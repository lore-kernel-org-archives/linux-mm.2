Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD530606A320
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 09:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a61qc6fn
Received: by kanga.kvack.org (Postfix)
	id 0A8946B05D4; Wed, 28 Oct 2026 05:57:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 080266B05D5; Wed, 28 Oct 2026 05:57:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED7F16B05D6; Wed, 28 Oct 2026 05:57:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D165A6B05D4
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 05:57:21 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C4215C0270
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:57:20 +0000 (UTC)
X-FDA: 85371582240.02.8F9F402
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 15ADF40002
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:57:18 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a61qc6fn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793181439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SpR5d9py3XMD/Kz0n214N+JOZVrkF2xRnFstJsjKg1c=;
	b=rHEdlMlYrmoDWPvW3wrz1pEWX64C5wrLmSy5MQx+OU/2HupJ/XNtnT54o2rKbmyxqAKQcd
	Qga0CYXSDzGS0JgfolKNOW0HxJJbHMieHrgl7ZDHsQQwyrUBrYxAbE9+tDH3QbtIo2OKST
	MuMPZ5KAtl1/8vWe8qQ9mGQaTixVjOg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a61qc6fn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793181439;
	b=2Bg/CZRq9st5ytm6rQuRBzHlG9QVbBljdQqhCAsoSjFA9Ky/YBwtzGgf+mj3fjFi9zzqXe
	LQ9faNqOWOyma/fJCmBxQJ3X7we1dpgzsmUWaYAfVAVZsm46papAVkvFVEOAEuLKgKL+/d
	8VxSSmvjZO/AsKTQfcWYyAupKHCeBqc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AEC9F601FA;
	Wed, 28 Oct 2026 09:57:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FCBC1F01829;
	Wed, 28 Oct 2026 09:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793181438;
	bh=SpR5d9py3XMD/Kz0n214N+JOZVrkF2xRnFstJsjKg1c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=a61qc6fnEZc3xfx550jc2D95XA3KZeNfm/bD3tKIVBm+O5o6v1jStX9B7HgcN4iq+
	 +TRzHNpBrQBzOe5eM5GSjvKmBC8PrOtIhuNY9Kf9xZVOcU65M/aneykg/oRvmHOOZt
	 xNgr59mTt/fCCc8G4cUeYGGFR1oul1MpnAnDAO+NCyHQ+HvJupBKhgDn9umn6xVcT4
	 vif3vXjMAIYShwthmy9MNfWM0uMOOx7gzDrxyDWALD//imvaXzDmvkmmtCGZk9sAIi
	 H8o5lTZ0LHxadSVYVYYcRBD9wnvESt48tHBXS5vAVBLKBvdyrBD8LcR5dm2XympuY8
	 XS2s/Ze4Frubg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 28 Oct 2026 10:55:13 +0100
Subject: [PATCH v3 15/15] mm/shmem: fix truncation of files containing only
 swapin-error markers
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261028-fixes_shmem-v3-15-4ce3baf2db4b@kernel.org>
References: <20261028-fixes_shmem-v3-0-4ce3baf2db4b@kernel.org>
In-Reply-To: <20261028-fixes_shmem-v3-0-4ce3baf2db4b@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Lukas Czerner <lczerner@redhat.com>, Carlos Maiolino <cmaiolino@redhat.com>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Stevens <stevensd@chromium.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 William Kucharski <william.kucharski@oracle.com>, 
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Nhat Pham <nphamcs@gmail.com>, Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1609; i=david@kernel.org;
 h=from:subject:message-id; bh=v1KTmyDVJ6BZ1dQ/IfjBTs7H2skt+1ukgSl8cYUbwr0=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIeHmt+W2Ky6O7HP87/qpyWdgqc8xUobY1eufv8irofL
 CYepR63OkpZGMQ4GGTFFFmCgu8bvHy5rrbajY8ZZg4rE8gQBi5OAZjIs0mMDL//7jPQktD//Zxv
 +gLZ1OrLp3LOfOLkm7Hk1JKfjjGTgu0ZGd5+Z1jHfcxZ2tmq6N99j+1spQJtKQpTuJ0nPBWctWz
 LJh4A
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 15ADF40002
X-Stat-Signature: w41syqzixjy35795y41jm37re9j3zk5w
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793181438-144457
X-HE-Meta: U2FsdGVkX19QppUQ71XeBD295diRG6UZpYwYMxCqAUK/dHKarcVsZdg1ADmf9qpsyAEbdbcr048bvza5YHZJOgZm1JVKPJRlKPLHgYzLXrYfS9p1oavyUl7bMWYNi+DAwXp6L2g0efq0t9dLiw0iqdRga0SMorSdyyaQlI5YW1SrXAdIi0Mqgcqkth60v4HkNpwylrkkeN7asHIarNNw+dc6IpksmO+8B6mdmaQY8h2LQ2YlDZFqO38jey7nMCdrtZQqqfRL/JvL7WkbKrIoNqiGZC+UrnxbtSARMrfsViCudst5uOGfRZrW9BkFnLTLXDkUbY1Jpq0+n0lv7ivvp1i5aSxrslGSG/HBzwttIodHVLpK6lseSz4gbKddgct6rz6QtXSDgyaVRax9rZSY/FTI4+H2JRrgmq5MQmgqLf62erhtcwzWok0rOAyijjrOQ31O9CAraa3Pd7BNNn+N+2Ga9tJGJA0TVK81CJQwNUIcQqCsB2cGhgdaHUY7yM2L3R6Pfo+NaE+iXfZkqISsnvpmxkG/5uuvNgFE6HO2I+h68IM/2DIEYRWceWZuRr206UapVO8Y86709u9qeizP664kwR9NrLx8aJdIi5plJh3pqWjdCuFgGYoxIQWB2InZ/AlJjkFdp9dEn9XPbkFgO5RggxbjhwK94TieNtTsSIF+QoQFyNXcwLCb3V4qsvURwGY4L4iLka7K38GuIzf773cZUS7iSW+5HPhyLtZKNMc8y0w9QDDyc3PDwKkKgPFBD/suDSweVz+3KKveyKapH2Du3Ir4/Lk2L7W0zc0+aBhS6ozlodqP9YgD/IBEDzKXCXKBB38uZ4SM9s9jBjyM5LMllGcRg6MYIjtB2rqY7BBmN2/ah38nz7PczqVAQaJwv+YalXwJf1id+fbaDGsqa1610JdduYmKAQ/iGri3U8w2VAsu++g99Kb0CdozWVlL6ApCjYjT4wKJ91snvOX
 mtjxTPyy
 CD78gUaj339RqmMW1x/2803S+tvy1JCwh/eHUsDiXkKYFNC+3+obYCD/b+OjOd+MS1U6U73j7OjTJBYOdMQLR3/4B57fG0KzqG06yTegS5POzR6frGQ2EM0twunMsKbwIlQZ4btruHoFrj4oYtrMvmOSzyO4QcIykOzwJkvR+twN/gAq1iEr+Pdn+yrGbJ0lX7jS/9pxrHpvuX7IdQ1Iq9UTM8TgTSxYt2Kk5NffbBPe1SvNyKqXIOUfN2DAlQIOfK5JtdJPVU9wA+MYFTtHoR718iveNS8tcc3FJXeUEHuuwHnKvBa6NysoaO0EYXVzNHIFg7tIVJt+eD8e6OalapMl2YLulGJiTMngv5Kmylvp2AvU1IjKYBBF2yuSAyh+T1vAQZVhR+0PjrfeCSe9M1dgDyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

It might not be very common, but we can end up with shmem files that are
composed only of swapin-error/poison markers.

Such markers are not counted in info->alloced. Consequently,
shmem_setattr() can skip shmem_truncate_range(), leaving the markers
behind.

Truncating the file to zero and growing it again will result in reads
failing with -EIO instead of returning zeroes.

Check whether the mapping contains entries, in addition to
info->alloced, before skipping the truncation. Keep the info->alloced
check so that shmem_recalc_inode(), called at the end of
shmem_undo_range(), can fix up accounting after reclaim has emptied the
mapping.

Fixes: 6cec2b95dadf ("mm/shmem: fix infinite loop when swap in shmem error at swapoff time")
Cc: stable@vger.kernel.org
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/shmem.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 11c3ac313c55..9e51768ef46c 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1591,7 +1591,8 @@ static int shmem_setattr(const struct mnt_idmap *idmap,
 			if (oldsize > holebegin)
 				unmap_mapping_range(inode->i_mapping,
 							holebegin, 0, 1);
-			if (info->alloced)
+			/* Swapin-error markers are not counted in alloced. */
+			if (info->alloced || !mapping_empty(inode->i_mapping))
 				shmem_truncate_range(inode,
 							newsize, (loff_t)-1);
 			/* unmap again to remove racily COWed private pages */

-- 
2.43.0


