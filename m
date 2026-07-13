Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23764C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 11:48:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25B556B008C; Mon, 13 Jul 2026 07:48:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20BF56B0092; Mon, 13 Jul 2026 07:48:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D3856B0096; Mon, 13 Jul 2026 07:48:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E40E46B008C
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 07:48:43 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 779FF40100
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 11:48:43 +0000 (UTC)
X-FDA: 84983581326.01.A8F221E
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf04.hostedemail.com (Postfix) with ESMTP id BE8F340008
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 11:48:41 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=N8JkedrF;
	spf=pass (imf04.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783943321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3PyMSDdhZBE9vEjgfp5OzX/2Lfp7N6HnZTWVkO5qI/k=;
	b=gGHqkLCgTZ4Nk0FE+AMsh5E6z1Z/OQ4GGs7nzTwpNPP/KF+UT+KAdCKgsbex8ezeuKGP5O
	dUqCQriA+3cF7cxoaQQL4fX2HMKQk2CnYk6X3fEns2M4wK4U/x9KNBhYedCO6ZV4hIDT2Y
	bg9rUV/T7lxoMPY+KzlBC7sqBNiohEc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=N8JkedrF;
	spf=pass (imf04.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783943321;
	b=Q70sZKavtzv9WL44tv0TYA6w50GlkfZ4Zedmwxii0KjZHaPEC80SFhkFxat4zNOROFfml2
	Aoje0g/8QOcunL7he3TSv3+LTNivfDMwn/5NBWoxrfpzmQ88Iy5AHMyIScdprIP5rBPRSx
	u0EQHw+go6Q8BdpcUYxiXQlrdQemfG4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=3PyMSDdhZBE9vEjgfp5OzX/2Lfp7N6HnZTWVkO5qI/k=; b=N8JkedrFp067HCVQay8inu9u1z
	h83J6ZhcSMk1hIUwslGZNCaiZyFqnaWOOsJk78AZTNS1tiI5I5lutnyQ2lLdSgfVpCv13fvzq4W5w
	Jesr6LxsBYoDyr92CCet2I/Gr2FmfW8wZ2E6riiDe1JTrJ57enaSMpbor/2nvGGwNCRhOvbvmOVLy
	x5celDTdld0oC5m6x5c6wGkRexupSwwMHuD5jJG27ycFpFJwLD7XYlZIh++WdVURcDUyiP1qifAeo
	uUMSzIAsax437bwUusG8r2IbBGIWZwFdvIU4e/nnPfnxxFyUm+BUxZRCLOXNtqFqpYbU7Mg7k0kkN
	u50fa91Q==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wjF9H-001Tiq-0i;
	Mon, 13 Jul 2026 11:48:35 +0000
From: Breno Leitao <leitao@debian.org>
Date: Mon, 13 Jul 2026 04:48:05 -0700
Subject: [PATCH 2/4] mm: kmemleak: report leaks only after N consecutive
 unreferenced scans
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260713-catalin_pto-v1-2-5b93b1131089@debian.org>
References: <20260713-catalin_pto-v1-0-5b93b1131089@debian.org>
In-Reply-To: <20260713-catalin_pto-v1-0-5b93b1131089@debian.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 workflows@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Breno Leitao <leitao@debian.org>, 
 kernel-team@meta.com
X-Mailer: b4 0.16-dev-d5d98
X-Developer-Signature: v=1; a=openpgp-sha256; l=4344; i=leitao@debian.org;
 h=from:subject:message-id; bh=YBPJ0mqcwhJO4nOJvC72HAXZ4ErujEc7xC2rk3ArDDU=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqVNCDmJoWE4BMqrcZuuBB18LglsrEY2eFnhOvK
 1EfO5TjQAmJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCalTQgwAKCRA1o5Of/Hh3
 bXuAD/9lsfBVuMajHKh8kGKHEKDGGScReuyPF9mfQyBxoY4s107cMCBzbUi/pMqEBi2m0B67sEy
 6XWG7EZlOGqW6IgVcv+vDl0/RMSWBMf3BETrnbSI43C1Qf+bE0McySykdVWWvddgc3cFEqkpx4U
 cPJZlZr5W7wOSZdUXez+yZYFAr8F8/ZYLWtUaYY3a1PoKpvVgsmUDS4XBjA5UDGmfztDO9uShm9
 hhLlpKkkxUnnnYjEvvxTWpIiQvAzkMP+vScEtsw0bnhx+Y8ew4prxijoLTrWvUs6beu5FLVOhkV
 5AL71WmJyCoy3z5wEM0L46Kvq/h8NT2tC9gbl/gDciQZKo9xlIBOXph51YULGnEpyLzty2/4/DF
 u1DLJviSgu0j2pbe/GOO1i3GhQStWMpCg+88eOmRLdMZpAx4a5aOFSjRnbXLlnj0Uut3PjQ7eiX
 k5+QryctC9FgYRhpPxD8+d8glFwRbl407dt8GcAsc2UClwaFg//FbzivwKOYtx2LKY0vJ1qEJb4
 JBYCWKWCb9u0EhicC0FTNbGF1ol1e1KuMVa57VtOWBkJILZdrBudqSfm9kMlJFDtAmW7JBeFgJp
 r8O/yymkSwOa1Y7akjrjyXPXCegs+pVJ21VAb9dFaM4LVlH3BDdOuVZuZntJl5PxJ0HWU6j7CST
 VaIvB0nICkpc5/Q==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BE8F340008
X-Stat-Signature: k7y861ywedwhy7wst6hadwmnyquawe8o
X-HE-Tag: 1783943321-695306
X-HE-Meta: U2FsdGVkX18TfjXKS2d+STd4Z0FYDdcaV5folAeBk69XE6x5Jw7kdEKfHrf9jK1ZxkeZ1mld1hvxvrL1vly0zfgjyjk29d4phkGE4bLGM1sULpX9CASHSrOnHvX7ZJ3J7LcGne5513KVKiMXvGVwQyTJy86PUy01iN6ZtToVtEoOtjirWHocRiHZPiYGl2cB6cs2O2PI7Sa3goG+8khPaYv98Kc+sYiNC5XXA1ozNwU26RMQnghHxoKmIdxCJjt3hQ9rmc//0d5Rn6NsWji0bMfDVhdsM5G3Tt7IDSqaESTwtEKvyz4PrHr/62clSFuHNwg7Ls3hxUvyGT3Jt6fWEZf8fR1qeOyIAiCeYDzQCoEZeyAdwY/1f89+aj0AiC7cqeffc/HPz19Nn3w8MWWU09mEL6hNlxgYbgnbEippXEnoQ699X6pqM0smtRmC9yLkTC1oXxXIwA1U8J0/gYDLFuvui+KWRo7STCZygD4VW4IQLhJD3emyzfgla8PEcMZ1sMNTYVPr9A9Rbons5gLRyAonrQWpDNQ5neNRMGr7QhsFIyP1WCQ78WOVM7UrGz2ZA0YHHZJRV2Zn0V7au77wZ4cBypdCbBIArIdq4fcYiKvuy207zEwjU/FKiX51kHJDQ8XxueJTh3y7FQQF8cK5APqF8LjIjDxm2fu0aFz13ZBXxQO+rfX/Os05Naj5fMc3jBVXo8bQ3XP9W4lJzv6zG0JNKYiHe3Xrnd/ekXF1EsgyNgB7BiTwqXW4ORZXO0Dol0hBggnr7ZSycpvmXelNqB5Dz+XXk2nqwK2X7zrpLplWtCi3zSoosQqATKLeQgDDWanm428uz4qdZghb1ivSGJ+8TaEUBBLU0gHcMTR6cMguA2Oyyp6zGG7jylYCFoymTnA+gpDHLwelhep9Y6NW3txQsEYo8Qaf35J2uuOm277zSGtBKPwDfbgnsrfqfWQ3CQGxqnJbBlupk8Z9agQ
 5Dzw8sWo
 HjOWkmwHabCJurHf3HBnbiaZDzkbfwK/gje2OTKNeGNgvvSKnTPHgXHbrJeWZPFepAZERzrybp3B7uwZ9sElFdf/Nh/vdlCXOHXkCifvxb9w1W/QzfZLsQIKBgCyBWCpld7R38iX5U2yGIX7IST0pa4xEwADEYSEALNj05Q2pE27i3pol8p9/FyYwc8BqFllzlzSpvkaIRKJTyLuYR1c8yGpYPYLfZZxSaqevr64TESxoqmdUXFvM1j4Aksurg8Jilo2YWltsne+tlIul7UIuqCymEjIBo3pdPODE8+fzKa+PH3QeGSt03okqnKZle+hCizJk2X+44AtD74MiH3cKvQmPkI4MMHI0CKTR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kmemleak reports an object the first scan it is found unreferenced. Its
mark phase runs without stopping the rest of the kernel and without a
write barrier, so a live object whose only reference is briefly invisible
during a concurrent RCU update -- e.g. a VMA moved between maple tree
nodes, or a page-cache xa_node -- can be seen as unreferenced for that one
scan. Because an object is flagged as reported only once, such a transient
race turns into a permanent false positive.

Track how many consecutive scans each object has been seen unreferenced
and only report it once that reaches min_unref_scans, a new module
parameter. It defaults to 1, leaving the behaviour unchanged; setting it
higher (e.g. 2) still reports a genuine leak, one scan later, while an
object referenced again before the threshold restarts its run and is never
reported.

min_unref_scans can be set at boot with kmemleak.min_unref_scans=<n> or at
run-time via /sys/module/kmemleak/parameters/min_unref_scans.

Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
---
 Documentation/dev-tools/kmemleak.rst |  8 ++++++++
 mm/kmemleak.c                        | 13 ++++++++++++-
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/Documentation/dev-tools/kmemleak.rst b/Documentation/dev-tools/kmemleak.rst
index 7d784e03f3f9d..a8a83bc69ceb8 100644
--- a/Documentation/dev-tools/kmemleak.rst
+++ b/Documentation/dev-tools/kmemleak.rst
@@ -198,6 +198,14 @@ systems, because of pointers temporarily stored in CPU registers or
 stacks. Kmemleak defines MSECS_MIN_AGE (defaulting to 1000) representing
 the minimum age of an object to be reported as a memory leak.
 
+The ``min_unref_scans`` module parameter (default 1) requires an object to
+be seen unreferenced in that many consecutive scans before it is reported.
+Keeping it at 1 preserves the historical behaviour; higher values filter
+the transient false positives described above, at the cost of delaying
+genuine reports by up to that many scans. It can be set at boot with
+``kmemleak.min_unref_scans=<n>`` or at run-time via
+``/sys/module/kmemleak/parameters/min_unref_scans``.
+
 Limitations and Drawbacks
 -------------------------
 
diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index ac77bab580688..2fff11637e490 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -151,6 +151,8 @@ struct kmemleak_object {
 	int min_count;
 	/* the total number of pointers found pointing to this object */
 	int count;
+	/* consecutive scans the object has been seen unreferenced */
+	unsigned int unref_scans;
 	/* checksum for detecting modified objects */
 	u32 checksum;
 	depot_stack_handle_t trace_handle;
@@ -234,6 +236,9 @@ static unsigned long max_percpu_addr;
 static struct task_struct *scan_thread;
 /* used to avoid reporting of recently allocated objects */
 static unsigned long jiffies_min_age;
+/* consecutive scans an object must stay unreferenced before reporting */
+static unsigned int min_unref_scans = 1;
+module_param(min_unref_scans, uint, 0644);
 static unsigned long jiffies_last_scan;
 /* delay between automatic memory scannings */
 static unsigned long jiffies_scan_wait;
@@ -692,6 +697,7 @@ static struct kmemleak_object *__alloc_object(gfp_t gfp)
 	object->excess_ref = 0;
 	object->count = 0;			/* white color initially */
 	object->checksum = ~0;
+	object->unref_scans = 0;
 	object->del_state = 0;
 
 	/* task information */
@@ -1890,6 +1896,9 @@ static int __kmemleak_scan(bool full)
 				__paint_it(object, KMEMLEAK_BLACK);
 		}
 
+		/* referenced last scan: restart the unreferenced run */
+		if (!color_white(object))
+			object->unref_scans = 0;
 		/* reset the reference count (whiten the object) */
 		object->count = 0;
 		if (full)
@@ -2064,9 +2073,11 @@ static void kmemleak_scan(void)
 		raw_spin_lock_irq(&object->lock);
 		trace_handle = 0;
 		dedup_print = false;
+
 		if (unreferenced_object(object) &&
 		    (object->flags & OBJECT_SUSPECT) &&
-		    !(object->flags & OBJECT_REPORTED)) {
+		    !(object->flags & OBJECT_REPORTED) &&
+		    ++object->unref_scans >= min_unref_scans) {
 			object->flags |= OBJECT_REPORTED;
 			if (kmemleak_verbose) {
 				trace_handle = object->trace_handle;

-- 
2.53.0-Meta


