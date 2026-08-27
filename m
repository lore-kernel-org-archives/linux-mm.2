Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CAF8C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 03:48:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AAA16B0095; Wed, 26 Aug 2026 23:48:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4816B6B0096; Wed, 26 Aug 2026 23:48:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34A256B0098; Wed, 26 Aug 2026 23:48:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 121DE6B0095
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 23:48:24 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2466AA018E
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 03:48:22 +0000 (UTC)
X-FDA: 85145666844.03.9B9C323
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by imf02.hostedemail.com (Postfix) with ESMTP id 84E9580005
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 03:48:20 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rJwH0wED;
	spf=pass (imf02.hostedemail.com: domain of 3grOPagcKCIM3mlspwlnvvnsl.jvtspu14-ttr2hjr.vyn@flex--wfelipe.bounces.google.com designates 209.85.210.200 as permitted sender) smtp.mailfrom=3grOPagcKCIM3mlspwlnvvnsl.jvtspu14-ttr2hjr.vyn@flex--wfelipe.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787802500;
	b=pwIB2z++mUARvhHF/TdQg48+6gQmVwXFFsyAHqhCSX5Gi2oMafCIXNpx5QP4gVyI6GEceE
	QSAd8YwyWGyaCHjBGfpzSMlsFRQEif/ZgfgXg43nt94gnCLAxm+QeojEk6ZHfGzyL3QNb2
	WhLV9SDcw3+Y05h2Pq5vI43O9/7k4B4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787802500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mytL1u/OX7fzFYMNNheR2pN3dLSUPiAgBvRmO/dMr4Q=;
	b=JobdZxoHPoUqB3TpuRzP7wC0Mmcrzaryo4EwB/fP9DtUcl0Hv7DClJ6vSm/JaNDauS/ZHC
	CK1mPPR/OUa5ZuhN3IsbW1oBckYxuuNBf93ngJidmm8Rs6dVr944aQWKAO4DU9Jghfn1qI
	mvw07BnlY2BBRTxs2+XioPkFYMrETHE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rJwH0wED;
	spf=pass (imf02.hostedemail.com: domain of 3grOPagcKCIM3mlspwlnvvnsl.jvtspu14-ttr2hjr.vyn@flex--wfelipe.bounces.google.com designates 209.85.210.200 as permitted sender) smtp.mailfrom=3grOPagcKCIM3mlspwlnvvnsl.jvtspu14-ttr2hjr.vyn@flex--wfelipe.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-84a67b16217so2718943b3a.3
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 20:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787802499; x=1788407299; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mytL1u/OX7fzFYMNNheR2pN3dLSUPiAgBvRmO/dMr4Q=;
        b=rJwH0wEDYrsxD7yugsgPpwT/wsl7M5+7h49m9fN3B4P0TcW6SzYhGkX9W/r7w9yXly
         /49xNhUiDzg0rJxVAmcaQvv7msvjBTk4AIUcTUbrzUBvKbhPaG1tjxAZbhWz0kaWidcY
         Gabm8AxvmOaxYbikKoQpTLomK3/fQRP4t0jRmTEcp1j/HkJzuswEsRjnjuQ4GQR8GfcX
         gMW/Hr+v1UNiwOqVCPJVQxor4ZSH1w7XkueGQ+lsVUjAnlvmnUc3Wun8hVIjU/LsV+hA
         ZQVNLhNnoZOQgCXb0Z0VBmPzmYgtRI+8Bio1haR+zW2lQw+kMtv1bNiI9ozqhAJE9bfV
         9M3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787802499; x=1788407299;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mytL1u/OX7fzFYMNNheR2pN3dLSUPiAgBvRmO/dMr4Q=;
        b=Dh7w8lqyJTXCp8FUrQPhiHE1drJAROJVY/lUDAdvt7CjQN4OaJcPwfHkN4p+NTCsCX
         NSmkA96ikKJSiisG/oiY++gDqY0bTKm5Ehu1n8BK805vsTEa6/EEv+fSGi3moaiJmzvC
         EQa53YkkNopomWeG/UoGfF3OKhjQg+1mlLV5V/D57IdDELlKkWdEQElcBIlxgMLIjTW+
         l8suYBxj4RXDLnqbID2uBxkoU+Igc2S394Qfh5KTySeHvM7tVqGvpm3kgm8gC6YJd6Im
         Ff4FxWzuwbkR1SAFP1ZOwqBtXNb5Ugg93roikU+NRNGpxNfPW4RXv7k05WR0njJ7oScT
         R5Ew==
X-Gm-Message-State: AFuF++mVGz7JhXVJIbDR18RAZM+GSLMGgEXUBY+xI79c36ZYYW09sOLw
	Z2rEvzFZFshaVSwxyDR3jjlGiG87ydiPlD6VjUmSpZbta5B7aPiE2/E/qdAL0GmgsZPJrxGGhyT
	m9nZtcop2lw==
X-Received: from pgnd25.prod.google.com ([2002:a63:7359:0:b0:cbe:e216:e75a])
 (user=wfelipe job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1392:b0:852:131f:b9d2
 with SMTP id d2e1a72fcca58-853721a4ffamr20661049b3a.2.1787802498954; Wed, 26
 Aug 2026 20:48:18 -0700 (PDT)
Date: Thu, 27 Aug 2026 03:47:42 +0000
In-Reply-To: <20260827034807.2822234-1-wfelipe@google.com>
Mime-Version: 1.0
References: <20260827034807.2822234-1-wfelipe@google.com>
X-Mailer: git-send-email 2.55.0.887.g758fc8c411-goog
Message-ID: <20260827034807.2822234-3-wfelipe@google.com>
Subject: [PATCH v3 2/2] selftests/cgroup: test_zswap: fix implicit unsigned
 promotion bug in test_no_kmem_bypass
From: Wilson Felipe Pereira <wfelipe@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Tejun Heo <tj@kernel.org>, 
	"=?UTF-8?q?Michal=20Koutn=C3=BD?=" <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Wilson Felipe Pereira <wfelipe@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 84E9580005
X-Stat-Signature: 6fjeeugh153tetz7onitak6ufkrekms7
X-HE-Tag: 1787802500-563428
X-HE-Meta: U2FsdGVkX18g7QwYAbyPQO0Oy4fnK05odLQwwtgjOmd6fJdBlReN3JwBtqwsoPZGpQlfCZVWAhOTxSkR6jnRH0HZGDj/t1vnr2+X9k82/mfdLaRbQnJ85bngRJv1RlMO7jAMN1VUiHI1VSMluJEqxbjER5Y/AQpGt+DKwMUDoA0UKt+8OaFR7Shqz2+zmB0aktQa1ZaZa9EtRWirnnRwiQDDkQ9LGGaC8tvfv2qaOlLHwM7tNKMeuHS6v0KGXSN+qY16I12T3nXlyUDRDmt9sm4iSHHErGpiqAUsEcObxivp3oK3KtMYfEJmbgVwF6qiIUz58Fa9R8Uv8IgALPuw4IS82uiUdGB4ZXxTkA0NwztDkyqIiy0u1/hUt2mJomG3nkjb4QJa+Z1XJ9/zNQdUBIcnoRlKrH/mtqchfF82GFbJ2OAE99OF1xNLMUQBmdsWReGDsUq7W5wyaVlOrujl5qomuX6fpwPuZw7krBxz2ST4ZKpuLCWIWxhm+VKuovkkc9A+HUNOZ3sTbLsCanzLVcIEwx2PHj/k6ew150ggHzhLtx2vhXxX714kfc67jkf4eS8eSl9xlOcDCyHLSibuYNX/V92cgMJzkhi5U1olByKgcTrn2WzwdJDaTfHg5anoMFu/rXnN3xEcQx8KhrPxVwHERYlsUA1fcHBSTGO14PX3l2I/ncmQ83VxMrqOQ/VMmN4Q6UWGBo+Trcye6G7kRSEYvW/LQte5/PsEitB3VNhbyWIpq0uRNMZOrEHHXJq8LRYDXB5McKB2Qo44SjALr9c9/x3Soo+HTj8gFOHnR9JwxFfRFKWhx3VjtRP/i/p7GT8TGpKFiWCoyYg8dJT18Y2pHrGAa/hPLRkpzJULSeZCniOXg9S6ads1t5eCxmyVvAlhESsTa93AVSC6aVRplBb83+h/ffpZhGWy6Codhme3A4oojpVSTSdgTbQR6t47lj/c8yZ09r6QZc/gmt5
 yhcGg2wS
 8aD8/bPTgughFpxWv1xuu6AafKpFELXt9+4JhHh/j4bLQZxaraVU9rx7pkt9ttmpwRffDSveHiTi4uyOYWuqJaYtvbY3TXySANPr1TJfLab0kcJebyPxvZQZRULEQhslV0TlRtRnbN3Aq0gCbRZ5lIzjrx5nH35AimN0371DzdaX4gOleLq7oBhPL6Lfo1lrsiUuy1HVv/fhb9eV8+PvFYpg4wk7fnrxE0F9FuoAvW5rlokGZv+NkZPragh5l+dfAuH9thkEqszQuIkVpZGAZ7VpSXMXA7HUfgJacJmcQs7+JirxK1TeFZnYWuLHmX8wC0077H3/Y0dGTUAMbHW9LnKIRWevPg1oGIyaxtOQ4s3/Wxk0NKnqrXPKvo5iW6h0q1be06xQe8K1QC4E44WUnF8K/DBz9LCqD5fXAxnfJ/m6cv66tXDHn4P57lHyBiNRUg4rDS7G55Sa6qisKJPOMG6xyFTs6QV/Y5FaEY64zxDicpdl2YLsG0B//xQ5zIkk820ddQo1xQhqSb7z56juT66FRtXlql9XEYSAbtwwVZdLXhPMlqfKFhUzYKl4kmsViPTtipT17PPQ9SBzMhwt+f/61mQCPDnOvnO6FtSJdUF32mQhiZjcUQySQewhzL0tffX8O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In test_no_kmem_bypass(), delta (stored_pages * page_size - zswapped) is
checked against stored_pages * page_size / 4 to verify that the pages
pushed to zswap belong to the test memory cgroup.

Due to slight stat update timing differences, delta can evaluate to a small
negative number (e.g. -5MB out of 1GB). Because delta is declared as a
signed int and stored_pages is an unsigned size_t, C's usual arithmetic
conversions implicitly promote a negative delta to a large unsigned 64-bit
integer, causing `delta < stored_pages * page_size / 4` to falsely evaluate
to 0 and fail the test.

Fix this by declaring zswapped and delta as signed longs and comparing
against a signed threshold, ensuring negative deltas correctly evaluate
to true.

Fixes: a549f9f31561a ("selftests: cgroup: add test_zswap with no kmem bypass test")
Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>
---
 tools/testing/selftests/cgroup/test_zswap.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index a7ff525c1267..9e7d4fce3af8 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -621,11 +621,12 @@ static int test_no_kmem_bypass(const char *root)
 			break;
 		/* If memory was pushed to zswap, verify it belongs to memcg */
 		if (stored_pages > stored_pages_threshold) {
-			int zswapped = cg_read_key_long(test_group, "memory.stat", "zswapped ");
-			int delta = stored_pages * page_size - zswapped;
-			int result_ok = delta < stored_pages * page_size / 4;
+			long zswapped = cg_read_key_long(
+				test_group, "memory.stat", "zswapped ");
+			long delta = (long)stored_pages * page_size - zswapped;
+			long max_delta = stored_pages * page_size / 4;
 
-			ret = result_ok ? KSFT_PASS : KSFT_FAIL;
+			ret = (delta < max_delta) ? KSFT_PASS : KSFT_FAIL;
 			break;
 		}
 	}
-- 
2.55.0.887.g758fc8c411-goog


