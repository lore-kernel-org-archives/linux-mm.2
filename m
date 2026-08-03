Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FC2DC55184
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:47:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 368196B0095; Mon,  3 Aug 2026 09:46:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C5DB6B009F; Mon,  3 Aug 2026 09:46:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F09D6B0099; Mon,  3 Aug 2026 09:46:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D052D6B0088
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:46:57 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 412151A0727
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 13:46:57 +0000 (UTC)
X-FDA: 85060084074.30.414BE1A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 83F0014000F
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 13:46:55 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eqmNyeRu;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785764815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m2q4F0oL2477vtEU1dLCuKFUHXuEfn75EzPRR+HK7ws=;
	b=pGRulFiZ5fA8GoZ2XmPPF7NYhd17laGDTYJM+zslUo93AVtcyopzMO4mz0054dH6t3YQDe
	4AXUHX2Mt6bm3GX5rh1xKvvJNthhr4sppIK79WvQ6jrzI6A3vSMmEtLqTlPZ4EiGg+ZOJQ
	uYpheKQqWRaMcnV0aOKHvp/3nccwjJY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eqmNyeRu;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785764815;
	b=PcFymvCr83jd9A6MOI/7fr/FSW6pbHbS5E3uk4ctS4NEgvjLdAaJtC0ufAPOXvtklLhGeF
	4CxK2sqVPW5fHLdh+9oyrD7U8c2xsubiBk64G/OQxuysLCMv/BEKzcdG+zQQGB6sJnaur6
	psVj/ONGUCNvXMdEQHkN/jKeS5PaWeo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9F36D439D7;
	Mon,  3 Aug 2026 13:46:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 982A51F00A3E;
	Mon,  3 Aug 2026 13:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785764814;
	bh=m2q4F0oL2477vtEU1dLCuKFUHXuEfn75EzPRR+HK7ws=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eqmNyeRu9MMThDgrJTemIAYVn5WtoRn3cu3pmch93QP5K4lX4sDg/pm0ttCpuOjLo
	 8+PXLi+w5RboMoDuuWynCLpTTszMlS13U6r8PTRN0vJrUbEXAWih1+pQyNXP/cyS6G
	 4bUXzZTjw11UMbSWC6wiNClS8+y//ZlGwijgAlT5pOP301hF9HoXXhZdJb583Zu+4m
	 IiumEe2kHNGvlWTLDFIIUXkE/WEtdAJbwtb+QHDkb6cWaw1KeSezh9SqqenYI0gPDy
	 Owyyd2AzuKyBRmgPyVYfFdYKGccjqFlh5QQ0Z03RLC/KeTPHYlhnYeNeQdDGW1g7/r
	 GIQVjwF83rCig==
Date: Mon, 3 Aug 2026 14:46:32 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 06/15] mm: propagate VMA anonymous page offset on map,
 remap, split + merge
Message-ID: <anB9MWSSITYpDibA@lucifer>
References: <20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org>
 <20260729-b4-scalable-cow-virt-pgoff-v3-6-e8ecfefea812@kernel.org>
 <4ad4b17b-bae6-4169-8649-bff4a29e7fde@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ad4b17b-bae6-4169-8649-bff4a29e7fde@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 83F0014000F
X-Stat-Signature: 7e415q9hi1wbh6mcousfjqzrm4kqrgms
X-HE-Tag: 1785764815-950496
X-HE-Meta: U2FsdGVkX18rhi9q6VXgKxwG/tYQSbBVPtIlW8ALIzG/ghcQMj6rkUUFXunJkpYVWgXlNOyUI6XRNURKFNdW2EVbmkfhNKUcmJPH/+es9A4wOMuTeLoZHbDg96H+/YoaSDevryu/CIwmklOHMvNhRIAEI7fy4upiozxeHkoALydiB+WnKlX/i1eFYlG3Sf/AEYriYFIou7/n/YN6Wvw5ohnVu4DMmdMMP1i5o26h4uOGkAa31Gjgh6JdpqUAYlzs88G8kRYiM3emmgxnKDt8MGOt9lvstPLv4iQwCKP8Wm2qXiiRqK2eMPaM4vicJZ+dDk8QUfZNcq5W1mtdBOYitOIlooYeaQ0qKdK9eA1wv/pFvc5Oe4O8oT5zYcI6w0HWfAdL2YaEb3CqcfHT3L6aOJp/cYEMhw33MnFC4WBqEz3D3xq7z7r5CQeeFOmzdBvXLvP59Y+0PVxE5peuM+gweGEDq/kHcL98sc9ZIEK/h1hai5Z1j9V8hYCVyq49gR3L76w3LInuO/J52EJkVhGyvb4gBHDIsW5IKofMrsuYp5q4Uzu8vN+MLw9eriH3gsmshZE8LZ9qxyo9uliJ3jvjxVkHVB9IAIB1uPla7PapGg18XT5kkViF4Rwx10D4uWLk9el5c+u6uSsXHWd2z/AqJtzrmkw/HwTkcSPu/cXdnrVEktT6X5eOFgn/iRsfS0m7rBhs9rQNTVmgf/q0QQwZ/23i9tOuacoID1K52FxeKwYjSNbNWaGpyXyEDCqtitty/QSBSDGyg4zuKYKNRPxhon1mBvL+P6p7PAH51wkH4blKBUnYVqutq01OI1LRHP0jzwA74pCQLS7qWgbIJZG/QCukA/SJVo0TPQQzZwlleJGYaCcEkX0qAhE1DrFhqblX2rpSmlSaiObVl9SoX6Q/JVphXXJpf4iY7/vWs8OYI41WymO+C3Ot5qxFrwYjAA1+KuPEEZtvri3e6rhinYW
 TsxZigy4
 Spg5gvHxaVFLTw9/CmQdCVNMy+jZc436UnTtj7PZWUVgSxv4jxZebzRII3rPuS8RQcU2ZBkMFOT++lMl2ZqbEsVosBz+TnmTVQd86ihiP0I8OQdrhJxdoAAAuoCNvCoojJE/TzDTpaO5SAllRTdMUMfxk/JQ3IzxMK+MKnh8TZH+Vgdbtxgyfa0kQOJwEInBp0MOMD0WDBF8GOVBH7dkgM5NcqwrrL6RBj+9KpxM0uSQUXBjC4KhiK8Exjhqtf22XH+9Wvu2q1i/b3o3lRmkaiXXugKK6c1Ds60qkku8sc59r8SOVUyIP5xvo4rcFXcLWIOG/D8tb0OJt8OsaNXjlcm3Zm5xgBPziH4Rt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 03, 2026 at 12:52:42PM +0200, David Hildenbrand (Arm) wrote:
> On 7/29/26 18:48, Lorenzo Stoakes (ARM) wrote:
> > We must correctly update VMA anonymous page offset state on all VMA
> > operations that would result in it changing, with special attention given
> > to remapping.
> >
> > We cover most cases by simply updating vma_set_range() to do so (with a new
> > anonymous page offset parameter), but also notably must update the merging
> > and mapping logic to propagate this parameter correctly.
> >
> > The remap logic remains the same - we may update the anonymous page offset
> > if the VMA is unfaulted, but now this applies to MAP_PRIVATE file-backed
> > mappings too, so we update the code to reflect this.
> >
> > Note that we use __linear_anon_page_index() upon remap as the VMA may be
> > shared, in order that we update the field consistently regardless of VMA
> > type.
> >
> > Similarly, pass through anon page offset to the merge logic, updating the
> > vma_merge_struct struct to propagate it, and also use
> > __linear_anon_page_index() to obtain the anonymous page index so it can be
> > safely used for both shared and MAP_PRIVATE file-backed mappings.
> >
> > Finally, we update insert_vm_struct() to correctly set the anonymous page
> > offset on insertion of a VMA.
> >
> > We simply ensure state is correctly propagated here, so no functional
> > changes are intended.
> >
> > Also while we're here, replace a VM_BUG_ON_VMA() with a
> > VM_WARN_ON_ONCE_VMA().
> >
> > Also update VMA userland tests to reflect this change.
> >
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>
>
> [...]
>
> >  	struct vm_area_struct *vma = *vmap;
> >  	unsigned long vma_start = vma->vm_start;
> > @@ -1919,11 +1929,14 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
> >  	VMG_VMA_STATE(vmg, &vmi, NULL, vma, addr, addr + len);
> >
> >  	/*
> > -	 * If anonymous vma has not yet been faulted, update new pgoff
> > -	 * to match new location, to increase its chance of merging.
> > +	 * If a vma has not yet been faulted, update its anonymous pgoff to
> > +	 * match the new location to increase its chance of merging.
> >  	 */
> > -	if (unlikely(vma_is_anonymous(vma) && !vma->anon_vma)) {
> > -		pgoff = addr >> PAGE_SHIFT;
> > +	if (!vma->anon_vma && !vma_test(vma, VMA_SHARED_BIT)) {
>
> Could we also use is_cow_mapping() ?

No this would be incorrect.

A read-only mapping would become unmergeable here. So this is something apart
from the rmap aspect, and it is a contract that upon move of an unfaulted
mapping (which for read-only anon would always be unfaulted) that vma->vm_pgoff
is updated.

This is later in this series extended to MAP_PRIVATE file-backed mappings also.

Also it would break the faulted_in_anon_vma logic and result in incorrect
VM_WARN_ON_ONCE() invocations below.

As for other -> is_cow_mapping() changes:

* linear_anon_page_index() - [as discussed already] - fine
* vma_anon_address() - convert to is_cow_mapping() [have to be faulted in to hit it]
* needs_adjacent_anon_pgoff() - don't convert - same merging argument as above.

>
>
> > +		anon_pgoff = addr >> PAGE_SHIFT;
> > +
> > +		if (vma_is_anonymous(vma))
> > +			pgoff = anon_pgoff;
> >  		faulted_in_anon_vma = false;
> >  	}
> >
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks!

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

