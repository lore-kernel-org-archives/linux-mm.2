Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8A7BFC0344
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 15:03:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36CDA6B0098; Thu, 23 Apr 2026 11:03:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 231C86B0096; Thu, 23 Apr 2026 11:03:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 084856B0095; Thu, 23 Apr 2026 11:03:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E81666B008A
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 11:03:05 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A74551B71B3
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 15:03:05 +0000 (UTC)
X-FDA: 84690138330.26.64430A5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id C852680006
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 15:03:03 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JrEjuLmY;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776956583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JPJOp/8GXmcpgErHx2K37zCT+O9sa9Or7wes3GsbnH4=;
	b=qWVX1IhoCPllEqR9U2Z+qYxXcrhsGLybTPJNNjqyurKhcpVM9HSLQVDZdwo3OEyugFUVeQ
	10B5f5R2PRLPh0tWT6vh+RymS5ydWPXntRo3gw05i4d0j+clUux22R7GE7ewUCB1u5WSqv
	B+ug0qD/mukKDvShb85Z0qq+eVtsqqE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JrEjuLmY;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776956583; a=rsa-sha256;
	cv=none;
	b=2tUOkAXls2cdZbnJoUkfKQQczQ7t2qgItUSMQPswD3cq7Dd6UHIWOj5+MyeQST6vnKbIWM
	Z7d4Lrti5bp28LONvAaEJhUb1dzdHyMzJdpuZpVgRKKOuRpgJcGwV/aycEt1AmfskA+yUV
	oP6Tngk3Lk4/4xqifhyoOKXR4w2QEGo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C05E044375;
	Thu, 23 Apr 2026 15:03:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6218EC2BCB5;
	Thu, 23 Apr 2026 15:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776956582;
	bh=FNV8xQP2YWLDSaMWy27hoOup6UGsYJXN2Gv3gecRBI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JrEjuLmYIS4mWBTUTBGJoJulPraOsKubWUrjeWM0ZikmkxlnLi2QvPIPWUTDmKaVG
	 QTbw2+fu2ftq/9h9E/7L7eTRjXoAVTBtdg6/gf8bdItCHn9ogg+Zk5uiRJNur3ECSk
	 MvCQscxdSQ5Ys/L01MVNp/HN5W56pmwkUStjCtw5j0/GKN8lhpBjba5j5av5F7MPjt
	 EN8zDME6LGyRrdzKuNwRUobqU26TBNJ8g3HTDSw8HWts8D+MDMcw61OYij42u47WZV
	 zLj8TdQxbzOhpWnQjwr+jCInYnA6iZBiDgkzPZPIPjanOQOFvYjdLeiW0y0rTgAkIW
	 RD4hIftBJsYow==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 16 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Junxi Qian <qjx1298677004@gmail.com>
Subject: [PATCH 1/2] mm/damon/sysfs-schemes: protect memcg_path kfree() with damon_sysfs_lock
Date: Thu, 23 Apr 2026 08:02:51 -0700
Message-ID: <20260423150253.111520-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260423150253.111520-1-sj@kernel.org>
References: <20260423150253.111520-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5p9f1aszf7an441mra4bedz6e8791ezx
X-Rspamd-Queue-Id: C852680006
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776956583-673511
X-HE-Meta: U2FsdGVkX1+bw9yvYZKLtTmYaSseZPXEP2DSf/jhv8Rh5ECoA4EMyIPEczKlr3E4ly6kY27aU7vhnJ2SbeB0cjqCNfs9yTDXUnTAkanGPoWUq32EbFBd6xi75diihCt9SdHuFZ6JVRGp0rE3XieVfFjZSb7U76S193PrPzsNxI9yhYkpMiJzXQEva//tt2LFXVz6HSv4xjOzN+2tmcsEj2YSkX+AlsEl3p94WQJAKcjjTdKejcK8fTFQBkOYQlNn8CQMGdRS2jDZ3e/Au9yTbkxjPQizJmUOMZiGl82nNVleOCwYQa1f2tDOwtZF+pFsGDyp4jcQZqwxXHdtgUYykl8eDMi7wBeFt5As9CTZBJs4AOsyCUIWdOqZv1cKpakyTpHM3MPEqZi9mOoWUO8Ral41+TFERqgbEZ/iv4mD81uBKH4w9ha80pHFNgRYmWiyqvql4zQnC63p7m/GsTLKlcGgFJWwoRJoWKi41DcALbAnthBSQObnvejqheXTjVfYrEABFju2dVjpncum4NnvnxtHAe5fyojGsipWjL8DTMhWOB7t/JyeSLvmUvOMyruRkTnSij7+UKH5nlBgBIHGbJYc4B6hbkbGfonTZb6ueEUJ00lPYxux1ZYYu8ALZ2PxXzpperF5cYh01grGIu7yM4BykAFcV3iyG/Hwmm5ZmuuJh8cxvRHhk1f8LamS1UHhHJVSEJowqR2eI0lK+g5xmDWdbjQ+u6+3CnR1JpGx7zIboynwAZZhI3BY/tLfeW9RmiVJ/Y8wtOc35sJw3eFfPFJZNW+zP2N7Wzdvay3IfGxoFLf57KqaWjYcaWCnDCCLIcgZNxILhRCvAUn/gHjg5N3iuxnrsfjvSRvu8/xh3WfnayaLuXZR08scTpNN1Z183O3zbPQGv865xD1BATd7cJddu/QmNLebfy2kYcCzi3NQ3Km0L2cH0bC97J9a/njBE2xHjyv9ba0KMoD7gXP
 ds3zGMx9
 Fi0vSbXknDNNRsc+zZ3iL92fPyEFoFqvauH4ZAvlIQ1lKz7bRhxbbxOcrNJVLjY2oERVZghT18r5VXyZN2ny1TiYuHk37ouK5YT7Re8hCbTg0vBDt9qSV933SdewVYYsb3y9GiWslKdoIe++KcDHsA+Cwkb8lPp633v4rRlfreA8+YDkGKPZdAB1+ZzEyE2zPufCgSGLIy/5HvC1DYJUSUA0DtCep+WD34/fj7ghdeg35Atdri4nnjong/Ji+x9wTRJjDeMFpqTFrr59UCUnEZPxhASlK0SdTcYTtqfmQwkBjroI=
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

