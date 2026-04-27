Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C0E7FF886C
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 18:07:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EAEE6B00A2; Mon, 27 Apr 2026 14:07:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C3156B00A3; Mon, 27 Apr 2026 14:07:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 378E36B00A5; Mon, 27 Apr 2026 14:07:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1C0846B00A2
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:07:35 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C4F10C13B6
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:07:34 +0000 (UTC)
X-FDA: 84705118428.21.4FC75E5
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf04.hostedemail.com (Postfix) with ESMTP id C41A840002
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:07:31 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Z3h3hIMp;
	spf=pass (imf04.hostedemail.com: domain of 34aXvaQkKCEIepmgiv2lpksskpi.gsqpmry1-qqozego.svk@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=34aXvaQkKCEIepmgiv2lpksskpi.gsqpmry1-qqozego.svk@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777313251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HxkgeF4LNZGOlYkWj+Rbzgew6yzkspsu2lszfChr6II=;
	b=U+EUNFxUwHbpaMRwrH0l0glIglPt138WXXj6z7QS9RSI2oDCgYCr/LQH/irmdKpqTXXUAE
	3XbSvqH1pdjF8Mspyu8d4LgjF8zHTpvuj89d/+h+s31X/OiH4x/xPd8YU6kS002q3anmRL
	KcNrm/wM95yIkfiIBLg0JgHuyNj6n8k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777313251; a=rsa-sha256;
	cv=none;
	b=n3jhfck9F91KLBdX/m6KOdUIHxNJrtantzOBr/rEE50vKe909KKbvbWT2UR6KHQ2Wvh/gu
	SsjxXYv5PN/BOC+mspQDoD/zxEEIq+7ZfI4vnpWQBruBLzmj1Mqf7UQCtq7YQS7a8sPh4w
	fV0yb9I0Pk6yATUGDCy6gepTrUxBPuE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Z3h3hIMp;
	spf=pass (imf04.hostedemail.com: domain of 34aXvaQkKCEIepmgiv2lpksskpi.gsqpmry1-qqozego.svk@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=34aXvaQkKCEIepmgiv2lpksskpi.gsqpmry1-qqozego.svk@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-43d1fec59c9so6958389f8f.0
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777313250; x=1777918050; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HxkgeF4LNZGOlYkWj+Rbzgew6yzkspsu2lszfChr6II=;
        b=Z3h3hIMp4xQd34FHSMgWh1FvQL0HEIMnENnE96f3F35GS1O8tH8kZoCs1BgIALccqD
         wCjwR4faJLGwLFRa3xyPc714i9kodhcohVye94erBACB8Wctdr60/2ohb2/AerRrXhKW
         nAOaR8P11hIVPGc4vWHX/wBzpt9g8o+f9gzSynl2/Vr6e+F/zNszEXPDm3Hz6eLNe31v
         /fXiT0wdQbYz6F5QypatUq/cYypGmST7rrF1m1Af5A0D4An9kz4CHqZ+wZwAkgJ/Juji
         PQIlWl++xqAcl3fV/X65S3iXHW/njGDc6qgTEF95bLMGwxjw+5pTEw9o8SDYgvA8a8KW
         WXog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777313250; x=1777918050;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HxkgeF4LNZGOlYkWj+Rbzgew6yzkspsu2lszfChr6II=;
        b=XnLixY1r9tBwbd2gyq6UWUAZ0fc/EvKdb1LJ0B6ZyCXJuTzNpSnZxaAU1wpeapvUrO
         D1diZh1hn1pSq4WdoJYDoPcfv6s4tqK33gAk0ZcXmL1WzjSKIxuY19lN/xGV0GM+wx9v
         ZSZewEDaDW2PssDtE+TXFoOkYIvdDnrBmCz8NgGbSAtQZhJsojOBydyC8k4qjM60bVfg
         t8M9NgBoYfaM34mOSRCjqLUx+vicU6bW8gQwGnxeWaQApy3BozS6RFn1cnOUcr69rNWc
         V4b3W1s0yOvucEwaHQgHMbjYJ/2MQTrykm4Av1j513UYH30/qiCprvdsUFuzIsfZhDOk
         K5dg==
X-Forwarded-Encrypted: i=1; AFNElJ+/QvG3TcZiTDx7z/GhVGp18i1tWg7MOOZD1FFKxXKn2tvFIy/R38sZUnOCuIuvBcr/3Trek9pR6g==@kvack.org
X-Gm-Message-State: AOJu0YwXIffs2NK63dCGmhsHuZQR7n/3cntDb8cvq1BW4oZJvbvcInzr
	TiyGLHxJHWO1aqHfuUTsY9ss9aX5O8BpppY5M1hElE+DDQSekuzebDlVuwtKspOLmWryytN1GNr
	Boec/wmRkD7m6+L4PxQ==
X-Received: from wrmd3.prod.google.com ([2002:adf:e883:0:b0:43d:7940:a11b])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:41c7:b0:43d:799c:b2cb with SMTP id ffacd0b85a97d-44636a393e7mr256856f8f.24.1777313249648;
 Mon, 27 Apr 2026 11:07:29 -0700 (PDT)
Date: Mon, 27 Apr 2026 18:07:28 +0000
In-Reply-To: <289b424e243ba2c4139ea04009cf8b9c448a87ff.1777306795.git.chleroy@kernel.org>
Mime-Version: 1.0
References: <cover.1777306795.git.chleroy@kernel.org> <289b424e243ba2c4139ea04009cf8b9c448a87ff.1777306795.git.chleroy@kernel.org>
Message-ID: <ae-l4FGDPLwBuDXM@google.com>
Subject: Re: [RFC PATCH v1 5/9] uaccess: Switch to copy_{to/from}_user_partial()
 when relevant
From: Alice Ryhl <aliceryhl@google.com>
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: Yury Norov <ynorov@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, David Laight <david.laight.linux@gmail.com>, 
	Thomas Gleixner <tglx@linutronix.de>, linux-alpha@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-snps-arc@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	sparclinux@vger.kernel.org, linux-um@lists.infradead.org, 
	dmaengine@vger.kernel.org, linux-efi@vger.kernel.org, 
	linux-fsi@lists.ozlabs.org, amd-gfx@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, 
	linux-wpan@vger.kernel.org, netdev@vger.kernel.org, 
	linux-wireless@vger.kernel.org, linux-spi@vger.kernel.org, 
	linux-media@vger.kernel.org, linux-staging@lists.linux.dev, 
	linux-serial@vger.kernel.org, linux-usb@vger.kernel.org, 
	xen-devel@lists.xenproject.org, linux-fsdevel@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, bpf@vger.kernel.org, kasan-dev@googlegroups.com, 
	linux-mm@kvack.org, linux-x25@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-sound@vger.kernel.org, sound-open-firmware@alsa-project.org, 
	linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org, 
	linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org, 
	linux-sh@vger.kernel.org, linux-arch@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C41A840002
X-Stat-Signature: 1miazm9n6rtksu7p3bhwra5m6qn9prk7
X-Rspam-User: 
X-HE-Tag: 1777313251-73222
X-HE-Meta: U2FsdGVkX18863Av+DqD0rI2gWIVzMiyzS3BHhLvCa+CcyZh2UfSGNq1+I7DMQYt3ZjjqrOAPWyexcNJj77sH3z+ufZfo7g620bEgxBymo2T7HJ+hc8e+RKWBd5BXOIN2RPds66Lq7KtjR2pHnm0rZSGIEYJx9TC9V1yMQG9tvOlimWFmtMXcAd2fVpe/aVA9itnFq5L5FrPt15hHadqhbkrQzlvprII9mIuvu6Z9+4kp1ZLgbiZbdZPhMZfCDkZBodNJAixZENY3VMCIGzPtlJTa24tnFJJCr6nJpC3w3/QhjG8f2C45i37oXXIiNyiE3sHPkg4x6F5IB+ehwGIW7mjMLNBiWtvSsgRUcLT/U8tYAdAEOiK+sEt8EO6U25DyTDZcWXzGR+R+c6aH3tPTDMuEruY31NHOxwHbjUQQjvmvGpdeHcuoJ+vrzLMCcFZ8sMt24qbjpoTfBqwiBD7eKtpirVcN13veUUrn8185yYDXwumsnqCjlu74Tqpwd/iH9hidBf9TCICwhu8mCGwEIfEgWwZxCq2NIG2q+lgHDFQ62hJeyIrp9xYIeMl0kvnGnPW08Eo1nWME/c0x0t0Ik5CcUcPOkqSzrgg69dvVtWEYknxA0LGPaeLNPh8+kdJd4fhYl9v3N7ndtBa/7tIcAvAyWNX2s5qjLHRGKHQlkD+EuRY2N4vEcrQr4ul1TmE7Vyz4/GrTHA8UI9Dgvif8LCj9FK2yIaSZv7yJE8h8PXuc1NECgyQYvgNFQX9hxIWmsvjDGqN31JdBfqDW16kVjLkugbHjOshFPTDebNc6xxdT6IOOgwcGwYvOkSqgSpWjQIIZlGFOp+rj99s2T3rtFMlTOFY5XEV+HyNNo+3CJA1hXgSEXzkZ1bKii53Vja4G3z1k7wzXVzLMvPHwoDdxbKW6WSQOJlHT4YLz7HvJR58ShOVOZrdzVJwhEcF14xmUfnNBqcVIdOjF/alsvU
 2ynyrJVh
 Ew207Qyq41l9+OX744W7UHnonOfj+9KH+nofcesX0zlQoF4Rl0tJanwGFtlrwhF6DuTD7wb373/Hcpurx/LY84f65xWBja+ECoVyLz7gfNUfKpTZqsIQ8ssh3h12sHJlykaIDS6FYOWulDhYvaX/r42icYw4OGeD+1LPKKlC6CbRcWo4kJw7QQOJOuMoIeuGfUXHqXEw36hEsrX5Uze1mG56vVq3fVTSxolZi4IsO3g3Y+NTGVbQEhgfZBmDlVoGs/YElyXBLlXka5tsx575C6DTy/i4Ji13flVEXlipWnyHIfw2TxvupRiH4zOw5Sju4GjemTgSmkldIzn8Uv/jv8Veis4+dAEoQFksgtua4TQthu4nQ+fz83Efj+2YN0lAelQyQM4ZgOGOe9aGTf0l6+O18Mg6YlUSlvMkm7Bz8n+Yh/zOINIx2qS0fZ4f40zUZ/yJKA4YE6wiRQ5yn4+SrO1BoXwEGc4sHmgnL+FPjBxVlfxkWkHTt6Qn9H/pdkE8Lr65rCkyG+ysiDvnGGuopbckvJbJ3HtDZkbj+132Co1OzOYtuFAI1UNoR3YZv5vIqLReYsGuOQBWdqqULn87C/jMWAyDPxFNsnOY04Nmae+bgu3OMSwbORAI1+UKCwHrGaNh2LQw4ludU+crmR228FXxG/235VOLaLEADor4X3NGGXkruUp8aOoEC4QnwUj+YQOefura0IHdGOvnUQzA5Uj8H1eM30eePTbBl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 07:13:46PM +0200, Christophe Leroy (CS GROUP) wrote:
> diff --git a/rust/helpers/uaccess.c b/rust/helpers/uaccess.c
> index 01de4fbbcc84..710e07cd60ae 100644
> --- a/rust/helpers/uaccess.c
> +++ b/rust/helpers/uaccess.c
> @@ -5,13 +5,13 @@
>  __rust_helper unsigned long
>  rust_helper_copy_from_user(void *to, const void __user *from, unsigned long n)
>  {
> -	return copy_from_user(to, from, n);
> +	return copy_from_user_partial(to, from, n);
>  }
>  
>  __rust_helper unsigned long
>  rust_helper_copy_to_user(void __user *to, const void *from, unsigned long n)
>  {
> -	return copy_to_user(to, from, n);
> +	return copy_to_user_partial(to, from, n);
>  }

No Rust code uses the return value for anything other than comparing it
with zero, so you can keep these as copy_[from|to]_user() without
issues.

Thanks, Alice

