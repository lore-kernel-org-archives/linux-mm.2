Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 696DFF4644A
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 10:43:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9886B6B018D; Mon, 16 Mar 2026 06:43:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 972F86B018E; Mon, 16 Mar 2026 06:43:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 874F16B018F; Mon, 16 Mar 2026 06:43:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7344C6B018D
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:43:41 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0EF011401A8
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:43:41 +0000 (UTC)
X-FDA: 84551590242.01.F9F8311
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf12.hostedemail.com (Postfix) with ESMTP id 49E994000B
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:43:39 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eYFgQzJF;
	spf=pass (imf12.hostedemail.com: domain of 32d63aQkKCMoq1ysu7Ex1w44w1u.s421y3AD-220Bqs0.47w@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=32d63aQkKCMoq1ysu7Ex1w44w1u.s421y3AD-220Bqs0.47w@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773657819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aIsjm9vE54z8tUJ1wyvdDm1uLSUX2YtWlUueHA6I6BA=;
	b=ad2ngCblACyrYfkyjfUaflClFVaBCj2CzVh4hjDZcwXKVyf/3HmL5Yw9AFUSCHgTacVIFi
	LgirhyrJFVyFK11Dh06sYkufBRuONWo3KFeU/xHaCrwQD+8u5DwLxok1FRujwhE31zAojM
	oyvE4HXf9Qvlp4834EP/ZpZm7U1w258=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eYFgQzJF;
	spf=pass (imf12.hostedemail.com: domain of 32d63aQkKCMoq1ysu7Ex1w44w1u.s421y3AD-220Bqs0.47w@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=32d63aQkKCMoq1ysu7Ex1w44w1u.s421y3AD-220Bqs0.47w@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773657819; a=rsa-sha256;
	cv=none;
	b=uqnyeR7CH1o5OzedBCT6/yvrGXKR3PF6Pf8U/iNZQpsP7VOEpvaD1H2bhc4WVQ6upS7ct/
	WlUbPXNIDkVA+5ewj1YemCLUSW9SijrBeoJ0TOD51qqioGLjM45rfTdZpvbD6tpQt3z80i
	xYzq0d2mJrdWbJxxlFkBMLGvyN50hRE=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48544725bdeso57296365e9.2
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 03:43:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773657818; x=1774262618; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aIsjm9vE54z8tUJ1wyvdDm1uLSUX2YtWlUueHA6I6BA=;
        b=eYFgQzJF3TGrVDiN/m9vc5EMnBXQV+RvglT3Vnkmu5aOMKuD6di89inY7732UXRohI
         t6f/eo/LEcCMK8CH+vAXhg/u7yI6+kGcjPolZxHkEyL3jNyDA6sq0PCLBmB017Phki+A
         00UuT4nu99Y/shvQZFhSzpJaojed6WRH8y/NQzEBpvBMW9YcnoIZJbrSrQHry4IPmJw8
         XCb6BHRknn4nI4XQ5lWx+BjF/QmdL1mHF1BMg/X+RDb/sSrbCSfNN9nVE8igGTleiA4M
         ybxmalBM5vAnL478pWtEpBywXCTre/UXm/b3m4fxa1SrcO1pALUUkiq/g6Ur+Vu0/0BH
         JDUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773657818; x=1774262618;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aIsjm9vE54z8tUJ1wyvdDm1uLSUX2YtWlUueHA6I6BA=;
        b=AyzEO4MGBnYFkVKlg2tBc5c5J/jXY4GJWkymDYV1NERoXdjO5uWoQZeU5PzKr15eCV
         Q7/vY5Sfyjj/G0XYJxyJILClsvOQhzZbuhEA7wC/6e3Js/P4GMzLJJGhOmkTzBPMtfmF
         KmUaDwebdMjZtV1qVFEYw90TrIWWrx3fuVeFkYKLgImEQ+d8vdPEIcl/WQhnWjAiSy5f
         r6D1jBc5izluopzlLNuRDXtzlfD/gU3ExLUkpqF0i9X8vIph5uUHO5PzRy2wv6M3x0OU
         ghFMXG43/Ir50ZeWWWPqR5PZlkK2XcGffV7sHgJ++jns2mfWNAzTWFGIzs0NBRk4hHhE
         zobw==
X-Forwarded-Encrypted: i=1; AJvYcCXkiCRrHEG8VySW2mouXuVrYGhn+C75EB+G3I56grh/rtpByDJaDIm7wh6aae7R4OXGWHIYesuaNg==@kvack.org
X-Gm-Message-State: AOJu0YzcH+JiUMK9vjDJj9M+bLlnp+whJJ46sD4owPIQizS+yB6wtzfj
	QTqVFkVMw8Nsg5wGHzfG5JxpicfTBs9oi2WraD/z/ncAFrCBkhyNfRxhl7kxOwxpKn/EFs+Y02y
	WyE4t+MXCBLC5ZXX5sA==
X-Received: from wmno9.prod.google.com ([2002:a05:600c:1649:b0:485:38ca:51c9])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1e8c:b0:485:3e00:9440 with SMTP id 5b1f17b1804b1-4855670c296mr200273645e9.24.1773657817662;
 Mon, 16 Mar 2026 03:43:37 -0700 (PDT)
Date: Mon, 16 Mar 2026 10:43:36 +0000
In-Reply-To: <20260216-rnull-v6-19-rc5-send-v1-15-de9a7af4b469@kernel.org>
Mime-Version: 1.0
References: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org> <20260216-rnull-v6-19-rc5-send-v1-15-de9a7af4b469@kernel.org>
Message-ID: <abfe2LbhLzXiGCkA@google.com>
Subject: Re: [PATCH 15/79] block: rnull: add `use_per_node_hctx` config option
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
X-Rspamd-Queue-Id: 49E994000B
X-Stat-Signature: j5iu1cz55bjci6qtjyf4c64u8jhoncdq
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773657819-753098
X-HE-Meta: U2FsdGVkX1/sbnuzAhL4tDLK0rZ+bz+02oxwlUngPa+jJY3RT2B+KHst9ER0JOrgqJs4JPzPkbjQhGfQR+3HMfMGGLuJCyX4+EOQe8tAGXb5m6XabdP9nrfPfH2XV0wyJHV3T5s+hJltksqTQPTi8ad2mIO2VizVSf937J18wx/XrQ9aP73VBl+JNPu6ya4QghYldS1x6/N+O5jA5LlrQoQiUmtz8Y49zcRJOjJxivM6shxPqGOjfOHSOEssCZ+KbfDUOOc4T1IK3ufr9zW4l0ty8b5y9vHu0zocNMwLpUKqMI1uNYvsM9IINGhx9QNZSxQx4WkbvHEi6yYTJBIXJ6tfTqB9rho5a2pPT/ko9maEHd3XlR3oHUB5Vfky0XjoNwxRWxs3L4DBoFyV2VzT7b7i0Vqj2h1gw9zOltqSTrhfbw6I6xt+nhsekv0SuyBX00w0Ng4SBijwrGoafNyVqVCMOvyLxvkObDfCjfJZznkMT5Nbesp2VE2DJ3mvVmbmoYWxCQjZ9cmzbrHY7vXDBE/ZKGtb7ntbRjI0NKRONAFIpUhqNz/8ON/LJoSSXqsUgZAR158ttG+qJ1ZcBQ1wkYevT8eexszIvcjS5GXi16lm5kk7fykKtaeobjjYMNUS9TWMGifMygDn576Dzs+iGlsydoV5FsSwxDmldj5k14zfuXphQijFAv/0GTxtHhZSyp12xUWCRiiMFzl6EDH+JtGY4xaDDdkB1b2LH6TeaG3pC01xxh+ZfTgNFU/056QOOdsbYAJ+DvHFcFuSWPSb3RLgVlTExJnlltC+uXsboqLu8rnaUhgwhTTOD6DHVZkJS/l1c2kYOphjkZHSUP8S6qYKnz2du8df5HPW+fM93MXZ3vH3eQvnEXWNvENJPKt483Q8KRqJ0+frtwymwt9lc3N48/pkzYIebOzvQzZ/u8iiiFY/A7MGm7QzxOxy2sAxfrMfOXmUtyxjYxeySgy
 C6vFFipR
 EIdFymRoItQmgVI2BOPykbUA8LcVaNIJaVXoc/+osgfBTC0PZKnj1YwRToaujN1dNFZj+xE8TS15cOQu5Mci55wYXeB6Y/7bJ+bJryJ2u7JMOxGBBG3LZYwHJC/KkGt9iz3o1pnNlz0TrmNRHHXaCNyhbj7P/6SJz2irTqwOUbwBG8V8GwFmx2Eteb0r6HrGL0eLLpdGsNIxC+eL+gO42vX5cZwT8BMNrvNo05snNEm9IgV6Ry100yq/D8yPpSFAsjFdn3xqVSY7HB8z/84dmmuCto9OrqGn3lV0U4Atm/zSSgSyifve05tyUGW7sszVPl1cTO3H3sAaEh5HQWef/JlB+82ZvUi2xKs74BeA7UhacXMmO6v2plU07cwbtkfSqSEWMKFv+jFlCB3qiCg9NCYrO8KzoYapdHtjV1NsDRsmY/T9VxDhOs6fBwRzbCIZQISTnWZMhodFuksBGbV56SV8dlREiRukoXDP62Y3m+rvNlY2xgVE6LeD8Wo680KI0Fp3YTtkv1NVfF+m+nj9d7qgtLdbYLaG61IdKEDa28B9rmwGk4hB5CZi0VMUgw9bYW9d6K+XMVto/+r7rRyRZeueuF3AL0FenB+7mcCia/0tlWyg/CGMVXuJ/BOSTmIhGEhJJBou/lmbIYTHHyXkBeWk759+bjaACdWr2GfL4x4WTWsr8c02wAwp7c0c0UZ7Pdq+boLGfxLoOPSWyuSeYMb4YCoJER6gwawL9MeeqFIcvxZlwoOFQjBCg+DMtCUqVgMRL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 12:35:02AM +0100, Andreas Hindborg wrote:
> Add a configfs attribute to enable per-NUMA-node hardware contexts.
> When enabled, the driver creates one hardware queue per NUMA node
> instead of the default configuration.
> 
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>

This and other patches make me think that module parameters should have
value() return a copy of the value (and require Copy). For non-copy
types, there can be a separate value_ref() method. You would avoid *so*
many asterisks by doing that.

> +configfs_attribute!(DeviceConfig, 8,
> +    show: |this, page| show_field(
> +        this.data.lock().submit_queues == kernel::num_online_nodes(), page
> +    ),
> +    store: |this, page| store_with_power_check(this, page, |this, page| {
> +        let value = core::str::from_utf8(page)?
> +            .trim()
> +            .parse::<u8>()
> +            .map_err(|_| kernel::error::code::EINVAL)?
> +            != 0;
> +
> +        if value {
> +            this.data.lock().submit_queues *= kernel::num_online_nodes();
> +        }

kstrtobool again. Also, this is *multiplying* the existing submit_queues
value by the number of NUMA nodes?

> +        use_per_node_hctx: u8 {
> +            default: 0,
> +            description:
> +        "Use per-node allocation for hardware context queues, 0-false, 1-true. Default: 0-false",
> +        },

formatting (rustfmt ignores macros)

Alice

