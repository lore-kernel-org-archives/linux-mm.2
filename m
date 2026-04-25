Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F6EBFF8863
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 20:57:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A810B6B0088; Sat, 25 Apr 2026 16:57:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A317D6B008A; Sat, 25 Apr 2026 16:57:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94A626B008C; Sat, 25 Apr 2026 16:57:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 832EE6B0088
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 16:57:41 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B27898B3EE
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 20:57:40 +0000 (UTC)
X-FDA: 84698289480.14.5FDB0D3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0FFA080008
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 20:57:38 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=zBRZEPzv;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777150659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Eoxho8u48j2pRz3C+6V0k3KIeFA5Qx+fAl7cbaPgKz8=;
	b=1r2sjoASXutpqLhusJudlCPQOkGw2aonYfUvGr3uS/pjmXg8rnWj1kDGaAb1I7rtw9dgMc
	ot82wHk9M/jJvf6v0ABK59hxEKSTbyxBTK3s0xzCHcS2ToUt5Iuwij8x3m2ePVvD+aDz/T
	HZT1LfwH6fA9tneULPaqHgNDmvDxMJU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777150659; a=rsa-sha256;
	cv=none;
	b=eFYgQte1/msMEErV3uubYGZ8qU8ltzvwrlp4iQ90mWxrJCZF4bVpQmGHR8YKWkVzOMY1XP
	4/no5bkR1cOxkhWS6MDh06s8N8Ild1lJb/kLbcfeY6oHoFtIqjRw7n8PBASQoSYCe8XFNJ
	0I68Z/rhDn2n6Y9MlQgNcju87ZkiwlI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=zBRZEPzv;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 66A1E60052;
	Sat, 25 Apr 2026 20:57:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0124C2BCB0;
	Sat, 25 Apr 2026 20:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777150658;
	bh=IIHdJY9Mqcs/tTjfHhjwHqxSAUCuVo7pSdfX/KVRHjI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=zBRZEPzvGdko9Avx+qOZfKNY2QcphvXu/wOUa1w1j8RVwiJ5JqFaXIf8jeh2EqVls
	 DWqPNAjUJubu0oer+FNNCS7LIqorqzTtAZ0ndu+tn7OhQUgXGkHPxYidgBRJZqaotp
	 ptVof85rTIe235A5tmqkMtFFgdpDK7qdTgMPVMZg=
Date: Sat, 25 Apr 2026 13:57:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: Min-Hsun Chang <chmh0624@gmail.com>, arnd@arndb.de, msalter@redhat.com,
 linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] asm-generic: replace ________addr with
 __UNIQUE_ID(addr)
Message-Id: <20260425135737.e79c4b546d22b5ebfd96c0b5@linux-foundation.org>
In-Reply-To: <20260322144032.7353997c@pumpkin>
References: <20260307092119.20733-1-chmh0624@gmail.com>
	<20260322144032.7353997c@pumpkin>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0FFA080008
X-Rspamd-Server: rspam04
X-Stat-Signature: jkqmqcubtmp9fnzp7q6f6pipkmdg6uz5
X-HE-Tag: 1777150658-411037
X-HE-Meta: U2FsdGVkX18oDJDsjLsg22DD8zXglJoCHv78OiHKJVZOpX4QFgdlzoO6Jam1Lckat94k1MpznlcB6AmI9RQMvfjiCZykCfG3GuagYJ2/n9hHrkZpYPCsKgFUzyDQCYWIWr7CsG1lzbdxbLIVS6XNGjSdxPe2Bg04dg9K0hBFy1VLhnetRYcMcaxwvsbDsjfNc6Ti1v+WaPyhEi74hgKWQFWi6bx/GpTcUd+QicGT0BLuIFHnJNlKUyn1UItLCDOnZ8Ic2R1uecFtGJRsC4UW31pG6jNcsguHUyG1szaN/DBpkimLXZ6fAQY+NJ6tHftXxpZWSDSv6kmaToVyCBi7hVbAH4QEiYQ61cJM+OEfkAQgFtVJICW6/LojUHfxFmHVxL3+tDzCPKjKouaSmbq7j7Z+9gFbTyjwidZdpFPu5IOn3z74+8UocrYwF0lcaTiGJDI3mZ7tIEl7LvYB+mTlZSS/eeSLBdGieIWmcrjCR/bERh7YhlR/1do7LtxQEWOgrd+ktSDrvV31FOqea9tZpDhVatMy0M61A6JrWqG614/ezizOFBLL0r1FVuonTEZKRIhyNZtq5yIFcSbsfXhywyV52kY2poOKcl+Y5L2xmW9z1nVMWDfX3PBiMFQdPshzwaiSHTeg9kLu7HGAFSYnIN7wC1tRAhASHYAf6zTqVX2LYXzTBAZ5+N1ksCkgCnnmN5AbYz6fT9fh/9pOkR2aBwj9QFzfme9CwSoyBt+30a9rsIY0LMcgc2GQ9uVbhfdTvNO8s/J03BDrwat4DZfWpuaATCNCGulvq7g0BUNJ2lveYhUrE9rOYKqOl0SCIT7EjG5yZRWGLWqJFvUw6N0VKXEsC41jpeNHyHYblYi9PxQhwSAllI94EE4ld+RJ2QBHDh+oniORhVZUNvH3NSU71eV8wOF3uApMJueLc24jJBbAUPesfZFRpC1zJnWJ1aaKq4Gd8j+pbs2z7bsHyJT
 /y9FsaEP
 fGkoseqtiCddtXboBfg/X3hoN3a9ymw7Q6uLRBlPb8Er6+/UUPHoc39YxzLYrTgRr6HyCOpLI9jSgYpps8BYmcg6p7D2+oEaiKXBGoiq8csnANdaWbBQJnwiFz2gIjzznEPpRi8VKSUGSDukHC/Iy8a0s27vY4HEXRMrAuVTL+MypNucVurGYdX5uQQU1DfVa++LNd5IBxFfnRhHLuiGIBJQxBY8bPUMZ03TjLTNORJoqUvPUFcAbTLVZ3gcIvOCAuSfq0Ke+qoDZ/IgJ44Qx0kJmRO38Y4OV+RX1wAbB+Gbk0iejOaQ0cjkESZQqSY7dBQy9FLqTNZTO0TZBxaYzsIRdAYIJT6jVZqP4I0KcPM4TNWi6oZP90FyxQyj4VvMmM5c7ZT+9NdoFrLOlr4OvyxAV+x8hy16UQc9SrEi/pbnpV7Hk7VdQ3fbhfsa0AJAxKByLp5a8YzzjQeIJv5iA+SW2Xorysl3+M26uqWJ4XjT/wZIl0BaCrGmQjA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 22 Mar 2026 14:40:32 +0000 David Laight <david.laight.linux@gmail.com> wrote:

> > -#define __set_fixmap_offset(idx, phys, flags)				\
> > -({									\
> > -	unsigned long ________addr;					\
> > -	__set_fixmap(idx, phys, flags);					\
> > -	________addr = fix_to_virt(idx) + ((phys) & (PAGE_SIZE - 1));	\
> > -	________addr;							\
> > +#define ___set_fixmap_offset(idx, phys, flags, uniq)            \
> > +({                                                              \
> > +	unsigned long uniq;                                         \
> > +	__set_fixmap(idx, phys, flags);                             \
> > +	uniq = fix_to_virt(idx) + ((phys) & (PAGE_SIZE - 1));       \
> > +	uniq;                                                       \
> 
> You don't need a variable to hold the result at all.
> 
> The real problem with this define is that both idx and phys are
> expanded twice.

The real problem with this define is that it's a define.  Why oh why do
we keep doing this to ourselves?


What's wrong with the below?

/* Return a pointer with offset calculated */
static inline unsigned long
__set_fixmap_offset(enum fixed_addresses idx, phys_addr_t phys, pgprot_t flags)
{
	__set_fixmap(idx, phys, flags);
	return fix_to_virt(idx) + (phys & (PAGE_SIZE - 1));
}

static inline unsigned long
set_fixmap_offset(enum fixed_addresses idx, phys_addr_t phys)
{
	return __set_fixmap_offset(idx, phys, FIXMAP_PAGE_NORMAL);
}

/*
 * Some hardware wants to get fixmapped without caching.
 */
static inline void
set_fixmap_nocache(enum fixed_addresses idx, phys_addr_t phys)
{
	__set_fixmap(idx, phys, FIXMAP_PAGE_NOCACHE);
}

static inline void
set_fixmap_offset_nocache(enum fixed_addresses idx, phys_addr_t phys)
{
	__set_fixmap_offset(idx, phys, FIXMAP_PAGE_NOCACHE);
}


I'll toss the below into mm.git, shall send it to Arnd if nothing blows
up.


From: Andrew Morton <akpm@linux-foundation.org>
Subject: include/asm-generic/fixmap.h: reimplement nasty macros in C
Date: Sat Apr 25 01:42:28 PM PDT 2026

Min-Hsun Chang reports[1] "the macro __set_fixmap_offset() uses a
hardcoded identifier ________addr, which can lead to variable name
shadowing if a caller happens to use the same name in its scope."

As is usual with macro messes, the answer is to reimplement everything in
C.

Reported-by: Min-Hsun Chang <chmh0624@gmail.com>
Closes: https://lore.kernel.org/20260307092119.20733-1-chmh0624@gmail.com [1]
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Mark Salter <msalter@redhat.com>
Cc: David Laight <david.laight.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/fixmap.h |   34 ++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

--- a/include/asm-generic/fixmap.h~a
+++ a/include/asm-generic/fixmap.h
@@ -71,25 +71,33 @@ static inline unsigned long virt_to_fix(
 #endif
 
 /* Return a pointer with offset calculated */
-#define __set_fixmap_offset(idx, phys, flags)				\
-({									\
-	unsigned long ________addr;					\
-	__set_fixmap(idx, phys, flags);					\
-	________addr = fix_to_virt(idx) + ((phys) & (PAGE_SIZE - 1));	\
-	________addr;							\
-})
+static inline unsigned long
+__set_fixmap_offset(enum fixed_addresses idx, phys_addr_t phys, pgprot_t flags)
+{
+	__set_fixmap(idx, phys, flags);
+	return fix_to_virt(idx) + (phys & (PAGE_SIZE - 1));
+}
 
-#define set_fixmap_offset(idx, phys) \
-	__set_fixmap_offset(idx, phys, FIXMAP_PAGE_NORMAL)
+static inline unsigned long
+set_fixmap_offset(enum fixed_addresses idx, phys_addr_t phys)
+{
+	return __set_fixmap_offset(idx, phys, FIXMAP_PAGE_NORMAL);
+}
 
 /*
  * Some hardware wants to get fixmapped without caching.
  */
-#define set_fixmap_nocache(idx, phys) \
-	__set_fixmap(idx, phys, FIXMAP_PAGE_NOCACHE)
+static inline void
+set_fixmap_nocache(enum fixed_addresses idx, phys_addr_t phys)
+{
+	__set_fixmap(idx, phys, FIXMAP_PAGE_NOCACHE);
+}
 
-#define set_fixmap_offset_nocache(idx, phys) \
-	__set_fixmap_offset(idx, phys, FIXMAP_PAGE_NOCACHE)
+static inline void
+set_fixmap_offset_nocache(enum fixed_addresses idx, phys_addr_t phys)
+{
+	__set_fixmap_offset(idx, phys, FIXMAP_PAGE_NOCACHE);
+}
 
 /*
  * Some fixmaps are for IO
_


