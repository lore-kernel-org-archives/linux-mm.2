Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE0A5606A332
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 15:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YrRAPDeL
Received: by kanga.kvack.org (Postfix)
	id 12CA56B05B1; Tue, 17 Nov 2026 10:58:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DE9F6B05B2; Tue, 17 Nov 2026 10:58:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0F186B05B3; Tue, 17 Nov 2026 10:58:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CAAA46B05B1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:58:42 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 527EB140490
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 15:58:42 +0000 (UTC)
X-FDA: 85445068884.20.CAD81CF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id A7FB21A0006
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 15:58:40 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YrRAPDeL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794931120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=cS72ij2d9ni29XRJBjpUF55VVESM9MZfzucjV2dsBEU=;
	b=Xflw2muERDldOrPFt3Ghp+Y5seiFjCN/t3+pcT2DjmFptGJfte4pfCGsYKLh5hTSjpmZ4t
	Msw14kYtFDAWsSNYJHVmpKPK44pC57Kw4dW4SRXHKsdxQXE6Wlui6xgwO5KBZ2u2AnpMuZ
	F0iOI1zbCd+1uU7gR2vQ1ZS4GridDsc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794931120;
	b=FQru3E/NmGi2RSBxM/F3BPRMuLGTWo6GMIksCoUXIwPpdxnXcpx/snXqne6XbBSJLR31Jn
	UfyBFBQeUilPBKwJ82EiLjdkD+pjiONTxfWVZbPh9M/ksyHD6NlTRZouP/XmMGvgyk2CiC
	JG3Ob7fOpI4oHCfwCZbYeip0SAHGabI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YrRAPDeL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A91C241FBF;
	Tue, 17 Nov 2026 15:58:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2030C1F000C7;
	Tue, 17 Nov 2026 15:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794931119;
	bh=cS72ij2d9ni29XRJBjpUF55VVESM9MZfzucjV2dsBEU=;
	h=From:Subject:Date:To:Cc;
	b=YrRAPDeLFHufyNicmII5GYATuKsD/SPRYLYHTeXp3o6xEXHIz+mmEK+LatGEsgBWw
	 hvx+/QMwz/AcIKp8qKIN53vGa4AjPEzf/3Pr6sGe23UyRDlOIQNXAsoFCEGCoEiBug
	 5G5Dv5Dmm/m8VWPQGPuzuu8KgtI0EJ4AKquNyyzEqglCrl/rvrEmZZwA6jeChZsPjV
	 S85MPiwldb2xOZnkUGQHJcJtli7FYEAwSwwwrhFNsRvxsEoc5P5h656QI6AxoJAAAN
	 jNdY644iCqf7+Abe8BsGMdKrwLQ0Kb7JFJUYx7a+y72JHQ+54shoiVh+DoeZR/Hb3R
	 mgwGo00kRlJAA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH 0/3] mm/memory: fix handling of PTE markers in
 insert_page_into_pte_locked()
Date: Tue, 17 Nov 2026 17:58:31 +0200
Message-Id: <20261117-uffd-dax-async-wp-fix-v1-0-c9a30f27f452@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWMQQ6CMBBFr0Jm7UTLAohXMS6m06nU2EI6gBjC3
 S26fC//vw1UchCFa7VBliVoGFIBc6qAe0oPweAKQ32pG2NMi7P3Dh2tSPpJjO8RfVixa1pi7hy
 3nYfyHbMU/eve7n/W2T6FpyN2LCypoM2UuD9UjMMUzzHinHQi+xLY9y/bS+rxnQAAAA==
X-Change-ID: 20261117-uffd-dax-async-wp-fix-867acc8dc78f
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Jingyi Sun <1045704958@qq.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@suse.com>, 
 Mike Rapoport <rppt@kernel.org>, Muhammad Usama Anjum <usama.anjum@arm.com>, 
 Peter Xu <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>, 
 Vlastimil Babka <vbabka@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, nvdimm@lists.linux.dev
X-Mailer: b4 0.16.1-dev
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A7FB21A0006
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 1o5ukecsyrzorif14rtacm39q1hoo4jb
X-Rspam-User: 
X-HE-Tag: 1794931120-109036
X-HE-Meta: U2FsdGVkX18yvJD9jyjTXCUmiS7PIYb9F3hKz1PvK9NetNIklS0a5+0rY/wAfK3qppXZRPFwH+mxfpHA1S9xoSaM8E+6AutsK4AgqvJE00eUjtCGvL6ZwqmEn8lowYPFC5OKkVs9OaKkYVeFn5FIyTRii0QrdmS+IJJlVREB2g8dscrWXjyP5/mwlLeJskt+A85iR7jwUDpMxMP9zXeHrT+hkR0dqZSDyQQBIsrvRUJc023KfH4Fl3GnhHZyXvwqgZw46zgNBsK+TgpNL0f5S8fwQgYNPAab8WYdNJKY8aNgEd22yc8l52QQVBM9gxp3N2VHED677RIP4c0UQgu8UklRHbvrDoiZP+W3YCt2/n0OIpXIvgU4mLIcLdAybdD/7n9BALrJAG+2m37c/o21VHu0oiy9c+Bd7+4B17cjxOqH9W8sLi7cBvzjxts14WpSqP5txwOaAQ0rBqY5DGCOr5M+bZzdm6u7Pic/S3arUGwuDmR2O4u4RdH2loxxEWPl7bmiVdOYkwls93NQUehgAi70A/qJ8wQaX3EzNSoRazZHXYn3QCv/pOmhlCXlGeXiV7EE5g55dxVn7Mx8O9aEPP6pdNDbEV4XJglafK3utV0IDLDTe+jLQS1Eob0J8+WqTpjFRXF+2f2nmI8EnDwY5c0NWHEu3zjQGwDJ1g7wH+SX4/9gahENM/ZkId0+OegCcCY3UIdoljK725nx9HBfH/Yk31FIAI3STYSKqN6kpPYbn1jqKaByHamwVel4t+zr8LIVkBPJMfSierEfruyWDX3MvZp2ZbWWRS/+oBbjcck6NxwaYzhCy19MODvkYhYhd1+LNf6xByjus6YU8nvs2GBcUFgkiibd6WVsGtqceEYnPIjqE3Yvo3KipyL/eJPBB+qs5+/fHqXlhF4Cdp1vjYAulo0dChIs8B3ZwU5m+Dq0t1pWoGuNFgjdJqWn/xolQimWXSENncpjttFy6jP
 bGI/CDgn
 T9zP2GtnnCIBL+lrOWz9WPqfEoupGFUhCqLdeuCztJyhB+XcYSVeoQ2ZUz2Rey4HaSqIidDr36ebjo7QUIzzhSw3eSuqqGha5VvRJP7cx9oPnGB0LRmjHfGvGnWySyyvNRtWXjnOin6eJf+8NFd0G6CJp18LkzH5RMC6F2oLbql1SFLIdP44wuMn9Qtyhrk83/9fYEWmnHZZKmxKC9v5WfawH69EyQXVixakmQo6Fxq5DwPUr6XUFsJIIELrWw7gp/GAk/v0+jRwokf8kT3PblDWVX5pG/Njhf2ld/wVkaFmes/v/V5Q8CsIBimqijE70Ut8s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Jingyi reported that a uffd-wp marker in a DAX mapping causes endless
refaults on reads and SIGBUS on writes [1].

The root cause is that insert_page_into_pte_locked() treats every PTE that
is not none as a present mapping. Besides uffd-wp markers, this also
affects guard markers that MADV_GUARD_INSTALL can put into a DAX mapping
concurrently with a write fault.

The first patch restructures insert_page_into_pte_locked() to make room
for the fixes, the second patch fixes the reported issue and the third
makes write faults back off on non-present PTEs.

Both issues were reproduced on ext4 with dax=always on emulated pmem, and
the fixes were verified with these reproducers.
selftests.

[1] https://lore.kernel.org/all/tencent_1874C71D4177A1624528043E008DB1A5EF05@qq.com

---
Mike Rapoport (Microsoft) (3):
      mm/memory: install new PTEs first in insert_page_into_pte_locked()
      mm/memory: replace uffd-wp markers in insert_page_into_pte_locked()
      mm/memory: don't upgrade non-present PTEs in insert_page_into_pte_locked()

 mm/memory.c | 68 +++++++++++++++++++++++++++++++------------------------------
 1 file changed, 35 insertions(+), 33 deletions(-)
---
base-commit: 93d7a816a2df3e907e2719bd12b0073f1285fc5c
change-id: 20261117-uffd-dax-async-wp-fix-867acc8dc78f

--
Sincerely yours,
Mike.


