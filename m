Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32414EA812A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 15:07:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 966056B008C; Tue, 10 Feb 2026 10:07:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 933FA6B0092; Tue, 10 Feb 2026 10:07:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 853666B0093; Tue, 10 Feb 2026 10:07:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 74B996B008C
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 10:07:04 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 04FC41B3806
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 15:07:03 +0000 (UTC)
X-FDA: 84428874768.16.7CACA62
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 26815180009
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 15:07:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770736022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sOFu981r064UEV4nZdYzmU+/xsnUioQlrTOeHah7SXY=;
	b=1iaZDCMM0TpYW6hoAy4M4R96CR6vPiPfIGiDmXKI8QHh70YxeqKIfamUp5QtKuAYPPuIYl
	FMkEw7qGppKas+bI0ep9mQHLsiN5s+RaLBgjdMPK46Ty3vWsNTtlKKHANoPo+9qA+3v2y3
	Tmammbk4YiAC2VtKBl13oYItbvTZf0Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770736022; a=rsa-sha256;
	cv=none;
	b=rnXoUVZb5jR1TrsN+FzurCa+5n98YT09Fg0KYZ4uNbyaxL6fXA13CK50FSQ72LoK+MdMnU
	MXMcCDJ7llJQ9dpm1C0X2baosvv+h3QH2yz14BAAQ4tx7RfckwHbw6v2ioPfmqP2J1yypF
	cUtExu+HjHGtKhik7Itf3q5xWXUkV7g=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 83A22150C;
	Tue, 10 Feb 2026 07:06:54 -0800 (PST)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B054A3F63F;
	Tue, 10 Feb 2026 07:06:53 -0800 (PST)
Date: Tue, 10 Feb 2026 15:06:51 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Andreas Larsson <andreas@gaisler.com>,
	Borislav Petkov <bp@alien8.de>, Brian Cain <bcain@kernel.org>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Guo Ren <guoren@kernel.org>, Helge Deller <deller@gmx.de>,
	Huacai Chen <chenhuacai@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Matt Turner <mattst88@gmail.com>, Max Filippov <jcmvbkbc@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>, Michal Simek <monstr@monstr.eu>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Richard Weinberger <richard@nod.at>,
	Russell King <linux@armlinux.org.uk>,
	Stafford Horne <shorne@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@kernel.org>, Vineet Gupta <vgupta@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
	linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-snps-arc@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, linux-csky@vger.kernel.org,
	linux-hexagon@vger.kernel.org, loongarch@lists.linux.dev,
	linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org,
	linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org, linux-sh@vger.kernel.org,
	sparclinux@vger.kernel.org, linux-um@lists.infradead.org,
	linux-mm@kvack.org, x86@kernel.org
Subject: Re: [PATCH v2 4/4] mm: cache struct page for empty_zero_page and
 return it from ZERO_PAGE()
Message-ID: <aYtJi4uNcpoCTK_x@arm.com>
References: <20260209144058.2092871-1-rppt@kernel.org>
 <20260209144058.2092871-5-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260209144058.2092871-5-rppt@kernel.org>
X-Rspamd-Queue-Id: 26815180009
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: ug11ytk5jso653rt4aryk6ujuxrmsuss
X-HE-Tag: 1770736021-702447
X-HE-Meta: U2FsdGVkX18sIeQx0jzTcYHFJlHr7BJX5cxy/KqI88o/XsI29KH4rKBSba2zs5qUwTBi3IkrTNWST9EAQfM0ObmsG2JFrFx/8L8BaPNbk24K9Ckt1R4tPF098MsacHv2YZY/Vo+uK0DXFnmgwG0vAzvntz4jAb+VCwfxsFJMV542eSvIiESg08weZYeYnK+xun5K+v07ORgq6QJ0QQbOhRdyFFJ5JkbdENJV2Mh1A5i1FF7NQ1ujaOPaFqMf8EiWqkp09eryRpOWNpLBR58Udek/mykPB7KuB3KAOVS9OADJDznmu7nCLtiEkW4oYIUAdNFd51DUP/NzD2v4GpbWZOFQThie+1UDBxId/chsnYtgyRgpdEGgCVddf6lWc941UsdcXQZXNDPK/po+eCPwJYMZtVdIlw4rh67Mo24RiZo+TWQlxaoBf1zrKQEQC2xYc5Xyt3gN8DGWVJrAD7O8jrcX52Hh6NPJKobePvTrdw5rbPfL4xfoY8m9rpKG59IehnHC+uOXfANiynvT6mNR6LNOkkNwDOq61rrU5hQnV21msXPd53iHY1MXJDjxY4tlfoLgY4RY04FT/C0/xUqE3ZSIxJJJVhkkMRBsDv93UDV7bH9wk5yWOsESpcvFxUriQoAuHIcFx1JLp0hdLAbcIfPeNLA3qVhzu45Saa+hxasE3MGgikVhdAllqTJqnzMxK04u24TYmW4p063l7zlFhlHW+7HpbCFz+dUyyq8ni+8MRnCy9AJRwlIQ885el+zPkMgRhWenYdP9DAq5zarTGvbvwK1dyDGjj/7QNAOAWsbIx3H7W89+xdCucJ1/EVvCPFBEG2jq2PsEEaGqQU00lh17xAprdjW9NHgDc9YaC0owHpFdGwXA33cksYoI/qJE45REz4ULLiRf/0Y7/aZs0TblRq5VQtUVfkx5OFQSuHxm5pGx/2G5E715l8LgtEQr4mAIsYxoDl/SWpWNixt
 qL5CBeX+
 h1zKktN/VmJfFoSiE25T/ulpO85tDpbauN0AWQ5yY1KGZoXgdj7TgsKQsk+z92ebes9KYtpi2vuEHK0oM/vRzo8l6F5XorNydhLMuO9ntQm6+6ocu7VNvEDEESvCXohxyENgDuTugIA41eUZJxv6nkhBpnshq7mz1yTuTL6SsT6Zpv08SGcBzEf+gO1jky0/rp0z+2IPwepj7QyoNt9o+vqgHf/STdmlLP/iDfr7di5gJdOEePrzXcD7kSciOvGPd9WYM50qLLMCbCF4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 09, 2026 at 04:40:57PM +0200, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> For most architectures every invocation of ZERO_PAGE() does
> virt_to_page(empty_zero_page). But empty_zero_page is in BSS and it is
> enough to get its struct page once at initialization time and then use
> it whenever a zero page should be accessed.
> 
> Add yet another __zero_page variable that will be initialized as
> virt_to_page(empty_zero_page) for most architectures in a weak
> arch_setup_zero_pages() function.
> 
> For architectures that use colored zero pages (MIPS and s390) rename their
> setup_zero_pages() to arch_setup_zero_pages() and make it global rather
> than static.
> 
> For architectures that cannot use virt_to_page() for BSS (arm64 and
> sparc64) add override of arch_setup_zero_pages().
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

For arm64:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

