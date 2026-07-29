Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F04DC53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 04:53:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CD3C6B008A; Wed, 29 Jul 2026 00:53:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57DCA6B0093; Wed, 29 Jul 2026 00:53:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4939B6B0095; Wed, 29 Jul 2026 00:53:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 20A876B008A
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:53:01 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 970D5C0564
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 04:53:00 +0000 (UTC)
X-FDA: 85040594520.04.8AD903A
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf14.hostedemail.com (Postfix) with ESMTP id BD84B100005
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 04:52:58 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="braXz/S6";
	spf=pass (imf14.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.180 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785300778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9SetuqOaYjSWxYWgRlh93KRUkOeZ8bsMn1a0okrHjRQ=;
	b=l6rW/JVslifC2EufGh/fxntJ+kTD12L62w36XWQ1XzamEM1UMQJHsLMpmH+nCKwupjF+zT
	BgeSF3AJRqgpUJbBJAwoJkmlObIOF4xjKeT16WrPJbs2a9hK041UFGc5+4EaiLVr4PjQWj
	DecnItVHBRBxCXYahzYs5+/arDTssoI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785300778;
	b=Z0BeFXh7KT5qWbE7+ZGvDRiHqtJGn5tG7D2BfJjPkQNKxTbXOaKP/Zl/QyvhjaAErupalJ
	564i7RG+FoR+VZz7GkU61xXfvd1quoCqiKKPhXfKh6zP6xFhaEYIbEVkuJzPhTeM+Fs6WA
	VgI29vYWJ6BAu/YKB11oD7WnTzxEXa0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="braXz/S6";
	spf=pass (imf14.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.180 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2cad4170e8eso8244155ad.3
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 21:52:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1785300777; x=1785905577; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=9SetuqOaYjSWxYWgRlh93KRUkOeZ8bsMn1a0okrHjRQ=;
        b=braXz/S6Gsi/n5qJm5NF2d2303P8qyqzYK9fozoF7bZw753fiJniyoYyoZYp1wPO9Q
         xBvMDI72fn0bjIvrHMQGzvK2+1bqDTL8wiUwGf9N+UMfwgNLD64NiFA2fubNeM1HTuBc
         4jIkl7csB3NrMU4a/MQBzl/DEZgDUjzJtX2aw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785300777; x=1785905577;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=9SetuqOaYjSWxYWgRlh93KRUkOeZ8bsMn1a0okrHjRQ=;
        b=K15Gz0yR4biKni62FVEeqGiosamMQbpJLhVXkEz0uxmDJIVH3WhTEsqKxa1aTzEhuX
         ND0LtWw8GAqm3qrKi6REhNuVok3D7ri5cXgiZAV22O6CKEprvlTS1pC5o1xYgGvb6kvv
         dvkUI0GQy4PIOfqdYZm5exmcAyPVkTK+zhCQcjl/7AqBvcXElKPOqiOB6POf9asiW5fT
         +RaKhC9FI8Z834V9RFiV5IH0HMMLqdmFUhy9NoHN9JyoRmJ1C9VnYFDsq+JQuudY3fIx
         St2/I632UafgqFkOPdy5aI9QZiypgdAEMiM2L18EN8CgCEDiecDztdTLv4b7kn5JX43j
         zjIA==
X-Forwarded-Encrypted: i=1; AHgh+RoG9EPDeP5NaT11oNW7E1TtnPSmNrmOex1lCr/HIDCmuEM//K2FPcn3WXGquQG5bMorPL3N+tfI0g==@kvack.org
X-Gm-Message-State: AOJu0YwD6ntm6ORbBtqUfYIZCq7M2nLT5aGljim9WhB+QvViFDE0PWZE
	Zks/uLnz3dIglNwYg+AFYaQAY/uSTANRhTAtW2JOWhRpnkxHf5swr+0pmPHbQYfC5Q==
X-Gm-Gg: AR+sD129xSzh3tx7QepKWvZ1B+c7fUyiwb+nYWdkFgY9OEWm3MXEbJh8m3XFIKgebxh
	iRW/SkHqNGU7kbXmHF6myl5oGfeuh5bt/4PI6bVqUr3QJWJaXfrmE8J6+7b44ZcsyxzR+aQODID
	bMK4OSToets+SfVgNG4HUfnrbiPeeuS7a5XSIER2lsO3FTOlHGXAr/shLad4QiDSsljppt/Z0/R
	3CBmriwKAMFzzngW6qtMHzbv3efwsJAxQ0yVDOfrIXD+pLPOKLKrkd6yDXY4KqgPAh8CF+Cnf0r
	bVK9vW3vDN6abgTxtkY1gXmMdMScJ/PohxIf4y2ruLiQMFukc0qJKVwjsqVdgdto/e6to7ghPXj
	XvJ40ReWBU4z5TzAU2ux6r2esL9wgcDgMqMuBLPExgsf+No/CyIZd9huw4cEGGQIFJFgyaLWB1A
	10u5FQkUgpf3ZcPE1FLJx5XFiUZCGhWT+a6v0qb75rIFnKyumXDYoiUKndR7AqIHSfYaDfXNJX4
	XoaSUkYyKUzmcFMvTUxU9WlOuQ+
X-Received: by 2002:a17:903:160c:b0:2ca:bba:b35c with SMTP id d9443c01a7336-2d015c37989mr61892485ad.31.1785300777634;
        Tue, 28 Jul 2026 21:52:57 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:65c1:52a3:f6d3:37dc])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d022c2dfb1sm4915735ad.72.2026.07.28.21.52.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 21:52:57 -0700 (PDT)
Date: Wed, 29 Jul 2026 13:52:53 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Richard Chang <richardycc@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Martin Liu <liumartin@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/zsmalloc: fix release order of locks in
 zs_page_migrate()
Message-ID: <ammG560TO_J3USz0@google.com>
References: <20260728055333.421080-1-richardycc@google.com>
 <20260728111509.7662e385aea0b055d2066e1f@linux-foundation.org>
 <CALC_0q-RwrfxiMypoKRQWUkUzRwkt2KoXN_GbWLxXX+4xx0WPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALC_0q-RwrfxiMypoKRQWUkUzRwkt2KoXN_GbWLxXX+4xx0WPA@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BD84B100005
X-Stat-Signature: sw3erkxhoqayy7o4kcs961yozo9b1xdo
X-HE-Tag: 1785300778-185492
X-HE-Meta: U2FsdGVkX18LowXgGq5Y1PY8cZruWri3rukQVdD0EZdeQLuPcjSym7LzK6ux/I4JIDt4Z1adRRtxWH0akYmYwkq6S6uNjVQ33Jb8Z0RmAXBYwCUW1mf5+gNMzPJC8YfBkDJL1HTkWZyxKdVFliQXMEpvUjXjwcZrW7pMo4Q1JEL+0eR7X5M/xuDct32WgLL2O3Wklq11JB7FYd0ARrqwJD1eSlkTkhA00qrY8WvS1/DCFal2B2eBZsqwsq4N0bfUPG2vGqxCDwognwEtIij3cXV9EpUQML/0dVF/TR3DdVCZWQFVhrKasU+q0+tfXUgjivuQDGCM0REpVhUclgje3+XdKHaJj892nQLdx0jjSRRcj4f7xN+6BOuz7YHg1FpPI08SX3xPvW/fawrpiGv04uU39jmhhpDAd8KxfM69k2TKrLTp/KmzHLYLBD24d5t5xCF2odGC8OaZhxlFijWx4XwuNg7m+QqQpsAi4AxZFR+IifforWFvn1s1ZleuahTq0kq3TzwknxbCWhI8gWTnLHk+9H1zND/gsz6qFiTBsMnQ537S1b0sGDgw5zWYZKAArDfIqZSFQzZaCMVPYPk/RzmpQW8btmNGGN5vL6gEkmgjFg4XHCb7IsHc98QcYeGyOMZhFodvffZlioBP1dHSjIUAVhtUXXbaX3WnH5I8d6iZSc6A3yiQqW6eBwgsV9g7Xj5kRN+ULGhCY9J3v2tpu4PhFQhdpfpbZwxQN+3rAot9bSCI0/ZY2V3/6eymn7Q3TfUiBfYp20SAGnNI5LgYiZ7bwWSNa3EKUIWfOSiVLi6Ws4V2daKGi8rc840uqUTn3Ht0TfgufYP4gQjhSpb9Z19No3VTKAFHSeZEeE1LIi20pqo2e67zO6F3SSxUHiyXIUizCRoHxI9uFkSwTESutX8HsIcQ8GpAZbamUe+tWcf2P9M3hm3X7XcxCLyA9Lj4v24ILKE2Qg023tUurMn
 dDLE5FD6
 jTY+MpqiE5ybTPLY9ZWX+KPeIDebXBi9I8rPzZBqzT/ylZJrCnIxgyyuM6OYl5liwbXoYE6Ayc5FKn/VBXe9DXoy4rO2GC5w8SVINvB2GwLwNn+MR06kvYcVihMOI1thJnymb99BhIxKG8Q/LXgnJdFeqPZtn8d9+6xa3paqPxAG9yNDpexiMU+++enued2v8/UJ7rIvmEI3w2Sm7VUekEmqXojVjTd9TLI6Kdhxh0umh1eCxzr13jXd02NdGcSK5i7FP1CHqHUYqiLpG4cxE45kyRjTqGLhIrlFVUtyaCV/5uXKaZDMSlIckNhyRsNqMQnVMFZ26FNSAbGCmm6t/KrdGk0A4txMHronJjwhsP22ZLyVNCU+6Mol8t2VpZpaztR3vNRebA+MWyj4D8Svx/mhiHrs0CS7ksDHrhcFakMkoUTQtbR25a+cStCSi7xWN6jQ9pUlwnCsxPDzm9IE22lkp1niEJ8hLNdbYUxFflb1LUeiFh7YPM8HHuFlkXskVvVS185TOkpxC53KiB+QzofUYaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/07/29 12:46), Richard Chang wrote:
> On Wed, Jul 29, 2026 at 2:15 AM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > Thanks.
> >
> > Does this actually fix a lockdep splat?  If so, is a link available?
> >
> 
> No, this does not fix an active lockdep splat or a reported runtime deadlock.
> It is just a code hygiene to release locks in LIFO order.

Right, surprisingly enough lockdep was never unhappy with the original
code (I run tests with CONFIG_PROVE_LOCKING=y.)

