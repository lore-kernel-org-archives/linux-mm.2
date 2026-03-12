Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B49D7106ACDD
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 19:17:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19C3A6B009E; Thu, 12 Mar 2026 15:17:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15CB96B009F; Thu, 12 Mar 2026 15:17:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 051AE6B00A0; Thu, 12 Mar 2026 15:17:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E81E06B009E
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 15:17:06 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B26A01603F8
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:17:06 +0000 (UTC)
X-FDA: 84538368852.11.85D3773
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id EA15120003
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:17:04 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IKQZlP72;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773343025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5K7eKfDaNC8F0R4YEvVj595iph2zwfv8FNQbISthhlI=;
	b=TjR4MtpSjzOma72BAQj7ZnaRG8f5uPO4SbO/sjpPLNr6R/ltVUzHUK9oT2XNriOzcziev1
	f1Oc9Nxr2xM9e2SCrsMzq2eNxpG0vapvBxHyfG/StNCBL3+PTutQ4qh+si7OaIWfgPG2n2
	k2suA/2aZ6ht4K5Y0PMY6RnXOVmFlDw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773343025; a=rsa-sha256;
	cv=none;
	b=sE4NvlbcLWx5xdW8tpa4VNHGfHUQPIBTUIljrMeQMtDD2W7use4/x5eLjWkE7f1ahNeaDb
	vg0FNNSaWUapta90wfcF2MREXjUy75I0UNdgk3TkVTJBGhiIXa4dRrvLk8lj0P1vp8wPms
	Df0QD/qH99jt5a1w9VnQAxKTEiA9ZrI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IKQZlP72;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 047DD43251;
	Thu, 12 Mar 2026 19:17:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEB91C2BCB3;
	Thu, 12 Mar 2026 19:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773343023;
	bh=LrLBS64c+lmBUJM2XbvLHLJnGjK9/zMfbb5TL2UTCws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IKQZlP72+6csLhk1/TtPL203kF8CKJ4yHgCb4eCuGDZU+ZL2nxheJGMXStid0kFAN
	 2OVVFpqO4OVMSByMzLStjg9y8ifXYjL6/QCXvUuLLFaeCMwb48LvyIXQCF7u8u3qeP
	 uwIxhlyGYbb0gS/nuNZz4OJ7lkW3NGWTMj4VZMvkqDMPIbYoIZWbRDEOUopY1WPX+7
	 qLm3s7SrxVb53C8Gxh9pGNSNcvt2v0Fbh8ym+0CkV6ERlSAFGMEF499lWL9vTnk1ZQ
	 I0/I4AC3auqJmbgPHCWmk6ZrjLB7Rl6c93zBisW5xiBxR+vlvIXopknlA3JpzzSbkv
	 HFt2tFa2A4wpg==
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
Subject: [PATCH 12/20] tools/testing/vma: test that legacy flag helpers work correctly
Date: Thu, 12 Mar 2026 19:16:10 +0000
Message-ID: <63f3217453d4797a7ad4705d438a4f8dcbaf1062.1773342102.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773342102.git.ljs@kernel.org>
References: <cover.1773342102.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EA15120003
X-Stat-Signature: 5rkw36wffdqx8ck69cguht6ua4n5hj1g
X-Rspam-User: 
X-HE-Tag: 1773343024-225647
X-HE-Meta: U2FsdGVkX1/7SyNyz8Cj41vAn3KBfwVFDGENbwmZtjI/3rbIb+uxZf8pAlU6cJfTdQi4WAUsjHtSaFohijYOkT9JWVRA2YeB4B7y2+IXvomzRV7fyiVY6810dy0I6UdAEMjNRFiYJK9djVd1vifdL9lS6QYYgSk7JNaikD72pEO6IIcjJ7OnAqheYWHJiqJLbVp89gtLawDfCxPqAxqJD8LiyMkqynbD6WoU6Mh3KiGSe29pxsupIiFTMz4YoR8evBYKpPtcQvfBEJ0PB69nma2FgMS3lsO/ubyPzwCyPUSYzU1YuTpP79EwglKZzO+VHQC1eMSe/BpN7Pi2Vg8QSbkWC4JYJR/7WkUbe9pFYRbx3/mILKh7L6hOXCsFvV48WuFVyJqQ+y1hZ1VL/JUn64Tw03VB6FRLQdJ0q8ixKThT3YEpJPrj/G5sJ5LNANeIE51FuvvNI9Gcm40CHf5RAVBhqXCGxsamixHw6Ib628t685di62xkwLMgtY/9kXaE1E0tC3RegoP7yLY7Lv8rIFYHjTQ42JHrb+Fg3dakinsOkyo1TAMWxyoUgx8Qgmi3ijJn1g2m6dT4mZ9fj6q6WoAOtvgNszkTr9SiMeEwfJvQekk77PhKQYa5HGpF8TBFEmEZ8gUlL2UiJ7KjYpa+JK4/ypaG1fedzR85uO1cdgWukpOQ7gKxcq4Rv18r+25MXMK3QQwzp/1XcEs5KKf4mfvubFCXu07EMpp996jCA9CpAuam5ZsU/C4M8U46o+VxsZJy0fxrWpEixbUgjqbfbRYQLhDBlM8toyU2JvUTg8Qtzk3w/lj0RKDBkyBcY/6bkdIX3JRIajf1fKFw9pXluwD5PzCyP8to+xV8rTsb7iFAmu7+S+zjeh96WDVYZL7eOeqvH/Xh6AccWuLG9H4TUvUcJUjpM4MhpTAuqFgxcB8DCuHa5LrDg0wfgKJB/P396hTXAhVF6yQzRawiPXY
 fgcVAIq4
 hpBbKICQJ22jc6w2rCWjUG5EQQzutsbZl3JDHi2ac1F9xNo1XXt2+llMo0wsgjtry+VQ4Ofmiuv2b/HeB2iTV+z28iS/R98BWp7my1UgcMcLzTqgokcWT15xWJue+qqoncTDz8UeDnGlwTQ828kFheRD6QyXpGaPvR42LKXMa3WixC0dwtHG285bb2AOM5iXxasj93kamgws9J24uk5yYyX4Q4qs0O3nouizjDNmB5vnibmoB/RmDXABQDtiL73YBOWC0WGbI1vSdJYwOII7RkkRU9PMjTankZ5JVfUmBAJLsKezz1s6Os75a8Q==
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


