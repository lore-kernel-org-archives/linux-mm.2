Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB357606A329
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 23:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RzZSB212
Received: by kanga.kvack.org (Postfix)
	id 952DA6B05B2; Mon, 16 Nov 2026 18:23:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92B5E6B05B4; Mon, 16 Nov 2026 18:23:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F3066B05B5; Mon, 16 Nov 2026 18:23:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 57EC96B05B2
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:23:53 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E21DCA7769
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:23:52 +0000 (UTC)
X-FDA: 85442561904.14.D020E18
Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1A94680007
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:23:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=RzZSB212;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.45 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794871431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XWFijJIoHdwN7Yjlw0VcOvBsbcmfGu6udAOAC1ItUeI=;
	b=MnYOEzEeaAA6PHu9itbaNT/Sa/MNAa/8WmtZwHxM6+LtOdVaPVrj2IRLWxsZs4F8cPulJC
	O4HscXdvVTciCJb1CZV15hzzqQwk1htO9sQQ71uII13PkMJysHqfeNTaGO0pwxrHMh+Os5
	s3Fg9La4Qr/gaNkiAvK4ntOL97CD450=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=RzZSB212;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.45 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794871431;
	b=fqmZEQ8C8vxtXE7S3swT/mq6QZLdne2KrQJeIc3Y0ZiseA70hR+6I9tZfoYpIhlntXgOW1
	tBRL7iAhQQ/l8hcz8fK5J4xCeml4bnifD9W2LZPAfC4fGCc9hxXE25c28eF9Po8xWEXKWL
	FOX1W4iVwwUHal95bfyZDl+ut43zJG8=
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-6d290b10a35so1555144eaf.2
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:23:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794871430; x=1795476230; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XWFijJIoHdwN7Yjlw0VcOvBsbcmfGu6udAOAC1ItUeI=;
        b=RzZSB212IbiS9Igk/Kil52qNfSdak7Uq+DJ8ZMoz3ylIrUiYVABBsFjlDOBklhVtOa
         1EyiKMIPWKHLG/drxIGAiBesxtLO51+P8bJy6dmqLbUUSBSH/UzaMM3IgCK1F+AAH1hR
         AkxXG3CM+qns4rYonluEPrLz9haC5QtCY8fHa7WJ8ZMa1Vhs+ws4I7l6gFfOHgLQX85o
         PIio8UrGSo21oiho2+HZ4XkHDRIMqzgtFK3GTIwjBxUGA1RXl9TbBNttrgZ2tEUalY8e
         L38Zmkobm2G0WPdlDvbvZ0etNrTZ4AEaF67Qr6TJhFLzEWBf1U544WRJQkHxVaprzJKs
         4jjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794871430; x=1795476230;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XWFijJIoHdwN7Yjlw0VcOvBsbcmfGu6udAOAC1ItUeI=;
        b=kjvrR2peA0kRP0URXy3BHxaGy/H///lZOV/2nSygks1rR8lWTJz7JP5DxSL1VCHJbF
         LgWe9zZDkjbGPHQ+YlK3GpzPAZ8zZTR8r8W5IKjNUateVDhQnWSZzYEntMIxGTLyt+il
         qeOSiAG01VmrMIagBK81SDvk42pgqMA+C7QTH1RNFHM/g9W80kB9r7pYXeZBnJIstNdK
         JDxYLW6TAWfFeI/GwYokHO6/IcKEnAOJ56vCCCYKSnr4FEX62AZS0v3a40yA+XonDN5y
         BY0mOs07TJdo76h9U8L+Xc8Z8cX9kQDios31ot5kUaXUmprwLM+eBnao+etTzCeE3DSj
         /G0A==
X-Forwarded-Encrypted: i=1; AL+hErFkpWTudtugT5WbUk9XUDqoMJX5sOqN3UQDCZf6Q5+ZcyMhU93BVw+BfsobNzvpeUR6wL/CIRgAHg==@kvack.org
X-Gm-Message-State: APuU4Z+c39qHJSEUnz9QfkMQxW2yOverrdNDYA9AIy9jvX1oLh54dwJX
	WWsBKOGBWhA3TFMNrZ0lDBevMe1zMbdndDWQDyF5nwagI4D+bmHPLu5Q
X-Gm-Gg: AYBFou2Erc6U/89owYPhIj5Ehf0Ut7HDXR/aoDaLvlX40TxDIsK1mCjiFJd12lEdI+E
	BB2CTZiRa61dHBou19sLKozm/encQL6vyf0KyzaqTRi4lD2znbx/YOotjR+kKuk+9givjEWYNJk
	GgD5KfQTjO+TJqb1Lvc0YTGlwbSAsSF/M7vZjkInSwQCINJv49SsiRXkcu/EDsq8CrRJrcUHQom
	qNcNxgAu14SPRQ/izRE6Uo5OWfRAajYive0O/ileuKX/WnW0lspS46D1tsW1RFYOsK/7eLR8/aj
	P2G8KIZ9P8j9cT7L+P73JkLOba7IeZxop4m1RrFNlqH+9AH8kmSntpCsJY0tq1woPLY4JqYUnnQ
	y5UjUtZFDHdHzyCKimFeFbdn9RcFuwM18zPfbeXTkYNAy7CEtvvtx4b6bw8v2XOt1aDjLPwglMp
	yY1jyrO4uzNTMd6gXj0MVkqz56aAbgnG3mPFt+jzNwtXMqKNOoYa9JLQisTDI3gky3XYgTrAZ+5
	K48Wc9zNZQCr/+eWQqBNz+yuao+VOzXJ4Vsi6900YOqeHn/sO+C9EdNCm37YcvfoC+0vLJLM8cI
	vhJ2qLeJWpkL+3EOOryhKHIPSYSYIW3Q9vO1G0ESn3xA9rEacqqZ+AGhG/2Z
X-Received: by 2002:a05:6820:1381:b0:71a:e932:868d with SMTP id 006d021491bc7-71ae9328a11mr3770709eaf.79.1794871430197;
        Mon, 16 Nov 2026 15:23:50 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:59::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-71ae6868fc2sm5390820eaf.2.2026.11.16.15.23.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 15:23:49 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v2 2/3] mm/page_alloc: move the kswapd node skip check into a helper
Date: Mon, 16 Nov 2026 15:23:44 -0800
Message-ID: <20261116232346.788145-3-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261116232346.788145-1-joshua.hahnjy@gmail.com>
References: <20261116232346.788145-1-joshua.hahnjy@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1A94680007
X-Stat-Signature: pqfnxhwe16m4uq3u5yss3ppwe3oamde4
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794871430-653900
X-HE-Meta: U2FsdGVkX18A6KizfU4hn+c1ZVUK6bLGOctkdcBd9vYUCP4LQ15gNvxbKoadyHhT13TUMWpFMsLwJg96kM62GjveN69yv8oxdi/KvqV0RnCzM9tYbshceddXZUAlD5HXUSC0bx5FEOgRlCBrNtY/bzpYyTXrw175toevp9DgeXmUZ/ekAB3vqQEAUg+RWgRVEjpJL38qTR8vete327chhTjZKVdWHl6n5RfaIk/jX6Jn6W9Jso5UvARQtxe7LwLBmLpVf1b5zZQzCGD+DDY4M94nJEN1vQ5wptzvtsw0rE+7IX8FMMZXXe0jo7a11WGGK4A7Fq8+J8JnLgbcyujDdf0Vr8f6wSzYhF1m1osRHaHP1bTiqTLzBjN6k8HXD7YbFUUvLe6OB574jlE9hPs6vwHstJQNYUfCftLrYYl/WWth6ZVpZsDx/Guh8ADjmFiS2xEcho6qQUl5Xajv+3WCdIQrah7kHKsvNflYMOvW9Bzgu9Sb6XKCEnrafYcKwu500FIx8we3WbMNmAQHYlrEXMxbNkTBqxe33KuZTLWAD7ix9lI0U3m33vGiwD/8uJLWcS/PCOs9BQG0rZJ7s9oplZ3kbeTyZcmrsA1mjQzLpp9r0xuTwDSK+1N3dv6PcCZo27EuruKT1iMmjdipK7h2pAWUVTkaBk0YFNgS/4aaBV7kED+t/qxfNlr1Gr/K05Z0hi6GP0Y7tO8J9JRw7HiMPyDZ9V7ecAYItjCKxuKCIJwiXdJaDdBIyPqocR1USr0l/cwfpl2Vt7pBD+CjcPIf+YUFT4+scsKxiLZklMsrT0SjsPQo6Nem8+BAulkRrp7I26pJB+w8Bqhd/lBMtpV//8c3uU+yMjJMkgezUAgTa/kgIJh9mO2FPVg6rVINZ9Om4Yc28G+wyXdoM/VT6PeT0dG+A5dJ/O9N7eRxXs1cD5JfivBu1sOs2i3U5DmQm++Catr4Cv4q4sH8gsIr52r
 6meSaMht
 4zDlTexptL4W2F/gdLMReKbo7FL3KUK0zpbtyQof2+X/K1L5ivEd9E45wwonpI9lXi9VX3VMQI49wPGm8uInDZGV4xO7fu4N7Z2AL7I63e0A8PqFuvqBWbVyFeaQ+EXm2ksFgFEr9CP9Cjfl5JwLGLdxAOUeUYWp/IEJKAtYV4avsZz+TII092P7YjeEIBEh3WZI9iGKDTnxcz6D+Qsg1CPJwRMwteCWu36xxOTm3/q7C4XHkOb6qRqLgz2CDMGyKopSluKubZ6L+wECE/sT1PDnkggowk5ALGp5M3UUvaf9UnY/qUA6P9DTo0F3WGNXVePOn02WiAwG3AxY+gVxPTAY7IfXcmaOz/8ow4X1GIVxcdep2F06xQ78x6NOVQXEfyLuIAmEUB2CPmZJzADO1ejXXkAr4vqPEdUxg+pLYZT1tvPgeO8pDYSn7TQidIXMvc/TYDtscqKS1652+V5ZdsC9xR8MVxyxGsxR/20+jXZ0cU/Iq44L/ZpGITfeBjgAbDQejjDamHB5Plue6RGwrFkk07xM4rSjV4z9t3oHN7RGxLnm0amQ6I6O8r4RGTUxzPcgz/12yAPDbqE/UAg52uGd7ROJCwiDA5zAg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

get_page_from_freelist() checks many conditions for each zone, often
with a big comment block explaining the conditions.

Move the kswapd check and its comment into should_skip_kswapd_zone() to
make the zone iteration cleaner to read.

While moving this, also resolve a checkpatch warning which complains of
a waitqueue_active() call with no corresponding comment explaining why
the lockless use is OK in this case.

No functional change intended.

Reviewed-by: SJ Park <sj@kernel.org>
Reviewed-by: Chris Down <chris@chrisdown.name>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Tested-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/page_alloc.c | 47 +++++++++++++++++++++++++++++------------------
 1 file changed, 29 insertions(+), 18 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 4d829e5eac49d..43929faffb989 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3785,6 +3785,32 @@ static inline unsigned int alloc_flags_cma(gfp_t gfp_mask)
 	return ALLOC_DEFAULT;
 }
 
+/*
+ * If kswapd is already active on a node and the zone is below its kswapd
+ * watermark for this request, keep looking for other nodes that might be idle.
+ * This can happen if another process has NUMA bindings and is causing kswapd
+ * wakeups on only some nodes. Avoid accidental "node_reclaim_mode"-like
+ * behavior in this case.
+ */
+static bool should_skip_kswapd_zone(struct zone *zone, unsigned int order,
+				    const struct alloc_context *ac)
+{
+	unsigned long mark;
+
+	/*
+	 * This means kswapd is asleep, so don't skip the zone. This is a
+	 * lockless check, since a stale result only affects zone selection.
+	 */
+	if (waitqueue_active(&zone->zone_pgdat->kswapd_wait))
+		return false;
+
+	if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
+		mark = promo_wmark_pages(zone);
+	else
+		mark = high_wmark_pages(zone);
+	return !zone_watermark_fast(zone, order, mark, ac->highest_zoneidx, 0);
+}
+
 /*
  * get_page_from_freelist goes through the zonelist trying to allocate
  * a page.
@@ -3796,9 +3822,6 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 	struct zoneref *z;
 	struct zone *zone;
 	struct pglist_data *last_pgdat = NULL;
-	enum zone_watermarks kswapd_watermark =
-		sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING ?
-		WMARK_PROMO : WMARK_HIGH;
 	bool last_pgdat_dirty_ok = false;
 	bool no_fallback;
 	bool skip_kswapd_nodes = nr_online_nodes > 1;
@@ -3865,22 +3888,10 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 			}
 		}
 
-		/*
-		 * If kswapd is already active on a node and the zone is below
-		 * its kswapd watermark for this request, keep looking for
-		 * other nodes that might be idle. This can happen if another
-		 * process has NUMA bindings and is causing kswapd wakeups on
-		 * only some nodes. Avoid accidental "node_reclaim_mode"-like
-		 * behavior in this case.
-		 */
 		if (skip_kswapd_nodes &&
-		    !waitqueue_active(&zone->zone_pgdat->kswapd_wait)) {
-			mark = wmark_pages(zone, kswapd_watermark);
-			if (!zone_watermark_fast(zone, order, mark,
-					ac->highest_zoneidx, 0)) {
-				skipped_kswapd_nodes = true;
-				continue;
-			}
+		    should_skip_kswapd_zone(zone, order, ac)) {
+			skipped_kswapd_nodes = true;
+			continue;
 		}
 
 		cond_accept_memory(zone, order, alloc_flags);
-- 
2.53.1-Meta


