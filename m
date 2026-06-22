Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48445CDB46F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 10:02:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F2626B0096; Mon, 22 Jun 2026 06:01:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C9586B0099; Mon, 22 Jun 2026 06:01:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DE7E6B009B; Mon, 22 Jun 2026 06:01:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1E7C16B0096
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 06:01:54 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8D80C166FF6
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:01:53 +0000 (UTC)
X-FDA: 84907107306.19.633B854
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	by imf08.hostedemail.com (Postfix) with ESMTP id C705116000C
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:01:51 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RKBSoNiF;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of 3Cwg5aggKCFg902AC0D16EE6B4.2ECB8DKN-CCAL02A.EH6@flex--jackmanb.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3Cwg5aggKCFg902AC0D16EE6B4.2ECB8DKN-CCAL02A.EH6@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782122511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9S11xQ2ndprBO95V/I6wL9RKFczfzFD4sM9MNZL9BLw=;
	b=NxtzgJ7tWk8foDUoN43IkwviIKdbi/92+sTM0wrkoPzFUnfwps1ValM8oeXaJmqXOZEa8I
	kaH/repkVWY7kUxKAJKl5820z2IIJQcsQkXB53ghQGxqxeBjkYvZyRJ10qZxDoUciajFRV
	TqOJpQsJERNXXfFjYpjCnvSeOhpLPE4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RKBSoNiF;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of 3Cwg5aggKCFg902AC0D16EE6B4.2ECB8DKN-CCAL02A.EH6@flex--jackmanb.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3Cwg5aggKCFg902AC0D16EE6B4.2ECB8DKN-CCAL02A.EH6@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782122511;
	b=3qjepwMNst6DLNZ6WMoTXBfRxj6eiq1MjdBhxWwp2pU7o4ttTqYHEyPhRFeEahseMc5EZw
	ypiKnyjH9UWJrZZn60iqeWGq8dOEXnt7h/9QD7McW9rpKF/Vhig4vjpw1+48unar6Pc3zm
	lpQUmC0z5HzcQL/ih+TJwhLwcXHKphM=
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-695c6b2814cso4372366a12.1
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 03:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782122510; x=1782727310; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9S11xQ2ndprBO95V/I6wL9RKFczfzFD4sM9MNZL9BLw=;
        b=RKBSoNiFujY4ntrVzYcyhj5mXvorpZdy1guqqx7sRLM2kSOQm2hV+jTLxg78uuDYX5
         mf/o6jKJCGc3+KzpI34hMvKEKXM1um+IP0Fo19+yAhhcklQ9g0rjAszoiZOmU/bFQuOv
         c4B2DuHYPYlInYbPSjzKywGXfcyHwH5fTypk4WRklAac7del3gQOc0H1ukVvozkwR02c
         bMqxb0R1ST/O/irGTINkaSQdcVMvnUo/WfK8iaYltccusM4nXNpFcXmXSlSyEtNB33C+
         JMjojvZxSTKZz0PmwavPC024AJ/163CtzFC5zaICv+ZWqDGGNAbcJ6zbuM53q3aEXqq/
         byEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782122510; x=1782727310;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9S11xQ2ndprBO95V/I6wL9RKFczfzFD4sM9MNZL9BLw=;
        b=lFvxV07g34KpYnXfMo8jEM9MEQEdiFaZvlxb1uLoadHoXhdGRFi3x9ngaxDdTkS+Ql
         tEfGTnJO+cvnPtdxidYTA1jV18c5Kp4rm2vWzvenbD4ZoPC9isYyxq312oZ31U61gZ5M
         dEfmvcA0bWpoifZqZwUONRiho+QfFwfK8QM9JxVJg6XxMR0C+EMNf9SRxeg3nIARqauA
         5uNYaI44In1VSybG2zEuRQUNK/b/90X8v7O9aVGDrt8B0mC2Z+tvDKs+HiTv7FfOjTHF
         Me4OlE29ClbnvJQdVZDV1JBcgzsIkb6taE2l/feasIUX1UVnI7zSu5HnF9DpaQi6ahqO
         ykiw==
X-Forwarded-Encrypted: i=1; AFNElJ9zZ3Il5uO3e3BwUxrpgogrZ+m9XfxcO4jOJG+oJ7LuKxOnIIBy9g5aB4zCaW/aYOITnAR1S+xxhg==@kvack.org
X-Gm-Message-State: AOJu0YxCJcJSz+8caU6g2z3WYXLk7rSESZrxsm/6saNQUxU7XvudXo0E
	i0FUrX1J+jE5d80sRDWmJn+IU4vSvJpRimXV6RRUBY4v76FC2KM7eQAoOxU7WonCYKZnL2N6L7v
	llROZ9fI3Q0fR9w==
X-Received: from edvh9.prod.google.com ([2002:aa7:de09:0:b0:695:de87:8924])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:268a:b0:674:5b2c:d42c with SMTP id 4fb4d7f45d1cf-696edc828fcmr6463779a12.3.1782122507560;
 Mon, 22 Jun 2026 03:01:47 -0700 (PDT)
Date: Mon, 22 Jun 2026 10:01:32 +0000
In-Reply-To: <20260622-alloc-trylock-v2-0-31f31367d420@google.com>
Mime-Version: 1.0
References: <20260622-alloc-trylock-v2-0-31f31367d420@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260622-alloc-trylock-v2-5-31f31367d420@google.com>
Subject: [PATCH v2 05/13] perf/x86/intel: Use higher-level allocator
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price <gourry@gourry.net>, 
	Johannes Weiner <hannes@cmpxchg.org>, Alexei Starovoitov <ast@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, Brendan Jackman <jackmanb@google.com>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	James Clark <james.clark@linaro.org>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Stat-Signature: 58ebo6tw51km8f6a99hyf5137jwg43dr
X-Rspamd-Queue-Id: C705116000C
X-Rspamd-Server: rspam11
X-HE-Tag: 1782122511-98775
X-HE-Meta: U2FsdGVkX1+LdMvTyIbk7V9bynvij6KFXqCc6SicsuQ5aA3Nk0m6X3P44RH5n/8jPvjOJ7eBRmTbtHXM+UycOxpfFznf2CwSo19NNEpIE8GXE8gpHSEJKFrkaOEIDIRk/k/8mYwrsSO8IfqdNgTk/n8WNY8R0u/sOAxrtw3XTGI2AE7m0laUzy/KphpBublc5gsHUcif+VccwfTTZ7iFDU+UI1fjb3lgH8iVSJXJxP5k4+jKjHIMRo5Bq7HL+R2IqAbN+memanA7A/TsqzeeZ6xp0Yyxxu6zSxInBauLTDo90EpEekHIafLju6BEA9X+UNjjNtbnFLia4vXfxmKVxWYKVcXEV1Jb4m8rdQtuulmVwqUZM0F4h9wUxnoenU8XjZCRmF4POAxPycF+ScKXrcMdSA4zM7JdOBJnG1JifXDX6M8wGwuY4j3swlRR2hgm9R38m46ZmeExvdn/A8uQ29NH846uwYKdjBltvzg4czizocWy3jXc1Dqnh6JamQq7TARJJoUctwjozEnXHhB4QDBy24en2gnAqveOp9CtJW+HW5O29uzibDF17NC/rEFwh1JmTihtQIhoKY7Snycj9NmYIhyAwodboSL4M8IXyplKKO2AWZFuuOWioU23jQxiam3P2429Fw9fexNeOrwymgoPj45I1DjmRJlsSwXjZ0Yfo3Ovy0KZGn1W9TjhfTnGXHBnvxtoIrQz3r8sm3X6C+Vj4h5mhvDKsv49vGcPZ8fiwl/clpRak9x7xlvFA3nbq8WTnI3MhE77h9poMORym+rHbXPUXX2I1KzyACH1JU282Hveaac/RTYEtb3PoSCnWgGedXa7EiPU4KCl3wL00SU4FFr/zQwr14GSzn33ZGGBoI6gFY3CZf+JBS//Va7hXWUAek+DUSgmqeGds4XierhPi5gT0YMHnNzpDgAXF9bml7DjTbBLhcWgBMlxx5FRD6SKBLVdRvPozxUVxKY
 aQlkKVLo
 HQCUsWdEmJn9UCFIFwLE0Xgxae+98gJSObHeMkg5XESKT8ILG2UJDFxJbU1Y3AJrbgoqQ2ctE9IGvq9AF1t+tSX7tWZunAmlwRZEtz7S9ht0M0HTRzMUadmbloQLAdUbTjFX8SALNPMKeiOaIbJPVwIBOlRU3VRWZVJJFNvMiZRxwKh4p4+MOMuYMDL4z9khcGextAY859p9CnyqVBJuVa15zbELKq8T2n/FtdpB9c4P0y164e1a2S5LUXJ3fsz31iASy+n/9G+8gE0dVp/vfyow1Y/UDS9pHUliu1HUgM59wKtEJGPUu62Pw6lzbpYLM2/+07ehab24GKoFd29+zl7SypalCSFSx4dMzcFjx1BQRTzp1ykQ57QT9G+l8rdbetnGXPWUMe7Spq31xsb02xF7TqLuQqf18dSYH9WmqvFMsXbEPnx7OZPJv4g4K/hf0WkKJSkr0XFLj2lfYX5QeQgAHfElEAHc+lKCNLBi497scyj7WXc3Jkfv+XXsNe04E7uvoSbD7H7ZcZdPipmdy6LQgedOily3sjIx83yE4Ic9danQBaFREqR1rDd77tHg+4Kc7WvOCJf7IiLm9dZGk7YX0+hrKoRzdIKNOcSS7KbPJLOlYCgIFCclv3nL8OH63pD0c3qvMDtPUGAUCf2cpqHUl/WvigA+InLF6WShoBpfaUndQYU3x8Pro7Ac73Bkm/qIa45y68UMRMcFu8UDtJ08IJEKX8feMinvUP9EroNpV1Ind8mhYhou7QdHEMubGgKRrA+5qOMWmNSr7+h1nWYzk++8NLmRmU6V9SndUX7fiv/gTlwznfhETYAdcKEki0U9B52Hj5eJ9YE53r6Ug9NeZLoBPuqpPZ++1RnoKiWoBWSoAALUTi8C3MNCQukHIb70p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The difference between __alloc_pages_node() and alloc_pages_node() is
that the former allows you to pass NUMA_NO_NODE.

The former is going away and the latter works fine here so switch over.

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: James Clark <james.clark@linaro.org>
Assisted-by: Gemini:unknown-version
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 arch/x86/events/intel/ds.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index 7f0d515c07c54..bbc20a5beabb6 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -834,7 +834,7 @@ static void *dsalloc_pages(size_t size, gfp_t flags, int cpu)
 	int node = cpu_to_node(cpu);
 	struct page *page;
 
-	page = __alloc_pages_node(node, flags | __GFP_ZERO, order);
+	page = alloc_pages_node(node, flags | __GFP_ZERO, order);
 	return page ? page_address(page) : NULL;
 }
 
@@ -1090,9 +1090,9 @@ void init_arch_pebs_on_cpu(int cpu)
 
 	/*
 	 * 4KB-aligned pointer of the output buffer
-	 * (__alloc_pages_node() return page aligned address)
+	 * (alloc_pages_node() returns page aligned address)
 	 * Buffer Size = 4KB * 2^SIZE
-	 * contiguous physical buffer (__alloc_pages_node() with order)
+	 * contiguous physical buffer (alloc_pages_node() with order)
 	 */
 	arch_pebs_base = virt_to_phys(cpuc->pebs_vaddr) | PEBS_BUFFER_SHIFT;
 	wrmsr_on_cpu(cpu, MSR_IA32_PEBS_BASE, (u32)arch_pebs_base,

-- 
2.54.0


