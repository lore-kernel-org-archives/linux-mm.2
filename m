Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F28E106ACE2
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 19:17:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 443FB6B00AF; Thu, 12 Mar 2026 15:17:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 425826B00B0; Thu, 12 Mar 2026 15:17:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 308236B00B1; Thu, 12 Mar 2026 15:17:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 145FE6B00AF
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 15:17:14 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D58298B62F
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:17:13 +0000 (UTC)
X-FDA: 84538369146.06.9E99786
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 169954000B
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:17:11 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oiFVSSWh;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773343032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vPhRODiUmhApdZ9nninHZXaKw/32D++OFungj9CnSis=;
	b=GPXP3LXIpveD5cvF22aZdO55YVXwq1aPVXnNWJ3bL+Vgogkmh4HcVsKqEsd0fgQe8UYFIr
	SpX7hOm/R7KuXJYbD6IxRbvpHoX0MrohhJ1RiGT485fOQ8Ibe1+Q4KNG3y/5sp3bbA37A3
	hzjsGbPTe+YLmk3LkfdmLa7rj7WWymk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oiFVSSWh;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773343032; a=rsa-sha256;
	cv=none;
	b=aE1zHBX6mG6p04uifDE/lTXmFf9sz/prge00QUK2hyBCrTmzOwNQd6FrtwlKMMDf80igIF
	TGgs+Wr0n/ctjUqM47Tb18KEE9iARX/t8VFHSe4mC6WK7/+u8NwPkY5itR39D0LYYbhrHJ
	bMomoQ57GEGStdBXhdZW6ozpsHp0lxs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3A2C2435E2;
	Thu, 12 Mar 2026 19:17:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91370C2BC87;
	Thu, 12 Mar 2026 19:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773343031;
	bh=Rovsmd7IqTNzI5EcVU23ecGwNpd7/HeY2RA96JWK1G4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oiFVSSWh2OUxe+IRR3rnmTy8nxwzuzVDRNi+ROq8s04X0N0PeqKlBjCJMmANJda4O
	 dGBvn2t4JqWT8XRLnm7gqFwQr3Ib+D6vdBYLCDQrscdAew48i/qQ79WgO1WaOCs1Ek
	 Uef4CcGMrvESwh2/7ZyrUZ/jikb5cfXIP6DhGpvR1DUKe4+IGexmTb1I8ojluvK0su
	 ZiGKKueX7fbrX15WrU4TqUkVZWJnXZDbQwaVolX/lK3hHBgzPeg0b24sxN9C7D7an8
	 XPVMwN3uY3elSHAWnR6Nuscs7fK0+H9tzU5FWYEBIYY4bYJtaSdZGD+0325r8cQLEw
	 pJyC4jXOP5boA==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Kees Cook <kees@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Vineet Gupta <vgupta@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Brian Cain <bcain@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Michal Hocko <mhocko@suse.com>,
	Paul Moore <paul@paul-moore.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Ondrej Mosnacek <omosnace@redhat.com>,
	linux-snps-arc@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-hexagon@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	selinux@vger.kernel.org
Subject: [PATCH 15/20] tools/testing/vma: update VMA flag tests to test vma_test[_any_mask]()
Date: Thu, 12 Mar 2026 19:16:13 +0000
Message-ID: <693d6e7333f5c8859593753e682a5e7169551b84.1773342102.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773342102.git.ljs@kernel.org>
References: <cover.1773342102.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 169954000B
X-Stat-Signature: wcf3np8xfc9id45e8d96nit8m4878snc
X-Rspam-User: 
X-HE-Tag: 1773343031-801490
X-HE-Meta: U2FsdGVkX1+MdMWSBUhr54j8PwpggSImfN2YUO+uDT2hHKtddK70FOvvcN67w0gfgpcl45UezTr+vo1qh8XeM1Ogp4rn4Kcc6k1HfPyZCb20Iuaeteb7/cW3xY01Gq1KfsJ/RDumue/XTKyxv98Of+Zl6fRy3Jr1Hu7YShgZYr9WhGtoIyw8P6KZfkVpxRtVaTUqQZsO+uR0QQjiJquHhVWThGWXz6CJhJ2g28hVNtin1UrwcNP8tkb36NLglbA5RWCZby2ZuW3D6jAi3yFf9Qje6PePz1NvLVqNnWD13ohSV39lcGukva5be7cvdIfoqdxrInaYbXWw8XYsqMoamINPTjp8ZdcoFabiph3txx4NkxfAHY56kmTa4jhFnVkkzdhrn6TIxkIKbY1TP156+1N2U9oPXxlfs/8xo9HtwGnTbAf2KHhjZJUqAz4tOpjB1YYJQxO2KEeb+B31ptSkbYu046jF9D+ckffj7w2uukFil1s3Iey3fZlO6pr1GaFp3gMcJSEZOH09kt8T/5ujTkBJQG6O/Pw3mZA8h+MVczcV8ScU6/N70NqjbQu4s3p2K2tqrrsDd8rhH5CEnDLbdh2ZQiQ6Ce5RE1S54ebDRR6okWi4DeYCr6QGkAOxxCRZyaiuioC4vbGD7e0p2oNjLA5zZI9xQD0FIlexT2Uarh/M3mn8cNwxDkzA7cIVl10N87acVYZSUcOtrL7y8Z42H0oF/7o/15eWZtSut3XJSKeOYrqYYpMpjHcgpkr2kSxsX2/HAiT12Nn8yq6T26nkY8HgQF4myqTJ4TS4TBgnOqB5Fcr4Vp41QSnVdAdAXh6KuuB9pWd6ffg5HvGi3nP3sPZI0jxBDIv40jPVUmXnGzxW7GF5M82W5GoafFSLTS7wufFjYbY/YrS/uB6MgmAYsWDzbVOgSwsUmqUPWod//2QbnfdpToYmCD0Ug0FZ35NVRRMR31QVTHbUvPrHrjs
 8Flgx3mA
 KIW4LeYWOB91uqZIECBmEVrOwp2tdDlajy94V22duxxjq2rQ4kHH4WC8XH3NxuKdKSoqkq+ewtzsN/dOnWm7SW5jQIyrbJzuL8i+qHm+J2tMnlbvKosZ7qYHZ0mbV6Di7tU30sVRJcgDkQP42KiAjb7gBLtvQKRNyIMvBCCTMuzs7xp3Lyhe5YtccVrrIzp32L6nTyqPO6bLXoOzYY8lObvmcArjhYQjPd9JKlKaPw7+5iGatYUgL4kC4VvBVx/Gxz4kCe8vG/6HPErpOHoTrP3llgnJWDgKzhzDbwhwcCPp0dezFWlJmDO5BX2Nym40aGlwxAoUqO7oBzZCBbxBD4aa8TX2qzCv+GO3c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update the existing test logic to assert that vma_test(), vma_test_any()
and vma_test_any_mask() (implicitly tested via vma_test_any()) are
functioning correctly.

We already have tests for other variants like this, so it's simply a matter
of expanding those tests to also include tests for the VMA-specific
helpers.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 tools/testing/vma/tests/vma.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/tools/testing/vma/tests/vma.c b/tools/testing/vma/tests/vma.c
index 1fae25170ff7..1395d55a1e02 100644
--- a/tools/testing/vma/tests/vma.c
+++ b/tools/testing/vma/tests/vma.c
@@ -183,13 +183,18 @@ static bool test_vma_flags_test(void)
 	struct vm_area_desc desc = {
 		.vma_flags = flags,
 	};
+	struct vm_area_struct vma = {
+		.flags = flags,
+	};
 
 #define do_test(_flag)					\
 	ASSERT_TRUE(vma_flags_test(&flags, _flag));	\
+	ASSERT_TRUE(vma_test(&vma, _flag));		\
 	ASSERT_TRUE(vma_desc_test(&desc, _flag))
 
 #define do_test_false(_flag)				\
 	ASSERT_FALSE(vma_flags_test(&flags, _flag));	\
+	ASSERT_FALSE(vma_test(&vma, _flag));		\
 	ASSERT_FALSE(vma_desc_test(&desc, _flag))
 
 	do_test(VMA_READ_BIT);
@@ -219,15 +224,17 @@ static bool test_vma_flags_test_any(void)
 					       , 64, 65
 #endif
 		);
-	struct vm_area_struct vma;
-	struct vm_area_desc desc;
-
-	vma.flags = flags;
-	desc.vma_flags = flags;
+	struct vm_area_struct vma = {
+		.flags = flags,
+	};
+	struct vm_area_desc desc = {
+		.vma_flags = flags,
+	};
 
 #define do_test(...)						\
 	ASSERT_TRUE(vma_flags_test_any(&flags, __VA_ARGS__));	\
-	ASSERT_TRUE(vma_desc_test_any(&desc, __VA_ARGS__))
+	ASSERT_TRUE(vma_desc_test_any(&desc, __VA_ARGS__));	\
+	ASSERT_TRUE(vma_test_any(&vma, __VA_ARGS__));
 
 #define do_test_all_true(...)					\
 	ASSERT_TRUE(vma_flags_test_all(&flags, __VA_ARGS__));	\
-- 
2.53.0


