Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 434DEEE0ADC
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 15:03:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECC5F6B0089; Sat,  7 Feb 2026 10:03:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA4046B0092; Sat,  7 Feb 2026 10:03:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB0F16B0093; Sat,  7 Feb 2026 10:03:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CB0DF6B0089
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 10:03:27 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7A8CB160407
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 15:03:27 +0000 (UTC)
X-FDA: 84417979254.18.8DB0AB7
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8DFF620004
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 15:03:25 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JA6UB6GR;
	spf=pass (imf13.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 209.85.210.47 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770476605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V6Ss5XpsjKoGOf9rRrMSZvZipghpLxZFw4pS4gJWW8c=;
	b=vulfz6W3+50iQ3iXo+IkbnE86AAKaLgp+MQkUgMxCcUqtDYFjHL7f4B37TSk/CeYIikMz/
	gw5GK3csOnh5w/faAx2zzMroxo6rat4KDoO4HQ+BsjnLXx80WFlCnALiIBR9RfvrwglsyS
	J0CNcevKyFvWkWP/w503TYlp4xjG+WY=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JA6UB6GR;
	spf=pass (imf13.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 209.85.210.47 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770476605; a=rsa-sha256;
	cv=pass;
	b=gCFG6pybvY1vSXOg2O8cF8JHhUzGQ0P1JCAAtBmdzw//4iTDDl2HYpJUa4+LAry6VyC7OT
	T4VQA6bIX6KEaA0It3F7Vwhianskqq1WNV3S8pWN6ExFTzQyGyk6FNufE6mHjhPWQexBvj
	DmUF7TCFtHhs4uuXtEVPY/92YqQ4LXY=
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7d148dd3421so603658a34.0
        for <linux-mm@kvack.org>; Sat, 07 Feb 2026 07:03:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770476604; cv=none;
        d=google.com; s=arc-20240605;
        b=ezlYZG9KznicE+OG4nxZ/adC7SwFLpVcC21u36PtyJVCW84AQB4nEEQm/lhKGqztxT
         VB41AjXS8h5OtDZTozwGpZo4yViOgh2UCcfXLIP7vvdVopdck13HPeruLlOdeDDcRVhg
         hYsCalnTDXnrSwYk0IEo+8shE5DJbX5EQhW1unZQIRlN1PpK+DpUsDLhXx/AVd5Tz/e8
         PE2DujRPX8/kC5rVDiAzDIzwpi/ru7M7hON0YuNcjL/XbH1eI2DXLXBvVIOPIOq4pZxA
         ih5FsnYdxFiQx0fH9qPg+g+7IfCMy8b6NkU0CDakKfD2S0PnMYDqmV5Sv3frXXF670fC
         YN4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=V6Ss5XpsjKoGOf9rRrMSZvZipghpLxZFw4pS4gJWW8c=;
        fh=vC7GnoAMqAeDIIoLX6QPd8Vl3ghhTuvRQd8IB/alrHE=;
        b=knIDyvGzaKgpRGphAAG0FPfUlafYZig70aZMEFBURuccc5flF0cyS+OVTVUTkCPpJj
         WnzaFEQ/oUjaGW4GokLtUrkP67GD61A1aG+K/k3l9aRq2UHWbeynuVx4cgbUHH8eMb2A
         TCsZz/Yo5zpZYGIoIKiOcbeddRKa8ovJdDvoQ8tbc//6wLocviOaYJD3wh6rfGtfvX6r
         PG7PyBncgutzF/PiwtFtMWXcpSzlYrep3ocIM+9zjD8KdK5sNP2GA42o1zW+U/R/ZLCt
         9yKdskz+upifwFQVv5jq5DS/94Kme7pgGy/HmtosNltKYCjcjtm+7PgbMnd/9DjAZfEp
         cDlQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770476604; x=1771081404; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V6Ss5XpsjKoGOf9rRrMSZvZipghpLxZFw4pS4gJWW8c=;
        b=JA6UB6GRwSOKqp5/ryTBubvD/AIVii2GimS/WJNWCYEnVK5jwTlEZczMj5dxC3OuKZ
         LfEh0kKCQifZoFsm/bjxK8zegwsGePsBcnAMJsY4sdK8q7XjJoYAig/2osG/dxP/ahnq
         /JHexYP2hLhDE0HVsKj9unLN2tX1Xxj05D1Ilf31l+cDi1HFECYltDKtJDOk+QXbTJhn
         GsBnQznPpDjXRhxenFN4Ox5yvCjhIFZNrtO/OrQ9qveFzC3kq4WNSuuiha7MaQrU0opR
         fDQ4euxTbG98VLae+2614Yn/UdoSQs+85KK/gAv/U19L9eMHNaMUKRQhpyYEkaZxUKOM
         hqsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770476604; x=1771081404;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=V6Ss5XpsjKoGOf9rRrMSZvZipghpLxZFw4pS4gJWW8c=;
        b=uJDNY23X+6F+syDNLwoDbq5PPBegcEYBI0n9Q12Wc/YptbQxKMlU3EVQNRonKzcONb
         dQ6FrYzqy1rhS9ad67HscrwoEXhgVC3VD2r3gC2b5dv7GEIlsBwDYYkCwHjdmV8mKtEX
         YEvqLddYQ7AGsViPSyxeiPAjYX9EBmV+OlDqk6JVLdIvak6tqyIf/ZP3p9brJvptYKYW
         50V8K+1dZvGTwTq2bLTRuDI671nrOYiyYUzgyZsKSJNbvwm56UpsbWC06h3+oxNtIrdz
         FcGjeQJddma5ZPMDBIylEg+tqVAxWSXTObgT4J8Cn5cGM2woiKoAKTZzqQkdZxPhAG4b
         i43w==
X-Gm-Message-State: AOJu0YwKq5DyD0xVFY6wphjWHzP1DbtO2jg4xfQ/2KEseTPw/Uy0CJCL
	ToieZtYn1/kUhiXr5rWu2rQkgGiAStym+jJp9MZcIOIZkVp+fAbu7PbdTwc0LN7LVTtDE+NRqAn
	rc43QEcXZt2Hhxblynr7GAfmaQhz14dU=
X-Gm-Gg: AZuq6aIsWq1jMAEK0pSAny/e9Oflqqmm5EFpU5eR8ext5eKnB2ablDnLvxoAZNBUL9/
	o9hg9G38AHAYEej8SM5uCqLY/lYwPJnBO06KLUVqbQ3lsqlbETO9f4wtGkJ5kk1q2mxR62gqei3
	4MGOQFEW0cCQWNVhPMzN306mnmn1WFj/UNgY8H35RSiKcoC0WXtUYpxYe687a9SQtBaXNaN1cic
	K1qS9Fzdy2ZU2OgdYxV0ogF2lYfCXSJHtsrGWP8awUt8157KnSQ8svGXCRuBs+hDLuJ+IOFiw==
X-Received: by 2002:a05:6830:4885:b0:7d1:9195:a83e with SMTP id
 46e09a7af769-7d4644176c7mr3390186a34.12.1770476604387; Sat, 07 Feb 2026
 07:03:24 -0800 (PST)
MIME-Version: 1.0
References: <CABXGCs03XcXt5GDae7d74ynC6P6G2gLw3ZrwAYvSQ3PwP0mGXA@mail.gmail.com>
 <20260206174017.128673-1-mikhail.v.gavrilov@gmail.com> <3BB6BA1D-3756-4FC6-B00D-79DF49D75C51@nvidia.com>
 <CABXGCsOMzrQTsByYraNby_MXnTuYBNt2vbWu65KCGX6bmi11iQ@mail.gmail.com>
 <F36AF979-5BE3-4399-9420-F41A475EA87D@nvidia.com> <B6CDB0B7-CB9A-492E-90DA-F8D7E3B037E1@nvidia.com>
 <7C7CDFE7-914C-46CE-A127-B7D34304C166@nvidia.com> <4C3D8E3E-D9D6-4475-A122-FA0D930D7DAD@nvidia.com>
 <CABXGCsP2z6sbf_FYZjdxyLhfJZEaxz0_WrEeteS50GLyU=KQGA@mail.gmail.com>
 <CABXGCsNM8Oex-V3vFSUy3ftMw1fAweHZHQYzRHWU9M6gm7r-rw@mail.gmail.com>
 <FF3C3042-8265-40E8-8786-333A6F627405@nvidia.com> <AB3C1175-FF03-484E-AEB6-07BC93E49683@nvidia.com>
 <CABXGCsNyt6DB=SX9JWD=-WK_BiHhbXaCPNV-GOM8GskKJVAn_A@mail.gmail.com> <247E7FE9-E089-43D1-882B-81C7134C2FFE@nvidia.com>
In-Reply-To: <247E7FE9-E089-43D1-882B-81C7134C2FFE@nvidia.com>
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Date: Sat, 7 Feb 2026 20:03:11 +0500
X-Gm-Features: AZwV_QibOWsx0hvxPwoz0xT04dTclVaZRJpGZO3WzheOmzFRcEus6GsPC6hRFhs
Message-ID: <CABXGCsMx5xxxaqsLMHrRE=K2-QQ8AsYWbpo=eCf+PKBEGXSZXw@mail.gmail.com>
Subject: Re: [PATCH] mm/page_alloc: clear page->private in split_page() for
 tail pages
To: Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org, 
	kasong@tencent.com, hughd@google.com, stable@vger.kernel.org, 
	David Hildenbrand <david@kernel.org>, surenb@google.com, Matthew Wilcox <willy@infradead.org>, 
	mhocko@suse.com, hannes@cmpxchg.org, jackmanb@google.com, vbabka@suse.cz, 
	Kairui Song <ryncsn@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Stat-Signature: 8rbagrdn7icxnsa487apn418uwrteyaj
X-Rspamd-Queue-Id: 8DFF620004
X-Rspam-User: 
X-HE-Tag: 1770476605-665546
X-HE-Meta: U2FsdGVkX1++kr+LDnsW4lEt6SCO9qpiYSmS6gMOhZfgIv6p9d5QI9WMzVvUKG4eDSvja3CB8D++/zraMg+F98kBBuvPvsu20pQ/nKtpxMaI+JeKJAh9QV70bdoWzZAHdWrVAQ0j80X5p8boglORJfPrAdQOoOxAPKuDqDApsaoNX8oR7XtqTZOmg7F+Fg2UHSRwW/latrqAzZh2cM9BMyz0gIgZD302vAV7BbNY/FrRVGQOSmjIjPGEheyKb/8t96CoBkfAq/5/c4V5x/EFk9bPmFSG/AH8HB/uaD8FEKhqVbO8kpE1Ck05j3XJxO/2yZ6rhc7YhjS4FxrESgrm3rzEuKek06wy5L4TnO1naUgHcAbaX6XM94+ieGfL6yT2VEcV8zxJeYR2TN6TW7YPn+2jRGPKcxIdKeKwr4UJT+ESPPQnUMTo6elG+Kjtb/T59OkR3mV3688ptZ9ZmAt1lqfeB3Y3MGvzUa0Kc7fe90N9FpGaIPYoJnXqAkUi5pAj0TVKTa0XhCr1zqER59JmVWF0P45wWDN+geWp0Kas2ndSH00XAeQFDnyzfs01v5pssNlvya/BI2fIVkp9QiH5tCgMUz3Ehd4ZYKTngIxxcmJ+fqTj26S5BMlHnZ7z9/IuTn/YGBUQqc/xkf6dCIS1up/AdGC24905VPNyr6hFeahPInBxlrlAaHWIQqw16xQ+xcdCS7QnicN1RMRYjxvMOO91kIfoPCElags9X27rXCzYQ4WhR9kXLmVRPttxcuip2edabk0i8w3rzXHrUcbONShNWRyFSP7Qw0WxOt18O6Gn7lBskhyJccApVGpylP2XDecKvgC6gIcbDPFXPHhBNZqWfl3sSltaKWFC2NxK5klytD2ilM1qJPyTHL0yIMfXvEdX58ETaDl/aaFNLyn/03wRYNI1+DYwuQqMooP9Owl+AVbUwFNz/0C8HKmUVL2bFAoCxc43tP/tirD6JKT
 gdXasWqP
 RUKK6fLmvgoP7AtjaH8cpDaNYdAm1g1pK/+J8YYA6EWV/+PyCuFk5GHrYd2A8KcKxaW5zOmecAXzaG5PuRTCphx14dTdIPSEXLiv7QDEQ78JVny4bt7RjkiQRHw5zeHjmh/7+QPLEVoXjlgC+9AiEZEOXXK31V61hqbGXtqmnSL5gb1QgZ6UeLlDask58lAOp1IAN1j/spkTrk+Rw/3IuEUwthja01kZtpTsJepeLMQg0F7KI1dnV6Uk09nejF9z9ABZy4lQBCipXgo95Y1xf9/lRsAYwWKpN/IWwLNhoSCc0pnd+SKZfda7K70SNTpO+WtQi2G/Ot7hLGcoLi7P+vYKGrS+dSQXVVH+/hqqT/AAexLPtUzQHVS8mi3ULTfT6LIQk4J/DqNqySFge7wD1VjN+wSokz5uUoZNtUgIPs5EeW7K5nNG5JMBDeqa37t09rPjGeBiGW1bpUPQHoZ37Wa1caxTrrpdZ6CmOtbYZW5ymlrTbmaxJrQhXkQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Feb 7, 2026 at 7:32=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
>
> Thanks. As a fix, I think we could combine the two patches above into one=
 and remove
> the VM_WARN_ON_ONCE() or just send the second one without VM_WARN_ON_ONCE=
().
> I can send a separate patch later to fix all users that do not reset ->pr=
ivate
> and include VM_WARN_ON_ONCE().
>
> WDYT?
>

Makes sense. Ship the quiet fix first for stable, then add
VM_WARN_ON_ONCE separately to hunt down violators in mainline.
I'd vote for option 2 (just free_pages_prepare without VM_WARN) - it's
simpler and covers all cases.
Will your patch include a revert of the split_page() fix that's
already in mm-unstable, or should that be handled separately?

--=20
Best Regards,
Mike Gavrilov.

