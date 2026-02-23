Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79E34EEC2A5
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 22:38:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AA0C6B0088; Mon, 23 Feb 2026 17:38:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 761166B0089; Mon, 23 Feb 2026 17:38:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 680F56B008A; Mon, 23 Feb 2026 17:38:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 53BB26B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 17:38:38 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E2C60160320
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 22:38:37 +0000 (UTC)
X-FDA: 84477187074.25.8A6376C
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	by imf12.hostedemail.com (Postfix) with ESMTP id 38B1E40004
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 22:38:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=L+Q2Mjv5;
	spf=pass (imf12.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.52 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771886316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DuinEuuv0LU2GEZWG09nmp0WL8L3OVm8EbjH7cRnI5M=;
	b=sDYfEIGAmjMSMdLcETM/0I9z29c1mtrgIhTC/+G+wbYg+jsWganTB5UgBTAGlhjNdD3vjI
	O7i4mCuXAOeqFz9KfVG0dBllBqukSADpqcqls631ASkrJsXRO4EatUM8gQMghDALszeIUw
	u+/8GuSD1GhpNNdes2ijqLLfM7hV6nU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=L+Q2Mjv5;
	spf=pass (imf12.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.52 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771886316; a=rsa-sha256;
	cv=none;
	b=3AlBqIBBJkaYuWKW0yRL43a9OxLI5YqvT7VzOhwR3Bu8PUk89vUFZAXK4X2pejgWvkESfR
	P62AcdS9ODtAhXizV+pBG8od6W5+qo4VYtgxkiEQindeizV8mVjuIPvPJDMJ15/wQY5Awv
	IrRW0Qr6VxfVZfAxJwLLgnlGwcZkp8E=
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7d1959ba05cso2229506a34.2
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 14:38:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771886315; x=1772491115; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DuinEuuv0LU2GEZWG09nmp0WL8L3OVm8EbjH7cRnI5M=;
        b=L+Q2Mjv5xxRS4lc/IAsed/OGm8/B5tgzSNYYBfj/arzA2csaSmlc/gSl8SMbtmdbzZ
         P7FJl/C2CHGD4frD6uZW3nF+RFWJFU2C8Yfw2AqUa/uSpudxu5jLgu49CBMiUelHwgPi
         Fx0zkjW9lzXkztFwdnAiQwkcvLQqtJV6bZ9XHKeTRqqr+JRIgA4e6bvXoPpjSEJxwjqy
         XbUi5bg2fYjDDhbV1YsknjSvSOXyECMU0m41Jfj/HpjOb0RNJstj9BWd8faXqjlnCaB/
         BJcqVxqr3pfB5Uz0N+fTXtPk6GcYcFPFR8TnGN1SAysb0vK9E+pDrxmQoYlEPfT4rCCs
         L1Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771886315; x=1772491115;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DuinEuuv0LU2GEZWG09nmp0WL8L3OVm8EbjH7cRnI5M=;
        b=ZB6WpIrKVZ09TtByhwxq8ABizDQ5IUCsolXJTyxHYBda1Hrqz+MBBG1DeO/UpoNn6X
         JSLf8evpwzhSgjgZMKxf5VePkBBdyrh4E3x+ZWuX7EGLTUEC2deOvIIhFYGfR1rehhr6
         9Tzb56mRxw2uPlQlcD569/+B/GFMfnydAKoD+P/7JFnOaHWC9UJldNtzfVPV/1r+9RVJ
         J7CGPJNUZrdPS6A869WO8xAhd3xDxCH9eRomZa0U4ncmOiJnj/vGiECd7EUniybnG1Ka
         YnwtWCjcYfKq/HLdBKcgJvukKRo7cpykGGJgfJ1wJ3hSXrcpHpbTdYFMUcWZ0KwxM4R6
         UItw==
X-Forwarded-Encrypted: i=1; AJvYcCWhtBxjS+HQ/9K33b6DUy6Gm5HkIEiphG3NwGem4+2ktPkhrftra+WtbLVF5o0uvPAphOy5Nmx/2Q==@kvack.org
X-Gm-Message-State: AOJu0YwG2Fkgz3eL2PHVe0noyQvs9oGXOaAsdCAP/0f+xDotpzUy9Pa1
	Z34mlGn0rV0ql8K6cfgrer2Y3oPRSVykqB40yCqhMO9Yf8a6k7D06R7X
X-Gm-Gg: AZuq6aL98ti42CH2tx7Js36UY9PRSrvbzb0vWzmyiPJKPLOwilQ/ckEttsZnqNfecLZ
	rmvl7JzkdB1/OwGyyS3BbY+8s8lag3JcyK2ZowATbytiaaJH/Z0z4h9BvDX7RLTcMElcYZTLAAq
	/mIlARDgKQQaVa41HWeUlxcApmlfm6/yZV1BI8QFVTILzUXkUQHWhCmVDuUMjQyFnMnMYnBRdOB
	s72H5y5HHjEeOgR1ECgdxWdc86sSG8qmaUgU0OcguRq/izjml0AE/DTzNyxiLwFOoEqJYGVyf7z
	3u+ka72APrqfkOOXLBoFk3hDkfiofkyXXEmdAhd0re7WXAaTzkwU5b/JgNbM9RYvSobGQ9pSyYJ
	kf25WRlHiQqbC0Zn2KBaRQ318hGGPHGfpfREvj71w0FDdwpXweq4hsEAt9pn8qnlAXxMTVu810g
	p1jc0PEqKk0cRc1kTyTKDGg0UwsHI5FsIO
X-Received: by 2002:a05:6830:660b:b0:7cf:da7d:608d with SMTP id 46e09a7af769-7d52c21500amr5531693a34.8.1771886315198;
        Mon, 23 Feb 2026 14:38:35 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:4d::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d52cf9f42dsm8185949a34.9.2026.02.23.14.38.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 14:38:34 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [RFC PATCH 1/6] mm/memory-tiers: Introduce tier-aware memcg limit sysfs
Date: Mon, 23 Feb 2026 14:38:24 -0800
Message-ID: <20260223223830.586018-2-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260223223830.586018-1-joshua.hahnjy@gmail.com>
References: <20260223223830.586018-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ebp8kqirjq7ykk5hzgcfdx6f6wicfh79
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 38B1E40004
X-HE-Tag: 1771886316-95470
X-HE-Meta: U2FsdGVkX19HZTsZ7WMpO1IPc4ZL9CtpWne78weywOkmx8rCMby6gohC7x/EjUwTkE0Ai1Ukhgp9Lr+gq+vHMG1V0yxEsUKdu71ONaamyYzCnC6amNw5lJq8aq299rWu0WfXRvmTVQD2yAsAfiJIvxkQ4RSMNmhH1xKVnLTGLecaY4hu7xHOilW7/fwIlc5SmF78fXgS3LWhLryG3rs34NlSA4dAMvsiL9d1+4AA2d82jste3g5QcFXWfXBMvS4Wss1gwheZJfUSBEESbqbTvHUdwnltikzVE91VWv6GDRHM+CIZ6Vy80ZB+8AnJiiPOVNoSGXzCoKMyHrdNftrG98cpi+Xbbc+ExCB2ktI374pJtMM+iKnU+EZgP5xmP3FAShnEBmXmwtMBaqgEoWfFpo5mtNfLsiDQqUSZ9Qwzx4GPrtNufxCQzPeZNKfEfRVFImesG54rJLrZUtzttBe2I5HxEbrVcI2BXFeOEpY6NesTRjSEnG8YmlXQj74GGlZiUa5mqoKloNYxZ9bWifM/Q6zDMY8AK53vbbkfUCbo4CxtVb4UPP4jBkD4/yYcF4eAHrNeDLTSEmt4XgD1mfz4/AX7zSbiteBsdMFQ+QP5LfrCJvBqQo0WO/4/huiCbNmRXX7EFZG+xMN+lfwIsxx6UhVusUgEwQlF64Ip0NUdVMTKEGRqbaVOTjeyelQIwlbmLa7WowPr8Sjos1rFvkwgZ87ayxnLl1+jSC1C0zOHaKRQg4ID5+4temRXqJ8io/Ul4gHF+zIDFqCfXDOKYTOwer7pN66+lCYrJxx5aTDt9+LJQmLQ/mozGJn6bD8trGfmkBsKF+kmGcNFAh0Ro41ajP2h91eFZEFGpSDqNcG1taNLiYtIwg3dI3siBvIlLIGiU7RSVOpHxwc/shPnq+PcFnLHvpuCYyVMomK7Q6zkBNjILmPk1tWdQB2sFhpNRaEQVN7kAGrJVq+kN7NSlYl
 ygmGLrEM
 ebsXvxqpQBG4K8/Y9KECWe9zOFmpDA7rYDBhPK+BkkeMzV8IzHRJQSvd4KXqFblDqYshXBDrAuMlDIIZNVJ/WdY576LFTrVtW4zHGAdLzcgTezuGt/auJ47BYoQYDbjl51dvc/1ttpEPO1avQHkn1UMCMacRU79hgcDcocE31WlnFp7ZeB+bXkC2Q0lkL7O3ToARAYgjie0ynJv4WoozIjTM4HB24FDwmLB3BmN92HP4L2bqspodgg2Io8Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a sysfs entry /sys/kernel/mm/numa/tier_aware_memcg to allow
users to toggle between memcg limits that are proportional to the
system's toptier:total capacity ratio.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/memory-tiers.h |  1 +
 mm/memory-tiers.c            | 22 ++++++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/include/linux/memory-tiers.h b/include/linux/memory-tiers.h
index 96987d9d95a8..85440473effb 100644
--- a/include/linux/memory-tiers.h
+++ b/include/linux/memory-tiers.h
@@ -37,6 +37,7 @@ struct access_coordinate;
 
 #ifdef CONFIG_NUMA
 extern bool numa_demotion_enabled;
+extern bool tier_aware_memcg_limits;
 extern struct memory_dev_type *default_dram_type;
 extern nodemask_t default_dram_nodes;
 struct memory_dev_type *alloc_memory_type(int adistance);
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 545e34626df7..a88256381519 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -939,6 +939,8 @@ subsys_initcall(memory_tier_init);
 
 bool numa_demotion_enabled = false;
 
+bool tier_aware_memcg_limits;
+
 #ifdef CONFIG_MIGRATION
 #ifdef CONFIG_SYSFS
 static ssize_t demotion_enabled_show(struct kobject *kobj,
@@ -975,8 +977,28 @@ static ssize_t demotion_enabled_store(struct kobject *kobj,
 static struct kobj_attribute numa_demotion_enabled_attr =
 	__ATTR_RW(demotion_enabled);
 
+static ssize_t tier_aware_memcg_show(struct kobject *kobj,
+				     struct kobj_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%s\n", str_true_false(tier_aware_memcg_limits));
+}
+
+static ssize_t tier_aware_memcg_store(struct kobject *kobj,
+				      struct kobj_attribute *attr,
+				      const char *buf, size_t count)
+{
+	if (kstrtobool(buf, &tier_aware_memcg_limits))
+		return -EINVAL;
+
+	return count;
+}
+
+static struct kobj_attribute numa_tier_aware_memcg_attr =
+	__ATTR_RW(tier_aware_memcg);
+
 static struct attribute *numa_attrs[] = {
 	&numa_demotion_enabled_attr.attr,
+	&numa_tier_aware_memcg_attr.attr,
 	NULL,
 };
 
-- 
2.47.3


