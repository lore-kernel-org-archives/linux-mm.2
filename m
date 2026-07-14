Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BDA6C44508
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 10:26:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 787F36B008A; Tue, 14 Jul 2026 06:26:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 737536B008C; Tue, 14 Jul 2026 06:26:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 628F06B0092; Tue, 14 Jul 2026 06:26:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2A31F6B008A
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 06:26:37 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AB6F5A02AE
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:26:36 +0000 (UTC)
X-FDA: 84987003192.22.AA9DB8B
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf12.hostedemail.com (Postfix) with ESMTP id 95FD540007
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:26:34 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=X1UcKjUP;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=DPgDPUNa;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=X1UcKjUP;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=DPgDPUNa;
	spf=pass (imf12.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784024794;
	b=Aj5uhmwwSf68F0YLmdagXg49D3NWxdaZ3SKVmG4nygSCK2uO/2NkqwWqR8yGYB2v4eO7DY
	4/FNzPMost3ZSXCfwaJo+ei0/IQSIR1ApoUyhGCpB0pXgNmPlkQYChSbA/ou9lVRyR55it
	gfNHf6H19R8Pt1nJdGyEriO/Se7frb4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=X1UcKjUP;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=DPgDPUNa;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=X1UcKjUP;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=DPgDPUNa;
	spf=pass (imf12.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784024794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=khB/to3aOpUTgGTf59zKb1ob5wdV92G9QJtQXjDAoS4=;
	b=dK2TaGbmM8JKBmR0bD/vIAoER7cDkFI1/zIIPz09qRZ8rMqGUSWl81HrdvNbmL/OaWgWnV
	/nDt86nDNEkIb9dWcXNTo02k1L52EBLIOw7q7iisizd+MIYajJMeABbKnbfh8uIG7zO8Te
	YPgk5sObPaeJwpSOcVXelSv6jjsYZzw=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 134CB75D55;
	Tue, 14 Jul 2026 10:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784024793; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=khB/to3aOpUTgGTf59zKb1ob5wdV92G9QJtQXjDAoS4=;
	b=X1UcKjUPwFCkcvM34/QaEi0GeBdnyXah3hmHi1D8Poz47UB712qXIXRaJG6edsNfbG2ZA+
	z5cB65T9O/OYv5qY43ugJDHwVaTgllfBIZ9UaWwkNvt07EqCc4MfDsXlOrzcTa1ljoJsh8
	ZREca7S8uqp/stNOGwDBdmvskz1XeX0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784024793;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=khB/to3aOpUTgGTf59zKb1ob5wdV92G9QJtQXjDAoS4=;
	b=DPgDPUNaL/Uj8oEf2qMTyo3J81KosNcpxLKOMxymAIDnO1BMA1vluTZ6/clWzrYO9GdgP4
	w321jUwSCwkNL+AA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784024793; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=khB/to3aOpUTgGTf59zKb1ob5wdV92G9QJtQXjDAoS4=;
	b=X1UcKjUPwFCkcvM34/QaEi0GeBdnyXah3hmHi1D8Poz47UB712qXIXRaJG6edsNfbG2ZA+
	z5cB65T9O/OYv5qY43ugJDHwVaTgllfBIZ9UaWwkNvt07EqCc4MfDsXlOrzcTa1ljoJsh8
	ZREca7S8uqp/stNOGwDBdmvskz1XeX0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784024793;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=khB/to3aOpUTgGTf59zKb1ob5wdV92G9QJtQXjDAoS4=;
	b=DPgDPUNaL/Uj8oEf2qMTyo3J81KosNcpxLKOMxymAIDnO1BMA1vluTZ6/clWzrYO9GdgP4
	w321jUwSCwkNL+AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0B7FB779AE;
	Tue, 14 Jul 2026 10:26:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PH4iO9IOVmoNJQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 14 Jul 2026 10:26:26 +0000
Date: Tue, 14 Jul 2026 11:26:20 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org, linux-arch@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, x86@kernel.org, 
	linux-mm@kvack.org, kasan-dev@googlegroups.com, linux-csky@vger.kernel.org, 
	linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org, david@kernel.org, 
	linux@armlinux.org.uk, akpm@linux-foundation.org, ankur.a.arora@oracle.com, 
	rppt@kernel.org, linmag7@gmail.com, chleroy@kernel.org, klarasmodin@gmail.com, 
	chenhuacai@kernel.org, kernel@xen0n.name, kas@kernel.org, zhangtianyang@loongson.cn, 
	wangyuli@aosc.io, tsbogend@alpha.franken.de, ljs@kernel.org, jgg@ziepe.ca, 
	catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, ryan.roberts@arm.com, 
	pasha.tatashin@soleen.com, rmclure@linux.ibm.com, baolin.wang@linux.alibaba.com, 
	tj@kernel.org, kevin.brodsky@arm.com, anup@brainfault.org, 
	atish.patra@linux.dev, pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	alex@ghiti.fr, dave.hansen@linux.intel.com, luto@kernel.org, 
	peterz@infradead.org, tglx@kernel.org, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	kasong@tencent.com, baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, ryabinin.a.a@gmail.com, glider@google.com, andreyknvl@gmail.com, 
	dvyukov@google.com, vincenzo.frascino@arm.com, anshuman.khandual@arm.com, 
	yang@os.amperecomputing.com, chaitanyas.prakash@arm.com, ardb@kernel.org, guoren@kernel.org, 
	yang.li85200@gmail.com, viro@zeniv.linux.org.uk, dinguyen@kernel.org, 
	schuster.simon@siemens-energy.com, wangruikang@iscas.ac.cn, junhui.liu@pigmoral.tech, 
	muchun.song@linux.dev, vishal.moola@gmail.com, namcao@linutronix.de, pavel@kernel.org, 
	djbw@kernel.org, yu-cheng.yu@intel.com, baolu.lu@linux.intel.com, 
	Jonathan.Cameron@huawei.com, coxu@redhat.com, andreas@gaisler.com, liam@infradead.org, 
	vbabka@kernel.org, surenb@google.com, mhocko@suse.com, geert@linux-m68k.org, 
	shorne@gmail.com, jonas@southpole.se, stefan.kristiansson@saunalahti.fi
Subject: Re: [RFC PATCH 02/34] ARM: mm: make 2-level pgd_t a scalar
Message-ID: <alYL7B0HAvmLVHGU@pedro-suse>
References: <20260713135614.1618183-1-yeoreum.yun@arm.com>
 <20260713135614.1618183-3-yeoreum.yun@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713135614.1618183-3-yeoreum.yun@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 95FD540007
X-Stat-Signature: mr7mt1g1ec8gsdda9dbtmh4q7aewm4rf
X-HE-Tag: 1784024794-635686
X-HE-Meta: U2FsdGVkX18qV82CpjnqVrvIhFOdStId0bCq0sY7+vKMq1MjfoBjzbIQOfti4j392xhvSxpLQzZNc3pwKBhUWNvvDQhtoP9UAtH+DuOGNXuMRz7Cp+O3hKsGXl8bEHsUzNLxN0eLDOJvwcYlLrsP1dtyP+5qjktvtg3RzMpJKnfVfeT5loTYknmRz0B+TFtNn2zDhYn3muVuzd46mIfODP8A2Wgeqb8GG/RwKyMntBEGfEEynM1hiorWyyAJXAmRVrqYWDJf+r3mQmThcX2N7EUIR1f1e8gzbyiN1h7BG6LWSUBDj93l5lVAHC7npE5DMA2gYCFB/8fmvaKON6HrYPk35DRlLVtD424hbVgcACwiFvfkcrH3O0rZO8FTM3/sLI4LKbsDgeQIHUXPXyoYo/PJit/Q5DplKpm/qGUq9r6YZVcedlFsTprWLx4OsL6+IvFR4fHPSfMYgRU3c4Fl+vQn2bn+tpnDUHKk2VE+7qQ/Tcu9TJEKCSvBvREE4rfdlfAa9YUwGuDdEIJX2PYlAoSZw1W8TdBIpchHSdPYdAKFuvTNgxRTdvFCPxXEowZ644Rp779YfvOLVAeyfJdIKgdC40H4M+b0PPDJL+vWjCpfPMe4dFHswN0dI95ZvZKD9MuUO/2UXlG9yUjQvWjUeruZvBylfK4jKsSQXz9+ZH9Ce7SHTbgz9H3ua0iD/fAgLlZejzNWXdn/J2gqP7RDqA1pQOKgjvs1RJ/F+KciHlaqZM9pxPDLUWSt0kUlq2gigBEo/+avyO2uBdv0YoVYZVH4D66jW+p3Zyr6Y1mk9w/ppasPJvtcc8JjkABnEwLbbcvFzmkg7LP5u9xyoBksEbJZfSSvtFlGwmL/2oLQAGxPPtEeYAunBscX3hWeUb4iG7qqKByyv7B4evpPIwvK4oJQ3MV8cceBYooGrs6q5GHAgyd0k18Eo0sSxFW8L4wIiIEdrTZbP2zlzG1TUaX
 cASRDm56
 4O72YIMmDKGYOcscG3poPmUPBgwk6cleCyOonvr0am11aHy2FblEhW3zuyMtvge1rTKwqp8A2iJ+VBvQC551UHFNJ4mHp6+1hi/zpS7zcLu+z8wYqY/We48cFGqIN8o1+GpOZjhdujteqpmhChupt5Wbq9UPmEJiaJLX7NP4Cp88p+WtwmnS5a5ggCNt9s7DbMmYx+l6SgrDFX+cKRhzdDZYkFyDjKSGaRmTCycQtTMuuZUsNBvroPr5RuKwn3I02BkgoO/wWRaZzGVcUpOk3yMPRWtbYqQn7PO4gWFHiVMaepu7PMYa6h68dFfhtNBRXvssYs2JM2RYdPLngPZb+0YXa7vMbT+o+LfcMSIRtjPaFuf8ZfmTuIXgdd9KISuTppRnRWnrDI74PsdS83ACiJFyDCPzLKecazt0RueL18bS2r2yCTCTatyMfcr8OMGedmPPdr2pwDxwTd/P5XFc/lGRgUQCIKikR8nHJVuNPnsBH43NCek1nCVYV6STjc5vJ2fnCnmYJbW+Zznifq0i+j7dxzq8ski3kqRskmm/JCYnCtL63nfB6gFkaMA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 02:55:41PM +0100, Yeoreum Yun wrote:
> From: "David Hildenbrand (Arm)" <david@kernel.org>
> 
> We don't want pgd_t to be an array, as it prohibits returning it from a
> function, like pgdp_get().
> 
> So let's just use an u64, and extract the right 32bit value in
> pgd_val().
> 
> Leave the STRICT_MM_TYPECHECKS case alone for now.

I have to ask: is there a good reason for the STRICT_MM_TYPECHECKS ifdef?

I see the compiler has an awkward time returning a u64 struct (see
https://godbolt.org/z/qejbv6j9a), but if this doesn't work maybe we should
get rid of the STRICT_MM_TYPECHECKS stuff? I seriously doubt anyone is
purposefully toggling it on for testing from time to time.

If STRICT_MM_TYPEDEFS's worse codegen doesn't matter then maybe we should
permanently toggle it on.
> 
> As an alternative, we could use the STRICT_MM_TYPECHECKS approach here
> as well, but using an u64 looks conceptually cleaner, even though
> pgd_val() gets a bit more involved.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---
>  arch/arm/include/asm/pgtable-2level-types.h | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/include/asm/pgtable-2level-types.h b/arch/arm/include/asm/pgtable-2level-types.h
> index 650e793f41429..02052cef9437a 100644
> --- a/arch/arm/include/asm/pgtable-2level-types.h
> +++ b/arch/arm/include/asm/pgtable-2level-types.h
> @@ -25,7 +25,7 @@ typedef struct { pteval_t pgprot; } pgprot_t;
>  
>  #define pte_val(x)      ((x).pte)
>  #define pmd_val(x)      ((x).pmd)
> -#define pgd_val(x)	((x).pgd[0])
> +#define pgd_val(x)      ((x).pgd[0])
>  #define pgprot_val(x)   ((x).pgprot)
>  
>  #define __pte(x)        ((pte_t) { (x) } )
> @@ -36,14 +36,21 @@ typedef struct { pteval_t pgprot; } pgprot_t;
>  /*
>   * .. while these make it easier on the compiler
>   */
> +typedef u64 pgdval_t;
> +
>  typedef pteval_t pte_t;
>  typedef pmdval_t pmd_t;
> -typedef pmdval_t pgd_t[2];
> +typedef pgdval_t pgd_t;
>  typedef pteval_t pgprot_t;
>  
>  #define pte_val(x)      (x)
>  #define pmd_val(x)      (x)
> -#define pgd_val(x)	((x)[0])
> +
> +static inline pmdval_t pgd_val(pgd_t pgd)
> +{
> +	return (*(pmdval_t (*)[2])&pgd)[0];

Ugh. This isn't correct C code. It only works because the kernel passes
-fno-strict-aliasing. I would recommend either forcing a struct here, or
using a u64 with bitmasks/shifts.

-- 
Pedro

