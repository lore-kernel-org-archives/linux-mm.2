Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD0FBCD98C5
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 23:21:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB8066B0005; Wed, 10 Jun 2026 19:21:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D68F06B0088; Wed, 10 Jun 2026 19:21:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C800D6B008C; Wed, 10 Jun 2026 19:21:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B59AE6B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 19:21:14 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4A81814033A
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 23:21:14 +0000 (UTC)
X-FDA: 84865576068.19.F88A972
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf16.hostedemail.com (Postfix) with ESMTP id 27EDB180006
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 23:21:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KxhTTE1R;
	spf=pass (imf16.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781133672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ZKdrW8MSyYpUdE/yN9cJchnfw0mivcsg5Esu2sk15iE=;
	b=2+3BxbRjildNg1L1VCsIDWS6978QeSDdhvTi1QtcjY+mfV/E8tTD0DW6Ka87/wzXm4LS0I
	sZMVQdF+FTldtpn1nDkOYHe6bL6BCJTWwdX5tDBRrfU3EBfqttyz+7634HcrWu8uaLzOwn
	BXc7LiqbAR/Moc+JDLF7qvukSU4wnOs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KxhTTE1R;
	spf=pass (imf16.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781133672;
	b=3IHo6m5baqCO9g9ovC1WWnTblcuAOWiIRLUqY1W0tYRVjQLMc/6cN2v3zyJ313nqvhUSQt
	RzcDXYuK5JB9z2/5/egixCdtAtJhpV0AydDf60V8XzNIyX+iZNOTJO/BhS3KTVyOFes9YN
	H557+sU1JB7c7ruP2HBHJIgdvGPClUc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781133669;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ZKdrW8MSyYpUdE/yN9cJchnfw0mivcsg5Esu2sk15iE=;
	b=KxhTTE1R84GXIzfi4AjA0QLkq2hACD5bG8AXTiValPDgZx4utDK4WqZFdSxRWhDoCo4ePW
	4bCMi1guYsCXdEiHJX8D79uE04PxfTQwPCF9oiyK++rzdKYOiQXS99nxam2krxIS/jBS3E
	yLMj+lGFa1MDkzN2hJTaBfktTRoP5XU=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Zenghui Yu <zenghui.yu@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>
Subject: [PATCH] mm/shrinker: do not hold RCU lock in shrinker_debugfs_count_show()
Date: Wed, 10 Jun 2026 16:20:48 -0700
Message-ID: <20260610232048.62930-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 27EDB180006
X-Stat-Signature: 8c3igxu1mfwmmuahjztqm7joeye19dxp
X-Rspam-User: 
X-HE-Tag: 1781133671-426369
X-HE-Meta: U2FsdGVkX1/GEDN2cm3m3V7lYfjFZcaRVy/nhKvvv2TvWaKW9i3ZED4vIYPsHZFnBSjvCk4e4OJHdF5tKvHUuttgXIyUohEXX7RJOirLlbHexKyZ5j7d+iCF6UBqOC4EtegzUbwB9pLcAP/tqzWJlV/relYBbdkIaBzKAuBLTG+u7i+tc044t6oOAp0NOspHoDfoRvYMkrzcBAuVH1bkar++Vin4WfJEprBscR8MwuyF9SwZu8dT01uQdIvtiZ/iwHwvliC9lcA6VGJsTZ/kBFPnaDJ3dywaSjovg/9IYZWHnU3CU3OXQh3zzAmGat9xBKXDA+PYlUgK50N/iXrxZLBy1J8NSxlaH58NS4CviIJEICV3VcK/RvD9cmQU1hAOi/gUcfjFpMB2aux+Du//UJ4Isbd/WmQrSB8yhRRp1K2v/WgcnMmYqrdmNfQ2wQ+h9gRHnI4gT8XLzA8e9seDah14YlEzp8rcnK9xlHgUWZ7UNoXUA0Kw8xsxi07oyH9Th9J0DJ/tMA0NxdnUvMqYSnmkCsnvNEAzwPjBJk3/8EswMOX+p1G870RLlCN+ayXORQCz530ek6J7pH+FaRaz05dnj0X9WV6LmTEnFnvyT57P1sDhb6OoeMEjlk5S0O5pfItkdyA5GmmcY0gJIXoLx6/8rVCLuLmM1zFYX+UCgtLg8M0+z8IsTEI2ckrmB2I7klfnt1+EFo8GoRQ/by6TxG1tZUWBUQcTe6TRxt4oZq2lARAPuRwHA6xi4wTrtHimVnbhShr9qsfl2BnpOfdSYBvThfpNrnch7Vt4mXNG6Fwo6ZMbK9DdfhP43NwTf4xEX45BTRw9NX6GNIJ3Zov0x0NeszhPE6Ljoks2w2e+274Bcr8FLWv1eJ78B1t8fYm/BSYaQHgy9Dd5lylidemtFEBhcUgITQrABmzyvKc+thEmjRMWDNWSSnh3T5n7u/9Qd6QsM9OzRSbpInluIDA
 bvaeST/6
 j7kNupiCYa8b2wlSiHeXDbJ6Ul+LlyvjG13AJiw3BTu+yvOjWXDD3t8L1tiMdCER8mYQPGaSyWNt0Uwq126Uf7mgXIRiRyU8t34msNWnUv/jCnGeiTwPdfbM+Zxe0Hg5/JEUUBOD7KYw6+xmoFXWDeAqMH8cg9JKeCUW25wany/a/OYdCknsti4lZhF/oTPaQq9CjhpdSNeORMxPZvmHZrVtiwcjae/EH1oZiUeh5s3xhsqzky77sndfJ18JUi6e+YBl3DV+9wOYQcINfOgeQBYK271BaZUxsVO2faSG1ZyzVwGw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Reading the debugfs "count" file of a memcg-aware shrinker can sleep
inside an RCU read-side critical section:

  BUG: sleeping function called from invalid context at kernel/cgroup/rstat.c:421
  RCU nest depth: 1, expected: 0
   css_rstat_flush
   mem_cgroup_flush_stats
   zswap_shrinker_count
   shrinker_debugfs_count_show

shrinker_debugfs_count_show() invokes the ->count_objects() callback
under rcu_read_lock(). The zswap callback flushes memcg stats via
css_rstat_flush(), which may sleep, so it must not run under RCU.

The RCU lock is not needed here. mem_cgroup_iter() takes RCU internally
and returns a memcg holding a css reference (dropped on the next
iteration or by mem_cgroup_iter_break()), so the memcg stays alive
without it. The shrinker is kept alive by the open debugfs file:
shrinker_free() removes the debugfs entries via
debugfs_remove_recursive(), which waits for in-flight readers to drain,
before call_rcu(..., shrinker_free_rcu_cb). The sibling "scan" handler
already invokes the sleeping ->scan_objects() callback with no RCU
section.

Drop the rcu_read_lock()/rcu_read_unlock().

Fixes: 5035ebc644ae ("mm: shrinkers: introduce debugfs interface for memory shrinkers")
Reported-by: Zenghui Yu <zenghui.yu@linux.dev>
Closes: https://lore.kernel.org/all/c052a064-cddb-494f-a0d8-f8a10b4b1c4d@linux.dev/
Suggested-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/shrinker_debug.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/mm/shrinker_debug.c b/mm/shrinker_debug.c
index affa64437302..cda4e86428c8 100644
--- a/mm/shrinker_debug.c
+++ b/mm/shrinker_debug.c
@@ -57,8 +57,6 @@ static int shrinker_debugfs_count_show(struct seq_file *m, void *v)
 	if (!count_per_node)
 		return -ENOMEM;
 
-	rcu_read_lock();
-
 	memcg_aware = shrinker->flags & SHRINKER_MEMCG_AWARE;
 
 	memcg = mem_cgroup_iter(NULL, NULL, NULL);
@@ -88,8 +86,6 @@ static int shrinker_debugfs_count_show(struct seq_file *m, void *v)
 		}
 	} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)) != NULL);
 
-	rcu_read_unlock();
-
 	kfree(count_per_node);
 	return ret;
 }
-- 
2.53.0-Meta


