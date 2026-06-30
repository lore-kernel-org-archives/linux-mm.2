Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF371C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 03:06:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C23CC6B00A2; Mon, 29 Jun 2026 23:06:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFC3B6B00A3; Mon, 29 Jun 2026 23:06:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B12CD6B00A4; Mon, 29 Jun 2026 23:06:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8D0476B00A2
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 23:06:25 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0CA3D8D205
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 03:06:25 +0000 (UTC)
X-FDA: 84935090730.14.413A7DD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 185551C0003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 03:06:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V4G1wMfp;
	spf=pass (imf20.hostedemail.com: domain of guoren@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=guoren@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782788783;
	b=x6TcxAC+zMSBceBwqnH749X5AsxgpYQj6uzoQQXxeihT4LL/o/D8M4+5fvx2sZ6Pj3IPWQ
	kGYUJlc7ro2k2CfpIzjwN7SV6zDHHoD38BZY1M6F46qGfI/H8RAeHgfFC+pbELjWuIflST
	3yGLObvkNsRDb+VNfvY68ryuqSqYEmU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782788783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fzAepXvhPnU3RVO1srqzjPmRiEpd6yJalacgOF/VkH0=;
	b=dtSgSsc24HWuHqPgkhFiJcj/c9z1UqKitX1zNvktDWCeqVz/s9B3Rfz7uqp/a9inyuEzp+
	dVtOKtTv1pzSnptE9Xd/tYEyxTCguTnVgLld0yy8hFTVS4xGXd5EerOdJ57TTGOsJZRZ82
	UTJ3n0bY+D3i3KwHEzPNxcxJvcuCFVg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V4G1wMfp;
	spf=pass (imf20.hostedemail.com: domain of guoren@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=guoren@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 14CC242AD2
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 03:06:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDBAB1F00AC4
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 03:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782788782;
	bh=fzAepXvhPnU3RVO1srqzjPmRiEpd6yJalacgOF/VkH0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=V4G1wMfpqdrFTlqf/mZx519oKTZ/iLrU5sQVvxLgzRVooqRBV2OpUEs2CMcQLGXG8
	 0E3QAwT5brwXlhsrLl+/tcISCSjNRlIosA5w1C2796Kb/vqCd4ZvMO/gb7xsO3iEgY
	 cFhLc32ujpT7Ao96pr5bjIOxCZjC62NSzM7E6svWzhPqfEVh9JHnsO1dwCPGFdTk8F
	 WlCv8hdVZTrkGhWDR1+y/5Tju0/AzpkkKbRov0T051lSuG7N6TiUf3EzHRROV4HXwl
	 C55HBAOdmd9FwmTmabP4maTaKc85Gy112Ea+NsojFpqSW4LhVis7+fgjraqVCnlAAn
	 R1Yveb3sZ1JyQ==
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-4624a44e152so3652014f8f.2
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 20:06:21 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rq3f6uMdZTyoVfYYLaTShq/yFuBfGdotB3Kg2c6bNJSNdbRsqzfMiVrTuPq77gH/G13JjD1OObp/A==@kvack.org
X-Gm-Message-State: AOJu0Yzv7bAMA2T5v9XFkPC/Y61OFd5Ysr9N7O3QZXOEnw+BIWJVY+8M
	j+jKcxzlU8sleKByeTv30PCfv5d0XvvTj/tdupadlZ2kMJ1hDVu7MYfjnvWhFApRyZDgboITYtE
	TM8QKx4Af8cGE8bNGrrrbIBONzbGWgUY=
X-Received: by 2002:a05:6000:3110:b0:475:806:c5e8 with SMTP id
 ffacd0b85a97d-475506e972cmr2367506f8f.9.1782788780671; Mon, 29 Jun 2026
 20:06:20 -0700 (PDT)
MIME-Version: 1.0
References: <202606291606.9h8aGniQ-lkp@intel.com> <20260629171909.1d6e96dd15a80b8f463bb68a@linux-foundation.org>
In-Reply-To: <20260629171909.1d6e96dd15a80b8f463bb68a@linux-foundation.org>
From: Guo Ren <guoren@kernel.org>
Date: Tue, 30 Jun 2026 11:06:08 +0800
X-Gmail-Original-Message-ID: <CAJF2gTT+Pz51u2ckYQGye_TNbfbvHHiEHb0Ned-k0MFCe4vgEg@mail.gmail.com>
X-Gm-Features: AVVi8CfpjiHAZxpIu9w2olplIGKjchfQBEYO-NTXILWsnMIEoAgT2ud8VKG7C3U
Message-ID: <CAJF2gTT+Pz51u2ckYQGye_TNbfbvHHiEHb0Ned-k0MFCe4vgEg@mail.gmail.com>
Subject: Re: [akpm-mm:mm-new 59/142] mm/vmalloc.c:3590:23: warning: unused
 variable 'start'
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, "Barry Song (Xiaomi)" <baohua@kernel.org>, oe-kbuild-all@lists.linux.dev, 
	David Hildenbrand <david@kernel.org>, Linux Memory Management List <linux-mm@kvack.org>, mm-commits@vger.kernel.org, 
	Dev Jain <dev.jain@arm.com>, Wen Jiang <jiangwen6@xiaomi.com>, linux-csky@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: yyk36s6815mjhehy1zngdn96dnm1dgfi
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 185551C0003
X-HE-Tag: 1782788782-312887
X-HE-Meta: U2FsdGVkX1/vCdLMaVIwsUIlgB/1yzc3nnk3rpmtJM4vjQLQmHZZCPMlUwKxECO2TCYhPvL6eP/4a9o/JDFBUYOJ0/Y4LV0UNBTeAJ8XuaRr691nM6zmvGKLgv140yopxgqjzgKRdUADJ7v6ckcR0ULxZHri7ljHNiy/7Yla8Yx9ZFgUeaI73N7X+KJPL71NtD9AfVkjsaXlYQ7ZVxsVGZuy0qjFrHclDP8GI3CpSvXESQlUOF1rM2QlHhe3JJVQ32ND5IVLue9Qke6QRjR8I1J45c80GhVd2s4lmOow4cutF2ka+8Kzyx10cdeNP0ljFCJBPVdE8LH+Azchp+PC9t4aTrG31HQksQgy7ZKfNLLi3W2KfODS1F4ccS81HbOiAlspwnFfxkaddhkfBX0cN0c323tmoffkPlsMuthtROPvknJ5kilteYxdDGgprLJwsTPsWWxXqBr1CKv7b8iylb1MoHwEAwdZNOmkMdnXUolAYINeWF0yCAZDGEntjpZoZKKZ0DAKB6nOvzlIlXKHv3esx9TRsF3wdyYSuFnJc/OA0gxoQ5nwOJMpTTJLxzdlMKZ0bgqsqLtJeWG6DOus68EpWdAbrAEUegP30r9gWVjYCHDu8onWjfq2K6sbeRrL4cEcDe2IcsmvyUxd277H+KMZ4QIBM1AtKi6tcs4ssQTXFaytS4qdbz/UAU3W1GwqX6TW3AAR4IwVGpwfsyzHh/iIjvVQ5ceb78P71NjHtoS4FzklX9ny7J9tCSueYbVFbjMkBAfSQj029bbx8fLXv6BC/qXkp5sCg+49u57YDq/loUKkf47l/p2O5QXR0lCbjUqg9O3x1c4FjkWNcsfkEK0+8BjUfAFukB/saq3Qquu0nU0v+9QEw2WGQ0cU9y0TtV2+sb869s0oamHXLE6WXhzKsZuU56M+q7gq5lq1tKwy+0zu98PrNeCutkggXnQnA/0BstEII6WpyMIHGoQ
 51MILhlu
 BD5kbQdcnjP8HXo3orpag2vq4F1xmKeYo1Bp4GPyrFCXxBgfLbqJCzLFd75BlONUyJFx02nqBvXLScVqBst+ueyuiG7aYfKBL2Z52eaq3KJf0r6lTSf8L63X/MGOw9J6A9WnMhTE/Ss1xfYVrTlJZDCdASxsaW2CFDEx3b/pjVN27oPU+P3Bh8oK2A28Qv7cvGhJmizZ0uCtMbbG5lmw0Rc/Y4RA20POl5oGUu9yuXFVii0k1SE/+8Y/e4PfiXbVinbOi4LyEznS98fgqMDbvH+eBidLbBUA24kBKeK7RU6FRlMDvCLEzMFR7ILxXB9ZE8Ku7KfsRnBbVT8dtRRtKnkavfZDf6stFwyINV2rArDnps5+LN1Bdn3Ka2T2tOdRcPrhyEscqqUTRS9MmlywV5EK/NWAugcPpMSz3Kf0M3m3z54zekey2jJTA35VpYU8BDBok7hrae3604/5Diqfzk4aXicRUtXr/wEGvSxqrydc1xjHY0Jv7z0gFeGuIc5cjbSMcG/kz67nZm3hiAXUjySsl4ynJY305VauiqLR0jSyw2PWHE8tZYpfeK2lREnJInhp7TjpAF5+o8yE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 8:19=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Mon, 29 Jun 2026 16:58:34 +0800 kernel test robot <lkp@intel.com> wrot=
e:
>
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-=
new
> > head:   88cefc306c43b58d9bb65c9e96e284306710d961
> > commit: 80c453511b6ee1af0e4db83c3db0020215c4eaf0 [59/142] mm/vmalloc: m=
ap contiguous pages in batches for vmap() if possible
> > config: csky-allnoconfig (https://download.01.org/0day-ci/archive/20260=
629/202606291606.9h8aGniQ-lkp@intel.com/config)
> > compiler: csky-linux-gcc (GCC) 16.1.0
> > reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/arc=
hive/20260629/202606291606.9h8aGniQ-lkp@intel.com/reproduce)
> >
> > If you fix the issue in a separate patch/commit (i.e. not just a new ve=
rsion of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202606291606.9h8aGniQ-l=
kp@intel.com/
> >
> > All warnings (new ones prefixed by >>):
> >
> >    mm/vmalloc.c: In function 'vmap_batched':
> > >> mm/vmalloc.c:3590:23: warning: unused variable 'start' [-Wunused-var=
iable]
> >     3590 |         unsigned long start =3D addr, map_addr =3D addr;
> >          |                       ^~~~~
>
> Sigh.
>
>         unsigned long start =3D addr, map_addr =3D addr;
>         ...
>         flush_cache_vmap(start, end);
>
> See, this is our punishment for writing kernel code in CPP rather than
> in C.
>
> I'll queue (and test) the below.  It should be OK -
> arch/csky/abiv1/inc/abi/cacheflush.h directly includes asm/cache.h
> which declares cache_wbinv_all().
>
>
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: csky: implement flush_cache_vmap() in C
> Date: Mon Jun 29 05:07:51 PM PDT 2026
>
> To avoid getting an unused-var warning from
>
>         unsigned long start =3D something;
>         ...
>         flush_cache_vmap(start, ...);
>
> Cc: Guo Ren <guoren@kernel.org>
> Cc: Andrew Donnellan <ajd@linux.ibm.com>
> Cc: Anshuman Khandual <anshuman.khandual@arm.com>
> Cc: "Barry Song (Xiaomi)" <baohua@kernel.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Leo Yan <leo.yan@arm.com>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Uladzislau Rezki <urezki@gmail.com>
> Cc: Wen Jiang <jiangwen6@xiaomi.com>
> Cc: Wen Jiang <jiangwenxiaomi@gmail.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Xueyuan Chen <xueyuan.chen21@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  arch/csky/abiv1/inc/abi/cacheflush.h |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> --- a/arch/csky/abiv1/inc/abi/cacheflush.h~csky-implement-flush_cache_vma=
p-in-c
> +++ a/arch/csky/abiv1/inc/abi/cacheflush.h
> @@ -42,7 +42,12 @@ static inline void flush_anon_page(struc
>   * Use cache_wbinv_all() here and need to be improved in future.
>   */
>  extern void flush_cache_range(struct vm_area_struct *vma, unsigned long =
start, unsigned long end);
> -#define flush_cache_vmap(start, end)           cache_wbinv_all()
> +
> +static inline void flush_cache_vmap(unsigned long start, unsigned long e=
nd)
> +{
> +       cache_wbinv_all();
> +}
> +
Thx for the fixup.

Reviewed-by: Guo Ren <guoren@kernel.org>

--=20
Best Regards
 Guo Ren

