Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC560606A32D
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 15:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lE9fEpNi
Received: by kanga.kvack.org (Postfix)
	id CD6976B077F; Tue, 24 Nov 2026 10:37:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C879E6B0781; Tue, 24 Nov 2026 10:37:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9D196B0782; Tue, 24 Nov 2026 10:37:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 92DA76B077F
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:37:04 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0729E80B95
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:37:04 +0000 (UTC)
X-FDA: 85470415968.19.F0C5344
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4F41214000F
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:37:02 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lE9fEpNi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795534622;
	b=ZBM1vcoOFaiIoxfzRzJaZXLGxJ11jP3bCVx/3ACRAisal8nDtVQoVQkYFd51MGi5P7TV9C
	jmAHMmX3xviDtz/zzbHBt0FkYrD5nFzqOwEg25KrGk7eY4Q/2XLh3vWl+ga0pWyUx9V5S5
	yeP7N1tO/hccLxyktXY4dQxJ+6slmb0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795534622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DC/+LIj6wa2bI+Fi5zCavOExK7wgUf6SARf9BVg3XsE=;
	b=m9Q1pUhcP8IPvJj8Tx0kemFL9qnYDp9y6Q8lTMMN0aS2+3fo4qYgilAL3jDp7fZjFmcgyf
	APEzBj/Gs2q2H/wmw8pPx6xTc9eRvWHCXbZEfxqj2xbrUGZAqN19v+5Ozamt0tbnE3Xoa8
	0QVAOqmmJWwkGFcM/Omf9uTAr6UZLRE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lE9fEpNi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9A6834033E;
	Tue, 24 Nov 2026 15:37:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E4FF1F000C4;
	Tue, 24 Nov 2026 15:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795534621;
	bh=DC/+LIj6wa2bI+Fi5zCavOExK7wgUf6SARf9BVg3XsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lE9fEpNi9vpjAcKJXktPM6hnlEFGX7K5sxuuqil76G9oqB62DKtmKu6plSoo6/k8p
	 tT5ZU9qj/oWfB5OA8xdWisNRLMzjaX0op1anyh77LJHhuRCtQ6QHZr//n0nOYK6WIk
	 7nBAGSqvoWQVnaVaF1Q12eHkQ7fD2kd36yWvbr7Cg5nHkZl0yYVlG2GU5fsjERlBty
	 gvTNR4G/yufzygXFCSIhu5NWhkBbak7WD0ZRYsiS/aCoBSBNb9hhqFmoi1CEIs9H1+
	 L9w1fQasCmDUodTd6cmZjJS9pm+wHZrboHjFKvmOwbiNQ5p/7yBo8QBKfaUUcshs/T
	 9Wq+3R5znw+zQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	Aveline Noir <jm5905938@gmail.com>
Subject: [PATCH v2 22/27] mm/damon/sysfs: implement report producer addr_{start,end} files
Date: Tue, 24 Nov 2026 07:36:28 -0800
Message-ID: <20261124153636.91854-23-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261124153636.91854-1-sj@kernel.org>
References: <20261124153636.91854-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wszzkxf6uspyirp7cquf5dbbnb346zxz
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 4F41214000F
X-Rspamd-Server: rspam03
X-HE-Tag: 1795534622-390100
X-HE-Meta: U2FsdGVkX18ClEzK0KiqmoR4ZGlWbc0w4tEA+6CDA8r8IJ8j8+XEZy4uGAwDzKpVgbSAgkbB8cGgTTN0uSlIdSDn0GvfIWHp/HvnLqONzc3914/Va76Q1BawYumS/Sa8jzWeDEn7w68zgG58Vl8+4UJ2K6SwWTnLHp/cYQNuh1zNnWoi4uhNdjV6H+8xZ2+g7QrqSSYpyBvVgLxIbFXkBkxpNU3SsonciNSTk/ynJm5+3Lcs9ChilDX9v66cxLVKKxQ+T8wEVfwJIYd4aBk5YYlibtNQ5C9ggT+hilz0j97GVYgMp4BUtCMnzkULE6poiuuXSGoNmmz+jV4KAUxYqWTX55Qm0sWFv9D9JLIoJwathiv6FZRZDMuvHgkt/HB+HBq6RDAdl0JNSC/7m5N5Uhvjvv/aohnWe5YQHsblF3HZxuxde7FYiZ6kCIxQ9tO9XU0SBCX00ouZ1s2DoCcAAfg+aMMs9xtNP6kLDlklZXbhEmCzkcU85KZjBaC2AxEIwzvUHNsPtbNnDbkPsQo2SkW3BbaU3DruFt+mBZWoF/XdQDyB8IoS8qrYUrp367dFEHCPSsja2gnNa508X8wrFTavVlbwQrlBKJq7LirAJrL99DolKBJWgBVqglRbr4sdshOJtXBFsuBzoN6YP5qt06pp+Q3Bad8zHBeA0pZbCwClssdCUATNxscBEZKv0BqhMMLO1GPU55FN9AyP3ob3tBhM5FwFpp32M/p5b+E9bRp1ReUq8uxul6CKOWly8ZgB4E/5mt7rLK96exkk3BwOVpbsHhlSGJmCcLOwp8NXswn623ujJRXZgg2SgHxafA3lAOzumuSaBF8PsZtJvNgLg5XdILn6JkeT/7qfyzEAsIJizh0EhuJSGyKcOTskMNDFe7+4sQlNEbkqjM+D8aWosjwxYHq4q9Fqw0bZU3b3YuWj6LSHKbHPI5mpZG93LMEQQJ5wt7dZA8lZ+5ggwak
 5cE5C/G9
 L953PGcE/+vue/BqDV7/ksUBZhT1EYBej4GL2voauOEnSDlnJNFc4iyGfbY+BtZ9j4IcbTKqUolnM9NDaYDu/KM5hnNAZRAtZZBgj0N/k2mU4FoTkJoiyfgq+wG+ND6PWEYXxW5B/w9Wz6J60INzbN6LMsB7k03fsKSOY6CWrjpIzSfyoEc86gOAy0Ap00LVAVm9md1JF+05ZOxGp07Wvg4FwPdFuRxQGpnBrzncAVzsGeh/3+W7HUOle5f97vS0vUkquOx9NkfpqNx5R42S61N9kSeJ3Gp2X+7R++U2CxUiPrsY5Fn92FoAfIonkCJJFaxvsweNnvDpwphTlZZsGGZCUkMpq3hbBXZxsNYu0QAEJQMzDGAkxxmqi5OFmVDYlh7u46JLc7IfTy75fk6ZZJaXXaNOQs66nK0ZmQz1fX0n4pBIl+2mtbgzKj8ytsON77JL5/7Wd+XwJwLoQGQD+CWMzqbrKEiHdW6JzC8VhIvjqnZnqjEnNXB72+WTZMDk50QGwV4x3bka5EwT/sHbUvfcv6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement addr_start and addr_end sysfs files under report producer
directory.  Those set and get the address range of the user_report type
data attribute reports.

Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index b4d898ec0c9f7..5f9bb1955dfd5 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -3047,6 +3047,7 @@ struct damon_sysfs_producer {
 	struct kobject kobj;
 	enum damon_report_type report_type;
 	bool enabled;
+	struct damon_addr_range addr_range;
 };
 
 static struct damon_sysfs_producer *damon_sysfs_producer_alloc(void)
@@ -3116,6 +3117,44 @@ static ssize_t producer_state_store(struct kobject *kobj,
 	return count;
 }
 
+static ssize_t addr_start_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_producer *producer = container_of(kobj,
+			struct damon_sysfs_producer, kobj);
+
+	return sysfs_emit(buf, "%lu\n", producer->addr_range.start);
+}
+
+static ssize_t addr_start_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_producer *producer = container_of(kobj,
+			struct damon_sysfs_producer, kobj);
+	int err = kstrtoul(buf, 0, &producer->addr_range.start);
+
+	return err ? err : count;
+}
+
+static ssize_t addr_end_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_producer *producer = container_of(kobj,
+			struct damon_sysfs_producer, kobj);
+
+	return sysfs_emit(buf, "%lu\n", producer->addr_range.end);
+}
+
+static ssize_t addr_end_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_producer *producer = container_of(kobj,
+			struct damon_sysfs_producer, kobj);
+	int err = kstrtoul(buf, 0, &producer->addr_range.end);
+
+	return err ? err : count;
+}
+
 static void damon_sysfs_producer_release(struct kobject *kobj)
 {
 	struct damon_sysfs_producer *producer = container_of(kobj,
@@ -3127,10 +3166,16 @@ static struct kobj_attribute damon_sysfs_producer_report_type_attr =
 		__ATTR_RW_MODE(report_type, 0600);
 static struct kobj_attribute damon_sysfs_producer_producer_state_type_attr =
 		__ATTR_RW_MODE(producer_state, 0600);
+static struct kobj_attribute damon_sysfs_producer_addr_start_type_attr =
+		__ATTR_RW_MODE(addr_start, 0600);
+static struct kobj_attribute damon_sysfs_producer_addr_end_type_attr =
+		__ATTR_RW_MODE(addr_end, 0600);
 
 static struct attribute *damon_sysfs_producer_attrs[] = {
 	&damon_sysfs_producer_report_type_attr.attr,
 	&damon_sysfs_producer_producer_state_type_attr.attr,
+	&damon_sysfs_producer_addr_start_type_attr.attr,
+	&damon_sysfs_producer_addr_end_type_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_producer);
-- 
2.47.3

