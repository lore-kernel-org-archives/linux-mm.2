Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41D4BCA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 09:58:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29F898E008C; Fri, 22 Aug 2025 05:58:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 210708E009B; Fri, 22 Aug 2025 05:58:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAFA08E0098; Fri, 22 Aug 2025 05:58:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8C51B8E008C
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 05:58:32 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 53F6EC0677
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:58:32 +0000 (UTC)
X-FDA: 83803943664.19.D8007D9
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3397A40005
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:58:29 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755856710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cXncjpxAdQoZ3uSg2zQ5MWQivHi6OyWyLinDnwqoFf8=;
	b=d8rven/okcvfRDDxUHWKROSXsF4YZF48/ATvUmxr05bFWobSU6l+B9W1Tk/rQO7WgEIeTG
	mvmplyqowOI68Qe7FBXDDHmBStov6jUw1f/IlEOcLskinGWJG9f0r0dLx6jUwP0X7oGbDP
	H9sZAkQUcxccft/8MlhYyjS3YPvUXQY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755856710; a=rsa-sha256;
	cv=none;
	b=2tUvLwlTNcc5PktVcEIuTYIeXSL7b15XLYmqqB0108QRoEGsYb/LRf9pitGYU2J9XdXNMi
	cILP57u86674Dif1+72he8hHk0PLHCtsSi02DUGOYzHOdrO8QpzE14/xXDiHzBHmMa8tEc
	GWv/NadjZqnIbJwKTnBWbWh64hDgxxc=
Received: from localhost (mailhub4.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4c7bGs1qmSz9sSb;
	Fri, 22 Aug 2025 11:58:13 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id z8vvb6RdR6kp; Fri, 22 Aug 2025 11:58:13 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4c7bGs0pQ7z9sSZ;
	Fri, 22 Aug 2025 11:58:13 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 0240C8B780;
	Fri, 22 Aug 2025 11:58:13 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id OVYa2l6pC0BE; Fri, 22 Aug 2025 11:58:12 +0200 (CEST)
Received: from PO20335.idsi0.si.c-s.fr (unknown [192.168.235.99])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id CB6F58B781;
	Fri, 22 Aug 2025 11:58:11 +0200 (CEST)
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
Subject: [PATCH v2 06/10] powerpc/uaccess: Remove {allow/prevent}_{read/write/read_write}_{from/to/}_user()
Date: Fri, 22 Aug 2025 11:58:02 +0200
Message-ID: <ffa271c5c127f277ac8213301da2f16a34bca885.1755854833.git.christophe.leroy@csgroup.eu>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1755854833.git.christophe.leroy@csgroup.eu>
References: <cover.1755854833.git.christophe.leroy@csgroup.eu>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1755856679; l=5380; i=christophe.leroy@csgroup.eu; s=20211009; h=from:subject:message-id; bh=fP9WObzJ/2N9/4EDoUl1xf8kjta+DR6uuNLODyDCEJs=; b=T3sZTJQbWWxSvxnrTMu3Ur0E3ipBuACkn/ijWTup5nP/rhipke3Mwwnj1EIXejhdNUP8CCdp9 d5eMN5XWMP8AtQqVPkELMTCR5a5WQG2m9Ln36oSHSKu+sfZWqRcNB0C
X-Developer-Key: i=christophe.leroy@csgroup.eu; a=ed25519; pk=HIzTzUj91asvincQGOFx6+ZF5AoUuP9GdOtQChs7Mm0=
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3397A40005
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: uqt85byz8yaqp58fto76fgk6hx8ss7t5
X-HE-Tag: 1755856709-350880
X-HE-Meta: U2FsdGVkX1/sP2YRx+r4JzjIR5RdqAmCp1ULieGW2K90E5mzIOiZ6mWfPobEnGF81awUOaviNgKJHGiAl8Z9mZKIQhtE8dXPA4XRZpMrMTTlg7NLdqTdjqce/0nuFepas+gOYlzAN8QC4+gosy3wrm6sdO7N/aTgsK7MUEmaQIaAJIkFUXJkAwkKbatBjk5tzzy8jopzSXaQQU6Vk3iqoxHTbmUiZaOCOWXMcCpmMqmAblSN8kRkK/muMe3TOzcctWEZMQUxEkygw+ZrqQskt2J1/dHZ1LNm1jOMbjwdB3FVf4Aa6eYGvOkEmJp9o+xRFbnpPat0VZocQVlk6uy6sWtUAERJMSzwEyuC9gWMXAyufVTLMP43kDq0zrVcJLdQD2lFRVtbm7TmZu/P0pb6GPjJE+tsrRE0NAMaVsjBX3iR+dnKBa9hM/mKVVJ66yo09oJ4GFVNysy4Ge5SJazJI6gXGjyy/n26lNyl1nNBghGAmn1uIfBszGkiVvb+Ftwhc4NKykQXdmOeJcVsq8TJ0S2dzAPZ4ty9p/I7lbZLEHMjYLjIFjo6OdSRJ9lotKX9CcJoE8xOdMik+7zGgDppyUfyCIaEjdUU5Nc9Qg17kpb8S0H1FSFykvhuu2zOYMejD3hkHQx0K8iVoTtsYuPLFfCFmtx6zyKmlZC80sfPDEBZJqlcTezPqr43znx7GCPAvHtGuTONMCPcSLCQmfZVGAjNEzU87zXcw5K0dbYuM0ag+CZILF0clVUT7Xb/OjUea8IAatQJ3qKqeM95Vb4pHqBZfutVjPo4HHR4P/NyBeBqx/0yKC7FNtBTY+GhY1E677OAZDaqMzcwAoS2eCnMEkpt9IDHPGIo5UnmHlXPLvBSB5PeNz1OWA7qmDyziyWgD9WIG+ElGWiorARbhA0gyujzG9p8uAYESn3/fWbCVD1DMQifUKfSSYH4qsvn1gzw2cavhQn3pJYhmgKjUHm
 yL5mYR7y
 lNrFDE/36cYesaEyaJUlwOBdGhJop/9MLt9fcommDWdYvaWOKh270KyfGK2yX6V0aEXM/RqilcQtJMhLCUdrIVhAa2wFWRpupLafsaVrdZCpm5gX1IaVUFX+R7ZeQGsf/YLBk57v2hG9DpmGniaWfbilS5MsqSd7gQEIY9Yw9JUpwqod/+kM1ml07/0UKW9AaAk8mziAFRoRtQuveG3lvpm0QjaPUbLh5Xu5go/LzM2rUy5N8KSMpfc5NADyISWev3L3O
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The six following functions have become simple single-line fonctions
that do not have much added value anymore:
- allow_read_from_user()
- allow_write_to_user()
- allow_read_write_user()
- prevent_read_from_user()
- prevent_write_to_user()
- prevent_read_write_user()

Directly call allow_user_access() and prevent_user_access(), it doesn't
reduce the readability and it removes unnecessary middle functions.

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
---
v2: New
---
 arch/powerpc/include/asm/kup.h     | 47 ------------------------------
 arch/powerpc/include/asm/uaccess.h | 30 +++++++++----------
 2 files changed, 15 insertions(+), 62 deletions(-)

diff --git a/arch/powerpc/include/asm/kup.h b/arch/powerpc/include/asm/kup.h
index da5f5b47cca0..892ad06bdd8c 100644
--- a/arch/powerpc/include/asm/kup.h
+++ b/arch/powerpc/include/asm/kup.h
@@ -131,53 +131,6 @@ static __always_inline void kuap_assert_locked(void)
 		kuap_get_and_assert_locked();
 }
 
-static __always_inline void allow_read_from_user(const void __user *from, unsigned long size)
-{
-	allow_user_access(NULL, KUAP_READ);
-}
-
-static __always_inline void allow_write_to_user(void __user *to, unsigned long size)
-{
-	allow_user_access(to, KUAP_WRITE);
-}
-
-static __always_inline void allow_read_write_user(void __user *to, const void __user *from,
-						  unsigned long size)
-{
-	allow_user_access(to, KUAP_READ_WRITE);
-}
-
-static __always_inline void prevent_read_from_user(const void __user *from, unsigned long size)
-{
-	prevent_user_access(KUAP_READ);
-}
-
-static __always_inline void prevent_write_to_user(void __user *to, unsigned long size)
-{
-	prevent_user_access(KUAP_WRITE);
-}
-
-static __always_inline void prevent_read_write_user(void __user *to, const void __user *from,
-						    unsigned long size)
-{
-	prevent_user_access(KUAP_READ_WRITE);
-}
-
-static __always_inline void prevent_current_access_user(void)
-{
-	prevent_user_access(KUAP_READ_WRITE);
-}
-
-static __always_inline void prevent_current_read_from_user(void)
-{
-	prevent_user_access(KUAP_READ);
-}
-
-static __always_inline void prevent_current_write_to_user(void)
-{
-	prevent_user_access(KUAP_WRITE);
-}
-
 #endif /* !__ASSEMBLY__ */
 
 #endif /* _ASM_POWERPC_KUAP_H_ */
diff --git a/arch/powerpc/include/asm/uaccess.h b/arch/powerpc/include/asm/uaccess.h
index 3987a5c33558..698996f34891 100644
--- a/arch/powerpc/include/asm/uaccess.h
+++ b/arch/powerpc/include/asm/uaccess.h
@@ -45,14 +45,14 @@
 	do {							\
 		__label__ __pu_failed;				\
 								\
-		allow_write_to_user(__pu_addr, __pu_size);	\
+		allow_user_access(__pu_addr, KUAP_WRITE);	\
 		__put_user_size_goto(__pu_val, __pu_addr, __pu_size, __pu_failed);	\
-		prevent_write_to_user(__pu_addr, __pu_size);	\
+		prevent_user_access(KUAP_WRITE);		\
 		__pu_err = 0;					\
 		break;						\
 								\
 __pu_failed:							\
-		prevent_write_to_user(__pu_addr, __pu_size);	\
+		prevent_user_access(KUAP_WRITE);		\
 		__pu_err = -EFAULT;				\
 	} while (0);						\
 								\
@@ -302,9 +302,9 @@ do {								\
 								\
 	might_fault();					\
 	barrier_nospec();					\
-	allow_read_from_user(__gu_addr, __gu_size);		\
+	allow_user_access(NULL, KUAP_READ);		\
 	__get_user_size_allowed(__gu_val, __gu_addr, __gu_size, __gu_err);	\
-	prevent_read_from_user(__gu_addr, __gu_size);		\
+	prevent_user_access(KUAP_READ);				\
 	(x) = (__typeof__(*(ptr)))__gu_val;			\
 								\
 	__gu_err;						\
@@ -331,9 +331,9 @@ raw_copy_in_user(void __user *to, const void __user *from, unsigned long n)
 	unsigned long ret;
 
 	barrier_nospec();
-	allow_read_write_user(to, from, n);
+	allow_user_access(to, KUAP_READ_WRITE);
 	ret = __copy_tofrom_user(to, from, n);
-	prevent_read_write_user(to, from, n);
+	prevent_user_access(KUAP_READ_WRITE);
 	return ret;
 }
 #endif /* __powerpc64__ */
@@ -343,9 +343,9 @@ static inline unsigned long raw_copy_from_user(void *to,
 {
 	unsigned long ret;
 
-	allow_read_from_user(from, n);
+	allow_user_access(NULL, KUAP_READ);
 	ret = __copy_tofrom_user((__force void __user *)to, from, n);
-	prevent_read_from_user(from, n);
+	prevent_user_access(KUAP_READ);
 	return ret;
 }
 
@@ -354,9 +354,9 @@ raw_copy_to_user(void __user *to, const void *from, unsigned long n)
 {
 	unsigned long ret;
 
-	allow_write_to_user(to, n);
+	allow_user_access(to, KUAP_WRITE);
 	ret = __copy_tofrom_user(to, (__force const void __user *)from, n);
-	prevent_write_to_user(to, n);
+	prevent_user_access(KUAP_WRITE);
 	return ret;
 }
 
@@ -367,9 +367,9 @@ static inline unsigned long __clear_user(void __user *addr, unsigned long size)
 	unsigned long ret;
 
 	might_fault();
-	allow_write_to_user(addr, size);
+	allow_user_access(addr, KUAP_WRITE);
 	ret = __arch_clear_user(addr, size);
-	prevent_write_to_user(addr, size);
+	prevent_user_access(KUAP_WRITE);
 	return ret;
 }
 
@@ -397,9 +397,9 @@ copy_mc_to_user(void __user *to, const void *from, unsigned long n)
 {
 	if (check_copy_size(from, n, true)) {
 		if (access_ok(to, n)) {
-			allow_write_to_user(to, n);
+			allow_user_access(to, KUAP_WRITE);
 			n = copy_mc_generic((void __force *)to, from, n);
-			prevent_write_to_user(to, n);
+			prevent_user_access(KUAP_WRITE);
 		}
 	}
 
-- 
2.49.0


