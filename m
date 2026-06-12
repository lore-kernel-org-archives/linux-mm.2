Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D233FCD4F2C
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 09:09:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8BC66B0005; Fri, 12 Jun 2026 05:09:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3D4A6B0088; Fri, 12 Jun 2026 05:09:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C52566B008C; Fri, 12 Jun 2026 05:09:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AFC936B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 05:09:37 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 552C58CDB6
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 09:09:37 +0000 (UTC)
X-FDA: 84870687594.23.C6D2413
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf20.hostedemail.com (Postfix) with ESMTP id A330F1C0003
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 09:09:35 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Zb2BqOhx;
	spf=pass (imf20.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781255375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ov4AVDFRF37D/+G11b2iCMEU1PIeF4rFLNtUdtH3Z3A=;
	b=e/5FNwAOk+q4bG+CWPzGi6t9AVKCrzOP1mv7TIoGu95aE/T1pWkF+vgeXAE0Bi6RiTIXdE
	SJUZgIqb0tTo2TcdlNKERUwaeMnCsBntcru8U0aKobceeFkvlQ07eBsnPMjIxsCusMl8uP
	jFhQu/zU1Y0ZzrnSeomN9yXmUftBjv8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781255375;
	b=SoOUP4fL594gbsW7E8yRG0WgFCh4WuawyZ297Yb8B9vFUMTpXM1g4bqvSm9zEl7UPUPUvc
	KhKK3bwqSQehLYoRLYS9n9JOpLhQ1QSNjWKnBoUyPigETwryDO2M0uR9bBzXw2K9h2xD6C
	wxaDcqibDECrRkqyxyVOqVD+21Pls3E=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Zb2BqOhx;
	spf=pass (imf20.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ov4AVDFRF37D/+G11b2iCMEU1PIeF4rFLNtUdtH3Z3A=; b=Zb2BqOhxIN4tIQojHy3lR9eOto
	cC/wZDHAnH2v5rs3qReuPzaRaYDBpz77V+2NVG+q7tPa8DKdY2/45mpgCudFob3QLViDtpJk/QaUJ
	4kkkvgSLXr8GD2R50aZgOR3EZC1H+FniE+5HtNxXH9VWvQnKRg+CSOrbIbyIRqH6MArtnjJO/P8iG
	dhhBdOcqEGWZab0qG/hDUamNVbUv2syb29BDAh36QaoOMbqWugggQLjlUkueSPprrUR6BG2V+840W
	iz2cdg3VMLT4HJLAbAxNuYstr6wN5bQU3ylkO2Nlnu2/of0Oh3S5FHT7zcmdxnesyz5N4lDDp5sDB
	gueAJOAA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wXxtH-00Acrr-2J;
	Fri, 12 Jun 2026 09:09:28 +0000
Date: Fri, 12 Jun 2026 02:09:23 -0700
From: Breno Leitao <leitao@debian.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: catalin.marinas@arm.com, akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com, sj@kernel.org
Subject: Re: [PATCH RFC] mm/kmemleak: avoid soft lockup when scanning task
 stacks
Message-ID: <aivJ5Dv0hAQ1sJu1@gmail.com>
References: <20260611-kmemleak-stack-resched-v1-1-d6248ade5f4a@debian.org>
 <20260612031605.58235-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260612031605.58235-1-lance.yang@linux.dev>
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A330F1C0003
X-Stat-Signature: anzapqashypp8weysrs9kzdn55b3u648
X-HE-Tag: 1781255375-788363
X-HE-Meta: U2FsdGVkX18/buvEhNz3yHlCI7m1lkiUsTB03O6yLZsbM7ApmLAYWwY0h7D64C0hRua10SAYgUbBqRmNW4SKC69C+8h54Kl/LJxgctZa1aAUm6PBd5vO4g2N636PuPVoBnUAUit6lSwCQTQik4SUUnNi+dPleDC60qDUav2Pv0fS9DqkF3RONOelsbO0RnPLwmad1kiAeGTELva4HwrlevIfK1cB9b6GzhbGs0tADDkM61m1m96LABHzYsiaSGYroCO0ZRjj3MIK6Hl5eRjBlYofRGWw+/g4dzwyZPpBi8YeVfTT2aCJZuRHS2OS/huq5jS0u1gPBa6I+YUsjfzGeECwxZ3WXsIyw/DX7by4vFgD6eGfSQ0jlIzwLpVF9h8zUYxcHHI9pyULLdcW0vsQIYx1ekUV4fOEfaAXzgUjO0Nv3OiygRW91WbPkdRdqG0xohmB8XtLh0mYE9iRf6sl4gP+TAWufNFytl7rh9wxi2YZ0f8cV39q6ZREgqBiC4EEg2DMU9Pk9zFXfmHRnOl+e2VFIlCgAZeDoSOAsvAmJofrNEUw5OZVgNkgwjxBrb9x6X6wIoECfj5nspgOowE7afH3WsraGkWueHv6RMg/5IsFhZUmscfjhAGJQZU9dS104GtVbvyTLDTVO1Z0iS8HFc5F66Q7y75v5sm4299vBoUxPrF+HWoUof0UVtpfuy0ak2raf3QFc8KdsrX8wFv7H23jF/wwn+IqBqafJDr5TKYXxTAef9AaAT6r8AghdXMU0EWQSy/209TGkBTjrz5MeYLm5LqcJquekBbK0LGyGEwVHmstyLwqUlIJLjt3mqUz3XWno4i1kZ60BYYFoHWq6Vks7Rx/mebYfdt5V8uUbc1W4bLhU/+gMlsZdjxdtp7iPNczkBfckRbHhzUzC2lgm5fWp2MdPOJqGII/DkMaj9b0J15V8O4FjQnwmyBdz+N1ERkfI56fxhq0RLIhxCw
 rQU4qHyz
 scbeRKdqum9Y3EtH0CZTO7haZuQi0PSNbG9UAKzJmNP0yJEUt7Ot7F8XqvmDqmJD5SkpCA/gRgQPKJZtRS1CMALQf+txQLbpiyrGw/Llf224PrSML7RskEcJCdsC+HCkyseJS2E+Q4vxdJ28cbtgqkQMXGiNBIl5J6fc7MmQAY8Zil79pYIsaCwlvnYY1uizMX0ItEPI9eI9PfMK1zNwwqd33DG+pyRFHIdOqiCKmLSaMUthsSL2gFrVALtmBZnm3Idvd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Lance,

First of all, thanks for ther review, really awesome!

On Fri, Jun 12, 2026 at 11:16:05AM +0800, Lance Yang wrote:
> On Thu, Jun 11, 2026 at 05:45:00AM -0700, Breno Leitao wrote:
> >kmemleak_scan() walks every thread and scans its kernel stack under a
> >single rcu_read_lock() with no reschedule point. On a host with very
> >many threads -- amplified by KASAN/lockdep in debug builds -- this loop
> >can hog a CPU long enough to trip the soft lockup watchdog:
> >
> >  watchdog: BUG: soft lockup - CPU#35 stuck for 22s! [kmemleak:537]
> >   scan_block
> >   kmemleak_scan
> >   kmemleak_scan_thread
> >   kthread
> 
> Neat, good catch!
> 
> >A cond_resched() cannot be added directly: the loop runs inside an RCU
> >read-side critical section.
> >
> >Split the scan in two parts:
> >
> >1) get the list of tasks (with RCU read lock) in an array
> >2) run scan_block() for the tasks (with cond_reschd()).
> >
> >Is it a sane approach?
> 
> Why not use the kernel/hung_task.c pattern here? Seems simpler, with no
> extra task-array allocation ;)

I've looked at it, but I am not sure we want to break the loop mid-air,
that seems to increase the false positives, given we did a half-baked
scan, right?

> Could break RCU only when resched is needed. Pin the current cursors,
> drop RCU, cond_resched(), take RCU again, and continue only if the
> cursors are still alive ;)
> 
> If either cursor died while RCU was droped, stopping this scan round
> should be fine, IMHO.

I am not sure, this is not the same as the existing kmemleak_cond_resched()
raciness in the object_list loops. Those iterate the marked set, where a miss
only means "this object isn't reported until the next scan" -- under-reporting,
self-healing, and the in-tree comment says exactly that.

Dropping a *root* mid-scan is the opposite: it makes *other* objects get
falsely reported. So the "it's already racy, bailing is fine" reasoning doesn't
carry over from the object loop to the stack loop.

If we go this route, the aborted round has to suppress reporting, reusing
kmemleak's existing "scan was interrupted -> don't report" path:

      if (need_resched() && !kmemleak_stack_scan_break(g, p)) {
              aborted = true;
              goto unlock;
      }
      ...
      if (scan_should_stop() || aborted)
              return;

Then an abort means "this round reports nothing; the next full scan
reports the real leaks" instead of a false-positive flood.

On boxes with very many threads, where the stack walk is long and
need_resched() fires constantly, so the break helper runs a lot -- which makes
aborts (and thus fully-suppressed, non-reporting rounds) plausibly more than
"rare".

Since each round restarts from the head, the tail of the thread list is the
most likely to be perpetually skipped, on exactly the workload this is meant to
fix.

The snapshot avoids that by scanning a complete, similar to what we have today. 

Anyway, I would love to get rid of the array, but, I am not convinced that
dropping the scan mid-air will not cause false positives.

Thanks for the review,
--breno

