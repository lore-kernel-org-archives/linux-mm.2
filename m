Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF7B2CA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 17:45:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DBAE8E0203; Fri, 15 Aug 2025 13:45:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B3AD8E0001; Fri, 15 Aug 2025 13:45:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C99C8E0203; Fri, 15 Aug 2025 13:45:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5C3628E0001
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 13:45:03 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 19542116F10
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 17:45:03 +0000 (UTC)
X-FDA: 83779717686.26.E51D0E1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 53F43180007
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 17:45:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of cmarinas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755279901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2aFcE/n+jYq3wIvYWDgDgimCNZtY5B4eYaY7TUpTtR0=;
	b=HGkpUbkZfucvY5FItF+6Q2LwIUedwXalm8SOvvBeM2aYDYL+Snx/LPBf4Hki4ILJ73TyHp
	5ce+Osulc4e4gagsyArgokr1jR1DPJKqFGQmonUNKttf7ogPtUPOSByCG6Eumv8uPbmYYx
	xbBOuKbO6w+bqrfzFDYxmKE+7fk1bkE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of cmarinas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755279901; a=rsa-sha256;
	cv=none;
	b=ZFOZaDa5Ssle9v+o0yWaR0iDV9cKYnC16Trt22cF/ow15ydaktQIM44dHUrNtEzNN8NPF8
	fM4/iR/Gtg0tEy4eTmp/FVgkLhKxnhrVk+KsXX8zPUNKje7GHYgJPEwsTG+lb06XZellk7
	5bR5v7dECR4YvB+j+2Wgxm1INrZZfhI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3A08143EDA;
	Fri, 15 Aug 2025 17:45:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A235BC4CEF1;
	Fri, 15 Aug 2025 17:44:55 +0000 (UTC)
Date: Fri, 15 Aug 2025 18:44:53 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: ryabinin.a.a@gmail.com, glider@google.com, andreyknvl@gmail.com,
	dvyukov@google.com, vincenzo.frascino@arm.com, corbet@lwn.net,
	will@kernel.org, akpm@linux-foundation.org,
	scott@os.amperecomputing.com, jhubbard@nvidia.com,
	pankaj.gupta@amd.com, leitao@debian.org, kaleshsingh@google.com,
	maz@kernel.org, broonie@kernel.org, oliver.upton@linux.dev,
	james.morse@arm.com, ardb@kernel.org,
	hardevsinh.palaniya@siliconsignals.io, david@redhat.com,
	yang@os.amperecomputing.com, kasan-dev@googlegroups.com,
	workflows@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 1/2] kasan/hw-tags: introduce kasan.store_only option
Message-ID: <aJ9yFZ0aobVUPDip@arm.com>
References: <20250813175335.3980268-1-yeoreum.yun@arm.com>
 <20250813175335.3980268-2-yeoreum.yun@arm.com>
 <aJ8WTyRJVznC9v4K@arm.com>
 <aJ87cZC3Cy3JJplT@e129823.arm.com>
 <aJ9OA/cHk1iFUPyH@e129823.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aJ9OA/cHk1iFUPyH@e129823.arm.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 53F43180007
X-Stat-Signature: uqgktruxstioedjqujn35i1kgonhtxpc
X-Rspam-User: 
X-HE-Tag: 1755279901-476262
X-HE-Meta: U2FsdGVkX1+8rxM1VjArIHagSgeMKd40Bdy5Md59L8LL9tRdMV9CM4i6B2fG196qRg5Amhp0FXzIz9atAyffjWghRdlPEN4FNteaCLqP33QZ75hs1Fj5syzD8oTSOaNR81/wZgIG5cHfQ1DMbRIZdlmQnfzyaYZQXdTbDRHXKUUoKHopb3aJQMjRql6kWGEX+ISxGTPE0Ni+4GfSCin98qoUT1PnsVAv5e9rIJPtGDzwL4ULNyT7nAEveid/UGlutCnrnkakIAtBBEW3ULEYYscrLPlhlO/qXkUqQcm4QAdN+/eCcTcwPzhmjxvdmz7XBer6MpX1JbIm0InKnDKG85cvq+iIIMjSGahmiAcapUfjHebootskIhmHtAXZM5ESfm0idE9rzocV/an1sRWXR2YDI7Q+z5MDcPkxtfN8KqISprZvH4szjGq41LmiOAF8hemRCHyh/X30PKxWbjNDFM3oiGOt9e0ylKq2Q7EAdUNaPePw2qc69DUxGCdHHdOQhZ36x4pmd4N5flgO7dmfU5A98a/fbWFVzjrzW/U+GpG/CayKXf5KTnvcz/4NsAw8l6dJ9cLp3GOKGr343c7ipI5JtXUWFSuftO9fediPfq0t2Qr942zTibTj5fvV/95tAEJw+OoMqySoG7smC1RtFQZFHmui58/QXnORmlyM+xB3fmBeKh0j6CWdJA1gm0AQHr9v6kYo+MfR5anSzd9HediugzYcyWYXRMN2fzulfPKfNSO6p/V+Rsx+Mlro2i7J0HJQonKQMkN9HnTUUrlNDNlaUPSWidxE/VS4a/Y/KfpKNRY3FxM8VuigwR7koaXFpudZkP7HS31o+tFT82l2reHqAd/YrO2KOsqHAtjn4DDwbAwbVdtMvqzLnpAYxJTZOF1Wpl5r1634tAuMO2wTzgO+2psN3nQkudDiw4IPIuDMKpPqrAA180CXbeXdQiz6mt9aUZoqJArPsLWWXDR
 uDgLoNrv
 6LitJIZjRJOisrSDrjh41X0HGBeHAQ6xDa4CLRFfW20gWOGwjt0Lj9ZoDbdPu7PRqkKVLveVDYaNmyPKp7Wc9j8N2YYCLFjPiGxwv93beYfZvVldTBaE40oErG5TP8i9GSufJDO/n+0RNiSErovHGJ2AY4U+OXOAOZ/krNf/wLSfBzIUMuAjSk7Fju1H8dM1lL1IOqtzLXunfRyTzA8w3UddrcbewBhZC4+5ZzkzWwqqdquX8hgIK+BqjhmKJS9v60bZ6ZGeR5z457g62HjRpSbQIA1OaYf+MXwyYnG6W6GrAPHo50b3YivK+7JZvM67JhZb/HJZr/Gt3qd18+hHIVS1JYo7udfTYg3wLZYFkbwfh5mqBv8i8r8V1gqDtIXPDwEyP/uFIgIfJz0b2C0zx7yA5fND5RNhMG2ec6Jxd/9uLVsi2QqHHpPSlVAutGGF+vLmhJ+5UOszvxdg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 15, 2025 at 04:10:59PM +0100, Yeoreum Yun wrote:
> > > Like we do in mte_enable_kernel_asymm(), if the feature is not available
> > > just fall back to checking both reads and writes in the chosen
> > > async/sync/asymm way. You can add some pr_info() to inform the user of
> > > the chosen kasan mode. It's really mostly an performance choice.
> >
> > But MTE_STORE_ONLY is defined as a SYSTEM_FEATURE.
> > This means that when it is called from kasan_init_hw_tags_cpu(),
> > the store_only mode is never set in system_capability,
> > so it cannot be checked using cpus_have_cap().
> >
> > Although the MTE_STORE_ONLY capability is verified by
> > directly reading the ID register (seems ugly),
> > my concern is the potential for an inconsistent state across CPUs.
> >
> > For example, in the case of ASYMM, which is a BOOT_CPU_FEATURE,
> > all CPUs operate in the same mode —
> > if ASYMM is not supported, either
> > all CPUs run in synchronous mode, or all run in asymmetric mode.
> >
> > However, for MTE_STORE_ONLY, CPUs that support the feature will run in store-only mode,
> > while those that do not will run with full checking for all operations.
> >
> > If we want to enable MTE_STORE_ONLY in kasan_init_hw_tags_cpu(),
> > I believe it should be reclassified as a BOOT_CPU_FEATURE.x
> > Otherwise, the cpu_enable_mte_store_only() function should still be called
> > as the enable callback for the MTE_STORE_ONLY feature.
> > In that case, kasan_enable_store_only() should be invoked (remove late init),
> > and if it returns an error, stop_machine() should be called to disable
> > the STORE_ONLY feature on all other CPUs
> > if any CPU is found to lack support for MTE_STORE_ONLY.
> >
> > Am I missing something?

Good point.

> So, IMHO like the ASYMM feature, it would be good to change
> MTE_STORE_ONLY as BOOT_CPU_FEATURE.
> That would makes everything as easiler and clear.

Yeah, let's do this. If people mix different features, we'll revisit at
that time. The asymmetric tag checking is also a boot CPU feature.

-- 
Catalin

