Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2458CC5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 16:48:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 024F06B00A2; Tue, 11 Aug 2026 12:48:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3F236B00A4; Tue, 11 Aug 2026 12:48:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E54B26B00A5; Tue, 11 Aug 2026 12:48:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AE33F6B00A2
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:48:49 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2DDF2C013D
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:48:49 +0000 (UTC)
X-FDA: 85089572778.20.AF6F381
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf12.hostedemail.com (Postfix) with ESMTP id 55A8D40002
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:48:47 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=r0tzDuzn;
	spf=pass (imf12.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786466927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OLBaiJQvXFC//um24aVUsRphyaJvRKwYbCegxqDVEAo=;
	b=1xLEyfPAeRNIaMMPqyONmYyGzpAYxDfDRSsclmUKYaCvbcgJyBQk/iSqFFopm1ardJK5q8
	YWrrE1kaH35XeyTrMVyC1/cJsD/YU2N2xiZL3Z+JPTqcWsfr1tJpw38k6tgBEPg8P3lNd6
	ffYkeL9reKKdhAPQSaYMxaDEfNwOW4Y=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=r0tzDuzn;
	spf=pass (imf12.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786466927;
	b=471AcRkaWil3yeq5MnoMIcdYOIj0V3Ntc5SbUTw44EuSNe1apbQeqqp9YiYLtIbvNtX+ae
	7ryisGSk6xh+fvmLaIOtGjigZ8IBNf/ybNKjfRTYrHEe1jUSNYcVIK98Q/Nqzhh4bmVB6L
	YqD0uMQkHHKy5UXQhLoVxp+eDlFhexw=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-84830c774a0so110126b3a.1
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 09:48:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786466926; x=1787071726; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OLBaiJQvXFC//um24aVUsRphyaJvRKwYbCegxqDVEAo=;
        b=r0tzDuznw8aCR4FwnxhG54Ufqbv2flqxHCv0ufY19cTLvqlqjXJS6nMKYp9K+NLffk
         t6AncF9nRBpCNf89rlf/3wNqHidxJIPEO75MAh4mZF0/sI0e6pFAlCTayzldA2CdnvvP
         hvB+ZPeom8RddlMKnWoxpjG/vG9KfpkNv/eyTdNxZWBrqH4eB7lFzHS0ew6DaFjZYNPT
         gAWB61+CHomXf2t6eGxph0N1HHIFDe9Rv2M1SOSqO+dP0F9+jq2QjrjNYXdB/VH2LXka
         wX0COkMCl6sZWrB6n05Um6l0cdnKfZ3bdumCKpwzfoAPZS8B7ysKT5htQjJiyO51oy30
         IdSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786466926; x=1787071726;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OLBaiJQvXFC//um24aVUsRphyaJvRKwYbCegxqDVEAo=;
        b=WEq6Nv2f0WuPYnNcOZx5dHOHtBFadb/kXFI+eOPSEbUZPMtbXR2gHshF80mTJ2r0x/
         8mdFaPmPt8bgL3aI3fi1TWN0sqO1PIl48xcbTYgdh0j9+GyCpC0ljsYZgGcx4oqCIosN
         EVi+kl5j2rFVG8TDjtLO/HjyPo4MGhKfvBw7sapWXTTmtiX8CQxJ/JVu2wmCXUKLAh1i
         U1NumUe/1G8Mgz8hUkGJJGYTQ0oaCJ3nrPpaXMGqbxBTwEO7nGxFxIkNGxyKgSrpClku
         gRseKAyFOrlJsQsTTyL1a2IGe++dZxOHQ2SDDGUXbF5C1B4UGTwQtD4CI5Aw5aVwVGGc
         6yuA==
X-Forwarded-Encrypted: i=1; AHgh+RoJPb9aJD9gnzB30DOQ1w5oKa7HEPwO/C45iwGamF8ItZpZKHrs4/tDeCmHmj4dXpUCHSCKcRcPDA==@kvack.org
X-Gm-Message-State: AOJu0YykKuvYS+CyKK1Z5szEcPt5nyamnQ0l/L7mW22h8RbQd5+n1GzJ
	joIkPFVdKnvbUQWVfLYLjvQefowJg8yTx5p93Me/MEUvcveNjujX3DHj
X-Gm-Gg: AR+sD101p0lpnry0Q7Y7ZoS7BI/0FWb/cod9/x7B74J95QWdH1BpiWN5VJGUD9XeNqW
	hp+8l53XZqL6gMjHx8qwl6lza//3z5kK5/NqHeybkuEoLhyOQC2MhUGkEkX/E5A5rNanH1tOU3G
	3eYVzGdLx3kkxmavrhNW1eM+XigQ3PRfPCUkU0xTDzQy2/hMnyNOliKjsSBVfswkRdiIkp+Xyry
	iaBtyQF1K7SrobaREpC+U1uYIbOAM7wMfx7cpAIYC7BkJQnqUd8ZspDOoSgtqcypM660e8uatlQ
	xv3KPqbqUBN0iIHMPjaTWjsuhopItbXQR94vi88Jb5JxM+RVoM5to/PwaAZgg++Dfi8XMmBlDnw
	Is+f2U8f46eGw9jvnDx20/PVOKm1/k0ORWfpB7m4KdCykDfynm2v39HUW/ICqmXffa9PmZOiu5Z
	bv90CyVR0NqUH+a6Lpb1EbWk7F8ytydpOZhwyxIW0MsgTos2PufdGr4Cs5B92zmEhr4Tm+r3nfy
	8x2x/yyXoFHcXQrsYzEKh2SFg==
X-Received: by 2002:a05:6a00:400c:b0:84f:7001:7a7f with SMTP id d2e1a72fcca58-84fa88a3b2fmr5152732b3a.36.1786466925897;
        Tue, 11 Aug 2026 09:48:45 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbed8ea1ecesm1283681a12.31.2026.08.11.09.48.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 09:48:45 -0700 (PDT)
Date: Wed, 12 Aug 2026 00:48:34 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Youngjun Park <youngjun.park@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Jianyue Wu <wujianyue000@gmail.com>, her0gyugyu@gmail.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/4] mm, swap: give hibernation swap slots their own
 swap table entry type
Message-ID: <ans-nAQ7dSyfPczI@KASONG-MC4>
References: <20260811132209.2862708-1-youngjun.park@lge.com>
 <20260811132209.2862708-4-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811132209.2862708-4-youngjun.park@lge.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 55A8D40002
X-Stat-Signature: oi4fe7n5cbee56cmnb5i36aasfnyht7b
X-Rspam-User: 
X-HE-Tag: 1786466927-662905
X-HE-Meta: U2FsdGVkX18xHbsWwLkQFkF0rYZr3N+CU/L9TQJOovCtqxfqlm3SuGQfX4uvUOuRKjm37Ht+nRFtPNgPLkJZ2FogwlMROd5E2Ns+I0qELelj4egbpbpe8itIZSlmkPdUaM7ZiOYsIjt8+q9+dUOuGMyewXzAudVNQtj9pF7YeU2xIcC//1ZPMr8FJgnnwWCEMKaUo0b7/FaryaC2k0Upc0EFYWv0RHzqOx1YvH+kg55sBMzNJT76sDe4MfIMvK30UmYaxRf6967tI083Pm46lEa3NX0NzUz7KrZ13XteqoadqdTismCb/Zly50k5HxLclLrW04hwxFnZY2IEtAV7Gt1GA52ZUxqqXgd+O79ff2AU/KhTdLDuCTpEvtYJKXfgZxrTRYF6f0ltmVIEgFTYjV8sfKrwCBMOUCNT952YeC5w/t4dN1hQ53KmC3cVKNYltAlZt4eaGAfK3xNhK6qVpBI1KzfbibAsxAgFDA2bsyqB5ZxpXZK0PP2C8PHHxHOa4j5qpdCoQmjLVDD5tEBErSmlFQ3P2u8fOROli9AYWs6KrB9d0GN7oLHAOuhqAxe8m5Ap0kpdZBc8fBfovelo+Pgytn460zt6eAK3y8pB//8y3CRO95ynxcgG3Y+Yxdk3lPbqpaCOnbnJ8s45hYgAC8EXlE0itEspbXvAUycPm57b834YW+pVcOlvkmCG2gWv/dHzgX2ie9m5MfiOBlMi05hgXf3GOtWkan22VBPTZkR5d4z73qi/DYdVKJXjHpQ7UKkZ5xGeRdHS4Ims9S+kiKgh7m8fmkC0oPYdzgPHqd3kq0iBXkt9YWrWBsEmIp3MMEG5mu0ZrCloBfu3CyVuZVoveQMCrSUF8QZ1GuYE9oAKt/jtWHa/h8Yo01ermM8MRu8Hg4DSZFw4FRWSzquMQFrN3MRHSbWEQEnshy+ses9v87xaFBqUi3hIz5IBb580+3dAbLZRlkredeaBuhW
 BHq0v/86
 vs4k7KUOzJboZvGKV2USTqwpp7b3G/5Q4H6mn5FOkrC1JMnUZn9rLIzH8Gel8d6OPNrbz4aKEIgplm8BB+QNxBElP2SBs2bTcmokWs/W3H52ElRWG7jtFuxAoJglz1xsbFBc3fCsd4TqofFxyToQtKb+m7XvsqmPSQtnSKEsIWUIMFDgnbdESarVJ7VXRKJN8XTuYh9NEePDlW5lfDPy0/k6msD/Tb5wmqSx8lJwx8qbou+Cqfd9KkJNXJ6gqMDIg8kJigReS+LjrHdEbCSHjEVnh9WfsBNbLZGDOY36l28eVLLht/GDSvil4L76sv7IKQLMOfoqbonmq9us+S2bmmDnAAfShHJgoqF9bVznkIrpljQTME4caCY4DHK9vWB3AsnsfXw3hcZmt6Bvlw6mtuGF52uAXc0NIULW0++GeZnNoHtIwHOxpV2cOyb6j98xPG8kGZEaPgt+wIEpSbBrRtJMlf6YJdZ6xJGBaMkJ1RkF/7CsSUVVX8rv6/RrJq6e1xX4H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 10:22:08PM +0800, Youngjun Park wrote:
> swap_alloc_hibernation_slot() stores a fake shadow in the slot it hands
> out.  An anon slot swapped out with no workingset shadow looks exactly the
> same, so nothing in mm can tell the two apart.
> 
> Give hibernation slots their own type.  Bit 4 and every bit above it are
> set, except the count field, which stays 0.  Bits 0 to 3 are taken by the
> shadow, PFN, pointer and bad marks, so bit 4 is the first free one.  The
> type holds no data, so the value alone says what it is.
> 
> The entry has no swap count.  Hibernation only allocates and frees a slot,
> so a count would never change.  swap_free_hibernation_slot() frees the slot
> directly, there is no count to put first.
> 
> The slot is no longer a shadow, so the previous patch keeps it out of the
> swap cache.  The count field stays 0 as well, so code that reads the count
> without checking the type sees an unused slot instead of one at
> SWP_TB_COUNT_MAX, and a wrong put is caught by the existing underflow
> check.
> 
> Suggested-by: Kairui Song <kasong@tencent.com>
> Link: https://lore.kernel.org/linux-mm/abp7aDgYLrxF3Me8@KASONG-MC4/
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> ---
>  mm/swap_table.h | 13 +++++++++++++
>  mm/swapfile.c   | 13 +++++++------
>  2 files changed, 20 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/swap_table.h b/mm/swap_table.h
> index e6613e62f8d0..b916a6493521 100644
> --- a/mm/swap_table.h
> +++ b/mm/swap_table.h
> @@ -30,6 +30,7 @@ struct swap_memcg_table {
>   * PFN:      |SWAP_COUNT|Z|------ PFN -------|10| - Cached slot
>   * Pointer:  |----------- Pointer ----------|100| - (Unused)
>   * Bad:      |------------- 1 -------------|1000| - Bad slot
> + * Hibern:   |    0     |------- 1 -------|10000| - Hibernation slot

Hibern is a odd name, but I don't have better idea for this... Maybe
just HIB, match the macro name?

>   *
>   * COUNT is `SWP_TB_COUNT_BITS` long, Z is the `SWP_TB_ZERO_FLAG` bit,
>   * and together they form the `SWP_TB_FLAGS_BITS` wide flags field.
> @@ -54,6 +55,10 @@ struct swap_memcg_table {
>   *   aligned pointers.
>   *
>   * - Bad: Swap slot is reserved, protects swap header or holes on swap devices.
> + *
> + * - Hibern: Swap slot is reserved by hibernation for the suspend image, and
> + *   must never enter the swap cache. The count field is kept 0 so it never
> + *   reads as a slot in use.

Not sure if the comment is a bit misleading. The slot is treated as in use
by allocator since it is not a NULL slot, kind of like a special pin, just
like swap cache pin, which also has a count == 0, until folio_dup_swap
is called. We can never dup a hibernate slot though, which is expected.
And we never add it to swap cache.

> @@ -2201,7 +2203,6 @@ void swap_free_hibernation_slot(swp_entry_t entry)
>  	pgoff_t offset = swp_offset(entry);
>  
>  	ci = swap_cluster_lock(si, offset);
> -	__swap_cluster_put_entry(ci, offset % SWAPFILE_CLUSTER);

Nice! We can free it directly now.

>  	/*
>  	 * A slot with a folio in the swap cache is freed when the folio
>  	 * leaves the cache, the same rule swap_put_entries_cluster() follows.
> -- 
> 2.48.1
> 

Just two trivial nit picks on doc, feel free to ignore, code looks
good to me, Thanks!

Acked-by: Kairui Song <kasong@tencent.com>

