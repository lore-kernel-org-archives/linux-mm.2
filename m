Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC81CF3D5E1
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 12:54:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EA0F6B0098; Sun,  5 Apr 2026 08:54:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C1A26B0099; Sun,  5 Apr 2026 08:54:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D7666B009B; Sun,  5 Apr 2026 08:54:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 118156B0098
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 08:54:09 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D4A5E160669
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:54:08 +0000 (UTC)
X-FDA: 84624494976.21.3A9FB46
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf07.hostedemail.com (Postfix) with ESMTP id 00FCA40004
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:54:06 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=DlVOpacz;
	spf=pass (imf07.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775393647; a=rsa-sha256;
	cv=none;
	b=v8UpkEZcpwiPgbf2Tqi/9cXpZSO1wmwYm6GJOLU6nugFizntEPCxVBfjBIJrum/b+I6qrC
	K0Mc/T+y61x6FK4LDnpF8WcHejPVwTWYGRhV2TAW0588GSsQKZODGthD1uqayywS85lHHo
	fL1AwBFrKrtH9BgIkJ3nH9Auvt4v+1k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775393647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k9npI1C6XAEv6UQdoRbep1PBwjjWINNu45ua4UkL2pA=;
	b=Sv6kisGz9o9tMAsQUfVPmE/n+h4mc5cRYz7t14/9Scum2ajeDrokupyxJMFy6f7/3CmXLV
	kvhGYLswNVqgP+cJLijqBoHPFg1AH5Ey2G9nsk9bgweEZud5QLUpRYMkcY3M7DjGDvbviF
	P+AqDBUiauI0SrLkKM+lBmojKCL8s7Y=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=DlVOpacz;
	spf=pass (imf07.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-35c238f1063so1898924a91.1
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 05:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775393646; x=1775998446; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k9npI1C6XAEv6UQdoRbep1PBwjjWINNu45ua4UkL2pA=;
        b=DlVOpaczUp9R51oPUKlQxmnT/3iGE+PK083PHgnV5l30sMXMEJ84mmU+Huf4zrOmBS
         2NcUwfq0mUpfM7LY++FqF8yIbx1bU/Ov8DxRgQVPfr0NnJq8LgWlBzAfD6xGPm0kAGB2
         tVYT7PGmZhZjXfiUAfHM8HnS9N5fVledq/vzeYsUDhaXAq8z7DJ6b/k52q2ff2kV5jkm
         BGBmJrEm/J8Yh0Ui0w217H7YnoHXCxnWmc53n2VsrQ5J2FxSPjwhhf6TBNtzLdTMc9t6
         05yQspmmhDYyc/Bkpt9OjxnyGPyNdc0TMUdOP8nz/kCb37o5SaRFRiwROJhxxjbBwBHJ
         099g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775393646; x=1775998446;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=k9npI1C6XAEv6UQdoRbep1PBwjjWINNu45ua4UkL2pA=;
        b=aoMfRIyQ5idm0u/SsJ8nugQDaS6LxWfcWJzYAT+N6S35SFgjAk7/yH5Y3P/z5A05mp
         YPFCvpDq4f+1jMfuK0o+Lp4tjvhabDYYgTOVLDek2YdpbAYmepuZDdKDtO2U2OFksRjr
         l5e6qSm3J4qKp11dBSheDEOy2P6FLLctneCq5ywPjQ8rRSAM/pjjSAaJyEP4QhLskzZD
         i4O2W4SCu0553+Vxpnb1HEUeUIG9Al525uNPc7BOaUM4v+reGC4A+VG8te/ZlQ94xrCQ
         LdTvN/AkvGUCrZsS53jx3GQRI0w1InjelJ1sy+Ud5mS97DXxNuV0cYY4sZEJ0DQvreF2
         Z69w==
X-Forwarded-Encrypted: i=1; AJvYcCWbkQ/xlHP0SML+mlsmxaJMSZa9DK5m3NpaGNnFVFUCNlmrHjY6cAlje8h3uJvNPgGLSK/NrnwQfg==@kvack.org
X-Gm-Message-State: AOJu0Yzo35im78/n1Wiax5SzZBgsyg5uysrnVc23qHeB63d6ueKAalmK
	zpDfesd2or0pkmHbVrP1kIkvzyUl/0zW08trHlahtRBBk4fDIeOjrJkPkBVLidjBaEw=
X-Gm-Gg: AeBDieuYwVqwzBmSFFZaetNHWUzZe51OmmXrTqEwzCQHBTI6YYkrw4CbDH1DqJB2adN
	Ozn5Fgbj3A3iOVn77YQ1WMXscrauRIUUxEHoa4YbW50q1L1T8LoJWtcfHljU9IlPQooaXYE3hK5
	UUgeHnC+Gwh7+D93DmAWCIPWplg0zVjzTBJP/Zdj6zyIOdCrKHS410c9ZXEiKV/vCQ6xUy/Yaxn
	CNmQKZNVWyC85tVYY1Bi9jA9shRcxTaAW5xfhFwoOwYwKeVcoMkNdZtY/dYl5kVufl1rdT6z7vd
	7ff29LWrVT1NrqgfNn2tuEfDaAYFW5O1kd8tC8HkopF2xbUYXet9HdgZBDSDf++YID478T3CFiZ
	hteTxHIKwulAVcAiF1NuMcUVLMMVXpjUQvw7IJOcBImdrRztyW26JYMdCI/3ebjKOLp6KEgi2+b
	gkYU3s8tfGrfdGn0HYedpAr/HrrK/XCeWwtOirJdDsZ+k=
X-Received: by 2002:a17:90b:586d:b0:35b:e4f8:7ac5 with SMTP id 98e67ed59e1d1-35de686380bmr8252102a91.7.1775393645672;
        Sun, 05 Apr 2026 05:54:05 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35de66b4808sm3748505a91.2.2026.04.05.05.54.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 05:54:05 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 07/49] mm/mm_init: use pageblock_migratetype_init_range() in deferred_free_pages()
Date: Sun,  5 Apr 2026 20:51:58 +0800
Message-Id: <20260405125240.2558577-8-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260405125240.2558577-1-songmuchun@bytedance.com>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 00FCA40004
X-Stat-Signature: 48itcc46y7hcgecowstukdsk7ksbebrz
X-HE-Tag: 1775393646-138056
X-HE-Meta: U2FsdGVkX19mbl21Ko7WsSKQ9P6o7gMaZPYWgU/2Q1A7x/flclB6CI+LR/9ff/ooxNYxW/9PL6PYt4EGIWVLuD70LUZGrMeoyFYkQKqWnOiNMSyeOpjeuS3GcXgNakK38hx+uJzYyafGr4bmbouegCYGnYP6zOrSXabUxVUrLcnZDdglPnQ+2B3MINXdL9dlkyTuxIHwV9+elWdsM+Qf659elJrrQ5R5CJ4/wD1sLtCjXZmhubgFESLE8SLL43A3jqUH4ucQtA27cRPkQuQy7fz7Pzcg4GwFehGGOvCdnk30Hc5tWEtsMJfEv7GO1VGNSte6i61KL5al56nHFJWp6OhM6Qvar2OHRrjgfMqp1R9I9rZR8NB+xY/cOvrsOatZrxB0MSYT3yhVE6IjXrgGoddxNNmgLoVOlcms4YL3TJad2dxuQXYlsosC8o7t5ghNiY5tiZlcI9SuZcsNzUDGa5kzyG13SpxnogFLs5mj4ZcG0ggM0uQhP+QvGhOBRY54wAfb+qBy9eah/bFAjMGA6k2HlU3vsSoJwBFuKAYyy0KSe7/sJMdJOvkJYFYgLWy41+EP6JoMnVYYZ9f7qWbMml99NrEk/dy/qsEv4CKOgpSl51VHfESGAbJY0LqvsfYtcMi0EZCgnQLgb63NLdHJZEt/7sotUlmMkPppXtpD513+wUktD1xCcxmTjwfEFhVzNvwAkKVRY+sjv21EEo6q6zzv1/JvxW04lXoeBznmIN38SiOXxN/Wu939zHE80DaM3XhOLks7uyLKObxdQrhS75kWbNM8IEd06TwH6kVrrCyRB4LzIJ8RYXFS1+zzEB0yN6moj3zp90BQg+ElpkDiIaGtSyVa44GD5ETeve+36UyCo50lj0cgcxj/Cx5eMIs8yL2uqGGBhyCXTigweNwYf2CdHXH8uyYadJnjofhqpBZOfkaKhtfwbE/KC64iClX8W5U45Puoit+/8Y3oZFb
 Z0kxkFnV
 zqj5B0zDZVly4AQmDpr+sgiydISWy9aRq1hb2VGoGzrUkElxkE7feV2EDvJXe3NAhTDug11C2JlmCtnIzRsyKaZx4fP2B/kSw2u5/SEnc35LQT0kKYwi77UKBOPKhwqkBuz3rc9eRgKRD50eGg6haSSDIxnNCQpM6x5MIrBrUjI2IOujz2u1w5lD2SH6tuJRHSqsOb2M9fVMKDqJhvmuYJzSWp8VMdsm8KF3B6nP5emdTFid3W7rWi7yRAg5aFM0pJj3TsAuk22mqKHUcqRrVEyaNKVRK1X0SSLxT6N6yLmpClWa4G3Wwiu8vRiVqaJth3ENB8xnFRtvpNGkNrGDVjdM+vW7CdITbJivLiIMrRHIG5ww=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Simplify deferred_free_pages by replacing the duplicate loops for
initializing pageblock migratetype with a call to
pageblock_migratetype_init_range to simplify the code.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/mm_init.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 4936ca78966c..a92c5053f63d 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1974,13 +1974,12 @@ static void __init deferred_free_pages(unsigned long pfn,
 	if (!nr_pages)
 		return;
 
+	pageblock_migratetype_init_range(pfn, nr_pages, MIGRATE_MOVABLE);
+
 	page = pfn_to_page(pfn);
 
 	/* Free a large naturally-aligned chunk if possible */
 	if (nr_pages == MAX_ORDER_NR_PAGES && IS_MAX_ORDER_ALIGNED(pfn)) {
-		for (i = 0; i < nr_pages; i += pageblock_nr_pages)
-			init_pageblock_migratetype(page + i, MIGRATE_MOVABLE,
-					false);
 		__free_pages_core(page, MAX_PAGE_ORDER, MEMINIT_EARLY);
 		return;
 	}
@@ -1988,12 +1987,8 @@ static void __init deferred_free_pages(unsigned long pfn,
 	/* Accept chunks smaller than MAX_PAGE_ORDER upfront */
 	accept_memory(PFN_PHYS(pfn), nr_pages * PAGE_SIZE);
 
-	for (i = 0; i < nr_pages; i++, page++, pfn++) {
-		if (pageblock_aligned(pfn))
-			init_pageblock_migratetype(page, MIGRATE_MOVABLE,
-					false);
-		__free_pages_core(page, 0, MEMINIT_EARLY);
-	}
+	for (i = 0; i < nr_pages; i++)
+		__free_pages_core(page + i, 0, MEMINIT_EARLY);
 }
 
 /* Completion tracking for deferred_init_memmap() threads */
-- 
2.20.1


