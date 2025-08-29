Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3559CA0FF0
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 15:47:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22F678E0001; Fri, 29 Aug 2025 11:47:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D0F88E0011; Fri, 29 Aug 2025 11:47:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C5078E0001; Fri, 29 Aug 2025 11:47:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E40318E0011
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 11:47:37 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 709EC1199D9
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 15:47:37 +0000 (UTC)
X-FDA: 83830224954.21.4803450
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf16.hostedemail.com (Postfix) with ESMTP id AEA5D180006
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 15:47:35 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=G0VgO4Rw
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756482455; a=rsa-sha256;
	cv=none;
	b=5ZZZm9S1cMSNQd5A75oM1zU3s8zVd8IeL6Fs+pJpCgWYU5ljMk6ZDx68x6+aKGb1WN+k4f
	lQPo++zFAtMjCyzJ3Ba0JP7UlKGnGa8JV+JHuZXR4Jnknv7PfoxslkTJBGt5RRRGQE6R9s
	xGndcv30HlK/oKC2FzT/dAPQT6Q87II=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=G0VgO4Rw;
	dmarc=none;
	spf=none (imf16.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756482455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pq2/SgGk+EbHPn3gALmfCwV1yFZjJ0WkQzRebatMWeM=;
	b=yA3u4MRKVPiEQNcxNnKvovamaopO42W6U9/KuIfldtp4esngWaosuovrRSO/KO8n3HY+TC
	SWGu/rPIUdVg0cQWJdwlQ9XvV/as8m0NcMYhyVq75gT+MZcddXOZEZ8B8v/cv0pdTc5lox
	c3/bwZrsWdOw6vE0g4Lm+hTtx+PRzDk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=Pq2/SgGk+EbHPn3gALmfCwV1yFZjJ0WkQzRebatMWeM=; b=G0VgO4RwbV7KJp1gxZW7tnn++O
	Zx17q0LhWns1kzleHWDX3WqOmEcvmYi5T9P7U176aNBYW9dzVhm1gNg1HQhsGZ+48ghv462qX/Fhb
	+v7YBE/2/zKonwM3BzwxnRFqeoXaz2zSiL4f14i9205K9Sg8OAP2RgVkOvgzEf/PAr7cyTaZt35v0
	YBS5G3Jzml+YPlDWFSvUssU3ROOQ1Wv6MN0Zy8qCeED9qmXmIbYKmh7xweaij0MCIdicuBVIqTfqk
	ymhbyiZ+vmzzAtKkCXW1fcQEyI2gOv89oen9bT6tHNlpzkHoX4mmLHwJ8SB+IyAqFSJ6Udt6qAF2U
	oBSAarhQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1us1K7-0000000EFwD-0J1N;
	Fri, 29 Aug 2025 15:47:31 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org
Subject: [PATCH 04/22] slab: Remove dead code in free_consistency_checks()
Date: Fri, 29 Aug 2025 16:47:08 +0100
Message-ID: <20250829154728.3397606-5-willy@infradead.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250829154728.3397606-1-willy@infradead.org>
References: <20250829154728.3397606-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: AEA5D180006
X-Stat-Signature: bkjogxnbr3sxaowuoi5dq3sc6t17e11d
X-HE-Tag: 1756482455-541780
X-HE-Meta: U2FsdGVkX19NRO4r55ESVSu/AwHab8CcQDq9rUc9rgZRBmUsqRVNSy1r6My6PJA3impW/uTB9ilsfTYUHdlDz1ZXGyvSioIG7ozOB2t8VknIcp9fQl0IQoroRKZGKBkHYaIvnmedzBocJ87YkYRsDuPMuhZ2GCv8ysc/WwKzWL246Ko7g0h/F2fBwSUWDqjz5hNub9JlcdlXYypJ8IyKq6XH6Pmjo0VR7QRpuPc4HIW342nO+lc8B53JkjeJ7Z9Y9n2TfWGmKwYBKiny2eKphqjajq0SHil+Y43M3q4yEa7QHjfJ5Ujk+p0IvLfZ58MxctAmf/4VqsTJiS1naJrdXkqZgHEDuuOmbfs6YCsAgNGFCuq/u/26/XbBER/aZattkzT0Lm6cGDEn5D1WnlcQwmLOmVI+ZAcKRgw/9SNN9iDEmeZPW2sEczFVBVN6IAGIIPW0FabCqH1m2t1ErGhOpJWfrEsIJAsYeUasvDpX//jI8XPLOg31k1ajNXfLEaqqNXwlB3Au7QBIiu/NCWbEYbugV7YtlAp2waoF/KKLy4UpfTD00+d8/CbyDnQBWp9sAj4lDWfBrqOCBWyYn+DiSTdL4QDxVgLbG/4ySROpSSxYWAexagBG2kY989hJPHTer+m9zLULbfAmxOpzswH2TtGmLobs7wFnLSMB7LgM4BxZcg6wOctUQPGNNVrbn8Wnowm7yukdA35dUge5FCOcILSLqgh/bBNcOHnApya+pkL0fTLBcWwFPOF6q8M1ffM+CP0rsFdyP0TmPaOk6getzYFC2wLMglIylorGNWTde6yXM8fhkhCqEA/i53pJcoTLx1kH9iLWhetRvDsp5TyW0XMlTXl+TjmpFrXnPKJy4IEaKhj+2H010J/+MWj71faweujz029BppPV1eDmFCJGaK5pOHYukSr4uIrKqAyW2lbgM4SmiONSfH/hK7B90N3bWTsG0IWV8NgYKjlFo+J
 qtn/IdyW
 79poJTl/9Tb5aNepbPlEbo0XUSHZcBYIxW1oocoNq2xCOP0fl7UpeeNqyyEm0/Qfe9j2g9I5C5NBuoIvqBIvX1OAXT5zJQZZqoxVXu3DVUNQcR8dejGOyy055UtNUmnuvpgY8FYbiJvq8Wedmn/9YMm16qlwFRsdBTMNnzB59rOREbzFGSqB6k1nR6YOWFkTEcierv9IQ4bIsdKnhFiQWsfNT+Ngy1qzneyBgDaw2T98spOa4ZZwe7f5QL5+g7H7L8RZq5H3RTUsn0Evhx2F7LrTM6m7pVolOZ1S3t+rHpHHVaQDTDqp/gp4lxC2nyzaeb017
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We already know that slab is a valid slab as that's checked by the
caller.  In the future, we won't be able to get to a slab pointer
from a non-slab page.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/slub.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 6b0ce2677d32..7b9fb7a88fdd 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1734,10 +1734,7 @@ static inline int free_consistency_checks(struct kmem_cache *s,
 		return 0;
 
 	if (unlikely(s != slab->slab_cache)) {
-		if (!folio_test_slab(slab_folio(slab))) {
-			slab_err(s, slab, "Attempt to free object(0x%p) outside of slab",
-				 object);
-		} else if (!slab->slab_cache) {
+		if (!slab->slab_cache) {
 			slab_err(NULL, slab, "No slab cache for object 0x%p",
 				 object);
 		} else {
-- 
2.47.2


