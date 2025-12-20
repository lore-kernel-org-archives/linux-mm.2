Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB816D637B2
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 08:41:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8D096B0088; Sat, 20 Dec 2025 03:41:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C10E16B0089; Sat, 20 Dec 2025 03:41:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF1E56B008A; Sat, 20 Dec 2025 03:41:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9A2A16B0088
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 03:41:28 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0635F140470
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 08:41:28 +0000 (UTC)
X-FDA: 84239205456.12.67FC434
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0230218000D
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 08:41:25 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ICM30fKw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of dirk.behme@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=dirk.behme@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766220086; a=rsa-sha256;
	cv=none;
	b=edPAJg74/oNfJ+KDQUOBJzHvUhD0TqDLsw21XJzmNmM8U5X+OmfSZH4ydmF/Mg54lCCSy2
	RKYsU6s7npsbeDHEAMCbXHvppCzjfxVg9bTppVJYUTKnuqt/Oz2RFx90ATrCSyupfdbO89
	bqCvMsi3ShHNAAaPI0oR8QLplJAooc4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ICM30fKw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of dirk.behme@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=dirk.behme@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766220086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bWMu34v/hHkSDoTf1KqyJ/0RKvtfdSHBb4H28JDtcl0=;
	b=LhNUAf57WRq4b81UJ4p9tnaefFOfNfHpLOz330/niXiSr+Zw71kbxnYZmc4KZ9a6suK5nx
	BPO3K4gyLzq2RjKIU7KsBrGC0cX5SAdXQnHKM+ySi0Wc30pdL0ZczCe2MewJhiBheqbQT4
	cVylTFB2EdsfKBJTf4fW+G5AZkvto4o=
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b725ead5800so351205566b.1
        for <linux-mm@kvack.org>; Sat, 20 Dec 2025 00:41:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766220084; x=1766824884; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bWMu34v/hHkSDoTf1KqyJ/0RKvtfdSHBb4H28JDtcl0=;
        b=ICM30fKwFLE7Iz6UdDrlgzt8stQ51r+B2NUfZzHC0C2eEERGpUNnWyjcb1uCdf/sNj
         q0z8SufObnNwUbslM/G1rw0Qmta3BJbT41SqXC1eihe2oUqgoiLne9/Z2TkQg7m5DVFu
         xDFW3ygmdRCkRzUerPPu9VByzjFZzG/UY/W8nVocIJGXT5l3MCR9QVWN5o33MWn+G7Wp
         Iq0JrkDGI6K4F4sHTlGLZqYV1/q8ToHE6AhbXUbbPN312JN3+EDpLIQfOb7OTWffSRps
         HoTq2Iy8rIMwM3EwVJs4xOMBMpC/Q1Qge/x+pGDsaPAYzdeNHXtWUi9h4tCi91tiiuEd
         gNbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766220084; x=1766824884;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bWMu34v/hHkSDoTf1KqyJ/0RKvtfdSHBb4H28JDtcl0=;
        b=a3vcNFRUXW4taN02EfjejC7Xg0ckShXdEbhy54fbdE5xMQTP+LkXGqOtTYbyG7oc07
         vhlJDfyBjkhxIu4JknMaCM/iT7XwpDPy+6dG0P2fEFFqGXbztJegP6acLXaVnD/zDcNh
         qKY5PM9aqj16MUaBeCly2A/+ypQrVYb23itYzmPwwrYFPAWIOhQhBGXfiIecK+erpkM0
         F0M22B8Ga2zHgqHhktTf8IZ9c47fZ5IN0ewxoo7Z9nIhj0Gsu8ZbZlgLBMa2PL3DAi90
         X86xxm9QLDrT+2sRtmoQRYnqwKa9ebubKUqGR8iSBN1JneMWiPVG0Wrk2dpvVldT9Yrc
         IBaA==
X-Gm-Message-State: AOJu0YxneJrPtaQpR42vev3KjM8jYG3rkXaX3euk05b3knE+tIx5Yz0y
	fJYBBbU75+5STk8sW/TOwrD62SQzkPobWeYcyqn+kddXC1//HGrF3dGV
X-Gm-Gg: AY/fxX41KS+VeEqJLmz6Fch1ekyTy0QJXT2qMbDTiKmJKV9YL+0XPr1XdLiSOQAyueb
	HCAZIrVNYw/CGuUcFhBfVyx0U/xMimdaxyboOJCiUlwEqOtU5c7tUrZaKIwnkQHucw8xQd6DDSo
	zPp8AthcCI5sWFiuUzVRWTzGaOue+PHyJGRSSgBEbA5ClcZIbhZsOYT+ZhJK4H44GIzIQbwAMPN
	QBr9KJfe0lAdUpZh6OVoPoW87LFZXeN670UYHOSQen8KE4lEW4ijvargBayrQIBVENgDwuCTMGS
	bikm0t6xLACQPet/MrJiyA+Fyp+t8205squabDd0DyKojxSr1LQUZz02shAflDTXPJ/GyCN7cIc
	124kmu/JgNLrt2zZrzZYweWFsKNP1pWTzrorSYc4yl3tV0IQEbdjzSxPowXH9CHMNt41GX/T9aV
	gDwoXkofiFis+rgDr9n/2vdV8vl+E1oOBcX05Uy4wKzIPND/O3cPK39GioCvLaaglE00Y7qUKX6
	uXQN9LkCVd6c9Ke3e9zh5faNRUqgCyQC+SrePBwnaChgA==
X-Google-Smtp-Source: AGHT+IHZzjoS9V14RENmLKlf+khQqIifVYxxHt4K4jB0VUyp6GWo7+1rwbjQADCiEESqZ3CgtTPG4w==
X-Received: by 2002:a17:907:960c:b0:b80:b7f:aa32 with SMTP id a640c23a62f3a-b80371da8f5mr551727066b.41.1766220084018;
        Sat, 20 Dec 2025 00:41:24 -0800 (PST)
Received: from ?IPV6:2003:df:bf2d:e300:6a92:2e3e:53e0:d832? (p200300dfbf2de3006a922e3e53e0d832.dip0.t-ipconnect.de. [2003:df:bf2d:e300:6a92:2e3e:53e0:d832])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8037de0de1sm452672966b.40.2025.12.20.00.41.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Dec 2025 00:41:23 -0800 (PST)
Message-ID: <9efae3dc-05d5-475b-bc69-250c2186dd70@gmail.com>
Date: Sat, 20 Dec 2025 09:41:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] rust: page: Simplify overflow check using checked_add()
To: Kari Argillander <kari.argillander@gmail.com>,
 Alice Ryhl <aliceryhl@google.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Miguel Ojeda
 <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>,
 Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>,
 Danilo Krummrich <dakr@kernel.org>
Cc: linux-mm@kvack.org, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20251219-rust-page-check-v1-1-df2e52fa3bd5@gmail.com>
From: Dirk Behme <dirk.behme@gmail.com>
In-Reply-To: <20251219-rust-page-check-v1-1-df2e52fa3bd5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0230218000D
X-Stat-Signature: 4yzzestqm5sixosb3ss3qafn8dertspe
X-Rspam-User: 
X-HE-Tag: 1766220085-499126
X-HE-Meta: U2FsdGVkX1/2iM6yU7YiVT5uk0hTjOSyy1Kjc8aAwmoR+F92ZXYU3g7q6cSmCsw1nSEaQtH3lCM/ne0JWSoS/6E7x5SOe6zR8o8VXOkkaHFSmfFl6BIdIihbKqb/BgkZo9KWD8BfcjnR3H5gDJQBHyHikxyRHmUSoa87UcX/ZkkgObnSScbZVcVqnMHcyItya385/3viai/Gg1i6hcifXOo8oj+fuD3tauhGXcDPKtCrKCivGMDvTiDK5FbF5NJ7LYejrMoeKjIDtVI4rBbQZWFIxsxr/iEolUqoRAL8ym8Ap0WbADkQnuNpnzjVTZOsTpUMEjGdXrz8oOROroKOMCY4e+ZFb2RSqp9lp2lN9VDZV9ogqrSGghBKNrWFr26jqCcYYp3MLPswTtuP0+XjvN0PNsbP4cU+Nl2jFECryDN9NQjP/0ECL91mSke6FTQ4KN8sTgofvmxtVLfALwB8nnJUgXQRHFWLYbYvGkNSMpPkYOPhQJyf9WbDHlYb3eXhqwWtitoOqbAXyL3GNKP3SiuD0Eht7MaYSdA/ybBi/FPIzoLNIVthIe5xl5zXoStshDWrNvTlfyFU3O/bwqZttCRNq2yYfhxPsrZIpLk7yieituwsRVc0sj3ikPK8hMvWkEf4rFy2Cu4B/u+Hg33kzfVChnLN3icdlCOx/vQpvGHMuIrLmLqWozOf2DeCzF7FaQH0phmcrSgvlS73MqHkIX0z2oxl8r3NivGAdtf1GTqOeI3giuL0I0wFZJscdVt9ymgBC//le2OJjC8sTHQ7TefpEfPEXirDTExEhHdQtbwaaeHIxDeXjycImzdWyf6pmndFwmN19cVhnguGSFubYgWtqjSOqg4bYxaYBVohfTQEt9M8mWXv5RQPeVsYS5pg5Zgi3aN1u0MLB94CJ5n/d+S6w1XJxc6/25N0Z59arEDAhyHuDY9Z60ZtW/446XhLAEhsU6bib/HdpJZV309
 +EMKYbPG
 /0tqw5NG7mnpv5Knp8LfGAJ1WOiTx6HPnRR0+tawTJK0t82xJ8xmDa7SNGvWkhXstVfP70cfW4KMXZN4+ca9EGxGXp8X58GMWXVTddONhMMW4zbzWwD0Go+va+36WYPnW7/wYW0mS5NjNjLYehgAH08zrEU+HNS452mJ679l1aKaZfff2RqC7wRniOD6XxXQ4LgANBGaB2L7eUsmGuvDs2DvcMSOMeK5V3e9U2WoB/p6l64wdb0QOouCV7ftJG8940YV0583DLEcY+qQWicJj9gfIHdKlmPrdTJ3WZ+MkDLXpxfQOanbgmz45HnLGNWS08WAbnB7i7m7VkJ5xGBVvDfkk35Am/sZUf9JnUsVkJflrsUboHGlz2aVD1E27CLdXtWk6AGcUtb5QirlupE/eyWJdUHshXJ53rGmAh0UDDPmpu4aM7C/8yRF/I5y4Iu7STIyqmWpymzVXcr9pVuR9mfaCVpx8v1urZfVAYGLrqvh82s0FjfkKnaZ0vAP1oCa82PM74EDemdx0SpcvlVBS1ZLIwWDm9onSvbf3p+IEfnAHw/aV5WBvfbkSm58S+s/r/AtHzouK7ptJQLc6XOTtEra5eAiqa7QTAV4x0+Xir5icoHuoUB9nSRb9IqSdroq7FZ+3dXvUqWfMH/bq+sX1f2hAlGdH6NDMOxbv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19.12.25 22:29, Kari Argillander wrote:
> Replace the explicit bounds comparisons with a single checked_add()-based
> range check. This avoids redundant comparisons, makes the overflow case
> explicit, and results in simpler generated code (checked with godbolt
> for x86).
> 
> Option::is_none_or() would be nicer, but it requires Rust 1.82; the
> kernel currently targets 1.78.
> 
> No functional change intended.
> 
> Signed-off-by: Kari Argillander <kari.argillander@gmail.com>
> ---
>  rust/kernel/page.rs | 18 ++++++++----------
>  1 file changed, 8 insertions(+), 10 deletions(-)
> 
> diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
> index 432fc0297d4a..a07e6d256860 100644
> --- a/rust/kernel/page.rs
> +++ b/rust/kernel/page.rs
> @@ -239,17 +239,15 @@ fn with_pointer_into_page<T>(
>          len: usize,
>          f: impl FnOnce(*mut u8) -> Result<T>,
>      ) -> Result<T> {
> -        let bounds_ok = off <= PAGE_SIZE && len <= PAGE_SIZE && (off + len) <= PAGE_SIZE;
> -
> -        if bounds_ok {
> -            self.with_page_mapped(move |page_addr| {
> -                // SAFETY: The `off` integer is at most `PAGE_SIZE`, so this pointer offset will
> -                // result in a pointer that is in bounds or one off the end of the page.
> -                f(unsafe { page_addr.add(off) })
> -            })
> -        } else {
> -            Err(EINVAL)
> +        if off.checked_add(len).map_or(true, |end| end > PAGE_SIZE) {
> +            return Err(EINVAL);
>          }
> +
> +        self.with_page_mapped(move |page_addr| {
> +            // SAFETY: The `off` integer is at most `PAGE_SIZE`, so this pointer offset will
> +            // result in a pointer that is in bounds or one off the end of the page.
> +            f(unsafe { page_addr.add(off) })
> +        })
>      }
>  
>      /// Maps the page and reads from it into the given buffer.
> 
> ---
> base-commit: cc3aa43b44bdb43dfbac0fcb51c56594a11338a8
> change-id: 20251219-rust-page-check-819ccc39c53a


Thanks, this switches to the early return style we recently discussed
in [1].

I just wonder if we would like to add a comment like

// TODO: replace `map_or` with `is_none_or` once the MSRV is >= 1.82.

like we do in e.g. transmute.rs [2]?

Anyway

Reviewed-by: Dirk Behme <dirk.behme@de.bosch.com>

Thanks

Dirk

[1]
https://lore.kernel.org/rust-for-linux/CANiq72kiscT5euAUjcSzvxMzM9Hdj8aQGeUN_pVF-vHf3DhBuQ@mail.gmail.com/

[2]
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/rust/kernel/transmute.rs#n75


