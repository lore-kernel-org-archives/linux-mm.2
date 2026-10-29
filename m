Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33632606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 02:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=AHoXjxLs
Received: by kanga.kvack.org (Postfix)
	id 55F716B05BA; Wed, 28 Oct 2026 22:58:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 510356B05BB; Wed, 28 Oct 2026 22:58:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 425F66B05BC; Wed, 28 Oct 2026 22:58:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 13BB66B05BA
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 22:58:22 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9202B402D0
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:58:21 +0000 (UTC)
X-FDA: 85374155202.29.F7E5B6F
Received: from mta1.migadu.com (out-241.mta1.migadu.com [95.215.58.241])
	by imf22.hostedemail.com (Postfix) with ESMTP id 82E17C0009
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:58:19 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AHoXjxLs;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of liu.yun@linux.dev designates 95.215.58.241 as permitted sender) smtp.mailfrom=liu.yun@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793242699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xc7i/PuAK0rO9RCkxx7kEuX7C/OJd9PDaVOZ+liEfdg=;
	b=McLVRXIqD6snjw/fKygrd7o9BmFRF3D/lW0h8Eg20Lh+oNfidow9BOriItpaxmF5UTtMmE
	ktumj7kx/zym6nbmquuXuQ4OT5TuBOSTcIDztD8Nl1c0UIwDS/3yNFO+zXqKb+qTuFsVwg
	ZHzL9H09xAZoWlVhmq3C3Jqow4LoHgk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AHoXjxLs;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of liu.yun@linux.dev designates 95.215.58.241 as permitted sender) smtp.mailfrom=liu.yun@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793242699;
	b=aU2y8HAmIltQn+tXD7qaT2VVl07PFAtaHA1LiQHQn6KHuDaEywPQVwcPdEMdF9U+B2u7WO
	e9D8C18RIyAapBVrdRiCy8ppOjU79IJVy/BUklx69esNjE6l/08EJSMj3L2K1S2Ri+F8dK
	7U7kl2dLxVMcp0rtv3FF5HEescPrWC0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=WByDDeU8vlXf4dEEaQEAxXBZw7B3vV2GviEqbsJxnwM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793242698; v=1; x=1793847498;
 b=AHoXjxLsbodHPVYmh7FQkbKQmUIfz6dll6aVSaYOi9puDpSni8osSok0bxki/+o5nXfhI/9X
 4gTtAWR0DBEqv9lysguh0lHSAIK/DnQZdRzrRgtsIO59ZVrt2zO5y4yDYdiKnzQ8nac9lRtJ3HU
 V3+bQXs3CIJV0vKcCoXQ0Jno=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 4cf64162aff185a0;
	Thu, 29 Oct 2026 02:58:18 +0000
X-Mizu-Trace-ID: 4cf64162aff185a0
X-Migadu-Flow: FLOW_OUT
From: Jackie Liu <liu.yun@linux.dev>
To: glider@google.com
Cc: dvyukov@google.com,
	elver@google.com,
	pjw@kernel.org,
	alex@ghiti.fr,
	aou@eecs.berkeley.edu,
	linux-riscv@lists.infradead.org,
	linux-mm@kvack.org,
	kasan-dev@googlegroups.com,
	muchun.song@linux.dev,
	liu.yun@linux.dev
Subject: [PATCH v2 2/3] kfence: clear the pool pointer before freeing pages
Date: Thu, 29 Oct 2026 10:57:42 +0800
Message-ID: <2fab8aaa82ab2004e706fd7ec8dac20427976457.1793242457.git.liuyun01@kylinos.cn>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1793242457.git.liuyun01@kylinos.cn>
References: <cover.1793242457.git.liuyun01@kylinos.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 82E17C0009
X-Stat-Signature: fhmugrjs3gkt9ghqe5nif73ikqhx8rj5
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793242699-667821
X-HE-Meta: U2FsdGVkX18rkCrlqe2PInWGwBEX4cCHiQQ+w6EOn/b3DFJk2YqyB50UUmfHM74qKA2IVPjfJTCMgkXow178BzNf1rmtyYO/dQGR+R+W9SAo8EstHbW2De+w3gbKuxD3ZZQR4fAxEh3wSCwk8lVuq8rYYbb9bjrUiMpniitVkoZECxE0rRfts+o+NBqDb61wDo6eSCJg39pL7QjwFVTkG5dYkFE6d7zdOy3ei2asO4CvdYmieU6Xu7vuLK5+9B4ud/QbD2LibD2DoGBYyrPmgzYaMaO9vyeqAB8I8UukCnqmcW3p3QjyUoFEssZU6CSOUZF7B39h8X32kCWm4jyyloayf0N6O0YF5OuT04+7ilvhvqp+5JrvOtXtovKcIoZqIr6Ig0v3/olvgpmpcmcOPNII8O9nu3iJ9sBDDLIXz35mlItvFr2UT8HUwh298x0craN+29an7RHphOdnkovVr7Zixp/laj93lIRFhmnVcWpATLv4Rk3h2NR8dF91uUQRS6hSO9YfLnmxuvF4TAb1NfmoAv1Zpf3+FBA86GS2MdunZHi24oZSmbbSbEpUdq4uLPJLC8D/e7eeJUJws+UljKkYW5AmTg6X+gHqPDzohEwRQvOldP3CrNJzw7OhDKkCtn43Q2Okn7K6gtWMUVcveK6Mh1GPBft+SiImDLJt+2+/pG32cWOEd7RmFaIQfRmKTgcVEpSYrxaXRbj3x/E/O0wXo5jKHu8x2voyN6bFaQ8W0sNyj2CzCpQjWUUkWY5sHlub6I1Ne3uW5rxxQeFrDBbWpwd6BNIVDXzErtHkIIcqSY4OvgZblpWgSo/rpo1I03zJu/xH0OymGz7C5j+JHK+myA1mB7R6lWv0Hv0K8JScmTou6SMx1fXueCz9i8of5mOMW6ZgIDJd7NRNzKmL1V1DhWHN+xtum/6L2fBvCFoAcanr8Z0c/ywXr9g++3oeiLL1zGzs8DekQf038EX
 i96zKh0c
 HjLKkRvyAeB5bdoiot18ZdSLnXsytLQUm0Z73QuMK5L+42aGGtRgAZBbq3luFno6+IW5FJqtKymqzwn5YUN1rjoBpL6+p6QoZFYMC6Zd2LtXTn+YoHy2ntHx0oddUL+x19xaCQiWvYUMVnLFSM3nqCGrQhHWtSaKS1gT2E4kEvd301MZO/KePe+nnB8rYF/x9pQuqbIHl6/cSsKrVjA/g/5q9HvO4O8HGWG0t0Y3Vk2snqi4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Jackie Liu <liuyun01@kylinos.cn>

Late initialization frees a failed pool before clearing __kfence_pool.
Slab allocations can reuse those pages in between and be mistaken for
KFENCE objects by is_kfence_address(), even though KFENCE is not enabled.

Clear __kfence_pool before freeing the pages, and use the saved address
for cleanup.

Fixes: b33f778bba5e ("kfence: alloc kfence_pool after system startup")
Cc: stable@vger.kernel.org
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
Reviewed-by: Marco Elver <elver@google.com>
---
 mm/kfence/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 6e3d01bccdf1..434df6cef7f2 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -1052,16 +1052,17 @@ static int kfence_init_late(void)
 	free_contig_range(page_to_pfn(virt_to_page((void *)kfence_metadata_init)),
 			  nr_pages_meta);
 free_pool:
+	WRITE_ONCE(__kfence_pool, NULL);
 	free_contig_range(page_to_pfn(virt_to_page((void *)addr)),
 			  free_size / PAGE_SIZE);
 #else
 	free_pages_exact((void *)kfence_metadata_init, KFENCE_METADATA_SIZE);
 free_pool:
+	WRITE_ONCE(__kfence_pool, NULL);
 	free_pages_exact((void *)addr, free_size);
 #endif
 
 	kfence_metadata_init = NULL;
-	__kfence_pool = NULL;
 	return err;
 }
 
-- 
2.56.0


