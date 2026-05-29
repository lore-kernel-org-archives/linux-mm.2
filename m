Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22680CD6E4C
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 16:57:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BA446B00C0; Fri, 29 May 2026 12:57:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76AA26B00C2; Fri, 29 May 2026 12:57:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BE5C6B00C4; Fri, 29 May 2026 12:57:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 477376B00C0
	for <linux-mm@kvack.org>; Fri, 29 May 2026 12:57:06 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F0F87140175
	for <linux-mm@kvack.org>; Fri, 29 May 2026 16:57:05 +0000 (UTC)
X-FDA: 84821062410.22.6DFAFBE
Received: from mail-ot1-f68.google.com (mail-ot1-f68.google.com [209.85.210.68])
	by imf20.hostedemail.com (Postfix) with ESMTP id 117A21C000A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 16:57:03 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PZ+6VrQW;
	spf=pass (imf20.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.210.68 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780073824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rls65X3DOzAoQMMdNR2JhXNJkdCouUDjyK2mqUrqz1s=;
	b=11P6vRdS4/pl7HTohuZHCkBnsVqcb9k5nz+O1ofzNq4HwQ0Y3xxu9igQ4L0SfHIMzSYktg
	WdPHeN8/HPLaNmupeyfSnUHeff1t2XLEhJYm3TxM5FxlhoDPGon3NifasdYfjHqLZoMxOU
	aKWqXsSwGI3fUzGQUFSToHN9LB2KwrE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PZ+6VrQW;
	spf=pass (imf20.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.210.68 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780073824; a=rsa-sha256;
	cv=none;
	b=yTmkhTkgRPP+9Q3JM/Afngn+cE0KM4gHq2UeWnnA9RwE3rU4zbSzyMFvpra4jMSgV7NtkG
	x0qtA1QADoKkmYR+IndwYPiU/tvC0wG2ZCI8xSHfsx8Rh4vwPKc1CWbG3YPiJagQYRa3QY
	KMOchqc5jbTMbD5B7xVHZR3EF+F2ye0=
Received: by mail-ot1-f68.google.com with SMTP id 46e09a7af769-7e666292eb8so2136484a34.3
        for <linux-mm@kvack.org>; Fri, 29 May 2026 09:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780073823; x=1780678623; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rls65X3DOzAoQMMdNR2JhXNJkdCouUDjyK2mqUrqz1s=;
        b=PZ+6VrQWBgbGZbCGOul/S8Pcy/BSbenEpVTymaz+/f+8IHuJNWqiSRZhgjU3bfcuoe
         K/81BQeTTI7RCha1rh+7Rm5JUDV9+UuwGttnEI4RDG7Csk83a53E3cH9h1gF8becoqur
         2zjMc7wiZW+b9fK1q3aEKEQsU5nQgXI8L+80tbST/uAlzOz+B5OIUGSUjzwex+eHblDB
         Ez+ozCFatbDrgm4tSwCV3v+K0IjPbrYd4WaWSoYDv5DZHMDP0plN5FQQCQGMZ1fQORDA
         slR0/9NK384TpP2LfNOjsXk+gFiTby0XmM85Od/GwZJOFY8os8buXMb1gCPSNCTTjcyj
         CF1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780073823; x=1780678623;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rls65X3DOzAoQMMdNR2JhXNJkdCouUDjyK2mqUrqz1s=;
        b=XiOJTtQw87CJAzX2pOYVKnsYFjjkh7UXFVI1K80eJg/p22htUXxsil8iCd9p0aSMr7
         C5mbzYEAc5RRM+aUBaVm9SgL+3jpQq3UQQ1H0yiNX6N7+LH8qElqubcXERZUFhY0a2Ww
         pQ6TOX8+YnTOqpTx8tGQpDtuC7uwQg1pRlMxMEfPtzleT4IRW3n53cSzempsna5lcdN/
         7qNUQWtjFuv4nPL7eQK+2SJaLUUa3CvU/VUwCOLBTC3xPhBpMDJBL7PCW5bnmWR7ktxD
         5UwZUQB5exjmRxa5VhqAPQ91OOEbiq0/ppXv8A509AM4eY67pfdLVHYxk6epw1XCozuC
         0qvg==
X-Forwarded-Encrypted: i=1; AFNElJ/fp27+lpY/L3exALWbY6XLk1yAT5khmN7ZBCNh2MQ76rBhLE2u8qCKYf4j8USDSzlHynvUdLOfUA==@kvack.org
X-Gm-Message-State: AOJu0Yxv2HtE0AavHUtjOrg1GQyXoNjTG52ghuW8dvGjQLjpoxNla2rv
	Ozv94tbOXvALrIvIeGI5UOCCRpLC5uSdWTp2CyS6EdSYSBOH1zK4Kig=
X-Gm-Gg: Acq92OFRm1l+nbnzwmnFFRIKNIy13NJI0qvq1s8+aZ5jR+8L0qLrXx4PD59ec6lj7Dc
	H8gGB1tSWITL/bGGm4VJacnyqTOYTXbJO/hyMw19n0n69Lbjgm0xXf/x9c5aTYcCvBc76M5tVzA
	KHK9izPXh1iijPOWy0iBlKy7X+Wo9v3fKu06xowyJDCGFWyWgFRpX20YeTMm+5RbfjRkiNZ87+r
	Q1Zh2LraapL4efbklrnUV99Tn1GVYBabXgK7GVGHOWugKfqf9BLcY0t6ybNjbWEaSO1sIR5A4Ey
	gUcdCzNkW+QZ+t484z21ko3pt63M+3JT65ihYoWLDtg/lkhqULIYkOb7QfX8iQBAS0eprnARmzF
	76HpbzbrDxIBnR4Abg8AGOCheEF+61tTlL5S+UvEemN6700DjMvg8YU7spoYROdoUzxadTzb+5J
	rO0scLXsZFEDgUccAIcaqttGpGn25RxDUdZa7cWIoTKIehP38erf/6ZSw31bQpvj3wIvueOkJ6o
	x0kb2HwtLeH
X-Received: by 2002:a05:6830:258d:b0:7d7:ccc7:c546 with SMTP id 46e09a7af769-7e6a1e3ad8amr396513a34.23.1780073822973;
        Fri, 29 May 2026 09:57:02 -0700 (PDT)
Received: from localhost (23-116-43-216.lightspeed.sntcca.sbcglobal.net. [23.116.43.216])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e695b8f662sm1862616a34.4.2026.05.29.09.57.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 09:57:02 -0700 (PDT)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
To: sj@kernel.org,
	akinobu.mita@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Cc: akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	ravis.opensrc@gmail.com
Subject: [RFC PATCH 2/6] mm/damon/sysfs-sample: expose perf_events configuration via sysfs
Date: Fri, 29 May 2026 09:56:36 -0700
Message-ID: <20260529165640.820-3-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260529165640.820-1-ravis.opensrc@gmail.com>
References: <20260529165640.820-1-ravis.opensrc@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 117A21C000A
X-Stat-Signature: 9rb3h3t9p6igpdb3jg3p3r7xokhez1oh
X-HE-Tag: 1780073823-295888
X-HE-Meta: U2FsdGVkX1+0ASmYGrddsOjQwYTx+2G0K4eFZKJ5Hm9Lv/WR1Jg+74IcxUUEkku1Hf/MQVc3YS8P0OsE2OI7P5mUr+HMLqc1Av0OkKmgASs2NY5wyZAr5b5g8HwehuDk485YGPwBYrZUFEmH2IFwR/rwh+p385KEnbBZ2s4Fnsy8iEDa0kX7/mShnPVuxzhI1AZqAtp0leancygLOHwfleZKAXMBQh7B14ddfM+3BEjVUnvyyLGvlQUujA+b6ZAsrkw9Bjqpz/vqyM7SLv9hKxkzhFxEzrOR05HXmxIJE1A3lVDdJ8VRAdf/YJuwf1xuVwbfaYRy1fsWOvELStMYwMNe7FsH7GIrl2UAvmVTS8mFxRNP8xGA0KGzb17BBFVkohID0sAgiofniIMvebiUa6H4iJPORfFFjF75qfcRU4jcTVSip41aPJ3TtUk3Ae0QXGyPnNtsf3OidARQbKstb347Ls/D0bIFlg2fxd/prgigoLtTqEDzbFbs2ZyaJUO+LAoUs4XC7Wjfl20GBU2Z3QuqCVUivsiHEuV8AxaGOdp0kxXm5PPCTFW9VgQLCDM/Nt771Or0eXBEtHo7ZYrh0FGhjXyUzeUL/tun7eeMDO/j6gBtPL4i8SG0GZ4AJTPJv5gU8ZzOG2uYZjQr+EB66hyPbi/Nj7gescOoLTjZThTthIxC1/12RN2gK6fQbsiSMStlg4qSzh13YlqpZyiG9U1cgt/3LYblu+/18//k3WUAdOKbsxHBlsgKIdHbtiuV8AAB0j48Etl/JCxeJttaRArds9r7TsuP2mnFgoEOJTzkS/71TzFDkDgJXRwbtacuAzEktGSxDQZ7F8R/V1szLO4q8KVBJpSvmEh7ycuxQLQLr9DMFRBTxe+dTmT1BIBRaGLwPrngIhjAbJX5erB23Ngq9c/w7GIgfaawGdxYs5R2Wvewnu9AWm9luHUAbyuR3k3hYDctk1eNeSqtid3
 y+hhCXsA
 xl0yQlliPVCRkNVD7YnpUo7yCReQ8SVo3c0BPTiZu+QTn1ZSSGxB2gFgs4xD1DVXGLYZn2uDTugLZ+KxCpT3Vkk12HRfD8ApPokYUDdddklNJCqCCmHQ/gIsH6GhQZdEPEd/gAGKxzh8/hiUiwaMNOpf6kuQo/jeBOgLbAxK+Z3kruyRBR3EftVd18G/DY4s4gFtiWKgyDDQQaNAv/DNQiQ+Jhn8xtp8ur+3H4OnZwFlUDZKpVh12kkpQA0IosyWNrLXI3AqQeMH8XtsBqjiecam7ZcH8D1bngI+fYV8i3RM9sVH6Nrlzu1UyzUmxFS6vKdMqmKLUpC4qs4HsiC0takknkiiDcwGxQRLahBEmfiGCmVa3lhJnvekbxbzGHIm1kLZetX65EuK31+4V2YRUKnLZZB+q3fEDiE+t41juJyk60Xj9a6oqOxhhVSDyTwVmGuLL+KOwhb1lllou3KkUxHhzeFhLAQPiNIMV8kWVbhbFCwt785fPC0kLkkhrjkMUcdBKn8uBxZ2v8j02ZXYk5XSZzeSOQT33pqFpceFunsJd7dep17Pb/RWJRDIDhVOhb5HZS6Od6DWyJVx83C7SjbDuES3g0+B3A2AQmwihKJoF1NeXt71Hnv8RTtWg71RdYbX2kQmJNR0n/HRocL+VkJb4LFDlqbzhUh26/c5XhNKKhM6g672/g/gKVix3Ugz7knBF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a perf_events/ subdirectory under each context's sample/ directory.
Each numbered entry maps to one damon_perf_event and exposes its raw
PMU attr, addressing flags, and period/delivery knobs.

Defaults match Intel PEBS L3-miss; userspace overrides them for other
PMUs.  sample_weight_struct defaults off because PMUs that do not
advertise PERF_SAMPLE_WEIGHT_STRUCT (e.g. AMD IBS Op) reject events
that request it with -EOPNOTSUPP.

Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
 mm/damon/sysfs-sample.c | 579 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 579 insertions(+)

diff --git a/mm/damon/sysfs-sample.c b/mm/damon/sysfs-sample.c
index ffc9c85455474..0570d27a47b1c 100644
--- a/mm/damon/sysfs-sample.c
+++ b/mm/damon/sysfs-sample.c
@@ -452,6 +452,520 @@ static const struct kobj_type damon_sysfs_primitives_ktype = {
 	.default_groups = damon_sysfs_primitives_groups,
 };
 
+/*
+ * perf_event_attr directory
+ */
+
+struct damon_sysfs_perf_event_attr {
+	struct kobject kobj;
+	u32 type;
+	u64 config;
+	u64 config1;
+	u64 config2;
+	bool sample_phys_addr;
+	bool sample_weight_struct;
+	bool exclude_kernel;
+	bool exclude_hv;
+	bool freq;
+	u64 sample_freq;
+	u64 sample_period;
+	u32 wakeup_events;
+	u32 precise_ip;
+};
+
+static struct damon_sysfs_perf_event_attr *
+damon_sysfs_perf_event_attr_alloc(void)
+{
+	struct damon_sysfs_perf_event_attr *attr =
+		kzalloc(sizeof(*attr), GFP_KERNEL);
+
+	if (!attr)
+		return NULL;
+	attr->wakeup_events = 1;
+	attr->precise_ip = 2;
+	attr->freq = true;
+	attr->exclude_kernel = true;
+	attr->exclude_hv = true;
+	return attr;
+}
+
+static ssize_t attr_type_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_perf_event_attr *perf_event_attr = container_of(kobj,
+			struct damon_sysfs_perf_event_attr, kobj);
+
+	return sysfs_emit(buf, "0x%x\n", perf_event_attr->type);
+}
+
+static ssize_t attr_type_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_perf_event_attr *perf_event_attr = container_of(kobj,
+			struct damon_sysfs_perf_event_attr, kobj);
+	int err = kstrtou32(buf, 0, &perf_event_attr->type);
+
+	if (err)
+		return -EINVAL;
+	return count;
+}
+
+static ssize_t config_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_perf_event_attr *perf_event_attr = container_of(kobj,
+			struct damon_sysfs_perf_event_attr, kobj);
+
+	return sysfs_emit(buf, "0x%llx\n", perf_event_attr->config);
+}
+
+static ssize_t config_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_perf_event_attr *perf_event_attr = container_of(kobj,
+			struct damon_sysfs_perf_event_attr, kobj);
+	int err = kstrtou64(buf, 0, &perf_event_attr->config);
+
+	if (err)
+		return -EINVAL;
+	return count;
+}
+
+static ssize_t config1_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_perf_event_attr *perf_event_attr = container_of(kobj,
+			struct damon_sysfs_perf_event_attr, kobj);
+
+	return sysfs_emit(buf, "0x%llx\n", perf_event_attr->config1);
+}
+
+static ssize_t config1_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_perf_event_attr *perf_event_attr = container_of(kobj,
+			struct damon_sysfs_perf_event_attr, kobj);
+	int err = kstrtou64(buf, 0, &perf_event_attr->config1);
+
+	if (err)
+		return -EINVAL;
+	return count;
+}
+
+static ssize_t config2_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_perf_event_attr *perf_event_attr = container_of(kobj,
+			struct damon_sysfs_perf_event_attr, kobj);
+
+	return sysfs_emit(buf, "0x%llx\n", perf_event_attr->config2);
+}
+
+static ssize_t config2_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_perf_event_attr *perf_event_attr = container_of(kobj,
+			struct damon_sysfs_perf_event_attr, kobj);
+	int err = kstrtou64(buf, 0, &perf_event_attr->config2);
+
+	if (err)
+		return -EINVAL;
+	return count;
+}
+
+static ssize_t sample_phys_addr_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_perf_event_attr *perf_event_attr = container_of(kobj,
+			struct damon_sysfs_perf_event_attr, kobj);
+
+	return sysfs_emit(buf, "%d\n", perf_event_attr->sample_phys_addr);
+}
+
+static ssize_t sample_phys_addr_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_perf_event_attr *perf_event_attr = container_of(kobj,
+			struct damon_sysfs_perf_event_attr, kobj);
+	bool sample_phys_addr;
+	int err = kstrtobool(buf, &sample_phys_addr);
+
+	if (err)
+		return -EINVAL;
+
+	perf_event_attr->sample_phys_addr = sample_phys_addr;
+	return count;
+}
+
+static ssize_t sample_weight_struct_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_perf_event_attr *perf_event_attr = container_of(kobj,
+			struct damon_sysfs_perf_event_attr, kobj);
+
+	return sysfs_emit(buf, "%d\n", perf_event_attr->sample_weight_struct);
+}
+
+static ssize_t sample_weight_struct_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_perf_event_attr *perf_event_attr = container_of(kobj,
+			struct damon_sysfs_perf_event_attr, kobj);
+	bool sample_weight_struct;
+	int err = kstrtobool(buf, &sample_weight_struct);
+
+	if (err)
+		return -EINVAL;
+
+	perf_event_attr->sample_weight_struct = sample_weight_struct;
+	return count;
+}
+
+static ssize_t sample_freq_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_perf_event_attr *perf_event_attr = container_of(kobj,
+			struct damon_sysfs_perf_event_attr, kobj);
+
+	return sysfs_emit(buf, "%llu\n", perf_event_attr->sample_freq);
+}
+
+static ssize_t sample_freq_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_perf_event_attr *perf_event_attr = container_of(kobj,
+			struct damon_sysfs_perf_event_attr, kobj);
+	int err = kstrtou64(buf, 0, &perf_event_attr->sample_freq);
+
+	if (err)
+		return -EINVAL;
+	return count;
+}
+
+static ssize_t wakeup_events_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_perf_event_attr *perf_event_attr = container_of(kobj,
+			struct damon_sysfs_perf_event_attr, kobj);
+
+	return sysfs_emit(buf, "%u\n", perf_event_attr->wakeup_events);
+}
+
+static ssize_t wakeup_events_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_perf_event_attr *perf_event_attr = container_of(kobj,
+			struct damon_sysfs_perf_event_attr, kobj);
+	int err = kstrtou32(buf, 0, &perf_event_attr->wakeup_events);
+
+	if (err)
+		return -EINVAL;
+	return count;
+}
+
+static ssize_t precise_ip_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_perf_event_attr *perf_event_attr = container_of(kobj,
+			struct damon_sysfs_perf_event_attr, kobj);
+
+	return sysfs_emit(buf, "%u\n", perf_event_attr->precise_ip);
+}
+
+static ssize_t precise_ip_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_perf_event_attr *perf_event_attr = container_of(kobj,
+			struct damon_sysfs_perf_event_attr, kobj);
+	int err = kstrtou32(buf, 0, &perf_event_attr->precise_ip);
+
+	if (err)
+		return -EINVAL;
+	return count;
+}
+
+static ssize_t freq_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_perf_event_attr *perf_event_attr = container_of(kobj,
+			struct damon_sysfs_perf_event_attr, kobj);
+
+	return sysfs_emit(buf, "%d\n", perf_event_attr->freq);
+}
+
+static ssize_t freq_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_perf_event_attr *perf_event_attr = container_of(kobj,
+			struct damon_sysfs_perf_event_attr, kobj);
+	bool freq;
+	int err = kstrtobool(buf, &freq);
+
+	if (err)
+		return -EINVAL;
+	perf_event_attr->freq = freq;
+	return count;
+}
+
+static ssize_t sample_period_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_perf_event_attr *perf_event_attr = container_of(kobj,
+			struct damon_sysfs_perf_event_attr, kobj);
+
+	return sysfs_emit(buf, "%llu\n", perf_event_attr->sample_period);
+}
+
+static ssize_t sample_period_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_perf_event_attr *perf_event_attr = container_of(kobj,
+			struct damon_sysfs_perf_event_attr, kobj);
+	int err = kstrtou64(buf, 0, &perf_event_attr->sample_period);
+
+	if (err)
+		return -EINVAL;
+	return count;
+}
+
+static ssize_t exclude_kernel_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_perf_event_attr *perf_event_attr = container_of(kobj,
+			struct damon_sysfs_perf_event_attr, kobj);
+
+	return sysfs_emit(buf, "%d\n", perf_event_attr->exclude_kernel);
+}
+
+static ssize_t exclude_kernel_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_perf_event_attr *perf_event_attr = container_of(kobj,
+			struct damon_sysfs_perf_event_attr, kobj);
+	bool v;
+	int err = kstrtobool(buf, &v);
+
+	if (err)
+		return -EINVAL;
+	perf_event_attr->exclude_kernel = v;
+	return count;
+}
+
+static ssize_t exclude_hv_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_perf_event_attr *perf_event_attr = container_of(kobj,
+			struct damon_sysfs_perf_event_attr, kobj);
+
+	return sysfs_emit(buf, "%d\n", perf_event_attr->exclude_hv);
+}
+
+static ssize_t exclude_hv_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_perf_event_attr *perf_event_attr = container_of(kobj,
+			struct damon_sysfs_perf_event_attr, kobj);
+	bool v;
+	int err = kstrtobool(buf, &v);
+
+	if (err)
+		return -EINVAL;
+	perf_event_attr->exclude_hv = v;
+	return count;
+}
+
+static void damon_sysfs_perf_event_attr_release(struct kobject *kobj)
+{
+	kfree(container_of(kobj, struct damon_sysfs_perf_event_attr, kobj));
+}
+
+static struct kobj_attribute damon_sysfs_perf_event_attr_type_attr =
+		__ATTR(type, 0600, attr_type_show, attr_type_store);
+
+static struct kobj_attribute damon_sysfs_perf_event_attr_config_attr =
+		__ATTR_RW_MODE(config, 0600);
+
+static struct kobj_attribute damon_sysfs_perf_event_attr_config1_attr =
+		__ATTR_RW_MODE(config1, 0600);
+
+static struct kobj_attribute damon_sysfs_perf_event_attr_config2_attr =
+		__ATTR_RW_MODE(config2, 0600);
+
+static struct kobj_attribute damon_sysfs_perf_event_attr_sample_phys_addr_attr =
+		__ATTR_RW_MODE(sample_phys_addr, 0600);
+
+static struct kobj_attribute
+		damon_sysfs_perf_event_attr_sample_weight_struct_attr =
+		__ATTR_RW_MODE(sample_weight_struct, 0600);
+
+static struct kobj_attribute damon_sysfs_perf_event_attr_sample_freq_attr =
+		__ATTR_RW_MODE(sample_freq, 0600);
+
+static struct kobj_attribute damon_sysfs_perf_event_attr_wakeup_events_attr =
+		__ATTR_RW_MODE(wakeup_events, 0600);
+
+static struct kobj_attribute damon_sysfs_perf_event_attr_precise_ip_attr =
+		__ATTR_RW_MODE(precise_ip, 0600);
+
+static struct kobj_attribute damon_sysfs_perf_event_attr_freq_attr =
+		__ATTR_RW_MODE(freq, 0600);
+
+static struct kobj_attribute damon_sysfs_perf_event_attr_sample_period_attr =
+		__ATTR_RW_MODE(sample_period, 0600);
+
+static struct kobj_attribute damon_sysfs_perf_event_attr_exclude_kernel_attr =
+		__ATTR_RW_MODE(exclude_kernel, 0600);
+
+static struct kobj_attribute damon_sysfs_perf_event_attr_exclude_hv_attr =
+		__ATTR_RW_MODE(exclude_hv, 0600);
+
+static struct attribute *damon_sysfs_perf_event_attr_attrs[] = {
+	&damon_sysfs_perf_event_attr_type_attr.attr,
+	&damon_sysfs_perf_event_attr_config_attr.attr,
+	&damon_sysfs_perf_event_attr_config1_attr.attr,
+	&damon_sysfs_perf_event_attr_config2_attr.attr,
+	&damon_sysfs_perf_event_attr_sample_phys_addr_attr.attr,
+	&damon_sysfs_perf_event_attr_sample_weight_struct_attr.attr,
+	&damon_sysfs_perf_event_attr_freq_attr.attr,
+	&damon_sysfs_perf_event_attr_sample_freq_attr.attr,
+	&damon_sysfs_perf_event_attr_sample_period_attr.attr,
+	&damon_sysfs_perf_event_attr_wakeup_events_attr.attr,
+	&damon_sysfs_perf_event_attr_precise_ip_attr.attr,
+	&damon_sysfs_perf_event_attr_exclude_kernel_attr.attr,
+	&damon_sysfs_perf_event_attr_exclude_hv_attr.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(damon_sysfs_perf_event_attr);
+
+static const struct kobj_type damon_sysfs_perf_event_attr_ktype = {
+	.release = damon_sysfs_perf_event_attr_release,
+	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = damon_sysfs_perf_event_attr_groups,
+};
+
+/*
+ * perf_events directory
+ */
+
+/*
+ * Cap on the number of perf events per damon_ctx, to bound the sysfs
+ * kobject footprint and prevent unbounded allocations from a careless
+ * write to nr_perf_events.
+ */
+#define DAMON_SYSFS_PERF_EVENTS_MAX	64
+
+struct damon_sysfs_perf_events {
+	struct kobject kobj;
+	struct damon_sysfs_perf_event_attr **attrs_arr;
+	int nr;
+};
+
+static struct damon_sysfs_perf_events *damon_sysfs_perf_events_alloc(void)
+{
+	return kzalloc(sizeof(struct damon_sysfs_perf_events), GFP_KERNEL);
+}
+
+static void damon_sysfs_perf_events_rm_dirs(
+		struct damon_sysfs_perf_events *events)
+{
+	struct damon_sysfs_perf_event_attr **attrs_arr = events->attrs_arr;
+	int i;
+
+	for (i = 0; i < events->nr; i++)
+		kobject_put(&attrs_arr[i]->kobj);
+	events->nr = 0;
+	kfree(attrs_arr);
+	events->attrs_arr = NULL;
+}
+
+static int damon_sysfs_perf_events_add_dirs(
+		struct damon_sysfs_perf_events *events, int nr_events)
+{
+	struct damon_sysfs_perf_event_attr **attrs_arr, *attr;
+	int err, i;
+
+	damon_sysfs_perf_events_rm_dirs(events);
+	if (!nr_events)
+		return 0;
+
+	attrs_arr = kmalloc_array(nr_events, sizeof(*attrs_arr), GFP_KERNEL);
+	if (!attrs_arr)
+		return -ENOMEM;
+	events->attrs_arr = attrs_arr;
+
+	for (i = 0; i < nr_events; i++) {
+		attr = damon_sysfs_perf_event_attr_alloc();
+		if (!attr) {
+			damon_sysfs_perf_events_rm_dirs(events);
+			return -ENOMEM;
+		}
+
+		err = kobject_init_and_add(&attr->kobj,
+				&damon_sysfs_perf_event_attr_ktype, &events->kobj,
+				"%d", i);
+		if (err) {
+			kobject_put(&attr->kobj);
+			damon_sysfs_perf_events_rm_dirs(events);
+			return err;
+		}
+		attrs_arr[i] = attr;
+		events->nr++;
+	}
+	return 0;
+}
+
+static ssize_t nr_perf_events_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_perf_events *events = container_of(kobj,
+			struct damon_sysfs_perf_events, kobj);
+
+	return sysfs_emit(buf, "%d\n", events->nr);
+}
+
+static ssize_t nr_perf_events_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_perf_events *events;
+	int nr, err = kstrtoint(buf, 0, &nr);
+
+	if (err)
+		return err;
+	if (nr < 0 || nr > DAMON_SYSFS_PERF_EVENTS_MAX)
+		return -EINVAL;
+
+	events = container_of(kobj, struct damon_sysfs_perf_events, kobj);
+
+	if (!mutex_trylock(&damon_sysfs_lock))
+		return -EBUSY;
+	err = damon_sysfs_perf_events_add_dirs(events, nr);
+	mutex_unlock(&damon_sysfs_lock);
+	if (err)
+		return err;
+
+	return count;
+}
+
+static void damon_sysfs_perf_events_release(struct kobject *kobj)
+{
+	kfree(container_of(kobj, struct damon_sysfs_perf_events, kobj));
+}
+
+static struct kobj_attribute damon_sysfs_perf_events_nr_attr =
+		__ATTR_RW_MODE(nr_perf_events, 0600);
+
+static struct attribute *damon_sysfs_perf_events_attrs[] = {
+	&damon_sysfs_perf_events_nr_attr.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(damon_sysfs_perf_events);
+
+static const struct kobj_type damon_sysfs_perf_events_ktype = {
+	.release = damon_sysfs_perf_events_release,
+	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = damon_sysfs_perf_events_groups,
+};
+
 /*
  * sample directory
  */
@@ -471,6 +985,7 @@ int damon_sysfs_sample_add_dirs(struct damon_sysfs_sample *sample)
 {
 	struct damon_sysfs_primitives *primitives;
 	struct damon_sysfs_sample_filters *filters;
+	struct damon_sysfs_perf_events *perf_events;
 	int err;
 
 	primitives = damon_sysfs_primitives_alloc(true, false);
@@ -494,7 +1009,23 @@ int damon_sysfs_sample_add_dirs(struct damon_sysfs_sample *sample)
 	if (err)
 		goto put_filters_out;
 	sample->filters = filters;
+
+	perf_events = damon_sysfs_perf_events_alloc();
+	if (!perf_events) {
+		err = -ENOMEM;
+		goto put_filters_out;
+	}
+	err = kobject_init_and_add(&perf_events->kobj,
+			&damon_sysfs_perf_events_ktype, &sample->kobj,
+			"perf_events");
+	if (err)
+		goto put_perf_events_out;
+	sample->perf_events = perf_events;
+
 	return 0;
+put_perf_events_out:
+	kobject_put(&perf_events->kobj);
+	sample->perf_events = NULL;
 put_filters_out:
 	kobject_put(&filters->kobj);
 	sample->filters = NULL;
@@ -512,6 +1043,10 @@ void damon_sysfs_sample_rm_dirs(struct damon_sysfs_sample *sample)
 		damon_sysfs_sample_filters_rm_dirs(sample->filters);
 		kobject_put(&sample->filters->kobj);
 	}
+	if (sample->perf_events) {
+		damon_sysfs_perf_events_rm_dirs(sample->perf_events);
+		kobject_put(&sample->perf_events->kobj);
+	}
 }
 
 void damon_sysfs_sample_release(struct kobject *kobj)
@@ -596,3 +1131,47 @@ int damon_sysfs_set_sample_control(
 	return damon_sysfs_set_sample_filters(control,
 			sysfs_sample->filters);
 }
+
+static int damon_sysfs_add_perf_event(
+		struct damon_sysfs_perf_event_attr *sys_attr,
+		struct damon_ctx *ctx)
+{
+	struct damon_perf_event *event = kzalloc(sizeof(*event), GFP_KERNEL);
+
+	if (!event)
+		return -ENOMEM;
+
+	event->attr.type = sys_attr->type;
+	event->attr.config = sys_attr->config;
+	event->attr.config1 = sys_attr->config1;
+	event->attr.config2 = sys_attr->config2;
+	event->attr.sample_phys_addr = sys_attr->sample_phys_addr;
+	event->attr.sample_weight_struct = sys_attr->sample_weight_struct;
+	event->attr.freq = sys_attr->freq;
+	event->attr.sample_freq = sys_attr->sample_freq;
+	event->attr.sample_period = sys_attr->sample_period;
+	event->attr.wakeup_events = sys_attr->wakeup_events;
+	event->attr.precise_ip = sys_attr->precise_ip;
+	event->attr.exclude_kernel = sys_attr->exclude_kernel;
+	event->attr.exclude_hv = sys_attr->exclude_hv;
+
+	list_add_tail(&event->list, &ctx->perf_events);
+	return 0;
+}
+
+int damon_sysfs_add_perf_events(struct damon_ctx *ctx,
+		struct damon_sysfs_sample *sysfs_sample)
+{
+	struct damon_sysfs_perf_events *events = sysfs_sample->perf_events;
+	int i, err;
+
+	if (!events)
+		return 0;
+
+	for (i = 0; i < events->nr; i++) {
+		err = damon_sysfs_add_perf_event(events->attrs_arr[i], ctx);
+		if (err)
+			return err;
+	}
+	return 0;
+}
-- 
2.43.0


