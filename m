Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91725E7AD41
	for <linux-mm@archiver.kernel.org>; Thu, 25 Dec 2025 08:22:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D554B6B008C; Thu, 25 Dec 2025 03:22:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D15896B0092; Thu, 25 Dec 2025 03:22:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C556E6B0093; Thu, 25 Dec 2025 03:22:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B35726B008C
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 03:22:24 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7076513B67E
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 08:22:24 +0000 (UTC)
X-FDA: 84257301408.19.4B6D2CC
Received: from sg-1-103.ptr.blmpb.com (sg-1-103.ptr.blmpb.com [118.26.132.103])
	by imf04.hostedemail.com (Postfix) with ESMTP id 19B6A40002
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 08:22:21 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=MWaCbPQu;
	spf=pass (imf04.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.103 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766650942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8UJwqsCU7lKx7MsCtXv7Xp41I0TJ8HI3IDAYvOZfD+4=;
	b=HCi7P2808U5mYd1qEh+tk0nMeiX53MPWHiCO8c5A5BWdUOPlSQgX7seQ0yo6+AWrAnzEWt
	ofFe8Inz3hJiI0gV2fMSQTWG0y1FgQ42G1CPxUEHWCEMiWYpG41JFh92WKnenC8nsgHaOL
	cWKtZj10FMKXF4eGPU5CuZgzIumfTzs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766650942; a=rsa-sha256;
	cv=none;
	b=tpcU8e6HvBM8jduLGLtmjXKMqyjpfB0NBnIb2zjgzsUk54Se4AyArTmf2ioYYB2WHBJF0O
	krGjrBY8APB8bMdgnCAi2QPXHVOijLkpgozwsr7p9xjyd7717rQGePR5JCZiMtv9KAIErh
	Mcg+zQJ3+/rROZbY4YRCxNya5j/RpXQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=MWaCbPQu;
	spf=pass (imf04.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.103 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1766650930; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=8UJwqsCU7lKx7MsCtXv7Xp41I0TJ8HI3IDAYvOZfD+4=;
 b=MWaCbPQu8GTmozuRmHrykATUlgO2YPmKAcBH007EnG3KE7muzSEjdmQmJ/Tbgono/biUbq
 qIngagg+a9e/CiBczSE0hHY7TQJbOjFIubeabmh6EXb7kCuv9dpFUJcBDvVpF2Il6QbsCK
 kjJmEtsvZBA9O5wYj/WFAFDH5M2JkJKMSgRuMLhesTxeiTsVny2UHoZCA1rg6nJIK4dJBn
 VzHQ2ynv9ADTwXXkeHsXLMwhVmNnQUO1RIcMwQl5TTn1D+ugxLgyWxQhvuHoEQp6ButZKY
 EdxI5RPLHrR187XI6XmJInlXlO7OpfuaIlsJCse/FwYejRNZ84BkasR1/+nh5A==
To: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@kernel.org>, 
	<akpm@linux-foundation.org>, <fvdl@google.com>
From: =?utf-8?q?=E6=9D=8E=E5=96=86?= <lizhe.67@bytedance.com>
Message-Id: <20251225082059.1632-4-lizhe.67@bytedance.com>
X-Original-From: lizhe.67@bytedance.com
Content-Type: text/plain; charset=UTF-8
References: <20251225082059.1632-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
X-Lms-Return-Path: <lba+2694cf430+ff30ce+kvack.org+lizhe.67@bytedance.com>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, 
	<lizhe.67@bytedance.com>
Subject: [PATCH 3/8] mm/hugetlb: move the huge folio to the end of the list during enqueue
Content-Transfer-Encoding: 7bit
Date: Thu, 25 Dec 2025 16:20:54 +0800
Mime-Version: 1.0
In-Reply-To: <20251225082059.1632-1-lizhe.67@bytedance.com>
X-Stat-Signature: xn7318z4yuymxqfj1dbatdisbot8urwp
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 19B6A40002
X-Rspam-User: 
X-HE-Tag: 1766650941-961012
X-HE-Meta: U2FsdGVkX1/lWR31A3I9uzN+h/5lJQbHXHL+ZcU4WxTLrEJpuun7glZgSvpkCm/jX5gIY0lcpLSu3bzl+Zf+r+hRmmbd/fWpc6/Bodu3kIr/00I7qFt8vf70PEHzas48BpLONdMeHjK7AOWQ3LzYCIWghL6LRcSN6avhy3KT9frpSDm6WedECQKkQRSIDfs70v9hVWTu9qEQ7C+aSV4jnVCeposLT0Z8VCerKBCMRK5Hu71AykmMgqQX72rnKxGGV8e9W4YIFWGjq2awWV+peToCn6Keqf1PPQSOHvI5ecmfol/tFEXcpbG8KBrXlwEn4lBmxtnuYYIKPgTcfxI7h6A2/h/hc202ajGuwWwLyOdH7+oThEOPvGGHoNJsE7rLvxsztnejVdnNPQgDgeHIzPglmMwT+qGsW8t84pw7ok8iuk42r3xQSKjmtm0j7mp4epeo3gjwAAxJXoow+JuGSETe5cAaJWhPx9tK8azu1vtjVmIHGUxuKaqOGx34sOd5TB+j9U83m8fTL8UEoZWnRmisq+MPHXy1sdf4c8IDoJdskxS4LkWDSevyPcthEAqb8dcoMOBVYcb9SST471IIT93RSpGRcSuorPNIqFlOvL8+ECLl6sQmE6O7vjPhfkOtdbS4w05/icetKhJcQi797Nbp7zBCufckMKrEUuICoiuHHAZSqt+mFh5uI/S5UXkjwtJdBlY4py58Bmh7d/7wBwlV38aGGhAWBCJtMAhceay7213FjYHngm2LG8kKaGPTC3Hjs/IKVMrJo4xtZrGt9hQAjkuoVcDelMqPseLCDAXF8WtyP+2S6+w/c5+TzDrgrrKBV/ISJFAQgjZzosXn5oDUP1an91Udn/aOM3vFY2him6rIQZtPBhMzOY1cuq8C/i6hh3LHSowAnqHD2P+a8Kg0BtDcUId/jM+bak9qzKmXEpm8KMFYbzC5rWs+eV9P9IdmKmH/siFs9cFc0nY
 sdf+MCDZ
 bcAwsp7EGLAkqZoc0w1sK1t0Ad9To92QRf8uVSTFWVMc/s7MDUrPHkylHwAE4Nv/Nv2SWSomO/MGvC49qxsttpIYWwwRQcOcag6y8em0UEpdlDGZBgrBiz1dJxPZAKp6L8ONZa2RYxdiKvnN2dWppvCH9nqjt27VppkQnqm6WKd75Tf43MJxlg2rRRophmihbnKzf8Gp/GeQoc/RRuJ5Ng9Cmeoc+m2gPnWjNxWDDv8s68ZXT4rIIhZU/jPeIplkeiPuOj19zGM4S9NQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Li Zhe <lizhe.67@bytedance.com>

For the huge-folio free list, unzeroed huge folios are now inserted at
the tail; a follow-on patch will place pre-zeroed ones at the head, so
that allocations can obtain a pre-zeroed huge folio with minimal
search. Also, placing newly zeroed pages at the head of the queue so
they're chosen first in the next allocation helps keep the cache hot.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/hugetlb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 63f9369789b5..8d36487659f8 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1312,7 +1312,7 @@ static void enqueue_hugetlb_folio(struct hstate *h, struct folio *folio)
 	VM_BUG_ON_FOLIO(folio_ref_count(folio), folio);
 	VM_WARN_ON_FOLIO(folio_test_hugetlb_zeroing(folio), folio);
 
-	list_move(&folio->lru, &h->hugepage_freelists[nid]);
+	list_move_tail(&folio->lru, &h->hugepage_freelists[nid]);
 	h->free_huge_pages++;
 	h->free_huge_pages_node[nid]++;
 	prep_clear_zeroed(folio);
-- 
2.20.1

