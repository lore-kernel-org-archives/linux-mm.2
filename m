Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 543A0606A33B
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 12:26:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E0286B05BB; Mon,  2 Nov 2026 07:25:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 947CB6B05BC; Mon,  2 Nov 2026 07:25:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80A956B05BD; Mon,  2 Nov 2026 07:25:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5B6E26B05BB
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 07:25:55 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D347C40C76
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:25:54 +0000 (UTC)
X-FDA: 85390100628.01.C02DF76
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf28.hostedemail.com (Postfix) with ESMTP id D1ED0C0005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:25:51 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	spf=pass (imf28.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793622352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LMJynhb5MPftogfmT9tk2MR+IArvvhmjJkMrR0rvjaw=;
	b=mH4ne1wiTbHXJqQgobByvBq5xQjH8AINTtcmNtgoOf+rU91SJsGmlSYTtyiHc9yWflVK6G
	vqCry22apx5MGK7kutGyqSNfObP03/ava3t5tYZ5jXM0G4p+nDqd6LQcTx3vL2XXArQF0G
	IfhCphEioY4+7jkMxnWwQVTU56W52Yg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793622352;
	b=sz0djGa9LYTpO/utY0mTmeeVb1hr+UGGyvLxQdZO2YwZwQoItdana60Y1pC5Xq4tZEhL/G
	wlWsDOGvMLl0amoPUSbek/kBhQO8kvcg/RHcZvdZojvfi8DIb6KVNX0m6ja6YVC16bu11M
	GvbDM3Rj8cSFbXsHCO1br8o20mnMOxg=
X-UUID: 86323e2cd6b811f19a56ed5b684f684d-20261102
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
X-CID-O-INFO: VERSION:1.3.19,REQID:4e2633df-6343-43c4-8e5e-81c356af623c,IP:10,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:35
X-CID-INFO: VERSION:1.3.19,REQID:4e2633df-6343-43c4-8e5e-81c356af623c,IP:10,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:35
X-CID-META: VersionHash:7db8b62,CLOUDID:77a413587497340d9a585fb3ded6dfa9,BulkI
	D:261102202547G39DAL8J,BulkQuantity:0,SF:17|19|38|66|78|81|82|102|127|153|
	865|898,TC:nil,Content:0|15|50|99,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bulk:n
	il,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BR
	E:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 86323e2cd6b811f19a56ed5b684f684d-20261102
X-User: husong@kylinos.cn
Received: from ctao-book [(114.244.3.119)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1357426714; Mon, 02 Nov 2026 20:25:43 +0800
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
Subject: [PATCH 4/4] samples/cgroup: don't let dirname() clobber the monitored path
Date: Mon,  2 Nov 2026 20:25:28 +0800
Message-ID: <20261102122528.1498193-5-husong@kylinos.cn>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261102122528.1498193-1-husong@kylinos.cn>
References: <20261102122528.1498193-1-husong@kylinos.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D1ED0C0005
X-Stat-Signature: xed6o9qq3w5crqm97ixtdf9kdcrjee51
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793622351-478000
X-HE-Meta: U2FsdGVkX1/z4AyI2Yxl+J/7/RfVxEAhMgU8WT+LxYbUTpsXmT4nUDiBkNhTkGPlRItvauQOtUiJJ6PXfdGhvVcGP9Nznhy6yEmR26XMneACrDfLQSOOJbo850GCfQixDK2t5A4Goar8IeXtiC8kLtvn/LpEwJ9uKIa0Gt98BXBhGAzlkNxZJOyQVRwod7eOk6EnjJO6IwCiU56az3/PbbODt31LLNaiuODYMc9ND5biQacWS1Wvy5SPWefmrWWmZ4A553QaqDaQnG9TYCBWZhEvtu9zstmAt+oh+1awliFi7Ka0VOq46rIMY6j0LgMm6cowCIP3TL+RLw9h+gyxz77vtdguoOeak2OmodxgtQlXVHC1yqxO9x7ybRSbqtRlbe5GoOHruc6Y/zKDawqFSb1H9c/xJNNBck/mCHORbrstIcqH6RCwemzFtb6Gd3Ng+MdwmHZN+U8wKo9udWRS+PT8y5o90H8Lslg66vgz3eyPGsD1Rk0YKzp+qnCxGTOz0GVBu2wW+XhGBqjkmgqARqh5NFfvKi8+4HtCOsErHbL72Ep1WPgbYhDX45ErwQnvWME3D6YlA+B/CflyDkROJlRHLMbxHeIgs5ZEHLsbpTN7QEJKlUV534AlQ942Xfu85+ML3fF8PfDCTr6AiHyVhTRtlNSdkFGdM8BlSKXaTybaipAY2zdnaCXzQUkPvuDFI1kiRLbzBTL+iothgBSoxIbWMjT+MMoBcefmUDx5dRrnx0ld8s2LwY/ykbA3xLVsEWHK3g72Gn73h5jjMi1T+lr79TIX4/OXiHDtb/aWvHd44hQTkDaXNKbYsgH38IpGKXkeZQAOQEY/wFLGgRckRxhYLvbnt91XMKLU/mqyQj6EPr9yc7z5my7Q5i9rti2qnhYICT4Wx888BAbJd+mYgpwgRWHtKRMr78JXioNYX+4ZwVplCvhX/GZfbd6YYKMc1/OOlZpifbu1lFt6Pe+
 pR8JNjlg
 24k5g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

dirname(3) is allowed to modify its argument in place, and the libc
implementations do: after building event_control_path, argv[1] has
been truncated to the parent directory.  Every subsequent "crossed"
event line therefore reports the cgroup directory instead of the
monitored file, and the two-listener setup taught by
Documentation/admin-guide/cgroup-v1/memory.rst (usage_in_bytes plus
memsw.usage_in_bytes) produces indistinguishable output lines.

Work on a strdup() copy so event reports keep naming the monitored
file.

Fixes: 60433a9d038d ("samples: introduce new samples subdir for cgroup")
Signed-off-by: Song Hu <husong@kylinos.cn>
---
 samples/cgroup/cgroup_event_listener.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/samples/cgroup/cgroup_event_listener.c b/samples/cgroup/cgroup_event_listener.c
index 3d70dc831a76..308cacec80a8 100644
--- a/samples/cgroup/cgroup_event_listener.c
+++ b/samples/cgroup/cgroup_event_listener.c
@@ -26,17 +26,27 @@ int main(int argc, char **argv)
 	int event_control = -1;
 	char event_control_path[PATH_MAX];
 	char line[LINE_MAX];
+	char *path;
 	int ret;
 
 	if (argc != 3)
 		errx(1, "%s", USAGE_STR);
 
-	cfd = open(argv[1], O_RDONLY);
+	/*
+	 * dirname(3) may modify its argument in place; work on a copy so
+	 * argv[1] still refers to the monitored file when events are
+	 * reported.
+	 */
+	path = strdup(argv[1]);
+	if (!path)
+		err(1, "Cannot duplicate %s", argv[1]);
+
+	cfd = open(path, O_RDONLY);
 	if (cfd == -1)
-		err(1, "Cannot open %s", argv[1]);
+		err(1, "Cannot open %s", path);
 
 	ret = snprintf(event_control_path, PATH_MAX, "%s/cgroup.event_control",
-			dirname(argv[1]));
+			dirname(path));
 	if (ret >= PATH_MAX)
 		errx(1, "Path to cgroup.event_control is too long");
 
@@ -76,7 +86,7 @@ int main(int argc, char **argv)
 		if (ret == -1)
 			err(1, "cgroup.event_control is not accessible any more");
 
-		printf("%s %s: crossed\n", argv[1], argv[2]);
+		printf("%s %s: crossed\n", path, argv[2]);
 	}
 
 	return 0;
-- 
2.53.0


