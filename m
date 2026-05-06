Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA94FCD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 15:55:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6B1C6B0092; Wed,  6 May 2026 11:54:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1CED6B0095; Wed,  6 May 2026 11:54:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90A126B0092; Wed,  6 May 2026 11:54:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 78A166B0092
	for <linux-mm@kvack.org>; Wed,  6 May 2026 11:54:53 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4D5BA1C008A
	for <linux-mm@kvack.org>; Wed,  6 May 2026 15:54:53 +0000 (UTC)
X-FDA: 84737443266.13.FD53D39
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 34806A0003
	for <linux-mm@kvack.org>; Wed,  6 May 2026 15:54:50 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CvwEGP9v;
	spf=pass (imf25.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778082891;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k0SkXB2opvup6CY0oxdHUpfZyFS06lLmY6H2UymVerw=;
	b=uRzG0Nrsiqmar8BeWLFgrOrXnHCK4KTuGFHjuFsTSUVLFU8xiRgnTziI4Ca9qU5LbalLSd
	AfqemFOGlzZBp1/VZ9h0Ycs9eaI4+dglrZPcSSZBncr29TMHOzM4JtaIG9IghPXrdqk8qF
	4jlEY9jAgzxW47Cyocwhtu6QQluh86w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778082891; a=rsa-sha256;
	cv=none;
	b=kNYmUBTScTDVZ5uRL9/Pk7eWPZqkoe7qG7KvMMPX8pz5uSQ+qD8lck9QX43Vk9FeAG21hN
	fU9lhf7pFj4I+1JiNw2k8qXo5mAfnYEiraUx4LYW9lWkXI/bMEiNUsUkj/N2hRC9GCd7Ez
	R6ofQARKcbcqLpOZqi0obevcpPaEiSA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CvwEGP9v;
	spf=pass (imf25.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C1055442DE;
	Wed,  6 May 2026 15:54:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A03F9C2BCFB;
	Wed,  6 May 2026 15:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778082887;
	bh=Cjxf/EnKO3INuCZtalhdX+tplsTqxpNUbg9nn1buYwI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=CvwEGP9vLmFdRLhKLodlSbyf1vlagsSAcJNfXsa9FJgTWAHPFusFLc2BiFb9ddUr6
	 9WIStheQWKcOfx2O5jqQZVvKA8l36RqYe07OYPQ0BsRUEIIexxiwQgGU2YoHq0f+L0
	 ZXdSQMyZRWjCEPAcLW1v3gkrYXPWGbAnG84BvKBX2L/8dQQ7kOV669ZaUgMLsX+3YY
	 WSNHw0MJCGG7eOvQaErmkzVMCvH85PF/wdmUyNKH9ycfE63VYnzNJYZRhCBR77zkh4
	 M+AtB1ajHLW+TdW7OqOgn4ClWYs2Shcs5QZQQ7RkWSCjDerEuq5WxaHZj5bt1AVgpx
	 JXQ6sx6Z7linQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95B9ACD3444;
	Wed,  6 May 2026 15:54:47 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Wed, 06 May 2026 08:54:41 -0700
Subject: [PATCH v2 5/6] mm: hugetlb: Move mem_cgroup_charge_hugetlb()
 earlier in allocation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260506-hugetlb-open-up-v2-5-826a0c5f28fc@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778082886; l=2460;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=MPbeDKNyLcbnXQ1xH9ZoNE3gcjhnProATlB2NU584e0=;
 b=MOe7vO6p8nmK9LtfzZoHWqxWO9rab9/pRCiXIaTQpCsX0qT0RUFUF8USA1VfyA7gflpQBiBnN
 YGA/0QFBYpYB+KI9ayI9sSIXOmTRv/VCNKint5FcRJbYweNG5u6hQDt
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 34806A0003
X-Rspam-User: 
X-Stat-Signature: pjoysmdfgc1xorzppgtmjbpriomywwbe
X-HE-Tag: 1778082890-36261
X-HE-Meta: U2FsdGVkX1/db13XbrMedvfWczakNldNl/fUibjqKdgN4A/Nk2PoBNxxfhPxcoye0ONA8VKAJ74P35+Qcc8kpLWaOpbkKddVKaigiEcIJH23leL7ZszrtnOubvQoVd2trlxxgQT9KY8Bp28PkHjHVz9Ufj1URm7l8cVf12VKOxA/piJPVD5tyJJnzDCcG7qZV1yPG4hftMglypSQJZDBZRvJ8G/cGYtKlx+cnfRs+6RuZXG/o9fXNaT+ZJyoZzhdLzj/p2AQN68I/Re0ElM/TbRwq+sWh0MIRl41PkvcfaI28a65txRGaLuFRBXFR99RN1jSJDoOi+K/Usfv6rAkCyDil/BQngPoJ5pdy72L4kH4+9/aZBkRO4JnsCHLEKlahu6b6Cx+56MVNl8NNnB0qUEc4Daj4tJOmDiEVJnN1PIkKjR8w+cL4iRj/g/t+Alx/1La2JOcRx5yGxqu95YsKbIIVbuZY01NYhckjMjBXtNLirboT5wF8qXH0fFImVAZ+ueePkTQteF5RObDHD1DukuGZ+OKCMZf71NJMtPnesqgoqsGQH+5SecPI5SGYkWTTXjSPHtIqfw/JECkQkV+jkpDHisfjC8yHFS4wnbIcEJ4fL5G+42pphj4jBC+6fpzRPJIw6zbMswvnlqjZp9IcK2qzeut2tMTgc1Dr7THpJ7LgkF+rPI6INrjls3LgW506F1sf2DReKE7pxoCt+0+DacNbStFm/kNzSaGbuHBWf4viAskmSGlWUr6INcIWbfvUhFp8354F19NBOZ8NyhIptxwrtdeptPK+trO9iZtoaB4+4O8Z9Y1cLLef3oDfM2WAxMUm/tjfJ4h/MYPiDfmFZ3XGMeXxizS+rdM6Nsamj+yyZuy9Iu8XATTccfPqjuguyAXOu8U8tAxU9OHYQbBzzLq1wPZpyVeW9fG06+laGpdTbZJtD2Csbg1gVuU6ZfWATCWkBmKAH6EYIN4OdA
 RLj988G0
 PGfClTaBDLZdhm0Q+hApevKSklCx0xA0dWRNJuZBdVmRbYPCIL976HMcRtbBkUubTk1e8idVIHvX2rIYDHxItGz2pBIpPnWHiFyrHWUkrTUH+n7AzJonPhI8KoC2N4+KX7Qj25VFQAPuOxw7K7PknB+lV5KFp1W0xGIvG9F9LF4RHPVb+SqnXA7tmkY6eulTWnj7DDoAIwlQnO19Gok9+NQT8LP9zRM8Nt0kYbOoUTLrcecKI4nwqcd7zy8zVcfc42kpj7jRI0dUaC9VTWFmXUl4Q4bCvTnE6BP2F1KjDCe0AvwD8yrGgUgSzemwGqlq/G/LAELGate8MaqyBTFOeFtiPJjdp79uda2zjpXC972HDd1JNPMLHJ2W1rau204OFdSe2HDGLyvPl1ReKhUNrpWMwoew37omoxQbmTTB1fbR0Taa5ndL0t5r51h7ij8HmknwTmgRM1I/wkRCPCN+59yJtnTz6qpT2wkz1qy7vCuui1sahl7V1Aq2zgqe+bEGbomq4T9eF8sZKxPV2NY77eMkXig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Move mem_cgroup_charge_hugetlb() earlier in the folio allocation
process. This change draws a cleaner line between memcg charging and the
subsequent hugetlb-specific reservation logic for VMAs and subpools.

While it would be ideal to make all accounting and reservations perfectly
symmetric, mem_cgroup_charge_hugetlb() is a complex operation that cannot
be performed under the hugetlb_lock. Moving the charge to this earlier
point ensures that memcg charging is handled before the code begins
manipulating subpool and VMA-specific state. These two types of accounting
will be separated in a future patch.

If mem_cgroup_charge_hugetlb() fails, the code now branches to
out_subpool_put to ensure the folio is freed and the subpool references are
handled correctly.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 mm/hugetlb.c | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 68c21305fc86a..4159b3565a9be 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2975,6 +2975,24 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 
 	spin_unlock_irq(&hugetlb_lock);
 
+	ret = mem_cgroup_charge_hugetlb(folio, gfp | __GFP_RETRY_MAYFAIL);
+	/*
+	 * Unconditionally increment NR_HUGETLB here. If it turns out that
+	 * mem_cgroup_charge_hugetlb failed, then immediately free the page and
+	 * decrement NR_HUGETLB.
+	 */
+	lruvec_stat_mod_folio(folio, NR_HUGETLB, pages_per_huge_page(h));
+
+	if (ret == -ENOMEM) {
+		free_huge_folio(folio);
+		/*
+		 * Skip uncharging hugetlb_cgroup since the charges
+		 * were committed to the folio and freeing the folio
+		 * would have cleared those up.
+		 */
+		goto out_subpool_put;
+	}
+
 	hugetlb_set_folio_subpool(folio, spool);
 
 	if (map_chg != MAP_CHG_ENFORCED) {
@@ -3002,19 +3020,6 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 		}
 	}
 
-	ret = mem_cgroup_charge_hugetlb(folio, gfp | __GFP_RETRY_MAYFAIL);
-	/*
-	 * Unconditionally increment NR_HUGETLB here. If it turns out that
-	 * mem_cgroup_charge_hugetlb failed, then immediately free the page and
-	 * decrement NR_HUGETLB.
-	 */
-	lruvec_stat_mod_folio(folio, NR_HUGETLB, pages_per_huge_page(h));
-
-	if (ret == -ENOMEM) {
-		free_huge_folio(folio);
-		return ERR_PTR(-ENOMEM);
-	}
-
 	return folio;
 
 out_uncharge_cgroup:

-- 
2.54.0.545.g6539524ca2-goog



