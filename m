Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45F12F9EDE8
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 14:35:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75A476B0096; Wed, 22 Apr 2026 10:35:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D1916B0095; Wed, 22 Apr 2026 10:35:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E78E6B0096; Wed, 22 Apr 2026 10:35:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 35D376B0095
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 10:35:11 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C3D091B6F7B
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 14:35:10 +0000 (UTC)
X-FDA: 84686439180.23.1845D4D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1E46D40016
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 14:35:08 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BTl9YSb3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776868509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JPJOp/8GXmcpgErHx2K37zCT+O9sa9Or7wes3GsbnH4=;
	b=GCPSvxJBdrQZqdbs9YsHrQmNLx45vkv/02GsXugtfWJ86/T9kdBzLN8aZ3q0p2jsc5IjxT
	HEzyfzEi4AJ1YJvY5ciOEPFNQB09jiOPx3GrUmkOJSMe6CloBTEwkFXeN35d+G6LJGVBCe
	YE8XK3OPcYJ9DWlf22FRGjcACYWTCwQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BTl9YSb3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776868509; a=rsa-sha256;
	cv=none;
	b=E3GSzkqqa38rBTEm0P7GHat6/LaTKwolpwnxhJxTMqyf6DPpEHLxg97Izll3mLfSpsa+YK
	+rMQA4d2MayB4ODyN8RI79RBktbCR0rg3UBY7DRYNCUrgJ0B4yDDahLSiZJiTVHHvKqW/Q
	pNzWRxGL1QNIn4E2Iuh2ApYkdhj7iVg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 98AD56132F;
	Wed, 22 Apr 2026 14:35:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 154CFC2BCB2;
	Wed, 22 Apr 2026 14:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776868508;
	bh=FNV8xQP2YWLDSaMWy27hoOup6UGsYJXN2Gv3gecRBI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BTl9YSb3eStnRjxhY7G8tc98WLX7BdWmhhOplI3i4Is0uFIMa+SYCogu7USM0q7aE
	 7MUaLhKdkIodqU8mJoK4Fm63Aj6I12yevY4xTszrpOdR/qlXI96B8I91VUhsPa/SZE
	 nDTpH7XBrG7roXNqejS6c4bSYKWA66eswR7SPTjPp/s8iiaKByllqAFELU0TpQZ1uS
	 y1YzEx0YFELC8sqpRpMrM4vZnuX8Wzt6ODj1k8uaAeqQMUfe5QUu/6bmDe16YbEzz+
	 Jzht0sSOLeIpt9lHSr0i7r+vLpPpMU07546RHlb0BnbJGcKWoymnAIUnLtBUEtPU3c
	 yEOSNVlt9yaLw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 16 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Junxi Qian <qjx1298677004@gmail.com>
Subject: [RFC PATCH 1/2] mm/damon/sysfs-schemes: protect memcg_path kfree() with damon_sysfs_lock
Date: Wed, 22 Apr 2026 07:35:00 -0700
Message-ID: <20260422143503.71357-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260422143503.71357-1-sj@kernel.org>
References: <20260422143503.71357-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1E46D40016
X-Stat-Signature: 5wy4pkfr835u8u14g86yeugfp9uz96yf
X-HE-Tag: 1776868508-136454
X-HE-Meta: U2FsdGVkX1/9eca2t60k4Rkqc28mqub++he8OJIh0M3kYHdyeY4eNWKhSvL4UY4yy7UcYf9p910255TZAqK1+goKWTuWzv546LoeiA6BWBUy+lQl5ROP9PRm2zOIuMVWCjzBq994AmwbrkDx5j/GKQ36skiewG0J3/0hO5f4RMXfTK7hiaAXZbR8hnvY3N1P2VfJHESQsT0Wv4mcqCyiWnwMM10UQRq6RHsAG6a1XPbSYKrLXASfQaskYe27O1kTlgcXOqPnbFr7hHamrBpu1rtndxhsx1e2dz0OMRrY4U2u7AVatoRFS3MDTEH2SPERKLkYgX8bAV26tu7ITBXG45Q6o7WigWyh9lQP07VJ0ZQKEPq8l/fdB5eVQaRC/nFUSe78pzxR2nu0YIbvtV3hzIB6ELES11GRPRWigxYvWcAnaSd0K4tAr1TtoMEGTlhNVVFI52zVkqX8jOykt5OrlNVSs2HrbFki79nJH5iiKhT6PCg0kur3wfmH1jroQQo9LkgApz6ZzDywA7khL6ymQG+ZxFarw5aoUKQ41tj9Ovr5fvU+I+PQexdm5+xKxIqAdAa169cI2d6ZzCZct2rhZRSaycUV+lyyDmG6k2ZqTcByrA5WT0BiasBqznBe+w9IGCc/95USrHn+S1YV1dQu4UPoxIxjQStCilTON76cfhQJLqu28fYeP+l9n1IpvEWxMpCJ+PN7zFaeOvF0PnqMjcoK0GRNwfm4zyBPsuHBMeRq6jLDrTJ5ag/7pB7Zf9mPY2B0Fy+ZG5jwxxFLRx2SAOnZjCSxLAXBYURSchxzCff7gGxWkLjSARDknYUCG7AdSZlfc6LAtEQndEfvaV0uJO+P56iWu/maSPpEXYnXAN24cpajQ62Re9CmHIxLMakdE8UyjHtCDkR5H3n5yiWDXqDlSYGnZJ+16SsOTm4gr47joB9dGBgHWzoYQriMq1jrh7oOnJawLrBKtHhZFRk
 ySBhjyG8
 8f/8gdl2tn/i7NnE8pO4CxUicHIKjIJ5F9Y6MKRKMswVZpc58A8HnSYi74/hyuS8RreBafot1QTf7CD2UOHqwcXiwc46cBE3H2NJyBEi7UB6gTtg56q7dR5F0bKbqaz++Zb0lRKl5b723gfwuhAyadiUD56QZIwFRh8CfKwceVQO9blc8f5qJCEqlUuEVExxVLkK9Qqob4ikiBC3b/+SzgbQPQ5bvoVbUvs6i9e5F1nUTGz/2k9AuEQhZfTcgpC4AhuRH6lsAO3Dpd9R2rLtWM7xCmhJeLfSx6UnC5eH7KM+PGww=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_sysfs_scheme_filter->mmecg_path can be read and written by users,
via DAMON sysfs memcg_path file.  It can also be indirectly read, for
the parameters {on,off}line committing to DAMON.  The reads for
parameters committing are protected by damon_sysfs_lock to avoid the
sysfs files being destroyed while any of the parameters are being read.
But the user-driven direct reads and writes are not protected by any
lock, while the write is deallocating the memcg_path-pointing buffer. As
a result, the readers could read the already freed buffer
(user-after-free).  Note that the user-reads don't race when the same
open file is used by the writer, due to kernfs's open file locking.
Nonetheless, doing the reads and writes with separate open files would
be common.  Fix it by protecting both the user-direct reads and writes
with damon_sysfs_lock.

Fixes: 4f489fe6afb3 ("mm/damon/sysfs-schemes: free old damon_sysfs_scheme_filter->memcg_path on write")
Cc: <stable@vger.kernel.org> # 6.16.x
Co-developed-by: Junxi Qian <qjx1298677004@gmail.com>
Signed-off-by: Junxi Qian <qjx1298677004@gmail.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 5186966dafb35..8d32a20531d49 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -533,9 +533,14 @@ static ssize_t memcg_path_show(struct kobject *kobj,
 {
 	struct damon_sysfs_scheme_filter *filter = container_of(kobj,
 			struct damon_sysfs_scheme_filter, kobj);
+	int len;
 
-	return sysfs_emit(buf, "%s\n",
+	if (!mutex_trylock(&damon_sysfs_lock))
+		return -EBUSY;
+	len = sysfs_emit(buf, "%s\n",
 			filter->memcg_path ? filter->memcg_path : "");
+	mutex_unlock(&damon_sysfs_lock);
+	return len;
 }
 
 static ssize_t memcg_path_store(struct kobject *kobj,
@@ -550,8 +555,13 @@ static ssize_t memcg_path_store(struct kobject *kobj,
 		return -ENOMEM;
 
 	strscpy(path, buf, count + 1);
+	if (!mutex_trylock(&damon_sysfs_lock)) {
+		kfree(path);
+		return -EBUSY;
+	}
 	kfree(filter->memcg_path);
 	filter->memcg_path = path;
+	mutex_unlock(&damon_sysfs_lock);
 	return count;
 }
 
-- 
2.47.3

