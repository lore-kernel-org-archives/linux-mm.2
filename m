Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3C6FF46449
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 10:50:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0274B6B0195; Mon, 16 Mar 2026 06:50:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F41A16B0196; Mon, 16 Mar 2026 06:50:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E537E6B0197; Mon, 16 Mar 2026 06:50:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D5F406B0195
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:50:24 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7A9031401A4
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:50:24 +0000 (UTC)
X-FDA: 84551607168.18.8B424B3
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf06.hostedemail.com (Postfix) with ESMTP id BAB4818000B
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:50:22 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Wj7bG+p/";
	spf=pass (imf06.hostedemail.com: domain of 3beC3aQkKCGIALICERYHLGOOGLE.COMLINUX-MMKVACK.ORG@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3beC3aQkKCGIALICERYHLGOOGLE.COMLINUX-MMKVACK.ORG@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773658222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CN70017b9XscXy7JbJrHaMQDBe/xTJqIeRZ6kPNoH6A=;
	b=gnG0osbtzC3XFkNwKR3tQKWsNMd7ATgTUJArXjodPTsPnCKKunkZBWg261AIC8F85kDydv
	cn/xE891tCiH0PO7WhxFw0Ldqtn0iwsOvS2AWR0/PIe9U7BMgIiZKMCzScAbB0tw+SeL1g
	ZY6ytka9Ue7HBF068nZeFTYAejrMgaw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Wj7bG+p/";
	spf=pass (imf06.hostedemail.com: domain of 3beC3aQkKCGIALICERYHLGOOGLE.COMLINUX-MMKVACK.ORG@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3beC3aQkKCGIALICERYHLGOOGLE.COMLINUX-MMKVACK.ORG@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773658222; a=rsa-sha256;
	cv=none;
	b=DI5FEdbZgmhYpLtsAWtJcmJyapqtOVjQOIxaExWGkJIJX7pGEaXdktGltvY4wP/h0B4cdU
	pXKx4sg324K3lW/1LlMyXW/BTzgdOB7l+ljkQWuNFBFG7CpTJIpTMzpzvjbWmUdeFOOpBJ
	OVuyuY3KF2x+yF6/7Nc9xeNHGMkhUGM=
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-439b8bc43aeso4014100f8f.1
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 03:50:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773658221; x=1774263021; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CN70017b9XscXy7JbJrHaMQDBe/xTJqIeRZ6kPNoH6A=;
        b=Wj7bG+p/aXwa71AC8PWJX1sPnjqm7euxqPsgbzRzVD3dqSgVVHgwdIC/yHKxMddLNk
         9JNEvGeBnJfp3fJYvwoRuLEFv9Js0FUwFNP6c7MQFNMAebx+x09gVIZsm7MhBJBX7Vl6
         zfiFwLnDE5/pZPgE4n58sUJFhtV6SFUrqwleeJBT8O05VDfLTZxfCNSA9YUb8+esnAYq
         yMThQUVX3upcDYHT5jaqeFqr+eLt3GSqiWQhBpG/aa+4jlhIlmAGI8tPpKL65vqanE7q
         dLBQhbsuiYrFYDyAbn7/V1xl9KR0OYnCzihwZs7Ycqayvblqr/ZbEBPih+HyS7RDfiLb
         fA8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773658221; x=1774263021;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CN70017b9XscXy7JbJrHaMQDBe/xTJqIeRZ6kPNoH6A=;
        b=SMR5RLKp/k+3BTFNVw0awbn+3QOi8D3cF+U1sNggMvOepzmFsdy2EwbHY+oNqvWnx7
         idsVR9QNvo/ZG/UHTxydI00CqMw/Ef2pxfpWSHFUyZBPRMpJ5owc9dv06nzeLQPKW/t6
         mdogmDfK62BdjDYcdRBNnR6HS5OQUc1Cnj+vql9A91Nza12mtm7LXixfbUWS7zcVfJgM
         GZWXUQJ57hBvcQtYnZ3JgyCuTiheg9owpXUmeeLbHn87pUJdMMLf/45sCxPCri4OGVwb
         7ewc58hRK6gkvL2UQu/39J6j1rExZhzSAAAVlsFgjA2AQQr4Dq3Jyxr9DVWS9rYKwgup
         GecQ==
X-Forwarded-Encrypted: i=1; AJvYcCWq1bitXCCPAb+2Z47oen2W5CFjaaQdYMiASV4R7Bj/K0MG3KzckKS6diMlKgmCBgbudJTat9cjpA==@kvack.org
X-Gm-Message-State: AOJu0Yyvv6mSm+dMWSQ/4whuiOuZxAOttY5o32xQ/FqfbTlo2QtCHfsl
	IxXeD6HLUXv9PfvO0F41/r/jWXZr8MDbCuQyEhC/4wzTAPTpZAsRp2PAH9u8ReVa6ukBUKoaJ3f
	s9TKnDVGkxtg7c3Wjgw==
X-Received: from wmpo26.prod.google.com ([2002:a05:600c:339a:b0:480:6c91:3efb])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4514:b0:485:2f6a:6ed with SMTP id 5b1f17b1804b1-4855670b701mr196241325e9.28.1773658221003;
 Mon, 16 Mar 2026 03:50:21 -0700 (PDT)
Date: Mon, 16 Mar 2026 10:50:20 +0000
In-Reply-To: <20260216-rnull-v6-19-rc5-send-v1-19-de9a7af4b469@kernel.org>
Mime-Version: 1.0
References: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org> <20260216-rnull-v6-19-rc5-send-v1-19-de9a7af4b469@kernel.org>
Message-ID: <abfgbBjloS39qrbM@google.com>
Subject: Re: [PATCH 19/79] block: rust: mq: add max_hw_discard_sectors support
 to GenDiskBuilder
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
X-Rspamd-Queue-Id: BAB4818000B
X-Stat-Signature: oxmijqow558udq8qsk6xu33jsj6fmjr7
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773658222-791671
X-HE-Meta: U2FsdGVkX196GiMS8ZxZS4CQeIaiY9f7H4uIfb2Ad+Lsz4X/B0+/eKzIR9mHHDuZonkNytHgam1Sk6+hAF9vsj6l6xR8EMlAaAxbrejbyrrEioKGEJSQRWZpTF+K8LY603SzoWOzCK+WNBmnHNzjiyKHEebnfMbUaufEFKgaULvdVBaz774UentQ0VaVHoJTJsNHmwU0GQonmUIWAVllcOd6llv+oe37SsX4BgFMg57s9PhuIAgoiK7vh/St/3guiT6GVBYm6p++80ShDJujJ/M2CL6S8ip4dvHzJ7CELqds4YcOq8uavpk/laoIpp/tz+pYSAc/UpLzFRq7m+14VR2ZGXmZf1Rz4QRLW580pFTeAXsS0rNQs+L0AUb01dezD6c46NIdJbRKWugGpq9qGlQdttefBDqJivYWRER3hVzDl2IzhvUyZ00ovJm9G4BDBApsLOt1g2YzBqBXAzhBH82DDbiinJpv/xHVe6c3KRc6DjK8KvmnQDu88/RmIZYNbdoNtAVnNdIyNJjFmQzz1kPIjxUDF6ta0OYyuHEz9/roCoZvVTG4DRTj5Htr4aMhLiv1HXF/B7GQJwLY7olpdQ3FTn1NviHAwlUEfSRkOK+JXWjyl89cFxz4wAlentyB7dqojvZWXVoY6Hbui/y8ZxGrmY4/c2irD5xAl5keRd9RkIqI7eqaaY/xsKNU5tSCH0wguHSIOkblf3xmtoF0UPG+8UjAyZKDGRl+TgrZLeu6c4ufWcyKP6yyCEZ8Lkwvj7kytBTKrI1qtvfbrFN1YWKfGp28UaPjMmIvK+K9MnMC4Ak6Jv+Lj6b/fHTA1quvE3SuEmMGHQM7cSPk2nPQy0pbht4+yJZCmEDUMiTzjBB6HOLU5SxCp1Q6lU1T1OrbN1o6MY1z8Ia2N+rUdq0F18zW3jPJDGL9XPdpZXFJlTFdQDMwym/vPwsF6c534YvIXTVqLP8KtrsaudE1IPn
 UXvzl2sP
 F7Rn9/waZ7gASL23WSy/HxRKXa8GhMHPDV2fYYlXkuVGdtsfruZb25CHtLv7vCKP6y1NcMLmgZqMZ/FHFGt/6o5nBR6j44Ic0oh0dtmBmUmxbSuTD8fI2z2dsuWVNDHxCXJ+iXe93BI5HmxMhC64PLsj8TQEHJsPp/RX60HsblvQAlspd8Spr1HtfHXiW32b6BOx0F+alxpY0h6nI/rcxStRnNckTLtFE9W8Tsk9t9rB8jn1PAk3uB2eaiaXVj7IZ8veKVsPYUICGta2FQQeDT8GL70U3NgRqJNNNJ1uxMbS1CPlRpgb3FfEKD+ld0btZkKHmDSN/oexMgwxo03ljbhlem15Jfss+KJMmS5tJc29/99I5l5vC4kqU6XvMUOUa/K5doGQv0lhFtrd2/yLiEUbsPqMdQwnvHjm01yU2oDIUU9SgoSsvfjYCnrpcEce4/9pIOzddRHkwbWDcgxVr9tCjccc8UIIJbU7L/lEinzJej2yddUKdEzaV+na0I0jprcXRkxlKRiiCUatFjvRhY0U6JJo8g1Irvm1b8DU2dCDgDqgXuUCZ07qbhf+Ojzi2zzC23u7AQjRD7q/iPVZhNSwcCtPS0bwRsXXC6KSk9yD4TYkLUY1f2GIjMcBWLG+lgLPdg3RLU2Du5joo29BrQ3Zcscco2ff8TCI5VEx22FpAWkuj/8hbk03mhvmdetCVS2D3KSEsM6lkPxLtF+vuuC1XgdllT2j+X/ak4vjvcdiLGo4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 12:35:06AM +0100, Andreas Hindborg wrote:
> Add support for configuring the maximum hardware discard sectors
> through GenDiskBuilder. This allows block devices to specify their
> discard/trim capabilities.
> 
> Setting this value to 0 (the default) indicates that discard is not
> supported by the device. Non-zero values specify the maximum number
> of sectors that can be discarded in a single operation.
> 
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>

If 0 is a special value, then it could be slightly cleaner to use
Option<NonNullU32> or even a custom enum

	enum MaxHwDiscardSectors {
	    Unsupported,
	    Supported { max: NonNullU32, }
	}

But I'm also ok with current design, so:

Reviewed-by: Alice Ryhl <aliceryhl@google.com>

