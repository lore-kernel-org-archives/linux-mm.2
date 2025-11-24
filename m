Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68C63CFD313
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 12:39:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2E506B0024; Mon, 24 Nov 2025 07:39:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B05156B0026; Mon, 24 Nov 2025 07:39:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A426F6B0027; Mon, 24 Nov 2025 07:39:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 93CBB6B0024
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 07:39:30 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6129E8890C
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 12:39:30 +0000 (UTC)
X-FDA: 84145456500.01.852CEC3
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8797D160013
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 12:39:27 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	spf=pass (imf08.hostedemail.com: domain of zhangguopeng@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangguopeng@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763987968; a=rsa-sha256;
	cv=none;
	b=UqGNNe3aXltFQwYi4H37e2DVTOp7fIHurMerkzbQ9BEY52eSBEC2wJ9RB9sIqzzUoxHHRr
	4scUNkk7iqm1Kga+srJplwKfnP297IDKTSanB71J0UJzfAIecIRCrfHz7D5EsNEmTeV6LT
	d0ggrSgOTdvX6UBwn+YOYi3g06dDYjQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of zhangguopeng@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangguopeng@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763987968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RxDJT0s6ye6FRjy6lCy2CrkINkoACQyeuu8NsRRygbc=;
	b=CkKvaObRDFaPfboFFSS3/CmX9AW5pRRhzM1qBmipulLDvLFkJqL+n8G4DGeKb1nOTHS5UJ
	LoSPcHqSSTq6VpLId9a13cXvQZX/BYWpBdovrh76tDFk2dYbzDsuGyBmRx94Q2DcU/5co4
	ieI8RUe244BDCPMs7BbdzEVmDXXYG0Q=
X-UUID: 98483984c93211f0a38c85956e01ac42-20251124
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_TXT, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD
	CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD
	ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:42b03b5e-27eb-45ad-9959-30113448a8c4,IP:10,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:0
X-CID-INFO: VERSION:1.3.6,REQID:42b03b5e-27eb-45ad-9959-30113448a8c4,IP:10,URL
	:0,TC:0,Content:-5,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:fbe2a9042fa2bbbafeb5aba0e34aac7c,BulkI
	D:251124203921M1CZFT1B,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|81|82|10
	2|127|850|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bu
	lk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:
	0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 98483984c93211f0a38c85956e01ac42-20251124
X-User: zhangguopeng@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <zhangguopeng@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 149211058; Mon, 24 Nov 2025 20:39:18 +0800
From: Guopeng Zhang <zhangguopeng@kylinos.cn>
To: tj@kernel.org,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	mkoutny@suse.com,
	muchun.song@linux.dev
Cc: lance.yang@linux.dev,
	shuah@kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH v4 1/3] selftests: cgroup: Add cg_read_key_long_poll() to poll a cgroup key with retries
Date: Mon, 24 Nov 2025 20:38:14 +0800
Message-Id: <20251124123816.486164-2-zhangguopeng@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251124123816.486164-1-zhangguopeng@kylinos.cn>
References: <20251124123816.486164-1-zhangguopeng@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8797D160013
X-Stat-Signature: w3dmwp4grmo5gkfaeiobq1yws7cqy4nz
X-HE-Tag: 1763987967-143295
X-HE-Meta: U2FsdGVkX19KVIMtHAC9TiCEgiX9FRguSFVNfPRGjwz33QneSnhTg/LbVfB/zfLoC0Ul2m9QL6Or+ITC44NsLHmlcA+mlL1108N4O5FtGLdd5HEO+uPrEUPOUjin7EA69tDgNfCBTcyp0D1Pm9INkNiAzGcdtSlLvUqgZSULkgQkWp5koktoao20FbMbx2tHcKSuoXOfFHp2onDGx2QuPbwFeI+rphsQbkQ2Kj4Zjukoojl4mppBBu+IPx2tw4appbf1Cnbb6EcSB1JkPblznUGeiObMumYD72nfTliWJV/mU0LVMpUI7a6nIE4jDCARl3epqdZ+rCO8fR4ab44mkJ8HHZTXXhn9ERivUvlaL9pOHQ9ceEC1T70YrhU5TCXihr6ZuJ1oof3YtI0IJvWvKdD/aN+SLE0/J1PLReZxTvHaCCH0YuO+pfzS38YHcpgujmR25/HS8DsdVjBK1jyBHtjyONBzx1rRoVCIBXUBkzSGgFSmk/ukZQ+eCFSFKMSBnaeYZRqWxiYQAN656NxxxSVDRlfLFWeSBVyAj1rNCzihWshxgH0LUMZqJMJdVigDOZ2lIAD69+/S5uNQcnXyy8WXBvpcgQh5LLQfPr4v4igodua8FjYvkMxXLmpBG+DObE86E4FmBW72rskc+8zTBdQss/xpfCu4pTsvtc0iJoiRYtdmOBmrRGx+ngmI9V6hvToCDECBbrx6kwmMS93rqk/qyhJBmsKS7AZPNHJcFwk7VZ3O2GUi/O80NMQNnfZUrkVou+t0Ya8SsUvpmV7GcioZ7GeD4bebu9FmTJiHxAzY8Ht4oWsufKIa7Ox39thuOkUns4qAvEWFWb9Zhfci2Og5Mn06L4FxDOA4uvgjrwGvOVkRPqBZ1sLzuEg2pz0C+Xfa+Z7/fYn1QXLv3I7teh1aesPuZsNwGySm+K5RRyqWnm3jYTWlShs/aMV8ix4FZZ4KI+iQuP2Blrr6DIa
 YOvXIbTt
 Y/Ipz8kaH3MzNmaGLRD8PbxZJKEVbKdtQ8+V1i9AcTc1NILLuPiNW7ZfrNWPlCu3wBxGALclnSPzoXXrcIToSXgQC43EJJBy9Ez+Vq+CedNr/lZVGPuRdQoNV810Ac0KmpXDEYkRsVVG2yyem8CqgpbEzng==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a new helper function `cg_read_key_long_poll()` in cgroup_util.h.
This function polls the specified key in a cgroup file until it matches the expected
value or the retry limit is reached, with configurable wait intervals between retries.

This helper is particularly useful for handling asynchronously updated cgroup statistics
(e.g., memory.stat), where immediate reads may observe stale values, especially on busy systems.
It allows tests and other utilities to handle such cases more flexibly.

Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Suggested-by: Michal Koutný <mkoutny@suse.com>
---
 .../selftests/cgroup/lib/cgroup_util.c        | 21 +++++++++++++++++++
 .../cgroup/lib/include/cgroup_util.h          |  5 +++++
 2 files changed, 26 insertions(+)

diff --git a/tools/testing/selftests/cgroup/lib/cgroup_util.c b/tools/testing/selftests/cgroup/lib/cgroup_util.c
index 44c52f620fda..953835f5da66 100644
--- a/tools/testing/selftests/cgroup/lib/cgroup_util.c
+++ b/tools/testing/selftests/cgroup/lib/cgroup_util.c
@@ -168,6 +168,27 @@ long cg_read_key_long(const char *cgroup, const char *control, const char *key)
 	return atol(ptr + strlen(key));
 }
 
+long cg_read_key_long_poll(const char *cgroup, const char *control,
+                             const char *key, long expected, int retries,
+                             useconds_t wait_interval_us)
+{
+        long val = -1;
+        int i;
+
+        for (i = 0; i < retries; i++) {
+                val = cg_read_key_long(cgroup, control, key);
+                if (val < 0)
+                        return val;
+
+                if (val == expected)
+                        break;
+
+                usleep(wait_interval_us);
+        }
+
+        return val;
+}
+
 long cg_read_lc(const char *cgroup, const char *control)
 {
 	char buf[PAGE_SIZE];
diff --git a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h b/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
index 7ab2824ed7b5..772f5383ddc7 100644
--- a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
+++ b/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
@@ -17,6 +17,8 @@
 #define CG_NAMED_NAME "selftest"
 #define CG_PATH_FORMAT (!cg_test_v1_named ? "0::%s" : (":name=" CG_NAMED_NAME ":%s"))
 
+#define DEFAULT_WAIT_INTERVAL_US (100 * 1000) /* 100 ms */
+
 /*
  * Checks if two given values differ by less than err% of their sum.
  */
@@ -64,6 +66,9 @@ extern int cg_read_strstr(const char *cgroup, const char *control,
 extern long cg_read_long(const char *cgroup, const char *control);
 extern long cg_read_long_fd(int fd);
 long cg_read_key_long(const char *cgroup, const char *control, const char *key);
+long cg_read_key_long_poll(const char *cgroup, const char *control,
+		  const char *key, long expected, int retries,
+		  useconds_t wait_interval_us);
 extern long cg_read_lc(const char *cgroup, const char *control);
 extern int cg_write(const char *cgroup, const char *control, char *buf);
 extern int cg_open(const char *cgroup, const char *control, int flags);
-- 
2.25.1


