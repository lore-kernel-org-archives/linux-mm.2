Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7F5ED1CDC6
	for <linux-mm@archiver.kernel.org>; Sun,  7 Dec 2025 09:21:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 275016B0005; Sun,  7 Dec 2025 04:21:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 225E86B0006; Sun,  7 Dec 2025 04:21:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13B8B6B0008; Sun,  7 Dec 2025 04:21:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 020B36B0005
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 04:21:50 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AAF2B133EB8
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 09:21:50 +0000 (UTC)
X-FDA: 84192132780.30.29961E1
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf24.hostedemail.com (Postfix) with ESMTP id CD6FD180002
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 09:21:48 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XSinBBeC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=mjguzik@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765099308; a=rsa-sha256;
	cv=none;
	b=k8QXMwgsnJ1PPKLmuImqgSX1QKUoXRuqWcftiMcpzkw1ucItZO0BN89vXE5d6GBSm0Op9F
	rcgLPB0tx2X85Q4GqOTIl5BuM5E+Kx1LrGrPjfvC3cwsoKJ8/1GQi72bk5EqCyfIKfpzWX
	XfwBbeUHxJtR0qqY07yFTqcb4s9SU8E=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XSinBBeC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=mjguzik@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765099308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DOvgY9knLW/q8oFaX8tcGdmBqB6enF0wMS5RI0Lf0GA=;
	b=FYlnyHcU9KpPlZvKWXrng+fDIS7oG7XB5CZo63osuRDypo9GzlCYtbtDhuaqJwdmGfl62q
	t4N/Cft8thh0tfD+ty8PnGrIiiXmtZYii47zQFiUVQV3MXFcFglpRboAQPyHo35VGz8Iqk
	D1Rt19ZRQElJ8XaGz+2QsUjnzW7GjK4=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-640e9f5951aso6658355a12.1
        for <linux-mm@kvack.org>; Sun, 07 Dec 2025 01:21:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765099307; x=1765704107; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DOvgY9knLW/q8oFaX8tcGdmBqB6enF0wMS5RI0Lf0GA=;
        b=XSinBBeCyj5C6X4ZbgylRtW8S1Y4pItkNSHZnwumP29cXm8VGthemi1ZyXBjlKHCH/
         Vu3ct9TeTfCtP3fmhyGgBIB3QVdvNHkI+493KaQjL16si6W4RkgTAmBKO2AihoKpAnlt
         hHBn6JFOPfPSo/44J5oZ0QSA8XJThjZwUr0hQt2Lcz37spqjxYcMMYRYpNy6BHJ8s2Se
         tgIiV9+JNiwq55Rt1Cipr5PL6eYs1kUucY12LrAuWzz4e/mlWkVSWMx5bYSzfzJq9AG5
         ZszSEdSky3BtAwJMNVy7nXnAVEvHS4ERskW7zCi19hrXGy4fd8qRasPTLoYiOTb1647w
         SPxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765099307; x=1765704107;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DOvgY9knLW/q8oFaX8tcGdmBqB6enF0wMS5RI0Lf0GA=;
        b=GCdzH2UXoNUvRHD3GtGJrA7RgAUP+8eflI8xJ8AuGaDPTECPUlZwUmKBNSnYw1AnWL
         qVMmmyhvCwOkx0JdOz5OYo/GKe7V1USDGsz1+JQuxiok+61535EtI0nWqsHx7AqGGmkh
         gmxGl666IgkxhYhKqd3wCxqio6S5Q9lgwUNvgkh8BXNleD4yyO6zsgbVeMBXweEbwcyW
         2LH48atifeG52waJcK//E/sUc3yg4FNPdqNsk8VKqYF4aeB6BjggK9bcuKm4PvFmanCm
         uOBMt2HBFF8KPAiYJzvWTzZM4hGOcxRM3D5YhTOw6K37fyekHSjFiErgZ3Uc7C77aG1C
         uDbQ==
X-Forwarded-Encrypted: i=1; AJvYcCWMTdsHsHeOg7rNtgO01S/o8f7Qs6icu9/mLrGuRs/9+PS4ehlfBxN+RU8VF+G79oZCPTJ7nM7/Hg==@kvack.org
X-Gm-Message-State: AOJu0YyiToFiQVKFdw+VwNojqI9Tw47nGh7/GhLUbQ9E5roz9AvoIoLW
	SRIq/ht43dWzLCw23ZpnagtjCk2Hb1IIobA+7qq4CzoZ17T3H3Zot7plFbg/rp5SPf+LIyhLU/Z
	IBm3vq0i7K5wmCpw8FDooFVQMqaJIa3s=
X-Gm-Gg: ASbGncvW3VdvS7gIyPYJW0CyEIywcAA3TWQBKMZOgnihLuxMsgARi3sWuXKTBW2axPG
	jSv/Oi7JXZUyGIamg1x790d9UO281D+ZQHcIG6z+RhYFKdCxiY4cbyJwTtMjbzgmJaZW479XNwx
	n6OXE9xmQSE63CmMkMIG5yCB3nzFfix9iP1NvqqbjzWQtzL9xOUsfrM7aPW3mUJIU+Qj+QUDX5f
	ZCjLCbVeZZezCudzfVRdrs17CZ2/OKzz0L/7+l2wdpkoANboEzCCmlaRAVtAydIdKOAnoDVR//y
	sIbKSOGTGcb4aB2Bn6cQOG1Qdw==
X-Google-Smtp-Source: AGHT+IE3f6+lERRTkhgYiXq3WxT75J4vw1ZgvUH3e0qfRSUXuaIevkmchnqMJ7PQ613xIwPYrVjTKig6hmvR9YqtDco=
X-Received: by 2002:a05:6402:40ce:b0:640:9bb0:a059 with SMTP id
 4fb4d7f45d1cf-6491809850dmr4243505a12.10.1765099306875; Sun, 07 Dec 2025
 01:21:46 -0800 (PST)
MIME-Version: 1.0
References: <20251206131955.780557-1-mjguzik@gmail.com> <20251206131955.780557-3-mjguzik@gmail.com>
 <aTUq5bRdPNpup8GQ@casper.infradead.org>
In-Reply-To: <aTUq5bRdPNpup8GQ@casper.infradead.org>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Sun, 7 Dec 2025 10:21:35 +0100
X-Gm-Features: AQt7F2qIgG7x1XRP_ygSDiP1LRfgTA-lBEZIDe8d-fhDcgS3auCKA34L-aS3_r4
Message-ID: <CAGudoHFjrMsQaDzndo3sM1Jn_WROBrZ0PeQbU89-tDakLAOvew@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] pid: only take pidmap_lock once on alloc
To: Matthew Wilcox <willy@infradead.org>
Cc: oleg@redhat.com, brauner@kernel.org, linux-kernel@vger.kernel.org, 
	akpm@linux-foundation.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 4ghejrcz5bztrrbpyx6rmrkyrbniqtg6
X-Rspam-User: 
X-Rspamd-Queue-Id: CD6FD180002
X-Rspamd-Server: rspam01
X-HE-Tag: 1765099308-200580
X-HE-Meta: U2FsdGVkX19YVhhhq0sRnEu6MSuT/S0VqcRD5nM/QIfkOYNUKz9++TCzmn+21BHplOgX4In3D7j6ixciE4qEA+Yu0A8h6HO2dmXEKx0W4w942gUQHe/XvnocvApSqpcWF+6+TcQXBmENh3OKZdxH/poyMhqBMzzuQkMwjCZKb6G8F8G1xQYD+rWJFUivtIhqyigLdVlS519xBxd9yH8tquPGJa2wDHufmNmcGYEHcpDnSwtYfb/6G/AUchlQJJnYtOOrNDVHPwSZxCTOIoX8IRZFpe58P+7nFU89hHXBfcNzG2E8grNNsA6Hbhj/oXdR412I/bcsTnc6LcTZCGkqdIff5RYWniRajR0yVcw5oT7Itos6PYZi76Bnik+9Z+AKZtkZzaWZMddtn36W9ADKkw276OyI37NXAc2Go6OKQlfTeXwpzJ7XIiktTS0VMJotQxy3ycEHfjXDdbDf8eA+pslOLNOwRA0S0ZD1VK7cjJWpapB8BuR10WeUO5cbakIteMXrJj0gTnTEAT6+yr6dKxuvhBf9YWKqoC+fy7IdZekhvOvGtzZzydzGPnhcGDMkWav5voyx80btUntAeG/B+OCOPJqI5Q60wD7WtgCz+NQLo8GESYRP7Do1Lan5TuYIzeEPOGkIIQn2AZj33szg4Yg6iusyO1y6k8heE6B0y31gutImwZ9iCrlou7GhhJLbs34+uC/bWZwundg3Vawi+MuMrvCiJlDlhhF2qVVQE72/96AKbW3p1c9Ay2QRdU+u63R1gm7wqKyxGGpoGdp+KW/6jhWDLJmClKDfm36cCYWqXN5FpPDUgz/tn4WIY67ZmOI85eoIYah1lyRXQQdsmDUxKUNTCZnzkfw3/E3kTj8lJgn4MO3/IHVcT0v+TjhXAv5IDhEDNoCTqrtzvBmBWrmoHdxZ1IxtHamzxLD280czqEYm1sz9L0+okmjYaEt+3gPdJ+Zt6J12A92HQ/g
 5SoQ/KZZ
 gMwHdapyCX1qA5HIga3CILz/mCO6fpTaDraImcX4vim4HxKPekk7zR+fh5rYY3iI128mEXVg8Hnqg4NMRTQ8xjJ0MrOgFHvkyDjkoLQXXTiNSFrExLg8vLtPm4ogY4P5JVWTB8w/e4hNvmjaXw3uyh09zzIbJonC3jW2xbeM1AnWrNcPMhfXDrXqtktMLUmvlesGaJs4xcpekCf2LW2itTK80w7+/tvoQIensKa29K645o6oNHTolJn+X1XxqQNgmpK1/tbWdFZ31B6r+Kg3Wtd3wGKs8PM7bgUD9Au83t1Xom4p+W2EHXuPgKFMz+XxGXOx38PnpXbaaMQcKBfKS8idHicBYUYVRPm2AUfuRCdY924fpoDj9Vyx2WkycXuNJw3GV9rTwrP/HJyLTRymT77zU/2iRS9UpkQBxPaXbyPMb0QnufghqBGsej1i/7HgGttXiRe16SbOjjYc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Dec 7, 2025 at 8:21=E2=80=AFAM Matthew Wilcox <willy@infradead.org>=
 wrote:
>
> On Sat, Dec 06, 2025 at 02:19:55PM +0100, Mateusz Guzik wrote:
> > -     if (!pid)
> > +     if (unlikely(!pid))
>
> Does this change anything?  I was under the impression that gcc already
> treats !p as unlikely.

I don't know if gcc is guaranteed to act like that, most of my
experience is with clang which was rather inconsistent about it.

