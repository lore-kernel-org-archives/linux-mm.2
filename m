Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5834BC4452F
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 02:53:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEC106B008C; Mon, 20 Jul 2026 22:53:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C70D56B0096; Mon, 20 Jul 2026 22:53:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9E016B0093; Mon, 20 Jul 2026 22:53:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5E3D06B007B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 22:53:12 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 94CDC12038F
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 02:53:11 +0000 (UTC)
X-FDA: 85011262182.23.7203D69
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id B1C4840003
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 02:53:09 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RU5nIEo7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784602389;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZpZGhyITuiEPc35R3SeU9ir9wzXaL641Y6XBXsA0eGY=;
	b=Lo/VgEcXe3JDL7olV/B/W2K9bY0N3TWcF7odhi9n65f1cssGRuYdd19tYKcC3WfLkYqUEp
	d08pAkmqfq4qxuPU4sA2OZiRXjW3OXg+TTyfb40bo4N0ZbACVN4iHd6GgxLFtBvcnO4sGC
	KnrhLbbSM8YEJU0uhlyMpzUEQORBdU8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RU5nIEo7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784602389;
	b=Z0jGY9kbiFzjD8W3FAcNFxtnA2LPuwUQkWKuNcw0/8VntnDlHtChn+X+LC580WbGARAKWw
	83KHbgnkMGL406T7VwPwt7w5qg5r8mnUtEQYEaOhQp5v5bUrvqNyWBh+zpkk/bP+I0275Q
	br3mWXElvJt+1id1Tgswf39Z40CtxUE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4C12F60A7F;
	Tue, 21 Jul 2026 02:53:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ED0F2C2BCC9;
	Tue, 21 Jul 2026 02:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1784602389;
	bh=9xYXc8cFALwl2scnPkDmoIcwhk2eGPLl2JPUNmDY2d0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=RU5nIEo7oWGGETmhUfdKPLm20rS3ih3Lz3nx7dwAbmJpFMYKLmt1sbPxm8M2BdFSb
	 p+qcEBcKlKCYBeGTbYZvCWk0+kdvFH9uvPlxo+HCrjvzfA3TxKn/TSf+lvQK01A1dG
	 6bCBamepBRssAXw7K2FZqZE+8Pq1xa652OychT7XIwjDIyD9SfXYw04rOq0bNNF1kL
	 fY0DPpYdi2kqYt6agKYJjpZBpnTg75KDWOxMZ1teiVfjCiYXeav3kklKOSKGInqqeF
	 KMnOIr1LMuDTplYR35a/9ljd8NETimAmPoZiEBsL5JeRUAahmv6rCmmCODVa3gC9rc
	 018p7QpijnZRw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCCBFC44524;
	Tue, 21 Jul 2026 02:53:08 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Mon, 20 Jul 2026 17:25:05 -0700
Subject: [PATCH v3 02/13] mm: hugetlb: Return -ENOSPC on memcg charge
 failure
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-hugetlb-alloc-failure-fixes-v3-2-7d2a169aa9ee@google.com>
References: <20260720-hugetlb-alloc-failure-fixes-v3-0-7d2a169aa9ee@google.com>
In-Reply-To: <20260720-hugetlb-alloc-failure-fixes-v3-0-7d2a169aa9ee@google.com>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, 
 Wupeng Ma <mawupeng1@huawei.com>, fvdl@google.com, rientjes@google.com, 
 jthoughton@google.com, Mike Kravetz <mike.kravetz@oracle.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: vannapurve@google.com, erdemaktas@google.com, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 Ackerley Tng <ackerleytng@google.com>, stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784602387; l=2183;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=nuUhbZqkwDE9Ph8fILa8cD4bi/Ma9wFUhfWLAJKiQgk=;
 b=j57evNN0B3aJE2bGo4aYEop42SQgenXTgRg2PUpxRSDxLbx80RSNC2CSSJi9kG5+6PcjtSdOX
 U3od4V1MktRAPv3uMaKCMouffdnKbebP9hZr5h1kP/nwAVICniSzxVg
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B1C4840003
X-Rspam-User: 
X-Stat-Signature: jc4bd1qd9wk1jeq146t5zrytm8f1bmow
X-HE-Tag: 1784602389-138076
X-HE-Meta: U2FsdGVkX1/klUnq91gaAhwKtp238RksaUjqcJqGxCCx2K1uDGat6bfUkTu/XIukz0iKo7dwOqX/qkuJtMPubozam61QC5DC1wyQKe308w7EE42UpPcdwZ+ZTtluIFLEN04GlRepzldWvRTTSjGtRdpST8/hi3+3PswKRnwTLm2feHtPMPUSO2+FcHaGVMxmtol9si2MISVNAXj05E5B3dvhEI5t3QXt7ZtWqM0XOK4jOfVLkibK8EOJ8YL93HJv0X1BKQ6MjjZ0tMQCJ6aGkzUWDf8/9dUtT5i0xq0K4ubKPnizLm6e29/hyFzL0NgeXaymsWYO8qulolqJnCcCFF3C8LznY+0YWlTwAG8CrNylnFgZj8TiM4pC8mhk97/JFpz+zEwPdp+u+jgawrrBJQJnLC61Fs6umdMu5FkFiuQBfMSHf7DUkKhHALO83TmUrD8Z+os6FdJN5gsT03OzwIdcWjMHAZQce5BVAG34M69Bi4jNZMM97zwpNoAjtO6AnFapOPICWtLhUGh86xeYTAbp9t7lZBPCOfrpqYJzlA2x8MTVbBmPQqIngY4a4Bfoy0hPvOGvb4quZyTXPXZ7PMxbAWG+JXKpsaH3KcQ188Rjah0GPJWNG/shiWRaIA77qiBSJw3JOOWz7Ak4or5OCp/kixz65IRyNSLL7XQT6Eym1VKcAy7NCwFmcmhaMsPRvf+/tU+wrYJTMWJDRN2tb6/JiME8KmpfAM8PoIi3TM10D3P5oJQ3bqnG9eCYWfRnzIOUNHyvJeT0Iwz0NxIBt1HcC/mX4JWT7GVDdGKVVjwdiX7eZedcYQx/CE6BkX+2BTntePuprlM1FX3TuqkeofUVwPk6C5M3IGyf16W4qQqmPmCPCbXzXq+uFYSChLA8PPkm9zQ9ziSe4Xke7N+octuTsZrQdW/IEMf0/CjMhMqsyCz2vGwtBcuKhgYzZFJ5igDDpe57lMwNtoGM3v0
 1WKAb+KS
 l7q/jyKMN0OokQXHOkhdqpCIJhadM+kLk71bSSNhmtdkerK0NC/7jdaeI4MUWNjobU1ebFZXYKJWyfBH/gNYvJJFP7gNyxGMdEoWfVkX4Y8vU7vJUKReDaLztWPXjRifyy9hR0aJ0wPebOhAmD7wd8n4KlCzSUJDbna17MmTTlrr+LWKQYPJGRsiGM5jFeLJcm0iZ4NqspuWIH0a3z3Czf+/ExzgmxnURWjwPqGxnpXDkpMadN8TJ3ORV65VSXS7TVkv2EXeL+sLTfaXNve9j626qbHfmaNwIuYQdd4PETaSS1hZZSuCYzMVYHEFJgaskcLEN0D9loL3gGMqWGI3jPl5qQ6az6SiYBFxnguGG4uDHmFMX3m64lLcmslopBuBYUnn9MNMdYq+t9b6ptVjPbkaetyqTxFgzGkAq8CzQLbWxP60sEe9J86uZpJB/wnNMcds05wXiWF0705NtpxpMSWuWSmwSAumXNSXw
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
index eef9610a0593c..b32735b092a0a 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2997,7 +2997,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 
 	if (ret == -ENOMEM) {
 		free_huge_folio(folio);
-		return ERR_PTR(-ENOMEM);
+		goto err;
 	}
 
 	return folio;
@@ -3022,6 +3022,17 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
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
2.55.0.229.g6434b31f56-goog



