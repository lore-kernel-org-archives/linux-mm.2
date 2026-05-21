Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BFB7CD5BAF
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 15:04:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 528E96B00D0; Thu, 21 May 2026 11:03:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5002A6B00D2; Thu, 21 May 2026 11:03:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37C2A6B00D3; Thu, 21 May 2026 11:03:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1891F6B00D0
	for <linux-mm@kvack.org>; Thu, 21 May 2026 11:03:59 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C776040644
	for <linux-mm@kvack.org>; Thu, 21 May 2026 15:03:58 +0000 (UTC)
X-FDA: 84791746956.26.27BA504
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf22.hostedemail.com (Postfix) with ESMTP id E9EC6C0021
	for <linux-mm@kvack.org>; Thu, 21 May 2026 15:03:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=JRAPlhPb;
	spf=pass (imf22.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.177 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779375836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VJJEuZOvug6rcak+Osyt/tu7+OHIrKr4x7Xajjb2SaI=;
	b=quQWJgiCVwM76PMGWr+/5yhDPynA5kCx9fSUZUMrCZcONDY0seZtMgfoDF6RZrD+xTBn7k
	JIinCLDCHWrHtYo5rCpnrvqBXgTzAhjSy3O78GSYkz0c43e7jzHFprwUE0glpRwpVq7xe8
	6G2gL4hheuWBxN74Ki348g33mqWGvas=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=JRAPlhPb;
	spf=pass (imf22.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.177 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779375836; a=rsa-sha256;
	cv=none;
	b=KHvvq7d5Ra7tCVMV+twWcjXmaJ/ASTqTGc7hjSaXcPDWp59dYIE8oqnusP/YPzMXy67k+g
	020zRQUKZ55TS+KBjBYuLsVVcXVphnWOypCCX88ivbUakUQCN57qnoHWMYHFh4fh5Q5nqY
	ZViggcfPtilHkW4w2nuPTfwZYvc/KDk=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-50e5bea4045so47271211cf.3
        for <linux-mm@kvack.org>; Thu, 21 May 2026 08:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1779375836; x=1779980636; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VJJEuZOvug6rcak+Osyt/tu7+OHIrKr4x7Xajjb2SaI=;
        b=JRAPlhPb33c0dHLLaJmkHUVl44A9ibBH6WDxEXNcDlMUgz63AXlLjB9eyeDdyGgz+l
         sUTEeLnsMIellNNcTKAIPPv9iQRWYK6ftQ7/eOzX2U+BHke9RgPxDyJlRkkdxbQKNzR/
         t2ij8wUg4KdpYuEdRebrRyvZl1sA55yLudNACVSmsY4iLKUMGypjuTNvdZTN4mnFnrzl
         2QTiHrxw/tVd+3pOPys0hAWIP0ylnDB+40CrCvnyGPk4j2v9g6R1dEFB8+zcG5Qyyyug
         x1qxWJI2mtcfwL79lCaF8uV9Ckz2zZKJ5pKODt6C8CaAHUzIwsgEsqkAappYDhY34vSH
         /VGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779375836; x=1779980636;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VJJEuZOvug6rcak+Osyt/tu7+OHIrKr4x7Xajjb2SaI=;
        b=Yva4RWpm3hDvzgaMeKqbOcn+aCjaE4qlUPcGLHhgyUQlWy4ikvMAuGRrAJLSviVAIv
         zzv5lQAJo4e0iCAd07g6TCMG4kD1ZhWEvTBnnNGPOhhsvOusBRC+ScJINM2haYV6Oqez
         0RU7z0Pm4UUOmAM0n/OFtcYfrq+e1hmh0jYMmf4Y1iK5JKTbP3q0lsbBNBxHVRp7/b5C
         btsD/O7sco8RUG2wm+Lqx9odPlgCJFEG3LyULOFOlm9YS99qnVd9jKNvAAczwf5OAZAt
         Ns5EagLbEXxnPcYd2dH1DF95AOfmU0TL0i91LLMR7rUwPMOZwPvSVk+Vszor6uOLP7CN
         wPTg==
X-Forwarded-Encrypted: i=1; AFNElJ//yuCCI6QwnJoYY6jmoVuQTGUOl6dgHbaxmUORNJuFMojOUApCB/wl6JflJNVL/ltGPKEgOJnoYQ==@kvack.org
X-Gm-Message-State: AOJu0YxKnD3QtdUlxHZwEwO+R7v+qBPwkTcOCs/AzygED1u2/Ek1I9lQ
	6TxS7OzCvO1ApaMAFhc2eANI3jJpmjuB3xbuXcJUv5gH21o5gAI8UiPG9lnzk2wKy6M=
X-Gm-Gg: Acq92OFLqnJW061iHyKea+V2F8LMhYM9nyD06H8KeQx9kVyI8Jo6NdWgYjCCq1BskPN
	U2HYGzr/vuOtHPFzz+yVcEMv8ZDonozk3ezem3+kHMcDP7z8wOEYruu9oQDkcn+X3BZrJIscrbx
	/kryZupRJgOTMX94diyn08xDO8fwgHnx1H1zSXcW4/whhAQOluxB9pdnQo9dQzdArRp77kRH3vT
	F49N0llRhSIfnDDSYLUJMQUCZzDUy7fplHA4KgWDWoXi0NWBOpzxwIx9SEgRGbaK53ZAci3XgCZ
	vI1cMGKyJPUe7awPfVeie/eAM+NZhRCJbqWuxaNKhXxSGO4hqwz8NdfVHGUB5BArabpdZofCfkW
	95jv/pKNzUoA3r7BgpY1q8mnBdmxOihue2ICr8cBkBxzAqWx3z5262RBrcOjlzvmnqoOCzh8ANh
	XAo99xVpijYkCuq36kL20/Hg==
X-Received: by 2002:a05:622a:608f:b0:50d:860a:8fb0 with SMTP id d75a77b69052e-516c54c70e8mr41818231cf.21.1779375835903;
        Thu, 21 May 2026 08:03:55 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-516ccba5ffdsm9169611cf.5.2026.05.21.08.03.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 08:03:54 -0700 (PDT)
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Kairui Song <ryncsn@gmail.com>,
	Mikhail Zaslonko <zaslonko@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 7/8] mm/memory: flatten folio allocation retry loops
Date: Thu, 21 May 2026 11:02:13 -0400
Message-ID: <20260521150330.1955924-8-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260521150330.1955924-1-hannes@cmpxchg.org>
References: <20260521150330.1955924-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E9EC6C0021
X-Stat-Signature: gmmfxwsouzh37quzctpnhu1mqrfeqesr
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779375836-27302
X-HE-Meta: U2FsdGVkX19VwPzNRiQCwCfoRpvUTPKK8/D3BJG7R1/dnp6Iq1FPsiXR4Cznb512/4EcP6bnD99tdRAeD38K83CZyNgGEF7n/SycKbC5dldPdyuXbHjYomUEeRNrYNgfmfVLfj8UGYdM7rEDsTtmNqhXdMV6jBwmQFGhAzXJ8HjDrQXOXjs6zStz4ePT4oDkZhN4bmFtT6eZe77yUmjx5yN1VETSKFSoqkNxj+s7hmovZaShtbPAI/O+/8kx9FL7dN2nKxYuxXzzFHebUNVIARVJWeaN5xVhLpMF+KjQFu7+fJUlPvYn7mNWkAug2Lo5IEBvEHEZMJU0oSoxCLfimGxy9gAE4zLtQIV4YrVdgtLJa6JbuL9xy1573AXvqIqTxjzV81K+B2tLrJ0KJlh2QFVQ4QbDJmv1Io+BcnHEgRcJJhR4GJ9N25UAwW3hAc85kSO6kDpTfMJFUnArhiI0EMFiJaSaFhS2wR6ir5qoA+lP6HVrn3paftGLXV+3urqAVni9qCTi9T7jvJOZxEdBPYnDWrr/fN7pfdXz/n/eFDg/xE0RQk1Jnc1yQW8EfeGoEmesVsbmFTPC9vMjlvAk0rQ6FfAo0qDkuxJjn3aFkAwN/HdWEc8Oans1EyklSVn3yz6sCWZ0jkKC7/Q8uQdyqYtZtkRkPSqtkMOmMa/FPCGJAkZeq+mb1g84wjEYSBjdODsmRCr3nUHiBkMSKf/YP3hz4rrdXMJTcJa8YnX3itK0pQAJCvSsOgSG3sTSZkecbTd75S4Gx8kjGx3rMkuZSX5JUP3tyJdFPO5bYQuxYwfjda5dx1rXXz9auK83RPScmCDt3dEevcmbRIFOEA6PToSBgC617a9GOFQgTB6bMmg14yR2CH3dq9vetMImGF39wSWNasf3ka6p5FG8eb0CxZpgvS5oyKS4EimZoC4WQ+KQzAEhdx9dm6bj21g7cV7l0+YWwlD80E20QjiBtLz
 wdamnhmB
 toXfw0bSJjOW9lFRZ1gUmLcu3iUi1BNofvHRFcmemziasAx97ZxtvY5eUpKeaIvtpA1G6v0PuXYnBbw2O2hLxU82GlFle8oIgiREbdrIH1GoZVevxgVtrjAh8d6qAFEZrNz7ES+37Kmrs2w2Vr1djbl2uZ7NH991umnhmCSxuz/iNLU5eR/75V2fqA1JrL5G6WD1RYZy+1LncMJaXLMiFvlXKpnxDteN3z9TRbZQLG9DUj8LQPpWWSzS3kIhWkQjfPWsH4tWBS6PEGm2CxqMqC6G+vHEfQDXJBSGiKns7Le3GL7c6q2vxlXmLKpf1uRKe7E114nEAyVUnAWh6lzGFxTUy0LQJwtpdcJTe3MkrVYS3MxMxQAET19qthzgK0cC/vNFzfruqZM1QhAYT/xnI0Qpu2uYY6gdJDAWl7VXYXGrHJT3txz/qQFyzIFTvNd9uagdw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

alloc_swap_folio() and alloc_anon_folio() use a top-level if (folio)
that buries the success path four levels deep. This makes for awkward
long lines and wrapping. The next patch will add more code here, so
flatten this now to keep things clean and simple.

alloc_anon_folio() already has a next label, use it for !folio. Add
the equivalent to alloc_swap_folio().

No functional change intended.

Suggested-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memory.c | 44 +++++++++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 21 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 0c9d9c2cbf0e..552fe26a042a 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4752,13 +4752,15 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
 	while (orders) {
 		addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
 		folio = vma_alloc_folio(gfp, order, vma, addr);
-		if (folio) {
-			if (!mem_cgroup_swapin_charge_folio(folio, vma->vm_mm,
-							    gfp, entry))
-				return folio;
+		if (!folio)
+			goto next;
+		if (mem_cgroup_swapin_charge_folio(folio, vma->vm_mm, gfp, entry)) {
 			count_mthp_stat(order, MTHP_STAT_SWPIN_FALLBACK_CHARGE);
 			folio_put(folio);
+			goto next;
 		}
+		return folio;
+next:
 		count_mthp_stat(order, MTHP_STAT_SWPIN_FALLBACK);
 		order = next_order(&orders, order);
 	}
@@ -5270,24 +5272,24 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
 	while (orders) {
 		addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
 		folio = vma_alloc_folio(gfp, order, vma, addr);
-		if (folio) {
-			if (mem_cgroup_charge(folio, vma->vm_mm, gfp)) {
-				count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
-				folio_put(folio);
-				goto next;
-			}
-			folio_throttle_swaprate(folio, gfp);
-			/*
-			 * When a folio is not zeroed during allocation
-			 * (__GFP_ZERO not used) or user folios require special
-			 * handling, folio_zero_user() is used to make sure
-			 * that the page corresponding to the faulting address
-			 * will be hot in the cache after zeroing.
-			 */
-			if (user_alloc_needs_zeroing())
-				folio_zero_user(folio, vmf->address);
-			return folio;
+		if (!folio)
+			goto next;
+		if (mem_cgroup_charge(folio, vma->vm_mm, gfp)) {
+			count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
+			folio_put(folio);
+			goto next;
 		}
+		folio_throttle_swaprate(folio, gfp);
+		/*
+		 * When a folio is not zeroed during allocation
+		 * (__GFP_ZERO not used) or user folios require special
+		 * handling, folio_zero_user() is used to make sure
+		 * that the page corresponding to the faulting address
+		 * will be hot in the cache after zeroing.
+		 */
+		if (user_alloc_needs_zeroing())
+			folio_zero_user(folio, vmf->address);
+		return folio;
 next:
 		count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK);
 		order = next_order(&orders, order);
-- 
2.54.0


