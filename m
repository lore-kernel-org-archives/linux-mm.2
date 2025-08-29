Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3A51CA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 18:50:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0A006B008A; Fri, 29 Aug 2025 14:50:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBA876B0093; Fri, 29 Aug 2025 14:50:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD0096B0095; Fri, 29 Aug 2025 14:50:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C78C36B008A
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 14:50:30 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6AFB5C0938
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 18:50:30 +0000 (UTC)
X-FDA: 83830685820.11.8B62DF0
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id B4031180012
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 18:50:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=DObNmiA4
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756493428; a=rsa-sha256;
	cv=none;
	b=krOj4B11QJj8knixFCOStE2J5gMhVZdQ8ppZwRmmo0WMl2FHT9D6NeKbW/eNvG9AHA2Sg4
	bFVAbr8NR8q0pg4Aag9YLC/cei1VWoxBhBSJInd+Wpdaa8QstA6HLZEzS45d+f7G4ZEMMO
	N4wInCl+guT83okC8r5nEtyMi7zMTIU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=DObNmiA4;
	dmarc=none;
	spf=none (imf06.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756493428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rkYknYrvpDrX3THICF8v6K2RDLPJdIDxYXhebZ5R9BQ=;
	b=1DDn1BUpYj2224oDeIoVBUoVWiKwBMyQdHPk2v+V4mLyHr/pn+WODfZ+cKOSOWTl4FncJ0
	8eSoVmxIrVmoWKbmL40eTbVMf16Msgya0TCKrtEM6TQv7ZqMpTmWKohkQVyBUle7wo4Sbz
	pB50BGeWNtNUGfXVvIz0XH566jxSYPg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=rkYknYrvpDrX3THICF8v6K2RDLPJdIDxYXhebZ5R9BQ=; b=DObNmiA4DdXC1x8X98bVpmVHo4
	7ha6gCeXXiG8TwyHvzU3tNYhQzmJhu+YUbyuwJ9KVV37wFmtGKWLhj62J8jG767ht0t0Qh7cF3rDW
	QhxJybJBfdUsFdxwIWqmqgwe3/QkzdQfvaURpUA4P+CCzhDI0VlvyHw3yIGoaPver0XtLjMney3U+
	Hn8ZXECUJnP1A2W1FPoTfrqvbUFU+cJttB3HXKyn9TM+d7h/suvvvuuppFmdUb7aoSbstY+V88WKQ
	E+e12rY8or+0LtpBkzvoqK/VDsozQMO8Yoap7cXmRIMCp94tirthpBIEiSsLWrjyTN4UDjf/vhv/L
	vdVjVtQQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1us1K8-0000000EFxv-1j8j;
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
Subject: [PATCH 17/22] slab: Remove folio references from kfree_rcu_sheaf()
Date: Fri, 29 Aug 2025 16:47:21 +0100
Message-ID: <20250829154728.3397606-18-willy@infradead.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250829154728.3397606-1-willy@infradead.org>
References: <20250829154728.3397606-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B4031180012
X-Stat-Signature: f6xxusbehdzkzdyuycxdhtjebiqxaz1f
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756493428-370207
X-HE-Meta: U2FsdGVkX1+cYd3cu59M8/YFJmbgOjsZ+vRzlHz4v/t54Ld/hN2zrDPNvV25BRNadltHtYOiDV6+jYxQouqqlMMA1EgqeHIj3tlHlsljFoh/gfDyWEKC1eYugZkx4Y1pc2zULve/It3eScZqHOcQJM98nWfOBiFmVafCf+YT7M//M28AFr4cHxuvB4fuhbcSFqE8wB9k/OhpPGgmTqW9cMCB5F61br4vokMYt2lU5piItz7zbj0up9Uk03RLZlAKEifw5hD+mY2Pjiv1cH03NyHkr6OC8zzTlm0knagp1viN7n6rSmT9TZ2kMnBjcC4QxEfGpTRxjOr4dIZjyoeB2Ct/3G7hKNN0gA95ea86/Bo4+AMluSD2DPW3UiqjIfLmFrtJGBeaIVqaOLOj4AK/x+WLTmVOuSyNWxce0wN8bzkidgv3V/eWofze8O+5lJGKt82mf8S4676UMV7Qq6COs/Z+BQixxUfWOZEaTI4gXsLE1/QTHsmXQBZoOG7EhmU/CnPaB9TKKGgJYQFuGXGI42oCmOwhpB6k7dDZDlnGj47p78Xh/oZIkZAFhcvB3IBSJsK6f+aqO/sxMAsgZfyDjY8QWZCLrsxSrIkWKzllf2F+2R5G0X6xDi+J1ouFfDBuPvZyGvr48q84kkKuKrKThJiCLpkSzNL4PdxsS6MCeaquh+g5/i9JAAA908n3e/Dsbdg0yYUeTp1UUpvBj+IfoDlU435/SKprAlMYzNvB4rBco+sLWKazzlUJzCUxUf+XGZxMTzLSFANbT5ZxWWQb2QhhUSAhtab+bdXm2OrGZe/MQW97V0/Ofb4CN83JOjElunBUCwJp4j4L2ZUoTLMIPvluQTu7psnQbtztV1mHvaGD5lKFJORydbMTCa51qdER19wG/Cy8umScW3d059KybEt09KtA9NabG/2UrPzb/YTSM/tyniwrns9urbXciyWxuSCXUhlSVeQZGhaNumB
 ZFyatm5s
 TObfH6k73oo5P8R0sYZQakHRHT+aLFrJaxZKVPwTJkheIygS3wtNjNptbBa94Cf4p+5uNr94PK0D4VIxSBQLTCx8jm0NN81QaJ4d/+EjR5jT1/LM/r4SPblsGf7sCbNGvktzgDSNI9gVhaiJiuUOU3cDcHu7Klbp0BsM0yL9OwrFDPL/1E6Y7mVNOGgipF3sW6WbgUSJYz6AYpN3TPctOyo+7Hw40IJ2mRkjDQpBHfF4CpQ/THYH3Ue/2dOodhx2XEjTZQ438+TpJ3KM=
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
index e017ed0cd438..5a0a97e5b86d 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1619,17 +1619,15 @@ static void kfree_rcu_work(struct work_struct *work)
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


