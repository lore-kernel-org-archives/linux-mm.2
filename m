Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B443BC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 09:00:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 999AA6B0092; Mon, 13 Jul 2026 05:00:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94A216B0093; Mon, 13 Jul 2026 05:00:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 887336B0095; Mon, 13 Jul 2026 05:00:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6C3B36B0092
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 05:00:56 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DC57CC8437
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 09:00:55 +0000 (UTC)
X-FDA: 84983158470.07.5558ED8
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id BD65020007
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 09:00:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ZjVUbm1i;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783933254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uhbqrza6JOxR/o0Mw7vTWiNnn86olZ/B/sZ9t0yhQpU=;
	b=jKHSJEkMBJ5npwNyBd1bd2DJ6liNeCWNVUrhcVnN5/WducpDU3U1dKULh6E9z6dTvWoYf+
	xLfidcmKuKqb4OwU0V01QhyHQNsHqpXp/3xnHaCNcz6HhXQTtEC/XWh4v9/lZMXQ9bbta4
	r6t0ipePZL5C5SInBT5TLFXkktjVh2E=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ZjVUbm1i;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783933254;
	b=GV4uPA6bfAqd+YZpnJl6dIi+kcW7/Oui7xo6UnHZym4hB5maUHJ55gg4LVhhYxjEuHsSyr
	D1A5IMbiocYLgFV6JCwyIb7dv0+Tv2d0QdJ94pbRb7zikh3+c+0Igxh59GNigOoyw+BnOP
	5xJGoswU6JfVBV4tnZ7/4LTCb/MGGYo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3BB741576;
	Mon, 13 Jul 2026 02:00:48 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 919C93F93E;
	Mon, 13 Jul 2026 02:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783933252; bh=t9O/1hD3qn8hp9fPVidp6LNF4W82iFP7Kx9rmmWgG7w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZjVUbm1i0r7id0oXgnlEVsYHjjTTsjagynsDqwUq4JWQboX2Ta+P0jQIneVqXglDF
	 Y0iOs637bqapD1xlzQM3YZPtUEaAwFrKBHTwUhWke7Ow02jmtEmAo0gbD34MtSDSHl
	 bRQtizh+12rSoMMLXxrwY+KFMReQSmAN745ISqtk=
Date: Mon, 13 Jul 2026 10:00:39 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Breno Leitao <leitao@debian.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: kmemleak: confirm suspected leaks with a second scan
Message-ID: <alSpN_sTpUkjDFxh@arm.com>
References: <20260709173347.689607-1-catalin.marinas@arm.com>
 <alCxkNBvoDGRG2ee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alCxkNBvoDGRG2ee@gmail.com>
X-Rspamd-Queue-Id: BD65020007
X-Stat-Signature: zcdaaoy4uhw1ydarin7ndrajcge566zo
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783933253-284607
X-HE-Meta: U2FsdGVkX1/Dncy6UN84hBDKbzBUxMpzxgtpkgjcAP7ANsSg1I4LyUp4mjV301k1W3qP8A+jbXX2NLa+nf4Qe1XaZ9xhPL5AFkdm0tdDMTm2cgNT+zXqyGFWEkhmEZEqI/TmThfA5Lba5M1Ep86wtNcfBQVFjnfUG/A8czW1ELdPDrDsivntGtg79gtrLOLXPnf7If9xfwDGoO78I9SnLYl5sAqFA5Qzrys9kh0V8/CCMRq+mY6qP834tJdSM8AVjQOp3/1Pcx3bPg6RR54H/L6/WRl34aoHpRZMTnQFh2yGkw8JF2FG/0XeWh2zMRy5bFeHa0dfwXUgijzd1zP/Pn4qLiL4cdYX2fWKOoQ6jAo7Jd7YJUFTFPUkfe4JH/Q1h4qpfLiQIbAMUAivGfRo7p46tWnZHp6rKZMcG9egi4H2e+hqWYbve4itVmYGMA1pSgNjLpoQEE4JUPghnYP7qch9YBW1Ig9RgkKz8ea8RMLZ7YmXKH+P858dGQZK0hd6ECAGZQ9BSCS8VksERaNH+JGrn4kwkt/GuZvQ2u35izky1+E2aYCKsvkJcA9eA4yEKQcu3x7khLWKoBVB1TKUKkHwI7ihpiUYl05y1j5VYNJEJnjNmgzeWjV+p3DhxUC+3ffGaaUmt3zEcW3QiP+WSYOb8BJ+W+ztELI3rCtBM9YChYFTKHi0azLsA3XiVsYuqALWbZEW6dHR4OMw7l4dUM5iB0kzpWPjfDxsauJdSJlL3N0D/lHkkTS1mO0zxVXpZ4DbRoQ5C9bYwGt2y5U28r1K6qXbF3e2hZStyWydpTZtJEYq5zxrF9pPLEpQxMnab7zmq5xEqq3zu97RGGQHGyBtyKhRAQzxSjLa9GmpStMBPIaFrISCintt7Ihyrvp5Fs10BJe29WZy2mC9Ft/F5a6KCK9m3Tc79+p528LRH+ELVbfvJPQqEIa3vFLLLUgwgdjslNrLqkJocVs2bSk
 aZjJTCxm
 hrUTxhiRc3wT+qp62alEIysK8b/CFJofSu7ExLucgNyOe3eeH43LXWvLRKf/oHnVncnnophkGMJV4QqdKqSlQ8ulxuq3GNH6YAUCdXkey4qoj6DOOiSxLCZ26I3YZjBXpbdVG438pArGT2MbRdy/r0BD6CVEumcfil1VQJV/gYJmwoQiw9VEpL6KvMlLw/kg3/zyuXc4FC/N8jQB9RkbO5L5r4z/gGKaO/WsXMWr/fpauvM/xzU7c8eObH93FmXX4hkrz33AJF2bIMay9r2JVH6M4GaTTdedAQ8N1DsJASQy0umUvqHqh6eQbJvOdyBhEqIs6e2uxU2q9+YhjLZ/RxH5JxXYh5gJCse1Gp5MrJDcdZNkSPK84N5SS/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 01:51:40AM -0700, Breno Leitao wrote:
> On Thu, Jul 09, 2026 at 06:24:47PM +0100, Catalin Marinas wrote:
> > The kmemleak marking phase is not atomic. While the object graph is
> > traversed, the kernel can modify pointers, free objects or allocate new
> > ones. If a reference to an object is moved from one location to another,
> > kmemleak scanning may miss it. We have explicit annotations like
> > kmemleak_transient_leak() but identifying and maintaining them is not
> > trivial.
> > 
> > Given that such transient leaks are short-lived, rather than just
> > reporting such objects as leaks, do another scan to confirm the
> > suspected objects. If no new leaks are found during the first scan, skip
> > the confirmation one.
> > 
> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > Assisted-by: Claude:claude-opus-4-8
> > Cc: Breno Leitao <leitao@debian.org>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> 
> Tested-by: Breno Leitao <leitao@debian.org>
> Reviewed-by: Breno Leitao <leitao@debian.org>

Thanks!

> PS: This is now conflicting with commit 946935b07cc94 ("mm/kmemleak:
> skip the remaining scan phases when interrupted"), which has just showed
> up in linux-next. So, a respin might be required.
> 
> > BTW, I'll be away from Saturday for three weeks. I may reply
> > occasionally but won't be able to test anything.
> 
> Let me know if you want me to respin it based on linux-next.

Yes, please, you have time. Thank you!

-- 
Catalin

