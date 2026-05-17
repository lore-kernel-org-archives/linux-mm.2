Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14175CD4F47
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 17:26:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F7AD6B0005; Sun, 17 May 2026 13:26:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A8DC6B008C; Sun, 17 May 2026 13:26:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BED96B0092; Sun, 17 May 2026 13:26:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3C8386B0005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 13:26:33 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E25A2A0692
	for <linux-mm@kvack.org>; Sun, 17 May 2026 17:26:32 +0000 (UTC)
X-FDA: 84777591024.11.8A33F27
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 56B31C0007
	for <linux-mm@kvack.org>; Sun, 17 May 2026 17:26:31 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZqUikQcW;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779038791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=MWiBqSXYE+ulxDR5njsxQ7su1Z1o/QYjkt+oqb0ey8E=;
	b=el0rOrA2s5FLwE6sgVCkrcQycc0jWZ2Fih4+mT1hS9LdBWV/D602KUFm9YhM+LuqGlvrOh
	1EwsQe6lYIBx0XsJymfEG9f/vm18M3yLZPObL14k3N2y9quLAihmsodQcDNpio+paNEqUP
	U+gDlq0rGqCk87+BQfX/7WIg/Z5zFH4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZqUikQcW;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779038791; a=rsa-sha256;
	cv=none;
	b=41v6wRCwaoDd++ARZx4UP7RkfgQ9bUFzjJzYxtCn9BL2xSPbRqwa8DzldxGkEhPxZSMDW9
	ElLzdfOJ2P4ZvHSoWiZ3DZRJWxRPp3R9NabDlU6IcpL2K2jIERhwjDDIkcG+F0Y/PBJy4f
	m6YCT8CgSVCvQ9eYHYZFFn0+YUMoEjs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B821860141;
	Sun, 17 May 2026 17:26:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F86DC2BCB0;
	Sun, 17 May 2026 17:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779038790;
	bh=uSmhrok23qhHp/UuKR5PcZR4/GmFUZQCLIknry70ibk=;
	h=From:To:Cc:Subject:Date:From;
	b=ZqUikQcW9Evjr7yatHBQHdM3uw52R38uUb2fVpt+MrdYfo6kq2QMD2JriXVJBsQGL
	 RJge6mPFr6oFhn1WRoqOfYuN7jDjvfOq/bW4atI+sFaPa5Bc8lkuQDmtLu+mnreJyK
	 jRPDOiZfoyMrf079tRQ0dXet/yk9Kq0WrJlb5jPX7pO6yZ/Zhs12tB7SlsAQk+2JWq
	 xvVbykHyrTwobwMdsrodM6AShwRWHERnOBLqgRO5rCQBzJelvWjIA6rJ1w/rWEe/Xy
	 LCN68rn/qhHye2VrgQKYGhNT14q7nx6tSJhlzmki3hhScpglOQXXEw7ytWwrrwOns4
	 6wbm2jlOlfxLw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 2 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2] mm/damon/sysfs-schemes: delete tried region in regions_rmdirs()
Date: Sun, 17 May 2026 10:26:21 -0700
Message-ID: <20260517172624.888-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 56B31C0007
X-Stat-Signature: ngechtqnmu735uxtb87678xe4bt9u6xf
X-HE-Tag: 1779038791-814067
X-HE-Meta: U2FsdGVkX1+zGcTnBQSa4Z/3skfqnmgwFGmC5yPC8kkeQYfZrSjfchPA9lBiMZcjjDpnrC9dKaS10niC74LO9cmq9k6GjC2dfHZbxbvIyESgUG0AiL1jhz+0WEtAPQeDekR/hp3ubBH5yAh8Sl7wpAUvKKUjNE7tOAGU9R0Ztfp0s3+5yvDcuxg70g8xMYLfaxSCWPFDocpQ0G2CrLkmP1RqNAKZUVfs0Ax9p4ojx+2PQ7eyW8wFAnyuc+aQTPllkr/evjiL8U24RC0ukwpOQAWA+ZA2PAIu4yQ6sSQyhl3Bwt8DEiSy//2Ze3RU9GDb6CClahYl+hYMoPsaeDLWgbqXrJ2oOht5lp2jW7bzCKsioBx0mvbEc79P7xj9ioVJ3XYvY/xyEuehNg5K4Kr9yYWq/7aXKynyJiAU5Ed9diWehM84xZGd275aNZw4tMdZYT71sHVomN7/WyuNB5ON+/8f5Vxia8hJ5nAhwm1JPB+8SCr75TPf1ew28+a+dZVVtzBqxT1w2+CniGIThKrl0MaiOzzIiWP1TEOkECVusZDd7eLH7G3z9m6ep4K9YoR/FI8iWVeTv0MBQvrXmEfXKyPGYTsovA5xEQoibP2KoDRfczHB9WoAOYUG8eWKsRzDgCP1eLAkMzh0yUif5WSndB37XgaP6ggB7FZoU4ZuLx4FKXUH0tzB9+ct7D1IKvIEt13RV5QAUqmJ3NwvJJF9L7yQ405feS5IZBXmaV9Y6fo6K4mfLIzL2UOU0CqQ5lVQMBC+7+9EWG8PhlTYP70jvpKB+UKysIxXqv6CnNVGK2+HXUHnR6KuNki1idcnDNZhFewHMxkOVI+M9G7zw49sovdbIcB34w5tJj05S8/i82MVSsPPbqHv4XcSHPK2OAeJ5QnysvJFejTn2V55soH6H1ElVivJTDAOaFbRYtWPTIFw7iSPvwERuaA+a1BLZs/szVVNnpfl3EN83mj0e0M
 z2x7QdQw
 A8dLSZuD2xs4+LhaFvAQtLtvEAhkChB186cz7VKrqmp7w547pEXZpicy8NjgwZZ1WDrqSBYwmxqED+N0lV0JTS0z0S0s1c1v49cMJ6Q/5mLD1+99PyZUHCvt+LqRSWeBwr3i+yj3O40FbLS2PBPJgNriKejQWMAKMlXbe85NGNXqgVJJcvV+aBkHP5dRktv2WsZwOBSn+HWh1H+gUa63NcA+Nc15jl6VRxQxvKyxc++E7/x2ZjzQMQgBLLJmiM0K8vohLpfGTE6eh/QjBSbwAQ+g+P7JqYy2ka9LnzZs1jLSV56I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON sysfs maintains the DAMOS tried region directory objects via a
linked list.  When the user requests refresh of the directories, DAMON
sysfs removes all the region directories first, and then generate
updated regions directory on the empty space.  The removal function
(damon_sysfs_scheme_regions_rm_dirs()) only puts the kobj objects.
Deletion of the container region object from the linked list is done
inside the kobj release callback function.

If somehow the callback invocation is delayed, the list will contain
regions list that gonna be freed.  If the updated region directories
creation is started in this situation, the list can be corrupted and
use-after-free can happen.

Because the kobj objects are managed by only DAMON sysfs, the issue
cannot happen in normal situation.  But, such delays can be made on
kernels that built with CONFIG_DEBUG_KOBJECT_RELEASE.  On the kernel,
the issue can indeed be reproduced like below.

    # damo start --damos_action stat
    # cd /sys/kernel/mm/damon/admin/kdamonds/0/
    # for i in {1..10}; do echo update_schemes_tried_regions > state; done
    # dmesg | grep underflow
    [   89.296152] refcount_t: underflow; use-after-free.

Fix the issue by removing the region object from the list when
decrementing the reference count.

Also update damos_sysfs_populate_region_dir() to add the region object
to the list only after the kobject_init_and_add() is success, so that
fail of kobject_init_and_add() is not leaving the deallocated object on
the list.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260513011920.119183-1-sj@kernel.org

Fixes: 9277d0367ba1 ("mm/damon/sysfs-schemes: implement scheme region directory")
Cc: <stable@vger.kernel.org> # 6.2.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
Changes from RFC
- RFC: https://lore.kernel.org/20260516211436.1883-1-sj@kernel.org
- Add region to the list after kobject_init_and_add() success.

 mm/damon/sysfs-schemes.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 5d966ac864193..b625f616f57e7 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -88,7 +88,6 @@ static void damon_sysfs_scheme_region_release(struct kobject *kobj)
 	struct damon_sysfs_scheme_region *region = container_of(kobj,
 			struct damon_sysfs_scheme_region, kobj);
 
-	list_del(&region->list);
 	kfree(region);
 }
 
@@ -164,7 +163,7 @@ static void damon_sysfs_scheme_regions_rm_dirs(
 	struct damon_sysfs_scheme_region *r, *next;
 
 	list_for_each_entry_safe(r, next, &regions->regions_list, list) {
-		/* release function deletes it from the list */
+		list_del(&r->list);
 		kobject_put(&r->kobj);
 		regions->nr_regions--;
 	}
@@ -2992,15 +2991,16 @@ void damos_sysfs_populate_region_dir(struct damon_sysfs_schemes *sysfs_schemes,
 	region = damon_sysfs_scheme_region_alloc(r);
 	if (!region)
 		return;
-	region->sz_filter_passed = sz_filter_passed;
-	list_add_tail(&region->list, &sysfs_regions->regions_list);
-	sysfs_regions->nr_regions++;
 	if (kobject_init_and_add(&region->kobj,
 				&damon_sysfs_scheme_region_ktype,
 				&sysfs_regions->kobj, "%d",
 				sysfs_regions->nr_regions)) {
 		kobject_put(&region->kobj);
+		return;
 	}
+	region->sz_filter_passed = sz_filter_passed;
+	list_add_tail(&region->list, &sysfs_regions->regions_list);
+	sysfs_regions->nr_regions++;
 }
 
 int damon_sysfs_schemes_clear_regions(

base-commit: 950de73f0f8bb17fc322e8f9ec09a5fbb4a72ed8
-- 
2.47.3

