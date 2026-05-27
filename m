Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC724CD5BD0
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 14:07:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E9626B00E4; Wed, 27 May 2026 10:07:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 199EA6B00E6; Wed, 27 May 2026 10:07:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D6B16B00E7; Wed, 27 May 2026 10:07:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F36A06B00E4
	for <linux-mm@kvack.org>; Wed, 27 May 2026 10:07:02 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7B7C4120593
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:07:02 +0000 (UTC)
X-FDA: 84813376284.16.D9981A0
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf27.hostedemail.com (Postfix) with ESMTP id A3B614000E
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:07:00 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=JHUaBSOJ;
	spf=pass (imf27.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779890820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qvNiDGBgEtWh04CKORYdnjbOWGHx4PFQRMc8UbqA0bc=;
	b=wftKR2xN81dvmfWDHZCH5ngyVgN7JcsSeU/uUxZcxWtEB8cjAnQufCKw58r1m1QzavCUE9
	y6LZFXOaXN/ynIqh/h1fuDC0/gtLSoYDK73Zp9JgC6Pt7GQ2sKwtbtot2AhYR+LmvQZnw0
	D1uW5W2VEEdcOIFIkoYEZ2G1eldmtCY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779890820; a=rsa-sha256;
	cv=none;
	b=tKfVosWMorhBV+6+O31Wd5grsinj0VUzrYjZoWHT3zsUZC55wztB/CzJSL6CBdxiSyfPOq
	9B6id69jFJ+O82mVCmWPQc2mBNiBtD1j7OCjrF3WKIbBYdiaqIV9l8khVg/UJpAZtWbJvo
	Zbe5UlMDH4q0/XhJSB0OvhDwlug5GLs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=JHUaBSOJ;
	spf=pass (imf27.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=qvNiDGBgEtWh04CKORYdnjbOWGHx4PFQRMc8UbqA0bc=; b=JHUaBSOJnq5vadUYwzmkHoaMjm
	1k53DUwYyVs12ddAPrAOBff7ga+He6A7EGRfQO2BZQn84C6hR3PyatneMWAHX6WBsy2rxzLMhhoT6
	p2+/dn7sshOf9yKbfvNjzmESoK/FaQ9FXOJDZ+GLMu4+4VFrVhfTJkMQNv1hB5lb+VqiFREGTkNLu
	pBYRwsfbX5Wt7d8lMVF3Ua0Obts18Yv8jOXl26BPM+sd5pfLJR+t+DbDtLO9Zq4xMw+m/U/8vM7sx
	bOkKl5OFqZU5bulJTJIeW/JerxVH6cE5xtV3kKxfYPr2laAhbHkId6x8pZ2PLp0A6SoLv8B2DgwEf
	ATUcNy2g==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wSEuM-003DTr-0H;
	Wed, 27 May 2026 14:06:54 +0000
From: Breno Leitao <leitao@debian.org>
Date: Wed, 27 May 2026 07:06:18 -0700
Subject: [PATCH v8 5/6] Documentation: document
 panic_on_unrecoverable_memory_failure sysctl
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260527-ecc_panic-v8-5-9ea0cfa16bb0@debian.org>
References: <20260527-ecc_panic-v8-0-9ea0cfa16bb0@debian.org>
In-Reply-To: <20260527-ecc_panic-v8-0-9ea0cfa16bb0@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5051; i=leitao@debian.org;
 h=from:subject:message-id; bh=B5KdTD7ZhP/7hHR5QHSstU2DTYx/6InnYGWHrgT3KG0=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqFvpbWFZ5tW+B7rNgwndjLhTSZaqZDyApt28GJ
 Z+2hgOzjLKJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCahb6WwAKCRA1o5Of/Hh3
 bcF1D/96nl3pHZvVsIHDOBSzXfwQzAgISt292m7aKGeL5wOoHLfNVNRDP/Qay3Zw8ihSmZ3SKhq
 eCtGDDDFkRK8DyONcMBfMNzcU10qbErfG4WjyHM6o8G0vrPAwDC0PD/7lHc2+JmsEadaFvww+XM
 /a8NP520hvDMj5SFWLtm6SLqzLvIoDLfy5Xuq29WYmniC/kGgBFhZ/AOHulYeBwUD/9rzcvmIwj
 RFNtYgjZ9sFtDVZ4qCM3BWaxuNtoZId2vtOhOK4Uz4q4+D+5kBItasimM6zOdGS5mea++lWcj0f
 baLqPbPYDyM1mV/Ll8+3kqjZSZmh9DyW//0FUVQAGKFkH6lqVXx+C3t88ItZWnc/ULK+PvMqAa8
 qnRQxkc4RXfAjoDeIZrqro8Qk/HgJWt37VUlbMM2rziXTB70YS7yZNWFf1gn5um8U2YPuOqeMVH
 O+UxsbKgQA7K0qX4ZQH9HwI2+MG25WFZMXd0PUj7dEkmnKfTo79y4dsVIgDzuaLD3KLCz2hETY9
 Gdj6pWYpUvRsPFL8trBz7mnqNo3wY05zjlGAGglp3LZG+rJ5igsTHRWRuc6IpfmMSA/RXwxIC74
 k9cAj6ATDQ8kYFXomnrW7iWMIrt5eKqdCs1apuDfCNcqV25ZjgZ6cT5XDp0P/28x8DWsecAWbUn
 GG9y0sD0/WbbUEA==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam11
X-Stat-Signature: 59o5sxia8oyexkqpsaf7s3otca4wqz3t
X-Rspamd-Queue-Id: A3B614000E
X-Rspam-User: 
X-HE-Tag: 1779890820-949418
X-HE-Meta: U2FsdGVkX196DF7WhKSSwfGdAbcyTdQNJ4qQ1KRlU3ghMHHOpY4LLySrzRIxuug8DjGMVJNvV9W6QG5GpBYI3huXGOsAU8jMxIswSPMp+7vsno6DvHkqYWggw7QJALKipctVQFxjV9MCCAXMgz/30uVIh8Ugcf1NL4CHO6Q+w6x3PjzbsR5MV/Ha/vIXs1G9wnlc/WGtHf5es+CQ+TvvmGVDIpXTxab+j1s+wCB7VtcDuAjp7iXPveKT398U223UPkuUkSOGtMY80eAGBDGvE9ErUVAkFTXH+rW9JZltsIwgJHa4aCjLAkQOgbKfkqypSY1p5kOGx5DK5mBu2+Sz0yLO/9mPgZpKJwInws/Ju3o0elEM7n5H4I6Z1zocNKJ/odCDpYVIST6x9KQx8hU1STXa7L8wTFGm6Wr3oFSn41xRoeQCo1z7NrBylFyfAawNUarGoeHcjB82yg5v5uAp0ZRyrl6j/6mCPRhJXKwLq3wIjcWXTLI4ZmZ+DqYMq51pWwQmvew6R6twpQoS4Z5RPnExlgJYs5RDIWEwl5DYasxodxl1AGWCFzBtdBkM3jGd+LgwQPcV1CmSZiGVgGXjaA2+Ne8XpG18Mv2ZSNOLiC5rQD3WJ85+HAwUTtMhkpEpSYeWoVGVSZr5fD4basrl/kHaGqykfDtyRrrJ9Ac3B2G9pHhjZS+ZttrpFoWamxsaL4zoxgJjw148j6AztIJIlNA5k1IcLyNs4R4OLddaf7CvxWzOeTP5iaCWQuxIljsiCwKrX/GSQT7ouGLUzz3VCixKfUmdzn29omG4L7HmoAzl+d/ETdqDbDg/q1S0il0Iup2U6YRR7vQq/quK2FvfBxgSyUrD1Lm49ZwZjC/VFX/6iXnxll+BGVsGzsfr5cU7Eljzh6oC8k/lME8gdwMZW2W49VQyycraULJcZZGiuJ+pSupQVKThMdWZDOirz+6nNo6d0aHFrxsw3g6PfjH
 DPWMBQgh
 WgUZGkc3IPfWuHCc5MJ3Z9EywS8A7eR99NskXgmzregJeAPjfqrcBt+vgVHkwpHkCAobx8SeLMx3toeyFrdFh0nSX7DX9sdFwDm2qlhxwfv38FnZWNoGW7+1KMECP7/RhZ96Md32bsXmD7TG2d8IutX5sacscTqJ4ZngRXCvPjn9rw7joddjXi/Vicyn0ePV1Zd8lOXEbgJVycVNC8TbomPXiAJbc4g5jYD/kgkKmHs9eO6j67r9IB/jqqK0eNacJj99CPDV2Fbw80EQt73msGzjOG6PGE7fcrGtcLWjyK47sWxMb5BTt5aPzpXMBzFlG8vDdKTPR6UnYm/mj8aW0WTJ0wcCgu0cJhQZetao/m9LqKDUJQcb6xKEZ6m3EDhHQBU7w+0w4pKxjOFSckP7tYeqPVFakfBLdt+1Z+3CYCMmsCVI=
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
 Documentation/admin-guide/sysctl/vm.rst | 85 +++++++++++++++++++++++++++++++++
 1 file changed, 85 insertions(+)

diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
index 97e12359775c..f71d87039904 100644
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
@@ -925,6 +926,90 @@ panic_on_oom=2+kdump gives you very strong tool to investigate
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
+For soft offline (``madvise(MADV_SOFT_OFFLINE)``,
+``/sys/devices/system/memory/soft_offline_page``), pages owned by
+``movable_ops`` are exempted, since soft offline is allowed to
+migrate them even though they are not on the LRU.
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
2.54.0


