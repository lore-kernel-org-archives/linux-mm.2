Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 995D2C88E40
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 10:08:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 770BC6B0088; Sun, 13 Sep 2026 06:08:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 720E96B008C; Sun, 13 Sep 2026 06:08:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 636D46B0092; Sun, 13 Sep 2026 06:08:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3B7156B0088
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 06:08:33 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4B0A31C27CB
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 10:08:32 +0000 (UTC)
X-FDA: 85208314464.20.D71FCC3
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf03.hostedemail.com (Postfix) with ESMTP id 95E8D20003
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 10:08:30 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PlQQQEpf;
	spf=pass (imf03.hostedemail.com: domain of ngocthang2710.1999@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=ngocthang2710.1999@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789294110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=cwdi/6Fr4s2UCykzftMpLqN1YkG8FoctaI5sNGgltcw=;
	b=dVBHF23M6svdf4t3vz40sp7eqongbrLVg+ShAf1HtFB1NwVUz8GrqaAwjAFWwpfu4/vRKl
	jt3fKKBE3hdQwePaR+4jltODLJXTzvzBwqs275sY/ynoa73IayTqnas5Ez0oRYVSlWr4Im
	48bL7ueq5rtyu/VseMc1Ca7ZWC0qyaQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789294110;
	b=jszgT1j1xJwUqOl0TbStlV5Wt/RjBAytz4UNiGt9lglCYlreWIARWRjtq1Gdz3Oh4NLdaa
	D/eBntHZp96/Jmm0G7N0jvVQXQLM7D0l4TMpNUvq8xZUVJkSqplwR6R0IWsKMdmOKTb0ek
	BeEDsuRFQT2ZEH3ESNITaTFl0GNPOFs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PlQQQEpf;
	spf=pass (imf03.hostedemail.com: domain of ngocthang2710.1999@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=ngocthang2710.1999@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-396ccb652d7so668047a91.0
        for <linux-mm@kvack.org>; Sun, 13 Sep 2026 03:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789294109; x=1789898909; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=cwdi/6Fr4s2UCykzftMpLqN1YkG8FoctaI5sNGgltcw=;
        b=PlQQQEpfB5gE8zkY5oxJ7vN/IhOZfqGgLWdRbbJNYRFudS7RaBqkor/CJc3dkjJ2Zb
         lt4YpEhMaIVBmE/3L7IZ5i0lB72Cnl7XWg8DtoQwag6wa/oVROl/iIG/nmIjckoQ1b5Y
         u2t+IIC7+LNlNqfz4DA5xHC0JI2u3bHTd33wDJF8rqDDwz+Nx1gtM0Cf+j3Diu8dbx+j
         Uv6IomNjeEf6Opcy9sNDfcSW0dT6R/rtKl8+oMNQqtdZOSlLL6CfpSJaITprSkJH+jch
         8+wIYQu/dxDyjPpRueI3x/2dBv6cw0WhceZwLbw5QXTJJsIXA4GBaMdfGZwOrNXDYYWa
         n9zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789294109; x=1789898909;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cwdi/6Fr4s2UCykzftMpLqN1YkG8FoctaI5sNGgltcw=;
        b=mAowSrC+vxRXP+lcbfV4eVOao2jk32HnaiYQGF8VZRQLiewygxBY6zvxwB6kvJp99S
         /ZNCxp3mEMTZWqUZsRJjgLWeLMKraTto4opHI3gqLNGyuLYgTLLuZSZwNC0R45+uKspN
         hiRQILt77SxYLwrTSHPTrvHPyh3RPn0ErPixfN/eV8M6dHphOYB5K/DYJItdPa2aM1GC
         1eiV/KvGzN4IFJ4h8DZw2f7hqKwTKMK0OIAVdPYrcEfMvz/HSDRg+bj0909p9qtpepOI
         ubHBwMnC+2OG+xPm8p0P/aAHR+hkRA3mvO8vlJF7uTsYVI0/IAh3ApiRx2LDsUECCE2x
         37Mw==
X-Forwarded-Encrypted: i=1; AKwUvBxzJ+VmmV/1CJjuFglDwtq+3xY+2jlvasLUVKCvuE+5G5c3T+qfF2E8WTIcVhR6SOiV/wiOCT16jw==@kvack.org
X-Gm-Message-State: AFuF++n5y4twoCt55ZzbtsjUS1vW4V9IwoM9AtvXP1dq5/Zwc7o3BTnJ
	fZ/eLa1ssAmZSaRYxIpkG8ebQvoUvkMsXHyUMAmAYJ3C6E2O0u48Q9cw
X-Gm-Gg: AYBFou1Pis+VxrhuxPw1Y8IV2ecWTqbzocPHRJM2/18P17tcoDiURx5eGKTgYwFcG5o
	CGKhk28Hgdf43j6ZNFYtNRG99ZZhAzFkPE50ihxF/AAr+OE4AVjrl/A6sVKSkjfGJW/gbEt/kuD
	uvlKd+sSX/oDKi0k+IxY2omnpzm6LU9X3mHiegwRJFD7bfBTkCPoubcTGJsUm5RDBP076tUM9yz
	n/osMTGfvz93QrOc2P9G2RGBBVgmhyNIJ2KcE0PoS4OVVr5a/E5HGyJ8ayXbahSHbJOkENzo6Aw
	taLLFNGAlqvwdDV0DlnRYfCb1Pdkrz1oGis9mT3aP7ONGg4sEdxwdtgrXSKHu0utgovjCQLRf5S
	gAsVxx0z4KWRrgeUWQ+JH6JIU/uEnb3848s6w3JARQ8n3i9nHeI8Mbi1zQR560r7I+cym33xLv8
	4zt5p/e44jH7fe4pYa6Kc4OONZlIyqRI4/4iJulSJnzp5VyOlxLJklxXhOqvOfnDkaCpeXQG9ic
	yClrtANRlauysUQeg==
X-Received: by 2002:a17:90a:e7cc:b0:398:e436:384 with SMTP id 98e67ed59e1d1-39dbbe86048mr11329558a91.1.1789294108871;
        Sun, 13 Sep 2026 03:08:28 -0700 (PDT)
Received: from thangnn-ASUS.. ([2405:4802:1d38:5c70:f608:4e94:6df6:c8b4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d9d5cce86sm4597773a91.4.2026.09.13.03.08.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2026 03:08:28 -0700 (PDT)
From: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] khugepaged: hold invalidate_lock across collapse_file() readahead
Date: Sun, 13 Sep 2026 17:08:20 +0700
Message-ID: <20260913100820.28654-1-ngocthang2710.1999@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 95E8D20003
X-Stat-Signature: 9878akc4819jkfd649gafjx9hibchexo
X-Rspam-User: 
X-HE-Tag: 1789294110-697465
X-HE-Meta: U2FsdGVkX195EkcpRl/bU79UbBhzxlWObKT2zINJ9QwVSrWjbvAzMDfZKUBQ/em+8/MbilQsbiX4mNToSNkg96bV7DL1lQI9X2b9Z4sTuXAGo31uOr8uQKhCCasJkd3loZWuCEKIWBuUzzCCTK9rnSoWhq0ucULev/VQ+DpTp7s5CGFOCs6DSd1eqFL+d3g4pTJpd71bx9/g7dJMBitRKv2F9x2qMg4P+ZZEmx19ZBDuuJyG7wrGpkgwzJyVbkQdJ459vUvGbxUa1sIvhIXjzSVqAvk9e1fadgseOa/yT8+P9/L9BYEvVwyXdoynLtuqP2PWqv2gzKqrRv7TjtWF7AIDaA7rMt7SI/1xGldX/5dA8nMM4g0o1z08bRmj/RUc9if/e7BiX/V5oOVC6D1f89N17RxzjoG2zX2IFQuyWRZE5YQAw9LNladsAt/WVgWw38Y+OWdm6BgtPuijrEhGhj7a2OwucOsLygmFWnuIxoV5IS0qYWETFCwZs+o2XTyedO18So0r2U4Z+g0cuRPZrMvIeeFWb+bt4vp7pJVHTtdEXY7YZXLNNOZS2SHW/IX4DMGoC7544UYq5XwuBgMIUeB2wb0iew3ibVK27dTiXBR96zVbneIcAc+0vOsJd8O1/2z3iou+gplKD9ruI9PMep8js8tYTe2H6uifdowSwKPyS8EbIFCRpWFreifs74ojHXQpORDTsGwQUpLZODmSAjNf5uepmfGcpUaTGw0hgsg4GlE2FUl0DrEx4S5WhXb6221fx8zC+Fbj1OB8gV9a39MMAt3ynmiryM62mnRYmmyR4iHY9VMKbX1pxlLS7BTF8A4eUvgEjYbY7FqBqYSz0vyzSCGb6XNgrFRkZkzZTq50sJnW0Yz++0ncaW7tYvfRPUKdXyds1CkfbITjDreZnTwdjA86nqks5784CGWqH4lMMkDElFHmDrNCWG8arEFPBiavCWiPWgNUEubIfbZ
 JttYDt3v
 N7fO8rOS89n+phwsYUUinGnKzc9R1KW0y/TjJjGQa5RZDp/KBa+CnzxsL5GhDuM5fDv3h8Uni0PaBaG1+RbSUvqAOkPTo5QBjzGtlrBl435v5e3EhDPwAlqEp6G7Z39FmEvoFAuXEwE9fMweqtg7vDK6NAYQxERL0OHG1E600qTX1AI6FCislNrhnMCDtfoIDadcoQJdBQ0cUGpZlIwNNYda+J/C2XWbBDTpiJnXjfkUdDeL0RoBxrFgEYjDVnyd1dlhXQAmh/flrFoEPvd6QXl/iwwIW4BdN609ddsTvLnoMYuhoeNAUICn6rQTgG4WUfWfAhlG4i8PR6DQnEggO94n8smpGGiiaA9ChfQkBBrJfIutFMMyw2LTi7yHoR1lIyonrr8Hcvx+/YIDNlCAoqiKhH6eXXmkszQ+yAVTZPReTSVNWa6BydfgvFoWh71p6DcRsEBHE+agHWw/S55jFzWb2fD6bcxTTAtJGict9A3vQB0Ppi7KAPhR2jod7RW4pKm1D68hA95zOMigfWbuXu25reWanUiDBD6VkqgFRG488JvOnzEPp5i4Z6o+pa1a+Y23ZhMevo2me4pl2m4qCva8TYmcBARyNOhF3V9+vR81NHB5WrlTgr2mTUlXltf1R3297jb3Z6ifJs3BHA4Ttb9b3MHuG62DNnzQG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

collapse_file() calls page_cache_sync_readahead() to fault in missing
pages before collapsing them into a THP. That helper takes
mapping->invalidate_lock itself for the duration of the call, then
drops it -- but truncate (e.g. ext4_setattr() -> truncate_pagecache())
takes invalidate_lock and then waits on each page's folio lock while
holding it. If collapse_file() has already locked one of those folios
by the time truncate reaches it, and then tries to acquire
invalidate_lock again (e.g. on the next iteration, or via a nested
readahead call), the two paths can deadlock/hang on each other's lock:
truncate blocked on the folio lock collapse holds, and collapse
blocked waiting for invalidate_lock that truncate holds.

Reproducing this over ~150,000 collapse iterations with truncate
racing concurrently reliably hits hung_task: blocked tasks within
about 20 seconds on an unpatched kernel.

Fix it by taking invalidate_lock_shared once for the whole scan, before
locking any folio, and using page_cache_ra_unbounded() directly in the
readahead call site instead of page_cache_sync_readahead(), since the
latter would try to retake the lock we already hold.
page_cache_ra_unbounded() does not clamp to EOF like the helper it
replaces, so clamp the requested range explicitly.

Reported-by: syzbot+16bf7cd0ebeb1de93aa5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=16bf7cd0ebeb1de93aa5
Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
---
 mm/khugepaged.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 11ff98d55c76..690ccbcdf593 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2267,6 +2267,13 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	VM_WARN_ON_ONCE(!is_shmem && !mapping_pmd_folio_support(mapping));
 	VM_WARN_ON_ONCE(start & (HPAGE_PMD_NR - 1));
 
+	/*
+	 * Take invalidate_lock before any folio lock: the readahead below
+	 * needs it, and truncate holds it while waiting on folio locks.
+	 */
+	if (!is_shmem)
+		filemap_invalidate_lock_shared(mapping);
+
 	result = alloc_charge_folio(&new_folio, mm, cc, HPAGE_PMD_ORDER);
 	if (result != SCAN_SUCCEED)
 		goto out;
@@ -2337,10 +2344,20 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 			}
 		} else {	/* !is_shmem */
 			if (!folio || xa_is_value(folio)) {
+				DEFINE_READAHEAD(ractl, file, &file->f_ra,
+						  mapping, index);
+				pgoff_t eof = DIV_ROUND_UP(i_size_read(mapping->host),
+							    PAGE_SIZE);
+
 				xas_unlock_irq(&xas);
-				page_cache_sync_readahead(mapping, &file->f_ra,
-							  file, index,
-							  end - index);
+				/*
+				 * invalidate_lock held above; don't retake it.
+				 * page_cache_ra_unbounded(), unlike the readahead
+				 * helper this replaces, does not clamp to EOF.
+				 */
+				if (index < eof)
+					page_cache_ra_unbounded(&ractl,
+						min(end, eof) - index, 0);
 				/* drain lru cache to help folio_isolate_lru() */
 				lru_add_drain();
 				folio = filemap_lock_folio(mapping, index);
@@ -2672,6 +2689,8 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	folio_unlock(new_folio);
 	folio_put(new_folio);
 out:
+	if (!is_shmem)
+		filemap_invalidate_unlock_shared(mapping);
 	VM_BUG_ON(!list_empty(&pagelist));
 	trace_mm_khugepaged_collapse_file(mm, new_folio, index, addr, is_shmem, file, HPAGE_PMD_NR, result);
 	return result;
-- 
2.43.0


