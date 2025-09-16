Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC2E5CAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 22:16:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D8708E0005; Tue, 16 Sep 2025 18:16:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AF718E0001; Tue, 16 Sep 2025 18:16:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2ECAB8E0005; Tue, 16 Sep 2025 18:16:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1E92C8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 18:16:04 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9BAC911926C
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 22:16:03 +0000 (UTC)
X-FDA: 83896522206.20.67A768B
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf01.hostedemail.com (Postfix) with ESMTP id C12BB4000D
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 22:16:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zbt80VMX;
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758060961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XCBNi/ou5yRHx7+ah+D+ieL7ClLUcNgw9Fw0BKqDeFY=;
	b=PYnamCJABX5QlCiai4dLaSzY3miwuEe4hBXiTAmiinBySkvTYmkNPuJ1MQ3cRgCR/QaAlz
	rZJjLLo7mYHRaZ4qSTOmJW0bAzGkhTRAE8mCGkhE1eqcbq7y/KS4jdME9ronNpl/iZLe97
	w0cN0TQp0r+TKJ6V86xe5Uvf1B4lM/A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758060961; a=rsa-sha256;
	cv=none;
	b=24wV9W+jVgXnBotkePrpaqmL5BZqMgjm0xrCpP2x/8kC8HDn/gCD3KtnlzX4HkxQ9g/HcH
	Ce2J4LB7VorwXMZ1r0jOSWl77HA8ifSCVQwd9McoyB6yyovY2bLqvNJL2kMG4E9yMFWoQ1
	QU1vwGvc/XaJeeJfyqa9uuYPEwZokWQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zbt80VMX;
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4b796ff6d45so78531cf.1
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 15:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758060961; x=1758665761; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XCBNi/ou5yRHx7+ah+D+ieL7ClLUcNgw9Fw0BKqDeFY=;
        b=zbt80VMXtu4TIbJrhMFi6NWMqLLbYqdsYOzPkVvgVuk7Dq68be54h9GB8iV7xfSG4u
         SV4P6yRfEsm3bparOCOm7QzCP7hkODBcSSthoE6uV/u8WxvbRvhtHM7BInqiheNuP9jK
         TqTFeb9z1PP3s60HVaK8vFj8BowAjYKcJupuunMRjACoQXE+3HcAPIQRIcLLZHAzHSVq
         tP5I4ikK4e6ucXwt/YKbNdh+pMxpRNWe6VSqmI5LVPKz6bx5MFnmvjYwn2yibImooTa4
         cj4X1nv2Qxhiautgg/UtO/k3QlfVIxEdzcedD3UEsIdtbj387QfMZYz3FVBwT5IROhbc
         TLtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758060961; x=1758665761;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XCBNi/ou5yRHx7+ah+D+ieL7ClLUcNgw9Fw0BKqDeFY=;
        b=m3XOQ155vsFIMXmiOrHi2fuMMXKK0XEerKTcryZdIXVUiX/1kWN5QMSDzIz2YZsXDo
         wjYe4NwUvoihU8gIp5zeLEZIBR7d12XNJv7moi2y2E1GlBJMsQnCEjYd7R9lRo6VIstn
         ALid3RcZIEiuks9f3FU/O5mI6GH6V1Q9tyl//Lil0VjYKEKWp2ahBGRWzWr0vzJgvvZi
         s4ehwYdGLg3MwTPynNZbvUdpEFsWdBSvO01dd7XmOSbGedToU+9GfbJgfciAKVopqenE
         MVFHjRmie0/iBJKCAEu5cTVKl6mzMc0OC3C3DrQSDoPgnfGpICEFK71Epp9Bbl0XJBsa
         HRmw==
X-Forwarded-Encrypted: i=1; AJvYcCWLcvaQP8T8FrAtqc578gu9jmAlaPGiu7jJ7BcOoKn7HvRWdjHd+l484egmfIAUgQ0ZpQdP9Kx7+w==@kvack.org
X-Gm-Message-State: AOJu0YybZOngeSv9j7Jv8tMb5ts2Z4aTRPPIM1ZGRvQ8bHoAQRAq/700
	Lzp+kqx7z80tRg4PkZo0fcBg3i9sMLj6r/H7agR8pc5lC2moecBbpLN/x/VSa8GPrxA9k0yUZNX
	uMsBER/xBmBDzkfReh9nKp6snU3Wab/PMSo4UFZ6Q
X-Gm-Gg: ASbGncvPHjBQsefWmMqjWKUZ77fnmMhe4X+SqtenKlftaGgeaulpxHvaatll74E7A4t
	Xcvm4Zjp/6BjAvr7Jz0znZ/Ot6JkYcmtIV0UG3VYTulyXsukKAqUJQHfVpgv6rbyseHSlQi6MGJ
	PXDEqcjxy9m8fjA1tEUjGi21bxxu8IzRrrjqgioJ0HgY3bVbboPQEY6+S3oxcHhAqodQaTQ54Cu
	yBVqo0FbqylPo5dYgvCyByCakFH+EOWVV7BdKMCcSzA5gW5mzT33LCM0TFrXEY=
X-Google-Smtp-Source: AGHT+IFwZOxD9kLzPCB1lILJmI0xgkzuMmGn6adIQK8bdZ9yMIliCNXUh+Z4nqxF5q5gbdz8Rfginp11jxz6hV6K3Jo=
X-Received: by 2002:ac8:5d08:0:b0:4b7:9a9e:833f with SMTP id
 d75a77b69052e-4ba2e66f6d0mr969151cf.7.1758060960355; Tue, 16 Sep 2025
 15:16:00 -0700 (PDT)
MIME-Version: 1.0
References: <20250916160110.266190-1-surenb@google.com> <4c4e97c1-7f93-4c09-a235-ab169a998ef0@gmail.com>
In-Reply-To: <4c4e97c1-7f93-4c09-a235-ab169a998ef0@gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 16 Sep 2025 22:15:49 +0000
X-Gm-Features: AS18NWCPPfExsO_fHti7iMCfKkGoQVQGtNzFsTAs87brLA4n_LMr0i3QIz8xI9Q
Message-ID: <CAJuCfpFc=qUAnS=-YuW_CRgF6GUz-7_ZEMFEL-n+XY6MAr7ytg@mail.gmail.com>
Subject: Re: [PATCH 1/1] fixup: alloc_tag: mark inaccurate allocation counters
 in /proc/allocinfo output
To: Usama Arif <usamaarif642@gmail.com>
Cc: akpm@linux-foundation.org, kent.overstreet@linux.dev, vbabka@suse.cz, 
	hannes@cmpxchg.org, rientjes@google.com, roman.gushchin@linux.dev, 
	harry.yoo@oracle.com, shakeel.butt@linux.dev, 00107082@163.com, 
	pyyjason@gmail.com, pasha.tatashin@soleen.com, souravpanda@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C12BB4000D
X-Stat-Signature: ubfebh963egrnceyqnoiz9kxzyznyuhd
X-Rspam-User: 
X-HE-Tag: 1758060961-466446
X-HE-Meta: U2FsdGVkX19vwG37oK73EhVQXoHSLwY4BPgTbwHlsIb2XhIkLno3y/aY1vua4jsiyV1Ovdl36jPUKoZwKg3MrwV7LWrM+Q4x9j+aq58iXOTtqoVVe2ZRoEECp7YUzo5mPF+qA59hWYSE2QAzxdobMTOQIAKdz0jjFBPOThCJHKWjdODX1rcrY82gpTda7W9DQgwE7igPP109HKdMrMk4BE87R/Vn+meNCGLuPLffawWNL7slEEZfMH2UkubEfSnHMCbG8yvjVPR/NdW3zqlLMxaOlnYNwZxAVllW6Wl/ZJHy7BK92vt81bdp0FPkQfWJm6SXCUA0SqC2Do2thyZ/25ZRMBHc9QqsMwGKpkdgpqcjUE81ri/yh+Y3t7iytnoFJNpzzbKfsolTQILUCnNgQzYKndKE2NDM8dN8bQvKuwLec9W6lo67spa0GI+27zSCIG+YpZgisrx9Yth7mpF+fZnn5dgIiIxnR+WmLRgJmAffuYv0TJ59VIjiX9zfCayR5xKICeSy80Y4bAdkHhgRxNDu4ZbHWHS0HRUtc2FuqpGhpmdaQ8YYTMZ9No9x8ZmI+hYKQQN6tkRfGA4Cene0aG+m/vuY/ZXxkJI1tF69aLuu//8O3p1rYnOe9qLOTpbWevP0qEzMuAQT6L35LjTXVb4wRq931GpqB1B6Ex/1fAZoKtUaAHFqSTnJa2f3TdReGFbYJuvxXW/hZJjETx51nc+G2II+1gdRGes3bLASKeRPV+Jgs7XVdA/jFlVJjobaO6JtL5LNtJDmCJjwCmNw/vIZAjCH6qvrJUof9EpMM05uWRRfzjZmJCs7F8BaEjBaxk9irXYd3l0NPJy8a6nTBZjg1vZXptrjsOdywKdQ3pBJpd+kkmhatzMzl6BeYnfjspyVOueIxV9fqpuL4of5XJMvraQzRzseAhXbjb2YEe4vnmnOv8iEJjpollRm6W8dE5ja4gMjcCeQfmDANBT
 c/LhFKSd
 6faer3ZnGDkI30mIrP++t2DmE6nH3QzuD5m9uIEV8SvD47SWYX3kcE8U6UfROWY6a/bsRczXE0fRvVYyU0Iom0eAZl+54YIJUPxliOa+NspLDmX2QRLlgmwGMKZD5b5eT7iy2hd4i35wg8tpkyC07V9waaPXwMV1Py57jxBQgwPGcCSob09ZEkbdaPN7fKEyQux5KXC5Nl+mH2gjyzGh7GOLot6IObFWdBL1BFNOIlcBSMIoiuDulYtqfryNt4g7oUXgtoNz2zXVTi8sQXtSdSFYOuxBTYZYNU/iwXMNgErnBfYmbI+7yaYPynoNkQlxKXxq4fimNbcl20dsWp6pxhmnVQDJ/nYl0aez1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 8:50=E2=80=AFPM Usama Arif <usamaarif642@gmail.com>=
 wrote:
>
>
>
> On 16/09/2025 17:01, Suren Baghdasaryan wrote:
> > Document new "accurate:no" marker.
> >
> > Fixes: 39d117e04d15 ("alloc_tag: mark inaccurate allocation counters in=
 /proc/allocinfo output")
> > Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > ---
> > Based on mm-new
> >
> >  Documentation/filesystems/proc.rst | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> > diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesys=
tems/proc.rst
> > index 1776a06571c2..17668f82ff1c 100644
> > --- a/Documentation/filesystems/proc.rst
> > +++ b/Documentation/filesystems/proc.rst
> > @@ -1014,6 +1014,14 @@ If file version is 2.0 or higher then each line =
may contain additional
> >  For example if the counters are not accurate, the line will be appende=
d with
> >  "accurate:no" pair.
> >
> > +Supported markers in v2:
> > +accurate:no
> > +              Absolute values of the counters in this line are not
>
> s/values/value/ maybe? :)> +              accurate because of the failure=
 to allocate storage required

Maybe... English is not my first or second language, so I'm not really sure=
...

>
> s/storage required/memory/

I'm fine with the proposed changes. Andrew, if you agree with them,
could you please fold them in when you pick up this patch?

>
> > +              to track some of the allocations made at this location.
> > +              Deltas in these counters are accurate, therefore counter=
s
> > +              can be used to track allocation size and count changes.
> > +
>
> >  Example output.
> >
> >  ::
> >
> > base-commit: 199236646ffd82b5a5bcf2bca1579ea06cb0ae74
>

