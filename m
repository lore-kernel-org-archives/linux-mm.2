Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A2AFD1CDC6
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 14:51:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A7B16B0007; Tue,  9 Dec 2025 09:51:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 553DD6B0008; Tue,  9 Dec 2025 09:51:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 490816B000A; Tue,  9 Dec 2025 09:51:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 376AD6B0008
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 09:51:11 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F10CD138721
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 14:51:10 +0000 (UTC)
X-FDA: 84200220300.20.FA1AB06
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1E66DA000C
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 14:51:06 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	spf=pass (imf25.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765291868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lL5CkCFk2dD+UlKKKGgt5ByhHV3HuPbGbVrdY5XUhd0=;
	b=qTTzyDJbn2xVwxJ5/+p8yInI/6kK5GaPpgnzSb78KGvYZKVv17+L2SuZCekYbocyDnLdFB
	YgEC7kNWfUpMIX7Qz6dzlEckg5WJ7S0q+L54p6XyD8ThN4bqi7svXCY46pZ20NSbr7+A2g
	t9y41e/4f4LdIsirpBl0nX33ghqnAX8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765291868; a=rsa-sha256;
	cv=none;
	b=a5j3ahFMh6hrPBhXweE+/hxkd6EU//b8EPOt+B87J2f7sjG+Lpnb7HirBBtk2TbLJviZoJ
	VVKaVoB8C4zdnG8rlsp7WaE7EfBoXaoTj8NqQthpNEnDG5JtSn21YZAi+RinqCucT0gcfn
	O48nh+rYdqKBWSWEolDoWJpaWOywzhs=
X-UUID: 78ea16bad50e11f0a38c85956e01ac42-20251209
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_UNTRUSTED, SRC_UNTRUSTED, IP_UNFAMILIAR, SRC_UNFAMILIAR
	DN_TRUSTED, SRC_TRUSTED, SA_TRUSTED, SA_EXISTED, SN_TRUSTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD_SPF
	CIE_UNKNOWN, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD
	ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:3c077365-ec3e-4004-be08-8f9088a058de,IP:10,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:5
X-CID-INFO: VERSION:1.3.6,REQID:3c077365-ec3e-4004-be08-8f9088a058de,IP:10,URL
	:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:5
X-CID-META: VersionHash:a9d874c,CLOUDID:4998a732b51ff6292f3d92f16951c3af,BulkI
	D:251209224349XEKF8H49,BulkQuantity:1,Recheck:0,SF:17|19|38|66|78|81|82|10
	2|127|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:4
	1,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE
	:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 78ea16bad50e11f0a38c85956e01ac42-20251209
X-User: lienze@kylinos.cn
Received: from ubuntu.. [(61.48.214.33)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1716179415; Tue, 09 Dec 2025 22:50:58 +0800
From: Enze Li <lienze@kylinos.cn>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	enze.li@gmx.com,
	Enze Li <lienze@kylinos.cn>
Subject: [RFC PATCH 2/2] mm/damon/sysfs: introduce priority sysfs interface
Date: Tue,  9 Dec 2025 22:50:26 +0800
Message-ID: <20251209145026.3263754-3-lienze@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251209145026.3263754-1-lienze@kylinos.cn>
References: <20251209145026.3263754-1-lienze@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: khxnk83j6xmp6sjmeyfpifs7j85m3zbx
X-Rspamd-Queue-Id: 1E66DA000C
X-Rspamd-Server: rspam06
X-HE-Tag: 1765291866-480128
X-HE-Meta: U2FsdGVkX18k1BREYlhgL6S7xFP+FD/QqSl6IgnxHLIKxANzfpKeGVzMyWhrxiCOGSpEjMThFgsTmfLZTM2zjUV5R0tVTpNA0k4HSAOwti7GsdFF7VQhVquZI9uYFgcWP4kF8Cfpu07KSQpYYyvBOcCjgfPKjBEpmlMv3eQuAeM+Xn2ixs1zcFL960IMu2R80sVMYPm39zmAx1TJcbxqPSgnPknxhF7h0NQitcQvyHyiCwuaVheRv5dfxY4VANeNZaDKYy3X8rKr3uq4y06ipp/YH1Uvjwvf5vM9rSWBEkt8Dk5gXruJSiwuxNHv5ZFZGODyNmz9qWY9WNtnzJRJAH09IbdLJ2dIEFAw8FiaN5vBhgJFSwVR0jLFgw+DEdu5BE8w309uSQHLfrLOofOZb7VnHbltWK1J3gf7NmUHHbGJxoArk3IaHQWXflGGHM+g3ps5bw5xgqsPEc+6uhrqzZE5raWzlTKmYnP/Z5QK5iLAQwf9zktfEBGIH33bO0ge7QZr1zBAknJ7XFOhqp2MO6j+E7+oESta2CxUJwlK+Mre+JIpbzxm75YGFhpDQqeu11xKkcyH5d0ngxrnpM8dVldkIuM5299V0hiYN+mctsyJUYJYeEJC+djdOMvz3Aj/8q0Wf6QKAM4VdJ4yCZ5mQqLv2DohbZClV8xBZ04D2TTKVL1GKQH9uYFBW9c5IxVNBdCaXR/TUcFa33aOJ6ulAxm1rIusnyJJ1YwrDT5ZYAuQTD/4XJ1cfgknl6NsvfQjAryqBguHQjNtntqCfMZKEnPFh82heRssgnmPuCiRcwo3Whjsq5rKLpM86EgKtNrSrS13FQRv9BNR8/RgDZfsQuo5Q4P5wu97OnArVESKZEnbaXyRO8dtwNQcpC1TR2XQgY2JY23N7tb6HhYrQzOhOxCuUdpx50ypEPnuY7DZraVhZDLdzUe701pWFhIR6TnYhu3raRXKL6GpR9vbTwN
 BHKl/+8m
 vDto6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch extends the DAMON sysfs interface to support the
configuration of target priorities, enabling users to assign and adjust
the relative importance of monitored processes at runtime.

Signed-off-by: Enze Li <lienze@kylinos.cn>
---
 mm/damon/sysfs.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index e2bd2d7becdd..224d9e89d967 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -213,6 +213,9 @@ struct damon_sysfs_target {
 	struct damon_sysfs_regions *regions;
 	int pid;
 	bool obsolete;
+#ifdef CONFIG_DAMON_AUTO_TUNING
+	int priority;
+#endif
 };
 
 static struct damon_sysfs_target *damon_sysfs_target_alloc(void)
@@ -298,9 +301,44 @@ static struct kobj_attribute damon_sysfs_target_pid_attr =
 static struct kobj_attribute damon_sysfs_target_obsolete_attr =
 		__ATTR_RW_MODE(obsolete_target, 0600);
 
+#ifdef CONFIG_DAMON_AUTO_TUNING
+static ssize_t target_priority_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_target *target = container_of(kobj,
+			struct damon_sysfs_target, kobj);
+
+	return sysfs_emit(buf, "%d\n", target->priority);
+}
+
+static ssize_t target_priority_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	int err, value;
+	struct damon_sysfs_target *target = container_of(kobj,
+			struct damon_sysfs_target, kobj);
+	err = kstrtoint(buf, 0, &value);
+	if (err)
+		return -EINVAL;
+
+	if (value > 0 && value <= 100)
+		target->priority = value;
+	else
+		return -EINVAL;
+
+	return count;
+}
+
+static struct kobj_attribute damon_sysfs_target_priority =
+		__ATTR_RW_MODE(target_priority, 0600);
+#endif
+
 static struct attribute *damon_sysfs_target_attrs[] = {
 	&damon_sysfs_target_pid_attr.attr,
 	&damon_sysfs_target_obsolete_attr.attr,
+#ifdef CONFIG_DAMON_AUTO_TUNING
+	&damon_sysfs_target_priority.attr,
+#endif
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_target);
@@ -1406,6 +1444,9 @@ static int damon_sysfs_add_target(struct damon_sysfs_target *sys_target,
 			return -EINVAL;
 	}
 	t->obsolete = sys_target->obsolete;
+#ifdef CONFIG_DAMON_AUTO_TUNING
+	t->priority = sys_target->priority;
+#endif
 	return damon_sysfs_set_regions(t, sys_target->regions, ctx->min_sz_region);
 }
 
-- 
2.43.0


