Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A0AAD1D460
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 14:39:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C8426B0088; Thu,  8 Jan 2026 09:39:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 775966B0089; Thu,  8 Jan 2026 09:39:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 680F06B0092; Thu,  8 Jan 2026 09:39:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 538196B0088
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 09:39:37 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ED6241A99C3
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 14:39:36 +0000 (UTC)
X-FDA: 84309055152.08.DFF7EED
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf14.hostedemail.com (Postfix) with ESMTP id 08669100004
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 14:39:34 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=nS4FJzk0;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf14.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767883175; a=rsa-sha256;
	cv=none;
	b=0WUxaIhxu9uk5ixlNS3sZp6vbY5D0pDmIDlRQIfd4icvIzLrFkqVOY5Qdo2rA/C26GoAnL
	ZT2H429yblgB5Uaibp1l9fUgCCOnNV70VY+0D47F1bto5L39XaK7dhcOHGALQkTe7k67Vo
	0SNImole0FB4S/2coEqnGfO4ADzRmZU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=nS4FJzk0;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf14.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767883175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wTL8U1oUZwkghfEX1cr6pYgRbtEkFJeHOx0vM5v97j8=;
	b=1HUovnrp+5CTQ6O+dQ7nYRhSFgdlW3AIciMWkoSS02cwkRa8K8qUl6Vnc9ajXumwk1Om+g
	G1vKxYq3veAdMlKTneRcK1u/SBELUkZHGiMe3pEg0FuFu80MXUGWu6B6m9x6v1jPqzkbvT
	UxqQmzvROG//EEmVz/Fka5ahP0ltWZk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=wTL8U1oUZwkghfEX1cr6pYgRbtEkFJeHOx0vM5v97j8=; b=nS4FJzk0nUmfsQVHsnpEYh7IT4
	hyypekP3TcURyqSfN/PrkuuM1fq1hwqkY0BT1bYBuZY2FmZTUsNWFX+bRYIEhbW92ZtUEXFpeDE9O
	j8IcWoxLB+GGr+EQu9xixRIkURn7WYWrE6t9V33pF4dqn2JxFcz59ieYLTRf3GrwY2kQDirSTGxwm
	T8W3z2S3epsMWgSsYxYh63yBlYKHQxZmdG4pn1IseIPHcDhYCw+C8XiwdTq1ctsPnDZbnDldO77/6
	hhPunyLEyiB0qRyYitTINmYd/lyJVW/FvQpiV4FGs3zdCyp0s6Z8ecAtXqhyoOPqFD5Um6xZSTDlj
	tHhtpCsQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vdrAf-0000000F4Dq-0yvk;
	Thu, 08 Jan 2026 14:39:29 +0000
Date: Thu, 8 Jan 2026 14:39:29 +0000
From: Matthew Wilcox <willy@infradead.org>
To: syzbot <syzbot+2d9c96466c978346b55f@syzkaller.appspotmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@redhat.com,
	harry.yoo@oracle.com, jannh@google.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com, riel@surriel.com,
	syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Subject: Re: [syzbot] [mm?] INFO: task hung in __rmap_walk_file
Message-ID: <aV_BoaOogKt3fGGI@casper.infradead.org>
References: <68e9715a.050a0220.1186a4.000d.GAE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68e9715a.050a0220.1186a4.000d.GAE@google.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 08669100004
X-Rspamd-Server: rspam10
X-Stat-Signature: fu56k97g5rs6izkhgsdn7tuiip7f8yef
X-HE-Tag: 1767883174-35950
X-HE-Meta: U2FsdGVkX19/QnSGKjS3uookqNaRQ8j+cwk2r9Ux8murqf6J7Bf4c+uWOQR+3/ZSbWqKXLXlD3RLcXz7ajyNLM6TgHowdRWqzBdLm60mLh15J1Jviik5OG1izkMUYu/DtXm4AtoVVUQTN58DBBjajNtqDjnBvLi/vQUM067Cw4NbU0N804z96QQxXjl4SfpbqxcFkJZkxNGCz/40o4dpj+KqcuuBYzGfuuoxuTCr+vbPtv+ODOA6sfPtyhbB5vYvpVSx3uNv6HTEMPyvH/k9ULymcGCETv3a4XtfAv2FX3rcCv+dAU4fpBCp6t5laEqLKKKDnuvRFmEDsu6JjeYMJLWwisY0bZnIpQFu2ENmlE5tOn/+t4zJMG42ZU3XLxBxZscASOyTAMI6ZjKeRETP2qYDJG+6jfxPnOk+TwPdjAG2nikcZ6urATCWunCYOcjuN+eGplVRh3fFjih7kjiwWu5wIbyvmkXplkOTzdgym2l9LI25PqJnlXYOAKi/CCRk8851ruZlrkr4L2ek615Syw7uqQt+r9JWijPlBqsZGliduECSpj11WRD0WSw99WpsEJSy5B49Cj1ZOFt2ddndXCg2CDgnNgZ/AJYTULztcLNuNe7aot7eLK9obHu1vCHB/S8xqRkSYpz/zGKfeIIl6f4ViDXAMNaCZbR7bHA95EeIM2iSw5q2SuHYcb3qX4WqChAvu63pCNYpeBUZO9rvfajSkBOzszfSHOapEkSVh3Q845NY4B1QpvIXkBkkWF1gQW/hTJiZ1gbGsHi0+O87y/I+rEdSy5cv+QZaK7T728ZEfRd7cB+yKf5NSgcYmVnTODvbnSGWf2coriy0v5Uizzc5f96LrPNk6iZO4MbKr3W06tPl5sZ+NYF13w03qfgySyeDEx1xoeqoP0dfIzmADN8cQToGZ+Hl7u7KN529ybYeZ7jvMdUGVJyekyP28WYZ4veyLXFhkdcuPlcFQaO
 geDYIzh8
 eG3D6R6gBAdGNQk0bTkVNbocAPoApf/6Q8wooQ9isTxIu7OWx3iMKfJ292AIjh0+Udf9yaRUmUZ6AIt+aR0Z256Tjr19meFT4WrsTl/d01u2YNPzaZMJmrZUmfiKs9G1tr9ckpBogxXKoNXkpmja6kXiy2kZDRgPiUS1cuDoc4masJtqvdvSn6osdsq45u3MBrs3Eg8APzaiGIvxohVy8Vm/KoDGG1J24C4VRAHG8+YGr8kbxtoAsJ8J308Tq+kvfQ5L8uQ93G9f8kNi0Y1ZhRsNKlYPLxLaCW6KditmCYSPZ+l8XpSKjw+0Lp1rug0vsL+BtwUNrdjCNO8icbO/wef5bkl3QMeofm4EAsA0UteV4oI7s7YbnE4jhMkpWw4kK3+iAlsN/yM3xH3clVJQu4lu9gElh7RnQyDDqTybSij9bcPRgY83R06Am9bhW74Z3r+aTyzFT142Dx8HWtzFlpEcNKvFv4nHo7TETUl0TKemX26Xkva4akVsACg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 10, 2025 at 01:49:30PM -0700, syzbot wrote:
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=133e89e2580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17f3ba7c580000

#syz test

diff --git a/mm/migrate.c b/mm/migrate.c
index 5169f9717f60..4688b9e38cd2 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1458,6 +1458,7 @@ static int unmap_and_move_huge_page(new_folio_t get_new_folio,
 	int page_was_mapped = 0;
 	struct anon_vma *anon_vma = NULL;
 	struct address_space *mapping = NULL;
+	enum ttu_flags ttu = 0;
 
 	if (folio_ref_count(src) == 1) {
 		/* page was freed from under us. So we are done. */
@@ -1498,8 +1499,6 @@ static int unmap_and_move_huge_page(new_folio_t get_new_folio,
 		goto put_anon;
 
 	if (folio_mapped(src)) {
-		enum ttu_flags ttu = 0;
-
 		if (!folio_test_anon(src)) {
 			/*
 			 * In shared mappings, try_to_unmap could potentially
@@ -1516,16 +1515,17 @@ static int unmap_and_move_huge_page(new_folio_t get_new_folio,
 
 		try_to_migrate(src, ttu);
 		page_was_mapped = 1;
-
-		if (ttu & TTU_RMAP_LOCKED)
-			i_mmap_unlock_write(mapping);
 	}
 
 	if (!folio_mapped(src))
 		rc = move_to_new_folio(dst, src, mode);
 
 	if (page_was_mapped)
-		remove_migration_ptes(src, !rc ? dst : src, 0);
+		remove_migration_ptes(src, !rc ? dst : src,
+				ttu ? RMP_LOCKED : 0);
+
+	if (ttu & TTU_RMAP_LOCKED)
+		i_mmap_unlock_write(mapping);
 
 unlock_put_anon:
 	folio_unlock(dst);

