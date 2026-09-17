Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4529EC982D6
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 14:31:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 288DD6B0092; Thu, 17 Sep 2026 10:31:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 261016B0093; Thu, 17 Sep 2026 10:31:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 175D26B00A5; Thu, 17 Sep 2026 10:31:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E0EAB6B0092
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 10:31:09 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CD7DB1C2427
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 14:31:07 +0000 (UTC)
X-FDA: 85223491374.15.B57C03F
Received: from mail-wr2-f34.google.com (mail-wr2-f34.google.com [74.125.225.98])
	by imf01.hostedemail.com (Postfix) with ESMTP id B9D6040007
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 14:31:05 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HmidhVfh;
	spf=pass (imf01.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.225.98 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789655465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OL1rW9y9mHZ7kkv/coK63PMmFR1002GsoxxgXvkjsnU=;
	b=kagpGdZNXXRXPuOT7W99qh0v63zFvjYi4CPf7gqUqIj9CH83FIgPeQEQURFTwDrOjbbOQ2
	+9cIQP/ebt9rkesJh/Zk9TJZPZB3CxiONtwkCe8FYByxciJ1BKNGQh/y8c5BhtO0/Z+/Dq
	3+4U1TzgnJA98MAuz2o1pnyGnG+WeQ8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789655465;
	b=Ms057wFlXR7JYToMlwU0UQ6fTdnnGf8KARwiFb2WDSpjp2ZyUAC3gGbrGi2YoOS+KQEIfu
	jZOLGI22wbjN77s2eK10sH3w2zdy5HkScfWtDFcpB4HMAKbG7Kcj6Y1zMtH56Gk2290tKv
	wsj/Zok5+nyemzdvVYjvWFKY4P3m5qM=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HmidhVfh;
	spf=pass (imf01.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.225.98 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr2-f34.google.com with SMTP id ffacd0b85a97d-482f633cd78so510797f8f.1
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 07:31:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789655464; cv=none;
        d=google.com; s=arc-20260327;
        b=HS6ApnbKmOve3/A1QeL/SPtpJzXIuqdBUZVYC7/Rhx08kID3UXdC/93mf3xBn4Cg4G
         WS19ov/pHDV1uU4/7O149PxmQ5kTBqRfM/7XmQqcSBk389OF1BrRTAyu1QerzaybZeOp
         0kTGu0Dma4O/hDT5GJdgND4ZniUSuERfgwf0tTOa3go/xDvoDJ9YmFwIvWkRdsixvv9g
         95JE6RECleDRngbhOu7KXbuUzFidh41Ko4YunMOvaKVhYULXi8E8R6yaMWOC/wQAP2jO
         9xyyuXbeXSbiT2pHVvMV3sRmccwFPYgpA9juTifN0jj/QhQIsrSNeiH614aa/4iJy66h
         48ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OL1rW9y9mHZ7kkv/coK63PMmFR1002GsoxxgXvkjsnU=;
        fh=dLZH+jBp79aiOX8R8EXinEG1BLrPG4L+zMHMQ6xemDY=;
        b=oAWdsp/ea1LL6G3gqqZm+HcjM8Dcr5iHwHYyhuMKyv/aMl9glDeLJ0yLmKkCPcsN3e
         RauLdun2P05cEfBbJCmuHOeYXZk454JBDvadmk3+fPtJ79G7flMScsaAfZ3XsjDf8Oej
         dbLvrK0t0FYsYd2JOJ/jOz2TB6UI8o6FIE1pPGnrxwBC2+l5KTQnpwId5vSfkdPTImWH
         clehFUYqz3LYXFJsrVr0jeHyP9NobMNtmLrhHSd9QCtmNmcJ72Ps5AwdFurbYiT/eEd4
         GFCtk+VtLfASefajumOZfgG1btp4kLfrC8NsddjCxhgKKXjnWv9fS+cWQfcGkP2Frh0Q
         zhVA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789655464; x=1790260264; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OL1rW9y9mHZ7kkv/coK63PMmFR1002GsoxxgXvkjsnU=;
        b=HmidhVfht6DBdAvaFJJYn41lkoHlWicE03QmLoRMnNROGL4uveedlW2a759Sr4luH/
         WIk4mLKgG7s2TR4QzpNe6QI64XyDxT7TiYSOzANaGI49htZUEui5iRCv5LyH8Gqj4yny
         K/9RyZQCMJ1PuQaP1UKpXhjtEiHDPZ+P6vDcUp3Wqpg3KdhVtuxzGZRHFzoiEZ1UBeNO
         sEux51VwC2Q2L1qOGPvP36QzeB8Bh87MA7gzCP6g+bIdo/TT6w3g/Y6bvQFKj5VIhieu
         I5ANbdzYJ+DUVBGqmGj9PTCzS/9aEa8uBGEWVQCSLDgr2+WVNreYb/9ler3R4OoykZ23
         yIdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789655464; x=1790260264;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OL1rW9y9mHZ7kkv/coK63PMmFR1002GsoxxgXvkjsnU=;
        b=TH+UU0d0AfhAwY1okpOhFpL2cpHU8jKL3ANBNG6/OlWh16NqOQu7HD5W2gQRmcirWD
         R8tGPVtvvNpxgY8VGVVB8iy6pwjHE+XJMlUQBMDuSFMkJF7jFxJVIYWfoyMgNUXh+o/m
         faq23NnqHTV9m3gzMOaxHb/qOTIyXD6XExnxD8JtjeQC8oAK/J4sYXquqs7zxBmHNyGA
         27rLQOAXTq2uCiQe8M9G1VrbIY7PHH7Uu1AH80R9lfZ4/PA31iR/qrNSgD+RGhfXwxeu
         x1zkb6uspYEpE3WKiuNuvEt8Ty6XZGZTY7Mgs7QNMEzIibgfz4Vqv4gchR4K11d5WTHG
         BZVg==
X-Forwarded-Encrypted: i=1; AKwUvByFYuTVur5NidEzbiyL1QjbvIwwV/nZ5P++NwbqfCqqfmbs5U7/4EbixEAej5nkd7BodAdg2GmrLA==@kvack.org
X-Gm-Message-State: AFuF++nFW1ujDGOpdzk1w72QO2dcMNqSYA0xxnPCBQRmHAdCf7ZPfUQ0
	8lLx4VlaeJ7ODTGTXFSVClFmGv9qokv7EliL4Ws+a9GCivatbaqmMTW8LDwL79tlk58hNcAvODg
	fbnHVUi9WpbSbVf9ogULQLuhAReflALY=
X-Gm-Gg: AYBFou0/Ae56395uzTfLE5i36J4ZArgcmDbLAyw1QQn6Ec5cx1hS+Ncl9RyTtt25zL1
	0mH0tVqgNhajuskG3UG4E9uioArEa+WYpWNX4SHlH5Nin9VfcPd/KUMRhwiGEHtKxgOS37491i+
	3IXs6zSfXXHBCD0i6vEetfMCEs3EhXsifFPwvkp8TW14BtVWgHjyCoIqx2949reglLIvW5TSSqa
	gMT5nI47mIFw3TrrjtxTRe5dVsQBRHOosP7tBcaj6R8Th63AKMVLS3DbntOJXfE0DAyhgSJGGUz
	nQ3hDbeTwqnXQNGd9AdpM8HUXjU4x90HxMJX62soZOTjiRkdC/ULW7Nm9OyeEN+INOY=
X-Received: by 2002:a05:6000:26d2:b0:487:cd:f1ad with SMTP id
 ffacd0b85a97d-4870d03f013mr9657861f8f.45.1789655463783; Thu, 17 Sep 2026
 07:31:03 -0700 (PDT)
MIME-Version: 1.0
References: <20260917052933.188679-1-jiangwenxiaomi@gmail.com>
 <493ef264-eab3-4be3-a80e-357f01ae1b37@kernel.org> <c92a1202-1fa6-4cd8-9d82-b46a1b5d8f56@kernel.org>
In-Reply-To: <c92a1202-1fa6-4cd8-9d82-b46a1b5d8f56@kernel.org>
From: Wen Jiang <jiangwenxiaomi@gmail.com>
Date: Thu, 17 Sep 2026 22:30:54 +0800
X-Gm-Features: AcwNN1VjxeYLM2KzGJsJYtKrFkqVeJG4mjk-7CUC4wBfKBcPA0GlNQxygqiRut8
Message-ID: <CAHKocdGWem4xW=vZ03maqtHaRLReYmAWkh0rAj63AW7e1+MjPw@mail.gmail.com>
Subject: Re: [PATCH v8 00/10] mm/vmalloc: Speed up ioremap, vmalloc and vmap
 with contiguous memory
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, linux-mm@kvack.org, 
	urezki@gmail.com, will@kernel.org, Xueyuan.chen21@gmail.com, 
	ajd@linux.ibm.com, anshuman.khandual@arm.com, baohua@kernel.org, 
	david@kernel.org, dev.jain@arm.com, jiangwen6@xiaomi.com, leo.yan@arm.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, maddy@linux.ibm.com, mpe@ellerman.id.au, 
	npiggin@gmail.com, rppt@kernel.org, ryan.roberts@arm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B9D6040007
X-Stat-Signature: 7g5a3bwfsuxixqsno8rm8rs16tygrjb9
X-Rspam-User: 
X-HE-Tag: 1789655465-258327
X-HE-Meta: U2FsdGVkX19tpLdKbSox653Xsg2DRwrhVHh7HZUEhFZu+H75ehBe9k75GM+gWU6moe6xZZcuJAVD2tvbXREPzC52La9LdatZ0zjy2plJVFtwKUPyqVy9+HnaPQktT89pZvdhJuO0uQnKDpZMFCkteE9IW9eAkW80TDWkDbZBjGUxkGZ/UDJ8MO+9p/Y3f4IRjcuSUANXtodMT5hVIEidAyk8aLlrWltJlTghxagfaRPPy9IlnZASxlpMoA6RnBO9xF7N8wsA2oKQsrxDCrvpX+b5DBoi7heK6V9jqaErQ2eyOo81a3guK6dqZVTEGuE3SDeqQ8m7L8aSM5cEumcIlhow9KLOx9cifwEBGOruXhG1vuy5SjB87y6q28G3kJjI48/lFAEiRZ7rwRNGP2jftcyQ81kVJkb3Za33R0vg4zSNHAtRRfAcjQyWe74+D+ZDGrERHtwCG1zawIeUo+fgC7ysYUzIfgsgcHBLRTvb6VFI3PY6pMMBFc6/a311nSLLqS7P8SKLd3HLuUmGSEGno9GTNnuE3/9zZ+Jqh300KsR1qf0jZtXzp6tLbtniVZyHc/cu6QPy6WYYBE4doZ+D4vOTDvWpIAVBbZxPQ9IE3Uwttqvx9/gajCzEMAvn1sedMqp5WIMrxndVcUGN0gpD5oYToTjmIXyJVNddWZ7fTu15S+XK3zU/Irjg/8wlNy59vEBhQLlfBzr7mqt1/eBs3Cp/Wfp3jtI9016xTaOfEa32HYi/4ho9ZnT7D72T75gqFTF9Sm5iFEcibhtdO/RAQAm3qOzO6YClhLzGwFt7Do3Ey0LMDnq+0Cxigk0zXuer9hw1dy+jfXdxbQPpgkAMelhsNOaO562VUjXSo889uwJgTih6qW9JSRLeDJGc7+o374zybtSt+JuE/H8LmjMriWjNZtMpKZSnldpVZTZxLYzUYZGjERvfylQN+8tdY1/dKPaqRHwHTIc2SxooiCx
 VTFduwP+
 2k59FLfARB5seny71KdBSdXz37brtk/1Bj0ofi0FasSZUTtgZo4gB6RGC5SWGt+4SvBkLBzUQkJUnhtEPSaLkGwnhXA+sQkCwcP1+sK3kUPJu/rzJecH3pGuHhJr1lrakeeyxt73alAgocP9/BvpGxpcZkj0vgwIc6PYnVEYFq23nL6sOX1Msq50fJtISWLV8N09xGtwtAF43oF/0Z6xTwyyNLcCmVC2Ne7uHEQWhXwVQvQR/PeMyM5xV2bOYZdDDsjDrW/EQLX8U3NTObtA5SzUZ2nCks6fVvqLEGGOeGD/CM1aGR3LxQfqZfjBkrQxJ3ZV1R8AwV8u+zNEymm/x+9py6Jb685sHxaMyl4Od/ll26EEi2kexDabRRP77HVlCW+pf5U9slF0yMLFIMw04dig2ultgSt39Un86aq/wqPXOsmAeLbiZpgGndchIKEaudivR39lqeHZLpPHRSdpPfi2mdfcrvldPFuyWdYK0Hv8EaRm2aGApRPkeRCOW16s146moh2DkCfOV2wA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 17 Sept 2026 at 21:56, Christophe Leroy (CS GROUP)
<chleroy@kernel.org> wrote:
>
>
>
> Le 17/09/2026 =C3=A0 14:17, Christophe Leroy (CS GROUP) a =C3=A9crit :
> > Hi,
> >

Hi Christophe,

Thanks for reviewing,

> > Le 17/09/2026 =C3=A0 07:29, Wen Jiang a =C3=A9crit :
> >> From: Wen Jiang <jiangwen6@xiaomi.com>
> >>
> >> This patchset accelerates ioremap, vmalloc, and vmap when the memory i=
s
> >> physically fully or partially contiguous. Two techniques are used:
> >>
> >> 1. Avoid page table rewalk when setting PTEs/PMDs for multiple memory
> >>     segments
> >> 2. Use batched mappings wherever possible in both vmalloc and ARM64
> >>     layers
> >>
> >> Besides accelerating the mapping path, this also enables large
> >> mappings (PMD and cont-PTE) for vmap, which are currently not
> >> supported.
> >
> > This series doesn't apply. I tried to apply it on top of v7.2, v7.3-rc3
> > and next-20260916
> >
> > Can you tell how to apply it ?
>
>
> Finaly I was able to apply it on top of v7.1
>

Yes. This series was based on v7.1. I'll rebase it onto the mainline
in the next version.
> Christophe

