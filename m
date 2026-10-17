Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7357CC6B2A
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 04:07:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73B806B0088; Sat, 17 Oct 2026 00:07:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6ECA96B008A; Sat, 17 Oct 2026 00:07:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 628806B008C; Sat, 17 Oct 2026 00:07:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 06F5B6B0088
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 00:07:14 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 415A91A0200
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 04:07:14 +0000 (UTC)
X-FDA: 85330783188.14.D11C3B5
Received: from o1.ptr9745.em.honeycomb.io (o1.ptr9745.em.honeycomb.io [149.72.141.136])
	by imf14.hostedemail.com (Postfix) with ESMTP id 29729100007
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 04:07:11 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=honeycomb.io header.s=s1 header.b=RIok+owk;
	dmarc=pass (policy=quarantine) header.from=honeycomb.io;
	spf=pass (imf14.hostedemail.com: domain of "bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io" designates 149.72.141.136 as permitted sender) smtp.mailfrom="bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792210032;
	b=lqlbb6AXQbWUBQABTSucVE3+OLBB9nj8WlVUsSSbDWeQ/EginDjZBbArxoQLqL1iPhpw6w
	AHGg2rQzdpKAELHCTEH8uWwRkf9K0AkU1inHrpcevAg7dnq4xQaG5i4HxAKyCypbXWPgss
	0L+m4UUjrUnSWr2zT/YpBmf13WF0e7A=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=honeycomb.io header.s=s1 header.b=RIok+owk;
	dmarc=pass (policy=quarantine) header.from=honeycomb.io;
	spf=pass (imf14.hostedemail.com: domain of "bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io" designates 149.72.141.136 as permitted sender) smtp.mailfrom="bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792210032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vmoqsEUaflaluKIcotOa0bF0phf2HZlStSKylP4A7kA=;
	b=QNLpV1efR0Rj0Xht6tUCO6IWmevips85C1/DcK6yM47alOJTfatgSfZlhQulSYSzuuDlPA
	rQ6opbpyiSYay7t6GaK7XAyKw6rgio+2BXSzxSIp8Sm9slzqKFICI25RXxZieC7AYawY0M
	LCasg0t9h38rm4OxaP4FlzF8EP+uUH4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=honeycomb.io;
	h=from:subject:date:in-reply-to:references:mime-version:to:cc:
	content-transfer-encoding:content-type:cc:content-type:date:from:subject:to;
	s=s1; t=1792210031;
	bh=vmoqsEUaflaluKIcotOa0bF0phf2HZlStSKylP4A7kA=;
	b=RIok+owkUkDTUdDOw52vTX1SqJKmm8h9Tg1GCpuJxWMAzeJHTHhhg7Ym/Q06670vcf1e
	o6DU/Cfpyw0Nnvli9OXDjWSyaVBSqYJCymjFhtXdpGqGHqlA94VSwqoI+2RSVIttdwAKs7
	rFe3ed/2wtPF5TJcK31bkD+sJ5h+ECZTPDbAMuiYxo0hnZ09p7e+fXnyvvxi3f1r8QD11f
	0fJLhDUhLK32t906GZiNaFuI6DJVxJBBke1rgP1D0JCS+Wfi8JBHYaGAnQm4jvJI943nZW
	Df0os7/S+AHK73xH67JyfxKRvDOF05D52uUvnuUNJhupzo6oezObwduZKSZ18LaQ==
Received: by recvd-canary-8465b4c48c-2zgt8 with SMTP id recvd-canary-8465b4c48c-2zgt8-1-6AD2F46F-5
	2026-10-17 04:07:11.103999751 +0000 UTC m=+1508805.732609009
Received: from daisy.dens.ffj.family (unknown)
	by geopod-ismtpd-19 (SG)
	with ESMTP
	id VZBbDvTlT0KW3V3gToMmBQ
	Sat, 17 Oct 2026 04:07:10.996 +0000 (UTC)
From: Liz Fong-Jones <lizf@honeycomb.io>
Subject: [PATCH v2] writeback: keep cleanup_offline_cgwb()'s scan out of syncs
Date: Sat, 17 Oct 2026 04:07:11 +0000 (UTC)
Message-ID: <20261017040710.1174009-1-lizf@honeycomb.io>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261015114307.1041273-1-lizf@honeycomb.io>
References: <20261015114307.1041273-1-lizf@honeycomb.io>
MIME-Version: 1.0
X-SG-EID: 
 =?us-ascii?Q?u001=2ECuH7N2XAoeMR1zrzr=2F6NZrhli2vbKPOHff5fJuZuba6ZIE8QPyIf9mn4Y?=
 =?us-ascii?Q?ezqeFFjUkh=2FeROy4LtnO7KN9jZmeX7GlhsjZ8PC?=
 =?us-ascii?Q?Bz=2FZXm+aVDXju7NjTKrzoAAjIB+x+EO1=2FK2pA=2Fl?=
 =?us-ascii?Q?bVTzaKDdCTENpW=2Fe+wlK3vnOG5PPz5q0KKgxjIn?=
 =?us-ascii?Q?OR0=2FNUOvFyAvJg9F0LGTtsRec2WImXQyCdSDAjp?=
 =?us-ascii?Q?Idn0DL8ux8Vb4LVkGcUI962W7tWp11OTylvGqNP?= =?us-ascii?Q?QrkJ?=
To: Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, Christian Brauner
	<brauner@kernel.org>
Cc: "Patrick Lu (Anthropic)" <perf.patrick.lu@gmail.com>, Roman Gushchin
	<roman.gushchin@linux.dev>, Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, ian@honeycomb.io, Liz Fong-Jones
	<lizf@honeycomb.io>
X-Entity-ID: u001.GRlkmHQ+Ka/CKxmoC/CxTw==
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii
X-Rspamd-Queue-Id: 29729100007
X-Stat-Signature: pwfbtemxxk4nzbs8gh9w4jageo865kri
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1792210031-703725
X-HE-Meta: U2FsdGVkX19IXMPc3dqr/sCCyZD1xczQceYCpjfwqsbB4r2GqhRsUGyIBZuci2FRvO91Ehy47l4xXYb3B4JUmcooiGotwvFWhJFkwphNcPrNickTrwnvCWfZvLn3tqFM6S+01yV+JPvKdhYXeSFBmaGFwhe6puoZgwdiECFaqnxC/t+vRnonQCpEL0GtxuQH+ymdVz+Th6NpTSqQkC2fp1KgvB0d9DbhCdBKtuir/LRjDW1hcBFKTDb3Mx0wOqck3HJXZpTR4NI4GPygitq45O8iAZPUglDib3XmaEs4Ao1K+5n+xDDiHzh0iUPB7ESKfV6x9KYPSTEfKFnrEyBMVU96/RUbeg2flAGYasiWlnxWJcF+SmbJqBQpT+JJ9iF7uowRBvlWOUOMPOELJ/PS8yUJQymGhLKgYrjfWaE05Z23myHHgc/eLUJX6nnCGRCQ3/DEMb3sc7azzYlqpTBtzICKC3AlsPPE5ObZT3y2XDFoo1ZW63HZ59efUIGLJK4iYJizXREf6SZ57YmQ19vA7EotH9vZ9V3f5SI0Zbi8kfJDU2aQvkHddjARxmenBsCBuCHvohYjPjVrFeS4ZZ39V3trWTsIt06n5K7gOm2yTLyu6+YO2oYuEKAZKzx7yQJliYIkwflYAZz12NyXbOCEAlNw5y/N0ViEgaRpSA0cRbPTQvlZr5r6YYz++EBc4OvYQDUH2IK9ZNN+0qZ6gEH2L/XHaV2zApi6Vn8UjS/PBocQKh+qFQZdwDLED+CRT09zBo56/BYl2l7Nfyjr90qNmtTIBJE4tqBT5cXq3IuCImKyG2N4vQIra1YN2dFK3k9KqvKlNNIWRfHR47aPwfKr4m+4QCzWTYy3RykV+7AAEEHobs9FRkmFEr4K4pMSSMv579udrtwIta49oSffWZKmuQD4YkJNYqcsFYQTlR4iHks3OKj5EqhbJ2L46+X70Iz7ClSqurnicE7XPmduRCM
 tIyUkVYu
 aY3rikg7ZDIKf1lwzBJFxDR1axBTUXLmAXx1x79aXTkrAclfaMoB0wgnR1+8Sp0kdbwNfNU6gqrKkrSXIeKiv6UYxPfcLUBKuhbEVEHV7ca54+Y+0hb+tR/YsYCO/0zLb0tvIOUmkhUaenD7V4e/iScGoDhhH6q5dV+8cJXE9kAl6eLZitD/h3pDwYCdvvXfS1BdbyZcUovXo/q73Y9TWK81e7iCBSV+T7NvR7G9Q5iVwVtTc6uZolRVOgGGltGnboqLTu2sqCUN/LnS+f27v2Q34ud7MMX5yY2v0AU7YvJsg+EP+Ywre0xEJ/CTECQuuxhR6utjMxD5BJJO+mbiTQyCvpVfkwBIkG4K103X3JQqLf15p5clk+RZRSv8w1gtEonyH/3RWsq3b4/Ia84FhPXATQrEH6RmwokPGU+//B8nKwAM880ivFZ6iVoOI+4o4Dii0JoUsPXVwqT1JMIJlxpxH5BKnfZePwylEGbVzXIzxCgr7dF7PeFQlc+tGHuD+FaBdEX5MiwoJ3+4T9GnNbT2IHTALPd3lxaR14a741gvm9QQqY993Hb1IMXtAqAZhOypqg1g2DCn3cNycQyTJ89QDlz1JFBSOdZk4UOnEt0zJJgiPI3lmzaUP1/sNHjF+Bm/BiPAn2Gv8kus2PkfXkjoyvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On a filesystem mounted with lazytime, sync() and syncfs() can return
without persisting timestamp updates of inodes attached to a dying
cgroup wb, so a crash after the sync loses them. File data and sizes are
not affected.

Since commit f6988c90671e ("writeback: bound cleanup_offline_cgwb()
rescans by rotating scanned inodes"), isw_prepare_wbs_switch() moves the
inodes it walks to the newest end of the list. When a pass fills its isw
before reaching an inode that got its lazytime update after a sync's
cutoff, the walked inodes land past it on b_dirty_time, and the sync's
queue_io(), which stops at the first inode dirtied after the cutoff,
misses them. The late inode has to be one without a pending lazytime
update; one already on b_dirty_time keeps its position.

The window is narrow. cleanup_offline_cgwbs_workfn() skips wbs with
anything on b_dirty, b_io or b_more_io, so the scan has to land between
wb_writeback() fixing dirtied_before and taking list_lock for its first
queue_io(), unless a multi-pass drain started before the wb got dirty
IO.

Take wb_switch_rwsem for read across the scan, as
process_inode_switch_wbs() does for the switches.

Fixes: f6988c90671e ("writeback: bound cleanup_offline_cgwb() rescans by rotating scanned inodes")
Cc: stable@vger.kernel.org
Suggested-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/all/0bc5d58533f10b4841807be3025daa11@kernel.org/
Assisted-by: Claude:claude-opus-5-5 checkpatch
Assisted-by: Claude:claude-fable-5-1
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Liz Fong-Jones <lizf@honeycomb.io>
---
Changes in v2, all from Tejun's review:
- Correct the trigger and the reordering description, and note how
  narrow the window is
- Reword the code comment
- Move the test details here and trim the description

Test, with a debug-only delay holding a syncfs's work on the wb between
its cutoff and queue_io() to widen the window: 300 files on a cgroup's
wb with lazytime atime updates, one more read after the cutoff, then
the cgroup removed so the cleanup ran. Without this patch, syncfs()
queued 48 of the 300 and after a crash 252 atime updates were lost, on
ext4 (-I 4096, so neighbours' timestamps are not written along) in 3 of
3 runs and on XFS in 1 of 1; with it, none were lost. arm64 KVM guests,
7.3-rc7.

v1: https://lore.kernel.org/all/20261015114307.1041273-1-lizf@honeycomb.io/

 fs/fs-writeback.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index ea3eb40bf828..372ac9785e03 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -789,6 +789,13 @@ bool cleanup_offline_cgwb(struct bdi_writeback *wb)
 		new_wb = &wb->bdi->wb; /* wb_get() is noop for bdi's wb */
 
 	nr = 0;
+	/*
+	 * The scan moves walked inodes to the newest end of b_dirty_time,
+	 * past ones it didn't reach. If one of those was dirtied after a
+	 * sync's cutoff, the sync's queue_io() stops there and misses the
+	 * moved ones. Exclude syncs as process_inode_switch_wbs() does.
+	 */
+	down_read(&wb->bdi->wb_switch_rwsem);
 	spin_lock(&wb->list_lock);
 	/*
 	 * In addition to the inodes that have completed writeback, also switch
@@ -803,6 +810,7 @@ bool cleanup_offline_cgwb(struct bdi_writeback *wb)
 		restart = isw_prepare_wbs_switch(new_wb, isw, &wb->b_dirty_time,
 						 &nr);
 	spin_unlock(&wb->list_lock);
+	up_read(&wb->bdi->wb_switch_rwsem);
 
 	/* no attached inodes? bail out */
 	if (nr == 0) {

base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
-- 
2.53.0


