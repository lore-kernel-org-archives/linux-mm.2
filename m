Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FE40C531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 22:30:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C3EF6B008C; Fri, 24 Jul 2026 18:30:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 874876B0092; Fri, 24 Jul 2026 18:30:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78B076B0095; Fri, 24 Jul 2026 18:30:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 51C746B008C
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 18:30:18 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CA5FD401C2
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 22:30:17 +0000 (UTC)
X-FDA: 85025114874.15.C936BEA
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf13.hostedemail.com (Postfix) with ESMTP id 15D5C20005
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 22:30:15 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=jlvsnQJ6;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784932216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VoZs+loVAhBwkjc5A6PJBaB7eEBwxAF4Y2TdD3Br7Qs=;
	b=evMSwnI4A5NodmgjT/xuqvTO/Zkrqs92pZV2YpEZht3m+LGHll50kx42LB9ApOjQfcuQBY
	oKh0xfAsAHVYjojCT2rD/724mfBrcURR5PC8pea5UDvfk+ESNakxyNzJ6M8qhbNmi/pY5I
	zpIYJk4KZANNgQhCh0KeAPhw/4maXEw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=jlvsnQJ6;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784932216;
	b=skJuPGqPz/Djv5EVS0PaQj4HfMjITZz4KntTUtA5qZekanLCJqB3e/eYY0G5czHNQm4XqW
	6TJIBh3spD6Dbmv9sC5GYpoW1Yo5tjRUbCRflZIc1lvdIUtdLv5Can1204uJbpLBUPKwWH
	kZ8u+9+ur9J8NBWuFHi0P8T7d7zMpRA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=VoZs+loVAhBwkjc5A6PJBaB7eEBwxAF4Y2TdD3Br7Qs=; b=jlvsnQJ6OfYza2IkSyBJe1yYTQ
	djHcHMT23M8KZMD8bBxVN78RuuiujT9B3csAmMEx29Wj4UcB3QOV6j7K+R5W/zDKp0EjWijdzTsis
	NQFFdlIGG0OQko1SKqWL6/hLu3MIkF9H9M9k/jR7sssLzOBWj1+ZPre8jmZKanZzDWikQKi3tvwo1
	c9UaZWccOxUWHRbiKwR8/70hRWTz81a2lKjg2t77yv0C2LbAmYwks1lkn9TQGBzLwDziLvM+xsukY
	yV7UEJdIzukIrnqT9F48pjx8ZFtSd6m+n/pbY3mvux3pv+tAmDo8z/3UrDf4kQI7FqonhJK6ZBfxy
	VB/qlljw==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wnOOs-0000000027h-1JWz;
	Fri, 24 Jul 2026 18:29:50 -0400
From: Rik van Riel <riel@surriel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Rik van Riel <riel@surriel.com>
Subject: [PATCH RFC v4 04/12] mm/gup: let check_vma_flags() ignore selected VMA flags
Date: Fri, 24 Jul 2026 18:29:26 -0400
Message-ID: <20260724222934.1463812-5-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260724222934.1463812-1-riel@surriel.com>
References: <20260724222934.1463812-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 15D5C20005
X-Rspam-User: 
X-Stat-Signature: hb7bm4xjkrn4jc8ipo4gzcd31np4znfe
X-HE-Tag: 1784932215-294755
X-HE-Meta: U2FsdGVkX1/n76ejN+z5uIRLajLIm4Hgym903gJHsl88o3oo23IA8HUKiW8phnZpB4gLqyeG/38kUqL6jWOP4qqLCaBewYJue6eXazVQVaq7dOxcnzGmhCc1vvzQaekJ0pGxCh7/bpaPazQ/eSZuowHisS87GonGpnVEGE8sp+IZeC+dhkl4s/90gY8PugTzESSL8eJCO+16bywpArFfYVQuWHdlTeUoapv2jAtifD8hspb51pKZamwIwFlpAKhO77mWuPzirH08YdemakBksO0BpTRYzKeYuJJpu7awNfdxYXgfZaiXnsNH/l8zaQwGBFZVlUib0R48JA9LZGzBpMy56nFHSLzTVvHYiSzXbxAT/9K56VFy+lpIDCSJLW395SZ4W73u/kZIu0jC9fqm/8O+HN3ObjIyUSnRhpDKUxJKUvliJea/70Zv8z7i+GQijLOpvPQivU2KqHUugLSI9QVzguaY1xlFfMGBM8T7NI1v5L0XJsRGpgYsyj7LIpSXlY0oNOINiwX2DEiETa0xqUFf32xbXZL4wsZC8MgcNBDCZ0S+NLJyR9pde7db3oqOYSneD13v1FJlv9AJnwBtdJOkcySk2Nzn2NlCD1K4ixxRwaNJnazvk4ykINqTQoRk44GjehdNtgOyfYLaTDD2p5s/OoqbP96GQl/H4h6V0Jd5/clEr+dj21ssOyvKt1PnsyttXxI+ty+kcZGpD8hult/OJIVZdT3n70ocQqw6Ret1/cCX7f1CsxtE67Fu5ijvz5r0dZontHiJe3YhMZfu/uJa6KV66RYlXbN94bV9EI/7MML+yz3FSQ/Y/cd9LTk+o6o50EER98NdVNzgbdSXR2tXrdSgf69qxJcQpFi0C/T9j/jtZtvNp+eJzAk31Aa5GUqC/pINxjwqbSwKeqBxEdPSbrHqY0wlwgJpKmuMqVYan5BOHyNamvz1WfioAFf5tOQhhtK/75f0pF/kmHK
 xeuJDMZ8
 CUAaSlpxFAwCGnsrwZAC06mHlUL93g24OxqefRtTcE+JKdQFxs9E/op73J6ebbu6rp+3FKxwoCudqS9XI8x8bLdrRFT7Nwkm23ExXrwUJ2gyd0mMR+c0CfszvOXOh9agRhcQJ+Z8hJVB55X38noH6j8VAMxn1zhfydcIAXlol6ydi+3JBDVAOqTX93TWSqjzxI+caHI/RVo4RPiH7vkjwVNlqjorodiob42T/LxjeYFdeF1Mz5Z3lz/Z+hUxoztdsjiVUNUQSHzVdjYzRkd7GNZlvJUVo/mMCN6iWfbvTOhjaWG9QPKfC8cFbnRmG9+Y7vEtm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

check_vma_flags() rejects a VMA whose flags gup cannot handle. A caller
that wants to reach a COWed page in a VM_IO or VM_PFNMAP VMA, where that
page does have a struct page, cannot express the exception and has to
repeat the flag test itself.

Add an ignore_flags argument that check_vma_flags() clears from its local
copy of vma->vm_flags before the flag checks. A caller can drop a single
rejection this way while keeping every other check. All current callers
pass 0.

This prepares for get_user_page_vma(), which passes VM_IO | VM_PFNMAP to
reach those COWed pages.

No functional change intended.

Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 mm/gup.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 0692119b7904..dcece7b5253c 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1197,13 +1197,21 @@ static bool writable_file_mapping_allowed(struct vm_area_struct *vma,
 	return !vma_needs_dirty_tracking(vma);
 }
 
-static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
+static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags,
+			   vm_flags_t ignore_flags)
 {
 	vm_flags_t vm_flags = vma->vm_flags;
 	int write = (gup_flags & FOLL_WRITE);
 	int foreign = (gup_flags & FOLL_REMOTE);
 	bool vma_anon = vma_is_anonymous(vma);
 
+	/*
+	 * Opt out of the flag checks that read this local copy (the
+	 * VM_IO/VM_PFNMAP gate and the write/read/cow bits); checks that
+	 * re-read vma->vm_flags through helpers are unaffected.
+	 */
+	vm_flags &= ~ignore_flags;
+
 	if (vm_flags & (VM_IO | VM_PFNMAP))
 		return -EFAULT;
 
@@ -1387,7 +1395,7 @@ static long __get_user_pages(struct mm_struct *mm,
 					ret = -ENOMEM;
 					goto out;
 				}
-				if (check_vma_flags(vma, gup_flags)) {
+				if (check_vma_flags(vma, gup_flags, 0)) {
 					ret = -EINVAL;
 					goto out;
 				}
@@ -1408,7 +1416,7 @@ static long __get_user_pages(struct mm_struct *mm,
 				ret = -EFAULT;
 				goto out;
 			}
-			ret = check_vma_flags(vma, gup_flags);
+			ret = check_vma_flags(vma, gup_flags, 0);
 			if (ret)
 				goto out;
 		}
-- 
2.53.0-Meta


