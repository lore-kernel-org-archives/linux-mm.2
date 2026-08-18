Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DE5EC5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 13:02:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 467B26B07D7; Tue, 18 Aug 2026 09:02:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43FBB6B07DA; Tue, 18 Aug 2026 09:02:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37BC36B07DC; Tue, 18 Aug 2026 09:02:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 185136B07D7
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:02:29 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A8030160112
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:02:28 +0000 (UTC)
X-FDA: 85114403976.19.69FB993
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4D7C5180011
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:02:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	spf=pass (imf16.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787058146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=Ct/TH+xkZ7hqwIrnX3enDOECDcpAv+tKrYiLpUl55Kw=;
	b=3DPRLTGzynm5vQAcn5tp6onTbEjOs0dtDioO5h1QKvwcB0JKuVSli6R2WuwcP8EVN1TxH3
	zMEyzpIziX/YMaC43GSZJ30uFri1CkuSjTZORT8lPovC+1g0ga4+/88BRRzS02uy8nKjCr
	ui1OTC0Yh7PkHK0y6PbvcdDlY/9e5I0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787058146;
	b=B8FS5ntoEl+WUzk7bIKpzpxmwp+hziFRswl3Jbq6VZQqsdIh8DoVO0YdlGMxN6njgeolUd
	JEdLECVQZ5Pqim/sX/UlcBqe+RDRV4BtUUbUlSRHc8B1oojnVklzaRj5iQOrnwKdQJoXSW
	CluvgkS29vxxRqSUND/3ImzwQ2Ya7WI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn;
	dmarc=none
X-UUID: 067491609b0511f19a56ed5b684f684d-20260818
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_T1, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:5b11598d-57da-4644-8347-efbc18028d8d,IP:10,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:35
X-CID-INFO: VERSION:1.3.19,REQID:5b11598d-57da-4644-8347-efbc18028d8d,IP:10,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:35
X-CID-META: VersionHash:7db8b62,CLOUDID:9cdabe40f9b50419632787e2e413e574,BulkI
	D:260818210214G3XWLUVL,BulkQuantity:0,SF:17|19|38|66|78|102|127|865|898,TC
	:nil,Content:0|15|50,EDM:5,IP:-2,URL:99|1,File:nil,RT:nil,Bulk:nil,QS:nil,
	BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_ULS,TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 067491609b0511f19a56ed5b684f684d-20260818
X-User: husong@kylinos.cn
Received: from ctao-book.. [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1956968772; Tue, 18 Aug 2026 21:02:11 +0800
From: Song Hu <husong@kylinos.cn>
To: akpm@linux-foundation.org,
	mhocko@suse.com,
	mhocko@kernel.org,
	joshua.hahnjy@gmail.com,
	willy@infradead.org,
	shakeel.butt@linux.dev
Cc: linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	hannes@cmpxchg.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	zhuhui@kylinos.cn,
	audra@redhat.com,
	bingfangguo@tencent.com,
	Song Hu <husong@kylinos.cn>
Subject: [PATCH v2] mm: memcg: release the css reference when a stock slot empties
Date: Tue, 18 Aug 2026 21:01:35 +0800
Message-ID: <20260818130135.154315-1-husong@kylinos.cn>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: cdd4yax889ygek9nr7gxafu8spnid6tr
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4D7C5180011
X-HE-Tag: 1787058144-261402
X-HE-Meta: U2FsdGVkX181IaUCqpjuJbLtsYX8yF6vgxvc7hrFdtylJ6GdcZV3rADwjp/AHDyGBqVGMB2wTjBSeo+K7oT97g9d9Zd+ofMUlEhQeZaBgBwFN0hVA3umUlrPxJzuOFUkJaAxtcr148JxZcMO52levQd3PUCNWjwTUyWC44ld6aZolL0EpA5kSJwqDRmkDY2QlRuI8oWAJnBcLCN8NUroC1stRyVfc3BVN86EWYWOmDFIU5axfdB2C3VRp7Iu0TphR3WKAxHJDGyEqZoL74KcfqlMyrfNWztDA9/wNaTcTBcuPqVe4//1SjIECXa3mmpQOMMpeUJoobmVeVLcabRfp9m/F67baIy+j85YtGmxNtrTAgDG1fzSHwYCzVM3x2PFhbExpF1t8WTVW/iaWY3JTgdUSFgM1tZR8GEs38Z7CPAq7jLVw3avfCEwnTgKJh7XWzrkiL6FfCSRbEmW46D0ZpaLEbN/pSxFSi19HzHH+rOa8jxcZ8WXc++bdH17uwJkCxKYGnrjXO1OD/JGVTp0QE5Z4VG6CodeJ1Aa2PaRIdsM1rmsA6zuo/9Wet1+wBAMBIlAUVns+N0NH/DzXOoI46k0OvfvDkGBJpr9zNXY4ZLvaIxuNeuVryLfQQVP+cvLg9/s+YTP/bwlMYUOwUL2L+nuydsdxQ/PJmDhII1vtR+tLT+deTvgG2eHV7YnVGFkqvFtkaJLgZ5rxf9d+AAlJCiaUa9mC0qjF4bAa9YCFCB7roRVjjkgkj4UCpkhFlH99AQGFusi2agNe4BHU466h08k8AC9/UbNpPR9eOvZb8PPGkkq+KLd8Cts+6/z3MK6DWXNM+HVb1N6cQthfMoY1tTPGnEDbLdTMMGSfCcvbWJupC0luvy0iV7egI3VoMVFtRmULKYZhaLayKNk1Fr8zxQ9hKQmhTVDJ5h1gSGZNxhgjCNRSTSon9qGr0I7jfYhgwbEFOF2dQrqX9L6LX5
 b1DiV5Vp
 GE3/fhCvZ/g3iUf4rUf9UrYiDEr4V1sUdrApKCLyPgrva8Qjp22j9Bd6Ph8+7NtPsWC3dZ30TURywhIq2PaZt2yVSeI3+dlFOq0aS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

consume_stock() can drive a stock slot's nr_pages to zero while its
cached[] pointer stays set, so the slot keeps pinning the css
reference that refill_stock() took.  The offlining drain only
flushes slots with cached pages, so the reference is never released
unless the slot happens to be displaced by an unrelated charge or
by CPU hotplug, and the memcg lingers in the dying state - up to
NR_MEMCG_STOCK (7) of them per CPU under container churn.

Keeping the slot populated past the last page only saves a
css_get()/css_put() pair on the next charge of the same memcg, and
costs more than that: the offlining drain has to know about empty
slots, and refill_stock() cannot reuse them either, so a charge
under a different memcg evicts a live batch through the drain_idx
rotation instead.

Drop the reference in consume_stock() when the slot empties.
Empty slots stop existing, so is_memcg_drain_needed() and the drain
path stay as they are, and refill_stock() reuses emptied slots
directly.  The cost is one refcount pair per emptied slot, at most
once per MEMCG_CHARGE_BATCH pages.

Fixes: d1a05b6973c7 ("memcg: do not try to drain per-cpu caches without pages")
Signed-off-by: Song Hu <husong@kylinos.cn>
---

Changes since v1: drop the reference at consume time instead of flushing
empty slots from the offlining drain, as discussed with Michal Hocko and
Joshua Hahn (full-stock drain cost, refill reuse).

v1: https://lore.kernel.org/all/20260817025917.66233-1-husong@kylinos.cn/

 mm/memcontrol.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 17da1f43b7d3..1271d390b617 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2140,7 +2140,12 @@ static bool consume_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 
 		stock_pages = READ_ONCE(stock->nr_pages[i]);
 		if (stock_pages >= nr_pages) {
-			WRITE_ONCE(stock->nr_pages[i], stock_pages - nr_pages);
+			stock_pages -= nr_pages;
+			WRITE_ONCE(stock->nr_pages[i], stock_pages);
+			if (!stock_pages) {
+				css_put(&memcg->css);
+				WRITE_ONCE(stock->cached[i], NULL);
+			}
 			ret = true;
 		}
 		break;
-- 
2.43.0


