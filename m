Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84331CD8CAA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 11:43:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9FC66B0005; Tue,  9 Jun 2026 07:43:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C505A6B0088; Tue,  9 Jun 2026 07:43:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B65F86B0098; Tue,  9 Jun 2026 07:43:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A88A36B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 07:43:58 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 005C08F213
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 11:43:57 +0000 (UTC)
X-FDA: 84860190114.09.2C1499A
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5D66518000E
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 11:43:55 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=resnulli-us.20251104.gappssmtp.com header.s=20251104 header.b=Gl0dPuIO
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781005436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h2j6CzARsoMyv7N0DLitThZjZq+4w2DpaYqL8Xb2hr4=;
	b=bHxdbvtWDywOemndw+7Ng6IgzLgII2Kdda3ae7SPBy8T5wLib+bFojfNdp7RMYLbWjk7lf
	yeTW6i3Lw8f3NqVmdIrzytW4m5IFjLTRFLtpNcXkuS+VXnwwyUOfLyJ8o1YFSdTqjtvLOz
	Uj7/78AWbYyD91mqgFwTTA8ZN8h/0D0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=resnulli-us.20251104.gappssmtp.com header.s=20251104 header.b=Gl0dPuIO;
	dmarc=none;
	spf=none (imf16.hostedemail.com: domain of jiri@resnulli.us has no SPF policy when checking 209.85.128.43) smtp.mailfrom=jiri@resnulli.us
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781005436;
	b=rl0zYhGd8uWKxyEcAxFMNJFd1WnGfj/CcAe7gG5d0zs+imFukyeBC1jcudoROsjI5V5SZI
	egdbAIFATYqRyuVG4RChyUITXBmw28IhjYiqxF19z1YT2dABYKdkogmQYA8q8hphTYVwIy
	o+kE5SqMJ70JK7BXdZdgRt/06ZxZuW8=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-490b3e03939so45272205e9.1
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 04:43:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20251104.gappssmtp.com; s=20251104; t=1781005434; x=1781610234; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=h2j6CzARsoMyv7N0DLitThZjZq+4w2DpaYqL8Xb2hr4=;
        b=Gl0dPuIOczB90uZ924GPXdn1eaHGLK5TrJvU/3i4yAcG3JdcYVhdpLL7fAA6zGczpB
         9prL3RuO76fNlpL8wipEq8KVWzUP9R1kP7V9Ldi5+DmL5oC6AuIWcuV1AiUIcXQNrTVG
         rQkZ871fU+ytYsuB090spfGHg1weQkJtZ7OwVrtqvqVBF2cHXB7ofsuAcnaMctKRdsG5
         N7c0xrXceYxPKwwlUjtlIu3CP8FgXXOCrEAF4rWshAT6QmsgLFifKULmW/I1gg+MUNmV
         oTbLwCLzhszphYwUuPp46o+3qQqbtUtMFfpJJs2I/wkNAhZC7w0O+iEsvDmP92eKVn9I
         udAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781005434; x=1781610234;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h2j6CzARsoMyv7N0DLitThZjZq+4w2DpaYqL8Xb2hr4=;
        b=I+aBqupp0FWKOnVvkwarEOJBl5CGLIw1HQmFsyeydNDC//kQJLpcsuH24OYmNy5N0q
         swA9n2FDTJVKlfumCS7uR9mCQHjHLojDcg2TZJBPWRypn8+ppydoAg+LjMmfv9OBGUqi
         WDMucx/A4Cg7ANjDR6mGhV0UdAFw3AC0ikjUKMnHqtvz1P4WPuuk0RhJ02pDp+/3yyz1
         gHoUU20Mum4GmnGChl4fUfJRL2t5004bvRqZuzswFShye7KaXJTtba0jxFElOYkaoWYF
         V6DK+dRAP7wtqsH68sr6VoZ+FOuoAVRbOBiXbE02A8cin/yqKRMNakKYrhhifE+Yy56p
         373A==
X-Forwarded-Encrypted: i=1; AFNElJ/R5Lxj6cT7BE4M3m6r9wUKnp4zJQRidFFlRMHLeAizqdWX4Seex3+LgFJy1fN0aQCoBdeMuZMvMQ==@kvack.org
X-Gm-Message-State: AOJu0YyOWTEoIUBo/fKivGPw1eN3Ugij3IZZUcwFdcBsn2Z3Ppy/tVUQ
	zoSlcPItOdcf5thvH9VCMd7eO0ZJAaJ6+Xq0SwZpe91SemRsqlqtC1kHBf/18+D8NwU=
X-Gm-Gg: Acq92OEjg5XpGvkG6fGwYUrn2xw1gxTZdK6s9BBUY1Axd6VI61kqpDI4hU0SBPlZYKQ
	B+mOTI5iIRlRczaihdE1MtBhZ2qScWh4ZaC1fiHt1N2DEZJyUpm9SG2nS7/DwJX/eyLiZHqcNVG
	nDbIA3YPOJroH2o1J2Ym1Bq+sKikw/4Hj25KUuHX6Vj9GYakqK1iQJ6gKm6smcSaeox9anJcNUh
	bkLbabEW2KIi53x+knwFs8GdrDCEE7gPyEGDMgI8TTv+6NIY8PFEt0SINUBaiAzg3gVGvxS95wt
	Dj9LaOq7oJYUUXFZ3CCJy9UgYz2aSduRMCMOlb2czdUOC/tO2Gdgk2PyR9Dl008QikuKlIXZ0Kq
	nk/OdHyM83LNT1hjX52XxTnXFcuZlUW+xlDkS2WModqhhr7aJMezanzjAarFxxrpyxwWypHfsww
	EgjYZ48jsibFhDXYy3ST6GdWHRFDjdbIG+eF+Y74R/xjijpghv3lwvMQ==
X-Received: by 2002:a05:600c:4750:b0:490:9dc3:3483 with SMTP id 5b1f17b1804b1-490c2cb81fbmr232851615e9.2.1781005433488;
        Tue, 09 Jun 2026 04:43:53 -0700 (PDT)
Received: from localhost ([140.209.217.212])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3b5b06sm432012895e9.3.2026.06.09.04.43.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 04:43:53 -0700 (PDT)
Date: Tue, 9 Jun 2026 13:43:33 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Maxime Ripard <mripard@kernel.org>, 
	Christoph Hellwig <hch@infradead.org>, "T.J. Mercier" <tjmercier@google.com>, maddy@linux.ibm.com, 
	mpe@ellerman.id.au, npiggin@gmail.com, chleroy@kernel.org, 
	linuxppc-dev@lists.ozlabs.org, lkp@intel.com, linux-kernel@vger.kernel.org, 
	iommu@lists.linux.dev, linux-mm@kvack.org, agordeev@linux.ibm.com, 
	gerald.schaefer@linux.ibm.com, linux-s390@vger.kernel.org, Dan Williams <djbw@kernel.org>, 
	Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org, Arnd Bergmann <arnd@linaro.org>
Subject: Re: [PATCH] powerpc: Export set_memory_encrypted and
 set_memory_decrypted
Message-ID: <aif8V0kHzv5CYIox@FV6GYCPJ69>
References: <20260522225853.878411-1-tjmercier@google.com>
 <ahPqbfH54R3JJyaV@infradead.org>
 <20260527160716.GN2487554@ziepe.ca>
 <20260604-dangerous-tuatara-of-sympathy-28e05e@houat>
 <CAO_48GEJsg4X7++zg-ztQgVibY_FjjManaA5_W3usjicGUQPdg@mail.gmail.com>
 <20260604135712.GV2487554@ziepe.ca>
 <CAO_48GH3NP09U6TdB5drbKY0TpwvtBXwrf=Jajsr5ttNbC_u9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO_48GH3NP09U6TdB5drbKY0TpwvtBXwrf=Jajsr5ttNbC_u9g@mail.gmail.com>
X-Rspamd-Queue-Id: 5D66518000E
X-Rspam-User: 
X-Stat-Signature: dw5khbch6aqkk1uuazyc9qjyqhrzunnb
X-Rspamd-Server: rspam09
X-HE-Tag: 1781005435-920929
X-HE-Meta: U2FsdGVkX1/mEedV25fsZSBv26zyQNfrPchsV26qrL2WZyfQV1y95S9aSujFqtd1T8BK+UuGWoDtuEKQNdaoeICwVYrzBT0+sYLvi3q9QQQYpmc61DBWpRjZTqmobYhpyOf1ilrr9frM79qhC5bMvlglSYrNUpynnpga6asfzbn0ByhiqcnRzM7LP52vO+d8HnmcOKJreVtI9iJ+2yHYWrUX9RWRsmy0NraNN/ECJNVl344DOFaqiZ6eWucHigoD1Tg6T/UsVAVqbXXFESJ98cp3IeVUeHokDnv+2ClJ8M3ucGDMWC0Tl6zPXDnnFHZNBDjXLDUOiJ4lxPhIxn1D/xZi/mlByDcf5RHv7z3l83kRjC9zqZRBkDk1JTcf1q+IqtHH4jo6y1uqicFEkoJLxojx+udGzIcaf3X5trvDg3+TmAfinGTPZaxsKhGRUG3NfHrajCJTb/Ug+Ux/ECT9y6Edn3IWuo9p5p+Bvrlecjub+dc38cP6sHOe3Tr71xv77lO6PN15vkATMkplbjU8CC73TkiGE+n5o9uj2nPTz+E5X87PZIebJkPt3GF59CjSQ8f8//XMrzN+JOwcFGScQUj0DwoUPAmf6ANyC/SZLF3dAISgO4gIEzJjg1QxBif3/FWuENKfVQCiMYoU5RzHGzHB9HYLzyvbZ3sVpo9fzLltsL1r3kgqCHhppvFnqFMs1LGmzLHeh7+oxcJSBTYFhQnRz66ehiFySwdpfJvSDp8KfIkZp//N+5ZqIS7NYZfPPCC0wtFSvnAJieC2gTZ0YZuxaW+zwF363foJqptYDlcR3GxmeYJxkG49IjGYlds/8M3FET7u5atN+WCpTQaz8Za5uupWW809xQL7Fi2PKXESsF9zD+1GAEkzdnKZiQyZiE9doHWg9sDwo+38Rx0C+YYk+60VQiM66NmcuCOMOIsz/z62k4k7l5+UPFusx9FWzZQO0RwqHuNDpJqwEpM
 1YBjyz4j
 ceE4vjEPz7pU4REiYX3mYdKK1kCJhJTHHdCg4PjoNwvRrejoyqoteIbbyPnLAv5MI4LaLQ4HvP1ZZgu0Sh6W1kl7TYtEBZ6BrLbo9USNUzpn2RUBbx1BQ/dT4vNFhMffD3XGtKzsQp67OOy0WO29pn8rwFCptL8Y9KSSUjs3gGQj29oqcUdNyFUjHnril4bDoj0dHkNV5v8NoJ7VmShFR0oFh/GmakccFeFjctiUkeniT7ZU7xQJiDJVFAvk+cXnk+qkgB+Ba1/PWSHhQEALMWtSzRlwGQhafuBoMhGVHp/EEOF21vVsEay9X8zQWo8Lo/vthO9Fg2tSSoRxOOXsNZjYKH+862j90mtZQFsvdxCSXNg52sown0irOMnqISvUr8rXyCl2+yoy+57S1L4Iu8AHxypsdhaQkD3gwRGlG4GtU319FEN+g84HTyXuCaOxBRFDsB88mhKFtcZ1FE8sRuaty3FWw8NOMQs1c5GlT9FwU/xA+c1LbztoDFZaJiJBBme8cncEy07LsNJ202+hUuLjSCpR8wMFWQYf27/WII8DEJytidPveuSPFfDDC2QBWzo6rv7xt5YiZr9Zo2O2Wk1Cdzzr7r86Q7htYkUv/cwin77aKJvAd5NMBMMb8D6nwA3gf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mon, Jun 08, 2026 at 05:17:15PM +0200, sumit.semwal@linaro.org wrote:
>Hi Jason,
>
>On Thu, 4 Jun 2026 at 19:27, Jason Gunthorpe <jgg@ziepe.ca> wrote:
>>
>> On Thu, Jun 04, 2026 at 12:51:49PM +0530, Sumit Semwal wrote:
>>
>> > Given that Christoph's objection is not really about the modules part,
>> > but that the set_memory_{encrypted,decrypted} should not be used here,
>> > one option is to revert 78b30c50a7ac until that issue is sorted out?
>>
>> Please no, we have stuff already using this so it would be a
>> functional regression. Revert making heaps into a module since that
>> doesn't have a functional regression.
>
>Thanks for your comments.
>
>To me, it looks like while system and system_cc_shared heaps share a
>lot of code, their user bases have different needs. It's apparent that
>system_cc_heap users don't care about it being a module while system
>heap users would very much like so.
>
>I also discussed this with Arnd, and he suggested we could rearrange
>the code so that system_heap_cc_shared_priv depends on a new Kconfig
>symbol like
>
>config DMABUF_HEAPS_CC_SYSTEM
>        bool "DMA-BUF System Heap for memory encryption"
>        depends on ARCH_HAS_MEM_ENCRYPT && DMABUF_HEAPS_SYSTEM=y
>
>This allows building both into the kernel or leave encryption choice
>up to the consumers of the system heap.
>
>If this is agreeable to everyone, I can post Arnd's patch.

Sounds good to me. Thanks!

