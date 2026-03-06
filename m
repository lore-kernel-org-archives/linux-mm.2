Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11058FCB619
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 15:29:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D73D6B0093; Fri,  6 Mar 2026 10:29:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 257C36B0099; Fri,  6 Mar 2026 10:29:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 047FA6B0093; Fri,  6 Mar 2026 10:29:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C251D6B009D
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 10:29:26 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8F4D51A0645
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 15:29:26 +0000 (UTC)
X-FDA: 84516022332.26.C64003F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1AFB6A001A
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 15:29:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WRg73TdE;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772810965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/N5I5kJjkEZIg64PkYpdtlaZKZ0JKdMBYrahzLr8qZI=;
	b=NYsAagTDGQEwBU6l/atYgFNNVdH3Sib9G+4Gy2fIq/iPep2/KtDSK6hEiljp1NdnRuJyTN
	WNnCer9bO0RAAsOHcR44zVIt3a7uCiPkXz94XQtHL2qABazLPA4EuzINO5smtKI2BTdwpj
	xXczMNSvoXmK1tUX5IsUF3IDE6T0fHk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772810965; a=rsa-sha256;
	cv=none;
	b=eu9mqL5E2W2uoZO5jzmMVSmQn6lCGo/s/fKjjpYYnQMehharpTZhBFLGu4CaTerBd1dobg
	LpgIIFj5vmMRbsUImSJ5oERsGtJC2EYTH6kWr9EBgw1gtyoIqcjQOIIJI6PGQ3IYWpnYIo
	WQpXblieJqEkjmFjDlPmIPA4hBCCXFA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WRg73TdE;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A7F8560134;
	Fri,  6 Mar 2026 15:29:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34C48C2BC87;
	Fri,  6 Mar 2026 15:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772810964;
	bh=iYt3HJjJZ2u5nNYQJzA/aRcSczmrsEXHtQU6RM/AfoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WRg73TdEVyvd4i2D+cE9DKozFYt2Lcl8StD2ZBnxuBM0TNHBmZtMWcKJvhOZbZLui
	 8I4V1H0TzahAbhtvqRgaG9uzarzmB0ssnWK1whlA/YvsWX98IMhiIi/mi+hc+vfoyd
	 J7/fw2wVoYrWLqgFExxpSEG+86Rii8ni8rKDjEDsnyrhqRKBkmNrgZmfPjXq9q9DiU
	 RJsd/RK4whkCF+zr1FTPvbz9QvPwWH9lOgtB6YHD8YOVPROqBpKffuvaFIcB9tmrMg
	 a9bMKvGd4ZPF6UycBVDy5YHa05AEqBytV6u+CP0Gn5ikzygJvasD66i71UG2DLkyvF
	 SyVMBLokqm+eA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 10/10] selftests/damon/config: enable DAMON_DEBUG_SANITY
Date: Fri,  6 Mar 2026 07:29:13 -0800
Message-ID: <20260306152914.86303-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260306152914.86303-1-sj@kernel.org>
References: <20260306152914.86303-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1AFB6A001A
X-Stat-Signature: kna4eus7ohsxk19uk7dogw6ojaqk3s1a
X-HE-Tag: 1772810964-989474
X-HE-Meta: U2FsdGVkX19lZhBUwVt51w87a1rZaUKqFArVK9NPvD9X6iPKmxWmjV91yA2++TmcdWCp9CUoIMHWvqfx/+MWfXaKx1OxolyjLJGGX6TxR1A7sFDxt2kjouK7Mgdn8oCKMqQByDKrYPciMdNZBtXjVwXNs0j3MoxFwSbE+qKveOfhJ2BMEwYfKUkeCiiIBNyF/5SmDLtr510wl63JW1pzhR4Q53h+WgMI4WLaKHvgVzZStCV61aB0/Q9cqw1QW+HvnXErzzma+k1dqip2pn5miHy8h93qOYUvamH/mJjPU8mLLZybX2wu2z2u5+WR3dgrq/wgWIrtpXPKEeH47M/+eMculRQzIBrm2gQSB42n9SKQeLepB/5VYFD9YWfv2eh3HBx4s/1eAjeyDIpJ0Cu6SHrxy1lap0hnZmX0Cr/2ncLG4ax6XA6aNDKPgRuOrimw20hTklT2l4+VdMSnh42g9dxOahDOAa9Ss8NyFBU1Od/UJV/FkqaUkNRbWiF0xLCdOwbVrsOwkPq7La+Ps/pFPp7E3sCP+oUBP/Qjmk2wTLMUll5nxET0D39IC/imfn4nARdW4OGH3Q6XOQ5iymOsq0oK3ycxnD1EaHL08QhImMMV+UoCQGny9dZzRXHctj/NhwC57LDdbFtto0LRLR1GerWQGianJ3Gq/DgFVz2JpmDEdPap4Zdi0ynqgcdwMQi4seTAxPxJZ7BIj0980S1Z+z03AreUSwlBWbOLG3+1ZHM/7oIpWVgPjZSmlh6mS/W8VY/gT8UOkJsqxJF/iJ65XWzJo/WbTJtybUiZSdiG/do9B3VoiFbIVM/q9l3wgYpk4kG6VAhnIapGGBL806CVQNFjLEOjbQn2k2cHCDqTn4EDew+XVV8xHUo/gun56Yf6uthBPGYruPm2Rmmv0/EFhhnsB3vKWP8QXTYZBOAesgF4MUb+04dIGvxamoKuGJZi5mUzW9mHhp5Vx/QYYE9
 NMzCBOrB
 z7iuXnIZwQtdA5qU=
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

