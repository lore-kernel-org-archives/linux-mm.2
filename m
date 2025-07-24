Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0963BC83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 09:27:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CB948E0067; Thu, 24 Jul 2025 05:27:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97CF68E0051; Thu, 24 Jul 2025 05:27:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 843D08E0067; Thu, 24 Jul 2025 05:27:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 70A048E0051
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 05:27:11 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2FBDDC0300
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:27:11 +0000 (UTC)
X-FDA: 83698629462.19.4D9AD3A
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6CE5240012
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:27:09 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=m0ercfIH;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of 3a_yBaAkKCLYWheYanudhckkcha.Ykihejqt-iigrWYg.knc@flex--aliceryhl.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3a_yBaAkKCLYWheYanudhckkcha.Ykihejqt-iigrWYg.knc@flex--aliceryhl.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753349229; a=rsa-sha256;
	cv=none;
	b=m41EilOlnx29gGsNjwn+LYMbgE95pAAzem8ExBPxyUcAXdZt7fJvBUsgI87HF+J4s//BJ4
	N1jNuNDfGsRVwUdn0VP/Gxlt5TuENZrDqqLQRP7P6BYA7DCdb8wyS90T2zgL2bqeN7e56f
	mgPQGHkuf6f9ywdai3mExMn43jUXXXw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=m0ercfIH;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of 3a_yBaAkKCLYWheYanudhckkcha.Ykihejqt-iigrWYg.knc@flex--aliceryhl.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3a_yBaAkKCLYWheYanudhckkcha.Ykihejqt-iigrWYg.knc@flex--aliceryhl.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753349229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EWsmFNqMTJifoq1H166MjVpnMG97Pu9rGEwqko2e+Qs=;
	b=O5igUOYNxb3EYX/W2xsgduNDgpNjtcd9cbgmfiOiQ8O/O6hUCW7YcV95MHHSPwcUs/PSsz
	21oBixtoA9siJmZEz9eIHR5sxedluMmGP1lCVOE4+HiB09aL5ADJHqbwlL5QmbP7L9ctin
	RiPccRJM9ByDxDZNREloXDsF6L6H3Yg=
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-ae70ebad856so52057066b.2
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 02:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753349228; x=1753954028; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EWsmFNqMTJifoq1H166MjVpnMG97Pu9rGEwqko2e+Qs=;
        b=m0ercfIHNn53WpYvZZWLbyMRdz+zwCYrqFJsHA3A4+FAepcvsRQJPSBGqWxpsvelJc
         FS6AcXwV9oHfiYDHnkzMJjnQrjQQXYdTZZkkHhKLBgGqRJHjqywF2KwlfwZrlvnSzF7C
         C27INqgg1kf+gE8O9cozDROpCdYV7minjGY6U2lXRw1AyYOPJuTJWLXgprJPv/I3ysaB
         x2X6BHd428EpGD+BtBAjxXPPDji2Gf4t+pmghSaDTVboXz6b6pgcmXgbdq7bH1NYMOuP
         38ku/Uw8Sx8Aq5UVq2viT7YUSssYd8kU+zzg2JFivn/A/rtTPPc33hUTwFTVgKMvz0mj
         lakw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753349228; x=1753954028;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EWsmFNqMTJifoq1H166MjVpnMG97Pu9rGEwqko2e+Qs=;
        b=gN71UD7LanB8/p6HNVx7wmHKBgdB2OZtisGOml3AIYYfo0kklZBk/9ev4n1BWvxzgW
         W5IBhLOlpyO5Rrt7qr5pj6R6x52tYYDgzFyJ+hTf+78cOQnHmcYogZ90jg5BmfQbtR6r
         8o4+3X5WmysyhksF3EQDcVMrIMCBf8tp2if+rwMWiVOQFHDSP1xLUPoPFVnXjG3TtJDu
         O+pk3Gw2HW9y46y4UPqyyOruabI2c4/TxsAcd2/RFXjvh/YdGxaZgHRfrqldeLUExdWd
         eux14MkIqysnahwwKJ/tce1QMHHuMhRToMOAKEJLoIm5oxrxmJfi4+26CwSsgl50UYV/
         HlFQ==
X-Gm-Message-State: AOJu0YwcK+GdGjekHWvUJHx97ZDDIcIIIH2RY5QtKjqXhpT6Z+rL0PH2
	HPsfflbRmUdp/QJsXkswwXXmCcr65ejaSebPwwOqQ6ZGPX87qnuy5XvizGviCjMoaFH8JYPN/RD
	a4lAbkUArkWflvOIQPA==
X-Google-Smtp-Source: AGHT+IGtDDoKDFdpf55RlRT16x/MrXLiY+iPYPhinM0WVwWZbH0DR7wxKq7NKGyO2VWyDlAiEA0xZK8qvSrqdQk=
X-Received: from ejcvw7.prod.google.com ([2002:a17:907:a707:b0:adf:bef7:bcbf])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:9fc6:b0:ae3:4f99:a5aa with SMTP id a640c23a62f3a-af2f64bcdf5mr605481366b.4.1753349227748;
 Thu, 24 Jul 2025 02:27:07 -0700 (PDT)
Date: Thu, 24 Jul 2025 09:27:06 +0000
In-Reply-To: <20250715135827.2230267-1-vitaly.wool@konsulko.se>
Mime-Version: 1.0
References: <20250715135645.2230065-1-vitaly.wool@konsulko.se> <20250715135827.2230267-1-vitaly.wool@konsulko.se>
Message-ID: <aIH8as4gSAJ1dTl2@google.com>
Subject: Re: [PATCH v13 3/4] rust: add support for NUMA ids in allocations
From: Alice Ryhl <aliceryhl@google.com>
To: Vitaly Wool <vitaly.wool@konsulko.se>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, 
	linux-kernel@vger.kernel.org, Uladzislau Rezki <urezki@gmail.com>, 
	Danilo Krummrich <dakr@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, rust-for-linux@vger.kernel.org, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Kent Overstreet <kent.overstreet@linux.dev>, linux-bcachefs@vger.kernel.org, 
	bpf@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: n9wfn4hppgzi914pszxebkuwwck1cjd5
X-Rspam-User: 
X-Rspamd-Queue-Id: 6CE5240012
X-Rspamd-Server: rspam02
X-HE-Tag: 1753349229-545579
X-HE-Meta: U2FsdGVkX180a5qY9rZc6Rz3elYhe6COhAh0J0AMN0j8i+5/VoZ/53fZvMbveTBPDGkb9fAupO3jZXY6JzZHFpChgqHmXeVXF+cOHmHVocOU2af6KARnYenK1nRdHzCVo7atzQBEaXZk2XqqiHxJt43mdWkjHv13EFCmKlY/NbBFcv1YoHyrRRzfwnmPZfYNA6ZywUyZbGqmYDfnW1O8HX4lSQ1ByiRWzhwv9XKSXt5sDnwvkNDU7Twwnlm313hMfYoLJY3hZ0zVrsFGpXUdJKSByWd2HUYhK4GxFoLHAKLOyBoHG00AiPqERoyglDSsANhJ003WDi6SVxnDEd4NnuBh9l6Bito8g9fRzqIZfF3zShAmXCGJeQLBdJUc5IT8aO1F05uIrlO1MArfR84GXgseMA0tbOsDsPI1xvP7LvXmQyvBQAq2oAQGeiU5ivrUgh84iCJhxGaKuSXl5aR0Vsixi3l6bdZ8vW6SB9oc5AMfp1Qta400aPKHX5Lih3LA/Qs/hrPPgAKukEU2cPpUikX5hexcJTD/Kh04t6Ct1LInm2g/apvEVkdzS4Sxjel8RoDgZAzcVMg3HA3EQfTH1w7EjFhpbwDjq2XoY7/9d4I7S2cIfLl4rlAUVPc2PgaVia/T0cBLGYOYCufXs6cz/lw9Acim1Snb0KeIFo+/MSoBljxo0SJ6BtRp0UF74OLKUwg1U6M7Z2HdfGlknGk2UOpuijOy58i+jA7SpYZhbNJhRr1qj7jCQBrYO9RVxg8nwXpYhVN9LdSFxuKpNWuCp78elInFpaAOgxvqopLr0+rGzoQ395Z0QD/CxskAWo4G+c7CFgRQ3UwHnJQdXCAEwjntZlOAy6XzkgpbW7Tf3LkmOz8Zr25MkdFrw7CCVwM7itLlm2gzskkR6mWMuWaVyMMbWrp6JBd3X0kiR7LQwuHnEsU2uOSjRbQvp0s0LA6iWvAT0NMYEGVLMeHOYhk
 VmDspQOy
 1Sb4QRcl8ZPSZ/ZDI/pUQPdFYxijWQ8tIBc4mxZ027E1r9tq6fjCZ2otFkR0qwDrFtCq6rQVyWRhud55gyUora3VN3bfiCANOk95u6m969OOYVOPnDGmN1r/qJgWKv+qpFh/ovHKarr7YOBkXo2BeaSqPOjOiWkd9qJN5qTeeF09wp3AJk99ToOvOq15ZTPOTwQRTzje5OZkS1hKadOxHa8ryBy1LMuNKHuoN5GIOj8T7SW0kbFLG1wPF2iQ4VmvOkSfePPVRnVPBVTMB2P5wXxUxnd2tfXm6PRIGMnDi0aKqOVeacjYu1wETwbUEZvjPR9ZEXg9LfXqXbPgngkO+pogxGch3g8XEuRNi6t22uJRAtgUTzBghJ/hgC2i9fj/zGdAs95R7ujMdbRkQcFaGleuhWcuB6M7qh30F7Ob6XKFJCeE1A0o6x/aJXx937lH5ZLt7VIBy2uYcQf9zaAvx/s7LdGhmFIV/KwDBjbJ5TO8Gz0oQjksMyOXK0J78WVJHKvm00k2MB60kGy9aKr42vJS9XVgQBtHRN3AYPKNOkKUazKwM4drmVQx4QmBFKiJm/OScuNAXn3zX4uoavFLU9mwS9wuxCr8UuWrycvE/HVLbTudZVMB3eRYNqQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 15, 2025 at 03:58:27PM +0200, Vitaly Wool wrote:
> Add a new type to support specifying NUMA identifiers in Rust
> allocators and extend the allocators to have NUMA id as a
> parameter. Thus, modify ReallocFunc to use the new extended realloc
> primitives from the C side of the kernel (i. e.
> k[v]realloc_node_align/vrealloc_node_align) and add the new function
> alloc_node to the Allocator trait while keeping the existing one
> (alloc) for backward compatibility.
> 
> This will allow to specify node to use for allocation of e. g.
> {KV}Box, as well as for future NUMA aware users of the API.
> 
> Signed-off-by: Vitaly Wool <vitaly.wool@konsulko.se>
> Acked-by: Danilo Krummrich <dakr@kernel.org>

Acked-by: Alice Ryhl <aliceryhl@google.com>

