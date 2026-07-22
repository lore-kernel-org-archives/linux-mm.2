Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70EC0C44536
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 23:41:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF9866B00AE; Wed, 22 Jul 2026 19:41:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0CAC6B00B0; Wed, 22 Jul 2026 19:41:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 876026B00AE; Wed, 22 Jul 2026 19:41:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 39A646B00AA
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 19:41:26 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A085C40333
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 23:41:25 +0000 (UTC)
X-FDA: 85018036530.16.6668633
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id A7A6240003
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 23:41:23 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W82BRnUd;
	spf=pass (imf27.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784763683;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ssGn4d/I3kBoooFscAw7+b7d6ubzqmbbGD2DsE1i7ds=;
	b=ULuZ6Rl6WB/YMiNjmQnlmLdWhZNPcS6vgPkAt/7nhT6XsVw5Pl90KV3KMZh6HcP+B83okV
	Mg1/KBHntgdvpAhV8OBA+CxKa88Zvh658EIu2A+LVavVXwFWoAdd7npxQgkigo3aKK+0Dy
	HMOuq9syD8yQxCIL7BOiHZxKjgqIUfQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W82BRnUd;
	spf=pass (imf27.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784763683;
	b=00lLdKvrlIp1MsEyRCXQLqyWVLxZLWfzw4qFhMLcbz1B+dcnzyNweekJWO4Ja+9vyxXhR2
	mkgZMYVpk4YZa4yWjl+0w6fd+AQvqhVZZZixXJRA3dSQBpEwR/s/9p6P+hQ6yZ+mVCHN0O
	wPaCpQ2oajEhTy16mB7G0NghJOcRjWM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 778B745134;
	Wed, 22 Jul 2026 23:41:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 58061C2BCC6;
	Wed, 22 Jul 2026 23:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1784763680;
	bh=pZEyi0J8om2ghDb6qME7uBKDwU9wZvWkyYWuA+nq1e8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=W82BRnUdxyWAQ4f+cvMo4Mzo/wV2rmi5lhO2VF23HZfYcpQlM1lcZFumECqhiTapo
	 DDQcSUd/6W9pwIAL8tUYYQaHBDjrQqJ7zsAw0sWyLEfpPyQurqZksyNlpq9aJ9LN6C
	 46g6yYXKoivcLALO7nTHcCJ94zTmAajL4Y+ilay0BhY7B0glNXu2KAclYcYK+fuE+U
	 M5YeUICXkGKJ0dst8euM3PQgtEBvQNQzh+9kuz+zSY2ZY1NA60vH5cXn6bXWDl8SZZ
	 ZmE7WLlNM4AaVq8ytPb6gMjSj4OFrvYII3K4E8XEWl9D+Kj/QAeD0cvG/8xQbqvOLW
	 G8Du92zuS5plQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 459EFC4453D;
	Wed, 22 Jul 2026 23:41:20 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Wed, 22 Jul 2026 16:41:16 -0700
Subject: [PATCH v4 08/16] fs: hugetlbfs: Fix global reservation leak in
 hugetlbfs_fill_super()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-hugetlb-alloc-failure-fixes-v4-8-88e8b81970dc@google.com>
References: <20260722-hugetlb-alloc-failure-fixes-v4-0-88e8b81970dc@google.com>
In-Reply-To: <20260722-hugetlb-alloc-failure-fixes-v4-0-88e8b81970dc@google.com>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, 
 Wupeng Ma <mawupeng1@huawei.com>, fvdl@google.com, rientjes@google.com, 
 jthoughton@google.com, Mike Kravetz <mike.kravetz@oracle.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, Alex Shi <alexs@kernel.org>, 
 Yanteng Si <si.yanteng@linux.dev>, Dongliang Mu <dzm91@hust.edu.cn>, 
 Hongxiang Lou <louhongxiang@huawei.com>, Miaohe Lin <linmiaohe@huawei.com>
Cc: vannapurve@google.com, erdemaktas@google.com, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 linux-doc@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>, 
 stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784763678; l=2642;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=xpwOn4o/8dwkPGcKx/D+08zZJl/SEz5ntK6oD42SVfo=;
 b=GfSo+082yV0XV2379mD54lWB1yFERnvv5vJcHzxcpA+vOTbZSFPHC1fJRtNvwaK1ItH4SHmMa
 P9nAWPJRDfrDUTI9SSn5NKpQmgKTijYg6y0r21Dm4bc+LzKU2zgTomV
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Queue-Id: A7A6240003
X-Rspamd-Server: rspam01
X-Stat-Signature: 8ogdyruk5o3wj9pp971pry84pgdzwscy
X-HE-Tag: 1784763683-479053
X-HE-Meta: U2FsdGVkX1+EQV4aiFIqNPweZ2cabLikIn7qP8rNnlnEpmyS+7da6fkb/0pcbOUQmC8nt0xdjbx7aD9H3VyAepj61l/YP77noVx2qcmvbqJ2OTYBhdcTPiYWNua3yrkMjCQ9MBEdW66RfRAN9VW79zyfpYcgLwQSik8yujzIow9oNPFAqBkt6FTKNtRAkC1Nm6MCxZERSGHMA0tSyKvJYb74DPWmngTg4NINsFXgBbTY0Dv7VM8mj5JABpPAstUnMQpSJYSkXq84HIU038TQPEi1BW3DjI8rj3R2DJDDVavHPkODNtQimmHFhAyIs21Nirzj4+7FVktDzg25A1gsDdwKC9NCIZ6gRr8YugGqPlZFs+7FdzFw2PTAQCLxtFUQPXwAEGrkH/nmVkjc6uNAMvon6J2xCxihovVHabhZYgcr8nK6A5yVM4Lq/JqKS1HQ8EYmSntKMLWYI+vTLxw6hf99uqSYYiNmIYUV3TE6XDsvCEDhEK3soV0f2+1XaFkuzpQw8g1Oeu1vWP330qfXdIYwVIHM475rv4FFU/QSPfwUpsbN6eUVujviKFzjMJwWU1zp7MVVEzIrrse61Wcg1bedGDJWBradphnVQldzMb12hl3lAZWHXZ9LTqdRwR0oCbg1MiUUkXrYVoXTF+He5MP3cMTd28HvUrStnxKaHG9VCrgH9OFGpP3WtrKNzz7whm82f3HXXMfWw83zIDpV+B/XyeuF2Yj2Osymv5/+6XFHlSvn2E1Ng8atqwVSxIyX9LBS/nMYobKxdIofVWGShjk45j1ua6CHAUYSt/tw/z0sD+a+Z/vtZ0DAHISZgjyuvo4GiLgZAXX1YEMg6Ogz1oVS34U6bEA6AA3H3JWPrZwhkLk7njldtQPl5+7pgjjMl68KFE9EojccgvJaSx2Ox4tmYNTKO3DPLqgxPlXRkMinGaTOyXpsZSx2Qgyf12ZHQHMV8lfmd/MqIMdLa72
 fqwocNQi
 2ase6vVeXoA//j1tW7DTJ52gMIxP7Z0CvQS9dI+XUZDUP6yCjtgeWmrtINx6vVS/V4QV906wiH3jHdR2gOzsCxcwnwpcMK43Wxs4lrkfmM7VXHzb15VejdA1aWqLzTY1gb2srQQNGy7KcKdHtSjJb/fYQ08WD7GJzhlcjx3sem65JytZW93SeaCtw7KzytgGOY9oW/NMRV/PJxFq65J4oYoU35iekXXdvlD2G6WmIZ+D16irrgQg6l5I58NRjvSheyybXJRHZmHhYAYgYIR9PUohy4Lueqb0rt+R8J39O91E/Gr1q5sz8faD7ib1PkeRt3/I4MG5P8wdc9OlOVo2D1yrtg0KFeKsPT5w9/aybAlBd/vfeexTgiTksi/GoaYcBIuVxr3TCq26oW12T7Vs0ZPMeKa8hHencxfMAliiEd/Fxsd9BLY/1Kwdxu/OlQ7KzALB3/gIybSCI8J0zSc3LGthXoAvAQCzRhL0tiG7dlQvS9HLwkRN5qG1jwXbuIVahblscpC8k2EuFMKHGffRaj84Esw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

In hugetlbfs_fill_super(), if hugepage_new_subpool() succeeds in
allocating a subpool (which reserves global huge pages when
min_hpages != -1), but a subsequent initialization step like
d_make_root() fails, the error path directly invoked
kfree(sbinfo->spool).

Directly freeing the subpool structure with kfree() bypasses
hugepage_put_subpool() and its underlying unlock_or_release_subpool()
destructor. Consequently, hugetlb_acct_memory() is never called to
release the global page reservations allocated for min_hpages,
permanently leaking global huge page reservations.

Fix this leak by calling hugepage_put_subpool(sbinfo->spool) on the
error cleanup path instead of kfree(sbinfo->spool).

sbinfo->spool must be checked before dereferencing the subpool in
hugepage_put_subpool(). Add a NULL guard to hugepage_put_subpool() instead
of checking it in the caller to align it with other subpool helpers like
hugepage_subpool_get_pages() and hugepage_subpool_put_pages() that
gracefully handle NULL subpools. This allows callers to safely invoke
hugepage_put_subpool() without requiring explicit NULL checks. This is also
aligned with how kfree() can be called on NULL.

With the NULL guard in hugepage_put_subpool(), the NULL check in the only
other caller can also be removed.

Fixes: 7ca02d0ae586f ("hugetlbfs: accept subpool min_size mount option and setup accordingly")
Cc: stable@vger.kernel.org
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 fs/hugetlbfs/inode.c | 6 ++----
 mm/hugetlb.c         | 3 +++
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 26c0187340636..e5d86f31eba5b 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -1133,9 +1133,7 @@ static void hugetlbfs_put_super(struct super_block *sb)
 	if (sbi) {
 		sb->s_fs_info = NULL;
 
-		if (sbi->spool)
-			hugepage_put_subpool(sbi->spool);
-
+		hugepage_put_subpool(sbi->spool);
 		kfree(sbi);
 	}
 }
@@ -1423,7 +1421,7 @@ hugetlbfs_fill_super(struct super_block *sb, struct fs_context *fc)
 		goto out_free;
 	return 0;
 out_free:
-	kfree(sbinfo->spool);
+	hugepage_put_subpool(sbinfo->spool);
 	kfree(sbinfo);
 	return -ENOMEM;
 }
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index b759748468734..90ec015a11181 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -177,6 +177,9 @@ void hugepage_put_subpool(struct hugepage_subpool *spool)
 {
 	unsigned long flags;
 
+	if (!spool)
+		return;
+
 	spin_lock_irqsave(&spool->lock, flags);
 	BUG_ON(!spool->count);
 	spool->count--;

-- 
2.55.0.229.g6434b31f56-goog



