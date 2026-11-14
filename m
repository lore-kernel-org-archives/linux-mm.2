Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 442B2606A880
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 20:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jEMY2NSM
Received: by kanga.kvack.org (Postfix)
	id 2E20A6B05EC; Sat, 14 Nov 2026 15:09:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 292876B05ED; Sat, 14 Nov 2026 15:09:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15A956B05EE; Sat, 14 Nov 2026 15:09:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DCC026B05EC
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 15:09:20 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 687291403CF
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:09:20 +0000 (UTC)
X-FDA: 85434814080.15.453582C
Received: from relay.hostedemail.com (unirelay02 [10.200.18.65])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6DA6F40006
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:09:18 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794686958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uIRwXEY8t6lxZie5eRJ2gJ12wOqgQ5rH5E9FXBP912I=;
	b=0BkGu+sSUUwO5UGAQawzbEsBHlll2NNmqMcPjWyTePzFybN7UUcHEmh1rHAddKeAL5+B/3
	wGYovkXXTVuDNJ2DU35icSdpbU1hQQ5e/DdK6fb3ioAbUy/uswlFCEwswedkGUSZ9w0cz4
	GkjqcD3UDdfkTXW2fzi20Jrs1p8Xlq4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794686958;
	b=c7JQjYfDEDagVkyUq8hYU3a2nQ696VVVJzTmzM3ua0ZZXaraXr9xOpayjdV7q4OXGWhIOT
	xwqnC58DybVKvELAIxbu4/3QUOc7WoSnq5DMrhZ9dQpM8r2ohnEIJVCGt4ZlswCXz+Mc8+
	QkkXoeFjQ2HbN0UERl0mbpfYb8NNsus=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
Received: from relay.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 06E4412045C
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:09:17 +0000 (UTC)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C68611A0419
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:09:17 +0000 (UTC)
X-FDA: 85434813954.20.9D5CEC0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2E01380006
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:09:16 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794686956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uIRwXEY8t6lxZie5eRJ2gJ12wOqgQ5rH5E9FXBP912I=;
	b=Zonm/PHB4v4coPHWrZfvFj8Q8hr2Sm453AxV+g0zfgPorGGq6HFm9Nwu0Q2GL4OdNCWMPS
	A35Wz84BOXoNXJQkNZApWBPtgD+i2eeaE2aLgyNJylaQNjVbjztugsO83lT7KJhAqxzKR+
	arzjMEyxvmreugk8B76JoRaEK8JemAs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jEMY2NSM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794686956;
	b=IR/lW9MFsbuLU54MyQ468tzfwHbMaOSVqQyQbMLCfWuUGVe6ma3AWIP3SLiaCLMMcZ1mQ3
	PvDeyn9xxCKABaqKZRQ+v3qaxGpAJbivi9BSC2GOzE3PqkdJTIn4bEIqm03Za1gdvG6RzJ
	Ajwqikvh6V+gI3Jqm+xZUEOX3wRAwm0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 503C94358E;
	Sat, 14 Nov 2026 20:09:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 769201F000C9;
	Sat, 14 Nov 2026 20:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794686955;
	bh=uIRwXEY8t6lxZie5eRJ2gJ12wOqgQ5rH5E9FXBP912I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jEMY2NSMQuKsUV0FCMZPZQChvPBUaiY29GE2Gvoyn3ga9XETKYhFFTXzmGmVg3RQ1
	 /w/24t9blmKo2IURjQJhXNkJ2A5jwyWcbXZtlGM6mqkddGchzavRXCW15jJvfitnMO
	 UPqVPPaFPDh+3qH8csqVHQCT4zLhqCv+WhkhXih1lAGnfXu9g2VQI5SO/vE78k3/sV
	 Jfv3RRsWSnOltMRlPGsZX5KvspN01ilxlGqEI95wDgS+9W2ifMxSO2E8My8p4rf/0k
	 /dbKJLP74qtzIQrG1lUcneeKkaZ9CAfXOjuutRbdBf22sm9LKMVl21wyWSU5xzwOAF
	 +mO86AUdWYd7w==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	hannes@cmpxchg.org,
	hui.zhu@linux.dev,
	kasong@tencent.com,
	kunwu.chan@gmail.com,
	liam@infradead.org,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	liuxiang.277@bytedance.com,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	mhocko@suse.com,
	qi.zheng@linux.dev,
	ridong.chen@linux.dev,
	rppt@kernel.org,
	ryncsn@gmail.com,
	shakeel.butt@linux.dev,
	surenb@google.com,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	zhuhui@kylinos.cn,
	sidchintamaneni@gmail.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [PATCH v9 12/16] mm/mglru: Restrict eviction accounting to eligible zones
Date: Sun, 15 Nov 2026 04:07:59 +0800
Message-Id: <20261114200803.23129-13-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261114200803.23129-1-baohua@kernel.org>
References: <20261114200803.23129-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HE-Meta: U2FsdGVkX1+U1MabUPkd+cBU4JzEMEC8/H7F/fsng2F1HpHX9bAS+TXIOIfdJQAA09FWBlq0g5C+fpqmgyIZ+i4FUlI+LujC3Xxvk25eFDdI1WQB7GKwVGp1ltcfKKfJmFuKeGsfvVPsUvW8262DL4zZcAcxPgnUuQpj5LVdAlmrQiPKr3ekgu4w5jnAnwox2n2hxnyY85sJiA/qx+b19PCmgaQayiVlIbpIVTgXBgz30dZkWP/Bc/QsSxugxmtjHPi15CbT20XRYJP/hwr+X4nZlv3ujMGfxYBrdzb1Hj0ncbN/Q3JYFtLD4qpOLm+qjr8HiSJHjIcwj+36feUOjdIv0qvZIGGsDjwUFLV3/9pS3V1SUFWWSWTyCzyXQDLPtkOiK4gjm8whjVZmx4g/sadJ1DiaiQF+Oxugz4fV/EHJPsF3vCUIfqZ/hDZCf64SksSpLMmvANnSll2rPrx3sbxdff2a1kFeG13gZnZk3fYxDzlxKdSzIg/WCdvZ/qinK2sCrrvT2mezI+e0sw551PGtDx8r5Q6ukfg7t9DBsT1Ul+qmBlCOM2rB4AzZNn1QLjhY7pROigHzeG1sz7d0nuTdiRjyhnmuBOlaFqCUZ45MNfkfkYIroixu5SUPdWzTFeXVMfhu/+KHPAVTtCndD/eKdRZkpaHWL7jPucteRz9nNyMgKgm2taTL9XPF0iRTkguL4qikbVSLdHg4HFXzl5TIzztZZ4xzzlrJckWIRDGLfaGoAbu5kyduJy7bJLoex7TvS2exx42TnGhqGux3XR3aBSMc21YSpwhyGZwP3+8U0gXNPIGhQ4XOOE1H+b15E3iz9iEQC06v/YDiRc2OK9KssdRc82RU7uAqjMGJ26pn0N1An8IfK3AbCIsseq0DwGjz6YIMzJ34rh/njctjAybhxb5gVJzUA4A3eaykEuUUccwc+p89zFcC9/w7Wi2z6Z6fg/7PdVY5u7CMAS3
 uoJT9Gka
 VLMaKEzwwZ/lPopVrA2nVguCIPMELr7YWPb9xFbSWbW8XRO0OJmcrBxsYqx2eoPfxoGZLg1VKMRmxDsywp48iqDu/S6Any4XTigZMW18ZqHm3qKTL5o/oHqmzot089joYaDpsfjBv6/QYNSHhSdpUGw4M+gcNqI3a9myztOKCD6qLRuRZ1hfkaJglfesnzSrATNzReLyyiz0hc5m0ZkQWXVQInty6d6IPE7lHDEsJy8SQtFYN/52SNTsLNZLnFz/NZmAyUI+GUcvw+cyx9ztnAEdxLgQABTn3dQIgLIv4M1ZPS8UdPyE+ABEcWzKu1n3iZQJROZA0lkmkz1o=
X-Rspamd-Server: rspam06
X-Stat-Signature: s1tk5q8cqft866gkjq9z38dpzwiyfa57
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag-Orig: 1794686956-273690
X-Rspamd-Queue-Id: 6DA6F40006
X-Rspam-User: 
X-HE-Tag: 1794686958-820448
X-HE-Meta: U2FsdGVkX18Mh1qlhRlmfdhQMgOGwzOkdKBxlRMVrir4GmajKbG1kHpVh5pP06WgFbPcrLkO/MwOyAWqcCKD+GJjMFLnlV+DDg8306ciG/wQWKvhpls8ycdR0cPE+hpHXBLbAUOGjk9eb5dN+m74QoJ6yXfzit8RgEY94Lj36CcLYpCtHE0pqETTAbbMb2BzrXKo67G0DD12Ee/CmBmPGOwQrKPh46toFWVi3AZEQQ8WLCKnP61l2Q7RkanHOcNz92HQUL+ML2NrFkRXG3IWMny60NJ8rYM/r5xubkMQxwzQw6SAuIE5jO9T2P6nJi2U1VqMmHcSlj6U1HYAD/a38CgS2S9kvA+DeHHwKjm1BgFkoliPvfB5daE7WgeHga2dYJ4nGONsZBApRlB2moAz+e5pA5lXM/bQ/WCrgucyyKY++QMsidqoq1YbBAm28rTizWJ7dBjYmkF+TwMnSkvjQKFh0//BDvsiKQU6AguhKUHj3vybV4ajfISMtCcs8Hj+zbpF6upCKFQA6OZtWhY1DvQVghOhAR4idOh/7glgRhWA2gDe1Vpf9F2dQzS0mSeuTDIdppVrvOL1Nai5hBf0PwnhoZNXjcIT6a+3LUUlIWO6yPdQ/1ViGQ+tRxOiKXsU6UPClXXkxobObFDIPOsBFcAw5PxE7EeHbTARKjwnRshowwR9mm9xJQ/T6DePyApDSnxYgcH0i9nDMxEgKLmhlYq2hNh4uUfAo5bFCqgLRhGWEf4mVMqvWzPg+Ngdwg/n9FRBkJFOdmTFCv4WsS3myEgaMhWlXinNxs99YFkfcnaZZgCw1Pgv61AK2MvytABYNbjLDtPqmZlZWGvaV491lmSbHd97HdQ1TBM0bhK1B47QfHypv0Rlo9CwoHYyT6mxwX+0fbAeGSKXJu9FaG8SaR5FXt6EQCFXOObngPIFskWjHYigvU42jE1d3Q+Z8whwaEXrqH1Xu1Q/o0jz7GY
 IcHQubY3
 +KMYWrSYQaUluNJ5j7p2ol/KD/pZTOaS1SqeWiZTp9PVvLKVeS7iuvcxkSDYbMn5EarcPQ91+JoWnAtuA81nZE3Y98AhSlEBjbKexxt5WB2QR8kTeEvqVFHcPIDy1q4esJ1pmzi7/bWEQ39Juzj9UOSxWHEK8HrTp/aiD2ESzma8w/xeCwQizpTpvmwnt6xZcsKLtJgyrzNexA4PW7XgYP1CaxMEPPV+cI3yHV4z4PLVEwaBFomfNY//Mfczn1pVfjlVlifBnwZ0zkvDQpO92zPk1aIJzAEI8+C4jJDUrzLhbmXob7mBj1vALIh8nj2MmONDc6Hco2+UNKNme1WV7clP6bbvSrK1Ou679dv2pGABnHw48WvA7tUl8LQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

For both lruvec_evictable_size() and lru_gen_imbalanced(),
only count eligible zones up to sc->reclaim_idx. This avoids
overestimating the number of pages available for scanning and
allows aging to proceed more promptly when eligible zones
contain few folios.

lru_gen_age_node() uses lruvec_is_reclaimable() to determine
whether any memcg has generations old enough to reclaim under
min_ttl. If none are reclaimable, it may trigger OOM. However,
lruvec_is_reclaimable() also uses lruvec_is_sizable() to
estimate the LRU size.

Previously, lruvec_is_sizable() counted folios across all zones.
With accounting now restricted to zones up to sc->reclaim_idx,
the estimated size may be significantly smaller, potentially
leading to premature OOM.

To avoid this and simplify the implementation, allow
lru_gen_age_node() to count folios from all zones.

Note that min_ttl currently has several issues and does not
work as expected.

First, reclaim does not enforce min_ttl on a per-memcg basis,
so folios from memcgs whose generations are all younger than
min_ttl can still be reclaimed.

Second, the LRU size check is coupled with the min_ttl check,
which can lead to premature OOM. For example, consider a system
with 100 memcgs, each containing fewer than 16 MB of evictable
folios. At priority 12, shifting each memcg's LRU size by
sc->priority can yield zero, causing all memcgs to be considered
unreclaimable even if their generations are older than min_ttl.

These issues should be addressed in a separate patch series
rather than as part of this eviction accounting change.

Co-developed-by: Bo Zhang <zhangbo56@xiaomi.com>
Signed-off-by: Bo Zhang <zhangbo56@xiaomi.com>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/trace_vmscan.h |  4 ++--
 mm/vmscan.c       | 27 +++++++++++++++------------
 mm/vmscan.h       |  7 ++++---
 3 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/mm/trace_vmscan.h b/mm/trace_vmscan.h
index 565c56428364..9dafdb5bd3ce 100644
--- a/mm/trace_vmscan.h
+++ b/mm/trace_vmscan.h
@@ -488,9 +488,9 @@ TRACE_EVENT(mm_mglru_aging,
 			unsigned long seq = max_seq - MAX_NR_GENS + 1 + i;
 
 			__entry->nr_anon[i] =
-				lruvec_gen_size(lrugen, LRU_GEN_ANON, seq);
+				lruvec_gen_size(lrugen, LRU_GEN_ANON, seq, MAX_NR_ZONES);
 			__entry->nr_file[i] =
-				lruvec_gen_size(lrugen, LRU_GEN_FILE, seq);
+				lruvec_gen_size(lrugen, LRU_GEN_FILE, seq, MAX_NR_ZONES);
 		}
 		__entry->nid = lruvec_pgdat(lruvec)->node_id;
 		__entry->priority = sc->priority;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 6d942f192e63..c9e22a5cbb51 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4207,8 +4207,9 @@ static void set_initial_priority(struct pglist_data *pgdat, struct scan_control
 	sc->priority = clamp(priority, DEF_PRIORITY / 2, DEF_PRIORITY);
 }
 
-static void lruvec_evictable_size(struct lruvec *lruvec, int swappiness,
-				  unsigned long nr[])
+static void lruvec_evictable_size(struct lruvec *lruvec, struct scan_control *sc,
+				  int swappiness, unsigned long nr[],
+				  int max_zone)
 {
 	int type;
 	unsigned long seq;
@@ -4221,16 +4222,17 @@ static void lruvec_evictable_size(struct lruvec *lruvec, int swappiness,
 
 	for_each_evictable_type(type, swappiness) {
 		for (seq = min_seq[type]; seq <= max_seq; seq++)
-			nr[type] += lruvec_gen_size(lrugen, type, seq);
+			nr[type] += lruvec_gen_size(lrugen, type, seq, max_zone);
 	}
 }
 
-static bool lruvec_is_sizable(struct lruvec *lruvec, struct scan_control *sc)
+static bool lruvec_is_sizable(struct lruvec *lruvec, struct scan_control *sc,
+		int max_zone)
 {
 	unsigned long total, sizes[ANON_AND_FILE];
 	int swappiness = get_swappiness(lruvec, sc);
 
-	lruvec_evictable_size(lruvec, swappiness, sizes);
+	lruvec_evictable_size(lruvec, sc, swappiness, sizes, max_zone);
 	total = sizes[LRU_GEN_ANON] + sizes[LRU_GEN_FILE];
 
 	/* whether the size is big enough to be helpful */
@@ -4249,7 +4251,8 @@ static bool lruvec_is_reclaimable(struct lruvec *lruvec, struct scan_control *sc
 	if (mem_cgroup_below_min(NULL, memcg))
 		return false;
 
-	if (!lruvec_is_sizable(lruvec, sc))
+	/* counting all zones to avoid premature OOM */
+	if (!lruvec_is_sizable(lruvec, sc, MAX_NR_ZONES))
 		return false;
 
 	gen = lru_gen_from_seq(evictable_min_seq(min_seq, swappiness));
@@ -5099,9 +5102,9 @@ static bool lru_gen_imbalanced(struct lruvec *lruvec, struct scan_control *sc,
 	for_each_evictable_type(type, swappiness) {
 		unsigned long seq;
 
-		youngest[type] = lruvec_gen_size(lrugen, type, max_seq);
+		youngest[type] = lruvec_gen_size(lrugen, type, max_seq, sc->reclaim_idx + 1);
 		for (seq = min_seq[type]; seq < max_seq; seq++)
-			old[type] += lruvec_gen_size(lrugen, type, seq);
+			old[type] += lruvec_gen_size(lrugen, type, seq, sc->reclaim_idx + 1);
 	}
 
 	/* the vast majority of pages sit in the youngest gen */
@@ -5136,7 +5139,7 @@ static void lru_gen_prepare_scan(struct lruvec *lruvec, struct scan_control *sc,
 {
 	unsigned long total;
 
-	lruvec_evictable_size(lruvec, swappiness, nr_to_scan);
+	lruvec_evictable_size(lruvec, sc, swappiness, nr_to_scan, sc->reclaim_idx + 1);
 	total = nr_to_scan[LRU_GEN_ANON] + nr_to_scan[LRU_GEN_FILE];
 
 	total = apply_proportional_protection(memcg, sc, total);
@@ -5323,7 +5326,7 @@ static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
 	if (need_rotate)
 		return MEMCG_LRU_YOUNG;
 
-	if (lruvec_is_sizable(lruvec, sc))
+	if (lruvec_is_sizable(lruvec, sc, sc->reclaim_idx + 1))
 		return 0;
 
 	/* one retry if too small */
@@ -5853,7 +5856,7 @@ static int lru_gen_seq_show(struct seq_file *m, void *v)
 			char mark = full && seq < min_seq[type] ? 'x' : ' ';
 
 			seq_printf(m, " %10lu%c",
-				   lruvec_gen_size(lrugen, type, seq), mark);
+				   lruvec_gen_size(lrugen, type, seq, MAX_NR_ZONES), mark);
 		}
 
 		seq_putc(m, '\n');
@@ -5906,7 +5909,7 @@ static int run_eviction(struct lruvec *lruvec, unsigned long seq, struct scan_co
 		if (sc->nr_reclaimed >= nr_to_reclaim)
 			return 0;
 
-		lruvec_evictable_size(lruvec, swappiness, nr_to_scan);
+		lruvec_evictable_size(lruvec, sc, swappiness, nr_to_scan, sc->reclaim_idx + 1);
 		lru_gen_balance_scan(lruvec, swappiness,
 				     nr_to_reclaim - sc->nr_reclaimed, nr_to_scan);
 
diff --git a/mm/vmscan.h b/mm/vmscan.h
index c6b583fc7493..c2cea36289f3 100644
--- a/mm/vmscan.h
+++ b/mm/vmscan.h
@@ -117,14 +117,15 @@ struct scan_control {
 };
 
 #ifdef CONFIG_LRU_GEN
-/* The number of pages of @type in the generation @seq, summed over all zones */
+/* Number of pages of @type in generation @seq below @max_zone */
 static inline unsigned long lruvec_gen_size(struct lru_gen_folio *lrugen,
-					    int type, unsigned long seq)
+					    int type, unsigned long seq,
+					    int max_zone)
 {
 	int gen = lru_gen_from_seq(seq);
 	unsigned long size = 0;
 
-	for (int zone = 0; zone < MAX_NR_ZONES; zone++)
+	for (int zone = 0; zone < max_zone; zone++)
 		size += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
 
 	return size;
-- 
2.39.3 (Apple Git-146)



