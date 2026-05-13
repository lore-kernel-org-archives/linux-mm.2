Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 685B8CD4F24
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:08:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D20116B00A9; Wed, 13 May 2026 09:08:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF7EF6B00AB; Wed, 13 May 2026 09:08:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE6A96B00AC; Wed, 13 May 2026 09:08:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AC6966B00A9
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:08:42 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6FCCE1C066D
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:08:42 +0000 (UTC)
X-FDA: 84762426084.15.C7F5A95
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf12.hostedemail.com (Postfix) with ESMTP id 61C4540002
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:08:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Bz9r6HOi;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf12.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778677720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ryF8YQ2n+wDSXZLLv2wjofP7Z1dSt9c7zUzJLRCYPQ4=;
	b=2CJixzsrFSYdW9cVHmjaemJjHbJJBQLfc5qmg50GLaD+BMBkRAFEzLL7gyfsE3hamow8V1
	Raz54NIDuZjAlApdVqYDYcM/vuounbof2S9Pd5seyqxqkaRVMosgMNfhVr+DoRxUM608VD
	pS/hKe5/HYKVcQIqwCvnAZPNXop+Pko=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778677720; a=rsa-sha256;
	cv=none;
	b=t7VzuD/OyT6otLWD/ifMsR32UFbMpSpkTJtqm5U45NRsDL0ka2HDrPqDGHk5RuQ0NXT81x
	1ROGMSqOQdOOC1CKnEpil7+Jy3yDvvB0zT69E5keTfxt7e+LypO4sr1VYxtAx4Np/2fEb0
	TGX5hcQGVOCMARYtzJ5V9aatzJX0g88=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Bz9r6HOi;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf12.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2babfd18435so34490505ad.1
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778677719; x=1779282519; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ryF8YQ2n+wDSXZLLv2wjofP7Z1dSt9c7zUzJLRCYPQ4=;
        b=Bz9r6HOiEv5OBK09kn3zeT2dSMKIUyr6R8GUwK41N2e8NHkWOPsMrJ85fW1DAFCFL2
         M4k/X9gptmXNVxuuFqzykaE1PWROt0k0cvVibxfUs8ngVc5SBnsUuQ8V4n5JUMsig7w6
         Kmwl1QQz8g4c0ssjmy35CrvvBzDZkMPwd0P68WYsgpStc82Of3Cygcj3CJFNEqckF7rN
         BlFshx63QIl1QCAyC0tSQinT47oB/QvWNNYjJ7OKaSS6Qt+dK/ZNOh9xaHVmELFD6YqA
         avtIB6iSp6ytlWnY+9b8IvikGTgwNF3yOrGzru5ZhkBZvGKCR4EYAZq4v64bX/EQOqAX
         03Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778677719; x=1779282519;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ryF8YQ2n+wDSXZLLv2wjofP7Z1dSt9c7zUzJLRCYPQ4=;
        b=XPv81UVQOc5SiwZ8UAMlhL/Wer0jZm+3i3psfq2XhDIvwqTT1XravojVR/XAoilBUJ
         Idmct+fzNX8Yas6DYXV0MoAjeHVmpYXKrHGKdrIKgAU7Ie3b92TdFxXmUwFsIsyguTpP
         pdztPCYsBgskwsJN/yyjw6SDNr2GpjJM8ER/TT3oiursY4+rlM61LXjsNZiz0lENUaon
         JFS7oZ9faBwD1bejQG9h+VcwwnLsE1dmjjET8WU5SATKMme3X6U1J1R6yI7vcJt3gRRc
         SAQmJgr3GbUSoeNrVAXVskpUMEgl2VKHbWQPx5rDBJ7hlLAxeiAmvWMDhqlDNRYFY80j
         uv8w==
X-Forwarded-Encrypted: i=1; AFNElJ+qY5706KKjWQYF583UV41LKRNYX0XrnY3OZ+GuFCEvr9l0Xsxrov1Y1sGM2AKx+GtXhblyotICGA==@kvack.org
X-Gm-Message-State: AOJu0Yx44OFm25HYZBWgabc2rjD9GrFptC0IsKfIXO7VrQpp496OlHP8
	2DBuOv78QjBzKU+RRcmkEm9hobBWq/Z60BvD5Y6Cd9Evu0DG2/BqXa1LBWQsZti0Qhk=
X-Gm-Gg: Acq92OG3c+ctP0MQCvHFMAHbl69PvJ8YgPvfyo+lpB0wS1mf5xordJFsMwFx44l3IV6
	QQmn3B1sv/R9Lj3ug54dbPkkziM0QA0tljVy4/sEfL6Stg/SiZa7qJpC63/hDe1hIeM5YrIPRDE
	NepxHNBXBj9DJ0pGzfj37yb97v2DSYJ92ncZaPwG0NYkhVJHD5ZYsds5ADhRFdc94HxUAf1XEUs
	RninB9rqBa/Gov6bd7Y/ZkTf4sdngsUaPh75f2PlLT/jfzD+EJCI6n1X7V9aGcyTkGKoE3W4hHw
	3dXSruvk52nDarj4l62nJGAOvUQfTevMWiUbIVJh8bs0DEZga3qrJusdZzZn+L1ZL8NndIkSOa3
	2O386FQ1D+Zo1pPvmvpohGPgUT2l0CxUQZSNSK7xlBogGEMNGw8AJ9N5Nkg+cPTAk1/AH/CvNQt
	1MO8J9V0s7sM5YlUDRIN5lTDfJxsNTT5VqQbREhkWn3FpCIZtf4KD7nmR9tGw=
X-Received: by 2002:a17:902:8601:b0:2ba:839e:15cb with SMTP id d9443c01a7336-2bd275cd01amr24527775ad.27.1778677718942;
        Wed, 13 May 2026 06:08:38 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e90854sm166641925ad.66.2026.05.13.06.08.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:08:38 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Frank van der Linden <fvdl@google.com>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 12/69] mm/hugetlb_cma: Validate hugetlb CMA range by zone at reserve time
Date: Wed, 13 May 2026 21:04:40 +0800
Message-ID: <20260513130542.35604-13-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513130542.35604-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 61C4540002
X-Stat-Signature: 8kjs9aj854yj8wm3n57hdkak6foasfqg
X-Rspam-User: 
X-HE-Tag: 1778677720-332405
X-HE-Meta: U2FsdGVkX1/upXnolV21JpF0jLhnFEEj/jCurClhHf1N643AxBlgMBDABpGbtaBO2MwSsA+ZrnEk+58b2/o+lnGzg+ZZSYPVT4hHZLw9nvjD58xACWIvjs4tAM72cBBoqkrLxIqHVHAu7YjA49wZXpH1Vd4UjIm52n9JpWjQidQbm/S82/LLPOlgM3H+YOk87/aHVomv7an1T5IbPtPa79dMvNwe2L7VE5Ih/Usn74V0j6S8za92N+oHbPLJZv7tRXWnVTyBm29l0MwWsoh89v3aVSBqYOrxbjsYiy7X3uF2LoBPv95oVRy2Tfz0X65MUeAKPgy8Jph/9BpTzHZ2nebmGfo0/EonvQeSHGYmVUfg+3MJX0nBDL389k5G9nipZ8R3TYhJVn8E0zcHWeV9DdERbZ3DqqWkPVU7QQazQg9jiM9GcmDzu5KZ6uJc980qG45TnlXrhKAKN78obm8VGeGZBhZvSgaOlD658cB+waWDLdC8t5aweT5CQTnv4QF1vhoBmh7ozzI0MdvXnA3Yac4kNmXkbFMH5KbM9jc/m42x8hgptw829SlhDZ7jEc8R1aq6veMbzZGTqMjYiDxMtKrnHaM/0hTLbJSStRGJw2X6/Ok/UKQzrHvAHRzaBx1FYfI/hrA6vTCI0ge6o8dzJvut78bRSZQm5LIMa4s/1ExO0oSti0SsXjcvgo7g5hShnScP1hN1PQLxDL5wrYduJ/XWEgjseR6o27Qd1BTKvDiMOSoT++ohPuNbk4duz5K2cldAodGGX4MLlx2+qp0FyUZZEgv5QfSIvPr4g1TcvhqHIZBPOljbksykfWCZmwssm9ludhSqE1YQAG+9csIJcOD6UpHmF5ugxdmbITS+J4gBj+tiFuay/xwz+AYZQ3AcV4Wqq+3ne76udSJ9oy2iimd64D88kk3iimfyUEH6IOdcqJUq8phTOVyJePFO/2Cyn0+RjRMEllA5p4r7sMo
 1n0DE+hJ
 gDzMGTiY7bPEv1oDkZzQmLbl78qGk0UUZfWeUbbNaVzdkv10Oql5AcJaxsWLAmINTTQeQEeQg/BTEHNR+AYpvn6RvhOcoZNZBSLEbQcUJxW8TBbVWCLGw8oadZa/AVRUmkzxLpHXnGJjcv0dwZPU8wS1u5lRcXw+O4oWZzM1Vu2jrDvM5E5fFMG6y6laLDU+TioAUDlFP+Vk7NUcXfLvysfyAmwIJy0uvluGVJiwTOS87mfRfHsIHr3sDgrhiItQU617q7oEdo5Jp5gRD94rW+ZtDAY/6rrWNxZktyJB58I9wjddz9cYUg1o107QocZhI1LCG1uQHHfbS4tdox4OCx7VKKSOMYmx2GNH4y+6if1T9VoiZJUFJ+K17lbC0P2nIggSDBts/0/yo/GBjqLvUNhewsNhnzBOu1D/QUQbv6xn25mk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hugetlb CMA allocation currently has to cope with CMA areas that span
multiple zones.

Validate the reserved CMA range up front in hugetlb_cma_reserve() so
later hugetlb CMA allocations can assume a zone-consistent area.

Also drop the pfn_valid() check from cma_validate_zones(). mem_section
is not fully initialized at this point, so the check can trigger false
warnings. Keep the sanity check in cma_activate_area() instead.

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
v1->v2:
- Update the warning message for zone validation failures
- Add Acked-by from Mike Rapoport
---
 mm/cma.c         | 3 ++-
 mm/hugetlb_cma.c | 6 ++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/cma.c b/mm/cma.c
index c7ca567f4c5c..0369f04c7ba5 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -126,7 +126,6 @@ bool cma_validate_zones(struct cma *cma)
 		 * to be in the same zone. Simplify by forcing the entire
 		 * CMA resv range to be in the same zone.
 		 */
-		WARN_ON_ONCE(!pfn_valid(base_pfn));
 		if (pfn_range_intersects_zones(cma->nid, base_pfn, cmr->count)) {
 			set_bit(CMA_ZONES_INVALID, &cma->flags);
 			return false;
@@ -165,6 +164,8 @@ static void __init cma_activate_area(struct cma *cma)
 			bitmap_set(cmr->bitmap, 0, bitmap_count);
 		}
 
+		WARN_ON_ONCE(!pfn_valid(cmr->base_pfn));
+
 		for (pfn = early_pfn[r]; pfn < cmr->base_pfn + cmr->count;
 		     pfn += pageblock_nr_pages)
 			init_cma_reserved_pageblock(pfn_to_page(pfn));
diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index 7693ccefd0c6..57a7b3acc758 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -234,9 +234,11 @@ void __init hugetlb_cma_reserve(void)
 		res = cma_declare_contiguous_multi(size, PAGE_SIZE << order,
 					HUGETLB_PAGE_ORDER, name,
 					&hugetlb_cma[nid], nid);
-		if (res) {
-			pr_warn("hugetlb_cma: reservation failed: err %d, node %d",
+		if (res || !cma_validate_zones(hugetlb_cma[nid])) {
+			pr_warn("hugetlb_cma: %s: err %d, node %d\n",
+				res ? "reservation failed" : "reserved area spans zones",
 				res, nid);
+			hugetlb_cma[nid] = NULL;
 			continue;
 		}
 
-- 
2.54.0


