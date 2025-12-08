Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB9C3D3B7E1
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 06:30:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E36206B0026; Mon,  8 Dec 2025 01:30:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0E086B0027; Mon,  8 Dec 2025 01:30:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4A1F6B0028; Mon,  8 Dec 2025 01:30:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C11856B0026
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 01:30:12 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 83EE41345C0
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:12 +0000 (UTC)
X-FDA: 84195329064.29.94646D8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id D3C0F120006
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:10 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bWYxgDEw;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765175410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=itENM1LK37FUtfHGhDXxQ/BBCcKj1prD9OHDpiMzp30=;
	b=7IMi6V7sWzPMA2qpZ/014vlVxR1Snt7qOso1xhxPWdcm0uQD8qKy0p9/Jwox8jo4IIvSj0
	29alkhLjvUL2O7a98TvYCVUN4Hr/1fgVzkpowvR/VVv4h1+HmAfrmJXYyKJLWmq+tl6JNl
	ZeJwZkdYMyN1sBiYGMqfL2FUZVPXu+s=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bWYxgDEw;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765175410; a=rsa-sha256;
	cv=none;
	b=4OO8ScJVf4ojQChwMwqRo1p0vo9uRXufDlYlucQ9E0PxRVUA4s5GeJfrBSGPtfEcM0ZvhD
	fFtJu5h5joIk5ZZKOdunrut8RkbGmWKR+IZ6Jpl6bEdQ6cvKdW9RjbIANctum8vkezUe4q
	ObipSsNzq4S8sXLo4JNmrGFRQcihWys=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0CEEA443BD
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23296C116B1;
	Mon,  8 Dec 2025 06:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765175409;
	bh=At5tPajQSPLt9hOlFCrxmrzWPKun1WpQ7z3727tgAL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bWYxgDEwewUI4Si1uvn2A7qlU6sI0b+yWp6SF/szJF2mbBBdXg0ZIAIekRW+ZOrrG
	 6TbmzOGczenZfeBVT1eGwM8skmQNCoC+T7rzUAg1s/D7qKk5krfv223sDy+Et7SKYV
	 oKDb/jYUtQD9s5Sp7d1+s6HJyBRA78C9StrcOfWWsYip5AOF/H+pRJNQBU5+6oOv9w
	 bB8o7cqHCaJ9YJ8Qk3M3o0RMOD2nKZPDQiL6V77bFV/BxTWnDPT447D3IS3ql5eu4y
	 Hm319ClPVM1KMf1IeY6kU7NtDbSWg2Wq3lUwZjBk+UOcPyDyvcpSJnwXRSjLE7qQRx
	 /YO2G1qXPqUiw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 13/37] mm/damon: extend damon_access_report for origin CPU reporting
Date: Sun,  7 Dec 2025 22:29:17 -0800
Message-ID: <20251208062943.68824-14-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251208062943.68824-1-sj@kernel.org>
References: <20251208062943.68824-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5p6cn93nyjaxp67zdihg33wad168by3c
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D3C0F120006
X-HE-Tag: 1765175410-612878
X-HE-Meta: U2FsdGVkX192vmstTrC1gB7EVt9e3AK0LIEIb31OanNWfbnAaUofnpPH9KYS2mDNpIXm9T36xZy91yMoyPf0UvokZTe7i8rTXEmwowAxhOZj+tfCzU4ixuddHzTEUPc/OQpqbkgd3RKCerpeWTQAmt6RdQ+8Cf5PVjl9j4imU8OAL9lfmmsmIfOleiysJmR4Y5g1t/PL6aElexLzK9yHPwqAy7SCOpu9IZoR6tCq0i9NBaiCMNr2saZ7pjssyY7MSC7ibKWD2yFx9rsingj2SNHqb2yo0rKhz/kJEgnMIhbhVWqX0WOoQcfs2aFrKkUzTDKVwEC7hiI7mocTWEneBu060aUatFdf8W0yotDvpZmm9Qlj8wCWvkLZxHqWb80IRTTl5lWKDWsWvrM2mhiG4O7iojUQvaWCVGmNnB4lwBh97gD3Rkf5JROPzDC1Q7ahTG3PB3284qB1OQn8PtltIOThOXLJ99/kfvuVyO1oG3hlXkUVjaHg6o12y76+IXO9unDXK7Y0Zwq3hJ0wPU2/0w7aFbqJvBMSghB3VneYY2s83glFlulWFHJbgOH0v9/+ewr9pyLAzGv2W699WbeKv+clMRMrMEZSImx/pAhiXSGpq2XcfcwwAv7ZB+dxDnXmdJyokRxTOe3OOSwSn3d+AL7KnH0NMyNnkUv1He1vYdYfsZT8ytl/o10Dxds+zEeJndJwkOAKFT6eQsSFeDrsthMq+SjohOgXy1iFgnQeOpdmdEpBXZL6K46YMQgx0R52JmkoLnJ+mBK9jJ5jPrK10m+Z79FxHgo7kpcvUM34z/5hlJKyXF8G45WHeCkSFwFxI5EVpAXYqQioz+VYQHDdfD9oa6D/1P/rTE/1a1puXaBW30vrnuL1uE2hgKRDF12esMSFFrlNwGG6LTkUyRYjSQXlcxtvTvuDMtYlypQvndOm5gqmVf728MS7SSS9WYhKkLZxYObt6V3VMTYdUZc
 9gL2hDNo
 gqRH0dfqcLxapzuo6+OfAyxEekliTixjvXls+Sue6VEmrr5YnXSf3rvEbsAuwUM54SGngj0PmPE09BqUkTgG5cPkaWT6mc/pYAJcnsYQ0rlXW/m2Po5N1Es9mmLrVXJP443eWx3MxmG/EJyHIt1PuhO1YWPKY3+7D1hkPgyNN3Fg153f6FWh5RjXTtFvGSe0WwntFvR80b3rA91OovK/C/CdYU+UjfO2202SYkbMnwzaaDEXhR4Dd+zQUpOYCNqQBkB7Gwmahqwv5XHHm2Beb0sdQ3S0TKNvuT5wyqNyGERjPSFu6W0e0CjWVxno1Ebu1kZlCgoPAnRas0HSCqEh0DD6DLFv62Iwy9uHlKiRqweqUuc5zR0OBvikuDk5y8HoShVGT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a field to damon_access_report that can be used to report which CPU
has made the reporting access.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index b04c2e36833a..e23a10ba7c92 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -115,6 +115,7 @@ struct damon_target {
  * struct damon_access_report - Represent single acces report information.
  * @addr:		The start address of the accessed address range.
  * @size:		The size of the accessed address range.
+ * @cpu:		The id of the CPU that made the access.
  *
  * Any DAMON API callers that notified access events can report the information
  * to DAMON using damon_report_access().  This struct contains the reporting
@@ -123,6 +124,7 @@ struct damon_target {
 struct damon_access_report {
 	unsigned long addr;
 	unsigned long size;
+	unsigned int cpu;
 /* private: */
 	unsigned long report_jiffies;	/* when this report is made */
 };
-- 
2.47.3

