Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECB6BC61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 01:27:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D22216B0088; Tue,  1 Sep 2026 21:27:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD31A6B008A; Tue,  1 Sep 2026 21:27:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC1BA6B0092; Tue,  1 Sep 2026 21:27:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D9A06B0088
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 21:27:27 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F271E8062C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 01:27:26 +0000 (UTC)
X-FDA: 85167084492.13.2EC7DC7
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2D0A840004
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 01:27:25 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MUuGTj8P;
	spf=pass (imf07.hostedemail.com: domain of hughd@google.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788312445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zUMTfAI7ONprrYSeDVVm7zPC919OUwaHos5tY6hqkXQ=;
	b=gTseY1ayQX2w2F63S0sXxZ4tTHtJ0D3kKHA+ffBa2Go1Ky27n7UfybViJ3n+f9XvA5cjLF
	WouTVaVDmggHeQv1X4v4NTxqxRH+BCyJy3tA2pHBTrgE7pKc+QM9B03/Om9rVP/1UqDLOH
	y19jv1Tk/n2+D099dTYiozyWnuAapfY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788312445;
	b=7vCGFScf8fEH4aYJI35nZ56b9FG11NUgg0H0tBU7G31bx40FZG95FooVIaeAK+5JB4kYY7
	n7zM+Zy90WD386r4HBcYbJ+O5tK+mWWWH7SzPzvZokUea/UlG2KJHAdwJzR+2S6ku6kzqk
	Ye2NOHqf5VUQ4+LKojeOmsY8QpZq6YQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MUuGTj8P;
	spf=pass (imf07.hostedemail.com: domain of hughd@google.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-836c8bdac50so7935887b3.0
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 18:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788312444; x=1788917244; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zUMTfAI7ONprrYSeDVVm7zPC919OUwaHos5tY6hqkXQ=;
        b=MUuGTj8P5RwxmZSe08iOw3exBurjWyL7Zfj71IJG/kC7vz0sLPCZdD6Cx+MGzy+s6z
         QYaOq9QyDKJ1Kxg5F6kZzXP07dFgiOJ5eAE/NFFBGxBgy4mCbVqlCfjNH3gwxFVBgVaO
         HzmLPd0XQq7EK/eUXoAJXRmS+vb8gwl48UI+ra0LyWjaGh9erEiUyArZp1zUBUV3S7KZ
         H5Ds3qr+FvpoHvhfobLqBp7B3GrSwYsGEmcuNajl/tfaXieLg+04BEN2VCfuSR2Cv0gm
         nTgPDThHvqtMfrPO+PI9+m+dMD1XD3+SorsCCCD84GSSk1O/jqI+2M6fsAj6eDoVOg7m
         elIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788312444; x=1788917244;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zUMTfAI7ONprrYSeDVVm7zPC919OUwaHos5tY6hqkXQ=;
        b=pn64RfuWQWfjtEgtYkhYvDnnDebPmS5/F+NIou3jTbuKbd+UN5O29gxS6AaiLpLLJu
         XEpyFam+EAzCLD5ZsEsqEDoA4s6RLOhE1r2D25LWARPCSn9nNzLsupPWjCOz8pNSQ3uL
         x3I8KAxzJFn1VIe+l+zN5Mgx8aE1WXknFheiqnSTu1ugaq5NrKijYDzgRDBKA0wHuNRo
         HAJ4SQzvvXQgYzIBvtxNz3qkIrJ+hi9XS1RwZzuE3eJFmIDZ9zg0BOKhS7s//6JwEoXo
         gQXvChBV2CsaD09YYP4wquojoDOy1FIPf5bCXcjfdtphPZDrlMsOubQVl7mymXiPrnb6
         ClyA==
X-Forwarded-Encrypted: i=1; AKwUvBzEZGNknCMEbVxgAThK0MUnXGNpu2Jx1HhmrpbfawdTUcAMlQaCTPC60/QhLi3WD+eGg9cYZYByqw==@kvack.org
X-Gm-Message-State: AFuF++luX1tf7Z5kqRjK+nSYnewMYgIXWlxqdekPer1IpZtM/3sA5KD2
	6+a8a3zPWKMj9tIzlOjL/GPB86ANhj+Yguzh7C7wtU8PpAVc83ZwEkQ+rILiuLCZvQ==
X-Gm-Gg: AYBFou3QgvLy4wfHo40GTkQJ6PxFXgRh/kCQQwWwoYf2Hlqr3fTIaUThMw2cEBTU5ei
	mOOpdyThgx3Q214KxrsxGPY1j/CxEpJ8RgGFswqoxofECu2371QmBvNDJWq5afTFc8TXFPMvWpa
	UWh2wO8ha/bO5FwbkcoMazf5pcYuRfqlJC8ERQ7KSKvGs3EBAsV6uQ0W/b7Sf9+5U7b0xEY3TJy
	9JlJJY/w8hgrF7dHzodcWNYnEbFAT3ItfM2Cc97+Gq9mwnQH5Uc+1nCGBswo9vn9IxT52opYEFe
	t+UZKf6NzowRgJp5Hj1K7PEFdbGv1jmEUDHOIf3G7FEtDSAOWNkv+xrlGGtdW0lenymV4FDXFqd
	kaRUXUCoOGdfHI7IAh8DXwFf+lIY2hCBGfj8+c4rp8px1PX7HSaIzpWlmUnXo+F0FaScJYaTt2M
	hhkq6T3rvyJrZYTOOxqJEvj8zYfNGTWZK4jCRkwzXkIrAqDdU8WtoT+ZhGCu6IIBUG6GP2dwjUU
	K0agaHZGo51U7FlIoX/LXFr+9jKZSkCbq4wt+mlp8dNJVMp
X-Received: by 2002:a05:690c:e206:20b0:861:d742:8c1 with SMTP id 00721157ae682-86c4da2b5a1mr5004487b3.2.1788312443615;
        Tue, 01 Sep 2026 18:27:23 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-86c186d7370sm6729127b3.37.2026.09.01.18.27.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 18:27:23 -0700 (PDT)
Date: Tue, 1 Sep 2026 18:27:06 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, 
    Vlastimil Babka <vbabka@kernel.org>, 
    "Liam R . Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
    Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
    Matthew Wilcox <willy@infradead.org>, 
    Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/mlock: use the IRQ-safe accessor for NR_MLOCK in
 __munlock_folio()
In-Reply-To: <20260901180109.3797944-1-shakeel.butt@linux.dev>
Message-ID: <1ddfa7dc-2dd8-406d-8454-59a349972106@google.com>
References: <20260901180109.3797944-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: kix4399od3ji9jx8cqycwpokqsjwnapz
X-Rspamd-Queue-Id: 2D0A840004
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788312445-520410
X-HE-Meta: U2FsdGVkX1/+c4fUq9FnsBslbaTUwGeIMckKybZHw/7r0FWKV8x4ep+WYZOX8CUOKCGveeIM7L1Fc96T/SX0313okPb8/pNSlgSp+nGiyrkfT8OQJbG6wX6xWdKMWtUxwhnrStcVHt0FOTwz0a5tUhKvZDJCdxlWTW42dmtogiZYwGJJ/kQmr79NDbeld+jUwvWIJA29TnleNTbUFn1vtn5Rux6FlYFZTrfLDF1aWKLvPPGu2WXlgP/Vuu54w2EL6kWM6usAFtle6YRiiZe15B4e8A18Byi51QnFdJdZwh05t/9P+TRwfTol5pKhG+ByfZ7W5GfDfgh903JxaJek+eEjNcKkRTo1CM3giHa/svt3SUfp+P25kCXQJ9Y3LUPGHd1yMFyF+WDLeVH/ahRY23jWDzIAXus6nuTHLwUptVIAan2Hl419O+FcSWNS7mf8z0/WCmeCrBn6cGGXPYNGS5JHh0YWkdUv4q7wA1srKAmFf2k/kLs6e9CkEvnRHr4QHdlIkRmYqicWcKZW6pKYwvr1MBpAO6bja/upc/csxZhZhPDwpPshAl92txId8mTH9blNRwJbOK5FEpPhOxLcP6x13wHa+mvYxruNksW5ylAExNnT7XiHATK//T/5GoqnluHiQFj3L4/kY6jKzKFixc40z4vqw/aCGnx422WECxUqG0pCKIzNFivzpYdmM03b8tw1ooybArxtj74nuk8qnzA4+4fjIc70TaoVN9GDpJCnIrceUtmL8h7/w1El6kpmLwn6vN9JeyynE1AolTmNJF6iLUmjzoaSmINKPGAG4+1W1FaDtrFYcdUjDR6WsWBsq9k2wmEf4xGHIv39qrYvy4MuZefiMfkHSkSqyYgFruHnc6KsT1DisXkX5TQqMcbH4iu+GjjYBq81M6SdQbNxnjZHUN7emVXlYOMUdoDdl13Jd41cFA9KKg9qOiL5p1rcVe6tx7HZEclNZMCLPaY
 LUxNxRob
 33NcDF9YCpVSc9R5yrAPwLKn+sVOmzl4vHLpDKhjQf+N8Ss8gAFp58CU4+BMVrUfK35a7Fkr9l2Mvjc8UuVOm8festpyq9jfsBIyU2dsfxP8G1e1hqG/KYL8i84b0zd3w1hNv+WsZj9FZhnn9aiyYUQKOBHVdHGQHTEr9JVvMwhQ+tAUAGIRNEk9Xg0UhZPxbKRkABer4G2+i+TncdH6+xCp+vxvhI3GpuKAyXwYVNVOUPu2JFe1a0fRIcUTer9/bnkzxWSp7fYxUjd1/BMkntFLZ6nkKrKB6Mp5ijJgn1rVuRYLNcL1WYB44HSz4XE44jpF/ky7O8MDBknJzDM30EbvL/A3AnQ+lc5eZvmjnXuS1HwDITXJl7PWF0XxB2waigUTWi2Q7GGpt1bBNg+CX7F5WhXdNp0LgdL0m5OPwbLQ9RpqosebVCFyDjlwdeQaMwUrEPlrTkK0UJ4Xfe3yrMn1RwepgC4nMgwbB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 1 Sep 2026, Shakeel Butt wrote:

> NR_MLOCK is updated from interrupt context.  __free_pages_prepare() clears
> a stray PG_mlocked and adjusts NR_MLOCK, and a folio can reach it with the
> flag still set from a bio completion handler:
> 
>   __free_pages_ok+0x6af/0x7a0
>   <IRQ>
>   __bio_release_pages+0xde/0x260
>   __iomap_dio_bio_end_io+0x16e/0x1a0
>   blk_update_request+0x14b/0x3d0
>   blk_mq_end_request+0x18/0x30
>   blk_done_softirq+0x49/0x60
> 
> The folio gets there like this.  A MAP_SHARED file mapping is mlocked, so
> its page cache folios carry PG_mlocked, and an O_DIRECT write sourced from
> that mapping GUP-pins those same folios.  munlock() then runs
> mlock_vma_pages_range(), which clears VM_LOCKED before walking the page
> tables to munlock each folio.  A concurrent hole punch reaches the folio
> through the rmap (i_mmap_rwsem, not mmap_lock) and can land inside that
> window: __folio_remove_rmap() -> munlock_vma_folio() sees VM_LOCKED
> already clear, so it neither queues the folio on the mlock batch nor takes
> a reference, and the pte it clears makes the pending mlock_pte_range()
> walk skip the folio at its !pte_present() check.  filemap_remove_folio()
> then drops the page cache reference, leaving the bio's pin as the last
> one, released from the completion handler above.

I'm hardly ashamed to admit that I've not tried to digest
that paragraph. You're writing about the rare fallback cases when
PG_mlocked is cleared late, and unevictable_pgs_cleared incremented to
notify us of that defect: yes, I accept that might happen at interrupt
time, and so we ought not to take the __shortcut in __munlock_folio()
which you fix  below.

> 
> So __zone_stat_mod_folio() here needs interrupts disabled, not merely
> preemption, and __munlock_folio() has a path where they are not: when the
> folio has already been taken off the LRU by somebody else the function
> jumps straight to the counter update without taking the lruvec lock.  The
> read-modify-write of the per-CPU NR_MLOCK diff can then be interrupted by
> the softirq above, and one of the two decrements is lost, leaving Mlocked
> in /proc/meminfo permanently overstated.
> 
> Use zone_stat_mod_folio().  mod_zone_state()'s this_cpu_try_cmpxchg() is
> atomic against a same-CPU interrupt and retries, and on the path where the
> lruvec lock is held its cost is negligible next to the lock itself.
> 
> The UNEVICTABLE_PG* events are deliberately left on the __ accessors:
> they occupy different vm_event_states slots from the UNEVICTABLE_PGCLEARED
> that __free_pages_prepare() bumps, and nothing updates those two from
> interrupt context.
> 
> Fixes: 2fbb0c10d1e8 ("mm/munlock: mlock_page() munlock_page() batch by pagevec")
> Cc: <stable@vger.kernel.org>

Okay: just a wrong stat, but it ought to go back to 0, so Cc stable yes.

> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Acked-by: Hugh Dickins <hughd@google.com>

But I do think you (or Andrew :-) should include

Reported-by: syzbot+cd2073ee6d958a8d0fcd@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-mm/6a931c5a.08e933ee.dbf97.0093.GAE@google.com/

That was indeed reporting a different way to get a WARNING from this,
when offlining a CPU: but it should be acknowledged for bringing you
here, and we should tell syzbot it's fixed by this.

I've been trying to work out whether you're going to come back in a
day or two, changing the __count_vm_events() too: and had raised in
that thread the question of why lru_add_drain()'s __count_vm_events
were not also reported by syzbot; but now I can see
 * vm counters are allowed to be racy. Use raw_cpu_ops to avoid the
 * local_irq_disable overhead.
and realize that they're not a problem; so this looks complete, we
shouldn't need local_lock()ing in mlock_drain_remote() after all.

Thanks,
Hugh

> ---
>  mm/mlock.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/mlock.c b/mm/mlock.c
> index efa6716e4dfb..39215a3eab1f 100644
> --- a/mm/mlock.c
> +++ b/mm/mlock.c
> @@ -141,7 +141,7 @@ static struct lruvec *__munlock_folio(struct folio *folio, struct lruvec *lruvec
>  
>  munlock:
>  	if (folio_test_clear_mlocked(folio)) {
> -		__zone_stat_mod_folio(folio, NR_MLOCK, -nr_pages);
> +		zone_stat_mod_folio(folio, NR_MLOCK, -nr_pages);
>  		if (isolated || !folio_test_unevictable(folio))
>  			__count_vm_events(UNEVICTABLE_PGMUNLOCKED, nr_pages);
>  		else
> -- 
> 2.53.0-Meta

