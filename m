Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB940CAC5A7
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 05:11:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D440C8E000A; Tue, 23 Sep 2025 01:11:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF5428E0001; Tue, 23 Sep 2025 01:11:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE31C8E000A; Tue, 23 Sep 2025 01:11:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AAA3C8E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 01:11:54 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4C8111A02FD
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 05:11:54 +0000 (UTC)
X-FDA: 83919342948.18.A97C6B5
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6F095140002
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 05:11:52 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TexsR9en;
	spf=pass (imf23.hostedemail.com: domain of viswanathiyyappan@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=viswanathiyyappan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758604312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H8oZjwkzLuzCrJu5AgJD/IpchDJW9dBa+Wc3mxEgcyE=;
	b=RgjMx+soqlyidQjrkfFEVZaW313K7Yt4mY+sj4W4aMSn/0zFOBf1VG8nI7mrHFHDBq/bmI
	9P+n2iiVtMkZhyab9wfmPKVTp1iZt7KLESjhoohHCz8vPcXb98ehSc9S2q/VR3nJUikOjA
	uRI+JCbuYRxYd2dbiUzwm3C7qbN7Wxk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TexsR9en;
	spf=pass (imf23.hostedemail.com: domain of viswanathiyyappan@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=viswanathiyyappan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758604312; a=rsa-sha256;
	cv=none;
	b=j38MjgnN2PmpnmKxvgH7HLIBQCjkkqe282R68KjN76sRt0hIhSy4JtfV7MEUf8vyxgd9p1
	HLBVRec5VZDlEQb2uneY8UoEMScw4VONgJZPFLC2Y2JZyciyW8ZN0pke59cmDSL1Ww07MM
	yDE+gox1qDBKK4moDzkGsZe5IcM05tU=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-61cc281171cso8176696a12.0
        for <linux-mm@kvack.org>; Mon, 22 Sep 2025 22:11:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758604311; x=1759209111; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=H8oZjwkzLuzCrJu5AgJD/IpchDJW9dBa+Wc3mxEgcyE=;
        b=TexsR9ensA+/Qln9ShKIxLQsGvsnpPoiVMIGVMYcaSFSEhLbGLgEt8gHFTymogIO8f
         20UE7Uo5Px3Fa+w0creZnwD+zVOLjDBUUYpMCTn5LXkaqOu55OwAb5lq6FmXs5qrqZY/
         U+FT+Z6aBXoWwbozwSuZBz0okFgYAhDq28nnt9Dj+9QMQ7pyBavWgijSy5jSz1HzUal5
         UlupOax+Wfk/3QMYtioGIS7rn4FYFIQ1ZMbbvbdBT/FbiEiaw/V3539ny338VB8duV6X
         cXJ4p7R4VXUCHrud2UatzcZLFwuqQKGfZPdcGQEFnTYkb3+D+cJX/ynpKVGFjKbWfmjj
         4Biw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758604311; x=1759209111;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H8oZjwkzLuzCrJu5AgJD/IpchDJW9dBa+Wc3mxEgcyE=;
        b=QXiRDjRlwX9k3oHgWURs08CXxUs/yWSuDabR3RjK56yFwIr7/iwhMmC5E8xBEDL8+3
         AwvHmB1gF30JpxvAS0es3ST1Lngyw5Yy7MZpmod1iA6v6HF6g4b+Yhf/6l/7LoIUl3VK
         7miZ21iS9aQt1eBEDOLEX13ykx6EQQXU/VNMzmX3nsgKUFY7ZgQgaKJnd3avq/xzSBP3
         yT2IG5Qf9g1r70lzdscZVMsCJJ1PSIAoUxqUk1lwl8znxZeGuHo1KJ1Wy3HNlD7TWmRp
         /FoBejEMTDpQynIRNUGPWbUQAAU8lBM7lHShuZDD1tYB2zCGDoFNNDMVWncfvYspZygF
         5urA==
X-Forwarded-Encrypted: i=1; AJvYcCWDvfEn9xEvevB6WieSkeQWlLkUVpeUi5yF+Z/siDpcBzzCr+SoAqs3D/GyWXnvOWoTxgLt1kAwfg==@kvack.org
X-Gm-Message-State: AOJu0YzSyHtmTrpIOTm6RM5JsBxxqhIUF15298wjHZTo3+J87bowWvmH
	DlJ8EO83wJaiWYM71CLlgsW4M9vxnu8wGfVxNyqn6ZjvFT4DlLRcTLDSFNAwtSey4DvgbF2Tq99
	I3RNxWrdJ7R3QgPou/qQrWzxrQ94SKaU=
X-Gm-Gg: ASbGncsTaULib5tCG9UPMbLS2MDvqAqaoMOYabtEN/2WTG+FUlr0b8b6+dAXS4hoDKp
	5GgFAmkbhj8rtXnA2MrKGx2BQRotKMfTd+7NTo1thO6M18GW9UdzTahw3gobVJwkaxDMewpOiLW
	CYpMmDSAwnOKqxSpWnuz4FcmN98ifzN77hVS7V+GTro2AhTUJfHMs7N1/vBenWBawki2kbu96Os
	gocFVIf0HG1Tmpj5HPdhy1NeKNoUmaKIiruUOGxOq0R1+feWbFjqQ==
X-Google-Smtp-Source: AGHT+IEPRdvpieHJw8RRRxoSE2PSWeDmEsF3LD8Vt0hJlWeSXhWvyc1YF2YZ1JHwU/y/0MfHKNaPmCTEz9q/HlDi2A8=
X-Received: by 2002:a05:6402:4311:b0:631:b058:bf04 with SMTP id
 4fb4d7f45d1cf-63467812253mr1028138a12.19.1758604310599; Mon, 22 Sep 2025
 22:11:50 -0700 (PDT)
MIME-Version: 1.0
References: <20250922170357.148588-1-viswanathiyyappan@gmail.com> <aNGOnDb0WsIbk2zx@hyeyoo>
In-Reply-To: <aNGOnDb0WsIbk2zx@hyeyoo>
From: viswanath <viswanathiyyappan@gmail.com>
Date: Tue, 23 Sep 2025 10:41:39 +0530
X-Gm-Features: AS18NWAz93VsrUOfHCTB4kaK6hHURodNuYHUG5D8F71sybC2WG0KWMO2FAQjnLQ
Message-ID: <CAPrAcgM=-2dvHg5yvsqtT_YfjH-gThc+iGZGJpc8gpKbg-OdrA@mail.gmail.com>
Subject: Re: [RFC PATCH] mm/slab: Add size validation in kmalloc_array_* functions
To: Harry Yoo <harry.yoo@oracle.com>
Cc: vbabka@suse.cz, akpm@linux-foundation.org, cl@gentwo.org, 
	rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, skhan@linuxfoundation.org, 
	david.hunter.linux@gmail.com, linux-kernel-mentees@lists.linux.dev, 
	syzbot+94d20db923b9f51be0df@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 6F095140002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 4m7espyw1gxhqweqxm6spp5ybkm3q3g1
X-HE-Tag: 1758604312-226811
X-HE-Meta: U2FsdGVkX1/wv3savtl5D1FRZUjNbvAB7BH/937aBWZGPJiqcPdvh0RaBBONt0ZjSeJDJOPtm36yfNvJM8z3A5kuSoij5DRPklbhI3USjD5J1/IvoLYZlxIw8mBR5OcdDbbpxwi3L9tuw++3QtwWAPILTbJjBwjZTqfup9vlGItqsstlHea/DK70oUcmbKP0+Jigt4uFznAlgdQamkZppuVhUVhqgpVpRw8jbFUnYRSO7gx7PdQQbGsFqFDbKKqpKuFkbj2sZQ9ifDNJ2IX7nAMJBWaBx3l+Tj6lp9o51tEXj3vAfeIyEqfR+gb3OU3egjy73XzsTBC4RnnnajGbCfGEDAE1nOCk2sTXDl7k3V37Qlqwuu0xKoABaakX15Am9XV69FnUnu5hl1ufrQdVAuX+eMbNbOFBVbTToqdNbR1QwuM5wCL6oDx/egotTBjfEpJk2kcxIMA3IFx4fQn0KjWOykFJGHxYoZtpS+IXYVeTdBupe9/bPL1vE1LlDLgAgPFK/hhAYnR7omEZyrLBKECXbhPujiBRXJOvmJReKFYf31RA32KFMR/PoIa7fiC7S0ipm/KP9ZkqF/H9uB7Fys41QMzxhZimcw1OigNK2weVW4UBRgZPy3EJaG5FnYXM2OM24Uj+SdgB15TzTwHpAosk9Aj1AjgaVvbKybBLnJ6Y5pCLTI7ne+dypOKy6PlJvhhNe5t1yz5pjVgqLDv70VTClwjel5ytQyQi0nE7kQz4/fUui4hPqVEswMCdxMX75BEdcKlMfiVzkMt1/gSLEo4/dujAe58dIIbaFreDnohRXybgMLnMsce7XAcllbdXxA+D2rmKvkKEEjRwMKMqrpHPHOx6TekhGOYK9t2FmsurNUPJAN4GBGeaXlQTBp31+B/gWwReXssZ8ENTfQPFuf+1+9cOxNfa3Xzu9AlotzMEkwhJ60YqEEs/MDqStmC7AhSib0y5ZAnrzjR2Tga
 naZMx6W1
 5MN7RxAYsqsf5mCqBKMdDCeUpbyYDWn79I26HOnzD+E0SKVZbxQjBfU4VXuUVtvihJJBAxP8AQ5oAEDIrswqVnz+0tIQDF58N59PViscwjefKRRxHphsteKLOr0WCc3h0gCB7p+tuIyo+e6YAYdxH/OqDo8kx7C8BpoxEpisqRS5CryxHZ3dGzb/FlV3nz1iiNemoDOHNJY1RpUWU9biWKRPvwyYzmwKkK8wvBbVJuJTKp8GprJK9lMEx///lllzk4EEvBf87P3BexU2t4Ki9ZhUdVTSEfkKbq87NkNVW11LbWxypr8mbJf26oN52WWjUST7N6hpVhCIukXF8I0O70Biq9GdSsXAV9jWI5xbMW6HC4/M5VH/CdODQBE+7LYP1XPkfMDiijNpWnBYwxuSqcMfP5cq61Vy58jFjJRbNd/NCp2XMFoTzWEi2C57srmR5IVOMRHg4Wr/IUkkkTlcXlKeq47Mhjgw3iuCUFIl/Irum8lUWhW6mwUvIQccaXMPUfANXBIedL1ErZfA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 22 Sept 2025 at 23:30, Harry Yoo <harry.yoo@oracle.com> wrote:

> When bytes > KKMALLOC_MAX_SIZE (8K on my system), kmalloc redirects allocation
> to the buddy allocator, which can allocate up to (PAGE_SIZE << MAX_PAGE_ORDER)
> bytes (4M on my system).

In include/linux/slab.h,
KMALLOC_MAX_SIZE is ultimately defined as PAGE_SIZE << MAX_PAGE_ORDER and
KMALLOC_MAX_CACHE_SIZE as PAGE_SIZE << 1

I was using those definitions

> Because allocating a page with order > MAX_PAGE_ORDER page is never
> supposed to succeed, the caller of kmalloc should be fixed rather than
> kmalloc itself.

So, Is it almost never a good idea to add new validation in the allocator code?

> I think the right fix should be to return -EINVAL in max_vclocks_store()
> if max * sizeof(int) exceeds PAGE_SIZE << MAX_PAGE_ORDER?

Thanks, I will go ahead with this approach

Thanks,
Viswanath

