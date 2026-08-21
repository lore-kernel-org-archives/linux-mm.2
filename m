Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CFA5C5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 18:28:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BA8C6B008C; Fri, 21 Aug 2026 14:28:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26C006B0092; Fri, 21 Aug 2026 14:28:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A8D16B009B; Fri, 21 Aug 2026 14:28:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E9F006B008C
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 14:28:39 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7FC5E1A016A
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 18:28:39 +0000 (UTC)
X-FDA: 85126112358.09.24DBC51
Received: from panther.cherry.relay.mailchannels.net (panther.cherry.relay.mailchannels.net [23.83.223.141])
	by imf11.hostedemail.com (Postfix) with ESMTP id 194E140004
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 18:28:36 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=melanic.org header.s=hostingermail-a header.b=Ex8NAptm;
	dmarc=pass (policy=none) header.from=melanic.org;
	spf=pass (imf11.hostedemail.com: domain of moise@melanic.org designates 23.83.223.141 as permitted sender) smtp.mailfrom=moise@melanic.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787336917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=y0H6u+Y8Fp33g4BMhqv2A76gIMJ9wJgN5OpGPv5y6Mk=;
	b=oQmEqxoAqMX6yNxQYo9U2/cxnf75ikAZ7sGzVl1OKQZE6VbSDeckH3qVBoRCGrRiGie/gB
	8l4+ACcCY8a3G1AH31tJVCgKHxCyFquRRpQY+Ipr+LizxIB2szXf6Fs13au52uISVXIJQ3
	JLN3ZRrEbLkrkbpctyiDdVbUajNfRV8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=melanic.org header.s=hostingermail-a header.b=Ex8NAptm;
	dmarc=pass (policy=none) header.from=melanic.org;
	spf=pass (imf11.hostedemail.com: domain of moise@melanic.org designates 23.83.223.141 as permitted sender) smtp.mailfrom=moise@melanic.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787336917;
	b=AMDVcPMOAoOsOCVuncmivp8AdFlEo+SE2z33ZeiEajNOYaRP5zZF4vR7Co4eZDNpOkfZgh
	pR2KfJfM80cU/BqnlbbaY4e5nL37R5DBMYC8jBPWBfpBY4UxH73xY1HJrejlszyL3rHqt2
	YUxJ25y5FUGES0iNhiLwz59vfn+Kttc=
X-Sender-Id: hostingeremail|x-authuser|moise@melanic.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 78E7740081C;
	Fri, 21 Aug 2026 18:28:35 +0000 (UTC)
Received: from de-fra-smtpout1.hostinger.io (100-96-14-83.trex-nlb.outbound.svc.cluster.local [100.96.14.83])
	(Authenticated sender: hostingeremail)
	by relay.mailchannels.net (Postfix) with ESMTPA id B2FF0401D4E;
	Fri, 21 Aug 2026 18:28:31 +0000 (UTC)
X-Sender-Id: hostingeremail|x-authuser|moise@melanic.org
X-MC-Relay: Neutral
X-MailChannels-SenderId: hostingeremail|x-authuser|moise@melanic.org
X-MailChannels-Auth-Id: hostingeremail
X-Belong-Skirt: 138402670fbe3dcd_1787336915288_3410687736
X-MC-Loop-Signature: 1787336915288:4117894728
X-MC-Ingress-Time: 1787336915288
Received: from de-fra-smtpout1.hostinger.io (de-fra-smtpout1.hostinger.io
 [148.222.55.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.96.14.83 (trex/8.0.2);
	Fri, 21 Aug 2026 18:28:35 +0000
Received: from localhost (unknown [73.4.98.140])
	(Authenticated sender: moise@melanic.org)
	by smtp.hostinger.com (smtp.hostinger.com) with ESMTPSA id 4hRTMd3Mqdz41Bk;
	Fri, 21 Aug 2026 18:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=melanic.org;
	s=hostingermail-a; t=1787336909;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=y0H6u+Y8Fp33g4BMhqv2A76gIMJ9wJgN5OpGPv5y6Mk=;
	b=Ex8NAptmbX6Eq6/FgptI6UBW2u7lPdbOSwrEbDHUEPBUKB1iIJKNHGFt+whXy0BCKDYLeh
	sgJpDwZ0Ns0MT2tkMuaZ2iGHQoAcyMD5cG+GL0kxP2gb5lpbufKgcTmBBZ8z85izeiyOi3
	rS5DW98DRGGdt2FFMpl7k/+w7Gwm6GMNVjTH0VRB5EW5vFzwl/UhYDLoISr1rvhKBwyHCC
	6A6W8wKFN7DZB0ZxTVsZ+ZnItmLNpE7gztNPuEE22eGeoLB+YanJcVmv8KcldbexsK4PY/
	IpginT66PaRUKwA1qvOtYKap6EgaOFhA6RvG0Oz+XFAYnzaMI0u6ZbDKPEkXzw==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Message-Id: <DKUU1YRIIFGF.2Y7M5HXDCG19R@melanic.org>
Subject: [RFC] memory.high auto limit daemon
From: "Andrew Moise" <moise@melanic.org>
To: <linux-mm@kvack.org>, <hannes@cmpxchg.org>
X-Mailer: aerc 0.22.0
Date: Fri, 21 Aug 2026 18:28:29 +0000 (UTC)
X-CM-Envelope: MS4xfEa6slZW0GqgCwHuJFQv/8MfsJlz4R7L/vDH77ew0PSK9M7fQZKfynZnu0RRC4TvdKgLFfwy2LXubdKnFy7NsUnRf+lQeOPUqJrlsCwL5YNZgx/lbaSc vj30KBzKRfDD/Td+0uK660GBh4jNhPpWZhmQaWf9cKQAoFZM0iHCBuxpp4pr8k4Sc/EoijhdMoSKrNI2dGQRI8MDudJsA7GjuDQ=
X-CM-Analysis: v=2.4 cv=fr2OZ04f c=1 sm=1 tr=0 ts=6a8898cd a=tlFvG+WYsuLx1OZ5RMiffA==:117 a=tlFvG+WYsuLx1OZ5RMiffA==:17 a=IkcTkHD0fZMA:10 a=SXzkmgPmAAAA:8 a=OGjWj8McAAAA:8 a=3BgyhFcLIEM2KKGDJPUA:9 a=QEXdDO2ut3YA:10 a=-FEs8UIgK8oA:10 a=EWLf6cg6Bh5aS0AxDgDu:22 a=UYjydHh6ynBBc6_pBLvz:22 a=ro8diQT2BJi9Lq4alXVm:22
X-AuthUser: moise@melanic.org
X-Rspam-User: 
X-Stat-Signature: g4b5k6hyrbn8ck8e16tkjbemk4ia71s6
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 194E140004
X-HE-Tag: 1787336916-858642
X-HE-Meta: U2FsdGVkX18+dUAPgWulL6UrgFXbMZGqWq15NUKWDguCXI0ADKTEeHfsjI7FheKxSzclCAgf3eLZYkmJk53a0KX5bNPnDYY7LG5QisK7HcaPbvL9Ux7XEb90zdXgYBAzZsiyQjFd2fT+zpn9L4lgjPvGVi4mLRWrYUEkNRnnjVGcEkXfOtsOSGgYAI2IpmuUGR/QJRYOhoG1YyRDH5yJl4ND7o4jfouqRMvTMcH1miC9QnlT13aViGkz3gdL8PZ6NroyNuTtCoBdfOtaUUdQJNxnnXo9adLb+sNlpqU08EIiHDUCCfFuX24FUxPUFRP1GpYN3LHdhZZxJyOPNv/QuD0s4VnnCwNpWKfRzzhfdikYcPKkpNdt/4Se25Ti07T8nUwEmRbE4AzWNdSmtpmocgt6IhX7I0vaBjCHbhIwBZe54IdGMIBUBdR+5A6DpGn4AkUtTQ2j9qeptYdQi1LEsag11qOyo2iBk+iMokSs4CJSgkMX7/xjpeD2yJyWLj/79dur6XNV7HcsGjoG/C0bYPCKaeCXdLnbCV4AmDwNEHzUivWFCxUqHhVD6y696wGhNTwbBi/W+25jhP8IHe9U3oXDqsbKFn5x8rWVbBx9pasXa6ERLLswWvsl3TSanLtnV2ZxD1wjhGP39uWFD5RErTmhlETjomP/5fzMZxSx8FhbFZi5ispjjJYo/hpyZ2OX4OCFXNJwjdW7JObu+Ku7fif1the+lVVlNNii1mPm+jDBy5qSrhkJy/ekk+57PGsqZOBBBy9pYyOlv+zKnrHkw+rQVY5+Ktj1NzrXVIe/1tRYeUor/QBAvqCuKvtCHlpT8iBJwYQDvEzptq2qugaF9qETKH7lRb/nSaYnNBCbELtGuwV7JnnIMgMoyK7wKtiL3jQh5MCoCLFfnNkpRh91W0SSGGtO5YRXXNm0WUXWYxusdJqBdldu+5qY0YaupssWrcdF96ZhPfyQQF19+kS
 Kz+ax67N
 eEO7kR2e0CyVv/ttqVsDLveAPjKAy2/Dv6odo25Z4I9J1tG1ESSZrTrQCQVYcnC62cUBE54qk+VzIdjFsCslxw+B4JI5fSgzoWgVSPIraHd3eYmudL8q4wK4m93ZVqlA6uf4YB18IhqexEfi/EgXxFYi7RBOEbzK4xAH3nj7YUDI5vSmZ48QkcBweLqYp0TvXvDTsN3CB+KtJeFNNXmoSO3wPuHg1H1oZ6usgH7b8+VBZsFpZ6mv781SaODaRyvXvUU4ma6zslOXi+BKWHHaDF8MZluiCKbevL8t0jXyk9nSun2L471K3+rb53L0MZKWQm34R7IVZCD5dwtwMw3I4wy0dIPeGoFQq81wjI4UvzZEvLYe0wVLwgacNNQnLBiAXUhQNExU/xcGFKnEJJZJaRjIfnuvJCPohgKkqpay9NlqbYdURrwsxsoB5D2v/iVeklqqTYpUxmRjXMxFIFu4cxiaDAj4oqtej3ppp+b2Rd26TZXguIMLZ8REW0Mi4sziaM2hNrx7bgu0O8FQu3yhA/4uO4Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all. So I wrote a daemon which attempts to manage memory.high limits
to keep interactive processes usable during thrashing (Rust compiles,
NixOS builds, etc) without the user needing to do workload-specific
setup. I'd be interested in feedback on idea and implementation, if
anyone is interested to take a look.

Code: https://codeberg.org/andyman/destressd

Basically what it's doing is:

* We watch the PSI stall percentages to see if programs are starting
  to stall because of memory pressure.
* When they are, we try to roughly estimate how much memory each
  cgroup was trying to touch during the last 5 seconds of its
  computation time, if PSI waiting time hadn't been a factor.
* Whatever is the weightiest cgroup by that metric (*), we start
  bumping down its memory.high allotment incrementally until we stop
  seeing PSI-indicated memory stalls in other cgroups.

(*) oversimplifying a bit

To me this seems like experimentally a feasible approach. I did some
testing of how long it takes to do simple browser tasks under pretty
punishing thrashing caused by Rust compiles. There are details in
the tool's README, but overall the results on my machine averaged
over five runs are these:

  phase                    normal   thrashing  thrashing+destressd
  --------------------- ---------  ----------  -------------------
  browser_startup          0.78s       21.63s               14.95s
  reddit_load              2.56s       27.57s               10.02s
  scroll_20               20.99s       39.91s               27.05s

The test is not super-scientific, just an attempt to give numbers to
my subjective feeling that "when we set memory.high on the thrashing
process the system gets a lot more responsive." Of course that outcome
is not surprising, but having a daemon that will adaptively set
memory.high when needed to make it happen seems useful to me.

I would also very much like to get the "thrashing+destressd" numbers
down so they're more similar to the unthrashing case. I probably will
keep working, seeing if there's a way of better containing the
thrashing cgroup so that the interactive stuff just works similarly
to how it does if the system's not loaded. But that up there is
the performance right now with the current approach.

Thoughts? Feedback? I saw a talk where
the idea of limiting memory.high was briefly mentioned
(https://lpc.events/event/7/contributions/649/attachments/546/965/2020-lpc-=
resource-management.pdf),
and in the tool's README I list some prior art of similar approaches
that I was able to find, but I couldn't find much that's using this
specific memory.high limiting approach, and to me it seems like a good
way. But like I say I'm curious what the people who are in this space
think about it.

-Andrew

