Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9109EF4644A
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 10:56:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03FF46B00C5; Mon, 16 Mar 2026 06:56:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 017316B00C6; Mon, 16 Mar 2026 06:56:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6F0B6B00C7; Mon, 16 Mar 2026 06:56:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D5A456B00C5
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:56:24 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 82AE71B6E74
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:56:24 +0000 (UTC)
X-FDA: 84551622288.08.8B95AF2
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf01.hostedemail.com (Postfix) with ESMTP id BA4FF4000F
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:56:22 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EI0JRDeO;
	spf=pass (imf01.hostedemail.com: domain of 31eG3aQkKCMws30uw9Gz3y66y3w.u64305CF-442Dsu2.69y@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=31eG3aQkKCMws30uw9Gz3y66y3w.u64305CF-442Dsu2.69y@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773658582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/z1SiqPCUjiS0l1gYfp55UVRcWnc3c5gpJsp5+gG+GQ=;
	b=2nX8gsfYyrjKlaA6CZa+TeNELYoCO+9yzm0PirbpSeyY4383kemySs5nEHV7M54Ut5lscJ
	uAiLW8ch3+23Ky4uxcsoz6u7JsFpXc4yIXiZhElLCtbmz11+wZyeouDCZcHVES0Nsi14WI
	4BJS5J1HAlmT4WdeD5QWxYC2X0cY4Ew=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EI0JRDeO;
	spf=pass (imf01.hostedemail.com: domain of 31eG3aQkKCMws30uw9Gz3y66y3w.u64305CF-442Dsu2.69y@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=31eG3aQkKCMws30uw9Gz3y66y3w.u64305CF-442Dsu2.69y@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773658582; a=rsa-sha256;
	cv=none;
	b=LeFlBuKisTav4COSHNcTeWdimzzE/Jv9Ccobw8D97liu/CsLTh9ERvb3tgtwvCWNm1UUK2
	rjiA8/C8/ih2RpTPuJanFw0KYpbJ6+qsY5kt9UDWaXjHJVset97vP89ApYpmYFQTdcyBVi
	PHKIBCsJBN78GB6bRiRfD/05l9L/o6Q=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-48532df52c5so64396735e9.1
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 03:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773658581; x=1774263381; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/z1SiqPCUjiS0l1gYfp55UVRcWnc3c5gpJsp5+gG+GQ=;
        b=EI0JRDeOFNFLxcdCd7UyR2o5W7SEb2ES3wzkeSRyg8n6Svry16vlixHHMJZ9jxlvws
         C4fkz4//dNtSPlKUqcFp0Ep3l7IqQAMOJg///MNarfUjqCbj6sSjzU+NvQ3vG4uj+br5
         7zOLRiJ0FPn1ozNTMEXTOcuRDBMSKFzhacKEhqiSNAgrYI66JiUoTcgO3JTdD+Pm44J7
         4MTQf6mKIaD+ByuS9gC3g8lgjcM7CsaysAW/zi+41q3+1i8QjzCuCX1owIFgsyQ/HdBG
         jDEjS+wYY4u1WSfjOAPF0U5pVYQOsXKh0JIsP7fVLIIQpfLYcGlTLTi+GDRP4KdasDc6
         vCgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773658581; x=1774263381;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/z1SiqPCUjiS0l1gYfp55UVRcWnc3c5gpJsp5+gG+GQ=;
        b=s0sXqMMX0LcFy8NKv+Cn1ncHMfqxu+qzJJWbgbQujdt7X9UZipmaibf0LYOZe9X7xm
         OVaaBE8Wezm06Do1AW+I69B/OZdnETtWaiXilBwoYt7ZLMF0oU++znoJuUf5JTIVj+xi
         kFgOlwEZBD/UJDMMZoksSJqAOX2JvpzMRUEbO9XlnLzyKpqAwJH6H5kQ+6hqo7CKVzIq
         kb7JSpYbu1gb4ISIJsNExGVRyVV1IIO8eqauDvDGoYeNlvT1wglx5D74iaC7lZ0TwTng
         WPIffo7ek5UPoKbdsp1X6ti27nPce11BKOvXx6nVq1VLUx4FVtSk1A6uRhjVm73WAbl8
         q3ow==
X-Forwarded-Encrypted: i=1; AJvYcCVu9EHjFCAKIH92bunONPk5BNVnhaUdwZu8dVUJKG9QCHj0oGmVsmsL0YDoH6aGnaOI92v97az+ww==@kvack.org
X-Gm-Message-State: AOJu0Ywj/M7hehC3N4VOuBBhlKEkCsuTU2RoZJRZKyfWrzmTiKO8b8Ty
	/jiWMWvaXPQaQUPBbGyqKhz1yj2kTXdLrYgH6JRhX2yA550xkiV8Emw9b72HRtTrHfxCkmCBBlf
	aTBMnDVLPEjpoGL/D9g==
X-Received: from wmbgx10.prod.google.com ([2002:a05:600c:858a:b0:483:a1ee:5eca])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3515:b0:47e:e57d:404 with SMTP id 5b1f17b1804b1-485567066a8mr208531255e9.16.1773658581102;
 Mon, 16 Mar 2026 03:56:21 -0700 (PDT)
Date: Mon, 16 Mar 2026 10:56:20 +0000
In-Reply-To: <20260216-rnull-v6-19-rc5-send-v1-23-de9a7af4b469@kernel.org>
Mime-Version: 1.0
References: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org> <20260216-rnull-v6-19-rc5-send-v1-23-de9a7af4b469@kernel.org>
Message-ID: <abfh1J8_4tOFkFaH@google.com>
Subject: Re: [PATCH 23/79] block: rust: change sector type from usize to u64
From: Alice Ryhl <aliceryhl@google.com>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Boqun Feng <boqun.feng@gmail.com>, Jens Axboe <axboe@kernel.dk>, 
	Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	FUJITA Tomonori <fujita.tomonori@gmail.com>, Frederic Weisbecker <frederic@kernel.org>, 
	Lyude Paul <lyude@redhat.com>, Thomas Gleixner <tglx@kernel.org>, 
	Anna-Maria Behnsen <anna-maria@linutronix.de>, John Stultz <jstultz@google.com>, 
	Stephen Boyd <sboyd@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-block@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: BA4FF4000F
X-Rspamd-Server: rspam08
X-Stat-Signature: gdxm7nzhwxytfoux3chfhiuu43qdhozw
X-HE-Tag: 1773658582-627004
X-HE-Meta: U2FsdGVkX19Ss1W2Eu8jkTHGcYJ16ui29tdkz0vamMMuSnEjHc+c8zGLlrTA3X8q3JRfRxNFvuFecs6lVJmxFxxZGgrIJTlzklsfFz3A1pdQO89Czg5rypmwV1mFYrZi+xqJjXSiMfNf2QGRzH7jTE7S9Yk2RXdx1YuT98j2y2ge7WJbkOG+783OlQm/aEsr5VpT2LWD5dqqRdCVu+nPE6DCCThTWsXoFBuaMbU/UGuBBxF1F191b1hbgdUaRotfkQvnQmaNMlZPeQIn5PG3r/CsKYtgJBjF6SPiRvmlI7bqIopdneLHUEEn81lvsEPU/uRVuNuUMJeFytNIs/F2RQHp6khcsy/0MUDx/tjike1cdlRVjc/mRgkQUD21o1o2A4TjIZWl4ZE1ZztXxv6QmW3XRMPQ3qYXwz7CEIaFzi/JsbVeswM311yVdCCpj095omOiDhnZOF10kGkqhEi5QsDsORUa9Wa8VRuKaR6t1r9byz2GyIylzB7Kqvh9B9a6+ug3RCxXjn9TzeF6in7Sh3/QYvrMKUOD37rwB+tcWomvoXrMj+DfDzL0H5wjI7YW25gavWEMKD2Vli9naYvsQL0SYuKS1BcRiDHHMxHATL2BI+5iVUi5/7HXJqeaOInGvhfOQ6JPugDhV3YfnAOi+2ggvifQwvGDaWSO80Qyn+9VAEU1wDeTgTJmdDSokpy7wI0y7fOFNaCsjlvpQpXtVVkrdL/B7h0QEfI3J/yAK/aIcCI5MZLGNmVYEtCTLnYR3mWLC0u1WBsIFiB0JkXLxyCJ8SZA9aYOglUVzrvhZ/3sUj+dpnWNDm9BTfSB5oKmu2e6ft6MsF1XqcBoATgVykf0k0ZPPuaR8HJEeW5b+++0h6SeutwMOCDnvrQLdeXor4dCVpYyC1YffsbEQmYCfsnnBfHdONutM69crjyZKJ+K2RZZga5LwyDO1sXadyZcxf3KoZnVHt7cPM3OzCa
 szT7tM9d
 MPRmdLEff1qC64ZpoAKsVAQcAm1tM++VZJ2HQCQ36FWm/8hr74xcPkBSM+d4eCdrJ7ibhF9EMQVJHRvL94GS9rZP3NtKkWHwq2mp6Py43XmGLrCrmC02ITU4WztP3SZQoQs7olAz/yeN5Y5kHh/DLPnBlOWl+rrZpUcsTFBMvc7075ZACtadIQx6by+TBQF/6q1IrzHXvl+JQfe941KHmkeoSWTvaWcBGP19O9P7lGmm0YN5CDnAbFihVs13mL4sl+HkBFdBuEZBdg0zZWm79ihQtI1+hs+c8860+Dqer0jjZDNlTozreWnGT8hQdVCsiHxYaW0r2wvqKZuIC8Is0atqymC6YgVtXC4cVap7eyZDMVcoYeUgTU4Qe3MVszek2LiZxnTOD2N8EwTWdN5V/D23sGela5r4SMf0d1GQiJb1YNyyUEeVA11w553ar9KS6J46CzZUdgyBoAcO5T/A8gUa/Zg3qQvQ9z7MXorDkR66t4Dqh5ihdGYxbLvtaG5dvP58z/fG4pchsDHUcwmXQKFjBUH8QquFn/Mth7KChqLpo2XC/MSw3HlNkoHilQrH7eo6pUA7BGVjXzcmzeua6W5/1rPOZCbAphLvxWJYFlF3Wig+/5+f6sUKG0yK/Qt44xho9K6ooPYjpzXxjkDf0wkuQbcg443SLbumApDBiszqoLKuwNfycv69sDJvYjwexHiq3bETCVsuILhXvCjpc0BliutuXNKi60US9fnzSTIRLmjrwsHu9sXH5sR7vy5xQvg2u3cRt2C+F2y9H+JjLyIGWaFnXl1Uv6Ek+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 12:35:10AM +0100, Andreas Hindborg wrote:
> Change the `sector()` and `sectors()` methods in `Request` to return
> `u64` and `u32` respectively instead of `usize`. This matches the
> underlying kernel types.
> 
> Update rnull driver to handle the new sector types with appropriate
> casting throughout the read, write, and discard operations.
> 
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>

This has lots of unchecked casts from u64 to usize, which could overflow
on 32-bit systems. Could use some CAST: comments or similar.

Alice

