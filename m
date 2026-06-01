Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 840EACD6E4C
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 08:49:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD56E6B0095; Mon,  1 Jun 2026 04:49:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DACEE6B00DF; Mon,  1 Jun 2026 04:49:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC2F46B00D7; Mon,  1 Jun 2026 04:49:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BB2196B02D5
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 04:49:04 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 63AA1405EC
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:49:04 +0000 (UTC)
X-FDA: 84830719008.29.D6416F4
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8CBAF80008
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:49:02 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="eeaO/BGe";
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780303742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8iZQN+oxehRhbRDFp2Djf7RG6EvHlnyDB08mWf0NvrQ=;
	b=IdGpYpo1s+2UzqtSzwOe8u9G7K39oX4mB83J9QF7et8XtbVZSN2ivX75exxk1HgmA5qiO2
	fN9wpuXJrAjGHlN+h6081zKvukiU8bRoQOU5OSohUDOHPIZd2moypeBJwRSF7J7cYrl4U0
	43VVa+8uTYQ3NaOniP2nndLsYr1Y4WA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780303742; a=rsa-sha256;
	cv=none;
	b=HAkJNdoZSKbO9WGN4QZqBR1MIhaAGWkZOnjAPCxXYg1wZIi0ugplXBY3NQwTFnQBQtk05x
	KekU8OuyV1A5GiLe6IgQW4NhrtU5QC6+4jyTcW2gOgM40sQN9xe71OE0u+367bAyDNm2CL
	e1byxrSc9JSzEyogd7W7ldtEblD2caQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="eeaO/BGe";
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8423f420455so361884b3a.3
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 01:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1780303741; x=1780908541; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8iZQN+oxehRhbRDFp2Djf7RG6EvHlnyDB08mWf0NvrQ=;
        b=eeaO/BGe86fR1g4O9nw8CXyJLMPtHMCcLKb70JXgyNT1JpFk0OAPbXhPDQmfyUvqrG
         9PfapYlNs3/difMbdEv5A32zhCEt1NSzdHRNnTktqHsLW5l2y8INEaoVVrk9HEtOtor/
         mm4doMJ83ARLgoZr4oYtlosSJ1NITX0m3bCGJap5zuVG1wegnH2uymwPgZnv8K056Kli
         43Wsmk/XLRionsTOyEg5lj2n0uIL0ENrnVf5i4+RANLxRLieIhL4udVubE/b44YxHLea
         ogeEXuOOHV3yA6G0a5F8+APA8UvIXt4I+V+FziRLX6ka8iWEe+d0gVexCcLbWr49W0PR
         pCHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780303741; x=1780908541;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8iZQN+oxehRhbRDFp2Djf7RG6EvHlnyDB08mWf0NvrQ=;
        b=ZuZbDHskPIYK368CvxG/yomL600VSQD3m+22tZvLxdW5vSOZay7Nvmebzurq0+UX2Q
         0J38LzMXWloSVuAoSzZxrVmjeP3hWJB70xu32nqFFgkcik1dgT6ZnIzQRNT0ALJSLpce
         iEO0ZBNeSio60wdDecOY26P3LQlNC+sqI22Wj6KnMkVgR8uIMtgmuxho34FMISmwXMs+
         5P/O0Iuz96eboSJBQLOMBhaiX4877QPZ5urE/fg9Vy2p2cVg0nMAt9/9rkpZU4xU/qF2
         gOdxFNcBK/4Pn2aY1cUFTyXqkp4W/bItaop5Tlc7LmQt7P5G8BV6OnAZ9VLqnURlrq7f
         95lw==
X-Forwarded-Encrypted: i=1; AFNElJ8GlE55OFpSKHObp5lNNDRFoWLFKXCnEYYWWvl1aq1pqPY3GVs5vLEjm1NKYe8Zf+BNibuULqFZ8g==@kvack.org
X-Gm-Message-State: AOJu0YyRnwAZysmjzz9ySY7vTlvCaw4ty+Bp0DmnkhdaKdPdrWqTEPE5
	73jkh2uF4hH7Eyfpf+GpBmQB2qXMHcDBWHQDX+XFtdlR231CU+hQI15bbI02A+fmSs8=
X-Gm-Gg: Acq92OEDrUdl6W5xYOYy191uIWzwOHhRmBW3f8e6DlKH5KH9IthNYdpUBvzFeRsQdR3
	S22n+oSJv56+lG+r7LYyNxU5H74at7zLCGrC3ke5nwaw4fXBkmF3xspG59ciOphFMWKDeIQmnLn
	vv0PvsD6IJHgQtjw+lMvAHAZyI1hX/5v4gcC6Md2AQskChUZqHfmVjF5AZXX3GuKV9YxwToe6Sa
	d1EUZFpqHSgapI0Gghrp8PnnsWo6SwFpADOr7LUPbe+TXoALcEpRkyQHFWxaFORV+R5YVlSUNFJ
	b4U/k71/UOo6Eub9kpn2XCVOYDJqlmZQ71E+fw4wGD06ktDKZ9F2t1ZuOkdXGzu7IS90xrssBoe
	tGfTtlbwdxC/gA4MSwmRs4YWwS+o++oQwhcoApwMweSpcdVw2O5Ks0B9uOWugHx1jR0OEp2yBeC
	koV3njay+D0wqD4HpYXLUMdZSXZjJb4hqAE9P2PFsIAo52UHITwj0efA==
X-Received: by 2002:aa7:9a86:0:b0:83c:928:6e5a with SMTP id d2e1a72fcca58-84225376b00mr9579300b3a.13.1780303741104;
        Mon, 01 Jun 2026 01:49:01 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.96])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84232ef8172sm6316230b3a.12.2026.06.01.01.48.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 01:49:00 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	Andreas Larsson <andreas@gaisler.com>,
	"David S. Miller" <davem@davemloft.net>
Cc: Muchun Song <muchun.song@linux.dev>,
	Muchun Song <songmuchun@bytedance.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	loongarch@lists.linux.dev,
	sparclinux@vger.kernel.org,
	Alexandre Ghiti <alex@ghiti.fr>,
	Albert Ou <aou@eecs.berkeley.edu>,
	WANG Xuerui <kernel@xen0n.name>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v3 1/5] mm/sparse-vmemmap: provide generic vmemmap_set_pmd() and vmemmap_check_pmd()
Date: Mon,  1 Jun 2026 16:48:40 +0800
Message-ID: <20260601084845.3792171-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260601084845.3792171-1-songmuchun@bytedance.com>
References: <20260601084845.3792171-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: 8u9aqjjwg751too7pydk6543h4194cid
X-Rspamd-Queue-Id: 8CBAF80008
X-Rspam-User: 
X-HE-Tag: 1780303742-543583
X-HE-Meta: U2FsdGVkX1+YRR51WnWYoa7JEKVky3qN8gq+7gHXkMeejwW5zTE89zk2cJ5jK27+LuveWq+5p8xdmZ96ZOnQY8oa5WYgOV2dyW5bEXWveflNFHP+EG4qBCFA+1z7Ul704pCpIuPm/JZqzKIWyZ16T9plJVxTALt58CMF5DLp0DzeQ6Ew9NbehI9a4YRNZmoBg6rN2bVqNGLlm8T65TK5DZAli4tEodbMjcRWvI8sCfDjfSBP7UxK3y5Urawaz960i3TKJQGi8+n5v4+r9wyPSl0u9vqKDy/HsYPIjRsq4wFOXJYiuP0gsezGth1DISB2XpRHbOoCBgEwnawBHRdWSF/ROJnwkIqikirpcMy2YRGD/PlUQeEttizHX4rPNruCPljtUjgnZXkhRt3ZbRr2kFS971eloPPQZO4voB4k1wsYadZSMdwvLNoCr8xT4E1FgUsPTIRLrFzgxUsXcrej3wxQg21wwOTBRPGVM7seJ/DvGeKwVlkXsEC19gASw1nHGAAiDuxND2Ug/77P1ri/QzqWNnTDVA1DB5YdEbCJSiMRfvF9ZZr6abjluvxrMnpSmow+7l8Xz/+MSWy4N4Um8p05X6kMQO1yBWu+PUmgemiNeqq9ILyMjrsyY4hauxBp5LBuvj72YBV8wbhqDMJe7B7dos9KrFIcUzwqmS8HY5BkZQ+KyFCzPXgWZ99bJjGNhx0Gr6fDcBZn5oXdT+VjAfR0FJ52pfiaMVv9aZGc3SoyTBTCAJdisPugxMVqVpIm87K3G6UPx+Bz2i0Fk2o49ubJicaGbw+yTIWvxABrhPy/srS2etU0tA0eLdSYPwFrsMcJxVlaGS4uU+nJ7SBCk6TaHvmQv6x2tkKxHneSpIHmEdE3QN4e48RR9XIwxsvc4pSSAH04CL+FOvUULPfWheylCjI8n0wuLE0B6xLQwuDPeyB8vrK6D/XRpW9qZllX6FzfunD4w3EnsDhgPjI
 5+LBUBZv
 WhZArzDo/+PjBU/7hCv46mUCbNpibqCUF0ArPlyrjPAsffDoWtTGpLU3LXqZPOUpU4+atQpqlZY9xYJanFPNic97prKH7WSeJ0bBL5n6hMtCZqwRN5TPgobDu1AXt+FZy7AjOfKizBKmkqeHT4nfm57Ci4zrKruUlQxP7RlONVHve0iw8H0x3GzLl4mFYZumV7X3UdPChm+ibo1cFMlXc/1cAWMbNZ9KYmTk1ktv4cxXDN4g1hacvU7WVEScbG1n338nMOito4Ugj9nm5P5He/ZNCG4dKNHyCqufZ5Zq5rgkSeIcurWwZm9jGkrCX8+4F5jABa1bbl1lys4/Cn3RYD0X5I2X3YsynI7XysM7UF2ARzqd7WCqzA0w1NWn6Q2WjsI3sTJik2ZFkWiKzEwnBhNg3ebxEjjtxMfyRIqczc5cmYcnkM3b6DvpAeYZj5Q7BBLwZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The two weak functions are currently no-ops on every architecture,
forcing each platform that needs them to duplicate the same handful
of lines.  Provide a generic implementation:

- vmemmap_set_pmd() simply sets a huge PMD with PAGE_KERNEL protection.

- vmemmap_check_pmd() verifies that the PMD is present and leaf,
  then calls the existing vmemmap_verify() helper.

Architectures that need special handling can continue to override the
weak symbols; everyone else gets the standard version for free.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
v2->v3:
- Replace BUG_ON() with WARN_ON_ONCE() in vmemmap_set_pmd()
---
 mm/sparse-vmemmap.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 112ccf9c71ca..99e2be39671b 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -386,12 +386,17 @@ int __meminit vmemmap_populate_hvo(unsigned long addr, unsigned long end,
 void __weak __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
 				      unsigned long addr, unsigned long next)
 {
+	WARN_ON_ONCE(!pmd_set_huge(pmd, virt_to_phys(p), PAGE_KERNEL));
 }
 
 int __weak __meminit vmemmap_check_pmd(pmd_t *pmd, int node,
 				       unsigned long addr, unsigned long next)
 {
-	return 0;
+	if (!pmd_leaf(pmdp_get(pmd)))
+		return 0;
+	vmemmap_verify((pte_t *)pmd, node, addr, next);
+
+	return 1;
 }
 
 int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
-- 
2.54.0


