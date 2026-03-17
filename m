Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 861FAFED9E8
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 16:57:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECC2B6B00A6; Tue, 17 Mar 2026 12:57:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA3706B00A8; Tue, 17 Mar 2026 12:57:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE0B06B00A9; Tue, 17 Mar 2026 12:57:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C861D6B00A6
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 12:57:49 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8B951140301
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:57:49 +0000 (UTC)
X-FDA: 84556161858.02.39A6CB0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id EBD71140010
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:57:47 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KvOITOgO;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773766667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qVlRbNapaHsfzIIH3O9/i5u8xgy3dh7UyRle4oZGuc0=;
	b=6jctqJxaiwq//FA6HgaeSqXlDqq1sI3pReRK2cXVratCSLwHyQ6wfAfHj07I9Ny5Tb+T8w
	BX19XIBOjCDjiIrBx3fWVjGaDbzFL6atkuQ2be/z8fAdjFuaWB+CBYTHocgRb/rSFDOLNc
	wWp6AMRtkfUuEX2tTE2rQ8S0je9wxTc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KvOITOgO;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773766667; a=rsa-sha256;
	cv=none;
	b=U6ZJJUMPAc1UbaXg1+mUw68pSmPCjd/KglUCmErLshgEJ+jpvNi5Vc/Iin4mijTp0w5ro0
	3ZKHpTixwK6/ieB4nIdN8os+E7CGT4yGXGkaOFYJeWLBwlOwYdP5GO+962SeJ0Z32jxxRT
	h+rVoFUKk9Wz9ugIhnu2KwCxZ98WG3Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 716DE60103;
	Tue, 17 Mar 2026 16:57:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46E24C2BCAF;
	Tue, 17 Mar 2026 16:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773766666;
	bh=GmzhoQ0PJsvg3r41ZGNVjXu6dhy2NO2MgeEoTaVUJyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KvOITOgO+ibK/lPOLHPXPeB+/05jkCMxW9PlT0bA7fNiSqObIrPhWQfImj7g4NsUq
	 Imap3UUZb/Tp92VIG/zhLpyI/ggtGmC52Tg17EJDKgxFAAbSbIyPBQcNonDJOD1ocO
	 L8whLAIiEhbgmmYDfK3CdjQ+aUo7ddrVdb+qeRT4lLLZqEq7USP2ESW+zqcvTd0sYT
	 YfZHO9mKUGFpb6acRxS0xvf8lbNt07LJo1J95hp1nZA9qI9DHCQqVIi/4ZYj9rmbQA
	 +NURaueDz8fkDy4jRiEVRYtzvnnIoPxRfsfcFjvpDQcQRwlcUlyEVMvJ3rwghpVy7e
	 99r7NDF8B9EGg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linux-cxl@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH 11/14] mm/sparse: drop set_section_nid() from sparse_add_section()
Date: Tue, 17 Mar 2026 17:56:49 +0100
Message-ID: <20260317165652.99114-12-david@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260317165652.99114-1-david@kernel.org>
References: <20260317165652.99114-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EBD71140010
X-Stat-Signature: sdcdt5u6oqw75c7ecesf3rq18rwptdkr
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773766667-759489
X-HE-Meta: U2FsdGVkX1+kqSH4ufkKtNB54+q4Z1tBxrcOYPMLRDWJc0zeMkodFtP6GPUIuY5SexzJ0VKEO3ESWLWNCRDoYkvUMIbC0hXC12wTR/vc5um79E6A43NT00uCDJl3cxS2pzeQcVNEv2pc80U8gJlobQyme5nSFtfowUuK8wLPLxHVBiCpFZnpP1861bk5+FSGENyPOcyNuMvjoF/1LdaVnoKrTSATG2Lz+uoXtTl/wpsToShQ6ShQekPjKjpY40kvCQdNeGcl8e+yrOhqMGqykkHloUUyp6KMlnuSnqwbvozjoetTRiuzWAKCP4KCcrK0ZisP/A8XWsQspfUavtT75h8FFy9WIJosf1Iy2aQ9gcxpwUj+tSbve+FZUBDWY+OGaGlJQ7tbxgyz8FYbfxnAp8W14GhGVwsZXL2G/lPmsDUHlZTki6iRRwg1sCxlVtj/T2a8GIZ1Q5m2bVjPp7Vcj/RKlSHM08gMcBJbumuVytNqCE0tDUaPLADyhiuaNetbj2R0+HVkaice5KbtR99sEAegDYAHTVzD/GoLLOzY72iA8AjCv792Q02g9bJ6ouVRmzvDf04CgMN5ghTAU+wSXKMcM7hJRbkb8CpGE1+gQtL4LMFop2auYYyhK040BAZWvcEsanFw3KFW+Lfcv1BBJAtw2/yzc+V643gMr75b3EB4fCoN+0nts7+4oYlM1wEk7Udhj+UxrRHg8Xq29i0XMBinFcQITdZtXhuV04lpi4eQVR/KXZRF9hfg5GRcGfBxEDafIPwMTL31vlaLNycCG3OHiZIMYXk6NcEKJbIAay0ZYGltgt6rT9Tp3uuQmyYHBmTuNqeEz8sDHqEeUX1L73eGnSbtAkJVREG1GWp+OAjgMtV1ZiAVnZltg+liNWlcIamTgL4RLBVGAETNQeiE9dVuvLoAF12Ikdq8koOP3gr2giF0q7NBr+Fmeng9BklzexjOMHhpRgwr4WWoAyi
 kiW2/neD
 z6KugVYpJnhJCrBftBFOAAyllqVGwC1hYYGtWCBeJRntLnKGZlXF/qlVKkk+4ZlUGval5Iix7t/Kby2S/zljmKV5SYOLjYszqhxvXKTNi84zoURpk+doYZodJP9PFgJMs0qkpEOwTHYsq/UZbdYQ7nva0fXsZQr6It7pZPdkY3wv2F+TOSSjty3HLuNWzyRaK+lo5n+5Rl0EU3IbLfw6UCQF2XQMqT4/wqOpHCuLFOcxK6Odp03S+zpbP4IZjykl3xFnTPwVerrzQGYO/mBc8JUV57I/NIGPHYtSL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CONFIG_MEMORY_HOTPLUG is CONFIG_SPARSEMEM_VMEMMAP-only. And
CONFIG_SPARSEMEM_VMEMMAP implies that NODE_NOT_IN_PAGE_FLAGS cannot be set:
see include/linux/page-flags-layout.h

	...
	#elif defined(CONFIG_SPARSEMEM_VMEMMAP)
	#error "Vmemmap: No space for nodes field in page flags"
	...

So let's remove the set_section_nid() call to prepare for moving
CONFIG_MEMORY_HOTPLUG to mm/sparse-vmemmap.c

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/sparse.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/sparse.c b/mm/sparse.c
index 7b0bfea73a9b..b5a2de43ac40 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -769,7 +769,6 @@ int __meminit sparse_add_section(int nid, unsigned long start_pfn,
 	page_init_poison(memmap, sizeof(struct page) * nr_pages);
 
 	ms = __nr_to_section(section_nr);
-	set_section_nid(section_nr, nid);
 	__section_mark_present(ms, section_nr);
 
 	/* Align memmap to section boundary in the subsection case */
-- 
2.43.0


