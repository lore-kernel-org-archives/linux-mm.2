Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A638606A333
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 16:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Pi2S/Y11
Received: by kanga.kvack.org (Postfix)
	id 208A36B05CC; Tue,  3 Nov 2026 11:25:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B7406B05CE; Tue,  3 Nov 2026 11:25:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 080A96B05CF; Tue,  3 Nov 2026 11:25:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D547B6B05CC
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:25:51 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 57080C0351
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:25:51 +0000 (UTC)
X-FDA: 85394334102.03.DCB09FE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 37ADAC0008
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:25:49 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Pi2S/Y11";
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf28.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793723149;
	b=Xt22tnYn2dLx/LKan7MO7Lca+aS0hk35Btk9CaBeW6LrMmKkoUzc3ns8seZnpw1FUlfRbo
	7qDjix+Ow8etpl2y9hyuDYzNUngE4FY4u91LQ/BPmN6+brl7swph9Fec67QhaRb2m4BK8s
	pGyxcTgnnHzbaqf2y7jGr9OZPMV6flo=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793723149;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wJNKxiM1RR8Nt30qb6ixH93YV4loyXSLX6/lXKLZxD4=;
	b=CS1KbsUcJfIdSUeXBETH7Cu7j545iJ38xgMN10htnt+timJNBgln6t0bMXiA8of+46jTVj
	Oq25guj5jzc1Gi6w3mrKsRqDVGXe1lKv+zbHfJbIuo0l1/xTVhvOkCuVsGx08XqZkIHtaP
	eJiwALbTGLhvqgC8R/hzcmnvQlh6vCE=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Pi2S/Y11";
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf28.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B622D601EF;
	Tue,  3 Nov 2026 16:25:48 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793723148;
	b=Dzxg4aTyjOjAHEsWOk9NjNHm/iTz3UkdwNz022bcVLBtMPofsCiPK64sP/I7bWr3Z+f9
	 lBTETRJC8x+i9qJD6dItrUuhQ964YQj2gmh6avUZ1Hq3jd6LixIiH9nJ3Ps2Ncj/iL9e+
	 zvZfb242H3dr73uh8S4FSb4ADriOtcw3yOK+Uqs65UZV32pJqhmni7z6ehE5KG3Gkwcwy
	 h2HIoo94jzTBqUKsm34XbjekR92VVIHk9mRZdtSR9DOk1LnF9cW2f8fiqRPLGLYkW4yMH
	 qjImlVpv4LwcNI0bFuz4ohQ1DzyhGa6qVuaUjVc/sIGNMZFc8aqGwj+T6aR+VH1aHng==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793723148;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=wJNKxiM1RR8Nt30qb6ixH93YV4loyXSLX6/lXKLZxD4=;
	b=ryf4F8KasqN3x8QhAUOccEDPEUESUJVE54AFOZlt2kDUqkGHh/5FXovz+6yazzeK1mvN
	 o/V5wvRFWWS8tlwINsHnkCSdr3nFWwoUFMJVIrzPWPcK8NOJSvWECJG+nyNzYDCDlv5z5
	 1jANSk3vMK4pSz4/Wkt4Y3VZEuyFSVLYbU8bV8Y9yKJGOwWSoldf+WlrKeE13n4U1Ogcv
	 jPxq3Kfjr9qu/NM9kIjlzTEzeORiUOGwKrtJXKk2hC8B9l2zuhroe036Xp50CWccd6SDQ
	 vf2/+W4cGIAnYGCYniOVjeJU58z7U4xCqhSAD663s+xPbaphFdbO5rJ7fHBYmc0/xfA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id C94B31F00A15;
	Tue,  3 Nov 2026 16:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793723148;
	bh=wJNKxiM1RR8Nt30qb6ixH93YV4loyXSLX6/lXKLZxD4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=Pi2S/Y11alvDG6yV5Uqnu7QjI/9KqzDh+6EdfLHXtTLAMWKgxLD4S/r7K/bXu1lhk
	 zSp3wMP0+OxmvDiD73bR8YOYnueQ+yMeIuTJyE/8lH24PwqadopxkKOCUP/0RWHtAW
	 lqXtV77p7T6cUjh7mqkEFzdmAMtOTbZzP9oro10+y4B7jLgckU80W21j3Zoyl1iTfW
	 5KApVtAf9gd9bW6BOF6a4Dh5HQH977OduN2+WVsomdSd5Ig0XFmcWaryGTNIxdNxI/
	 dj18P8WvA+R7WMBn7SAR7Uxltz1TSp7vauOOMeYyQdbePiH0Ka1RbOSqd1TP8HsYyQ
	 nvEn9E3o73bfA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 5336F46A2A;
	Tue,  3 Nov 2026 16:25:47 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Wed, 04 Nov 2026 00:25:47 +0800
Subject: [PATCH v4 3/3] mm, swap: drop the swap cache guard and reclaim in
 swap_free_hibernation_slot()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261104-swap-hibernation-slots-v4-3-0ba9393609e1@tencent.com>
References: <20261104-swap-hibernation-slots-v4-0-0ba9393609e1@tencent.com>
In-Reply-To: <20261104-swap-hibernation-slots-v4-0-0ba9393609e1@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
 Jianyue Wu <wujianyue000@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Kairui Song <ryncsn@gmail.com>, linux-kernel@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793723146; l=1453;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=HPBYUP9MF3eSuiR7PGXZbC8XEUoasVA5Ed/MrXu8OwY=;
 b=4uNVtu2qFnk2q3Ro3dEgv6Ysy2ZgK5QDFSXGgJ3BR5URLa/fqYZSm2gIUkczc6q/+EjLyM7Pp
 boIUOm6t6rxBLDX/bw1typJvrJs67/sZAvugRsZ71of0Po6iNzyXGyc
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Stat-Signature: m4n4jz1tk4po7qwe1fxcnu6gkyoppty4
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 37ADAC0008
X-HE-Tag: 1793723149-390844
X-HE-Meta: U2FsdGVkX18pjrk0fLF18phPNFC27A1Dh6cJ3nAEpegqp9xuxE8uR0PgWMNWcX4bqjAJ8xp2ghWvKobqMR3npSTzZbEjvuNV37bsIYS1pjH+493EXjVblhxE85c7F8mrdNY7aQCgUGZXf6cqtlLXjMIlcrMCKe9PClmQR6LeZUvjnlHxfpMdjIBRLGN8MAsYi5TGs945p4yFFGtURh1fINKIHdwwTxg9Ny/1Ga4ToVQfDgNbOIIniVNkTNHzi8OVGXTqglPkvmcBkZ39HP7hmln9UaDdDcCmZiZ7cU4psZO0szsJKEpjtoC++IF142gSS3jxI5A60o1whycMUhn0WiLspK8JcetWGzHigyc+5ZAkAAq0rdbQwv9qWuJ++KBQBCV0PNCFbZKvSyt/1iME3nblY10xdkH593zSAulqYpfmg/O7SdN/NN8QQ+ijLtKQ60l+qMd+eLsgB16dXMmALifqmRCflhrVQcVO0Bo30UdDpb7+EQCrIWbo2sIb8dSgWvu3f8fDUHhOb9m3PMRMF/Xpct1i+E4vAtsRglaCvvzOT9wM2ESFW18qn4gD5kwmvB30jWYF0+6Et6N3xw8rfSOiYaKJtPuKaBtPanky3zLcF2qtsP43p7DGCrpKspaHQspGWqyPgrUb+tE4FD6Cn3VmutJcaCJKVbE9HPr1009BKwDTS4W501RFZJjIb6qqR4wxqazpl7RpIuO4Kth16MbqeCZO30iff6C88frd4sstgk+85Aj7wRpN7LbX6/CfCsbnlVuOQcLhFoT3NJRAPxwil2kyrmzujJoAW4ag1QpIgofTt/a8wp2OjdIHCV9P+tdmuA2bcRcGwwuyiiB+s9E+0VcC2nSdLG36PgzQzUHiPuW/Ys3W6xuYAYXdfVSkC9h33bp/NCdS+9RtCSMYBW8M1/mg2Z96ImS4NJ0/tILuDYR1YoUGbvmSZxMSf1ApyHdrXHSKS0DaaudLyP/
 9tu0PAaY
 v9u04VdLJps6vJD9l1Pmsvi70bcJ5RyhznkVle9wsNIHgcCHub523F0o+edOd0UPHJMjzapRuoQEs8ZocK+XYJZYTS74eugSj5+S4wSs+XsTB6YzTZNp+K4YMIH3/h8ZlhaD1hvN0jR7NHrMwf0y8mcJVGM1H24MmBUshwwbkOZVQBtblvxoMapdN8p3fzHp8RYFuLk5JYgzsHweOpz3RVDSDGmIo/Gs4BECKqyXdrt/eHcOauQw2xyxolz7mtMPMf5IsWgdEGs54HP+8pmL6tIimv3q3kSHVKH/AbLmlFtc5Ho959fhZv3qhNQfJBzn+i8Z3ki6Tz2FkT7u6SEINKF+uVdSgaMHbUM/Jx+EoMxTeywXmNbebiNjyshpeOHptpoD8WBWGqyrls7aEvoWgMjF9mNrnh1tAbx8dGRfExgEmfUCnWcWd2Wfz4N9QeL8KXBk1DrxijI6UP/K9+d2HNEUGyZ04AeEIk+J5HwziFTb/s15yVSREOCADoJ9qPfJ0AI7Ux4MI6/ZiBxmMTJ4WzFndIyFDpUWao0gI85u+/7XiVsNEED8i+Ts/2wnkozyAM11FBhWF5mtWq55zjTIsl2uNXg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Youngjun Park <youngjun.park@lge.com>

Both are there for a folio that readahead might have put on the slot.  A
hibernation entry is not a shadow and has no swap count, so the swap cache
turns it away and no such folio can exist.

Signed-off-by: Youngjun Park <youngjun.park@lge.com>
Acked-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index c26243140bf2..8dd2ba825413 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2227,18 +2227,8 @@ void swap_free_hibernation_slot(swp_entry_t entry)
 	pgoff_t offset = swp_offset(entry);
 
 	ci = swap_cluster_lock(si, offset);
-	/*
-	 * A slot with a folio in the swap cache is freed when the folio
-	 * leaves the cache, the same rule swap_put_entries_cluster() follows.
-	 * Readahead can put a folio here, and freeing the slot now would
-	 * leave that folio with no entry behind it.
-	 */
-	if (!swp_tb_is_folio(__swap_table_get(ci, offset % SWAPFILE_CLUSTER)))
-		__swap_cluster_free_entries(si, ci, offset % SWAPFILE_CLUSTER, 1);
+	__swap_cluster_free_entries(si, ci, offset % SWAPFILE_CLUSTER, 1);
 	swap_cluster_unlock(ci);
-
-	/* In theory readahead might add it to the swap cache by accident */
-	__try_to_reclaim_swap(si, offset, TTRS_ANYWAY);
 }
 
 static int __find_hibernation_swap_type(dev_t device, sector_t offset)

-- 
2.56.0



