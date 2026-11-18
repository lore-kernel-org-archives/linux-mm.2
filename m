Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB1E1606A32C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 02:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GKzVTB/o
Received: by kanga.kvack.org (Postfix)
	id 56A2A6B05CE; Tue, 17 Nov 2026 21:22:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CEBF6B05D1; Tue, 17 Nov 2026 21:22:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31EDE6B05CE; Tue, 17 Nov 2026 21:22:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F20606B05CB
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:22:40 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7D864804CD
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:39 +0000 (UTC)
X-FDA: 85446641238.17.CC82D4A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id E47DC20008
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:37 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="GKzVTB/o";
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794968558;
	b=5hJlN+Ht7X3tfhnnfnFdpEj+aE/v3HmtwVK60CSJPqt/57x6eqcE+ga6pMcx/KqgmYCmQz
	I1r3Yo512f8xcioe0C2r8sCD4vnnmQNKItnuiWl0+Ycwg2wgxfxJU0VwnZg2R81GDhwK3x
	oyhsBT8GltZKffj2gMS8hkTLH+qP7BE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="GKzVTB/o";
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794968558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5kDNeq0YIzH6aqgKl3Y8N9odneRfo3uo0UcuJ/hi1Pw=;
	b=6yzGrmSoOniyN0EQfubl4q+C7rwzOlqfQPpIeQQ+oLBQptu5pQSRi/7rZleLTEGbmNgnrC
	IlpwigmVT9EQD1rbgxYfJEA1yhQEpuixC3Ym5zAocBshgpKE9xWO2Kv4JcmyrDcI7wG2w9
	Qnzglq9Kla3UvKCMqE61M6oe2/PqoVc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BC9C661F35;
	Wed, 18 Nov 2026 02:22:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CB711F0092F;
	Wed, 18 Nov 2026 02:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794968557;
	bh=5kDNeq0YIzH6aqgKl3Y8N9odneRfo3uo0UcuJ/hi1Pw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GKzVTB/o+PIPUhNOflmOqevlWf/jhiGt+NaWTYUqm8KoS/a3yt1+jZSmr5ukVrs0K
	 TZaju7cU8ONa3qgGAIVLWAHPkh6M6LWSJ/iZxf8EhvwZi+ZDBD9g3uU5KpHI7h0hyI
	 gzkG88+lKN343th7uhHUR4St31cGUGs5odx7f2ywkWVf8AeieH+8orJHoKBWiA6spI
	 Tskvra6eGx4aCbXA3vYRXX9XgS42nMNFEmb/FbTQxriErwNsSEsNlKs0EC2/WPoquz
	 iKBkVId/VfAWF1wyZTLQJxwOFwLV0MvPLpCRc9waiyfrhb1aXJLEY8qQSN8VJhuCOH
	 zcd2mZJqBk2KQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 15/27] mm/damon/sysfs: add filter_report_type file under probe filter directory
Date: Tue, 17 Nov 2026 18:22:10 -0800
Message-ID: <20261118022225.100659-16-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118022225.100659-1-sj@kernel.org>
References: <20261118022225.100659-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E47DC20008
X-Stat-Signature: idqxxesi9bcm1k1i9rbdziqrarrjmaah
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794968557-232696
X-HE-Meta: U2FsdGVkX1+d6v9qUTiXlIh6ssy3/S2uZf3erT7kcsj62iRN+Qxu8I3UZs4T9wCjeOESYuJ8CyLOy0sRUBVV6lrwjE0ZVIfPH3h+WpcCKSDU42mKokDpWyhFCsnCjQ2A4Pa1wdH2cAWajDA8keQjNK8PG40mqQEwkFxhwIU9zlbTC/Bx3Ihadc0UhVFRk+u5KZ/P6rGSIzd6iL4uDTefMyRu8yF4+9hbIEmHXRFQssl8oAAF42Wfofv8tvzhD9ZudheuGTil2naYRUdKgr1y2Wq7+THV5HFyyfcrH6X/ZJTjCiINRlkFgJOftRMxdUj711JuN/jDOzVfQW9A2q7IHD78tVnztybCgbF0ta5CfewrjXGVq94Bnx3cEvLwF8KEiq5h+49KzkYCTttHfTYZnZFMCMFVbFHHysACkQAK6p1xyzIFD4ooK9xn4kycDhhtnxFlFMnF7KBsoGa1q1Jzoi9QqfuTBEfMr/fwf3GmG2//sPp4Bl9YHw1lvSPR/P512y9tsK790dTEHoqlobELU4/e70XPozDCjeeZfIcfGFrxGT0c4OUNsd+OlAi53hZKaEydfX24uRTc+8SQ1irOmbx7VKFk9Rj79KK/muVnYybZVHp+Q/823d3XWk79LZ2HX4ELP0XRmGnjDnEYVgV2x2uC2nM+UeX9WhzQY3BOPT+VdbfuoHPgtckuIC3flB43nmhl3htQBsUV0Gw8ovlpAzV21muC25rHXAzLvn1VAW2eW8rD9pvpnJhMpBPl0sffSXwKQM1sVsPax0lrTzX0S37r4vuhkAhFutbppnK0gyN4jXo7zq2g58dqp4ghtsCG7Upk69noqwxMcqxJHMxc7hi7B1B6NeeCnGpDtpo9QiQhVLCPPdxcnlnOx2ngRJNCe5AjkIkkXPO21viAkmgSioHl+y2r5jRjgWHo4r8AvOt9ymjXoKBPKSKQV5mrykrX7biX3iqR9WLrW1NItUd
 ucB8bVCT
 QYSgST3OUD7tH5fA2CLYUMQvsBxaEJoV/vUHsKQkS3gvEICnGHqKy3HhbC1Jfr2CeB0v1nDnzmrFDOMx+sJUJjUjk9mufwYc5ATmsLpt0Ak7XMen03gPKW/UE6eYHwyFu8fTU3B3K8BI1KGHjUM5Q11kngFAFqb8hHyYahDnzfC+8YV/VlygMJlK1UOVzJcWmRwif/KR4Q/H2uuGQBwT1S8gtr/lDDLycrCbfoFwaG/6cRVjhpJWQJ1R0vBcamKkQSXYnSMzNBmIMVaR+7JZG0ZW+YQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add a sysfs file, filter_report_type, under probe filter directory.  It
receives damon_report_type from the user.  Reuse
damon_sysfs_report_type_name struct for user keyword matching.  Move the
definition instead of forward declaration, as the code change is small
enough at this stage.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 61 +++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 52 insertions(+), 9 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 7cdbe2fedf7d8..ca971cf1dcf6d 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -977,6 +977,7 @@ struct damon_sysfs_filter {
 	char *path;
 	unsigned long range_min;
 	unsigned long range_max;
+	enum damon_report_type report_type;
 };
 
 static struct damon_sysfs_filter *damon_sysfs_filter_alloc(void)
@@ -1175,6 +1176,53 @@ static ssize_t max_store(struct kobject *kobj,
 	return err ? err : count;
 }
 
+struct damon_sysfs_report_type_name {
+	enum damon_report_type type;
+	char *name;
+};
+
+static const struct damon_sysfs_report_type_name
+damon_sysfs_report_type_names[] = {
+};
+
+static ssize_t filter_report_type_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_filter *filter = container_of(kobj,
+			struct damon_sysfs_filter, kobj);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(damon_sysfs_report_type_names); i++) {
+		const struct damon_sysfs_report_type_name *type_name;
+
+		type_name = &damon_sysfs_report_type_names[i];
+		if (type_name->type == filter->report_type)
+			return sysfs_emit(buf, "%s\n", type_name->name);
+	}
+	return -EINVAL;
+}
+
+static ssize_t filter_report_type_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_filter *filter = container_of(kobj,
+			struct damon_sysfs_filter, kobj);
+	ssize_t ret = -EINVAL;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(damon_sysfs_report_type_names); i++) {
+		const struct damon_sysfs_report_type_name *type_name;
+
+		type_name = &damon_sysfs_report_type_names[i];
+		if (sysfs_streq(buf, type_name->name)) {
+			filter->report_type = type_name->type;
+			ret = count;
+			break;
+		}
+	}
+	return ret;
+}
+
 static void damon_sysfs_filter_release(struct kobject *kobj)
 {
 	struct damon_sysfs_filter *filter = container_of(kobj,
@@ -1202,6 +1250,9 @@ static struct kobj_attribute damon_sysfs_filter_min_attr =
 static struct kobj_attribute damon_sysfs_filter_max_attr =
 		__ATTR_RW_MODE(max, 0600);
 
+static struct kobj_attribute damon_sysfs_filter_filter_report_type_attr =
+		__ATTR_RW_MODE(filter_report_type, 0600);
+
 static struct attribute *damon_sysfs_filter_attrs[] = {
 	&damon_sysfs_filter_type_attr.attr,
 	&damon_sysfs_filter_matching_attr.attr,
@@ -1209,6 +1260,7 @@ static struct attribute *damon_sysfs_filter_attrs[] = {
 	&damon_sysfs_filter_path_attr.attr,
 	&damon_sysfs_filter_min_attr.attr,
 	&damon_sysfs_filter_max_attr.attr,
+	&damon_sysfs_filter_filter_report_type_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_filter);
@@ -2992,15 +3044,6 @@ static struct damon_sysfs_producer *damon_sysfs_producer_alloc(void)
 	return kzalloc_obj(struct damon_sysfs_producer);
 }
 
-struct damon_sysfs_report_type_name {
-	enum damon_report_type type;
-	char *name;
-};
-
-static const struct damon_sysfs_report_type_name
-damon_sysfs_report_type_names[] = {
-};
-
 static ssize_t report_type_show(struct kobject *kobj,
 		struct kobj_attribute *attr, char *buf)
 {
-- 
2.47.3

