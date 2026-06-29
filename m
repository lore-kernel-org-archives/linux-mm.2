Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FCB5C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 15:04:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 602636B012C; Mon, 29 Jun 2026 11:04:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DB066B012D; Mon, 29 Jun 2026 11:04:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47B4F6B012E; Mon, 29 Jun 2026 11:04:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 169F66B012C
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:04:20 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C516212011A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:04:14 +0000 (UTC)
X-FDA: 84933270828.11.A2BFED1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1E9CB16001D
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:04:12 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PcDHXqhE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782745453;
	b=fRZUpPLWmaq1HvF6ITI9/18aqlPCnMUezWxmbpbicDLZAY+78jXFvROM9jetyj4A+xRUnH
	xrP4uCqwUhwxL7p6Nyj1akMc1Qw3qcvGrT2pWbqm0udqljGiCT0I8slqKcDdNklNGifBV5
	cFG5TCbpGQ2GkjxOaB+pThPXO280geU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782745453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tWUJODwdTE7pH27pI40oaqFE2CYlQJqY1Z9hmUi6ed8=;
	b=d32ovKsuLimCkEIPsq+q13s6YwlQSJcBiBfF925XmF4JCcimMewlMRJ1LwvZSX6XUar6Dt
	z0zEIo3YikCBXkq3zGxGBBKFDK9sUFyHWNkYl13gZimDrhsDogbuKQu6mOXdN5HOQwIciu
	bSteNn3+MZ7DcuBtA+bTOI1JB1msWx0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PcDHXqhE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A9D8560129;
	Mon, 29 Jun 2026 15:04:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C4F1F000E9;
	Mon, 29 Jun 2026 15:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782745452;
	bh=tWUJODwdTE7pH27pI40oaqFE2CYlQJqY1Z9hmUi6ed8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PcDHXqhE/bIrZtFQ9F+4e4CNVz6V1zxlfjiFoRWxC1FDjE2JODm8vZb2iN6Eigzno
	 Ph79Y9UrJqcVN+LGSlnPItEj4sZYiQkqg6bD+McwtzEJm66HSVr/MBs1XcEN6nv27W
	 N6DCX7mWnMYR9EK7bLKbqxK+26Ff1GBjJqTcTEqCLkf/44WEU9mJaGc9wPRxLCBL5f
	 ukj9O2dq8s1hFfITtdeXoOnwmL+lVdivY3/X1KUAuhE/5zGqtiK29pSEr3fHuXrtc8
	 bFud6jCxY+2pSJ2CEAJT3QQAG/uhAY1BuJQS0h1qZUw/Fu1/9VZd5+KoPGUtYMAjXP
	 3J8FGt4KLhgfg==
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Kees Cook <kees@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [RFC PATCH 04/10] mm: update print_bad_page_map() to show virtual page index
Date: Mon, 29 Jun 2026 16:03:44 +0100
Message-ID: <f10dd43c4ca57484948dcdd9be9fe398f79dc9d3.1782745153.git.ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782745153.git.ljs@kernel.org>
References: <cover.1782745153.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1E9CB16001D
X-Stat-Signature: fasr58kwx5ay9xdykm4hwm1tkbtginnw
X-HE-Tag: 1782745452-744399
X-HE-Meta: U2FsdGVkX1/uDM4i7U1rmb71KeW+bn6z+1WSuNV1N7uXMAZ2EW9CIsun/F7+Hsx7A2/Fq7rgDIKvZYNDXnEe8Kp7lIfBJzAEcUablIyEGs7gKseUOy33BadSfQ7xr7EXkQBIt6m6iDoyl9FPm7fs6SRvkyn4q0I24P8qMaCETzXp/VZZ+iqLVY6mdihsXqX6pvHJriNqYeHSq5z/lGXGgqI9v+TUyQoP7KZMsD3u+5D6zQIrZiQa67oAZC79JhPYKhxqJTsi2M8bN7wXnU6UNhO2kWQP+SxMlVrJen6i96uLrZYzd/Phevtq/9p32jk+feFKhY59SHn36w3Pgcz0ORDa9T2tXKXpwo+1JQ/eWUGzfZZXNZ5UrNfwwL/JT7RHvOyMidtmxdXNwfHscoBzejFuzEkjLJTaGJGiCGGrLlitsg0A9kv5n7sugjtAaB1BJf8vzrjX2zekkzYzbylWJU51xMT5iZjWYWXmG6qql1V3FKCkiSQWSkDDuttiJepzmItxi7EioBz8J0HjxWgz4hs/rRz8DNyZiabhiQf4pzxZV4M0QdMPUwmSnFsZbOz64KwjRDHY0/a8V2WtQZ48cv00o2Q+3igeiViHUTMNluF7mNNvAVqzORp2v7P33Bouu/lM9E+o4wvHkwwPqB/jqavQ88ogE6tVbPPrz7KurDyJIyMp9C/+dYVf7ZrMVnIdQsTMPFQjTEKSuP75+H3k5jW5BR0rUpZ5YxGH9mT/3Dp8//9S18wk50t/+EFToeE6eIa4Nqnkd7g3UeNffkiU6atN+ihERAiDvulhcAl76+QtkQVBApX7kyChXHAcAZAJYlw6l6qFCjw9oF+Cut0I7SPLlOa0QaBlWR2suz06Npf4TJEH6KihoTg8tAVgyNj3DbhQ8luxxZ4/tCi9yGTCBlRiKaT7WXP9WO3uHGZnHnVqtBLb5QBpTd9WLcS4JqXfyCW/7xAqysELYUGH9S1
 RwgxjE0c
 pJevLGaXMctVzd+Xz6DOehwKSf4QjiO026NWkZkH7tB1EBB3ou8UcKyAMM9JGrCvXZkYc+nJFtLQXajPvy9swIYW3yFroAywluT1cWtmqal89OAR3q7G+YWDThPTKpxeW1XPKlVvpP84PkvRvMiHVMqW95rNffEDpwlVObN0KdAvav3M1hWTso3BtRgOzm4kcI4nUt/bycncsm3NpEYkQJCrX2zhpfxccYss60F/IzXxnbmE2VwyyNIfC2GVqk+cCq+V2fSArMCO81vgzHXet5xDWPl57fFK1PA7skwQzel03kF7ao1abAz6kKzfgqkpiNf0aDrKhhQm6m9gQpAGvTmDMUV5ciSwPhT8fI9r3FumOC6s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is potentially useful debugging information and matches the existing
page offset provided.

We only do so if the VMA is not a shared mapping, as shared mappings ignore
the virtual page offset.

We use __linear_virt_page_offset() as the VMA may be shared.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 mm/memory.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index f5eb06544ba4..7890e5200ecb 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -588,21 +588,23 @@ static void print_bad_page_map(struct vm_area_struct *vma,
 		enum pgtable_level level)
 {
 	struct address_space *mapping;
-	pgoff_t index;
+	pgoff_t index, virt_index;
 
 	if (is_bad_page_map_ratelimited())
 		return;
 
 	mapping = vma->vm_file ? vma->vm_file->f_mapping : NULL;
 	index = linear_page_index(vma, addr);
+	virt_index = __linear_virt_page_index(vma, addr);
 
 	pr_alert("BUG: Bad page map in process %s  %s:%08llx", current->comm,
 		 pgtable_level_to_str(level), entry);
 	__print_bad_page_map_pgtable(vma->vm_mm, addr);
 	if (page)
 		dump_page(page, "bad page map");
-	pr_alert("addr:%px vm_flags:%08lx anon_vma:%px mapping:%px index:%lx\n",
-		 (void *)addr, vma->vm_flags, vma->anon_vma, mapping, index);
+	pr_alert("addr:%px vm_flags:%08lx anon_vma:%px mapping:%px index:%lx virt_index:%lx\n",
+		 (void *)addr, vma->vm_flags, vma->anon_vma, mapping, index,
+		 virt_index);
 	pr_alert("file:%pD fault:%ps mmap:%ps mmap_prepare: %ps read_folio:%ps\n",
 		 vma->vm_file,
 		 vma->vm_ops ? vma->vm_ops->fault : NULL,
-- 
2.54.0


