Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37EFDE909AE
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 14:28:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CD8D6B0005; Tue, 17 Feb 2026 09:28:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A4A66B0089; Tue, 17 Feb 2026 09:28:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CE646B0092; Tue, 17 Feb 2026 09:28:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 47F9B6B0005
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 09:28:51 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ECF211A01C8
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 14:28:50 +0000 (UTC)
X-FDA: 84454180020.08.AC026DE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6FCB8C0008
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 14:28:49 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RuMk24za;
	spf=pass (imf28.hostedemail.com: domain of da.gomez@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=da.gomez@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771338529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=cYUs2auc6C0kBTkFHq1FeokAWnj17fVT6B2TpqeQr7k=;
	b=ASr3TW+AtHKXIMt8AG+CDfId4HoR9mRFkQy5tUOXxIpG3NITAo6ioHI6Y4kRHk4pE5oQBK
	mQ62vqiqkLzkU/x9mopWyKLCpYYEgD5yhzolFkh+8GTXZN3ydUqStj8R5vu6e1v/LiKy73
	5RlOFOYrP+Leu1Vw3o1ubhVCoYbPHwg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771338529; a=rsa-sha256;
	cv=none;
	b=vnYvTZzWkgsO06BPaXR2HT0MeYouYMgZBJ81cblCHzIje1Szw6h+qUeKbP/3NFx0QPPRe5
	RUgeSXYKjaKXu0CcKXoDX9f1enuaWpfFbjYd4BsdnJAV/rjHbVCYMntlgrIEuowAnRZzCq
	1+W1yP0YaQ7zAF03cSxakvIeJK+CW2M=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RuMk24za;
	spf=pass (imf28.hostedemail.com: domain of da.gomez@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=da.gomez@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C514361334;
	Tue, 17 Feb 2026 14:28:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 080D7C4CEF7;
	Tue, 17 Feb 2026 14:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771338528;
	bh=cYUs2auc6C0kBTkFHq1FeokAWnj17fVT6B2TpqeQr7k=;
	h=Date:From:To:Cc:Subject:From;
	b=RuMk24zaAcqDwru/HUUW+6TSzAdx7swBdMy/utqMtqqbdhhwJqRvuoyqseacdXfoU
	 Dyi7yE6btONYnJt2F/y4KN4Wyo6130aozcR5OMIPpB1mT0hxIbpCz1pQesUmyHYNvD
	 nO6sODi7Qf6oID8ZVrVj3Bd3BkcYPZdOx0RggoRKVTMSAgipFyUQ/q3099L1m2UJTJ
	 zhBdBAaCPW2SbBms5qkXUt69IvGeO1k/OznpnapkVjoma1gTl37ZnarzluOA7PPnc1
	 nj4dqU2V64AX26ygFj7KC24BQ9ulUXErtVrzZdBYuPVHYc0qGkn7N+DuGcAoPoIayq
	 VIFtoCGDsOKHw==
Date: Tue, 17 Feb 2026 15:28:45 +0100
From: Daniel Gomez <da.gomez@kernel.org>
To: linux-mm@kvack.org, lsf-pc@lists.linux-foundation.org
Cc: Alice Ryhl <aliceryhl@google.com>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Daniel Gomez <da.gomez@kernel.org>, Daniel Gomez <da.gomez@samsung.com>, gost.dev@samsung.com, 
	Greg KH <gregkh@linuxfoundation.org>, Julia Lawall <julia.lawall@inria.fr>, 
	Kairui Song <kasong@tencent.com>, Luis Chamberlain <mcgrof@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Miguel Ojeda <ojeda@kernel.org>, rust-for-linux@vger.kernel.org, 
	Tamir Duberstein <tamird@gmail.com>
Subject: [LSF/MM/BPF TOPIC] Evaluating Rust for XArray
Message-ID: <aZRncP-sKLLS2K1U@macos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 6FCB8C0008
X-Stat-Signature: 5raq4m6g7pdhfiortzxf93ut1zddqcjr
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771338529-560558
X-HE-Meta: U2FsdGVkX18jCHNP1/Zmsa2i/sssnU1LhdpK+3WtB4qQkRtzSWfId6DB+ybsbp5z3ZoJsglcq1e9ae4Pj8P+I98PVfJOYiJ8Cxh4wvVcl29em+6Tu3w3cqzHKMPEx3xoN2RvW7ucYs9TL9Kb2HZzPpvCtxaK7gSqIVIuG46Saio4WzRha94urTCy05VxdYuPFo7z1/V1IFmp83b/+pC3g3UJlOWLsz2D1bIPsDVE/4PT0hl4BQYP288MA9Tksp+1buS+WDfsBDkWr3ObrkIsd8DcY4EzWIOSZWX5XRR2onWcC3Dl7BSW19xrvy0Lm6bv3GTBwyV71N2MpoU5uFT8QfsAPQg1xYwgbKMVrw3zEPZAioicpTSmwdT/1d+b+uikcJEyGSAmkz+LNSosfOqGm2fFn8QiazZ0lqGHqkS9YNjEaiVMTwxFcxy1fC6FCDupycx7LfAydITlm0ugI1kcTO6qw8SJJSEpJO/r+03UI2YNcxJ6Fn/KLFfkanzhm6e5LgjweZjiZYY13pfPll9GuASMxapj+EJ79iR+T5LnPi6QLLWQ5rnieoZq+5fLD2ArjD6BQOlC8buSh7wHIhTb+pekw7OzeYMaIvr2ShPAoHWjf3eVGhcYSWHktTPREGKkhZjbqWXOceBH+dOp7tE0AdAFWUK0LVcTr7z1UQXgXFI6MKLUmxKq+ClQ+LnAdhAvF73Ni1TJ1l5Pai/ylUWXDYGS5ZoR/NuxvGYSDD1TNB9rsmORkkzXM2IzlmMhpatEEWdN6wQsnuigPgln/ulPja4BX5Z4TRtzT7jmhD8tTT+SmwKWdlYWYCN60aWLMiAaZOi5P8aQ8zJBvumf7y0xwShQUQj+Gt4hPrbDa3pFzKOIBiP1CZfeQ0xpW16AadkGjGmBRl4FL/VXUPSruJOXJl5sS4EtFYDI9iY8YfIXNYSghWYfZs//+VO5L4ZvCpIuTjNnQPhHDnk88RSBlPh
 bT8tOsyP
 MHlBHHTLwuZlLAAOvQ6wm0YKsfgYiLUi2p3Mb7tnGhCZKYqFvObCOzwxFlu8WqO/8rAc82bhHZX//Lu1EvFrpFmNI/ZnU56PkO/rrWdC8tg2RRWTfExJNCOr+LuJStbn3XmpVpDtN2Dbqsa8KP7ENjpcs7dI2o1KgehMBi6H3Zcd7E6uJv3wGFRfv2YMBDTHaCB942KVKOJeOJL85mEl+1BvuNCSkaHygBERFCe6/edu3bZ3UjqX5XuIVloukhbMMBrRaqukgKKdOlqx+KsHBJv5ugNDyPECsu8b/l0/e1qH+vXYgsuXx2MwQpjr8kyBAEEXS/tUUJYU9Bke8NBSKYIchQBLhRW9Dl2U/hyKnh0c1SBDbWemmvSl1CLbrnprXEHVwd6ze4w/IuU1y9M42pyZcrkrs3VG23lR5LexBpyx7drjjv0HI5JqDaXbx5MwNue1BLGv3qvt0DyCqxPjK5lHNlQgccFLKvUgD0tls7WstF18ukLQtCREgB2ArRxcoJHTKVOo7V11orpmqMcOozm/iR/14wsv0IAj4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We propose a topic to discuss the potential use of Rust in core Linux
kernel data structures.

The XArray unified the kernel's radix trees into one API back in v4.20
(2018). It sits under the page cache, block layer, filesystems, GPU
drivers, and dozens of other subsystems.

We looked at XArray bugs since 2018. About half are the usual suspects:
races, resource leaks, encoding and overflow mistakes. The kind of bugs
Greg says make up 60-80% of kernel security bugs [1]. Most of the rest
are complex logic bugs where Rust's type system may help but cannot
eliminate entirely.

The motivation for our interest in evaluating Rust for use in the XArray
started with a bug in mm/filemap.c that corrupted page cache data [2].
Consumer code called xa_get_order() without the lock, the tree changed,
and pages from wrong files ended up in the cache. No CVE was assigned
to this issue*, and no reproducer outside production existed before the
fix (a synthetic reproducer was only created [5][6] after the issue was
escalated). Kairui Song's refactoring and optimization patches [7][8][9]
happened to eliminate the issue.

In Rust, xa_get_order() would be a method on the lock guard. XArray
users would not be able to call it without holding the lock because
the type system would not let them. That does not help with the complex
logic bugs, but it eliminates the class of mistakes where the API is
used outside its required context.

We have a Rust XArray prototype that implements core operations designed
around Rust's ownership model. By the conference we aim to benchmark
it against tools/testing/radix-tree/ and use it to back the Rust null
block driver for A/B testing performance against the C implementation.
In the longer term, we plan to deploy the Rust implementation in the
page cache for A/B testing performance of generic workloads. We invite
the community to take a look at the code (when published), which at the
moment is rather simple as it only covers the core operations.

We know that Rust is not magic. The first kernel Rust CVE was a race
in an unsafe block where the safety comment was wrong [10]. However, we
believe that constraining potential memory safety issues to small unsafe
blocks provides a significant advantage over writing in C, where the
entire program text is to be considered one big unsafe block.

With Rust now part of the kernel's core infrastructure [11], we would
like to explore whether Rust is applicable for use in core MM data
structures. We invite the community to this exploration and we would
like to start the discussion. Specifically, we seek insights into:

 - Which workloads set the performance bar?
 - Would a type-safe API reduce consumer bugs, or would they just move
elsewhere?
 - Would rewriting core data structures introduce new, previously
unseen, bugs**?

*Under the Linux kernel CNA's CVE assignment policy, data corruption
issues do not meet the cve.org definition of a vulnerability and are
therefore not eligible for CVE assignment [3][4].

**Our thought: The existing test suite covers years of real edge cases.
A second implementation running against it is not just a rewrite, it is
differential testing.

Link: https://osskorea2025.sched.com/event/296sD/keynote-rust-in-the-linux-kernel-why-greg-kroah-hartman-linux-kernel-maintainer-and-fellow-the-linux-foundation [1]
Link: https://lore.kernel.org/all/A5A976CB-DB57-4513-A700-656580488AB6@flyingcircus.io [2]
Link: https://www.cve.org/ResourcesSupport/Glossary#glossaryVulnerability [3]
Link: http://www.kroah.com/log/blog/2026/02/16/linux-cve-assignment-process [4]
Link: https://lore.kernel.org/all/d4a1cca4-96b8-4692-81f0-81c512f55ccf@meta.com [5]
Link: https://lore.kernel.org/all/5bee194c-9cd3-47e7-919b-9f352441f855@kernel.dk [6]
Link: https://git.kernel.org/torvalds/c/de60fd8ddeda2 [7]
Link: https://git.kernel.org/torvalds/c/a4864671ca0bf [8]
Link: https://git.kernel.org/torvalds/c/6758c1128ceb4 [9]
Link: https://lore.kernel.org/all/2025121614-CVE-2025-68260-558d@gregkh [10]
Link: https://lore.kernel.org/all/20251213000042.23072-1-ojeda@kernel.org [11]

