Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDF11C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 05:42:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 990A96B0005; Mon, 13 Jul 2026 01:42:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 940756B0088; Mon, 13 Jul 2026 01:42:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 857706B008A; Mon, 13 Jul 2026 01:42:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5E1CE6B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 01:42:14 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E31FA40A1B
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 05:42:13 +0000 (UTC)
X-FDA: 84982657746.23.42BAD9E
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf21.hostedemail.com (Postfix) with ESMTP id 43CE91C0002
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 05:42:09 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	spf=pass (imf21.hostedemail.com: domain of zenghongling@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zenghongling@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783921331;
	b=rf/HerlPdNinokhdByj2MP9WRazL8Znud7Ymcn110wwVlhDxPfh56ipOESTaKnR8jG11sY
	Hx3zfE0O6/2q0SZc98D5+8YDqGfa6UdG1yQ5SUtxCpgqQ5iMerVkqPpgXNNZRNk6zkd6cd
	thxOTFzDjROleggX8jJfRmbjgSLU5m8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of zenghongling@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zenghongling@kylinos.cn;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783921331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=I5Ta9/QNqCWmfj+A2D7pWgDPlpCgEtStbUv9TQz9ldQ=;
	b=FA5aR/ckv1zcCWz/m09PJEAzdWFPXCDC9HjgS/T3OGAzCYk5nFt/8QMtOe+vcMF4fObS0U
	AYTnmO92O3ciqJpjqRLbEHvKhNaG34EdQcbYhXkrUfnrA9quEtx+2gpDHu/UVvBA/F9Jij
	HoX43fWJVfiMQ819e5izqGcyHV1m2Ak=
X-UUID: 917e9a207e7d11f1aa26b74ffac11d73-20260713
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:38897b86-6435-4b13-8f83-65f0762bdc75,IP:0,U
	RL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:25
X-CID-META: VersionHash:e7bac3a,CLOUDID:23c94f9602a6a63bc4130bd9aea047f2,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|136|850|865|898,TC:nil,Content:0|15|
	50,EDM:5,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,
	OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 917e9a207e7d11f1aa26b74ffac11d73-20260713
X-User: zenghongling@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <zenghongling@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 556758284; Mon, 13 Jul 2026 13:42:00 +0800
From: Hongling Zeng <zenghongling@kylinos.cn>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	zhongling0719@126.com,
	Hongling Zeng <zenghongling@kylinos.cn>
Subject: [PATCH v2] mm: huge_memory: Fix kobject cleanup in thpsize_create error
Date: Mon, 13 Jul 2026 13:41:54 +0800
Message-Id: <20260713054154.120915-1-zenghongling@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 43CE91C0002
X-Stat-Signature: hkmk8ytekhjijwhqwt4ats7igzcc6gtf
X-HE-Tag: 1783921329-824288
X-HE-Meta: U2FsdGVkX1/Cjo8KuWUVS8xDjADIimd4DGl+RDwbvyTERJIsWAe4iBukeF32uCMISb4yFSzddEfnnajWgEQ3YhMdynqC/ORgdbC61/VWI6Y6PgjuFWlMD2PMWQFJCkgZhA+ln1i0yNkzWgXUy6QCmY5z9AjNBcaDVTmpHYF4rE5FQi0ak3S12uSkEmTtanJaYuM6D38RvM43K5fR8UaP1TtrvMlxF0a2ZCw+qaR0TOWlqcS+8yesGznXwK+B7URO+kr9aSS2/zK9P4Hupi5jAMfKEmOczRhroj/STyRxQ0kpSfoGV67Pd4zCNtV4VbeJSyK2i4YaIteyZrAKK8cjf4cE9uPgxGV6aNAtgtkt1+GLircVYLM5TwRh94D//TWqtHfYANjApH+LazJyUdBf1KcDD69kkUEy2rRvn9+07Hyj9RJ5KT42UXi8D7SuCGAOWCjMpMM702ronU+woQhbcCQJYX4d7pCAiEhCbTIHmIy5d2ehkeM73dT47QqkOj3x+uCeCKtRH5elBtggp9FaJckEoe4nH9aKGcXjcxi+aSLFkM6Y6DOLK2yu1ukeiDFE+Sv7VHIqmEwo2/wSdRIoCAwt70rfEf74GoRFmuQNIzMPum2GOAW6jyQCNgiifqDJ16N9xNPbJyXxJ8jVCkEBHJhJzq7y2LOmNtFqyPHLVSXk33vNu1hhHR4OyQFCStffyHcMoxZi8MEhrERUJKUwlrxi+ZZM+Y9t+VjpdjRx0ydcBN5TKdnOAvEHK7Hon17yX+/kYD7hgtlX2dIUnnz0gWRjCnC/Nt6VrO34RLRyRxZuTng0X3x1Ty9k+MVK2rSi246RguXRKeIv/aZJZfi4dUtlynpo3UZz4BR7LNbk+Sbnzq2ARgnN/LQWZAvGkg0Fp9eDdqsla+0ff8Viq6ka3tS1T6XRxyNzbqBRSpaGj6lHyn7xIygpgTAQN4NdazWyuhhHRVCyl96xqx2Rik5
 EocqRe2M
 AuZ7KGUd+UJMgpdcx+5BqPtpJQbug4H6pyZbh5uutvOH0/1Nj6GfzgFqmt2n2LdVyN3P9MnHl0FNoRIMxkLZRJQVJ37Gm+Ut8n+oq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When kobject_init_and_add() fails, the kobject API requires calling
kobject_put() to properly clean up the memory, not direct kfree().

According to the kobject API documentation, kobject_init_and_add()
calls kobject_init() internally. If the subsequent kobject_add()
fails, the kobject has still been initialized and must be cleaned up
via the reference count mechanism (kobject_put), not direct kfree().

Direct kfree() leaves the kobject's internal state (including the
reference count and kset membership) uncleaned, which can cause:
 - Memory leaks of kobject internal structures
 - Potential use-after-free if there are pending references
 - Inconsistent state with the rest of the error handling code

This fix matches the pattern used elsewhere in the kernel and in the
same function (err_put label) which correctly uses kobject_put().

Fixes: 3485b88390b0 ("mm: thp: introduce multi-size THP sysfs interface")
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Suggested-by: Baolin Wang <baolin.wang@linux.alibaba.com>

---
 Change in v2:
 - Use goto err_put instead of kobject_put() + goto err for consistency
 - Add suggested
---
 mm/huge_memory.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2bccb0a53a0a..589f7bf1f19d 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -818,10 +818,8 @@ static struct thpsize *thpsize_create(int order, struct kobject *parent)
 
 	ret = kobject_init_and_add(&thpsize->kobj, &thpsize_ktype, parent,
 				   "hugepages-%lukB", size);
-	if (ret) {
-		kfree(thpsize);
-		goto err;
-	}
+	if (ret)
+		goto err_put;
 
 
 	ret = sysfs_add_group(&thpsize->kobj, &any_ctrl_attr_grp);
-- 
2.25.1


