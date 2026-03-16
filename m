Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 328A9F46441
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 10:01:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6088B6B0173; Mon, 16 Mar 2026 06:01:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B33C6B0174; Mon, 16 Mar 2026 06:01:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C8FF6B0175; Mon, 16 Mar 2026 06:01:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3C2216B0173
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:01:41 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C789314016D
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:01:40 +0000 (UTC)
X-FDA: 84551484360.13.0493109
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf19.hostedemail.com (Postfix) with ESMTP id D623F1A0014
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:01:38 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=flSKNOyy;
	spf=pass (imf19.hostedemail.com: domain of 3ANW3aQkKCN09KHBDQXGKFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3ANW3aQkKCN09KHBDQXGKFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773655298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WlcqbF6Fi0ANmT9UrxWcGsAHJorJqkrv5GS5junUEeE=;
	b=redFu6PSE878XjG6I1b1g+CIzjklewdmzYtMoPmUVBOzXu+Demn2VYb49Agbvir3QFkpZk
	lMd0FAbOSWsdfVT3nR6b7PO8ytXxdphDJUQjLexDjbiW/7sjjKLTj0FTcuvfNUSIh5oDvV
	fQnD3QSKpDCnMaOobwg3O5OMRB9SX1Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773655298; a=rsa-sha256;
	cv=none;
	b=iUlJqRRTarGYz6jLyElMkuqq+iy5q6rKyKOljmF5RBLVIqtpQZF1Itf+4XXh/BGLjjP9mz
	vtYCH9lHqN/9Wa5Rjulg+WbixAfj+H2zkjQaSDfnjusHk/7505HthQBMucU1HC/GPKkBfd
	0Z77cw4ZzbkfglGlX0D0UjYcfJJ/CZQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=flSKNOyy;
	spf=pass (imf19.hostedemail.com: domain of 3ANW3aQkKCN09KHBDQXGKFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3ANW3aQkKCN09KHBDQXGKFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4853466655dso41889065e9.3
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 03:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773655297; x=1774260097; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WlcqbF6Fi0ANmT9UrxWcGsAHJorJqkrv5GS5junUEeE=;
        b=flSKNOyy4lfued18lxuPwmKqfunrk3ni/EhTnxgfENIv6hNUlbV4n3p9GAW+kpFAYv
         +M8r22GGdES5THuHVtYXQvy88GDbCvIPtAjgOmDPpSP1R1sPrh27QOCI1a2rSDOBqK0G
         mUNAWe8pwUOXWbi7iiSeP0FuG2JvtI+9cGBXY1X0uS/0XSN4+aEnbjbIn9WGdBJHI8q5
         oOibG4p1ZZ9HK9XF0VmDO4jOk9jKAlxqLj72dv9pTxEdM2nUqVCQ0ccDt39IGwW/IrUu
         BGzHHFATIDQqHdddua+DA0XPAZBQ0N84HRgUH1IZDsCssbaRrPeCBJvpHKew1tIa2AwB
         jl2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773655297; x=1774260097;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WlcqbF6Fi0ANmT9UrxWcGsAHJorJqkrv5GS5junUEeE=;
        b=RjAkL6O5vOQ0N+IiavUHDu2OO1YV+896k4KNkjAmxQAN6n2zaWmfykQIh3O20V073b
         bFYRpuCZhMhve2L1FxrAjRwF2sK3LPPKBNirzEYmLvRx/SswssEwk5+WwWPRErUQtKlC
         LnWY2Hw62KJmzRTGdX7uWE0UrqJ3UhmNb7yHIAnlJCJ+rvFa470BKvohLTWZwgY/yCKk
         E76UO/lMNkmEeqvLvthmTwx7Wp6/RqcIXTvP+HrCZtWM1YNsBMuRqDUWfk6tV3aMrynO
         9pHy4HO5zmjkzGYeCZ6b6kk1nQ5K7yMjDtWQzkPMfC5gezxdr4Nw6+jCCCZwoQ1cG+RO
         bFrQ==
X-Forwarded-Encrypted: i=1; AJvYcCWlqcH00ErstH/JAZGhIcGlBITgYHgxjACxNtjqFzOF4AhvUyPNomMyMb3PzJoQfsat2EJJXKtuFQ==@kvack.org
X-Gm-Message-State: AOJu0YxNR9gOZwesjNsJc7IX+OiepIjcDuEazE37GbAapDRoByjvo1Z2
	XRC38mFlO3IwXNQ2pPZIWQ7OSNFxG8Xa9TLrG6/DimIbBxkT2ALlMscj5LHjgr5akWPpUxCYgO+
	el4+S9QPm+NoG69yhhg==
X-Received: from wmim11.prod.google.com ([2002:a7b:cb8b:0:b0:483:5126:2240])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a39a:b0:485:3b00:f93b with SMTP id 5b1f17b1804b1-48556728b5emr152715195e9.31.1773655296989;
 Mon, 16 Mar 2026 03:01:36 -0700 (PDT)
Date: Mon, 16 Mar 2026 10:01:34 +0000
In-Reply-To: <20260216-rnull-v6-19-rc5-send-v1-5-de9a7af4b469@kernel.org>
Mime-Version: 1.0
References: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org> <20260216-rnull-v6-19-rc5-send-v1-5-de9a7af4b469@kernel.org>
Message-ID: <abfU_itQLa4jDy5L@google.com>
Subject: Re: [PATCH 05/79] block: rust: change `queue_rq` request type to `Owned`
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
X-Stat-Signature: kuk1mxg73hfcm6b6hinin93fjndc8hig
X-Rspamd-Queue-Id: D623F1A0014
X-Rspamd-Server: rspam03
X-HE-Tag: 1773655298-598875
X-HE-Meta: U2FsdGVkX1/3IWnviSFrCUV1qBBFuJPPMD9riZXjqq5qCxtDgI97ibSLAI8CRA59i001CzKxwrVhUgnqexXZugZV41teaku0fEYHg5kmOyqGaAEO0hHiM8zE7I4KnOtz6S/y1c55uQrkN/YR2+EZ5HMJH1K5nSNslLoFeRCkAUdQ66vbSsUvVTDC6DNQVIxsEUof3A9to34SLp0z7Am7k8wf9vZfYYL4UMHeNgeusk4XubSiyuWGNFIMC0t+hEXYPZlYUJWMK+M/Ix5njjt83Mw2XhaUSuZAF6kjrcSvzocdlNH10TVkiRUzJXoi8paGjpmoPCqDF4mMA/OFGBd9xyO6ZofLGBlW67nLzaZNl8oSzhn+a7aNtuZWAM77eKQNrsJ3UChtIyGcJC1Hxtz/xvw28DDlgrYDTNPKJ2QnRHAstwrrCkROe+2uakMFlOD1X1QXTfiUtgl0FtqsJz7iUXg3fJm45jusGrErelKjmYm5Q/5jjh9PBoPsbhH59ahiTFcIuSFMpQC98A8qTynDKZDpNG/jgSL1Q/2ad8QFGdVi9pvckgoBGbfKqKwQagNzo6SPh5IV8mEzHce6ccyz28+iIcGrKa3DSzMhBK8Za+ETqkGAvIhCYH08I9pSQSFghg3Oqw89W6SShoVFogQEIRQiCyz5P2SLylydj86iWgSLXaTiTSwAdCiqmLUoC4M+rDVR9/Qh8HaztbimR/ZO96VDWYF7OWs162p3J5WPZP5DeVjILv7mVXH6Ud0cZi89p34gzA/sKlgQ6mcPsAnIcHt8yO5vtdaqmoZLEMSJ3uPkjhjGMUZrxCPpXbcXlgTqmKlrlm9Hi9FBAQUw/9Pf7imYkE9y8biifDSBlrhj8qjKRK/9H2LMzbuIyz/E+Nckc5zSo0f2tI5C8ToH+vl8iIfEogKH29xQSUj1Aq500H3v7GiCxbtHCUQn8uDBpKFqteqhd8EhahHS9GQ+FKU
 0IDDU4KV
 75Nnd2qGcLehGynUz+xBK+fcGIAqix/9buobbiYKpsh+kldMxlzzJdFOaOAmFR3y4aVCBWBEf7EeF6py1VGSRJWH7R+c4+Zds2+aNw+YX/utkyhpCzX9GZKDYA4oHyhoUbMOmG2ozCnt8GJJ27QxGTWz9E4h2k9OMumWFLSgYW6qkXxeDLg7Dln44QzP9DfvcC9ZM6hMhqoAKm/M6cjmozDIgfEC29tfK84l24RzakxU7MP5JhaM/dGMVm3FYFwfs+RHMid85T5YZMVO96gTlHlzERieQBYmy28uKLwbs2nYeS+dT5FoOhN17VYirlvw5zGnMHvuBQP58gGsgxaG/jIyMxmS5NPD35HDRMslQ3KTb++YYIW3QrE0EWS8Cekbhd/wM1b1PIYRElFm9d7s8okj7V76RzwSKWQA/AmeY0AyKNB2ZQKX+fbeXqnEn6n8al6lGKb7GYb+VSBwLn/htgNnY1uhPYzvhGrrr5pwdh7YIfpwiDL0wL1CoywJJ1Untbi+Xsa70zaX7XSYjRMZXOZN5hnjmUe2D2Jecoe3Vjwdxd1h/crsgk1geVxoZFrY9Rrbskej4zlcuQ6Cg/oUbfV1oOe/52l2bdTdievRJK61jdpRlCHEe4XdANy1uhKuyQ8QSeUAFcPLbJ/nerBJbrQBLTzOXIdks82jjdRiTPVfF1VqETOL1jnEW74brbv/TBQurXg1tcAM00IocDu5ExkJTzEJLosh+RDqeL+ZkZVmwArrAmfdpRndZ8Rixc/2CLhxY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 12:34:52AM +0100, Andreas Hindborg wrote:
> Simplify the reference counting scheme for `Request` from 4 states to 3
> states. This is achieved by coalescing the zero state between block layer
> owned and uniquely owned by driver.
> 
> Implement `Ownable` for `Request` and deliver `Request` to drivers as
> `Owned<Request>`. In this process:
> 
>  - Move uniqueness assertions out of `rnull` as these are now guaranteed by
>    the `Owned` type.
>  - Move `start_unchecked`, `try_set_end` and `end_ok` from `Request` to
>    `Owned<Request>`, relying on type invariant for uniqueness.
> 
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>

It would be a lot cleaner if we could implement HrTimerPointer for
Owned<Request> and entirely get rid of the refcount in request so we
don't need ARef<Request> at all.

Is there a reason we *need* ARef here?

Alice

