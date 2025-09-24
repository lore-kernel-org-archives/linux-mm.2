Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F35E7CAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 15:00:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C778A8E000F; Wed, 24 Sep 2025 11:00:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDA048E0012; Wed, 24 Sep 2025 11:00:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A51A08E000F; Wed, 24 Sep 2025 11:00:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8D8E68E000F
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:00:16 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1EDBD87A8D
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:00:16 +0000 (UTC)
X-FDA: 83924454432.17.2A93FFE
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf05.hostedemail.com (Postfix) with ESMTP id 30265100016
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:00:13 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bOONPAwb;
	spf=pass (imf05.hostedemail.com: domain of 3fAfUaAgKCCkOFHPRFSGLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3fAfUaAgKCCkOFHPRFSGLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758726014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z2K58t/vrOefSYqdR7POZfHM/E5LlRhe2fvwwEfqIfU=;
	b=giSWlqNTz6ub0lnlo/O30hTOLQO09y9EVlxYI45pStZvKueOoEWo/RssvliSSFhKOwtzLv
	jg+Ck3TxvQHFL28YW2nTOPRdPdJG6dRLIzc7l2DKD3EZ757Zh3nEhH36C9Yh4wyrudpMO2
	TnsG5HCm4BG0P0H7U2HMUORdFEimnV4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bOONPAwb;
	spf=pass (imf05.hostedemail.com: domain of 3fAfUaAgKCCkOFHPRFSGLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3fAfUaAgKCCkOFHPRFSGLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758726014; a=rsa-sha256;
	cv=none;
	b=wlq5fLsz/OdzK7a2/SqZn7zxsZchSZLZ9xOtU3grUtR2Oc7rCk2e2CCt8MTVHzvTmYvnZD
	j/Zk3TLbXr7Qc7Aj6zmhfIgz5g3CQ7jquQ1g8ZJr8YzfjaANltdf6j9BShRZ9hba9B9E2l
	VbG4QlIbgNdeqGMdETCP9YMKgawQg2A=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-46e23a66122so11666525e9.0
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 08:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758726013; x=1759330813; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z2K58t/vrOefSYqdR7POZfHM/E5LlRhe2fvwwEfqIfU=;
        b=bOONPAwbTE52ukZVxMoo4AccRKpZ/D9KfweVvmsof2A36IdVtdXOMQF9l4xWSDedBt
         n7ijJice1IJfYVsDUWV6XItovAhVVMdilK8pC73Ey0YNE75umtFiuMxR9S7Qx6dxKOUR
         Azd5fvbOF5rcIMkBN7714tQMN+G99z6ctNkVXck/OreThuxpe5PhhA5uplC6/CTxMBKO
         lCrYZHp7qDUMAXW7LqNeb1A7/23afJ8ib6Gr1az6yKIYhkha/jej0d4EEOFm0meyAQbq
         XM4ZIuzhjApnPpD7+cAgQa+XM0XHIczxwobCWXIIzbFLGQtwdSKMJE5TnljvoOpn4IG+
         GLgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758726013; x=1759330813;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z2K58t/vrOefSYqdR7POZfHM/E5LlRhe2fvwwEfqIfU=;
        b=tEQM3QpCC95jsFNI9VyiSJ0Ugn3Lroy0QnvZn3MJmT+xMFP3PJjSGHov86bchEZmAH
         squmoXC180dtNqIdYQV0TIekgq3V2uGqdW5irmUyyF9L8UjYYhNa+J+HjGIiYB8jnTKV
         QmIQBHiwt9jRUA2Q+vMItRfRbrInqXZ5nxLGOFy8p2/2KPOWJUgvvpNnEw2hyski0sEf
         FSE4vHb6lXg42rFHT1X6KX77oAlCcKpcLYiUUKDWnRURIMKZmPH8IZo3RZLMuBlP/2r4
         Cb/EQ5xDU41DTYWtzg48aiIZiY1bXpNaogcfvpUwqWBz8WVUUYwZauC5APKy++vtETtu
         0pvQ==
X-Forwarded-Encrypted: i=1; AJvYcCUD6F8aGqpgb3zFXnTJLI457L/MPB40+jJ6/3VVTntSJ9N/MWgHmlkDFRIMMR6zShebqKne1Dn3rw==@kvack.org
X-Gm-Message-State: AOJu0Yw83yTwJsr+g6uiI8ORvDEfreAxyQDViCAJi0Tj9B6oif4+ZAQO
	WgZaLGcWtZgK+9vX0mOA0GgSsiJeStl5abHfFSoSOg6PaoXlkqWry3+modMnHxoF4jyQDjQIwrs
	qxuuVSyT95BGqGw==
X-Google-Smtp-Source: AGHT+IFLbqLP4y9VzvHzeY0NK/ko0qJcgJDnQDoVhaZ1NLWwdjq/QRcEPRrnluk2M64Siud++fEyGmKNZKOPkA==
X-Received: from wmqb8.prod.google.com ([2002:a05:600c:4e08:b0:45d:d60a:8d7e])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:609b:b0:45d:e4ff:b642 with SMTP id 5b1f17b1804b1-46e32a04a4emr1138645e9.25.1758726012269;
 Wed, 24 Sep 2025 08:00:12 -0700 (PDT)
Date: Wed, 24 Sep 2025 14:59:40 +0000
In-Reply-To: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
Mime-Version: 1.0
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
X-Mailer: b4 0.14.2
Message-ID: <20250924-b4-asi-page-alloc-v1-5-2d861768041f@google.com>
Subject: [PATCH 05/21] x86/mm/pat: mirror direct map changes to ASI
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
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 30265100016
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: emfrg4kgyyrj8tcy1cgghuymteagoqo1
X-HE-Tag: 1758726013-528721
X-HE-Meta: U2FsdGVkX19OYSlZjeq4Xz52VJVBTJkKlvRckImi4H06gIqXyolMeVkPPhMBtk5BEMpgk9fVou5HGCazdEMNgzt5eVOL1qnmMmvzkt3r4za/TfQdPnzRUSZm/gYXB+bEPL0EgvsLNM/DR/2Pr3knVQrLXBqQcMnXIVE5NgjZkmKuPsl11xzfYNT0n0tTKTQe4uwEuGYmBHRxdgZ4gbHdDuYMn2kdY5hq5aF+Vbbcn/idU5emqlprXnYcgjkZMM20mAuO9nnPm1nj5UKUu0jQeN/XX1n9XQZ1zrpW+WOzmNJOxRko82ja3oANdPIbnABvGuzDnRIm97J+Wl97WiJubhl37J5E8VPc//nAsDGG6WpavmOMAjGF+VHVKznfVG9AXJf7xsu4f/SlU4tTwA5CUi1jGIgMidkOW1jFEn64b9S3OJIoYP/XXg4MepN2LBNxi4XGjJ1ykT2GpBbk3WvW/ycIZbsObEdAfZpSwLuJz9aA9CKjehzDp0nmISASR4oMUGgN+FJrJPpDXQ2A8rXtnu+mJmk4ET+ZGB9cgDaPahjzZ93kwfJ1lmFHyM/WqQvi1VZMEmKkDQs+o9PgoQ5TslBl4UaX9bdn+aKVocps4qruA+qwilQYpKsT4rfWXzGK7vG/ln9ECHaGID9TSysyZr78NzJGRpVSURcfV5pDlkd/8s+SivQzsl8oMrfDcVWni7RVG818CzqRtn14XIBCUPwrAwmn872BF5OBII0bGD/bwl8xvznI7gisNpUlLP4aWKWcauSN04AXEZZo+Wmrd02y8Xn9nh8iMwEwt9Rx6iZwNv8mXqk92Z9mTt4pFqdAoCYJ9Ay9nTJjxSSLnuu5/I5ut+sV0C5vBZ3CTRus7dUeZ6iAhLPUfp9lMwA5K1egMIuzENwpkXByvPH9LK9pySpZFzQRCZK3gbTIPAYYZbVqbqsDeuNN+DcZSViZ5gnA7F2V8NfLXtFvp0UDsEt
 kd7h7ps6
 K1lNDkfLuBtQ6zlq6OGt9HDdbOrtSE52tjP4uhskHvxxwYUqTleEppxspGka7JFEepX7fWxBjfaQTIryOfQVL5F4/tGZsliV4nJ8HEsNFckx83oUyQ05dUqYSWGkBoeDJ6PGzCRSIlN4m7TDiNeoXXGCOGxuoeKbkcbXbFoynjo1qs9YMUlLICvns4wHdNGd9O2+CJXsRpmwbxDOwYFpVB+cuC5TlAQC8Ro7yaH8ITvv4Lwaox0v+73kfOC4Nf0UVIfvX4AJtQaxvcI6v7rxEAV8YWlfVzGmtPUSiWRmEGoUesmnzDktBm53Rlf8eeOS34dbW0FGBxit8I8BFTh/Ht3sANq+idT75BFsiBknNJlh6JzdcBY9gRx+rWr/I01ttqBZOHwfzMb//eZjUTCZrwohIGiSXxJqSjwJRkLx8zF5SrC5yTG5sC5C36Sj55zKpraT2YnhaajavoJLhVO6l7tMpqykNXlVRkhFZMxBbQqOz2TGRoQxXr1+I4C5xlY/T3Rr/MvQESaV7cgrO77SgWdCRiZL+Dn3rRj0PzTus97cLWru/60bO037gcw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ASI has a separate PGD for the physmap, which needs to be kept in sync
with the unrestricted physmap with respect to permissions.

Since only the direct map is currently populated in that address space,
just ignore everything else. Handling of holes in that map is left
behaving the same as the unrestricted pagetables.

Co-developed-by: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 arch/x86/mm/pat/set_memory.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index d2d54b8c4dbb04cf276d074ddee3ffde2f48e381..53c3ac0ba55d6b6992db6f6761ffdfbd52bf3688 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -3,6 +3,7 @@
  * Copyright 2002 Andi Kleen, SuSE Labs.
  * Thanks to Ben LaHaise for precious feedback.
  */
+#include <linux/asi.h>
 #include <linux/highmem.h>
 #include <linux/memblock.h>
 #include <linux/sched.h>
@@ -1780,6 +1781,11 @@ static int populate_pgd(struct cpa_data *cpa, unsigned long addr)
 	cpa->numpages = ret;
 	return 0;
 }
+static inline bool is_direct_map(unsigned long vaddr)
+{
+	return within(vaddr, PAGE_OFFSET,
+		      PAGE_OFFSET + (max_pfn_mapped << PAGE_SHIFT));
+}
 
 static int __cpa_process_fault(struct cpa_data *cpa, unsigned long vaddr,
 			       int primary)
@@ -1808,8 +1814,7 @@ static int __cpa_process_fault(struct cpa_data *cpa, unsigned long vaddr,
 	 * one virtual address page and its pfn. TBD: numpages can be set based
 	 * on the initial value and the level returned by lookup_address().
 	 */
-	if (within(vaddr, PAGE_OFFSET,
-		   PAGE_OFFSET + (max_pfn_mapped << PAGE_SHIFT))) {
+	if (is_direct_map(vaddr)) {
 		cpa->numpages = 1;
 		cpa->pfn = __pa(vaddr) >> PAGE_SHIFT;
 		return 0;
@@ -1981,6 +1986,27 @@ static int cpa_process_alias(struct cpa_data *cpa)
 	return 0;
 }
 
+/*
+ * Having updated the unrestricted PGD, reflect this change in the ASI
+ * restricted address space too.
+ */
+static inline int mirror_asi_direct_map(struct cpa_data *cpa, int primary)
+{
+	struct cpa_data asi_cpa = *cpa;
+
+	if (!asi_enabled_static())
+		return 0;
+
+	/* Only need to do this for the real unrestricted direct map. */
+	if ((cpa->pgd && cpa->pgd != init_mm.pgd) || !is_direct_map(*cpa->vaddr))
+		return 0;
+	VM_WARN_ON_ONCE(!is_direct_map(*cpa->vaddr + (cpa->numpages * PAGE_SIZE)));
+
+	asi_cpa.pgd = asi_nonsensitive_pgd;
+	asi_cpa.curpage = 0;
+	return __change_page_attr(cpa, primary);
+}
+
 static int __change_page_attr_set_clr(struct cpa_data *cpa, int primary)
 {
 	unsigned long numpages = cpa->numpages;
@@ -2007,6 +2033,8 @@ static int __change_page_attr_set_clr(struct cpa_data *cpa, int primary)
 		if (!debug_pagealloc_enabled())
 			spin_lock(&cpa_lock);
 		ret = __change_page_attr(cpa, primary);
+		if (!ret)
+			ret = mirror_asi_direct_map(cpa, primary);
 		if (!debug_pagealloc_enabled())
 			spin_unlock(&cpa_lock);
 		if (ret)

-- 
2.50.1


