Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58E8D1077612
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 20:40:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD3F26B0322; Wed, 18 Mar 2026 16:40:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAC0D6B0324; Wed, 18 Mar 2026 16:40:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE9686B0325; Wed, 18 Mar 2026 16:40:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9C2F56B0322
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 16:40:12 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6F458B6411
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:40:12 +0000 (UTC)
X-FDA: 84560351064.21.2436976
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id C2E77160002
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:40:10 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A+LWPAJd;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773866410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OxofV8F3YCOot5SdT0ZJxvSa8TRTLRUaE2caKyE7rpM=;
	b=8UyLpLHWtRyR09/KTaZZUlbPoIJYCSz8O2H7fyM0HDdkLLJJtlcRuHIXFaRmq0VE8HVLWn
	+WJjONluVYzJ/Z11WRWa7OySfsa+B68tZ3SkiS6G9VlcySy2Dpad9MXAJvA+P76omuV/4d
	ER9iLlw4ivRUT/ygBmX2Prgeyf8Wu1A=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A+LWPAJd;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773866410; a=rsa-sha256;
	cv=none;
	b=2fjE84uvFxyP1fdtC4Nm8rfyGqtxm87TQMOnOKamOH4Ic0Z0VSs+NA0VASBd71PppxqhhO
	8VbX+2heY6mYh1dZmKS20jUOluvZlwK/xE7CZd6nAJYV4n/8iHJVjfnOH8BPD90vXcBorD
	UCJ2T4TQiZQmclYLaJi1u4o0gx9M+M4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3E01761852;
	Wed, 18 Mar 2026 20:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99554C2BC9E;
	Wed, 18 Mar 2026 20:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773866410;
	bh=4hGJuEdcThcMdbeM2AM1MWkN/V5ubnZTBsubak6jBD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A+LWPAJdQaFkpuzW67ZvVhCebOVm8I33QNmUh9lnf2px0US1OI/uyMqp2yEy7cLdL
	 QJwBo24QvR4hvDHKYSKAs0WUOCZwUJg4DAzHUE9pbjk4TnSEJULI+p8807T2xRdtbG
	 +fCum19lJQpsThRLuu8Jt8+67nzQ8IWZbzby8E+AvSavNf8mSthpV0mlUVzZIqrsyW
	 GegAnY1LCd5nmt2Qcxd2lhney36z0ywkzYaKejcQGyaCVT37FiSwPuO90aeLZTNclQ
	 lid7oh1gBOTesI8cEPb2SXJqT1PAeCzUefKPghOKJRSSCZ2xKMOc9TKaEnV2ebWyIq
	 fuSWFxidRtemg==
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
Subject: [PATCH 4/8] mm/huge_memory: handle buggy PMD entry in zap_huge_pmd()
Date: Wed, 18 Mar 2026 20:39:26 +0000
Message-ID: <8ffa393ad86b9b0ecd9b001ca88706ce2f9fe003.1773865827.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773865827.git.ljs@kernel.org>
References: <cover.1773865827.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C2E77160002
X-Stat-Signature: turi9afa9qr8yyffzuh6y91berg6z1wd
X-Rspam-User: 
X-HE-Tag: 1773866410-946765
X-HE-Meta: U2FsdGVkX181p1+MbYZt1NEJWuED03MhOWGWk3KBzVppJdea+HLJ82EEHLyadX0kyCUXsFOQDTv+MDC1W5miCVCsAfkdCbv5RY338Ma/VmRrPe5gVpq2XpCQ1rH/fdpt4qQ6Ufm+s9K+519GgbfDma/fmbNRZq91BfK8zWT2otCDYYeyAu7P5ZaAEFH6EjyBCn8LwMkl85jHcRO/9JtNEfcdtzzbRCxBtNq6PnGNWHCca0reg+/fOKej0WG7c6mcE7bR1e4RpYL9Tt5pyNfMpQzCr6ITEPBeajj4FnG5vhGWHTUN/ylLLFdslR3l36HdgCMnxX3GW6D6HmRNyhKNuXTOMSpLOC81MP1mDVpTWuj2onGSCYX6Nc6u+HST5UA39rcdKodz8T60haKqwOvPq6J0zFQQO5hLAxyDVEYPPmIwKwuLSacO+VkdG79VYvTBZdIeP3XgC8D2TDgTabgFhEcGvaYBbdzGO38gXoKvb8Vj1TPBNYNhEEkzy4fyZLCYGo/NR1IUDyjqS1OKncuH8YtC0F/g5fdAxnXeeGMI1IX2NpUfHB7r+Lmry7Hci8/hrVcK31Lq4eD6Rurer4KVlNXNSJASgZIQ2fABNJl/48JSQHNBWzdzFoSFRKomObaWTinMADAkv+f4+uFMOkUaJ/i5JvAS7AEOxMp9P7HzN3/7SJ8bRNb/Yw6NYFADcvZlYO+VATmoSmrvJmTGqTmiEOw1wk0wH4JGBGTKDhiUkjv2Uv+F91LLxollj6CxmEFi/T9HhJDCM4z3J6Ewv595m1KQkwEhm7AcRg6BMMPHMiUHNBYGXgShgPXSaJdRmyDRuocFcoaRHacUiV26nX6zPUuCtzC1XIVwWyGbOGkuu+ZpYgVJa2fNQJP4GN8k9rEwyIOgQ7MQ61U3PWfDmd+ASWEXAOYtEwAzy4FGWV9Upz6XMtwVYDH6isLnK4MFhjngD8SdRkh7P/5MM/HWYRb
 qzwuW7/3
 HQSdWDSZ0OQ2PKTnYkXg6pj6BKG6AC71I7JvM4kJdfU8jc8GUYGxjeKlW7L75jTrQg5fRTG6KWq89gvrKDYf/AajTK2oRwTOwy2MBHrSOCqNewRTZdOj62y2liNIm7/5A6eMpwaStshx68zUWU+rT/EIdU/PwQg1Tt2ddw0Ncg2tFcY4O8cuimnZejNtkELvc/NouwCTw2xe611cRN5hNld+JVPBtmViilhaGm2Ggm85wJ6IwWWQnF3WEL0dF1/EfleOCa1javS6zgGWgKavKCYD+DQ==
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

Add an else branch to handle this case and WARN() and exit indicating
failure.

[0]:https://lore.kernel.org/all/6b3d7ad7-49e1-407a-903d-3103704160d8@lucifer.local/

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 mm/huge_memory.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index bba1ba1f6b67..8e6b7ba11448 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2478,6 +2478,10 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 
 		if (!thp_migration_supported())
 			WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
+	} else {
+		WARN_ON_ONCE(true);
+		spin_unlock(ptl);
+		return false;
 	}
 
 	if (folio_test_anon(folio)) {
-- 
2.53.0


