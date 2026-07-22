Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C503EC44532
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 23:41:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F05756B00A3; Wed, 22 Jul 2026 19:41:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB6C46B00A6; Wed, 22 Jul 2026 19:41:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCC016B00A4; Wed, 22 Jul 2026 19:41:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A49BB6B00A6
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 19:41:23 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2275E140280
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 23:41:23 +0000 (UTC)
X-FDA: 85018036446.09.26888D1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2689080003
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 23:41:21 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lxknJXe7;
	spf=pass (imf30.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784763681;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oZSgTT2n0SYRO2W2K6zwZ+bBf3QQEdC4kZLNNhg9aCU=;
	b=hO9NPAFe2ygSZMEAG2ILxfWT0tlgBazNtdbylYwmAihuOSDU+LqFcMtdjISii1X8QCHJbz
	urPzf48g2c3x3IjI/Mb520sDFg+h7/WCDVdf5HfklqlQyRTnBmoyhdBAZTqDJCx65OqVo8
	Fh543jp8q7UGe2pgwMpfpXD2aJat0nY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784763681;
	b=favfjgvt8+eBzDQ9VE9eGwRkc981dOzy/60uubMG5ZQ6nTcz15l+26PNw/hfQg209nXWOO
	Mis/ykEvBpBHzkJ8Wwh4D/HB+rAYmYhiraEGa+2NcwXwHk8E0rsO0QZPih0pQLHOfeFVGv
	4+l4nIr8LsEaNGA176hPj1rfhmWfY6k=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lxknJXe7;
	spf=pass (imf30.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0DC1444F23;
	Wed, 22 Jul 2026 23:41:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C6518C2BCC6;
	Wed, 22 Jul 2026 23:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1784763679;
	bh=asDu53szvZ8BxoP3xBFFR39bZX7xQtE305TUvB0bAIE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=lxknJXe7l9WWVl1nrdgPiDECtcTR/T0+0QyM5xKGNuyOhOYaOFp6SdHkZle3Cmsoc
	 Fu59LGcdYS7jLw/n7M7E+GtnE/sUYF6xkkhiOcgzVvfurCiYerWm/ECSetMhR0HqYr
	 Vt6Bv0du2qmOM8DxocCyXhex9yRokvfeENUjVAQTSasaITQs72EP77EzOpDWhpXXkR
	 94vYDqDsQnLa2Sk7FG+RZjISvTQeN0duxCqh3Xsi3DwBYJQLDubjz3HTJwCTv3rUre
	 U5qOfF9SoXIeceLDrvZUJ6fUkWdQNrsvoMBcwtHHgV2nJOwwzGdHCEvowgbkSxYNW0
	 YyTr1Bi9zTKWw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A49A3C44536;
	Wed, 22 Jul 2026 23:41:19 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Wed, 22 Jul 2026 16:41:10 -0700
Subject: [PATCH v4 02/16] mm: hugetlb: Return -ENOSPC on memcg charge
 failure
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-hugetlb-alloc-failure-fixes-v4-2-88e8b81970dc@google.com>
References: <20260722-hugetlb-alloc-failure-fixes-v4-0-88e8b81970dc@google.com>
In-Reply-To: <20260722-hugetlb-alloc-failure-fixes-v4-0-88e8b81970dc@google.com>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, 
 Wupeng Ma <mawupeng1@huawei.com>, fvdl@google.com, rientjes@google.com, 
 jthoughton@google.com, Mike Kravetz <mike.kravetz@oracle.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, Alex Shi <alexs@kernel.org>, 
 Yanteng Si <si.yanteng@linux.dev>, Dongliang Mu <dzm91@hust.edu.cn>, 
 Hongxiang Lou <louhongxiang@huawei.com>, Miaohe Lin <linmiaohe@huawei.com>
Cc: vannapurve@google.com, erdemaktas@google.com, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 linux-doc@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>, 
 stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784763678; l=2279;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=wmoXONTSMCE0pZEPoT08cRwobUPLPpiUr/LRWZQPS8U=;
 b=KDHlw7WdJmh8mcn+h2AhBlYR5bdH3uYOuVSgl+nfxzJXdfEHSQ3u3Zm+FIYqoIRms5b4sL//9
 RkxUzY2QUxjAzwB8bEk+AgPBG+by/l/X50vgdac5sR6PTRn695EIGVh
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: arndp6u8g8ak4tmqdm3134q7h8pi9uwm
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2689080003
X-HE-Tag: 1784763681-522219
X-HE-Meta: U2FsdGVkX19qwlBH/Db8Q1JM7t9d+T5PYmEd6sgDlBTNARIFT+BWLEckawas/5JDDHg6idqUsGaJ62RBqaWuSM5acmuHj0HBuVPm0YDf87ynMMNP83rcmoye7rqJk+xL5HTPPLK6YVV3+E7UnsmB66AbUoC8rgblqKud0WutDsnIZhFsG/21HUW8NQj55FZnW6V83xlU1+pb1hhRHeZRjeLZ0a/2E+uc3L1i8i0Pjpy2qlJN9WsHOzE2I2ZUqFBtNyCAWpZmJK31w23qTZjdg9gV7PlOOIO0tV7obKHgA9rNMLaD+AMguYOvEawhlUkGalWKLG32RvmbsBj+9+G66/WsLfHDJILw+UAGuG02ql6r15KlNlqGBP+9tKg4wLEaA1HhQtjk4paZ1mleiZqcpLjeQn5lClEv3dbE1GQiqwxSLp06eX0JXM66v6bhUwgDsXSkUmN+DPYxI3uIoJ7hK853LzDZePV9LKZtxnvQXAF+LFfQgQi7JYzalgCgZOZmjb9sJGa5TxnQNJzx9+Zvtc7+35gOlJPjL7+PppErNXB2XtvRTawHkq9HzuA3o/acP2um+DGy2eGmNbiGwFTW+A8Tnf3YpSiWlkxIWBViXKWlTKJn1ElJsbCKZlb4+Yaa2FrmDGjoDaC7zn/eCIS/1ETeFUrRSbq8SY/KWZ8jMvkMO4YmjyKyf+GfmAZVKJfVsc/TlLl8nE9VP4JHlkfk1/hfTse13V6iTfSQOdGLt7KE7sIt6B0q3Hxp3BkNur13ryr3yrF3NE+2EAuk2EALtBf5md3CQghwGLtAkqd4q4GnQOCEXmkyfiZjgZ2Fp5NmydBCuHZwey/22k7HQTkrqb70xd6kuEAyRk3WMQ1lAEpnb8Irng+ez6J3dICPBZcWg4egH1ULWi+yZ6ivSRjGBmnU2vyGql1WfonmpjNf56OF9IG7ijkifkCKsWySNThpeghcdKBjZb1zubo+Z1O
 a2gZOEe+
 WWUOx3qNxargZf1RSakTdi2fCA50fIa0fHun48JF+0Ao76w0KcENEOGtoYqYdga3KVxLY/fGrWL0qcKC5QVQzCMhm6xkjh4mW72ZGw3m/qXerDgpZaHW3b6xb36W/BiLgD40mvPGIYTG9DZ5L/yLufO27pVsuFoAq65XeaADptV7WfyDNRDLBUnulQgvBj76J9G8FfxirZn9Fy+TlO7sqxVx9877yDQhqMQ5MzS7n2Qlbddj0aqIp3zBsDQeTPGhKhd9i5peWwD6T4StAmdooAJm96g/j8mRQ2OecXHQR76I9q/DOaxvUMzIGv3imL78kh41BXev2FsXMvopdxWZduUECmZKY+SkPPGZ/k7iE0zPvbCdJPY4Eefptg78klJHzGPRudNqoLItTLcGyRhMxYwA4kgr0TTM8tyPUnKRrPfYtdfawneU8VAf/dK15xw3wdM9wZIl9AJcgRQ7BMYCDeH8VXQMjuTyPnhEk0swrQk5T2J6XpZEMAvcK9Rp9Vwn7c1j6
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
Tested-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/hugetlb.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 36fa3fb3945d8..15f9c5a9f75e2 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3010,7 +3010,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 
 	if (ret == -ENOMEM) {
 		free_huge_folio(folio);
-		return ERR_PTR(-ENOMEM);
+		goto err;
 	}
 
 	return folio;
@@ -3035,6 +3035,16 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 out_end_reservation:
 	if (map_chg != MAP_CHG_ENFORCED)
 		vma_end_reservation(h, vma, addr);
+err:
+	/*
+	 * Return -ENOSPC when this function fails to allocate or charge a huge
+	 * page. If a standard (PAGE_SIZE) page allocation fails, the OOM killer
+	 * is given a chance to run, which may resolve the failure on
+	 * retry. However, for HugeTLB allocations, the OOM killer is not
+	 * triggered.  Returning -ENOMEM (or anything resulting in VM_FAULT_OOM)
+	 * would leak to the #PF handler, causing it to loop indefinitely
+	 * retrying the fault.
+	 */
 	return ERR_PTR(-ENOSPC);
 }
 

-- 
2.55.0.229.g6434b31f56-goog



