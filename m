Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43D37C8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 17:13:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 497548E0034; Thu, 28 Aug 2025 13:12:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AB148E0023; Thu, 28 Aug 2025 13:12:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11A468E0023; Thu, 28 Aug 2025 13:12:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EAEDE8E0023
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 13:12:57 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AA070140303
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 17:12:57 +0000 (UTC)
X-FDA: 83826811194.26.730EEDB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id CBD841A0003
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 17:12:55 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="UH9OD/nH";
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756401176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0nSTYqqo6W+KNCRma2II9Jiu2X0+XBjegiK0dCwSVN8=;
	b=uvA627/OWnZNxsr+mWX0yj8PHeHUjrwLsgUiESFwDhRpk97it/2L2bFjb7o/D1dWUFbZ9J
	CyGaESwdwb9TO+DOb/+31NISyPfiRc5UAOAgfxkhdqj1IjA5xIf2QmBwRHB914EeLjRV9b
	9fMi+7rXthic8pki/VSS/OkxdbohG+4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756401176; a=rsa-sha256;
	cv=none;
	b=f97wQsAm9PyEaZYMA39T5CcdZwe9MLLG+atqpEvyUbbFEdWhU4DWLf+Ccpz/eVGPXCC9/f
	e/6oJ+nEck1HEA5/FX4YiboRRfRIj0SKpDK73zPQ3y3zitPF/5WCNvShEDgKeyQ6HLJMAY
	ApgNwg0GXol4Y2XKTksiOotNKYnMhFk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="UH9OD/nH";
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E947A443E7;
	Thu, 28 Aug 2025 17:12:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9F37C4CEEB;
	Thu, 28 Aug 2025 17:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756401174;
	bh=BBbyydnwAs+XoNN413vvEKNIDBGc2IkMvtIzus1iybo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UH9OD/nHql8BkKwDV6clvDMyCvuuDAVn4QXQrqdQgRCKAn45/yaH7ZhIXJq4NhQe8
	 X/tdfyGZamgbpDx/dAKScIx+v2emHEdN2YPtXEJD7YpGWlxqVFmaQ/r9xNyiH2jBAG
	 7tfe/iEM6vmp3ObBIaU9/2zq+j2SPO5jYkHOJl+imDDd69SJlU75QICwwHm8mDkaTM
	 vhQmWqTFd166GJDhalcloBfgmonSjiB0eKeMruetNgXIqJMhel5N5MIsrUc3vHMhIS
	 cjQh2fUImtoMjxJCuA3kZphZ9QHS4DYyQfPI/w6mGSeqZq2zsYSq8MvZUirLElBHho
	 zoQWAbeUV/arA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: [PATCH v3 07/11] mm/damon/sysfs: implement addr_unit file under context dir
Date: Thu, 28 Aug 2025 10:12:38 -0700
Message-Id: <20250828171242.59810-8-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250828171242.59810-1-sj@kernel.org>
References: <20250828171242.59810-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CBD841A0003
X-Stat-Signature: 7wufrk97r9ggi578k5x8577rpmejtn6n
X-Rspam-User: 
X-HE-Tag: 1756401175-229748
X-HE-Meta: U2FsdGVkX18fsgewSm0pJldsDpZmCQeYcRbQZ0dX2GC6B2sd0O0N904QakTTY2p1R4uyKaFjUQkGoYNnMiyVBCITq0gXSZr4m6v98RZEjCdUrwFH+OWCSt/8Mo7Lxr0aNbVx+DPtXH9hSO/9KwV/K8tuzW7B3swgysOZS2cZxeY/NLzFRs8+KsU9xS/XX92mpRKQftoSYDcyOD521bnna9RYuPc0QU8rMianqXvZGvqo50JBJIdCvBCgcsZTuXjKRqB06O9Cg1SlK7ghhI1R/8diAJZ5mcd/nnQ8woN3g3XWiGvQ1zZ+QvqJFgs3hIqJlo4iHI9sH24KX9BX666GfphXB597sGaIE7zKRv23+roAGjXf670sIQ22IvKjDMH5MMzHEiYTQSyc9K/rwLiVRLghRlINkDn/pVqa8wSJdb6Ua6zF6AVRppWNuG09Zb3vovPtU2dtnjcSzROsBtklBH92en3qJe/eX86DCnGpKOmDFjSsLnZSIuPSKxVqBPa6QGz0BMD/DAop+P1498Wk4SoGDDoATIaxDuvu3O+mgR6xbaaEobjDQ1cQTxlQQCLp/yZjyOn+puoMY2+eNK4fgnUFMEuzPmXw1ZPYJPjqtK8ctuYNLMdpsibf6os9B5TsIqE6jysQH55lBwl6Geo5QWnRgMfignOxKfGP7bY01ypU9vkVEVH9VGrdnriWIz4+jwIQEilqHCIg7O0fDJDbWAN4vaojkKEZ/cvOX6mVPQmM3KiteJRifqGF5FLYol9HBHlDFIRvGpVBy3TXApJcGiWUCR23Lgza0aQzwu/rUtvwWrmSh5gn1rh2jGI52Nzgucppb9JtVrFdtgUSfcBdfX3LoC4lX/WkFyjJPJ+XrmpwwtfEsTOjyJo8cQ2bKCTHbiAoVSOP07MD8TuKFCaJgNdiRB0IDEDwz3HxiI3xfiNU8UXub+u/FSDz/FiNS+HvQYiDry26HkYZNxwo/Iy
 oMlBOyIL
 jEzur53C1cd8Xpx1mg4vdCKK5bbeKeXYYYAu+YonOcn3YeQAJVz/HtSZ9jWzPaEyu2ryk/fJQm8k87x4VCNvBwDJ91SS3YfqxlD09WON9FFdqHN5IEI9fvizJK3qj3NA70S2GAY7RDHjAXLzTm3H4ZVV9BIkiIEzdRS7Sbopu8Zz+HEIjyauemCw11KJrlMg1NNKF/QBdHlyNATrp7l86AM0W7LhNN/zBJReMWQWNWnSkxx0xINo28XRov/EgU8qtPIv9oP5LX/dQC1H2mOF+Wv07E4tfy5AODCgrpk2+yonRYb4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Only DAMON kernel API callers can use addr_unit parameter.  Implement a
sysfs file to let DAMON sysfs ABI users use it.

Additionally, addr_unit must be set to a non-zero value.

Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 6d2b0dab50cb..98bf15d403b2 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -834,6 +834,7 @@ static const struct damon_sysfs_ops_name damon_sysfs_ops_names[] = {
 struct damon_sysfs_context {
 	struct kobject kobj;
 	enum damon_ops_id ops_id;
+	unsigned long addr_unit;
 	struct damon_sysfs_attrs *attrs;
 	struct damon_sysfs_targets *targets;
 	struct damon_sysfs_schemes *schemes;
@@ -849,6 +850,7 @@ static struct damon_sysfs_context *damon_sysfs_context_alloc(
 		return NULL;
 	context->kobj = (struct kobject){};
 	context->ops_id = ops_id;
+	context->addr_unit = 1;
 	return context;
 }
 
@@ -997,6 +999,32 @@ static ssize_t operations_store(struct kobject *kobj,
 	return -EINVAL;
 }
 
+static ssize_t addr_unit_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_context *context = container_of(kobj,
+			struct damon_sysfs_context, kobj);
+
+	return sysfs_emit(buf, "%lu\n", context->addr_unit);
+}
+
+static ssize_t addr_unit_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_context *context = container_of(kobj,
+			struct damon_sysfs_context, kobj);
+	unsigned long input_addr_unit;
+	int err = kstrtoul(buf, 0, &input_addr_unit);
+
+	if (err)
+		return err;
+	if (!input_addr_unit)
+		return -EINVAL;
+
+	context->addr_unit = input_addr_unit;
+	return count;
+}
+
 static void damon_sysfs_context_release(struct kobject *kobj)
 {
 	kfree(container_of(kobj, struct damon_sysfs_context, kobj));
@@ -1008,9 +1036,13 @@ static struct kobj_attribute damon_sysfs_context_avail_operations_attr =
 static struct kobj_attribute damon_sysfs_context_operations_attr =
 		__ATTR_RW_MODE(operations, 0600);
 
+static struct kobj_attribute damon_sysfs_context_addr_unit_attr =
+		__ATTR_RW_MODE(addr_unit, 0600);
+
 static struct attribute *damon_sysfs_context_attrs[] = {
 	&damon_sysfs_context_avail_operations_attr.attr,
 	&damon_sysfs_context_operations_attr.attr,
+	&damon_sysfs_context_addr_unit_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_context);
@@ -1397,6 +1429,7 @@ static int damon_sysfs_apply_inputs(struct damon_ctx *ctx,
 	err = damon_select_ops(ctx, sys_ctx->ops_id);
 	if (err)
 		return err;
+	ctx->addr_unit = sys_ctx->addr_unit;
 	err = damon_sysfs_set_attrs(ctx, sys_ctx->attrs);
 	if (err)
 		return err;
-- 
2.39.5

