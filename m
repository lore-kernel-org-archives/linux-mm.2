Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC2C2CAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 15:00:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7C248E0016; Wed, 24 Sep 2025 11:00:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2D9A8E0012; Wed, 24 Sep 2025 11:00:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 969B78E0016; Wed, 24 Sep 2025 11:00:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7EC868E0012
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:00:21 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4605F87A7E
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:00:21 +0000 (UTC)
X-FDA: 83924454642.11.0352C5C
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5F5351A0010
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:00:19 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=P+K3BTvf;
	spf=pass (imf19.hostedemail.com: domain of 3ggfUaAgKCC8ULNVXLYMRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3ggfUaAgKCC8ULNVXLYMRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758726019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8QF2cRHh8FytPgxr8dpYOGpJvCeadM1546zJy7s8ewQ=;
	b=v1muBJbUXb6oR8nHwdr5C4li7/JupDfiE+GGvH/V+uYepH25Fn2qGE10jwFYy9944ONjFX
	ORIr1/LxjTXImao+U9grmjx8w8r7bKpoybzmrMDC2PAShvQULLft0KGBBhMqcr1XxN0Vzy
	7008GeHCrx58H/YuJRDCKLCIcKfGMCE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758726019; a=rsa-sha256;
	cv=none;
	b=D3yyg1kRmlQxEnS4P7ASrEZgVdRaVhOZiTlRAkNuJwDdHrNCDtKl5T/QvO9Tj5CkK8V3Aj
	Y8rhH5rVwfE92YYOuxs+NUC7ufJoJmtqmpQAUdykFMs4AkgY4hdMbRBWcrIV0kmbtG8nJ7
	WEaMoA3P0EeKnH25Zq8kHMYmix84TGg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=P+K3BTvf;
	spf=pass (imf19.hostedemail.com: domain of 3ggfUaAgKCC8ULNVXLYMRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3ggfUaAgKCC8ULNVXLYMRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-46e1b05b42fso19988435e9.2
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 08:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758726018; x=1759330818; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8QF2cRHh8FytPgxr8dpYOGpJvCeadM1546zJy7s8ewQ=;
        b=P+K3BTvfDexCJKw0V+Z+zV5GvFk/pKJrunPbPH7n7G4w0ghLkHxQqx8TwBa4q5kXU1
         7mKUayp5lCyZETlaDsRxxQ+0Z7Ocm4s0a6s+IIuDsdzk9IQjjsqJvYK08oim7JhEx1ix
         UV0PfgOZ6S4r6fvCLh75wqUiTJhftt+EwgZ5bL982zSgaRFWJ+p5x1xrt6XIGJq0wUoo
         3W/9tAzDYt3Ilb+O96h2VMrMfCB3C+Gz9+LSnaQg8JMxqBGXIXaYVTkChdxnq4pIaVPq
         0f3PrFVVRgCNXvZQqeKnTl0OT0kcq93ZU/V+LlyGZKbV6FLZnDySxmA0JHIf5eIjrHaG
         C/Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758726018; x=1759330818;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8QF2cRHh8FytPgxr8dpYOGpJvCeadM1546zJy7s8ewQ=;
        b=nnqDwDAyn3V10ux1s4sO6ni53VOqFcuHw6ZdOsyUB/WhGpKytzz0KZLwyTQgTOQjwA
         /9zFY5RwFl0i3kSsV+fIj5U9D8mCG5Ch45azP+BDLKLRO/qKMsQaHhErN1i/Ep+EaNQi
         JJi8K9GQq2XoLtvLHzfuNFxLAkv69ui4ouw3V53NG+vQ2d/yoXqVG3uyHmYi7TfJZ9Na
         0wh42BMrT+2gAoPDFNAulKCGJu/Si9hkA+XkpyuuhL6HYgTxur0Rs0BNt9kq9gF/p2hh
         iSMOk5CZs+oWk3QBx5JdyPHoJ0Nr9E+PlvAi9tLzZmmjRb0ueVVPuzGHWDobV9uVyZzp
         CqBQ==
X-Forwarded-Encrypted: i=1; AJvYcCV31lw8PxNVbmSTkGPikXJsak5MW592zaYBnQXY5pTJR3VmEdiVuQsr25H+45uuAyOHmiE/IjPD/g==@kvack.org
X-Gm-Message-State: AOJu0YwINn3lfuMI+BxKZte61N9sN8U7vsKPrNE+qND+SOekFu1EKIeP
	wsclrIzuYU5aifCDdyibyEICZmq0WEZMDboSKWOiKBe/37H6cQgKbc6dY63UmYsrTQn14QU1rXt
	09k6u7prDrO9dWQ==
X-Google-Smtp-Source: AGHT+IHJnBZBPS1nMKaaZcgp71cKjbeNO0YRmTqlXBuWFLXJWbiztOh0lMCy2GikS/TH3xlbidCnHScZxYe/Iw==
X-Received: from wmpd40.prod.google.com ([2002:a05:600c:4c28:b0:45f:2be0:b17e])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:198f:b0:45d:d197:fecf with SMTP id 5b1f17b1804b1-46e329229ffmr2453735e9.0.1758726018015;
 Wed, 24 Sep 2025 08:00:18 -0700 (PDT)
Date: Wed, 24 Sep 2025 14:59:45 +0000
In-Reply-To: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
Mime-Version: 1.0
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
X-Mailer: b4 0.14.2
Message-ID: <20250924-b4-asi-page-alloc-v1-10-2d861768041f@google.com>
Subject: [PATCH 10/21] mm/page_alloc: remove ifdefs from pindex helpers
From: Brendan Jackman <jackmanb@google.com>
To: jackmanb@google.com, Andy Lutomirski <luto@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>
Cc: peterz@infradead.org, bp@alien8.de, dave.hansen@linux.intel.com, 
	mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org, 
	david@redhat.com, derkling@google.com, junaids@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, reijiw@google.com, 
	rientjes@google.com, rppt@kernel.org, vbabka@suse.cz, x86@kernel.org, 
	yosry.ahmed@linux.dev
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5F5351A0010
X-Stat-Signature: crm1tw86c4rw7odwijmgfypd86gaiffm
X-Rspam-User: 
X-HE-Tag: 1758726019-457313
X-HE-Meta: U2FsdGVkX1+fOXR7fyf7AdOuhIqXP29D6O2wGFuHQGLdlsj+36YrdD37/4T/rOjAbz95yptWhPTl8CBGcI4Ciwc7LbDkkpt3Uez2T6TO/bZaMwwqViiHzwyRJkd/dtSFT3HXLoa6WDiaA1y90o+1hNK6vqoYs1NwDjUkZs4eGyHk++mF4TFbjRXdQM9WxmZD48TnzUozOEuvKK2FboKyqrHhp3dcBt4cbC7q0i4fI0RzLP2x3Pity8AJwYMJIOTztC+teAF5vYOpO1O04lmlE0ZKEBDd3eUEA3A5E/x7hhlCP/dlgnWqufVghDcNEl1QVCgwlFsPJawMdD5jQuYsqA1r2P1zpyYgoMsTsuDSLKJh6a+C9SXvFnRJH5JmiSUrHdjaQue1gUVJ7ucnVuBTr8lrz0RYpVOjp9w34zb/G6q94ZK4+X4lrni7ssDimySbk1HgMNqt7F/Rlfm6qU6Nhtau+CfYeZWWISmuIfXerlDqkQ75pil3w3NqRWo5x2plfInW0IDEdyqZraD1ikGKc2y6AeUhZGzl4ZYt9d7nJuVc2LQlGEyWE4OJStYbhbzB9L7Bo544p1P7hpYz0E+3aiYiw8149xqS12u9NfzFvzIiBKctJCAXuoOycUn7jffZElbkZkzqLJUvwogLJqQ8GH/XoxiC413gaGBWEkIejxC26gJUiNNQhlRbJeiM6vfC0h3GNvU6kw2VhJNYlPXqQ1SALS2SSJ17S6gCAm4PsMMFyNnZSZe83bh0iFlx1ce7pN8EtObuhVPAEiqvYnHQjNk4BzAnDsGPTS0mDkqfVHxcSaAbd5nR2SFYfoQknfBb1g/rdebiKdV5FpS0s9mZC0KBz5h6rmjhd8ThwqdoGfVpF9EuG9LGmmA6MZUVij86uObVXbvYcEA5Ww98wntx9Sfvky1+M5a5oT1KDDibQ84KF2qpm04KFZM0XqXmosSUmFv2zHiY3xdrNkXaPOe
 CMn0TNfw
 uTMiyic4/kW23U7fzKq9vDRTcbrCxZboGoQ7EeZ0MjHjefs7xTs4IpDeGGWYBWG1GlrC0/JsgNvMbkzrrqnjpTzGji3QzFtwa1nN+t8eC/sJwj9iIHuDUfkgZsn7+Ah2JAWKm+qwyzfjQY+03NbFEsoXfXj0LOs5EsxfLj3o8OWS9IjtD5aRmxVhukc+25LHAbj4qyPTeoZrNp+iaGkf+WghPwJkJ6JETEKJ0FcVJfK45pmg5rbvye+xfJQ4iSwCdta2SS526Aq40MUk7IJJpdIVFcmYkBY1mhJDG361Pc7Ctdb2rQ88o4cwV4YAnUITHpHbvOYBgw3HG3EC4OASP/BXuJWDbRjgkRGVJ3dCrzeiREIo683+emghKw3ye8ZGyKmPKYZwdu/SRr2ctCj+UKAzJDnHmky3VesZuntaknPJ4HB1E/S4QviTHMjrU00bUPuVNgMCPc+Up3g2Z42Ehpp1OQwHzQxa32LeuDRkIS3TEWJzeI5eOGjLqgEpUSdOBQ8ZAk8DFVen9D0L8edcZVVifjadcdJRf780qjy9Y9KJUylDgswq1q+j29W5eBtsnSmoW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The ifdefs are not technically needed here, everything used here is
always defined.

They aren't doing much harm right now but a following patch will
complicate these functions. Switching to IS_ENABLED() makes the code a
bit less tiresome to read.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 mm/page_alloc.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 10757410da2127b0488c99c5933422fc649f9a1d..08e0faab992fcf3c426d4783da041f930075d903 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -656,19 +656,17 @@ static void bad_page(struct page *page, const char *reason)
 
 static inline unsigned int order_to_pindex(int migratetype, int order)
 {
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
+		bool movable = migratetype == MIGRATE_MOVABLE;
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	bool movable;
-	if (order > PAGE_ALLOC_COSTLY_ORDER) {
-		VM_BUG_ON(order != HPAGE_PMD_ORDER);
+		if (order > PAGE_ALLOC_COSTLY_ORDER) {
+			VM_BUG_ON(order != HPAGE_PMD_ORDER);
 
-		movable = migratetype == MIGRATE_MOVABLE;
-
-		return NR_LOWORDER_PCP_LISTS + movable;
+			return NR_LOWORDER_PCP_LISTS + movable;
+		}
+	} else {
+		VM_BUG_ON(order > PAGE_ALLOC_COSTLY_ORDER);
 	}
-#else
-	VM_BUG_ON(order > PAGE_ALLOC_COSTLY_ORDER);
-#endif
 
 	return (MIGRATE_PCPTYPES * order) + migratetype;
 }
@@ -677,12 +675,12 @@ static inline int pindex_to_order(unsigned int pindex)
 {
 	int order = pindex / MIGRATE_PCPTYPES;
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (pindex >= NR_LOWORDER_PCP_LISTS)
-		order = HPAGE_PMD_ORDER;
-#else
-	VM_BUG_ON(order > PAGE_ALLOC_COSTLY_ORDER);
-#endif
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
+		if (pindex >= NR_LOWORDER_PCP_LISTS)
+			order = HPAGE_PMD_ORDER;
+	} else {
+		VM_BUG_ON(order > PAGE_ALLOC_COSTLY_ORDER);
+	}
 
 	return order;
 }

-- 
2.50.1


