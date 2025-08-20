Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CD7ECA0EEB
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 01:34:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F96C8E0018; Tue, 19 Aug 2025 21:34:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9835E8E0011; Tue, 19 Aug 2025 21:34:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 823E08E0018; Tue, 19 Aug 2025 21:34:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 674AE8E0011
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 21:34:15 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3123082F1D
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:34:15 +0000 (UTC)
X-FDA: 83795415270.01.FC27116
Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com [209.85.217.46])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5282F1C000E
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:34:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NW4T5J4l;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.217.46 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755653653; a=rsa-sha256;
	cv=none;
	b=eIwxjmQIkZc+HRVdNqT0WlX2+2BuXT7GvUWNjtIgK91xp3nGAg5yPJGlB5qZovltM3Oajx
	fTQa/QhUixOSWiGWK0zGWiHUR+whcc7vHlMtE3v6MeDN4rAZNu7YP2Dj+XXuRnGpzB5rH+
	kchluO1d1TWqVCCbrVPVyORpscCEezI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NW4T5J4l;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.217.46 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755653653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/s5KX22ZKNy20GSmoKGpSXm9KhZqzsJchYB2SFtI2Tk=;
	b=bkfu/P6mP8JZ75zwZKf1G41Z+4l4U9OceSvzSSCvBOV7jNbAws92+sMeSoP9MpBNOr9GxK
	xqkmfkWFXKJMuWjfFv7+/1H2q94pTB2C4fpvnBpw6QK+PMfzPL91ohOnL7fPtwD5l6ey1k
	Rq9E3zw7uwLqASxXkHxFQ41PGDk66uU=
Received: by mail-vs1-f46.google.com with SMTP id ada2fe7eead31-50f8bd52e06so1896409137.3
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 18:34:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755653652; x=1756258452; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/s5KX22ZKNy20GSmoKGpSXm9KhZqzsJchYB2SFtI2Tk=;
        b=NW4T5J4lAAKUqBIT6RgsSFFBYX3SekiP4xjtEGQwg7MRvoibhdbmqCg/NG+Ac5dA1Z
         7f6zl5G0vJ2/kFfLhsfnYvWhHK1//Gno8W2+hSTO6swCFTj1ANSegExtIWPjeN3NB4/L
         M5Qg5aH6/gOeZcb/1T6DOQcm+ayTORe9qYV0rFHoKi3/+Wq5cAnE/jfE4SdagcOO2D4H
         gWtgVKQ/flNTSVAI4BLPVSE2hDdWZM5GWOIf0HuW9ojwEtPYy0GF4j2ACUnGDPaGHnL5
         Muecxr8STAM/GDm25XqUCtXZREApWUvdIRnhNSaxGW2vqNCHyAF2sxU7y5DBP7F6OLn1
         0q+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755653652; x=1756258452;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/s5KX22ZKNy20GSmoKGpSXm9KhZqzsJchYB2SFtI2Tk=;
        b=qMgnuBHrMnmmy/FVwFp29BQkjhcB1RgV1QNjgJAfBA5ZtAKE5143QAc0aM+uOXyqf1
         6bQimnfFSZ16iTx1+AKaR6+xGfQVJIB/MbAjr9JdbvZVrSGEhkVJ8nFEmu1ef127OX+V
         uxiDHk2wuNHDoGOXnIZf4oNElS00ug+m907zeDK+ssjlPwNlrg8U7gTKCzm93AKFa0zO
         zvt55ZO1B79GuW/B5stQ1usTHl1urhRMQFiy2DoT6JTF+r/WRIKHIWSXMZLkZqK/faVb
         DsS7L9qiH9fVT2/72tkSePjeV2l/oWM+qvj6/reP6ThGprA1bHqKt03Hr7c27oq4F1ye
         7sUQ==
X-Forwarded-Encrypted: i=1; AJvYcCUcWnp+9EAglFmEM72XaA72oLEIfsiXl73v1xdn9ALwAxq9nUxrK/LITINjIypcR7r5XGQET2WJ1g==@kvack.org
X-Gm-Message-State: AOJu0YzoYdO1VJyVukF7PZWVv/f7mgEfVN3EHVx0/OvU+JF3xTsLMBUH
	3SP6iiQxOymOjUUVHjuB7XnPRUdxk8DtZjeZ3UTX7l6zBQTMZzQOEAfax5akjhKc59WN/INZaVs
	7GeHXk1BeHsSktGw46zjk5ROwFuFFEh8=
X-Gm-Gg: ASbGncvYBwq2I3ZFyQ+ivjmyGTjS9vhsh82fpiao6Sqh5G1yfEc1tXxo6kHq03Ytedy
	cCh5J9qhhSG/iXnJsBxeQVRn/zTLrM1d9OyOI8HJEImZYtTU7Mzu+4N3CDaWjL4A54bVZ6mQS+W
	hJZV70pabQ3tql4SGuTLNESbjosML0uXpyvGwiZ5jlZU2yKysvS1L3Q4F/6Q0f7Z/e1hE52th6Z
	fkJXDs=
X-Google-Smtp-Source: AGHT+IH59QaYj8PVrLGYbCpuZBJCiG+vGOmEnEJInZ9CVrWnoyUY0LLSgv3CRoTWrZz6siUk73RTGOz9uGXGYGQdrMc=
X-Received: by 2002:a05:6102:32d0:b0:519:534a:6c27 with SMTP id
 ada2fe7eead31-51a517c8469mr357736137.29.1755653652254; Tue, 19 Aug 2025
 18:34:12 -0700 (PDT)
MIME-Version: 1.0
References: <20250819193404.46680-1-sj@kernel.org> <CAGsJ_4ygTv1tCJeuF43NhRR4E0kiMLpk6i8c+UHoUMt6LXykww@mail.gmail.com>
 <aKUi7hvcaK0h0oMg@gondor.apana.org.au>
In-Reply-To: <aKUi7hvcaK0h0oMg@gondor.apana.org.au>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 20 Aug 2025 13:34:01 +1200
X-Gm-Features: Ac12FXyBMXRrPseaIunZh_CzIXyD525pwtM5WkB6blbfzShRnBs13xkgDqjTZ-8
Message-ID: <CAGsJ_4z6YvQULrEmNjFjLNrJ4RK6w0+d9uF2-7v06gOYirrYRw@mail.gmail.com>
Subject: Re: [PATCH v4] mm/zswap: store <PAGE_SIZE compression failed page as-is
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: SeongJae Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, kernel-team@meta.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Takero Funaki <flintglass@gmail.com>, David Hildenbrand <david@redhat.com>, Baoquan He <bhe@redhat.com>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 5282F1C000E
X-Stat-Signature: x93jwsrsr9ka76datu1rs7exjpj4fozr
X-HE-Tag: 1755653653-581953
X-HE-Meta: U2FsdGVkX18QM6uFuUMDG9h7KFdw6rv0nBjKILDr0iQ/99QiUFzRFjSy5jrNn7c5Co/4QzyeFS/eNcRWJElj3uzZdTJTXfUU/JTMWtUSP4r8N7h9Mo6eLYNRMt9684z55mH1DDTeNWlLmTfppUYC9oyuoIE0kNy33Y2zN3z5tg4DQItOJTj7z4Nv0G4FP/tmwUUDlSfEa9tIBgKn0Tl5g80EXAuW8j/Bk3Oembhk8CrhSLoLnZHHt4wAtTDMe+ug0xWeKQ4Y7jfW4FYcpLfcExYTsYvmuzmFK/YKFHP/bwWPwAuASyK/LapGHENm7HhfDHAG5ebHC5LZ1uAjk0UUb4hmrdc9IYEdeE6FE1Ce2tSDJrbNzFrsm+ucLTwE00CsQQnWEzRPBA5Rhmk3dDFCCSUFuvpd+b9Qpo//vNlSw1GP2pD/iIB8mRkCY1YDuNUOqLdjc6hxQV8wRXWChTNjfofosOmzpXMjH9NhLuXRruwdBuCphAzPEQF60jj/9wdyAPq6CazcjfEhMrcYFA5HRMYjYXT6r3TbxzPrUQ09HKegdpUDPTXnVdhFVjcc6gf3gyLnpDKFk/S2NNPo2vrJ7gDtyYPb+cF6yA0Czkna7OXpFGkZjKuRWE0MSOcEY0ObyFV9OUil7RzKHZ/ZU9wvH7NddnHj1TjDPBnuUZ1lTpmP0yQdMzuCryABnVc6emPa1Cm4a+KkkqVpacxbq5dxmH1VYIu4+f6Yd4j6GMFQo+hn/j38k3ZNN+8n5WSQ2hVp9DATm3vPIvy6t8KmgiKu/297WqO7ix2zJS0aeIX/DeP58XHdOhzeDE12UED8FUH58JbIz1iV2mlGuE23hZKUxAUHmpHC48Ps7mLU27Mf5MKHOklgan5bWp/Bd2WeyhgpD/qqqnsVCpvqrvb6tKQBZXmFMtKc9oNErqx2E3HM3gj/e72QdmvdTbbAlo7JN+up6dKOuCEnB7YVkXwsxwc
 qRXNu+ZA
 2ErSzPRIPUUSD7zm3/sLvUhit8i3mxTAztxjf8SKRfSXzk/eNArQVFXU6KspCstohwck6zxYPou3yUDHt6ZZB1qmOu/ZBMB3fchI4vpDSSh6SDwzth91MoiYq3nGfp32KMMAqQjoYIvXT7hvIoSgjoEtSjVL1wAeFkTq4D6iiC1g6N2VpJDxBO+QlUuPAfhYOK5CidPtOtJxWdJfDCiI8Xx39TVir/LAbS1ztor1Zz5i8tSKf/ZdxRJEVN7sf50qoVX4+G++EwH8aO9zZPIYSXUZSqm8ATGt5Pv/IYjWjBQ8mb3PlbxXfxYGanlBwYTlRH7Ur3djDDLaoAkWDvOwbdAwevlXZTOOGHSdmkNNbIvxnBePjoTDA5qW1sUFPp9yruybKnBY5xtHXSqOv1oeQE7OSOXnvRVI9watMrst9K7JkTOCVtBt211CCtvaZhYpZFU2tKLNDrOfoL5DQ6+DLzLZN3A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 20, 2025 at 1:21=E2=80=AFPM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
>
> On Wed, Aug 20, 2025 at 01:13:13PM +1200, Barry Song wrote:
> >
> > Let=E2=80=99s sync with Herbert: have we reached the stage where all dr=
ivers
> > reliably return -ENOSPC when dst_buf is PAGE_SIZE but the compressed
> > size would exceed it?
>
> It doesn't matter.  Software compression should never fail, and
> if it does fail due to a bug, that's not something that the user
> of the API should worry about.
>
> Hardware compression should always fall back to software compression
> in case of failure.
>
> IOW all compression errors should be treated as incompressible
> data.

That is why I think it makes little sense to add a counter
zswap_crypto_compress_fail, since zswap already passes 2*PAGE_SIZE as
dst_buf, which is large enough to hold even incompressible data. Adding
a counter that will always stay at zero seems meaningless.

We might want to revisit the old thread to check whether it is now safe for=
 us
to move to PAGE_SIZE in zswap now.

Thanks
Barry

