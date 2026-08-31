Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7963EC624C6
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 14:09:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45E1C6B008A; Mon, 31 Aug 2026 10:09:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E7B46B00A4; Mon, 31 Aug 2026 10:09:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AD1E6B00A5; Mon, 31 Aug 2026 10:09:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EC53B6B008A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:09:47 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 641DE80159
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:09:47 +0000 (UTC)
X-FDA: 85161748014.19.D22488D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 79CCE20006
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:09:45 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Vxa9oF/s";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of chenhuacai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788185385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L1mNt+t9t3Mp1gIJn7MX5n0Mz44VISN4VLwL6b799Bs=;
	b=5eiAoHkYfqPQxklwR9F6BrSvjkIjMr7XHPvWEkYuSX/sZ3jktR3lCzv0hYqt7o4ge1SmF3
	dK7Zm75OUaYaRxPUFL6gaXNgMAkzwZBrnvuUcg6b1G9z9yVNqKhPemUpFVkxFtD+wcskuU
	GiSJEVaYsyidqYNuyxX3zmyNTRstCks=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788185385;
	b=mBYSFFjgSwp5mFe5Vk6vVj6h65JgWpdazxj5ReZw9QbtbN7qs8O0YIAgvTM2r07BZYrZZI
	Z+IQNQYO1XdZX/YJEw838ty0bxcp/o6a8gkGObcshCyAKuWVvLwQMxajmmB4vFVVxI7oc8
	+K6zcyDIHwTaU8gqhH33J9fb8+WWdaE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Vxa9oF/s";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of chenhuacai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8E1DB43FCE
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:09:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 756311F00A3F
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788185384;
	bh=L1mNt+t9t3Mp1gIJn7MX5n0Mz44VISN4VLwL6b799Bs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Vxa9oF/soWfIGx7X9eBymk6tUBTtSiGceTld0BHTg54XTE1uWopGPbiR5qAiDdjda
	 iaJ3uvNfpOPmsRf222g18ht0Km7pm/98QZ3tlJNQjiOp3SaGMmyhyw9p/XFbPew558
	 7tVYTzHuDm97oKg0HjVguFpsU2H9obvZ9W+/j6RGvcDs5jyZtgUqmkq8ESPWdMekxV
	 d3j0zvnb5rRn9HJxwu8ZTDe6GNqARHZsq8wRDUFaq7Cjd+jP3t4AjfNlQD+ricbfQY
	 t6b8GVYS/5XDQNQ+BqQfQROnn9n7hMkhuJImHAKQavStYE25THku2v1yfK8B7efNmp
	 4dNZYg3inseBw==
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c2530cabcf4so544423366b.0
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:09:44 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqQwEvJ86JoqmVfpHB2VzxVKUDcZcUjiJiwBQ/qo8DMCzy9/PhvK4xGES8DPDhaptV8pluWCdD6ZA==@kvack.org
X-Gm-Message-State: AFuF++mxCfv/VgPSubjbjAXUDPL3OTYi9y3sexeABeb9p5nCdMIbSWrm
	GFMVNlaNgLjyGgPTXFdW4ykMkrYXyI8286Lw9nkHLH294oC8O5PjQsdGYAzENyuEeB+n2hAovba
	Bi0DcFYJI7i4CkyV/evbIRd9lFU+EQ4Q=
X-Received: by 2002:a17:906:4ed4:b0:c25:6c9a:88bc with SMTP id
 a640c23a62f3a-c25b3d8a1d8mr44713366b.19.1788185382598; Mon, 31 Aug 2026
 07:09:42 -0700 (PDT)
MIME-Version: 1.0
References: <20260826092541.3905933-1-ruanjinjie@huawei.com> <20260826092541.3905933-6-ruanjinjie@huawei.com>
In-Reply-To: <20260826092541.3905933-6-ruanjinjie@huawei.com>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 31 Aug 2026 22:09:30 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7+dO2rnb4KxRvVo1w_Mx8Vfsdq7LAbkzPfNYrwUhEtfg@mail.gmail.com>
X-Gm-Features: AcwNN1UnFQ4mMXEBOHuSLr0Mu3pUPtp_q9Do6p0Tl3kncID1TuZivoGd1AqJPW4
Message-ID: <CAAhV-H7+dO2rnb4KxRvVo1w_Mx8Vfsdq7LAbkzPfNYrwUhEtfg@mail.gmail.com>
Subject: Re: [PATCH v3 05/17] LoongArch: kexec: Fix CMA page leaks in segment
 placement retry loops
To: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, 
	kernel@xen0n.name, maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com, 
	chleroy@kernel.org, tglx@kernel.org, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, hpa@zytor.com, akpm@linux-foundation.org, 
	baoquan.he@linux.dev, rppt@kernel.org, pasha.tatashin@soleen.com, 
	pratyush@kernel.org, ruirui.yang@linux.dev, kees@kernel.org, thuth@redhat.com, 
	gshan@redhat.com, jic23@kernel.org, james.morse@arm.com, ardb@kernel.org, 
	leitao@debian.org, yeoreum.yun@arm.com, sourabhjain@linux.ibm.com, 
	coxu@redhat.com, tangyouling@kylinos.cn, hbathini@linux.ibm.com, 
	adityag@linux.ibm.com, ionut.nechita@windriver.com, liaoyuanhong@vivo.com, 
	seanjc@google.com, fuqiang.wang@easystack.cn, makb@juniper.net, 
	piliu@redhat.com, ebiggers@kernel.org, jbouron@amazon.com, 
	mclapinski@google.com, me@linux.beauty, graf@amazon.com, bgwin@google.com, 
	robh@kernel.org, takahiro.akashi@linaro.org, palmer@rivosinc.com, 
	x86@kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, kexec@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 79CCE20006
X-Stat-Signature: bwd9s7kkfwi54auqrw6i1e3dnp5k6zcq
X-Rspam-User: 
X-HE-Tag: 1788185385-233480
X-HE-Meta: U2FsdGVkX1/lnU6NCyvbK+atOA1tdyU5CHXM0MauHxCgRCRmxyONheB0rcPNv0iQwb/VqDF5GGB2/PghXCwUISTC7pugIUqjSaUCrkVouNqPxOBPdE5cUl5fJ5KOC/AmteARcoCk2+7pDpLboS8gfvA0rCV7e4HCEKkGTMas2rpHsmQf30F4vMfUj8Amcfn5Vpd4fSVupSdesF65alFQqMHObQoYc/BaLr25ytJw+AfrpmnUAVF2acgwj7BqWTX2mPHj6FD4DK/I6lpzrSaccUyq53HHYGiYDlMWx3OJ/ExhrSNRAx04Ibfa1JF979dKMcbot6YzNnDy495CV/1EBBtiyN3nYyIn2EtgPLCiIZSZgTXGISth2dUj9IZ0M04xF69R+i0TNTuyqbxF7JYXqfaHzrxaSlyBEKCudn0e2HYHKw7PQqGcFI1WXuQKriqUMxhGbU03hx9EkoXW7aDkj+D3R/IUfb6uH/NqYD704CKOvTqpx/RLGgGqlyEdsBYSJEzdmJSN94T1Ht/f4RSsKWo09BAeg4KqkfpnwHslKhgqnJfXzN/BtmQHwdwmNgrxvf4wHtAbuE4IFpi7xmamUV10Wh+0wUxaKfPiqi3thAxpi95u3BXcslzbPt0lk9a8w/VgV/nYcMsqs+wcNPZyhE8+PauLRkN2alyerhLHwoDhXHAisLHYTwFZrtSjgNDl85fs5tlh3CC1A5mdCQ+JsxV18u7tN/CrD/+oJlVVUoxDfZBdDcXK9tTghd0MsryT99P4GIkhn0uG4LE9ynTvuKBtKkNnMvHrhYnbDpMljFVQogRUIFpnNy2W3J1zSIxevbe2b/DNlu9pIvW/8L7vzK44HQXGm3rytQSmNdVOnxILo8WgUxYZwGPKLxHFabhh7Mmy5Pi3Ha/NgJVpl/rRMS4EFv55cACodkHOCWnhXBQxFREq1gM1i4PW+B2UhZeNyJ+PDAfR3xn5MEzcJ33
 B/8cKLgG
 3Ex48dd2FkaUXJIr/Tmxi5Lf/K1QLAKho90/emE739dQhd9+dNzLvtJFvckjGmrzgTKHOEejcDrG0AxPAsWFeIeuFYGv7lj+LVy7YndgLCx4RXZ//ej1pXRt44+FOkf6E3YKxXHiZZDKoWOrhOFboiEhA+kBYeYQ8Nwks0qv9mNWLqN7/7V02UrixbpDggMC6KjnRX5J+qFi9uZ3ADdqkPzI+kgvAnmeYORztQrfI9KWfnOA7Qie2pZ5LWDbEqjFW9831wAJCBh2FJNRyDZaeQRKfn92SO4wHteOhGCqnWjVKkOgk4r2mzqO+3eUDa34rngSF480a6PBbNpI06eHGddKo+kfqsn+5S6dkEqq1+kkPirqC9eAzXmqM8rZfe3t+03eQ0rMainwPI9EtQa7zN/zXO8CUUq662j5p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Jinjie,

Why does the ARM64 version of this patch use "kexec_file" in the
subject line but the LoongArch version uses "kexec"? It is better to
keep consistency.

Huacai

On Wed, Aug 26, 2026 at 5:25=E2=80=AFPM Jinjie Ruan <ruanjinjie@huawei.com>=
 wrote:
>
> During kexec image placement retry loops, any midway failure causes
> the loader to truncate `image->nr_segments` back to its initial state
> to purge the failed segments.
>
> However, this truncation introduces a memory leak. The CMA pages
> allocated via kexec_add_buffer() during the failed attempt are tracked
> in the `image->segment_cma` array. Because the subsequent cleanup paths
> only iterate up to the truncated `nr_segments` boundary, these allocated
> CMA pages outside the new boundary are permanently leaked.
>
> Fix this by explicitly releasing the associated CMA buffers in
> the failure paths before `image->nr_segments` is reduced.
>
> Cc: Huacai Chen <chenhuacai@kernel.org>
> Cc: WANG Xuerui <kernel@xen0n.name>
> Cc: Youling Tang <tangyouling@kylinos.cn>
> Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
> Cc: Kees Cook <kees@kernel.org>
> Cc: stable@vger.kernel.org
> Link: https://sashiko.dev/#/patchset/20260729031235.2840255-1-ruanjinjie%=
40huawei.com
> Fixes: 55d990f0084c ("LoongArch: Add EFI binary support for kexec_file")
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
> ---
>  arch/loongarch/kernel/kexec_efi.c          | 1 +
>  arch/loongarch/kernel/machine_kexec_file.c | 6 +++++-
>  2 files changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/arch/loongarch/kernel/kexec_efi.c b/arch/loongarch/kernel/ke=
xec_efi.c
> index 5ee78ebb1546..15fd797ff3de 100644
> --- a/arch/loongarch/kernel/kexec_efi.c
> +++ b/arch/loongarch/kernel/kexec_efi.c
> @@ -86,6 +86,7 @@ static void *efi_kexec_load(struct kimage *image,
>                  * We couldn't find space for the other segments; erase t=
he
>                  * kernel segment and try the next available hole.
>                  */
> +               kexec_free_segment_cma(image, kernel_segment_number);
>                 image->nr_segments -=3D 1;
>                 kbuf.buf_min =3D kernel_segment->mem + kernel_segment->me=
msz;
>                 kbuf.mem =3D KEXEC_BUF_MEM_UNKNOWN;
> diff --git a/arch/loongarch/kernel/machine_kexec_file.c b/arch/loongarch/=
kernel/machine_kexec_file.c
> index 5412aa9f3568..62a5be102065 100644
> --- a/arch/loongarch/kernel/machine_kexec_file.c
> +++ b/arch/loongarch/kernel/machine_kexec_file.c
> @@ -217,7 +217,11 @@ int load_other_segments(struct kimage *image,
>         return 0;
>
>  out_err:
> -       image->nr_segments =3D orig_segments;
> +       while (image->nr_segments > orig_segments) {
> +               kexec_free_segment_cma(image, image->nr_segments - 1);
> +               image->nr_segments--;
> +       }
> +
>         kfree(modified_cmdline);
>         return ret;
>  }
> --
> 2.34.1
>

