Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FD9ACEDDB5
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 15:26:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E106E6B002A; Tue, 18 Nov 2025 10:26:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC1D26B002B; Tue, 18 Nov 2025 10:26:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB0196B00A1; Tue, 18 Nov 2025 10:26:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B4BE16B002A
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 10:26:17 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4E79A4DFC9
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 15:26:17 +0000 (UTC)
X-FDA: 84124103994.24.CC12F8B
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf11.hostedemail.com (Postfix) with ESMTP id 68B3B4000E
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 15:26:15 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=jvJW0H8M;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763479575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=spNg0gEn6ojtwOkRBH8Jpq4k+vihAqprmX1EFmSE7Zc=;
	b=bbKGeiQWLEy3IzvaDva0+goP9C11qGFTlgbIzqi++9x6rDmFSvhc2Ep1eXkQD8rhzrNpOI
	vH0MRUtzrpVACH24PDNAwjLfuoVewMh0iFmB0mWok31GBI11oryMSc+yOkwgGKvZ9N1Ekw
	pCX/5yezAHJfVYDLwfyOSVu56xVzcls=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=jvJW0H8M;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763479575; a=rsa-sha256;
	cv=none;
	b=sWI9RKDQgxCHb6sLBJtNLoFpfBkyxBA1Ro5wDxaxuKTgyyQxkpr8BWX70SLb3oBKvClYkr
	lj5UN26TaQlB9oW8z6UkpJOKPUf9/9f0t8AIVci3OdCpfqNaf1apOYmlaaSdyZXJczfCjG
	LwzEj8vjycLum4C1KBwnDXVP2o4b5Ns=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-640aa1445c3so8813343a12.1
        for <linux-mm@kvack.org>; Tue, 18 Nov 2025 07:26:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763479574; x=1764084374; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=spNg0gEn6ojtwOkRBH8Jpq4k+vihAqprmX1EFmSE7Zc=;
        b=jvJW0H8MBej3MQRBtVCcvps/WXpGD9xDjlTysEJw5DHp29xHorkVcSFbd13XLTWpU3
         8nhraF46qRAR6b/EsurlhA1v0/EQTH1flvmjgSzaVW23NzLhGOFlJfUsuEXXQxOMgMih
         GW57ippVTuywy/ZKyABlqmUn7Wid+V370Kh+fanWBh6rfCTju+pRQBEiqacY+/zyQlI4
         tdKCDDfyofJqmpLPwgc75ZUUgCIoGKMNHl00v8gbv5kCFSNk/DYwZDN/5GhWn6hLGOTl
         ck2BIrqXNmB/Rp02tBLUStQDJ8u7lQRd/vw/ty1fqxN6yr1/pWVIPZCsZukolQiMrTEc
         cDVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763479574; x=1764084374;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=spNg0gEn6ojtwOkRBH8Jpq4k+vihAqprmX1EFmSE7Zc=;
        b=iV9P/zWlgiBT47CfseyocHNG4L5LJT3uqn4yGglo99vyJdoPVSHqw+xxabxD1g7+tH
         tvWiCb+MiAffIfdx6RKspPjBjLNs/GHLHkwCs5DSv30Ih58fMLVM1ni67py+u0UbVkNY
         iktp9LyoyNjKfbWJMw14yOW0SeAfCgAFve8huEJwZrwnuea7Kl5GtXtTn4K68+FLA7s3
         LQfZO63/ND8VCeSbkv41anXJ2H6zfo7o7FYz7jChgG4NcDIfTDTGXbRVMVx+Tx9punZc
         TTUyyS62p5qAlt7i+nvmG3n4EvvHdtqh/oGwx12vFL1G8/Qp9dX6ncYLi89jGGwIhu5e
         g1dA==
X-Forwarded-Encrypted: i=1; AJvYcCXehHspm+qZ83XaHKb7GQ6NrbBdcjzg4E9Xoor+tCK62Rb8KjTYNpe1oKhEycQAPSq65VhSTW3BIg==@kvack.org
X-Gm-Message-State: AOJu0YziOvTQ7EP5Kl+ZhROdsGWVtYXiFqtIkrGIl/grdYCXeExIPVbK
	L3issW4FRTD70LBj9CkEG7iGkfwLRYqRe9Stzyf6ISXyXyE//IDb35J0ixxb9ypRZo5TVFM3fwd
	VOFR1mAUAr1hxfaqezVinzK+tiCbq7EyHWym1AuDUeQ==
X-Gm-Gg: ASbGncvK6DuOnMJ1rv492qzGAr6mxUytImUz8ejqp71W233ocibnVfpwd7ORPgdXgfr
	wsXlYiaDIeG4FyJ83b7jDar2cfFXMRCXRJZv1mdJWibh+S9J3KRiT+MLJ27dwEqYYuAdf7P/PaO
	UBb0Jk4fRbgXevSlMReHO7nRudZoOPopYC5QGH5pxoYkVW9p+xka6cp+8VipAn4t1Qm6w70x+xT
	mvuXjzb6WqqEytHkLSYAMaIv4fkhW+HPzxSPjoC6lqn4SPk4V4R7HpTWBxCBOeCE0Ba
X-Google-Smtp-Source: AGHT+IGAslLYmoVpF06Z/Euv7CMoo8wIkiMsh+cvXEhFQRtSzRPdnq13K+BulBTnwOjNOOpla7fFnHdB1CcXp6BMI90=
X-Received: by 2002:a05:6402:3256:20b0:640:95e2:cd17 with SMTP id
 4fb4d7f45d1cf-64350ed5837mr12652174a12.36.1763479573814; Tue, 18 Nov 2025
 07:26:13 -0800 (PST)
MIME-Version: 1.0
References: <20251114155358.2884014-1-pasha.tatashin@soleen.com>
 <20251114155358.2884014-5-pasha.tatashin@soleen.com> <mafs0tsyw7e0a.fsf@kernel.org>
 <aRhJk_Glv2pX2dRo@kernel.org> <mafs0qztv4gw9.fsf@kernel.org>
In-Reply-To: <mafs0qztv4gw9.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 18 Nov 2025 10:25:37 -0500
X-Gm-Features: AWmQ_bmY4_D0I2C3zJJLi3fuG_3TrDg5DVV4CdlyPx9Q57oTqWUfDHmdb0U1tgE
Message-ID: <CA+CK2bDfrx21=Aw3pwPn4=AKGVeh0O+sB5gp8rvh0fk8C_nsdw@mail.gmail.com>
Subject: Re: [PATCH v1 04/13] kho: Verify deserialization status and fix FDT
 alignment access
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, akpm@linux-foundation.org, bhe@redhat.com, 
	jasonmiu@google.com, arnd@arndb.de, coxu@redhat.com, dave@vasilevsky.ca, 
	ebiggers@google.com, graf@amazon.com, kees@kernel.org, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 68B3B4000E
X-Stat-Signature: cs6xxmobjeo6r4qsiekisq8j9aixeb47
X-Rspam-User: 
X-HE-Tag: 1763479575-749151
X-HE-Meta: U2FsdGVkX1/sG+0xfft/6TzvQOYhDUte9HkpnjSl3maBa8SA9wRgPP/tB5x7KNalINafKylWyyC6xfhpr5bZgBnqbxpnXnLc0PNroLuJdF9ncH/bYrNQox1J6eA++Ri6bgXcrCcBTQgX+iyQrzByIZ9BrEotZiIIJRLl1joiP7wKceGWwUA5K1aNIkrTFECk1BAatNr9B34zL/DvcnlbKdgCWt3GGZs+U4QM7o1u5FF+R70URRIbAyJVFwBd5gHa3Yz5/1vcx0AlrUQzeUqs3N2eGipTo+DDvSAAcnZ4uHQ/B34I+NXZZlco2zoWfX32YD2ZUJ62gUOUbwFLUDukmJK9McpIC0TkMQe4hp4qGnoJKPkeyyeZ4hbGF2R/OKr4X69Qk4XjInmhVwrH+F9sH/S7Nt84gIvguF7Sg8OBxaqRb/TtDFP6OZHBisbq8oIVcEfEzf02c8Czw+MZHHu0dWP1YuPLf/tl82s+u6tUzcLylz4yaaeoX4ZL8gYr3dWN+jMdSYtX5aa8mQEdcdIDtEQzn9BFooK6ZObfG9Oo3+QRgSgrmYMIDMD1egGjbDMgmPs/06MbwOV7WKGRk/TZ0q18RQ3K1YeFaWaKLUGBwnHu2QqqbpYIe0wSGHwr7zrfsntfaLZRQtCYEYz7OzgWPHqNJiPLfRexaOUbsdWwnrtoOl1SZsIIdB9GRth/sVk+Y1iPzoJfdOK2myZY8Mo7kbYuef8S7hxO8Bh7TuYfbikmhByLxG805qEC0Wj3FKFwQPdlQnSpSuJvMhOVUY86i0rKc9XwIpQx1eiEEWbIlv4Wq70esNKvU4r0RBnkAJrNycD5vkG9BLoSDci8g8O107pd270W2SAjvWlPdLxMm5UpCu3NKJ/g6ZRFYtKCCZqa1TkiCpBoCaQc6nxhKiSmLS/kGq8WWZCsxqRqXZQmETCEe4KbcCNF0wBZAPqGvslfmYyx9xZ3RFKTucv2pcR
 yEK4uOUy
 Q7b2oWxu4W4679D8L8xKlTJG1jHpCoCT8VHW24vezzO264wkfXsGma9qI7aEEHsC0YoClyAcNWrO3n81FU4w6TWfDA+/3SVgThlnt/Y8X6LcDDFoBhtxB/Fc4OaCdTeHZn8T9mYIWUUahPUk5Di1EMFJwBQ03q/FxLBVeqiApQ2EQ5PzJ00AhU5Jf8pp+PtGhLa2L31/fWZCD1ZsZPuhdne28Jg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > This page is never freed, so adding it to zone managed pages or keeping it
> > reserved does not change anything.
>
> In practice, sure. I still don't see a good reason to _not_ initialize
> the page properly. It's not like it costs us much in terms of
> performance or code complexity.
>
> Since kho_restore_folio() makes sure the folio was _actually_ preserved
> from KHO, you have a safety check against previous kernel having a bug
> and not preserving the FDT properly. And I get that the FDT has already
> been used by this point, but at least you would have some known point to
> catch this.

The kho_alloc_preserve() API is different from kho_preserve_folio().
With kho_preserve_folio(), memory is allocated and some time later is
preserved, so there is a possibility for that memory to exist and be
used where it is not preserved, therefore it is a crucial step for
such memory to also do kho_restore_folio() before used. With
kho_alloc_preserve(), when the memory exists it is always preserved;
it is gurantee of this API. There is no reason to do
kho_restore_folio() on such memory at all. It can be released back to
the system via kho_free_restore()/kho_free_unpreserve().

Pasha

>
> [...]
>
> --
> Regards,
> Pratyush Yadav

