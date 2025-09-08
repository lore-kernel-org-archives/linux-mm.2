Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4027ACA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 15:41:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CCA68E001E; Mon,  8 Sep 2025 11:41:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97D008E0001; Mon,  8 Sep 2025 11:41:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86BC68E001E; Mon,  8 Sep 2025 11:41:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D9498E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 11:41:04 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2B3BE1A01DB
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:41:04 +0000 (UTC)
X-FDA: 83866496448.03.EBB1A56
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf07.hostedemail.com (Postfix) with ESMTP id E42564000B
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:41:01 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=GBi0aSjX
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757346062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i/NTHz2QW7PrsPI9dqlnUBz3BBd0hMA6KRgZuxingf0=;
	b=T8JGMtoUlYiWyq2ejkr9lBrFxETNlza3md7dKPyRWzKURO07hmJE0TIC96EMCcmBWiFpdO
	gZC7ztUn/9RQJX8Nil7twjDOS0m82bfTL2lxG8ibtY/ttho6GTA/6ZYDC/eIYE7GEscJMQ
	RqmzfYWgi+Z32rLD/LLXW+xCSDi6Hg4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=GBi0aSjX;
	spf=none (imf07.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757346062; a=rsa-sha256;
	cv=none;
	b=6n5TmU3X+77G0rPRro4ezzePtgbtitn5EifvABGAqv0r9djA5Z2oNvTjOry6S+CujPikfd
	x+53w2tNvQ4jqlpMHKlp/7bUuduTncrvR9B5N3yNf0znyo0dyB5vlcYRN+ZozAvFJ2qosB
	W1/aWv7ziOZp33RFBppURy4/beuW66o=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=i/NTHz2QW7PrsPI9dqlnUBz3BBd0hMA6KRgZuxingf0=; b=GBi0aSjXvmeOh74/NWSi3Netvt
	umXLRbKELo8BXdYxPT9vJ2FKLymdmCKs9+em8KbrcqX5x00auk1qmfwCy56dH7bfo+4jsjIbkXiNF
	Py8LhDHqpag7Y3M0CkWiEKvdMIcgJ5JAp5LybORafLtsFTB5aXzU+ehZDwT0JwzbDJVRGHTX2c2Zj
	UYIaPgOuNqdZRD4w4j4SgdGitxRIMxyjAv/mhet+Oc06/B0dKLFB3Ah9dtlIlwAW3lFr+MQiYUx0I
	FkKCVk8NQSLmu0KmpPeagx0WYy54sRY9J1MQNXqs8UmccEueofDmvgnKJ2Ycx8lDiQBosX0/IswBx
	uzwXl7dw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uvdzB-000000055Nt-1QWl;
	Mon, 08 Sep 2025 15:40:53 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id D2D5E300230; Mon, 08 Sep 2025 17:40:52 +0200 (CEST)
Date: Mon, 8 Sep 2025 17:40:52 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Cc: nathan@kernel.org, arnd@arndb.de, broonie@kernel.org,
	Liam.Howlett@oracle.com, urezki@gmail.com, will@kernel.org,
	kaleshsingh@google.com, rppt@kernel.org, leitao@debian.org,
	coxu@redhat.com, surenb@google.com, akpm@linux-foundation.org,
	luto@kernel.org, jpoimboe@kernel.org, changyuanl@google.com,
	hpa@zytor.com, dvyukov@google.com, kas@kernel.org, corbet@lwn.net,
	vincenzo.frascino@arm.com, smostafa@google.com,
	nick.desaulniers+lkml@gmail.com, morbo@google.com,
	andreyknvl@gmail.com, alexander.shishkin@linux.intel.com,
	thiago.bauermann@linaro.org, catalin.marinas@arm.com,
	ryabinin.a.a@gmail.com, jan.kiszka@siemens.com, jbohac@suse.cz,
	dan.j.williams@intel.com, joel.granados@kernel.org,
	baohua@kernel.org, kevin.brodsky@arm.com, nicolas.schier@linux.dev,
	pcc@google.com, andriy.shevchenko@linux.intel.com,
	wei.liu@kernel.org, bp@alien8.de, ada.coupriediaz@arm.com,
	xin@zytor.com, pankaj.gupta@amd.com, vbabka@suse.cz,
	glider@google.com, jgross@suse.com, kees@kernel.org,
	jhubbard@nvidia.com, joey.gouly@arm.com, ardb@kernel.org,
	thuth@redhat.com, pasha.tatashin@soleen.com,
	kristina.martsenko@arm.com, bigeasy@linutronix.de,
	lorenzo.stoakes@oracle.com, jason.andryuk@amd.com, david@redhat.com,
	graf@amazon.com, wangkefeng.wang@huawei.com, ziy@nvidia.com,
	mark.rutland@arm.com, dave.hansen@linux.intel.com,
	samuel.holland@sifive.com, kbingham@kernel.org,
	trintaeoitogc@gmail.com, scott@os.amperecomputing.com,
	justinstitt@google.com, kuan-ying.lee@canonical.com, maz@kernel.org,
	tglx@linutronix.de, samitolvanen@google.com, mhocko@suse.com,
	nunodasneves@linux.microsoft.com, brgerst@gmail.com,
	willy@infradead.org, ubizjak@gmail.com, mingo@redhat.com,
	sohil.mehta@intel.com, linux-mm@kvack.org,
	linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	x86@kernel.org, llvm@lists.linux.dev, kasan-dev@googlegroups.com,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 13/18] kasan: arm64: x86: Handle int3 for inline KASAN
 reports
Message-ID: <20250908154052.GG4067720@noisy.programming.kicks-ass.net>
References: <cover.1755004923.git.maciej.wieczor-retman@intel.com>
 <9030d5a35eb5a3831319881cb8cb040aad65b7b6.1755004923.git.maciej.wieczor-retman@intel.com>
 <20250813151702.GO4067720@noisy.programming.kicks-ass.net>
 <nuzda7g3l2e4qeqdh6m4bmhlux6ywnrrh4ktivldljm2od7vou@z4wtuggklxei>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <nuzda7g3l2e4qeqdh6m4bmhlux6ywnrrh4ktivldljm2od7vou@z4wtuggklxei>
X-Rspamd-Queue-Id: E42564000B
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: xsua6gtabdcokqi3qby54nwfx51qi67b
X-HE-Tag: 1757346061-551189
X-HE-Meta: U2FsdGVkX1+WmZ0CzHro2RIeetg+eRGZxZTwMOWmm0Ak3LrHQTWI7j32VDz5tbEya2SM12ITv7VhgfkCXoVPi2Yf47so6Oq9CUMNG3c+8zUq00bLhgMLxMBUSD2qbDMOwcjqKj7q75uudN85S6vloYdlxN7DZ0tbklxGZC9CEKT4EoE2Z6UTefaeYUSnY3+2sqKxTrMp9WWydaG0ejEG7FikaoQDudnbWo3sE6mK/u/8SiGVhqB5iOs/s4Gl5fADe+CLy3/fIl2+cbipUm/EDq62qJ8WsNX6eMNB/55ZZBB0D7g9LGQXZ7r/DbkKsyAfsl3NK06z8i64bpf63T8qr8d8a7Pk/sH4puk1q0hU/E3Qnfzh15QJDIZrjTqKxX6CirfsXUVqD1cX0CX9E/fW3XYbayWw659U8wteTadkiBbQYSviLJysjHX9HW+n9Iqh1o3s773EGOJTQhhmvbPe+j7U3qlosAaOu9Y+tpJwtlVKisoXj+P9Co38fWsVwe3dDqDlEQqJkSFGcr4pEkHfILFlTP28T++dCyGubQC8b1jHf2F4YBz53ULpWI2zlHmHQzRKxzVoPRWbTh/IAiD5lmyoq9MUo/ewQwPohcZGmqjNBaiT6mJlg7braSXQID7e57q8tOhUuEGkFukCr+IVLYRvIyXrFfAnj2/tsMv8pp6ZAY3UjgFB7mx5FkLXQu6yzzIv6CZA5AIQePsBUOXAQfn60RynTdwfK2VZTGaJ0JLQnbmCyHbPK3LR+J4NEYPsqOIm7vJ/ejkBHWeTKVAIitlDJBoQ+A0bNPDhtAo/E8sqHY6RZIaO3C6oomEFYWhEsUrhJ0Wo7ShQ5YKR/ZbagBd3ekCUJEEPflccnFZ7XQYblHurjlGQUv5PSLva+vN2uWMuAa54VrAGsJal5p+Ei9cUof8aRHGMRxT2jLijpsd1QayTYLfh7QdJq/BqeCBQ9P8kVPyse4b4fzfjPDl
 sRWRQAfJ
 8p8Rmdc/ZynmAMak6PyB8z7QXfBi7umMyBLDZq206ZIr2WaVyCBNJ2zvygMrUl+UZIlh2G7BfazaltufrbSWs+8v+5VDWSqWprJOFR3CCJOSxxD8wt+hafV7SkCvR5+jClSXsFIaui+IqgF4IUBgC3D3Yn62CuVIfO7vss+hzRfJ1GlwIf0mXApb0To3RobxegbDj7v2KIeXmvbZlDWgJiG3rjXTKYdI9uKLozIOyIS2Kn/M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 18, 2025 at 08:26:11AM +0200, Maciej Wieczor-Retman wrote:
> On 2025-08-13 at 17:17:02 +0200, Peter Zijlstra wrote:
> >On Tue, Aug 12, 2025 at 03:23:49PM +0200, Maciej Wieczor-Retman wrote:
> >> Inline KASAN on x86 does tag mismatch reports by passing the faulty
> >> address and metadata through the INT3 instruction - scheme that's setup
> >> in the LLVM's compiler code (specifically HWAddressSanitizer.cpp).
> >> 
> >> Add a kasan hook to the INT3 handling function.
> >> 
> >> Disable KASAN in an INT3 core kernel selftest function since it can raise
> >> a false tag mismatch report and potentially panic the kernel.
> >> 
> >> Make part of that hook - which decides whether to die or recover from a
> >> tag mismatch - arch independent to avoid duplicating a long comment on
> >> both x86 and arm64 architectures.
> >> 
> >> Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
> >
> >Can we please split this into an arm64 and x86 patch. Also, why use int3
> >here rather than a #UD trap, which we use for all other such cases?
> 
> Sure, two patches seem okay. I'll first add all the new functions and modify the
> x86 code, then add the arm64 patch which will replace its die() + comment with
> kasan_inline_recover().
> 
> About INT3 I'm not sure, it's just how it's written in the LLVM code. I didn't
> see any justification why it's not #UD. My guess is SMD describes INT3 as an
> interrupt for debugger purposes while #UD is described as "for software
> testing". So from the documentation point INT3 seems to have a stronger case.
> 
> Does INT3 interfere with something? Or is #UD better just because of
> consistency?

INT3 from kernel space is already really tricky, since it is used for
self-modifying code.

I suppose we *can* do this, but #UD is already set up to effectively
forward to WARN and friends, and has UBSAN integration. Its just really
weird to have KASAN do something else again.

