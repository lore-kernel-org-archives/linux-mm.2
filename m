Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8190C61DEB
	for <linux-mm@archiver.kernel.org>; Sat, 21 Feb 2026 19:36:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22B326B0098; Sat, 21 Feb 2026 14:36:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 206F66B009B; Sat, 21 Feb 2026 14:36:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 102556B009E; Sat, 21 Feb 2026 14:36:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E5C086B0098
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 14:36:40 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B23A316056A
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 19:36:40 +0000 (UTC)
X-FDA: 84469470960.16.F46A350
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id F2E55140004
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 19:36:38 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NzDLCrir;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771702599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/N5I5kJjkEZIg64PkYpdtlaZKZ0JKdMBYrahzLr8qZI=;
	b=5B3Fi7SoI84tcGS6TcI88PJPfHLCqHfPCGFsF242YlcheSeaYgKCcuhj3/OnlMDe76iCVE
	UlB4IzmutX1LjZo1F85+/OTICXnMDcO40D8Z0zNbhu98mCSvMk2beywExMExRMkkxKkL9k
	qf3V2iPHvf3VELgt6UsvT9hj8JcwoVM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NzDLCrir;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771702599; a=rsa-sha256;
	cv=none;
	b=Zs1Vqv9ZC6plgwANg8UvVwX8ZO9rziH+YvRX3FTlrLglWIne33G2sKPd5xAHwC5/DoBsDp
	J2dgLkKMMyLqqVahAhLcNYN7eANBPCREaZWCC2q9z9ClOIMpKOjXwZX3EMkAeV+hG9VDCC
	KUYw6lNYhvxVtjL9N0AOYplFplaWgTo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A9781444C4
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 19:36:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76021C19424;
	Sat, 21 Feb 2026 19:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771702597;
	bh=iYt3HJjJZ2u5nNYQJzA/aRcSczmrsEXHtQU6RM/AfoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NzDLCrirLxiXJ5MTJob6eNXmUGHqltZBK4hK3K0ojglQ/kKc2jCJd25QXbbRj2Ur0
	 iBSBXBBAG2ggVEbKhok1CboQbE/p4yB/MIXimsyzj5hbKHv2C0+1PHD5PrBfprXSuA
	 iI9BBmHp4AvcOhm97QzFfcBMvgSbdkO9YlR7EwH3JOS1o4qeYOo3zldg9cRGehVEmE
	 zqErZ2xaNFzRBlDtjrETMekCQ8YZMPLJjYR10du2COPKT5A5KwGoR/RXhu86MyVCz8
	 8aWb0SLnTdrTljbn2zODv0ipNtRK9s1HND3HJMEEw5udY9vRGYU6N1yxatbheZOz7d
	 I5sthnhmS/M9g==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 10/10] tools/testing/selftests/damon/config: enable DAMON_DEBUG_SANITY
Date: Sat, 21 Feb 2026 11:36:27 -0800
Message-ID: <20260221193629.19332-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260221193629.19332-1-sj@kernel.org>
References: <20260221193629.19332-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F2E55140004
X-Stat-Signature: 73pm813brbm63t9aszagy64dwqqe4dxd
X-Rspam-User: 
X-HE-Tag: 1771702598-181749
X-HE-Meta: U2FsdGVkX191C+xkN+ZZPHDVRm8aC+43UnNuV7KC944WEDVJUD3olDaHIpK51FwjHNjscyiMzk1QONkHM1hOOdNh+LUsvAdmAl05Y3NFZampfv6yE+Z8T882VBF59+Qwo8bupgvG8GxaK/kUwKkSAFnkhYa7TKQO5ccEMk8xKNd2dJg5WIN9f0e4DWQf1Dl2JLzlfECdnOXUYcNdFSI20J77wLycmFtcjWX6SvaJsUJcPR8O+BhVk8SSq71HEZvquW2LkN4sTgtNLOhbnhW3bJvOIUuBdmqOSl9ZG3hl5diAd01IXyEo8AZSDrS1l0ht+86EuCEahynZPevLL6RYSU3fH/yDJY6eBRkjQI3Is+bguN3Wqac++dwcKX8eqIQmfMCJe+vPxuandRjTiLS2ZitvPWqs5Z6RFxh4Bui0+2N9+cOiUQaSdCEv+xyY9ou/6dcr6f5adMdP9B6aC+VOUIEPghlurKgr0uQ2EUj8k1nDxMB1xZDzoRsYd04WwRrHlaj81xzAaI4S80LpGZz6Zt1s+bv5auP+P9R1ONW5avcjlrStLR0pCb+wcg7xpVFBJ3e3O2QQAZIjSTeIMkJm2qgwUd/uMZ8zb1kZb2bwyDbpPNi+T64hi4kqadU8Zy/etqatVMnZVk2ZUfTY/mvIx168Lt9kV84ceCH1IBz7Upln/EFNLtWg161kmgaDq9QCLc+4JEcDTFdM3WdyVX31kbT68797ku4DdfujGzGW9ArKmhl6Y87bHTjOOmQMmKvf9h8JdAsjuCNFXTddmn3mkxpi4YQQrklHEkJh+E0mn65KPWXhZcCvIjzi5/zoGFcZPIPK2xy9RfgPC8gzWaQYhILGN755sqKhCUSnkcPvXqAol0+ZLtSXTBlFks5dcfMRUWPFfUAyGDpmLhqMvej5RwbA+MN7csof3m13dF9pE+6/FBbSl75oBqFIsccfqMl8ENk7KPit7GcMgulzBen
 AiznuUmt
 wdYuR2wj0j7iGfy+kRxJDYecOgWQdhuj2NVvcCypuZKEhdua7qS7EWsL7Egb7yEG/gFsN7MiUFD9PfPctBhdm+ibF9fa/Y3z6UoXQMFlMu6+0uH4NHDntR1XJOPI5zYl9UyVfn4QtojNp9wM9XuAa6hUFBoCJvFPPL5ZM98qn5KIvBtoCdwLFpD4fBDrFe92iFGiZvdI3EP1dpPwqunrpB03O9PFWf93DkRSJNl58g7gqJETBdDlp2S/G5kfxtrgW+nZo+4nho4JUHpg4i9FuUA09nFMQqr1hqQs27HVSsgo0ak2whX5rnefedq0hh7X95heFy197ZxmhXEn0WdMJ31ACyx/jDWCtdg68
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CONFIG_DAMON_DEBUG_SANITY is recommended for DAMON development and test
setups.  Enable it on the build config for DAMON selftests.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/damon/config b/tools/testing/selftests/damon/config
index a68a9fead5dca..6304adacb741c 100644
--- a/tools/testing/selftests/damon/config
+++ b/tools/testing/selftests/damon/config
@@ -4,3 +4,4 @@ CONFIG_DAMON_PADDR=y
 CONFIG_DAMON_VADDR=y
 CONFIG_DAMON_RECLAIM=y
 CONFIG_DAMON_LRU_SORT=y
+CONFIG_DAMON_DEBUG_SANITY=y
-- 
2.47.3

