Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B65FCA0EC4
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 19:21:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 936B68E009E; Mon, 11 Aug 2025 15:21:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90E408E0093; Mon, 11 Aug 2025 15:21:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 824958E009E; Mon, 11 Aug 2025 15:21:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 711738E0093
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 15:21:44 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C27591A02CE
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 19:21:43 +0000 (UTC)
X-FDA: 83765446086.09.9F7BEBF
Received: from mail-ej1-f67.google.com (mail-ej1-f67.google.com [209.85.218.67])
	by imf19.hostedemail.com (Postfix) with ESMTP id D27D91A0004
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 19:21:41 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DQUDmkYh;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of wjl.linux@gmail.com designates 209.85.218.67 as permitted sender) smtp.mailfrom=wjl.linux@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754940101; a=rsa-sha256;
	cv=none;
	b=Elh7UOZ1py3Qexf7u3CaetAI6nE7z3EccVfeZQj2QDh1x6jrfa8bxAb6SWBjcROzoFzbhT
	BjarI78/xQi3AZonY4BQxKzkrU/mDu24vkHZwGBZl7VtKQQCF32d3N+OrJd0V6gqh4xV32
	hy9WvVYgw3n9q5QYtI01jhknS0mpxQ4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DQUDmkYh;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of wjl.linux@gmail.com designates 209.85.218.67 as permitted sender) smtp.mailfrom=wjl.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754940101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WfA5yKinma6wtByRTCx1cftkJPjcSnflCI6y0F3kQ2o=;
	b=TnJcLhQFgWB2NH3PfPUvlTSQ9hfgeDHVOVqat74GR6sEzuubUanE0k3REHjb6hxVnaRa5M
	3xhHeAFRWdTMxY7uXYXcDYelBgmZIj8j0gC7ymjTquzsND5J5jD7trRwUQd/04c9au/tGl
	CFy+vGW1Kmmw9eshhUzpAjfgybjRRKk=
Received: by mail-ej1-f67.google.com with SMTP id a640c23a62f3a-af66f444488so671443566b.0
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 12:21:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754940100; x=1755544900; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WfA5yKinma6wtByRTCx1cftkJPjcSnflCI6y0F3kQ2o=;
        b=DQUDmkYhazQoiVSfpgRK3y8ZzLWnakxqM14nML+jKY0sv4YsDsRmQA4uzKYW/NKEZ4
         UYzOc1O3dP75QBte6meccTNA4q1MiUNLAjjBFPBKSbmvweNxpv/IguJ9pAR30+5blfyU
         0J2DcE7MBiPVjISPwe+biwTP1X8wIMPCetuNvor9Xs8WC1T2ShNw3CO5WHJXohSW1peR
         2xwWLqzHgersHXMyIA8FZNUedw6x62xhf1IIYvZXg9MloBPRn8+0oS1T7g4RjTMg8m3i
         CN07mtBmjwXZZDM6xFF52oe+lmkvT5T2gdIOpjiyZYR5LXJYs+pZ1tQXoNB6u1rAVJuW
         uVMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754940100; x=1755544900;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WfA5yKinma6wtByRTCx1cftkJPjcSnflCI6y0F3kQ2o=;
        b=rS7zBN2lB1NqFOj/cgHg+kCmLHFMfATDGsgERahVBXZHvAsKJHSrSHegosazt5Mc75
         cFflC1UZlvl0iE9lbJDr+5U9iJ8W8n5nwx3TA+C10qZ844WZnKsZtL/Os4HzCYCTVxaE
         fAVm0tizi+etGlv2PoY5DPF9dT1n3OdsQgxpUOs01WiHgR/dcKUIRnfSFV/fokUUZ9LG
         inkr0V91YiZ+BHgHoXAa70E1tyFUFYwbT7OQUHMsnoHYIj0S6xHjbopeSp4GLYWy++08
         eg0Ewr126AF6syaQ8BKjEKfINwet4olw81VGoMddXKm4U/Q4pUSVMIE1DuzAKENZH4dF
         51zA==
X-Forwarded-Encrypted: i=1; AJvYcCUEYj0R+im8Fw48QKcS3i7SINEXEWCGl0SPmQVKnQesuAKGygF//EM8VCeAXE/6n+iV1IaNlULt8A==@kvack.org
X-Gm-Message-State: AOJu0Yx7zscm6sHM0PWnTOhvmpzozBXW2tlsmAzONclG6mq7x9YTrCng
	S3SwipgsZukNQG7x7ekNjj86M5Ue4bhQje0g2e4uxwtQtVLudOk9Nrj5IH0Vu+uw94MVxV/oBqB
	nH6/TOJdIT4hsL7H93JUHIRLOJER3ThU=
X-Gm-Gg: ASbGncuNCZlwzAejOm0TsuZWFG+wYBRP+7YDojhAlOnVGkeAPq4aEu2TUjy75vTQwvL
	kfvKx9FsT6teBaBNjSv7gQw6eg6DkPqAB0ca27zxpKwSDfIOOFRp439/VhYY9h/YBLoOlAHvK3z
	/wxU9YU54qYqj1/Qd0IocDrj1J2uCR2OUWjlG/AB45pPa/znWEt3XcIQq+3X6AprZZGcuCBaqx+
	N5bUAYvxrhok+6UOd0qkI+8Omx1jlo56+Hu7RcKJBrffBDOgw==
X-Google-Smtp-Source: AGHT+IEOro1frCTITrHsRWhfV38IS+Z8Lv5bnkyZtUOrrQBC0QzFHwPL9PwlAAjnVHvRabZT1vbWAPReE+R+BBwcbAk=
X-Received: by 2002:a17:907:72c3:b0:af9:6e2b:f30c with SMTP id
 a640c23a62f3a-af9c64d4ac0mr1238490366b.34.1754940099838; Mon, 11 Aug 2025
 12:21:39 -0700 (PDT)
MIME-Version: 1.0
References: <20250811182500.42670-1-wjl.linux@gmail.com> <aJo7_B6cQc1EucA1@hyeyoo>
In-Reply-To: <aJo7_B6cQc1EucA1@hyeyoo>
From: Jialin Wang <wjl.linux@gmail.com>
Date: Tue, 12 Aug 2025 03:21:12 +0800
X-Gm-Features: Ac12FXyT4htmSTdi5IcSa8EfmIvYHeg7deDi32-MVHCVVqZdKOUgkkfDOvnUAdw
Message-ID: <CAG18JnwT1P6W6AwQX0nKDiGTBtObzVXNO7RgO2B-ipnC3D4xGg@mail.gmail.com>
Subject: Re: [PATCH RESEND] mm/vmscan: remove redundant folio_test_swapbacked()
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: oc64bycu6t7i8s5k7i3nre5b58bhsz68
X-Rspam-User: 
X-Rspamd-Queue-Id: D27D91A0004
X-Rspamd-Server: rspam02
X-HE-Tag: 1754940101-825686
X-HE-Meta: U2FsdGVkX1/TTT+f65iizIaqfR7yZCm9svbpbtXoyqsMCB7Vf10HRYQJoqXd/zYzyfmTgvrfmlzoXvsjCygj4WRNCnqh+85oqXRPBEG5Yuf/+kvze5yHpNIuhBZAlR26aZS5XQxZt0ue96ZnVQlpAGXuRoxknrGrfUJgOXBD37i3bbrxJk0MnjGTz/ocNT/blOSP0ypAUM/jCl/Vw7AZY3fN/bh124E6v7qTDcsJ0k/6Czzk4x8epUBIvK7nMZp2JXcE9hlSIlqGMR96I/s3i5Eoc+p6uMjTJz36z2wV/WMcpRAI3l52HSDMy3/1m0X0GW25Z7B0AObKPa7+5tWRAin+gotlnVv96mscXdaAN/6Q0APtInVFSIbhIp/lt5Q5Tc3NlguEAEbClb4QBqngA1b7vX1/VxSm7UwNZoP1WpIpc9ZSllvn5D9AhVGNvHHQnta3Aa6XfQ+DPqvOxadkkbXWBRzowPx+ek5qjtbGfuTWiVQdELsox8hCsTDLA6yCY9mncun+NhSX5EUj4Sf/hxXFrKT9l5NX6AAThFPEe0is/0HhFWpYUjuMmnyXAXfYPqk9zXkxQDbxgctuF93iKopLbkpFniaYyHGy/PTtjRQsQA1T3R5UmDMVEIbYR4DloH0ijnIXS5Dl2M3P/Cp1u0h0V3j37x0QCXWQQz8POir5WLUl818A2yY727yJoXVSp6v/J+B4F9ODBXMj53UNV+JyDXq3GA7bLHHkVFNutPQA7DH4lF+jl8zXlcPb1jgnplWpYNb3KQKt4Sik+bfyEyt9/yajafUBQ9uK1/cxUNsrKtZ2HZwUsZE2djIvoi39TrM4XTVPGrt633OlfTfuvRLi0gOit/dB5FbdKg5nMrzn3hEIZ4HVa/xpIGC8hmYDSHkPdTirios6lEUG9W5Q8pzb7PDZLXkybBfAU2J0+o29bKa8PcHT8yzNOidSOhvlii6gZKqCsZ9w0ouRr1F
 r3SKp/k2
 whCAf+0y0IAKYGkc+XEVohzCIqgZ7aKDct+rXU3H4SwL4BW/edQFVGuoavng/XZmzuh3ow96+zNJdkR7AhXxgJolmQGMtz3GB8Ob4ZWQ6FIn7leAyh4wyvj4ZIxCnIe5/akPx5SC9BVuIYbsQz0IBrMaKv5P+lToRyA4ENbPpkgllgXq8qtVCERwr3R+6ws7v/ZXTm3446uEVCd+zyXntrGaz3facTpb7YEC5JJy29s9xZfqe/+4Hap12Sk3nBTE0+Ow1ErlTUkEJ0N3PljLIhU2xHEkcP7LHeJABbCkE3Nhi2dhoMRYo2xbLlGleR1CVmZer0I5zeWs+jPAKL+GPMZc8XxHRF0kfeA0oJqxB18ePzSJPijduz5Vp2i9tZ1ZoFd7oxx+CCKjbz81rdHMi4tyrRELp1ktGDZF5JnRL0RsFQ0skHdEehTjFwlnEy84Vpek1GZ9YthFtKFSyDonWfl355VfKfnUzKJH4HtbwdiALoww2vwdP6/Own3VMVQ9mUhSnEKQ5qwnPu6qj+fGcZkBBLDublGibZ0zhP9t5Oskot/vUmtTQPQA4rwiPDovUBaoqUleFq4R9I3ougFTov28282o7ldDKZzz6FXQzsvm+byyxF2dB+nGduw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 12, 2025 at 2:53=E2=80=AFAM Harry Yoo <harry.yoo@oracle.com> wr=
ote:
>
> This is marked as RESEND, but which patch is it a resend of?
> I can=E2=80=99t find the original one.
>
I sent the original one to the wrong mailing list and missed proper cc's, s=
orry.
https://lore.kernel.org/lkml/20250811181839.40336-1-wjl.linux@gmail.com/

> On Tue, Aug 12, 2025 at 02:25:00AM +0800, Jialin Wang wrote:
> > When !folio_is_file_lru(folio) is false, it implies that
> > !folio_test_swapbacked(folio) must be true.
>
> That is not true.
>
This is the definition of folio_is_file_lru() in
include/linux/mm_inline.h line 28:
static inline int folio_is_file_lru(struct folio *folio)
{
return !folio_test_swapbacked(folio);
}

> MADV_FREE pages are anonymous pages that are not swapbacked
> (and thus can be reclaimed without pageout if they are clean).
>
Thanks for the explanation! I'm new to memory management, so this is
really helpful for me to learn.

Best regards,
Jialin Wang

