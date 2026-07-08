Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 815B1C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 22:13:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D1596B008A; Wed,  8 Jul 2026 18:12:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 093C26B0095; Wed,  8 Jul 2026 18:12:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D170F6B008A; Wed,  8 Jul 2026 18:12:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A11CC6B0093
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 18:12:57 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2FA08168D9B
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 22:12:57 +0000 (UTC)
X-FDA: 84967010394.28.DAAB760
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3286FC000B
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 22:12:55 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hSKU7svD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783548775;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WFpKWmGQ7oIw97dxv1JLADblByJScTciGr6z5HLOti4=;
	b=2SRGzhnVkFCfzY26COMm6Qpyf50zjvAxwbC6jZ/XVB1JpmtyCAor4sKX7JQF+Xo49zcdmw
	eGgeW/WRsB4bERUegJ9inJ3VdyB8k6JMB69jo3tKuSp/rmXifxdZhFMiD85dMUBuMPETkJ
	vSzZ12dlneo3fMNhC0dBzOdsBJS8PtE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hSKU7svD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783548775;
	b=ai8UELKmFOW6BvAeSRWYU6byKJUtlvIueqznj/fL7D/gzbGLYZyo6NLBLZ2uolC6vT5XeP
	+l+ShXvFUQ8VGM9NLWL71Dnb4Pj++rfcY55XTOT0feyTEbYospzermAE/UxdPdfEweKvPy
	6x0J1/7eejnKAkKpa7P8sMYHmu4YW8A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 214CD43D19;
	Wed,  8 Jul 2026 22:12:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EC6D4C2BCF4;
	Wed,  8 Jul 2026 22:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1783548774;
	bh=69AY4ocHUaVliMTNSwskxx27mtLaUjKa3eI4hfXhBvo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=hSKU7svDBslpur3gfD1oOP5CBgiuO35zxafM/UXjUXu+5rzkTdUTQobmvuRAAd2vr
	 XvZSZNPUlOAWXh7X/HD1OhELAhgDnbN0STJvz/19nfTXIazDtx1x/ZZhU73j4rMrtF
	 QaiOv95z/RzHHqTV5u9I3yISNNTJA4S/qot6PhHAkykbh5ANVlE9pFp4OUgnUt4TUB
	 KH3wJzcdJI1lh5q74wACwsJzlJEJfXyIOuoYv/V+9lLdCWnh+bX6aRzECd0SZJ/gJz
	 RnCw1+T1gsLpTlxilTZrhnA5sGsDeNdbsNYTAyuxo79LPRHE91RgBr0dX9IjbE8xSu
	 Nhb0USqLF2f5g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D26DCC44508;
	Wed,  8 Jul 2026 22:12:53 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Wed, 08 Jul 2026 15:12:52 -0700
Subject: [PATCH v2 4/5] mm: hugetlb: Return -ENOSPC on memcg charge failure
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260708-hugetlb-alloc-failure-fixes-v2-4-c7f27cbb462b@google.com>
References: <20260708-hugetlb-alloc-failure-fixes-v2-0-c7f27cbb462b@google.com>
In-Reply-To: <20260708-hugetlb-alloc-failure-fixes-v2-0-c7f27cbb462b@google.com>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, 
 Wupeng Ma <mawupeng1@huawei.com>, fvdl@google.com, rientjes@google.com, 
 jthoughton@google.com
Cc: vannapurve@google.com, erdemaktas@google.com, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>, 
 stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783548773; l=2177;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=ATDEFmXVx2084y3k2D/X0eSSvzPLxfpRzdf7vni2gz8=;
 b=whjYrYebXAkYbMWBoCoWQO4eHHsGErO3ZYnQYeeOZV3idySVzaxov0v7Qk5ursaHnFiAv7Zlf
 rjMcQxMzBmQBqzPEMm8GK46Ebh8T8XnSWXnxppCLYFsxMSuLwGJR2EI
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: zeubq5d5bjdf34c9ajrwg3ikx5tw9zbd
X-Rspamd-Queue-Id: 3286FC000B
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783548775-646207
X-HE-Meta: U2FsdGVkX1850ck1CXMCF5T2josLtNbNHTWYSqGGG0szC4D4djXh4ia3HJiEgbybTapc+rCndme/h7G8rtGYQN2Jf8KTW2ArpGjMPvBAUH1pmBcA82CoKO6UAynsZf0WetvNiYD2whrcWi4+RxTbGmnRMNSVppyUkXkT5qGG6HSQ4mi2QqTMN0j65tmYZHXLtCvktNQwzRwsz12rwB0oEylJ398lQ3kEDbwr2lvMZcCE2+FoRFsD1HvG+IeAmPKvjzvogDpb0eV/c09As10kNZmEz/DQhH1Zptgon7VeDCURi7XjYvdp3e3O9RIQR3QqMVLIG+hi3jFdWZSyg/2cVwv+Hd6fVzF5o2UPYN0G27f1pcQYSXxSmPVrK83keOzr+UudPQwUlx6/+0SEflNCvPUWSCbb0OLapZr/0fpGirkviW5KBQm0QHeCDvCDATmyeBO4wbCDpJ8gUolfpD8PA0dggYUNAS0cUfkkR8WWMd/FyDjUOBsW4vZBmQX7/3VUst1GE2g3EomN0y5Jz5eqbiWok1IL9fr+SzgVLNlqiWw0bFqrlk1diLU313VI4NFWlt9lrut2JDW/cGdrUxH8RJ1jI0VC0HXqpc663TGVF/GpNd/oEK1v+yGUa9lhZSmA8KlmjLXp5YjqV6nMgxlEbJkflZdLQDVeMVwf7jVn2/CGEPjEmCsLP0kOTprgjZbAxsii5FBVMfEBytjhyH+8/T64PZ1qxquPThHCFvurGdhYi7m3q/CKwDxhJIDhcqhduKICup/PX12H6kaEpB9cV8My+J2OKGCLEjfODzghWRsb14K7idJqaZHc4GJ/4O7LSnZNTLi225ZI3DJ8waEmANJxQB9+qZyNfZESXsFcWHkynNrwggoT9oDmLGNh8ejuBg0gqzCHPbNuCJH6ovikORjPb5Az5ftgniE0EeNQq1yav2YjmUp3CMJjYxMnFVQPJ39+fulPYhIer4KFvh4
 MPefX3kT
 iifhUO+yktHk8ab30OuOlfEZKZsNCY/0SPomDt8GrkU1UF1jxWq9ClxcI12C5U/p95lLPpy22L17QlAMAyJRHNHUcnKEUI6U3mI/qrH9wQUHLQ7nOpXR9fkgLcJ6APx9oJSnQiRdfYJl19ZQ5CRQAQvVmIRpALaueZ27rdG+QXnb84ZQahBY3YYVS/rnHdnoT0360hcrBU+EVT8KelvsXU4LEHGUTK1PyONiGiRf7H8H1mA4Hfn9m8LQBc8SJp62CY8IW5N2PAIYTF1+gwqyEOYdiSjBMJYVa90MoJohxAjHqmIyEd5Ph3pSoRI8zhqfMcXWPURAtac4wJNzQv2dT8EwAGuN2ylVKAqqkpJjVaFW5RWtnVGcXueYHY7VAuBMBA7RViwlPy1j6sq8cjdH2QVP8skEWRl0s/YLmsDI8DL1ug35TRzlLx61qxCug1J3hKf1sh5WJolPAXKVtbKDPafv+ZQjPrgcT0Wkb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

When mem_cgroup_charge_hugetlb() fails with -ENOMEM, alloc_hugetlb_folio()
currently propagates this error. This results in the page fault handler
returning VM_FAULT_OOM.

Because HugeTLB allocations are high-order and use __GFP_RETRY_MAYFAIL,
they bypass the OOM killer. Returning VM_FAULT_OOM to the #PF handler
without triggering the OOM killer (or having it make progress) leads to
an infinite loop of retrying the fault.

Avoid this loop by returning -ENOSPC when charging fails, which maps to
VM_FAULT_SIGBUS, terminating the process cleanly.

Make mem_cgroup_charge_hugetlb() fault handling use a common error handling
path, the same handling used for hugetlb_cgroup_uncharge_cgroup{,_rsvd}(),
which also don't trigger the OOM killer and hence opt to terminate the
process with a SIGBUS.

Fixes: 991135774c0e0 ("memcg/hugetlb: introduce mem_cgroup_charge_hugetlb")
Cc: stable@vger.kernel.org
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
---
 mm/hugetlb.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 1f3f4b964b153..3e1d99f03c70e 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2991,7 +2991,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 
 	if (ret == -ENOMEM) {
 		folio_put(folio);
-		return ERR_PTR(-ENOMEM);
+		goto err;
 	}
 
 	return folio;
@@ -3014,6 +3014,17 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 out_end_reservation:
 	if (map_chg != MAP_CHG_ENFORCED)
 		vma_end_reservation(h, vma, addr);
+err:
+	/*
+	 * Return -ENOSPC when this function fails to allocate or
+	 * charge a huge page. If a standard (PAGE_SIZE) page
+	 * allocation fails, the OOM killer is given a chance to run,
+	 * which may resolve the failure on retry. However, for
+	 * HugeTLB allocations, the OOM killer is not triggered.
+	 * Returning -ENOMEM (or anything resulting in VM_FAULT_OOM)
+	 * would leak to the #PF handler, causing it to loop
+	 * indefinitely retrying the fault.
+	 */
 	return ERR_PTR(-ENOSPC);
 }
 

-- 
2.55.0.795.g602f6c329a-goog



