Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9DA0FE521D
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 12:24:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C1D56B008C; Fri, 24 Apr 2026 08:24:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34B8F6B0092; Fri, 24 Apr 2026 08:24:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EB356B0093; Fri, 24 Apr 2026 08:24:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0B1366B008C
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 08:24:40 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 987F3C0317
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:24:39 +0000 (UTC)
X-FDA: 84693367878.20.D4743F1
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf27.hostedemail.com (Postfix) with ESMTP id A795340006
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:24:37 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=jv+RC6ic;
	spf=none (imf27.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777033477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ux+dKLEa+dGQsO13rZ7n9Hp7R5EyF61kSfNPgtxt75k=;
	b=QyI+6WsikY24a74vVdrA9LG6+imtcTtrIOYVsHseCgW4To9Tav6zT97Ok2iepbaFTsc8ex
	3XHlSgXlGBU8L9nsde+U4aFgHGiyGI2Gax8C6HxemXtCBrPJElb7jkY5AWJIXH0E0tZ0Ox
	r51oBSnBwU+p8PxYz17DEAke8oSDovQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=jv+RC6ic;
	spf=none (imf27.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777033477; a=rsa-sha256;
	cv=none;
	b=Vn7M86rN6G2jxw2L7LQLJOxb4iKZCNwIAGXMZZPHuYLEZRNDUUH5/MTTJUwjwMePsF8H8t
	kpAiQ8AjJFUO5OdxKjPBwFh9ZPqtGHvgCVlY0+PHcOUDT279fZP55z7mIWSuTgFCbSr//E
	RJIIhF4wh4hKkYprkcBt/X+mFi4FAd0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=Ux+dKLEa+dGQsO13rZ7n9Hp7R5EyF61kSfNPgtxt75k=; b=jv+RC6icqmw+AIfsj3bBghXgrt
	R8/hpMnnPDSGI8Zha4i+moOCUok7mhlWVvHruF/78BZf8PLPnvsML3WBP0hPBDwesgNx65KNKAgCC
	NiofZIkjzjyw0QGqvIbaGYDdBFBwLTTf+yRwwdLHDZmy89KDeOujxsW+1ucFfx6nI5lMoFYz/p1ly
	fzhRcyZupEAPsPL4+IF8yAlwijbcSJCq/XsqeYSZ8YaFmCys932Af7DGy+desTW2OJKKZyr433M0b
	1jHJs2GkknsKEH8Ln5kwPPZZjVYGNkze0fQ6hNsvuzXk564ZAcQW5yNphw/X5aYDDLbJKgXxegvtR
	j7hVbaMA==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wGFaA-003APf-1P;
	Fri, 24 Apr 2026 12:24:30 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 24 Apr 2026 05:24:00 -0700
Subject: [PATCH v5 2/4] mm/memory-failure: add panic option for
 unrecoverable pages
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260424-ecc_panic-v5-2-a35f4b50425c@debian.org>
References: <20260424-ecc_panic-v5-0-a35f4b50425c@debian.org>
In-Reply-To: <20260424-ecc_panic-v5-0-a35f4b50425c@debian.org>
To: Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>, kernel-team@meta.com
X-Mailer: b4 0.16-dev-453a6
X-Developer-Signature: v=1; a=openpgp-sha256; l=7305; i=leitao@debian.org;
 h=from:subject:message-id; bh=eS1k0finACx5qpWj9XoieIaQ81rq4UQ36Bes/ewTsRw=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBp62DtOfcaIv9TaQOU9gZwxQ7MlBe8fgAShmc/j
 uVu17mpXsiJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaetg7QAKCRA1o5Of/Hh3
 bfmYEACtzFVve0wOH9y0XhrsqkQRjyCZGRlfLloIc5eISlSB/JLE/rBNsDmq+PmAnkscUrkLR4B
 CniMwQp0p87r4fhfiYPxetH9YzeN5mA3f7Izw7KdCwONAWeuuswvwsMP4HfdjaiesIJEQd//WPt
 0HoGn5JYbqR4hFHJWcmWFPZvSydNa/rA09jL48fVN2TNCyIqajXp/wt7I+UD4T7VPMBp2smc18N
 EtuASULZd5wscNCTwERsnoOAZ5AabgsulRamo2LaqTGUPbykSCBzUVG+6XUSHGA68KTES5245TM
 gkWA84AZOtohxhiVXEP1vLOObi33BHrphFfBP63AjsZ9+Xda3AbsIrC78od2hOmnUIJx6Rsp9vz
 8SJ1xxp9mPuo+gEKOVxU8E5Z7KPTEciV7hSUJE3X+Pg0GYqTbPsduaT967j981byU6yup0qDuiK
 Qv2ZFjDp2aM0na55No31lICfnHtDjlxiPAgZDsK/nLPh8eX6lSLgJA+57C6YQTLqwOE1byPTCCN
 hwyfbD/gDFVraivUNwNrAP8kKdjiZYE3bkI7wZ/RKeDd/UjlbDju0VTcWbGSPryUbd6fL2vzmtZ
 RZ9hDRJ6D6AHtTE+XcScNZVM93CytZFrvJhWBiooeiuVj1w+KDGdLTO9oqBju1BSWTE3lrMCT2V
 e9H/rUsNDDkogMg==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Stat-Signature: k1igdq3w97q1nkeg3itw3pcuofdxtfx1
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A795340006
X-HE-Tag: 1777033477-853408
X-HE-Meta: U2FsdGVkX18UjC7hGAgQW6D2NgBMBl8RYBwBlkRkWmdMPOmFKnvYqEmJMeBtzMKuS6nXPNY4pEE4/vLqtI2bgcntdBTTM0qcS0O60NNCaDjis13Ns9c19Qz+OABVNC/Ea2Mc6Nkl5pd7wypz/nU8GxE0jGlM0RpkayO+6Yab2kpLitqRUIjw07NDX2XitGv9IZcacZGl+KmnkLCVZxunPllHpZPMO96g2SdrMsdELSq2ljbZ3pkjFg/NxlxtIHUDU19XsDc2WhNjTXsSQ/qtSUqvSWND3g1YcEXzpI56NLk4FAxHxK4XRiN1fbXDE5q37rPCeEzgLTseqtqti0pjIO3MGdqtZ1J4fw46wzgAqU1AYWki4pkgjgPST6/8vNjFGt0mEwq3Bljo6Srg/UVTgGAEWnaPUaCRvFCjGvSe+iy1zHtL/DZAt9bFGofrd+AVcxFvgRkemgv31ZxTwxrH8GFj8D+ehVJnlDYf9OXG365vNsoaRgkXIXaDbPLRsQt0s2Sd84k0L7b5vAjZec08jpXEC8/8VNrH3Oqos9+01HWjS7vhNwRBqB8IfWIVipavA8YcOVTfGvWiOOBAooM7RMyfMVzn2xmBnvGiNGLdZYJZk69BQcZmpqleme1fFl6GVhac4rlQtGC3MxQdNWapoQAFooZicHQkKLocf4UnJ5bGFNj3UWhw4ZacAK8zMfZPsA/vnN9TuYJkE5Gtsube/5Sc770KnDr6qazRk5Ez8X0l30G3O2Hc+uMlHrLliZfP3hOD+WnEYrDx0Sb2ggnzcroKX+Joa/FbQa+XBW+W1Kx3Pvna4BwDWrQ2cS6BX5WtkGmYCYFdJNP80EghhxUOl0IUnQ816Z5njTpKHuxft0uMzweHMsSeJ5neCpFmDuJiFVwSiwcUw8hDeoaI4qT2kqiqD08w2hEJ0R1l7OlFgzg9diT5ZDTZ1YIwLv4+ap6r+bmtbX+V81XIshV9Kpx
 RufZ0jm6
 IIUHBGiGKRKEAcqK3y79lnMMot/dBP13zkaX2Fuog3Jluezy60AtcbwID1IhCWZ/U51DBLLu9JY2LJk+qlQJZmPL7iPg+oAAWP0lRJjZUeUjnIdRyFrsEaVoiQeGW+tGoXnNUBCd5XtLNZoSvRb38rh3En0CsV1RZTGEzQytXMlTh7NS/BhF5aEPPf/azKAn+7amZ6FymY/4NtSsTYSqum/EvF9b2s7NPGjVjm1u0kQR6X3PCjaNF1mQbgpMMlSc82lgBLY+/oAIZHZKZYV7q/7G8TePzecbRgvKO/tMUsNl1Ea2EOYR23iGys7Wqxm2H5oSQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a sysctl panic_on_unrecoverable_memory_failure that triggers a
kernel panic when memory_failure() encounters pages that cannot be
recovered. This provides a clean crash with useful debug information
rather than allowing silent data corruption or a delayed crash at an
unrelated code path.

The panic is triggered for three categories of unrecoverable failures,
all requiring result == MF_IGNORED:

- MF_MSG_KERNEL: reserved pages identified via PageReserved.

- MF_MSG_KERNEL_HIGH_ORDER: pages that get_hwpoison_page() observed
  with refcount 0 but that are not in the buddy allocator (e.g. tail
  pages of a high-order kernel allocation). A buddy page being
  concurrently allocated to userspace can briefly land on this branch
  too — its refcount is 0 inside the allocator and it is no longer on
  the buddy free list — and panicking on such a page would defeat the
  standard SIGBUS recovery path. The page allocator cannot reject
  hwpoisoned buddy pages reliably either: check_new_pages() is gated by
  is_check_pages_enabled() and is a no-op when CONFIG_DEBUG_VM=n.

  Rule out the race inside panic_on_unrecoverable_mf(): yield with
  cpu_relax() so a concurrent allocator on another CPU can finish
  prep_new_page() and have its writes become visible, then re-check.
  A genuine high-order kernel tail page stays unowned (refcount 0,
  no LRU, no mapping, not in buddy); an in-flight allocation will
  have bumped the refcount, attached a mapping, or placed the page
  on an LRU by then. Only panic if the recheck still observes a
  fully unowned page. The window is narrowed, not eliminated, but
  is far below any allocator path's cost.

- MF_MSG_UNKNOWN: pages that do not match any known recoverable state
  in error_states[]. A theoretical false positive from concurrent LRU
  isolation is mitigated by identify_page_state()'s two-pass design
  which rechecks using saved page_flags.

MF_MSG_GET_HWPOISON is intentionally excluded: it covers both
non-reserved kernel memory (SLAB/SLUB, vmalloc, kernel stacks, page
tables) and transient refcount races, so panicking would risk false
positives.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/memory-failure.c | 91 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 91 insertions(+)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 7b67e43dafbd1..fd1aed1af94a1 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -74,6 +74,8 @@ static int sysctl_memory_failure_recovery __read_mostly = 1;
 
 static int sysctl_enable_soft_offline __read_mostly = 1;
 
+static int sysctl_panic_on_unrecoverable_mf __read_mostly;
+
 atomic_long_t num_poisoned_pages __read_mostly = ATOMIC_LONG_INIT(0);
 
 static bool hw_memory_failure __read_mostly = false;
@@ -155,6 +157,15 @@ static const struct ctl_table memory_failure_table[] = {
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_ONE,
+	},
+	{
+		.procname	= "panic_on_unrecoverable_memory_failure",
+		.data		= &sysctl_panic_on_unrecoverable_mf,
+		.maxlen		= sizeof(sysctl_panic_on_unrecoverable_mf),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
 	}
 };
 
@@ -1281,6 +1292,75 @@ static void update_per_node_mf_stats(unsigned long pfn,
 	++mf_stats->total;
 }
 
+/*
+ * Determine whether to panic on an unrecoverable memory failure.
+ *
+ * Panics on three categories of failures (all requiring result == MF_IGNORED):
+ *
+ * - MF_MSG_KERNEL: Reserved pages (PageReserved) that belong to the kernel.
+ *
+ * - MF_MSG_KERNEL_HIGH_ORDER: Pages that get_hwpoison_page() observed with
+ *   refcount 0 but that are not in the buddy allocator (e.g. tail pages of
+ *   a high-order kernel allocation). A buddy page being concurrently
+ *   allocated could also reach this branch — its refcount is briefly 0
+ *   inside the allocator and it is no longer on the buddy free list — and
+ *   such a page may be destined for userspace, where the standard hwpoison
+ *   path would recover it via SIGBUS. The page allocator cannot reject
+ *   hwpoisoned buddy pages reliably either: check_new_pages() is gated by
+ *   is_check_pages_enabled() and is a no-op when CONFIG_DEBUG_VM=n. The
+ *   recheck below rules out this race before panicking.
+ *
+ * - MF_MSG_UNKNOWN: Pages that reached identify_page_state() but matched no
+ *   recoverable state in error_states[]. A theoretical false positive from
+ *   concurrent LRU isolation is mitigated by identify_page_state()'s
+ *   two-pass design which rechecks using saved page_flags.
+ *
+ * MF_MSG_GET_HWPOISON is intentionally excluded: it covers dynamically
+ * allocated kernel memory (SLAB/SLUB, vmalloc, kernel stacks, page tables)
+ * which shares the return path with transient refcount races, so panicking
+ * would risk false positives.
+ */
+static bool panic_on_unrecoverable_mf(unsigned long pfn,
+				      enum mf_action_page_type type,
+				      enum mf_result result)
+{
+	struct page *p;
+
+	if (!sysctl_panic_on_unrecoverable_mf || result != MF_IGNORED)
+		return false;
+
+	switch (type) {
+	case MF_MSG_KERNEL:
+	case MF_MSG_UNKNOWN:
+		return true;
+	case MF_MSG_KERNEL_HIGH_ORDER:
+		/*
+		 * Rule out a concurrent buddy allocation: give the
+		 * allocator a moment to finish prep_new_page() and
+		 * re-check. A genuine high-order kernel tail page stays
+		 * unowned; an in-flight allocation will have bumped the
+		 * refcount, attached a mapping, or placed the page on
+		 * an LRU by now.
+		 */
+		p = pfn_to_online_page(pfn);
+		if (!p)
+			return true;
+		/*
+		 * Yield so a concurrent allocator on another CPU can
+		 * finish prep_new_page() and have its writes become
+		 * visible before we resample the page state.
+		 */
+		cpu_relax();
+		return page_count(p) == 0 &&
+		       !PageLRU(p) &&
+		       !page_mapped(p) &&
+		       !page_folio(p)->mapping &&
+		       !is_free_buddy_page(p);
+	default:
+		return false;
+	}
+}
+
 /*
  * "Dirty/Clean" indication is not 100% accurate due to the possibility of
  * setting PG_dirty outside page lock. See also comment above set_page_dirty().
@@ -1298,6 +1378,9 @@ static int action_result(unsigned long pfn, enum mf_action_page_type type,
 	pr_err("%#lx: recovery action for %s: %s\n",
 		pfn, action_page_types[type], action_name[result]);
 
+	if (panic_on_unrecoverable_mf(pfn, type, result))
+		panic("Memory failure: %#lx: unrecoverable page", pfn);
+
 	return (result == MF_RECOVERED || result == MF_DELAYED) ? 0 : -EBUSY;
 }
 
@@ -2428,6 +2511,14 @@ int memory_failure(unsigned long pfn, int flags)
 			}
 			res = action_result(pfn, MF_MSG_BUDDY, res);
 		} else {
+			/*
+			 * The page has refcount 0 but is not in the buddy
+			 * allocator — typically a tail page of a high-order
+			 * kernel allocation. A buddy page being concurrently
+			 * allocated to userspace can also briefly land here;
+			 * panic_on_unrecoverable_mf() rechecks to rule that
+			 * out before triggering a panic.
+			 */
 			res = action_result(pfn, MF_MSG_KERNEL_HIGH_ORDER, MF_IGNORED);
 		}
 		goto unlock_mutex;

-- 
2.52.0


