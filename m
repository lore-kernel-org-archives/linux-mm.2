Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83341C88E56
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 10:11:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3584A6B0092; Sun, 13 Sep 2026 06:11:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E21E6B0093; Sun, 13 Sep 2026 06:11:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A9D06B0095; Sun, 13 Sep 2026 06:11:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D9DD06B0092
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 06:11:54 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 31268120652
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 10:11:53 +0000 (UTC)
X-FDA: 85208322906.02.DF1189C
Received: from mail-pz2-f43.google.com (mail-pz2-f43.google.com [74.125.228.43])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7D6DB14000E
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 10:11:51 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sTdxIw2P;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of ngocthang2710.1999@gmail.com designates 74.125.228.43 as permitted sender) smtp.mailfrom=ngocthang2710.1999@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789294311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=cwdi/6Fr4s2UCykzftMpLqN1YkG8FoctaI5sNGgltcw=;
	b=i58v40g4oaXPNAMSGBvuGrcvi+sxRQe2xqZ/oiVl5TmAGS81zK0en9JZ9+VBhjOpRRJkIT
	DrH4E/uw0Sgpbqnxo8GFBYhnb84Hvld7KPibt/c9y+wBuWdwG7TvyQuGzGebB0PAEr25Vr
	vjyNJ9CHBMA1C7upxCGxgo4AU997J8U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789294311;
	b=N3IQ35VoNVtnSzOU/ABeo3/xOLBdg6rJi4E7kVU31/BICd6qWSOwiCUoK/GlO74PCXR0rn
	ysRvvWLPOsZv+WdvphmGPMsQMO2cyGyJctf+jT05vl10t1Js4qsGCobp3L3AciBwTYct8V
	nouOz3QVAiF3IcthVsS79cgYoUNTpfg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sTdxIw2P;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of ngocthang2710.1999@gmail.com designates 74.125.228.43 as permitted sender) smtp.mailfrom=ngocthang2710.1999@gmail.com
Received: by mail-pz2-f43.google.com with SMTP id d2e1a72fcca58-86b90133ae8so873209b3a.1
        for <linux-mm@kvack.org>; Sun, 13 Sep 2026 03:11:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789294310; x=1789899110; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=cwdi/6Fr4s2UCykzftMpLqN1YkG8FoctaI5sNGgltcw=;
        b=sTdxIw2PHC+TDcu2n0Z5g9Wga/0A8c3uzK0lYtuvINj+1yFA4xbPzazXy7WgECjhkM
         y6Di+t8K2SlDerW2wi3waIHFenBlVCr92EyiqTxOkxVsheylH6ZmiaskdpioD1lynUUc
         IHHQzvt9ex1mHZCSp4jrzLrSI5IoyruDbYdzAqu7afxDWUa594q7c1ELCujBxkLWgCr0
         JKG/hCzDmR8lGpt1dpuxEHp9Zg9tbK3dNihOAUTTRTFZsodJMQEitKuJO+1LKN/lB1sl
         0Keb9rLKDKoCbZMU+B7FNYIZG2Q5JixVbpYi/atJVQ6ps8h6ixUzUGWZo2xlrlVoE4fq
         LyEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789294310; x=1789899110;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cwdi/6Fr4s2UCykzftMpLqN1YkG8FoctaI5sNGgltcw=;
        b=ZJ9iBozEJIsO8tOsfJYMvjmTi6/Zhm/ndOkJAgfWyJNAptpN2glcvFNkQFQn2PHlZv
         djwRFc4NQ4zANZTyHoWQ5wNEvbb+dgOWk7swwIm8cfBF3n6wb2fZMvSId3wdJX5s9+qu
         aSiDvFf64vwszy52GVvtY2adKFPOadrUO7qD9geHh5NUEB/1MVvyP39dQkwwLubCeCOq
         m/3SAFnHUFmGxR7AngoRrdde0E+hzs3aw/5wddGw5XYuccvsOBUHTh+BM023r+kvJ3Tw
         zysOPUl3QqSl0Ary5ad382JOdcrvUg8H8Vc5J32hNhtJ0Pq+3Rh49GcpQeFSqGmeaoA1
         ChNw==
X-Forwarded-Encrypted: i=1; AKwUvBz/ZnD8oUvZrI13RVgV3eCbznrWkBIunEQI18yLCFp/wlnnMvcci0OGBlNhESla3qQNM+qb/qajtQ==@kvack.org
X-Gm-Message-State: AFuF++mJJ/c496/NPh0jACMn6oNEaiaNfTsg6zK2snLYBAIKOEmNA0fp
	xyOE2qrjcWYAjir79NuNhljlhtUgTcOMNonVGNTBzK9exMvfwDMCinjV
X-Gm-Gg: AYBFou1DP2FmysW4bFu4M+9dC96mobsC1iiwr/NjTYVPZhUaQnSnraHtESNP5BuuulB
	4sjTkF6lSxgRc3IQV3x7ZXAduJ+oDkb/DJOnWHITdZi4iyYiCxvKT9qD77t01mQeZ9fudTPWzh+
	jhLPKAexqRMZGgQX29/J9OTX/7B0v4QSw3Z8HrnsJheM556Le0jdSsXixzXJTYcz+beButcgwA5
	vX60k2AF4yZoQLOXQ0jhuYJyIF8o3LjsfSrm659Rdi4NWCdKxTey3z1NVgXi3F7B/N+JEMG1FaH
	i5spDcykW4wkho6QTcLnGjUu3Tag6t02HvxaIiH1gDqL7FZu6hXzmCvjzlv//51SIegr77bdrwR
	Vzat/mEOJDLlrN/hjeg7Ss0BuxoSkF7wdAT0xU2J7E39LDu0S9BTddnNsvNdK3fWfoVxl1hm0m7
	WSAmiE9DoD4V+9PIycip45MXyHQNdMm3tV2MYgTO3D834hrEBXoyFAdE1tDzfyS/CdneedPzzR0
	NFn2pvYdrDlmexVGA==
X-Received: by 2002:a05:6a00:4f85:b0:848:67ca:bfd with SMTP id d2e1a72fcca58-86b318fd2e4mr17232792b3a.16.1789294310240;
        Sun, 13 Sep 2026 03:11:50 -0700 (PDT)
Received: from thangnn-ASUS.. ([2405:4802:1d38:5c70:f608:4e94:6df6:c8b4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86b29cbb0d3sm3141397b3a.42.2026.09.13.03.11.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2026 03:11:49 -0700 (PDT)
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
Date: Sun, 13 Sep 2026 17:11:42 +0700
Message-ID: <20260913101142.28802-1-ngocthang2710.1999@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7D6DB14000E
X-Stat-Signature: 9878akc4819jkfd649gafjx9hibchexo
X-HE-Tag: 1789294311-775481
X-HE-Meta: U2FsdGVkX1+6qX1rmFkKodODTEopU7/EGIGIbPsjQXLDLMaFOqN+M1xLJNN9UxQ3d84rL93MS7GwW1T7S6sLVKm0QllPEMkhZk15gZTg3BF64KdVhx12CigTSYG9USPZx1/XawTv1f9bt6dFlalSFkQfQVvU8gYkBSiJrJ0h6MDtHZm+Yd3o4Bey3NGvtLxR9BG8rsPz0tAU8nxOLpyZZ9MTrDhd26lXl57ee0Ut5z46zm036CMTciWymQTB2nAcyU0oXY+eyjNNCD+W9Kpg9Y5cO4aLoo0OZbp4Hct08gyZ7rkGO3sqnDah+a4HptkroXByPGkTVB+KiPjz47WxPXNyVJhOwb7CMjqBNz8w5LP1n6rsi9R/J9MNgGro2xQ0ZjR1mnckxORNqR5z0RTUOoJLot+3JrAgUpAgWKiFXwET0XZV+BurM1qtJJVsCNDP3tVtnO2B8UASW6PL/Er8VluB+uROhwJ4IFGs/hmVFaqMsphS3GWcwmvL2FuTvLU70pq+La33IWvp0LKFzPnyhZ6MqTKg2jxCSdrqr+E+hazQPh5gInTABeKUGmWwn1wbjohC4Ww4Dddx+la9ji1hKrKOXQYlRyORBeolYRlQ6wwuVFvp5ilGUZYdn/6oLx80MtTFmntvQpN8b7iB/TG2hxuvHClCsCnsZCTCkvrHE+5culFJQYIJuPQ8DBuYepV7Icw0N+nPvA8HJ+fzts/XI/aE3SP76rCflD1vsfb/4Lu+1sYNgR1FNo3pv9ZlH3XkJ2ifLF7sz2hcwQplA0aJLzIBADJRNLgTEJwObiJY7zja7n2hAntSQzVPPEf1QR1DeYyEAxMvgH7H/PHSKmSJBqVE28FU4X95sx5VAk3pJQxv+w1e8/vgdobIOo9WDyPaiOJrPuTNKMCOOyz5s2bOa5Dmcgf8q47Qzcj0Nx5iFCsp/ZEowFFSze4hgffg1iIENRdiJ+dm3pVkZfM12zL
 ylts6vRs
 j/B33qiN889vDNvJqGuatKiKakwmuirXQdpTNFUE2oDxkkGDnX2b6TqCeewWEtF2S+icG39OvT54+3ouVTzHBu6Xqmzl+xpQbvboEuVA9f+eCIn6EjK7xN5zFDZ42nb7z4TVhqaxb5XYq6igGT/yUhxXvHfUyFpLpZJT1RVPdfBCgA62lX571oCX/PujZfpVuBnlLRuuEOp3t1XO/FMyWHx00iNTA+ouMAMwzdXm/PN00/SJOxl/z3rBIGBExt2xZaCWrgJwnBLwo4V15eAHDq7rg/SvtwqbZZhrir/v4uIOpKlNr7K5Xx+UXNKuc2YChoj4fSKPDaHIAQUu3j9NpzDacTpyF9c7ke98tNKTZ0eqcps6FcK8tq60u6fXN5IBaT0QVA6JPwfbP/wpoJ9AV8gij+kuvrAg0+aptCUyFAMlQ7R0Oyp2kJt0cabQZ9u4tX3Nxx0hic578pHgty5UpLb8HXlh5KivN+9Pt2FlesgbZIWDNaLkwrYLnn8xM2RopgvAvmRmWfekR2tn5LPeehx1rGEqbopXL5Hq7vAxe1FaTLTSnHeLUqk6ThuoCgoK7mBj0bU9c5J9xwYaL4dSfsZqok4qw20J4nypWzW/S8wtoWrnvFFMrZPxW5lMdlBAsvmso2TVVfB2NYlNsOAsVTtnpqU7ehLLUDD1k
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


