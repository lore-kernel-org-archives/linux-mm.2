Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F020ACFD316
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 18:44:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED5016B0092; Sun, 23 Nov 2025 13:43:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E37816B0099; Sun, 23 Nov 2025 13:43:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3B0B6B0092; Sun, 23 Nov 2025 13:43:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A3E166B009B
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 13:43:50 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6A5AC16017B
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 18:43:50 +0000 (UTC)
X-FDA: 84142745820.22.B327CD1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id CB94140014
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 18:43:48 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BYi9f6Rx;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763923428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p4i7v4nVbcSEudSmaHNFzQHwryIXTiKojx87AyEiKyc=;
	b=oqfqh7b9viot+V5EzOsTnJ/ANnHSHdvbM+SYj+y1ZoNoHf1LLMSd3UFF7TGJ+IXEeGGLah
	jEbRV1lqIfro1CRmbpEzTyiIwC0XYgy/7S1APCzG792JUqsWJZWpmpIvPfUiezCD6wX51N
	YqHHcgJoWOFvng0e0q55v2jZtyk1U88=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BYi9f6Rx;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763923428; a=rsa-sha256;
	cv=none;
	b=ERVQoLi7FH9AjZd/cKLxSNinDCRgEFTEYgG3QwrIauNOqyb4jB7JUyWNuYyng0erie8UAj
	e5NNTtIvUxGGdYV4X7xEjkQQJtSdM0oKBtd+3cJ6cFKJSF9p91GJ9IwHUrZjKdGiFsaoSV
	rbw27/KWAcTJFANg2RDOQ9E67+uCRHw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0A1C74439D
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 18:43:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC1A3C116B1;
	Sun, 23 Nov 2025 18:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763923427;
	bh=Ybb1QxrTxcSMGL/dvuVAmRcZVW1T/bi0bFKyjCzx1os=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BYi9f6Rxc+0CMnIHUHMDz+lfgFgknCKtvqjVXfYl+ve/HQa7T34ClRr6hEVo0/svZ
	 tBbqdU/pAr3Wx4t6yoqbOGnxB7At1cegTkOf63a7/Z91Y42MYkE61i65+LgDRitFFR
	 NpFSrSWW39sMVdAFNy1K6+pZ8qteehu2Ve4Wz8kS8AgkJ/ug9qmG072Xo7B9ikNjOV
	 r8iHDaN/UmObSd4WTqCejsHaKE5Xa/7T2QWj4c3Piwqlv5xe3ALScwDzhPZDGyLrHO
	 jEQpkBey3hUJIxrRLfH3ekhusmaCYgLuxArQAM1Mc2uepF0ypmKzzTj4gVLpM2V208
	 h1X+1I6NtwkIw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 11/12] Docs/ABI/damon: update for max_nr_snapshots
Date: Sun, 23 Nov 2025 10:43:25 -0800
Message-ID: <20251123184329.85287-12-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251123184329.85287-1-sj@kernel.org>
References: <20251123184329.85287-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CB94140014
X-Stat-Signature: kz5ypfxmfz7pc9ajceehehzi4trpm466
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763923428-898436
X-HE-Meta: U2FsdGVkX1+po13I1OChquRdp0JhWztLH8KR5jRv6q0pnVfVSCoqPU+Bpi7nzU4IpNbQMGs1UTZ/P38Fk44OTHfb4nmAp6dNaOc4O+H1wWLogWEoc/6DgQ9DTxvXBtcrV9TWULl4HkVRqbuw4n6mTAf1XrrKAdzINldqhXOhLMYZgcs+AQBQcPH2RjJioovUtX7hcmxDpuolJr20lWBD6FGSyNFyvrDVGFClUYvcpvwvVijIvljsRU/+H8H1zTuIpiYpzSZA4akX6cKkFrWROXENVIhT5dFGdOWqh+dYMMCDgCPajZdi5wpL4Kpl7hJzm/wn68kaMcd7TEMkXdYyutYbwx0TlmvI3ViOIAyMO/nLVZFLVjpx+ZrSR7m38hy2TH/1BtNolfXcxyUGJT6SxWmMQF4u3RHRnL/+KHrvR6G0k0ZzEgOLWTQUWnIcxwWSfpSMaQS8hClp5Rpu2ZeLpGia+I3FVlzMQ6SpbO5SQglEnBNHkRizebZptwyOMHXT6LRG3uT1P8fSNZNrXA9C7luFlSE63abEWpwciQXOgYrZUVZgUoEm8MxmvVxwjzJOhgvNHcsQyIqyCOZ0tPQw83oy9wbeSR2KMvCjGYe76UvxOUQicautOMHupk2N5Q5532t6La+mWejdi3Q/6Q2rBmKMImlW6FISwpjsGgP/cYFCIMuF6nI/Cok3mhDKagEBSOwqxtKUgJxBXSVwtmImgBz6CLlVYpxVdpQbQvzCo+gcP40NUEZ1XZ5fN9M/E3fsSGNs9D+pRBzhqpc1LX4Z8HxnXRjtHGeht9iOL9HOEPuDr7ozFvGLU7/OHzQJWFkMQU7QhDUeBvO9zvUzMhfrqnOsFOh93eVFBfKbetuOnJJg/gF1w2IaGqOipVCbJqTcYgn+iAT5tyO9RV1VyVMZ1BWOZkUyt4pPMGY0MEPdtPrC11J5DCO2bs9pbTnolDg43gc6Izcqa078O1Ze5+C
 Kt9EZ/ga
 hTvuIc2A8DkA/LIFW6KM+4JX+atN9yYez09wbEwEc+BI5g690RK0KVHK5t6Lu+xdiZ/0WZjwrygDaPZkGv5U3oPFP1nCcYDwFaWGgWgtfubp3dlUJeIgRAPFDUlrpWTMk0ygOHQDWuD77HonwGF9pZVv7EVCaMjyIK3GgFjV/oyIsd+XxIrcjO/bBtzodq6PyM6KmCemCrLokPfHo19AbQX1+RC1cbcgkeXyTj3+9JTwwl5GijYmeuBmv4waQiNGB5Bz4EqnEWjjkWzciZJqxKkcYOiLhKYS/G8uO1Q11azG3gUnTTqsoV/Q8y2zQZMyZkjWzQjALfFUte0wbW6bmANlUuwZiwwC4juGZzAQXI24iKFYqRKCHTRbjPWoghBcpduJJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON ABI document for the newly added DAMON sysfs interface
file, max_nr_snapshots.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index 8ec469eb4471..4504a0f8b446 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -522,6 +522,13 @@ Contact:	SeongJae Park <sj@kernel.org>
 Description:	Reading this file returns the total number of DAMON snapshots
 		that the scheme has tried to be applied.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/stats/max_nr_snapshots
+Date:		Nov 2025
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing a number to this file sets the upper limit of
+		nr_snapshots that deactivates the scheme when the limit is
+		reached or exceeded.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/tried_regions/total_bytes
 Date:		Jul 2023
 Contact:	SeongJae Park <sj@kernel.org>
-- 
2.47.3

