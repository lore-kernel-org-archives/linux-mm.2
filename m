Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46B12606A329
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 09:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sOl1c/mZ
Received: by kanga.kvack.org (Postfix)
	id 205216B05C9; Fri, 27 Nov 2026 04:13:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18FEA6B05D7; Fri, 27 Nov 2026 04:13:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0571D6B05D8; Fri, 27 Nov 2026 04:13:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C73EA6B05C9
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 04:13:56 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 335424025E
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 09:13:56 +0000 (UTC)
X-FDA: 85480336872.21.740EFFF
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5AA6F40009
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 09:13:54 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="sOl1c/mZ";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795770834;
	b=ZAKLcyQqC3tuWRiBHEWek6aXqDNsRP/pAjl90YGdCBlzIDNwXpp4lnbbkXCtaFQZvtzBCv
	5vcRS2LEoSjkoDKXwpdWo4Swrk9/7i9xTgiuJ7S0hGthhg6xb7yuP9F6P2T4DBg1h/rXLg
	oO6g0QZZlYQ+p/luGd2i8bv/8ascHPY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795770834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v9lbr4TFxiuuucypBBOqCbJsUUDeJTCLXV6XHKdyrTE=;
	b=6APXo3mMJnri1qJNX5CZlDFSoL8l/gioovtfOBeOm0PTphF2jooMGH36A7FTPaRpJufaRB
	/R6W+CfLHOKnpBQSYDv6UcCEvhFxK2IADPDgD8khdgG+xUKOZcf1n7/5LDGR7fo9evNczg
	sW8DjLEguXO5PK7ana6vzrHd9X952jg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="sOl1c/mZ";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=azpijr@gmail.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-4ac08f4a0b2so5575080f8f.3
        for <linux-mm@kvack.org>; Fri, 27 Nov 2026 01:13:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795770833; x=1796375633; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=v9lbr4TFxiuuucypBBOqCbJsUUDeJTCLXV6XHKdyrTE=;
        b=sOl1c/mZSmwKUMOOYTmGEusi/fIL60eMSNW9cDmNicf8qOVJc1wWqg9iCCODmdIXZg
         cXwS4pn86rUbwf6TsfZmd4WvCSuJwP2N8duIp4Ct55pyQs6+0CTLEZgJ2HdtcRH1LlfC
         RAfDKeZPHa/Ps24G5sPbfvNaOlgWzZK3xKzu5EAmb8gA6ebq/AyDjUPrnaM8bU8MKCz3
         S0LxT6ELmOUl+5ttqISWIhBBS8YmahDucoXNVpATnP6DGBH6VPYSZ0pkU5mLMr+HRkw3
         zRQDknNcwCkvvVxzN2X6LLlBdana065KWolRQzm78TLZbSOzVRHwIRU1BCaCR+mz6oDF
         9vyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795770833; x=1796375633;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=v9lbr4TFxiuuucypBBOqCbJsUUDeJTCLXV6XHKdyrTE=;
        b=R4E3zCI/ynbqV2eVPOicFC3rsrjqTey3ueeEi0x4qOymxJjwSfJaeJ/iNK4nD6zylL
         0a+NNmY6rQc8ZqTx9XMYnYRqinhKDqzSeKsJeyr7PR4CBxCChEBW43CY3NkPSrzsebLp
         1pQcNzyH9kvvlAlCYQ+Tvy783IyjntllSruTbG20kaLa2Xhmh2QuJThPknQ16moqVyjr
         cIS35AZIjgw6eLipzofdmELJA9Wj+2bJ0jxTRGXqby0cLAv40Ys5EzqDf0/Z4OOKa9Xh
         v8j2sz4fQ1SHtDc230XwL0Q8NZbxsL6bCAUfbLDy7z3++aemnEnPVKfuhnNk0w1XdRot
         bO1Q==
X-Forwarded-Encrypted: i=1; AL+hErFwFU/1T8Mr5QT8i7XkMgM4Q3+4GlzUsirbySLsM8Jmt64yfHbkxNNBH7aBhmUvMcW543J2gQe6Dg==@kvack.org
X-Gm-Message-State: APuU4Z9/LRPoBrT4RxKm5TMtKBwSQyK+mHh+nA0FYUXEHCKW9f2MkcF7
	S7cg4/zl2F8ONZAqkX4dh1e0hxLx4A9RELU1t6h/YxiKy0UyK9mU5AGb
X-Gm-Gg: AZFdTZcqkYra/JJPc7RirxK1CuzjnP/X0BXfBqbpBCSP8SAzO1omFyUCNgRypGsgDcO
	BwaSvhNJFQMT5+CrVorxxzKBq2SryUZS5ZeL9L1OGUw6lX/rXQMcVcbAwI4ZsFlHiBve1x2s7O5
	sxcJvCbgOoTCMj+qA84T5SGpc/1xitAiv3RzUbotqUB5cFCHTGLgTBegNonh9PtOsnbwk1GvmKM
	MM9Um5RYjf8FpOvf5d9pNyC8FUPNBfQ6UiGE9JNFSDk2gJXvosqT5DLWTa+/BOITXVj/eyoeCxM
	XjfQM5O6vlJWOA4OwQvx15CsuoMgsVxS3Ir4WFzhkMffqHSMmN+8TvUHnew149TDNfMsfnvcIJG
	H2qT5ErAXFJj+hTh10JumvqFj/8vpIyzgsXop9wYACaHeuRyWeGqETjEms6M11shnMmDq+rIRab
	ACXoHKk4mSzhg3DbDWjv+/cJuVfDOknZiToILhXmaKj45HtTfS0enhcd0I/GQF0L1NPQcunigzv
	MG3iCf3WLBAJUm4oqzOj6Jy36SuqKaDGD/IA7ZYAfoOHsD8UjI78ZSA1Ah0WtMcsAC4ziItkG8y
	wZvuULcqlgltWzkwxrXenGSXoIYzaFDAKlE=
X-Received: by 2002:a05:6000:4211:b0:4a6:4862:28fc with SMTP id ffacd0b85a97d-4abaa9764b7mr46243092f8f.7.1795770832771;
        Fri, 27 Nov 2026 01:13:52 -0800 (PST)
Received: from nobara ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4b1ed8b6a05sm26067087f8f.43.2026.11.27.01.13.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 01:13:52 -0800 (PST)
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
To: David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Zach O'Keefe" <zokeefe@google.com>,
	Hugh Dickins <hughd@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kiryl Shutsemau <kas@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Dev Jain <dev.jain@arm.com>
Cc: "Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Rik van Riel <riel@surriel.com>,
	Song Liu <songliubraving@fb.com>,
	linux-fsdevel@vger.kernel.org,
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2 1/3] mm/memory: allocate the deposit page table with NOFS in do_set_pmd()
Date: Fri, 27 Nov 2026 10:12:14 +0100
Message-ID: <20261127091344.113688-2-azpijr@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261127091344.113688-1-azpijr@gmail.com>
References: <20261127091344.113688-1-azpijr@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5AA6F40009
X-Stat-Signature: 5ps6kqem74xpj7zrigfny149uyph9k7t
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795770834-902603
X-HE-Meta: U2FsdGVkX1+dwO5OIwnMry6Q8Koeg/QRl2uEXPVMWKqYHuJccov4qADgR1poY0Ur1RuYyflltrSf27oqFzgVHkb3nVBwA5xaxQ9l5G81qoCa13vZdjAJAXF9uGpBDHIX0IOVq83iEwU098frSJD5X8WHQ4NcslpuHnTk6DAvD++esL1XoeqXV0rZsJ9Cnaq6KoqzurQl1CshXE5Z32lWM8HIz8Aoaml8xRD8SlQPTwc56mKqtSpC/BFEBplMrumqGSVPDTnU1p7Zrt9vKkMnPpqPi7J3svm5y9XlygUu9+XMe4ZrlVE8kSb+tYnpAQJUf9GzwXJTuL2reAO/XAfZr1ZD3rFEWlUjUfnWBZJ8rEjR2dWJQ0E34dw1OugIwcTVnyYxj1NsERmkcdfgLr37eqI+d33nsbIuY3vL8IzdZ9pO4gwbFLeVq2bm5NfdD4GiPIOgIoXS9mA1Mx8jj9/EJmGAVTNEDfucw2nFH6s7FqR6IftSeKpmWVKZeS6oZ7n1RmoBqRS9ekxNtwFe+4CDZ3nJxxaIPDlyvKxN0Nst4jYHdJ+VQshgM+Rs8G6pf6hZV9mJ/3AAgI5ZRB99tjxaS3RbVcmRDwq5/qdc3tYTGflWNG/nGnNM1U9MbAB0QbyseBzEsPWP+heWq/Ii68k40AQYRIJ9+Ox1E7igktPga/7VBPvf9enluwMglXrLIqT/gE1MkIbnSzAuMmHI+ZzmynihePAr2mYu5noGZD1QSCgxWQ9li73NGAdV5e99DYrsRU/tL/ERyAXoLIjYQuiwS3ttLQa6ePZEBC8s2axf5Ts6uWbr08c/g22hMHyXbvIH7HlPbNWNqBik+kMcVbVxLxxU/mhSBooiOBgszJ9WXIWoNGjRUmt2rRngCrlw5/OnX01ahKyOME1mTc10x7G8f+wanr2WXVzEDq1O3tWtblE/93cGyHAfxDAV4iolQGOLYvWaU6R1Tqigu9Ac1Oq
 g9gcnJsP
 o3aNzOZpLIfpT0qPZr8w18Mf4d8tjyC9SmoEmG740y8PyFNxC+T/5I7HELZhlo9l++7Qp4uETb0bB3/q8+P2q8c80fa7P1QQgTPpFTN+9Mt1JKv1lq2hUgLfdCzY/urUcFoSM9Z4Xyhj/oPkUxztUgS1MGIZDtO6XmrqtD6saXv/lwreuI12Nu4p0KNP/CdWqLJXE1gY/Bz9pg0q8I5jwaqmBBkwZShep26daf5cQ/YccdFUJO/5DW3gi0hBIg1SOzYlj13hg/QGX0/945QypJmW2EeXDmTKXcTfxQKA3krPahqBHcUKsslHPXZmV4oi/aPkp4fVf3mQIHMK+bltheMG0pjk7HUs77VZDefQw//JljYb0lM/Nth8MOyiDCsZbqevBBGkKgV1iIuklUtaNlYgjYGmwiJh7o0rYxKsGK79bNZfvmMYkAZ2Cc4926zT2JDqybUo0D2dq4tD5VHaz+akWVVlqNgOyKH8W5pzUV3znv6q7sp7VL+03ykD6tSoG165ZDiVlrqL+Qob3ChPmNi0NhCS7zWd7jXDiGX3uGeeIme+jaEkBvG5lwF035dHsjzC9aVol21ynuDF3OB4AZbi1mcpMsGmRVpJvW10AqOmSOUJGuJpdd1xRfvyxjBHeYbbcPZzLkmK0KNYYyH7q4p+Rd7Q9Hbse6YITiULA3l6Qh7sQE672Rin1FF0YaKPOV6azKVNHAmJMmck=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On ppc64 with the hash MMU, do_set_pmd() allocates the page table to
deposit when the caller did not preallocate one. Both callers that let
it allocate hold the folio lock: set_huge_pmd() in khugepaged never
preallocates, and finish_fault() has no preallocated table when the
page table was removed after __do_fault() checked the PMD.

Allocating with __GFP_FS while holding a folio lock can deadlock in
reclaim, for example the memcg reclaim deadlock on cgroup v1 described
in commit 63f3655f9501 ("mm, memcg: fix reclaim deadlock with
writeback").

pte_alloc_one() takes no gfp flags, so allocate the table in a NOFS
scope.

Fixes: 34488399fa08 ("mm/madvise: add file and shmem support to MADV_COLLAPSE")
Fixes: 1d65b771bc08 ("mm/khugepaged: retract_page_tables() without mmap or vma lock")
Cc: stable@vger.kernel.org
Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
---
Changes in v2:
- new, replaces v1 3/4 "mm/memory: never allocate a page table in
  do_set_pmd()" (David)

v1: https://lore.kernel.org/20261125100058.15200-4-azpijr@gmail.com

 mm/memory.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/memory.c b/mm/memory.c
index dfa307a9228c..05d03b32ce52 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5806,9 +5806,17 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
 	 * related to pte entry. Use the preallocated table for that.
 	 */
 	if (arch_needs_pgtable_deposit() && !vmf->prealloc_pte) {
+		unsigned int nofs_flags;
+
 		if (!may_alloc)
 			return VM_FAULT_FALLBACK;
+		/*
+		 * The folio is locked, and reclaim or compaction with __GFP_FS
+		 * could deadlock on it. pte_alloc_one() takes no gfp flags.
+		 */
+		nofs_flags = memalloc_nofs_save();
 		vmf->prealloc_pte = pte_alloc_one(vma->vm_mm);
+		memalloc_nofs_restore(nofs_flags);
 		if (!vmf->prealloc_pte)
 			return VM_FAULT_OOM;
 		pgtable_allocated = true;
-- 
2.56.1


