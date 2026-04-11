Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 999D8F3ED5B
	for <linux-mm@archiver.kernel.org>; Sat, 11 Apr 2026 16:49:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7D566B0098; Sat, 11 Apr 2026 12:49:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3CB96B009B; Sat, 11 Apr 2026 12:49:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B5D26B009E; Sat, 11 Apr 2026 12:49:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6F4816B0098
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 12:49:32 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 475A7E3307
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 16:49:32 +0000 (UTC)
X-FDA: 84646860984.12.678D904
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id A28794000A
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 16:49:30 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sNYxtZS1;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775926170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GMUCrJ+gvGwaDfmPiXkEDkPCzQINbFEnETxptdhOtNc=;
	b=ZHZn/y14ox+ZD5FpA8BIRCosXAIYmv/cEsnDksQMbuHE8GKJZReuVN7fnJYHiGgoNIpZUB
	vp9y0b2bWvNkGqY0PkgunVvqgquvqUa5GHFHq1awsMC0M8FhPHcvhv5snT5gyHaAX22Zw2
	OF6kqyrHOmnCWPD/DCG1IkVSNiSBtMo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sNYxtZS1;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775926170; a=rsa-sha256;
	cv=none;
	b=7DJS8VRb271fJoGMTd7GnbIQPiZTs48YMOGUj5YEqhZff8AJkDtLIj13JGZ0CaDM3QMc96
	TmbOLnZalTu5ifncTmkSffDqM4fH/7Hf6yLr7Aq0O/t7XOFDBAFgntuuELiQAHNSJ8NesC
	PLnFF+l5r+w0LAxRkaGDRdSDK4QbDiQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CD0CF44565
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 16:49:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 889F7C2BC87;
	Sat, 11 Apr 2026 16:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775926169;
	bh=WgiRHi50zFvHwjFSQiNfyV/FQHY8WOkdhFM9Jv3jqj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sNYxtZS1tdOejvA+4Kn34usOzwQPNpvKw88iKGSG85Zti9yROWmO50wi+KDN8QkwH
	 BLz57W2c5V9vkCGZ3CLrQEtZWBu5eYVFutIVnjeEUd11tpBp5oXF/UMALCChfkvxoM
	 EXv1SInihRiARg7e46ke9+FnUWxSWRDRi1gmD5F61bkw0c9Ci9DLPkf6wD8t7lrrRS
	 bCzEtIHRMxE1oIoFcjVYRtYWSwshcaN0jm6GkaGkzMpWhcCM3y6VSyhQ53fSrKNuX0
	 unw7lrQVK/IBIsUvimdkWgNSg2qgc3EsjmYZS2ClY+ymq/ETKoh1LNGSNiZcpvdAxG
	 v/9v9FnFRCMjw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v5.1 07/11] Docs/ABI/damon: document fail_charge_{num,denom}
Date: Sat, 11 Apr 2026 09:49:00 -0700
Message-ID: <20260411164908.77189-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260411164908.77189-1-sj@kernel.org>
References: <20260411164908.77189-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: cyackmuc8dhgfgx5bw4xmn6jin3b1krt
X-Rspamd-Queue-Id: A28794000A
X-Rspamd-Server: rspam09
X-HE-Tag: 1775926170-889018
X-HE-Meta: U2FsdGVkX1/+AlTR3JfkxZILIFgnkY8hPKYuBaclvpbjkVFJVPEbi3E8ZevRrCpSzxk+UGbeAQZGaHSh72eK9eMhysdfXxPmrEuNYezIXRW2JSZsqNsN4Rmrs6HNViZi/z1/VfnotMkoWbKlLVf720I4k0kTKpQ5KdtKQvHHODxwhWLclh26Js4uyRScuXcWI9ltCA4X7/vo6aaw3Bfj4MWfw+VWtYwUbCf39cJOEyDtaWSmySi4CdEo9lS0FJfa+MUUUh+cnBagNf+rc0WejhofPPon0Q9xVRSRICiLj2Cfkk83oj0rvNiQjr6jEzukD+UrEKe+EqOqDb0OviOl3Xztx7Ftzlgq22VKWHyTjauG+KYKu9ADRF9qFGIoi7/YVlewyiJcjVEzGhOJv6nUk0BT/kQ5IAjwR52Rg48uzALNT44z+jR4fqyoVYTVG8jPgvAhUaTdao3aS60hywLNnnzECaOJT3rbIh5XA04MASuTUfMRJPirSKZ49Dxt1R54xpzB81a2JOiIz5yv4ThBwf42JQcd+DphQXxjz13fQogr/tPoA+1y7RUdkN5S643gimHz3z7wIYPJN6RdsFDm8ETBl5vlIsBue9xfqcLtybKGYu1v/lHER+pGo6f+7W01qc3TsQ4/sVQOqXbHWpEN21bLUn28hUraXpVfcePzPqdoDmeRj2tkrP9CLSOapN8x0XP2RdEM4krG1NpmiqEKHLjqWDnbnP5p7RYcCf2cG47VcFX1v1S/xZYfRJFvADUku/Uiwun25mUkycRct74xLWm3BBlNwxcnyOa0WfHjXHVi9AA+kP+4kTuSirp48zsFck6MYwghPFBnTATWGGifQdpkGK8llAZEVckhwdeRwLCejbcopNgwNFMvWUxgwRbI9FbXCmIMOZzce4vd2u3aq/BmLX9xljqKx4au1lBotiel/kBkPqnDyrb6ifAo9lL/P/WbdRJrCj8N9CrSBuY
 OLh76E3V
 tKOe+hgnmi0zXf0KLYtMp7doxAaRcqecG5NZKWWZuKaxMZlyQe0DUdoy+so7Uu5zVWGCfVpeJ3PjiyakGG61Z3LFIvpIGj2xhe7aXQNvLGbZFs903y2eIIx2w7rpG/+A/LTCDcO9PZ3nz+oxlzBbxBm+Xc2ZoIvKH0nAE0ZSae1KqhOCftiQBk9jQt9kJ9YL6QDpoexA8QCPiSTraZ8TCV6os9GktB9n2bU0Fo82wepYibOBw1Sus15A8gS8IkDwE35N9aeZfaVLIogER7lRxSgYUTHG47y73JRSyOVdjDUiLxpgncVZK99RUJHIzX2MB7fd6Rngq1H+MkNzSNqTPvFUYbRgNpC+jQH3DOD4k+lRntscuSQoaueV2aAbXXIUMoFCo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON ABI document for the DAMOS action failed regions quota
charge ratio control sysfs files.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index 7059f540940f0..971c22e34e722 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -329,6 +329,18 @@ Contact:	SeongJae Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the
 		goal-based effective quota auto-tuning algorithm to use.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/fail_charge_num
+Date:		Mar 2026
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the
+		action-failed memory quota charging ratio numerator.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/fail_charge_denom
+Date:		Mar 2026
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the
+		action-failed memory quota charging ratio denominator.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/weights/sz_permil
 Date:		Mar 2022
 Contact:	SeongJae Park <sj@kernel.org>
-- 
2.47.3

