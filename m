Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C500EC55174
	for <linux-mm@archiver.kernel.org>; Sat,  8 Aug 2026 13:25:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 581906B00BA; Sat,  8 Aug 2026 09:25:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 532C66B00BB; Sat,  8 Aug 2026 09:25:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 421806B00BC; Sat,  8 Aug 2026 09:25:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0F5C96B00BA
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 09:25:58 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F3A7F1C0EE7
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 13:25:55 +0000 (UTC)
X-FDA: 85078175070.03.C856FA4
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf14.hostedemail.com (Postfix) with ESMTP id 33992100002
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 13:25:54 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fm373Vd3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786195554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aEPuJi9dOtjcd1sSrhmRN/FNlJj3jv4zUiWWrq20D8g=;
	b=vemzjGzyG/wv13I8lvztYvc3TF0YcVvlnWVTgVFbvFA9+9K+tK9PCQ95NX68fbrvpMVTxM
	qLxY9XyV6ItCrynOSrWyp/f9IrlfXF8mgBHxtf+uuMWk4s4KRdWBRyzW8mSUyN2ohtpKpu
	5/aHXlS50tkC4gccb78QU95pR24IIC8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fm373Vd3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786195554;
	b=xEreKCKklbJ338bq5A08K6+2XLYScjtYcjG7iCOhvTRRdYCjuFcaBLYpiFi9u9AKZNKjcW
	qD6VvhMJTHaxV0Nle5/9TBHan2wpLMg/FaaE88Hlyg7qZ00BvzV8vROreHgNQYzScJxYvV
	iVeVg9cMBAmmoyLqDKeEU9Daf1ZOivQ=
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-381c51fde6bso495750a91.2
        for <linux-mm@kvack.org>; Sat, 08 Aug 2026 06:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786195553; x=1786800353; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=aEPuJi9dOtjcd1sSrhmRN/FNlJj3jv4zUiWWrq20D8g=;
        b=fm373Vd3z1EtlL6+KgeonVbwaAjbskuHw0sMfSstK+YtASm7Bo7CjrblIMnyyPmTGH
         bS9Kry9x6uvGEwXzX+x5yoGUSlx7JHbVLK2500fRq6ytj2JIyNzUUUZfRvLKMsNL4RGe
         tACwN394XG0JShAcRxYhdDqUFKPaW2PlkPMiTZNzZAqiwYQlhYvqUt365OqsprlOUNv7
         lXieMUlUNZFGcj92bnQ6738Ez4PHi2FyxGfK36UYnf+1DRVXfhm3yTf59xCpC9BglaNO
         872piBfqP9WlOgD4nVgIPMRcawchcc3g2Xn4alv6BYIUs/QhK/yP9BnplR2HuLVpLPtt
         jB6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786195553; x=1786800353;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aEPuJi9dOtjcd1sSrhmRN/FNlJj3jv4zUiWWrq20D8g=;
        b=o7Mr2gSFgkHXwftRBz4LLa5YSviHeC1rFDQQ1eWKhsSUCypnNAP4HB2XMDTkvqQa+d
         0n39ANJoixF1WsWdu2ccdQ5ZB/+gNXiXJTlfXcnlroum2mMbBtVaVRC/LNcfqSs4R15W
         aG9Bw056jfF7yaAfIk98ExvLi5Q0njDLWL5U47Y7CfOY1gQ6nRYL+5l5TNXSdNtsPWZR
         1CA/cbZHlJqBsHFRQBes92K7U4VHhDnWRwb4lsfKCoZleUxet6bei7g00CQ/rrXlsXtB
         lTmS8PSiUNBYlXTr+QyiwV1J7woxra683ztGe6bLtSnxnorGY6pNEHUjYB+CHBaZ7DK9
         S/HQ==
X-Forwarded-Encrypted: i=1; AHgh+RpK8M+ERMNigmNb27ZcyOIwHxXNSeynp8zYfO4IWke+1ZTvo5hyLsMKAUOw2PPlg+9yfVYTAP/F2Q==@kvack.org
X-Gm-Message-State: AOJu0YyL4BXaQMMy6daRwPjW9N1FGLyAGATTb44p1XUT0ADKsg3r62G3
	vrA65p1+7a9ZUkERXdc4+yHnQoaG4T4fMnEhr6coeI9wrmoNuRDswFGq
X-Gm-Gg: AR+sD12LliGurhTz9SUMgyHbvVM//I03BIcRErKSKxk+AQLWw2KoHuN72eg+GWKiZpA
	O512rMahAbVjLHxgDUaRkQbPn9FERRhrTl2GGUeR3Z01ce4PiB/6XMBa5+8jVqNGZ1tGCBX7t27
	YEPmIp4+fgEkTz1neu0F9F3q7l966AEnJyZR/Aoa336AFvwgBP9p4NEtuXfHsfk01EApZHpDo8r
	JGGRbpXjM9Ml0EVWJLPkqFwSw1XkSwxRpJdPvRTz5Ysb8PHvrmABksuDXf2H1pSHomVr0W7NQdp
	LXk9hHyJiWznFC94LiSzMdJZBAV+zWZJWiw+RRdH/CkcmRTTnsrhQWPojnF52WRm6vQ3htaHnB9
	QURROypjl1VCULSTU1oxytKvXPk5vPeE16hZ8P94+se0HFxWrobL7D0ViOSNjKM9XQVEDoTErSo
	YVQsXNNIkNs/PSUqfTUsFmdFPkMx9rkumab3zjLCaQfYj076zXfVM5nL0SClezC8/m2w5Qgkxpr
	gmTtxRlSYvbNR29/uPHcqS8fco16k4BlSg=
X-Received: by 2002:a17:90b:2748:b0:380:7688:fbe9 with SMTP id 98e67ed59e1d1-392823a4a2bmr7598863a91.8.1786195552899;
        Sat, 08 Aug 2026 06:25:52 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39085f5c9a5sm8330201a91.15.2026.08.08.06.25.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Aug 2026 06:25:52 -0700 (PDT)
Date: Sat, 8 Aug 2026 21:25:47 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Youngjun Park <youngjun.park@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Jianyue Wu <wujianyue000@gmail.com>, her0gyugyu@gmail.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] mm, swap: give hibernation swap slots their own swap
 table entry type
Message-ID: <ancjiz6-qyC0ki4O@KASONG-MC4>
References: <20260806190636.446205-1-youngjun.park@lge.com>
 <20260806190636.446205-3-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806190636.446205-3-youngjun.park@lge.com>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: qzcxa7wfqnf86yzt771xk9gf6zy5ooem
X-Rspamd-Queue-Id: 33992100002
X-HE-Tag: 1786195554-47216
X-HE-Meta: U2FsdGVkX1/VoJzq9Dz7yENRmoEcDOJocN6fYNxbisZ/o+DupytadthSpzHp2I3gZ4gBzvl3QGCIm4lLP+7AkMirCcTlu2xmWSi+md9eRcgHT7yVVpEc5shQyoUaDhnlBOEjIUwcKccGBR3nN6CLLNdIGHM+Xy2LGt8nnRqhPmKoYeD7NekTH9uaWnNHem75z42EDrw40CRy57krz/tqnrkb0v3DIZ95WbjblrLDZLQ3q6VGPO4ZQFe9qiXYsY9UKNzNjIY5IoIP24W0rM4RkMy27gTaZbRMVX/giV34axFX75OlPMa19xZc23QzBIiKJ9DeVp2cewz/cP3DgKSqV/tDroU6GRayl28MBj1fCp+SpqHM7PF+7tLVuOisjxDNVAdvouSrmjDNRsgn960tv9jBEcNZix253QRVNkcA2kF1URvY9o3SZI6sWI0mJ9kpOS56Q6TvPER4dLvTKnZ7G04EJ2BPAndKb2wVlHKfMjDJu+/y1UijlFRw/NW/vHK+5rOo+zZ3snM+OXnYm9XPQRD5rjAWJie5I633GyjpZLNJG3IQ1OZhtp8VcNzBiedMUgrsTx2V3mwLr+rYxY9EjrKg+PuYNqOpaIAkJUF10fMAucpjNxnQeOC3vdwE/YgwEck5b7wpAUBQgjbeNPW5HW0Xgmv55Krz+Mb4WAc699vYMRnbwCRN1Jm6X1/Ov/wc0d2J5DCHbXNVXHv1Ph1MFKGZ8awVBSuAzy0GTT4CcJNzKPKk8AZ1oKERODmeZYg+E3V4oqKd8a46ZE7/a1Ss5N3opXR8WP9zVnvuO2Y3wPFzCisT9KAMuqCsYYCwT81txGGyc4wp80uW4ltjx5o84wtZ/YHjFEd0ry0fR28HAEt3do4Sqn4Sfle6/8p3CgzfQpqWg+kyGK1AE8rtmQeHbKbbXeq6bZlyISqdq7P1ArL4sR6hHP370NKXfLcxpWZ9qtZUsrjCkC5Fx/B4VwN
 djI0Oi/f
 xPc+F2Agx8gGU+jCwn2Y7hoY8mTkTRDbtM9Ac/Exq1m946g2wS0ig9DE5tQwAriKy0Qe54S6GcSzzCFi8DO0DMcXbU1Oiov8DmU1rREKE34w0FPKTHEJgt3zDPHCUeGZ0waZcUMeVDSXrNtpRmETdohW2NbOyB13jUDZMZc58d0oUUPdB8IeYf4o4fjN9oIML0q+tZO9r6r3tB9OEGtOXFePha87+NbSnDkSWkx9es5ghwmFqD8xhtFVfUlJnLkUE0LDWdX/niZ/HX+4xMqqZTuAegylwfbCepJ9J0mSpdA4f7G2xz6tjOZsvcQP1uwme66ZmJOMbX+sHCTxXilL46mQ1ZwH4pSuNJ2027mkl/uUgqaqcC7wrK4H4mSGcnTMXAa4QDSYszm8G/z7R8HGHhuiBgX/yp/+IwLjwbRxoCYlsid6XueA7Hn34Lx5SvB4paP9yKZ6pzfLtwJadnYPIyn8O3wPYP7UUzUSv1nCMzrQkGwzxnDgODAx8kTh0ApGtwAWv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 07, 2026 at 04:06:34AM +0800, Youngjun Park wrote:
> swap_alloc_hibernation_slot() stores a fake shadow in the slot it hands
> out.  An anon slot swapped out with no workingset shadow looks exactly the
> same, so nothing in mm can tell the two apart.
> 
> Give hibernation slots their own type.  Bit 4 and every bit above it are
> set, the same shape as SWP_TB_BAD.  Bits 0 to 3 are taken by the shadow,
> PFN, pointer and bad marks, so bit 4 is the first free one.  Neither type
> holds data, so the value alone says what it is.
> 
> The entry has no swap count.  Hibernation only allocates and frees a slot,
> so a count would never change.  swap_free_hibernation_slot() frees the slot
> directly, there is no count to put first.
> 
> The next patch needs these slots to stop looking like shadows.
> 
> Suggested-by: Kairui Song <kasong@tencent.com>
> Link: https://lore.kernel.org/linux-mm/abp7aDgYLrxF3Me8@KASONG-MC4/
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> ---
>  mm/swap_table.h | 12 ++++++++++++
>  mm/swapfile.c   | 13 +++++++------
>  2 files changed, 19 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/swap_table.h b/mm/swap_table.h
> index e6613e62f8d0..c1c516bcc17e 100644
> --- a/mm/swap_table.h
> +++ b/mm/swap_table.h
> @@ -30,6 +30,7 @@ struct swap_memcg_table {
>   * PFN:      |SWAP_COUNT|Z|------ PFN -------|10| - Cached slot
>   * Pointer:  |----------- Pointer ----------|100| - (Unused)
>   * Bad:      |------------- 1 -------------|1000| - Bad slot
> + * Hibern:   |------------ 1 -------------|10000| - Hibernation slot

Nice!

Just one idea, would it be nicer if we have:
* Hibern:   |   0   |------- 1 -------------|10000| - Hibernation slot

Or:
* Hibern:   |0..001|------- 1 -------------|10000| - Hibernation slot

That way if we accidentally used __swp_tb_get_count, it return a actual
meaningful value instead of MAX. Either 0 - the slot is not used as
a countable ordinary slot, or 1 - the slot has one user: hibernation.

Maybe 0 is better at least for the intermediate commit, see below.

>  
> +static inline bool swp_tb_is_hibernation(unsigned long swp_tb)
> +{
> +	return swp_tb == SWP_TB_HIB;
> +}
> +
>  static inline bool swp_tb_is_countable(unsigned long swp_tb)
>  {
>  	return (swp_tb_is_shadow(swp_tb) || swp_tb_is_folio(swp_tb) ||
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index f5dfc7e59191..a337387f7431 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -928,7 +928,7 @@ static bool __swap_cluster_alloc_entries(struct swap_info_struct *si,
>  	 * upon folio unmap.
>  	 *
>  	 * Else, it's a exclusive order 0 allocation for hibernation.
> -	 * The slot starts with count == 1 and never increases.
> +	 * The slot carries no swap count and is freed by offset.
>  	 */
>  	if (likely(folio)) {
>  		order = folio_order(folio);
> @@ -940,8 +940,8 @@ static bool __swap_cluster_alloc_entries(struct swap_info_struct *si,
>  		order = 0;
>  		nr_pages = 1;
>  		swap_cluster_assert_empty(ci, ci_off, 1, false);
> -		/* Fake shadow placeholder with no flag, hibernation does not use the zeromap */
> -		__swap_table_set(ci, ci_off, __swp_tb_mk_count(shadow_to_swp_tb(NULL, 0), 1));
> +		/* Exclusively owned by hibernation, must never enter the swap cache */
> +		__swap_table_set(ci, ci_off, SWP_TB_HIB);
>  	} else {
>  		/* Allocation without folio is only possible with hibernation */
>  		WARN_ON_ONCE(1);
> @@ -1929,9 +1929,11 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
>  		old_tb = __swap_table_get(ci, ci_off);
>  		/*
>  		 * Freeing is done after release of the last swap count
> -		 * ref, or after swap cache is dropped
> +		 * ref, or after swap cache is dropped. A hibernation slot
> +		 * has no count and is freed directly by its owner.
>  		 */
> -		VM_WARN_ON(!swp_tb_is_shadow(old_tb) || __swp_tb_get_count(old_tb) > 1);
> +		VM_WARN_ON(!swp_tb_is_hibernation(old_tb) &&
> +			   (!swp_tb_is_shadow(old_tb) || __swp_tb_get_count(old_tb) > 1));
>  
>  		/* Resetting the slot to NULL also clears the inline flags. */
>  		__swap_table_set(ci, ci_off, null_to_swp_tb());
> @@ -2201,7 +2203,6 @@ void swap_free_hibernation_slot(swp_entry_t entry)
>  	pgoff_t offset = swp_offset(entry);
>  
>  	ci = swap_cluster_lock(si, offset);
> -	__swap_cluster_put_entry(ci, offset % SWAPFILE_CLUSTER);
>  	/*
>  	 * A slot with a folio in the swap cache is freed when the folio
>  	 * leaves the cache, the same rule swap_put_entries_cluster() follows.

This idea is right, but is the patch in the right order? If readahead
tried to add a folio to a hibernate slot by accident, seems nothing
blocks that in the current patch, and that PFN slot will have a (MAX)
count value, and considered countable? If the that folio is somehow
reclaimed, we got a corrupted shadow (hib type is gone)?

If we have the count part of a hibernation slot be 0,
__swap_cache_add_check will fail natively, seems there will be no
such risk. A few existing helpers can also help catch potential
wrong freeing of hibernation slot. (underflow check).

The layout can be changed again afterwards.

How do you think?

