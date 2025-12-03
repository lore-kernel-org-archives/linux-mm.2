Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A797D12D4C
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 11:57:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D97E6B002B; Wed,  3 Dec 2025 06:57:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B1616B0062; Wed,  3 Dec 2025 06:57:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EE656B0088; Wed,  3 Dec 2025 06:57:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6252A6B002B
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 06:57:25 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 19B081404FC
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 11:57:22 +0000 (UTC)
X-FDA: 84178009524.27.62B65C1
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf19.hostedemail.com (Postfix) with ESMTP id 66ED41A000C
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 11:57:19 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	spf=pass (imf19.hostedemail.com: domain of zhangguopeng@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangguopeng@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764763040; a=rsa-sha256;
	cv=none;
	b=hq6tCkXQvkRLHB+VzphBLNbcPmrLbgCy8s7EcOTUruHstobpmx/qUxjegDTBlfz+owT/Y4
	ASpVxYbiNWH6VUUASW/fz2LIBG63KabbBuISsf25gU6P1qrEZH2JSZI3yT8Qnmu12uD0fb
	oVaWaXWnlTAcHHq/vvhmmx4YxxONBrM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of zhangguopeng@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangguopeng@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764763040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b02HORmVVxjw2robqlvE2chYcEWBo5hWLk08rd1xWA4=;
	b=0N8xrvKTnaADXbMFwh53+aRvQLDEwJRNkgTSkIl+9jy1WJtcPiw+fRPTuc9WtjUvVcyTin
	99MDB4mFKH+Wo/Vm6czOXJ5EwKSlDAkuPi2gc+AoVr234VPiTpXRbKOGnEMNkn+Ht0y4v6
	tRyqiuj56y9kTZzbBE4Xad9+qF0dloE=
X-UUID: 32c2b594d03f11f0a38c85956e01ac42-20251203
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_TXT, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:9b517952-cf82-42c9-8929-cfe76af86642,IP:10,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:0
X-CID-INFO: VERSION:1.3.6,REQID:9b517952-cf82-42c9-8929-cfe76af86642,IP:10,URL
	:0,TC:0,Content:-5,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:2c81f6f184124145c3e33436ac1623b1,BulkI
	D:2512031957120TJFA92I,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|81|82|10
	2|127|850|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bu
	lk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:
	0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FSD,TF_CID_SPAM_SNR,TF_CID_SPAM_FAS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 32c2b594d03f11f0a38c85956e01ac42-20251203
X-User: zhangguopeng@kylinos.cn
Received: from localhost.localdomain [(223.70.160.239)] by mailgw.kylinos.cn
	(envelope-from <zhangguopeng@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 404167327; Wed, 03 Dec 2025 19:57:10 +0800
From: Guopeng Zhang <zhangguopeng@kylinos.cn>
To: tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	shuah@kernel.org,
	roman.gushchin@linux.dev,
	lance.yang@linux.dev,
	shakeel.butt@linux.dev
Cc: muchun.song@linux.dev,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH v5 1/3] selftests: cgroup: Add cg_read_key_long_poll() to poll a cgroup key with retries
Date: Wed,  3 Dec 2025 19:56:29 +0800
Message-Id: <20251203115631.947908-2-zhangguopeng@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251203115631.947908-1-zhangguopeng@kylinos.cn>
References: <20251203115631.947908-1-zhangguopeng@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 66ED41A000C
X-Stat-Signature: 7r7w9id5j9re74k6tg5i99q6iypkuyj4
X-Rspam-User: 
X-HE-Tag: 1764763039-321953
X-HE-Meta: U2FsdGVkX18N/yzJzZcvIF7kTmiZM70M5YxYw3bw9GyGada3WksVZD0D6NhCvGJEijkF/x3nWn86KGcIbKh/xIIdZbLmuVOnrsGLBwm8k7TmSkUhW6TmDm/VTa/fwo3SjcrVw61JSnH2l5ERc+c4wQ8683+V6+xSXXXB75b60Q1/1anGNgZVroCfKd4L+h82Qu3UKrH6hgo6GeC5E6Zzf2qvjc8EaL1hdNp5Ki1TKk3iep6GorMSSjHiOegqkHuHJ3LqJTRX9qy1WJV3ufGjLaY7auQAHIScntT7EdJ91tXcebL6EdcFb01hzkaltVmHiIoij3+/0C+ntbtURj4zAdHZDM7DZvD8+ZVKj9J8H+KgP4hkoBt9sdSDftMxBFs4/hMsadMsClNNL92VBnsMcmF3TS6JEp0RT5i/Ell0VOtDmaLvP35a8e/Ne7cF+uQRHq2EdlqmpsIXmYIWK/5t4prkMI6Xj8zw8s6Y/gRO35VM4Xh1UJo2p85qHf5fHuC1tVPYVkqQXQPwkMV0xOvnqP/jSIYRM3NLo449akQtrCfpBt02NXyK+yOCQprSiRVYAvUNBu6EfPyxcp1yKTKtpW5XmQMR7x80yyS4sL3mrYL2vhnsRw9TBwVR0Lrhv/RjpHRCrI+HWfV64ibHktQA6tGN/4KuIJku8cXMGE+FQm/G8G10U1bihC1TxqMGSrwszX2RTrlB5IpIYCV2yasSKgAlaabfsS7IrJeDobyur6Hc5S2JLlTVEPQ//J81ygUZM2iUPFSVXd0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a new helper function `cg_read_key_long_poll()` in
cgroup_util.h. This function polls the specified key in a cgroup file
until it matches the expected value or the retry limit is reached,
with configurable wait intervals between retries.

This helper is particularly useful for handling asynchronously updated
cgroup statistics (e.g., memory.stat), where immediate reads may
observe stale values, especially on busy systems. It allows tests and
other utilities to handle such cases more flexibly.

Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Suggested-by: Michal Koutný <mkoutny@suse.com>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 .../selftests/cgroup/lib/cgroup_util.c        | 21 +++++++++++++++++++
 .../cgroup/lib/include/cgroup_util.h          |  5 +++++
 2 files changed, 26 insertions(+)

diff --git a/tools/testing/selftests/cgroup/lib/cgroup_util.c b/tools/testing/selftests/cgroup/lib/cgroup_util.c
index 44c52f620fda..ce6c2642fd9b 100644
--- a/tools/testing/selftests/cgroup/lib/cgroup_util.c
+++ b/tools/testing/selftests/cgroup/lib/cgroup_util.c
@@ -168,6 +168,27 @@ long cg_read_key_long(const char *cgroup, const char *control, const char *key)
 	return atol(ptr + strlen(key));
 }
 
+long cg_read_key_long_poll(const char *cgroup, const char *control,
+			   const char *key, long expected, int retries,
+			   useconds_t wait_interval_us)
+{
+	long val = -1;
+	int i;
+
+	for (i = 0; i < retries; i++) {
+		val = cg_read_key_long(cgroup, control, key);
+		if (val < 0)
+			return val;
+
+		if (val == expected)
+			break;
+
+		usleep(wait_interval_us);
+	}
+
+	return val;
+}
+
 long cg_read_lc(const char *cgroup, const char *control)
 {
 	char buf[PAGE_SIZE];
diff --git a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h b/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
index 7ab2824ed7b5..77f386dab5e8 100644
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
+			   const char *key, long expected, int retries,
+			   useconds_t wait_interval_us);
 extern long cg_read_lc(const char *cgroup, const char *control);
 extern int cg_write(const char *cgroup, const char *control, char *buf);
 extern int cg_open(const char *cgroup, const char *control, int flags);
-- 
2.25.1


