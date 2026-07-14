Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B6E7C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 10:26:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 340D36B0005; Tue, 14 Jul 2026 06:26:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F17D6B008A; Tue, 14 Jul 2026 06:26:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E04C6B008C; Tue, 14 Jul 2026 06:26:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E41C86B0005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 06:26:24 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5FB5716031C
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:26:24 +0000 (UTC)
X-FDA: 84987002688.06.E4AFC84
Received: from fhigh-b3-smtp.messagingengine.com (fhigh-b3-smtp.messagingengine.com [202.12.124.154])
	by imf24.hostedemail.com (Postfix) with ESMTP id 43A15180004
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:26:22 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=Pqtmkz6e;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="Z lKZNlP";
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.154 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784024782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mLrCRSaLQOhbKPhCtQrmT9tdi69iRLVjJWCwcKmyKSw=;
	b=JW3SBP+mrd6p9YKnpUnyIAzsDMP23xlvXTGou8SOczZ09/8MjAFKdJrCaugodnIpcie1oY
	bovKOypnX8SPF3qaZFkNlXwSK4TGhfqvlVitgvqcTdQmjcjkBtdjTnucpahC5smmcG0Skw
	ykv87jsqTlxiNAuhZb8CijZWyyHT3jg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=Pqtmkz6e;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="Z lKZNlP";
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.154 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784024782;
	b=vdDLZWlfWO1isFm0x/1cR8vKc3dUcncN/aSutJIcQI4yMVlyZi9DktEGZXUmtdwdsF+BLv
	diSuKglU3EJh7OLQ/FeFAQxqAJv9kz3C+yXgZizdeGw9uZiNJHBa6qOJYT74DUiI76LGyO
	07sxW3OnNuJsWTiWwiix1fYJb3sQsa4=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 2F84D7A0161;
	Tue, 14 Jul 2026 06:26:21 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Tue, 14 Jul 2026 06:26:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm3;
	 t=1784024781; x=1784111181; bh=mLrCRSaLQOhbKPhCtQrmT9tdi69iRLVj
	JWCwcKmyKSw=; b=Pqtmkz6eOZoH//mflXWb5wAr4oWWTPDQMtmzT0C/6JJKz5E6
	cnYS+ZoVhc3IsLjkrD7Urnm06mLW/P8NT+HolalQbq1//Fca7s1YFsux73ZoGCtQ
	+4fN7UeCox0wpcAGJSH+GD+GoUGhlOx5lF/hyTXR1UbCuKwl7UNfs8u85f6LU28Y
	WDuRtdQFCaHGMUph4Of+ZBjiPrUKPtQwY4oaUA8faPxWDH8MR3tl6ZVt9/uGlx8R
	UYSU6Xng+dUDDZAy//XakeQQC58egFNK5TR7efh18RYfs+FeNZLR4okEusvgNyG8
	rErwm5kWlSVg9VqlZhUNYOdqzlapprYwTHGF4w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1784024781; x=
	1784111181; bh=mLrCRSaLQOhbKPhCtQrmT9tdi69iRLVjJWCwcKmyKSw=; b=Z
	lKZNlPT82n8WCbovThLZ7rpq6Lg+I70y8vVC0FkK51gvCnXU27bxX6oULrfUQNWh
	hXs0muHiDYsD0Q6bx/X4igBicMnc96KwIrI7QXXqisP4HP4LCDjyF6+FCzunzzeS
	383JSgGVR3EOUza7VEIe2DOIWNwbwHIs4iPqDNkYhg+N0L1tiXtmAQ4gVGqLy3U6
	c6AevICfP7qvx7hZqMhtqBhiiFWi0im6cpDOzG6b3xDFRxyQDLW57KJpj3f6fQiu
	UuYbwQ9sU9ONVpDiNxfaIZ7ULBsYX2TZQOxaZ/fykVDZrbCQcr5rOohPqf3zBg0q
	Ey85qofA87F3nL6TnXIKg==
X-ME-Sender: <xms:zA5WatLGdGpL4E44l3-Guq_B7rNdACfm3pG5aapq7FUvvGyCWJpdBw>
    <xme:zA5WalAm1ppALF-i5IEh_LN_JFnGT_dRXx2vYM7WwWXy34l9EIMK7nfcFyut1_JQ-
    7mE_ulqhuFBgiTcisw8gLb4IM4hARA5oGXdBy0cuzxWG6aVrUsYCJI>
X-ME-Received: <xmr:zA5WaitLJdVR6EaZ3g5CpEFHPHAS1lgyjZe4gsLnrYdrc6WWGSEpwAszzMEvzA>
X-ME-Proxy-Cause: dmFkZTFqnwoqvmlLwk4eBc0p62H1S72DYmJWfgp9mbCTF6KmVGqSluA2hCfcFEFcBmBy1h
    SimnBXa/8ZcE3FQEeQsT9/NwmGPE+MjjbSRw63RLyi3MbFNsYQ6q7hfLjRmcr+FHBXZ73L
    QclfZjDrZbwF4fR8lnMKMZve15K66buR5IrqNXLYQbb4a924wVaTI2ssoPySKVt2TvbDMC
    uzqQC6DLoKzKoFcyr/04S2eMweFelAbnRYg++nlTSlV+6u4hO9KL434IPIYCyoTqmpEmeg
    L3SLiPLu7nMPdr+XxvA079BPooOaCrJS45/reL6Mrc8fzjnRDHEWUcFjlZ7LVHxkMMEiem
    qBo7f8F/l98+UzCVye9YyRXnDzMWJ/eAkxrc5m3soCdAttcian+JIp3GLovgSdDXIt4AMi
    12k73AE5hODGzXN8Ofsp+mQZdXuI+qVrR12vYV1TdK0mbEqUIbMTKJxJd6Sx8qHmmIIQez
    +HBiw3uQjJV5fD0sfmgIqlMFmm8DH4aJz7m+I8+3hdS2f2TCb9Xt5MUkw2rqeEl+K3fDTl
    TmhPzak62EwDg38ToFPPYZRJdE8y93YYov50CPctHg08ZEXimCcg6FLnv4YK0dTHMkIyP4
    bLygfGuRCzoYODLgWoAad7ytc5/7XPbEodScu43kaILpC4doZIIniGRwaRZg
X-ME-Proxy: <xmx:zA5WajQOP5WZl71RtYUCLtQobPERzInKzfZ_k37kDLFDqxeW_exSTQ>
    <xmx:zA5WapL93CoMuFB5X6yP9lSjM2zvfVjC69Keai29CZ4C9pD7DRcsMQ>
    <xmx:zA5WamtgL13HUtOwe1u6yS9yXrhCUX9FoxDUzl4M4f3TZG2gam9JTQ>
    <xmx:zA5Wag_G-jAhpMkJAwrsvZYHVSiFjG0z7pkEqCnqXhkLvxK6QUVcbg>
    <xmx:zQ5Waleq14o6_bAOWxSIXl841ZfY0rhEV1uv5N2b8iWaNcRuKKCNWRdZ>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 14 Jul 2026 06:26:20 -0400 (EDT)
Date: Tue, 14 Jul 2026 11:26:19 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Zi Yan <ziy@nvidia.com>
Cc: Hao Zhang <hao_zhang_kdev@163.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH] mm: thp: unlock i_mmap before releasing split folios
Message-ID: <alYNlDNMQy0Fl2VB@thinkstation>
References: <20260710071344.GA106129@zh-pc>
 <alDSekC_5t-29vJS@thinkstation>
 <alEWEColDdwQboYX@192.168.1.215>
 <alEg6ZPc-ao7s6o6@thinkstation>
 <DJXXKH4KOBVQ.2I9NU3EJL88HA@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DJXXKH4KOBVQ.2I9NU3EJL88HA@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 43A15180004
X-Stat-Signature: yp5cxeqa1a1k85977xaim1dfr3fj84xp
X-HE-Tag: 1784024782-577008
X-HE-Meta: U2FsdGVkX19X+kySyCl/787UHqXh8ro7Q1DaLK1kqeRvTK7UVFb+SRR1mhNcqsPnNoq7Fy1JGvEHNHvKQ//1Sls9G0mpXTYIOFPf21Ds5o+w9So+ie3ZAxpy3Abglc4vU2YvF9GkrFqLCr8D7NvZdRcFNuy27coAWte/c316PxkrkmnnhxmA1/q1v4GkKVE2V1x4FQBIfZ6sgoNc81x6gPrKzJpq30hDduWgcBJjsPElCWhnf9NJKcovECeAThtwQusgy4y932xWe6ytSXf9DUbQk9vY1CMTrM0PG/wiaqGfB5mTF2dJuwgFWbJii1WQ/NwbBqZ9qS0ULVOA4Ng+hX2xi0+M5oqWcx5mUtpWEzzqmoU2Js6OBxKaBIIu19WhEFs02WrCk3+RdzfQH1qT8p9Fj29/0r6UX4oooiV138f1KkGDj2Wkaa6ZCZn5E2LllZs62qJr7/Ds/48AofTAiOUAOkDVK543UHDbnuUbEHUQLznGSs0ilVEv+iegN7UjS640wWs/n1Tnlg1CvY2bpqtdNFBpJfVz6iQCgEYA2yjySQgdvW4A0C+nU6gthyXlJXZWmzkM7IE/ZKU1MSlIEejdEbc/1Jh29dplgUxlfslZN0ISzCmnoGYFqExJqA4YrJwadIfcWjMhnIToIT+5UO2/aX8N/W4NOeCXSa+o9r1jvzmnO/ei0IMaBByUaO6dZWQJLyrPeoFWHXMaAQwADZgkyniaEHkLQgticiAiuA8ph/t0zGd5Whb6YQcyrYRkzuMGFVC5OYNWZhG7m+eFPsEjjJON8SlyCSsvw7uzD/ivWCDIAqTFFZLRIvMLnuA64xmHO0NJ1yGmwO6tttuUo+GdooKI3eyl/RdpWsK754dmh3yT1BiLrmIoO1u/GXprV39w2SXSMM6WEh8+B9JSH4HCFRDY3qohg9uX/OhitAZ3rTXjDmb78lP9s8V/UmUPbmeH0eJ9Ykna02zEkgB
 ps4SmXZA
 xXeuZkwiGxatNKi4YYQ3KwxrSpMz79NfKx+r/jL7tmeGWmRH8oBZMlhiMTJO4couNbjQCvxCJM3aTzJIYYuD3Nwn+T3o6MAT6A38CBbFwXYyclQCERAVR4wGD031TbrPlV3rVUxBbxLQ2PW64PC7sdi3a1vkbF+35V/SKONS8KXrxmVz8z8UbdarUCF6oLTVS+1zswd6IdwNQbzHKwH4G3/tCBi3PSN86SANVjA7Dap+lGR1gszioKW6wUAJcM/o90aZhCTAFgzSSbS0tOT7I5bpBsWjThLVke6yi7OI1Tl0V0n8tE+gI+i/aLAtxz4bMUHX0hyyhVE25hujQe7P+7PhUePu/FHl+zM8B0tWhGZPm5Wf9T3b7ZImpnayE5is+KcxCb66LfpQytfy4F4KGdd55+ZeH0j6truWrYpSqtP5cYm1B+/tXUmSS2pSEHQZ3lz/BF6ELkeEAvj5TygYBkvq0Ugm19CxM39Ydpfp44NWUqQfQxaYwBA0fJ+WhwhPRlVVN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 10:15:40PM -0400, Zi Yan wrote:
> > This log line confirms my suspicion.
> >
> > The UAF fires at i_mmap_unlock_read() while try_to_split_thp_page()
> > still holds the poisoned page locked. For the inode to be freed at that
> > point, eviction must have completed truncation, which is impossible
> > while a locked folio remains in the page cache. So the after-split folio
> > containing lock_at was no longer in the page cache — and the only way to
> > remove a locked folio is the split itself: the new_folio->index >= end
> > drop in __folio_freeze_and_split_unmapped(). It requires lock_at to be a
> > tail page, which is what memory-failure passes.
> >
> >         CPU0                                    CPU1
> >   i_mmap_lock_read(mapping)
> >   __folio_freeze_and_split_unmapped()
> >     __filemap_remove_folio(lock_at)   <-- beyond EOF: leaves cache, stays LOCKED
> >
> >   /* no locked folio pins the inode */
> >                                         evict()
> >                                           truncate_inode_pages_final()  /* nothing to block on */
> >                                           call_rcu() -> free inode
> >
> >   i_mmap_unlock_read(mapping)          <-- UAF: rwsem in freed inode
> >
> > Your fix moves i_mmap_unlock_read() out of the window, but I don't think
> > it is complete: shmem_uncharge(mapping->host) a few lines up also touches
> > the inode, and its nr_shmem_dropped guard is exactly the beyond-EOF drop
> > that triggers this. So it is in the same freed window; the patch just
> > relocates the one dereference KASAN caught.
> 
> I was discussing this issue with Codex after I saw Kriyl's patch and the
> iput() issue raised by Sashiko[1]. Hao's patch might be still valid for
> shmem_uncharge(), since all after-split folios are locked at
> shmem_uncharge() and prevents inode from going away. So the rule is no
> mapping/inode dereferences after the after-split folios unlock loop
> begins.

I agree that Hao's fix works, but I don't think "all after-split folios
are locked" is the right rule: the beyond-EOF folios are locked, yet no
longer in the page cache, so they don't block eviction. What actually
pins the inode is @folio itself: the drop loop in
__folio_freeze_and_split_unmapped() starts at folio_next(folio), so
@folio always stays in the page cache -- even if it is entirely beyond
EOF -- and stays locked until the unlock loop.

But maybe we should sidestep the problem altogether and refuse the
split with -EBUSY if @lock_at is beyond @end. Then the caller's locked
folio is guaranteed to stay in the page cache and pins the inode for
the whole function. No ordering rules needed.

It is normally only reachable as a race with truncate (or eviction),
where failing the split is harmless. The exception is a folio left
straddling EOF by a failed split in truncate_inode_partial_folio():
memory_failure() on a beyond-EOF subpage of it would now fail to split
instead of dropping the poisoned page. That range is zeroed and
unreachable, so I think it is acceptable.

Any opinions?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

