Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47053CAC589
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 08:34:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F9DA8E0013; Tue,  9 Sep 2025 04:34:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AAE08E0001; Tue,  9 Sep 2025 04:34:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6994D8E0013; Tue,  9 Sep 2025 04:34:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 567328E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 04:34:47 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 142A51DE46D
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 08:34:47 +0000 (UTC)
X-FDA: 83869051014.13.13A2F29
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf11.hostedemail.com (Postfix) with ESMTP id 27EB14000A
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 08:34:43 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=AkETeRDs
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757406885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tUi9+YGmuLz8MduOv6pUfelR4HtcHzXR6NiGUZMk3E0=;
	b=ZhZH3B2J4I//Cg6kUsIeSe+uO7WTkWS+6+E4X2F4sZW2yWKHPWJrNgdCURlxppFSA+csDL
	g0HL2aCmLF8Jc9g60Q8VjY3N6R3N0aRs1SqGeXkbIeBxhfob8IBed9esmINT4SXPQak1XO
	ly/x/OYUuU7UsURXBaYzd6vbayQFvcM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=AkETeRDs;
	spf=none (imf11.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757406885; a=rsa-sha256;
	cv=none;
	b=UX/xyi/40g/J6iofRYbjjUOT28dSR9v+Q2YjUxAXmuniOgPJtqzayzjus1Kb2xX2DUTCHg
	KogfQUApPW9uojw5eLXuPqoqCHquBLCelZBUNRwni0w7sRoZ0OjApKDi0XtfRnCtVY5Pmu
	DuRi+vAYrMFblcDvdnRFUBys0EAOlYQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=tUi9+YGmuLz8MduOv6pUfelR4HtcHzXR6NiGUZMk3E0=; b=AkETeRDsJTdI6UKG6HF4BPJb5D
	NmpsuselVIUxvyqPhp0976Uqa6+dKeCYTKNqrqUG7Sjnyl3KQt6opcecyzSOlcl5t9T+Uw3AJJrBk
	1rqvkEpCg37RxJNOvsLxEehluqRq9ekIdY6P51muShRZnh0deroS4nBSFcr/BBfE80mU04qK7HM/u
	0o9/lmKI25eIkyMoGk2/EEpkYkGkaL1xVylA6C/m28W1AYCHKVdU2iGttSdxhKTj73YgpRn0ENU3K
	m4TGddv9xzMGisnCwgebtxzRqANgkTFu0guFUmTIiqXWU37nrSLJRNPaak1o1oWsNRTCk7rO5BCM+
	KzlGyozQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uvto3-00000005FzH-2299;
	Tue, 09 Sep 2025 08:34:27 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id D2142300579; Tue, 09 Sep 2025 10:34:25 +0200 (CEST)
Date: Tue, 9 Sep 2025 10:34:25 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>, sohil.mehta@intel.com,
	baohua@kernel.org, david@redhat.com, kbingham@kernel.org,
	weixugc@google.com, Liam.Howlett@oracle.com,
	alexandre.chartre@oracle.com, kas@kernel.org, mark.rutland@arm.com,
	trintaeoitogc@gmail.com, axelrasmussen@google.com,
	yuanchu@google.com, joey.gouly@arm.com, samitolvanen@google.com,
	joel.granados@kernel.org, graf@amazon.com,
	vincenzo.frascino@arm.com, kees@kernel.org, ardb@kernel.org,
	thiago.bauermann@linaro.org, glider@google.com, thuth@redhat.com,
	kuan-ying.lee@canonical.com, pasha.tatashin@soleen.com,
	nick.desaulniers+lkml@gmail.com, vbabka@suse.cz,
	kaleshsingh@google.com, justinstitt@google.com,
	catalin.marinas@arm.com, alexander.shishkin@linux.intel.com,
	samuel.holland@sifive.com, dave.hansen@linux.intel.com,
	corbet@lwn.net, xin@zytor.com, dvyukov@google.com,
	tglx@linutronix.de, scott@os.amperecomputing.com,
	jason.andryuk@amd.com, morbo@google.com, nathan@kernel.org,
	lorenzo.stoakes@oracle.com, mingo@redhat.com, brgerst@gmail.com,
	kristina.martsenko@arm.com, bigeasy@linutronix.de, luto@kernel.org,
	jgross@suse.com, jpoimboe@kernel.org, urezki@gmail.com,
	mhocko@suse.com, ada.coupriediaz@arm.com, hpa@zytor.com,
	leitao@debian.org, wangkefeng.wang@huawei.com, surenb@google.com,
	ziy@nvidia.com, smostafa@google.com, ryabinin.a.a@gmail.com,
	ubizjak@gmail.com, jbohac@suse.cz, broonie@kernel.org,
	akpm@linux-foundation.org, guoweikang.kernel@gmail.com,
	rppt@kernel.org, pcc@google.com, jan.kiszka@siemens.com,
	nicolas.schier@linux.dev, will@kernel.org, jhubbard@nvidia.com,
	bp@alien8.de, x86@kernel.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, llvm@lists.linux.dev,
	linux-kbuild@vger.kernel.org, kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 13/19] kasan: x86: Handle int3 for inline KASAN reports
Message-ID: <20250909083425.GH4067720@noisy.programming.kicks-ass.net>
References: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
 <36c0e5e9d875addc42a73168b8090144c327ec9f.1756151769.git.maciej.wieczor-retman@intel.com>
 <CA+fCnZcMV0BOJyvx2nciCK2jvht-Hx0HnFtRzcc=zu+pQSOdVw@mail.gmail.com>
 <couuy2aawztipvnlmaloadkbceewcekur5qbtzktr7ovneduvf@l47rxycy65aa>
 <hw7xa2ooqeyjo5ypc5jluuyjlgyzimxtylj5sh6igyffsxtyaf@qajqp37h6v2n>
 <epbqhjyfdt3daudp2wx54jsw6d7jf6ifbr3yknlfuqptz7b4uq@73n5k6b2jrrl>
 <CA+fCnZdJckDC4AKYxLS1MLBXir4wWqNddrD0o+mY4MXt0CYhcQ@mail.gmail.com>
 <ra5s3u5ha6mveijzwkoe2437ged5k5kacs5nqvkf4o7c2lcfzd@fishogqlatjb>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ra5s3u5ha6mveijzwkoe2437ged5k5kacs5nqvkf4o7c2lcfzd@fishogqlatjb>
X-Stat-Signature: wpds3qgd3pss1b6794x8aqqefgdtxtaz
X-Rspam-User: 
X-Rspamd-Queue-Id: 27EB14000A
X-Rspamd-Server: rspam04
X-HE-Tag: 1757406883-877510
X-HE-Meta: U2FsdGVkX1+5dMVmcX2Wt3/2EDAKBBQFOw12NKRq5wwBqP6y577v7NkBYSwYpDWALJC08BN2khPPQEoMYolxMoM/hWFiSTrq38DwEFRQ1fYjH5vSRXMWwqrcQtf1gfVEhswEPTcP19egY//7H0xBvhUtERaWlETWfneYIO+YkJSD1c+XXGDL1F9scz94kJqYiFacWt3u6XW6O+o7BRNzcWqu9GUalhPO+rJ/ldvVqSz32nZriorUz8ZQoDPHir32ycNlA4lOSs3VxZfCNUP+nATIfEj1+iFz8fse+wH9KUM7rvToAitjfkQo6Rm3IbOnkSQ6j2+CyWz6JGBFzW0WgQvkDowxvQYyaaVOdAyZRpQIjPYeDYaJOiVw8TGd2KufUt72Y10QjEzZk04ZuC7UWI2ywKocpwd0AvICYUcCs9V1Nm+UAc5MLK2aqs9LWItKxQYFIJJAETN49rSl8kUz//GirLDYx6zN0EvVcrwSFzvGS16zRHW8S3Xl/DX7HnJQzSiCCidJgd+n1ZerN+dJvlyzXS4IziXXORF9XbVzdHqBoleF6ZkilFG9GBjHi+vTdA9I3OJSBXPYnUj7S9b5+XtjpmjX/URRjqtqAHkAgo4TSTRyssSE0mMHv/bg7KoC6GPDsiqt3sbl27zqtt6L43+QSGU2+GA5qqTOYBCXxyx/scfcq754seUROdYRLGaTqvupqEsNj3ohXAL6LQzyfTf1TgPEy7pzUCUzXeEgUTtdj71G/Ew1hTFWujMoJg9DVEd5CQiJAu325vLes/qkKLl3A1frCmRaVrmLeq+74rAMs4DEE9VXH6iHPsXmnEzjimMm0vYoLV6N0xVNBQ4Sfk2sBFeKp+6KntmnnTPqwqwutNZ1DJks1pxRcfFBuNkpZJbNGSoq19SSAyQSBj811NXXG9vxs1pmLhugJwLK3MDaGzkPc5AUf6uhyCxVFEKePH0eJnvJjgtc6A5V41m
 yVmmPqJl
 A9vXvQzjg17ORVH4Lq8Ko//OzU4vylEpJAd0sgaTSv0Q6vSjbnOgkE2fYJ/wpc2AC1UrS1OSxWR370gGEkd+8gzSh+YEXfcs9O17iV1oByS1rxkypm3UuhkQ2GhT8ilKqtAxde6ayk2uEB9V8l2M4oy8VQ5cXsSdauRXvYjYege0rLMuk9l9XjkAYNcm4hhtcA3OkemfZ432/gQAeALU3bIdhNfWLZrPvL/Xsey7XtEZ9XaLEPLI/fR4b0sgPzJBYfiQ9sRWsHblQSoU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09, 2025 at 10:24:22AM +0200, Maciej Wieczor-Retman wrote:
> On 2025-09-08 at 22:19:05 +0200, Andrey Konovalov wrote:
> >On Mon, Sep 8, 2025 at 3:09 PM Maciej Wieczor-Retman
> ><maciej.wieczor-retman@intel.com> wrote:
> >>
> >> >>I recall there were some corner cases where this code path got called in outline
> >> >>mode, didn't have a mismatch but still died due to the die() below. But I'll
> >> >>recheck and either apply what you wrote above or get add a better explanation
> >> >>to the patch message.
> >> >
> >> >Okay, so the int3_selftest_ip() is causing a problem in outline mode.
> >> >
> >> >I tried disabling kasan with kasan_disable_current() but thinking of it now it
> >> >won't work because int3 handler will still be called and die() will happen.
> >>
> >> Sorry, I meant to write that kasan_disable_current() works together with
> >> if(!kasan_report()). Because without checking kasan_report()' return
> >> value, if kasan is disabled through kasan_disable_current() it will have no
> >> effect in both inline mode, and if int3 is called in outline mode - the
> >> kasan_inline_handler will lead to die().
> >
> >So do I understand correctly, that we have no way to distinguish
> >whether the int3 was inserted by the KASAN instrumentation or natively
> >called (like in int3_selftest_ip())?
> >
> >If so, I think that we need to fix/change the compiler first so that
> >we can distinguish these cases. And only then introduce
> >kasan_inline_handler(). (Without kasan_inline_handler(), the outline
> >instrumentation would then just work, right?)
> >
> >If we can distinguish them, then we should only call
> >kasan_inline_handler() for the KASAN-inserted int3's. This is what we
> >do on arm64 (via brk and KASAN_BRK_IMM). And then int3_selftest_ip()
> >should not be affected.
> 
> Looking at it again I suppose LLVM does pass a number along metadata to the
> int3. I didn't notice because no other function checks anything in the x86 int3
> handler, compared to how it's done on arm64 with brk.
> 
> So right, thanks, after fixing it up it shouldn't affect the int3_selftest_ip().

Seriously guys, stop using int3 for this. UBSAN uses UD1, why the heck
would KASAN not do the same?

