Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 181FCCCF9EE
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 20:08:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CD058E00ED; Wed, 29 Oct 2025 16:08:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E1138E00B2; Wed, 29 Oct 2025 16:08:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A9138E00ED; Wed, 29 Oct 2025 16:08:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 587508E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 16:08:30 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F3D5412B12B
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 20:08:29 +0000 (UTC)
X-FDA: 84052239138.12.3F4B76A
Received: from mail-4322.protonmail.ch (mail-4322.protonmail.ch [185.70.43.22])
	by imf23.hostedemail.com (Postfix) with ESMTP id 30288140008
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 20:08:27 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=f1ahGvJ8;
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf23.hostedemail.com: domain of m.wieczorretman@pm.me designates 185.70.43.22 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761768508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ye8tYnzEiAyAJOizOqIrcZYSk2K1DbVUwkfvl955amo=;
	b=qxPD7d2UKqU/k+wPt9UniuMfxcIb+Ln9ursOSn91HvCM49g6FE6V8M1v9xghrxprKHa/fn
	0iZeAdkI/0rEjVz+xcWJv+mm/zMm0KdMRuB026OAKRi9vmKczSS5n34STTz0Xg6yJcMfdO
	bJMBErP2xHEJ68ArYV9FB4FvMzG8rjM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761768508; a=rsa-sha256;
	cv=none;
	b=tjFDU1l9U4CU8xiPi/KLTPY74dwz07SQMDiSeciWfb5IjJlEY7kcIDeD/CHAL1mKXjTxjj
	1fgT0Ge+I3LItUHFhm61JXhK1c+nzYzq3tK/WJPxWe/+BcLOMxj929VOFEBYz8ZYhoxf6+
	MJFu/T0BdT1tAFnjdGUFCM2KpJ0KrMg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=f1ahGvJ8;
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf23.hostedemail.com: domain of m.wieczorretman@pm.me designates 185.70.43.22 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1761768504; x=1762027704;
	bh=Ye8tYnzEiAyAJOizOqIrcZYSk2K1DbVUwkfvl955amo=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=f1ahGvJ8GYmWSAN4yQvaJJ8AMmaQXPPMzcKSaz6Xrvq0aoFjM/UK6qEVGIKRCoLqb
	 5LIptGgTqr85HdCtdsCnnkULneMU0vlAU6dQciyV6UUzUvyMy/kCVMmX+/4xr6YHW/
	 +oMozIC9BWSxBmEgcmmyjZZG3vnN+B3w2jxVYTdAYKkzhqe2taxX2Pl6kthj9hres/
	 YBb4kjMyUMhTGxyvSz8vda/30rOZZimxFRxQD0jyouhiV9xwy9nfBkUN6uEXRd/Z/X
	 euFq5/cNqoY3dnXuBokf29Dwc8D5+0mx1I6WMSm4ouiysMLrt2mGdvalln0qeq9P+o
	 sDufRjOTA1fvw==
Date: Wed, 29 Oct 2025 20:08:18 +0000
To: xin@zytor.com, peterz@infradead.org, kaleshsingh@google.com, kbingham@kernel.org, akpm@linux-foundation.org, nathan@kernel.org, ryabinin.a.a@gmail.com, dave.hansen@linux.intel.com, bp@alien8.de, morbo@google.com, jeremy.linton@arm.com, smostafa@google.com, kees@kernel.org, baohua@kernel.org, vbabka@suse.cz, justinstitt@google.com, wangkefeng.wang@huawei.com, leitao@debian.org, jan.kiszka@siemens.com, fujita.tomonori@gmail.com, hpa@zytor.com, urezki@gmail.com, ubizjak@gmail.com, ada.coupriediaz@arm.com, nick.desaulniers+lkml@gmail.com, ojeda@kernel.org, brgerst@gmail.com, elver@google.com, pankaj.gupta@amd.com, glider@google.com, mark.rutland@arm.com, trintaeoitogc@gmail.com, jpoimboe@kernel.org, thuth@redhat.com, pasha.tatashin@soleen.com, dvyukov@google.com, jhubbard@nvidia.com, catalin.marinas@arm.com, yeoreum.yun@arm.com, mhocko@suse.com, lorenzo.stoakes@oracle.com, samuel.holland@sifive.com, vincenzo.frascino@arm.com, bigeasy@linutronix.de, surenb@google.com,
	ardb@kernel.org, Liam.Howlett@oracle.com, nicolas.schier@linux.dev, ziy@nvidia.com, kas@kernel.org, tglx@linutronix.de, mingo@redhat.com, broonie@kernel.org, corbet@lwn.net, andreyknvl@gmail.com, maciej.wieczor-retman@intel.com, david@redhat.com, maz@kernel.org, rppt@kernel.org, will@kernel.org, luto@kernel.org
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, x86@kernel.org, linux-kbuild@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev, linux-doc@vger.kernel.org, m.wieczorretman@pm.me
Subject: [PATCH v6 12/18] x86/mm: LAM compatible non-canonical definition
Message-ID: <56d9203b1fcb6281b0d29b44bc181530e5c72327.1761763681.git.m.wieczorretman@pm.me>
In-Reply-To: <cover.1761763681.git.m.wieczorretman@pm.me>
References: <cover.1761763681.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 015c7fdaea374a790951b755b565538ef4bdd04b
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 30288140008
X-Rspamd-Server: rspam02
X-Stat-Signature: wizaafdtdp7fe531iagkgn9tcziwxwhy
X-HE-Tag: 1761768507-292809
X-HE-Meta: U2FsdGVkX1+EYypoSdSdWrTfdA+58rrTbq0EvPt8hB72bWRIOpBRiwBYGrFIwbFXXyKayY3ib1ysvzzxNfZvKc9PL2ZFEeuq3relbosVPay0wcL/9n1g/Qb3hau1Poq5M2mNkawaOSH0AMrLCp6U4zR+flcQKY3YAsdv8I9iqNu7YyX/3LjIYvRGtLEZ2DmI8rwsB6wyHH+YXY9Dyu/rnpGabmTPPuDcNpYUIFn2OuaKXouN/IdETXQyIqchj6SugRd5NXcnqKkQZHC6s2OOe6KcyefgQC8CTBVWb1f91Cf6OCacpecRqgZ9YhSuGWop4Zlr1uHvs0PkqdqG3I4EiIpShK54vDyn7oFUmV+E0TMyvv3GiPF+fV7qMFtVTIAU6tMBwF6Y4FRyk3v6QQvXU1qeYoMraDxJoDt1BYaKdQah3e7ntYwkBsn2ovwFmoJMpiko5FqpJ1mQh9bnoQpwfPhIt0MZq8uh5T7PTZha9J1bZ4X7qdbRQeRGHT81qwMWFdMQ+K7zcmeOkQn+DFrqJGGOCqkfLZJxvMjzIYS1Zlr0ZjQ5o0mSgJl9hBlL/EVXZ0Q0TqnXWuCzYZueg6nLThR66OlIZlYbqGz3GgPpkSBkAnUW7qo5en6p2jG1gDAEPIqQCJStcLN7fFW34u6WjfWGsW6PF5cxlJBkErkrXcNu8imvUrBK94THN8y+UtklXuplVZO3wvEXA4uZbq+r8aW8JwbQH1P2byIpGEx4gW9MdlQHgzHgTIBuY/NX6udd5R7jmw2idM9mtN7x3xuRulDi3KCO/TggNlGBaOV9k45I/kIl+2lNfsgq4df4PFi2JfvWpwE+IItkbDsurqy52rHx/yvr+SULw+zI6lZ8tB9qn6KQiA8ZX+WufGPpCMhxWDK7QGeZXOFjoqofxlcU149eYLJOWBxoZymZJ6NkjSL2FcsHC/gRTDwMyrt6UlZ2qsRvsYreIfN3aKueUCl
 i41Kpebc
 sEZAm5wBieuJdGuNuubEgAdo3PH9pZYca9md8yUztouiM7CnJbrQiQTLbS6yXaRBzt7Lgg9HPjc8JI6+5J0oNrdVOXJI0a2vYylqjvHTgBMsyFcopYv5du9NAK6JNXAZWEV1Z15CUZADqzDBZm2Q3TBssvXwZYw9O06/5sl3sK9KTd7lrnNiOvQFSlb4bndEP7sxtIajVIanGkH1J8oj5GXdMDXh8Vqg4H3gO28p4UZXMDWBfGJ3KlX8ZH+3Q3syH8EbKHj47gOz8erCY4yyBbRP4d+iHbBcK6tIc2hbgQY5mnGGXv6oV/QA/Dg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>

For an address to be canonical it has to have its top bits equal to each
other. The number of bits depends on the paging level and whether
they're supposed to be ones or zeroes depends on whether the address
points to kernel or user space.

With Linear Address Masking (LAM) enabled, the definition of linear
address canonicality is modified. Not all of the previously required
bits need to be equal, only the first and last from the previously equal
bitmask. So for example a 5-level paging kernel address needs to have
bits [63] and [56] set.

Change the canonical checking function to use bit masks instead of bit
shifts.

Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
---
Changelog v6:
- Use bitmasks to check both kernel and userspace addresses (Dave Hansen
  and Samuel Holland).

Changelog v4:
- Add patch to the series.

 arch/x86/include/asm/page.h | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
index bcf5cad3da36..df2c93b90a6b 100644
--- a/arch/x86/include/asm/page.h
+++ b/arch/x86/include/asm/page.h
@@ -82,14 +82,37 @@ static __always_inline void *pfn_to_kaddr(unsigned long=
 pfn)
 =09return __va(pfn << PAGE_SHIFT);
 }
=20
+/*
+ * CONFIG_KASAN_SW_TAGS requires LAM which changes the canonicality checks=
.
+ */
+#ifdef CONFIG_KASAN_SW_TAGS
+static __always_inline u64 __canonical_address(u64 vaddr, u8 vaddr_bits)
+{
+=09return (vaddr | BIT_ULL(63) | BIT_ULL(vaddr_bits - 1));
+}
+#else
 static __always_inline u64 __canonical_address(u64 vaddr, u8 vaddr_bits)
 {
 =09return ((s64)vaddr << (64 - vaddr_bits)) >> (64 - vaddr_bits);
 }
+#endif
+
+#ifdef CONFIG_KASAN_SW_TAGS
+#define CANONICAL_MASK(vaddr_bits) (BIT_ULL(63) | BIT_ULL(vaddr_bits - 1))
+#else
+#define CANONICAL_MASK(vaddr_bits) GENMASK_ULL(63, vaddr_bits)
+#endif
=20
 static __always_inline u64 __is_canonical_address(u64 vaddr, u8 vaddr_bits=
)
 {
-=09return __canonical_address(vaddr, vaddr_bits) =3D=3D vaddr;
+=09unsigned long cmask =3D CANONICAL_MASK(vaddr_bits);
+
+=09/*
+=09 * Kernel canonical address & cmask will evaluate to cmask while
+=09 * userspace canonical address & cmask will evaluate to zero.
+=09 */
+=09u64 result =3D (vaddr & cmask) =3D=3D cmask || !(vaddr & cmask);
+=09return result;
 }
=20
 #endif=09/* __ASSEMBLER__ */
--=20
2.51.0



