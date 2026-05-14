Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92B49CD4F39
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 14:09:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08E746B009F; Thu, 14 May 2026 10:09:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E48146B00A2; Thu, 14 May 2026 10:09:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFF036B00A0; Thu, 14 May 2026 10:09:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A14006B00A1
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:09:24 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6E3B11C0333
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:24 +0000 (UTC)
X-FDA: 84766207848.12.268E5D7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id A437D180013
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:22 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fpxTp9Gw;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778767762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mH6giCxdh124Zq3I+dXuH1/1rU/xZgVOnEr3DNyTuh4=;
	b=ofB8Cayam1aG0bGMIz5ZtL3OxVf9+JPTzrY+S/ItnCR+bNInJaFyUc6KheXFi5FHbfLPdQ
	HWseO3OO/vUuW+zF5IIJLyuh9XYWF0hoPTqO/RNr/N8bbUXW7QgW+FBdppHa91kiNRcZDS
	hE0IXNdq3n5ETdHYX3PW6XLFdBqbglk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fpxTp9Gw;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778767762; a=rsa-sha256;
	cv=none;
	b=6ywULciQCax894/yyjrVQhHd9cpilbRgyacJwtZlVctUYYxkl4o4hJu+kz2wH+iVdu43ds
	/l30vducA/kOf36Je6tvIb2/FcgOCA/fsln3JU8sxkhnoEf1mdg84ZodLpFzhtb4DAFOGi
	Ml3+ALdCi5Vxq6PajeGMwVWV7YRTS3M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A30D9414FC;
	Thu, 14 May 2026 14:09:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D254C2BCB3;
	Thu, 14 May 2026 14:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778767761;
	bh=SZZB/8Y34d4c5OpPrN0Tt1+a+YDiqj7LFYZQ5Lka3iE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fpxTp9Gw+l8Vl8rBZw4W+zQuKZ06VS+IOj7ZH1TMUCHyZIanKD/HwS/HkrcQ/t33/
	 sfdoqFcRr8elEGvTVOpLDLTxd7wmQYUEDLRzWanxkX3dxTF3Glo1Zum608QEz81meA
	 D++RreXMFH0Z09jFjdlJk2PL5Oz+DkyVA/lPT4mbDA3V7vTEST8QIdedYARCUc7K7O
	 UcUkDS4ms3weyKW3OyEL/veSXn00H0qGmNlkIO/PE/pH9YjwKmz0m1u3XLz3RdFEMm
	 0WaifBrCEJSTkZh4dpTISxjvtIIMZAoAIcVoEWp+QlS26K117My2LEKkJFIQkgxa/4
	 iv0vCKPveUiqQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.1 10/28] mm/damon/sysfs: implement probe dir
Date: Thu, 14 May 2026 07:08:43 -0700
Message-ID: <20260514140904.119781-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260514140904.119781-1-sj@kernel.org>
References: <20260514140904.119781-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: sfi8a8hkqzha9unmwbm4rc5bbn5iexhg
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A437D180013
X-Rspam-User: 
X-HE-Tag: 1778767762-379746
X-HE-Meta: U2FsdGVkX1+z8YWLqt62gME6opVFtG8U8k6QJViL0xqghfrKZHnhZUH9rpPv29MHF5oWb35JNfWbou1kNF0vOo1KMfQpZKxJvXmy+DJnsHjgSvtoulx/bqv4dfjh74+J2npVxMpws45Wg99y5FQ2niW5licF+A6mBy5blVU9nezifH0SfcThELiz6oexqqfnonu83lIbZ0pj4dU0UYvELKb4fJy3ddHvlgtn0CPSTc/N4NE+/K5pawl8JJBo61JyJSjnTy5aR/xgaUFXkxDPyVFmyXIKlZoz58ybqmT7v7DeZWyjrQqM9Xo6XPs/njU62CYoiLaWrtvnaCR5kwz8Y4cXX8ios5goMoavB2AMch0LW6fUuLSWArgZEhN93tChpcyMNzEZSV/MdLQ4F6TiMmv39DFPaIGrixLlxEPCwrQcI+wAliW86F6Fg07q4B1H3WqumEFGqBrhm6kIiTtHgwV+yj7l9KvLLiSuGe+bB4nQWVBFsDTNBAxCqHxmBisb7cLD7hO8r81ejpcSh65zNDmxWWK1Xr+e3kPS/DmtlvESFKThvbvxofCxtKcC2OPIoWXaNM+4Pbx07WaIeg+OLyHkXGZHRY+0wEMC6zYCYkGNG0EqPMk7isnstKY/P60vU8u0n+Ufgr4oh/0J2bJJKmBcHxHLfb0ZgRxFH+GDsIRzAIk76Njn4Qls4/SE4Vo5Ete3XN8noqOgtiS2nz+1yhuY3sDJ5QGv6TBQ70TAMi0iWpqphQL02Y41KZIsdy9vzRl3egfIz+vWHKMvfFBdpoxCYsadmzOYecS04zIcOthT3eMRmR178zCbtT0D6wkqITg2dGv22jMA52IVljJUgDAbaga1dM1rD3XXJyXfIc+WQAIrnQGbbUtuR4Wmjck6ctFxaIzcLHYZF7bv0g1Jd3mcZaJr/TF0XbBzoZnPrRY3u5i1OLKMpXtnsCNXQGC6RRrCo2ccsKS8mdhmG3V
 iDSW3EuG
 P0ZB5qX3gQY3wslHc7fnKHZ7lA9sQs5+XhtNwXyeOa1P6uzOL51wAwdO3qHyJ+lOGzCuUFoDak4uZ3VU4WChlHOoRhz9JWE3dYfEY1sqUypUjBsCBYT4wwQX2uqWm5JGhjuYhG05EPBcdEnGup5QOVf5rZd5SeT5B0zuzmRF50KAQik5I6Di/JI60hUOd1NUWYltEvDYtZSoJ6AC0GZbHB6XjHAf0oy8PmxHdTv0lHTEL01gUbvfcKzs97tGj9A5LG47hLFxB2x83pDU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement sysfs directory for letting users install each data probe.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 119 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 119 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index ccd19fc062f31..fac4e37aa2851 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -747,12 +747,43 @@ static const struct kobj_type damon_sysfs_intervals_ktype = {
 	.default_groups = damon_sysfs_intervals_groups,
 };
 
+/*
+ * probe directory
+ */
+
+struct damon_sysfs_probe {
+	struct kobject kobj;
+};
+
+static struct damon_sysfs_probe *damon_sysfs_probe_alloc(void)
+{
+	return kzalloc_obj(struct damon_sysfs_probe);
+}
+
+static void damon_sysfs_probe_release(struct kobject *kobj)
+{
+	kfree(container_of(kobj, struct damon_sysfs_probe, kobj));
+}
+
+static struct attribute *damon_sysfs_probe_attrs[] = {
+	NULL,
+};
+ATTRIBUTE_GROUPS(damon_sysfs_probe);
+
+const struct kobj_type damon_sysfs_probe_ktype = {
+	.release = damon_sysfs_probe_release,
+	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = damon_sysfs_probe_groups,
+};
+
 /*
  * probes directory
  */
 
 struct damon_sysfs_probes {
 	struct kobject kobj;
+	struct damon_sysfs_probe **probes_arr;
+	int nr;
 };
 
 static struct damon_sysfs_probes *damon_sysfs_probes_alloc(void)
@@ -760,12 +791,99 @@ static struct damon_sysfs_probes *damon_sysfs_probes_alloc(void)
 	return kzalloc_obj(struct damon_sysfs_probes);
 }
 
+static void damon_sysfs_probes_rm_dirs(
+		struct damon_sysfs_probes *probes)
+{
+	struct damon_sysfs_probe **probes_arr = probes->probes_arr;
+	int i;
+
+	for (i = 0; i < probes->nr; i++)
+		kobject_put(&probes_arr[i]->kobj);
+	probes->nr = 0;
+	kfree(probes_arr);
+	probes->probes_arr = NULL;
+}
+
+static int damon_sysfs_probes_add_dirs(
+		struct damon_sysfs_probes *probes, int nr_probes)
+{
+	struct damon_sysfs_probe **probes_arr, *probe;
+	int err, i;
+
+	damon_sysfs_probes_rm_dirs(probes);
+	if (!nr_probes)
+		return 0;
+
+	probes_arr = kmalloc_objs(*probes_arr, nr_probes,
+				   GFP_KERNEL | __GFP_NOWARN);
+	if (!probes_arr)
+		return -ENOMEM;
+	probes->probes_arr = probes_arr;
+
+	for (i = 0; i < nr_probes; i++) {
+		probe = damon_sysfs_probe_alloc();
+		if (!probe) {
+			damon_sysfs_probes_rm_dirs(probes);
+			return -ENOMEM;
+		}
+
+		err = kobject_init_and_add(&probe->kobj,
+				&damon_sysfs_probe_ktype, &probes->kobj,
+				"%d", i);
+		if (err) {
+			kobject_put(&probe->kobj);
+			damon_sysfs_probes_rm_dirs(probes);
+			return err;
+		}
+
+		probes_arr[i] = probe;
+		probes->nr++;
+	}
+	return 0;
+}
+
+static ssize_t nr_probes_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_probes *probes = container_of(kobj,
+			struct damon_sysfs_probes, kobj);
+
+	return sysfs_emit(buf, "%d\n", probes->nr);
+}
+
+static ssize_t nr_probes_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_probes *probes;
+	int nr, err = kstrtoint(buf, 0, &nr);
+
+	if (err)
+		return err;
+	if (nr < 0 || nr > DAMON_MAX_PROBES)
+		return -EINVAL;
+
+	probes = container_of(kobj, struct damon_sysfs_probes, kobj);
+
+	if (!mutex_trylock(&damon_sysfs_lock))
+		return -EBUSY;
+	err = damon_sysfs_probes_add_dirs(probes, nr);
+	mutex_unlock(&damon_sysfs_lock);
+	if (err)
+		return err;
+
+	return count;
+}
+
 static void damon_sysfs_probes_release(struct kobject *kobj)
 {
 	kfree(container_of(kobj, struct damon_sysfs_probes, kobj));
 }
 
+static struct kobj_attribute damon_sysfs_probes_nr_probes =
+		__ATTR_RW_MODE(nr_probes, 0600);
+
 static struct attribute *damon_sysfs_probes_attrs[] = {
+	&damon_sysfs_probes_nr_probes.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_probes);
@@ -862,6 +980,7 @@ static void damon_sysfs_attrs_rm_dirs(struct damon_sysfs_attrs *attrs)
 	kobject_put(&attrs->nr_regions_range->kobj);
 	damon_sysfs_intervals_rm_dirs(attrs->intervals);
 	kobject_put(&attrs->intervals->kobj);
+	damon_sysfs_probes_rm_dirs(attrs->probes);
 	kobject_put(&attrs->probes->kobj);
 }
 
-- 
2.47.3

