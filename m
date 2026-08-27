Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42604C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 04:29:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 176E56B008C; Thu, 27 Aug 2026 00:29:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DA886B0096; Thu, 27 Aug 2026 00:29:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D35076B0092; Thu, 27 Aug 2026 00:29:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ACB426B008C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 00:29:32 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1D480C02F3
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 04:29:32 +0000 (UTC)
X-FDA: 85145770584.26.36CB7C6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8BB1940005
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 04:29:30 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=izYrMHPw;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787804970;
	b=W1NPDky8J9DBVaT0VTmz9s4IoCFw3cB/rJthySiadK55YYlohc12CbJFqTZtv4K2L1TgI/
	5M0w4egp3uzVyfBO5rw4gpR3DpuToUMi6s7xGg+aLjUp+wjXphWIfZR6pple12+tI8FxPn
	0LlQIaWHLReYENN3wfVmw89gKraivJI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787804970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nERbAFEHHSw5ax7MRWud0rpkMohS2ci96UJ8OD+KyJc=;
	b=N6oY3YgxYayHP0X3vnt+zVmRCuS03H+7PZ5VjZMS76E39674Mm+2iLr1EW80M0pfNvfHry
	y/v2Tj/oWOfgs5EHtINAXsTmzO1WMf+9XCubN9/l4uXsmEotXJ5dsyaHzHmB0BjHDymIqF
	sixVNxxfam+YxvQLXJRjnTon5904PD4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=izYrMHPw;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1AEA1600DB;
	Thu, 27 Aug 2026 04:29:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FF341F00A3E;
	Thu, 27 Aug 2026 04:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787804969;
	bh=nERbAFEHHSw5ax7MRWud0rpkMohS2ci96UJ8OD+KyJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=izYrMHPwxZ/T5mohTVMD2kb/EMqa5Sw1xgHZkTwTlhGJXkBmsvABfHygDlg84j6ry
	 RueknLBCEZsnFp53JM/LEDbEMLrOb6zFh2FHV64Qer50CtGPcbnjnPAzGRuqKBPBu4
	 0fij/rL9wBRUJOzRG5fDySXAvMbil4F1h/J1oo5taORYj0Vqb2OrZY1Axz5UiKcCMK
	 0dLPK/8O3Xia6oTGIISTWtU7e7aXGERZuNtsa9AzZwtciEBXNy6Ntb+fA0g7cjR1OO
	 3svM2t9PAz+hdYacgQaho2YIQT1+SRnsdveN2DRY5Rk8nGMcXdTbOP45kA+Ow0VsOd
	 EMBggIeJ1YlwQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/2] mm/damon/sysfs: set next refresh jiffies per sysfs context
Date: Wed, 26 Aug 2026 21:29:19 -0700
Message-ID: <20260827042920.93580-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260827042920.93580-1-sj@kernel.org>
References: <20260827042920.93580-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8BB1940005
X-Stat-Signature: h4dgnu4fkqm6ejqfxcen317uucqsic4n
X-HE-Tag: 1787804970-208829
X-HE-Meta: U2FsdGVkX1/+RA9W1grQfEC1VshOIpgOlGhex/S9cvps23AHgraxzCVIXX47T/K+uPuvxoZQo/zXBaGhwjvqlqqUX17ThrtmTmeL+l0PblVmDMP5A8/2LflwT1cTZ9i+xShveCODZ5pETUl/pInLHamzthUQkXCX5es3R5Ss5h3pRsgad74fOyNiAkvihd3EF5CYzEzfm5iJ53d7evzuEuwZmYnuUV5/wCNPkLMk8scRELwl9m9e4dqphfCLJSFmaDgkl5j5AIcTV0h7oDuY2/hEzN9K+ds3+cM5oa+xnPI1nwM6gQwoBicus0uhw3bWCHKgpbEzNQ5prQblzM3pHLgvm59AxuauvoFSxcAgTYZReW5TDv63nTl2lnl++KIVl/4T3UUYx7t4lTNNBrbhhtsGXcJaQ7eMwkJlXp9e8AxPDikIe6ugkLw2sUvQ42FWWmOxug+cLPxEMsqznvA1FZ1IpT99O+yiHZXci9JpcCeZi/kuqdCAU6684TtqcPIq3l7lryz58COf/gR4CKUuPyGUksYrOUS+I6k4r7pkBIq/4Zfr+d8oPhYOqes1Vm7Jpgtc/afTG+tGYl7slFlIvyLcMYuJmcMsRIr/dFJ5RviBdylFavLmA6oYuiFjMojOHhG6seZOEFybhEaVbFVpxWp3gQqRiJpvJAMyEiNvj8um4yimcBPriyT2XZ6bEA3u/cYmZlU5Tr0gDSNvgPmtxyw+fiCgwsSPggxGjlUm8xikcDPDLJ344LCR2SVG6l1mfrYboKpB+W6iZ9NQ/k9nmctN39p+J+J1yLFaKAfmLdjMgeaXDRmXn19BmXh8R/yE2WHiNrFNWYquEBSp+gWmpEYqs5SG+YBxfra5cKKgNlfFo87XJ1LlTDII4U7Ds4th1YsiPWSPCBwqNDVTaPEeYzkJwsX0n+mN450p0ye6yYNcvwxH1RfEmLwInHiVVQ0CwqcWExSSm/eCJMkpfFa
 9VuJdkUp
 IoSkyCkL7pwO9sxy3SINhVoofDPutmY3Ld6xYX66sGDRlohZI7n/4AeXixYwMAW9+m7ljuX6pG7hvIKIsSYq1iI9DP8qm0B1ymy57wjUw4zVdShMIH9xlHQcjpBYPEUNSI5M1t+XjFLnkxLH3qGt30P1xAgwucUxLbgyJaFUZOb/I19fRsPHIqz1iJ/Xg2JR3eKgSymBzlgkT5KIIpSXUqN+Yrdg1/eZN3aOxuTQfZ5fwa/I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When 'refresh_ms' is set, DAMON sysfs interface periodically updates
auto-tuned parameters and DAMOS stats.  The timestamp for the next
refresh is initialized when a DAMON context starts, and updated in its
damon_call() callback function.  That is, each DAMON context updates it.
However, the timestamp is a global variable that is shared with all the
contexts.  When there are multiple DAMON contexts having different
refresh_ms, the update frequency will be changed, depending on the order
of the contexts.  When there are multiple kdamonds, it will be even more
chaotic.  Fix the problem by having the timestamp per each context.

The user impact is not very critical.  It does not leak, corrupt or
crash.  The update will not be faster or slower than the lowest and
largest refresh_ms values of the contexts, respectively.  The user can
also manually ask the updates on demand using kdamond state commands.
That said, clearly this is a bug.

Fixes: 9fd7bb5083d1 ("mm/damon/sysfs: change next_update_jiffies to a global variable")
Cc: <stable@vger.kernel.org> # 6.18.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index e3858ffab4b22..f05b256c90ee7 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1789,6 +1789,7 @@ struct damon_sysfs_kdamond {
 	struct damon_sysfs_contexts *contexts;
 	struct damon_ctx *damon_ctx;
 	unsigned int refresh_ms;
+	unsigned long next_refresh_jiffies;
 };
 
 static struct damon_sysfs_kdamond *damon_sysfs_kdamond_alloc(void)
@@ -2215,17 +2216,15 @@ static struct damon_ctx *damon_sysfs_build_ctx(
 	return ctx;
 }
 
-static unsigned long damon_sysfs_next_update_jiffies;
-
 static int damon_sysfs_repeat_call_fn(void *data)
 {
 	struct damon_sysfs_kdamond *sysfs_kdamond = data;
 
 	if (!sysfs_kdamond->refresh_ms)
 		return 0;
-	if (time_before(jiffies, damon_sysfs_next_update_jiffies))
+	if (time_before(jiffies, sysfs_kdamond->next_refresh_jiffies))
 		return 0;
-	damon_sysfs_next_update_jiffies = jiffies +
+	sysfs_kdamond->next_refresh_jiffies = jiffies +
 		msecs_to_jiffies(sysfs_kdamond->refresh_ms);
 
 	if (!mutex_trylock(&damon_sysfs_lock))
@@ -2273,8 +2272,8 @@ static int damon_sysfs_turn_damon_on(struct damon_sysfs_kdamond *kdamond)
 	}
 	kdamond->damon_ctx = ctx;
 
-	damon_sysfs_next_update_jiffies =
-		jiffies + msecs_to_jiffies(kdamond->refresh_ms);
+	kdamond->next_refresh_jiffies = jiffies +
+		msecs_to_jiffies(kdamond->refresh_ms);
 
 	repeat_call_control->fn = damon_sysfs_repeat_call_fn;
 	repeat_call_control->data = kdamond;
-- 
2.47.3

