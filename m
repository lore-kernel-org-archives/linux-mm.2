Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6E30CD4F3C
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 21:14:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B28A6B0099; Sat, 16 May 2026 17:14:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 089EE6B009B; Sat, 16 May 2026 17:14:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F09256B009D; Sat, 16 May 2026 17:14:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E0CA76B0099
	for <linux-mm@kvack.org>; Sat, 16 May 2026 17:14:44 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 83EBBA0313
	for <linux-mm@kvack.org>; Sat, 16 May 2026 21:14:44 +0000 (UTC)
X-FDA: 84774537288.09.0D9483B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id C643914000A
	for <linux-mm@kvack.org>; Sat, 16 May 2026 21:14:42 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=udodKoFy;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778966082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=xXWZXwmm5ETnSomTiMH5MOFmxndnRD5B7oNefS65BI4=;
	b=SoSpsZdTQrkDyNspQ407Gb63kbC9fpo+FH8Mx5n22sp9vpHTWiLUeU3ZsKpGN4TJNi/ROn
	Dgnx5O2QdCemfzYXEAjtIvSE4jxfHy9xhbeKXPjsjixuliUgkG6GHOksjZyNXQOPbxE+rl
	1HDSZp0kLvLoOFsSv3Mc6upPn9gjpVU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=udodKoFy;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778966082; a=rsa-sha256;
	cv=none;
	b=HLm9HACuUoG2jMMqCyn99SWh9mjM7mInJHDcrEi0wUwHA5SyxOZObaOJykOiGoRlaElJp+
	ahZWc/13twLrKg0Nu+L+DoMUJATqhfMQyiF52vwEjqcPPK/NZIo/OwAZBGvnvU9KSXbO9L
	Wdh+P9B+rFAhp9h4sFBGQ/M3VMOhAtw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9686741797;
	Sat, 16 May 2026 21:14:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A661C19425;
	Sat, 16 May 2026 21:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778966081;
	bh=eXb27mgMuft7D/Kna5spkvt2pEa3JGTJj4WtzToGUq8=;
	h=From:To:Cc:Subject:Date:From;
	b=udodKoFyHuHw4e0+rQfbvCgxWvRXAMA4MMsmXi6USJIVqOK57GtkP7btDpyX7gqOF
	 qUGCCUA0oc8cegm1UYvT70jB1q53LkMvmvljziC78Fe9KXro2TZBkDcICXg90kFLHG
	 0wAz4HROL6k7Icrw4KMmPOZK+AZsHcUxNh6saUH29fCbEoKaMSju4n9OxbjMWNJqA7
	 rxgfKOL8sUqN+j7SpEkM3FZBtv8c53toiG++jNgiZUCGKeeK3HFxTZ+q9Yi1KkfqUS
	 FLgTNGmPFezzVwz/yclBqy6GAseYw/iokdRYXDYzLmhYWrXqXPMjGtGlFX+d0v7NRM
	 qoFYWjLSd4v2g==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 2 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH] mm/damon/sysfs-schemes: delete tried region in regions_rmdirs()
Date: Sat, 16 May 2026 14:14:35 -0700
Message-ID: <20260516211436.1883-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pjx3s86hcr6kupp8yydmmi397k1gx188
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C643914000A
X-Rspam-User: 
X-HE-Tag: 1778966082-699204
X-HE-Meta: U2FsdGVkX184WeVM98vDQTkHs+zx4flWt4eu1K+mn6+GiWEE2g3jYZooqYY4R3cC8MBUBbPgW5y3VaAOHoDAQN6Dpm2CkAj16sS8l9OXBAH1pDVbz3PkF5qgGKy1mMB/WKQYIgUdsVry2GlXLqRgzVIVpNKwWqq2j2GEe9/oQkaoXJ9sxThgI1txrGPjbFyFC8j9i/OQ8Xwtpv/Y3soHkiWtUecUZVMxkfj29jEidUppOekSQ2eAa4dxqoAVsLhCjMuupub8iaj+cg80H4MZZC9CmyzMiCVf08BKa67IeHd0D/yioCfYH32FdDd1AhyMJOSFAXMO5NYSZjVknYeU87VJOx8z2FKDlWWbeloKZ4XE6Z0Rpae5YyLHWEhKFbPNXzvXpLh2tQVvBsmqI5faReh/0FFYqqOsnLFYyiXBeezir2uOCg4ZHu5n5BokVNQXRIBesoXPfvOO2LnPCgqfBY4I+u7kPfedaGXBctjpiV1zfNjfeV1A6oRTMU9NOtyYzIW6qDGXlIlHpMveUfjYYaBWaRnYRnYhT6NTD9OMLiVUJ6Y1b6wX3W8+NM0NMZPzY+aGCzL7I1/MbU0+rlCkTKbvArfGP89DXRZzj/Jxg/o7/exLXSszWTCA+bubhZsYJWdbaKztUpEJC6h4nQTHK0mjqLJ31k4R/UYBEj1TQFix2S1Mp211HmuAmQulzQyqUFf84gfSZkCx2MGyjgcZmFAEPI3tfX1tHNmsk2etr3dkexQx0EOPHpvooW9SUH1B7udz6woucJZfDW3aWF1e+Myw5wrpNHJ+HqZ3o5Bri2Lqn7p8kMx7BA7ZHwlK7EELjaQ2o2Eo3h9iYfXHLQL1hPkreqbjTCNjdWgd1GMth7F+Hg2iEz4haeBAtgC7XyHC92cEhTRXpXUX7f1D0LXC2tkEehB9Z09uKT7uoGcRBi0/sOI+ncao1mi62au8NqDwoLOnKIAmUAqoDXHQf/Z
 Vi1ni5k6
 5OFmc+4GfQMvqe13WKODdtdVNh6BYmycIxReZC8TMqLPsnwzKmNzrBXcbHX96WPyJHcDIayoGvoLEGGduV3fECNxeaqqpnkdRszsmKAyQjFSA4NFpzuSd8cp9wyGNttY0XKu7GbLqehEm+4rLgQ1m8SbQFrlpH2hTBJS2z3awe+QgHzxMeoSlBMfYbDHNB2RwawQqe3i3C7PbmKMBWNIohx2nvyd9D6n7pS2R9naoJQ9/X2hFsnjx0GiuVQmhWEtTTx+VDKjouSkBMH7N53o1z0lCDrNksCxxlsW0GM68WorWuVk=
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

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260513011920.119183-1-sj@kernel.org

Fixes: 9277d0367ba1 ("mm/damon/sysfs-schemes: implement scheme region directory")
Cc: <stable@vger.kernel.org> # 6.2.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 5d966ac864193..52627ce3a1a62 100644
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

base-commit: 950de73f0f8bb17fc322e8f9ec09a5fbb4a72ed8
-- 
2.47.3

