Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DE22C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 13:47:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B6016B00A4; Fri, 10 Jul 2026 09:47:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78CE46B00A5; Fri, 10 Jul 2026 09:47:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CA746B00A6; Fri, 10 Jul 2026 09:47:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 439DD6B00A4
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:47:08 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D2775C3130
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:47:07 +0000 (UTC)
X-FDA: 84972993294.07.8B76890
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 414134000A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:47:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NJk5Scv9;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783691226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yJOHjYArtxH1+/qkwlfdh08BuCLZ4ONkiqi8cM2xmzA=;
	b=JiH9ZvjO1T4KaXPBZxRMpmaNIxZvLq0cegNSP/i6UpXufR/MlqJoiaM6awwRpc+GEfPvto
	ihQq9dGIB2RDwb3MzGa4T3UndIgcjjTYDUdseTlxnJnHguM6dg9VQKQ/lm6TO9ZdWPpfN5
	90LjZIdxYcmuHW+2sZf7m719KcmAfWY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783691226;
	b=mRsAH3SobJTqB1IAc5Rc0nlK9NYxK5EVcbuc5rLvP3lcBCZTIQpG7dMu6uLfB2Uh9eAmKS
	gcCcxaUKZCktA7qjVKG+YJObSXwwtSeo8rtFc3KKuEU0kuwSqZWENRw1cay5ufQddn7SpR
	GaYpauMKyIpbZ1coe7heDayM2CfkraA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NJk5Scv9;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9FBB044095;
	Fri, 10 Jul 2026 13:47:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D4BB1F00A3A;
	Fri, 10 Jul 2026 13:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783691225;
	bh=yJOHjYArtxH1+/qkwlfdh08BuCLZ4ONkiqi8cM2xmzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NJk5Scv9CzNpnPdfFDYVeiMuJG6fb1OTCsPDbcrJrCLAVbnOKNEhP8f7WlAsmguc3
	 vtXxF0X1kzcPVOOLVsCcfBY8skt6XdfaN9iVNlcaNzulG4EmUU+z3I4eguPILVCDM+
	 6XJNAn7l2GgFqYlZ44YIHUjYmkoLyCiR3Q8qAywyFxOIa6UoeW8ESkWExeaf3mLRz4
	 c0NPQAFyCZYAiYj0lXSXdkzkoEp/6/2qEmNR4VoZrRTqJHoVHLatp9CQ9Go6Fvkpyx
	 WaRo1RksJrwB2IEL9eicdFbmVggg/PM9OUc8/tYGJZX0g0ahJknd1fgigsOZwu7LIr
	 QRwcv52EWdXWQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 16/19] mm/damon/sysfs: implement probe/weight file
Date: Fri, 10 Jul 2026 06:46:45 -0700
Message-ID: <20260710134651.18084-17-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260710134651.18084-1-sj@kernel.org>
References: <20260710134651.18084-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 414134000A
X-Stat-Signature: uxcxrehm6zg14pwdmsr5gauouoh8fkxq
X-HE-Tag: 1783691226-163426
X-HE-Meta: U2FsdGVkX1+mddwU6npXatJX1O8FpfBhDFcSUCL1hv0dJOeE7ftg5H+8m608h8wUl9wP3OkCDkUkCOcJ6KUsRBFBPh+YXDy1f1jdw7lOblXeXUJvaVIYgNdI6c0RQvjkI2dO0a9+qYHFgyG05EVRHBUE4kLyWU4A4Rs0z8J2h6w5a0MJMa7SEPkcPsf8iTbYI/LzIUCk+UsuMlrU+MJe7/w0TkszcADCs1DlA+0s6JmckWioRw4T3kHvjTD366J0+rFBSBf7PtdDXy8OpHIO2gY5XciPlIfjEvLBgra4/a7qUenG4LPwmGdOey5C7y1mRGNsByKTvyn5czzegdGzV/OLzlybLsOUA2X2YyOURu7+LdJov32GCJTGFWZMtXQh1/4UD/CClg4kwcPMksl7DvHROxby+sXEamhVdE4860O32i2yeo0qhLgKiGhotDpVWo46DoO5l/wKaDrfKZ6vUur+wO/SVT6h1OnH1e3NCXT71cOZmeBaheKy+3cMo2xZslQ2rqsdZPP1lFt2HrlcqzKiHCLHNFK21L4gaQJEXDVLRq9nNL8ojxfZfDDOvw9z7qYoOcGvovG3g6BM9/LxPRGrd2tQQ02fi0BBQYDHaYAvzl6AYW/y3mHZhnDIj95WeQl4D4paq9a5r+7xnkLHvqNuSppqsrsqKPiUmxJgVKF9HAuKBrGL51D7mvpaUXPx31bKQBz9/9juW0EQcIY9Y8vwRdxCVaTkEFd+HcUCknEGHTirmgqHr5Iv1l385jtQ2lDNL6lY14Oj5i/LsLCi3K6Y0gJ9G7FGF4RKfsNTQzK0X8TRw02r0NznhM+/Qo2NTHcJ4uOuR/aCq0+eGtCljp0sAk4yDf8G642OD393EO6gZ/8BI64f4k9pNM4i/cNTbcAjDsAz+1JG6/DMXp76kAipWRdsNXsIvO6yxww2iJxd9VqZ5Mtj0jzrRp7HvSuFF/jM0Y6Bc4ELHVKeGWZ
 /cy0KEdP
 fMj+kdptHVE+3Ws70hB3oTJk6oUkkrFb0EqGG7l4bt+Kf1ycBenmtdxGBNTFlicF9ZsgizMCHX7csQm7z7UX2PfKpo1sAL/yhH2KG1CHOm36eHepdHLMgQflSaIlynma0/A6RgVqn8xYcI3k9HGPIsE/5lIbHA9o0jJj3OQ13oh9p5KzfbHIp0FLAxKmGyCFNTW4qHjYfBE3OcproLLjcZvS3XnfrLNUdPSyG5U2utaP112Mkl2j4rsWOTpTcquOFw3AC4FglD961KWUBwHD4v8PCLf0djS5U4SzWAej0gTEir5ScJChoJMBb/P+xiEsLEZcS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement a new sysfs file, 'weight', under probe directory.  Users will
be able to set the probe weight and enable the attributes only
monitoring using it.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 6d7e36c9e509d..b5fe036f78015 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1065,6 +1065,7 @@ static const struct kobj_type damon_sysfs_filters_ktype = {
 
 struct damon_sysfs_probe {
 	struct kobject kobj;
+	unsigned int weight;
 	struct damon_sysfs_filters *filters;
 };
 
@@ -1100,12 +1101,35 @@ static void damon_sysfs_probe_rm_dirs(struct damon_sysfs_probe *probe)
 	}
 }
 
+static ssize_t weight_show(struct kobject *kobj, struct kobj_attribute *attr,
+		char *buf)
+{
+	struct damon_sysfs_probe *probe = container_of(kobj,
+			struct damon_sysfs_probe, kobj);
+
+	return sysfs_emit(buf, "%u\n", probe->weight);
+}
+
+static ssize_t weight_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_probe *probe = container_of(kobj,
+			struct damon_sysfs_probe, kobj);
+	int err = kstrtouint(buf, 0, &probe->weight);
+
+	return err ? err : count;
+}
+
 static void damon_sysfs_probe_release(struct kobject *kobj)
 {
 	kfree(container_of(kobj, struct damon_sysfs_probe, kobj));
 }
 
+static struct kobj_attribute damon_sysfs_probe_weight_attr =
+		__ATTR_RW_MODE(weight, 0600);
+
 static struct attribute *damon_sysfs_probe_attrs[] = {
+	&damon_sysfs_probe_weight_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_probe);
@@ -1965,6 +1989,7 @@ static int damon_sysfs_set_probes(struct damon_ctx *ctx,
 			return -ENOMEM;
 		damon_add_probe(ctx, p);
 		sys_probe = sys_probes->probes_arr[i];
+		p->weight = sys_probe->weight;
 		err = damon_sysfs_set_probe(p, sys_probe);
 		if (err)
 			return err;
-- 
2.47.3

