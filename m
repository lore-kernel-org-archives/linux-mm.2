Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5D0B1090239
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 14:51:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 329136B04E8; Thu, 19 Mar 2026 10:51:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D9B76B04EA; Thu, 19 Mar 2026 10:51:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C8AA6B04EB; Thu, 19 Mar 2026 10:51:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 088F46B04E8
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 10:51:07 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B08CD13B51D
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:51:06 +0000 (UTC)
X-FDA: 84563100132.15.276DA1F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 00A0A10000F
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:51:04 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tlQhb5U8;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773931865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aInfBWWVLqS+IZS5bb9QXC0z00kfS+2upSPaZ4RfgCg=;
	b=CIgXucb+OLklKjM/Acv1WB9MERnL/sX86L2ezSKca4DnwXRyGx/5q7gm/hnzR4VVHjBkym
	AYVIu9WiMiNnd+AYF03goj9fgJQSz8oG602i8nSoCrvuSAyC7LVLKc59jASTchoF1iDBlZ
	EN9UrNbBdTvd4Qv71bydZ7TreRcNGjI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tlQhb5U8;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773931865; a=rsa-sha256;
	cv=none;
	b=2KBZLTLJRjOlvuDlw1KTMypcQpsK8gu8w7XKPKxGnEK5cxVxhHlzIAPXR4g4LtFjPjT/Qf
	jyiRcqpBBVWxeytPCG+zIAZOWl+uEH00uCuSYUnKZS87g274NOn4pvH2dG4OksWcv9b3OJ
	0+LJnyYLtvf0KboRl87i4v/wLAyYdyY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 492516011F;
	Thu, 19 Mar 2026 14:51:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB216C19424;
	Thu, 19 Mar 2026 14:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773931864;
	bh=NA2DgZthntn+Bg9p76vM8EhmWgvmuxh9uchtbNyldWI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tlQhb5U8pIGZhJaEn9uhM9ipP5ZvbmouNAA4Ihk1ejHR3ke0/ewxTzj1Uka5Mlbsz
	 pLFIkb5W+Mw6Rsis43iKa0qN6vLRn0ljIl1K4AqJpZBa80h16MTiD8oqj+iJM4WThc
	 kusDk2vZvs4JUK3T949S1jzI/YslUIbM6gzh5sJRM/vYH93dJ4dxbk4gkNrT+X16Rx
	 fUr3JhyrOpq3I7hQhysr+JmVqv9MscUTJ92KmOG7AbffJcsmGWC2CNA1DN6cSCgLY3
	 7MUiaGRvcclIs1U/sbbK8uxKQlHPcpehRaRJjgR5eByOaTptAwSYsjLR7y5Yus/f0a
	 wIhLrOmaLh76g==
Message-ID: <ee4029ba-87e9-4ec8-9391-c2c3a96bdbc7@kernel.org>
Date: Thu, 19 Mar 2026 15:50:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 05/23] mm/vma: use new VMA flags for sticky flags logic
Content-Language: en-US
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Kees Cook <kees@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Vineet Gupta <vgupta@kernel.org>, Russell King <linux@armlinux.org.uk>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Brian Cain <bcain@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Dinh Nguyen <dinguyen@kernel.org>, Madhavan Srinivasan
 <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H . Peter Anvin" <hpa@zytor.com>, Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 Michal Hocko <mhocko@suse.com>, Paul Moore <paul@paul-moore.com>,
 Stephen Smalley <stephen.smalley.work@gmail.com>,
 Ondrej Mosnacek <omosnace@redhat.com>, linux-snps-arc@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, linux-hexagon@vger.kernel.org,
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, linux-um@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, selinux@vger.kernel.org
References: <cover.1773846935.git.ljs@kernel.org>
 <fd4276d39055290061f87e9fded20b6a6b712975.1773846935.git.ljs@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <fd4276d39055290061f87e9fded20b6a6b712975.1773846935.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 00A0A10000F
X-Rspamd-Server: rspam07
X-Stat-Signature: o1rw64s3st3opc9kfocwhpjc7bzww8h8
X-Rspam-User: 
X-HE-Tag: 1773931864-554264
X-HE-Meta: U2FsdGVkX18RH7CCFCEJwGfUFzlsycPq7tWxoMNH9XDAr3/aDM/gF5HV/CGa+UzN2DFVv76GABcEPKoy2DMw1SZUZVRyKRDMS0Dp28bCBlqY5WN27yanxzJiYi9czDDvUeWvI8gIOl5dOnajwAw7UfgWTGZNUk48ZyDFssSpu/buRabJOe9FxG7EA+27B0IsSI/ErM4O+/r2ruTkTmShFdTP4eUjO7VhTro8KYsFaiOa72uUUXB7tCILSWne7XjIZywhVJKx2YbmSZnSqOLm3AE3KEQ+gFyZOLM9ANBLnEtXCIWGUlPZwdPk2VWaSeTCPH/PPbjdvkDn5oahtS4LkGzqBhWkxQ+ENCBGFvDnFT3TO/ZNIR5l2oUEbXjBwPIJnDFSj+mvLqquu3c/xN+bwIwvtuRDfoITDyKPNKUP4nLCGaMHz7XLme/o8C4amhDMe4+GfcPzz1z3pHTAgopY8nLSW+Zm/X8TWT2S6674TNuIOivx3JP2s802aFxzFlwOvatlN0uk6ApBpjFQe+vzr6zOUj/zrS897VhXOEfW2w/3448oO0q2Jqeyz7htTbkBakZf1qVQnGQukQL0tOLHzrgOp19dDt1yZQ9EIIn35chtJ/UxOGrO8+3YvliawhLxTOUFD4jjHE9iWm46J3sJB5xJj8BZ5Q42hfm59KegNcjgVd8JZmAa3c5509kGZ3ItauH7CFC/UOYjScZ20XcY+WiRLdBE7f6Zl+ipuaBkffWh5gpsnKv9CRRzeS9Ne4sAkvuLtwHJy/zqgaiy787+9qlFJZ+Hk8YnBH+R7mAkJTrCW1RJXw8yPVXPEm8HJ++xgAxxUvgVt4EbNbwrXNDFxRpbQeJm0HxBI2FsiTm5wyI5YVEzyVZ9e6UQwp8mMscfg9ZTJI+ITdhWMYrC7FodC+6mwrKFuTryl3Bt3ONceeWWycGrSv1q0oPPEFAGGEEXvjFGymLjOJW5e5RS2Cv
 4uRDWPPG
 TuK2fyeqjDjoHmIAwtc8g8n6EDAGYGv3qhQj38dnMRAyTPnJEfXvsQ3jYeFRGPoI3ifSimEbRqsGAIIM5n/ln/wfXmuIzmpztEfSQKCT0SqDCGKepi/f0HzqelWanve7pNHqSyOazmh77+ZHuFTGbPOYqZriDEjNedWKecEBlSqSymeY04nGzY4M/yHRVL/w9IQZjHZSG+02khzmWpscAkI+IaHfcrOZN3ZkQKRj13csUMOCA3isXT1yXwBDjdbioYA22qEvKXlScVjHbVBAAgoDIs6ZkUOD1bUqC6dk05jQMcWX2WXA2/r1JChDwWXTS+uFRc6fw4UyDCnh5AWFdRus+j5UkGHF4taJ+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/18/26 16:50, Lorenzo Stoakes (Oracle) wrote:
> Use the new vma_flags_t flags implementation to perform the logic around
> sticky flags and what flags are ignored on VMA merge.
> 
> We make use of the new vma_flags_empty(), vma_flags_diff_pair(), and
> vma_flags_and_mask() functionality.
> 
> Also update the VMA tests accordingly.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


