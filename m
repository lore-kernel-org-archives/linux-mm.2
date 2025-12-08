Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5DDCD3B7F2
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 14:36:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0320D6B000E; Mon,  8 Dec 2025 09:36:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F26366B0010; Mon,  8 Dec 2025 09:36:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3A126B0011; Mon,  8 Dec 2025 09:36:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D00436B000E
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 09:36:40 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8C88C1DEBB5
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 14:36:40 +0000 (UTC)
X-FDA: 84196554960.15.3908BE4
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf07.hostedemail.com (Postfix) with ESMTP id BEC0C4001C
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 14:36:38 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=igpgrMYX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765204598; a=rsa-sha256;
	cv=none;
	b=qjnJzvh9j22A5F3dJOaU5fH7BppHITfCWXHo0wnOQco5OvFlYPvO5DtXpWi6+iFVgmxeve
	c5n1HStuC3Fn0n3UemV3mLN0DJcq3eP5FT6W9OJAb1cMtuycA4lQW7JnW7Qi0CtWpdGX8n
	Y+2H1J3RlGE+Vziq3boJTNxnGGgNNxE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=igpgrMYX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765204598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=Wezc8p3Xv4E0oxE4aHMOqrpF+we7vmdd8zjyLCzUiFY=;
	b=8j4IGbURCjkf3NGbo6/t1SnSZpu8XE5fZ/MnLUxvTlWanRiOJljr2sPjMbBYp8a/6W2m7k
	Tzi7pu8Ai0nUGTuL3/XdTczmSfvk/AnTsAk3K98MpAX+0CciSrt4i/7q1NfBEY9Lm6eNEf
	6BWYqM4cEQbQJTC9Nh2AKXgW3PqPako=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6418738efa0so8006496a12.1
        for <linux-mm@kvack.org>; Mon, 08 Dec 2025 06:36:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765204597; x=1765809397; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Wezc8p3Xv4E0oxE4aHMOqrpF+we7vmdd8zjyLCzUiFY=;
        b=igpgrMYXE717UZIB0yn9T7Ykcci2tPQ2ezpkiMlF5tGb4HvSJzsaskbZKsjV5uoY1+
         CDf1CTt3eakvHf5eJozut/HVBrxDUvbCSoRJKzxVmUQ75qGd7tbOrkZRuuRd6Wv6ZAFM
         mvf/utvdBJLgbVYjqgdEMQ/THjaFvMST/8q7kQg5XZTWjoNa9qOCfst0k0gNmzkJzi1V
         Pc047Cijclqs3UzZIHN/HZKJHOUYhmLzORgzzUlKg9zFZY7I4I7/5qkmsYcfveZihta3
         72N9FB4biLWWDDbBYBhvIEhIZ12FfUCAYsNoOln0oBLvtOeDbh/kOrdY5whh4luUIuXc
         lzTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765204597; x=1765809397;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wezc8p3Xv4E0oxE4aHMOqrpF+we7vmdd8zjyLCzUiFY=;
        b=X8G/ok+mfl2WMIdkM9wtpEtxuN8TEQIW8GFidy1O37h7wJtSUSKOHwHvxT9BL9rpD7
         /3KcBhYMJ59+OQUgH1yE/9tEh/7LmyasAJQMLayVwAxbWCRLY+6TTBd5kOXvC3HA2gCm
         fCUhO638xuQpDQAsl1esaVEYnRJUGBKlxSGvefY+Tn+EHhRiNR7jFL1LZAAlYfeTEfjk
         BRpK8Hn+GbM58XmW6hqef4VRwv6U13oIueoMI5ddFjpt8F3L9bzHwA4A/fP0AhEdNqHp
         mcx7HD1+ISzMnDiE7PUfAgzdGmzmfJjvtUp1yMGAvQ60KbGeFXCO6tlqG63MGUqgVTR0
         044Q==
X-Gm-Message-State: AOJu0YwTQGqtkSzKXaWlFAdFgKAJL1ClduBgpzxVZdY3o6eW8J4ws1FW
	mkpz01CYXtNX3M1B0X9CH6NZui0lLB3Ei3qcjC5FCOgbtIA2C2lnEX+8
X-Gm-Gg: ASbGncsHZIvElyTXX9k+6ftis1HiuUYInuZSuz7SrcWjAC5Dp473CYXqJQlIvp4o4Zh
	wGtd4y2/ZKxKg2N44dTOFRgkaAbjKC+eGHUeNqZ6g1bQNOcM8+5GZB5tw03gkq3yqosz6Wl1NS1
	aR8n4/XG+mLAYVAj9HpiFnTgxdWnsFw7VJabZyvWoiNcMJBxfBDnRv7h84AXmJY5fP1SP3hINis
	+SMlCYbw3uhwB017U1G+Hv0RNWdRaonZepAGNUv5fM2QU65rIKA5zJV2Ct/kPIIdWm5DPb0IJ04
	QzAMt6JWSPq+eCd7Ipkyxia0OptOyQS/6ZIiqePx8Sp6vTECuAVvk+8WQPYz5/iGWoifxhLNn/N
	KZtiv+s4bEdbX7+34gC1PPQIGe2kU61mroFjhtYC66L6yvRDj4E5VXLZ34uTNooWFHNoQz7RUj2
	ZJyayDzLlV/g==
X-Google-Smtp-Source: AGHT+IED3qmcRV5PA3ltCUekuMocB/o33Y57cYaQ536ij6p+vAfZpAclqM6ySrue8Lx6LYCDogSmbw==
X-Received: by 2002:a05:6402:34d1:b0:640:947e:70ce with SMTP id 4fb4d7f45d1cf-64919c053c7mr6548570a12.5.1765204597211;
        Mon, 08 Dec 2025 06:36:37 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-647b2c5575fsm11441334a12.0.2025.12.08.06.36.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 08 Dec 2025 06:36:36 -0800 (PST)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [RFC Patch  06/11] mm/huge_memory: introduce __split_folio_and_update_stats() to consolidate split task
Date: Mon,  8 Dec 2025 14:36:11 +0000
Message-Id: <20251208143616.20797-7-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20251208143616.20797-1-richard.weiyang@gmail.com>
References: <20251208143616.20797-1-richard.weiyang@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: BEC0C4001C
X-Rspamd-Server: rspam10
X-Stat-Signature: zka3eqmchtfoerbmwqss1mts5qd6edfo
X-HE-Tag: 1765204598-330650
X-HE-Meta: U2FsdGVkX1+ZVHvXK/FNnuRbjPchSQ+vGV5YjWpkzO0+Q930HRZpJIwc/Oc3FHy8hYMZfkqXlNQGAd+mXDFfdg/TAC1NwGdedxrrb5ryoY/N2ILr3b5e9VTimkzjRRRv7m7ydwfHQ2siwhTFUCTOHRnPBaxLwiYsxUf29oUQ7jOSRU80eCAT8qxzN/YyI7r3XQpzZJZF9bgIUhFlPIlB9No7gesmYAORIoyNYyf+uHOf0Kbg7qYOUFGogmYQRrgHostzT4/uXRndoGhNE0GTPeJO1GHrLjcIpZkplpo6fF24J5El6rFW3HYH/OlVqr3zxyM2NoJPoPs+8tzGqqv1ETB3nGTmi+Y1pAPzFxXFJAaaY0lKYXVEWj0mn7w6CZkCNUSjuFrJLtka8Hg/smGI4d++osow3vmuWtnOuprh0GVS6fb4c36jX0OqzmZe/Hf6EO/9jYR7QEM9ohZ6uUhfk4gziasuQdg7kN5GBwfNqmuPLPq47nru86JRz76fYp7F2Ep6CGJVVlxSsVUX0Juej+QTKn3TJE4SKcKj5mgVD/oJ7HfVzPrr3qh329t/tlxUDG4nk26AWr76SUoo9D5Lx8kVugW1IcgRk5vbWX1LRsPXgPjmSKzy8NNerXD67YpPbtqMdIob3MJVrxQoiLIQ8SswP66uzbIfEbVidcf3QYmKDY7Gy72lgbxod0SkvT0YMJBR2ExBVHeh84z4ErrektAbcOXIQ3mWjrtSguE2BmKNW7UUuIt5CXU47X2nHhls5OJLDq6h+eRvy3QJiAIt4ZLwu8e+/j4/Fs1v8TvuDOei1+EUVzW8ADUUHYktxR52r9Mr7Ri9uReiZu8sFinY6QCJMvxklAWftay2N80ilp/5Rs5g0iwRQ0b71MRfeGRpbT+rOgxAUxTvOlslTRAduSZ5WPF0CdKRjLuRSlVO04eMEalLhRBGdjI17JNt8yWp1YeQUnHsUbibxhnJCDI
 ewdPtwaf
 Ig1aEewXnOtBHS7dy0Yu1upk33QV2PH3E0x9RA+7AVwWwf1QZeuJ7RP7FMM3+r6EWDNcTgYUVqtlhHJKiJ0rLM97JZDYqf/zROOsAEOQtLb2m9WggUAgbRRcqWUMKhzsZzEucqq0jE1O1Ey+FYSMdpQ2zb3svi7/xlNfJgZaeiBmeJpXJbFbdM9KFH8nJvsBok7qqioVwGXQ+xeyJB0sfzPm95xCnLkZtHsI/x/3F+EEiGvXwzeYSbX33W/BdZmLQ2gs46AqnZ/K5M+B0M7Mcbs7obRTBqMO3KM8P8JBu1Xq/VnvODkmkFZZICEpoBF/xAOlQdl2zMP2Y6VIzRuc3EL/46/z6jox2VAKn5N6XE8yhu9tNCnNqrzYMpbAHIrcbN3iSxJdNLCm7ByY3ib4Uw9qjIBd73DX0h4IGWgqf/70XPRbwbmAo388CHnVLvpgJNe1rwfMyawu5o9QcLmfQhQggIhwB/GckFQbctcGNw72LLfVEZCNR2FoWCs+xG2mvs5UtQrS8+wyWCEcusUXPnsVSR8idiJu3ue5dbYy9YmtJZEv2AzJl9k6QKnIoTo7C4H4Oxe/S0iajQsLlyQ1+cchcX6TtBgy6Wa37WOT7zKN1eUEoP0mjReHNV2xD56LXqEvI2sjmqv3+qDn17LQ4muHmvtnvS0mr6fOGQ/+zgVuG2x4i4DyUzmg1HNtFaef7Pe5+WDbgO3H9Ibpg9S22YtTJ5A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The folio splitting process involves several related tasks that are
executed together:

    Adjusting memcg (memory control group) accounting.
    Updating page owner tracking.
    Splitting the folio to the target size (new_order).
    Updating necessary folio statistics.

This commit introduces the new helper function,
__split_folio_and_update_stats(), to gather all these tasks. This
consolidation improves modularity and is a necessary preparation step
for further cleanup and simplification of the surrounding folio
splitting logic.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>

---
v2:
  * add const to nr_new_folios
  * remove is_anon parameter
---
 mm/huge_memory.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 37a73bfb96ff..7160254ce76c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3571,6 +3571,22 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
 		ClearPageCompound(&folio->page);
 }
 
+static void __split_folio_and_update_stats(struct folio *folio, int old_order,
+					   int new_order)
+{
+	const int nr_new_folios = 1UL << (old_order - new_order);
+
+	folio_split_memcg_refs(folio, old_order, new_order);
+	split_page_owner(&folio->page, old_order, new_order);
+	pgalloc_tag_split(folio, old_order, new_order);
+	__split_folio_to_order(folio, old_order, new_order);
+
+	if (folio_test_anon(folio)) {
+		mod_mthp_stat(old_order, MTHP_STAT_NR_ANON, -1);
+		mod_mthp_stat(new_order, MTHP_STAT_NR_ANON, nr_new_folios);
+	}
+}
+
 /**
  * __split_unmapped_folio() - splits an unmapped @folio to lower order folios in
  * two ways: uniform split or non-uniform split.
@@ -3628,8 +3644,6 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 	for (split_order = start_order;
 	     split_order >= new_order;
 	     split_order--) {
-		int nr_new_folios = 1UL << (old_order - split_order);
-
 		/* order-1 anonymous folio is not supported */
 		if (is_anon && split_order == 1)
 			continue;
@@ -3650,15 +3664,7 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 			}
 		}
 
-		folio_split_memcg_refs(folio, old_order, split_order);
-		split_page_owner(&folio->page, old_order, split_order);
-		pgalloc_tag_split(folio, old_order, split_order);
-		__split_folio_to_order(folio, old_order, split_order);
-
-		if (is_anon) {
-			mod_mthp_stat(old_order, MTHP_STAT_NR_ANON, -1);
-			mod_mthp_stat(split_order, MTHP_STAT_NR_ANON, nr_new_folios);
-		}
+		__split_folio_and_update_stats(folio, old_order, split_order);
 		/*
 		 * If uniform split, the process is complete.
 		 * If non-uniform, continue splitting the folio at @split_at
-- 
2.34.1


