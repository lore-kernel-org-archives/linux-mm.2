Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B228CCD193
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 05:39:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0D158E0003; Thu, 23 Oct 2025 01:39:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBD958E0002; Thu, 23 Oct 2025 01:39:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AACDD8E0003; Thu, 23 Oct 2025 01:39:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 955558E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 01:39:54 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 493D348DFC
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 05:39:54 +0000 (UTC)
X-FDA: 84028277508.17.FA4A948
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf26.hostedemail.com (Postfix) with ESMTP id 73365140006
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 05:39:52 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lVbAATW1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.178 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761197992; a=rsa-sha256;
	cv=none;
	b=14/Iq5ppzuCh9hjMkBRaQOMi8LZNPLGXH5s6/Mtj3ScjBxWXKoSXsTsxph4z+41RjcxGD7
	/mAvG5khGN7tZsaTxYBe3+W/vIlUZohNYhkOzCkgOJbzCtpSC/FEwNMicOBN/cU0h8mBS8
	2CECVOeHF+uOYCprcj589Ad1gJ7b468=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lVbAATW1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.178 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761197992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FsKIh8Sr2YempVn4RfoujlQjHMyiuNGVB5flJcwQHSo=;
	b=TfvNPgw7AA3rSw2sMPEQAGqRwV8E7JRRqHb0wnnJEPJ4embq+HTyAJ14XST91OtNKdgHli
	hoTcG8F1RD2KmsmVmbZXZ26dR4qGmvNpIMOC5HP64LdLht3ewsChoTPzzEV1Y+CiYv792J
	76P9cSr8sm0rD+lqYVTIjFf8NnNlDrQ=
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-88f239686f2so42399285a.0
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 22:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761197991; x=1761802791; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FsKIh8Sr2YempVn4RfoujlQjHMyiuNGVB5flJcwQHSo=;
        b=lVbAATW1j6dqnhW1OZa6VZY8pxkW/P7VymDb5xu2doJHodalWJpLE3tL7sUBAc4n+Q
         ewQib6yHGWYwtwsSt6mTZz1b6r7G+K75NOXD05VSlMRoBjAAmqPsD5U+xM5RObse5bq6
         fUevsBXq9mVI3j0yoanrqRLXbTG6FdJ/VpU68mzdA+NQB9OqlI2icDFWoxBzG4+tIIgp
         u6WtKK4tB6U9PDxHSr8ApC6fgCIwHu12HFN0ggYmzGs1+IjyGgXv/nDqy/Y8xzSsoUNt
         kr6kDEkCF6FnJnOyoAoon1epHezmrW0iQK5lrHMfQYQuFSkToWp7fcCzOBrtlUTDaYJE
         IVbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761197991; x=1761802791;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FsKIh8Sr2YempVn4RfoujlQjHMyiuNGVB5flJcwQHSo=;
        b=fY6W1Ji7pGwVeg5zIw112ta5AUMcYLnImlFw5B67hWATcdLpztc4eiWu69mdVDmSvt
         Ytf+40qhEdRLUVsf1M/XHPudFtwu57PQ/q543O4LFADaWzKSfJClnFohHBXE6w6kyR3n
         FLqk6e8UA27B+AFGC+8A8uiShGm07PNZT4/hCE5ZeMTHb2hVLW11KpWalkQcvyj8w0oN
         h4AFwE02de0ZL5xMFjQ7x/QnXui34USgsJRe6G+gCieoMPn5VyLCsEAB2mZPFtWEPlT5
         i4ffhkJk15NXa+5nCj9GtWSVq7O88ofMydMLn+noTIyRuSXJq9U5gnGKLzZpQau8IBKZ
         eQkA==
X-Forwarded-Encrypted: i=1; AJvYcCVJwRis6axrQyBkMbRkuZhpuc2mKImSpLckSuEHLKhl/fQw+8ZmUIdjS6royHskhHGyOUgNXrO4LQ==@kvack.org
X-Gm-Message-State: AOJu0YzDji9eH+SE3alG9N4x8o+uWeqqAk006zsMpiEQLaBlEHaU0z+G
	DjLmmYsoorJQo6HbhzXAZFQNLMxUkaukNqMwDW81PFJU7VjAPQwkgx8gJIKBlrC7aQYMfIDfsug
	cPc68m6fWOTHLoc0+p+6+Rtv1MkGQyoA=
X-Gm-Gg: ASbGncuPt8zNlRhMjMC5s9wT2JW4IUdT0LF2jZXtG3lasCVaWO+LvlH9tCKlfNrKz+6
	KzCQPs1bjwbU6RF6dfdIIVnqptr++LzBiRhTA8OdKZIccOLeMYm6a6dcpaA1DIfKCtvpI0RdWJP
	OG9TZjQr7pq9hpnq/KKPUiJX6Oq6Sb7A3MiQj51dKFoylV0wqI9Ekah5j5dujEJ/5HjlrwUQqgO
	fSPME3bFyVgs+qLpfZV19ixqai6s+zlHtg+OMm8OyzJbh+d2qMFEQizADmKKxQEiG5xEI2lYnnE
	tBabA0l1lNjxMk4l
X-Google-Smtp-Source: AGHT+IFTcAOtXGOZhl7XZO47Jw5as7yHXv1okWMKdwokC78k4R5PlQjBIcNv/sxneXQntHqjozJlsExm4jwJsJf+GKs=
X-Received: by 2002:a05:620a:2990:b0:82e:ce61:f840 with SMTP id
 af79cd13be357-89070fc102bmr2871005985a.84.1761197991234; Wed, 22 Oct 2025
 22:39:51 -0700 (PDT)
MIME-Version: 1.0
References: <20251013092038.6963-1-ying.huang@linux.alibaba.com>
 <20251013092038.6963-3-ying.huang@linux.alibaba.com> <CAGsJ_4xaA8QRjP9H=n1hQfEfGop7vOd5Y=J+KQzuOyfa8GK-kQ@mail.gmail.com>
 <87a51jfl44.fsf@DESKTOP-5N7EMDA> <CAGsJ_4zPH0fwBOLQwh1y6jG3tCXHLGRCTyVVSCWb+NfLCEMV0Q@mail.gmail.com>
 <871pmv9unr.fsf@DESKTOP-5N7EMDA> <CAGsJ_4zW6ogVdi=t9JCuvGD9N21mA_ORXRCakw4Av68d9n+DDw@mail.gmail.com>
 <875xc78es0.fsf@DESKTOP-5N7EMDA> <CAGsJ_4zKGS-Xd-58ufXGoyRfaZWd8wTgv0b6ibHJ2aS14mQqtw@mail.gmail.com>
 <87a51j6zg7.fsf@DESKTOP-5N7EMDA> <CAGsJ_4y32i3aNYPum=8J3_Kt6vOSisr_jg6btB-YG1uQBqHG7Q@mail.gmail.com>
 <87ms5j4444.fsf@DESKTOP-5N7EMDA> <CAGsJ_4xhJSLnXOZy4kPmnif5Paq+OPN_Ww+rPk2WO4-ADSC0Yw@mail.gmail.com>
 <87qzuu1kg2.fsf@DESKTOP-5N7EMDA>
In-Reply-To: <87qzuu1kg2.fsf@DESKTOP-5N7EMDA>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 23 Oct 2025 18:39:39 +1300
X-Gm-Features: AS18NWDKv8WT7U0pZbWb-8Jorrgh3QZSKh6u4PKNw3UoBHBCpCMmg3gw3nK3q9o
Message-ID: <CAGsJ_4z7SASir4gWThfePdnvw82TB8E6rXnzJ=CieaFnJpJt7g@mail.gmail.com>
Subject: Re: [PATCH -v2 2/2] arm64, tlbflush: don't TLBI broadcast if page
 reused in write fault
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Yang Shi <yang@os.amperecomputing.com>, "Christoph Lameter (Ampere)" <cl@gentwo.org>, Dev Jain <dev.jain@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Yicong Yang <yangyicong@hisilicon.com>, 
	Kefeng Wang <wangkefeng.wang@huawei.com>, Kevin Brodsky <kevin.brodsky@arm.com>, 
	Yin Fengwei <fengwei_yin@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: q67bs6krkjkorz9eeh6khorxzxow18my
X-Rspamd-Queue-Id: 73365140006
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761197992-522408
X-HE-Meta: U2FsdGVkX1+UaQ4fiUJapV4Q96CN3TmldIs1ixObkEBEKxk3OL4yM8RQX4lW7XAh2dTEP/FCeQduuipQVCKkj2NnZYs/38CKn1AzOiwJSVqGUNCSyWdYWXPUv/KdH7Ftngmar5ppwVOzSIxsKRuaEegJUyqW/OpSStyAt9cc6e3fXkKTfYICy0M36LNrwmey2nzZu4YABe81O/jnupUpCcN7+MMboaJ/mlNqGhu6SUQjsdjWQl/aDfghm9FZzcVst+z+aLpMXBQsyTqALydU2cqNuMpImWXPdGMnP8nlCbSxH63H02OQ/YZyyrwfvY380gL+3ORCidzsYJdf5uWcA9XMoIA/ZxqJH1T6Jb8Lr8Urkx+KS3Pmw+brusCycHnrlqdiE1gI965FxPw+WEAN84XSvpcorZ1kNUPqc7hvs1WEQkotrLGn7coitNM+7uIdcg15ERYyZ4Ror672XCZtfyVBvnreYuZ5/pLYqChISL/1d3sR+iyZEC7XNF0O27PAwU/o6MISB14tkXZohlsqNL8KlXJHbwnXckOLkNp832rvvh0FkbVY3Ch/u5e9Zc4wYihbr40EtuzprD4E3qf4yu0jw9/dk+1KKR3aePXGnS9YdijSQ1ZAZT15Rk0FfbzFxbXGyXVdEoaGshqkml77gHUSxV0erDe+QbSoDdeWnaHcVpkl3RXkyjkjZDEMVUA/+f70x76w+EdNO8Pmuvlqqddw7DfNS7CP1xBwEWSWMkkemNOXCarrdWzjfmj6JlFA40GqWTaN1x1QImt60/umy+z4jO9CVCmb93qCrfn/xbF7qoEY+D1AsGLA0/MbRnjc/IaIUUNUoGXTLPI3tUNJ5RFijaWyrnmkaWGm7M+tRD4Kbfw5UwLQE3M9tpLVPYTXU5dWtv5E8G0Na9P33cS9m5Ks1D77D3kijAIyKzR03dB9Lrs01+41mfutpY9RT16L+CzUFkx/ssyO1S2l+eA
 sAsd5HeH
 nVKhwYuL7jOcivkJonXnK5IW7bYVBeCyVND42vhypyFEMxLvsaEroWa9CQxZ9fxzjDlTkr77e+uY3/PibgFx2r78BXlFgiaM0hH1Fe5EAyiBqsGVvr2LkqmsfHHk/V0M+rWII94hOsLxMqWsSVwiVedEFYzok40iv4b/HOZIRzih6RN92cNDjXw2kbbmO32AeDP7KKle2LwawqglKg0XY3DL9MFcpCMQNUqOFGe4XsdOey8VWjr0tT+D8jWut2PVgi2NA3FHSsvBJidDQKKU0/equQXEqcDnR3g0XX9SornrgvnrSoNkQs2mWvKeDJzF/zPoDJzBCG74SrAZmX0JI+eySSrAssPmJ2eY9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> >
> > A:
> > write pte
> > don't broadcast pte
> > tlbi
> > don't broadcast tlbi
> >
> > with
> >
> > B:
> > write pte
> > broadcast pte
>
> I suspect that pte will be broadcast, DVM broadcast isn't used for
> the memory coherency IIUC.

I guess you=E2=80=99re right. By =E2=80=9Cbroadcast,=E2=80=9D I actually me=
ant the PTE becoming visible
to other CPUs. With a dsb(ish) before tlbi, other cores=E2=80=99 TLBs can l=
oad the new
PTE after their TLB is shoot down. But as you said, if the hardware doesn=
=E2=80=99t
propagate the updated PTE faster, it doesn=E2=80=99t seem to help reduce pa=
ge faults.

As a side note, I=E2=80=99m curious about the data between dsb(nsh) and dsb=
(ish) on
your platform. Perhaps because the number of CPU cores is small, I didn=E2=
=80=99t see
any noticeable difference between them on phones.

>
> > tlbi
> > don't broadcast tlbi
> >
> > I guess the gain comes from "don't broadcat tlbi" ?
> > With B, we should be able to share many existing code.
>
> Ryan has some plan to reduce the code duplication with the current
> solution.

Ok.

Thanks
Barry

