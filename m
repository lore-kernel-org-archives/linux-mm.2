Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57C5BFF887E
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 18:20:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E25E6B0093; Wed, 29 Apr 2026 14:20:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B97B6B0096; Wed, 29 Apr 2026 14:20:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1837E6B0098; Wed, 29 Apr 2026 14:20:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EFA486B0093
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:20:05 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AFA88160321
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 18:20:05 +0000 (UTC)
X-FDA: 84712407570.02.9EF7B35
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9803340008
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 18:20:03 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=I6dsvz1f;
	spf=pass (imf17.hostedemail.com: domain of dave.hansen@linux.intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=dave.hansen@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777486803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=U2Aes9sZIkQFBIU+82E4fqMlnjosyHS4gF11vUDrQBI=;
	b=lxoY4UVirpd0aqq8SRv1ATn2267RyjDxFhZXy+aV3pfJYklzYAxR0JQXI7mgKzifyHzRYP
	D1IkJtLhZqMX9vHG+DXnyt79xhmWvDms1n1K1mkWk1kSEhUJLcJkftjgbgFDIJzMtYHggs
	/FHnVAU/K3lbiR4KecaXovmYP9fgARs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=I6dsvz1f;
	spf=pass (imf17.hostedemail.com: domain of dave.hansen@linux.intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=dave.hansen@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777486803; a=rsa-sha256;
	cv=none;
	b=ZjWfYjaC8oErEZ0Jv4j4roNzdQ/TBZAziN76dU5ZySboT90nx7qLqdug35oUQ/ypySSkbg
	qBRl2nB4WIlx+dOpGuo7DAcafgc6aaT0pVdRN/ia4M0pvPeMwv/mk2E3qmEHeadoO4XEfs
	9+/R49zqLfIz7w4hUh49NTXdgECwDkc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777486804; x=1809022804;
  h=subject:to:cc:from:date:references:in-reply-to:
   message-id;
  bh=+sJGsZ4/2gGZtmGKtRdP26CBc6vMMZiB8DZRyd6JjHk=;
  b=I6dsvz1fWDMSGS5g0wgcBY0dclk3wVCvAn4Ow3/BjfewhWq1fX+WcBwR
   3MGLjXQ7PcHnSZ0zD2dnA+u2Xjf6QimwhHRHJz9ZpbsSqgPwTQScU3LoC
   AUOdGxf1Hzl+4A6FaAm+Sy8uRyOcZrnz9kDMVTlihqLYfu9PUhcXNP7Xw
   ix9YKeKC37NtQsB68/vr6aOm5qyMhgQ+noWxUYZ79TrIyEC8cBJUoh+Hb
   bMqCYXDpW72HAnKeqXNX4PyEwOjhl+WvFJoDpvOHZsGsqGcttm9ZTI6ra
   HxMKrB1ElsK+VKdd3kHb56gkpnmb2rG0wZY40j9xZyLdCpaWY5/Tx6jHv
   Q==;
X-CSE-ConnectionGUID: pfudRQ2FQQOcPn2OVwyMnQ==
X-CSE-MsgGUID: 2zqxbU1NRSKgnj/vBAAzQQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11771"; a="95990122"
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="95990122"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 11:20:01 -0700
X-CSE-ConnectionGUID: gncUGFtqT9GLDg0YFldOQA==
X-CSE-MsgGUID: 9ZVGbQVnSfWkW5U9dFOILg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="239336412"
Received: from davehans-spike.ostc.intel.com (HELO localhost.localdomain) ([10.165.164.11])
  by fmviesa005.fm.intel.com with ESMTP; 29 Apr 2026 11:20:01 -0700
Subject: [PATCH 4/6] binder: Remove mmap_lock fallback
To: linux-kernel@vger.kernel.org
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org, Lorenzo Stoakes <ljs@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>
From: Dave Hansen <dave.hansen@linux.intel.com>
Date: Wed, 29 Apr 2026 11:20:00 -0700
References: <20260429181954.F50224AE@davehans-spike.ostc.intel.com>
In-Reply-To: <20260429181954.F50224AE@davehans-spike.ostc.intel.com>
Message-Id: <20260429182000.93887DFB@davehans-spike.ostc.intel.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9803340008
X-Rspam-User: 
X-Stat-Signature: pupbazyq5impscdsbjbyhiqnsbqg6rqi
X-HE-Tag: 1777486803-992777
X-HE-Meta: U2FsdGVkX1+zcw50NUJdDvAds8yW0jEEj/KoQk4ZRA3S+2H3NBCV/QIT3lVqZpIfcoCj0xs05AW78mcjLkuN3AS5d+nizKgEcOpu5Vc28qdYBdOr+d6vh54XP89PY7QLXfLMY68SLuyU1hUX6DfBWQG3d62JwNmhK48ysPraielvcnoEd2wk2o2NpgJpaGd0zLEHarVXM7hOvzZiBv4nHmVm+pRQtEGBIePGwOZF9Doqgx4FKpbbjWV/jjBg4OjAUz81G3qQ5rzi6cPNEc6b0sWpUWgRBD0PHpxGusgAASkFGRGV3JojsKk3zLdoaylNwMpjdTdYVG0h9d6s90JOxIx46RXndO/x7ZAGA7FPxP0SJWmGhc8eSAZkH4ecf7NBkKCClTpTa5TFvQ/SpQ9ocrr2CSGq0+2KfI+20CpNWzg1GHdtPxifyvOLTNEXEGoKN1XTemeknB33VoMY5YOtxFbL6dEfhbFBdmWfaBkWSDrmgt48/4CNXxhH5y76EzR44l5Ydoy9HssjJZronqV6bFbD+g6nIoPcOQWizMv96Zhs3oKQE3kLR7lwbAEFV+kXcYDTV6GycJkQK7sipAJcrzqmvCnYIeq+0GS1o7RPrRD4KJxL/EiBVD3YudMk6WtCebVFyphuIiW+txTHxslIdNwfEsr2NmeR8U+QcrtfgNGwYKHcm7gu1Mc89AGvfObR9WcpRJDIIy4bTH/fEXWGshdhkvWgJ97b/Mp12XQqFBXCa1oyVR1eMT8kty3BqHXAmq0UYuoL0z+1xzFS6bcgFUYmVP6V1xhfczYUOMOQziL8yjyKum02E7gSpghKId5RgwakFotRagy+zQhxSESrEZjRvShW5aiYbR/m3opeR+GiUX5EE1cZbMZ5SkG0k9q9XlyXZVXsVTvuL1GW5FtTxxsyMjUunbkPxzYJfE2TaqfQNyS6BXu4zPO1yUE4+uMvUBgiVOMqefQTcFLFgnw
 YO1JBPPv
 7HyUhn1B9wSyDizP9z1dqAL0CdppD7XQNOLyapDo+8pngMsNS3Z7QcNASjc+3ydKB9oH3SbzfrAPUDfxT9StRLk90Ycmd4C1td7z/0TTiSIvo4Vc4AVX8JTsANC7NTIAAn9CyTkr6EuBNpOxFaCluo7iwfVt9lba2/xF/T6BSKGcfoNKvi8jdFnpcUcncVw/cd6Ic7PUjaSK85eU+gAD98tMiciNiawW3bGMKwLNQgj04T9d7rLFwB7pVlVMaZYo2N3+VUUZG/IWJCA0oCvWYgq8obZ4QHpGUl59KuiDb+qkAkf7/5HeUVuoyw0Jz2XbkaNdVlXPCPfJYqJmOyEa6gpTMVbwRGDl0ieC/0MOMzC1nJ9BxXiXSuZCDxuMLmpnp0tAsQ/joyRAqQVfpxCAVMS7jmRHB1Cvbsy2L
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


From: Dave Hansen <dave.hansen@linux.intel.com>

Previously, the per-VMA locking could fail in the face of writers
which necessitate a fallback to mmap_lock. The new
lock_vma_under_rcu_wait() will wait for writers instead of failing.

Use the new helper. Wait for writers. Remove the fallback to mmap_lock.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org
---

 b/drivers/android/binder_alloc.c |   17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff -puN drivers/android/binder_alloc.c~binder-vma-waiter drivers/android/binder_alloc.c
--- a/drivers/android/binder_alloc.c~binder-vma-waiter	2026-04-29 11:18:51.307654829 -0700
+++ b/drivers/android/binder_alloc.c	2026-04-29 11:18:51.310654944 -0700
@@ -259,21 +259,14 @@ static int binder_page_insert(struct bin
 	struct vm_area_struct *vma;
 	int ret = -ESRCH;
 
-	/* attempt per-vma lock first */
-	vma = lock_vma_under_rcu(mm, addr);
-	if (vma) {
-		if (binder_alloc_is_mapped(alloc))
-			ret = vm_insert_page(vma, addr, page);
-		vma_end_read(vma);
+	vma = lock_vma_under_rcu_wait(mm, addr);
+	if (!vma)
 		return ret;
-	}
 
-	/* fall back to mmap_lock */
-	mmap_read_lock(mm);
-	vma = vma_lookup(mm, addr);
-	if (vma && binder_alloc_is_mapped(alloc))
+	if (binder_alloc_is_mapped(alloc))
 		ret = vm_insert_page(vma, addr, page);
-	mmap_read_unlock(mm);
+
+	vma_end_read(vma);
 
 	return ret;
 }
_

