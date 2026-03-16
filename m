Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58C63F46455
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 12:02:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFE526B0213; Mon, 16 Mar 2026 08:02:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD6006B024C; Mon, 16 Mar 2026 08:02:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B02496B024E; Mon, 16 Mar 2026 08:02:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9F1786B0213
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 08:02:22 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 61F4BC10AB
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 12:02:22 +0000 (UTC)
X-FDA: 84551788524.03.5D7D5ED
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8713214001B
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 12:02:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="jlqGEkr/";
	spf=pass (imf09.hostedemail.com: domain of 3SvG3aQkKCGE9KHBDQXGKFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3SvG3aQkKCGE9KHBDQXGKFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773662540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UX+URBpTt60dMhGkY9Id85Iw5Xtu00SbMnwBlBMIQ14=;
	b=Ovjjc+TFtSn+i1nbfi2Fh5LSTavppP4GqvKhbKD6Dy3sCu4e5unsm85q0qAdfCKBDsXjiC
	+TxDFbViIxfp9D6nX4OejzhXSgWR6RCPVclCLomEIhtB4hFse3DfkIc6Yt4RRtFC4KgL14
	XUgQbiGJWxGVbkEbX1zDC0EKvJ+f1tE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773662540; a=rsa-sha256;
	cv=none;
	b=r3YyAGCfl76RzVB67Z1JDF3eduzf8fx9m7A3WfCeSMyRS58FUYufCgD+fgTRNs5YrDyb+8
	BbLCsrmbjeYFcJZvmsVUxrY4UlcpRTWUlxxdLcldNZJFrSgjD8MwRq83YCRA9V078o429h
	09jgOFjVmymLrUxgYDCuEc5D0eM3vz0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="jlqGEkr/";
	spf=pass (imf09.hostedemail.com: domain of 3SvG3aQkKCGE9KHBDQXGKFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3SvG3aQkKCGE9KHBDQXGKFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48553fdd03dso26256735e9.0
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 05:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773662539; x=1774267339; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UX+URBpTt60dMhGkY9Id85Iw5Xtu00SbMnwBlBMIQ14=;
        b=jlqGEkr/kROxo95N1Q9k0QV4BdLvDQjrpAIdyYbf3gL6RtN01XcxZSlzNO7S/xyoYR
         zyy4TA45kijnHHMfzV/aSY0fq/p4fr6K+YsJKWXYoHVu9lpNQuafYTtUCg6aI/sr04Gw
         AC8DpGRAnta4ojLKLj8/AN0Sp0Qh+BQ5heT/hp/K+oPP6iuuyu3YNtV9Bl+JEjv7R5OW
         t2jrbuEDefrmVJEsb54a5CS7d9A4xdsQz0/Xu9jQc4oUil/nK9it3/YVnrgSeO9md+wV
         hF8rrgNoGbDsjrLXLGizyxyQx7ld5hHY9Hnds5JMRQ8Lo+jc+oSRkE2c3YTEqbtBOoPB
         YwDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773662539; x=1774267339;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UX+URBpTt60dMhGkY9Id85Iw5Xtu00SbMnwBlBMIQ14=;
        b=Iem6gjHJxlbvENmJmeUtmnUWqvXizcAiX9fQEN+NzBYuetB2fxt3NCy0LA1tE7Gd4j
         ujtVGYZCq0k8UO2LUXDEYh6nxNs0Edrcor3pn2HuOWjm9kSWUJtLoTCtBzGoTdOHNe3L
         PIQJO7N6OWho4VubwBdVnUIiHN4xD9VNUl/TvOzDpi3mPibUpUTvYtmkl56h3TSObwGE
         rBmqTtu9skP217I9i/SCT7MGu+OgeIxLoFZdKYyTjbTh81BdFi00PJJDwv9a7yIX7YLE
         ARKfDPlDMFQvs4v41WhQbCmUOUXeGAZ+4C672QgrO/u6bvBpJ0tXH5rsubC5xQ9Odo73
         q2UQ==
X-Forwarded-Encrypted: i=1; AJvYcCWAbRuyL1QePeQO2Rx3pVtXCkjBbx+AefKR0qqknttE/eq2i2kO0p1YLUEFJZsoFO6to8WALp0ncw==@kvack.org
X-Gm-Message-State: AOJu0YzOUUpibgmgsJx68vlQaUCiYiPwze95rUCA7BvfJoCTvrqNtTPv
	OWnQamMwmGnt8wUA4ywg3nTI+UCBrY7Tcb5rwUvdS8o78kGAFp82UO2MgTD/sjzL26HwEc0zdjL
	yv8EYId1qRAsXsCMvpQ==
X-Received: from wmi8.prod.google.com ([2002:a05:600c:208:b0:485:513d:66da])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3b16:b0:480:69b6:dfed with SMTP id 5b1f17b1804b1-4855671e83bmr211989475e9.24.1773662538650;
 Mon, 16 Mar 2026 05:02:18 -0700 (PDT)
Date: Mon, 16 Mar 2026 12:02:17 +0000
In-Reply-To: <20260216-rnull-v6-19-rc5-send-v1-26-de9a7af4b469@kernel.org>
Mime-Version: 1.0
References: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org> <20260216-rnull-v6-19-rc5-send-v1-26-de9a7af4b469@kernel.org>
Message-ID: <abfxSTL2qTMtpnY7@google.com>
Subject: Re: [PATCH 26/79] block: rnull: add badblocks support
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
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8713214001B
X-Stat-Signature: g7j65nxr7nyfufd6xiibswmiy1ugesdy
X-HE-Tag: 1773662540-8599
X-HE-Meta: U2FsdGVkX1/LBrNhhkLcQ6Dl86R7BJuhS6HcFE0HymaEYxmsjfmCBjyw7cDjwFHAGyxlZCP/xUqrBoQ2RNHs0xwCEcfHUV1UbbCRcUAwPVSuXXx6cfYpH93JlOYiFEQRsJdJD4rIgklM0mXGzM1Nvsfqa7AdACpkc13tWxcGhIgct5OZE4tjtzNNaPbwrdk0PKybmjL0kOT3uLDohnG7WfA6uNdS+6XRAU9xZGr6OkfcDDFX5X5kS5uJ+qk9ZPq/8ZQxac18inHN1+yvG/ek4i3bWnOVbILVR3pnfSbUkzIWpTcJJdSLSyxDattjHSpzVXX1L3zH2/eKemOu5IaiLYqNwaHfjK2ZVOVXm4zLSRrZMCjPjsDkQU7wM9h+6l4iJtpb5ClpJmDchBBj8zUUMsUAnzX646tfhf8DnFl+pfSfhtyf81z3opM32ybXtxb7P3DW2lHWrmVnWVNf4VzKwJBBoAjbZlNsyWyadyKxf4HMmFtMcekcZ08B0jFrpEh87gBBEpw7ptBz7keqWguBwVw7ptXMzwiBSxksFlOqWwoU/21Y172d2/RdUIURQblqOvgnqxRSt702bzL0d5oBUFTRrzpjlZpbdtUCHixckD/6nlOO96X1ckIr63WcqtBakTOxPKPHyGRYJ8giz2Fd9d0idgLNRaRIpSSaWWPFg/W6EPWPn4P9KSumpVMBsBc4keVviZZqPU/xYSsl2aC/kRk1VLPb//ujbwAUpjIqTNmCv77l24Uv8zwT4z4w1DGUiMtOil+htGVI7jImBdC6aADbzOgLFMzIQ60pkcBesc5XRq7aN1xEZknmNwezDZfNtSrkEYPL623smxDwtByCRLRJ+HZbYVZcpJGXuMiYrAe+0FGduIrf1DzPNWvcit+8diDyGQ4m9w6g2wATuJm5j29Sa5MlxM3ZhNlZQI6PogbPUIJokuL55r/2VQoJoFkhnsFgrjKOoLn7BIY/Z3d
 avgmWsAm
 gUIeAs7HrZmcixyM1BVwDkevrwBCjNGgfxcB4jvuLuEcY0dD8hgooTDs8+8Dtn6ropQMpAYr/bOXFQVLeJON9B8VQBTvPkFY76cfNLGek1epIViSLSZ7UrU1XuEG8dgQJxAfIEhyM8O1qDpKf00QW40/LyC1QS7bBwqouXan+wPKt/mn2JgD8akIqZt5HO+dJpn+r8fxuGBRAwIMJPzYUGXhMJpBoq0R3aPq7XSm1ktb/vDBAa105Y+5uzQe4IB8OCAFjiV4ChWrgtUxXhnASyMxuQileFGe4HI3rCpGXHMd0kV9PI/L1+5uoBqRbkcjdM2YffeYfCZiJei9ZrfwYuLgFotwjDUqAyFbS7S/3ES2ECVAJIzpqnisel2Ze/ZTcblR13Y+NxO+O3koTb7LXzkDyDCjbWbnxDtLIMY26uW3ussobzkmymlcGhX4eTkOLjwMQos3T7waVE8NVxMdIdmQfot0USML1ZK5L1dtiG80AhwZz7Iy/FrsCXsRRSo98LfBSMwl5eIqqGlz5MJVY52dL0yXHU6n5MWGEqTP7Y2IwZDGrKidKR0iWo7wvjrteLq2GUh+28+VTz5y/oBFiilFKgsgXyYcOOxTW5djoISTDGv5oP2teDfrSDnUGYfOYh9dwGCysq8+0ghxCMNc29lmXY2WLHmME8+tejDcB1OBzuDYjgR05hljWbcvk0t2kcFhwuHi2vIly7T4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 12:35:13AM +0100, Andreas Hindborg wrote:
> Add badblocks support to the rnull driver with a configfs interface for
> managing bad sectors.
> 
> - Configfs attribute for adding/removing bad blocks via "+start-end" and
>   "-start-end" syntax.
> - Request handling that checks for bad blocks and returns IO errors.
> - Updated request completion to handle error status properly.
> 
> The badblocks functionality is disabled by default and is enabled when
> first bad block is added.
> 
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>

> +    fn store(this: &DeviceConfig, page: &[u8]) -> Result {
> +        // This attribute can be set while device is powered.
> +
> +        for line in core::str::from_utf8(page)?.lines() {
> +            let mut chars = line.chars();
> +            match chars.next() {
> +                Some(sign @ '+' | sign @ '-') => {
> +                    if let Some((start, end)) = chars.as_str().split_once('-') {
> +                        let start: u64 = start.parse().map_err(|_| EINVAL)?;
> +                        let end: u64 = end.parse().map_err(|_| EINVAL)?;
> +
> +                        if start > end {
> +                            return Err(EINVAL);
> +                        }
> +
> +                        this.data.lock().bad_blocks.enable();
> +
> +                        if sign == '+' {
> +                            this.data.lock().bad_blocks.set_bad(start..=end, true)?;
> +                        } else {
> +                            this.data.lock().bad_blocks.set_good(start..=end)?;

Taking lock twice: TOCTOU.

> @@ -118,6 +125,7 @@ fn make_group(
>                      home_node: bindings::NUMA_NO_NODE,
>                      discard: false,
>                      no_sched: false,
> +                    bad_blocks: Arc::pin_init(BadBlocks::new(false), GFP_KERNEL)?,
>                  }),
>              }),
>              core::iter::empty(),

[..]

> @@ -155,6 +160,7 @@ fn init(_module: &'static ThisModule) -> impl PinInit<Self, Error> {
>                      home_node: *module_parameters::home_node.value(),
>                      discard: *module_parameters::discard.value() != 0,
>                      no_sched: *module_parameters::no_sched.value() != 0,
> +                    bad_blocks: Arc::pin_init(BadBlocks::new(false), GFP_KERNEL)?,

It seems weird to construct this Arc in two places. Is it shared or not?

Alice

