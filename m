Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76776C43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 15:34:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34F8E6B00D8; Fri, 26 Jun 2026 11:34:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3266C6B00DA; Fri, 26 Jun 2026 11:34:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23BAD6B00DB; Fri, 26 Jun 2026 11:34:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D3C586B00D8
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:34:14 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5E9FBA04DB
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 15:34:14 +0000 (UTC)
X-FDA: 84922460028.25.59F0E9D
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8B6F7C0009
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 15:34:12 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=TwUXR5E9;
	spf=pass (imf22.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782488052;
	b=CS8YBQurfaqUZ4Pcw+bQ7HJNMzosNn0Jk8w/GphhkR5xBwAIO4y9YyvbC/OqASRXeEf31e
	jKjI3jt46iLCZwfyIDBwSS+9TuJOkOr4Pgg6e8DDbo+Ykol8YvoJbipqBDQ8aaPvfAiCSk
	qpMdsUJcfSqpIOxpr+Si1x075o0KxzQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782488052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f+riptiA6r5Y/PNxg2RAlIaqa1a8ryBQwwolMCsPfZU=;
	b=icClI51O6D+m9hdRZpFTcogr5UhGegNI82BLVc6pN9DJSX7vH/dApsL2GdKVWmdJzHFzz0
	+EiO6WJ1Y7x3EfKi3wjdFOdKs/P8jRfPoJ0Oh9opM/rao2fXaNTpgT7A92udWS/BWInMcU
	PseUV8DPck6apE84WkEx2qEj/msGF8Q=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=TwUXR5E9;
	spf=pass (imf22.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=f+riptiA6r5Y/PNxg2RAlIaqa1a8ryBQwwolMCsPfZU=; b=TwUXR5E9/K37R5jz0A2WuTPfbL
	Dsobixxr4sNOLkxi+2HZ1OCS7KvmFJOiRPVsi7kDxsSwVi7SvRQNaKIyJmxM7aCBJJDO05ZrhOmfr
	Tkq3TBZOMCS83htptyCNWALmAlvNRMCdD/N7ARfZ580aEZBBvGzRAI6y8zTn7o6nlp7JyJC4/RSEa
	G7UOu0m+8QjuQxsNwctvCZNfXs7YFtQVTIkTo2G6ROO2BzkTdypuldIS5yxWvPpWgv3YatDynbAi/
	g1A54zXsj24o9cp0JxIhSYZoC4G3WFKe3CObnfBee87VvkJSNPc1abUNIiV2IpM+d2MpntQdstXzH
	2PWsV1Yw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wd8Z5-0044Em-0f;
	Fri, 26 Jun 2026 15:33:59 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 26 Jun 2026 08:33:19 -0700
Subject: [PATCH v10 5/6] Documentation: document
 panic_on_unrecoverable_memory_failure sysctl
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260626-ecc_panic-v10-5-6dacb8ad024d@debian.org>
References: <20260626-ecc_panic-v10-0-6dacb8ad024d@debian.org>
In-Reply-To: <20260626-ecc_panic-v10-0-6dacb8ad024d@debian.org>
To: Miaohe Lin <linmiaohe@huawei.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, lance.yang@linux.dev, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 "Liam R. Howlett" <liam@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>, linux-trace-kernel@vger.kernel.org, 
 kernel-team@meta.com
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=4818; i=leitao@debian.org;
 h=from:subject:message-id; bh=msoDLvFqwsOJsYCzBq/Fp8NcqXTHSLhr0v0oqz9cZZ0=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqPpvFGxxyKT9/sgwOOS0p+wzSQP+2uxPNzEPhh
 B8C+2sz0neJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaj6bxQAKCRA1o5Of/Hh3
 bdfYD/9Q3Rl+4JzL2jM/faeOug7+fuPvmgpElU1400RuLNC0KARD/bUAd6RtRjjjCka/eLoHDwP
 aKRf6ZUyL0HzrTZ5xoP3yfrrFiM1OOXW33F24m5WViPF19uPOYQHRTcFWE3/gWFzUhd0MkapvIu
 bzH9CP5xaKBycNQrvdJ6ryToVS+DcYhGnu0SIA9eBQ1dYXl6//rKAJ75cW24T+Y/3Jph/Et1QEn
 K4Pplpm6urFSaiPabT64tvILB3guoQPj0MW0lu5r5TKvSLAJUZYNCsuGZ9CFxMYfQ+lE0615NGT
 jh+Y5GlMyBH2/OUYd3yywqV927hh1pkA10nAzxdRSsSXXYL0I1hpk8UoZDX/6XGvjQRTKFNY305
 0crU4ZE+7gxzwuIipO0HirQI1j3lvYOxRaLMptDwa/CD6id8/kj5cH+B4tgV78LLWBbypkbf2mm
 mVoXZaiJMP8p0LdebVWsUvszcOAOXElEW4WFRy/BnxR0sNPzJpZ1iBnlf5kkXBJoQxUd1zf9rsq
 IyZifZaNUDQpGhNdeoCPrK+z7ZGsY3tV3moKC3/81tPAoShFSjmXW/ZAbq+LcmM+qn+uqs0Y4dC
 lYvGy1Z9oYkWg9sjW3A4BRWg+m21JYo3ca7BSt0OSWGGtfD6ugSzqHl9eCwTeNn6oOCtlLLmuGx
 yVpTpqOz7c9NtIw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8B6F7C0009
X-Rspam-User: 
X-Stat-Signature: 994x4x47xb16jgxnoxppxskqp1m3scz6
X-HE-Tag: 1782488052-886617
X-HE-Meta: U2FsdGVkX18aFvmwuQeKIjA42qdDi1KXPIyHQ6fGLoeEmKzfOmTVS37I4PJr7Dy4Ek48+GtyLWIa7t+K2Gak7tRXdlc90JLja12ThZ88vgJBCPwe5LfPBXVB75sn4qobmKCVE1uCOUx45zLesgPIgEHKHvZlaHmosXeKgmBRYxNG5oGfvOnDjmvwe3i9o5dELsY7eiVBq7S5L2y5ssg3S5XsiG65upeZE93Vatq7N5MpJcq3MdKoePg75J295gqbeDLiKw2y13I00j5BD1iw4GBJ0muiqAP0Fe3JVqx7QrgO9dUJP1CR7ip0b+cr7slVqwVZuI4pA0OTUoWFlRgGhdqr7GpYeZzwbTzhU3EHhX8P337JBvP3XaG1gDIdmsoLjkbx5o0DPgiGH2wV2t9MVhhFzJRTk8qVT/QkB3fuZYYBOBdI6rrg5vq5DkjE3DId8s4dLuecSYcmHxwqAn4/vb4e8rxu5GPNNGurDCPhLBL9NnTTDYajT+rVJRKFxEsfAPAxnVQfXxOBksMobXnilA9OlTDiwBXdZZKkNulcAc8Qgo/eMI5EQHNkNWyNFRrmnKzFO0xhPTW6ST04j10lGvvHsOSAaYlB/nAhiyQwCTmEv5vEfgKBouuXnaN045L8IBuudgA9c9sY7+O/tUaIuv+PppAzUvJz5fMuW6Bv4xVNpCNI+4dTibKqE6/F1FS5++tGdfHD4obgkLlHvwQV4ZWvLjAp5/OAnpa4xO/oJPGGBqLbjWR2B3fgeZcx6ifMSwVn8hXPnSBMVn5ngf4Qqvb9HbLIIwLn5xuuIe6GtBIlid7GEywCTUmfo6FeaBHXOCnHRtrIpWtSLK9U5xCL5rwxHAdTdX+k8c5H8PktV2hZMuzT0E9qSzJDRMBqTzXK4EQ5gT6f6EjQgNNd83oKSKJbWRuTtvxLhSms5nBP3FOLcOAsXWcf8t5NB6qaaGs6BU3EVCctAZfcfphgW+T
 y/fQe6CO
 HRTqVfxyQr9ow8YeRL7nOwECKqyhKvWW3z8SAKXtLJbyC1ziyS4nk0/EFPjKdz0duYSr3EPvj6PoEn7m9KboQr4CoUHznZfaIJETAwwBEaumZggBiqhCF5k3Ex4Tfcikj8HXE9AgRbE/3l2MDWwt/3IE5dkhFU9dyvsRpiYD+qQGh0sQ7sd8t0tul8JpIXjerMgi08NDcr+gfSwy1ZWDDRtAb32KSiHIj/JImncl94BAkO/a1rEeKkb8Yn/didI111BfbgAPTlEGeEvpMFMrjGujhB1uQr/bFIf88PFWBomSDkuXNBaPOjsg9e6QxjFODCCM0PuIMn+ZL42uVK7XZkJqqH57/BgBLo+zqbBCj8bemyX2fhP/R1A9s/hzroHtDeATvXxLDpqsiSwsIhot6U9xAgQAQ8D1STzrkbvfXlniHCJZkNGixZjHIPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add documentation for the new vm.panic_on_unrecoverable_memory_failure
sysctl, describing which failures trigger a panic (kernel-owned pages
the handler cannot recover) and which are intentionally left out
(transient allocator races and unclassified pages).

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 Documentation/admin-guide/sysctl/vm.rst | 80 +++++++++++++++++++++++++++++++++
 1 file changed, 80 insertions(+)

diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
index b9b0c218bfb44..22cc54cac3b21 100644
--- a/Documentation/admin-guide/sysctl/vm.rst
+++ b/Documentation/admin-guide/sysctl/vm.rst
@@ -67,6 +67,7 @@ Currently, these files are in /proc/sys/vm:
 - page-cluster
 - page_lock_unfairness
 - panic_on_oom
+- panic_on_unrecoverable_memory_failure
 - percpu_pagelist_high_fraction
 - stat_interval
 - stat_refresh
@@ -925,6 +926,85 @@ panic_on_oom=2+kdump gives you very strong tool to investigate
 why oom happens. You can get snapshot.
 
 
+panic_on_unrecoverable_memory_failure
+======================================
+
+When a hardware memory error (e.g. multi-bit ECC) hits a kernel page
+that cannot be recovered by the memory failure handler, the default
+behaviour is to ignore the error and continue operation.  This is
+dangerous because the corrupted data remains accessible to the kernel,
+risking silent data corruption or a delayed crash when the poisoned
+memory is next accessed.
+
+When enabled, this sysctl triggers a panic on memory failure events
+hitting kernel-owned pages that the handler cannot recover:
+``PageReserved`` (firmware reservations, kernel image, vDSO, zero
+page, and similar memblock-reserved regions), ``PageSlab``,
+``PageTable``, and ``PageLargeKmalloc``.  These are owned by the
+kernel and the memory failure handler cannot reliably evict their
+contents.
+
+Other unrecoverable kernel-owned populations (vmalloc allocations,
+kernel stack pages, ...) are not currently covered because the
+handler has no page-type signal that distinguishes them from a
+userspace folio temporarily off the LRU during migration or
+compaction.  Such pages still go through the standard
+MF_MSG_GET_HWPOISON path: ``PG_hwpoison`` is set on them and a
+delayed crash on the next access remains possible.  Coverage may
+grow as the handler gains stronger kernel-ownership signals.
+
+Recoverable failure paths are also intentionally left out: in-flight
+buddy allocations and other transient races with the page allocator
+can reach the same diagnostic, and panicking on them would risk
+killing the box for a page destined for userspace where the standard
+SIGBUS recovery path applies.  Pages whose state could not be
+classified at all are not covered either, since an unknown state is
+not a sound basis for a panic decision.
+
+For many environments it is preferable to panic immediately with a clean
+crash dump that captures the original error context, rather than to
+continue and face a random crash later whose cause is difficult to
+diagnose.
+
+Use cases
+---------
+
+This option is most useful in environments where unattributed crashes
+are expensive to debug or where data integrity must take precedence
+over availability:
+
+* Large fleets, where multi-bit ECC errors on kernel pages are observed
+  regularly and post-mortem analysis of an unrelated downstream crash
+  (often seconds to minutes after the original error) consumes
+  significant engineering effort.
+
+* Systems configured with kdump, where panicking at the moment of the
+  hardware error produces a vmcore that still contains the faulting
+  address, the affected page state, and the originating MCE/GHES
+  record — context that is typically lost by the time a delayed crash
+  occurs.
+
+* High-availability clusters that rely on fast, deterministic node
+  failure for failover, and prefer an immediate panic over silent data
+  corruption propagating to replicas or persistent storage.
+
+* Kernel and platform developers reproducing hwpoison issues with
+  tools such as ``mce-inject`` or error-injection debugfs interfaces,
+  where panicking on the unrecoverable path makes regressions
+  immediately visible instead of surfacing as later, unrelated
+  failures.
+
+= =====================================================================
+0 Try to continue operation (default).
+1 Panic immediately.  If the ``panic`` sysctl is also non-zero then the
+  machine will be rebooted.
+= =====================================================================
+
+Example::
+
+     echo 1 > /proc/sys/vm/panic_on_unrecoverable_memory_failure
+
+
 percpu_pagelist_high_fraction
 =============================
 

-- 
2.53.0-Meta


