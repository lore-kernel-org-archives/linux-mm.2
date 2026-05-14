Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE091CD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 12:05:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB66B6B0088; Thu, 14 May 2026 08:05:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3FFA6B008A; Thu, 14 May 2026 08:05:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2EA56B008C; Thu, 14 May 2026 08:05:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id ADAB06B0088
	for <linux-mm@kvack.org>; Thu, 14 May 2026 08:05:47 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5F77AA0496
	for <linux-mm@kvack.org>; Thu, 14 May 2026 12:05:47 +0000 (UTC)
X-FDA: 84765896334.17.55169F2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id C8612100009
	for <linux-mm@kvack.org>; Thu, 14 May 2026 12:05:45 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nxRKoaYK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778760345; a=rsa-sha256;
	cv=none;
	b=LbF7gCAOFtrFdLGJRcOA+9JigpLUwE+EYdZ9C4mx9WKh3s3NKaOdGDtVv3CHUs0vX6kO/a
	/nOgjW4oGSHOig8x74heaw5nKH+Wkg21lCV7vwiDbN/0p3k8VMDJW48v8FgTw+bVbnrf8d
	wNuqWof4NOqmKumZJLmPWFQdN0ZLvQc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nxRKoaYK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778760345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u2IRkJIdNc5n6d1Pp3C/BA15PO/LGXnhPRWXps/pwmg=;
	b=utJBKP9xts83oSnF4Er2HdAZDYq4Sub4oEFffztTgaNQzEuTDdVTjPqC/6Nn7U1nx8OXyO
	4nWGofQuwGCAYpfIOlWjMKzMOQweBXsYG6DP7zAREseb8HvCNnL4e8aNpu/HEPDuL5wP0e
	mVHje9LXDeNbfKFc+jDgIFIeTBqgJoM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2570060008;
	Thu, 14 May 2026 12:05:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D93FEC2BCB3;
	Thu, 14 May 2026 12:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778760344;
	bh=u2IRkJIdNc5n6d1Pp3C/BA15PO/LGXnhPRWXps/pwmg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nxRKoaYK4eb8EtfLemF99sX0W8F5Q5Zzhv/xs248Gkb8uEn22lQx0XrcKWLsXbKap
	 sxuBn6xhynodZu7VmgdMjdJVRbUghMc0ukfWQQhBWC+BJE9PH+jehjk5NwXHsKiEP6
	 EMJjXTkOU/Rci04u2vDXErI0Y+0VZG5+560G46UOBjWxw4OvpDXcsT2vgW7ZVj81J/
	 RJpAAHIp9PXHkZKZIzc5mxA5czKorSNi+fHoTwo4tHna34FARqTFbtzELsOGDpRnyu
	 GK5T4yebECPudPjUl3NBWV806tOuUkRXFEtLsejxHx/nKKV6tH17CS6ZNFDDnmQgjc
	 XKT53bC9lAhmQ==
Date: Thu, 14 May 2026 13:05:40 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: ranxiaokai627@163.com
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, hughd@google.com, 
	akpm@linux-foundation.org, leitao@debian.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, ran.xiaokai@zte.com.cn
Subject: Re: [PATCH v2 1/2] mm: huge_memory: refactor
 thpsize_shmem_enabled_store() with sysfs_match_string()
Message-ID: <agW6InXXostJnmwm@lucifer>
References: <20260513094508.50888-1-ranxiaokai627@163.com>
 <6d6b1949-fb11-4b05-a01a-9427019b3ae0@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d6b1949-fb11-4b05-a01a-9427019b3ae0@linux.alibaba.com>
X-Stat-Signature: w6fmzfrkcphsdi1qjy55kjnqpsmwr4x4
X-Rspam-User: 
X-Rspamd-Queue-Id: C8612100009
X-Rspamd-Server: rspam07
X-HE-Tag: 1778760345-958352
X-HE-Meta: U2FsdGVkX18UAj8wJu9kc88S2ZW72iwXRVzbhcFKcM8gklXqZblxHOWjmFMAjJggojmp3J3VJ7fYiNvT2XPDqlkCDgFT2hDWz9SWIoouBziqj3stA1BP00/nBl8HLOalovphZd912M7cIJvGJEZWGOkMHPwztXrpHAqQ1c5mVpfmngydq6h2jEoVeB+HeMtDjrKcdFdm3q2LSk1qAZGmyEcYvq5yhzl/sONFMiTjNAzjiNGQZyvxq+hEvW2gptr10BFAQ4lWRoIHykFvQ1bgs0I6bJEu/IgAr6n7ZeG/NWyruSlHhdQKnNSG10EVbnN5pvk20LbS+6SLTPtx1tw6k+ucuQpXWHijsJBz/L8SA3lzdYFjynUFqguXjyvZpNgkYilmtGYC+obWPDR4+g3+j/Id2jaB5JfewhM+IikEXG6hsQhY9d49xvkI0HOnGOdmkTxzDKIUyLLsVZTaBnr5g+OlpVAWyFNu5O8emxRplcuR7NEpRBnVUOm+mAu8VUCj5rLQZXO7181p6nOnAeFe2yOgkdhh2q51x4HcGbYGFC/hedyQ8Q5nrrvT6AUf7OwkLvbG5gCe6LOP7FHerQcQb7IkVFvGV4oC43uHoTnTFstvgcbrgGmwXC3AtrU6Tfrws87sBtRo+zYES55S16aSGa+hmung++B+GfMpQkVYhgNYwuGp7IV361lP7cWFdic2zDJETlOVA/ysnXQWcZOlHJ+Is5TAIo6h3Jmcot56KnxMedllKi7tRi7/JZJeWKeSMSD9JTCdqnozZDDPRmC+47plk9errqrWd1N5iNndkCZOrIJTLYYZd5CY035iXwrmrvXyUObQXIXV6BePmcW7vFbpwTkwQpUIzWkmWRQyHq+80MZGTjdgQAoAoTJ0Vaoxly3vnsZu3B0yZepSdKZIeeqYetMCyQR3nUOGSRxqJntUsrlJlFJO2GfiT4eLJUkSfGUaU+ppEQMmp0bG4VO
 KmlzXdTU
 2yYC4jv/KquLcvK8I7gjWOb9RVZ6XsUz3snPnUE7UGiE5ttiSqFnnADiiTs6lj3pCBtjEhavZGS+B8giQWTfer7aYF5ewyy9N/2m2pzy4soy6q/L5Qn2DrWzrCG+gYyLrwpKAWt7GpyhNwWzUppmMMWiZlgRT1Fjhp86Dba5W4Uj/l1jzEhGa8CqhO2sBDkPKIYkvdqDoRfTD007ohep16i0B2da/GTpRk1lsoZbRDjoqnpVajIBY/43qOrlWBvA3u5Wz2jZbkjN3LQt9jrckYP2JmDxlrt31uy9noLe4bbRxPlpkTyHgMU2cWITgAyAhn3szmBfn7fqYTVJnb/WWtlymm+fW1zzyVyXgKUeb8atypPwHiwwBQpUQSbp4rvJJuiGd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 14, 2026 at 10:36:34AM +0800, Baolin Wang wrote:
> The subject line should be: "mm: shmem: xxx"
>
> On 5/13/26 5:45 PM, ranxiaokai627@163.com wrote:
> > From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> >
> > Inspired by commit 82d9ff648c6c ("mm: huge_memory: refactor
> > anon_enabled_store() with set_anon_enabled_mode()"), refactor
> > thpsize_shmem_enabled_store() using sysfs_match_string().
> > This eliminates the duplicated spin_lock/unlock(), set/clear_bit(),
> > calls across all branches, reducing code duplication.
> >
> > Tested with selftests ./run_kselftest.sh -t mm:ksft_thp.sh,
> > all test cases passed.
> >
> > Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> > ---
>
> You should document your changes under the '---' for the new version, or
> ideally, include a cover letter describing them.

Well this should have been a cover letter anyway! :)

Ran - please don't send series with >1 patch with 2/2 in-reply-to 1/2, it's a
pain to deal with.

Send a cover letter if >1 patch and have both in-reply-to the cover letter.

Cheers, Lorenzo

