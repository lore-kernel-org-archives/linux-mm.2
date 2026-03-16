Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBD96F46445
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 10:30:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BB816B0184; Mon, 16 Mar 2026 06:30:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 398806B0185; Mon, 16 Mar 2026 06:30:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29F906B0186; Mon, 16 Mar 2026 06:30:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 193ED6B0184
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:30:39 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A8A301391D0
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:30:38 +0000 (UTC)
X-FDA: 84551557356.15.043E867
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf20.hostedemail.com (Postfix) with ESMTP id D926A1C000F
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:30:36 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pXnm6iYp;
	spf=pass (imf20.hostedemail.com: domain of 3y9u3aQkKCLYWheYanudhckkcha.Ykihejqt-iigrWYg.knc@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3y9u3aQkKCLYWheYanudhckkcha.Ykihejqt-iigrWYg.knc@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773657037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GnI3L0XQnlP9mY2nbxG4p27V2eYyKmct78Co1ZDhRco=;
	b=iznfsrlezeJbhG90NAAV6zC2CfWyQBGJaOn7kQEHy7vrfaduRvhFF7sjevLoojvD+ulK0i
	k2P6QwwuGISXnN+TmJoSllCwk1XRveXxnsvhbbzihYQqRZx6pZdPT0m1lIzMQ6Wco85Eqo
	QcbqicO52qN+KB6QgiTCkQSivJkNDFY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pXnm6iYp;
	spf=pass (imf20.hostedemail.com: domain of 3y9u3aQkKCLYWheYanudhckkcha.Ykihejqt-iigrWYg.knc@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3y9u3aQkKCLYWheYanudhckkcha.Ykihejqt-iigrWYg.knc@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773657037; a=rsa-sha256;
	cv=none;
	b=Kx993JczXxurq/gXQw+QhMZna1uulnDbB/A7uJuxOeM1jqb2tkT7mQe945RcV8fft6BGxC
	e2vBieTQMihzHkwcAU4C3xkBsqGS51MGVkg1fOPsUtxS94DH8nnKXQ5zhdWSFlc+vtk+mL
	n5WEl5sTuLx9ZRngWmqnz7rs6AkX3tI=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48378df3469so33787485e9.1
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 03:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773657035; x=1774261835; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GnI3L0XQnlP9mY2nbxG4p27V2eYyKmct78Co1ZDhRco=;
        b=pXnm6iYpfo+5coSPa+8I9s0RoEqNkReEhWK69f15e09Rsx+3DMU+ka/zEsY6hwU9L7
         YFMI6hgvRHxoSz2uBoyVAW5Z9iC3azGVyJNv3zDw2taKLQu82R0WJkuNEdjDY7BEDudT
         wBcCgx63ZosDAAYWpUNVP9vIBv+ew0lEUDe3cT0psMU8rgivrXnXooW8wptwGFlUTsqS
         7ACoydXwcd+duKFx1ymoL2e/tfeD6FoL8IFltgT7pWDimIjFiRklr4gohLbk5EFLfRSK
         z7QnlTvzt8vCh1VJqVEabB/ibNN3J74p/+ttCd2nI1TQyxEZqX6M5RtWrg9+oMEEDY0Y
         OKXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773657035; x=1774261835;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GnI3L0XQnlP9mY2nbxG4p27V2eYyKmct78Co1ZDhRco=;
        b=j9JiEMjqZxOHLqNs4SvH69aPiNEiqPDdMe6Z/nm18uMeUemjKZxLMGkFbW38/7C/ZK
         EBA7PPmvz9DWuVO67AcfgQbju/rQzEXJVFUzID6egQOYl23/hGzZ8+Zq4ZGUxM8l8wnk
         Psr8gE60P1JSzc9Iz369pxGVz4QXCP3YeA4GaVQSxM9cB9OiVcEIdsKatb4muNid0jTr
         pdVR2BjcPDKIFSxjWCW36EUKb5QokHUovZZDC1MfHd2iHuDH3geS0b4lPNyFdXhxryDQ
         kq3rpOFq6A9e8zrke4ITjWF+/Qia0MLiiHkTCh7FdmxmNkOUf+AMIT6hkvEeVfBnlAoL
         FB3w==
X-Forwarded-Encrypted: i=1; AJvYcCXBGGaUuZY+GraaDAiVxzguX8M2vvqNmNZTMLtHQP7684eNtHXbDwAjxJ6RljCO/iE+X1JbQ3GQPA==@kvack.org
X-Gm-Message-State: AOJu0YzbuLebtBRyT+t94HOQQG3yd5MEOGBv6Q/pipVTVmpCLq4ojEho
	Es9XCdp+DejVT+l4bwZAJ1J3WPkOZjHxKALWJlSgpM8XLgJ6zeKB/gavtXbPEHpVDHpHbAx8cZ1
	IqJZrGlBIdSgOo6SuzA==
X-Received: from wmbjt1.prod.google.com ([2002:a05:600c:5681:b0:485:2d79:6c7f])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3e05:b0:485:3428:774c with SMTP id 5b1f17b1804b1-48555ab09e1mr180890215e9.4.1773657035188;
 Mon, 16 Mar 2026 03:30:35 -0700 (PDT)
Date: Mon, 16 Mar 2026 10:30:34 +0000
In-Reply-To: <20260216-rnull-v6-19-rc5-send-v1-11-de9a7af4b469@kernel.org>
Mime-Version: 1.0
References: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org> <20260216-rnull-v6-19-rc5-send-v1-11-de9a7af4b469@kernel.org>
Message-ID: <abfbyuTWIXDz8iax@google.com>
Subject: Re: [PATCH 11/79] block: rust: mq: use GFP_KERNEL from prelude
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
X-Rspamd-Queue-Id: D926A1C000F
X-Stat-Signature: xjycjidcfnb9gqqnpgznwjd9wajjrwyf
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773657036-957222
X-HE-Meta: U2FsdGVkX1+/54vDEgBWFExGHC+YMjpYAL+9kpETB0qaYgZ+9omcv4+vom0zR2MleJmfimqts6tExcSO3c4l822cwidPbJw8AmYfPBmRT8K1ktoXzVaevmcjI3Q/4HAhNHrRLXqKcNRRzXEPi1dT+rXklvxEFNTQLsJLjuQ3zvxREXDR0blCiQFA9zOmMqBgCstfXPSX/MLetBaqlz0w5ywBPV+nFHJaF5vPDkHgeufVT/d0M//wahpO6HqrlSBFrcbQw8yDXEQ2KDPJKucTAkv733Fmow8ae2nqYIL8qL9h+luv1jDIXgmsUrxNtrRYsm9nfmWjNJb90tJ0l9A/hOWuTcHpaQm5aWE1INn9X6foRbaHayFGwNtJQjRStGW6POUORPuM1wK2uAkaW/DsfbzhFhswsWLx3HA6aR9XWuP9vgWc515B/CjLtlm7M4HCK3R+/zEQzbjovV6cVKzWLjplssKX5BaK3+blSyu8BWRu8rkbKVzG29r3sjnfMQm11BWooAzKnxZ6nSP/by95cI8wtor5ylHZ1H60eLRN+DlF067Q7qJ6Jl9WSD4VbJQJYrFFyH9XCXg/3L9OQcCDL4QgP6IgWNmko6Z8OqBXAdVKr6rcboXZfTb0LOnni3+zzQJSRx+aYZYzqkx7i3CNascZJuF3NW/hPpPrrnEQgu2V9k9Pj+n5WDs1JHcrCdalxeNLo5/fL0on36p6Q/UtdF/yszEUvk99GqJyRDEJPaswCK6ZfX0ntm+PgSaM+ICN3NvqwlYWyzOrxDxyGUCwpWAoTlG4sxz8aFwJuoCmkZn1cDIZawocSCd3z561WZxuGNXUsnpspdU9yOyz8YnsN+c+QUcb1aL8QPPv/CutDriO1ViqfE4u1t8OGn4xz+uod7m0DJw20JshZ7Mv31pEhjYOVm3+8hWxe3+W1aFc4uvefS37X3fr0f+NatVzCRaUx9XlLb8vfOgu0l8I7ka
 Y5HHQofl
 ZZ9aZj8sPnHFYb4fzRoT7X2iBe3ukHTUphjJhEaq10wgtG6yEdmZZjQWQztIvv03QXymMxULjhbUTD32WXizFXmGlqSXtxCm8+uJlp4pWi8y6PM+lNNOLT+n4C3QnEOydVF2K6BbDHkIMFPnidiQ7xVm5dTfyY1p5Y3AKa+kso/B9H73Tjy1bVJQuROhZD0PWRTmUN+wM8UqddkZ5zhVp4q+V+xsWtff2z4CCfkVHnA5OMRsl00hF9uY//Ga3ODf+mG7ij07zmOxHFk0mxM/RQbukgTTFdXvy7x5StU7CuNulhjgbrdDmLOgcw5d9nGAd1AUREFzH3b8Cl6hJm5hhjOjBBnPjQx8oULOwE7TDOJM413xV6Jva2+qgJ3ZOtWj+0fiLrTSGsLnxoSirom6HSmlVhkqgDWrCBPDA+tVbhtfX3h92aM4IRAY4snPQ0JuAiZ1V+j71gZcNcNdU6QoJ7S7S6T1mT4P4c/mUt1ClDx9z/ZvIe1y6SaAOlyl5efp0AKXj9xtuaXFguRWsUAPPomNTxz9Vmnrw07kbA3Oh8/m1CrdnM9j5/rzFEQ7G2oAFdYTwQ2AZwJMXFBcsVQRegwg6bC8mdk5K1eTLraLvvhRaAHy45pK9CUsr9UJQLIcvoUq9DnSi1RoEmc940LbFZH1VOfSFSt1bGZsN+csA3TNzK+qO/GklbsIxNuQvYiBC+L3OWFwbBEMfLKQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 12:34:58AM +0100, Andreas Hindborg wrote:
> Remove the explicit import of kernel::alloc::flags and use GFP_KERNEL
> directly from the prelude in the module documentation example.
> 
> This simplifies the import list and follows the pattern of using
> commonly used constants from the prelude.
> 
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>

