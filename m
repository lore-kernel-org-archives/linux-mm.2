Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5D71CAC581
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 02:22:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46B366B0012; Mon,  8 Sep 2025 22:22:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41B526B0022; Mon,  8 Sep 2025 22:22:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30B586B0023; Mon,  8 Sep 2025 22:22:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 180216B0012
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 22:22:47 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CD11AB8BF2
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 02:22:46 +0000 (UTC)
X-FDA: 83868113532.22.7D22650
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2FF21180008
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 02:22:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oTp3KKAa;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757384565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4nMXGgdypbZGwpyv33IpUsBqhC+V8TPFY6DWKa9xx3g=;
	b=HV1GT81/HTU3URGCXE8ORXQ/Xnkj53nsXR59fN1Mgzu4A1QZ4Drc+ocYUhvxBgZCC71G8f
	tIr6UMAE5RmgDNvS75uJfkShHsi+4BWuXkfqVksVOAFL7spoIgFEuAUvaFAYoCyWoWDzno
	UBJRZNaOXWhHzO/8mAI530cIBQUhjAg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oTp3KKAa;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757384565; a=rsa-sha256;
	cv=none;
	b=OYaUfG/PKGeoZn67bTuGts4IzVtMFOjmNNHtiEs2lgHVQFWzaP/f4eBiV80UdDELhbGqKa
	HgZPNa0GC2TC87dJOoiirtpc1FECwQZEGOzQGE+cXi4+ntYb9WbICoBbG3YXMSTXZw5Yut
	K7aPOA8YuIN6rA+9nFwXCWHuPq+OB3g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4081B40678;
	Tue,  9 Sep 2025 02:22:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9519C4CEF1;
	Tue,  9 Sep 2025 02:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757384564;
	bh=aE3MoR2tQr9P83NDIFS+on/nd9/NuFxzaUakeTNxCms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oTp3KKAa1bHkGzU+GjVolsTd6qVyUDIDYpgAmm9g0iKVAi7FC5+vMLcxjCivtCkaJ
	 9JfOBCyKVqFvKa5rdFWxeJGhvb3LYkE2spsimlwJFt/QUzhx7a1hcKMOVzn/9hnkzx
	 IKIbT/Saf2AN6UmhD9hLfgbUp1qxcmsLw1nlIWvtqpy27HzZBtPwGpvEseJWv6HRi/
	 adjJLYJq5JLCdfeaOa5FEDTp3+eEz8Rs0kZKNf+pHuc0SfHaPBv2hEqOfr+ZSxrHWF
	 s78MP+bVJlUUzqq9fOs8hyB3By5oE6nTDsBLTmo6PQRufcYu7D9XQCK48bS/M3JanY
	 oHuuzqJfqubxA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 17-rc1" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/3] samples/damon/prcl: avoid starting DAMON before initialization
Date: Mon,  8 Sep 2025 19:22:37 -0700
Message-Id: <20250909022238.2989-3-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250909022238.2989-1-sj@kernel.org>
References: <20250909022238.2989-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2FF21180008
X-Rspamd-Server: rspam05
X-Stat-Signature: tc3fm9wpwps6xwodn6oqrno3h11s56cx
X-Rspam-User: 
X-HE-Tag: 1757384564-399253
X-HE-Meta: U2FsdGVkX18BuDyO1ZN/N2MiwK6EBHQPky93vPwP84TBcl4p7CTn+UYl+gZwGEDFTZV4rfiahFerf/WwsUu18G0MTnmkboJC2MwlT40TbIAbzgeymX0bH0cGeGbVJLaH9fpqro1tM6Qk9sKHMJ8OsEwEuNTxVElFLei/klwMr1wqCl9I2/9KB7YyiA6qPuByTFDbk7Mp5jzeXrrpRTHRCGjYZdXCefcQdYza9irdO5OjxusoPS1nxj51nw0YtKG98UDU5zrYH2wSaTmUjo55wT7g/llSsU+Gw9cO8aLkOuvEPZlJqKyetlSrsIp4mUnxQJMn7rXsQpZIXsQ104BFHv+TFzNlaiGUE/+fXp7KNPuEjdF80ccYMXh4nwqie6V2Gy2eaIELW/ReF+wPbD/qa9uV1gLfv8OixqIWYWDFTick1HhOcjW/fVrls14AbLjshGOGVXQVp40ehovGck9MwBjxS/JygKvbUQx+8Um5IFF7XyHCtJxwBRN3a3B5oMDvEE77RsJTzWjHTVHhGEYiZdU/uvgEv/E6YwRgHOaunbjyUuYRzUROgoZo+9zS4YzqBr6yw1DmsmK8JIinzTGYZaMRT+WEig752E87NRQCfc8oc8rZK+G2YnDhbqx7UTghncLIRcCvAHPe1fKJB2XvVQ8UD+hkdWp8MWAy/I/hXr83zOu5f5+lHSCKrmIOF9XuT7GKNCgmaYZHN+u79vmbG9v8Qee6r+JcuuHwSl4ZT8dyH7HRkQr7I4/cc6f2Rz27x5BRzcZD+TQHxpMfRMjP7Xo3q2GRBSwMCsL+8j5arLZQkBxfSzOn9ztb7mxj6oQF3Tal9VIInMNzxOJkfhf95TAdiFs6co+qdOZnK5hx++x2NFMgiOPGsoaCbI+8g4XwJaxb+2jtfeyiNYZ26s9F6YCPZQc+RbqUfS1WWRlenUmjKuKpD2w89KY3foEYdLkUx9u0JsJuQtMx6ZahK15
 OxJ9pLEp
 PaQVdyTP1MIMa834LHq/B50zSd228D04X8BK1NS8TI6uxQCpnhWg0JPSAyrZCLNr197DD5dtBEcRlRIRclDiwVa4eJ9l4XT9kTnPnS9qpqB6JmsP2j/0iSzq/eqcXuh3+8rDESBibjRX922/ZSqPoegBn9dU8YnYWhojewYQ5kn6rkrqkaxeMJHoxlgA2N/AxIAIgr18quThL1skmy1/zhXt3WIZozAq1iodM2OlIzsciINw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 2780505ec2b4 ("samples/damon/prcl: fix boot time enable crash")
is somehow incompletely applying the origin patch [1].  It is missing
the part that avoids starting DAMON before module initialization.
Probably a mistake during a merge has happened.  Fix it by applying the
missed part again.

[1] https://lore.kernel.org/20250706193207.39810-3-sj@kernel.org

Fixes: 2780505ec2b4 ("samples/damon/prcl: fix boot time enable crash")
Cc: <stable@vger.kernel.org> # 6.17-rc1
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 samples/damon/prcl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/samples/damon/prcl.c b/samples/damon/prcl.c
index 1b839c06a612..0226652f94d5 100644
--- a/samples/damon/prcl.c
+++ b/samples/damon/prcl.c
@@ -137,6 +137,9 @@ static int damon_sample_prcl_enable_store(
 	if (enabled == is_enabled)
 		return 0;
 
+	if (!init_called)
+		return 0;
+
 	if (enabled) {
 		err = damon_sample_prcl_start();
 		if (err)
-- 
2.39.5

