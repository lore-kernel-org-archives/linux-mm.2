Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CE50CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 09:58:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B55EC8E0097; Fri, 22 Aug 2025 05:58:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2DA88E009A; Fri, 22 Aug 2025 05:58:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A7898E0097; Fri, 22 Aug 2025 05:58:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 717A48E009A
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 05:58:45 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3089C83D3F
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:58:45 +0000 (UTC)
X-FDA: 83803944210.19.A9FD28F
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0BC6D140007
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:58:42 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu;
	spf=pass (imf09.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755856723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MFG8KH6sJFPKd6Y/257k0rKMxlU0LD4tABKQyvpqMnU=;
	b=6qBjPcpOLfITbudDZZbIdw8I/SSGc7ExRYRpTReNlirSwPWsyQVqamsEaA3ytJOJwD09vQ
	hoVmWEFIcTgwVZXIa0eEsZYQ5Oazw3IQi1+OD68Y8Vhfnh0OBMaJ6EQK+s4E4iTRlpiwVq
	ysNPJbcNKx1ETqDgfq1SesMz/iigkUQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu;
	spf=pass (imf09.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755856723; a=rsa-sha256;
	cv=none;
	b=K+kCKSt+kVseVU81wIyyQbWkmOc81G1LYSqZelJiYWNrRYRR1n2nZKEEQoFC0Tw8AZGI5D
	e8vZmvop2ds+uCzJbvDu3NC/3N959XKAVLl75PO305C7EouQ4jIQOP6APBUpAPq4fnD8c/
	td9LpWHK0TS2mabIQ1/UCRxDi6nIzJM=
Received: from localhost (mailhub4.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4c7bGt1fvqz9sSd;
	Fri, 22 Aug 2025 11:58:14 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nA9tiptLvbS4; Fri, 22 Aug 2025 11:58:14 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4c7bGt0fxTz9sSc;
	Fri, 22 Aug 2025 11:58:14 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id F2A058B781;
	Fri, 22 Aug 2025 11:58:13 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id xGJtbDV9gyfJ; Fri, 22 Aug 2025 11:58:13 +0200 (CEST)
Received: from PO20335.idsi0.si.c-s.fr (unknown [192.168.235.99])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 00A1D8B775;
	Fri, 22 Aug 2025 11:58:12 +0200 (CEST)
From: Christophe Leroy <christophe.leroy@csgroup.eu>
To: Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Darren Hart <dvhart@infradead.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	"Andre Almeida" <andrealmeid@igalia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Laight <david.laight.linux@gmail.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Daniel Borkmann <daniel@iogearbox.net>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org
Subject: [PATCH v2 07/10] powerpc/uaccess: Refactor user_{read/write/}_access_begin()
Date: Fri, 22 Aug 2025 11:58:03 +0200
Message-ID: <cd88a8e7b9af97c0cab84fc4b9dec74f10932568.1755854833.git.christophe.leroy@csgroup.eu>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1755854833.git.christophe.leroy@csgroup.eu>
References: <cover.1755854833.git.christophe.leroy@csgroup.eu>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1755856679; l=3531; i=christophe.leroy@csgroup.eu; s=20211009; h=from:subject:message-id; bh=f9F9/cRuytydLUtTkyZlSioNNHJr4smVC+NwESq3LiE=; b=iGg6YdGAsWyUK0iNyg6FWIwUKR9y2x0CwCJ+wXEjuvZEm5CU7Pic2aw23YM8P5L+Yc1baQWjs 9Okn+6PeCsDCvFYf0Q9gOtBhSQ0ERuHaxTeQbnXZTGDNJug9EN2Om79
X-Developer-Key: i=christophe.leroy@csgroup.eu; a=ed25519; pk=HIzTzUj91asvincQGOFx6+ZF5AoUuP9GdOtQChs7Mm0=
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0BC6D140007
X-Stat-Signature: s8ck6y995d1brm4ggn1iz8egq16oaegn
X-Rspam-User: 
X-HE-Tag: 1755856722-737887
X-HE-Meta: U2FsdGVkX18jjkqAKeUEnrMJf52gyC4bq+pWYqBF5apFNTJyMrl7uKHcb/MFRMTEIrHbGPbFiTq7/Wzs7GyuICIWr/esSpyltWeIKrmABotBvcoQ6T8zPp965kQLIrKQ1TE3kJpqVrXOq5kitkYUE2Kv7W9e+sZpxZ9RQ7ytS/5Cgf6G00VZKVSz/8RgiIqUzRq53dHVbkqcwzXajG7SREfNAoAEh1rmuN0EN0NrwjWrB6/54qlVfsGG1XAAZG4mgs7asYakwGGTG/YObJoN1dOwl7GWvbf+VQumkRkC2KCetH0Ju7cqYiM1sURhbBKnsX4MafR6Lc5lOceUFQ/YkhPiiKb0uAp4/K3rFlyLHsXNgmMJZnO1VHCVUhftSyI9L4FlpVjizsPBfgF0FpLqP4q4RJny0+HIwclkFWJXPsYEX0xAGrFMDkxgkh40CNvEDr/k3x7iX7+gEQm5MST4DicpZrM0fKeJWWOByOKcMHdv5GTfcWcKON4rpm6fQ2mUqmUKoQPN4NZAKLLOe2Iiti1qkuv80Y9jGISuzYrvVgyyqTG8gx93Kpxx0FCuDhnAiPNW0FUALrsOk6BYxS/bUapth2EiwC+tgwJKYLRQzPFKCemj5v8RZyPcwyyLCPz1kyCuI0LAnojNxc8jc7onTB503Ve6gi8ESR5KWqTpoCgL0vrBdcA7HRkPNBfpmvUVmzsUrvE19Y8G7Y0e7pZ2HBnNvq2E7B7tiZml3zz3YpVxSwqTe8s52IIqQBE4YMs0eTS0JeIQoeEQbjPlz1VCw5pv49Dt6Mmk8XsoQqrHYt5FY4jA5dLBhO9QF5yGJh3BGHASwXjmWZLMnhdlJmpuZ3Pd7pKRVky/awvgsz9RbPA2Q7k1q5u3Apnf5bGODf6WFNJG04pqxhdoV2jvDMQVdgl45EegZbUT4BZv2kb0IjN+wjOVgTlQA5qnvUc02sQn+//1ltDacFkGd/rO0Bp
 UMy2Pwcn
 oybU2TyxUE3vhgFrtWVp837RuMtidhh3BtchnRe8n24U2lQuLzeuLfOSKnNh1TybDS5n2wK727iOKm3T062TvaI59LIs1UHZ78FEhF06rqbQDKKR6/JWdgxy5gn3tAzXWZwSTgbqzez4jeQBt8iSFj6FdnvZUT5ubL4SOFEHcGFdix21YZ5mcxlyEcaZftsc9fkGrxx22MSAuGSNI9hJLkubn2vRKZ3Z+4hFOoI5TXuJOA5O2vaWwbxpF486paJwS/Ue1uLxJiq5cgHgqFCEmxTOJjqOYcAcbIVJB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

user_read_access_begin() and user_write_access_begin() and
user_access_begin() are now very similar. Create a common
__user_access_begin() that take direction as parameter.

In order to avoid a warning with the conditional call of
barrier_nospec() which is sometimes an empty macro, change it to a
do {} while (0).

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
---
v2: New
---
 arch/powerpc/include/asm/barrier.h |  2 +-
 arch/powerpc/include/asm/uaccess.h | 46 +++++++++---------------------
 2 files changed, 14 insertions(+), 34 deletions(-)

diff --git a/arch/powerpc/include/asm/barrier.h b/arch/powerpc/include/asm/barrier.h
index b95b666f0374..7acbf27cac6c 100644
--- a/arch/powerpc/include/asm/barrier.h
+++ b/arch/powerpc/include/asm/barrier.h
@@ -102,7 +102,7 @@ do {									\
 
 #else /* !CONFIG_PPC_BARRIER_NOSPEC */
 #define barrier_nospec_asm
-#define barrier_nospec()
+#define barrier_nospec()	do {} while (0)
 #endif /* CONFIG_PPC_BARRIER_NOSPEC */
 
 /*
diff --git a/arch/powerpc/include/asm/uaccess.h b/arch/powerpc/include/asm/uaccess.h
index 698996f34891..49254f7d9069 100644
--- a/arch/powerpc/include/asm/uaccess.h
+++ b/arch/powerpc/include/asm/uaccess.h
@@ -410,50 +410,30 @@ copy_mc_to_user(void __user *to, const void *from, unsigned long n)
 extern long __copy_from_user_flushcache(void *dst, const void __user *src,
 		unsigned size);
 
-static __must_check __always_inline bool user_access_begin(const void __user *ptr, size_t len)
+static __must_check __always_inline bool __user_access_begin(const void __user *ptr, size_t len,
+							     unsigned long dir)
 {
 	if (unlikely(!access_ok(ptr, len)))
 		return false;
 
 	might_fault();
 
-	barrier_nospec();
-	allow_read_write_user((void __user *)ptr, ptr, len);
+	if (dir & KUAP_READ)
+		barrier_nospec();
+	allow_user_access((void __user *)ptr, dir);
 	return true;
 }
-#define user_access_begin	user_access_begin
-#define user_access_end		prevent_current_access_user
-#define user_access_save	prevent_user_access_return
-#define user_access_restore	restore_user_access
 
-static __must_check __always_inline bool
-user_read_access_begin(const void __user *ptr, size_t len)
-{
-	if (unlikely(!access_ok(ptr, len)))
-		return false;
+#define user_access_begin(p, l)		__user_access_begin(p, l, KUAP_READ_WRITE)
+#define user_read_access_begin(p, l)	__user_access_begin(p, l, KUAP_READ)
+#define user_write_access_begin(p, l)	__user_access_begin(p, l, KUAP_WRITE)
 
-	might_fault();
-
-	barrier_nospec();
-	allow_read_from_user(ptr, len);
-	return true;
-}
-#define user_read_access_begin	user_read_access_begin
-#define user_read_access_end		prevent_current_read_from_user
+#define user_access_end()		prevent_user_access(KUAP_READ_WRITE)
+#define user_read_access_end()		prevent_user_access(KUAP_READ)
+#define user_write_access_end()		prevent_user_access(KUAP_WRITE)
 
-static __must_check __always_inline bool
-user_write_access_begin(const void __user *ptr, size_t len)
-{
-	if (unlikely(!access_ok(ptr, len)))
-		return false;
-
-	might_fault();
-
-	allow_write_to_user((void __user *)ptr, len);
-	return true;
-}
-#define user_write_access_begin	user_write_access_begin
-#define user_write_access_end		prevent_current_write_to_user
+#define user_access_save	prevent_user_access_return
+#define user_access_restore	restore_user_access
 
 #define unsafe_get_user(x, p, e) do {					\
 	__long_type(*(p)) __gu_val;				\
-- 
2.49.0


