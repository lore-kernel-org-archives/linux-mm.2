Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E296BC982D9
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 10:21:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08FCB6B0092; Fri, 18 Sep 2026 06:21:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03FE96B0098; Fri, 18 Sep 2026 06:21:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBFD16B00A7; Fri, 18 Sep 2026 06:21:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CD8DC6B0092
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:21:04 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2F6C4A0601
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:21:04 +0000 (UTC)
X-FDA: 85226490048.08.90AC9F3
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9086D140004
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:21:02 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=oOO60XwY;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf09.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789726862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ZQNv34Ek5Ax6QYdQ7WcoxvzXPWjuzfsPGdEUkXflEs=;
	b=RC69DYeom04UfS6H8GbgZJvoSroARQ+Aw43UmppUv9lqxGcyk5PlYZ9nfyZTw7q0ffMo0y
	O3L6cCsi3Xf5NjP9WbUBe4txp5M3SnFgXyoEQ8u0AtcawHVFWDYo0rA8tOmEpgsVsvCzte
	3Dyyz5opbCySgvT6dG8v12cDk6jjh8k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789726862;
	b=gJBvBbURBhazvmAhzB47gaQIpDobq6HHLYQBS+1tHUUSCDl5qoxNPpwVYAa6eklVbfKCOA
	0Yj0/gVYB9mMg8oUPMN07K7/SugNbsK4g8z7Kf6QXo4G8vhrDLJGidYUi73fIZ0GXguFeS
	4JpFNc7VwN3wH9jv9YvTLL3EQVz34ME=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=oOO60XwY;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf09.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/ZQNv34Ek5Ax6QYdQ7WcoxvzXPWjuzfsPGdEUkXflEs=; b=oOO60XwY8ERyAwZK1S5h0ToTPQ
	OWwppHptar6tur502/2Wg9/RCn2+pTXEtbIxFfHSEZlVoELlME73jhYQbNgjqZXZLZlskIwr4BRLo
	4KhTvT+ONt5E5DYomWH9sCloKyIcNdSH+jcmjU8hT4oxN+3cPP3FToHvfwgCedBhWkNh93FuDuebg
	LSCa4XpTARiqYS5ebFHkY+qrfq04Jev8uQkMm22bxOdXL6rKAblbLD/pGi5gzHlrNVhf8kjDvSZ2a
	DiR2HyXULTC0Etm/1SxcycLYuX1tHXwQnnjP8oldLyI2EF+MMok6nX92fsb8cD8KxXPWvDBGHbwPS
	JquZVzOw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x7Vi1-006eOU-1G;
	Fri, 18 Sep 2026 10:20:45 +0000
Date: Fri, 18 Sep 2026 03:20:39 -0700
From: Breno Leitao <leitao@debian.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Randy Dunlap <rdunlap@infradead.org>, workflows@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-team@meta.com
Subject: Re: [PATCH 3/3] mm: kmemleak: raise min_unref_scans to 3 for verbose
 auto-scan
Message-ID: <aq0PcQ-S5i8CWqr1@gmail.com>
References: <20260917-b4-kmemleak-doc-v1-0-84fde6d1f749@debian.org>
 <20260917-b4-kmemleak-doc-v1-3-84fde6d1f749@debian.org>
 <20260917150443.a872ea0fd692503c53b2b773@linux-foundation.org>
 <aq0ChSUFw2n6lXIQ@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aq0ChSUFw2n6lXIQ@arm.com>
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9086D140004
X-Stat-Signature: turx85865z7bn5naw6mgf1qznz8y9nef
X-HE-Tag: 1789726862-563684
X-HE-Meta: U2FsdGVkX19PJY1C3d0NaGjkz512X98XbBT166kW7IapZJtj/+UuDWwjWumTtUGFyLRpefdDcmoWV4IKFiziQ8OhOwahdFSwrvVxUOSKWveApcxK9Lb2PDgYzYMS4epdP54JLG7LB5ZP5IsNnUKkDmcJSsTVN7o1Uktsw3FH7LyQicX5A5q6noycebr20TKRLTkgDLQDs5MEindM0KEplfQffPd7sswHRFi/M/LZq2JWaNQQoqI3Eq5FohzsIkRv6Enj8mizhyy0GzsPgYdaMfN1a9UDLlycqwA0vMcAUbPSJJ3XDtf9p2hBgkWtYkHRAg0TGkjxbZWWGeiFnJKS1AM47+PCyx0E+uPMKfGpH5j+zOFdaSFBZ7U0Nh+ihcH4dOZSewTEBaBIQInE/eDAEWnzRZkg3zK8fF0kLzenaiuHV5V1Ba4BfVVA71wfyWmv2o9agXNWgaitO0JS0ZU9f5lvnxEZDjldr06N3q4lN2gokBOGBwFViqjJ89NaW/9YoVGM7r8n55v/nxnAJJ0Yd7g8u4G79oMAZ3o4M6Ltb/U6kxAbUmKTYyTkkpJA7kJME7oIdDvAqZUV2ig/YJ4/nByAdCuOve8luTUBaOh2lIkIaKru2UvfHEGsp+/dPm1FFMBijMbb17Rpbp+0Z+mib+hyXUuWrxaV2oHlt/JUu1TZU+pJicMcK/oT+5hedVdR2/qD1f99vVQBzArgdV8eHjb83E/VMDYS+YJUkeUPyZ/KkLVFqfEcUGL5/MuA4hZbDGewrFDCUqdcuEPEXZGSCkMOuqshPuhxStKPN15hYZqXfZ9bP9TCLuW3wr2i8lilAEL5ZR/RrDNUlgbf0Y/YzmP/5sGZvdS2k5dTBMGn7L9buA4MPTxGwBVcDjQvH0ZSBn96PCTT6YwCRWAjP4HmY21PpxT9gs2ogW3YRXagI2r73dTYSU+IJFK2J0TZkRptMLbpDHN53NQn5XpAeLy
 OiD9joXT
 mwDY79t0cHyLDdvwkQx6RHe1xgghiKcy2CK+1qqymg8nd46/SZ0j3atgYLqbSXFo6LfIP1ar6PS4zGfImTPjz7RujDPM+vSu0yIwVfVwsBS8UZP6gejQPsAC8uMAKqVWI9ryPjxo2I1qLjL4h918RGWe/PrXhgx3+fHecqv0De4G0THObRQoHDs5bjAQTdK+Fw+QS2brbLwTQgr2RLKYoPaJ0ffSs5BRDOeI5uzx/jJ2QfK0thjiBCWIK27svg3NUTfPAdlhAKCyGZXyJe71UZDxq2iCdc4iGPYuL4bMHyDvRkB1YM0hFzG+y09kRgUxEPg908jzebsbDaLA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 10:21:09AM +0100, Catalin Marinas wrote:
> On Thu, Sep 17, 2026 at 03:04:43PM -0700, Andrew Morton wrote:
> > On Thu, 17 Sep 2026 06:47:37 -0700 Breno Leitao <leitao@debian.org> wrote:
> >
> > > CONFIG_DEBUG_KMEMLEAK_VERBOSE sends every report to the console, so a
> > > transient false positive there is broadcast to whatever collects the
> > > kernel log rather than sitting in the debugfs file until someone looks.
> > > That asymmetry justifies being more conservative than the general case.
> > >
> > > Require one more consecutive unreferenced scan before reporting. The
> > > only cost is that a genuine leak is reported one scan interval later
> > > (600s by default); the value stays writable at run time through the
> > > module parameter.
> > >
> > > Kernels without CONFIG_DEBUG_KMEMLEAK_VERBOSE keep reporting on the
> > > first unreferenced scan.
> > >
> > > I've been running constant upstream kernel with
> > > CONFIG_DEBUG_KMEMLEAK_VERBOSE set, and I am still seeing some rare false
> > > positive, that goes away with min_unref_scans=3, so, making it the
> > > default based on my heuristic.
> >
> > I'm guessing going from 2 to 3 reduces the false-positive reporting
> > rate, but they're still possible.
> >
> > It all sounds rather rubbery.  Why do these false positives occur,
> > anyway?  Are we papering over a fundamental problem by filtering out
> > its user-visible effects?
>
> The fundamental problem is that we can't do a stop-machine for the
> kmemleak scanning. When scanning takes tens of seconds, pointers may
> move around memory or registers on other CPUs, so kmemleak could miss
> them. It's all probabilistic, hoping that we won't hit the same object
> two or three times in a row, 10min apart (for lack of better ideas). We
> have other heuristics like checksumming but they don't seem to be
> sufficient when testing on a large scale.

In fact, in my investigation there's only a single use case where I
actually see this false positive, which go away with this new approch.

And I have a very solidy test setup where linux-next is deployed daily
and run for 24 hours, until the next kernel replaces it. This is on real
hardware with some basic workloads, so, in fact the false positive
(given the design above) is quite low.

