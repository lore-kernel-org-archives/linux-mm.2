Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21DD2CA6007
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 09:10:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA3766B008A; Thu,  8 Oct 2026 05:10:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A54606B008C; Thu,  8 Oct 2026 05:10:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 969DA6B0092; Thu,  8 Oct 2026 05:10:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 702AA6B008A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 05:10:22 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F03231A04C8
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 09:10:21 +0000 (UTC)
X-FDA: 85298887842.05.51446DB
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf20.hostedemail.com (Postfix) with ESMTP id 21F2C1C0003
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 09:10:19 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=b43J250S;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.128.46 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791450620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6uy/kPke9fi9GxHZDbYTp9LZEJXPKNC8bWEdNfKWUhA=;
	b=yJpRXPgX04W8xZzx8oKSjbzHCUE05gUsxgb9Wp7R2KX07/mfoXqSkpkgnAHtQLA+jp//L4
	R5eOyXyqZJgkUydtMJrS2Om/Awcz1uYFvwVzKs6y9RFOWGZ3J990MMAtwXEsjgfXASrNUg
	ZauhkAPRYpK7SKjorKf3/Y97d1pgOmQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=b43J250S;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.128.46 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791450620;
	b=DH80nQZUIt3R9VmdhHRdCKT/L8IOo5flIaxovvSLP8+e6p00W5Fryb/QUO/QFr2LwJyAxB
	wiRkx/zdKDnnLNm2a9vJAUjgZaoFnS7QSOx5TXcQ458kKAD7VRXmqLpKHT+APRBOded1NJ
	OGq2n0KOktAZFWKSP/b3trs6sSB2E7w=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a018dc1f98so23625245e9.3
        for <linux-mm@kvack.org>; Thu, 08 Oct 2026 02:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1791450618; x=1792055418; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6uy/kPke9fi9GxHZDbYTp9LZEJXPKNC8bWEdNfKWUhA=;
        b=b43J250SyLWafWALtDLukm2Rbt+M3ZmJSPs7BwHSt2Jr4Z5uSGvvvyuLaQRXVlpFdC
         M3tCIzV+RP+8wL16/VRj9P6h4uoVz9ES/MgoSXU6NbciLaJQ2fGetTHoROL5cXwqDG4F
         Ssnt5GsX/8iVp6xl8b+095P6YGA6KiY/+myhrrGmoz3xYy6j723fi4d71HMoo5T2dVRs
         MuCZ1UabBAzRw5ZSOPK+uLDyptbTM7mexsqqkfjnD3lqxPE4oYXw5cURWy6+WLCDQItS
         1ik7aKCqfvN+Ae67Ctc2I7kkWEjKQ1APdDU0tOkzFglbK+kfsD4bUdyQ2Jiq3C7tkPdG
         jD7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791450618; x=1792055418;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6uy/kPke9fi9GxHZDbYTp9LZEJXPKNC8bWEdNfKWUhA=;
        b=Hg7xi0DCJpwIdFXdQUTTDC0nXODhrRFaZW5BNxe8Tyh37Ka1fwAUWVQIQqAQhttnpV
         SNn7s/5KzWikjJgVxUJaXqpCuIxcw9QC+LUgru6QV5gyoaTVKpyaM0Y4qhVdFm9FE6j7
         t/ERfZDAEc6RKTi2YXNye9J8V71Ohspu/BKehiLdCJJmgP/RBtlV9HDYxeMjP6Fg0iYN
         xeMJm27fNTagoQIeScUgshCdFsDSQ/mZQ7Cej0dnqUL/coIWV23exN00YoxUjNtBxzah
         VlzMfs47I+B2AvjY3zaBYlcG6/Kt6bKd9CPqcDzhN99qh7E7b9Jwk0Rg0ZdSVFx93WCl
         43WA==
X-Gm-Message-State: AFuF++lX2LNthLap+QryxBWyqyZRMKhuk5G/Uius+9xJJ3/VjIo55kQd
	kC+oWR5zpbt7/RToLcln4ddvNUX2vmzPQlLFOqZPJyPJACZyGRPB8hmo6x/bz9h/nOg4OCz9NFV
	BMkRi
X-Gm-Gg: AYBFou0md9WGr3LUT4ox0MZVFGG/eg1vY8moApHDIMV0Z3a20+5X0ds+U2CkIVfGg43
	oOjJKf98X6pcd+6dq8Eybi/K40MH7XzpEp2/3n3vt3GgWJqp84xUiUb4fHDmdapRt2qUn0KtSre
	PHF71Eiv8W07wh8LUN9CQtPi9WJqStWtxBkweK0irmbYz/qFHqv8d4xpQ5nmhaT++TDGrnHUHaf
	w5UsN3yWtzluCOEZt63qvRgM3QUbC3KXHVKPw3Sp68MtbMlblz33cShOOrR/yls5cERLD6OtS9g
	O3H64XMdn9iit+LUEIxd9YKLf66Mlotcj38axs1nka/bqOmDqqYtuDwCB8ZGht0pQrlnVtrwWcK
	X9FyxWNEsz1YNUUCiPPTLCfHITp1nVAIJ7ZXpaoGpO1/G9UjSICxEgBme1lM9ZtWIKroX74QxSq
	lXgIyaU24jH5ah6436om7TCipowYElbg6ksTFG+ema9cw+wJrzrpbjY10ZQ0CGL2tnJZ40R0CyF
	4OM08ps
X-Received: by 2002:a05:600c:821a:b0:4a0:1a7f:2abf with SMTP id 5b1f17b1804b1-4a1802f6338mr82809725e9.7.1791450617925;
        Thu, 08 Oct 2026 02:10:17 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([213.198.107.8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a17f493761sm199060405e9.2.2026.10.08.02.10.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 02:10:17 -0700 (PDT)
Date: Thu, 8 Oct 2026 05:10:12 -0400
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org, willy@infradead.org, david@kernel.org, 
	vbabka@kernel.org, brendan.jackman@linux.dev
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	kernel-team@meta.com, jack@suse.cz, akpm@linux-foundation.org, ziy@nvidia.com, 
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, ying.huang@linux.alibaba.com, 
	surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org
Subject: Re: [RFC PATCH 0/6] mm: pass alloc_flags through folio, filemap, and
 bulk allocators
Message-ID: <asdTptfeLkuypU8t@gourry-fedora-PF4VCD3F>
References: <20260923211041.3127588-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923211041.3127588-1-gourry@gourry.net>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 21F2C1C0003
X-Rspam-User: 
X-Stat-Signature: irtyf56h1r6ewc8mw51yt7udik7ewd7w
X-HE-Tag: 1791450619-265740
X-HE-Meta: U2FsdGVkX1/CIGWoB1YF7pquG7Y+u74UW9oGLVxl3WaR9CMvB2TJP6NZ2Gng72bng42LuWtTgQCh0OoObIJELaKmrlw96e3pmT8e11u+bCRSvE3s9M7fTVKKM8LuRbcKfDMxNJAW0OE7wvF1sO7MgBf8X5D9G4VgE/vYT0TFp+tCYVr+BlWpVAj51c3ntUxd0FTJ+DdxG+OP701wC6lqBZrEUq9kaHdCxhK9RjRLLZ4ZP8GfLLzLdrP2Nf37KCw1tGYwC7JyaT4TuCD0ImjFWmD/cEoMRUeXLMTVw8i4RLPaqGhWTs3lf/PiX7pUYLUK+4x44VWDtxNU1Ze9ZZkM5nPYdJyfBA5kcBe+4HsZdAkd1r7rGUn5v1F/aJpxrTvrLVU9yTdrqrxCfnUUk06q/BFgqmcoNI5RQtohm1AkChW9btDw4Zp1qT3EIKSxaNqEMKSLK9b2pBsVXIDGcUu42tmBB5OFtqnGcirvsPNs0Sp+P/f9qOu3sTNgwY6Wije+NxQKX/+s+MxN1lb/xmfUmPc0602rxh6RNc9+Ryjla/H1Y09C+gfn2vHBVPtxAeyouieC9OrcRTVuJyjxi7BMGuk/cDzNoX9dCgug9ur1uSm7c2kXouTaCU8vHn9E1f99G5akRKkpjyWzuXMUbTUFvsYdXVVDwxIXar4Z70R7CtUghqytzXi04pb7sPdHslLpnIvaJ0MGWa2NwsIFPmKOph79lwvvMNPQPygCA7ikp1txqMD40VMmRuAFuc3dsRgVEHjDrHUTnzG/qc0LnNVkMuEK7WT8Do55vamQf+TXTsQ9zRRg/lVC5sVg01uJjI+hfYzyUSS9Vu8bhetmGiCYg694CJK4UbU7L88CuWnuIKR1hpJsZZ6WdFLXVflbdVwJIeKtL3f4aXB6XBnCkOMvSTMWuj6JeozoZ2LowRpfUJeApvcSlVFQTWc8CF4VD07etojxJdfFw7TWcXutrdJ
 w/xJZz2p
 gV/ZVW7gYYbWFSEiyCbAICjR5zyDilKViqO/wy8Q8jqp3oHj2AFd/0cjKKe49wMSwVDt4qWcSBC7Ku2BymuTj5aG+CGxFmQPNLzDBsFNk7QamJ/o8qja01cAiASfnC0e4qPy7WThM0atOuanOe58RDDAd3rHjiW1DHDSYwZD3wnUknJrS9YP5GjJcm8A1xX3xfYmXxuWTo4SOLj9h89n6aqk/NqF75Ny+AvC/nIMqGV+c1MJOf51hoOl+G7yQ8WbvmGT36BZWHvMCFmZ6tqE3WetivZJ/c5F8fHUhtb2nX002fE/JlaEoHA8UhsxLzZEiyrdrB4KcadbyzI3vSQBmK+Gj46QsPqWQht8mqDKaFbWvnkfR9YH9/j3ZwI/VpMekRv4npfWAgOZ6pHiCKpk2UWpIwjv6UtjkeCe644HgZOEiBmMGWHe9vSU0nPt8hy/MNaYa4GKy9hgkB6I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 05:10:34PM -0400, Gregory Price wrote:
> This six-patch series first separates allocator behavior flags from
> the bulk allocator fast-path flags and shares their validation and
> preparation. It then passes alloc_flags through the MM-internal folio,
> NUMA policy, filemap, and bulk helpers.

I had various discussions this week regarding ALLOC_ZONELIST_PRIVATE and
ALLOC_UNMAPPED, and whether adding alloc_flags to the APIs is a good/bad
idea and what the alternatives are.  I'd like to summarize the notes
here and try to find a way forward.

recommendations that were made:

1) re-use unused GFP flags
   #define __GFP_X  __GFP_DMA
   or simply delete/replace __GFP_DMA

   There presently are no truly unused GFP flags, though there may be
   some users who can be shuffled around if we are willing to add
   functions.

2) alias 2+ incompatible GFP flags to make a new one
   #define GFP_A (__GFP_NORETRY | __GFP_RETRY_MAYFAIL)
   #define GFP_B (__GFP_NORETRY | __GFP_NOFAIL)
   #define GFP_C (__GFP_NOFAIL | __GFP_RETRY_MAYFAIL)
   #define GFP_X (__GFP_DMA | __GFP_DMA32)
   #define GFP_Y (__GFP_DMA | __GFP_HIGHMEM)
   #define GFP_Z (__GFP_DMA32 | __GFP_HIGHMEM)

   These are all nonsensical combinations.

   Downside: We should probably just forbid these, otherwise the function
   contract just ends up being confusing - i.e. (__GFP_DMA | __GFP_DMA32)
   should just warn / return NULL.


3) expose alloc_flags as mm-internal only flags (this series)
   in addition - convert some GFP flags to ALLOC flags

   In 99% of callers they would simply add ALLOC_DEFAULT (0).

   The upside - it seems like there are 2-3 GFP flags that may be
   good candidates for conversion to alloc flags:
     __GFP_WRITE
     __GFP_ZEROTAGS
     __GFP_SKIP_ZERO

   And the zone/zonelist selectors seem like candidates to free up GFP
   flags by turning them into internal-only flags and giving drivers
   some kind of explicit API, e.g.:
     __GFP_DMA/__GFP_DMA32 -> dma_alloc(...) -> intenal ALLOC_DMA|32

   I considered whether __GFP_THISNODE should actually be broken up,
   as it actually means two things (don't oom, use thisnode zonelist)
   Something like:
     ALLOC_NO_OOM
     ALLOC_THISNODE_ZONELIST  (or keep __GFP_THISNODE)

   The downside is yet another flag interface in the page allocator.
   Note: This is basically 1/2 way done, this series finishes it.


4) simply add functions to the page allocator

   folio_alloc_private(...) {
     alloc_flags |= ALLOC_ZONELIST_PRIVATE;
   }

   This has the downsize of requiring page allocation callers to know
   more than page/folio allocator functions if they want a particular
   type of page (unmapped, private, etc) and increases the surface of
   the page allocator.


Would like to find a path foward.  I lean towards GFP -> ALLOC flag
conversion and making alloc_flags internal-only.

~Gregory

