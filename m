Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E41F1C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 17:03:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF9566B008A; Wed,  8 Jul 2026 13:03:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD0626B008C; Wed,  8 Jul 2026 13:03:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0E8B6B0092; Wed,  8 Jul 2026 13:03:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 772006B008A
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 13:03:12 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E7377168ADE
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 17:03:11 +0000 (UTC)
X-FDA: 84966229782.01.205E497
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1E12E18000A
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 17:03:09 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Mg5MW7op;
	spf=pass (imf16.hostedemail.com: domain of praan@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783530190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0rcxz3xIlmj9F6FAJyNtBM4J//L5BtHyiG09PcS+rH0=;
	b=23E7v4dEcYoqOaIpRXqv1Ge0rl8hXDW+Rfa3z4s4hKL8cPvNKQJWpKwwRDTB+TBr4l1Vsk
	MdIXGbLGtNg5RK4OWOOe+hIIzHDvCgTpumcG354Y03w6f9PB3T13UjzwJ8TmXFchMlcbuF
	iSDa1bmZNyv3xMK+CiMO0In7/3H8zlU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Mg5MW7op;
	spf=pass (imf16.hostedemail.com: domain of praan@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783530190;
	b=DyDVVuocRxEL0Kkh2x5kSL2+7a2Pc6ZOP1BixNmsF8zh00aAKYpnG61+Ny6i85gHDZIqCF
	cwLmxz0SPwjc/enTD4ASdD+iNWMgD7k6bNYkshdxbB7BpwBPDrnfOTr37WrMgsohC02pyk
	vMVUU9OIguZjfoTrVknnEr2Vwnbyh3I=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2cab97c86bdso1075ad.1
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 10:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783530189; x=1784134989; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0rcxz3xIlmj9F6FAJyNtBM4J//L5BtHyiG09PcS+rH0=;
        b=Mg5MW7opRF9Jx4IxYF7jf0x3UaY6J+ddGLKy5QMCy8BjnB0NyITHkAmmBTFbeWnEJk
         vzzB7+jWs7mSJvZ9xMdW2Fch4CXz1mZaocipOcwYvRmvGl8+nyZZwA/Snu3FnMrNTx2Q
         2Eo5eUdA3fbnADcpRC2JraAe2yCjvX8MDfQ5OQnN6vPfe7JM7dZZlz9MSX4xflFbUOSe
         1GYgv3kVg1Gj2n9BojXPsIyl7lCA+p/qoYyFYgjisFwBJWzNFkb52k9nJES6yo8CIv6f
         CgmqFNCwz/3B5RHI1Rs4Ajh1c09sntNZ/C01uM0TxMNR0EOLev56ixNSFwGssx467yoi
         goUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783530189; x=1784134989;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0rcxz3xIlmj9F6FAJyNtBM4J//L5BtHyiG09PcS+rH0=;
        b=SUwpRm2uxM16GRLI/rGMpzFBGBeBI2AUTezCBQDchmEXb6WMQkJ68alqoclGKcKuTH
         WZj4VUCEfV99FrrKVCFLxW9uJfcQ2A3XvN/SCgFZ0ZMffU1c8rbXBVHamf1jkYGfLMD3
         LEceD6msDmjpXhELRFBdmFyXGyAmvI7CyvGVABhd1CQ8kirweEQnZwYh87n9maLw17hx
         ui9JifFwS2buRFkPT+EboHWu7cFXFTVn+QpQ/6dY4sApEQkSdkTCQK3BbO1pbwZk/oGN
         +JH1BxrHvjzrjj3d66I9T1AoOCKuGJ3SAsMBsVhkxl5Y8N7cy++afTTf4KfHuqaoGK3/
         zQLQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro1Z44wqklZuEMzbtB1rSotfDmMvQvSGDmeDAzILhe0t9fxnKtkVc6MQ/H4+Tw1YmrY69fAW1OcAg==@kvack.org
X-Gm-Message-State: AOJu0YyuS5ojuewj1Zd5uFqqEiCg3V/rbtQQbkaSmbO8+Ornwr2NHYDr
	39Dkf+XR6kVVphOYVD9YsOs3NtrR9yaO86Dz+J3l+wmfLWBmVJBtqigxBWdQLyHu3Q==
X-Gm-Gg: AfdE7cnNNg5v10e/0ArRwzm+fz5dq14CvlKq+qJm1kSchewyIUhxDCMsNN4GslXuehP
	ou16Jn9plgFeOS7bsuVC2Ap8qIA6Kf0vQn/SlOJG2yN7N+Fpxsn0HgQ7orbi0BcES+VooHp9FKA
	1PKF9BP44B3KIstj9Hv81IVCZI482YdEcyn9iOmAwYkJKort/daqjuvxVzLs/RMq7ZKzVAFTYha
	eVkLAvIBlJyZvzoN3bBrMtzWSmdBY2w9fJbxehzcDLqLVFfX6C+OuHZCQWLzTOQ5YNh6Gwk+4ux
	KlpDXibzrUA3VnRnR4Ckw7xeMFkL6WI22P7p7aaR1I4YlxRb50wW/cvNt30xyiJOM1TEufKYRmW
	1fYwxEn2ZN1K0ckGy6kJlnpFitbyN7rcBc4j3OnshXP/1GdZ0ixUZ4pkUtLOuoTJR0n9PNZ/JED
	5PlwYRJ+QiIYMvE0z1hd5wEZVuIJB0uecnkEb2zKm/Tl/Tsew=
X-Received: by 2002:a17:902:e752:b0:2bd:6dad:3dfb with SMTP id d9443c01a7336-2ccff969666mr193175ad.25.1783530187903;
        Wed, 08 Jul 2026 10:03:07 -0700 (PDT)
Received: from google.com (10.129.124.34.bc.googleusercontent.com. [34.124.129.10])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6b64819sm7622445b3a.12.2026.07.08.10.03.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 10:03:07 -0700 (PDT)
Date: Wed, 8 Jul 2026 17:03:01 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	David Matlack <dmatlack@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] kho: Support preserving unsplit high-order pages
Message-ID: <ak6CxVty3O5Ib7q4@google.com>
References: <20260703020832.1731864-1-praan@google.com>
 <2vxz7bn5mv0n.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxz7bn5mv0n.fsf@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1E12E18000A
X-Stat-Signature: njy8spmeaa9zxcy9sko9m7fcxaksho5q
X-HE-Tag: 1783530189-108734
X-HE-Meta: U2FsdGVkX19snG1AGtDLugiyiN5j7BTIXLl6OtcTEBGGaJ5JnZMmaaO026wa5XA3VYc5hm6A5wT7axJ1mPe6St6p6Dqeg1lIBnorFFpaR94jQ8tbXh7Dwdrsf9odnnxB63ItiKKk5V7vk5Dv0C4Vi+u0T4Nyj/XotwLnnTn04/cTgwpICp3lmUMaFXzFU8zGZY23aRbqecNFHHGJOOPVN2452HHuIo4ZR/k3EY9oMa768GpY+IviCGozrZQsnVLqt339tO93LK8/iYHiZ2FKcNDmIunkNkzDkXQdtvWTGKjLvTMLBHfZv8nLjVnkTfYlJnJ8G5wHAVkdpOI+QvZMGQOwR1C2RT0GzXoXRjsPpUBcaXW062BEioJg4aGTQmzNbNd7vQ6AaUKMBe1s+r5+GS6jgtmrf4hZBppXbbVmT1g7zB5qZ/ICaDshHa2N36y96KLPW1/VPoA4MgmTqJqUfbvbfWV2dprxHhAysjDWH3OaIcDyfdqG5LSZs+hgrhNUuC2/iIX9Lbh0Qlmy3RVfo5DKIHAfjvsCPKrwkABbPPBYwTKBspG+FjqT2HykKOou/XE8pLQNkThiOXH6OK3JAPFGltDbF8vg84+nsn34z5T9CqnvSerblny9CTQTPIeNIiHHQvniG1nAjdXfK50D3h5juy+/PQNuBhUaRBoCMH7JI3v+EwdU6bnNhRaa5jjYuuoCTlU5tVrGJrYFyX1QMJvPdJcHxQb/QhVQ5N4eqs+HimEANOzBuuxpbekm1QHWWGvj2Ng2oEFBPMKlfgg73Z+3+HMXot0+Fzn1OUqG1u+GNRfVv9wWzQPOAUCcBCEbCtyJizC73Sx9R/jFrbTW1i9hAjrBL/ib85rp9kOYq4dg1K+vZqpHzA5PeHYjaeT3xLgSXaxFd2rsvKOZG/DgU/9knBAxKZxfIi9Y9YIm6otclizEy4XF7GNOoJcwQwzy1nHcwXzVWS6wvouAjuK
 EGgRh7q1
 MKTDUaOL7xWNldeXhhquZh71iP1g0tQ/QwG0xybKZyCBZAOzsyhEAt84fnGlEWBi6HZQmsnCoVcih45D1L/JQPPP9O4svSEn8f2EpshjCbLurd6ggVhviCxFzbXkCwiu6doh33wKn27a6sr7sbsP8ZueWeJ8q8DpKjGAxVxZvRizLanCwfpecyrU4AC5Bk3YhdsZR1f3T4VS6wsevSCalRvhMGcvtM8NMiEQdSpjJC8tTpyJNDpplqBVx6IFx/OPRq1Jrb0IFs/mY90CYqZ8sH5WAwy66IxLb2luNMMBWKPZQCgMPLbXFtB6nRqB+X2u6GYfdOVCvpNRjJ6PAF1i5e9ZpOcgkMuTOjEee1Efk8WsJy/8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 08, 2026 at 04:11:04PM +0200, Pratyush Yadav wrote:
> On Fri, Jul 03 2026, Pranjal Shrivastava wrote:
> 
> > This series is required for the ongoing effort to preserve DMA allocations
> > across KHO [1]. It addresses a fundamental mismatch between the current KHO
> > restoration logic and adds support for high-order buddy allocations.
> >
> > The Problem
> > ===========
> > The current KHO restore implementation treats all multi-page blocks as 
> > split pages during restoration, i.e. kho_restore_pages() initializes 
> > every 4KB page with a refcount of 1.
> >
> > However, many kernel subsystems, most notably the DMA allocator (via
> > dma_alloc_coherent), frequently return high-order non-compound pages. 
> > In this unsplit state, only the head page carries a refcount of 1, 
> > while all tail pages have a reference count of 0.
> >
> > Consequently, when these contiguous but unsplit blocks are restored by 
> > KHO in the new kernel, the forced refcount of 1 on tail pages causes some 
> > trouble with the buddy allocator. Downstream of the eventual free path
> > the __free_pages_prepare() [2] ends up calling page_expected_state() [3] 
> > when is_check_pages_enabled() returns true (only when CONFIG_DEBUG_VM or
> > debug_pagealloc=on).
> >
> > This detects the non-zero refcounts on tail pages [4] and incorrectly
> > taints the kernel while leaking the pages in question.
> >
> > Proposed Solution
> > =================
> > This series introduces a "Page Type" field to the KHO ABI to track the
> > refcount pattern of the preserved pages.
> >
> > 1. KHO detects the physical state (CONTIG vs SPLIT) during preservation
> >    by peeking at the refcount of the second page in each buddy block.
> >
> > 2. The type bit is preserved in the high bits of the KHO radix tree key
> >    (Bit 63) and stashed in page->private metadata during boot.
> 
> The KHO radix tree today only guarantees support for 53 bit wide keys.
> Although in practice, on 4k pages the math works out to support 60 bit
> wide keys in practice because we have 6 table levels.
> 
> Still, you can't preserve a key with the 63rd bit set. So how does your
> code even work?
> 
> Also, if you do this, it comes with a side effect. It will increase the
> memory usage of the radix tree, since now you have two branches of the
> tree, one with the high bit set, and one without it. So that is more
> intermediate table pages allocated.

I agree that this would increase the memory usage...

> 
> >
> > 3. kho_restore_page() applies the correct refcount pattern based on the
> >    preserved metadata.
> 
> Why do you need to save the type of pages in KHO metadata? For example,
> for pages or folios, we don't store any type information and leave it to
> the caller choose the right API. So reserve-mem and kho vmalloc need
> pages, they can call kho_{preserve,restore}_pages(), and memfd needs
> folios so it can call kho_{preserve,restore}_folio(). The radix tree
> itself does not hold the information. The caller knows what its memory
> is supposed to be so it calls the right restore API.
> 
> So why can't we add a kho_{preserve,restore}_page_multi() (pick a better
> name; we can argue about the naming later)? Then your driver knows it is
> restoring DMA buffers so it can call kho_restore_page_multi(), and KHO
> takes care of initializing the pages with the right refcounts.
> 
> You won't have to muck about with the ABI in that case.
> 

Ack. My goal was to keep the KHO API opaque to prevent every driver
from having to peak into MM refcount internals. However, if the 
preference is for explicit intent, I can simply introduce something 
like a kho_restore_pages_unsplit() helper (or similar) that drivers 
can call specifically for high-order non-compound DMA buffers.

> >
> > 4. A new helper, kho_split_preserved_pages(), is provided for subsystems
> >    that may need to split memory after it has already been preserved.
> 
> Umm, that sounds scary... Why do you need to do that? What's the use
> case? Why is the driver reconfiguring its memory after preservation? I
> assume these are DMA buffers, so why do they suddenly look different?
> 
> And in either case, why does KHO need to do the split? Why can't the
> driver unpreserve old preservation, then split the pages, and then
> preserve the new ones?

Ack. I was trying to cover up an edge-case I guess but if we're simply
moving to an explicit restore API none on this would be needed.

Thanks,
Praan

