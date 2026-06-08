Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02AAFCD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 03:43:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 299116B0093; Sun,  7 Jun 2026 23:43:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2703E6B0095; Sun,  7 Jun 2026 23:43:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 186476B0096; Sun,  7 Jun 2026 23:43:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 06EB16B0093
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 23:43:04 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A3E1E1A08B3
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 03:43:03 +0000 (UTC)
X-FDA: 84855349446.02.7D2B285
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1935140002
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 03:43:01 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D41Iapm4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of yukuai@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yukuai@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780890182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QSu6XsEiboRL19rJVWEiFsNcMRrFU8VXRLqsphg+RLA=;
	b=F4FGFLNHPSW8rg0zitaPO0q9528D6NJWnvk9b+xjV8x3hqe5ialGODGNR2t9a7mW6fRy3G
	xi5pL18ye1bipkAPx3nz3hdin3N+NoW6pIEVJt6K3PO5bCsIX9kNde7VHCgdGm1ROorPo3
	jRFFUx8qMQz41VSEWNRI1S+W5EehXY8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D41Iapm4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of yukuai@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yukuai@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780890182;
	b=Ueb5vv7a6yW7YDAe85ZYbczrnuljTp5O9KSytt2RbJI1AH1kaLmyBKY7KJAkV61BjFunJK
	tDZK7kCB9SKmCPWoqu5h/2ryLJ3GNVJ51wc/EbVuRn60LVXVT6zSVxNIzEo09IpiAe/2Wy
	V7Vi3t7HRDnCwtILdRcgQ+HugxuwpYA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 786BE601DC;
	Mon,  8 Jun 2026 03:43:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C1F31F00898;
	Mon,  8 Jun 2026 03:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780890181;
	bh=QSu6XsEiboRL19rJVWEiFsNcMRrFU8VXRLqsphg+RLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D41Iapm4tXqr9Ba5E+mBBRULkFhOthmZ/kCNgUh3KHXBEZtxqOUL0uh0RPVQUrrLf
	 aA5985WZ0YdB/TPxUgWPK8zWajdGX1N75ign661nUvcGvVuB0WXesX4q6eiDHqy9B6
	 poYoWwIwO2P8VgSsJ8ciii49If7XvmzGt5cGiXw3XJznRsQG44tp3dilXRKXECWrZT
	 KVTPsCpl85zbSYKBhvwd0uZ10Lpmh3V3QzFYEHG8Jp02aYAEHFothj/C6y2cgSyvvn
	 /CVeoPr/Jmbe/1mamqhptaWQaYqlPKhooc1f1aQCGZI0DIRWJtmRQj5tyOFfZoLWTL
	 qJjenKf+xAcXg==
From: Yu Kuai <yukuai@kernel.org>
To: nilay@linux.ibm.com,
	tom.leiming@gmail.com,
	bvanassche@acm.org,
	tj@kernel.org,
	josef@toxicpanda.com,
	axboe@kernel.dk,
	yukuai@fygo.io
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/8] blk-cgroup: protect iterating blkgs with blkcg->lock in blkcg_print_stat()
Date: Mon,  8 Jun 2026 11:42:42 +0800
Message-ID: <05799877e720dcd300e2ddd4625e8e162959d7cc.1780621988.git.yukuai@fygo.io>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1780621988.git.yukuai@fygo.io>
References: <cover.1780621988.git.yukuai@fygo.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: aonyt9wzxksktqufeowjqpb6nuw8tq9w
X-Rspamd-Queue-Id: 1935140002
X-HE-Tag: 1780890181-751159
X-HE-Meta: U2FsdGVkX19Xo21QIcYddHMdD5bk6KfT/PSSUDuwuNrQfEA1ADOrovNd1GQCutV4K0phZz0FKU68eNdz/zGCUuCQwVFNjVVjsLb8NINeNJ9j5DvSB2qXwlaQgIaaAb5S1STKCB8Ab+Q8JvojRkhxsJDnTJwTWmW6J1zY5piPorMy/viIzCYRk5k41O3MT+NH84KbGbiaBrfRgwHHuOipMbtw7Nu2mFZzlEpGGfReUD3X9Wtwtgi4fSU3gPTMySvUJvDDFP75UCn7/OaJ9SJoRwaqoGqZ0e9cp6TwJDC0Hzui4Umx9BhnJEHtwaXws5MN2B+0T6IgTiBMNFtO9E3faD3pbPWZU3k0FMaQ2woUQI81ZxL5gOilc0h6HdmjIEjWlLUO2d/GWpBgU6waGqfQh6fDJHnrGrUXTUhF+523MmdfWqs32GdE1RyQu8RVKRW8AFk8p8qiFT9iXNZ1MyLtJb3YUiI/9kDWpiTlQyFhH4iAQimEb4kUUFzaGve8I8lHFhZ44CdifhhZy9x4LCOEOjJC3xwMrahzAvGtyXc1vkXVGFeAIPOhBNQS3xJrf1pi6dXevhi3hJva5ftvBxRFb2sQKq5W66MUXMbzwoLS/rreIATzzmk3gvCFwkpuaUeSPbsuV7BHsF4W8Blwibs+fbalWM6RhiJtiJaOJG1IuyDTb2WLaClEk0GNl2rdyWy73akI6hdEdlvuBysbZefZ/S2E91OWZNfRzej//ql4jYo/eIKNGq22fE+/4sA+5Z5SW3N86R5G66aqziIqMVT3QjBr6/hbKkmuzge4aM7ocTtE3Ua5HTEsdhnD9HJaXTVWzHqFqvA2vEXQN60IZqb1P9nIl/3w22cklrVbIR/ZmYXV2ojvKw73pOzrIVa7luYa+gXv/dbjFy2Ipk79yMgPetfTx4Ji668G/wV5DwpsZM02ILcWd6HDHW3RkupIInjPrg/SYWBevUT1syRHBWv
 JqLdWkXU
 +Kq1xAzxOcSJmIEJpg2B/319vOz6U2qV68HehSifu5xyWJmcj/LyUPXody3s5wx+/fmJNDXNaZvjjpzDWEakKOXbVM8he0xyjjjtNo4t4IpzY9cUm/4mG1LbwxiKe+IxbROwiNzuBbrxIbDvGFFpniyZZf+aHIpV+d9VHuuswlcpUoyco+cQWlC7oc+DXpJjsKr6AZRcXq2GY/UHA0fc7O4h0Tz780OFqydSlTgVjf5e550pHmkD4eDOvU8k0niDGOdTZ9E7XjlQzdjzqLBCHl7AYwFtqMlXp1s6o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Yu Kuai <yukuai@fygo.io>

blkcg_print_one_stat() will be called for each blkg:
- access blkg->iostat, which is freed from rcu callback
  blkg_free_workfn();
- access policy data from pd_stat_fn(), which is freed from
  pd_free_fn(), while pd_free_fn() can be called by removing blkcg or
  deactivating policy;

Take blkcg->lock while iterating so the blkgs stay online and both
blkg->iostat and policy data for activated policies stay valid.  Use
irq-safe locking because blkcg->lock can be nested under q->queue_lock,
which is used from IRQ completion paths.

Prepare to convert protecting blkgs from request_queue with mutex.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 block/blk-cgroup.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index c75b2a103bbc..b55c43f72bcb 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1241,17 +1241,14 @@ static int blkcg_print_stat(struct seq_file *sf, void *v)
 	if (!seq_css(sf)->parent)
 		blkcg_fill_root_iostats();
 	else
 		css_rstat_flush(&blkcg->css);
 
-	rcu_read_lock();
-	hlist_for_each_entry_rcu(blkg, &blkcg->blkg_list, blkcg_node) {
-		spin_lock_irq(&blkg->q->queue_lock);
+	guard(spinlock_irq)(&blkcg->lock);
+	hlist_for_each_entry(blkg, &blkcg->blkg_list, blkcg_node)
 		blkcg_print_one_stat(blkg, sf);
-		spin_unlock_irq(&blkg->q->queue_lock);
-	}
-	rcu_read_unlock();
+
 	return 0;
 }
 
 static struct cftype blkcg_files[] = {
 	{
-- 
2.51.0

