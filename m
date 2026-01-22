Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36D59D6CFA1
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 19:12:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84EA86B0315; Thu, 22 Jan 2026 14:12:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FC596B0316; Thu, 22 Jan 2026 14:12:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 708816B0317; Thu, 22 Jan 2026 14:12:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5F18B6B0315
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 14:12:09 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 145C48C443
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 19:12:09 +0000 (UTC)
X-FDA: 84360545178.09.DA411F2
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3A75E1C0009
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 19:12:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=jC6x1fVW;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769109127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s7keTxLfsvNLS0EPh8K9+DpG6jqqIVhJos6SbOQ9CV0=;
	b=NwOYBcIhFHKD7rC9pS5/59cMxh8gkkQG60olgo5ib5BLJW/ivQCNHaJsBOKps+ndhDxOPp
	mgE+zReEEW3J7InFPcqXom5kiFc7zsx8cHnNxwffKarlNQDDG9vTzfLiP/IPIgBItCgKsw
	WUKmktNLSFX7/4cX4kLKoRGNi5E+onE=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=jC6x1fVW;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769109127; a=rsa-sha256;
	cv=pass;
	b=gnXQTDhxbooGWvdZdBIxY48sK+1tQk//6qgnoZKzUQXjDNR6NGBZDzOodGG9jPdxpAIhYr
	tQ/wm2GUIzzovZvSmrAjHq42CT0Q/rTcW9g4XlGcszu9XnszUeAt/49T1OJoQqRSJoLrIu
	HNArt4wrW85Qj4zVlm6ELHYSyzPubHU=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-65807298140so2136371a12.2
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:12:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769109126; cv=none;
        d=google.com; s=arc-20240605;
        b=cuwTw4jXuHdFJJvla2HgHlNooy0PodOyotQU10lWZRNjgfDCXulYt4hPnnebabWqJr
         /s8GIL+QWDvm9rEDi62GAHSUZoC4ZUwL/CxFIwKKXGqSZzFfgLEEPySl2F3xixRLEV9T
         IFFILiBsxP+yptwA/qTouR1fkHWy2WUmw3lUiGSmJrbtMm5yyAJvIUBaXOCxNb4jn1us
         SR6y9oY3zOSMAj4+rdeJm13SHh5M+sBsleO6NLDLBQrQ5XwLUgF7qBgUwESPgQ689eZJ
         0ReslrypuOc7wX/Txdldnt88jOI8lGKrcjoaUgMc8KYxgT2Z9f6AGDc7F/vzCuYMclRc
         7ilg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=s7keTxLfsvNLS0EPh8K9+DpG6jqqIVhJos6SbOQ9CV0=;
        fh=haXNtJl07NU763+9vvoyBN7Gmzd9vUx7B6o6IlI5zKI=;
        b=IzIRNMrjfcSclBRU+u5LfIBiURUb3Ddx2nseyug0MwPN5axTqMPjvmA6J0a8o9yfXy
         oo1NqiXSreZ2aVj3ls6E65eI1mdLLKqv8tvaOi2xfPBELFLIkohIPDn6ECO+tzMrcp4e
         Q0wfLpEQuc9xKHC3IBfUXcTyXOwwi9OtpyF1rlkUkra5prA/acH7wCbALOtZxvi2XS3b
         7ZQEBVUtYymGzBhMbeOCfA/R3XFxdicTj1UpdwgyP15sUkoxToqUPPLcPhiBKBxS2IxH
         7/ZuHkZxJNrqHOkXvfbb+a1VGqJkRd+MXF2b5arB61GCeNE6spdZx1XFuR5WdIJTfaqL
         hkxA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1769109126; x=1769713926; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s7keTxLfsvNLS0EPh8K9+DpG6jqqIVhJos6SbOQ9CV0=;
        b=jC6x1fVWEYAtvVy2PZzLCdf9nA785abpDuk3nP9AiYgVyMSQRCFanbrU0qkM1Xe37q
         Y922DMOHx+h9g3PD1S4IA1wM2lQqbGstdHaGawJkE7JQ4haODQUWPf/WYvM2a08SFMS4
         bIsRHrzWxNcKqfRiPSllADxA7MMwZXu4VhkQPSpq8+9PE1FnimHxqCnahUtlRYs0dpyM
         NYR8gpeIs5950hWpdlcmPrGdfE9FrJqvIIthJyeSAAKTg9pOyFpPYpOlgb+piu+z+sAe
         cxY924+SYSCslIcFCHTykyInr8o2qMxg5qEzfP7IBPUIjVGPn1HdaFpDPAii+IrxRWac
         Du9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769109126; x=1769713926;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=s7keTxLfsvNLS0EPh8K9+DpG6jqqIVhJos6SbOQ9CV0=;
        b=ww8kTOZY0rIq5aOKuF0zD8Rvpln7h92NgF17l7DTv21Gse1nxEPKIv2vlludwOUGtR
         MRQTCbCbRLaQ9JG9/tum3LxRUrwMEKKyHfHujtdkxnfNkjutR+zgTFSfGcShfQON+s6L
         tOc/0bQMLoVfceUCUZzsRamO4sdlhJwA7fvXXGNurL6yCRjjnXSL5jWCk0hNfge5bb45
         odayosAUV6+DiGiBmAbZCKHtc+MSkPp8h+EC29J+SbZutzllmkY+yp0KUyNBzp7P2p6K
         UI7GSVjTgll5yov2C6U9T1nSKj9iMaMjOcap9Mx23sI9krtihd1tTd6cN4H+s/AAUcJq
         A1bQ==
X-Forwarded-Encrypted: i=1; AJvYcCWd9/bNOq1w7Qujx66/sjx7qSL+FOJ7kVUEeC0sSJoZc4U0OJ7vU4NQQZmIf1687o+UWpC2NYCTAw==@kvack.org
X-Gm-Message-State: AOJu0YyfTVVdRKhx2U6D7LwPKVKwgrqi362CMiMODuJ8cxUj7kA8WvNh
	yje1llrTq1QkGS2gNseqkz/sbZIwxU2/7FlvZtIr57m6X6Djy50qW+cIxHpVjOgIOUEmFU8IJJO
	Fs/D1KC0T4aGvxboenz/QvnugQX5JitUTXNTLIVYuMw==
X-Gm-Gg: AZuq6aKq6nqHnkXpiGOPn0LSQW3oB/4qE1SpbuxrEzwfSffSAln1JMJfSbnVyEvGxLy
	2H+4xZ1siX6HllBXl/kqt/+Z3KigH5g8nXHdBGd2VHTs0bVFXKhMc2t3gOIxUMkf/kWVYEOVcsO
	Vbuyv0izWMHtD8jn5kcLwI+4v+pR7jQ/zJS5NBZOne+IkU7SLCi8UgNPuXcADDekfV7b88BtPuN
	UxD2WM8Ba9OPDntHlC7ExQL4twtLQzQVjmUA1CpPpAHKXUGJ6zTQAvgRjF9BRKzbOYsHxtTlxuK
	HoGNnibNz7gxlFL6WdrEpruxRA==
X-Received: by 2002:a05:6402:3647:b0:658:2ee0:66a8 with SMTP id
 4fb4d7f45d1cf-658487a11ffmr332902a12.18.1769109125806; Thu, 22 Jan 2026
 11:12:05 -0800 (PST)
MIME-Version: 1.0
References: <20260116112217.915803-1-pratyush@kernel.org> <20260116112217.915803-3-pratyush@kernel.org>
In-Reply-To: <20260116112217.915803-3-pratyush@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 22 Jan 2026 14:11:27 -0500
X-Gm-Features: AZwV_QgAlu9tv78e6zZyKDfrOb0ic14yXrXnuRshKsxxfWgKKxJ9Gk9Gedsce3w
Message-ID: <CA+CK2bCTT5Chn+i0ZxDBsn2WwZTx0qC0q-2PbkW+4xSbQa=GOg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] kho: simplify page initialization in kho_restore_page()
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alexander Graf <graf@amazon.com>, 
	Mike Rapoport <rppt@kernel.org>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3A75E1C0009
X-Stat-Signature: wumrr7khy16id51sedr3yudhwmyqkc8z
X-Rspam-User: 
X-HE-Tag: 1769109126-627970
X-HE-Meta: U2FsdGVkX18SZ5El8HzOSxc7TXCFSa/45xk5+uatvnyHWRN0MEtNnYYkFS4aXDZcSHRFEYgAQMW+47z2RYr6g6/bUM9qMv/mOIh1zb8ZI7JqfLPiriVJunHTrlGQAMeNPRQJVhFYYHSBjby7jmeh5sUgciM55SFnKiq9WYNIePVGQXn9IM70rpzp3FEg/mOJUQOxUwAWQQ1k3RVtO53M1eZSZnP+bxP25v4ORUSne9bk7RlDDNTKFA0inixcWAx1ttgvsJ2X26C15JplZP3lztsB5PctkHgTqSqaRPCRFVElyVIgbfWwbReJ22zpJX9pRYEIqHOWtVhaVVz95cSI7ILMcxs0XLXWdQBnZQRqmD31LtWYcUdOIxgZ1k6PkX/Wud6+QhBgV5/ovPaj6IWTTXL6FKLI6kDzOOgYKVTwPRjrkXksrIICVH78/0seAquGNhMR6vQgm+Kp+4azn2Px+6lowlxt0RlmfrxOosfR9BIzwxa4ycW20Hl5kPevx2/AOVyHxZKMCb77EUXIhoAtao2W7+QdnoyC+IuTRCoXzBU581p88f5pCp3cI49Bg42tJwG1olJ6qAFOGbW9aZdQ0Sc6ju0alG+IP2p1iNIK7bBpBi0/LPLc+fzXKLUqccasCyRl55rFqsD30qZHCCE23wLkIaPlO1zrEE3nfqEUlFz1OKR8ctB3kXm3uOc7R5a4zp5nqQwNm42N3AU+FZQU5iDq6qPoB/bUbxl/3aFn89OIqKg67eKnCCmW37SDMYQPLnb4JrqVdU1cOSOFvughQAZ0kN+DRufzOLarA5tn3Oe6jshnbAyH85FRg1+Aqa6R8h0QZbe+KB3Y0v5kjfHYUhb8RrNmXHMpfZwMikDkPilKljEQs+IIzyUpjis/RdRXakWAJwOh0XEGhYp/YICV8WKucAqcuUoOFMi6bQex9K9zEKd3jTG2GeKSGojCuS5n+lfLudoSUDeK/09sFYd
 ofOEHejW
 JtNCiuD227VOLEHW0JN1tyHlfBs5ya9SwDa3kkpvjvp6WJ1nBtidobvSDTzfjSD4F8a5DwMxzhiTE5KdwA/Akuuiw2zlbLyjO2zyaPWi6iiPg7m4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 6:22=E2=80=AFAM Pratyush Yadav <pratyush@kernel.org=
> wrote:
>
> When restoring a page (from kho_restore_pages()) or folio (from
> kho_restore_folio()), KHO must initialize the struct page. The
> initialization differs slightly depending on if a folio is requested or
> a set of 0-order pages is requested.
>
> Conceptually, it is quite simple to understand. When restoring 0-order
> pages, each page gets a refcount of 1 and that's it. When restoring a
> folio, head page gets a refcount of 1 and tail pages get 0.
>
> kho_restore_page() tries to combine the two separate initialization flow
> into one piece of code. While it works fine, it is more complicated to
> read than it needs to be. Make the code simpler by splitting the two
> initalization paths into two separate functions. This improves
> readability by clearly showing how each type must be initialized.
>
> Signed-off-by: Pratyush Yadav <pratyush@kernel.org>


Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

