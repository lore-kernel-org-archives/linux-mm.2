Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54218606A334
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 20:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Pw4tjcVW
Received: by kanga.kvack.org (Postfix)
	id B1CDA6B05CC; Sun, 15 Nov 2026 15:29:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA57F6B05CD; Sun, 15 Nov 2026 15:29:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 995EF6B05CE; Sun, 15 Nov 2026 15:29:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6C4336B05CC
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:29:12 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EA348C083E
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:11 +0000 (UTC)
X-FDA: 85438492902.06.64F073A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 77FA9100005
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:10 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Pw4tjcVW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794774550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YDurKzhLIi0mIdGpL4ZrXZs3NcRPuPDRtfbfQ8ZOhNQ=;
	b=J49gQveetyg+9zLQHDpPPh46bL5GIoAPX4DfMhj3HCQfxp0+1wkewui1y7JRMjPOFFK9gd
	oKAWEG0rl+/aPIw4i2qa9R2UM/kxntGe3opPYAJz8zKRl+c1IQugbc6QzV4g2DZrq9nPm5
	knYnnQWs9ZponfiuimTlrHdkFqjPkjQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Pw4tjcVW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794774550;
	b=c4ergX9cOKJx98lSsF6bVxw62Uva3REKWGnBvoG40FKPgKGhbMVOssN04D9+kWd/K/hkhd
	a2/3460o6u06hJlQhO+DYM+BQzhL2NXO1gXD5A4KG3uFRp7CHvD0G9cHWCpZzvb9ILVr4b
	EZH4x25p6Rpzk+wKEgqCv15nc45PaSs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1BC6E611B2;
	Sun, 15 Nov 2026 20:29:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F291F000C6;
	Sun, 15 Nov 2026 20:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794774549;
	bh=YDurKzhLIi0mIdGpL4ZrXZs3NcRPuPDRtfbfQ8ZOhNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pw4tjcVWzqwJg7iRBiFDM7FkP8k5OwGqzmaFn2WB09w2liP193bNY1i9mjNhoVfc5
	 WlIqgcZLJyfNI2e9C5ClAxljazHrJi70+smYiMG2G4Z9N/EjuH57pDZnFTade0iKGZ
	 LwtEYvOcqznmJMckK5Da3hEvl6NfhGRRLWHUsYAR3Fv8pMOnrzUWsTe+6y8JwnTble
	 iiCkj5z+hoG2cq2dVjWr70wrKrc6Vjh0bPCYsUtXBLx3HxgkkaLNaTV5a+4Jzt/f7G
	 IayqTi3+pkEoQWTLUVPSfX74xuyOYzDk9BxphvRIs/kGL4D83MyNKotLk0+SfgUmCU
	 UdsLOkXUUhYhw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 22/27] mm/damon/sysfs: implement report producer addr_{start,end} files
Date: Sun, 15 Nov 2026 12:28:40 -0800
Message-ID: <20261115202849.99134-23-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261115202849.99134-1-sj@kernel.org>
References: <20261115202849.99134-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 77FA9100005
X-Stat-Signature: wah1oej9u971cjtti93jaqhmde3xp6u7
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794774550-358073
X-HE-Meta: U2FsdGVkX19q265gugvxvRLl/ju1znEop0TlHqt76EKGunbYDAitSwtrtC6ob9veha8KX2W3KVRUDrYwmxQbHprP48i6Xi7OURwOeV88wKcK6wp8aMKH3YWyGXrPypnWjkwnDdARRFWUz9I6R7sZ5O3QauiZDu9gRjnFsfPg1Uy2vr2FuQxWMUuhoq6FXY8TY5yik8RvTJo5Oe5pYWE110PX0j3omqkOv7PvYUqiE9O3LKPxeizd2vSnUSYlpfi8LYuEQFznvL/JU6/c6d61QdeXmMSNzt718OvfTezPE1Tzlp8+fspF5KIIvuDO/EJMvO0pcaNoIft7Y4jkCoNeLu7a/IKsXj82mpYheyQqyyP7I+P7QoFEygNVVv+WLYbUjtXtSzVlcypgKxWfq64HIf8tdCbq8J4b1qkp4zJXa7QSNvjN5Ya6Udm30TjQ4/kEajaEYE9fK7xb0gnWrWpRVFVRv0gPmCCJXB02aEHYTMYYkZPIVd+4XUnmDBcs3uTwPc3nc/YSK8lIoBAdnsKIeWwdtlaE5QYKvewV934feEydaH6OzdBziePNVHtR9O3qQSwQsB25PPTOC4G8s0/qQJ1CgKqtk6wD7WmWu2GaI8YEZtNgztXTR1ncqGU7qQ1uLgS/9a0GvdLwhNQH7pNmn46uUyFRdyrsxK5obFqnqCuzABGgInJ6hUZrkePx6QUWJPihTwfob+RDKmIcsLwJq4UCYDrkiJyreCfgwtsJjBMKexCAbCv5dJNFSYl5fTChT/F+nqQXjqzq7RISXXMX57A2QS+RHtu+2B7GV1OOYxUhOSaj64jzcTH5QUp1M30aCiUoT6N0+PnkxfWBd2y7QEa9ggXQPY+0BgCDmCbr/foPd5a18LDDRA+yQ8wAYzZ32FFwugpyL49wgJYNVNSom7CcwEe11c3d9/uYYHMlnNnJ/rBrrMPUGMcM48jUwMB88Vg+bvPfb6VZvyF0r4T
 qWRICk60
 sgr6kakCpX7v1d263BK6Rr6HsZVQQiCQq8/jWGUzoG+FQjYZ4xIJMbt4zGGrRj8H+d7J2XRhJymDXtFNi+I4m+5QB6dbFDRKMWbiFdOu/IcVpE2YZVZ8IWzW7/xPj0ZeNU5CA/BS2aoSk0k4EoGsY3B3cp0q1zJxBgYj/ty16WuMyHb50P5bI5w55Xd4Uo5Lx1RGt0WSIK4tmg6CAJ4wmHBZtPxsDOeAYwdJuInoCsvGIFy326BiOGzPMSaApGbg8XAXV6tKvwx42eNpjwad3jncR8g==
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

