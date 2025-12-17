Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 201BDD6554F
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 11:53:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69B396B0089; Wed, 17 Dec 2025 06:53:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 672756B008A; Wed, 17 Dec 2025 06:53:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59C826B008C; Wed, 17 Dec 2025 06:53:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4B7B26B0089
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 06:53:26 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EA5C4C0A5E
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 11:53:25 +0000 (UTC)
X-FDA: 84228802770.24.6C87717
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf27.hostedemail.com (Postfix) with ESMTP id E884340006
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 11:53:23 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OoNyCQ7M;
	spf=pass (imf27.hostedemail.com: domain of urezki@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765972404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7t6JuJAKEyX17GFUwC5uMv+PO6YCakZOGeDd49LaW4U=;
	b=EpI3EPOoZ80QKt1kXPG1RacLr2ac2tACw3/v+NYnnpDXPcYBb+21Pw8P8sbwaP4xLAoxjc
	n/d2U0iwGD4ArWZgTRqUs4jtJxolmjm+hQh4ltLsxgtdlsRjgzdyJTM7fiTHQCcHJXzgCP
	7O6FBWtxVOKfwkIgg9GRrBlYEwyfd7c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765972404; a=rsa-sha256;
	cv=none;
	b=I4hh+OkeT4VL8Ps8X+9HR9lCGUr0mieXGUjFUM73m97h0hANvbpxMKgEtThFDZuTcAZr3v
	bl2Usu5zPnmdTaxfL5pL+LtnnojGtPeK3xNd6hprxugsMn9EJBRR553Xd8dd5dapIJGq+K
	cIHScqeoH0ZaUX2quBWCXSpi011xunE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OoNyCQ7M;
	spf=pass (imf27.hostedemail.com: domain of urezki@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-47118259fd8so57003815e9.3
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 03:53:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765972402; x=1766577202; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7t6JuJAKEyX17GFUwC5uMv+PO6YCakZOGeDd49LaW4U=;
        b=OoNyCQ7Mmf/QqDgxu2d4GYi3D5QZr5/U+Karib33p8s8EEI/BDDQFjNa8GrgSXoS3b
         vv8tKGowpMOEqZFxYoiC6sUj1vok8y53qpvT5Ijphv+UzE3kC5L+I27Hn2pmjPJ06At+
         umYvEIZ1VBjR4tKUkJClbZkz3QgOtU2NaDzVdshTxXi3heTWa9IP8T8WLJRbhE7lJG8G
         BQScJyazcPGlrShFw3fOwFjcRgFyxNCWto3GmrVfgDzk3pXwp5rphcwCvbJGG76g0Glt
         PwpklAdJqzMyqYaCdT5MOR997rzUK7hs8x3rmV0IHGas6UpnJ9rwrMKg+WVF+WO892ix
         baJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765972402; x=1766577202;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7t6JuJAKEyX17GFUwC5uMv+PO6YCakZOGeDd49LaW4U=;
        b=Ap2mQZ0qEsqJudHwbieLQMPubUatHpTkRWBgP57bimUd3G7HD1JjdRtnIM2rj73lkB
         HX2UD3szL34JbwPPX/pQRWQfiui9e5k2fd82lUjTH532GODbqQzSDm5acEVrVT6+1oub
         9IwsgZNChdO0aRyRd75o4Cr3sczpUGamBZC/Uf6nJRX0h0ZuLs1KuEI3a0cqS6TBWNnM
         cWG3ihTmnY460VgQsOKMOQ17JGLXaq1qmzkuFvLFLSXPjFK79+IAOUHRyu6Umf2oe1ud
         Y8h5SJrG0QcstbTgB2ECQn0yhVZsM+Fm0hc+eph+ICGsWBwvoMEZV8moECMLw7rdiTuA
         Q08A==
X-Forwarded-Encrypted: i=1; AJvYcCUUsxmvU02ZAWn/C6xsq0HY/C6nBXJhCv4kjVfZt55lzhRtOY2uXrcCZBVZf5RWkbH9gzl4fGmo4g==@kvack.org
X-Gm-Message-State: AOJu0Yzpmk8J8a/9aZY7+F8psuck5oWQ4PL4ATJa77qdpZmjY98xDBhT
	1uROueIMMM8Q9crhEf1A9sFq0EoNWHBBkQhnhCIpsHisYlfNfOB+04djkMFXWVcwWGTL0vXYYzf
	oiBcHoDb6dtb5Y3KxvUjILSzGVL1PCWs=
X-Gm-Gg: AY/fxX4CPEia3JRO1lB2/5Yzc/ZXvkMYGYDmOU+jHPhrzl9cf6TsyJNTYmQxf5WXsy0
	HGr4EzanrNVEBrTSmqoKEfjG9OFbDXMWI9S201lpNQKwm2P4kK4om6t8M1qL/03j/puk3y5MhEm
	y6hUteMF+e9HC1llnWKa+axqgPx9IeLjhv8hoEbXBAYQjZFe4wQcmfOcrqkX7ib1fA6UAiji3pD
	io+QbxdhcQTPvhmUJj1q5SgGVzaGmal5w1+sIGqlGSEjqGBotNZlKTTaeTQrBnFiVf+eg8=
X-Google-Smtp-Source: AGHT+IFPEtX519ZTLQSXJiTgFXEb0OJw4iIIi/Tj16kJdH+kb4aEhtNuuhetN3F+Dy91Ljc+GFQ7VJKn7dMcol42Hwo=
X-Received: by 2002:a05:6000:2001:b0:430:f742:fbb4 with SMTP id
 ffacd0b85a97d-430f742fd2bmr12632027f8f.43.1765972402240; Wed, 17 Dec 2025
 03:53:22 -0800 (PST)
MIME-Version: 1.0
References: <20251216211921.1401147-1-urezki@gmail.com> <20251216211921.1401147-2-urezki@gmail.com>
 <aUIpciUKUeclNk2s@MiWiFi-R3L-srv> <aUKXs_3bxLyMvTgu@milan> <1329f4ad-5fe1-41e8-97f4-0b58caf86fce@arm.com>
In-Reply-To: <1329f4ad-5fe1-41e8-97f4-0b58caf86fce@arm.com>
From: Uladzislau Rezki <urezki@gmail.com>
Date: Wed, 17 Dec 2025 12:53:08 +0100
X-Gm-Features: AQt7F2pLy-LddkBes3ku9vN3z09sqcprn4YfAkMkZTU9C4j3jK80A8lbrh6UWjs
Message-ID: <CA+KHdyWezxoLH_HbJNYfXhSG0axdRpH5Ax9of8=g9zJwk0Z2TQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm/vmalloc: Add attempt_larger_order_alloc parameter
To: Dev Jain <dev.jain@arm.com>
Cc: Baoquan He <bhe@redhat.com>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Vishal Moola <vishal.moola@gmail.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: b3amu7hz75ugw8zs1qkh5bmf8ibuzpgh
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E884340006
X-Rspam-User: 
X-HE-Tag: 1765972403-906086
X-HE-Meta: U2FsdGVkX191kcahVfhGmaM9nwv5guMawKMMUNwVSBorsfQ/Bto7RRdeuJxuLSdXJXA4kWmuEQILjSQu27ngPwMqKKGUXQYoLi8m/SurxqFbpF49yBjDKg1+RM28NhIIH9usUEjepV5/rKF8YLVqwTMjpa0O/vkNm4P6QCiR/0yEJrRJ1TIDco6fbnh8XBHiIK/WmypVHH9Pit19tCq4a7L6S+GjnU0gG9jdu/aAIhkqaPd80mOUCC/WKFAEV8U7iqbH1WJzx5nEHEwrVo5BFKHIHUdaX/d5eYrC3A/Ht/eIAnJHVzbjCdPV5OWzBIQ4o2XocXCPb4bDeiSL1BjoZb6SZcRPrNMjbz4LdoysU63eptGRGzz4WM1GbW8lsU7k7iRIRrf97k9TdBxDuUmVighp0e/zAa6LzUpazkbB2me9mnWuHF5NECMujnXJhmPiVw86RfGo5rHS116/cCc03Pkq/lYeghESyE5PqV1vLlq1ASclhCWBWkmHiLp9cIh+3MWegN+LJY829v+roHEU6Uqa6SnOQ7RcA65vYdP9JCDrztgcxLk9i2AjJglwFJi9tkA7BrjKArsvrsoSNy3DegaPnnRvChJVAGYAT9sFsbgTlX6sZhWh4LHcF0T3S1F4MEoqn5umJxgltO6U7k1zS9aqnUdDLsRpC6Dy9X8U4vgYR+qIkNYuAz82owOn5qkeZZKzVJBqBWF0VoEO30xsIVisM6XkZbT+z3411xVxG62Nbm14SWhC601TsOpU5AvI13z3ojYDI00rBZdCRc0y+2R8nguBO+tuXOwy0uDk26NrYWNkx5knLRlSJlpgaS9GyXXjRY+VsM91jTs8okpgyVgfz0WC9ArlBDfQCyBmeCPAvyP8DGDAsTabT669+PGcMjdfu/J1QQc0sIcOfO2N66NwMOUpEtKeT8omcwFeGghA+o3Q89M8nkf6uo7Qdje4bjwM2ZRwp4Ckf7dvn9m
 J3sEYD+O
 xyUvsURjvB7eoG8PDOG4w4Lr/qnMOs03JPyBfC6LMz6e79mjmtv5Sq4yBeQuqltzk4vLpOsHZly5fjeGnhSAMd1j3ONN+x5bMizqyKE0T3+WECyU8q++8yEg9cbfj6hQrt2P53w1R+ZkWePMQkUQpP4NJajTeDnyh/uB95uAO4sMOby1h+JNA7AUZ/mByuYEe5KG9xLvqgoJrgA+PosItZvs4hvANKnioKOy6A++YcyH5dvkZQSV6VrCJSvtkllUBKzOAxYgbHBIcYZy5IewMdphEM0Xcfx1eZkhZGgd2dOIn0/+vbYNAlIougcmoF7nGHkDwjkRQlD6++dvBMr0qv/I7wzsxePOKNdsfYU2rAwC7BQM2dwSlk+rWEE78p2ltSiqaQR9KUia/hSaoNFauce5YmaIr9mg0H2oNwCQX5JHhOow5L7dg9DO27yDvPbwJdz2Jygh+mH5WMOA3F6roml6BuMARF1vpeBb2EdnHP9Gw7zeMx2f3hiWR+V5vI5zYbM7tWD4WBJrZKLNs2K2ZdiqSSg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello, Jain!

>> (btw, I had resent my RFC, in case you missed!)
I have not :) I saw that. Give me some time.

--
Uladzislau Rezki

On Wed, Dec 17, 2025 at 12:49=E2=80=AFPM Dev Jain <dev.jain@arm.com> wrote:
>
>
> On 17/12/25 5:14 pm, Uladzislau Rezki wrote:
> > On Wed, Dec 17, 2025 at 11:54:26AM +0800, Baoquan He wrote:
> >> Hi Uladzislau,
> >>
> >> On 12/16/25 at 10:19pm, Uladzislau Rezki (Sony) wrote:
> >>> Introduce a module parameter to enable or disable the large-order
> >>> allocation path in vmalloc. High-order allocations are disabled by
> >>> default so far, but users may explicitly enable them at runtime if
> >>> desired.
> >>>
> >>> High-order pages allocated for vmalloc are immediately split into
> >>> order-0 pages and later freed as order-0, which means they do not
> >>> feed the per-CPU page caches. As a result, high-order attempts tend
> >> I don't get why order-0 do not feed the PCP caches.
> >>
> > "they" -> high-order pages. I should improve it.
> >
> >>> to bypass the PCP fastpath and fall back to the buddy allocator that
> >>> can affect performance.
> >>>
> >>> However, when the PCP caches are empty, high-order allocations may
> >>> show better performance characteristics especially for larger
> >>> allocation requests.
> >> And when PCP is empty, high-order alloc show better performance. Could
> >> you please help elaborate a little more about them? Thanks.
> >>
> > This is what i/we measured. See below example:
> >
> > # default order-3
> > Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 l=
oops: 1000000 avg: 3718592 usec
> > Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 l=
oops: 1000000 avg: 3740495 usec
> > Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 l=
oops: 1000000 avg: 3737213 usec
> > Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 l=
oops: 1000000 avg: 3740765 usec
> >
> > # patch order-3
> > Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 l=
oops: 1000000 avg: 3350391 usec
> > Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 l=
oops: 1000000 avg: 3374568 usec
> > Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 l=
oops: 1000000 avg: 3286374 usec
> > Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 l=
oops: 1000000 avg: 3261335 usec
> >
> > why higher-order wins, i think it is less cyclesto get one big chunk fr=
om the
> > buddy instead of looping and pick one by one.
>
> I have the same observation that getting a higher-order chunk is faster t=
han bulk allocating basepages.
> (btw, I had resent my RFC, in case you missed!)
>
> >
> > --
> > Uladzislau Rezki



--=20
Uladzislau Rezki

