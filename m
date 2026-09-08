Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B67A4C79FA0
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 09:32:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D39096B0099; Tue,  8 Sep 2026 05:32:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE33C6B009F; Tue,  8 Sep 2026 05:32:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD1806B00A0; Tue,  8 Sep 2026 05:32:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A3C4C6B0099
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 05:32:08 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 402571A04C4
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:32:08 +0000 (UTC)
X-FDA: 85190078736.06.B5BC975
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 84DA014000C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:32:06 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eSiHtrwW;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788859926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DZAjXyNzHlCjg0AhlziS+3C/RKN5/CeoTOOqdZq/ZDI=;
	b=U+yXtiRdA7kwE9azXr96pdfGVUy6eUqGdw7TvVI6Z9rLStYAXCxHqWWdj1pgQl8jUjNj+E
	oVGifLWYqKpznr3CIlmiW07spOnQks+IGuDdKGJHqU2mu3ltmv8MIeU1JXdJRFh81kwTpj
	f4oG3resy7R1F8nlfcXSCxHRCc7M9Nw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788859926;
	b=d9wz7UMwktswMZtYkxn/KNGnFUAYJaw6AF+d1/FTCBgmUoObprko1AjDLLVE90HagJvmOv
	lnGchUJo5UkwAFLxn5Siff3Dyhwhp8v2kyh93IDN/l+8aPcMJZo4dmfffKVVm7ZX2sbZxL
	kuJR7iEk4LofaRzKD0gKnkXa2l0YQW0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eSiHtrwW;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B5E1960A98;
	Tue,  8 Sep 2026 09:32:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C23FB1F00A3A;
	Tue,  8 Sep 2026 09:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788859925;
	bh=DZAjXyNzHlCjg0AhlziS+3C/RKN5/CeoTOOqdZq/ZDI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eSiHtrwW3jRYSXPiUmwOiKfisZC0w2GGQuZST/Uxf79m4i19ogqSU5si61wFyLBxU
	 iOs3ZPwRe26jYRixxg4ZMIAztZqDjnbk4yHEb3/ZtztgUl0jc4BljiI9GObSI3LnJo
	 36JPADQksLGe/Nz0fdYJq6UgoGtbiO1zfkOV9briywY8rD6SXEMeo1zad+U+KwOTsj
	 fR/3/WCYtrhVRdMQ8JHYR6U2sOr9DiUX1cm513VV4BW90wNgarOeemi2ZCb/vdC/Eg
	 Yjf0/cMGLvRcGhuLrjkv4fl1W0lvag0j3yjhb+yiRprByAG6RuSS1Nrh0iZmhnHUYn
	 cG2NaDhaA2fGg==
Date: Tue, 8 Sep 2026 10:31:59 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: akpm@linux-foundation.org, david@kernel.org, riel@surriel.com, 
	liam@infradead.org, vbabka@kernel.org, harry@kernel.org, jannh@google.com, 
	lance.yang@linux.dev, minchan.kim@gmail.com, lwoodman@redhat.com, 
	kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, linux-mm@kvack.org, wangkefeng.wang@huawei.com, 
	sunnanyong@huawei.com
Subject: Re: [PATCH] mm/rmap: fix missing barrier between anon_vma init and
 vma->anon_vma publish
Message-ID: <ap_U6R5aMGdL6rly@gremlin>
References: <20260905061820.642437-1-tujinjiang@huawei.com>
 <ap6ybQeSg_rrmC95@gremlin>
 <cb602c85-ad10-426b-8edd-cf9684c51749@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cb602c85-ad10-426b-8edd-cf9684c51749@huawei.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 84DA014000C
X-Stat-Signature: bbfq5hebf71rybyymtue641uupuxo7y6
X-HE-Tag: 1788859926-742657
X-HE-Meta: U2FsdGVkX186rJoUrbX1IlCt1o8fdPZW7NllZ6wIDZqMm9TvoswqCz7yZu6IpXFUrZP/nrqe3+4tW8DcQv514VVG+GhU7MeKjy+5tlWcG0TiWgBKzlL9LTPjFekzYkgEC4kzwWpokraOqWKAwXxtK6+hxk+Uw4c2UvV2mRnRfCuwlAFK8PNcUzkDJQfLyaM0bE5j3ZXosvUSDKNsG3JMQwkdO4lLHWiTTrUkoaQLW+d9HJalM65ZaxmCpkC+QfRdoVBeJ/+TWFiBt3e66taAK0OyOT8VESznSWXrPwk4+L63KkMuM6l67saOXpz9/d72WodlOxSJH4QGYIrngZmyhLaUobMvDiB6d/ODk0j88nkUWijoIbjT9K3h380kZ6WUrozp6BODBi+eSK9tE3wPDp2cMk3QzuPWZBnLCwc9yxQLCke9tWE+MhAXTO02gTz/dZImqHcr5RwqEf1F9KyJX7j+ZL6iDbZovgNasnz5tLGwx5OX36XskxqbHCsfJwFi/VX47q3Gby9xnJslRlRGXYKdXtybsx7elvPqrMo+JTMkuH5y4w5CAjsgxrSVZrbm8KcCNtPEXD89AzoCHXPAJmPMSWFFX+qiGIDGaFZ1KAPTo4V3Zwxb0n2k2Lxz8Y6hPqspBZxmcC0aJ2yNupS9qjwRe6vB0Mjilg77+vRWPHpexCIQaMaNNm0Xaci/gVRcsYa8aTvlhWEXEjFbqpmEn6U6IDGSxFknYsM3qLT4p36kTjlP2qdF0Swp2+PATIhtln0RWc84kTN8dxBZDZQiJndjq3ICx1ulkOoH45fKt7Y5IOhO3+myqjIKvVbgTYmZrJpmqXGEcLI4AGCrtUSfMvah+if2i0/Ogb5iySqsrOe6TNdSHA/z4ITRO/88U8s443svUohTeaWhLSJVyueHFqzha01p1WnfiG4ggwzApfqVv5Qta5chVU9G897cC7I4lkY88+3pT+k2hGqaUiq
 9/dNHFEf
 RlwobJ0zoAOpcSqK+rUC00j0kBrXnrnlYx3UzNqkqbPtaMq+C/ZfihCq70FSWAcqQiQPaCfAClxmqCtUAaQvt+pMvlzoC9zCWlkwd8yAj2AaU/JFZr0Bsy80USMmIzAGG+r6YT1h/bbyXAn9Evj9PTm+Mlnwp0uxyEDY9jx067Fh/b7qBNl+kFY5mUOeCr1ercW9AmRLeEOPYY4VEbIa387kBa/zXxnP4T6604zaoB8JQnvrmR77aTsqitYaRpEQo0u1zwK/hjIpCm1Ovqu47xqXpH6K1sjeqLFfsQA9f6ZCV1xH+drrMIdgzQNtjGhKi0cdWIbA8VqtXWv7RE4d5Dqjmd+pPBUd17iIRcsi1b+kJvxW7dDFJAM+KJ3p/VKpv+R5Fhro1Jksob8s7vJkqSNujMIHS7N9uGvaVdO++atFgQws=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 08, 2026 at 10:48:29AM +0800, Jinjiang Tu wrote:
>
> 在 2026/9/7 21:52, Lorenzo Stoakes (ARM) 写道:

> >
> > > Without this fix, our production environment could reproduce this issue
> > > about 2-5 times each month. After adding a smp_mb() before
> > > anon_vma_lock_write(anon_vma) in __anon_vma_prepare(), which is different
> > > to this patch, this issue hasn't be reproduced for one month.
> > I don't see how the smp_mb() would make any difference there, I wonder if
> > you just reduced the race window?
>
> When troubleshooting this issue, we suspected it was a memory barrier problem,
> so we added a full memory barrier like below.
>
> diff --git a/mm/rmap.c b/mm/rmap.c
> index d1819fd69938..11203f381beb 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -205,6 +205,8 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
>                 allocated = anon_vma;
>         }
> +       smp_mb();
> +
>         anon_vma_lock_write(anon_vma);
>         /* page_table_lock to protect against threads */
>         spin_lock(&mm->page_table_lock);
>
>
> smp_mb() ensures that all prior loads and stores are completed
> before any subsequent loads and stores, has stricter semantics
> than smp_store_release().
>
> I used the strongest smp_mb() barrier to test in the production
> environment to confirm whether the issue was related to memory
> barriers, and to avoid falsely concluding that it wasn't a memory
> barrier issue due to the incorrect use of a weaker barrier.

Ah OK I misunderstood this (memory barriers make this easy :) so this therefore
means you've confirmed the bug fix also, as the release version is definitely
correct (I analysed it through in my reply manually and ran it through a bunch
of AI checks also to be sure).

Nice then :)

>
> > > Cc: stable@vger.kernel.org
> > > Fixes: 5c341ee1dfc8 ("mm: track the root (oldest) anon_vma")
> > I do wonder if something more recent made this at least more possible.
> >
> > A decade and a half without it being caught before seems... unlikely :)
> >
> > I wonder if the VMA locks made this more possible by (significantly)
> > increasing the ability for racing faults to occur (no mmap read lock
> > required).
>
> I mentioned it in the commit message, maybe you missed it.
>
> "We reproduced this issue in v5.10 with KSM enabled. The kernel
> doesn't merge commit cf7e7a3503df ("mm: prevent KSM from breaking
> VMA merging for new VMAs"), so there are many adjacent VMAs that
> aren't merged but are compatible for anon_vma."

Ahh ok interesting.

I do wonder if that is a better Fixes target then? But at the same time,
technically, I guess the old commit is the right one.

So yeah I think let's keep it as you've specified.

> Thanks for review. Will update the commit message and comments in v2.

Great thanks!

--
Cheers, Lorenzo

