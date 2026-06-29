Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45F3DC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 01:44:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC6566B0092; Sun, 28 Jun 2026 21:44:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9DF26B0093; Sun, 28 Jun 2026 21:44:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB4296B0095; Sun, 28 Jun 2026 21:44:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A2BDD6B0092
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 21:44:03 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 19E7F1A0535
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 01:44:03 +0000 (UTC)
X-FDA: 84931254366.17.DE3469F
Received: from smtpbgeu1.qq.com (smtpbgeu1.qq.com [52.59.177.22])
	by imf29.hostedemail.com (Postfix) with ESMTP id 38500120005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 01:43:58 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=ny+ZY+iB;
	spf=pass (imf29.hostedemail.com: domain of chenyichong@uniontech.com designates 52.59.177.22 as permitted sender) smtp.mailfrom=chenyichong@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782697440;
	b=5D4a4bH+z226EdImv1bhR4oW0FmDA0v7jg1WN1MZAvsRvT4802Ru1OEUpfmoVblvW7bUIX
	nQN8qBUlMcT4KLeB/IqMcQd9kUNoVZuVZXGNj/593pPEBWq9myTQSgzK72BuMhfekwOW/i
	I0Mbi0D8hcAvQAWYPN2Js5v2BWKoqWA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782697440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d/eHSUknk0sCy7CxDqOch56J+Ya+GbJ/5sqC4UKx71s=;
	b=SyFGrX1k4gToUSN8ev8VZq9BjQ9E0ifCSPzuzvJDc/vdQ6YsYdXR6N/mvX+IYMKEvbr6E9
	ruEmEP21AdFmWfBSo5R2JKwqSQYHdi0w1L1D3f7ha1YKCsaXhlWGAQCVR9nR6MWzw1kywY
	H1qoAgG7UVp3t6aFEt3MNamvGvvOPAA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=ny+ZY+iB;
	spf=pass (imf29.hostedemail.com: domain of chenyichong@uniontech.com designates 52.59.177.22 as permitted sender) smtp.mailfrom=chenyichong@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1782697422;
	bh=d/eHSUknk0sCy7CxDqOch56J+Ya+GbJ/5sqC4UKx71s=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=ny+ZY+iBvuvOxbbG6Qr5fLuPLzooR7yZIhThEGYZqBoSCp7BGXCCA8z+u5rXxLRlK
	 ol2bwUcxJVDByJSPGcYx6mxJx1GEWuWXQYV/ZisuPXbpY07/wGAdT4/Ru94N1bSGMZ
	 mFNbqd18eA+qdg0+lCzov4zlLK3hbzoKLxd8MeA8=
X-QQ-mid: zesmtpsz7t1782697417t1fff5ac5
X-QQ-Originating-IP: NOE+I24n44xPEKmRpXWUns3nbx+KmIpjpirkQUuN0bk=
Received: from uniontech.com ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 29 Jun 2026 09:43:34 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 10259888320296844636
EX-QQ-RecipientCnt: 7
From: Yichong Chen <chenyichong@uniontech.com>
To: akpm@linux-foundation.org
Cc: vishal.moola@gmail.com,
	ye.liu@linux.dev,
	zhen.ni@easystack.cn,
	chenyichong@uniontech.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 3/3] tools/mm/page_owner_sort: bound pattern output copies
Date: Mon, 29 Jun 2026 09:43:16 +0800
Message-Id: <20260629014316.130307-4-chenyichong@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260629014316.130307-1-chenyichong@uniontech.com>
References: <20260629014316.130307-1-chenyichong@uniontech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: OEU2aer3F3z2nGr2BYCcmQRyE5JBGAP3Or6xYA388ComUgHcBtS5UybC
	cEFcXi0xEZXTUtdycd8kXEcX9CbrvOhsv8omTO7EDU1Y0IY7nepzWOJNaO0bQ7CywJv3373
	zOYd3o7SEFCUrn2EzkUTTXmESD/OMWgQ0JmyfoVApy2oLxlaQse6uFWDxiKRvO5NeVeys/F
	RZSl22J8rop9CNG+Mlgr2OR/RSidSGBP3jTpYACxsMDSEyh67KuJ4Lcb06e0Y3CEr25R3ZG
	V7i0vrQ38I0dXxxwl4f5qRJqqnDRo//0FAZus6HS6v9P+07T0z3iyGhGHKSpI/ZFVO4bh8a
	5un7c63J81RK9unsQqVZymOOz2+rSbXclL19Hqv8SSJC/oZoSBeZEgEfY9k+ycwpodIFBz3
	jnE1ozVEl6ICZhqwX0hkQjcOZ/CIxHwHjMbhuf//7QUaYLaVujfuSEk2vldpdMm6oTqjcmW
	t2HkTimjSOmyhgXu+LsddaLejuddwHzrZe4FvyelL08vPxMpwJ7tLkw0hy1zqEjOHqUXwtl
	pEH2HMlHUV6yTranwodsKlz/5QX/WtxBSNKM8xZPQ9308ruFDBlvN91dEhwVj9ikJGdQT1b
	XOwIO93r5lgvOdrBiCD0EcQtw0n3OsdT4fwDQoqzbUlhiNlG5mGctG3YX374OpawFOYD79b
	GqctzYqXC4nrvBUr3ZHfk5Ffn6cg1qZwClr/fVZYKhlvl7r4SajlXIL1Wa2W9HnHdWCgbb2
	zMUW1JGiNk6C+aeZKtlGRApIchClgOqpsp8+njxTRtkaWuUp3AvMz8V3U6mne5Z8Q4Qdswh
	HARS16pDuFtt1SESkIvClcy6Ykm3bpyXboiQ/lw9QOsRGQs3RjjmiSUyHPOG8hzCitsPvmo
	j41R/T772iw7rIeWANBjgaFbd0DKMPkUbJoCX2qqBhPBi78fZyNdLJ3EoC975cgbl8uYbnz
	Myt0kkLEXSrI5SO17O0uBah3e09mhE5AD79prCT8bzphwHX51CiY6ydulkAr1eWSy9DOcZ3
	JS9Qwziof3yzgQwGPX+4QbJN/RAuxByeRCVMPtfnLO0kOdFxNxOV3k2K8LMJHJx5I/vxprX
	+G43AzDUJOj
X-QQ-XMRINFO: NI4Ajvh11aEjEMj13RCX7UuhPEoou2bs1g==
X-QQ-RECHKSPAM: 0
X-Rspam-User: 
X-Stat-Signature: awthwtiz4mgderwdge5ua9gbp96qqcbw
X-Rspamd-Queue-Id: 38500120005
X-Rspamd-Server: rspam06
X-HE-Tag: 1782697438-861217
X-HE-Meta: U2FsdGVkX1+hynNYCBPk4mhB/AACNjEC/ea4jTEBL0AM0vDvzsxeD91aSxPgJECkjSmS2xMCyytGHYrDka0hbopqOqkkQjKjuyoBf14u6c/3+hNBWFBfKVM/7qa6TPq/mx+8UdRo2Q/6a4CL/7qABVcrUDYeiV12+XasUQQxb6WbfblOHU6HfMjwfjMxkyi3ZpHop2m4ovnm/xOYrzM4S8VACvJOupl52uO7OBKEk8jGdWrA05p8Hok96WfrqaRaj29/A3eHlJ8Hy9e0C8uQThQj3seMq4eLX0bYYcIJZKqve8FLXAtz7075lxxm/hkd4C+tNZ4rpYe3IU3D17yOg8Yq8hjYFO18e6feXrzjN6/gglS4XRIuzgFCQD7qSNU041fN4Q3e5Vrr6LpdMI364BilDbIqUCA0IS6okz4mAK6HFFTFLU5uYvgblAl3OYmYA3iEw6bZOyasn7lWXe12vVws6PCh/5WMbMW0XrJ1viaupLWht/eF1xmTRFeLUI2ed0dP2cUEKferuNm1J4mXyEDJvSt34SIZYlof2xpU292FY9otT1ZpCd9wyJZykyg2LWD+y/7wtS6D4UmZTCREGlhzfgsG2tIrKetKUNVSnJSTeXQUBe1sxIuihGEAJdJsaRM7LLxdLN7rM+MThEVm0MhIdyPK4buIMLOmDwe1JoLkI8WJGD4iFF9yGQ9Y9+quPqt+zTca+jOpvYIhKJVmmRmnqscR1aajzgulpe7xHr3fL0WfdiPaIh37hxHCR4AmCwiOqbQFKZ6Gx2LPk4K2CEOJwfALC078E8KJcytsVZvjGhJmZYeklVnkp66SycbIEdHN3mAdkkFYJGaWHT+xsOdtP4cg7/Zxu5gK/ryBYXhXiHPfgRBpoh4GO7r8F6VQ0yHeWdwOw71BNAfcTDgrVflJhuUpdWAPQYN6Rd+ojCeXM/HJbZ7OamCQBe/Yd89rX8+tXHNsjBgg3UZJZ/l
 LBq2R0Go
 /QanI3H4c1E9ruSSjE7XYYZas/UCenX9oIV7nwDIRWRMUEnWXwcv9J2MaHcZ8otZtUodDlzipidJJJRcodrF4gx8G/T2oPRPvb1/26OS+LrReMtcR4OBLzqCWy3f8UjevBOnOg4FTrf2vy4n/RxoFL4JU1dB8ug86gMSR0NLtspvni1Xq1+dxzjzV5WS75Xfbq6MNBosHbbrCUwJAyz4mDaKizwTqRKM8h5kIFJQpm4oyJHGBHd0btK6XvNzi5vEx32sBGFvyHqyNNOZrixSIIanlFvmYZWMy/ULQF11tPwQpoLoJ9j3mV9KsZkFgx490ppQmgBKTP1Id5m0hq3PSUxYXibCF6MbTwnoOuCY+Fe9kWBHOZkhQMv0U1sGgxyvDHAC7T+QP+yEFCNedxCdX05/A70B64FxsKJW9ch0q3pqvsG0xruE1K8emv0m9xYyUR585dabp5eSVoL2EknZkCmQAzg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

search_pattern() copies a regex capture into caller-provided buffers
without knowing their sizes. Several callers pass fixed-size buffers,
including FIELD_BUFF and TASK_COMM_LEN.

Pass the destination size to search_pattern(), reject captures that do
not fit before copying them, and terminate the output string inside
search_pattern().

Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
---
 tools/mm/page_owner_sort.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/tools/mm/page_owner_sort.c b/tools/mm/page_owner_sort.c
index 4c9be28abe3b..35d3d254941c 100644
--- a/tools/mm/page_owner_sort.c
+++ b/tools/mm/page_owner_sort.c
@@ -237,7 +237,8 @@ static int remove_pattern(regex_t *pattern, char *buf, int len)
 	return len - (pmatch[1].rm_eo - pmatch[1].rm_so);
 }
 
-static int search_pattern(regex_t *pattern, char *pattern_str, char *buf)
+static int search_pattern(regex_t *pattern, char *pattern_str,
+			  size_t pattern_str_size, char *buf)
 {
 	int err, val_len;
 	regmatch_t pmatch[2];
@@ -249,6 +250,12 @@ static int search_pattern(regex_t *pattern, char *pattern_str, char *buf)
 		return -1;
 	}
 	val_len = pmatch[1].rm_eo - pmatch[1].rm_so;
+	if ((size_t)val_len >= pattern_str_size) {
+		if (debug_on)
+			fprintf(stderr, "pattern too long in %s\n", buf);
+		return -1;
+	}
 
 	memcpy(pattern_str, buf + pmatch[1].rm_so, val_len);
+	pattern_str[val_len] = '\0';
 
@@ -307,7 +314,8 @@ static int get_page_num(char *buf)
 	char order_str[FIELD_BUFF] = {0};
 	char *endptr;
 
-	search_pattern(&order_pattern, order_str, buf);
+	if (search_pattern(&order_pattern, order_str, sizeof(order_str), buf) < 0)
+		return 0;
 	errno = 0;
 	order_val = strtol(order_str, &endptr, 10);
 	if (order_val > 64 || errno != 0 || endptr == order_str || *endptr != '\0') {
@@ -325,7 +333,8 @@ static pid_t get_pid(char *buf)
 	char pid_str[FIELD_BUFF] = {0};
 	char *endptr;
 
-	search_pattern(&pid_pattern, pid_str, buf);
+	if (search_pattern(&pid_pattern, pid_str, sizeof(pid_str), buf) < 0)
+		return -1;
 	errno = 0;
 	pid = strtol(pid_str, &endptr, 10);
 	if (errno != 0 || endptr == pid_str || *endptr != '\0') {
@@ -344,7 +353,8 @@ static pid_t get_tgid(char *buf)
 	char tgid_str[FIELD_BUFF] = {0};
 	char *endptr;
 
-	search_pattern(&tgid_pattern, tgid_str, buf);
+	if (search_pattern(&tgid_pattern, tgid_str, sizeof(tgid_str), buf) < 0)
+		return -1;
 	errno = 0;
 	tgid = strtol(tgid_str, &endptr, 10);
 	if (errno != 0 || endptr == tgid_str || *endptr != '\0') {
@@ -363,7 +373,9 @@ static __u64 get_ts_nsec(char *buf)
 	char ts_nsec_str[FIELD_BUFF] = {0};
 	char *endptr;
 
-	search_pattern(&ts_nsec_pattern, ts_nsec_str, buf);
+	if (search_pattern(&ts_nsec_pattern, ts_nsec_str,
+			   sizeof(ts_nsec_str), buf) < 0)
+		return -1;
 	errno = 0;
 	ts_nsec = strtoull(ts_nsec_str, &endptr, 10);
 	if (errno != 0 || endptr == ts_nsec_str || *endptr != '\0') {
@@ -384,7 +396,10 @@ static char *get_comm(char *buf)
 
 	memset(comm_str, 0, TASK_COMM_LEN);
 
-	search_pattern(&comm_pattern, comm_str, buf);
+	if (search_pattern(&comm_pattern, comm_str, TASK_COMM_LEN, buf) < 0) {
+		free(comm_str);
+		return NULL;
+	}
 	errno = 0;
 	if (errno != 0) {
 		if (debug_on)
-- 
2.51.0


