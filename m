Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AF1ACD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 14:37:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C69186B00B1; Tue, 12 May 2026 10:37:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C14EF6B00B3; Tue, 12 May 2026 10:37:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB5296B00B2; Tue, 12 May 2026 10:37:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8F5E76B00AF
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:37:09 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 533B81C030E
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:37:09 +0000 (UTC)
X-FDA: 84759020178.11.BA17860
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7B09BA0002
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:37:07 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Kr/9bfP2";
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778596627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8yd0YW2MfhryPbHNrmR7FjDXKN1/tNV3/vxI6crJIBA=;
	b=jMvSTkniJqaijwoTdiCnv9Hx8MN5aIDaYjE6QtOXC9ijaW36fXJ0+q9LdTk3frJ6tTkXZV
	kUdLAvQZi51p9/yDzULGMLqmJIiSbE4ziVmbXNfRIkXKeh6MG8pMwntesKH/uT8rDkDFNB
	b/d1BXOosc81XHcwxLGKnLQmSgRGZMA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778596627; a=rsa-sha256;
	cv=none;
	b=ehIZM4H4JjKk8HhcHHWDNSoWjonTolPaX7K1Z6w2MAK9bZ3WDB1VknmAp7cNW00sCEnxHa
	qHnmv1wRDHK3V6oJkHY2hxRoeqUJSwfjc8VgDksidUGr1/gYfAAJd6UxJNu4OVvHrVOyeY
	WJKjGj3ybGaG1y6aUp/oYERuc1zSw3U=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Kr/9bfP2";
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3AD8A44A8F;
	Tue, 12 May 2026 14:37:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0858C2BCB0;
	Tue, 12 May 2026 14:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778596627;
	bh=GgqkpGLzfY3SpgNfpQk0ztstdYxBESX4HneypEejd9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kr/9bfP2XO4lLoz6+fwIsfqfH6XcLg/Aj2lluUEaQ+nNluegiP+NcV/fN3UNckTHo
	 iQseqhKX7sGENACO9Q/XVXxq9IS6a5ya3hcombCh0cxIna3nerr9IEvUrPNM8Yo6xw
	 ae1hrESycAolWrNIIQtxTj3WCDIM1BzAApCM37jZlJAeIjNzKCKNVz/iHpQciufkLp
	 j/uJ7zrEV0YsMZg4XWjGTtDiNqkjGgZb+LYEkTMUgzbVhWfENlgPn8BpENrSPQaqkt
	 hX/G4hHjRO5ZEF+Yk4oM/Taz8LHRkGIttS0YZSAzfbeIZYhI6PBOrv6Pr/hYCcTVy+
	 K/EcSTBsjNQ3Q==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 24/28] mm/damon/sysfs: add filters/<F>/path file
Date: Tue, 12 May 2026 07:36:39 -0700
Message-ID: <20260512143645.113201-25-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260512143645.113201-1-sj@kernel.org>
References: <20260512143645.113201-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7B09BA0002
X-Stat-Signature: whx35thfnbsqaoug3qqfxbqhw83j5urj
X-Rspam-User: 
X-HE-Tag: 1778596627-493
X-HE-Meta: U2FsdGVkX19tBy0/JA2MTkh2hF+fw68mp9tXaAug5tAjlHv7zNFrusDXZ963egb0UeFO/4z4uPdQGOu74yBJGy8uqNIwp61L5EXUmaU2mpHSDp9GgECGmm6nUyFjkv+hfa6zig1TX2Ah6jY6bsioI0c1D/4obftC6oLQguvwJSA1zHbc4mOV5jg6zJ3pklreRqVtbgdBhYIlZI1SHjgzdeH/AsL2fc+oLx8a6Hjx7QuTwwjkVX6seP4l8/9czH48vswnJELIFZ6c9DuIvrXcB+kiNYVE2CY3oPL9mHPqKwMRa8xpp/H5YkF/5nra/JWwV1Y9yBhYL1Ru2J/F+Zo7t+m56zQ468Im+U5NdB1PUV3iYQYXRcqQnXxy9TpJ2mazkb0dWy5JOLQnvUaoOPIt+6t7t5tDxnvfKrZ3QdaF6/X/L/5dgFrjgM2L0PlpFDgX4yIUUdy9jgbE0DmQhYd+G96JptKds5IRRKRJwB0Yro7KwImPjhCaO0ci/qNAyhNb2lhtW9FPfH5Rs8g67TkYmJPALnbWWgOsZcKI7R50PfeuTqZeJjcTY/xyAnKUu0ulH/ttMIvSLeBSiaLbt8lNiUaZxLF0/GZSu7c3rAyPRWREH1EJa+hFbDPHUyegPekvwXwf0qwyajldd7rBVJ7rGNz3VU7Rod8q/Ek/96tyvy95r+yZoBC9qu33jFcJzR/+8Pnetf1zoCXc9sWEEHk0+KPDsJX+2D9uRLZKPcS6/cs+9MyJ4UpiJkG3SxoViG+5A6ZGPp2ltOYbr3jMH9rEdaEwX7LlbnTbQvMVp+VEQVmiN8cwjRRT6TYUNW8ckbF6U7wyEZ0CnqriSKPCSfsJpxoiEe6vP9Fnsn+9uTA0DLrX5VAeId1aUBlhcUKqVCZmu7EPGljEUl9o+okwLWj8wgK27IsdbXwMglcdqYZoq39iJ7FeVo0Zf5DcDUjTrHFJ/++hyK7qCt3aOvd5hAG
 C0tzxmvU
 GYIPiwWz/Q/D/ZKjffrE4Se75L2klJKklH1ngXi/lAc+XYB7xNTiBr9X6vZ7hdz/t6a1t6Fn0HQjDAfzXpprS/bfAjoCat9I3EpzRWODOvkf4OCYDs3qO5s36LuNvJhPK18nTx62qbB8uApYeXpYmz2YBI+REFljGZ8mQpwG5WKei2T1iF5LExlar8e60Hvy6+1KR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a new DAMON sysfs file for letting users setup the target
memory cgroup of the belonging memory cgroup attribute monitoring.  The
file is named 'filter', located under the probe filter directory.  Users
can set the target memory cgroup by writing the path to the memory
cgroup from the cgroup mount point to the file.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index e4dbf85feadc2..2b68e1a7de451 100644
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

