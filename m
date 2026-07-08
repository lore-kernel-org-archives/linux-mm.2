Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E714EC44501
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 22:13:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE18F6B0096; Wed,  8 Jul 2026 18:12:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8AFD6B008C; Wed,  8 Jul 2026 18:12:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2C5D6B0096; Wed,  8 Jul 2026 18:12:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9EEE36B008A
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 18:12:57 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1EBF6A030E
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 22:12:57 +0000 (UTC)
X-FDA: 84967010394.23.5CF1901
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1F13C140004
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 22:12:54 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GSVIvt7L;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783548775;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EHRA153HdJs+p0E2OoonLSoRb3TShk4RsbXzl8qPf2g=;
	b=GhX9zRTDr7GM0g5IpPb+aF3sRowdEDIsxMWmNPPO9BBzWxOCTCCLVub67zxkDn9KP8z2uS
	CdpqWVKpsliqNbB4i3B80mmjjnO0nJKe0C7RAxMARg4CyIqURiU+ZbK4+gdo/mCqHcp5/i
	MvY8p4PFGYJufyApE4Zv8uWjrg64M7c=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GSVIvt7L;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783548775;
	b=aqKnn6gMSHYr+q/DPORbQhPGdzuQO3bHK6VxW58KXHB4KtKD8fmXKdNvoIt3dG42Ye4/tv
	jivaD8xI1X/8DZPIHCTFJ2HIlpQGI1G955jYqCIBN135uqFP+wuTqggXD9eRQeJwkHR3as
	Xb1XpE8Nzc8OtuuQwMcvKzyX4o8aXpo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1667843D0C;
	Wed,  8 Jul 2026 22:12:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DD883C2BCF5;
	Wed,  8 Jul 2026 22:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1783548773;
	bh=ocs3W/FAuSHd6XHuqJdgjkplQY7OsSH3DoKXZ4km4mg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=GSVIvt7LaUewb6Yor4iDkwNMfDJhf/m/vroxwPYPSCGrSK0e1KXQIj2XUJGuLEpu8
	 b9Cq/6qAQ436CNHHNJqb9rdjTG8YvBCoFTLow5TOldA51qbumUzi4a5K9tM9Q7yKbA
	 wH7ep7cNFMfDKPdMXJOCpjLgM0syVBs0+N2MBYZcv7VesC685hR+I5qLTON1Lnu6wd
	 WAyAcoSOVjwKWYNVzCc19k03PEod1xovD9CHpTHonS/tQ2r+H5l9brT324ei9NTKof
	 8n1M6JGS1ohWkQZwLbMw03Lql4cte5xIUYvYQpFpZ16frIumykFxe54zpC+eZ84Vjb
	 8dxr1dpU4bmLw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C421CC44503;
	Wed,  8 Jul 2026 22:12:53 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Wed, 08 Jul 2026 15:12:51 -0700
Subject: [PATCH v2 3/5] mm: hugetlb: Fix folio refcount mismatch on memcg
 charge failure
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260708-hugetlb-alloc-failure-fixes-v2-3-c7f27cbb462b@google.com>
References: <20260708-hugetlb-alloc-failure-fixes-v2-0-c7f27cbb462b@google.com>
In-Reply-To: <20260708-hugetlb-alloc-failure-fixes-v2-0-c7f27cbb462b@google.com>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, 
 Wupeng Ma <mawupeng1@huawei.com>, fvdl@google.com, rientjes@google.com, 
 jthoughton@google.com
Cc: vannapurve@google.com, erdemaktas@google.com, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>, 
 stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783548773; l=1242;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=VCn99bEoQNyadmxjsM1rKLroB6Ii6NvdNcvQQwTosM0=;
 b=o1JFZ+27rVlos6MFYdiRSbM7jq5fQzxYDj7CUQVhhs+9hVEUTxvX8ee80Lj2a0M6OeF/Mef73
 j5AZHRgZWgxCMzoi/qtVUEcHbbk7tolQ4opx4Apg+u3CPShEJZQp8hA
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: g6yj6a1zunc8g6d6jym5xawqgxyc6ahu
X-Rspamd-Queue-Id: 1F13C140004
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783548774-522907
X-HE-Meta: U2FsdGVkX19Em3DPq3AcXRXReKA6jIZQN2MHwwT6NIUAEUlkmLP8et73U+cnXakTgh+/vpuGKpeUEwNic88SSPn6udK2hPAS/5B8tZ+QJm+FT3BQZqeaJDe+1qMQWUvtk4KfC0x9i8HfHxHUc4UQNs1DOa5fcNMe1ouAAsVawJbI7RBsnnqlj851F5jCasas+4WfzLtDrYtKYtOuRLim8//lVh8UZRKw4d8QwlRCKZ/V+Je1nvszrRIpqcZCFhysBvIA9SiKRSlaRhmBSBqBqn6OFodcFyD82B3dYQtLvNsAyILBYUw6exF1loIAfJ6o0nKi/v5gyKONLHn5/Wra58uBKSy4wOdG7u8AkgJ9kn1BrG9OCzcDiEae9p9UmE38RIh59zrwL3G+TkFw2TGVRoGMF3du67adgijRQRo25Rh9g+aexNiwHWQrn+8dSCHFgcZiK+NGFMW2LcxzAIAm68M3XLLI44CpckC4iUI/DCyvxdtSLu5Z3p2RLEn8j7wkNaPTt6zWgrDCTZlC4ib4rbTnUor41gtz4G530jAATPzkoEsq3t6vy/0q8cuPnT+vmAGNfs1iSiUs70+TAK2SMLyPAF6/uV8mYpzUoU7wB8Mu0yrj6iXATQmgOhgrQJViziNhfrZ3zT7kBn+/WUVzu0S/gqw1utuhe3ih1iBLzMTBdwFn/4rap8rsDr48+hlNUbddLpL6W4U5b3CKEh6pSd2He5yc3KC+K+7vUOINt4TzinrXtiTTkDxJJMM+u9OOsyQSKv2JeAObiXrV4yeOmN2o8svzvFQis7lZn2C53UT+jK8V2mib8Apud1DadtPUI5wLsH3U4B1VQ4//uDjgIeAizpLzAyXSgVGVu+OyVravqNORf8kg+rSMXKtlwf9oq3Qa9v1tMWuYRvG0vciWqWgVVX9+5QE8tb1KQ74Fh0PNZb1Gb+Kc6Bjbvj/xqURGOH4JPVcOKo2YMaYhn+2
 sn9hLOrF
 rzY2lRB++/ropE9Ye9MsncQCy1EFkJD7eaixg1b6iu6V57m9HSEWDr/EkAyEF+B7rXDM+cnmD/hGaHvdOgoeDhJv3+LSjwL6sj2OEcOg74aG5wU7djUrRuquW+ByuD6o+Y0wIvwRDLXtUsBEw44SGkrbO7J+m/SxrvxrNVC41GTyKxSTYoi9O189vvIfKE0ZboXikCdfSQDtpsSlXGQ4Bc78ef7Q3QE+6LOSHHCGisH5ZsLO/FZ97q5Cjmeu6HYQ18Bl9gzbKRIWkfhkBNfonJApxMI4CeOh9waYFMpBSBJjT6fYPPQszdCDz6bbsnyxp/L0iZlef/q1zC0un+ZpqJK8jvHLPPlPSKRBTsKkem8NAToefhdl+xuFnngTq12IvCd5dYLtL/sCPvCHgay2yOrHGxXVsbMnoBswAe6p/ZycipzbjbRd6jePzvJFshLlnScBdOHZ/3NsPPrYn9NHuhtarTcXwZxXbOl/H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

When mem_cgroup_charge_hugetlb(folio, gfp) returns -ENOMEM, the folio has
its refcount set to 1 via folio_ref_unfreeze(folio, 1).

The error path calls free_huge_folio(folio) directly, which expects a
refcount of 0. Hence, VM_BUG_ON_FOLIO(folio_ref_count(folio), folio) is
triggered.

Even with CONFIG_DEBUG_VM disabled, returning a folio with refcount 1 to
the freelist can corrupt allocator state later.

Use folio_put(folio) instead of free_huge_folio(folio) to properly drop the
reference before freeing it.

Fixes: 991135774c0e0 ("memcg/hugetlb: introduce mem_cgroup_charge_hugetlb")
Cc: stable@vger.kernel.org
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
---
 mm/hugetlb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 4093c1c0a4a1d..1f3f4b964b153 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2990,7 +2990,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	lruvec_stat_mod_folio(folio, NR_HUGETLB, pages_per_huge_page(h));
 
 	if (ret == -ENOMEM) {
-		free_huge_folio(folio);
+		folio_put(folio);
 		return ERR_PTR(-ENOMEM);
 	}
 

-- 
2.55.0.795.g602f6c329a-goog



