Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16534CD98E1
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 21:06:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEA496B00C8; Tue, 16 Jun 2026 17:06:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC2EA6B00D3; Tue, 16 Jun 2026 17:06:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E00E26B00D4; Tue, 16 Jun 2026 17:06:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A7F1F6B00C8
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 17:06:05 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8371D1A0178
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 15:09:09 +0000 (UTC)
X-FDA: 84886108818.24.511E938
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id E82BD10000E
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 15:09:07 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F5uc9FL4;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781622547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=24pS8GK4dyL7EYkozGkjXsM9BN2kGeayQ2pQaapNgLs=;
	b=lx2A3h+SjHFMuhxRdGHr3Wf1vEKCmmsR5ZRs8CiaShK+Px0G+Ir//rtRfuKnS2zE8Ssbfm
	DtTLQ3sILcd/hl4oQDY8iWRf+PFhqcMRVCFcUY6g5SjNqI0lOBX65rR//qoTscsWdRrlXn
	54LZc/FrgjsPYOapcrpvB2GPZR1L+2Y=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F5uc9FL4;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781622547;
	b=1xvJM8Vn9YJWOcCNw4/xWt2HomT8GVxR9ml6DEynrdIby6lHwvDQGOH0qVS6hTX4RRwYeO
	pTQctBXxRxSvCxbaq8tiUiUu2pVqkjhCsfqU1SfWK6Zk9jHJXP44WGJabnj7/qr9FUF55/
	ACrWBOCqnPm5kOJSg52X44ZZ/xay0+0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 779F060120;
	Tue, 16 Jun 2026 15:09:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB0571F000E9;
	Tue, 16 Jun 2026 15:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781622547;
	bh=24pS8GK4dyL7EYkozGkjXsM9BN2kGeayQ2pQaapNgLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F5uc9FL4t9jwZcTUjB44eiIrPXrxF7DLlSE37piZc5Xo1Liq5gPgSenhP8dxM+xrM
	 NvS+hGiFKZQME3IaDzU3axI7/SGczvnB3vbEDJfofTIFeIGnxkoJ5fxPkx+aueWKqu
	 eKYimBbSnXBZ3SAM9mRo4q+bYd8FZ4ZBlpXIbjylcR+gqhosnZD8KxDLwCxaatnJtV
	 ASmSbKGRdMl/0qhG/ixO8IRBR8oLr9V6h/Yu5gKwv6K3y7NB5bQwpICvoTDvl5PZnx
	 mm2qz8QwxPI2qFnHmRY00abxeEPDFL/Y2BfHEOO/RoKyJwiQHJe7DP3BJR6AUiccRZ
	 A0lQ/vwloSnCA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 8/9] mm/damon/sysfs: kobject_del() probe filter dirs
Date: Tue, 16 Jun 2026 08:08:42 -0700
Message-ID: <20260616150844.88305-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260616150844.88305-1-sj@kernel.org>
References: <20260616150844.88305-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E82BD10000E
X-Stat-Signature: kfarzamhx1z335ntqow9eepf5nzencgg
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781622547-712214
X-HE-Meta: U2FsdGVkX18I1YkEc6XCURR3lG13sG1W14P7pnL6WUjOsWSpFUDOa9fBIcL75rK3SLX/4+ezg90AQnFFM7/kG7zVV/og12k/TQmwKWMjwo5/as3mLhRcHMzl5CveF/p2iYG0gkl0CyN0kz5gZ5axD5F7opkIQ8INHFiotk7I5GnhTeW66ZqJ1uwuqlO53TBDyhFHeeZ4Yi+Azklc0qFIIYjxzp8GRhmTbwGJ2gnH3qrOLOak3VLPVvB0zSh3pVMf/V05fcSgWC8GdZDirdrRrJHZW8tyWoxZu6SL+fB+fnvR/ZuDfNrqbuwnYYz+4VFTftCBdlZmsZtRv6b6saK0TIQPzY9+GA3jbUBoB+EThDUzUsc+U5wkKGMjQqMURZCKWdvDllOMUxJA8AhEbFbwnukKMEQaGxR+pcpWBe4EvVdc91owua/LhSm3y5A8H1en90hs/v6HSon5dsP56HO6M+By1Lt7UHZHY+NDjnzL/aa5x10gptxXEf2ReefJeiEtKE2w2ShOhqlp4ksrwLo3KaR171mURXedtC0pkdTuQcZry2fzxN/rqE+yKTYD17PzHapcM/QGwyfow2Bhn1akG/QdCQWD6P6HLPkUUwumWwuG5No6lJqCkahgcwIyvX9uC1UWI1cZ08U4twMsiwBCvtVgo5oYNZCtZJcf3BO9Mc7dnPtJRgTpLV+DpIg/oLPBqNWVc7SomdGTp9uwLZ3FKxyQVPcKHnIJBeupW9vN4vzDEP6N4CtciiSLQ1HnIsPxbVBOXTFQjjpK2WjquSqwroTDuV0r+Pvl0CXmfSbedufgDq9ffwWC9WsJxrcTdJS6DdH1ZgQ3TiLsQaUthJA7whySC0+Ibr0n/8f2I9ebLqIqKy6ft46svv1jzlzuTIpmMsVIDHmvY6SGdYrtUHnZlKmnhsGgcPEob4mYyVahU3Y0Z2uxdFU+TOffBxBYyU1nybGH5mGNURqAC4LADCa
 2c9keRLw
 XvHAb9a/NqC+CAm13PpgwUqg4/TwLaWtoaH191SpN84dMyee0AABAjgEVP7DPUm1kpkTxyunPv+0qrMKP9k1jGzhuOH3gIxhEG4SnOsYTvoHKVvXCfCmbR1BeBizhWX6UYevA/gyaBR8sPiX8AmxrZsEGPE3fSdQeNGmVbFH2wdKyL6HqKxdEujr7E3h30EHkZVRqiMYrYV7JeQln3oPKcRgKNHNOniU9M7gXuxgy7JIGl256M8atYhrqtaAokniVwKyO1kBvLO8s8yEt4AemE76PwQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts. Fix
those issues for data attribute probe filter directories by adding
kobject_del() calls.

Fixes: 82e66aef7714 ("mm/damon/sysfs: implement filter dir")
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index f72e1e37df9d8..04725ff3d9f3c 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -960,8 +960,10 @@ static void damon_sysfs_filters_rm_dirs(struct damon_sysfs_filters *filters)
 	struct damon_sysfs_filter **filters_arr = filters->filters_arr;
 	int i;
 
-	for (i = 0; i < filters->nr; i++)
+	for (i = 0; i < filters->nr; i++) {
+		kobject_del(&filters_arr[i]->kobj);
 		kobject_put(&filters_arr[i]->kobj);
+	}
 	filters->nr = 0;
 	kfree(filters_arr);
 	filters->filters_arr = NULL;
-- 
2.47.3

