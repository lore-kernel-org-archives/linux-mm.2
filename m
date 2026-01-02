Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57A27EEB57A
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 07:05:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCD766B00B5; Fri,  2 Jan 2026 02:05:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B77186B00B7; Fri,  2 Jan 2026 02:05:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A70876B00B8; Fri,  2 Jan 2026 02:05:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 96A206B00B5
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 02:05:29 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5460B8B632
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 07:05:29 +0000 (UTC)
X-FDA: 84286137978.02.4950566
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9F18E4000E
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 07:05:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aVMy1uEj;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767337527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1chzHxsrADOvWvHnGxP4KUnDWT2YzEh4P+Cw7lJ2EsI=;
	b=8Kal3HyEnLGbUcZqhXhZkCwHfIxLPzKZLGQ9mLpl7k6hw0ysKzsjRiDfXwDhk24d72ueGF
	kLWL1k0e5Z13QpxY3s077mFaPu1NosQzgKok+oxOcu5Tb363SzYVAX3IETzEBXgqFkok11
	oUfTqtlvh39Vl5E7v8fEZExJT/Qw9S0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aVMy1uEj;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767337527; a=rsa-sha256;
	cv=none;
	b=c+eA6gqWtFUJ8A/LeG/UhopyEVm9XfiYU1vks+hmG5+j0v4o2p7ISh/wBpRJuv6ndpQGph
	xViQ0+FC/mXoS2lU+rsg8UixlUcbfYSG6b3ZPyZAK5V99dtgEeUAkHWNpBkdqIFjcoVb0/
	AnTeqEIML9PtJOV7eoy9hUeu7fxnjJg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ADAAB436EC;
	Fri,  2 Jan 2026 07:05:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A822AC19421;
	Fri,  2 Jan 2026 07:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767337526;
	bh=RfrVgNIj9rxp9R6SGMWNq/5X+PJ8wzbzZyqbje0LIeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aVMy1uEjz+i8JVR5vvetsdLlgetPkDBi4pcNoZ4vjSKDBc19eAiwfNmFLk+7mga3L
	 CoRj28PGPQFLtYhjpAFGOpcJutt4IEAphYnmmrXUanPJV/sEjuRaYp5ErdlMYFMwBa
	 y7Tx3dNUc/RzrtMBd/C++WHUWIgC4F/tyXDOwS85cAPJvO+XvNSexJlAVbEAIac8yK
	 7B8AnG2S4pCOhihUnC0FMc3yT8kq9pvWxyPULUe8cP34d112OYpiJ6uofrGOoed7ZQ
	 J3GRwa/R04BfG9D1qMTYLWoomnB7hJ4FZjufi3DB/KiokHvaSbus/icytAHD/NLK2p
	 CLxFTDSXhTUeA==
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
Subject: [PATCH v2 21/28] xtensa: introduce arch_zone_limits_init()
Date: Fri,  2 Jan 2026 08:59:57 +0200
Message-ID: <20260102070005.65328-22-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260102070005.65328-1-rppt@kernel.org>
References: <20260102070005.65328-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Stat-Signature: gcz7fcugzgwkydyjqa95isxcpeny6dih
X-Rspam-User: 
X-Rspamd-Queue-Id: 9F18E4000E
X-HE-Tag: 1767337527-684292
X-HE-Meta: U2FsdGVkX18n29XUJSKMmaEGGXA+lFaOIFQoIWZK1tGFCyeot8pEZKLk7kL2njfxXHlEwIuqoW8enrxsHNCTctsh1goVxfdy8/JRGShuXnjT27DFYEPPKfX5IObvNTdZSH8OdT/TmDrRKYWVaZidSBzt19Bmp/TBP3ggUymw5T7acLFdZyw3AvumfkrilQQOVURWF13FT6ywN6d7j8vcO0rwrNliqf+31jKzX98LFjdnkuLdlhEjOv+LgRRnzby/E7sJfBPIes8cFU+4qOmpupqNZqicefUBy1kciCECHgSbEAJXbZwA3KP2zgwx8NKOsgGDeL3u053HfyOC3z7cwC+gDjJcb2VdOfTZcE8GnVYivBwc8N5yBjEgYHkW/dIXGAixCli0wGQlBM6bnnYlRCE9v11q59E+uI6T+UpFcGzhDZfN1xlRLgpZXal75SpR30y5XEkauwvOJ52D3yzGecncLRkt93mLjUYuyHbklXNj4F4grEeWQFk9FlBMMht5tdmjQIGWEevoNPbPbox+Bg9ABG1AIHXO8eH/e+8IbnNaoyvCvP72RPmqLPyGEGU5rhjh2XhuokVSV93fQA/cJSaYRob2oS1UJXzajgP4IJwkkqClz5F3DcbfwwQVdCG+ufr5SfE9x4CAKQE3L3djGNwDbSEmTzytfSdwqg0Z9jVN6W2Qw+F4dJVNyUzSzJa/Z8qQGMzGmAZlodJ/t+lZk7ccEl7wj/4ujjPB/4m1J7mKJWE2KTiAr0Ka5bpZXqWFDyc9Z99lcJ3R+zcFfiw+MPP5vmkfRkwsyKXMw/d81DcbegriA/qmA40wiI8BO7eBucEuBh3NRuBW706qDC/FeWYkeQ1omK7n1ZBJywu7MX382bbn/8yZ5x/20fyfpYMD3HJyOGtqN5zmrcHZG7ZlUZophzJk2ACfRUgoACnarOliCcjcedPaspt+HCw+96fhqWnqPlFAMRADWLHsArQ
 BThrw53b
 SqhooTmyuNd4HmkSNWfZnZnTXUkXhgdHZsi7AEg4JsFNAyUyIht27g/sQjPo2ptvXbfho0I0vxlod7pssAyCVVu96WTMR3dBaQmrmMnpPlHMrMDifb8UW7Qnd9s1s9nWihERwxZ+SWXBUj9GW54zogpcS05VJHfgi7OFPfx7IFOVbczka0A2sgdYSrmteHg/ru7MY2iLhmAcD1ihXU/iR64PLWrFb/LpHSF47yKPElnTLmODo3+Y7uvq7APjUW4ujbFrtkK5JQcPGZdXQ+WVcva+Gzz1iamesI26v
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
 arch/xtensa/mm/init.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/xtensa/mm/init.c b/arch/xtensa/mm/init.c
index cc52733a0649..60299f359a3c 100644
--- a/arch/xtensa/mm/init.c
+++ b/arch/xtensa/mm/init.c
@@ -116,15 +116,19 @@ static void __init print_vm_layout(void)
 		(unsigned long)(__bss_stop - __bss_start) >> 10);
 }
 
-void __init zones_init(void)
+void __init arch_zone_limits_init(unsigned long *max_zone_pfns)
 {
-	/* All pages are DMA-able, so we put them all in the DMA zone. */
-	unsigned long max_zone_pfn[MAX_NR_ZONES] = {
-		[ZONE_NORMAL] = max_low_pfn,
+	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
 #ifdef CONFIG_HIGHMEM
-		[ZONE_HIGHMEM] = max_pfn,
+	max_zone_pfns[ZONE_HIGHMEM] = max_pfn;
 #endif
-	};
+}
+
+void __init zones_init(void)
+{
+	unsigned long max_zone_pfn[MAX_NR_ZONES] = { 0, };
+
+	arch_zone_limits_init(max_zone_pfn);
 	free_area_init(max_zone_pfn);
 	print_vm_layout();
 }
-- 
2.51.0


