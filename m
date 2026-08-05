Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D12D6C55ABF
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 03:59:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3D5D6B0088; Tue,  4 Aug 2026 23:59:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC6006B008A; Tue,  4 Aug 2026 23:59:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB5086B0092; Tue,  4 Aug 2026 23:59:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B7EE16B0088
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 23:59:08 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 51B8C40386
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 03:59:08 +0000 (UTC)
X-FDA: 85065860376.08.A302C3B
Received: from lobo.ruivo.org (lobo.ruivo.org [173.14.175.98])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8925920005
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 03:59:06 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=ruivo.org header.s=mail header.b=Ltnx84Lp;
	dkim=pass header.d=ruivo.org header.s=mail header.b=XIyJ9w+X;
	spf=pass (imf13.hostedemail.com: domain of aris@ruivo.org designates 173.14.175.98 as permitted sender) smtp.mailfrom=aris@ruivo.org;
	dmarc=pass (policy=reject) header.from=ruivo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785902346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=o4QAi7fBeb6I9wGrT2VJ9NIYmAVe4mq/cp6pnEkzVRM=;
	b=qAzejGCe/Uq83TK2rzdwW5Ow7tfjVeIixSqfw7hqGspfR/sAfm927mhqrtgK7X1uM82EvX
	7IJQ6g4DQiXyYA3vyysLxsenj37zIhUnOKbcvMS/vS04oYsX7DBvp5ziuInIEHhxk4laGI
	79jdz8OtzneEPjlZhgPNPgBTcC9vcmM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785902346;
	b=O/AnshUkvu7xXGsekjkdy8V1Ag8YO6VwQtJC8mvOYY9+x7qAfzXMHcmz29Ny5Gz7t2R1z+
	r4lsgQ6YK+Y18bvVfZ5jCIzsJzTyoEFF3+Gckcuo2HcE2x+8ZCQ5vikZoT4G5JtF2nMHNc
	X4v0XhwXNPCNdLooo6+t0zHb+q+eSdE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=ruivo.org header.s=mail header.b=Ltnx84Lp;
	dkim=pass header.d=ruivo.org header.s=mail header.b=XIyJ9w+X;
	spf=pass (imf13.hostedemail.com: domain of aris@ruivo.org designates 173.14.175.98 as permitted sender) smtp.mailfrom=aris@ruivo.org;
	dmarc=pass (policy=reject) header.from=ruivo.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ruivo.org; s=mail;
	t=1785902345; bh=0XtezHN7lbvhYPS5ZgcLDlQAUboNr9z2+QlaNxwWf/s=;
	h=Date:From:To:Cc:Subject:References:From;
	b=Ltnx84LpCqO3/KkjZDtKR+TT1+fhVSLFxJtvofp3n9R27D/0hYRa3ejmiOga0d7yg
	 jd2vi2me6I/n6wtLQZw3JTkyteToETz/wnWD05qNaxa4tE9l++L47rjpIjHSv8bUXs
	 +WquGSaYfMcdT7MB8bBnMxOYqNBrO2nj0o/1u4GU=
Received: by lobo.ruivo.org (Postfix, from userid 1011)
	id E40B4531D2; Tue, 04 Aug 2026 23:59:05 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ruivo.org; s=mail;
	t=1785902328; bh=0XtezHN7lbvhYPS5ZgcLDlQAUboNr9z2+QlaNxwWf/s=;
	h=Date:From:To:Cc:Subject:References:From;
	b=XIyJ9w+X4l9xB7pN/KtOsPbMkBiYSCvixwT5z3XwWNmMLTwpwdZ3E3poP2SMoZuzC
	 wfKnTo7dqkvwPn0hDXsgQzhsDjLrLOP0tY0kDSprF/KXFmU4ipKIDv0fpeljQR/l2H
	 U/ODayVhk6GUXx74ecWOBkqDxP/8y36AbHgTo8rQ=
Received: from helbrecht.local (bob.qemu.ruivo [192.168.72.19])
	by lobo.ruivo.org (Postfix) with ESMTPSA id 46C6F52E3B;
	Tue, 04 Aug 2026 23:58:48 -0400 (EDT)
Received: from aris by helbrecht.local with local (Exim 4.99.4)
	(envelope-from <aris@ruivo.org>)
	id 1wrSmG-00000003Qw6-0Ute;
	Tue, 04 Aug 2026 23:58:48 -0400
Message-ID: <20260805035848.062492610@ruivo.org>
User-Agent: quilt/0.69
Date: Tue, 04 Aug 2026 23:58:48 -0400
From: Aristeu Rozanski <aris@ruivo.org>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>
Subject: [PATCH v2 1/2] mm: gup: move pmd_protnone() into gup_fast_pmd_leaf()
References: <20260805035847.936054733@ruivo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8925920005
X-Rspam-User: 
X-Stat-Signature: 5pnutziiko6ixqgz51akk7j9suxxneaj
X-HE-Tag: 1785902346-783992
X-HE-Meta: U2FsdGVkX19FE6S6pC0NV5MHXEar/TqRid2PvZ9OYnrbi9vSiMpPJqXj/xf8gjd8ZPKyzZkMUxRpqRroNeRAePUIQl1l0cch4MaOAte746u4Kk5hIKiLdgPNMEQvPd/2LXNDyt/GQdMABv5KLiUX+JnmPjib60lazITMoV4BX75EspEDxSYmlWlH7okmQseVOshtenIz4uhBa3AM+JrKUu5ZhJEQjFUvHhl+3Q+esR75qBSukdK15IIU4JMxTtU2uinSOWZ+pb0KsRcOetfZmuCprPrzNCkzqYwLUu1q2/03qZkAx654YljfGQ3bhH75kI53QZeOr8QBcUHTI1KLIWoFRAyfmQ9MlHrksMsL6nM5dXBA4ZQeucNYCz9rUXqOmM77abnOnqZRyhkUkp+1PvL+8865fuKmIl9DVZI/0kA2t9eTS26fj2ibM5GPsdT8M02t4NJIY7oQNxfRdd3FjMi7kocSk1eqytOZMzqnaRGEJAqs33Hchw8Vp9Mnu25BjVOQCxXArQz6ykZFbYLl+KBLlwyxpLev7Hnkuj7bm7IsJo4QgDTd42v+PJ4TxTZJ5anPDXGlmk5Q2VtR+cWLfFRylKUjgWfuI/vETu1N9M8/2YG6Bl0Rh3amoJhFTJiYE8i497rW2Q2tqJ3phjGF05oxt14J/4/OF4u5aAFuRRDp3OoJeWvqRcDlWJCKU7ocMrIU6o41kYFHgFv6H/ry3z4VSrq0va3pjCdtYvMto/bFpNQ4Tk0E4I4BWEl13hnhgRpj+/+FW3aAIc7Vq6ZJH6e1GKvSEw3h3bXDCiEv0g5AqVB8plaAVyfKmWdceqTFjqzGWcvU09fCaZFIfUycHwUanRniHggmV0igJK46NpGwwa1nof2YgIyMmhZRpNlwOZPApTj9ewc0LJFh132M8YdKhR3m7VQPN00Y2YMUk4f2ur5y5azM9Yj7UjNuCFQxLGEyUERpjqa2ENMXrhc
 VE2Se/V3
 ElpPPXHSOBHZO8AUDtNkrLIWRHFF38mg98eWxQSHLIRJvT5UkpMxvwQtfryksUhAXIk4cSnKHfrRNPG3FBszZxrsR09sJ54JZZn/bEeP5hjkc+wQY09XK7oRrF6aB/vw1GIVQ0S2yEnn8LY9xjjL6f69eAZ2w9/0YIb0xiwM6l3WU+znv9yi4+7IcjqvRkPNBdSSI4QA9B+2a6gJs0hOZAq004R6pNDrPaamV6/4K8GOhOdz+G4AwZsVzOzVW1rsnj6rv1Ki45+ZVyJjKo/xaCXr8GMpvl3XpN2u5cVVsX9oYm944UbD9NE7ErqN/AVl5G3PC7VIPRFvQBJtaLVUaNng9YCUP/NW/HFdy87tDsPEuZugOMwOrg4XjRJO6qjrxEoxO8GcKoSh6/3wg/qDu32ulzuIFfn7BZzhAUSkEU7XXI5OqTDJuVDuB+c2wHrwFAi26Iw/ppoGawoMYe3n8XMza8P1Fp3gWzqkl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make pmd handling match pud handling by calling pmd_protnone()
inside gup_fast_pmd_leaf().

Suggested-by: David Hildenbrand <david@kernel.org>
Link: https://lore.kernel.org/all/85e760cf-b994-40db-8d13-221feee55c60@redhat.com/T/#u
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Aristeu Rozanski <aris@ruivo.org>

---
 mm/gup.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/gup.c	2026-02-17 23:14:22.288234753 -0500
+++ b/mm/gup.c	2026-02-17 23:31:36.522625385 -0500
@@ -2929,6 +2929,10 @@ static int gup_fast_pmd_leaf(pmd_t orig,
 	struct folio *folio;
 	int refs;
 
+	/* See gup_fast_pte_range() */
+	if (pmd_protnone(orig))
+		return 0;
+
 	if (!pmd_access_permitted(orig, flags & FOLL_WRITE))
 		return 0;
 
@@ -3024,10 +3028,6 @@ static int gup_fast_pmd_range(pud_t *pud
 			return 0;
 
 		if (unlikely(pmd_leaf(pmd))) {
-			/* See gup_fast_pte_range() */
-			if (pmd_protnone(pmd))
-				return 0;
-
 			if (!gup_fast_pmd_leaf(pmd, pmdp, addr, next, flags,
 				pages, nr))
 				return 0;


