Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 322BD606A33F
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EzXrhltc
Received: by kanga.kvack.org (Postfix)
	id 561866B05B7; Thu, 26 Nov 2026 06:15:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 512756B05B8; Thu, 26 Nov 2026 06:15:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 428F46B05B9; Thu, 26 Nov 2026 06:15:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1D2146B05B7
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:15:02 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9D1251603B3
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:14:56 +0000 (UTC)
X-FDA: 85477012992.24.F6356B0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id E1F93C000A
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:14:54 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EzXrhltc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795691695;
	b=McK2vX1wViWSeUjNkwbXO8fOixsgeg91n2qfsWVo5KpLTVKz+a4IUSVDxslOHAhGRcWlkQ
	/NrHt3I28PFqErbPi5lZy/jlOUh/LmECblEupd3eUiW4WWnhPnEbcrhFZFZRPfcZIpkbtu
	L5WWGvCUkBX6Zvngdc6mim2ivezV0U0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795691695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pOe0fNlH4H+/AQprp4nKXyU+tisJl0prDAgrQlBRIqs=;
	b=OehwcehqARnGrFTMYqPXYjDzFRbDHLzR/bUT+0p1LStxSNOfu56S14Cu+eQNcQ83VtSHkV
	vhqcZuAWIAGitfudiypZ5g99SiccCexbX52JL7QmUFltzx7uneLKTnDt6uTE4SpHFRMdNr
	3retO+TTi6EQH1VAMncCJ7h7tE8HHwg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EzXrhltc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3F6DF444C8;
	Thu, 26 Nov 2026 11:14:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 714501F000D4;
	Thu, 26 Nov 2026 11:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795691693;
	bh=pOe0fNlH4H+/AQprp4nKXyU+tisJl0prDAgrQlBRIqs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=EzXrhltcMrtKqO6MUWfWRH8/mg8UPhf8i9k4imGHKf4DwbyhoWKKGEnGwRRQgDHwr
	 GmANWhG79gGu7kXW0nekO6FiH4J7RNjWmJoACGQuDBbF6TFy0hUTXDeJ0AR58NQZc6
	 buOPNoDUiaYbPsAZILufugpB4I0oq+kC27B2yxiGnZBMhs/TYqArOIvN/BjSWka2Ll
	 CnvSHYHGIaFGI/ZvB/lVrv8z1dzNmQ6KLqJFB4zTv51MOrM0Ketp2V7nlbX1PnrjAl
	 v0eW8OfCD1pYNH03IstDX7+gNwHnJQcool9WeGFi33CrMoUwm4fiA2rhPhJlQOskbm
	 xnEyOahRKWe7A==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 26 Nov 2026 13:14:15 +0200
Subject: [PATCH RFC v2 02/54] riscv: test for Svnapot in pte_napot()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261126-generic-set-memory-v0-1-v2-2-723f1e33c3d8@kernel.org>
References: <20261126-generic-set-memory-v0-1-v2-0-723f1e33c3d8@kernel.org>
In-Reply-To: <20261126-generic-set-memory-v0-1-v2-0-723f1e33c3d8@kernel.org>
To: linux-mm@kvack.org
Cc: =?utf-8?q?Adrian_Barna=C5=9B?= <abarnas@google.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
 Borislav Petkov <bp@alien8.de>, Brendan Jackman <brendan.jackman@linux.dev>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 David Hildenbrand <david@kernel.org>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Huacai Chen <chenhuacai@kernel.org>, 
 Ingo Molnar <mingo@kernel.org>, Kevin Brodsky <kevin.brodsky@arm.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, Michal Hocko <mhocko@suse.com>, 
 Mike Rapoport <rppt@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Paul Walmsley <pjw@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Russell King <linux@armlinux.org.uk>, 
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Vasily Gorbik <gor@linux.ibm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, linux-arch@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev, x86@kernel.org
X-Mailer: b4 0.16.1-dev
X-Rspamd-Queue-Id: E1F93C000A
X-Stat-Signature: h8op9mur6c4ai4jd7dynj1ucc69sfy83
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795691694-962103
X-HE-Meta: U2FsdGVkX1+VzbStjyR/ErDtCTl85vcWScxj/fC8vGQndcYZjoQkRHeQarzjk/BWLsuhQDjzsVQGPbUwU4Me4d+9vZFKWRFuPudvD+BfqUHLDui8C6cKeORXKV3hA7/bzltCdNC1/SnBZSzNNGncoYxeybtxg0wIQuLW3o8EZEQY6Lb9HBfeQmEZUcdfqHPIVD/lltsA4f6BsNBW241WeAxwX0iWV5H7U6GiSExZVqQCPnK/jaoGlpzgwXDrQUoa51SdZR7iuhjCvjr6mLINJgNJ/xNxeX8TWLi69gWH5DD0nm8V9bFNdiWoBwJyxUBzqgIgCaa5UVMI6V+dtuaAbspr27xd6Z/dvt5sxhfRDlXnY+aLbWAYB+JCJJHJDipcu7MBodH7hRGhT9SnzXUN177bnCuD6rz+VIwpiKHh/auOXHY0eLMRB4D95Vyr9ziBRsi0kFnRvdJopm2DsDDsWk4SOErQsuM76HXGSXQVstpJbPZGUdGiw9gIRkG0knQbhTS00ogwPNJUHOC/q16JdR93WtvPWhSln47/xn1Qtt6zj1A34eWf6gobrVl78T/7vFEhVLdt8mv+HeUlQGQ6O1jJjYU4wHVPJ8nsKzDUldHwR9HwxKLcn7CFrJH97m3ITTYCzXwnufRpcX/gVNVbZFEw4eS9XaUz1h68jb5V7Q7CSneHHqVvmpHvXNqV/bB9nto+DMu2ouWD3WoUtgUxwk0y73gxR/C1sucio6zQ+8ad0kEyyqTu/S++I1+1Ig7X2tP5yqBuGxsRw9cV7gI05Ke0LD164zLMt8YnoANq1GNSHEGsSRaDvTtirIC44cnqOGblO1gKTf3xt5MqIvCdCv6l1NBGX/YJfsBH10weQOu7OlWH4NlSt9F5IWljwI1PwibcCvRY/5EQcmgqZ37Cv9SFldkV53mHHa+/N3PJeLDWjtEfVs+Io4bifwVrBYcAY1aSANVRcErmlGQR2sH
 Kcm2e1HG
 qU2b7BFtNS3ZMiJT987axcXmSMuImTjBeGkfaaPkAAly7aiyqntGUW58xECoy2yFjzTZJa3UfjSvx9EqElkDaph1aTksN0NNzz6ufhOOd6bJrdswRGfSU2p3rZ1BNPuvjND5Vbwn8iBirzsCRePe8PrcL2X2f9eciFjs5s/zcgnJmXxZpFhZIQvyx2IkMZfFJ5T8ikgOEXCVgM962cuKUiUOQjjwQIWHNtLUX2xkFnXW742hE6U+f7q6aEcaoHIX8nI936cTtUH2XWYNyRaKuyvU/4nICwZtK/gcgpu0wctglr1F2m60u6RLoYmhX79d7Xh6+TUKqBSPknScopdULwxAYhGSSS7JKCA21EEAnyrvk39HpfcTFyueKM1iKwyGwl9LuVPo/Sh4w4MbHNnwbRtL2vlxn+h/ccRkW6ApWsH41RFw7/Esg6syYhT5LrQ3liQWop72ZzUwU41Ds4dm7JcKwxzaM+EdfE8iDfYRvBDc2vcK7xqYZ53qE+7lc7jISjkaOwTE5w3iN+2s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

pte_napot() tests only bit 63 and relies on its callers to check that the
CPU supports Svnapot.

On T-Head CPUs bit 63 is not the NAPOT bit: it is set in the non-cached I/O
mappings (_PAGE_IO_THEAD).

pte_pfn() checks has_svnapot() before pte_napot(), but pte_leaf_size() does
not. With CONFIG_RISCV_ISA_SVNAPOT=y on T-Head, a page of an I/O mapping
looks like a NAPOT block and pte_leaf_size() derives its size from the
alignment of its PFN. perf then reports a bogus page size for addresses in
I/O mappings.

Check has_svnapot() in pte_napot() so that its callers don't have to, and
drop the check that became redundant in pte_pfn().

Fixes: e0fe5ab4192c ("riscv: Fix pte_leaf_size() for NAPOT")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/riscv/include/asm/pgtable.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 2ebd5fa5adc5..1c1ba48315ed 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -288,9 +288,9 @@ static __always_inline bool has_svnapot(void)
 	return riscv_has_extension_likely(RISCV_ISA_EXT_SVNAPOT);
 }
 
-static inline unsigned long pte_napot(pte_t pte)
+static inline bool pte_napot(pte_t pte)
 {
-	return pte_val(pte) & _PAGE_NAPOT;
+	return has_svnapot() && (pte_val(pte) & _PAGE_NAPOT);
 }
 
 static inline pte_t pte_mknapot(pte_t pte, unsigned int order)
@@ -306,9 +306,9 @@ static inline pte_t pte_mknapot(pte_t pte, unsigned int order)
 
 static __always_inline bool has_svnapot(void) { return false; }
 
-static inline unsigned long pte_napot(pte_t pte)
+static inline bool pte_napot(pte_t pte)
 {
-	return 0;
+	return false;
 }
 
 #endif /* CONFIG_RISCV_ISA_SVNAPOT */
@@ -318,7 +318,7 @@ static inline unsigned long pte_pfn(pte_t pte)
 {
 	unsigned long res  = __page_val_to_pfn(pte_val(pte));
 
-	if (has_svnapot() && pte_napot(pte))
+	if (pte_napot(pte))
 		res = res & (res - 1UL);
 
 	return res;

-- 
2.53.0


