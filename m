Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A85EAC5B574
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 07:35:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B30816B0095; Tue, 11 Aug 2026 03:35:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0DB76B0096; Tue, 11 Aug 2026 03:35:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A45B16B0098; Tue, 11 Aug 2026 03:35:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 864916B0095
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 03:35:20 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0E29EA239A
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 07:35:20 +0000 (UTC)
X-FDA: 85088178000.02.2128C98
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf17.hostedemail.com (Postfix) with ESMTP id B78E940011
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 07:35:16 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=2UUf9vWl;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf17.hostedemail.com: domain of mawupeng1@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=mawupeng1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786433718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jB71I2AGRR0M8wrb6cuRs3B6zPtQUdkI29IkLfGLMtQ=;
	b=7bpt+4PaO1+PC35uzJhmHlWwb/mE1Jiv/6lQNNfzu0OpZCC1+Nw+NCnUW6YzKU0vHc/Bb+
	2ut45xDCFgiS2toQ6T2tk/YgpteKnCslE9a/i3jXdKtGdlmlA6b7hWzPI9XnLOPn7XV8mW
	f2lgGdflQlSn2LRnN9ZcQP/YpXT+3gA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=2UUf9vWl;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf17.hostedemail.com: domain of mawupeng1@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=mawupeng1@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786433718;
	b=jzh2mVADzlyU5S+A7FNmHLNQ74zctOV0MjnTG3nSv8D9/iopOkqGXt2WcJtqRwDL6LFIBg
	DIii39vEu5LNVRgGSCHXuYgR/VXXGfz+dPAjGDlquTXsxw81RWEHY3BjNhbREE/LtXy8ws
	49wN6SiPOp1jL6Ro7/lbstjCDGG7orw=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=jB71I2AGRR0M8wrb6cuRs3B6zPtQUdkI29IkLfGLMtQ=;
	b=2UUf9vWl/bGoUNYEPPy5nqC04Pecukd3EkqryHKIAYE0xdKtUK+WobrG2rw67pxGai1XKY1Av
	F41Ajz1o0gHwcU4mqdIyaaubIvMMEewE4MeJTHR2Y2HXA2URfNptBIhCmATRiW0XPzmgWdUxCx8
	u6dlEMSRA2xb7s51XOiN8qY=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4hK36C4H4kz1K96b;
	Tue, 11 Aug 2026 15:24:35 +0800 (CST)
Received: from kwepemj100016.china.huawei.com (unknown [7.202.194.10])
	by mail.maildlp.com (Postfix) with ESMTPS id F1808402AB;
	Tue, 11 Aug 2026 15:35:11 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemj100016.china.huawei.com
 (7.202.194.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 11 Aug
 2026 15:35:11 +0800
From: Wupeng Ma <mawupeng1@huawei.com>
To: <akpm@linux-foundation.org>, <liuye@kylinos.cn>, <hannes@cmpxchg.org>,
	<mhocko@kernel.org>, <david@kernel.org>, <ljs@kernel.org>,
	<hughd@google.com>, <mgorman@techsingularity.net>,
	<yang@os.amperecomputing.com>
CC: <zhangqiuhao@huawei.com>, <wangkefeng.wang@huawei.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Wupeng Ma
	<mawupeng1@huawei.com>
Subject: [PATCH 2/2] mm: vmscan: stop scanning ineligible folios after max_nr_skipped
Date: Tue, 11 Aug 2026 15:08:49 +0800
Message-ID: <20260811070849.1332165-3-mawupeng1@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260811070849.1332165-1-mawupeng1@huawei.com>
References: <20260811070849.1332165-1-mawupeng1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemj100016.china.huawei.com (7.202.194.10)
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B78E940011
X-Stat-Signature: 1pn1xiykcgexge86o9xzmjtrwheghp6h
X-Rspam-User: 
X-HE-Tag: 1786433716-664776
X-HE-Meta: U2FsdGVkX1+jUD1S+V551/KMi36CiXOGxZMDFxfaAf7gfvSV5xRvzmEi2a8L2Dw4gpGnhO+eoBaxILGAdEu1j5QNUQ76aSmjjXcIoxSf65QkDTHAvKD8OIFqUfyAcTIG1Mwq8Ez12QDMRjPNlyAngYlqLz3vvlDLKd5QcR+GgvJ33XXNoqLVqfvCX9fh1Z2bGz4qMBT9ux2fnhnzybAgJC9uFGXUX/WDD+Sqqqy1kfu/g6T1cYbqvtVIVJyGUx+DVxTmr0IwKxFNQhuwZA9e0X1h0A1zhJw4bfhQhHuZxjuPCVhPKItDkUsYfO/atW2p+7iDz4z3mkzZnabJtqLVnHfHgCLcoQPISc0Adws2Lv0416HfXsVBqStfYWeOVS68yRgVe+Sy8pF7GFyISgxgDj//04BEHfWIifEZqpuUqGYZ/N4oLK0qaNvq4+rzXUloA4sx8lIfeDtig9t6e5FRGmciS1bm2znZj0tcsgLCS5luALKX9P33FM4sSduiWzA7sW90/IsupDqlzAVYOyJkSGPGb9/1sWq3sN4OBeVEKdRhvLEoklA91rn7bn/8jTFSEDluHalvzgQ8dyQpTNWJoWVGk4wbG+5+OrTXKPO7Jp2hTloAZISTcE252Z3uW0Yu6Cq73Ld0JiFfSSU8lQF1VkFBLVPbptknXjkH/ABTDCglw/JG1heMBeNysje2iJBouxxldg+pcia3pO9wnz42sm6agx3woXikc7MIaram4kbU3lV97GFdljp02XCFrRPjh6PphpwtMBVjGjyNPzkkgjlUpVEo+d2Xr9/Dg0ATpAMvwpcvoNKdGd99E+wtekPAJRz7PDaqUpu1YbSUT6G0umhhhbiBHDKXOkfavxAV5vI9PcTTI+oAFDXBYnnjhZfK2jTnqZjYBesEC8PfmydYtSR9GQ/IdqtpAkXMPw2jeohWoyZtMGKHavftPm8ch7UbNOphYohxtVNfLEv335l
 KDrTSOgC
 Ob9LL8TOCtdf4mefnoJCszrzG+Z66xskpjI1B9BzaPWC1lm3EA8Y1UtDHiwPZC3nUugQEym+XVCWWDo8pjkQnQVGQuhNUHRxQVQ2vrQKYuHhl/ffG1gR4QIiA7wV7rfXmNq4WqgWKUtBwoDMO9wP/bkiH/wK/mvJmeO29bAkfyhIdAWww/Wi+24Xwl93yitFg61y37/15ZC8V+UGS3LGY/YNuuO/jvrUFFWX0W9SoTktk8D6cI5QGQm/yg6EOzliOSfSkzC3h36qTEyDITqOZQRgDL775LIkIMqGWPfjp9gAU2keZoF2x0CJThWYqQpONL4jOVkW9kbfi5BwNAMXyZ+vCVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When reclaiming for a lower zone, isolate_lru_folios() accounts folios
from higher zones as skipped and, once max_nr_skipped hits
SWAP_CLUSTER_MAX_SKIPPED, force-isolates the remaining ineligible folios
to keep the loop from spinning on the skipped ones.  Those folios are
reclaimed even though they can never satisfy the current allocation, so
nr_reclaimed is inflated into a false progress that keeps resetting
no_progress_loops in should_reclaim_retry() and delays the OOM.

Stop scanning once max_nr_skipped is reached instead of force-isolating
the ineligible folios.  The skipped folios are already accounted in
total_scan, so shrink_lruvec() can charge the overshoot against its scan
budget (see the previous commit) and will not rescan them.

Fixes: 1c7b17cf0594 ("mm/vmscan: fix hard LOCKUP in function isolate_lru_folios")
Signed-off-by: Wupeng Ma <mawupeng1@huawei.com>
---
 mm/vmscan.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 147e74f9732d5..ac3237a58cb29 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1704,12 +1704,20 @@ static unsigned long isolate_lru_folios(unsigned long nr_to_scan,
 		nr_pages = folio_nr_pages(folio);
 		total_scan += nr_pages;
 
-		/* Using max_nr_skipped to prevent hard LOCKUP*/
-		if (max_nr_skipped < SWAP_CLUSTER_MAX_SKIPPED &&
-		    (folio_zonenum(folio) > sc->reclaim_idx)) {
+		/*
+		 * Using max_nr_skipped to prevent hard LOCKUP.
+		 * Once the cap is hit, stop rather than force-isolating:
+		 * reclaiming ineligible folios only inflates nr_reclaimed
+		 * into a false progress.
+		 */
+		if (folio_zonenum(folio) > sc->reclaim_idx) {
 			nr_skipped[folio_zonenum(folio)] += nr_pages;
-			move_to = &folios_skipped;
 			max_nr_skipped++;
+			if (max_nr_skipped >= SWAP_CLUSTER_MAX_SKIPPED) {
+				list_move(&folio->lru, &folios_skipped);
+				break;
+			}
+			move_to = &folios_skipped;
 			goto move;
 		}
 
-- 
2.43.0


