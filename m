Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67BD7F8E493
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 23:51:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54A7B6B0088; Thu, 16 Apr 2026 19:51:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D4396B0089; Thu, 16 Apr 2026 19:51:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39C226B008A; Thu, 16 Apr 2026 19:51:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 23B446B0088
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 19:51:11 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5DA6E8C9A8
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 23:51:10 +0000 (UTC)
X-FDA: 84666067500.13.E2783C8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id AE8661C000A
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 23:51:08 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Xf7kwT/1";
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776383468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MfCO0irWytOGHlDwN1MA2coEvZ8CMiTNXe+PBjIEJrQ=;
	b=00GA5TrjuwFVS6ZbuGqBGZP7Vf13GachtHL5rm/QUQAyjkTiAHNf+agaBmX4aLJT9RmxuK
	WTp63WMmrHChyE5w2JDl6yK/Jt9n0/vYa1XEDaNU6uuiLDKcWVt4LspxQ4Bc37rP9Q77pi
	Hnxy8AaXukU5PLKJVoPFGMLctes4YPk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Xf7kwT/1";
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776383468; a=rsa-sha256;
	cv=none;
	b=exlRLycilPpti3npdyDsNfdskXsKMjGXfEbCFC2ftTAq6ERcjmBh8mPHipAIKTjzAmkSa4
	HgKq+qswmFVYR7Rf7kg1chqfb4vK0xzy7SruuAwIeLQZd/zVUJXkBvUZoJ6XIFcoSEEH7e
	S28S0qyYPmtlzxGt0j4g5HACPi28Wnw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D8B3860128;
	Thu, 16 Apr 2026 23:51:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1471CC2BCAF;
	Thu, 16 Apr 2026 23:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776383467;
	bh=wTOVfHug79g8+nbILjm69mxMVmRi87HcrvZ9H4ZTYco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xf7kwT/1seW+bniYGSl6Ad5DBg847D3Pgrgy5fl5cCAAfMj9wVbAVrbt3x/EZFhbK
	 +xKKk/sBtj2dqGoh+8Cq4PV82gJdypZnAn1AzBfXHcKhgR90hx8Wyaa6KxKq4GEDgu
	 iCWCCItKbw2gjjF0mxJyME849CZKXO/ZZPHPRd5ncZ0PKUHOsALY0TMDjWKFW3rA+t
	 v7aQQQqbNfYoEflJTjZfLNpGrt7t2/fxS1agXijs6ceFa2hw8/fKd5RV2VeXSxhpb0
	 rId5IaltXmYYgovviWZgZaVHWTVBMb9p+RiaT4iYp64RLoS1bHO1GOdbjI2eAf1XqI
	 kG37RxGrpduyA==
From: SeongJae Park <sj@kernel.org>
To: Sunny Patel <nueralspacetech@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/migrate_device: Cleanup up PMD Checks and warnings
Date: Thu, 16 Apr 2026 16:50:59 -0700
Message-ID: <20260416235059.58706-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260414141344.29949-1-nueralspacetech@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fgy4u9doowb3g3biu57ed14i11sc7d36
X-Rspamd-Queue-Id: AE8661C000A
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776383468-102861
X-HE-Meta: U2FsdGVkX1874YG8+/bqFDLe0CphqXiKCiNg0ip1GM+pGoLbmW74wCA9pit8T8i08Kpbl23wpK8Ko1iiIJMVxchMPfgIxoA5Gu17EC3CShtW2aCrjoIB+uaxycNQznu2+kZhF8jqHJUbLfrckngMi5jKQXwmVyqPxLmvsfPcnE+F0YpMvbu6g8Dh1X5igI4v5qKvZSmfkl5KJXunFOWv0t8V41AGjOArAeYLsSTpB36hNLF1WC9NegByGEu3/TimMWCKkDn9JUlaCvqDNXq60wWabLP9bbV+MMBuweIDgZVY+VFzbl6RBb7zYPLuGFYlSAn830+TISc5U1gACgSRNTm+FjCve7J2+c4Vw1SiF74bRroi+Cr68yQo/ksF6DpERM9e6w9mzPLkN1Jagg5Ds8czyOaaLLfu7jDTpdgich9FvUUFehrUnWobOwK1D6Db4EAn+/J9xGW5wgI7+wIPyApDwhhWKqVrvPV16m8fkklDFF0USCc7waPZIRkvKVpYRhxE+llJ4krzZkhG8GQO4OyleNREVOI8RWjEqfQIw7z52w6jHQjfJ4qVP2lHwgdfbF+GFUothL9Ieofv7LtZHcjcqJEa/qV1CiM3I4U27WnGL5ivCporUAlTsDbTQhEqJsQmTdalD+qD0CcfmazwWVD+JLOf6xGyWQ67qFOe+KBS8/IbW/Cf2ERKocivyyvVUw5KXfR3mZVpV/nftisBgquROqy2xiklEZwmSQf8841LJbO37MtNOcunPQGQkvA5pLbj5hQe2fDv0lvnSeEIjWjjy8MaoZhxfi0pXPk1XkO42Wwo1xw+Z7gaHYyxZKqGovBBVI+piGwep3j8MIY4jTiami7W2yIhzbmKcC2eQKizG4b8AcfTYEmpddTIcQy8emuA+Gx6kM/Sc4kESOhjbHJ5Tk6121D5MyyeV+2Da8ztu/1JozZt0M4ed4QbCHoChhWFqH94fxP/yWleUWm
 pTshJbB7
 t+W2qngg3vy0xexjdHM5V404kBDMKxdMxyI6WDpWEp46yrl6PerwpAWgwKH5lnROymq0a6QgfnCF90YR9l5xF9iJ/GB8JYNj2RkjqPYS4r389gh2+CDjMraPSTF2RAlcexIZbyOf5QBTCBlaZCuZGKF2ZRQQUI6ejVOLeGrjUv67KumA/OFAl2KDl5v9YFV0n4WWKM5ymsguhEMw+cylTQmukqZt628BcQ5QPzcTjEjWMoSWIGKauaSYR3wlbG00xDGYfJtEEiBR3G43A/toNc205tn42P81G2xI5EkOufiKtC3y2sPviNDhHs8WUkVAbIWVvsq7Y18uZ1IQWM3T32H8DtMhuUu/r5Pgr63MbkU7i6yM5d0jGF7esb8uDZNGbNu1QTLODah0F/Ws=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 14 Apr 2026 19:43:38 +0530 Sunny Patel <nueralspacetech@gmail.com> wrote:

> Remove the odd VM_WARN_ON_FOLIO(!folio, folio) usage and replace it
> with a simpler VM_WARN_ON_ONCE(!folio) check.
> 
> Drop the redundant VM_WARN_ON_ONCE(!pmd_none(*pmdp) &&
> !is_huge_zero_pmd(*pmdp)).
> 
> Refactor the PMD checks to use pmd_present(), making the control flow
> clearer and avoiding duplicate condition checks.
> 
> Signed-off-by: Sunny Patel <nueralspacetech@gmail.com>

Acked-by: SeongJae Park <sj@kernel.org>

[...]
> @@ -865,12 +864,13 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
>  	if (userfaultfd_missing(vma))
>  		goto unlock_abort;
>  
> -	if (!pmd_none(*pmdp)) {
> +	if (pmd_present(*pmdp)) {
>  		if (!is_huge_zero_pmd(*pmdp))
>  			goto unlock_abort;
>  		flush = true;
> -	} else if (!pmd_none(*pmdp))
> +	} else if (!pmd_none(*pmdp)) {
>  		goto unlock_abort;
> +	}

I like this coding style [1] fix.

[1] https://docs.kernel.org/process/coding-style.html#placing-braces-and-spaces


Thanks,
SJ

[...]

