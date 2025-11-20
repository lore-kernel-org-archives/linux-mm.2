Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A60A3CFA441
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 19:23:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFC646B000A; Thu, 20 Nov 2025 14:23:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAD036B002D; Thu, 20 Nov 2025 14:23:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9C106B002F; Thu, 20 Nov 2025 14:23:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B18596B000A
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 14:23:32 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 36CDD12E4B8
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 19:23:32 +0000 (UTC)
X-FDA: 84131959464.04.1CF4E88
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf24.hostedemail.com (Postfix) with ESMTP id 478DA180005
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 19:23:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=iIJ8o+t7;
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763666610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CyqJoiBriMQgCPogonFRTQ9rKbbZAaEyFulWYXXm130=;
	b=OeSCGolFUsRtwfVC7qtDWSBUo0xTWhfqEO+1rqLuhb/e41xpG6xKgbP6NDq3h+OJzVsWOt
	SQv6fAj5kZBS4DYsjz/c6z9ZQloNYXDL5sUUlHKrpGb6DcBqnmuYLQluHhthWIKk1S40KN
	N+0YLYpo4GM1RUD7iCRaL/x2NDoigMQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=iIJ8o+t7;
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763666610; a=rsa-sha256;
	cv=none;
	b=PZP8fwRyGpYxF2E5jqAFV9DGdZ4GNKuGHECpfGXGeQj3tfunoVDaeQxUYN7yLU4e1zQz1w
	c01dNCRTR6muxNDY681qlXCY+XJsygx0dlgjC6Ej/IFPnioZJeTDk3cBBFk0ecP1IbBmM8
	o2RhozpWVT5ohTOFLp0JNInPV8rUpME=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-64074f01a6eso2204821a12.2
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 11:23:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763666609; x=1764271409; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CyqJoiBriMQgCPogonFRTQ9rKbbZAaEyFulWYXXm130=;
        b=iIJ8o+t7b6QIhNEyHCyHxZRtZnzg1wReDaXOC4q7GMErW2DPJrDw/5JZPJ3qbRJ5o+
         L2fSG0V2bOOTnGek2yBN5IhbIMkg+NLX0HrujtxSWAlAMqx/QZBsMmTtbojObv0wQ9W5
         GyqW+Cc7NRv6eZuNBXevUnMYg9OOHpRFhuQuKgzT67U9xZfa+98GIPR/tptaUONXepQO
         nwZM3f3dp/t+c3iNkbhO72DeEuBWivNGqQs82nPCD67gzjdRZNjQwxgNSwVfwQlJwFhK
         zrqq+616lVTx74Y6Bt9+9WMkV2OraF7v27JSL6CVxr+Eivd/iy5szZFhVTxbjUf03nft
         ycRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763666609; x=1764271409;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CyqJoiBriMQgCPogonFRTQ9rKbbZAaEyFulWYXXm130=;
        b=eo7v69JbEFlZss0TBMB90qXqZW80Ym9+sNbDxNkJXJm8FEASsWc3O/JYcn8lmBvWAX
         XU6Xt7VTA0iabiKSDlhFf5Gq3ozWeAAzBhD8Ofor/b2076OQR3dFY0OHGCZQm9xeBlk8
         VhPuj2oE+Vdjlnxo7BTNU67W5JZ+P5x9ds+NC2bRo0X5typ+PYOWYwBC/XLeMi/tfgTZ
         4uQbTywow4+RsOenD7zdXYRPW1qQiMY0TJNf8LHwHuIuQmvvjYn4iDqUrUO13b3Eb5n8
         S1BbueyFcbYD2QhBlwU9GY7xr1oBAumIj4bQJP+2U9JRTs+PL4D8oLgBNrq2aflqnuOz
         f40A==
X-Forwarded-Encrypted: i=1; AJvYcCW7Ash+s838jqq8esRED99cMCOyVRJdzAUBCuumYl38VIiGCJRXyWumWPwXlKQFWMfCj34dfb5Acw==@kvack.org
X-Gm-Message-State: AOJu0YznWKR2ILTv4EWrwtbxzwSTLy2JaEdCntnOmZd2rxeGmXvfUTOv
	DsvdHWQyoDkHBVoTlmDD+3YjfJX4EweV1dkR4km3Nnb9Ek7+qVPK6/SLOkZNjBAs0JuH2PnVEj1
	knkxWUTZjzrYj3hTOkiknwCqFds2SfttREtTTZyvzzg==
X-Gm-Gg: ASbGncuaPyRQMsP+9IsNIXoBK8rLQxeH9Q7tXu+Dqczj0+psouOF0dC/1RSrYWusWr4
	SqvvEeXKjhNY1e4cIRRNNRddPehwW83dpnq9KeJ9jIV6czyxYzOSUYSTgejrqOw2vBcOmJd2Zdm
	EAdYLkAZjp3OkfWqK9hbE7MH6fd+Y670Ow6J3vhn4Owq1Qk0+d/GuC6/wMwhBN2Hm0ZFBNaf+yN
	KAJTTc8nXf0zIG9hogz7/a99ToJIo8HZbIIhhN3HHMoWVnneoJHj4hTWd1c+/nh9yYi
X-Google-Smtp-Source: AGHT+IGJIRbNGCteCBItzQRTIq/UH9PLUTffzANE/lniZXOm3tJP5jtVCSVDjBc5RQYSOrk0+uvnxuTU46FVfmAnAaA=
X-Received: by 2002:a05:6402:34c7:b0:641:4b82:10c9 with SMTP id
 4fb4d7f45d1cf-64536450b6dmr3933635a12.27.1763666608422; Thu, 20 Nov 2025
 11:23:28 -0800 (PST)
MIME-Version: 1.0
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-6-pasha.tatashin@soleen.com> <CALzav=c-KJg8q8-4EaDC1M+GErTCiRKtn5qRbh1wa08zJ0N4ng@mail.gmail.com>
In-Reply-To: <CALzav=c-KJg8q8-4EaDC1M+GErTCiRKtn5qRbh1wa08zJ0N4ng@mail.gmail.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 20 Nov 2025 14:22:50 -0500
X-Gm-Features: AWmQ_bmAzBC36YkUhEhsUvaEIh48LIbtssnzB0dTWcGpqHev3pMUQm9n-Tz4Sts
Message-ID: <CA+CK2bD4Y3CMHcTGKradmv-hAbdtA7zsw2CYeh7-8LNianYMZw@mail.gmail.com>
Subject: Re: [PATCH v6 05/20] liveupdate: luo_ioctl: add user interface
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
X-Rspamd-Queue-Id: 478DA180005
X-Stat-Signature: bdqxxw1t9fc6zx7xoiric1zqkn1z97s3
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763666610-492526
X-HE-Meta: U2FsdGVkX19CVu0+vi2VHsHBiPFL93w3xPgxESQbLNOd0mMKb+pJNlAGJgYHdYLRFH8gi4nZFZ9Wqe4FMxWeYXniklTcRsz0FWYIzx1CMa/5chxcLwqB1ZxBrpfx0NlXYdYXdQC+sfPKYieYLzIgaPvQdl1tQR/Nf8KMkC8ygamoyE0UfhrBR87jxt8fuh3pZNQjOAzCOKQRTL9Uc0Ot4DDd3G24XaeXPX5QZUHtFE7Ub+3CRk9HbCOYer8DgOxv1oN5yfpTtNW3318h4VU/YwkiOED2uJQGZbNpjcHvGsRBERaqaKojYNZtQe/49qRdzckgT0seem/tVdieRQRAkV+94B7QvCbbAuDnyqa6YDWn+e+YZzApOs/Cv6K+gt2gDRrlVGFWrBi9kMpXz9Tt/GIfzIAPbp09FRf08Ch9W489CvzG22HDPjJwi/iTaxFNO4HXkw+VCWOFnmblXNPHa0cUdSSk4Fa6HB7xQvoZTSGcbbtuVV1Amc8Y8P0FhYa1zTD8jSxZsyZjYAHWI+w/Wr8e/0OwV8+hnJdKNHBd0aZPmNSoPYiqKwwI8OCLTK0cxBUQrIAvgawUK/ybL4PQ0IaZbyQsawCoQ/lMf5FZD07gUbjI0ZbDwso1L2mOn+kCRxNxvzzZMhYVCWXHolBmkd0qIPRtdWsIJ/EIBoKhzdoqx2dly4bnFkK2xvK+FF7mSo9I8w/jwUEqcr0KDMLIDlehys3OJC/cgGrPCz7i/DF0WNJrjbQyAs6aO1h8f1gHGwMzpGRJGJWTxVM/z5HOK30wOEpJyZihTxmWr1DnXI4wEr7V8VY/Beaz05L3faXGmOvdqwF7anW4NYtcFu7k4fmZQKlpHziTskJzCfJTLVG6u3C+t6vHAhDh6IoP2Dysy4HI2KONlKOUHLu0IHFBkcfm23M6SxhyQtKFegwUH6NESM90fqFg+PNeTZUgyr8Lr1a20MF0gh0CySHzp0p
 YSwGB8dA
 HdEyUO5MyDpZvoVehtL4m83uRAIpvmJcv93+7SiR8oVl4HpbB7sjYHmRlbfKdKMFTxV+SaxYxO4ubhxLk+b2nej/s38fz4o28MhrAp9Z3jTjW0t2UC1Q0pu1FAq4QQ52xMg49Lw7XeTisBJMV/V27PEuYzob+X+h5J+oyHm9vqDuWT5HDe5XGKCzD+/KqqgqozRAR24r9Vifo6TlZWnAxN6KVWYB4FYBz7tno6/RInqCtLIRGqcNphksIC7JfB3D8lbdZwnFDIZDwgQmte4HFQrp6tgnXX1DuOI2J4qvYeVWJwlP1eHN+bgXto6pOtPVoyLVNxWRRw2/KVQkbkyIN+bKp3MnDzs01Cei2yLkYKk4py+QHTLUJaqDB77dwr6PkUUYFh2/JAvtW9Nk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 20, 2025 at 1:38=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:
>
> On Sat, Nov 15, 2025 at 3:34=E2=80=AFPM Pasha Tatashin
> <pasha.tatashin@soleen.com> wrote:
> > The idea is that there is going to be a single userspace agent driving
> > the live update, therefore, only a single process can ever hold this
> > device opened at a time.
> ...
> > +static int luo_open(struct inode *inodep, struct file *filep)
> > +{
> > +       struct luo_device_state *ldev =3D container_of(filep->private_d=
ata,
> > +                                                    struct luo_device_=
state,
> > +                                                    miscdev);
> > +
> > +       if (atomic_cmpxchg(&ldev->in_use, 0, 1))
> > +               return -EBUSY;
>
> Can you remind me why the kernel needs to enforce this? What would be
> wrong or unsafe from the kernel perspective if there were multiple
> userspace agents holding open files for /dev/liveupdate, each with
> their own sessions?

By enforcing a singleton, we will ensure a consistent view for tooling
like luoadm (which will track incoming/outgoing sessions, UUIDs, etc.)
and prevent conflicting commands regarding the transition state.

This is not a bottleneck because the vast majority of the work
(preserving devicse/memory) is handled via the individual Session FDs.
Also, since sessions persist even if /dev/liveupdate is closed, we
allow the agent upgrade, or crashing without requiring concurrent
access.

Pasha

