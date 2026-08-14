Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE782C5CFCF
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 16:07:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA89B6B06E8; Fri, 14 Aug 2026 12:07:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C39DC6B06E9; Fri, 14 Aug 2026 12:07:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B20486B06EA; Fri, 14 Aug 2026 12:07:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 859766B06E8
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 12:07:49 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 139911C01C5
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 16:07:49 +0000 (UTC)
X-FDA: 85100355858.22.3D6AAAE
Received: from fhigh-a3-smtp.messagingengine.com (fhigh-a3-smtp.messagingengine.com [103.168.172.154])
	by imf31.hostedemail.com (Postfix) with ESMTP id F41462000A
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 16:07:46 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=sandeen.net header.s=fm3 header.b=WWV0Ay2L;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="W 6zcFx4";
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of sandeen@sandeen.net designates 103.168.172.154 as permitted sender) smtp.mailfrom=sandeen@sandeen.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786723667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VNUlU/tHnoQ5KDHu9/pwcilla1bjI0FIeW4BddgKQBc=;
	b=8BHTS6JSVROmsj+yXuYLCl2VdXHMccUQMfFINK5GkNzzc/+KssYNG8uY04gm+VOqGh5I3e
	yl0KkVDCHaiQJZWzUZP3kNa/2t3LTWXp7K6WXKM1DOMqYIPu1vtp7DCYqcdccfuyqM5AWy
	tivCTxJL5C/8wk2lNAyho55E8W7UqLA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=sandeen.net header.s=fm3 header.b=WWV0Ay2L;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="W 6zcFx4";
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of sandeen@sandeen.net designates 103.168.172.154 as permitted sender) smtp.mailfrom=sandeen@sandeen.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786723667;
	b=q4Slniy/oGs+URgRwHdo+53ReVFCrIrwtkcJuGhNDD/xfWgJB54d5971uK6WN8hlyfEvbC
	dJaswcFsgqS6F8pAuaFVgYcrS3rKZw0xSD6BtD5vjyHXImb+AXuQUs945tlaAa3FYtvX1p
	EnFEdeTg0iHd6+GKEtPywlXKtMuh+Pk=
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 902D2140006E;
	Fri, 14 Aug 2026 12:07:46 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-11.internal (MEProxy); Fri, 14 Aug 2026 12:07:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1786723666;
	 x=1786810066; bh=VNUlU/tHnoQ5KDHu9/pwcilla1bjI0FIeW4BddgKQBc=; b=
	WWV0Ay2Lv2g6nJD1eMeeADJcg1hXu9q+Ig/bW9KSy8WvPrI9jq9gwV3uhVHEu9mE
	2g2D4GgpRqKP9bBVlc69R2siwCzKR2IbpovPwMnpQ5nO1r/oCotLS+VPvE2ODUtf
	f6PAHVC4DcqKpEdFoOtJzGg1BSBg4kCpHP2SzRl+hc3iaCgsfbmnd7Uj35w3ChUM
	oWbMbM+Dby4Kh2TwbB7zORSNhe/atnvj4F0z2uYBYeuKyeVxiZKQXrylLQIqDMx/
	uMjlwZzIgBcAMe4HUqZFk1/wJZ7fedZcxlCnFN6YYj1N9vvqa9WI4nlnhLZd4YfD
	U3F8wHVWrUtCxyqv99V+sg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1786723666; x=
	1786810066; bh=VNUlU/tHnoQ5KDHu9/pwcilla1bjI0FIeW4BddgKQBc=; b=W
	6zcFx4v8FoQxnwG+6XLw3MchzLeewgQBmm99fdPKNEj7rzYDFUupqA0zJSJnuTUP
	ipfoM+15ktKk6SGYyClb7X/E3mUXj8oK6tSJu0Ujut/3NVyu8xBB9HvyUbHIIyAC
	KhvGKndfbFkG57BFRwWsaSrVNoh6o42k0vu6NvY/pjlUCzqulAtMbz7Az/ltsBli
	urZ2HfaGh/zbtSVncBzIMM45X+44iwAmWHx5SsfBnszwvtALk8E/Ab4c1IBSdu2h
	jfiegwshFTq3tElMEJhw082FwmBlglfh31xmCgt+dfth/j3kegZrTQwy/e12kJzU
	2zCik4n/UPGI6IOktUkXQ==
X-ME-Sender: <xms:Uj1_ahuSmJO47iQSTkmN1cOlviXPbEkaMD6mGIjs33qmVG6uIxrxbQ>
    <xme:Uj1_ahc4TWnCXT_KgDLbnL2VsRM6RZtV6yh6-bkhk7AHNWa_M7uexqVBrXCnN3QGY
    yEGW2CEAKEtKyJWXSdRTtjeChgF3Bab_hqk908J0-76COD-ynB3x81R>
X-ME-Received: <xmr:Uj1_apyZY0vqZ3HaX3wmMK_WEEUmBB20x9PMY9RGomz1H_Tf_L9HUIsVcLLwqbvzh1jg0OjsBaY7FaAOUz3si2of>
X-ME-Proxy-Cause: dmFkZTGjgA0y5oBk/MpKva3iNFZXJBWtc6+Fce5oVa8b4osBsgvkoNzuWwmcenbYIZsUJN
    6MjE3HaFHLT5On+1P7Hen5P0rxkjejejrzObPDACCec4UlYvluy50NTfRyJ9C+9n+QkgvE
    ghSW0S4WLWei6nrsQKEmQj+mSpNVlcjWpLZoJcT7YXZo8rPvqNY6l1SgJOtiV3LWhzJ/ap
    KGjFNWewFzFDdsIvjQ5UtmB0yzph0+JfGpAM8U8KPSUR8yNZGXySeI+toc1to1C9+EPeD0
    5J2uYhYAKqJh2E3JmgCO8+5BGLMyp3oc8OoFJZ7Rij5Pn2vW3LZBZz0DhOH5jmfDxSaeOK
    pK2s9ijyy2mjmBTy8LGNhgaX98U4hshparW5G6LthA/hG/wwrgYJi/tkvl2MfklK/F0yg7
    Cnv4l0dr90mYmelJy6pjtTPbMLvWJlCGNTrZ4iPmjirjaaFbqirFrC7Kz0Xzf8qMmM4Yvb
    YIfTgWsZrCP5hm/qlZt7HujLrFDrqvWHBFTal4EYDLVFLLciCrjyE4jBuapXTqFmKq2lW3
    +2mYe3y317oE2ZQSscKnONgcyrE8VZE2GADaNEUbLkdHvHteSH+ZBr41LC+yCvK8Ost+kw
    edri7PL0wctKozKGoCk8vYUVXYuUyKqX9mkWoyQRGa1nZ/ytIT6fOC/O3/Uw
X-ME-Proxy: <xmx:Uj1_anGdWlLZo3yrwclw4FhVaTEy8apVikZvnLd2cm6MkmvXfUUXdQ>
    <xmx:Uj1_atzEdUmE3cKrPy5VBpPHkhqtSsKduMVJdbYC_RJN0TtiopzlnA>
    <xmx:Uj1_aovHaKeVLOMli6CAT7S494Y4VAHWlKV2JJjXkMo_qI7SMEaVmQ>
    <xmx:Uj1_aq3r8nDmK1TXGVD9QqjM6W9cCfM4XGUu91r6yBrM7cL-UM3Ztw>
    <xmx:Uj1_ahhp3wrnu4DTfOoLrYq_-5x86AG2SUaowlHXnMh_YEau39d2o-lD>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 14 Aug 2026 12:07:45 -0400 (EDT)
Message-ID: <11c14c65-8609-4482-b3d1-23d4d36afd66@sandeen.net>
Date: Fri, 14 Aug 2026 11:07:45 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: xfs: properly account xfs_buf items as reclaimable
To: Dave Chinner <dgc@kernel.org>, Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, linux-mm@kvack.org
References: <20260813204929.2253988-1-sandeen@redhat.com>
 <an7D_9YRVDG-0Qjq@dread>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <an7D_9YRVDG-0Qjq@dread>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: oaojmyo89zyph9fsbytmhnjaqaj4ykkc
X-Rspamd-Queue-Id: F41462000A
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786723666-75132
X-HE-Meta: U2FsdGVkX1+7Db/fppcD/a+nlG//nPgzH0XfySeN0AqvvvrOUP9us2bJIARso99Ltc917XEzjRXMHS08U+7dFcTaXf7hw7QcvxZ0SCAS4IhmOYGBCqZ0apBCUq1Frym+uKDaCE9adamNBKtf96ME3GtxjOA+wgN4JLH5bKQmm76qGjhVwJUcV+LPB0EP2fK7lo5BTolTvxhWptW+RBCSdjVd9n1t2S8JyDcqNz6f8lnKSz0Iis/zkvE7goSOPoND2JTXeulem5lweFhNYGuTAVTaryv1j0AvWZHhnTL7F7R17WUBnASUz40t3eMiX0mhbew9qwgDYzlf6JSUyGHkziBMl1Cym5T26CbyrNaKqs/42SdsFQ+hnYjria5K3vth/8ffVKJ2wlQyv409TNcENBbCXKmicdG47HRY7mVzKrYBd7eGpq/AIQ1PkzaZxZTgh/Y8r0/9Lqzif/qoZAQQ97aspwsX0YU4b1Rv4psrmbvJHiwtzlS27DnSMYfujgXFDqCgS2Vjs/juaoLlNutz6dVMr/h7V8v/RirHXQ2oT/YKhd9PsstUDnyGbrN5WSS6zdF/GqiF1KVmIWjHi18s9/pn2eDwFKtPHXAmDvghgSn7PoBZnqXr3eY3evo8HrZFGI1rjcNfPxjIz2AIEtw0ufwn8cZcf7U9ZREQcFMj/cxNQgjp2geTWPmR2/u9ZpJAGNsVglI3oimcJtgyRz/92p19CIuY9kbrAUvHGGrVSko6d1l0a7bCgeRRwLL4ZyYIa6B80v88vvbpE8yAhlXxsF1YC9dRdVxjA/cG2ifwwAv/3ylhovIUhtf/t2V77kSVoNcBaDiTjNIasc387/25a6FnJt+cf3qgH4RMaeQ9pJ4phGFUHQBNPmOLdE1PVFqV/6b92QUZIRS3d+vh0mmCa3oV3auyquOeHhzAOsq2wCOZZ+dQDYNU1Gjy4Ma2T+pmCG8xsAxabsA5Sc11zaK
 ThEkcYZB
 9ZKkQX/Xy3kRLIH9oe4DJS9jAir6nLEhV+lvLzC8c1belnRCABFal6ZUfZ/aw7flTaIK2Nt/bs82OrnyLO+HBNEx4WiByJF07PxWysvOMdhvWEcgxPL7NDxoUuD5Ky95tZ2PWBMo57hIUo16PA8tXhZBwrjAQzcaAalYVJIX7xOSgJP1Wl7ieyKpKRIHf934PXEGZac/DO+gDp9z5STdqRxW2Z60riqxdTzW7EHunk0FDEQtzZiqiIfDr+vnHcImBisFkV9XYOzcGqE6OCx6ztxKikLwIBqjKeBaA1my/M/f1yyivwt2qBJsomcoT/NmhR/zmf61AU8f2ZQQaIUYSPQLYlcrgr9kL/xdl2WkV0zbUJb8Y1s5ErrwYyGOM6mr3Ctrixjov/dIutq0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/14/26 2:30 AM, Dave Chinner wrote:
> On Thu, Aug 13, 2026 at 03:40:51PM -0500, Eric Sandeen wrote:
>> It was reported that xfs_buf items are not accounted for as
>> reclaimable,
> 
> Actually, they are:
> 
>         xfs_buf_cache = kmem_cache_create("xfs_buf", sizeof(struct xfs_buf), 0,
>                                          SLAB_HWCACHE_ALIGN |
>>>>>>>                                   SLAB_RECLAIM_ACCOUNT,
>                                          NULL);
> 
> So the xfs_buf items themselves are accounted as reclaimable slab
> objects, and these are what the xfs_buf shrinker itself acts on.
> 
>> and therefore various statistics in /proc/meminfo
>> and /proc/vmstat do not reflect their reclaimable nature as
>> other slab-allocated items with shrinkers would do, which in
>> turn affects the accuracy of stats such as MemAvailable.
>>
>> 2 patches here to add accounting for xfs_bufs allocated via
>> xfs_buf_alloc_kmem() and via xfs_buf_alloc_folio().
> 
> That's accounting for the memory attached to the xfs_buf, not the
> xfs_buf itself. 

Yeah, sorry, I was sloppy/wrong in the cover letter. Tracking the
reclaimable memory attached to the xfs_buf items is the intent
here.

> We don't use the size of that memory for reclaim
> purposes, hence we haven't ever tracked it. It is, however, fed back
> into shrinker based memory reclaim via mm_account_reclaimed_pages()
> in xfs_buf_free() and hence memory reclaim correctly tracks how much
> memory was released by the xfs_buf shrinker scan, even if the user
> visible stats don't show it.

I guess that's the crux of the question: should those stats show it?

>> I was not sure how to handle xfs_buf_alloc_vmalloc but I think
>> that's a relatively rare path, and the above two will capture
>> the majority of xfs_buf allocations.
> 
> I think both folio and vmalloc should be accounted in the same
> manner - as a number of pages based on the size of the buffer (i.e.
> same as mm_account_reclaimed_pages() does already). It doesn't
> matter if it is vmalloc or a high order folio, the amount of memory
> is the same.  If it gets accounted to the node of the first folio,
> then it will at least always be consistently accounted, if not
> always 100% accurate for the vmalloc case.

OK fair.

>> I've cc:d linux-mm just because i think this is the first
>> user of NR_KERNEL_MISC_RECLAIMABLE in the tree?
> 
> These are fs buffers - shouldn't they be accounted as something that
> reports as "cached" or "buffers" in /proc/meminfo? I mean, if you're
> going to do this to make meminfo/vmstat report the memory usage,
> shouldn't we make the effort to classify the memory usage correctly
> for the user?

I'm not sure. NR_KERNEL_MISC_RECLAIMABLE says it's for
"reclaimable non-slab kernel pages" and that seemed appropriate for
this case; they really aren't the same as page cache?

The commit (b29940c1abd7) that created NR_KERNEL_MISC_RECLAIMABLE
renamed it from NR_INDIRECTLY_RECLAIMABLE_BYTES, and said it was
"still useful for accounting direct page allocations (i.e. not slab)
with a shrinker" so it seemed appropriate but clearly I'm a bit out
of my depth here.

Thanks,
-Eric

> Cheers,
> 
> Dave.
> 


