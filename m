Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCF19D0E6E0
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 13:08:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A1AC6B002A; Tue, 25 Nov 2025 08:08:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1528C6B002B; Tue, 25 Nov 2025 08:08:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 040C76B002C; Tue, 25 Nov 2025 08:08:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E82616B002A
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 08:08:45 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8EE0AA6194
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 13:08:45 +0000 (UTC)
X-FDA: 84149159010.26.22668FF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id DA61140011
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 13:08:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N4XhmBKV;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764076124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YPtrMhtvlXVPpT3N2bsfJW9CaFk19AHjcdgQoJoyOOc=;
	b=LoZNJc7Q5LaroeDDd6N2RQVsaQrJu+A+D/GDVOaGTziKUOiv9aeLSDP+40xopx2jgccYjz
	rMepsTA/0joRvrOTmaKPjWe9b5NIfjbgiyI25p2s37gnj3DP+xEYnrLmE0PYkykrtn1gMM
	WSr8GOuuwi3UdJrP2iLE9zhXSalP5iw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764076124; a=rsa-sha256;
	cv=none;
	b=jMgVg3VsXOEJ01ZwaxLIq9V4nSMOfVwrDEaJT3src/uKvJmkggGJD7/TeLMLcrB5zW+io8
	jjvMfy++NKpYPybNcVC0n8bRds4A2vphdCJoHrDeJI2a5GVXretnu2BUwo7VfNX65XCxzt
	ab93/D0P6c+4pUbQi3ilgjUUzzP+0gA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N4XhmBKV;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CC4D94370A;
	Tue, 25 Nov 2025 13:08:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D386C4CEF1;
	Tue, 25 Nov 2025 13:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764076122;
	bh=dHFz6qR/I9ZFBforH40m7KtLMQ9NhVkinfXAsC6xU+U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N4XhmBKVuKkpuROmmK4pPwB4aDpmhsMmOBJu0LOA/wCbUltTpWw7lpfRbgXtkVoNK
	 id3bIy5xKOEFBIjmgEe1kTkRjxKMmiSGyf3rMaCLyRMTpTcAdCbogdS5qEflK5wDng
	 1wlg18Sz2+kvbgjdsfqXEa0bM2ewgVoK3lwH5++i1nTQNlXSpPCMtrTbAYhFzvEdpg
	 kUcWpe8KPiPktz3FzquYixQAHYMtN5A8B8O7sX3mC9jOBWm4vnIpt8UgASmK2MGA/h
	 Pod7dUxXsiKWhPvykeECGahNqYUv1GLFELSQV0UJlqclrmAzKqsR/VCIrBpv2WJ5hh
	 EiEs8aqGz5BLw==
Date: Tue, 25 Nov 2025 15:08:17 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com,
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net,
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com,
	masahiroy@kernel.org, akpm@linux-foundation.org, tj@kernel.org,
	yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev,
	chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com,
	jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, linux@weissschuh.net,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, gregkh@linuxfoundation.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com,
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com,
	skhawaja@google.com, chrisl@kernel.org
Subject: Re: [PATCH v7 02/22] liveupdate: luo_core: integrate with KHO
Message-ID: <aSWqQWbeijvruDqf@kernel.org>
References: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
 <20251122222351.1059049-3-pasha.tatashin@soleen.com>
 <aSLvo0uXLOaE2JW6@kernel.org>
 <CA+CK2bCj2OAQjM-0rD+DP0t4v71j70A=HHdQ212ASxX=xoREXw@mail.gmail.com>
 <aSMXUKMhroThYrlU@kernel.org>
 <CA+CK2bABbDYfu8r4xG3n30HY4cKFe74_RJP5nYJeOtAOOj+OUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+CK2bABbDYfu8r4xG3n30HY4cKFe74_RJP5nYJeOtAOOj+OUQ@mail.gmail.com>
X-Stat-Signature: z5zd8tiz8te899wjf53j9tge7n7r9tfz
X-Rspam-User: 
X-Rspamd-Queue-Id: DA61140011
X-Rspamd-Server: rspam01
X-HE-Tag: 1764076123-694958
X-HE-Meta: U2FsdGVkX1/MvaU+HYSkGMS5DV5dRjQeqEG78xhvFnVlu2hO1HQ/+DlIZYuLuyGtKXue0MYUjAlH2j6j11jTLHKCF+vVhI3THDWcPbkwmQcuM1TpO9MAEfF5vyM9oGp2VHmvH0bX1mL8vSiA80taROzQg/xNfNOqxeo5kUcrGVUE8PozY8N/yA986/E4hTpAzHxbgWMiUiir9znwOuiwgewkFlM5oOXN+JATQUSC2ACQYn6YkNqQVI0p/o3iE1w2ji/6GejU2QwfvJM5BQRjo/z3Xx40blh5Yoia678MbO+QWb0BPc+ppv7RMyYQ2ry6P/30NEwAuvIRmMAMSYjdC3kG9aS2LG1hKfS3WNrjbR/pfBQ2Dj93pNdwaGhrSeB5hvKZ2Nq6DcAk5fiyibUf32yPN3hYSB64qNxzGPg75W38BCHbIl6o9wTKRn6LwpFP6tXrIaZeZQ1fwuuMQLUtjsswKhnD4xW679xsViF+eps+ceHcy6AbEWbx4vmd2XGlzaPYb1p49SQhTHYproRdqvv4U+vIG6mMVT2FquJyDcpFudjOebFgy+cOpUpMIfWFkcX22NyP27zizqgysgrvI08oeA4iRZUlK5m1dXsQkbcS7ZgjUKYznEd0/HcomzbuqKEX+phfAi6PNSBI747gLFJdrifsLG+3Lb906eCNSdYnT72Z6eFAa7pkmTVzrHhVagjtBCdGghy6Q/iq63H+e9rA/yMTYAjbNscZpCDOtYRZPJmJLA7hSWTCqRmsX3HIotK4mZEVrDK+yGuvL/iNVfuHCRzo9zsSrILpSkWIYVGXCZXLT0hY0m1JHt78e6njqOSEEh0xMA/5cQ1RtEPJ8sDXw/JyQPaB2i6VGbUeSO05GXsXOLPAKkCBYFI+2QYLQS479Yvd9rZE04FcHN9lhxIBNlz37SZ0wWq2PL+8ftB5fCZVUDt1OEs5UUKXBdnxOw2+vCLpamyFmg5YT9A
 4m9QQ+2R
 sH4chKrSBLZYaYsJ7/7k04bWfaog3wvlC2VWdk4RYnTaADHo12HASY1DocGykzd8pAeUIyXiduaLICig=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 23, 2025 at 01:23:51PM -0500, Pasha Tatashin wrote:
> On Sun, Nov 23, 2025 at 9:17 AM Mike Rapoport <rppt@kernel.org> wrote:
> > > > > +static int __init liveupdate_early_init(void)
> > > > > +{
> > > > > +     int err;
> > > > > +
> > > > > +     err = luo_early_startup();
> > > > > +     if (err) {
> > > > > +             luo_global.enabled = false;
> > > > > +             luo_restore_fail("The incoming tree failed to initialize properly [%pe], disabling live update\n",
> > > > > +                              ERR_PTR(err));
> > > >
> > > > What's wrong with a plain panic()?
> > >
> > > Jason suggested using the luo_restore_fail() function instead of
> > > inserting panic() right in code somewhere in LUOv3 or earlier. It
> > > helps avoid sprinkling panics in different places, and also in case if
> > > we add the maintenance mode that we have discussed in LUOv6, we could
> > > update this function as a place where that mode would be switched on.
> >
> > I'd agree if we were to have a bunch of panic()s sprinkled in the code.
> > With a single one it's easier to parse panic() than lookup what
> > luo_restore_fail() means.
> 
> The issue is that removing luo_restore_fail() removes the only
> dependency on luo_internal.h in this patch. This would require me to
> move the introduction of that header file to a later patch in the
> series, which is difficult to handle via a simple fix-up.
> 
> Additionally, I still believe the abstraction is cleaner for future
> extensibility (like the maintenance mode), even if it currently wraps
> a single panic (which is actually a good thing, I have cleaned-up
> things substantially to have  a single point  of panic since v2).
> Therefore, it is my preference to keep it as is, unless a full series
> is needed to be re-sent.

Well, let's keep it. If we won't see new users or extensions to
luo_restore_fail() we can kill it later.
 
> Pasha

-- 
Sincerely yours,
Mike.

