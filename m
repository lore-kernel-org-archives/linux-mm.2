Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBC21C98307
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 09:08:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA4E06B008C; Wed, 23 Sep 2026 05:08:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C80BC6B0093; Wed, 23 Sep 2026 05:08:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6B4F6B0095; Wed, 23 Sep 2026 05:08:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8E05B6B008C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 05:08:38 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 262741A0720
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:08:38 +0000 (UTC)
X-FDA: 85244451516.20.8A0D273
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 553A81C0002
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:08:36 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LJ0LQp4w;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790154516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mUB3dtDJtbKg0h/89Rij/dkAu8zr108kl0u7Zd/GSTs=;
	b=w68q1iF1gFfAdQ0VhF0kRugujmz0ZCNb8Y6jblNLZo7AsmvH8dVpZ7ErpThyDgtqZR6OFB
	OsY//IDZTC4UGFQJvKUx6Pla1VG1N7Cd0FsenUDX42G6DXQxGiC9O6NAjtIqcRCp1SSG4t
	zZqhmj4t0hB5UxaMaS74UapAQCtQ4Y8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LJ0LQp4w;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790154516;
	b=GetpsR7qGO/IzNA8ry/j1c8S/mFrlr2t6UPsUf70aqmIjg3an8vyfpaf0X1mRMBefJG+hO
	TxCfgooxPH/5wODq+wDfcL9iPJOkU0hAvBvlAhw5pIMmmJsiElZXijcydgYkHwp7rObeP1
	dXiIncNJqlg30hcAtwTJqznDDNfVGeo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7985E413F8;
	Wed, 23 Sep 2026 09:08:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B0C1F000FF;
	Wed, 23 Sep 2026 09:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790154515;
	bh=mUB3dtDJtbKg0h/89Rij/dkAu8zr108kl0u7Zd/GSTs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LJ0LQp4wN89aKqlJd06DaCcBQBpV7ry3y27/DBdd+/AC1PsXGbcwRIqlFJVAegiTa
	 oR80pxJR3nlg7MU1ZcoK9TcWgnV1c3oIFnMmd9gtUuezuS07DbQEuhV5MFNUiAR2oC
	 r3wp94UXPgLNXIDb0SCYlTGTZeyrPFyy93WceP9DYN6IKram+1g7xxxQ4UkjiIJbHQ
	 yeETtvktdPZlGl9TDjTuk/WpBV0WqKdpeG9gv5Y2AXMESWyJDgYxX6GCCnS38Pciys
	 4Y4X9gsrWo0YOnRthqVe1Aw62X3ry+euUqxmIrYpnQAp96ns8D3Bn9jHtcFEkfU9HH
	 Sy3YYGPfnp+AQ==
Message-ID: <92b52e07-39e0-4df0-8b8d-ffa18ccc8820@kernel.org>
Date: Wed, 23 Sep 2026 11:08:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 12/12] mm: change the contract for free_pgtables(),
 update docs
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Guo Ren <guoren@kernel.org>, Brian Cain <bcain@kernel.org>,
 Geert Uytterhoeven <geert@linux-m68k.org>, Dinh Nguyen
 <dinguyen@kernel.org>, Simon Schuster <schuster.simon@siemens-energy.com>,
 Jonas Bonn <jonas@southpole.se>,
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
 Stafford Horne <shorne@gmail.com>, Rich Felker <dalias@libc.org>,
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 Russell King <linux@armlinux.org.uk>, Vineet Gupta <vgupta@kernel.org>,
 Michal Simek <monstr@monstr.eu>, Chris Zankel <chris@zankel.net>,
 Max Filippov <jcmvbkbc@gmail.com>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 "David S. Miller" <davem@davemloft.net>,
 Andreas Larsson <andreas@gaisler.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Matt Turner <mattst88@gmail.com>, Magnus Lindholm <linmag7@gmail.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Mark Rutland <mark.rutland@arm.com>, Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Helge Deller <deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>, Thomas Gleixner
 <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 Arnd Bergmann <arnd@arndb.de>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
 Yoshinori Sato <ysato@users.sourceforge.jp>,
 Shakeel Butt <shakeel.butt@linux.dev>, Jonathan Corbet <corbet@lwn.net>,
 Randy Dunlap <rdunlap@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org,
 linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org,
 linux-sh@vger.kernel.org, linux-riscv@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, linux-snps-arc@lists.infradead.org,
 linux-arch@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-alpha@vger.kernel.org, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
 linux-um@lists.infradead.org, Hugh Dickins <hughd@google.com>,
 Qi Zheng <qi.zheng@linux.dev>, linux-doc@vger.kernel.org
References: <20260922-rcu-pagetable-freeing-v4-0-fe1ad1f1e303@kernel.org>
 <20260922-rcu-pagetable-freeing-v4-12-fe1ad1f1e303@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260922-rcu-pagetable-freeing-v4-12-fe1ad1f1e303@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: amtqopuwta31dhfgk4o6hxqbqd4skowo
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 553A81C0002
X-HE-Tag: 1790154516-821651
X-HE-Meta: U2FsdGVkX19OiL8arCygT3fzH7bEY4DawDAE7iAVF2e9d93VbpKKbavv53h3aGF6igeKFmv2QO1QuzbeF3w1qL/U815KhFLq0wQ3CO8ezhv9bk9QE/QFao+Yv0beL3Ce+uQydbPN1YoEge5oGKIarabo/mellvPY+jRphQVp90cQZUeHOIz1wDs4KjcAWCylsmNxHALILu7QWSA26jeu4qtvtbK6BaJMa843qE7aY+h+Yh9lIaNBC06ffpfpIq9phuL2kNEDtyj6MXYy+2cO2F3s98HwSjneQAmAOSBegJQC1ZqEMGXTQFofo9XXCFTk2Tje98lgENE68FsKo0FXFNfCVJ/YI/WoOH8ct/yvBB7WvMqPsYzF2Sc2ST5UusJYajgBtKLzumn1vLM5X2gou0jyQIpl21JB5aRHoJ31A8dTkOTYmbFLM5ofyWHywXNvg5IBFOyTjsxrGXtWiJPC7/00/PqQldxaK6LS2N1XPHlK2tnekKvi1JHyYg2i1Rj5cT5t2L3w7V63FJ4g2UQVQi4uE2XptacPKVZuKP/SbI+yGmylJCP7XlxCCL2hGvXTULqCj5Ccrw7CIFhqE38AxtasqmorxXzgPx57sa2hmRIXjOjmEOVnwkHRZlvJoqg5f4iiLLrNKMa04NgdH3LHaFS+YBMbqNnBH5sfdsUdYR45cCNHNyekuov3RH1txV1WFnw85ZUQybUzhN4S4x2ROyfXU+9nAA/ZXiJC1XgS/WVKJd+MFYYRjoVMQOqQk8dkOyVdDAZ64bn0p3OuvzAgLJzurEnnQTLrUEe0Y2y1RO6Q742F9D6hiK5Oz71a7iR4tBGbJIhw9xQhrpKLV/ly1mMNT6WW4YnhPyvLq0KljtHh45DoAeV6t09c6n/PbYAAnDPV41iG5gVIM4hWFCTHRSSoGuXVuOp84tQevDv6K0JX4hERg8d3cKC5IyRSe4BJpPE0FRkrQlzrFVX6gat
 kn4GAhZz
 pdH4ur3PgwQx4DF41OdWD5l8saeHcttMQJXzMy4pyFhPcAGVc43/H9cVHR+cQU0YDyqYV1TPkz0gDcPOujc7otHnADn4R96Q/RFojAKqJM+7xDcnqet3q47fFd7Q0QE+OfxymiMqqPj09Ky657j1jUyGqieEUmUo9qJfBBly0T9Hhljbfr8DknYNk9HO/dwNLI+xzg5qZ49SogWm9duxm3fJT26u0FDokqPvXz26LLr0fqsVsw/N3via5HV280xZYpixQclzzf+HwPCmeQv+YZ+H5XFx18j8WBXjhnxouD3eV0Cpi4AlitgVQ8i03OXTMoNst/1arxFk6ScUrEaI0kySzI1y3xF3HVqpmDAJMivPdkhFoHEDu+l5CbPZ/G+wsABT/NF7MZ0+nDG8ZeYDXUTvO5w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/22/26 17:35, Lorenzo Stoakes (ARM) wrote:
> Now that page tables are freed after an RCU grace period, it is safe for
> read-only page table walkers to walk page table ranges that are being
> concurrently torn down, provided the mm is kept alive via mmgrab().
> 
> It is however unsafe for writers to do so, as they must obtain an
> appropriate lock to do so safely.
> 
> Update the pte_offset_map_lock()'s comment block to reflect this.
> 
> Similarly update the process addresses documentation.
> 
> Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  Documentation/mm/process_addrs.rst |  6 ++++++
>  mm/pgtable-generic.c               | 15 +++++++++++----
>  2 files changed, 17 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/mm/process_addrs.rst b/Documentation/mm/process_addrs.rst
> index a7296f251799..b1f4f44d75eb 100644
> --- a/Documentation/mm/process_addrs.rst
> +++ b/Documentation/mm/process_addrs.rst
> @@ -537,6 +537,12 @@ We establish basic locking rules when interacting with page tables:
>  * When changing a page table entry the page table lock for that page table
>    **must** be held, except if you can safely assume nobody can access the page
>    tables concurrently (such as on invocation of :c:func:`!free_pgtables`).
> +* Page tables may be *walked* under RCU alone, as page tables are freed only
> +  after an RCU grace period has elapsed. However, any entry found must be
> +  revalidated after the page table lock is taken (such as the
> +  :c:func:`!pmd_same` recheck performed by :c:func:`!pte_offset_map_lock`)
> +  before it is acted upon. Changing an entry requires the page table
> +  lock and one of the locks that excludes teardown (mmap or VMA lock).

While we can walk the page tables, I assume there are some limits to what we can
actually do with leaf entries. E.g., Doing a careless pte->folio lookup might be
dangerous.

I wonder if we want to hint at that here: that walking under RCU (traversing
page tables) is something different than actually operating on the leaf entries.

Apart from that LGTM.

-- 
Cheers,

David

