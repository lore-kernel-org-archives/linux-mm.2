Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF3A8F54AB3
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 13:27:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24B166B008A; Tue, 24 Mar 2026 09:27:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2228F6B008C; Tue, 24 Mar 2026 09:27:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15FD06B0092; Tue, 24 Mar 2026 09:27:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 080B16B008A
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:27:06 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A11A213B6BF
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 13:27:05 +0000 (UTC)
X-FDA: 84581032410.15.669FDF0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id EE66714000E
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 13:27:03 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=s5ZzseGR;
	spf=pass (imf23.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774358824; a=rsa-sha256;
	cv=none;
	b=11xfIxCvQtoa5rbtMmevSc97JZwKs9GdbmZ/bDd7xcuorWR+H6okAoL7l+VUtCJMeXG9NT
	KR6f0e599d2APpsxYzZtkxuzyFsjO2VnBqTJ84ls0HOSWvNcugjCXQnQobVWG/fKDV7PIO
	12lDrNiyHZdFRDNKjBTNi83Lzbvpdzw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774358824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kJS3iOroYXsJrxAKRJJQqOunBpBMGMXkBi8aTqJKmL0=;
	b=YHOqwf1QZwqwmwaOAEOxJq9Y8ifGaZ1ze/Kwgk+gJuq5eKAzDYNHjgBrktHldyQLM2kN9X
	7/VkXDj0bMTQhCnJdPwQ2kZkgJcaLUPXAHVkktYIyCA5yJAdV6Olo3SuD+o+Z/Yn16uukn
	NmYFRVgny62VEtaUn11QnptGELKgTgE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=s5ZzseGR;
	spf=pass (imf23.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C0CD6153B;
	Tue, 24 Mar 2026 06:26:56 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.1.194.63])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 581333FAF5;
	Tue, 24 Mar 2026 06:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774358822; bh=Ia2GTAN1c3MwIjU4lUJMwHz1mGgU70Racq0g1YjJE6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s5ZzseGRA1gs8qALby0g1l4GKGjy1Qp7cx+PS3+ynQOJDMP10D/yyoQ1OHvTRzkxt
	 kjq/61LFc3TC089l2AvWmSO+0nEW0teFeCijTyp1NWeEfoW/1oZeJ9bAuVR0e8ivXY
	 51xIw/Q8egDHqIZ4MzLOzo4KaZq5vaffyPNhtCrw=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
To: Arnd Bergmann <arnd@arndb.de>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Marco Elver <elver@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Peter Collingbourne <pcc@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Ryan.Roberts@arm.com,
	david.hildenbrand@arm.com
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>
Subject: [PATCH v2 3/3] mm: skip KASAN tagging for page-allocated page tables
Date: Tue, 24 Mar 2026 13:26:29 +0000
Message-ID: <20260324132631.482520-4-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260324132631.482520-1-usama.anjum@arm.com>
References: <20260324132631.482520-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EE66714000E
X-Stat-Signature: 5dpitm3fusyyre338okxfswdci7da5qw
X-HE-Tag: 1774358823-629294
X-HE-Meta: U2FsdGVkX19JouV+naI1OByXQOuAgmG3/HFpj/2qEHhMfDro20U81tg/bm2fexFiMyNRMRMoGftu7J1/DtWgWp6pf47SrGn/FzJacIC6kciL0vIu8Ewesds86CAjSUWL+A5RbD4xY+lXxgcrH8AFqgmvBSbQRyloHT/XJ4Tx+qPDoPSOpmjI1+yl5DFtNhH/p1p4Z5bOHAcf1BcZeuAxa+6KAJh6S3zLtuzrrzjfACyzqBKL1MTfbEYAydSWKyLoQqlGdQGmpJECOwN8Zlv6lLra63ZG21aYQ2hfvP/9qjxLLq7TDDk2qF3EcfRiPW5Oyn5kx5lUqs5FDfJKn59yJKPjmPSpPw8t90/4x8xaJD49A86Zzn/EOasG+Cq8u10EjIZJ002fjuQXZz2OIGOhuCxKgYitAOELMXzl05Uk2bTq6+YO1GBfqEoZ1jqCkZXDaMbecSXGjhfnJWGUNmD31Z68cwrI4qyqWAf/VTQRpsL3sTJRqWaf2l9r/bq6+dBpPLiI4wy0Hhj9Jctox47NIlR7MrEAmZQpGEsse3IvM83otnDZ8rzFyJn6btJ1YrfyT6wt31xXYhr6SNXoMVnvTDztNSqhroDX840YqfHpV7BsxTwFovtDokypB6YSR7XonPljwtGX5i5KZtGPZie0NhzzsZZTGZa5z4UyNy6GkO4qTtv34FUUKHsLENv3WkE2grhA/HJhKjJbj/+M5XS+FYziyaK+vv1YtodglIteYWpzAGjRUC3T3RLQeMD3wHrjUsJiZcuOhxBQQZHqIKAT3XA+cf3wlyLjhsTn8OBH45coaAO6DHH2bmD5HC2JTeVWcSRC+k23oNYg2BTwrzK60DCxSwIKr3zOe0e2txubR3ykMcUSHXUfi1mNDsbrHZ7Srmfs5MC3yQ24eOBNNvrS3P+QvjWYGy7AsFeMC9s4x81NhzeGEE/513wDXS3kbvyg1I/I90r0nRi22nJ7Qj9
 m0rCsLGN
 rK9fp73kcmz/M/PBlSAyDJPDOfHR5Ls7yEV6T1Itnhu8tn87PpiaPw6Y+51XV7PWQQlSxy3yn7x16AM1X4+wq1XzakHUgIttQoNSsex7Th9PhA01K/fvFAO2XmpSA7nfe0PZJYKgdIfo8xjQ/qrqIHnr0tHbuFy9dk8dZZC02FE5gXhFMKUYbP9udRnqfl8ykH71ZVcbl1clnx/GCFgejWkM/Ahg3JUcLIzBL25zFQaAquG7NT7chm6HGHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Page tables are always accessed via the linear mapping with a match-all
tag, so HW-tag KASAN never checks them. For page-allocated tables (PTEs
and PGDs etc), avoid the tag setup and poisoning overhead by using
__GFP_SKIP_KASAN. SLUB-backed page tables are unchanged for now. (They
aren't widely used and require more SLUB related skip logic. Leave it
later.)

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
Changes since v1:
- Update description to mention SLUB-backed page tables are unchanged
---
 include/asm-generic/pgalloc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/asm-generic/pgalloc.h b/include/asm-generic/pgalloc.h
index 57137d3ac1592..051aa1331051c 100644
--- a/include/asm-generic/pgalloc.h
+++ b/include/asm-generic/pgalloc.h
@@ -4,7 +4,7 @@
 
 #ifdef CONFIG_MMU
 
-#define GFP_PGTABLE_KERNEL	(GFP_KERNEL | __GFP_ZERO)
+#define GFP_PGTABLE_KERNEL	(GFP_KERNEL | __GFP_ZERO | __GFP_SKIP_KASAN)
 #define GFP_PGTABLE_USER	(GFP_PGTABLE_KERNEL | __GFP_ACCOUNT)
 
 /**
-- 
2.47.3


