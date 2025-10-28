Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 565DFCCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 11:44:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C64C8013A; Tue, 28 Oct 2025 07:43:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 676F180131; Tue, 28 Oct 2025 07:43:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58C818013A; Tue, 28 Oct 2025 07:43:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 461BC80131
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 07:43:59 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 92D1714041E
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 11:43:58 +0000 (UTC)
X-FDA: 84047338956.27.56B34E6
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf20.hostedemail.com (Postfix) with ESMTP id 534CF1C0007
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 11:43:56 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761651836; a=rsa-sha256;
	cv=none;
	b=ninwd9bE+o6q2C7jNwifAlX16WifUFxiHSLoadJ+wzOBiTlpF0MxgObdg1SdGI87n2XpcS
	hmbs7x/wVBjbgXijfXVDsb5a79zT9dwLdc58IWIOIbJUC2ksQOR45MhRy7DSEkotPDD/oR
	y76Hi0IqmqCEcku/qmkpr8dq/CMcPjs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761651836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6RBxOpQwM9ZQILp1LIjr5FHqyEz/6xG2wfXnnp3R8PE=;
	b=aDZINsj9BWEOcbetviY8r1kxsbXAJs/1iz0lc7k2oQV9hICKFPyMjntVLanuxHDG/YMRX8
	zP0HWXIg+mOzCWcr2vE5JOmueoMw+C0fBqd5k/sNGde7wX074EFYPyE3diwiCVxxU0WDJd
	6ekhxwvM7sHKam/ouheLXA7ZMg64QVI=
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4cwpMp484kz6L4yt;
	Tue, 28 Oct 2025 19:40:22 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 3FC4C1400D3;
	Tue, 28 Oct 2025 19:43:52 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 28 Oct
 2025 11:43:50 +0000
Date: Tue, 28 Oct 2025 11:43:48 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Conor Dooley <conor@kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>,
	<linux-cxl@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	Linux-Arch <linux-arch@vger.kernel.org>, <linux-mm@kvack.org>, Dan Williams
	<dan.j.williams@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, "Peter
 Zijlstra" <peterz@infradead.org>, James Morse <james.morse@arm.com>, Will
 Deacon <will@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>,
	<linuxarm@huawei.com>, Yushan Wang <wangyushan12@huawei.com>, "Lorenzo
 Pieralisi" <lpieralisi@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Dave
 Hansen <dave.hansen@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	<x86@kernel.org>, Andy Lutomirski <luto@kernel.org>, "Dave Jiang"
	<dave.jiang@intel.com>, Krzysztof Kozlowski <krzk@kernel.org>, Alexandre
 Belloni <alexandre.belloni@bootlin.com>, Linus Walleij
	<linus.walleij@linaro.org>, Drew Fustini <fustini@kernel.org>
Subject: Re: [PATCH v4 0/6] Cache coherency management subsystem
Message-ID: <20251028114348.000006ed@huawei.com>
In-Reply-To: <fe57097b-1817-4428-9940-477c3f36cafb@app.fastmail.com>
References: <20251022113349.1711388-1-Jonathan.Cameron@huawei.com>
	<20251022122241.d2aa0d7864f67112aa7691bf@linux-foundation.org>
	<20251022-harsh-juggling-2d4778b0649e@spud>
	<20251023174026.00005b42@huawei.com>
	<fe57097b-1817-4428-9940-477c3f36cafb@app.fastmail.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.15]
X-ClientProxiedBy: lhrpeml500012.china.huawei.com (7.191.174.4) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Rspam-User: 
X-Stat-Signature: ioj3etd6sekn7gogb7bm5qrhf8ezh9gy
X-Rspamd-Queue-Id: 534CF1C0007
X-Rspamd-Server: rspam09
X-HE-Tag: 1761651836-479289
X-HE-Meta: U2FsdGVkX19v5+g9YvZ5U1Ut/66drtrNVMYRWY1yf5BUrLFaySg+RF3ig7SM6wrqglpdG9q7gyLu2joNfnvo5pr7UIfDxoiizT1L96oEjko+fCGzP9zYoqsSPFDz8UnuOYaQAp2X+yh/9/QImhvXORaJfz0XvJlBIW6Qer2xqsf3qAdiI/coY2WnvnSODugql6/apD6ZVzvf5+m23cweHaiFH3OJCql99w26QPyP51P8ZLZ2HeCJhnLJK4lkfIeexmGTr+4kmL7m4wsk8avw9qNl3nDptmQ8RBW1dF+msI2jXo0ArzVzOPJObYzdEeeCGUIcpc6jCVkL88KMndxV7hbIDEQOXDMrs22UJU6Ta8rWfwM3Q/9Ev+hCtTD3Awp3ZIgeO2pjdp52nsGI/96/T6ueoe+RLmIqCXbFjS4yz5zaVCBrEnUmD9GJaHqVk4z5c2Fo+9kgkcsVXn3NlBp/l96+s/O+KmhhGJI4dLGi4362xQYCqQ0KV76v8ijYMN0tdCOG8u8W7xsHdExkI7vJG3x9bOnd8JWne5NxT/5Pfwe5kam0PmyhZ+C9/uTnvXmh5+q65Tprl/7E4mwYr32eLHfBhglr1UoHVpkJQ9ZS5h2m2WARohq/m+gxy+9nQFOSqJIvt2xEt0tE05+fXlVhslZiHg53aqYLCOtgWAxnpEVGyiuEXlLpYc2IZkA74m4m9x/KLOiHuuCtjAIVOLEWWplcAeGLYXs9tiMpzjnzOJdO1vRAoHOxiPCIHXH315x6oYDpoMOK/TcWOTCrVlmSvnB9Nf9bO3p0iCUMf+vGEfuS2yvr8YCf/5fftag/4biyY0WHhLTw7eo9mhmypWEsgJ1Th7JND/64N8wczpBokVwaY5wdMDsaIoxZXeXUPosjB3u9mJKGrqoeCkJ0XgkiHiaIhbyeLYRxK2rEf4yBt3ftwJYCxQweFZH9/EsoxeMX8hoyaJWmtsa1wbJzxHC
 6iAUk9Hu
 nuWXTvFvuBrviwpBTcFJszWPkO6V+8Z9x1kC9nFwcCjFvTf8K0raH+PU/lQdiU7uvJpGUnsizqW4BAW4cetorLnqPwyUNXHNWVvvfxEAgnOh9FGdWDWcnfp6aeUW6bSnkoWt/GINcAiDTmvJ0gT1S+uSgdtgq3S58GN7D2cn9hsGPKBrzLkvGvRWE4iU6WQGyq65svIbFNa+7c3XVL3QM//XJw6opug9JYOZ1Rywqr4o++JreTu8YUGXNNg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 27 Oct 2025 10:44:03 +0100
"Arnd Bergmann" <arnd@arndb.de> wrote:

> On Thu, Oct 23, 2025, at 18:40, Jonathan Cameron wrote:
> > On Wed, 22 Oct 2025 21:47:21 +0100 Conor Dooley <conor@kernel.org> wrote:  
> 
> > On CXL discord, some reasonable doubts were expressed about justifying
> > this to Linus via CXL. Which is fair given tiny overlap from a 'where
> > the code is' point of view and also it seems I went too far in trying to
> > avoid people interpreting this as affecting x86 systems (see earlier
> > versions for how my badly scoped cover letter distracted from what this
> > was doing) and focus in on what was specifically being enabled rather
> > than the generic bit. Hence it mentions arm64 only right now and right
> > at the top of the cover letter.
> >
> > Given it's not Arm architecture (hence just one Kconfig line in Arm
> > specific code) I guess alternative is back to drivers/cache and Conor which
> > I see goes via SoC (so +CC SoC tree maintainers).  
> 
> I tried to understand the driver from the cover letter and the
> implementation, but I think I still have some fundamental questions
> about which parts of the system require this for coherency with
> one another.
> 
> drivers/cache/* is about keeping coherency between DMA masters
> that lack support for snooping the CPU caches on low-end SoCs.
> Does the new code fit into the same category?

Hi Arnd,

Sort of if you squint a bit.  The biggest difference is every architecture
has to do something explicit and often that's different from what it would
do for local (same host) non coherent DMA. In some cases it's a CPU
instruction (x86 - which this patch set doesn't touch) in others an MMIO
interface (all known arm64 implementations today).

The closest to your question that this comes is if we do end up using this
for the multi host non-coherent shared memory case.

Before I expand on this, note it is very doubtful this use case
of the patch set here will be realized as the performance will
be terrible unless the change of ownership is very very rare.

In that case you could conceive of it being a bit like two symmetric
DMA masters combined with CPUs. From viewpoint of each host the other one
is the DMA master that doesn't support snooping.
 
View from Host A... Host B looks like non coherent DMA
 ________                            ________
|        |                          |        |
| Host A |                          | Host B |
|  CPU   |---------- MEM -----------|  (CPU) |
| (DMA)  |                          |  DMA   | 
|________|                          |________|

View from Host B... Host A looks like non coherent DMA
 ________                            ________
|        |                          |        |
| Host A |                          | Host B |
| (CPU)  |---------- MEM -----------|  CPU   |
|  DMA   |                          | (DMA)  | 
|________|                          |________|

In my opinion, new architecture is needed to make fine grained sharing
without hardware coherency viable. Note that CXL supports fully hardware
coherent multi host shared memory which resolves that problem but doesn't
cover the hotplug aspect as the device won't flush out lines it never
knew the host cached (before it was hot plugged!)

Use case that matters is much closer to flushing because memory hotplug
occurred - something hosts presumably do, but hide in firmware when it's
physical DDR hotplug).  Arguably you could conceive of persistent memory
hotplug as being non coherent DMA done by some host at an earlier time
that is then exposed to the local host by the hotplug event.   Kind of
a stretch though.

> Or is this about flushing cacheable mappings on CXL devices
> that are mapped as MMIO into the CPU physical address space,
> which sounds like it would be out of scope for drivers/cache?

Not MMIO. The memory in question is mapped as normal RAM - just the same
as DDR DIMM or similar.

As above, the easiest thing to think of it is as is memory hotplug where
the memory may contain data (so could think of it as similar to
hotplugging possibly persistent memory).

Before the memory is there you can be served zeros (or poison) and when
the memory is plugged in you need to make sure those zeros are not in
cache.  More complex sequences of removing memory then putting other
memory back at the same PA are covered as well.

> 
> If it's the first of those two scenarios, we may want to
> generalize the existing riscv_nonstd_cache_ops structure into
> something that can be used across architectures.

There are some strong similarities, hence very similar function prototype
for wbinv().  We could generalize that infrastructure and a) make it handle
multiple (heterogeneous) flushing agents b) polling for completion c)
late arrival of those agents which is a problem for anything that can't
be made to wait by user space (not a problem for use cases I need this
for, userspace is always in the loop for policy decisions anyway).

The hard part would be that we'd have to add infrastructure to distinguish
when the operation should be called and that the level of flush will be
dependent on that.  An example is the use of the riscv ops in
arch_invalidate_pmem(). That's used for clearing poison for example.

On x86 the implementation of that is clflush_cache_range() whereas today
the implementation we are replacing here is the much heavier WBINVD
(whether we could use clflush is an open question that was discussed in
earlier versions of this patch set - not in scope here though).
On arm64 for this case today dcache_inval_poc() is enough as long as
we are dealing with a single host (as those code paths are). If this
flush did go far enough I believe a secondary issue is we would have to
jump through hoops to create a temporary VA to PA mapping to memory
that doesn't actually exist at some points in time where we flush/

On arm64 at least, the Point of Coherence is currently a single host thing
so not guaranteed to write far enough for the 'hotplug' of memory case
(and does not do so on some existing hardware as for fully coherent
single hosts this is a noop).

Also the DMA use cases of the existing riscv ops are not applicable here
at all as when DMA is going on we'd better be sure the memory remains
available and doesn't need any flushes.

Longer term I can see we might want to combine the two approaches or
(this patch set and the existing riscv specific infrastructure), but
I have little idea on how to do that with the usecases we have
visibility of today.  This stuff is all in kernel so I'm not that worried
about getting everything perfect first time.

The drivers/cache placement was mostly about finding a place where
we'd naturally see exactly the sort of overlap you've drawn attention to.

Thanks,

Jonathan

> 
>      Arnd


