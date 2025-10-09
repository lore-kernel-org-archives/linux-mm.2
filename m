Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22BBBCCD184
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 17:05:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6256A8E0093; Thu,  9 Oct 2025 13:05:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FCA58E002C; Thu,  9 Oct 2025 13:05:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5129C8E0093; Thu,  9 Oct 2025 13:05:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 405B68E002C
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 13:05:39 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E5689160AA3
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 17:05:38 +0000 (UTC)
X-FDA: 83979202356.02.93B6B5C
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf26.hostedemail.com (Postfix) with ESMTP id 19ACD14001F
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 17:05:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=WVwSuY1M;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760029537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZEwvryL4F3rbj5qgEHR3Bc73043Xk7gnhFlf4AiO1uc=;
	b=rfLkg01Eui0RI4X8VM7i9Eoz5IVjF9Rl6LJcsxoxp2LCmt7wlk83uh8ziUbueaAZRr8No/
	+w24+YIecBuCNjBvH/DzpstWGk2DFV1BEWEqfyaILOzY9mMgdDJHXrAGheAFwP6M1aTDvF
	6Ybwh7nBcXB3/Ohp0hI9DWBsSXCbGDc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=WVwSuY1M;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760029537; a=rsa-sha256;
	cv=none;
	b=hSsC6rTNqGWjMxHFkjIfX0g10DZmU/d6xLE+Z8E2pi5P2uV/ANHxH1uto6tddU5wmDBdZ8
	TZ7ILnoD9dUx0bBn/ijGt7LHg8WcVc8WnHpFkHDGDRkZGihQZBVw5vHogZISSpvusku0cY
	toFWBwcC3C3xgPLdQ5i/gHWRYV87tQg=
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-85d5cd6fe9fso104121085a.0
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 10:05:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1760029536; x=1760634336; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZEwvryL4F3rbj5qgEHR3Bc73043Xk7gnhFlf4AiO1uc=;
        b=WVwSuY1Mdxv9xeEUeNA03HNhYPV8Snt1mjkZIabLjjKbDL4rZQZYffHjMz9fjj1oZQ
         EXXiljyM0VtNOkFw/VP36AkiI7roESia8QQyUjetT6yEb7+vF2kXg6I9hrgkIKRs+7eS
         CH/qaiS8BlehO3GKKHC5wm+8fRFtNE8u9yMrN8EtO0cGQVpCWt+fJJFna0tTmNCxrax8
         mkCs2/rrwkW9R4kMn4ae2EoIqLKBYimz7pH8BtHsC3ac8RmiPkV1z8qzkOLhBDNaBH3O
         NNTIvnedi/HHzZsO/FEpaazUaGKS0t1jU9okNbK5YZFcWOECwG5ulYwHC4O/FxhKgTZq
         TieA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760029536; x=1760634336;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZEwvryL4F3rbj5qgEHR3Bc73043Xk7gnhFlf4AiO1uc=;
        b=LcsBThQhLaXME38C4YVNaIJcxArXJonXuxmtN6wJBYDDJyf8hWtD/4PMxqfJExBKb2
         EywUCDJrJdu7gctJyBwQ+9Uqum2g3VycQ/XSI3lK4FP3xrLQT8vSOycaXVz4pBiWJqxt
         uCLzdaSRlKyZDLdZszDbm0f9ZBIX+v8Gqdk68H2dUehi29st0OLMQTfTszszejcsguzT
         o4mxUoOmL5MQt5BEQOQuSla0buRqNqLmVu/PdSKUM9ZOMSTkXceT0Bs2QxwkNmG/fxEt
         YO7bQn+Bw2kBx/5bqSgqQ9sMnsBfuYPxhn0dwcrSzP4km4Bla+cxMxnKwftsbrSzQEeo
         SD4A==
X-Forwarded-Encrypted: i=1; AJvYcCXY+4jmDu8OTe38UnBi8HB3OC1XhreAcDOeHW3lpdIqzSrsoyHuhRKun624dzwMYj35jwXyTDjN2A==@kvack.org
X-Gm-Message-State: AOJu0Yw7XNQphe1Wy266r8uVt8Jj/15Do7F9fI8kuRl6mlP+2JsP3+n1
	qbmhsfnhXOAp8utLe9rCrTEMTfho3SIVKLLdO4hPZ6eQvGbkuMuZvye5cBCf/7GYQZNqlAXot//
	jrFVUWtmchOEooSMTG0TA4onoKb5iOzKM9F8wQ23PTA==
X-Gm-Gg: ASbGncu6GUlUgV8AEpcv6VFW55WVECacG3jjhzvfMkrkc5l1PgNtDYMXG0JM0qt/ay7
	BoOgsLoptq9cE7bqi6Fi7KqhLwym0GshueNo0oWwiogonSt71vncHLmX8Hu4Y4YuBZtV9weAAUY
	XJxMe7s4uou90Z6JtwKLDPEHD46bb7KO5PAzjP2pYID8cwZBTXV84vrdtYZYUm5djqY58h5zZwa
	i12MifOqP5keObdF/+Y5nc1uroRUdQ0G0p0hRI=
X-Google-Smtp-Source: AGHT+IFE2sAReF4JI9gkbOEBI0GExAG6O+9H49nxZIOW3wiMfCJHnma5AW+apR4GDzx7KvuzWvZY/WusdxfEgE8+CuY=
X-Received: by 2002:a05:620a:2952:b0:870:ab:42f2 with SMTP id
 af79cd13be357-8835384546cmr1185682885a.24.1760029535702; Thu, 09 Oct 2025
 10:05:35 -0700 (PDT)
MIME-Version: 1.0
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <20250807014442.3829950-20-pasha.tatashin@soleen.com> <a27f9f8f-dc03-441b-8aa7-7daeff6c82ae@linux.dev>
 <mafs0qzvcmje2.fsf@kernel.org> <CA+CK2bCx=kTVORq9dRE2h3Z4QQ-ggxanY2tDPRy13_ARhc+TqA@mail.gmail.com>
 <dc71808c-c6a4-434a-aee9-b97601814c92@linux.dev>
In-Reply-To: <dc71808c-c6a4-434a-aee9-b97601814c92@linux.dev>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 9 Oct 2025 13:04:57 -0400
X-Gm-Features: AS18NWB7Cr_VpUIKYZatXQYpiNUtQ7J6s9XvqZtMcyHaQrrY3c7p0E8zT1F9p7k
Message-ID: <CA+CK2bBz3NvDmwUjCPiyTPH9yL6YpZ+vX=o2TkC2C7aViXO-pQ@mail.gmail.com>
Subject: Re: [PATCH v3 19/30] liveupdate: luo_sysfs: add sysfs state monitoring
To: Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: Pratyush Yadav <pratyush@kernel.org>, jasonmiu@google.com, graf@amazon.com, 
	changyuanl@google.com, rppt@kernel.org, dmatlack@google.com, 
	rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org, 
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, ojeda@kernel.org, 
	aliceryhl@google.com, masahiroy@kernel.org, akpm@linux-foundation.org, 
	tj@kernel.org, yoann.congal@smile.fr, mmaurer@google.com, 
	roman.gushchin@linux.dev, chenridong@huawei.com, axboe@kernel.dk, 
	mark.rutland@arm.com, jannh@google.com, vincent.guittot@linaro.org, 
	hannes@cmpxchg.org, dan.j.williams@intel.com, david@redhat.com, 
	joel.granados@kernel.org, rostedt@goodmis.org, anna.schumaker@oracle.com, 
	song@kernel.org, zhangguopeng@kylinos.cn, linux@weissschuh.net, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, 
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	rafael@kernel.org, dakr@kernel.org, bartosz.golaszewski@linaro.org, 
	cw00.choi@samsung.com, myungjoo.ham@samsung.com, yesanishhere@gmail.com, 
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com, 
	aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, lennart@poettering.net, brauner@kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, saeedm@nvidia.com, 
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, leonro@nvidia.com, 
	witu@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: q66hfurypb36nk5dy3n5kud9a8nzbfo4
X-Rspamd-Queue-Id: 19ACD14001F
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760029536-634379
X-HE-Meta: U2FsdGVkX19CWgYp4RJl7et7O7W/rI0iB0/B/k3zbGMiLwhFXsnRtwIo7Lz4c2aLXJ4fKU/D4Mk+x40IjOUlmv8UvK/3Dd6JehJRCR/OwLA6H0EK9bNxaLgDjiL5KRJbEz6AV0loA/GJZB4KOsuNj0W3CJ28txQCVmfqBDG7UYa4atlAx+I1+gaxnBX/xY75bq3Nr/M8hz5UAnWmtRuV26zrYCuL8VDk47yHm3lyOzZfmDvYhphyaQmoxYEzL6xknzmF4xu6PFVgCDAwg7j6pcoLKfhmbIrQSUICnGmgq9isLV01HyeOWNUHcLOMWwHMQsJ3Q0qQ+d3OBwHVwWJbzGOlmFzZ6/sJxAxdLA2CxOzK8AcaL81S/JzOPD2hu5opxhbEmUDvD7GesXzbEuPsjTsT3t4zEMOHwNiEVfzq70gnJWaCbn2Y2i1cMpg/+YcI4/WaOnwJhXpHDhcAskWObnZF3W7s9Cjow8KCOl4GuIKs4hHeDMnvTe3bkiDYpTvNUlLziqnV5cbsH9T9dxLn1KQTn/ruj/sFgDD6fDk47kFLlMaXcx5+YIIwOJed6rGEAcqtDJfrcqKOIoqINVhHOjBkQ5djRc5f/ahYIarrhdY7Qk4AyYrInGD1DFlBBFxY3kQwnGLIq+J7z8cGU5AY+s5hLfN/iWCmu/aq38QmHvrAZUL0fEm2+Gwh6eH8hVtj8yDrTFtn32clFduEK79g/xsc9+0VkVV7tzciu0CTVt5KulphJeGZvGplSgIjZ2aDWARSYU+VjcNVTpQNYiqFw8msPY7725VVM3od00HBhBPZ83UI6paNF6vLQC1cAWHHyPLQKGqkw3CSouzHboc6eeyPPKQBS2O4UeK7tSvhNLD6dGohOCez846iUX4hwhwojwefBXSdStWLLuZIVH4xouyTTfBwQgrBQXBJ3fvVYLgTvrHsaGkbF0VOSWpGJVgYmlxyFbu1hPhbY/uJNt+
 V6yqV18l
 kSlsJkwwgFNyuuK0ZgdFpqEVw7JEmlZTXGpCUB45X1LKlwioh2vXlYDa3RQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 9, 2025 at 11:35=E2=80=AFAM Zhu Yanjun <yanjun.zhu@linux.dev> w=
rote:
>
>
> =E5=9C=A8 2025/10/9 5:01, Pasha Tatashin =E5=86=99=E9=81=93:
> >>> Because the window of kernel live update is short, it is difficult to=
 statistics
> >>> how many times the kernel is live updated.
> >>>
> >>> Is it possible to add a variable to statistics the times that the ker=
nel is live
> >>> updated?
> >> The kernel doesn't do the live update on its own. The process is drive=
n
> >> and sequenced by userspace. So if you want to keep statistics, you
> >> should do it from your userspace (luod maybe?). I don't see any need f=
or
> >> this in the kernel.
> >>
> > One use case I can think of is including information in kdump or the
> > backtrace warning/panic messages about how many times this machine has
> > been live-updated. In the past, I've seen bugs (related to memory
> > corruption) that occurred only after several kexecs, not on the first
> > one. With live updates, especially while the code is being stabilized,
> > I imagine we might have a similar situation. For that reason, it could
> > be useful to have a count in the dmesg logs showing how many times
> > this machine has been live-updated. While this information is also
> > available in userspace, it would be simpler for kernel developers
> > triaging these issues if everything were in one place.
> I=E2=80=99m considering this issue from a system security perspective. Af=
ter the
> kernel is automatically updated, user-space applications are usually
> unaware of the change. In one possible scenario, an attacker could
> replace the kernel with a compromised version, while user-space
> applications remain unaware of it =E2=80=94 which poses a potential secur=
ity risk.
>
> To mitigate this, it would be useful to expose the number of kernel
> updates through a sysfs interface, so that we can detect whether the
> kernel has been updated and then collect information about the new
> kernel to check for possible security issues.
>
> Of course, there are other ways to detect kernel updates =E2=80=94 for ex=
ample,
> by using ftrace to monitor functions involved in live kernel updates =E2=
=80=94
> but such approaches tend to have a higher performance overhead. In
> contrast, adding a simple update counter to track live kernel updates
> would provide similar monitoring capability with minimal overhead.

Would a print during boot, i.e. when we print that this kernel is live
updating, we could include the number, work for you? Otherwise, we
could export this number in a debugfs.

Pasha

