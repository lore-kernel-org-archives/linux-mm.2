Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E936D1091931
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 23:31:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87EE06B04B3; Thu, 19 Mar 2026 19:31:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8083B6B04B5; Thu, 19 Mar 2026 19:31:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 683596B04B6; Thu, 19 Mar 2026 19:31:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3EBAA6B04B3
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 19:31:04 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1AA6A14079E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 23:31:04 +0000 (UTC)
X-FDA: 84564410448.18.52410F3
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6838680013
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 23:31:02 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MsjbYNra;
	spf=pass (imf30.hostedemail.com: domain of 3NYe8aQYKCIoACwvo1u22uzs.q20zw18B-00y9oqy.25u@flex--wyihan.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3NYe8aQYKCIoACwvo1u22uzs.q20zw18B-00y9oqy.25u@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773963062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aTc9DooR/2VPop6AXcvWPH42yPmf9OOMr5Mq1SUAhF8=;
	b=zY4m+Ma6M7x/Hg9OnUmjYS5D27tGIsjk03V5mNkLsJ912gyMW2AlXYc1RzzZ2j1zfS9bKy
	iLeItRGN2UWa9YMDIOVbqtfrqy7vGUS/RPqBbNNAht9UQw9Sdx50eFryCiKhazRl7arf3/
	hFgxOdRrhGwS9B3tXA/hdDxmAGUnFGA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773963062; a=rsa-sha256;
	cv=none;
	b=rMvkvjhSoTH1XaKFBwE0qSZuiVg3cpe8tzwJfm1v18nS92RkfmXhd5tNGu/Lro3ujfRNk2
	gkcg72VYfssdjuJo1b/4jqhFycbdZaayL/alGvisCk+xG06cCPzEvwBpibRAUNsWLiH3UC
	bO74pXX5TR9ux19nuS2K5zVZs6EKwQA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MsjbYNra;
	spf=pass (imf30.hostedemail.com: domain of 3NYe8aQYKCIoACwvo1u22uzs.q20zw18B-00y9oqy.25u@flex--wyihan.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3NYe8aQYKCIoACwvo1u22uzs.q20zw18B-00y9oqy.25u@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-354bc535546so94080a91.3
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773963061; x=1774567861; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aTc9DooR/2VPop6AXcvWPH42yPmf9OOMr5Mq1SUAhF8=;
        b=MsjbYNrao5sBjgfIxdBRjQJnuyNbtOS26oQgJKDi1+YxxkvL0vW4YKcZ2lf1w+G1VR
         KH5jDmeIAUvwWMdac65E4v4joSrELLyNOsot9hcJyiDHik8ozpoD/AXh3mqmexCibYnb
         gTGweEynyIdAmEzBSJb4v50FWawi1j8fwzhsalzX9sc1TNaLt63fFEpqRcecIfQTYmfK
         EL0+B6kBct5VojMi82cvpk/1d8uYmuMneaV6IVIOuSkYHGs0yuqYEXnDVJjENlKd1iA6
         X2klMtkpAcadRpltkI4Twf0uIkxM0NKNy7obgHzTDceQJJFy34rdGhZlXiNg+4KvzGus
         AACQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773963061; x=1774567861;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aTc9DooR/2VPop6AXcvWPH42yPmf9OOMr5Mq1SUAhF8=;
        b=RZpMLz29TyEg0EQRK5wyAUYlphs7vs2cJgEXceQYGf98iyZAeuKNKkWJhTNuCBdmgL
         2bf5a/9EfB4wtCOaaz7BFpPyLx7vD6dxlVPn5yHfEEe724tZugSQLm5AZyFf2HVXOb2P
         fPiihU8RxZdVwM/xEf0Ke0bsrYAxsRdiDmmYun43+SjpX32MmdQPFMPiJczcsEkl3rQc
         vMVxgvhYj7Iyj/mc4525TIYkSSjaa9zjt3DCxdFsRn+zX8HVeJoNSW7kle2BSX6Pz1fv
         i04P36zPhSAzqIj/9vfWTe3FwRBx3gwNoGD5ZTt8NrHPWnazXAGsomWTwNmVj8Fxy2uW
         lgGw==
X-Forwarded-Encrypted: i=1; AJvYcCX2QN07qmEI5Kg44UtVxKX1h3dTxC+J/Z2nu+rM5NUVFUEVkTejXKGmaCM7uCH65AySzgfL9PedKw==@kvack.org
X-Gm-Message-State: AOJu0YxkbpTwmiEjmUG2rxqD2T534WbWubzc2IexBJeW7tYkAV+qWuZS
	MF1hSgbGmFz6NV1hZnDa6Um694S/uUOLqqq8uRLl4TRvONpk4GvWu3baMlsY+jIK/bVshxueGd3
	uvNEsjw==
X-Received: from pjbgz11.prod.google.com ([2002:a17:90b:ecb:b0:35a:624:7b40])
 (user=wyihan job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5405:b0:35b:9397:7073
 with SMTP id 98e67ed59e1d1-35bd2d668admr547168a91.30.1773963061106; Thu, 19
 Mar 2026 16:31:01 -0700 (PDT)
Date: Thu, 19 Mar 2026 23:30:31 +0000
In-Reply-To: <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-0-92c596402a7a@google.com>
Mime-Version: 1.0
References: <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-0-92c596402a7a@google.com>
X-Developer-Key: i=wyihan@google.com; a=ed25519; pk=cRi0fKzS5BMxlHyHY2pJv3w/1zcgfYKr6EYGYppdMYc=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773963053; l=1542;
 i=wyihan@google.com; s=20260319; h=from:subject:message-id;
 bh=zHitcA41pFBEUJ383H8n8swfI4BJin4muVKIFkkU2XU=; b=55H40VUL7GxMofCPXgAP+Uk3iLTL72SaLmREsmblKKl9G+ZOSJY8iKHX8YOxAFgnJqdH5XZzf
 fXaJWZTbAZmDgPciWDasEHmQx7TAolEylUlNZ3mq/X9WXooK2QChYEc
X-Mailer: b4 0.14.3
Message-ID: <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-4-92c596402a7a@google.com>
Subject: [PATCH RFC v2 4/7] mm: memory_failure: Generalize extra_pins handling
 to all MF_DELAYED cases
From: Lisa Wang <wyihan@google.com>
To: Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: rientjes@google.com, seanjc@google.com, ackerleytng@google.com, 
	vannapurve@google.com, michael.roth@amd.com, jiaqiyan@google.com, 
	tabba@google.com, dave.hansen@linux.intel.com, Lisa Wang <wyihan@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Stat-Signature: fsmicopuw3isfm6gd3npoj99yt8ejba9
X-Rspamd-Queue-Id: 6838680013
X-Rspamd-Server: rspam03
X-HE-Tag: 1773963062-209526
X-HE-Meta: U2FsdGVkX1+0YddPAyPuvAoNW9RI7KTpiyldmgyNIBJyIC4xJbyo58K81Vy9R/vn51Hj6JcSwspLrmTC1qOTi3OsD9auMCyylBx9blUf1zVw24oKdyrB3svHjU2smZBBp1XOOxghGrrqWOrf5EuB0IikSwOqYBAO0OZ3iUP2uHt3w/oTHJK0+DAeBVdqQXZ7mYdVx65DUgc2UowCIjH4DgZ+F0OENOVkAFMpX1KhfyaQ4BknDOjusRagCGCC77xJylqSRNzAd3uP2CxuH6h9qiDcifsvVx9kezSsinv81J7vJO8M5pg6JQw6Y8P0dvI6wt0fcTfQGPVjs2T3Tr43aM1uItccGQ03gkObTAQ4iUf/2yVT9lu2rV/C8b+YEdeKRlmnyEJ0FqW1UN0d3Og6x6qf5m3wjW7/ZsjNDOzY4ksU2SyR2VfCnQzwhKupkc6gCLcmCirKpOaryiYoE8E5jrGYJaDD2+f/yEI0WDfB33r8Wy6gG0N0b7E+zsgoYKyzk/7t0jqZU3p/wiKUgP8VewzMJ1E5BrYoYi3VJmeiWGMl4c6ATvIMq3EpXPcEFnwa/KzO2+O1/fgWcx/BuLlXjqdOdAiE/g9mAFgdIfhRqlZtYMDo1y+lj0lq8XpK9p5Yt1yQeMLUx+bqKJPI4SE1hVQa+IT4DqCgZ8C+ngTWbhn7CJZY7/01LY2ZaSVt4aP5kO5QIQR7+y0kXt8vOJ5T8XEcTHPigfKr1zwH647kHsFvAcgVwWQZkoBghccYGXtD18cKS+VjmKurEYMLWQ5fhkNygu/f22I/e4+KCiR6L8hJwH5+hGvM+6PG3W+ttQjuP1yVdCIV6bV/9RpdeEqLF9wgdFjTy4tyToYEjIM9OMZH9t9CKdqM8+sIIMYf9thiO60yN+WMSjx6ZR3cR0B4lZbA7I69FdL52dvfDzgl3aJR7JAXPLkX+9nraZIb9qn3Pw9Fh3wpCiobWga4dU/
 bfK/xsi9
 tGX0iTF5C9L7jb4t8KsnP7K3xkkCA0g43Y+qFKb5Gfr885bj2HlQJN+KTE3RT4bimFeNBxspcZP+jzCZoUhuotpOTWmwc/DcovClYwKRhBqtOQv2PuldkQtdxu1aovkvFcBfvIXfey8fgAGGpEp2IihP9Ae23wPG1DW/8CPd3bU815B5xvw3eSDP1MgQlDpBBZ50luJGIulSw7Js7Q06TCcKCi5TtqFBZo37p1GOGQRADiK6LvyKJ97FCouGHDAU8jXJ37qBHOAVXcWPtgaIcWRlQtamD9CooZ6lPPNr33piC4P8uD8EVZsEzKi9P6G87w+9U3MAAJqb/Z1fHIhoj04vVaUfKcqhRna35ERT9Hyf49RORGhjOIK3l9g4pAD2abrVvIs7KPSepzrrCNUC9L4qhpIB3G8ibv5eC5tgX6MrIV6T+8fF9eW/U/BgJA6KhxEG1ZF2gyTMyABAiWyI0rmGdcA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Generalize extra_pins handling to all MF_DELAYED cases not only
shmem_mapping.

If MF_DELAYED is returned, the filemap continues to hold refcounts on the
folio. Hence, take that into account when checking for extra refcounts.

As clarified in an earlier patch, a return value of MF_DELAYED implies that
the page still has elevated refcounts. Hence, set extra_pins to true if the
return value is MF_DELAYED. This is aligned with the implementation in
me_swapcache_dirty(), where, if a folio is still in the swap cache, ret is
set to MF_DELAYED and extra_pins is set to true.

Signed-off-by: Lisa Wang <wyihan@google.com>
---
 mm/memory-failure.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 57f7762e7418..86b6f7ba5d3a 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1052,18 +1052,14 @@ static int me_pagecache_clean(struct page_state *ps, struct page *p)
 		goto out;
 	}
 
-	/*
-	 * The shmem page is kept in page cache instead of truncating
-	 * so is expected to have an extra refcount after error-handling.
-	 */
-	extra_pins = shmem_mapping(mapping);
-
 	/*
 	 * Truncation is a bit tricky. Enable it per file system for now.
 	 *
 	 * Open: to take i_rwsem or not for this? Right now we don't.
 	 */
 	ret = truncate_error_folio(folio, page_to_pfn(p), mapping);
+
+	extra_pins = ret == MF_DELAYED;
 	if (has_extra_refcount(ps, p, extra_pins))
 		ret = MF_FAILED;
 

-- 
2.53.0.959.g497ff81fa9-goog


