Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CCA0E9A75F
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 10:28:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEC916B008A; Tue, 24 Mar 2026 06:28:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9CE66B0092; Tue, 24 Mar 2026 06:28:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB3236B0095; Tue, 24 Mar 2026 06:28:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9A6856B008A
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 06:28:18 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 357E0140BCD
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 10:28:18 +0000 (UTC)
X-FDA: 84580581876.19.C78C6B3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 77A8B1A000A
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 10:28:16 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TwUPEMQI;
	spf=pass (imf19.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774348096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hqAmRTdXVRfS+U7m0yjiwlQtsaYIm6uefqtyvL7n9sA=;
	b=spCvUsblUAZoXTXKLLa7oXEbx2o1fYRrScoV97w/7JWTHo3k5fylATjiCThkIB88Upk9Wn
	aXMh2UR7/tQxlCx2rgXeIplU9VWloPRA9qkgKgtVkUNIVEJETqbhLog85x7r4hhq/U80Pf
	CaIPgRktwWYundTwR/ahkGvGd1KzxpM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TwUPEMQI;
	spf=pass (imf19.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774348096; a=rsa-sha256;
	cv=none;
	b=Vw2IVJZOxmvXvMZDSmogIQV4ItEy8Qxqekq8zJ9YsDJegqOOVu0eLAPeRZd9fMfse+ruHs
	TpA2+5CSOenQscu4MzIf+oxtyW9qxfUUEqw1XFvqb1Zw42/f+Z3XGJBwAAktNPumf+OV8q
	uDSqGa1/xEs0Dt9qi3AEdo0o2kXpMkE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7E92640856;
	Tue, 24 Mar 2026 10:28:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8343FC19424;
	Tue, 24 Mar 2026 10:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774348095;
	bh=6sgVnhGfx/Gr8MffbxZCAPHDZSVU/xN0vvzwT8HpMXg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TwUPEMQIHDD077VI3busfNuril0YmxjbGwYzsYejnKrfkZDSC31QZyKmCQLu9fJdE
	 S5DNkNHd03l3ny1WkrAQmiEwJkMI2pwGC/B0vLv7fVXyePrr3Hv8/hzfrjcXVx70nH
	 2dXBt0+xytHW7OEPwLd3iYvC/yWcp0dnxi/vvifQowEKAxMbcOwjbqMR9xKJPST+I0
	 OFbGwwBwY34Rx2+NPSefHt/Aszh4h0sx00Ivsq31FzrhDORR9msiKkKuA3Xs32MAW6
	 Yvz0D7YxPYQSeJ9ltUfuOmYgJs35b8EJ6irK5Npyzij9GsMYDq+WoJsHm0MXADDHnt
	 ablF4wBqmilcQ==
Date: Tue, 24 Mar 2026 10:28:08 +0000
From: Will Deacon <will@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Andrei Vagin <avagin@google.com>, Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Cyrill Gorcunov <gorcunov@gmail.com>,
	Mike Rapoport <rppt@kernel.org>,
	Alexander Mikhalitsyn <alexander@mihalicyn.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, criu@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	Chen Ridong <chenridong@huawei.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Eric Biederman <ebiederm@xmission.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Koutny <mkoutny@suse.com>,
	Alexander Mikhalitsyn <aleksandr.mikhalitsyn@futurfusion.io>
Subject: Re: [PATCH 1/4] exec: inherit HWCAPs from the parent process
Message-ID: <acJnOB-rlyt-3jU4@willie-the-truck>
References: <20260323175340.3361311-1-avagin@google.com>
 <20260323175340.3361311-2-avagin@google.com>
 <acGEonF9I6sPA42B@J2N7QTR9R3.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acGEonF9I6sPA42B@J2N7QTR9R3.cambridge.arm.com>
X-Rspamd-Queue-Id: 77A8B1A000A
X-Stat-Signature: 5ngecxsygg1ynghqhm36cf6nuh1xkgnk
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774348096-882604
X-HE-Meta: U2FsdGVkX1/SikCu/VuumaJrspfMuT8j7Q+s+OzMLtljl3T/nnqbRn/cEcJ8CbCUOk/FMd9sc9y52oASApmGBnrUQP2Z/0/tHu61SN8w4bwdjrsejtKrAX2kE1UXcij+BxyQXsKFc4sVFFu0ANrxZKvx0IoxIonmQTzPIvTkefUt3zu56Lw3ta552wdZ3Ki2ReVTEg8xyhK7RrhC43+jEiXClSGBSG8TRbysACwglKZ4NVXakfeLU5KEMN5TbS9nT78O2CBYomUzOQA2OWJrrMSv4fVDlt5U2xWYbhMLBPe2rBcz/XHca5xEMUr+uuZ8LxkraEpSiuieciwtFk6tsuld1RAXNsGP47JsZhUCDDMdaUpY06nRhEqBTrb9jdMi1DuzASu58li1lCQ9dQyBWFgORWRALOLXy1dJi0jRVl1swfpPXf/D4RqltZjivJFmK8T5ozpprayegygeE4PqdrPitugvtetEYqa84Pl0GxNifDf5wlQiPMvcl1X7I+1aC/kuZCkbsK8RgGc0zV4pixyJpjmu2EQa81B0ZB5f5AqjcyEaBMKyQFQ8hJyExBWVpHvJ9qMHdd/HKdEnUmIXiXoaITz1cvgTmp5xL7KYlD0i14jJxBMfqPseGGoET13jPBeUjuJQzM4Ytr33vN0gWsNvJ6u8oh/WhdSzc5XhuBPnLh5lXgq86Z1nOW3b5Cdh4XHXmgSCOtThqFEpO74euhoiQtqmHB7N0yX7Z9UKOGJ8S6U9yAktnJEtB2PEiR35vOkPwb0kCIf1NqLe7jbiA5SrxpeWHwd9rzbJ8DCWz0XsusB0cjiSzYBpG2Yf5fDs8DjGteaGFvF36VAaOPP53Vy+tFZRL0mnksCZC3nbw7UghPl0dkNZa+0PI+Bw9RcSJjd2rka8BY/06oVpGGrbzarpiYhkwkKDFgR9i50+I/K4XQXo9s5GLE31u05jUCfukA0nyARN5hgthx1XIZl
 WBf+VJ+d
 yczyC3jV6hNfIhTCY2sCseyq284BG1myo+CDUKhypnx0EEHEEthN4XTeLctAARHel8CslJ2g9JNOj1fmMx5pP6YPVS1o8jSzIphWaS8Ya2VHy1IW6tEH1woPqJaI1RwqFfdbEh8jmoIkcneQ43U/hKIO32D+z14FMoPXuMKj/0hbjc7E+zN2F7lzcrPWB6ofV/kqQCtCjCKlRCHBNmvddOyZjNj0Hovc2pRxNSSirHkDn87IyrMA0mSf4j9ACh/3f0Kdd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 06:21:22PM +0000, Mark Rutland wrote:
> On Mon, Mar 23, 2026 at 05:53:37PM +0000, Andrei Vagin wrote:
> > Introduces a mechanism to inherit hardware capabilities (AT_HWCAP,
> > AT_HWCAP2, etc.) from a parent process when they have been modified via
> > prctl.
> > 
> > To support C/R operations (snapshots, live migration) in heterogeneous
> > clusters, we must ensure that processes utilize CPU features available
> > on all potential target nodes. To solve this, we need to advertise a
> > common feature set across the cluster.
> > 
> > This patch adds a new mm flag MMF_USER_HWCAP, which is set when the
> > auxiliary vector is modified via prctl(PR_SET_MM, PR_SET_MM_AUXV).  When
> > execve() is called, if the current process has MMF_USER_HWCAP set, the
> > HWCAP values are extracted from the current auxiliary vector and stored
> > in the linux_binprm structure. These values are then used to populate
> > the auxiliary vector of the new process, effectively inheriting the
> > hardware capabilities.
> > 
> > The inherited HWCAPs are masked with the hardware capabilities supported
> > by the current kernel to ensure that we don't report more features than
> > actually supported. This is important to avoid unexpected behavior,
> > especially for processes with additional privileges.
> 
> At a high level, I don't think that's going to be sufficient:
> 
> * On an architecture with other userspace accessible feature
>   identification mechanism registers (e.g. ID registers), userspace
>   might read those. So you might need to hide stuff there too, and
>   that's going to require architecture-specific interfaces to manage.
> 
>   It's possible that some code checks HWCAPs and others check ID
>   registers, and mismatch between the two could be problematic.
> 
> * If the HWCAPs can be inherited by a more privileged task, then a
>   malicious user could use this to hide security features (e.g. shadow
>   stack or pointer authentication on arm64), and make it easier to
>   attack that task. While not a direct attack, it would undermine those
>   features.

Yeah, this looks like a non-starter to me on arm64. Even if it was
extended to apply the same treatment to the idregs, many of the hwcap
features can't actually be disabled by the kernel and so you still run
the risk of a task that probes for the presence of a feature using
something like a SIGILL handler or, perhaps more likely, assumes that
the presence of one hwcap implies the presence of another. And then
there are the applications that just base everything off the MIDR...

There's also kvm, which provides a roundabout way to query some features
of the underlying hardware.

You're probably better off using/extending the idreg overrides we have
in arch/arm64/kernel/pi/idreg-override.c so that you can make your
cluster of heterogeneous machines look alike.

On the other hand, if munging the hwcaps happens to be sufficient for
this particular use-case, can't it be handled entirely in userspace (e.g.
by hacking libc?)

Will

