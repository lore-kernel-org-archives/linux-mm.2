Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70AABC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 15:18:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F9666B0279; Tue,  1 Sep 2026 11:18:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D0CB6B027B; Tue,  1 Sep 2026 11:18:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E6D66B027C; Tue,  1 Sep 2026 11:18:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 572386B0279
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:18:50 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E7C1D40236
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 15:18:49 +0000 (UTC)
X-FDA: 85165550778.03.01655CE
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2902C120011
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 15:18:48 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ovSHvCPq;
	spf=pass (imf29.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788275928;
	b=RRJYBsO5b8WW37V0lVwnSQTL49omLZVbU+cSaNK5iDNW2Wpg74VUyti8MPEIFFt2W6Zctq
	9jWGBJRfhk5V+3U8q+gZe6cuCcC7iSPqqa4fbi7HVWKYEfYvNg+tklfUnpCbUm3klMWDQU
	1D7sr81xWUOaFoIZ84LP7356oksxiGo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ovSHvCPq;
	spf=pass (imf29.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788275928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hqt0DA3rHMBC2JGEPtQ8G6D8wkEO9isBswK4tBDKvpo=;
	b=64iQ3HJqoG0g6rmnEtMT3HG1UXUOg9298JkgXqgXZUM4IlL3lt/lRsb9N2Ns8j/Z/A7tt1
	fGUhs/aSiQACXFr8krsQhUg3Clyn6ksrwpNxYk4+6GVUafYVlKAk9ARbF9G0ORQuRyorhc
	l2HWb4qAIulxmlPWYYChWh0A7VeUWcA=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-8485ab7c382so543565b3a.1
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 08:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788275927; x=1788880727; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hqt0DA3rHMBC2JGEPtQ8G6D8wkEO9isBswK4tBDKvpo=;
        b=ovSHvCPq212UnSyvIAbFZbiHbYipQqaAIUAgQcdatkZJxF5q69u3V0fV67Ap44fLtw
         lOhSXVWXTVJnF5iQly3rdvQJ7eKVce8hylPLO97fylkNadrrFgZSXT49gpOSRLGfX1ks
         p0gdEOQ8G7qB418VB79e3b+TZsvKX6vFDLbmoopm/S5XiJ+ZCwz5jjBHVe35WngRjLz0
         zLCo7IvDuHxjJSgha88K1AcEy8zVgfd20DLbRtmq1a/4ofG2RXjEt2NDkb3hEwOj4NxI
         ugFOs+8xrmugG5Eg1B2c6hOjE8BL6wRxrttjMfsXN4rq9kw7U/M1yryxiXEBwGnJ9kco
         7Vdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788275927; x=1788880727;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hqt0DA3rHMBC2JGEPtQ8G6D8wkEO9isBswK4tBDKvpo=;
        b=XEhc15z7i9UQ8XumfPZI6CO03BULdrT0niOaEtkM0T6rzMxpUjyXgjAe/fDl0+Mutm
         MgneX3DRtbVJtEpw5QvmLskx2crf8yUaPz9k/d4sOAc8VYUN+w6b+d+2oHAzlWTvrf/Y
         WnT1cJOVtcxyiMYC3tLyGjwoBwTaN35Nqs+iVro7z/zRVp4fEIccudPHQ3SCamvtBPmg
         JbzR/+Uf4p8Ris1I1OmVri15KtaDlkWczX96rfFVxwdb0dRxBqJROb6cQFpNzLrBwuF1
         5RY5Z4IoD33zSsYbCqGHOTA2IfPawwlEX1nJa12RgjhXq4ssb7qeLsVwJqFD05dLysze
         mXzA==
X-Forwarded-Encrypted: i=1; AHgh+RoPJxfQZBO73b42tfuFuHtPC0jlSrG+L6JnMyWDt959a1Gv5RYCT2abt2ooR08ta5SQtk0O6rhe9Q==@kvack.org
X-Gm-Message-State: AFuF++ljTO4ipFrYfocSivCcsFPmkg66D5BAaMm1zTDimFnpgh/QpC5T
	cWuIcwuQQ9BOD0Uvuu2n/hzDtuH1gAoOr98/w1YawjUcc6cHBk8pq98g
X-Gm-Gg: AR+sD10ZV0E1ZPguAZNBRtphiPK9jFfFBJukUwxKz3R6//4pJ3KsoOEkyZwA+/1UMPr
	tkF8upJnv8aJwQIa3zazFb6eTXXzA3ajkMQOcIOV/L+yJQ+XLBQ3qbY9kMljGr5OwTbWBWMZHxF
	be9UzHZZAt6vF9kXC6VmoqhA0jsLHPiz04ZajHeS2mFCHF0rjTPacqmSBGXLiKMpPQKChOry427
	smC+IqKVp5p1oWUi22Wi7eNsc15uqgtLWHNPwa0GEgLt7v4kgTmQ1ILgTqDCyhSt5dFD+jODE79
	YcH5TXciFxzTVfcFrgITpn7XL/sOob0IwcI2YXQU938xDWylzi7NbAprh+uM+P867UHjFpQ8pnV
	GdKC9exrzKLYlmYM7a2Cr8g+uIvvNgX+zKpU2ATcKeWPkqNC0AnivzyP8l8ow3ba6UnUYm5T8O8
	FtE1uhtrgjJuI0RrsYHHZsqqH9chf7kroDm9v7LNZHIiicSLLR/QKBycnu7Kk0sHvO11bWSA/J/
	6NLBlvHShwmK96JKzq0mEXvKg==
X-Received: by 2002:a05:6a00:4903:b0:84e:b5a9:ca3b with SMTP id d2e1a72fcca58-85625f2c0c9mr21548292b3a.0.1788275926871;
        Tue, 01 Sep 2026 08:18:46 -0700 (PDT)
Received: from o6.lan ([240e:391:ed0:47d0::1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-85db24f33a0sm89911b3a.9.2026.09.01.08.18.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 08:18:46 -0700 (PDT)
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
Subject: [PATCH v7 2/3] arm64/mm: add set_direct_map_ro()
Date: Tue,  1 Sep 2026 23:18:17 +0800
Message-ID: <20260901151818.3191443-3-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901151818.3191443-1-xueyuan.chen21@gmail.com>
References: <20260901151818.3191443-1-xueyuan.chen21@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2902C120011
X-Stat-Signature: 7jtxcd75pofn1cjckwe1e1w5sghf4ubd
X-Rspam-User: 
X-HE-Tag: 1788275928-324655
X-HE-Meta: U2FsdGVkX18bpCArZhDiwdM6RPj6/+gTEIvT3OeppJzDvdRP/k475UdDre7cJZzWG5hCPiXXcQcrpWl9jj5sY8kqu/6LJFVUX972cuOeRaL6Jw9iIzHpErxn/Y1s4efE2tPxf4WZMlemJC0r5xPPrN1gcanWoBGGWirCr0g/xGRW8Icalw20oXcISCgMvc5/kPJNRx8Sd+TuQYt3cGzSCaD+D5paNAIuMA+Q2WL09BYuYmSsFC/JgZ05cst9Ln9oMYkbkVa2+6Tp63MwyTj+629DPZM4Uz++rbdCBeYpSWOt+z9qxTZn3iPF0F4Xav9aJ46B8/b2TO0UCnig5ZrcKR7qmcFr1kw3NvI5uvI5qYphML41J8KKYQ/y2rz3+QuV6OHe2QSKjjGw6t70SNaJnVOUKO882dvwNvQ/TF0GScdVtbpif1ZN8/x93mv6TYdAJTwNdielG2/nC3+ZfKyBR7E7unhcP56Uroy2AwuTJl36qKWELdF13fePz7eG51NFe/8injz95iqSTyuaOqrEWXLssKs+216OYamMtKa+iPRBs/pLyexSvN24CPmi5UtLpyhHV88rtVizkAD/9Pgusz3zUAQ8w0Z5q50e3efXB/3yuc6cctogXaZJe9Xx5VYMoAY6cMhuS3sBZJqew2KW9eFxdbIce7V1CFXNlS1dmmTYZdyp9j43hxlkCdLZ19PirwbLZ+izI2eTMlxXLmpSSJ544sx1A8OZzakuXhOKfhp7R9CgDUMSr6/3v7jX//F0sNzuBKQeLQslviQQQamQhkPQMi2N13UrLBGw8Tt39sj0ocY1P3EoccjFcXxtfnOYouedUZA2CZYIEjhBlJ9e6XYS5SctiiPNWzVPh4Jp6z3t+lzJ/T1rqZHnZmHBEu36Z7z+OeCKKzpG5Bl0j1m6itJO3PhfTQhxr12M7gAvpHpuahwyt7oEZ+Ky203NyQ1UkUv4KToR+JfEEkwPLUR
 T/isVCQ2
 oi0aQNMQ+YlY5WJE5JRP3l81x07gr/Yb2vYFrWB7Gzb8EySDAPd/b6lwAv4lOYmglCwSOmwv2tr5sm9vxDHR8MAenPgCHX9/U7YoKHg6zSxGbkMylO62HdecsZCvoki8Hp0F1exLxJTRWr46ur4LZE13n45ZqPPYEMFKq4YysS5+zuEWokx7CoRmI2hv8mwLHHcYDm365ILUsXKcbrX+8Ko/kUpWe9ZqaK8qc+cFDLb7QStU0NQ52fikNYeQ3F0OHVYHLaUsAUS1PslkBBesT1uuO57/8V5Z0AM6d9beUHRsQi6muTOWAgmgLg5O7KFoEgEN1j5KlK5DSWAdxa84ku5/KPSBO4BCUafce7EKjB4SRzPhlNgLIPmtjbbLlYJOV7bbVU7O6JW7agfZk6Zg6JxAbIgxUw3AXiKiG2dysrYaNnEQGEts/3/vtc/UUywTGjoI7LaogZB5q2V+cX5Mao/+3Pp87eAkX2hEQMBf76YNXV+qEP4T9A+yjWNgXOtCHgvkJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement set_direct_map_ro() for arm64 and flush the TLB internally.

Co-developed-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 arch/arm64/include/asm/set_memory.h |  2 ++
 arch/arm64/mm/pageattr.c            | 12 ++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/arch/arm64/include/asm/set_memory.h b/arch/arm64/include/asm/set_memory.h
index 0091ba12200e..1be86dc11543 100644
--- a/arch/arm64/include/asm/set_memory.h
+++ b/arch/arm64/include/asm/set_memory.h
@@ -13,6 +13,8 @@ int set_memory_valid(unsigned long addr, int numpages, int enable);
 
 int set_direct_map_invalid_noflush(struct page *page, unsigned int numpages);
 int set_direct_map_default_noflush(struct page *page, unsigned int numpages);
+int set_direct_map_ro(struct page *page, unsigned int nr);
+#define set_direct_map_ro set_direct_map_ro
 bool kernel_page_present(struct page *page);
 
 int set_memory_encrypted(unsigned long addr, int numpages);
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index 132938b32eb1..0e95cd904ccb 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -355,6 +355,18 @@ int realm_register_memory_enc_ops(void)
 	return arm64_mem_crypt_ops_register(&realm_crypt_ops);
 }
 
+int set_direct_map_ro(struct page *page, unsigned int nr)
+{
+	unsigned long addr = (unsigned long)page_address(page);
+
+	if (!can_set_direct_map())
+		return 0;
+
+	return __change_memory_common(addr, PAGE_SIZE * nr,
+				      __pgprot(PTE_RDONLY),
+				      __pgprot(PTE_WRITE));
+}
+
 #ifdef CONFIG_DEBUG_PAGEALLOC
 void __kernel_map_pages(struct page *page, int numpages, int enable)
 {
-- 
2.47.3


