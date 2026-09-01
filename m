Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 934B2C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 15:19:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0AC46B027B; Tue,  1 Sep 2026 11:18:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E21A6B027D; Tue,  1 Sep 2026 11:18:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F8236B027E; Tue,  1 Sep 2026 11:18:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6FF186B027B
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:18:59 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 82C2B40187
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 15:18:57 +0000 (UTC)
X-FDA: 85165551114.01.C57C848
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf14.hostedemail.com (Postfix) with ESMTP id B6E9B10000F
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 15:18:55 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lWe3aesf;
	spf=pass (imf14.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788275935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dzuzRQWzKhh9d8u5tb9B8Xmk/6ykx/rwaytUEdjFAyo=;
	b=aCFOK2I+EPCGAsnIFZ0y1k/wC7XjAYATjTdj1ik0oMj/c80qfqV+ncbZrRnqaVGSsv7vS6
	0CRyZOSD+Tb701j9m0jot1sTdC0jBq0CcWffj2bkxKkLwWkje2AyDL8fhtfAaeeoK95R/i
	+HW+LxA4VnuEnrdjLd7lfRSZXZBZyX8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788275935;
	b=GvLQwFsta+d/8lCBg/vuimqJQGDWCjTVEPUSg1RLQb1zZ9sDO4PGTdxiMkhr4hIZC4TbpB
	lcQbNT4fxWrvx3PH7aARjxDo9EvpMwnlQZi89LJjjl356NSsRfpdRJ71ATIpX3uwvm62PX
	7Da5G+3qfdbVOYnLSYNaNWmWQpHM0wQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lWe3aesf;
	spf=pass (imf14.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-84a6f026675so537675b3a.0
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 08:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788275934; x=1788880734; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dzuzRQWzKhh9d8u5tb9B8Xmk/6ykx/rwaytUEdjFAyo=;
        b=lWe3aesfYQ5nPJfFgI4AGQhDE03zCrt7o11Jg/Ew/B6DGNF8BlsWu8aa2u5D1wMwFh
         9JxMt2F2PPXh3U/MD0EM7o6/6DfrhzDsJZfkRAqKC57pWlIgVsNJoZwadu/uzbp+mHSv
         WxYBJHZs9t69ujLeHtQDTrBfsM2S8QdfdwAtzg0nJFdOvIrxiI2znLebjlaLJtLFcSRG
         bJKn4t5RCmuU4MekmVhpf6Jj6NKKPullgUDlA1sSrfPykg9B9hmpEG4zulXMwhDZvOWH
         9sKAwDWbEsBKYGra4gig85uz1/rab0xZC0Xvz9LSBu1moWbC681RCyetv/Ja6PvDRoko
         v7Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788275934; x=1788880734;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dzuzRQWzKhh9d8u5tb9B8Xmk/6ykx/rwaytUEdjFAyo=;
        b=YQXoDE6EV1oxBJ5fknPIHnTb11Sn+aLOYAdAX6FH8/OPK3cJ+sEj3q/B0dRqi5bxwO
         hs5JYByIDs/+TQjnqYBntBO+k6x/es37bgHiOfr2GkEqEbdC8w23Xu3UoBtfBRHAorlG
         E+BrNuzNGtww5QXkG600uW0HMY9hRMxdTUxoogzCjZTYVXbNehsdW8PhqFLm4xzV3unu
         WsHegZVgyDYFrvSYSvGshtqeGGfcZSxBwzwZxKr/GW4T4Kogsl+5MRGhcsQ/15eo6B+D
         Ix9jTneMUZcdrCSjKdDfQUZ1TS8QOEuc7NCbGj+d2Qw6mje27tTy2cxIATRXxu1PVIr+
         T8jA==
X-Forwarded-Encrypted: i=1; AHgh+RqGd2D2lqmDifxDCADBtZhmxH5M4vw6UUzoQokDi3ZvQKXWvprcp4n9yLb9X7pwhhknvIJIA0DBdg==@kvack.org
X-Gm-Message-State: AFuF++mtrl7DdKE3BfmHlEdbf9D/eNPXqzckuG9sx4DmhEb42BVF6Lla
	aaoCSDiYJmaE4jFISGobqCoQjlYzWsX1D7C1ZpX+ujhI8LwiLKsi6qrw
X-Gm-Gg: AR+sD10q37bC+DjmbKSJg3wrZtkThsHZr7B0NA8vJviHY3TPIYyBq9v0RZH2owYuVTX
	4lH845iohoM1jD6yhGCrqCry0GwBkPnYhBRXhGOIDDsLLFWCAXQO3Mn0gWubfV+daTDtRd20KOK
	7nbOjWKluJCpFbV5dBBbYBHmr8/KyCQMsTU/XXPx5k6U7WKJp0YZHFjiR/tsv7fzoWafHiGzAGq
	oo3AuTmeDbkT98PJ7cYsdjPeCvilufvp9S2834610jhZCfawWxYV+5OBfwXQMeJl75Ckcl4j3r6
	VW41kJoFwHvh8l3USf9DzT8JlwAjJv50vm8qkph7Vb5m8WTdYfqiGuCyb7w+iwnsRUWN5U/8VQS
	Whb3S8aTfs16Dq3LbqKfTjNkhxwdODlOqm8Uh9594ml7HBRb2TVUczEY1atq3U101oTGp9vOlNR
	wk45w4i52uxSnMg+G3AOzOmYlLQnBuySJQ4nsxhw2I/VP1QBqDX3RiX4HTSDubDPNNetR0ww2oA
	MBWzlKNi6VN7rcyt6lGkDXFfA==
X-Received: by 2002:a05:6a00:4a89:b0:845:cf73:5bd8 with SMTP id d2e1a72fcca58-856271fc239mr22836969b3a.1.1788275934457;
        Tue, 01 Sep 2026 08:18:54 -0700 (PDT)
Received: from o6.lan ([240e:391:ed0:47d0::1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-85db24f33a0sm89911b3a.9.2026.09.01.08.18.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 08:18:53 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	ljs@kernel.org,
	usama.arif@linux.dev,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	kas@kernel.org,
	rppt@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	luto@kernel.org,
	peterz@infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v7 3/3] x86/mm: add set_direct_map_ro()
Date: Tue,  1 Sep 2026 23:18:18 +0800
Message-ID: <20260901151818.3191443-4-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901151818.3191443-1-xueyuan.chen21@gmail.com>
References: <20260901151818.3191443-1-xueyuan.chen21@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B6E9B10000F
X-Stat-Signature: 9bfp64m97ah5j6ztten86n4a6fjaz815
X-HE-Tag: 1788275935-10224
X-HE-Meta: U2FsdGVkX18t8r3BMRC7fPUgAIcLolHPNwA/Q6zu+zS0otnXc/jMjfBd2EeizLkNKlT9IlAj08PR7Wl+r5ubjJIBYxEx909k2wgHXKw8NB6SVPOuvklZ+oteroXLXVwMB6oylJfwBv0Pq36s7CI/u3oIYeW+DGWwYXb0noKeLWBRUtDph64eFcLL6byJvqwpbxwRijp/R5nC39l46TdQjAO4i4ND1vwzpPc5ONMfituf8kuGXY7fhc5KrV77KMjL4b8P4lDpXigLDe9LCDeaUc3WZJ7Pq0P5qHLv6QqApiAdoo/Iw9121OIlleRUuqFXkVpvJO2HCqUPCulvergZL1bN6b2UPnUo9dRy/7ptXcaoBBdcEO1gi+X2LgIKroe2nqlncxR0zPxBZZQIvLSFRN15kuYAGBsqh1TuOnUvzpNZ0JhHvrPoq7qhjjp4cZBlj/oAc1M3FxNn00vhKnFKaywRz8Sol9cr5n2cOQ1BxpXjF5Mqs91kCBGZ3UO++YIYw84tmU5CeS+H1wCJY/I5LOFChP+iGV3q34Mqz2MfW1Ar5Wxa5mFR0a5DB/JG1oixurzD9I3QyytRJjxTAxV6QdgGzeVUSvLmSXhQ/fWXqjxSdPNduoNsiR42jMyeRbTFZO7GgebNVs3RfWvp8BxBXwpZoAw2aR3VfFY/6UO48q1NnkQ6EfWJ14dktipa4FaGYWh6cpw4i8aLj0bTdjcs8xpKTad2UlbhhF0My2BvxzwjtClCNObrpxT28afdsiTJl4o61HolOLxqGf5LmC5I4zd+h9on4jU4XJNbnN7k/GRSRYlsJwqctjPV+gcyPsM0q4wZhXY+n3hIj7gdCZbj0Vigp2qLtz/3G6i8IrjlyGJ7CSzYWUtH08z2MenWgEPcIoFt5gxeXlLZ3DW8lLadZMLTFu3YodUfGzGccXuOVh0Gl2d92meuXWgNBrCfMWheO3pL6eXIKOHpXSnWV2a
 wMNLZ6VC
 meZJpNCk5iiX1QhkfMGm9d98DRDzE2mUb1SRicz4QgUx5FucfKToNMQjXroal410YOK51gBDkZIPQmWbPpm9F2D94Kz0doJmP8L5w18LcxNpT3b5c5iTqvjfLholtRhihKBRuiUHMDORdT7SZI5fhPVA/YwBvGuKAVFDhF5vptPguGeAu3Hd6VYl43wiwmxVfyClzMg+ZX427hRyFYG+f3SBEEoAJMq7x+V+487835WXHAFOqQdL6DZTgNlPr5R7hO66aT3sihyWdRIa8w+mP4IQ772a4oGnwbrlMoxsaCjCkMrP9xJ+XM0u8MqhYsgtqopAQrczuDBuWulONRorWhPT+lRXIXvnFPHCm6jwDD2W+DPZKmMUoN3wh9VgNYHXmApYoPQ/2wgXivXMimrR37colq6QPOeii+uoBnibe76R4MA+76/9sTbHeRy8Nm3aToG/2BJ2r1y5g2sg4nEcmzLtADcsrIn6xdTiqZnwg8iqLV2Qtp28FJlQq5CZM9iOyxdNf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement set_direct_map_ro() for x86 with a page-based interface. Clear
_PAGE_RW and _PAGE_DIRTY through the CPA path and let the common CPA
wrapper invalidate stale writable translations before returning.

Co-developed-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 arch/x86/include/asm/set_memory.h |  2 ++
 arch/x86/mm/pat/set_memory.c      | 10 ++++++++++
 2 files changed, 12 insertions(+)

diff --git a/arch/x86/include/asm/set_memory.h b/arch/x86/include/asm/set_memory.h
index 39271a5ea925..710164ea8258 100644
--- a/arch/x86/include/asm/set_memory.h
+++ b/arch/x86/include/asm/set_memory.h
@@ -88,6 +88,8 @@ int set_pages_rw(struct page *page, int numpages);
 
 int set_direct_map_invalid_noflush(struct page *page, unsigned int nr);
 int set_direct_map_default_noflush(struct page *page, unsigned int nr);
+int set_direct_map_ro(struct page *page, unsigned int nr);
+#define set_direct_map_ro set_direct_map_ro
 bool kernel_page_present(struct page *page);
 
 extern int kernel_set_to_readonly;
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index a1a061d995b3..7c0cfa7acd17 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -2666,6 +2666,16 @@ int set_direct_map_default_noflush(struct page *page, unsigned int nr)
 	return __set_pages_p(page, nr, 0);
 }
 
+int set_direct_map_ro(struct page *page, unsigned int nr)
+{
+	unsigned long addr = (unsigned long)page_address(page);
+
+	/* Direct-map callers are expected to pass pages without aliases. */
+	return change_page_attr_set_clr(&addr, nr, __pgprot(0),
+					__pgprot(_PAGE_RW | _PAGE_DIRTY), 0,
+					CPA_NO_CHECK_ALIAS, NULL);
+}
+
 #ifdef CONFIG_DEBUG_PAGEALLOC
 void __kernel_map_pages(struct page *page, int numpages, int enable)
 {
-- 
2.47.3


