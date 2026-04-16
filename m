Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87CD4F428FF
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 06:20:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 982516B0005; Thu, 16 Apr 2026 02:20:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 933446B0089; Thu, 16 Apr 2026 02:20:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 821DE6B008A; Thu, 16 Apr 2026 02:20:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6DE9C6B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 02:20:15 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8BD7E13B7FD
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 06:20:14 +0000 (UTC)
X-FDA: 84663419148.14.5C91391
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf28.hostedemail.com (Postfix) with ESMTP id D037BC0003
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 06:20:12 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VMiGTDpg;
	spf=pass (imf28.hostedemail.com: domain of gxxa03070307@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=gxxa03070307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776320412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Nf0QCsalo0B1Wg3Ym29TQTIyvRB8LMAG8+6qUgbfobo=;
	b=xwgNBGRpE+DMz/Ek5iYZHkFh6OO8wWBZ+HkUcsoXuro5BXIh/c4ggytKjsUyJ82HsLElKG
	ZUD0l7o+RlsEbKJweD961TDptM/EESh+19+HYmpJ79fMb/RShhfhLSwYZet/LK6Ir17UQ/
	Ijcz0Z77gBRG74t1jsl8ZF6YtrO9orA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VMiGTDpg;
	spf=pass (imf28.hostedemail.com: domain of gxxa03070307@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=gxxa03070307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776320412; a=rsa-sha256;
	cv=none;
	b=27G2TKVfNCqh+bzEpnuoalCZaY1xquMQYz6EglVkBfHz1gWHl4g4avkPsDJSOrt/EmLbZ6
	jFdDBGW+QAi2US1h+aib8LuxUdqg6glTrcjg2xem9ZR6d7hQHt6g/SiAF+ZgQ9FB8UFF9N
	nE6deorNdXYeOakzkARm2DujJZA+MtA=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-82f0fc82c76so2589588b3a.0
        for <linux-mm@kvack.org>; Wed, 15 Apr 2026 23:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776320411; x=1776925211; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Nf0QCsalo0B1Wg3Ym29TQTIyvRB8LMAG8+6qUgbfobo=;
        b=VMiGTDpgQhixQP1BfHSDRgQ8jDQM7GJTX3oxefpf+h6orgTliMD52iXkbcJ4x6CcVe
         Ev3T4z2uEQmw4g7MyVkdv/pQxO/gyFrLOSrsvhun/OmaSJEfAlwLjuDMSoozl8KEqD8O
         NKJoe5OK3Vz9QVLeDLMfT2lVK1GEI2CPyhiN6jJJSPLJ3dJBFjp63W82L5mPF5Q7DuDP
         8nVbyizqF+JpHgRhh2v817S/vJ5p2H7HzZTvb06dgYAKWeEaIY4GMYaqQemj42NVp7s5
         SnvAiWkHKgdyhn7MnN8EUanXCgLbPUHM0dzHiENrhqGH1ciJVc/q6ysxI1u0heE/WNKf
         vIpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776320411; x=1776925211;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nf0QCsalo0B1Wg3Ym29TQTIyvRB8LMAG8+6qUgbfobo=;
        b=Q+iIIXCcMrdvbVeynOM611bqUppFLJwabWO8SZmS9//qgiEDsZ+meJJmt3jD4rFpIr
         CMh7plzmS6a28ASjrSeOu7qsHauLiAbmg1Y89wEwabcoUqj4/OK+EY5m0UfuarHpPHph
         gLDc3Ej1kBlPz+PvlmPlfjwE69/1ioKoU707ZiqIXXRIkhg/SvsXlLL+skMnlRm1gOhB
         3pCnGHgQMGEeYdecTHYFmYibKf/ACH2WX+IKuGxPIjATNHJMp0OwxMlubQmg9JUCdruS
         V5ZL+T8tBf9jrvBJ0DGcQwkw8NaSS+2UsKWo1MmudSgEebLMOAYEOW0OolJg3B1drjHg
         HbOg==
X-Gm-Message-State: AOJu0YxjcDBqm6L8TnN12+mlxVl7GbqIU1KuC/1dm/XmcZMNtSfAou4V
	nhFkciQArVRazfS8+taYLUnWYntgYRR0HdNzznZGkU+hVxOq09knnEWy
X-Gm-Gg: AeBDievWdvtdeqqz1p/b7zo/EZluWnQ3TSvs4p162c8E3ZzR7dNfuT2Pc5vaBNavpVB
	bLkHgLezlLxUnBMOM7HPdSWUUVQ3IWLfB6mhtgiz8KeaDTCT7NFUECnYTIkqRfILx+WfXMXI1wb
	iZ/VxHy/72h6EErbpJLaYPPNTDfEaQne8EU+QDcSKqvKVAz5pFBGcQcrWViAJfN4ztPPWGGYBIq
	Val0cR36O6BTILAG7Rr7OO5iHomODX6p6g2oGLboEd+kcKeBHumz+vXcawxhxHO2Vguk9f7U9u4
	LfFQsxF6VnGub42JeJJKyzFommgQZEJHGS1Qcf0HJlDGHtuqAkM6aDJ2jvrHsPD1vQsW/Y/ZJkG
	YjCGUKChm7QmUMQdqwMmY8CBHRp8yyIUzk7g8pNko8s/40tzz0jkOIAGFYMdCLdXD9gTMKsPO8i
	Oi0onZc+3uK273tkoyQ0PoCCR9+b4F49WZ
X-Received: by 2002:a05:6a00:9457:b0:82f:37e3:ae6e with SMTP id d2e1a72fcca58-82f37e3b11fmr14219676b3a.31.1776320411470;
        Wed, 15 Apr 2026 23:20:11 -0700 (PDT)
Received: from xiao.mioffice.cn ([43.224.245.230])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f6cae74dcsm3414971b3a.11.2026.04.15.23.20.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 23:20:10 -0700 (PDT)
From: Xiang Gao <gxxa03070307@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Donet Tom <donettom@linux.ibm.com>,
	Xiang Gao <gaoxiang17@xiaomi.com>
Subject: [PATCH v3] mm/page_alloc: fix spaces used for indentation instead of tabs
Date: Thu, 16 Apr 2026 14:20:06 +0800
Message-Id: <20260416062006.725677-1-gxxa03070307@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: iw3brbagmdifjeq7985zth8zqedjpkkn
X-Rspamd-Queue-Id: D037BC0003
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776320412-501351
X-HE-Meta: U2FsdGVkX1/EbAIEHIFFKK4jpx31AbBaUh+5fE3waV1uztWrYuOfrHF6KLWxLeR5msypQ6IfmcNayOQjmuA34iGFyPVottjmqNoOFEy6XK04hcogjk7RS3r5PRoYo8YM9sWpy1zowE3dQg2tnvh+vZmPrip05h+g/Js3ZS8TCaXcNJgI151KtbV/0n25/pNkg84++KdP1Kn3FtDg4m4c2F/hA86lTFkx+EE0rFhxebWRK1TcLal7eypX4U10fkRN89pGaVFxoGMoVBiAiEneBiWD1PnJGYsxJQindh9p2Yx4PuW0TLW5KaCBFcOtm/H5Ao7cGUxb4DTttwztlsm++NHKhTusDGqII7V1XQcljEGF1RKz+e4Srtt2uryrKRmuv6sx8jZvx/hXYqucgxUJuPKEHQJWPIuF98S6aoeO1VtfBqdqSKo8/xnf0/hSAt6YBJcCpIv3EG+BDhF1/HcMUCutUEx0cg3Dvm42ZF77AK3hJaG7dhKrQXlxGzU7txY0/9mkwS37I6L9g1eCKTZXDkUcxq6UCZ9Gla0kQ4fz11iD9LsryMCpGrgYuHyRYBNfHt7OfNtq3ewEHO6CwDjKxtPGN5nzrEcZU9lVMtnUFQZAxndrRbqkrD3D0bKR2nBSUmvk6kZMhiijdsbmDvMKabCX5T76Tmx5Ew1pDG+FgtMBXl4uC/DWL0XNIlm16umrdZrrc4GvqfxbWbZIovqwH9Kn8C/vAw6uKkIJ+qJ3Qnf0S1nTgpQLuMf/+nqVv2N31VYxAso9g2gbTT0FMPEFrVxuzC67Rs45LiWwJKqoVv907NbAZkEBI+ewz7uT5uLFZ4SsDoPDJMoUABknqhA5u/pFzFi5NHvAWaCmPM7j6JIuIjrxw+EClW+kdOyzc8lEHv/dnQbAUCgSPZDtCrFos14OjYKbseQc0lY0Tzjz0fT7FOl99j3hOZgI16AGWGAcRGI/AXMeCkFsnwKy/do
 ABBJHpTK
 9pAuSxx7AmWwoth5X3J7d7aUthzKKMEDr6DUjtkMIFKqZ4GZo27otN+lt2Mg4ZuqfiVNshQha1AZcB13MwRoPQ/+6/KW9dIajXcK4JzUhsPKxRNA6TsWZCER2xM7k0ebK5IeYTVhfnnJUknV0Zd0a7/wEQSQ0m8jOhM1R2NbttHCMmSIOc5Gx5iyGpziol/NcXk3ElOS3Fv4OoKuy/W7Tt/Khb4t4B+u+HB6Kf6N5W6YTrTFDgOhHgigl9PEMhw2TOMgwSIaRf/cRlDNmOTMtdkISd4Z7gIgPcl7w1ku/rH8kVaynDu3vp2M2sXQw8H1a1O63Kw5MGGLxjKGddLNyESGMUwx3V3p6dycRS2oWdnajcp7/WVfO+hxNXK/oqTlXgreCnTj2es/fWYAbmM4dWf70v+zC7YpyO2ec6ReSNihH/gyBT4xW4yMicwRfuwYLq8IK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Xiang Gao <gaoxiang17@xiaomi.com>

checkpatch.pl reports two indentation errors in page_alloc.c where
spaces are used instead of tabs:

  ERROR: code indent should use tabs where possible
  #887: FILE: mm/page_alloc.c:887:
  +        VM_WARN_ONCE(get_pageblock_migratetype(page) != migratetype,$

  ERROR: code indent should use tabs where possible
  #6626: FILE: mm/page_alloc.c:6626:
  +						         sysctl_min_unmapped_ratio) / 100;$

In __del_page_from_free_list(), the VM_WARN_ONCE at line 887 uses 8
spaces for indentation instead of a tab. The identical VM_WARN_ONCE
calls in __add_to_free_list() and move_to_free_list() both correctly
use a tab.

In setup_min_unmapped_ratio(), the continuation line at 6626 uses 6
tabs + 9 spaces for alignment. Replace the excess spaces with 6 tabs
+ 1 space to correctly align with the opening parenthesis on the
previous line.

Signed-off-by: Xiang Gao <gaoxiang17@xiaomi.com>
Reviewed-by: Donet Tom <donettom@linux.ibm.com>
---
 mm/page_alloc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2d4b6f1a554e..752673a9b43c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -884,7 +884,7 @@ static inline void __del_page_from_free_list(struct page *page, struct zone *zon
 {
 	int nr_pages = 1 << order;
 
-        VM_WARN_ONCE(get_pageblock_migratetype(page) != migratetype,
+	VM_WARN_ONCE(get_pageblock_migratetype(page) != migratetype,
 		     "page type is %d, passed migratetype is %d (nr=%d)\n",
 		     get_pageblock_migratetype(page), migratetype, nr_pages);
 
@@ -6623,7 +6623,7 @@ static void setup_min_unmapped_ratio(void)
 
 	for_each_zone(zone)
 		zone->zone_pgdat->min_unmapped_pages += (zone_managed_pages(zone) *
-						         sysctl_min_unmapped_ratio) / 100;
+						 sysctl_min_unmapped_ratio) / 100;
 }
 
 
-- 
2.34.1


