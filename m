Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE326D116FE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 20:28:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB52B6B0011; Tue,  2 Dec 2025 15:28:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8C406B0012; Tue,  2 Dec 2025 15:28:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA2636B0024; Tue,  2 Dec 2025 15:28:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BA2316B0011
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 15:28:14 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 571DDC026B
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 20:28:14 +0000 (UTC)
X-FDA: 84175668108.05.7917666
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5CCFC180013
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 20:28:12 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=y2tc3ClS;
	spf=pass (imf06.hostedemail.com: domain of 32ksvaQkKCH8dolfhu1kojrrjoh.frpolqx0-ppnydfn.ruj@flex--aliceryhl.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=32ksvaQkKCH8dolfhu1kojrrjoh.frpolqx0-ppnydfn.ruj@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764707292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0yaLbdbXJAqPOG8MVf6C4XR3DKZYvDAAnU5HF8zvPbo=;
	b=SpBrC1d6eWyE4GrQVqIgEXUEN8BnChn0JD9s1C1x7JkOrYLZbm/7zfNzB//6Xjy7Bqmids
	gR8UagnUm/0tUV6kQlTMRrDFF6p0zG84i2mFOa8uOPacLkOSpBFgLunaufv1VQf83pH7Zb
	C2HI7VzJbCH4csXwyQk6fJeLZKYsCQ4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764707292; a=rsa-sha256;
	cv=none;
	b=QtN6c4X2gBbeOLqsL2GBJJYJJqUy5jBh/MObgeQ10E9TzlpNFGImNHiPYotet9B2HewDAu
	wfu5tG/ozUS0TlbxUg2C4s59zJAIdxnxpEBDXCzpXDrnD94wI0rNATfJ48APrwKkFUxhLe
	us8oYbIj0uoA0a9AEgW07xNguXtkviI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=y2tc3ClS;
	spf=pass (imf06.hostedemail.com: domain of 32ksvaQkKCH8dolfhu1kojrrjoh.frpolqx0-ppnydfn.ruj@flex--aliceryhl.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=32ksvaQkKCH8dolfhu1kojrrjoh.frpolqx0-ppnydfn.ruj@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b735eea0bddso470703566b.2
        for <linux-mm@kvack.org>; Tue, 02 Dec 2025 12:28:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764707291; x=1765312091; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0yaLbdbXJAqPOG8MVf6C4XR3DKZYvDAAnU5HF8zvPbo=;
        b=y2tc3ClSENGEXH8B+3rkA2aX+IJiWhUhWE8II463VCBsLTpODeG+p2/RU8ILShcofq
         gzIBpJm4qisIsdJD63CbwP2cFuyXwhFICc+zJYOSoM+gJWTrFTLbwGA/JLPkElPiJqoY
         NCFCloulilWqi7d7sOelFgjNh6AXI/meg78Lj7gs5WVsQeFLJZXm4r6uZMBw3tuIOM8z
         dqLrQoNYpP52fJBcDFRuwwhzJRTRUq+1lg8C8R9aK/hxe3HHbKPrPCBSe0UvFF7K33//
         zEfq9Y6icB9aZC8w/JItMXUm8L6EpACeepcZmpw7Zw3q1IuTqeRHExdFxkisZznmE0ze
         TPtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764707291; x=1765312091;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0yaLbdbXJAqPOG8MVf6C4XR3DKZYvDAAnU5HF8zvPbo=;
        b=LWMb/gBC4cP42n9QJXCJP40GJokRcYiE+Rvp0cdUj0CY8rInQNRbN3c1Atm7PyLu6d
         t15v4zdnNtD7mgJOuDV2n/XtVJfHEd2wX1gxCxoLMt/h7Vzf0H5SCpIOPGz9JIl4GIzG
         wqsSXAeg47zy/M9EmZaQ1EJbHFxWJ6xixLiZLu/2XuLinqfne9NTZLMaRLwQJ/y+eK+h
         2J6+vzfmkEM4u10PG6mjiVuywToNhtPfPwrmMUL6AfOjKOndOs/6pNMm5HrrIjpAeBpr
         AfJc5ISFknNVHtQrD2BEt2y9byeOLO9hO9juTn2d2W4P/+o9ITyvP3vddLgO2molyrWI
         QyNg==
X-Forwarded-Encrypted: i=1; AJvYcCVp7HlPAp50feinvGGytAtSknl1UwdmNMB3Ea6hY44ZPAaST73HveWY+Jg4YY5Jfo+k01FzXj7Jig==@kvack.org
X-Gm-Message-State: AOJu0YxIl8IhN6c4QWcT9WlEPkL4Hqp35mwPr/pQGhCDQDY8yoOOBcph
	lRoNjW+Ai/YE3aJbY2hmklgtDO79zdYNjFAW10MBm5/aqDdHoFqAuq3JTLbFNgB3RQ7GKBrV2qr
	YlyUzAmGCEXHaqIlGHQ==
X-Google-Smtp-Source: AGHT+IFxbJTUi3LG/UxAzVg0DHJfs/QK8ZkbgJFUFzeew/1o2JPNxmwoD7ry+SYsd199ZxrJFbneEJ7rLxcSHeI=
X-Received: from ejckp26.prod.google.com ([2002:a17:907:999a:b0:b72:6a6d:5018])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:9289:b0:b73:76c5:8f7c with SMTP id a640c23a62f3a-b767184bc4cmr5031432266b.43.1764707290453;
 Tue, 02 Dec 2025 12:28:10 -0800 (PST)
Date: Tue, 02 Dec 2025 20:27:56 +0000
In-Reply-To: <20251202-inline-helpers-v1-0-879dae33a66a@google.com>
Mime-Version: 1.0
References: <20251202-inline-helpers-v1-0-879dae33a66a@google.com>
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=993; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=o237WR5t4MMOHA/6xwLqKKnBZN3/rDT9uVvqOcTiQhs=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBpL0vXS2KTuDwIHjFPV9SPMyVgAzUi/MU12KYc+
 WMaROi5+LCJAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCaS9L1wAKCRAEWL7uWMY5
 RjdSD/41DCALGMN7nyQxyeW2hZ9gETkyG8/iqH2wlmXrShi1r1+WB5woa9Xyur1kDN4fny2B3pO
 Y/5ZTPeLOcZ/aZiVYBNJA/D9HwDtronU7j5mUuxB0yWDU86evl6AxsKiEvJuzy96b8AtZ0ARx94
 IgGN41NqoWqbtVWQg6QlCkP56YIrgkpzGAS8atcgpDUrXNb+PE5wxdosva9Kh9do0WUVeLVeSKd
 BdEA9iG36VbrEo4YdJv4GRojxiLeD9CDzvYaGx6ijS8AsM1Osv5V66FEhywlu5eg8vNaBbPlcj2
 xI8IBYCVYdeDDvb1eKyZRLyLRwSvHfbhkMIgkLYycP51rfgkb9kJ8xzMWQGx4zynmLXzAXH0J0m
 5EB4i8kqfcM55bSpXOcCJzmldnW5zNj6/a6PmCC3hINHPjiHjIKkZmyQFZ+xyfRWH5U5ZZnvqIq
 RTDSAE/Vjex1zfELbKMrNyp4+efGryIeLo2hKskD8xXiqzcEDhKiNZY7C3d1jHSgp0uyZLRoe7e
 N/0L4pucmpbvlsisOuuXdvhokGnGK0s/K4V9WjZ94AoP9QZDTbOpFHNW6iUVflzEdZFfDfqHEs/
 ToADXA5Wr2TwTuT9flTY9YEdDg46zEMD7PVRz2llCMVxG6AYZdE+1gKeJLV9PHtLVfRe6h8qxrt EQLssKb+G2MtrPw==
X-Mailer: b4 0.14.2
Message-ID: <20251202-inline-helpers-v1-1-879dae33a66a@google.com>
Subject: [PATCH 1/4] vmalloc: export vrealloc_node_align_noprof
From: Alice Ryhl <aliceryhl@google.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?q?Bj=C3=B6rn_Roy_Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>, Will Deacon <will@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Mark Rutland <mark.rutland@arm.com>, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
	Nicolas Schier <nicolas.schier@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	linux-kbuild@vger.kernel.org, linux-mm@kvack.org, 
	nouveau@lists.freedesktop.org, Alice Ryhl <aliceryhl@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 5CCFC180013
X-Stat-Signature: fri3nz6teiwto88qrgk7ej71ygfnpaig
X-HE-Tag: 1764707292-323302
X-HE-Meta: U2FsdGVkX1/3DIySmVPkB6JIyDpr7s5LEZsSIP9DOnr9sWU+AoYC4laUnIRQ1zl0T3wKpHNbKytSQkUbQyBU49ciHXlvFf67zzg7wqvz/yPVMZSsXDmn9UtzdLIV1wkkGXKf1Kn5kbdBtfeqJt9oyfOU94LPpqxX0gjYElarHokqoWF8IXQ2CdhE77C5J6kZjfFgUItRm6ByxH44Y67MePJbWd90ydSa/i6bMPAUxtSqiqTXGPgBLOgvobeSu0FgvIae2oOBwURzwIXbzgiYJaKpc5pN8jVG3uJHPTFxFUtDQQjotBOIKGtQn5REy2OAlwbOFyoHoIrr94Q5oVvH4PKQHhl8okNDI77iwBLSEiUnEyuxYgThGk+XckHmrWBrZg9b0s/VEJeWV/kmzjX4zmtOQr+ki68z/oXzlQ8VehspI/F+dE7e2c9RS+6b7JKJFLxDa/XbXe+WnjSCHu19Tbj9wFk8Q3SYu/HByfWVj0fPjJL/8QoW8nHGz0uvM/MGyLD5vc7cjWNNhLr7Y0pcJk6WN81dj9mES2kn3bbKBYawwCS+42Pc0OY2fhxm2Wi2HUHSOIBJMqSJUB5wepaEVBhTvYshCes7EOaII9mpP4eKCUtIakzj4q+jHBUc3monEKIhZGtnlRw/pjfXYlIs6tvB4WChjUqDLRhi5/JETWMNl3TZ/DL0drJWpcR7dCay8YZJDcA70Cq1KYKlTS5d44FbYMZyaORfv0g3Z6aikq5r8YRV7wZuUNL/4pr965Cj1Ll1jsbMm3mj8w7+mQ4dya1xwqskNzmHmNFp17Qx/MsNsBvSzi1Oeu+pm6+ldj3gCUn0H6kkJu/knjxAhG/AQ6oHrR13IkLRfw+9h8a1pqKJC+ISv/Xy6nrc3XSMD5ZLDfQdJUhKemgTCSm1zvkavtlPD9ly59QY1VEYc/alyrqkqUISnv6v1nTjVLCf2kpJvn7KOHoKqDdn0C7EyxB
 jYVGYT4i
 r/7pPgjh68gBAfIcPcADi2w8XRsFdg22AvusLae9QNbMK48lqac0/Z0HmTIvRv1NT7m7YQhTbDCRGA6yOue8iYxFgAP8VgU0Peor3HH3Z94iO7qLvVG3h8hmOZ4r+XI7EwpGLx6K5mgXAKyk2k9fyh7YB+rcDQnat97C/AiJ5b5Trran2xSpV2DKRQ+PHWIEOrfOK8Uh00elw7Gbwu2yghsIP1KJabH+fVnkLinhxnaAp31FZlwkvEcb42szw6Mck4atBP4Fcp+9k8Wnw4ewaAENll+K4veBfuLMZMMH19sYHzEcYxofO5LYjomox0RqV3WwrttL+pfFqMHfsgeAhdkhHLgJ7KySa1JUW6/Iypg6b3eP3M9SLv1fWagErpyjjbYMiAo9t2GVA0m8L9WVkNndHdFn+LPtMp9opXWUOrBunq+2ux1IZFk7DDKPk5x9cAqi0sOY/pYd4G6E5JY9xBp9C6iUGaJA0lggNevns32JsZ8+7myw4fRLvX7RWelHHvvqwvofTGduI9hZzXm52AoO84nrEsoyA0ldASXk43OULb2e3llMP59e4CIVy5x+DXeodZy6xdhFdFtmzgJr/QlJxsVnV1O+dGfFKxibHd3INYNqzV/MhzEopkac2eq8nBkjMxih+bD1YGuWDhVCiTvXj6Y2xvmrnCtmrUKF0yO5e0FKS1y1V0N0HnJrjLjxX4WLIF9fpO4goyOZFQqwuZLaSNf1xfZHtUrs/yz66vnhryG3VRwi7jL1cjaQwqOmxXfFCNqkOAZ/TwcMU3cKuSLPVHov5J/5iFVWjmo8RrYQ9eoCQlSEibin7P0/Yn+UGivrk7u3ks69B/DA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This symbol is used from the Nova driver, so it needs to be exported to
avoid a build failure when building Nova as a module.

ERROR: modpost: "vrealloc_node_align_noprof" [drivers/gpu/nova-core/nova_core.ko] undefined!
ERROR: modpost: "vrealloc_node_align_noprof" [samples/rust/rust_dma.ko] undefined!

This error is only triggered if inlining of helpers into Rust is
enabled.

Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
 mm/vmalloc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 798b2ed21e46059f341ed0d46c7fe56bbe357b22..e086d00f04d61ebd481cb84e3dfea51d8a2ffc57 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4200,6 +4200,7 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
 
 	return n;
 }
+EXPORT_SYMBOL(vrealloc_node_align_noprof);
 
 #if defined(CONFIG_64BIT) && defined(CONFIG_ZONE_DMA32)
 #define GFP_VMALLOC32 (GFP_DMA32 | GFP_KERNEL)

-- 
2.52.0.158.g65b55ccf14-goog


