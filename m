Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04588E9410B
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 07:03:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69AB66B00A5; Fri,  2 Jan 2026 02:03:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 665466B00A7; Fri,  2 Jan 2026 02:03:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55E3F6B00A8; Fri,  2 Jan 2026 02:03:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 44D6D6B00A5
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 02:03:20 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C3F9713A9F2
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 07:03:19 +0000 (UTC)
X-FDA: 84286132518.28.40EE50F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 075BB4000F
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 07:03:17 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k51lji2Q;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767337398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5tzZHLZRN3jOrlP1D8SLHHdCfMJ27h3Izx64Fi3A5HE=;
	b=UterrlCD9IEMZZbnCh7vKojVeLAxj6fAOKYw7qcOVXkVig03z3dXijWXwnwrVqMqXps82r
	gsCVCcPRL7/qhwFrO1j28RC5KXdexgJkN1bu98XKtoN96bjJJ2+0AEQnU/QkO9i/6a/NM4
	istgxlq4gqHnn2j5RRcYoa1LTXDhFqI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k51lji2Q;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767337398; a=rsa-sha256;
	cv=none;
	b=7Vou5V+TTCFw4AsrdL/5lO59HtFeaKJ+Btjp2WspgaPvdAsDJzM78qQXBUnQ5VRM/c4O2J
	5ShzSO5o8LBZqWXXuXhAoJO8FalgEaWRxYveZtSmSztCdOtebFVGKExt+MBCXnSIyEh9W+
	+9Z2slBz8ybdOMu23yUJ/TtPMF6BhGE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2A680417BC;
	Fri,  2 Jan 2026 07:03:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F011C116B1;
	Fri,  2 Jan 2026 07:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767337397;
	bh=YC7hFXptZV2vdW9aMAEwYEJyXUoPJivVkcdf9qZf+do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k51lji2QjYJ39GPdkQBxYH+cBYmigCLRC6NXgwAJR4J4z6dqk9RLhhr71fZ364uig
	 95YPjiKoiJ9Q6MkYYIKe0Qe0QI0Q5JlHh5ptHasX77hFqEm/pKTPKOraFV5ZA+mJmE
	 VsTs1ZKh700Nzxb09LXehI09AlWKK21/LsQEoEzZ+89LwDiKkP75kiw+OUFA4OW4fa
	 /cMN3ckEQi/Oo+ChT9dXkbKd+RCJQNoCqBgdl7wjNL21IyhqWFZ+3N1lqclWLpMUbO
	 OxQca5uMAGW+iitFju6jlXFvXTR5zMYZkRz+pWQpFronMxZ6auLfBcsEdOHCLo+amb
	 wv9wz8MM48wmQ==
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
Subject: [PATCH v2 12/28] openrisc: introduce arch_zone_limits_init()
Date: Fri,  2 Jan 2026 08:59:48 +0200
Message-ID: <20260102070005.65328-13-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260102070005.65328-1-rppt@kernel.org>
References: <20260102070005.65328-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: h1s9pyzwdyyxhq655e4zwgxehbgwfz4y
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 075BB4000F
X-HE-Tag: 1767337397-634444
X-HE-Meta: U2FsdGVkX1/2q+U0ghh6nifQ7g5O9x5Lq1VU17dZX6eUgly2Tj5L+yxKFKPhMWCYP5N0E1u+/aqUemh6Hq6l7DMJwBl2gnC2qRTlfJwcbP+hyeLu2bWY84ofPDwCWtEKAGrDDonvTq9PbFKZNvux5PfFZAiRgQqd38ndnI7TYkV5KdTNRCo2BmAp2YMYFokVNfcG1+hnie9LZSrA9UjVRxwd9rGbKIWVb629L297OEOW7RYAicfP5LcOaRl7S9QLxX6HdL1YgRtGmYnICEelA9IREkeYrZIBNCoI0LriwHROsnRThKpk/Gk6/gAknDPT34UqefuSBbm0NyCCmdaIvcpnkXrmf6bQRro0BumdhFXeqdpGcnlCOr8CT798k9yvurz/7QUTW7XhnvjBQ3Jm+EKfCAnFZI8b2unKFYHOEGOgk61YWx48nb0vU6EP7YZrZm16G1pvJwT3GqGgkoosBmqJqV9y22LYGN2w06WS+MT8kxC/AnvkUHu1Dkl/nD43pIbHpqATNktlSxbjsiABvXMz+y9EOzJ3XsDciZWYRcRGIuYeApDKD0puJLJVcELHcb/BP2sSkDbUse6HKSsVvZhvvfWWvqLYW4UfJNmZmhTQYF4nOyj8jP88icLi06fFQvDuxh2EyNXFXnXwjkRNqMB1d6D+qtjAYcXURAMC9S2soW5MuprrduwOzbQQJol3ZN5dUjgDHanGPVTlzmLDjgqiSR11gHvWkTMAB2XaFQi444TW8lxDjuhvssVtUcv8U2apNqB2SGS0BY2gdKHtBg2MN6lOcvFFaL1Y7buyeHle3U5kYWmrWQsrX/z8z370vZwC2O2uD3ujaDQBa0Kujn2vcCQ2+NM28g8ioNzf67zTcsR11QsF/eAGZ8Nfp2bcuWUor8ZfrCFbu6EM6Ew6XGDHXRJfoBr2weEymoJQzvTCt5YLPupUrC2Z+GjcUCqSBGvOfXsyc2wQUQ9KpwX
 XBfuTvx0
 BjLsLyP/J5jKiVPOWyIgtigtX6IyGCwPmF9hKvIMPFQJhOBhvEz27lxHOXI7oewd8Dy15BnUgC/TNdBB7ceZ0RBijO5GoDncy9j1B6Q+IizKBCgc5/jDXdUTc7NvMW5BrfAPcDuBOxal+1B30uqMgKLVDngBiL4vRQ48FZDYasvRsPA6yDayxhJ7me+5NQ0v826i2T1+JA3jbG9DqgIJVXNT/37E/CIz9Gbq49AjnTAurlb1Y7WZ5dUsPKwSRI3F9d8/cHFAEYzl0u+q8vwBxAREcMjoqUIg3kS95
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Move calculations of zone limits to a dedicated arch_zone_limits_init()
function.

Later MM core will use this function as an architecture specific callback
during nodes and zones initialization and thus there won't be a need to
call free_area_init() from every architecture.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/openrisc/mm/init.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/openrisc/mm/init.c b/arch/openrisc/mm/init.c
index 9382d9a0ec78..67de93e7a685 100644
--- a/arch/openrisc/mm/init.c
+++ b/arch/openrisc/mm/init.c
@@ -39,15 +39,19 @@
 
 int mem_init_done;
 
-static void __init zone_sizes_init(void)
+void __init arch_zone_limits_init(unsigned long *max_zone_pfns)
 {
-	unsigned long max_zone_pfn[MAX_NR_ZONES] = { 0 };
-
 	/*
 	 * We use only ZONE_NORMAL
 	 */
-	max_zone_pfn[ZONE_NORMAL] = max_low_pfn;
+	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
+}
+
+static void __init zone_sizes_init(void)
+{
+	unsigned long max_zone_pfn[MAX_NR_ZONES] = { 0 };
 
+	arch_zone_limits_init(max_zone_pfn);
 	free_area_init(max_zone_pfn);
 }
 
-- 
2.51.0


