Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00535CD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 07:51:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50B776B008C; Thu, 14 May 2026 03:51:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BC976B0092; Thu, 14 May 2026 03:51:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AB746B0093; Thu, 14 May 2026 03:51:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2A80B6B008C
	for <linux-mm@kvack.org>; Thu, 14 May 2026 03:51:19 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C29EFC1F69
	for <linux-mm@kvack.org>; Thu, 14 May 2026 07:51:18 +0000 (UTC)
X-FDA: 84765255036.20.5564CC6
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7BA27100011
	for <linux-mm@kvack.org>; Thu, 14 May 2026 07:51:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=mRn3LvCp;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=AQKHof5U;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=mRn3LvCp;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=AQKHof5U;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf14.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778745076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e0oLzGvgjo+kkPs6eVlVX1mjY7PmbLR+my7KbcNIqtE=;
	b=ms8Q538AZCoh0oD5ILjAOTKU9wSR0IGs9f+NtjnrcsjlF+vYAKpo1Ja0drAXwZF8t415ZE
	ZHI0n3hsW/wSPScq/3DCC1fIuOttMEBVUUOcPoYZoecIEW94BdACSze9az985djJGyfmXH
	2jGy2DHB8xiOpqt9gFpMMdTTKl1vQ5U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778745076; a=rsa-sha256;
	cv=none;
	b=t3cUHgmMsUwDK1zIEgINJhPpnAEYNVaOHifUArntcB/C7xvnPkaXWZlTNEjKIuPFJT/gi7
	0+tUS+tNvwNUgc0IphgHMNrT6lP+epE72B2JP6R5ECOz/Rp7F8pLRTRAjYM7JvDkIbQyAe
	og8lIOsWuLf9EItVjIUpZ1GRJbyb9ck=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=mRn3LvCp;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=AQKHof5U;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=mRn3LvCp;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=AQKHof5U;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf14.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B3AA55E07E;
	Thu, 14 May 2026 07:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778745074; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e0oLzGvgjo+kkPs6eVlVX1mjY7PmbLR+my7KbcNIqtE=;
	b=mRn3LvCpWJvBTMoC8izGim1Rfz+aMKrO/0XhfY89fgfgFZbQpOuVOWAddvHYEkA7+LKJo5
	yCDRPKWakhGuIALgkP8CJljL6IaO4c9ke7cC4kzMQNXFVk5dx95HxNDIVzB+FvAy7wLM56
	Q9JDc7bSagTNpctJ2xOKh87bIB9lYiQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778745074;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e0oLzGvgjo+kkPs6eVlVX1mjY7PmbLR+my7KbcNIqtE=;
	b=AQKHof5ULOD+6FSayUgMnMQ6mQXXktxN2vWkvdgWNvc+G23XX4cakwhKHUrvTZ1U+XMCqZ
	duisf5E59H58eOBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778745074; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e0oLzGvgjo+kkPs6eVlVX1mjY7PmbLR+my7KbcNIqtE=;
	b=mRn3LvCpWJvBTMoC8izGim1Rfz+aMKrO/0XhfY89fgfgFZbQpOuVOWAddvHYEkA7+LKJo5
	yCDRPKWakhGuIALgkP8CJljL6IaO4c9ke7cC4kzMQNXFVk5dx95HxNDIVzB+FvAy7wLM56
	Q9JDc7bSagTNpctJ2xOKh87bIB9lYiQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778745074;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e0oLzGvgjo+kkPs6eVlVX1mjY7PmbLR+my7KbcNIqtE=;
	b=AQKHof5ULOD+6FSayUgMnMQ6mQXXktxN2vWkvdgWNvc+G23XX4cakwhKHUrvTZ1U+XMCqZ
	duisf5E59H58eOBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D89C3593A9;
	Thu, 14 May 2026 07:51:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kLHKMvF+BWpSBQAAD6G6ig
	(envelope-from <osalvador@suse.de>); Thu, 14 May 2026 07:51:13 +0000
Date: Thu, 14 May 2026 09:51:12 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Frank van der Linden <fvdl@google.com>, aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 01/69] mm/hugetlb: Fix boot panic with CONFIG_DEBUG_VM
 and HVO bootmem pages
Message-ID: <agV-8Ng-E0tZ9G5k@localhost.localdomain>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
 <20260513130542.35604-2-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513130542.35604-2-songmuchun@bytedance.com>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Queue-Id: 7BA27100011
X-Rspamd-Server: rspam04
X-Stat-Signature: b9wynpyfoe6kf6pmq9gh69ezjqrwyci6
X-HE-Tag: 1778745076-464668
X-HE-Meta: U2FsdGVkX1+gsva80VOjgvk5xey3QTaIpaloHRbvBZmggxWWWbn0EXuGMFNcqppD/DqpXrJcP1thyGudamgkwpfG2bhK54fjGhNDxK2yEwLPDfpqenxznGlmoY3f5AwdhCHrD/fh/IOyMHHOZ9xxOndy66ZRxRHGlOkm/FVa+r9i+4QqokUm8W/AeHk+xA3G2+2hlKJuRDar2QMiATiV0ywFrqvS5P3/dLQhcf3PUqKUZ3EXHTvxkuGpxUjm0CTc/0eMSjKr2yLJjHMvfF0M4u3sl8avJzlNyZSV0t2/11EodQxnzgF8KZCiSeQNpcHFGdwe5fNx1AJvOX4BIYCh3pN/B5Fd6LfltmeCTf0kU93cOf8YoOfUsnA77rTZBHW+KqZxknRIOfSQje5Xhzycux80n7TkeJ3RYbWU6ExBByS+v0FcGjbIUERfQeVZhiAg9fAcLjsPQ9Cm7gqnv8lwT1BTkHFWcs3RPl0xG0pF5mUYC5GQ9YP8OC9Je41Sfx+jNZj2UE0jle/ldPta2aV+r2hFP9b3jYAj7VqH5T5cXG5+owUQ6QT4XCyO9FMLay3eTHMh5uMy+jqG5BXEi1V3X/KfbMF0IqRoJt4+sbkRviZbKkcxHrQeWIaS1h+VBVx6O4Y5ObPYZeMHo0X2oYXFvGdTXcJNdrRFizDfJx99ysV+ae1LvNZLDAjGJe2tDShGwHhn3GBL9HyROQSoTFh7Taj84A+pZvZjlxZUDaYsXb7i8Zv7NYELAucISsuy7jL80F3An4Qx4m4Lw4/Nhded+Rwlt66m2bIYXRcmt/G/nZAEzS7wznn+QoQnLE4lVk3OpDOJRRp+CXLI5RETsCz1R0Bh4DhGd8NsXQLWneVn4r4L+O0hgLWgDqFC5zbp0iB4zknRXYaBVoDgLKEExTpm4bdNuaA+1rFOKe5oCI4Xtza0lv1Df6sk21nrq/HCWASi5nbwOdWJn4qCffRRbmR
 8PRWQrwO
 aE1OO2wmnptGrEy0hbbxInJLCitg7jFP+kLzO1wrAJebt7O7SO3fTM6RDU0DPFLCSyES9to95I54PmPOxU5rWxncEz7WWE8FVKeolyZJxZwtCV8pT/vdm4HYXmpiRi6XhK8tnnQmUhZT9s06D7aplku4KOB0cDLKoehkoJuGF9Sp6BT/gvGBoYaos9hrE7TP0Gc2McywlioxIunaGfnHfojwqInmrwzk2U0DJv+wCyVsetlmaNNN6yFlR/9A5cOiRqgyMtY33GU0BdiSxJtzYpCVBWob2t87nTcU/H2wOerFlNueoO9AYDqk9RAnwmeUZFoVx1pBr2F4QMZ+ffur5mYDiZ8fIG61GeF08AHJSS6OVBJFwbyjy4tz19g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 09:04:29PM +0800, Muchun Song wrote:
> Commit 622026e87c40 ("mm/hugetlb: remove fake head pages") switched
> HVO to reuse per-zone shared tail pages from zone->vmemmap_tails[].
> 
> Those shared tail pages were initialized in hugetlb_vmemmap_init(), but
> bootmem HugeTLB folios are prepared earlier from gather_bootmem_prealloc().
> With hugetlb_free_vmemmap=on, prep_and_add_bootmem_folios() can access
> pageblock flags on bootmem HugeTLB pages whose mirrored tail struct pages
> already point to the shared tail page. On CONFIG_DEBUG_VM kernels,
> get_pfnblock_bitmap_bitidx() then dereferences the still-uninitialized
> shared tail page and can panic during boot.
> 
> Initialize zone->vmemmap_tails[] from gather_bootmem_prealloc(), before
> bootmem HugeTLB folios are processed, and drop the later initialization
> from hugetlb_vmemmap_init().
> 
> This bug only affects CONFIG_DEBUG_VM kernels, where the relevant
> assertion is evaluated.
> 
> Fixes: 622026e87c40 ("mm/hugetlb: remove fake head pages")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

For the correctness of the change

Acked-by: Oscar Salvador <osalvador@suse.de>

but I have a couple of comments:

> ---
>  mm/hugetlb.c         | 19 +++++++++++++++++++
>  mm/hugetlb_vmemmap.c | 17 -----------------
>  2 files changed, 19 insertions(+), 17 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 31b34ca0f402..d22683ab30a1 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -3382,6 +3382,25 @@ static void __init gather_bootmem_prealloc(void)
>  		.max_threads	= num_node_state(N_MEMORY),
>  		.numa_aware	= true,
>  	};
> +#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
> +	struct zone *zone;
> +
> +	for_each_zone(zone) {
> +		for (int i = 0; i < NR_VMEMMAP_TAILS; i++) {
> +			struct page *tail, *p;
> +			unsigned int order;
> +
> +			tail = zone->vmemmap_tails[i];
> +			if (!tail)
> +				continue;
> +
> +			order = i + VMEMMAP_TAIL_MIN_ORDER;
> +			p = page_to_virt(tail);
> +			for (int j = 0; j < PAGE_SIZE / sizeof(struct page); j++)
> +				init_compound_tail(p + j, NULL, order, zone);
> +		}
> +	}

This deserves a comment why do we need to initialize those pages here, no need for
a fat one but a hint, because everybody else looking at this will wonder why do not
have it in hugetlb_vmemmap_init(), as the name suggests.


> +#endif
>  
>  	padata_do_multithreaded(&job);
>  }
> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
> index 4a077d231d3a..62e61af18c9a 100644
> --- a/mm/hugetlb_vmemmap.c
> +++ b/mm/hugetlb_vmemmap.c
> @@ -870,27 +870,10 @@ static const struct ctl_table hugetlb_vmemmap_sysctls[] = {
>  static int __init hugetlb_vmemmap_init(void)

At this point, hugetlb_vmemmap_init only initialites the sysctls for
each hstate, should the name reflect that better?

Also, vmemmap_get_tail() still thinks that tail pages are initialized
here from this comment:

 "/*
   * Only allocate the page, but do not initialize it.
   *
   * Any initialization done here will be overwritten by memmap_init().
   *
   * hugetlb_vmemmap_init() will take care of initialization after
   * memmap_init().
   */"

so we might want to adjust that as well, and I am not sure if we have
more comments in the tree referencing hugetlb_vmemmap_init() as the init
point for those pages that need correction.

 
Having said that, and this is just a question, we cannot really make
gather_bootmem_prealloc() also do the initialization of the sysfs right?
I see that hugetlb sysfs gets initialized from hugetlb_init() a few
calls after, so.. meh.

Anyway, maybe just convert hugetlb_vmemmap_init to hugetlb_vmemmap_sysfs_create
(pick a better name), so it does not look like having two entry points
for vmemmap init stuff.

-- 
Oscar Salvador
SUSE Labs

