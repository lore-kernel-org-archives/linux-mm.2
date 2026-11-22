Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6C45606A330
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 12:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=aqpRE3mH
Received: by kanga.kvack.org (Postfix)
	id 07ABC6B05BC; Sun, 22 Nov 2026 07:40:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 004716B05BD; Sun, 22 Nov 2026 07:40:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5C3B6B05BE; Sun, 22 Nov 2026 07:40:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CB7B96B05BC
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 07:40:52 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 399B980678
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:40:52 +0000 (UTC)
X-FDA: 85462714344.19.48C606D
Received: from mta0.migadu.com (out-46.mta0.migadu.com [91.218.175.46])
	by imf31.hostedemail.com (Postfix) with ESMTP id 42DD320005
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:40:50 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aqpRE3mH;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.46 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795351250;
	b=KwkyVS3clfId8JtdLltlJ3aKbsP71tsALOGo3lH7lymdAPS0IfT4oSwSFsOrJUlvqIw0ao
	CbbC1Df1w2SNIDtGAp/wfhIqDmfslzVSacYbT2n6hnTZfKG07nHmdB4S7i4Eb6S8Jnwvkc
	5vD5DtXSbIbwja2pN3NTaaaMxf+NZiY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795351250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DYQ7zJ50rb8VOoPYOra9GdI41CkUpWQlSUYJOOJtLao=;
	b=wDgbkreLWkSfoSNFYzdJ6naThaHVHwGoaXDcaj+nTyKDTsINtVpCCWGcgmoymBbWinwUt8
	qrPHrk0JiyO7mlN8UluzjS59HNWyMMXqRNlvuDYlHctzYA5mxzyXJOFn6ZDprUtTSr68z5
	OGGdE2U7HzMyXZI68TlE12Zg0mZgK+g=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aqpRE3mH;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.46 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=+yAiuIFYVr3+0OQE+cv2N59mSojKiu1LmTrb6IwrG3Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795351247; v=1; x=1795956047;
 b=aqpRE3mHqSKKY4ZWBELRshVORAFti/bxJA98Rk++zoeSNpBngJpQfP0BTF9jmHYH6UU/A0Ee
 35mjsR5IKe5gSno39QR1QQLfjOQB4eJs6JfhH3+n/3TB3LZBTferAwDdVrKUTSGi2b6DXBwcX6i
 yr4z08vZJbkerCIlDs2twfKU=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id f0288d815cd8398c;
	Sun, 22 Nov 2026 12:40:47 +0000
X-Mizu-Trace-ID: f0288d815cd8398c
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	urezki@gmail.com,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	shikemeng@huaweicloud.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	chengming.zhou@linux.dev,
	corbet@lwn.net,
	kunwu.chan@gmail.com,
	klarasmodin@gmail.com,
	linux-kernel@vger.kernel.org,
	baoquan.he@linux.dev,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH v6 08/14] mm, swap: require zswap for xswap devices
Date: Sun, 22 Nov 2026 20:39:12 +0800
Message-ID: <20261122123918.3486916-9-baoquan.he@linux.dev>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261122123918.3486916-1-baoquan.he@linux.dev>
References: <20261122123918.3486916-1-baoquan.he@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 42DD320005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 85j89k6nhr6pjkghqwdyud518wit45e6
X-HE-Tag: 1795351250-843937
X-HE-Meta: U2FsdGVkX1/cZ/FWZOJ955rHQDs/4a/2R0FcQX5+/IIBvDaZC8+VWl+3gNneFbhfYqlQ7FYIRYETI46Hg7qRQJ+p03w60gceMB6dipagoZ0Wo3XX8AarDx1u/V/NzPb1hg1+wzy3CouIvvvGvL90b6dFwXaYsyNlXwruCOTvdKDp/TH3cRgKysmmzzkAvNnifRNfPpiwTm5KB94Cy/9EwSyUF/+mgTVPjrCikrSw14mQmGFCwdV4lJOx+ueL98B/HqLJEMY6ZXghAOsw/CzyBQfoiZb0r/mUYV14QB8fj7yop3Ig9RFhLHU3Xk1oaTvZ0i1CzcF9E3ZLP4vmJJf/mVV3y/+nKloplwb2oECJF/1N0/khBFaTMxbd1QsIvNLonee4Kwn8UFlyn773DJ37LbengBaMh//YaNmg68zstwSwkNQrLOiM5AZ8olxSjKfRokH5L+tYYa+oapThxfcLJurfsnWERnyz24UyYplSbe7emBf4KHqRseRnJDhHtj9gWL7aoSpVXgPsv1VrEw75gh0+En71XpnJoLLunZKpyzKFbXII+q4cSgAzPbc/8kawifdP5QKC9yn40FtAI7LOVaSBPUhSMJWA+DKDrAbMKg01+jb5j17fz9VYtBpNvzUsPIC8ixmTaF2CvfoB9ODsSgx1TSiK1dHbYbX3/k0q39OsjewAoY8AEIqL5CSttNRZPzINL+eIFMlAfJZ0ydLr06Cq5IIHuA5iyLaucEIwqMcH/kHV3tnrOFqOeA/vaSbUEBfgvMU0FcPHlhnAyR1eVJITfActA2ke1QkU/muYMRIP0kJWZLguuuvOFkTSIiXqlh6N9dF2gEffN3300DsfVnIkH/OprRcy5v+Eejsx8KEce1S5ApV/UCAL9q8dqo1zg0Qd0nhKbvor9jQn/27UHGONVmxYrS1ixWY3i3Pnexd1x+0GW4LMrJZW0Bk5+Cg4w43+wFF4uIfivupQgXB
 E5u+bYoL
 2JE0IRdwjIE14WJ/bs72yrWP3Tn4U3BZqlJcwfcFkF2CLWPOTTESWZM6zeOAocjyB88m9Tci/4p6aP3y2Ra2uAaFJGEcC/gLl1eZFEvc52F8U1Brc5Pf+LJX4K3P3IAiUwzNoYi84GBCxS61pu6ZaoTAwLWGUwQh6amA4714G+PvLncJDBQ7mCSWwC8VICEwCojQDJ4Z2DgnJQPyQpOKQ3cu1Ck518fJerzXynklyMC0BCm1OdFG07BkdEBawQ1uEngCbU6gR/nZgZsV/uryL1ylczyhKk6N4IcTA5n00XkH7WlbNiswu+VYWjUQersFSkc3af+VqQ8nxhmSdBwXe8RkbTnozgaiHGrYRs0S8czTY0PeeEYEznffFRRT39taO2Cjem5l2jeRpAo6Ecv07uZvHAebusCzJy/v+uiwexIZjb9mprcaeC8uLZCRWQrtxrlJpCXpjm3C2QhJWio0NKGWp1LwEOgdPT/tjnC9VCREAowDKnvLWtTGqP1BDE2QjV8N1CyblWwnf2olJ11Ec0+AcRa6pC2Aoa544
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Baoquan He <hebaoquan@kylinos.cn>

xswap pages live only in zswap.  Without zswap, swapout cannot
free the page, but still takes a swap entry.  So the device consumes
swap entries without freeing memory.  Fail to create a device when
zswap is unavailable.

Acked-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swapfile.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 1f319e365b68..ba899e349e99 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -4089,6 +4089,10 @@ static int xswap_create(int prio)
 	unsigned int type;
 	int error;
 
+	/* xswap has no backing store, it relies on zswap. */
+	if (!zswap_is_enabled())
+		return -EOPNOTSUPP;
+
 	mutex_lock(&xswap_ctl_lock);
 
 	spin_lock(&swap_lock);
-- 
2.54.0


