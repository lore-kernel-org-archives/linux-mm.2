Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD6F7F53D65
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 15:14:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A21C6B02D9; Mon, 16 Mar 2026 11:14:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17A9E6B02DA; Mon, 16 Mar 2026 11:14:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A75C6B02DB; Mon, 16 Mar 2026 11:14:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E976B6B02D9
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 11:14:03 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8C58357B53
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 15:14:03 +0000 (UTC)
X-FDA: 84552271566.01.6CC1932
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 027D4A0006
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 15:14:01 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ko3GXsts;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773674042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t6AGk77xJSNsVs/V0kQXWe4rl/ceV7DcqmaDWn7Zizs=;
	b=KdHVFfWSc/bRt9RjoBGwbr1oXCrYSN9LmBobqUhKrER2bas72xrq0yxS3/6VHdVTOp4EmR
	WdLeyAHlm3C7M1wYTb0Wib+UGlLMeTjgdn3U4Z6StskLWmIrwXHArPzlUwUirDIJXM4S2d
	naSYOVhoSsSTZqHy9LGbty5FsMtJv6g=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ko3GXsts;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773674042; a=rsa-sha256;
	cv=none;
	b=NW54ClNOSJplJ9dSNHU8gez/Yau4f+060iNvzQ7z7khsiz2NbaRTYtdOJ5PUUs7ru9PlB3
	ODIyl9OEiTx+FWBPlQHlOzd54fTnQiFEg6cjIHxN1aQoetsQa85AG3/JEsmWUDI5uvwC+8
	C7/0AqoTI/E8OIsUqrVhsIbtgKvBBMw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5CB8660018;
	Mon, 16 Mar 2026 15:14:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D488C19421;
	Mon, 16 Mar 2026 15:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773674041;
	bh=bB17RaP+sGJYjZOD4hRJTM0tiGwcoxMhkY2sJcw5ves=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ko3GXstsM7IxbccEWEVNpJtIUBpqwxPArXm3YDYSnQC5oQ+CoOMRS6TLtPunJCGOL
	 kMjaKrnvz3LzF/qU1/7j9hXCoOrjU8WMFo5D4dpZPeDKz29YkicMxJ+23W9QBb222Z
	 opWK88iI0M1fc5YhIksujtt6TKMzk2viiuT2MgoBq6XUS72X4DTFnjrAOp5c66KhT5
	 +rJvaUrp5WZPB/Rd6rSqc+xKQDorBFUyreXDJc/86GviYeLj5jQdNlr+ixJ0UYjJB9
	 f8RXg3oH8xuCxFSagTkGm8j+to/KHa/zJfihhtUxLTELwpT8lGpoyGIUsr8pJ1PwN8
	 Y2cJxkNGqJlIg==
From: SeongJae Park <sj@kernel.org>
To: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
Cc: SeongJae Park <sj@kernel.org>,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com,
	wangkefeng.wang@huawei.com,
	yanquanmin1@huawei.com,
	zuoze1@huawei.com,
	damon@lists.linux.dev,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/1] Docs/mm/damon: Document DAMON actions when TRANSPARENT_HUGEPAGE is off
Date: Mon, 16 Mar 2026 08:13:52 -0700
Message-ID: <20260316151353.100406-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <224a29a1-13cb-41aa-8736-aebe1023fb7d@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 027D4A0006
X-Rspamd-Server: rspam07
X-Stat-Signature: 3tk59ym4qrb6rr64t9f4p3syqoh95wed
X-Rspam-User: 
X-HE-Tag: 1773674041-497254
X-HE-Meta: U2FsdGVkX191QgLXD0DII26yr9w40wU2UXWdarbMubDPCaLocuEaiP3V/mr6YfG86QfYpatsZfnQ1JNjrnv1Xr95OlCjT9yDG5Dq7a+mnamXg8EivAKFcK3oIiVLS1surydmzLiprthMZtodpVxyIXq4zKPMPzFAS2MQztRF1jlWBrLq3f8+cRW8vlulcrofHjUWCUuOOMwZ/b0faPeo5TbgmU3cBHYltt8NKKnCNw2VxvHARP1od+IQ3CjQjKw75puVMvoFBPJpNyuF0foaC1tV35eyuKa5BiJVZXQuNxBh4M4HAjsWpR3hPd0yogly+eFoCJJjXmNoK9rrUgEmE8zB2duocjGaIFEAuA24qEUo12EBlCQXf1RClhQQJ2hE/8XK+nf9myumvJ/uUrOldpETGQLQofx9+nNpfnXPPGSg13IAhBeQGq9257u4q988LUDRAOF9aHTmGaj2wKn0TqdiqGygX2quM57KeHvbLjKOXzSAR5s+0F5WW058YYbTTGssDZdG3UjfljPUw8dhDVoTbXAOxUoh/ntcuPxhrUlWWXJ4iFVoLSZZ3PTDY/P0yJAiD1kN4rJzsJL9Og6FNYJW5Ec7SlhP8vuzNMfL3ugbtIrxZJ6R5pSTtXEPVAquS7wmmiup1qTijGuGT/nHlDVqR0bRZ+3BZBTE1EHbYGhjLF/AfI8oJDOP0e0c8MSb7ztK+G/msjM421wcOz/oJdmdg+RafXjkb4FdpdbyDoW5aNU3PDJE5PXgXXCiPYHd2MxwQ/NdUfzjXJUSt+SiWY12qNvAzT+NHUmPNeX5WinPzwN96xTbdH4QCJSJ7hR8FkbKgG0nHkFm8qtPsf3zskQXlX8tD0Cz3PDHpcEyOGAxKowFr8MurWfSTWSKNyqb4naZR/P9y4TmcKIocOphUwTFjnWvJeBjCgZqDUSH/7gnpFk8ejQG6ayKzroA4VO6rjGOwiSk0eb1uLMwbV5
 3GkNeugv
 xgb7sz2q00vrRey8M9RCPDnGHzrxTyMJoJ7LTwUv94rVI18Je35EKcXPyE7ddYZc6kM+xAyH1FrVnx/wP9sP/qxQ93zSLxOX/0OX1wap2BBWU45eNp/x278O5hHvjcPYMjAShCLeez4h2LyvOh3tOAzayVEvvzTIxIuEM7RIZvzYedgVwF8sQ83Hbe1burNmhLWgbF8Io6KW8sI8hWo57NRGp3s6b3aKNc/9pN04CZJtx/+l+Fv+dGUoi7ibgJOkt0jq+/k6vqbbDZDFCbdRrMlmlXf/EWUnBHDKTI/HagqqtOv9jsEF691DhUUAO88YaCUaH5hie1yM3OxHEOPHLCfWaZg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 16 Mar 2026 17:56:55 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:

> Hi SJ,
> 
> On 3/16/2026 5:48 PM, SeongJae Park wrote:
> > Hello Asier,
> > 
> > 
> > Thank you for sending this patch. :)
> > 
> > On Mon, 16 Mar 2026 14:08:21 +0000 <gutierrez.asier@huawei-partners.com> wrote:
> > 
> >> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> >>
> >> MADV_HUGEPAGE and MADV_NOHUGEPAGE are guarded and they
> >> are not available when compiling the kernel without TRANSPARENT_HUGEPAGE
> >> option. The DAMON behaviour is to silently fail[1] in when DAMOS_HUGEPAGE or
> > 
> > checkpatch.pl shows a warning for the above line:
> > 
> >     WARNING: Prefer a maximum 75 chars per line (possible unwrapped commit description?)
> >     #12:
> >     option. The DAMON behaviour is to silently fail[1] in when DAMOS_HUGEPAGE or
> 
> Yes, this is due to the link. I tried to keep this patch compact, without a
> cover letter. I will submit a new version without the link.

The above warning is not for the link.  After wrapping the line, however,
checkpatch does warn the link line like below.

    WARNING: Prefer a maximum 75 chars per line (possible unwrapped commit description?)
    #13:
    [1]: https://lore.kernel.org/damon/66131775-180b-4b9f-b7ce-61a3e077b6e6@huawei-partners.com/T/#m278d3c9bbedcceaf2efa51e3dc7b40a40654e51c

But, it should be ok to just ignore the warning for the link line.  So, please
wrap the line, but keep the link.


Thanks,
SJ

[...]

