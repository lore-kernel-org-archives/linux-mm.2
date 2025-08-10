Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50C94C87FCA
	for <linux-mm@archiver.kernel.org>; Sun, 10 Aug 2025 12:57:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C679D6B00A7; Sun, 10 Aug 2025 08:57:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C189E6B00A8; Sun, 10 Aug 2025 08:57:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2E586B00A9; Sun, 10 Aug 2025 08:57:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9D89C6B00A7
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 08:57:12 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2109D1602FB
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 12:57:12 +0000 (UTC)
X-FDA: 83760848304.02.9B15C0B
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3EFC9180008
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 12:57:10 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eWB9e9MV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.43 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754830630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hk0vQpEQc96pPsBzVddcY2ri747yVEKfcp+ejDRXV+8=;
	b=UTLAkGGA7r42x8JCIQeyeFlazFjQRdMoHTIFFg7VJJlf9ygFGCDn82FBdMM/f9hf6MW6zR
	ENb6q78Dogw6E6fPPGRvdc064ezEzjXezF7oAu5R3wp/jnhVg7kpg5OX7gbUqnoc99/ZV7
	QBlt4PT+hM/6QbBNZ8a8Y6lu+BmwE10=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754830630; a=rsa-sha256;
	cv=none;
	b=DR9Hrqhnsoq3GIWPZS8xSBEcUt20l7aeGWa5d3/OJBWb3uKPbOEjAEbNQ95EYqHG5ST7Yf
	R+ar11/+K9ukg2nQJcr66tldU7XVyPXxIIt/ubm9m6RpCtTtPEvTIR5yXMSk0xz6VKp28b
	mKeIzkTFmOQAq996CRN7I6RpBQWuoOg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eWB9e9MV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.43 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7430835eae1so2224480a34.1
        for <linux-mm@kvack.org>; Sun, 10 Aug 2025 05:57:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754830629; x=1755435429; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hk0vQpEQc96pPsBzVddcY2ri747yVEKfcp+ejDRXV+8=;
        b=eWB9e9MViZVjkkreIShw4+EAs5JPGo6FfrrCO67N4KavLjvhfKEONH9xltLGEDY6U4
         nSqR44Y2aTvI2VcykDoOAgvW7h+9YhRDVgvPrNdsRdGNc7Yv5jabEESV582Y9RFR5se5
         0n8IJSxVxrY1aSLk7K4jGr68IY7+N/bktu+UNZNCHkVjuqXl/xxrQ0CbI8RXeX5JJ1RN
         tC/ynhT2hPVc/kthIZYBXLiCUOOs+lJSJHPt5OokChin6yJ34KZh24S+/g6wT+FW8NVY
         GZbw6ls/+1IdSFAY0Jb+OwbKQiSsd++cqk4m9qjDzXTVhcnY2+G567LfArWNvhu1r/At
         3j0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754830629; x=1755435429;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hk0vQpEQc96pPsBzVddcY2ri747yVEKfcp+ejDRXV+8=;
        b=VbLEFb8QeU9UMo0dGeiw9F4dUKFPEwiXG/iPy6u/mdSfLM3HJAI4OAQd8BpWH1Segr
         SDOFDDuhQD3+7PEWuqRD/P6B7Vbu/qj7PgZm9fvQnRe0IFLoIto3fqr+kYCwqUlLbUo+
         P9hSz6oWnfPcwEgK7YFSZwPUD3vcT4mRiY7Ag5Fop3lBJh9/lfS2sD0DC8204aGYMVr3
         HsaKqym26ae6RWW/RPbZZyGaRYGWUBQECB6yA405DBlSkbmYrSFJ85jBxzfMUxOXpX58
         RpMZcPP4Kh2wW1HeFUGIVR6DM8E3Mv/RmAbHbDsZl6AEGLZj1/AgYisppvpQomoQvzna
         ho9g==
X-Forwarded-Encrypted: i=1; AJvYcCW2RynngosRX6DVpI7lbNB32gP8jd7MPsaQYfn6gcJMBt72+bTGth3a6hgIY7i2YHLQnw+iCom5nQ==@kvack.org
X-Gm-Message-State: AOJu0Yz5HMnyFfrbbXbFiBX1Z8pTKTgY6ACfKg48emcZ/i3KvLRLb/Kg
	2C+kVxFtJy4aGWPzLxeYFWxV+GyJK3Ljk+W603INtVfc9T3ea4lyo9x1sskhaykPTbReRbUCa+m
	XBipPha7rB1xYrJb7vbpnqRqEyUVIudM=
X-Gm-Gg: ASbGncth+7AJ5Vl1Jmvw+6jdBTEJ4xgbhbOZW6ccjj/Rta/s0r3bJL322ukof8bVrNu
	iEtDuRpmQjb42+qRjzbRCxVzW2yG5dTipqpe+EG8lsQ5lcis9jTL4fv3OeHA/2WP+Bx3KdaGFFG
	lcGcE3tHMDlOv64nqURWpwR2kKeWkfAmOLV0Z4Sdm7OTQh7hjSr0LJivvuoa+Pg3JjJVkNWR0dt
	vdL
X-Google-Smtp-Source: AGHT+IEHY5r6Gce1oZK2OIKAsnl5ILZ147Y/o1PNH7xhcU6UAD3tqVBOQ1FMnzzZRxl24LGN1z+AQ/cYR3zDsNhaclg=
X-Received: by 2002:a05:6830:6c88:b0:73e:5540:730e with SMTP id
 46e09a7af769-74318ee5b56mr7154681a34.4.1754830629127; Sun, 10 Aug 2025
 05:57:09 -0700 (PDT)
MIME-Version: 1.0
References: <20250810124201.15743-1-ekffu200098@gmail.com>
In-Reply-To: <20250810124201.15743-1-ekffu200098@gmail.com>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Sun, 10 Aug 2025 21:56:56 +0900
X-Gm-Features: Ac12FXwymO9fVmgHrw4TsFCYnXlG-bVN2vqISj3bUbiPHnM0Tf9frR-EF_q3LEk
Message-ID: <CABFDxMGw6usfYmccAAvu7HRO6xCz708=9tTx-Ln-HgQ6GN49Mw@mail.gmail.com>
Subject: Re: [PATCH v3] mm/damon/core: fix commit_ops_filters by using correct
 nth function
To: sj@kernel.org, honggyu.kim@sk.com
Cc: damon@lists.linux.dev, linux-mm@kvack.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: gh1jdi41tt4coi5r9humonpq7k3nfnzh
X-Rspamd-Queue-Id: 3EFC9180008
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754830630-789133
X-HE-Meta: U2FsdGVkX19Bc9TxKeMhlRNA5sYamaVYtmQP3EM6GzjDEpnR+KHVdOK4XRKTj3B0luhha29/VKYfAMrZ6KEGkX2+CYVtcWcvyUEgbjmW0OhS4yeWnvOm60lpD5o3WUzGKOcyiaRK49ZBK54ymoR0wGXybeZU724pl0JNdJmA1gSWUUAuMOV55rG83sXflNJaUjOxIytYQJMV/ZnrQSD0urTUh2kdZZ09Yq+KlUrOT2ElEmdCC+l/7AmcL2QbTTE1n6zxvcLAAFIAMyrVwu4yNPQGs/m28HYbfUVrTmNYVk8bxwFv325/3VcsdcOLshnWrDPIYPi4D6NSLQU2gQ60qFqRBsRCuWhM0Gbfy5hBs00ppqzEcGIxjcrmz9ZqVZCTgWXXctxV9ZctHtg0S7/gSPFJneQiodV1hhDaGUDJEZ2unWcTi+8OYJktP9XydkKD+Cq92QvMBnwng9ZNwmkeepcZWjm2JohNkJ7VgXXewoN+0fXTuhzhl5rNBq8v+xD3520VJHOFuazz+9sEf39H/VTxGitwxL6/btnYW4QCu2RRX6/weH1esA4AEapbfbvQuJ+m5086zVf4NTfPv4y8EmDBIg0oIGwQDD/Cj3h+yl5xvHrl2nbIXhaPwmRaLjoMAZc9/OvjXyg/AIY0iWMrEKU1zKJzN7iPdVGeU1U14QpG9lz2NlnHEQj6IatnIEBFbWg1j/4RwD61BSQCiUIy5oxo77baJDsXkwJxyb/IHNJlRS39k9/g7xTB4ybhpaCbb8i49ZRDDt+WZJ1HFezKwizjY4DW7l93HXgUiniA+eC6Y8AyiU4nEJhwBv7sVM7xAh1qs9COZE6gizVLS5mkqXlR8+g5r0idbJ9+SXVnCSU4QOWzrvfZOR6ZWlhM8vkejsSsZhfl/mI+VTs2nvnC7QNXV40QBwAr9Y5+6abmHr+bnJbPAx5U/4jLX1fuWIS2MVoxBhLOdeh7g37w8lm
 cV3tEiV4
 Z+7Jwy8FL7EME5UyInnpFXpEfTPzWJFrETh4hVb2gNuRccw22vNr45yFr3NzlIGcanyTYkClTGpuVfQQ1kVYT+urW9zOQ3ChjS6rz6qzXUCGdZGf1P87+3lN7Yi/qD2B/1iFap0v1aoVazv/BKHSXCHDqbJZhl1+KSXIcfjjJQgsMPCN6Zqw0YeylEHjDI/qSPiZylaeB0//sHS35mX8L7Akn1E8u5bo6OKDR7qlK5YQGDK2SOqrEEygtq+okwmlhGljYfb+KTSQVDJnK12cXOPt205aMhtJ5OoFtsB+fXC9RTcLcnc2d13efnnsL3o8MuN7pKfw+QWq5sFazUyRzMbOBvPRwbvYzLDsHAm0/9dcKxEGYcH+Tdau7iK7F5H8zZIk6gjD58qmCHIJOnbFSeeAFg0GyoKxBnKg0ypOwPVkHg0JMD9ZkUwnLRD5mlLc/jw17
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 10, 2025 at 9:42=E2=80=AFPM Sang-Heon Jeon <ekffu200098@gmail.c=
om> wrote:
>
> damos_commit_ops_filters() incorrectly uses damos_nth_filter() which
> iterates core_filters. As a result, performing a commit unintentionally
> corrupts ops_filters.
>
> Add damos_nth_ops_filter() which iterates ops_filters. Use this function
> to fix issues caused by wrong iteration.
>
> Fixes: 3607cc590f18 ("mm/damon/core: support committing ops_filters") # 6=
.15.x
> Cc: stable@vger.kernel.org
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> ---

I just forgot to add change logs.

Changes from v1 [1]:
1. Fix code and commit message style.
2. Merge patch set into one patch.
3. Add fixes and cc section for backporting.

Changes from v2 [2]:
1. Separate the patch into two parts(code modifications and tests) And
this is part of code

[1] https://lore.kernel.org/damon/20250808195518.563053-1-ekffu200098@gmail=
.com/
[2] https://lore.kernel.org/damon/20250809130756.637304-1-ekffu200098@gmail=
.com/

>  mm/damon/core.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
>
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 883d791a10e5..19c8f01fc81a 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -862,6 +862,18 @@ static struct damos_filter *damos_nth_filter(int n, =
struct damos *s)
>         return NULL;
>  }
>
> +static struct damos_filter *damos_nth_ops_filter(int n, struct damos *s)
> +{
> +       struct damos_filter *filter;
> +       int i =3D 0;
> +
> +       damos_for_each_ops_filter(filter, s) {
> +               if (i++ =3D=3D n)
> +                       return filter;
> +       }
> +       return NULL;
> +}
> +
>  static void damos_commit_filter_arg(
>                 struct damos_filter *dst, struct damos_filter *src)
>  {
> @@ -925,7 +937,7 @@ static int damos_commit_ops_filters(struct damos *dst=
, struct damos *src)
>         int i =3D 0, j =3D 0;
>
>         damos_for_each_ops_filter_safe(dst_filter, next, dst) {
> -               src_filter =3D damos_nth_filter(i++, src);
> +               src_filter =3D damos_nth_ops_filter(i++, src);
>                 if (src_filter)
>                         damos_commit_filter(dst_filter, src_filter);
>                 else
> --
> 2.43.0
>

