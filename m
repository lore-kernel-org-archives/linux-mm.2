Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95CE4C531C7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 09:29:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 528D56B0157; Thu, 23 Jul 2026 05:29:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 500176B0159; Thu, 23 Jul 2026 05:29:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 417016B015A; Thu, 23 Jul 2026 05:29:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1628C6B0157
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 05:29:23 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 84F0D14014C
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 09:29:22 +0000 (UTC)
X-FDA: 85019518164.22.9C8EDF2
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf07.hostedemail.com (Postfix) with ESMTP id B3F6040004
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 09:29:20 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=tAjkfvKJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of zhaomeijing100@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=zhaomeijing100@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784798960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XgS4LfBBZVF7e0vsLNofmuF1qmxptGwTKB4edvEsX44=;
	b=5PC68VhgKxNJ42PDgyh5HWX1tO2fqWvr7Y3u2wC7J9a3eWNB4w17NWkjlkYYAfuGMufrNF
	IMKs64oADnB2MelAVdUJZk0/Rq3AZ9i44fdNj52RfSmdkusDYRbsxczpUOE9WtSTiSAS4l
	awSuflwTqgSQXUy+ncG1QRxTxID5Ns4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=tAjkfvKJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of zhaomeijing100@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=zhaomeijing100@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784798960;
	b=i9IfO7lNSE1EkidQlmFo9/2ACyWIlr4+PLRGNwLvxKctKfQefT2FlFZgEJzVfUCTr6Hjoe
	ZBh/prre+WZlxK7x6UMg8US/qyLPZEeivO/1vM2mnuDF0d28DqWUzoYK2gxhQv0Bf2HTkY
	dm6FofVhH9ZqwR7jqsu2EoDkQPJeKoY=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2ceab75934dso4990575ad.2
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 02:29:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784798960; x=1785403760; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XgS4LfBBZVF7e0vsLNofmuF1qmxptGwTKB4edvEsX44=;
        b=tAjkfvKJhMRojGs6H0oge4mtYPkgvb4LB/8OS23hI5BNXaFdth1j9gOE34zg6xJYPg
         gvFklC2rtmzzwzxZFZPqazkgWuOOKJHYlrZrn/tzm1YDfEsETAWCgS4tWQaWLIZb7rHp
         nBSS7fcwVJk+K55QwQ1jKacIl6en2cGfTVJUL46FIsMzpdY8tTQ99jSl1VJ58LMQtD+1
         JgE+rtvBuKA4ggBN646HfOY67qG2R4Sm1b6bCAbawSGjhNTrqlH0gi2eYsZ72C/vZ72n
         SUb+o8Tep5mQFaw7/4CB75tIAx2r9WMREgmJGuX/+wS5yz/ycy+/Fkl0QOlYpPn8f7nn
         iPLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784798960; x=1785403760;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XgS4LfBBZVF7e0vsLNofmuF1qmxptGwTKB4edvEsX44=;
        b=ZjxY83V2abG0gRqtPqJM0BAbL9LubLFLCwIaCnZNjhsyZfPzq9sydHZbc6DIZ7TmOS
         d0MlCyCmxRrDuZuzMI+BJHujbWIv8mWGdYg6d4/Fz5erDfYiL5xVYInxNJfP+IQA2alv
         Ndjc3ScGfhFZ260UYBHrveqdC3cZi0NS5GjeRy5lsbczfRIAhv02iXrBUuk0mczlpDv6
         g20G2v+5swzYVucVm5S0dNRSP5TUmlGR10pf7jIZtgfjvjhSpP3Org2CjJKzGpAACSO3
         hEFaTF0OttZJ5/9VZsLzZaZbdW9h8TQrMN6hFK2UH/dF+aAfxMvW9tqpPxZl6qCufE9C
         Cd5Q==
X-Forwarded-Encrypted: i=1; AHgh+RqD5B+ZggdTGfPMJelJephKWggxJCHpY12g+3aTMWU9mNf3Yl/Um2f6ujkx18ZlBFlrO9KGocODiw==@kvack.org
X-Gm-Message-State: AOJu0YxtMcEa1mYDogGehGIzZnbxXtVS6hZ7IqNocdEbf5geyySWwHgy
	mQdvpD5rRxVoVFfzk7VN4t+FCZGsRsmO9FpCLJRQBw/4R/GRl3Q4Lq9/
X-Gm-Gg: AR+sD13CqNHTCk9rry3fwMIfEvoRPScfAupyKdAaxqOPzy3Gz1YOc7jJVES2YxUS0U9
	OEja46GWMRQIDPH3QWAY6ejmqlkeXVAxUXn7H432VKRMcyxx5RS1+oakWPXoVnyQoKuGBydzlb9
	xGTE0pgTHlGd8/huf/Wxpxm3ONwWuK8N/XlsEBq2ieswduLSi+9N9fzH/x3gBCSbOwJjh4rThv/
	AFbOsPYdiVPV3hax/n+XkJahmjAVvVUkrYOgCjrB3ZujwJkRRPNH9D2RvoV5dIbxVI0ozLY16sd
	CEyLWomKsE/LxGQrOa7zppTJLv56TeRxIgbcL8zmNgsGE7VwiF2tA+XLnlII8iSCcI5/nRkYk1F
	xhQVYmW5+fkOpyRSzJpCi/dfxxACb2QQFKxpjtW+dGgpUToSMZHNTMtKFb/TSt64EyZLaTLBKYA
	l4IKOyxtWlaV5r3CZIKg==
X-Received: by 2002:a17:902:d4d2:b0:2c9:97a8:afe7 with SMTP id d9443c01a7336-2cfa74db373mr26986545ad.42.1784798959619;
        Thu, 23 Jul 2026 02:29:19 -0700 (PDT)
Received: from PC-2B0BA31200898.company.local ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf8efa388fsm30298125ad.12.2026.07.23.02.29.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 02:29:18 -0700 (PDT)
From: Meijing Zhao <zhaomeijing100@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Meijing Zhao <zhaomeijing@lixiang.com>
Subject: [PATCH RESEND 1/3] mm: trace: decode arm64 and sparc64 VM_ARCH_1 flags
Date: Thu, 23 Jul 2026 17:29:03 +0800
Message-Id: <20260723092905.761037-2-zhaomeijing100@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260723092905.761037-1-zhaomeijing100@gmail.com>
References: <20260723092905.761037-1-zhaomeijing100@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B3F6040004
X-Rspam-User: 
X-Stat-Signature: pnhreqyy748d1kgho7rtd3sngsd9e5s1
X-HE-Tag: 1784798960-808275
X-HE-Meta: U2FsdGVkX1+/gBSEiL2lk4fK3soQ60yN7DWk3JYX0BDGLkWqbiCn3ojDnIE3H5oJIhvUmUgjhriFLl8SiXUreygL/aQctE4HnImdlDmwienfPvRcoiMafxo1mfMO1xDh48r0Nxctaa9KR2wvLGr48XoJFMhaO4eFaV77gcOyaEQ4lT8N08RRONzXBS8c05rikNhpK3Hgr/+TNndcRo4x+Crs7Fd3C6QwHl4GFnB809tA85N8noDtuYpKSdah2ckgiVtIDurQlDTfiLM0w7RDFMkaLicqxLbwe6M4nHs9wsmu6W+KbvbjBJypZgLofgy+WnG0FGPWegsCMHrdi+Fk0eLzYDw6BzhcCEF6IA75SA5bnrSrr5yVFQXLd7l48FX5PKlqpxdumgNb9gM1ulm5HSPy/uruugFHQTR1x+xpWPZJXhpmmwjdfCIzpLNBZkMRw01WW/9V8izVF/WeC6f3V1J6OZSnUCgh4cZPAcLdtIe3OcSkNFnWOOoVUqhtHvX0nrTNOVeh3+QbVRDMX3sC7bWOtFztxReGZJ77Lt/Q31TCpHIl4flaLk/KQe3bwvjC9IUnyhRRZI8p4kGcFDEF/mUZj4ZKUQt1HVFppMWURaqeo1KQW1dUw7DAKZssDay8+8L5Eyvwl+EFuuUDjEOEidSBQbnY45rRoyUBYGFl10j+gnAgZlFE2krWaLX3hrbi43DoAI5wqlTQsVU5+tXL6nqmYNTDmJHHh06BncbC58siKKN93Hqsp8sHw+vkkAgWpQMmorkZkcRKjUREP0nMJKEWMph2/T74e2GjAK1qLslUclXKJ0FyUUDjgFoncnJXBGyM0ZpRZiySTMQkwZQ52eQfCGw+41bsych6tK9a1f2EM6nwwU5bWVBsCQqZmHx6QpRrBnyWmMEgRj12z8VGQPkwSYDy4SzQCdCFR41vQWeIBR1Dw3LL9J0wKp0kKBbOaGegxYK96JGmHA3YWYj
 oeUkQEa6
 cSpyMMg5PnAjQxtOo++j8t9CxBtTIe13/q1uWFbn08CF6/en1bE5JPnxvr0ssZnUjwDJ8oj/nq2B2uui66OYpKKrdfBSo+aw+rlIfYH6Iet5D7RKzZuVo2pFr1BQMVDv2o0J0oN/BI2yAc3TO06IFflKgmECoisBMvch5mV6tEu13cKaXMWjNI4uVVMo+JwkNfktC89+XaewMHk7O0YiemqfzqKnsZUlpTxVyxbZfGf6W6/gSjbfFRD/e6mXTsOUJ8mwIvrtA0RcJqmgmxJ3blB/y5iQCZL+TgBaVbZYnHGOJmH5cAg840HmF5bdnQVZopD6OaBQg0DE0SzN9MkhXy07cPi1DlbWP5m7eFAaJrOnd5OwiNfj3XNqCmttLaSF8u5TrUQMcbFdvnbLFsgBZ0cT9Uo6h/MggIB4GrR9rbszWccPNEjLqmaY30a+BhlQW0IR72kQ0ydyRIS0x0eTHxMRd3nMylQDlNqSnRLqffUyGlVCBaqeOh7JdZ1AsBYeEwPGiOdLLyqFV7dQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Meijing Zhao <zhaomeijing@lixiang.com>

The VM_ARCH_1 bit has architecture-specific meanings.  show_vma_flags(),
which is used by VMA tracepoints and %pGv, already reports the powerpc,
parisc and no-MMU meanings, but falls back to the generic "arch_1" name
on arm64 and sparc64.

Report VM_ARM64_BTI as "bti" and VM_SPARC_ADI as "adi" so trace output
and %pGv dumps expose the actual architecture-specific state.  These
names also match the mnemonics used by /proc/<pid>/smaps.

Signed-off-by: Meijing Zhao <zhaomeijing@lixiang.com>
---
 include/trace/events/mmflags.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.h
index a6e5a44c9b42..add5ad6843e8 100644
--- a/include/trace/events/mmflags.h
+++ b/include/trace/events/mmflags.h
@@ -176,6 +176,10 @@ IF_HAVE_PG_ARCH_3(arch_3)
 #define __VM_ARCH_SPECIFIC_1 {VM_SAO,     "sao"           }
 #elif defined(CONFIG_PARISC)
 #define __VM_ARCH_SPECIFIC_1 {VM_GROWSUP,	"growsup"	}
+#elif defined(CONFIG_SPARC64)
+#define __VM_ARCH_SPECIFIC_1 {VM_SPARC_ADI, "adi"		}
+#elif defined(CONFIG_ARM64)
+#define __VM_ARCH_SPECIFIC_1 {VM_ARM64_BTI, "bti"		}
 #elif !defined(CONFIG_MMU)
 #define __VM_ARCH_SPECIFIC_1 {VM_MAPPED_COPY,"mappedcopy"	}
 #else
-- 
2.25.1

