Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BA85FF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 12:02:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F00E16B008C; Wed, 29 Apr 2026 08:02:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB09B6B0092; Wed, 29 Apr 2026 08:02:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC69F6B0093; Wed, 29 Apr 2026 08:02:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CD16C6B008C
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 08:02:30 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 13C321C0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 12:02:30 +0000 (UTC)
X-FDA: 84711456060.08.1AB3303
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf14.hostedemail.com (Postfix) with ESMTP id F0C1A100028
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 12:02:27 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=HJk4NYXB;
	spf=pass (imf14.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777464148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DPNfuYFXh3MO60WD+H/lFLrfvqe7g44VnNFXGNd28pc=;
	b=JYhGxeJEeXu0hzSwyiROBp0mMS1VLj3/mNrx7SiPdf2lXmfIvJyQnakCIdwtrXfQxaBzup
	mmDenXvFwn/gHjIXFGywtI7v5hBqYMd6axa5XaOo2js3lgHnB0JXz/Ijk6Cv4RJ2l2nDG9
	vUNMyfkcgitKZbbY1Hzy9lNugc7AaoU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777464148; a=rsa-sha256;
	cv=none;
	b=jErJ1meBVGnf+/hTWXwNLkKAbW6DHZnTlyg9nH+p9V6sMwdAr1uz0CeFgVs7/LGwsYLemR
	CJ6NmQYrW4FHoqwDYco3TG93m3bsOUcd5WKVNTOnGdK9pH0nuOR2/iTpsuH0mHISP4bq9r
	+Fh9q2QUzpbJ1df7ryFsL61FveJMt+w=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=HJk4NYXB;
	spf=pass (imf14.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 0DDE6C7A78;
	Wed, 29 Apr 2026 12:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1777464146;
	bh=DPNfuYFXh3MO60WD+H/lFLrfvqe7g44VnNFXGNd28pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HJk4NYXB+4aZdIUMmjWBVDbviaOo9UmC12ZEX+ZWZlorvoEgtW1jK69ku+buW7b7t
	 NU7inhpoS4ZZZ4YbPQaYkf51BmoCIjCuzsZwfuoRwh4+EPsO9Syidlcf7WsZXR6F4+
	 xjDsEtYOt+PeqQJsPJ0JFWxF/BcpGsd39HwwkV2c=
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
Subject: [PATCH v3 8/8] mm: use zone lock guard in __offline_isolated_pages()
Date: Wed, 29 Apr 2026 12:02:04 +0000
Message-ID: <13149be4f8151e18eb5f1eb4f3241ab3cffb373e.1777462630.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1777462630.git.d@ilvokhin.com>
References: <cover.1777462630.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F0C1A100028
X-Stat-Signature: o4qaru54rxc5eqfrfxfrdymoe797ximo
X-Rspam-User: 
X-HE-Tag: 1777464147-893668
X-HE-Meta: U2FsdGVkX1/hYL2HQpwCqPAopEryyCFDgmjy/2A9+FMdhzwpMryynmubDBm56iD+fP35LQogPtt2CGIz6tz1WOMBSGDEB/3mpYEOXm55ag54jNUB872xpU0K9WNYqXcMmG9No7vkND1ySOT/jq8EFvbylioB//d1eE1x1XXV7x2DjKQJ4bleTn+1PnQJXbs7ESwbK505VaTXxE0gYbSKpfrWOEKtHlSL54Sb1CY6rjfp2n0yrIOTXBNOUvLcl2rTe9FvtSIUtJxV7CKztxCyKQ8+SMVEsnURD4Uiw5i0aQXhJYQOE1RdMd2++TNX7VPR12cjdmVW9CoyZPbBE0JzZtJ0PR8snc0O3p3v3JKdxC+q5r99bwXwa6NG8/8j7i76O12BG1eWRIVoDXIuHdrdmuMLAH+9MmiKLE0Gmsr0s+6Cp3XfwQWL2c6LybcJ/wmFKH+TxEVGqxrPfvTNzku53cHNDWgAdQ0fELpOFyUOc5XIArA2su+HmWEBIofDNxgXrvdiGUuLG2kl2gZPFn0Q5uPOtBnSHEWSOqsRKskCajfenhjxr61ueqLlyNPZpstSzot1qpbMb9OR1Tfp6WvezvgfrxL/WHX5/SbB33sosCqNQiBxir7+ay1PQKKRHlb8pPodloy4tMZPX7Hlu5PIBasYDhFlFMwOL1sXpGezDLEs5VrdLoqtK8EF3h9hagcZvhcKugiNHljn+bVr2nuEmD179BlsSWxbY8UL9omz9LUGRR9yobTGQqmaiOKnuH93jZ4FnugRrEKh+J/AvJ+4ngA5tfSt3riDddASCQIozcKsMweGpYEzalESmgQdESyE0Xwyf/DzJW+ahA00m8D7A3pdThE7+ofvMGhWFOSv4BWlW2jakiLLFTfEqX5Vv2cutOGYm6LgTJAtt91KxS13qlOksfhHOUbrZ442z5TViV2ypitGJaBNSynNFgxoOrXjGwq+/eCyt5KSvr1IDqV
 1IPfphmn
 mWVE1m9GKL9qzuJl19RSxgpldwMxAjy1/6flRRgnk4ZZZ02gKwqtZrxAU3PP9FQBJLB/zvocShhmojsmuvAtbaXihb4qmdyggk0/0lYUu3xC3uxmferaMIwX3o+w6OWM02wJgobsKJFgA9/DaiJIBOMK6N28F6LUFxAaJMR3jIw8rX9CJ9aQzaFgwWRgcJ9kL773QSDKMkUYIh21NuTz/SHaq9rpWIBckcdi2olD6dH+42Xr09/xqA48uJ5nlHLHuhdsnetBIOFdK7y91ONmxQzZmARhrnSuGNvgI//8+AiQpGSPfqdHsRO/ehsOvXM1wKvG0OQctYfiKZ/zE/UnGJfd8Jz066uo97xgeVdIYj+5dnuLxYxnqQTk/7CD8wFaN3k+NPSyYDO2AGXESpC0oDC6BNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use spinlock_irqsave zone lock guard in __offline_isolated_pages() to
replace the explicit lock/unlock pattern with automatic scope-based
cleanup.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
Acked-by: Michal Hocko <mhocko@suse.com>
---
 mm/page_alloc.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 27bd316e4453..8cfec846203f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7358,7 +7358,7 @@ void zone_pcp_reset(struct zone *zone)
 unsigned long __offline_isolated_pages(unsigned long start_pfn,
 		unsigned long end_pfn)
 {
-	unsigned long already_offline = 0, flags;
+	unsigned long already_offline = 0;
 	unsigned long pfn = start_pfn;
 	struct page *page;
 	struct zone *zone;
@@ -7366,7 +7366,7 @@ unsigned long __offline_isolated_pages(unsigned long start_pfn,
 
 	offline_mem_sections(pfn, end_pfn);
 	zone = page_zone(pfn_to_page(pfn));
-	spin_lock_irqsave(&zone->lock, flags);
+	guard(spinlock_irqsave)(&zone->lock);
 	while (pfn < end_pfn) {
 		page = pfn_to_page(pfn);
 		/*
@@ -7396,7 +7396,6 @@ unsigned long __offline_isolated_pages(unsigned long start_pfn,
 		del_page_from_free_list(page, zone, order, MIGRATE_ISOLATE);
 		pfn += (1 << order);
 	}
-	spin_unlock_irqrestore(&zone->lock, flags);
 
 	return end_pfn - start_pfn - already_offline;
 }
-- 
2.52.0


