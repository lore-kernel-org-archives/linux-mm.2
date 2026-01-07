Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9416ACFD647
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 14:48:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 017486B0088; Wed,  7 Jan 2026 09:48:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F06DA6B0093; Wed,  7 Jan 2026 09:48:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE8406B0095; Wed,  7 Jan 2026 09:48:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CFBD66B0088
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 09:48:42 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2DBB016034D
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 14:48:42 +0000 (UTC)
X-FDA: 84305449284.03.E11B5B3
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4C22380010
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 14:48:40 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=gfgvtMRN;
	spf=none (imf30.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767797320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+xIhfMAtjHYjFTH+p76wSQ0KBZqEgJllYmQCn9tPHTw=;
	b=ZAbO0iRDIgZLlTYIseNTJmEcyXlp39HrJatPT9T7oWjJdwEZy42r0nNrshX5sTalK+CroD
	YAIBVEczYhpweCE6dyvP7Xqfii7tMfKTJxMQvMMlVVLancoVBdKWOCyPYyQ3QuGqDUP7O9
	Evb/YmFWEsRyzRc1d3hx5LuqSXaEcSc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=gfgvtMRN;
	spf=none (imf30.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767797320; a=rsa-sha256;
	cv=none;
	b=ETX2rrpZSodgYrwvoqnx+tv4ld1FfqACK5WAq+phdEMuh9OaEofATXzUoh8URdh/BL6ezO
	MbVsCP+RjbEGLLU9ggVgXQwziYHQJyXIAjnZJ1PMWZbYVr6u3qSQdxIwiHq8g7xKO3oY2+
	MBxSmfhs+98y6OncKBd3TlGyVrYqKlI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+xIhfMAtjHYjFTH+p76wSQ0KBZqEgJllYmQCn9tPHTw=; b=gfgvtMRN85Hh6ULIivj+/lsOiA
	MybjhOoCgrIWL+bUF4ZEyrlnJ3BCKR4kow6Y6NDL92/3cFJxBWTaKb1rIOfGBe+Dw0TMz+F6hTAg8
	Crnru+IpjVNRY8M3Yo5pEqYsNvsbroxjMFB+JLG+kn8JUv7wu/qgJNEaHLWZYnCI/h9377j2QaiDj
	Wp4USeOE/onY3OPFlzQZveXDAm1UarU5jmZ6+7+4LDv4lZECvq9bRsaYpa+NQlBAndtaGIh51toTF
	IydUvltqxiSopJRhJfdcYVF+WCRW6z7IOhoMVL5JAXrCp/2naH+s5TUY9eMaE3iE1xilEVS8ykNR8
	zYY+BTvw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vdUpO-0000000DVbI-1rdl;
	Wed, 07 Jan 2026 14:48:02 +0000
Date: Wed, 7 Jan 2026 14:48:02 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Alex Shi <seakeel@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>, alexs@kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Vineet Gupta <vgupta@kernel.org>,
	Russell King <linux@armlinux.org.uk>, Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nick Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Guo Ren <guoren@kernel.org>, Brian Cain <bcain@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Michal Simek <monstr@monstr.eu>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Dinh Nguyen <dinguyen@kernel.org>, Jonas Bonn <jonas@southpole.se>,
	Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
	Stafford Horne <shorne@gmail.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Helge Deller <deller@gmx.de>, Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Rich Felker <dalias@libc.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
	Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>, David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	"open list:ALPHA PORT" <linux-alpha@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>,
	"open list:SYNOPSYS ARC ARCHITECTURE" <linux-snps-arc@lists.infradead.org>,
	"moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
	"open list:MMU GATHER AND TLB INVALIDATION" <linux-arch@vger.kernel.org>,
	"open list:MMU GATHER AND TLB INVALIDATION" <linux-mm@kvack.org>,
	"open list:C-SKY ARCHITECTURE" <linux-csky@vger.kernel.org>,
	"open list:QUALCOMM HEXAGON ARCHITECTURE" <linux-hexagon@vger.kernel.org>,
	"open list:LOONGARCH" <loongarch@lists.linux.dev>,
	"open list:M68K ARCHITECTURE" <linux-m68k@lists.linux-m68k.org>,
	"open list:MIPS" <linux-mips@vger.kernel.org>,
	"open list:OPENRISC ARCHITECTURE" <linux-openrisc@vger.kernel.org>,
	"open list:PARISC ARCHITECTURE" <linux-parisc@vger.kernel.org>,
	"open list:RISC-V ARCHITECTURE" <linux-riscv@lists.infradead.org>,
	"open list:SUPERH" <linux-sh@vger.kernel.org>,
	"open list:USER-MODE LINUX (UML)" <linux-um@lists.infradead.org>
Subject: Re: [PATCH] mm/pgtable: convert pgtable_t to ptdesc pointer
Message-ID: <aV5yIuGi9Ni5YP5E@casper.infradead.org>
References: <20260107064642.15771-1-alexs@kernel.org>
 <aV4h5vQUNXn5cpMY@kernel.org>
 <080e493a-e4f1-4c97-a3e1-f76f126b5213@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <080e493a-e4f1-4c97-a3e1-f76f126b5213@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4C22380010
X-Stat-Signature: ftwcun8udq3z5xts16un5848hj8sf7ai
X-HE-Tag: 1767797320-977982
X-HE-Meta: U2FsdGVkX1/ZNTN8fQ2Z/v5wM8XVB80pB3+prE0kii2k9UMmlQ7yKLCZHN50NS/YEcv5jbg2uhsdo9PMd4PkI/4zA6quPU9nsGuLN/2eg7cd//qpboKgsktaffLOQF6GKimxa3Z8U/Q5dTkZU5N6YsgAt0ffiPPmh0PRC4+uYR9zQGdqU71ehnWinG7GaqxKljmqMiht1AXbfG/mYRY3Va6GQI3M4iaUty3CY+4EoSn7rHoGkXUj45EU4yAuHlzJvbQ9W6DKtPBuJ3p43OgYq/wJPCgXAktW8r8/h7vrZTIS3B1AgKrOZmOd0eFWuZa8W66cM9l22hddfns3GFRvyTm1OPdLKIMxmilibBu/yNrmS5O3tzBzYGPazt7tlQ5gEuJmoruSg2TtEOSDml9Mi9WE5V6P5vnbzdXWgO3f7d2rYINHIN0PibVO1M4VdzOFAclQ77lBFHyCXNNiu7Rm8S2ebc1xvLgNJnganwv84zwKysuJH67Lj3C0mvT93/AcSkuTyMRB91HtdaYLNnuM+mGCGnTH2aDYr67KZO0bRt4DcRwRuMGraAV2cg3NPNYxNE8T/+muuogBwHi+favR4Ys/cVvp3nbPp7sCyIyMTUwPzqNW/CdDXx45wqmilWD7Jqev7O+g7OxLz55Oe7mvnprKO8PRKxSw22sPPKTe69fQy5ImAMU/9rE2mE/wm2m0L52fpVwMrjuVXWxlD2vJqT3woUdSCs85JpieoFNbPhTnCa0cCxpEYN3lmkSynOJQrO37vQSuCCt8PUL+5UWCybj1u0X010BnMHAZBcp6w68UflfLjPRhEeRi72+Np5H5q8RUIFH3t2dFEuxOlTdixA7OWvYWD4L90CpMAWjtSniOlKrps0N0Hw9EMBVwSJ3zRheduk7I/2woSX1NbXecz7di5r0mKoVqMqESq/9YzuGpUPI3H7AxW5qsvsP4TstX12DMycTn62qs0SAhulM
 OrbpXEug
 Z+NqzsFtAOhMgolW1XLSIOaKikNqPqKDGI8XvG6iJn7ljQhKPzLVWGHH3HMlTtEuK55BkT/FsI42Y+FI+1AsVsW+kmpSuUgd3nBr0uryVkQrLdJRvFRtzZaUpR2BNIoWuRvbbp8TYGxAORlmBKzmcZbNUsZrUMXbAhZsCWxHk23yfYooW50d1WPeWAkvM3NzbxuXLN2W1AsQIrcMxlA1YdDtcE9KsU/r0aLoQRdTxG5CVnISxIhkrnk9QQ1zVyIrZNOlnGrbO9rPkR+u8HnaYHX0GuWEW4W0LOebdwTebmf7jz4E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 07, 2026 at 05:28:36PM +0800, Alex Shi wrote:
> Right, I will fix this. and sent the 2nd version.

No, the patch is stupid and wrong.  Don't send a v2.  You seem to have a
hairtrigger resend, so I'm trying to prevent a v2 being sent instead of
sending a patient reply.

