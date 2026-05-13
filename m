Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EDB3CD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 15:40:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5AC16B00D1; Wed, 13 May 2026 11:40:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0B056B00D2; Wed, 13 May 2026 11:40:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F9EF6B00D3; Wed, 13 May 2026 11:40:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 79D096B00D1
	for <linux-mm@kvack.org>; Wed, 13 May 2026 11:40:26 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1F38CC04E6
	for <linux-mm@kvack.org>; Wed, 13 May 2026 15:40:26 +0000 (UTC)
X-FDA: 84762808452.21.50BAECD
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1DC6F40013
	for <linux-mm@kvack.org>; Wed, 13 May 2026 15:40:23 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="MUz/a7yD";
	spf=pass (imf12.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778686824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ps5zJ4kvCPWwzd5UeBW/t615zOIlJIp4XGX6hA3qpRU=;
	b=BgK4LRf9NWyphdOU/3o+D9/N1c5N4Iz4OA7ioyJu/oZpE58GqjeZ7thGGG/stdOcOxDS4W
	M2RVVG2x2EE4uEcfjPD/9WowkZrQaOfOxpBrgdwWEkNMNMGFJs8yCxFEvnJ6OKCewhMC7k
	eBeKJo1KTnf7qeeN0JbHzxgXhwrmHsk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="MUz/a7yD";
	spf=pass (imf12.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778686824; a=rsa-sha256;
	cv=none;
	b=6m8XxbqsYLYSr++hXLuZ6mJRwiOaveWJcWi+v4NjdovSMQQA4B+r18sCv8KY+VMZUOZFiF
	08aLsp3MwdZUR7nJAMUljzvvXNMNjNcvdGTE/hDmvPg3TFs1K4K+4K6FIcqlSxh3RAAfAH
	eKxrM41+4UfltwYlLdMuiuARXeDuB7I=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=ps5zJ4kvCPWwzd5UeBW/t615zOIlJIp4XGX6hA3qpRU=; b=MUz/a7yDPF3GUlgcn3qxI3gfXO
	vu0GqHwaV/Mb1bW82IvzWEIXuz1AjC5Kf2hZQhhXHM7cK/WFxIui/Cd+LceT7+B4TWxlF/y5O2o5V
	Ynyr/q5CC229E0JpqG/ofuV5CPL8tKnbhLV2UojmrnwyGZx02U7HgRK0SZ/4U98R3CXLsTObxtF4Q
	8gPvehCcyeFI3RKI/DNCXG0nWLf2F803eE4PF4ug8dR562+Lae3fObfrgDoKgeS865C3f7su0x3tF
	DcDiLzTDw+HtJoxbAfkmpsusVnu8fI4Q/dYZoRN+va/uuESIhOwGl2i00Uv6IslMYqXmaHSgP6ynC
	jDONS5zA==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wNBh5-003GVI-14;
	Wed, 13 May 2026 15:40:19 +0000
From: Breno Leitao <leitao@debian.org>
Date: Wed, 13 May 2026 08:39:37 -0700
Subject: [PATCH v7 6/6] Documentation: document
 panic_on_unrecoverable_memory_failure sysctl
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260513-ecc_panic-v7-6-be2e578e61da@debian.org>
References: <20260513-ecc_panic-v7-0-be2e578e61da@debian.org>
In-Reply-To: <20260513-ecc_panic-v7-0-be2e578e61da@debian.org>
To: Miaohe Lin <linmiaohe@huawei.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, 
 "Liam R. Howlett" <liam@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>, linux-trace-kernel@vger.kernel.org, 
 kernel-team@meta.com
X-Mailer: b4 0.16-dev-d5d98
X-Developer-Signature: v=1; a=openpgp-sha256; l=4856; i=leitao@debian.org;
 h=from:subject:message-id; bh=ncCft6wLVNRyu8CqP+C5ij+1shPAevwH/Ny4XjCyHOI=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqBJs7zoPgDDOGBYZIRWE5RwFBx84GbKDJ1RbfP
 mV5jtA91a2JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCagSbOwAKCRA1o5Of/Hh3
 bZu2D/4gM6SMB3HsM1fzjJLPFg/Qj+o9TLUGhGX0U4PAr4DLJAFnRYhnbWfSnD6iqxo/aGpRGyp
 A4uC+3akefYTn2jttKvwNwQTz3K/dMC2u/ygdomRYAEJCzqah7oozi71XW7BJxV7GEzGuyggiDR
 nY1mzqHCNUC1/iWJB9Ptq5b+6tbCikpyCb5F9wQbk3B4tN9/g47cKcav0BJDax+dn15Pujh4laM
 y98k0W0fSNwDrJQySnNMOYZy0vraHPxo/gUc2EPLzOSEI8+RWGd3yuAmG4eK8PZrVG3Le/4e6to
 LzEAxARG4wZz1tvDYTNJegKeLJa8JYZPpHOgRE3WfYEreS76cQ2/4yujfr28kHniGRtDp+dU5O0
 NHSJZTDB8MdO9wLjHpCmaanq0Sv+PCdxDX9llfKF57/gWSRPnRtJ/gmJaXNxdjjJjr77McAlIeI
 kW24yoCcw5pm7OTWQzM/Lh8UiJxWB8vI3ypt3TauIsmdojyATYMo7aUVL/GRSCQRFKxDZ2zy6Dz
 kRBbVBUj2QzfbkRmglwtI5hM4fxGA5JFyw+1+NGNI5e0MUJ+KIncw+XWiSiqMq1M2hNO+Vtxa2d
 l/gZCO7rSf4VOlydR7YnJkksXXBbj5lgIH68gjUg2h9McfRt8NUgNEHJT/Yn6cW4ncP+pC6u5DW
 pRlZ6VXaiL1vUrA==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1DC6F40013
X-Stat-Signature: wzyhdfj8gyjj3wercy1m36ww1a9c1665
X-HE-Tag: 1778686823-715597
X-HE-Meta: U2FsdGVkX194Y5McT3O5E3AiCvLfZ5GPT9IqGa62iyFBxUSf3oiARAwShgsUqbIS3+UJeFiPTC3JRdnkfxeYiDhWmU89hSZ0MYXzI2RIQHihIjWEyidfmp+cco/9DD1Om1VLfule68mFT3ruh4Efyv8f6i0+WUpHsVVKCoUERclQ2N8NmgRu/7yo80uQk8duWZtn7IFdGI9N0ZNLPl5Uo+YVbojSDDAVQmamvKDSQ14q5sJKDjRJiA/iNngrQcdEwO83z6KdG5PCNdnraTzwmauOPcJ25wRAgP4kK4TeO4uK2Zrk2hWDGniS0AO7gaAEegL/q4xz4kf6UuFIKaRTJ2hXMLdYIOS3HEEYYzUKFki1XJE2rzKmM0RSPxi47lpWIF4/6IN6aovl9bZqU60wvVz/Sq5nQcVofvlgPkl6szgUJU0YKF/CmiKK7nJ3sKGZEGh3oe5uR7TYeyK0J+0snKIarRp9avl4DiBtuiIt/nVqqlEmjGZMMV1bDBVXETC3IhWnXcAXjOSpZfpl503VpvjIG94oGyVTARvvVBsGN5ak2SNaqDLK7mlLAzgaYQl0ks5ksRHisWAfkrGZq7dGn2qYCErgpVdvxi1JSa1YOIprKrO9Aeco/o7YFUnCIWRxv5DWZyMqkNiyQBT8wbcm64RSHvrAtaqypWIxonHdnziKekvwpsMb3ZSi3JMA9JDJJnhiEPSg22zPjy+VYDJpgcMTO0Ug8YxLJQMpz2g0AltUOJJzrqp+8lEfk7rB0qGWrUgX6YaRTqARnjxgDyDvXdoUbMZaOcrdnW+9VmkHPf/hXyVk941Xx2Bs0hkimb8XL9bMjT/NpE/N1SBFuFbfYB3pQ+NYmL9q/XdxQ6Od0nvvTmiENVcvFsoJK9Ev0pLcUc7iqmGdo1lYV0nYB8SmvXln8LtMRiB/bwutL7aZ2HRiwiRNNR1Hy8STQVaRHdGBi3uzOD+kvHRUWaSIGZ6
 xoAmgc7l
 5JTIkYO22OZyEUz6nMB0AXYQdwTj/+u2ldeA750JIEHDtWVHGyZnG6HaQhL7Cj49Sfr7uPX7xvGS7VOB/vWIrja2WChFXqSZzfjKhgdKA9N2DFhNnaeTpyVdE8PXWcnpddxDX9BTJwgtv8v6jCDpCUOW4Gg4mwR4fV2xURyNW23y8C9KXQYu0HWra6yTFPIqCQ81Jqxd00qRJGpeoksIaFfBrhI3DNRCepNi7JAVOanpkDIbmLdwClCF8VFydYS40WFXF4ULXUKOOQSrRgjNK7FJkUJpkeM8dQzO4X01caKExiciQT5HV7aAOsPS0hLWaEYtvraPqIiJ1HHTTUlKX3rnAQiyoHpkGspLtwByIEW7SAGsa2+2l3QjLLn97B5rp45aK4CURrdGN7Rc=
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
index 97e12359775c9..452c2ab25b35e 100644
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
+hitting reserved (``PageReserved``) memory: firmware reservations,
+the kernel image, vDSO, the zero page, and similar memblock-reserved
+regions.  These are owned by the kernel, are not managed by the page
+allocator, and cannot be recovered by the memory failure handler.
+
+Other unrecoverable kernel-owned populations (slab, vmalloc, page
+tables, kernel stacks, ...) are not currently covered by this
+sysctl.  The handler cannot reliably distinguish them from a
+userspace folio temporarily off the LRU during migration or
+compaction, and the cost of a false-positive panic on a recoverable
+userspace page is too high.  Such pages still go through the
+standard MF_MSG_GET_HWPOISON path: ``PG_hwpoison`` is set on them
+and a delayed crash on the next access remains possible.  Coverage
+may grow in the future as the handler gains stronger
+kernel-ownership signals.
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


