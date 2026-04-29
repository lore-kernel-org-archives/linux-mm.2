Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3650FF8875
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 12:02:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 823456B009E; Wed, 29 Apr 2026 08:02:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F9686B009D; Wed, 29 Apr 2026 08:02:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C27D6B00A0; Wed, 29 Apr 2026 08:02:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 542EC6B009D
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 08:02:34 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8204C879FF
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 12:02:33 +0000 (UTC)
X-FDA: 84711456186.19.E171C39
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6BF391C0012
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 12:02:31 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=RWWSKnaV;
	spf=pass (imf21.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777464151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OOsMll9kQIx755DceTdesDlxlXAn4+aAsGZl7xmkZUM=;
	b=SB+4O1wuKjkfhJgVYCKdYq9mdkklKtuaVWrbbC4g7t4sAD5ZC3cpj2vJ+jVKCqjKacuIz6
	j93wMSgh0Xqx6y7g2D6aY4aQgbleIzjZhbkANaQBUBx26DRrdL+wqSMBrNgXF8tprWWFZk
	U8EFLhsxOorV7+ISMBJZkwxunV70qzo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=RWWSKnaV;
	spf=pass (imf21.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777464151; a=rsa-sha256;
	cv=none;
	b=kTN6uUJoxb0yzzxCPGXaQc5FxpP+XgciOYJ9sdCfcdkUwiBiN+p7eBv6As/IXyPsB0Rx8q
	Alxpk5AWAgI+oBZF7C8eZEwlVvjXBzc74hSToELvSJr4Ghh0hCXxUVuIKpkIheJRATkMWh
	HRweiZNrOaWAfmJF+r+Iqs4L5eMdK7k=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id E1BD2C7A93;
	Wed, 29 Apr 2026 12:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1777464148;
	bh=OOsMll9kQIx755DceTdesDlxlXAn4+aAsGZl7xmkZUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RWWSKnaVu6bg8FfpcCKZGBGlcKbkZMRKYp4JmFsvfHlLEzFE6vh8QL11YDK9kY4+M
	 iwNGLAehc3nQPJgObq4aOVECtGJvEZFODpE22XOAq679VsTRjzQaJXuSWceAl/VVtF
	 4WbKGP1n+QLIUNpVtc4ftWDPFmPCTK9pveNkzKQY=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Dmitry Ilvokhin <d@ilvokhin.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH v3 7/8] mm: use zone lock guard in free_pcppages_bulk()
Date: Wed, 29 Apr 2026 12:02:12 +0000
Message-ID: <aafc2d660057a91eb40417f8ff4645b0a8c525e2.1777462630.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1777462630.git.d@ilvokhin.com>
References: <cover.1777462630.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6BF391C0012
X-Rspam-User: 
X-Stat-Signature: zdfycktcnsrfiemtkm3gdt4uii5grxim
X-HE-Tag: 1777464151-490108
X-HE-Meta: U2FsdGVkX18VTDRDIm5kaC7BTqm7cElXGvo5srS4HwlYK0ajoatOvC5y3t3Vc2ff9soMcee0ovO9oak2yq/gCYlUpTVtHGCMPdGdPjCVnNqlBXXf7xNOujC7Zhb+tk/BTASFw1ImeFVGXMMz1fgdB9+kKsszEQDyLO+PHtl+sNOy1geBo3DM6r4AvG2TxG7ilNFQpNTJc0bpi5aow7Fw6RjA8yLDR9VCgqAucGV1EFJrEfM9FakH9q+L8XdSVtd7wr1JEZWnA0ScGtcy0tkBtVHt+XKkaYGAXaGgbdjJQ0Fdar0z7QCLAhmAqg/cKASJph4+Krej/RIp+bHokHNHVlN+rQMDm9ynUTNyUkTAyC1ti2/n4xcwCPAY1hnkoITS8ktAiVfRzgPx0Mse7mVH9BsAiZ/qG3DJxCNYNpMRQCVCVOsJks9nlZhOoKYl1h3HOfexhnHPY7dwciOJJ45PXrWID+qPsp5QMwVUEghY+nlomxq2/R1mSIDu8gGym7Eqhu1JYZ/+Z15GminmKzSdZgJ/POSEMX2wh08es+zENhPRPPo7hXG/tU9wJ1CMsjTDnV86BkYdsfz+XF+BY8xfCxEdMn3/nkmWvtfNi/SbdlQXJvKC3g3BUpTYK/ZsBCy9Len22JQrh9Yzw/lMwWWSSIQqiExZX/hbNADV2oYolEqJKgNe3cCnux0XssBZ3uzke9cl3GNdM8U4n6on241kDlGcNoZSvarp9fjj5EeA3z/y/w6V/pyQNeGtZS9pdfqRScsRFUuoi6qzlSb8GRjb/gP8qoWO6CQqY7MpwdsdaFZri5n3nl3cirSaCmWO3TIA0XP82iBsf80UJyX+fIMQEvyBfxbOqMKtPUzAAzPXTew92Dl3qIbA40g3V2fZNTRJ6LmJrDvg+E2mqj8OyvwQekHPdS1Ron8DlFNwlXTT6rQwzvzNteATR9fH0dH540YX2jnB/sYc3GxKAP/QJvF
 fHGvP8FU
 IQGDu5RAYvgg4bwa6q7Mb0ZC+v8t5v/2uq4C1wo0LsFmsA5Q1t+EX/W2w6rtnn6ecLlPAJwBHLph06nyBpmHI+RO4cu48gUP8xvkPBmyVeSlGccrqY6YVbxMdwcZ9gm++yuHscU/8/AxWasS+uQ1LolvHr65doZ4CQNMX1/goIkZU/PU7Vz3dfKukJiwejUf+eiY0xYuxuE4kb8+cZEmhCQb2CPDeHlbHvO8G0MDVK0lPX9qI3Hs+0baCtVChdtosM5LJlw4L3HCwH44xHayf+EkdAn7n11LVmigdOkoMqbJaWWxKOq/v6XPY/bitQyR+zPJIWo4sBINHLfEQRoAjR2biiy7wFVDmvVl0YM5LIlviDkAYgjsLrbayHRXkArimRn2HYGtQBRqJIrMzlRgxf8ZdlDG0jeBdd57Q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use spinlock_irqsave zone lock guard in free_pcppages_bulk() to replace
the explicit lock/unlock pattern with automatic scope-based cleanup.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
Acked-by: Michal Hocko <mhocko@suse.com>
---
 mm/page_alloc.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 87758fb6a926..27bd316e4453 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1456,7 +1456,6 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 					struct per_cpu_pages *pcp,
 					int pindex)
 {
-	unsigned long flags;
 	unsigned int order;
 	struct page *page;
 
@@ -1469,7 +1468,7 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 	/* Ensure requested pindex is drained first. */
 	pindex = pindex - 1;
 
-	spin_lock_irqsave(&zone->lock, flags);
+	guard(spinlock_irqsave)(&zone->lock);
 
 	while (count > 0) {
 		struct list_head *list;
@@ -1501,8 +1500,6 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 			trace_mm_page_pcpu_drain(page, order, mt);
 		} while (count > 0 && !list_empty(list));
 	}
-
-	spin_unlock_irqrestore(&zone->lock, flags);
 }
 
 /* Split a multi-block free page into its individual pageblocks. */
-- 
2.52.0


