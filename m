Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6665C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 23:47:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12DC86B009F; Thu, 27 Aug 2026 19:47:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DECC6B00A0; Thu, 27 Aug 2026 19:47:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0ED46B00A1; Thu, 27 Aug 2026 19:47:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C80346B009F
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 19:47:30 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2F43180214
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:47:30 +0000 (UTC)
X-FDA: 85148688660.24.185A224
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 94A4F100002
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:47:28 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XhR8wbY7;
	spf=pass (imf14.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787874448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XpoXXZeU8kWFe5s2ICH1kueGMPGyd+PONtE3ej8VrGI=;
	b=eQx/3R+/AENVgr7Z4wPjdNj9Dwx2Z0C7MGP75ltT4F+4J8PGEbYwYTDX6reIxIcZp3EeTc
	3RYzBlKd5SXufXOgFKABExvr2T1CzdV9muB4YRuIK4Kd4QMLFoigbRZriTrN6DMYaNzK32
	yhEyopinZuKZGt43O8+pMieAGd7fywc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787874448;
	b=gd22mWqiwN9LN0PJrj7lcj2taZIU9TZ3IqKpFX+lpgQtferlEb+ToQs7v20intE+jMFsRk
	q5mohxpsY6FH7kx9HxA4wcGU+V/MkZLFW8559pNYsVpP9N2jmdvHbE+MA74J57h68B1uUS
	WSonyW1EIwUjrtkN9MAZ0u1OPanpmJg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XhR8wbY7;
	spf=pass (imf14.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 40BCB60202;
	Thu, 27 Aug 2026 23:47:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E7ED1F000E9;
	Thu, 27 Aug 2026 23:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787874448;
	bh=XpoXXZeU8kWFe5s2ICH1kueGMPGyd+PONtE3ej8VrGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XhR8wbY755E4SSkqcE9MoEeN68jEYcQaM1A4b08q+UG4rIUxm2uAv78LbMZvoh5d+
	 g6gehELG5vSwKTnG3B5FcTDJIUvvrx1QIMwyfn5Fj4EIbmoSFehR1i0enLupWQPP/n
	 qKsntasHkCzEdm6QEYabfxmLMIEFDkavBd1LMsseR8AA9Cfoh+/mNJf+ljS2s71GFT
	 84kmA6eZXYM2jYuSgOgeIFPSMnCvGM9XFK2ifqLhr7LC7Bryn8yZ0Fgtk2ROpUJt2q
	 1+sjhqBDeCGIJ3BBxOy/CeZ9CJo49A+dEPKpafC9wKqCAisBjBXuw+ie/Z5ZpEQo7a
	 Wvp1+J8J+xLnA==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	lianux.mm@gmail.com
Cc: axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	chenridong@xiaomi.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
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
	"Barry Song (Xiaomi)" <baohua@kernel.org>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [PATCH v2 4/7] mm/mglru: exclude folios promoted by aging from protected in inc_min_seq()
Date: Fri, 28 Aug 2026 07:47:01 +0800
Message-Id: <20260827234704.63163-5-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260827234704.63163-1-baohua@kernel.org>
References: <20260827234704.63163-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 94A4F100002
X-Stat-Signature: wpqxziy3xmx9dunghq7j73ei7inu7rdo
X-HE-Tag: 1787874448-484621
X-HE-Meta: U2FsdGVkX1/EFWPNx3Yt+9bnry63vud+uTTggYMteJR3Rh4oumHwyzqi2h09HE39UYWrEON7sXTv7mTACTL4BWyy+kGgTBq62yOPCj899qcI1l/CLCIQeiMTJvJv/DQ0eWh6AsL6psrkBsflN02uskWR1NFZCL73xrR2mcY9hdGol/ukdk0MNfIryRJYS8/FVHMvJ1qJiYIv+612TcuJZdalqNGqig8HpaHKuCLFYRy7/bCaudPMeRrHhWTf2INBX/XWquEqulTATOyeW4HZ4KaG7LEpdhM1+B4NbcY+4SeK9RyUxXqNKpGbZj75Upa+fDdKST6JStTpD2d9K8vbpMLdK/yBb6/GaMsLJAQg/bK1dkAjffYHdHCq6gYqQHfEKU3t+dSIYGmgdnCTCXtGFGclb7Ig1VvuPkLfbuLhU19bi2tf4X/SSmm+GVACBFEElnB6y8JFyUq2Ts4P0wKzvjX6KbiK3WhRxnF1i+QLIDhpEGVqm+BB8MRx+cYAtVc7Ns71Md14h1i2UhKqpXcDamZJpa12JIB6WAmcM0G7H6+piDrBQfZ7MedmMC0Uh2Loscq+fGEdHjRSAofxcOBdchJiWhHb0ROkvVz9H/2kBptBe21QBL4OySIRDcEyYOYtT9xi/u2+OozU/sHdAIxgn+aP6jifDqfqNgLW4GvE2Md5+Z28ynBxT4VMqNaqO/dudfAInL7Y6SKGdIza+Wi/MCUSnPRL3tlirnVLA4v5HPnjs7Xe4gAoYEjtvGm/64BJP8s3wrHwFRGbBNbhw4uAzZbx/F5wdVCyBtnet9S0FprRJayNb5urB9+tN9d9ZUWPT06KcTNQxk+Z3dcCOfr8KhmI4KEk/AewwZO58Z+zKYFD2vZmI5PIGOwZ0qWb0+DhIxwg7BGL0b6N0nbG0x7Qdz4e9Nm4SzFMUhKmcdY9ETN/lydjhXpWFaWl6BSpWk2d7e3MXzVImH19Rzz596H
 tUe2hbxi
 6bvBwmjyFxrSMNKmj+CFlriAW1rGQNhACNx05J/tNKz8vQLAFQM6htZf+2kxDITD8002nq+UuJObC3YTM/nvIyw1oFdMjHloQMLJxmXBE2c9RsZWMuxR7pmSC8vwQarpmmxiXJlCDVlRH1w6quhup235QX6hx250SILNI4RmqorUNv/fwuuCgqUJ4PN5TJ6Q32Mbnw0clyUEu9QVutOkyqaGhpJ64fPSf+vfNJy+l4bv0B0Z8IXRDe+hAg9kAknd6yuyA5mRiYsDqAats920BRnwyFIns01nLWQpK+b31y7wdRsyvQK8MtKDXgAStxq5sUTP2QYQTJ/hzutJW2poEgnkqpRo3/KdO7UBt0JF1xxGeW2HvxmNnVgTzciwFhhKywHB3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some folios may have been promoted during aging, so don't count them
as protected, similar to sort_folio().

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 mm/vmscan.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index b10d1703d907..2b33d3f44682 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3952,17 +3952,17 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 			if (gen_increased) {
 				delta += nr_pages;
 				list_move_tail(&folio->lru, &lrugen->folios[new_gen][type][zone]);
+
+				/* don't count the workingset being lazily promoted */
+				if (refs + workingset != BIT(LRU_REFS_WIDTH) + 1) {
+					int tier = lru_tier_from_refs(refs, workingset);
+
+					WRITE_ONCE(lrugen->protected[hist][type][tier],
+						   lrugen->protected[hist][type][tier] + nr_pages);
+				}
 			} else {
 				list_move(&folio->lru, &lrugen->folios[new_gen][type][zone]);
 			}
-			/* don't count the workingset being lazily promoted */
-			if (refs + workingset != BIT(LRU_REFS_WIDTH) + 1) {
-				int tier = lru_tier_from_refs(refs, workingset);
-
-				WRITE_ONCE(lrugen->protected[hist][type][tier],
-					   lrugen->protected[hist][type][tier] + nr_pages);
-			}
-
 			if (!--remaining)
 				break;
 		}
-- 
2.34.1


