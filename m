Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 919B1108B8EB
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 10:16:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2C086B0005; Fri, 20 Mar 2026 06:16:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDD516B0089; Fri, 20 Mar 2026 06:16:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCB656B008A; Fri, 20 Mar 2026 06:16:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CBEA06B0005
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 06:16:12 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 69F4313865E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:16:12 +0000 (UTC)
X-FDA: 84566036184.07.0B9B471
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 910A01C000A
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:16:10 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VpGnIYfO;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774001770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TycOeWVZquacUlciRj5W3aWhpreqS3TXqwdxrkjDt0w=;
	b=a299IkJGNFtKtDCthwHp4+n+4ThmjDvnhovPMYIPeBwibzJEyTPSKBNcKf7jRdGqDK/Osf
	UNLpKITDYUZjn8AEA6pYSTYJcpxjiASceJXwUUyciAcBgHuONjItin7Qwnv+d2v9jamhZn
	8knaaaKwg153mgI459UHZPnueHWvK5Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774001770; a=rsa-sha256;
	cv=none;
	b=IBvwehYMsrtlbkXnCDz0tBqG/YA7BQ9KuSilaws3UqAJavek7OLGYZLaEqZg4repslhtq7
	QS9kWxZ6cRFx2vqvohbO0lMbTm1K9m0CnXdt2UbspOhXCX7FCr7vzZ/GvqehW4g82IeXpu
	d6tH227GpjC+fekkTa0i8FgSyqVy8TI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VpGnIYfO;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8A6B0436C8;
	Fri, 20 Mar 2026 10:16:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3FF9C4CEF7;
	Fri, 20 Mar 2026 10:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774001769;
	bh=ap9t23GAznSjlYBwe3WH7nSlcvQ4uwkCMM8JPtwfdBU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VpGnIYfOhfS5un78DFGTJ5loTHw41DGnYvLF83kfJLhLDtl86vDxsK7+kZYUzaYnE
	 5V9zcIkNRIqSzj4tbwQLydHMYDPmXOCMLIySJ4ULjxFk/lefzNfI9hnLeFOCIGnnDl
	 mAxr5fguFL4uy3itIhWz2Fy0cYKrzKJpZhkuV6STy5rmqivM3mA46b4dMOAVIm8aX5
	 aL1J/e+lrGnyidQShydB7ZP25CoL8lbUtLPYsSX+m708iSuLKQWfBy+aNV3CStt/8O
	 sw5JQcZVkYlp6nZd/W4kU0jl8JC6+CIhgGnco8oF5shbFK5ws3inZ7cQkjFITK2eiJ
	 D0/iPE2qO9fcw==
Message-ID: <a7535063-abaa-4f67-a090-4a47098f10e7@kernel.org>
Date: Fri, 20 Mar 2026 11:15:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 21/23] mm/vma: convert as much as we can in mm/vma.c to
 vma_flags_t
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
 <44a952b98d68fc231ab231de6de04b077866bab8.1773846935.git.ljs@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <44a952b98d68fc231ab231de6de04b077866bab8.1773846935.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: uhfpi7y7ato1ch1ckz6us61dshdd4hzx
X-Rspam-User: 
X-Rspamd-Queue-Id: 910A01C000A
X-Rspamd-Server: rspam12
X-HE-Tag: 1774001770-562337
X-HE-Meta: U2FsdGVkX197EB+e2dqE4jxYUTlvYuNEweTPeCChrw2pWSQ5+2FoYHVhvQUdtq0msbcfB5HvwQjCqVOMuNNpxU/YO/9DJQ8dV+q0PHZf80v7vx3kcxC4ZiAewlg5eeNHKKUPDd6RQuJclFBH3ynWxCzgbuuIzVq5K2csndY8InArKEq+Jb+a3sPNOhgApnzY/VvwqpVyJdUihJzZBwYP0QTGUek6rzITckQ74jxmvKZqNH2T5JXsmUjXzT5TCYgwUvunLgMrUbp+qqotjqadg1jy2XqbGF6Ly2qquI4651xWMngOMqzFzaE5dfc+ZEINCM4e6diIR6QyqjyjNkaCrG6JTL3JNpjJAfodt+C8D8BUWlUoYs/SupkYmWYwyLUPoq5/ZJD66gEMYer50wsDLpahQhjjDKt73StpSdnkSb2ovkw1mFX9NUSB/+JgvsqXAC5nsPvmGSiQQy62sfbTWryC0UkZb59LQMKcBkCCqq7hLQbuy2KaGNFBracBceWh44nvJ6ZDmx+FZaZJPl+xByZWG9SIIv48j7s+3+XRK4PpUHNLffV8/i0Z02uQehmxg3B/z3Iso4jiAilMzPWuhtigCe4oQqGhYnmwWh2j01ZjzFOSBOL6oo1yJfEo127nh7zJJXFtyxjGGWuO0jzv8Sk+jabQZaQKZl6YXCmf/6V8Q8Uzq4TTkHMp8GNGtpWYEjgPcyAfSHDANgrJXnIl4+iXOICE/S4MEobF4cgBWGDH8LqeGnJB0F1CWQ5Je9uNCncNVI7g0hfos995lGFQaYi48AjM2IEHnXEB7Fbos3jQjkalE6fmITJiyLW9VehKZIDJt5UPUNlK5oRqaZbUb2OBuIzhZH48lG6eSi10ea7SWGxcjJ1W9bA3XC6DRmPLoojo48YxfRvuukq2eIL69d1OAaHpA3fKifTJdU2kUO+l7oan5vc2sdEWb5yNT6a0dQafREUXA+QUcHJIDOX
 qjEQkoVp
 4lYtyMJMukXmNSTtdFU0nPU4dyyLmH2idE3s5uWNW2gPgE3t7a+PoCR6G+528/E5j09lRV2g2g6Ur4DYa5g30litPch+rtDiUkvxyttSgWFWBLYfkwopzDdxVNAK70lIIfKg1OaK6QJfejITjiaTxwVqmI3u6yq58PiQnfbxap/HVxDb3wylJgCWAod/Qt5BFon0cchX03UIjauHz9YYX67SbudO0UFaiuhhu16fp6dYQn7YRbL+R2KZUZSvBBB4BQrcfEV+AySZkZ5SRy3BdKpGHfqsb4mZe2EBilRk5azHWssL/WngXJaif9sdn5clAdmuEYj7UBvxUZS2ZzOTVp1gOALVvxAuR1wxNn4xW2DyU04LoCg5xeAq5uZ1U5hofK6si2Ln+Chp+9AVasNdk7GFXyw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/18/26 16:50, Lorenzo Stoakes (Oracle) wrote:
> Now we have established a good foundation for vm_flags_t to vma_flags_t
> changes, update mm/vma.c to utilise vma_flags_t wherever possible.
> 
> We are able to convert VM_STARTGAP_FLAGS entirely as this is only used in
> mm/vma.c, and to account for the fact we can't use VM_NONE to make life
> easier, place the definition of this within existing #ifdef's to be
> cleaner.
> 
> Generally the remaining changes are mechanical.
> 
> Also update the VMA tests to reflect the changes.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Nits:

> @@ -2338,8 +2339,11 @@ void mm_drop_all_locks(struct mm_struct *mm)
>   * We account for memory if it's a private writeable mapping,
>   * not hugepages and VM_NORESERVE wasn't set.
>   */
> -static bool accountable_mapping(struct file *file, vm_flags_t vm_flags)
> +static bool accountable_mapping(struct mmap_state *map)
>  {
> +	const struct file *file = map->file;
> +	vma_flags_t mask;
> +
>  	/*
>  	 * hugetlb has its own accounting separate from the core VM
>  	 * VM_HUGETLB may not be set yet so we cannot check for that flag.
> @@ -2347,7 +2351,9 @@ static bool accountable_mapping(struct file *file, vm_flags_t vm_flags)
>  	if (file && is_file_hugepages(file))
>  		return false;
>  
> -	return (vm_flags & (VM_NORESERVE | VM_SHARED | VM_WRITE)) == VM_WRITE;
> +	mask = vma_flags_and(&map->vma_flags, VMA_NORESERVE_BIT, VMA_SHARED_BIT,
> +			     VMA_WRITE_BIT);
> +	return vma_flags_same(&mask, VMA_WRITE_BIT);

Another case of possible refactor, if you agree with those pointed out in
earlier patch.

>  }
>  
>  /*

> @@ -2993,7 +2998,8 @@ unsigned long unmapped_area(struct vm_unmapped_area_info *info)
>  	gap = vma_iter_addr(&vmi) + info->start_gap;
>  	gap += (info->align_offset - gap) & info->align_mask;
>  	tmp = vma_next(&vmi);
> -	if (tmp && (tmp->vm_flags & VM_STARTGAP_FLAGS)) { /* Avoid prev check if possible */
> +	/* Avoid prev check if possible */
> +	if (tmp && (vma_test_any_mask(tmp, VMA_STARTGAP_FLAGS))) {

The parentheses around function call not necessary?

>  		if (vm_start_gap(tmp) < gap + length - 1) {
>  			low_limit = tmp->vm_end;
>  			vma_iter_reset(&vmi);
> @@ -3045,7 +3051,8 @@ unsigned long unmapped_area_topdown(struct vm_unmapped_area_info *info)
>  	gap -= (gap - info->align_offset) & info->align_mask;
>  	gap_end = vma_iter_end(&vmi);
>  	tmp = vma_next(&vmi);
> -	if (tmp && (tmp->vm_flags & VM_STARTGAP_FLAGS)) { /* Avoid prev check if possible */
> +	 /* Avoid prev check if possible */
> +	if (tmp && (vma_test_any_mask(tmp, VMA_STARTGAP_FLAGS))) {

Same.

>  		if (vm_start_gap(tmp) < gap_end) {
>  			high_limit = vm_start_gap(tmp);
>  			vma_iter_reset(&vmi);

