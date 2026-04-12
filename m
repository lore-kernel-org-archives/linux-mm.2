Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07289E937EF
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 17:54:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32C666B00A0; Sun, 12 Apr 2026 13:54:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3039B6B00A2; Sun, 12 Apr 2026 13:54:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 219226B00A4; Sun, 12 Apr 2026 13:54:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0FA6E6B00A0
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 13:54:47 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 759CE1A074F
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 17:54:46 +0000 (UTC)
X-FDA: 84650654172.15.FBD1B52
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf14.hostedemail.com (Postfix) with ESMTP id B7154100006
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 17:54:44 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FepkDQkV;
	spf=pass (imf14.hostedemail.com: domain of lgs201920130244@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=lgs201920130244@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776016484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=YDfdf5SNMNx3/WAzaXsxgQ2xJAL/YKTWXjEjNPHPnao=;
	b=LpD1UsxY82dOCReE8BsU0z1yYGp9TojU3phJ7Tz1sS1K+17gYZbiAko0sGM0mV29cmOqZN
	ZUmE/aLaepD5H2MOTqNOuhfZ4XYrtlDSMmrc6qeA2Kdcpv76HxwZObgrLSWzoILTi6MDoo
	Z0/eMe3AFnTHTp3qHgqho46PjT7XnjY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FepkDQkV;
	spf=pass (imf14.hostedemail.com: domain of lgs201920130244@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=lgs201920130244@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776016484; a=rsa-sha256;
	cv=none;
	b=c+vu4oMV6FgiARogiGrlRrc51eiY6mcWYOElBtmMSAQTMgtxKD2R0SH789L1T87j4OXcgC
	iutv+8wfQGVm9+Ch7rC8CKIxO1z3rK50t/ZLa963jqcyToD3qHACNiK878y0Xmxq21au3Q
	pYY9ZKMnJysyt91PObIiRyy4eHqBTbg=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2b4583f0a1aso2813895ad.3
        for <linux-mm@kvack.org>; Sun, 12 Apr 2026 10:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776016484; x=1776621284; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YDfdf5SNMNx3/WAzaXsxgQ2xJAL/YKTWXjEjNPHPnao=;
        b=FepkDQkVXeRQkz9RvXdatLmw68VxUWLYLa9TKNo9NCEjXAdk8Dz/Mhq9ZSK2Rru290
         RQoXS7yYwFG8lqx+yh6s7CvG/0O3Ja1tiikyBdmpYg1yclY+OJJqz2GvdjTff8f+VxqI
         UhXy9Pa6J+jkEZeZlnUI2wZKowc48HqoAjmSIKeo868aI07F0wGjIkI8wPgrec9pGsHX
         ZQIZs7dL+yOs3jkHx0qskcE05pkg1xSAVi2jeCMYw2DoLy+qPrslK2xQj84nG5ulFLB0
         3y3JNgjQWBF1ZBdwiJWJJ7JVJB4z2fAk9S0uXn1aweSOMXR89zWiwYzUM6XRXJsTdHBO
         rBKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776016484; x=1776621284;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YDfdf5SNMNx3/WAzaXsxgQ2xJAL/YKTWXjEjNPHPnao=;
        b=N3DYY/1HE9MlScU4b0U/FAcZ6BiaMbqpjcPjZJd59Kwx+HuCa8VtC9jUAHL6d6XJzw
         lJ4D0kRZAvL9BcaRjZt3wZT3oO5Dp8UuRBC/JDJqPc2v1f0jw3S48zoyQJN+aQsM4uu5
         YDpEuzLJ1+BT5tle15iEEwkqIrw/GgBzFn7mcON7TpGlZX+/lh0L0baiui10UdR7L+x2
         aZkRgZrSXh5FYJjZXvF9Ee8d/UtY01kaPxnrhvFhioNgYcJqwVaVSKm+Ude6tykQoWCU
         EJqLffnUyK7cigeGLokGFjabbSXNHj53DCKVyxQWcjlE30+ur5we/l1Iy+tInZLJ3/dw
         NIMw==
X-Forwarded-Encrypted: i=1; AFNElJ/a1LGhSTViLFBYv/K4lgiynNewaotU8Jedeacw0W0kkHYGsjCHvcQcMaXPz4U7ygNb2utXsGG3rQ==@kvack.org
X-Gm-Message-State: AOJu0YzwWmNdRq4/FCyeWgiZy6gzVUCfyBrq9WOl4u20UPN8JVFTRmn8
	hF3ApixtFeREHestJ1+/eQJHexwmOxfh4s187Nb36CFqMhT01jkbdXRM
X-Gm-Gg: AeBDiet6t4H0Iey3LhW3ZSw0+wmcrGeAOabqScrT1SwLRn4gEI76P2YW2sGhMTURdHq
	GAT4Pdz8uarAgz96Lhd+HGWNUtqCC/GKodM2ewBztbub66Xt4vLbcroiY2nj3MEqjGXRbcFf0Nx
	RQktaF9D4qu72PK649BkfbmAg2VOkX3RV5TFzt6onGwXNQeuNHXQ3JUntwwktS5yHqbmTWVwspF
	uiuENx0xhPi1A++XviJC3ktMUGemorVdEMPe2Jg2mUj2B6Cg23+JWxTmCE0+Ye6xdM+BjMXcew7
	VO5QD1SLubuXGxleShxyumNcCeWUAm9UjXFGplPtrPsOs6MiHp0e6rjtdLg/xzTcskuyt/gnd9q
	pfemxdMM1Pal4lvscM5fQ+93T4/T9zKpekxjKfzqXCFtpJqlyCqqPjTcIAM950CINjoOTyDdtCD
	wy//fHnXAKJhFCHIWJAImKKdL6
X-Received: by 2002:a17:902:f642:b0:2b4:5986:cd80 with SMTP id d9443c01a7336-2b45986d953mr20083035ad.26.1776016483595;
        Sun, 12 Apr 2026 10:54:43 -0700 (PDT)
Received: from lgs.. ([2409:893d:1188:142d:6dbb:2e05:75d3:967e])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2d4f25d83sm92119835ad.58.2026.04.12.10.54.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Apr 2026 10:54:42 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] mm: thp: Fix refcount leak in thpsize_create() error path
Date: Mon, 13 Apr 2026 01:54:28 +0800
Message-ID: <20260412175428.2613383-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B7154100006
X-Stat-Signature: cu5xhgfh4775qrydohtseig9nf7o56th
X-Rspamd-Server: rspam06
X-HE-Tag: 1776016484-374318
X-HE-Meta: U2FsdGVkX19L7Zapi6SXQ9k7Q8BRWYzypw4MxhT3bQIC7eE3f8OQ1IO+hNvzetmcOrEWJVQLUAGxqGd2tpmXWHE3ZGvAICutvclRTNDVy1ERzvo/g10PEAgUU8eW6qg1UFXFceGhjuaeSIaVGpoAqxCw/IuKGR8tR/Jpi4MPz//NUuQrzVDDZuOItvAuIGUaurpQ+hQvLxtZS/j1q/ku1OJsC1BGJqnd4E5d0turoiViyDZ0aGpt+g3sa5RrFhea0fEVwxPbW6Eo0ftcYQoFeq9mL9H4pylGyaQ6r6GcaZ4gkwf7i/qZZG5u+80HuQni07e7PpaibYxcGSGfKDgIrgiDTLBu0hQyLmoGyahJy3b9nEkAJQb6/cI5iEUF4leIVIJrCKVuVOzaaD4QO8PONbZ7mZ1ja4TiPFkXDMJozC6C4oQq/j56KOvfwvj7f/iCQhTFkeEU6Aro2OXVKAX1IdrNzkOFuAYztrFDHieDNsLLSxeKNwnJ7dGwJqp5e0k4sWU9FQrqagblGcwgY1et/VHS/2mq0rCfWALhQLCYppDMBnrdzH9vwmF1ECP8Fx0FbrY1TgNhcgz2EMPtLDcxnEzLwVN0tXAMT9PWhyyMONFbbkUYjknYpUkH1XHaOFOecwV99aA7Ryq70w44UrhvKZiJrYs1RmHNYXfhr6Caxv+XrtsLceQaZwajpztqCTSMLKEc+CLzlFOM9HzWRWCIWxGnZmpYtEDhWWUIzpl6kEvheFLCvsNyL/EukdjOSbbHwMKQO9zD64o939s0DM3/cErU2RJfQ55RkOOMNwsKjdUc+W3Ri/DYPOx3ATCuVZ/GfeSxxMLOZEQ98gT7IsEv2MK/d1KTbBOrA7vyc2nBNheiG326SV6AsCZWXcbNU3OX82BwMfpUmKeWZTFF7j9BDHfZR8g+OzunpW8ilgMS7Gs7v3Sz/+HF+fsrpdNTWDobHBY1WAWelRgG+xEQvFV
 8gkN0W1W
 6FjW/hcneoZcC4Uj+0TiFnmYI/q0sbxZtbSGJ9lsfHaptnK4AAX0jub4/yybAD/sdZjCigPqwsypLoYTx6FFRXbSm+hy1A6M9dHHNyGUGC8fGHaZJbM+xR8kpyFJLnVzCrYmJz469wn3FaZbOoGTjYzykaNxJ7ZGH5jMCs1euPfviNuxrc4ydWgVaSipWEZRHxzJAiXLFnRDbTHm5JKKFyH0W4+Jr09rzXb78BL2PBUnPx1RUbd/Ub+7XxGyvf1FE4jEwff2adP2//OZCLJrtH3JjsWP0fpd/UCQ5eWbtVei83B/NbgUiW1VkJ9Amt6Mi9rdfRXdxLbqrqFajI1YCWkbABfOnVr9BCDt1IcV5PMnB5wvnRafXld4BMtRimnbic2q5Hagfq807i8W3oFkVQXgP5yT0sbYwKZiAKbyUbUZ8sHIDhPxceRseEYxNhWZ3NEX9DGiZY9zl9g8nFLMfEu4kz0KlCrGq5fU2nAgJCgLHYqHmVYSwHKrHAw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After kobject_init_and_add(), the lifetime of the embedded struct
kobject is expected to be managed through the kobject core reference
counting.

In thpsize_create(), if kobject_init_and_add() fails, thpsize is freed
directly with kfree() rather than releasing the kobject reference with
kobject_put(). This may leave the reference count of the embedded struct
kobject unbalanced, resulting in a refcount leak.

Fix this by using kobject_put(&thpsize->kobj) in the failure path and
letting thpsize_release() handle the final cleanup.

Fixes: 3485b88390b0 ("mm: thp: introduce multi-size THP sysfs interface")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
v2:
  - Drop the incorrect UAF mention from the commit message
  - Clarify that the bug is an unbalanced kobject reference in the
  - kobject_init_and_add() failure path

 mm/huge_memory.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 40cf59301c21..c8ffa188a198 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -726,10 +726,8 @@ static struct thpsize *thpsize_create(int order, struct kobject *parent)
 
 	ret = kobject_init_and_add(&thpsize->kobj, &thpsize_ktype, parent,
 				   "hugepages-%lukB", size);
-	if (ret) {
-		kfree(thpsize);
+	if (ret)
 		goto err;
-	}
 
 
 	ret = sysfs_add_group(&thpsize->kobj, &any_ctrl_attr_grp);
-- 
2.43.0


