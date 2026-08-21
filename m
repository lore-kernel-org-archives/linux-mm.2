Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3722AC5DF87
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 00:03:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 131A26B0095; Thu, 20 Aug 2026 20:03:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 109B76B009B; Thu, 20 Aug 2026 20:03:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 046476B009D; Thu, 20 Aug 2026 20:03:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D4B516B0095
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 20:03:52 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 61D4A1A02EE
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 00:03:52 +0000 (UTC)
X-FDA: 85123328304.05.552BFCA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8E7AD120003
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 00:03:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=GfJIQSk7;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787270630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rkqoQ1bNprLHZhoURPVoyGVzYoMeIkuc+4Vk6Fc2uzk=;
	b=l+f+PtiyUABnb41psWaDAAymzOnbt7Hmk5HkLunieKxC9q+/wt/cjTiSj/MzuBza2p78pF
	9Af4A6GWfYZsNkaZElG2XL6f1otwBsSFF7eToMqMc6eSoZWh7t6RFW95Jc9dFHa4+Q+PeI
	X8BatRc2W3trGq6Nu6MVo68UtaeCSfo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=GfJIQSk7;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787270630;
	b=k+WjvKDFZw5IoNmD7Cb36nECRFiAe6s9vgIHN43ulawqbeEsRo72bagzp+e5DrlNWFYBfe
	lYC1rpX9QpGlNg3+DubNlnw5L54/sh3MA1mo+jGLm7NNPjA7si4s6CiGM6jx7qMcyVzP6D
	m3/OZoHr4ZMcy8cmdif+SdjfteVWAFE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CF77B60A58;
	Fri, 21 Aug 2026 00:03:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 130941F000E9;
	Fri, 21 Aug 2026 00:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787270629;
	bh=rkqoQ1bNprLHZhoURPVoyGVzYoMeIkuc+4Vk6Fc2uzk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=GfJIQSk7VaFpnteowHD/FR0/xe6Peu4XjC5VYanSXlsFT621yIX8fq8xncajnoDev
	 PYBBJD82NMxIY0W7y0w/JIAbwOtqkrFkFYWNGwLq0/7YrebfI9WZODjg7F34825QUr
	 i/Kv9foWkJV0FleVubC27wy6ae93DLU3J1aG7pMU=
Date: Thu, 20 Aug 2026 17:03:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jason Miu <jasonmiu@google.com>
Cc: David Hildenbrand <david@kernel.org>, Shuah Khan <shuah@kernel.org>,
 David Rientjes <rientjes@google.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Greg Thelen
 <gthelen@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] selftests: mm: introduce page allocation stall
 reproducer
Message-Id: <20260820170348.48f04ed654dce5193ca3a532@linux-foundation.org>
In-Reply-To: <20260819070538.2404983-1-jasonmiu@google.com>
References: <20260819070538.2404983-1-jasonmiu@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8E7AD120003
X-Stat-Signature: ija49x6e9tdu77yinaonp3wo19c3yg45
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787270630-809513
X-HE-Meta: U2FsdGVkX1/Qy7BfXiZS+0lss5fEYnZk/uX0zO8nt7vEFIS6VvwjZcY6SXC7+CVKWSyjtUp0mzKN01VgQdFPl1j6vqfplXgzOqsC+Wt474BFPpCeINO1xXSp4vsQWqIA4GH5DCGAV8wob9EvdM8v1/T6Ymw0GPDuYWn6uyGwAvh0SBDf78cUo2WdexExJSgQd5ZhtZjoScnK5YBaUFFp0TmMrLdiKOhYn1Mt4aUJwDc1zqXoK+hSRaKM3kNoeFb4EGcpkaJudBQ6hWieCgj2YzkCx3XBDwLPCGV3w2/K0f41h2m33nnfO3mowOsSWI4sI3x8mv7RV2SnGCjDhd+BTOS5rAkyKoi3Q7mhdxH8FwHTe1I9XXEtXqtVECVGFzo1bBhGYGaesYWbUTK3PY6/T3wx0tOXJCLviKd7q1Eee8MZltaiJj9XFcfoGml/OFPF4ROZnep+5nS282fnv0vGzTLGHB0kaRyD/euoHN8NipVq5I/PinL19C0hFK47u6+X2yDnOW2OYf2sxbnVSCICj7Rl6325v6O1Uu6yn/wmkb7iYbaMx/bbiIvOsPXeUimUDoxn60izHP3ubV4TKM4Tq/IZ9DV8LC4pVUMeeTbzk7aEcysis2rMo4jsO4en6EE4yBMXvOWizjqD8fuEylkVK8GAz172Zvc42hGGKBR5YWtdgAoZnLXcaZEgV4Lpx3mBvvaY8PN+slpXc17fm3cm1w6jTSOSGDM9zDrhH098HnoWpcBhRvxbQKzOdCjDm4/50ykeX36zEwP27LUcWmwVBzviCfPCRYEmncUKp8AeEm4bQC12M7bCfR0isNjOf3itROJ/mEdjkf0Jm3Rz0hAAg7xiHuPEuK3i8V4p4ArhLDXSYiDhWKZitvpDLewGDM6/57JAATfOHIsFl+MZsiRpkAaygv3NftXZB+L7kihTRYFqt4JfdNhn3JWuvAdVri21J0YJRenwjfw4s/SkSou
 0aqRcGf0
 5mC3t5CJoLXWU2sTaMsDi8TCV/DEr08o1RZYgxj689wOHqwJ2CXZ/vhweq7yARFtpYY6g+Dl3jjGWmOUC+f/zTLpiq3xVjGwgD/Urs7492libPTF+qm7bsbufajWgsVOFZUgze+fXVvbTSFCwaThnHoHxXL97cN9jhYDQK7WCuTp66x6pifX461tDmOjHCzpGBZNx9Qh56NXPbkYcDixv1ZM1+4EbWIvs7WpP4lhbHegbLxie+QwTRDh9sgcuKVtCNVJqNs81k3xFdZK4sCT+IWzC91Xe0YNYyuNa4k5pef4y35lqwd4uMb3ufYxHTlKwFgErvGTChNTufAk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 19 Aug 2026 00:05:35 -0700 Jason Miu <jasonmiu@google.com> wrote:

> Background
> ==========
> Under severe system memory pressure, system unresponsiveness often 
> occurs due to page allocation stalls. In commit 94e0bcde055e ("mm, 
> page_alloc: reintroduce page allocation stall warning"), David Rientjes 
> introduced a warning mechanism to emit a kernel log when a page 
> allocation takes longer than 10 seconds. This log is used to correlate
> a frozen system with the system memory state at the time of failure.
> 
> To further debug and analyze these allocation stalls, we need a 
> reproducible test case. This patch series introduces a new selftest 
> designed to artificially mimic the severe memory pressure scenarios 
> seen in production, allowing us to observe the resulting allocation 
> stalls.

Interesting.

>  lib/Kconfig.debug                             |  11 +
>  lib/Makefile                                  |   1 +
>  lib/test_mempress_timer.c                     | 140 +++++++++++
>  .../testing/selftests/mm/page_alloc_stall.sh  |  80 ++++++
>  .../selftests/mm/page_alloc_stall_pressure.py | 235 ++++++++++++++++++
>  5 files changed, 467 insertions(+)
>  create mode 100644 lib/test_mempress_timer.c
>  create mode 100644 tools/testing/selftests/mm/page_alloc_stall.sh
>  create mode 100644 tools/testing/selftests/mm/page_alloc_stall_pressure.py

Nothing fits very well, does it?



selftests is for quick tests which are run by run_kselftest.sh.  You
had to place it in selftests because there isn't anywhere obvious for
it to live.

So I suggest a brand new tools/testing/stresstests/mm.  If we create
this, people will jump on it and start adding things which presently
reside in their personal collections.



I can't say I like "mempress".  Is "memory_pressure" too wordy?



All of lib/test*.c shouldn't be in lib/.  lib/ is for library code! 
Again, we put them there because people are shy about doing mkdir.


Sashiko said hello:
	https://sashiko.dev/#/patchset/20260819070538.2404983-1-jasonmiu@google.com


In [patch 1/3], s/__GFP_NOFAIL// and s/cond_resched()//.

