Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBF6DC982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 09:22:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D90336B009F; Fri, 18 Sep 2026 05:22:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1A786B00A1; Fri, 18 Sep 2026 05:22:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE33D6B00A2; Fri, 18 Sep 2026 05:22:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 990F96B009F
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 05:22:05 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D879F8061A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:22:04 +0000 (UTC)
X-FDA: 85226341368.04.1E438F4
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 32722140006
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:22:03 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=CRc6En4o;
	spf=pass (imf09.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789723323;
	b=1avrujPwoDZpIyChH3jVcqqO8YCHHpLXn+ngoMmhFDXqUMElDKdaM8sUiiQ52oRG08WcLB
	lIUvBLZkYDfIko7Ps0uucDqdzOMVz2YP8YghViSdhAP2rK+pRagzlrDeB1rYMsZZT8HyjN
	FjCSYqDw9NE0pDkTCh4dR5NAvbBxkc0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=CRc6En4o;
	spf=pass (imf09.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789723323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sMrReC/7rL6BxRKpcVSQlwikJWa3PB3Z5vCA5vK3g4k=;
	b=mZVWDmiFY9fVrMVtZwCL1RpVwv0lhCCDcPZGXl0F3Su2fKpJvGk5SRjop9/+WOhq77Wly4
	Gqi/9mgRrkTz8wWZx1noNEfkljb6Rwc8n/PVH9MF8yrwwKz4CJ+TpyYVRNJuaxFwjeQ2ig
	eflKEFeRrmJqlphY+EeCj0efjYoHjJU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D97D0168F;
	Fri, 18 Sep 2026 02:21:58 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2D1193FAF5;
	Fri, 18 Sep 2026 02:22:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789723322; bh=YXbg8h3QX0LMadHGqUmPe0199Ik27wuAwoICustn92g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CRc6En4owgRirjVFVR4Xi7k4EH/UqS925SavcyEn6s2SVlrryWaSnc0wN8NoROyWW
	 y76nl7qrmR2OakFBMRGC0llWAeFBqZZr0fHquU3/J6n1gNaRDrJBOMG/aqFoIVJ7S1
	 fhtNVUhWRtl2QTEcq/Wn9m/1AbLWsqQ8QMRSETPw=
Date: Fri, 18 Sep 2026 10:21:58 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Breno Leitao <leitao@debian.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	workflows@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH 3/3] mm: kmemleak: raise min_unref_scans to 3 for verbose
 auto-scan
Message-ID: <aq0Ctvzr4V4zjF0k@arm.com>
References: <20260917-b4-kmemleak-doc-v1-0-84fde6d1f749@debian.org>
 <20260917-b4-kmemleak-doc-v1-3-84fde6d1f749@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917-b4-kmemleak-doc-v1-3-84fde6d1f749@debian.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 32722140006
X-Rspam-User: 
X-Stat-Signature: 3bckkpxxbbns4hkfh4irxan5irjbd5mf
X-HE-Tag: 1789723323-95053
X-HE-Meta: U2FsdGVkX196iPuLzcvsEFpgwE8OJ4o5xQGtHy2ITel4QOmuNQJFGtXqomG7jZmPWkOa2I4YrfSWZcUj6QGJqOYKumqG9CWTS6B+xaAWkENN8waq6Fk5rU0tIsSLsGvcTwUoc3pwnPiGaZ6M847QkF8Ag1S5FvswbLLh4/MvfbZ6g5Qm3YZ3qKOve6HnfSdzWIOIyuxlneCjYMefde/JjPbAWOgSfctciSoqAFU7vLACqKKd1ihdhv2kiVQE46BKe74WmrCZhojTM3QMzgJYb0TK5SLxpOLTizKtQiLb70QHVx/15oiRkl45tB7HavpOvni19awdR+KS/2iONm39RY/CajUOlqgIH3MwwGYbTthKuDDCPhIq0cJxX33G91hT1Ot8xc/2Zz1uGy4HId6xTXeWM8mRAjtro63nEzHGhT4I7/pBHko74wvVM9Exjsw/l/HnmPyOBIaZwqVigbcOy4n1C/ZVauUp+o5VZu6B78rzfTrF21ZSgbg9/Xr7VBY/kQfqh8ONIBdylZd/HVb3Mr0Hhuw9Rrd9uD9m++o2UM8zAh64Rg60saS1cJ+tgWscIrroUVvnR7hsue5nv8l0aLczHRhy5QvDPUsUHQCjl3/stleevZooQnNAapcoS/rjCF2nE6wRz118dW1mcfEe8Ql5XzVc5nNsN6sertoAJV+2zyQkUmtIMdcmQ/UCRtQFZL1jOCS2/c/z6QbhiD0OwEvUxySA759VtI2/bR2H6Uzi8ejxfpjlxiS5Gyxnta7n6YqwDrvS2PV16kB/f//ELy429L/LI5FDaX/2fdLWXmrfVsCGVhz6jHMsdLXTNf8XXr7XInA5YANpD2rP4b68PmaVCvLQvfIJRBpIl7IGnfUvKiXIT39fLjJJ3bsfnvBsNYktRe8+vrUd0RT3Kh/zvLPCGHBrLOoHPIEWkraBeiFE3YKDXzZPSd+kTKEuoUyTDV40sb617ufTA0PlXBX
 n8k1ocKs
 tHzgQazxMmEJQPDXwrfb84Izfz9fgkbRqDOdMR53yifJ8RQLlgZv9IlKJU3A1XRixJp/L7TC9CIv5+U1/8vjLl7ThCFDc0UjvbxK0XYhfPEJ8HFss8QSQ1OENupZguwCkw8by1f1hscnLep1CzQnH7wBu7/DZSWndFU8rWiai8scNHo240qR3fly1aE4ca8AFtaIskzD1QT4gEgD8esQyokZNMfYT0YQ/x/Wx5Gz97Dr7MlBD51x2Sb84GtU/Hl8KWUcYWlEXvo8sJ6AfrGsaRlnWRct4rqrakn6dvGSCGFbMYIEpgIV3FMnfjDjJ4Y5NAP+t6s/fFeHUSXevqcQ7erzf6RQbRZ+OZBN0LEMKpnvCmF0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026 at 06:47:37AM -0700, Breno Leitao wrote:
> CONFIG_DEBUG_KMEMLEAK_VERBOSE sends every report to the console, so a
> transient false positive there is broadcast to whatever collects the
> kernel log rather than sitting in the debugfs file until someone looks.
> That asymmetry justifies being more conservative than the general case.
> 
> Require one more consecutive unreferenced scan before reporting. The
> only cost is that a genuine leak is reported one scan interval later
> (600s by default); the value stays writable at run time through the
> module parameter.
> 
> Kernels without CONFIG_DEBUG_KMEMLEAK_VERBOSE keep reporting on the
> first unreferenced scan.
> 
> I've been running constant upstream kernel with
> CONFIG_DEBUG_KMEMLEAK_VERBOSE set, and I am still seeing some rare false
> positive, that goes away with min_unref_scans=3, so, making it the
> default based on my heuristic.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>

Until someone comes up with a better idea to reduce the false positives,

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

