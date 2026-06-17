Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F674CD98EE
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 09:01:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF2786B0098; Wed, 17 Jun 2026 05:01:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA31E6B0099; Wed, 17 Jun 2026 05:01:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB8BF6B009B; Wed, 17 Jun 2026 05:01:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B939A6B0098
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 05:01:52 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3DCA11A03AD
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 09:01:52 +0000 (UTC)
X-FDA: 84888812064.11.DA0277E
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7411B4000B
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 09:01:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ddQtveI3;
	spf=pass (imf27.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781686910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=QRmAg+xuFzi1RxjBmfejFM7dJeCpCksbcxaXlfltdno=;
	b=1b9Dpa1NjsPAFr0YfOwu3LYa2VYWHdt/4LA0veW3866yS5jeZXFcojh7Kn+NVHW4K6ogHd
	T+j29QAaBgKdgwvIvwiiUN2gWcAK0CWIiOHzNqDUzERlEsriaDFKilwvY35XEgb/cvX9M+
	utX5/BxK9ZYJ2l74vv3t+si3iE16N2E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781686910;
	b=QxZNKI/ZjbEsN97D27NFlLpBXVii3pU2eP0l8nAkyC4Wm1jyv4r697RgPbpn60jNKA2cBE
	SKelpy7FtB2S/PoNdloe/oTByZzd4hkkYsdpdFvJzcnNZu0Arco73ANuL72SnGRXScwBgG
	xn9P33FpohpY8CM5szOunC0opLiHMHg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ddQtveI3;
	spf=pass (imf27.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781686909;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=QRmAg+xuFzi1RxjBmfejFM7dJeCpCksbcxaXlfltdno=;
	b=ddQtveI3ogFiIk9LA7O2DTIuFGZZKvzdLaBaCtEUvnRFh8Ci1w6FhDN8xO4kXzG9qEP7GO
	TRqM2zaVEWI5+dgIl3X0tu+AQf4OuLER72gmcQ10QQVeEIo9rcWdumdCWWk1H/CpxNVDnm
	PgXBuqz7INSXsWl+H/ZZ2MI/a+5X1KE=
From: Qi Zheng <qi.zheng@linux.dev>
To: akpm@linux-foundation.org,
	david@fromorbit.com,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH] mm: shrinker: fix NULL pointer dereference in debugfs
Date: Wed, 17 Jun 2026 17:00:52 +0800
Message-ID: <20260617090052.27325-1-qi.zheng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 7411B4000B
X-Rspam-User: 
X-Stat-Signature: pu7ydyahbd1s9du9djabkcjy74ex8kut
X-Rspamd-Server: rspam08
X-HE-Tag: 1781686910-634712
X-HE-Meta: U2FsdGVkX1/wuQABZjdYWFHmfNsmtHT59J1OTdiSU4T14Fz9yNAkROf8hl3mKOh4PIv/glSNhGCIFvkHM7H29pVysyT+wkOq4Oir/1gw5ufw7mtIjQw9c+1rNQ3HfJA5+Mtm0c9eE6WdyMmctu9C2du4NQldGPbwAOhH+gK5s+EwX2JeCVo6hmeIHL0YxUBmG6Aw4ntVA7IMEqsfEh88mzPyAKn8f5TpfAI/TGeVtD5eJNudeksNMD0JpQOBsSxn1qtaTrbf8rsK0FORhgVfj50+t8kUjJJb9+bRIQVJgrlU2epTMru2zf8T04HpaWl0PxCczV3oQbj+jEwxl+C7t58Nt45sMarkRaGptVaSFEZLRIfcJYcuYxnVgr9AYJHdF5ceQwp5DBlpFO94lB91Is+6K5/hBARMOigXd9gBHvJn/2mY0wHWxLopN8QmGT9JzeMoBZr/gBs6FFBDZ9IDhEmaezSVr0L9S4mFcTbsKB3uQVFvd1xkQ4yYMU7le76k8jO5ibBNK9bl+SoEPAI5HE+XC8gsrJUXcpu+FJ9Z/BMUa5KCQBEwAbIQDCX9D7RV8ETEkDXJJ2hgFVhZ05xW3kNEDLUk62Yg7qaF3sl5tccI+PpXB7L7gbGJwk7YLzGIBe5X2H4n7IdaAXWtuWKrmIRHcYIwjt9/Adj7oJd4aVstaqPnVkbWrhQbPcz2WcCuLb9PyMQwmtGOaY1ixoxj989Jhw2VatZG7eI34WZ/d90r44nd2fvhGumJWUWh9jub0ct+GQZL80u/iBTuRlFElmvc3mnYDFDKzBgEKhPQqdmeihJ/WfVsvkSOkbbXlKq5dCNchZGtgo2i3nTO0AOyvl2gRVp/BoEFea6Q4RBvmgmV9OGVASqiP3ZI8E8KJy9IZ98NysC4C6TP/n6Yp9ox8Zs/i+cXTqueu+i+RSq1/f9polAo1cQaE4Nll0CkmDWvTcqWkeoFT9hDSR7UAnw
 APK+H/iI
 Lh4VAtqo7iJIDDyiHLbBPLuS+WLM+neX/SkuIYaf2IETOZWcXAoc65rvOhZp6SiEt/QASB32Ji96Foqgc1PAxewl+9t1AqmVoX/4E1pqXi38SZ9mGo7I4TmGPBHCpFYaTmp4HSLNOzqGomTWlCyWkhBQohnTzxurJIyPB4mMgUNPGG0C8byjQfCFJhy3iuHRkwhucU0IJEJBTcyTK1KFcqRMYtyT8s7RJ5INO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

The shrinker_debugfs_add() creates both "count" and "scan" debugfs files
unconditionally.

That assumes every shrinker implements both count_objects() and
scan_objects(), which is not guaranteed. For example, the xen-backend
shrinker sets count_objects() but leaves scan_objects() NULL, so writing
to its scan file calls through a NULL function pointer and panics the
kernel:

BUG: kernel NULL pointer dereference, address: 0000000000000000
RIP: 0010:0x0
Code: Unable to access opcode bytes at 0xffffffffffffffd6.
Call Trace:
 <TASK>
 shrinker_debugfs_scan_write+0x12e/0x270
 full_proxy_write+0x5f/0x90
 vfs_write+0xde/0x420
 ? filp_flush+0x75/0x90
 ? filp_close+0x1d/0x30
 ? do_dup2+0xb8/0x120
 ksys_write+0x68/0xf0
 ? filp_flush+0x75/0x90
 do_syscall_64+0xb3/0x5b0
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

The count path has the same issue in principle if a shrinker omits
count_objects().

To fix it, only create "count" and "scan" debugfs files when the
corresponding callbacks are present.

Fixes: bbf535fd6f06 ("mm: shrinkers: add scan interface for shrinker debugfs")
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 mm/shrinker_debug.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/shrinker_debug.c b/mm/shrinker_debug.c
index cda4e86428c8..cafb56630132 100644
--- a/mm/shrinker_debug.c
+++ b/mm/shrinker_debug.c
@@ -183,10 +183,12 @@ int shrinker_debugfs_add(struct shrinker *shrinker)
 	}
 	shrinker->debugfs_entry = entry;
 
-	debugfs_create_file("count", 0440, entry, shrinker,
-			    &shrinker_debugfs_count_fops);
-	debugfs_create_file("scan", 0220, entry, shrinker,
-			    &shrinker_debugfs_scan_fops);
+	if (shrinker->count_objects)
+		debugfs_create_file("count", 0440, entry, shrinker,
+				    &shrinker_debugfs_count_fops);
+	if (shrinker->scan_objects)
+		debugfs_create_file("scan", 0220, entry, shrinker,
+				    &shrinker_debugfs_scan_fops);
 	return 0;
 }
 
-- 
2.54.0


