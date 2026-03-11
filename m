Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 480A8105D26E
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 11:04:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79D1F6B0095; Wed, 11 Mar 2026 07:04:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7455F6B0096; Wed, 11 Mar 2026 07:04:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 685ED6B0098; Wed, 11 Mar 2026 07:04:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 46DC86B0095
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 07:04:06 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DEEAA13B9B7
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 11:04:05 +0000 (UTC)
X-FDA: 84533497650.28.F7A3533
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
	by imf08.hostedemail.com (Postfix) with ESMTP id 08443160003
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 11:04:03 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	spf=pass (imf08.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.197 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773227044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S5/Cl/z+0gmIUXxDptFUfJfM1oCYe7o1UJXxQdotJW8=;
	b=RBUABmC3pz4SPpKLHHQY0TRFKhJJGElJQltYQzJJKXkBOylIe/7dn3tPr3ykbs8tvKpHDV
	Tyi5pPvWHV6fVDB59gt99EVp6cbo/Vv5QFHQAYPEQOYCRo3FuwJuwqGGOw8Q7FHiGJAMDZ
	i5FWGQk7KckARn6MDr7Kr5ilgen0n9Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773227044; a=rsa-sha256;
	cv=none;
	b=aEvZRarvNZfvKtoT979Nzj9XSHTY45wAXyF05J4wE3ws5mbgyZkQoQsg4RQP5CCvl6lXfk
	IZxE8FH5omEW9bJyhZyHlb5hJgM3Zii0tDUcYsp66FgJqAKomZRrZlpI3ocylVDmrNkIgX
	2VtZG1+6cJ13BPHSMvDJhd2JFZ7CgK0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.197 as permitted sender) smtp.mailfrom=alex@ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id 9A2D24329A;
	Wed, 11 Mar 2026 11:03:58 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: akpm@linux-foundation.org
Cc: alexghiti@kernel.org,
	kernel-team@meta.com,
	akinobu.mita@gmail.com,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	hannes@cmpxchg.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	gourry@gourry.net,
	apopple@nvidia.com,
	byungchul@sk.com,
	joshua.hahnjy@gmail.com,
	matthew.brost@intel.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Alexandre Ghiti <alex@ghiti.fr>,
	stable@vger.kernel.org
Subject: [PATCH 4/4] mm: Fix demotion gfp by preserving initial gfp reclaim policy
Date: Wed, 11 Mar 2026 12:02:43 +0100
Message-ID: <20260311110314.237315-5-alex@ghiti.fr>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260311110314.237315-1-alex@ghiti.fr>
References: <20260311110314.237315-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Score: 0
X-GND-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkeefjeefucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuifetpfffkfdpucggtfgfnhhsuhgsshgtrhhisggvnecuuegrihhlohhuthemuceftddunecunecujfgurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomheptehlvgigrghnughrvgcuifhhihhtihcuoegrlhgvgiesghhhihhtihdrfhhrqeenucggtffrrghtthgvrhhnpeeludffffethfejfefhfeeukeevffehjedtieelgfekjedtueegfeduhfeifefgudenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppedviedvtdemuddtugemtgdtledvmeegtddtmeemheemfegriegvnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepvdeivddtmedutdgumegttdelvdemgedttdemmeehmeefrgeivgdphhgvlhhopegrlhgvgihghhhithhiqdhfvgguohhrrgdqrffhgefokeeivdfrrdhthhgvfhgrtggvsghoohhkrdgtohhmpdhmrghilhhfrhhomheprghlvgigsehghhhithhirdhfrhdpqhhiugepleetvdffvdegfedvleetpdhmohguvgepshhmthhpohhuthdpnhgspghrtghpthhtohepvdelpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopegrlhgvgihghhhithhisehkvghrnhgvlhdrohhrghdprhgtphhtthhopehkvghrnhgvlhdqthgvrghmsehmvghtr
 gdrtghom
 hdprhgtphhtthhopegrkhhinhhosghumhhithgrsehgmhgrihhlrdgtohhmpdhrtghpthhtohepuggrvhhiugeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhorhgvnhiiohdrshhtohgrkhgvshesohhrrggtlhgvrdgtohhm
X-GND-State: clean
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 08443160003
X-Stat-Signature: j88xzunz4rr9abrcyyf146389q1rj4uq
X-Rspam-User: 
X-HE-Tag: 1773227043-959329
X-HE-Meta: U2FsdGVkX18DxSMUqhKRpKXutM5ovfOhNoGBnhqyk6bDLWtmbS3zWKMn65hvK9RNfRd/TI/gDKf8WX0jHYtm3RHM707XuoON1iJsCu8TKYIcbmQcDsDMIJZJZfZmDc1amBR0Z2X1HodLn49jB3a4G6VDpvVTVg/AVf2jC7mqibDy1cCR2FhMln+Bv+lgFMvdk+6xypUL1u5Db/3t1q6i+7mpjCxRLoYlb//FWtxgw+8FyhCxbS0J+a8EmE1q3dkQNS4hvhFk6tcxmpYMoZnF4vQvcl/hx8xj4mbNioHBNlm0f2SqfZ9ZVLsydnq4KDOPEIiexmFVXipFFflw+X795ty8Wtmk7kPuWUBIyw4JgPZYu6vspv9W+j+QplFf2LuxBqG4w3ZesPngOWLSo5zZBN0DeGlT2NJKkEprtl8pRhhqBwktesVKrIlsaAvp6hAzqhpuKiD/KLM+Re1u3p29/WKKJq0gaSl3SVnLUnOgI7ZVJJ3B+YBXqBk06bNWsNxHSxzrsyf3XwnajZKoCp6pTgHg8B3qKUQTPK3v5LvhL7aKI7gwMi6/1Jn7hMlSsYUZqdnRKzYnaM0lL6IKm6ILmNggrnOlzihBSHS1ketFCqTCA1hk/9I1a7GvJuOlqSugCFMu0bC58ANv5GrO9y3uXdSBFYr/aj5xZALvv7P5RT5if23UD0GLLB9hxpF7E20om9ouznrvYNAXLnfwLsoNOKy0V7wUYL/UX6qG6kBdfPH5rX6XOB7KtRUR15xbkQWcZugb1qiNnfXRktgNbWcA2LZNJBFEw+1QY0tdR2ceBEwtanKt95i4QtGnqWeQXxYbbSxYzNXS1RxF5kKX/5hV4DqHQk+GcH+xbCLryIWDhC9I2bhlWeUredM3FQm+A+sspQ+HmXuppqY2NEXD6o07AY/dhEffbOfc6UgSk80WJbi3OgXHzi/tKqdxzc4wy2CSKSbqbrH5YJGHo0fJQ8c
 Q61WVfvG
 wYzsmkX6xt6a5TFzgyb3TGIwhXhwo/XJfjKRe3LlsQCwQazWdcIkPjWiqdSn+v8EoUs2lnHph8uF4KND5qcMgq7xbW6GeN00lRVgkH8TgkwBA26jXvTCw6JM74XmlHpiMITxHXvsUeEG3E0IQgqQTXeEK758nRzlBbWy2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When the src folio is a hugetlb page, htlb_modify_alloc_mask() will
unconditionally enable reclaim. But we have to preserve initial gfp
flags which, in the case of demotion, prevent direct reclaim.

Reported-by: Gregory Price <gourry@gourry.net>
Closes: https://lore.kernel.org/linux-mm/aXkfBF5bdnTZ7t7e@gourry-fedora-PF4VCD3F/
Fixes: 19fc7bed252c ("mm/migrate: introduce a standard migration target allocation function")
Cc: stable@vger.kernel.org
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 mm/migrate.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index ee533a4d38db..d44a34d37007 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2169,13 +2169,13 @@ int migrate_pages(struct list_head *from, new_folio_t get_new_folio,
 struct folio *alloc_migration_target(struct folio *src, unsigned long private)
 {
 	struct migration_target_control *mtc;
-	gfp_t gfp_mask;
+	gfp_t gfp_mask, gfp_entry;
 	unsigned int order = 0;
 	int nid;
 	enum zone_type zidx;
 
 	mtc = (struct migration_target_control *)private;
-	gfp_mask = mtc->gfp_mask;
+	gfp_mask = gfp_entry = mtc->gfp_mask;
 	nid = mtc->nid;
 	if (nid == NUMA_NO_NODE)
 		nid = folio_nid(src);
@@ -2184,6 +2184,8 @@ struct folio *alloc_migration_target(struct folio *src, unsigned long private)
 		struct hstate *h = folio_hstate(src);
 
 		gfp_mask = htlb_modify_alloc_mask(h, gfp_mask);
+		gfp_mask = (gfp_mask & ~__GFP_RECLAIM) | (gfp_entry & __GFP_RECLAIM);
+
 		return alloc_hugetlb_folio_nodemask(h, nid,
 						mtc->nmask, gfp_mask,
 						htlb_allow_alloc_fallback(mtc->reason));
-- 
2.53.0


