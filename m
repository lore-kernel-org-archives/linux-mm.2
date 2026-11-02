Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCA9C606A78F
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 12:25:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2657B6B05B9; Mon,  2 Nov 2026 07:25:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F6806B05BB; Mon,  2 Nov 2026 07:25:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DEA86B05BA; Mon,  2 Nov 2026 07:25:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DA4FC6B05B6
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 07:25:53 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C23081A0C89
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:25:52 +0000 (UTC)
X-FDA: 85390100544.29.5F3D16E
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9A4351C0004
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:25:49 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	spf=pass (imf20.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793622350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cP8HlbLPqyhqKuqna0qVGWoiHPYWTx182iscTSCNW3k=;
	b=UmFNi+O2/QzhQ6UrhZgy2BusB59/L8od88XLjsZrPB6QdAm6S4yTMr7DZiKidYUKqNToIo
	AjNnKcmPcYHpyu+lTHORZJTLfkEjjMUCoAYJq12t0jItxf0eX2wXckFnRJSKSs5ae7NV64
	nJAXZRNwfNuIRv+/SBqYPfMaoLGKREQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793622350;
	b=QtRIn9RiUwSIHWM0sxiAaGVddVDT8i7+ljp1WMPlJnmqDuK3Ggm7o519lEa5Rsd4rwOC3X
	kaz8BHl0/oR/1lIVZO4yzCws1TGTKjNiZkk/QRMb0J8xrRfwRlwkHs8oI4TNd50Ym8fRx5
	O++ccJ8tbOcOyJbOHuwkwD0eXWA722k=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn;
	dmarc=none
X-UUID: 8434b474d6b811f19a56ed5b684f684d-20261102
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
X-CID-O-INFO: VERSION:1.3.19,REQID:1b6cca05-a92b-449a-a34e-de6d2eda1270,IP:10,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.3.19,REQID:1b6cca05-a92b-449a-a34e-de6d2eda1270,IP:10,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:7db8b62,CLOUDID:65a68b027f359fed935768789d1ab6df,BulkI
	D:261102202544D32HOMG5,BulkQuantity:0,SF:17|19|38|66|78|81|82|102|127|136|
	153|865|898,TC:nil,Content:0|15|50|99,EDM:-3|-100,IP:-2,URL:0,File:nil,RT:
	nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:
	0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 8434b474d6b811f19a56ed5b684f684d-20261102
X-User: husong@kylinos.cn
Received: from ctao-book [(114.244.3.119)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 322983919; Mon, 02 Nov 2026 20:25:40 +0800
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
Subject: [PATCH 1/4] samples/cgroup: fix poll error handling in memcg_event_listener
Date: Mon,  2 Nov 2026 20:25:25 +0800
Message-ID: <20261102122528.1498193-2-husong@kylinos.cn>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261102122528.1498193-1-husong@kylinos.cn>
References: <20261102122528.1498193-1-husong@kylinos.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9A4351C0004
X-Stat-Signature: oezzcpo8nx9agchc4dqw7o1wwypdwmcr
X-Rspam-User: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793622349-718645
X-HE-Meta: U2FsdGVkX1+NdEIJYKEhiAm0COfb35KwywfuRlqgEHLdc90IxG2S/tXaOGJfhE0r7B1BWE9Ss7OaPH5X7WptFOQ/7hMWoq76UkbLn51zPGcFJD4j6iKlq8cnJJzoSq6PfcCjzoyrQwQWW2IxH1to4B+UHNJjxIC9N1eMgSdJnTUVMJQedyuu/EigRrOrCevwotKm4m8ru7urp6KCWTy4pQ7SmU/RAPtQnq88bt3ffv1PZ5hZlplHWXei1ZmzKWq5fhgAmfd/RypjA89J8jldB6q2r1Rjv1BtdX6QpSdZS/4Q6xh0NwM0z0b7NDf6QzI0RoFdZmEkm0c2qhMMpQ4clv/u0ZVTG0dB0SBihhSrXty/3UaalN2uNpW/qUa2Jj+Mt4OIYdY2o3CZvJxJ1pDcgwZJvSiWcNBNkt8TJyH2xfS6akwyHBBI+yKbT1T/ktsS2ebGWrA+htORzZYfscjFGBNc+aZicX0Txoom2xAOGwVB08yE3Rh6+iIxv7P1dtfBRxeL3i/If5HAp4AEKRseNBl0Z7I6VV2eArr6o3DWb+VW5gOdRnXei1S+Ksa4Dh0QhCohKn/pFqQwvVrKVsh+xw59l4rl8TbuVsNElxTJkfTwvgGZm0uAnwx7Pqo1JDuQ/fKw5ZvbYh8RmPDntvxiOudDFFV4lnSMJ7Hco+Chh5tMCVyMKbyadHIv1JBsciBq5Pt/i4f5QFRqktqLycBzbZrnczatZT0d+uLDPRi5IdTzcqchXrX7Bol/sC2ehjyD7ohWSwCqc6hb0SmcVpV5Bq2pnZx6F5hD7TmOnl0/KgmwsrQa5A+FUiMxPWq2f8XcjQogPzOVJnNrH0U9IqftZtBRAK9hsoj+fS1DeQFCj+sVN+gDfisfrqLzbib3YNRIP2SNoyHlcdud54IIQjI4Ph9iV0lGurLDtSFSmGghHaQSv8Vo69AHVI/rD/YOZO0/9aSeMCuYWqB3GRNXB7F
 tlZXDtTW
 hTxLgNaQMSauoCFwH3dK1T98isysdyinH4WWnSTMkztBWAhRH33N8lU7QZfdqwqD3XW7bixuhsLzfgq5j4S9T4aV6SBnM75TlHot1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The poll error guard tests "errno != EAGAIN", an error poll() never
reports.  The one benign failure the loop does hit is an interrupted
poll (EINTR) when a signal arrives; with this guard the listener
exits via err() instead of resuming.

Continue on EINTR and only bail out on real errors.

Signed-off-by: Song Hu <husong@kylinos.cn>
---
 samples/cgroup/memcg_event_listener.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/samples/cgroup/memcg_event_listener.c b/samples/cgroup/memcg_event_listener.c
index 41425edbd88a..ec7c03fa7887 100644
--- a/samples/cgroup/memcg_event_listener.c
+++ b/samples/cgroup/memcg_event_listener.c
@@ -234,8 +234,11 @@ static void monitor_events(struct memcg_events *events)
 
 	for (;;) {
 		ret = poll(fds, ARRAY_SIZE(fds), -1);
-		if (ret < 0 && errno != EAGAIN)
-			err(EXIT_FAILURE, "Can't poll memcg events (%d)", ret);
+		if (ret < 0) {
+			if (errno == EINTR)
+				continue;
+			err(EXIT_FAILURE, "Can't poll memcg events");
+		}
 
 		if (fds[0].revents & POLLERR)
 			err(EXIT_FAILURE, "Got POLLERR during monitor events");
-- 
2.53.0


