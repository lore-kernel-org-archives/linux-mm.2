Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FAD9D46617
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 20:13:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3AEF6B00F8; Thu, 15 Jan 2026 15:13:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBEFB6B00F9; Thu, 15 Jan 2026 15:13:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEAD56B00FB; Thu, 15 Jan 2026 15:13:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9E9BD6B00F8
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 15:13:15 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6CE521A0309
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 20:13:15 +0000 (UTC)
X-FDA: 84335297550.30.BEF4107
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf19.hostedemail.com (Postfix) with ESMTP id B2DE21A001B
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 20:13:13 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iAy0eAk3;
	spf=pass (imf19.hostedemail.com: domain of manish1588@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=manish1588@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768507993; a=rsa-sha256;
	cv=none;
	b=5nmboE7i50PAewqU+kSdv1BN95vOZfk7Fbbbn4oH7FkGyPbFFFlLdNlNiafstJmNXWQF3F
	AoxZGNXdFlntm9ZfLovo5nZW/9HVG5JEKGagc10uRahp7aZbMCrsvNoU+2Alarud+gydIB
	J2Kn9uYY5wA79SO1U8SOgQW8vP3uIts=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iAy0eAk3;
	spf=pass (imf19.hostedemail.com: domain of manish1588@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=manish1588@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768507993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=tlUsscsYUaJ1E2vcNvebVKuOn51GC41JpX9QJesXTnA=;
	b=BwP+gUui1QrFOzf20jKiaDTvyBch1hkgYSsVvZRj1TYv0PgGDsk5qaDmLwMA8Cdvv8jbyw
	c7I0WarHFcGebNSQjP6bqlHCzLPPrZrFgR/QMdnMAKHMv+MjBds+JVQl9E/5yRAMz8l/xX
	ta36sdLphT5iWz4gS2fMBtJCAKNgK8A=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-81dbc0a99d2so682451b3a.1
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:13:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768507992; x=1769112792; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tlUsscsYUaJ1E2vcNvebVKuOn51GC41JpX9QJesXTnA=;
        b=iAy0eAk3tiVLb8Y0axvwntlCzezZqiQ3XlaDaA2plgY2uY/HYA2gjWikwytcrbvijH
         m1kBJul6LDA9fTHCXC8kLrx5rp+Wo1fn/auZRkyCptbReBKRReDOS9FAYuvGEiYH4jld
         CdOw90LBpJEyuHY3OPv53ds+NlleXBLQZpjkcN259/YIZ7jPivkNAoI9ea6f71daj9lq
         3pmidArhwGbg4O9/q4n0M9pei5tTHDoJfQkZeXq5A9VaOKRA35NLTr9QzQF7nnuFiNne
         c+CIp/cpWjudTZ4dSH7x9TDVVZ6OyXyrbsilt03pLBXxzpLWD9t3F7JiwUgPcWcCIBRS
         ssZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768507992; x=1769112792;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tlUsscsYUaJ1E2vcNvebVKuOn51GC41JpX9QJesXTnA=;
        b=wf7aS06t2ksnRJ12MAhfMwOdlP+/1hguoPylK76k2SjvYjaCl2LZ6vNad4CzUMEJ+1
         dQKsrpHIVpjv9XLqDiQLKARY83e1XTTgVCAoNzm8XmO4PaYV+qIZWZRHgupoamKHorgE
         LJ9s8rA54btm4Rmu6aJMI4CsokebjKA6pPsWe/o6Q6trNqZAGophCOILnOPofrQoVvsF
         d2RMYPRqlB6oMqRwPuswOLC5iSjz4+zrTP1J2h0KxecQEytEb11jjBCio1Eua6tx/C31
         +EBlKa99VlKVVQl+38Dms6LwlpePYeE6dIDVnnp6qj0eobh4Wxuk+WFO9I3/09brQhyO
         jEfg==
X-Gm-Message-State: AOJu0YwCNeVCrnhd31+q0m+OGZOaLdodToJZ1yTEEpStoDUVYyjTtnVC
	VnQeynoL7mllUb2+2q8snlwgr+6ZVwZgOi13wAvWGa56ehAE9KxTpH+IiCnWDg==
X-Gm-Gg: AY/fxX7bfLge3U6FXT2LtmlKVqSmp04mNQ6vKVOBYVF31PC+IEEu24JaUQXzKFl9oLb
	dxOpR35gW1+wwSkb66EyD5yf4DYBFQx2ttoGDKA7CRYmyCskbPAmaqi6dKj40OIdGjpOuTpKoU8
	64+4dhvUPlL6JibhJamnkmJYcovjrLu/B+vYz/xF0m4fgIKLot4xidqUueY/e2OJmBs/rBUJ7vg
	9zcEr2ZdpuU71EC66JUaawFd/fz6DI5ZKDmcu351A/L6v22cMafAU+LOJpfzt8fI1Z/vigX0HTv
	WbLf8LWhav1OmamgsVUL5JjHt5E0ey0ZWBdGko/uSkmpeLdgEmV9ZYJUeRuLmfUp2q41czq4Fdn
	Wg2SDW4u8h5TQn71ymKmyyDFRAgeGRVIlKv+XLKyE97UYARCZ2CKeHjUkN1PF+2wJGnjKHLiWbg
	Yaehf/2rlbuJozFDWS+Q==
X-Received: by 2002:a05:6a00:ad3:b0:81f:473e:e8d7 with SMTP id d2e1a72fcca58-81fa0385493mr736315b3a.54.1768507992388;
        Thu, 15 Jan 2026 12:13:12 -0800 (PST)
Received: from muxbit.. ([122.171.16.181])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-81fa12784ffsm186714b3a.40.2026.01.15.12.13.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 12:13:11 -0800 (PST)
From: Manish Kumar <manish1588@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Manish Kumar <manish1588@gmail.com>
Subject: [PATCH] mm: fix VM_WARN_ONCE indentation in page_alloc.c
Date: Fri, 16 Jan 2026 01:43:05 +0530
Message-ID: <20260115201305.119383-1-manish1588@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B2DE21A001B
X-Stat-Signature: npryncw4a3f39rpop4y9cwspt13jms8b
X-Rspam-User: 
X-HE-Tag: 1768507993-914120
X-HE-Meta: U2FsdGVkX19wneVa4Y/NhNSWKgM48jlWSc2cL7wFsw5UmXKU7LWocjzkS0/r36/PmMytj1l3X4j/XFR9k8vSMWq/F9HVRymTZctvg2E8MzsMt5T1AFh+FSuqASSmAaKTxc1Bdpl2NUJr+NuiCdIoAtXJ3FsagAjRQ98Q6IsiMcbwZwkMjfdZ+C/gx3BkMx+R+2al5G/a8QR4OvPMAWL1gaziKONL2XQ1nYGOI2gMOSwtrnVIIQsrc9iVqjs6ZuotQz5yI66eqzX3SralSIl5P+C2qSYYC227PLkMWtsutSDW9Ls3vdt154hHxO7ZIu1EugCJO11yWUqtKuQYHn3H9U7BSh90tkHet7OhlDiuDiXyUq41zvGe3odCWT4FPPtHbhbzkh4cjELwF6rT/uPUPuIgz67zgZvGK0tgcSPrDxDOGrfWlCxqzfiScAB66KE4+uAvOn1IUdhlbQDmAxBjEP4n0re1Nh+KwkvM2WBAWZnsLu7uL2oRR+D+gPWmkip2DDsrmM44QEOP3wRFpZqawbHxokA4ap4hneJiI3CLL/wMGso0IFXaZhBW7SGEpBTrx+C3JW59tRsBzQBjS2oXfa4dtPrkk+gvwaNoPUGRwlkk43l+gk6/6oAbhmlEGPD2u9kYBru5hmIRjvk07insx2N/P1tGZay4eS9VrjxUUpbbBX2YCsw/uRiZC9/JSDzvBHACpgKbKseyz6KoOShVCRSobieMlHZzQTcSBcLbAuLfzciabCRkXyXDhGWhU0GayBjdcYFcwK+yjo7JUObeo4masT9wXzlHmNQ70s7Whrbjyh5D5cN3jGDzFXUzTwPefwxDele1Jda8GA56k8n/DYXYAhOUatM3rg53CifOW6s2NbaBeNKcBOG9+xYW8jVaqf3qGYzH//lLudXbt8ZhX6NQ29rcjfHa6n9nodwQvbvmsWW/VUrEveFSq055hc5boMQbzsIUFdYpB2tuy+R
 CTe0hWns
 zastFiRxvukhoeUnEAXXVXcsaJhcblf1b5aIu0Gj8siQO+5A3o3KJzxYn6JicS3Wg0eZXOl7iPJ/D3/tuFGl9y+6LVeAjCDcnUr/itMadJ+RgVlZ4t+/HV/Cv0siecBmNf+o70yWUB8VLxA/5g47LHhF4hrHloaGia5vMkjlUzaHRTP9I9kCiZwaAC4WpDLz43NNvmY4FDR3pk0Y3vAV3HZwSXDxY7Wcj90yKj4+l2VEFrsHrnvQTofvtfIroxLI8TaKt9jVjwVOmCmwdorD3ClG6YG0Y6jCDo9u9JR0hrJLMUyja+uxhF6ByLs5JeBW9emIIL2vmtsFJ1oJMOo4nww2yERQurToB9nLGwSKdgm6VzRFNrX/sI1fCYKx2wYb0/JYYf2UslRfXGZFrNXu1bfhLwkGuJkxTtEUOeZlY04GC0YjPTm+gUlj+ckxfa9DQU1CQrQK63c6IbyA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000042, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Signed-off-by: Manish Kumar <manish1588@gmail.com>
---
 mm/page_alloc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 5e132ead5ea0..5f52d8e71872 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -858,9 +858,9 @@ static inline void __del_page_from_free_list(struct page *page, struct zone *zon
 {
 	int nr_pages = 1 << order;
 
-        VM_WARN_ONCE(get_pageblock_migratetype(page) != migratetype,
-		     "page type is %d, passed migratetype is %d (nr=%d)\n",
-		     get_pageblock_migratetype(page), migratetype, nr_pages);
+	VM_WARN_ONCE(get_pageblock_migratetype(page) != migratetype,
+			"page type is %d, passed migratetype is %d (nr=%d)\n",
+			get_pageblock_migratetype(page), migratetype, nr_pages);
 
 	/* clear reported state and update reported page count */
 	if (page_reported(page))
-- 
2.43.0


