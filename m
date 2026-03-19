Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CDF71090220
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 13:00:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4B526B04B4; Thu, 19 Mar 2026 09:00:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D591C6B04B6; Thu, 19 Mar 2026 09:00:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C95CD6B04B7; Thu, 19 Mar 2026 09:00:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B89126B04B4
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 09:00:39 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 81C5EC1F1E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 13:00:39 +0000 (UTC)
X-FDA: 84562821798.28.3EE6BC6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id D719414000E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 13:00:37 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H9Vr0NmT;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773925238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9LaalRg272LTX3XHJp86kH8Jf/DypHDPYoJgR9IIJnM=;
	b=sVMpPVbItkpd2Cn0E3+eaJ7KhweIq4n/fMkA1Pitzq6JAd4bmnZDamOHQfA6wM/eLZV//M
	HhWkJo1knhejUIzOKYiBuPXTynfwWIZ5sdvpNyLfCV0JXfY0tjiMbP3sA+w/CZ3gGIZoff
	tN5YOygsZfuqsPLixKhCeYXJfihpUa4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H9Vr0NmT;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773925238; a=rsa-sha256;
	cv=none;
	b=upIAa2pVmGc+bSUV7OcCboSOrFmvUrUHlyWHSVtzHXktlh9jNqVaQgEX7XPNAhhVXw76vj
	2f28H9KudgHV/Dunf0KtobSXL5bEbzYR941i3QV6uZdNGIpAXkCtuRzrgHGFpeMiDrBRue
	MEVseeVY6QLOf+tPLUIvkDQnYVd8dmw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ECFB54459E;
	Thu, 19 Mar 2026 13:00:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E847C2BCB1;
	Thu, 19 Mar 2026 13:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773925236;
	bh=kspbMybLh+6i/a3mVmNNauCT4x2DdLe5LLqLRnb3Wp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H9Vr0NmTzWFMhiAdsOMnHQ4dQ0Vgay553D0KhLhBvx3FWZt+EvoVQ7ghnu3Jiz7sG
	 6PC2ST2bgoPmgPo0lSUWJwDucyW3ohWywV+qU750kSjpA27k0OemOj6VdE6l/oiqw2
	 w4ka2IJ39V1QPp3vg+toosfQoKGw12V1oRozuTdZGM8AERILwgIwYxDO38n7c5C0Bv
	 r3+YW1EB59c8Fk3dXZJTpxBxBRBRrHcYfrogXP7SMq5T+R3h3/l6pr8yfBphmjlfj2
	 MMz8dj26355XtxZ3rRyV2exYN80/h9pW3feKhvCWEHKavP0oU4PZrgpSR3e8/PYTGh
	 tyIo3aHVF7Dmg==
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
Subject: [PATCH v2 6/9] mm/huge_memory: remove unnecessary VM_BUG_ON_PAGE()
Date: Thu, 19 Mar 2026 13:00:12 +0000
Message-ID: <3fcbddfbfd0408364fad4548be83455a59d17f79.1773924928.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773924928.git.ljs@kernel.org>
References: <cover.1773924928.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D719414000E
X-Stat-Signature: hifh5m44oz77ycqrps6s8x6tgswp48fo
X-Rspam-User: 
X-HE-Tag: 1773925237-304433
X-HE-Meta: U2FsdGVkX1/wLgPLuOQ2VF19XOA1Q539ZrU6Kp8oN4m0azByxQicRw8MRXDawP0ndGOz2EJj9cW2gsf3oJ6fkYcPBA09CGs1giAaONOq7UcxIk1G10AyX0DvAYOHqEPK28G+g8pURGRk7KmNBJiYiKH+Fe6g4q9S+ZirZVHCnqTGj5nH0Z3GKfvHDkux63Ds/Cse8TL9GHRW1uhTgonB24FEja1ToJ2D3NPkLXfpkQec4IydrXGzLcRCvitBh5Oj0BdLrOm8xgaxkpTNgMu4XkN+H03D8WdqBRpVQvP1Zj9fwPsgH9G35P0ZTcCZ1i8V80xQJ98Ra7X4e3UeD9SrzFe7Nb79EZVGysSfGf+zgEWr6YLq7Kor7ibcsDPrIzHTVqgGlEwHp8tlRMdYS0yRckZPdJe7N9m8Yj6hF+Lv4tBUzUm6lEgXBl4gvlj9s7djkE5qM6s1+CgTX+aNBIceaRDnG90O9qFbLlGOL5RnFCeFGpcYcYYSQya9h8sl/H29+MP1sMqxmXsYai5d2k31SZaX9pE0EmYmIvNXjXDpWfz9bouBEk8cUF+GYemITzZ5OGkegg04V8/Ni6Fj/huzYC+QCzghhM1Jpk25Hyfh2nKkl4MVfL7GB9XLpit/0Zv/LsS2otPqxmi5+sr6NqCjUHq/qgRQpDC723amBR8Zx7LJ+Dcq8n5LwdkFJqZklhqbBbasbXd6m8dCbiqNdFsuA5LOvwEm8KA5+vUZzUsZoxXxr0kJAfgwvKbQzjJyLS5Y9zu0mJljanlKLvwpF8CPOMfRgMxWHOmdD2Martaqjw1g99mG5XcC2K1rG3u8vnAskpjD5w8X2VJyd3AmSLHEslr44+wa0p0jfL5cTZ7EiDIRgPiPu9P3QLrGjPWrUfEFHKHUqHadmhr7LEc4Xei5WFyKo7PzkkwkRrjODfp+d3uhgdkF9eBlphYgGLYuebcHXQyZ1QfWOV+a81+xJyM
 EpmfE9dd
 i6vaPRwgZ/JLSxtW75vztFnHPMEiZ6tJ5F6izUZoKRNSpCHG14E9s+B9Qg+Up7GvjTLvvYk0GPs70vhyXyA1VkURZm6V0cnyobWCJpVLK/UWHLqlvKR18YUk3OUQ3oSgVXi3PNMcvrAA1GsO9xVI4G4ccKgp9AA19zBPtJRi4qF+G9cllWpnpjpvem/KvcEmkeNL3IQc5GBGgje55GpMpTVDDBE1T5ASkv5s7I96LLZHJSf89fohHlQbp0YAuQhXABWOm24Y5OvzhwTAfZNiUk9lPhA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This has been around since the beginnings of the THP implementation. I
think we can safely assume that, if we have a THP folio, it will have a
head page.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 mm/huge_memory.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index c84b30461cc5..499c31bf8f83 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2468,7 +2468,6 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		folio = page_folio(page);
 		folio_remove_rmap_pmd(folio, page, vma);
 		WARN_ON_ONCE(folio_mapcount(folio) < 0);
-		VM_BUG_ON_PAGE(!PageHead(page), page);
 	} else if (pmd_is_valid_softleaf(orig_pmd)) {
 		const softleaf_t entry = softleaf_from_pmd(orig_pmd);
 
-- 
2.53.0


