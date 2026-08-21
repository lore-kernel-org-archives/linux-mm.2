Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2818C5DF88
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 07:05:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 956026B0095; Fri, 21 Aug 2026 03:05:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92D9E6B009B; Fri, 21 Aug 2026 03:05:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81C9D6B009D; Fri, 21 Aug 2026 03:05:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 544F86B0095
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 03:05:29 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 319A1403C6
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 07:05:27 +0000 (UTC)
X-FDA: 85124390694.13.62A9E44
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5F997140005
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 07:05:25 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=crusoe.ai header.s=google header.b=IElXwrS1;
	spf=pass (imf23.hostedemail.com: domain of saravanand@crusoe.ai designates 209.85.214.177 as permitted sender) smtp.mailfrom=saravanand@crusoe.ai;
	dmarc=pass (policy=quarantine) header.from=crusoe.ai
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787295925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=H72dygOg9yIEOwIPt0eosLGHWNoHMNL+/AqoJVCW+JE=;
	b=jxHz8ZD3Ngh/AZyd3/AcNmY1BBFuskGkYB5CV7i/rflIypq99vvv1vVWCAiQLyxCWQYeSr
	E3/VZRtAUJbltIcdkUtLHnooWY+/1GCz86C5WosSoSpPHne3VDB2Uc+AZbYF5iprdOCo/9
	JeY5lAAXTdBHnhD45wgXeyzon4j4H3A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787295925;
	b=acunK+w+BvLUWMhFxglr3oBvtPya7+WFvAdTi5X4X7FnqnhzeU3O0TZ3v0ReVDd+VELi8L
	/zFZLu64FQdLWczxgwSgBT30Y12O4A6+TwWlirp+6PCLaPsNcjwZzsyLKydXZFu37ZCWb4
	YDv92vlMbOwuDVf8PblUrKEVrXRITr0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=crusoe.ai header.s=google header.b=IElXwrS1;
	spf=pass (imf23.hostedemail.com: domain of saravanand@crusoe.ai designates 209.85.214.177 as permitted sender) smtp.mailfrom=saravanand@crusoe.ai;
	dmarc=pass (policy=quarantine) header.from=crusoe.ai
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2d5cad1a6baso6442605ad.3
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 00:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=crusoe.ai; s=google; t=1787295924; x=1787900724; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=H72dygOg9yIEOwIPt0eosLGHWNoHMNL+/AqoJVCW+JE=;
        b=IElXwrS1QiEewBPQqDaSlkQVp0qFyUCx+8QWjN8wjFV5NQrw3nsuOwZHnIrl1XqnJ3
         poRHOL+0hDUl4SQwG5dgomWjg58mOmk3suylH6vp6f2Wxk6nWXgyNfQpFji3+FHzvzQe
         2Dq7wY89UjUW3NGxXcIxbXMzB0r1xTNw1I9ru+ATk2dMBATv8phAud6zv4U5++TKs2Vw
         e4zWfTda9VSDKyQNdyf+ROmmgHXHKrWcRPqfr0G5vlHCBxnQwXtSszDsEdpw2ITjI3LL
         nTtq5NX3/PE8ae4a/K/pBekjgkOdoogw0KivsBq8vDLCnP9yaeFOCIN245YwBqIx/bjS
         YvOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787295924; x=1787900724;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=H72dygOg9yIEOwIPt0eosLGHWNoHMNL+/AqoJVCW+JE=;
        b=PkaJetIO63OzEyvdFXM4fLRIdZVlj6wBtcBECLMM/Vc058lHnvhgKkqNJyjOWbqCLq
         EMxxzNah8Q71ziZwhQw/+mkXDVnoKqt7woz3JFsjFTdDDWP6TsjbaJpZ0n6nWx7L3/rf
         Liyfw1OJiPyZcxn6MpEMFN/mS+vs4XAtxqEX0Ne6urqtPOHMQNdzay7UHtaTN/k1j4oH
         Jy+eKC1zixGfP8OazzR/8EaDP0ZvHIq7MhHzr44u67Os/5h77NfiHmcb5LDfmNgaQGmV
         alPu6L//qLS+UwrRByA/M2S5Jht8bepplMkMB2w+8ht2zRMgO9ShaRH+0OBhvXRZVZXn
         +a2A==
X-Forwarded-Encrypted: i=1; AHgh+RolSGUbkK9knBlWdUkJFUzB5ZyfgDFp56OsZ6pHW8GNinpzj7zoLzYxIuyzaGIJ6ou8NUCJ69O2AQ==@kvack.org
X-Gm-Message-State: AFuF++nJEoTPVypQKwaOFUDtza5JUFyejokLlrALXEVo0D+D4YcpllYn
	o80k6631uHuGjc/L6hSN4a4ocZ+ARRw+aPXqsnQXNBLPSvo2jv+CiMYrD4rqeoKmSi4=
X-Gm-Gg: AR+sD13JRun8eucVatDfC81pJwvOQ2wXMZ77yVEzzZ6QOhAXg0gxgG6LPGAyFmpTGOo
	dHv14FbjyeS1sHkxx/Vp1V5Px3xkK2oVBWgSGUeGghtm/ipdqwxVUy+C0rWSISfI0h2hn0Gn3aK
	dsp6H0LNyGGXFcc5gulUmrA14A95N+sl5yVMFdjmFreMmNZxo4oqaASYwBpIXNQfQ6b2NL9xwJo
	lOc8nm2T5oWPvSs9rYjd3lx3IiZVh9nRNTHWaD4dNrelNW67dTwhIxyMYeulo9hJMWhNz6kgZS+
	TqoQw1aNKGj2tueu2ueNwujCk3Qx7Vcu/r0wBnliFTPI/Sfda5Wk3kdk7Ww94VZbA4Kfohq0wNT
	IwuXY4Dj23fxCW4lFM2zBM2peF+L7n8FXD774KiAcBLp+sUi4Xwavi3mmonUaRlsPlHLkiVSog7
	5+T2ciVDn2T4J9SzPlsxoEgVGB42dPkNNpJnPm9lLQ34hd6/LuuFTvDPfHFRtlxn+L/6ZE5jtMH
	KUNGk0g0YsMu69RWxbaUE8nhKYA0LspGTdjbiGq264=
X-Received: by 2002:a17:903:b07:b0:2cf:afe8:b722 with SMTP id d9443c01a7336-2d64afe960dmr79499025ad.11.1787295924173;
        Fri, 21 Aug 2026 00:05:24 -0700 (PDT)
Received: from MBP-Saravanan-D.civet-hops.ts.net ([2601:647:4380:3400:8867:e04c:ed8b:db39])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327bef77bfcsm21651507eec.9.2026.08.21.00.05.22
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 21 Aug 2026 00:05:23 -0700 (PDT)
From: Saravanan D <saravanand@crusoe.ai>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Peter Xu <peterx@redhat.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	linux-kernel@vger.kernel.org,
	Saravanan D <saravanand@crusoe.ai>
Subject: [PATCH] mm/huge_memory: allow huge pfnmaps regardless of THP mode
Date: Fri, 21 Aug 2026 00:05:20 -0700
Message-ID: <20260821070520.25759-1-saravanand@crusoe.ai>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: egqss8h5zothmmgeej78i3hyuutjzm7y
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5F997140005
X-HE-Tag: 1787295925-685418
X-HE-Meta: U2FsdGVkX1+LDtG1tB362hMCwUatn0uOZKr5klclmzEwDMLK6qfWvTpAmRsGdSGvMwoWGDMiw/k6uG56BQ8urmEgtp77LPnZh4j3Y8ao6FM8Rix07Sp5LKsRHhDajPB07Xl+wHQ/RnDd5WwBcDvPEYjBUnYIlKOv4lEZz0HrzVmGAQNp0QGM0o4foo3P2ukW51CCAIq/cKTtUh0izHa8TQJuA4RY71mke/ia2ZNWno+ZvB1s2CuQvjtNTh/umBnXgLjFt0Fy98HctK17flku+tbVnWqUMKAnQZ0C9ks6BijM50BDdJZvdAwo7aPF3NxMJ6W9jbulgxQ4kF1ptRtrz+HaN26I5Sgvl++v0PJXbV2TFzr1HM2njsJmnjO7ZGZRPDu29O7hhRv6mhsRzm18aakiTB0+D8UDvKMRJzIfLbiguaw6wRefbzk3lByO6cIfnPynTBT8DBlN9D4MHonY2N5Zlf2CJi5a4RQCkj/Gl4WGTuZM6/ibPVOHfjWcCb6aMFsSY+qVLgHB9tCNj5N6xdnfXPBrEYiAcwQFJxailvKQARvKlD13mJDpf2aWfe753uXfV5v1W4jhp+QH8VsBhT8aPoV7hxLhZp9chOxa9pxc7jBalpMymT9S4bUpTmR6AwwnFwkzdQwWuF/SO6tRNnbtxO7Zev5tdpwTZhCQ5Uf/wwvKvkuIXW7XLBuqD8xWKmSg8hHnuQYOHq6+MLRpFj+WK1pWFQKKEIEd+uwsHHhihe6DSDbmyl7v1Gndxh9bTi7ZgdrcDVVXEPjz3UpJRBZhl/kAYWpSID6zaOGfomqValaqJ/8oPNaU3d58JkVGht0NaAb0HYUMVkernxQCFrRMHh7ZS10u3QzFo8DaxJup6/EP+hkL6uWj2waozePszNJWHiyWJLf1ZIFUZJ+qvxA5Z7FnyZXhNYff0VtEDSYSHp+vSbjsc1WcXK6LkklfSjWa1zJzHRYub5IavFy
 VooSO7/b
 vaR08Y3YdrKPe55wOFmGCuY5OIC+/TN/r8ueExAbMn0opAqy6li+5h42toPCoafUqw2sNA0mWicDUbm4433ef0X8gH36pDFbVG3yI8DFvRULZLSuyN8FhbWBRcmetf44G9T/wGhsZC+GHwOz8qtCSowrvjz30+9nn6dZJ9ZCHNiHYAYcjyR/veDcsyXLDRQ9YDla0sz35m2fBC0B9+wZKYxW13ww3mQwskXWlceFVvZCS9OWKXMio0FJDNHxXimgEiHB2qfOrlKo6+IVLk0jSGetOZ5lq6+OV5x5NQxQSrLpspl03oa+Txpv9mDQKAWTt+kE8lndSKqh1VHGKvBiFJtMe9ZhzyumvmRj0HgGMJJKzmLA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The THP mode check in __thp_vma_allowable_orders() runs before the
clause that trusts huge_fault() handlers, so huge pfnmaps only
materialize when THP is set to "always". The THP modes exist to
limit the memory and khugepaged costs of transparent hugepages.
Special mappings are backed by pfns instead of THP folios and
khugepaged never scans them, so those costs do not apply and we
can exempt special mappings from the mode check. This also makes
THPeligible in smaps report 1 for such mappings.

This matters for VFIO device passthrough on distributions where
the default THP mode is "madvise". Mapping a 128 GiB GPU BAR
through VFIO_IOMMU_MAP_DMA costs 33.5 million order 0 faults and
20.7 seconds when the mode denies huge pfnmaps. With huge pfnmaps
allowed, the same mapping takes 128 PUD faults and 0.4 seconds.

Signed-off-by: Saravanan D <saravanand@crusoe.ai>
---
 mm/huge_memory.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index afbb5974bd22..bc61b8020af6 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -193,9 +193,10 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 	if (!vma_is_anonymous(vma)) {
 		/*
 		 * Enforce THP collapse requirements as necessary. Anonymous vmas
-		 * were already handled in thp_vma_allowable_orders().
+		 * were already handled in thp_vma_allowable_orders(). Special
+		 * mappings have no THP costs and are exempt.
 		 */
-		if (!forced_collapse &&
+		if (!forced_collapse && !vma_is_special_huge(vma) &&
 		    (!hugepage_global_enabled() || (!(vm_flags & VM_HUGEPAGE) &&
 						    !hugepage_global_always())))
 			return 0;

base-commit: a032d41a86cb82a747bc14d9c82b3e153a9a9ab7
-- 
2.53.0


