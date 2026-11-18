Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CC73606A33E
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 02:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dnEB0gVC
Received: by kanga.kvack.org (Postfix)
	id 3480D6B05BD; Tue, 17 Nov 2026 21:22:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31F7F6B05C2; Tue, 17 Nov 2026 21:22:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FC296B05BD; Tue, 17 Nov 2026 21:22:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C931D6B05C0
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:22:37 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6578B1C37A0
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:37 +0000 (UTC)
X-FDA: 85446641154.29.0EA87F7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id CD2F0140003
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:35 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dnEB0gVC;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794968555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kHhnYqoQe1EhM4f5cyc2l4mme4lRuHhy4MnQ2nEOlUo=;
	b=Xuu8em/PDQTzpCV6paOCcLG9dsCNuaiBVWFqdyJsjKh3U1EOvd2ot+6k/1kopKBvotzct9
	Qb5iyAEPBGYZgTpLmacNN1FR+Y0OuI66Ms/+Fy6Le5oJZ6zjUjzYe4Mgqz5YkvgfrXn1JL
	B6Lit/dTGihAu2NPEobRPnWYw0NEePQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794968555;
	b=MyNwFOzZOnuz5JRAGc/0rx9W5oK0rwmI9MeDPP8xpLU6wMRhSdch1KQ8HX97Zk2VmGtquZ
	XokmuIaF03ftIJ74TMzpOUypuH3rF7L4JeZbA30PgSPDzDCavH73fJZF5xEkOsK2LkuSwx
	wy/w3wOBy58XQLPvbvi3426MB7XXDaY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dnEB0gVC;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6B19D61F24;
	Wed, 18 Nov 2026 02:22:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AE091F000CB;
	Wed, 18 Nov 2026 02:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794968555;
	bh=kHhnYqoQe1EhM4f5cyc2l4mme4lRuHhy4MnQ2nEOlUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dnEB0gVC6et4IrG9LHg9PAvALWa7uIN5NdBb4F2A42PPeV0JpvH+Wpas86V5CKI8G
	 ULD6oxqzsRL1n2tuCicc8G5fggKD5pE2xrxK3agzTTqx/JZuqT7ER8uovLb76rDd96
	 fh4e2aX4wrFzUx0JDzzFkohUbl7WI0tIDQWn+Qr0r4pa/pKgWRUhNYg6n0ybWKgePu
	 u27xAFrlV+GytjKdkTC1dWMBcS803rPFvhTnEEXJVddUI0RMAfeyJ8RzYvxz3t3o75
	 c3mkxcx77NNOPtol/81BTYV0GssChMvHc2UR3OdgUqqoSt4ygjpo8d2pv1lRTq5qOs
	 I9ZqPIfFPocEQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 08/27] mm/damon/sysfs: implement report producer type and state files
Date: Tue, 17 Nov 2026 18:22:03 -0800
Message-ID: <20261118022225.100659-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118022225.100659-1-sj@kernel.org>
References: <20261118022225.100659-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CD2F0140003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: s64zcd3ces1oziycttyrf1tw73z3kyn1
X-HE-Tag: 1794968555-510602
X-HE-Meta: U2FsdGVkX19Ke5X3Z8riQli/5hD5/5WtuKBskXYblvesGLkxLTRZlY1GMRPjJATnneriYqiYA8VGQkAtAEkL0muNAEWIKzbCjR5PmzTht0mQeDxNpZSiVNUrGFyJ9Ose9B14CIQcGmrtZeiepDiA0a6Joelim0ozejSRkcr9myG/fZ7MFdSrslW4KDIRx1p5/vjMohlBPK5rfM/M9etW1UjiJZyevBdobBolQa2gbVguqCn/6kisZap9GsgS35ttCaZA6mSOaN/nZl9iP2+12NmVHK+Wuvv7DoSkGeSZQ1YEKfFUphjwwLLZiqB6a/QLXyCoARNOaVk+hoRKQSHG6K/jxOVmEAAzyhx1i7UW6MjFrcU0ci4lEjJ6qnwH9qNZpqAYeWYAnRqI2h2k7miNt+fEZ7tf6uW9yQe7xPSAsU/vXuwXwGxpTH0RX2sqY+BYYeW+3dDBb04aGj1qSX/IYmzfdc18DAztNCSdeoltqNcYSD2t5HwJHT13n3YxfD3ITrdxtS31Nj3ob0PFQHffGl+ft8N+CNiib0WuOy220m11kIeVscSBQ5JGjbRlO6G6XJh+Q3apJyRnlG8zJum+EqpwgHiEvqs5Fe/LpWvbp8MEwRtQVmNvRXYSRsCW5EPAhAvnT0HejsDhIIDg0OqvNS9Z6SjHNObWSHVYDwMYq4EWBJEf3pBJPKh5WOuYEC7lCDKTFU1+m7JMI3apPnyCN3IYVZvyhtGqpwyVn7aD9kVhEY9YNh+GQ9Oa7qrZKX+BVTDbENtx9eAg5VF+UHsK5+3UHKd8gEn4iJnJmY/4vN+0+AAoK4hXXW1M6kiruS6JpkDpDAixEKSYBlWOvTh61G9zx4MU/Mk5rvOoIBoGe3oee4Z9vvti2dt2Fr4fvNoGwyUJhaMf/q2ro7SMI2NrRH39w54TpMdSSIgex5s5mxFnoVXtfmlS8eD03Og1h1wxkivzFlmxe8N33SEKl7v
 w2zMS4tP
 WhiyeEuZ47M2QmqGTJLFQq8U+BgpAayaPqp4Du9QRVNClvO5OWMp1nxvWsqgG8SKOX+Ma2Nhx+h71js7rD0bcOzqTPy46oxOxkimV0fDY5z4vPbJtieqANfi32WV5GrfjTJdC7hIkRw3aB0qyf9XPwmp5/AC74NqHosV7s2OmFzp1YuxapfNOSnnDTYmTlokM4Co4uX7srGHyLKBU+Sc3B1zQJvCVl4oeQQ6Abt5jhKUNd24=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement report_type and producer_state files under the report producer
directory.  The type file receives the type of the reports that the
producer will generate and submit to DAMON.  The producer_state file
enables and disables the producer.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 80 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 80 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 7c6bc30c12125..7cdbe2fedf7d8 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -2983,6 +2983,8 @@ static const struct kobj_type damon_sysfs_kdamonds_ktype = {
 
 struct damon_sysfs_producer {
 	struct kobject kobj;
+	enum damon_report_type report_type;
+	bool enabled;
 };
 
 static struct damon_sysfs_producer *damon_sysfs_producer_alloc(void)
@@ -2990,6 +2992,77 @@ static struct damon_sysfs_producer *damon_sysfs_producer_alloc(void)
 	return kzalloc_obj(struct damon_sysfs_producer);
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
+static ssize_t report_type_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_producer *producer = container_of(kobj,
+			struct damon_sysfs_producer, kobj);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(damon_sysfs_report_type_names); i++) {
+		const struct damon_sysfs_report_type_name *type_name;
+
+		type_name = &damon_sysfs_report_type_names[i];
+		if (type_name->type == producer->report_type)
+			return sysfs_emit(buf, "%s\n", type_name->name);
+	}
+	return -EINVAL;
+}
+
+static ssize_t report_type_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_producer *producer = container_of(kobj,
+			struct damon_sysfs_producer, kobj);
+	ssize_t ret = -EINVAL;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(damon_sysfs_report_type_names); i++) {
+		const struct damon_sysfs_report_type_name *type_name;
+
+		type_name = &damon_sysfs_report_type_names[i];
+		if (sysfs_streq(buf, type_name->name)) {
+			producer->report_type = type_name->type;
+			ret = count;
+			break;
+		}
+	}
+	return ret;
+}
+
+static ssize_t producer_state_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_producer *producer = container_of(kobj,
+			struct damon_sysfs_producer, kobj);
+
+	return sysfs_emit(buf, "%s\n", producer->enabled ? "on" : "off");
+}
+
+static ssize_t producer_state_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_producer *producer = container_of(kobj,
+			struct damon_sysfs_producer, kobj);
+
+	if (sysfs_streq(buf, "on"))
+		producer->enabled = true;
+	else if (sysfs_streq(buf, "off"))
+		producer->enabled = false;
+	else
+		return -EINVAL;
+	return count;
+}
+
 static void damon_sysfs_producer_release(struct kobject *kobj)
 {
 	struct damon_sysfs_producer *producer = container_of(kobj,
@@ -2997,7 +3070,14 @@ static void damon_sysfs_producer_release(struct kobject *kobj)
 	kfree(producer);
 }
 
+static struct kobj_attribute damon_sysfs_producer_report_type_attr =
+		__ATTR_RW_MODE(report_type, 0600);
+static struct kobj_attribute damon_sysfs_producer_producer_state_type_attr =
+		__ATTR_RW_MODE(producer_state, 0600);
+
 static struct attribute *damon_sysfs_producer_attrs[] = {
+	&damon_sysfs_producer_report_type_attr.attr,
+	&damon_sysfs_producer_producer_state_type_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_producer);
-- 
2.47.3

