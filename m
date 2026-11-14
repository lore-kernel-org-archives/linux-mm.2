Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99247606A33E
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 14:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mQbd4T/V
Received: by kanga.kvack.org (Postfix)
	id BAD366B05C4; Sat, 14 Nov 2026 09:51:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5DD96B05C5; Sat, 14 Nov 2026 09:51:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FF356B05C6; Sat, 14 Nov 2026 09:51:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6A4526B05C4
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 09:51:47 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 001291C3B83
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 14:51:46 +0000 (UTC)
X-FDA: 85434013812.27.5B86DE3
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2A4251C0005
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 14:51:45 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="mQbd4T/V";
	spf=pass (imf21.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794667905;
	b=XRiTf6tSGNYFdWTY+2J9KVvmZfNVRYuXAne8Jmd+tG3P7n6jlpza4BCGAGNkU78fJIIFGY
	SwUXmGr7wHRz9cUhKzPvaDjUPn9Js9fvg4hKITcU9aJ/Zv82LReMcJd5q+tDtcJIQGpfjd
	qlh7k45saQwZfEmYt4gdli4Gw4WuTqE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="mQbd4T/V";
	spf=pass (imf21.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794667905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d/KG6L5TmcYH8sgI9i0BskQU4jwPk6/DgXHqGyit9go=;
	b=G++I/0BL5BNdTebOiEo4uYguGv8HY58gtkKgsaB5FO9FYd9RYQOBjFXYlWGNQ1mqceVyhf
	KN9sJ6nSAVw4doJ1nZRhMqvXPrs6k7HhVq9PDIQWhY1o3bKCy/aQN1+MKnFzYCHpk3njYr
	n0pq4BVVwWPxdb5NBIbheYdl1wVfJPI=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-8b5c3288e6cso838958b3a.3
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 06:51:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794667904; x=1795272704; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=d/KG6L5TmcYH8sgI9i0BskQU4jwPk6/DgXHqGyit9go=;
        b=mQbd4T/V4LdtSGRCmpr5mlUDRM0+/h2dBjZIgBHWLmqmHXgdD+af2qZ6Zz3blw1baQ
         66wIXy1hbL990gzxPrvnFCOYFq1E45vHDzCQ2+piCgtF8FsCUp68Wuv3xVzxY8AbuoLN
         n7JoPvQYb7Q7VrgBhGncd6HudphmpXFY5XuNpzBx18jBJl3x7jow1zg4q00oz+r69uEh
         d3aNpevNkO3CZ+s+4U34H8U1Jg0OkDZh10FD/mAN2gIlx6UBPNsMtczD8kyc+/QM8qDN
         zZq/mGpp0vfrBwAQW5W5Pdq8+F0WOi+Psw3AaIwAKbgIfdUIFxlgkxOWNNwmkEPt4BZf
         hFcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794667904; x=1795272704;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=d/KG6L5TmcYH8sgI9i0BskQU4jwPk6/DgXHqGyit9go=;
        b=sLc/Ofr2Run4DTjtUX0DPH7K8oLy63SPXaFwye5Ki1KJXn80WF+2GJD+033ORixaai
         mSYLt2ec/orAkMBANdYyV3eA/RknT3NrbJIq//DtYKGoK5KlwbUrchQOFM6+oh5poxKc
         cuFSnaqROpnozB76+Vz0O+usZcPuFAYmDEezeOxBRh9FE6rxZwYxDlojnj14zbLgOhRD
         kfDySuJdbtOVOCmBhbVtSaWvx+oKVPepwK8wk6/erERZSB99UkXXmuZHhQqzA5cE3Fbz
         LPix328s+hkqiUbvqfdFiisKN7hDBsQ7+tubpe0a0O1OPYZeQc1fYsN1GDr9Gy5Yah6t
         YR5A==
X-Gm-Message-State: APuU4Z+LuJaDYYuzURnwN8JTQkqfff0z7rG33MQDT3PoXs24bG5jQUOH
	KJxBI4BOj3cYq28Nzvn4VmOj66/wgcYdxvMoLfbpA+cad/9aG7pJH+cyx4iUWw==
X-Gm-Gg: AYBFou0zFmWiPhC2mqRmp7Dh7KkMpgM53FVzahRf0SwpQ2rIANAhh1bOyqCFo7nHzoh
	F+sZUkY10UDu6VcfrOaUIkpmcvhOwyucUUfa40ZLTavYofoaE0yrAtHLX1iaxD6DDidReBYIInx
	a9plLNI06xRlI5tdvvu25SHJU3m+ZVX1j9Th1DnC7a/1FwpkRukaRpwmXv1kHbCOA5KL1cs4Nz5
	i7qIM/8HOk9+bpZHgpXxJibLayWH+f4ZERrt0XZk61JUcJgsOeWAmXRbnQFyl6EIfWcK4aLGza2
	0ugrWTgsoc2NhEUblmVeRh+IdTV/tizu3vO/0An2bZdEY69OynhJRrtkDm79aBCzJjD+2WIefe6
	jA0ifQrAaqRsVYvozQXSLbwFZm96ta8ARa0DeLE7dOgS+5FUzlya9G0xy2rYuY7IyHSU2oi3sVM
	1Sc94V9I4+6kXzSpuxahAQ+2R4E8JIFTtjRWAyZ+pWvtjUtH0v047mj6ShDzqEgBYe/wKnuh+b7
	ACPQMV/QeqrdxazdqQJo1KeL6C1WQutBlt3y4Tm0Q0k52BfQ3tZJyfAueUJC7+kZhqN843tXVMX
	xYnvZRYerxO65l/aYFLRbMnuCbI/rQ/aJ2nCuz01gdHVvYkW/4eoWIrITKfrxWNoa1AEGA==
X-Received: by 2002:a05:6a21:6e01:b0:3de:79fe:13f with SMTP id adf61e73a8af0-3f7a7bc1ad1mr5150361637.38.1794667903897;
        Sat, 14 Nov 2026 06:51:43 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cddc1873531sm2424369a12.10.2026.11.14.06.51.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 14 Nov 2026 06:51:43 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>,
	Jihan LIN <linjh22s@gmail.com>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: [RFC PATCH v4 12/18] mm/swap: bound synchronous discard outside the allocation reader
Date: Sat, 14 Nov 2026 22:51:24 +0800
Message-ID: <19155551d5c520add74b25f8d50d22fb890e3fbb.1794666741.git.lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1794666741.git.lianux.mm@gmail.com>
References: <cover.1794666741.git.lianux.mm@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2A4251C0005
X-Stat-Signature: pjigzkfwkrda87icuso1ecxygz865ewf
X-Rspam-User: 
X-HE-Tag: 1794667905-776393
X-HE-Meta: U2FsdGVkX19tBvVuPtoILtDrO1fG8AYmlVIQaX2XmrlTeEImGETv+VTcTAZ+G1fGMyxQnfRGlqLD96pnLXOdWV7y2BHgZsV/WXbUic0fBJit+66ubw56E1aIYWY9rmrHQC+huIWsxvCfRzRTqIC2e+9QAFKTvSviq8RxDRuheLrUF3KVIpOZzvQbj/+ePT5Z9UNex2J/tAgFnqOowrS9sVq9AfjhMSspZpPf3pcdAs2Ki9xBUAXqUTFLZh0URX6RfdDv3pyaS5ZcOMaZQsSdto/29/s+4/pVWhQFmdiSK+wlQDXY0TtINjIq8Cdu6iBl7NVcWuGtlklGkfaXrGeunJFjMfcEpc/Do5mtqMCzN2/wtP67zVEmsZyIYd+PHunYrjDlbA79rYpkdMev8DbbdrvcNkEBjwCr69plrhlTGf8wsAwLIIMj8cTYV6mEvxfN22htBYwxNOI+TGxwXePRjZPRpUP0WJtHgRUbXE/jRprjR3xawjZPnXrZQByIUAiYIVBdAFtm5+88+SMGY399xhr7nGUCKl2NXoIsxicpQDbBkVYDTzQnPXXM1jcYEEPiw+AwxVHHuHC0stT+VNr9febOfZpO9ExZUeLgQpaUiWR/9azVZqvJHbaHseRgbFLI5WiaFR8yUh87w8UCa9BMov/W2TTrl4qef3NZP9GMedWJ+zadSK3xdkuDsSe4sxozIJED7Fo7NaYyeFL30XRF8fwfYp7stcQK7NxeM2TKi/7rk89/ij08c0VF1k9Isowh2k6hulA9ZvLcWRbC2JqoFTxN5YWFXpfp50/4tmSIqkOXw51gkSLRsMI9F2ntaHUb2F2g3ZR4R5HmCS3NcLLiL7TfgvL8Z/+eVr7bKJBEepGRqxKXUHWQ2VeV6Hdqw/0hdJe8usHbSDduaxVuYCrLxFfOO1lTN9Dl8QaaADCTvMfddA0C6N6bTSkCoo4yGZu1hk00kYQ7gN5zpMo8K4W
 zsv0Lwqe
 33+Ougs3J/Xj2OmSMibD15SWS9IA/pXudg0We/Iq629zyFHN/B5/Lt0Hridpanrk5JZL71fOaYw5gAlVI9YsnU/ebCvbQYnANeiM+FC1/T8Q9iBIcDye9dVjU3rWJYze4wTIjIBw69d5+sTOJkxpY8re+QqoWVqArDkX4hMXNx/7jmK1L11IQeAZTSYXeB4cEUlbHe5mtX3Jj5FqO5jfWPv2se5aZyLfNMthJ81cl1mHUsX5RDQlxD2Nprn8xXQ1ZBy82SHrj4f/MQOHxgNknFvNhrJIH14eM+eCp1eFo0WdG2KGjGer2THY5MhmmOsmDZxXgXdnm3p/7MLWtTd6occwNvoGusiZmio0mRm+jKsU9XtUG3BVFqjb4eZcEFaOOkSQdfobApliD8fqdBNDH1EVhDa1DSuF5THPAjOo00+wI3X3By6YQbBnbj7FHFJt2PymQJirKpGkcKFTRlmYIHN16V/9n4sSthLxoBciZZOm8ZQ44sTOq9tliyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

The synchronous discard fallback drains a list that freeing paths can
keep replenishing. Limit each foreground step to one cluster, retaining
CLUSTER_FLAG_DISCARD while I/O is in flight and returning the cluster to
the free list only after completion. The background worker continues to
process the remaining list.

Keep synchronous discard outside the topology reader. Enter this fallback
only after a complete normal order-0 allocation walk fails. A higher-
priority device with only pending discard work does not force synchronous
I/O if a lower-priority device satisfies that walk.

Find a writable discard-capable device under the reader and take its live
reference, then release the reader before issuing I/O. Drop the reference
after completion and restart allocation with a fresh cursor, so a
concurrent topology change cannot leave stale ring state. This also sees
discard work produced by the preceding reclaim scans.

Track the swap types already processed during this folio allocation and
check each candidate at most once per fallback search. An empty check
does not consume the I/O budget. Each swap type can complete at most one
synchronous cluster discard, bounding successful retries by MAX_SWAPFILES
even if membership changes. Do not keep discarding until this task wins
a free cluster from a peer.

Large folios retain the existing same-priority retry and split boundary;
their reader-held cluster walk does not issue synchronous discard. The
budget bounds work count, not device I/O completion latency.

Link: https://lore.kernel.org/all/CAMgjq7CsYhEjvtN85XGkrONYAJxve7gG593TFeOGV-oax++kWA@mail.gmail.com/
Signed-off-by: Kairui Song <kasong@tencent.com>
Co-developed-by: Lian Wang <lianux.mm@gmail.com>
Signed-off-by: Lian Wang <lianux.mm@gmail.com>
---
 mm/swapfile.c | 175 ++++++++++++++++++++++++++++----------------------
 1 file changed, 100 insertions(+), 75 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 5c5e449e9da3..6b2dbaf33cb6 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -6,6 +6,7 @@
  *  Swap reorganised 29.12.95, Stephen Tweedie
  */
 
+#include <linux/bitmap.h>
 #include <linux/blkdev.h>
 #include <linux/mm.h>
 #include <linux/sched/mm.h>
@@ -585,6 +586,26 @@ static long swap_usage_in_pages(struct swap_info_struct *si)
 	return atomic_long_read(&si->inuse_pages) & SWAP_USAGE_COUNTER_MASK;
 }
 
+/*
+ * Serialize the allocation on single CPU or globally to avoid
+ * fragmentation and make the workflow easier to follow.
+ */
+static void swap_alloc_lock_device(struct swap_info_struct *si)
+{
+	if (si->flags & SWP_SOLIDSTATE)
+		local_lock(&si->percpu_cluster->lock);
+	else
+		spin_lock(&si->global_cluster->lock);
+}
+
+static void swap_alloc_unlock_device(struct swap_info_struct *si)
+{
+	if (si->flags & SWP_SOLIDSTATE)
+		local_unlock(&si->percpu_cluster->lock);
+	else
+		spin_unlock(&si->global_cluster->lock);
+}
+
 /* Reclaim the swap entry anyway if possible */
 #define TTRS_ANYWAY		0x1
 /*
@@ -916,12 +937,8 @@ static int swap_cluster_alloc_table(struct swap_info_struct *si,
 
 lock:
 	if (!locked) {
-		if (si) {
-			if (si->flags & SWP_SOLIDSTATE)
-				local_lock(&si->percpu_cluster->lock);
-			else
-				spin_lock(&si->global_cluster->lock);
-		}
+		if (si)
+			swap_alloc_lock_device(si);
 		spin_lock(&ci->lock);
 	}
 	lockdep_assert_held(&ci->lock);
@@ -1024,10 +1041,7 @@ swap_cluster_populate(struct swap_info_struct *si,
 	 * which could give allocator hooks and failure cleanup reserve access.
 	 */
 	spin_unlock(&ci->lock);
-	if (si->flags & SWP_SOLIDSTATE)
-		local_unlock(&si->percpu_cluster->lock);
-	else
-		spin_unlock(&si->global_cluster->lock);
+	swap_alloc_unlock_device(si);
 
 	gfp = (GFP_KERNEL | __GFP_HIGH | __GFP_NOMEMALLOC) &
 		~__GFP_DIRECT_RECLAIM;
@@ -1134,44 +1148,40 @@ static struct swap_cluster_info *isolate_lock_cluster(
 }
 
 /*
- * Doing discard actually. After a cluster discard is finished, the cluster
- * will be added to free cluster list. Discard cluster is a bit special as
- * they don't participate in allocation or reclaim, so clusters marked as
- * CLUSTER_FLAG_DISCARD must remain off-list or on discard list.
+ * Discard one cluster. After the discard is finished, the cluster will be
+ * added to the free cluster list. Discard clusters are special because they
+ * don't participate in allocation or reclaim, so CLUSTER_FLAG_DISCARD must
+ * remain set while a cluster is either queued or being discarded.
  */
-static bool swap_do_scheduled_discard(struct swap_info_struct *si)
+static bool swap_discard_one_cluster(struct swap_info_struct *si)
 {
 	struct swap_cluster_info *ci;
-	bool ret = false;
 	unsigned int idx;
 
 	spin_lock(&si->lock);
-	while (!list_empty(&si->discard_clusters)) {
-		ci = list_first_entry(&si->discard_clusters, struct swap_cluster_info, list);
-		/*
-		 * Delete the cluster from list to prepare for discard, but keep
-		 * the CLUSTER_FLAG_DISCARD flag, there could be percpu_cluster
-		 * pointing to it, or ran into by relocate_cluster.
-		 */
-		list_del(&ci->list);
-		idx = cluster_index(si, ci);
+	if (list_empty(&si->discard_clusters)) {
 		spin_unlock(&si->lock);
-		discard_swap_cluster(si, idx * SWAPFILE_CLUSTER,
-				SWAPFILE_CLUSTER);
-
-		spin_lock(&ci->lock);
-		/*
-		 * Discard is done, clear its flags as it's off-list, then
-		 * return the cluster to allocation list.
-		 */
-		ci->flags = CLUSTER_FLAG_NONE;
-		__free_cluster(si, ci);
-		spin_unlock(&ci->lock);
-		ret = true;
-		spin_lock(&si->lock);
+		return false;
 	}
+
+	ci = list_first_entry(&si->discard_clusters,
+			      struct swap_cluster_info, list);
+	/*
+	 * Delete the cluster from the list, but keep CLUSTER_FLAG_DISCARD
+	 * set while the discard is in flight. A percpu cluster may still
+	 * point to it, or relocate_cluster() may encounter it.
+	 */
+	list_del(&ci->list);
+	idx = cluster_index(si, ci);
 	spin_unlock(&si->lock);
-	return ret;
+
+	discard_swap_cluster(si, idx * SWAPFILE_CLUSTER, SWAPFILE_CLUSTER);
+
+	spin_lock(&ci->lock);
+	ci->flags = CLUSTER_FLAG_NONE;
+	__free_cluster(si, ci);
+	spin_unlock(&ci->lock);
+	return true;
 }
 
 static void swap_discard_work(struct work_struct *work)
@@ -1180,7 +1190,8 @@ static void swap_discard_work(struct work_struct *work)
 
 	si = container_of(work, struct swap_info_struct, discard_work);
 
-	swap_do_scheduled_discard(si);
+	while (swap_discard_one_cluster(si))
+		cond_resched();
 }
 
 static void swap_users_ref_free(struct percpu_ref *ref)
@@ -1609,15 +1620,11 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 	if (order && !(si->flags & SWP_BLKDEV))
 		return 0;
 
-	if (si->flags & SWP_SOLIDSTATE) {
-		/* Fast path using per CPU cluster */
-		local_lock(&si->percpu_cluster->lock);
+	swap_alloc_lock_device(si);
+	if (si->flags & SWP_SOLIDSTATE)
 		offset = __this_cpu_read(si->percpu_cluster->next[order]);
-	} else {
-		/* Serialize HDD SWAP allocation for each device. */
-		spin_lock(&si->global_cluster->lock);
+	else
 		offset = si->global_cluster->next[order];
-	}
 
 	if (offset != SWAP_ENTRY_INVALID) {
 		ci = swap_cluster_lock(si, offset);
@@ -1685,10 +1692,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 			goto done;
 	}
 done:
-	if (si->flags & SWP_SOLIDSTATE)
-		local_unlock(&si->percpu_cluster->lock);
-	else
-		spin_unlock(&si->global_cluster->lock);
+	swap_alloc_unlock_device(si);
 
 	return found;
 }
@@ -1883,33 +1887,50 @@ static int swap_alloc_entry(struct folio *folio)
 }
 
 /*
- * Discard pending clusters in a synchronized way when under high pressure.
- * Return: true if any cluster is discarded.
+ * Discard outside the topology reader, holding only the selected device's
+ * live reference across I/O. Each successful retry starts a fresh queue walk.
  */
-static bool swap_sync_discard(void)
+static bool swap_discard_for_alloc(unsigned long *discarded)
 {
-	bool ret = false;
-	struct swap_info_struct *si, *next;
+	DECLARE_BITMAP(checked, MAX_SWAPFILES) = {};
+	struct swap_info_struct *si, *candidate;
+	unsigned int i, j;
+	bool done;
+	int type;
 
-	percpu_down_read(&swapon_rwsem);
-start_over:
-	plist_for_each_entry_safe(si, next, &swap_active_head, list) {
-		percpu_up_read(&swapon_rwsem);
-		if (get_swap_device_info(si)) {
-			if (si->flags & SWP_PAGE_DISCARD)
-				ret = swap_do_scheduled_discard(si);
-			put_swap_device(si);
+	for (;;) {
+		candidate = NULL;
+		percpu_down_read(&swapon_rwsem);
+		for (i = 0; i < swap_queue_len && !candidate; i++) {
+			struct swap_prio_ring *ring = swap_queue[i];
+
+			for (j = 0; j < ring->size; j++) {
+				si = swap_device_unmask_ptr(READ_ONCE(ring->dev[j]));
+				type = si->type;
+				if (test_bit(type, discarded) || test_bit(type, checked))
+					continue;
+				__set_bit(type, checked);
+				if ((READ_ONCE(si->flags) & (SWP_WRITEOK | SWP_PAGE_DISCARD)) !=
+				    (SWP_WRITEOK | SWP_PAGE_DISCARD))
+					continue;
+				if (get_swap_device_info(si)) {
+					candidate = si;
+					break;
+				}
+			}
 		}
-		if (ret)
-			return true;
+		percpu_up_read(&swapon_rwsem);
+		if (!candidate)
+			return false;
 
-		percpu_down_read(&swapon_rwsem);
-		if (plist_node_empty(&next->list))
-			goto start_over;
+		type = candidate->type;
+		done = swap_discard_one_cluster(candidate);
+		if (done)
+			__set_bit(type, discarded);
+		put_swap_device(candidate);
+		if (done)
+			return true;
 	}
-	percpu_up_read(&swapon_rwsem);
-
-	return false;
 }
 
 static int swap_extend_table_alloc(struct swap_info_struct *si,
@@ -2213,12 +2234,16 @@ int folio_alloc_swap(struct folio *folio)
 		}
 	}
 
-again:
 	swap_alloc_entry(folio);
 
 	if (!order && unlikely(!folio_test_swapcache(folio))) {
-		if (swap_sync_discard())
-			goto again;
+		DECLARE_BITMAP(discarded, MAX_SWAPFILES) = {};
+
+		while (swap_discard_for_alloc(discarded)) {
+			swap_alloc_entry(folio);
+			if (folio_test_swapcache(folio))
+				break;
+		}
 	}
 
 	/* Need to call this even if allocation failed, for MEMCG_SWAP_FAIL. */

