Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D352DCCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 12:31:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1872E8E000C; Fri,  7 Nov 2025 07:31:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15EFE8E0002; Fri,  7 Nov 2025 07:31:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09BA48E000C; Fri,  7 Nov 2025 07:31:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EFD8E8E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 07:31:52 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0796E1A0469
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 12:31:51 +0000 (UTC)
X-FDA: 84083747664.16.9071AE0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id F3937180013
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 12:31:49 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762518710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=riGlcmndbsVNq1RBdZCHUXalg5T8zJw1ELQJ4dXOoec=;
	b=ohSlGt6NuZu3wjzpvFGddILbxGXXdXWpiRDJjrb3vShbp5ioVpYh7TXB0DUelH8dnDl8j2
	vpSAr/Wa4mVy3XCfY81VEqpqsgK9kwW+dr24aN/p+xY9My7ska4cLA+Uk7/umt1j2XOD2F
	1nphlKhVcWURUbnI9xWFCUKsvCRIzNw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762518710; a=rsa-sha256;
	cv=none;
	b=HaFFNriU3yj9u2rCxTyiLPjp9E8mmIwc0ufsNfc8JA7mVYBc3mjNLSa0/ARRnR7DCubUJs
	/oa+eZg0QIuER/M66JPU8utXUX6s5H6z5OWeqMPEXKIW1Yr+ww/lU8DwinwvCswfPIR0Aj
	vOR6RAHl5myPOoklvck9N3M5qTiZuZA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2C3C81516;
	Fri,  7 Nov 2025 04:31:41 -0800 (PST)
Received: from [10.57.86.134] (unknown [10.57.86.134])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 412D63F66E;
	Fri,  7 Nov 2025 04:31:44 -0800 (PST)
Message-ID: <b165098a-8164-4664-aaaf-1e8c4391d797@arm.com>
Date: Fri, 7 Nov 2025 12:31:42 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 02/12] x86/xen: simplify flush_lazy_mmu()
Content-Language: en-GB
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@redhat.com>, "David S. Miller"
 <davem@davemloft.net>, David Woodhouse <dwmw2@infradead.org>,
 "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
 Jann Horn <jannh@google.com>, Juergen Gross <jgross@suse.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Suren Baghdasaryan
 <surenb@google.com>, Thomas Gleixner <tglx@linutronix.de>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
 xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251029100909.3381140-1-kevin.brodsky@arm.com>
 <20251029100909.3381140-3-kevin.brodsky@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20251029100909.3381140-3-kevin.brodsky@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: F3937180013
X-Stat-Signature: rt4g3p3m87cziyi18wnxamu8h5g1kjjg
X-Rspam-User: 
X-HE-Tag: 1762518709-807033
X-HE-Meta: U2FsdGVkX18i4YcVFgnTq8QRqDLxggIlbBaJDR7SLNQFjLKH7ce6v9PNtc5DIbNcKATOMR0Q8B5FiJFnh3Cdo/7KpDIOova0TToMe24lxoeW2BKQQweb+j7pSTQKQYhLhWtUCVC49woMp7hK4wIdIfKpHRlpW5ubtlU5IoxP6HcCvF/MzhGLMElZj8N+IpSR7FwFlguIhh2pkXyfzyFqvYsjuJ+OJ+JYS8A/BK+KjwthTjQ4gogMkOEFE/NLXE71u89OY4l6IOuREEVeyNStnROf+ITYTsaeLhdZDitLO4vp3iQJjoBRBrzO8bpRLmSJ53mH1NKJgmy6Fr4HQHuvYudRaFb5qFXGg219l1wXNQQIqpgwoNgwF6lmeDRZt3ZlGetqBImxuzS1LVAorGoLx9BPOaK9NFRmAU7+8S0y0LUNHDy8xieNQqdqB2eG2f86bBINiz0rGMjO5X5LhtXCPiABgDxkDuYNPwmICGySpBsj30sRsUyAG91f3wHs7iWMdwmBoGN4IbH0Y7hAfrdXAj3iNabTIm7MjQctCRSBJ28nLtA+1Hu1JM0Kub4Kxss1KmIXfgrh2nqXmDxjcLO3VIw9zA7uWmRdzW8NJO/mSaAeJGf32PMpHVc7QJY3eRtD9nw/DItbYGmo5DRIFoCQamiwSl3m6InyOvHHnaAcNByFXrE3Uk5yzwR1eg5XcmrDsMeZudJwsu+o10hccuYzYuxo0ozhEY/IXpuge6PZNAT7UCxglsqJkSnJ6o6DTg1q8NRHRBEetKm0d0xTGovAwpWSUXBdLrrDBDz09UGXf1xJa08GYKhz0XEjhYVfmfuNvvBNZRqbfHQr3G2csDXBgTJjt6vm8DL0b360JGa1p51NpfAgjaRMU0TH9djsB/M+oiA0wu6syppje8eok/L68ev5R8V3WELrZLYdlrgfbyVddcaK3MyoIX4TgK7OXeUWX3TuYVn+M6umPu5C6UG
 vX0OFgNF
 LXMLpI//gmpJzl90ZM/MTbK9RoK0qj7VYeCOE/5ngoARGMEblDtQOHy5kHCZnu/Z0ag6pI2PFJcY/iHEwiOVY4jOpYK2hc53h19CtKY42dpDB81/5uarD7NB9zkZTbbQntlGmK8SgqadbBN6EkCz4YPrvpp78VwRO6rtyR/nH+r02uxlTBZtcMVjEH6+JfVzOFHXAwrCt8mHolxs1ob+vZ3G836hyan/5eBGfWQhEwby3w/RMg1k9fo1+5Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29/10/2025 10:08, Kevin Brodsky wrote:
> arch_flush_lazy_mmu_mode() is called when outstanding batched
> pgtable operations must be completed immediately. There should
> however be no need to leave and re-enter lazy MMU completely. The
> only part of that sequence that we really need is xen_mc_flush();
> call it directly.
> 
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>

This looks functionally equivalent to me, so:

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>

But I don't think this tidy up is strictly necessary for your series to work?
(perhaps I'll change my mind on that as I go through it).

> ---
>  arch/x86/xen/mmu_pv.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/xen/mmu_pv.c b/arch/x86/xen/mmu_pv.c
> index 2a4a8deaf612..7a35c3393df4 100644
> --- a/arch/x86/xen/mmu_pv.c
> +++ b/arch/x86/xen/mmu_pv.c
> @@ -2139,10 +2139,8 @@ static void xen_flush_lazy_mmu(void)
>  {
>  	preempt_disable();
>  
> -	if (xen_get_lazy_mode() == XEN_LAZY_MMU) {
> -		arch_leave_lazy_mmu_mode();
> -		arch_enter_lazy_mmu_mode();
> -	}
> +	if (xen_get_lazy_mode() == XEN_LAZY_MMU)
> +		xen_mc_flush();
>  
>  	preempt_enable();
>  }


