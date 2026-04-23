Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5FDCFC0342
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 15:03:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62B2A6B008A; Thu, 23 Apr 2026 11:03:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DC216B0095; Thu, 23 Apr 2026 11:03:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36AE16B0093; Thu, 23 Apr 2026 11:03:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0E87C6B008A
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 11:03:06 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C7A741B716A
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 15:03:05 +0000 (UTC)
X-FDA: 84690138330.28.5F67065
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3563C4001B
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 15:03:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bPORGTu8;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776956584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Z1nFc1xWCFJrudUlh6UpulgaxT7O9I8PMUdERu/vE4=;
	b=shGZ32TY4OZ1UTqvoXGB8ZmENem2hF/qrRO2+HOyPfPkxN2PFvPNRGswVK3QP3DDEd8O8G
	1atntkkY0rvkp0qKZBsjf1DK3Ia3OqmPHK3W7fN7wsUJeaBXhmOSHDC8ueS15Y+NBLjc5H
	pcm5xWAskJPpkqpaPvPpuZMTKM8dbrU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776956584; a=rsa-sha256;
	cv=none;
	b=ioW1+RqvlsWixK/HccDQQ6cWGfwfH4pVymViZ2RnGu0gq1xpYFq7oU5v/FJnEC4keOgZEb
	hwI7j+9NDgRtrWtt496xh+RFI//U5UKDo0I2GB9ggdQaiQEru/wKkttFMbwI/6VnGTB/NA
	exTxm/fvuxSx4MRQCzcq/zdKQEMJp7s=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bPORGTu8;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 57C6660582;
	Thu, 23 Apr 2026 15:03:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C76B9C2BCB3;
	Thu, 23 Apr 2026 15:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776956583;
	bh=pgIYrrAK6X9JUhNoZ3jKTnGdrjt9Atw8Bt+OO+9uPx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bPORGTu8YrJGGYX+HnAjs4fhHzD34EJaP8VvY8cmPf2H1h2K+ynmjdiqsDJRpNLx3
	 oAm8LmDxiObij537YgRsVv9oM6ALhzLZkIQDw1MEvXIvNKegud7BicI9LVHanw4j7R
	 3t2gL/IrQucxdYlwOPIdTfmG1QMwtO6BtcCK1qYkgnmzXqXjInGFKvYrEhKnmXyCyH
	 1ZaFAbhm8Ku55oGUt7sPh1Bc9RRftEt7WR0RJUwyCPEkJCbaEisbwjOAlB55phTjfx
	 ZP00VagCX+shexDpBGPApTmnSfdHaW0XBr33sR3yM7T8Ucy3gX/c1EwD3zf2KJV69W
	 mA0XhtYkvvv5g==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 19 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Junxi Qian <qjx1298677004@gmail.com>
Subject: [PATCH 2/2] mm/damon/sysfs-schemes: protect path kfree() with damon_sysfs_lock
Date: Thu, 23 Apr 2026 08:02:52 -0700
Message-ID: <20260423150253.111520-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260423150253.111520-1-sj@kernel.org>
References: <20260423150253.111520-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hrcgof6exwgt4xameu764orzqf7qkzum
X-Rspam-User: 
X-Rspamd-Queue-Id: 3563C4001B
X-Rspamd-Server: rspam05
X-HE-Tag: 1776956584-527757
X-HE-Meta: U2FsdGVkX1/8ZAzVjn069k44YtTOqaQpwjgQbln9O7NtR902+otR9Ux2eX20u4aewn0NeHOTNpFaUWOlHBJhmusXNd3kmQEGf5E/ZiFta3Xt9iazRdKbV1qyE3I10AKQpQCHf5JvjB+rQe+fy9RUGQu85cnUJ6pG+1kbE5dSzqzytXZkS24XIWfSG9+0QTlY6avwKpIJmGmFkERJVeya8jpQIRvWvJ6d3uePjqmASbIRLXQbqt/xU6ORzhQQi2hr1KrwN7NIUCBVmI4XLMgM6qzsP4nt9s7zNKBT7wBvLvN9bcd2QFq3pgoAbL4XW2kvq3xsdc2r9wAFyewdElAFSFdGlsT3aG9eTmeMxGISaQzy462pi00V6X5JAo0kYgbaosWmCQEbiRPOiw7mT5kKXO37lQfH423dtRH2A/KILE5S7vxvowCofYH04Brc3X89p6Q8ffohEwFe0/tN1sCUHl6tzBwePU2BZ9V9dVI40PEr4AOC3dfTs1mBxJGTek5J+8CGhJS7U6w3lgFEQ24VY1TBylWIq4iQCPn1b3nai9hcxlakuQ5+7ObF1ZaHLWqB5bJBTI8qKdS9J6bogoOkeN7GxKcu/IgKPY2kzec0M0ORQuL/SSJZKhQeuOinA0usYn1t00NEEg9pQsDlHePDOm+mrSKzsES4gJ83xJwuwgfQOG/PRWyP5EDBRW1QBFamIwW7bes/lPB6wGzuoiVU2x47Rsyqd90Sv7Ttf0hYgrl34xcNOEYZgeun8uotO/sVqHLahgNcg2AHO7Cfill4jn6LCFpNhmTW/tmlQkgizSrwYigYNyyE+NBF0jus2xUGoXvunPodaB4NMbh4L1thWjXPgW2PFHJe/yiWwyyo59wCetV/nCz5r55yTFWnklg3qP4G6CuBiZ/JMFfb/9071aZZpJdNtFNwjwtSraKAGOq0OeKNzMFtmdeGVWnpST/QYfesf8qBymvCZjNuVNy
 yPhoyant
 RpxKmf3ulXusMKbKOjTE/L43Z+NCAcZIgtXwqmXMnzWIa4lUMAdiJnXXWnljNdQWliC2QP1vIQcctBNlPwc/+X074lkzsXF5SeinLXzDGh2C4dgOuJHbpzzr4YTGIq/msqdqm/z0hD0HL0E2w27mtFdQOBr8s/aWW3DFBGvQJ3NQf+hKSkZSRIJO8u/hccXgDf7f871tVOJDDvVJ7ZA2knK2fGElCNdg6kuy98Zkd/5/oEOJ0u7zN4PSoKfDBheUi9hoWsO0XVknnru9ubT0ihfsuzC+RHlvvQvDMefNieY2SJt8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_sysfs_quot_goal->path can be read and written by users, via DAMON
sysfs 'path' file.  It can also be indirectly read, for the parameters
{on,off}line committing to DAMON.  The reads for parameters committing
are protected by damon_sysfs_lock to avoid the sysfs files being
destroyed while any of the parameters are being read.  But the
user-driven direct reads and writes are not protected by any lock, while
the write is deallocating the path-pointing buffer. As a result, the
readers could read the already freed buffer (user-after-free).  Note
that the user-reads don't race when the same open file is used by the
writer, due to kernfs's open file locking.  Nonetheless, doing the reads
and writes with separate open files would be common.  Fix it by
protecting both the user-direct reads and writes with damon_sysfs_lock.

Fixes: c41e253a411e ("mm/damon/sysfs-schemes: implement path file under quota goal directory")
Cc: <stable@vger.kernel.org> # 6.19.x
Co-developed-by: Junxi Qian <qjx1298677004@gmail.com>
Signed-off-by: Junxi Qian <qjx1298677004@gmail.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 8d32a20531d49..245d63808411a 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -1197,8 +1197,13 @@ static ssize_t path_show(struct kobject *kobj,
 {
 	struct damos_sysfs_quota_goal *goal = container_of(kobj,
 			struct damos_sysfs_quota_goal, kobj);
+	int len;
 
-	return sysfs_emit(buf, "%s\n", goal->path ? goal->path : "");
+	if (!mutex_trylock(&damon_sysfs_lock))
+		return -EBUSY;
+	len = sysfs_emit(buf, "%s\n", goal->path ? goal->path : "");
+	mutex_unlock(&damon_sysfs_lock);
+	return len;
 }
 
 static ssize_t path_store(struct kobject *kobj,
@@ -1213,8 +1218,13 @@ static ssize_t path_store(struct kobject *kobj,
 		return -ENOMEM;
 
 	strscpy(path, buf, count + 1);
+	if (!mutex_trylock(&damon_sysfs_lock)) {
+		kfree(path);
+		return -EBUSY;
+	}
 	kfree(goal->path);
 	goal->path = path;
+	mutex_unlock(&damon_sysfs_lock);
 	return count;
 }
 
-- 
2.47.3

