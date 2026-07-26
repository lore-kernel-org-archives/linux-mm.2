Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3B5CC53200
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 12:21:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADCE66B008A; Sun, 26 Jul 2026 08:21:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8E606B008C; Sun, 26 Jul 2026 08:21:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CAB76B0093; Sun, 26 Jul 2026 08:21:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 701A86B008A
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 08:21:41 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 01C93A153A
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 12:21:40 +0000 (UTC)
X-FDA: 85030838802.11.34CD7E7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6ABC2160004
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 12:21:39 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GCI0st6V;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785068499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1mYLU4EaS4pxcWMxyoTDGyKkMMBMmDPXY4s8sW+uOWY=;
	b=A4tR1BSU3XSai2TKGExRkCUuUhFKNqFJLSHBzFMuFp9eWTgS7YkGCQyqA1LzvjT2wkM9RW
	AtSgXFiSGAJbtFgrMGEPDLGI0Q1LzC/orDkkU0YfG1uW8TEocMp+jqFuywgbinkK1W6kv/
	yzHgW9L7DxGf+CKWmZH1oM21Cp/Fr+c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785068499;
	b=TY37j6Hl9miPXuUHMMxmcYixSM81oE3JJqp1BjUVOWDPOEZl3VluGcodTyo0zxOcd3OujQ
	TJSQhIW1Dq50laH/eRLkWpwed0OcKX7cxkTazT0z3gbtAhOIqs+AVwgfBDCpwC8Oc+6TD2
	jqlxGBbaixUubrpE7X8WoBKAbIEepl8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GCI0st6V;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 35EEA42434;
	Sun, 26 Jul 2026 12:21:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F40C1F000E9;
	Sun, 26 Jul 2026 12:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785068498;
	bh=1mYLU4EaS4pxcWMxyoTDGyKkMMBMmDPXY4s8sW+uOWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GCI0st6VMA/PxindSKsTK1fa1HHQNEAhoyMrtjOqHGkV9D8odwoBhfgBsDMnKebTB
	 tzVpHm9cirAefSwjZyxDmzrR/qR74a3sPe/4VI5g1tV5cnthy4Fy0SWSyqJY19MfX6
	 Bs7uVR5Qpbo+dxZNu/yMUTt4S0Y/1Rj8s3Wz0Y8XswwW4YUU0gyyrPap8yj+/RJ+Nk
	 JTtX7bS0IYLII51VS/I8uEK3s6Cs8PUpj4kq8wUljO5VL8WSXEdWW4HNzbrqPtMlSi
	 11/GexWl2bplD19vFtxcYfbgcYG0L1SsKAlenfpCawcurtS4IJokDMkU3z19yD3Ewg
	 SpMQ9lG1hDcUw==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: hannes@cmpxchg.org,
	david@kernel.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	ljs@kernel.org,
	kasong@tencent.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	linux-kernel@vger.kernel.org,
	lyugaofei@xiaomi.com,
	stevensd@chromium.org,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [RFC PATCH v2 2/5] mm: mglru: only fall back when reclaim is running at high priority
Date: Sun, 26 Jul 2026 20:21:20 +0800
Message-Id: <20260726122123.7614-3-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260726122123.7614-1-baohua@kernel.org>
References: <20260726122123.7614-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6ABC2160004
X-Stat-Signature: 14x9skin5pohm6c513af4ueq56ujh7kx
X-HE-Tag: 1785068499-571559
X-HE-Meta: U2FsdGVkX1/UX9TsjhPayfwKdEbqRgFQImIF4bBjNuHeuUloGHdfeNf4FGJhEBFWxgEtR4LkBf4cDBV1384dB08WPYEaD9UU6fqsfFZxcxN0eoL4YZTDgYmsq4nMkN2+AhLnCzf8bog2Ic/BEBafb9MbBAqDr7B1ChqhU+8JllaYMCW2Y2PV0dDI9eVP8ljLcBYCrEYGoh5Ihhpj5X7c55ig4X2I63gHDPFhJNaW/fX1EkgxePR4f2FVHoVq6NyGygv1ZmfoSoakXiLgwNj25fcdzd0EvafxL2fY1Jm2CDykOcFc9APKItb1/jBpEIwDSuCXb5aqJOFCTI2ZE3d0hmu0XOek3xRh6DfEG7X/iUcwwkn5Vpp2QAnyGK0PdO8gos3Sw2X7T0T6o7QixF0Oz79AzBKxM74cJeD1GDa4BJblthEIGOWLTCfG7tN59LtULkBwIMzTfL4+ZdjJUcMgdah8LaX2L/PqTpp/DapP5T++qEz+jCkyUTbnanmk6GcMfDPBo+rwVNua/F0U9HrUtYXSw7KFKfpECd0YA9fDikXeF04p1ScGdLtw5dckyFYe4sOFdgA3twdqzhY9tQWGfJIM3vdADwO1A0Dv++5VsWDnzb9krvSvpFRnLrj0ZD5NqMK85vbHlb3GWcEOFw8J2Y38OvaPO7laXQO/4qfY1/qI7Rqk7xdbJLNW7E7w2hEM4PNXC9Yg6C+bW4yyKt0FzZw3GRAmVsS8m7T/epTFM8uaROTWDVwkPZkmXKwIF893OUTAcGNsfW9GRi/1YIa7mKSfMXNkev+7VBp41bAQJX67h1d2MytnGt4/TwYC/Qi10lJAl/2b37HfTOWx8OhtuL4xuJ/5Wq4tmtCKoGc6Iy2HIpNn0f2DKXFB4t4LnRPcqVBWvtf7q08/KeUUEHKQig2dh7HDLgzlxNRxQQKHoiplFBtHHFlgE/3d0JBs0kOA1KOddqJUQGHpTs2eUqJ
 65gt7HkT
 kSJdRY1rDF1nxq9Ci4SNaWSxtEbF2fwzsBwC755cMJiZHQM9vwymYVGqiR0zuwrC1x+dJqzwIhUdxubh0NIvOQ0ktZCRzT1FiLpglJ1Sl2VH05Wwi2THJZc9+WBlEWgAm7hDPkmwIBNtb6Dt3wmyoPKpbXhk1OlM2yA45t0UGKarR9ao8bVW0CFrHFN2gsbQqXkRwH7qJEanNrFSTu4w5wUclELBufFfnC/KcahdSadu/lG8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Respect the type selected by positive_ctrl_err(), where swappiness
controls the relative weights of SP and PV. Falling back too readily
undermines that bias. Only fall back after making a sufficient effort
to reclaim from the preferred type.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index babbce4bbfe8..4a387cc4145a 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4857,10 +4857,14 @@ static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		 * type is still reclaimable; otherwise, it would have
 		 * already run out of reclaimable generations. Falling
 		 * back too readily can disrupt the positive_ctrl_err()
-		 * bias.
+		 * bias. Also, only fall back when reclaim is running at
+		 * a high priority.
 		 */
-		if (scanned < nr_to_scan && *isolated < MIN_LRU_BATCH)
+		if (scanned < nr_to_scan && *isolated < MIN_LRU_BATCH) {
+			if (sc->priority > 2)
+				break;
 			type = !type;
+		}
 	}
 
 	return total_scanned;
-- 
2.39.3 (Apple Git-146)


