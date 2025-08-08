Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E876DC87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 09:28:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C1B26B008C; Fri,  8 Aug 2025 05:28:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89A006B0093; Fri,  8 Aug 2025 05:28:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D6FE6B0095; Fri,  8 Aug 2025 05:28:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6DBF16B008C
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 05:28:05 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0EF6B5FB66
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 09:28:05 +0000 (UTC)
X-FDA: 83753063730.03.4F491A8
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8C4F5140004
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 09:28:02 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=KVCdxGB5;
	spf=pass (imf26.hostedemail.com: domain of fffsqian@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=fffsqian@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754645283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=hg/dNySbwBik4yOGXZxNDXDhAmqw7dDjJ6pVF0ShhBY=;
	b=gxtB5CkOh2+wjbFDN91jPgpPPN7XZX6QfJgwIyMabkwTRlBnSVhdcwkhRlCf98kb7qx5zS
	Hgl4dvxnnMpNFbBFSZBjjQtS8+HOK8DpU4qNlglUCHD1ckVZz2VhU4cSG2sNsRRgy0pKbT
	Xvud3TSGhVTiMGkrMGhIT0j629DkERI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=KVCdxGB5;
	spf=pass (imf26.hostedemail.com: domain of fffsqian@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=fffsqian@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754645283; a=rsa-sha256;
	cv=none;
	b=zkrAhdTKDpGTW/OjQ1/aQ8Paz2dxIVNGUk364bdu5o2Lid1beJ/+ftlPPoQUMaS9iOl3L8
	e44kbQLdC2uk3Nm6sM+ebufiMvPDQt7rJJID/+lzFH9sRZaKuT4FE4OO6+Wqv/8Kns9Fxa
	oTaWhMF2lxDVs9tzq8Z8oR9aGw3ogII=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version:
	Content-Type; bh=hg/dNySbwBik4yOGXZxNDXDhAmqw7dDjJ6pVF0ShhBY=;
	b=KVCdxGB5VV9GpPQ2Cbv/DJ4IyeE1SYj3iZ8rgB5+GD36WZ2FkHGX+lf+7W/TdR
	ohrA+WdbQChSHji0f3qWpM0otKZBUu2m/tdk9Dotoh2fjGQCRIdVholK3Vhfts0W
	fOb+QgSQFaAG5NcZ0UOLQihNnDuVzyY9KHjmXJO2Pgxzo=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wDX0473wpVorWBMAA--.9256S2;
	Fri, 08 Aug 2025 17:27:19 +0800 (CST)
From: Qingshuang Fu <fffsqian@163.com>
To: akpm@linux-foundation.org,
	hannes@cmpxchg.org
Cc: david@redhat.com,
	mhocko@kernel.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	lorenzo.stoakes@oracle.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qingshuang Fu <fuqingshuang@kylinos.cn>
Subject: [PATCH] Fix the data type inconsistency issue of min (tier, MAX_CR_TIERS-1) in read_ctrl_pos
Date: Fri,  8 Aug 2025 17:27:17 +0800
Message-Id: <20250808092717.191444-1-fffsqian@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDX0473wpVorWBMAA--.9256S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7uw4rtw43KFWfAr43CFW3Jrb_yoW8Gry3pa
	93G3yqk39xtwn7Gw1qqr4xAw1xWw1vkFW7JrW2qr10ka43GFykta15Krn8t3yjyFWxX3W3
	Za4IkFW3K3WDAaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jU6pPUUUUU=
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: 5iii21xldqqiywtou0bp/xtbBDhqjymiVwnUSpgAAsD
X-Stat-Signature: xau5aj4xatebjzypnduxf55rfgr1fcgb
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8C4F5140004
X-Rspam-User: 
X-HE-Tag: 1754645282-703420
X-HE-Meta: U2FsdGVkX188MFVmm/hMHCf2HUuqfCe8/t32IP0Bc+rwe2plcLwbMMIwbx7DTuGK0sbcUueLR4Q64qQsGS8ZacqTatbtpC7sDlyUnDR9PSCW9k+A4Spin63unBJ65RrgnNylbJFK946m2yCBuzsaun9+49OhOQ6jhMQ/UvySpsg8f1t1d94GtxLoRYq1LnLFdoIpNDN1LqjSk3H8hnOOQToiET7NDxdp9Ljr0ezTcwD3DWtaJOMTff2efLsBb2M/DGePpfqhrDybRWBne54UUh2KZ7wbyEw2qK0NLrSHeJ08XeoaA6l73AIwhpNlJLXhzPKjH3qVZ2CmVLHSNKfyyUViTuSPuW4elOso/3rw9hcqGGxZESOGOyLm4eJsbWcTmk7C9xBdpFyo8AcRHe/459HjxBDCtZkRWTHq317MHHbZl6b+UKYIf7RPwROyPeHuvlFsJMKfa5okJNOC+cjJvUctKXEKR6GM2yi6vnzmHmfPn4/u08okiXcNgmEKiq2TR/7MEw9AvjaFEIF6oQvM/Pb2boO6D3yLgE6maGnPgmiyzY5P6oSA2ZkORv3qT/ZtweSxuYlBox2B6c4RRj58+JMLVnFDlhQGuZCYJCybP2rsyi6NDDxPK4HHAriXo6YzfShxAtnidBOuOAE3FraC8voGYVMkqsWqF1/CQJgvdAnl5//Z7aVlvabd+Ih4ly7OzcrD99UaGQ6NUsQKE5AYDVXyRosqnXo70mAZbMRr95g9FUYbUJ8eQYtxSbjECuC8/J05wQHp90s0461Dq6maktTBrmK/+4GBUVJS+6ZyfLFe9Y7GEEzS0KOp0pomWq+hhaHG15kiExqG9OdDCLxrkRGcK6H8ehecgge7n+nag0Pkz6YqmP13CDQnkumvFsxpUrPtFMZrPw2U8QMsgucnC4RCeseJdqO72t1AZL2yapEiJWJCHuBxtj6mLRdrR1hZ4evf0Od/WapUK/lYI0H
 ryVStkIB
 lQ8Fx89sbxcFDWqK0VMD0LPVqXHm6MQLNIqrZHgl0dxwTN5tha/se+NE0vXICTMAXKn7WznlFimyjZ/mwm/KWyFGOdZsaLd5UyoE4SBoslfQXLuF2Iz0DUmkoHgRU/4D7mqIw81CLQC3CbvY9ZBiECTkw78GIWLb1aTdJcNwM3A2I8XxCujL2LCZTcxhQGoxP35775NYg49bdeIA6Aqcwim60121/M+S8wB6hwn3g0t5PwusXGR8QBd0Qv6eOcaArwM431+kTOH3UYnka3JV94Uew5CcfpG+mchydscbChSgSKOGn+0A7B8sQJLyJS2ZuTCWvDXVHV9a7mDAWawho7K8h+H3BxQVoPltdw6J3mng4XBdukuNXpNoX4aQf7QsE2UzS3mSlCcpN6hHx0YsEqdBKag1iWBORIwAeYkCX5uJ3w3OrPdla3LrCTSRYO19J8BPVAh72rzSha4dfMyBV1isfnVFkThNffGfpFMTmJbDih01VQqHsrmMDMPQ7K0i4zVFN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qingshuang Fu <fuqingshuang@kylinos.cn>

Due to the fact that the tier data type in min (tier, MAX_CR_TIERS -1)
is int,but MAX_CR_TIERS is an unsigned type, directly using
the min function for comparison will result in an error:

from mm/vmscan.c:15:
mm/vmscan.c: In function ‘read_ctrl_pos’:
./include/linux/build_bug.h:78:41: error: static assertion failed:
"min(tier, 4U - 1) signedness error, fix types or
consider umin() before min_t()"

Fixes: 37a260870f2c ("mm/mglru: rework type selection")
Signed-off-by: Qingshuang Fu <fuqingshuang@kylinos.cn>
Suggested-by: David Hildenbrand <david@redhat.com>

---
v1 -> v2:
Modified patch descriptio
---
 mm/vmscan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 7de11524a936..f991196fd8e5 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3194,7 +3194,7 @@ static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier, int gain,
 	pos->gain = gain;
 	pos->refaulted = pos->total = 0;
 
-	for (i = tier % MAX_NR_TIERS; i <= min(tier, MAX_NR_TIERS - 1); i++) {
+	for (i = tier % MAX_NR_TIERS; i <= min_t(int, tier, MAX_NR_TIERS - 1); i++) {
 		pos->refaulted += lrugen->avg_refaulted[type][i] +
 				  atomic_long_read(&lrugen->refaulted[hist][type][i]);
 		pos->total += lrugen->avg_total[type][i] +
-- 
2.25.1


