Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26B6A606A7BC
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 12:26:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C29F66B05BA; Mon,  2 Nov 2026 07:25:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB9456B05BB; Mon,  2 Nov 2026 07:25:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A539E6B05BC; Mon,  2 Nov 2026 07:25:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 78A0C6B05BB
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 07:25:54 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0218180C28
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:25:53 +0000 (UTC)
X-FDA: 85390100628.18.0952668
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1F43E180002
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:25:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	spf=pass (imf06.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793622351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N/e8F7vO1qlhJjWmiyga+ERkoaVaWC5pSbm4ZBAVLeM=;
	b=DWqY2Zzp84LGr+z5xcHayqYU90k8WI+d30p+Va9owx9H2QAaWHQlMwRYsc+d5T4vepnWcT
	1j1o34btzzsj9GWzkZH+jwg8DKYl4MOD2B8Q7sgipAcgaDx2Js0/lvsJ/zy4tfS5DZa1TD
	REsPj4OOGti+JaajXXN2cc3vRWFOJoc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793622351;
	b=daablKIAwBMIf59iQ0/A1kC9mlRgFyipRVXOcq3LbBAxcnlhC0ZU20gUgn6hoM5BvM996h
	rTp1A+UISoa3uMo6xGAavSVacaEmLb0VkUOx9BEchkFMT3rf9c+C/piiIRF0c/lxZLngeJ
	wIwEUEmK9sphmci8JCdl54hj6eOmXVc=
X-UUID: 858d10bed6b811f19a56ed5b684f684d-20261102
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, SA_TRUSTED, SA_EXISTED, SN_TRUSTED, SN_EXISTED
	SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_BAD, CIE_GOOD
	CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD
	ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:c03703fe-cec2-447d-b4f6-b032501b1e87,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:c03703fe-cec2-447d-b4f6-b032501b1e87,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:ba1fe32e8b8323372cef97d932a82e0e,BulkI
	D:261102202546DIMLN7R4,BulkQuantity:0,SF:17|19|38|66|78|81|82|102|127|136|
	153|865|898,TC:nil,Content:0|15|50|99,EDM:-3|-100,IP:-2,URL:0,File:nil,RT:
	nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:
	0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 858d10bed6b811f19a56ed5b684f684d-20261102
X-User: husong@kylinos.cn
Received: from ctao-book [(114.244.3.119)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1779435450; Mon, 02 Nov 2026 20:25:42 +0800
From: Song Hu <husong@kylinos.cn>
To: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeelb@google.com,
	muchun.song@linux.dev,
	akpm@linux-foundation.org
Cc: tj@kernel.org,
	tjmercier@google.com,
	ddrokosov@salutedevices.com,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Song Hu <husong@kylinos.cn>
Subject: [PATCH 3/4] samples/cgroup: arm the inotify watch before reading the baseline
Date: Mon,  2 Nov 2026 20:25:27 +0800
Message-ID: <20261102122528.1498193-4-husong@kylinos.cn>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261102122528.1498193-1-husong@kylinos.cn>
References: <20261102122528.1498193-1-husong@kylinos.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1F43E180002
X-Stat-Signature: w1forwzhjqdhwiizirk3ehnh7n45w3ik
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793622350-73532
X-HE-Meta: U2FsdGVkX18yxG5DCbv+02pZJOaVEaZyadcbTL3xa9LjFEAovzc0Oegn1WKsKlFiQw4XebfDhZQn5GD6xK6ef2mFapODaoDo9nL+LfypTDJBhMxgNZY7Szr20NsCgZhwUvTq2zMrFMM1SAc85AW8jGbS/ADGZXH1imlWXmkjMyf8uXYhsUJ3Gv3Amc9hZpqXaTNNO42UKslwV+KAKhG5O4Qj2DJhOtKWzTb3lIJn81RP9vvEfHV+ukenEsM1+h2nMngmYlnTqGb2oWDNLQO4bk0G9Q2dRbqMkBawYWcof/B2t4mzRzGa7vRccAljp0WC9GiOMwEBd4oTi0HXzLXZo7SzJFOQt/306i2kjVOr5/czWFTx7c/AruAPEtOkhVUYH83+hgqdrG1/hcvSB9CW2zs03d06tVarV/nc1kABrKW9r7WZ/sb5T5/V1GAC2lS2skqskkGLrvn+zCkD3EUeB79DoohEFENs0tAc+oUpK6N3nFa9E0iQrJ7wFWccz3ZsUtNTKkk3xu1juh0mfHv5M7Fybd/VDueROBYOjdPu4hlToIv1hL0TQQCvNAKI+OWe39hkKkSCRWEAxhCxPro/jIVZ29e935rP4CZOGQ9E9zhqHbHR0krh2sIhHSKfToNRxyl+aSDIrzNKBe22TQOqeebq2P1XwH0iLyMuE2fAs1jz2BdOHHKjJWx5SjN89nwmgRXK56RDfgndx4gnZ3GcQk7Sog0V+gl34reBU6bBCwJ01LR50flOPag3crrFAYxUn58z62Ho431uqPetLBllWtR4IhcNIE2O0bzQRsxSAj5Z/0M8Et7z3qKQsE9mZk8073VI3GH1TZyTQLIGzSbhsuJGPrnFXqNSXnDFSB1/Z1AaWBg++xMzAlZ/SOKB973dCxuJFNPqnUT3Putwgk9KQ93iuIkeSXP2JTSb0qx1SunX1gcBBJIfqbDHg5Mu3I9wxxhx44xn2iGb39Rn3dh
 ZjU7di7A
 58Fb8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The listener reads the initial counter state first and arms the
inotify watch afterwards, so any event firing in between is lost:
it is already included in the baseline (no diff will ever be reported)
and no watch existed to queue a notification.

Arm the watch first, then read the baseline.

Signed-off-by: Song Hu <husong@kylinos.cn>
---
 samples/cgroup/memcg_event_listener.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/samples/cgroup/memcg_event_listener.c b/samples/cgroup/memcg_event_listener.c
index 996bf6fb117c..c23af43bf6cc 100644
--- a/samples/cgroup/memcg_event_listener.c
+++ b/samples/cgroup/memcg_event_listener.c
@@ -293,12 +293,6 @@ static int initialize_memcg_events(struct memcg_events *events,
 		return ret;
 	}
 
-	ret = read_memcg_events(events, /* show_diff = */false);
-	if (ret) {
-		warnx("Failed to read initial memcg events state (%d)", ret);
-		return ret;
-	}
-
 	events->inotify_fd = inotify_init();
 	if (events->inotify_fd < 0) {
 		warn("Failed to setup new inotify device");
@@ -313,6 +307,17 @@ static int initialize_memcg_events(struct memcg_events *events,
 		return -EIO;
 	}
 
+	/*
+	 * Read the initial state only after the watch is armed, so no
+	 * event can slip through the window between the baseline read and
+	 * the watch creation.
+	 */
+	ret = read_memcg_events(events, /* show_diff = */false);
+	if (ret) {
+		warnx("Failed to read initial memcg events state (%d)", ret);
+		return ret;
+	}
+
 	printf("Initialized MEMCG events with counters:\n");
 	print_memcg_counters(&events->counters);
 
-- 
2.53.0


