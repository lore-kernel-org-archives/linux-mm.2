Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4486CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 11:55:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 291A36B0006; Wed, 10 Sep 2025 07:55:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26A368E0002; Wed, 10 Sep 2025 07:55:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1318F6B000C; Wed, 10 Sep 2025 07:55:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E70976B0006
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 07:55:17 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A5044C08C5
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 11:55:17 +0000 (UTC)
X-FDA: 83873185074.27.F199381
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf28.hostedemail.com (Postfix) with ESMTP id 407EFC000E
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 11:55:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=jGr+a5yx
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757505316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s3Zwl6Mj1STBAEvmoeMrFI+bR+flJhLcwOanfnQh3BQ=;
	b=zF/xTtIUFH/zxv8d+YG6hj1IHyPuOjpTO8zFLfcZaRs8xCl7Z2wFIyMVUmMA+PhH50vJz2
	kyFCru6wNX5TvV2v62Irk6qDlycfFyNrkeZGvFhc94UXOU0eoYh5rQJl1NSfcL85dAlDMG
	noBzucfpKfOnBDrT8U0LRE1Bw3w6a0c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757505316; a=rsa-sha256;
	cv=none;
	b=DL7ZISHNuKNRF4agP0wrAmSv4fB4UHar85mZx/giACJ08TvWSWNviiJ3ji2SH4eZtFMkXX
	sJDSxcNBj+On0Wbfkf6sjxIZD17+6aqDLBMLeYwPdpM6WOn+ogVSAV7+LBxrDS/JT1vkpI
	l56Q+nGvz6NE7qDy4Vo9LreZp7EsmdA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=jGr+a5yx;
	spf=none (imf28.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=s3Zwl6Mj1STBAEvmoeMrFI+bR+flJhLcwOanfnQh3BQ=; b=jGr+a5yx1llwmLQubtecwx3oP0
	113SZk5sMKLTdL56tWhXfJxETy76aNiHqk8f7IiNcf/fMmrvq5Pp1kCDAMaHcKCrizEeN/C+h5Cx/
	CvlDFr0OoyA4StIjCEuwGPvg3ZnMn20QdXPzJiNos/wUjuTTWXnKqI7XxdnSFuHv0Ky5NQWZWDLsn
	fhetImW9aKG8NzRJobh5+DJ/xPVyypdrgdev2klUWECBFNvetsTcqTWI/ThQBAav97ueHp1F+JBIp
	FTG4R/4ffzx9YCShkK2UB2/p0v0L6WIIr0aRzSogGK6qh4PWjTiux6luQrvoPK4NkiDr8LXl6RxWy
	Pqb43+DA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uwJPq-00000008MFT-257k;
	Wed, 10 Sep 2025 11:55:10 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org
Subject: [PATCH v2 17/22] slab: Remove folio references from kfree_rcu_sheaf()
Date: Wed, 10 Sep 2025 12:54:59 +0100
Message-ID: <20250910115507.1991829-18-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910115507.1991829-1-willy@infradead.org>
References: <20250910115507.1991829-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: m3sce8pts66c9mo563cp6u7pqgky194i
X-Rspamd-Queue-Id: 407EFC000E
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757505316-194730
X-HE-Meta: U2FsdGVkX1+64JHr7N508l8/Wibp/wIjAEijuav6OWv27UzAY4x7MvuZTt81iZb/ccuvPZZPt8S1WUzQtiIC4yx6q9U/X1j8uZKSUkcLlKEl8x6dl9b/OZgwiaPfpRyv59PAq3cf05FLYJCRZMZUjCpoW+77JRwCOiLYOulhIaynjXpR1rvXMduuIvvH206beqfLHejbLv8YQpn0EcG4d/Z1z6xVUg/12gYwiRPWSRxQ+dw7m9MuIL99Cx7icATlhXlcEaND80SmvQyb2k5iTW9nA8riXGfH6jCugSNx9JyfFe/ghkE8JmXRYlwSarih1jLMqv7s4GTZKkPiKIhIdDdmI3DMs/bLDWB/0ACMXy5jpVq266njUCYNWGg8bKR9IJVaXdZ2m7pcNpDjWDFq1N772t4QGiPPPlOl3/EQ+qR9FuNS4HCnqZHD3yjua3nBTwx79iq5tfJLtpAXgZPBaYs3GW35LfoOQ0UgHj+hihG2x89vhvoz8SDSkziWzugGPohKE7wzwaiX3Wu6HgIHkxE+9Lbm94dHoT21uW5IChkCS3L42og/QrG5of7/iPnRMsKSnMp18TG4KO6p5uAeuxm6TlMfuXK1Mlwvewp9vQ/U6/y5tCdtPpnpfbZhFPYowvp6sdxGZtZqoBAJNX2ByoXP6HypZ8/i3EgvtcCajUGVLmgNQCg52rw2bfiz0TMMSjhonkA/aAdBTF7TcGJgzvZotQasprvhOU2Uv2jBGQyUQgD5LL1G4mN5Mqn26iri1v/KWKTQKL+pkIL7uYnpZ8oKcO0QBsKPL6dRzxTwHmQN71VQ5Gz4+zaS5cdbFdNjZf9JkTqo2Uz77Dgol6eob07BbtY2+F/LDQmsv9NjBOpaJEVpyrpsqidKiPKxvBp8XjiJZbBLT/b6PZGq9rZdoA8nZpy7QJ5qxOe3zTwgwpH+z7PHJGeOkQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation for splitting struct slab from struct page and struct
folio, remove mentions of struct folio from this function.  Since
we don't need to handle large kmalloc objects specially here, we
can just use virt_to_slab().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/slab_common.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 3216a4e65b51..8c11192f5b2b 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1612,17 +1612,15 @@ static void kfree_rcu_work(struct work_struct *work)
 static bool kfree_rcu_sheaf(void *obj)
 {
 	struct kmem_cache *s;
-	struct folio *folio;
 	struct slab *slab;
 
 	if (is_vmalloc_addr(obj))
 		return false;
 
-	folio = virt_to_folio(obj);
-	if (unlikely(!folio_test_slab(folio)))
+	slab = virt_to_slab(obj);
+	if (unlikely(!slab))
 		return false;
 
-	slab = folio_slab(folio);
 	s = slab->slab_cache;
 	if (s->cpu_sheaves) {
 		if (likely(!IS_ENABLED(CONFIG_NUMA) ||
-- 
2.47.2


