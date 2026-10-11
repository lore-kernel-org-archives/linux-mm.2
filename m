Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 511D3CA9EBD
	for <linux-mm@archiver.kernel.org>; Sun, 11 Oct 2026 09:23:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D0706B0088; Sun, 11 Oct 2026 05:23:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A8CC6B008A; Sun, 11 Oct 2026 05:23:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F00D96B008C; Sun, 11 Oct 2026 05:23:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C93D36B0088
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 05:23:22 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 41031A083D
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 09:23:22 +0000 (UTC)
X-FDA: 85309807044.23.E170609
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf17.hostedemail.com (Postfix) with ESMTP id 49F7C40005
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 09:23:20 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=I2+o9Ukf;
	spf=pass (imf17.hostedemail.com: domain of nsd.project.dev@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=nsd.project.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791710600;
	b=CcahrEcd45XCmj1Nt+UBM+C4egxZU8Alx6LDTx9+NObCNYrOai8qqjmcA7goQr/qOs0/bo
	Kvx5ifZeYaglbscGcQHZ+997NmXeQHlJ/uzkSntbcwLQd9wkAEFbo2THjayFP+un5Cx+zO
	9D1qGxUXsb/kfiap5N2NGVL7M+hFODc=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=I2+o9Ukf;
	spf=pass (imf17.hostedemail.com: domain of nsd.project.dev@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=nsd.project.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791710600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cYQ50HopHsteNMAqeFteBt+xPXAUZSKtz95dPIh3ijs=;
	b=27sVEQ0TXeK/9nCmPg0jxpT/bLjcKnyoPcHM13ujvlQlmKLO/LYS9IO98GS3EgRN7/PkYF
	jcIHFdUyVipxTmeZ0DGwQKSCssr2Tg0SYRRuqV/pSpnH23TwYGU94hljUx/Z0WZIDcJFma
	3rPogMTjPWLbi1ThARgzlEQ0XwrY6nI=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6af9a90e4bbso1012771a12.0
        for <linux-mm@kvack.org>; Sun, 11 Oct 2026 02:23:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791710598; cv=none;
        d=google.com; s=arc-20260327;
        b=BcbpvMchKTw1sWSuO8MTrV3C2ulM0fBe+Jlq4o7jIU2nBPd5v4xUegOM+EzGx85PgM
         PNjhL5uZAe+f2Y/39ZnkXdRdDcQMIXzOPlDMgDmkMIqypC+vdHaEW2eQzxnFhP6ZG5OT
         U0bgxuTsWivNsEnpjS7mSszoKcZ1w4FvLH0CQ9msqcWftEbsiIkWMBJiB6MoiRP8JB/v
         6EBI06OvYTn2L+f1p4PWrAbKh4FkyoeIVx/xcKhsIup+jkvs8MxW9mhKvnsvmTIzWY3C
         RWw2Vcwvrq/PIHSrQhvNkycUpzE+SUN83ulF2XU3jdGbqV7PDevgb5kkjmDp3ifBAE8l
         QMqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:references:in-reply-to
         :mime-version:dkim-signature;
        bh=cYQ50HopHsteNMAqeFteBt+xPXAUZSKtz95dPIh3ijs=;
        fh=QpyJrt4Pe/orAKEH5CeQI3YxuxfXZnXjNdl/FMDwx7A=;
        b=KPNgtncuUTWaEbTlHuz8B5SI097NPdD205tr19nIbVeXBQv+uYLfEDUHiUm1Qnh6Vc
         qgB9aceUGw7tbNxtDYMV8j6zxKKrSXdEIzTNKOZxsjsp5gQX+6Fnmd0nRNkf6gtjtfoI
         wHc9NDpR0DVHTdqxeoq/KuqvDNxCcsLSEf8CgQIqi8SuJwD89DPq9YLGlANZEFssfITt
         IXeBpIZslg0Lj02R898jwRLjZSByW1/VZjMGWUaodEABxfADO7EKRFOF5T4PLx/ILr3l
         dj8wYpQ/SVRwtAm3kOe/vOoxlw6C8/24hipV/7nI4D4QwvSYWCPS0OCqzzZjFeFDvhmX
         n91g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791710598; x=1792315398; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=cYQ50HopHsteNMAqeFteBt+xPXAUZSKtz95dPIh3ijs=;
        b=I2+o9Ukft9C+IfxZ6CRM6Tw0KsVT6bW3EkDSx3QQru0RNFQLY7ulDuuPGF9wr8RK4S
         Rmrve+c5BZlST2lsKhylT5P2c3ggtcTz0V2Bhv3q6RrFHs3Hq11TgI71rDXPmceDEmnP
         YQ+Sfv/aqQX4NlYeDuSoruaeHpRDd9ZL+Y0sWH57ljdKjhYrQl7nNBdnLp7mhJPXmR5n
         /B5bcSufd4h8Ndi3MyQkfNYr9NdfinouCCibpiQpPKzb1iPOtzkcF8dwUwJOAQ/2bPpp
         /Y1HMkPASjCdq1upEzVFWW86AEGxcSO+UJLa3HgnD2JcYhqUpDvQdmKuWP7WD51OR9+d
         +luQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791710598; x=1792315398;
        h=content-type:cc:to:subject:message-id:date:from:references
         :in-reply-to:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=cYQ50HopHsteNMAqeFteBt+xPXAUZSKtz95dPIh3ijs=;
        b=WqNXFRHZxGhsWjRnWoZAVJD/dktcc8C9N3Oubumqyr7ZpkGNsEY3SBZQIeSjFvuxl5
         gVN87oEmTbHvkrrAl+e9hmNGG/wHae7FpPp88K5GCdejVWB5ILd1Z58a2S5Utk3ONm8/
         1iQumbwOZLcmtwqire3LOFQCRBCJCWIiJYD6xfktea3ZcgEyBObDwdWvuBKzpzZI76kA
         9/b+sCE5khSX2ArrnwfoMmMZs0DBdsTKT9lGscfXiCMcKr694raDcXYOB6FzmEI5JafA
         QyPvqlp5JoHRugN7iI4MbBJYdUDmnflQQaBxLiZiiAsg275AMl0Bcc1WM/o7o8TXxlfP
         Zycw==
X-Forwarded-Encrypted: i=1; AKwUvBz4PUFlrYRKjc1ZSvynVzW3oHPhCeJ6vb3CVmro0Rqp2aT8C2L5kznKVRu+rQxkhXmtboJxDzF0vQ==@kvack.org
X-Gm-Message-State: AFq9FYII89jpZRQiSI5JIVfWEAChZGwG8L8qS0tQ6XXlRyt8MPIhddBY
	VfUUv3Kb9tyvuMXMVqvcRYE7quxknHI0wINnLXm6h6DnC2PwS7PzmzsVlyx0LwaGx9xPLU8jlLg
	5iOBhzHWIQAcMa/0RwmQ9I9gJF6T+ZLY=
X-Gm-Gg: AYBFou1d2g0WIbiOadJE5yulWef2KVxXV+VUOQVZsMAE+3kQ3woPgRngVbK0KJAYD3Z
	NEnyV92kmOPFVTOX5a+dbIyi/Ua9Wzg11fMAC/W5QUEvSc8QzI3qofx3erZFSVhmq1Dnl6BoB0o
	RTexZ5JU7RygynME2e5oeS6yoJeYaB1pJ1NxY4bRXdgo4efevx+3zleJA/+rkC0mTT4KPA04nXX
	cjTP7Tnkv4rkD3WkL0k3BdB4DOX1eNrVvW0OKXIyMMzrTsdFMM2YDXlUudi1/7X4JIDNoR8Qngu
	PzgviMW4yCvKb0VBhvOfjGy1AE1ahrHhllPWk61/2BQxWXoPc676ZIvF2g==
MIME-Version: 1.0
X-Received: by 2002:a05:6402:21cc:b0:6aa:e589:87d7 with SMTP id
 4fb4d7f45d1cf-6b17c1decf7mr5274283a12.6.1791710597818; Sun, 11 Oct 2026
 02:23:17 -0700 (PDT)
Received: from 292895732794 named unknown by gmailapi.google.com with
 HTTPREST; Sun, 11 Oct 2026 09:23:17 +0000
Received: from 292895732794 named unknown by gmailapi.google.com with
 HTTPREST; Sun, 11 Oct 2026 09:23:17 +0000
In-Reply-To: <CAFLp9PGgfLJtqeSaTqrG0jcFAu4stP0og4Txy=ewCw0ZxFdCMQ@mail.gmail.com>
References: <20260725182628.221603-1-nsd.project.dev@gmail.com>
 <CAFLp9PEQQVuDpJPwrNvLN1-u3w3TMwZPUUrf0+rOBrvDjBBf1A@mail.gmail.com>
 <anlByPDZmvEhWeXI@casper.infradead.org> <ffcij36vnozf3rginqd2opd2dwqyki7xhtdo4veuty734hhgba@utjav2k263o6>
 <nsd.1787001235.35928@mail.gmail.com> <w7vte4itudtkw2yf4vbmuofiumfffmp2y52dpu2bqvqtdgjvpd@5femyiozss3e>
 <CAFLp9PGkVYZcQT5qAx-RKFOF-urZ92m417zpAeF7ZQempbS1HQ@mail.gmail.com>
 <arEkgM15qewERAOJ@pedro-suse.tail5790ac.ts.net> <CAFLp9PGgfLJtqeSaTqrG0jcFAu4stP0og4Txy=ewCw0ZxFdCMQ@mail.gmail.com>
From: =?UTF-8?B?YXloYW4gYXlkxLFu?= <nsd.project.dev@gmail.com>
Date: Sun, 11 Oct 2026 09:23:17 +0000
X-Gm-Features: AclHuK-By11gbr9MaNoXIL2Mt8RpYeOZM3ccWee1GrqxzZ8ofTrOrPUSY7ZUhu8
Message-ID: <CAFLp9PE8hUCa7ia0tuewytGUacGL5azUeUSSf69a0PwhbmOW+g@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] Neural Storage Driver - learning page cache prefetcher
To: Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>
Cc: Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 49F7C40005
X-Stat-Signature: bg3qz3wyeuxj3nnyuz41w1zw36xrxtju
X-HE-Tag: 1791710600-404199
X-HE-Meta: U2FsdGVkX1+5TkJ966TA6w6jkREw1wBhjgs/r3B6+pdFnQBBHaVGLQR2ruLhPBH7qohacVRae/wzCTB4l+sqZVBZPwB/HLtpCUT6lkIXhq1zOWajj1EkUqmUwPIYJ6DZaHDyjWgwEatEP7D1zx5VPYMhZdTEv67WczcpDstS+gPRDG1C46xPKdcHkGwYPAlq6c+inJUAOmZgxfDtle6gKNsy3O28TumsG+sb3oU7XkgTel7DqaCCmjxUV79SaVutXq7BDL0JhlO1xYdw2b50aGJC5fAHN6QE/MNPakyNB6M0+JyOHvicQLw7SCfz0RJXlYpM48jxVGB4YQK5fNeKRorwRKpLlW5BZdXI4lIOIrNdlARbgWBR2Azb6p3YCSwtCB88ouQnp0ZOASANxpg/ekDeh6PMB1Dpd1b8OBGzmSYC3YMd1wQZfZ+ZZdMgjPJ8kbJC1hEKrDVURaKjij8JEKxKdpk/+aSjxi2ADCJ9gce3YYN/DmzblLCI8y/P4G/HY3h1PpKwBFhs7ohV40epUmiRHZfmskoo8DHICPZtzx3GfJAabMovqkyrX9iL2Qxwfy6bbS0aVPhe2HyJYV34vpI3vy+uCxvVsIHzKm/cjbxHcOKg5HwTjwGMnfv55N2vRuzKa2/hV/FC5YomcoOp3Bn6b6LX5k3yuXicp12yDwSJ7lL0TMBrrMFKU4rpNRFy8zVsn6uAcKBphOKFDLE8amHYfXddbGDASXKdNcA+PbybtjyJUKAwf1xjH/nyhNZRyh8+Tj9sd7mieNFYlWr2IjyrHhRZ3WAUbLGIrAystrtRnCVC3ZBGOLfJVTGPIHZkJmZUmKNnPalSq7phLqZNYfn+rNu7n5V7xIdhm5LL6/XqfendOsyeUf0TE5oQBVxbL7QCwcXelsKnl1V4PmbhSf2Kt+rI4no9+lbVehdB570Gb56MgM4tNtmFAjsncAA3tXrgR4Jo8DmQ7j+tEUz
 K56dX0VC
 UOViccRb5Nvy2nJbxJGaMawFx+AmOzocybUwqVpbPBsehcTb23bHXtjzNK9Js18e0NHAL6tYFNP72TBdeg0NVAYaae7qRHLLHh5nmU2t15nLmv3BPpT2h3Q3gCXiWAv+zZ1hPKrpeynvCff++Rg/0ebqwobcN5uM4t863CLWhyj/ZtebI/NioVbsNZWWc5NOB9Dkjk9/759wqwMicC50+gaaME0bkvCpVmdnJSCZToX0w/h6vZcN6M6fNLHivXL3k+/nNyRopuSQucZIk+zYFC+IRbf7ljhaNqcozeW9f0vsErTV6Wy+bJePh/IuRsxARKsjWe5gNUQR/UcXS4Hyx0D5i/1piU6gbv1NZBhxkdTOyvm6Wx4NDNLrT2y81fC2LvxmNLq79Jk8yIlJ0MbAh28MpsxVExxi5q9pof1GTaeeeDG/xezZi5HRoa/tbzC9MUwqpVKjbBg3eavB2AErc+hWemk2COs3xEpPXm5CK/Ient0Cy0DRn594srjktjPqPMsumvUzZXXL6qT+L6+4BexnCJ3meCnvjN1lQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Honza, Willy,

Just checking if the Sep 20 note got buried. No new numbers
from my side, same tree.

The two things I am unsure about:

1. Is the capped shape OK - ra_pages bounded, overhangs
trimmed/dropped and counted, only measured willneed up to
io_pages and that off by default (Mod A strict)?

2. Do you want the small ra_state bit (2 slots + stride,
read path only, all windows bounded) posted separately
for direction before I test it further?

Thanks,
Ayhan
Assisted-by: LLM (English draft help)

