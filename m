Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 874F7C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 11:12:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6F956B00B0; Mon, 20 Jul 2026 07:12:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A20B36B00B3; Mon, 20 Jul 2026 07:12:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95D226B00B4; Mon, 20 Jul 2026 07:12:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 699626B00B0
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 07:12:19 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EB78E1C001A
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 11:12:18 +0000 (UTC)
X-FDA: 85008891156.26.9E94372
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf21.hostedemail.com (Postfix) with ESMTP id DD34B1C0002
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 11:12:15 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=esRpMR1k;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784545937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qKLNv9nPUB641uxGT2XoWRnvBcDasFEpS3y3304Rfn4=;
	b=Y+pT3sROTseyYu0mi7I0zJNPRS8qSTf+ldCqSkg/7NKnk4gUbtuQjt4r9XIymt3JoyYHke
	LEYyUCVjxra3Ck7lGssyRPuCUKDvij/k4LTLvd8bTPSk5B6dyNb5+iwLGiEYbUBXZQSMIv
	DOxgjLBo9XTcNdNKuuxxChU+gdPE8CI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784545937;
	b=npaiQ5Z4hITB8WbeXjG5k3qVM7UGxWYUcu3eVDnNK08VGIoegy6YrpTpzkhCuLVjkFKRV4
	oZSyeT92vN0AGmWC3Kx19KcnAeb4iZL5/wK0A1iGlwx37z7eOEp4rZQzUu0HELdiCodbwv
	VD1VJv0IEnhYqmd0uAUUq7cFKHmEJGA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=esRpMR1k;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784545932; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=qKLNv9nPUB641uxGT2XoWRnvBcDasFEpS3y3304Rfn4=;
	b=esRpMR1kEiAHW3N+oSGDykh9w2bhXCHAiiA1+RsueG8XoIUsgE1ytYijM6qflcWz5NyZBN5ZqBlSHuUZK8FH3E2Ih9bBl2JQQjkRWKNpOiPyA6v3ZgnU1/6BdvSXxSuX+7OFTK7fsPOn8eTPRGMAWbUXTonbsLYy6RCUBcCEtLQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R391e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0X7THEvy_1784545930;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X7THEvy_1784545930 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 20 Jul 2026 19:12:11 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	hannes@cmpxchg.org
Cc: riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	mhocko@kernel.org,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/3] mm: vmscan: add a helper to identify file-backed executable folios
Date: Mon, 20 Jul 2026 19:12:01 +0800
Message-ID: <2ee74f9f98ac45a2f0db0ceb018e086bdb671d17.1784509721.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1784509721.git.baolin.wang@linux.alibaba.com>
References: <cover.1784509721.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DD34B1C0002
X-Stat-Signature: m3w1rr8sxoadmkab54nn4oaurfbimdca
X-Rspam-User: 
X-HE-Tag: 1784545935-736353
X-HE-Meta: U2FsdGVkX19NMkhtqWIpwbMwI28zXs5K5azP9pjRWLPBi7jUujVA272zFxv322S/Qvp6UcAoRVwmRJCWDj8EWD0qdk8PbdF2Zi8fHf6JvpLMH7FGarKvB4wBxLtWWXS8I94v3F+DfwGcQvNYORMjTTeoGvu/Xuf1Uvcf6p9WBhAuMwWMdo0JAU3sGNcgqEnWcXFIhjvckvh47mMSGUwcc/q7xYe6nfBFUm4/+L5s8vMR4+SPcgRAW/BU2pgMtlN2yP8uKgJ73Pp0F2HeVjZ0l+ChYRykdHJQjrXBwkrZReGGZ4/5JtaDRFEOyLK04Uk7kQPP+Bc9HdAogY17NVA3lwtbOE8Lef1RA6rKuFbc+CXBA+QEzMXaft97wyWLmMqnzspNEQNWHR91KUbQO8JYv1KhIFB0cUbonZdpYy3x7/YOOBzZKgBWXsGX3Lrc9kF408pzAh8Q3VSlUDW+EhBmIJ1N9xDgFXE/yPdPGwCUi9RATS5Znk16QoUFZ6whah/qGr0SOzPelukW3D1pS34BtPR2Ad/VIQY4WGpSIdYpWOOOJ9dYagJLdhV9W90UZd8XJnfuGl6K7GHoSRAiv4weZbnBqrwyHc5COLm1PI20EAdQibyXcHitfzg0ELss0j95xu3ASZZFf70q8prFV4S0EaVkXmp53U0ZqPpuOAT9LHOcqy9IYfzsCF7NX+C7pfF2R8IHiN8SHt7p6TOjP9+MIr7T7r6kFgctRCqAThzbDAGSuS6ser5SsQHGgjBEhcIu0ndkR6dXc0VhR01r2lYCc+fuqkmascSO0KuhypoIYwunma2bBSCL/qdLQ22pL8UXP7kUWJFlIAaWFxmlhW/o2R3DAutUynPNbV6ViAbrKDMjygp5xOw4XrVibi/Yo4w5vN1JB0rudtVGjDdBYPYZtPpJHFqnhRJZlNqJuObIdfiJ3XsP17LG1vLxe6kH8/PmFtUJT66/hhBKSaE9QWx
 QGeaJ7lf
 C6JuLFYXHLFNyvdwEfpUBLV14RrAWGSes4qwhiPXhFD+RrgbP5WI61u+1myaxoPpBd+VDY66AQVPDdOTif3/wulgJObCwZQf1vG9oGtiw85S/r8zhO1SUcB54v6XoHKwSV0v8qRMYPZsY4KLEcLM1C4v4Xk2Mx60fhjvEhiJ/Z5A9vlY9JY9Kc93mIsW9Mxzqzg9P33MPaT5Uqwi5ew0Ok/D/4JhwkyJ6d5sPwcCRmgfwvNZWbFMr1UN8iIP/At542Xq2WzKGYJXPYMY1nuly9CNOjzrDetyuNCuiF6UzJln6SxfH3FzTg+WFlnHyq2lOB333Ve2E+NWOpvOpj5QJNZoxyw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a helper to identify file-backed executable folios to avoid
duplicate code.

No functional changes.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
---
 mm/vmscan.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 11357b86ba2c..8f0c31a4848e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -268,6 +268,12 @@ static int sc_swappiness(struct scan_control *sc, struct mem_cgroup *memcg)
 }
 #endif
 
+static inline bool is_exec_file_folio(const struct folio *folio,
+		const vma_flags_t *vma_flags)
+{
+	return vma_flags_test(vma_flags, VMA_EXEC_BIT) && folio_is_file_lru(folio);
+}
+
 static void set_task_reclaim_state(struct task_struct *task,
 				   struct reclaim_state *rs)
 {
@@ -914,7 +920,7 @@ static enum folio_references folio_check_references(struct folio *folio,
 		/*
 		 * Activate file-backed executable folios after first usage.
 		 */
-		if (vma_flags_test(&vma_flags, VMA_EXEC_BIT) && folio_is_file_lru(folio))
+		if (is_exec_file_folio(folio, &vma_flags))
 			return FOLIOREF_ACTIVATE;
 
 		return FOLIOREF_KEEP;
@@ -2117,7 +2123,7 @@ static void shrink_active_list(unsigned long nr_to_scan,
 			 * IO, plus JVM can create lots of anon VM_EXEC folios,
 			 * so we ignore them here.
 			 */
-			if (vma_flags_test(&vma_flags, VMA_EXEC_BIT) && folio_is_file_lru(folio)) {
+			if (is_exec_file_folio(folio, &vma_flags)) {
 				nr_rotated += folio_nr_pages(folio);
 				list_add(&folio->lru, &l_active);
 				continue;
-- 
2.47.3


