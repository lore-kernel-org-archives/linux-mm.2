Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59DF8C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 15:17:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E87FC9000A5; Wed, 13 Aug 2025 11:17:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3881900088; Wed, 13 Aug 2025 11:17:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D00C69000A5; Wed, 13 Aug 2025 11:17:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B510C900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 11:17:10 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5C9CD1403C9
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 15:17:10 +0000 (UTC)
X-FDA: 83772087420.12.D85E7A7
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0FC2340009
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 15:17:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=WxLyCH8i
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755098228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pNSPGI3nahSLz3vSSHU/GM73uUfkJwp5wjG48WP8eNs=;
	b=v/E14PC4TXlG04ct7rohGsL+945D9ix5GuqKTWt3JEw3DClJcSdAlI9plUSXcC3L3yChQk
	VOLpjv80EV1q+M9FfVQIBhx3Ru9QXnRgY963WoHTqxJZt9yxxbBhAtQWQKvdtgxJYQhPHi
	WGnFXpW7b7nT9Z234nydzAkOaLnQwzM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755098228; a=rsa-sha256;
	cv=none;
	b=x6w/VAMt3FhcM6RxMB9UUq3wz2q0SrUqyuMKs2yt87Lfr5OyUb1Fy+7uWEH4BupZmnkrqu
	Vx0pCC7o04ZJlGxtqr+u/knlCoW3RqyNDuMFcKXrXBLlmdfn6l7/+oi20QQ2wz90CmouEU
	YR1z51ijJjXdnWP87OJKPzL4KQQ5pDk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=WxLyCH8i;
	spf=none (imf12.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=pNSPGI3nahSLz3vSSHU/GM73uUfkJwp5wjG48WP8eNs=; b=WxLyCH8iH69E9BH7UtMzH7H17H
	t6Ml0vI1fI2OOdNxOGP+5iq+poupLQ2GZTl8Qbg+GLZRMfJhbheIFXwQRw1fAo5vR3jjnVWGALbDA
	GF76KZXk/18EMG+E2DoKUem8UcWsq4kimbAVigd1E9VJbGvY6eMOx/aSv7+4PZZXOjQZExeGyi9kM
	hKX2INP+qOiw68z+tMFED9Du70a0VZMniilClGrYQN98aaHcaPJwhLCTFus3IDJnpPe0eJIJBCBdh
	hGIx2Rn6domoKnDI7gda9nml2xVHmkJ45p9qHFrGca4GFufzKdq8T/KWcgwMoXA06x8qBnyuwj/3g
	Q99O5ANA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1umDDr-00000009rE6-0f1W;
	Wed, 13 Aug 2025 15:17:03 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id C17623001D6; Wed, 13 Aug 2025 17:17:02 +0200 (CEST)
Date: Wed, 13 Aug 2025 17:17:02 +0200
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
Message-ID: <20250813151702.GO4067720@noisy.programming.kicks-ass.net>
References: <cover.1755004923.git.maciej.wieczor-retman@intel.com>
 <9030d5a35eb5a3831319881cb8cb040aad65b7b6.1755004923.git.maciej.wieczor-retman@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9030d5a35eb5a3831319881cb8cb040aad65b7b6.1755004923.git.maciej.wieczor-retman@intel.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0FC2340009
X-Stat-Signature: nkds47irnqkiqita4e5agfm9bxz4gjm7
X-HE-Tag: 1755098227-915636
X-HE-Meta: U2FsdGVkX1+VKo5OYlghXl0QbE17R1tMaRkOwO1IggWtwN6TSfXAtsL66MRf7lzW8xa85dn4lmN6OyUGLX5IFXR71sFc1bOV0O9L5zxbH7nE0r3ceBQrzlA0zmEIYO7z1z5DiovqaG+EHLDXR4eLphibU8tL4Fe5ApjS4ECX45yPtMx9187B6BDsD9HQMm5y9sY/LDNBhwR8Yaa58YOjIsZeTa5MUyoyNhRRGfZcsJZpWTv8hvU2mAsVF93m8OCxYx99vkpvPe9y1FYIuS8VP7WAlAtx5E4eFbot1qvCimLV/nOjZNmOiTM4S4z3sOeG+ILLSP/15BH9/NBXUjK0dFQ12IgYNYcX37JDwLutMrcQfXu3T01Ut0+khDVpwTpH/iXAwfoMa83ThgboxOMy3LZ/5v7q8D8iEDhqZ61J2wIr/h+NqvGQl4G42gBBgvSs4peo/YvDv6/SPv7nUkhTaJy+Tn2ilds6oLsUnGx3Cw9ds59Wv1x5d+Uexlrvqmb1nCadMsqA+pzekhOUCDN4/OxKfCYR9DYABflUcM4GZlG0LeC04cdWbKjjr5SdT7ZL2NuSNNijJReqpsXoSxSiPM3EofLq/nNsIgEg1rdha9/h/4cc1MyrdbGXolUCm1f9ijCxGjg3vsVjK9INuvJtIpR3R2tbyXsULyJQ0ybfSvyQfJhJ682MR+rTzFFkYIcQQ7Zaf2IZcqBBfGIZIHYpgKCLMUK0vEe9MhnNsY6de9+6MDd+R1/c10DOO4dHw6a130DdUPkAQUUkJDaWhrJoVkYoPKq1mamzCj+THiwI/GUvZAt1mVUK5duRBbyHC3qPw0P4enmIqVe8JRTwI7v9P/pCjEHpRcMJFp5xMPlx8u8eTk+d1fbgTqYv8mh/Pk/Hv/gZu6aYz9JsC7gEoHqBpkqxxsSmNsflGAQ6eMt2kv+p1aZCYvAFInP1WhhyEU+cQ4hI25f6KYGK2EQgEit
 5uzy867B
 UaoRilZGY+H1udUHeAuEgTPM3mWqIb9kNyo6emATrgrBK4dL6lqAT0w7/rbFh1pdOEbIG3hiMv0LkYD04XLHnC/BeW3TaRv63pmI/4U4IJDPeHoPQZgpCL9yKp3zuWRDXCfMOaymLe32eIrEoEbA1uo9J2AAF4O7+4OYX953WYIH8HgoK+Vzf39t5Tpi+CloETw2LazPV7bBQe/7EfWUEJoqb14eea59KtKxmac6emDVasus91appTtmye9G63lkVbHW5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 12, 2025 at 03:23:49PM +0200, Maciej Wieczor-Retman wrote:
> Inline KASAN on x86 does tag mismatch reports by passing the faulty
> address and metadata through the INT3 instruction - scheme that's setup
> in the LLVM's compiler code (specifically HWAddressSanitizer.cpp).
> 
> Add a kasan hook to the INT3 handling function.
> 
> Disable KASAN in an INT3 core kernel selftest function since it can raise
> a false tag mismatch report and potentially panic the kernel.
> 
> Make part of that hook - which decides whether to die or recover from a
> tag mismatch - arch independent to avoid duplicating a long comment on
> both x86 and arm64 architectures.
> 
> Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>

Can we please split this into an arm64 and x86 patch. Also, why use int3
here rather than a #UD trap, which we use for all other such cases?

