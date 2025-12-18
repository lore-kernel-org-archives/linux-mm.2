Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8151BD68BC9
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 01:59:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78EE46B0088; Wed, 17 Dec 2025 20:59:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 758BB6B0089; Wed, 17 Dec 2025 20:59:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5713E6B0089; Wed, 17 Dec 2025 20:59:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3A8026B0088
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 20:59:09 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E6B25C0B85
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 01:59:08 +0000 (UTC)
X-FDA: 84230933976.25.F6D0779
Received: from mta21.hihonor.com (mta21.honor.com [81.70.160.142])
	by imf07.hostedemail.com (Postfix) with ESMTP id 72A374000F
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 01:59:06 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf07.hostedemail.com: domain of yuanlinyu@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=yuanlinyu@honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766023147; a=rsa-sha256;
	cv=none;
	b=eFCj1KFwL9BqojT2FhcJEHBYRFQFh5zdBbbHWc19CTONca9LasM3aqe4s9mZzDojFp3KYk
	YuwCtNJ8eiAyS/Cz+DPzSynVZoUdr+myYC6uKXpXdlMYDFWiWDCk2uPHV7sEAtn24n1rrK
	uSm+Y687gZ3fofgnj6vkl4xb7CGdw+A=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf07.hostedemail.com: domain of yuanlinyu@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=yuanlinyu@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766023147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iNL6Xv1UwSXA/ER2aXrzKwOgt7RZH5mqkcbw1XQgSPA=;
	b=hcijwWCCjnsH5wh2UGsGqT+o8I3099RPZR5FOY+5ZJnGInc9zRh53CNQpkuOQdZC1Kr54/
	jufclD4j/QbowBclBU1lWo3NPwMAGAOY8wDO3znnSfwI0ZoZ2K4rz2efG1Up16bM9/d166
	8QHLWsiWKWBxfgNjRW3K7KtcnQDpxsc=
Received: from w001.hihonor.com (unknown [10.68.25.235])
	by mta21.hihonor.com (SkyGuard) with ESMTPS id 4dWv0T3PyTzYnWDt;
	Thu, 18 Dec 2025 09:56:25 +0800 (CST)
Received: from w025.hihonor.com (10.68.28.69) by w001.hihonor.com
 (10.68.25.235) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.27; Thu, 18 Dec
 2025 09:59:02 +0800
Received: from localhost.localdomain (10.144.17.252) by w025.hihonor.com
 (10.68.28.69) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.27; Thu, 18 Dec
 2025 09:59:01 +0800
From: yuan linyu <yuanlinyu@honor.com>
To: Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>, Andrew Morton
	<akpm@linux-foundation.org>, Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui
	<kernel@xen0n.name>, <kasan-dev@googlegroups.com>, <linux-mm@kvack.org>,
	<loongarch@lists.linux.dev>
CC: <linux-kernel@vger.kernel.org>, yuan linyu <yuanlinyu@honor.com>
Subject: [PATCH 2/3] kfence: allow create debugfs dir/file unconditionally
Date: Thu, 18 Dec 2025 09:58:48 +0800
Message-ID: <20251218015849.1414609-3-yuanlinyu@honor.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251218015849.1414609-1-yuanlinyu@honor.com>
References: <20251218015849.1414609-1-yuanlinyu@honor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.144.17.252]
X-ClientProxiedBy: w012.hihonor.com (10.68.27.189) To w025.hihonor.com
 (10.68.28.69)
X-Rspamd-Queue-Id: 72A374000F
X-Rspamd-Server: rspam03
X-Stat-Signature: 3acs4b46wkquk9pejyg99wii6wq5mpcr
X-Rspam-User: 
X-HE-Tag: 1766023146-882466
X-HE-Meta: U2FsdGVkX19vTOcJ7pb9CDkaVVKmrp7z1o4xAdGepb5WMqfd2W6Repu7MRCjfkg0dRfrUzAkxDuSQU4sVmM+OINxbkr9GVcfA6LHCyOXhxPH5H+idepyTMojipeGcLkcbKzf26lKNg3IX4eckTGHKn3mHGfkELEypQcV1OHnkEKXrNuYZ0HtW9s5SkPLDbMWI2i0AjDDitCcSQm5P+KeJC7oc8vwxT1niTW4sHw9mWz5B1p9+MCutp4LMCdRQu8XwnS4qfssq+Dmg7oCwVaYspiDviwxPkrG7b9bVZ5KF21d24ApJhHA4DxG7pnpDUQavqCM0cQY3Ck+xy2ZJPIq9EbuHiJ7soP4fZqQZoHmodajrR0fXcplwDhKyrpNfD+725OpYjS59hRm4FTlM22Z9dnpMRDGLYUdahC6GnrV3EltK7KegQkOMzgi0OzD0LXj8dFheyFZ/eHS1KFlnO5MRGyeLc9kkUIjg98T0I/EBkCpk4PthIiDKMUmmRMXWpOzEWnDOeQaTvd00NSmYhrHMczKXbaWPOagfNOHTMRIPdj8WF0lrF2vC9evc47CdOiGtm4mYI7f5AO/J5OR34VXDmFruVvEoLAeYLePn3RBd00FM+GeNt8nMaAXV5Pe35i/afTUy4u1ArxVUX4VXjV8IB4mLIoV6MFIHe2njJIscsAu7ReF/tM4po4O88+npXjuTp73T0HCFP1LN97vJKAmPPm8nYqzN53+AUkqrJv5iqOR20OdzdmBB/dlEdWoNOr3ec8rr0U4oB8NqsfdbeqSJt5b8hb1Q5EkRlsX+X2Sagwu1rVW6KwHArIQr/oNJCXM2NwjFHvjjjuZSgAZmmVuldICBa8O19m+Z3aA4M8ijRLxOgMPDFZ/d60blILn2a6fu0oDaQWc9IQ+Mez8yztj3F/mWToZoEnoUA94lKUSFYUZnKhwvBFDEPDMQVyAJpwWNG7cn5lV7YtHkcAdc6I
 6rVzKgQw
 6H85bnKpUj5aS5imN7S2f354y9A2/Lq0P+ocA1GvUxCPOp5pozjIwdGZkdNfPuptIXfFSBPx/AXr8uwx1xBfBCCRHRnhwrY2H870d56Sw5OIjYp9rFGaSxRx6dqJ+mPEeVJnGQUSwWmqhlmFPjB3gv1hOdrFakrmuyipCcXeReX6+ojNS8FlutYJRjdkBhNzn8IjSY/lfpqRLOxo1CPTCQM/wkA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When add boot parameter kfence.sample_interval=0, it will not create
debugfs dir/file, but when user change this parameter after boot,
it can enable kfence, there is no debugfs info to check the kfence
state.

Remove kfence_enabled check in kfence_debugfs_init() to create debugfs
unconditionally.

Signed-off-by: yuan linyu <yuanlinyu@honor.com>
---
 mm/kfence/core.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 577a1699c553..24c6f1fa5b19 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -782,9 +782,6 @@ static int kfence_debugfs_init(void)
 {
 	struct dentry *kfence_dir;
 
-	if (!READ_ONCE(kfence_enabled))
-		return 0;
-
 	kfence_dir = debugfs_create_dir("kfence", NULL);
 	debugfs_create_file("stats", 0444, kfence_dir, NULL, &stats_fops);
 	debugfs_create_file("objects", 0400, kfence_dir, NULL, &objects_fops);
-- 
2.25.1


