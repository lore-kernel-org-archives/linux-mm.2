Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E93CC79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 13:34:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CC2C6B0099; Wed,  9 Sep 2026 09:34:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A44C6B009B; Wed,  9 Sep 2026 09:34:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E1486B009D; Wed,  9 Sep 2026 09:34:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 10FCA6B0099
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:34:16 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6942A401BD
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:34:15 +0000 (UTC)
X-FDA: 85194317670.18.528B8C1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9E09440008
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:34:13 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VKETAwhb;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788960853;
	b=NFGSMgXaJ3aalaXD3Hqq8sYiJV4tiMAgoiXlD5cQitmTlQFX8pkEf3N9W6SZtB5+WpsJx6
	pDnZOn9XJZKNltaK+mAjfVVVcvEKN8NSUoMgT2lgXZX/kKMo5VyRN5xqXXPVE9zP9VM1QE
	OvTX1JzwcqKMfnHi91zC5vHCWjQ1mWQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VKETAwhb;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788960853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vwf3XHFmLke+N9soz5HJtjy5W6jvA8C1cmDilLBFR0E=;
	b=2zatj2ZwnPmmMfYRlLP5f5NK+R1yB8lnyP9h43dFgKgIP9ILuHfiNfaROCuDfhwS1zlTkM
	ym52/d1udlfLFwMftZ2mG/cY2IhF06gCGJgfxC8yixCeXG4k/1FnKizemNMbj/PXaLINR9
	Gpnr1W7nUB6U3vwE4TPAp8mQcszXrZk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E479E43A57;
	Wed,  9 Sep 2026 13:34:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D97AA1F00A3A;
	Wed,  9 Sep 2026 13:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788960852;
	bh=Vwf3XHFmLke+N9soz5HJtjy5W6jvA8C1cmDilLBFR0E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=VKETAwhbvv+EK0Gm31QFMYaYfrQJ2PkX9WiTurdg0GqN2atlcsKeEnI2LT69seS1g
	 ckmzVzkRoynOrvTlgBNzG1vsWAhQRsMuS1a7vuZYSDXafGxdgK9TNpx4ebCVmVAjM1
	 xDU1YFvqp0/x0rO09WvuApW6ngX9ZKM5Vkq7BQ8v35OA/CBlRB5ViylH9nulLN/f29
	 5dnXJYPV5oRwG4/vm/WSmAWMIcDVIe38hgrg+TvfeE1NJrKE8c5xy9uZKJTJnaRbyS
	 OkQib97F1RX0R0/WJwLRKYGE5XY9OxKPJH/UsYWzVYILEjG7UPdcd15Pipp0iFaPrd
	 GcwqJZUYV2Rxw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 09 Sep 2026 15:32:55 +0200
Subject: [PATCH 02/12] mm/sparse: refactor sparse_sections_init()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260909-b4-sparsemem_cleanups-v1-2-008fc8d579fe@kernel.org>
References: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
In-Reply-To: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Oscar Salvador <osalvador@suse.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-fsdevel@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2859; i=david@kernel.org;
 h=from:subject:message-id; bh=vj5TwCzhlLxvUe7A+Bx3R9PGajolUon6lM6RJzWmxHU=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIWJmg1TG/wTlyzoPKR2TK/dRFzncSdjcw5bZd5zM1//
 dqqsVqxo5SFQYyDQVZMkSUo+L7By5fraqvd+Jhh5rAygQxh4OIUgInwTWD4ny5++k5Jx/wO5uki
 oZopr+4wct0S4XQ8sunwR2f+wENn5RgZrr9oaQteGlzRdT11x6xTOw1nq7yNDpm/IaqT039Ki3U
 fNwA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9E09440008
X-Stat-Signature: eptb9ngr4sx7kqiiudat86sma4wn7d7b
X-Rspam-User: 
X-HE-Tag: 1788960853-970478
X-HE-Meta: U2FsdGVkX1+sk9k3fh9bqcHuK2/S5rWP3+g7tuxaD26TCQJMwzAhpxXvsCMP+BOHQqLcyJQBN/RhDt5f/2bY33Y6GdCI3OVnwYl5fwiJN2B2qRooxnm8PZ7srlpZZI/PvQVkr2psY2WmCvpQr7/qI4c+fBUXjBleI9XWWF1NXsik2NstZiNv/tqjMZp2Wm2TbBUfoVUNTxd8FaWxJzdYzxAhIfA4YskaSXAiohufr2I3WlMK81pR/fSozSX6f6cEputIpf7EP7d87kHCnob12L98mslFBatlDjWTwpg1MOC7vYD7ua/sUJWwiSHhJj4Za9jSYwX4PxT4PMV23vWzieONu5QmwrLATfvWQryMGQo2Pv+6gJ7xV7hMJI4JangKE/7piyirENVzEa53iVwD89OT535rujofRDTYRM135HIeg1JmNuUW5mE3xY1dinYRqHgIX6Sbd+bLygTWUWrZRrs5gVIxlEgXMQt2Gm8KVxMVhb3BcBIRnhtGKabqcnS/9NKshmMlw7UNcpz4jWS/kF+19Gg7hpmo5K7D5zaCNtzNzQXT4SmZjxv8NzuR3bxe6rp7e4/M67Y2pR8ZoD19jDJKWqvW6PWg2kul5ADn0C6g1IFq9xPU4rEWFlMnSiAaiDd/+02MEBcAw+kpjABO7p5szwjBAuOw89nHz5qj47sN81lu/f4dSJDO46rwCeXvcLp4O9fC43rpg1Aw1GdszrvAZLQ8ltvfM+VGai2i0XdukSgxdqP0QCx+g0zuQA83tfuPSqjiDj5WYDrTXMcKwIPgmHUvQcAW5B/9u6JlZudlX+3H2RhRMOg6HWtHXmJ+sHWbdkNsv3gSeTc/eZ45yNw9n54Su0Edm3IR5KGkrBhZojGXVuBpHgLQVQRpDyePkooqW8qeUjZV4ZM0chGhgHfdj6zAeEZVltPdPKZW1Oog68X6X0TNng9Tvykx6+9OAgcOg7yngp7Osm7MLak
 dq3ClmOu
 WrTuIpXIR1XV/zA4cKtSdyuZ8P8urV9VGNavmYkeqriqmbqBI1xs/UMfYyzr6S7EUMSK68Ck//dRLaPP45seCEwjbNaprcBN2nPJUKsmRLSHtI7xTcqbKRNa408peCEGumosGq2fP7Bqq+q36NavQvtsEMbp5DxSy3+rJSfE7UMZlECZc1rNBOnNSSTuzY4b0aIxcNxmmH71jCh7Heocops+vXHK+r8ku6k/MjPN+pDXw1jkaVcWRONcLM2W3egIRmpEDaPWgE5ssvCUV8SQDNLhQDP/vUcOg7zkI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memory_present() really identifies+prepares all early sections so the
initialization in sparse_init() can properly iterating them to
initialize metadata.

Let's just inline memory_present() into sparse_sections_init() and
cleaning up the code a bit while at it: make it clear that we are operating
on pfns.

Note that we call set_section_nid() now only if the section
was not already created earlier. Now, there is no more inconsistency
between what we (temporarily) store in ms->section_mem_map and what
we store in our section->nid array.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/sparse.c | 41 +++++++++++++++++------------------------
 1 file changed, 17 insertions(+), 24 deletions(-)

diff --git a/mm/sparse.c b/mm/sparse.c
index 6a6d258862904..36e3d854febc5 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -179,22 +179,27 @@ static inline unsigned long first_present_section_nr(void)
 	return next_present_section_nr(-1);
 }
 
-/* Record a memory area against a node. */
-static void __init memory_present(int nid, unsigned long start, unsigned long end)
+void __init sparse_sections_init(void)
 {
-	unsigned long pfn;
+	unsigned long pfn, start_pfn, end_pfn;
+	int i, nid;
+
+	sparse_extreme_init();
 
-	start &= PAGE_SECTION_MASK;
-	mminit_validate_memmodel_limits(&start, &end);
-	for (pfn = start; pfn < end; pfn += PAGES_PER_SECTION) {
-		unsigned long section_nr = pfn_to_section_nr(pfn);
-		struct mem_section *ms;
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
+		start_pfn &= PAGE_SECTION_MASK;
+		mminit_validate_memmodel_limits(&start_pfn, &end_pfn);
 
-		sparse_index_init(section_nr, nid);
-		set_section_nid(section_nr, nid);
+		for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
+			unsigned long section_nr = pfn_to_section_nr(pfn);
+			struct mem_section *ms;
 
-		ms = __nr_to_section(section_nr);
-		if (!ms->section_mem_map) {
+			sparse_index_init(section_nr, nid);
+			ms = __nr_to_section(section_nr);
+			if (ms->section_mem_map)
+				continue;
+
+			set_section_nid(section_nr, nid);
 			ms->section_mem_map = sparse_encode_early_nid(nid) |
 							SECTION_IS_ONLINE;
 			__section_mark_present(ms, section_nr);
@@ -202,18 +207,6 @@ static void __init memory_present(int nid, unsigned long start, unsigned long en
 	}
 }
 
-/* Initialize memory section metadata for all system memory. */
-void __init sparse_sections_init(void)
-{
-	unsigned long start, end;
-	int i, nid;
-
-	sparse_extreme_init();
-
-	for_each_mem_pfn_range(i, MAX_NUMNODES, &start, &end, &nid)
-		memory_present(nid, start, end);
-}
-
 #ifndef CONFIG_SPARSEMEM_VMEMMAP
 struct page __init *__populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,

-- 
2.43.0


