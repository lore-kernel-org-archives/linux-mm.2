Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CF45FC5938
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 11:52:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A64B46B00A9; Thu, 26 Feb 2026 06:52:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E8426B00AB; Thu, 26 Feb 2026 06:52:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EA706B00AC; Thu, 26 Feb 2026 06:52:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 798A26B00A9
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 06:52:39 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E47505C7DB
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:52:38 +0000 (UTC)
X-FDA: 84486445596.05.0B3752C
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf26.hostedemail.com (Postfix) with ESMTP id 72E48140014
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:52:37 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=T9Nh2WP7;
	spf=pass (imf26.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772106757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=e4UtDCLPK6MdNbkYxpreAAQYHqOm0mkD391PTP+crYQ=;
	b=qtVW05/YBse/uPVVfIdBxlPqoaKhtGQEMlA6npc7Ei4SZ4KXtHWqhQsqa5XDdfNazm4aFY
	wq2WEVBbJN/18NB42tDhX03uX05SHukVIlSuhXYnCeeDCphoh8vpo0BE8uRV2xvmCZOgyf
	kKwBDbWALc2B2EFNCxW7AS/7Ez4vLjQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=T9Nh2WP7;
	spf=pass (imf26.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772106757; a=rsa-sha256;
	cv=none;
	b=KSwCfWCMd6U6ga2ydYeDQng9jUjOqJnLbegbIID/ggUg8vL9+TJy/+PI9DYMjb3y9I4rjz
	MedbSFh3oUqyVv79SwfA5xd0dgqv5zd3/r3e1zeO30k+aTKMQC9LlMta5Ip7jJeqHujJGi
	gR1nk3YDqiLMlmm25VKJjmjLRxMR99k=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772106755;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=e4UtDCLPK6MdNbkYxpreAAQYHqOm0mkD391PTP+crYQ=;
	b=T9Nh2WP7sIe3MKc7LtjuySVNIG+4vS4bCG6ibBNIgH/EGfbZUmKHR+N4SLz2Cw/z9Dn2Bv
	8CUeCxnA/vlAsvcgSYCJWJyZ+Mkuyq5/31fFV3qnnDEftqvePsDkZIPf3qrcRg0NMnaxnT
	LDxjti2DMHk6vQJBOzzWh0B372MvaJw=
From: Hao Li <hao.li@linux.dev>
To: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev
Cc: vbabka@suse.cz,
	harry.yoo@oracle.com,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Hao Li <hao.li@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH] memcg: fix slab accounting in refill_obj_stock() trylock path
Date: Thu, 26 Feb 2026 19:51:37 +0800
Message-ID: <20260226115145.62903-1-hao.li@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: uatmx7ib8nko3ztk8uuawiy9pa4ct31w
X-Rspam-User: 
X-Rspamd-Queue-Id: 72E48140014
X-Rspamd-Server: rspam01
X-HE-Tag: 1772106757-897459
X-HE-Meta: U2FsdGVkX19XpovDvgdY9ZJbxIvRjsV4BDC8mDjk+zMiGaCqmIMeqs4xBjQdkQebR7za+L0WluFXrLXuGYO8gB9oYyfo1m+lGYNpIQfAygypV243Bd5zgRxqPDNzz2LvgAGu1ZI/m68DyVoTYqRsTbjOjAaiExV4QMo0SVAP5ltMqEwy/VCNSk1w1KKqcxeC1yqxS0KzRMYqznlW6CKzmbpAnmyc8riu/+10erJOOwy54rJd1C/e43K8IAXBC1cl1AG0ueL9hpooe2bCUeOLFqFlH6ryQnghK1M28HrF5o3JPRSWdqBCEhW6N/2foUboxeANFHElak7+41B+77GFzOmaMsBAN+kU0CnJZ5KfpbuogqXzYDQisyAYJfthiP3D5683V8ChEKBHdvF7R21Kzexkr0sx9JeRaV8cxeOFXZ6gs66BtcsEDZyXDnA+ZmQ3/c2w9FW4OCAeehB6xHLA3lbukxdd0BFNiIO+LJpWISVigWkX8KDx2nQ8OOtrz+OCXk/GohFJU/0KnVn/Ig55jBzToOoMn1PR51b3l0sJoBvgwhUmD67wQlt8fkTD3ecjJh+cLI3aYVEZd5EsbwGm7NDOXO1boNybwt2GCxEBf0zf/kN/lwl1GaizuRizHMCvxXdUjuBege5n0YB5twsFk+pg7UKKk29GKm/USmDZqJL8o4aqEDBMN7/0DMV+hdFW3RifN1kYbBjG2uSYRnPJk3fgvGW7E8oVhUJhaAuKJ2h8Duy5YXzt48L85DXpF5D6mQVUo7nK1m6x76ad98DyEPytX5kzStll8mvc6ClbMeBTVRq0wpBm2wobZxNKhKSMvUes8lOoFME7MxdKhmrRBKhxwQHCvaAeTK+lIR5WoTwcgzPml+v5WHDTTrp2LQlj1JJy1JAybgnXJo6z87XLnX8SZBLKZlrgJI5ZC5hc+ZBQCCOY/WKiMdro9C/QvIZQJyZEF2uPo2c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In the trylock path of refill_obj_stock(), mod_objcg_mlstate() should
use the real alloc/free bytes (i.e., nr_acct) for accounting, rather
than nr_bytes.

Fixes: 200577f69f29 ("memcg: objcg stock trylock without irq disabling")
Cc: stable@vger.kernel.org
Signed-off-by: Hao Li <hao.li@linux.dev>
---
 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2d6dfba540d4..683f9f9bf47e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3060,7 +3060,7 @@ static void refill_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes,
 
 	if (!local_trylock(&obj_stock.lock)) {
 		if (pgdat)
-			mod_objcg_mlstate(objcg, pgdat, idx, nr_bytes);
+			mod_objcg_mlstate(objcg, pgdat, idx, nr_acct);
 		nr_pages = nr_bytes >> PAGE_SHIFT;
 		nr_bytes = nr_bytes & (PAGE_SIZE - 1);
 		atomic_add(nr_bytes, &objcg->nr_charged_bytes);
-- 
2.50.1


