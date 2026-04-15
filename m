Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAE63F9D0F6
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 01:21:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E99006B0093; Tue, 14 Apr 2026 21:21:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E21856B0095; Tue, 14 Apr 2026 21:21:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4D376B0093; Tue, 14 Apr 2026 21:21:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8DF076B0096
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 21:21:00 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 32A8158122
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 01:21:00 +0000 (UTC)
X-FDA: 84659036280.05.8D2720B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 644DA140002
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 01:20:58 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aK64Gw2u;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776216058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8dYXSnsy3YgKkiYK2k8BEGYVs6F8PwUlTNDUI2oZeWg=;
	b=NNhDDCvSoPk/iBNMRH0Vi3JlJ0hMUSjTgRK3WNqXeQv0cLAqVJmatPEd7QGssS/gycU30M
	UvOsjcqxzlqgTB9iYaWhuS4mEGP+FOVfGAVgOizArwshmXDvU6/ZFr8NkEw/uNaELiUMCU
	eam5DerAJWmHPHqpBb0SQWey9k9M9lQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776216058; a=rsa-sha256;
	cv=none;
	b=lfLJCad/XTYmc2/NOCj559r/tsCOlTpLQlVcB1E5Pe66y+slwADG//LelKyHVNjOLlxQBV
	m13xVSXhr/Vo3MDdRiyNdT8VMTb6rHZLKW4uW6Yc2LKoI03pdmNaDo/Py/vcHkCxBPB3/p
	Q9eWCqZa5bk+GQF0d8KVmWOcw3U1Urg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aK64Gw2u;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 245A8444A4;
	Wed, 15 Apr 2026 01:20:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD95BC4AF0B;
	Wed, 15 Apr 2026 01:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776216057;
	bh=9rMAkySwPwOzbR0wIgkJ8MpOnAl8M9axmSlqMcxmgDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aK64Gw2ur1hChS7ihUc5Z+ZtOlcOMO6rKxfPpk1x12xYtp19gCrx5YtOmmiBtsPLK
	 Nqfa/HwiNAbxNJge6BC928eI8Xc+Q58dLxSglm8rjoRI/Q0VzDq5xkrIa/gEO/Ubde
	 l8XKuPG8BsYipTEhAL6hqA/zB1rIyBUhkdlvhJ1AhokMkEbgtx5lmuI3LG4/jKUq9z
	 ezcuoQVS0T6tB+Q0hsPVTC2KFJidYWEnPxw3QxLYf5NgjD9Yih2CXxndfAnxqnLd+k
	 Gd6TIaEhRv86iDjoaTWErgw12wq+oISGaWy/z7ebg5f382XxNZ6wTKYOVlbm0jcSxw
	 zMZ31oUofRvSQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 1/7] mm/damon: introduce damon_set_region_system_rams_default()
Date: Tue, 14 Apr 2026 18:20:29 -0700
Message-ID: <20260415012048.76508-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260415012048.76508-1-sj@kernel.org>
References: <20260415012048.76508-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 644DA140002
X-Stat-Signature: xofi6e7aifbnao3dnb9p555uy8hkp4hk
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1776216058-149586
X-HE-Meta: U2FsdGVkX1/iLtNCKb4NUGKERuP+i/FXydVIXWnTWPK96xrkWDatByZtVnBwZCXbZJpoWug0CjYh4ZPYt2axIi41HegdqDPgZomeUUvC2l6+QmhW8z4RLzQv5hJ73hsADm/JrXRD6EkdpBml1P5RlvyhH8x8c3fGzPIN5VHldY2Jb30yPjmvE5rjHL0OWqWPwV21MjJVUzCqIG5lV7nvCAnaj663Gn5OMdbFTsAJCE6l3s4JPGju3gwwfyjxqaRGJmawGQ9q7iRRMpdbkfQVbf2MDRpYx1W+EolHlcCUfHBPyrE7IfXV0O+57MXOWMSFk5oDT1Uf+t62atnidT/1NwhjQ6cZ4IhvA7Zvc7x3HJG5aK0q0/spI3tmxIr+zpE1wuh2in2uQ+gpxigPQ0/dThJTR1n5RI0vyq3OQJmJXYkNVmM5EVB9QgNT7FOwTCyQvO42mqN9MdwiNxZLy2XfVQlVZadVI4jU5C6YbvvgDQfYG6OJ3lE4f93YkfVgSfF87/WXOG9dtBdLwDt47rxdAyYSTDiF0YCV2ioomBAV+bxTA2YAevzQwt+22w3R18hvIC4PtVVHTIxz24mL+H7jYBL1yOAUPEy7mCCXkEaOVHcrYYfVREhT1OQvEejviviZShjWwbKnBafbbnUDWizDggwnKuRUz2VKTWrOlhIeeme9Gb0/rUxWWB4X8xCTTojAKKX4RLl2kMUx48DXYLYn49/beseH+XrK7uNTG87y7MCVS1p8eR20eZPdiw3tHpygRp/YNgN812+zQGEH5e5nc98AYamOaiDDfQaopH1WGNVVEgEpWxiT4FCVGo68f/Rh35E+j+NsAPHdu6kKXsE132OSyzh6YOzQU/n9SS6hEe2RJ5hl9pDG767/IAvMlSYC/FvC435nrEGnOwMQAvA+B0dGq2J5QHU5pPVEZ3kTUZWfAP3ywdkDC8Q5B1yR/kDfSfAljfVb9UBBRTGdX3h
 ETZJzvUO
 DrvqnSb1pSS214jcndaKdoaCxxZVBS5Zjrarc7KzKa19o4zzDG18wfn6r3hQ0Re762pTzf3urd+rWeBBuvU03tZfriFTvrHBfFXvu0feIr2aOd2bSfNkEN5oqwHaKvWulYRk5sJnJACU7AJxtyQ4yxglEt2T9xbddpPUmGeF8zLurjI2QhzLiOViT+oyXuPBMrj4rqbo5MrPSjyjhunVmHU4hiZ0V7/LvizEKfb3qyS0lDKAihy0cew2fYkSLKiS1Ypx5uvWLANtFmjz7FoP8DDVOgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_set_region_biggest_system_ram_default() sets the monitoring target
region as the caller requested.  If the caller didn't specify the
region, it finds the biggest System RAM of the system and sets it as the
target region.  When there are more than one considerable size of System
RAM resources in the system, the default target setup makes no sense.
Introduce a variant, namely damon_set_region_system_rams_default().  It
sets a physical address range that covers all System RAM resources as
the default target region.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h |  5 +++
 mm/damon/core.c       | 77 ++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 77 insertions(+), 5 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 5fb1dc585658b..c4cdaa01ea530 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1007,6 +1007,11 @@ int damon_kdamond_pid(struct damon_ctx *ctx);
 int damon_call(struct damon_ctx *ctx, struct damon_call_control *control);
 int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control);
 
+int damon_set_region_system_rams_default(struct damon_target *t,
+				unsigned long *start, unsigned long *end,
+				unsigned long addr_unit,
+				unsigned long min_region_sz);
+
 int damon_set_region_biggest_system_ram_default(struct damon_target *t,
 				unsigned long *start, unsigned long *end,
 				unsigned long addr_unit,
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 48633da449104..3cef74ba7f0f4 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3186,14 +3186,20 @@ static int kdamond_fn(void *data)
 	return 0;
 }
 
-static int walk_system_ram(struct resource *res, void *arg)
+struct damon_system_ram_range_walk_arg {
+	bool walked;
+	struct resource res;
+};
+
+static int damon_system_ram_walk_fn(struct resource *res, void *arg)
 {
-	struct resource *a = arg;
+	struct damon_system_ram_range_walk_arg *a = arg;
 
-	if (resource_size(a) < resource_size(res)) {
-		a->start = res->start;
-		a->end = res->end;
+	if (!a->walked) {
+		a->walked = true;
+		a->res.start = res->start;
 	}
+	a->res.end = res->end;
 	return 0;
 }
 
@@ -3210,6 +3216,67 @@ static unsigned long damon_res_to_core_addr(resource_size_t ra,
 	return ra / addr_unit;
 }
 
+static bool damon_find_system_rams_range(unsigned long *start,
+		unsigned long *end, unsigned long addr_unit)
+{
+	struct damon_system_ram_range_walk_arg arg = {};
+
+	walk_system_ram_res(0, -1, &arg, damon_system_ram_walk_fn);
+	if (!arg.walked)
+		return false;
+	*start = damon_res_to_core_addr(arg.res.start, addr_unit);
+	*end = damon_res_to_core_addr(arg.res.end + 1, addr_unit);
+	if (*end <= *start)
+		return false;
+	return true;
+}
+
+/**
+ * damon_set_region_system_rams_default() - Set the region of the given
+ * monitoring target as requested, or to cover all 'System RAM' resources.
+ * @t:		The monitoring target to set the region.
+ * @start:	The pointer to the start address of the region.
+ * @end:	The pointer to the end address of the region.
+ * @addr_unit:	The address unit for the damon_ctx of @t.
+ * @min_region_sz:	Minimum region size.
+ *
+ * This function sets the region of @t as requested by @start and @end.  If the
+ * values of @start and @end are zero, however, this function finds 'System
+ * RAM' resources and sets the region to cover all the resource.  In the latter
+ * case, this function saves the start and the end addresseses of the first and
+ * the last resources in @start and @end, respectively.
+ *
+ * Return: 0 on success, negative error code otherwise.
+ */
+int damon_set_region_system_rams_default(struct damon_target *t,
+			unsigned long *start, unsigned long *end,
+			unsigned long addr_unit, unsigned long min_region_sz)
+{
+	struct damon_addr_range addr_range;
+
+	if (*start > *end)
+		return -EINVAL;
+
+	if (!*start && !*end &&
+		!damon_find_system_rams_range(start, end, addr_unit))
+		return -EINVAL;
+
+	addr_range.start = *start;
+	addr_range.end = *end;
+	return damon_set_regions(t, &addr_range, 1, min_region_sz);
+}
+
+static int walk_system_ram(struct resource *res, void *arg)
+{
+	struct resource *a = arg;
+
+	if (resource_size(a) < resource_size(res)) {
+		a->start = res->start;
+		a->end = res->end;
+	}
+	return 0;
+}
+
 /*
  * Find biggest 'System RAM' resource and store its start and end address in
  * @start and @end, respectively.  If no System RAM is found, returns false.
-- 
2.47.3

