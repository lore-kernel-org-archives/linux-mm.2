Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA2D2C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 17:27:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D07FA6B0119; Mon, 13 Jul 2026 13:26:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB8056B00EC; Mon, 13 Jul 2026 13:26:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A47616B00EC; Mon, 13 Jul 2026 13:26:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 484CD6B00EC
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:26:58 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C800DA0017
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:26:57 +0000 (UTC)
X-FDA: 84984433674.13.18B8978
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id C6E80C0003
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:26:55 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kakovTCw;
	spf=pass (imf28.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783963615;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Pmb0MRfmtUjcfkwLnNuu/McNLE6dPMaagkQ+xW7jJU=;
	b=bcdulpB80Mo+DHlFPWrU9QqIhJAWmM81TESyDbMLs0NQr6wKZTs0JAA8MPQEqOaB9/V7Qx
	bshUk8VNM4jF5gcsM8ZmzEwVPAg/LpZMTF48NedOFmtZxAT/2UExhBzwpegie5pVIC5tx3
	RChNOZtMwZB9Gfhy/fN/iHJ2p6hOPk0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kakovTCw;
	spf=pass (imf28.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783963615;
	b=QdKCkAMCgHX3CPatLV6O2hHuBn6AABL1+Io+PDCjS1Z1k+haGTu+N0eYlUCKVlnWSygQH6
	hKOHxFg7ClORpFTF0QdWcspYmpTTjvn6SYcNV0Xti7FPYMWvCcOSyPD+Lhm3BUFAmSBzdt
	Z4sxXeUiyv/4tBv0K7ACb6ZS85FQn74=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EF1C9414EE;
	Mon, 13 Jul 2026 17:26:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C563DC2BCF7;
	Mon, 13 Jul 2026 17:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1783963614;
	bh=B4zCWGJ9+aLc/O6vq6PcXzy8sOSwPeK/kwVGyL76lCs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=kakovTCwIWNPxgoAGw5/gERoibOiZW5BPtUcYKiCPaouisMVusIeSc2T3/IGjsqG/
	 GkeAX7KyS2Ble8Qfrz86ms6HF/N6q0hzerZIieCViv4LnaldtEuXxGY/PNGGVa0Nrd
	 AHe97alC0dE29efvOBm6fOR4Czgu6BmEBsEsl6JAJicQOE5WWOmwlH3oU0A37EGNOR
	 z1/tFf4IYLijHlTCEGcCZ4be1G797l8DynI+RZI4rTme0qPPeB/js677jgytnRhPyh
	 GsPVkLkK2HN+Qyxe4QyMApYp2CbzcrTp1gP/Dr/08sExvG0MTc6DhKWkuEFiR9k3DY
	 T9SdBUqRzjbEQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A530AC44509;
	Mon, 13 Jul 2026 17:26:54 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 14 Jul 2026 01:25:40 +0800
Subject: [PATCH RFC 02/13] mm/swap: slightly cleanup the code for
 hibernation error handling
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260714-swap-pcp-priq-v1-2-de9b164ed419@tencent.com>
References: <20260714-swap-pcp-priq-v1-0-de9b164ed419@tencent.com>
In-Reply-To: <20260714-swap-pcp-priq-v1-0-de9b164ed419@tencent.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
 Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
 Youngjun Park <youngjun.park@lge.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783963612; l=2506;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=MoWWPNOWkGVpdbQrV1EThfD/0KHjuJm/eolt7XVFWQk=;
 b=MQ54BpDpDAfKb1RowmKnHfEt3Y6KtS8Jx/Yq7lkNkJOU5oneODQ0VBeWa7pVznUJtE6mEvHxR
 w4Z8sd6jzKuBSQXl9v7gxd4u93v77a38GAmvggh4/D08rxbMsllzVgp
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: 3c4him8gmfuep5tfcp5maf19se9ghgw7
X-Rspamd-Queue-Id: C6E80C0003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783963615-250517
X-HE-Meta: U2FsdGVkX1+4kGipPYqIIS1EJaKk0SZARY8g8vF7ZIFyQaGGrqkBFzS/fzjwJRegtWgqz/FBRpjKv0K3Tijzxum7z3zrDHCm6o+3u3shMsPXVh+KSOMq20L9e8eFD5SEdKMVIEAi4SaUdBUg4Xwz55R0rSaG9hiEgFiQcjFB0J9yr+YvFxZSbzUBnXXiMDg8uy1vX+h9whivWq+sJmoXhyX5/phvpFmIYc72TUsnQVh7Zo7vtT6HumoqzihnMzyMTGgnmXQtMrpsW1ncbZ2CW+9HMd+J1PmwCAJo+pn/JE482zjj+hJ+tTPCjc/wZaqU3Z+QSMiYW8ewQJea1Qghgu0zNp6QCNw4CVIjnhAnea5SMtYEmEA8Kh6DHWqqnXjOFgw68FtAqQZCwTVqtIInbSJoG3H9z9xSBGf8jzhyrvv1Pq+EEsvWdrVXMZJrxInnRqa3dWITgV1j1NpeA9vnhu/DVIcwPGi6J2m56THOf8k/keBQjsa6uLdjggW03TkFyrKPd5GDJkFgTpq9NwaPYH7vv/qKf3iRgrMyw+sZu26fcXn7dTQQEOHpCP/edgnyp5KXKOCk/EhtcKP5rNe4seYJ7Fvl/wx41JcMfRBDPV3Zo90Tx31HEmtxVu6nTwAA1HRY+pZLCYcYg6lOXZ4+GBmJCE1hjjcLvpcVtbUvdast18LdiN2FSY3BMHCawPQ6H8Twcn6pEdfmA1M09f2XoRqwSsHLRBMJHBnewOdFpJeZHl/dAhCHaHXLC6CwcySDd3egEiJrwVyvrwj6crg9hec9HHPe41vnmo02s0/sdKO6f8zftd5zyIznfr1SyXItabt6cD9ObWjxL7k8LJ3Dy8BJIvR3+Vq6Wyk1l6uQtKU9Po4J/0jrwVfWVkzaCes6UlHw57kNnHrEdH6kDvYudUaani2sHU9py9m5HiGeEg+aSytC13jTBDBzECVmBzrakFytlUugW5Bk8I9Rsyx
 V7mKFVWC
 C3f/t2oqzjTmsF0JPepX233NBw8ho6f5vtYvFTJywvBFhhgY24AqRREzxPDJZzOa2934XvwxgzBSyPnfPYKWJVPO/LlvshDQ1OJ0VNFFdkb/FXiXQkgwxvVlhYKwYOvCs8nclZJQUikwV0bFjFXwXab007RXaqDnuRqvoRMdmfPrau8fImCw1IXRSGR++9EFlrrU0mortxbElgiqsyK2EibjLyf7Xp8mmfbjeYLBmYwf58UnidKqgkWpRTeKchTT4A78m7Sgi+WNS/Mz8hZIVcEhDyNqUWx/IoD2Xc2ctowkLIWUAwRra6bdRAZQsszpuSVubguPfI8Xyu0rO6COOdawzTlPqDkMTOfsPGP4bYwKTboxRqn2stctp6+z8xZ9CvMgVRHRs4dYgAaV/L48RiIu4dVbAq2pYr6fAUO72PekLvUV/9kn9FS10YsGBm3aXIbOfGj6VntRqPww=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Restructure the error paths in pin_hibernation_swap_type() using a
goto out pattern to avoid repeated spin_unlock() calls and simplify
the return flow.  Also simplify unpin_hibernation_swap_type() by
making the si NULL check inline, and clean up find_first_swap() to
avoid an early return inside the loop.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 39 +++++++++++++++++----------------------
 1 file changed, 17 insertions(+), 22 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 27b4d11125d6..30ee75bdec40 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2247,21 +2247,18 @@ static int __find_hibernation_swap_type(dev_t device, sector_t offset)
  */
 int pin_hibernation_swap_type(dev_t device, sector_t offset)
 {
-	int type;
+	int ret;
 	struct swap_info_struct *si;
 
 	spin_lock(&swap_lock);
+	ret = __find_hibernation_swap_type(device, offset);
+	if (ret < 0)
+		goto out;
 
-	type = __find_hibernation_swap_type(device, offset);
-	if (type < 0) {
-		spin_unlock(&swap_lock);
-		return type;
-	}
-
-	si = swap_type_to_info(type);
+	si = swap_type_to_info(ret);
 	if (WARN_ON_ONCE(!si)) {
-		spin_unlock(&swap_lock);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto out;
 	}
 
 	/*
@@ -2270,14 +2267,15 @@ int pin_hibernation_swap_type(dev_t device, sector_t offset)
 	 * the same session.
 	 */
 	if (WARN_ON_ONCE(si->flags & SWP_HIBERNATION)) {
-		spin_unlock(&swap_lock);
-		return -EBUSY;
+		ret = -EBUSY;
+		goto out;
 	}
 
 	si->flags |= SWP_HIBERNATION;
 
+out:
 	spin_unlock(&swap_lock);
-	return type;
+	return ret;
 }
 
 /**
@@ -2296,11 +2294,8 @@ void unpin_hibernation_swap_type(int type)
 
 	spin_lock(&swap_lock);
 	si = swap_type_to_info(type);
-	if (!si) {
-		spin_unlock(&swap_lock);
-		return;
-	}
-	si->flags &= ~SWP_HIBERNATION;
+	if (si)
+		si->flags &= ~SWP_HIBERNATION;
 	spin_unlock(&swap_lock);
 }
 
@@ -2335,7 +2330,7 @@ int find_hibernation_swap_type(dev_t device, sector_t offset)
 
 int find_first_swap(dev_t *device)
 {
-	int type;
+	int type, ret = -ENODEV;
 
 	spin_lock(&swap_lock);
 	for (type = 0; type < nr_swapfiles; type++) {
@@ -2344,11 +2339,11 @@ int find_first_swap(dev_t *device)
 		if (!(sis->flags & SWP_WRITEOK))
 			continue;
 		*device = sis->bdev->bd_dev;
-		spin_unlock(&swap_lock);
-		return type;
+		ret = type;
+		break;
 	}
 	spin_unlock(&swap_lock);
-	return -ENODEV;
+	return ret;
 }
 
 /*

-- 
2.55.0



