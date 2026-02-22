Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B509BC624D2
	for <linux-mm@archiver.kernel.org>; Sun, 22 Feb 2026 08:49:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 169886B0096; Sun, 22 Feb 2026 03:49:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11E306B0098; Sun, 22 Feb 2026 03:49:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F175A6B0099; Sun, 22 Feb 2026 03:49:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E08506B0096
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 03:49:24 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1C0221C5FD
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 08:49:24 +0000 (UTC)
X-FDA: 84471468648.09.607708D
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf27.hostedemail.com (Postfix) with ESMTP id 559E740011
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 08:49:22 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=sdSepJ2n;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.45 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771750162; a=rsa-sha256;
	cv=none;
	b=R4JdyHk4AEGxIcpcQr/3uvZJQ/GF3jfVY9IZi8H3CKnK010razUZWYhovhPoG3k3pk0p6y
	UcjDlwpEw9WhabUD/X5TWyJmNKid+xH5OIaqSo+0BjI8jgALSRv7ejEw/lgqY8YqtLplwq
	8jiEVANVRv/5Yjel58C21PV1cr1sZok=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=sdSepJ2n;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.45 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771750162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RDpP2syoLUpQf1rGH2VYZ/yb+Dz8+coRcRrod2PSFvg=;
	b=3bjGIGB8R7VENgoDP2HXmGUhRn1JqH9ttuCXUJDksy74p+CkHe6eHj0IDfhEY2LBNKIuLi
	07W0skVFQDuYPhLwzOE/aUZesqY3GZ2rK/TQKYdWUa36P37BzDRy1HyEzwlmRgBlplI5It
	yp5RjGaI3Gdu/VreWqSC5K+LfhAogd8=
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-896f82e5961so50666786d6.0
        for <linux-mm@kvack.org>; Sun, 22 Feb 2026 00:49:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1771750161; x=1772354961; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RDpP2syoLUpQf1rGH2VYZ/yb+Dz8+coRcRrod2PSFvg=;
        b=sdSepJ2nIVh7gRB3yE4KDrCnoWhdc5bs6/7almWoLQOj0GJUH9hobf/pQrQcf6CGej
         D41UCdt9HBlARIy7iouWOnoWZwFL2g8gsTHXQB8fLn1TR0sIg8tBqU2l9NGqdefx+F+W
         8li/7UkQtUye7FEOpAPa3CGrjGSR5WqSr2yjTeCC7l82fOV35sGh5ObW+Y+lccVFElyF
         1zLz7HIBc9Yhhzl+CZNDbYdJYvaVKL+GG09gESfBDX2+UVmMZSDpefOwb/9LRJmLise0
         /WtQbpFgexu4RTHlST4vsqJvrmlr07cj2BAsZJWT+DNTann1R91glxIcSKiMoOLQdF58
         R/pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771750161; x=1772354961;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RDpP2syoLUpQf1rGH2VYZ/yb+Dz8+coRcRrod2PSFvg=;
        b=kzxUoWCilGBkTcMuq1bM58/jhVGzv9R9Oo1xS5GFg6mYDrSqSQcnxap85J7ruyDgzp
         IDZ3cXnPbFymCBJ1mY/YGExqLnu2/kmqWtqsomF6xrkxlRpk/OXWWQAkZqVd1w5kXKkZ
         E1D0ssHthUjYKXQouBOy3FQZ9fpYp2gKE5FqXJ53WfvFepyW7LkcxxbalY61srVQH6qs
         Q26fxjmNCsBxWXin/9+/IxnTPtCC8jSKU496qVXn2qi73BFr869OhcQMJTHm13MT32qT
         iAtmFY/nqQ1+sc+/8vWmwLvLy4st29igmFe+dBQe17uAkwgnqfQX7abO1BLXESAAoAWa
         eeQw==
X-Forwarded-Encrypted: i=1; AJvYcCWy6+fzxOnRcipMuSxzRcYE9AeiSRsehLwEZSTRbRGndrQuJbni1vx20ndSY7uIcvDp1r1l3jGyZw==@kvack.org
X-Gm-Message-State: AOJu0Yxoe6kbP17vlkTY3wu90Gba+D4vDx06lNyE2m/6Kh3EiBiLbBnM
	D4mzRNkt+wpwz+lvurahPdqURFto6Rzm39ArDwce34Kfjb23kDAGRV2+Jv4/ZulCnAc=
X-Gm-Gg: AZuq6aIrqvvUwCCSKUK3ZdHzvRzWxnxtMPzjQKcvrySkTAGftrGnP3ppQHW4W+fMTS0
	YwJoiNfi9yctYNdhkVRSOfeN7tFSYmKb6cqUGKI5DSA5nDeSzMvY7t7Xxbgoj9HMhmNpgA9YDgf
	dOXccuLrLtsv9gNpT2GPVsbTtgHi3PIOkrhR6mCzkj/LHnIzkCKuUOh3jwO7J+koUFx6aT/DcO1
	ky7K0MZ+5y9WOz4jkVcFftG2CeIfXnPMABYGe4PGaZvhLDrUi1bXVgHIRS+hurIoSy24bFlRrlO
	hsESkfvQ06vcQxF4QOLjf2eZYWG70/LdT7dRossMSw6b0rRoJWptd0/ofD2TQp9JAbvot0w/3y/
	CZ4SQAnJL5Me7+HuyUEvFAuGg9i8aNJfCh/d6xRbJ4KJpfWmF+2HzT0AxaiwT+owaoPPpuGD/gE
	udBiaVsI5T7UKdcv9yMQaMNaWEY2zGR0Fi2GQ37VXJZknh3DsYMDdQ/jQ0AW4jzMkTOhlXio7DC
	aqqDRoxhsBtuU/O7d6HJTvNQQ==
X-Received: by 2002:a05:6214:c4b:b0:87f:fecf:17b2 with SMTP id 6a1803df08f44-89979db90eamr79397046d6.64.1771750161345;
        Sun, 22 Feb 2026 00:49:21 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5070d53f0fcsm38640631cf.9.2026.02.22.00.49.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Feb 2026 00:49:20 -0800 (PST)
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
Subject: [RFC PATCH v4 07/27] mm/madvise: skip madvise for managed-memory folios
Date: Sun, 22 Feb 2026 03:48:22 -0500
Message-ID: <20260222084842.1824063-8-gourry@gourry.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260222084842.1824063-1-gourry@gourry.net>
References: <20260222084842.1824063-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 559E740011
X-Stat-Signature: p8csxdw3coc8f45rzq4xbb7zh73m4zfw
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771750162-336877
X-HE-Meta: U2FsdGVkX1/BoMIk1r0+1uIEGaOALrs7vJcG9LF9/7WuyHvBV3MDT1+5zsvxqhN0z3P72xa4fe5rZCh8AAmQ2vMR2horQ1+9AZmfqTIeuvZO8RWjqNb+vW//Pb8WIG2EmEjZzV4irmQfEYL67iZbczP/efNM6jhYrz6pv3yw+rxvJDTwyQZehc+4YeAu2ztBbNZMKH2JcMJb8noZ+QacW7sP1wIKYeXRPUbZ6FQ+ZBCClDRHqUaGxj+lFp7nGqP4rQ0fNVJeRYGiqZ+brlMbOqQmcw9imPK09dhayZRbWbZZPT1AMQXFUa+GFBgEygOV8BDvsggieYpTIyffYRKFUlr8q3rP9gcO8wTRBAu7hha0JCbItFYtlhFugLdUyGcraJQGkDRi+Hh2Znn7cgxjPBy5W7oc1SbzEkmTdMxmFqPv8bqK2TzAzrUVTvjQC8ZfxV7XTgDYO+BY1CRIrUWet9IapozkxmrUYgsJ7FAnI7jQkKNFwUKfhDvmTYQmQ3SaEPspL1EnBJU+2nmBvT3mA/Nw+6nwr3+gwEJd/oSMIhflLRKVxbGjyyMtU//5q0ME6p7ILQ0sLzlJ/WcpIbCqSp1O5mYQggE9LzWyS3wUnOLfPH29JyJXaKvO4c2D7Ihb4H61htJ5LPzdaIggq58jSuSrNDMvYaV76pliA9okVdwWw/u/25HRjj716b4vpHtv9o+WS0py4IjXTlrVkA4v/vgEjS0b3fyY0EefT2yokZZdFG7VUJ9MYYEf/pwNzo3r/mMowgIH25klatBHj6t8Iv4uEaz9johijB82buoxVLpTlBSKXgG6Ba931CVGQm8C0IOYw5T4YD0+PZJkrWzZTp0c10tc1uGDqwBRlKALZ8odWDr++fGudleb1DZDwHUCzKM3WC4lLGcGRE4beHK8wF6lBmo1ImP3VLMLGQPCll6uWko4zHyw1qQw459WKIB60iPXcanI5sQfcalKToD
 +auVP18p
 +EEQDVifTah65y8GItEeJYbKZlOUepfX4sk4M/Pzh5P+a2Pgk5AcM36fSEXMKQUyPd4/fUnR3ZnogFT6BYlIK96KBP2ZUFnVMpCivRWDOFHHUseuv13TOVPjgGufqDkWJ84iYPJ5j1djFoXGLcE8PzC6pz5o6NhZa1N8oXerL7RYostl/llPQDaCoar1Pj0tS9Qari/qCzH0EjkQcOTBxMHs81M4wTmzLO3JOCiKVisDBYiVn+5+J2V4hcEA7Lbi2gD9jJvV9g9gxykfN4uShHZr9HCkRQEupjwQkMV9tQZ+1KJQ+DmKxGFnPFWjV4moeBBRJ1xojxSxy0buWCGWb2GUM6gEzF6RnE35MQzt+XFrL5xQ9lgiVDKcU/+wMlgWvN+gAmD0dKYrtCfdwPBw32bpWPSCDxK2pl9hl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Private node folios are managed by device drivers and should not be
subjectto madvise cold/pageout/free operations that would interfere
with the driver's memory management.

Extend the existing zone_device check to cover private nodes.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/madvise.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index b617b1be0f53..3aac105e840b 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -32,6 +32,7 @@
 #include <linux/leafops.h>
 #include <linux/shmem_fs.h>
 #include <linux/mmu_notifier.h>
+#include <linux/node_private.h>
 
 #include <asm/tlb.h>
 
@@ -475,7 +476,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 			continue;
 
 		folio = vm_normal_folio(vma, addr, ptent);
-		if (!folio || folio_is_zone_device(folio))
+		if (!folio || unlikely(folio_is_private_managed(folio)))
 			continue;
 
 		/*
@@ -704,7 +705,7 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
 		}
 
 		folio = vm_normal_folio(vma, addr, ptent);
-		if (!folio || folio_is_zone_device(folio))
+		if (!folio || unlikely(folio_is_private_managed(folio)))
 			continue;
 
 		/*
-- 
2.53.0


