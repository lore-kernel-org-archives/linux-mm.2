Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43F08C55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 08:40:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43B076B00AE; Thu,  6 Aug 2026 04:40:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EBE26B00AF; Thu,  6 Aug 2026 04:40:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3020F6B00B0; Thu,  6 Aug 2026 04:40:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 044FE6B00AE
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 04:40:12 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7CA2814066F
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:40:12 +0000 (UTC)
X-FDA: 85070197464.07.FBA8E55
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7915E100009
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:40:10 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=SCDN3dhS;
	spf=pass (imf05.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786005610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GCsTohHBGdTI7OdSyzJzRMkcSEd6NU9RaG9o3LbcxHE=;
	b=BEJTmMdGCd70y3U7U3tJwCCIhrFzJSVKoxX3O6YpNZ+XnuwfzJscf9mRzec50Pe9+xCoCc
	iPCi9NGlSL2/G0oNuzJbsPPkHVqIzO6aG/fLN7Jbju7SfmCrurBJo/SznPYodp+YZrNejT
	3Y2S7LgGyuYQ+91ExauFcdP8hxOJgl8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786005610;
	b=xVYzlXIB/q0p/1yUFIRI6MfOXwjjheHcypLl9dSOGXuSAbs97PfetJ8X3XJjNkC0KNm7P5
	OC02Z0k4NdV3Ylfsp3wpqF3wSBde6NZKLnjqeiSOUagpeUH9HcLsWAcAt/RTRCa0NPeWuH
	buh3qnkSEJ2G4WSc51rCyygpaRj2Uk4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=SCDN3dhS;
	spf=pass (imf05.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9E7E7153B;
	Thu,  6 Aug 2026 01:40:05 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E349C3F632;
	Thu,  6 Aug 2026 01:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786005609; bh=iJ1Ndc5V3Xfq1tWscZTZQDNLVYCcoKPyTZqTCUohTZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SCDN3dhSTWUZvm7NxWd7kT2BoSqz+CVAJ52EjmPO3XFFI5DgzdxTKarmA8W7w8CCM
	 vAytJ56KvsfJiBpTM3sWcsX5b4vufVL2p6PVM/2YavA5VjzU41jcEC/tN2j35rLOND
	 s5OV5gCpv0HvNaWN+KVLCNsfqo1phtuKS4Aoj7Iw=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
To: Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Dimitri Sivanich <dimitri.sivanich@hpe.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Nick Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	SJ Park <sj@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Mike Rapoport <rppt@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	ziy@nvidia.com,
	pfalcato@suse.de,
	agordeev@linux.ibm.com,
	ryan.roberts@arm.com
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>,
	linux-kernel@vger.kernel.org,
	intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-parisc@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-arch@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-trace-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	damon@lists.linux.dev
Subject: [PATCH 2/9] mm: make hw_pte_t visible to generic PTE interfaces
Date: Thu,  6 Aug 2026 09:38:40 +0100
Message-ID: <20260806083926.1807279-3-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260806083926.1807279-1-usama.anjum@arm.com>
References: <20260806083926.1807279-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7915E100009
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: cq8bxan6rawkdwfo5okypazhrff7j4n8
X-HE-Tag: 1786005610-94613
X-HE-Meta: U2FsdGVkX1/OdYT9KmixLaAMa7kQ2U6Y1tx7pRNfyE/isPFgG7CGh1Z3CPk2zlyjbW1nYzeHiYZPGRP/AL5fFhaMGotcDaV9m/pna88+VFC8RMZH5Xk10Q8bk3x4O8HLNRjXV/TcW0wLlxSkbyCdPUmahZVccH69YAbS6FlUohUDGZk0VKHnXRiwlJ899fkXdw1WgxblfpkxdfCkxjU1p7Q9gKlir1MsxP6T2hXp8one/DFVCmHdi+8WvpMRozb3EdqM61zttPPNx3aWdaGCO7TcwaAHGyITq/s1jCkLxNNZXh7l87g9YOKKBgfACnYCsOW3sPAuPXmWl77T6NnpvKa/oEscbS0QQtlbdqWOc1xzEArIBRe0yayNcNrdxFwSBeezh4K3khPJd91THc9aZqLS7SuvuNYyMK3QywdqEy2prwQQ+F24CP5sB++j+mRtiG2P8sESEu54vvOcf7QfwUCKIBlaxqNo1mNr/lETm5Uax8QsQGuew4Pa7jx8E1pzYPdr/UGf5caub2rCJpVQovdbeiwGDNu+uEeyf/fUAHff5iQuZ+8tlWHt+3Ivq0JEkgQdduOx4F48ppiw9GKV0/yaf4STgjTSbmL92hQePd+3C8NV3Mhh/zK687ytb+UVdoWXHvavpl9D6i3E7AvYmf/TCVnrZ7oYUZZNNng5Q7hc/Zs4WIgWJuLNjtzn+VrzCBAcMHxOGIlRIqxzg+pJIXmJfWXt+5I4j59yTozxnGmuT8KyTfA4wR97J39b5v2M7vwsYNZeXNz9W4KvkD7PMFgrTblQ+sb/vlgwlAXWqmw50j05wP/CrAIzn6OGNHL12y+Lyvj2jx4lJB04fjqaFbdyC3xcmvgYwemdAgi+fZKOnIteb+YY2wUgS8Wc6G1tjk4DAbD3wv466B3og9+80Zrm773oNoU+m9LwpnoR0pbJg/GR0HynDLeFp6nx2CrdIsHQZHTCYXkHrrv08Yq
 Avywpb9e
 t/AKRAqyiBr8Np4LwrDqeNJkFfKIM7oNg0+TDuNdVkLBDUVYySTDIeBgcz1xAEJdo7L97KSS+FDLQonN1HoW+RuiTRVVhVPOAsuoO+/UczOlx0ZAI48V6shUJlgDk6obmUysmHYsu5ZjdtXldPM+7fPP0cs8Ag6lmX+vMy897+Ko8L2xSPu0hluUfxa1gy/8iI8xJj0iKH1oiU2o0Thj2RoEtD2hH9CqTh1BLuclewIMx+2sD25z2tiDJ553guEkbTw3yMxBhb3MgKby+pzrSVwSEokY+NZko9ExJwiLZeCQcqc4ZRLvQeAcqkS2cLsvQsf7OjNY4x2VQkUW55DdfkxRgZELhlqyRAoB6sRSvRTwKblE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Later conversions use hw_pte_t in page-table checking, generic page-table
helpers, and vmalloc interfaces. Include linux/pgtable_types.h from the
headers that declare those interfaces before changing their types.

For vmalloc.h, replace the direct asm/page.h include with
linux/pgtable_types.h. The latter includes asm/page.h, so pgprot_t remains
available. It also provides either the default alias or the opted-in
hw_pte_t wrapper.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
Changes since RFC v1:
- Clarify that the header provides both generic hw_pte_t definitions.
---
 include/linux/page_table_check.h | 2 ++
 include/linux/pgtable.h          | 1 +
 include/linux/vmalloc.h          | 2 +-
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/page_table_check.h b/include/linux/page_table_check.h
index 12268a32e8be1..12ee6d16ad339 100644
--- a/include/linux/page_table_check.h
+++ b/include/linux/page_table_check.h
@@ -7,6 +7,8 @@
 #ifndef __LINUX_PAGE_TABLE_CHECK_H
 #define __LINUX_PAGE_TABLE_CHECK_H
 
+#include <linux/pgtable_types.h>
+
 #ifdef CONFIG_PAGE_TABLE_CHECK
 #include <linux/jump_label.h>
 
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 8c093c119e5a8..cf595608cc4c4 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -4,6 +4,7 @@
 
 #include <linux/pfn.h>
 #include <asm/pgtable.h>
+#include <linux/pgtable_types.h>
 
 #define PMD_ORDER	(PMD_SHIFT - PAGE_SHIFT)
 #define PUD_ORDER	(PUD_SHIFT - PAGE_SHIFT)
diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index aed121d729b01..b068e6ade4207 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -8,7 +8,7 @@
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/llist.h>
-#include <asm/page.h>		/* pgprot_t */
+#include <linux/pgtable_types.h>	/* pgprot_t, hw_pte_t */
 #include <linux/rbtree.h>
 #include <linux/overflow.h>
 
-- 
2.47.3


