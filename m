Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08EB7CD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 15:39:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70D226B00E0; Mon, 11 May 2026 11:39:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BD656B00E1; Mon, 11 May 2026 11:39:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 585156B00E2; Mon, 11 May 2026 11:39:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4728C6B00E0
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:39:52 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E80A21201C1
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:39:51 +0000 (UTC)
X-FDA: 84755549382.18.F5A3E20
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf12.hostedemail.com (Postfix) with ESMTP id 16FBF40005
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:39:49 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=wHpPbeXo;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf12.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778513990; a=rsa-sha256;
	cv=none;
	b=Wm2KX/zyhHpEAawp8h5PSmCfgHXdYpi2ditS6n6Izu8Iu+/bcsS5ol1Rs+Mo0NuPxb6arK
	6iQA4Ar9m8Jsx8wAeBsUM/GpA9LWSDUufGt+JonXeCNMd+/HqTWqf/j6/wbzsANJYyPwlQ
	JT04gZu9bzAUIxY2jMV/IEhDkl4UdFU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=wHpPbeXo;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf12.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778513990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C+tCS04YBf4yWLUQhQUZajCDPpB2s5wPhqtGUXXQBCg=;
	b=4g2uOcjK0e7yC673kBH4+pZHVMA4cHIKKMvyjLaZrQH2q3DGxEr0a1FpEpVPsJY82aZM4j
	OO8JqJDT1urifOeAtaGDSsBoN4TwEL+YZ2QNeiPquaG65Fgq0IZrgWK886be0FeL6ecQCJ
	egXCnGeGytsm4zEr7HZjpCUVi41Zl4Q=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=C+tCS04YBf4yWLUQhQUZajCDPpB2s5wPhqtGUXXQBCg=; b=wHpPbeXoMK5MT1JH7k3UWAIHXT
	YPhq7Iw77BUECX985/6TGJ3de5iiLXQETl29UH4yo9QyzbhHFF3vL75PGK2h5+vNAzZa8dmfx9fro
	/F75vzIx3aP1KX/3AoJJ0mDB8HdZ/Bv5fyu82u6M7NxvBIGURg3ucKJiwiwtMa1j9NWU+9fFvAjEo
	jSi+muMc+aodWrzb84/a4beXBV+F0vGCL6p2NR/0Hp8S497GKSJdAwz3moLL2hR+JsFb17zgKLw0V
	QKhyOUzgJ6F0BBNA6KTPNdSbyr8ULW9j59BLU5MxdLmn8Yq5RcqCCfMXCqr5eYdgLY9EmoMDsPDw6
	mThJA90Q==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wMSjO-001hVi-1k;
	Mon, 11 May 2026 15:39:42 +0000
From: Breno Leitao <leitao@debian.org>
Date: Mon, 11 May 2026 08:38:38 -0700
Subject: [PATCH v6 4/4] Documentation: document
 panic_on_unrecoverable_memory_failure sysctl
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260511-ecc_panic-v6-4-183012ba7d4b@debian.org>
References: <20260511-ecc_panic-v6-0-183012ba7d4b@debian.org>
In-Reply-To: <20260511-ecc_panic-v6-0-183012ba7d4b@debian.org>
To: Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 "Liam R. Howlett" <liam@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>, linux-trace-kernel@vger.kernel.org, 
 kernel-team@meta.com
X-Mailer: b4 0.16-dev-d5d98
X-Developer-Signature: v=1; a=openpgp-sha256; l=4250; i=leitao@debian.org;
 h=from:subject:message-id; bh=Q+ABac2nobHr/s0/5BCHnN9Y3bSYo92z/wSIvYBKopg=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqAfggExFOzTNiSrshYAhWzivg+fyoMl0UHn1Ol
 k/baPddoo2JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCagH4IAAKCRA1o5Of/Hh3
 bSYoD/9wpkfhqpU3NW837qbyKkH5PtTXq/mLXGB9M/kyPbi/lbjrhtclHCid5vxa0hjuNNXSWM+
 rjYPOBkE5+yr3G3fvTQ6x0ilNHObfL/mIlrbudRUeyD/AdWO5Py0u3BGlXS7EmgKsUNhNRCydwq
 LLUKeo9F6zk1uaTsdttH0fH0whh1OUIfSYawJwMN3yhybIyoiiPyZM8LpodWjJPgIKE8X37wKMK
 CU0IrV9EqhOo+5Xpdp+TSi1YNJm4WPqt25g1p6GcP8Bv9+JNsKl9nFzfJxJ67nY3Yb8580z5kQy
 FjbsK7ev9NciRGRpptWMCCe3Jct0m8nm6gqTJvNXpHMrh5UfX7woZ3NpkmP4+dIZvVFWGQe7sqo
 RiFoPB7UxxevtzgkBglm6ac8kqQ6dAqfbPWAxSmwJ7U/B72jONwFccgvj/DgSXWWNNES3Avc8IL
 FBGIWQmkD4Yht6YtpDvz5pTgVibcRT0mopLbGxZel8PGK+8ROneMoK0pv+94JcDcYCZkOHj7RHy
 477VvpdIPxBxaj3ew8chVn1yvFb0wApmgnpR2vwwungePtd8UTo5o8jFebr7PrDUGGyiTvcytUz
 TMUHDk09qF+spb7VnVYTx/nEkoOi7NucFih/niGo88XheO1J6daCVgLpFrSBdydI88Y8HJBgw4Y
 d+Rhi92mvN4p4Jw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Stat-Signature: cuifpi9fpdi6dipxf6sq1ndd8x7hmpmq
X-Rspam-User: 
X-Rspamd-Queue-Id: 16FBF40005
X-Rspamd-Server: rspam07
X-HE-Tag: 1778513989-938297
X-HE-Meta: U2FsdGVkX1/lHOOhWxZwagf5ivV5PabzEqoESCaLjyFygFA/nXDvY/HwcWMd/71ouh7IOdhTahsDn7/64fubBXHrj9oPe34YLHAxLHhcjdMoqAtJfAqI4hJayuIftI59G/fkyyO3ZcXcXRMacKn1YyxY/ndEdJdRlN7hWf8y+HTe0EZ56imDcVnmq6OZ1aBo99qykb4uDMQgX8sGqgHFFoKpIAUTI7pTp0x3HnTu5cLbJ1gTVhw1C8OxVHqmOl72W/ancjs99juo+9y+szJHPtq3PFyEwwTLuMzBsGJWm8LcmgIdfCvU+cGME8VzDWLoLQp/VomJySSZQ/jBGKCoXUW55wRbuOTZo6sXzCUt0BvvaSu7wM7X+V9tm+BMG7ZZ/J5eBBEgCCpLdusXxLNgUp1hSjhqLm5I4R/stYDlT4bqQlkYLkrVJRqPBc2WXNa1DUxbM/Ar3jvK1wPjA1bdoyVCw3bmardhI0Wg8YzM/5ieTTnzYdHnc2K2ePbns2mXcmodykknaUL/GPmh43mim++Z+vINecyolvMBEdYUdJM92aOk9KpofphZJimfm07On3MvGHTQUOofnU4tX7PXkCraWiJL4Z3o6kzUQDrm2CDV6olLX9BuXJJlIeBB73aOoCkIGgI6H1iOOhhx0cU8w7RkytASULjjXoEgARFLvHLFsVEKyyMizwqv32UIn9Es4r7XKF0DQRSttNN7MHV/haaiNnbLZqSnp3F0rCZdr6GoGhOndUmAdKTLh7hCKoRiW2Nmj9Cd2Mkdz0Cd6oJnqJzZsL/3Tznuz84AXOzhbYJxiuh07snkw0lKNU3T/LFLaHifzHPe6hHYxCiMxUkKmhpbXVSqGUfO42zv71IC09g5GuKnufdFRedC9Z/mTnpBy/G43rALr9F9/TuJrGIacwjdXyqwUKju0XDCtLmwwMJ8gy4QY53gukvwf2M6Ig3dr6s5bbAjgFX8mLNk/rp
 kRvwmMGV
 ESrtomtzj5GV95egivcXoG9u5s1qxSCxWdJsZEoZP4hozyjmQwxVISYaH8fX/e1UdfQDbGicvxN5qHmpm7QlLdOhbGZZQtxgEmVxpvErRIhQamIdoY3YZ/Wie1L8PQpLPtpUDr6qB/qhCtOl+Upz6FMtJt/9nwBriJwCYCrDZiifNyk5J/9vQRo0vK7KIQxu9XLG4VLFb1ZRf7vC66gjI9QC5WMa7Z4jm+ROfvYwhqXIeT1P/D7I5UDDzcNUPhy3vXh71nXh2KxbhcZ+N6UzSNYAt8m+X4zvlyOZTFtFz825qJCHdhQiaf8Bd4mzHIotqri9YLe8Hg2Ov3wxtyPzbpJqvMKzFKQp9AU31LG+qSl/PXO2VXTc0P0pz16ii3UvVFK6L
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
 Documentation/admin-guide/sysctl/vm.rst | 70 +++++++++++++++++++++++++++++++++
 1 file changed, 70 insertions(+)

diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
index 97e12359775c9..802c51ba8c43b 100644
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
@@ -925,6 +926,75 @@ panic_on_oom=2+kdump gives you very strong tool to investigate
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
+When enabled, this sysctl triggers a panic on kernel-owned pages that
+the memory failure handler cannot recover: reserved pages
+(``PageReserved``) and stable kernel pages that hwpoison cannot handle
+(slab, vmalloc, page tables, kernel stacks, and similar non-LRU,
+non-buddy pages).
+
+Other failure paths are intentionally left out because they can be
+reached by transient races with the page allocator (an in-flight
+buddy allocation has refcount 0 and is no longer on the buddy free
+list, briefly), and panicking on them would risk killing the box for
+a page that was actually destined for userspace where the standard
+SIGBUS recovery path applies. Pages whose state could not be
+classified at all are also not covered, since an unknown state is
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


