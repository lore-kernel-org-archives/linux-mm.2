Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86803CA100F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 19:30:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FE168E000A; Mon, 22 Sep 2025 15:30:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D6058E0001; Mon, 22 Sep 2025 15:30:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 713168E000A; Mon, 22 Sep 2025 15:30:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6250D8E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 15:30:23 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CAE9FA6194
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 19:30:22 +0000 (UTC)
X-FDA: 83917877484.11.B75AFD4
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7B3B3100014
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 19:30:20 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=f6rCTjjr;
	spf=pass (imf05.hostedemail.com: domain of paul@paul-moore.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758569420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cvdWOntfA4A2sQxeMILs61f9nOsNLek7agJHp14BnZw=;
	b=YtA0izIXdDXS2N8T6IyE3onwpzfWZqa8HqFzNM/2U1spZyt9Nqx4sa9wprOhNv3EoaYspj
	oEt8lJbSbHpg+RJteKxI78v2CsNZeNgQzV2kID00CvTzGqYDTwRHcrqX+5qgrBu+DcGNmi
	rjQxvWr7ZE8hEoyRPnEhnNojcWWZDqU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=f6rCTjjr;
	spf=pass (imf05.hostedemail.com: domain of paul@paul-moore.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758569420; a=rsa-sha256;
	cv=none;
	b=26tyca5ymp/NiG/VesTXJDCGpDGWXA4UP35yZ1w2HhAP2hv+cSsYvEVtija6e81YKdIzIf
	geLL+Ub/I1atPe19T/hPFnoaDesWNhqMgUhtt6uq/HiHtbwh2q2cugjVtMdMxc4PrXeutq
	4NFFsSj1ecVjDtcsdCTLr/z4sD7B5gk=
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-61feb87fe26so6110073a12.1
        for <linux-mm@kvack.org>; Mon, 22 Sep 2025 12:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1758569419; x=1759174219; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cvdWOntfA4A2sQxeMILs61f9nOsNLek7agJHp14BnZw=;
        b=f6rCTjjr8ZDR4B7Vheej9XcxfNvIuzqokiVw4TA9ItWT/IVLaQ3H7kvWXWS226nWMS
         rnzEcWNfjIOUxT9mTn1Sbl4lLpZJMxMR9EOeKL8V0SJLb3CGLgk4XgQHDNO2HaYUoL/R
         V1ZeUlbo9YwEQr06GWWPhn2dsUs19OQ9nSUsDF7mRPmBj2OtGv+zyXkVwOSWfNAn89sA
         SIOveR7J6XQCtY1EAGsARGRmwf/0LXbjpdKWi/wz3sr82XcBOw4LLRv4GM17dtFG8hy+
         WwqdK6silVVC4/u+A0K+qAkHQRwMUmxBCzdUJix3lM8cE+morqLp/nUyfJ5R2V1fCxrI
         tJZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758569419; x=1759174219;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cvdWOntfA4A2sQxeMILs61f9nOsNLek7agJHp14BnZw=;
        b=V9xzj3Lseofa4ltHCjs5tMxdy1XlI/nCEJ0a/W0SxPPMQd6SuUp26pZFbI53njUFru
         PS889tupPndKj3NGonpUkI/zZrdkmDwCTlhf+Z5E+u5Zq/oXOEmWSEnzsOXeQWH30nIe
         pGg1n0sJab7oQXtJm8UTsf++0UPHAEEBAjmCCtwEtw8dBhp1vCdVUR6A4GiUdrbvBYyO
         tgBAk9KeSW6fQj0g0IrZRp4tazwQlCvmkgI2+y+c9g/e+zC+SqDMN/B/5S2DfJIkZ8Wt
         RNMoWmgRnJcqs7x5pCHN7tv28+Pz34avDJiB8imSUz3vaTMiO/wKSZEaZWy1WLYeEP4D
         5hfg==
X-Forwarded-Encrypted: i=1; AJvYcCUfon1sWiw0zo3QjPqTwt3z7Y0lpnmWj3ZVz1OOOlFKJbwDGe0U46R2S5rzI5gTTNpEaPQmgfvdTg==@kvack.org
X-Gm-Message-State: AOJu0Ywte4Ut6kEodgLIxTpEeORKCAbYnkto67niJlgLqATaIutKe5yf
	8wq8sjgOp4HB8wjCmWG53k+FH6B+eVRDUCyG9pTbKqPBBp8l9ULrtRvBoHSlXMqe+/JM1Ba+nrJ
	0wHcy7O9Is7Kqj9Qy0XtB1OhRgKWQyO7+3uBD8aNH
X-Gm-Gg: ASbGnctCh/vs/3G8piaXGs6Zp8AfPJIlhtSTxflGItYD1ctKVM/Pa4izU5EmAavc8pv
	uW3jZ/vh18oLqiMH+8UhIbJmTuaBixL2Z2LbhYolpLRjH1IhI6NSfGLErqx+jQ5WboCXDpiqcxI
	VSAwoVYMWjBGAF99p0i8pDG4zoiH5UGZ4dtfxJ21DPb6167FuUs1kTL6WG7n1eV3Pp3O2sHGJRl
	cdu87g=
X-Google-Smtp-Source: AGHT+IEiBDSh+6Em5c+U4LmqyUVPf4J6sg4KEYshuli5NnK7h8jqw5N22Ih+dxfjqxwcfWjX8MHUInxueYuNHXzg6tw=
X-Received: by 2002:a05:6402:5201:b0:633:7b1e:9aa3 with SMTP id
 4fb4d7f45d1cf-6337b1ea02fmr4563672a12.34.1758569418235; Mon, 22 Sep 2025
 12:30:18 -0700 (PDT)
MIME-Version: 1.0
References: <20250918020434.1612137-1-tweek@google.com> <CAHC9VhSbWJ-8tj5BxSTxznGO8zraKRSE31a+tqdfMHB53ef-MQ@mail.gmail.com>
 <CAEjxPJ5GidA9oT_fbKRe_nH1J3mER0ggM-dBW=Nuo765JDuQKg@mail.gmail.com>
In-Reply-To: <CAEjxPJ5GidA9oT_fbKRe_nH1J3mER0ggM-dBW=Nuo765JDuQKg@mail.gmail.com>
From: Paul Moore <paul@paul-moore.com>
Date: Mon, 22 Sep 2025 15:30:04 -0400
X-Gm-Features: AS18NWA9HrHmx3YP496OglRtxh1AdycMtaqbc5LSlhUEUhu_PxKTgISVOm7uHlk
Message-ID: <CAHC9VhS2TU2GWgfUOHerbfjyxb5QZMSMqLdQirjSdkUohR7opg@mail.gmail.com>
Subject: Re: [PATCH v3] memfd,selinux: call security_inode_init_security_anon
To: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: =?UTF-8?Q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>, 
	Hugh Dickins <hughd@google.com>, James Morris <jmorris@namei.org>, 
	Jeff Vander Stoep <jeffv@google.com>, Nick Kralevich <nnk@google.com>, Jeff Xu <jeffxu@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Isaac Manjarres <isaacmanjarres@google.com>, 
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	selinux@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7B3B3100014
X-Stat-Signature: sounugd396iq7kyeoqmgj8wr6ja68iyf
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758569420-521010
X-HE-Meta: U2FsdGVkX1+h240ns5KeS05loqFOZVGUIlBb8n8gCV5VJrhq2fy1B3DMnBqpuC09xUqvqicTqiKT1xq/8URUxdB2ndcxNhiWcY/7mIOZvw0z3+8+RqbrgdsgY0JcN5EivYEu4PzJUpUQZmzilBVBN6ZMmcNbmSGMZLV9ilZP7/aUhu6oXgduc0sJY3VnT5uHxCg/PwjpX9PvJsd9jwfgb6L/Uenp73czKLfZ7YLhW5MOX6VmUVdmFIz0DGfNsCyPvz2oqm5zaFw2pY/9mKC4GwL9B7Na0SHJect5TawDDXacMYxpZS/PoS1V7tA/UmyYIhJV0a9LKoJ33l2Js7iUbKEPPtvXmTWwn5KNmicDqLSsJ8FhCaZdIpYAZdorH3kVntMWo9A3OAKf2rzQ3Wt+uNIMYCBdq6Hvf+lggvcdyBbUgqeFf2Z9ydEhGWyw2etF4Vs0UOVZSPztKsOJgVK4QL/G/LfyIiP+0D4JBrudWrasXou/0L17bzCY8wGjTpXhTTS2vKvwydjDIFAYEL8TlMH9h6HKotD1HE0kXgdFY881TgYOR0teNz3Gd54xIVw6e94bJLSIRnWQ55GlJu5mA+VtWyyreY1Qr/SNxcGhsqkMPyG312pVQqDJ6mFefUovnmkT0B59FhwQ6prftAd7+jqpQzpKyqmeGM8SXZZBZ9or5GyjvZQ3tZ2pUPZRI6jpROG0a7xHSZv/1Bcgd1lvM6iYkXDgfQ1vWZWU0YaAHdBU6yStBmh9gtJeRi6EsW/kGUeUPCzevpTRXeFHxmQ28LnF9CDSuibI1vTSt7cJbrAmjTEQGQ7h06v9yP0f7KzQL2uan7lfi2ejHNybKT0UvcnbiSQCQV6rBeUyO4FSTRv9Ye3wBHIf/C6trHXOir/A7ygkABbWQkVTgDqQUixSwr/RggJJmacaRcWCZ8Yxnvi9ws0Z6v7JkY9whDAUAd0KiwUZ2S9f/dydJ/7B83i
 LfY3zPQP
 EfzDWAYqDvTA5GmHGZAsOJMzFbgnXX7KP9eS6/NcHLd0IE2WAzNYVrT6SeelOO2QfLcrgaia78UOaMRw44FA5V7UtqV7JBCOajJvMEGV0v6XEQ3IZlJvSFKTj30o0OLf/Nx/0TBKzUu1fcQ6YuybPFUCNOxbyeK+TlW7e0IVc1jgUIhyCIUIVs0DZhOz4YNdQUQLVHRJa/mGQbkLkevXfrOrBhj2URX0I4oVBVHKZtlO5MEcT3BH/j+bG/jVdme3mFsHBuQ5qEyafNQBQL5+rgq99pTHK/yt4pm0Lku3wwTLJCQUrICGpZablfRYk/UpZ1/7QpRTS2ch4QM0jxcz8+if40I8cG8roulmdGRtXbVyJ0BOnExmWqCe+MgzYAHCbJNdJ4xQ0X6jBPin1ck123Z9CXr1ZSnMvP25G4zVMVpj5dhs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 22, 2025 at 9:12=E2=80=AFAM Stephen Smalley
<stephen.smalley.work@gmail.com> wrote:
>
> When would you recommend that I re-apply the corresponding userspace
> patch to reserve this policy capability number for memfd_class?
> After it is moved to selinux/dev? Understand that it isn't truly
> reserved until it lands in a kernel.org kernel but would prefer to
> reapply it sooner than that since there may be other policy capability
> requests queueing up (e.g. bpf token) that should be done relative to
> it. Can always revert it again if necessary, at least until another
> userspace release is made (not sure on timeline for that).

When it comes to API issues like this, my standard answer is "tagged
release from Linus" as it is the safest option, but you know that
already.

The fuzzier answer is that unless something crazy happens, I'm likely
going to move the patches, in order, from selinux/dev-staging into
selinux/dev when the merge window closes.  This means that any
policycap API additions for the next cycle are going to start with the
memfd_class policycap, so it *should* be fairly safe to merge the
userspace bits now, I just wouldn't do a userspace release with that
API change until we see a tagged release from Linus.

--=20
paul-moore.com

