Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75DFB606A32A
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 12:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=WbUiMHBE
Received: by kanga.kvack.org (Postfix)
	id 593A86B05F5; Thu, 19 Nov 2026 07:03:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56AE76B05F7; Thu, 19 Nov 2026 07:03:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4808B6B062A; Thu, 19 Nov 2026 07:03:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 17E6B6B05F5
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:03:01 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 17B4FA0ACE
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 12:03:00 +0000 (UTC)
X-FDA: 85451732520.11.C134CDF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id C2250180013
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 12:02:57 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WbUiMHBE;
	spf=pass (imf24.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795089777;
	b=No4vpkjQPqYu46w3KB5++BBOKTueBU3Ru7czgxAbhb9dmvCS81SjJbiAr41Ez4Sxur8bDY
	s7BnUw0jYpKI/WZAtyGLYZKUNp0K/UErhKahDlngg5EIkABvLuT3GS8G7B7Nca46p2B3hp
	rCLexmaXdAMis+1KqC1UZ6wJfD3gxG0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795089777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kbCSLrCrP7oRdquD/0Llnb20nwRhMvgzSZfeCvbl4HU=;
	b=e4GZ3Y5aZmQOlODSr376DxCUkXlo0O5dut/MlUSqw1fo2H9u7IFDVBalo1ObpZ8XWJRieq
	jmSwW/d1pETYtf5D33lVTrykqFTDpTOVqqwYPjjOaRuD5q0YRsXfZdYEKSmYJTiRtsCswY
	LY96cywnjOEyWt5H34mvoZYGVsGcNiQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WbUiMHBE;
	spf=pass (imf24.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795089777;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kbCSLrCrP7oRdquD/0Llnb20nwRhMvgzSZfeCvbl4HU=;
	b=WbUiMHBEuvIDHAG3Mk9l9D6sMtH4mX6/CydEmVUXLD71Ewfj/XTRiPATN+SDiHCjhf823j
	tX2b+hpGnoF1j6f9+cjHbe2wB0STZ5zSU1qs1AC51F+N0fRC+pnDWrzioy7AXDZaKdD0gj
	4FxIv9zO6PWEY+1MwbeAr7lWpUJs4Hk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-503-u8ZS7WXKPZCbb7X7TJ3RHQ-1; Thu, 19 Nov 2026 07:02:53 -0500
X-MC-Unique: u8ZS7WXKPZCbb7X7TJ3RHQ-1
X-Mimecast-MFC-AGG-ID: u8ZS7WXKPZCbb7X7TJ3RHQ_1795089773
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-48fcb657f32so1307153f8f.2
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 04:02:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795089773; x=1795694573;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kbCSLrCrP7oRdquD/0Llnb20nwRhMvgzSZfeCvbl4HU=;
        b=f2NZYBLsVp/P2XfXQlJ7d0MJ1yXbh60PtuHuX5Q6bqhl9Z7XXCIGqIa07dW6NMSxtw
         6Z1wgPTBXe2fIpdZO4fXQw6c6k6p7Wv0sPQxEB+4BUP+0AiyzJPoFHp5GKnhoOA1RCbX
         +EuDxi2jSQnzTmVi2/D4RqHs4R545ZTyFhx41cGm1f4kLQW5JfQzcIrbwdp+qcY7kWLi
         +aajStawm9jFvME2V+aC6rU9qeTGXYCYhzZn3i1KcMTI1elfCCiQ4U68peHBUlAqIY5c
         BxQcWoU1jYZG/SE9O+Ly/+29Uj46VuE4M4gKr9ug1++Dlm98Rv6dbxX2jOl/5pSxT+y1
         hwNg==
X-Forwarded-Encrypted: i=1; AL+hErFRvRkaOflfqVE8Phro2HEqZNn9DK28kEHNM45kCwWxHmCeErX8VorRUZiccWdFpg+k+jVK/VZHqA==@kvack.org
X-Gm-Message-State: APuU4Z+IcJpvk5/rmJg2CJZMIQj8wlSY9m39D0V4elhp3ZVWkQNmIioR
	xQgXpBmDNSBzKcmeqwyn7dLOwAiYh9f9QtvEzUBtYc887PNL8kj/x3csVDNFNNpA/97wGibVrm8
	5jj3nUmGjGF1NW3K4x2zfOYB5gMJaJGbL7UK8Nm16hngGfpZ3RwEp
X-Gm-Gg: AZFdTZfmReKrQrhCbuW6XMYGox8xAr2lpIf79/vuaGGGgzyVDbg1lU1l+/qQ4LkHuuf
	j6/kFFBI0uTBd0XS2Q7OlEy63ydfqAdZk01PruRsuGxBaX2OGfEYasvEe0mYrWyUkjdPSL5Z9Pp
	uXRbO4uRGQfH9gKC+i7kmHNdaXB3qUoe2GVra/nJn/zN41YKBkp3hgivZoEq+HpERpV67rZeITH
	K96dNTAppMC60mGMSadewrlC8YetC2/wcaXVnTDlIwmM0B1Ln8/gP6WWDxwPIwiDhmSOfN/Zj3T
	3vNb98DX9F68i7SWpWFbEptSdgGnqhfZXyk1s0aHTFMoKSSsExdu5uMZ0wcr2+hoMp4hDdHrAze
	ZLDVM9Vw7/SF40m8S9KzDiQ7AsB+PsPzxJQnT4Jy4yvM=
X-Received: by 2002:a05:6000:4283:b0:4a9:b2f1:aac4 with SMTP id ffacd0b85a97d-4a9b2f1adadmr3551667f8f.22.1795089772549;
        Thu, 19 Nov 2026 04:02:52 -0800 (PST)
X-Received: by 2002:a05:6000:4283:b0:4a9:b2f1:aac4 with SMTP id ffacd0b85a97d-4a9b2f1adadmr3551587f8f.22.1795089771908;
        Thu, 19 Nov 2026 04:02:51 -0800 (PST)
Received: from redhat.com ([2a0d:6fc0:1520:4400:d78d:7b2d:2f5d:e08f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a65560b5f1sm10622532f8f.21.2026.11.19.04.02.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 04:02:49 -0800 (PST)
Date: Thu, 19 Nov 2026 07:02:46 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, Dev Jain <dev.jain@arm.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Greg Ungerer <gerg@linux-m68k.org>,
	Gregory Price <gourry@gourry.net>,
	"Huang, Ying" <ying.huang@linux.alibaba.com>,
	Lance Yang <lance.yang@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
	Magnus Lindholm <linmag7@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Miaohe Lin <linmiaohe@huawei.com>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org, virtualization@lists.linux.dev,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brendan Jackman <brendan.jackman@linux.dev>
Subject: [PATCH v11 4/7] mm: skip zeroing of pre-zeroed order-0 user pages
Message-ID: <73917d7bc27d763dbcdd2044d311acaf452144a0.1795089715.git.mst@redhat.com>
References: <cover.1795089715.git.mst@redhat.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
In-Reply-To: <cover.1795089715.git.mst@redhat.com>
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 35O1q5bpXBOWqxH8ZlCDsjCRK9XIYtWAH0HWmNyYols_1795089773
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C2250180013
X-Rspam-User:
X-Stat-Signature: qrhwkunkfqj7hb1n8m6ae8s3w7ymf1o8
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795089777-451816
X-HE-Meta: U2FsdGVkX1/aKInv1V30trs0EOpZFZPyCyjqH3aZ2E3B3sPeQUFUm8ZzkBJhWrZcpHASkGrC02slBuEVmlcLtRNq7GLujfP1vxkp6yhCi2wkUZZ7iEKhyQ7RzK+tRTIq3wtPAtAXtBKVeJfSID2mrYI6Rj0Ysh8Whzi/47yfRlLABirSIufVMIgBzw7Hc5CXAg9w+T0wEniUXWd3UyT6T3r0p0Wby3XC6ORaANU4QCd+pbrBu+KM8sNwCOWYlba7uZGgg4uMfjnY/QdMoSHLEZBFmLfMt/Q9Tkf5/ULmANvmvqik9OD6sPytRQw7QXV1s1Z8FIX+yaS+0pfymyPZVjGD5CHJT0hHcPZvGvasu55jh0BP6rmg+qHzfiIAgIMlJH28d8aBp9UqNDodpQCj+Y4uRSUUqnY2qq/QvbhpTHIRu0CmuM4O57wndLVyh3AaPuh8E2F/8OeJ51snInMhSGPlNmFJ+2Cl0ojVd+8oQ7OkZx4fqG4k6K9VAvjlchf+9J+eU/IhEYbeQqPHB+TO1qXPczIahNHIBSoO3hbI8pKmYf89PM0hjxHp67E6skewCzPqXofw41Zdqvs3Z552OV9c/hjLMvAXDd+ZnKHMxMf8HEYuUGrxG9Z+dkk4ZevR7QYz9RQ0LheN3V1SrcpE9yT9ZVTHkXwad0XFIxtosFsQPoCUyeCIhbGzbgi8nBcYyMSi/J+iB2WR6fZAsMydclaPCprUKp98C2rUbNCk+V1MKE+AFWQ5EtReXnZx0muie6GDT3Y8FXZzNePpUYHzIQKGWWBlXDMylxYjiv3kIikmFpoPBWbk2Mw5WbURGBIQwHnKqyEc1S89bpM2fUtKMOcGG8w7Bhz5dzLB40ICTEXKfSmlQwtIb4Go//CelJsoTsYy/qA8ftVgXVndOl3+pF1GTcG3VdgB2PuuInyovdmumf475EKDQuHx7bX6RDq6M+EjmeNytvL1FGATmjS
 XJhS1sTP
 8vSeuu5+hcaz++npBMIP6uHIqDJ9wX2qffd5Zz173KvsQZpTQzChLDjRcgoGvPDDvZn/AYz7lPEk/4ArK57EW3My9QL8Ya1cqId+0O1qCcnkLvpJtEQ5ffYeNvvcpAFPZPDRj+TzFCCBPk5f+B/7Tf/dnmGWWahqsQmP70fjmgu9iAoFnpH2lYlXkYhWWumF2nSUl5MptTVg9o1NIndQVRivMDVXIXb6y3LP16kHBwbn5R3MrjAG/6Rq6dYEx7rc8PQBvXmt1Y+2RTttTw6T25EtQmScmgBZl2hYkdcxu0gtYcI+GfmkWju9fjLxxInGcaQ5p2n60/4UyaoeKEfeybDdleDwQgUmttC9+d5IjVm/E2N20GEWi1ZSA+0N4zjI5YFXmAhG0P7wVbj+imWMmh1DZdRxd9AnZW92qzRbWbewzyCfKh3Okj9ojhPWRl7SLiHFm25o5xpjaVtgeeFnY0sChEEIuqjAaQSPuhD1xWOIP56WiHCfRqaoicmu6dGC+8fHWLTXabs23ooG65wrD5kD40xn38GXfAdadA+m35d9m8SDsPvW+pnvzOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Skip initialization for order-0 PG_zeroed folios.

For the generic vma_alloc_zeroed_movable_folio(), skip clearing known-zero
contents and unpoison KMSAN metadata.

On x86, vma_alloc_zeroed_movable_folio() requests __GFP_ZERO, so check
PageZeroed() in post_alloc_hook() to cover that.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: LLM
---
 include/linux/highmem.h | 8 ++++++--
 mm/page_alloc.c         | 5 ++++-
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index 70bbe93b8d669..4abd2a0fd82f7 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -344,8 +344,12 @@ struct folio *vma_alloc_zeroed_movable_folio(struct vm_area_struct *vma,
 	struct folio *folio;
 
 	folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vma, vaddr);
-	if (folio && user_alloc_needs_zeroing())
-		clear_user_highpage(&folio->page, vaddr);
+	if (folio) {
+		if (folio_is_zeroed(folio))
+			kmsan_unpoison_memory(folio_address(folio), PAGE_SIZE);
+		else if (user_alloc_needs_zeroing())
+			clear_user_highpage(&folio->page, vaddr);
+	}
 
 	return folio;
 }
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 927a288eb419b..c2cb2f66c1736 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1829,8 +1829,11 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
 				gfp_t gfp_flags, unsigned int alloc_flags)
 {
 	const bool zero_tags = gfp_flags & __GFP_ZEROTAGS;
+	/*
+	 * Skip zeroing if already done. Sanitizer handling still needs to happen.
+	 */
 	bool init = !want_init_on_free() && want_init_on_alloc(gfp_flags) &&
-			!should_skip_init(gfp_flags);
+			!should_skip_init(gfp_flags) && !PageZeroed(page);
 	int i;
 
 	set_page_private(page, 0);
-- 
MST


