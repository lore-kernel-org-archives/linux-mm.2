Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9236FECD6FE
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 00:37:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F12C76B008A; Wed, 11 Feb 2026 19:37:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFBA96B008C; Wed, 11 Feb 2026 19:37:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE8E36B0092; Wed, 11 Feb 2026 19:37:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BEE8F6B008A
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 19:37:32 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 664941405E5
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 00:37:32 +0000 (UTC)
X-FDA: 84433941144.10.CD40A51
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf30.hostedemail.com (Postfix) with ESMTP id B0FBC80007
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 00:37:30 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=OUzZCSzf;
	spf=pass (imf30.hostedemail.com: domain of 3ySCNaQsKCJIwy60D70KF922AA270.yA8749GJ-886Hwy6.AD2@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3ySCNaQsKCJIwy60D70KF922AA270.yA8749GJ-886Hwy6.AD2@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770856650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7+fyXiA+m57FzuXOpgMoIQnVFz3nHsjbKsXBY1bNSP0=;
	b=lL8KoTjy/H9UGRkMPTYwCWcnhSsu+SSVpkwDCfElXAGEaswq8WnLxoXy/LwCb6DMjJpgyL
	/Y6faTsB9N9wU5JEW8Nm11pPHRBS0rsHEyaFwRMxvXAkXZZcubsWSwZVCjUiCtrR8emcVC
	Fvij3XoQzOVC85s54cWrYotT9xoyHyQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=OUzZCSzf;
	spf=pass (imf30.hostedemail.com: domain of 3ySCNaQsKCJIwy60D70KF922AA270.yA8749GJ-886Hwy6.AD2@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3ySCNaQsKCJIwy60D70KF922AA270.yA8749GJ-886Hwy6.AD2@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770856650; a=rsa-sha256;
	cv=none;
	b=dMrCD0OnSuEUSKxQfyG5zDmeDXsBAaADIJr1+5gb+A03l6WQUc4K3dFW7NdzxPtXkCSBwg
	e/6uPGK4cAEN7bq/Ahli3fuwrCu64oEPyB0M+Wqr2RGJ9DRI1NuB0GrG4iQSxDSl5dF4et
	MNalkaudpDFt404f0bH99aa1J7dzopw=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-35301003062so16219919a91.2
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 16:37:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770856650; x=1771461450; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7+fyXiA+m57FzuXOpgMoIQnVFz3nHsjbKsXBY1bNSP0=;
        b=OUzZCSzf1Z2SlHhLsq5jLwhtB1uoCQxoaELAQz89RdwnP2/hB/KbHIBSJPQ8oJF4Su
         Aubi3rkpkPmM62tklXWxJmECXjOC9Ieb40RVX44Kf+9BHaCbzU8wqjmum/l9hOfRrTOw
         Lf/O951Qtt6NnOc/LBxjcsYi36JcRlgwmOMNoTckUMxN6A71uhvKh3MWf1QvEgzI3JZ+
         CQBp4+WvCndi4nbsi2FLvpnir7rXg51xAy4X4uo0fKsjMGNPxKN0W7bQh4STojD7phy5
         9bdJ0LhhtoQJAHAGgF+jmjOqMpvNMFwOX932gmbE64nRLDHgcI44FZmzfknM2wndRbmP
         AMtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770856650; x=1771461450;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7+fyXiA+m57FzuXOpgMoIQnVFz3nHsjbKsXBY1bNSP0=;
        b=XRBIVl7jvZvwKbcx3igeWMF3gvyR7apW9hED+0Qt8SZX9RAADwI0hWD6t0t3EL0hMS
         TEswJfdM7VuOv/xyk5Yd2rZQ+lrCJbRloJPpg/ZjtjJf9ebmJRyjBc1EzcAXU+vIawjc
         Z7ej91tOBw6H3jkG28NL7DGldyLatrM88NTN1OnRJeFjT4sUesE0BSwjCocVu2ghjMbk
         sos/d9pko5C6lgXraXftstzlecn9cVMN1Gxw3qrWAWYBdpWI8MVLJIVQIoPoAbK3D+u8
         /ce5rAxf+uJSOIQUq51sNoEcROKbdL173a8QphZiRV2kc3W4mu4dknCLeCR8I/QBgEb7
         ydOQ==
X-Forwarded-Encrypted: i=1; AJvYcCUyys1fRHytf3pTGPeCn87F7s+WJYIQUD1VUf2mowdGF5smV1Z4tcxFx6BXck5xpIbwUwHJ71cq8g==@kvack.org
X-Gm-Message-State: AOJu0YyGWrDSbTJGFvHzEjWrW5PRo2c1awMGhEnCOQtpZEwqzOiKO+O0
	N8DlOeljfq1NHynwDXc7QnyO9N5o/u1fp9lP02JZ5QUykGIGiNadVpIU9HpvyYZwaDg++Wj6e+E
	yonmRmfpgEHzINXSCCGMdRwv6OA==
X-Received: from pjzr13.prod.google.com ([2002:a17:90b:50d:b0:33b:51fe:1a73])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2e45:b0:32e:7bbc:bf13 with SMTP id 98e67ed59e1d1-3568f52e24amr904712a91.34.1770856649529;
 Wed, 11 Feb 2026 16:37:29 -0800 (PST)
Date: Wed, 11 Feb 2026 16:37:13 -0800
In-Reply-To: <cover.1770854662.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1770854662.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.310.g728cabbaf7-goog
Message-ID: <18dbaf2ff9579b285d92f26b9a69e1e302f3bbcc.1770854662.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 2/7] mm: hugetlb: Move mpol interpretation out of alloc_buddy_hugetlb_folio_with_mpol()
From: Ackerley Tng <ackerleytng@google.com>
To: akpm@linux-foundation.org, dan.j.williams@intel.com, david@kernel.org, 
	fvdl@google.com, hannes@cmpxchg.org, jgg@nvidia.com, jiaqiyan@google.com, 
	jthoughton@google.com, kalyazin@amazon.com, mhocko@kernel.org, 
	michael.roth@amd.com, muchun.song@linux.dev, osalvador@suse.de, 
	pasha.tatashin@soleen.com, pbonzini@redhat.com, peterx@redhat.com, 
	pratyush@kernel.org, rick.p.edgecombe@intel.com, rientjes@google.com, 
	roman.gushchin@linux.dev, seanjc@google.com, shakeel.butt@linux.dev, 
	shivankg@amd.com, vannapurve@google.com, yan.y.zhao@intel.com
Cc: ackerleytng@google.com, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: y1k1zfohhx3ta4ujf6u7snmrgbe181bm
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B0FBC80007
X-HE-Tag: 1770856650-188541
X-HE-Meta: U2FsdGVkX19M9PwR/4PhdA2WWSgYNILLgJWDwvNHYoWMfD5Z1z3Mrt7eg/cVwM21k7QPd4WfQ55cmVzaFo2x1kdYekk9UgGim0kLVQhdfJb3Z0W0EYYOR0i0dSeiyheeQlT/ZJMwt3T9WdjrArDZtijDIfha9qfVcPZYpu0aa05Z0Nz6bcy2tMJkqDCTNlAJeYEOD8Ls7+LDup532ALRBiBcSshyhrotLef1poaY4JUm3z1c2ZvZrnoTLHtbV+K+q6GTnFEsDzSjDMr1DuwI+CgnauVsJFjof3GqCiGLx3HrKbEUhb/ebhxAeqk2WfZr9o4awPtUa7aDc64MiNRj35p14EXahoTFxpJ+Zq5JWssKfhjpXcU2TSAlxtq78d6EAHyKbE3AKLXh27iB+9dH0Cx0j5drZKqlQEQINNPQ/1gr487+0xKkOQXxVjUlboIbnJ+iVJagUnKekwHeANXVa/v5fvU57oMtWhXKQoYoEpWTvO7Qsh2uNQm+aiEwe4FHuPVohuSNMYbagMf5faq3bq1VOY5Ya8l18b6QcZoup0tQzbckiYEtVSWsuEau5Om7f9EKCycFpeDg2U/oovVWi2VK0ETr+ysP8L0gASm6YjKpidTSxHb9Bu9UIr9hysI0vCSg1BYAsHC0fUO5WITP4KzHtlteN7KhJd05Db7q612LIQ1/uoAU74ZJDrEjIrkL0bm2kEBfYDEDwdZCf/8yMTNWHZIb6vqb8CyH/BXO7KLZrmlNuLf3RqpYrZchjeDKtwVASCr49SgaGYIoOJWMLgSQO0oQj3dM0gaKF2Q+p+WeAFKIvN4sVyQ0A6OCQbuZkCIp472Q96QPiCoQO3Qphg7ZeZ3rh2mMrJkWRN4G54+bbXilpXPiivDIe8uo6Ex0hFUWeSIwYys6VLW1jGe+0hSaSy7jFyqKRV+v8GAf4p1SbUJA/bleWHOndWd/5gQ3uspGyPFKwLNkvvvYLYE
 GmE+dnPJ
 sFrPPwpczp63RkeqCco2kIotoGb6UDlDkHusLWwO3WFo5SomLPwWfOU0UaoitvoL50uWR6hbL6lq9oXd/ziDcRi5mYzzDiHiUsoPlUvnO5zM8dz+45LxMYuSisb70as4sSpWqbWJ0GlEBisQl3fiX+UFd8+3qR97D0lh8dmukBN0RTfh/QFSwbTN55RLYf6Q1rqylxkPnIy419eZAqq2dOLuECsMH7/JS2H6rSRS/5jdpJRfYBDnwkak2XPdS5SIsqqfPsPIcmCnMZp2/zIHRuhv6OmOsT3/j7WZ6YRcAybeot8EWJiQet8tVbv/dinjIZYCYvyUFTZgI4IHIZtD5om10w7icHlJGmIH6zyl31qQe97XJ2AdUjKBNjQm/nf2YFt8B1kLyN7JWitKvoUAXP49+YmeISZbyr7VoKlUHIVgINS7GLwEirK/xRBwqqGixOAzPzunHINPzJ9JUwCPdQlK6ARdS5odMHN7ohWuIpjECcN/JEwMKuBQ0YyGU96OJWxTrM0yZpge0VdRH4iu+9MPR6TR6rlT21o8sy0h9wSdUnsUlpvWI4S8Ei1JEGHXXMN8/NDo0AqcQ++38BM1vmAF2sFxUWog8iMzdBlatyp+JAtg+bNqnCdWqUhUnT3YVpIHMEe+u2jz3vwuaxmD375V9nz9r1DQLghSy1TxjUqy5r8vOMlHddi5lHA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move memory policy interpretation out of
alloc_buddy_hugetlb_folio_with_mpol() and into alloc_hugetlb_folio() to
separate reading and interpretation of memory policy from actual
allocation.

This will later allow memory policy to be interpreted outside of the
process of allocating a hugetlb folio entirely. This opens doors for other
callers of the HugeTLB folio allocation function, such as guest_memfd,
where memory may not always be mapped and hence may not have an associated
vma.

No functional change intended.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 mm/hugetlb.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index fd067bd394ee0..aaa23d995b65c 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2223,15 +2223,11 @@ static struct folio *alloc_migrate_hugetlb_folio(struct hstate *h, gfp_t gfp_mas
  */
 static
 struct folio *alloc_buddy_hugetlb_folio_with_mpol(struct hstate *h,
-		struct vm_area_struct *vma, unsigned long addr)
+		struct mempolicy *mpol, int nid, nodemask_t *nodemask)
 {
 	struct folio *folio = NULL;
-	struct mempolicy *mpol;
 	gfp_t gfp_mask = htlb_alloc_mask(h);
-	int nid;
-	nodemask_t *nodemask;
 
-	nid = huge_node(vma, addr, gfp_mask, &mpol, &nodemask);
 	if (mpol_is_preferred_many(mpol)) {
 		gfp_t gfp = gfp_mask & ~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL);
 
@@ -2243,7 +2239,7 @@ struct folio *alloc_buddy_hugetlb_folio_with_mpol(struct hstate *h,
 
 	if (!folio)
 		folio = alloc_surplus_hugetlb_folio(h, gfp_mask, nid, nodemask);
-	mpol_cond_put(mpol);
+
 	return folio;
 }
 
@@ -2892,7 +2888,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	map_chg_state map_chg;
 	int ret, idx;
 	struct hugetlb_cgroup *h_cg = NULL;
-	gfp_t gfp = htlb_alloc_mask(h) | __GFP_RETRY_MAYFAIL;
+	gfp_t gfp = htlb_alloc_mask(h);
 
 	idx = hstate_index(h);
 
@@ -2963,8 +2959,14 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 		folio = dequeue_hugetlb_folio_vma(h, vma, addr);
 
 	if (!folio) {
+		struct mempolicy *mpol;
+		nodemask_t *nodemask;
+		int nid;
+
 		spin_unlock_irq(&hugetlb_lock);
-		folio = alloc_buddy_hugetlb_folio_with_mpol(h, vma, addr);
+		nid = huge_node(vma, addr, gfp, &mpol, &nodemask);
+		folio = alloc_buddy_hugetlb_folio_with_mpol(h, mpol, nid, nodemask);
+		mpol_cond_put(mpol);
 		if (!folio)
 			goto out_uncharge_cgroup;
 		spin_lock_irq(&hugetlb_lock);
@@ -3023,7 +3025,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 		}
 	}
 
-	ret = mem_cgroup_charge_hugetlb(folio, gfp);
+	ret = mem_cgroup_charge_hugetlb(folio, gfp | __GFP_RETRY_MAYFAIL);
 	/*
 	 * Unconditionally increment NR_HUGETLB here. If it turns out that
 	 * mem_cgroup_charge_hugetlb failed, then immediately free the page and
-- 
2.53.0.310.g728cabbaf7-goog


