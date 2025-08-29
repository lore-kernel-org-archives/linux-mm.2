Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B36C9CA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 15:47:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D91328E0010; Fri, 29 Aug 2025 11:47:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D42448E0001; Fri, 29 Aug 2025 11:47:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C58178E0010; Fri, 29 Aug 2025 11:47:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AFA318E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 11:47:37 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 69A751607F9
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 15:47:37 +0000 (UTC)
X-FDA: 83830224954.24.F1A0792
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf09.hostedemail.com (Postfix) with ESMTP id 823EF140015
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 15:47:35 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=N4G8xUm+
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756482455; a=rsa-sha256;
	cv=none;
	b=bSS2nYsQuKMStI56etyQaEbXUXy011yTDZIP5Pqv8JKg8NVQukyOnTBGAR/EtEP0hUxgc1
	2cKARpxXEeQ6sypdaQ+JMVcT9eQ18DnlirZ2VDLTI4u9HYwp8eOH5q7dEvlv1qgCuPxy1V
	/rPYD0ysd4/UQi/SUbX/KBClI8eVnIY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=N4G8xUm+;
	dmarc=none;
	spf=none (imf09.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756482455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dLSO1AVz2650sM+QyD1ANdHUaEw+Wllz8FpTIwZsjyw=;
	b=6LEctAk7+7SHDZW0xrfoJrhyqO/jjh4ZkMV5B5o4dm3Psn7akhE1yAdZjMSbuprmm4ECMF
	1Kkydg6MlukKmKw8EXdI3iiyCAJc4pQJmZqYiMx8P7IWN8+oLF87SFeWqPVSNwueigtwr4
	QmnoGspo0eAmPJ/Q2tKhAXBi9+wVwac=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=dLSO1AVz2650sM+QyD1ANdHUaEw+Wllz8FpTIwZsjyw=; b=N4G8xUm+czGfx4Rf5nuKririll
	ck1wUaa48hMguUm/BB8ZqzOV29KhVRocLHchHi+eEJy/JV6LcoZIePTE6UqR5HsWTDLmH3kpBu+Qy
	pEFCrNaXYdMKsueGR0KCk10pW438zQTLF0OH4rkYHU1NoJ4m7TwinnOsy+NePAzh+wdagHLh43gc6
	QGNWpzWP52RebByJcHasNKgrTrJqssVygbvIlNuv2Z3PG4Ao2wF2JvsjMkxmzN+4n5KSvLHy8D7Lp
	Z8eQsbm1W6waQ4v5MgRLor9OzKgH49lrk+5PWAPBxl/CaYH3qeJrohhOSkBh7hODnuTl4MrTYuvku
	gCock5hQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1us1K8-0000000EFyf-3kWz;
	Fri, 29 Aug 2025 15:47:32 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org
Subject: [PATCH 22/22] mm: Remove redundant test in validate_page_before_insert()
Date: Fri, 29 Aug 2025 16:47:26 +0100
Message-ID: <20250829154728.3397606-23-willy@infradead.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250829154728.3397606-1-willy@infradead.org>
References: <20250829154728.3397606-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 823EF140015
X-Stat-Signature: 7e9owfbto118sgrtscjjwehopfq1zxc1
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756482455-205082
X-HE-Meta: U2FsdGVkX1/N+fnirRu9RJsLDJzUvQVh/Kb4T2nodNHLWUdYjIuc07WSiPZ/QpH1YNvIkJvyI83xRyKOyy4fdphOVj1imS94boCXMRU9yk/oo3+4UUR4NFsc5Hv27rM1eVbZE5NCWJOomAxyElfKTQR3JG3ImCqHdIA0tIw9QjGruEo2/A9tPktsB2gcNyLiXlhff38BnLwlbJ5GeMlpTHOtpHxiNplrmI3VpxkGZh6wilcaYZTzUjpHzL9bgxbwhiQhlcoawKuPMTX7t9+kwB23aX9907tp3D7kaDej6hRs3rXlm1TlqepWFpaBji32ms8ooD6D+1cMPonz1GZ1YvR2fVnY/bUL9rWWan7uULYFf5+zqbSt3hHeKZ8t+zAeIqf5ogGXh1uhRfxEox3HGuiQsk7322oS9+HTuLdpUpff+DoVrzAjQSBRr30ns1v55ogIT4CR2riDkJY86GqoUrjexOGlsOsHiKCFUy53ZTIMycTyPvQJ8FGwS+pffUhawkain7VIARwcFbFHhuLodRdHDE9ly7lRoGBmg4ivIVBrpFdsrPMMAYva6c90JkdLWARf9soSYq8PAQY9ozpb0Q0pAMj6x8+8C+XpRGWCl6ejKcfmvrJzXtqP5/cI7ivw6AUHmMh+nc9ijBVQQfP81VgLvqk4vTs1rYGBgnrDD8398pq7kxI4/CzRA7TAZotRWhEfBI15M0vvvnC6cx7vpsG1RyRrXi3o2+27FdPEGhp/NuImlUvkbvOk6PFGZLt+aDJPPlk6qnnRx9alSmHdCAURd5RPl5SqEj7Mfj0/mgqp3kxAAAY7mb27agLytuoPGfH+O6F9aZPVUjk/N/yxoDUEVWlVoFiXZGKo3sJkzYqBM2/jS+bU/+o8yJpsGEC8+aYW6jERIjMDZPOtUumAAe7vsvxir1VyCGancIcdwW9x4lMyyZXWcvDyXyAYQ8Zd0SudTq8UOx3I4csJWhD
 DayDzvao
 htvZbCisIWOPc6MjZJ9WGRnKgvYZLXlNycqpRi+dJN5YyK0gTXXCxoInGHK20R2HuP8ao6pWGA82teTUp1FY9rj1IvjXz/ZGTe722QL+zkPD3J95OeE/fMEqrKI1+LtCG2LnFfTzw9bGcz7pFozMaJ0pQnghci4A4QM/RP7STXOXKNmvdyjsA58mNn40nReAumxjn0GrCN9++o/JNJqx3Qxa/PkXFomHvUar74yvbq5DWEY1z24V/xQC0l/OJzFM4Qdjk/HXcRY0L+8E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The page_has_type() call would have included slab since commit
46df8e73a4a3 and now we don't even get that far because slab
pages have a zero refcount since commit 9aec2fb0fd5e.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/memory.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index d9de6c056179..cc9ba448a7dc 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2266,8 +2266,7 @@ static int validate_page_before_insert(struct vm_area_struct *vma,
 			return -EINVAL;
 		return 0;
 	}
-	if (folio_test_anon(folio) || folio_test_slab(folio) ||
-	    page_has_type(page))
+	if (folio_test_anon(folio) || page_has_type(page))
 		return -EINVAL;
 	flush_dcache_folio(folio);
 	return 0;
-- 
2.47.2


