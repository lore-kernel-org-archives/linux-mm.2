Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A6A0C5AC80
	for <linux-mm@archiver.kernel.org>; Sun,  9 Aug 2026 04:02:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B92096B0103; Sun,  9 Aug 2026 00:02:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B43056B0105; Sun,  9 Aug 2026 00:02:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A58FD6B0106; Sun,  9 Aug 2026 00:02:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 553516B0103
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 00:02:41 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 003971404AE
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 04:02:38 +0000 (UTC)
X-FDA: 85080384438.06.B4AF1F9
Received: from lgeamrelo13.lge.com (lgeamrelo13.lge.com [156.147.23.53])
	by imf13.hostedemail.com (Postfix) with ESMTP id BBF622000F
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 04:02:35 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf13.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.53 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786248157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QhcNA1MMOHR95k6P3pb19IpAD2Ulk/ogPeYzic9O9Mc=;
	b=0GfveARKB/wKdUjcCH/8Sj25fvhS05Zshhx/wEI9cHLVudnLi+ltsQsRuaVVHZJ+xEisPj
	8FaZpRjlzdtu+KTVZ/XHKLWj59F0MjtI3tUfZWBkH9gjGBxMcpkkVsIS0SLTP2LNF61uD/
	9vF+jwmk9Qj0lcV/nRzrz5PZP+DdDBA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf13.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.53 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786248157;
	b=EksWHFrAAv70TUMbPpWklVnCrEzHcpCFbD/pWaRZVcmWFZEkOcxHqf+7ET9q/BUlv3jPxb
	RW117yywdbOpdoOA1RXqv2sTehj2DWYstHPgtRom02o+hixMA5X0OscnQCcIk7Y29AoAJz
	z2xqBWAnXlzxEK0verwyPZNgc6vfrE8=
Received: from unknown (HELO lgeamrelo01.lge.com) (156.147.1.125)
	by 156.147.23.53 with ESMTP; 9 Aug 2026 13:02:33 +0900
X-Original-SENDERIP: 156.147.1.125
X-Original-MAILFROM: youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.1.125 with ESMTP; 9 Aug 2026 13:02:33 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Sun, 9 Aug 2026 13:02:33 +0900
From: Youngjun Park <youngjun.park@lge.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>, Jianyue Wu <wujianyue000@gmail.com>,
	her0gyugyu@gmail.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] mm, swap: give hibernation swap slots their own swap
 table entry type
Message-ID: <anf72SvjPu0yt5wT@yjaykim-PowerEdge-T330>
References: <20260806190636.446205-1-youngjun.park@lge.com>
 <20260806190636.446205-3-youngjun.park@lge.com>
 <ancjiz6-qyC0ki4O@KASONG-MC4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ancjiz6-qyC0ki4O@KASONG-MC4>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: 61gxc1rn4maktuzxwzq3a7u694453utt
X-Rspamd-Queue-Id: BBF622000F
X-HE-Tag: 1786248155-365005
X-HE-Meta: U2FsdGVkX197XSTQE5fp9sjOBYZlG7ydwTDY0w9NC1XIwwOBgaPg594hVyQrsRNCrq/Zp34kL/haZQFBIcWO5FPbi8VRZDQ3Gkqby0BjpSBFYolPjugKXnf4QN1fdVXAchL+OQP5cjrJh1U73+foFfwVLfjozOtEfJBaGVCK0ZDvYVEStKo/KnrvJmoBfNjFIOO0RtTHb+douQCTiMG0tWr3ViUxFY04BBIO979/uYBPKAhcZSg4w+8jaU7CtvimVtjVTzWKowLJ6s68U21o/DjGnnKy99OE0P+IE4xV5E5i7VQl3T/Rrm220ljOqlDGfxlVtDppoEkLzFFxHp3SOvR5ffRUjKaaVJayFkMDr9oDkZ2b1J1Xq8iEOvhA92EqY5a9QGyAPbY71FS73CTDd7ai/vKJti0TrAXnEQVpKuZOj/GhIE121kQ1PhsgULG0lzQXhrgVE6MnocWN1eKo4i6A89KCjpdGD6QmSe1Bucao5DPgeCkOIv2WjU9bPvJBL2IEHpZ21twFpiilayGMqzVmyKSBKcvdgmId7BqsDQWZPQpqPoycFbmq4Ukm0hD2dKR/KPojtufPa+cGuuYriMlYTXNeYsT3RoOXWTG74rg5+c17mQROaSAdfM90fkr30crEyTof6A+tWLEtvG+tH8p/8BQ3/rIFxWRY8qFVy515H82KbspFYqYpPpDU4lqs2dXAwCk09r2H5DiV4KNbwW55a0dvidulS31IssmhreUXbB6ULR0yw1DTruN6plQ+YMwPsfS4CEwxS2wYK9BAZGm+KawzHZk22+I6McSw9lI3BQZ/PVfLp+m8mWWAO21DXb5r6g2TDrYm34Luf9bnbJkFUIedF4K0gEw8MjyJi64s02CGkwFsf5URxP7mu0YO0oHf/d991K733r5890Pcdp7wT5+zdqOUKSAsddKkdlp7Pc1vjMERbctoeX4WQNlobkTP4VzoZKY/I4BuM0M
 lx05Q0YE
 SlpVBm7vp+MSrUaAiNr1e2dixLK3WailEfMH16hiw2KKeWdxn6/QTaEG3viidF6TpPCChnlguMd86Sl+etLTZoPANkBk+TfuEHEGK7KU+ZsZ2FzHvA0sKpSJa6jg7g0qEBQk7cJF/+sf9bELirfhaH8CI+u+l+nC4IxBBISSGsGMELBiZYW03e8SDJzz6BccpScKUAi3KZuZWhDmf7umvBhX+ycHnVhy/2irpUeGrsed7tltSBeD4qgoZwoOxZskaY7Pp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 08, 2026 at 09:25:47PM +0800, Kairui Song wrote:
> On Fri, Aug 07, 2026 at 04:06:34AM +0800, Youngjun Park wrote:
> > swap_alloc_hibernation_slot() stores a fake shadow in the slot it hands
> > out.  An anon slot swapped out with no workingset shadow looks exactly the
> > same, so nothing in mm can tell the two apart.
> > 
> > Give hibernation slots their own type.  Bit 4 and every bit above it are
> > set, the same shape as SWP_TB_BAD.  Bits 0 to 3 are taken by the shadow,
> > PFN, pointer and bad marks, so bit 4 is the first free one.  Neither type
> > holds data, so the value alone says what it is.
> > 
> > The entry has no swap count.  Hibernation only allocates and frees a slot,
> > so a count would never change.  swap_free_hibernation_slot() frees the slot
> > directly, there is no count to put first.
> > 
> > The next patch needs these slots to stop looking like shadows.
> > 
> > Suggested-by: Kairui Song <kasong@tencent.com>
> > Link: https://lore.kernel.org/linux-mm/abp7aDgYLrxF3Me8@KASONG-MC4/
> > Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> > ---
> >  mm/swap_table.h | 12 ++++++++++++
> >  mm/swapfile.c   | 13 +++++++------
> >  2 files changed, 19 insertions(+), 6 deletions(-)
> > 
> > diff --git a/mm/swap_table.h b/mm/swap_table.h
> > index e6613e62f8d0..c1c516bcc17e 100644
> > --- a/mm/swap_table.h
> > +++ b/mm/swap_table.h
> > @@ -30,6 +30,7 @@ struct swap_memcg_table {
> >   * PFN:      |SWAP_COUNT|Z|------ PFN -------|10| - Cached slot
> >   * Pointer:  |----------- Pointer ----------|100| - (Unused)
> >   * Bad:      |------------- 1 -------------|1000| - Bad slot
> > + * Hibern:   |------------ 1 -------------|10000| - Hibernation slot
> 
> Nice!
> 
> Just one idea, would it be nicer if we have:
> * Hibern:   |   0   |------- 1 -------------|10000| - Hibernation slot
> 
> Or:
> * Hibern:   |0..001|------- 1 -------------|10000| - Hibernation slot
> 
> That way if we accidentally used __swp_tb_get_count, it return a actual
> meaningful value instead of MAX. Either 0 - the slot is not used as
> a countable ordinary slot, or 1 - the slot has one user: hibernation.
> 
> Maybe 0 is better at least for the intermediate commit, see below.
> 
> >  
> > +static inline bool swp_tb_is_hibernation(unsigned long swp_tb)
> > +{
> > +	return swp_tb == SWP_TB_HIB;
> > +}
> > +
> >  static inline bool swp_tb_is_countable(unsigned long swp_tb)
> >  {
> >  	return (swp_tb_is_shadow(swp_tb) || swp_tb_is_folio(swp_tb) ||
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index f5dfc7e59191..a337387f7431 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -928,7 +928,7 @@ static bool __swap_cluster_alloc_entries(struct swap_info_struct *si,
> >  	 * upon folio unmap.
> >  	 *
> >  	 * Else, it's a exclusive order 0 allocation for hibernation.
> > -	 * The slot starts with count == 1 and never increases.
> > +	 * The slot carries no swap count and is freed by offset.
> >  	 */
> >  	if (likely(folio)) {
> >  		order = folio_order(folio);
> > @@ -940,8 +940,8 @@ static bool __swap_cluster_alloc_entries(struct swap_info_struct *si,
> >  		order = 0;
> >  		nr_pages = 1;
> >  		swap_cluster_assert_empty(ci, ci_off, 1, false);
> > -		/* Fake shadow placeholder with no flag, hibernation does not use the zeromap */
> > -		__swap_table_set(ci, ci_off, __swp_tb_mk_count(shadow_to_swp_tb(NULL, 0), 1));
> > +		/* Exclusively owned by hibernation, must never enter the swap cache */
> > +		__swap_table_set(ci, ci_off, SWP_TB_HIB);
> >  	} else {
> >  		/* Allocation without folio is only possible with hibernation */
> >  		WARN_ON_ONCE(1);
> > @@ -1929,9 +1929,11 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
> >  		old_tb = __swap_table_get(ci, ci_off);
> >  		/*
> >  		 * Freeing is done after release of the last swap count
> > -		 * ref, or after swap cache is dropped
> > +		 * ref, or after swap cache is dropped. A hibernation slot
> > +		 * has no count and is freed directly by its owner.
> >  		 */
> > -		VM_WARN_ON(!swp_tb_is_shadow(old_tb) || __swp_tb_get_count(old_tb) > 1);
> > +		VM_WARN_ON(!swp_tb_is_hibernation(old_tb) &&
> > +			   (!swp_tb_is_shadow(old_tb) || __swp_tb_get_count(old_tb) > 1));
> >  
> >  		/* Resetting the slot to NULL also clears the inline flags. */
> >  		__swap_table_set(ci, ci_off, null_to_swp_tb());
> > @@ -2201,7 +2203,6 @@ void swap_free_hibernation_slot(swp_entry_t entry)
> >  	pgoff_t offset = swp_offset(entry);
> >  
> >  	ci = swap_cluster_lock(si, offset);
> > -	__swap_cluster_put_entry(ci, offset % SWAPFILE_CLUSTER);
> >  	/*
> >  	 * A slot with a folio in the swap cache is freed when the folio
> >  	 * leaves the cache, the same rule swap_put_entries_cluster() follows.
> 
> This idea is right, but is the patch in the right order? If readahead
> tried to add a folio to a hibernate slot by accident, seems nothing
> blocks that in the current patch, and that PFN slot will have a (MAX)
> count value, and considered countable? If the that folio is somehow
> reclaimed, we got a corrupted shadow (hib type is gone)?
> 
> If we have the count part of a hibernation slot be 0,
> __swap_cache_add_check will fail natively, seems there will be no
> such risk. A few existing helpers can also help catch potential
> wrong freeing of hibernation slot. (underflow check).
> 
> The layout can be changed again afterwards.
> 
> How do you think?

Yeah whole thing you addressed make sense.
I will follow your guide & review and send the patch soon :)

Youngjun

