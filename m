Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C881C1090225
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 13:00:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D3C16B04B0; Thu, 19 Mar 2026 09:00:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2369A6B04B2; Thu, 19 Mar 2026 09:00:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 173DE6B04B3; Thu, 19 Mar 2026 09:00:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 044C76B04B0
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 09:00:34 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BC121BA00C
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 13:00:33 +0000 (UTC)
X-FDA: 84562821546.11.127EB92
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id EC79B18000E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 13:00:31 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mHFF5QM8;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773925232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k2IAvajY2KuWSe+YBYMYlFU4G7wDqXu9hSrpYjLB14A=;
	b=2xbMEzIvpesD0ShmTxJR7/GNWleMXY4hIdW8slwpEImzEnlZRfRtuTZ/IJNiCGMci1HErb
	SjaW8oMiWcr51pB0z62cEhfWToQfRZuOKu2ksIFmzolEYOhHsNO6j0gQRt+zJZFndTAxzb
	epwXJ7QCeIqQROaCb3yt93+ByR5/R4s=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mHFF5QM8;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773925232; a=rsa-sha256;
	cv=none;
	b=HF+sthOKNJk2B5s9hD5ruvPkBML7qrJFkKlDOxE6U3TWPXGnCtOWkFihAo9ibSMQA7JtTo
	nnheJJEmnn9ZObSSizih+FPaqhKQhlb9enuxMnnptQ/9iHuT33BOmPH8CrnL2N7DzK8+l9
	JIz7G608DIWArEjxazVqavo0HtPCUgg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0829144539;
	Thu, 19 Mar 2026 13:00:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74475C2BCB2;
	Thu, 19 Mar 2026 13:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773925230;
	bh=v8lQVzkXwOo8XYwemfH0T2OEyL/5prtqwnB27T50syc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mHFF5QM8KYtYSTUl9vwuuKfFVITJcxtqGlTi62Obtb/ntJBkSFgkeXrXy4eKXorq1
	 56X7Hl7ESr5wFAmWaIpIImWovr77yYH/BCSq3fPGdjv9z2NOz5WNxAPOEU10ONZpWD
	 gUHWg6DH+pv0SuY77oNzZpUZVrSa35vLxP/v4Nai+6+b8rmugbDSU8hF8EACK/URpV
	 D99vWxvXBuAc1POpvcy+fc+HAwuiyuTOsY2zPA8RrPuVVtqF2Ah9HhY66Uzm89Giqd
	 r3tv4ODzOkUBDkILY1T7s2Iy7ln6VjRK9QkpfDOWl4t6aEFB3t6SUQTIcQ1DQWtnu+
	 Gfvk8A25K/lGQ==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/9] mm/huge_memory: handle buggy PMD entry in zap_huge_pmd()
Date: Thu, 19 Mar 2026 13:00:10 +0000
Message-ID: <1ec18767b106a1ee1ed6e33e332c3ad5531dc636.1773924928.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773924928.git.ljs@kernel.org>
References: <cover.1773924928.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EC79B18000E
X-Stat-Signature: m3mh4dpeuk13gj93rik5kw3ucaxnuw8k
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773925231-545005
X-HE-Meta: U2FsdGVkX19cf2Kwhyd7oanZLTFNjYgcSKdHTUZQbIg10X0HaOFzHhVz73zBWbRVfzzPzAsQ3KO7I56APT4xkJHJgKx90wZc4PsqAhlBixBR8Xz1xRuE2T4wuIgmgUh2XfijYx2GsDsKFFgUFeEMQQ6iN+lCqWrzVOAX1QKobepvcKo9HcVlAYKHImBzrQmEmAlmtAsNsD6As8BGkeppXYeZ2cEnaZiQcRyyMOSXkFeJlbnQnpgtOx6Mq/W7EDVT0WVSit2g4nFDxb1FuOe/eWWuzMPcoFXtUYJj+JDclMTclozVcyNbokqeGEXL1uUz6kxrmbabxGZzSe29j0gwNpZKuvll9GlDooVQVrQMICRoTVKGD92LL7uDaB4I+VsEfa6l0IGyqbybOLLq5o+0G1TnI0+54LUNM3XAMTKtTk5/B6Cj30N/0lucOFxahCP8Aug+x+VfLBvA/Nk5aO0gQUIeLSXxizm4aDw+CDFdgE3CXYg6L2vlvPx0rbEUUNW+vKCA6JxK7+ON3BcJeeb7B4Oqbj9j+2EsHSh4Gsi/cAT6WvPdnVqRReOIZnV0xzUIhK/xzi5aIs7YQAXXV0xg+KLJ+F3v1AAy9STmHkKur2JCxRnwg5D1Zp21Oc4DFm5Ux8Kqlc25Y9DzmU1eB4kSt4lCQv+EQ/lFUnci7XGDYF53JwEDtzekC0p8aFTr7Ylg2Wwbtxh/63z+3MTseAfcF4dCwvAPnrLdKYzscasRkcv541OcU6+GDawqpTP91fv4DnxUnAFR/40IlxCHl5fcsCPulW+iLcoc/TU8/7dqWHPV3foGRgedk9O/O61o8zie1pU8DMQ06ZLjmj+1vrd7qzr/eCcOSFEEHRJ2VswJewFTeRWWXE3CGCW7F5G392wlEXkj8pzA9ekB7hQVWJ90WZcg64E25Ra4Brv9VbT23riHMjGlfjoXLMVNqSnNZSHFwN+WOZTbxu01qKKUQpT
 Vh2c0RUm
 tLwgVqbL3Zdfp6cXl3zsLBIM8NuByIYPf/E5q1ja2MUenbxWyBk1Ew8Co7CTKmbuTBSBIglnPM6Fy+r47CUiht6GcjpbPlXiwF+Hj2nkfN5cbJFOTr9tNIXqCXoFB1I4eunVGsvGqmM8xLZAvTmpmlA0sqV7xUa5Q5uBLDc0W9yyszTNAldSMqHogqAeaVnsWoOrTTXgDrHLeoPepyFpdbPoUADILXlDG8uLxFQ/MZVRNBG5GtstdaiUYndTnVNjAUoZQBPUL+dNwwW5Zqmz0iGCTnQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A recent bug I analysed [0] managed to, through a bug in the userfaultfd
implementation, reach an invalid point in the zap_huge_pmd() code where the
PMD was none of:

- A non-DAX, PFN or mixed map.
- The huge zero folio
- A present PMD entry
- A softleaf entry

The code at this point calls folio_test_anon() on a known-NULL
folio. Having logic like this explicitly NULL dereference in the code is
hard to understand, and makes debugging potentially more difficult.

Add an else branch to handle this case and WARN().

[0]:https://lore.kernel.org/all/6b3d7ad7-49e1-407a-903d-3103704160d8@lucifer.local/

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 mm/huge_memory.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index bba1ba1f6b67..a2f87315195d 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2478,6 +2478,10 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,

 		if (!thp_migration_supported())
 			WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
+	} else {
+		WARN_ON_ONCE(true);
+		spin_unlock(ptl);
+		return true;
 	}

 	if (folio_test_anon(folio)) {
--
2.53.0

