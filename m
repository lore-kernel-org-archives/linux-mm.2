Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97C89EA7959
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 03:31:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4BC56B0093; Wed,  4 Feb 2026 22:31:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF91D6B0096; Wed,  4 Feb 2026 22:31:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF8046B0098; Wed,  4 Feb 2026 22:31:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AD0E56B0093
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 22:31:21 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4EE85C1827
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 03:31:21 +0000 (UTC)
X-FDA: 84408977562.22.95E7200
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9CB93A0004
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 03:31:19 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iPPgsWh3;
	spf=pass (imf15.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770262279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=vaaXsJL5AGetw98gAbGYxxD6vHawDzL3XjdFErrz8Eo=;
	b=cCn0H6Elmqvs9njHjDQRdGtqgittpD6P7hguvsk+o4Oz2EtWScFdCPsMiZk2E8rhSKC+gw
	htNmJwftwgqjF/Fh7E+8Z2a0OG4iAsM07tZwkIuRHDaeC/qNZ96/nVvJPfJGHNDsOA4yL7
	5JXwkPcXvIcu6RlRVj0y8ac3VwQJ8mo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iPPgsWh3;
	spf=pass (imf15.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770262279; a=rsa-sha256;
	cv=none;
	b=vqdI9jcK/Hq9EC+J8yNH8+HYsn7nzJqXqwSwZ15pl//jsqdW0gklBIMItbgBLfVOdkVz00
	Lk1w2QqbUEq6ZK931VjUyYJBie1erY99GhR63SXJbb8aqY1HWn51Meurtw7gLdbToDqlno
	9lBU8F1EqVh6R7DhFOycDA9FlYJe7Uc=
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b885e8c679bso69487366b.1
        for <linux-mm@kvack.org>; Wed, 04 Feb 2026 19:31:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770262278; x=1770867078; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vaaXsJL5AGetw98gAbGYxxD6vHawDzL3XjdFErrz8Eo=;
        b=iPPgsWh3gCT5VsSXEqGKDaaAIFWrG07FsqXCh/8UUVc85wu9iw+O0y2ryyg4GVZYOL
         SBSIElOR5jqvrljyamaT5jQZrNujtXtuLQisTy6IWtCpKNOyBIO9bebGnFpFNz7aOnxA
         nMu2ec1/7oLhQVVoPkeHPzfDsmT2bJ1cH5CLCOSnc1ru8GM+WtZGL8NGJpVlu2smO3EU
         x2y8lhdSMdfpj+W+qZUiSE899QTkt1idR5d4NU3/qAPjYY+AxX9xsCjB/O/TOO+Az0IJ
         +h0b7h4tDXHYGIOvJCgnMEqtWwJkgQM29dL5ZBp+7iAThIvpAOaO/QlHUaLKKi5jYl83
         pG2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770262278; x=1770867078;
        h=message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vaaXsJL5AGetw98gAbGYxxD6vHawDzL3XjdFErrz8Eo=;
        b=qghd+ww9ybVRCK/WeEo/MJsfaexE3QPjkkSsmrxVmobav9sSrYCrBLTM3OG+VTWMOO
         EO2M/ChFDhpM67oqDbvE1j488/6gqhPL0J8Fs7diZ1P5BUIP3iemn8zWymVg9ixT9ubK
         mLURWdLs1X5phDfvXJaau8jVAhlHxhqJZE3/sVFpEyDcxiT1gm94bztCk6DnW1FX2nrh
         tDVwyIdOCia9ovM7e+atSETvivKYpy/paUkimNnKfMfEXJQXKvOrCHvNV67MH5ipmCTb
         nw8q7QZAlkL5e0iK20snxiDS6kIJ0oeexhBiMGPwCfvWp8R0rFWEuFfENP4JuBK9eWUW
         24Aw==
X-Gm-Message-State: AOJu0YxDmcarKUwe3s/pHavDkqeUodEH4t2soTTYx1j+g9J73/GAc6sC
	z9TED36X8oFhH9kX4URNA5CDE9m+VcC1jq9wYk4FYKqjfu9ipMPnnIbP
X-Gm-Gg: AZuq6aIzgqmOzu6zXNkYGNuoxdgTY5+L0GECGg1HTULWqfzeh9SYTm7Qoz19978ON0A
	qGrprixHcnMYduRp1ukobp3SQDq16InwYi+K11x9AqT6zzmcXhDYvK7VChJYceShb3T9NvLz5wa
	hKb42SiJvz1bwVaFK7Gvcox3nHpBXGP0tQVVM+LCSwbAWNGLKamIye4cEvPmcf5pgaIvdMyQWE1
	M8mOzE1SScDLIsalthquh9MgXHkoXl33RHr1V/06YJqlp8Ujxta3zrQ5JoZaItEP7VttYLsF8y9
	vikYGduBrJEYsW+HtqHmVXvF2s9MPDHjTyZNGvRzVABV8G2B70tCoSuDDPPkVq+qtnlZDggG/7+
	S6fhGEszYxKgGQj1cGAZBCGEzCiLKWtvnvPGmxrAJNp+WFadkqedhrem5Xq+1MN7tQLTMn3Dn57
	sg43AUWjkw8w==
X-Received: by 2002:a17:907:72c7:b0:b88:5385:59d7 with SMTP id a640c23a62f3a-b8e9f04c9c1mr375893466b.4.1770262277573;
        Wed, 04 Feb 2026 19:31:17 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8ea00455adsm186412066b.60.2026.02.04.19.31.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 04 Feb 2026 19:31:16 -0800 (PST)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	riel@surriel.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	harry.yoo@oracle.com,
	jannh@google.com,
	gavinguo@igalia.com,
	baolin.wang@linux.alibaba.com,
	ziy@nvidia.com
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>,
	Lance Yang <lance.yang@linux.dev>,
	stable@vger.kernel.org
Subject: [Patch v3] mm/huge_memory: fix early failure try_to_migrate() when split huge pmd for shared thp
Date: Thu,  5 Feb 2026 03:31:13 +0000
Message-Id: <20260205033113.30724-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9CB93A0004
X-Stat-Signature: 6ht3qsznzowmzjnsxi1em7ukzdu5odwk
X-Rspam-User: 
X-HE-Tag: 1770262279-846684
X-HE-Meta: U2FsdGVkX1+Hh0jK7IlVVZp3ADGNkoJYI7013O3MxWbrl9PD9RBX7VJYDl18TmRQ+1fP5/zoR7Sfb6vHAATjmtyvfJhtjWRYDHFOx99/2wo52hkYsaLwymbbw548RKG+ZViZwtWCz+I88DpVb+hSTyRt5XwTEUzpb9+JA8NwiTvLeg8ZYwGOq7JHgzM855gTvgebJYpYGfDaw13eDYBlruy4GKWunebhl6glSACW3Au3Y3OAiRJQRHIAjwoPIEKlsCXsDN5adTOGoD/V/SCZIVfnLuzHfJ0purSZp4jPXM2nBOiD9bId14XvZ8YFw079yq3eHGG09gpYUXmTRM27mqySH04AF9XOp8j2hJDTDp/FKamZM21O3A5oGctkJyvzjrkNRxw28KurqTdkwPZIQS5S5pGVJEWUkRoI+m72uEL8GCQyifA9P67ivAYSpBaYO4T/yQDX7UsmmdyzADTqUXU/mL65UIp2yoykzD2CgMM9APdM6g9ch634eXkZkt0uP7GYnztrvf0NYxpon4lpzWIFT+Auu1dpp493YB9jat7kODS1yeK3+SO8K7vtAcJG99GJIeMTC8jgMboN2As4S0wkAYyc80kxlCLQ05CC1NTFSXzSK88F4fgLwYqBoggbRZi53e8SHgODwvjm17wHvXMd4Ly05Xrx2Bb/x5/zeGwWtVtLtgv69G3EafjmdcK03WJxQF6uSEwQHVZls1wnNHJxi3nmKQAQmsvCJ0YgLbu15Xy5Lv4Ig066ZOPUilkJN+UOnBWOByz3yhFljSuKD90hej5zeuRJzMUowlgntrHBOtU93oiH+9sjRvbt9yCmSQuZ0PctoYJTGeHUFs1QTDoz/nzPeXduxUHN5p25hAOyr8PsDZandWlK2YPmJcnkfFXNp7J5ptmjVbzV3qAQOBE4q1pbml0k4nfQlLyNzOEl9KLL2pBaHXJchjOgsouNWMdRvnckId/1qBKe9O0
 ZZbUL0Ua
 ihsJJkqqNCQo02nW4peByDIpmkHs1MwtB1/Jeo7W2z5lIkpRDW1jipTxhX31rD7YjBc4Y4g8eExsYBcGCO+f0a0H3jR085vee//UotxRrHRkECfw7JpcMtZp2Laq++4ilJqfo79GCVLjFb2RaXGsI0FQN01lLgXrukiI/2/1zBEf8dmk/GnIFOu0pqe0aMlV4XfgvqcrtXNZqDEofQEzHZwcnPMqquVv3dqkD190xbLh+2yh/CbeJhLqfRy+3YddGeJiVnCibMej8pH61seGnZ9VojQ092HkE+KyC8EI8txHGRF18WV4/8NxD1aeNc3UQmrYu7+CEL8fUonHLX2vPj/p9/prgFnkFIpQpgsjWHWkl/7s+PDxJAcOhPFT38Qlq2GaKYMuk8IHjABbkQtMzdtJcNeH+BthbXqZ6Srdt+wIzp1edgEW7N3hHJtKh8cHOTpi3fCx8X8JLHKlA+9PkdfuVZGx8zMOYVANdGEuEHsdBM1IZcRja7vAGN71dLw6V9ziB8n7DkaG9khIYKpR4OnH6SuHK27gtLqX+4cwHR5j9SSYLsen4Wk3j5h8ytYGQAAvAHSoiQo4njXTqp1SPbTmFk6DZjB0bIsZEUJ2bYgl3lug4gu4xE/RdT2HDGGJeJ+RcEWLhfvYtIqywhFMaMVNf60OqsdrLmMB3qrLBn3WrL7bh3KOZb+fgJpQoTeld8aBYOt+yKbiEyPKF0R5qkaD5qngxnq8MguipRchKJb+uVv+QmGhkr6UBhw4b/wqmDzp+DJU2hMCgbqDTPeAxpm72l2GqfI8aOtXH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one() and
split_huge_pmd_locked()") return false unconditionally after
split_huge_pmd_locked() which may fail early during try_to_migrate() for
shared thp. This will lead to unexpected folio split failure.

One way to reproduce:

    Create an anonymous thp range and fork 512 children, so we have a
    thp shared mapped in 513 processes. Then trigger folio split with
    /sys/kernel/debug/split_huge_pages debugfs to split the thp folio to
    order 0.

Without the above commit, we can successfully split to order 0.
With the above commit, the folio is still a large folio.

The reason is the above commit return false after split pmd
unconditionally in the first process and break try_to_migrate().

On memory pressure or failure, we would try to reclaim unused memory or
limit bad memory after folio split. If failed to split it, we will leave
some more memory unusable than expected.

The tricky thing in above reproduce method is current debugfs interface
leverage function split_huge_pages_pid(), which will iterate the whole
pmd range and do folio split on each base page address. This means it
will try 512 times, and each time split one pmd from pmd mapped to pte
mapped thp. If there are less than 512 shared mapped process,
the folio is still split successfully at last. But in real world, we
usually try it for once.

This patch fixes this by restart page_vma_mapped_walk() after
split_huge_pmd_locked(). We cannot simply return "true" to fix the
problem, as that would affect another case:
split_huge_pmd_locked()->folio_try_share_anon_rmap_pmd() can failed and
leave the folio mapped through PTEs; we would return "true" from
try_to_migrate_one() in that case as well. While that is mostly
harmless, we could end up walking the rmap, wasting some cycles.

Fixes: 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one() and split_huge_pmd_locked()")
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Tested-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Gavin Guo <gavinguo@igalia.com>
Acked-by: David Hildenbrand (arm) <david@kernel.org>
Cc: Gavin Guo <gavinguo@igalia.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: <stable@vger.kernel.org>

---
v3:
  * gather RB
  * adjust the commit log and comment per David
  * add userspace-visible runtime effect in change log
v2:
  * restart page_vma_mapped_walk() after split_huge_pmd_locked()
---
 mm/rmap.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 618df3385c8b..1041a64b8e6b 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2446,11 +2446,17 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 			__maybe_unused pmd_t pmdval;
 
 			if (flags & TTU_SPLIT_HUGE_PMD) {
+				/*
+				 * split_huge_pmd_locked() might leave the
+				 * folio mapped through PTEs. Retry the walk
+				 * so we can detect this scenario and properly
+				 * abort the walk.
+				 */
 				split_huge_pmd_locked(vma, pvmw.address,
 						      pvmw.pmd, true);
-				ret = false;
-				page_vma_mapped_walk_done(&pvmw);
-				break;
+				flags &= ~TTU_SPLIT_HUGE_PMD;
+				page_vma_mapped_walk_restart(&pvmw);
+				continue;
 			}
 #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
 			pmdval = pmdp_get(pvmw.pmd);
-- 
2.34.1


