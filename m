Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85B45CEDDB0
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 15:19:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF4856B0095; Tue, 18 Nov 2025 10:19:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCBD16B0099; Tue, 18 Nov 2025 10:19:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C08586B009B; Tue, 18 Nov 2025 10:19:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B070F6B0095
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 10:19:11 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 83B86BA2E0
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 15:19:11 +0000 (UTC)
X-FDA: 84124086102.02.047F23A
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf09.hostedemail.com (Postfix) with ESMTP id 749EE140011
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 15:19:09 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=c9SjT6CQ;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763479149; a=rsa-sha256;
	cv=none;
	b=UuUwqP7rtunFhkh+dRA1PbClqMFj/QEFugtEZoulUz+hAzAKYKa4Rq/TfWEWSUHk8jf6d3
	cUwbLYKg+7boSx/lh/djxlMhJgqdqHPOz3/yeRH0q628JHmJt4Ht9ugvgpkLjGGCs4kqlj
	1edLqmVDEM1V8efpnEPsBeefCfIJusU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=c9SjT6CQ;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763479149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hk0ZXs9FzwYps2jxvQYT5vEXRk0C4Qe8Vs15fTPcizc=;
	b=wmK9eDdeDvZ/TrZag+jONuRVZMsdgAUxXTSwEXjKVKwC7dga9AaHXqBdeawFn4aRIlnwLM
	MWzQAoUcL9WBDDNkPrcuTqNAZsjj92//06r/wBm5MJwoAnj6vZ1VV0NmMUqU2JNzcCpd/K
	eXB5b/eG7E/sAC5mUbhwaBkQ9QautbQ=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-644fcafdce9so1847877a12.1
        for <linux-mm@kvack.org>; Tue, 18 Nov 2025 07:19:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763479148; x=1764083948; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hk0ZXs9FzwYps2jxvQYT5vEXRk0C4Qe8Vs15fTPcizc=;
        b=c9SjT6CQFKyIz30oIRth/NoUTy/GE263FQ1R96s0ufeNiLp9or5qrT8r08q3tPNa4h
         g/DoPYFGMHV081kBshXMIb/ti2GK8gN498Vuisqu/LXCij/KVdm0mDKSDw20fqgMkpS5
         DL6XuyfcYYVoUk0iBBewHrj4svWzMJocEWnJvsrpP3hjRlfoZ3U68fTkqa+JrjtTPo8L
         lElLW3Fwxxm1C4DGGf8EWhi68FKd/AeVHF7L49baIEF8taC2YjFAUVu3HfU58TVaxM9Z
         ZhO7WoWfWTfODE/A4s92r2L0Kw/SgCyyYFXJ6+a530kC2siBHhWUTUj76g31MvzGqCL/
         mWMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763479148; x=1764083948;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hk0ZXs9FzwYps2jxvQYT5vEXRk0C4Qe8Vs15fTPcizc=;
        b=KJ8YQnZWSOhIDCyH17a7h8fWuBvvoZkAeEv7VLaPHt1S6Nu59WvMrvXDOR1rfS1jd5
         Xu5NzDdOZnMEv72nirYVP/IVRBZsZrMQGQAdNn1AM0lTtbd1xb3nIdPRDqZ2ZgimvUgW
         iPdWujMw+Q2s9SAyWy2H3bAHn5Vc2tm8fVmZbRadHZj2Bres544ETJRgQQrN2Mt6Fgvs
         sr+QJwryGsMfQnSz3bFd3UcyMj9SttHiKopQ0C7XCh/ve/OvlfWVTkmUVEObMN256EFX
         2ZwFDAaE0oH2hER143x7DQ9Enjk5RkZfFaUDQPOWKZTVSRJb/65RABLnIf2Whbi26bEH
         YBHw==
X-Forwarded-Encrypted: i=1; AJvYcCXQX3UV0rzfDDiszexJM3fTG9Lag6+D8gr1QHTIzHz22lko/3kpQeKHJg7BFWQgquFoUaUCxYLhrw==@kvack.org
X-Gm-Message-State: AOJu0Yylvi5TPZxDJ/PyNI/UCercXo79beip1ZbQTGmjoAvBjR5rLNoT
	P1its8yXd7lyPr1TOUXhb6WFktytObANm36fef5yY/E4y1EA8v0r5ITVoHvDc0y/P6ea8qOCQ0Y
	3SIKic8qiTrc0M9x5+sUbse2vy8H4cRS9vyfMdle9JA==
X-Gm-Gg: ASbGnctlne6JiWe/n6+UT6hUOPVBJ3/Lz4awp0Tkkbx3eIGvzbBURimM7Od3DVs9J3n
	OGJ/oGqmy1Umn3yDFjES6XBYa2iU4q0hkcBZfRbxP+E1kuSUL3T1OmEvD8NJI2MKl5ufdeTQaMq
	CW17fBHyeNqGPE40Gpw+GMeAOaDbCwzqrUEBhjf4loqunfDXarU3LA1qvlYuBLXemmJgBNQ7F9G
	roc13nYVFucPYTOyD/qo/sml3KCM0PcE5W+Bku2E4BF0VV+dXDs8vUvp4tcPZ/Zu1VT
X-Google-Smtp-Source: AGHT+IH73uaGXtkqWxA+vOqKSKXyc2f3xkXFQtsjUi4wNeWbkqpozwjKaxfRNk8v2eP437M4d3oprpw2Yh3MBItYnTs=
X-Received: by 2002:a05:6402:1d54:b0:641:9aac:e4a9 with SMTP id
 4fb4d7f45d1cf-64350e20d78mr16134284a12.15.1763479146917; Tue, 18 Nov 2025
 07:19:06 -0800 (PST)
MIME-Version: 1.0
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-3-pasha.tatashin@soleen.com> <aRnG8wDSSAtkEI_z@kernel.org>
 <CA+CK2bDu2FdzyotSwBpGwQtiisv=3f6gC7DzOpebPCxmmpwMYw@mail.gmail.com>
 <aRoi-Pb8jnjaZp0X@kernel.org> <CA+CK2bBEs2nr0TmsaV18S-xJTULkobYgv0sU9=RCdReiS0CbPQ@mail.gmail.com>
 <aRuODFfqP-qsxa-j@kernel.org> <CA+CK2bAEdNE0Rs1i7GdHz8Q3DK9Npozm8sRL8Epa+o50NOMY7A@mail.gmail.com>
 <aRxWvsdv1dQz8oZ4@kernel.org> <20251118140300.GK10864@nvidia.com> <aRyLbB8yoQwUJ3dh@kernel.org>
In-Reply-To: <aRyLbB8yoQwUJ3dh@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 18 Nov 2025 10:18:28 -0500
X-Gm-Features: AWmQ_bmBeX4hEJXb1SebGbQCukqm3GOn5m3ynIQiDheXLPwAAGR4LZnSH-Cy4rU
Message-ID: <CA+CK2bBFtG3LWmCtLs-5vfS8FYm_r24v=jJra9gOGPKKcs=55g@mail.gmail.com>
Subject: Re: [PATCH v6 02/20] liveupdate: luo_core: integrate with KHO
To: Mike Rapoport <rppt@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>, pratyush@kernel.org, jasonmiu@google.com, 
	graf@amazon.com, dmatlack@google.com, rientjes@google.com, corbet@lwn.net, 
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
	saeedm@nvidia.com, ajayachandra@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com, skhawaja@google.com, 
	chrisl@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 749EE140011
X-Stat-Signature: ajpw5er3xp3y1hak6ckwpm4ydd318aob
X-HE-Tag: 1763479149-497890
X-HE-Meta: U2FsdGVkX19DqwzAT88mdK26Bd42NP3GakCZ4SJ+oJRHfWrRvQh9mAK8V/N3zcWAQML1M0qRyKkmvOJjbLeiU9/omVn62+TkTtyFFVp6R7vi59A2OYg1HFnQlGHh4WsIysw16Dirdqw/CstdVGCQ1tWZ+hOmCiyN0exmP6ZGP6qC3PsNTkyiP1zA8VI/eYUsV14XJjFY0oM9MHWW8NuXE64t8ktC9H9d1v0nXbvkTFDQn6FzJBHn8q7Q1uUJUcCB3244RKZiQYl4lk0FJSyF46qMDNdffl9VR0UPnBWQ0uRrnrKpq/JXSPqjqRUPTHCY604NtBmAIPTpcjsVxLNyeUS44uACf0hMzs1ju3+f5ggErkOUMny/KeDFDLhtQadf/fwc3wGMtqSeIJiqKgCO3/D4L9M0Sm+gbclu6v0h07ap+/VGnlZtLVe9y6E7hPRFKhaIsxR2S70nF+ax1V9ht1P2Dsb5gXKTdkAEYDjs4PdLv34PzhjSVzmkgZaMIitbNxgRt/ZP/q2X7/DIt9GEZEBlStwdyFLBycN1Xd/sFOnfWAkfuRHU0iZx9P8LQ7X64+we0IKnK88aZFdpxGS++Bo/01bayTlmmlVZxNCgcxhOXLzSSAZlPKGldpvU8zQOLQbjOScDp3cRYXEUhGhB90GGr9wXLD+oKOmoXta+sdoxr1Hwdtgg3d9aaQc1tRHDNcky04MEPlYq0RDjkQBFsRitrg0bwqt35ekPOp1YiCeyl8rIqiQsLJsAPGj88hDcYpT5S1KPMDystpm7IY3R/1yFhhLjB/B1BVIHy+Fa/zwVPhrQZq+QfqIe2L9OkGtW39S/Jk9iSt7xKmedjfGnO3t1/hY1KjDqHuqhqHK+wPrNjzv+3TNhqyYQiPI7CcQed0k/wWoFLA/WLP/t+rtdG1AobAwfZGXEJ4yJh55SBGNjps7vD5ZKVNXFBFcegyCawfsrLkG6wbl8oAmf53k
 NIQ4pSSC
 13Do75fltM4r2lCHEnnkq1EvWyFnsyjn+NlwKMCifNeieUB11VWG8LKBZ+oOJorUu95dNxneRAuDT08YlMTOkaC6Pv/Ewpt0nHVF/JERfcBKjCybitHl9LLQ2r6ETrVViB48NNRI+kMHneAZMZjoUPpvsWqRwrI92EewbK5km8/Op6IxVS5wljv1ahIZ76NPiizuVfOT5v8hoHx8Q3TW7PtU2iS4KzvpwM2kSY9k7VdiLhL6+0Rn9KFtL/hLKGqo5t1D2+LlJ0TdW0wvzGAoJCqt52MFGO8F4aB8tLczWBeCu1fkT1fDlEx8RB6YgAhDxpqBvHZzPEgeNcbg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 10:06=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wr=
ote:
>
> On Tue, Nov 18, 2025 at 10:03:00AM -0400, Jason Gunthorpe wrote:
> > On Tue, Nov 18, 2025 at 01:21:34PM +0200, Mike Rapoport wrote:
> > > On Mon, Nov 17, 2025 at 11:22:54PM -0500, Pasha Tatashin wrote:
> > > > > You can avoid that complexity if you register the device with a d=
ifferent
> > > > > fops, but that's technicality.
> > > > >
> > > > > Your point about treating the incoming FDT as an underlying resou=
rce that
> > > > > failed to initialize makes sense, but nevertheless userspace need=
s a
> > > > > reliable way to detect it and parsing dmesg is not something we s=
hould rely
> > > > > on.
> > > >
> > > > I see two solutions:
> > > >
> > > > 1. LUO fails to retrieve the preserved data, the user gets informed=
 by
> > > > not finding /dev/liveupdate, and studying the dmesg for what has
> > > > happened (in reality in fleets version mismatches should not be
> > > > happening, those should be detected in quals).
> > > > 2. Create a zombie device to return some errno on open, and still
> > > > study dmesg to understand what really happened.
> > >
> > > User should not study dmesg. We need another solution.
> > > What's wrong with e.g. ioctl()?
> >
> > It seems very dangerous to even boot at all if the next kernel doesn't
> > understand the serialization information..
> >
> > IMHO I think we should not even be thinking about this, it is up to
> > the predecessor environment to prevent it from happening. The ideas to
> > use ELF metadata/etc to allow a pre-flight validation are the right
> > solution.

100% agreed, this is the goal.

> > If we get into the next kernel and it receives information it cannot
> > process it should just BUG_ON and die, or some broad equivalent.

I initially had a panic() that would kill the kernel, but after
further consideration, I realized that we can still boot into
"maintenance" mode and allow the user to decide when and how to reboot
the machine back to a normal state.

Crashing during early boot has its own disadvantages: the crash kernel
is not available. Also, because live-update has to be very fast, the
console is likely to be disabled. Therefore, getting to userspace and
allowing the user to investigate what happened (e.g., automatically
retrieving dmesg or a core dump and filing a bug) before rebooting
seems like the most sensible approach.

This won't leak data, as /dev/liveupdate is completely disabled, so
nothing preserved in memory will be recoverable.

Pasha

