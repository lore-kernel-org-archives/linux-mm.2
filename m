Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACA25606A324
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 11:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DgkW4o/z
Received: by kanga.kvack.org (Postfix)
	id DD4616B05C1; Wed, 11 Nov 2026 06:35:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5D356B05C2; Wed, 11 Nov 2026 06:35:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4D326B05C3; Wed, 11 Nov 2026 06:35:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A262C6B05C1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:35:47 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 45387A0283
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:35:47 +0000 (UTC)
X-FDA: 85422633534.17.818459E
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf17.hostedemail.com (Postfix) with ESMTP id 76AA140003
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:35:45 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="DgkW4o/z";
	spf=pass (imf17.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794396945;
	b=UrXAVy+KjzJp/NVEexrbmWITMxhbwQ/QA6uU75YFmPdolx7maLxz/vgU1frlRm5GEU8rof
	YIThwz8CdSMoUkgEF4piQ0iU2r/D0lKZ7V5+/eAtKT6wJnZQ6q157eZswOH1mu2uTUKSgf
	Tzc+dgaU1fcze3nLDMQqPSh1mTsR6/s=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="DgkW4o/z";
	spf=pass (imf17.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794396945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qjgu9e/u2YP2/CdjTUrK3P/cx+QqzByH6M6hocqEYA4=;
	b=Kco1K76AOMRD8mS5bS+zQ1Rjgn/8djdWvkpwehNowJx0yvDkEwxTrdIokQiS2ELwH/kLpa
	5Ch/2cST8UV8sFgUIgNgxR2agMe2/aCKPuCMme5jAKqIh5DHKvzUU7j/ZtKfY7FAxOyXzE
	+AJiBb07bnxDKrRdmHi4/u7vqJ3OkL4=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-48e47347279so1977811f8f.1
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:35:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794396944; x=1795001744; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Qjgu9e/u2YP2/CdjTUrK3P/cx+QqzByH6M6hocqEYA4=;
        b=DgkW4o/zD51bwybpljPGfRIOElDT6fg8hxR4E3rzPwLeNTeahiborQJndaAKp31All
         6/eLti0O85deFueCsoZ/XKdsmf2abHGCV9XBC7tvTcHVgpQNJQ8Z4o5qf727eU/EV8ss
         fK5VzbN1zM4TBfGOPdSVQAc4DBEaOC9ALxy6QKn3PMInXSxM0dpktCphVCnRBTSgq2qS
         hNy9CtqLhYp3jSk1UAyoWRMNxEsiCIp8VpjuRQ33YZt0T3a8uXVWqx95RT0GryvpFdLE
         Jdyoj/tqxcKKsGbs/yH7sGa1dLDSXwMZz+fr0xlJohFKOZeUYobeXhDuy5FSFDfZsP9G
         2ePQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794396944; x=1795001744;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Qjgu9e/u2YP2/CdjTUrK3P/cx+QqzByH6M6hocqEYA4=;
        b=l0y9JkzSVEODs3k3YnepMs5qWO1sljfplcfeejIed7i4rIDUt8RRxSyJRla5cZzfYK
         a/Ym98erIrQz962JrguP4VBOnSheJ4eE7sfk3WqvucaB9FK1X0cX3B5cvbTB9P9fIkj5
         dM+3XF7eJ0EkcGpC+DqSNmCLDQZb79RE5vd8Q6d4to1fO34IFQA7A7uIRteuWTy7HYcB
         r7fhUpJqpnUVXccG9RM5UIlriF7wVCSz6n5eakDhgjQIkVPyIvcYODkZcyoFoWaKQ0wd
         3kDYiUAoCzpm+B0ZcDqgkeA3DC7hXgRV2aVcfxGQROtqNjFAjokIU/u/lX6k6Tya1h/e
         8YOA==
X-Forwarded-Encrypted: i=1; AL+hErF8G0TyiHIDuAyf30nXkun9BChsLs8P41HWq9lFqaIuvqUT7ZSsw+1FIUceq4RHFN48T/2NqGrKMg==@kvack.org
X-Gm-Message-State: APuU4Z93l8KR3lyfRoyiHoQK3DoogTMezZ1xYgub2DPnrMfVRJi8YaNW
	0ktzswzNHf27arCFBeZYQwgMv4Fej07Ao6RcslSzvONKu5VrTHzOyab2
X-Gm-Gg: AYBFou31m0P9Q6esOxlq7Mq90CqVACsH+p9Xz10PPLTG9gETVkZvKtxQNj2fQbRplSN
	diuNTpN795E51C664mIWkUMn7iP8M9HBZfseYD5btpVcMsN8P394z6nuOJH2Jw5fLAxgrl40Eia
	ZpKdJOzyAZ0WgODdlNPFztcnHNOUvrXjTH5vf/cZ/b9+mehUBwQDq7i/cnMwIlxvMYvqne/ckYJ
	6aO+mjMRW4zTBCWQs47R2xO/mtz1cmJAOpA7l62+AhNBWbK0QtJuHKYfoys+4YrDFm6pzg0e0J4
	GDrr9qhjxHYpSMKVqIHR5shqe6Rrvbe16RWhFmHwkHd2uA4wlFolLg7JHB2JSNO8Ea0gEIyRbhq
	4dl6oI5c7/PDrWd79Zm79fc4uW3a8l71bXk33mm+fVR059zFxvOHdQopfky24WsazCcEf0L/UsQ
	qhV+d1PVTLdPa27VsFG7ZBf5UYFkVRQ5V3zym92W7tg1+0m+fXaFUqfkrZ6fEOsX1QsCjInPs7A
	gFOL9zYwen/mlJmVC6WFE8UR0yt8Psx9hBzyxWcSC5nbOb8rAulANzqIauvatdzkPIGpBV/VGVK
	pLOyDCYpnuMDoFI=
X-Received: by 2002:a05:6000:2512:b0:48e:17d1:16c9 with SMTP id ffacd0b85a97d-499c86a0bcamr3562940f8f.40.1794396943825;
        Wed, 11 Nov 2026 03:35:43 -0800 (PST)
Received: from nobara ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-498365cbbe5sm11598683f8f.42.2026.11.11.03.35.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 03:35:43 -0800 (PST)
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
To: David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Rik van Riel <riel@surriel.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Joanne Koong <joannelkoong@gmail.com>,
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Subject: [RFC PATCH 1/2] mm/huge_memory: check split_underused_thp in the caller of deferred_split_folio()
Date: Wed, 11 Nov 2026 12:31:37 +0100
Message-ID: <20261111113535.330078-2-azpijr@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261111113535.330078-1-azpijr@gmail.com>
References: <20261111113535.330078-1-azpijr@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qeh36uxhtfequ1ts8f8ce5tf9o8u6438
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 76AA140003
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794396945-499916
X-HE-Meta: U2FsdGVkX1/GEpJ7bOf4kT1ok9C495BvPBizlkvN0PBKygSf+sj+IrF0azqq3+blWRM8P2Wq+VOj9+Zz4pSLXQs5f9sgTg9OkIPdOZ6eWd5tiG5HO4lTl1soP4tLhN00/c4iXlUSsFD7x7vHP1PrUyYpebW4I/hrkPogME92mx81KFL9XVOng/W+wSyv0ZuKFpvmMy2jJrtbOQHlaZqzgTEQ1SI+2L5fl0Ls2UlPa96PEi/DZ2b+PmZV2+6iM5N+dSh//8Ve3HnnpBygScDmmxVvu1DT1htkShF/I7XyZW+zwu4AOIYw1cKkW5KMaHU5B+Qn8T+f8xc2QcvmSGXAHF4KtxG1zhnVflFVvl9z1dn+/0iy3gIVocb4E5S/3eIge7vMrQihqrLnLE4w6ActkCbGl/VTthU7c/Q+JI+ug5CxnzdwbdZFQr4GLKSu8wPOGtVCGsrvTTeshC8hBxz9l/JuTbGP+A4bb2nwbz/u7uSMZTzGA3CA7gWZbaFvuEpn8UdRgv8087b/Y0GI3Aa5Bbu0AK++012MYGW631hN0QIpRwEzmI0ESEFHGV/ZDXi4UzpChdGAqK9X2h+uwub4zPRDvJLD6Vyz+ZkBDDp/g+AtAcwmZIbrzAT5WKDggKaYuT3dHULga9OupTnQdxv0O8PGuAIjbtH5VezhjtdghmTO4wFBAH9yNLCodrjBq+mXu26NdteJHMzgCSEL2A7+stW0s83pi939McfjYwF2aFa7v6Hh0w+p5fBn54b3Yrlg3+Z0EArWJS59EoQ7xSx4TTHvW74oGy+JdzyCBny+LbNkFK7PmSPAbShNexP2V4WHzC87VIgQ1yd4+yxsUls7RfrQ+dewVqBUnwh7LYRIv65EFFz18YE/Pqgk36VNhkOWC0jc88R6tibaFrhKxUtNWIwq1FbkV1nGgAqjxDmmjxivrRBWGVGhpL6Xt/1KF6JoSoEFJkYEIoE91mIY9eB
 nBJ9F/ki
 1A5kudSifZYDDh2KUGr4fYWf68v0GeWuhSyckutyrJvdZM7tIGkY4V3eCaNW9O2FyAZF0FOB6yZmXCEFuGpDA84mN+hBaFa9k6arjEvTwF12R/mzDcvB+W3OYaHoORE0K928EsXPH2MuIhKQ5lTdxrIJTV6dY5B4vOWMxMAGd3xshbWUsSLZMuW4gSh52Xc1CCeaR4S7E99ZpKLBSMOayipqnN6KnwuJvxnC0c3dPl40UjcD0qbj4r2NuzBBpWwXD1SrKmSM7sM0y06Y0VD6L8FZpdGxxEzFukazTwWEE4zOj+IPagrkpsxIyYNCBMAtSyub3H0GkoyXRNdqju0BZ17siZzQmFIDYvkb3rs8A0GOkwUmKrd0GOxT64nEw099CIEmmpqsbhPv0pYNm8WYiXRAMQbQZRlXUg/VaWlftItd8Fz4M451yztAGP/eNuGRt2t9VNAs3JmKTQT8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

deferred_split_folio() ignores folios that aren't partially mapped when
shrink_underused is off. map_anon_folio_pmd_nopf() is the only caller
that always passes false, so move the check there. The next patch queues
folios without PG_partially_mapped for another reason.

migrate_folio_move() passes false when the source was queued without the
flag, and now requeues the destination even if shrink_underused was
turned off in the meantime.

Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
---
 mm/huge_memory.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 0d589be136d2..8c4a69c797ed 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1403,7 +1403,8 @@ void map_anon_folio_pmd_nopf(struct folio *folio, pmd_t *pmd,
 	folio_add_lru_vma(folio, vma);
 	set_pmd_at(vma->vm_mm, haddr, pmd, entry);
 	update_mmu_cache_pmd(vma, haddr, pmd);
-	deferred_split_folio(folio, false);
+	if (split_underused_thp)
+		deferred_split_folio(folio, false);
 }
 
 static void map_anon_folio_pmd_pf(struct folio *folio, pmd_t *pmd,
@@ -4631,9 +4632,6 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
 	if (folio_order(folio) <= 1)
 		return;
 
-	if (!partially_mapped && !split_underused_thp)
-		return;
-
 	/*
 	 * Exclude swapcache: originally to avoid a corrupt deferred split
 	 * queue. Nowadays that is fully prevented by __memcg1_swapout();
-- 
2.56.0


