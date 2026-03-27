Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4066110F285F
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 17:12:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 631026B008C; Fri, 27 Mar 2026 13:12:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 608676B0095; Fri, 27 Mar 2026 13:12:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5453A6B0096; Fri, 27 Mar 2026 13:12:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 44C426B008C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 13:12:34 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EFCB0E17D2
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 17:12:33 +0000 (UTC)
X-FDA: 84592486986.23.B1B3146
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8512180018
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 17:12:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CBBUkAdN;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774631552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g+743C1c9bGbfvP4cQljiRojozWZ33IbKUWDmbpgGVs=;
	b=X+v7WOEh2cG9f9QspYqmd6g6f5zCVQddeijfp4Mpri1qU3fgVWAJvUECPhLgBG2jg1CZe1
	PyOoa+7PPB2bBBLHeWf2RqseZw3o77XyxwZM8CHJEdC6K7koebrkKfqt4NCHQnz/WqXxto
	GhZBn5CIMoxkUrWtLErjHh9ypsFOXaU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CBBUkAdN;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774631552; a=rsa-sha256;
	cv=none;
	b=vBg1WLBpqcToKBLEMPoIWyvZwCa5+B2zNa5XO7ODVDpWfIYbckGW0sxliJ0kTKNdO6MUqk
	PrcKi53jX6+owei9+RThiX+grtBKRfAOEttUa7yTU0wjuQbTMWwrphFtkztTUusDUsjIMo
	IYc8OTswmicgWDt0T7egJoL8yQKDff4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E1D7760127;
	Fri, 27 Mar 2026 17:12:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0883CC19423;
	Fri, 27 Mar 2026 17:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774631551;
	bh=MvMFqhnsZZr06SdVmhQQ8yFBO4J0YHjtEFCesOzEOVg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CBBUkAdNPfmmIltuHE6pZ6GpwC9m1K+SXX9SsGPrXIW3gJCsavgLlBBFhllhQ8YOV
	 tt4v86XDdlFoZfXDWWeQB/kZRnJsC72/2SzZfO03eHu3zwjOw/NRJZJdfe7tPOsj/H
	 xZPsKYg2lEOyHQVDuzvBc3T+oW5ge/Ms1dc/coAeYjdDtxnlJCj3sgd0nOmr6HhLlb
	 ryVmy9CH86EKbBkS5gNJ82lQSGvFhRoc7XumwqORtvLuF6ft5AuU9wHZOeQVY8tmIJ
	 ikfw0WPIJMlejTpAQz8wOen8RRrBNWQTRHTEyw9/Q1dMm1o4NegwxmZRKfaj1AEbCW
	 zcL0eU61oIoEA==
Date: Fri, 27 Mar 2026 20:12:14 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Bert Karwatzki <spasswolf@web.de>
Cc: linux-kernel@vger.kernel.org, Liam.Howlett@oracle.com,
	akpm@linux-foundation.org, andreas@gaisler.com, ardb@kernel.org,
	bp@alien8.de, brauner@kernel.org, catalin.marinas@arm.com,
	chleroy@kernel.org, dave.hansen@linux.intel.com,
	davem@davemloft.net, david@kernel.org, devicetree@vger.kernel.org,
	dvyukov@google.com, elver@google.com, glider@google.com,
	hannes@cmpxchg.org, hpa@zytor.com, ilias.apalodimas@linaro.org,
	iommu@lists.linux.dev, jack@suse.cz, jackmanb@google.com,
	kasan-dev@googlegroups.com, linux-arm-kernel@lists.infradead.org,
	linux-efi@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, lorenzo.stoakes@oracle.com,
	m.szyprowski@samsung.com, maddy@linux.ibm.com, mhiramat@kernel.org,
	mhocko@suse.com, mingo@redhat.com, mpe@ellerman.id.au,
	npiggin@gmail.com, robh@kernel.org, robin.murphy@arm.com,
	saravanak@kernel.org, sparclinux@vger.kernel.org, surenb@google.com,
	tglx@kernel.org, vbabka@kernel.org, viro@zeniv.linux.org.uk,
	will@kernel.org, x86@kernel.org, ziy@nvidia.com
Subject: Re: Warning from free_reserved_area() in next-20260325+
Message-ID: <aca6blFFWskxAcAr@kernel.org>
References: <20260323074836.3653702-10-rppt@kernel.org>
 <20260327140109.7561-1-spasswolf@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327140109.7561-1-spasswolf@web.de>
X-Rspamd-Queue-Id: 8512180018
X-Stat-Signature: onznn1rgqz5hoyjj6hjyrioqarj7nawc
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774631552-647370
X-HE-Meta: U2FsdGVkX1/DxO7H1xK2bhbs3QaqWyngN3kxgKPTLijkmEd4cef+A2abpiIkaLk+txShgwJelFkVFepBqG19fpvxhPfC5l54Vdm5laFAxopVa0GRZfQS5tiFzYxgRLfKJzbUlGpZrFBfhocBL8V6aBrRTyA5KZj5dCKGZX130fr8vxrW3ZxY1cINf5v4sdyBFb5XivZu1Wga6Ph89/vH4MNcj1xHIQhuUja38r197qFwKYDih5P+pHlRxzvyM171ZxL819baqoNgzfl9q3B+0k3b/JVRV1t0Kg0eyGox4pVgbvTQFJ27pIsS8VF4npxjqk4OttJE5b/Q+VTdhW3KgXMNauQgr1R4BTNpqP0UBhGPxCVvRKj67htVOtPVQODjAMgwa0ckFKXoWs/kmgK7pUO5Se8SOPzryzI+fSq8+tn7NWKO75LWU3bGiaSx3Us+ALi1HxtVL8KrivF6LAcmnN1LVbLSEIb9KKTT8+4R9LbpBr5ypx3LXF2oZpFEKDIdNP3+GjeFBL5dxbStzg1gkLx2oNPCJhxci/0zo35wf9zH/4/emD+KuBbrj9663GeEs1Crnaytr7r4i3Bir4OP74mXCKEN4i9xrl5kQlsGxw9DWqZ0LtL9qBDODjs8E7B8hcoHeO9LMy2bSUKHPQyWRHwOOQGJmSZ0tpH2BP26T5zAvgkOpVRubirVT6+bmnyGSNoQi5SQ/Nu0tTPFUJGD+jAl5jrBkcVKJjF8LJbDmXtn9pRxzy1VCYgZ1NaASWwX//IAa46Z4aZvTwHx7pl3IrcEIcfydIHBdypAyj5W6TmOfYw6GpBANneet4JuLBT8810keFfeXwI8LEBduqQhftLEiUonAjGgPZtpvNWAWcKivArtjeRA/rINTmJB7c82PXGI8d+M/knlRRgFwCo/OyqrX2frtN6Tx+5sC1jN0s3bT+xJ1A4sT6zCdZ8KvMnt9J+MH07GNWun4SwQW+z
 eRmrzUAy
 OVlQM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Bert,

On Fri, Mar 27, 2026 at 03:01:08PM +0100, Bert Karwatzki wrote:
> Starting with linux next-20260325 I see the following warning early in the
> boot process of a machine running debian stable (trixie) (except for the kernel):

Thanks for the report!

> [    0.027118] [      T0] ------------[ cut here ]------------
> [    0.027118] [      T0] Cannot free reserved memory because of deferred initialization of the memory map
> [    0.027119] [      T0] WARNING: mm/memblock.c:904 at __free_reserved_area+0xa9/0xc0, CPU#0: swapper/0/0
> [    0.027122] [      T0] Modules linked in:
> [    0.027123] [      T0] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 7.0.0-rc5-next-20260326-master #385 PREEMPT_RT 
> [    0.027125] [      T0] Hardware name: ASUS System Product Name/ROG STRIX B850-F GAMING WIFI, BIOS 1627 02/05/2026
> [    0.027125] [      T0] RIP: 0010:__free_reserved_area+0xa9/0xc0
> [    0.027126] [      T0] Code: 48 89 df 48 89 ee e8 06 fe ff ff 48 89 c3 48 39 e8 72 a0 5b 4c 89 e8 5d 41 5c 41 5d 41 5e c3 cc cc cc cc 48 8d 3d 97 c2 c6 00 <67> 48 0f b9 3a 45 31 ed eb df 66 66 2e 0f 1f 84 00 00 00 00 00 66
> [    0.027127] [      T0] RSP: 0000:ffffffff9b203e98 EFLAGS: 00010202
> [    0.027128] [      T0] RAX: 0000000e91c00001 RBX: ffffffff9b100c0f RCX: 0000000080000001
> [    0.027128] [      T0] RDX: 00000000000000cc RSI: 0000000e2d42d000 RDI: ffffffff9b32ef60
> [    0.027128] [      T0] RBP: ffff9eeafdd6fbc0 R08: 0000000000000000 R09: 0000000000000001
> [    0.027129] [      T0] R10: 0000000000001000 R11: 8000000000000163 R12: 000000000000006f
> [    0.027129] [      T0] R13: 0000000000000000 R14: 0000000000000045 R15: 000000005c8a1000
> [    0.027129] [      T0] FS:  0000000000000000(0000) GS:ffff9eeb21c05000(0000) knlGS:0000000000000000
> [    0.027130] [      T0] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    0.027130] [      T0] CR2: ffff9ee8ad801000 CR3: 0000000e2ce1e000 CR4: 0000000000f50ef0
> [    0.027131] [      T0] PKRU: 55555554
> [    0.027131] [      T0] Call Trace:
> [    0.027132] [      T0]  <TASK>
> [    0.027132] [      T0]  free_reserved_area+0x89/0xd0
> [    0.027133] [      T0]  alternative_instructions+0xee/0x110
> [    0.027136] [      T0]  arch_cpu_finalize_init+0x10f/0x160
> [    0.027138] [      T0]  start_kernel+0x686/0x710
> [    0.027140] [      T0]  x86_64_start_reservations+0x24/0x30
> [    0.027141] [      T0]  x86_64_start_kernel+0xd4/0xe0
> [    0.027142] [      T0]  common_startup_64+0x13e/0x141
> [    0.027143] [      T0]  </TASK>
> [    0.027144] [      T0] ---[ end trace 0000000000000000 ]---

Does this patch fix it for you?

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index e87da25d1236..62936a3bde19 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -2448,19 +2448,31 @@ void __init alternative_instructions(void)
 					    __smp_locks, __smp_locks_end,
 					    _text, _etext);
 	}
+#endif
 
+	restart_nmi();
+	alternatives_patched = 1;
+
+	alt_reloc_selftest();
+}
+
+#ifdef CONFIG_SMP
+/*
+ * With CONFIG_DEFERRED_STRUCT_PAGE_INIT enabled we can free_init_pages() only
+ * after the deferred initialization of the memory map is complete.
+ */
+static int __init free_smp_locks(void)
+{
 	if (!uniproc_patched || num_possible_cpus() == 1) {
 		free_init_pages("SMP alternatives",
 				(unsigned long)__smp_locks,
 				(unsigned long)__smp_locks_end);
 	}
-#endif
 
-	restart_nmi();
-	alternatives_patched = 1;
-
-	alt_reloc_selftest();
+	return 0;
 }
+arch_initcall(free_smp_locks);
+#endif
 
 /**
  * text_poke_early - Update instructions on a live kernel at boot time
 
> Bert Karwatzki

-- 
Sincerely yours,
Mike.

