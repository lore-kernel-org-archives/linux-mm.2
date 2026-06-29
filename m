Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8808C43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 18:59:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9876E6B00E7; Mon, 29 Jun 2026 14:59:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 937636B00EA; Mon, 29 Jun 2026 14:59:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DD8C6B00E7; Mon, 29 Jun 2026 14:59:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4D4996B00E7
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:59:01 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C2BB114023B
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:59:00 +0000 (UTC)
X-FDA: 84933862440.20.C113675
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id E3FF280003
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:58:58 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=H29bbmdd;
	spf=pass (imf02.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782759538;
	b=8fjnra0mhtFoZrnQys3+sqZJCNsz4SLWit3cGBuJlb9wtITdSfstr33fag9x70SHjIxXM1
	2SOumOw5fDmAPK1yJKpQNcIc01PupslKW9PcinhwpVCmKmj5+2PgnNZdtbsOMFSgN6ftiG
	jL468EyCyMQuVJksrlj5U/VWSEIPZcw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782759538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HVOlM7kPzvO4OMsU9kvVFUMLuWs6g1IuomjuOlanbZU=;
	b=trF0owLlzYIlgAE9LG+pPGAttkAO8f/ttjNrD/D3SaCSzhjN5nJgZaGgH1ARj/6ECMhubU
	fMOpS2x1aKkDD7LOI+zvlRxMLjG9yIErx3JiqMDjB8pDfGO5syuSC7zZnG3J+OlGLzRvPv
	lEJOyofUebtDvJnLQNM/iH7B+3nAbAI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=H29bbmdd;
	spf=pass (imf02.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-845ea8924fdso927265b3a.0
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782759538; x=1783364338; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HVOlM7kPzvO4OMsU9kvVFUMLuWs6g1IuomjuOlanbZU=;
        b=H29bbmddVf3nhLOeb0ZxN2Xi2KBAOdZ5WPZ+628mgDChC7Zo4iluXSSOF4X1bScw14
         jpyTfl16eeyt7sCeJp01uCYjJ7LpVc6A7nMIM4YyFZUKxHMzECCuQ7woNc2QokCI++4s
         YMgyAi1F9y/b4EGtb/Fd4u9y6T7rWapw3vB/Y0jQCG2YQCUrYwBYfSE+omiTgvRDXNV8
         WC0gKuyz6TLHIpdldPfWUwuCfsJ5oHvcsOGdBHhuPlv8FaQYxK1eHGC2ZI31g3qVlQiw
         R8E7XgL0pIBVswtM2ZUdKVVE2j4qb37iqFYm08kOwycFwA29MJtzJ9vZRPlqxWZcMIIS
         /pIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782759538; x=1783364338;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HVOlM7kPzvO4OMsU9kvVFUMLuWs6g1IuomjuOlanbZU=;
        b=hZCdAOmge+Z2+nSb9CBGbjY56AN5YxdzgKkWdMzvSXtb/PeNRZjetxd+Cf45RG8fHY
         vs2T4fgLU5femu+LPkUnia1Nulc6Gi/H4IvLfPlwtgg2zgLOl/YYtMlgTkvAYbS0GQbn
         hAenkBpnoV5jTjU6I6FNU1w3+k9jgfen5CCGLDQcWNvxBlFcgQz4QkX6rZmCFJu75a0R
         Br218wUqms7LsGnpldyjUcctHQfp7rfszE7UYIMu78MyK4V9wMYL57noM+Aq/uFxOxEO
         +J+IEr8BYxi0nPNRl9dZLslaLxQ8t5k9qdv1F+PUD3soZHfpYpR63b83PBLBbXCvoAvu
         I3Bw==
X-Forwarded-Encrypted: i=1; AFNElJ/Vmv8mkK+URRl7Uw+rM6lr75q+oMp/3hF/gkqOw3jRwBaR6Yhn67ZVM71ye3WbMlsQDjFyU6jlOg==@kvack.org
X-Gm-Message-State: AOJu0YxOm9NR8DdVY6o9S3FXKNcrbdhGHlYHMqldrIN5idpG01nwlLwK
	sTGypsnbfuLZpwxBZNgp8hDeomslqZ0OhqPngP7Uuwj3i9bbN6kHCL/A
X-Gm-Gg: AfdE7ckIV+DpiWDdkmCrt8Z0qSItKkKCi8nD5DRMVKngMalmz1RYGq6Fgi/hEn2jP0j
	jCEpyFLvc2nVOyzMylxy+rmDAEFonKN8N1mWaKxZqtMWq8WczIs9WonJfPnhBqFvUDYL6Ah0On3
	nUqQDhS3aP5BkuiGgaDvyzFBrXI29nij512MYpigGT4ZoYIdhvtzwz2fR5YQlnIul86kcCXXJHU
	25ahW8z/ozk+CuMUGT0IAQGw2BseQ8KmKETshKO9xKc7RElPt5k9ZGI8aZ5wtFLBFTrTrjqpu6M
	lBRU4Yp9Hu3zLly6afu8H51I3UvWPhk666WPKrE+SFGMQpGH7telYIU8OEfrajxGDeb5XScaalb
	Owmq7hJKlOEErqBUBBcttlq9TUIGFAsEz8kBJjTPUg3sWEfXkrXvplgX0TuhBkIhu7F6ofKRMj2
	XscNgxjHvL4Z9GE/nm9B+glr0XAXG1NTuI5hJuw8tG2vxa2kyKpWGFB4nFPmqg5dUIHqz+Gho=
X-Received: by 2002:a05:6a00:2c89:b0:847:8971:87bb with SMTP id d2e1a72fcca58-8479eec6fd9mr551262b3a.21.1782759537763;
        Mon, 29 Jun 2026 11:58:57 -0700 (PDT)
Received: from fedora.hsd1.ca.comcast.net ([2601:644:937c:6c90:6d4e:7b2d:4a39:fb0c])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-8479ff8f959sm223955b3a.3.2026.06.29.11.58.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 11:58:57 -0700 (PDT)
From: Vishal Moola <vishal.moola@gmail.com>
To: Dave Hansen <dave.hansen@intel.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org
Cc: Mike Rapoport <rppt@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	xen-devel@lists.xenproject.org,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Juergen Gross <jgross@suse.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Vishal Moola <vishal.moola@gmail.com>,
	William Kucharski <william.kucharski@linux.dev>
Subject: [PATCH v2 2/9] x86/mm/pat: Convert __set_pmd_pte() to ptdescs
Date: Mon, 29 Jun 2026 11:57:35 -0700
Message-ID: <20260629185742.126987-3-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260629185742.126987-1-vishal.moola@gmail.com>
References: <20260629185742.126987-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zej516ik6g8i559n33y533e7zdyb4zpx
X-Rspamd-Queue-Id: E3FF280003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782759538-73104
X-HE-Meta: U2FsdGVkX18Ln2EbePzj7EAQ9KlpuvgE3ahw5brCA4U3eMnEtLJcOHHVjkl2Ollxi20qPro8rb2oEuVbhS6liv/7euCWTU3YFLlB7YJ++TJdFz02dSqNDnVsC8fpoD1xHTeFRzFnfcVwzgXmUCsA6pjamNF5yXB679YDB/zNiMAm1Zyx8XlSaRPxOzH5SsJkpck3OTo3miwC8xEqEqwbRsXduN+oGAvgsTt0uqUWZ7jZ5Qa2nV5hSYofpHjEwg8MpAQ1nQZyDEkwdIGMQuFjvHm9tJlxR5o2J/th308vjna1+1n5EG/aQ3EJ1tjMlzEwa+vlmybYdIbkPp0cRO7RLtqU4nIIcB8n1P42ipIimhijRvFYT/0D7x/En8nnjkx9zpur2pK2reCdlRz3RvPhOqaQw+mzRlCOlw8F/wQzqXWd9b61dNK2iPIQZC/404veK3IWLKi8vPZlncktLhf1pJHiBomEhBbcMihtpom3bPhDlE5m9mXuzGjb6RpF/Qp6O9t2nEC+5ctKK2RuHiVuRDSq0iMdxgtP01X564UiGv2M95uW+FOINgGthPrsbxQ2cQz+xHAb26DUz7/teDaqgwEmM9/yr34ElaeIaLLI7svuwR9As2x+0lAgFLEBXQiOHoEHJqa2c97Y59SBPCJMVsIdOXCy2CFybO6jzRu4L9vlPcvBgV9Lk8XmcVL3dhwqMLkzx9AtENC1eCNjG2kmgyTPfgdFjEKaM3HstogTw752CMkpF5MBUcnjQwcTHZTKdoT6spVDs0g8Uul2O85ihk2zMAd4808pib2R4fd02tPcK0fGZI5DUjYxFFH4wbuOqey6EWRUQnxD7yqQvA/b8b3C1e2SrpGjCc0QevdmcYLuFEKM8Yv5XrEE5aoK0RJFnfBHSXOasAMf/Oa/zHEQPBIRXUsXcx4YoYsJLPrmk6gh57t2yirxnemufVefIVuH/MMY61SOEqFXAycJfMa
 gugwYHDu
 eeV4pocMXPH4jDBzHjfdYiI0Psl8Xuzv0ZHw22xICNFhP2w5Ir7WHtZM/+QiFkCQ/kjHhLWpb81QyNyVdd+okUhZtypZQTDKfqwQ8xY+y8HqouMKvGf7LterCHQRar1ocq7xvUxcio+qpMB+EX48dPdcI8KZI8PjTimCofFWk0ySB+CtOH9NWbZ59j2YTmiIM6q/LEcgrLM1DT7nrsyyk/6d/jH2qg8vROXjy1qfcILWLbLJpyVQUMbWhwg/5or9f1s6DBp+cBmhfVlAT/5cH+6yy3GQ1qE6+9SmiI85LA5T2CM0eAR6jsL2R4I0vh12wc8yWPBqo/MY+D22rT5OZM0cdQ5VzX+JCbT8huFyw9SfOeGJsUXmLcJIXsbKLAeB2yxK3kE9q0CfrYIT/48XVFg9lt3zk0u8aag9ZRSJHtbRmTO6RFgODyi+q7t+gt35Xqsr0gIMn/rDS05rvSEpnQ4Qg3W12c+ql93d7cl+V35JlYva1oS2v7reyXqvStVBBYlujdjo90oqBjuokPj0fVzY7Fq6pehdH3wFH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert __set_pmd_pte() to ptdescs in preparation for the eventual
splitting of ptdescs from struct page.

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: William Kucharski <william.kucharski@linux.dev>
Signed-off-by: Vishal Moola <vishal.moola@gmail.com>
---
 arch/x86/mm/pat/set_memory.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 3b9032a3f315..93cb71451ce2 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -890,15 +890,15 @@ static void __set_pmd_pte(pte_t *kpte, unsigned long address, pte_t pte)
 	set_pte_atomic(kpte, pte);
 
 	if (IS_ENABLED(CONFIG_X86_32)) {
-		struct page *page;
+		struct ptdesc *ptdesc;
 
-		list_for_each_entry(page, &pgd_list, lru) {
+		list_for_each_entry(ptdesc, &pgd_list, pt_list) {
 			pgd_t *pgd;
 			p4d_t *p4d;
 			pud_t *pud;
 			pmd_t *pmd;
 
-			pgd = (pgd_t *)page_address(page) + pgd_index(address);
+			pgd = (pgd_t *)ptdesc_address(ptdesc) + pgd_index(address);
 			p4d = p4d_offset(pgd, address);
 			pud = pud_offset(p4d, address);
 			pmd = pmd_offset(pud, address);
-- 
2.54.0


