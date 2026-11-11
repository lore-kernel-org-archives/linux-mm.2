Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F287E606A8A5
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 18:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SjvbQVSp
Received: by kanga.kvack.org (Postfix)
	id 1CE1F6B05BE; Wed, 11 Nov 2026 13:14:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A5EF6B05BF; Wed, 11 Nov 2026 13:14:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 093BF6B05C0; Wed, 11 Nov 2026 13:14:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DFA636B05BE
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 13:14:53 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 76AA580399
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:14:53 +0000 (UTC)
X-FDA: 85423639266.12.F72B5AB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 911D3160010
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:14:51 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SjvbQVSp;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794420891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iBrqxDvAX0jm66MYxGueSU6Y9eUtRw26738r/ikyIJ4=;
	b=BYY7RhyMHrnASPodUO5GQcH/z5QVxK+s5/uzCBTIHcGQ8IC+zToqHgs52vMxjohQ55KsMn
	v2ahsOv9yMZmWbc4e7IN9TcUwfZgvG6NSMQZB6S1uKPKuybXx1TQ7yHUhxQO4npSDujF8L
	AdmTfTyxMoAsi+ZQHFAp75XfOPv67qY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794420891;
	b=0bNcjEK1/rNwyQUt0J2Oy4OyaLLOgHY+/Hi71pxr4luFjJ2GYiNS1nmYdMVUUiHjd1oM2Q
	awNv4kPDMSmih/wzPoiSKmFrSncAn8sr3jE8VToHqX8HpTX9Xo+cRuQflB2aKeWMTUHaXh
	6bi3v6vV4Gobk4YQ++X5lDs6JbEwZoI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SjvbQVSp;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E445442B9A;
	Wed, 11 Nov 2026 18:14:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCFC01F00A06;
	Wed, 11 Nov 2026 18:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794420890;
	bh=iBrqxDvAX0jm66MYxGueSU6Y9eUtRw26738r/ikyIJ4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=SjvbQVSppMTg2svz/QJqu/NneUf/CM9ncBjbTwznaM/ia/FZG2x6VrAbIep9rXiOb
	 9YdTerPAfZDGdMEqtMTQxWjesf/YknFJY9VFVarEG5R94zHAQ5EhvNw7KwlvHF32fK
	 S/lZ+DxCTtd1c3W5mYdwSJhzS+h0PXqRlqD0U7WmBy74VpWmjtwjASpxP+SQbOPr3s
	 16FeyHejGTbuucjHttyObG7cE4/tikgwSeF1Xc2YXO2h2KJIsMLucauyScuuBK1qxR
	 nvxTWBwN+DjqMFRgzCAhRDTILzcMmr7OrRgMaT2Pve7K7/qOAl5asIIhdBgNdzVXwu
	 9kURjg/DKSBGw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Wed, 11 Nov 2026 18:13:18 +0000
Subject: [PATCH 04/13] mm/migrate_device: allocate THP deferred split heads
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261111-mason-migrate-et-al-fixes-v1-4-3d2454362e8d@kernel.org>
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
In-Reply-To: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
To: David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>, 
 Kairui Song <kasong@tencent.com>, Balbir Singh <balbirs@nvidia.com>, 
 =?utf-8?q?J=C3=A9r=C3=B4me_Glisse?= <jglisse@redhat.com>, 
 Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
 Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>, 
 Chris Mason <mason@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, "Borislav Petkov (AMD)" <bp@alien8.de>, 
 Mark Brown <broonie@kernel.org>, 
 "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1849; i=ljs@kernel.org;
 h=from:subject:message-id; bh=ibMf4g8+XoIQ5HakdVfha6zsUSXLFsCy8+nehPr+V+0=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLK+bMieU3BEonX2kbI2rkn+W+ZnJUiu/7T6n8Wvmyrbl
 q+RubjoVEcpC4MYF4OsmCLL8y/i+4NEwuZ1XvB3g5nDygQyhIGLUwAmMn8HI8N18Z19Rcp9ndt6
 /NbOdXwU4Ht2nULe5OmXPmSaOzW18T5mZDjcFrl5b7baCYmE9k5jz5oJW5Sn9OTNz05XUblt+Or
 4NjYA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: eem11mur86wu5fa6j7uqd1j9fkxeqfak
X-Rspamd-Queue-Id: 911D3160010
X-Rspam-User: 
X-HE-Tag: 1794420891-65746
X-HE-Meta: U2FsdGVkX19Ko8/ppAqE+tDfbJY9at3YRNxHdzJwPHQ2thV71JGi5WN8EA4KmtZsUCfF2YJsUMrw6wVDZbYdjXvYUhe2cn+v+RQrjByvUIu+j9ZUBiK18A27cFmlpfkT8xXD4YQ7FDTBQqFpLLw3Kd+LWDPQiAe9BY42DC1i2a7rESKhIjXaPGavpYpsdgcT+Flw56f/4mypAuuuUmZrfO943mgBUUh/wviuaBHwn2BTZXZfU9kjZZpZ9CnL+Rj8YLfFmzhAhmj6KVt+zCe2N6pxC+5Z9e/HwJOOTzqjpfVYN2+bxvrKqFFFul/Aqoivu/1g7+Rsj2kvU0hs5rtVaVnM/mQzjxikvCqgTqm/FHUkG4bTnia/ZUiRjBuC9VvvsRaxUyxH1Pu6K+e3Ln1rd5+DUm+TilcIOakSFdqLc6FVV7Xx5gQ1+2x2Cg556Veygs6rcFP7YfFY9slXD/xVfr1wB9/haKrmskCVOnFkWoEdudCvpZOAdtTDXjxUnamsYtJngfI3+sO8mC8ury0qHOUfMDV9zFF8WpxnvizZal6CbmX12Xj1Pr4hv3//0KBENZgKsBLUlhr8XJqHaOvf+ZZYpwEbT+xetNb/vdrdX0EzGwLhQwXJQQSnGCagprPU0lSX1Bq7qhDFNq2X3n+zi3ESzNrdk+Ch0C55YqhxcZy2OJFy9M342XORC805V8JNTK8v9QZiI2awc4g6HKUPZoFWVp522lIMqsQ/+6YfrnYZ/+F36iA6j50LOW6dGmsTa5kix4aAl7tTGZJ+RZFYMRIyu2+sLJz5eyD287fCLCNf0B2UwASYZhUoXfG4oriM4AkiDomMu/wYjnK9pMerzI7MkUJm0QI4QJoZk6K+/JX17gQkRyhCF4T1dKqobo7gtZcqeUasmr20S5I9OzfgmGmqgfLhWTaJtOI4eeUeHOHOBqBc72n1Rshtm1uUjD/WdcHDvtAbTf1OaKv+/Zg
 hE2yTPqy
 /gszhtF4JhmeSvB17W5rDaKLWyeFZzVSpb3IJbIx3PoAYlFbWjQAtCtVYmeZRmJZ2J+zf+A2+I3z+ZiYCTtXcBBqt+wQnCqghfDS7md2FgvrOXBt0Pyx73I17F88Pvqp5+gUGlX0e0XGyG0jA89Usce7kS4We9B2qTmH9lVuZrMVihic6W8HIxO93Xe/qke/9o83JEl8khYL6xe0NuiV0PTw8+kYzYI5zEAJKrIDh1LyRxvbg3l5c9pDiajhHJqhTAy2PNAlZH710TOefUfTp9T0y/MTmovw69+od3JSbXDAK+9ih/3SROXTF7Ruk7jo2KeL2IAuZfhO+LyU+65rpREHq7tcKKVcaG4U1ixe3mIePggnBUOC655Hk8ISzHH7U3gS4E6C+97j4Qq9ZFhg0koYDI3fRjNx5eBvkyAIz9mobJUc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Josef Bacik <josef@toxicpanda.com>

A THP that device migration maps into an empty PMD can end up on the wrong
deferred split list when it is later queued for a deferred split.

This occurs if the memcg has no heads yet (resulting in a warning if
CONFIG_DEBUG_VM is set), where deferred_split_folio() will then queue the
folio on the parent's list.

Once a later THP fault in the same memcg allocates the heads,
__folio_unqueue_deferred_split() and the split path resolve folio_memcg()
to the memcg's own, now existing, list and take its lock.  They then
list_del_init() a folio that is linked on the parent's list, racing with
anything holding the parent's lock, and both lists' nr_items counts go
wrong.

Resolve the issue by calling folio_memcg_alloc_deferred() after the charge
in migrate_vma_insert_huge_pmd_page() and falling back like a failed charge
if that fails, as __do_huge_pmd_anonymous_page() does.

This was originally discovered by code inspection.

Fixes: fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru")
Cc: <stable@vger.kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[ ljs: tweak commit message, remove unnecessary comment ]
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/migrate_device.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 9e19fadfa65c..9e5dab8e1b77 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -833,6 +833,13 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
 		goto abort;
 	}
 
+	if (folio_memcg_alloc_deferred(folio)) {
+		count_vm_event(THP_FAULT_FALLBACK);
+		count_mthp_stat(HPAGE_PMD_ORDER, MTHP_STAT_ANON_FAULT_FALLBACK);
+		ret = -ENOMEM;
+		goto abort;
+	}
+
 	__folio_mark_uptodate(folio);
 
 	pgtable = pte_alloc_one(vma->vm_mm);

-- 
2.56.0


