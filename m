Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2708ACE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 19:00:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7942D8E0028; Mon, 17 Nov 2025 14:00:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76BB68E0002; Mon, 17 Nov 2025 14:00:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A87F8E0028; Mon, 17 Nov 2025 14:00:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5C90C8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 14:00:57 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0B62D12DF2A
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 19:00:57 +0000 (UTC)
X-FDA: 84121016154.10.70A4F46
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf25.hostedemail.com (Postfix) with ESMTP id A1370A000E
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 19:00:54 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=NzcXSunr;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763406055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HPFoc/+4ns3fO2ktzkE/+/lUeXaO04xK8Lezo7jSI84=;
	b=mAEcDQ1+cXqigExCF8zMT5Nklgt06TTOZODHVpVPwY9SM3NTibCX4+YXWUGiNY6RZ+T0XF
	m36+x6E2AOfQe2/xvmcfgQleCYAcub1Hq6KAg3waxK2XEZKPKtIbPLY+6ayeYYXvYg94ow
	52HNpNmC31ost5lBC1wPm3TTXnUhNNg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763406055; a=rsa-sha256;
	cv=none;
	b=1hvvr90MID9hEYGC43DHgbSGm9fdn+ROs78hND5by17fsrHDao0zUDFeFHBNhxQKYLsoYg
	QbWCd5f+EZMLmqb3Gp6fuHJG4ih76K9cFdNra3727WVhb4FV6cs0xGOyxOH8ZuJjGHhZjr
	atrxN7yO1gKj4RJk3iHsxUN2arxffDA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=NzcXSunr;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-640aa1445c3so7132616a12.1
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 11:00:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763406053; x=1764010853; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HPFoc/+4ns3fO2ktzkE/+/lUeXaO04xK8Lezo7jSI84=;
        b=NzcXSunr1QUjHWjc4tRQmDq2/cqdFZvgwdbJChJjXu/Gy5jNCbjh2KsEk0w4Ht5fGh
         Aqr599rPXE6whZ9byChLSuUUJ36PN19xfZm0DG89w5JUXN4kJWZt1VkYV3Z9sEmUVYCH
         o6a/WkWf5Jd1gPJgK5BvPzPGObo0z7sPZmHuiWPilyUK0db/reDowOeRCumoxOla7uoO
         7bZYAB2jezsD12dApcasmzuVcn5MGzHXfmW+9ibbQpmFale/+o06ccXvi1cFkLm6Quz4
         wPgpTTXE6A28oFaM4dMC8/rvonEGkrq77TMk3ACVkNiKD9A3F/uiOl1DqDG0YecMDlfn
         Mvyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763406053; x=1764010853;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HPFoc/+4ns3fO2ktzkE/+/lUeXaO04xK8Lezo7jSI84=;
        b=XShQuokfPrCrNSHPkygSDzpJfxbUxthQSssLtO54CkvZTvtj7FNWskqKjtYbk6yFMN
         z92QFEqSNYvYtSvOofv3fqzs50SYuY6tdPsXwaISNZHkcs6J07OHAC4eLxpdFYCqSBvW
         WBptZMBk8ZHzzFXVa9XkDtFYFr65J85OgvEP/5QhzGnRUZQghFtlDEZr54vmQnwN/Wsn
         1/ikdcRgVj2JY6UIpqjfOHW6wSdZJnid2g09umVH1nAi0hSF797JeJ1QWz8dwzo+zhEb
         Kg3Iq01ioRNzAxdx8DhwXTQ0r+g+p8fkq3W1yXBJSiLwV8UOrg3Jv0Qtu4gUwvZI7oll
         gy+Q==
X-Forwarded-Encrypted: i=1; AJvYcCXplJoDMI5NEJigl4nYpqgNTuruKV+Lzc2vmcElLB0/wPJBnpot+Dk7Otv4mc2hbEZR/sgCje9jNg==@kvack.org
X-Gm-Message-State: AOJu0YxeEciXBYhGJxre53Mg9BSajUcT0Gmcm3j3bTabjtgYVMC8epp2
	VYI85M99s5qI3wz3bQY+HIpR/Nxg78cvxdU4CcbJYe6s9K7dxHWTsglYMYQwhOEg1WSsXKsXtWR
	kb0VXhMri06SpVdZbW3YNkHIZebj3GUs51mKqB+gCbw==
X-Gm-Gg: ASbGncvqr5hzv77LB2UjxgV3bpYmsdWCPl3nCI2Zl9KYCRnsHlfnyExHc1yvWkecnN3
	r3YXtftzwvh+AelTYitbCDCfFL3gknVQZVNF1wNhREh8o+8K61HGSVtWSRfo9h2OPlN55542igZ
	GiZHxEjL+3u6HeYRZHAWN4AhXoDYQfBOQ5jnnkiihUBTyNGZg7GtcKRAZZuBsqh1wFv2G2ugZ5t
	h6DP5Mnv5vLCHBp62SyS4a4H7BSqk+FMDHG9axgDPYhFwuXDYoOsMiMjZCzHKar3K+h
X-Google-Smtp-Source: AGHT+IFV4NJXr23fgmib+nZZop8ZpcGlfzValh3mFozDE5HCWs4UKMYvFXIv7w0dSviSfrbdSBGLz4YMmJN++K6QINE=
X-Received: by 2002:a05:6402:2812:b0:640:bb28:9a28 with SMTP id
 4fb4d7f45d1cf-64350e237b9mr14060340a12.15.1763406052900; Mon, 17 Nov 2025
 11:00:52 -0800 (PST)
MIME-Version: 1.0
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-21-pasha.tatashin@soleen.com> <aRsDb-4bXFQ9Zmtu@kernel.org>
In-Reply-To: <aRsDb-4bXFQ9Zmtu@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 17 Nov 2025 14:00:15 -0500
X-Gm-Features: AWmQ_bm3PVSUD_ScaaBFLOLZ3gtlTTKqmWWQ6wfPBc2TSiFgvBGhnxI_qyTqjOU
Message-ID: <CA+CK2bCfPeY558f499JHKN7aekDzsxQkZJ9Uz4e+saR0qtXyfg@mail.gmail.com>
Subject: Re: [PATCH v6 20/20] tests/liveupdate: Add in-kernel liveupdate test
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
X-Stat-Signature: u1wirs43iqjk53ee5xwt1izz91gcwicj
X-Rspam-User: 
X-Rspamd-Queue-Id: A1370A000E
X-Rspamd-Server: rspam10
X-HE-Tag: 1763406054-501185
X-HE-Meta: U2FsdGVkX19Ikwj4o9DbCjV0C2yBchWILHPu+lyAq6EHRrajJ9lAqkms+PTdlZyt295Ym6J9gtdL5WanyENF20AIOjNqjnOmEYMkjQsdUkOKYfrClgKGaufV2UgfAvGBqRYofc+32C/Bv1CvEVTrHU418k+7EOcPd09FfaZhzP4yua83HxPyTAYri316CZrz2p7yteQ7+4zkEL4lc+jm7eDixVcxydwUtTZdwqRg97nFUQHQiFtEkuRr2UFQFyOYyLaGl5eJeBBdbenNebSCyvtX7jWGJFs1Hmj6s7ZmW0OtNKBz8YqfdH/H7/qBVO48LXjXv1/n6Jn8e2FFk+ncIu+1o1bMn7dZ90UTcjiLt3mkXegY4AYI+Hq5OzmCK5OalrJl9mYeC91YyNGlpjerVKPJwpMbdG0ncykGn6hOwzGPxBZAO+TvrNiBXCa9c3ITZ4zjvmabKpVHStYJLVREO9avqVc/D5QY3yGQLakixDDo+bWCoEH6KqCvXW8PyyTGp8uznUSCh8F/qusIZ6e1JueNq9sztHUiMWhYbMcFMuqulKEM1z+Z0EEJqaQ3wfPA4ZIrzFYQpy2sbNK3iKa5bJ18lvf4HIcuxynUgc/60CBlY4tB+AljpdH6AnxNSvMt/A9VhuhJxm5uDqrND8fjrEvsl1l9oComecgl4HVFD7O4ArclRJaIQA3wW4HXu0YOkWlidbm+NOjYq+LuhVPKE8czW352egniTNXwrc45+yFXoqUrqksUNX+6wr+aOsPGHrThH1WP3wzy77r8U45wB1StDluuJHuYL9lq+2Isrov+SrMrlFj80lkPh1HQMpzLnyR6yoEhdpQWLWdpf54Xomf+rEL86ez+O6BvoTUs43XVx4pO50MTbH0hjI79CqJUufs7R3MJoGuXLwH9gewiHzvcCkeOnjrNv1OZLN5s9ZPdhFkDARBzPyhfxYiluoAehPfGaSYNjBeLHhETx/E
 yTkmW9TY
 Ax1n+tJYJ6QXx+duIwnqVdvEL58qkiXZ+CQJdQtKvqtwmjT7BufcuuiUiHrEMqn9s2lYmYsUQNU3/tKzK/jcvEu/gQHqX5lHQoe+o+I8ntOTUix18pDX4TF7v+wYhBfpZmWAGk4JJn7r7vnYd0ZekHLkoTFDubiMD01yA5z49fbMo3cknOveYMB0y4uZcmjCTJu2TtRNP9QfFqxP0DJZtgk4OdB/bwOck2DW4Gryu2PqoW8/VXv15WxKM5WfXMAROpiFFOtBRr7Yt+YeWXXrA1TnTJPZG8hSzMoINz5qzWXrO4W2pSvrxjGFg+t9TbkC7hhxz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> >  #endif /* _LINUX_LIVEUPDATE_ABI_LUO_H */
> > diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
> > index df337c9c4f21..9a531096bdb5 100644
> > --- a/kernel/liveupdate/luo_file.c
> > +++ b/kernel/liveupdate/luo_file.c
> > @@ -834,6 +834,8 @@ int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
> >       INIT_LIST_HEAD(&fh->flb_list);
> >       list_add_tail(&fh->list, &luo_file_handler_list);
> >
> > +     liveupdate_test_register(fh);
> > +
>
> Why this cannot be called from the test?

Because test does not have access to all file_handlers that are being
registered with LUO.

Pasha

