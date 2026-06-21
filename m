Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 453ABCD98F2
	for <linux-mm@archiver.kernel.org>; Sun, 21 Jun 2026 21:42:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCCB06B0092; Sun, 21 Jun 2026 17:42:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7CEA6B0093; Sun, 21 Jun 2026 17:42:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACEE36B0095; Sun, 21 Jun 2026 17:42:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 72B436B0092
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 17:42:48 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D19E81C2DC9
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 21:42:47 +0000 (UTC)
X-FDA: 84905244774.14.01BECE7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0E28E40007
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 21:42:45 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D4A1txxw;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782078166;
	b=LM9UGrwd6DjwTnAg8rhLQm2DYiXmbI7dxamt10/JrdiIljyf+07LUGFcrvI/8IiZZB/Hpv
	NC3iwvPRLn1KmM5Q8mZW5WpBeJHdeE4MjE6sKbhLuAKShkly63FJP8uwHXaijC0m6OABx8
	YVJUWdQe5igIrBZw6g6LIWNrnRk3/XI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D4A1txxw;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782078166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lL7MHFsV5uVbpGE1PaL3gylfP3s1otTosgqDG8rU960=;
	b=ulH2262tlpmtfwV7k2veZUEJcSzZHHWGIJiV6w8SZbPeKXcOO431CbTJ8ip7E/rxhJHjge
	zk+A1KbhG+3b1IFvyoMm6tPp5wMwJz/w1IMor2hQQtOTdn78plC0HnBUMaUA2DLsGYbxEg
	UGz2j82vB5TkWVicqJEF7fU9hHi5Mco=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A56DA601E2;
	Sun, 21 Jun 2026 21:42:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF3B31F000E9;
	Sun, 21 Jun 2026 21:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782078165;
	bh=lL7MHFsV5uVbpGE1PaL3gylfP3s1otTosgqDG8rU960=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D4A1txxwMvBfs++g0T5ekr+cWkOtMglqGA+8dqeDI7JhTpgvdYtyQMXEMxfwBHTsE
	 QldGqBauTEPzL+uH+Mq1fJAo+OFRjix9eDmS4kMXzZUXzx+VBBYDiaFr1/7W5gblv6
	 lGfG8JrgO0w/OTK7LyRT6+uL6I5ZjqgsNnFxmHGgvucvPHH+7EYQ5UbH1i/hd/3YyA
	 aLZmkYZTWDJ/CM7MdnxXX3a1UGI5jvRdO8PEDF4gBiZ51iTmUTY/ClPQm0tVZwnhyx
	 mifdTH87aVbbjBUmovsuMCklPTRogD0SllDK9ceEDuxyUDIj8dEcHOe7O4XqIlwyYX
	 ahk2rnJcSl/CQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 3/3] mm/damon/sysfs-schemes: set probe hits as pseudo moving sums
Date: Sun, 21 Jun 2026 14:42:30 -0700
Message-ID: <20260621214231.13449-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260621214231.13449-1-sj@kernel.org>
References: <20260621214231.13449-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0E28E40007
X-Stat-Signature: o6e1zku9bqx5yyo87ow9re6mt5zaoj8a
X-HE-Tag: 1782078165-707761
X-HE-Meta: U2FsdGVkX1/C1xnca72rNEG38btxCwlzce26/i+3cWvYsal7RNcUyHNx/NNs5DDa/VSHP+7XCmShWg9l80BDjIrV7kjczM9BK5vz/qe2PC7krcG1lZfbUrsgyWM5vWQPpW0Q5wcEPL31l5QzxW4YYO/xugxMGr9r7okPbbuAiBWsTIuDVgfBMSMdlyJ+jNYAn7rliGZIIebb5DwwOkPC7OmHX7fZOm8Gagnz1KXU4XGZJTF5eU9lz1DvwU6l9PA8HvKBKfFLGXNw4TknucehDwN4A/kR460YJcuyhxz5VFncFgt+v9Eb3RcVor0Jym7r3/Vjeo5pBQwbssBaGYU711+z818xpnGRQd2cIIShPGQMJh9WZF17wPMEheEaB2wzTx7L0XRw4i/Nm2OZE/3xHnnjTESi0cDXA6Zx5OYzKxytlj11RO0lGOB7lmZb/bn+5BUpoLdPUVfsBGpu0UpdXYrAaM3SrzRm+Zwm2p4Yh5u4iQrHYUxI9fiJCZizzJ7Non9h3Cg9VtPUM65onHcMPpdfpgggTZaUEF56QM9E2VcgxWV37Zpcfo5azzbaBKudf8ebGrI16W13z4841j0Q3+5LTzj09qEk7g+Hl17GDVLhaGitmTZxlgpaR9i7NfHAeW+fqqQXXZnVEkt/FTJO10rb6nD1RQVWu+sUQ6u88fbdnSoB67aOnaXZnPwEZuv/lrbZRdUyU/rgoybPc8jo8pISBrbdw+4PdlzLTOOFBObBt7BjCk2qjjJpoqWtsHZ/OBQa92/vzc9XRJj9zjzNHba/4mCqMjJMLPLpW8JOZPAmmKam3pOZVgEQO9AriKaxONkJjlMWLDkre9B9bYNzNpmlUv2agIgVILCy8GhsrBaqKs/HonTwIQAITjhNGT7GyvEJWUY8NkWlDxGbZCDoPVsIxEMrkMVpQXMtC/3WBf4TKontgp7Pc8ztKxKRI/7v6MMV+ppp0gcT7RSJjA5
 YKnv51jM
 8DMtjDsAY/iDos6gjYd7cjEkp24G1EYh2EUhq17EwrNik4rShSqCCiHqxJk+UTMlPuVIXXMtNan0kmzMN8+3VPqzW64BIKCfBv42zu84oVsa8ZOkxCsLKngHdajVac4N0Bs+WC3LsGo6+Tatsr3QJAGuJCs6VPemQdIUPBqZXmY7tff74UA/7h15ypeS7TjrT+jrcE3pJGFlpm/CUNz2/FBSxP179S/H2QNPDvpR+8MKJdSU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON sysfs interface exposes damon_region->probe_hits via probe hit
files.  Because the counters are completed only at the end of the
aggregation interval, users can show incomplete values if they requested
the file content update (update_schemes_tried_regions command) in the
middle of an aggregation interval.  Set the value as the pseudo moving
sum value of the counter, similar to that for nr_accesses.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 30a007bcf82f4..06ebf381c32b6 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -112,7 +112,8 @@ static int damos_sysfs_probes_add_dirs(struct damos_sysfs_probes *probes,
 		struct damos_sysfs_probe *sys_probe;
 		int err;
 
-		sys_probe = damos_sysfs_probe_alloc(region->probe_hits[i]);
+		sys_probe = damos_sysfs_probe_alloc(
+				damon_probe_hits_mvsum(i, region, ctx));
 		if (!sys_probe) {
 			damos_sysfs_probes_rm_dirs(probes);
 			return -ENOMEM;
-- 
2.47.3

