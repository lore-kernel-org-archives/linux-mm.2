Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 345F5E94120
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 08:05:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F1366B0005; Tue, 30 Dec 2025 03:05:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49EDB6B0089; Tue, 30 Dec 2025 03:05:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AAF96B008A; Tue, 30 Dec 2025 03:05:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 266996B0005
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 03:05:21 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C3481CF0FF
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 08:05:20 +0000 (UTC)
X-FDA: 84275402400.01.6C8D7CE
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf04.hostedemail.com (Postfix) with ESMTP id D799640017
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 08:05:18 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Nho+QAyK;
	spf=pass (imf04.hostedemail.com: domain of wale.zhang.ftd@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=wale.zhang.ftd@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767081918; a=rsa-sha256;
	cv=none;
	b=CKkJlecopbA5/MVpuWI4dvjMI1/6EoUDSbGWA5yxXZKPK5J4V0CqQdXIOA3ZQaGGPm+bGT
	PZGzVsmbXat6l23+XUeX4y1eDMJPTpdCKxcN2JGvVzFgDuXqGo22Av8/DsAGLMqIypAsIx
	Y3b7SDOXJl8qwpa9tFZIvUBLtt+2hyA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Nho+QAyK;
	spf=pass (imf04.hostedemail.com: domain of wale.zhang.ftd@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=wale.zhang.ftd@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767081918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SIbXKdPrLAVqz0MWdKLpFgImpBb3x9UQKjRYKI7ZRNw=;
	b=XYCG4eKbr0U2NQq3NMs8udM+kQ47ESOmXRJu1FrDmFRzO+WacBOpaf1JN6WVeDADYFX7IW
	0b0OiNNR9HfInhVZ7Erj4a1lJ/tm4lvajcDQcicPT3l6fqh4ExKdspiTO6npeB90K8bz1m
	z1CBBe1wqt9GvmxBSzddz9k2Ii4JNaI=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b736ffc531fso1770331766b.1
        for <linux-mm@kvack.org>; Tue, 30 Dec 2025 00:05:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767081917; x=1767686717; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SIbXKdPrLAVqz0MWdKLpFgImpBb3x9UQKjRYKI7ZRNw=;
        b=Nho+QAyK2rMPf+zO2DVLDaMu70kQ9d6O8buSLlTUKPlOgk4/tY6MaUraJ5ZwZKTQEd
         +/x9SexhqHBvMr176NbtPUZG9JVv2aXwUkj65/IdpJE/kE+PK5ICa6888n2EYrAkZtlK
         wgOFtFICND/dVI3jQaXbgLt7e4Ogzf8E6P0du0Kwkv1gbWYcFQQjv3Tv35t/LRh6vLmt
         kBM+61v7cl0J8g1nlOgOuqiuc6O+J4SUbzPF+PP/hi/m7jnMbR0LxXtvJarcarT+Yanj
         GNkeBHbtHV5b8lGlo+mG7DRm6uLFALf1IpGTH+yXch0GyAfwIhwP53KmKsNS68CiSBEs
         xOHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767081917; x=1767686717;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SIbXKdPrLAVqz0MWdKLpFgImpBb3x9UQKjRYKI7ZRNw=;
        b=Nce3e6Wy+3wfKFUAhXvHIz6UN9lxnhLPj8slTLmIPGv/MIpfgnMzj/SVWFbzIREbpm
         6FUZWSoNSwz7bsZoDG8M5lEa7tGo/Xh85BcnfXEGb2k+xSb7MdpKtqbOD0yOE1uoIn07
         XHCPOgyjJ5bW8emaEDxERV1e8fXCuccmgtkZ2GNCs6cRVKtjGy4G25gGpDFTY4fUsE+m
         5sDT5sEGCiZ3n2I7/yYVe8gYGOrShnzef2Idn9gIKTVcN0hzeSGPusK72KTWBDiWdiD2
         J8p3H29VeLM2AL1FSQh//I4kOdrQiF8dzC963BIMJbmUHOErRF4xRuVyreklLjuj/psI
         PKzg==
X-Forwarded-Encrypted: i=1; AJvYcCVhKWBr9eUTGNplubilH4sKtKzUlsQeOLcpKTD9JqaBkALCiC1Qc8k4oRy+VKYVQ/owvJJqz349Ug==@kvack.org
X-Gm-Message-State: AOJu0Yxgr80IjVvE/9yk2QOCvUdHmqL6+GYF+LLs8ZbADIRqPiLjx6Nc
	zQipT7MauENspK3axn3h1KnkqEa8DbnqIc0YGh/Pu4BmwTQ/1keupn78Ioi6JsheqmLsW4qTtU4
	buatHI1gLkqG7n9qsN6mSy3fGm20Oy7o=
X-Gm-Gg: AY/fxX7j/iwpLjtZJuxoPIbJ8jBJGgSERGzaUJolNhMJU+JshR4PMmicP881r64VmtM
	Kz8I6FjxZxb7QJmgh+dZXOu8Y44CgWNAPANlapuTfOZLlOuTPGwWi0RbKTPQH1SpHagP5y2zi17
	NnVHpgEOi0pVvQnCrNJaNCJkhAS7bp8PqOc1qMMHIRv/2RhFCIX/dPkCK9+3xPnB/oIS17WE8Zm
	4HbFH8nf47c4tU3WsI+sylYCBmO7Sx3cGpe5/90XwI3Nn7AcPFUxXI84o82iJCpRxP9GmElv2ZH
	N2GVJrM=
X-Google-Smtp-Source: AGHT+IF4cUwUcAv2slzqJcuj/I6eRah1Eq40JyNFo5eIt+T/iEHNR/b7lKndSa7QV1+mko7uZ5hDHO1628GB6HSba4g=
X-Received: by 2002:a17:907:962a:b0:b83:2af7:372a with SMTP id
 a640c23a62f3a-b832af73869mr1428183366b.41.1767081916908; Tue, 30 Dec 2025
 00:05:16 -0800 (PST)
MIME-Version: 1.0
References: <20251225094057.286954-1-wale.zhang.ftd@gmail.com>
 <CAGsJ_4yEAOxUmrPvca3Nzc-OB0+xXk5Y5gzszsY5TPqHCGvgcQ@mail.gmail.com>
 <CAHrEdetNrGJbogkhMKY-25fgtxupPxKKLkwFGuenV8p5EwzZVQ@mail.gmail.com> <aVNccyCxjCPRjJiS@casper.infradead.org>
In-Reply-To: <aVNccyCxjCPRjJiS@casper.infradead.org>
From: wale zhang <wale.zhang.ftd@gmail.com>
Date: Tue, 30 Dec 2025 16:05:04 +0800
X-Gm-Features: AQt7F2ogVOs76D0YXE_GIhC7pYhD1LHahrzZOO57-qjHBviaosudg0-kBbayvnA
Message-ID: <CAHrEdes6Usi0Amc0mf_1ZZ4MLbTxWYor9bjNOm9v7GNx8DMMxA@mail.gmail.com>
Subject: Re: [PATCH 1/1] mm,swapops: Fix compile error on set_pmd_migration_entry.
To: Matthew Wilcox <willy@infradead.org>
Cc: Barry Song <21cnbao@gmail.com>, akpm@linux-foundation.org, 
	lorenzo.stoakes@oracle.com, chrisl@kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: D799640017
X-Rspamd-Server: rspam04
X-Stat-Signature: reonk7fxbi391isy9c1b34qkm6qcb75n
X-HE-Tag: 1767081918-664926
X-HE-Meta: U2FsdGVkX1/SSKPoljx7f1cb4LgFIAp4rXY4b9ZJnw512VAym1J0L9aBi9JzZ1MYFn87v/arSjq3045q7H+0sJC3qbJFbTmRftLdVqfroyQkGoXoMIF94KOGWA3jJpK6njk5In+nBKqgS+ESy5Pqkzvoi0yQB8KHtKCUzkXaVAdpgIvphV9dfMB51inbTYJooONpRwqx+mAb6t2QWKpG+61KSA3szCTo01liDhEyTIbejv+LzL0YShF0XgctnB1Rmm+jev0BJkDOyFxZCeBIYQhINajNxP0GEwoYUqJyWvYy6RtOPgBhtrJQrpDxEyknyKeVQzS7GK1ayF6dNgTJFwLxBYNwym4ZWvPl749QxYNqRb7lMJlio5udAUhgiNDX7cwUQZO0oLEvEQcf4toeS1T9LSw6z2j9D6P6fE+hhw7WJwzM257U8Ziu4HpgMJF1Um3eguWFg/cQ1nd2spc5m0X6Cgx6uGwdpX91+xC0Mm+64AcEZYazVsjKFQgrojlJCZo8MGFISL71aQn09g9dndRZOfaKReA6JC3ZC+p4EJXOEFK1f0+P18KHGq+bg1+cUPzyUtmC6ocXH9th1l3CtagStyV1wotlCAq3LggN5knyzCQyMlUPddp23RS6kO/mUK1+XnX1GYRfdVxydQ7nknxyy1ch+VutIceDsg9f1OYyhAj5nECchbKZtMEY5rphv3VlIt3gsi1onZdEHppcxfr8ezoZdBIluhDdXg+XRTDPGd5XcPwzmLysbOml2xbKIwHAesfnUrlZykBSaAYxSVVKzBPdrb4yt7Y4F4RcllMQKk9WxFMEHpk8ev7En298yqS4uobMtiub5xnk8T84wuF9/39sx+PeumGr3yvpIf245sQROe2qnqu9bQWcGmcSO3lyhJurYZyAI5F1nh1NlcSk5I9V/7m0JzcYswwB0YUfa4KVDGAmdX7gYU44WHAEtKKGWs+zJzvQcthBmmf
 IJ0qMZma
 mpCIGwancro0ReHyymPJFb7/yvJ6vGf7DzbFrNrItCGlw2zAi7IRGNKYz3Brtzu9oVMSpYH9oyTzYIQR2YLB71AJKvbtUAtxlFNz3WO/4V+a/E3KecG7S6/mwntISXeV2Al40FnYm/+SO55LJ91vjPaPqieLrDAhQY7VMEy129r0C5wBpAhyWmVUJlJcaf6FjuKGgHDvbu2mVcvZ494JgpIxxi35wflwhWrzIyiuOo+9IsGD27JnjP9kuEQqtWbYe6KAwXKsdMi1YMz/gX1/DiZ79emWgVH3SXFYtNvaTB1QLXL3I6DVFzPSD0Vw6dzdfOT5y7SSB4WxVZabH7DWjWkRft8KZV8PgrPsNoC3a2Al6h3i04+RZ9vUqPHxU6digDlbuu8coHL5BTkBJnQR+GqrUTvVE9nFQtZSEL6XzLYajzU3J6B2OaJC3W9Wysf1gyixdKwmVq0K1VnxZkgtAtZ7ls/4XRwRyAuUVEn56bSPUpWg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 30, 2025 at 1:00=E2=80=AFPM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Fri, Dec 26, 2025 at 07:45:48PM +0800, wale zhang wrote:
> > I compile the 6.19-rc2 for arm64 with -O0, this kind of error log will =
appear.
>
> I don't think we support compilation with -O0.  Why did you think this
> would work, and why did you think this was a good idea?

Hello Matthew,

Compilation with -O0 is mainly for beginners to learn and debug.
I don't want to encounter the same problems every time I pull the
latest code. Perhaps other people will also encounter the same
problem.

And I see that include/linux/pgtable.h has the same usage.
 320 static inline int pmdp_set_access_flags(struct vm_area_struct *vma,
 321                                         unsigned long address, pmd_t *=
pmdp,
 322                                         pmd_t entry, int dirty)
 323 {
 324         BUILD_BUG();
 325         return 0;
 326 }

Thanks
Wale

