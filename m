Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DC76CCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 20:19:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2B618E0010; Tue, 11 Nov 2025 15:19:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB42C8E0002; Tue, 11 Nov 2025 15:19:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7C798E0010; Tue, 11 Nov 2025 15:19:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A24EE8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 15:19:14 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 604F81DFEC8
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 20:19:14 +0000 (UTC)
X-FDA: 84099440628.12.BD98873
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id C683CC000D
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 20:19:12 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="i1r2Y3/e";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762892353; a=rsa-sha256;
	cv=none;
	b=Ct7FRxwvHVWF8KKow8fUyJpK7llxz17JQjxa6yD/UvXQ/KCfBe5gSImiv6+syQ9G6ub+oR
	HKS7Pl49dJvY3XKEUI88/7STzXXFiLUKjNzxFcnBHz2r8WJK+Hzp5vwmdA51Pxe3I9i6Ff
	1F6DokJdY7T2E3CbKwOTEH2ceNdg6vE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="i1r2Y3/e";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762892352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sp/OtzJlhWmxzUJY8Wus/gmmoWZnK26u1hlyL+7KvHI=;
	b=w+9OhmDhPkcytlRsY2qZRSOPy49gLuHw93+fn0+NUPW0L5T/gmbOG0v18XGjQfeciereqK
	SNR2Fx2cVLlfYh0bpxGXs7Fwxu9KbmJoErtD5GBrooQj647rUFSS0GKnn56iKW/UUZJm/1
	c39vkxDbO8uY37OVa2JJoa5t5BNilLo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 84CBE40BA5;
	Tue, 11 Nov 2025 20:19:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D978C16AAE;
	Tue, 11 Nov 2025 20:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762892351;
	bh=fu6s4/xojeZgX7aNEWJfig73AGlXvP+znZlBg9agON0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i1r2Y3/eCL0Xa1MPNF0IPCxP2xdKudBp6EZ4cRQgfP4VdypOsH81FEZotsSfUiHgF
	 cxTKhhYY6VoiwxWk49M2q1Dd5X7DrOaUYN6CD31pg6hRhseCY9+7TPbwl+fE6WDY3J
	 31yszZrpQjppaORB+oPZZPM+0RE4xt4NeYgT4dYAT0rxBTI4o1+5oOfU6U6A4lRZ0g
	 a8AJUZGlBDEH/REX282Zj/V/0p3VxdI1WknGoEoxhbzATEVAhgaclM9Tv1CxfsmQUz
	 JaYcvB8j8Yuz9n5SbCpWwKnjk1cA3nIn+JhfYLvi3YqQ2SQ/CMl3wbK5nMn9PQC8tS
	 jBOR9zCSUendA==
Date: Tue, 11 Nov 2025 22:18:45 +0200
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
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn,
	linux@weissschuh.net, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-mm@kvack.org,
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
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
Subject: Re: [PATCH v5 05/22] liveupdate: kho: when live update add KHO image
 during kexec load
Message-ID: <aROaJUjyyZqJ19Wo@kernel.org>
References: <20251107210526.257742-1-pasha.tatashin@soleen.com>
 <20251107210526.257742-6-pasha.tatashin@soleen.com>
 <aRHe3syRvOrCYC9u@kernel.org>
 <CA+CK2bA=cQkibx4dSxJQTVxVxqkAsZPfFoPJip6rx8DqX62aEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+CK2bA=cQkibx4dSxJQTVxVxqkAsZPfFoPJip6rx8DqX62aEA@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C683CC000D
X-Stat-Signature: mj44fh3jd5hqr8s1r8mem596n94rniuj
X-HE-Tag: 1762892352-293277
X-HE-Meta: U2FsdGVkX18vHDNlLp65EiqW7Ygl770wg5P3I7W1pQHBIrJIpJG9ErT0FjQEcGS8ef6iNBvtaknjge11XKRB+Id7t3ytv0Gn9oB6WZy54HdQiBrsCGu0z6IEAgX/PDhK4PiEx2brutw9tRNGTo330xpLbf4eg1pauOExF+aMTqYXe3j3fDAIBDXLmpSlGSEG7V9SkNsxtWfqXRLfMt7UB9q/rjSCIn5XlEqEeqOGzH/FXf7zWa0OJslUAVtEJD2nJToGpz7tmvzxXyRZHShBqpafusbMky86v/dFn7J5pzr2mv5s+Uu0lPEPnBadneslAUGR03PnDpEBDPKEmz0d6iRFceCAAGsC4AxUj+0LxcyLmyFoNLV/UkiFwIAcjIc5HIcjwlrWBKgai45qVjZyodHHx6xqUxN7jPL/kjVP9K6ZuoPZ7jabQC6JkS6tY5KcjkeJ3fwxNBaLELztcoFUUERTcsSf4uuoagE3NXZ/OtL0U8+bFU53FIt7sttqTinVXSPUxEeGVyW0qEox1DodZ9WDseiz0YxYQGgdZDlNqHhM8ZFVMEgRWV5vbUoBvLdM9axbxHIUGMTgtsONZ1I6zSv67BWBf5vFz8xHaS+hqBdeG1eHQv/yCKxdRovxlT81xIxl4oQrfjJxQEevDrBWIEUkNV1YVJPoX+qAyAaQtbNFnLyYCtUXdH1XObd6mulT3OD3S/fHauwpxSbzQy+5DuiKRF/LQZhXBqnxAfzeqHoTmHL910fYeqtbrXENgBo2tlSpn7G8fRHjSj1VhwNyV0QOUNCjUww9aL94/4+QG6L0xWe4H+yrrSu+2WEdkM7tsDjsJd230yoDn4jO3lEOIMSRemGpzvJnS7b6bY8e96m3l4qh6O63nhVWUrMXfymWja46twdJg3DbhAamR5DKQb0GXHnozqbXGXN3Gu2KXGTpYFdoL6jIQqz0LJFDQM4qfKNHN4lyqbzkq/pnnCQ
 H4KRZaOl
 4wqrawyFN0ctCn1zN41Ep4qiCLhKRp3HuQOVvh8+qNJeU8mQwwzZfoJ73864RSXfzuC2q
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 10, 2025 at 10:31:23AM -0500, Pasha Tatashin wrote:
> On Mon, Nov 10, 2025 at 7:47 AM Mike Rapoport <rppt@kernel.org> wrote:
> >
> > On Fri, Nov 07, 2025 at 04:03:03PM -0500, Pasha Tatashin wrote:
> > > In case KHO is driven from within kernel via live update, finalize will
> > > always happen during reboot, so add the KHO image unconditionally.
> > >
> > > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > > ---
> > >  kernel/liveupdate/kexec_handover.c | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> > > index 9f0913e101be..b54ca665e005 100644
> > > --- a/kernel/liveupdate/kexec_handover.c
> > > +++ b/kernel/liveupdate/kexec_handover.c
> > > @@ -15,6 +15,7 @@
> > >  #include <linux/kexec_handover.h>
> > >  #include <linux/libfdt.h>
> > >  #include <linux/list.h>
> > > +#include <linux/liveupdate.h>
> > >  #include <linux/memblock.h>
> > >  #include <linux/page-isolation.h>
> > >  #include <linux/vmalloc.h>
> > > @@ -1489,7 +1490,7 @@ int kho_fill_kimage(struct kimage *image)
> > >       int err = 0;
> > >       struct kexec_buf scratch;
> > >
> > > -     if (!kho_out.finalized)
> > > +     if (!kho_out.finalized && !liveupdate_enabled())
> > >               return 0;
> >
> > This feels backwards, I don't think KHO should call liveupdate methods.
> 
> It is backward, but it is a requirement until KHO becomes stateless.
> LUO does not have dependencies on userspace state of when kexec is
> loaded. In fact the next kernel must be loaded before the brownout as
> it is an expensive operation. The sequence of events should:
> 
> 1. Load the next kernel in memory
> 2. Preserve resources via LUO
> 3. Do Kexec reboot

I believe that when my concerns about "[PATCH v5 02/22] liveupdate:
luo_core: integrate with KHO" [1] are resolved this patch won't be needed.

[1] https://lore.kernel.org/all/aROZi043lxtegqWE@kernel.org/
 
> Pasha

-- 
Sincerely yours,
Mike.

