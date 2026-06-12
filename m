Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B68F1CD4F2C
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 07:14:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED8A76B0005; Fri, 12 Jun 2026 03:14:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E89686B0088; Fri, 12 Jun 2026 03:14:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9FD06B008C; Fri, 12 Jun 2026 03:14:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CB0946B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:14:25 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 56A04C2B7B
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 07:14:25 +0000 (UTC)
X-FDA: 84870397290.23.4CD03BA
Received: from smtpbgbr1.qq.com (smtpbgbr1.qq.com [54.207.19.206])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9D8F7180003
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 07:14:20 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=MlwyAvgW;
	spf=pass (imf24.hostedemail.com: domain of chenyichong@uniontech.com designates 54.207.19.206 as permitted sender) smtp.mailfrom=chenyichong@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781248463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=0DH7CoZwm/L61lyISp16HVvqGBcx50fMetTeOW/xtCg=;
	b=IqaoWJCEedl5C/zbna9Bwpgf5ZrUf4MB8B1+G1NsLfq29LR9IqVdbRBGZiPtte705Teuq8
	XOhhs5sWppTOxoE0IOquFbYzOLouWJzrObMMDL6PrxbgxF0NgNPoDyxYNEfE73E8/7PI2o
	sfazq6YfK8e7moXlJn2UBmc3q057h/k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781248463;
	b=tcoY34uT6bgOekWdTK/XxbfanvkGsUPoMl0saUso0yj+wVmLdsOdesolDXuqCwAehfyBZl
	zLv09hjx3EEcQ3HYZfT27MGPIpXQextU+O/88olrnDF0JxgEPTfDZQlNWwXF6kRnFgqlT6
	msdgc1ZSktDq4gma6ypYQRyba4tYwu0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=MlwyAvgW;
	spf=pass (imf24.hostedemail.com: domain of chenyichong@uniontech.com designates 54.207.19.206 as permitted sender) smtp.mailfrom=chenyichong@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1781248449;
	bh=0DH7CoZwm/L61lyISp16HVvqGBcx50fMetTeOW/xtCg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=MlwyAvgWqCe08Ms1kY4eu/JZ7vJS4LgbLUjZ/hKRYo+vJobneaw/kxDTDPgsomZsq
	 5gavSFKUQhZU5CN87/yiRPf6FK7T+Xr0jV1mT0ouGy5ExCy8jWZQdOZ/xA/juDJ5J9
	 GF5wG9842BuWUfwf1K/7w+OxZblYdSD5NDO80AL0=
X-QQ-mid: zesmtpsz8t1781248444t1be742dc
X-QQ-Originating-IP: N/oszSuHs83mENbsmXIoy+f3ADjb+RACc/Oy4wPXp20=
Received: from Shurima ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 12 Jun 2026 15:14:02 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 3577815154405116248
EX-QQ-RecipientCnt: 6
From: Yichong Chen <chenyichong@uniontech.com>
To: akpm@linux-foundation.org
Cc: penberg@cs.helsinki.fi,
	clameter@sgi.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Yichong Chen <chenyichong@uniontech.com>
Subject: [PATCH] tools/mm/slabinfo: fix total_objects attribute name
Date: Fri, 12 Jun 2026 15:13:59 +0800
Message-ID: <96556748872BB47E+20260612071359.649946-1-chenyichong@uniontech.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: MiI2pzLhVQ8nAttIPauINP73KdLpitr6JHSwVJmySOID0qBT51nKjSgB
	ZRgDE/bnoOk/DqD11f3vTfVsJOrefFaGGM+QO8e5LfyhE+jUnLj4ZaZMDwZ9Hcx40lh66l1
	teKrY98b6IHpJct4MGrsM/8BXfEITEi3AWtFP2WXyJ4y+1FF+x+7j6086G36yLgU2XNRVdu
	/JE5s7YZZfICPQGYj4nDucsQy20Eu9G0wbd6KDY6jLSqDNaR3V7TJkgH7QUy+G+2zo0sHn6
	C0tqsBtliRql6v48Ix7bk667qwKGwTS9vGECXhveN/XzgL/s4eyR2fDdwtSC9tR3C/kf6La
	HGm0E9kiFDkKfJKuw67jiEU2lBzUbPT9r3PuTU3sSY/0ZU58mM/39U8rlAszA4EaI+7hyyc
	CJReT4X/jRXPwJtWjpYvFG9ly1bg49M8GEAmqNcN4okyF8PRp1YLpGve8nPGrdjnobtbaEY
	TFfYn3XaFdtHJc4SdVM4YlvZ1oorS9JcoJizU7p0bZPV+twIR7DgvD06F/XrHj9zAcHby+A
	ot0XjTI1VowxHK/nsJqcU7xDj+lvOOkuohHh7zupOYLb4OTwmkYW672X1CMOZTnl9haHdPL
	Qt/a+BpWPjsY2WU0FixQXPc5dVNCuFkGaLkCNBID1WO+q1zDLSaaHh0ww+NXgCmIx3abAfh
	0QUkj8DPV/lMVXl5uUzcEwDBw+Ar5AD4fVFxys6RZJtcRDNjDlH7eoz6SDYffsd6yxP7WpU
	qtoxcOT8z0TJP+tO+ZLRnv8i1Ivc26jR386cX3wsLUHxDqhfKmPqK8CAXHKwWMOVQxszrf4
	JZ0qX2Jp8IVlkY8UWXs/SD+F0acPC6H4IyMojrGR2jgb8MCi7YyvqikY6D2Fi4aXRl/KUH8
	eLDfiKs/DEC+wkNBeEV6ra2Pa4Di7XPYz+F1i/2btwZHxWE1w2FunJ+PVdm5tZQtsxGGnRB
	YttTm3jcNXgUfNIkBDjmB4U8yMDyitnQQvj5Nwc//ihr6TGDQRG0Sq3PFJ1bqqDNPF3HQon
	0z0wNbXatL0XUDnlbeAqCQwXYFbICkQamXLd5Fyob18BAMyQ7wyYT9Q8wxuTpddDdhcDBdW
	Q==
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
X-QQ-RECHKSPAM: 0
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9D8F7180003
X-Stat-Signature: rez798fu9sdkr1ktff4b6obkzrse9tq5
X-HE-Tag: 1781248460-936217
X-HE-Meta: U2FsdGVkX18UZkKIQ6b/efkni2SNN6oyaAH6oMZZhkahBvz68Dh1lw2tX65jpoM/x8B18WiyCwqjunwGV2iy3YgT8Q3/kH6LEZG0NIo0zBo/Tv4vO8xUybiWCfvTngsb0RcLSLIHBPYmnm+O/S1UPwEnlXEnZ2ED9UYfblDchWC/TrMYYs9LbQjbDd3UUN0Odnt2YxVsGU8GexnLlMxK6isPjWcMIa/dHchRxMIFeF70yYr0YokY5RQOzxjkY51423PRbrSjxmyEzCTxv4dBu9qzafzKVtlU+EJLpmRFExusl9Sg+FKQRmISyWOf8UDsY9+zqA3L8yjPvOishmaaQHCQ3XkByHRylXOX0fNgezS9Q8htd4LIpf3+6U7NVNao0VXQLbF6NCuvHtnQvXoHUZIlb8QFS3XDg/ty5+8d2yGx9ZmlfTmnkQEJmoQIEMDd3xZfTdWI43FHJEjCvkfTMzHYIh6AZyzEqIvqNG/RT3Osh2tX6pLsBgmhGOEs0DHmS5dPHjZcKRTofToH8OriYdzsfp5OkUzp1nWINc017n0kFrboKCl5WE0PIEjc4MQpVJG2r+6WOwMf4ODRSXLHtFHf9FNS33gjLoPjtsIREmNt13MqD1CfeOn29TjMjHWpTUzF9WAZcdeykCCWqkyyNuNJY6TkRBvuT5tN+Jm7FY+EiBZqxeyhB0IJu2xappZOv38hFyazhMKNPYzAXtOf+QGWyU4n9GKp+dp4Nv3kGPMPA3XTBCwn2wpQGBC2UCGFWhz8KoUcaD4QPlWocn/G15EPWKbUInkc0pbo9WYiot2k7DfD/+3UrGDa+6QezPa2revIOYeQlkLaDb36aM1uQ6IqwjgIULemrVyKGntDVGYCLyGMW/md9+Reg5YeV+kltAGHuuMngMwR+6NtN3qGPH93UZhPThpmF6BYzYkIZ+7eGfekF94fnMmQx43fTIi3EoAaQYjIp/RQFkj5drj
 qEuAxpK7
 GYZqOqvyawLHLvcdQtR12V2NZkzYwivS6dJ0du+VMFllxfSbcc6nBOo23AFIDju7gjrXj2abVXmz5njNwgJEU/S2DSMgCytNqrLblc7e35TEBrNJDQ3UBi2aDNmc3kuHXCsh177i7eAFoJCVy4fcUa5A78O1qMjE2OEtkYkKx2sqcS34qEalP8aa575E1h1KmmhmRuPojQh8jqi0a30Cb4upSBDtiXC1S/e0qAjlpe3GAtpC6sq7oWgysq1wxX7W7s9knzcrW3lWLNKoB9zHkbZ6a9I7ymz8vYyHTefZzEGKvFX//JhCWcBE7lB4b8B4r+eBBKhnHO8l2G0vcSGOC43PM0OalDFUk/aRE49gdkCgV0fFcGw83PolyZlW9437HIWaLfWmnVJ0d4Bc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SLUB exports the total_objects sysfs attribute, but slabinfo tries to read
objects_total. As a result, the lookup fails and the field remains zero.

Use the correct attribute name and rename the corresponding structure
member to match.

Fixes: 205ab99dd103 ("slub: Update statistics handling for variable order slabs")
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
---
 tools/mm/slabinfo.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/mm/slabinfo.c b/tools/mm/slabinfo.c
index 54c7265ab52d..f4077746d6df 100644
--- a/tools/mm/slabinfo.c
+++ b/tools/mm/slabinfo.c
@@ -33,7 +33,7 @@ struct slabinfo {
 	unsigned int hwcache_align, object_size, objs_per_slab;
 	unsigned int sanity_checks, slab_size, store_user, trace;
 	int order, poison, reclaim_account, red_zone;
-	unsigned long partial, objects, slabs, objects_partial, objects_total;
+	unsigned long partial, objects, slabs, objects_partial, total_objects;
 	unsigned long alloc_fastpath, alloc_slowpath;
 	unsigned long free_fastpath, free_slowpath;
 	unsigned long free_frozen, free_add_partial, free_remove_partial;
@@ -1263,7 +1263,7 @@ static void read_slab_dir(void)
 			slab->object_size = get_obj("object_size");
 			slab->objects = get_obj("objects");
 			slab->objects_partial = get_obj("objects_partial");
-			slab->objects_total = get_obj("objects_total");
+			slab->total_objects = get_obj("total_objects");
 			slab->objs_per_slab = get_obj("objs_per_slab");
 			slab->order = get_obj("order");
 			slab->partial = get_obj("partial");
-- 
2.51.0


