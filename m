Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5EE8CAC5A7
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 10:11:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2681A8E0001; Mon, 22 Sep 2025 06:10:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2003D8E0010; Mon, 22 Sep 2025 06:10:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1FE18E0001; Mon, 22 Sep 2025 06:10:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D23DB8E000F
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 06:10:55 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 944C4C05D0
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 10:10:55 +0000 (UTC)
X-FDA: 83916467670.16.8A627B4
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4EDF5C0004
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 10:10:51 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	spf=pass (imf28.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758535853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8OUTYjxcjxxHWxR5LZ/wlhMi0zwXyoRsjJC+CpLjkdc=;
	b=0Ap3RkPo5If8iPm20Khjp+waiFo/A1Hytq4vxdB3c9CWNS+uytTeWZKioh3ik6q2B9gGeL
	ABVjFU3+9SUeUPY/K1AGM2sjvksToEYOgL8hwMXglWxC544JEAB6TPQFPS6q2SIzv+HsGN
	AfwrqmB+cPxKxf1xqg7KvDeIyL+NJus=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758535853; a=rsa-sha256;
	cv=none;
	b=ywM8nEUCpjBSjGhL5hBDhr1ehmB6fTd0DQr1/rVkKJiQL5r17kxzoE5QgrFyPcD/0sVEe9
	Zzs4zUWPhG21Ki/0r3mKInfc2SmDU76ogBlR6KcIrkJsmU2Y3gEqSwcEvPsKNO0v2tuJsM
	vI97Rg4Kit4FiPz6sNDzPHAuAYN/H9s=
X-UUID: 65f05902979c11f08b9f7d2eb6caa7cf-20250922
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_TXT, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS
	GTI_RG_INFO, GTI_C_BU, AMN_T1, AMN_GOOD, AMN_C_TI
	AMN_C_BU, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:5c8a2a3f-503f-44a6-af0f-1a5d4aebc910,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-5
X-CID-INFO: VERSION:1.1.45,REQID:5c8a2a3f-503f-44a6-af0f-1a5d4aebc910,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:6493067,CLOUDID:31d7d39b95cce73a5dc3d5d670b85d5f,BulkI
	D:250922154409NPG9RFLE,BulkQuantity:1,Recheck:0,SF:17|19|24|38|44|66|78|81
	|82|102|850,TC:nil,Content:0|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:40
	,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:
	0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_FSI
X-UUID: 65f05902979c11f08b9f7d2eb6caa7cf-20250922
X-User: lienze@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1089521498; Mon, 22 Sep 2025 18:10:42 +0800
From: Enze Li <lienze@kylinos.cn>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	enze.li@gmx.com,
	Enze Li <lienze@kylinos.cn>
Subject: [RFC PATCH 2/2] mm/damon/sysfs: add priority support for DAMOS targets
Date: Mon, 22 Sep 2025 18:10:22 +0800
Message-ID: <20250922101022.362822-3-lienze@kylinos.cn>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922101022.362822-1-lienze@kylinos.cn>
References: <20250922101022.362822-1-lienze@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4EDF5C0004
X-Stat-Signature: qt7tk5wb57y5tiiz7q4n4jd4woi33pyx
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758535851-186450
X-HE-Meta: U2FsdGVkX1+gGTPj5b5o85tcBVFKHRhHSz4KIN8ryCbRZ2ViwCgpqSvixrarUCenGMzHZN+0SgQJ2i58Vky1bpPkbaZbWAlEJNaEGL0aTd5Mhi+NLSaFLRKHqD+FzQ+C3y7nW7HJgU2qklAKZTcYfjCv7Kooy+1J43lZ7R85oQMVUPJtXFT/7uH+FRiMPG4UOCC++ZAKUr9TDp55TF1tckHYHZGKUu196ZpDAH0EDA8PeGj0QJgxKVs8YdVBYA7171MrLC28Wh0kwNXA/qN8cNzDOGkPZxB+jg4qe3N6MKpis2kyif5Ppp56s0UDZpxonmFd7YQG0g+RzujiRacdkIdwepn0SPwSK6OPFB6Fj35kCYgijntuV/vL27LjvD1oeTCfu0lp6MGWNgAeXN8r7ggPbGOgGIOBGgDHQpjmeZZ9NUp8EHgdw6tBgEVmChIbxZ04yo/EnsUjzx3TRiZfMo6MeYT5ZSnwM3SvgIMhPOlLlQLAVVYmhollVjk4DeP4Mbvb6P3xoRwZ3hGbfEPqVT709Br6NMybqZrkmgxaqwBItuaor/8Zn2pFMV+VLasmkHjuniH2ActA+uVoF0x6tiGnVlIhNE1/5+t9ADbAayjYfdJKfm40cUOKMl2/Zirug68rFwt9eTygvn/opmWCF1Y7g8kzKORXTvIU/z00t+mL1wKT/aWaJpMZzrgGk2tjpeiBOgjvfX6V5X+tV9VO1uzyDPQxe+eM6TyBiULVR3ZYbWNYhP+rpygIcWf4hWs5+ckyHCor28iRYFuwu8HFA9qdJldxqaLtcXQbK6BTchE7LyDOm1ebFjch+KVOqZg0Cck0DCcIV+oH5K7BA47w71YmZqkDZYGHvV13iItaPTMc2XHx32NF0AQOcN2XP68u1E0KB4XCjBl/J+ZLajK849dTYVu9NaHnZ0xGiDXoUqCfTiSMxDLOQXDLQCKaWHXPjHAheXKNbxMXEqgsQC7
 4EGDUint
 VIEVdEiS+8PP+juIZs2V8nwSjcdmrFjgZ1Bpz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch extends the DAMON sysfs interface to support the configuration
of target priorities, enabling users to assign and adjust the relative
importance of monitored processes at runtime.  A new sysfs file, priority,
is added under each target’s directory (e.g.,
/sys/kernel/mm/damon/admin/kdamonds/0/contexts/<ctx>/targets/<target>/priority).
Users can write an integer value to this file to set the priority level for
the corresponding target.  Reading the file returns the currently assigned
priority.

The interface integrates seamlessly with the existing priority-based
scheduling mechanism introduced in the core DAMON logic.  When a priority
value is set via sysfs, it directly influences the frequency of scheme
applications for the target.

This enhancement provides user-space administrators and adaptive system
controllers with the ability to dynamically adjust monitoring and memory
management priorities based on real-time workload requirements.  The change
maintains full backward compatibility -- targets without a configured
priority use the default behavior, ensuring no disruption to existing
deployments.

Signed-off-by: Enze Li <lienze@kylinos.cn>
---
 mm/damon/sysfs.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 6d2b0dab50cb..cd08732f3b6d 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -212,6 +212,7 @@ struct damon_sysfs_target {
 	struct kobject kobj;
 	struct damon_sysfs_regions *regions;
 	int pid;
+	int priority;
 };
 
 static struct damon_sysfs_target *damon_sysfs_target_alloc(void)
@@ -271,8 +272,33 @@ static void damon_sysfs_target_release(struct kobject *kobj)
 static struct kobj_attribute damon_sysfs_target_pid_attr =
 		__ATTR_RW_MODE(pid_target, 0600);
 
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
+	struct damon_sysfs_target *target = container_of(kobj,
+			struct damon_sysfs_target, kobj);
+	int err = kstrtoint(buf, 0, &target->priority);
+
+	if (err)
+		return -EINVAL;
+	return count;
+}
+
+static struct kobj_attribute damon_sysfs_target_priority =
+		__ATTR_RW_MODE(target_priority, 0600);
+
 static struct attribute *damon_sysfs_target_attrs[] = {
 	&damon_sysfs_target_pid_attr.attr,
+	&damon_sysfs_target_priority.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_target);
@@ -1340,6 +1366,8 @@ static int damon_sysfs_add_target(struct damon_sysfs_target *sys_target,
 			/* caller will destroy targets */
 			return -EINVAL;
 	}
+	t->priority = sys_target->priority;
+
 	return damon_sysfs_set_regions(t, sys_target->regions);
 }
 
-- 
2.51.0


