Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5535F606A8AE
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0i0N6i/o
Received: by kanga.kvack.org (Postfix)
	id 790986B05C6; Mon, 16 Nov 2026 06:04:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7690F6B05C7; Mon, 16 Nov 2026 06:04:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6575E6B05C8; Mon, 16 Nov 2026 06:04:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4056C6B05C6
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:04:53 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D08211408CC
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:04:52 +0000 (UTC)
X-FDA: 85440699624.21.85AFDEE
Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	by imf26.hostedemail.com (Postfix) with ESMTP id E87B014000B
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:04:39 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="0i0N6i/o";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of nakixii@gmail.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=nakixii@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827080;
	b=uF+exVH5i/9rKw+4qn0gqVABbmzmJD65YZgfWi/NAXlJP4ASGpEbT46qkM+kp3YmbJU+vz
	jaxBHg8w2SJJI05TDGZB8NCqbYumtbzMwtFXJ8UXmrK1fysa5lROfL/Nf/Eo+E8+mhfcpw
	lsjBG3WVvpNACELR1hasjiCtGyrbOY8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qKxpEcN2pivN4rr9uZi0u3NXCbLqXQzeVzDGfJiaQ78=;
	b=8S7yTkeOM8++4ScTq8RFKh+1s8mMcLmmyZ0H1SALppmRkiJr76sa5v7zkekqnlcS/hU1BR
	jn5O68Vsc3LeO7ibqB8X114NSCz5fGKHMVKs+gAwlEeQUpoTvXizgAJQFbXVVhap1CGW/P
	oJq0AOr12L6K5ZxP0FKGtrJh965BAxA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="0i0N6i/o";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of nakixii@gmail.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=nakixii@gmail.com
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-1a2af4c8d00so6714758c88.0
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:04:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794827079; x=1795431879; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qKxpEcN2pivN4rr9uZi0u3NXCbLqXQzeVzDGfJiaQ78=;
        b=0i0N6i/op3kYXc5PzutHZqVZoNPfbfIfWQ1rKtRGHcC8WuoXzbPRIpYwuE2LgEBckw
         BX5yM2uVi+aiGuZScqP+bb3vsPLm1122uf3Fo7LZag+pcvWyFohmNbwHr+/RlpxCipzm
         g+B7SbtnZUwiA4/rb399Rth6VJcj6C4tUrFweC31NHxqEi5v4CJNZV83tY9OCF+nNwxM
         bQzXA9ULiDc5JmXOcv7DcZ+JIzcuzVmasDKCVWEDb5MNuW2OLUwZEDlQbqV1LIzGvMY2
         0n8D+mlG0REWZaHJbkqra+PmCli6sfwYWXdANyyDFGqvon762sVGo2GQuHffQL6j7I8r
         S5dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794827079; x=1795431879;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qKxpEcN2pivN4rr9uZi0u3NXCbLqXQzeVzDGfJiaQ78=;
        b=AD3UU+B9RXXPRTG1AYaoRGrZWfAm8BRX7sL8dVtilT6c8td6RemI1qjHNE8ikAZrGW
         ultJBpkh19y33N/YtLnHYKDs9tL2ztvnkzrrcp/sU7u6EqOzfze6teFZgo2L5VVmsFTd
         qfRU+ItIjAo9dhk4WWgENchDqgvy3khNfHZqpAkEwDxTxkbnDrEYPsrxVtWqbaXw+mor
         bI22Y9oHNtacIeq9RMFqpps188h92FvyyDmNUlEhY2+bP7qj3S1tSQ5Qkrnt++ehedq2
         9XjJhAnNb6fjY+5nJtmDJ2U76DUoasdrDe6dsJd+mjZ37J9WIyEt2KAthIFZAY+wbSVn
         OGwg==
X-Gm-Message-State: APuU4Z8lIyr97kKZh19IZVY5qt88wyiQ86Dlc3kL7jdhFkEbOqgLcP4q
	Z23AWYqDJl82wAcb6COiBlyNP7sOlfAtRvWgxtGXngCdu14lDViaBA0Hc2GJ1z+/YBUweYgi
X-Gm-Gg: AYBFou2eVmvsYozzJRV/Ay0AFY/Rj1YKAU/C7nEm4Vumet/ZjmlAE8QheDrBAz744vt
	cSbdJGmfrDxhPcSwVwZR6nGWfJWAwPVZWAK4MjJxfSsE1hIBkrgKnhOAPMiAJx09yJEy6xepGdv
	Hd+QP3JjXzNW8lMu52XcBn2r0GCvxDQYqvlhewySVdw7cQ97f6P5yTtVAXgRX1pxtKxPCKgaYMV
	FhNyZVsRoSA17dS0YRoyho9jci/olDMgunYpaD10KK6vo2VCVdlD1kXUkgEI/A0AT0l5fWA5DUI
	AEsipPHygeaqX7LjGPWLgS1JCTW20fh+dHL17jzWqu8IueOWgu0rii9Dc2qGHC1IRArdGRA7IuD
	VR86tD73TtoSnuB9Eq1C7GQEuILgZJYo/UFfi8pgeMk4CWx7VAm79DlcHAv05DETmbT4vh1y4ks
	qfBs+6bmGa1JdFQqF1/SJtN7aS5j0xAsCnXqxGrPdK7qw4fdxhrgkz7TiArynu+Em49XO2v6+QR
	qg2Udw+GhZ1jG1FTuHEPvwsV6S/oW7ccflJYG/sNQTxf6+iLQe5XjFtMS6nyzsIz4u06Xp63lKW
	O9jbHudSLDfeI+5j8cxCJgmsapw+CUOIhbCiXe1fNg1kzVA=
X-Received: by 2002:a05:701b:4590:20b0:1b3:b53e:b4c5 with SMTP id a92af1059eb24-1b503137aafmr9667743c88.38.1794827078542;
        Mon, 16 Nov 2026 03:04:38 -0800 (PST)
Received: from naki-PC.localdomain ([203.175.14.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5031918c7sm42999260c88.9.2026.11.16.03.04.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 03:04:38 -0800 (PST)
From: nakixii <nakixii@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Barry Song <baohua@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>
Subject: [RFC PATCH 12/16] mm: memcomp: report precise token residency
Date: Mon, 16 Nov 2026 19:01:18 +0800
Message-ID: <20261116110122.309748-13-nakixii@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261116110122.309748-1-nakixii@gmail.com>
References: <20261116110122.309748-1-nakixii@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E87B014000B
X-Rspamd-Server: rspam12
X-Stat-Signature: j7xwzj5ssbuzrr6j5tmrymknujkdipnb
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794827079-563678
X-HE-Meta: U2FsdGVkX18veA2vkf0oS+wlmRuJkO/VNSI0/viLEuRshzLyPUQmyOkRfnpYlM35EOeFGltmBiELeRAktZMSlXw5lMXW0Tl06F4IBN+lqHBRaUlg/k+I2hD+HQl5pFoqY+M4x36zjilc7YCiZNfSXe+K8jUxqUfftv3cssT0G0zrdHY8UjGKrpVkdLwm7M+2MvJslZsOhgOuvGeonF+DhKpQsWuhD9aAWaf6WvqtfuqTntTm91F+ZmBdYMbLLbN9gD6xDkB8yuSC1OA6jZsTvhXnRHiichDqq2oShZqQSeK3em9DvuAH+woNEfaRE407K6QpxSM6E/6BS3KSsE9L8jZV1x4vhDvxghH0LYxCvqR4I66OlXkVobYNrJwGhUYVeONV9ZbhELfnQWMC1j1iwgFiuwtGeyqIc2q4WKJD3rHyF4lGEpt4WUi7SZFl4x3LsiE27rfPE9XAPWAMAfJ/+jYf3NmYtl3k/egJM6AFDqNH8Xq8SLaCSKXQmJrTVZBwTzdGBF/mx102kqwo0rZ/qtBmIzvr/5MqatMZkBPyrtLG8iRGy1575v9vHZoAYN5HCw7uKrU1QUyJ0X/dwPG+SEDA6wRDQqxInqJJuKilO72+mQ26cAcbWsP6CXw0/JljRTieMhN3JGlreJ9JUUrcc7SGwtG8l6VnwRvexzQUm0cuNSRooP3WlPfCZ/hMIslAxGZ8vw586bU0datd3jnfsCuoIrW10nEtikz2NTt9amkbxSsvn16A58O73Jh3Qc65S09AqVOT2j9NmWqg1Um7zexfV9Dgj5SoopUyc/QsBOUrxUjrrDC9ppRYIRQlnFXl/+IkVWxOtf78yIiGx/+FrEQXJP0XLSwDxF/2aJneyP3dvtApm8BcSCGa4Yz8RX2yAH/YdYuVGcatQ0AfeWShAYKNMYqT8pdpweV1STba89+WkHvEe5nDZoEuebFWH8MvrQMRt8E/tmKFwyKCbZF
 d/gwXBZr
 hRCZD/zQ7krYIbMvHcp96T34/63xIrl/CCE6Pls0vBO57IZeIq4lMhK+WhOx6NE31Z5+WfeebqK1WwdV4mBUueuGqp/yv+89cxGm4WhKhB6b9YfN2vbQokzWpeLB+JOgr5MoUB8n8vJDlGDzTah+xIPUxJTF7EJL/KW+wUYzkQxFle4CRJe+jN2014FlKLNXZdqUo6vRvuWGPXX13XmUaQ0zc2oaEv4jKtWCXSGe9MwNbpRY2+Wt91PFQakKTaGYGqLQ52MEk5Cig/9bMaUNijM0s+cFmdUZrxUG9TZmaDWXhpEDcIfIx1gWGWblmzclDO4Uj29lKL0C9pizndjO+CPfF5QmQUcGrWM3VDjM3PtSE7CRWLwJv9cMFJ7JLQN+R6ZjcsVmsEAXAFwuDc9hXJ6UlfIz89aIbIEIEDZOYhqsPT1wRhckisCTHZuSm5/2PJ5TX0PaTEzTUecTN8SCTuwRi3FsWZv0LwiU+ZQF05k0uUF0/ufGvk8G4Y70963ZczS+Lw9/Lud/kc0dZBVKFERFE8DlgCLRneoiZX3noMYgnNVRkbOJJOl4fvTtpZTWisI2zmWZ3eHo56nT+MzLx7l3VsoGCrmfcK7Ivi0F28QZNoR8jhsVavSyGI/FohwFLxg0RtSNyQ+19nsPIn0Y9pKZvZw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Report whether a token can satisfy a read without I/O for anonymous and
shmem mappings, including each base page of a large folio. Query backing
swap-cache uptodate state without reading, decompressing or consuming
a shadow. Drop PTL and XArray locks around the query and revalidate.

Preserve each base kernel's native syscall and page-size handling.
Add test-only query seams with the KUnit patch, not this production
step.

Signed-off-by: nakixii <nakixii@gmail.com>
---
 include/linux/memcomp.h |   7 +++
 mm/memcomp.c            |   1 +
 mm/memcomp/api.h        |   5 ++
 mm/memcomp/mincore.h    |  77 +++++++++++++++++++++++++++++
 mm/mincore.c            | 104 +++++++++++++++++++++++++++++++++++++++-
 mm/swap_state.c         |   5 ++
 6 files changed, 198 insertions(+), 1 deletion(-)
 create mode 100644 mm/memcomp/mincore.h

diff --git a/include/linux/memcomp.h b/include/linux/memcomp.h
index 8248a44bbb57a9e98afe29cc0e0599ca9f6bc988..f992a5e716fc6dc59b75072e6bed41eb4454e083 100644
--- a/include/linux/memcomp.h
+++ b/include/linux/memcomp.h
@@ -45,6 +45,8 @@ enum memcomp_anon_fail_event {
 #ifdef CONFIG_MEMCOMP
 
 bool memcomp_available(void);
+/* Process context only, with no PTL or XArray lock held. */
+bool memcomp_mincore(unsigned long token);
 bool memcomp_release_folio_reclaim(struct folio *folio,
 				   struct mem_cgroup *target_memcg);
 void memcomp_publish_cache_eviction(struct folio *folio, struct memcomp_ref *ref);
@@ -191,6 +193,11 @@ unsigned long memcomp_shadow_token(void *shadow);
 
 #else
 
+static inline bool memcomp_mincore(unsigned long token)
+{
+	return false;
+}
+
 static inline bool memcomp_available(void)
 {
 	return false;
diff --git a/mm/memcomp.c b/mm/memcomp.c
index 01254bf22c8834dc61d731cf5f776cb77cd9c908..a246c801910b72a5084d4db17d4183e0d69bb958 100644
--- a/mm/memcomp.c
+++ b/mm/memcomp.c
@@ -3903,6 +3903,7 @@ static bool memcomp_writeback_defrag_pass(void)
  * Core load - decompress one page from @entry into @dst.  Sleeps on the
  * token lock and possibly swap IO; never called under the PTE lock.
  */
+#include "memcomp/mincore.h"
 #include "memcomp/workingset_load.h"
 #include "memcomp/load.h"
 #include "memcomp/consumers.h"
diff --git a/mm/memcomp/api.h b/mm/memcomp/api.h
index b73bde6c3d976f05bbe3ff35ecd57bf82f58f789..47946253497046eae4c01b230fafc5f2e6dc1623 100644
--- a/mm/memcomp/api.h
+++ b/mm/memcomp/api.h
@@ -39,6 +39,11 @@ void memcomp_invalidate_cache(unsigned long token)
 	mc16_cache_drop(token);
 }
 
+bool memcomp_mincore(unsigned long token)
+{
+	return mc16_mincore(token);
+}
+
 bool memcomp_entry_present(unsigned long token)
 {
 	return mc16_entry_present(token);
diff --git a/mm/memcomp/mincore.h b/mm/memcomp/mincore.h
new file mode 100644
index 0000000000000000000000000000000000000000..ebba2424b65ef4f0ce5fba1892c6728f43a346b8
--- /dev/null
+++ b/mm/memcomp/mincore.h
@@ -0,0 +1,77 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _MM_MEMCOMP_MINCORE_H
+#define _MM_MEMCOMP_MINCORE_H
+
+#include <linux/pagemap.h>
+#include <linux/swap.h>
+
+/* Include after storage/access/refs and the memcomp_slot_* helpers. */
+#ifdef CONFIG_SWAP
+static struct folio *mc16_mincore_swap_folio(swp_entry_t swap)
+{
+	struct swap_info_struct *si;
+	struct folio *folio;
+
+	si = get_swap_device(swap);
+	if (!si)
+		return ERR_PTR(-ENOENT);
+	/* No allocation, read, readahead or swap-cache hit accounting. */
+	folio = filemap_get_folio(swap_address_space(swap), swap_cache_index(swap));
+	put_swap_device(si);
+	return folio;
+}
+#endif
+
+/* Process context only: the caller pins its PTE/XA owner across this query. */
+static inline bool mc16_mincore(unsigned long token)
+{
+	struct memcomp_ref ref;
+	struct mc16_view view;
+	unsigned int state;
+	bool present = false;
+#ifdef CONFIG_SWAP
+	struct mc16_swap_fields fields;
+	struct folio *folio;
+	swp_entry_t swap = { };
+#endif
+
+	might_sleep();
+	if (!token)
+		return true;
+	if (!mc16_get(token, &ref))
+		return false;
+	mutex_lock(memcomp_lock_of(token));
+	if (!mc16_view_locked(&ref, &view) || !mc16_flags_valid(*view.flags))
+		goto unlock;
+	state = mc16_flags_state(*view.flags);
+	if ((*view.flags & MC16_F_RESIDENT) || state == MC16_PENDING ||
+	    state == MC16_STORED || state == MC16_WRITEBACK ||
+	    state == MC16_SAMEFILL) {
+		present = true;
+		goto unlock;
+	}
+#ifdef CONFIG_SWAP
+	if (state == MC16_SWAPPED &&
+	    mc16_swap_decode(*view.word, *view.length, &fields)) {
+		swap = swp_entry(fields.type, fields.swap_offset);
+		/* A token guard alone does not pin a backing changed by swapoff. */
+		if (!swap.val || memcomp_slot_dup(swap))
+			swap.val = 0;
+	}
+#endif
+unlock:
+	mutex_unlock(memcomp_lock_of(token));
+#ifdef CONFIG_SWAP
+	if (swap.val) {
+		folio = mc16_mincore_swap_folio(swap);
+		if (!IS_ERR_OR_NULL(folio)) {
+			present = folio_test_uptodate(folio);
+			folio_put(folio);
+		}
+		memcomp_slot_put(swap);
+	}
+#endif
+	mc16_ref_put(&ref);
+	return present;
+}
+#endif /* _MM_MEMCOMP_MINCORE_H */
diff --git a/mm/mincore.c b/mm/mincore.c
index d6bd19e520fcfb9389e6825eefd72d0b51ad2969..17e8d7a5b316edcfb13d72242767eea662a559dd 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -18,7 +18,7 @@
 #include <linux/shmem_fs.h>
 #include <linux/hugetlb.h>
 #include <linux/pgtable.h>
-
+#include <linux/memcomp.h>
 #include <linux/uaccess.h>
 #include "swap.h"
 
@@ -49,6 +49,35 @@ static int mincore_hugetlb(pte_t *pte, unsigned long hmask, unsigned long addr,
  * and is up to date; i.e. that no page-in operation would be required
  * at this time if an application were to map and access this page.
  */
+#ifdef CONFIG_MEMCOMP
+/* The XA guard, not the unreferenced value returned by filemap, pins token. */
+static int mincore_memcomp_page(struct address_space *mapping, pgoff_t index)
+{
+	struct memcomp_ref ref = { };
+	unsigned long token;
+	void *entry;
+	bool pinned, stable;
+	int present;
+
+	xa_lock_irq(&mapping->i_pages);
+	entry = xa_load(&mapping->i_pages, index);
+	if (!is_memcomp_shadow(entry)) {
+		xa_unlock_irq(&mapping->i_pages);
+		return -EAGAIN;
+	}
+	token = memcomp_shadow_token(entry);
+	pinned = !token || memcomp_entry_get_ref(token, &ref);
+	xa_unlock_irq(&mapping->i_pages);
+
+	present = pinned && memcomp_mincore(token);
+	xa_lock_irq(&mapping->i_pages);
+	stable = xa_load(&mapping->i_pages, index) == entry;
+	xa_unlock_irq(&mapping->i_pages);
+	memcomp_entry_put_ref(&ref);
+	return stable ? present : -EAGAIN;
+}
+#endif
+
 static unsigned char mincore_page(struct address_space *mapping, pgoff_t index)
 {
 	unsigned char present = 0;
@@ -60,7 +89,21 @@ static unsigned char mincore_page(struct address_space *mapping, pgoff_t index)
 	 * any other file mapping (ie. marked !present and faulted in with
 	 * tmpfs's .fault). So swapped out tmpfs mappings are tested here.
 	 */
+#ifdef CONFIG_MEMCOMP
+again:
+#endif
 	folio = filemap_get_incore_folio(mapping, index);
+#ifdef CONFIG_MEMCOMP
+	if (folio == ERR_PTR(-EEXIST)) {
+		int ret = mincore_memcomp_page(mapping, index);
+
+		if (ret < 0) {
+			cond_resched();
+			goto again;
+		}
+		return ret;
+	}
+#endif
 	if (!IS_ERR(folio)) {
 		present = folio_test_uptodate(folio);
 		folio_put(folio);
@@ -97,6 +140,41 @@ static int mincore_unmapped_range(unsigned long addr, unsigned long end,
 	return 0;
 }
 
+#ifdef CONFIG_MEMCOMP
+/* Enter with PTL held; return with a fresh mapping, or NULL for ACTION_AGAIN. */
+static int mincore_memcomp_pte(pmd_t *pmd, unsigned long addr,
+			       struct mm_walk *walk, pte_t orig,
+			       pte_t **ptepp, spinlock_t **ptlp)
+{
+	struct memcomp_ref ref = { };
+	bool compressed = is_swap_pte(orig) &&
+		is_memcomp_entry(pte_to_swp_entry(orig));
+	unsigned long token = compressed ? swp_offset(pte_to_swp_entry(orig)) : 0;
+	bool pinned = true, stable;
+	unsigned char present = 0;
+
+	if (compressed && token)
+		pinned = memcomp_entry_get_ref(token, &ref);
+	pte_unmap_unlock(*ptepp, *ptlp);
+	if (compressed)
+		present = pinned && memcomp_mincore(token);
+	else
+		__mincore_unmapped_range(addr, addr + PAGE_SIZE, walk->vma, &present);
+
+	*ptepp = pte_offset_map_lock(walk->mm, pmd, addr, ptlp);
+	stable = *ptepp && pte_same(ptep_get(*ptepp), orig);
+	if (*ptepp)
+		pte_unmap_unlock(*ptepp, *ptlp);
+	/* A changed PTE may have dropped the last owner: put outside PTL. */
+	memcomp_entry_put_ref(&ref);
+	if (!*ptepp)
+		return -EAGAIN;
+	/* The first validation is the snapshot; do not retain a stale ptep. */
+	*ptepp = pte_offset_map_lock(walk->mm, pmd, addr, ptlp);
+	return stable ? present : -EAGAIN;
+}
+#endif
+
 static int mincore_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			struct mm_walk *walk)
 {
@@ -119,8 +197,29 @@ static int mincore_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 		return 0;
 	}
 	for (; addr != end; ptep++, addr += PAGE_SIZE) {
+#ifdef CONFIG_MEMCOMP
+again:
+		;
+#endif
 		pte_t pte = ptep_get(ptep);
 
+#ifdef CONFIG_MEMCOMP
+		if ((is_swap_pte(pte) && is_memcomp_entry(pte_to_swp_entry(pte))) ||
+		    (pte_none_mostly(pte) && vma->vm_file &&
+		     shmem_mapping(vma->vm_file->f_mapping))) {
+			int ret = mincore_memcomp_pte(pmd, addr, walk, pte, &ptep, &ptl);
+
+			if (!ptep) {
+				walk->action = ACTION_AGAIN;
+				return 0;
+			}
+			if (ret < 0)
+				goto again;
+			*vec = ret;
+			goto next;
+		}
+#endif
+
 		/* We need to do cache lookup too for pte markers */
 		if (pte_none_mostly(pte))
 			__mincore_unmapped_range(addr, addr + PAGE_SIZE,
@@ -146,6 +245,9 @@ static int mincore_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 #endif
 			}
 		}
+#ifdef CONFIG_MEMCOMP
+next:
+#endif
 		vec++;
 	}
 	pte_unmap_unlock(ptep - 1, ptl);
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 4669f29cf555748c9c3245a370a613dbfca37d76..f955f67502f503730864c34bf1711c9d4ecb5a10 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -416,6 +416,11 @@ struct folio *filemap_get_incore_folio(struct address_space *mapping,
 		return ERR_PTR(-ENOENT);
 
 	swp = radix_to_swp_entry(folio);
+#ifdef CONFIG_MEMCOMP
+	/* A compressed value is not a folio; mincore queries it outside PTL. */
+	if (is_memcomp_entry(swp))
+		return ERR_PTR(-EEXIST);
+#endif
 	/* There might be swapin error entries in shmem mapping. */
 	if (non_swap_entry(swp))
 		return ERR_PTR(-ENOENT);

