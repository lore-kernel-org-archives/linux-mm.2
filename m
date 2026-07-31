Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E70AC54F54
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 06:38:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 173946B00A3; Fri, 31 Jul 2026 02:38:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1238D6B00A4; Fri, 31 Jul 2026 02:38:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 040706B00A5; Fri, 31 Jul 2026 02:38:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D78226B00A3
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 02:38:05 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7A5121A0384
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 06:38:05 +0000 (UTC)
X-FDA: 85048116930.17.45F1CE5
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9676E20004
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 06:38:03 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LNJyDa0t;
	spf=pass (imf13.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785479884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=GZJSSc516GjoO2HCslivZHlKZYAy5x/lBCh/5W5oRBk=;
	b=r5PSG9IwLp3Uz1j3YNVp6ls8sGGM/O67A6bBC9n33NY7VGDBNbZ+Lybu9DzWPr44Yuvx1h
	JcN0XTCL4el4Ft7Tz+1817+MFy10HBG2emP60w1VzBB2V/0D8xQ6beJ5aRYFVdJvtW119w
	x3a6qFwfedaP5w8U8o/UL30Eqlz6KE8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LNJyDa0t;
	spf=pass (imf13.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785479884;
	b=utEnEZLfBZgwbJ6M2Rs54mwJ9A0Ghen4We9/de92P6T32W5unwpLiCOPH4aOUCBAoD6fqm
	Uw1VN6re/USMLn6373REZFWS1M/7HKRdC4AGb2bySfnZKTFyx/rywntBh0MVU7PNS9NCMw
	9ThUdGO8kuq8X0xC/j7s5d45yv4BkgU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 997B4204C;
	Thu, 30 Jul 2026 23:37:58 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 3F6DF3F86F;
	Thu, 30 Jul 2026 23:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785479882; bh=1PzFwrvofx/n1IZxAx9wX1em4Ex1bRfw3KiKbBznMQo=;
	h=From:To:Cc:Subject:Date:From;
	b=LNJyDa0tozvJGlC5MdUcgvN4sxszRTsYJkKWyipAJBKzn0zssx5vvB4qpWe1DE+SC
	 k+0MVbLX+vASBLvyGaqOEr54Hrk3Ay5eVtSpknGybI513cmpDo2LLtTcQa3dE/pqOQ
	 AxJMGjh42fN+q/FLen94zpw+NvDU7wSWr6EG4AKM=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH] tools/mm: add thp_swap_allocator to .gitignore
Date: Fri, 31 Jul 2026 12:07:54 +0530
Message-ID: <20260731063754.73125-1-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 9676E20004
X-Rspamd-Server: rspam01
X-Stat-Signature: f7ian7d3rqkmfn7ogyr79b797oxcng7u
X-HE-Tag: 1785479883-199638
X-HE-Meta: U2FsdGVkX1/59BwV0xfDNHPGDrkE+luYMc5UNLASqA+25jpR+mf+l7jO71CTfuPgNPtzKK+ADyJGAFekxXf7FnJn54dzx/5Yd0p0eW+DJLpXbll4LkAItB0Gqh0jhRXYEfOjO6AcAJOgmmER0QKEFW28gwqDLbIqtBjMpWHIS4fLqEs5erLZZxCL6C/3zBRtpH4T7nlVFBdpTptbDSlGKvizhlG0b4502T26lTs5OMdmUlCbE8kdbzMiNw9fBGJZVFCu3OAR9/MpSYA+dkkWHwvnPbUY0SHk5anFuGsX9IViHb8vnH52N3wAhtwNP+pZ+88PmXsGjtF1RKefCje86ZJwjqh/T4A11YQ3TyeQirRF0I73Yih1oCqh8D9dFo0vCDbrJIZds8nBs2FeWrklfx/kG6AFDTOyfwFe9W3uQclpY+Mr04bT5N/CGkf0qVfsCV5Mxbby5f02xrZfp/SF6hJ+pPExZnSSTCcTb8U8/PdGQZfMcxenXMnb7ev6mzhj00UqlsWVpzFZiZ51qkkhpYyl+1rta9+vqg1Zed4eaOkL9d4QBzRpT0G0SW3JEYh8EgoP/BCuRxtlSss4Nxd4jDOxNxUukak40oH2RLsrtbTvm0haiadqHpja+a3RVqUaJ5oeTuiV+FgW47dyvZyNEWdj2zv9iMHlq+9NuF1Dwz7IzlsyeW6P4mR5HMeOWSXfQMPauXJmSRVV9S+Lq8DSQDJNerqfTomPrpoTIw0P9hk6s5EwTQdUe7A/h7i+qogZcyLby6Y7uzSeXKlETc1B3ceoJXSknqGhiSDmKtGQQz3XRa0OHo8Xy1PAOjFeILzu4NDDjnH4l1bjcJz1lgbiORC80EKT7h/nWf+GIKbN7fntsrTHycSWiifgL5gs75hVG8kg6o2CETSwOxDB80OoBaVZHhFabakrrDQC1JnBFBtEP9r6m+zDOJRggvbUCndKYGl+WeQQENOjeJvXf3V
 XNwTw16a
 /T6pw1BQHoUoI7C82Fef4UMvJ6h1q9rojJaEn2X9EcvGPByzou7IxO3ZHmIC5ZEUk9jrLc7Sv862UvzA4NLLNoAjoc3QokNOKCB77n1QLs0oDGNSJAQz0AY+ZZjHXE9EYHWTlQDn5U+GDHfwwTfO8mtP8uujpwdnxzktnchzsoxBJ8Nb1DKEg7CiyiojFNkrQkDzb/4yvDw9GN+7fKgNtHWXbwY3S5vxXbxTEXVrB/9A9J0/UCOas4jqxbL1is6+b9mPKfdNNzeqw/S886QuSfn+X06yYjGcoQ/Jn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

.gitignore currently does not include the binary
thp_swap_allocator. Add it to .gitignore.

Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 tools/mm/.gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/mm/.gitignore b/tools/mm/.gitignore
index 922879f93fc8..1446a659e540 100644
--- a/tools/mm/.gitignore
+++ b/tools/mm/.gitignore
@@ -2,3 +2,4 @@
 slabinfo
 page-types
 page_owner_sort
+thp_swap_allocator_test
-- 
2.39.5


