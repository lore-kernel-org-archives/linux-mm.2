Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A747CD5BAB
	for <linux-mm@archiver.kernel.org>; Sun, 24 May 2026 14:04:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 320106B0092; Sun, 24 May 2026 10:04:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D1056B0095; Sun, 24 May 2026 10:04:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E69E6B0096; Sun, 24 May 2026 10:04:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0D1176B0092
	for <linux-mm@kvack.org>; Sun, 24 May 2026 10:04:39 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5A0D61A0D11
	for <linux-mm@kvack.org>; Sun, 24 May 2026 14:04:37 +0000 (UTC)
X-FDA: 84802483794.13.F856039
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf23.hostedemail.com (Postfix) with ESMTP id B7B1514000B
	for <linux-mm@kvack.org>; Sun, 24 May 2026 14:04:35 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fyGIIUYL;
	spf=pass (imf23.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779631475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=mk78eHnFhgUgCvO8WVCiSQYNQ2D/doAI48Qx25lC6wY=;
	b=Q8DYzLGL2HmWeSZ2w6P3PR4GYu5fexYhQELY5TU+NLijzYAAsPX8sxXaIU2JIDbiNbIIB3
	TIf2KI34lwuQgebN0V6Luujem8JB0GGUxxa+GqkB85a1Zbl2ppA2tJXH63M6TIIeJad0Zn
	rjc9MGZ6a8CerqPD5gRbdwhlcY6dKgE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779631475; a=rsa-sha256;
	cv=none;
	b=ZeAFywuK2N23Fvwvf55mLGrrQUMuzgrkfO5ZOe48n6PklQMXIG0Co2oNAPHrwib6iP1Nwm
	azDieg4bV9lafd9lhEOwLRJI/MnTaybBtSe39Svg3PX3oneWcEFplCJ8fxgTFtCAbMJgjP
	DcVc1ji/8Q+Y3Ci+Bu3OZVFtaQEd8Is=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fyGIIUYL;
	spf=pass (imf23.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779631473;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=mk78eHnFhgUgCvO8WVCiSQYNQ2D/doAI48Qx25lC6wY=;
	b=fyGIIUYLLA89SpMTUFz9YhI4OAucJpEoDj7GveEnaMTTKYToiuiISshEcXVqKtr1rmsAts
	vAb6R5Lw8KuKAZ2JeLKRuZdjrDoOvwi2wzPgPnmPcDMYd89XvwcR18WqvV002F+y/gtTav
	9xYr0PFBQXqgNoEdSXAJblx2FjpUCkc=
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com
Cc: minchan@kernel.org,
	digetx@gmail.com,
	jhubbard@nvidia.com,
	gregkh@linuxfoundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kaitao Cheng <chengkaitao@kylinos.cn>,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH] mm/cma_sysfs: Skip inactive CMA areas in sysfs
Date: Sun, 24 May 2026 22:04:20 +0800
Message-ID: <20260524140420.61864-1-kaitao.cheng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Stat-Signature: fmnrdqyr46xfu77ejajn6fbuy546ijhp
X-Rspamd-Queue-Id: B7B1514000B
X-Rspam-User: 
X-HE-Tag: 1779631475-530596
X-HE-Meta: U2FsdGVkX1+nkvbEsvpRdyVphsAUDBS6Xc7EhKDmDZI0pTvIR5kF4s1gc5iqY/3vSnvnDzu1yGB2Pxh975ipKWzDUaQGnNhEWUCp0Ca2Uev2VYm4O27xqRyJ/XjGTXo/gj1Q0nB1GytapVaP1LT2Vbzyksbj05PBOLiV1r2N4ylxK1l47QTVUD6swBDB4P9DChSSzNZPilGW2DPBU5NtEA8R79nPqO290tW1eTazyXth4aEmq9neKpvq0R4TpRJhg1J0w+f9qO05k7JEscJqFFO84pXjh4P+FDUnmNfuO1LXQZUbUR3bc/QsOzLOCStbpVTuPSMXnqmjKQjChcGk2G4LzZ59G1vAUfPyWb/qC6VUswNPVexqNNNaKWdahcF3hUfqmC0mhZE2ljY19B3XP2ybOBWjcaY6voqjPXgcQ1xUxUc3zMTEayV/w+P+qgEyMPY1uZ5tY05yZdYAvI54LqFBRgKLUtfI5PT5bT/wPRWagR7jcWSHxr4ycZXh1+xwi1WxKN/iW2aNtRGwsFjuv3GxssTmebfg1UEc7pAE4hJ5jNfFcOhxLbEyML1y1p1hRTd1reGXSvNuy0o+SRq+armyyDU2ORLi8IfHkqkVSG/j6ZEcdIJQPZ9AfquDkH8oZGM113FqMpRkKL84nu5XpSgERjsSXM/hR5xmQsW3YwzUlYhza5oeHV1EecnzVUTjLEWlWDWueVs+VDmRa6KJzYJiRd38mh8IfzHRen+MHQFpYlNXROkKVkTNK1bhz9wz8kH/4uKIFUtuJMSKy/SoP89JYLcMSiTWgG0JmobbGFY5CEDgdvKPOJ5/Ewc2uL8OAvDNfLa9E4M5kn9jLk3i8YIOAKwjww3ezEDHOxy5QXhPEN0CWMcGEn1+uIb/TfozlMEsX0jktxYruyLZmG4SP6robr8jPcEsZ8ac3MFzLwjEc8YswXNcwmGXjXmsJ/jbEaUrJ7O0aYucr86vuS1
 96KZ+DNJ
 gJwf+EdImPc6YH77l5gdyXI+q/Q2LGoQFrKOGnFi/GwAeWB9Dp9En5+fywTmLV84cFWKVFY9H85EQqHEDNaoxpCc8T9mw2Kckq3MHoBpZXEbr/8wT+ltNzoJeGXwZHJNmmQnAbGGMxWdxLsocKzLRITBC9+lNFQYVpZD539UIPQQqK/z+wU0mge5evJq1CEHyX0rMpzTLLr6U7/mvrgC6vmBpQNZhssw8/ry1cc+QUO24UbH2wmBje9ELf/pniBP4kf9siWDO/Mnf5o5Ka5VB38U5/D9IscoKyaKFGcOm7BlIWBo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kaitao Cheng <chengkaitao@kylinos.cn>

cma_activate_area() can fail after a CMA area has already been added to
cma_areas[].  In that case the area is left in the global array, but it
does not reach the point where CMA_ACTIVATED is set.

cma_sysfs_init() currently walks all cma_area_count entries and creates
sysfs files for every area, including ones that failed activation. These
areas are not usable CMA areas and should not be exposed to userspace as
valid CMA regions.

If such an inactive area is exposed, userspace sees a CMA directory whose
read-only accounting files report zeros.  total_pages and available_pages
report zero because the failed activation path clears cma->count and
cma->available_count, while the allocation and release counters also stay
at zero because the area cannot service CMA allocations.  This makes the
failed area look like a valid but empty CMA region and can mislead tests,
monitoring, and diagnostics.

Skip CMA areas that did not reach CMA_ACTIVATED when creating the sysfs
objects.  Since inactive entries can now be skipped, make the error
unwind tolerate entries that never had cma_kobj initialized.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Suggested-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
---
Changelog:
Changes in v2:
- Revise commit log

Link to v1:
https://lore.kernel.org/linux-mm/20260522131434.78532-1-kaitao.cheng@linux.dev/
---
 mm/cma_sysfs.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/cma_sysfs.c b/mm/cma_sysfs.c
index f52b696bc46d..d5bf792c6245 100644
--- a/mm/cma_sysfs.c
+++ b/mm/cma_sysfs.c
@@ -117,13 +117,16 @@ static int __init cma_sysfs_init(void)
 		return -ENOMEM;
 
 	for (i = 0; i < cma_area_count; i++) {
+		cma = &cma_areas[i];
+		if (!test_bit(CMA_ACTIVATED, &cma->flags))
+			continue;
+
 		cma_kobj = kzalloc_obj(*cma_kobj);
 		if (!cma_kobj) {
 			err = -ENOMEM;
 			goto out;
 		}
 
-		cma = &cma_areas[i];
 		cma->cma_kobj = cma_kobj;
 		cma_kobj->cma = cma;
 		err = kobject_init_and_add(&cma_kobj->kobj, &cma_ktype,
@@ -138,7 +141,8 @@ static int __init cma_sysfs_init(void)
 out:
 	while (--i >= 0) {
 		cma = &cma_areas[i];
-		kobject_put(&cma->cma_kobj->kobj);
+		if (cma->cma_kobj)
+			kobject_put(&cma->cma_kobj->kobj);
 	}
 	kobject_put(cma_kobj_root);
 
-- 
2.50.1 (Apple Git-155)


