Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61ED4CCF9E3
	for <linux-mm@archiver.kernel.org>; Sun,  2 Nov 2025 08:25:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A382C8E000A; Sun,  2 Nov 2025 03:25:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0F8F8E0002; Sun,  2 Nov 2025 03:25:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94B8E8E000A; Sun,  2 Nov 2025 03:25:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 83F458E0002
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 03:25:08 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EBAFD89245
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 08:25:07 +0000 (UTC)
X-FDA: 84064981854.22.284A609
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf16.hostedemail.com (Postfix) with ESMTP id B331F180006
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 08:25:04 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762071906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=hJtuMsDzBIHrPaSBV79Q1e2jfOmM5xu17eoPkja9aJY=;
	b=jjyZKYR3is3Z9Tp1ij5D+Ia/1uh0kwBAQdi0PD1TAAZmtcra8q5ohT+/vwX0grBvpKinS6
	HZvm6+jJQrWzT+3z+Zf7yWjOUXD/qO+WEQDCJOlDhLwvO0jw+D/acWU0VGvmvXemgqtELr
	K9KPuNCG4dTREqH+UsPqcvGW8p36KF4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762071906; a=rsa-sha256;
	cv=none;
	b=glU5suzoXtGGSW3UenVyOi9JpVLPSF1wYruWwERiP9QbhZ5z8rFc89gfHbvBn+1WWCUtuQ
	6TV1e/wHt+ts2xlsDIhtFJOpxsabw8kWclT7BabV8agNhA+ySWsECz7qW4sCsXHSsytnyv
	BpgHpnOPFXSntoNTO9xSfeoujPG6wBk=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 2 Nov 2025 17:25:01 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Chris Li <chrisl@kernel.org>,
	youngjun.park@lge.com,
	stable@vger.kernel.org
Subject: [PATCH v2 1/1] mm: swap: remove duplicate nr_swap_pages decrement in get_swap_page_of_type()
Date: Sun,  2 Nov 2025 17:24:56 +0900
Message-Id: <20251102082456.79807-1-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B331F180006
X-Rspamd-Server: rspam03
X-Stat-Signature: 83s4a44uwsai1cr4c1krcnp6d7erb9qh
X-HE-Tag: 1762071904-472209
X-HE-Meta: U2FsdGVkX1/P1AbKjcLQ/MRE07/SVY2hMVXVASBpYo8H0l1cC1TpeXvu1hIbyPd75k91olvVwpbpffzldwA7tGext+viBLO2hCR1nbC2uFjKRBNJVC5VBNyzJ3AtY/KVfG4B557vMn5D5C+4AO+B8UH+1qt8t+tAB+AyFfdNsSxbeHUYgqztD86oS0AbbQZ26wEk/vum9uHpdfc6E6mpHkxXkAjpAe5Y6pjJQ1nK7O8JFMI7Da7LabcMbuE5vKSj44l/upLA0MXOF3JD9lIjs+kyP8NW6qLbddkjG+phYdWTbJ80ljmiabV5sAZA6CWlsg5aHR2Ohj6kw67m1+uDd/57WeCo/ZygRXQRB8scrflN4UgeWC7j4TG4wOjCr5tLGI9H9oIWBSnHZYt6thr8sUiAtyh9ULY3hYNLqWjZX1nzyeBSkzQW2t12FMF2U/IAuU/hp43HTamjm/mXOo8ssFLrPhKoyHtYEpnl7bJ0LR1Sy5PqfYs6ZeCAKuRSSGOgVA7Zwqv0jX/rkNCup5RaHoksy8gMEvU7aaL7judzAAl7SFrTIIWosGHSlr8LbYa+KsvFnbmvLHrqahrKuh3gxZ5PQ9g5XNgGw+5P5Lsg5LVTApfx1UKV2nrKAr1aMlTnAh9obV5axkp//h0NziAYDMi9n79rqJuEcUNM1pJoaQSdXgnaIB27eW7NT8Zo0s4B5U6gKAUg3wr/Fzhn581/7Mw3fRVdXVgcNfGW4KqXxRzrSKDYA6Mry2vivyZP3h5uhb5ZlI7AJWTh+ZbzPNmPlJA15wY8iqWheQW/VSNGD17IFqeIk3ktJJvtj0KZXFlVefOI3I+YxqzWZEi/mnuHKBF7wI6q6oCCfv8whlu5gXJcXAeyjLdr6Ouy4rg27A4FsvvxbO2JNZsXJwqBv5V+ugxzgy+z4rN7dousxYDERUxpjpvdFm0XB6i3cYjVV8Ev2TT8RSNSK+qUUtuIBPb
 yUMtT2Ls
 NpO4q89jMJpiDCOkoDL43Js36GWXceVYD/Xo7xE4pvOPIGt3VQvBejmLvR3KCJfXqicBV8wFgpqS03LFwiYlcY3GRtM78wIjPCN4c9pMmeUt8Ms3Rupl8ZP/5SVT7y5IH4GnlqECF45/G7AjGZdpGlkkwzC6ItzxEBRrxLVjYXjsUus5r3oFpuzoSmTmJQfboNH7a517GV/wHmtlLnF1Fw9HSAUIA2gkB28rj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After commit 4f78252da887, nr_swap_pages is decremented in
swap_range_alloc(). Since cluster_alloc_swap_entry() calls
swap_range_alloc() internally, the decrement in get_swap_page_of_type()
causes double-decrementing.

Remove the duplicate decrement.

Fixes: 4f78252da887 ("mm: swap: move nr_swap_pages counter decrement from folio_alloc_swap() to swap_range_alloc()")
Cc: stable@vger.kernel.org # v6.17-rc1
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
Acked-by: Chris Li <chrisl@kernel.org>
Reviewed-by: Barry Song <baohua@kernel.org>
---
v1 -> v2:
 - Collect Acked-by from Chris - thank you!
 - Collect Reviewed-by from Barry - thank you!
 - Link to v1: https://lore.kernel.org/linux-mm/20251101134158.69908-1-youngjun.park@lge.com/

 mm/swapfile.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 543f303f101d..66a502cd747b 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2020,10 +2020,8 @@ swp_entry_t get_swap_page_of_type(int type)
 			local_lock(&percpu_swap_cluster.lock);
 			offset = cluster_alloc_swap_entry(si, 0, 1);
 			local_unlock(&percpu_swap_cluster.lock);
-			if (offset) {
+			if (offset)
 				entry = swp_entry(si->type, offset);
-				atomic_long_dec(&nr_swap_pages);
-			}
 		}
 		put_swap_device(si);
 	}
-- 
2.34.1


