Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E571ACD5BAF
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 06:27:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3ECF6B0093; Fri, 22 May 2026 02:27:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEF026B0095; Fri, 22 May 2026 02:27:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDDF16B0096; Fri, 22 May 2026 02:27:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B94326B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 02:27:10 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4BDF1C1749
	for <linux-mm@kvack.org>; Fri, 22 May 2026 06:27:10 +0000 (UTC)
X-FDA: 84794073420.16.7FE0BE3
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1B89140004
	for <linux-mm@kvack.org>; Fri, 22 May 2026 06:27:07 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=XNjB5KWe;
	spf=pass (imf07.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779431228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=YdtJYhJK7/PxyZ+XkjgH1lwtc20KzI5A/QEO0gs3i1k=;
	b=xN4ZLovK2M4Piro7r6sskzpiLqieUTGUyt2sNJRRdm2w1PrSz8C0UlVcd0LKQtdouPh9dE
	NenLgQ+mn3OUJVKEquIzmoUCUBK09KQ6u+j4pr0XsGz1UyhxQrhTEe6PaORGXhLcDcOUOf
	c41+UbqJYrrlp79wR2CCTYKmr0foxfk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=XNjB5KWe;
	spf=pass (imf07.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779431228; a=rsa-sha256;
	cv=none;
	b=Uc23j4h7vLK+SsCQcaqsxscI++e+AaRENZX4lQ/vTVrCGtX8q7QHmUX8YfmZtyO1hYsc5e
	9eG+18/9bwNSIHgXrRk3epDgVV27AwAghzIeyH0z0cIykJMwYhoQMi354uI4R+jlFdAy3A
	NiLgH82ZJfuhcXQKcsYXLv1AngylsjA=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2be1dd4af34so54681635ad.1
        for <linux-mm@kvack.org>; Thu, 21 May 2026 23:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1779431227; x=1780036027; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YdtJYhJK7/PxyZ+XkjgH1lwtc20KzI5A/QEO0gs3i1k=;
        b=XNjB5KWePNmbYnErljWXFDAF454aCZOIj+XafuRtHJa6RrnJuTgol1nFT9iE9wgw9k
         +e421br94ggiqE4N6SV9A0s7aDRNNnVObQ6ZOJQfmXewoyJch93k3Jg4eO8wOld1g7ek
         h9+/oO0YMh/RoXY8wkVzb5dJly7Y3OHObvJjIi5fDkQfh6BSsCPVDMEwFsTgV+V3nonO
         p+KnwsQLw2rqsO0Uav6NpctHdU2TxR9O8iWNooClooDrHGiNAw36hdAMYR23d2pWRrY4
         +7ol+ETKwR9CEw5AZrzdbOXOHEoPmHxbhNmb3ujZ+18L0Gwn0bUu74eHST6OF3uAzRsa
         rkAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779431227; x=1780036027;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YdtJYhJK7/PxyZ+XkjgH1lwtc20KzI5A/QEO0gs3i1k=;
        b=WXZW1L5/t9e+wDnj8dput/I56544QSCzHakAEbMOtjLr9/XP65IpJmETgT0TcWZb42
         Lmykq2RIWVKa5ES/sBasHn3wbcvPmn5Q2NDllksia1bYURcUjR5BfaJB4up4UAzMvvLL
         ZoPq4BO8mVcaVdJi5EOpisRrZ0bccE93/QVynIrbjtwUnu4TQHcSJmvkrXLAc5OkrmxA
         nhGH6m7jOm9IrvxAMPkLeZ/h9q3Oj3Y20u7eUPXgeCRCqSZAjgcdqtSvxPVM6u1+GA1I
         d0c81W0oOpUSjP560qKCmnXza8sGj+odrogBuOCtU+8Re0lwZohXqy8kbRPNBJW9+44Y
         8X1w==
X-Forwarded-Encrypted: i=1; AFNElJ/VSiC/ZxzPFfj1lPyv9466R8J14ms/tWbiZgq3/fG2vL5lGxftOiutaEW6AwdWEOH4eH6Ezj7deQ==@kvack.org
X-Gm-Message-State: AOJu0YxHwydZqpkyfiklDQ4lsQFxz043bX8CgqO+p5VGtZYv33hhvtp9
	vtWXKFdFnrkPhul/G2ZtDJPr1V0hKRFqukb8rHMG0Vr5k8F2VdPCZBTZPLgRP1fdjMb/uGl7VGz
	8M5ewaj5I9Q==
X-Gm-Gg: Acq92OFhlcCXPMZq3sNkN2YlcZvhTSxu1yDQAnMNFli4R0uMmZUV7jNaAvUQugBo5B4
	g9FmOL7ZvJeUlD4cbixpEM28AkcfZmbxminuAeUUIOpyY8R3+6V/DlRScoAaiQcCzCXkZbgsvHJ
	bepd3NkuRQAC5MIkOg5lLruTkeLs9JUwV0lz6Vss14rSEIBQIT6yHp7vHNfiH6exPYNCuWm8+0Q
	2s1Uyg1kgzOaKTJ9+MCCFwmUA6xEG3ZXVy9VlNcI9g//4MUr+NUbQi9WYkgF5JnYBi1OQKzdRA6
	tJpj7Exwf0g3O5ygwKKj2scvksriViEjjKia5jhu9bahDh+KkTsqAeqd4qdzPUQtweZob+a8s/s
	61JlSIuwlfHaig1dx/1Voj4qmg7CcOSnbAavn511Onryo7M/MB98j9sTxogW9GV/jVwEorVH6ap
	iaSB8DUSjidXLMwfOkyLg5i8stEo2ul3vDVnPOPo2AThY=
X-Received: by 2002:a17:903:3887:b0:2b2:ec46:dfd4 with SMTP id d9443c01a7336-2beb05e290dmr22751115ad.22.1779431226532;
        Thu, 21 May 2026 23:27:06 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.98])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb58ff106sm5045035ad.74.2026.05.21.23.27.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 23:27:06 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Frank van der Linden <fvdl@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	muchun.song@linux.dev
Subject: [PATCH] mm/cma: fix reserved page leak on activation failure
Date: Fri, 22 May 2026 14:26:58 +0800
Message-ID: <20260522062658.4095405-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rszx5edjr5xfwx8ehktx8x3s9k3qxpbh
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1B89140004
X-HE-Tag: 1779431227-652948
X-HE-Meta: U2FsdGVkX1/88GVEbeGeDcLcmWaRqNA30uga9qxZ1XvgrBSkGf55+jdn1wlfoe4VxGSHUamUWlIBMEHtAcWR/5Mt8pHIMDT34jABFEs5zNQm9pYOjEHNuh3ZcVJVLktpmurnqZFFVbIQ50hAeMzgUBich/vms6WxSU9eJwOjzM0w6QAR0dFwBLj1AG6ugDueFlOQ/VgG0NV2H+wJ0vAk5e3pTZ1tIQt96lIOFRS8j0xxZym3iclzMe4kJOcEJBLWqkE75H/MNymhrAv/c8MHrjbYOXNCWN1b30W7+rUjzyaoRaatTYCnZgPUln04tvn5CMoUk4EwiS7wSfBBmYli47ZjsZ5W86BNhd2Kxny709Aqwa0AWXSqyGw7aX7SWASUAsregrlnYsmHMs+y0OsBAQj+A6mgBvIftxGcdn6GP+9t7d4DZFFf2Sw2pfmHcoRc2TNcHSdiCUTIT1I/ihKDJ08QjZ3YQTgaalEsKkjvZVGXknbdKd15bANGOVntGXp84do+/p3LJqWCJv7Mhgi/te8kEMItRBxkWAa8Yd6UL2SLT9ImlCVzA5Jsau4x2I7828mi/RlloDs6Uz8kPnKGnTjcssOQDGY/PYECyoLub495PWKbnq2UbUmBOwp7liub620uSay6o34Clt6AMU4wtzqCU9tbxsTOVZqxFLtMignuuxcSoguGvmrAV4dryj8pLB2BjhJwd/dpl/17JF0K78saWfDq7hzhC/5id693wTmtBuGxOr8dsowjT9sO5cWIwnXSllBSfJhdQdNVhDr8nmu3SMCk98y6AQiv+AwLYX91+FgYYbGR+/kXuC0i1Eh0qKsa3WkFBenpmU08OLO0jqUcYe81taAwdCrv96pnrQI4Lw4M7VrM979+QCSRruiVTFzh+sPKK9f2mIVkD/nYhLuApzO5uu3X8m6og88qLh50MQhvlGmEMRB+2F+49HKaZEyxGRJ/bhLeF3y5IIb
 Mv8no/k2
 xM2B4s3b5K1nrCN4/ArXWKCMktJ3w8t3jedPWMH+fT9Gh18CE4VFXRrz+UhanXju6Eu0Q3fqVbv+71773XkyhWJm4XeBGuBguO9col1myA8rZ2Mxk8jrflK4W6NlLyI5/jUXCYvVbJZTuUxgsyHAG5gZsMo0PK2x6fCdVVVQFP9P/lqFTRR2p2QJ6T6S5wRCfs9YZ/Do52bCGEODyrdKvpL8LTfU0MVivAnclrVoIGGc0OqLXnNgB/u1zltfLjuOVM35Q5SRlH/mlaeXeWs2L5uZlxwhixagyAlJu0h25gvaUIKkhHF4ICU4ppjt2dgimyuGpXchvwj+HlFk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If cma_activate_area() fails after allocating only part of the range
bitmaps, its cleanup path frees the bitmaps for the ranges below
allocrange and then releases reserved pages using the same bound.

That bound is only correct for bitmap freeing. Pages in ranges that did
not reach bitmap allocation are still reserved and should also be
returned to the buddy when CMA_RESERVE_PAGES_ON_ERROR is clear. As a
result, a partial bitmap allocation failure can permanently leak the
reserved pages from the failed range and all later ranges.

Fix this by releasing reserved pages for all ranges. For ranges whose
bitmap allocation succeeded, use the early_pfn[] snapshot saved before
the bitmap pointer overwrote the union field. For later ranges, continue
to use cmr->early_pfn directly.

Fixes: c009da4258f9 ("mm, cma: support multiple contiguous ranges, if requested")
Cc: stable@vger.kernel.org
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/cma.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/cma.c b/mm/cma.c
index c7ca567f4c5c..a30075507d41 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -188,10 +188,13 @@ static void __init cma_activate_area(struct cma *cma)
 
 	/* Expose all pages to the buddy, they are useless for CMA. */
 	if (!test_bit(CMA_RESERVE_PAGES_ON_ERROR, &cma->flags)) {
-		for (r = 0; r < allocrange; r++) {
+		for (r = 0; r < cma->nranges; r++) {
+			unsigned long start_pfn;
+
 			cmr = &cma->ranges[r];
+			start_pfn = r < allocrange ? early_pfn[r] : cmr->early_pfn;
 			end_pfn = cmr->base_pfn + cmr->count;
-			for (pfn = early_pfn[r]; pfn < end_pfn; pfn++)
+			for (pfn = start_pfn; pfn < end_pfn; pfn++)
 				free_reserved_page(pfn_to_page(pfn));
 		}
 	}

base-commit: e98d21c170b01ddef366f023bbfcf6b31509fa83
-- 
2.54.0


