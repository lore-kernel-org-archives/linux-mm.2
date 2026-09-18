Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45505C982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 09:21:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A0B76B0098; Fri, 18 Sep 2026 05:21:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 578696B0099; Fri, 18 Sep 2026 05:21:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B52A6B009F; Fri, 18 Sep 2026 05:21:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 325D06B0098
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 05:21:18 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 394D5C0565
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:21:17 +0000 (UTC)
X-FDA: 85226339394.20.DCC9CFD
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 32C551A0003
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:21:15 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LAW1+F6i;
	spf=pass (imf19.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789723275;
	b=5veURQS/2J6tbiyBVOLZwZ9fWKlS/bB1no+YZ6syQUd94/RVj3L6PwFcFcT/7Cl+RubNYF
	xZfw726zuOXoLyP+soIQ1DjHeya6f+VnxuANqKgIMkdClEwpcpGVy/24VnuxY1mGeBrB9K
	kIuNDOx3p2h7c7RDGTDetbu+bKoHmW0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LAW1+F6i;
	spf=pass (imf19.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789723275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=emW+CIqm75bD0uWoBQMsXZb3SCTu4GXqDkhMcs9oBnw=;
	b=P/zXkTMl16XAzEodbLce0GAN40FgqC8r6TeNrAJkryQ8/oSjJlBedURnuvH4SmWdJvYQN6
	Pq6Eg7Ucr/tXp8aHm0njZdiHpBkmC5g4CBvvIodWAY8wcB/XPI/nRDI4YZxGz49jEliv3o
	4kiNO9aGHW0ocVUDkNJBF3LPBy7brSs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AAA2A168F;
	Fri, 18 Sep 2026 02:21:10 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AEE6D3F882;
	Fri, 18 Sep 2026 02:21:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789723274; bh=5CMhIz7TNdTgW0ja0EqDPikDbWaTqP2A9I/h5UkqOQA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LAW1+F6iqLNU7zwhRuci9q8L+w0i/ZhyEK1hvEUAlDRh/Bg+1GlOgMqVikHiT+frd
	 ZoJWyPH0UkjTV1r/5xX6Xvj3o6oadb+H8oHXKjauUeRHLxc7TZuAwSSqvbgIy/6OXY
	 G1LjX/i4OAcjXApwTQ0K1XuyZYh52FOWfoUpIbgw=
Date: Fri, 18 Sep 2026 10:21:09 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Breno Leitao <leitao@debian.org>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, workflows@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, kernel-team@meta.com
Subject: Re: [PATCH 3/3] mm: kmemleak: raise min_unref_scans to 3 for verbose
 auto-scan
Message-ID: <aq0ChSUFw2n6lXIQ@arm.com>
References: <20260917-b4-kmemleak-doc-v1-0-84fde6d1f749@debian.org>
 <20260917-b4-kmemleak-doc-v1-3-84fde6d1f749@debian.org>
 <20260917150443.a872ea0fd692503c53b2b773@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917150443.a872ea0fd692503c53b2b773@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 32C551A0003
X-Stat-Signature: 3fnckcauerhdio8ezi1t8gc46j5dhdee
X-HE-Tag: 1789723275-124102
X-HE-Meta: U2FsdGVkX19sKzofQ8FnVC2YOC2lul4sEPpv9Bog1U3cjR5E5T+hlRVkAcCfqqLeyu8UgsLZVQigcfdGz4C/jypOz60lk0FQkCrG3QaUnzlUqHoyJLpx/JZD9GiG5X7OI+HlFLh86d4ExpPTomy6/QrDr/mVid6eU9XGd9Ws4KRNnZhXhZ7d4i1tdLoXNzzyhuw+5EWokiGQawrsorBVoO32cJq6avZWBajtbY6uwfDMRFL+Ppp5xio59k/dzNIlqrwEKrlVV3Vt1ei9yFRmHHN5+l0cMm/BGvXxRy77qS2+9zD95a+5fp2SkKpVI/msgUrCrk8h8r64rqpfwnS6tLTRnwXRVSXFyxr//ZBGCRwJMQPSRhO5TnX91yTtUIDifWYmPk/Zhgz2YDNbWnMWYWBopwMiSzEUk43ZOvaK18M/kV5DwkzR44mLRxnoAn6hiqeOFCiEh8FO8T78sZncXfq5inXa+lO1fxlPS73aUljjwxGW++I+6+kyPaAoltQBFb908afT/vO3GoMHMtEaIqA7EAwOOLrbeFNr/Nx4fwL6HaM99qxzlBLsoAFSF60365NCEkFbvLspVFT5Pr/ohjhKMTGmIgwZQ4qhyzM5LOf4kqiSN/gCy8td7+qWNZTlceHE0zIvqqIkL2QUpny/2oDCKxhKqx6a9CZKZLYAGCGLbnEojsBfyNTlC2exYN6epzzUw00ErKfhR5WiLx6wp/SHtqcnu1iGArG/RTyw3DZObwWctw3ID+69aasze4u+JozcHL5iGfPFoWGNrrSB1pBtGyFqdD+ir6Iaj+sI1h+h3ZLBBsbf2VKq+IArVUhelRMlGcoJdnuMKShRK/7VRClSXFay6pEx7Z+tmuYK3Cc0QI53PLz0oV9gy3GjhvWQWbSCiBd81n9+v2a3KvdRcTyyyZ8OhmKk8HSwP1YYuZtC+nlKrKnGIp6x4ARkhvTN8QgTRoDOdTu6x6G+0kX
 bcFBpJjx
 y4EGCK8cTZV0djnZuTtHUsBUh+QSY2puTSOuRpWIrWafHuLUpveb5Wq9827IlmTNgGMwMPRS+flkSHAbTnYZqy77k/+mRnviYHTyVsTc8SeozfxJHVH0xmnsjLSgpSZ4dswCsgKpLs02ft/gcQjvGJcfmTnLFIvFHoOvnaEupp5hHllCD52WmkwP6xLbsyC97hVn1ZXlVTeu7PsWtlX95P04Rfs0z0JAoSpDFuWwRFsZCghCgwfEguWB8JGrrD8tB2CdIqvyHlOUVHIUg5IGrhPUBoF0HCaYtMSLrxt88nD4bwUI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026 at 03:04:43PM -0700, Andrew Morton wrote:
> On Thu, 17 Sep 2026 06:47:37 -0700 Breno Leitao <leitao@debian.org> wrote:
> 
> > CONFIG_DEBUG_KMEMLEAK_VERBOSE sends every report to the console, so a
> > transient false positive there is broadcast to whatever collects the
> > kernel log rather than sitting in the debugfs file until someone looks.
> > That asymmetry justifies being more conservative than the general case.
> > 
> > Require one more consecutive unreferenced scan before reporting. The
> > only cost is that a genuine leak is reported one scan interval later
> > (600s by default); the value stays writable at run time through the
> > module parameter.
> > 
> > Kernels without CONFIG_DEBUG_KMEMLEAK_VERBOSE keep reporting on the
> > first unreferenced scan.
> > 
> > I've been running constant upstream kernel with
> > CONFIG_DEBUG_KMEMLEAK_VERBOSE set, and I am still seeing some rare false
> > positive, that goes away with min_unref_scans=3, so, making it the
> > default based on my heuristic.
> 
> I'm guessing going from 2 to 3 reduces the false-positive reporting
> rate, but they're still possible.
> 
> It all sounds rather rubbery.  Why do these false positives occur,
> anyway?  Are we papering over a fundamental problem by filtering out
> its user-visible effects?

The fundamental problem is that we can't do a stop-machine for the
kmemleak scanning. When scanning takes tens of seconds, pointers may
move around memory or registers on other CPUs, so kmemleak could miss
them. It's all probabilistic, hoping that we won't hit the same object
two or three times in a row, 10min apart (for lack of better ideas). We
have other heuristics like checksumming but they don't seem to be
sufficient when testing on a large scale.

-- 
Catalin

