Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAD32CAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 17:03:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43D0B8E0011; Thu, 11 Sep 2025 13:03:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C67D8E0006; Thu, 11 Sep 2025 13:03:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B5CC8E0011; Thu, 11 Sep 2025 13:03:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D81308E0006
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 13:03:04 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8260058334
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 17:03:04 +0000 (UTC)
X-FDA: 83877589488.11.C636D51
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3BDE914000E
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 17:03:02 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MtT2CGXS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5GSiutm2;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=aRi7YGSd;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=UFU16EPg;
	spf=pass (imf23.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757610182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gr2Y5vpWLhYmkFvvE0c3RnudTXKlGf10pEcNoBQE900=;
	b=T/YSWwG4QoPx1QGLR2Rnc8lagGkTWMcJgd9ikHBb3mfSUyz+0I68zSluOXlCkxq1pZrNO+
	/IB3UsFibHqLnDjuYsZZL/FWyEGrusPUL10o7w9utXsKT6WDdj+90AZRjR+A0p4NXgY1gM
	FAGDnkaspnfRmXY9zS8oUzarYah22z0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MtT2CGXS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5GSiutm2;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=aRi7YGSd;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=UFU16EPg;
	spf=pass (imf23.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757610182; a=rsa-sha256;
	cv=none;
	b=vgw8jFBnThUjklJ5RC1m6eXxKL+CSIvWKSTHwWagfGygFSV66xsiypaS2h8JSBB4RGFTfp
	r6abQaXk+VnRvOFb6LOR0F3v1P280zq0QK+Vu1AHjkftZUqRfyKANNWRlEJQAPjulTH4Zw
	OfZyvNpFh7a6r1fOElhABdgt85lOpjI=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 01DC47647E;
	Thu, 11 Sep 2025 17:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757610156; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gr2Y5vpWLhYmkFvvE0c3RnudTXKlGf10pEcNoBQE900=;
	b=MtT2CGXS0oB0KE1fLvExDMMJMc8nuu5zAuU4GGnqGztTCwbkABvMuffinDIgF3zqj8kqta
	3AoVsTSuueITNaVq5kqGMa8RRwt1OjPcs6aE6xFIhXq+MgCmlHgphheOCFJYxAWNNz8wjT
	xDXwBHzNblv2tej3IzBsCL5X519G42g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757610156;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gr2Y5vpWLhYmkFvvE0c3RnudTXKlGf10pEcNoBQE900=;
	b=5GSiutm2fsIaxCzQ51sYTrzP2N+ePhhsgtlgzgUPNLJmkKs88ZBL9ckisMxvkdEji9kxQi
	LfWroL+vWuICWTDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757610155; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gr2Y5vpWLhYmkFvvE0c3RnudTXKlGf10pEcNoBQE900=;
	b=aRi7YGSdI/ZSD8wGJzaYz9hrGpD8rTajcN2DOUK0xGb5fo8QZos5GWypcwB03LfqNih4Nk
	UxMF/lPpfP5VSvTxm5UeO8tyhKqPVyn/czhyn7m2aUd9CMvCBve7Xff6tqqO/JAgHNSIza
	sk+Ya7lBEqTc0aq5fupszNHOeaWR+PA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757610155;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gr2Y5vpWLhYmkFvvE0c3RnudTXKlGf10pEcNoBQE900=;
	b=UFU16EPgWUxx9bfx8YzkL8UdxDIMNz6fYhEqJyLaiyW2gWddq6NlX7AuR/C0apIbYu7Ege
	6QRvffcbojJh5lBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E169F13ABA;
	Thu, 11 Sep 2025 17:02:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mFfANqoAw2gUJAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 11 Sep 2025 17:02:34 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Thu, 11 Sep 2025 19:02:34 +0200
Subject: [PATCH 1/6] slab: Remove dead code in free_consistency_checks()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250911-slub-slab-validation-v1-1-8b67eb3b3dc5@suse.cz>
References: <20250911-slub-slab-validation-v1-0-8b67eb3b3dc5@suse.cz>
In-Reply-To: <20250911-slub-slab-validation-v1-0-8b67eb3b3dc5@suse.cz>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Harry Yoo <harry.yoo@oracle.com>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.2
X-Rspamd-Queue-Id: 3BDE914000E
X-Rspamd-Server: rspam05
X-Stat-Signature: e14m98kxem1g5nyfafey5hwq7eyi7wnn
X-Rspam-User: 
X-HE-Tag: 1757610182-44250
X-HE-Meta: U2FsdGVkX1+RiRlxAU7lk/p+V/1nxM4AwW43p2F8vsB2nV1b1rcP8/2ikEYwJrmi/lDuAPI/AWvOjwaRDAIZORqtTTbhdXQz5wU+TBD9Zxl4edV8CZC1/eMYGbkjV2Doagzh3M7QaXWaxBMMMVh2o72yAW817MH9sApeZZy/jMNy9r5mmOPXhqHvf73+0NIdfDGDmwo1ohEyV2zYsZN5aCecUTMyhnS0vWUboMdP702+BhntftgCRzCQumd2K5gb0QKPjmbCqnYZoIP59Nw/g6M6v8F1mWOgnNL4qmOReeu3ghpz9FeRZ5MAnJN1RMPFDghjfgbaJLSBrft+stkh4d33u5qAOPk6ZEZLbYAYjxr6Nr1MiJuy/a61EktpNEZsDTCbJsrkDKHQ9bd+4H60fbK2w5woI1BxQ5y8Bb8nBgDqiNiOaBpCWQQQOFeCwaQAJfSSITtmoN2koweZ1Bpv/A9ckNMaJJnPOT44OGOFVU8wVLKhyuHe6CCYwivWOtMvJk2WkZmtKBQmY5JiwaRSKtaDsNHrMC+v97fiUQTsByZSMFEW8SPZLeO5k71W04vM42Z1kgUdQpHlc7LjJDrtPf2jz91p31P+veyiHxRCXoCdHNJ6i4/A2CTVbH8eiSdiGMwDp5LatTv/XUME2BpZMqCx0JxDhXL/COYpUG4xI10x+gBIHjH8hSa4HiY1Lqzqes5Jn9spJ/9zCcheJtUNwM/lg+yTUk+KiwmNohwqypNdOp6xJ7nWNP1mkYCZkGGZ5fTt8XBQw5kLvhRss/G+w8m5f3vQ8/w4TNa6DPkr7xRFgZn/thNAIsJoIoFlqY65lQqah7JZmZOq1JFcCyiGpbUH85NaNQIBeiam6+gmGcq4Gv6vQJynAwnkc3PebkrOSh+Sr7EnO++v0DAV8BAK1lpkLbOzab/lt/xdakv5kfa7i6MOn7w8xYN9qLWcYvV9YeDlR0c3Kb9Rh+vJYOX
 8tRYrlhe
 T5X8UFKzsu0jIDTMyI/08sscgsCITrIMG9MP2rXhjUCetHT7mL8446Mz6qbVQAUVwLvsfi64gku7tcI+TBGjSj10xObSVovEeQS8u9rV50cbWPhXoj3E6DTtFHMnUsJfLoxxTLM+NqUk808VmvO0i5uhiKbiUX8HJdnmm2EFy23T4heEy4OoEe4hOTzEOIGX+9dpM7sBFcVV85Fr1DrNrC2KX4FOfbC7BT4rxhcuzXSmC6XYrOzrTYGwiOQfFjND+hYUQSwRmCu7brRklEOYFC3s1fwfnvpXJImIv0qruedV/fN7hsEMqz30N0dWImW1Q1AjmWcDV/4khfc9FDVnt5gF+i07ahomYQ8XQ5uNWiN3FIlRSS+XyhRmoBG/1bCIMEbmE1hlrhzdNFmfcciYBmMar1qckLGBgsQqL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

We already know that slab is a valid slab as that's checked by the
caller.  In the future, we won't be able to get to a slab pointer
from a non-slab page.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 3062f56bf49882538ba5af407de9f69c451f2e29..56143bfd1ae319d384981c810a5ed84af00f4afa 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1684,10 +1684,7 @@ static inline int free_consistency_checks(struct kmem_cache *s,
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
2.51.0


