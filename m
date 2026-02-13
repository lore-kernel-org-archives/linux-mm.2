Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDD30EDF159
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 12:39:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E46056B0005; Fri, 13 Feb 2026 07:39:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF3B26B0089; Fri, 13 Feb 2026 07:39:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFF686B008A; Fri, 13 Feb 2026 07:39:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BA5C66B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 07:39:12 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1102B590E8
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 12:39:12 +0000 (UTC)
X-FDA: 84439388544.25.331852A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6398CA0007
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 12:39:10 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Iewffj1a;
	spf=pass (imf15.hostedemail.com: domain of arnd@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=arnd@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770986350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ua1EqearKdl+ZkHBh7ebbZBgTKD1RnbA1vPHOk8Ft9Y=;
	b=eoCFEUsItG6/4cyADALzmYkmINizY05Ru2NZeP+WPi0xkdp4vhQwV9LJVNTb0Jm1EAGfk/
	EbHLr70KVo8EdS8kfTCiSke8+hITNwYlDXH54qCKcBnoAaY70rHkRU18G5FlkD2zCiVz4V
	8S5yGpIiA8RJ9789+iuc/vTaz/BT1Sk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770986350; a=rsa-sha256;
	cv=none;
	b=Esw2j+fGD+i3zjqBL8gr/jKjyA1TQ5WLbJV3DnjX3EyhKz4GaZc/p5PExMOhLpBb3/VCP2
	8q6dSMvjSul75zQ1PX2o/7vM1I+fXYzWi1YKR47iJe2VQ8PQAW+1xxOfpibTM85HxVCPT9
	ZOHMJEKbf6EQvLGGECINwNyLaWQsucw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Iewffj1a;
	spf=pass (imf15.hostedemail.com: domain of arnd@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=arnd@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4E320402CF;
	Fri, 13 Feb 2026 12:39:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AB84C116C6;
	Fri, 13 Feb 2026 12:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770986349;
	bh=laNa4BER7QFZASdIZfUnttS00mWIh/fuYeeHXj7xcO8=;
	h=From:To:Cc:Subject:Date:From;
	b=Iewffj1ahTP1mCqpsfnFwRscoWq4f6h5zfMRcqNOVSONn+gTfwlnwGuhiYXlz++qa
	 +DtjTZweVklZpK3ft/cdvh6pakHSzWFkzSgtYuU9Ctw92Sd5l6RGVwIGwPMr3iGnFU
	 Usn+yK9GIY3TanxCi/JhSD0zkWWFgfnJ3TTCvk6PCbBprZbUbU94gwR5J8TrlKUEuk
	 JBTGpe7KTlkXWpqttzm386ehH3l9WeVbAuPmar1cFIo25pKKxax3Ga40BkODaHY5Gf
	 T0afnStlLIbfxsxasvATv1gj+575CtIWCDNS2TtLRBU2JKIaiHjgTQxdyy3iXO9ZOY
	 QCLHQ50IPkNcg==
From: Arnd Bergmann <arnd@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Wei Xu <weixugc@google.com>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Kairui Song <kasong@tencent.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Koichiro Den <koichiro.den@canonical.com>,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	Bertrand Wlodarczyk <bertrand.wlodarczyk@intel.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/vmscan: avoid false-positive -Wuninitialized warning
Date: Fri, 13 Feb 2026 13:38:56 +0100
Message-Id: <20260213123902.3466040-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6398CA0007
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: hgate7wbforebhkbfchgcptpqb5tknw7
X-HE-Tag: 1770986350-925779
X-HE-Meta: U2FsdGVkX1/YpDR1PokCx9jhXLdlSlEn+XHbz53TJUBXac0Ms/0HWNkfAhx+l76gwwSMpAaGgoPX7ZmT+U0HYLvuAIsw7516gIqkyz7Gm6Q72KITzyNqW7h18syCy4SYD7XuyqwGmoosFMnkWhE6Q3ONx6QltBYlYPxHfho83C4YQ7XoLvZ/CoO7AnAf68LgP53lFOMgsMnoN7O+/tPnFjEFyK9q9eNBF+3RADZw6eVXCv1RxtLheBiAe0NsOZJYppUi4r4At5YOQmQ9s5SLLa+7pTQy1j5CBWqaNuSfdjfL4Cxu7a8EjF1yeTGA58BV7uwIHL0rJvaqN3Ajwz1gFIUGuIiwcNeClu2SUgkx44F5aFT4fVVITtRuLmMsl2EhqPIpq5yXhRrSwvIJy2lo0ivlRF5idCBm4nsj29GN26b4P78v9MWTvjq3rk0lur9n/z0OgAu3w0oXS0z0woU2+k/Fxj7roTdm0BwbD7wLfdyxeJXgasCo5/V7TTaQ6WnLESEYDxdhQoQH9asfZlPpFuisijvNUlMZZaz8D85I5yC+/hkXR+ZPC7kLidEAPHXnCw7zDgtBVUDM/ViRyaIA3+7qT5ez8UUv/A7Vn0Kag293cJdvJKysH/MW0yjHNYg9a/q1+fF4nLFMXi0kdM8Vsj1mrV6j8PCNQjKuhFdWBvwNIqgu/Tur5nDdOBhTENp/N9bl0kTr96Fzib/FcXENxHVlOKNVib1TpiBVoEdWCaomm5xjJbKzePgMALzILO3CGsVs3UFXkMph53rXnsfxLAnovROZwlqTSKpCXC/qhIgEN6nGqujL/MHab+IByZoPq5jPOAjy8duD25uWgCt0/4ADZuRto0XN2DQYwnwU12FFHLtCpuO3Ckeh34L6jrWBWcAK7kx1G4ZAcmaId4TsF+cj6IKs6bbWvvuCMuv9bLWoprNOiwYZbRWwH2B5KetKlwe1SRWl31V4TvFRMPu
 8wG9k8Gs
 pp9XPBP31wtE4VyuPrnPAbOj+JwDLKs5bAtP5U+w6aRv3n8gEv6hu5GS9o7hF5Ik6rsIdgW9n7xucEiuG9eZFFHLY9Bvzg8uXOa+Ptc9WkNYW+r9VIQLuuCMn1+E/dWEOO8Bq4e3FHTQNJ8qk9YyecO+50fR+gVlAJ4yREIEzsB9SUYa/N1Yvk1FVPs4jzX1jJuypuEarY6YJp2c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Arnd Bergmann <arnd@arndb.de>

When the -fsanitize=bounds sanitizer is enabled, gcc-16 sometimes runs
into a corner case in the read_ctrl_pos() pos function, where it sees
possible undefined behavior from the 'tier' index overflowing, presumably
in the case that this was called with a negative tier:

In function 'get_tier_idx',
    inlined from 'isolate_folios' at mm/vmscan.c:4671:14:
mm/vmscan.c: In function 'isolate_folios':
mm/vmscan.c:4645:29: error: 'pv.refaulted' is used uninitialized [-Werror=uninitialized]

Part of the problem seems to be that read_ctrl_pos() has unusual calling
conventions since commit 37a260870f2c ("mm/mglru: rework type selection")
where passing MAX_NR_TIERS makes it accumulate all tiers but passing a
smaller positive number makes it read a single tier instead.

Avoid this case by splitting read_ctrl_pos() into two separate helpers
that each only do one of the two cases. This avoids the warning as far
as I can tell, and seems a bit easier to understand to me.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
This is currently the only such warning I get from gcc-16.0.1, and
none from any other version.

I'm not overly happy about having to work around it with a random
code chance, but hopefully the version I ended up with makes
sense regardless.
---
 mm/vmscan.c | 37 +++++++++++++++++++++++++------------
 1 file changed, 25 insertions(+), 12 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index eaf795c1cfb3..602c955d1f30 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3159,20 +3159,15 @@ struct ctrl_pos {
 static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier, int gain,
 			  struct ctrl_pos *pos)
 {
-	int i;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	int hist = lru_hist_from_seq(lrugen->min_seq[type]);
 
 	pos->gain = gain;
-	pos->refaulted = pos->total = 0;
-
-	for (i = tier % MAX_NR_TIERS; i <= min(tier, MAX_NR_TIERS - 1); i++) {
-		pos->refaulted += lrugen->avg_refaulted[type][i] +
-				  atomic_long_read(&lrugen->refaulted[hist][type][i]);
-		pos->total += lrugen->avg_total[type][i] +
-			      lrugen->protected[hist][type][i] +
-			      atomic_long_read(&lrugen->evicted[hist][type][i]);
-	}
+	pos->refaulted = lrugen->avg_refaulted[type][tier] +
+			 atomic_long_read(&lrugen->refaulted[hist][type][tier]);
+	pos->total = lrugen->avg_total[type][tier] +
+		     lrugen->protected[hist][type][tier] +
+		     atomic_long_read(&lrugen->evicted[hist][type][tier]);
 }
 
 static void reset_ctrl_pos(struct lruvec *lruvec, int type, bool carryover)
@@ -4640,6 +4635,24 @@ static int get_tier_idx(struct lruvec *lruvec, int type)
 	return tier - 1;
 }
 
+static void aggregate_ctrl_pos(struct lruvec *lruvec, int type, int gain,
+			       struct ctrl_pos *pos)
+{
+	struct lru_gen_folio *lrugen = &lruvec->lrugen;
+	int hist = lru_hist_from_seq(lrugen->min_seq[type]);
+
+	pos->gain = gain;
+	pos->refaulted = pos->total = 0;
+
+	for (int i = 0; i < MAX_NR_TIERS; i++) {
+		pos->refaulted += lrugen->avg_refaulted[type][i] +
+				  atomic_long_read(&lrugen->refaulted[hist][type][i]);
+		pos->total += lrugen->avg_total[type][i] +
+			      lrugen->protected[hist][type][i] +
+			      atomic_long_read(&lrugen->evicted[hist][type][i]);
+	}
+}
+
 static int get_type_to_scan(struct lruvec *lruvec, int swappiness)
 {
 	struct ctrl_pos sp, pv;
@@ -4653,8 +4666,8 @@ static int get_type_to_scan(struct lruvec *lruvec, int swappiness)
 	 * Compare the sum of all tiers of anon with that of file to determine
 	 * which type to scan.
 	 */
-	read_ctrl_pos(lruvec, LRU_GEN_ANON, MAX_NR_TIERS, swappiness, &sp);
-	read_ctrl_pos(lruvec, LRU_GEN_FILE, MAX_NR_TIERS, MAX_SWAPPINESS - swappiness, &pv);
+	aggregate_ctrl_pos(lruvec, LRU_GEN_ANON, swappiness, &sp);
+	aggregate_ctrl_pos(lruvec, LRU_GEN_FILE, MAX_SWAPPINESS - swappiness, &pv);
 
 	return positive_ctrl_err(&sp, &pv);
 }
-- 
2.39.5


