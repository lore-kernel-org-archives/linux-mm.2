Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2250CD5BD0
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 13:48:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C8EF6B009F; Wed, 27 May 2026 09:48:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 379CC6B00A1; Wed, 27 May 2026 09:48:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2936A6B00A2; Wed, 27 May 2026 09:48:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1B3146B009F
	for <linux-mm@kvack.org>; Wed, 27 May 2026 09:48:49 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B6E081C0488
	for <linux-mm@kvack.org>; Wed, 27 May 2026 13:48:48 +0000 (UTC)
X-FDA: 84813330336.11.12CAEDA
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf28.hostedemail.com (Postfix) with ESMTP id 608C7C0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 13:48:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of hu.shengming@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779889726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ftny/bTV15cwUnhuT4t5nIXsSBznlD+dP8glqqty/ok=;
	b=KRuZlQd8F6AjDzBeojX2AvGhTIWNJpv/JxLbCya45jyx99BVObF89/E9BMrNgxbrBHFi+a
	tfVw+vqhmmaoZzUytqT+OOVt7vsQPqA0gNdbEixRiInd4pOVemmPzma4d2yXWE3eK4fjwa
	pXL97ProvH8OR6CEvFMrp5LDn8aI1JA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of hu.shengming@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779889726; a=rsa-sha256;
	cv=none;
	b=WKXKuwE0uY5khYbYRwVq6pUp5Rz4S10fppAsmaQD9sxQn/IBUbncxmQ4gRRTiLEEWeYqDF
	7mlMg4sXXDMA79exRCmw6Vo+3dODDltiluxePmekkZ1NJJvr6VLQM+vUV0/U1nK/ygoUXt
	e8/2jP1HVj1Jvh1SRCBLTn5epU5ymKc=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4gQWDP3j5Sz4xNtN;
	Wed, 27 May 2026 21:48:37 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl2.zte.com.cn with SMTP id 64RDmaEt073328;
	Wed, 27 May 2026 21:48:37 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Wed, 27 May 2026 21:48:40 +0800 (CST)
X-Zmail-TransId: 2afc6a16f638487-f5ca7
X-Mailer: Zmail v1.0
Message-ID: <20260527214840093l-oER8Ds4tJLCyI14we0S@zte.com.cn>
In-Reply-To: <8c5bf213-399b-4fa1-835a-36d906061e88@kernel.org>
References: 20260526232429176aHA6oZjTYdhXcZVHc2ZQ-@zte.com.cn,8c5bf213-399b-4fa1-835a-36d906061e88@kernel.org
Date: Wed, 27 May 2026 21:48:40 +0800 (CST)
Mime-Version: 1.0
From: <hu.shengming@zte.com.cn>
To: <vbabka@kernel.org>
Cc: <harry@kernel.org>, <akpm@linux-foundation.org>, <hao.li@linux.dev>,
        <cl@gentwo.org>, <rientjes@google.com>, <roman.gushchin@linux.dev>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <zhang.run@zte.com.cn>, <cai.qu@zte.com.cn>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2NF0gbW0vc2x1YjogdXNlIGVtcHR5IHNoZWFmIGhlbHBlcnMgZm9yIG92ZXJzaXplZCBzaGVhdmVz?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 64RDmaEt073328
X-TLS: YES
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Wed, 27 May 2026 21:48:37 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A16F635.000/4gQWDP3j5Sz4xNtN
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 608C7C0005
X-Stat-Signature: srq4fqhc9ac6kjzy6piin19jk41aeomy
X-HE-Tag: 1779889726-953572
X-HE-Meta: U2FsdGVkX18AGDRFN5MKMsoq7q1h+99Mf+hEBAoEjp7KObvZh2LFRpycp+vMq5vsLfAHI7k55ESAM+j4o4p81A6gvTUaIt/lzmQOGOOn92zN4bdRqicpaImHbnAPe9Fh013zgss8LSkU6OV2rNlmh8VRzyzixTBMBLpbCj0jgu2XtXyg6v3Ji4sv8JQcytJFENQXOClfMg/2yq6eejDMTiq9deiEn/uF6uxeacvqr9Xy96tS9rDDi4wlWyzeVM5Shuhh9ZYCDrQFgog8xC+wuNPCz469X1JjItSIjHX9/EN05OUC5gM8YQwr3kW2tmIVZD9I+U+0+fbddovS34CpOchMW9t2d1kCkGRbbsAMNXG3XjRh9kxh8qVmVyM51r1fu9zlH4y4NA64RiRpgQviyHRPNDXdsbNPsQ1RrlFAOM/mxNGm50Q05VWFWvmaDJuWKjiTEzjZ89bK6vzl8QpQhT9jK38YUjVXvLjpzMUDW/UbWKe3X8JKbtRA6WofWiu07lOgT4E6s9R7XTVhGq8g0+e+E8IweYpcSRBUhIaZPFP0KXHQD1gjY/4OOD66meSM0ugh67cvQliE+iVVBewVonmPEg+QlcyYyuIO6KZFu75WYS63MTKT20i86H75s0U4cLoImxtL2cG4cpAYh2753oPquPyVHLa6lv2QTSxE8qnThMydheyibyQ120WojCFS5GTpTCzhkFN6M4WS8vidPUjnuLS2At2K7xtdZ5kR1zMQdshRD8wseh7qf63rY+kuh3pKQahhnLkBSkeJFKierP93/BbM8ZsrAnNo6ld3SPycUA37r9Uu0ooN4FFGymDSVxtx5XxDeFodNdwjRHOrobjQlcd3F4RItVmUlki2ltpILZv86RNbFM0xZdvhp7MV1iLdIet4q6nOG2ERmT5SKMbIzf1TCthFGeFPzOG9v0ooYvuh2WLawPFlGNrawCO3O2h7eZWKCFsPnVI5VAH
 LhDMIjmc
 OjpBwM5N+ZBL/v8GjKEbldxDea7gIByUHDKvya432ckirSEE6f2+S/Nqq5ue2KGGCAkaujrWeROPM5yhHy1libw2F7p/+QaLSv9N3M7jK1//nmhAebukvCEsBBd8m6h2xCTpPiYE/5MPblvnliIxjc755Sy9uJUmCgOZOUof0QwXx2OHKLMnmulOWzA4kV1WGK5OX2kNN7gh9b/H683+TBoAdryMIOBC3SoNNppKrzx65JK8Imi8AzKKG9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

VlastimilBabka(SUSE)<vbabka@kernel.org> wrote:
> On 5/26/26 17:24, hu.shengming@zte.com.cn wrote:
> > From: Shengming Hu <hu.shengming@zte.com.cn>
> > 
> > Oversized prefilled sheaves are allocated separately, but after they are
> > flushed they are empty sheaves as well. Release them through
> > free_empty_sheaf() instead of calling kfree() directly.
> > 
> > Use __alloc_empty_sheaf() for oversized prefilled sheaves as well, so
> > that they are allocated through the same helper as regular empty sheaves
> > and released through the matching helper.
> > 
> > Since oversized sheaves are now allocated and freed through the empty
> > sheaf helpers, SHEAF_ALLOC and SHEAF_FREE also account for oversized
> > sheaves. Update the stat comments accordingly.
> > 
> > This keeps the oversized and pfmemalloc prefill paths consistent after
> > flushing.
> > 
> > Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
> 
> Hmm, __alloc_empty_sheaf() does "gfp &= ~OBJCGS_CLEAR_MASK" which includes
> __GFP_NOFAIL. A caller of kmem_cache_prefill_sheaf() with __GFP_NOFAIL might
> not expect failure. The __GFP_NO_OBJ_EXT handling is also not necessary for
> prefilled sheaves.
> 
> Well maybe all the gfp handling could be simply moved to
> alloc_empty_sheaf()? The other caller of __alloc_empty_sheaf() is
> bootstrap_cache_sheaves() and I think it doesn't need it either.
> 

Thanks for the review!

I agree that clearing OBJCGS_CLEAR_MASK in __alloc_empty_sheaf()
is not right for the oversized prefill path. In particular, it changes
the caller-provided GFP flags and can drop __GFP_NOFAIL. I will move that
part out of __alloc_empty_sheaf().

I am less sure about moving the __GFP_NO_OBJ_EXT handling out of
__alloc_empty_sheaf() as well, because that seems to make the free side
more complicated.

Currently free_empty_sheaf() assumes that sheaves for SLAB_KMALLOC caches
were allocated with __GFP_NO_OBJ_EXT, and therefore calls
mark_obj_codetag_empty() before kfree(). If __GFP_NO_OBJ_EXT is moved out
of __alloc_empty_sheaf(), then oversized prefilled sheaves allocated by
the raw helper would not have that flag anymore, while regular sheaves
allocated through alloc_empty_sheaf() would still have it.

In that case, the return path could no longer use one free helper for both
oversized and pfmemalloc sheaves after flushing. It would need to split
the two cases, for example:

        if (unlikely(sheaf->capacity != s->sheaf_capacity)) {
                sheaf_flush_unused(s, sheaf);
                __free_empty_sheaf(s, sheaf);
                return;
        }

        if (unlikely(sheaf->pfmemalloc)) {
                sheaf_flush_unused(s, sheaf);
                free_empty_sheaf(s, sheaf);
                return;
        }

There is also the bootstrap_cache_sheaves() case. The sheaves allocated
there are regular-sized sheaves. If such a sheaf later reaches
kmem_cache_return_sheaf(), it could not safely be released through
free_empty_sheaf() unless it was also allocated with __GFP_NO_OBJ_EXT,
because free_empty_sheaf() currently assumes that SLAB_KMALLOC sheaves
were allocated with __GFP_NO_OBJ_EXT and calls mark_obj_codetag_empty().
Unlike oversized sheaves, these bootstrap-created sheaves have the regular
capacity, so the return path cannot distinguish them by
sheaf->capacity != s->sheaf_capacity.

So I wonder if it would be better to move only the OBJCGS_CLEAR_MASK
clearing out of __alloc_empty_sheaf(), but keep the __GFP_NO_OBJ_EXT
handling there. That would fix the __GFP_NOFAIL issue for oversized
prefilled sheaves, while still keeping the allocation/free assumptions
consistent and allowing flushed oversized and pfmemalloc sheaves to use
the same free_empty_sheaf() path.

Would this approach be acceptable, or did I misunderstand your suggestion?

--
With Best Regards,
Shengming

