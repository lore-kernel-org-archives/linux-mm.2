Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A709EC61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 11:39:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5B4A6B0092; Mon, 31 Aug 2026 07:39:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B33716B0095; Mon, 31 Aug 2026 07:39:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A48A96B0098; Mon, 31 Aug 2026 07:39:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8909E6B0092
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:39:42 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1133AC0459
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:39:42 +0000 (UTC)
X-FDA: 85161369804.05.28CA2E5
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf28.hostedemail.com (Postfix) with ESMTP id 359DAC0004
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:39:40 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qx8aHArZ;
	spf=pass (imf28.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788176380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t+e3nkWCWmnCXTSnQisaZ/JcY9969zoxFZBJ4/hDxuA=;
	b=xrwuDan8aPYpmn05FEp6naSUla1gZGlWOr+JneAwJXymR22BjX9VciGoQMQHKvjY9iuaOo
	0vrEJBfxSnx20pMwteaFUe7gqChbl3l4oi8k4iD2/p18JO15lkkWIiP9YS7SxMji38uaqN
	hrxbzBnruqU6tyLl7RZxSwhB/1J22Co=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788176380;
	b=zwywYRbsH/Rq77KdCiwJjzFQhIjv5FdAt+GyUKngKdwO+lKuvqtciFl6W5KKEfcuz5gQFQ
	k/fNZAoMFreOACJdfJ53MaPgKWkC7FSauDdaF4ohvGKJxWjDkvG7UZcuP0H63L8rSE9U6L
	eJLRw8GLapYhJ19JoSiabTGL1Qt8Ed4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qx8aHArZ;
	spf=pass (imf28.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-47c2b362ee2so2928224f8f.1
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 04:39:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788176379; x=1788781179; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=t+e3nkWCWmnCXTSnQisaZ/JcY9969zoxFZBJ4/hDxuA=;
        b=qx8aHArZ6UtyXDs2nbdssD1CLMkKo2w+CrjIoH7ZX19QEzHczOYXH+FirdilvyEtzA
         XrxGpHKFyJnsnBLSXjCQJus1Gdsj3kAtl0zfogRkEvhp4nxDdt/GvBaXYR+4k/BsQqj7
         PI8iH5i3gC4gpXjDcIBE1EgazzMRwzkaSY01zgmpbaFX5baUGp4RggrZH56uuMEwbm1k
         /VpnMiRjGHuQ4vW5UuiQxTRkpWvgK1eg+OGQBwOTmwOfa8eamKFUf/y1EaiWZTwatAEM
         ct6PeiMP+fCX8IS/Qbehsm+CJ+Shdk9JUxpQAW92/TBhnbM9/q76F9hoCEQyYq5B7ZN6
         5iEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788176379; x=1788781179;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=t+e3nkWCWmnCXTSnQisaZ/JcY9969zoxFZBJ4/hDxuA=;
        b=Vcm5It3RtMMMwK1QDA5oyAwIQnNTgz8JDyLImFPBFScNKn8aIf+oVdMq+016NbiFFP
         0h+GH4QLcv9jYmaBvJJs7OXouQF9u12L1PQg3/A57e5h9LGjtPUkFjBMBJcIqVfDV8h5
         ASbVtqz6VogKQ1JjETLA6qK63FLIS6kuKbwMzeAZP8SN9u4GNR9dQ/9bDT3nbbwe+C50
         2aOncJLu/h4Y2PyR5cGhSMqzY1c5z/UoUIY4hEUy0uczmPGly+fHO2h8GekACXNX9R1a
         HBk5+1FN7Bpx/fR6vKgZJ2YV3Qxop2vXaGrjAaLLBFpXsgeElLi1HEbXtXl2xOo0Bcne
         C8Jg==
X-Forwarded-Encrypted: i=1; AKwUvBzYSDtQqmwL0gFLYGpErUJRZ0DSjFkk9IeaLUddCaPKy7DAjzHa4JnmURqbda30XhAPZXPeKxW1Pg==@kvack.org
X-Gm-Message-State: AFuF++liaCzpHWL53XeoeVhq5/Y3P3TCpo0MWaE59xRc0MyqJrp/QDGc
	49pngEpayq0irfy848qroEzpQVwzQRR+FK/Jsabptatfh9iCInAvJs77
X-Gm-Gg: AYBFou0uhxfxtvnmZZEfcMwJgD7xCULsS1d/zfqjuJ//f6W9NQQL2vOp76WAaDhc5D4
	DAxqFvOng0hphY8EoOouIaXtydEGHBqPauzO3UiYgoXDW9duD7xN/WT53CwygKX+py69Bwi51uO
	BRCd2ixUUaQQayjLmiawGkx91znOtAEcpaLPyQlUVIzIRU9yN1kfgvf0mEscvJRSAFDaptL1s+X
	8JRIDFjCGHy0fD7BAyH8B4uhMtYLazC6uzJTKZV0Qw3xmBy+VctF3/cnMvsbMl3fhO3QvGuxcwA
	73tuMKSMiEKWTYnMP6dqCe7xiqAPaPTq9sckLE/8IrsfrZl4UK980BhEdrZBuxGh/3l/SF9VVFh
	pyg1OA/6/e/sn0VT3/ymSSos7ebccWu7MPlrMBuPpiU9TWm9bXF0w6qEhyy4Z97MLIdN1g9fXV/
	3qxaZdSDOvcSUVTz6uBoMsh/nCsrCdtRfv4cPhgHMZpwIYj/vz4zZQchvQnL58ktAI9WB9bwGC/
	U12OAPmmj1Bqgm1TsJdfnVvrQ==
X-Received: by 2002:a05:6000:480c:b0:484:3f5d:7dc3 with SMTP id ffacd0b85a97d-4843f5d7de3mr3330798f8f.5.1788176378681;
        Mon, 31 Aug 2026 04:39:38 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4843310ab29sm14535272f8f.0.2026.08.31.04.39.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 04:39:38 -0700 (PDT)
Date: Mon, 31 Aug 2026 12:39:37 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Eli Billauer <eli.billauer@gmail.com>
Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>, Arnd Bergmann
 <arnd@arndb.de>, Brad Warrum <bwarrum@linux.ibm.com>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Michal Simek <michal.simek@amd.com>, Ritu
 Agarwal <rituagar@linux.ibm.com>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Matthew
 Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 2/4] char: xillybus: replace __get_free_pages() with
 kmalloc()
Message-ID: <20260831123937.32255a49@pumpkin>
In-Reply-To: <f6001085-9234-4025-ff34-6cc4a66c293a@outbound.gmail.com>
References: <20260830-char-misc-v1-0-05e2ce44f291@kernel.org>
	<20260830-char-misc-v1-2-05e2ce44f291@kernel.org>
	<f6001085-9234-4025-ff34-6cc4a66c293a@outbound.gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: rkf6yyao45tnm4499oknsbzzcrofwhhf
X-Rspamd-Queue-Id: 359DAC0004
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788176380-498034
X-HE-Meta: U2FsdGVkX19MNuFcZG8dMAFO+uwv9Pjc6S3834Le03Tggv22zagInpTAZ+eydVjBcUzSovYWoSFhvzCi1aMeoDhDt+umnJJzbHeWJap3cYn2uFzvfIWE1rUU0rWtI48lXabsdkK4SZLvcwGcUdtQSyqsEp2jljjdNF1i3pmqdpH/pnp5ICe0cS52KLzG8Y58lrHysQE6di2FShcDfzVNqgTUYK5lYcovMhLBWMC6KsVX8VPgqSI0ZJ6uYQmDJSIeSwK+84gQQ6tq2ibiCMN0SskeDS/gkqQK4hpf858Ig3mY1L48PSX/YkQfpC1BhcwnSLo0m742Vq5iFxzMy+OUr4ZZ/KFZjdOC8sVeiMDIjzZteYsseDQo0uRdhcHfCwzo4rSnLCAjf7rv+VxlWzlHrZgljTG18Z2aaLAvPgMO4Bwk1au7j56z9qs6+oYAFkmGsMzB8zblQiB0DeNPCdwMlJmUDiyRsGUdisrZ16fdQRTJNpuFzRczGj/cYjl2hfFnZAHzCHkLSaZElJbZGchzUomp45FVyoJeBubQjkrXVDKs1r4WxfFcxsh79UV7rvA+8ieyooDKo8I2PHLNKdAFjTUYatONz+xURsoxK/2QPBt789v7h6gSb8EHZV2a71tvBNRkjfvkyjgf7wn89A+f1XsxWcYgSSfPGrlrNa2Xn30eTazcvo3YkkcOdAz04W1BDCxn/8oYs83FLeQwpWDLdrGYr3o/JYUN2eIhWuKkCyQ1YDezyCLphO1RXLKtVUwFBywY6s8mWbcJY3QlkXbI7Vt33LgSCK/6kWOD3XiFHC27ytMrDUE4tWczqW59AYV8nvMLQfPqK2Lq+9dJvHxfp7o3zJD7nvBG+uWppTs8QfLWOF/8VG0DDBv6pMFrujzT25K7qNcB0P4Ylxhl9ICIWtRbHgDMuOyg2oafY2lGO9ZxpYUiY5ARm4NxVmxHrWxeDSR/M8rdidGnL79MxsE
 v3RAFukN
 DGTxt55hLIAz7y72pT58hbDTi/GAfpAyni39Kei2q0TDnVi5/gqGY8pQg10iOYX0vtM5OCYuFT7t6NAzrHUF0RDaCkyujW7Fu601zMbDT14sFKV4sbWfx3AIw7X2rk/8hH2vNaEVqsy9jdMCAhFJwx2C3Jg3NRoPNfJ5cjYi7snREfBtFeRPppWdy2dioCr6xp+gQuUFszOvQiMHtuKU8BM5/Ac9UinKanjMobJnUv4rpmCHrkH0A0dglrvlZFfxne+EHQU2GGbXwqSo/v3zERK0Zy0xnvpkmKr7J79qvpj4E83CjiH0xxMhafEHr/a8rnQMHN5yKPBr0vT8EaUE8qQkODVYjcgnFxH3uxN7JELih+Y/7l1SKU0QdkhekN4rafbhnlBVXY83WGZQD9ojPo16BF6V7j5ZVDK6Q14pPLFH8WxZIsb+xkbjLf7+tGUeHBQ43pYuvBOscpM6S3tBNrdRy0nhIsyQlaJpLRoRCaKg3IELFMiYbux0gSCgeYTgoE4rzh/GqXiMRKGdAwe3CQzWlkf9mTuWAGNE4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 31 Aug 2026 12:13:08 +0200
Eli Billauer <eli.billauer@gmail.com> wrote:

> On 30/08/2026 9:47, Mike Rapoport (Microsoft) wrote:
> > fifo_init() allocates the buffers backing the software FIFO and
> > endpoint_alloc() allocates the transfer buffers of a USB endpoint.
> > 
> > These buffers can be allocated with kmalloc() as there's nothing special
> > about them to go directly to the page allocator.  
> 
> Except that they are a bit large.
> 
> fifo_init() may be requested to allocate up to 256 MB of buffer memory. 
> This memory resource is split into an array of buffers (fifo->mem[i]), 
> each 64 kiB (or less, if there's trouble obtaining segments of this size).

Would it really make sense to allocate the four buffers separately?
And/or use vmalloc().

David

> 
> Citing Documentation/core-api/memory-allocation.rst:
> 
> "The maximal size of a chunk that can be allocated with `kmalloc` is 
> limited. The actual limit depends on the hardware and the kernel 
> configuration, but it is a good practice to use `kmalloc` for objects 
> smaller than page size."
> 
> Regards,
>     Eli
> 


