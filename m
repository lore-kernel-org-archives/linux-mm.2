Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 390CBF46421
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 09:27:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E31B6B016D; Mon, 16 Mar 2026 05:27:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B11D6B016E; Mon, 16 Mar 2026 05:27:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DD4A6B016F; Mon, 16 Mar 2026 05:27:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7A1286B016D
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 05:27:41 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2E6ABC02B9
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 09:27:41 +0000 (UTC)
X-FDA: 84551398722.17.38CBC3E
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5F23240006
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 09:27:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=d6l2oAtI;
	spf=pass (imf04.hostedemail.com: domain of 3Cc23aQkKCNY2DA46JQ9D8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3Cc23aQkKCNY2DA46JQ9D8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773653259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7q6QzcmG6dxnzbKj8eqJeASThBGQ4nQR5hfoFgOE7Lk=;
	b=zRhCDj/oshF+8tpkxF5KJpCR2PT9btRjUaZRkKvtst/ilm+IPN6c0nWV/UU+r/iehidRCt
	/naU0fA34jYrL1eGltMju+wzDSLED4ywtZiD0jZqpIi/PtqwWDuAN4KO5JIxKOvePle5MH
	sHMhRpmhkFaeNJ4QQsxLE7Kvuwk8ejA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=d6l2oAtI;
	spf=pass (imf04.hostedemail.com: domain of 3Cc23aQkKCNY2DA46JQ9D8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3Cc23aQkKCNY2DA46JQ9D8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773653259; a=rsa-sha256;
	cv=none;
	b=bAc9y6Z3fptWIPdNh1Rk0HRmQJCZU1LzEk76ihCrfDgeYTa2YTG9fHFMR8TbUjiVjsNxG0
	2YV6v5zpdW4cRXTfir99yUmKZgx25c9Zm6aAdLsvu8G7I2/M+/eCWt/Fo5PoWxBe5c51nK
	DxgRta+PJHe5mLqbsQeeT/l41xmiywM=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-48542d5aa9eso35788945e9.0
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 02:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773653258; x=1774258058; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7q6QzcmG6dxnzbKj8eqJeASThBGQ4nQR5hfoFgOE7Lk=;
        b=d6l2oAtIU5pvu5G+9RiDX+aPMgy3Je/uhb2Yl/DveiURo1HiD5hTgKvNq046YNuAIh
         rko3PVPtKboReq7OnH/G6gUy7ANlTA/OhQwL5YlLpl8VAyJdCkqZUoll+bM/LtZIbnYS
         LAp42Nhi/invY/C59T3wXRpzvEzgH9h3LsABxM+rN+DzvQMhZC9fqgwboU/yEjrxqvef
         KRuf9oAMMij5D/NFSVMfueL+sIMFMFSJlx1Llv64rYK+/S52gNaYHKzzl/s8NyXu6haJ
         h8+xtMqaBp9KRXTaPbUjGrg/sPG3KkaM8yxtlN0OeCGYyyaUoMGyDzr+/SwoDgUghisY
         lvDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773653258; x=1774258058;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7q6QzcmG6dxnzbKj8eqJeASThBGQ4nQR5hfoFgOE7Lk=;
        b=enK/D1uuRoBfiU2iDO6tQ0P1Gzuzg4BkhjakeYA/uBG38siS0ZJ/IYBJ1JED9/sW7R
         8xpNMlc3z3T1r+pJZZQe2OvPji/2zkWcszuR4RSanENneLwzj4YePzQez979p+zDVC12
         0SlKyI+iXszUyegpqm0aqgMjiOnN+FYoAu/7hDQP8KXkJJR1/Jbm4Czem4PKz3PhQ6M4
         GzAKfTet6yxUGPrEhEZweBOO1BHl1+SwvPAN2CxfZgUfIbkEkHY5wKtOQGMK2QOhERxq
         msIYZHsaqojmI4Ncxgd1WX2gP8irvRqxwlg48Vq/g6BLemOI0+0hZQiS+oeSfGTPMkdH
         L8GQ==
X-Forwarded-Encrypted: i=1; AJvYcCXlRdNUphx1wRum+XKky+3VDblweJBW0YprZ7mBvXM7PIT56xIW1tVSYqkaAcYGNy3SHyeK0Sz/XQ==@kvack.org
X-Gm-Message-State: AOJu0Yw+gNj/jzyQpeM9/qInwi36AsjXQbetW5sp8xSr836eoGcuk7Zc
	NQt9HzsQQsRQPOAgUZVwnGcJHPO58BruKr9rkhTVXANIuNfzcNEKxtIyhv1cXflU+jrfR0rP8H5
	avYiTmLuCBzMDBsr61Q==
X-Received: from wmbg26.prod.google.com ([2002:a05:600c:a41a:b0:485:385e:a8c1])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:c0d1:20b0:485:3abe:ab86 with SMTP id 5b1f17b1804b1-485570ce1cfmr145458085e9.4.1773653257588;
 Mon, 16 Mar 2026 02:27:37 -0700 (PDT)
Date: Mon, 16 Mar 2026 09:27:35 +0000
In-Reply-To: <20260216-rnull-v6-19-rc5-send-v1-4-de9a7af4b469@kernel.org>
Mime-Version: 1.0
References: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org> <20260216-rnull-v6-19-rc5-send-v1-4-de9a7af4b469@kernel.org>
Message-ID: <abfNByL15D4s69Al@google.com>
Subject: Re: [PATCH 04/79] block: rust: fix generation of bindings to `BLK_STS_.*`
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
X-Rspamd-Queue-Id: 5F23240006
X-Rspamd-Server: rspam08
X-Stat-Signature: bwoae5n9poc9fgxktcpqbc9sgdnem3g6
X-HE-Tag: 1773653259-137588
X-HE-Meta: U2FsdGVkX1/lwums+FvCYz1R7EAMp2S0W4zz5yoz/0wyp4UbT5MhnVtOydqOz1UvXOWsGltN/6Ego7DxNKPeV8RJjFeOFVf7050IcL+v99ULuugIinX7RSQLngoKuU3ef8jPZOwgzvMCRcWCMZDmqY8/PoDb1+pMXaAE85o82lV1jqPFUHw8lkDsA+AION23YaDHgQA4Ia7pwZRUIY8uhdljND7cGmoOpJMIyzHqRaJKIMBkl2svODjLx77eAf269xVGst/mlUQbrd+2p5FM2jlaWw44bf6sHYi43dF15v6ZTdPIY1MRDmBu35gBhkxrWBNT4VNbiglrvddI/wRaFX9CLE687cn21ZtV9lqtIGHMNuZ7OXkvaxaMt9s02YdimeVBsfloy8M2DeaaGjH44cgZhcM9AXjahROHxD6zJDBxlZ7kdEvrv8cs4xInkUKJRF+FYDu/33i3FluPnb1onTGzKB6l6gWuukAQzcS0TebYIx6W9nSOFFWGzz3YqxtC/lMaAvSsd8CO9+tTl2oz/uAIpV5IJ72BxVuvuxNjF0X+22gMP4BLsEpLovlzZGSktCTef6FfdourRDSrB0OVHXFt+rkbUJgYIiq4+OV0bP/Ft3VMHaNApt+J4Rlcjovn0GB+eCfWtNVkl0LRNC9xXW9awem66k4PAgsmdkHEwc5FO2nuyKvctzKf3vG+F9cFBia1CIkb9jAaTASQxBrcBWSUTK+aNhT2RoiwtfHpaxPRaM90VZcpn5hs1bBxTgCQob846IoF2SjiWT8pBGMVFBAei7/v4LYmHDAZdpwqUwq53Umk/AKEOn/YGlaHqeZ64YEYGIdMPLT9FiAzDFHrXrik734cKYA26ebpfJxk6rTgHl9AAuHe88eBAWMts+FZdvuOOThx7Q1pSFpP7nXBVJPVkiahCRZfyjhLZJi2N/wylHxbs+S8UMNexiCRcEKMA+MSaw+PlTDYL9pe0fx
 +5fecbFH
 eYTszuROffFXJh0E2tqUAj/UP0xVCGVObgEN2vXRHy/sbXJwv3oBhH2GEqr0qRriLy9glXF0iAFz8F/JI/eUvqJQ+6xpGZWGStlhhTI679lBtXpAwvfKDDH1A94jpUN3ElCEIrUW2z068FW64iq1H2fXIPc42f37REzalXa5a5qWLuEx6VUd5cTOXd7TpnPsfM1TFaQ2M2QvBm48XcEdbVBCFMG2LBb+ne5TZkrxo+F2Z9DyNcsgk6osR+hKp7cHMkjj/OoOnS2LNI/AR622Ezwi8rauAepZLxSNqx01MoST2cNwRiyKlf2UMR6EW9cYdoALOPkTowDxjnGdv+Ii1Hy8n9dhPdi5/luRa4Gf9VBDD4oDM1t2V/LaFbmv4zBm2ioB5U/e7YF5P+qMEpl3HfBjX6TDtT/Wu+rtkcCyBE3gDcK4Q7tdU33rkHvkPCOVQRh6g3/fNFsMxeJF917OnwhFQskabhLeHBnrHWHnurQStNjS2YmCReYH3Aifzn85sqm3I6/+WnN0mrZE/di0+W5iJj/aiwlbtF1m3dXQpQuwL3TcE6eNIluUvZH/idKr3cmkd1LjcuT9phVIzybPSaumVjzx5hICivNc/4iwdMfhDUxm8+RAfvGg71tTD1QfQ8zvQmtq69HW85sUOgu+1FqUDvXtVCf+uPwCc2+hzBDAruyWK331B3VPKv6KBDcdu5e0HLZ8UU/ELJyFH78Qwm1q6E52bk6rJx7WIn9EKvO5ocMOgL5uasVfY575PqRrPnSXTN7pVjJQooZMrFPfS1TNRPFZFKYO3qtJAbhJwzK/kNmmD5BF3qsosbYmw/nii+hZ94VlNq6z9brA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 12:34:51AM +0100, Andreas Hindborg wrote:
> Bindgen generates constants for CPP integer literals as u32. The
> `blk_status_t` type is defined as `u8` but the variants of the type are
> defined as integer literals via CPP macros. Thus the defined variants of
> the type are not of the same type as the type itself.
> 
> Prevent bindgen from emitting generated bindings for the `BLK_STS_.*`
> defines and instead define constants manually in `bindings_helper.h`
> 
> Also remove casts that are no longer necessary.
> 
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>

It'd be ideal to change the C header to use an enum, but that may not
work as I'm not sure you can specify the integer width you want for an
enum.

Reviewed-by: Alice Ryhl <aliceryhl@google.com>

