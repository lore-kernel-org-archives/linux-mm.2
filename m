Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F106BC5620A
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 08:41:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CBF36B00BA; Thu,  6 Aug 2026 04:41:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A3616B00BC; Thu,  6 Aug 2026 04:41:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B8CB6B00BD; Thu,  6 Aug 2026 04:41:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DF0566B00BA
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 04:41:00 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 87A05A1C92
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:41:00 +0000 (UTC)
X-FDA: 85070199480.11.3BC2C44
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id E6282C0005
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:40:58 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=luByc3jt;
	spf=pass (imf28.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786005659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r+i6O1oG376r4vxQVFy6sLqVhxZ0gWTxJnTkxrNrMKc=;
	b=zH6yKcDTcR3Zp0tcHTZhAx92nazbU/0nEkPvfT+kDBSjIKFkf1spJu1cYYKAzR7O+ld+13
	hMStqk+Jeel3mhDA6xRse2r6RmLIhuHMSEtVQXM6krII7NaBQLx9sgTuNMzTEnXwGXIjGJ
	325KGfV4atHy7ebnTsv8px/yCuZAQ5M=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=luByc3jt;
	spf=pass (imf28.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786005659;
	b=dptvUOnoYfDRz+QkRU6NlzNYiRS/G0Wh+J6OOfRaXuCzpnXzdWtHxjU0LZie9GfJhsMojD
	mcBdSca4Ratk8N0y7VAI2PRgyTnVI6C64mzLb3pfxJ3Qs5kBVYG7QVd8IP1TU6uprwQ5UB
	/9kbVRPDNh3mCzixpNZIrjZqV/ReOoI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 289F5176C;
	Thu,  6 Aug 2026 01:40:54 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 712203F632;
	Thu,  6 Aug 2026 01:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786005658; bh=Jt3lY9Rfe2qE4RAnGMFG9uUvIQ7Ln1RzFK0qs/6Pya4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=luByc3jtbBV3gUID39iGf/O7Ordl38J04J9ScF6tTrQH2SAyJst4PI5/HEx/+oO2M
	 tC4u2VpNMwnUKS+GMCR24TnNoqgA1Zh5W58AIkL2KnpnrIKANxQnj1eS3ryjCi4BDm
	 nxuZnsP5XbydqmOlfXFKlJJcGS7jqx3QJB3bT6Ww=
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
Subject: [PATCH 8/9] drm/i915: use hw_pte_t for PTE range callbacks
Date: Thu,  6 Aug 2026 09:38:46 +0100
Message-ID: <20260806083926.1807279-9-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260806083926.1807279-1-usama.anjum@arm.com>
References: <20260806083926.1807279-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mfp3bpo8xsdydx9i1fkstj37odjapaep
X-Rspamd-Queue-Id: E6282C0005
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786005658-139067
X-HE-Meta: U2FsdGVkX192DO5SzgutIHPPB4ViXIHRHw9dI6M7Ro8+D7UwN8+6ba0J6YDrRiMqSUnt+63ZpK1F+QEKGmBnJ6PjXnwDTW4nKassbWMiQibXY4X0Sa07+XwI5DZDkImb6mkKUWB7jFVdd1WcLi8d0veG9YYoRMqU+t1JkN9Ibsm4BHcmb8vZu7K5QqPcJoqyCmWsCA+gZ0lUpN8cr6hmovaY39VEzSBqV76J3KkGe2ZZtRYjoDobnzFYKe+MenqXjG64iGAZWoI+0tgi/8nCz6j9gWdGZRagiDMEJftZDGGaxzTNev3sRJ0c/ByjxW7dTQ/Jq9tjYj0TlfVLosU1HdmJDd2gSmzWFCWjmKBb19QXntuMFbwiDoVzGRsFXyJzr2DlRhD19INcZpRzTDzGSaCTC62a9y+Mbmh/e2MWVA4MmsoWQfaZXhZ+eyF+WrrbhmEaYQAToy/OIP1o9avXN+lHS0K67PMePc+jQTQugsMeVdLAxtdrFvJHCaV4CYHZNjFhKoKp7KoWwFHlIKzSsUGV9HF/KY1C89nQmKC3eP4d9c/fvShHJhQgUOYfFVM70MtK+xCYpbzil0SUiG2+VdINUh1sjQ4wT7f+dLH9Cm7ts9NxmUJUXZDB6zdcNhtRlKFq4DytNR3ihvkCsOLBNCyoUQvwAWeEgPZlGJ8n87FOoFqtSVrX9TlYNguRRp+BSlv5etR4h0Ysxy1gqxe5+jZMLf1llT0aI8S5i32rggpkRPQz786j5ntNgRWKpKgaMkqwNTW/b5yOKGoF5+40II5TGOmYsdHLW0aT4ZVTeupIzL1mi+N0EJiS/YTIlg8XTGCeNejVYzpxUWKN46LMGL9CLKc8yWotDfWHmDIphhypvd0nz19aEb2+/TK9qDLRmbeRf49QWdSr290Br0xFg7lXQyv8RqYe2CsEXHNYUK0odTHOSUDG0N9PkZZDGrZ1lcAEtVr66g9fQIbGDBf
 GCkIyxdr
 LscwuLHzcIZOVSZpb/98dPML1qZeq02PfCHAe6MUGl5XZJBdHyyg5JmuPKa7AtYZunONrbHv43C7pjW+Lk4Vqo3FldYBn+C/TVqzgoKdoGUbTnJ5cvPhAwJrPPFdBwMB30z8/IZ97JbfF/e6scNFrZrW5WKpw82yN3a9P17BMj4GGYbc3Hj/WF8euitCiHcRoErWZAAtyhZZ45JuCLwI5TUV7PsHDoi3K221VHnudoEnvPOc1q5e21vBE896sORtJNQqdAtkmNsUUTgf0AlItOOlOSuWFdJaYskWbtyf7InAmWu52cCZEr6L+/XXqe9+QDnJEbwIG/GO/14FQsBBD335hT63Zpz3DnkIjAmcjSBHy6pY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

apply_to_page_range() now passes PTE table storage to its callback as
hw_pte_t *. Update the i915 remap and selftest callbacks to match the new
type.

Continue to use ptep_get() for logical values and set_pte_at() for updates.
The type remains an alias of pte_t on x86 until that architecture opts in.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
Changes since RFC v1:
- Clarify the effect on architectures that have not opted in.
---
 drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c | 4 ++--
 drivers/gpu/drm/i915/i915_mm.c                     | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c b/drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c
index d01acfb7d93d0..056faf4a3618b 100644
--- a/drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c
+++ b/drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c
@@ -1690,7 +1690,7 @@ static int igt_mmap_gpu(void *arg)
 	return 0;
 }
 
-static int check_present_pte(pte_t *pte, unsigned long addr, void *data)
+static int check_present_pte(hw_pte_t *pte, unsigned long addr, void *data)
 {
 	pte_t ptent = ptep_get(pte);
 
@@ -1703,7 +1703,7 @@ static int check_present_pte(pte_t *pte, unsigned long addr, void *data)
 	return 0;
 }
 
-static int check_absent_pte(pte_t *pte, unsigned long addr, void *data)
+static int check_absent_pte(hw_pte_t *pte, unsigned long addr, void *data)
 {
 	pte_t ptent = ptep_get(pte);
 
diff --git a/drivers/gpu/drm/i915/i915_mm.c b/drivers/gpu/drm/i915/i915_mm.c
index fd89e7c7d8d6f..aab88e8edf946 100644
--- a/drivers/gpu/drm/i915/i915_mm.c
+++ b/drivers/gpu/drm/i915/i915_mm.c
@@ -48,7 +48,7 @@ static inline unsigned long sgt_pfn(const struct remap_pfn *r)
 		return r->sgt.pfn + (r->sgt.curr >> PAGE_SHIFT);
 }
 
-static int remap_sg(pte_t *pte, unsigned long addr, void *data)
+static int remap_sg(hw_pte_t *pte, unsigned long addr, void *data)
 {
 	struct remap_pfn *r = data;
 
@@ -70,7 +70,7 @@ static int remap_sg(pte_t *pte, unsigned long addr, void *data)
 #define EXPECTED_FLAGS (VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP)
 
 #if IS_ENABLED(CONFIG_X86)
-static int remap_pfn(pte_t *pte, unsigned long addr, void *data)
+static int remap_pfn(hw_pte_t *pte, unsigned long addr, void *data)
 {
 	struct remap_pfn *r = data;
 
-- 
2.47.3


