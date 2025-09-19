Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DB09CAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 09:25:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56E91940009; Fri, 19 Sep 2025 05:25:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51FA38E0008; Fri, 19 Sep 2025 05:25:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 435D1940009; Fri, 19 Sep 2025 05:25:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 30A4C8E0008
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 05:25:39 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D5B9C1405E2
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 09:25:38 +0000 (UTC)
X-FDA: 83905467156.10.042481F
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8245DC000E
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 09:25:36 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Y0bmY6ku;
	spf=pass (imf28.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758273937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=oB0ZWPbK+ZLVMGEIgwgPI2hlWSIgxfz6oD2rkNKtFKE=;
	b=KesyTxy/ixOXcSVdQMLbaWmorNh68lomfOb2MQ/BOc9zsOf1pWAxzWc5uqbfColcSLHmmo
	3O5HL14Fes9h/k4JV8d1lI1cN8TwfVR6uaiB3gDnEhcIPGfzffJ6098UhsKsUbd3rGnZor
	x5o3aGgAH+uZ0jtJkN7aw1uAklcL2Kw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Y0bmY6ku;
	spf=pass (imf28.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758273937; a=rsa-sha256;
	cv=none;
	b=TwPki8/mpqzPe6jE1jJhxV16GevhxqtZbWbn9xshpHNA44+7TYPcD6+QRSFUiiH+c7Gdrq
	Sp9lsNmSxYDOpvkCv5qyjGO47I28LQI23lMH72U3EBjHqnejmLqLi9QDdaBNtMJw9dkA8V
	kjd3JP7UWQM8VGfe0XuDuzNu25+BKHA=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-329a41dc2ebso1483212a91.3
        for <linux-mm@kvack.org>; Fri, 19 Sep 2025 02:25:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1758273935; x=1758878735; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oB0ZWPbK+ZLVMGEIgwgPI2hlWSIgxfz6oD2rkNKtFKE=;
        b=Y0bmY6kutKfQV9WYbhVwhY/+X2ml6qPzarLsuHelHjOrrxagq+NfW+n4SIyBUGVE/N
         sVMKPVIdNp9BRnWuQqFvbPbpZf1Iqpx4tcNqkXmUrwC7uS/n5LIWYE0JSQkju3pxKbkt
         kVvbE+K4qlA+BXEf8q0HvWjy+syKF/zRlB3SXdMqvtB67bmg4LChjjaHyhlgz0ZyE4tj
         WHxchg/yo6oiC89tAbwhnHMwtB0r3+f1rvVSIURTDGiEmwgFfFqJFCsX8YFzd4txdGBR
         G+BorbgwgfiT9oFWN98e1S0x0F4/KrOjIPgjD1x0oIYxCOkEV0o4qZq9Hy4roOqJ0WzW
         i0fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758273935; x=1758878735;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oB0ZWPbK+ZLVMGEIgwgPI2hlWSIgxfz6oD2rkNKtFKE=;
        b=GyS8aerhCB8bB1SKynrzLikPqjhJsXLQ4688I/X7S3c+NVFo+qmp7Rzoyf9XcbxQaR
         lKXqQ5/VmheVzvsq4wFyDegQtYp9DR3XNWi5IMA93c4FNuHeOVknUOx/QuwanGmMUkAx
         RMvcjo2Z1RCSsC27KwZoqNfysxd/kQCal4eVz30kY5KlVWZnPCYlDQ0hCpnwj3IKSQ1u
         SQ1X8tAESHAdzj1cZlqrn9JF7pwOIjNeieuqdj+Sy/ZI++f/vl6AV+hG/SpHz3HzCwQr
         L9EsLEzi1okrKu6V8b353ArMLLLaWkvJi0zd/YneD2TTz0yfxv4zmG0p49QL2kopZMaf
         Z3Qg==
X-Gm-Message-State: AOJu0YxJMXjLeP/+uo+HypQ4H8dWteYf60gXWcy0JqzfeX4gbt96lC2r
	BvtnEZwHIHi7RoGm6L1CtNINzeNqEoUnn5mmohQP4bCeQbZPT7HR48IzvmM7CBVk6O4=
X-Gm-Gg: ASbGncv1MSm+OsVZHUrqNo5TXGVn0GIWwKVZVuNbn4Fjfk+tNWltwMS3oj9XL+LE06A
	5lyfZxg2SnTa9dtcaVkkUM9DPmVfsEY/CYfZJkVHKU6pWSUrVRQJUsfTet1TJ33rk8wc1lV97T/
	e2n9ml4gSHNawjy8rPu55RxXxDpVFKXME4Q9XAlxr2rdpcDMcyecFZ3H/pRj6OheEZKAJLZ/r+g
	B4k7u6wpFKCkxznTbO85wJfhlJZ5HwMeKfpSsmSNq5MV99NCuV/KDB2bBc8Jpn8E+9S0MSm+aUR
	U4KSc0Y231i1VYxuYbnIF8psQCCsmq5P2vR0Aea8kEiKV6c/IKNVbYg+CvoIeRbJR4Nx95HN4nl
	EH3SBoeyiIDijWsikFIdoyDQliAL7ac/QCm3WGsp4LQMLpUWV/w==
X-Google-Smtp-Source: AGHT+IFddFvkF2BlBIc4LZkzrbMcxGq/6wzM3FTHdUvbu+vJro5USlOZqK6qwg7qJ92ZmKgdLsf5DA==
X-Received: by 2002:a17:90a:ec83:b0:330:797a:f504 with SMTP id 98e67ed59e1d1-33097fce4c3mr3315076a91.3.1758273935039;
        Fri, 19 Sep 2025 02:25:35 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.11])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3306061925esm4958387a91.2.2025.09.19.02.25.31
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 19 Sep 2025 02:25:34 -0700 (PDT)
From: lizhe.67@bytedance.com
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@redhat.com,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	lizhe.67@bytedance.com
Subject: [PATCH] hugetlb: increase number of reserving hugepages via cmdline
Date: Fri, 19 Sep 2025 17:23:53 +0800
Message-ID: <20250919092353.41671-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8245DC000E
X-Stat-Signature: nrry8qu4n6z81dtxzeogm7rco3nahqs3
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758273936-643676
X-HE-Meta: U2FsdGVkX18hoeFUT/+2do7Z9lb4p1aU4n52Xr4Zap6vuVUuIgsYTaSTYkjekwJK/QmQNX2ocsMqL7b6uJwhIRMwkEGPHt1KMABKFATGSrjoXWe9aDQpdnzrQ8fRVCkC0y90c/DvgDM5O5A1prdaUmsafB7PR1ibwTVA1bG+kkqsteizW49bgSLl/N2Ss1Kt866Y0b2MLpA/ivGexQzRrzsWoEBSIoAqEX/WhMZTFkyGnXBhgywl0MH5oMapUf6FeLZm8rT4B8zmKUOiukGtBiZxEz9wXWi+QlT8D04NPLWWppV1xajMa7avlcd3X+OxotsaV2NPKYvb2SJgrAk8olmUlxflIzO6p6BllygLzRojPtkWK+m5QwiRb/rXi7SIIzYrVPUHR0fpE35MerRxT1fv9apagjpcywidpPRK9qa924YznIQihH+kk+aFLZQ2qICxCKYinM95MGKXzoFUP7P/9VJnPlJ0MhVBwnPTiU7O9+FLOWb4hDNlu+W3a1Jpf4CIyZvVpKK0A6VXZ9JLhN234J3KKztVv9floTkCXPGKUibMQRq4j7HkGk/JIyRZN0xJh3819/oeQAomafUaciAhdUoSaEjr9WPdF8LHpA9+CDymUCx7V2kIu/RH3Y4NK/7P0NG2LJdNqOk8ahGd/WYKeQ8Dmt9pC9drklpfjwfAx4c84evahw6BnSa8hew9nKb8EqX+54rHui4xs/aZhdibvGsXEd+5Xz60FwpGFTuENhjhWlR5Ipqy8l/8/ybiOb3BlvWAMXtcFUIVZ13Lk7SGElBJoz8FZdgmC292MMOIV/C7UcPmNMrRNc2NoiRuUnlYiO4o23A9AO51jULcmhYGca5moEyExu0SKAYfh7pfPmSbTonkDhCJNOrEpcMpH4cYqlc+lyw3djuSfofqepZOTCVAcUqKPq2eVRGmnU+UovfmAthmjqnCVzddpHJf8F8EO5KP4ngqekADD0c
 4aYgs9S/
 hcWyTg8in/YW2swD9bU7hoxdqTGXjleMYzK3c1OlqgydvAXhb3em+dDUxfIvi91PZCaRXHjUCHuuj7gKgox8BBEQjj8g6088FXJPsUHD3T71/afQBBF6hJPI1up04aJa6oQ1032ppnzDeI3dUR0Yd2lXKBane8YWealTWpnTu6S/uKj7IsEmxF4OsDTobrneaV/IuiBX7fyQ+ZwlXSpByAzJiOploORmgMgMEKMwro2UGwbCGnQE8ZuKD/kvKY+LRKG0FwnlRP7/5Sfsre8kC+lwoMkcWqjXpsYQiW/l9LHVRLJX7dh56UV3u89UK8Zj4Kw8lSKsozjbjyoZeSqmliYtr3w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Li Zhe <lizhe.67@bytedance.com>

Commit 79359d6d24df ("hugetlb: perform vmemmap optimization on a list of
pages") batches the submission of HugeTLB vmemmap optimization (HVO) during
hugepage reservation. With HVO enabled, hugepages obtained from the buddy
allocator are not submitted for optimization and their struct-page memory
is therefore not released—until the entire reservation request has been
satisfied. As a result, any struct-page memory freed in the course of the
allocation cannot be reused for the ongoing reservation, artificially
limiting the number of huge pages that can ultimately be provided.

As commit b1222550fbf7 ("mm/hugetlb: do pre-HVO for bootmem allocated
pages") already applies early HVO to bootmem-allocated huge pages, this
patch extends the same benefit to non-bootmem pages by incrementally
submitting them for HVO as they are allocated, thereby returning
struct-page memory to the buddy allocator in real time. The change raises
the maximum 2 MiB hugepage reservation from just under 376 GB to more than
381 GB on a 384 GB x86 VM.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/hugetlb.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index eed59cfb5d21..fd44690878a1 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3554,7 +3554,14 @@ static void __init hugetlb_pages_alloc_boot_node(unsigned long start, unsigned l
 	nodes_clear(node_alloc_noretry);
 
 	for (i = 0; i < num; ++i) {
-		struct folio *folio = alloc_pool_huge_folio(h, &node_states[N_MEMORY],
+		struct folio *folio;
+
+		if (hugetlb_vmemmap_optimizable_size(h) &&
+		    (si_mem_available() == 0) && !list_empty(&folio_list)) {
+			prep_and_add_allocated_folios(h, &folio_list);
+			INIT_LIST_HEAD(&folio_list);
+		}
+		folio = alloc_pool_huge_folio(h, &node_states[N_MEMORY],
 						&node_alloc_noretry, &next_node);
 		if (!folio)
 			break;
-- 
2.20.1


