Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EE96C624D0
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 10:51:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B33ED6B0092; Wed,  2 Sep 2026 06:51:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFC3F6B0095; Wed,  2 Sep 2026 06:51:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AAFE6B0096; Wed,  2 Sep 2026 06:51:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 74E486B0092
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:51:14 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0211B8015E
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:51:13 +0000 (UTC)
X-FDA: 85168505268.17.E0E26F5
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
	by imf06.hostedemail.com (Postfix) with ESMTP id 494D1180004
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:51:12 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lt9OVExA;
	spf=pass (imf06.hostedemail.com: domain of 3nv-XagoKCFkM4FEE56FIK7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--vdonnefort.bounces.google.com designates 209.85.218.72 as permitted sender) smtp.mailfrom=3nv-XagoKCFkM4FEE56FIK7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--vdonnefort.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788346272;
	b=ioiNyZiWBJRjGnJXLf9B25LViSJ9f0MgNdQXjfLWQx2BJKI9Hmn24m/sGJdsVzNRVVit0k
	hsZV1xpDQ3OLlCFSHVewGZ3zybfQmJ/SQ9ImZ99U4f6Lboo6p9mJDQ5lgOaID0NXr4QjlO
	FLmqGYfTktQSZy1gapQEA3XfT5BnovI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lt9OVExA;
	spf=pass (imf06.hostedemail.com: domain of 3nv-XagoKCFkM4FEE56FIK7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--vdonnefort.bounces.google.com designates 209.85.218.72 as permitted sender) smtp.mailfrom=3nv-XagoKCFkM4FEE56FIK7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--vdonnefort.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788346272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nz0QJrsFl6sXg/0SkB/zVAyOBBHBg8ebGgd7F8eNZsM=;
	b=utixVUysfl3Yd7zGapBS48qYov2UZYE/3ECIQP/+y7wccQCpCDmwuWOVu9JAca3UndD4Se
	V3BR/agJkmbJUodXvcEjyzqoF2HpomXCinPQ5Sr1XiiPkqO4ArlVO96XWH9sr5TZS8Snsr
	n03CYPmAf/F8p9dd/FRq+9RVXE+NC2Q=
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c2542cd4faaso108882066b.1
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 03:51:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788346271; x=1788951071; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nz0QJrsFl6sXg/0SkB/zVAyOBBHBg8ebGgd7F8eNZsM=;
        b=lt9OVExAjSwc2DPdb75/v9ajjKBV1y+rG36izcrm6Od+EHbnUszcuNu6UHI/bMFYEs
         5/irZ8JXlo1AKRKggBhRFk0lsrI09NHRmPkiiAOasAvcTSOcIp/isxeTZfbvLB58gice
         xXyaDOgV+MaSg90ZNvQ/kDMEdBaZyrfcwVz2+HnKAXsSmyjLEohoDa40HrASUZV3zLKW
         hMjLOkm0RF2Y/8cmT8WimVlf8B8Harh4vHGHN0qMJQXbd28k5rGHFRuP0oBKxjuW2tfk
         c1JGPQZEh6tLlmfWOy5/alYtKeLxtGR61iwV3Q0RXWreoLSJSivq01KAxuDgyH5XjV6L
         pv9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788346271; x=1788951071;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nz0QJrsFl6sXg/0SkB/zVAyOBBHBg8ebGgd7F8eNZsM=;
        b=O+zvFRGs8WUKWjURPgf9NQRWOodpPj7NV/8MV3LtV1y7NOdoF5Dg7+kfz+BbEZ4ogv
         PklM7VH8+BwEItyf+OzdWrizlUNptJKRzhbkQa/X0M5B7qvuhSrP6m8b88W60kzuz+jq
         /2fOPCAhip/UGS9MVEuKP+8uWjkm2kjv4xMfp3XHoYATU/Z7cS7XcY5FQPMxHvnqdeml
         1HsrWGEHwssCtMW9bVsKtMbpkmdYz64zItEgf3+CWZsPVAdcB2QYu+Tou5EbVlciq2F2
         YST9sew1tTfttW8lSBE9xiRr0iJEp0yOwDajqtGa4QQUsQIbomes4uvisjt9erwhigQ7
         D+fA==
X-Forwarded-Encrypted: i=1; AKwUvByy4zzNluJCaBz3tfKod/OUe9InK1S7jNGury3ZiHD3E8ywzgkZFdrAuK0vESkXrzSccZlob2GtPw==@kvack.org
X-Gm-Message-State: AFuF++niafD/FE04zxEO4avkOWT/mIa6UuahrYoqZdLwkqfzS8RZkrCX
	KBQsSc/AlR2iFrOOQfx8qaV4Ok6o61aa2BC092SxUt0tEBffazl2cCxYliwjAOYlicaVTAIeXHT
	dTYyZfva34GFJaB1T1sxdTw==
X-Received: from ejcz24.prod.google.com ([2002:a17:906:2718:b0:c25:3006:b1a0])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:807:b0:c15:f598:60c0 with SMTP id a640c23a62f3a-c25d544f52fmr257827266b.4.1788346270231;
 Wed, 02 Sep 2026 03:51:10 -0700 (PDT)
Date: Wed,  2 Sep 2026 11:47:05 +0100
In-Reply-To: <20260902104712.2399797-1-vdonnefort@google.com>
Mime-Version: 1.0
References: <20260902104712.2399797-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.970.g62bdec98f9-goog
Message-ID: <20260902104712.2399797-4-vdonnefort@google.com>
Subject: [PATCH v9 03/10] set_memory.h: Introduce can_set_direct_map_range()
From: Vincent Donnefort <vdonnefort@google.com>
To: catalin.marinas@arm.com, will@kernel.org, rppt@kernel.org, 
	akpm@linux-foundation.org, sudeep.holla@kernel.org, jenswi@kernel.org, 
	robh@kernel.org
Cc: mark.rutland@arm.com, sumit.garg@kernel.org, ardb@kernel.org, 
	thierry.reding@kernel.org, david@kernel.org, danielmentz@google.com, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, 
	op-tee@lists.trustedfirmware.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 494D1180004
X-Stat-Signature: 9krqn7xc1drmt1xcnqoq5xtgxpyskb4s
X-HE-Tag: 1788346272-797987
X-HE-Meta: U2FsdGVkX1/Z/We+adlU9jjhc18fAR54GbVfXhQlAnv9CcJdhyEYtvY37kqVFOMjwG49l8e9/WFGbjRStpFrM34PQOg2IFrKxQHt6HNn80JJ0NL8SrEWdJRJOaY2TmLIwocYGm8lSWrEg2Dw7Y0/jLBXVDf7sWm3LrvaRsfHPYV++WOh9pT2MaLw1QzkZszlXTUqYX7GGInCtW7c7xsOvKLkTdjuZl+cOC9Tn1lrtkduEERduGxPoKfYBbZvC05dtmXOwJ8PpgkLSf7XM/bqiZB/xq27PZ1Uun4M4EOhS0DD16pitZZySJTyp5BqU4A4LhFCn3pogbGKJMzAsbU2o6tdo31YbGYMUQw2XKCU32NenaOoZZ3U+KlybX+eMCDo0M4AmxQttprMdBdl8yx0IcPjJ+SA3mLm6w8I+d7s5t0yDE+g1DR+Wc6PE/5iSNEA4+2wZodd4PhSGOyO1bRi1JaMAazvPpMmqE1eMA8KTLPS/9X16n5lZ23REku6U8EmQVh0KEXfiZZonpKlSB0YkXA6GdY09uTC72FHTQwuv+QbN6UxCuX84kKAhSS3D0Ff7qIeOJDIr1s0mc6BlFgbP0c9b6KMbOlxISHCfwP9REzYl706Z1uB0KL7rNPwDrXUl3hELVZs0FCiZPQTAYdDqbRXOncgFh8b9kvFncRaX4g20W6PEYKy0702aFmW3m3Kpx2oBe4OPVJSmN/6GfSveSQILDNo4XPjRnhtqlpTk1ec1/dG2F9gf1Vfvttc5oEn8MXPTBfbrxehC+Uycja+bXPWYcj4GFjY0u4P5GqskqZv09CXrOlX9xBP7In+2brr224dpgDjj4KmgDd7in+fYaxIa9/VRM1HndrEQWf8EU6IzjN5rd8ax9yT4tniSiK7ff9PH/YGs/EXJeGcsw63kpICZ4N+w0EJbJncfTPsEfwWswb5w0NZrRyEPZw0pV3398xvWc+hjs6CJP9yovD
 ARdpJjin
 /tD94y4zSykCD0jJFv3nuqgc7YhkJ1WUlCcR+wHVKjlKhuvgy2v30XJE0xgUGPUKWESR+kIqX63qk29FV9lASvIQdXt0E0CeKBzhGGCKthFTG6n7CIRpNNJz97QfzPxyDEPCa0GwVgrEZbkAf+ufS1aY9YlQsEvY9CTIX7fvbhjDe75Dh177GLO5CuMg4E7WHlaCfFL8q4ov7nod0R0pncITt7zbHR0PSS98ensk3FbIhPCpwHOsPg6j20KOXVC+GM7RRP6sL4LPyxXx6qdpq3CwJoMlrIyR4QabfuiBv3ztB1tKmvh+klWLUXtv+wKBOmXCYD6UHbF9FQRivY4CYhdwDbq+7J7ij/K37APmqy9DweZPAN+Ho6h/H/acoTTwy4hUuLtBrm80wp7vER0ZNu2a6L6hMFQaG598qLeS1247NMrr3Ehkq1/syNLhLF/Teq6rlWW8gu41ixlWy70BukulQ6hGwD13ao4AtNX5g4eV8ihvGOhb/C3O90KjX3qu0xjXtWc2/EYTa1ga2CQOm93UdLbduesRskuxnAD7pxEeCG0Zy4EsOj/zg7hIlFAWDABB+Tgxmin8SDugX5x9W44w2ToeXwme4RSNkklP9rX5FiXHOnXV5f1YA4CIsrpojW9oWDgadbHOgZD09Fr5ktKGZHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While can_set_direct_map() tells whether the direct map can be modified
globally, can_set_direct_map_range() checks if a specific range can be
modified. e.g. if mapped at PTE-level.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
index 3030d9245f5a..88175c3fa751 100644
--- a/include/linux/set_memory.h
+++ b/include/linux/set_memory.h
@@ -44,6 +44,12 @@ static inline bool kernel_page_present(struct page *page)
 {
 	return true;
 }
+
+static inline bool can_set_direct_map_range(struct page *page,
+					    unsigned long nr_pages)
+{
+	return false;
+}
 #else /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */
 /*
  * Some architectures, e.g. ARM64 can disable direct map modifications at
@@ -56,6 +62,14 @@ static inline bool can_set_direct_map(void)
 }
 #define can_set_direct_map can_set_direct_map
 #endif
+
+#ifndef can_set_direct_map_range
+static inline bool can_set_direct_map_range(struct page *page, unsigned long nr_pages)
+{
+	return can_set_direct_map();
+}
+#define can_set_direct_map_range can_set_direct_map_range
+#endif
 #endif /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */
 
 #ifdef CONFIG_X86_64
-- 
2.55.0.970.g62bdec98f9-goog


