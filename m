Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BA04CC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 01:16:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21A436B0095; Thu, 15 Oct 2026 21:16:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A4A46B0096; Thu, 15 Oct 2026 21:16:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 093E66B0098; Thu, 15 Oct 2026 21:16:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C16036B0095
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 21:15:59 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 31E061C282A
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 01:15:59 +0000 (UTC)
X-FDA: 85326722838.09.15167BC
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7598740006
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 01:15:57 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=openai.com header.s=google header.b=QfNwJ0lx;
	spf=pass (imf12.hostedemail.com: domain of kylebot@openai.com designates 209.85.210.41 as permitted sender) smtp.mailfrom=kylebot@openai.com;
	dmarc=pass (policy=reject) header.from=openai.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792113357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=6NehW30zqnjXf2BZQWCFKMsNatcoAA2i6XIIUsdpRco=;
	b=Q5dBUQheB4PDqQjYcnNu4oTHPEhFEa0uDkz0Mq7n1FqMJs2kow+qogUu34koPCQQ1faIfW
	vXtcEMnYxWmkXSD+NfWX3NdGZEo3RPp/fUZMdKnn5LZzdVFeo/maCBgOJsXbX7EPFbGBla
	/ou8VeeNfo+7YIIP/BZ+ZX2FN5ZEXp0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792113357;
	b=IgvubxKZRe5su/ggyMGK+XSfJiy2q/8lfp9dZLnnv/2j5rCixl/3m0yPRxk1X/0mDn3pYw
	dmqh+VbDFrTNFr34w8bKZktx2NLsMjzfgMSRn8tULFh6dMIf0XoQ1eNyikgM4d6mieu2bL
	J/yyTlQ06IhOwE7v8SqyGdKUu3e68zY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=openai.com header.s=google header.b=QfNwJ0lx;
	spf=pass (imf12.hostedemail.com: domain of kylebot@openai.com designates 209.85.210.41 as permitted sender) smtp.mailfrom=kylebot@openai.com;
	dmarc=pass (policy=reject) header.from=openai.com
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-8244537ab76so2698037a34.2
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:15:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openai.com; s=google; t=1792113356; x=1792718156; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6NehW30zqnjXf2BZQWCFKMsNatcoAA2i6XIIUsdpRco=;
        b=QfNwJ0lxhlC4POXeBj+RjSZOvAWz0+yuC6palm54YqzEoW86ivwpWKvV2Kej+2giyl
         uaSnuJFayrLV4vudqcZwLKjVKdxJztNlNJWy0lAeNwzO/Mm2UntdOonTXfEziS0APFvA
         eDbdxL9oaNN1lrl/6gCaQW6MUdQqpilz/6fZY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792113356; x=1792718156;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6NehW30zqnjXf2BZQWCFKMsNatcoAA2i6XIIUsdpRco=;
        b=uk1dqJZKc0QQM+2gsTy6QbQQOCAxqFx5UL++YDw5wYrdDbUXoGsOi2KNjVPFGD7HQG
         p8YbBOq+/2sT53tvz4wDhkQIU3mTPOPpNNRMvfDPlCA7hztVPCDwGe1xcQoGTLZA0p2Z
         gYAmmKmxxzD0feIJL14U334LUyDJvJvJZ44FD/mRSgqUK7zMIztzcpPERwtxhmwj91oM
         PjLE/nJwXIghG+bmQXdFJYqRHmFTpuqmFAPAhCNgGzToXPdZDNnTb5Sdymzx46qV8T5I
         dDbCHonc55zBGTRaoM3YN8axODTRj3rOJTV1MhqS2Dg69ohSqLZp3o2zkBJto4BPthxu
         Q/Sw==
X-Gm-Message-State: AFq9FYKYJKI1TSLNFtui0GDPHuppsMr+ZlwnQb4znK06ybdhb9PGx/++
	Qc+viKNLP4EP8SFRmHVFeiqM/bQ4wH0+R4R8jq8hi2ChuvBZrUS51dawnarJy5yB3oro6VzGFP1
	wC4q/rAo=
X-Gm-Gg: AYBFou1nP0VT6JuGP13nUC87B75K1l53lcpnQ1tQ7b6OahM+QlTvBWw0XzO4p1q1hBm
	8P2QY8A5V7xYab79g1mYwmsImRcILZtRdDRy5AMqpcStk+c+Q7NnVbjrOfiHKqDCbRj4qrnVRk0
	SBA+tQ99KzXOvzwLuzwjdgp18t2kcuu6h0yTCV59hB1kVPXx3G8RS+VcCWDMxfWGzmiTcoISoBq
	eiYQ6Jn46faVuice63t9luQUQb7zJ5Jz7llTnbc5rpScF1FNyqg3vIzNAPe1UD99tmAvxDmqGkF
	nuF85tPnlJdM8Stg+aUTTgt2/psuDUHtGPSCONpTGwZGKVG7+Z+tkpW4o6pMrOh6pQgKVqHOIK7
	upbdvDnYcOr4M8Xs+4B9YlDgRZzTQlXH1S7WbJ6/QhwafbbYZVjuqeRhRibd8OKH7pjj2dg7Gal
	r4NNqOmGDwAh9QgZHBP9rDB+IGXzg85ElpKlHlz5TOw+u1BpwQS9h1fs64jYOxq00RzIEFE3SmY
	VagPx6MoIkdJG5WFhmmRolRmkBgyvX49gAOjrikwcL0z0RN213tXMd4aa0Lie5jKvdy/P6B7qk=
X-Received: by 2002:a05:6830:67d6:b0:829:9992:2106 with SMTP id 46e09a7af769-830984475fcmr20639981a34.22.1792113356354;
        Thu, 15 Oct 2026 18:15:56 -0700 (PDT)
Received: from com-75606.corp.openai.org ([199.47.143.7])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-842a4a01f56sm547197a34.7.2026.10.15.18.15.55
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 15 Oct 2026 18:15:56 -0700 (PDT)
From: Kyle Zeng <kylebot@openai.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Rik van Riel <riel@surriel.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	linux-kernel@vger.kernel.org,
	Kyle Zeng <kylebot@openai.com>,
	stable@vger.kernel.org
Subject: [PATCH] mm/page_vma_mapped: continue past nonmatching huge PMDs
Date: Thu, 15 Oct 2026 18:15:49 -0700
Message-ID: <20261016011549.61146-1-kylebot@openai.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7598740006
X-Rspam-User: 
X-Stat-Signature: pf7tq5m6o3bmdif6rz4gyfb5iacymnru
X-HE-Tag: 1792113357-644073
X-HE-Meta: U2FsdGVkX1+etCxfc4+isKkmDOQJvArHGA2rmbXxXOa6OmSB+0e/eIgSiM8JWx+K16qSg3dgJ05l8vuX+/kfsv4XnPxmwDQJ0Vk2WZRMPp4fR/9/D65hLQtTir3XFeMbJDRV+BKKnByqIHE367rWSopMo90oKjiPzydq3Kf6QiWlpRKYNsrZai0hnepfZQm47tOQ+Vjrnangktdoq7VA4nfUbnXdvC/OrHrnsvN8/fTUPltPBFmFa2nq6PyYTtmdgzsf8JRfy6mp7CgzNygRMCstAOkuEwF3TADHhNGFny5cZVwHXixqIVZ2+6xTAzDYDcBoCGTm1Zz40ToRbXzObtS1qcu+cNKLcfKFwEGNc+2wjJGoJiHd2fE0LYZVyf5VL5QZtqSGBeMaXR/D+I+slxhmsUZXkI+b4wNSGaW3qeG51YB0IL/cZG+qEDsCdtHE+MgozxytORH6nQrs7wzouOtAeFedpdD94KnVYdByduOdpcaMuR5jlZ3SgLaiJxuXHDYhNyObsR16WhKzlUaZJLdQOC6GFzzaVnHfrwQHB690aU1L8RIv9NGp5iWpyEx5+aFwFL9TenD6/utO47CUjYMd5BLJH5byqueBpJjck4Sxn8reUvTG6rchervgdb/VgFaeDmIx9XxlkdX4msTY92Rl5p0wfozFzISFc9FfwPhBC2dI8v/FZhyOq3ii1+PZbbpt2At2qHSZxTwvFs6WX7XqQeJGX5URJN6yG3vvOzZq0zfOLTAfi9+N/VTUP0ttC9rymzJ1irNWz+ezmHX0S1/WbEQ8bQZBwFdPgNe3HgHTeHZeo31tppCOWNe89Zi+kYqlq6VpJLLePL5A8qxrqAiDrcybPdKbfo+ICCe+FMM50Zh8/E9QFyMxlJa+kMmAkv6neSMW3i9ZR8O1qagAtsbB6qIHceqLajsGYDNtQHdEvdKE/CZtp9L1pweK9FO+bAYEDDlXppnkfwjO2a+
 0zW74vTM
 ns6h6eCGb9dN6/XIlhCBPIt1OuIZBG9ZEBHrzlPyq1K8YCXy85Op0jxu89S+yHedDRyzIzFkV0BNoOlQaovTiUW0oFDvvwn0m8MG/3P+GDiR3RWrAAuwYn2JN7R6tXrDjoivtZaXOXuOLXbcDrYryfOblrmJCt4T3Yq+DkLZUmFnTnxz0q7TQt6meXQqdg/9rkmiU3UyzjwyJ6JrFBtLQAr0jAmmQ+e6QcJxt4PpdU6v2iwONec79i9EuZIg93v+5LXmZ1umYfbr7oDf/TZNpKHz0NsOhkoR9UgzrilHsVsQx1z/9BAQk7YEEvtpltRwGiwpE/87qYGskI7H3FBcfVABBwlNyK3ReCcsz4XruSFe5sEY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A PTE-mapped large folio can straddle PMD boundaries after an unaligned
mremap().  If the first part is discarded and replaced with an unrelated
huge PMD, page_vma_mapped_walk() stops instead of looking for the rest
of the folio in subsequent PMDs.

This also affects migration entries.  A walk that stops at an unrelated
huge PMD can leave migration PTEs behind when migration or an anonymous
folio split restores the mappings.  Those entries do not hold mapping
references and can outlive the source folio.

Skip the current PMD rather than ending the walk on a flag or PFN
mismatch.  Do the same if the PMD became nonpresent before the locked
recheck.  Release the PMD lock, clear the per-PMD state and advance with
step_forward(), so the existing range limit controls termination.
This covers present, migration and device-private huge PMDs while
preserving the matching-PMD and split-to-PTE paths.

Fixes: ace71a19cec5 ("mm: introduce page_vma_mapped_walk()")
Cc: <stable@vger.kernel.org>
Assisted-by: LLM
Signed-off-by: Kyle Zeng <kylebot@openai.com>
---
 mm/page_vma_mapped.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index 4e964545e5e8..67c8039e9d28 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -258,28 +258,28 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 				softleaf_t entry;
 
 				if (!(pvmw->flags & PVMW_MIGRATION))
-					return not_found(pvmw);
+					goto next_pmd;
 				entry = softleaf_from_pmd(pmde);
 				if (!check_pmd(softleaf_to_pfn(entry), pvmw))
-					return not_found(pvmw);
+					goto next_pmd;
 				return true;
 			} else if (pmd_is_device_private_entry(pmde)) {
 				softleaf_t entry;
 
 				if (pvmw->flags & PVMW_MIGRATION)
-					return not_found(pvmw);
+					goto next_pmd;
 				entry = softleaf_from_pmd(pmde);
 				if (!check_pmd(softleaf_to_pfn(entry), pvmw))
-					return not_found(pvmw);
+					goto next_pmd;
 				return true;
 			} else if (!pmd_present(pmde)) {
-				return not_found(pvmw);
+				goto next_pmd;
 			}
 			if (likely(pmd_trans_huge(pmde))) {
 				if (pvmw->flags & PVMW_MIGRATION)
-					return not_found(pvmw);
+					goto next_pmd;
 				if (!check_pmd(pmd_pfn(pmde), pvmw))
-					return not_found(pvmw);
+					goto next_pmd;
 				return true;
 			}
 			/* THP/device-private pmd was split under us: handle on pte level */
@@ -292,8 +292,7 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 			    (pvmw->nr_pages >= HPAGE_PMD_NR))
 				sync_with_folio_pmd_zap(mm, pvmw->pmd);
 
-			step_forward(pvmw, PMD_SIZE);
-			continue;
+			goto next_pmd;
 		}
 		if (!map_pte(pvmw, &pmde, &ptl)) {
 			if (!pvmw->pte)
@@ -336,6 +335,17 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 			pvmw->ptl = ptl;
 		}
 		goto this_pte;
+next_pmd:
+		/*
+		 * A large folio can be PTE-mapped across PMDs, so a
+		 * nonmatching PMD does not end the walk.
+		 */
+		if (pvmw->ptl) {
+			spin_unlock(pvmw->ptl);
+			pvmw->ptl = NULL;
+		}
+		pvmw->pmd = NULL;
+		step_forward(pvmw, PMD_SIZE);
 	} while (pvmw->address < end);
 
 	return false;
-- 
2.55.0.openai.911.g06873a30d2f3


