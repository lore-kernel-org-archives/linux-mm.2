Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF0F9E9272A
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 14:13:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 287086B0088; Mon, 29 Dec 2025 09:13:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20ADE6B0089; Mon, 29 Dec 2025 09:13:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EC1E6B008A; Mon, 29 Dec 2025 09:13:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EDCF26B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 09:13:17 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 939C4141335
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 14:13:17 +0000 (UTC)
X-FDA: 84272700834.05.6A13060
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id BA80940004
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 14:13:15 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767017595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=foHDr6tTVVg2N+oq2ubI3TwM6NJy7Osy+6nFP/DCYQ8=;
	b=hE/Y/KgMPvfzeJLyFMzJiz+L9JzhMuAr9BnhTh6yDMBLp0Z+TOiHv50dx04zijD5ylrTzC
	G7AwRFbh5uRp+0lz0pwhshZomUQSQg/AD8Jp9nNi9R1rw6VutSGyesBth5OFQhY5EjxCSG
	ZO+Im2xxeMk9mrqV4oTvVWvkwpHO71s=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767017595; a=rsa-sha256;
	cv=none;
	b=7GnRUYAkoV9mVPjU0iVUd5p/cVjAYFgO31luV6w5kwgFm7remzCz3JE5WSymGmgxAs2L3i
	6rYnX3745KBeJqRMcTk0eEOSU2qQMMuB46r4t9neA9xMhxuYy7wOVule68EF9ASzSuS1xw
	QmnDpt+kWFXxbywu/8xMhGWepcHG6MU=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7b852bb31d9so10684289b3a.0
        for <linux-mm@kvack.org>; Mon, 29 Dec 2025 06:13:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767017594; x=1767622394;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=foHDr6tTVVg2N+oq2ubI3TwM6NJy7Osy+6nFP/DCYQ8=;
        b=go3Nj0yOJ28oLMqUXPw+c+NBtCofgF/nxJeTL93etY+S1xXv7Mq5hNCC1CLhgJeYvE
         kHwb9t3IoNdFrU6fQfsbOB73e4c4KTQzBQxKZFioLO6CZKxLNmS7ejD29E4owCs3c/t3
         MGcLbSAGgJPgQraDQm4siYidxDWaRfyHlGVTU0pu9f6K6ryNJgM6GSixu8PMzPWpz1hM
         +6WjB1LEiLc4IB0oFN3DAAOcdFQL4gHkUYJSNmMLvblo9KwfQK0l+ub2KOTeU59y7qlH
         KLhMrWsLZ9l81848VgZL/OEDQyy6GNkDqW6qaXKCzW+YXtdj2WPfzMYIob+gQaBi87tS
         udWQ==
X-Forwarded-Encrypted: i=1; AJvYcCX+UrEbBoZWBzeF5gVL1vouWCqq9ogQ7tGljGD9Lufozr95WnafqMbf4BH6NGftEeno4YoNnfIdgQ==@kvack.org
X-Gm-Message-State: AOJu0YytVXjO5C+2NswhEpvoBOoFbcWuxbwGjir8MP0rxASpeHeXw6nH
	6DEpxlm3rX/s/DdXXZixcfP+ziQjrgIYzK9u+Kd0g00aT3gEbqConMNz
X-Gm-Gg: AY/fxX61SQrtBGyzyzE1Nw8+R0j8yMtloA0ceQG8a3cQOLPgoyXKquNmLvXntCKFDxJ
	pQDYI+MEDj+Dmu70bxPwW5AuPcTFtkHXe+gezTYKz53DNL0vPqcaELsMhRok0jqGA0aAJVUpE64
	SRBmTRZzgS4M0fibz+4Jh64EgM46pywhhXL5KGZw1X6RpKjdXOh9VSbXLNdOnN6QXSD7yHdXJIo
	l9GXzE22RVel/t/LcdOvjigFKgZtXonJahESAHfgT9GUhHXQKO05EKhJ3+V5OBXM4L3AQTyjWkQ
	Pkac5wkL/0r+t+LVRs37bsT1AkZKGq6E4NlNMaGXqApYPhyAxXAeg6maE8jwyS1k5AnP9+ygOSw
	isAKj0nywZnilebxp/1jcYF9o404wCGKdishDleCyIGj/VXRi3HDmTsflq206cLXMFSD/FFYGT6
	x7P8WorG8IVQalAqWQCjiA
X-Google-Smtp-Source: AGHT+IHjQ5rl02KKPHQhO2WlxDrubU3tUX+Dp23WgXVCA057aOMTV2/+jAKILyQh7BNfdVe+rKUfAQ==
X-Received: by 2002:a05:6a21:328a:b0:366:14ac:e1dd with SMTP id adf61e73a8af0-376aaff9943mr29756512637.67.1767017594482;
        Mon, 29 Dec 2025 06:13:14 -0800 (PST)
Received: from EBJ9932692.tcent.cn ([103.88.46.167])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7a93ab3csm29472636b3a.7.2025.12.29.06.13.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Dec 2025 06:13:14 -0800 (PST)
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org
Cc: will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	peterz@infradead.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	arnd@arndb.de,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	ioworker0@gmail.com,
	shy828301@gmail.com,
	riel@surriel.com,
	jannh@google.com,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v1 1/3] mm/tlb: allow architectures to skip redundant TLB sync IPIs
Date: Mon, 29 Dec 2025 22:12:43 +0800
Message-ID: <20251229141246.63435-2-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251229141246.63435-1-lance.yang@linux.dev>
References: <20251229141246.63435-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BA80940004
X-Stat-Signature: 8e3m3m6bga54m6pf14y4bbajmcepxrsk
X-Rspam-User: 
X-HE-Tag: 1767017595-68085
X-HE-Meta: U2FsdGVkX1/E8gzWZKtrNmGzEBQqfKAO8ho+DVV1bEm9WhdmdVkGabfNVMbO04lNXKhFSNLWK476t8/PhGHTFTkdFNOKm54Uy4jyHz9Dw2sci6I4XKLR7tNKzpW39LZ+j/9zrlbJ67nAD7M1nmc6x32fbDld77AoIztcpbe6j6oclUkQk5g3LS8J54CPSZNNI6hDKHUQjP3sakcY7G9bl8Wg9wrEskL+rXBsaJ8sBE8fnCcLC0E/8dsHXYw2kVnxsXFhT4xqLvHggN1itbC1CxaEJNmcGSwZBND+gW/OvB1dAlXAA3jonN4fsBxp3nGL5ax3K8QidDSpakyW0PTt6j+yQOg3TDJfGVaEqq98muA61tDORJlwhJjymOvdbbFGsL72U91HE7++62km4k16UVLUr7S1swQlbcfQcVnldxf/7gTiRcmWo2NdNI1UGUrxApL9g587Bbq2XMpUoVN8HjwcqiRV/5R81sN+3BkScnxRdUOvtqejI6ROTaQ+2dq2Vuff10+XDwW73rS22gHUz2qYsWYaqU3n8MhKwSXPryOFNbT1uhupl+1LLxI3gd73UDIIW42ElRKavEMxb2MtX1mht9ncgISKQH2NF1r35jk1PJaZu0Gb9JJ9siJLWkERErDAu638ara081cUm97vK8YJsDa0owTvGv7IiQR4nsukONzMwsuq7MMjeaBkSnFt0CuO7fba4rR563kBfnDuHCoMLjvj2HfSy86Sk/jPhj19LjSnT3fvvgUGGluhUtgzl3eLXwWe7fxrrOxbabm3/nuv5YvvrQnxLduT4DBwulDa0DxOUN16RqiMyd2chyf9nzfQ8c0+XphcH0ygXqvUr2GHYK3dzzM0DoNTjjMg/ASIPIMkOOXb5irV9UBgWXNgiG7e8M10Pkq7U4m6/CyMGP+977lRFBfUqLPsmASMhDq6Dkabl9O11E2BuL19LLtOXEcQBd/4XImpi09BLwP
 HXokE+qO
 o9w8sZzplDRN29/F2AhP585trYJ20ogJ2UoRsEnddEeqOKqDFyxx3ClNi1GODrJB6h+EK311fZLwFhYUv+lL9dKJNLBb6FfxyWf8e4Fj4val3bi0xFlw+ix9i7hpAuQMMbVs3ZMd4dFir1khJaA6nQlGi7mPzzz+1Zb7awCbXgzHMo0kLehNzrYIVvMD7D8csxg+W8bRKigugWx3PXmARC/+Zykx3gBfr7mV1R3urGChwkoWpHJxwOFaAs3iQU+0Czbe6kZDSS1EupImcfC7bgFPOL9H/NEHxFtrGX6cp5n556VGdZBRbKhWEg0/gk2sHa+ug2+Deg/NB0VoSvexa8o6O7utsVWcYR1QBZ3kaQmaHnbCDhxVWf07Hw9eSj1gt7gDGGTeFSfhzlV8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

When unsharing hugetlb PMD page tables, we currently send two IPIs: one
for TLB invalidation, and another to synchronize with concurrent GUP-fast
walkers.

However, if the TLB flush already reaches all CPUs, the second IPI is
redundant. GUP-fast runs with IRQs disabled, so when the TLB flush IPI
completes, any concurrent GUP-fast must have finished.

Add tlb_table_flush_implies_ipi_broadcast() to let architectures indicate
their TLB flush provides full synchronization, enabling the redundant IPI
to be skipped.

Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 include/asm-generic/tlb.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index 4d679d2a206b..e8d99b5e831f 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -261,6 +261,20 @@ static inline void tlb_remove_table_sync_one(void) { }
 
 #endif /* CONFIG_MMU_GATHER_RCU_TABLE_FREE */
 
+/*
+ * Architectures can override if their TLB flush already broadcasts IPIs to all
+ * CPUs when freeing or unsharing page tables.
+ *
+ * Return true only when the flush guarantees:
+ * - IPIs reach all CPUs with potentially stale paging-structure cache entries
+ * - Synchronization with IRQ-disabled code like GUP-fast
+ */
+#ifndef tlb_table_flush_implies_ipi_broadcast
+static inline bool tlb_table_flush_implies_ipi_broadcast(void)
+{
+	return false;
+}
+#endif
 
 #ifndef CONFIG_MMU_GATHER_NO_GATHER
 /*
-- 
2.49.0


