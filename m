Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20510EDEC08
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 04:41:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EDCD6B008C; Tue,  3 Mar 2026 23:41:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A3BA6B0099; Tue,  3 Mar 2026 23:41:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F36546B008C; Tue,  3 Mar 2026 23:41:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CFF036B0093
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 23:41:31 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 793C0160401
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 04:41:31 +0000 (UTC)
X-FDA: 84507131982.25.E8A6ABD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id BC9A340005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 04:41:29 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SqDXw3W0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772599289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j8ka91Kp5vF8fgwhMUGB7eZQNZvw5YwTf06xR9t/g+I=;
	b=geHZbQo1D9gUBy9BQXjU4IwzpY0tcPL+fqmHDCgtSsqGUIWCq0/Owt7j8TlOAJihl6P9aL
	gYs6oPRj/J7W8rMzezdurKxmHFSUnwXgGKsrN/ygU6ebFG695hyU9B2PqWk49GQpypH/xe
	h20Kh08VbWvrWynLzkps2LZIj7Qf36c=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SqDXw3W0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772599289; a=rsa-sha256;
	cv=none;
	b=T8VsqgjpNOxjar/O4lYQACZQp+HDvmTkw7oLa1yxkVothOedZrQLZktiwGVcJ5lvTAnAmB
	rdiVX8+rITBPIV9kqeLBrkiVC06+buFZ0nFnDUcJcPJ4NxTyq45KVWiu6kOxExnMA0/sW3
	3rhk8EkHLobmLKXOY6olhpZE/wN6Zxo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D988044729;
	Wed,  4 Mar 2026 04:41:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2304C19423;
	Wed,  4 Mar 2026 04:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772599288;
	bh=Cz0dujDOIX0D2wsuyXTUh/TXx2EbdEyN7109tlsNnZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SqDXw3W0NvWmeE+6mfw9826vhRUL+IYxvIT1g0hxflbTAQReC+zO17jRTJ/k70Dw3
	 vIRctIxYEcOgvqYKEfJgr8acdwqdA/k0jP7gAKpqj78BMscunzq3qn0HMZnI4/ACn/
	 9tuw20Eu7Zc0qIW8++W2aPzr0vqpQz9wG4M6rTHtjc78w4NcxJ2qW/HD9PrmSlJOkh
	 A4XoU/8/mehdTuAjY3mcl2cyb7JUKzoc7kLZrhFMTDvfQMkotsldejxe4TNjwFo+Bh
	 sQEUw4ZzMWlJqgFzX0chsvmojPt1qCpe4drrTBuAUri9CKDo3GayIeTM5u03R3hsGa
	 PN3VTPBFtzKXA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 04/10] mm/damon/sysfs-schemes: implement quotas->goal_tuner file
Date: Tue,  3 Mar 2026 20:41:13 -0800
Message-ID: <20260304044122.79394-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260304044122.79394-1-sj@kernel.org>
References: <20260304044122.79394-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BC9A340005
X-Stat-Signature: ax38ngxr7397g68wro7c93bba6kiuddm
X-Rspam-User: 
X-HE-Tag: 1772599289-898246
X-HE-Meta: U2FsdGVkX1/9icX0avwhy6fihzQ5t9QEsKQDHiY73qsWJoFDSHRPwGjRajeO5JruZ0gXLh/LrkTbIcjl6dAPva2t2vANjUFDfi3Z3ZPqg+VTYc2NP5dWnDf6BD3++tvArKUN1QLUx5wcJ4P8c0F3vuRmijtIkZUtt7YxrzAiyMKwyCYP3jqyqBsRmRZhziU9bfN2pR2YnZf2QEQfroOeJ2bt3Rfm6VQ/1gyqLjc7OhsQnWjvrX2cdqPsNwsgCAgDSeN0NfztPtAcirlMuio9cK15/SVRRKsnb0A4AXP1rqOlWlztBA4odPOhfY1qCeyhtmQ8hWM1Sf1ThCEnzA+pZG/VIiNqNqf12iIu4l3cgj3Ao2IqGhxsi4ssHIB/PdwZ0YUFCsaRtLAjQMmlgej8zrYN6dVQEX6JnqoQE/6vYuxNuDW9x1sHgEtfP36V6Grr9XdtceM55VIVyvJ7oZT7rm6DDmn7DF34VKBOSBwtuTflA7PkICUFQWZygE8mSYpFeAlNqOq/9Ml2g8KUiVbBmEI7/1x2vetGNpYZ2KzMheOrBl6NlYs37AIusZCOEr05RTB16Eb01VH38isRgnhBQ9xz4oVw2x1iBCN/HHQr2ZZizY/JMm6wEwofmSMt5aPxjQwSVKlA8seMlDnQPCkqFlZTSK7/Zy8qvah3X7L/SSZqaDSySGvKx/7z/mMQnRxXbHUth1GpdrcZaWCL6HnqvVKkinsLGrKr0tUfwxVhK7baGDyVXD3Hg5qIb+u94kfYxiADiBIDgSIUUy0vjuXQkW9RglkOy0blBOfsOISFx8kWf7oC0lN3fPcbfLd7zvXYpYbOjDRNcKJ7BfJHG37AIXhX0JFH7wpz25CmOolMy1r+WQjVvmIP9J082+6xDfRCEFoCY5O/A4eH/AiiLstb25TssbJV6+26FYrQdZhPQPsi5Qy02Rc3v4z7ilWwtDprAy1Xl2h1pxgef8oSeM8
 hB5BYfaj
 S8ZAGFmZ4Zbj2tcTQk73HJfKSuLJn5nbCM5Guy0NGhN5Z+NRQPkIhyr4xUDRkJGWfkBwpiz6EvG42B89wKX5xr4q+vkYE8NfZn3jK2DOrT0aRCo5VfNIXeBMvUphUNIUtpFOebEfSQHllW15/rcw/WFosyKmKBcV8BBC2PGYoTeBRen9gFw8N36imfjzx82GbAzC8a2TgtDu2lWjXnbpiCNf6Y84XOV9V9HQJviXkD2ALHGXak/5fGDtwfiBuSfJi8MaG9OPk99fPxzr1eIiMs1nJoA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new DAMON sysfs interface file, namely 'goal_tuner' under the
DAMOS quotas directory.  It is connected to the damos_quota->goal_tuner
field.  Users can therefore select their favorite goal-based quotas
tuning algorithm by writing the name of the tuner to the file.  Reading
the file returns the name of the currently selected tuner.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 58 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 3a0782e576fab..5186966dafb35 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -1488,6 +1488,7 @@ struct damon_sysfs_quotas {
 	unsigned long sz;
 	unsigned long reset_interval_ms;
 	unsigned long effective_sz;	/* Effective size quota in bytes */
+	enum damos_quota_goal_tuner goal_tuner;
 };
 
 static struct damon_sysfs_quotas *damon_sysfs_quotas_alloc(void)
@@ -1610,6 +1611,58 @@ static ssize_t effective_bytes_show(struct kobject *kobj,
 	return sysfs_emit(buf, "%lu\n", quotas->effective_sz);
 }
 
+struct damos_sysfs_qgoal_tuner_name {
+	enum damos_quota_goal_tuner tuner;
+	char *name;
+};
+
+static struct damos_sysfs_qgoal_tuner_name damos_sysfs_qgoal_tuner_names[] = {
+	{
+		.tuner = DAMOS_QUOTA_GOAL_TUNER_CONSIST,
+		.name = "consist",
+	},
+	{
+		.tuner = DAMOS_QUOTA_GOAL_TUNER_TEMPORAL,
+		.name = "temporal",
+	},
+};
+
+static ssize_t goal_tuner_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_quotas *quotas = container_of(kobj,
+			struct damon_sysfs_quotas, kobj);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(damos_sysfs_qgoal_tuner_names); i++) {
+		struct damos_sysfs_qgoal_tuner_name *tuner_name;
+
+		tuner_name = &damos_sysfs_qgoal_tuner_names[i];
+		if (tuner_name->tuner == quotas->goal_tuner)
+			return sysfs_emit(buf, "%s\n", tuner_name->name);
+	}
+	return -EINVAL;
+}
+
+static ssize_t goal_tuner_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_quotas *quotas = container_of(kobj,
+			struct damon_sysfs_quotas, kobj);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(damos_sysfs_qgoal_tuner_names); i++) {
+		struct damos_sysfs_qgoal_tuner_name *tuner_name;
+
+		tuner_name = &damos_sysfs_qgoal_tuner_names[i];
+		if (sysfs_streq(buf, tuner_name->name)) {
+			quotas->goal_tuner = tuner_name->tuner;
+			return count;
+		}
+	}
+	return -EINVAL;
+}
+
 static void damon_sysfs_quotas_release(struct kobject *kobj)
 {
 	kfree(container_of(kobj, struct damon_sysfs_quotas, kobj));
@@ -1627,11 +1680,15 @@ static struct kobj_attribute damon_sysfs_quotas_reset_interval_ms_attr =
 static struct kobj_attribute damon_sysfs_quotas_effective_bytes_attr =
 		__ATTR_RO_MODE(effective_bytes, 0400);
 
+static struct kobj_attribute damon_sysfs_quotas_goal_tuner_attr =
+		__ATTR_RW_MODE(goal_tuner, 0600);
+
 static struct attribute *damon_sysfs_quotas_attrs[] = {
 	&damon_sysfs_quotas_ms_attr.attr,
 	&damon_sysfs_quotas_sz_attr.attr,
 	&damon_sysfs_quotas_reset_interval_ms_attr.attr,
 	&damon_sysfs_quotas_effective_bytes_attr.attr,
+	&damon_sysfs_quotas_goal_tuner_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_quotas);
@@ -2718,6 +2775,7 @@ static struct damos *damon_sysfs_mk_scheme(
 		.weight_sz = sysfs_weights->sz,
 		.weight_nr_accesses = sysfs_weights->nr_accesses,
 		.weight_age = sysfs_weights->age,
+		.goal_tuner = sysfs_quotas->goal_tuner,
 	};
 	struct damos_watermarks wmarks = {
 		.metric = sysfs_wmarks->metric,
-- 
2.47.3

