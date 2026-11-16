Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE1E4606A883
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 15:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=neeh/JxC
Received: by kanga.kvack.org (Postfix)
	id EFF476B05B0; Mon, 16 Nov 2026 10:07:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED6D16B05B1; Mon, 16 Nov 2026 10:07:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEDB76B05B2; Mon, 16 Nov 2026 10:07:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BEC016B05B0
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:07:19 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3543CC0160
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:07:19 +0000 (UTC)
X-FDA: 85441310598.20.AFA6E77
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 5932A20005
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:07:17 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="neeh/JxC";
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794841637;
	b=gHaXt1qThf/X4PH1HdLwF3xeWhiOPAiEeFYf1bnL21VZi8PFW1owWiop6PrEu0fzIHmPnh
	Mdx1LFWV5f53ukj98QbJv8BdAPTaUorTqjl1QSQqgv6MrEuhicOzfmasSP4a2yudjTF581
	p9kNbBOmSvusRP4APiw+lWEgsk6CP8k=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="neeh/JxC";
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794841637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=2Z5TqtpnMk3mBwsYMciP/4XrcUBcxTvv+6N/ymI5s7o=;
	b=DM17JpsXv+dx/yb8KngKITHdQLnWcCo96vVZRqVWeT4g9q+574mvyG2D8eUoadlS9eG1dd
	U76MrnshokK/U4z402vV+Bqat27PXXDqZA8rUlLDXZMPS22pUy/slN7zcA7X9ST3aOh3Nx
	2dMi1mrtnuDkaNRSJCqsO2lwBe8jysc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8DD9A46573;
	Mon, 16 Nov 2026 15:07:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 548C11F000C6;
	Mon, 16 Nov 2026 15:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794841636;
	bh=2Z5TqtpnMk3mBwsYMciP/4XrcUBcxTvv+6N/ymI5s7o=;
	h=From:Subject:Date:To:Cc;
	b=neeh/JxCQ8KhWMT1ASqFudUros9bMuT/k3e+b6YcIbhlFSqg/KWf0X74pYD0klhhi
	 Yw82eW47iOIpl9tBYZbDGIcqxiq4X2lASVcgeV1HxTJPd282H6wCAFqfTWafk4BxIV
	 9GA5x/dRgc16XSlrrJsJCpmg7BId+gA8MbyBBuPGMugcmD3CbnEF6U8nON/8v1fR2h
	 FzNSWw7+9Br3Tpokdio2tyivE4Rud0gO3IKwV1E3tOaZgMsoyakFlGDourx/2w2wHU
	 7KP/i0dRFFwdXwBt1gIl9k+YmXEtYu70iOYlHmojaTWWZlV4i0EfGHOqqqxf2pbs77
	 1aaJg0xm7wp+Q==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: [PATCH v2 0/2] mm/huge_memory: flush dirty file PMDs before
 removing rmap
Date: Mon, 16 Nov 2026 16:06:57 +0100
Message-Id: <20261116-dirty_file_pmd-v2-0-571883053174@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAA/3XNQQ6CMBCF4as0s6aGKdIIK+9hCEGYwigCmVYiI
 dzdgGuXL/nzvRU8CZOHXK0gNLPncYBcmUhB3VVDS5obyBWY2FhETHTDEpbScU/l9Gp0FpNN7Dm
 u0iyBSMEk5PhzgLfit/37/qA67MpedOzDKMvxOOPe/cVn1KgvNaIzlSGbuuuTZKD+NEoLxbZtX
 4tE/lS/AAAA
X-Change-ID: 20261113-dirty_file_pmd-90e63640a593
To: Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@gmail.com>, 
 Peter Zijlstra <peterz@infradead.org>, Arnd Bergmann <arnd@arndb.de>, 
 Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, 
 Ross Zwisler <zwisler@kernel.org>
Cc: linux-arch@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>, 
 stable@vger.kernel.org, Chris Mason <mason@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1153; i=david@kernel.org;
 h=from:subject:message-id; bh=idU/K1Zt+rfQyeUYE3QGExobNZd3DZ1ROw4P1GPUcO8=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLJ+y4io3+H5fH/PdMu51zh4HDrXWP7i+vZUvenPU/GNu
 xTZhbg6O0pZGMQ4GGTFFFmCgu8bvHy5rrbajY8ZZg4rE8gQBi5OAZiIcTXDX4GkFO5tDXXN6k9P
 LO378GjaL4akD/lZ/dNdlJYd5P10aR/DX/HsuW03vJpuJgbcyHjJdabhydNbfwNjY/0YlNqKHed
 3MgMA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: s4qf93ycs8fi4nqu4izgamifq5nyei9k
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5932A20005
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794841637-923606
X-HE-Meta: U2FsdGVkX18ayD7He904gnMruXnZLtE4lkqu4k0TgdUivIrFvHyATne7ay8TWRZ9f76H6Hsr9HdAQxMwX3eT4LE89wgzc7dZw6bUWLl6Wcd6EOkX6ijENlfZumEQqtGO2GDypWsOmpg38Y/W7czMJHk8sQ7TxgUFriNbGQ5dXbDXXWLQZK3fd81gI81R9MADtLYi0YYZzbDg6mpCHEjhRJzRZk8dBHEsxqqZKFLqudumOJjNCEhFACJdDFRaJ8qqsNvgrpUzW0b3SCv3xxL69jX5CRm4fA1akohoUzt1EJhn7lSI06ZBrT0YO44z1Y1jOwOhT96DYK1VP7n0GL/EQrCf/ueGNSDG75WjULocVkSDqf6JlmJySUpD6HwJcbNcef92KNuKXwvPKJPXFpbvvlLPNa8N7gex5RIEc+eG/i+OYE8RsVfJtRx7/rwvkg2w/gGsyAzGSFSN0xZTZBCeyl1tHk9l0mZZjhinsshrlmB5lzEd1dYguByMHZ76Dev1VlzXliIJShTOayfA2avh7IC4+t+u/VkYUOmW9irt5ZOJzFpH8IDDMJiMzJliOOBfsaaplDP5nuQClv+gay8M1UbUgezbq7NgwlChIqBOHFDtUMiPgdA9oMGcwQ3MzRw4NptAlB5BaTrZRc7t1Yz4cE/n/JC2H3FU/1rM5Xeadnkdyd7B56u5Lizb3gTVT7FzxI0KUJOZoKDvTpPT3iEu9ZeVcTYpetV+9fsNHoko8L/6GQWMKsuUs3hH+TwubaqxU67jJn/qoIr2MDn3mcpbbXhQ1JEAeRRbcKUNs6Z/weSMRRZXrmPbiKRYL9TjHSXK0QFWEC/vAhZSFhezT0sUjGNNXQfnQ4WbJmYxV0VQBA2/ljTluzTMHtrEdsc/bzFvB0lKr0DEa/KzIb+DpVDShO8lVYnA+qFXcNApy6JJgYCLY7U/YBAf6jIkOpVsxVovAufU9WWyRQdWBpezSyQ
 GAT+3B7M
 9yHL4N4TkM586X+G4CTDIaGYZdaTN6YSqIEMktKrVi6EH5ozPgGBzODgjs87IYGTJasZumyKNOdkjeDCFOhz8d9N7wz5ywzRMGwE23cCGI2kKMqswbN/QR/381kY6+/Vw0YVVfWy3aXTLiY5LfmPlvYnqDXGPrd8DyX0nwYgWwsZSmdxskE8B3H3M5iqGMXoK/GjkFOU0oie88KmqUJroRDHIqx8qDzgTCnhkUW9nSoLW5P7byDJxYLSB8zeMo4NZKMdCe4uaKgkoQvicl4TMh2y8N3TkDDuxUdKPXEghqvhZ358qomrhHugD+TCqxgDAxXdJkdccf3dPf+pZmFktVsKZ9Et+7Vur/ujvpOxgUd32Ang6H4UMnrWk+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Details in #2. Now includes a fix for a preexisting issue on UP in #1.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
Changes in v2:
- "mm/mmu_gather: delay rmap removal on UP as well"
 - Added
- "mm/huge_memory: flush dirty file PMDs before removing rmap"
 - Adjust comment in zap_huge_pmd_folio() to talk about stale TLB
   entries, not mentioning other CPUs
 - Adjust patch description
 - Pick up RBs
 - Use Closes instead of Link for report
- Link to v1: https://patch.msgid.link/20261113-dirty_file_pmd-v1-1-8c11f2a2e65f@kernel.org

---
David Hildenbrand (Arm) (2):
      mm/mmu_gather: delay rmap removal on UP as well
      mm/huge_memory: flush dirty file PMDs before removing rmap

 include/asm-generic/tlb.h | 16 ++++------------
 mm/huge_memory.c          | 39 +++++++++++++++++++++++++++++++--------
 mm/memory.c               |  2 +-
 mm/mmu_gather.c           |  4 ++--
 4 files changed, 38 insertions(+), 23 deletions(-)
---
base-commit: 25f5c92e1ac06496679ea229e5c825aa88968efd
change-id: 20261113-dirty_file_pmd-90e63640a593

Best regards,
--  
David Hildenbrand (Arm) <david@kernel.org>


