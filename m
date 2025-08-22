Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68DC1CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 09:58:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CF598E0096; Fri, 22 Aug 2025 05:58:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97FAD8E008C; Fri, 22 Aug 2025 05:58:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86F308E0096; Fri, 22 Aug 2025 05:58:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6E4DC8E008C
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 05:58:28 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3F34483D9B
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:58:28 +0000 (UTC)
X-FDA: 83803943496.03.BF77DB6
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	by imf01.hostedemail.com (Postfix) with ESMTP id 354BE40008
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:58:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755856706; a=rsa-sha256;
	cv=none;
	b=V+OxGW1Y+XkyyapDoXIqlqOSzlAwnlc8OQ53cwV/ow2ItICjxBxsE+/0/I/Pzk00fLqQdc
	xFMuD2IepmGZgcQXEdM6CFpojxLqm6EgivXoj2o2+J0mYLG8xdL6TB4UjP20SfoPF/WDxb
	Y+5Zv0+ofg5pJGuDkvBFM3aEyELLC8Q=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755856706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o8buzcW/UN4/h4LCvWa/BS8NAykGhPfW596PyvWifB0=;
	b=1obqZdZ22uXw8vW9Ibt3FYbY/iAmkywVb6AbRGo0kqgWm5Md54ydzBcPyCjpafhIGc0OMd
	h/a29UPS8R0I3FbB9L9vP4aN8hwmOYiCrnWyOIs/mZc1xW6d8n3PP0JrQoB8/+QfJfAcvv
	7GKvQbMZ8gTfWgjRewNXyxn0EqS58OA=
Received: from localhost (mailhub4.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4c7bGp5G2dz9sSW;
	Fri, 22 Aug 2025 11:58:10 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id L-iQubse_0cd; Fri, 22 Aug 2025 11:58:10 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4c7bGp4Kv4z9sSV;
	Fri, 22 Aug 2025 11:58:10 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 799BB8B781;
	Fri, 22 Aug 2025 11:58:10 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id Jh8il3hsJZQH; Fri, 22 Aug 2025 11:58:10 +0200 (CEST)
Received: from PO20335.idsi0.si.c-s.fr (unknown [192.168.235.99])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 7612B8B775;
	Fri, 22 Aug 2025 11:58:09 +0200 (CEST)
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
Subject: [PATCH v2 04/10] powerpc/uaccess: Move barrier_nospec() out of allow_read_{from/write}_user()
Date: Fri, 22 Aug 2025 11:58:00 +0200
Message-ID: <90ce0c90c53d3132023d753650b1741fab60dcd3.1755854833.git.christophe.leroy@csgroup.eu>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1755854833.git.christophe.leroy@csgroup.eu>
References: <cover.1755854833.git.christophe.leroy@csgroup.eu>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1755856679; l=3128; i=christophe.leroy@csgroup.eu; s=20211009; h=from:subject:message-id; bh=W6hpcedkcWK/fNdxM9/tYip/yiX0Wu6MZIyees7Pogw=; b=DUD1UUmtiwXNWatGhsXc9CjjVSp+31iz3JZAC3Kq7lY2UnNgEKtP/hJS7JrJ7X+vsKhFuWqba zo1szpJqvm5BrN9GBW2DIAx7C5wqNiWIty4eJINj4EQofJ+cdDrJaFQ
X-Developer-Key: i=christophe.leroy@csgroup.eu; a=ed25519; pk=HIzTzUj91asvincQGOFx6+ZF5AoUuP9GdOtQChs7Mm0=
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 354BE40008
X-Stat-Signature: 4gnj491zwefdh4gysr31xid57iczy98e
X-Rspam-User: 
X-HE-Tag: 1755856705-90648
X-HE-Meta: U2FsdGVkX1/mCPBHQjRn9zffHujMG4Dqx9GYAHZyxaOrkG3SvTln4+Mp+bOqoyqw8roWF3vyOitxEYa7xmswEi3cQU1mpbvdk3EYzICnlDrCElqQcFRrD6HTlNoFkBycyn9FLC5NL3H1GbN0LGnAaw+wtJiuL+jU2Uzl8QJAr2V//73lW13BHlQuNUPSOlCwUI3QC/BXiwvrpDo1PPj6azpzWlLdEv1A4bY+Z4vJIc7MLkZ5n6R7VUcCuH1FEmi/S2sTqyREVRkS8xNGwAiCTTI+zQeH+kw1V6dZDtL58zDlFpotOfQynX50EFYbeRCLf0bDzXV/EJ6werAhbbIxAfG7xdQfIGjC1Ov9RguERuzHmyXvTxXPoOtlx+YQC9q5Hdfmdu1h6jbZwxjbXT0vNDzgZyWD7Kq3OkNPO4JkVBCDubhxKSX65KcTWcGWovgO9teuNrXErKwMZ3gifGP60PgepzT5TIi/6lIMCuIzvlbG8XhxT72Z6pZ3cPO6PUtM7l5JWRtXMNUWgk8H3TcAtmcWaMj1C9elBMwYovDsaEC8mKBpNkeEcl6hxF2xgeyZTP1dtq71NGt4bBlHfxm7Ibbt766mSI0juWQa59L98jtRz4PSlB9lCN0pdmMLA1t4CVLYuTQTMrZ6nlOd2CwcwkpeTW2zMpFJ5lSDf+b/TQ65+XFt6kiO9iZO8aoG0JXdd2BIKgNHLQW+xCU1UCWV0jIERljWPz/LemBw8b5mJR4pQ2G6hQ1KP1NNOwc/ogM3xk6eXGNhO1l9eHnCIqE9hM6AwyBA1yBzKjTTJa5lb6D5M9jH+VnHimQQmEZ2yZzCITJqm6O2ngtc8vg3qgx1fxy0AVexsetjMNjb3CDuxYH5g7DS3URRq/iiSdaFwg3pDELoltIfIyHhrtlIIqrc+ueNU/tJlaABmpO8G7omStsnT2/RgJKCEHluPfWQJ/iGhFyS6BJc9buIocV6kkc
 AhRluvre
 UwcNhMt1wGuR+7oc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 74e19ef0ff80 ("uaccess: Add speculation barrier to
copy_from_user()") added a redundant barrier_nospec() in
copy_from_user(), because powerpc is already calling
barrier_nospec() in allow_read_from_user() and
allow_read_write_user(). But on other architectures that
call to barrier_nospec() was missing. So change powerpc
instead of reverting the above commit and having to fix
other architectures one by one. This is now possible
because barrier_nospec() has also been added in
copy_from_user_iter().

Move barrier_nospec() out of allow_read_from_user() and
allow_read_write_user(). This will also allow reuse of those
functions when implementing masked user access which doesn't
require barrier_nospec().

Don't add it back in raw_copy_from_user() as it is already called
by copy_from_user() and copy_from_user_iter().

Fixes: 74e19ef0ff80 ("uaccess: Add speculation barrier to copy_from_user()")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
---
 arch/powerpc/include/asm/kup.h     | 2 --
 arch/powerpc/include/asm/uaccess.h | 4 ++++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/kup.h b/arch/powerpc/include/asm/kup.h
index 2bb03d941e3e..6737416dde9f 100644
--- a/arch/powerpc/include/asm/kup.h
+++ b/arch/powerpc/include/asm/kup.h
@@ -134,7 +134,6 @@ static __always_inline void kuap_assert_locked(void)
 
 static __always_inline void allow_read_from_user(const void __user *from, unsigned long size)
 {
-	barrier_nospec();
 	allow_user_access(NULL, from, size, KUAP_READ);
 }
 
@@ -146,7 +145,6 @@ static __always_inline void allow_write_to_user(void __user *to, unsigned long s
 static __always_inline void allow_read_write_user(void __user *to, const void __user *from,
 						  unsigned long size)
 {
-	barrier_nospec();
 	allow_user_access(to, from, size, KUAP_READ_WRITE);
 }
 
diff --git a/arch/powerpc/include/asm/uaccess.h b/arch/powerpc/include/asm/uaccess.h
index 4f5a46a77fa2..3987a5c33558 100644
--- a/arch/powerpc/include/asm/uaccess.h
+++ b/arch/powerpc/include/asm/uaccess.h
@@ -301,6 +301,7 @@ do {								\
 	__typeof__(sizeof(*(ptr))) __gu_size = sizeof(*(ptr));	\
 								\
 	might_fault();					\
+	barrier_nospec();					\
 	allow_read_from_user(__gu_addr, __gu_size);		\
 	__get_user_size_allowed(__gu_val, __gu_addr, __gu_size, __gu_err);	\
 	prevent_read_from_user(__gu_addr, __gu_size);		\
@@ -329,6 +330,7 @@ raw_copy_in_user(void __user *to, const void __user *from, unsigned long n)
 {
 	unsigned long ret;
 
+	barrier_nospec();
 	allow_read_write_user(to, from, n);
 	ret = __copy_tofrom_user(to, from, n);
 	prevent_read_write_user(to, from, n);
@@ -415,6 +417,7 @@ static __must_check __always_inline bool user_access_begin(const void __user *pt
 
 	might_fault();
 
+	barrier_nospec();
 	allow_read_write_user((void __user *)ptr, ptr, len);
 	return true;
 }
@@ -431,6 +434,7 @@ user_read_access_begin(const void __user *ptr, size_t len)
 
 	might_fault();
 
+	barrier_nospec();
 	allow_read_from_user(ptr, len);
 	return true;
 }
-- 
2.49.0


