Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6260EC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 12:24:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF9FA6B00A6; Mon, 29 Jun 2026 08:24:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD19D6B00A7; Mon, 29 Jun 2026 08:24:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4B396B00A8; Mon, 29 Jun 2026 08:24:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9B0E46B00A6
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:24:13 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1CB9A1C69BC
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:24:13 +0000 (UTC)
X-FDA: 84932867586.18.84465ED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 71F6A40002
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:24:11 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="U/U1oudd";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782735851;
	b=KZbmEwvRwaqRxFYopKev5aqk8g5hizT/uKkIP/Xy3VrOq5oouJcMOBL+F86S87sbKAHJVA
	fRry5Bc4ZUcSwGDQCOTtSKEcCqB0hzWPWXRnzU8cPIuL2/OhtxcPD2Af4PYNX3ZaambdbT
	0DRDFMB4dtwfKfvzsKgi83lnm5skPDE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782735851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zVjmXpiPRDEuxz5eG83icMPmdk9wIBZlf3SL8DGVmHo=;
	b=2AaP9IRIfpfw8JEMFPcyir/Gs2zV/6JNvud4AAMwPssXC1jQSEI3aJtpeKtcTIURjLTPrd
	Y9FxJDG/K1LGFDxKw6ZSFc4tQGY+ib1dGsEUxAMOsEBsT1RDl9ltt6K6hyBX+CvxplCgxM
	VNmb4u6byHiQUboBWiAsRe9C1E/TJAw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="U/U1oudd";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AFAB243A39;
	Mon, 29 Jun 2026 12:24:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4C2B1F00A3D;
	Mon, 29 Jun 2026 12:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782735850;
	bh=zVjmXpiPRDEuxz5eG83icMPmdk9wIBZlf3SL8DGVmHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U/U1oudd2OHsamjeEZuCvVMXdEMpD/oNczijfmJk++UuSM0tp0M4bDoBkBnaZgEGX
	 Rzmf5lgUCLOwf33ifMK/K2bot41pBldLuGDyqh4AHtCcQbq63vAXxJLsQhScbx1wjy
	 pAmJsMiKpOZTiLamQJyBK0RuwzcIABdz8kvfm7lfq8NBus/l7rZHyqG7zzwotne8Nc
	 GTXNJ+fbsxLNNKwRHR60RMPCFuyleSFo52WnA+wKgJklYu/E8UISfAtIT/7g6bzNml
	 Dn0Xje1cMb8CoXoDrIYucp5qfkxy+YeGy+zN6IEHKnft2iA8dzEBICTockHkc/ttHS
	 zMtueoMKRjIEA==
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <linux@armlinux.org.uk>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Simon Schuster <schuster.simon@siemens-energy.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	Ian Abbott <abbotti@mev.co.uk>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Dmitry Baryshkov <lumag@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Alex Williamson <alex@shazbot.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Dan Williams <djbw@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Matthew Wilcox <willy@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	SeongJae Park <sj@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Hugh Dickins <hughd@google.com>,
	Mike Rapoport <rppt@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-parisc@vger.kernel.org,
	linux-sgx@vger.kernel.org,
	etnaviv@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-arm-msm@vger.kernel.org,
	freedreno@lists.freedesktop.org,
	linux-tegra@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-mm@kvack.org,
	iommu@lists.linux.dev,
	linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	damon@lists.linux.dev,
	Pedro Falcato <pfalcato@suse.de>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH 05/30] mm/rmap: update mm/interval_tree.c comments
Date: Mon, 29 Jun 2026 13:23:16 +0100
Message-ID: <80d482a927b2e9862487b812e0ab48ebc1289a70.1782735110.git.ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782735110.git.ljs@kernel.org>
References: <cover.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 71F6A40002
X-Stat-Signature: amx7jpp7u4dwn3omrxkkiywfea8zdq1y
X-HE-Tag: 1782735851-188083
X-HE-Meta: U2FsdGVkX1+IuFwFDH8MdhsaoD4SavPpED6MlT863OtDb677fQKp9b2GWGleF1jF1HEfHaYo4OaN9tL+PHN8mwtOYqZF5L+mWNtZH2YxAQI+ULxXUJlv2oY7VY5mSpb4RgL1CXqlJVShZp1kd6Vh3qoDq9mEOdc6UeTFUHToArjrn0NOOLGyOEqBlxyRWl02nAK6nb3OLbsenl2d2dKj+FQ38TurnZsKXbnW/UwYA9VMo4g7FFCcOxicCboZsgMg2TPuQ4+VxrUYyz76iO2qQmdiYIwn0lZr4Mxtav72VyxgjaaSJewhfXIsh9RJ+cZlF83xi55qKSDOsktUG29DVgaF6Yr75o+5Hpw4FslORA0J01sSIKfsnDHbTnWVYr99hD95ZFb/wTHxHjdB9tNAmDlkcX1Z1rsPHHdw8L3NKUF+n5kMbLNlybIcxUqPllYdc/yMwEJd9eLxVzt5C1X7KlgkkPWX8xXKFhq73upra3+wV4Ia0AqcQr0ftES55rGW1QyxvOnZGiy6d1IrHy8tlhfjThNG4bJ7vY2USM3mZjF7qEsmLnq3VBKEyOrHhnm2J1HoE42dkxz3w87mjYAAjRVYT9hYiSAGIoFO3/KFIOj0TcfKVdmT+gB+1WVEFJeM8OXpeIEyMngXw+ouv8Iw3Ehc26NULGDQSsrIAlnoHQRgjM+waDuEHxsq4H1JbNbzSELgO2jf9S0twggxF7wkWJM2HsVIDZiT+ylPJYXu/CyrsJsP8VSZ5L42WuO2GbvGLWuV/Nlw5dW6EXI1dEhKJ4eyqodw0jgdaX5EsEXXfFEchH7ldMhYdoshbHhTOiYd1KbSqEMi8cLXqQa8ejW6NaUmWX6MQma+tUkDngkP0aO6EwYWMbcErXu67ZNwNHxPC6bBHfTh8F52NCvpslhJXg7B37pOcXeZQopkCF9qr398VeE7cjKLlQTr4Hxq1hlac3vielYQDzIW6T7B+Aq
 w4mxArxq
 4VGY+pqh5QoHYn7VV9J1Bk2NQxGztFvlhrZUCYW8OmAro01JXjWTZhNfesvdeUL0AUBEg8WLVdbNo/OMrVNYUOIQekD+AggvR+ZtJQKlDriK6kEJmA8nV60rjJN0KoSVeI+E7ZIUjIf22PqpSSey1qjVgF5sSHwwi1Uve/h9bCAuM8MGW1eAOhvpAHdUw+/Oe76f1RCqknAQ7Oh2vo3G0Pi5a7nKTXaTt1+DoRhqth8zVXgqqn5lV+ZYixvhGwqbxhNtK7LbRBRQH356tVF0UjBEUC9nyp1o/bPedyDLzSL/MKYm8Ps8TtZ+EWwKuiiiIU7F9nk7dqeXPhCh6qWqimc+sQ8ohE6C0PG7ztOkfLWPQEHYx1FHMQT0yMf4lIwagNUIO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update the file comment to clarify that both file-backed and anonymous
interval trees are provided, referencing the relevant data types for
clarity.

Also add comments to indicate which parts of the file apply to each.

While we're here, convert the VM_BUG_ON_VMA() to VM_WARN_ON_ONCE_VMA().

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 mm/interval_tree.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/interval_tree.c b/mm/interval_tree.c
index 344d1f5946c7..2d50bc6228c4 100644
--- a/mm/interval_tree.c
+++ b/mm/interval_tree.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * mm/interval_tree.c - interval tree for mapping->i_mmap
+ * mm/interval_tree.c - interval tree for address_space->i_mmap and
+ * anon_vma->rb_root
  *
  * Copyright (C) 2012, Michel Lespinasse <walken@google.com>
  */
@@ -10,6 +11,8 @@
 #include <linux/rmap.h>
 #include <linux/interval_tree_generic.h>
 
+/* File-backed interval tree (address_space->i_mmap) */
+
 INTERVAL_TREE_DEFINE(struct vm_area_struct, shared.rb,
 		     unsigned long, shared.rb_subtree_last,
 		     vma_start_pgoff, vma_last_pgoff, /* empty */, vma_interval_tree)
@@ -23,7 +26,7 @@ void vma_interval_tree_insert_after(struct vm_area_struct *node,
 	struct vm_area_struct *parent;
 	unsigned long last = vma_last_pgoff(node);
 
-	VM_BUG_ON_VMA(vma_start_pgoff(node) != vma_start_pgoff(prev), node);
+	VM_WARN_ON_ONCE_VMA(vma_start_pgoff(node) != vma_start_pgoff(prev), node);
 
 	if (!prev->shared.rb.rb_right) {
 		parent = prev;
@@ -48,6 +51,8 @@ void vma_interval_tree_insert_after(struct vm_area_struct *node,
 			    &vma_interval_tree_augment);
 }
 
+/* Anonymous interval tree (anon_vma->rb_root) */
+
 static inline unsigned long avc_start_pgoff(struct anon_vma_chain *avc)
 {
 	return vma_start_pgoff(avc->vma);
-- 
2.54.0


