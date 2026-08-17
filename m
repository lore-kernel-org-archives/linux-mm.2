Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46A7BC5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 09:04:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D8816B0915; Mon, 17 Aug 2026 05:04:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 588C16B0917; Mon, 17 Aug 2026 05:04:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49E2F6B0919; Mon, 17 Aug 2026 05:04:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 248BB6B0915
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 05:04:17 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B2B4C1C1A79
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 09:04:16 +0000 (UTC)
X-FDA: 85110174912.16.2230E44
Received: from mta0.migadu.com (out-112.mta0.migadu.com [91.218.175.112])
	by imf03.hostedemail.com (Postfix) with ESMTP id AFFD52000A
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 09:04:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QqPt6gjB;
	spf=pass (imf03.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.112 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786957455;
	b=fFLfws6HTRn7d97WqvaD7mo9h/ABBHK6n21jd2SBa2ShDPNeLEvea5MgET4hLb6jUyehQ4
	NdToQSId/LJEGUkobSSHCdv8JF3QLaDsb46jbcON5RZPjRZuSnsK0bPSIFdorJmssIrbNR
	c2Xn97CsaRjtnKnmwp1NorlfK5O+TWE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QqPt6gjB;
	spf=pass (imf03.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.112 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786957455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L2YCBKxsxUrj1UZmZgy4NZeVYVhYZvjsCzxGSL9qty8=;
	b=LViSMS3E0kabtGC4sqG7vjVKcuhiV/NpFW9rv9mPjWz47fbtGsfzQJg6NwVQrx3C9Qiilc
	T/d5IYdkkqLueLrzVb/IiabWl/tjkOmbqn1ygX3QDKHCWF9O/yiG1Drw/Rz3e9evPnvQbO
	puVkxgsY/RL2QgqptBHLjAnbgI8y+rM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=4HvbEK5AaZcVolE2fkN6dQN+XhSrm7WBGVzfwAP6N8A=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786957451; v=1; x=1787562251;
 b=QqPt6gjBzlqBbblLyKD4ZPuzEbHJpkFE0FpaFYXmZlGue5gs/q+TVMYvsNNOEcAvr+aiQWya
 txPiP5XAkK5NJO2IL2kGWUXJDoiGE/ROXBYkQ+0lqon5RhfSe5cFxbhYuzE638e0opYxpNkg1ug
 v0jrOxOi0nJMcODy1UGslfm4=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost.localdomain (221.194.171.228)
	by smtp.migadu.com with ESMTPS id 85f26d1e2c6e61b3;
	Mon, 17 Aug 2026 09:04:11 +0000
X-Migadu-Flow: FLOW_OUT
From: Qi Zheng <qi.zheng@linux.dev>
To: hughd@google.com,
	baolin.wang@linux.alibaba.com,
	usama.arif@linux.dev,
	brauner@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v4 3/4] mm: shmem: move unused huge shrinklist queuing past the truncation check
Date: Mon, 17 Aug 2026 17:03:27 +0800
Message-ID: <17fcf64faec0dfbbe6cf8a97924e3f39cd3c51a4.1786955972.git.zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1786955972.git.zhengqi.arch@bytedance.com>
References: <cover.1786955972.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AFFD52000A
X-Rspam-User: 
X-Stat-Signature: ptxdxbxgau3qgc3yg5mu6pbytyuw458a
X-Rspamd-Server: rspam06
X-HE-Tag: 1786957454-780146
X-HE-Meta: U2FsdGVkX1+eIUJNLi5yn31og6culdooWXKFwkNyeqwnYT1TGJg09FdWRhyIt8b7/sUAdt2Da6Dtz9ETEqHUC2KrZPB6abA+gJRJUKBWDsqn9af34IV9ebOYDc/MpLkkcfIK6bD5l5Glk5qyKLevZTYQBr/Xtw7VSRAt73k8nUEN+2lQUwSgZ+8wpc3GKPLsSeN9Gs+9Njh7V163O+e+SQoNYdLgHOAKiVQ2DxQBwaJlhnBR99Po4xZ3Fy6aHO4iPbZSskwOJmNHUkQ+FsM6lFbP6765QfGbeXZYyu0Aw2wUktHj2CJl1L8KUu5MEozBKyUnuUuT+NddnClOtxy0TW0gOJ0c4tEMiADGiZ65xhJBhgFhWeHwu+Ma4kAegQcgJbRDuZVkZ2LSsWGnlaFx3XtIEDghZ0IDbQMDh0pPiw91Jku99DPiYGf0WphLf8a/73Bsl5gjnGBsN5j8Di6HosBc+Q619+L2ZKZuMRbiqj6Zy2u0pkDJe6ojOhm+LDxMoE3FGSfN9147/amweqZaOJXMOBdqSQvoR3USHFyNsr1NLIqK5qJqNem/JZzTUExDRb9BwC9Y8epaHy8IuLkwD/rJBpgsy9Wq3ntD7rvkTT9AJuMfQbRH7xmVPAeURY4fRZZWgR2uLCR7w6JHzG8eNAawUVt1xqJgIlyvFOoSvNTL69bTJVGNY0OypRKM7DOAS+ICN3H8k75sJmLHJYeOfZRsUmuPjL0NNNuPyMjofYCilJoHTfAPI5Nn4nzKueQ4x5VFEc2rxfJwX9d2Ws39tpf3YaWnf6Clwyx+sDCdViAXKOVe+UUXNBeGFi05s5s1ivXItcGtLVwZKoFirdljo0XSNr2MCWHUt4qxU77JxAMS8PQF7+64kluOZMsl/C1XtEPbCNSDwYabjo13S7E1v0IJ2qixbXh7zXfo8PR3aq0mEK6fK+17fXBoXN5bwdL3GCo//nJ7pBKSud7yx0m
 h5viEuEJ
 QJfssggn/xXUIAoBChjODY0XH8lLUhWtkputTyv+vGpApnARQAl6EeR+9jC+BWhhAKmQDkiahUfwnpKDvnAA7FCGSMo5zi4A9cQ6w12G5E7NzH4c4F9CLjrAhnXu3THyjjb8vzRbqkzNpd1h/FbakOkv7ZfVcoBFu61aH+dJvDioNpnDpolZF+uKbeydLtr6OFWmPigUFGGpGlMN69Ok4CL+Wjryy8TBBWOjGEqIB8a38Jjo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

The shmem_get_folio_gfp() adds the inode to the unused huge shrinker list
at the alloced label, but a subsequent truncation check may still fail and
remove the folio, leaving the inode on the list with a stale folio.

The original code works because the shrinker re-looks-up the folio and
drops stale entries, but it is cleaner to queue the inode only after all
checks that might remove the folio have passed.

So just make the pure structural move with no functional change, and it
serves as preparation for the memcg-aware shrinker conversion.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/shmem.c | 48 +++++++++++++++++++++++++++---------------------
 1 file changed, 27 insertions(+), 21 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 897fa2b61346f..81eff314cfab8 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2536,27 +2536,6 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 
 alloced:
 	alloced = true;
-	if (folio_test_large(folio) &&
-	    DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE) <
-					folio_next_index(folio)) {
-		struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
-		struct shmem_inode_info *info = SHMEM_I(inode);
-		/*
-		 * Part of the large folio is beyond i_size: subject
-		 * to shrink under memory pressure.
-		 */
-		spin_lock(&sbinfo->shrinklist_lock);
-		/*
-		 * _careful to defend against unlocked access to
-		 * ->shrink_list in shmem_unused_huge_shrink()
-		 */
-		if (list_empty_careful(&info->shrinklist)) {
-			list_add_tail(&info->shrinklist,
-				      &sbinfo->shrinklist);
-			sbinfo->shrinklist_len++;
-		}
-		spin_unlock(&sbinfo->shrinklist_lock);
-	}
 
 	if (sgp == SGP_WRITE)
 		folio_set_referenced(folio);
@@ -2586,6 +2565,33 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 		error = -EINVAL;
 		goto unlock;
 	}
+
+	/*
+	 * Queue the inode on the shrink list only after all checks that might
+	 * remove the folio have passed. Otherwise the inode could be left on
+	 * the shrinker list with a stale folio.
+	 */
+	if (alloced && folio_test_large(folio) &&
+	    DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE) < folio_next_index(folio)) {
+		struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
+		struct shmem_inode_info *info = SHMEM_I(inode);
+		/*
+		 * Part of the large folio is beyond i_size: subject
+		 * to shrink under memory pressure.
+		 */
+		spin_lock(&sbinfo->shrinklist_lock);
+		/*
+		 * _careful to defend against unlocked access to
+		 * ->shrink_list in shmem_unused_huge_shrink()
+		 */
+		if (list_empty_careful(&info->shrinklist)) {
+			list_add_tail(&info->shrinklist,
+				      &sbinfo->shrinklist);
+			sbinfo->shrinklist_len++;
+		}
+		spin_unlock(&sbinfo->shrinklist_lock);
+	}
+
 out:
 	*foliop = folio;
 	return 0;
-- 
2.54.0


