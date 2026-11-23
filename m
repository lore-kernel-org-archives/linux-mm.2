Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A030606A327
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 14:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MdfRgJhh
Received: by kanga.kvack.org (Postfix)
	id 457906B05CD; Mon, 23 Nov 2026 09:19:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42F366B05CE; Mon, 23 Nov 2026 09:19:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 346C06B05CF; Mon, 23 Nov 2026 09:19:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 09DE06B05CD
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:19:13 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 842591608C4
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:19:13 +0000 (UTC)
X-FDA: 85466590986.17.25EF8F1
Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	by imf13.hostedemail.com (Postfix) with ESMTP id A994620009
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:19:11 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=MdfRgJhh;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.174 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795443551;
	b=A1a1ikcf4m+oSnYavrlApSaaOtNwl7kfSpHF3hZXtLpOwBIRKohLUohfmAXx3U2xV5u5SN
	e309eVeqGN7ZUu6GC620DCOq/i1RMxoq1DCt5YClgfdQiHzmdu73Vvu+b+bCPMd1ueRu1D
	WnhGr9nUDeU2Ncw4yUVeeadbGTaBAkI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795443551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=77msjR0dRhdtgIkE1HozDHoWzLE9oPsBqEtLLPC0LPg=;
	b=EvBa3SYEN6sdQwG+eom1dB6KDR0YY0bRDZPcuZomkz6qLMZ/s5KO2b/oENYGUcy1ukxBs/
	dy/4KPBZS9l18LvBLNjEwRrj3lD0YDCPKgV4V7tgrpEzccpybxuR4YHcKBWthKik0ov1h0
	bCQ1Oj400MZUQLaIjC/YPPHKnBRs85Q=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=MdfRgJhh;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.174 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-3869b68caecso4373155eec.0
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:19:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795443550; x=1796048350; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=77msjR0dRhdtgIkE1HozDHoWzLE9oPsBqEtLLPC0LPg=;
        b=MdfRgJhhbYV4STXd/wjGHNBFyvhW6lOFDMUABiQscFoHPUYC+lr7zRC49RF6OcblCE
         kt3zJACIlKrjYwn6521cPdbKlGk/pOyOaosbKkz60OcQRTJ1+EvwmDep9kyXyguyR7cr
         IS4CRyyDDhRKzzqr1DdbRbpJxwGdEHCMgfNdmdSRkCD6N0BzKoHzcheu9lb93M4cI5F4
         pXkVxMplATV+OxtLEccEGcUJx8psS1Mp3jJFgfsAs9HwVrdMipWCNVTCIhMLfEke9oNx
         UYBxYK9ZYex85nWxhShWk0VicNt+t7kvX6BKeeqFmSFZ+mzXwkg83+yLqXq7IWlLcNoL
         4ruQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795443550; x=1796048350;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=77msjR0dRhdtgIkE1HozDHoWzLE9oPsBqEtLLPC0LPg=;
        b=T3BwH1dO2ClOK5aFYMun12Nc7oYfZBQmYk16uMclEo19xEWtrHNZfBxRzSsDeohoav
         u6Ap4yN51wdn7M2raGv/WQu0g48c6hbk9bMWPEEGdPfsRm1bEFsonzcvLKwFvTyAeHqu
         0RQBPjQMVS/421HOPHoUfuRQ0I65Jb9uBpPBzWolJYXjDeONC6g7dh9OexwFursTQFlk
         v3wursdECilOLjc4d6gEXk1P6SyNSbx6zFujaTXeHEwxnEsYWzkWUPSRmk9mKNbgrtsi
         C9NmEsNn6kh2e1FPufKqxGu4f+4heUQphrulQWzClmJhDC6K2bb4g+kp+VqS3B2vtRD6
         CppQ==
X-Gm-Message-State: APuU4Z96UiwBGhSmhdjzh06RNlNyzuOlswMtRTFt9/sbW71HxvK1IBBx
	nUtg5gPiaxhzq+mYLoUAqK6rjoV4OlU4mz8NKwdQhiBnukjINr8RdRJ7H5fd0fRJ
X-Gm-Gg: AZFdTZcd6T7Q3RsABmKhhB25aYJSC/OajepidBo2duZWSuqugAqJAqEnkR/6E9NyYvM
	0ic6eR8AQ4gx4ra1flv5xQx37TSIVEzY4c+Ri25xlNNrCFcG+uXLShII55HN0qFnMQIs71kObHu
	VRJoHwAwgtbsQVDZI7Gq425cmzKJj8ZZ14/nXxYt2tCY3pUcjLDF++zh0sOx7xftpdqg7srNg6d
	oM2HdSSGcUwzUKFfBWX90V6gby4fYPAAw1RG+gwrps49vMUhe4aBWjkXm1jn/v5a1D4n8jDu0oG
	pEOsS7BcXTSXZm192c7rOXSWsEvqldWeyvzmP5/E78yaaOtKTbYMkMgvyYsUMqfguZKZGQiqSvW
	uLnxsOGtnxxCW8f/rlxgLL1BiPTL1fU3g3Ib0UIa6wWA92yIAU7lS/z7LHOdLKDlNbjnlb8AWkp
	DGSe+T0RCuYwIanVxpc1oAqlz7oAQwivFgIOpvKjVljxjeGcIINo0RAHrHNeHH4nJqH2fKyfEKy
	61Drnixu6+Er14i7y61nezi7pjQ3iZBohWTQbvCEUe+S09GRzIaoDZLHAEFd3R/hP9+FMtSExIc
	3ywm2P52lS+G0sDqC4/xfcTtu1oWHBkeSw1TpXIQTxLKbji4gS/omRdTHSh/F7LbzOEC
X-Received: by 2002:a05:7300:6da7:b0:384:5885:2f81 with SMTP id 5a478bee46e88-3856c0c7c05mr16726108eec.5.1795443550374;
        Mon, 23 Nov 2026 06:19:10 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-385d2b93dd9sm40230786eec.24.2026.11.23.06.19.02
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Nov 2026 06:19:09 -0800 (PST)
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
Subject: [PATCH v5 13/19] mm/swap: bound synchronous discard outside the allocation reader
Date: Mon, 23 Nov 2026 22:18:58 +0800
Message-ID: <ed722bf572f44133ee44f5b2c3d90f53b99f38e2.1795439990.git.lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1795439990.git.lianux.mm@gmail.com>
References: <cover.1795439990.git.lianux.mm@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A994620009
X-Rspam-User:
X-Stat-Signature: mwfh57afgx8sc68n15ddpyirk9qjb4q6
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795443551-613166
X-HE-Meta: U2FsdGVkX1/a84vH0XNm0cot/uUjTkSGHaEhKHJnwJmYpFmAl1nkcDlh3vFTr7MMmQ6fDDk7kSJPJWn8SZ75WrHjQZidrLpjGmCk2NUTRXoNxRAIsnd8Mw2c72FIGktvrRZVtuHprJNT/ZzgPETsGlxkYLh7j9kylLrY715jBBZUKFL891El+0Y1AYP3F/D594yVB48VvVe882O8iPdqaKYFpWDNGeepuOlvI8wQk+Qlm+2iWmn7oADe4rdsnvt6Tz7p0zY923Uva5vKmo0R0B2ZrDs/P4M9+fMDrGqYsQNWYjOoIHLj2fe5fber8FXHWRy24ahTUpGLvnZNkwgiCsOwCAQupJPnhtdo+IPQxIGBRNAyuDA0ko864pyDxs6EPMgHaPM0Z5magcwkoMN1sEhKspnprFJ+bFVztwR5PMT/h3skDrUo7+A+QsxUGjy6Wy9cZke3nEWAWdnQiBFnyqiwb+O1s4tAbKGAEWhoJYpN1r6jmXKGWNPvNe9LhIrCQh4xbs4Siw/k9JtFlScVdLjJUDXsx3zQLy425idMqN3giNdLorLX0udz9Ht6uyalyldT+4nz82i5AjscMZGT8n5FcLxSwYhJR1dD/0eDYSl068diPdZM3ZLp2nGypv4DdBA7bsU2zRdGcLP6qkF/OPQvARVCBvJRQFJCBj63SVvMn10iLt+y9KARsFrs+MscnmWegRhBe+ruE25mMHC+TEzwuKz+CmHl3J/lm6CWrbUzoQZfDJmhY+qKGwWv0zwWswDkSitvTt6qIzmjPqoOqGjgklJGl+Ngzi16VNvVcyq0SJvS4r7eKO05UDN6/czZyrhU+DdaNe4gENkOEmGhv6oWZC5lWhFyQmfX7zNAEefozHwNt5+ZovxZth7xDfS/m6n9WRyflHwj/uNkxm18a9cIvxlX0WQKCNY3DJutbyoo3aWOqdTSLJWKs7c7++H9xrASIQZ/fVGSeC+xoGg
 ounIyUFb
 6EkPHPxGOh/YIMnwmEFVv2MUJINtv3G4MILV5bFV1CqzALW+PR5h689un+Nj9N16DJpsnsPInFgLnW85/H8vmSLNGTeWT4ruyLSyIAytGjLDXXbpka1kDFBJORp6J+2t/Dj3leJ26xIAyalce+q7a7cn7py27e93igRvd729ecQSRbRvoQIUaL4+1g9ha0KraZskhgqB5FU/xCUq+wBfTD5o9IpwYfxkhC4uNypdoknm2tEjBCLfCjcKIoAJBu4ckHRRJ90dATmBfaLHH4PvJvM7Tc+qGRhAP04liMdbO2XO5iSjj/e580tRvV9NZMebJff/qm3ZAlGelqm2A4qICVUEYPbc/LIMzEyBLkzc4K2QbnFUogZfpAfMFq1wt6Nu1cbqBf3VxQ1Z4Feo6f0GRdmyP9WePUG72P3sx5bKRdhc/1GpxAEqASfOdB2Ela0dQ7M5PmYz1dAA4fTl9pHa4snjIt7hWu3ggw9tJPSkgQT5v3X4UIUTGdAsS7vRSkBXlND6iFHQobB/q7pxxI7CRiCuq/Ziz3mBdq43CiacOV2+JNBchZtyTBxXi2isCP9lxpd9Pvr1Ao7vKPmxZcgWPDITcciNoDlZPK4llpMrXGxE6hQG8eHxlaPgWUFGVyxwJBiFonocuEBlmmPzO/A0FKy9FhHZ6TDAyf7dwIizfKT9ovVTWLr9rQ0Wm0VoxI+RYgKVBqjQyoLY4r7Ms3W96kix8VQ==
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
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Co-developed-by: Lian Wang <lianux.mm@gmail.com>
Signed-off-by: Lian Wang <lianux.mm@gmail.com>
---
 mm/swapfile.c | 175 ++++++++++++++++++++++++++++----------------------
 1 file changed, 100 insertions(+), 75 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 1f31a3ae75d6..d28dd10c92cc 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -6,6 +6,7 @@
  *  Swap reorganised 29.12.95, Stephen Tweedie
  */
 
+#include <linux/bitmap.h>
 #include <linux/blkdev.h>
 #include <linux/mm.h>
 #include <linux/sched/mm.h>
@@ -583,6 +584,26 @@ static long swap_usage_in_pages(struct swap_info_struct *si)
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
@@ -914,12 +935,8 @@ static int swap_cluster_alloc_table(struct swap_info_struct *si,
 
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
@@ -1022,10 +1039,7 @@ swap_cluster_populate(struct swap_info_struct *si,
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
@@ -1132,44 +1146,40 @@ static struct swap_cluster_info *isolate_lock_cluster(
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
@@ -1178,7 +1188,8 @@ static void swap_discard_work(struct work_struct *work)
 
 	si = container_of(work, struct swap_info_struct, discard_work);
 
-	swap_do_scheduled_discard(si);
+	while (swap_discard_one_cluster(si))
+		cond_resched();
 }
 
 static void swap_users_ref_free(struct percpu_ref *ref)
@@ -1607,15 +1618,11 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
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
@@ -1683,10 +1690,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
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
@@ -1881,33 +1885,50 @@ static int swap_alloc_entry(struct folio *folio)
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
@@ -2211,12 +2232,16 @@ int folio_alloc_swap(struct folio *folio)
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

