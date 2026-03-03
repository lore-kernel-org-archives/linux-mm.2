Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE8AAEDEBEA
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 19:48:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 214B56B008A; Tue,  3 Mar 2026 14:48:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16A5C6B0095; Tue,  3 Mar 2026 14:48:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02F2D6B0098; Tue,  3 Mar 2026 14:48:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E58D76B008A
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 14:48:48 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9A98113A6FB
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 19:48:48 +0000 (UTC)
X-FDA: 84505789536.06.91C6971
Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	by imf17.hostedemail.com (Postfix) with ESMTP id C05B340008
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 19:48:46 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=G2wVYqzw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772567326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6QZyywLR6W23Tiu7K2mRjVRgp5iZjQzJfzb8/E2KBpg=;
	b=JWd5l8D+dZKsLns9Ue6pq+29Y2NPul8W5EXCNyHyTGmQD4GCLe8e1PNu9HLDQ8Tc3d4OrP
	tj5+0+hWUR4C3B76sz+EuaXILFo/Cy+9ez8c4L4vobTXrIh72kqLBhKNfiM7hYLUy5k7OI
	HDraQ9/2odKP1L/utsha4FWJIZVMj6E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772567326; a=rsa-sha256;
	cv=none;
	b=YpUbzM8CYT5C5OXxJGWB3X/E4jyyL7dajNnDQ3na+Io6ScV1SQ0An6YNlP8vUF97wRsJRJ
	Za2yG+iTLZpNNCAfWKHuKN34njmNXHM4RMcG4J2HsCMF+M4lq1vdQGRm392kYBqCpwZljB
	9o29E+0QOGluZYxkeCsQyiHEUEZk3QM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=G2wVYqzw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-1275750cf9cso4897120c88.0
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 11:48:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772567325; x=1773172125; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6QZyywLR6W23Tiu7K2mRjVRgp5iZjQzJfzb8/E2KBpg=;
        b=G2wVYqzwFXH72vUFqxcp1PGyU58MyOeztn7+5CFCFGVbbWk6zr4mFdcWjnSv1J5t8i
         U0PWbJ1RuzpTsD7LHUgJP0rBqG1s3mf4UUw4QVeHEr3gECJ2AJAUwWzk0DAfGds0/h/T
         p365HQ5X9/MfETQRsT3nhdbL1OQDsmTX3OlMhKvTf8nKGUmSpQ5z4fuxqihfVk2ssqQN
         pQOxkyAGpEq4Y4PIE1EBw6YQN2/fyeEG7UpGJ3G1r3MpifUHXM9cjzHBzn+DQPhU54S8
         RxHsAcG1NnZUQeRPEB0dWzzmjgxiDFPAcJD0MwWQAz0nuf2XPlA3b7n3RLlFEQQwtaTG
         Mcyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772567325; x=1773172125;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6QZyywLR6W23Tiu7K2mRjVRgp5iZjQzJfzb8/E2KBpg=;
        b=l+dn1FhEig4LuRSxABhEN998CAy/SrQLlMwdsuaXCl0PUPytNpnVlR7faFgG2hohNG
         XU3oLYz+GBNz3q/Po/kcoOGOXW6D3N6nUZ1gESpjFjJb/bgoIuP6sJuBiObMtheM+M6r
         43z79WS8sBH6h6Y6WW2h4N+2eyot2stVkexOGNkqaBaYJXrhXuBm7dyVWZp8FqNvSGOd
         6zXl1zZKVBKDDr3GsWmMs0AibZjczs9mpTONBPkm81IYxmUCKr4ZdSJtRvaQ0aPnFS7E
         nScxe6BIgUoX9UPXVwukxuMubFYWNK/mpmlJL+zH7INY7aphGQOXNROyWOPrJ8YlNBlo
         S3YA==
X-Forwarded-Encrypted: i=1; AJvYcCXgzgua+qX01LSL7koQvqhzKbVe2CRyh7Q0/4pCgq+hrX0YICY1lbGkYlXm65OQMXiQaIkFIO64Gg==@kvack.org
X-Gm-Message-State: AOJu0YxZjYOq8afSLBRwnfBQ49Y6FtTOOnMLVtlV3OPmH3PPx0PrdiCJ
	mic+kI5D0MfX7D8KpKT5T75bqyBHuvm2d07+x6TuwkF3zZMtD5VF413d
X-Gm-Gg: ATEYQzzv4ADBko+cc4Ywia52MlyZXk3trbpkyr2hoaNNAutaa8E3ldAfkqHSEbEBY1e
	u0uIEtN1JrWyZ8A/ioquKssYvUBL4grSW/ln+twADBW2Fqclq3cgDqwHr/JbZ1WmiWMCJ8/yc8y
	w0IqrNrTQBItgYebP94mngF5wOIO3LOOcGOhDP2yYTbVzGJiTe5ZJPMraUT9N0Sq2mmvcEbMOLa
	D7T123Toiyg1qDgeVBDJTp6pZDmAlfxFxj3QY43euo5bM3GxnAYqomq6cFGiWU2XroW86a3Z5Ba
	G+fU1OCCn0WkZEARKXxyZOxbSq6tXI8RwRjk7sCWv8oLt4y+42TPIOaK6alVKJ47EZFcR9X/Ld5
	k5I7ocle8RDHplgbWxV31fnLnsjfHQjpOMez6GLzmFRB5uGULeN3S2xz2+ZQCAhqKZUsck2xshF
	aseLjnEBo7G29tFMnZKv/g3wnM2bg+F9Idsb5A3ZRY19h7RCX686NNdY9d06Ntf/yG7IXFupCFy
	2XyPHabMjMPAbM=
X-Received: by 2002:a05:7022:68d:b0:123:3103:b22a with SMTP id a92af1059eb24-1278fb68a91mr6843228c88.3.1772567325341;
        Tue, 03 Mar 2026 11:48:45 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id a92af1059eb24-1279e9950cesm9258748c88.7.2026.03.03.11.48.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 11:48:44 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Lu Baolu <baolu.lu@linux.intel.com>,
	Dave Hansen <dave.hansen@intel.com>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Rik van Riel <riel@surriel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Juergen Gross <jgross@suse.com>,
	Yu-cheng Yu <yu-cheng.yu@intel.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [RESEND PATCH v7 1/4] x86/mm/pat: Convert pte code to use page table apis
Date: Tue,  3 Mar 2026 11:48:24 -0800
Message-ID: <20260303194828.1406905-2-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260303194828.1406905-1-vishal.moola@gmail.com>
References: <20260303194828.1406905-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C05B340008
X-Stat-Signature: ux7penfbq6toyweiipxq1gmj8hb78dnc
X-Rspam-User: 
X-HE-Tag: 1772567326-752361
X-HE-Meta: U2FsdGVkX1//oxOm6+gEsnyHlh25f/mam6tgkrcsQvlVr9ohOl5zWzO4c5B9Wmasi9bsEp2pgiOwmrjd4izveaNyvOy2WNRes6dJbEedpJ2B5UEYkCT+A//U9cvP7AOmyONx+XcMfocDWnHA9gTkpg+h34a+Ed+FQV5e5wlVgyUuSNT6j9tNUX+cwrM4p0pyRLD6AntBmPOGgm6joJdVYLYpF3A9exp16QgFpnBoIquD6Kfhzd9zvd8ilymY/tXkOEz9TCH+okgh8lQWVqr88/O7TRIsKmKhvbDbjkI+EZwrNjq5eqoba6gcMHxg0tq/en85h3+JGdpYbkKXw6NrMQPGAEGK7mdUc2csoLR4R3MzLCfXEvZV8Xzf7S6D2Bw2zf676A8WTdAqAAEyort5oj5C21wZU5wu0c9svrQ16Xkq6yBk36xVmLWXlk5MDC7ceVjeNGpkAGvj5sOm/QMb3aWX92yMdyNo93MN4msw+4fVw7RQJi2HtFawLOogTgFF8lrHZ+ofWRzI1YMNh81EDa+eNT6BzylXrchqTtYhN7Rb/3BPgoEnxCddBkefK2jiti9JcGaumQVWLg5HK+DkD+LGjEFXQyScyTa+lIAZJpzLRiID/FXRdeNmYt0bZ7je3ArQ5j2gOXK7x6z3TGdbwCMjvQkx3UBz9VFeZvUh/hfcKFYyHsg3SlLTRY2uXUL92BbtpQg5IOMtNvgXvRShL0k/XLyy+WYu76Gx5WuZIx+bMPzsMlG1sFbYniBm5BSUCF/j0myA25gdJu7jicnpOi3LmT4QSLd455KnDxXYcrxZ7MQ09rYlMZDNQ2EImMNnqIYLCuxo6g1KWIX2KgNhCq8+KqYu9bCKt1orjOb1JaUE5+4ukSDoCP1/Yz6sJjlBdhdXuiw5TeG3Vgtp34MVhu41Oa1c2Mx8uCm/162sc3H6YriAUvNK2XDDZ5hiefJRcI6R8xOo1CjZMaf214B
 6wo/x1kt
 rMYUE+XHdw52FlqmQ6VZNmWvsXCdp2GgcMCkzWDzQxlyZId2QDHdz/S8NkV6ctoZ7g83GUy61AOkmmhMM1UXW+W5Xk5o69wkbKTuzRVQCq0/BncF9Ka67pRZRtIBoPcv9k7UTwZKRLPW40GxQbE1jD/Bqv6rzB0GhtR8y3GZ7Phu9mYEneTc09hSKnyWRZiphWw6YJtyEiPquyUHy6EZKnCyou0k/Vs2koAiC32kpDABC/pGrFTFXwOp/8ErjLZkNAW12LV9Pk+YqIvfHF8934lNd+rQbyxxeKLVjj8fnVwhcBvy8K08LQrEqxIcT5NV/2Gfuqf0gfHyJc2HD4A0tuVOPpiWdh/CLB/lYeh7kVhnfzwohwJPyty0DjgNEo4gysWV3Iaxvj/mZIp0ciSaxaRFuKGrZztzcl0S0TaO3KwfuSkraWfH5v1IEtCT8vVp1GZLqABkQY7d85l+3dDNNhWHUbWV9nC8216PYQij/9+ye1xE8MSUxMZYhR4chyT5eTGWHQCG/oVv6lUGWNRLNp/imkswwAIvcXOsX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the ptdesc APIs for all page table allocation and free sites to allow
their separate allocation from struct page in the future. Convert the PTE
allocation and free sites to use the generic page table APIs, as they
already use ptdescs.

Pass through init_mm since these are kernel page tables; otherwise,
pte_alloc_one_kernel() becomes a no-op.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/x86/mm/pat/set_memory.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 40581a720fe8..a4b1b329c23d 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -1408,7 +1408,7 @@ static bool try_to_free_pte_page(pte_t *pte)
 		if (!pte_none(pte[i]))
 			return false;
 
-	free_page((unsigned long)pte);
+	pte_free_kernel(&init_mm, pte);
 	return true;
 }
 
@@ -1539,7 +1539,7 @@ static void unmap_pud_range(p4d_t *p4d, unsigned long start, unsigned long end)
 
 static int alloc_pte_page(pmd_t *pmd)
 {
-	pte_t *pte = (pte_t *)get_zeroed_page(GFP_KERNEL);
+	pte_t *pte = pte_alloc_one_kernel(&init_mm);
 	if (!pte)
 		return -1;
 
-- 
2.53.0


