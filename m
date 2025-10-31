Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDFA5CCF9EE
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 06:54:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B0EE8E00BA; Fri, 31 Oct 2025 02:54:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 216EF8E00A4; Fri, 31 Oct 2025 02:54:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD2088E00BA; Fri, 31 Oct 2025 02:54:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A6E5B8E00BF
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 02:54:14 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 666341403AF
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 06:54:14 +0000 (UTC)
X-FDA: 84057495228.24.4ADAEF0
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7429B1C0007
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 06:54:12 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf21.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761893653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZZa4zROsfB4xSJtQN8oWlXD5heGe13KaKHVBiSiIgd8=;
	b=bilrpyww8VtnXA1I33ZlqDGwvoguSVypsR9WjRwml9XOI5pirHo8YFNijyJJWRJskEQApP
	qb+Nwz5uzgdbmJBigVU5JqszDaFn2Z8Ttx4dhh5BwO3W1/5fszh76M1lY2G5RIVMNHSWfJ
	Eu/J8SNDpzYF+lEpQSQSsZ6aJzIeavk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761893653; a=rsa-sha256;
	cv=none;
	b=hQKUufssfGR2+Seh0+99Wrg9mpBlroVlU6I+Pvv46g5Bhy9UVp6TiDcod7qVnSH47eM6Ma
	oV+6a2lFv/itsvvN4kuyL80RyH/1wzn8kc4NrrhJbQxEL9oWNKVzsL4Tue7t149QM5e1s3
	Q3qr/ICnpSMutT9sJeQ6u6JbCmFTYQ8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf21.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 31 Oct 2025 15:54:09 +0900
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
	youngjun.park@lge.com
Subject: [PATCH v2 4/5] mm: swap: change swap_alloc_slow() to void
Date: Fri, 31 Oct 2025 15:50:10 +0900
Message-Id: <20251031065011.40863-5-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251031065011.40863-1-youngjun.park@lge.com>
References: <20251031065011.40863-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 7429B1C0007
X-Rspamd-Server: rspam02
X-Stat-Signature: j1n5gxai3pucaia5u7o53n4sout1mp8f
X-HE-Tag: 1761893652-225076
X-HE-Meta: U2FsdGVkX18iFEbTaTtYbThdDPRxlt/5iKVATWNQ0+jpOkugpzIJtfbiF8GZNx6BpbPxUKxTcGzp8j2apQcigKl5GZ5YctVBXRpJh5DUG/Pejn7GWRLSAlY/cK5QNEzzwQEjF7dhGv3bvg8SyDehiSQXEJv5JluQnceMQP5tcDZefPMjXRW5FDN37IoqEjSWy7OK8QPIQ2AD5ikBUCokIJf/nMK1JdGn/YyNvoWoH8FnTaZ9pihiBg0GIOqkzfACV2MuNAb1ozps/lPshgoGXgiNIJCg1h68tdosKGuyZck6rhl2+3J/s7NDwi++i1sE8UvOPfmJCeinHP1qlo2FXa0L61sdkZQGei6kPv1/5UZCUL7vAyEapsldrrG3rM907rp2ZCasjmwW7s1a9R9QSNARf1wjYupIwdPJv0ruENCNVss/mR7KLKR1Wc9Ji/nsG8nr2BcHh553MyLZ6Vq2b9Yhq4XIsmC64D3dAjdcCh68TZVyjakL5VKjPTyJzYsVwKxUMkxoJ6+Ah/NnghKzgcYHK9Go+hxdefE5LzBLr8BexcO8UE69fUcdShWDKfDQKyQJjYcoodJD3nWfQOC7qc+710Sk/YkECaSD7EVTR8aNFCPQVhJJzzDhZJErdn35Qx8poEF6tj7AloAiRnWQB0TWRf9TeQ/7Qw3YcKWi6huE5pCdPO92stx6BOFUN4iTAI57KWlb42SNqqHYKNMv+Nsy4uhgQPaOd1OZAQLNZOfkcuepU/olVsFNa7mCH9A34+0NJvHydqRK0H4d06f299/7yng0yAoj1DTholHXXy6/Oek4hi5Pa6G/itb89pbWCrFBrSPvTtgwYHdjaRu9sMBHEXU75PAwLFkR8tu1Z12B5FZYXIOyeLCeE2aADtpP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

swap_alloc_slow() does not need to return a bool, as all callers
handle allocation results via the entry parameter. Update the
function signature and remove return statements accordingly.

Signed-off-by: Youngjun Park <youngjun.park@lge.com>
Reviewed-by: Kairui Song <kasong@tencent.com>

diff --git a/mm/swapfile.c b/mm/swapfile.c
index b7cde8ef6742..4f8a1843262e 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1339,7 +1339,7 @@ static bool swap_alloc_fast(swp_entry_t *entry,
 }
 
 /* Rotate the device and switch to a new cluster */
-static bool swap_alloc_slow(swp_entry_t *entry,
+static void swap_alloc_slow(swp_entry_t *entry,
 			    int order)
 {
 	unsigned long offset;
@@ -1356,10 +1356,10 @@ static bool swap_alloc_slow(swp_entry_t *entry,
 			put_swap_device(si);
 			if (offset) {
 				*entry = swp_entry(si->type, offset);
-				return true;
+				return;
 			}
 			if (order)
-				return false;
+				return;
 		}
 
 		spin_lock(&swap_avail_lock);
@@ -1378,7 +1378,6 @@ static bool swap_alloc_slow(swp_entry_t *entry,
 			goto start_over;
 	}
 	spin_unlock(&swap_avail_lock);
-	return false;
 }
 
 /*
-- 
2.34.1


