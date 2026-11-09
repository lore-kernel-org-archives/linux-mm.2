Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C3BD6082BEA
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 16:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=efhrXBeT
Received: by kanga.kvack.org (Postfix)
	id CA9A96B05B3; Mon,  9 Nov 2026 11:00:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C33666B05B4; Mon,  9 Nov 2026 11:00:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B223E6B05B5; Mon,  9 Nov 2026 11:00:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8BE786B05B3
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:00:48 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 22403A0764
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:00:48 +0000 (UTC)
X-FDA: 85416043776.25.2F9B524
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3EB73140013
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:00:46 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=efhrXBeT;
	spf=pass (imf26.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794240046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3hwk2GB5E9yuK1j6xly70E+Q1WnRkihoUhyrxhgUk1E=;
	b=7GDXSStVvZ804TET2VQOno0fBkzYBTQkSdBYBEvRSnOHV/De2h3YgNWN70Sn08V+s4JrV5
	j5ObzkiSlZkfW8A/a5VcRXvjcyWfXuHS0oHVIVbDUEUzGbhWwBd8nwtNkgEHvhG50nqWmZ
	FRwZareLg4V3zPIZMvJBtYH7SpmvwBE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794240046;
	b=oh+gqRyg/RHXbGT3Pg0dDKKGnTS4eKpSIOVLsym7t7CBfficyvdtMYh8t9UdQmwgEmYuqu
	eTsxyuK9iSD2ROY+2cCM0REbxCUn2elKQ5DvowtbN4xLP2hJj6h/joMIBZX5iCdSiquWM6
	dwuDkj/H4sv6XfaZjZR7XSJI60K0Ils=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=efhrXBeT;
	spf=pass (imf26.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 507AD14BF;
	Mon,  9 Nov 2026 08:00:42 -0800 (PST)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 74F283F632;
	Mon,  9 Nov 2026 08:00:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794240045; bh=OKEfECUxhgnJD4NtvkX2PSEKEz/6It6XOn59vGtNFZ4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=efhrXBeTOF6JY5AKxnktAByldq25EXNZeVRm09/Wjf7S5kezGDQUmu0M7VzFSfwil
	 vTH/fZ0C96iOHmegIez5wQ295wUY2VfSMryjaa2iCbFbnH4vObVLJH8lbo05jy320F
	 KbKM3HoqmmAKE1toAvwnccYvWdyVaKCAcVp1xWbM=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Mon, 09 Nov 2026 15:58:27 +0000
Subject: [PATCH RFC v10 02/22] set_memory: Introduce set_direct_map_pkey()
 stub
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261109-kpkeys-v10-2-aa6c4d9603bc@arm.com>
References: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
In-Reply-To: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
To: linux-hardening@vger.kernel.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Ard Biesheuvel <ardb+git@google.com>, Andy Lutomirski <luto@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>, 
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>, 
 Kees Cook <kees@kernel.org>, Linu Cherian <linu.cherian@arm.com>, 
 Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
 Maxwell Bland <mbland@motorola.com>, 
 "Mike Rapoport (IBM)" <rppt@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Pierre Langlois <pierre.langlois@arm.com>, 
 =?utf-8?q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>, 
 Quentin Perret <qperret@google.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-kernel@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org, 
 Ira Weiny <iweiny@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794240029; l=970;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=OKEfECUxhgnJD4NtvkX2PSEKEz/6It6XOn59vGtNFZ4=;
 b=QZxoRYuTQiuuxIZupKn6dIrLtKt5bbYrAIVLndZ4+TOYTnRcMSs5Z5ryXhuZFgfXQzUYAojW/
 XVUm108COzSBB9z+v+KqzEaNNu2yUR+UCcsn/ZivdTFiTH6wmdcy4hL
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Stat-Signature: q17ui587sx48y8w1qmhh3jsdsnatejuh
X-Rspamd-Queue-Id: 3EB73140013
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794240046-433000
X-HE-Meta: U2FsdGVkX19kZ2ZUpbbCfX/c7FfShwrfNmwBRT5t135Sk1ZHbKOO2xDdrtrXKK3LIFKfPUnKCNjfmnN2cGCciC175GQw8yOsLxZok7PgOnBUjATt7hAIJdkpMaT6aWSmM/AyUMTFjG8PV9mff8PPfT1onHhqGdeMP28EVFKOlLBlrMf5julDOEI149r7Dt3zR9NboJFf2DU6NJlYDCcyRedBZlY/yzyyOYWkJFSRCbkq6IzHXEFp2XEz8/uY+5cohxYepjOY0pnAZX5OGaF98pkn3UMN2Ua0R+i9Uigd5NeN1Tb9Kw/BzzYHDnJLnsrwpm0fb63nqfCTU6fSqNbxnNmfpiuL0hCiqE5JfQRNfQJ+7I+Hc9F04gIzq5u/ftcF2qM07CejxYmuDRhHbrHnml/+CwIjYeqE9KdIy84MLez2gLI0SnK4ymeu1N8RJpT2WylecS2LQ+lonMmAeMc+gf/iDr8zbQsIB63Wo7lmsg7Yh2TNl2s/KFYTqUub/Mo0P/oudDi9EJwNDRWiTWJlK8yy3RG82vWXd1WSgo3Bt5GmO7bI/hLUwJ8kImflYqv84dNdF8yOZExfHUKUPGQXdtB+Ns8WRf9MwliihaSA0yLXzdYJWyDEPH8HLBsuWovx44XbbQZASilfPdy6Bhf5iPmYo5gJ0CqAi1SVE8vzVpp8BFSF2pAhs3nQpMhoiC53b0g8JyvYix0s2okm4LE1lAgggHxymwyMbbLCiErF1HYf+ZWhZQr6bGQ1yaJL766Y18H7aLfUqM09YoqGMrlVytvpdUQu0bYMPk2ONDVuMfJlofQdmKG+qtJFILQ14dmk3Fsbtalg9AIxgPCWNxyhDbL4ctNWSgbG2eFPbIXVkvbHMCTNnfqJJBpjeigrzPSK3Q3v5zNaOqsWO3P8n8C4hcdAMPUTGQGKjteD6jhxJ0oUhKteAWsjpwE7EKL3iyKf6umVnjwBbU1ROZJvN1y
 U+xYwpaw
 fM9EwzDHaV+K2LaU6SlzQMNg/LE8MMFxOK5609sGxdqAoGvYGbYWZvF+LNnw7TsHWp3GKMPxMXdUpnPKJ0P0tshP6sSFOJHwoV3E52aK4hD8ciOufcHptvx1pEJvvlhxWolwqlVyN4DOanlkHTZFqv3SSHUMJd2SPOJBUDQzX14mTM88p05INjMF+/sLguM44V7CMIEsxyyYHCtY2pLhp6nfTfdtEas++Tqb9ZjUo+URoRFAZhT04FDWYa77lhfwWRUaWYSSpSl1BV9DkPbNoizjT+x8vS7fVCBj5EVyF8n1e6WdTyR5G/qBOWGDXyKYJpSyo8DhaR7smt05nMUGifsbth+UnpfKRzkp6SezsdX93JEaCApd3pEZsmc7x7rR6bJMdFa5My3HJSr3BWsKat9U8Cy50qU1DlTVS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Introduce a new function, set_direct_map_pkey(), which sets the
protection key (pkey) of pages in the specified direct map range.
Architectures implementing kernel pkeys (kpkeys) must provide a
suitable implementation; an empty stub is added as fallback.

Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 include/linux/set_memory.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
index 27c32fbabfec..6172f1ecad35 100644
--- a/include/linux/set_memory.h
+++ b/include/linux/set_memory.h
@@ -190,4 +190,11 @@ static inline int set_memory_decrypted(unsigned long addr, int numpages)
 }
 #endif /* CONFIG_ARCH_HAS_MEM_ENCRYPT */
 
+#ifndef CONFIG_ARCH_HAS_KPKEYS
+static inline int set_direct_map_pkey(unsigned long addr, int numpages, int pkey)
+{
+	return 0;
+}
+#endif
+
 #endif /* _LINUX_SET_MEMORY_H_ */

-- 
2.56.0


