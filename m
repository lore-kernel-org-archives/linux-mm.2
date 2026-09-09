Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAAEDC79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 13:35:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF6B76B00A2; Wed,  9 Sep 2026 09:35:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCDDD6B00A3; Wed,  9 Sep 2026 09:35:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0B7F6B00A4; Wed,  9 Sep 2026 09:35:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A37036B00A2
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:35:11 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 38DB116019C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:35:11 +0000 (UTC)
X-FDA: 85194320022.13.94B3671
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 62EC91A0006
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:35:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JUrQET7B;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JUrQET7B;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788960909;
	b=yU7t5BGvMFhUGroIqvm79JWmawijvIPTUvRM3xaG3DuJH6Uj/8bOG9e9O3/NVvC44zudp6
	2YKBwz8QbnkBZ+7uZftC5ug5OzpMMHhIWeROBf8qrPOO113fRYf4ZO+PCWh/WaJuyZV3u4
	CyJmB7IDg9x6fOidplCZ0w7LlA1GvAo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788960909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L2v3o67HNQ9aSFqTXVM1jpMn5NU+1i04xE3R5tvtAw4=;
	b=JK+cTpcQlP7hwloLAKwZrvmPVelwpSm1+onSY47/X4a4Xu74y99wvHa72O/ccrkwU13bNk
	3IRbdo9D29b6iNt6L11X7kHuwqlqfQ2Ew+a2qDUDxoWzs4/b7tYjp57oWoz2kfzf0YbdPw
	qnUlpqW6UsM9HbUSblz/aENbMt3cUCI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 86093423CD;
	Wed,  9 Sep 2026 13:35:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87FCA1F00A3D;
	Wed,  9 Sep 2026 13:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788960908;
	bh=L2v3o67HNQ9aSFqTXVM1jpMn5NU+1i04xE3R5tvtAw4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=JUrQET7Bpep1u4rw0MKmhd9cfkeICsEyAERFh9SEB3R3M+csy30qdNXfG/4GEdFoe
	 ylt75rtuHgs5B902EEQK9MUSQwl8Jvgpfu87L8ifQaEXVvj2lWEQ2sNq5st4BeYXO6
	 7AFVLyGoIDL0OR6RE1ecN3f0N7liMpHacZoQ20+8IP0J88ZyM2xcWbh3R8Ek+fVCrQ
	 /IOC4FEn+4dlR9VjLohiYugge0+bl+TbMqGUOgEt+goOdwybo2LG51/wecTCLBMqbX
	 UKc1z3AWRQcg9gA+oBnjs1wQEvXxuzHAsQJ5bIom6NyHIAfadkKPvZyItRyn/yduu5
	 x32FaRXVOo9OQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 09 Sep 2026 15:33:01 +0200
Subject: [PATCH 08/12] mm/sparse: move __highest_used_section_nr handling
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260909-b4-sparsemem_cleanups-v1-8-008fc8d579fe@kernel.org>
References: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
In-Reply-To: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Oscar Salvador <osalvador@suse.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-fsdevel@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2321; i=david@kernel.org;
 h=from:subject:message-id; bh=ifd00cyRI1HuxOcc2xxWxJxbUrmoY4ieu/5tTBcNKZc=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIWJhj/9Ny1KDloarDGVa1TGt0r2+dIpR+efCbvRNIKL
 bfLL/nlOkpZGMQ4GGTFFFmCgu8bvHy5rrbajY8ZZg4rE8gQBi5OAZhI7jxGhvXvpFgXTC59Y6Tj
 FHXihcBi00OJWlFqnZdOrNI6IaKxpoSR4c/7iSYTvC+Glr0wsct6bm6/8hnnuY4O6bVr31hNFeG
 fygkA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Queue-Id: 62EC91A0006
X-Stat-Signature: 5zxq7jmqmsa536mrh3johusqexmcrmpm
X-Rspamd-Server: rspam01
X-HE-Tag: 1788960909-461917
X-HE-Meta: U2FsdGVkX19W3UK9uwSQIB4PJNH/VCQvdZVoPc+rAd/QMUmPC/hxzmL2MBQ1yoE6VRGchl4uJIdah1CwhtAQO0bxoshS5ozgckDXuNz2rkevzB8onq/lgvOK2ZTnMsf6/ejJ+RzsUBdGNiMRyBtvrWaWP4y3oT+Hnq875dDCK2/B1REy/5noWLUwv2Gd445TMw2YnPnciudscZuvACd6fMlY5bB83YgYp7tLdY34T0o1rT8QkxaPxZjDzb8QUx0FsgZQrOZ049LUhPXkGCfHWvLktb1VmYLCsLnfukT1+eszlCvdK18U/TgMXNQht+EyZQT0m8iktEiJuUPhkucxscKbDo3aWuovmcyEkpJTuiMMEv6x6WGL66enOlFQfrpqFrzxhdzZJQaQsOFqT1OBbhQJyok+Tp5ZhtuEb6QgyNJFKxLDQ+EiCL8+33WcDMnUFkiagT18+zpAa68+UyiNzGYgZ2jNCW1ntW1PJsWvs6ukW+pp3LRAUByTpwNDaMj8v+iByToTs/Pw8OC+tsLyM6ct6AlvFFT0vbgTVhKirsTpIMARQVMc99AwrUQNOeQm5Oez94fALoCspQkprUfBvW8MpTrQMlODO/P3Hhhgqa25E6Te+9IkrqqtCgvYp+9cVkT4Zvo2SUpEV6nRPyQNm5xUAyhcinsK4qlLfbDtMj0N3OJE0hSWwetXYao9cj9XuALhFRIeOkK4qUlJdh0bOoM6CtkdEdWQdNGQDypij2y88HoMirtgKmLgpCIlXKW5aXAw7y+5C/4v2NrIuFBxOxWxNlbi6vXSHIHVqedj0A4eks1yksHzVzRBnFGfyra6oRhFcLnpaYLFBROMolHI0AUOAcSUnCrZxqu1+fRkxDfmVXhLWdPnMgnTmqEKqfY+G8ZmVqO5KZtPvcWc8jXkWrHgNybvbxAxkNu81jf2kywUBSRcKz/rF3FRMKbt0XOI8IrBMJzB7HxGmF/1flP
 JkizDOqT
 kd2wgTNVfs6J7cthtOYe2rLHMGYjINER/C+1nrBdS4JxKX+tmL0/jgq23unR62gDc25iQqMZoEi0m3b7/7TxQlVRBhou+pC6E6N0eYHvaSe3p3l+6StddGWFbHnRIz06ZNbJG5oqHEUssfZmFBzhIXayiRIinc3YQT/bvvTOmbhC9AUdp0k0IsYD7EpfpuAAUnYjHsZ3Yljrwhx2cX1Moaitkgep2+X2hCwgTSLTepIi7tTtO/b5+2s/jYl9KzaFdehOH56TmGO/IGRh/TyoZrqFd4lsLrrzAKnVY5tJn+Rlq8rGsNDPt4hKCj2pva18d562fu+QNexGUVEI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's move it to sparse_init_one_section(). However, to keep early
boot processing working, we also have to initialize it in
sparse_sections_init().

Should we use READ_ONCE/WRITE_ONCE with __highest_used_section_nr?
Probably, something for another day.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/sparse.c | 5 +++--
 mm/sparse.h | 6 +++---
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/mm/sparse.c b/mm/sparse.c
index 2b41ae36f20b8..2d0f2db34f4cf 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -177,7 +177,7 @@ static inline unsigned long first_present_section_nr(void)
 
 void __init sparse_sections_init(void)
 {
-	unsigned long pfn, start_pfn, end_pfn;
+	unsigned long pfn, start_pfn, end_pfn, section_nr;
 	int i, nid;
 
 	sparse_extreme_init();
@@ -187,9 +187,9 @@ void __init sparse_sections_init(void)
 		mminit_validate_memmodel_limits(&start_pfn, &end_pfn);
 
 		for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
-			unsigned long section_nr = pfn_to_section_nr(pfn);
 			struct mem_section *ms;
 
+			section_nr = pfn_to_section_nr(pfn);
 			sparse_index_init(section_nr, nid);
 			ms = __nr_to_section(section_nr);
 			if (ms->section_mem_map)
@@ -201,6 +201,7 @@ void __init sparse_sections_init(void)
 			__section_mark_present(ms, section_nr);
 		}
 	}
+	__highest_used_section_nr = section_nr;
 }
 
 #ifndef CONFIG_SPARSEMEM_VMEMMAP
diff --git a/mm/sparse.h b/mm/sparse.h
index 7c5d82ceb7142..a3af4967fd5c5 100644
--- a/mm/sparse.h
+++ b/mm/sparse.h
@@ -97,6 +97,9 @@ static inline void sparse_init_one_section(struct mem_section *ms,
 
 	BUILD_BUG_ON(SECTION_MAP_LAST_BIT > PFN_SECTION_SHIFT);
 
+	if (section_nr > __highest_used_section_nr)
+		__highest_used_section_nr = section_nr;
+
 	/*
 	 * We encode the start PFN of the section into the mem_map such that
 	 * page_to_pfn() on !CONFIG_SPARSEMEM_VMEMMAP can simply subtract it
@@ -114,9 +117,6 @@ static inline void sparse_init_one_section(struct mem_section *ms,
 static inline void __section_mark_present(struct mem_section *ms,
 		unsigned long section_nr)
 {
-	if (section_nr > __highest_used_section_nr)
-		__highest_used_section_nr = section_nr;
-
 	ms->section_mem_map |= SECTION_MARKED_PRESENT;
 }
 

-- 
2.43.0


