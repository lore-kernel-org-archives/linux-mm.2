Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAE21EC1EA5
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 12:07:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F2976B0098; Thu,  5 Feb 2026 07:07:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CBC16B0099; Thu,  5 Feb 2026 07:07:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F3406B009B; Thu,  5 Feb 2026 07:07:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0F1956B0098
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 07:07:49 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CD03BC1CB4
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 12:07:48 +0000 (UTC)
X-FDA: 84410279016.25.207C105
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf23.hostedemail.com (Postfix) with ESMTP id 08B2F140013
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 12:07:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bElHgJWO;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770293267; a=rsa-sha256;
	cv=none;
	b=gdw7eoFcflqi1VRB4zB7uRvUeSsMQMePOrVAYukNjyEsbXarRTtU5GFFX0G6RdvGvY3vyu
	6ladVSisxcSwhNT8TCizji0MorSQ6lzZSPdiFeumQkL4DapJv15UKrelNH34gJKTMKJGwm
	smDCjzbAHlkLj2lEEIm8DUo2pgr5mR4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bElHgJWO;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770293267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=HwXzgfSUWOHVbbonVH7nnw4Aoqzv+GZiKEzBXHPRk/s=;
	b=3FrNsas8L/E5D4kmijGJlDCedOSjvugd5kAFBXENEOm+SrRMrpwKRMbrh419sKkNorZ2ah
	TEfuccf2riGpHyVyrADKV/dRqwPo5ejK8XUtuuOH6j9hyGd49kEQS+vUk0IQ6PZCEbMZYA
	Vf0iECZkn2esjF/QuI7yXf6ur+e5yHg=
Date: Thu, 5 Feb 2026 20:07:23 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770293264;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=HwXzgfSUWOHVbbonVH7nnw4Aoqzv+GZiKEzBXHPRk/s=;
	b=bElHgJWO15ORWXe1OfN3x4XDw0xJj+vuxH8HUv+UwikG8iSeZi/DoIwH9DDGK8LJ+noWxG
	v43wX6RoxgiGEYQex6RWpPX/2M8eaK7LFhtpoPKrFXEYD7NXf6JULcBiGYsDW6IpJtYR61
	C+oH4OF+0BV/jDYw7RVQojEcweBDK60=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: vbabka@suse.cz, harry.yoo@oracle.com, akpm@linux-foundation.org, 
	cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, hao.li@linux.dev
Cc: akpm@linux-foundation.org, cl@gentwo.org, rientjes@google.com, 
	roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Hao Li <hao.li@linux.dev>
Subject: [PATCH] slub: let need_slab_obj_exts() return false if
 SLAB_NO_OBJ_EXT is set
Message-ID: <20260205120709.425719-1-hao.li@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 08B2F140013
X-Stat-Signature: af6dnt1iataihhcjy97n8qt3goqkrne7
X-HE-Tag: 1770293266-117863
X-HE-Meta: U2FsdGVkX18f9lOCSWA7buPxEesM4PuUG8n8WLUM9VI4QXUhGTOMytsHVj+kmgs5/o23wfTDwxk6eGKIW5qrF2/jr+o2IQhGivS+FklD3YG1xQKRQVxz+dFWjSyqaExlayHQCu5G9bk71oq50ROMmr0tBYS+9OKKzdtlP41Dzj5g/nRZDvlt0fOhTaeoShtkWAGQeahfcX52+iMJ8/jKzt0rBQbk71N2vxbL2gJ0y95DGzjhTF/FeEh/jZJZW8q0temq1L/cqRNGX/6s4xBzOdSoI2zuz2m80TIdZzi7jzT/1kfBz415AWqIUB7LxqiiA9fE8CaEQKB1dTOg/9ozPZ8zjd/mqHu8S+C6NtbTnS8/ILt9OIuP3oQUouEXKrmBj7/qeyoTrLvL6WrQBypzF7ToJU2q/YN18H0ScdJaMuA2aX+R+elBK5NvSmOxpClLhimeH3bTvEDJPUHZLZFKT9bVm8A0EJf54w6apoKhBO74nYveki1JTiQdNW19/xTcJwnKnKtBa179bPo0zsKH0s6Mvf0gVz+A1ZOjpNmXV5gRd/MmBB1RF0hvAV5BmxEDuq6Yrlb8IYXeCE4TUBtbWWaTy2SK6DQrBqBe9MTSqNCrLndXER4W41+5Wvkn/i1IlcVFrowhvGznd2ZBEYs+h7I3GJpT8UGC8qdk5guA3eTQ/fOyd489K1teZuxwTAcsttSA+VrAXAsA9hxRNAD4p7isRDcuBnRer39Upsw66HbZt6YVAVNO5bugP9aZWrBhpbD+gEB0uxBkTrmROu9uDIsL280P2hsuBoqBKoFD5fXjo7uGDJWmBC/fSOYkikwftiAjSEoF+bI9lTqUrM+c88sXwEXG/hMDHrBQOB9+l0YJ8XPM7xYRrClzWTYfu97OId8Msg4LON1xU3t0RB4s9aPnnO88jY/4MbH+Eqdn1AtBaMxAfH608lzfdYUAzG3eW+UATJNSEpZ0xfD45rx
 Pz9WNe8Y
 Bh9rl7HEkhmJyaPs38fnjuuO8X24wwPngWwPbYscNvKMWj23FyBkuRV2+RlLDJZUF7K/D6YmwBSrH5NybX3GfxtBf/2sRBE0zS8qJFmmiMfhG42qcWZPgjp+DwzzEfpOi5lyHcNIBeSlz41PL65by9bG8S30LEPOryuVdVYEwJT0I9osJesJlHPhe/3HcRfrcQmwe74LBToWpaAbRu9Tn/pSw55+kHHiM8ZkemAfV2nbS4mr4vhsQLw8sfW+utqS4ByDS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SLAB_NO_OBJ_EXT is set for boot caches, but need_slab_obj_exts() doesn't
check this flag. We should return false unconditionally when
SLAB_NO_OBJ_EXT is set.

Signed-off-by: Hao Li <hao.li@linux.dev>
---
 mm/slub.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/slub.c b/mm/slub.c
index 865047eaf02b..3b1402e1c39d 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -901,6 +901,9 @@ static inline unsigned long get_orig_size(struct kmem_cache *s, void *object)
  */
 static inline bool need_slab_obj_exts(struct kmem_cache *s)
 {
+	if (s->flags & SLAB_NO_OBJ_EXT)
+		return false;
+
 	if (memcg_kmem_online() && (s->flags & SLAB_ACCOUNT))
 		return true;
 
-- 
2.50.1


