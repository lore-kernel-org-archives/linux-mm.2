Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7157D41144
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 09:25:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DE1A6B00A7; Thu, 15 Jan 2026 04:25:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B2AE6B00AA; Thu, 15 Jan 2026 04:25:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B58D6B00AC; Thu, 15 Jan 2026 04:25:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F417D6B00A7
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 04:25:27 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D22331A0278
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:25:27 +0000 (UTC)
X-FDA: 84333665094.26.FC1E1AF
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf29.hostedemail.com (Postfix) with ESMTP id E8452120006
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:25:25 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dg8tyO+u;
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768469126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WYui0318UOsS6VyHkKkmfrBiXM5qykug+UUq04REjYo=;
	b=CJ+8+TQYQOT/v42GtgLyNqEwnEmjSy2p3RjBWK9A1Ku7O2jCOzUqZHR9v6gFmVQuq5wpaJ
	PYl4qnjJPF4jqbrX3mxTTDUaemsWwiNFYmtwCj6nOTuplxxfpBeIO4pb1YM474q1bJQPEg
	+Vb/N2xDfJaa1lNYjhP96VznvF33k6Q=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dg8tyO+u;
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768469126; a=rsa-sha256;
	cv=none;
	b=Gczwu1TLgI8kaGFxApcAFd5/bMVI3mqcARm5beIUuQFotMcGdmuvcVg+J7u7Q6klTdVMjY
	TXySLNT2I8aSgPZOYPGXzCRifax6WOkBKgbeZubN7Nv06BaMNVDGm7WsnryQNwyyu3leqH
	7u8iHFYxqvWP4QuZzL0wqIBolA+a/yg=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-64d02c01865so1106411a12.1
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 01:25:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768469124; x=1769073924; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WYui0318UOsS6VyHkKkmfrBiXM5qykug+UUq04REjYo=;
        b=dg8tyO+uvHffPYkHO7SRGs8BQKdugizXy0joWKFrS3XEij4Z7ocLCn9lgGknw+Us5F
         BYIs9S87QLZ8tcxZFDxHR2xrXf9GlX/KMPewZ/IazgNPYEA5qj4qgJN2I60YFA3zdjMB
         P7E0KbBPxl99mTF6rMVRCmxBtrpizTK17lYLxL3Br7L5PojSGEWV24hJmtomoWRhHzFF
         CCqvj349ME0cHRkbjT3q23QOuAoOnJRk8I1R3T3T4E8b8gSjV4F90XvNrUUarMLftfmR
         S0tUaiZL43DAbPfTkckg/NkhZAdZIb+ekzMB5AVQ0A/JTgg80Vozj3stdD+pglZ6WcFB
         2Wgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768469124; x=1769073924;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WYui0318UOsS6VyHkKkmfrBiXM5qykug+UUq04REjYo=;
        b=pWQkTY7vy1k94N9qbTQD8jg7XfnbqptbDghn0kmCVf/kUOtn3ehYzVnAd3Fi3/yXTE
         3nt3sDa6S0gap3Zqmfns1O5CyB2Gsn72qFnQHNXRwGT8uuFXRPDLoVRrf7zsQEay92W4
         /eq3Uq7Gd9UKWMsWcuYD+H34asQ9sBhxYZh857nBibMwvh8MgcnP1C32YriDjh9/RIZS
         flkIGrk2psFheQsM2/LzMhRCE45xwz38OQpNRdr4NIwXMQTsNqc2Sw/RIoXYepH1YbXP
         arpvCX5wr408RFI+O6Fj8EQXAX0cF7tr0+UO6s1+/n6q13ms1EnZMvdFq42k4pVhNQIb
         ZojQ==
X-Forwarded-Encrypted: i=1; AJvYcCWAk2SS1tAni+TLBk4H5+tJciEJw5UtSsUoN6TnY6FsjJY2xksK5HrHce4zol8aswBVShNUrwaTjA==@kvack.org
X-Gm-Message-State: AOJu0YwpEHjS425rlRZ3aa/dV2as33hsy9Sg/bxcCuOcM69il7nY4qhj
	eLg6iDSX1VbpNKyerQMzowW4EUlewN6V9KFjvOmEj6723Y1CpooeolAYkFLrKvjNTcPPHNx0cAD
	jDx4Dbl11Z1ENRFIhsgmOy6NkZHfeKoY=
X-Gm-Gg: AY/fxX4RkssqJZrJ2PMekBt4KxI30c4QAKCbkOG6YF9yGNk1Q81b7MaOtUsCeeDQzci
	TzDOx0A06XShuG0i6g4qubLxrg/ja0Ykqcr+MTTcZsGi5qGz3qIuOZaPMSqtwb1kH/r1gqM55/D
	0GvFWssRd3JGFF8Tw9L6NMRhjZ3+Njc0yNZzxTI+pc4WQriTo2Pj2Igvzabk6nyKH/chcRRgAri
	j+YmXDbVw0mUwfgeGQf8uAlnxn34EevIGdXOL4ukhVy65868AHO1D2qyJITBaoNyQydKkfOVAru
	VDS8676D3AI1N7xx/QNqWeccn1gF
X-Received: by 2002:a05:6402:2804:b0:650:891f:1c06 with SMTP id
 4fb4d7f45d1cf-653ec115969mr4596435a12.12.1768469124088; Thu, 15 Jan 2026
 01:25:24 -0800 (PST)
MIME-Version: 1.0
References: <20260115001405.3513440-1-robin.kuo@mediatek.com>
In-Reply-To: <20260115001405.3513440-1-robin.kuo@mediatek.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 15 Jan 2026 17:24:45 +0800
X-Gm-Features: AZwV_QidmYXnF7h9yz4oq7n444gRgXoBRtnbiVEv5D6iVPSwvP_31krseRm0_Mw
Message-ID: <CAMgjq7Db38sNdsGe121oBFshiJz+vUrKWf5BjB3djAYUr40LLA@mail.gmail.com>
Subject: Re: [PATCH 1/1] Restore swap_space attr aviod krn panic
To: robin.kuo@mediatek.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Matthias Brugger <matthias.bgg@gmail.com>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, wsd_upstream@mediatek.com, 
	casper.li@mediatek.com, chinwen.chang@mediatek.com, Andrew.Yang@mediatek.com, 
	Qun-wei.Lin@mediatek.com, oliver.sang@intel.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-mediatek@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ocqzybg7b9iw9fcfh8ajmker3rw85ykp
X-Rspamd-Queue-Id: E8452120006
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768469125-380192
X-HE-Meta: U2FsdGVkX1/QSnVORVfEKWLaipmm5qy+jc0X4GM8npxqlj9Iw8IkoDdHmsPkdR4ZxtWHpKKwo1W4t/nmuswN/aRB7vNSilZlIWYRcJMNbDgkX/1aPgCtAbKo26LJoYlUUro0Ok52QBntulFfnu37pUUbhvUTz390y/C+5SRikm0hD0wVntbih+4TfQ3VF/PK1nbBs7WqAsVfTivBizbjSMjIICEjpaK5e/+QcMeGkTB9FWrvbSPSr5poMkyQ4b9r7IJlzt8w8E6GETIzoLdU8J6ve+yUV0ZCj4CZ3vyma+b5F+S2fuMUYKf3UonrAgIXYHnrTNC1WKq1LIXOJ9woWxHci68ZNie6+OLoG6e7HU2Zbozh8aTFBUrTZKo/0ijQOZDOXFs/8OlGL3/kpC+CLyKmp8c48T3VZbZ42Obyw1ZY7F3F+bWh3D6vhidrpNUOixyJcTe8l21y0w2bZw2ngwEOagSPxLwzY+MxXOyDufemdNDr2ehxZHQbllgHn/+2HneniaZt0vcc4kJcGdioa6L31y0HvO3yVQlj27FxKoxIMGDqXYQOKpqS4AQWwEphwipqYFWFZXViz4BaOlpue9CXVI4Iyf9Ght+P0YuE953nw9c3qBfAlYTCGuIKrqyi1lii9OJubZeyykVlvJBNMyZK2YWWbDCtXtfOLU/rHISpphM/gTMKijGeAeGrLfDDp6DkqayfbA6osWtoN4smicONJ6BaLSqB3pIc9TOM3uqBC8bgT1DsAKDVcNGiIOnTSTXMOhbfdMztayMuSGqadLnJ6eskrk3oGWGipwvYtgC+wOeWXlaiu+EXwobj0Yixl0jZdsF/w/wNJgW88gMT+DGpRnYHVPqovcKYrwTVluNpMnplO/bp09/+Hi57fpcSrwqWG491s3gXSX6ENNcsnIY+FOQwptIhiZS6gkY0m9XLpM2/X6wjTZwl6to5oLQCq2UEPNHbfjHTcbljrFi
 2h4rJSqN
 faaytDbPIeqW5kKDs5SoF6rnuBCblRqYhOOtPmXGLCDQnjvYicxrDA69JavFjrqJU5sysATcu0XADxKDXNzCwf+kVjTRXjI6BA2bWUeaNwG9q7G+X8jXedDC7/JLHLHjlmpTTj7/k/5cV1VX5CZBCCJlMoUs/Z+Vu8XtkOGfKMf6yfPatbHv19ZihZIyf7+2A1Pb1qYpri0u+YnAAPo6gLo0vPrxJDxB3jZFXyRxWLFeMsytrwDEKvXxB9AJKt0ddELfj0l39aU6+LP5eUkka1XGNXFn47QHl5eBVl8zSsKFkhxRnFVKPpK73p7NdcKtjpXyW/EdlLezadstFCkRs+ZH/D8YjlSZQvZDTBim7TISFsRJXnRzTklErBs+vL4p+vA+CK2Ey7l/5lZgWi0gVfmX+SJthbBd51nk3PI00j60kqZ6sanT/Xghd0obFfBJm0Hc0GQ4EFLrvoXtaT7yiNVWLnho5KjBD/XOQsNrshJQOS2uI5snZ799OYGotakGICuUJftdQeIeEtrHYYD3gQQvKurA6eRjcCjepZWxpYw8VjiL+y7nFUAjOh5dsgBmQw+lESmyOHGNb/84ZP3rhlnBEufjbyLnU6Wf2+Uc2DY+Q6oI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 15, 2026 at 8:14=E2=80=AFAM <robin.kuo@mediatek.com> wrote:
>
> From: "robin.kuo" <robin.kuo@mediatek.com>
>
> Restore swap_space attr avoid krn panic

Also a nitpick, you may want to add "mm, swap:" prefix to the patch summary=
.

> Commit 8b47299a411a ('mm, swap: mark swap address space ro and add
> context debug check') made the swap address space read-only.
> It may lead to kernel panic if arch_prepare_to_swap returns a failure
> under heavy memory pressure as follows,
>
> el1_abort+0x40/0x64
> el1h_64_sync_handler+0x48/0xcc
> el1h_64_sync+0x84/0x88
> errseq_set+0x4c/0xb8 (P)
> __filemap_set_wb_err+0x20/0xd0
> shrink_folio_list+0xc20/0x11cc
> evict_folios+0x1520/0x1be4
> try_to_shrink_lruvec+0x27c/0x3dc
> shrink_one+0x9c/0x228
> shrink_node+0xb3c/0xeac
> do_try_to_free_pages+0x170/0x4f0
> try_to_free_pages+0x334/0x534
> __alloc_pages_direct_reclaim+0x90/0x158
> __alloc_pages_slowpath+0x334/0x588
> __alloc_frozen_pages_noprof+0x224/0x2fc
> __folio_alloc_noprof+0x14/0x64
> vma_alloc_zeroed_movable_folio+0x34/0x44
> do_pte_missing+0xad4/0x1040
> handle_mm_fault+0x4a4/0x790
> do_page_fault+0x288/0x5f8
> do_translation_fault+0x38/0x54
> do_mem_abort+0x54/0xa8
>
> Restore swap address space as not ro to avoid the panic.

For a stable backport simply making it not RO is simpler and better.
We can do the cleanup and add debug attr as I mentioned in another
reply later.

So for this change with Cc stable:

Acked-by: Kairui Song <kasong@tencent.com>

