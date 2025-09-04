Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF6F0CA1015
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 20:38:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 199A98E0013; Thu,  4 Sep 2025 16:38:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 148EB8E0006; Thu,  4 Sep 2025 16:38:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 037928E0013; Thu,  4 Sep 2025 16:38:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E664D8E0006
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 16:38:05 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9FD491603A4
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 20:38:05 +0000 (UTC)
X-FDA: 83852729730.14.49596E9
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf06.hostedemail.com (Postfix) with ESMTP id BEBC8180015
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 20:38:03 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lAGyKmzp;
	spf=pass (imf06.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757018283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jhh00s7ip+FeDC7Nh2hWPnkefeUX3xcGprPGO9tNdd8=;
	b=gOgYGkNGqBFgk4zPEJ0BwqvV5NkMRiIcnkJz4NKf7J4MweeittpACMnT/nTmpsvCEEYqQ7
	oahaCCGnZcC8kKPfTAEXy1B9jrREYFCQuIT1XWYxNHdQlhp5RMYova6DpaFoXb290TP4DB
	Z7EzRzX9RuuKR8lUfT5UZzpO0pKKLFg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757018283; a=rsa-sha256;
	cv=none;
	b=Y0/UGqs9b6GnB73fuPy94AxL8c30hvnirBnUGJMaBH94Wargwml1N8K38NWlQ8OZ9LfWCq
	toK4Im3Q12q0uff19wjukUoKQHTCuwTX+F4ZqeVpax2CO3FQh+8APCBJwmAw5N8/nsXUK0
	93BAucYG6jAH1avyOFvVAgAZ9icapfo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lAGyKmzp;
	spf=pass (imf06.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-24b1331cb98so1855345ad.2
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 13:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757018283; x=1757623083; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jhh00s7ip+FeDC7Nh2hWPnkefeUX3xcGprPGO9tNdd8=;
        b=lAGyKmzpadI9bdfLR5Ft+a94A9GtMzcCBOOs0KXPfTihR5ZTnWtkl9vhuol4eCS+rZ
         7K+aiz+hR8MJ9cZPLpVv7S2Ml6D3Jt2xMPtDyrLGCT3rlVz3tAhI4kJVCJHiZ1N644U7
         mDTUtmAoy5dJMkcYsRwyiQ/Q1lb9DYA9bAh+rnExykEg/gw2YME6Gl1wzUpIbDsgeBlZ
         8eMw/LEkx007lYvCMH9GZVGMcVEV5qPyXdYwZS/6qmMg2zJo1d/3U89/fcjRBndtK0m9
         bcMbxOhaxyHUDZfv8RwFueZW1BB8mHVGhiMCOUUfT1Hl+a1kJi1Y0zmCqE0y0AhWP73n
         cTJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757018283; x=1757623083;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jhh00s7ip+FeDC7Nh2hWPnkefeUX3xcGprPGO9tNdd8=;
        b=cmyNMljXJPVAi4CCYkc1mUHn1ONp0YwkVgjaoPo0LBvh9APmCo4Blgskzj99AyJtsU
         4LT49uwBMDxe6twGZDxP5yH9ymSikjHBxuWLh9dZfA06LazTyTKDV3eIfyOLKugtiL7H
         TPXs/A1dx+vdeN9KZeFWaMngBP7thXV6KIWYQKmtyrDsR8hP6S5P763+cWcZyWd5L7SF
         H7R6ZV+HA8QIL2ChY9Q5Zs53gqpR/nUd4UZNspZ24OzqAtGN90glp8BXcSqOetWv3vSY
         hgpIfT9hhfyTlK6B3/aT8EqCf33FdOs554hB6GzpEongoBNWWqlhzvHaJCtxe1lWSWU/
         6ItQ==
X-Forwarded-Encrypted: i=1; AJvYcCVI0ZTCesIuraa6OB9RzIdk40qMZ3OY8ZVfH9vzVeGJZm21O4kF3spguVaMoVRXWUPYjjeY9CT1LQ==@kvack.org
X-Gm-Message-State: AOJu0YyOPBw1Zp7gSg+2g3KU639b1d9x8Olds6/y0MyaAbvP7WkutMRR
	pNS8llbBNPr7B2EsJejqsjacnvJNCsSH7x58dYU34+G4sOSp9/8MsWJPoCUZ928do/8XjB6yZgt
	nC69q6XUKrnAKJ7FxgztcN1IofXEy/is=
X-Gm-Gg: ASbGncsibhxJgCBadTZ7aLUiZy4KwnY61harQsTeRv7CK7kdz1KAVkbDQk4Yy7mNT6x
	txdeMBzEVkXCRsq2as5PJTPLR23BhuRede2/Dd8IAhJUHAW0kqJX92Haoh92yW6agy8uc4KSUMW
	7YJQkezTEfGw7fj8wLs2v6MRxgkp+jkjdprmP53obg1tsmUYlcBO7leFjaqTaWuse1Fujd2i+y4
	OzFQzzvA7B49HUgQ9+CoclL+zUz+I6O5Rj+dzMDXvRgSrpmeRMX5YH4VwbFzqpIO+d5/NGEtPlk
	jRuXXXuJ8gbLz/DzbAD5F1czcXJkA3vP3mT+
X-Google-Smtp-Source: AGHT+IFqx1GUCyWqYDe3BDuJ5rH+p0E80yA7Xljhs0Nix5yrCExt8EgPQzOmi9EaBsIyNxC+TxydT7c2/DwA9G8pP1g=
X-Received: by 2002:a17:90b:2250:b0:32b:aed4:aa1a with SMTP id
 98e67ed59e1d1-32baed4ade9mr1371213a91.4.1757018282507; Thu, 04 Sep 2025
 13:38:02 -0700 (PDT)
MIME-Version: 1.0
References: <20250828-rust-percpu-v3-0-4dd92e1e7904@gmail.com>
 <20250828-rust-percpu-v3-5-4dd92e1e7904@gmail.com> <CANiq72nnWmzOfZ1PhSid4t_e-yWEgi_hVx5Uj4hrB9wzpuP6nA@mail.gmail.com>
 <68b9f3d6.050a0220.174510.28d9@mx.google.com>
In-Reply-To: <68b9f3d6.050a0220.174510.28d9@mx.google.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 4 Sep 2025 22:37:48 +0200
X-Gm-Features: Ac12FXx-tTsNVn2EwIk9LpKY3_SwIwSIlYHTvNwAjGyhRpyARFyh2FmCJDKByuI
Message-ID: <CANiq72nkZ0F1_YUfBg_y=JcEMnQW+uVr9v4BXONUJdor3ZJzgA@mail.gmail.com>
Subject: Re: [PATCH v3 5/7] rust: percpu: Support non-zeroable types for DynamicPerCpu
To: Mitchell Levy <levymitchell0@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Andrew Morton <akpm@linux-foundation.org>, 
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, 
	Danilo Krummrich <dakr@kernel.org>, Benno Lossin <lossin@kernel.org>, Yury Norov <yury.norov@gmail.com>, 
	Viresh Kumar <viresh.kumar@linaro.org>, Tyler Hicks <code@tyhicks.com>, linux-kernel@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BEBC8180015
X-Stat-Signature: w3qm3ifno1u9jzg7m5jzggyp6qrahaxr
X-HE-Tag: 1757018283-714581
X-HE-Meta: U2FsdGVkX191vHhQSz8xJnCTHdHBYqjzp194eHI7fcNAiJj3twUrvGpnjKAt8+8Xl3vsbnpQgx7aYISn/rpYeFMdPOEzLWUM9XNSR+DG6gY2gcbrraOyItmseAhYvoR68OvnHERnMBF3phVqOql9cXK+qG0nEH+PQTVVwvN8h4/NzCPCGximB09tEinO6uK+U+0VU6CJYbO/1lKf+zmbcj5rPiTUXBzKIIEioJI5NYMZRmSf5gjnFY7FnJh7/k+2hqA5COw6pWpabBo9bIuo1pmGiMfe4S4vuWCKF1Y+fybDerBs0mpR4Ub199tsx4wPSUSmBjYXOMsnsl2cqjFn2Uiel6yjfHEgL6ba7lUTchr5ljjwvig0Z8uHG2sEDYWLR44FAw314mTXu9GcwvH+3WaOJU4n/hHN7zpYFRef8DQZHY1uuvRDacmKKMzpXdlI4wGSLY5YHl92QteMyfqmE5n75Vzv7KfhMKHXLKkD7jAnvdJjimEa6mPNupl2HEuIdm9uaJ9241r3wMltm1vmL9KBIndzeR/wuwe4R5MUIQKj4NAHeNDa8QEw8fbEiSpCL7laYeDCLB/XtbCOMaSPcddLmYw2uyEC1wkaD1MfGkGm0nF24ZI6qCHHPJB3QJvE/YHe/kkljptLFi71RBQfgb9yLXZtkRntYYUPsBH221zOQqli9nXtu38aIEV2duv8kWPVVtIdNDdlUQa1kawb/zjGa2g1ogjInHvTUXyIbBwUPMtFtu8LsRi1onwoWqcgwxJCKYU7YTwPbjq5O3ULeN/gIpFZ6fmXjT2VKI+KgSlR84XQxaL6LorFq9jXQG/zG0Et70hPfSvPx46I4dT3k/E76SvtfB1ixms3WuXwbt8MjKGYd2vMf6V8ogMDYE//QCiy9G/Jm7rxXRzQ7HA4w80k1wNUAEgfvbUqzp4ewHU2+LjAAk/HAdzBjM+rTVuDLzOh+xktcFYszUh3sSC
 h0VvH8Ei
 TCBZldj3zw/b4M4ZpZT1DiF9SI46CJoF7whP9kPUiBwPCetWYlAYNjezP1g2DGP+W0EJjnHLCt26odUluNtPtABmE6UZgvuBsDJtCgYWYf9ocXBvfNH5KtWUAv8aVsfVd5PguKYcD8ZIZm2/SGEszPvM2zifE1NNvbrwWKp50rkejyzFnSZAxCcMEsieEUV8e0HVeeBPuUBBH88fwXi1Zn7If6ZZAGJlAOhDKD6xoSxvkJF6usKThg/zJpP7jvAmQ8yRmPxlO/JWbWWkVXc40NpN8YTwf+TBHSTzuZlR2t/SH8KORdyNHBaMMHLR3GWA+9k8X941Pp8pwqcTYSzwdZk3Ojh3E2sL6TQGR1FOHJYC0TaJXtRSFVWDJ5vFBNZ1siQ8bXN+s+ysGQ7ed7SPfc7adTHg3VVI7/3wKeSxze5EQZzJeRVu5Jz49WJqCJTaB35sMpyswar6bIylMeeC1orATTesolLhZk0fA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 4, 2025 at 10:17=E2=80=AFPM Mitchell Levy <levymitchell0@gmail.=
com> wrote:
>
> Will do.

By the way, sorry -- just to clarify, I didn't mean to remove
anything, but rather split it (likely at the first full stop).

> Yes, this is true; strictly speaking, calling this function without
> dereferencing the returned pointer is always safe. I suppose I find i
t> clearer that, when a function has preconditions that are necessary for
> it to return a valid pointer, the "safe-ness" has more to do with the
> functions preconditions than the act of dereferencing the pointer.

In that case, I would make it safe -- we don't use safety
preconditions to mark "dangerous" operations, so to speak.

> In this case, the pointer shouldn't be going very far, but I think this
> logic applies especially well in cases where pointers might be getting
> stored away for later (and so the validity of the dereference later on
> might rely on non-local conditions).

But that applies to any returned raw pointer, no?

> This flows from the first requirement (that `self` is a live allocation,
> which is necessary for `per_cpu_ptr` to return a valid pointer). Though,
> as above, simply possessing this pointer isn't UB, so it's arguable that
> any call to `per_cpu_ptr` (on x86 at least, I'm not sure how it's
> implemented on other arches) is always safe. Regardless, I agree this
> comment should be more clear (even if the function is safe, it's
> probably worth noting why the pointer returned is valid when the
> function preconditions are met); will fix.

Sounds good, thanks!

If you have cases you think other architectures may have different
requirements, and you think it is likely one could enable the support
for other arches and break it, then I would suggest adding a comment
about it.

Or, ideally, try to see if other architectures are fine already, even
if you still don't enable the code in other arches.

Cheers,
Miguel

