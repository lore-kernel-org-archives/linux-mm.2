Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AECE5606A31D
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 23:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=0xYKEwSB
Received: by kanga.kvack.org (Postfix)
	id CA7EB6B0276; Wed, 21 Oct 2026 19:59:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C80136B07FC; Wed, 21 Oct 2026 19:59:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBC846B07FE; Wed, 21 Oct 2026 19:59:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9665D6B0276
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 19:59:23 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 918898049A
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 23:59:21 +0000 (UTC)
X-FDA: 85348302522.02.0A94376
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id C7257C0005
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 23:59:19 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=0xYKEwSB;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792627159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ksEI+I5nWbgBGU6Al2imyLpHdZLmo2q8PfxF1UceYPU=;
	b=BZbLMAIG4Hv27zQQAXvjG7WXhbShdO76SlJFftxKV6u8h+fGSjASdVji+t705vrMEZEE0C
	1Cqe0ECQsQm5s8yKnexIAM2doRXGcJWCxNXgjioebg0MUPrihzb3Uayuj3KP+Z7XeoNb2H
	f93mQNqciiNfx41wS54zmRXgamR8LXk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=0xYKEwSB;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792627159;
	b=8mTRjwHdOErTA7KXlkOLBdV2xBkcYCGvhEIfXfg9dLVCjboRU4tWRX4lSZN4lSbVsSVjF9
	nWNalUBILzxgGfyraI3JfLcHMsLXE4MNewHol45aGE05Qzx9onaksPv1fgPvkZYM/lMppY
	4L7vcVahzfRkg7QIMinW56eoMbFmON8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3D4FB601DE;
	Wed, 21 Oct 2026 23:59:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C0F11F000C1;
	Wed, 21 Oct 2026 23:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792627158;
	bh=ksEI+I5nWbgBGU6Al2imyLpHdZLmo2q8PfxF1UceYPU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=0xYKEwSBu66dnnJ9HcvJasewpGZc84uS97nT6nqlUpEiIGU4UO4F9Yx5Lpy95VaXw
	 bT5j8IbaUvNr7+0bTwVoQv+E0xBT/Uccgz3hCrqURvefxtS8IxXKoE4D/qvgV3JtrJ
	 xXtcvhf2Cvz4ppddQdBQ+/CgxdCgSlx+zS5UQNKw=
Date: Wed, 21 Oct 2026 16:59:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hongfu Li <hongfu.li@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>, Vivek Kasireddy
 <vivek.kasireddy@intel.com>, Steve Sistare <steven.sistare@oracle.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Hongfu Li
 <lihongfu@kylinos.cn>, stable@vger.kernel.org, Daehyeon Ko
 <4ncienth@gmail.com>
Subject: Re: [PATCH] mm/hugetlb: charge hugetlb cgroup and memcg in
 alloc_hugetlb_folio_reserve()
Message-Id: <20261021165918.da553bb0879c110847c232f5@linux-foundation.org>
In-Reply-To: <20261020-for-alloc_hugetlb-1020-v1-1-e6eac82dd754@kylinos.cn>
References: <20261020-for-alloc_hugetlb-1020-v1-1-e6eac82dd754@kylinos.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C7257C0005
X-Stat-Signature: 8t7uqpku85aqwc4ysqscky1roxqd818o
X-Rspam-User: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792627159-871599
X-HE-Meta: U2FsdGVkX1/5eQhb0yIHLfRsFzEWdIlOI6pa84/i7ki1SIDg4FiBNyy2WKbXXDmASYn3fzwroXIbB87avJL8LO5VQ30lwxifqBlnfSyAhn/qmHmkW+cj2PVIwk/kY8I4kDWhiE0Usfcre2Z6OUWQxTTI8I0A0sxMdJQegKTJ9f3g3hbbw207tRjci/CDN/w080i2nnrn7ENl4mJXjN0EBC9YbNcCtO/LN3ycFAi0dyoCriFYsQOaQx053XtkStz4VtlxrMVJ+pzpdLZaPPHKt885JVBJUOFmBLU7yy82y2KBAX2X/V++N2HS6a7qs0reo8UIEFsP0aqdOISMHCER0bEZwYVkF04D6tq+wtJ7K7yeOPWa27I6w1dfZFRmua/Fm658Uyf2aduP4S4a7A74/McuNe8mwoUfmKZw6R6dpfvRSeOtgs7LOafEPW4/hCh2LxTd421fkAw6zvQTGWo2fmBJxK5BltDyJ75nzRfrExzuC4Jbl8J8BQTBeJPY5Z7Gk1B7uIknma8GKLdouXD5aFDgQ+mMkeenoBhLT8bMA3I3pDBqFtk9h7hD6SEzONLpqYEHJEAV8+4WrYp3vzTNwYTz6pUGGC3cDb3Gfw7U3ZQxw4NSZyNpV+9lRidNze/U6BcyW15eYF044Gpbh5rgVlVSn7+Ucv8K5QCRYlqL4DNLnIkFTphm56cAPEBXeX6bi+dbkheBM++DD/kEFcy9xHk9P+FO3OKJ5X3lbFFTTyjODEk6XhzdQBNCjISprdjBzKZUV//1nGYoWzJptYtMYn473t1R9LJLIRmV1eHidHEQoZre3LPPLCqgfmN+uDczSyzrw6w54bXE2mMFaEzg9FgcW90+nXO5XuIhdjeuVTS3flp65tVNl5As3/vJ/3DQesW3P/m+KOXbOzKh1U6nFidrtfYXVbdghhFI7uFtKFaXMVUu+pv/+mFh3n+d9M/3KWB8QQ2TLo9+UMfUSjk
 qhHz1Tid
 2aC8OznhtkgZt9RXNYZaag3nNSOd/hrK9YwqwYBT50juVDwEXYMplKDy/EJYuZ27wLHM2yX6Za7nfHt+Sqe+fRq0iyh9vdN8MSg846YMDQx6mLCy3euoac/P6c/ExvXusFymSmbs3MIC0AS+HWFmdA3rhO7QKSvHVxL4j9WOpNwZzquaqNjb3h3NHjuVzMh5o6htInu7I0KHYP2bBfDF2LaDPIOT4sDVvzPuSm0hZTrhZrecQLsuVSVwPAPO7csJ13CZrmkpQ+fOua1Xj1K5xz/d2X/idTkNZNC6zIGVN/fVGioacmO5QDzBR0pO670Yw+29BoVVApcJQP9YzD1+Fiq2jYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 20 Oct 2026 16:46:30 +0800 Hongfu Li <hongfu.li@linux.dev> wrote:

> From: Hongfu Li <lihongfu@kylinos.cn>
> 
> alloc_hugetlb_folio_reserve() hands out a folio from the hugetlb pool and
> consumes a global reservation, but unlike the fault path it never charged
> the folio to the hugetlb cgroup or to the memcg.  Folios allocated for
> memfd_pin_folios() through memfd_alloc_folio() were therefore silently
> bypassing the accounting: they are never charged to the hugetlb cgroup
> usage counter (hugetlb.<size>.current) nor to the memcg (memory.current),
> so both limits (hugetlb.<size>.max, memory.max) are bypassed.
> 
> Charge the folios to both the hugetlb cgroup and the memcg, just like
> hugetlb_alloc_folio() does.
> 
> Test with a process that creates a hugetlb memfd and pins pages through
> UDMABUF_CREATE. The counters were read while the folio was still pinned:
> 
> Before this patch:
> $ echo $$ > /sys/fs/cgroup/test/cgroup.procs
> $ ./memfd-alloc-folio 1 &
> $ cat /sys/fs/cgroup/test/hugetlb.2MB.current
> 0
> $ cat /sys/fs/cgroup/test/memory.current
> 1351680
> $
> 
> After this patch:
> $ echo $$ > /sys/fs/cgroup/test/cgroup.procs
> $ ./memfd-alloc-folio 1 &
> $ cat /sys/fs/cgroup/test/hugetlb.2MB.current
> 2097152
> $ cat /sys/fs/cgroup/test/memory.current
> 3313664
> $

Thanks.  The before-and-after output is useful.

However there are potential interactions with Daehyeon Ko's
"mm/hugetlb_cgroup: prevent use-after-free during cgroup offlining". 
https://lore.kernel.org/20261020100345.1677643-1-4ncienth@gmail.com

Your patch adds another caller of hugetlb_cgroup_charge_cgroup(), which
has the cgroup-offlining CSS lifetime race addressed by Daehyeon Ko's
fix.

An existing memfd reservation can belong to cgroup A while the task
pinning the folio belongs to cgroup B. A's reservation CSS reference
does not protect B's usage CSS across charge and commit.

Also, the accounting bypass predates 26a8ea80929c.  The original
memfd_pin_folios() implementation already used an uncharged allocator,
so the Fixes tag should reference 89c1905d9c14 instead.

The memory.max claim should be qualified: HugeTLB accounting in memcg
is conditional on the cgroup v2 hierarchy's accounting configuration.

Daehyeon's fix is in the pipeline at present, awaiting a minor fixup
and maintainer review.  Everything is rather swamped at present.

So please assume that Daehyeon's fix is present and rethink your fix on
top of that?


