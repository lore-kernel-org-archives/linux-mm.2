Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5013C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 12:47:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BA9B6B011F; Tue, 30 Jun 2026 08:47:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F8096B0121; Tue, 30 Jun 2026 08:47:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E7046B0122; Tue, 30 Jun 2026 08:47:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C91F06B011F
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 08:47:03 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 40F5814047B
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:47:03 +0000 (UTC)
X-FDA: 84936553926.11.7059864
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf01.hostedemail.com (Postfix) with ESMTP id 56F884000F
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:47:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=KwMU7BEG;
	spf=pass (imf01.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782823621;
	b=cprE1XMk2oxfkKuJJYhY3X47cxSZSpVjvJkwxhPJh5V5EXETPjKEgoA4aEh5Dbs7q9sNVK
	rr0r6uMfVIJwhiKdpMRSQ3kKcM8sSf2bMFSw/Vo14fgt4fb6ReglSgOkxLmimzHtxC2+MY
	j164pKPnrgQuF4wt8QpryDHXYLe5zXo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782823621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f+riptiA6r5Y/PNxg2RAlIaqa1a8ryBQwwolMCsPfZU=;
	b=Q5uvUwhd/wTocYvldxZLPMPtqKo/EuEnJuytPtDe7IXxYNhOMjisu8YPdQzhyXLM5pvxyd
	MgLIZs6ZD4W8soia8rv/mxkOq2OxAtG3oKMR/Q18vakMZKH2YR0EQ5SWmHyo/tNzxQGkjN
	JIaToeAUq2iyuuF8DNBu18Y0JjfkFZg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=KwMU7BEG;
	spf=pass (imf01.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=f+riptiA6r5Y/PNxg2RAlIaqa1a8ryBQwwolMCsPfZU=; b=KwMU7BEGKx5LbiKbuR1dZ57CKH
	u8HORcxkOwM5jFm1jTzvEw+4c8pW0/oePV9iRd2zfZ9+4n3wHLURKGNKgY+tMZHBK0i3lq29OLho+
	FqhnT3q5GVza4mW6j6hVFQ5XFuYxqDAp5s2qfEQrEgs+k4Z+wmRdr/lNtwOQn6uzwvjLxcAL9nDU3
	GUE3XwzHJwUxPlaTCCOGjBcq+ts1PCkzc/Sfe/FOxoxwp7x5D1GT1ayG2moU2AEPUX5CzHNcfzoNH
	Uzp4af40NqgtupD/mjt0Nszr/catUCIjXMDkuo/yWxea1xUXae4yAFnyAAeNeFm8Ir4dyseJp3bvC
	XyNGOOkQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1weXrc-0074c8-2N;
	Tue, 30 Jun 2026 12:46:57 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 30 Jun 2026 05:46:08 -0700
Subject: [PATCH v10 5/6] Documentation: document
 panic_on_unrecoverable_memory_failure sysctl
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260630-ecc_panic-v10-5-c6ed5b62eea2@debian.org>
References: <20260630-ecc_panic-v10-0-c6ed5b62eea2@debian.org>
In-Reply-To: <20260630-ecc_panic-v10-0-c6ed5b62eea2@debian.org>
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
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqQ7qdWBb3w3i9zonOzAZvixd8VOV1wwZ/UrYi1
 hP1CKN8MiKJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCakO6nQAKCRA1o5Of/Hh3
 bQ5MD/950PnBLjKhKhm7aPCbqFUb/DDS/bxhtNwErQfWcj/UkgqV/WR/1YLVbTfHXIR5CLaz3mr
 byD2Vnm6ihXfREfvV/gnQAVRc0mbVkeBCJTwlM5YHKiGOL2NLCUeRf72TbG0+N79u9LGWDgxyKK
 m8uzwA2unIggXCe96m22tMLWwt+2qpKJi2vFIoy8UkyjLK416VYsfZmJz/Fq8HRcXeitbVQrE8c
 wd9EJ/wpG4+8TSvqS7Xj9MPKaQBLrkk93wO+SrvP9MYq/1PtSKzPLYVi5JXievKDQBlsZ3e7Y+z
 LKEwjahzrdiHhlgpmzHfQhRnOlOvlMblHOBkp9otigeF2O66g0Q2FTiZjXncm5K/S16C4KpldiO
 ZNhsfB15QzfPWQOrrTL/S2n5cMEATlS8n4xBerHYn1+JfEZ+sNWcEohbVldotutHwW3cwoHuJsK
 /EelZZUvMc9asX0V7IGKt88idjJ8wEH85q5enPDeKKAJCEE+7+SIfWhLziIOpbiEAtH2joOt0Wu
 V2BjzQhzzRuu4D9UYbLGARfXpcy9g0PQAWyPaspq2fsx1GwMXHRufHjRIyNS1ZGIX3UTADqxmgq
 6AiQ460qgYgIQ8DcTtd0ETJhcTm4/XW6k+DDgue8OrtWbUTFZ2pBLDpc91HvOXKygCT0bBHk7gr
 BvAlyjmCeZnas7w==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Stat-Signature: cdq915dkn8fbnhzyxm91deapgnehh97j
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 56F884000F
X-HE-Tag: 1782823621-851190
X-HE-Meta: U2FsdGVkX18gAFxWz0Fr7PWSzspiR3v7NSi8Oz7xv6LUYSbChDpWu9l4txH41z2vH+ZeD3NIMikqMPttpQUcoVcLWj+aiXrk413fMRLcDoLuVr061meerjY/kk1HoUMib1mE8211Wfx6i39eMO5vmsrdet9aV/2JI0i5pMmF713/7eB5usCDCIomgZTO+p5XKFc9ZC7YV+1JzgvNhSqlQmyplEkCXdIw551A1PccWYX+BWikeBD3mQJRGfJrx68ezTlrYtAyC7egNMGq3iyoXloZ+hHCGXsh82U8mFw7v4av9w5Ig8DvSutzTULKxsMLdtJra3f7bMuf02ohiALGgOXW/EINwxWzvEYa1nRPmXqJNc3kNIdX25DRddhTyLzhK0RyI7/SqwQlUwyUn0URgccODuhi1N66ZHLnyRvCW3uKD9a4k/rh3djSabfonxQvfxGnzUs0PLG/olsvEwSY3HT3x66ML2k3P2xM8q6UGXJtARTZuv6a2tdbOq62Y+zKfGKD3pUgQXx70dAUICXulc8vTR9RS6p5RzqhU6Djd5U5qDaHsaCAievb+czWiS++rlowDwGGy0YIqGlH9mkwUjbUla1RLgkPUt+89K7x3kthKvVpAWk0OUvCkiuY/IWvpP4vSZiHSDTzWb9FL7w/QglofSLaAqlMHDeENwJaY3OjbcMrBBKpw4Si48NVvwzaTUBGyC8TxrcM6q7MdfOxcP4H8nUOHaasX66X7CPDbtTYcD8RD/WUnYPBBtxpWszbF60DW3bqfVWyoORnKJKetLN2AgZca2pSthfC4zzeNiZlENcUApXDvSYSNHRZbrcYHWc2630amiHwBr0BLYpdbqH0m5kq3iH46bLLwWHepfFfp257HxFHeqhT5GEz3YfzNMu7meCF0Ls9663VGjNCazhp5jjygmyH5KgaaW2JoWKoJ3Qmc35b7HiEJS2RgbxEv4Jztty1/tlgL8J20wW
 fkSLh4Tk
 +imlb74+i9wv2rJt9q1uYmr5ZYihap4NMU2klyvJ0ZDsb+C2UR+lw0eIkQuKQMKpUBPalqr3aeB48Byk8YEOqwoU69H5i/kTeK/mQfTAgZ6raYYxbdgTgY8dHlVpzx4J6nCEx4l9J/BF6vyVcsxsG8XEQ8Hcrt8MWU0wxGpfxLr19Ds9PCst2/JLKCnFNttqVIiTbHk05l9xbttKZR3pVwMCEHDLIjFkjuuQk8dcCa0fHfVJb3LToPxlQvjv0iifIgz44BzsNO+KLI4Lerw2uUzhlyFCrfp7sgSJBBhS5NdbYuJtiFGbj7zbQrhiWFMUiS9zjVqTc2PODGXpiCPWgcEbN3Wx9q97f/yTa/E8VLUu7V67yIigbjZ2t9ONTnsMZctQGnAmNpGu6gGZ28TPyp4WjXNHZRAn6llGPRDXrRMdMhLuJpNNFi5cvVg==
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


