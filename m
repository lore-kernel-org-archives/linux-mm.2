Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17CAEF01831
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 12:18:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BA966B008A; Fri,  6 Mar 2026 07:18:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 578166B008C; Fri,  6 Mar 2026 07:18:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47ADF6B0092; Fri,  6 Mar 2026 07:18:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 32D6B6B008A
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 07:18:01 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D2E151B8125
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:18:00 +0000 (UTC)
X-FDA: 84515539920.02.9C2224A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2456D160004
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:17:58 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rCp0TEPy;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772799479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rsecX7IfEkl6mg+kpO6NHs6lMEsEKwri/xBkvNiB/E4=;
	b=4NaJO7ED4/qdyV1ZiqjwSE45o4tyAS2RIg22JDVU3SehXrH3OE1YaMcNNCevfYywy5y7L1
	5FRdpsUzLRp3iw5iKsFaEo9TFZDMJGkfs4jluISa/UnWe5IN70uvJ0Gq2lwc4Sm+jwlJKg
	R7CHI83mHmPmxdRzwseMnVeEmuFl0JI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772799479; a=rsa-sha256;
	cv=none;
	b=c9RqeTUUwLlFY2ev//kuWoV3uZiaid6TCWN6MbWK2ZTtYHw76/8es9DalgaAB2ZwsZ/IHe
	VurZi9ne1IQO+2PxIkIyEi5dQQrlb0Mo1hSAiLOtGFKjMxkr17vrscIJirdjph/QY3PbXm
	FdpeGaLiheNJ8P9MKe1Q8P2raloZwzE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rCp0TEPy;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3D6E3404AF;
	Fri,  6 Mar 2026 12:17:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 811D4C4CEF7;
	Fri,  6 Mar 2026 12:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772799478;
	bh=yyADghSRuv3g36SG1gTJ+zwspTahcSZlQ722wYwHmFo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rCp0TEPyTOAJupRC28UvQbYXcao/G55MgmxFJIUwmwhQpuaPUpOT9IaUxiz4l5nEc
	 otvkysRzxPs3DwlOKdKiqY//hgQr7LqJ9BEez9xlbH2rOvQ6KR8wW1Te2DyXt5Y7C0
	 AdZO6ELl5OOGQXFL+vy+jJZnK0vGap6Hkyknjo+SAeXBT8O22MNov+m6lrTpzBgLZQ
	 EhmCORIlTz+NSzc9TcBguQTQ6X0MFO8+HpR8ALVK04Q+cBoY+dyiAu0NzOviSlR6nv
	 hBCmb0cqI2vr+citiZrZ/w8gPppkTAUyT1n6sGgxa1kceA0/E1psbkUc1vZ34fDFyh
	 JYwVuJUUBth/A==
Date: Fri, 6 Mar 2026 12:17:55 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, 
	"linux-mm @ kvack . org" <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, David Rientjes <rientjes@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Alice Ryhl <aliceryhl@google.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>, 
	Todd Kjos <tkjos@android.com>, Christian Brauner <brauner@kernel.org>, 
	Carlos Llamas <cmllamas@google.com>, Ian Abbott <abbotti@mev.co.uk>, 
	H Hartley Sweeten <hsweeten@visionengravers.com>, Jani Nikula <jani.nikula@linux.intel.com>, 
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Tvrtko Ursulin <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Dimitri Sivanich <dimitri.sivanich@hpe.com>, 
	Arnd Bergmann <arnd@arndb.de>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, Andy Lutomirski <luto@kernel.org>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Eric Dumazet <edumazet@google.com>, 
	Neal Cardwell <ncardwell@google.com>, "David S. Miller" <davem@davemloft.net>, 
	David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Miguel Ojeda <ojeda@kernel.org>, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, linux-s390@vger.kernel.org, linux-sgx@vger.kernel.org, 
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, 
	bpf@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	netdev@vger.kernel.org, rust-for-linux@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v1 07/16] mm/memory: rename unmap_single_vma() to
 __zap_vma_range()
Message-ID: <f03471b0-ec73-40d1-88bf-a977c0e8d201@lucifer.local>
References: <20260227200848.114019-1-david@kernel.org>
 <20260227200848.114019-8-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227200848.114019-8-david@kernel.org>
X-Rspam-User: 
X-Stat-Signature: wycm5bbaheypnh4z9d3cis5kisswmp4h
X-Rspamd-Queue-Id: 2456D160004
X-Rspamd-Server: rspam03
X-HE-Tag: 1772799478-960683
X-HE-Meta: U2FsdGVkX1+RR3/PsixFzuNc5PPca8YLgmM+gd+DahAX9unwpnXE8fx4sqoq6cebdKvt9iuHdekwSEoi2/yQejUE8IGrdmCPd4EO3nInphJs+hPzJcWVYNuP4ix7r2fjE01muR1Q3NxKQuwRq1wauwsvUSyV1lsWBRz4hcfTGXczszjSHL5zjs2oERXJLQrH8eHsk+PW2d5+M5UTdYMLmQQBpCrEqRU514wpvqeF0pexGNqscXujYoFBmFlWxspRsRE1Jnr6qWIDSSlIXwbBW32lFNIfJZvAYge/hFhK8SxyvMjnhHpDa/MmU0HU0oz1HdECDEstFWvnvd6eDF25TLIqT1Eu/i6LanFM0aEtXsZ1DVkFISkEC/+OQWPlJ3emCNcSrGur7b4E5j3WoVFXFJGyz/8TovVcW0wqkvkOk5BQmq8VGTmBzs8jSMairBd7NzUakH4rjQMR3+EATU0+cLYT3ppULYnFWvzr+VYuvkNnQ7MDousXxgr4MihXyC+dXqf3UBlgXXBc2kqXwIe7XLjRLYR1L83pAjQgj0346HDWfQqQjCqIqreOb/rTcbiyiwEqVvegIZZtUL6yoQfL6SKDBFdhWqgjYTrF1dk2WLWPe24c9tJDjlnI0ncZeQ0qR4LdSmHOOXHpoxoqxuyV/fvwWay20iTIoLGiwkHtBmbviBB/+hbvspg7D7FeNeZYQVZE/UPxfWDHpD3I3JXwcoZ+fJ8b5SZNEOq57SkVqcihXDthC5eaSZDL/bmnwDImVFsYR1umsKLvfAkQol7Cn0yhpcTbtY+l1WqwEalLTxKN1dgil4kQiZ1xDCljK0y3PEh1M4EdHuSDRmRSGxe+H13nrZ3MjbQyR6238O6mFfV3voX+X5RaCWnlj1qTkOJ5Ogp9ZF8JVMagm+XNfWE4WKqzSf0ZGlGFotFIskyu3rQx5xOFFIkqzMJCIqeSykmoDMNWhDedpqCHj5BhqdM
 a6ZigkbZ
 eGefY+V1j3c1PiE0pUeIOWRkYxqcrrhYansAZqlX5QIKBD5gafGxQzlEcRn2vfjM6iVcavNumQlr3eLniaPip3eMLAf3Zz1aFfZ9ciRPadbkavcJArACVNCsufAUKfujsscKd0bB6Szr11QYHfSYVcZMeiM+sFykEq+TTEjhD++nqFySqj1KwcfkEsQ34pgmrignoiTBEWmYnxnAkMQ9/SVHtSgqdD39esMBhVbIuW1JtzbyVNhJC9RjfGyWAOJaOFk7ig0NQkcOlwtwkfh0IuVXCYWWsVBLR6XIs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 09:08:38PM +0100, David Hildenbrand (Arm) wrote:
> Let's rename it to better fit our new naming scheme.
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Yesssss thank you! I hate[d] the rando 'sometimes zap sometimes unmap' naming
convention here.

LGTM, so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  mm/memory.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 621f38ae1425..f0aaec57a66b 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2074,7 +2074,7 @@ static void unmap_page_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  }
>
>
> -static void unmap_single_vma(struct mmu_gather *tlb,
> +static void __zap_vma_range(struct mmu_gather *tlb,
>  		struct vm_area_struct *vma, unsigned long start_addr,
>  		unsigned long end_addr, struct zap_details *details)
>  {
> @@ -2177,7 +2177,7 @@ void unmap_vmas(struct mmu_gather *tlb, struct unmap_desc *unmap)
>  		unsigned long start = unmap->vma_start;
>  		unsigned long end = unmap->vma_end;
>  		hugetlb_zap_begin(vma, &start, &end);
> -		unmap_single_vma(tlb, vma, start, end, &details);
> +		__zap_vma_range(tlb, vma, start, end, &details);
>  		hugetlb_zap_end(vma, &details);
>  		vma = mas_find(unmap->mas, unmap->tree_end - 1);
>  	} while (vma);
> @@ -2213,7 +2213,7 @@ void zap_page_range_single_batched(struct mmu_gather *tlb,
>  	 * unmap 'address-end' not 'range.start-range.end' as range
>  	 * could have been expanded for hugetlb pmd sharing.
>  	 */
> -	unmap_single_vma(tlb, vma, address, end, details);
> +	__zap_vma_range(tlb, vma, address, end, details);
>  	mmu_notifier_invalidate_range_end(&range);
>  	if (is_vm_hugetlb_page(vma)) {
>  		/*
> --
> 2.43.0
>

