Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F09D8CF45CD
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 20:53:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6239B6B0005; Mon, 12 Jan 2026 15:53:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D1CD6B0088; Mon, 12 Jan 2026 15:53:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D0696B0089; Mon, 12 Jan 2026 15:53:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3BBE06B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:53:54 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F3B52D0303
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 20:53:53 +0000 (UTC)
X-FDA: 84324513546.12.1B8AD11
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 48602C0002
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 20:53:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=fcrLqdsd;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768251232; a=rsa-sha256;
	cv=none;
	b=Lsl/fV3dwAn8bJmILL2/kGVsDGv/2f6eaieNK0DBTLR88zIcX4H/9MK2+AQ1idoSJhik7N
	Fk9XOBOrhlK/WuQbq6tqlaEw8jL939IE6Kh6Bfqvlm7sXs5CmBxglf90VY5BE9cl7F6xFC
	HIjXtadowGlJnmhfHIhnbzBD9A8AZvo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=fcrLqdsd;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768251232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uBXXF5o0pdnEYmS+0GgHzhXXXUzX8EvhUfTcXmNVDzQ=;
	b=gp8vS0FhASEXxgF6SrguGElcL6RyaEakENfHGAzossD+AIKU3kp5zF5wlpu94UC1SkeGqF
	XPadaB3s0j6Qyr1ueg/aNCv/6xCKAylXZd9tNcjyckDboDjm/alprLUgroL9/TrQLG1xwC
	FrphuR5WVyCpyY7ZSAzr1nQfD3kUc6A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5BD516000A;
	Mon, 12 Jan 2026 20:53:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3ADAC116D0;
	Mon, 12 Jan 2026 20:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768251231;
	bh=ie6Omrxq/W/eHhSqr4UBVGDnspkDc0hgmQPM9XYQErE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=fcrLqdsduaGm44osSwSPN2OmTnmHZDSQTFb+vK0TurhdOmTd+b6joebWJi7ugwjuM
	 WAHPqx2kg9/40sYmNYjfjQbCWB9501/dcWnfmb2MvGsFNmueEUtnhrPsolxdg7YyDE
	 oZydjAYwQP6P01xZ9qoo4MmQ4flizTLO+ilJD9LM=
Date: Mon, 12 Jan 2026 12:53:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Maciej =?ISO-8859-1?Q?Wiecz=F3r-Retman?= <m.wieczorretman@pm.me>
Cc: corbet@lwn.net, morbo@google.com, rppt@kernel.org,
 lorenzo.stoakes@oracle.com, ubizjak@gmail.com, mingo@redhat.com,
 vincenzo.frascino@arm.com, maciej.wieczor-retman@intel.com, maz@kernel.org,
 catalin.marinas@arm.com, yeoreum.yun@arm.com, will@kernel.org,
 jackmanb@google.com, samuel.holland@sifive.com, glider@google.com,
 osandov@fb.com, nsc@kernel.org, luto@kernel.org, jpoimboe@kernel.org,
 Liam.Howlett@oracle.com, kees@kernel.org, jan.kiszka@siemens.com,
 thomas.lendacky@amd.com, jeremy.linton@arm.com, dvyukov@google.com,
 axelrasmussen@google.com, leitao@debian.org, ryabinin.a.a@gmail.com,
 bigeasy@linutronix.de, peterz@infradead.org, mark.rutland@arm.com,
 urezki@gmail.com, brgerst@gmail.com, hpa@zytor.com, mhocko@suse.com,
 andreyknvl@gmail.com, weixugc@google.com, kbingham@kernel.org,
 vbabka@suse.cz, nathan@kernel.org, trintaeoitogc@gmail.com,
 samitolvanen@google.com, tglx@kernel.org, thuth@redhat.com,
 surenb@google.com, anshuman.khandual@arm.com, smostafa@google.com,
 yuanchu@google.com, ada.coupriediaz@arm.com, dave.hansen@linux.intel.com,
 kas@kernel.org, nick.desaulniers+lkml@gmail.com, david@kernel.org,
 bp@alien8.de, ardb@kernel.org, justinstitt@google.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 kasan-dev@googlegroups.com, llvm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
 linux-kbuild@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v8 00/14] kasan: x86: arm64: KASAN tag-based mode for
 x86
Message-Id: <20260112125348.124d201ef2baf762561a43af@linux-foundation.org>
In-Reply-To: <aWU-oL8oYS_PTwzc@maciej>
References: <cover.1768233085.git.m.wieczorretman@pm.me>
	<20260112102957.359c8de904b11dc23cffd575@linux-foundation.org>
	<aWU-oL8oYS_PTwzc@maciej>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 48602C0002
X-Stat-Signature: uqob8jitsns9ae4om7w76j5gii589pgu
X-Rspam-User: 
X-HE-Tag: 1768251232-674509
X-HE-Meta: U2FsdGVkX18PoWW0mp8e+h+zt2nT2jw9hh0ZHbNWyuO9+AAc6noiXCvtY0s4nw7l/1itJ4wuTcn9OHmoOxsCmhdbVf0sTJastNMGtbPrWZk44oJ19cz6hRQnvem/pvtVgRrfqpWzHrnnKYOGWizbNnTYjBrNuDJjRRKiOPLZhMOj4AHuuUwdSwDRq8k9GO7KISPGbDayEHlgqrUbPN+YdW/VNE4hQA2sI3VJYp8QwrX4Xc03Kd58XjCpWLII4USUGgKxVWjcMNrtmAN6Lz8260k1WOBTQ3gpDoYqmJqak2cXLulGKKb1npwjYFtJnWTbazw6oQcFjcbrjw7rCHwcNu1gH1+Ez7TG/DM5u95g3mE2Bpv2Z5NuqGkUy09BOVBD4yTGTI5lPWHj/A0TZTFeqVGqI98AIM5yjvl7szNePp+iDJ6pkaX3OjMU3MMRPMsd/ncMk2N1Aet8KeyQOhgy8og13atWoTM4kaDJS07M3jN+Ao7CsqcLPt7EqDIjAZWlmfymqYRGztZWaBVmcr49soHWzYP+kL8EqEHuHVGthpXXkrmwsoNlIZdQ8pkuDq+cyu67VuyTQIUlLSA0o8UhjUMU0seKHlOmed6azpjgHKlxHUOEZeprM8OQn0wJI0EyDAydstECGDKp0f1D5o3LrZ26LAChgqARnUFLsWfBD7odguhhRaRYkxP03Jc6gecGzvy4pyq88/vc5lrnxyUhFBiS+Mb1gzqhpk7dUXJZN9SoYIkEsEMdAshtVwcYaT0uAhy0o+8lvVdcZJI7ICPhth+pguAnLkXDLOdEEwhzgiQ6FExFEVMc0OykVTdWnYAgs2zFTZgNEaJDEsFAhSq6kHRZhHeFUU2tDC7vbgEdo2d67S+FqSuoWzWGkFxu0qmfGmgDxCqCY9kzHiRBa1Xgf6EnGVwKU1zoWbLtOxddayG7j97bjVRiq1w8/XCaBlePa4z0xt5J7Cq6Gs/plh4
 benj6jDj
 emSBTTtZv27MMefpKUl+loAbPLCsomRpq1n1bErT5R9RjN+GedW4FV8tNXjkuQ9M5+YSevwwEEi9eOVTKvoL8xixXuFmkaxsmDfDaGJmqS9aOxg1FpnfaPBlG94qY2Yr08rxbgMPa95RTTg5DxjDrLkAOW8NLq2iRcrNU1cps+25Swp4RwUUZjcG4+UqKTeIab8Yr1W9ezr9jiVDxnJYHgCfqoQQsSu0ePeiPtCklKe9zAfNOvCpicCkl7qAGhKNvFDAoDq6DlgRTDVi803n/7e8l3ii7VBPvou0fbaejavuEgCIk672GAJLPMQd3IO9Hep3gs245r3ThPe8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 12 Jan 2026 20:08:23 +0000 Maciej Wiecz=F3r-Retman <m.wieczorretman=
@pm.me> wrote:

> >OK, known issues and they are understandable.  With this patchset is
> >there any way in which our testers can encounter these things?  If so
> >can we make changes to protect them from hitting known issues?
>=20
> The gcc documentation states that the -fsanitize=3Dkernel-hwaddress is
> similar to -fsanitize=3Dhwaddress, which only works on AArch64. So that
> hints that it shouldn't work.
>=20
> But while with KASAN sw_tags enabled the kernel compiles fine with gcc,
> at least in my patched qemu it doesn't run. I remember Ada Couprie Diaz
> mention that passing -march=3Darrowlake might help since the tag support
> seems to be based on arch.
>=20
> I'll check if there's a non-hacky way to have gcc work too, but perhaps
> to minimize hitting known issue, for now HAVE_ARCH_KASAN_SW_TAGS should
> be locked behind both ADDRESS_MASKING and CC_IS_CLANG in the Kconfig?

Yes please - my main concern is that we avoid causing any disruption to
testers/buildbots/fuzzers/etc.

