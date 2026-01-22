Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85A80D6CFA1
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 18:09:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9A286B02F0; Thu, 22 Jan 2026 13:09:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E714B6B02F2; Thu, 22 Jan 2026 13:09:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D73326B02F3; Thu, 22 Jan 2026 13:09:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9D9706B02F0
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 13:09:46 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6B321D2DB8
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 18:09:46 +0000 (UTC)
X-FDA: 84360387972.03.892A79B
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4AF5040015
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 18:09:44 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ctqmgLta;
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769105384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LbjBnPVhpRbR+iDPKNRkBtw2lZYOaBG/Duh0jODc6ZA=;
	b=lLn2QD12HkLMMXfiDaim10SkmSoyT5eyCBJO8HxOsT/D3pF8UFRbjZHFZX57iK7QGubrji
	E12UxSEQW2WZM6fYuCHZfRWsRuxEsI+FiXd1EMHIKXZhdQfZLD7HP2QbcpHvdhkP7LLguh
	STudNR82jt8/CkkXqfLCgNEx8heV0d8=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ctqmgLta;
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769105384; a=rsa-sha256;
	cv=pass;
	b=FgaEFzkrf+6hldDm+6c3W7RbA74bsm0rm0um0H9qZ+IbWPgHb9zCjf0z8u8ESQz50IvVLe
	ASoppRS2oPei7kQE0Lz3PfYbnxwc0+1UE9M9UFhK/12NC/MBkW1PgToejyVXeNWSQSgzNo
	iaaLYnxfjyXURf8bIUfYxXzXwXH2x3w=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6581234d208so2532600a12.3
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 10:09:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769105383; cv=none;
        d=google.com; s=arc-20240605;
        b=EHEAjhiOiKHLZ60oLkJZAX1CCMgYiG6T64MyFoKfBnO2AqocIJgo5zN455A/Yrb12j
         bDskEd1Tn9e7SVOajW7Kgubp3LSvVN8TCGuT3o7JuN8Lgw71iCUS/O/4yN5KhSEoi5si
         g7ut7ixteu/wPrr/uvFzgcfXC/24LtWAQji/PUkgDatQFGmg6MVfMxEXbG89k3ax++hp
         ADvv6OPO4nMm3eLvHRb5860H7v4tjBhIX6miE4Rzk0taC1U/LVRjM7nfOKt8WOU5VYBl
         hyzkZKC2LC85xZ7O1ZCZ+SDEFyOjT1XmBizFoUeSKGklhhzPV5Bk8v0Wq1d+pRLwm4F9
         t1FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LbjBnPVhpRbR+iDPKNRkBtw2lZYOaBG/Duh0jODc6ZA=;
        fh=1Rja3thGjCfzDstJuqZW7MJ5VwmPJYZwe3u9o0GC5Qc=;
        b=BQ3HOYgzmfcXmwIxuDt/fVHiEQFthBOvylYCaueyKd/f8VwmItA/fYs2UqBaMB/9NT
         LgufZLUeBiILrM8HJnau4g4YmOhC+PjTTtq1HWHiJpuVtUPWDtjrgGQgMdkgA7Jwsl8Y
         /XtyjqnQMyPGlbKc/4LcyUsNvH8U0qAbEX8R7da0VwJ67HeZazidqn0uBwLGPqa3CPWz
         tY5E5G3IFMyiKIydnF8gZ6PAps0N878NPvW1VperVR9WO1EHDivFfC2sE6VMjcZy4qHn
         ExFdpGJy090yaxNXklG8U2Q7Dw0SsftuMoH02XmyN57UV8BTFT04KLsoiHYuW9O89T0X
         kydg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1769105383; x=1769710183; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LbjBnPVhpRbR+iDPKNRkBtw2lZYOaBG/Duh0jODc6ZA=;
        b=ctqmgLta/Mjpb5OgJ9sQF6xr5x4/JqVkFcXR4V+UvRoJpj33vA6XET+HQF6DlzW4Ze
         3VQZo0S4t402Da0ds020jjbxKFqPLD+WaMNPvm8Qlgd5wRylJxaT6LxWDP4lWeLrtR/I
         fmrH7/RbO7MoLytVFJkwkDbEkRPJ50mYFnzkPPv6TIouf1xZmN4mlC/JVl7u+L8l/lyo
         UU1lS6KfXsJTdmh0Gan9oKAcbd0QBLD65d2KJ6LrpfBwlzgtEXFrzQG/NmPDtJXhWzvG
         phF7icZWF4P4DSILPQW8AO8yF0RYUmJxvJsnmjhCA1in49gFmbgYDlTTJmucMiS9rIo7
         QSEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769105383; x=1769710183;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LbjBnPVhpRbR+iDPKNRkBtw2lZYOaBG/Duh0jODc6ZA=;
        b=nWeugksAl/7+/YuhaoNU8Zt7dYfmMKLXqkeGXop6g1tVrWQnXXfWpWRMgjB5pF70OO
         BKMEkWzJlDw4aZ5o37roMKgQ84Vc9u7TOObj9iVQqNfsA2atehpEo+RP9qwpTxIkkUzP
         klJYN8ZVpWzh/GRbYnpiy4j0tOfOq5MDiVaKxGECJACeze2TH0bD8BgLFiGxOKSZL4J4
         qMPKYGlg0JFX1sxgdbBGMddSms7bGLjirEbD63i/SLhdFY0bEV9n5hBzRzmGj54uWTDI
         g5Ia4auK3vb27AkuJYU5qCGUbwJ2RdhnBxBY3BTvdjjqSaxuPMr9ZHaIoaiwB4NuW6EN
         SIJw==
X-Forwarded-Encrypted: i=1; AJvYcCXDSFihbIPNVoEFnHcqm4PAVeSJEwl/2cOfz1Id1/vBIaekgXmHhw5tQ/KPKsfsPxX7U8iym4v9eQ==@kvack.org
X-Gm-Message-State: AOJu0YxAmmWNNHc83j9BwKtRLMvlZeZ34XDkzMm6JL/DJNZ1W/YTBc96
	FE1Ew6nDu8CdQxHszUtv67hLSY3YZD46UgHOU85StcoAmZv3y9oK18sAfTO0pMoao0eCgnm/z/q
	kXTg+DtOZ8zmdqsXGJGThPX16T2oafKu2xlA8iWRIwA==
X-Gm-Gg: AZuq6aK9v0UCSMTIpOkYJ2rchT2aD2NOwWiWmwJ1kp6Fzz2QXwK8pkzePCW76qcg6mk
	hnQ5p6GP5l2inGJTe/BK/Kt1Qh9nfc1QEcjBc9NxG9WzxlWA/VNVuVIAYBca0WCqFHIbk+07CY1
	BkHoVaz9TD0numg7AGPA60yJuI+ey4BuISfh/10aa4nCiV0nX3qeQu0wwoHUgTcOVq2CJnEbdSf
	UBdDuTrllB1rK4Nue0ZL0xdEmyHJONqD4zvQY+rZy/cV4pfd4j5ZKbuaPbAht/MqqyomFDzkL52
	e4z1R1fLz1Irj+TeL8v8gdqb1g==
X-Received: by 2002:a05:6402:1e92:b0:64d:3b22:a5c2 with SMTP id
 4fb4d7f45d1cf-658487baf12mr292541a12.25.1769105382740; Thu, 22 Jan 2026
 10:09:42 -0800 (PST)
MIME-Version: 1.0
References: <20260122132740.176468-1-ranxiaokai627@163.com>
In-Reply-To: <20260122132740.176468-1-ranxiaokai627@163.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 22 Jan 2026 13:09:06 -0500
X-Gm-Features: AZwV_Qi9TMnkjzXXfx8I6-lM4eliGE6Ihf3Eq84jRCQeznE2azuug8e_3kMlNnw
Message-ID: <CA+CK2bAMBxZMBGS6DLaEO7M92vutW5UhfJNSwk+okdVu=EYu+g@mail.gmail.com>
Subject: Re: [PATCH RESEND v3] kho: init alloc tags when restoring pages from
 reserved memory
To: ranxiaokai627@163.com
Cc: pratyush@kernel.org, surenb@google.com, akpm@linux-foundation.org, 
	kent.overstreet@linux.dev, rppt@kernel.org, graf@amazon.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
	ran.xiaokai@zte.com.cn, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ja1kzsbbx4r5n66dkiq1d6idbm87t3nj
X-Rspamd-Queue-Id: 4AF5040015
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769105384-321946
X-HE-Meta: U2FsdGVkX18RWKmY8vgdEwqNlps8xg9DddN3B9aTVOMZQ2Uje7OCKRuXf9bRtNvpaEeDtdOa4NUHHacXca4vYJsi1pOozCwA069NL4V5qzoOsZCMI49wgGgpwGDUC1pojV+dUqf4hgayeL+DO/7df7HRdOlk3mSGgX6XRdYThwXgavNJG4KngCCnoYFG5eZ7zuqQrenG3lIg8WOetEaFGvy+NORn50QjpS1AtvzLny6GSEsUSuOgPOjxNSpjcpXtJ2Vlu4VqOLJ1BAPq1jyk0y1AZf+3Wxb8s45nc/Gz73lLstu18Yi8z+LUzUyCB8D5L8W+AAxN4J3W2C90rVZOkXj9nXdm8Zq5KTRmirZo4djxZebbIBAr9SExR9jhos4pq1RaXLowbl3TymuAa6jTf5wseGs3pu70Fh3VtEbDg6V4qHULQz5MC1HQKSX2dUiPvXRsB5QQX4k/CJlBqiY2DDK6Mz0U3HYn+J9y14MqkYOOxLGfATEeRCHOjQvSnWIg3YRGv6+T4u8LtlXQeTkgPPrxS2HpkOjNUaS7pDyPXp+Q+ft1Zs+dvVdJjvuTFVyhPbjJHS337pOVIORWND2DcRiJ0KpP52nBeY8YmPIuDYRnyJSSFXcysthKZdeWEePYV5kbrgJ8EL9d7xJZpXS1fblB+6nLyI5oQKxJNIMUfQC6XcDG6o3O9TQoZvhIxO1RzqCgHRBQSslJFvYWZEvwWkqVH0WZ1kmFhMEfrPduqzF62tkPJuj+QZtnUi0u+9szdGYr3RzUdtNPBvew+7q4e9DzWCVYH15eumU+dJmTIOE6PN+WFkEIa3xIDFJY4L3+sBWTvN7KzBJZapXzsZTdwdn8HXmhuj1q4Y/48A6SFfOOGgxkt56QWjr3XxMP+ADkFOnccU5f5R88FRgISjhDnE4milwRohRBM2E2KNkSRO9lZTQJ5WDP2s2irpABGLKlLrjRM3GxO18wmF36Y7v
 7S7vQr0J
 nix23PeKSXManqPhuSftoBwa0PHk7zXjt+LjWu52uYxNekbDkYkpZNcewYsUT0LLL1p9BMujRpgfdSTNJdIW2SFW/ZoryklVzWrqgoC9E32mNjsdtj3f4k1+Te16zWkBFzAhcW0pmp32JC+dNcC6lq4YvAdy2PfBlyk1M8UmrZjwY8c6Nxq855/83ri/2FvCQ2nwbYDv7GW2cM/mI3UZau34JbMQBY/tL/q/MhFbvBVJHGeRrIJsjvbeN5Yzgfv0/YRsHO47QFGJVNec1+nsLwP2brOGYv1qm/Zol9GJ7ADjjkw5WisnpUlqftlT9vNYltJMJgDBZ53v5tn2gzNCCPNDHkW1ykIVcRaTUZlbParpxB2LOaZ2D7rZNJZPJ3gP/w03VepTYd5hA2Jy9ZpEiBt/CCGcWs1plrLltWzitXBYvOrZXMKp1z7pGJMREF15Ecq2uafayKkgjfwxXAB2+WH5bvTHN1TN+/gaIXocSv6rpAas=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 8:28=E2=80=AFAM <ranxiaokai627@163.com> wrote:
>
> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>
> Memblock pages (including reserved memory) should have their allocation
> tags initialized to CODETAG_EMPTY via clear_page_tag_ref() before being
> released to the page allocator. When kho restores pages through
> kho_restore_page(), missing this call causes mismatched
> allocation/deallocation tracking and below warning message:
>
> alloc_tag was not set
> WARNING: include/linux/alloc_tag.h:164 at ___free_pages+0xb8/0x260, CPU#1=
: swapper/0/1
> RIP: 0010:___free_pages+0xb8/0x260
>  kho_restore_vmalloc+0x187/0x2e0
>  kho_test_init+0x3c4/0xa30
>  do_one_initcall+0x62/0x2b0
>  kernel_init_freeable+0x25b/0x480
>  kernel_init+0x1a/0x1c0
>  ret_from_fork+0x2d1/0x360
>
> Add missing clear_page_tag_ref() annotation in kho_restore_page() to
> fix this.
>
> Fixes: fc33e4b44b27 ("kexec: enable KHO support for memory preservation")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> ---
>
> v2 -> v3:
>  - also call clear_page_tag_ref() for non-compound order-0 tail pages
>
>  kernel/liveupdate/kexec_handover.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec=
_handover.c
> index d4482b6e3cae..96767b106cac 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -255,6 +255,14 @@ static struct page *kho_restore_page(phys_addr_t phy=
s, bool is_folio)
>         if (is_folio && info.order)
>                 prep_compound_page(page, info.order);
>
> +       /* Always mark headpage's codetag as empty to avoid accounting mi=
smatch */
> +       clear_page_tag_ref(page);
> +       if (!is_folio) {
> +               /* Also do that for the non-compound tail pages */
> +               for (unsigned int i =3D 1; i < nr_pages; i++)
> +                       clear_page_tag_ref(page + i);
> +       }
> +

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Pasha

>         adjust_managed_page_count(page, nr_pages);
>         return page;
>  }
> --
> 2.25.1
>
>
>

