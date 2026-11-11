Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61AE7606A321
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 06:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=KAl5W0Ke
Received: by kanga.kvack.org (Postfix)
	id E71266B00EF; Wed, 11 Nov 2026 01:47:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E21B56B05C4; Wed, 11 Nov 2026 01:47:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4ECD6B05C5; Wed, 11 Nov 2026 01:47:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 973D46B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:47:49 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2BBB34020C
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:47:49 +0000 (UTC)
X-FDA: 85421907858.20.3EF8CEA
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf04.hostedemail.com (Postfix) with ESMTP id 57FCA40009
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:47:47 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=KAl5W0Ke;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf04.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.171 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794379667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bvnurKRq/kU9ebhETLig/zqsjvD96i3F51B+gs0iQaU=;
	b=b84IKDWlequ7yNPzAGu+tkxYV5FhutRYllye2edAXJLwORkbhHPq1k/e6dSI3OiWwCpw44
	P/Bus+jYhCAu+FL56ghOt4f4BuKTZBHglmftw8Lh490z/uaFJJ7s1ghKe+56vj9lvYI4jR
	VSnWMigbI9l7YpvY+MphUFoUFJ4TGmU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=KAl5W0Ke;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf04.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.171 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794379667;
	b=j1vWC/wzm6MDYdaUWE5oO/Kk3r91sAWv/DCwh5DqQM9q8CiM72gcgJheBpZGbDifHdkJDh
	3+luESKonU8OndsbKVIKJsVGuXp+u4DSyqXKie69AsxyBUKS6rVnMwQgzhL6XPac60Gjtd
	veXg57uLRtDQdUSZmIVCxOMK78CpxLE=
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-cdb628232d2so1703718a12.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:47:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794379666; x=1794984466; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bvnurKRq/kU9ebhETLig/zqsjvD96i3F51B+gs0iQaU=;
        b=KAl5W0KeLsKCBx/olw5IhAE2VEMqHiHX1VJenQ0UTCyhJtZ27uactRpqfKlOtloDck
         ZSiOjn7Thv3/VB6q1QX+unYbYfzZUZAbQvf9XuQ0ljqWw9hjTx7uc2nRGUQjlbco7B3l
         GpdvvovtiLRsLq8lztTlVa533TsyDKYk8EhWU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794379666; x=1794984466;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bvnurKRq/kU9ebhETLig/zqsjvD96i3F51B+gs0iQaU=;
        b=2TUojkOXdeizeq5KdH3r+nTewaVFlV3WVlXABpx2bQ2PzEkecWoomy4YoBhknGCOHM
         VzJszPQP4AlKsJ8IdpDupyPRuOXNzDnOyt/moKjefXiFtmLd/yER9NyBsC5sppS63PKJ
         RFSYzs+8BiRq9U5qYFJdOihiNtZTcpMa9pTU/i9EWxn4WSzi2vJk5rA/YUXOuKEwWAIW
         kpd4sc1Y7+5EzJkdl+EfR4Nnmnaumt3WZG2Y1RHNb8BkmZ42NcVs+XON80TKbuCnObxx
         kWgZEDIzCDm19BOpswgstVPpPhp7f608kUCUtAimgwV2gULPsC4stD5Jm9zK9Mwp9yD5
         g6ew==
X-Forwarded-Encrypted: i=1; AL+hErHROU32OsFj4/6RBVoHzhDaA9hoynZKUmffxhmFBuzz+j/uWpgYKOYZecGOpsv3dFck6v3OlWF+GQ==@kvack.org
X-Gm-Message-State: APuU4Z8iZUwTj53/9wJFcrYCOMfVzuVkQaTT64jW/raPW1waqqCeITby
	vGGLXcRNwY39Nh7x88KzFC5Ib1pQOOFc10lpPaZUJ+HYmEYFF9rYpgc8wxtqBZWHSw==
X-Gm-Gg: AYBFou0daBoytiUKGDN9avPGgOXouupc6Y7wupX5JkP1pJoxdQ/Cu3n0HACn3oyNXlV
	YP+mjt3v65FBd/E7OhiqTaRzmEbKs1G8AARk5UP6BiyEv3CzxlltUKxg0P+d2P/5YtJhMpRPrio
	cHOSG75sEuSQTeNqCPS6gg7HZhkC+CjPyswXzlc+IxwWS6Ca1yzbRaQQU4oTQMiwi0kDfqVtadr
	5mnl2R3BGYAPKCgv9c9wkU4v7nEjeAgcms1q+KvaXH1Cb4+76TG8bhnHI13mbYM4A5Nr9Ai3Nzv
	tw8HrgkqoS4gKki+J9qfUTXLDKUz7MHpJnlg6yy3KlAPCJxSfiK5R7QgAZyiyeuStIE+fvZ/nqn
	+cQJSgZ4nfChg51tPR9aWvrr6g3pWujMI2gskGAF0Fw3keq3dWRM2WrPbzX91u42uSdPhW3l58t
	fDyD2x0WXpwxjTVenqXVCw+KmgclZXH/joxOVHf+FotEl+GKbP+G2KlI/uaHA6uVXCDKo7dV66i
	5jxgpnAbA++uaCggniTtwqFeSJWVUZmun+WLk3AtMbSRJdimOIQY4M9VyNEK38qCqOo3Ij8O8GC
	Ph1rK8dX2AQuRMlXElDZ8HSQVCg9Lt9fL9YyWEI72+evKw8i5unJ17EoBhWBrK7U5bq6tXWK7SL
	1jCru2NjKkpGO/nsKJg==
X-Received: by 2002:a17:90b:3c12:b0:3a8:bd51:205b with SMTP id 98e67ed59e1d1-3b182efb4e0mr1748244a91.37.1794379666174;
        Tue, 10 Nov 2026 22:47:46 -0800 (PST)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:ad6a:b446:df00:78dc])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b17db85a9bsm3268666a91.14.2026.11.10.22.47.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 22:47:45 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Yosry Ahmed <yosry@kernel.org>
Subject: [PATCH v3 11/11] zsmalloc: populate new zspage outside class->lock in zs_store()
Date: Wed, 11 Nov 2026 15:46:34 +0900
Message-ID: <20261111064707.2568433-12-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
In-Reply-To: <20261111064707.2568433-1-senozhatsky@chromium.org>
References: <20261111064707.2568433-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 57FCA40009
X-Stat-Signature: jygtfoxrfw194d1875mgq446jo5xbxsr
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794379667-487782
X-HE-Meta: U2FsdGVkX1//pllMjL813JwhRs/uWBwP5S4y+N2mGWa3R7Kvjj/GfA+liR1Ag7xM0RoLFcePRLuKjBrYoMQRljZUDwwNnTMFlXLHMMrGsdvCdmzRVB2b5DOy+gj3B4TQ9Io2uKLCOu+uQqTxW977snWlS/P30fWDPibD0iPgAK8qkXhbqXC5xUdqXjlbMIpvlF33I1M/mxALRvjfktnX4HyR3r7uCPbicemJLhg+KWXkq4y+2ob0x7vb7l1Fz56sblJaLizLJGS9pL9F2YWrI/QDq9wcAXlfOYi5dSuiVaaxUyolbda5FINe9JQ+SSCp7dyd0B30hBz/nBhw22lHGkzYzyGrRtsE681t6ROAGyKTU4oI2mI7StTsXgias1Gj3G9TNHPuuEvE5dvYjnpqljSYtBzyBV4S78iReasjvPCWq2ESbR7sXaO4yZDhRrVOOhZBq4prQm5cM4UUMd5N5/FVoRPUUdw8IsY8j+9bb3k3MGGqKR5p3r5u0JXRBjSNJ8oN/Hi59OXWc3ChGer8mRpiJVKm04oPiPicsKGKEcHVj5GUSzHPxPXD66Yhuf/R3qNYtnet8LGPbCLeKDaKiyfwxPLEgU6y3Qk2wqFH8vl2SRdxoCmjqiRrtJqMlNHsIVf0VRCD5HMK2Koai5M1aV1Jz6hzSWq+FX1eqU6IK4b4Kq0yooyk6GL7E9xnUp4cn9ACwxaukLZSSjPeZIIbXhnwbRMwlODU5s/DUWo4X0MwHZncAmGzcXe9qYU+uXJIv3Z7P7LomeXqfvHbgua80NjCWCjQg2M3aduUKU9RKRG5BMRij0wcLP40+od0r/++BVlBocO97396/5x7o0dzi90g5kixpqrxLwknSijX+uqDiyW9El+KeHa+cCJqTOkADp7oQT58zVWjGTS8FuxjkuN14bKt8jCcHcJja96PMGBFq5XxdBbzglq9eiBYvsA0xgV1uq1KJIxkP2Bl+9G
 KHOkLf9/
 HUb3db6pHQzmGz1xQUpp95n9Y6IPkZi2Bgh06nIy0CSmWCxOEaYTty23ko8Txts3lesUow1vX+1qeIY/sGvSNbZgyl2BXQYO8DfvdQs5ZdUA5Bow9O6+r0G7iI9bhePMQuJ1pbWwtaoSqbpZVMQWozqKoQSlVlQq2stMOntoclYXt3ixkjJ2e2q5xds9OUe0L206Mi5zix7d3wy5pQ4pQTh1zjAy+c4WERwK6aI2ckKdxauMRWo5ntJ7EwjhBpYTYwoEUlg3d8N0w2XbxvbiKN3UAT35ldP1c8kNSmdzTirRi4ddPbW1qMKpIR/2mq7bYJr+veEsjsX/i7yILZUDFIkc3XYWm5Xd6Jy7/zwr2kPZ3XP6H0HeKeQNJIzLmSWysvKxFG++rLPqT17nr7LqrtB46Lg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A new zspage is not on class fullness lists and is not movable until
zs_store() calls insert_zspage() and SetZsPageMovable(), so neither
other zs_store() callers nor compaction and page migration can see it.
Nobody else has the handle yet either.

So for a new zspage allocate the object and copy the data before we
take class->lock, and don't take zspage read lock.  This makes
class->lock critical section shorter and saves a zspage lock/unlock.

Suggested-by: Yosry Ahmed <yosry@kernel.org>
Reviewed-by: Yosry Ahmed <yosry@kernel.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 mm/zsmalloc.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 7f1cedd34081..4a6ec43f418b 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -1323,8 +1323,12 @@ int zs_store(struct zs_pool *pool, struct zs_handle *handle, const void *src,
 		/* Now move the zspage to another fullness group, if required */
 		fix_fullness_group(class, zspage);
 		class_stat_add(class, ZS_OBJS_INUSE, 1);
+		zspage_read_lock(zspage);
+		spin_unlock(&class->lock);
 
-		goto out;
+		obj_write(class, zspage, obj, src, size);
+		zspage_read_unlock(zspage);
+		return 0;
 	}
 
 	spin_unlock(&class->lock);
@@ -1333,8 +1337,15 @@ int zs_store(struct zs_pool *pool, struct zs_handle *handle, const void *src,
 	if (!zspage)
 		return -ENOMEM;
 
-	spin_lock(&class->lock);
+	/*
+	 * New zspage is not in class->fullness_list or movable yet, so we
+	 * can allocate the object and copy data before taking class->lock
+	 * and without zspage_read_lock().
+	 */
 	obj = obj_malloc(pool, zspage, handle);
+	obj_write(class, zspage, obj, src, size);
+
+	spin_lock(&class->lock);
 	newfg = get_fullness_group(class, zspage);
 	insert_zspage(class, zspage, newfg);
 	atomic_long_add(class->pages_per_zspage, &pool->pages_allocated);
@@ -1343,13 +1354,8 @@ int zs_store(struct zs_pool *pool, struct zs_handle *handle, const void *src,
 
 	/* We completely set up zspage so mark them as movable */
 	SetZsPageMovable(pool, zspage);
-out:
-	zspage_read_lock(zspage);
 	spin_unlock(&class->lock);
 
-	obj_write(class, zspage, obj, src, size);
-	zspage_read_unlock(zspage);
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(zs_store);
-- 
2.56.0.542.g3ef89b7020-goog


