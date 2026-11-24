Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AFCF606A330
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 15:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JAjjkP6H
Received: by kanga.kvack.org (Postfix)
	id 29DAF6B0769; Tue, 24 Nov 2026 10:36:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24DE96B076B; Tue, 24 Nov 2026 10:36:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 163686B076C; Tue, 24 Nov 2026 10:36:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EAC536B0769
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:36:55 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 86F0B80BE9
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:36:55 +0000 (UTC)
X-FDA: 85470415590.12.A024370
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id DD66C18000C
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:36:53 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JAjjkP6H;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795534614;
	b=nPpzwKLIqOwGCRM9Iepg16ar/vCATmKKqjtyefd/Svge20KoLMWE2v4JP934XtDbxrefhx
	FNpt8tV1wHsrtWJz0yZcYiN4SgaEq00C9PfwTJ7SPiwzGHy7/pTfHy1Upjspf/ABzgm3MD
	+MkHaS7Y2p8eiNyG9HxtRpk3yB1wvRc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795534614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=biXTWaSvJqqpcUUoUjddCAvbnOUyLvQxAIn/hPXuU84=;
	b=Pa2kpRDw68vzoDkkwbbgC8vx7ovUv5e1OGinDSu5aezuuA3YYDSj61YSV/d0t93stucGR2
	5olILAgr5RjQPdxXi3EvkqxX3GSpY1mNMm9bBkNLXG1ay7mxQ8MEPYkbp3F9wUS+3r/AAN
	8wA5HS+nUPc5eGTuI8rqqVNyd0BcOHM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JAjjkP6H;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7FEFD6271E;
	Tue, 24 Nov 2026 15:36:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8219B1F000C4;
	Tue, 24 Nov 2026 15:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795534612;
	bh=biXTWaSvJqqpcUUoUjddCAvbnOUyLvQxAIn/hPXuU84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JAjjkP6HpBkGxa67ba014jvwH2+hY2PZmDcbEUwv8Tt8O0BccP3/QCZ8u6l5hmLG7
	 eIKc3LzwyJ5uKEd7k4AMLQkma2bYMNcnQE5+2o1V+WFs3qVzFywkutSfnFm7aOXTrM
	 gOOJjDZw/QP+893zYpPgDoc+yeupkN8dSSZJfmFs13qMbkRUsXyp5nrYpRN58QRB4M
	 Rzd9KQhdf9bgCMAZWuA8mcl2och9J1DWD0rALpTL0NBth+rK4YND+m80ele3IUDEZ4
	 UjLiGzOPdvb6YD+g0UtrnndK3fNDYnP3F2n/F1nUThXEaFT0C0JejebtlUJJkbxfGw
	 uk3rta7DlFY/Q==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	Aveline Noir <jm5905938@gmail.com>,
	Lian Wang <lianux.mm@gmail.com>
Subject: [PATCH v2 11/27] Docs/ABI/damon: update for report producer sysfs files
Date: Tue, 24 Nov 2026 07:36:17 -0800
Message-ID: <20261124153636.91854-12-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261124153636.91854-1-sj@kernel.org>
References: <20261124153636.91854-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: DD66C18000C
X-Stat-Signature: rbfq8wd38xbdpbtb5g9tzzxr4wed7ixh
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795534613-584206
X-HE-Meta: U2FsdGVkX18Li3zyMHDNDO54MOhB3vIcykYOFSjNb3LvRrjL1l8nSN8aEGv6tDCs6f6hC1aumYYc9BUTgvAPuMJD35K0bqQNef7ioAQA5cLg4VxEuHuJqyjqClIihisGgT3QzoMJIy6RMERv4P6uqMw76kfR8s8cJ1pwl7979bihDU4dNN/u8f82UnNOHO1sx3tXkhgFTw3WLJ719S5PlqQ29U5edWeqVulDWtD5QXDgssRq1JAQ0y/D642QzfuwQ/Xl/s1HHPe8kqj8PojNjzuC2rDIg3pGX0x9EguW1n6iG/4+MdE4FXuDgd4S8F83R4mlITLTYD3PxlvL0M0OG74GUcrm3QpXL0fSg4EcgQPcNBNgPHVf4elsNGGk0C+v95ti/h9TiNHE/zOuLCVdu5pdlbAe5nSsv95WBI/wQ0n+f34/6m4Lhlx1mFQKfiy7YqpuPvKiNdDNh6jeO+nYKrFaoW5y2w35pUSQMozD81W0X6/XPHvJeU1SlFiopBSJSNWAlxxkgFeGdvCr2aaeKL/KtJj9ycYuIcv642FZ3eXgbOuLQ6vECD0eYothPlsqn9nF8HhCYuiCahVNK++NUMAVOC6PkySkGZ/vqSbYqCwV1JmBDutqH/4MRAWQAmW8gxrvLNg7VMAw1uwcAjJL/rM+RzE32Yc/QNgV/cxd73cyvS1yGXFv5RMI0KMRHe5KWDHQkYTek/jr71PcI6AjXTCwIF3Ap61m1ahLl28i+RCAUWp0ebGB+ui3wChEe3OO2RfqHz+j301xJkayTRXaBKwF0/U2dX9FLqma4WHPnED7IPuotqTBKIn2ApCJ39m12yVl/1f0S+c3UlLzCIlUJzkt5K9pULlqMjTja1BH2Fi0rJ7b/DsYelYqOmBUrPz8Ub421CORPK8NqJoEQ3PniVY7V+A03olMbLrzS+6xpmM9krm2gaicp8VDe3ZtcBYL8zySMRX0LiEBHsGdjqb
 9uHo03pF
 qmlCs6DWwLOfHiPkMh7Nk8HcQmvLx4faWG/Nei8JoWTEXzVa0aX0fm+it2Qxbmq2RxtGqyUCR5E0x5piQt7hv0Ql979EtCF0GucMIGUmlF2zi5+WbEC0QQS6GkTItP5/lk/79Nm+adNYzA20sZaiJ3sRQ4DJHzFs2pPnf4AFzEfMyvleOaJk1DX5uwZ/6i5aYSMyw/PdYgaQQ36oFmoQZ/NJpCqtZ5new7xzTj0spN+cc16nQAyM3Vapvih3GqmpnY9RaRw5KawVuwEdglGUS+Bn/zC5ElzsB6yE8jEoO3zEIlvCocCnldvpDvb2PDtdGteMHo4O+eR6TVznLwm0v0itG2wFZsRkM+pPnAiv5f4ZgYEKWPIBNkGdaAtu6YuT19Xosp2kfpyLSrJ+hqSXCnX7n9R/KieCHMekzI+cGH+PV3rBWh77e6y3XwrOWKAjC/C9zBgIS59KsfgIBG/VSIOQjbjG9SDa+IxDMW1xwHnEDjZr0zfpgbh7qXv/54fexjXQvp3nRptU2UCMmL9xmRYIyQrrGxqt3I/aH/q8PX9YYnfg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update DAMON ABI document for the newly added data attribute report
producer control sysfs files.

Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
---
 .../ABI/testing/sysfs-kernel-mm-damon         | 20 +++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index 92348178e48a0..b5e5004ec9fb7 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -702,3 +702,23 @@ Date:		May 2026
 Contact:	SJ Park <sj@kernel.org>
 Description:	Reading this file returns the number of data-attribute
 		monitoring probe-hit positive samples of the region.
+
+What:		/sys/kernel/mm/damon/admin/reports/producers/nr_producers
+Date:		Nov 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	Writing a number 'N' to this file creates the number of
+		directories for controlling each DAMON report producers
+		named '0' to 'N-1' under the 'producers/' directory.
+
+What:		/sys/kernel/mm/damon/admin/reports/producers/<P>/report_type
+Date:		Nov 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the type of
+		the reports the producer will generate and submit.
+
+What:		/sys/kernel/mm/damon/admin/reports/producers/<P>/producer_state
+Date:		Nov 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	A file for requesting actions including enablement and
+		disablement of the producer.  Refer to
+		Documentation/admin-guide/mm/damon/usage.rst for more details.
-- 
2.47.3

