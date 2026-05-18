Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D51ACD4F50
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 18:17:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 393A56B008C; Mon, 18 May 2026 14:17:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31C8D6B0092; Mon, 18 May 2026 14:17:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C2FE6B0093; Mon, 18 May 2026 14:17:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 04DA26B008C
	for <linux-mm@kvack.org>; Mon, 18 May 2026 14:17:49 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BF509A09A5
	for <linux-mm@kvack.org>; Mon, 18 May 2026 18:17:48 +0000 (UTC)
X-FDA: 84781349016.14.456957C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id BA493160006
	for <linux-mm@kvack.org>; Mon, 18 May 2026 18:17:46 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M58eeV4u;
	spf=pass (imf08.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779128266;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uNwNrAEXSmXCcBNvDjDEbYc4go2I1oEPQGTCZLZZ22k=;
	b=2UziKVFX5WjwCNanghRR8K9d3A+t1ak0dP6vwcAksiwecfHVjp6+Bd9Y6fAfgIaXKbz3iP
	1G5ze3lTDWg+pI+pi8GRnE4nD5MaINy89kAaIyKwz+27xbYxGUPyBIJ/GCLnQl9ov6AYa/
	KnzGZfGUtNQZanY9/7oWgUQrGXnoZ3I=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M58eeV4u;
	spf=pass (imf08.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779128266; a=rsa-sha256;
	cv=none;
	b=KHsrz3JZ8yviEFJbgN3HvD1bOk8raQvY0YiiGp+iMqWOfTV5pUfNIr5EZfMthc7DHTv1j2
	pPgyjkh6Ua9+a6bxEV7uiW3iYekbEwJ4OsxEHhG8IRdjzpZ01/0ivhFF+JLIA1phbKkZoH
	aGA6n30gTaWJ9/8o0QD7xBsKNoAdsos=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C944E44485;
	Mon, 18 May 2026 18:17:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A373EC2BCF5;
	Mon, 18 May 2026 18:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779128265;
	bh=BUdOCaQuOCSBBDHR2jUyq+U+9zPMuOuv59bLWu+eXK8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=M58eeV4uIMxcWwQE2urHUh/QNnc1jCQBqSjK9PPpmrrgybimA9xYcjou1TUZCjuvI
	 AvcAUrVa6eGU5NMe5rREDkifS95Rlxmdkt1niQq2t+QLUY6VQQ+8cJMIAF5FXxDt74
	 eINX0SB8yeSkm5KrzwlirNCZ6TAa4HV+Y2Ph+rU6HTr1P5ZdFR5fnhgAcRBzNHY/dx
	 boDlFqxn1DBobvQFL6JfB83LimuOi3PZyAwKCBc/S+FgtiQ1Bk9ed6l4UlqTTTfEHR
	 ChVB3Qk+S2zHVfZos0SXxXl3cQEzroxHU7LEXqU4eFfVM1Wtg3kmcyEuhimu9ialjT
	 G4KPykVIF8sSA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95DE4CD4F50;
	Mon, 18 May 2026 18:17:45 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Mon, 18 May 2026 11:17:34 -0700
Subject: [PATCH RFC 2/5] mm: selftests: Inline {read,write}_bytes functions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260518-port-hugetlb-selftests-v1-2-d64ba3a785fe@google.com>
References: <20260518-port-hugetlb-selftests-v1-0-d64ba3a785fe@google.com>
In-Reply-To: <20260518-port-hugetlb-selftests-v1-0-d64ba3a785fe@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
 muchun.song@linux.dev, osalvador@suse.de
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779128265; l=1888;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=3vqV15tnc/KP7l17CqT82I3LVdfcrBoQAIsUGRd62xc=;
 b=8wRWXv6/rOnk4l6CutfsJgow0n6eIr/AsAi5gOQiNeOSPDM5g7SuG9MmaRX7tv6dn3aqhQhb+
 PQUacAigGvODbw69xP477YxGOx0ttnT+euh7SJS2UaNIeMbKaErkZ1g
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: aeq417bik1o8yypb48obc8w4shzbrygt
X-Rspamd-Queue-Id: BA493160006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779128266-413702
X-HE-Meta: U2FsdGVkX18nYHwBtXsMpWi0D/ERbs6YKfXh51AnfH18WaiV0KmXFmStPKW6D7oefE3GWXkeWwAGPGHVOw/t7G35akCxXC1A1a4MZmXi0Yfqjx5ckGKOXA5XPWZevBiSaPYGOXZrpGvEUny377KwBCi3mPrpfbBtO5Kec3PAOmzlSguutvSTPx3TEjtT4W9xv8l0x5FbCWsNVUc9Asx2NXyo+007MRfgkXA0HrHIRV+4TR8Xs3Hak2RgOHW/RbQv/tBoJ5xQ4gfJae1O3wjJIwH3guIJBugiuB3xkmmjZ9GemOBpamiFaTRqYUHw2gR2cFcgQqYajVofgLljmXq5FC5Xh89FwRd5QQ9rgnzeGCsmuECJKqY5q1LUnlYtSOzbV9J8dZRilSV6gc7wkwSWxb1CTTbBFmScjJsFTk/0C3PgWuDAPF2HdJVGAg2iQQmtCfn6oJjhlr+bTRuA+zCWkL0/jeyrVfIkpwjjB/+uTguTHT3c5GTjh272QlWdvpiJwaa7ztSpOJXpqUY+dw8/aF4RZhdBB+GH44LF2YJVUmRvg5ljP6nz8dLqRJ6i4xTfHWvlUulYNKQI2T6+HAviU2tSlRm5jYWv5Szek5YZ5XPJDeJl5tV0dZzkrhhUiAK+f+z+OhDaLOkmr7vfLuquWGlPQOcnZPW9MpOzLUUr/HLjbF9uPY1frJu2yltMJRHjLQfZ00PnuHX8wX6L6oPkI5QR50Zi2RsQrygsRwL6OACD+89m8HOk/GKKELWASo/yGqONRug6stxeUoRBUY37TeWmidNawFpmLsA3unHIdIS889WNpvUfn4nFlJbsg+WApHNaX/3/MSaZ1EvFEmJS+s+pO35OGV+Dab6PM3IiNUYPwxp5oKjSeXUpZUUXQ7XmrQ+mDU70aiM8z58feCrbjjAaEKUcuc0BgcYb+TtB1K2BIGHJapVsnZw6w0x5jb0DXoX44MT1vL7hMcjwEZX
 cgOl7vFP
 Y1IgHri/2Ssn9xgEK6bfQf+Uh53QhlOXgeuscz1oZOL2bXaoouSjZ4fRFA68vTkg+seGMJosEft0PqC9TtG1ihgLAg0BlLCAHjjTyo0P+grihakbKVF+0uAzM+gDqGtrVWspBafcaFoaOvqhsRE524Z70PM9Iwb5ZNGVX8pERMg6NN+trHudW/dEsuOE0Xrf1QQFOacW06V/uTIl4MjS2EW7JaeK0DzvtvcILYpbS4vu6xfHFn5M/HCZD0uLeyYTxgPifjf1pVVNQUguYgcDixfEtPvtF/llhQYUZwvh1lZP9Jge0f4/Zbh8HFGlan/MVX4iGfZoguP6YBLN53bLZwAmhS7vETZ7ABIyJ6tkVg8N2JItct9gUuPGG0QiAha5qwaVldoZzNUVnuK04N80F4j5z7JtiyA1ikODYxf9ZwtwYoW3QgU/Cir91vHjQSDvec0XVEuoXmx7XJRIyHF8Z0AnDGg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

When the kselftest_harness is used in a later patch, making assertions like
ASSERT_EQ() relies on _metadata's existence at the macro site, hence using
helper functions makes it more complicated.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/mm/hugepage-mmap.c | 38 +++++++++++-------------------
 1 file changed, 14 insertions(+), 24 deletions(-)

diff --git a/tools/testing/selftests/mm/hugepage-mmap.c b/tools/testing/selftests/mm/hugepage-mmap.c
index 8c246070572f9..64f7d28a97fdf 100644
--- a/tools/testing/selftests/mm/hugepage-mmap.c
+++ b/tools/testing/selftests/mm/hugepage-mmap.c
@@ -20,31 +20,11 @@
 #define LENGTH (256UL*1024*1024)
 #define PROTECTION (PROT_READ | PROT_WRITE)
 
-static void write_bytes(char *addr)
-{
-	unsigned long i;
-
-	for (i = 0; i < LENGTH; i++)
-		*(addr + i) = (char)i;
-}
-
-static int read_bytes(char *addr)
-{
-	unsigned long i;
-
-	ksft_print_msg("First hex is %x\n", *((unsigned int *)addr));
-	for (i = 0; i < LENGTH; i++)
-		if (*(addr + i) != (char)i) {
-			ksft_print_msg("Error: Mismatch at %lu\n", i);
-			return 1;
-		}
-	return 0;
-}
-
 int main(void)
 {
 	void *addr;
-	int fd, ret;
+	int fd, ret = 0;
+	unsigned long i;
 
 	ksft_print_header();
 	ksft_set_plan(1);
@@ -61,8 +41,18 @@ int main(void)
 
 	ksft_print_msg("Returned address is %p\n", addr);
 	ksft_print_msg("First hex is %x\n", *((unsigned int *)addr));
-	write_bytes(addr);
-	ret = read_bytes(addr);
+
+	for (i = 0; i < LENGTH; i++)
+		*(char *)(addr + i) = (char)i;
+
+	ksft_print_msg("First hex is %x\n", *((unsigned int *)addr));
+	for (i = 0; i < LENGTH; i++) {
+		if (*(char *)(addr + i) != (char)i) {
+			ksft_print_msg("Error: Mismatch at %lu\n", i);
+			ret = 1;
+			break;
+		}
+	}
 
 	munmap(addr, LENGTH);
 	close(fd);

-- 
2.54.0.563.g4f69b47b94-goog



