Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3676CCD3427
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 01:54:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 327C56B00BF; Thu,  7 May 2026 21:54:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D5856B00C5; Thu,  7 May 2026 21:54:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19CBA6B00C9; Thu,  7 May 2026 21:54:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0209A6B00C1
	for <linux-mm@kvack.org>; Thu,  7 May 2026 21:54:27 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 681B41A068B
	for <linux-mm@kvack.org>; Fri,  8 May 2026 01:54:27 +0000 (UTC)
X-FDA: 84742582974.30.5DE26BC
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf21.hostedemail.com (Postfix) with ESMTP id 95C8E1C000B
	for <linux-mm@kvack.org>; Fri,  8 May 2026 01:54:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gB5wWFR8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778205266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=nseJDaSxTNqf6W2FqkALGVnCq/m8td61Q2PPLEqM7Zc=;
	b=mrA1yU3hymRic8SR9FhDE7dyMpW3OgdgC6QVIi1nktkBDAEJVddPbVb+SYgN3maLMlrMvG
	pOYg7HYeC+I/tn4youo4nEatetJ2H3hlsDEcZlN6DJW9K4SVaNYTfkCabfBj01Fxkw6K8D
	xxo/BsLCbfvW1CO0iP8IOiL4oQy6+L8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778205266; a=rsa-sha256;
	cv=none;
	b=UmB5hfSPrYtlS/3Qgkqv5BtscAEkSz5Ssy9sZ2yPom3ezZ8gWgfMOc6BG48FlAx6jPJ3Wk
	rIgNKokcxf3bA4CvmBDDIy5CBan2SF3JpBJtUJNXwjiZ2yxR/kd9gDM0DgtcblB47fQeyH
	0YdOQTdkaouJMxSfhn6vOEMKAEs3xOM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gB5wWFR8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778205262;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=nseJDaSxTNqf6W2FqkALGVnCq/m8td61Q2PPLEqM7Zc=;
	b=gB5wWFR8d2fS6CPEk685eZA7JwGi9erehPEoqkVzp0el5erKaewWqfl6AD8KiWU9D8HS//
	pukirYz/z+LC5LSbu6Ep31VUgJUuhISwzvJa5QpVySDArvRBeN9E9c7J0Ddgl5bj/kn0uB
	XuvRSPHbWISeDrHw4Xsmv1wjCeMyZmA=
From: Hao Ge <hao.ge@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Hao Ge <hao.ge@linux.dev>
Subject: [PATCH] mm/balloon: expose per-node balloon pages in node meminfo
Date: Fri,  8 May 2026 09:53:16 +0800
Message-Id: <20260508015316.25722-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 95C8E1C000B
X-Stat-Signature: kedm8gi7ci1r1a543kxty7aq4goppxr8
X-Rspam-User: 
X-HE-Tag: 1778205265-796989
X-HE-Meta: U2FsdGVkX1+d/n6kTNQQHUHdOm8ZjEhROUMsT5a22EIF5K1hhbv3ZIwgavxN5IS/mUiYfxya9k3l12qMDpkh7bpsqvkI2ILrWjtRzBI2dS64YzvbguA7zxFH+/N9iC8fyNy5jvDi7DZXJaUT9aGNfKNiBKTeLGDjf140NB1h7RoR1fE98Ze3o7rFqCAtk+8e4FsprSAaUuG1gTMQHqC2Oh2ogw+N8yVnOuZokLzQSLD8P01anZki0Uqzd4itor2F75rzYIyv+wr5Ql/vEmO91/PGmtTSO4wurFiS847B+J0kMv6w3nVZKrr10pbhKT9CJQggj+R4+MuL+qbSRRoVQ2/gvzhQ0ZU1Wnhb/SOTzaJkkqySlkz1i1N7/dfv3WjkEBGTzicYtS5INde+YV7ArX7o9xHNmJf8d0lVsJikrqeWIzUbTdAiopbg7dA0qbe5ISPPBYjUPJZ005kSv7itVhmIODqgvKs+xYnUS9kpBfAYGsrsSG2wS3xI9+HXaIGWoNIESTt03CD5SvXCbIqay70TY0B9zZwPAN/hOTJ5vSO6EFO0mUSpmktHXIAa9dQiV7m5CECWR2fXIUwSwWmKqWxRqwVhK7CqjRAWmna7Rla+HRKQJiMMLWk9Fllds39H/iiHfsIPPl4GigL2LJ61Vva/4mYT9RRWr8ZUV+UscIB20wZBUdSEBm6s/rQ6q48dVPm5AEwS5toxv9zg5+HhcuEsGCdQ4/fOTIRknvmttne8qAi83YezhkVt2fuFqVIp+2oeJyjl4DWX4ha7DLKo2ZFfsS63x6b7X9FxUSNE9cPSs1JliYn1R6qsfXsfwE/GOSuz4bFtJxFF4MQRGSKL4LtCEUHa+z70y0DsgBIsvzpV0P/FQRFl0xplZtMrrxmJExG4U8X7jf8gL5Sny95WgNfzZEDX4jej3ZPor/zeHKVRfV9kfQGHWgN93rAPxtHk1fdm/TWUbit+M/e7DA9
 mGQdhTOY
 OD916fV/nQkLdRVfr5XJirhOdlnPHTqN3fRlHQve71xtEoj5ecPhk0ZxPOwC66rmhiZYOOBw5HS/6mutcCtLiWA+9pN8qC6+lXorzyNOSxlvENbWQSnlsOjGAHP2b1o97e0BrCP0shgsvczIudMboeIqtmN91+ZzBc4PnxzrtAoQOXvS+TM4sp6pwxAhb9zDi7S6N
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 835de37603ef ("meminfo: add a per node counter for balloon
drivers") added NR_BALLOON_PAGES and exposed it in /proc/meminfo.
However, the per-node view at /sys/devices/system/node/nodeX/meminfo
was not updated, even though the counter is already tracked per-node.

Add it to node_read_meminfo() so users can see balloon usage per
NUMA node without having to parse the raw vmstat file.

Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 drivers/base/node.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index d7647d077b66..53f4e51d6d82 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -513,6 +513,7 @@ static ssize_t node_read_meminfo(struct device *dev,
 			     "Node %d Slab:           %8lu kB\n"
 			     "Node %d SReclaimable:   %8lu kB\n"
 			     "Node %d SUnreclaim:     %8lu kB\n"
+			     "Node %d Balloon:        %8lu kB\n"
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 			     "Node %d AnonHugePages:  %8lu kB\n"
 			     "Node %d ShmemHugePages: %8lu kB\n"
@@ -543,7 +544,8 @@ static ssize_t node_read_meminfo(struct device *dev,
 				    node_page_state(pgdat, NR_KERNEL_MISC_RECLAIMABLE)),
 			     nid, K(sreclaimable + sunreclaimable),
 			     nid, K(sreclaimable),
-			     nid, K(sunreclaimable)
+			     nid, K(sunreclaimable),
+			     nid, K(node_page_state(pgdat, NR_BALLOON_PAGES))
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 			     ,
 			     nid, K(node_page_state(pgdat, NR_ANON_THPS)),
-- 
2.25.1


