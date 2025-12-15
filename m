Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6035ED5B16E
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 00:49:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68EE76B0006; Sun, 14 Dec 2025 19:49:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63FF76B0007; Sun, 14 Dec 2025 19:49:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 554F86B0008; Sun, 14 Dec 2025 19:49:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 458FD6B0006
	for <linux-mm@kvack.org>; Sun, 14 Dec 2025 19:49:12 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B1B15140D11
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 00:49:11 +0000 (UTC)
X-FDA: 84219871302.13.395EB2E
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf17.hostedemail.com (Postfix) with ESMTP id 07D8440004
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 00:49:09 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OW6rAyF6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765759750; a=rsa-sha256;
	cv=none;
	b=7hspqrexFxQAIKfkFaXmr9vWHSQe/3rfr8JqKQ8mS+EElIhAqqmrgneq5IICZoO9n7VQdg
	O19Tn4RAlKvkb8JVQU7sP6iMhaWYnGJlPfHkXvNqBzVwBBM+kklLM4UjjgGE48jPFliJDO
	Kjeygh3W1bpLSJOblEzgyn37VUwjIkg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OW6rAyF6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765759750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=hJ2lg3lS+JwkZjRv6xXwi+41bPyQQQwdE6As6qZ1lO4=;
	b=YeM63D47xJPckBV1CRN1cHjuFIDanP8iWsbiLupIF1p5dvVSDQjgTOvGTV/Gq/qQduw16r
	hAtt1/wlSfMt+pGGyU6PpTe5DFvZzRLMgC+WgVqqOJY75K8vWMWY9fZw3TY5HCfROj8vD3
	ovvYYevNzB6m5zVg44NPD/0vbKhLj1o=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6419aaced59so4527210a12.0
        for <linux-mm@kvack.org>; Sun, 14 Dec 2025 16:49:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765759748; x=1766364548; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hJ2lg3lS+JwkZjRv6xXwi+41bPyQQQwdE6As6qZ1lO4=;
        b=OW6rAyF6CzOjc8FgxafeYSCXDY1qsLAtm6CNe84Fdw+o0wcOzt1AEZrx7V/Eq1gPHo
         sSbgVfJ3iJyBzEMGa1hyVjxcludMfDYEmkQ/3Hd68vj9PfdJtB+GRPVV+3GaMFSR05MB
         2xJV6YBgjYrk0rpzdeMtjjrRGHax5VdTat6USJF6FxVtftM+iZwRdvika8fi3NwJuulv
         oVqlh/x7WtYEwIrHMqAgl1VqRnqPtvfrnCJthc+WHz1omzQUAt2C3wItKtHsyIbdVUWz
         P+lccuxSWl/w4NU3eM5a+rCL+FKxglL2OoxDykq9bLNuQuZYTf+Z6WXSuMml7dVkEqKT
         Z/Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765759748; x=1766364548;
        h=message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hJ2lg3lS+JwkZjRv6xXwi+41bPyQQQwdE6As6qZ1lO4=;
        b=DcN4Tu2LvY6tiWobE+SIU09n6lbqZ5+5txFkYdz2aZN6h5NRG2Ga9IPvZuUY2t7VOr
         COgkNQ+LQxikiTYLCYLpol175DOs0erYpUjrXYM+rFMvFJneanrBF1Z5PXWJtKSzuM0w
         bvGs1O6jESJQGul2BXEOKz9cRguDnD736IHYsuLocIa+UWGopIWEeBjBZffNVGjKP3fF
         gqjcFmToCs8MDMPPfL44nsqPpuVFjInFV9M5BPPhj+A1YGV2ttI0ooHhEHTVoAmA3bl1
         eH8WS9J3iwAmAruIWbqJqDv4XBdUt49kzGnzdV9O5PIlvd9dmuxiPb8O02nDU7d0jJ8l
         5riQ==
X-Gm-Message-State: AOJu0YzS2zRgiSH3IU1ZimhiAtnYuBZc0tl+MwNR+BeBimVOxsmTCp6V
	VDDR2V5kL4ldMjne+uH44llq9ayM4Yo7MECVJaUaTogg37lqW2ILkBkX
X-Gm-Gg: AY/fxX6DUN5oG2uUxszj2TZ2TlrWp9O8UWsEOpuPFxqV3kwXRP4kcBybS/QOclEad0b
	YiGb7FGcsci8K/pjUlwdDIqBfOLqTQbM0DygpQBd7OJBUZg6pl2tKfAv6D8NRKR4R99E0gNipYo
	/M+p1t3J0wvGsyX1qaXGvP7pso2xra7zLqrWJ1xgx6pT2yFsyy6JE7gOwsF3mLI1Ex3j+Ut4v/V
	rAfdTfGNZpjMRqD8C5xXRgKEvnNJ+usKUubbAwlRvq1b+nEwu7CPiWdhmgeSQdE2RuAg7LzHbXz
	ulGl/R0LatBAbRoUFQZNJ+vnEEsFs/Olvb6kGn1MMll6tdbeOhRYCLx8WosCJzz+OLm2JZKqKrJ
	PgRV0rAfOj7bSsIrgqhoq4kC90bk6BV+W0XzPfkV31TK/iXvLpdCQI6eatSNFtHEbegj56mUbtA
	zL3XdWeCB/fw==
X-Google-Smtp-Source: AGHT+IH8D0xsh2ip9JpKzMLa7+7/po2CRhAaTU42uOPwDM7vpX6PItQ8Vh7fljqXnTWm8mMRZKt9Ow==
X-Received: by 2002:a05:6402:460b:10b0:649:a63f:bea9 with SMTP id 4fb4d7f45d1cf-649a63fc03dmr6230973a12.16.1765759748300;
        Sun, 14 Dec 2025 16:49:08 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6498204fbb3sm12026540a12.8.2025.12.14.16.49.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 14 Dec 2025 16:49:07 -0800 (PST)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [Patch v2] mm/huge_memory: use end_folio to terminate anonymous folio remapping
Date: Mon, 15 Dec 2025 00:48:36 +0000
Message-Id: <20251215004836.694-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Rspam-User: 
X-Rspamd-Queue-Id: 07D8440004
X-Rspamd-Server: rspam10
X-Stat-Signature: bw1sst1rq6ehp8y3km943556wx3fr3wk
X-HE-Tag: 1765759749-351818
X-HE-Meta: U2FsdGVkX19zWMVOmOAoQtnrchcNu0wY16Uucj+oAXvPjvgXwp8HNBqvPuIqyixAtRHK7VVe+xvXbcmZcXfS1MFRhlbWVs4VM8Ipq+oTxGdbQewdvD0UENTONuGdoYJTDyfrYScnaBckOVG0m2+3GfRmEdoePkVJ/ndyzBgW2yViSJ+SgQUBFYA78JsPYuXs80bXaESZFrhWet7Y64/b0FnB79EMY2ktdnjxd6EyDPt6HHNmxy0s+0/cWCs/zsVlNAhb/FEFhkRPdsZ3jY0BFyikPRUO8r2L71JEcWqqJx0R3+n9p1V+sj+Of7NldmuJ5KHwWPlpKIu0R9JKme1icpVLDyi4sD1NSP0t89Nd7m5PTumywZzIDghT2uwSwtfooRccN3WjOHSrQnpVBpK12yULGLeg32OBT3+b0Ovbf7EuqHQbtnRW9HQYKUlfryD8dx1K/gct2Zs5RmgukOLPzhbipWqrmGSbpHaMCJRobH9CvW2Ls0zLvHkxmusojq/esV3LnKwiPLBAGkMXcbi8E/IgXdcV9/M/YOzpfwRbm5kcPq7Lmbdof2397m4/yTT1S83g9g0b5A6pSv+X09wBYhIiOXX0xZzMZdM/wXKa5mRDMzNuK/+P9quvDiYnZkec0wHmIpkIzCZnLS/17C0jk9kHK8OqGMiyly2C9hTJ3g6sjlD9cf/BqefXA1Ku79SL60oRF3k/Jq2WVEHLMFE6nkM6EnIKj/fM6Hn0YzWFwKoHbRihvz//kB5WdQHTl/OdrFD9ev7CMqxGntsdlFrpQDYFJPJDQ/o1F7kUaURKjim4I6Qd68rNpq5/nP9EeQFypXlCmxBVNuALuw1WBnQjAup5/y/uO6Ny1XCUj8sSzGlUzEUVyJ1YwNlnZzfs8r9EvFljXN5ddUsE2Ej8b0GgroroiLceUWD/RjFDgEOYHtFB0M5H9g2J6MWaQsyg4xUSimYWov/8LUQXLNqIFDq
 SJ+9HX0E
 JNVbZhsTwSf4QZgrNG/NL7g9LhE68jQO4AtMcayZIoO0yOcwRsv2XAaRZtNMxrfohIYvtMMt45l+qauv0BGJf2533enLVWXiu/62L1IowTZIN/4CG58Wx1btaXIzDnkqk4MQ7LjqiX525oUlIswA5xySEy2DRusftZnXnuC+rTT70/19hajqXL5uFxL6lmqbdVXv137uM1c9x1azKljtH7beuVgwnXer1DncL/VTalBDkxxuZxmxALYt3Hi4lBJSd89nsl6CXE3EDs2pH4/jgm9PxJ8+zEjFuIzvAs+fESTOGzR1crpEsXIyn1w1E83CbBKY6aSyhoPvePDilfqHo12GqosnBB6tcZnot65j0Hpk6mLC9gJzzhbb7nH46OBkKQJ9o4QlJB6Hm01uz77XKacx50FZ1oCzJeDPvqmvYh/6pt5MZPQnejVyA7WS7mhgv5kCtAHaQXMBvmaGPkRy7vy3OVEsYiJ2GXv83hGpeWSsy4rugkHC+laARCiUH87jjLlLTYw01oAl4Moqf87mrylZ9TO6Csw9lriOH1PG7/VVWvl1Qa5inD9D+u9IcxirVUsssonAbdAw+gHfbJRLs8E0vlg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After splitting a large folio, it is necessary to remap the resulting
anonymous folios.

The current implementation determines the end of the remapping process
by counting the number of pages that have been processed.

Since the final folio in the sequence, end_folio, is already known and
tracked, this commit refactors the remapping loop to leverage end_folio
as the termination marker.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>

---
v2: move folio assignment in loop
---
 mm/huge_memory.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 40cf59301c21..fe812d9c7807 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3423,20 +3423,15 @@ bool unmap_huge_pmd_locked(struct vm_area_struct *vma, unsigned long addr,
 	return __discard_anon_folio_pmd_locked(vma, addr, pmdp, folio);
 }
 
-static void remap_page(struct folio *folio, unsigned long nr, int flags)
+static void remap_page(struct folio *folio, struct folio *end_folio, int flags)
 {
-	int i = 0;
-
 	/* If unmap_folio() uses try_to_migrate() on file, remove this check */
 	if (!folio_test_anon(folio))
 		return;
-	for (;;) {
+	do {
 		remove_migration_ptes(folio, folio, RMP_LOCKED | flags);
-		i += folio_nr_pages(folio);
-		if (i >= nr)
-			break;
 		folio = folio_next(folio);
-	}
+	} while (folio != end_folio);
 }
 
 static void lru_add_split_folio(struct folio *folio, struct folio *new_folio,
@@ -4066,7 +4061,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	if (!ret && is_anon && !folio_is_device_private(folio))
 		remap_flags = RMP_USE_SHARED_ZEROPAGE;
 
-	remap_page(folio, 1 << old_order, remap_flags);
+	remap_page(folio, end_folio, remap_flags);
 
 	/*
 	 * Unlock all after-split folios except the one containing
-- 
2.34.1


