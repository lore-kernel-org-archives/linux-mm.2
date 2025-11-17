Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B25AECE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 20:17:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1134C8E000F; Mon, 17 Nov 2025 15:17:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C43F8E0002; Mon, 17 Nov 2025 15:17:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF4998E000F; Mon, 17 Nov 2025 15:17:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DC1778E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 15:17:37 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 71824C0271
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 20:17:37 +0000 (UTC)
X-FDA: 84121209354.05.A73DBD9
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf08.hostedemail.com (Postfix) with ESMTP id 45C7C160004
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 20:17:35 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=aaiYvTAC;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763410655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S33O+CF2B1r3tkcDztO9KxprMMVy543GWsitFXBZZIM=;
	b=U7husxhPPrVy28nkDehJMvVpbQv5qlcISGuyJk6K5FTn1h8P7AnlkSKoO/2pP3bUSH7ElR
	EM1yjqsqpAcYRfd/9obLSospd6l3Sy8KgOvthhvnDd6cH0v2OrmAOzYyymqn8ZyfIZYyvi
	wEEssIejeGv+2cnuNXGt7H2gxbZalNs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763410655; a=rsa-sha256;
	cv=none;
	b=cdC3fCi0LYlGFbnhT3VZ4GMqo1CR6hC8if24P2WMYpWkluX2BuGfPk2uwhTg+GiACWHMBp
	/+aO9JWTZ9Bkso6ePQhSRASYd4hPiDlKkYGmrJBYUqJzeZq+aiWjCpRG4QINgZqcY9l7Rn
	LgVuvG0IDSM3cvRQtYOO8fXIFPm33TY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=aaiYvTAC;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-640860f97b5so7651581a12.2
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 12:17:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763410653; x=1764015453; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S33O+CF2B1r3tkcDztO9KxprMMVy543GWsitFXBZZIM=;
        b=aaiYvTACloP+w1eym2ihsTQQnGm5kH85PvTCai9qZL2v/iu39vCqwbTjB4FzIrPdUb
         wrKs7yX6r6jepQPfXBwCmhj9nlnGH/gdpwxoDl+fkSGpOiRlMYE8mBoI6K5cfaGSPjDQ
         O8TFK/QQPBkQrCBLWpL6s/q389+JMCNpN3tWFPwheILyonpYmkJUMzF3H7Eix34XcFgj
         u6DgkwRDNNCCX3ZaOymz/zAoH3pRaj7B8W1GBIxH5vEWNj7g/nj7fp9HubfONWNkrTs2
         eyz36O+X36RLcGuzUyM+1LsEAdtHMRsHcdtkvFcEDAbBwd3J2zOUzQ9k76XJudRBLY+H
         pj6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763410653; x=1764015453;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=S33O+CF2B1r3tkcDztO9KxprMMVy543GWsitFXBZZIM=;
        b=EwHvFrIxWJYQzegm1UamKrn2MSEIQHFyzI7niXrsHojVh7e96aWVn2V2D60nj6DHoL
         N5HdHnOksGUwWqwdV4BQvshq4PdMfUlwWHj+rDuJdqnk+svZ39gk3mGlfsjJCtO9vp2J
         Swjq9EM3nh/39Lw6poxJIbVT/rujEpEy0OrN2CbYPWC13UHkih9YmkqJ7yCTZogdTtjO
         hUo5Vz4SHq76/WIzFH4PxoirJwRSTBCn9iOADyIVcb99OD1QTmi+U4K+a1MvP+b+xW+C
         eI5VGUdB+38C96KSFuZz1SrcZiPlwEc3MBfzTuMzzozM+VKZn1KfRuAqQecPMMC0JCo7
         LQ7w==
X-Forwarded-Encrypted: i=1; AJvYcCVeeO/FvRUtcHbtNBzaJR7zJerM2ytFFUQ4eXFFPyrJMCJos2qvATpObvOBVWZRoRxoYw4Aw3PuUA==@kvack.org
X-Gm-Message-State: AOJu0YwQ0xe5dFc4pDiKzZaq7BBLuXrWWXZJ+Y1MIzOidAkUjtHBuT5W
	XUqFDvYoO3Mm4wB5xIDJ/KFzjavVUFoc0LgSd5nT38aucNCiSH+cMvMBao95yuUgzK/VVDrKIQk
	1A3SJUCQVTpjWrxOkhnTDmZIRWbVhv4FXZli27wcLjg==
X-Gm-Gg: ASbGnctNFXiL3Z4cMoOBmLqPWH/2qsnw27CtTfpOxQxfz1zBhM4oPE7XKz1fVJyNIXi
	qY1n5wqw0/hM7QJ4tN2t/ZPCMiEbrCSgvjpFgHpU8IYm6qnssxabYGuzxn6YvaWWnRIUAfvkK2T
	88cOeJfenK7gyZIUDZP+P7bkqXYIIYDvQ6ECrYp5b+orSFWX1q4/FYMm/NDXihHrDvc86HfuE5m
	aXXoOaKcxQPv51PsQE7wl4Q+9g7DYHWU5takmT+qlmWfw+FjfFmcNvLWJOll9jtAhFS
X-Google-Smtp-Source: AGHT+IFItSdGQdOgeoVWjbSlLG/sP/FZzoFWO1rtvgD6y2lU/+PX1v1prFL+slWcS3blQ8WlJsrEVKQ7VXI5F5genq4=
X-Received: by 2002:a05:6402:50cd:b0:640:ebe3:dd55 with SMTP id
 4fb4d7f45d1cf-64350e04b82mr11009068a12.6.1763410653320; Mon, 17 Nov 2025
 12:17:33 -0800 (PST)
MIME-Version: 1.0
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-18-pasha.tatashin@soleen.com> <CALzav=eskApQk6kstsQWThwV=h4Qmd85kAw3CxZt=6hj=JS-Xw@mail.gmail.com>
In-Reply-To: <CALzav=eskApQk6kstsQWThwV=h4Qmd85kAw3CxZt=6hj=JS-Xw@mail.gmail.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 17 Nov 2025 15:16:56 -0500
X-Gm-Features: AWmQ_bm_MkoZE--tsc-fA0lwBQn6VGwYgaMcS7NtBv5sswRv0JDdatkuBxPFasI
Message-ID: <CA+CK2bD-57sMM1pm9GkdrpRkvk5qCf3CfQ1yr1q=X5+e4dgmoA@mail.gmail.com>
Subject: Re: [PATCH v6 17/20] selftests/liveupdate: Add userspace API selftests
To: David Matlack <dmatlack@google.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com, rppt@kernel.org, 
	rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org, 
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, ojeda@kernel.org, 
	aliceryhl@google.com, masahiroy@kernel.org, akpm@linux-foundation.org, 
	tj@kernel.org, yoann.congal@smile.fr, mmaurer@google.com, 
	roman.gushchin@linux.dev, chenridong@huawei.com, axboe@kernel.dk, 
	mark.rutland@arm.com, jannh@google.com, vincent.guittot@linaro.org, 
	hannes@cmpxchg.org, dan.j.williams@intel.com, david@redhat.com, 
	joel.granados@kernel.org, rostedt@goodmis.org, anna.schumaker@oracle.com, 
	song@kernel.org, linux@weissschuh.net, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-mm@kvack.org, gregkh@linuxfoundation.org, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, rafael@kernel.org, 
	dakr@kernel.org, bartosz.golaszewski@linaro.org, cw00.choi@samsung.com, 
	myungjoo.ham@samsung.com, yesanishhere@gmail.com, Jonathan.Cameron@huawei.com, 
	quic_zijuhu@quicinc.com, aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net, 
	brauner@kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	saeedm@nvidia.com, ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com, skhawaja@google.com, 
	chrisl@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 45C7C160004
X-Stat-Signature: 6cffs7jqiqryrn59xtgaqzznyq76t46y
X-Rspam-User: 
X-HE-Tag: 1763410655-537539
X-HE-Meta: U2FsdGVkX18ZRxnfLDZl8PspDfS1TXx5B2RbHUmRyi7cRsblnD2odkBYIWUWYLEL/8tJz+6k6jdW7jQK0ptwXITBZ0IawJdEy2ZIuQbP01FBWSQisF7zVM36EdYz5dvsPBlxBBw3WunS96PlcecQGS6RdstM86SkqQA/QJL2DQKa/jiPgKdTgqlGj/9ecD6CI8DxE7v/tJlyX9bshZ7U0qPamzQJjAbRreJf6Abk3HVJc2PeT8ZbCvu4taI3HjwBYrB+N8yOV7BgVapeOZlMaN28rlI1jqwIglYPF29Uv7EHJK10lBvwApxLb6HKjZqIm6jdtETN8z1wqbwv368z91zdtxyNJaJqfdH+4psjCr5A+GSv6ZpUfguOnQwiqh0585Il2jNTimaSTV4qz9dI6qxYCAF51RmcB18v7uNIlWKDNhsMjaY7j03F2RHQ6xXGtBRBoUJ/gl3CBhrN2Dg9/2TDz28Y0cDQA05cx5uo0Lh/ijQA47qLY8/DEeSBLz5LjJ4XM2XC5T+Twt8PRQsctmlZe2FY9hcZojvBmP10Hue417y0gefklbjdQ/6MPJPN1dkWhZVEuIXhjafwElScOiE7E0DWnpgTjNrKjLkdDPgpQ4+mEquKHPXSgqX/xg1rhDLkq/dE9VzweanenZzlmV3lZeNxPiMWTM6lUIiZTR//uB9SjZOv1fklhDIEHH1oPA3JDp0R1ioAUluKnCGJsh1x0lhEPm7rGZbGpi+sGFjoF6/SvZXHuhQuxWXsamLOlepMhh+GlgVIpyPv1IKhnTL/1VJkUo+igkCywt/OoAL5d4tYOqYSYCS1WR48z3sxszmF4qKQXFMr7mhabQI67X8dTHK0HQzMU+Yv+2bC/6IGZPSqzsIUmtAKp1W5EH/AqisYwwm0cz899uYfv4fWplIknMYRoU+/SxrZk47duP1OnyEtQp2vQvGGXayGHjBBrsNvP/+60fecuWzfNvH
 xVOP/U2g
 n/ODljkcgnTAO9zR1TxIO3FvbbmFBgQrsqf5uvAurSjmbSMf7g6oydHB/jHd+LGQIKielO89EvDs6iuqUf+b+TxT78tdBd4DzMd1V8gNJ4E05h1s4kR6POQNVCZt6XiZUiWQOPHcPJKbpdZalp9taX5w7dB9DOo/faf7bUx2aakj4kTx3T9/lRM08EfeUVFSFPbnhjj/aKiIAtIkSeBNuqI52XRAIFeaM4RM5zBy2kGz10wAOuajjE6j1jmkyl7kB30yirMiENUOAXH/Az3oI+Ho0shOkIMR7MZXeREGFBWy3tyDqv5VceU0litw39hHiGIlaWkWt81zD2/qEIRTJR90PASlHcwOs3VFGRs0KAekS38lSHgFcCsbPXPjU6jQfWNKRdbqk5v0+n9UG7+/8m2SshJ/W+Vlw3J38IzLpBQ+AIh8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 2:39=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:
>
> On Sat, Nov 15, 2025 at 3:34=E2=80=AFPM Pasha Tatashin
> <pasha.tatashin@soleen.com> wrote:
>
> > diff --git a/tools/testing/selftests/liveupdate/.gitignore b/tools/test=
ing/selftests/liveupdate/.gitignore
> > new file mode 100644
> > index 000000000000..af6e773cf98f
> > --- /dev/null
> > +++ b/tools/testing/selftests/liveupdate/.gitignore
> > @@ -0,0 +1 @@
> > +/liveupdate
>
> I would recommend the following .gitignore so you don't have to keep
> updating it every time there's a new executable or other build
> artifact. This is what we use in the KVM and VFIO selftests.

Good idea, I will do that.

Thanks,
Pasha

>
> # SPDX-License-Identifier: GPL-2.0-only
> *
> !/**/
> !*.c
> !*.h
> !*.S
> !*.sh
> !*.mk
> !.gitignore
> !config
> !Makefile

