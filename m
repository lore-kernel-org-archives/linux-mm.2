Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3761606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 13:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nqMHcqWN
Received: by kanga.kvack.org (Postfix)
	id D6DA16B05B1; Wed, 11 Nov 2026 08:28:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1E866B05B2; Wed, 11 Nov 2026 08:28:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C34D46B05B3; Wed, 11 Nov 2026 08:28:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A446B6B05B1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:28:13 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3D956A02DA
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 13:28:13 +0000 (UTC)
X-FDA: 85422916866.25.5158C10
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 97279C0003
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 13:28:11 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nqMHcqWN;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794403691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9yzvDp9V72dMlAIfM00c1rGjJ9jmhjSG6zJg+AYgebE=;
	b=yFZ9wTJy/ZQpQO1RLLXzAqSAYmxikfPU0ckP0O7uXXAJAnaScxa43/w0LmDBPx6a44+WTV
	/mWlUend79geBz1UqlFPKltnIwU25WX+vKhI04UpfuPGbFt20eebgDmiOSPVv2XQIyeS7i
	htOmrm+Ylr4LGRsKTb05aHO5rqCxzbI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794403691;
	b=f67bsYQWNK/SJEPjch+oLXI+z009TdLLEGWbN6/RdilS4/17n+nN87YO557nYRcFVX7F+r
	ux19jz0/uDVXBLnzzWyqK/U2n/szpFfOsc8VVcvO7Z3jKTvVaC3yuYgt7WNOKgdJNuetWb
	nYrP4HHwMRuNZacQ625Xu+K8t0z0I08=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nqMHcqWN;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BF2EC43448;
	Wed, 11 Nov 2026 13:28:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEC7B1F00A05;
	Wed, 11 Nov 2026 13:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794403690;
	bh=9yzvDp9V72dMlAIfM00c1rGjJ9jmhjSG6zJg+AYgebE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nqMHcqWNioXm2Og6tdRJrkWbKwC0ujOefOXYCjxvh+lkZt7of1xvfeQt+q+zjLgQU
	 BUyh1Sr8huHwHJuA1ivTE7cvYTdM+BgaI2OwUooGuWdAHky+HVMV3xKJViN+hvdkvF
	 pI3Bqzmra/TY1QWhDj4QwW4e+DtPnkldM+RbLq8OA5GJnYfJ2C4HPyw8lIiaKAqC9F
	 UE++pRPBavhCP4PL709OT8SVK1uHUyQn48DrdttkxZfWS9yluYKPztivIpKSF51b8K
	 KM4d9OvPM8RqXr5VPhokRc/U/EA/VHCCii1pyiGbT5ZQPYADURSLCyL7Yt6lLAanPk
	 EA77fMI7dyxFg==
Date: Wed, 11 Nov 2026 13:27:59 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, apopple@nvidia.com, 
	byungchul@sk.com, david@kernel.org, gourry@gourry.net, jannh@google.com, 
	joshua.hahnjy@gmail.com, liam@infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, matthew.brost@intel.com, mhocko@suse.com, 
	pfalcato@suse.de, rppt@kernel.org, surenb@google.com, vbabka@kernel.org, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com, kas@kernel.org, hannes@cmpxchg.org, 
	riel@surriel.com, shakeel.butt@linux.dev, kernel-team@meta.com, 
	baolin.wang@linux.alibaba.com, Nico Pache <nico.pache@linux.dev>, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH 2/3] fs/proc/task_mmu: don't read young/dirty from a
 non-present PMD in smaps
Message-ID: <avRtKQUdo_oEqyow@gremlin>
References: <20261111113904.650722-1-usama.arif@linux.dev>
 <20261111113904.650722-3-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111113904.650722-3-usama.arif@linux.dev>
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: xx5pjhbess5dpfh8w43rzzt46wttrerf
X-Rspamd-Queue-Id: 97279C0003
X-Rspam-User: 
X-HE-Tag: 1794403691-409727
X-HE-Meta: U2FsdGVkX1/jrmMolDdtPqEnga2VhpuNMD4ebo3mkPSugZ6Wamor/3TlvmCutdikXMlnNzf378XlpFP9jwf5DehmgekGiMHGISFOgT2ZaeIUfrOqJMmg/rgRnRjr0txGCd0aKDFsZJ8az2B4Nx/eyJSQXFc4m14gfkEI8MV25cP1yIJL+rMO56MCFxBF7Qah3DWmc7+Lsp8r6ldonF4+XxqF1k6jeTJEf6FyqXYZ2eE2PFz+IioJuoDaLw7dRjESuqwZC+whbqmf8+ax+q2cwGkrkmUSvp7BjiwEG2xUU1iLjoZ96nwnBhI85NfeR3Fy0baJuaGy9fr33O4p7h59fz+HMKjbeypIi/9IFRgZSPavj8D8Js1IZAu19rfLiIXyDEvxjNWt2Ya4ZVIihpK/DZheL3g6X5sXhnbKQXHGbz5jnpQW22Y9LHhFvZxqYzBksfH03DL4VehQw7Kk/snxrJ6XtNMxP42+AHHHNZN4svrHeU7cYH36SOHGUC+oQ4qUop98Bqkzkss1j678HZfUccKwS0reSmEokk3IofvrfKGAxAQksgYa4lzi5CNtZ02Vu6RkOUAKl6jUECzfx38bVYOX3B//fNYtoJwe05OW05We1RCyEhkCNTsxRRvMC5pNAQvscXpClsK5DddMj6ozvx8RUiGjM5ONehiEMGRJ9iFoG4C2u761O2oaM5SP79xGJk/RkPbGOYL/6n7FZO1lZ+kU8O+tOTrNLni/o1k1G9dEu7is2KFNnRG8CCb2IY0o5+AGmNgkESUo2cW0+TBq8Lg9jfQuUbQtOOD6tT6xzGkHCWsIGG0IiweHRi31sGqa8TbqDq5ZiqEpxUzLnJ5jZaFpdrtoZeyWdpD5/l/aKeFW6yTx0Ag8h6llweeSyZaO4kO4bj9WG67E6s5KYdaqYCaDAzNjHxm2px6k6y5i0efZ2uyqUcQ4o+Koyn5h2Tqdj0EIosx7D3KGAzB5GY7
 4NKSQqp2
 cOB21225EX4x2iXYtYBuvCk+gdfRIBEkVwdHEvwt5HARWcuvaVTM0L9BEs5qBNy5cHGLziLtc8ZioTdot9+yXAKWc2mFYhZB9qKRH9l7xOTe9+7kfpY1pCyoA51T2gE/WyPzss6AJmweekfYDW6T8eqLtfmc9FdVMDjMkOTieEHB29gm1Q/Y4hpispAW9rWhYvK1HKBeGAgXjEjg0N6LykC8Xr0jXoPL8NuibF+fqzoxj8dgMCkN5DULhxyC5Bj6Us+LN0aIRYfAWWDi8pcq46kZmoLvESNwda50KVYSutyI7uPJ9MGl+uO2FRivGbwRlEn+j6XehSx9RgnrGnr2BborB7qo7tSMnLPUSTngZIga8QByAyooB9reYdP+N+0NkjIMEPmw7RvJSqFm447RamYq7eQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 03:38:30AM -0800, Usama Arif wrote:
> smaps_pmd_entry() passes pmd_young(*pmd) and pmd_dirty(*pmd) to
> smaps_account() for every PMD, including migration and device-private
> entries, where those bits hold part of the swap offset rather than
> accessed/dirty state. smaps_pte_entry() only reads them when the entry
> is present.

Could say something something softleaf here ;)

>
> On x86_64 the offset is stored inverted across bits 9-58, which overlap
> _PAGE_SAVED_DIRTY, so pmd_dirty() returns garbage: a clean 2MB
> device-private mapping is accounted as 2048 kB dirty, and lazyfree
> accounting is suppressed. pgtable_64.h also warns that the hardware can
> set the accessed and dirty bits on non-present entries by mistake.
>
> Only read the bits when the PMD is present.
>
> Fixes: c94b6923fa0a ("/proc/PID/smaps: Add PMD migration entry parsing")
> Cc: stable@vger.kernel.org
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Damn, yikes. LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  fs/proc/task_mmu.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 22361607020d1..c0d391186c2b8 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -1019,13 +1019,15 @@ static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
>  	struct vm_area_struct *vma = walk->vma;
>  	bool locked = !!(vma->vm_flags & VM_LOCKED);
>  	struct page *page = NULL;
> -	bool present = false;
> +	bool present = false, young = false, dirty = false;
>  	struct folio *folio;
>
>  	if (pmd_none(*pmd))
>  		return;
>  	if (pmd_present(*pmd)) {
>  		page = vm_normal_page_pmd(vma, addr, *pmd);
> +		young = pmd_young(*pmd);
> +		dirty = pmd_dirty(*pmd);
>  		present = true;
>  	} else if (unlikely(thp_migration_supported())) {
>  		const softleaf_t entry = softleaf_from_pmd(*pmd);
> @@ -1045,8 +1047,7 @@ static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
>  	else
>  		mss->file_thp += HPAGE_PMD_SIZE;
>
> -	smaps_account(mss, page, true, pmd_young(*pmd), pmd_dirty(*pmd),
> -		      locked, present);
> +	smaps_account(mss, page, true, young, dirty, locked, present);
>  }
>  #else
>  static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
> --
> 2.53.0-Meta
>

--
Cheers, Lorenzo

