Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76E71C88E53
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 09:08:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D2936B0093; Fri, 11 Sep 2026 05:08:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5925F6B0096; Fri, 11 Sep 2026 05:08:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 480D56B0098; Fri, 11 Sep 2026 05:08:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 151BE6B0093
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 05:08:36 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 02C42C0156
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:08:34 +0000 (UTC)
X-FDA: 85200905790.30.D4034CF
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf14.hostedemail.com (Postfix) with ESMTP id 11ADD100006
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:08:32 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=o0SR5xoR;
	spf=pass (imf14.hostedemail.com: domain of aliceryhl@google.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789117713;
	b=hFQ17XTpl0YzJzlmVTlHeR8bV3ejuef6J0FDMo1zjfyjrMPdwpFCu1UocgHxaGbKYrki+X
	jppMG+k+IP0rwcmQxaJKahFyJWJ9I/wh8ElU6N5H+ZdD4zAMRuWAEWUhindLp4OCDYWEJO
	nSMYT92YnyAfgc7y8ICE5TyM5gK7Zx0=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=o0SR5xoR;
	spf=pass (imf14.hostedemail.com: domain of aliceryhl@google.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789117713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8V6E7xJ2vtTyuoasuWVTwqEDTbAd7Nywgb6H8W3xPYA=;
	b=j6Jjv1j/EGfPbOtwm56BKDFMfqkK+aWM2DytmyMTD3vQF4uBt23fNhiU18/bu2E+7QjoZC
	53xJ7Yw8vn+4s3JBptUW+6u9tzYOosddm2fos5ivSqMihcjJFKdi7CQDimXLJpy0uoNkLX
	B5KWzlb1mKhhn6bfNqP/S2+BSRyejkE=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-4843e397f74so406031f8f.1
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 02:08:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789117711; cv=none;
        d=google.com; s=arc-20260327;
        b=qkctzeu+uRW8Im3bJrghTIrwlwHEfAECWk2mdXnPrOd/3OVsQMDdcQChOPkMYmKwqb
         nHBMPSJWVmNgPNGtkQesHKKlpgg1EdOELWS0txnI8ymepptbObF3YLB4zasDQf9qvbjZ
         eWsFjram2otoXUI+h/BLXamRcVOx+8SkoJDAIlqqwfaUDiWhgbK7NcWp/WFiP4GiP0b3
         gOJEX9TN+orVbZFjZFtgbYvlpc/BIhaN6xu3Kdg8XO0OVFtdGebmNDNTfegE8x0fCxgc
         MeLtpUVbNontNBMQq5ckvkBKz4noq/5oArZmPrFQMZ9OxluKOo9abzWV/OvM5WhOhUah
         I9Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8V6E7xJ2vtTyuoasuWVTwqEDTbAd7Nywgb6H8W3xPYA=;
        fh=N6tN26022DTxYv6t/KcmiWLpssPPDWg99vAN4IEFAYs=;
        b=c0EBMTz7wWrS0ci6ZP2sEA9G7FF7rNMPD4jmZ8XyyKpd2tTLjA9KO5ORWZzbgvRq4U
         LXpbT0EVDfjMCIhpSXci/5p1FP2NasKZ6f3gKrfcAyWD7CfuCdOx0POHH8WeJt+u9EH2
         KykDJ19xjj5cGGLQ3qhPbRXgoE2T+7LV9VR4RuvyGadTrXIdg0ua/OhtKuYfhNexpxOU
         DMeB3dZz47MDDgSZd7vV5hLQyzpqOamnIiZ8RfgRd2UXgjXiy7iEWoVslMj1kmHyK0Zh
         aViY6WLhANNsA7H+dX70VPWmlqRKvqjDFDeKHHIXD3PUdtwK2lje84EZlyEn9BPGEp7q
         qmEA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789117711; x=1789722511; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8V6E7xJ2vtTyuoasuWVTwqEDTbAd7Nywgb6H8W3xPYA=;
        b=o0SR5xoR44aVAa32yqWkS+6yUaGp8Xy6A//KrTCvRZRYS4LwIdgfHV5Su7yiSOI1kl
         ehMFnC3lXKpH2vwsxyLQ8GfeBD1aFVOaf36UacaiKwfX5BJ9TDc8+0gfWFkyDH/5RKnG
         FySlxaf0Cq7aZo90wIYO9UTZywH8/B99rBzqY8L6qs0Dzfqoxhvve0oLNhiNPoy2RcQr
         GzlSmEeOcfnxl4MqQawO/C3gSzEBlUk7V+dapC/a9rhwn6255JsfHtqf/UATzLoLlp/m
         FKeU2D671CRhok2zva+jLZLto2kVw/4DG9fj08Fmn0BRhW3vSA2gaDuv0cViC6xD36V+
         zGag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789117711; x=1789722511;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8V6E7xJ2vtTyuoasuWVTwqEDTbAd7Nywgb6H8W3xPYA=;
        b=UGA/1/SsXaC/P5blE8zyPNn56jzGV3LWP4o3NAVFsDvcryy/uU2e/JKHfpP0Ar0wNR
         +UGNsE2y8Ue12G2Kp46QI1XuJfrkGhAj8u3ToMlFOiTVpgAsA3g6u7mB57KrL0iSH919
         xBi020ylj1kI8ekiPXcq8ee/QwKza7Rasf4II22X9/LKhcN6HGX4Cq3mafA/SQWAAitv
         EP/K821YGj2vlH+XOKvCOTZlPSzFjZUNTVHCHg27RcMMBP5A8/4hx7/4DBk0G3Jvdwpw
         f9YApQXDKG3sNtxm8o0T4sO8QLMExc1coRMCccpN7CdoQpglVtOEo23NSdXMpuG3Cub/
         M0Jg==
X-Forwarded-Encrypted: i=1; AKwUvBxdDBqaa1IUc5cP1TQ279G9sMdP2ssouCMhkUAUsr4pRVqPyXKHpWHS09drAXxwv5SkZ5jvGFjj7g==@kvack.org
X-Gm-Message-State: AFuF++mgtH3iJBXkk8oLenlM0144lJ4oNAfXS5az6gAslj5fK9unbqPD
	f874QleNIid7X6tipZBWfWmGbnD8/qTWz8gmP89U0mo7W5c7ILIyx2FmXXKwUW8unr5+qjZIICD
	mo/sx0/iC8h9GqVlLlqKDh0IP1iFTfZ6UUYMXy+bV
X-Gm-Gg: AYBFou3IbeeQ1E3zjKosON/g9lkjU2aeFAxaiyn2lrzhQpwrqNRQX+lJOuz/yK+qCKO
	qk76hB3c2Fqnr5a9jnPBCzvPP6Ephyt25WdLkTY7Yehut6xLASwgf8PzXLJ3Fq2tNXAZr+3UHRa
	ssUeJFmFOviRDKlbP17+5hZ4njUaPT4xqF9LNK7qskK+ZiJNlZveYUeXIbdfHGbViADwphcnLFI
	JqRSu/R80S6Bt4BQq8McE5eEkg0kZGg0oWg99/VMQTiwEYrOtd3PEnEDJzKmXoD0TMF7CV6eKK3
	aWTI/SHBNR+M83EQiC2/WaC8iWQ9t1CU/q5nbItrcjgLU50COmW9dufyBO2Dhbjl0rYGX1zj8ox
	ig7omfXgu3fLp7CsUDBimufn1We1Sy3r4b/u0JwpS7qxlKx2H4uBOGrGkYG2qOpHK
X-Received: by 2002:a05:6000:46d0:b0:485:8226:c691 with SMTP id
 ffacd0b85a97d-486e0f6ce92mr8157059f8f.16.1789117710377; Fri, 11 Sep 2026
 02:08:30 -0700 (PDT)
MIME-Version: 1.0
References: <20260910-unique-ref-v21-0-e83257373062@kernel.org> <20260910-unique-ref-v21-4-e83257373062@kernel.org>
In-Reply-To: <20260910-unique-ref-v21-4-e83257373062@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Fri, 11 Sep 2026 11:08:18 +0200
X-Gm-Features: AcwNN1Wcpw91RcC64bgI4fLKPGdY59qIT8O1U-qjeWGvrNCV-tRUtkCYbazUk4w
Message-ID: <CAH5fLghUQW5urTfLCCDT4BhuqoFVoLUAG46TS-SxaS37bJcgWQ@mail.gmail.com>
Subject: Re: [PATCH v21 4/9] rust: rename `AlwaysRefCounted` to `RefCounted`.
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Uladzislau Rezki <urezki@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Daniel Almeida <daniel.almeida@collabora.com>, Tamir Duberstein <tamird@kernel.org>, 
	Alexandre Courbot <acourbot@nvidia.com>, =?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
	Lyude Paul <lyude@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	=?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>, 
	Todd Kjos <tkjos@android.com>, Christian Brauner <brauner@kernel.org>, 
	Carlos Llamas <cmllamas@google.com>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Dave Ertman <david.m.ertman@intel.com>, Leon Romanovsky <leon@kernel.org>, 
	Paul Moore <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	Igor Korotin <igor.korotin@linux.dev>, Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, 
	Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	=?UTF-8?Q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Michal Wilczynski <m.wilczynski@samsung.com>, 
	Ira Weiny <iweiny@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	=?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
	Philipp Stanner <phasta@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, driver-core@lists.linux.dev, 
	linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org, 
	linux-pm@vger.kernel.org, linux-pci@vger.kernel.org, 
	linux-pwm@vger.kernel.org, linux-usb@vger.kernel.org, 
	Oliver Mangold <oliver.mangold@pm.me>, Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 11ADD100006
X-Stat-Signature: ho5xyrno1nytgssos3nr5yho7j4pzusp
X-HE-Tag: 1789117712-565153
X-HE-Meta: U2FsdGVkX189NG4c/u5ThGK5gXei8+wY0lVwmaWCndjy857QA6gN9HGqMiqTZQYoiOa/XAchnObFeBeQ/fYX0qMNDrU+4eVrZoMZJvJw02gF71V6JlrntIvnaUyzWl5IV0ft8ykliaw+SYf+UeRq0YpyKCfW1gSfds5Fj9LbcliJXokNGmKF6QNCNmaimpKXbaX15OADfteQ/0jEakUfdKj4ERdLm2GRU+rZNlQLTwAGalSz+MpIkp8B95iq+aUZzMuFiBrHjW4ikmOv3DjE1YJsTsaOkxKh+M1sH0fPKKleDztjIY/761+6C7J+3Y3tR1Tw26gIn78ggxKOP39FwdWpmFR7FueZPyi/7pH52WNzpa6iSDXXZf36/FKS1loVA7Rn42hcn7FwcowVrS7FzVQt8f2fOBwGCIzGDh01IjfmsCGpAnoQFxbZiqhhpX+k56fZ0fn+s60tuXx0xJIhYSZDS8p6FWWPWTQWLFi30vnv1HdwsLs1xW/Gpc/wHAr+wseg6loC0IezZsDsF5nA+h77W4PxFun47cyPw2zy7ykLAxJY7FwepebbEHvSwUMU5Pu39Ttznneub8SnK9ZksEDH+OeSKtRaLgVgOWzwKtTmTyQlTM5GZxPd2AxRfIaiQP2vhzGUjycqDI8RRKLbiT08yVpWiV0QYsf/wx6fGV4AyrjIN/kUZw52KjjM78yWD7M6u4AoCzFCFINAOandQ+OfZf0HzEHBu4brGjC5prMjKGlRZ7zPUe48Hw5aNJvxToiJdLtrWmfqulgMlUFCDPEZU5FVvN8J2dfDv/bPc71zELPk9pZFA1FC/XEafbGJAJYm+M7e87omEYtQ4Rl/obpOI3RFhA6QQSmig3SinJGvJJmV3GS6mFgGiAeX2sz3Rlbh6hyAkBC78Y9l9gW9ffkyvtCFpM3dWC+WB0Ucizy+CBE3pOXxaiQCpLrY3Iqy/xHqtT4Bgfy1vbyLyii
 JsCMetid
 hkfmO0ME9rRb+7BOfkByDY7NPwuQrxuQSQ64Enl7uH50bYmAvQpMj0lLbkYBHRjsnzqXtWKfw5P9E8rCPVken2F6U2NTeHih8Y2RtmrEEwoYW9TMAToaPKMmNbWcRDKmSSf25Ji0p1tUSj2Ha5bLB5elDwn7RqUjwtQk3Ehiz3CSbWJQzsygpv4QK+yO5nz2AakDGtwcbYGhK1I3CRjHSlCharrCOmu3R2yJ2bm1sUaD4NER78PGkaCHV8DBvlwZBPfKcs8990y2Ukd70ijIegd9Kb4pupS1h5SEWO9ixy/EpSv/bf7k2c4L4n0SnSx0oizLBmSeJ8IvCbgvbBhdA7g8jtQMFR6zdYcNQyZ4CuoJ807IX4ISxYGfhJ4RCcA8q0Mly6hYbysdvSlG4EDlqvZ7kODrh/rUIbr+0qeIri9ioXTyob942gMVIGpBSUXwgmmTaJv5+O3ljzVHQivbgVWhS75Zmo+Wp35ox7/vj/8AHNnisKjwjWn5dT9h/a3LMR8teUvszT2hR1gQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 11:01=E2=80=AFAM Andreas Hindborg <a.hindborg@kerne=
l.org> wrote:
>
> From: Oliver Mangold <oliver.mangold@pm.me>
>
> There are types where it may both be reference counted in some cases and
> owned in others. In such cases, obtaining `ARef<T>` from `&T` would be
> unsound as it allows creation of `ARef<T>` copy from `&Owned<T>`.
>
> Therefore, we split `AlwaysRefCounted` into `RefCounted` (which `ARef<T>`
> would require) and a marker trait to indicate that the type is always
> reference counted (and not `Ownable`) so the `&T` -> `ARef<T>` conversion
> is possible.
>
> - Rename `AlwaysRefCounted` to `RefCounted`.
> - Add a new unsafe trait `AlwaysRefCounted`.
> - Implement the new trait `AlwaysRefCounted` for the newly renamed
>   `RefCounted` implementations. This leaves functionality of existing
>   implementers of `AlwaysRefCounted` intact.
>
> Suggested-by: Alice Ryhl <aliceryhl@google.com>
> Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
> Signed-off-by: Oliver Mangold <oliver.mangold@pm.me>
> [ Andreas: Updated commit message and rebase on rust-next (7.2) ]
> Acked-by: Igor Korotin <igor.korotin.linux@gmail.com>
> Acked-by: Danilo Krummrich <dakr@kernel.org>
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> Reviewed-by: Gary Guo <gary@garyguo.net>
> Assisted-by: LLM
> Co-developed-by: Andreas Hindborg <a.hindborg@kernel.org>
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>

This has a lot of safety comments of the form "This does not implement
Ownable, *therefore* it can implement AlwaysRefcounted". But I think
the safety comment should instead explain that it's okay to create an
ARef<_> from an &_ for this type. The fact that Ownable is not
implemented is not sufficient argument.

Alice

