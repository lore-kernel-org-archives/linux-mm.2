Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CECEC624DA
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 10:31:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 762A86B00C2; Thu,  3 Sep 2026 06:31:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 739C16B00C4; Thu,  3 Sep 2026 06:31:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64FA26B00C5; Thu,  3 Sep 2026 06:31:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3B24F6B00C2
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:31:28 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C30E3A04DB
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:31:27 +0000 (UTC)
X-FDA: 85172084214.13.BE3693E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 228FB14000C
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:31:26 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=QvHhv94l;
	spf=pass (imf23.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788431486;
	b=QWskA5Ogdoy50rwng3AE0c157xJON2Na6N3AaYVvHOruF0xddyxYf5QDMYSGojTnFZwnG6
	UPZOum8e50Z2R/wVPVWDgQTqexwf83M9TjfPI4PrRzxdAjGvwcHW3n1UUkCCkYcN7AkjsP
	Ri18edFvjqFOeW8NRoqQeZzMGeppKBI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=QvHhv94l;
	spf=pass (imf23.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788431486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aIO/sh25/2DXIdJ1qYo6inYe04x5bulIz7HJbN4c8lE=;
	b=n5ELPwwo2rMM5RVqK+cq5AuR6kle2j1cE8uEeGsw39eWCpM7TqtkZ1gKPC3vrsQtKaEOqr
	9QHjYUbopWF6NNKSpo4qoExU5RWqhUslPjOCrctHHUhewBsrpfaRReaKrs/GZ2f9MLxG2V
	Ah3zJhTSS/7UW8R50kK+RdG5TEqrfJk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5BA421596;
	Thu,  3 Sep 2026 03:31:21 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id F28AE3F673;
	Thu,  3 Sep 2026 03:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788431485; bh=wa6kw8wVjvVd2W8nAbhMf4/QKJIqMNke43dTRJ3tbuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QvHhv94lVGWx7TmcPQBRk7OR/PvY0hnXRhX9xVN5Y4qN+GDaWN+Xshh7VTAkVLSnY
	 Jdi6olRL94sQmWoyHi9kc6yp4HLF2iZAObXc9xsiPZr5FAVO73li6Y/Q2PlXwZuEJi
	 tFBQkMsde8wyKBlpx9nCFXxKYf2kd54KRIoPFYKU=
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
Subject: [PATCH v2 4/8] mm: convert PTE table entries in ptep_get()
Date: Thu,  3 Sep 2026 11:29:56 +0100
Message-ID: <20260903103002.1091859-5-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260903103002.1091859-1-usama.anjum@arm.com>
References: <20260903103002.1091859-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 228FB14000C
X-Stat-Signature: ofrf9y9crgunoay95w89ap7wyuowdhue
X-Rspam-User: 
X-HE-Tag: 1788431486-679337
X-HE-Meta: U2FsdGVkX18Z2ZY+3HlN81mfbG0q9KZFdjsrtIibnD8off7xh5SLbEQBZiAvwBSKy0W6vJLsvTUNJ0cuWOvi/CfofIDK8Wxxcdio5zFD1M7A47bGk2SK786hRVQZCsLBJFZg4VLw/1i40an24Z5iWzkjNIXjTiYmqvIjJQrlyW6mUNY5SDrl05ZVYBFT0LI/KeFQjbpfrYnY2uDfD7LLAKgoMrjYL2fMLqDWH6vkh9+F6o3B96KFkxPgd4AhH23gOGkJaA05SFYi67yNdXq7CmtVEz6kuiiLG2sXl3B1xQheZKR2EycngCFnLGxS9qppIlvVPsOSvzkDHInD5cocHlbHPIfdzUGK5XBlzlNsJjS4miFA4HpWnVC97RmMaTm8RuC/mGoAHUswBIvbuoK7qnlx/K4+LMIVE6ioS/KyMoidMlf900v58tiu1qXv4q4CFrYTRPZU0Dv5hK8S8Av67Nbeh6cePf4izMsrAV7DZ7CdThFHy0eiLyOtbCjfxs58G1YQ3/i1Az+z5Pxy5symtwJyoA5WU9xZbGT3yFH4qEMZbXhUBslhBgyorLDhEtA0BsimeghLZGzHlmUEqPOWNMbRfACw72MOqjUkbJGeQDxic/yO7pjeA5Gm6tEF4NqRO1bsQdHPhh3raV6Fyw5LxboMZIx/SVpN+UvM2Wfy4Z1wUMbDMBEyfVMPuJb2TqtHTbh35yZ9J2hAv0tZ6bDX9XIOAI0qgIIoXHbPhvVgTfsYzI6Ls+KLsVW8i9DijtK5RU4IWDh9fYUXm7G0jEfM/Od602jxkbrJDG6tmXMPGf+a4+q7W79bsOv1hzNPqcYqYldAysG0lOZIJLEAHJt/LGx0xqFPHkCxNlqDXOI3mR8kbKjL6ztYTEuDk+hINtOrPsVYqnLi/V5M4OHxG/KIE5OiEV6criZk+uGeDeOB9+jGg+YBJrMDlMzeDpDWFrliII5o4usKXtb29cqdLy2
 vzVVzcRS
 NsfN0mrG0uxHWBSP0c7zLkxS7T/F28yFdQbmvsA/w7lvYUYV70OKYLxf10LxkM281YkETrCCyz0LFrCkEuCiwMp6hXRF/9y7sIqAa2e9ycnNng9BbuNrQqeyCvj1rb1zlEKsonQvZ6WhRAr4yFl0+18fjZO40E3g1vMlmXSmyCTwB52nwaV3yVBWm3cFFu2pIFdtWXIbQGN+SQgn7W8p4wqLSjxHPwCttdhKFhHdl5Mt5D73Xk9VA3WNzKhzWJcpe+kyEu+xdGvruqi26EbpSf2C7yYkq0eu8683Z/2RcVKdAitHImgGWR0aH+u9JPnfB1XdaKfVKbm+Jg7p4dPberBcFpG0DMeS6T3Ej3t1/96aGM84=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ptep_get() now accepts a pointer to hw_pte_t storage but must continue to
return a software PTE value. Add __pte_from_hw for both generic hw_pte_t
definitions. Read the hw_pte_t table element atomically before converting
it to pte_t.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
Changes since v1:
- Use software PTE value terminology.

Changes since RFC v1:
- Define __pte_from_hw for the opted-in generic wrapper.
- Apply READ_ONCE() to hw_pte_t before converting it to pte_t.
---
 include/linux/pgtable.h       | 2 +-
 include/linux/pgtable_types.h | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 19098e302b75a..41337da0d65aa 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -493,7 +493,7 @@ static inline int pudp_set_access_flags(struct vm_area_struct *vma,
 #ifndef ptep_get
 static inline pte_t ptep_get(hw_pte_t *ptep)
 {
-	return READ_ONCE(*ptep);
+	return __pte_from_hw(READ_ONCE(*ptep));
 }
 #endif
 
diff --git a/include/linux/pgtable_types.h b/include/linux/pgtable_types.h
index 07da05d375c2c..d6c5a7548550b 100644
--- a/include/linux/pgtable_types.h
+++ b/include/linux/pgtable_types.h
@@ -8,8 +8,10 @@
 
 #ifdef CONFIG_ARCH_HAS_HW_PTE_T
 typedef struct __hw_pte_t { pte_t __pte; } hw_pte_t;
+#define __pte_from_hw(pte)	((pte).__pte)
 #else
 #define hw_pte_t pte_t
+#define __pte_from_hw(pte)	(pte)
 #endif
 
 #endif /* !__ASSEMBLY__ */
-- 
2.47.3


