Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0BA9CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 13:34:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA5CC8E000B; Wed, 12 Nov 2025 08:34:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E56D68E0003; Wed, 12 Nov 2025 08:34:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D45FB8E000B; Wed, 12 Nov 2025 08:34:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BF2468E0003
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 08:34:08 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6E2B61A0507
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 13:34:08 +0000 (UTC)
X-FDA: 84102048576.02.EDE3BA5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id AEE751C0016
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 13:34:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZrJfWier;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762954446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r3+ZctwDuZGvlb1k0GqzpRSDDJ7h/5ZJWqMNp77avuo=;
	b=WenXQs3E0yTIttyhb6KhOehRXNxmlBIoK63KncCgFr+lYxwOtZBTvDNAfKb8NgGuVAdnzu
	TuCswoJh0K1obzfO4EGzfk0RJirUKy+lhBCKJXMmbio+FbauLFZ/oWk6tL7KNewbkmVs9k
	i7l42IUScBc0XGG5GxFYk4p/TcIima4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762954446; a=rsa-sha256;
	cv=none;
	b=MdS8RMHvKMi+XPLAqpkZtKJj+Xq4CNYse9B4Lx9Yjbv093LUYEqquuSvymhYDS5tNaqH8h
	zNN+Aq66rUbhqvPPs2RghTMEwALf2MR6iBMcyVawo12KXSYr4ICp5bHKq9IabqAL3Ijtph
	Iqyvd4PMlwBOZOSRaYIKEF8Vmszh5w4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZrJfWier;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 05D1E6020F;
	Wed, 12 Nov 2025 13:34:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C41D9C16AAE;
	Wed, 12 Nov 2025 13:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762954445;
	bh=qbSj2P7cauAyPGofpRuk2eH237ghZw6hFXEaJ7Ed/gc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZrJfWierYi07WtFcEryrFiK6Au3xJI//n+EazQJsB4b0URzBvOjJ2BPBvBPoM7FvZ
	 XWPWQhLqrXXbk6Los7kqf3Hu8uafXdEsjQxORzsfBLgMdTU6sehs9FlWa9STelJO6B
	 OWz3HlWFH/uCzNh2VZL47Gng+Ch9YiD7yBzskEndLdC70aFjLKWUcBaq0XFoDHp60t
	 0wx+iCnlCp9J1RZS79PtlT4DNB84z8R8sl+GyTqFXcqT3qGXpr8ALU3f1PIB1jKeK2
	 8K/l0BTJHUIz6SWhepPCUMWA1Uk5bb1RAQCRj5RdZtH28whozTzBEJKm7YoNIweTse
	 RnTOFGNsvHEfQ==
Date: Wed, 12 Nov 2025 15:33:39 +0200
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
Subject: Re: [PATCH v5 02/22] liveupdate: luo_core: integrate with KHO
Message-ID: <aRSMsz4zy8QBbsIH@kernel.org>
References: <20251107210526.257742-1-pasha.tatashin@soleen.com>
 <20251107210526.257742-3-pasha.tatashin@soleen.com>
 <aRObz4bQzRHH5hJb@kernel.org>
 <CA+CK2bDnaLJS9GdO_7Anhwah2uQrYYk_RhQMSiRL-YB=8ZZZWQ@mail.gmail.com>
 <CA+CK2bD3hps+atqUZ2LKyuoOSRRUWpTPE+frd5g13js4EAFK8g@mail.gmail.com>
 <aRRflLTejNQXWa1Z@kernel.org>
 <CA+CK2bB8731z-EKv2K8-x5SH8rjOTTuWkfkrc4Qj6skW+Kr7-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+CK2bB8731z-EKv2K8-x5SH8rjOTTuWkfkrc4Qj6skW+Kr7-g@mail.gmail.com>
X-Stat-Signature: w7t5iz4fctgy71tje193913ah1ij3444
X-Rspam-User: 
X-Rspamd-Queue-Id: AEE751C0016
X-Rspamd-Server: rspam10
X-HE-Tag: 1762954446-339545
X-HE-Meta: U2FsdGVkX181n+BbIfe/EybKyiNMEfL2nWN+IEhfy+QNdUQtYKd78vZYJcahe5sQTGi9GVr9D4M+VQk6Ax0ORJwUBrEoL85B6HUroDB6zLs3KF6msF4Z1lOxyyl9bx+E9D5EKd8SAReMx7vNkTsQqe+rEBx6xx0P8VpywEyt+bosKx0Fe5XyuYNzPrOW01qSP4UuGef2Gj42heUXCeNYzmPi5fxcs43JVxQvCTfD3e1mhb36FzB+YRqhtHsMAZ5kvkI0fCovgJIPoQvu3Qd+C94+dgT2eh7Ho1J6hJ7+s+T/v9LI3J/q1op+5xHbq4zpj2wxZaHT699AhQl0g13iXo/tMmmTAEh/MM3VjHppKcuinoGGpQMxlZ974qDlyYrpKZInGMrJlploRo6UrzInH6p/KROwifq4tSpzK1vFq32rRwAMnjZHxJiUNM1x7kPREPl8u6BFNEtH9/NH3pyCR2jl4RdwgCHyqqInDxrqmzpKPtbAhOAYK5PIld0eqqZzqQUFkFVkk0ybZX3TSWJRY9vH0UDuwgzmaKhbai6JF2xAxw4iyuMACuhrzgda2jIWNI/NECKLMrauEU+Wpk1urhj0BM6Xvh5anuJRH5p0qq1yWWs7kSkOEWafnqBES+MrT2dMWipx4Su7XeK2NHIAPOCnpBLpTBAGPhmzIz31jWH6wJisnEV+5R4RIP7CYxx7cQXW7PA8pGr1bq7RA/nsnC0wAKb2g9tcy862kP7SCTXycBVvBWRmnPp93I35WXai7/SvK9XClJgjw65Xr+kAPsBYm1Di6Eo+D6PmmC7pQT0rRuvkopVMKRaqKkPf74Cr6k6PPOakSIkREOGtwW3w4muTruQgTV2/OlWYK0atbvzhCQm8/G9fp2CWwXPudPTrM+h+rrblJgbcKuiXswTGqjOqSMjASv7PXTtsWRqaHGIIwSC5eL4wIJfbymRT2+bY4JMaL8Oo/ik+jYL/EX5
 zE0P3IUl
 GFYAFdwAJwiXTWmmVH38kwOub+28JDgFDCMjbnrZb9Zjr1PzzHKD7S7lINIWKEju1ElygqE+QAo0TQ4THNZQNyHg6xQ48vJt1sKa/nVdFH0EE1/URP2QfQ36XIfzi2LI1z80HmaaqT4wo3C/PpNkzNKAlI/quGnE+dKN4vc2fpXW5vXatUdWilHrtbQukBONlLkk14/wI0M1Z2aseDWwQ+BaCbjRtHgtjlz0Q6PfKks0beiq5zH1sNA9ej6j2lhJH+670Op6pLzeO1lvylaaq7Gd6SyONfNGHrPvlHreMohQkHVTrodW5wWAC+hGFheM4it1PTxcGr8wKaqsP3qx1II0MXNm4Se02p51fxl9ZYJv0KieoRmnBh2G955xFwVv46aAdMaNpIDh9Zi8TzXI7PPw5y4qGptueIm3wij8LMhQMiaPipfw8ztoxag==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 12, 2025 at 07:46:23AM -0500, Pasha Tatashin wrote:
> On Wed, Nov 12, 2025 at 5:21 AM Mike Rapoport <rppt@kernel.org> wrote:
> >
> > On Tue, Nov 11, 2025 at 03:42:24PM -0500, Pasha Tatashin wrote:
> > > On Tue, Nov 11, 2025 at 3:39 PM Pasha Tatashin
> > > <pasha.tatashin@soleen.com> wrote:
> > > >
> > > > > >       kho_memory_init();
> > > > > >
> > > > > > +     /* Live Update should follow right after KHO is initialized */
> > > > > > +     liveupdate_init();
> > > > > > +
> > > > >
> > > > > Why do you think it should be immediately after kho_memory_init()?
> > > > > Any reason this can't be called from start_kernel() or even later as an
> > > > > early_initcall() or core_initall()?
> > > >
> > > > Unfortunately, no, even here it is too late, and we might need to find
> > > > a way to move the kho_init/liveupdate_init earlier. We must be able to
> > > > preserve HugeTLB pages, and those are reserved earlier in boot.
> > >
> > > Just to clarify: liveupdate_init() is needed to start using:
> > > liveupdate_flb_incoming_* API, and FLB data is needed during HugeTLB
> > > reservation.
> >
> > Since flb is "file-lifecycle-bound", it implies *file*. Early memory
> > reservations in hugetlb are not bound to files, they end up in file objects
> > way later.
> 
> FLB global objects act similarly to subsystem-wide data, except their
> data has a clear creation and destruction time tied to preserved
> files. When the first file of a particular type is added to LUO, this
> global data is created; when the last file of that type is removed
> (unpreserved or finished), this global data is destroyed, this is why
> its life is bound to file lifecycle. Crucially, this global data is
> accessible at any time while LUO owns the associated files spanning
> the early boot update boundary.

But there are no files at mm_core_init(). I'm really confused here.
 
> > So I think for now we can move liveupdate_init() later in boot and we will
> > solve the problem of hugetlb reservations when we add support for hugetlb.
> 
> HugeTLB reserves memory early in boot. If we already have preserved
> HugeTLB pages via LUO/KHO, we must ensure they are counted against the
> boot-time reservation. For example, if hugetlb_cma_reserve() needs to
> reserve ten 1G pages, but LUO has already preserved seven, we only
> need to reserve three new pages and the rest are going to be restored
> with the files.
> 
> Since this count is contained in the FLB global object, that data
> needs to be available during the early reservation phase. (Pratyush is
> working on HugeTLB preservation and can explain further).

Not sure I really follow the design here, but in my understanding the gist
here is that hugetlb reservations need to be aware of the preserved state.
If that's the case, we definitely can move liveupdate_init() to an initcall
and revisit this when hugetlb support for luo comes along.
 
> Pasha
> 

-- 
Sincerely yours,
Mike.

