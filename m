Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 412F3CD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 15:18:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E0356B00AA; Tue, 19 May 2026 11:18:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B70A6B00AC; Tue, 19 May 2026 11:18:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFE066B00AD; Tue, 19 May 2026 11:18:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C9BDB6B00AA
	for <linux-mm@kvack.org>; Tue, 19 May 2026 11:18:40 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9AF121C10A7
	for <linux-mm@kvack.org>; Tue, 19 May 2026 15:18:40 +0000 (UTC)
X-FDA: 84784526400.04.523ED39
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf31.hostedemail.com (Postfix) with ESMTP id BAF5720006
	for <linux-mm@kvack.org>; Tue, 19 May 2026 15:18:38 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mwbAM5pl;
	spf=pass (imf31.hostedemail.com: domain of 3TX8MaggKCNQ0H31+68J6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--ardb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3TX8MaggKCNQ0H31+68J6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779203918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3jz5HVOoTF+6wyIXVi1PRz6mG2EpkE1nqqXU3A/HO1M=;
	b=lij37i+0t1VWLu/29MMU2eNyYVxSQV+OKWvsUUkzrLniYzytwRTNftO4KiKOnMb7SQyBme
	ZFhfZPHlX6r2RF6Ov/hPihkzOM5aw5//ZcUyUZh5bjTvifmHn2/qqZVqNXUF+0OBvZn/OY
	aWjTFLuVbPiBDjM0rJTsFuDZlhHz7l4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mwbAM5pl;
	spf=pass (imf31.hostedemail.com: domain of 3TX8MaggKCNQ0H31+68J6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--ardb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3TX8MaggKCNQ0H31+68J6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779203918; a=rsa-sha256;
	cv=none;
	b=m+wuXvjBwW1vn4K33dgSvmzMtkkUF3rGuyiDOgVjuxN4BlHx5X1rd4h2HkI4nuToOE6Z0M
	AsjraOJm/a5tXMD/NxhNAlC6HV12+1QsaDl0wpzlctaxPWYm8/1m5wbaUqXReqlCqe023a
	rG6hrbRIrCnNRKio2r8AGl9UqCOz9Cc=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-48fed2519daso19769315e9.0
        for <linux-mm@kvack.org>; Tue, 19 May 2026 08:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779203917; x=1779808717; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3jz5HVOoTF+6wyIXVi1PRz6mG2EpkE1nqqXU3A/HO1M=;
        b=mwbAM5pliR2BHv0eZYltt97zp2ByfzlwucUvL9T116H46Hz9PqYABi8prRC+3YosoG
         rpVuVQinX3f8iaChAAV4yTpaPY/iT/SAMY1rihq9dbPBHBS35JK/oYmWzijiq7Ur0oSP
         uxmVbI2g8eSQhp+eb8FrK7Ydpo9/yuvNQ3/jCTuXOQjiG3jk24ZcH9ueAHVf6CGpxJWn
         eKYJp4g8456oVfZKTOTMR9eeo+SXD2VFBKiAuSFnuD7VdwQVsnACdde8Z6ot2Vxxkeow
         +RhDvtsgrhMWN3bOF/bMyi+LuHK2fBC0PDzUk+wLK98AqoBR46qQrL4MVGt5ryYXrtxF
         yJFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779203917; x=1779808717;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3jz5HVOoTF+6wyIXVi1PRz6mG2EpkE1nqqXU3A/HO1M=;
        b=QeSxbJU8vl1oho+vN0tY3bGmy7RMTB+BDqU9nPkLs9fkN4gQzaFOYYBrfe4vkfpl9v
         y6t+OylDb+AB2zYino9HZampmCfjYTVYX7mc8tr539EHZp2kCr7Q3T9lRGuYhcT2nXNj
         bYImKfG+a29nBP8AWLDWvSOfb3hYfvTDdmmxgzRu++LQIYdZGnf1cWBvDUGMhHzvAqc8
         fd1S8g+RnG0fFAIgG8XjHoT7jXBN5ZH0MeFc5nHxDh05dqwZ6L0/mE5G8pIfL3kdHFw3
         bwjlx2Y6scATw9LhHb1MTMT44gkl0DSdX97VmcRCyvBj/AnXulBMpbVzaQxIEdFtJ5ZQ
         3/Fg==
X-Forwarded-Encrypted: i=1; AFNElJ/+KvqDL9r2b5LWDTMrfVBZFtFmlEYkynySPPniDx3RuxCpUviLrbOqkH7QJNSekth2VfHMhCAqQQ==@kvack.org
X-Gm-Message-State: AOJu0Yxkp0tK5HwLhQ1tmaB3w4iJ4rJBym0lUlOLMP+sG1/TsXB1Jkef
	Ccb39Ci3F8/vaOVCXvFEGUvtH57KkHKpwqsnFOos0Sbdbhub1fpjynh+Q/NRicvTYq5lzDVPJg=
	=
X-Received: from wmgb4.prod.google.com ([2002:a05:600c:1504:b0:48a:5909:4ec0])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3b27:b0:48e:7854:1608
 with SMTP id 5b1f17b1804b1-48fe6516b54mr287879475e9.25.1779203917004; Tue, 19
 May 2026 08:18:37 -0700 (PDT)
Date: Tue, 19 May 2026 17:16:27 +0200
In-Reply-To: <20260519151616.2557018-15-ardb+git@google.com>
Mime-Version: 1.0
References: <20260519151616.2557018-15-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2309; i=ardb@kernel.org;
 h=from:subject; bh=UkAnTwiseYdN3aottp779GEWC8HTyTdJGgqvssDeFDs=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIYun7oLF8bs37COMHj7P+n7snJGyv9rm41dMbMS8zptLS
 tXt/7u3o5SFQYyLQVZMkUVg9t93O09PlKp1niULM4eVCWQIAxenAExkZRAjQzevZ0Wao2BR6VYx
 Id/GxVnnL9mVyHGzz3i8hW3B1yMN5xj+St4OTmgr/7Gk+JVAuEzcFYW67LpiNmefmmsV5/P5Y/2 YAA==
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260519151616.2557018-25-ardb+git@google.com>
Subject: [PATCH v5 10/13] arm64: Move fixmap page tables to end of kernel image
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, 
	mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Liz Prucka <lizprucka@google.com>, 
	Seth Jenkins <sethjenkins@google.com>, Kees Cook <kees@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, Kevin Brodsky <kevin.brodsky@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BAF5720006
X-Stat-Signature: ige6qkppxzyc8ehkrxzug7zf4abbyzrj
X-HE-Tag: 1779203918-216870
X-HE-Meta: U2FsdGVkX1/CUZ6Dg5nrXMpaRDnIui30soAJUrJiqE0vTYWpfAfB10j8YO5CcsTTc8nY6wPSnhAlsQjjxjbPWvXKrLWNovsPh9TkdmJxh7T7WWbuoZIKhafS/Ee6Y147+jquqNXp0aaoFPrlxa6DKRg2JNRlNkDe/9v+nuxxHcAJwyM/piwAARauwL0kXNaeRQzW1hw9iJuA6r0ucsl43p2Am0GGz99wwBNmC1CkQHnCM77UMKFPRaC5eQXgfooeZc8t4x0s7lqzEUTsTvvq1Tg3EJg4D0iJnb2+92KHvfYVygPySAK8XWPVYMeP6u1QVTZSF7Kt73Mm22u/6Tt1JGL9feltTste+Yr893WtQ2cWU3GOVEwayvvD5UOVo3JdYLPtxRVoT7BVFBgtEiPJ9ju/JYJGYW87Vaf0xQYOvEZ2goZQnkoIZxQO1DYxkUq2pF1ya+K859WELR1LR2FsvUpOvbPDOUc+7bI4ZEKcfBmaNBcrk9N8G+jC0Px6saVpMgTmn51QXBeN/t7YQ0ofRfHzqYIhfLE1wEB0JkyVm/nxJHSr7ifkWpNTWmwlIadzoQjFLmNgQjdZF3sXu96u43jJvC+FCrS4vwk1tebs9ZUKR0TEO1V4Cm/SCRHwL8fBN1ZSHvL2bV2ca330shws9KEjvPfejPjzH70BUF+v8ErQny3uNrwxI24pOevHbkABb88oA0rd9lGnDOMWyVZB5AB5H/7uPq7oBP9Gr8iskt6RmreTpHgdwuSrrpdLbNUPvas5OJtlE6xUsBLZ+YEIvsh8YvP6oUGSAQ3WT/94xvLxeHmq4GBthIZ+Kq2ueldYtX9gIeaxv3Xq4xatzLs9jFAeKYbnCwLjgnm+wEpytdZotvaXyy5KDqs9JxqUBiZSBg91i6pf4fdzbTxCXxPE5E5BvxtT8Z5JOMy0oEBPyyf5PcmtyQnyfiXbu0sETMMmH1Pgzy+obfYGEexWYv2
 btVjGIHh
 0Uz1YXEfNttVrkY7ONhlOQ/vb5j3eG1yMl1l2RzPAADYy19yDDKAoCZRiPGtV691y7gHf+31zMPyq5sAj0S/TJrWKCO6Lm1LmpnKr22eftl5oEBBkEPdFWlV5ivByaOpREHz5GQzICseGzSjskTJZKTlutwRnIefFPbg+3i6JPKy7aiG7398W1peAIYFB7I45eEKcOr1aeEp6U7pSRznzeQ2S46GEIxv175AWpclBjc/rSGtbS+qBCbaln1bhlCwCTX0CAfe/nqrMC+ULznMWaFSsc4B9bPwEAO71YrGGTZ8XN11gqiMZQXauiJ32Tp31fxL8j0steV3Zk8ZmhyJbxW8XXRTZo7if32XDBIFtEAdhCxTYFfcEr2h+wK6Cw4WvF1w7fT4+V9AqPLNusr3zeh1oPVkcMooWb/GBKb3ZM8zGcmgS2ZRXiB8xvqN7J/XQeje7818v4RtpyAODwiqeAr9UXoJ2Qpr1q8CnpI3lz6zcX183s0ba51mofGFAogWp50YtFKMUdt6n2bpgCAqhi8Zm7uqryQ+netGE9pQZgRAaBmzYq7MehwqE8RGXu2j8YZb9PNp7WVXUDT67y2Qo8ki81+81trdKgLX7PdxX2S7KqtMhRKQXSSmQlWq1dv2d5YrI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ard Biesheuvel <ardb@kernel.org>

Move the fixmap page tables out of the BSS section, and place them at
the end of the image, right before the init_pg_dir section where some of
the other statically allocated page tables live.

These page tables are currently the only data objects in vmlinux that
are meant to be accessed via the kernel image's linear alias, and so
placing them together allows the remainder of the data/bss section to be
remapped read-only or unmapped entirely.

Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/kernel/vmlinux.lds.S | 10 ++++++++--
 arch/arm64/mm/fixmap.c          |  7 ++++---
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index e1ac876200a3..64c7bf4b7176 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -349,10 +349,16 @@ SECTIONS
 	_edata = .;
 
 	/* start of zero-init region */
-	BSS_SECTION(SBSS_ALIGN, 0, 0)
+	BSS_SECTION(SBSS_ALIGN, 0, PAGE_SIZE)
 	__pi___bss_start = __bss_start;
 
-	. = ALIGN(PAGE_SIZE);
+	/* fixmap BSS starts here - preceding data/BSS is omitted from the linear map */
+	.fixmap_pgdir : ALIGN(PAGE_SIZE) {
+		*(.fixmap_bss)
+	}
+	ASSERT(ADDR(.fixmap_pgdir) == __bss_stop, ".fixmap_pgdir should follow BSS")
+
+
 	__pi_init_pg_dir = .;
 	. += INIT_DIR_SIZE;
 	__pi_init_pg_end = .;
diff --git a/arch/arm64/mm/fixmap.c b/arch/arm64/mm/fixmap.c
index c5c5425791da..b649ea1a46e4 100644
--- a/arch/arm64/mm/fixmap.c
+++ b/arch/arm64/mm/fixmap.c
@@ -31,9 +31,10 @@ static_assert(NR_BM_PMD_TABLES == 1);
 
 #define BM_PTE_TABLE_IDX(addr)	__BM_TABLE_IDX(addr, PMD_SHIFT)
 
-static pte_t bm_pte[NR_BM_PTE_TABLES][PTRS_PER_PTE] __page_aligned_bss;
-static pmd_t bm_pmd[PTRS_PER_PMD] __page_aligned_bss __maybe_unused;
-static pud_t bm_pud[PTRS_PER_PUD] __page_aligned_bss __maybe_unused;
+#define __fixmap_bss	__section(".fixmap_bss") __aligned(PAGE_SIZE)
+static pte_t bm_pte[NR_BM_PTE_TABLES][PTRS_PER_PTE] __fixmap_bss;
+static pmd_t bm_pmd[PTRS_PER_PMD] __fixmap_bss __maybe_unused;
+static pud_t bm_pud[PTRS_PER_PUD] __fixmap_bss __maybe_unused;
 
 static inline pte_t *fixmap_pte(unsigned long addr)
 {
-- 
2.54.0.563.g4f69b47b94-goog


