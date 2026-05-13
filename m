Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2B39CD343F
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 02:38:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E02406B0005; Tue, 12 May 2026 22:38:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB2FE6B008A; Tue, 12 May 2026 22:38:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC9386B008C; Tue, 12 May 2026 22:38:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BC2D46B0005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 22:38:12 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2B770406A5
	for <linux-mm@kvack.org>; Wed, 13 May 2026 02:38:12 +0000 (UTC)
X-FDA: 84760837224.08.D9967E5
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0A299160007
	for <linux-mm@kvack.org>; Wed, 13 May 2026 02:38:08 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	spf=pass (imf08.hostedemail.com: domain of yumiao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=yumiao@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778639890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=jbkDlk/Gh9JONUscNuBIZxrMOLkfd54SsxGtvUpITWQ=;
	b=OC1N+xL6T2+wNJgNkyp8Md/lVE6N3IPF4odYHBqUFBtApsg5pMZL3ezRyMHKWE9b+DKhxa
	Ak5n9OY5qP0gXjTZMUVeYefxT9gY6XN6QG0pbv7pt1ihCOhO+nIwEK7kEMvkVrTxf59uSN
	VNOodZ2F6ZYq3E7lT87FRMRNAfJ+e6k=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of yumiao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=yumiao@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778639890; a=rsa-sha256;
	cv=none;
	b=rPW8zjkSJyXU1z3oVyCSZh+vjJHQqSf5mQNtIQW1/FpAN1KJ520/NyQNHGyQCttmdqsxlx
	TsnoPf2f8z+YSBETuTAnT8OaXQxkTNKqLGRrPQ07SafZtC7ULTaDaNBYV62ECAEVn1u12k
	KuC+pCrqxp6BqRVIme1E+tijCHiwJT0=
X-UUID: c3fbfcb04e7411f1aa26b74ffac11d73-20260513
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CHARSET
	HR_CHARSET_NUM, HR_CTE_8B, HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD
	HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER
	HR_SJ_NOR_SYM, HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_CHARSET
	HR_TO_CHARSET_NUM, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NAME, IP_TRUSTED
	SRC_TRUSTED, DN_TRUSTED, SA_UNTRUSTED, SA_UNFAMILIAR, SN_UNTRUSTED
	SN_UNFAMILIAR, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD
	CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD
	ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:ecefcfc9-f295-4318-b6ea-fe6d35d9bf7c,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:15
X-CID-INFO: VERSION:1.3.12,REQID:ecefcfc9-f295-4318-b6ea-fe6d35d9bf7c,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:15
X-CID-META: VersionHash:e7bac3a,CLOUDID:e91c13234778766932006b445e033996,BulkI
	D:260513095221EOQFH20K,BulkQuantity:2,Recheck:0,SF:19|38|66|72|78|102|127|
	898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:40,QS:n
	il,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC
	:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FSD,TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: c3fbfcb04e7411f1aa26b74ffac11d73-20260513
X-User: yumiao@kylinos.cn
Received: from kylinos.cn [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <yumiao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1475918497; Wed, 13 May 2026 10:38:03 +0800
From: Yu Miao <yumiao@kylinos.cn>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yu Miao <yumiao@kylinos.cn>
Subject: [PATCH] selftests/cgroup: Fix error path leaks in test_percpu_basic
Date: Wed, 13 May 2026 10:39:07 +0800
Message-ID: <20260513023907.179097-1-yumiao@kylinos.cn>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: isjeyji7y4gz9i9gqkui6565w97j8sns
X-Rspamd-Queue-Id: 0A299160007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778639888-519267
X-HE-Meta: U2FsdGVkX18z2y6P2yoL+m4yeeOHoO7e+Z3X/SXnthhWuAO90GdkEDBVhqsO++tWSSE8Vodk0WMxjcPALWJ7ftpxh22a3YBjoWQK+tAyczOKtK4adUjqmrlLA5DqjpkVlpaqoaniqwlgLATdXdUfIApmdKwJUvU93RxaoxMuB8bNabY+4auvXeUTmvyQD2fDkTiyV89tDzogBWA7VhMKSu5TyMBEyFiEewfSU2fI5Zaep6983BlSyYPMCP8lR4UaJ2i1xhgiS0aqkW4ZTxI5U1BB731KBAgV5M8eNk57DHXNo7160ZowHG1VXJsfESZ1N3xa8li/yiO0xlU6poBgmVxFMbfpF8bfh46oY+ZptVbkQ7eNCDuDhAtmOq4LSQj+zE6H1Bm47WSGlCDBeD4GkZNjFYQzFBghdNcHk7JZpS211ZjNm4duWzRra4kEUCGd3CpFiAQXTkv9is+EqfCOaN877JkbT4ggbs7sSQQcMfojgLs7JtSEyAncsrfOXFPmZ8iaiEuAgdXaDHZfyX3Rmf4brDuVvK47exZngVp9atkvHQZ5ENzP98ovJuhbvWpypWVJAKW2VnBt3vaPzbyLFPGEHWs6L8Kt4gOOKNJUhYCD0J7+jZ9L5/yIs7BdxNbvrWjBJgOkj6N/PHPCut5ML9BxrG/D1d9pQzI1IEAP4YQ69B+FeGtdpgMeoE7e1+jq6kd7jXqodc7bEbn/5/U0zGzo82eqDIJrhoPxw6RF3BzAC0Y4fm3oLfBOznf6KHFYOOcT2/aCI6Fvgz9a52EfPukDwzrAPY3x66r2KmgDLtADqscohZb/IeNFQRzQBzcCBuZ4LFR114xS4EZzrB8ye9IFLZTslsl2E/kyv0+/Oxeqzotv1a4RqWmDWpJuZI7iju4LMTEEIMLulEawdmbgr7cLTK3bajT+wwOYLsS+5hmwk/4SKWIJmx2U2RjIHoEtiljZzEY/DYu36uXn6x9
 cYMbl2TS
 q56esMygnr87brOI10gNZ0BF8s3e0FLYb8F6rRFwirjp9edT80ZRB/L/e3g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When cg_name_indexed() returns NULL partway through the child creation
loop, the code returned -1 without running cleanup_children and cleanup.
That left the `parent` pathname allocation unreleased and did not remove
child cgroup directories already created under the parent. Fix by jumping
to cleanup_children instead of returning.

When cg_create() fails, `child` (the pathname from cg_name_indexed())
was not freed before cleanup_children. Fix by freeing `child` before
branching to cleanup_children.

Signed-off-by: Yu Miao <yumiao@kylinos.cn>
---
 tools/testing/selftests/cgroup/test_kmem.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_kmem.c b/tools/testing/selftests/cgroup/test_kmem.c
index eeabd34bf083..12f59925500b 100644
--- a/tools/testing/selftests/cgroup/test_kmem.c
+++ b/tools/testing/selftests/cgroup/test_kmem.c
@@ -368,11 +368,15 @@ static int test_percpu_basic(const char *root)
 
 	for (i = 0; i < 1000; i++) {
 		child = cg_name_indexed(parent, "child", i);
-		if (!child)
-			return -1;
+		if (!child) {
+			ret = -1;
+			goto cleanup_children;
+		}
 
-		if (cg_create(child))
+		if (cg_create(child)) {
+			free(child);
 			goto cleanup_children;
+		}
 
 		free(child);
 	}
-- 
2.43.0


