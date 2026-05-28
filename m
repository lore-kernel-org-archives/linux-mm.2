Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 471E6CD5BD5
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 06:37:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D5BD6B0005; Thu, 28 May 2026 02:37:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 985DD6B0088; Thu, 28 May 2026 02:37:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89B8B6B008A; Thu, 28 May 2026 02:37:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 78C796B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 02:37:43 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2684E12046A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 06:37:43 +0000 (UTC)
X-FDA: 84815872806.22.AEDFC3D
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf31.hostedemail.com (Postfix) with ESMTP id 4AE7E20003
	for <linux-mm@kvack.org>; Thu, 28 May 2026 06:37:40 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=none;
	spf=pass (imf31.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779950261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HZ6IxvhMqjUGBTjHDLo6tubQL5kpPdWgOQqDyNrHzyM=;
	b=F1tHVJ5uAONXZxp7S3IN20i3VieUzsSWuG4BdCdZ7ckWXA/nYuMitwxe/xfeS3NOOSFjBo
	/fH1x28uWZ26LiiF6uBRGMZZYizkCDS2y19fjZtweYZYXCgu/uPe8RiH+9elc1kDoH158u
	yvsOh9kyFzynC83Jalrx623rMJdm9/4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=none;
	spf=pass (imf31.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779950261; a=rsa-sha256;
	cv=none;
	b=xeRD+6yrFvIY/c0pZxRmSVDDFZJCUbxN0jZxleNRICVUsQpG5/v827duUJ/EHFrNvc1T9D
	RlO7Or2nQ4DlbvbmM7LnMtrQLHE5nDaj978l6IMMZux9NL8oDZxbqc70SPgxMzjYs19Nsh
	LlPq+OOtK6kig5s6ugdOXXzhkJTLz7E=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gQxcd1tWTz8XrrX;
	Thu, 28 May 2026 14:37:37 +0800 (CST)
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl2.zte.com.cn with SMTP id 64S6bVS6031773;
	Thu, 28 May 2026 14:37:31 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Thu, 28 May 2026 14:37:33 +0800 (CST)
X-Zmail-TransId: 2afb6a17e2ad7af-39b90
X-Mailer: Zmail v1.0
Message-ID: <20260528143733563XhbDWw9ZGOiFU9KHd72Xu@zte.com.cn>
In-Reply-To: <44b8ba46-a002-4668-ab99-4bf01f4b66e5@kernel.org>
References: 20260527214840093l-oER8Ds4tJLCyI14we0S@zte.com.cn,44b8ba46-a002-4668-ab99-4bf01f4b66e5@kernel.org
Date: Thu, 28 May 2026 14:37:33 +0800 (CST)
Mime-Version: 1.0
From: <hu.shengming@zte.com.cn>
To: <vbabka@kernel.org>
Cc: <surenb@google.com>, <harry@kernel.org>, <akpm@linux-foundation.org>,
        <hao.li@linux.dev>, <cl@gentwo.org>, <rientjes@google.com>,
        <roman.gushchin@linux.dev>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <zhang.run@zte.com.cn>,
        <cai.qu@zte.com.cn>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2NF0gbW0vc2x1YjogdXNlIGVtcHR5IHNoZWFmIGhlbHBlcnMgZm9yIG92ZXJzaXplZCBzaGVhdmVz?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 64S6bVS6031773
X-TLS: YES
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Thu, 28 May 2026 14:37:37 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A17E2B1.000/4gQxcd1tWTz8XrrX
X-Stat-Signature: zn69ts5eihafyhzu83yg7y86qbzmwb4s
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4AE7E20003
X-HE-Tag: 1779950260-105922
X-HE-Meta: U2FsdGVkX1+7gZCzXu7WYEXx1DvZ/IcRd96RmOwDgt85NTHy0QYKAn6auTpzC+GwvuW9qYg2uacN4oXnQ/k0o7pp4Ab0hOLWIb+pGAXxe9W0VwlMgDuFdInZK7IlI02CD6Ac3gy2EA9JurHeGCpXL6q22Z2VsLQ2oqWQMvjElTUERWOZAlCR77/QoLK8Ph4Emsyqcrk14Jg/+d/S6facWgrk38HDMDiQ6dZH1gA2KNQ3SmslgIdcD0hWW+VOHi51SafVVRitgV81LGwN6a3BF3+GJKE6yv581i4UHgV1qcItdyWH9LlA3Qekt2YrJWO2f/AaQ+8oLFrVJf9Uu3PHIxZyRAPn2FTHA4jGKzTBzJuNLmqbTQZCvyZ1ChVY1i1MF/d5NHR+de1B1GqMaRQz0CGQz8tIeuUYw098qF6bsW3RNdt6plShCjp13eSCPPC/57voq/XNXXX5YojJmbr7uk9iTUillI3vZ6nwHYYbRdEo81wm6bslxt35OGs4A4mPkSzSDtZI/kGeaxTun6GZnbNS9hG846guPGYDcTCHURbt6eKbNCTNNMbyrSUpEojVaDwHa6NyQn/LXCnAUMCNcisz1z/If3byYiqSaIsUrCvGMAr1B5KNkuMMjpuw1aCht9CAzBCupScSx1CLk/ekchgK9d0pKdVb5IKvq27F1bAnbUAloC0j4T49/LEOf0NUAr1JEuLyeOyOM4qhGOXORDCRQPod/Yi2nv/VrQPGTnUwGp4yutu/SY1plhID/Q11jNZRjXqGB/Kald+5KulRk8KbyOu3QSuV/BNEH9Q2FZ9PnsdFd2vaPBLRVb1fveWPFU63nyUU3gRVsQKeqX+dByg0Qw1HOFFdOwBW3E2EePHLI/ATzmN7SSGPSCfTB+mjueHDAEKf9NPFyODxtlbdrjaLzMvpqD+MpoC39H5XxwXXXBuK6HLHpZfezZu67mo80BViaDBMaVhMS/i1v2N
 IpUu4GfP
 Xhb9GxNfBqNTkYSluiq1c+e1agn2VSpWJcV1bEeUvZOWFeOzwkTTo3dav6Uh0XDWhXs26NdjfUf3shhjcDaCYgUAYSak65KN9EKdr8cDaxb/QdFP6ssqU/sbqmK5jw9CsVydeQ5XrmNx7QAlz0jhQ/sosYI3Ls83zj5vp0DhYhao/bInUrqGDMh1chN1odtUet2HmeKxKuL5Plk0Dn79xK7upJAFiMC+QvK/2+sYs/HRGzglIdVLaHGjRhg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

VlastimilBabka(SUSE)<vbabka@kernel.org> wrote:
>On 5/27/26 15:48, hu.shengming@zte.com.cn wrote:
>> VlastimilBabka(SUSE)<vbabka@kernel.org> wrote:
>>> On 5/26/26 17:24, hu.shengming@zte.com.cn wrote:
>>> > From: Shengming Hu <hu.shengming@zte.com.cn>
>>> > 
>>> > Oversized prefilled sheaves are allocated separately, but after they are
>>> > flushed they are empty sheaves as well. Release them through
>>> > free_empty_sheaf() instead of calling kfree() directly.
>>> > 
>>> > Use __alloc_empty_sheaf() for oversized prefilled sheaves as well, so
>>> > that they are allocated through the same helper as regular empty sheaves
>>> > and released through the matching helper.
>>> > 
>>> > Since oversized sheaves are now allocated and freed through the empty
>>> > sheaf helpers, SHEAF_ALLOC and SHEAF_FREE also account for oversized
>>> > sheaves. Update the stat comments accordingly.
>>> > 
>>> > This keeps the oversized and pfmemalloc prefill paths consistent after
>>> > flushing.
>>> > 
>>> > Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
>>> 
>>> Hmm, __alloc_empty_sheaf() does "gfp &= ~OBJCGS_CLEAR_MASK" which includes
>>> __GFP_NOFAIL. A caller of kmem_cache_prefill_sheaf() with __GFP_NOFAIL might
>>> not expect failure. The __GFP_NO_OBJ_EXT handling is also not necessary for
>>> prefilled sheaves.
>>> 
>>> Well maybe all the gfp handling could be simply moved to
>>> alloc_empty_sheaf()? The other caller of __alloc_empty_sheaf() is
>>> bootstrap_cache_sheaves() and I think it doesn't need it either.
>>> 
>> 
>> Thanks for the review!
>> 
>> I agree that clearing OBJCGS_CLEAR_MASK in __alloc_empty_sheaf()
>> is not right for the oversized prefill path. In particular, it changes
>> the caller-provided GFP flags and can drop __GFP_NOFAIL. I will move that
>> part out of __alloc_empty_sheaf().
>> 
>> I am less sure about moving the __GFP_NO_OBJ_EXT handling out of
>> __alloc_empty_sheaf() as well, because that seems to make the free side
>> more complicated.
>> 
>> Currently free_empty_sheaf() assumes that sheaves for SLAB_KMALLOC caches
>> were allocated with __GFP_NO_OBJ_EXT, and therefore calls
>> mark_obj_codetag_empty() before kfree(). If __GFP_NO_OBJ_EXT is moved out
>> of __alloc_empty_sheaf(), then oversized prefilled sheaves allocated by
>> the raw helper would not have that flag anymore, while regular sheaves
>> allocated through alloc_empty_sheaf() would still have it.
>> 
>> In that case, the return path could no longer use one free helper for both
>> oversized and pfmemalloc sheaves after flushing. It would need to split
>> the two cases, for example:
>> 
>>         if (unlikely(sheaf->capacity != s->sheaf_capacity)) {
>>                 sheaf_flush_unused(s, sheaf);
>>                 __free_empty_sheaf(s, sheaf);
>>                 return;
>>         }
>> 
>>         if (unlikely(sheaf->pfmemalloc)) {
>>                 sheaf_flush_unused(s, sheaf);
>>                 free_empty_sheaf(s, sheaf);
>>                 return;
>>         }
>> 
>> There is also the bootstrap_cache_sheaves() case. The sheaves allocated
>> there are regular-sized sheaves. If such a sheaf later reaches
>> kmem_cache_return_sheaf(), it could not safely be released through
>> free_empty_sheaf() unless it was also allocated with __GFP_NO_OBJ_EXT,
>> because free_empty_sheaf() currently assumes that SLAB_KMALLOC sheaves
>> were allocated with __GFP_NO_OBJ_EXT and calls mark_obj_codetag_empty().
>> Unlike oversized sheaves, these bootstrap-created sheaves have the regular
>> capacity, so the return path cannot distinguish them by
>> sheaf->capacity != s->sheaf_capacity.
>> 
>> So I wonder if it would be better to move only the OBJCGS_CLEAR_MASK
>> clearing out of __alloc_empty_sheaf(), but keep the __GFP_NO_OBJ_EXT
>> handling there. That would fix the __GFP_NOFAIL issue for oversized
>> prefilled sheaves, while still keeping the allocation/free assumptions
>> consistent and allowing flushed oversized and pfmemalloc sheaves to use
>> the same free_empty_sheaf() path.
>> 
>> Would this approach be acceptable, or did I misunderstand your suggestion?
>
> I see, thanks. Could we perhaps move the mark_obj_codetag_empty() code to
> alloc_empty_sheaf()? If not, then do as you suggest?
>

I looked at moving mark_obj_codetag_empty() to alloc_empty_sheaf(), but I
don't think it is equivalent to doing it on the free path.

mark_obj_codetag_empty() only marks an entry if the slab already has
slabobj_exts. For sheaf metadata allocated with __GFP_NO_OBJ_EXT, the
allocation hook will not create the object extension. So if the slab has
no obj_exts at allocation time, an allocation-time mark would be a no-op.
A slabobj_ext can still be created later for the same kmalloc slab by
another allocation, and then freeing the sheaf without marking it on the
free path can still leave the sheaf entry with a NULL tag.

So I think the marking should stay in free_empty_sheaf(). I can still
move the caller-GFP filtering out of __alloc_empty_sheaf(). That includes
both clearing OBJCGS_CLEAR_MASK and handling the early rejection of
caller-supplied __GFP_NO_OBJ_EXT:

	if (gfp & __GFP_NO_OBJ_EXT)
		return NULL;

Moving this filtering to the caller would let the oversized prefill path
avoid losing __GFP_NOFAIL.But I would keep the SLAB_KMALLOC-specific
__GFP_NO_OBJ_EXT allocation and the matching free-time mark together.

Please let me know if you have a better suggestion.

--
With Best Regards,
Shengming

