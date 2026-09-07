Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B61EFC79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 14:05:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C41046B009D; Mon,  7 Sep 2026 10:05:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C196D6B009E; Mon,  7 Sep 2026 10:05:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B56C86B00A6; Mon,  7 Sep 2026 10:05:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7B7626B009D
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:05:47 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F18B0C0191
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:05:46 +0000 (UTC)
X-FDA: 85187139492.03.BEBEA78
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id F37691C0011
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:05:44 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RUOrHYoQ;
	spf=pass (imf20.hostedemail.com: domain of chenhuacai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788789945;
	b=63AQY2r0uEllwIwb/zfFDgiHhVu3B3ZU2hjhW3rlbk3mdff54sbWFzl5DshWsQZCv/cp8l
	s+jTlzbMN1tXXnTzru5GS903tE7vdp7LzynefNF9AfZ8U3e7hRjhCMyqSlD8puzrAs+0/D
	yULCTQWTEnagvDyJDYh1BiZrpLBXJNg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RUOrHYoQ;
	spf=pass (imf20.hostedemail.com: domain of chenhuacai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788789945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J8wgTvZrkyOjbsQqIGG8z/GcZBW64PcNCuag9I7xU18=;
	b=Y7zLFxPFfBT4VlivdWkp7hFAjn7oQqvwZqaB2p97pU/jgCBe2YOsorGg1Yu+Nx6sejti1L
	yWTaifG0rPUORZPYY6olzAEQ2nHkcJVkNRC+BJqn9nAGzhOnz3wNyY/8112Ae3VqUB1OhI
	nbbXiBfybbIrhHYJQu+gQIpjsHpwqAA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 21D50447C7
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:05:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0632D1F00ADB
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788789944;
	bh=J8wgTvZrkyOjbsQqIGG8z/GcZBW64PcNCuag9I7xU18=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=RUOrHYoQ+GLUyustaOnDD/vRwxQkg0yItQIODSKnHeBn6PR1CFn6Q4JdGPyRYxYXn
	 /pigYEE+G8ttU7Qw/R4ZmqcU7u+CV4dKriAE47XIyb0BLZkbfgWTuXKq3ygVUdcMIC
	 TQZBfVG/Fra4KYmPn0rPwu5YfWec1orKABhiYS/pQKSsklAIFoZrSeVdKr28Y9+Z0P
	 RPkm+G4LLVtn5zA/QC/qOaR+3kNDkoHius/qanZSQTqnQIC2Yr9c8F9r0WwY648I/1
	 K9O/ksatGWFHCHvj9qeBXVx3I9l+33ONlsBHTy+KivEqNDk0JKYtVNiZ3DXSf/8jyd
	 xB7l5G2SraVaw==
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6a682579c72so4524342a12.1
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 07:05:43 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBz27Wg7+rugtF/dLlQV+WkWkaOVH53A7T93bq5wj8SkVNDSAPXbp8t6I5hu05foj1sBFoZCY+Y4Ww==@kvack.org
X-Gm-Message-State: AFuF++npvsRGevEXupXibI0Bv/3XAJm9DoK8QROmSCYmkOT3nf2Rf0gx
	zmB8Fa9wV/x2yweF0AklhPeVQMzZKWQSFUXdtk5CltTcPmsuGmm1Qq4nyePhKB+lgAAWgS8OfQ+
	pDUZzbnz1DEHa4qiFM0TMzk95wXv6Sf8=
X-Received: by 2002:a05:6402:44db:b0:6a6:7fa6:f0ac with SMTP id
 4fb4d7f45d1cf-6a7e8f9e843mr12416286a12.22.1788789941040; Mon, 07 Sep 2026
 07:05:41 -0700 (PDT)
MIME-Version: 1.0
References: <20260907125404.922123-1-ruanjinjie@huawei.com> <20260907125404.922123-6-ruanjinjie@huawei.com>
In-Reply-To: <20260907125404.922123-6-ruanjinjie@huawei.com>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 7 Sep 2026 22:05:34 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7qjJ7BPnJ2KoQZSyMUvX_6i9H=EfdadXnmXtNiiB4ROA@mail.gmail.com>
X-Gm-Features: AcwNN1WbqzVfALnNIkIUg_l9MiYgRfsYFTxDDEyu_aV6t47lWMUK_7ZDBokn7zg
Message-ID: <CAAhV-H7qjJ7BPnJ2KoQZSyMUvX_6i9H=EfdadXnmXtNiiB4ROA@mail.gmail.com>
Subject: Re: [PATCH v4 05/12] LoongArch: kexec_file: Fix CMA page leaks in
 segment placement retry loops
To: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, 
	kernel@xen0n.name, maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com, 
	chleroy@kernel.org, tglx@kernel.org, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, hpa@zytor.com, akpm@linux-foundation.org, 
	baoquan.he@linux.dev, rppt@kernel.org, pasha.tatashin@soleen.com, 
	pratyush@kernel.org, ruirui.yang@linux.dev, kees@kernel.org, thuth@redhat.com, 
	jic23@kernel.org, tan.shaopeng@jp.fujitsu.com, zengheng4@huawei.com, 
	james.morse@arm.com, ardb@kernel.org, leitao@debian.org, yeoreum.yun@arm.com, 
	sourabhjain@linux.ibm.com, robh@kernel.org, coxu@redhat.com, 
	tangyouling@kylinos.cn, hbathini@linux.ibm.com, adityag@linux.ibm.com, 
	djbw@kernel.org, seanjc@google.com, liaoyuanhong@vivo.com, 
	vishal.l.verma@intel.com, fuqiang.wang@easystack.cn, makb@juniper.net, 
	piliu@redhat.com, ebiggers@kernel.org, jbouron@amazon.com, 
	mclapinski@google.com, me@linux.beauty, graf@amazon.com, bgwin@google.com, 
	takahiro.akashi@linaro.org, palmer@rivosinc.com, x86@kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: F37691C0011
X-Stat-Signature: ta91rq9jseqne99fi974y7uzhuiqqwkz
X-Rspam-User: 
X-HE-Tag: 1788789944-622624
X-HE-Meta: U2FsdGVkX1/2KK9wZ8VpAm88fB6TSA3BHJCaZE5f/wfVVP21K/mcsZm3sE0auMP0LGAE+nPjaWPXpPEmnXY/MrLNNbSNn+gkcml7pkEzwlHgzBhl+Ybo52wJaXcBd54FgorNxQt2gC3EbsW30WIQarBnm5+riDuZvw/UVP3cz81CQ6heZ4PJfXkAnG8xvcXtYhFhWidEWfWE0SYxlXXJiD575NqvXmipQJVA/GWbMyPzIAnVCyltUNWVFwYabHj+69BSuZ+sV1frf/3TxctwZklh28TOKa5JGGjwSNT8TRm0/s0QXHVQnvJFaKNfKC4RJ2WHWCckBjDZWCFRZm4L3TEiCTae/Ugkk7vuJ7RKJ1zwMd/U01qztWu5QGdeLHhAD2dKJX24CFIz1GcBk+r/ShJ981NbUoX1onWreowjuRnqVz4J7Zj/HjwAUlyBotIcGIW1Ki2ddKqNvkcA/NsqIk0lppTSdgEzdN2ltFkl5Zg+cRgojE6F3ZbSflmaD37ymJz5kfJcgfXcAWl1FQ8y/xlULg4naXdmILvqXAkYO2JlA90yvGbVWZBMw7fGUvFIgLRBZDotWhJBdmvl0ZH/dpUgwjTUhY94X3w4cybE70fCWNVQcUYhHVOIlc4O1o2UE+xx7KbCOBQsaQCKCAvfe3naMd7Pin97jsrsdSEe+kg8swLCzvYB7WtXoyUask3OzmbswmkMJBYvLvCv+zzHxF3LLrQ397NyuIrZRLjqijqHYaMUgGOvRZuNMM0Hu5x72sLAPeyULkHNg1pVnCByIunTFfza9QAF3Tgo3ionaA4exQCasDrYlt7mwZV0KiiqS6TVQbV+W+To96STtTZ1ge+ayG1HQtW7QT0ppDfpuPQlZCFnami5hZAY5yKH/3Gj5IlQdZR0AsrGX6g6iEWk2C8+e+R5T02jIeyCIf8A5nbyT8CEyk9eINwGn017rZUfVRXRwTtOBTh22+M6kaI
 PFtS/Ck7
 MVv+XxCOv0c8QFeY+ICzpOQZE6ZDdKm8at/IOeihwJ9GxShTWPDtjltG7llXhySeBcZAQzihl3dxIF/uHWG2gTfTUmNcE6CgtJNIvQu5IY/EsCCdyhnEHbfWZD9UdRTDG4PAj2YqasaL7fs7DMGpM/3m0mkkEDSoHFesg4O2bdu9JF+bIuogQhNbonG6D7Zn0gwp/gffPSIbPW1HRP/XxCl3ihK/YHosgiRVHkVgYeq6xEHvQgI5VUlkCzJEWM4/LiH+idtngxWrZjZdMFbFJUyItEtPl14qhGORr3dkUmNDTiX5vKBj3lRuiBpC2VjxcsSgmYScnvKYNihq6gqW1ibVIflr5wzOOhu5RxhkFA4azqQUA5BKwETqWrqamAD3Ne8Mh9HJl2EuFz/X7MkcYua5wbnuMqYssOXLnFDF3X1J0+2d/TKpvbxyt7WbZJ8n1h2IIAvdJiU5FMi8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Jinjie,

On Mon, Sep 7, 2026 at 8:53=E2=80=AFPM Jinjie Ruan <ruanjinjie@huawei.com> =
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
I'm not sure but does the elf version have similar problems as the efi vers=
ion?

Huacai

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

