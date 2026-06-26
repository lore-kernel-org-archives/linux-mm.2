Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E8F7C43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 17:56:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CDDF6B0119; Fri, 26 Jun 2026 13:56:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A50B6B011A; Fri, 26 Jun 2026 13:56:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E22F6B011B; Fri, 26 Jun 2026 13:56:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 004B36B0119
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 13:56:42 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 776E68EE9F
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 17:56:42 +0000 (UTC)
X-FDA: 84922819044.17.5EE5A4E
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf19.hostedemail.com (Postfix) with ESMTP id 934B61A0006
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 17:56:40 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="o/O903/4";
	spf=pass (imf19.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782496600;
	b=H9HoZOQRtW89VRYjAMhJE1tCFwXQZS7oImgUbv+lfe68FeUFoJ4a8Kw35Ti7ORNP2GYolh
	JgjimoITYJEvOv9HOiynG7a9nlwlqKWB9tj0KF0Y+fWv7EVeAWWziEyRfmxdVVfTNvd3NW
	cU3ogm0hzHHa/ZSYAcD9B1OT1e4OVtw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782496600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=T/yDNeENQk5nXiDTD6qUqgk0a5MH4BVfVQczVhaVuoA=;
	b=kmgZ7YswXgCUqDcCKaEmNX/OMoNyC1WYSCpz2fu8KOoi1f23O0YFY3vciNHhHfl7zZpqaw
	eVs+gTqtTX1Tgm/DXmV64LkpjHF12zAFeEe2Zs4PvTzU5pfAeo1qNFf+xhpll+cNxkETNU
	Nra0mvlW1ygExMVTXkj2CfmkN4J7v6I=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="o/O903/4";
	spf=pass (imf19.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:
	Reply-To:Content-ID:Content-Description:In-Reply-To:References;
	bh=T/yDNeENQk5nXiDTD6qUqgk0a5MH4BVfVQczVhaVuoA=; b=o/O903/4w/EtEg45tOoobMYYDP
	2a+ZpaDby0ydOjaAFzI3HDvAi75KnNBNfvxOXbAGFMCDRK8kh2fSItbT+tZzkP809++cIwnzv/gF0
	VDUCVz1bmsUknmz0s7XdE4c+hWsZeBW3fC/RCKj1oXknpgxB6MpvLPSCMHjzHQXubSCyVBsK57JXz
	MnkVIzaJO6WZtu7fhu0goXbByREjxq84fQRf2FEvGzmTwu1Qmb0mmuuK2ffZ3eeBtlE3ZcrngfhQd
	NVELMKY2VGYQGgGKLJ/DNWQOog1PyH8+nBhZLh/HUg3BJdnR5ISwx8ycvBFHvz2bWAUdwPWH9bkHg
	n5Wlzq1A==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wdAn6-0049GT-0N;
	Fri, 26 Jun 2026 17:56:36 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 26 Jun 2026 10:56:23 -0700
Subject: [PATCH] mm/kmemleak: skip the remaining scan phases when
 interrupted
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260626-kmemleak_improve-v1-1-d40c7616f64f@debian.org>
X-B4-Tracking: v=1; b=H4sIAEa9PmoC/yXM0QqCMBgG0FcZ37WDNcbEvUpELP2sP5vKZhKI7
 x7l5bk5GwqzsCCoDZmrFJlGBHWqFNpHHO/U0iEoWGO98dbrITG9GIerpDlPK3XjXF97GtfFBpX
 CnNnL51+eL4fL+/Zku/we7PsX1PKQV3QAAAA=
X-Change-ID: 20260626-kmemleak_improve-944f76e04da9
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, oleg@redhat.com, 
 kernel-team@meta.com, Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2072; i=leitao@debian.org;
 h=from:subject:message-id; bh=jUIq0vG+C05UP/DTkd9jKQvB8xrfwJswbYd2kkAvLE8=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqPr1Q09NE00N7Ut2sn7fj4Q5Yc8O/oeXef1jz/
 SRugHPzRjyJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaj69UAAKCRA1o5Of/Hh3
 bSPwD/4weBlccb3jshkAIQwtDS2nutd635NMNywNKDZCdoNpA0I+OTSGbpS1qMZ+5yi9WYFQQy/
 ZliuoO44azXy0hhtHwBc5o11asj4MrMyJNY0H06wZln1puMB4nGYbWEREVOlgQQOfg96iMpFNjG
 mWI4OcKm752HKzWaQjJ/WyPMOTw/XaP9V56mHccLT+mDTYqyc118GbcO8U3EaBc9DZC2Vxtymr8
 NwrziB08OSWev5gsQ64yFQaibhZsV7+chyysGW5Z7ZT3w9H+dLN7Q/bFDbE2+pTmm+q3nkom2z7
 /cYABjWRC1uBDxX7CCgWHLE/X3MOEaqealCAB4tA92tQEpfMXpuK8xUEFpE4OnqlMaVQEoOYXxA
 rIl0K2O9IDjIV2CuvV1zj+0S11djrajJtI3EDfCvcgKx6a5w1P9aiaVsqDSsjNMvXp3FbuPEbKF
 7uskjJB05GGFTIyB0hOXaHAQnwbCo0Ba2rxtmTe9AlPzrlJYg0fESVBC9C5j8XFx4eSg3RP6vxv
 IY5n/xdF9q/oNYQ72QY9wmRNhRnCptckFFqISr+dzAtoFTf31Avm6L8Set5+lt8D1nwJ4PgdWZK
 odnVd01my7zBX5G9PA3hIhQKEj+zzXuQutOiPIcHLEuv3DiO5TQ8QUUVNIR2+1H5VC0CHDj9tVr
 JfBcO9cUM6Xtl0w==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Stat-Signature: it5zatwogprjqmqpb3ku9u3rk9gzmost
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 934B61A0006
X-HE-Tag: 1782496600-702601
X-HE-Meta: U2FsdGVkX19eDWKp1R3bvNwZH+Z+ZVPY/t56+0ubDdqVv5viH47Suys+f1vIfuuL30UXNHfRRiRHPma2g3V+QytTjSayJ/f3hFTqjIMYHkvjjjuhoNxYGP5eQ08Gz/0FkmgvgJEDK5MHQ3zrzX7lIbHIvf7NiioM31/Q+NC/4W/K7rZL0n0JXIc/15DckhK3SvqMeL+8QlP8y55w40qol9bmcqBOoSmwpzqsgyQCNDXCjJJ7fJi/R2QfYxGvZE8DQCeNscaOrUlRZVex5Ay1d9GIpGCPraJMsn8umPv3v7GTYdI49qM7BwuGqfou+zV+gjLBIXyC/cCXoYMLzVEqH+oeJwPkQRRdM2yuD6fgM1yFtV89AfIDNbXnL2nLzCIokSj+cCdwZqr33vMfbmHxUwPJmt9aWgLnkSLEcwwtSHuXi9tyFoAMzVkcJMRYeDmbwWSgKbMuHt0bgjdS3LEY1QPWXR4lC0KfAM0L5QhiOPLdXUFuB1s6fRvfNplHwvhPrrj9r+pg913jVOlF/krv1Jj5uYyhs0cWTMrokLeqbEKxtahi0YGCzuk8zkhw3jvVuhPj7JIPbpzHBk/iKeK/UoEZ/dkUvS1HiWyljM8p+mCPbEkmLIERZkwBE+N1jwE/c4ycoAOohdsViQxOPSO1+m7/aWdzzgjzrCKpWB7g84IbmlrWZ5VsBwboCh1n2KJeFNqjvi1bwJniV2Wu+U3ubK0Gvk4lv8L1YUhlga/EFyfu6r7EAmdk9srH6cBTwb66vgDowGgGjcbmNsBz3o9+f512JMGubNZdjDqoosUsK/RGvQdlfWl//Cpo55krtm05r/g7nSKuseG8Di0NusSOsmAkij2miD0vBC/RoD2hrNAynRTlEK4ZJ1OOb9AFBPnkfwYZYtjs+dOyX8tfnXDT+5r82y0YDScQdxaJfKr4UKIDrH0VdTPsnLJ+T/BHxiTFy4N8M6awHm5DKuInV6Q
 6gp6cAIp
 OkZZK/im5ZniyynTVWIF4Ya88HwcMphSYGrg/58UBDn76tNqNVGWFei3RqsK7LUFd0JXptmQTbvrMR6qvoKJ1aYoXVyMLd7U/56G0FKJQKgsJC+t/6z0zAlyPEGKpd+CzGau7GVw4RO1qtKIYuhZ2BPjkkRuXAy54Olo03kYBt+Yav2uPyn6tNTjxuVh6sm5OqHfMNUyPTWoqkDx5DtenWdLX6fd6NLAjwglI7GCYtfWnU77QLYi5d2b2OGbj5ZHl7j7ys6jbWh6cH0JGywx1wb+6JEkKC0yMN1jNMXE02J1FqeP8tg1HMGCkxg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kmemleak_scan() scans the per-cpu sections, the struct page ranges and
the task stacks in sequence. Each loop now bails out once scan_block()
reports the scan was interrupted, but the later phases are still entered
and only bail on their first scan_block() call.

Jump straight to the gray list scan once a phase reports an interrupted
scan, so the remaining scan phases are not entered at all. This does not
change the scan results, it only avoids the pointless re-entry.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/kmemleak.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 7fa7124727e36..68a0e30eea1e3 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1850,6 +1850,7 @@ static void kmemleak_scan(void)
 	int __maybe_unused i;
 	struct xarray dedup;
 	int new_leaks = 0;
+	int stop = 0;
 
 	jiffies_last_scan = jiffies;
 
@@ -1896,7 +1897,7 @@ static void kmemleak_scan(void)
 	for_each_possible_cpu(i) {
 		if (scan_large_block(__per_cpu_start + per_cpu_offset(i),
 				     __per_cpu_end + per_cpu_offset(i)))
-			break;
+			goto scan_gray;
 	}
 #endif
 
@@ -1908,7 +1909,6 @@ static void kmemleak_scan(void)
 		unsigned long start_pfn = zone->zone_start_pfn;
 		unsigned long end_pfn = zone_end_pfn(zone);
 		unsigned long pfn;
-		int stop = 0;
 
 		for (pfn = start_pfn; pfn < end_pfn; pfn++) {
 			struct page *page = pfn_to_online_page(pfn);
@@ -1933,6 +1933,8 @@ static void kmemleak_scan(void)
 			break;
 	}
 	put_online_mems();
+	if (stop)
+		goto scan_gray;
 
 	/*
 	 * Scanning the task stacks (may introduce false negatives).
@@ -1944,6 +1946,7 @@ static void kmemleak_scan(void)
 	 * Scan the objects already referenced from the sections scanned
 	 * above.
 	 */
+scan_gray:
 	scan_gray_list();
 
 	/*

---
base-commit: 338a2c2582c8eddbc11cf35463a14a36c051afb5
change-id: 20260626-kmemleak_improve-944f76e04da9

Best regards,
-- 
Breno Leitao <leitao@debian.org>


