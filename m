Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 445E8CD343F
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 23:42:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 689F36B00CC; Mon, 18 May 2026 19:41:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 613576B00CE; Mon, 18 May 2026 19:41:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B4446B00D0; Mon, 18 May 2026 19:41:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 067D96B00CE
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:41:35 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CAA741A0A71
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:34 +0000 (UTC)
X-FDA: 84782164908.01.80A1996
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2670C1C000D
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:33 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t7sLBbkI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779147693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4MgVOwraIlGZLR/EHqQM/SA4uhbTgcnp9OekjD/mOtY=;
	b=e3wu/ShdqKn2xaqIhCQT/4FeR45juiOqrjcia8k1/cS8rEa1hjJ7rDXW/NPcbAms4KodYO
	2k9OCRnE3UrTsy2TACtDFo6E54AdobjVo6GzbFBx59xlOJMxO3jBeqKwMU1oEOX8pAXt9g
	xBYG+sKEaWo4Ah/vslZxWcxo0n8sKBI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779147693; a=rsa-sha256;
	cv=none;
	b=3r9Wuk6GynbsJHBhZ/UHtYi+QD46drPn/BWdoDHHrRgiaeiy80bilNsxDhDYVBHWCGWSSl
	4MQ+o33yXgsvwxLRNVbKbJM5q4aFTYyKsYU1xL4mjRa0IuNzHOp9hCf5TXUAqK4wbWG4Q+
	5KNTQq4TvVZiqW1xphUn2c+5x8C3QZA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t7sLBbkI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E0C0F409B8;
	Mon, 18 May 2026 23:41:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97959C2BCB7;
	Mon, 18 May 2026 23:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779147692;
	bh=AGpRYvO9ZCNPMYMckm0cAjHmLCwWdiWl6GwH6dhHuCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t7sLBbkIOm43qO3O7T09C0xNfgkehYwnbWLABepbu5er81+Uv0T6aeWgA7jvDoG22
	 xnmmPma69N0hJG/ABB7sZ9bDgoVFB0BH95HkfjudigdbF0FCMcKmbA66EiggkXzZ7/
	 Df8rXsPrHeWTBCh6E1AxZhsf2RyRXZKyxXF3p0PrE/VuAOhLd8Ukk+pWt3xdgWuj9P
	 +/mi+D1mKP2jA4Y6ed2tAlXJiAIdxKJaKbfFMGQXTdGO+NeUNpW2mrXiS1iPr+SG7i
	 +tVR1A5gWWw0xsquh2zJe5KiYi95zvnd6rPEscl0nIBGPhwh4gh35jXHCIS+pZFhru
	 CVt8gTD4Ugzeg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 24/28] mm/damon/sysfs: add filters/<F>/path file
Date: Mon, 18 May 2026 16:41:12 -0700
Message-ID: <20260518234119.97569-25-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260518234119.97569-1-sj@kernel.org>
References: <20260518234119.97569-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2670C1C000D
X-Rspamd-Server: rspam04
X-Stat-Signature: wpnzmcokpcf7abb346rd8c4dxeuxypqj
X-HE-Tag: 1779147693-387793
X-HE-Meta: U2FsdGVkX197Ks7hGdOHFDnOiEG+YZinNIHx4TTSEC3rzL1CA9LLp0X1HzWx21MfUU/vvz264AiRs+lov4+C0NJTIIXecdLe91wr4rcfn3jJvS6EWudtqnXJoyfJVkRKr0TSSjKqqO9T2NwrS04QvlOxar63m6vt20KoMFO3qWm/chKL75IrFkJ8k/0O5P9VsGu3DFhGLapxLii6DkrPT5f5BSiPfuog06b+G4j607ttGeXRWMRhC9vwVStjm4RjaIYxL7vc5Y1DkjII9GOjvl4o/HgKPW1MXjyKqe8V/BB1jRQAqcMTJkEGD/DTp0HY/blrnR+P9M6o6Bp1PKxrNxQ046XROzR7e+Pnp80wcqOG+ZiO+vlcGbNzvaNMZp5eVWe+rFre0B3hOQfH1i5Zgrbq7Ivqz4SNNpvj8cxlc9Vn0mktlcyPuli0L8vLD7EEqrlU/dYwlYpgAadDkO1JtR8QhbTZicuNtuZQaQlTnqD5V2NNt9FxlqhJ98irl9svNkod9vuxWVZIM9ldymK/Bg7sU1OQWvKE60OjR+Oo+vDqKZB6fnJhtFdcrUnuEpFGm+vZFHI4kX4bIW+T8pJrqRvQHAP1cYSPmUo2dX5DlMp3eLuoZlxtTfSng64DcDM9RGtF8YujzmPMu68ZiSRmdrWSSzmOCKCAfgGTRSRLxppPYgi2AWav1wpJPiRvZ8sKo03vf8iWE1DjJoU2DC1PKyWSrGqxJIN7HCEvmG50WSk3Z1VM/8pd58dFu7HHHAInlsE/D5A5byj7JJuN+TpreQmk7zd9CbxwBRvr7m9eSxhHscW0DMkMqiS1K0TZNKe1ScnuAc/BtTSg+CszwACudJg9+sZ65iTVKfdSLjZTXMTlpyetXTT6y/jAlGQNk7Per27HmQGntoTmtgAF7vT9KmhUS7cx4ciSXftuZDFM0u6sFogOSmbmJ9zRmD4aLuQ8jsZbyvpxfydBZPVYF2r
 HVe+EPnj
 y61LguPw6n0gBXXjLZSpLA5ibfzcr0KNYKh6ftPtqF6jysdpi4kGYWEDR67PmVCV34A8pp9s7LQyhrxlfmis7TldM/V0HL4vF0GF11Nd31O8GxUL/WlUlu4lpGZ73neNXBcQzuh+ZI3ddSB7S8tBa8hXfNp7IgYr8r2EOpwH52PbOVssACps+Q63UIRccpzsw1awm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a new DAMON sysfs file for letting users setup the target
memory cgroup of the belonging memory cgroup attribute monitoring.  The
file is named 'path', located under the probe filter directory.  Users
can set the target memory cgroup by writing the path to the memory
cgroup from the cgroup mount point to the file.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index eeb7fdd030cf0..0f6379caf4816 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -756,6 +756,7 @@ struct damon_sysfs_filter {
 	enum damon_filter_type type;
 	bool matching;
 	bool allow;
+	char *path;
 };
 
 static struct damon_sysfs_filter *damon_sysfs_filter_alloc(void)
@@ -774,6 +775,10 @@ damon_sysfs_filter_type_names[] = {
 		.type = DAMON_FILTER_TYPE_ANON,
 		.name = "anon",
 	},
+	{
+		.type = DAMON_FILTER_TYPE_MEMCG,
+		.name = "memcg",
+	},
 };
 
 static ssize_t type_show(struct kobject *kobj,
@@ -862,11 +867,46 @@ static ssize_t allow_store(struct kobject *kobj,
 	return count;
 }
 
+static ssize_t path_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_filter *filter = container_of(kobj,
+			struct damon_sysfs_filter, kobj);
+	int len;
+
+	if (!mutex_trylock(&damon_sysfs_lock))
+		return -EBUSY;
+	len = sysfs_emit(buf, "%s\n", filter->path ? filter->path : "");
+	mutex_unlock(&damon_sysfs_lock);
+	return len;
+}
+
+static ssize_t path_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_filter *filter = container_of(kobj,
+			struct damon_sysfs_filter, kobj);
+	char *path = kmalloc_objs(*path, size_add(count, 1));
+
+	if (!path)
+		return -ENOMEM;
+	strscpy(path, buf, size_add(count, 1));
+	if (!mutex_trylock(&damon_sysfs_lock)) {
+		kfree(path);
+		return -EBUSY;
+	}
+	kfree(filter->path);
+	filter->path = path;
+	mutex_unlock(&damon_sysfs_lock);
+	return count;
+}
+
 static void damon_sysfs_filter_release(struct kobject *kobj)
 {
 	struct damon_sysfs_filter *filter = container_of(kobj,
 			struct damon_sysfs_filter, kobj);
 
+	kfree(filter->path);
 	kfree(filter);
 }
 
@@ -879,10 +919,14 @@ static struct kobj_attribute damon_sysfs_filter_matching_attr =
 static struct kobj_attribute damon_sysfs_filter_allow_attr =
 		__ATTR_RW_MODE(allow, 0600);
 
+static struct kobj_attribute damon_sysfs_filter_path_attr =
+		__ATTR_RW_MODE(path, 0600);
+
 static struct attribute *damon_sysfs_filter_attrs[] = {
 	&damon_sysfs_filter_type_attr.attr,
 	&damon_sysfs_filter_matching_attr.attr,
 	&damon_sysfs_filter_allow_attr.attr,
+	&damon_sysfs_filter_path_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_filter);
-- 
2.47.3

