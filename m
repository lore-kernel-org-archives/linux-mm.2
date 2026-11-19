Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FEE0606A32A
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 15:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=readmodwrite-com.20260707.gappssmtp.com header.i=@readmodwrite-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=H/3OueDx
Received: by kanga.kvack.org (Postfix)
	id 6AB906B068B; Thu, 19 Nov 2026 10:32:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6834E6B068D; Thu, 19 Nov 2026 10:32:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5992D6B068E; Thu, 19 Nov 2026 10:32:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 304986B068B
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 10:32:14 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 033BD1A0B4D
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 15:32:13 +0000 (UTC)
X-FDA: 85452259746.06.391DB7F
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2253920002
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 15:32:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20260707.gappssmtp.com header.s=20260707 header.b="H/3OueDx";
	spf=none (imf03.hostedemail.com: domain of matt@readmodwrite.com has no SPF policy when checking 209.85.221.54) smtp.mailfrom=matt@readmodwrite.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795102331;
	b=UUERipxHAFRWpY+dy/u405PWsUjYT3ylJLMScjreIa4p97FKIUMKU9AOGoIf4f+sv5fj5x
	ItxwcF2I/nw7z7iGRfVV7AmZl20UDXjR9CwqmQ25FWJouQQthtzJF/Ad4QAup0nGGfgkOp
	g60tBn8r9Z3lRL+Uzykv0LSDVLnHUig=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795102331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fcWwNEHkYlUPLQ8a1nsTOUqqcSFaeduCjApaxkKfvSQ=;
	b=HUOQQstDEeHclyQUIRvYSmYbi0uIMn/5wNBrkENIbuPkKOYVFqJLlDx1HUsQVD+HhNkj3e
	AdX/CqZTe21rpHDi/PWjqfZGsg6D2CLVSP98dZN1Jl5DR8RO+3Dh83hZktcUxqxk/KaLRh
	dVfgGRKGk4AdWAaIM1uzG9KMHy062Zg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20260707.gappssmtp.com header.s=20260707 header.b="H/3OueDx";
	spf=none (imf03.hostedemail.com: domain of matt@readmodwrite.com has no SPF policy when checking 209.85.221.54) smtp.mailfrom=matt@readmodwrite.com;
	dmarc=none
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-4a33359c1b3so1714575f8f.3
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:32:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=readmodwrite-com.20260707.gappssmtp.com; s=20260707; t=1795102330; x=1795707130; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fcWwNEHkYlUPLQ8a1nsTOUqqcSFaeduCjApaxkKfvSQ=;
        b=H/3OueDxOdWfMIi0Eh+0FdN3Ew9VoiNZvlEixlxzaaoFAjxx+LwveQ8nFr3wiBFpIM
         EY+bYhp/1MDn/55DydiCgeRVxq6/9/hLxdsO7IvBYRIIti6yhv/RLEO8UaS0NRy4MHS5
         w3ehSa6QTYicyeWAEF5HRTyNpKubEokxysy8I0GADGnCe3MuQk3xqMDN3b3HQ7s6XpjQ
         EXW5MbzG0g+EEqNzTXDWN2paUu8mH2tE/YZTo6/LFkiA9TWhU5zji6NgdHSZSX4GnCf7
         qAWccMB3J0DQz427FAl1CxrG65RP2FNcUwJ4PX67W79dywc5ASzulUSLXMrZgKOJUl3+
         2NIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795102330; x=1795707130;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fcWwNEHkYlUPLQ8a1nsTOUqqcSFaeduCjApaxkKfvSQ=;
        b=WT8LyV4nBCBhHCBRpanbqeT8Nbm4y/iJrYUMcZfsllZjXrOPfItkEpbNX+5p6PoHPo
         44/JdzxkFzSK+ytdCjcwV2YGo7KwlSLiWjOgYlJ8mh60YBlEd5EqxK5DABbGDXvYiTxp
         aZbmR0ENMf6b555kp0nlXgmFhAIvQPyu/rhPQu6/5qfmQOC8DAH3wg3ljF7XRXV4uhC3
         MUNnSPYG9JcmA1PD49wOANASkJXw6IrnqpQ3/5z/QjzUcHnEob8WmEXHjBv3kz9VbBwo
         wO1YIJXQN7T3iauGOrTGZrKcGpSZ1MtOIG3cpyNemCEJhWlYxHozUgbOKRUld1fVEU6M
         MfoA==
X-Forwarded-Encrypted: i=1; AL+hErHiUAf5vxcSCqrP9rfeMwKZaTFl4WfCXAc/60abX0amKnyY+PJgCiAkUIuz/DglFDgGld/J+0F+3w==@kvack.org
X-Gm-Message-State: APuU4Z81w/8DCV4lRnBP5BCX7xc4iSGqsK4NXGAQoD8pObcxq0uzbopb
	U8hILWRRGvcb1bhlDuQpe2p6CcTGbnYJYT0ht7B7gSlDG+kQ2ZaQMTYKYEnqxaqFJo8=
X-Gm-Gg: AZFdTZdomj88WWY730/X8RQ51GbJ7nRfLrlFrtUbV+Btqp77gCDibyp+TcU5BzCFiNm
	nMqggZ+pnTPyVd+EAvW2yAZmA7cl069sDZfuINaQYPBwVIZHVv540fL3pUYm1xsn+w9f/XKKCF8
	6RYD2DpJbfNVBwuP4s1dSF0NUYcyOtRrqULhx6ZWhffzW53eHymsRn18CTIs7GR07ONRFeLereJ
	40KIVOEUqGo7XD7vcPjLHjNda7v43nv17f/Yn6SKYJSGjQQ6JBvJEU6A2Zn/u19ZJJKbpVsfgBW
	z6c4J9FrrnG+AXWM9d4HiBqqNqWFB5yL3pQ3WHXGjvIapZc8Gl/UN4vOHkTLZ+kCDKjMihgVEso
	0T4/rXcEYtOdt49vswIWjVI1ZOYnUNnTlV2tXvxW2z5TH2n8UuZOIqq4x1BS7asYchGMqM6yL5K
	JxQguapzp9/FRVrxjjsk4biPMFz+nNYdiFWjwzmDlVfT2w3yCC83f4HDMwtJTMJdT5GlUoF+8IL
	Q2bm86Ium1J/OY+KmEwl/GPGiFh49DCUAsSv6JBLs6CJbbwUZMruYpnuF87FLZHxiPx9c8mrlCQ
	0hWbvTbHtHTmINpawRT8tCxGn3AV2G6b
X-Received: by 2002:a05:6000:2382:b0:4a6:bc53:2466 with SMTP id ffacd0b85a97d-4a6bc626983mr11814917f8f.16.1795102329755;
        Thu, 19 Nov 2026 07:32:09 -0800 (PST)
Received: from matt-Precision-5490.. ([2a09:bac6:37a8:294b::41d:4e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab65cb41f4sm237463f8f.7.2026.11.19.07.32.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 07:32:09 -0800 (PST)
From: Matt Fleming <matt@readmodwrite.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Vlastimil Babka <vbabka@kernel.org>,
	Caleb Kan <calebkan1106@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	kernel-team@cloudflare.com,
	Matt Fleming <mfleming@cloudflare.com>
Subject: [PATCH v4 06/10] mm/page_owner: Read stack traces with stack_depot_fetch_into()
Date: Thu, 19 Nov 2026 15:31:39 +0000
Message-ID: <20261119153143.4099483-7-matt@readmodwrite.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261119153143.4099483-1-matt@readmodwrite.com>
References: <20261119153143.4099483-1-matt@readmodwrite.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Stat-Signature: bk6fttb8hieb3yr7jbe9mh3komix5im5
X-Rspamd-Queue-Id: 2253920002
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam08
X-HE-Tag: 1795102330-877151
X-HE-Meta: U2FsdGVkX18V535DOoLvFushi+8ydan7RK3ZdosalaG4mcMP98TQnG7jUNdJLOZ2JBsBXT3NTsJSeoS2eRN5kZaVdJi86gAkOzlAZcfnF+N+SUO7x62270i9ysZlM05VZHL5wXfTxS7uLi6d7U+C00nUGyTZ1w/Djay0ihedkL6fRMbCCOuh8Q086KlXIbu6HjqgKNEm+9a9K/JRyd3Ozi2/KQ8La+1FuLVGJ8zwMNSId5hOBG3lIE9+Y7gw8Cd5iuwVt2BbLFWmuno9c/TBNNKQ3/OY/wG43/44Xac/UXZRw5WuCoFxpN2bgEcF0+SbNFEBf/gRLI2TmzL6J5Dbh/y1/XZ2z+nm/C0xLqPHJZnZABL0P3CwWzL+oT1QiKF/TwZwAKfsZhnMhZbSecBYSU1itehcgI1Tbzlsqt0u0TzCCTlT9fttcblwLUmBoJAy3JoGvEz5zg0+p8cfc6yiorMkWzOGaxY7/vahSyNWn8R6MybQobAQ2nOzBLPXgJTOO2V2ztU87AL5XwKBRs+KLv2Q31FExNZmOYigdfDGBYpJ/7M7imdUOSWALrEZAyHnNg8nivTxeF8B/KAzXR2kctbDyOHJZfVQkI8So2SEnYvV4bzGN4RmQlrdWXDVSyMISRc5cW0pkz6clj/LFGL2dCwJ8HSGifZnq60EsgVORr/IUoi9J5IAnTrln3+0MujQ8Rqz+gY6srj1dp2WStaJSWOYibxnZ4RomD4UMusE8v8HTA7ibLqgA5jIpAulwxHVaYSL1BJhW99I2u9k09fZ3NVdkkAtbVjZQv50QvDV+Ohl22/W3LF0FJxaUQ8zkD4eFhZ6F9GqrnFBN94jmK3sfSNeNOolURfYJOk0QYmQlNOBVts1JkmwTwsHKuWTUaW3kT0H1/eO1DrWsDTTCHt0oprPSduGxXNcbihV3+em9hBiNhu/7TmJ/QLdfBqTPN2xctQfcCmFCQIUbeFI1Fb
 hUr7FJaw
 moINsssEvt0b/b0zeJQo4tCzFvfW0rx0KGV0/Jx7iiwZ1rDHeoPoNZCUghGDpK7iw+rjyQFmpsLe0q90BP9Rj3mviiWkPmgIKW6wt6Holl+trtWAkg9jCGalxfO7nLtqLvRb2Hs04E3yQxYvDX0+rOXE/6DWs7VafdHceKyj1HGTv3Ix3FWxU4u88+lASVaOykIjF2kyVE/eXGKivx+NQ/mdC4EIlS0anPU297mOF0XZVT3Hr/aD3zXhuwGVF3CeDcauIwg+lUrYBE2Cmcx2Y9dnWS5e6xOQ1qJF4nY1LLYukTKjjC9Ko+6w4P1fo4YPjFhXxQIPtcuwJabIgdjfX4/fB+UOJqX0bEoXTDoiRGoZUgulOHI8rckXtdKHnqPc3UDT/ZO5PZy6i2Hm+EY3zR3BB/3OtUAu6SUjFmfclwXfb2SHkYp9+OPupFNAp8SPvsSiku/Y0VVGq85lBsKJkNEf3cw4j8yqKCQufqg/QVbB+GwASCyFkyZ6OvCwroeoPYCgvZGfx2RSZ3BcKy7peB4TlAzJ2KTqXLK8EC6c76+/4U56+6+9HXj1qtiSbPKMQcCmX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Matt Fleming <mfleming@cloudflare.com>

stack_print() reads stack_record->entries directly. A later patch
stores compressed frames inside struct stack_record, so rather than
decompressing those frames let's use stack_depot_fetch_into().

Copy the trace with stack_depot_fetch_into() into a stack-local buffer
with PAGE_OWNER_STACK_DEPTH elements, which is the maximum number of
frames page_owner saves.

Signed-off-by: Matt Fleming <mfleming@cloudflare.com>
---
 mm/page_owner.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index cfc31c92d765..16429e70e00d 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -1068,8 +1068,8 @@ static int stack_print(struct seq_file *m, void *v)
 {
 	int i, nr_base_pages;
 	struct stack *stack = v;
-	unsigned long *entries;
-	unsigned long nr_entries;
+	unsigned long entries[PAGE_OWNER_STACK_DEPTH];
+	unsigned int nr_entries;
 	struct stack_record *stack_record = stack->stack_record;
 	struct stack_print_ctx *ctx = m->private;
 
@@ -1083,8 +1083,8 @@ static int stack_print(struct seq_file *m, void *v)
 		return 0;
 
 	if (ctx->flags & STACK_PRINT_FLAG_STACK) {
-		nr_entries = stack_record->size;
-		entries = stack_record->entries;
+		nr_entries = stack_depot_fetch_into(stack_record->handle.handle,
+						    entries, ARRAY_SIZE(entries));
 		for (i = 0; i < nr_entries; i++)
 			seq_printf(m, " %pS\n", (void *)entries[i]);
 	}
-- 
2.43.0


