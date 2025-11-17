Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7ABCCCEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 14:22:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D81198E0009; Mon, 17 Nov 2025 09:22:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D30FE8E0002; Mon, 17 Nov 2025 09:22:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF8F88E0009; Mon, 17 Nov 2025 09:22:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A79DD8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 09:22:58 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7BB39855E0
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 14:22:58 +0000 (UTC)
X-FDA: 84120315636.14.3F13E3C
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8EB6310000A
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 14:22:56 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ekHBnW4O;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763389376; a=rsa-sha256;
	cv=none;
	b=VgaEW6oG30tudEaXNpGM+UbrBiPfPPDH75FcmTuxPSNsUDMumzzbG4r3YINCQtYSQMtq8o
	4Ct+n/ZnEppcuvhWpLsuuJS3EGhOUoq+sk2MwWeqInwh9GtA1Cg9888j2x1dVClMakO5vy
	hVd+PGUwaXAx8s+1jcMK2l7p6B0x3AE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ekHBnW4O;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763389376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BpEF14JwpgPT7D39g8XJx/NDIOdD//cHw6pm3Wkjf4g=;
	b=D2qrzt/HHxTuQGW8HkDsqyf9+leGb6NP7Y7bTvyIi62V4wYtRnzKRtLzdl06uctf7B8Q9j
	XCyZIPnJS0Xdvox2zuEz3CpG3T/h/re+eXWbqRfrumZYrFbabBc+RcnCHqjtyXPxa6RQgW
	8tjmp4jMy0aD5g6WZOy59GW8QjMvQK0=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-64080ccf749so5868286a12.2
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 06:22:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763389375; x=1763994175; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BpEF14JwpgPT7D39g8XJx/NDIOdD//cHw6pm3Wkjf4g=;
        b=ekHBnW4O/kL1RimTND+5Il91baPel4PVPd/8i3Ki1+Pwv/uUmfWy+yhbS6my0C/z9U
         LDoGHZAwpTzlAI71LbFWPTesz1phDbQNP5Usj0e/JRNYZZPZRZo6+3AA0O9e/43LNDHg
         uqGuDxRYpEac3AF813W5NuS0+t2DSNf6aoxbYstuPg8iorXXKR08J9j2WsXhLzWHIcFW
         XTdDhclprxdr5FPs5DxFbT7wmavXg/utYGP3ghwTmJy7B7CD0IW4Dv7ZyEsYuk9Rd6nI
         fbZmSdcOSeWgI+mT7ZqfnBQxkJ5TJZ3RwzocoD3wSrUH43VjZxf9aULJ3sTGHCWn8aEV
         /vAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763389375; x=1763994175;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BpEF14JwpgPT7D39g8XJx/NDIOdD//cHw6pm3Wkjf4g=;
        b=kuA9lk6MU0Y0sRWruNd+Nsuv7Xx26D+xkaxrANIatu+kpEq25e5c3ciqeDoBG5c0Ws
         iJ88fku/JvO+sF43yZuTEuosPNmkrET4nIYQUKalXFmGxmWC3ENDH8yCZ8VEFXqoFUWD
         MYOgGh4QEi8N+mCX0rayZ6+lcLlhe5yi3MFTrGoleuzxEe2FdDFi6BZFTHdHxh6sClM5
         Jr0QnO7m5oRz7EwYfaY0iUJXnbI6n0aAlPDP68ajIs6qVtGXrxqm6PSN8rJ0In4ft87c
         Lr5PNup6FgSWSskVAvbtvQR8ofwH8NTDb/FqhGrg0FGzYQhwQ0OFFTj2YByBdk+tQjW5
         udkA==
X-Forwarded-Encrypted: i=1; AJvYcCXcpMXwL1kGllsVMhqw/K7a6K+YBkbFfSYw90BakrBI6O+CwgkEzRfw6ctUEJmA52GIfx3tC70NIA==@kvack.org
X-Gm-Message-State: AOJu0Yz+O6N34I4HcZo8QuyqJEm4E6WTr05YYkJRvgAVKS5xZq5TRC9U
	2D4Ag9Y4UHtRm5eYWff4eqgTT+nm7JHgscs1f/h40XrJxNQgwJ036N9UeNHzMKsPl1ypleEakyb
	ATF5hjL2o99C5D851UQGS8320duzeiYXBnaYBQJ8Udg==
X-Gm-Gg: ASbGnct7epocE3SKtsISwl/fMChV5/0cBMT+X08PWmZoTW1X6Ei0vyd5CZfsCXwXq8e
	nb2oG62HICi3/NNJBjaZy/NzOq80XX7G141ZyYNwrxWmNNqPmhlWIiLf+r8mWLO3Vg4WyI0/41r
	qrRRRqbnTBdzULKGuorFOfYO6GT9fq7hKposrhjbx0N/J4H8aOLMKLlX8mip1VWx5dfuGb15Om3
	su2Sy1G3+oJhXB0L2sVm4DtrNo3N2JleBJnQel3kLpoir0/s80M8RShrkMDRVNzuUkheKze6CdL
	jF0=
X-Google-Smtp-Source: AGHT+IHa9YOzj6FRhxpEiiz0OGiVTh00SkAyRkpmpsCgXO3neMf5Hwjy2VuUd0cgFfp3qUhUPORhyn0xLdhCHN4dWSA=
X-Received: by 2002:a05:6402:1ec8:b0:639:e30c:2498 with SMTP id
 4fb4d7f45d1cf-64350e23226mr11650950a12.13.1763389374738; Mon, 17 Nov 2025
 06:22:54 -0800 (PST)
MIME-Version: 1.0
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-6-pasha.tatashin@soleen.com> <aRoGw9gml3vozrbz@kernel.org>
In-Reply-To: <aRoGw9gml3vozrbz@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 17 Nov 2025 09:22:16 -0500
X-Gm-Features: AWmQ_bm48MLbx6lEP4m9w_8Roe08ADT3jnLNtB7LP5zXsIF-E2LtaeNOwAhNVDA
Message-ID: <CA+CK2bA-mA+qnqWKtZdkCpQ5WpWdcEhwU6BTtC_FgRRT=OVVFw@mail.gmail.com>
Subject: Re: [PATCH v6 05/20] liveupdate: luo_ioctl: add user interface
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
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8EB6310000A
X-Stat-Signature: shub7mfcifkwbo3xgt1g3zhtnbt4mnfi
X-Rspam-User: 
X-HE-Tag: 1763389376-813822
X-HE-Meta: U2FsdGVkX1+66nm3zP3j9IfYc8c/esaTbnWIQvTszekzBuExwPQKMNQa6XxfNSobkvUEWM5ofZWLh6cGSm7F60SKV4ZJv0u7hoTNnIf0i0HPk2ClyLs1RpVhrQuv5WorJdv09PoVKpnPpyHyT1A2ju1uMkOYC7jMUCszpMktY4Sl9yyQfXU0W4T6WTo7FFjaIpDqkwWmImvcNYtk5ncP3lMMi7pcoLwcyauqS4LvGjkMkYtlg24Oab9K4yTYHAEhkmFbC7X9aDyE2qqdRQv8juhbRo+jxAXL8hXcQJCBxR6NzSyXIcMjocUiV78qH0OfKggFNVifH01vcHnwJBVWWnuCTf5KtUiYFID7yeXAVCvlhb6nW3tRuQ/CqkFe+LLSOP+VJYN58y6mYb6BB3M2DbqYtW+k0Y2+IEOKzNSvi9NjXC2N+8S25r6phwpebIliEm4T/0IXo2l0L1HYBeL5YzYgAoEM/52MZtcWZzbSbNCv/lFvq21JLis4FJ5Amb33m4V6NWJg39A23YYP5kYN2I9hiVAIY+QOsmJ3in8yP+fkOklvVD8iYNAm5BMlxLm5M9sWOGQCZY3CIJHq/J3ETlqVqVPlZ0KSxB1cvWwP57vsvCX+gM58rtZhuah/1PjKhy4kMmqQc3gRaq2+iF6dcnTc8GEZt2BwsZnEX4f02m+P0mJ/lO0+Nba3NCZyV1s6IYmIYmutMgUTYB8Qp0FYr79TwA7eCTBlxnOxjLYsbnB76RE1wlMFRHNbkU4WmSUC2s09Be0YxqmbFHRs/fJ4PI2JD1TWCxEUz1nwpq0vdK+yEwFT5/ANdML6J4FugCf3PiaYlY9LcP4Wt7hfmq9BfuGVn0yxszWNgPKr3L3HINJbWAnSe8FTm/xWEXlwG1P1ipDBaGLJCZB1nQ5T3f3+I5xS+QxSrAI+YtS+lRNfvVQj70J6cZq0iF249erKgj/nGjNGWkQS94D3onoJGX8
 JKrMk1Nm
 82ZO9CDsnURRxd2kOd0v0q+nZDIv/qqB0p94xoNabhw4EqUB06Ol2eiXxIGb7iERt0ulB/1do7gdy7KbeSCVIFQ8HDE/XFW/tifGQYQGXBsVPIgsGVx/18L+W0SnSvpGYxkWiSvYlNNHDoT888DxnNy9hJlBaCzNXCMtBxUHDtdCrfY14Y0jvAWEMa//xNriNBXilJCfiJV5cmQJ3mPGVw1RN1GmGQhCrbdneEpiquPy2B2y8aPGMo7soke2Z6Q2U/Q6XvGLMWfP3RBQvxixMXbvN+NActpbDcYFL3M0/sFTX/yR+RegVbuVAWti0Ltk9OXkLToVzU4mgVTgTLclKVmmkahTmIxj3jQVwg6lK1vVI1HpEOALDC5peUE0NYHre1Y/h1Gp5VH5ASmGfmtiU17mp7tKlOGWJ0V4I7lPE20fGE0o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > --- a/include/uapi/linux/liveupdate.h
> > +++ b/include/uapi/linux/liveupdate.h
> > @@ -44,6 +44,70 @@
> >  #define LIVEUPDATE_IOCTL_TYPE                0xBA
> >
> >  /* The maximum length of session name including null termination */
> > -#define LIVEUPDATE_SESSION_NAME_LENGTH 56
> > +#define LIVEUPDATE_SESSION_NAME_LENGTH 64

Ah, here I updated the session name length :-) I will move this change
to the proper patch.

> > +/**
> > + * struct liveupdate_ioctl_create_session - ioctl(LIVEUPDATE_IOCTL_CREATE_SESSION)
> > + * @size:    Input; sizeof(struct liveupdate_ioctl_create_session)
> > + * @fd:              Output; The new file descriptor for the created session.
> > + * @name:    Input; A null-terminated string for the session name, max
> > + *           length %LIVEUPDATE_SESSION_NAME_LENGTH including termination
> > + *           char.
>
> Nit:          ^ character

Done.

> > +     if (atomic_cmpxchg(&ldev->in_use, 0, 1))
> > +             return -EBUSY;
> > +
> > +     luo_session_deserialize();
>
> Why luo_session_deserialize() is tied to the first open of the chardev?

Because at this point, when `/dev/liveupdate` is opened we expect that
userspace has finished loading modules that might register
File-Handlers, and FLBs, with LUO, and therefore we can deserialize
the sessions and find all the rightful owners for FDs. After this
point, we also forbid registering new FHs and FLBs.

Pasha

