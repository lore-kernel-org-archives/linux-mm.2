Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96F51CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 17:56:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF4E38E000C; Wed,  1 Oct 2025 13:56:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACBB48E0002; Wed,  1 Oct 2025 13:56:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A08AF8E000C; Wed,  1 Oct 2025 13:56:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8A9AE8E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 13:56:44 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 602C1139942
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 17:56:44 +0000 (UTC)
X-FDA: 83950300728.03.C5D6CAF
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf09.hostedemail.com (Postfix) with ESMTP id B3006140006
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 17:56:42 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=Qf+EB3vI;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf09.hostedemail.com: domain of mfo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mfo@igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759341402; a=rsa-sha256;
	cv=none;
	b=ZAgETFPU07Y7XN4Vb6mJY8fEOUJpOLxFAkHu1U2e86d+OYZfJK5vCQGjuKJ1rxGvt2Wbda
	1tHq63OO7BaLoiH7YED5s8uq+d/QwG65UjeAwHxYfn688YrTg5TYortyUPF9CBvjlJauhP
	aqBuBWubg8Pl22tKSaNaYBo+Is3GmFk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=Qf+EB3vI;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf09.hostedemail.com: domain of mfo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mfo@igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759341402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d2BHJMm4sslHyidALeIjAD23MeiVl6ZlrbLv4A2t1ZM=;
	b=KV6XP18htT0TRE39quUQZxJNJIKO2wcnjEiW88T0FM5eeXD7UO0Ur38wBWwoq45DUkCirp
	B+psJobVa4YmbgVg8r72vpyLVDQvCsd+yd3JoXXL5u5LWMQr4LBK0DDMmvyxgGLa4xrp/s
	jrsktaPh7lLsLG32yfcJ6Owv1BilcL4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=d2BHJMm4sslHyidALeIjAD23MeiVl6ZlrbLv4A2t1ZM=; b=Qf+EB3vIvufdgNxjmGXzOvYobp
	89qmQvFn2SwESes+rePGkq4Zc6twetH21Kap3KonAlEcE0lfMmviZPuedwyZ+Jp6rGzOce5QxpJMP
	8Jq9ORB7euMY65AZZQuVrV3H0cYq8QjHG6+y44t+ceTbzuE2KUvTkI38NZJViOzkIxm7pUPwNB3aE
	6NsIBon2W35uyqWj3UFqKdgvXNNannhLwvbNGqzt8P8L6kKM18r+RiRBxt0ZGeA2EKJqFdO3MUtTo
	BN5eOTHoutn9Zz3GF+vV5qGXGcnhsh/Y48n/4YgoZaWrG9nqTEosA61IT3MolHld4xgt8xDWXZtuI
	H6D4dHig==;
Received: from [179.159.118.139] (helo=localhost.localdomain)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1v4149-002xd4-NQ; Wed, 01 Oct 2025 19:56:38 +0200
From: Mauricio Faria de Oliveira <mfo@igalia.com>
To: Michal Hocko <mhocko@suse.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Oscar Salvador <osalvador@suse.de>,
	Suren Baghdasaryan <surenb@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-dev@igalia.com
Subject: [PATCH v2 4/5] mm/page_owner: add debugfs file 'show_stacks_handles'
Date: Wed,  1 Oct 2025 14:56:10 -0300
Message-ID: <20251001175611.575861-5-mfo@igalia.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251001175611.575861-1-mfo@igalia.com>
References: <20251001175611.575861-1-mfo@igalia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B3006140006
X-Stat-Signature: gse8aw3ba6ian67fruqrfisndok1krop
X-Rspam-User: 
X-HE-Tag: 1759341402-441329
X-HE-Meta: U2FsdGVkX18NEclb+wYSimGBeQZ16FcRtAMQFiijQmdkLHwQzYH+oe9KZGMMYwrZat5u/wDnAb1d3yLW1HeiqwZgi6oWxE1XqI4JmpPm07WNS0ly8cOmbLAoSmhgRG4U9mSURLP7bStGT2GbtSS6ouvFiGNY93Ufr9e07X6g/u9e0I3VtW4kBeLFcL/ToySimdUO8jla8EMtVJlSkzRUSf5uUIquRlWGBETq5kUsxHIw7QzJKHRpBHGvtsyp9lN2YyKGCQxQ+wHGw8Y54oSGmn1CwMc23ITa295303//2/lcRKqAX9QqRjEz9rn4Wp9CHn/gXHeBUfBxTJMu0m2aghQw4oop7HNkIOWMgoWN5hfZT4siAuRTXTZgDwRpOj8DcSADyG9A1VwBsZ/g8/hv+H/suHxmwZmWgLPesXb0+9GvMUxUChrQsZVH9IVQmMDGUfkUJ42/bppz7fhYCmr4psIqDdSJ4wAQb8xnfJ8gL34j91z3ek2SIEg0SNC1kGpzGi2ySxn+qFwHhIbfr9IPRgmIeZsJO+ksFubTtW3ju/tGibFNUXPVXHkljr2unHYZlQaA5sHgbqq8ZNrKRZiyZhaeJk4U2q/6rurYSsyH2TiPl+MKDCdVngKZIyTpj5ZCrhNAaeR0XMwq6iv7Bi3AmWnwG7AFzw5nG3r8woxeYR1vmJ+f70JmhT8PYXqfeu2LJ9I9XLP+u/8oIrrBfEV5LRldba9jFk8nLb7oiV/wSfxosA1e2YwI32wavY6TK8+dZitLvd1Sf/39dBdmLjfwmzR5KADEzaeCrSIZw+GJ2RZyRKI2k9njEshL/qqL1k9jEjNtCuKbQjFbJNYoZM8YBJvwBz+Dd+4meM4uv+z7Far3uSnAJFFE9m3kbgq8ujkw4MYk0uD1cmtSVCKtfbEDWU2yzcl9cZcYIz+pscVaPXJoBiAe7ZkNMPsJFeytUxywwhTx/nAuyEA0rpB1GAv
 KDe4E1fN
 ZouIjStEfweJ0d9fvAKUixD7zY4nIyZxgjmXNIMNyZEsTP6igHiep09XebBotAwosl/s2WKFYKxGGXcnKTzScdNKzDw6wCT2x+GfKrytFWJYCaMaCNq/9otEjLUo9Aml8y9XI2a9X9Nv55tdLtMFkVitOpEfbmE8kQUfogsoe54rS8PwAsPlX08dJdbIMfLHOq/0d8M8u5ocU5dBPwVAxYdIR94a3ruatIAX9m+2Kk/lfWewvOuoqEuruN57n/LZL3PjHEtUrlqGqhrrbwUlVlF7FXZ9uxzlNWWeQgxqhAG1lU+/Tdzp5Xvlmq0KVKfy4A3oX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the file 'show_stacks_handles' to show just stack traces and their
handles, in order to resolve stack traces and handles (i.e., to identify
the stack traces for handles in previous reads from 'show_handles').

All stacks/handles must show up, regardless of their number of pages, that
might have become zero or no longer make 'count_threshold', but made it in
previous reads from 'show_handles' -- and need to be resolved later.

P.S.: now, print the extra newline independently of the number of pages.

Signed-off-by: Mauricio Faria de Oliveira <mfo@igalia.com>
---
 mm/page_owner.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 5d488fce0e3d..0e5c7bb3e4e8 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -913,7 +913,8 @@ static int stack_print(struct seq_file *m, void *v)
 
 	nr_base_pages = refcount_read(&stack_record->count) - 1;
 
-	if (nr_base_pages < 1 || nr_base_pages < page_owner_pages_threshold)
+	if (ctx->flags & STACK_PRINT_FLAG_PAGES &&
+	    (nr_base_pages < 1 || nr_base_pages < page_owner_pages_threshold))
 		return 0;
 
 	if (ctx->flags & STACK_PRINT_FLAG_STACK) {
@@ -925,7 +926,8 @@ static int stack_print(struct seq_file *m, void *v)
 	if (ctx->flags & STACK_PRINT_FLAG_HANDLE)
 		seq_printf(m, "handle: %d\n", stack_record->handle.handle);
 	if (ctx->flags & STACK_PRINT_FLAG_PAGES)
-		seq_printf(m, "nr_base_pages: %d\n\n", nr_base_pages);
+		seq_printf(m, "nr_base_pages: %d\n", nr_base_pages);
+	seq_putc(m, '\n');
 
 	return 0;
 }
@@ -999,6 +1001,10 @@ static int __init pageowner_init(void)
 			    (void *)(STACK_PRINT_FLAG_HANDLE |
 				     STACK_PRINT_FLAG_PAGES),
 			    &page_owner_stack_operations);
+	debugfs_create_file("show_stacks_handles", 0400, dir,
+			    (void *)(STACK_PRINT_FLAG_STACK |
+				     STACK_PRINT_FLAG_HANDLE),
+			    &page_owner_stack_operations);
 	debugfs_create_file("count_threshold", 0600, dir, NULL,
 			    &proc_page_owner_threshold);
 
-- 
2.48.1


