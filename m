Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51450FEFB56
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 15:14:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEBF76B0089; Fri, 27 Feb 2026 10:14:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABFDE6B008A; Fri, 27 Feb 2026 10:14:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 997F96B008C; Fri, 27 Feb 2026 10:14:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 81F136B0089
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 10:14:48 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 20788160748
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:14:48 +0000 (UTC)
X-FDA: 84490583856.06.5E124EC
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf17.hostedemail.com (Postfix) with ESMTP id A9EEB40006
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:14:45 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KGOsO2xl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XGo0ZI5s;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KGOsO2xl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XGo0ZI5s;
	spf=pass (imf17.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772205286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xAMGvNmWWeOUWrlpPVGbaYyjorfoWBrXuzOEHd95yzU=;
	b=WCejsvKKKvNOu3RvSQxeHFJoYostx9GChGjY+9r7Vh4+rLTbhJZ6mINxORQnHnLbjDvHae
	FSWnReXSG9WxzyMe27hMbE7P8UWNaKm9sXPeccmrKl2Yf4Ki/i4XMLxP/du0Ce5lF9NdcY
	uV19CcqPYN9V2fD2drXQ0vXKwh78sDw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772205286; a=rsa-sha256;
	cv=none;
	b=Rfetwhxs5NbREmqry5dlae4Irq+IDG7WjR+gUs1xMKBgMCJmMCi6FHAxvdkeoI0/how+rF
	QQYOAPpEyQHiyVEYxg/wQER9YZISVJRdZSVP2lEypAanap/8V0XLS7DzBqdQGhU3eRuksB
	0BOL7WI02q/2ge21Ry8oyj47597vJZw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KGOsO2xl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XGo0ZI5s;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KGOsO2xl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XGo0ZI5s;
	spf=pass (imf17.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 28EC64E8FE;
	Fri, 27 Feb 2026 15:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772205284; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xAMGvNmWWeOUWrlpPVGbaYyjorfoWBrXuzOEHd95yzU=;
	b=KGOsO2xleHoPus27Y6Ek1ayBAgbsPByIHYStimBLio2ET2VRaKaAMbpD+3lbbEgLxgpaLQ
	rDuM9X3O5+laNfxDbsFh4dp2Q0Nb+3YfHsqRaikWExEP/Mce9jmgcjn98m37Fy/fVXk/jR
	FZTDLzEz3YPJ7E3JQnM8na3mJ1AOD6s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772205284;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xAMGvNmWWeOUWrlpPVGbaYyjorfoWBrXuzOEHd95yzU=;
	b=XGo0ZI5slqI2tjMLFZ/Wnev+M7Y3Q1kSMCz81M1kuEb53HEbjts5xw+hxTUDFmXpikLuER
	hjJuPfdnYXEQbCCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772205284; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xAMGvNmWWeOUWrlpPVGbaYyjorfoWBrXuzOEHd95yzU=;
	b=KGOsO2xleHoPus27Y6Ek1ayBAgbsPByIHYStimBLio2ET2VRaKaAMbpD+3lbbEgLxgpaLQ
	rDuM9X3O5+laNfxDbsFh4dp2Q0Nb+3YfHsqRaikWExEP/Mce9jmgcjn98m37Fy/fVXk/jR
	FZTDLzEz3YPJ7E3JQnM8na3mJ1AOD6s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772205284;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xAMGvNmWWeOUWrlpPVGbaYyjorfoWBrXuzOEHd95yzU=;
	b=XGo0ZI5slqI2tjMLFZ/Wnev+M7Y3Q1kSMCz81M1kuEb53HEbjts5xw+hxTUDFmXpikLuER
	hjJuPfdnYXEQbCCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9B9643EA69;
	Fri, 27 Feb 2026 15:14:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UdmtJeO0oWn4GgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 27 Feb 2026 15:14:43 +0000
Message-ID: <b9527ed4-7a5c-42e9-8814-b276b3741f63@suse.cz>
Date: Fri, 27 Feb 2026 16:14:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 23/29] arch, mm: consolidate initialization of nodes,
 zones and memory map
Content-Language: en-US
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Alex Shi <alexs@kernel.org>, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>, Borislav Petkov <bp@alien8.de>,
 Brian Cain <bcain@kernel.org>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 "David S. Miller" <davem@davemloft.net>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@kernel.org>, Dinh Nguyen <dinguyen@kernel.org>,
 Geert Uytterhoeven <geert@linux-m68k.org>, Guo Ren <guoren@kernel.org>,
 Heiko Carstens <hca@linux.ibm.com>, Helge Deller <deller@gmx.de>,
 Huacai Chen <chenhuacai@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 Jonathan Corbet <corbet@lwn.net>, Klara Modin <klarasmodin@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Magnus Lindholm <linmag7@gmail.com>, Matt Turner <mattst88@gmail.com>,
 Max Filippov <jcmvbkbc@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Michal Hocko <mhocko@suse.com>, Michal Simek <monstr@monstr.eu>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Palmer Dabbelt <palmer@dabbelt.com>, Pratyush Yadav <pratyush@kernel.org>,
 Richard Weinberger <richard@nod.at>, Ritesh Harjani <ritesh.list@gmail.com>,
 Russell King <linux@armlinux.org.uk>, Stafford Horne <shorne@gmail.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Thomas Gleixner <tglx@linutronix.de>, Vasily Gorbik <gor@linux.ibm.com>,
 Vineet Gupta <vgupta@kernel.org>, Will Deacon <will@kernel.org>,
 x86@kernel.org, linux-alpha@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-csky@vger.kernel.org,
 linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-hexagon@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org,
 linux-mm@kvack.org, linux-openrisc@vger.kernel.org,
 linux-parisc@vger.kernel.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
 linux-snps-arc@lists.infradead.org, linux-um@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev,
 sparclinux@vger.kernel.org
References: <20260111082105.290734-1-rppt@kernel.org>
 <20260111082105.290734-24-rppt@kernel.org>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20260111082105.290734-24-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: A9EEB40006
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: j8kic7gjdjo5zns8bbtzn8dua16jkdru
X-HE-Tag: 1772205285-39642
X-HE-Meta: U2FsdGVkX18t0lOhCa19xUJJ/7kp4plKpkIHBuvCfH8M66qBVo2mBJ/8i+ZqZSA2nwtiaeCIAe8wb5q+InSmoYdecLdvjsMhUGqvK8NzwdamEUl4MRlNo92v1N1ZTN4spX8Hvqm6IYVfkXu6sStQ8/tBj74ZjJsMtCxCV1h+IAJ91jw273s7ILoslfGQwPTPxOW9z5xnU4S0wVcuYmryjS44lgV1pmZCATczQhmsYr0HupT6qZ+NgtNIAuVqhxlvi96hx7AvEbaEroIYKj33JbXRrLZeY6ynVuaAuePcVVWZMAHXDJwvRGL53gPdIJEkkfgsVE48rQKLy/HlSZ1ZZ1F0pKcAZ7+1r4Z5Pr4ZpAb++gnF1Lr3rHZ3P15613ZLkAV+7/XSIcfzP4jcxOPIRBzg9x8hb7R+ANlgq6e0maO48UEbtjjqok+Zl+ljDE/hoSlrypTtPe57N8T2beMfgBXqUF7PV9V8kcJpZLJg/aYwWc5la8HIge9K+Fe0lg6GfqsGgSXdUqIhE12/cWkR5zrzdTtzR1XUaIVhASFt0uzh4mZs6dkR5lGgQMrKLxWlmBSMRFBLgVqc7fgNFtnTwGsNDySpiUDyUtblC7VNIT/W3ioYmDyOTHa+262j7BuRzjbj+aje/FYN7PJpceWszDTWvUVFhz3lGg0K1oKmQrxu1lRHBX8tfWTkrysEIxJNNIV9gs42bj+GylpYSySfzqCxIzTiZb/T8QUcRoK7dtVHg6bCebDdMxyBr/TPYRRgyrPIJx2Cu8cF4huwBNzeSjhJn1yZpiNDZS3d61IyC19KJ5mhG8xb774VPdzcbUqg469D+49MXzlsBmV9MwjZDIf0nDvDNnUdi4k4x/NgxUEls+OwFRme6v4+dqmV1Zegcjhz0zNC7P/c1OlOujhOtEQHJKoU0dvn9AzmMEyrcLoqZYEPc8LJsuj0gYKzH235CQiuXdbtc15DUZd/qaa
 IodjooJz
 O6hk62L6cqXvQaKc/HdqjlxowiTbRhxTXRqJoti5Am0hlqTxF+ZtpnRTCOe0pEO3kM3mIGIhBe70qcV9bmuWQWlOSgF/qZ5Gf+0Otu4ryOd5BfGOylmW2wnJf9t60GJFPHoxryI8FWYsaZyKsG0kbtuLrcD2dwpmlASdDzsbPUhmlU6H9US/WtwmsxvPxBsuuC7n+Vvm/+ct94zlhThHJWR7ydGj0gdaZu0M4ukaaExXKarNjRRwBNCj9Uq/sJWtyTHuBbiioJBsqcvXMIKWmK9sZSNEfX8/kWt1vjNjslQ0Rs9ShRmsXnRIOcsMqzVstMYO5zS2Q8xIjwD66PbmapzfymFjSXmxExYozJeVRErAraKyNuZU+gGrqpUI8Xy7nPJSRqP0sed6FdAxuFFe2URi4bm9ds/XdGrQB9C2Ptt19z9pwVwv4VQnTvkVOzfUHZLfn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/11/26 09:20, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> To initialize node, zone and memory map data structures every architecture
> calls free_area_init() during setup_arch() and passes it an array of zone
> limits.
> 
> Beside code duplication it creates "interesting" ordering cases between
> allocation and initialization of hugetlb and the memory map. Some
> architectures allocate hugetlb pages very early in setup_arch() in certain
> cases, some only create hugetlb CMA areas in setup_arch() and sometimes
> hugetlb allocations happen mm_core_init().
> 
> With arch_zone_limits_init() helper available now on all architectures it
> is no longer necessary to call free_area_init() from architecture setup
> code. Rather core MM initialization can call arch_zone_limits_init() in a
> single place.
> 
> This allows to unify ordering of hugetlb vs memory map allocation and
> initialization.
> 
> Remove the call to free_area_init() from architecture specific code and
> place it in a new mm_core_init_early() function that is called immediately
> after setup_arch().
> 
> After this refactoring it is possible to consolidate hugetlb allocations
> and eliminate differences in ordering of hugetlb and memory map
> initialization among different architectures.
> 
> As the first step of this consolidation move hugetlb_bootmem_alloc() to
> mm_core_early_init().
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
I've bisected a problem with virtme-ng testing a NUMA memoryless
node setup (on x86_64) to this patch (commit d49004c5f0c1).

It's executed like this, where node 0 has memory and node 1 only cpus:

vng -vr . -p 8 -m 4G --numa 4G,cpus=0-3 --numa 0,cpus=4-7

This fails to boot due to:

[    0.095894] BUG: unable to handle page fault for address: 0000000000004620
[    0.097196] #PF: supervisor read access in kernel mode
[    0.098180] #PF: error_code(0x0000) - not-present page
[    0.099155] PGD 0 P4D 0 
[    0.099641] Oops: Oops: 0000 [#1] SMP NOPTI
[    0.100437] CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 6.19.0-rc6-00152-gf206359553c9 #53 PREEMPT 
[    0.102201] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.17.0-2-g4f253b9b-prebuilt.qemu.org 04/01/2014
[    0.104313] RIP: 0010:mm_core_init_early+0x263/0x900
[    0.105271] Code: 93 ff 72 09 8b 7c 24 30 e8 da 82 00 00 48 63 44 24 30 45 31 db 4c 8b 24 c5 a0 7b 1d 9a 48 89 c3 4c 89 5c 24 50 4c 89 5c 24 58 <41> 83 bc 24 20 46 00 00 00 75 0b 41 83 bc 24 14 47 00 00 00 74 04
[    0.108863] RSP: 0000:ffffffff99403e38 EFLAGS: 00010046
[    0.109861] RAX: 0000000000000001 RBX: 0000000000000001 RCX: 0000000000000001
[    0.111223] RDX: 0000000000000040 RSI: 0000000000100000 RDI: ffff89597fffae00
[    0.112577] RBP: 0000000000000005 R08: 0000000000000000 R09: ffff89597fffa200
[    0.113924] R10: 80000000ffffe000 R11: 0000000000000000 R12: 0000000000000000
[    0.115294] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[    0.116656] FS:  0000000000000000(0000) GS:0000000000000000(0000) knlGS:0000000000000000
[    0.118193] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.119283] CR2: 0000000000004620 CR3: 0000000060048000 CR4: 00000000000000b0
[    0.120645] Call Trace:
[    0.121122]  <TASK>
[    0.121521]  start_kernel+0x5d/0x780
[    0.122206]  x86_64_start_reservations+0x24/0x30
[    0.123079]  x86_64_start_kernel+0xd1/0xe0
[    0.123860]  common_startup_64+0x12c/0x138
[    0.124641]  </TASK>
[    0.125061] Modules linked in:
[    0.125646] CR2: 0000000000004620
[    0.126279] ---[ end trace 0000000000000000 ]---
[    0.127162] RIP: 0010:mm_core_init_early+0x263/0x900
[    0.128106] Code: 93 ff 72 09 8b 7c 24 30 e8 da 82 00 00 48 63 44 24 30 45 31 db 4c 8b 24 c5 a0 7b 1d 9a 48 89 c3 4c 89 5c 24 50 4c 89 5c 24 58 <41> 83 bc 24 20 46 00 00 00 75 0b 41 83 bc 24 14 47 00 00 00 74 04
[    0.131676] RSP: 0000:ffffffff99403e38 EFLAGS: 00010046
[    0.132684] RAX: 0000000000000001 RBX: 0000000000000001 RCX: 0000000000000001
[    0.134033] RDX: 0000000000000040 RSI: 0000000000100000 RDI: ffff89597fffae00
[    0.135412] RBP: 0000000000000005 R08: 0000000000000000 R09: ffff89597fffa200
[    0.136763] R10: 80000000ffffe000 R11: 0000000000000000 R12: 0000000000000000
[    0.138112] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[    0.139487] FS:  0000000000000000(0000) GS:0000000000000000(0000) knlGS:0000000000000000
[    0.141014] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.142094] CR2: 0000000000004620 CR3: 0000000060048000 CR4: 00000000000000b0
[    0.143448] Kernel panic - not syncing: Attempted to kill the idle task!
[    0.144833] ---[ end Kernel panic - not syncing: Attempted to kill the idle task! ]---

> ./scripts/faddr2line vmlinux mm_core_init_early+0x263/0x900
mm_core_init_early+0x263/0x900:
free_area_init_node at mm/mm_init.c:1721
(inlined by) free_area_init at mm/mm_init.c:1902
(inlined by) mm_core_init_early at mm/mm_init.c:2681

It crashes at WARN_ON(pgdat->nr_zones || pgdat->kswapd_highest_zoneidx);
because pgdat is NULL.

With some debug printk's I've figured out that in free_area_init()
we have:

                if (!node_online(nid))
                        alloc_offline_node_data(nid);
             
                pgdat = NODE_DATA(nid);
                free_area_init_node(nid);


But node_online() is true so this allocation doesn't happen, and
pgdat remains NULL.

And node_online() becomes true in init_cpu_to_node():

                if (!node_online(node))
                        node_set_online(node);

But without having a pgdat allocated.

I was able to workaround this by changing the code in free_area_init() to

               if (!node_online(nid) || !NODE_DATA(nid))
                        alloc_offline_node_data(nid);

But I don't have the bigger picture, and also didn't check yet what exactly
about this patch results in the failure. Probably ordering of various related 
actions. Thoughts?

