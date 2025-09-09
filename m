Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B017CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 08:40:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 659F78E0014; Tue,  9 Sep 2025 04:40:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 631788E0001; Tue,  9 Sep 2025 04:40:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56E648E0014; Tue,  9 Sep 2025 04:40:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 46AEE8E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 04:40:45 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1F33A1403F7
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 08:40:45 +0000 (UTC)
X-FDA: 83869066050.13.2C55EF2
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4C179C000A
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 08:40:43 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=MBHVmkYE
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757407243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EoUcqt6OXqlU+JdoRus3vWmyIypwXpaqFZjRiXTD7KI=;
	b=nMCK/LY2xD5X2zuhfjvTvtlN73BKLYKM42o4s35l7J0Jktm6Ix/mGVJt5knxRkWrBQjCyd
	umZHMqlw9DtNcbG8+mAsqtZp09QR/nAkh57vrjovcqv8/nyPVUb9JObmwiYKzs62/IqaOr
	h6UpaRT6J57Aib+mBYhE/or/Wj13tmw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=MBHVmkYE;
	spf=none (imf28.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757407243; a=rsa-sha256;
	cv=none;
	b=aYq8FNm8rJYX81NBuXKLNz11hrKC8GjRZcb3qRo5f24ZvyU30sBVBng5nKVP3eh6Pz258b
	nNPg8InXdwMAr3THsqJ/e/Ik2PCjpv28IG8Xe59gcde3eozoxqIlN9ITk3bkeKffB7mfIs
	BD0g76hOsvCObfTFsEnQPsUnVHwpfYc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=EoUcqt6OXqlU+JdoRus3vWmyIypwXpaqFZjRiXTD7KI=; b=MBHVmkYEd0s33w4HDnRrScBGWK
	7ka0nv6T/lMA7WcFajL8j5eR/F1lEPT3HHe0/qQaXKg6cu+eOZY3VMYML9R7GsnwMKwjavuiK3rm3
	w9eA2cXuoey9UoNeDuRcsl67SFXaLXiPCH/9QEkPoLgLkPhbh/xGqtRKb0GYPPmIv0K1QC/4mg7QI
	wK/jTHDDRQm19IVoiiqhU8DjydiZypghHgXG/fm8pn2NuTS1br9FO8BFOCYpMaPkv9eYcjIbfpQD0
	LeAOVtWlB1+JDmWlHcFU1zdERFUa2j/r3IMUho/bpoKJ5GRAHGstaCri0szq+tx3hy+wDFGNr+sFY
	DW942Gaw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uvttu-00000005G3f-3VLf;
	Tue, 09 Sep 2025 08:40:31 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id D4F4F300579; Tue, 09 Sep 2025 10:40:29 +0200 (CEST)
Date: Tue, 9 Sep 2025 10:40:29 +0200
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
Message-ID: <20250909084029.GI4067720@noisy.programming.kicks-ass.net>
References: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
 <36c0e5e9d875addc42a73168b8090144c327ec9f.1756151769.git.maciej.wieczor-retman@intel.com>
 <CA+fCnZcMV0BOJyvx2nciCK2jvht-Hx0HnFtRzcc=zu+pQSOdVw@mail.gmail.com>
 <couuy2aawztipvnlmaloadkbceewcekur5qbtzktr7ovneduvf@l47rxycy65aa>
 <hw7xa2ooqeyjo5ypc5jluuyjlgyzimxtylj5sh6igyffsxtyaf@qajqp37h6v2n>
 <epbqhjyfdt3daudp2wx54jsw6d7jf6ifbr3yknlfuqptz7b4uq@73n5k6b2jrrl>
 <CA+fCnZdJckDC4AKYxLS1MLBXir4wWqNddrD0o+mY4MXt0CYhcQ@mail.gmail.com>
 <ra5s3u5ha6mveijzwkoe2437ged5k5kacs5nqvkf4o7c2lcfzd@fishogqlatjb>
 <20250909083425.GH4067720@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250909083425.GH4067720@noisy.programming.kicks-ass.net>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4C179C000A
X-Stat-Signature: 9rqu4kg66n9qp6ghm5zfuro3bkjg3btd
X-HE-Tag: 1757407243-454614
X-HE-Meta: U2FsdGVkX1/6hiJm+fabC9+B61ZNTskETcR92710Jld5TLt0X8z4J2pjGpFgZ8rA5JEksY+eHADVMVlmNY3FlVwg7z+4vvs0KU+L9bUs3EBc4b+eyYf5vdVJFgnT7Ju6UEe03r3KSWd5xt9m95Y1t55nvf7uGbd3JjHOttc1d9iBC3QWlv1IgAZEfgPSmmHjU3v9dh+zph72WMDRnjT28KitouSpPYj2IGX+is8Sem1BiPdywYNlsGoFYVpvb3Gsnc301PU3VGHDw/7NNHnTp9GuRZe/mX0TdkJileH4BUDbDHuus7zJLusAnDUrT1TNr26cYYHGBokI8/OCv9MOMZfUH4XkT/xDKd5UdQrnjktBSEKnZSZE0R4E3upqEFgNkr8nprpaETacm0j+2GTSV2pwQ8GE4YnrGdy8UdA46U/uC9NMgYgeC10t3bBggLquz0TvMf+5zRe+nANyZbHqdLcf1O9LBz2X9Hj2+50qibmrvqlVJOgsNrCFVxtD3IWGh+gGNJogtX0a6W7MCaxpvNKi2QCwaaMgTaQWpV2hKUWUBwqQGPR+2ARvIBHWxuJECnHs+qmrKIsGLFYJrPJrb+8ee5C86LQeEw2qgKlhrhjAvb4uXVZpN7n6BfB4OLQ1eI5SVDn1EEcu0yI6Cel1McIfOse/kaxZ8j+cENdZx8rfcQ9xRMcktB4LfwcYSQhgqE7Z5oRyz3eecKZrlZmxqJYeDRAEGCIeqW121AJk0RSjbw+pe3rkEIOzji+EFJdhczigZSz+HixbSsMKPa5lcXc6kqdXGlXpWKZW1SRmA17xBk1XH1R7/MPLl7PTLJqnsTmGGjyltdiAFut5MrxN95BlkLxlw+Tjhx7LZZM0KSkivEEoyF3L4LkO3EE637bEoIa4Dg8zWIKotTfpL4BKiSX0Urm2syIgTNyKD1XnzldbFcokf2s7Gx/KXGyCpNlN8GkWw3AEw0ZOrkNhxyN
 wxg3AkII
 KVBZmXkL696mEgs8lp9Jos3/YQ2XEfY+Om/YgtW0wwtFgY03p4uKewUGe1ishfp6me1euhcvehAqALPt/CgwVIqtogdO9mNMdlGTL07Jt+lv6Wx1n1pkOQJFqjfcXgdt5gWzm8CxxAbYemYikqfjAj9lrsDScoRfGuWHni+9TZAx5Y4iqaEHTG/PbHBtj3ekeGTuqXJOZeDDXB+H7px2VM88IexIV9F7oj+7urznrOZ4CxeaJFiBqpSBryDerQOMGNuyCyR26gMWSBE0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09, 2025 at 10:34:25AM +0200, Peter Zijlstra wrote:
> On Tue, Sep 09, 2025 at 10:24:22AM +0200, Maciej Wieczor-Retman wrote:
> > On 2025-09-08 at 22:19:05 +0200, Andrey Konovalov wrote:
> > >On Mon, Sep 8, 2025 at 3:09 PM Maciej Wieczor-Retman
> > ><maciej.wieczor-retman@intel.com> wrote:
> > >>
> > >> >>I recall there were some corner cases where this code path got called in outline
> > >> >>mode, didn't have a mismatch but still died due to the die() below. But I'll
> > >> >>recheck and either apply what you wrote above or get add a better explanation
> > >> >>to the patch message.
> > >> >
> > >> >Okay, so the int3_selftest_ip() is causing a problem in outline mode.
> > >> >
> > >> >I tried disabling kasan with kasan_disable_current() but thinking of it now it
> > >> >won't work because int3 handler will still be called and die() will happen.
> > >>
> > >> Sorry, I meant to write that kasan_disable_current() works together with
> > >> if(!kasan_report()). Because without checking kasan_report()' return
> > >> value, if kasan is disabled through kasan_disable_current() it will have no
> > >> effect in both inline mode, and if int3 is called in outline mode - the
> > >> kasan_inline_handler will lead to die().
> > >
> > >So do I understand correctly, that we have no way to distinguish
> > >whether the int3 was inserted by the KASAN instrumentation or natively
> > >called (like in int3_selftest_ip())?
> > >
> > >If so, I think that we need to fix/change the compiler first so that
> > >we can distinguish these cases. And only then introduce
> > >kasan_inline_handler(). (Without kasan_inline_handler(), the outline
> > >instrumentation would then just work, right?)
> > >
> > >If we can distinguish them, then we should only call
> > >kasan_inline_handler() for the KASAN-inserted int3's. This is what we
> > >do on arm64 (via brk and KASAN_BRK_IMM). And then int3_selftest_ip()
> > >should not be affected.
> > 
> > Looking at it again I suppose LLVM does pass a number along metadata to the
> > int3. I didn't notice because no other function checks anything in the x86 int3
> > handler, compared to how it's done on arm64 with brk.
> > 
> > So right, thanks, after fixing it up it shouldn't affect the int3_selftest_ip().
> 
> Seriously guys, stop using int3 for this. UBSAN uses UD1, why the heck
> would KASAN not do the same?

Specifically, look at arch/x86/kernel/traps.h:decode_bug(), UBSan uses
UD1 /0, I would suggest KASAN to use UD1 /1.

