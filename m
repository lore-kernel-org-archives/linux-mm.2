Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2438AC5DF85
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 04:57:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 889146B0098; Thu, 20 Aug 2026 00:57:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EB026B009B; Thu, 20 Aug 2026 00:57:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68C0D6B009D; Thu, 20 Aug 2026 00:57:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3539A6B0098
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 00:57:14 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A2F50A25F7
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 04:57:13 +0000 (UTC)
X-FDA: 85120438746.06.D52F4B6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0CA2640002
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 04:57:11 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AjJX9t8d;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787201832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=leejdAoqEqZUEy4AxrXKtUzDLcGvX9RnYsTPxVQMljU=;
	b=fzcXN8ob0j/m0oivx8hndQcPdH9PMj3Qmdgf9KWrHoRYwNF/MGivsY0y3QqpF9P5GhzGc8
	bBNnjnHk05rBHG4bo3sSvKG/HxGDbhKG838stOPP0G2mPB8sWqmVunP02okqsUQNnFNnAY
	hjpSvQy8z83w25MTVXxvEhemewLseSU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AjJX9t8d;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787201832;
	b=0CWoC6XC4qd/jK3amUOPUJoLcXtLZbIJr7tBCitJZm9i2OpI1WglZEw2uquAWpzEFRRqNj
	m/8MbEeauGMIyVpLs1/0Zou7xWxnSHOhOySsqp2pQEI/+pTE7LXXkp0HZlqur3TowIy9yv
	AdclE18bbJaq0xthH+OZm6rO+MufyGo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9CBAD6189C;
	Thu, 20 Aug 2026 04:57:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3DD81F00A3A;
	Thu, 20 Aug 2026 04:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787201831;
	bh=leejdAoqEqZUEy4AxrXKtUzDLcGvX9RnYsTPxVQMljU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AjJX9t8d1iHhdRU7OOIHyWRfxUYNBT7+IhGAeNv/mDa1oB/ISuwI9IO1gpOW/tnio
	 CyWqy6AAx1CojOSTz0zOrLBZQuLaMFT4Zx4X8WDSeHRV2oEDVBquJnP6zoXoqRk5tM
	 4yBnWVrn9gS4iUXDxccgX7dVxI5PG4xKRgYO2aqHc/qB+fEzTq3qzSiinyGgU6Fndx
	 tD3JUR+C7VkgdPQeNgkWRdtSAI+zOTqujXtJzk5mfifgeKat5dDMZuXI6B3MY/KsJM
	 C+ZOStoNFjopd1olV3zRTrjJYrufhClOETEn2FQ9+5LNn6rDcnHCbM/q2htaeQtJPH
	 /EwJdB3S9Z7Ag==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
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
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [PATCH 3/3] mm/mglru: retry the same type once if isolation fails due to races
Date: Thu, 20 Aug 2026 12:56:03 +0800
Message-Id: <20260820045603.68809-4-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260820045603.68809-1-baohua@kernel.org>
References: <20260820045603.68809-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fo5dij7j57ttztjt7tkbcncfb4r733x1
X-Rspamd-Queue-Id: 0CA2640002
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787201831-783205
X-HE-Meta: U2FsdGVkX19Hbe71x66FOTmHiTqbOwliH5zfG9R5aiJK9O6GyT0r57Y19yFTmdWS9QFgTeIpOQu5OJZfY2+q/u6qRDBj9sWyLmWRD+OuEGjZHJ5hNckEiib4Bru7o3yBx9Gh8ipVh54zIAMioyVY33aizwDsE6ELhksP90Bbtf6pjCCq22zP7gUi45/WyoOOHSg33R5iTN+Q99J4uyxBBtEGdPUaRDJCihf6VE4ZcUzZQ4ohk6Wc5TqHKlWswfYNPrGRwh7LmqBPFcVMuF3Wmzt5yWQWAL4z2XCxGKuOmNaNcKnSlMLyMVQmaU650b0yvhupfFPgBV3rkzD5GUNuYfdZCChAL8SyaD7nP0Z9bpkh8FR4bB4MWqo0uKWGgEf1GyBRjjHSf+o4Plf/85Z7CP/diTGCyUEW+PHuJ0Nv3WOa5mpHvlA+5yUJTmDBVQtgH58xQ2jY+A9XgUmmxokKw7gGlegYZX5+/m0OnnJHrZZtQ8L4aVGaCnxMNGVhxk+xm/ZejJcQPV4DSwExS/EmZ0/eZKgDT6kJouAbYXNlLAxguyO+Uks+Fk2rz2ahsLaQ4BJc0M6BvLrd/kqfsHm3YIzyjU5E05apObJiZKqEXMeE+lX45agLRHTfsyoWQIxvJsgCRMOQ8fXR6kZBK9B7qI4nyvXs8iNA0l2jueoKhwwpKsL8GMuGn5gV7gUpvQleiklXglwnYAH8FMyIfDxSdYdnaqDnlI1UZQWtqFS9smP7Q7p/FkfhVIxBE1jlpI+ZuHRITg8p/pJqUg1ELu78GXfnxXa4iiCOba1oAY9oo2rhk5MKcFsVhKBj0rljr2abaMTVfJ2QBSdHZgIHsWlaqLc2taXPjVi8Vv23loPhT2UNLwf55+Tc6nfq/RJ0v022RtokaklHlzSLOlQtc57XBV48LJoqg6KAYFKlnwCOBaSYs4tY1Hx5+gFWD3Z+uFgtxTpkdY7j+w3RQFTelBE
 hZNngKQ3
 QQ8fZPfPv/RveWGOOWAMBw6obuM0eT7IWLuTmzgplwQbmbUK0ZFEYYZ8FPyVJnWerpcYMEMBhwAsb4cTUTYs3H8NLqjII6ikzeo2c77ymEuHm+62h/ZwoFp4m3mQG7SMp4vXPwAvsbJC9KH5aTqqBIyPsb240twp8+h/xY+MZibrCpV7kqH09VXibdB4VIBklqF1bTgMjswwNfWGb+YgC8M6SgN9JGB+w0Ay6C5b+TSaR19B0CfLqF6K7f/ZbW95Um3AyNdu1AhKo6YhFouNHZ8WkK2LM5J0i0oCTxiawF40UtFf+7uimY5MEYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If we are not exhausted (i.e., there are still folios in the
reclaimable generations) but fail to isolate any folios due to
promotions, protections, or races, retry once more to avoid going
through the outer loop again.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 1f2e574b0061..1f302386d8ab 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4862,7 +4862,7 @@ static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	bool type_fallback_allowed = !is_single_type_reclaim(swappiness);
 	int type = get_type_to_scan(lruvec, swappiness);
 	int total_scanned = 0, scanned, tier;
-	bool exhausted;
+	bool exhausted, tried = false;
 
 retry:
 	tier = get_tier_idx(lruvec, type);
@@ -4885,6 +4885,14 @@ static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		type_fallback_allowed = false;
 		goto retry;
 	}
+	/*
+	 * We are not exhausted, but failed to isolate any folios due to
+	 * promotions, protections, or races. Retry once to avoid a larger loop.
+	 */
+	if (!exhausted && !tried) {
+		tried = true;
+		goto retry;
+	}
 
 	return total_scanned;
 }
-- 
2.34.1


