Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3597AC5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 16:08:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48C666B0088; Wed, 26 Aug 2026 12:08:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 463856B0096; Wed, 26 Aug 2026 12:08:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 354896B0098; Wed, 26 Aug 2026 12:08:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0E9B66B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 12:08:08 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9BA4D1C0874
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 16:08:07 +0000 (UTC)
X-FDA: 85143902214.10.65A851B
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	by imf29.hostedemail.com (Postfix) with ESMTP id B23B9120004
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 16:08:05 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=T1VkdvPz;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf29.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787760485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6TL6o2qDUSSET4kTZDIBsppDmS2qokjwR9B3c5mQR8U=;
	b=vSclb0bOotBnutcucfHUAlJAioEKsZw95Ds3XM3tk5VVVI9xEWYcAT/W9YZoYi68UHSMJt
	LePICEu7lwUxtaFXOe8P/VJ9YDJ8miaSVCAgqxQBVnbyjgF3jkasjwNKwXUExpSSfndv+k
	cjJQWSl5xqL+8ue9w3iDmsln17P/KJA=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=T1VkdvPz;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf29.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787760485;
	b=8VOfT3gNIXzMYOI9QsTHv3LUlTRxJBkH/hkTiqx9zs3mCG7zq/RJdYxvGj4VTzJIqLE+EM
	IC8ZaGpcQmCCR3q7IEL7rsFLd7u6WE/jJSc5BGnnTvKXA8DX2b6PGfXe+NZhmfQqOvJN/R
	pPIdytEM7Y22erNwaR6foRx6xqfYSAk=
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5aeb2bc82ccso1079344e87.2
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:08:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787760484; cv=none;
        d=google.com; s=arc-20260327;
        b=bKlE/7f0olhZfpby4QNYAP6KZYRmUk7Kp48Dm2d363dgP2sbHIdxXxmTqvzQPC8UBL
         CNQTVkgMAhfd80Vx12RXmwdkH6E/UaQgQoITHshr2aOhjb5gXvHFqmJTNls+pvHe56w1
         jgGOYJAz+h99p4YnutxnFNvEMlMD7QFHqYKzRg+y/HutY24d706gKa9j1i9BzjBFhNmw
         UkOzKC4XJnvsLCSc3/gsmNJt+j8nvA5WM1RiXW4IhGXJl6HhfHdbzDjF9hbhqTEKC1Yh
         fJgtBSSJ+U7fNbduVuAlI4uCi/BnxqUUnUplBInE1AGOtcFHXNaT5ABskGmsVWC75ShF
         9MKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=6TL6o2qDUSSET4kTZDIBsppDmS2qokjwR9B3c5mQR8U=;
        fh=TXpL3MXQm3oNG3M6iwOxV1gpqYuWX+4C/0cX6D+e0tY=;
        b=VZvTVSlEJsnHUErIZiLntZQd7m6zAE7usDpnzeVANryMKeUXO+y2P2e/da+tSv09DW
         6vidytUouXLeShd65/9IFvp0hpSM6D2bO5lzM4saX6fMApvsxGoCUbwLE90EX/LtIxGm
         uJFSWMSnCqT9dAtdgk72zfiicKW4HAWZGoai158BN3GATPrf+btefdZmtC9e7fxvCorI
         8fZfOy4Ay99gnZKQOtvJBv/WILC4pHcgrv66Z4+G4DcCL56XXKMG3uolSLzORm84DSWC
         kQIK/FpryfsqbxbHuwHS2RYqGbKubBC1jXvtwotvFDEDBTxJRV6oIZR5W8tVG0qjd5ba
         /jCA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787760484; x=1788365284; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6TL6o2qDUSSET4kTZDIBsppDmS2qokjwR9B3c5mQR8U=;
        b=T1VkdvPz5CpqW5CSyebnsbxGGR7f0RvwOsbPP0xbbZGkHqGuZWejC0hJRO+N4StfPv
         sgGc2xupMGMhJeXBC2nKOj1MJpNtMTuB7+jH6vV17Nbq2KQk7hkPUN7OGf77UIIbhX5V
         cb84FpQmTAtQWjfySVYH6eyksFEIgdU7WJ2bfQwlGIddCuJ1rzDuy5RrgmZcQi0oCAzK
         19nyAC62SKqw+b0q1ic4Bd7m+43E9Pc3kcZNjODOOisswyb7ipadXxdl7ukmizDCCtb8
         YHkZ25YBcDaJmh8M1MS0UQ2t83ppzCbExGEbB8/RTasGRaK8UaDQMIwX5M3BPpAu5Xwy
         ixSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787760484; x=1788365284;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=6TL6o2qDUSSET4kTZDIBsppDmS2qokjwR9B3c5mQR8U=;
        b=oR5zGOkJEam0ATIB+w1G9ijz2mKQDtEmAGp8wN5+lOFIXiT/e2yemUWLfoR44K+Ehr
         ttaRroSFKhACfCpJCz7Fq5kQO+1B8P4KmZ1VYIuePDKCF8+XTrDK0g0KoVRbzUjAgiRI
         nwF1z0nCsQfC5j3IW7W+7V6iqKT/Nrx1mlp9ZjZidCVaRMIQHZPNXR4bFMDq9T9HPy1n
         zHAGaTkGCluRkC6EU3oYBuTVOikEplAqN6JvGlbjvaEIwCvfZ8AMFEA/u/gF7Zc4jTok
         6r+pIAR9l1PoHavoJPTy7UnSC/KSWijQqhlyOLpZ1SsKAwXHxNEV0e0dNBkAgINRVXc0
         bpNw==
X-Forwarded-Encrypted: i=1; AHgh+RpyFMhgjVHAYdRvEl/wZ+RJy9mibEXy0Uc2ea9NDr1PVaqeBjmzzsu4mMu5YyIVPV8wyM/vpAN0Ug==@kvack.org
X-Gm-Message-State: AFuF++nuA0HFeSCNpiML3QiOgqu+viNmd3EX35dICvqVoRMK+P5KhAaH
	WNB1sHgJBtuQNdd0OaCeKrpP2vVceyYsL3pdUQxWK8O8PiMxUCOpYkEvmBfeOtDedfSFo3ppBRc
	FsbmXawI/k2Q+pGwsB7tqBu16kob1GTQ=
X-Gm-Gg: AR+sD12j6H5MFpgvLScVPcv8f7CmDSESo+UXaZ2Rv7UMAS85X4AnpcraRJRZXy+VFXJ
	2IZWaHsy3A5UtLeZegAEB8AjGFAywG1FdcTySwGSqU8r5pbfOWSSOQOIhNAPfjpqCm8yLa+W/z7
	+l/J09r5clMsvxGlVyLFvCu58p4YIBmFvaxe6Hyo9slR9CJN3txuBWkJ5i2l0vjo101w7A2iUVf
	bZ0ZCH6BkVN7uH3zu5vognvVDrRd3usZw9q7Sfqd7l9HSsjzuXh7l0peiZFvCib+MZ2uMXDorZp
	Ki6P6meiYIFmE/tfQY/7dGGhmDu45mKQp9VQyveciO2kVUGN6SlW1i0UNrNzdED8WU7ujTAsZPc
	=
X-Received: by 2002:a05:6512:38c7:b0:5ae:b998:9134 with SMTP id
 2adb3069b0e04-5b4a9006427mr2044785e87.1.1787760483740; Wed, 26 Aug 2026
 09:08:03 -0700 (PDT)
MIME-Version: 1.0
References: <20260815-shrink_zswap_entry_0815_v2-v3-0-0171bd86a667@gmail.com>
 <20260815-shrink_zswap_entry_0815_v2-v3-2-0171bd86a667@gmail.com> <CAO9r8zNFYM1bry0DwDRNtpnEL9yyXQ3h=1wcLbGsO1sFtGgvjg@mail.gmail.com>
In-Reply-To: <CAO9r8zNFYM1bry0DwDRNtpnEL9yyXQ3h=1wcLbGsO1sFtGgvjg@mail.gmail.com>
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Thu, 27 Aug 2026 00:07:51 +0800
X-Gm-Features: AcwNN1Xa_upYQ8xLBB-nlAO59uqKGOulAkiKGtTDN8aKq4iOOwa5PXp7uoaS_Ik
Message-ID: <CAJxJ_jgihBLy2mbPAN-uqup2mGq+hurKkH=W4RGo4Ad0Eki5sQ@mail.gmail.com>
Subject: Re: [PATCH RFC v3 2/3] mm/zswap: replace the zswap_pools list with a
 fixed pools array
To: Yosry Ahmed <yosry@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B23B9120004
X-Stat-Signature: jyxmiia7w5w7otyj98kuhabycqqejwbb
X-Rspam-User: 
X-HE-Tag: 1787760485-864504
X-HE-Meta: U2FsdGVkX1+5Pvjxs5faduhqQ7rm9kqxH8Dj9jAM0gHzippMa8W7RltEDDbXWx2f15sGkG12btp6ZYSqt/gAQKn2+jAM1aMY4nYvcIZHvRmwyF5YVGPq9G2GsStvFdhJutNKU2RqLipvAoUnfSgfOm1RUjTZbQPDd3P360NRj33RG7jRcty0TyMIEK8vwPG3SjRxfWQSpLLvo7yalFGbPha1a0XEF1EGLMKAu3gDTqrPLCFRG8wApobDxZm35XVIVMMcT5HbyUmYEDfkh3Nx7FjrG83K9hm76bq+gVW/5ZTKZwkRDTqYM6G+hy1J6dgARF2ucJORVzI20WFPSiHlWkUc9Z+CqFyUydpefVMpbxAqCgKWhviD79hKULMlbTaIHgD9QWS/d1l+fj12e7hCEGz5H+V95MME9aJT/JkZD31EWhwL3BHLhQ7wGTn2NhGVVCJYNeObaOl9kTjfNeWCHaKlUJBbzF368Btv1B2EIRJEp8nQpv/O1YWvrq6bcL4APGtUlNw5V+4TsMWRw+IA5x6G+cyYBYLnh2rELDwPtYVAeyrdGcFDKd584CfxepErVsPEPQoN9W5C/oclYZe/Z5XqjEY+dqL+5wS97HaVJYjyNT7h4Da1u8jzJHwcHOhVxb1vkg6ytJBWUixgMpvDXye3BbwEco1uBbnyQ6NDLsDL/ZzZflw6Ht8QfHMnrUImy7e2XxCD8bRXeZtr5sUjeWibMMIWbGaEHhNTNYG45SsBxeLEC98xUvZNzXzPdlFlM6xYD9RwOBBC4yLzNoloOLtwdZTy9d5tPey8wOsHNDzRJLKjTVYAA8lWwcopwM7qcP3Xuj7G6X5s5MGfoJ+Tjc0EXjDT320GCyK9CSAn2GVr1tHokpZgW6mPzbeKXu7VOEZpsMVgEGaaK0WF/Z8X+w5WY+JqRLBlGL9yQ/D0TSNMRiSFT4gYEYMazwDm/hS+ao75gQ2w4BgoJnzlVvM
 nzENdRJY
 W6lDiC9U4qlLMEFfZDtEkvuMwClnvjga/S5iheN6/2vXo7RcBPLYjAkan1xNe8HUHdeXzrdzUt0P4aKBcCeVXEIaTBDcFFq45oLsV2KwuKvGkUXaSVTfuG30GsEbiJQD2DiizhZbbV3v2a44z0wyPVmOSflN6MpY74aa1r67GuwRBI6cpIn7TISpqswN3E+0d80Vi4U36/+6CuLp8ND69Fw64sd9lluq6irJ6LxD6VNyOD1NwzSCNbqtIfoe23Q4JyynOU8S4zGMp9E7yKqT/VZRdmtFfW5NflI4cSwAhqLNWU+r4rtocD0kVFT214554t67a2OkfXZpmdIcNQO8ddc25iFRJ3kaNBVlDQXVmF5sgIGglpO4hfbyz2APZNxNZI4f+mirJzUBsohR4OXQon872ZaljvbQLmuRQROPoEltM9hvcpGSbrAqLpUZYKYxWLYYJDZSUNA9n39nRalu4sXOdNQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for the detailed review.

> I think the reservation logic is self-explaining, the comment here is
> not warranted. Especially the idx part, I believe we only set
> pool->idx here to keep track of the reserved index, not really to do
> it before publishing as publishing happens later. If anything, maybe
> replace this with a smaller comment to the reader that we reserve the
> slot at pool creation but only assign it when we make it the current
> pool, with a small explanation of why that is needed (the actually
> issue Sashiko pointed out)?

Agreed.  The important part is the race from the v2 review, where
zswap_pool_find_get() could observe a pool before it was committed as
current.  I will shorten the comment to only explain the placeholder:
claim the slot at creation time, publish the real pool only when it becomes
current.

> I think we can drop the assertion since we already have the lockdep
> check below, especially because it uses BUG_ON().

Agreed, I will drop it.

> Hmm let's read this into a variable first then compare it to
> ZSWAP_SLOT_RESERVED instead? It's not very readable.

Agreed, I will read the slot into a local variable first.

> I think this comment is unnecessary.

Agreed, I will drop it.

> Let's drop the assertion here as well since we're adding a lockdep check below.

Agreed, I will drop this one too.

> I would align the second parameter with the first one if it stays
> below 100 characters.

Sure, I will fix the alignment.

> This doesn't really explain why. Also, does ordering really matter
> with the lock held?

Yes, the ordering matters because zswap_pools_lock only serializes the
writers.  zswap_current_pool can be observed by RCU readers without that
lock.  Publishing the current pointer first would let a reader observe the
new current pool while its array slot is still ZSWAP_SLOT_RESERVED.

I will reword the comment to explain that the slot must be published before
the current-pool pointer.

> Is this a pre-existing bug, or why do we need to hold the lock here now?

No, this was not a pre-existing bug.  The old list_add() ran during setup,
before any RCU readers or runtime compressor updates existed.

I added the lock only because zswap_setup() reused zswap_pool_publish_slot(),
and that helper expects zswap_pools_lock to be held.  The setup path does not
need that locking itself, so I will publish both zswap_pools[pool->idx] and
zswap_current_pool directly there instead.

Best regards,
Jianyue

