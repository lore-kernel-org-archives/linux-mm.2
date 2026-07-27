Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B103C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 16:48:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02F726B00A3; Mon, 27 Jul 2026 12:48:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 006476B00A4; Mon, 27 Jul 2026 12:48:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E11826B00A5; Mon, 27 Jul 2026 12:48:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B6DC46B00A3
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:48:41 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3FCF74005F
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:48:41 +0000 (UTC)
X-FDA: 85035140442.25.B0D6F49
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 968614000B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:48:39 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YyFm5Gu8;
	spf=pass (imf01.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785170919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HahPVOr/LCy73Q+fo/wlUEFVR+AYMRfMo+YtSiWbXOs=;
	b=eeaUxx8cE6MzNyUvhbW2P9Rwd2NpHmSybZB6/yBVkGSmIEN8bhnD6OAgaD29oZpcwYViYd
	BYdUA7B7fhpAyGJu5NdkNgWF6rJEGIT6FMb/Ugc6EhHEkAcBza38bf9kOm8C/c7l2xd95C
	uKn+awt19u6UutEhvXiswXT2SwH8ayE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785170919;
	b=fX8p7sCCuKAmGNN0gBQfgic+Y+nQKN9L8EFdG/qfuh0a4QXpzJQDJbh/QSxuRaeMvM4BTC
	BlQceTdCxFudao79v7QeXXpgfoLydrSWz8yY+AUiAyo9Sj+V2hVYo3xD1EAKrCKKQv4W+e
	zHUeEDIQEWoEFrHcxL+Q0GxtdqpKy1E=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YyFm5Gu8;
	spf=pass (imf01.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A6C41175D;
	Mon, 27 Jul 2026 09:48:34 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 1CFE53F86F;
	Mon, 27 Jul 2026 09:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785170918; bh=JMnQ5x98rYMBvstt3t6K+WsTOGu94NI0NQakEbtgfbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YyFm5Gu8COeycq7I7LYuCSC/XjIt2u0SAKwUx1Aj+4oUv8YQBR7DVon5ehIZuZSOw
	 HvpyitnYjapZXnfX92hDFIEoEvFM5a2NTAQD7BozddqkW8IZdE8y8E26ijdoSu/Zlj
	 wnelz5qvccBri/v5vzsa2BD/s8NUyi27TheVyBvw=
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
Subject: [PATCH RFC 07/11] mm/mremap: use ptep_get() for the destination PTE
Date: Mon, 27 Jul 2026 17:46:58 +0100
Message-ID: <20260727164715.2866609-8-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260727164715.2866609-1-usama.anjum@arm.com>
References: <20260727164715.2866609-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 968614000B
X-Stat-Signature: nmhfuuhq1gfa69w7dzikskuuj4hu46ei
X-Rspam-User: 
X-HE-Tag: 1785170919-549623
X-HE-Meta: U2FsdGVkX19GTtKel2RkPphNfYSVQzhoiQKF87EWWBqlwZDTm0tK6RjHRavtOH4Kk+tbMYd+BdknMjKPd1TFB7Su02qTMOlLqspz7TZMj3RG8+wK4J5eAgprJdGZgdQ3Ur0S55WGtiEoTrzFutnmKauFQUPF9QLKJuJIIL7xUdHWoL4qpmZrOURMMBE6Wzyp8jtGj7WOzxCCreMQpFLHQvOnw93BuT0pYcihwUkvzzx/BCiLxEADeHHX9O821p8+I6bjlygx0UqWtKJh+gStachNDx/xMx1h4qW6ElP3CQu41Ykz1FqDxk+7//malKCuDWmLLu58jqg8Oc6mjYqMLEc3IjbiWH32dEvYSK4MoTYh1Wd7j9wc2w2G6lFJDcWhJZbnHYwHhUhtz43OhxL9Dvu2qwpdqAhnr0M4xmSIukpvTP8ReiUYuJCk9qBTR8EYKA8araWDC80TlCohUB6x3osIc9IeA5kPhFB1AVatgEzMSPBF6RaQIU6gxr3CGEKeDCSA/dtgGznZrioJOafNMHVjrvdK7E3en5tgel4DV5JJwpYomorjpwblmTncNioHiv03cw+z/7vU+tvSGNKLoLBd8c8NoAQJmcr+OdFLCR/sackXbC29CXqHSxUBjbqvRhxcQjB/Ixwji2rfV2lehpaydz15pJc+xsB3qC++JNI70BlgfX/wfqdNaPEfE/LSt9hkdnDSBmLM3HNxECPfNiqA3sANpMG9M55glaPK0M+wO5sch2sfv6rMppNJy77Y8PgK9/4RxSX2y52IyKk7+Y9f+23SIAIDJmpOx4lmPF2+Qnscl0WvrZl9f2Ji7iKmwDC3KEnHI+eEsq9FDtW7nWthM+IhPXIn8i1x1pDbcuVqI1psQfdwsxXN82VNprAGlGxrCi30Mc6tr2WdJ/hl7too/+muePyxz/XZ22JqYgg6dbsEDv4LmopDQ3tVW+ctzHWog/Z1G+jUTXqjN+Z
 F4xMbkKP
 cA6UOuSt13H3RzZcsOaYewdIKeW95p3dGK+I5+RtpMrayTzYmKz9g6hSa9GC/lCNlbrFP83NML4liGtZ4a8o/jPBbELSxDp2Lz3tMd/YBjDYw1LFhSML/lRjPWo+V0MNC5j3fvmBDCmeOigZrFKrMM8RV8vsXy7aPvilZIbiDHGvxoikm5/8YInFQvSHtG3xOraWFz2hi8zZ5YW2mwxdAD8POeE3lw5IBDuWTUHVF60cFhFyGdusea9kWlG/k4cOr6JpPbRKAYBqRjKeoENmDxYYHyxsEY7uTMgX3yQ/pkrKocxcG70xa8WuaiWSXrVhsrdPWzF3xd8aqc5VANI6za85ylGNUJ94UmmCF6TUaPl1/wbgH447nR/TxUNtL7CP5++D7M7bAqQmoWl1KiYlytiLfBVz0u9uUwWf3PKCbytDQ784=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

move_ptes() directly dereferences new_ptep when checking that the
destination slot is empty. new_ptep now points to hw_pte_t table storage,
while pte_none() consumes a logical pte_t value.

Read the destination entry through the standard ptep_get() accessor before
passing the logical value to pte_none().

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
 mm/mremap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index d966ee8248b6b..ecb90ccee6fdd 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -264,7 +264,7 @@ static int move_ptes(struct pagetable_move_control *pmc,
 
 	for (; old_addr < old_end; old_ptep += nr_ptes, old_addr += nr_ptes * PAGE_SIZE,
 		new_ptep += nr_ptes, new_addr += nr_ptes * PAGE_SIZE) {
-		VM_WARN_ON_ONCE(!pte_none(*new_ptep));
+		VM_WARN_ON_ONCE(!pte_none(ptep_get(new_ptep)));
 
 		nr_ptes = 1;
 		max_nr_ptes = (old_end - old_addr) >> PAGE_SHIFT;
-- 
2.47.3


