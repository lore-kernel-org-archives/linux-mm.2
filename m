Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F4BFCFD316
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 03:14:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 501B66B000E; Sun, 23 Nov 2025 22:14:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B2386B0012; Sun, 23 Nov 2025 22:14:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A10B6B0022; Sun, 23 Nov 2025 22:14:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 21D2A6B0012
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 22:14:22 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6305712F279
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 03:14:19 +0000 (UTC)
X-FDA: 84144032238.19.5264FB6
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7EC3EA0004
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 03:14:17 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=KQ7AdBRn;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763954057; a=rsa-sha256;
	cv=none;
	b=kIE28lzcpdMq/v1WXpFL1iwRxJVBzuHwecCMz2p9Gwt+FjzCCcYshJmChrFbP/1WWN1gCh
	RfOmJmsBiLDRueKSMiJIQrLPvIxHo3pfhweEG1FdVF1lgXwfpUzF05+T930/Qpox1HN4E6
	PTqHS7lOJUqp2BB9hqfR+n2o9rkN8r0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=KQ7AdBRn;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763954057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZxWYYzGvXb7lNtyybtYmnOldPsxEU1v86JbAWbqU92g=;
	b=Dh2KxSCEyDVKSS0I0fnisgmEh9NXdq6uCpU/6ywEMpmfQDcDM2I1bQs7mFaESedzOJ+MHl
	OFSoIDV0JaOb5zpBz/uOmjqcA/Lf758R0K8wIIW7SG8xTG/yGjmaIDbICyZKYh+Y8AnIAY
	HFp+0AmlpoJh7MypKRy2oc4jbpanJVI=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6408f9cb1dcso5627297a12.3
        for <linux-mm@kvack.org>; Sun, 23 Nov 2025 19:14:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763954056; x=1764558856; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZxWYYzGvXb7lNtyybtYmnOldPsxEU1v86JbAWbqU92g=;
        b=KQ7AdBRnFT0T/lerdrQsXIpS2xRy49UVZdx95YWmy3sHhEZb18+EA1TKwM70jD8XJv
         ktjDA9unrDMchQgsEz+aBFGcLECeeC5beNncVw9ac6XNPRoWTJJyMuFh4A28N5nKCSY5
         cdeLnPHCRpfoZiq3x2jWLrZ2vLQUunlVllyn/KmSCsFUEJ55gRHls3l4LKTgxT1UWJNe
         hU0QGvtz0G9rn68qjGFLMhYQt888ft5ZPfdXycz0if4iTyH3AjD/8QLAhu85VGmgAkSn
         YgLew1KF1sTY8oX2DM8KPmh9ltPu0r0nF8Dy0olPDeGh0vSvIMkI3PoA5zL5eieYLXrc
         vpKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763954056; x=1764558856;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZxWYYzGvXb7lNtyybtYmnOldPsxEU1v86JbAWbqU92g=;
        b=jqz/6C+kSnXPekdPLBJXJICA30K9U3vjVRN9y9/hyfxLmnRwLASGMiG1BACTiGcuqP
         s9h5ycOG+m6u2wRjcRvh+586/VG85wZMe6DTUvQL5X/rLmfe99az/blEdMevJk34lsZt
         d3plJ+THVYEo2fYaqRtOMwHjlzUN9fX4WFpJ6HC2Z44rJrMgMctm3k7DjhICLlDsRzzb
         ZxB021rBbgU7F/jaLlDud4rzk5QC1Bozbr8cSAbyVtQHHaCBBOsKRZLC/THAKI9uQO+U
         rt9AJDLwkuioFn6Cmz/yOqHpe1cxPS6lW4Xt3WfIqd8cJG6xRibulW0tZkwmhiwsAHfk
         d2Hw==
X-Forwarded-Encrypted: i=1; AJvYcCWhBgwlx2KtPJUknw3T5hAJYmydyEryUeQtcNlNPL+xj40PVjl5/t6NzwKvlVrwJM4tRmMGe7IGKQ==@kvack.org
X-Gm-Message-State: AOJu0YxPZOoJiZ9z25QRrp7HsO/P1eKdgECNWciTzjtunKC2bRjIIfro
	uNgt8fez/5Hidn0IUceCWOOYUcbk8HCSTPQmFfbYRpkrFH3lTj+GbR7L24Woam5vpt49bA8BIKM
	8M07BR7RtC8a8sGD6PluJgbVCaoWsHJOP5RnsI0kZrw==
X-Gm-Gg: ASbGnct8qF86MWxtCfv0cMxwpEw0waTgFdX5hmhxDHHeYNv42pDPmI2ZszJxo1mvVfE
	A9jka6nABaeoZ1ZmL134yXLTaoCpMc4udjfnmwN7XZm7mk4xOgGMHveGLWN/gd1IsLGG2Humy9O
	hE3PayzvF/6d6MVNeqQJ8VJxYMpRap84qBfdE3VK1KmszPESZPAujcqZ8ei1116pkkdyQorIoFW
	bzWFXGpsrvFgd2lep8TfqHt/A7yRORY1mz2DiBgfQYfnAF7GCuC1SCgsDNyJRE7iTGF
X-Google-Smtp-Source: AGHT+IH67JP1UaR3gpoqZ3MrgHkQzMQhpp66V9UPwtAjbwPOvJT5SkZilFWd08WjSbu3wTcfKGr6KSLWlhGvqm+wzqg=
X-Received: by 2002:a05:6402:40c5:b0:640:ebca:e66f with SMTP id
 4fb4d7f45d1cf-6455469272fmr8497105a12.34.1763954055610; Sun, 23 Nov 2025
 19:14:15 -0800 (PST)
MIME-Version: 1.0
References: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
 <20251122222351.1059049-15-pasha.tatashin@soleen.com> <aSMsqD5mB2mHHH9v@kernel.org>
In-Reply-To: <aSMsqD5mB2mHHH9v@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Sun, 23 Nov 2025 22:13:39 -0500
X-Gm-Features: AWmQ_bn9jKi7Ktx8U1VC5NBm-L4AbZd5N5WS8ORgDcSjrzKv7tbGyIW2qlGBRlc
Message-ID: <CA+CK2bCrNC0uYdXbC+JK_bvk8BYFPSL=ZbTZ_T6LMHtoum+Z8Q@mail.gmail.com>
Subject: Re: [PATCH v7 14/22] mm: memfd_luo: allow preserving memfd
To: Mike Rapoport <rppt@kernel.org>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com, 
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net, 
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, 
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org, 
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr, 
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com, 
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com, 
	vincent.guittot@linaro.org, hannes@cmpxchg.org, dan.j.williams@intel.com, 
	david@redhat.com, joel.granados@kernel.org, rostedt@goodmis.org, 
	anna.schumaker@oracle.com, song@kernel.org, linux@weissschuh.net, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, 
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	rafael@kernel.org, dakr@kernel.org, bartosz.golaszewski@linaro.org, 
	cw00.choi@samsung.com, myungjoo.ham@samsung.com, yesanishhere@gmail.com, 
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com, 
	aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net, 
	brauner@kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	saeedm@nvidia.com, ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com, skhawaja@google.com, 
	chrisl@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7EC3EA0004
X-Stat-Signature: itd97chhjtzm5ygnq5pn67fu9qy5rcqd
X-HE-Tag: 1763954057-187334
X-HE-Meta: U2FsdGVkX19hUMZQdvoqI3TkbK8OHIG7lcu9RlPA96YPbzM3vHeRjFyEHovU2+YgB0kFzsH9ocmbvp1NX1IkBXab7V0ikIKzz/4IrSwgDRqyLu2gk8IWc7nC6FgH8bXg9WoYp8RCoP6WlcKfwr5ZPAL2bYAT0oYKEMSAaIR2U0lS7QD8vE1tbRqMBVbWgzdRL5s5MnDlyxVY6qzBNETHCMBoOwH4OZSD5ii4DbCZuUKDB+5sKKHQhWo2GbujM/+7KS/ZSgBjGE3f60k3VC/P/BhsJoJdLO7/TcwCwcb2rPcOhkCPh5OoQGFgit6iiMooGledj5GxrPC3pOKZ774X8lIYl3/YWoyaOra+ztQgPG/nnExm8t10iGiwVveBofJf36zoHlI0jvU+0A/LJNas5blfMBi9OVfRxgPiJZnNkrxI9UsKbTxUts/NiPWKKKEQ7VTTFF3UWhfBhInUtrNqKmDGSTMYNlAif+qtR/PWFDQTbk8VZav/TttTO+empsv1gHl5KEbz0WPF/9Y/kbYLh4qvff1FT3D5/o+YVF2XFJ4Y+7f5yUeljo60cBipBCNuYmOEBkG8fY1ZwdBpxf3jE1ol+ArzKm+zyZasb3M2ssYK1Jb2rJUoU+BwT8zsXatO0X4ihTKMtBgX0CVuiGpHiO1fJXH/HHarM4JqaqeMztHxy90QTJZEVCaSUs1ZuWf8yX3um0gj35ljQsEtwX5FHE1PbGK9Ae55pJ+fho1gloGwiFqAyACyKy2JMqpwOZauBcP9wvNxc9Eb29iPjqYVzhvi3lEEgOKwsa64PnIhx6V5gaSEJl8QVeQRNsMDjlRBzVwjPNcVjCkFSqFhmqMy0zpcrvUhjb9DQEXgTShK/y41rKn/PM56O7n6peS1+Ok5NAiyFnhkkNiLHO61owKg2IYDnYdyfQVFSyYbA+HDDoZKF9zZszp4c4IXraRaLC2MtDOYC9HavctSjZHTlFY
 +IagUU6p
 EXqLMnKuFq0AtSVtpdlbtxz3iSGp9Ib7ZIGozUOjKImyg7vQXcEN3fBlD31ugIhh05LGGwyVDP1pQ8PCN3pR4l1kFNQjuX8EjDGXNOhwZOJlcaLKeb/jBma7dscW7HmITsjTGm5W0AtL6cSvmyEhuaHljObQyVphuLhvRgJdWVXDLXeOTI98flU7+34+g8OPpCoQ08BAtLRz/06GqGM+3P6lnKsMWeBvk1dq8+HdMU/D+COan9uG2E3vIK+F+4hiSkn3IMQNb/WqJ2iuzYh5EYoQ2fvV0mkiq+AB4FVtO3PPGW1O8wpzhNSX4oQv/JYlrJaZELOJ6ANM6zD8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > +unlock_folio:
> > +     folio_unlock(folio);
> > +     folio_put(folio);
> > +     i++;
>
> I'd add a counter and use it int the below for loop.

Done.

>
> > +put_folios:
> > +     /*
> > +      * Note: don't free the folios already added to the file. They will be
> > +      * freed when the file is freed. Free the ones not added yet here.
> > +      */
> > +     for (; i < nr_folios; i++) {
> > +             const struct memfd_luo_folio_ser *pfolio = &folios_ser[i];
> > +
> > +             folio = kho_restore_folio(pfolio->pfn);
> > +             if (folio)
> > +                     folio_put(folio);
> > +     }
> > +
> > +     return err;
> > +}
>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Thanks!

Pasha

>
> --
> Sincerely yours,
> Mike.

