Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36C58C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 03:17:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C17A46B00B7; Mon, 14 Sep 2026 23:17:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC5A96B00B8; Mon, 14 Sep 2026 23:17:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A691D6B00BA; Mon, 14 Sep 2026 23:17:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7D92A6B00B7
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 23:17:10 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E2842120306
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:17:09 +0000 (UTC)
X-FDA: 85214535378.17.3B3C5AC
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5D1CE40004
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:17:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789442228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q++yFCihLm5ha86x0IQ2fkklxsXHHKKwYzsfR1YJIDg=;
	b=UZLNXzAutbb7z9/glf6iixm544pk5bzvv61kcg+pFrkLuzhl09tX+ezenRz9pPpw8uuHFY
	/8FXQ3SkHVwpxR0tHjeEIlxvM2oh6R4FVzetvUFQgT8m1cPEPz5cCGqlRAv4H9JH6WBnKe
	/IRfQSSB7s8Rbn+8LVcXomjB79At6Fw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789442228;
	b=JKHh4Rp820T5nee6OW4yS5QRj3/I3FSLWSlwJMEiTs1KemO7GtSEX33SoK1AISYRSiKh0a
	FsSqOS+rh8kADsP1C5x1d8zXVN/NbFnDXNlrZu1cao8p2pPXTciTwcLLELJWdIDtLfX6iE
	g+qo/cyRVqXlbsCVKpoUcRmPzYI6K0c=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 15 Sep 2026 12:17:04 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	Len Brown <lenb@kernel.org>,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	her0gyugyu@gmail.com,
	youngjun.park@lge.com,
	taejoon.song@lge.com
Subject: [RFC PATCH 02/10] mm, swap: skip swap devices without a block device in hibernation lookups
Date: Tue, 15 Sep 2026 12:16:50 +0900
Message-Id: <20260915031658.1505680-3-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260915031658.1505680-1-youngjun.park@lge.com>
References: <20260915031658.1505680-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: diw76i6y39kc9egwamoeopdziaejaind
X-Rspamd-Queue-Id: 5D1CE40004
X-HE-Tag: 1789442226-386452
X-HE-Meta: U2FsdGVkX1/1Tdx6V0dXGhvyUEYZISk2M1mzGyIh9azfmUOa8NdZULmrVlcjGk7GNjkfSJK/EwaZWnaShHjP+0PnXrl7eAAEMNiv/QiqEJPCIhKWgcQbUR1KKhF/SHhiRja5CSoNfom2yGi9/blwwQJQa4mjIFb9LFVEfcIu6r0ZXB44uLV60HTwpI72PphRANoxLQ1D4KCjh6aWgPwwlAH8mte+3aO+EyvEhDgMQDGSf6XmtijN/5i/WmFI27WJ0w8/JQFtpRdRItq0QrPD3YkuDVRtHa/napZEoSwAbKTg7cAdyuHuADDy17KHykXrnpn9FXvGSWbNzPo/ZTaPFaG2CA0D5M5uwGLBHCJbJQGXTm1TdoyEMA25NwuV0BiQWTFlK02wF8Nl/BK2ktqStSYFphRsQNO7r3uGdaCyp6gRxsSpLUaL8hvR4t4fxG5u328VjCqijbzh1VnbCL+foOzHBGxXTeLlFqIeLsuTpXIxTPHdEsZQ9DaWEY0fM2LYtgSJDls0IRXrVuMXPyZMnCWw8zBEx6q0DbRMK8HkS0WNGzLUcW3trzGA7vtj8Rl7YANM7dY/cDNnirJr5gY5f5WBvdQw3m/6hCQzCFXBgbQgwos1UCJuhY9qYBk3NB1sFDlyLMUso/aZuo+z8FJMTiE+YhnvJX5nvsU46q6F5LU2Xm4yttfVL1Sl1k9AVklCQM6DpN75KJk5GmxKuPe56tGFjB+NM+vX5NsOZHx5TxNWigKlJP1uhaycnsElLwq89Q0WADpNdILi6FcxnkJ13hyl0tLcn4IbnFbvg/gOec/0W50SfqGZyeQ7gwo1njOzxM5CMhL0LJugG/CmZDvyja7iMDgt4+OvVYWFGIoicr92oQ3YCSQJsGmB8lKjTKpqx3bFyUNMDh9PIUYWMR6h0olTsZ2IZfMDHzvDyytdmUvJ/cLGojLIH6s7S0nOlkxfg/6f7kty+vJWmwNq/Xb
 O093U5SY
 DdMRPDjm69+qufHN7mYKH3rp47faYvpEVVK4ShOxdT+ky2GY3k3Or0PbUkXyLP210uLnSclIRDmhhWDudhW+xVCCBTMRIb2uA34IBmMV9nvoHK1m9sGdTk+2RojX10L203fp91Nm4aSSDgXnndNH0bhqAIDcmkcZEsoj9kquViRZDGy40qLXNH/EHThsTb0AV7xdsphQaWyHUWU3Wh9oetSPmpJezuhDd8irc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A swapfile on NFS or SMB3 has no block device, so claim_swapfile()
leaves si->bdev NULL.  __find_hibernation_swap_type() and
find_first_swap() dereference it without checking.

Hibernation cannot use such a device anyway.  Skip it.

Fixes: 21bd900572f3 ("mm: split swap_type_of")
Assisted-by: Claude:claude-fable-5
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 mm/swapfile.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 592ca26a5c0b..655f2647472c 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2238,7 +2238,7 @@ static int __find_hibernation_swap_type(dev_t device, sector_t offset)
 	for (type = 0; type < nr_swapfiles; type++) {
 		struct swap_info_struct *sis = swap_info[type];
 
-		if (!(sis->flags & SWP_WRITEOK))
+		if (!(sis->flags & SWP_WRITEOK) || !sis->bdev)
 			continue;
 
 		if (device == sis->bdev->bd_dev) {
@@ -2425,7 +2425,7 @@ int find_first_swap(dev_t *device)
 	for (type = 0; type < nr_swapfiles; type++) {
 		struct swap_info_struct *sis = swap_info[type];
 
-		if (!(sis->flags & SWP_WRITEOK))
+		if (!(sis->flags & SWP_WRITEOK) || !sis->bdev)
 			continue;
 		*device = sis->bdev->bd_dev;
 		spin_unlock(&swap_lock);
-- 
2.48.1


