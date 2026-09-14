Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3D50C88E50
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 13:24:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBE326B0092; Mon, 14 Sep 2026 09:24:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6FD86B0093; Mon, 14 Sep 2026 09:24:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A84AC6B009B; Mon, 14 Sep 2026 09:24:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 78D8B6B0092
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:24:07 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EF312A3A27
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:24:06 +0000 (UTC)
X-FDA: 85212436092.08.FBB7B12
Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	by imf26.hostedemail.com (Postfix) with ESMTP id 31D0614000E
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:24:05 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZNETvTZu;
	spf=pass (imf26.hostedemail.com: domain of jaewook376@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=jaewook376@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789392245;
	b=h2MhWDQrF/MMUOfoBTnV6NflEii+tPa4GqqBSZsFQkvcafaTyueD+B+ao8okTgYob98I6O
	rTgGX869zzWdQJu3AZRGtPgIFDV3xrDKlHKJl7bMgZ3kDNx77GvBGZS6uNa9FQSnZrOjC1
	/tbhvjAhLFjPAk0dsh4uGV/cROCQbGg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZNETvTZu;
	spf=pass (imf26.hostedemail.com: domain of jaewook376@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=jaewook376@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789392245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fgRiOcxuYT/a5YlmbXURlfn299Pxo8srZQixNKFp+fc=;
	b=XWoWyCeTbBeaLDJEKHUcnuv3GAYdFoxsZE6AR2jvxM6cPfsgMsxTcg7ruVUTzhNAUwes5P
	2fYDgbiqO1G3eO2qemZWPTW3BXvOLKpvKBUvJloDX8CGxeUu5owXQoFFGB5sxZyUD6I013
	TwvLkKvTxGvx32UuFDEQX+NZhYj3Pvw=
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc4d04d73b8so1526635a12.1
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 06:24:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789392244; x=1789997044; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fgRiOcxuYT/a5YlmbXURlfn299Pxo8srZQixNKFp+fc=;
        b=ZNETvTZuaZk9p4UfaFKwMJTF8Hh6Cupv3M2GI6WG3g4AWfpcec3kYyymPfXyrcFpDI
         lw0lxnyby8dDQClEE+UZa5K3cfvmqmFAulga/Ns0kc8mTEq7KCCWB9ceoorDbSqfkGNs
         8qale8p8lgCts1080VCBygsLWHh9JclpNDj9rhJgZvq4u/E5BmTGiEp+Kf9Jj0J15lGH
         i2eG6yK5YFwYc560QTlID/IXh2HrhFVYqPGHiB3U3Q+H3Km192kM6Jlx2V38FShlEauu
         VjMhwi2sfE6i+zUumH0ktNJtcl7dx/z+KaQ3RdzjeYkxAY8XGP+KUpRnpEFLSQK0h+JT
         SNow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789392244; x=1789997044;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fgRiOcxuYT/a5YlmbXURlfn299Pxo8srZQixNKFp+fc=;
        b=d6f3IobwFOaGe/HpPmYT71Ro8GnDxdu3gmUjaTNKQeRUo7xGpkMHIU/y7ffbdIlc6q
         pDIIWPEjNdP0hXeyR3vPxFu63bCG8eSwx8vtKArSqoMTcDCb5qCswqcol3lOBUVws9ac
         XkcAaPGeHd2WlRAPTceQpgRtsVU8THmnjO7SM0ncz0fwxFrKcIQN0jn6TzT6ilkD8ek9
         PfFj49efYPUVGq0BzsLu8+rSA07pfZ0q2Vn6XiticV30eQPcvwQ6tjWPRf+qhNmi9Os+
         Kmj7Fz8cFRWAMHSOG8PP9Y3jtkh4ISygXvvPpjGhnCNzt0rW+j0VbvNrduX+FLPeGKRq
         zPkw==
X-Forwarded-Encrypted: i=1; AKwUvBz2vYPEbuWqNsxxJcnFdr8AmPLrwmeIhy6dU9jyzd4YkoTcbtwgrduGBwbTSC338RS8tbX6yBo7rw==@kvack.org
X-Gm-Message-State: AFuF++k4jL8WsC+9QOuErwJKjNLp0Sssf5V1IFIez3FFCqrxhLrM00e4
	2Aq35lk/j1zOjCAy02/Stgwt1imNm0Yr/aScvdLJEvEatLTNoZ4naYw5
X-Gm-Gg: AYBFou3q7k2/F7A/jvyFFrCJNpNhOXkV9VYVFJDW1XNBjgbK9rBWJk+PSbU0fPIkIN/
	aIw/BvApbU26b9tw6FkR4gX9NR0CVos6t7TW6u3pCaWNlYUH1tM23/Cj5YcNGlQtPkwBXS8WAH6
	4l1/wkykK1u6BM2D2WdzIrMqip1hjM0poM5Yt4/hG8ROJtLzvHGsOoeGOg0aVfCjnw+soRzVvav
	yLeeDNv14jgqlQjJixGogvdtrzFyHSZVuEejOSY5gnaIcf8dDmEjwQXI9tWh1QSFNsOu69Q16vq
	tFvYHtL7xsG3iTSzSm8DPT0Rwl6RHP7O5YSWDTuJ0ets+tjGnJMlwXAPGz6oDzDxlLwBvPXfLNX
	u7o2E/otj2gCKYDQxjaSko+DqsFhB6DN4Fh3yG8eiweyon8kklUvV4iGlhgCu2Md53RY5qwypwb
	tB41E3x0vfes2Vn0V01FqELTzSDtEsvt0QviEaGre+D7ZMrnsOkhqbha6CukwfBdO0RxBCLiv/1
	tJobKtwrG4Egw==
X-Received: by 2002:a05:6a20:7d9d:b0:3cd:9bb1:c6f5 with SMTP id adf61e73a8af0-3db40452773mr4994899637.10.1789392243791;
        Mon, 14 Sep 2026 06:24:03 -0700 (PDT)
Received: from arang.localdomain ([14.47.12.38])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc4c6596265sm4938853a12.27.2026.09.14.06.24.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 06:24:03 -0700 (PDT)
From: Jaewook You <jaewook376@gmail.com>
To: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johan Hovold <johan@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3] mm/hugetlb: preserve mremap address delta when skipping page tables
Date: Mon, 14 Sep 2026 22:23:52 +0900
Message-ID: <20260914132352.472-1-jaewook376@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260911182408.75821-1-jaewook376@gmail.com>
References: <20260911182408.75821-1-jaewook376@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 31D0614000E
X-Stat-Signature: kzg9axxygj7f1cd6atutgf5d1k5x6m7b
X-HE-Tag: 1789392245-909528
X-HE-Meta: U2FsdGVkX18qjO5OfmCR2cj0c3u4lKKKJNj/TqO6jLfFMAdJ9wVGSm79cPmOyYzwIsYO35sKUGZvWsBga7D3nvpZpXupwm/AoBCbFo/3DWruz7phmsRUr0PayyYcrL6BxGnb02MBFmkb2PACzHFeR41iGHJb+rqW94VD1DQsM/n1tpYWucQiG+lQ+XtITBVrUVC8AHi06FB/J//sp7Ldefv4X2YJDV2g2Z0pLSa5AoCOPDAlhJ2egyycIn/4hJ3qaA3dseLoGzHpiZm/yEZV2zOxxmJME8ewMkUPUi9vKhoTL9C2+SbZ/pg/jGo002DzNbz4LqlQvRqiZmJtZwV/ynh6pK800uNN1HBBAOQfZfc4WzR6twh2R0pubpRoZK6mWrAbdCUkuLxtsOWsxpwqBygIMWQF/PjjF2guzwlhpuBDTyvNIWclHQ1S9kboSuv5xR0TXcErIG5FzA0HEQP+ChzOUufCLVF69ts2IlOwsjOR0Bscn+HdmAeQwondGa4xMRJKH1XHxkyH+iRf8wY0hmC1B6rdE0kyKxVfLJQOaNvncRKuSTPlZp1IN43QPgFuK+D2/0SUTXpP4zWigvD5OO2U8uYwbgIgDSHdM9AYCNXjPqQU9i/mmqMqhLHDYQFJ0ydtNxIb6QRSNSr0GqDhfuTwfof1cpnWLLhdA/aksyY/Gy7fM8O/aKY6CF4UBChxW8bWm0bRQJIbwXz5cgBHIqoRtXQdNRmM+3dIvJk/+UdVUbctBmxYlNaKl/+acgwtNlr3tiAN2odLuBltD3aaIwxSHP3uoGrhKMWeAD5xbXV0qCHAZrbquk3QibZ8sP9YbBQ66rqejbccbF2lzTaZUj8yNZD278bA76uiomSxbSJErC9jejFsHIPjsBeYP/yBs12E6yF2X4ExlnnqP3shAaCVkPK0ppBcCOLtOpKzBagpn89v69D9bwQwPNksE5Ya5MGd4Fd/Xb0lozgF3Oi
 jxhwfXKF
 c9bA1ofGrwape6rrj7LpTp/VzEaitFJcf9BmkzS7K/RfG+gXeWjv5o/l5bn9ucbiTneTUNZeXWtmzSkgnlJNvw3d9D8LwUCn9dx3LqyC9B0tX3RwLhmT2lIRpseVpW9fC6Fgtd9l+I8Y37jcRYVPydV4z9mxUIvGYSmIw/346EhJS/lIlwVX20lh9t7r8MjwBPKfFlq8ojVoqBS0+1nJ5DSzSV3bLoIPJi3Y7SHlW5XKxpuZ0KvC7TK5Hg3d9hjn9ngxJaLXAvV7rRxzntrfiC6oBgFnq3cycB3WzeLrxQIJKBqrPRW1ItvPpoMhQoXOVi3LqxPe4moJitGIIBdVy1/yoSuaoYP6MKcw8eZyxta0Nb17CdzYQbEq2+MnLwxtGRB4gdOxP1dPQeiZttCLId+VFPbnqZ5v0yc1FkXM+c86+unctVsvB8nfW2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

move_hugetlb_page_tables() optimizes mremap() by advancing to the last
entry in the page table when the source page table does not exist, either
initially or after unsharing a PMD table.  The common loop increment then
steps to the first entry in the next page table.

However, the code advances both the source and destination addresses to
the last entries in their respective page tables, which is wrong.  The
destination address must be advanced only by the same amount as the source
address.

If the source and destination offsets within their page tables differ, the
destination address can be advanced too far, causing follow-up issues.  Fix
this by advancing the destination address by the source advance distance.

With a reproducer, we were able to trigger a kernel panic on x86-64.  With
this fix in place, we can no longer reproduce the issue.

Fixes: e95a9851787b ("hugetlb: skip to end of PT page mapping when pte not present")
Fixes: 4ddb4d91b82f ("hugetlb: do not update address in huge_pmd_unshare")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Jaewook You <jaewook376@gmail.com>
---
Changes in v3:
- Clarify that the optimization advances to the last entry in the current
  page table before the common loop increment steps to the next entry.
- Rename remaining_size to offset_to_last_entry as suggested by David.

v2: https://lore.kernel.org/20260911182408.75821-1-jaewook376@gmail.com/

 mm/hugetlb.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 4f6f58bf3db6c..5749f6270fb1f 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5161,18 +5161,21 @@ int move_hugetlb_page_tables(struct vm_area_struct *vma,
 	hugetlb_vma_lock_write(vma);
 	i_mmap_lock_write(mapping);
 	for (; old_addr < old_end; old_addr += sz, new_addr += sz) {
+		const unsigned long offset_to_last_entry =
+			(old_addr | last_addr_mask) - old_addr;
+
 		src_pte = hugetlb_walk(vma, old_addr, sz);
 		if (!src_pte) {
-			old_addr |= last_addr_mask;
-			new_addr |= last_addr_mask;
+			old_addr += offset_to_last_entry;
+			new_addr += offset_to_last_entry;
 			continue;
 		}
 		if (huge_pte_none(huge_ptep_get(mm, old_addr, src_pte)))
 			continue;
 
 		if (huge_pmd_unshare(&tlb, vma, old_addr, src_pte)) {
-			old_addr |= last_addr_mask;
-			new_addr |= last_addr_mask;
+			old_addr += offset_to_last_entry;
+			new_addr += offset_to_last_entry;
 			continue;
 		}
 

base-commit: 08df884136f1c1197bab2a27814404fd329d9aac
-- 
2.43.0


