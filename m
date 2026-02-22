Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 984CFC624D2
	for <linux-mm@archiver.kernel.org>; Sun, 22 Feb 2026 08:49:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0205C6B0095; Sun, 22 Feb 2026 03:49:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F410E6B0096; Sun, 22 Feb 2026 03:49:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E228E6B0098; Sun, 22 Feb 2026 03:49:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CBE2F6B0095
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 03:49:20 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 93EB2B9C0B
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 08:49:20 +0000 (UTC)
X-FDA: 84471468480.21.2FCE6AC
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf18.hostedemail.com (Postfix) with ESMTP id C751D1C0012
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 08:49:18 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="iA/4uN43";
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771750158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PN2sy4KwpOgCvYV+YZxAOK9yTs+OHW6J8ZgmY0xzRNk=;
	b=FGat/lqRPmJa2M8HE8LMok+4VhmcrMaF7Eu4hVmN+NQETROQE4ZdiEuP0mUX+He5XJzQM5
	NJf/qVScc472PNecGnJNfIStWOcvAfGXOJU4Sq7NTsUb/Oiy89co2tBjDQnvCQMPXkzoDz
	/BVjairo7KO0K637J3wId5SSPLBU10o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771750158; a=rsa-sha256;
	cv=none;
	b=OgrScdYJHQ6abwvXGvGCoF4BqH0nw2yJS85zlSb/ydEMSBlDUJud4Eo8X7Z7TFjuSyczSS
	kdPxejGxBeyvQLxckPTyEEIupQMkp7k6T51o8cEWmH5e3kLrO5CAwMTPpzo7chgcgy5I6g
	RkKtfX/kXiQtgefCDrm7dMvM+Vj7GV0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="iA/4uN43";
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-506c02ec1b3so37405081cf.0
        for <linux-mm@kvack.org>; Sun, 22 Feb 2026 00:49:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1771750158; x=1772354958; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PN2sy4KwpOgCvYV+YZxAOK9yTs+OHW6J8ZgmY0xzRNk=;
        b=iA/4uN43uGkbHwAcGKoNqCWFEx4x83yz2khYvrR+nq6Yhau0hgM3TT2OQ1ig1DOnha
         miCGbWdB12h5uvUHvsMsKDLwySzF8hUXLzqxkgOtNiVVrwfqnJ08Z0JMi62jRPfms0Xx
         jGgRoQx4yht7LJEZnAACFsVoxNahyd3xc5sQwXNeSzkMIQF2Hlnsavu06M13vHu9CAiQ
         XlHIwhn1tBnSbF+J1k597+uWM+afwTvsaoiVGUtLSwjd79cVa8KcOtL5mbgiLF+vwB/j
         mSVR5xmvdjijBcjTeF/VvbcxeN9eUl2CJBtt+iXD2XbPhCQ5kV1KtqGNZSECJ1te2sws
         DAAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771750158; x=1772354958;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PN2sy4KwpOgCvYV+YZxAOK9yTs+OHW6J8ZgmY0xzRNk=;
        b=FxO36JYv7MATL9sMtjg3Q3zD5HbzTMq+4zr899WPsqRgJ0lDc7chto/yvLa4TyaB7r
         /a81WOkbTtyVGs5H9sosY7Dox/rjSeyX721NkYz4BlmgNwMAM0rzLkJHCJwNp1vPfw+x
         m8ChIafUX/FNe9r0CVxJKjhwrUcmENJ14kGLXFyml/HMKMzVbgJUgvNzI7caYvFI8VS0
         jzUKG0hIL7E79U6H33r/MgSRj8yeG4XMWNVCDrAGAPlVmpGmAPr6KCZhgDBqgu28Lcc7
         /EiU3ARBGH/wN5lSbK/jRb5TKtLGPs3uQAtMp/N7W8HrZ8OS68xoHQAEBvC4lzL4LRxz
         KJrQ==
X-Forwarded-Encrypted: i=1; AJvYcCUPu9kGczYlBTW17DR4P54YHe+xzEpv+Ivyijr7y+fAerepvZBFPvQ/J6/0s9jdpWCbk7gS7mSOYw==@kvack.org
X-Gm-Message-State: AOJu0YwKrvBWQ9bdGovfDu/gzcLF0B71wdUyqROjAm6Q8doPSowbakkD
	mW+F/0jOtoUEf/dB0yxZsacxLF24H31FC3iz+2fI4OYSqvh7VA9BbbphWt40Hj7Md9U=
X-Gm-Gg: AZuq6aKtQc7UfHxl4US/ngNh3CBvA9cAxJoaRQRQpBnujOYxteL0Esj1SxS6KztQRlM
	zRoxpT+tozBPuaVAWd6xeIbuRrL72fbxFT4G9cxhKtkWDb3dmgalN/j927fAlU6h1nqfvZ9A8zZ
	RAddHbtYIRA/6Lq/oyRLwqTfBUU+5l0bXNpucRM0U5Oaq8eCsh4E0fbOvMsid2U1KeSTUViJlrs
	6NoNxYMQDG2Y0rA6WntZHTZQSe7s+qTsb2AU14DwNe15FZya5tmHuKnm5HF8rIC4LwG73QedsMY
	ciinkuobTN9QPQNmm2C2NfwsrHvixfs2tS2KzUPV9vwxNsvXWdQCmCoIORVwryDzF2/ax5ZlHBe
	D1AAuYVEaHk8oC1vAfgezMb+mM2zLiMjbbFaQKsY8LJ/GBPGEtCLrv91fyGtrkmH2JT4lAGljN1
	QaFF0ZXt9dBTu/Tsp2Y9AzpZmdgOhaYDKNWMe/zNhYec8VsSu4HdMSR6XbhM6Hr39mdxl/B1PZc
	hMwUsLEBv059p0=
X-Received: by 2002:a05:622a:201:b0:4ee:232e:4950 with SMTP id d75a77b69052e-5070bf3bb60mr62117601cf.8.1771750157802;
        Sun, 22 Feb 2026 00:49:17 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5070d53f0fcsm38640631cf.9.2026.02.22.00.49.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Feb 2026 00:49:16 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: lsf-pc@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	longman@redhat.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	osalvador@suse.de,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	jackmanb@google.com,
	sj@kernel.org,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	muchun.song@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	jannh@google.com,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	pfalcato@suse.de,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	riel@surriel.com,
	harry.yoo@oracle.com,
	cl@gentwo.org,
	roman.gushchin@linux.dev,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	zhengqi.arch@bytedance.com,
	terry.bowman@amd.com
Subject: [RFC PATCH v4 06/27] mm/mlock: skip mlock for managed-memory folios
Date: Sun, 22 Feb 2026 03:48:21 -0500
Message-ID: <20260222084842.1824063-7-gourry@gourry.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260222084842.1824063-1-gourry@gourry.net>
References: <20260222084842.1824063-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: zfodeunecexwq5dmy48cn8infdnf5hy1
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C751D1C0012
X-HE-Tag: 1771750158-251802
X-HE-Meta: U2FsdGVkX18BuIqWrAEUw3fvnpV9vDOzjEtVgq8DJY12NNRtMOTB1kRwksFPocdCl/CDzJSgi/TzK11D6tnOOnptGY8fcejKUKH5ClGRXpR2/WYFOAeVrxMah5kfLvhV13dEBQh+LpxtQPX+Dklz5YDiicyApy2O8Mko21fxkQciPk8W5vfLkiaI9M5VbJ7+NulM6Mg86XHaLwoxBDEL/yXGw95IzkbI9ZuDPT3zXr5NVlRNbusBsF0cOnLiYaIa9G5BaVx5nHbAOXgZTpJ3Y+p9VXG5MlygiGbFFyPzt/DRFaGzsgi8AqMMgs9h6Bxiybj9uEDIlFFVY02AAtTlnwUkfKTMVufsDvUG7yaiTBvx791+zHh+4x60F3Q21eaCc4NushN2JrYqysKw9xb2Y8c5UgOYukyNFv93TyS6B+mAWFE2SSEKFb73QY4AHdr6LJZ1Y3Pww7ewKYSJ/A8KlTHGI0USCIz3d7uMLzAvnPydQbROkMKqMJdHt3zrlrb8Ih8SZew6QyjtI23NRT3TXf7mtTaCaDZWL3hqiitjfgB4aIlMeT+xPJlFki5cd3hTAk9EwUgbjceF6lM0hy4XWrUMIaBvwQpwzGbZkZSGRf/CGohQVmx3d8CLgLR0k+oiLoT+R0AokInwBmo79s63mGyGvjwYu1X5Xik/sGfes60R2adqVHrZdpJn8JfmyT/+DsS2x3Ek71gP10aGOQytQ3HUliTvDF2FmsylqzWZX5eq3Weu5Vn8BMAiuCT14TjeF11oU28wsKPw7JWDH6mwSf0pQed3cWOoIXPqszEBQiMTpyjbDMZc9cl083NdGb4D7/DqQ7BwA1ufjsyFS11+alpYHm36vmCqfvIiWoeWAC+QYpNzu6TYoj8wgQKQJUs//j/ajv3m153g8eixIYQcy5Z+yRi8HOMPNOKCKMDfKe2sKJIPtOmZ4A89AbHjBOEgSFGuQQc36zkMqh96hAS
 bzjNByz2
 dHDIOgw00gbgmggujl4WOjYJfYl/xXGdPW99seNVH3B3VRUoRUqvt03oZ2Gi+i4YD3hXEQLLBKjZmoa7+Yl0uLPrqVfbfmUC1Z8SPb9DfI25Tmm/EYfZDquFWfBcelcJ88OG4R4mppfC9Ca0eQcSmI4pOe+OavxrtXuEt54PpKhi+rttP63jQD0UQhxtiBifO/9apq0NZldOCedNxMFvB8/TeF+p+kHbpxXkvEb5JJCsqu1vF9gNUBvth36cCeC0u40v1aZ3A+1ScTGdp0kWTOs1W4vq0KHEdvjFLzrsAB1PcrvOg4YB2b3kK88pvrYq0GfUl1Lu7Wx9rGaRIK41jp0OU5A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Private node folios are managed by device drivers and should not be
mlocked.  The existing folio_is_zone_device check is already correctly
placed to handle this - simply extend it for private nodes.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/mlock.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/mlock.c b/mm/mlock.c
index 2f699c3497a5..c56159253e45 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -25,6 +25,7 @@
 #include <linux/memcontrol.h>
 #include <linux/mm_inline.h>
 #include <linux/secretmem.h>
+#include <linux/node_private.h>
 
 #include "internal.h"
 
@@ -366,7 +367,7 @@ static int mlock_pte_range(pmd_t *pmd, unsigned long addr,
 		if (is_huge_zero_pmd(*pmd))
 			goto out;
 		folio = pmd_folio(*pmd);
-		if (folio_is_zone_device(folio))
+		if (unlikely(folio_is_private_managed(folio)))
 			goto out;
 		if (vma->vm_flags & VM_LOCKED)
 			mlock_folio(folio);
@@ -386,7 +387,7 @@ static int mlock_pte_range(pmd_t *pmd, unsigned long addr,
 		if (!pte_present(ptent))
 			continue;
 		folio = vm_normal_folio(vma, addr, ptent);
-		if (!folio || folio_is_zone_device(folio))
+		if (!folio || unlikely(folio_is_private_managed(folio)))
 			continue;
 
 		step = folio_mlock_step(folio, pte, addr, end);
-- 
2.53.0


