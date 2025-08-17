Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AEEFCA0EDC
	for <linux-mm@archiver.kernel.org>; Sun, 17 Aug 2025 08:33:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE5C98E0038; Sun, 17 Aug 2025 04:33:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBDD68E0035; Sun, 17 Aug 2025 04:33:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD3528E0038; Sun, 17 Aug 2025 04:33:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C6F3F8E0035
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 04:33:09 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1941A138B70
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 08:33:09 +0000 (UTC)
X-FDA: 83785584498.30.572C020
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2EED51C0007
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 08:33:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=EZUuthj9;
	spf=pass (imf20.hostedemail.com: domain of aliceryhl@google.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755419587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hTwTOtGwt6cJGY41AEmiyutI55TEpKyzi4qJ2ueIWhw=;
	b=YgFkWVYuFSr76m7+zk1Rt7jnNo4/h6HF7aR9xSU2QN0yZ0eGjZqz3l8MVQrbATvVF36d+O
	n5GWvSQ1VDWYGEjnUYiqkkOQFRG/7La9qWF8keVcIbWcugrQoN2sW1LhweVP69XrjSXxMG
	MqqdNSt9oSlz7jxdJjDVGD7rULKpGP8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=EZUuthj9;
	spf=pass (imf20.hostedemail.com: domain of aliceryhl@google.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755419587; a=rsa-sha256;
	cv=none;
	b=ARMp4sw6I/VfFjem9sTgbaMJmuRSseO/1mfi1BiM32udETprFXnxdI4o67ksIsMjQjHY/I
	YRvJ6KzUBYlNkgJ4bAHDDKch6coDvUb+qbu85LqvrOEMEQ5cV8JK1A5cdga8ApLGGIfQG6
	eECCBz1+Tv4LrAv91hBDSIwJ4YAxCQ4=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3b9dc5cd4cbso2222327f8f.1
        for <linux-mm@kvack.org>; Sun, 17 Aug 2025 01:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755419585; x=1756024385; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hTwTOtGwt6cJGY41AEmiyutI55TEpKyzi4qJ2ueIWhw=;
        b=EZUuthj9qyoYLbxIwnFhqKZNOis5WNBBlIa2iHwoI44xJwXznkcXPgyuwNHErCHmKF
         DoiX+vZ8jFm8ZcELBUw8GHHPu3sOI5x6A9Diecrokqv4VXd3B+wuQnUR/NJqUEaFxY4S
         8RBHG2JWeTGKAD36yfC0mXyq/Hnbi1GINk0LV5OmhYkXGoyDTD3a+TvlcrknfmEifbui
         aczcuP9sDfyXk7y2Lma79Y6RsoOWKXpxI+522oZ8VpD7x45Yv0+AcNctDc9fJKEPmCgR
         VuCakrU8gzYW7SqCsGsk5l+Ub+kwUrARPt1+zo6u4TptDfxQSCnhtAqKnI8jg2dxwkUW
         4nZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755419585; x=1756024385;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hTwTOtGwt6cJGY41AEmiyutI55TEpKyzi4qJ2ueIWhw=;
        b=fOj5OIkDeH3/1cBlL5DFCRThhCD7hOm+qdZiliWbRohFQdtQ+y5HTeCPkDDH/AEEww
         epR5baCqePcQZ9f48zTOpbbZ1BEEabCSw8Skz9ssU9ne2lXpnVesm5aeJ6cXYgnS5hZT
         As9UnU+B2GP9EVESun5WKU0O5gSCkj937HTB5ZPRtkFCSjGErCbdQH2Miu3GgCpZHZM+
         oMG9bEhL/aWuLTBQJLwH9Ben+/YOs548ggu1ava6dwvNP0Pued4oY4xwF1pH/9OiqEhl
         yAQVlt6OlS32lo8PDcYoSDEr/d9MNvQJXPzfMqAZyfC+vbOxCPg2H9iwFh7y+3V2lBlW
         9CrQ==
X-Forwarded-Encrypted: i=1; AJvYcCV1frf6C4Q9O6Z8qhyA5VucpkCVZalTiiL9sMHDbtdunUfzC34rmJBJdJLvSeIt+7a0DxwsIuZXxg==@kvack.org
X-Gm-Message-State: AOJu0YwvfT/DpN8ue9FD5ruwn15dztf4VcAn6ds/GAQAqq0wH0KV4JyB
	qNebfh8T6qGEf5i4IkeKflFg1HFOUI/YROSi7/mZdQq+4Fy39Bz7+tMt9mXRi6M/CT5Pr01axXP
	JE9st8t7cgtoJum0azsWgXj8IggrbJFRoeZt8fPYa
X-Gm-Gg: ASbGncueUuxYEGH5qYtEM33fKcUL6EUocUo3SrtoSjkBqR2DDhhOX6Hy7OtECle+y1P
	3dlqb0W93rth5hQIMz+4rXULYSZIR0ivFtkLmi6AtSs2yGaLZQXLP/+ALFAE31p7bJW+o3rvBaw
	WHP73AhwJiPQvVXqHSUxfsDhyuQQp7gpM9lrG42DIEzOzUqiRwPsImH9g8i7vyiW/yxgmw8aG+d
	oLOuVmMk1zqzGEUA9g8a+sKjGD+ToqpUR4A
X-Google-Smtp-Source: AGHT+IGoRb1xdrYrj6kHKejvqdDcCa7iTaEaP7TOTbmewwBY/XYltNC5+vB1zPlq8+D3PhMalwZdmY0KcTb1ScHU0tU=
X-Received: by 2002:a05:6000:430b:b0:3b7:9589:1fd1 with SMTP id
 ffacd0b85a97d-3bb68fdc587mr6365788f8f.44.1755419585362; Sun, 17 Aug 2025
 01:33:05 -0700 (PDT)
MIME-Version: 1.0
References: <20250816210214.2729269-1-ojeda@kernel.org>
In-Reply-To: <20250816210214.2729269-1-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Sun, 17 Aug 2025 10:32:53 +0200
X-Gm-Features: Ac12FXzhd2iFnnKjyXBfrCIdB6O_r4X05qYMnlTOhhEd7NQgiE9g9rzOlA9OUao
Message-ID: <CAH5fLggYHJg+PmLD=Fg2a=pO7JRmM+AqppwBqOBpp6+179YcVg@mail.gmail.com>
Subject: Re: [PATCH] rust: alloc: fix missing import needed for `rusttest`
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vitaly Wool <vitaly.wool@konsulko.se>, 
	Danilo Krummrich <dakr@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org, 
	rust-for-linux@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>, 
	Uladzislau Rezki <urezki@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 2EED51C0007
X-Rspam-User: 
X-Stat-Signature: yfu84s4669yz8b3cjh16sfcpcjjeobqk
X-Rspamd-Server: rspam09
X-HE-Tag: 1755419586-418822
X-HE-Meta: U2FsdGVkX1/h4ETHl0EkekaYyJbcchJbIKmxaQwq7YOniMx//s9j25be9eyvWWZGHLthrbWWgDDXZtLzvVjAl/+VNayoqVllAd0AMy4U6WlHzCtIC05SX+M3IAQnjfz0G0TrhTXNF16WLEMkCvQF5DV0HJgfwuFZsqS3zNtTI2grtNGIjdM9O7l9PEJVBsS5Ij4vis1QwbhUsMCBsZAoIVRirOEYBM22/UG87yZlD9vZ7k9ll0letmqvNvG81l/3lCnlxl4RC3VpIMOE6vNPSGxEoU6Yqt1vBdGszNsNWPgqOWhiBkv69u2gBkcRhmH562TE7q6eMRReeZU3WACX176v0tTqM1dJJTPNPhBoj+H6KshWz8cyAl/iiA+cuwf9Fpgmn8t5Khxp0icEVsFPnSdKJcMe/Lj7WR6oEKXqvXXBiQ9HxDOovvex9sTTGBxMGbMY6ZnilI+VkMr60t26QnzcK2bDbaeg7t+U9XQvlE97O2KDSv1B0bgBt8kpbzA/auL0Sel2nomdzTFsTBgd1n7w2gouVoiL9y8QVLA2cJKqjiUyO9RDGodhOLzXeLwz7KLgz8fRZTxXV8QB/4JbHYHu4qKIdmiGRhBTTROyAE00n9WeOxtBqDcc613hKnLyFvFq+8zyJ2Fs17Xs7Ad7+SZ5ivNy0I4bdn6wcoEFIrl6uu/hWY11F/5jmBhWc42UE2pNhFJrS106Ovh6AnailVVU8sUHa+afIduD5E0WHoXBZn7wgOSuhGcEhI7dZ4ckhwDfeuxmYB9NoBO2oC396XDLsARrVRugFu+Z6BRYwiBjjMB+N5v2mlxEHuty7bG3CjyYXjonVoGk3DzCvk782bp4ulwyRe04e7cpDS3Q+gxWQFk67MwrcnposlZqBdIuLTsDHFttyU4kuIqtej53ljmr3trG870RlzXXgOTRjkQb2oyCRWBLHjmn45e9cura8TqDc+utWy9ftTRALby
 Hohd9hh/
 qm9QKd0dTBtK5H8SWu6mn4vb7EEzBJOdn7LCLlIWsZVUhiqhvV7tDnFUbo6fKrGRUkkSXUYeq98LebOPL9BamRe7jT21a1cfwxHveJIZBIVJnoB0RPcww4CbD0ElNbC2wPrOHqENUHNOS1CNQKkV5ABQ2OG0ict79Vehp8Yu5ZKIyVPNUjPWreIq96YdzUV9OMxTKXyqALQUEBMujO7GA46eJp5ivH1zMzwsTNanugfxS+9FN2Cltqljwz2rzmK1L4kSa3oLukDNDKJdq3cskQCxyrSFtIzmDC9PP6uHCpqsKRPJhxKVxnQ/GFVpt4f50pBQqQvfcVurEeY2IRm5ApnBtKgmkRhtE13fv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 16, 2025 at 11:02=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wr=
ote:
>
> There is a missing import of `NumaNode` that is used in the `rusttest`
> target:
>
>     error[E0412]: cannot find type `NumaNode` in this scope
>       --> rust/kernel/alloc/allocator_test.rs:43:15
>        |
>     43 |         _nid: NumaNode,
>        |               ^^^^^^^^ not found in this scope
>        |
>     help: consider importing this struct
>        |
>     12 + use crate::alloc::NumaNode;
>        |
>
> Thus fix it by adding it.
>
> Fixes: 8405eafa6e94 ("rust: add support for NUMA ids in allocations")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Acked-by: Alice Ryhl <aliceryhl@google.com>

