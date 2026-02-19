Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9068BE9A04C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 05:03:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3C796B0089; Thu, 19 Feb 2026 00:03:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDC416B008A; Thu, 19 Feb 2026 00:03:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC8796B008C; Thu, 19 Feb 2026 00:03:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C90E66B0089
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 00:03:17 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 450C558C7D
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 05:03:17 +0000 (UTC)
X-FDA: 84460012434.27.8B57C29
Received: from lobo.ruivo.org (lobo.ruivo.org [173.14.175.98])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7B426A000A
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 05:03:14 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=ruivo.org header.s=mail header.b=GnqsfpS1;
	dkim=pass header.d=ruivo.org header.s=mail header.b=Hi4Btrrq;
	spf=pass (imf15.hostedemail.com: domain of aris@ruivo.org designates 173.14.175.98 as permitted sender) smtp.mailfrom=aris@ruivo.org;
	dmarc=pass (policy=reject) header.from=ruivo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771477394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=o4QAi7fBeb6I9wGrT2VJ9NIYmAVe4mq/cp6pnEkzVRM=;
	b=AoPG9m3oI4LyoPN/IKGe5OrtXCFAPAPBKPYHnKXtwrNA4i/+9c1QlsSvfjEqcrsXjA0QMe
	+i+h23Objt5N5LH9vzfHGEq5RK6QFgcL8odShIDAkCot6YhKmB4T4l9MuCl2jXEIxnYvB6
	4gsaIvabDz/y6dMgYMAPD0JtK/sGMbQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=ruivo.org header.s=mail header.b=GnqsfpS1;
	dkim=pass header.d=ruivo.org header.s=mail header.b=Hi4Btrrq;
	spf=pass (imf15.hostedemail.com: domain of aris@ruivo.org designates 173.14.175.98 as permitted sender) smtp.mailfrom=aris@ruivo.org;
	dmarc=pass (policy=reject) header.from=ruivo.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771477394; a=rsa-sha256;
	cv=none;
	b=JlrOlyPlF8YXMP3TZ/DKbwNpMAJwALOOWhhYfENHGzuPHYUnUFNP6E4X/yn67ZSaQnuNOY
	K2EMAg5tS032AnNuEy8yfU/v97laywTh7qABigabrrwreg/ihppHSZJ+uFcZWqv8KJncWr
	yiHeiE6qLi9DzALUjGoPqds08iAu7wc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ruivo.org; s=mail;
	t=1771477392; bh=0XtezHN7lbvhYPS5ZgcLDlQAUboNr9z2+QlaNxwWf/s=;
	h=Date:From:To:Cc:Subject:References:From;
	b=GnqsfpS1zDoGRRpbxP9q1BHFE1eTeS+woYHCtRrOkJymlf2+txaNSWRHB/41uEs0G
	 LKzyHvYuwC7Xgl1P7VdJIVZSfOBdKjRd83xd1sbhGw2zivKy8QTWF/M+K+6TUrnkeL
	 3PQ7kD1YHtHaHlRNiEzEWync4kVWedSfDcp7El7o=
Received: by lobo.ruivo.org (Postfix, from userid 1011)
	id 7551D53A61; Thu, 19 Feb 2026 00:03:12 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ruivo.org; s=mail;
	t=1771477370; bh=0XtezHN7lbvhYPS5ZgcLDlQAUboNr9z2+QlaNxwWf/s=;
	h=Date:From:To:Cc:Subject:References:From;
	b=Hi4BtrrqQEsyvTkHMAm2zPmbL7a0rugpAZsmwkIcBXrtTFLx225knTehQX7lMmuv2
	 uHjew0F0ZqeE3PsH7K5qFx1SaEICGb5/02Cy3dr8xKImEPg7tNY1EAetL0K8cIJs2E
	 DP++cBaRvjALTogBhkVMI0aTuU78n7YaBn3r8bnI=
Received: from helbrecht.local (bob.qemu.ruivo [192.168.72.19])
	by lobo.ruivo.org (Postfix) with ESMTPSA id 577B752BFE;
	Thu, 19 Feb 2026 00:02:50 -0500 (EST)
Received: from aris by helbrecht.local with local (Exim 4.99.1)
	(envelope-from <aris@ruivo.org>)
	id 1vswBe-00000004J1M-0yZM;
	Thu, 19 Feb 2026 00:02:50 -0500
Message-ID: <20260219050250.177881706@ruivo.org>
User-Agent: quilt/0.69
Date: Thu, 19 Feb 2026 00:02:51 -0500
From: Aristeu Rozanski <aris@ruivo.org>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>
Subject: [PATCH 1/2] mm: gup: move pmd_protnone() into gup_fast_pmd_leaf()
References: <20260219050250.061598056@ruivo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Stat-Signature: k6im1uyf6t79eb1cmghu8zc6sgxbqmdg
X-Rspam-User: 
X-Rspamd-Queue-Id: 7B426A000A
X-Rspamd-Server: rspam01
X-HE-Tag: 1771477394-389887
X-HE-Meta: U2FsdGVkX1+h76Ss8WcA6ZEfW/DJn/mFgWLqMlefhMdGJCPCyQl2Q1FaEKz+jwCF14rEi3LI2hWJguN1pCK9ChDdIZlcIfEzAk13TNrCLDqPD2Wd6yPJnun7AhR8oWwvp8ZwNoM8W6RcqShIsIv/+iP6EGSMc1mC45Ar7CpuigEQoWCpMitku0yzXRvY02mtxsz79a3cwBqX5ORGHeafMW79uENCxC+J+ocVU3vabEzCKQiMr4M+j3DaNs4ZFj6QbIl+dDg9xptZp8DmrXu/G7Fwx9UkuQV/W4Vu0lDaqM3uFJtye1ag6rIvVmnGi44K40fpBfr6LGtZ9YHDgW7+E9B6CoW6J+d36HqrT+/pY3xK0LIdkY0ptZckeWMbH03HiotORLzBa1tAAc6EJ2YoI2NxfDMNYJ//GViX/ZJxtYZPTCLfbwSVFl/0I8l4Jv5938KEHDOX4DmGj/M0DRBc1v9W3+8kg8V4JUt9cfwKvFi5OAoe2wWmulhV6SWEehxpmcFwTUpTZm7Hfjoen+5norzhECeBNMso1mi0dj78j7n8CcyxWyxHM1H5afYEmm1CSb6YlfK1TEeS1xTOc6sN5yYK3kcsXh+9kcZcCdBauLWOSj8Je+4sxs882KNQTCvh2gd6OUhjwDW/ECkXoma4p/394o0nnx9iT8v5IlrYwXoMoH9CYetE4cn8gpeaUvrJ0ZF/8WkZC+ixh6qHw3heiulCmYgDJNpIz+qhPRZgiEzNQd+xiPhVu3Vff+tl5ydcguoQohoK7nkpnrKG0mDr5vuGeMLVjT0v4m+d15fYBVKhENkjMzVi/4nDkQhj8LRu0Zykax4Xzjmrp3l7LcG/qj2q4qrd54duNhqEwbLuOM2k0ACTIgFxfwrb8+x1tyM7Q2gm5tATAYdiLvsWfYF9A0pVey4cjnaPXXlJoS61YG/tRQbZtIabHn3KNIZB7gB164b0ATq2mquzyjmzjRl
 5NlglHq8
 zQcwxigqT/BlNFAWu/RYL/nB4udDoj31Z4dTXz0tfpNLmbSIoR8pKsoeWVKzsCwwV6c93fjmjsMBuJfuD4KdMWgw+EFF10TGFcYhTeizKlQOLVONiXvi/vi+UPXQnEJ/3dl+JKd0nFifePBWZay5vIChJRudPXjRF2ECPNl8jqG03tEP5Pz7ZpN7P5gHJedBfz4KEXim9i2wGHLM2yUbupemPNnmF8AE8aHLpw136Ukibv2UIzSHqHgfIe0jll3V6B8k7KWet6WatqjJl0nU9jxo0hQObLm4KDgd4cbuGclTmNnKmyUW6H6jPaI5L1VeOezc+K+5cQ8LC0re6exvlr2PGOnVqKq6+vuZ2BNeSPX7q67ZowOzUg8GBEmDD52DyiLAwNCVjeueomNziUI9VF4lgPi5yLPfxVufMR8Vtk94QYzKsUYqZ3mAHl1YCPvz9bbg9ZnfBUschTeUita5nzLPwEdxgvOmC/juh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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


