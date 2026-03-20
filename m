Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 590F11099B3B
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 19:39:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B5726B0175; Fri, 20 Mar 2026 15:39:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68DE96B0177; Fri, 20 Mar 2026 15:39:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 556C36B0178; Fri, 20 Mar 2026 15:39:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2BE556B0175
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:39:17 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DF5461C34E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:39:16 +0000 (UTC)
X-FDA: 84567455112.21.C0C563F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 04C98C000F
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:39:14 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n9G5Rfle;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774035555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5K7eKfDaNC8F0R4YEvVj595iph2zwfv8FNQbISthhlI=;
	b=SmEcqmafVyfokNonNC2YZqulnyMdW0vrVnbF12gyuf8Cmb4M0bPGPNJuzXgC6m3H2EK0Er
	s+KNomvuGLvaqH0zp/iUdmCB+limJO++zMRLoqhIJSs8pSCDCi4Ypro4ZEPEI27THZNIJL
	8yjS1f9MGxFW0E7kfinOGHz+K/Kg2lE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774035555; a=rsa-sha256;
	cv=none;
	b=1mosOTKxBDS4VR2N0R+aAsj4Wx5vRMjcHSRcL6k7hwN66AlmZDMsfsIAgyC/X/W5Nrr+xm
	0T3XS4Vxtp+xg7QCXZIkS/kOh5wVefFZpOzwQEIlaro2I6bONhaApBr1ONqUxoy0pHM+wb
	aJ7pphlGsx+HjW+kgpYojVX7fywQ+1Y=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n9G5Rfle;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1489D43420;
	Fri, 20 Mar 2026 19:39:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75CADC2BC9E;
	Fri, 20 Mar 2026 19:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774035553;
	bh=LrLBS64c+lmBUJM2XbvLHLJnGjK9/zMfbb5TL2UTCws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n9G5RfleSKlgF5IOVA2zXMw7RB/0EsB8jsXdwJANrb3vkQfRndWlRknI8JoQlRPuv
	 zgCX6aDwrYZVTz75jLr+KIPFYcBrUDvMT9XX7hAb4vlckyEtjaKsjouuzE4QE6Dcl1
	 o2HwpJagChgQY9sNvxa2V3D81uvsfl9/SrEthaNA3o+Sr88oot/AuaCYgDeBFOySyl
	 q6XeWSPRQJ3LJkLYxCqrpBHPF/1/0pG+jUNSe8+4vHsB1eeoQfAb1rWhYw6UW/7T+1
	 OvSzcnuLb+EqzJMxiNiIU7Wkgy6v68h8V5rWxiRLmLjJMLfpRprBXEC9xhv69y4Xd8
	 BPa+YjeIoj8Pg==
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
Subject: [PATCH v4 12/25] tools/testing/vma: test that legacy flag helpers work correctly
Date: Fri, 20 Mar 2026 19:38:29 +0000
Message-ID: <3374e50053adb65818fde948ae3488e1e29ae8b1.1774034900.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774034900.git.ljs@kernel.org>
References: <cover.1774034900.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 4yztug7dmpkzj1zhako3so14kgjsgid5
X-Rspamd-Queue-Id: 04C98C000F
X-Rspamd-Server: rspam03
X-HE-Tag: 1774035554-960608
X-HE-Meta: U2FsdGVkX1/UjqH2IGRZY8mcYLNd2+9noMx4GuPZ1gd5Xt81dNYNjO/djQe8CaWrAtXlm2uN3Flf29EbcW3q+6iBPK2QFdYCFwBN3P5uoILBJ8W6FMW6117HR1hbXnfg9EpnSL4nnxDY4RKSrK+NBuIj/x5qkPJvJ5Zv/OhvPv6zV9TU1Ss8N355HUrj2uW4oKsm/9gq6m5Eeejs0tyAYNrqhpvR2vaa44htSLiZTmngxlIJFykDzIcJhI+NfytRY6OY1eJ3XIVjy3ozsMyQgD4OIbhokkYwH0LcaZ/Qvajag1v15Je6KFsPnRdE+uJehiygJ6sZP4acHmTOQ3A+i9Lo4rxKgQZu5BC5H6pcoLBvoymdsCT6Knu3rJp0PkTbhVA6gazU/vIF0UL2E73H4zQufDS9oY6YP5m/FqAgH7mFEYjBTDf8n9D5q7B0ZSvResmHogcE4yy0n8FTCfX1WbB/5K+0YQ4OfSC7jddIWG2l9VLIOGsnhvOFl701fMMuniarFE+ma/2C6/Ln9LiyF2dPDEnG83B3WTwEvJKkz9XixW9wCwWono3397ybPixiKyjDmo8tTHf/gbOWqBRkTGTuQRbtXqaeUmCFu9Vr6v4pkn/x/v9D+UW9Iu+mzAvUo3qfePohpcowjg9nUtVj03HRpdEHn2q+sDek6NrcRAF6Y3UUjYQkqf3QmZ4mGej82hRW4tq0jwHjCTr9sRTZDb5X1Duf64BPUmzqgt0Qc+/78pMNaChj12pQLig/lVIY6gZUdLYguITqY8vfuSCYJOwtuwaiM6xdxgrjcZGxOJ1Gu0BXW5FQHIuPOakmv6SQeCs2gHnCnhln4XzQUVaEHSk+tDNggs5XuSdueTGcJTAszPQ+tasNbHIt7KVg86YsLrqAKfejM6ew91/wRr99v8PaWbfrzKldfUFFKaDtv5AX/TvKixwybTu2PnnwC8VGo11VgUgiAPjeeEty0oa
 W0hqFLGW
 PUcT4r0hIao5+bh40vJE6Dx8YKsMUbdsr1NWlQnfLwbOqwhAnCu5sWexC9WlLrm4pJDY9ZSmVIgOtv4sBW4hbq+x2gec2GnQT3q8f3d2IbWx+T1ScHhS3MPwiPxa5lwv0ZCaOWdyhhXVxCMXtWzQVa+XbI9bN5meSa1hfF2N5i6Cuzrm1KhLeZSl/OUoRxTVW1F2b0Gb/pKnYNV2zG9rOzeAfQ+8pqirCGO/bP3UIoEwmeLxAapA2spfNjy0iRwltdrpl472eR7yO5vPfeQryRKoHj7Cr9lQDvtyfuoMCrcZ7NnHNcn+Da8HxFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update the existing compare_legacy_flags() predicate function to assert
that legacy_to_vma_flags() and vma_flags_to_legacy() behave as expected.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 tools/testing/vma/tests/vma.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/vma/tests/vma.c b/tools/testing/vma/tests/vma.c
index 98e465fb1bf2..1fae25170ff7 100644
--- a/tools/testing/vma/tests/vma.c
+++ b/tools/testing/vma/tests/vma.c
@@ -5,6 +5,7 @@ static bool compare_legacy_flags(vm_flags_t legacy_flags, vma_flags_t flags)
 	const unsigned long legacy_val = legacy_flags;
 	/* The lower word should contain the precise same value. */
 	const unsigned long flags_lower = flags.__vma_flags[0];
+	vma_flags_t converted_flags;
 #if NUM_VMA_FLAG_BITS > BITS_PER_LONG
 	int i;
 
@@ -17,6 +18,11 @@ static bool compare_legacy_flags(vm_flags_t legacy_flags, vma_flags_t flags)
 
 	static_assert(sizeof(legacy_flags) == sizeof(unsigned long));
 
+	/* Assert that legacy flag helpers work correctly. */
+	converted_flags = legacy_to_vma_flags(legacy_flags);
+	ASSERT_FLAGS_SAME_MASK(&converted_flags, flags);
+	ASSERT_EQ(vma_flags_to_legacy(flags), legacy_flags);
+
 	return legacy_val == flags_lower;
 }
 
-- 
2.53.0


