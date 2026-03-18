Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FDD8103E19E
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 15:51:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A9686B0294; Wed, 18 Mar 2026 11:51:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8820A6B0296; Wed, 18 Mar 2026 11:51:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 797936B0297; Wed, 18 Mar 2026 11:51:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 65E516B0294
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 11:51:17 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2B9EF1A0638
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:51:17 +0000 (UTC)
X-FDA: 84559622994.01.87020AA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 88C0AA0015
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:51:15 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="PAMV/FRG";
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773849075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5K7eKfDaNC8F0R4YEvVj595iph2zwfv8FNQbISthhlI=;
	b=D/bdbP5F/wM7/S/V7vMDBxFn6KrVw6qHY4CCx6TRqlPQX47//1kl2NkOlF0SjEZS7cCsrW
	cabD6QPXXG/yfIKzGVdujAdfgsNMAMGgW8qXzJ1J+21z6aYDlbxGkMV3dlDi8knvRDd/jN
	l6rVxt3WjTYrjQ/SdY63LJ7dXfTJkYE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="PAMV/FRG";
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773849075; a=rsa-sha256;
	cv=none;
	b=A8YMX/KZOlu28pdHjdCiWdA3oYPh9y/Gf0ohCrifMhRLQNbjKLA7wTI3XqclillH/vtTnv
	hPj7JgsNDMPTesMsCFZy6UUFrUQ1egUzDKI3hhNmUKz0qjdmlYtf50B8G3+5sFn9NESak9
	+2AbTqHZs8gYDqwcz9qu31P1BNLKHIw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EE69760132;
	Wed, 18 Mar 2026 15:51:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3F1CC2BCB3;
	Wed, 18 Mar 2026 15:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773849074;
	bh=LrLBS64c+lmBUJM2XbvLHLJnGjK9/zMfbb5TL2UTCws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PAMV/FRG9PjgQCw7QyBV6vAY5/1tkgmucdPKe6bNfQcaayUFlcPcWUrRM5+pumUew
	 8tkdQO0XR039wEdB/Z+kBm+nVhTMS+y+FEWY9areaHD6j2ywMX1H//6cVHsmdp6ujF
	 M8CROXi20fKoT1AdSl0ZdsL1KeupVrZxCUxOLYtB6/K8aGzLF9/ZuGPeCnm1biPoS7
	 zf9JSM2o7s+qHRM/dDXx7XJX5zWvE/ctttO/iWCDZFKpArYUsCJ2Cods/BYOCBUPcY
	 ldo+q78sUAKXxMqnxurIx0JfoKd2+Sc8PBn+lOt6KAxcWcmrMIXNNY1urbuV+cISbL
	 5HToCgJWlqsdQ==
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
Subject: [PATCH v3 12/23] tools/testing/vma: test that legacy flag helpers work correctly
Date: Wed, 18 Mar 2026 15:50:23 +0000
Message-ID: <4bbead202fcd419239913a61de769b209aa298fd.1773846935.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773846935.git.ljs@kernel.org>
References: <cover.1773846935.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 88C0AA0015
X-Stat-Signature: ugo4sdbo96xo4o7xw6kw53q5jmjsmeji
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773849075-918909
X-HE-Meta: U2FsdGVkX1+fDNzrzrIWwNOa5h95TMnJXoKsu9YkODgf7d/FOnNYrubEKs4iFt0kRk/EfSeCp7RqC+ebVMHvPbtel/oVQ7c3Rq7YgKBH5rgpc7uf8W8iZOVfO9CZ+qz45mruuaRepVtcG8abBJxJvxITYa7yXRkJUlCBbKZiSjGSefcyhjFYLOm38Sl81TLv2wUGtMCNEZ1Q8M3liprNnRYqX54R7L6tSGQ5mhTxxWR/txgsw2jDhnp4gDv8BEou7usWw6A7YZz86wW4Rni33aJ98AGyfjrQ/9n6to+nNroiXPv6jmfdYtfZ1wsWSfgFAGH/U9Ee/H/aydFAjKFgdC0v3m90QR4rlbtb/tNvyo2OzlQmvLQgR3FuOPzhJ3A+PPUblCvXC9tzk9k4Tp9eqx8A9NmkKUTdypZgM8ceVHs6vPeZLq+REr6DN/7hd+YrhmAHNl/vCPqUGE/1rAGWKvr63dZbSU0YZdeMoNB/16vIjnVxYwBXAA88ga80GIPhNWa43EzUTrCn5eBdstNV5wV+GrulSUuRwErOl1WyonodM/yseHLnenc0gTsZD7HrcnmzFjVFJtk9709/s/Y27IGuPBKDuR4J4JSXLZtm4gXmnUFurkmLLrGH9eqNN1yxE/rggZtYklMqDe2LQNLjbJWBDhqcCNAitUrp3oYorcOo3gX3yh9uww+el7cAaZaLTs8CqIvbLiPKmBj8glSn5dVSN91QA/oxAyvnHPTg+A5pZnFIKqr6+5KuFE4OUYnUjYYkOazqG5MmY4CG0phaasYkYpBkKvGDy9qcCkZU4hk9uFEnuAOY5Vj01nYcmh9++RTxT0KZDI1H4FVY+CZ6QjvZEgQRA87qg5yuLIdvzAzFoysMZFHuzixG44L1iLNWQbZ5KgAI5Mk6rWlJb637cwQE2o0eMCLxzeL9jmLRMXiBa4YDTj6WmXBbnxa0So0LCc4ekE+ctcWx2KdrOZt
 Lmh2hBJl
 xCCZeWmRqz5YvPsiFSFE+joHoL104sGgidWf83O8OmTYSmzbH9ocJSyEm4CeB5xePmLglVuUowABZGmCmuoFWdVAahUhwarVUsSqykpKU0IdG0KkvMHw7ELc0hdOIyFtrd7ffY4Hf4UIF6o8Or8sB5oT4lHG1v2GB2oNXf26g6jyNpms/DTL+CilM0c/5/jGpy9ghtTck3i6eiX7h80b6XU0IscwueSVIIl7pHAFdsDqEsl70s2x9xAxldobUkBUCMaNtLxOt5PC5QZO0IG0SsQa+ClDt5EEbnGeSN6QtwZZXw/M=
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


