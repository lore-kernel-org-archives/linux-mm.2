Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13CD1E74AE1
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 07:45:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EE736B0093; Wed, 24 Dec 2025 02:45:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E2376B0092; Wed, 24 Dec 2025 02:45:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1CB16B0098; Wed, 24 Dec 2025 02:45:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C6A6A6B0092
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 02:45:44 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 799FF160618
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 07:45:44 +0000 (UTC)
X-FDA: 84253580208.06.BCE26D0
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf30.hostedemail.com (Postfix) with ESMTP id 19D1480004
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 07:45:39 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	spf=pass (imf30.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766562342; a=rsa-sha256;
	cv=none;
	b=XLEt8mK+g3iJUv0Rygxd1Qh5MKnOUp+KpTTlj57KTQ3EELwYuSfb6WRM2q5w7U8NII3QO1
	h+Ifnk7UKxEEp3bI/4727dA4eTjJHinfXITyKB7f1bzTIJq5vR1/YG8K0fJjTyLV/sMCoc
	oOS5m4bOgMONwKJZJ9y8D8p3PJbbZ5g=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766562342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mBZyahRxyCIssYHtNec09GCPEKkJYIKoaTzQzxDyR0o=;
	b=dMcHafJZGosoaa8HI8PzJd/7OXjb+CBpY3eSLN+9rCC/cSdm+XOheWxxAVl+/SLh0gpyL8
	Mh03g21pMviMHEfAtFACBLQi8lpufUc7tEApR70OWxTjNqSbDM7SxOXszPZy32m9mcUC7S
	3bARi9kVTFnx3jMEy1Em2i7qbFBo/NY=
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dbkRr5LlczYQtpF
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 15:44:56 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 112E340571
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 15:45:35 +0800 (CST)
Received: from hulk-vt.huawei.com (unknown [10.67.174.121])
	by APP4 (Coremail) with SMTP id gCh0CgA3l_cMmktp9pcvBQ--.63051S7;
	Wed, 24 Dec 2025 15:45:34 +0800 (CST)
From: Chen Ridong <chenridong@huaweicloud.com>
To: akpm@linux-foundation.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	hannes@cmpxchg.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	zhengqi.arch@bytedance.com,
	mkoutny@suse.com
Cc: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	lujialin4@huawei.com,
	chenridong@huaweicloud.com
Subject: [PATCH -next v2 5/7] mm/mglru: extend lru_gen_shrink_lruvec to support root reclaim
Date: Wed, 24 Dec 2025 07:30:30 +0000
Message-Id: <20251224073032.161911-6-chenridong@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251224073032.161911-1-chenridong@huaweicloud.com>
References: <20251224073032.161911-1-chenridong@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgA3l_cMmktp9pcvBQ--.63051S7
X-Coremail-Antispam: 1UD129KBjvJXoWrKF4xKF1rJrWUWFWrWw4kJFb_yoW8Jr1rpa
	9xG3yUZa4rAr4ag3Z3Xa1kWa4ruw48JF1xJrZrXry8AF4fXFy5K3y2kr4UCrW5Aw4kXrya
	qryYgryUW3WUZFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmS14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0pRQJ5wUUUUU=
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspamd-Queue-Id: 19D1480004
X-Stat-Signature: 6gc1tspme3isqbtd4pcbdjbgdwobx6pk
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766562339-497109
X-HE-Meta: U2FsdGVkX1/PQzzBF8bseYaumvFGTMcOAlI3Z7WFWaa5cC0xQ3mQ6zvvibAXmZW1KxxDcrwwxr6PXtOEMBUbVfHpAjsGvhywNQndRH5Q/sXw6FLlpPl5D5ar/txrTBgTX5jvY1mzfkIdow4HQBhS+rrRqx0wry8+PEPmRPbUBp4X5PFs1OvJJqraGhqyCyP8oFuOPx998HnsdDtCuS8SP6aXW2Upr4HoI59cS3nLcrFHKaJgemDukuIpELisV6KCW8Pl1I37tem3++RmjG6bI7LQLGOrRG6rKk1G64RhWR0c1YI2qvReFAxkwPlzVL+fi2L7CGa8ckTmAyIst9RyPOP07JVifJeSOIP5MCAbp0KWBbYRSmWE87+LUOIWDyMMRQWiTbSyzzg2gcHMPmSdElWtBRCk1RSuXJc0Ld/90Oodqca8N2081jf/gX+frKnETZw93um0bOZDZQB7U6lf1qMZ2FcX1vU/REEx9QHLuNuGhKr+ZeVy5dvuRL/2iZiaiYJt2FQ489duLOrMOBr4wAXbTjL/wfIKxG9LqUOnNbdNS2ffn4pgEXIr3GT5eCE3YWYz//nv8qiy9mlwy6L5VnnlrH08+B+bqhdQImEoYIxMjVozP4PFyna9R/auMe9IyaHoxgusW9MrE9bETFbTW2laZj0jOmNADDYZk1ACDyPPc9sD4sXUyfz7HrQXFmrGNBIrNqWkbQmu12HMHK2JpxNn+CnIsEa46U08MoEUubm7IT8Mu2LgIGo5/hn1JiB2VAVef8GnM9ChpouxQIZJzNglJ+SSNUc80lJGmuQUmyo+5XxuR/tFX3+EthlHd27YA5t9LTVZeqJZYrJ4JjT9rNa5qEMBbP4JHifrLp+L9fHrMIKgiAL811xHE4HHE6l2n+0sm1khdP2VWeiyEC0dtJSfvSi7c28fQ/mXFpsj/j/zYVLXrQCObEntGl2sfnoIjt2iy277pY6rUnXXGDr
 n81chQrt
 z+IGIDD8IBS6QDTXYWQJBBvs6XNpc+YB7gQtKoDMN2BKAnXjREenOnVcEKnJ1npUXwz/qKd9C6q3rgd9QL/157wBWwe79rEfuMRWs7Nu8TluqDm0kXy/MUZpxDGJW3JfAWGM3h/4+DF91OOk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chen Ridong <chenridong@huawei.com>

The upcoming patch will integrate shrink_many and shrink_node_memcgs.
Currently, lru_gen_shrink_lruvec only supports non-root reclaim invoked
from shrink_node_memcgs. This patch extends it to also handle root reclaim.

Since the initial setup for root reclaim is already completed in
lru_gen_shrink_node, we can simply call try_to_shrink_lruvec within
lru_gen_shrink_lruvec for root reclaim.

Signed-off-by: Chen Ridong <chenridong@huawei.com>
---
 mm/vmscan.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index e55c7835cab5..3a266f6456af 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4820,7 +4820,15 @@ static void lru_gen_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc
 {
 	struct blk_plug plug;
 
-	VM_WARN_ON_ONCE(root_reclaim(sc));
+	/*
+	 * For root reclaim, the initial setup has already been completed externally;
+	 * proceed directly with the shrinking operation.
+	 */
+	if (root_reclaim(sc)) {
+		try_to_shrink_lruvec(lruvec, sc);
+		return;
+	}
+
 	VM_WARN_ON_ONCE(!sc->may_writepage || !sc->may_unmap);
 
 	lru_add_drain();
-- 
2.34.1


