Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F004D1266A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 19:38:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAB3F6B002C; Tue,  2 Dec 2025 14:38:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5C006B002D; Tue,  2 Dec 2025 14:38:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D99466B002E; Tue,  2 Dec 2025 14:38:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CBB2E6B002C
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 14:38:51 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 79DA11602E4
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 19:38:51 +0000 (UTC)
X-FDA: 84175543662.12.4543E21
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8833C40003
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 19:38:49 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Dzo3J7Kl;
	spf=pass (imf12.hostedemail.com: domain of 3SEAvaQkKCNU1C935IP8C7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3SEAvaQkKCNU1C935IP8C7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764704329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cIQFzvQj0Y4HZI4kBd8TIFPc4eUfRrW65uunjiND9LM=;
	b=gZvJZ9fAmUUQMX0gUEnNrWZFu1ytkJjnyt7EYPkI1qrKPYpMyN1NB25rP2wM5URJwIeAEh
	fd5MAGhb8/+r6BGObj7RtDoGVlieGK48UW1APc6/wtBnsP0juLoqnsqcTXBfExLfrUI2mt
	ZZhCLHPN+tN6t7Ic3Br/0koWQ0i3K6w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764704329; a=rsa-sha256;
	cv=none;
	b=xa5MSQhrJaV6ZCWZszsKKr3Oc2BLvvfAREJzy5iiWvTabx3SnbR7vcowzgfeTCQtlx4/8Y
	DWQNsgumVjT+/Rtu03vr0npI8XgjXrAN6mIjWFJa+bimxobvm/ut3Xvo3p5Dnfw0IS45VJ
	X5juvGhkMwMh2N4sFLYmzfA36ATyagQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Dzo3J7Kl;
	spf=pass (imf12.hostedemail.com: domain of 3SEAvaQkKCNU1C935IP8C7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3SEAvaQkKCNU1C935IP8C7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4775d8428e8so48421445e9.0
        for <linux-mm@kvack.org>; Tue, 02 Dec 2025 11:38:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764704328; x=1765309128; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cIQFzvQj0Y4HZI4kBd8TIFPc4eUfRrW65uunjiND9LM=;
        b=Dzo3J7KlPIpSFG9zGPbSLGWtRHOTJ6JSc4nVqeW+BYk6fPUJLtxXCLaMU3VhFgEsb2
         M87/R//XrZXVqwLchl6Jb5An0mTlirLN3DyDk+bqBa32Ys+rCQElS2WeKZFHt4xtUSQ4
         n3wuM60BBBEEga4C+B3dec3uZLi0wuT3b1G4xx50NXhq0OZCE+LeIdI67Akevh1TGu8j
         eTqKwRsqebNcKnOx7UsVw7qq8gFS4QPhIDHdgPlN1LO3/hGlrfVk7s1D1fstkzDfAMUZ
         897Q/ib4hz0x8lEkiGf++WxscrUkwjwUtaD+t+BH9zbT8owLbZB3/2xuWmmT4FcBqMbd
         07Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764704328; x=1765309128;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cIQFzvQj0Y4HZI4kBd8TIFPc4eUfRrW65uunjiND9LM=;
        b=ocr9iT3/0vWLRfN2VDEN0AOYJNqcpxjw4o98sHfFclw7KW0t4V1i1qLVxpoFPPhOTE
         +UUPwYrQpHVq6+fg6PHBlUgey4TdSV7n8VgvxIpfXvGQaE1soyQjOBUj/ekg1kSOc0Bv
         dw4lAJ3QCXWXIWsorIcpwHppydrlJZk8bqAovtYPpQflzWy+l0ezgmEtn9TIhQZJ34PG
         wpr1NGWhHalXrVt/8BN4f4bMh/dbetmhdaeImjcghaiA/jESQjiLWmvVEoyFm89Q4BUZ
         u1C3nQTljgsBLC85WjvIevqg2RTfZjcmDCdjpSAxZAIv9sBtGPFxhdOrW6QqJOkfHuTT
         qO1w==
X-Forwarded-Encrypted: i=1; AJvYcCW3VzrzJnAyXXUzQrSM2iwXXZ2uTwk+hZfZN2Vc6UDDX29ASF7cJmfyeJwpwf4mmJTcdl96P1CqRA==@kvack.org
X-Gm-Message-State: AOJu0YxsbfEuY3eHRNAwTAD+L7j51MTi3yMa3LR/Z5RPaEarFPAc2Dz3
	rXBKbyU9+eCkbRP2gsOvf2tmnjV0xONMresK5+LJOZztDLRAtGjxpAMMrasDX+u4sKqv7SAfxdd
	96nxCj8ITjybOYmkrqQ==
X-Google-Smtp-Source: AGHT+IF2Puntj/eKEoW+BjOOwfdx6Hi6RJWJ9337ShucXrIPEpJfEWDgyCzbKBbEoyZebOZYr1FMhJ/i5/uBM3s=
X-Received: from wmon10.prod.google.com ([2002:a05:600c:464a:b0:477:9c96:9fb9])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:354b:b0:46f:b327:ecfb with SMTP id 5b1f17b1804b1-477c0184c45mr416068545e9.9.1764704328135;
 Tue, 02 Dec 2025 11:38:48 -0800 (PST)
Date: Tue, 02 Dec 2025 19:38:10 +0000
In-Reply-To: <20251202-define-rust-helper-v1-0-a2e13cbc17a6@google.com>
Mime-Version: 1.0
References: <20251202-define-rust-helper-v1-0-a2e13cbc17a6@google.com>
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=1496; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=9J2MLVDNZYm9xM/OMq0zK+0XZtRU22LQEL0JJo068rA=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBpL0AL1P6xk5iJWRPBNmQbM7bSHOMHh7jJWICIF
 waE9zMDeLOJAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCaS9ACwAKCRAEWL7uWMY5
 RvTBD/9Q0mEQj5UCViRNOBAsiVewKwP3L79mXstnuVw4wTobK1OvaptZoaklpIQV8TEkTkdlVpu
 7Dp7i7P9Ad+6Sa/lsYJkMEYL/V4cIEyU0F1MRY7NNiTc79GmqdkY1AIosR5YL12mz8xqnan4Rf7
 n+5vYnTJiGSTjiW2wy4Kg1REQ3dx2NX87tjzAJAFAhlVE5K0SI9/VTwDp448XfP52mG94nwgbKq
 NH+TrWW1YdlXDKM7dmp1f+RGIe4n/EZA15DnUpXMBkGWUO9c7UbVbh0FThV2icXU9/3b7zdGrkC
 mIk/g8R5nkJKOmbSn+t14+7rPkFCLGRUpsh3WvfU38RZMvSGkr+HmYFxUQxHzIXgIm7DIzWacvR
 /BRNtoMZy7saJBMOxJOFx7IMvbOgQ27hqU7vfw19IXkLq0dDKdmXzVJe1/GTMYr0Zs9UjHeTwI3
 7ZNKFb31ffcqo3bsi4iC2mutbbNRNSG01bUytOhya+WcDDQE7melml70NqqTD6rAdh8mLEK6ija
 ZmS0lJmqCBSCFvEgwir1HqVMbVRbgS/US8LqsN3JRecoESfA1FUXdMEs5AfxFXgUNd64FUOkXjm
 GD382J03EVUFoS5KLRUzn8kVAy1OW13x3aHiKielhfKXDl/ERrhEXzIE0NJ+plYZR9/S8X2uYoF G7LUOgiGtxQPRlw==
X-Mailer: b4 0.14.2
Message-ID: <20251202-define-rust-helper-v1-46-a2e13cbc17a6@google.com>
Subject: [PATCH 46/46] rust: xarray: add __rust_helper to helpers
From: Alice Ryhl <aliceryhl@google.com>
To: rust-for-linux@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alice Ryhl <aliceryhl@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Tamir Duberstein <tamird@gmail.com>, Andreas Hindborg <a.hindborg@kernel.org>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8833C40003
X-Stat-Signature: qaoook6xkhit9tb5fud4bz6m66bqm346
X-Rspam-User: 
X-HE-Tag: 1764704329-184726
X-HE-Meta: U2FsdGVkX1/VsrEv8GI3nSx+HmfqyO+iPvUSHVuMXM4180hGpDgaPdBiE3HrA+PeKs7agrpCnF3GyCqjZs8MYWmOGLudkyKSSsHhMK+vulQJbeqLM/BL9vttrcOm9a5e3c2EhgKk6Xlcd/YU8mNEhhtDE72ULWxNGV+lmadHw6VzrQWjYEmeYaG8mp/WilH8VYRrMoZIvFPpfYVHl99EDK7V+NdB26yQrc4phsqk9SPapDt7l19Q9I3VhqDGuCr7cx3Bz551KcES36Sn6Hi1CYqyuGteLanfy0Il5FRLy0cc/Fz2QYPwCyOUaP9i+ow2NTDTc2HDl96g41Ip/JKYx+sIzgSmR2oFlzo5f7wHY+s0xX4262RERtU1pNtv9pu/TmvqNUoHHRLhwd6fvhGpRrD1n6fLIgUbTrRrKfgruoYE+spdNRGB2t14j1n31y0H49Ay0FGGyHRwZfkyLEaLj9RIG7SEAJAiLewHKYI/gH50m3PHULMUR23PFc3fVtIX0UPOuDDXxBBPxtGXGsyOGswTvaz6bzMfY93IwcKA0f+KoE9ggDnTbGwow8HGnSfvofU/R1ProTZw3cAnPO3O7c2H1AlYfugh5PEcDJoKxSyan5vxAeofma1jPjqzGCpLQQS9m3KtQbt3I4t6FvFfLdesBJQgUy2bxGSVhqwsMIrHvUY8tfMiFJE24niZb6mCmNnis3qkD/+DL/nm1uRfcDLFxP4Zmcs0vt8sMHOmbixiqTznbHua8Z1l3pyriDfMToqa0VpSipF0ykNG25fbmti7+K10Ag2O33RKQRSv47znvR8a1pEqpj31Niiw20Zj0K9xSOvZFyHGlp9urNIToq7A3xwj9V1wHhoHzal+3goXkBi9aK4iSXYH317mtE9YTKviNcCBzZ5c3rtieegDTyvqNNRbaPAt/l0w3mDyONJ4hXids5CFM8n6Y/bkJIlbY57QTxVnMqGjF3GzMRy
 ahQWJNXY
 97AvijRtU4qTuN0oFVy1ctAykQVMiWeLdefJLPO+V5Ql/nplo1u0PORCJhzk2YpQoSa2w+vQPOKAtecX6WNyi8Zeh55gjBvdl08HiaSta8aigIb0V38mOtyd+xmbZtWH/ccZ1wLzICstHdIQto0YsNG5yrbHH0RiEKL2hwUFNeNn8FcJfEbyDztGfIPf/xzblqaG67j+7Yw1RXW5j5zBz/NxSsQgY26+dU7ph4z2MbF9trIzgRkF5w6b50cOKTn/N804Qf/rBeWMw7bcDfLFKBFBBUjsVnhVnoCfcXQ0L/xPS9iO/51ZnzVJ3jvxLgC7lI9FQBl1sCvk/7OJb6uSGCaFOB/vSoSXwmo73wsGUbAqmYWdiNxphu2aOtgPoISgft+chbaLgPZ9IVSkFnypLEIlkwVURAbt4UGY0XL4DwMOTnj6HXOrkDVIKax7aMf+BPrsWRMhHRH+tNif4oh1NhD6CAbTVURI/X3aPcYSNDnOndBdLFRLZJBZLX6RsPO1L8tTNXtnepxWn3hOiZqKYTGDj02DWd0e9Bp4r1lhg5saxX0Y6LF1b3eXmK8G45XNz+LtAL+dh3nkuZ+OfwnNVuR5+6BdEIj2P4a985q6UTsbVjT/GRxQZYKR8AQRGoMOy5NoaYJWtcbX9eA7oMNNsJ9pn+MEo+6vTspJqGjSCc+Kek6SwNkiq1z1ET8As7c9ps77fNq6bcDsGgqYf86Ox/arFpTJnVb7PeQFS9nOcdDyUjZAB4qROEmRVlbAFfUpxx8YaEp5rcju7d3YgT7F1MI8k6EKMfMCWQNvZx1jVa37LSvn6AjRUMQn2Q4KO878VOfivmNDiFXZr2K4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is needed to inline these helpers into Rust code.

Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Tamir Duberstein <tamird@gmail.com>
Cc: Andreas Hindborg <a.hindborg@kernel.org>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org
---
 rust/helpers/xarray.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/rust/helpers/xarray.c b/rust/helpers/xarray.c
index 60b299f11451d2c4a75e50e25dec4dac13f143f4..08979b3043410ff89d2adc0b2597825115c5100f 100644
--- a/rust/helpers/xarray.c
+++ b/rust/helpers/xarray.c
@@ -2,27 +2,27 @@
 
 #include <linux/xarray.h>
 
-int rust_helper_xa_err(void *entry)
+__rust_helper int rust_helper_xa_err(void *entry)
 {
 	return xa_err(entry);
 }
 
-void rust_helper_xa_init_flags(struct xarray *xa, gfp_t flags)
+__rust_helper void rust_helper_xa_init_flags(struct xarray *xa, gfp_t flags)
 {
 	return xa_init_flags(xa, flags);
 }
 
-int rust_helper_xa_trylock(struct xarray *xa)
+__rust_helper int rust_helper_xa_trylock(struct xarray *xa)
 {
 	return xa_trylock(xa);
 }
 
-void rust_helper_xa_lock(struct xarray *xa)
+__rust_helper void rust_helper_xa_lock(struct xarray *xa)
 {
 	return xa_lock(xa);
 }
 
-void rust_helper_xa_unlock(struct xarray *xa)
+__rust_helper void rust_helper_xa_unlock(struct xarray *xa)
 {
 	return xa_unlock(xa);
 }

-- 
2.52.0.158.g65b55ccf14-goog


