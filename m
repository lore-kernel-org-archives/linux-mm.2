Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD37B606A336
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 17:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=arndb.de header.i=@arndb.de header.a=rsa-sha256 header.s=fm2 header.b=IWsMstT8;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=bGfrAs85
Received: by kanga.kvack.org (Postfix)
	id D230C6B05B3; Fri, 13 Nov 2026 12:55:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFA9D6B05B5; Fri, 13 Nov 2026 12:55:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC2206B05B6; Fri, 13 Nov 2026 12:55:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8B5B06B05B3
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:55:12 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 054FC16021D
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:55:11 +0000 (UTC)
X-FDA: 85430847264.06.2B4244E
Received: from fhigh-a3-smtp.messagingengine.com (fhigh-a3-smtp.messagingengine.com [103.168.172.154])
	by imf30.hostedemail.com (Postfix) with ESMTP id ABEC780004
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:55:09 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=IWsMstT8;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="b GfrAs8";
	spf=pass (imf30.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.154 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794592510;
	b=GKclnMBRAGO69cOf1PnVDyUMut/LUlTCviPNwgyy9VdIXKpRE1U24M+FYOax6op4DRW8B2
	iH6hDJUMeW5wdhyycvxysfXBLWNDHQcRDpaTSKE4iHIfycGRe4FqB5/N6MyMzVWKwtY8nH
	vJh11OFz0GITpIZVfGN0CmPSOxmkX6Q=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=IWsMstT8;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="b GfrAs8";
	spf=pass (imf30.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.154 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794592510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lt2IwZ/R4hYW5jbQqUrgr5oyZsqrYDevo+6k0LFEn4Y=;
	b=W6maQOgsBKwPt5LUR4lJvVKciUkwT+O/qUT/lJ9dRUCjCZy2DTLy7xKu8zdm1ViTc7NUCy
	P9zWqUH6fXnkgMsywOcWlJwX0fQw0VFxDTRIyL4hCYibS98sDzrokiPPGblCQluXuAISSc
	r8fElpdyxyoHZMDYp6VBGXFivyNv8Hw=
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfhigh.phl.internal (Postfix) with ESMTP id D0D871400096
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:55:08 -0500 (EST)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Fri, 13 Nov 2026 12:55:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1794592501;
	 x=1794678901; bh=lt2IwZ/R4hYW5jbQqUrgr5oyZsqrYDevo+6k0LFEn4Y=; b=
	IWsMstT8l8u8wOxCFntAWVLdDRlu/T7KGrY0L0CFRlAs7w0EI3DCD/9QPrv5axhE
	eiV5SKDgw4WWX2sAA74NyPS5IGUd/+oSsnGzLK/ZcCxiDCna9MNiAt+TG4VDe6JW
	SNi12Cv2FQ1u9E3DGdkSqlbtYyQjPn7d4zSRpWXqgltV4ooOAVZ1gjm+XvHd2F6U
	mBwc7TBxyyq1D80R4cwNJwjWSX4V1PLLbFYa0e81y42OWciBgBguzlpr5tfQUtbs
	W8uHT+pJPWFUPHthJw7x6eyj9parsV69VQo+wFd2COQd0CUcszRymXY2eojZqFSm
	n+/2nLOIu3lwYJQTbk19gg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1794592501; x=
	1794678901; bh=lt2IwZ/R4hYW5jbQqUrgr5oyZsqrYDevo+6k0LFEn4Y=; b=b
	GfrAs851e0sWB2uPG1d54SqSDf7DjOwzwgm21LQRJeLhWf6RLpmKiM6FciwDr6jM
	mfDJNs8kY8b9/hxKhb49KLlYQ/zYpW5jeELZqt8F185RIaGi97FWhKwt9ZdbUXTH
	txfRMSfkplbdQrUDa5vg7kZ3m9dqTP6xWOlToi0fWK024mwjKlPyNpvByrTAD19n
	W6CabkkZ02nbqvS/l2iWySOWuvb82IZsgK7adGzOi46Mubz6FbybgIR47dmmdnWz
	NUZqbsrQzcLmzPfnSLoCKr5dw4p1HV2CtFxDvdjQgr625RHimYBgjqpbfvw3/vMK
	xitUMswruRcEZt/mGT6yA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=arndb.de a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794592501; d=arndb.de;
	mf=PGFybmRAYXJuZGIuZGU+; rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm2:rsa-sha256:Zr/pZRaiEeTdESeKDIuoMCEiiauk8A1JFoPQpC+3SYpfFEo
	bDxaWsNu/7U4SkqwHnEsiUPO7xg4SNjw+I1z9wCkwWvGaQ5xSGcrAkprfQ95Ap03
	yAtRLsyAAAEmWaHMpYr5z165pPdlOhbXYI4M/SKozrkk+r5dFfD8QG3LJZAu5oRY
	6Xt9MYAuFcWxz7HcxGoCsE2DPLa/qM1KSqA2l6JFD7e4EH7n6GlotfR6SM/CRpLa
	Ng04rlKBILeXCe0GF3sYnD3uqDvMXyZNpc8UlrZmF30oVyb/RNXTmZOPHI7Sc9pu
	6gqZ4hhWd1UO5Nlu1hUHyAC8rGM4w+a1fQDMkVA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:cVGTogRqu+z8axCAJ4eI0fd7srPloZF8+BBsbVr7vuk=:Aol36ivzBJsbg4GpmzkWwnZve0vXUIg4h95rif6VmZ8=;
X-ME-Sender: <xms:5073aoqvS4fKiVcw6Nsm86dV7mxfbjmVgKlVgU160Ph_Sf3_95BMeQ>
    <xme:5073apeNtvXHUyBqWE1Yx7_GZmp-XLxKncTOef1QiEU3XOnvIsknUeG4HoDG8pTAD
    jhvC66Rh4_CzEfYOoJ-TrZoodnde3ZCcMS5x6Ryr9QeeP-Sy7DSYeF67Q>
X-ME-Proxy-Cause: dmFkZTEGOx7wOQEJCkmAHpMyR3jJzBFyIj/geLCAzGjbH7J6EVayvAD/bTcH3bn1E4A/Xd
    2Fk3zgmQ2qrioOD4ZqmYWqVy5NUjRBZRM00xRWv1nDk+yko/p/eAJDQ9TZfQXrjSO7RHbr
    x+Ut6tgpLHxDbMYS2ffitP9r1V6pFBiBqndsjNI+hF1o87G6PPa83AERB0KE6WGTCnBwOC
    vRo6zlvoKcNqSfuYMKXMNGmz77FnXWS6gGENMSirZ/o+EVOnFA2lFG9RhBNbzCwWK0rZh1
    sZGhNbO99gM8NjAeP6iEGmUkV2DQQeu7pFHpt5FzHlbNVWzlJbnRmS/2tKd2zENM4vwGtd
    kB6PT6cWZLv/tnQEgiKVbjhm6vt/51yDlpDra6xv2sKi312xjeOJ8PYJN/BlU/VBIIUMk7
    FpbVsa9p9084vDHXa3SYUoMUP/rJzQUnola6DXsOJpoDp6JImwZJYpzmAclnnj7ETpMlHo
    sqHvw8/kkyTJxvTPYga9LmmuX5hIsgGcfWLTFX7NAjN1DQSu8+XQehEU3aupFYC/Wx/ouY
    pbFu/Kz8sBF80AZ1yEtQ3C21FIFxSHNqN9oCr7kiU0/hx+S001GaEDTzt6nXCr9JryTPf7
    9yO0DIg48mgW/NKVfwisP0pBPAl894bWNbdYiACF2YKAL2nM1N26oHAwm7+g
X-ME-Proxy: <xmx:7U73av874rxQa_KKPzpiW9UL80PKsgyXbX_MTZB8eOZNox8X5qOhhg>
    <xmx:7U73auBJSLyjTXsRiOXHeFZaO_lUocIVgglYVsonOdd9iYfn1ad0KQ>
    <xmx:7U73arsRepQ3ft6HdrbhOok9nHuiieCmRsTOsDUXbl_ymRHVacfHzA>
    <xmx:7U73aoakeN-h3kc9jmCp_8l39gVP-3jFjKdJrgxic_2c7JycSsEYvw>
    <xmx:9U73asi0xYS54pePAmKVkPlc9t2-VuIISZ1A0taV2Xbqz9hr0eqfYsGW>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id B855732A009C; Fri, 13 Nov 2026 12:54:47 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ThreadId: A2m0p2cyauGk
Date: Fri, 13 Nov 2026 18:54:27 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: sashiko-reviews@lists.linux.dev, "Arnd Bergmann" <arnd@kernel.org>,
 linux-mm@kvack.org
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
 "Andreas Larsson" <andreas@gaisler.com>,
 "Christophe Leroy" <chleroy@kernel.org>,
 "Dave Hansen" <dave.hansen@linux.intel.com>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>,
 "Jason Gunthorpe" <jgg@nvidia.com>,
 "Linus Walleij" <linus.walleij@linaro.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Matthew Wilcox" <willy@infradead.org>,
 "Malin Jonsson" <malin.jonsson@est.tech>,
 "Richard Weinberger" <richard@nod.at>,
 "Russell King" <linux@armlinux.org.uk>, x86@kernel.org,
 "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
 "Madhavan Srinivasan" <maddy@linux.ibm.com>,
 "Michael Ellerman" <mpe@ellerman.id.au>,
 "Nicholas Piggin" <npiggin@gmail.com>, "Michal Simek" <monstr@monstr.eu>,
 "Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 "Vlastimil Babka" <vbabka@suse.cz>, "Mike Rapoport" <rppt@kernel.org>,
 "Suren Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 "Nishanth Menon" <nm@ti.com>, "Lucas Stach" <l.stach@pengutronix.de>
Message-Id: <2a6929c0-f402-4cc1-bf15-cb83d0e9746c@app.fastmail.com>
In-Reply-To: <sashiko-outbox-212719@kernel.org>
References: <20261112112528.1116405-1-arnd@kernel.org>
 <20261112112528.1116405-6-arnd@kernel.org> <sashiko-outbox-212719@kernel.org>
Subject: Re: [PATCH v2 5/6] arch/*: increase lowmem size to avoid highmem use
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qaysg836x6kpcxfqzd3rqyrdem4q5hia
X-Rspamd-Queue-Id: ABEC780004
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794592509-206137
X-HE-Meta: U2FsdGVkX18cntIIg7i3uK4FIqmCQCJSavJxXI0W450XNTkcY0oQhCnTzJOCLGnpMy0m60U8Xs6cYbA6Z7AyA7LMX9wKxAXSHi/NKIEHwT+miPmTVRTTaQthCyhrsF68GH90SQcgBRyGiDbVJrmpBxij+MgY03xzGLMbckdmdeT2tMFtVb6JxXD9fu9uJIg09iy8cvdTFPLs/5KLmzqwuiGy9DnIP9OjsH4BZ7Ym9pT+asnVrKgne653CgXlCQTclopPDKkxVwpsPkeT7Fqnn7qJZkX0be5cASmylv/lzTooMDKs29GobOy7UbVaodAxuWEYORVVqOcaUTAUJR6w6QZ8takTZrgx8wcce8TJ+eGgd4Do3cwBsb4aXzEFCeY5AQaKjP0+GqeSlddc9jijuRX2iyUoJxasmbHyqHd/NQySPcPVSTMOJ//tC/T/E09fKYUJuSkNzD2n1CxndUaqhYGikLCzhU/11zEceg+L6N0QZda47+EjCQRntRd8tlp4c7dOQOKzx4ZOlkIvb5nNeKrQwM454PtwamWydAqD98P1OtkFpOS16wnJAWe8TxwJuiaEfCZ9AWDgy4iqY4KQvmIUvIBhA+Lq/P+6y74H5tyMRzCcQyFoJqkQa7CIQ6qHmnsts/wpKEECMAMw3pcDeG1l2soqEtokLPLo9JvM0a36p+/Le/Gtd3VID/CtWKEHjOY3KF7kxQQrnbWL5c9C0vU4DqfAYopbbBZa454BgHlwDKXLPdvI46A8Az0iaoZTtm0WlF2srCTvNP5a/GZ5kdVx05vNe2djvU/YSNBcRKnn364OAh+wK+AMnlutzKuq+JXX1e7EjzlpqewJONncCTwtzkdI0l9dNAYBTyXDaiPx22uvXYqZ0ISrQGNGUJCTkmJC27nGyfWTksK4rS/y7NI4wnF03xmTYHROY7iUz4OCxbw2fwRkosVQdmHjrLarH4fVs6tYmpzGJf65JaM
 B4AoOqMa
 LsqtLJePRAkID8HgKysp/YGKPXsMGLWuItClSOAFl5tsEXiZo1R7I2Jw8LxTc+hO/d9FDn4cVfpsbPcHI2pz/xI2e/aPVwoXVnKVT2/86ghtYBBb7gINqmNAGIk/eb313cJcFEnQPsN/dnAsD83B3YcXc/ql4MW35wYCI2L818MWMXM9GFQwL/eTp7nCca5biPGSBc9ZdZKsUPcOQY0m4CXw7bTL8j3Zt8HCY8tygCk2qCmwApaLGuWdCUBv1V6ta40W86URMSpr/mhPMCu+X8rX72hitWnIOsmJAmiGd98gGzFJh2iBkq4JSqBrvRaVBa6Q2EbVkzvN7ONRTx7UsizI4OlONoh4THPwrLIV27bCnf18u0LCqYJYZ2O2dZ8wBOfHTRAf4NG6Ye5HXwwO9epLx4wHENP1ZgvbXnhQGsL28ZB8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13, 2026, at 12:26, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 9 potential
> issues to consider:
> - [High] powerpc: 85xx LOWMEM_CAM_NUM and PAGE_OFFSET cap lowmem at 768
>   MiB
> - [High] ARM: omap2: dropping HIGHMEM select limits multi_v7 and
>   omap2plus to 1 GiB
> - [High] KVM: PPC: e500: get_host_mas0() hits kernel TLB with
>   PAGE_OFFSET 0x70000000
> - [High] powerpc/47x: 2 GiB LOWMEM_SIZE triggers BUG_ON in
>   ppc47x_pin_tlb()
> - [High] KVM: PPC: BookE: hardcoded 0xc0000000 host IVPR breaks new
>   KERNEL_START
> - [High] KVM: PPC: Book3S: LOAD_HOST_SEGMENTS leaves kernel SRs 7..11
>   unrestored
> - [Medium] powerpc/kasan: 32-bit HIGHMEM lowmem overlaps KASAN shadow
>   and fixmap
> - [Medium] ARM: config: aspeed_g5: dropping HIGHMEM truncates 2 GiB
>   AST2600 RAM
> - [Medium] ARM: pxa: hardcoded 0xc0000000 dereference in
>   pxa3xx_cpu_pm_suspend()
> --
>

>> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
>> index 93350d2e51b99..fee6b7435b7ca 100644
>> --- a/arch/arm/Kconfig
>> +++ b/arch/arm/Kconfig
>> @@ -1027,7 +1027,8 @@ config BL_SWITCHER_DUMMY_IF
>>  choice
>>  	prompt "Memory split"
>>  	depends on MMU
>> -	default VMSPLIT_3G
>> +	default VMSPLIT_2G if HIGHMEM || ARM_LPAE
>> +	default VMSPLIT_3G_OPT
>
> [Severity: Medium]
> Does switching the non-HIGHMEM default to VMSPLIT_3G_OPT (PAGE_OFFSET =
> 0xb0000000) break suspend-to-RAM on PXA3xx?
>
> In pxa_pm_enter() -> pxa3xx_cpu_pm_enter() -> pxa3xx_cpu_pm_suspend(), the
> code saves the first word of SDRAM and writes the physical resume address
> for the boot ROM using a hardcoded 0xc0000000 virtual address instead of
> PAGE_OFFSET:
>
> arch/arm/mach-pxa/pxa3xx.c:pxa3xx_cpu_pm_suspend() {
> 	volatile unsigned long *p = (volatile void *)0xc0000000;
> 	unsigned long saved_data = *p;
> ...
> 	*p = __pa_symbol(cpu_resume);
> }
>
> On PXA3xx boards with 64 MiB or 128 MiB of RAM (such as pxa3xx_defconfig),
> 0xc0000000 is now in the vmalloc area rather than the start of SDRAM, so
> entering PM_SUSPEND_MEM faults or corrupts vmalloc memory.

Right, I added a fix for this bug now:

commit c795c18cfdda3220280ccdbbb0aeb17b9e3ae9df
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Fri Nov 13 15:22:55 2026 +0100

    ARM: pxa: support arbitrary PAGE_OFFSET
    
    The pxa3xx_cpu_pm_suspend() implementation hardcodes the default
    PAGE_OFFSET value for CONFIG_VMSPLIT_3G. This has always been broken
    for other configurations but becomes much worse now that the default
    is changing.
    
    Fix this to use the correct compile-time constant instead.
    
    Reported-by: sashiko-bot@kernel.org
    Fixes: c4d1fb627ff3 ("[ARM] pxa: add preliminary suspend/resume code for pxa3xx")
    Cc: stable@vger.kernel.org
    Link: https://lore.kernel.org/all/sashiko-outbox-212719@kernel.org/
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/arch/arm/mach-pxa/pxa3xx.c b/arch/arm/mach-pxa/pxa3xx.c
index 06c578ea658e..253770075a8b 100644
--- a/arch/arm/mach-pxa/pxa3xx.c
+++ b/arch/arm/mach-pxa/pxa3xx.c
@@ -103,7 +103,7 @@ static void pxa3xx_cpu_standby(unsigned int pwrmode)
  */
 static void pxa3xx_cpu_pm_suspend(void)
 {
-	volatile unsigned long *p = (volatile void *)0xc0000000;
+	volatile unsigned long *p = (volatile void *)PAGE_OFFSET;
 	unsigned long saved_data = *p;
 #ifndef CONFIG_IWMMXT
 	u64 acc0;

>> diff --git a/arch/arm/configs/aspeed_g5_defconfig b/arch/arm/configs/aspeed_g5_defconfig
>> index 45b937419dbda..5c5d831df36ab 100644
>> --- a/arch/arm/configs/aspeed_g5_defconfig
>> +++ b/arch/arm/configs/aspeed_g5_defconfig
>> @@ -27,7 +27,6 @@ CONFIG_SMP=y
>>  # CONFIG_ARM_CPU_TOPOLOGY is not set
>>  CONFIG_VMSPLIT_2G=y
>>  CONFIG_NR_CPUS=2
>> -CONFIG_HIGHMEM=y
>
> [Severity: Medium]
> Does dropping CONFIG_HIGHMEM=y from aspeed_g5_defconfig truncate RAM on
> 2 GiB AST2600 boards?
>
> Despite its name, aspeed_g5_defconfig also enables CONFIG_MACH_ASPEED_G6=y
> and explicitly selects CONFIG_VMSPLIT_2G=y.  Commit 4cdabee7d6d2 ("ARM:
> configs: aspeed_g5: Enable AST2600") enabled CONFIG_HIGHMEM=y here because
> AST2600 boards (such as aspeed-ast2600-evb.dts) have 2 GiB of RAM, while
> CONFIG_VMSPLIT_2G=y without HIGHMEM only maps at most 1.75 GiB of lowmem
> after reserving space for vmalloc, ioremap, and fixmap.

Right, I've removed that change here now, and change it to
CONFIG_VMSPLIT_2G_OPT in the patch that introduces it.

>> diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
>> index f0f1d7a8640ca..d145e448a6b80 100644
>> --- a/arch/arm/mach-omap2/Kconfig
>> +++ b/arch/arm/mach-omap2/Kconfig
>> @@ -135,7 +135,6 @@ config ARCH_OMAP2PLUS_TYPICAL
>>  	bool "Typical OMAP configuration"
>>  	default y
>>  	select AEABI
>> -	select HIGHMEM if !CPU_CACHE_VIVT
>>  	select I2C
>>  	select I2C_OMAP
>>  	select MENELAUS if ARCH_OMAP2
>
> [Severity: High]
> Does removing this select silently disable CONFIG_HIGHMEM in both
> multi_v7_defconfig and omap2plus_defconfig?
>
> Neither defconfig contains an explicit CONFIG_HIGHMEM=y line because both
> enable ARCH_OMAP2PLUS_TYPICAL, which previously selected HIGHMEM.  With
> this line removed, both defconfigs build with CONFIG_HIGHMEM=n and fall
> back to CONFIG_VMSPLIT_3G_OPT=y, limiting all 1.5 GiB to 4 GiB ARMv7
> boards booted with multi_v7_defconfig or omap2plus_defconfig to 1 GiB of
> RAM.

Indeed, I had missed how ARCH_OMAP2PLUS_TYPICAL sets the default for
multi_v7_defconfig as well, and definitely did not mean to sneak that
in quietly, though it is at least tempting to have it explicitly turned
off anyway, if only to see who would notice.

I've removed this change here, and would replace it with a separate
patch later. As far as I can tell, we support multiple OMAP5 boards
with 2GB on mainline dts. Larger configurations are possible as well,
but would be extremely rare and require LPAE, which is also not
enabled in the defconfig.

Something like this version, though I suspect any change I propose
here will be controversial because it pessimises some other
hardware.

diff --git a/arch/arm/configs/lpae.config b/arch/arm/configs/lpae.config
index 1ab94da8345d..535696d6de96 100644
--- a/arch/arm/configs/lpae.config
+++ b/arch/arm/configs/lpae.config
@@ -1,3 +1,4 @@
 # Help: Enable Large Physical Address Extension mode
 CONFIG_ARM_LPAE=y
 CONFIG_VMSPLIT_2G=y
+CONFIG_HIGHMEM=y
diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index 069d5a49f01c..c3e427ce8d88 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -103,6 +103,7 @@ CONFIG_ARCH_VEXPRESS_TC2_PM=y
 CONFIG_ARCH_WM8850=y
 CONFIG_ARCH_ZYNQ=y
 CONFIG_SMP=y
+CONFIG_VMSPLIT_2G_OPT=y
 CONFIG_NR_CPUS=16
 CONFIG_ARM_APPENDED_DTB=y
 CONFIG_ARM_ATAG_DTB_COMPAT=y
diff --git a/arch/arm/configs/omap2plus_defconfig b/arch/arm/configs/omap2plus_defconfig
index 5791953b75ff..b00789279f25 100644
--- a/arch/arm/configs/omap2plus_defconfig
+++ b/arch/arm/configs/omap2plus_defconfig
@@ -36,6 +36,7 @@ CONFIG_POWER_AVS_OMAP_CLASS3=y
 CONFIG_ARM_THUMBEE=y
 CONFIG_ARM_ERRATA_411920=y
 CONFIG_SMP=y
+CONFIG_VMSPLIT_2G_OPT=y
 CONFIG_NR_CPUS=2
 CONFIG_ARM_APPENDED_DTB=y
 CONFIG_ARM_ATAG_DTB_COMPAT=y
diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index 79f8afe3a6bf..d145e448a6b8 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -135,7 +135,6 @@ config ARCH_OMAP2PLUS_TYPICAL
 	bool "Typical OMAP configuration"
 	default y
 	select AEABI
-	select HIGHMEM
 	select I2C
 	select I2C_OMAP
 	select MENELAUS if ARCH_OMAP2

>> @@ -1193,7 +1194,8 @@ config LOWMEM_SIZE_BOOL
>>  
>>  config LOWMEM_SIZE
>>  	hex "Maximum low memory size (in bytes)" if LOWMEM_SIZE_BOOL
>> -	default "0x30000000"
>> +	default "0x80000000" if HIGHMEM
>> +	default "0x40000000"
>
> [Severity: High]
> On PPC_85xx, doesn't CONFIG_LOWMEM_CAM_NUM still cap lowmem at 768 MiB?
>
> Right below LOWMEM_SIZE, LOWMEM_CAM_NUM still defaults to 3 (or 9/12/15
> with STRICT_KERNEL_RWX, where the first 256 MiB uses 7/10/13 smaller CAMs).
> Furthermore, because the new PAGE_OFFSET defaults (0xb0000000 and
> 0x70000000) are only 256 MiB-aligned, calc_cam_sz() bounds each CAM to
> 1UL << __ffs(virt | phys), which is at most 256 MiB at every 256 MiB
> boundary.  As a result, MMU_init() -> adjust_total_lowmem() ->
> map_mem_in_cams() still caps __max_low_memory at 3 * 256 MiB = 768 MiB:
> non-HIGHMEM 85xx builds (including ksi8560_defconfig and stx_gp3_defconfig)
> discard RAM above 768 MiB via memblock_enforce_memory_limit(), while
> HIGHMEM 85xx builds shrink TASK_SIZE to 1.75 GiB without gaining any
> lowmem.

Based on the explanation in commit 49e3d8ea6248 ("powerpc/fsl_booke:
Enable STRICT_KERNEL_RWX"), I've now increased LOWMEM_CAM_NUM to

config LOWMEM_CAM_NUM
        depends on PPC_85xx 
        int "Number of CAMs to use to map low memory" if LOWMEM_CAM_NUM_BOOL
        default 8 if !STRICT_KERNEL_RWX
        default 14 if DATA_SHIFT >= 24
        default 17 if DATA_SHIFT >= 22
        default 20

I think Richard Weinberger mentioned that his 2GiB machine was still
limited to 1.75GiB, but I'm not sure why.

> [Severity: High]
> Can a 2 GiB LOWMEM_SIZE trigger a boot BUG_ON in ppc47x_pin_tlb() on
> PPC_47x systems with more than 1.5 GiB of RAM?
>
> Unlike 85xx, 44x/47x does not call adjust_total_lowmem(), so mmu_mapin_ram()
> pins 256 MiB TLB entries in a loop up to lowmem_end_addr (now up to 2 GiB
> when HIGHMEM=y, such as in currituck_defconfig).  However, PPC47x hardware
> only has 6 bolted TLB slots in ppc47x_find_free_bolted() (5 if
> CONFIG_PPC_EARLY_DEBUG_44x=y uses slot 5), covering at most 1.5 GiB (or
> 1.25 GiB) before ppc47x_pin_tlb() hits BUG_ON(bolted < 0).  In addition,
> dropping CONFIG_HIGHMEM=y from arch/powerpc/configs/44x/akebono_defconfig
> limits the IBM Akebono PPC476GTR board, which supports multi-gigabyte DDR3
> configurations via SWIOTLB, to 1 GiB of RAM.

Right, I don't see a good solution here. It sounds like we can
easily support 1GiB of lowmem on all 44x machines, but supporting more
than those would require non-bolted TLBs for the linear map, which I
imagine will cause more problems.

I've added a special case for 44x now, at least most of these would
be old enough to not require more than 1GiB, and the ones that do
are less likely to run updated mainline kernels than the better supported
freescale parts.

--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -1191,6 +1191,6 @@ config LOWMEM_SIZE_BOOL
 
 config LOWMEM_SIZE
        hex "Maximum low memory size (in bytes)" if LOWMEM_SIZE_BOOL
-       default "0x80000000" if HIGHMEM
+       default "0x80000000" if HIGHMEM && !44x
        default "0x40000000"
 
@@ -1244,7 +1245,7 @@ config PAGE_OFFSET_BOOL
 
 config PAGE_OFFSET
        hex "Virtual address of memory base" if PAGE_OFFSET_BOOL
-       default "0x70000000" if HIGHMEM
+       default "0x70000000" if HIGHMEM && !44x
        default "0xb0000000"
 
 config KERNEL_START_BOOL
@@ -1261,7 +1262,7 @@ config KERNEL_START_BOOL
 config KERNEL_START
        hex "Virtual address of kernel base" if KERNEL_START_BOOL
        default PAGE_OFFSET if PAGE_OFFSET_BOOL
-       default "0x72000000" if HIGHMEM && CRASH_DUMP && !NONSTATIC_KERNEL
+       default "0x72000000" if HIGHMEM && !44x && CRASH_DUMP && !NONSTATIC_KERNEL
        default "0xb2000000" if CRASH_DUMP && !NONSTATIC_KERNEL
        default PAGE_OFFSET
 
>> @@ -1245,7 +1247,8 @@ config PAGE_OFFSET_BOOL
>>  
>>  config PAGE_OFFSET
>>  	hex "Virtual address of memory base" if PAGE_OFFSET_BOOL
>> -	default "0xc0000000"
>> +	default "0x70000000" if HIGHMEM
>> +	default "0xb0000000"
>
> [Severity: Medium]
> When both CONFIG_HIGHMEM=y and CONFIG_KASAN=y are enabled on 32-bit
> PowerPC, does lowmem overlap the KASAN shadow and fixmap regions?
>
> With PAGE_OFFSET at 0x70000000 and LOWMEM_SIZE at 0x80000000, lowmem can
> extend up to 0xf0000000.  However, KASAN_SHADOW_OFFSET is fixed at
> 0xe0000000 in arch/powerpc/Kconfig.debug, which places KASAN_SHADOW_START
> at 0xec000000 (with CONFIG_EXECMEM=y) or 0xee000000 (with CONFIG_EXECMEM=n)
> and places FIXADDR_TOP, PKMAP_BASE, and VMALLOC_END below
> KASAN_SHADOW_START, colliding with lowmem on systems with ~1.9 GiB or more
> of RAM and triggering a boot BUG_ON in map_kernel_page().

This took me a while to process. As far as I understand now, the upper
end of lowmem is unchanged, but the maximum KASAN shadow is now ~300MB
instead of ~134MB and this no longer fits into the 240MiB vmalloc area
above the linear map. Before my patch, using 134MB of the vmalloc area
for the shadow wasn't ideal either but did not immediately break the
system.

The question is whether the extra address space for KASAN should come
out of lowmem or user. Taking it out of lowmem would be easier, in this
case limiting a KASAN kernel again to 1.75GiB:

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index fe33032dbc13..1eef831faf3a 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -1192,6 +1192,7 @@ config LOWMEM_SIZE_BOOL
 config LOWMEM_SIZE
 	hex "Maximum low memory size (in bytes)" if LOWMEM_SIZE_BOOL
 	default "0x40000000" if 44x
+	default "0x70000000" if HIGHMEM && KASAN
 	default "0x80000000" if HIGHMEM
 	default "0x40000000"
 
> [Severity: High]
> With PAGE_OFFSET=0x70000000, can get_host_mas0() in the e500 KVM host MMU
> match and overwrite a host kernel TLB entry instead of forcing a miss?
>
> arch/powerpc/kvm/e500_mmu_host.c:get_host_mas0() {
> 	local_irq_save(flags);
> 	mtspr(SPRN_MAS6, 0);
> 	mas4 = mfspr(SPRN_MAS4);
> 	mtspr(SPRN_MAS4, mas4 & ~MAS4_TLBSEL_MASK);
> 	asm volatile("tlbsx 0, %0" : : "b" (eaddr & ~CONFIG_PAGE_OFFSET));
> 	mas0 = mfspr(SPRN_MAS0);
> }
>
> get_host_mas0() masks eaddr with ~CONFIG_PAGE_OFFSET to produce a userspace
> address (< PAGE_OFFSET) that is guaranteed to miss in PID 0.  When
> CONFIG_PAGE_OFFSET is 0x70000000, ~CONFIG_PAGE_OFFSET is 0x8fffffff, so any
> guest eaddr >= 0x80000000 masks to 0x80000000..0x8fffffff, which lies
> inside the host kernel linear mapping (>= 0x70000000) and can hit and
> overwrite an active host kernel TLB entry in write_host_tlbe().

I should probably revisit my patches to remove 32-bit KVM, as I don't
understand this code at all ;-)

Would this work correctly by masking the address to the next lower
power of two below PAGE_OFFSET?

--- a/arch/powerpc/kvm/e500_mmu_host.c
+++ b/arch/powerpc/kvm/e500_mmu_host.c
@@ -115,7 +115,8 @@ static u32 get_host_mas0(unsigned long eaddr)
        mtspr(SPRN_MAS6, 0);
        mas4 = mfspr(SPRN_MAS4);
        mtspr(SPRN_MAS4, mas4 & ~MAS4_TLBSEL_MASK);
-       asm volatile("tlbsx 0, %0" : : "b" (eaddr & ~CONFIG_PAGE_OFFSET));
+       asm volatile("tlbsx 0, %0" :
+               : "b" (eaddr & (rounddown_pow_of_two(CONFIG_PAGE_OFFSET)-1)));
        mas0 = mfspr(SPRN_MAS0);
        mtspr(SPRN_MAS4, mas4);
        local_irq_restore(flags);

>>  config KERNEL_START_BOOL
>>  	bool "Set custom kernel base address"
>> @@ -1261,8 +1264,9 @@ config KERNEL_START_BOOL
>>  config KERNEL_START
>>  	hex "Virtual address of kernel base" if KERNEL_START_BOOL
>>  	default PAGE_OFFSET if PAGE_OFFSET_BOOL
>> -	default "0xc2000000" if CRASH_DUMP && !NONSTATIC_KERNEL
>> -	default "0xc0000000"
>> +	default "0x72000000" if HIGHMEM && CRASH_DUMP && !NONSTATIC_KERNEL
>> +	default "0xb2000000" if CRASH_DUMP && !NONSTATIC_KERNEL
>> +	default PAGE_OFFSET
>
> [Severity: High]
> Does changing the default KERNEL_START away from 0xc0000000 break KVM guest
> exit on 32-bit Book-E hosts?
>
> On 85xx and 44x, interrupt_base is linked at KERNEL_START (now 0xb0000000
> or 0x70000000 by default), but kvmppc_resume_host in
> arch/powerpc/kvm/booke_interrupts.S restores the host SPRN_IVPR to a
> hardcoded 0xc0000000:
>
> 	/* Restore host IVPR before re-enabling interrupts. We cheat and know
> 	 * that Linux IVPR is always 0xc0000000. */
> 	lis	r3, 0xc000
> 	mtspr	SPRN_IVPR, r3
>
> The first host interrupt or exception after guest exit will jump to
> 0xc0000000 + IVOR offset instead of interrupt_base and crash the host.

I see, so this was already broken if manually configured to
something else, or if someone had tried to run a KVM guest
from a crash dump kernel.

I would add this as a preparation patch:

--- a/arch/powerpc/kvm/booke_interrupts.S
+++ b/arch/powerpc/kvm/booke_interrupts.S
@@ -230,8 +230,8 @@ _GLOBAL(kvmppc_resume_host)
 #endif
 
        /* Restore host IVPR before re-enabling interrupts. We cheat and know
-        * that Linux IVPR is always 0xc0000000. */
-       lis     r3, 0xc000
+        * that Linux IVPR is always KERNEL_START. */
+       lis     r3, CONFIG_KERNEL_START >> 16
        mtspr   SPRN_IVPR, r3
 
        /* Switch to kernel stack and jump to handler. */

>> @@ -1298,7 +1302,7 @@ config TASK_SIZE_BOOL
>>  config TASK_SIZE
>>  	hex "Size of maximum user task space" if TASK_SIZE_BOOL
>>  	default "0x80000000" if PPC_8xx
>> -	default "0xc0000000"
>> +	default PAGE_OFFSET
> [Severity: High]
> On 32-bit Book3S KVM hosts, does lowering TASK_SIZE and PAGE_OFFSET leave
> host kernel segment registers 7..11 (or 11) unrestored on guest exit?
>
> LOAD_GUEST_SEGMENTS in arch/powerpc/kvm/book3s_32_sr.S overwrites all 16
> segment registers with guest values, but LOAD_HOST_SEGMENTS only restores
> the 4 segment registers 0xc..0xf (0xc0000000..0xffffffff):
>
> arch/powerpc/kvm/book3s_32_sr.S:LOAD_HOST_SEGMENTS {
>         li      r0, 4
>         mtctr   r0
> 	LOAD_REG_IMMEDIATE(r3, 0x20000000 | (0x111 * 0xc))
>         lis     r4, 0xc000
> 3:      mtsrin  r3, r4
>         addi    r3, r3, 0x111     /* increment VSID */
>         addis   r4, r4, 0x1000    /* address of next segment */
>         bdnz    3b
> }
>
> Because switch_mmu_context() -> update_user_segments() only reloads
> 0 .. NUM_USER_SEGMENTS - 1 (segments 0..10 when TASK_SIZE is 0xb0000000, or
> 0..6 when TASK_SIZE is 0x70000000), the host kernel segments covering
> 0xb0000000..0xbfffffff (or 0x70000000..0xbfffffff, plus any module/execmem
> segment below PAGE_OFFSET) retain guest segment register values after
> exiting the guest.

I guess this is enough?

--- a/arch/powerpc/kvm/booke_interrupts.S
+++ b/arch/powerpc/kvm/booke_interrupts.S
@@ -230,8 +230,8 @@ _GLOBAL(kvmppc_resume_host)
 #endif
 
        /* Restore host IVPR before re-enabling interrupts. We cheat and know
-        * that Linux IVPR is always 0xc0000000. */
-       lis     r3, 0xc000
+        * that Linux IVPR is always KERNEL_START. */
+       lis     r3, CONFIG_KERNEL_START >> 16
        mtspr   SPRN_IVPR, r3
 
        /* Switch to kernel stack and jump to handler. */

However, I have the feeling that there are other code instances that
make an assumption about the 0xc0000000 start. This may take a while
to find. On the plus side, both Christophe and Richard have been
able to run ppc32 kernels with the previous version of my patch.

        Arnd

