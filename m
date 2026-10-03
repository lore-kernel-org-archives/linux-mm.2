Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9013BCA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 00:19:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B06A26B008C; Fri,  2 Oct 2026 20:19:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A69AD6B0092; Fri,  2 Oct 2026 20:19:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E3806B0093; Fri,  2 Oct 2026 20:19:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 539386B008C
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 20:19:08 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C1407805A1
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:19:07 +0000 (UTC)
X-FDA: 85279405134.29.507D50F
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	by imf28.hostedemail.com (Postfix) with ESMTP id 147E6C0008
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:19:05 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FVVO8jw2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.210.41 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790986746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FS9XCl9z0DTVjd2kXBwt268wO43LTyKRy6tPTS178aI=;
	b=fcPRW0tCOBfg+A0obMcKEP/XHwHujgTey5rKOBCnc4354JYttTVdVsacxqHmtaRUc7IXzj
	+O4FZOcf8NLcAnjPn4W6bQnijDIRjFozG0sRjG0WabcwaNSJdo9n4rHquOHN/LKzmkaSCW
	Cke+700ufza3Ixph8b7DuJ8oY72slpI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FVVO8jw2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.210.41 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790986746;
	b=AlM3FW04bzJJ9HOu3HbxoNA05BWG59eAx/G7hu7oErXwT3QXgm8hOkW+jmCXjKCThAJsHi
	Ce7scWJZyY0rKV8QcFeOw9bXkrEcB2gdfaTjY4eHsBZNsN85rEhXKs5BH91z4LJLYN+PQ1
	6sjM93fCnixTnKerg4mWbFZwTtsPrnI=
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-821a7bee9b2so321982a34.0
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 17:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790986745; x=1791591545; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FS9XCl9z0DTVjd2kXBwt268wO43LTyKRy6tPTS178aI=;
        b=FVVO8jw2v/r9KoBjV2VU5R0mh6zyqgwi9Y378q5Bu1tWBUA7TwA8bx3JBjBfoY1EWH
         91IZU/cjTodGHXiGVs5fm1liYabuR6+/pJ429DXHmYOaKp7vYEHB0rOOy3Oy1U30Ljed
         pljubLdxskhorP4bsp2rdJCrf/iLKCtuR1iwZTXWHP7vSqnxIizJtVbsbLKKlbngj4jT
         P5IyRccYAGHSLz+cG2mhP9sy0kqZL7CohgVioMIe/tVDNZFR4XwrrDdtc7dPjH7JprBA
         lqjhGo5zzCTf0iMVUjjFMkDSi8jhvSK6pUj8gZw/wqat74Y5uaJXrPtzkd2cyWgV+Dss
         010w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790986745; x=1791591545;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=FS9XCl9z0DTVjd2kXBwt268wO43LTyKRy6tPTS178aI=;
        b=VyWzwsD75Dq/dDeLRxr0F5J9Vm5/2TDrr3R2bRw5+QJJ+9Mh87CpbM9/1Zje/L0EgX
         zL0zFhLx4zR3PXm1fpyWd2fDm9qRU00nQaBdGjHuLgNSqjXEqqSY0M/gm1pJNNtNGkkd
         nvzqK87fkyDvFd3PGdu/HQ4UiexXzYW/oLVQm4j6gQasZSjtlkDnuaR71n+Q6NuM69yy
         UWxTWLgBvLAMHnpWIuqBp2XaX1AztjfUHkLwzgnvvb6vyfqT6QOdLCs2gAlRoLTanFFF
         W0IFp6ShRojuY/HKVzDO09FtS6mi4MBL4cawWUWJbR0V0Y5RTg2elVYa9Sc7MZD8TwYs
         Fnvw==
X-Forwarded-Encrypted: i=1; AKwUvBwpgRtvVqTqFaKH7QL2X1JChvjFfUYyd49SDB7O3bcr5/RRvuOnRqNl2NtRjUo0EVS5Xz+ZfLWVag==@kvack.org
X-Gm-Message-State: AFuF++mNE54Kal75UqOjHpRb2ULTnDiYHXbsvrxcApozDngZUdiYEuVb
	S/jif7/cWs269fgaemAVjqIx2dWjk7UR4EtVgEzFayaD6nBv2ut/a3v+
X-Gm-Gg: AYBFou1YYS5xSwt2N3lbjqrfYBwW6HZl8FfL6goQs/BXH9PezFOFnafM2Ry8cuj+/DO
	VZ+wC9P9rXaNq9bX58rvHMaz91dQ+pRHcpdEMldeFiOvKbGrz2DH8zM2ZJNWHkswY7ILBWHZS2o
	Z/HQIMh71r0nZLksyhUIJJMnayW90452ooTl9PW5x1q97SzQoFH1vtyeemHwZcKV9CHD44uyKG3
	0OGgdRavJEPp8ZykTsUs/nov6lu24kDb/6S7DR4Lvy6KBfykRuuJMj7W+gtrt0zFjS46zz40YAG
	lkWDMOoqmMx4+SlmDTIz/mcypl+aQSvG0MJljuO+5s8ySZIOhDUIYu3ofAegzeOSb++ZAyAbv8v
	bJG7bIJ0++xjQX5MzlYSniUISncCSzWpmPZwlN4vP917N49Ozwpv9GkAIKGwkXHf5adX+AomO8i
	Rv78LLZsecKA58vFdWjYn4dvJRXZ8Ww2l7Y0mG8Vlh6mf72QnKuz+YePSy0VQRwO03JZtbOvJZH
	gaELY6cPUU4xd2M8mmYj8imK/pXspUmXf+UKmHahWYYGuWvUA==
X-Received: by 2002:a05:6830:7285:10b0:823:89b7:a57e with SMTP id 46e09a7af769-82389b7a603mr1114212a34.33.1790986745097;
        Fri, 02 Oct 2026 17:19:05 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:9::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-8227a66c6dfsm4498434a34.23.2026.10.02.17.19.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 17:19:03 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	roman.gushchin@linux.dev,
	willy@infradead.org,
	jack@suse.cz
Cc: mhocko@suse.com,
	muchun.song@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	liam@infradead.org,
	rppt@kernel.org,
	surenb@google.com,
	riel@surriel.com,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v1 2/3] mm: memcontrol: add mem_cgroup_reclaim_for_batch()
Date: Fri,  2 Oct 2026 17:15:54 -0700
Message-ID: <20261003001555.3498357-3-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261003001555.3498357-1-joannelkoong@gmail.com>
References: <20261003001555.3498357-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: tnmu1u1tpw63wxoqgsp8bnx98wsd3ej9
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 147E6C0008
X-HE-Tag: 1790986745-780976
X-HE-Meta: U2FsdGVkX1+W1v9893xPQ3QTmwAvTXQE8rJe40KqOtfvGyXltIw8u+ab34KSQtMhNRULVXN6GKLz7k09STnGHJ3+10CSTod3+PkQcXmxmnB86bEPor6/nTpVRVr3Sg9e9uui5u9EUNoKyjuHdbGySZXZGw1RvflDxdBQ4IkwjXLiDKwZ2yxl4KwvS989nmwuH047H0CxTZ/1hpbk+GkaihJvEZloXspRQGTTy9AbaXTmYBbvK5gALsHOF6r34gR880Gj2md4f4iwsTUz8EsLZY5bW14rjm+cY6zQ5CxUk+xwd0ve1rotMQFPDM2cZRNZYT5VWzV8MOgXetb09F/iGsLCVKRVAyXv96V7l5xnE5S+IzLtGygKIAz9qIpOX0w8xigLzPYOReb5PqG6nlVG4kemMnYHmxJH2ezuu/yZxWOSvkozIn5yJhptUwO6lLFVmOdbK6Ag9hR42cnL7fzH4MECCzbvbup9mhrHvH9hPKSmlUq+GdM4GrCP6K6HFGiGoJVcYeSx45SPgHopSAc5mdLr4FXq9/9nTPHvfyaxkwpf+snw/ZW7pfDt/mE8TeNiOkS4qDp1oBrz/ugpaolL6ZSDHlelFUsoTRFdMn83ihrItddaos4Eo1xEUwyL3s/jCvsiOt1uuOSIks7YK4a/Y3WWWYinDa90RCTrP5egz9iX0JzePZOBqTPFUhzeHVWrV4IYACTA2+iIJM8fdHg8rwbwj4yE8/AWYNqzq8R0Wm/P5aDThhxGF8mGXONuXWPPmqWbPCRXIcfYfGMc739fV0UvMjo+kJfBoSXMA9+TaSoKqjnzNDQsGoaK15SMPGGyZpzv6sQ5rCstFJDa55Pj0wI8hLaLoRAWEW/Y5PWqC4YkJQQqWiZEjJGufCt7MWiIkivKnHHo0r6mpiEqYzCI+vXxM2Vtbr7xNqU4MvoIXck63dcXQ4U2/NEyiJw/Lc0Ecw4v8sWJTWCvOkjQhnz
 VYRIwwlN
 NMS5KnzGmydqcVrp1v8N/L0kKs2RvJnkZPS2W+VjCLct0lHMa3Ky3sjZ+wIBUkXgMMD8Xzk/GiEp6SDKq2T/Or8QXaW4NBEX8oYwxbL1RG3ssc179LFCPqjsOky5iqrCoKjHsuzJ5VmgTyDcXPXkUhh0MnvVPPD24D40VUWTdsaKtiJMY/cnk6tzlBlhz4UFqVpMk9RJsT01EaglC6GtQL+TEzJByYiqW6kFMBtDTg03N8WURD8d2poe4koDwO4jjDrNGEfmdY8ClJCp2ZvxzyajODiq1cIaZjN9Ng1++XMohxz29L8mCSmebh2gB+JUmCP/IopABXjLx1zjFncREz8NBtP3+AxapLuHj9pJDHYIsYpg25ly/WL7RyEO/ECkNghw/IflSyvN41wdrI6MALrXxo7oVjzMgKbwcnv4dEFKn3Lxg7ym316oGQAK8zmgdC+YVlzf4MhRWMFgU+IEI/11Nkw452D9F89iAmDRzTdLU9jIAQVjZ+KY0QXezI86enOP61G+PDsegoHk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some callers charge a batch of folios one at a time, where each charge
may reclaim. At the memcg limit, each one of those charges then enters
reclaim separately. Readahead is the main example. This was observed on
Meta's fleet, where a single fault's readahead window can trigger more
than a dozen reclaim passes.

Add mem_cgroup_reclaim_for_batch() so that such callers can reclaim for
a whole batch at once instead of once per folio. Callers can then charge
without reclaim and if a charge fails, call
mem_cgroup_reclaim_for_batch() to make room for the rest of the batch.
Unlike try_charge_memcg(), it retries reclaim only once rather than up
to MAX_RECLAIM_RETRIES since failing is acceptable for the callers'
charges.

The next patch uses it for readahead.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 mm/internal.h   | 10 ++++++++
 mm/memcontrol.c | 64 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 74 insertions(+)

diff --git a/mm/internal.h b/mm/internal.h
index ff28b940e0cd..6d914f6a6138 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1652,4 +1652,14 @@ static inline bool can_spin_trylock(void)
 /* char-mem.c */
 bool file_is_dev_zero(const struct file *file);
 
+#ifdef CONFIG_MEMCG
+bool mem_cgroup_reclaim_for_batch(unsigned long nr_pages, gfp_t gfp);
+#else
+static inline bool mem_cgroup_reclaim_for_batch(unsigned long nr_pages,
+						gfp_t gfp)
+{
+	return false;
+}
+#endif
+
 #endif	/* __MM_INTERNAL_H */
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1d4b603085a5..9aea684ea755 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2736,6 +2736,70 @@ static unsigned long memcg_charge_reclaim(struct mem_cgroup *memcg,
 	return nr_reclaimed;
 }
 
+/**
+ * mem_cgroup_reclaim_for_batch - make room for a batch of upcoming charges
+ * @nr_pages: number of pages about to be charged
+ * @gfp: reclaim context
+ *
+ * Reclaim is needed when a memcg's margin (limit minus usage) is less than
+ * @nr_pages. Starting from the memcg that the current task's charges go to,
+ * reclaim @nr_pages from the closest ancestor whose margin is too small, with
+ * at most one retry. This lets callers that charge a batch of folios one at a
+ * time (like readahead) reclaim @nr_pages at once instead of once per folio.
+ * Callers must be ok with the charges failing.
+ *
+ * Returns true if reclaim was needed and done or false if no reclaim was
+ * needed or if the current task may not reclaim.
+ */
+bool mem_cgroup_reclaim_for_batch(unsigned long nr_pages, gfp_t gfp)
+{
+	unsigned int reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
+	struct mem_cgroup *orig, *memcg;
+
+	if (mem_cgroup_disabled() || !memcg_charge_may_reclaim(gfp))
+		return false;
+
+	orig = get_mem_cgroup_from_mm(NULL);
+	for (memcg = orig; !mem_cgroup_is_root(memcg);
+	     memcg = parent_mem_cgroup(memcg))
+		if (mem_cgroup_margin(memcg) < nr_pages)
+			break;
+
+	/* No reclaim needed. No memcg up to the root lacks the margin */
+	if (mem_cgroup_is_root(memcg)) {
+		css_put(&orig->css);
+		return false;
+	}
+
+	/*
+	 * cgroup v1 can limit memory+swap together (memsw). If memsw is the
+	 * limit being hit, swapping a page out doesn't help, so reclaim without
+	 * swapping.
+	 */
+	if (do_memsw_account() &&
+	    page_counter_read(&memcg->memsw) + nr_pages >
+	    READ_ONCE(memcg->memsw.max))
+		reclaim_options &= ~MEMCG_RECLAIM_MAY_SWAP;
+
+	memcg_charge_reclaim(memcg, nr_pages, gfp, reclaim_options);
+	/*
+	 * Like try_charge_memcg(), if reclaiming didn't make enough room, drain
+	 * the per-cpu stocks and if that doesn't help enough either, try
+	 * reclaiming again. Other tasks charging the same memcg may have used
+	 * up what was just reclaimed. Unlike try_charge_memcg(), only retry
+	 * once rather than up to MAX_RECLAIM_RETRIES times, since failing is
+	 * acceptable for the caller's charges.
+	 */
+	if (mem_cgroup_margin(memcg) < nr_pages) {
+		drain_all_stock(memcg);
+		if (mem_cgroup_margin(memcg) < nr_pages)
+			memcg_charge_reclaim(memcg, nr_pages, gfp,
+					     reclaim_options);
+	}
+	css_put(&orig->css);
+	return true;
+}
+
 static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 			    unsigned int nr_pages)
 {
-- 
2.52.0


