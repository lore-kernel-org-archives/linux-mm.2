Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19F7AC88E50
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 13:43:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A7696B008C; Fri, 11 Sep 2026 09:43:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 157A16B0095; Fri, 11 Sep 2026 09:43:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 046E46B0096; Fri, 11 Sep 2026 09:43:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CEBF36B008C
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:43:33 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 66DFD16023A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:43:33 +0000 (UTC)
X-FDA: 85201598706.12.2EF81E0
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf02.hostedemail.com (Postfix) with ESMTP id 81E6380008
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:43:31 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="YO3yK/wg";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of aliceryhl@google.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="YO3yK/wg";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of aliceryhl@google.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789134211;
	b=7aepk1KFxMRilfpl9/Dis0JNyTuqa4TB7WMGHS7B8ii5PcBKDnAATnIl9FOg79kC0+A0iM
	7lBOWAoCqtqPBISdpnOC7gWpQJSrb7GxOGH+u7BeCI23QJjnYUI0n705EX08TVldaHuOJT
	FD0e6kQy4Mcm5ZdkO4iL7YFjU9oFNCE=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789134211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qqONGiVmU3Y+JSEn4qygivSbxUuzyWx0IT02Btj63eI=;
	b=wxBb53JNy0vVTyl8/e3OeJ5WR8CWmZ0Xv8IaDTQJw6bqDsoPA2WQNNP9M8JAL0I+2LFPmz
	C3KOJIIzIKfLj9RK/ZbaTgw3Hr5yE9bZ82WKughaIVLSF0USwgzu/sS2y05j1mFctEj6uJ
	pDdRPCI5Kl561bzKaXkSs6SZ8eAAgDs=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-49b965570d7so11607485e9.0
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 06:43:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789134210; cv=none;
        d=google.com; s=arc-20260327;
        b=fdhHdoeLVvPVG9tNN35Qw1mXETSQmaInKQUFwV3pRojqYyOyqemItQg6o3R2yOeXrB
         fxLxoPD41HjUMPyL8znRz5pu2pIllX19D1n8sn9wao8+F78OqSqMwe3BOyY6hQgCfIO4
         xABterP6XaC03q/ex3B3pKszH9pZQGQsYezBsP5JqLwFhIvKU6pvF641tdq0fX7mj9Mn
         wIxSsE3mipXMlc+IfC/mfIrYrpUtQPGgU89GYlrg0ov0vJo5IeeeEg6WacrVu2qZ7JlK
         C/rclewWzcXOA5MiWD1TmLDZgihtxpfhXMA7HmeaGANjasinAzxyaG4S5BkTeEYxz/hP
         oc6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qqONGiVmU3Y+JSEn4qygivSbxUuzyWx0IT02Btj63eI=;
        fh=cyWUnBPa0mf0UH7Avij2qX/EefXm8XpCDY7QIEEudQk=;
        b=FDqqvqv9ak0EffXrR3Qb+MzH24GIXItUr7KwULzhv6/MWnYftjBzjYsqNmvqCjjf2U
         EzFfahueEmCQQG+oZj6tsTtpn7A0jy/wA5j+aoQYI7TGl7+5UiDby3d4CLwNAHqsYm2C
         tIeptfFNnbrBaHoUpGBKgoPD3Bq7xdN3DuIXwx2N8KYAro4zK84JE8dH09s7smwPXhsy
         8Otox7ETUqhgTHV4WNIOC5bE/rWNN8BiquTFM1rKyJ7fEMQyQHbUCQzd9d02n9HhLjzo
         h//3uBpnp1pQAu9UrcLuCrw7o4wA8McBpCVV/49IgL6vDleUMe6AbdTs+wRrHBdRsohw
         vQEg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789134210; x=1789739010; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qqONGiVmU3Y+JSEn4qygivSbxUuzyWx0IT02Btj63eI=;
        b=YO3yK/wgvN0nziaWbdSAobYir4UmYLfYRLcHguoh9Vt9fXbhW8R5wNNFvSIaHhxvsN
         1/Vv613bH26VeSwYeEaYw42mDjjSgIW1pyMp0plzTl7TK/DRAesj8bJhi72r44xEVC2z
         S1m6FdYtNCVzeLr66cgelu5SApktxXBPOk4j6uUKDLMV6Y1QAP2FTgUFCox/bXYvKGjx
         6daxdHXwYAd/A87CVn3xYkWl45ya2tsi5kZAu3/3xMasPRZdiD5N+yG8c/dV/mgrQBa7
         KbWlUsQ0j87OiT52+/n82hg5M2fr1kZ+UpIYs50sCUdNCfu/sv80nU483TYjjN2a+V0u
         a2kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789134210; x=1789739010;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qqONGiVmU3Y+JSEn4qygivSbxUuzyWx0IT02Btj63eI=;
        b=X8zrD/+BqhLjueW/8uhY7oREEZNxm0TAvUZW+05OmmMTKNgzd+5QD7S6jY8IXu1LdS
         3fT0ljm9www6/KVuHyb1H5CYA+kBlua1Z6NLPCMH+U2ICCbDt+wHwKE2ZmqEAEuNyIzL
         ZP3RUoRvV8YRzWRpbabKKeFKUswb6yNOLZIE+G+IN4a035MqVu0kYwXMoc/mFoPdeT63
         77dPxwL1WZEGBfx/Lt9dumsQECqbUI9A8TMv/5kaDTSfrtO5gDuS5Mqzy0+lPoLpA1fK
         GHcmFcciVfH/oBSjsOfeXZYbXufOeJM/gKHKepUsF9inVZGRn76qrDwVb83pM23B+Y1x
         ls6w==
X-Forwarded-Encrypted: i=1; AKwUvBwmGtIdqySgstNz5AUQ9ipToAVwfOlyf7mdVVB593geXb1osaJyI7lpeRbco20KFQ8hR//F+aEDUg==@kvack.org
X-Gm-Message-State: AFuF++l3YI3mZzP+DzGdDWhY3WZsRgzF+RP7iyOO6D+Qo/7/o+VrSVuG
	ub2DPkRZxXodZC2RIRY0tzUm5MtqII/bJSe7s/DrUIApPa4nWaa/aUfBMcaa53Pu0nvUiJRqcaO
	uA7skaKAj8mdbuXqjH5Sr9QD86935PcwK73c0YvPJ
X-Gm-Gg: AYBFou2iPyu63OWsyzlRv3eebllIMifnapAEYKDsKOaAYecbQDu9HTJJ16jQeMsVMdc
	NqqBAgV6/wxeCxrr2TsRTR6bx92Bn42aLF8Iy44iBqlfYJa63GQRao7FnWTVggi0LDp5bh1U+xO
	i2W/DJZ6elS/2lSSVAZtlhdXm7qWncAg9BuA/DGFjdChwNvj6NtYALJ7jbmqLfVlkddeTJf3lH/
	/v6V6nWmsdhhehL0e+ALgviqt5yCV2mkrimUmtIUF1tlTtV1xjT06IAsI90gLH9ZaNQ1aDtpTzk
	0GbreD0X5lM0vxlYY/DfeXmAwUN45GrZTsdnI8zwt7n4S1cKtGeQFNoIxN99Kv6pplyUE57h1jh
	Rb6s/Eu1CGvnPGaKcphTzsTt1kbBwSL6yGs1TPsCTs5z9tL4rc5sr
X-Received: by 2002:a05:600d:8445:10b0:49c:cf18:494e with SMTP id
 5b1f17b1804b1-49e6198a3b2mr36939915e9.12.1789134209249; Fri, 11 Sep 2026
 06:43:29 -0700 (PDT)
MIME-Version: 1.0
References: <20260910-unique-ref-v21-0-e83257373062@kernel.org> <20260910-unique-ref-v21-7-e83257373062@kernel.org>
In-Reply-To: <20260910-unique-ref-v21-7-e83257373062@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Fri, 11 Sep 2026 15:43:16 +0200
X-Gm-Features: AcwNN1UlYe5vy_4Ph8n7W5xph6nzuuUOW4o-tvYKznIiNAx0UgbfO_rFNfVUhuY
Message-ID: <CAH5fLghC2qRh8qNmMHMWQXiWW9FAPdd-O4z-O-17FFDB3hy=+A@mail.gmail.com>
Subject: Re: [PATCH v21 7/9] rust: page: convert to `AlwaysRefCounted`
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
	linux-pwm@vger.kernel.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 81E6380008
X-Stat-Signature: gerircr8kjinkthof1cotufzu5m776n7
X-Rspamd-Server: rspam01
X-HE-Tag: 1789134211-143603
X-HE-Meta: U2FsdGVkX1+6D/f+AJ2AA9uqgkC/tLYzLjBU/QMgou0Fmyqw1i54CKsmMNhzSCFDTbRi+Ff7CF2fn428YmD3nLihQ8BqNjonFVlwV1DkVUUMpL3H9dUcjLcJRnWXyQ8AvVYYEzP8twWtqYx1SOoX0mB0d8iUtXmTJpGWjp9LxkHLbkxF/Iux+t5dRNq6Qd1fDeqqz0u+47es2ZLTRGbocs0HkuRrmBw/7ZMPdIETAUBf5fq7oib6t68rLGRElWeLiRoW/iLOnx5V2vcHttRk0MFJ+p8YcE19Kd/rHXsMtTbOkEMQij2IUlRQQ/LZjfxu9D8/6wO64ixnXfOf2cm7DgF8FMeaIsp6oXZTyv+NytWqJDvowaZP+cs+lxs+NK3stQsffTh36HhEl95xwkpffbbFT7J/xn64bi2dwnFKZpHERMl8OSjQfrNCu8/FGPvup673iClx0uhKLaG6w1USYcGNz4SMQlW7vCvhEfhY1SEWOS2AkYbQyYCVKGXyfV3q1L3d5XoxnjiuoTA/oEpv8hO/7bQ8ZUamMsbbR7LBTmNRFZXNrWzKpoBC3ts+pxdYDHfO/865o6LJetvKFX+bT9dKV0MSdAXVRs4DzqUwc7G9IMJ8RfAGaz5mSaaGuBZZ1cp69z1zkbpcHwGi9hzonuYt5r24Z479Evyq9+/IvduvEVdOS1XEwzVE6QaqfNRbPU5Ub6v96GpUQCKuqWoYRBxiZXQSkaYv/7ikKt5epevAnnOEi34yaPVbSh2uWkKXR9LqFjBn8axNn5HcpF1SF/IjTbTu6gCpGpjMGeNyzXf64cGF5RdW7eNZrEcgw14Usfnwjf/mYvxeRkuM5t65scR7f2uSCrpdVCltv6VXI64CIqf/pZSm4xMMCQkSa0WdqXhH+DSZKVTjHM7rVq00psUEovLfICjmee7ckxuTT4B4Dmp0yxt+RP3Xlle9Yeu+31hBG326V3U2EcTXwGT
 wGUK4jRu
 oqBKXbWmS/rsBhE81ddRJzISf28LbaDVmX44GzGZq1b45M7OTuvnfcpK8untfM9ErzjD6FkHujGSeQ/DKl5HzjwGLhQlN7VW0OlocfxZlgQCDN0V466ehEwaYVvQ7QoIr1xKpFZFO/SJafwEmZ8UM84Sx+m+8hjThU5R0B57vhiRrzDWSCSNm1GK7C4uSUorqRUxiH8eZr6rqv1IZe/qlk2z9VGd+JClHDMoA/ItPDVKYGtexUT5zKB0jLDrUpjT2hx2VlLRMP6IRznRGsDzR7im3A1pRn8MMgnOiKnFWGQBdInpMxAZPqQf3A6NAMDSxWCV2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 11:01=E2=80=AFAM Andreas Hindborg <a.hindborg@kerne=
l.org> wrote:
>
> `struct page` is managed by a native reference count, and kernel C
> code routinely takes its own references to pages, for example when a
> page is inserted into a VMA with `vm_insert_page()`.
>
> Thus, implement `RefCounted` for `Page`, backed by `get_page()` and
> `put_page()`, mark it `AlwaysRefCounted`, and return `ARef<Page>` from
> `Page::alloc_page()`. The page is freed when the last reference to it is
> dropped; for the order-0 pages allocated here, this is equivalent to
> `__free_pages()`.
>
> This also allows `Page` references to be returned as borrowed
> references without owning the `struct page`. Remove `BorrowedPage`
> and update users to use `&Page` and `ARef<Page>`.
>
> Assisted-by: LLM
> Suggested-by: Alice Ryhl <aliceryhl@google.com>
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>

