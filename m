Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40AC3CD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 00:19:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D68D6B0095; Mon, 18 May 2026 20:19:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97FD26B0096; Mon, 18 May 2026 20:19:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 845C46B0099; Mon, 18 May 2026 20:19:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6BB336B0096
	for <linux-mm@kvack.org>; Mon, 18 May 2026 20:19:52 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3EFC11A010B
	for <linux-mm@kvack.org>; Tue, 19 May 2026 00:19:52 +0000 (UTC)
X-FDA: 84782261424.12.59C852C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3FD3810000F
	for <linux-mm@kvack.org>; Tue, 19 May 2026 00:19:50 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="jog/QEL/";
	spf=pass (imf14.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779149990;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I6eWjXEFYdt8CWLoTeuxQCHYocKr/Y6lUTYYMNSBV2w=;
	b=XHae2cHPPBw1B5vfRP2X69yBSOmIBdXAChuJ0E/eKzz1oroyMTUrn58t3mBcjAWGBFhROd
	We9cyRuUtEVBg1WVB1pbz6dB5ULNYyuoGOdaL32LPEM7QrrhZPNShyLCTDwUSG2Q9Y8XCJ
	vuopxpZuWz3Ero2FewqlOSbOYkPys0M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779149990; a=rsa-sha256;
	cv=none;
	b=lqwgVr4Ug0bxWQBYrW6X+EfdW5I5aKHItTMYrBsdje5kVYtNZHuGZebNGXhv5gIBfh3pHz
	VpzfZ00/unydYMX6j1LX0WnfSKyhOeIT2jAP2sjJKVzlW/9IYH8qNvmDZjgYZCXdrME1AP
	79MV3iJE3CxoeVu9gvd0pz+TqLVwsro=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="jog/QEL/";
	spf=pass (imf14.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4A08E44484;
	Tue, 19 May 2026 00:19:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1D870C2BCB8;
	Tue, 19 May 2026 00:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779149989;
	bh=DmF912XBXWSZg+goW1bFDdFsol5YVx4sSEtgnClKN1k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=jog/QEL/Mtj6SyktShDjWR+b0urP8hq/27Yb3AHS8Brlshe7wjXWSa3/ycz7WSgiG
	 oykV+LN7ZJhVY0ccWQqHKOaYH7XscLcMuYQ4HG20uf5MuNE2vvIhUHnwXCRwkkgOl8
	 t2JWwdqIETULelt/1jBzmvaaE8b7CYGztlflYUq0TCgJivFObhj2XqaMrDgNn2X2Tb
	 A1LEt0gpYba+72tMtBqRzxieML8D/nr/32TBmbgiXEsh8tl5+uJH/2KS6nII27VjWN
	 CCKYYFLot0sbpVldHGFWjoXP/AzFWT3zMDcPFn/mJKy+4kjuWfgTOdgxwbh5aAqzNt
	 j0wAo1frEXKng==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08AF6CD343F;
	Tue, 19 May 2026 00:19:49 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Mon, 18 May 2026 17:19:40 -0700
Subject: [PATCH v3 1/6] mm: hugetlb: Consolidate interpretation of gbl_chg
 within alloc_hugetlb_folio()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260518-hugetlb-open-up-v3-1-e14b302477f8@google.com>
References: <20260518-hugetlb-open-up-v3-0-e14b302477f8@google.com>
In-Reply-To: <20260518-hugetlb-open-up-v3-0-e14b302477f8@google.com>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, fvdl@google.com, 
 jiaqiyan@google.com, joshua.hahnjy@gmail.com, jthoughton@google.com, 
 mhocko@kernel.org, michael.roth@amd.com, pasha.tatashin@soleen.com, 
 pbonzini@redhat.com, peterx@redhat.com, pratyush@kernel.org, 
 rick.p.edgecombe@intel.com, rientjes@google.com, roman.gushchin@linux.dev, 
 seanjc@google.com, shakeel.butt@linux.dev, shivankg@amd.com, 
 vannapurve@google.com, yan.y.zhao@intel.com, Zi Yan <ziy@nvidia.com>, 
 Matthew Brost <matthew.brost@intel.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Dan Williams <djbw@kernel.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779149988; l=2912;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=AePQ5ge08BDvno3Z2sz00AANV/evPZ/MLFYsGkJ3Hf0=;
 b=0skywfukH1jzfYFODEad/4ypPJF3H2kngkFerrbzsvccVY7o7T5yItuX2PowuUM77EcPbwDhF
 MwzZdmsTk/RBAMrVi2w8pIQySnBvDmHLk/qra4e6oRCSiyOsn5aDJ5F
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3FD3810000F
X-Stat-Signature: gs1bcog71em9gpfzj1day41sgtx7z495
X-Rspam-User: 
X-HE-Tag: 1779149990-99197
X-HE-Meta: U2FsdGVkX19Uwvc9RZ275/DSTql/1HB46n3VhTIGlL/Y0OxnEwpIS3k73CHYHDG9bQCDfPydERpTEPehK3fGcEQwxh6URF1f32aQ6QG8E90c8+G9E6uBrVGJgbGI5d76N7/dUKXYqNoqMgEIJswSG1Fpxlp/iq7F8kN0ImtE26rLWDJKAl8xYUSTu57XmLH7goGglWghl7hqK395Rxd9fn3jn7KQddtwE90hBjlGu1zbmqfoEcQul0216etjSSWnt4D3rodz/ejo2SUo7cFgyUN8se+lqvkfX12DfW2Znks52h+xs9usN+r9TkcSSh4nTy0dA5uPnV7fRTkucvzJVKGM3zdAlrU4qKkI92ElV4MptH0lBihgLpi0RbFQRopAchDVvFZuwpnKuHXkBPbShJ4bET7teRb/26vwJNAxAYoMmja3spWthT2qmgQeitI8DWBwNSIV40plpaJ2qmlL0u6XnFnbgekS8fcbg00Wjag72hu+f8UYTa+9tu/TLTWDAgW//xql13z2e3ZvLE1TWPz5bLVJPBDh3bJFJJe8NxQ/yOcNWikDEZpnxq2nshNt1+F8Du9w9hVlGXeZosscIIb/ESHnB0Db5948uHCFRU4V1u0WZU6Ii+T7PyepVPKBjUQi0yP8VMbZ+JkUIZBOnEQv3wopdgxwC5n6sTtvzVILbKq37WXJ60Lf/wCYYBIGeLNhQ7Mjj/BnwZQpQTa1iviJJmgxjjYz4yuDQqZ6XAYghHrGLRVY9irmLXFFSOAjYT7JoK5k96j2/7c3xVkJfka3UA506bESmf0HNpGz3VQdK3PoIetTXIn2p4oa0NojEm1gC76fS3OzvzQfCmlT4x3nAX7E6w9VVWGPQ2llgW8qED421N0Uq8OP5e2pnN69KFGZNLQCs7e7f41nROQmbk731hAezTFHzP3WgYBYbclb8CRWwH46CWyrKcCU4pP+9XiI8xLAsH8vmUNx61C
 hwAlALdX
 WoekOB1Ae3cFaCWdegGyvnQ4Vm6Lok+oBGUl6DDKbOYc8fnbA7t5bSlFe9yv8MMrJP8IBJpwEEY7e1pI7HH5bqANhh61JSvPMqCKZDfco5JV+tWsHbEfqLEFp9+kRZIprVsd4T3jU821sb2AeZt6GwUsR3P6d07FCrV9bFUg22UMhftKFh/9Bii3dE64hu28CoMVB8n6X+e3OxY0/M8QmJwMIkyiZ1iwWTa3tx0a4Z8mfi9/QUFerQnfWFSqE9x1BNfVOR7AJRshlwtUqpAiSAisjI7IWiCBLf+uIVqsDTz+O3yKWdFHQCYnvlvjJdcZbf4k2wKzszPoxlcfoXZ/ChSBmVobnVrVgxAoVwIhmqlppIcto/EDPTMc4/F+rtOeezc6vxe3y3eMhbM0XbS4crAC+EcwwdMxGZD7joNTmbBzjuYSOUAb2QnXXo3P8Dj9bQsarA9P+QHMTYpSSMlr5cpp1PcypX60clwD6bkPo8U5HCOLo1FWpkT4ldXOA8Cp2pqg9c94PFzdvjsapHT01VLbwxdlljpsqwosscVBTwFcpn38VySetrLnoQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

The dequeue_hugetlb_folio_vma() function currently handles the gbl_chg
parameter to determine if a folio can be dequeued based on global page
availability. This leaks reservation-specific logic into the dequeueing
path.

Relocate this logic to alloc_hugetlb_folio() so that
dequeue_hugetlb_folio_vma() focuses solely on selecting and dequeuing a
folio. In alloc_hugetlb_folio(), only attempt to dequeue a folio if a
reservation exists (gbl_chg == 0) or if there are available huge pages in
the global pool.

No functional change intended.

Reviewed-by: James Houghton <jthoughton@google.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 mm/hugetlb.c | 25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index f24bf49be047e..190ab539a97d4 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1336,7 +1336,7 @@ static unsigned long available_huge_pages(struct hstate *h)
 
 static struct folio *dequeue_hugetlb_folio_vma(struct hstate *h,
 				struct vm_area_struct *vma,
-				unsigned long address, long gbl_chg)
+				unsigned long address)
 {
 	struct folio *folio = NULL;
 	struct mempolicy *mpol;
@@ -1344,13 +1344,6 @@ static struct folio *dequeue_hugetlb_folio_vma(struct hstate *h,
 	nodemask_t *nodemask;
 	int nid;
 
-	/*
-	 * gbl_chg==1 means the allocation requires a new page that was not
-	 * reserved before.  Making sure there's at least one free page.
-	 */
-	if (gbl_chg && !available_huge_pages(h))
-		goto err;
-
 	gfp_mask = htlb_alloc_mask(h);
 	nid = huge_node(vma, address, gfp_mask, &mpol, &nodemask);
 
@@ -1368,9 +1361,6 @@ static struct folio *dequeue_hugetlb_folio_vma(struct hstate *h,
 
 	mpol_cond_put(mpol);
 	return folio;
-
-err:
-	return NULL;
 }
 
 #if defined(CONFIG_ARCH_HAS_GIGANTIC_PAGE) && defined(CONFIG_CONTIG_ALLOC)
@@ -2939,12 +2929,17 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 		goto out_uncharge_cgroup_reservation;
 
 	spin_lock_irq(&hugetlb_lock);
+
 	/*
-	 * glb_chg is passed to indicate whether or not a page must be taken
-	 * from the global free pool (global change).  gbl_chg == 0 indicates
-	 * a reservation exists for the allocation.
+	 * gbl_chg == 0 indicates a reservation exists for the
+	 * allocation, so try dequeuing a page. In case there was no
+	 * reservation, try dequeuing a page if there are available
+	 * pages in the global pool.
 	 */
-	folio = dequeue_hugetlb_folio_vma(h, vma, addr, gbl_chg);
+	folio = NULL;
+	if (!gbl_chg || available_huge_pages(h))
+		folio = dequeue_hugetlb_folio_vma(h, vma, addr);
+
 	if (!folio) {
 		spin_unlock_irq(&hugetlb_lock);
 		folio = alloc_buddy_hugetlb_folio_with_mpol(h, vma, addr);

-- 
2.54.0.563.g4f69b47b94-goog



