Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DB3E606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 07:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bj9YUBQj
Received: by kanga.kvack.org (Postfix)
	id 3774B6B05B0; Tue, 17 Nov 2026 02:15:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34E9F6B05B5; Tue, 17 Nov 2026 02:15:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28BD46B05B7; Tue, 17 Nov 2026 02:15:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0060E6B05B0
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:15:31 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 76095140322
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:15:31 +0000 (UTC)
X-FDA: 85443750462.19.19FC3CE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id DB28F1A0008
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:15:29 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bj9YUBQj;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794899730;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mNOOLsZLwPJkMTA+fZzTwEqvEADECVJ3Qe+zvDqNddk=;
	b=vgTbAA5VqMWnR7ZL02uOXArvjzrkcUhBerjDaA87p8lUNm/Tq9v868047YU30bLpRHRYRM
	r6FGoaj1S8toBZtzYhUXOruIQ1XUEEtafRVakOn2bPzol1UxKDzxAB+S79I+r76pH71drI
	3/dmpu3/kXodlTClb4C3C07Bnunm3dE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794899730;
	b=gmcMc6ZXMDV++nundM+HelD34NV4aTqUUV0qT9TnBsy2B2GVgaJafeJ8lN2QeImfw63+gn
	WJ3A7in1+Z63B0Uux9uKxDFnRLITx+TOf5ELvDvcfM3XQaErYRvtcdpg8LCdVglrEcFx2m
	FunNrBCORfZVQni1rIIDUa0DPB/yBDs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bj9YUBQj;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1B02C61C6B;
	Tue, 17 Nov 2026 07:15:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9C2B1F000C4;
	Tue, 17 Nov 2026 07:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794899728;
	bh=mNOOLsZLwPJkMTA+fZzTwEqvEADECVJ3Qe+zvDqNddk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bj9YUBQjiYbRhZcNLeSb8pxVvVNA8HDd1zVlt9Ja6xYOfiaM0H0KWjkqG6Vcofoal
	 6GRemWCuMVGZdCIaCWHT9OUOeVVntcQSjW9FoXNaufdYmXwthGDATAY+V0eY9gCDxT
	 U8oZ2lvKi+ID2s7QAaE52AY/wIe4B5pID1QQyT+Wt29TbTKgY0C8B3SvKJ5uIl9QM9
	 7ukj0XnG/cN7j+DWA6Rh3pVXTrndRYLM4AZnhSU32zDPjPnrHgq35msvrETL74MxNy
	 PBMs/4esNGmDQ03Stz7E+x1EqZFgklFsoTZlqRk281pRcsAGQGmZvirOycl6tgX9c0
	 iZkuEeSENXHIg==
Message-ID: <sashiko-outbox-218305@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 07/11] mm/vmalloc: undo what
 __vmap_pages_range_noflush() mapped on failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hao Ge" <hao.ge@linux.dev>, "Suren Baghdasaryan" <surenb@google.com>, "Uladzislau
 Rezki" <urezki@gmail.com>, "Dev Jain" <dev.jain@arm.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Madhavan
 Srinivasan" <maddy@linux.ibm.com>, "Michael Ellerman" <mpe@ellerman.id.au>, "Nicholas
 Piggin" <npiggin@gmail.com>, =?utf-8?b?Q2hyaXN0b3BoZSBMZXJveSAoQ1MgR1JP?=
 =?utf-8?b?VVAp?= <chleroy@kernel.org>, =?utf-8?b?Uml0ZXNoIEhhcmphbmkg?=
 =?utf-8?b?KElCTSk=?= <ritesh.list@gmail.com>, "Shrikanth Hegde" <sshegde@linux.ibm.com>, "Alexander
 Potapenko" <glider@google.com>, "Marco Elver" <elver@google.com>, "Dmitry
 Vyukov" <dvyukov@google.com>, "Dennis Zhou" <dennis@kernel.org>, "Tejun Heo" <tj@kernel.org>, "Christoph
 Lameter" <cl@gentwo.org>
Cc: kasan-dev@googlegroups.com, linux-mm@kvack.org
In-Reply-To: <20261116071325.263682-8-hao.ge@linux.dev>
References: <20261116071325.263682-1-hao.ge@linux.dev>
 <20261116071325.263682-8-hao.ge@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 07:15:24 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DB28F1A0008
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: s8knc6dxqo5ejqzntp6qr9zigogqikue
X-HE-Tag: 1794899729-355084
X-HE-Meta: U2FsdGVkX180C9seIvljNx85tXH5tDTbd9mpCD40DcMGjw7bQNzy0utrM1gHG8oTsuj4FjI+GA83949w/lUlH/tI/XZhIdRBsEb4S7NEwiZXAGVwPcN1+Hny6ALXnURce38Y9XgbUGxpgJLS8AYmBk4rnnv4Rd2S5ZQoL9GOlnEZzs8ppdjDu8tHjwcj4wsr6H1NxpkgQuLmlc7J/Y5vsIufeOzy8AxvpWwMxIKAh1BWZUEyS7bRwWQ3duVCX5owUp3Jxrexklmk0DYTtChyBSuXgE5TJcGSWCWT+7Gh0KeTufHnfyc8Pagq3d9fP7mV0+YnVI0WljeJ6Qa1RJP7KB5AT3//gJRMSHG1JfrJo4l1NEaABGbab4duoxeNQ5JXk5ZhslSW9VZZX90vDn1YyC4cP/822BeE6qUKUk+JdxU5gTFZaj41Uy/CalEgLt8+SrW65YNHhScG7TNzp5LMx7gfC8Xsm9sbi6Hj8jSyEsrTqr2u8fcTGD37RwQhEAyC4fEHfX6qD30EdvKROzc/M9xuB3PcZYSedtLZxSnmjDU5Se7SJuRL1iVimvVmAgcMm4/J3CQyHW9noh7/QYEYvdRfqEl/6b/QpUJlnIPfukCu/wwbYnSOTo1ZklmAwsq4+++5POLoVo3D0vR7egm495S6oUz4SLmuUrVS1rNprDX53Zt3wn/C4x4TeqXvR7vf4bxwEvYvtYZTPmabhNwYILbisGC7brmPSsTScoRXYnu4nKShd6wXNoiXGMCRpcd/VEuxCFwnzjXOgQnqf+YEfhhQlCvMdMuAxgKqjlJAnxhBBONLyPqr4LlnMYqMCWvx0YGA8PXum1Vw404YcCwLOF5U4GbLgaOS7TZXgsovpDlBB4MhHYuJb1IdVsCBFrN4m60M6v4wd7U1Xr+hDT/lBiZREmfX5MzWdAj9lTpZfuc3aByrhQbCBT/52WKkqZK30CL4PpU9fwpES/SDubH
 IuYjFlHZ
 dJgjnCvX+KuB66OHAxKmVx8fsucTT41TPllgmKCNEqmWkmo+pKWlkBGKQXRBUlMxH/gJ/UaUo8fteB/4qaW+T//wo2O/MR1OlzcWu63tnP9BmEIEv/DVOeM+wEWymprW1g9vJ36nE2pF0spLLCyL8n31Rvv/jc6YEvfe+BUCfwQIH360T/HgH3+dK9g4x9QLAPPh5dEpJ0NSu0rSDJljiO6aZ9ZdE8v2GIs2skRKkQUDQnbyqeWaOLginkBoYGsF0gfehm82mhxaKrb0iz0C2pFfHv5YT68vyZt8uILJPc3cOdCR0hUvuEwXXe9AxZo3s5SBxB8/bwefGAaZlvQN3Xl6P7L1zNLNYGFTl1q/VcJwzxxweBE6KDn2Ze4C5BGTCa5sgTmBSCHAeXaLZdY4tCIqONTpPjfsBSdLFbp29CBwelC1Pk9uzJCd9j/IA3lUPYOdc4xW6KU7nq10sAse6E4GJgLPhgR+9STJ08vAUYdQY4V5MbXQknwYXioUlUipC3dtnfxdpxxliFF5NVoxC+CO/QlAg3IBpSeqDKmRvO7uVpxOCQE2pQSnKlzGhcDoQ3G6k68e2/r/eVkWnjrunhJTVTEyW4s0QMRRKUt6Ex05n8M4FObuzYmeu4/l0swVMzPlAuZxC0BgslQ3FgwuBuJwEfanpTdQVFHlvcyuQ9rEq/hgAhicv6pRk/UxpPQ2jy6kXZcJ2VxdOaUd0dCWyn2J5D043DjuyThzr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] mm/vmalloc: vmap_pages_range_noflush_walk() truncates nr into
  unsigned int
--

commit f06c1baff5ffda8b5f9a1dce600b9d716bd0c648
Author: Hao Ge <hao.ge@linux.dev>

mm/vmalloc: undo what __vmap_pages_range_noflush() mapped on failure

This commit tracks the number of pages installed by
vmap_pages_range_noflush_walk() and tears down those PTEs in
__vmap_pages_range_noflush() when a mapping fails midway.

> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 5c1eacc2a0ac3..4f3c320a48499 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -725,7 +725,8 @@ static int vmap_pages_p4d_range(pgd_t *pgd, unsigned =
long addr,
>   * may have contiguous chunks, as hinted by @shift.
>   */
>  static int vmap_pages_range_noflush_walk(unsigned long addr, unsigned lo=
ng end,
> -		pgprot_t prot, struct page **pages, unsigned int shift)
> +		pgprot_t prot, struct page **pages, unsigned int shift,
> +		unsigned int *mapped_pages)
>  {
>  	unsigned long start =3D addr;
>  	pgd_t *pgd;
> @@ -748,6 +749,7 @@ static int vmap_pages_range_noflush_walk(unsigned lon=
g addr, unsigned long end,
>  	if (mask & ARCH_PAGE_TABLE_SYNC_MASK)
>  		arch_sync_kernel_mappings(start, end);
> =20
> +	*mapped_pages =3D nr;
>  	return err;
>  }
> =20
> @@ -758,18 +760,36 @@ static int vmap_pages_range_noflush_walk(unsigned l=
ong addr, unsigned long end,
>   * The caller is responsible for calling flush_cache_vmap() after this
>   * function returns successfully and before the addresses are accessed.
>   *
> + * On failure the PTEs installed by this call are torn down before
> + * returning, so a retry sees a clean range; PTEs that were already
> + * there when the walk failed are left alone. When @gfp_mask cannot
> + * block, the teardown skips cond_resched(), it may run in atomic
> + * context.
> + *
>   * This is an internal function only. Do not use outside mm/.
>   */
>  int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
> -		pgprot_t prot, struct page **pages, unsigned int page_shift)
> +		pgprot_t prot, struct page **pages, unsigned int page_shift,
> +		gfp_t gfp_mask)
>  {
> +	int err;
> +	unsigned int mapped_pages =3D 0;
> +
>  	if (WARN_ON_ONCE(page_shift < PAGE_SHIFT))
>  		return -EINVAL;
> =20
>  	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC))
>  		page_shift =3D PAGE_SHIFT;
> =20
> -	return vmap_pages_range_noflush_walk(addr, end, prot, pages, page_shift=
);
> +	err =3D vmap_pages_range_noflush_walk(addr, end, prot, pages, page_shif=
t,
> +					    &mapped_pages);
> +
> +	/* Undo the PTEs installed before the failure. */
> +	if (err && mapped_pages)
> +		__vunmap_range_noflush(addr, addr + (mapped_pages * PAGE_SIZE),
> +				       gfpflags_allow_blocking(gfp_mask));
> +
> +	return err;
>  }

[Severity: Low]
Should mapped_pages (and nr_mapped in vmap_pages_range_batched()) be
unsigned long instead of unsigned int?

vmap_pages_range_noflush_walk() tracks nr as an unsigned long across the
page-table walk, so storing it into an unsigned int truncates the count to
32 bits and would leave the unmap range incomplete if a walk ever failed
past UINT_MAX pages.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116071325.2636=
82-1-hao.ge@linux.dev?part=3D7

