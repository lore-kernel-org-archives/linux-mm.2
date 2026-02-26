Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4EB2FD9E1A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 22:23:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05EEA6B0190; Thu, 26 Feb 2026 17:23:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 009C16B0191; Thu, 26 Feb 2026 17:23:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4A8C6B0192; Thu, 26 Feb 2026 17:23:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CB7686B0190
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 17:23:14 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6C28156E6F
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 22:23:14 +0000 (UTC)
X-FDA: 84488034708.07.0F695AF
Received: from layka.disroot.org (layka.disroot.org [178.21.23.139])
	by imf23.hostedemail.com (Postfix) with ESMTP id BB217140002
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 22:23:12 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=disroot.org header.s=mail header.b=VEjBiX7K;
	dmarc=pass (policy=reject) header.from=disroot.org;
	spf=pass (imf23.hostedemail.com: domain of mcq@disroot.org designates 178.21.23.139 as permitted sender) smtp.mailfrom=mcq@disroot.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772144593; a=rsa-sha256;
	cv=none;
	b=vua+0rBfI9TlNetLf5Q0SW51ttxedJnE0X4pszNxrK1IraFcQhl9KCZ3njnVxrq3em5IOS
	6fmO8/3aLLV12ynpXpPHT60YDpUAeFEacx6IpkLoUb2vqwAGVaczILGpsEyDflu3R6t8Pr
	5Nr501QcxWrUS9MDXWTpzlW226vqfJw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=disroot.org header.s=mail header.b=VEjBiX7K;
	dmarc=pass (policy=reject) header.from=disroot.org;
	spf=pass (imf23.hostedemail.com: domain of mcq@disroot.org designates 178.21.23.139 as permitted sender) smtp.mailfrom=mcq@disroot.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772144593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=VYBAWAfVrRhC70z6alACWnJa/G2uqG1LwnT04sKmifY=;
	b=yJXu8pCcAU2iHmwIzGKa5dQniwzACkCBJsXBTN7m4fXou+1wSL37AKKf/PZsM3E+wlBtJB
	qTUYhiVA0xEoq+MltiJwsOV2mnGUzM3bSeC+YXUGv9rO4p01e0TerhejzXC1A2SlUGyS/l
	PzEOdm28m1wleCFOMauUt/xvgtzCH+I=
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by disroot.org (Postfix) with ESMTP id 9B8952620C;
	Thu, 26 Feb 2026 23:23:10 +0100 (CET)
X-Virus-Scanned: SPAM Filter at disroot.org
Received: from layka.disroot.org ([127.0.0.1])
 by localhost (disroot.org [127.0.0.1]) (amavis, port 10024) with ESMTP
 id CbaE-xR9lXVp; Thu, 26 Feb 2026 23:23:10 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=disroot.org; s=mail;
	t=1772144590; bh=VeWQNZuF3GodHUOAGR4MKmiuZROjs+XpxXoFLAB/Rw8=;
	h=From:To:Cc:Subject:Date;
	b=VEjBiX7Kin174vBmtZiZyEVT6fT+zbstSrNpvi08NaCuanFsUdK3gp/jKvFQsPIbw
	 pnKNrlFoQYhoauU6+EADw1Lf6C8rYqSXSJ9IQzUdLSbR6lMie6nyXProMfCxVQS/GA
	 6YL1LNiGghz3pqmL3vZoOlB7FDbl+tGOlXbJG6GxOhJGVt9A/1hw9phvHwLMoXd+jZ
	 ra48h0wxygrv1T3qz5gO1m992NzwP+H16Nh3tQM1Nblz7Ee/IbSGvF8d/MWR/N+fpi
	 KPuB3k2CFtKYSTCLW3IaOcsCB+J3TWLnwQtEzaHpE77WgE8opiXZti8jG5xabgBgZ4
	 cxnzTU2H5fDeA==
From: Benjamin Lee McQueen <mcq@disroot.org>
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Benjamin Lee McQueen <mcq@disroot.org>
Subject: [PATCH] mm/vmpressure: scale window size based on machine memory
Date: Thu, 26 Feb 2026 16:22:46 -0600
Message-ID: <20260226222246.4618-1-mcq@disroot.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BB217140002
X-Stat-Signature: sj6pg7hbkp1krdc6qsczqxqgaeg5bj9r
X-Rspam-User: 
X-HE-Tag: 1772144592-290397
X-HE-Meta: U2FsdGVkX1+j+BHYJ30mX1qktUHdIMSRx4ZPRojolkchOTlqqWa7PQab9FrgDe3/2/r0caAPAQqGZmiiEOiWiLweeyysyrbobOugK/j4vrM3lsQccmd8R6DH32BgBaf57CTmfUvVyuAfsjwW5zKbdw4936ArlyYJ1LviqOvgHoCX744eoF172PiOWGfjUhsHje9ss+qETmTrEZEocWATPZ6BIiyUl0WWauRHK+yDB4XP5j1vgtPblFze8MDnweHFMQuqDaRToaHpuJtHp2I0TqVlSgUmCHbj2QvQ+QzQAVpRRP5OOvXaevasHuKVpUOZFPmxatQRk/YZv99lxws0sT1uj0kBWeWHwZ9FeJBvntnnUV6vyHm1qiyWJz7/M6poobIaifWuxlge/2uiwAUEG0MEcdWA0i6tKu72NdSlBa4kpQSZJdDozUZqp9Fvgd8phqn1vcWvNqLWZbyUFY1AJA5yVb28eOL0tK26cRl7GCYZ2Roxd4VtK+6J5vMQ+aq+qzomgKuu1l3cxv5tOH+lmAAf3/Mzw+j2KDtLsY+pa3ih4Uz/E11mBTxfBXZt7E3qNx9jF8/tU99dbyRqQNlNjUELf+B//iTjvFNd16GyzJti1bp7W4OH10Wk3KgYZQxVhaz5hzopuC9rOMeQ2MJ2pJngzfHuOHZTEdwDTfFVF1CE7nGpNg0aU2pDIXklCfs3FdlZkAQM8KSECz+UPgNA66622Qf87+j4c0aY008mMrgXx/XfjIBm4Nd9N/hoqi8sSfifJlhzKF1OPciYHnxl98jTh7/S3bmstLYCDkRHOwxw3/uIutu8UveXoETGqMSBA5AF6UiLQwZ02bAAF9HKcVillgohdLzEqvPCI/RvxMxI5XIGSmUIdLOaTIaJIM35NkLl3RQ1PSnIbcOmSZQzBsLbW4RNUH2GogMQnHKlt/EAxC5h+9M8XuXvMdwTx6ac
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vmpressure's window size was fixed at 512 pages regardless of machine size.

This fix, from a TODO scales the window size based on RAM size of the machine.
The method of scaling is similar to vmstat's scaling but based on RAM alone.

Signed-off-by: Benjamin Lee McQueen <mcq@disroot.org>
---
 mm/vmpressure.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/mm/vmpressure.c b/mm/vmpressure.c
index 3fbb86996c4d..1d7b5d9e4351 100644
--- a/mm/vmpressure.c
+++ b/mm/vmpressure.c
@@ -32,11 +32,20 @@
  * As the vmscan reclaimer logic works with chunks which are multiple of
  * SWAP_CLUSTER_MAX, it makes sense to use it for the window size as well.
  *
- * TODO: Make the window size depend on machine size, as we do for vmstat
- * thresholds. Currently we set it to 512 pages (2MB for 4KB pages).
+ * The window size scales with machine memory using logarithmic scaling
+ * Smaller machines get smaller window size, while larger ones, for
+ * example, get proportionally larger window size.
  */
-static const unsigned long vmpressure_win = SWAP_CLUSTER_MAX * 16;
+static unsigned long vmpressure_win;
 
+static int __init vmpressure_win_init(void)
+{
+	unsigned long mem = totalram_pages() >> (27 - PAGE_SHIFT);
+
+	vmpressure_win = SWAP_CLUSTER_MAX * max(16UL, (unsigned long)fls(mem) * 8);
+	return 0;
+}
+core_initcall(vmpressure_win_init);
 /*
  * These thresholds are used when we account memory pressure through
  * scanned/reclaimed ratio. The current values were chosen empirically. In
-- 
2.53.0


