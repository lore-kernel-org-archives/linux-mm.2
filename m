Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F31D606D829
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 16:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F0ECtycT
Received: by kanga.kvack.org (Postfix)
	id 726486B05B5; Thu,  5 Nov 2026 11:52:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FDFF6B05B6; Thu,  5 Nov 2026 11:52:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C5BC6B05B7; Thu,  5 Nov 2026 11:52:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 33D4B6B05B5
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:52:51 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BCA9FA0B7D
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:52:50 +0000 (UTC)
X-FDA: 85401659700.08.4995E82
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 234B840003
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:52:48 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F0ECtycT;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793897569;
	b=nXch8x8GVqafMifujtK9INnNDgbyASsOZVhGoZtigLAB1AzOcS+NkzYgTwhtN2z+Zx5sLI
	39NvKfqV0ztVeZAgZbZ+yFuKMBpfuYTJo2qVpQgLIOGr8gOatjYzwtrMSRduChcR8GvyQ+
	SiFg9TGmDLrbLZVnOru3UYONelJ15Ec=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F0ECtycT;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793897569;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=93Jjsh5uP1bJuXaCFxDECc/bZWbVcYpxvdFTfNjDZUY=;
	b=EDPISzpnKTNG22d+BzhpVAfzRUd1d4jjHFwZp6ZcEERHsMAAzxSQzjBzPEIkeie/Wvoe3G
	tbMHX7+sLNzY9Anyr8GPC+ZzW6Qvv2Eh+Ywq3kvulgDKi6LSkkkzbBo3XgCwgMbffoqq2S
	VQzcohakrsHnw4AYwOmhYWEN1XRdsGY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A37DC6020A;
	Thu,  5 Nov 2026 16:52:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6AA51F000C1;
	Thu,  5 Nov 2026 16:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793897568;
	bh=93Jjsh5uP1bJuXaCFxDECc/bZWbVcYpxvdFTfNjDZUY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=F0ECtycT0ID6uIHdj/OpmBK2gU3FHjDn3/gApTFyDgc91RQtJ4WgWm+RL2HwAhVdt
	 nWsuBuZYAr0GwetQrft6qOL+ZG0OfKdSu4K1WmEtRjthoSmuVPdG98l1Kpwf6aQG0W
	 TxNu9lDTAXW6iF8+9OnH1JOR16vW2uC3ZObWq9SKfkU8PZEFIoJyiVJFzz4xz4fKVG
	 zzPcRa9glxwjIFDFcSrYw1yFqUAO0Hkna49kQLb0fVCLIYNVQjfbRuGEiahNsBkEYN
	 wkqeuLitvZXCR+Sp14k3ZHYCWxqNnyon64Q4EWpYZKeW/u8085i4PiD3HSrj4uKiaF
	 h72LTbmmT/bkA==
Message-ID: <sashiko-outbox-199544@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 06/14] dma-pool: Allocate CoCo atomic pools using
 CoCo shared memory allocator
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?QW5lZXNoIEt1bWFyIEsuViAoQXJtKQ==?= <aneesh.kumar@kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Baoquan He" <baoquan.he@linux.dev>, "Mike
 Rapoport" <rppt@kernel.org>, "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Pratyush
 Yadav" <pratyush@kernel.org>, "Catalin Marinas" <catalin.marinas@arm.com>,
 =?utf-8?b?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, "Joerg Roedel" <joro@8bytes.org>, "Marc Zyngier" <maz@kernel.org>, "Marek
 Szyprowski" <m.szyprowski@samsung.com>, "Robin Murphy" <robin.murphy@arm.com>, "Steven
 Price" <steven.price@arm.com>, "Sumit Semwal" <sumit.semwal@linaro.org>, "Suzuki
 K Poulose" <suzuki.poulose@arm.com>, "Thomas Gleixner" <tglx@kernel.org>, "Will
 Deacon" <will@kernel.org>, "Russell King" <linux@armlinux.org.uk>, "Benjamin
 Gaignard" <benjamin.gaignard@collabora.com>, "Brian Starkey" <Brian.Starkey@arm.com>, "John
 Stultz" <jstultz@google.com>, "Mark Rutland" <mark.rutland@arm.com>, "Radu
 Rendec" <radu@rendec.net>, "T.J. Mercier" <tjmercier@google.com>, "Madhavan
 Srinivasan" <maddy@linux.ibm.com>, "Michael Ellerman" <mpe@ellerman.id.au>, "Nicholas
 Piggin" <npiggin@gmail.com>, "Christophe Leroy" <chleroy@kernel.org>, "Ritesh
 Harjani" <ritesh.list@gmail.com>, "Shrikanth Hegde" <sshegde@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Gerald Schaefer" <gerald.schaefer@linux.ibm.com>, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Sven Schnelle" <svens@linux.ibm.com>, "Ingo
 Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>, "Dave Hansen" <dave.hansen@linux.intel.com>, x86@kernel.org, "H
 . Peter Anvin" <hpa@zytor.com>, "Kiryl Shutsemau" <kas@kernel.org>, "Rick
 Edgecombe" <rick.p.edgecombe@intel.com>, "K . Y . Srinivasan" <kys@microsoft.com>, "Haiyang
 Zhang" <haiyangz@microsoft.com>, "Wei Liu" <wei.liu@kernel.org>, "Dexuan
 Cui" <decui@microsoft.com>, "Long Li" <longli@microsoft.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, "Vitaly Kuznetsov" <vkuznets@redhat.com>, "Andy
 Lutomirski" <luto@kernel.org>, "Peter Zijlstra" <peterz@infradead.org>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>, media-ci@linuxtv.org
In-Reply-To: <20261104164555.3555725-7-aneesh.kumar@kernel.org>
References: <20261104164555.3555725-1-aneesh.kumar@kernel.org>
 <20261104164555.3555725-7-aneesh.kumar@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 16:52:45 +0000
X-Stat-Signature: woccd6wwrs74uoh71pskhjexrwr95r7f
X-Rspamd-Queue-Id: 234B840003
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793897568-784685
X-HE-Meta: U2FsdGVkX187Eo7V8EdBn8aPi/YFa3+OJybjaRuVQmWnR27ZFLpH6BtElKemS2CeiTB4GyElR1Ex4OqWueGxdNwQed+oxc8L+xDxEsLkZP9i7ODeBKDC/aT6mPh8A9t1rScuUJmz5AUWjXn/m2+gGm322Ap8rvmIg45gMwf817mX7T90NO4MdPQhCpSZd1YrdKx+H9dwWyPsM+sxa8r/83QkuOvlF0euqcN14tRhY4RVl7K3gaUUWzDck67dvgAjR1F8y/I49y9JzPefrdPwevBbaImrDA8+ddsu27yaMPFEGa3/SUzgx8cQWFhtyilwrMN34yigOsifc17ITFZ7VVFmMWpyFe6b1yeS9T7Rs6/T8KHbNXMEdagsDeL8Qw+5ku3sl4BqDRRKIHmF/M8HsoUhGvwiPqMBWHevlBiXx+qRpysKOt81UhLhXFx12xTs6KuCQdPRxygY78hw6yMnqVHbmVg7X2Q4oDtgm4KZu6CuwjB+lZKga4wqmhbAcqu1xzffYnQFo8dawtFgaKEZc/1w9vigpkHR4qoeqYTYsuDBnGiHMFFCd7neFod4baFLcLOs8S7g02IxfMMM/RiT3KZDCsBzUhoC8jFL7meDuRrlHWqKAxivVJLzcs+hCRN28bg9CjVTPH4g3zekJyEgP4bN7WgFipmY7irFYdKMyj0Dym278f4mqOmqVsv5KVmvD31UvaltfXZOuTUi1XL+F65yMEb2/rnxRxMrrOci3oKrtyJWljaRejp+ktu3/eLEm9xjKSMcb6p5uE0pbOkw6ggAOwtemDqsi6o7BOz1KciZLoKdAqJ3vLGfM/lQZsET/vnCoLqMwEUi3ylY8usp8kEXU480/15kRjOanLzubyDu7mVzl5DVL/UNGi1h/mzphNUVXXa319nXAaUg9RnHd06Cip/L6k4V+8zQVBig1Fv6rB3s/KC7y2NgiJ/myq2/XynaanhVaYocED178m8
 SemSgran
 TvaEbVpJOknwpi519+KAznnDoMb22ZXi3yKRCEXeVwf5DPswb+pEMjkjLR1GuNNSE07h+M5VyeoDL/J3W44Gsmq8YiJ2vg+VvpJE7+IHV0LIm5r6NnT7OYzU+DXIXgfaslZOOiCWPsOCEFwc/gCVvt9h5co6f0taBew7cN7VZyYgOMq3tAwFkKN6AKgL9qSjIjDLqopFkxsltN5li/c83m0Jz3jg3MFh9DF16CM0wNl95VCZ7teqdOLj8+menfZ9YKK88oHs2yFzK65MXtH/iYyDAtsRtHg34soKArAu+ybQdUsbqJ+oO6DCfSzMJ9MbqEGzX0Yh381s/35oq7ZijPUE/sW92NyFWwo0pnc1M9tKtKruW2HaQGYdBhwPSU2jQzh/49moU1s+cmy4PvtEVYSfzDTAHGU9jLxxba41iMGyq8bUDuP6ZDkxhC9KAZvxKm/9pEA50cPfEZvfiKF3HYLHGJnEe1UYYf0cWY7nP55SruSgtLvQeUbDvdinBQIRZk3Z0S8KAv++ds8hh+T/NB2yUa2y17BtY2WRJWjXNrI0v6BvMVTzknGVddVvGJkTdzeJy2EB0tIaUil9qvKzd0YQPkr6nBu5pjVp9mlW99fJXrADj7j4VTGhyffMSAPdvCp5npv+4lYispi2/q6WwNT84PIZGeOaNbJF7p6c7Le65dGAF+kB16nhw78tZqe36jvxxtFOHLP1UeCg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] dma-pool: cc_make_shared() runs after arch_dma_prep_coherent()
--

commit daae4fcc15a00bc83c4081ef4b27786a7f224537
Author: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>

dma-pool: Allocate CoCo atomic pools using CoCo shared memory allocator

This commit updates atomic_pool_expand() to allocate confidential computing
shared atomic DMA pools using the cc_shared layout and transition helpers
(cc_shared_calc_layout(), cc_make_shared(), and cc_make_private()), enforci=
ng
shared granule size alignment and minimum allocation order.

> diff --git a/kernel/dma/pool.c b/kernel/dma/pool.c
> index 70b7f64b17ab5..da487c3f9dc61 100644
> --- a/kernel/dma/pool.c
> +++ b/kernel/dma/pool.c

[ ... ]

> @@ -126,8 +142,7 @@ static int atomic_pool_expand(struct dma_gen_pool *dm=
a_pool, size_t pool_size,
>  	 * shrink so no re-encryption occurs in dma_direct_free().
>  	 */
>  	if (dma_pool->cc_shared) {
> -		ret =3D set_memory_decrypted((unsigned long)page_to_virt(page),
> -					   1 << order);
> +		ret =3D cc_make_shared(page_to_virt(page), pool_size);

[Severity: High]
Does calling cc_make_shared(page_to_virt(page), pool_size) after
arch_dma_prep_coherent() and dma_common_contiguous_remap() leave dirty cache
lines on the cacheable linear mapping alias when CONFIG_DMA_DIRECT_REMAP is
enabled?

In atomic_pool_expand(), arch_dma_prep_coherent() and the vmap remapping run
first:

kernel/dma/pool.c:atomic_pool_expand() {
	...
	arch_dma_prep_coherent(page, pool_size);

#ifdef CONFIG_DMA_DIRECT_REMAP
	if (dma_pool->cc_shared)
		prot =3D pgprot_decrypted(pgprot_dmacoherent(PAGE_KERNEL));
	else
		prot =3D pgprot_dmacoherent(PAGE_KERNEL);

	addr =3D dma_common_contiguous_remap(page, pool_size, prot,
			__builtin_return_address(0));
	if (!addr)
		goto free_page;
#else
	addr =3D page_to_virt(page);
#endif
	if (dma_pool->cc_shared) {
		ret =3D cc_make_shared(page_to_virt(page), pool_size);
	...
}

Because set_memory_decrypted() (in commit 0a47431deefc ("mm: Zero memory
during shared memory transitions")) zeroes the range through the cacheable
linear map address passed to it:

cc_make_shared()
  -> set_memory_decrypted()
       -> realm_set_memory_decrypted() / pkvm_set_memory_decrypted()
            -> memset((void *)addr, 0, (size_t)numpages << PAGE_SHIFT);

performing this transition after arch_dma_prep_coherent() has already clean=
ed
the linear map alias dirties the CPU data cache for page_to_virt(page) with
zeros without a subsequent cache clean (and on Arm CCA, cleans the protected
physical address alias before the RIPAS transition rather than the shared
physical address alias after zeroing). Those dirty cache lines on the linear
mapping can later be evicted to the Point of Coherency and overwrite live D=
MA
buffers accessed via the non-cacheable vmap alias at addr.

In contrast, dma_direct_alloc() transitions the pages before calling
arch_dma_prep_coherent() and dma_common_contiguous_remap(). Should
atomic_pool_expand() similarly call cc_make_shared() before
arch_dma_prep_coherent() and dma_common_contiguous_remap()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104164555.3555=
725-1-aneesh.kumar@kernel.org?part=3D6

