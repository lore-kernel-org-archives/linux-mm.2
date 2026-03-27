Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B350D10F284A
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 16:15:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7B1B6B009F; Fri, 27 Mar 2026 12:15:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2C3A6B00A1; Fri, 27 Mar 2026 12:15:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1AE76B00A2; Fri, 27 Mar 2026 12:15:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9FA026B009F
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:15:12 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 32CD0160281
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:15:12 +0000 (UTC)
X-FDA: 84592342464.27.AF0EE46
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6ABC2140014
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:15:10 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=xKidylPY;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf09.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774628110; a=rsa-sha256;
	cv=none;
	b=y4opUTaeeNTILTkKAi7+BfYKLDmMXtQ3uZY2mDL/P7svDo3eaAMSRo6VTdxJSxC07VWd55
	+dGsRJsfp5TwcdzUxjTYipmoEEnzJ1i0clDTR1vus5GW8quoXvaYRekEWohGsctWnStiaW
	6mTqNDxWuqVix4Lh5AXmJoYfNwJdFBQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=xKidylPY;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf09.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774628110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fc1DSdx+1NGpsx6DxTUmGYyzLhousydXBN7+P9M33vM=;
	b=J7kW5lu0lJNXfsdfvGYJklGAcYDaw+H0vcyva7B+3tPpY9k0UCkpbfwYgBJPANmpylUBpr
	PWuIik99TlMEgjrjYQYUfvRprZaBfTCS7bkNkl9KnAk/tYa8S+N/r6IubH56tjlM5GzwXq
	sHO7sMCZmq4fUtARHQedfBAavslsNSI=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id B7AC4BE009;
	Fri, 27 Mar 2026 16:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1774628107;
	bh=fc1DSdx+1NGpsx6DxTUmGYyzLhousydXBN7+P9M33vM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xKidylPYRrg81a+LWdvitx5WGKoZmgJNywFEWcboptqVf1GBb2Sb/+E6ZHh/sfmiy
	 6fB6qIH3UyK9DVvjuxxeDjiNMMja+GNJBVlFUy7viezxSQn0skOFkARbveVS96KqQJ
	 6Ea57l3JeVdeeUgUwClPeVXubOyqbejjG5RTYPJc=
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
Subject: [PATCH v2 8/8] mm: use zone lock guard in __offline_isolated_pages()
Date: Fri, 27 Mar 2026 16:14:48 +0000
Message-ID: <894e4e6ab3a581ccb43bcfa4c2b7c1c38e1193c3.1774627568.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774627568.git.d@ilvokhin.com>
References: <cover.1774627568.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6ABC2140014
X-Stat-Signature: fw6wrqeqoabkrcfz8urr5wqg3eypaopn
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774628110-773717
X-HE-Meta: U2FsdGVkX1/fDF0SaaU28AsIP1Z9cx4ivY7XlmtJIQqQbz2zCS9mWMAlcU1HFZpKwIcilGjYceoAohpuRzB1QPi78Py+LiQUtXGRxe+e16aK5FDhTTidSKiZgv6ryQTBfHZS3hPoooCc5BZxvR9qG13zeNbcQ3/JSL9Wyj1EsMHlHeH6P/dK9XKMh2sIqJekwQ4s4d4upGxy98rdUKByb1IsdOmDqmVfUtSkaqjE80cMqEeLxvN3DeZ+TtMUkITdslkZKO6g6KE9Ib1G1nistNOy1ih45YLCj3eqwpnGueiDWcfKRvq169wQic6mxFXYT8tjjW8JFpMrCEWoN0z6GF6WVfiU9D1/5IsGgS3hQSyKx+VavDQTPNgnEJPzMK8MQ+H7mGyCwBYmzcD3aRMp1EiNloisQKggWNEiZKaDu/smmcYgku4RFWUGrfZDkUFkHshwAtyiPBhKFvDC8meKDVPAdlWvTqm34FtbJjlpXSKHT1V57Xxu29Vjuv5LZbVwWHq7D8Pvy+Xv0dAb19ZXuqIAAN2Am6O0PD5YzOoj1B2NmyYfPmW7cNQungIoJO/ozg4bnV+zk1lws8pJcj3AnZ/F5VaQKFnSn20a4fdUzkojnNfhML6Q5Fd4b0m8Vi8eGjhlVpPCk0+Ew2rhcTRveEATQCe7gtAL4M7QiUkrHpJKs49h2NVbiuK0K84DDk3eeH9zVXNH91Lwxfyqx1OwM1/cLISe2/m1oss53Wkk1n1kQRqUKU2CUnXo7oANsTrnLDWEqO2nEks9ycwBuUKtsxjcSN+LURT27Xrj5fnX+JX3Ulc/7xS42X712FP6D7LJNdk/tUxaMoSGTSfXXPB30lH6/AYUvpw4iOGrloEokEpXJt1yHDDYqGRXGLzkG4lTG1pT2Fy/kXHQUViuvtvWwy2LQb2fgOzbT6eDZjqCVzqyk9K6Hysthr/1FqXVd9KGsIClAXfIb4MnZYom5qd
 1eigFlkE
 eI2r2NyVJDf8Is+ES92aab0Mz1LBCVhCWro96j7P7Fxe2BrYxyvAualy+699LegnDt6Ss7bfGGX/2HlaUI+yPKBEDUhRPcQKqs/7Za07GPTuAsNow1nnmhva0vuRFRi5KNBeV7QyX/Zyc44qKw6ZuPWh+sdepjpDdE+Nde0PVQVmQxZQpaxFqIVFXtHWKLu5esO45FKI5MDITEuYJfnCjii0emLPR1FvgvuimsRpvAOp3ywICPeRCk1go+JY7czr4eiNSulEQF3pUthqqBotl0B7M1ZVCA1ea6Onylnv/E4+CFn6qcmT9aqGRJO3mq6tPluvtFbEDj6ck3rhD8h4wYGhertHk9hoLmObA
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
---
 mm/page_alloc.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b00707433898..6a679995b9df 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7375,7 +7375,7 @@ void zone_pcp_reset(struct zone *zone)
 unsigned long __offline_isolated_pages(unsigned long start_pfn,
 		unsigned long end_pfn)
 {
-	unsigned long already_offline = 0, flags;
+	unsigned long already_offline = 0;
 	unsigned long pfn = start_pfn;
 	struct page *page;
 	struct zone *zone;
@@ -7383,7 +7383,7 @@ unsigned long __offline_isolated_pages(unsigned long start_pfn,
 
 	offline_mem_sections(pfn, end_pfn);
 	zone = page_zone(pfn_to_page(pfn));
-	spin_lock_irqsave(&zone->lock, flags);
+	guard(spinlock_irqsave)(&zone->lock);
 	while (pfn < end_pfn) {
 		page = pfn_to_page(pfn);
 		/*
@@ -7413,7 +7413,6 @@ unsigned long __offline_isolated_pages(unsigned long start_pfn,
 		del_page_from_free_list(page, zone, order, MIGRATE_ISOLATE);
 		pfn += (1 << order);
 	}
-	spin_unlock_irqrestore(&zone->lock, flags);
 
 	return end_pfn - start_pfn - already_offline;
 }
-- 
2.52.0


