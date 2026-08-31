Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29114C624C6
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 14:03:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F9306B008C; Mon, 31 Aug 2026 10:03:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CBBD6B0098; Mon, 31 Aug 2026 10:03:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8458D6B008C; Mon, 31 Aug 2026 10:03:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5D2696B0092
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:03:06 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D1894A0168
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:03:05 +0000 (UTC)
X-FDA: 85161731130.29.F879CFA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 34D9B1C0002
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:03:04 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=irD4Ae4D;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788184984;
	b=RcjlOyjbEC3Dh+6aH0lb/OpYYy4R0YxhrDTD07mv2Y225UsCdeUlUANFWNDiBZy2nIoBUV
	Xh2nLTTsuNE4l5jA+V8rywSr6tXS4JqypN07iClRMfsEyorFHNl2q5YqkHEkph9MwbDP61
	8ErcYs+tkSfqfR/MehQtmnaFkrI+4+Y=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=irD4Ae4D;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788184984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7ZB1yfEGzN5K33ID0e3bcOFkHhvifJ8hhhrNtAvrugg=;
	b=xiCeobokHWDbP+kby0NrduPQ9gGmEex2kjPtN30XiYrnbUCBwg5pxwaJBC0E0jJ0Q5/kz6
	jc/IEoCgOFoujMDy1ge3J/dg1DMhSJOYKVGX4vi9H5RxqdD3hvc6velpRItCF97TyI8hA9
	+AP5dJIIMrbAv63Vyjac6IfdYhOFo3o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 99D3360210;
	Mon, 31 Aug 2026 14:03:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CBBF1F000E9;
	Mon, 31 Aug 2026 14:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184983;
	bh=7ZB1yfEGzN5K33ID0e3bcOFkHhvifJ8hhhrNtAvrugg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=irD4Ae4DKcf8PeVHbMIoXVmCG2XKWzQmLktHoyVCc/ltspDG7jkbi1VoTpdxAMGrw
	 oEb7Xpdf3Fn6kS9cnBqas4zMMgM0LGPOyRcV5i4IQW5WjdW18jH6NGKAR+Gh4Oa4cw
	 0R1k0ICtEq6r/PKzIwLJQcuIcrV+y5J3NzWZzGl7jDAaaXfWZaWonfmraI2LYdS1wB
	 rWDVbqw5wgtHIqvUJAci4RFc/frCAhzqnU3V0k2h8ThWh1yTO81ZCBJmI32YtBadrF
	 eGyQDgWxzJM1pYctbEK+t4pRduc15P5dHwm92jbb/3JMWLkPXWSgHA8cMYlrVjJ4ih
	 RpmPGuf95qGpA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 2/8] mm/damon/paddr: respect folio end for DAMOS_STAT
Date: Mon, 31 Aug 2026 07:02:41 -0700
Message-ID: <20260831140254.72004-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260831140254.72004-1-sj@kernel.org>
References: <20260831140254.72004-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 34D9B1C0002
X-Stat-Signature: txrsdunzknszkgy6rmiobenghiihco7u
X-HE-Tag: 1788184984-912461
X-HE-Meta: U2FsdGVkX19zIUrDuzLUiYOYty5PF3JgbWiTENrM1dBKLoA3804HNOPQZryuiTmU+Va2cREMhpGfqvUYE+D7qDzWiCzkyb4r1eJGPSLIXW+UL223L3mYasYsq2k8NrOmZqEVMDA7YzH8Lna1QeyWV8jA8uDB+JaWILT2bpdlb/nKEzYFE+exC3cXplswTISYVN+MJiyoP7mi9KMh3aLEul7QZ6D5tuJQsr5FhXobCP6vZLzxgDL8aRGXkb0YyUpeBAmQc10Ng/vjjAgyzax9dtOGCYxr8oSVzNfJKisWJnZybZk7hmW5OG53u52EgysbiR4GgBNh0/YrTbivRT8K3WltIJLxmTSTOZ5adMi4iVqhrbJxvFeU2Q7303aYUuLUrrLHKUAso5xjHGf9A85H2J84Xdx+8B4O2TlHZMazcu92VPK07TYaxrZpaqmZf4MMc5DUuOMMOOmjeMZKxUBVZaDVqDXr+qcS2Z9iZ2kDPYHvJZ2yeBjnU7PKbNXxAXng+WdCjZ7frF85Q/uL1RzFOM6oHql3fLg14qfqS50Hd8XlRxgM0/hDGTOJ97bKaPMG7pVbHQvnOA+tfTiI38YwBQScQXbJt94WlDcKHOlcFxLMEvXpGJ6gcg+F4XKLykYva1TBNMYc/FAQy4V4d+3JZEfZZGCOFvo8+Iu8Le1u6MY+Nk83/gPrHfeGvLWV6cwOU9dIfnWjt8uYwJ4EK8AtUf4+s1C/kDPeqeOBPWiJZ45DuNjrw36dbVpH6BHEJwKGsyOcYpeZ7g9e1dwj61DCcai8VPWHetAWtEZiBmieTWA+p9ewNUHyBkog+bT9maAtaM4OfILMQ8uCKMbfYtIoaSo7s3BYH5Qhfcp7IILAng3FY+G5FlZF+ODs8p5GGIWf4iEDeYAGr9mcf2AZeRvu1DQrkoLT8OrGIqO/2zwDdueYXEE6On/UlppfnpYJOx1sZGrFmASvgSrNu4Sx/Km
 qBjFS9td
 f5zOfMM/jgCWKHU/Rb0URT5thWdKa433F81vbYxY/awf5SY+0RAfG513UbasfkUX1fG9dDvVr6PUYCyRZ34tlERrPkTrI3X/tzJupTdgMPJWYxVOx077kqRDpMrkE1iJE/VTgemh3C2xTbMHTa1GSqjjLkEgxKSvJm+nvTQHI0LQbh3yPI5emGZZfqJjEjL13TQcVm0b8ujXRhizSKik4PcOslqf7nIOszhuiVPjOoM4o8x2k2iesHxM6Nh963nJXfDzZNSX6PilkW9/eoX6w/LipgQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The function for applying DAMOS_STAT in DAMON physical address space
operation set (paddr), namely damon_pa_stat(), applies DAMOS filters to
folios of the given region.  For that, it gets folios of addresses in
the region.  It starts from the region start address and advances the
address by the size of the folio of the address until it goes out of the
region.  If the start address is in the middle of a large folio, and if
the next folios are small, some of the next folios could be skipped. Fix
the issue by advancing the address to exactly the start address of the
next folio.

The user impact is that the DAMOS_STAT-based page level monitoring
results become inaccurate.  Since the page level monitoring is supposed
to provide relatively high precision, this is definitely a problem.  It
is arguably not critical since it is only monitoring quality
degradation.

Fixes: bdbe1d7bc325 ("mm/damon/paddr: increment pa_stat damon address range by folio size")
Cc: <stable@vger.kernel.org> # 6.14.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/paddr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 5c6c3a597fd0b..2ab7b3842701e 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -379,7 +379,7 @@ static unsigned long damon_pa_stat(struct damon_region *r,
 
 		if (!damos_pa_filter_out(s, folio))
 			*sz_filter_passed += folio_size(folio) / addr_unit;
-		addr += folio_size(folio);
+		addr = PFN_PHYS(folio_pfn(folio)) + folio_size(folio);
 		folio_put(folio);
 	}
 	s->last_applied = folio;
-- 
2.47.3

