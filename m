Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A759FED9EF
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 17:00:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1D6F6B00AE; Tue, 17 Mar 2026 13:00:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECE7F6B00B0; Tue, 17 Mar 2026 13:00:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0B616B00B1; Tue, 17 Mar 2026 13:00:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CB61A6B00AE
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 13:00:31 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9078B1A01AA
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 17:00:31 +0000 (UTC)
X-FDA: 84556168662.02.834BA0B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id B39CF4001B
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 17:00:29 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=uSCu+K+Q;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773766829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=TJuFDA5qoo3DB2g3huB9KyzMR7XwYpjSCu+KqagxvqQ=;
	b=X0SY795qvyolIPn5HI/BgldqoSxUyO7OUH5WbZO0qwhD0+50Jf7Wea45Y/BOXe3TbhrVKi
	0CWcWZo9vXWFNM/30IAiWJYjDeD5z62nh94C/PPMb+tpRIhIinO63JyTjl3DHWmR/vFcvU
	+ZTTSJJ+XjfxcTXS6mFCDR/4Cs1AUmM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=uSCu+K+Q;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773766829; a=rsa-sha256;
	cv=none;
	b=WDgqaiXliA1XyXvUQb1ktT6Dw4/6PuBFDMc56dnlE5u8sKAPl6wvOgOgJmaayHVjwykpm2
	bu9RPvPf4vEIXia/VgXtwo/IEz+7LElvN9w0Spk6z9hnkp+ysMc6MIzxkyswE5afCjjOyp
	BDggJ8GEQkIdGcgTxnPATknpmTcOTEY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 70AC043AE4
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 17:00:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 425ABC2BC86
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 17:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773766828;
	bh=lrUYSaOf0mhEwW+amKNSuh8ZA3IvZY7k5Ze0puQWmNo=;
	h=Date:From:To:Subject:From;
	b=uSCu+K+QTtY/6+xXg+DqCbUzorFVsvJebYSKoZ6ihqQk+0wD8E82j0ZWdlTXwu3sx
	 h5LXgkqpPPdr03rgIQP8az4VwdWNYirGPCkLGoY0BpGH9Fn66FmIyp2Gryfwb3E2Z0
	 lUsMd6SlkOP++M+hmXCjpLvuK/C8mdtUB3eNC4HA=
Date: Tue, 17 Mar 2026 10:00:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-mm@kvack.org
Subject: Fw: Introduce Sashiko (agentic review of Linux kernel changes)
Message-Id: <20260317100027.f650bb38d796d5023ad45878@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B39CF4001B
X-Rspamd-Server: rspam08
X-Stat-Signature: idzaafy4m7oud1i83d56tbn6iwua5mud
X-HE-Tag: 1773766829-134032
X-HE-Meta: U2FsdGVkX19f+WR0A2FPXgAj+VNkxViPp8y5hoIci1B02EOiL2a3TIcfDg9Rz/HdglETHM5Aq/htxHo2+4B5Lvx7srrEPdzEL7syCqbmHsEMEJQjxyVqcSXLbpRELG+0aQzQR48CoVKaAEHAbtT9kyKvno8SC3yggiZVkOsQVL502hOkMk+bq9E4xolUq7kKiHDMtOhCUwSN02KSaWLsFNCkAMBKg+FHtCDPtYw5k8DqEBzMDGKtnek262UodCSjE6kQ15PE1EEK4l5zBxtJsDfX6R3K4zzR0uel/VhXajZpHm8eMO68YGJsCT5IkegvhZ0uJAJOt+QtMYuWf4MxO27TPgrC93uaP7QO3RFRtXb1iKFpthrrnp2anOr6OqTurOTBkGF0kKCSXE8h4Qi4v3Zqnq+udYk29hwnPSyaiA6yABQQKa1wjZ8hnLV2GxWUf/9JH/PUJF1w7PDP89wG1BW9MJqKHE7T0pHjt0938tm34qU3QtFZHoOqsjahxKd5ai91CTiVfwhlQYmCwf4UDykPnrIKApEEAVNN9xX2HEPbficsetcIqY0QB2Bl9U1lS2uEpoCVWWkC6jC8VXxfj6ynUgfRCF/M1sqoZukhVqKUhFnoVHkBHCh5y1k3XVxNbnrXaIPBkFE86QDknFUgEwQiCotsPgH19dbTsTxddI2PzUp1xhqBbD0mmdmk7hh9QnTrdZSZYUUN9mBdZ5SrsX4bQE1ZndHlDuFg9jTychcQlVIyk2shNnL4zfmT6j1Huy3bsOyh5HFOSa1CSp4jJf14OIjzaN2y07+Ei6fygj1wwRTd5XvftbZszNXcYt7Hh5dPqWr0FoM/LPckQuCOpl7N8pn8Slx8deyFN3Ls8/j120UFtXx5GeCxb3Xqb2/XQWXo4QRv8PwqKlBu4MjP1F1+OVJ24/Ok3cTHmphuRecXNZ6Vt3qvWbhEYF1i3oEesRuHg1szPp4MnZfLM1K
 UO5lQjZd
 Ozp507Cto44Au8h1w5yT82I62Y2Nz3hflbZCeRmt9NPVMmkAxhBeICYjr1d0PQ8HNOmSQSFaYkB4OqzrWy0paeweo2AYQAtVebhFBOC0eUUFhFoZpM14k2PiKYYeX3apj+iyVVe93mqJpe6y7DZW+1aWDb8ISKvq7VqNCK4ZpdPQnVly36+ewTVntGLu8ohjRGWvkRRYJooCIf/qqadENfkAd4iIv+Q3ZVQh913aP2yfznhFQD9nKEEGbsCtOXBhhNw8WIEZiILK33wrFGO9Du9EUtF/SkpICEHJa/2OL0bjoo4BpqQF8Oy12RjM+bLyXPRh7VpgvSRjwJR3wrKeVWXFO/w28q4j1oJDG60Xbdho0FPfqp16XEgHjt7SSdGCRmQOskxJ8msQIi8qOYa/tKY//yOavzp48IVaJAsL6B+1h3K5R3yU7vWYhFjxkepLx8pGVcM6GLctlh106ajxxZWfyeOd6d2Xbr5pfOURw8UnahRazAn0Tb1fIFqdq0Z0pwOz/yn6hndf+NgFSnaBLS3hWMvdsuLJpG8vuWGkMFQJpa9kwtDsszwsHY7x99yEOYxRFPKHTth/th1+rbUTqhf4oXWnuPJWHBkFOuBCWhvLFvfPApC6HwXiX1htJr9dyh2dmMqewO7KlATyHD0PU9HCfO26flXM20mKYKkVEzpTsI677dEO1/97MZTJrElZ12tyh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

fyi..

I would like it if developers were able to privately sort things out
with Sashiko prior to sending their patches out, but that is
impractical - these things are expensive and the potential for abuse is
obvious.

I am keeping an eye on the website's feedback on linux-mm - it hasn't
been finding much at all lately.  I'll let people know if anything pops
up, so we don't all need to read it!


Begin forwarded message:

Date: Tue, 17 Mar 2026 15:31:11 +0000
From: Roman Gushchin <roman.gushchin@linux.dev>
To: linux-kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Theodore Ts'o <tytso@mit.edu>, Guenter Roeck <linux@roeck-us.net>, Konstantin Ryabitsev <konstantin@linuxfoundation.org>, Chris Mason <clm@meta.com>, SeongJae Park <sj@kernel.org>, elkin@google.com, Christian Brauner <brauner@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, Sasha Levin <sashal@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Sean Christopherson <seanjc@google.com>, Ian Rogers <irogers@google.com>
Subject: Introduce Sashiko (agentic review of Linux kernel changes)


Hello,

I'm happy to share something my colleagues and I have been working on
for the last several months:
Sashiko - an agentic system for Linux kernel changes.

First, Sashiko is available as a service at:
  * https://sashiko.dev

It reviews all patches sent to LKML and several other Linux kernel
mailing lists using the Gemini 3.1 Pro model.

I want to thank my employer, Google, for providing the ML compute
resources and infrastructure for making this project real.

Sashiko is written in Rust from scratch, mostly using Gemini CLI. It's
fully self-contained and does not rely on any CLI coding tools. It
supports various LLMs (at this moment mostly tested with Gemini
Pro/Flash and slightly with Claude).

And finally it's fully open-source:
  * https://github.com/sashiko-dev/sashiko

It's licensed under the Apache-2.0 License, and the ownership of the
project was transferred to the Linux Foundation. Contributions are
really welcome using DCO.

Sashiko is based on a set of open-source prompts initially developed by
Chris Mason:
  * https://github.com/masoncl/review-prompts/

But Sashiko leverages a different multi-stage review protocol, which
somewhat mimics the human review process and forces the LLM to look at
the proposed change from different angles.

In my measurement, Sashiko was able to find 53% of bugs based
on a completely unfiltered set of 1,000 recent upstream issues using
"Fixes:" tags (using Gemini 3.1 Pro). Some might say that 53% is not
that impressive, but 100% of these issues were missed by human reviewers.
Also, many of these issues (like tricky build failures, performance
problems, etc) are very hard/impossible to spot from reviewing the code,
so arguably 100% is not reachable. We started with low 30's a couple of
months ago; better models and improvements in the review protocol and
subsystem prompts pushed it to low 50's. With better LLMs and collective
effort on prompts we can push even further.

Measuring false positives is much harder, but based on manual reviews of
reviews, it's pretty good: it's rarely dead wrong, but sometimes it can
nitpick or find too many low-value issues. In many cases, it can be
improved with prompt engineering.

* What's next?

This is our first version and it's obviously not perfect. There is a
long list of fixes and improvements to make. Please, don't expect it to
be 100% reliable, even though we'll try hard to keep it up and running.
Please use github issues or email me any bug reports and feature
requests, or send PR's.

As of now, Sashiko only provides a web interface;
however, Konstantin Ryabitsev is already adding sashiko.dev support to b4,
and SeongJae Park is adding support to hkml.
That was really fast, thank you!

We're working on adding an email interface to Sashiko, and soon Sashiko
will be able to send out reviews over email - similar to what the bpf
subsystem already has. It will be opt-in by subsystem and will have options
to CC only the author of the patch, maintainers, volunteers, or send a
fully public reply. If you're a maintainer and have a strong preference
to get reviews over email, please let me know.

We also desperately need better benchmarks, especially when it comes to
false positives. Having a decent vetted set of officially perfect
commits can help with this.

Finally, some subsystems have a good prompts coverage and some don't. It
doesn't have to be lengthy documentation (and it might actually be
counter-productive), but having a small list of things to look at - some
high-level concepts which are hard to grasp from the code, etc. - can
help a lot with both bug discovery and false positives.

Thanks,
Roman

