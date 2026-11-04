Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3738606A328
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 09:39:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07CD56B00EF; Wed,  4 Nov 2026 04:39:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02E496B05B3; Wed,  4 Nov 2026 04:39:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E860D6B05B4; Wed,  4 Nov 2026 04:39:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C3BB96B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 04:39:42 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 51760C04BD
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:39:42 +0000 (UTC)
X-FDA: 85396939404.10.60C83FD
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7747E10000B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:39:39 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	spf=pass (imf05.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793785180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=GKas3peospknksB0vSRc5IU2FW9D1srUiUjTUhHUOGk=;
	b=qHixZ/ywZiQyrDEE9t6BNfyfOBw2djMytsfnZXnB55ldeRmkJJvs1VdDZs1UN+Btxsl8a8
	g5zJYNnmn25niPl0Y4aWJqSSkhJaz73v/v/rV3YhO05m+7y9a031RaJAvcYjkq2QVFk/W0
	Kbmp8ECiRDN1Rww+Ut+mJDq2CboNqYo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793785180;
	b=XJSMn5ht8NKwrKloLk0nCNgG+IrUpYtJbbcnHDAgxCwPny29jzd2GrAq2Odp/Ir3mVB/bF
	jOsAakU96zW6TYUVr9m3B2SB7hCoBLzkutNPQEs8y9+Bs4klud/e+x6qMO+sx/Gk0kUx93
	iO+6YzAaOJOejpnQxypTAojL0Wq8wVE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn;
	dmarc=none
X-UUID: a086d4fad83311f19a56ed5b684f684d-20261104
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	SA_TRUSTED, SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS
	DKIM_NOPASS, DMARC_NOPASS, CIE_BAD, CIE_GOOD, CIE_GOOD_SPF
	GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:eb28db4d-434b-490d-8aba-b9882b379760,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:eb28db4d-434b-490d-8aba-b9882b379760,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:c3887dee93015b2c45488bae4be79267,BulkI
	D:261104173930I66NRZ8C,BulkQuantity:0,SF:17|19|38|66|78|102|127|153|865|89
	8,TC:nil,Content:0|15|50|99,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS
	:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,A
	RC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: a086d4fad83311f19a56ed5b684f684d-20261104
X-User: husong@kylinos.cn
Received: from ctao-book [(114.244.3.119)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1667460396; Wed, 04 Nov 2026 17:39:27 +0800
From: Song Hu <husong@kylinos.cn>
To: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org
Cc: david@kernel.org,
	tj@kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Song Hu <husong@kylinos.cn>
Subject: [PATCH] mm: memcontrol: serialize concurrent memory.min/low writes
Date: Wed,  4 Nov 2026 17:39:20 +0800
Message-ID: <20261104093920.2279191-1-husong@kylinos.cn>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: zhe95wwra3p68tubis6bqa4uz77jfgpw
X-Rspamd-Queue-Id: 7747E10000B
X-Rspam-User: 
X-HE-Tag: 1793785179-894946
X-HE-Meta: U2FsdGVkX1/1F51Fv8uRZkC4ZQOBzfrJDaP1qiCFAfumTIBJBFnzSW8XCio2G3X2FSv26FCrDiS7iO+eKDrqAtLt3SU7ewnIxbbEb0eTlD9ssLOda9TGej3bpxLLHqYptxA5m7iETg+VhtJMAs3u5MJZ22AzSE4PtrpA5vyqBCy2Q8du4eR4F8w5i1pK702FQiKA6/KAEubGYcIFRQa9v1xCgy7H+1G6AFPXNY27wB7cOFKLRPoaOzuXSNSFSy5qCA4YGd9bagHrT4ekPe1APIQ/slcoB87YOrUXmiY4OGydKkj3xQzTIatFGoaTvSY5mtzZ8ne92elEZeEjftDM2LMUq+OxcYLPqhAx8Xg2o5dc/iOgp9jbMcAhCd11ndqsCw93/thICZP/AeJaOtB2SAM1Z1QSacwQNHEri5uLWKurUxtTvNaP83jzbuYP/2ueQMLPlHtuTxXTkUpo19/mhr9nd299BMUfymPLqmbYBbKlOQt2d07qadBL3SxZGePcWcqZ1fBw9C5nF0xX9mPiiBQVfVN2X42DkAKc2Cz9BPpeU0P66+TtsVzPm6y6zB2uC6IzMzgInxWZg+ANZg4xaP5T/SlFqD5g0rnS+MbsbX32WAhtdUtjTJKERtysGWyChqkY9Q2YSCeJv4PP/Ceso22PrzDtoaQthBCdec92izOKFA0mkNf28oVUxQ0DsxKfD3jWkWhHHeilR39simnscyHnsgb9ii8bX/i3/CDeWeu6QeBcbLGMUBHYNVWY7ziC1i1wyBWxO+wc7AIkwQTTEYODnjNBQ8thWGTLDBc9NKbbpXzAgaBQwm4kOh66jfCg9t0ZhSUo6nVh+mY3H3LxJnroyM3FdH8xUdtNQOlA5UYhgmbezQoTk9po+Nu03yjbebmxy0YU6VtNyjha2QVjfNj96WMWWusMa1OYRhyuSUUQk//33cP/QnQmBG7+ii3S2J0RwtRxGmhdV/BbDwY
 VO6Ytt/Z
 NWQXS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

page_counter_set_min() and page_counter_set_low() require callers to
serialize updates to the same counter.

The v2 write path does not provide that guarantee: kernfs serializes
only writes through the same struct file, while each echo opens the
file independently, and cgroup_file_write() invokes the handler
directly, so concurrent updates run in parallel.

The store and the subsequent propagation replay are not atomic, and
propagate_protected_usage() recomputes protection accounting from the
current page_counter limits instead of a value captured when the
write started.  Two concurrent updates can therefore interleave such
that the replay associated with an older limit overwrites accounting
computed from the newer one: writer A stores 100, writer B stores 200
and replays, then A's replay runs last and leaves min_usage and the
ancestors' children_min_usage computed from the stale 100 while
counter->min is 200.  The wrong accounting
persists until the next charge or uncharge re-runs the propagation;
an idle group with resident pages never self-heals, and reclaim
meanwhile distributes sibling protection by the wrong numbers.  No
corruption beyond mispriced protection.

Serialize the write handlers with a shared mutex, the same shape the
v1 controller already uses for its limit writes (memcg_max_mutex in
memcontrol-v1.c).  The offline and reset paths, which clear the
limits under cgroup_mutex, take the same mutex, so every memcg
writer of page_counter_set_min()/set_low() ends up serialized.  The
mutex is only ever taken as a leaf in process context, so there is
no ordering hazard.  memory.high and memory.max need no lock:
neither propagates protection, and their setters are already atomic
(a plain store and an xchg respectively).

Fixes: bf8d5d52ffe8 ("memcg: introduce memory.min")
Fixes: 230671533d64 ("mm: memory.low hierarchical behavior")
Signed-off-by: Song Hu <husong@kylinos.cn>
---
 mm/memcontrol.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 84f4a8fd4d16..87ca7bc1aef1 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4458,14 +4458,27 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	return -ENOMEM;
 }
 
+/*
+ * The store-plus-replay sequences of page_counter_set_min() and
+ * page_counter_set_low() must not interleave across writers: a stale
+ * replay can overwrite a newer one and protection accounting stays
+ * wrong until the next charge or uncharge re-runs it.  The walk in
+ * those helpers crosses counters, so this lock has to stay global --
+ * per-cgroup locking would still let a descendant writer and an
+ * ancestor writer race.
+ */
+static DEFINE_MUTEX(memcg_protected_mutex);
+
 static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
 
 	memcg1_css_offline(memcg);
 
+	mutex_lock(&memcg_protected_mutex);
 	page_counter_set_min(&memcg->memory, 0);
 	page_counter_set_low(&memcg->memory, 0);
+	mutex_unlock(&memcg_protected_mutex);
 	page_counter_set_high(&memcg->memory, PAGE_COUNTER_MAX);
 	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
 
@@ -4548,8 +4561,10 @@ static void mem_cgroup_css_reset(struct cgroup_subsys_state *css)
 	page_counter_set_max(&memcg->kmem, PAGE_COUNTER_MAX);
 	page_counter_set_max(&memcg->tcpmem, PAGE_COUNTER_MAX);
 #endif
+	mutex_lock(&memcg_protected_mutex);
 	page_counter_set_min(&memcg->memory, 0);
 	page_counter_set_low(&memcg->memory, 0);
+	mutex_unlock(&memcg_protected_mutex);
 	page_counter_set_high(&memcg->memory, PAGE_COUNTER_MAX);
 	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
 	memcg_wb_domain_size_changed(memcg);
@@ -4924,7 +4939,9 @@ static ssize_t memory_min_write(struct kernfs_open_file *of,
 	if (err)
 		return err;
 
+	mutex_lock(&memcg_protected_mutex);
 	page_counter_set_min(&memcg->memory, min);
+	mutex_unlock(&memcg_protected_mutex);
 
 	return nbytes;
 }
@@ -4947,7 +4964,9 @@ static ssize_t memory_low_write(struct kernfs_open_file *of,
 	if (err)
 		return err;
 
+	mutex_lock(&memcg_protected_mutex);
 	page_counter_set_low(&memcg->memory, low);
+	mutex_unlock(&memcg_protected_mutex);
 
 	return nbytes;
 }
-- 
2.53.0


