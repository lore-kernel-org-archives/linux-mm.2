Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78E4DC624D5
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 13:13:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83B236B00C5; Tue,  1 Sep 2026 09:13:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EC7D6B00C8; Tue,  1 Sep 2026 09:13:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 728C46B00CA; Tue,  1 Sep 2026 09:13:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4F16D6B00C5
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:13:39 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B67581A03F7
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:13:38 +0000 (UTC)
X-FDA: 85165235316.15.6A905BE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2F1794000E
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:13:37 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VmCJP86o;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788268417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7ZB1yfEGzN5K33ID0e3bcOFkHhvifJ8hhhrNtAvrugg=;
	b=q7McR/fkB3ngFybi64uYWvAWFEB3V6txMAyIEE9UfVT/ooaGr6KUeKmQ2MWYINvjlZ0kWf
	VPJjX0IjLPAj+xdkGa/+z2jpK5298f56JbCEuWW3UB1f0h0Jf7KG7nafiazSxjNXop2UDc
	xK92+ko4kvhm0XH6stba7Xj3+qsRjEk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788268417;
	b=hKemIJAOUcjGL83gWjsxhTAaKrCcwE3vtAoPTUbe9HfuzIAkGqX9aLrIr1WdPidVmUUL/5
	PWgx97ZfFKAQ3qpGDIpp93UCF1ZIBrwprB1d6ixZ//cWX6puiLv1s/ZoITsNjOpeJn5B86
	1Sqb2oyhjnxBHvCSZL9j9h2VS9/qKJI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VmCJP86o;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 762FC4142E;
	Tue,  1 Sep 2026 13:13:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 266FF1F00A3E;
	Tue,  1 Sep 2026 13:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788268415;
	bh=7ZB1yfEGzN5K33ID0e3bcOFkHhvifJ8hhhrNtAvrugg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VmCJP86oeHn76JzQLhDmTScTgW+IQItKLl9s/BVtCWN6+31Zv3FKqrjnmL/GHP6Y0
	 7NyPgN784/d/zfr6IaXQ1Q7G6hghehkfC5yVy/ucrAlz22jveR89bO60RfJ81n7roT
	 5QYT8W1WRaCLjfJAeCdOt0aEdfS1E1ctnkyf1uNNbeP6ibbaHWJKcARxSDDMqq2zlU
	 wKCmnJuNfkB/JOmC7LlU9MTTu13WvDmPXIyh/6mciXcvapOcaeAv9U/2jVHTwBFVtL
	 0oPMdpW3BGL9Fs1d+ZzPsipWp/kjLfHZrHrHA26yrV3TuY7WenMcHdKe0LS6x17Lnf
	 lA0opfQpWCzfA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Usama Arif <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/7] mm/damon/paddr: respect folio end for DAMOS_STAT
Date: Tue,  1 Sep 2026 06:13:18 -0700
Message-ID: <20260901131326.97615-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901131326.97615-1-sj@kernel.org>
References: <20260901131326.97615-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2F1794000E
X-Stat-Signature: we66n1c4xy3u5yxnpmik6mom898ew55p
X-HE-Tag: 1788268417-917928
X-HE-Meta: U2FsdGVkX1+ipfJpGAXvkR6kv66F6FvXh0YIfmNoRPH2WQ7t7y/oop8q0MSc2Jq1CyulNll9Vx6PFmO0GTqlF3bVshQZy3fZ2xlfCQOov+ewrfHCtsGJO3t6OcdawNhBkRuJFXJwRyLymC9D8tuWwt+VOzEQJikTjOTeFKXT1KZAVEju3uU0d9YklKiW6DCCv2nCT6I/5xqL0/Uhz2sXBo3PorxjpcB3Iysm+JhCBYWFsT57PPTscqjsXB9Ni4lqEW94wASFQUbrpA15IBlOGN1F+zBR7IaxY1SP/eOIaPtRAPyEw1zTDfY3gkFzkq2v6peSUd/XAhao/qg+7PHBczGSl4alNHsSQ09e0/4UcprY0jgDi8+tbCUeV/vNfFESCb351Y/MuJDO2rTpx+aE0W4FQlzJ95n1aEPv6+kEbkfOayDHSF+9MQsQspOvsPg3TXpxaUlVLTE7v2D5xutFsxUreEvfbV0gBlt0h9yA5SpL3dcMFEdthQcAedP4TagjDFkDgtNrW9N5d4nU35DoZF9pjP4nycTmiBVon93fWMWyy6eg/yu4q+CfR1HkQeLm5HtV3zBnr8qC/dN0Kwnd7rSOWNBki3Y6Td4O4tIP3sQIFQ/gOFfC69o88V6vI/jYSFUoIsgMPNrV6zUkEuidWBd3cKvWJ/r80k4/ouoPjonNeeIpMmj1rQqbHtV3eCbNQhTF2CKt3pQW6IBsQaGZxRo4fCeuq8REyd/CKs3C6NLl6EO3utWeikMFxMC9pjdgy3Kp3g3emeV1/NrV7Y4FvLvoOwz1Lw92EYJ4FSu2JhgNQ2VLHXoHV9/S6vFICgv0OPYsvTdtOE9bLImzvplnjYyQ3Cj2qt+qRiMeirkImBD4ke3MkpvasFqCTFKGaCuqsMoeZD8r4o5fgbRrIFdNEKyU6qXdqoa/gBfofAdcm4OlGxfkhunTGpQ7cu67Yk7IfJASKGT9Dw1BEhd15os
 QWZ5UPD1
 atq6YmIHvbTt4T18MZZy9+ii5FUA8bmFEGNWisDoP829tTWk/eWbPYUyqUvemevlP65m82H188Su4WJgKmYfOL0Zf3fJGfUcpsSitEvFyh1NZUISbs4zaIAgU3Q6lTZyNuPqbdIF4ddwYtubEbQsSQi/XmFdgHmRdCIRPz/KJw4O0CHtSIU7u7BSaRvTFfnsy0FEnRisrbqTNrX9YZkOHCW4c7XLqP1tQiegbks1JcFT0hPDhiiVTtaQwr3BvqmhTy7Fs1X4Vpkm2S21jGECBvLnrTA==
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

