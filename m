Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E39C606A326
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 12:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=epteBc3c
Received: by kanga.kvack.org (Postfix)
	id 9F5E56B05B3; Tue,  3 Nov 2026 07:56:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A7716B05B4; Tue,  3 Nov 2026 07:56:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BC716B05B5; Tue,  3 Nov 2026 07:56:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D6286B05B3
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 07:56:44 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 86F04803DD
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 12:56:42 +0000 (UTC)
X-FDA: 85393807044.24.C68A383
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf31.hostedemail.com (Postfix) with ESMTP id 5D80E20005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 12:56:41 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=epteBc3c;
	spf=pass (imf31.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793710600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=550l5NSMeWOUt7dSUoYx2SoXWS5kNeVAAxHhUo7UaiA=;
	b=4BBewL/JjTWsl3yherveeApavVz2MW3vYP7w9OF8xjW6nUvwU4I5TStrwSGBnpmPBiYo1/
	LaVcwf/VE/f6xsn5vcBvl0LAGGFg2vG2sPfsINFeMJt6I5kZrO2xTsJQwB7dzVyVnq5NEK
	0hCaz2wstniUIQb28ChqR9CkUF6BG7I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793710600;
	b=48lbY1iR+yBasvzkAbRsimSI7EIfscbuHkwxiiCZ3W4tWuR4PICuTxS/IyZcGmAVI4zZgN
	R9+X0Np+azWnR4kAFlcwaanFrCOPOT9ey3xwwwHXoL7FKJnpQbd6ibcDmDZmMeHvm6alAv
	ikGArhAmBAGsnVgqwbx2sEVB5BibPuk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=epteBc3c;
	spf=pass (imf31.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=550l5NSMeWOUt7dSUoYx2SoXWS5kNeVAAxHhUo7UaiA=; b=epteBc3c0oZ2Npdn5lECSkbDTS
	FobmpV3xqhG7OFfwgB8aLkGeR8ld8/+b7zcIMyEzlnCwzm30dvjvEBNPCVZwU+IdtMUovIDxbiWGv
	X14cqkR5y8A9ESIkPEP/0/6VgzHuW31nu8AmU3Ssqsna3e/liMq4HbBbacIhKqOW3rpos8s6tbWWz
	zP90acGfsxti7EbzLW+52879NbHnKpR5G+n39Fr9+8TD+wAQ6Oiv44lEzW+RaDi5v76LbrVN+eH8Z
	+qT9ICB20WKnZIGx8uTMhEZ7uV4djBp2jCIPWJ02O49ZrEhBVhIqPc1abpfxE5pw1AexIRGkyxHau
	dkUHmZzg==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xOE41-00000000SpM-1jHB;
	Tue, 03 Nov 2026 12:56:33 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 85719300322; Tue, 03 Nov 2026 13:56:31 +0100 (CET)
Date: Tue, 3 Nov 2026 13:56:31 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sashal@kernel.org>
Cc: kernel test robot <yi1.lai@intel.com>, oe-lkp@lists.linux.dev,
	lkp@intel.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Kiryl Shutsemau <kas@kernel.org>,
	Finn Thain <fthain@linux-m68k.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ard Biesheuvel <ardb@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Boqun Feng <boqun.feng@gmail.com>,
	Daniel Borkman <daniel@iogearbox.net>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>, Gary Guo <gary@garyguo.net>,
	Guo Ren <guoren@kernel.org>, Hao Luo <haoluo@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Jonas Bonn <jonas@southpole.se>, KP Singh <kpsingh@kernel.org>,
	Marc Rutland <mark.rutland@arm.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Rich Felker <dalias@libc.org>, Song Liu <song@kernel.org>,
	Stafford Horne <shorne@gmail.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
	Will Deacon <will@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: Re: [linus:master] [atomic] 80047d84ee:
 WARNING:at_include/linux/instrumented.h:#__split_huge_pmd_locked
Message-ID: <20261103125631.GZ1779021@noisy.programming.kicks-ass.net>
References: <202611022259.def3e086-lkp@intel.com>
 <20261103122647.GL1813469@noisy.programming.kicks-ass.net>
 <20261103123508.3910990-1-sashal@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261103123508.3910990-1-sashal@kernel.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5D80E20005
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 9mh7fjka6gg7jsi38kejn7gfm4t8csq5
X-Rspam-User: 
X-HE-Tag: 1793710601-879817
X-HE-Meta: U2FsdGVkX1+szABkfW2P4dNb32Bjcxq7+UStZVCTpnadqBMhWOooKdbveyiL/04g9X4bR70R/SDI0PuYWymQte9V1+CIOfTPKXLhegF7XTyLkSSgPJDpHOyFSvwSrD9uVJX1pGSGX03JycIn7GhnkWJ+ctDYSBDWNw9sFJQLM+vD8fOGWfdFVWItDQUCpZ5pUT5uOjI8JixQg2/DDAdAluDiEGXjCGXyCzZEjdmHnISI5GPAZRzup08U9ISf+Tjgv8aGilw9QOL2yyxIPv+PyeAw1fvM3GOSh5yTrJAGyOUHMNvRrfWFlEhoPaAGT3Sm/slujT+bcUCaEqym/VjQB83brPRh8sCNz5W93Xc9z7E+T99GTp/tvVJoD91O6qz8hCYxO3D59cDwLQi7hxK2Tn0Cdub8uwuL0AyMsVlPespW/h4pXtF2ZWb6xO5GkdmR6tnADJO+sNU1RpAv96Dbji/yf59+CbESckrliwyAQLN4CbwvjZHx+tlhnk008DqCbslpxBHgGvL6jKXcy90XtSnxSqwYKMbYb7fUf8TJwr1wGjBcEDVx3Sa+C6knHa+DGIuOVr/nbTvXB60RJFdk1BGXWcgM9Dw8op377twrdJMe3Ux619XEwjO3NWkQr4UNprhVcBUvOccd4Xa2I2OJT1t/DIxN3CcnP2T04ZUmzELZHarFBAcChOXknCq+P1/bgkZggGscw+XIaF52VGJt99YKNFSyu+U2UYyIlg3cJoIYSKUEk+m91bCknlkUxXUnu8Ji9KQiffdNGkpjgJsXFpSRvyFK9PXeXeWQzW2P+DZcHtILU6UskyOf7iP/SoA5nq3fGoi5Fsh6nCfmD2eO13J3wH1/kWuer55cayT0kOJpzzqJofP+1UVtYExcB29pcv5KbiYW9m5UFnJxX9vwS/XhlzPAnGdvvo9TI1TZm4qUc8uTb0NWMof4cFI66ZJhV3NuZfWqVQWKa/tFZU2
 oCRfGC/J
 aW6xSCPgjRrWsvltXoZ93ojwtzP6zjUwAQCW6qzUcOulXZPrQvpXPsM3FUmkX6GLeomdbewJRnscfsQphoM8kuWkuXgUNFqsD4kLpapRdGu3ygFhTEnswRrC7Eeqt8xbqUq1DtviG6sAL3F+43B7DYed2RiT1KW7eVcipl2uwFjDpt4JMo4bdFy3oXRqS8KV/20Ggpl6CHm4K4SPuVm8hUXK3BoL/iXUkH+UzVZA7NixqpPMZD8DEhFVMoGEEMIvGmF66YLYjqb53LhZcyI+z+VRXtqxwWYjai9BtihuZWV7Esp2uK6iJazQekYPSQBCpx08oKx3PF2YEGjY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 07:35:08AM -0500, Sasha Levin wrote:
> On Tue, Nov 03, 2026 at 01:26:47PM +0100, Peter Zijlstra wrote:
> > The below 'fixes' it, but the question is of course, WTF are we using an
> > on-stack pmd value for set_pmd().
> 
> The split fills in the new PTE table before installing it, and uses a
> temporary pmd on the stack so pte_offset_map() can find the table:
> 
> 	pgtable = pgtable_trans_huge_withdraw(mm, pmd);
> 	pmd_populate(mm, &_pmd, pgtable);
> 	pte = pte_offset_map(&_pmd, haddr);
> 
> __split_huge_zero_page_pmd() does the same thing.
> 
> I tried the typedef change. It works, but gcc ends up realigning the
> stack in a lot of pte/pmd code (126 more functions with Arnd's version
> in a small config, 204 with yours), including handle_mm_fault(). Just
> aligning the two locals seems simpler:

Does that matter though?

> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index bd44d58e86845..b8faa6df9bb14 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3132,7 +3132,7 @@ static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
>  {
>  	struct mm_struct *mm = vma->vm_mm;
>  	pgtable_t pgtable;
> -	pmd_t _pmd, old_pmd;
> +	pmd_t _pmd __aligned(sizeof(pmd_t)), old_pmd;
>  	unsigned long addr;
>  	pte_t *pte;
>  	int i;
> @@ -3180,7 +3180,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>  	struct folio *folio;
>  	struct page *page;
>  	pgtable_t pgtable;
> -	pmd_t old_pmd, _pmd;
> +	pmd_t old_pmd, _pmd __aligned(sizeof(pmd_t));
>  	bool soft_dirty, uffd_wp = false, young = false, write = false;
>  	bool anon_exclusive = false, dirty = false;
>  	unsigned long addr;

This will work; but it feels more fragile.

