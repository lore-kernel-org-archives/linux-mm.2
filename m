Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05796D3B7E5
	for <linux-mm@archiver.kernel.org>; Sun, 28 Dec 2025 12:46:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67E9D6B00BF; Sun, 28 Dec 2025 07:46:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6527B6B00C1; Sun, 28 Dec 2025 07:46:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55F2C6B00C2; Sun, 28 Dec 2025 07:46:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 454606B00BF
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 07:46:22 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D6376A55FA
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 12:46:16 +0000 (UTC)
X-FDA: 84268852752.08.50CBF07
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2AD99100003
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 12:46:14 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HP+mA+BZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766925975; a=rsa-sha256;
	cv=none;
	b=nsgwH+jizLWMxpi2fPQZlvOv6lf+34QVRI2vF2sqOv/gKntqP94ne0wESILAqCx34ZG4rv
	jbou7bdU0vVXNWyxqoKxImViNE9vji4OnImgq/ME2R9c/WX//qS1hgKr1qvtPyb6XQJnM7
	1dSLo9nl7vlBl8cjsU9SzNhgv+bco6s=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HP+mA+BZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766925975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=73LcqBz5hQi6w1FzgSf/p3pFdTXCprVbcEbfxhngyDE=;
	b=hknkgD+5d47byf2E2ZarTnTaUwIstz4m1L1WScuDXBVnlGMbAvrRqRh+jqwhozv1y2TE74
	9Wgg2N+2pA8V3FrHrfaybb8W+zHIRYxgb5qfH9pXmFjpnuROlk5ee8FIWQV12QvO4/Mal1
	k8z6rQ3RZ4ihw7dXsPK+n85jChtYEIo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 546DE43EBE;
	Sun, 28 Dec 2025 12:46:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B19A2C4CEFB;
	Sun, 28 Dec 2025 12:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766925974;
	bh=RZ/DiLSy5d6B26KkgahmhRPqqfwFfapSaWjdzs9zbh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HP+mA+BZahH8JKqMnF569bvDW7aEOc3ZV2OzZ8CeJV0pYGatK4hGWAcTJZtJKMc1l
	 zQa5VLTkCrBWM5fbpERPbQ1eZnpBZhfcIVKsdvya2ruS9g4VKsLOvR4muWleMIXdla
	 N4/GhIBuMW0Jb4/krptZ6sXqeyLQQT0F8Ku6SldAUhjleZjmJZC7Jv3LxQ7CPEH24Z
	 z9gWkCFCTS/wqOBx+z47sRhJJDJM0wnI33NNyzKaPRXEoRxTuQveIyJMBXpW7feKtO
	 92D+nORg+iwZw37Q98hv9ae8aJIO4Z062T9I/ZK+PBtq9Bt9jycEry4Sf1W/NPPXcE
	 GjRe8TOVu5LkQ==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alex Shi <alexs@kernel.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Andreas Larsson <andreas@gaisler.com>,
	Borislav Petkov <bp@alien8.de>,
	Brian Cain <bcain@kernel.org>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Guo Ren <guoren@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Helge Deller <deller@gmx.de>,
	Huacai Chen <chenhuacai@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Jonathan Corbet <corbet@lwn.net>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Matt Turner <mattst88@gmail.com>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>,
	Michal Simek <monstr@monstr.eu>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Richard Weinberger <richard@nod.at>,
	Russell King <linux@armlinux.org.uk>,
	Stafford Horne <shorne@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Vineet Gupta <vgupta@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	x86@kernel.org,
	linux-alpha@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-csky@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-hexagon@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org,
	linux-mips@vger.kernel.org,
	linux-mm@kvack.org,
	linux-openrisc@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-sh@vger.kernel.org,
	linux-snps-arc@lists.infradead.org,
	linux-um@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	loongarch@lists.linux.dev,
	sparclinux@vger.kernel.org
Subject: [PATCH 25/28] x86: don't reserve hugetlb memory in setup_arch()
Date: Sun, 28 Dec 2025 14:39:55 +0200
Message-ID: <20251228124001.3624742-26-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251228124001.3624742-1-rppt@kernel.org>
References: <20251228124001.3624742-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2AD99100003
X-Stat-Signature: hhske9ikfej7xsxg66cfsee8rxt7p5od
X-HE-Tag: 1766925974-727742
X-HE-Meta: U2FsdGVkX1+0HsV46uB7fsnHPPb+jOCTJKCx/fFJobviep7GNStt8esvVxTFzCsUU7qdgxhbLAJLhON98RXDdPbkmozaH7DuTwri/FAJ40RQu4i7uWRav2jQmj5fdWjfC2QqtqyovqwCrGyRkMLujdXfXysqropc0b7tq5eFsb8SrvxwULP3acAF8YcHeQnKQYuaclBQ/tsENLsYMq8PHr3n+DUqCMMglO1Qi79spIc3Wa8GKQ5D7H1TB7IJYAs+r3XVGmBUndQ28onYZWpirTRXKHhdUJM39jmhI5qR7o8Ybj0m2x6v0mgpW+Z1nr3T52uvR4rJCWi688X0XYqdI92MPRP6tJ02EudPz3czz+5NyJ+W9oydgWm4le/9f5OTTOdmOQXv8XJeKDsxXe0ykCS1t9JTyFPfHXqU+1K1ESXkFVEGSwnIsuro21KAIX7bUXAegfTlxPHQQx1H6Ed8Fqou7dGu+6y1XXB5qRZFepfIXByPgfEvyYx2HDBVe2z4UiMvTr3DpDiBPp16cRmQMIFgkRaWgHMatbrXbzezjgbqGv4J5BtXeCxrhSbHn1vEsBZkCgwSHlN4KTFtt4bLgqBwqo8c/UAS3SwJl43XnEgFmzM/UMNBJvOdIwJOdLTq6q+akqq6dh7YaSDbmB5+ajKfoV76L+n19M2j0jBkGiiQCu0/F73iswuQqO5hJSGK3Uwy15UMKZxFGKJJm63LwXXQTpeU8lLVViNXkdi6GZq1uf8UTZPk2x4d3VO5mL6EHMIMzHyfPNbS8nblNuP/dd949bAJ/n6qxi4oQ7/9ZfV/YoLsb7iC6D9QCKiNyghcRlzjrqwmoeoBMI2P2H3rZFrshgDS8lN2/qE1jcN4Rh8iCDZe7aKqPnwRIAy05MWKONyI1R8aGShjI77KvcMJ/LgWm5Mcm7gO/eZEYJZHOIcWIXH2kGvq2C7Rz3CyOiNVp99rOZ5J6zT/skmZvz5
 XZYJN3eP
 1iwZ6oQSlAWvaTkrsmkt1krS5NLfY91fOEcTtjCAa2JSun9t9UnUqPXARLfabr+H6W0j2tZlSZM+irFV3Yhn+7YTMA85qVlYu4qsuYFISBeTvrF2Jb98V9vICd8yqF5H/x9vM+JTl6IN9lFN//sZiwwkjaMrYRglRY0MaVv2B+qbqUyX5TtvIuaq7l68wbvE73+Ha273LMhrs8GjRRo0v2S1OluEWPCn32j0q8MnwxujxJmscDCSjUu/hMnshlLEV6qw6mS5zTsrejurQ5l0jg93NbQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Commit 665eaf313314 ("x86/setup: call hugetlb_bootmem_alloc early")
added an early call to hugetlb_bootmem_alloc() to setup_arch() to allow
HVO style pre-initialization of vmemmap on x86.

With the ordering of hugetlb reservation vs memory map initiaization
sorted out in core MM this no longer needs to be an architecture specific
quirk.

Drop the call to hugetlb_bootmem_alloc() from x86::setup_arch().

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/x86/kernel/setup.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 1b2edd07a3e1..e2318fa9b1bb 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1191,7 +1191,6 @@ void __init setup_arch(char **cmdline_p)
 
 	if (boot_cpu_has(X86_FEATURE_GBPAGES)) {
 		hugetlb_cma_reserve(PUD_SHIFT - PAGE_SHIFT);
-		hugetlb_bootmem_alloc();
 	}
 
 	/*
-- 
2.51.0


