Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7264C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 12:32:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A1BE6B00C2; Fri,  3 Jul 2026 08:32:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 376F56B00C5; Fri,  3 Jul 2026 08:32:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23F446B00C6; Fri,  3 Jul 2026 08:32:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F1AB76B00C2
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 08:32:32 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 888C51A052A
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:32:32 +0000 (UTC)
X-FDA: 84947403744.17.6A78EB1
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf21.hostedemail.com (Postfix) with ESMTP id D72031C0005
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:32:30 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rxeX8fb9;
	spf=pass (imf21.hostedemail.com: domain of 33atHaggKCKwVMOWYMZNSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--jackmanb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=33atHaggKCKwVMOWYMZNSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783081950;
	b=s1E6nFkacdn5JgvFdtG3HCnaWtTXfiJFgTKfjvrECcUwQWsr1QyRarYPPIlZ7+pTy46Tes
	cx585u3SQu1GEFnt87MCaQTNgQLO7IzN3Po0Dtqj+OxWyT+JJnMHdF24i+oMqbcIVAqclh
	nyn7+YfFEF1AJLDamkaZrXPwv/cBLBI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783081950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kyqQt98xw9ATzSToTJPs54AMwBuvYnqZayPicgnewLI=;
	b=qkDapIH9zghI0xAWkyzKIycBW+wenoM2KU46gHKzoE+oDGDJiaXki5LnGjiOSMEy+Eh2QN
	ThLoM6GXYzGVgH4cr+EXuDKY8dMum2YskiFRC+IDfr/qd6ox4SHv1p2PrZuTYa+x0/FFAo
	XiKJE3/jRqBebNBhAWEIp9L9cckrjyY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rxeX8fb9;
	spf=pass (imf21.hostedemail.com: domain of 33atHaggKCKwVMOWYMZNSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--jackmanb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=33atHaggKCKwVMOWYMZNSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-4754fc5c021so379703f8f.2
        for <linux-mm@kvack.org>; Fri, 03 Jul 2026 05:32:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783081949; x=1783686749; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kyqQt98xw9ATzSToTJPs54AMwBuvYnqZayPicgnewLI=;
        b=rxeX8fb9BTt6fqnvqY/TxJkI9Eezsm9HfI0S9L/e2akmlbC/Jz9wCeYyhAMjC8Aml2
         zU4BeVuK8rsZTvQl4HxaF7eQXCvMpPQQXsWiU9Kh0/2uLa4B5Ki2qsoU0dbI7lCJ0b2Q
         3haOrvD+ssFdAPUqe8RLLIXkGwQHAKFxRfO5/TTkPPwMqVjs0TaSDZoefn+9QOLhSilY
         rTbaTuAC7d9Sr0avltOZG9gn+3axc0JcGI7C6dMzAqcAyKiUECtc6wJ+y9RuDTYn6ixh
         8oFTxDzxgxEB5B8MqXV9g+/8mAPvfcvWcQ2VLzEbOhT/1qWPn7cBeRe6myQbTiI+TyeP
         BXsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783081949; x=1783686749;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kyqQt98xw9ATzSToTJPs54AMwBuvYnqZayPicgnewLI=;
        b=Bv6ADphoWGS9L3IZunkg09u8uE3nF/hb8wtwphemhPbqRlQwNFqv3OYbvPqnfNkVSV
         sr+Yg3Rr7mqi43FpVElei8e7JycMAQwIgC1a2VKCgzeF26YMWZV1jj0Lv8T+NG00tfZz
         QbHG0xsv3U+hwVA42G77JpzjBLMN5XyOWIdYnF5CJxNaogtXFwUBcfNjoJkVjYzmesHO
         3VfjBQILahgWc21uvROBWYp810zGhEusu9b0CJWSuhO/BZFjv6KKsZZtptYfwRgIaAew
         dfC3Zg+ojDKoAfh7FaScSs47Fp/R43W26pWyT3q+WBfj24BlDPB74HFT3F5Et87YBWq5
         QDiw==
X-Forwarded-Encrypted: i=1; AFNElJ80AztNXkyIPbjnsbxgiM0x1M3HIc7OoA2gGFP0uXMkSFxYElZmXcY0ZDanoUxtyJ58JDjPde1X1g==@kvack.org
X-Gm-Message-State: AOJu0YyNBX1m9/SdbJ6pCDeh+sw9AOjiDmPGZp8trOn0Ab1n/BipKDLC
	tlBovyqx20q8lBgrsuY118jD3w8uVcMp69WYmCSWJrOEIU24iw8a4QyXgOJRUPI325798M7QBc7
	DxqNmmO64upMd3w==
X-Received: from wmbip29.prod.google.com ([2002:a05:600c:a69d:b0:493:b6e1:bb31])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:5296:b0:492:6efc:7c60 with SMTP id 5b1f17b1804b1-493c2b99781mr138970395e9.28.1783081949082;
 Fri, 03 Jul 2026 05:32:29 -0700 (PDT)
Date: Fri, 03 Jul 2026 12:31:48 +0000
In-Reply-To: <20260703-alloc-trylock-v5-0-c87b714e19d3@google.com>
Mime-Version: 1.0
References: <20260703-alloc-trylock-v5-0-c87b714e19d3@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260703-alloc-trylock-v5-8-c87b714e19d3@google.com>
Subject: [PATCH v5 08/18] perf/x86/intel: Use higher-level allocator API
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
	Matthew Wilcox <willy@infradead.org>, Hao Ge <hao.ge@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
	derkling@google.com, reijiw@google.com, Brendan Jackman <jackmanb@google.com>, 
	Yosry Ahmed <yosry@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	James Clark <james.clark@linaro.org>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D72031C0005
X-Stat-Signature: iptyw1iunaxjio37y3bbwgrujbzf6ute
X-Rspam-User: 
X-HE-Tag: 1783081950-72490
X-HE-Meta: U2FsdGVkX194xd+eHlzIYyMafWgZUKgh4OKltUAGTsQAoAQsLq+QHktZtUI7doFh7QNDdqBPRFgp3rFmWQSzjHTTcIO/5GeuE0pEti4cdCPSHnaLVZ/XbBfGFAMhPW8j0xsv2ATyrsqEer8BETtl9T5gbHYkFhL2EOnVrPmwVMlaeD60T7jkrT4STpjWRWnuqPGouDkICfmYSYNrsNnrxsDH6Zq9OQ0E4y3oGfBavwatlnDIc/jomxabPWB2ngSmXVfDxOz7wv4x6RO3NYIZLGI+8z7t+SKq0lcWBh1Z9KEHjuJwbegplaG7KUC3pyA+IHOV9fS5Dx3+gjvd5CIlkykvExitxeUTedeRCvxJ7agHrJa1MPtN7YUImGrAWM4xxaik3Q/4fQqnSy4OGqo/EkL/mfh04Ke5niVsB+aEPwuIl/9w8mTXZIOpBQ7VEItXooSziTxdyrgBClZ6eHWdDRtBRovXp1ekYeK3r1Pn/J9bd7c4nwfBvDARpCyEqpWOcN6grs9KhQ+vOnJnvE+ggrgCFB+YGYAzqF6yKRa2uWm4OU3xCS9bNm5EqyVJ00T2A+oTAKWsdPRnUsaNj2MI6qfZHqjQ9HAQz/kj3xV/bI3MsRgbpA5KpvY+Y1K3LBC26Or3DDAE1oTGASUljC9T38eQw4kWW6N3ovdd842YG9p4xNmIF19eHxxKpJ65J/KFQqaygPnvXbwBAUr1024hTTaTuBnq5LE4kmjVXEj+zRagbzxBNVQRMRwYnTc363GkM7QHXgMLLYjpCIKrouxdbwHX/ZH/ogdjEAn7yc/G34Z4H03CU+VsSXav9WuhNwqcPGm24dEyLEYFCnyXFbFNOyaf668dyNFWGXnErZ57bZFLZ7xL5uUkWer1gukx1ozGIWynDZmIGkwupAP4g4IyRbTQ25JjhndZxs4b9Mu6zN+qpud9mhCcZGhDeQLGFPV55pd06/onFLZJHzkZOWs
 iiQMwmwf
 YxhMCkLRg/16XYGwwoEGVhzAoclTqqIYMBihpdKRVZrh14vDqqQrxB5c4QnYW0U4RZCxx1OfjbDWo647KH4KlHokgmwyj+qnW3vauCV0enMXuSMPGdxzhZIkD8bpfyBhp9SHk40gR7zjzKcQV1d/3P0dOVwpuu+/CY13Mcy+TrPJcn65uyfUrb6oYSlq45rdMT6VIR5VMXMgDxXVPinayqKYZ+WfSr6z5IOp68D1P7oA5pJ/yGMY76wkcyaynQUug2PQjgfDIOfAKYaWERcOvGWIs9ojhS3/rM3Stj6a6PJTYb9wNJXO+tg/oYchJM5fjeRTDI5OsrVUaXJJX8imK13bhB50l7cEsoKZFsGkIhKD1/o6lpC5k+T/7McsrCVoHnmyk6cEhUbG4dv8Y+jnmLOSgjwNKdh+l2AFPDnAIZly79T/IMhnw2vKzNVbFWNdxZVrxdyKKWOWYjhleSOp7bdGyWZ3cMl3XsRnsYzxhmGhH+FrrvunsFwzPemnUJsY3+N5Qz/srLqZ9v077pZ3rxa21LY8H83dzMmNp1fC+Pt4IzD25lKZDlI/cAl1iOqK8JV8BKKC1eQQdT7BEgd+vUMMk+SQAo+QzckvqPzwKQTukXjiUBbMCNhGbWZrohj2KIcDKykkCZIXYpgZIl5dapl2/hHXwvoDpiMoRC4DWP9HD6y+ks1bv8ApfeA5QHCJzc7d34cJXnT/WHhdxK9EvPOA9q6yJTZi3bKLpKj0pcQJSN6wUwnieAE2NBO+BM6fmXQ3Vbwv++/o6jQCVWO6wKsM74bxRDa1LqkHI2mhVVLRPEgkkasEVstVlGGsEttL5V++G502vxJMbJnWTSlSMKv4aTT2XCSj+jQ+ksn6+hlMmu+5cD/zxAJQpeLDZ0LGisgca
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The difference between __alloc_pages_node() and alloc_pages_node() is
that the latter allows you to pass NUMA_NO_NODE.

The former is going away and the latter works fine here so switch over.

No functional change intended.

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
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 arch/x86/events/intel/ds.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index 91a093d8cf2e7..70be80211d823 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -832,7 +832,7 @@ static void *dsalloc_pages(size_t size, gfp_t flags, int cpu)
 	int node = cpu_to_node(cpu);
 	struct page *page;
 
-	page = __alloc_pages_node(node, flags | __GFP_ZERO, order);
+	page = alloc_pages_node(node, flags | __GFP_ZERO, order);
 	return page ? page_address(page) : NULL;
 }
 
@@ -1088,9 +1088,9 @@ void init_arch_pebs_on_cpu(int cpu)
 
 	/*
 	 * 4KB-aligned pointer of the output buffer
-	 * (__alloc_pages_node() return page aligned address)
+	 * (alloc_pages_node() returns page aligned address)
 	 * Buffer Size = 4KB * 2^SIZE
-	 * contiguous physical buffer (__alloc_pages_node() with order)
+	 * contiguous physical buffer (alloc_pages_node() with order)
 	 */
 	arch_pebs_base = virt_to_phys(cpuc->pebs_vaddr) | PEBS_BUFFER_SHIFT;
 	wrmsrq_on_cpu(cpu, MSR_IA32_PEBS_BASE, arch_pebs_base);

-- 
2.54.0


