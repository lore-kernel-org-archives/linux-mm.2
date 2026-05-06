Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0AC0CD3442
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 15:54:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 738B16B0096; Wed,  6 May 2026 11:54:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70EA76B0088; Wed,  6 May 2026 11:54:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 588E26B0096; Wed,  6 May 2026 11:54:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3EFC96B0088
	for <linux-mm@kvack.org>; Wed,  6 May 2026 11:54:51 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F078C14013E
	for <linux-mm@kvack.org>; Wed,  6 May 2026 15:54:50 +0000 (UTC)
X-FDA: 84737443140.26.DC60CCB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id F04E01C000B
	for <linux-mm@kvack.org>; Wed,  6 May 2026 15:54:48 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Spy2fGUa;
	spf=pass (imf20.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778082889;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gzqQJ5ikg5bUTHD6wL56uOlNqbg5g7vI1sW0F5UhdkM=;
	b=WDSRz3+kDwiBm3nqJmfl8MCjgmIELKXaIj1yjATo2RyD6F0bBdurfUNk30RVUVPP8xDXH2
	VAzqBKvXd+Gnc+Ed2KneyS+y1SsLMjn78yEwDVDWh/a+FA3Z33RHEXcJkiHzXpGGmuuiyM
	PruzUBntz/rkq+ILlTkN+Tl3yCSRGlk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Spy2fGUa;
	spf=pass (imf20.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778082889; a=rsa-sha256;
	cv=none;
	b=aXuWfiaaq9G8Xte7xIpUrW+A6nbJl+UhhSclNJh+l+eSJsBVz2uEl7HIU2zr8Fp30mbAxu
	CgBH/D18h9sDXS8QtZSn+ImS6CemU6HQ2euYMuBSn49w7kAzGOIPQxGr1o0LMBq6yJnNBU
	cQPJIh3CJrbY3Kv+Jbx8QkOd7Yf/Yhc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A56C6442A4;
	Wed,  6 May 2026 15:54:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8589EC4AF10;
	Wed,  6 May 2026 15:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778082887;
	bh=MTAqXqjU1haYCX3aL6jCZ5kr7+TwMGVT8o6E66wbHEw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Spy2fGUaj609nhPpwatopMmHdK8eVklmI2H0UvK27zGUzJjsmAD6P6C/4FfQ4/nzb
	 7Yge0qfDp2zwOejFgfgs4f2S3DD1UmRA/Tdi8r2B6R503D1LWasVDnTCm3b/qcha9z
	 6ENjWJA6tT+OjegIKwHMWM4EkWRdWB6MT54dw/raCw+OKT7AULGJzfKFwQhv6Hz+xS
	 UY/WjNeBt8GrmZSc/aCO4GROsN5u2wq44sE1vh3jOrDZwLM+gjUyCnncv3XewFMhgJ
	 zp3hBlpQ5W6sEGQkXWy+08WleFIun1POXV2x3po0wZyRCKccUXIIojhorX1WWm+4f2
	 owEjzjDqIMELA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D4FECD3443;
	Wed,  6 May 2026 15:54:47 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Wed, 06 May 2026 08:54:40 -0700
Subject: [PATCH v2 4/6] mm: hugetlb: Use error variable in
 alloc_hugetlb_folio
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260506-hugetlb-open-up-v2-4-826a0c5f28fc@google.com>
References: <20260506-hugetlb-open-up-v2-0-826a0c5f28fc@google.com>
In-Reply-To: <20260506-hugetlb-open-up-v2-0-826a0c5f28fc@google.com>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, fvdl@google.com, 
 jiaqiyan@google.com, joshua.hahnjy@gmail.com, jthoughton@google.com, 
 mhocko@kernel.org, michael.roth@amd.com, pasha.tatashin@soleen.com, 
 pbonzini@redhat.com, peterx@redhat.com, pratyush@kernel.org, 
 rick.p.edgecombe@intel.com, rientjes@google.com, roman.gushchin@linux.dev, 
 seanjc@google.com, shakeel.butt@linux.dev, shivankg@amd.com, 
 vannapurve@google.com, yan.y.zhao@intel.com, Dan Williams <djbw@kernel.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778082886; l=2128;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=eGP3URO25a2yJfXjXfljDSZfxvkXYHSvdYeyD7MI+ek=;
 b=7RdhDIfpu2hRHtT21qfwETAVWbSePUPaxz9JrwOIiwwAWtPE6ipWXGpk2G8+NkmVEBhRnCSRm
 dv6BvSt6FHdDvL8xQXod9qkE63QOT2QnsHlTzCbxf64nENwkYBB79re
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Queue-Id: F04E01C000B
X-Rspamd-Server: rspam06
X-Stat-Signature: jmo6sbgwqgrbgbeypqod1pkp91wyg73h
X-HE-Tag: 1778082888-645107
X-HE-Meta: U2FsdGVkX1+i7vt6D2l4qGcgmO/+41+PvHX1B/iP3qZEOMSYeuryfFDrO+YGURcAIuPuK3xxWZ/YGcCoXuAiwfB6w88az5fletDhuLIJHB6L16ZFsS2lwnqH1fZ7IV713eqJkkgwAaBTU2CA1jAcPuWRWcx574dP69cyCX0JKRTCTlJPn2jJ8QTey9A5RtWFMDri+0XVnQrPJFEw62ULAxwvqhSF1+z5nD2QeWi29tEEmU4oybbbJenci4g69LuKvVRRIq5ox/TdJ1fReuRIYKAGSvVYRZnHG7jBzEXTCH7yOuckr7uNXC38xg7Zbo45aDAXPpvzCKs+khz3kbpiwkrYvX1lPs3x8i+diV0K8zB9OEuD/40+zdD5hkqd19ms25PgQ4xGMcfqg351Aa1QxiWfB5Mr4oyP22I60F37Bn1pqg/nib/iBDyunB1GLTOlVzFQ7cQ/SdmG/UipTc2eBpVM/sGGH9IrTNkvjeMj9flBIWORnc+b4w9wHQsrUT/db76WiRYg2dtO8HMifyyoTf8dlaM85wHoCLniItUhB/w5sFJ582tx0qnEdbCBhVGb9JGDPD7GLvKjC+Mo2wFBBVvTcGkn0mOlv3o6xH02kZ/4Y8GAzB/XMYm4S30GYfq5DaaEDvQHa76NFwj2jOsCi/noOWUXawLMcR4SY9FtzQkFUpB8DA3HlM4GwR7Xz6F663WKjqXUvj1gtjbvimBoGX14rxqOHcY/qQQjlybUFjKYCoKjpcAcp32YsHjEhv6Mnaj07NtLb5sWZ581Ey3NYbM4D4gEkPNaW9aUXj9ryefV1ExtC/pXMz45LIkzbCkTnOU7foXzzCXeQnNDX/RVRIJqKB6Ti4Yf4hk8CVGgDt+GiVZXLHSboaPAO7UIxshdtqYkCA9m6x/rBfa+4RSk+MNVDTPIYMRLIFyy0cTKEU4og5q0euuXzaYSbfy0rQso6rjd2uAO0XGzOZVs/FZ
 9G5cgjKy
 xqIzKEaCrLwr49cT1sLAD28JTYdldo7I5mSLNxVebuVV8AQ5nVB8uVKvR7XB4923KbYL2MMNSy+GzAG+SJzzS082ipu1lN1mqPv4XTxie52lq3nnVhowq494YhemYL/eJM9rXiPTyiHo2RCLp0zmN1kXWw81kPvrS0It4hEWkD+hJUS18foRPqKKgE2O27eqUCV2Y/ELN2ajPv4DzeZV+ZdphmAWjfVpLm5vBT/poA2/m3XcpQH4DJcyXZMEOE42wk4/A5eegfcs7afY+YfnTR/Q0M/6DJVTTAaLiIk2y2O+Vbj7qodJGzKtQuZsCZcJ/99LNYc1hpIUw2H1cOiK7avwU9EznMVPB7he854qi2/83r9j84sHl5BLyBsOOrKsazdhw3+utmRw6HLMtrXWFCLzOccl2O9VN2rGJNr3wz6/WOjXpRkuxDqjrOV8h6SUv4ThyGEg8++OwnhrwAT+a72oz29kcZFjhAwzpNN4voH2G3LojkYQ3Ctc/PemDGDHEvdfNjJf5sTBDxjeLHEFm/B8tjQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Refactor alloc_hugetlb_folio to use a local variable for returning error
codes. Instead of returning ERR_PTR(-ENOSPC) at the end of the error
path, assign -ENOSPC to a return variable at each failure point and
return that variable at the end.

This allows the cleanup goto targets to be used with other errors in a
later patch.

No functional change intended.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 mm/hugetlb.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 3395de4d0999a..68c21305fc86a 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2894,8 +2894,10 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	 */
 	if (map_chg) {
 		gbl_chg = hugepage_subpool_get_pages(spool, 1);
-		if (gbl_chg < 0)
+		if (gbl_chg < 0) {
+			ret = -ENOSPC;
 			goto out_end_reservation;
+		}
 	} else {
 		/*
 		 * If we have the vma reservation ready, no need for extra
@@ -2911,13 +2913,17 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	if (map_chg) {
 		ret = hugetlb_cgroup_charge_cgroup_rsvd(
 			idx, pages_per_huge_page(h), &h_cg);
-		if (ret)
+		if (ret) {
+			ret = -ENOSPC;
 			goto out_subpool_put;
+		}
 	}
 
 	ret = hugetlb_cgroup_charge_cgroup(idx, pages_per_huge_page(h), &h_cg);
-	if (ret)
+	if (ret) {
+		ret = -ENOSPC;
 		goto out_uncharge_cgroup_reservation;
+	}
 
 	spin_lock_irq(&hugetlb_lock);
 
@@ -2938,6 +2944,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 		folio = alloc_buddy_hugetlb_folio_with_mpol(h, mpol, nid, nodemask);
 		if (!folio) {
 			mpol_cond_put(mpol);
+			ret = -ENOSPC;
 			goto out_uncharge_cgroup;
 		}
 		spin_lock_irq(&hugetlb_lock);
@@ -3030,7 +3037,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 out_end_reservation:
 	if (map_chg != MAP_CHG_ENFORCED)
 		vma_end_reservation(h, vma, addr);
-	return ERR_PTR(-ENOSPC);
+	return ERR_PTR(ret);
 }
 
 static __init void *alloc_bootmem(struct hstate *h, int nid, bool node_exact)

-- 
2.54.0.545.g6539524ca2-goog



