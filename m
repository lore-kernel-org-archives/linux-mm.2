Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29AFACD4F3D
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 01:45:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07F096B0005; Sun, 17 May 2026 21:45:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 007926B0088; Sun, 17 May 2026 21:45:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E11AC6B008C; Sun, 17 May 2026 21:45:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CB5A86B0005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 21:45:26 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5C2961A06D9
	for <linux-mm@kvack.org>; Mon, 18 May 2026 01:45:26 +0000 (UTC)
X-FDA: 84778848252.22.7F399CD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id E508E120002
	for <linux-mm@kvack.org>; Mon, 18 May 2026 01:45:24 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OHxCFjk2;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779068724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=GcLT6iYWr5Jtc5/0qiqKxkE3XRJo84XMU84tSzcuyzc=;
	b=nfbDiQ9wgayDwU+Ka6maxKtVGVS11+5Tg4jNhvEjIvpj05WByv/vuNGFNCY3VialOXt4At
	49CZaStFAIkdTgncTJGP7ytSVEkVOI9PU6/oWctljHR+55Uua9gdjXd/bnOS5mznZ1bCJ4
	UrHvQNU9CpNcPysNpNY8MRrwhr6EBuk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OHxCFjk2;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779068724; a=rsa-sha256;
	cv=none;
	b=vwaNeLu/RVDx78Aka7E4/eVZTzI79tMPiLi/rz/bwbBGhYk7oHen7aMRW39TAw2Ulj3nxa
	JIczGTWNafvg8jCN0Z6iqs0oFxUNy9hIoTk54m59gHqU2CIjQX3gkYUw9HOTfUzal7LpAI
	mjF1ivfUfsmQghI6kl5Ule7lhjaUBrk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 385EA60055;
	Mon, 18 May 2026 01:45:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9185EC2BCB0;
	Mon, 18 May 2026 01:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779068723;
	bh=OWqRFmr2OhTII5+uLiuJXBwMpAtunyrYvW8/JA65/PM=;
	h=From:To:Cc:Subject:Date:From;
	b=OHxCFjk2BKsf4BAt7j84NIKBlngRhbUVFSTkylTDBuaBC+xJDQEFx/I6W2l2IgXUI
	 MDRGhn4LePro4iq62EKPDjPdBsrCvXkL8cFzEbAL9MIwRAZjOK9erhswnXzLLFQafC
	 0yv4TXxOJ1vVOdIds+cTBeVqKsOBxxBIl+0mKIZVbAIMI524Brl1vXFDI0Cnxfo51G
	 W9rFkmZ2ZwQWkoM68r9LvZdDeDGEJDIUSy4ZHDHOLt0Ol5IV7MeMGUHI65Sm2K5hyL
	 ooymr3dvIKcxxXjNCXKkJYGUxTgwUc6BEide9LoGP5UvgK2k3V+cIntE7bszzgK+uz
	 S8gMZ0Yn1m0ZA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 2 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.2] mm/damon/sysfs-schemes: delete tried region in regions_rmdirs()
Date: Sun, 17 May 2026 18:45:19 -0700
Message-ID: <20260518014520.88424-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E508E120002
X-Stat-Signature: 18gqz4w6m4fq5stp7x39xzh9fu1s9muz
X-HE-Tag: 1779068724-361771
X-HE-Meta: U2FsdGVkX1/Dd/nRagPhV4hiPQYa0bnieDTTR4GuW0J7wmDlDd5c3Gyl6jfpLanjFtE07EJKIUfZP2VvEKkw45qr2iNGSYsJfO/+r73lOYbpPzz17wD5M9TwuqFwoKWjO+AwTdsd8FCk8h1n6wRSu7piHQDZ/T0TL/AqjWqkn5kFbiP6NK3HqE+3b3w+3GMUGDZXp/KFvayWOlKNYeAdn9PB9VQMKGRnlDRtrLwX1PQmOmMLgTbAsfFtMrM76JFOPdmBPAumwP64VaEHrToC13yCW/StoDBIeGcC5JjDMa7WhOR1cbuTn0muZrAL0U78UNyINDFcZFsGHLiLV5VtgjtYf83/+r3WRM0rV/O0m8r/uIZ0yCBkDBu9LHGhx9llDr/EO88Gi8/Icj0Gk8ew/OcaRQzbBnsSuRPjc5pV0bZ0z03cE+zuGYi9GWBI0D/sM2PJisszzjxgOdVoJ1UN2FeJQKT2Um5pbyNX89EDC5eMHEThQ+0p/SDFCbsPdbh2KVEPSue6HrT1+hgP8ozJHw6ywHXqRHySUgXD8MDc5RKCTdl14vF2FvqzZv9s6KLg3oAKtaa/8pdGl7q/ZWWOQUjIItN3ZRyfj0NiGtLt/iNm+XwYXEK87QMnMWCBhsBFaf5pwIk6bW73AAT4FO+4DY9i7aV3+KRoRG8A2MllvBFiSyJoVPW/5gbX4RV5uVEExe1972q7IuHm3IVqPaK7+s9VePejqXKH5IsvCgqoJPQVRJ3pDAW6DQpUk59e9DpoIb1uO5MO1ZDoW8Tiv402Q7tPitUr3VgmSYV/zfRmzLJIgo0kErRs/KCQkY/B8imKaYoikLM3mqLGIPQe3BVn1V4zQyz+4B+G+GppxxRnvidNRm0NFkOZ/aql6FrPRopohNW2kmXK3nF3dB1fbXUou1wkA0LJrj7KvSk43RYUm7L8DfaLNRzs8iCWT7RxpbRP+toQAWRhQitOIjYzdA0
 NcumPwX6
 XjDjZKdI29hb3HgFh+z1SbVJnk872eVrpoX/JMFhnRWX0dZ4ooZzdbpHU3zBlza/WwXITBtSkp8xfdLI7xscT/xSgXf7Sh2xun9GGppmuDMnK3yqSvLRSQQVfVtNpg082CWvZQ3VLlyyTaNbOOAdHvk/hMX/U/MtENAHvBDOebxkw/8oyPnMUNiIAuX6TzEfeoh0Bd0oZC+f8JIWZvObpOOiGiBorERd1mk9W8jAghuIBnPoaqYuiC9Mow9+iELkz4GQN44MSvtA9CD1PdJEmxFqnP5X+2YXSIChlX03UlV7yL1A=
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
Changes from RFC v2.1
- RFC v2.1: https://lore.kernel.org/20260517175915.3352-1-sj@kernel.org
- Set sz_filter_passed before kobject_init_add().
Changes from RFC v2
- RFC v2: https://lore.kernel.org/20260517172624.888-1-sj@kernel.org
- Rebase to mm-stable (7.1-rc3) for Sashiko review.
Changes from RFC
- RFC: https://lore.kernel.org/20260516211436.1883-1-sj@kernel.org
- Add region to the list after kobject_init_and_add() success.

 mm/damon/sysfs-schemes.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 245d63808411a..3421d82fea422 100644
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
@@ -2927,14 +2926,15 @@ void damos_sysfs_populate_region_dir(struct damon_sysfs_schemes *sysfs_schemes,
 	if (!region)
 		return;
 	region->sz_filter_passed = sz_filter_passed;
-	list_add_tail(&region->list, &sysfs_regions->regions_list);
-	sysfs_regions->nr_regions++;
 	if (kobject_init_and_add(&region->kobj,
 				&damon_sysfs_scheme_region_ktype,
 				&sysfs_regions->kobj, "%d",
 				sysfs_regions->nr_regions++)) {
 		kobject_put(&region->kobj);
+		return;
 	}
+	list_add_tail(&region->list, &sysfs_regions->regions_list);
+	sysfs_regions->nr_regions++;
 }
 
 int damon_sysfs_schemes_clear_regions(

base-commit: 5d6919055dec134de3c40167a490f33c74c12581
-- 
2.47.3

