Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05AFBD2502E
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 08:26:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C4316B00B6; Sun, 11 Jan 2026 03:26:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69BCF6B00B7; Sun, 11 Jan 2026 03:26:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A7EE6B00B8; Sun, 11 Jan 2026 03:26:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 490866B00B6
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 03:26:29 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E5220B830D
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 08:26:28 +0000 (UTC)
X-FDA: 84319001256.09.8C6DB69
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4137940002
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 08:26:27 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cE1cYxN4;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768119987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EUP8A0oU4o/USGU4JF7iSIOLVJ/2u6llFeNZ4HBfxOs=;
	b=Yhi/i/GVwDSWYy0pe6cTd2wp8cJbePxvNgUN7QN78RVZDh0nH4WagrXa2ES6a38qiIDzyP
	7p6xxnXX0NIBQD2iHwh1p5apA/w9hu9xJN0S+zVV9iyZhNjy78vtqDxDrrt3C0Gg+eSNHV
	Bmup7Rzer+OKz8tf9D4snKdeam6nM4g=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cE1cYxN4;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768119987; a=rsa-sha256;
	cv=none;
	b=xc6mX40m6kkARti4HJH41v0JtUceZrlTlGMypB+JLF6w2kxWbORc8o5acBj7smHCwynJae
	umWaBtayJ8wupDBpfwC50Paq7go6fnUJUkdVXAx44wfuiabExTR9MqEYTk/h9RyG+TcgFA
	16jVWvx5VHdw9LJeN+8Kos5cYHp7tZQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5B11F429FA;
	Sun, 11 Jan 2026 08:26:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9902BC16AAE;
	Sun, 11 Jan 2026 08:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768119986;
	bh=2fA0ShJu41IpFxgmfkKiNARLhjMIlJQdtqcPZZQwJv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cE1cYxN4XiRu8w05462pUh7mJ7YsVKuFjZN060SdsKaL4HwvgafRghrCyOjRFhfks
	 goIC3meGsc011NdlQvuX6sIIgoPYYnguJE4V0ezIriNOLb6UY7TUl/H5KBLc8jHspZ
	 bqpyaiW+yhS8K0JZpP7OoWNV42LbmkHolciEGY3Q8P86DZkjSJMAXJFu4snmxoEaeq
	 r3tJN1kJLVtUQz/4sqhj/7RV76IDG6QOBqIhTOn9+KWKkfscjeNSTO2ALgfmelbFhD
	 UIdusobMPUaMKF4j5L6OSMUErDZGo+V2brMOeeP2O1yqFNvH5sQW4orMNneYRJx38a
	 Qg78VBIC985zA==
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
	Klara Modin <klarasmodin@gmail.com>,
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
	Ritesh Harjani <ritesh.list@gmail.com>,
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
Subject: [PATCH v3 20/29] um: introduce arch_zone_limits_init()
Date: Sun, 11 Jan 2026 10:20:54 +0200
Message-ID: <20260111082105.290734-21-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260111082105.290734-1-rppt@kernel.org>
References: <20260111082105.290734-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4137940002
X-Stat-Signature: zgc3q79aao8jn76jtamcc6jofwg5jdp1
X-HE-Tag: 1768119987-801264
X-HE-Meta: U2FsdGVkX18HoELuFITEHmh52WH+mCYXYlhepjdmSQ5E0KydE1pf41TsSQURVLSmi+EkDNTnNyX5wwfnm7knMGKTZUa9aHaFevLLP0ApjNq4v2ThuJ94UGhZpyHSOMyzPkS1W2Hcjro1Rr5texzgcWOOir0h4FIdfsZ3uW3brPCCTRJ8eoIJYsNXCUEiUOMGBCwKA03FSVBynq/psJLLUs8fE54ygkdit4hEOCdz8NSlLOLNDKS2ifPnHXIAFcydTL6M7T3q21SM1Fhno7swhvoHHQiraoF8TR4P0l6NS83lwZuD9wk3L2BZ9K8YP3cZxBVyXCR20zAZ2SrByoaUv0a7NCjZHTT9lvIGEXBm2T4OWnBX20Q5O30S56hXQhGm3/FTUJ8cPRaOWYO4l8Eyh6RkQqHmXp8DWtALt/ZGSGieO//tthP8VcmTxlATp0Cbcc+PESqxW0arMddo1mvgXawmn2pMGkZobrPBBag8I1FErJ3D00yPb5FwPTjeIg2LIGM+dlZVaI8ldty0MBtymWMELMBKWf9ks8LdDigwR4dbBZsECF0C4a45itzK47D3rjKDqz84aVpNJgZg672C7KRxujfgXXDM/eMkkAQX2qjg1hxTXXHXjoQtwY8yfOo4cxBu1RjWTo2/wPSqElcmCB4GyX8YG6800Fv09shl07jZqeybXR2f1NhnoOIj7V7iTIFzdfiMOxk1KiKHlmzoHVg4GsIEhcYwTUw2GJFFwgXbatm4bF1M7Nc/hw/6bkBC9TqXD/YUqlbnNIPlvZ/S9mCE2sO87LTPh7dtG/AX3vwhH6Uw3W7ZxyG8J7twWEr5o5C1LpOP5/XKydygy3N9bX2RkKDCggrw1J0zbf/pvnS350Ydnj/RK/GQy/MfmaTzZQ1M+Sz026d1MpTupT1zbtuKeI46AY3mq9+VQ7BPqQPByg6dYULRfgVVzXqm2iQC2S4DV0cL1WYPJkL9n+L
 j1LUKxBT
 xdAB44S7Ps0U5dWQZQ0nLRT715XZ+EXhoz7K750uqbQu0iMcK2lH8y7uP9KvJKo3RsJQg/7ALbVl8fGH+9jz73yGWEyU5jzhQKDj0VnL25SIUfo7R5HJR4Yy6kFnPYpOMZL1zfuBeI2QJnd/EFN803AxfDxcFSF/NbUoYmLdh7z6cqAetsJGF2xBm/r2AN4mMSktYPFiMxCwjPmMmuerMBuJ0w92R4q+KlmpKets4VWsi/JIiTbkK0y4eXeQUBob1eQzxxLbFBBx02xMh4ILcAaekUxdvN9w9MTptWVP8b/QlQ+TjxZwIPgTE0/xbP8de+6OWjxFYJGInzbmOrfWU/8CcGPNpLCY1ggdl
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
 arch/um/kernel/mem.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/um/kernel/mem.c b/arch/um/kernel/mem.c
index 39c4a7e21c6f..2ac4e9debedd 100644
--- a/arch/um/kernel/mem.c
+++ b/arch/um/kernel/mem.c
@@ -84,6 +84,11 @@ void __init mem_init(void)
 	kmalloc_ok = 1;
 }
 
+void __init arch_zone_limits_init(unsigned long *max_zone_pfns)
+{
+	max_zone_pfns[ZONE_NORMAL] = high_physmem >> PAGE_SHIFT;
+}
+
 void __init paging_init(void)
 {
 	unsigned long max_zone_pfn[MAX_NR_ZONES] = { 0 };
@@ -94,7 +99,7 @@ void __init paging_init(void)
 		panic("%s: Failed to allocate %lu bytes align=%lx\n",
 		      __func__, PAGE_SIZE, PAGE_SIZE);
 
-	max_zone_pfn[ZONE_NORMAL] = high_physmem >> PAGE_SHIFT;
+	arch_zone_limits_init(max_zone_pfn);
 	free_area_init(max_zone_pfn);
 }
 
-- 
2.51.0


