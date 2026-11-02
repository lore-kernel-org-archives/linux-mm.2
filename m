Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9571160A260A
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 09:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jp7hWoRL
Received: by kanga.kvack.org (Postfix)
	id B963D6B05B9; Mon,  2 Nov 2026 04:40:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6DCD6B05BA; Mon,  2 Nov 2026 04:40:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A83CC6B05BB; Mon,  2 Nov 2026 04:40:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8B95E6B05B9
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 04:40:12 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 12E34120C22
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:40:12 +0000 (UTC)
X-FDA: 85389683064.07.C337D18
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5EE4640008
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:40:10 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jp7hWoRL;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793612410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8aDvlOYrK7UWy4XuJN0OZX1n4c+MlDIjC9XuVai/qps=;
	b=f5D0Kcr2aQg3vbR4CU+Yb7ZYOYQ8ZFz3w37uuvK0VLnvDv+FQ41mK5QBXhqOieKvNR7rs/
	4cGip/LFGPlPx5jhVrzsNzuvP+7CKN+oPFaRVqH7mqhn2s1niZ3L6jUu1dBJcSRFh8HEyE
	l5k+iucdmk6CXIi6djQqSVZwrUDq/vc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793612410;
	b=FaqZgZhXLnuNyHNl2RcVEftgS8ufuZpKu6IeLAlrb+tZQ6NM0b8QSr2tQYf3gZymCNcK5t
	G2llvXGqlrQDmiSF8r0nw5rcBt9fc8ZVADAEqzFQaDNgkg0/69oFZigEq6hbkFdqkNeMUj
	W2l5Abt2DPfsIPcEzLiYzocRIE3axrk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jp7hWoRL;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B819143E3D;
	Mon,  2 Nov 2026 09:40:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67EA51F00919;
	Mon,  2 Nov 2026 09:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793612409;
	bh=8aDvlOYrK7UWy4XuJN0OZX1n4c+MlDIjC9XuVai/qps=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Jp7hWoRLLokcBTU+Nh9VL2w2I6BUtr4iq9bzn3PgSAs2RQRE4xM/wzghX98yYTiks
	 7yLXrGRh57e9iJHXwqsZJJy04V6H6x8rwnDp02ZUKV102rbUjZCsfQRHdYiDbfjYFh
	 IzmWT7iLlB7Eo+n9mUqIiGMVU16MFLHwoI/vl2aDPXjVZ9qHrAlLziezBTW7Vrra0U
	 MHPThO878vP0QvnEdV3yLlglh4Xe9OjxeNzp2SazHcSLkPj6k791X90HkrYQ4c9HEn
	 nksRt79q2UbCJ8NMwOd0C2S70JZ8Vt0ogp8jMVDE7bPMwfM7pyDSG4xsWzcCqeXUAL
	 GqlR/yYIsCr9Q==
Date: Mon, 2 Nov 2026 09:40:04 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Songsen Yang <yangsongsen@insta360.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, syzbot+10e72ea5747737bcd2ad@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/vma: fix NULL anon_vma deref in validate_mm() under
 mmap read lock
Message-ID: <auhYlOz1OmBSWLsx@gremlin>
References: <20261102074414.10902-1-yangsongsen@insta360.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102074414.10902-1-yangsongsen@insta360.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5EE4640008
X-Stat-Signature: jg3kso8jy5sekmdxhnznfueu5d1hj1cz
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793612410-190006
X-HE-Meta: U2FsdGVkX1+NwwVkJrQdXVxViSz2PFIG5s1VvD5kF04R5Tq/p4x3ndkWvBz9nJPTy2qD/GwFQxWiKBGDgY12sOBjVuQ+DlAMf2r1V40wR70ZunjzFHCGMhHgyhctDIllvJO3WWbVyJdnfma62CYaxkkDiVNT1nChBa11CDLHVkLd5ZHC8FaZnjdCGDdWk00dyWLV4VkLvhF7A+BXbmLeqAkuxaN9rOISqc8ViufDboDqdpR1BD9eGHWRVhWKA33/GiFXEbkVBaNLshoGoADJ+M1zcdjQxHKGSpbdtv+dEU5BUfUAo15FNRhl7bYbogZc1fXrUs0UgC7rrZZ2fb/d1KEzRrIh8V2Oiuduvzc8K8XrVRpMCpzmqCV9AaWr3643FTAwtnTuQbH/o51a+sQ/bmProL343+pWeIThYZpRFqlRNbyoGN8KRaQnCzHk7425ZT0L/lZm54fF61UhnWbvg3neqaePKkXsOXGuJrg0SnAfYIpemNLCe95zrv4A8xMY/4tcBRnUrSi5wp8yYTfWVaJYAD9Ijqqo4kk6whe+HZ4moPymEvEWTjqiaw7ow7vwWI+AQ5wEa6+XNpPFWPCN72vVyCLlltuIRnbLhQhD4qvosry/FmNqUESHX9ypkCbpM2xq8y+wtI4g52EnBZacrhZqIO09wa6taxCeK/AJ/xBYuEEHu9pWYv7PgkagJcYLK9ESOyI9+/0Klmx8FLeEvsPmmcddWNJ+sb7s0c7+60YgyWL/AQjSQIPSQtWnifx7NK3DdHELKgIpaRQAAzNrGGwwDLg7dUuV+Q3CXPKFSdYyoK2SXH2OGk9lLJoWrzUemG3UCHXN3JxejpaFg6QP1gjxgerooXYAkWkLnlAy94MdJX9pi82C7olVtW4oUbYnHs3cOKhJMznK60RNpo+HFbNiz4SgN8fnR9OmV/J7rCc4O/3IfwQqzMEoUUcxcgDXBR7i7upe7hG+Ufm4Tvo
 PMdo2d4F
 E/czs9VfyENfgerrTUMB+Bi5Y++5U6V38ugrw9sOxzxsVBwRwFTr/ymXu9MuxNUc8bku7gXVu29CXPPssyG2UqFy/yId3EZgOcKCNhIpgeMar5CiA1nCnSr0mWQVbo1P1Rl4AuaEMBfpl9TGWLoJU4IgWSGI6HhNduhUyfzxLhPff0eIHQTMJZoUot+mWnuCstmlA+IAdo1oTStKb4v4+eLVe6Ndgz4F0GVKo3cEJKV2/ZYnQxFqCNaOd5PC5KSFkYml3hl8/hysW4EzNGxIly1k2CMO8TZawa+OLPq65BKCbsNywiVH16pOJ8z3o9yFpZ8r96ZYpVDqFnSrFRFqVkRmWEcLPLRajD+vaSl9Od9rsN/ElbVMj8zqQb+CWB0dk/Sc3d9nL7WAddTsyESAIdmDc39dpKv5HWVVjv8OvAgfAsxdzug3Rhy/2JHAdJPcugrffp+fir/sMk9KNgsOmcy0Zfs/fX1KX1MF3ahcyDOHbfMR3wjv48TXlweDJbT9SHCQVsMlgrCbGiL7hFkKr181NIqHZg/8w+2XpL5lH1MwAecpayv3LARMrvosvZ5SXvkYK0WX1NuVRM4rG3ewcnlPjMg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 02, 2026 at 03:44:13PM +0800, Songsen Yang wrote:
> Since commit 38564710f443 ("mm: implement and use vma_has_anon_rmap(),
> silence KCSAN"), validate_mm() decides whether to walk a VMA's anon_vma
> chain with vma_has_anon_rmap(), which re-reads vma->anon_vma, but still
> locks the anon_vma pointer it cached at the top of the loop iteration.
>
> vms_complete_munmap_vmas() calls validate_mm() after downgrading the
> mmap lock to a read lock. A page fault on another thread can then
> install vma->anon_vma via __anon_vma_prepare() between the two reads.
> The check sees a non-NULL anon_vma while the cached value is still
> NULL, and anon_vma_lock_read() dereferences it:
>
>   BUG: kernel NULL pointer dereference, address: 0000000000000000
>   RIP: 0010:validate_mm+0x143/0x2a0
>   Call Trace:
>    vms_complete_munmap_vmas+0x201/0x2d0
>    do_vmi_align_munmap+0x285/0x2d0
>    do_vmi_munmap+0xcb/0x190
>    __vm_munmap+0xab/0x190
>    __x64_sys_munmap+0x16/0x20
>
> Read vma->anon_vma once and use that value for both the check and the
> lock, as the code did before. Under the mmap read lock vma->anon_vma
> can only go from NULL to non-NULL, so a non-NULL value read here stays
> valid until validate_mm() is done with it. Keep the data_race()
> annotation that vma_has_anon_rmap() provided, since a concurrent
> install is expected.
>
> Only CONFIG_DEBUG_VM_RB kernels are affected.
>
> Testing: on top of mm-hotfixes-unstable at commit 989bf98b512c
> ("iov_iter: validate extracted segment for bvec alignment"), x86_64
> under QEMU TCG with -smp 2 and CONFIG_DEBUG_VM_RB=y. The race window
> is too narrow to hit with the syzbot reproducer under TCG in the time
> available, so a debug-only mdelay(1) was added before the check to
> widen it: without this patch the reproducer crashes with the splat
> above in its first round; with this patch and the same mdelay(1) it
> completes all rounds without any splat. The mdelay(1) is not part of
> this patch. mm selftests were not run.
>
> This issue was analysed, and the fix, changelog and tests were
> prepared, with the help of an AI coding assistant (Claude); the
> submitter has reviewed the change.
>
> Fixes: 38564710f443 ("mm: implement and use vma_has_anon_rmap(), silence KCSAN")
> Reported-by: syzbot+10e72ea5747737bcd2ad@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/6ae78418.6552420f.2a0efc.005c.GAE@google.com/
> Signed-off-by: Songsen Yang <yangsongsen@insta360.com>

This fix looks garbled.

You've no guarantee of what is read and when, the ordering isn't a thing at
all here. If that were an issue, you'd need to use a READ_ONCE().

The fix is also not correct. I'll take this over.

> ---
>  mm/vma.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/mm/vma.c b/mm/vma.c
> index 4672d4205..b674c69f7 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -679,7 +679,7 @@ void validate_mm(struct mm_struct *mm)
>  	mt_validate(&mm->mm_mt);
>  	for_each_vma(vmi, vma) {
>  #ifdef CONFIG_DEBUG_VM_RB
> -		struct anon_vma *anon_vma = vma->anon_vma;
> +		struct anon_vma *anon_vma;
>  		struct anon_vma_chain *avc;
>  #endif
>  		unsigned long vmi_start, vmi_end;
> @@ -703,7 +703,13 @@ void validate_mm(struct mm_struct *mm)
>  		}
>
>  #ifdef CONFIG_DEBUG_VM_RB
> -		if (vma_has_anon_rmap(vma)) {
> +		/*
> +		 * Callers may hold only the mmap read lock, in which case a
> +		 * concurrent fault can install vma->anon_vma at any time. Read
> +		 * it once, so that the check and the lock use the same value.
> +		 */
> +		anon_vma = data_race(vma->anon_vma);
> +		if (anon_vma) {
>  			anon_vma_lock_read(anon_vma);
>  			list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
>  				anon_rmap_tree_verify(avc);
> --
> 2.50.1

--
Cheers, Lorenzo

