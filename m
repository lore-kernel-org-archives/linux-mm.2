Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8BE9CFD2F6
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 02:54:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 897DD6B0012; Thu, 27 Nov 2025 21:54:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 831F06B0023; Thu, 27 Nov 2025 21:54:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EC4F6B0027; Thu, 27 Nov 2025 21:54:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 260DF6B0023
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 21:54:27 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D14D55875A
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 02:54:26 +0000 (UTC)
X-FDA: 84158497332.29.2A9A7CA
Received: from mta22.hihonor.com (mta22.honor.com [81.70.192.198])
	by imf16.hostedemail.com (Postfix) with ESMTP id C29F318000B
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 02:54:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b="D/ONv38m";
	spf=pass (imf16.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=wangzicheng@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764298465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ayengAhX69VuLBH0udWTRo6vLW+weVNlnBoDZD4F89Y=;
	b=sg8XoNOmGqEIAcfiTHx2Dpv7ruPmDCTNXF2QTj1Hu7LkkKViL3UKnVpAvn/UC53cWvQuHM
	PmI+oJtyNEO31SYUg5QEJkKcN1lIOJRTDxM7QWNP1x8r/1FbfDhCd2LSkfkbGKCgQWxhvZ
	+fBPyzQjSOyuBMBWFNu1qk6UYmydPuE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b="D/ONv38m";
	spf=pass (imf16.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=wangzicheng@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764298465; a=rsa-sha256;
	cv=none;
	b=M12ffKgD9zB7AFCKKHcJ4zsBKulKAFaCUJ8fe86+KRwR0APxg3leNdkzYkVOCv8GR/i8Kg
	QlHaSPUpsrbeI3bbiz4aQP6B2eM0ew7gYwW1LrfHbZwHGWhNk5Zgl5EJsRytojGzTstw1u
	rPpb/XNUpogsM0vUdWFVBgYhEjHoRKc=
dkim-signature: v=1; a=rsa-sha256; d=honor.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=To:From;
	bh=ayengAhX69VuLBH0udWTRo6vLW+weVNlnBoDZD4F89Y=;
	b=D/ONv38mN1pq1e7180jj6fLd5a8259bJluYa3QO18y6zFy5F/tRiYEJP8sym2N7hA863amxvr
	UmNMVh51G4h4+er9cvTf/XqUjjc4dCIuQNJ6lR9iPwniiE+8aoFvWlI/2gJhYBYcJyOxXcb7XTV
	KBo6WDRcjPl4ShX19XnFtbQ=
Received: from w002.hihonor.com (unknown [10.68.28.120])
	by mta22.hihonor.com (SkyGuard) with ESMTPS id 4dHdBN5DVfzYmwXH;
	Fri, 28 Nov 2025 10:52:28 +0800 (CST)
Received: from localhost.localdomain (10.144.5.36) by w002.hihonor.com
 (10.68.28.120) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 28 Nov
 2025 10:54:19 +0800
From: Zicheng Wang <wangzicheng@honor.com>
To: <akpm@linux-foundation.org>, <hannes@cmpxchg.org>, <david@redhat.com>,
	<axelrasmussen@google.com>, <yuanchu@google.com>
CC: <mhocko@kernel.org>, <zhengqi.arch@bytedance.com>,
	<shakeel.butt@linux.dev>, <lorenzo.stoakes@oracle.com>, <weixugc@google.com>,
	<Liam.Howlett@oracle.com>, <vbabka@suse.cz>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <corbet@lwn.net>,
	<linux-mm@kvack.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Zicheng Wang <wangzicheng@honor.com>
Subject: [PATCH 3/3] mm/lru_gen: document procfs interface for lru_gen
Date: Fri, 28 Nov 2025 10:53:15 +0800
Message-ID: <20251128025315.3520689-4-wangzicheng@honor.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251128025315.3520689-1-wangzicheng@honor.com>
References: <20251128025315.3520689-1-wangzicheng@honor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.144.5.36]
X-ClientProxiedBy: w012.hihonor.com (10.68.27.189) To w002.hihonor.com
 (10.68.28.120)
X-Rspamd-Queue-Id: C29F318000B
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: sirwbao8efi38x5ymtbjkgzj9866ix5f
X-HE-Tag: 1764298464-251543
X-HE-Meta: U2FsdGVkX18+DdMPm2kkGnoY+P/E+HyXY+DInzr4sNQ1lfQkLWya7DTOu9iJpFfNoW2USPNFNu8ZWpjFYmeTPabHDVmbiWm6gcUbBt3dQ6+PzJ2SmV6n3Rl1xStJTVrZrF/D0wsfp6EyBnbdKaD6l1i2a3Mpra4DK16Myb3wGU9WUNpC1mCFMyEYwwUvngY7jZpGZT1US8H1t4zq5B3+ql1WQKFY2gKEBAy/qHVfYH1s5ENGAo1YTCavR9x5qHDTaNQpvKTp7O8fQ20vo7NeXHCZAotk+kEvl8jRUiY5SQ8wL8g19wl2RRK/kwiLsvYywRTgsPC70tTVF7ZX46ZD2Kpwf6KzJKUXCHAd3dvJGMLNkbFGLpP4CPWilng9wKfeLXjKSitk91Sfu0raZVFcSmJjcH8B2vOvk2IofgQoV/YV2HXXbDHCQweqcBbFzVsHIYIjadxCc5mdGywguQBxsWcY6hQ90DOv7nKD0bCnpUpd6KtOq8YcVpNwvQ0fEBXR+N/nxSmd87T2ELKpAJdn34NAWWvJszt2o1PfjeYu9FOiAchKja302tLO3mgJOh+Pmt/iMSSRJBl3j665Yillm4p+1HtZm09rO2VMwVoAabj4zAAjgU84gjkDKL1CyZDztXzxp4cOgwC3iae88IZ/DAQJSgGvO9HR/nJg0wBSNael+2j50bvAHT3UvfRmJr6d+5L33eh7CxtVZ29VDt5MZUioMtpKbZy/fWv6T8KR2FVHTiHFyqkiGoEf6jfz6ytuotCeK4ExGYVBLFhlTTnTMDL4bkc0qmjRailCfeQqxZkVGFC+whpUs70TQrhWhlvh4+qKtzwjE12Ni2HTKsYkP3+oSgH+XBf9/PMnIs3lplXx86e4sjGqKzGk3wzgSaSZs15J55amc/EuYfkm7Dp8U6nbz61SlnFczGjVEU+466FESSG0PmEQYcb7iBOIAPV85BKsTRwZLEp+Jk6p0hE
 r1qGxv2z
 T7q6IKSj6lg9Y8AczTGk2ulOXuA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Signed-off-by: Zicheng Wang <wangzicheng@honor.com>
---
 Documentation/admin-guide/mm/multigen_lru.rst | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/Documentation/admin-guide/mm/multigen_lru.rst b/Documentation/admin-guide/mm/multigen_lru.rst
index 9cb54b4ff..d9927b254 100644
--- a/Documentation/admin-guide/mm/multigen_lru.rst
+++ b/Documentation/admin-guide/mm/multigen_lru.rst
@@ -161,3 +161,22 @@ cold pages because of the overestimation, it retries on the next
 server according to the ranking result obtained from the working set
 estimation step. This less forceful approach limits the impacts on the
 existing jobs.
+
+Procfs Migration
+================
+The multi-gen LRU control interface has been moved from debugfs to procfs
+via ``CONFIG_LRU_GEN_PROCFS_CTRL``:
+
+New Path
+--------
+- Control interface: ``/proc/lru_gen``
+- Replaces debugfs path: ``/sys/kernel/debug/lru_gen``
+
+Key Advantages
+--------------
+1. Production-ready availability (works when debugfs is not allowed)
+2. Maintains identical ABI to original debugfs interface
+3. Preserves all core functionality (working set estimation, proactive reclaim)
+4. Standardized location matching memory management conventions
+
+Note: Requires both ``CONFIG_PROC_FS`` and ``CONFIG_LRU_GEN``
-- 
2.25.1


