Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35F36C5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 12:18:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A087E6B0110; Wed, 12 Aug 2026 08:18:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 805F16B010A; Wed, 12 Aug 2026 08:18:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62F2D6B0114; Wed, 12 Aug 2026 08:18:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 364776B0112
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:18:39 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8A73C120303
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:18:18 +0000 (UTC)
X-FDA: 85092519876.22.59E4663
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id E0895A0016
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:18:16 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R9S12A8I;
	spf=pass (imf15.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786537097;
	b=sQdL+sYXjUKkzFQN9vFZQTwWSVXRreGYNTnvPzwX/fPFCc/xxl/cTsYsO+Pp4q6EDkWshN
	I8jC+pAyaHuCyIXhGwYaN05YITuhsXGVX6E9nULz5kFiMx1Dn2T4O7d9JOvuq3ywKxK2Lp
	OTjHrcLjaXUL1qnV+IWIGkKYq6BAARs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R9S12A8I;
	spf=pass (imf15.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786537097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uepm22g2J/5iiwM0/TymuO6Dk8rItX1/CDBy+v0l+eE=;
	b=0TQOkPzndvPoG6tDmPM19f3t5dgLP9+OSMC9n+FyANM3uMjgKXXsm6cRjCOQwEoPrG/V6V
	ZjIA3YR8pmJPYK878r06jADUHrV8/XGlaWgMPX3rqMG48TTqbLFuzsYUCenoTanuyEWqtD
	8hFWZoKTRIJLzG8Owp5FB3rsmiuG5RA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2F4A844EA1;
	Wed, 12 Aug 2026 12:18:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CCFC1F00ACA;
	Wed, 12 Aug 2026 12:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786537096;
	bh=uepm22g2J/5iiwM0/TymuO6Dk8rItX1/CDBy+v0l+eE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R9S12A8IO8zHeVVFYk3oGKcmS8dHnKtd493X3Or8A9aMUAnd6TNwa1+X4f5MGtMO4
	 HZkg1bXcsT54Nq1o0ZUngNCkE7ad4jVS6yhmG9vec/HJLix348ZdwSfOffTFYWzUQn
	 hlQ8+kbywEs6WbtaDYMCUFY6Jt3Y92l0pxWPusHszQozoihM8HV18KN4Jf2RSME68h
	 FDSuRqkmtnRbAzctC9qysMudGB9lb8be25nzo46e9D+vU6CUqdrBdL9FlU9F6/ePLR
	 jV1Dtr/Bon9GdcngDpxypLFv611Zo0azHucegMQWobd0dcSjZXFMZa9UenFCzkaosC
	 0XnW0QYQJb98A==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: axelrasmussen@google.com,
	chenridong@xiaomi.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	stevensd@chromium.org,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [RFC PATCH v4 03/16] mm/mglru: retry the same type once if isolation fails due to races
Date: Wed, 12 Aug 2026 20:16:45 +0800
Message-Id: <20260812121658.69965-4-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260812121658.69965-1-baohua@kernel.org>
References: <20260812121658.69965-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E0895A0016
X-Rspam-User: 
X-Stat-Signature: jx946fegwf78gfdnsy6nm65zzujgyymh
X-Rspamd-Server: rspam06
X-HE-Tag: 1786537096-983631
X-HE-Meta: U2FsdGVkX1+PN1XhfHwfg7YgkgkB4TcHDUDq0DtO/BvHc7SijmECYQsZeDfYhUsKgoT8jAYIc9hZcgCzsxyT9LI7xQ3+IX6DNPZWCET8W5BiYhwKXddnLIE6lvFsFRtBIWKUmPH4CT0HFp+eAxRSC6z+I1mrcUwgsb9T8TH+Lat406y6JCxTs4+AOVPMH3nhtgHl9JiJR4KTMSKWE8Dw8aA4Mm2a4AvDCux1z9fk186YSxOPAFoVh5YrW4ADNf/e6/eUpVChJUbyZWPSozLVE6lQEZ9lvr50GLYNxKkiD1ydQVW+vEpJrZicH6q4YI/vH6Apytvxc9SQojlgSIAz1Mqsq/LTkdJfhzxfgcRwL8fuhmmonbElICwaZlnrger8dtux6wvw22MKMc98mIeBh4iQN11cK2yH5yDC9wMzqSMRHois2KbARgTovoeWYkVpJntUgC/DDi0ASuk173Vb95NoJNsT0Eu892BjPNMpx7fZdU71kGG/FJz15kV6RUeZD4yfWBGC4RE1a0HtLvWAdjrRQuBdpE7sf0mIjWos0Wwk6Xn48FK5ZCHD/t0uNruNhi6dlnoBh5/7Jddb1id9gZBGb965pHII/taSS9p4metXnSYT0fGo2gwfox9SuCDIOGfNx3UJBrKIVCEXOZCdkYH5tRtYXPMfiRCuEXtjH8jXLFpTFTuOAQ/hc/29t6lgZTO19U/AUEtLkT+yyPrZ3dCKkIiwUTY3FffQKCTNHJ3VFYJ9PJEEqb9ljKVJFgfPmqc//rGCiTa9uLpKN616VDDa31gmpYgQsJFRdocW8lXjEysYvOPvEn1zEchmT07S1AZcCWb/JwCiCDQEl2qwFPXxUqdV1l/xCSUqIuGu8T42Hv4DLqD8BBuL5o0BQ3nb2xTjVc3bXxfVEuPgAWpTPsBPy0+FD9Ed2XlcnnBXCf7lIXp2bWsYDmDT472F35DXvqObqBn2dp0DwXDGfn6
 /i9OaJrt
 aaq62fZp8mselO8DctUxv4izKv397EW4GadfsI83xMXHrksKCMXIgKjSzpnKq4G+grvkLqs/I7eiOk9Knfwz50HQgOn1VmPN8GlrWer2g65cS8qv6uXPDyeI+UwZvxOFhe88mYpvaWNlPT0hP3fcxHCd1p2ai5U8Azpz1bVARywLOJBLyGV6YoXQIlhVh8RR/Lgd0OAdLdRI9xbv9cX76XLKb8REu2EBAtCKF0U799ImIsoIiBRqJXhQ/RJxlCa9Dg4wI9t0pPwjKGRJ2hYwiyDDJdNm5sUhPLonKkR7gMD1kbGo8fRmzkJYCPg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If we are not exhausted (i.e., there are still folios in the
reclaimable generations) but fail to isolate any folios due to
promotions, protection, or races, give this type one more chance to
avoid going through the outer loop again.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 0670a25d3a7e..dddd2ecf970a 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4868,7 +4868,7 @@ static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	bool type_fallback_allowed = !is_single_type_reclaim(swappiness);
 	int type = get_type_to_scan(lruvec, swappiness);
 	int total_scanned = 0, scanned, tier;
-	bool exhausted;
+	bool exhausted, tried = false;
 
 retry:
 	tier = get_tier_idx(lruvec, type);
@@ -4891,6 +4891,14 @@ static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		type_fallback_allowed = false;
 		goto retry;
 	}
+	/*
+	 * We are not exhausted, but failed to isolate any folios due to
+	 * races. Give this type one more chance to avoid a larger loop.
+	 */
+	if (!exhausted && !tried) {
+		tried = true;
+		goto retry;
+	}
 
 	return total_scanned;
 }
-- 
2.34.1


