Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A9F0C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 07:59:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 852806B00A0; Wed,  8 Jul 2026 03:59:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 802C96B00A3; Wed,  8 Jul 2026 03:59:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 718E96B00A5; Wed,  8 Jul 2026 03:59:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 458A66B00A0
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:59:35 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C91EE120688
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:59:34 +0000 (UTC)
X-FDA: 84964859868.24.E48FE9F
Received: from va-1-112.ptr.blmpb.com (va-1-112.ptr.blmpb.com [209.127.230.112])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4A0BCA0005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:59:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="eww7RN/E";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf15.hostedemail.com: domain of wangyijia.yeah@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=wangyijia.yeah@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783497573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YVmVbtBX3HCj9Ijd0ts5x4Wm1TJDsoimgyijvblmLxM=;
	b=OMOEWEO+A+Asb00/FEXlQsPHqxjxcAc0rTV9JigCcBY4czhsUsFwYb+XibXniI5PKCHn4T
	sHIku5UO1hfwEwUQVCMPKwTSKOYbOUFEHh7sairk0LnSZZUIcQ+i7HvEUgctp3aALLr2ta
	3uhrEtjp2UpBTO96rMDTRRQu+8uwYw8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="eww7RN/E";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf15.hostedemail.com: domain of wangyijia.yeah@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=wangyijia.yeah@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783497573;
	b=xMg4Je/WX9a5c/TCLA+vlzL7qg4vT3h71QH2nj2S54hN3FanKgGuEuHwVoMZk9AtoIKUfS
	AHxQdLcd77A354rL3ENRul4TvqrWZvaJGVY2GQJMl7wJeNbTsc2RPlDZ4/CVehkQ4UvHZq
	kXGj3bG3T6z/xVs2N0Vn9U+0uQTiL9c=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1783497566; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=YVmVbtBX3HCj9Ijd0ts5x4Wm1TJDsoimgyijvblmLxM=;
 b=eww7RN/E12R5+K/Y8ZquyTUz+A6c907DGgISd7D/i7o9Tb+Fb3SRji/Z/2G6lw7i2s3Z5q
 7kX4thirQSA9GzuhdB7dTtW0STLFooBXgUOLBFYLBw7WVtWM0K/1dGuWeOR1ogqZ92cbm5
 7hyBMZ3sdZ6uOOUZw8KRw13aoRMw8zsZ6S+PVtl9ro7xxgC/wrVjS7P+I6dTNCwaB+Xv41
 uFTElYEEGBzfbntqHjMctESu8gK1twPGKjgDpZTLnQHbmus8Or9kaOoBDZcaqUtE/SV2ew
 /C8HIp+xNdjRFLSjZX8bUDjo0O/Jn9i8fhjgepHJpfwbQ19O1mN0Tit16CdL2A==
References: <20260707142314.a421d05c05da56260d1bf085@linux-foundation.org>
In-Reply-To: <20260707142314.a421d05c05da56260d1bf085@linux-foundation.org>
Cc: <akpm@linux-foundation.org>, <linux-kselftest@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<muchun.song@linux.dev>, "Yijia Wang" <wangyijia.yeah@bytedance.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0
X-Original-From: wangyijia.yeah@bytedance.com
From: =?utf-8?q?=E7=8E=8B=E7=BF=8A=E5=98=89?= <wangyijia.yeah@bytedance.com>
Date: Wed,  8 Jul 2026 15:59:19 +0800
Message-Id: <20260708075919.3324888-1-wangyijia.yeah@bytedance.com>
Subject: [PATCH v4] selftests: mincore: count file-mmap readahead on both sides
Content-Type: text/plain; charset=UTF-8
To: <shuah@kernel.org>
Content-Transfer-Encoding: 7bit
X-Lms-Return-Path: <lba+26a4e035c+b67edb+kvack.org+wangyijia.yeah@bytedance.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4A0BCA0005
X-Stat-Signature: seojxydtotbqx5us1drk4wx4f7kqieep
X-Rspam-User: 
X-HE-Tag: 1783497572-795012
X-HE-Meta: U2FsdGVkX1+q4VQc6mepyQwu8p1R65fPzxV+F84THd0PFeZwYZMCOj+sR55B64ksvz8GyIoslTogh8UKuBQ5dNlRQYVFROQF/GcMUtsbJ4wzVnyZCV70SN9AUL+VT6ssiDudjkCzovvE09GDBHgtrVh4vc7ryRmqhJ+SAwq0m5mTAC4k5Zama03Z+wf3SxcIac3W8rgR66BcvypoNv1wrw+vIOUGERi1TuYVcklGcvPSjtDNcsCXs/PkerBJt/gSIX3syednDRFJ5O5d+R5tU0qyqLwciCy+Uxek0VngNp4+cpKfOanQYr3AsAMt0LVe1DBlYNVLqy3cPQX+XCqM+xikGxgzTDJcrpvsJWrJP4PUSm+MMOzEIIrfGrGg/3l3kkerCKeAiD/SqyaocN9COXszHn2xjHYbgTLSZ67wowWTnp7sfBUCijspe5z/jAm0Dlzg6muoNQHQ+peO3wvZUjDQi9RfEVynoiuzJ8q3FvSI99G8bwp4SP3NqNm7/4VWaAg6ndh1hs9hOi4vYyCzCbLVK8Y8pdn0MJH2OpL/0uh4biyEiT6FMg/9FhWyFdBt//HIbNCrWrznE/RZ4QZIRQUtU4nMoY9l1lUEq0WpAYWbLaki3qwy7TBPdGtke9b9k+LmvV2Bbq16jrtB2dmSj1GPyHCHbWtpZ72h1OOzFBNwododar4iydf+j6663rxALkmRLj7soz66/ugo4WXYWdmIumwJ2UCtUuIwphQqSNw2PZajTEAaJbuDt/IrGK5m4p1tRHKut5cTAZnU7gHtqpMiMG0hJFcqthE8j8Ghxb0Zl7DVMfUPi/nLj3HDgpO7JZ53uoFlCsIYOyc8sxkwjb8Xip2KH3UrN+5VDCTlM6aLEQHV3vVTNBCOcPdSTic6yWaHJMqeYXXCG88vxCb73S0eJOentrgGHYDCaztCkZbcFZRKyf0lVvro8Vgdjw34BCO2t7o3XSVSk/MV4oB
 zo4KcbiU
 ffvF989iZihAMyKHbu1eLfOpmqKTyCzv5h9xPTfM5h7irbyBQdqrKz5SPpzIkCao9W7nTIpU3hE2ZDxPa5vBcXQ5egVEJXoeLaxYBAnRW3E2SA2tdrtJmY07MhnJmTn46Y5awC+qgBheNxOV4h73tjjItKBNcYfZzldAma0JaZHvunfNKFCuxfs06aIXbfSzec2nGbMQDCSGQW20Hh8Xphq0wCzZvP2CooVitAF0tifZzy/baAs3hn3tnxOqvcgsnZd/BP46IaXVTR7bj6PrqOmjfsA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Yijia Wang <wangyijia.yeah@bytedance.com>

check_file_mmap() faults a page in the middle of a file mapping and
expects the mmap read-around path to make neighbouring pages resident.
The test currently counts only pages after the faulted page.

That misses valid read-around on systems with large base page sizes. On
arm64 with 64K pages and the default 128K readahead setting, the
read-around window is two pages wide and centred on the faulting page.
Faulting page 32 makes pages 31 and 32 resident, so the forward-only
scan from page 33 reports ra_pages == 0 even though a neighbouring page
was brought in.

Keep the existing readahead assertion, but count resident neighbouring
pages on both sides of the faulted page. This fixes the 64K-page false
failure without teaching the selftest to compute the expected readahead
window from sysfs or other implementation details.

Signed-off-by: Yijia Wang <wangyijia.yeah@bytedance.com>
---
Changes in v4:
- Drop the sysfs read_ahead_kb helper and skip logic from v3.
- Keep the existing ra_pages assertion and count resident readahead
  pages on both sides of the faulted page.

 tools/testing/selftests/mincore/mincore_selftest.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mincore/mincore_selftest.c b/tools/testing/selftests/mincore/mincore_selftest.c
index 3182043..ebf2b06 100644
--- a/tools/testing/selftests/mincore/mincore_selftest.c
+++ b/tools/testing/selftests/mincore/mincore_selftest.c
@@ -243,8 +243,10 @@ TEST(check_file_mmap)
 	}
 
 	/*
-	 * Touch a page in the middle of the mapping. We expect the next
-	 * few pages (the readahead window) to be populated too.
+	 * Touch a page in the middle of the mapping. We expect some
+	 * surrounding pages (the readahead window) to be populated too.
+	 * Depending on the page size and readahead setting, the pages may
+	 * land before the faulted page rather than after it.
 	 */
 	addr[FILE_SIZE / 2] = 1;
 	retval = mincore(addr, FILE_SIZE, vec);
@@ -253,6 +255,12 @@ TEST(check_file_mmap)
 		TH_LOG("Page not found in memory after use");
 	}
 
+	i = FILE_SIZE / 2 / page_size - 1;
+	while (i >= 0 && vec[i]) {
+		ra_pages++;
+		i--;
+	}
+
 	i = FILE_SIZE / 2 / page_size + 1;
 	while (i < vec_size && vec[i]) {
 		ra_pages++;
-- 
2.43.0

