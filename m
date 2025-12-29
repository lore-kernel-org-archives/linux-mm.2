Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AAB6E9271B
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 01:26:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90A1C6B0088; Sun, 28 Dec 2025 20:26:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C17C6B0089; Sun, 28 Dec 2025 20:26:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BFB36B008A; Sun, 28 Dec 2025 20:26:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 66F576B0088
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 20:26:00 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E19481A05C9
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 01:25:59 +0000 (UTC)
X-FDA: 84270767238.07.781E895
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id E4C74100007
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 01:25:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JRFWKJxz;
	spf=pass (imf05.hostedemail.com: domain of guoren@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=guoren@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766971558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W+mdphFdhHyow6rAPBZM50HCMYbmaBeO4dGerIc0iH4=;
	b=Poj/QgCxaRLkqp8BiYOuRwnauhLsINvYVYG4t/65FZY7OUfHhn8GmLBGfMpgfDxC+5IerW
	RtvtJXwJ40T6bqn/a52U11IHpuydMppNF7xIkcS2jVGw67kzPkSymKOR6QU1NpQMExCq6Z
	QmSHGM0GXI9bDY+mVFIO4xWeEEoonBY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JRFWKJxz;
	spf=pass (imf05.hostedemail.com: domain of guoren@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=guoren@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766971558; a=rsa-sha256;
	cv=none;
	b=nb7BTRXYnOhKGXZwPcu7Tl+TxUcLu/6uN8M0+PqAWwY7gGpV661UTMQPNqWJtWTgTptiRa
	xMZUIh5Gs0Li4I9DhwZI6HaVkEgMjJymBZuECEiYrCpAJ1t5W1XSz2cxT0gVHLUEQDB51i
	fngOufJZJvCF9Jl80QTrgLDXGHdMpY4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C165444485
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 01:25:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2516C19421
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 01:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766971556;
	bh=QcHUIuYE7RQs56jGjmqpy2oUOjx983YRYnPBuaD4boU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=JRFWKJxzPMVQR44/fR5nIIhozZE+LgKUESPHybZ8wZno197JiHenXGKVJkNpSqguw
	 2xLe+veDDWm8kNDY+BiuQ6SvvVwq4Hpcc3W1hwbZp+jfRAR1nDJPVP4EK59344ImkK
	 wlsii6F/eZYefoyYAw2fXzJjRbRH+kzlnYLQAY1eO5Ubr8qm60ldJqs+pPD1ZsFSsg
	 NrY0alhp0ugdEFKLyzrY3OxKA1u0ctAhx1QBGvs/z6tbv8fsSbtYftMz3kEpB6/lKF
	 BZtMwOxmk5Eoyviyb7mYDSTLqm3LFsfpO0X0ux1I+BeIUazvoB3riY6Caw19+VvfnP
	 zpfyrSVDOV9qA==
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-42fbc305552so6952046f8f.0
        for <linux-mm@kvack.org>; Sun, 28 Dec 2025 17:25:56 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVSP9KfJvOjWcXZ6NV6OSNEdWGKc8UC2o3OB1o74c0NAAWkY8vkvuBHgrM0PSwRSjOQWY6iYeKIgw==@kvack.org
X-Gm-Message-State: AOJu0YzaV5HcnPV1Ol28OlhtgiG5ueB4DtfOgfU/sd2ds3+Q6m2obhVL
	rQVeCCQwxN71RNKUemJhVJmAvhbCIybyzH2SQ1AKAnWHuEH3Q869Qu4+V8ZTfhQVvMf6BuFn0/D
	0p1RYWWJPYLC8AqXD1VFWSX8nIeIJVaI=
X-Google-Smtp-Source: AGHT+IH0/4lM/7b5Nef4Fb6rn6mJpOxGdWgk9AqK9LZQSl+6Va320QICtWgPPv8KCBU6m5HaJgurTChUGp2fBhZ8S4E=
X-Received: by 2002:a05:6000:2308:b0:430:ff0c:35f9 with SMTP id
 ffacd0b85a97d-4324e50d989mr31524498f8f.48.1766971554637; Sun, 28 Dec 2025
 17:25:54 -0800 (PST)
MIME-Version: 1.0
References: <20251228124001.3624742-1-rppt@kernel.org> <20251228124001.3624742-6-rppt@kernel.org>
In-Reply-To: <20251228124001.3624742-6-rppt@kernel.org>
From: Guo Ren <guoren@kernel.org>
Date: Mon, 29 Dec 2025 09:25:42 +0800
X-Gmail-Original-Message-ID: <CAJF2gTSMLhnqQeZB=oEwLGzXfJwxPh+vJvTuz-OFGrwJi5uPSA@mail.gmail.com>
X-Gm-Features: AQt7F2ovPXIqQiKDAgz2Iigjc3UdRKj7ty_Tsln8fN_MKzmJJ5LWRy6ejtLdRVA
Message-ID: <CAJF2gTSMLhnqQeZB=oEwLGzXfJwxPh+vJvTuz-OFGrwJi5uPSA@mail.gmail.com>
Subject: Re: [PATCH 05/28] csky: introduce arch_zone_limits_init()
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alex Shi <alexs@kernel.org>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Andreas Larsson <andreas@gaisler.com>, 
	Borislav Petkov <bp@alien8.de>, Brian Cain <bcain@kernel.org>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	"David S. Miller" <davem@davemloft.net>, Dave Hansen <dave.hansen@linux.intel.com>, 
	David Hildenbrand <david@kernel.org>, Dinh Nguyen <dinguyen@kernel.org>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, Heiko Carstens <hca@linux.ibm.com>, Helge Deller <deller@gmx.de>, 
	Huacai Chen <chenhuacai@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Johannes Berg <johannes@sipsolutions.net>, 
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Jonathan Corbet <corbet@lwn.net>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Magnus Lindholm <linmag7@gmail.com>, Matt Turner <mattst88@gmail.com>, 
	Max Filippov <jcmvbkbc@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>, 
	Michal Simek <monstr@monstr.eu>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Richard Weinberger <richard@nod.at>, 
	Russell King <linux@armlinux.org.uk>, Stafford Horne <shorne@gmail.com>, 
	Suren Baghdasaryan <surenb@google.com>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
	Thomas Gleixner <tglx@linutronix.de>, Vasily Gorbik <gor@linux.ibm.com>, Vineet Gupta <vgupta@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>, x86@kernel.org, 
	linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-csky@vger.kernel.org, linux-cxl@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-hexagon@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-m68k@lists.linux-m68k.org, 
	linux-mips@vger.kernel.org, linux-mm@kvack.org, 
	linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-sh@vger.kernel.org, linux-snps-arc@lists.infradead.org, 
	linux-um@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, 
	loongarch@lists.linux.dev, sparclinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E4C74100007
X-Stat-Signature: kq6sxnoho58wb7roid7wwnt86sjsi67k
X-HE-Tag: 1766971557-19575
X-HE-Meta: U2FsdGVkX18GKSptJkosO2sAf0u+ZkrtVaSYsvLW7kK3BPmDKUaTwTWw2aHObdgJ34t66tbuhVOvRk+7oG3x0yX5C78bAkfhSfLmf3O1ixBBlEAT1k/G2KaeP7uCJO6MurkLfvPfrNmB2IvHywXZroIsQJ5XWsW+glJzc5361HwZqiwC3IRx/kyKtYfHxJDbOWqdhOhxTn0RMqMJ0h0pIhfLT3D24ANiWnq5AkRLFB6vFFFI1QABMsJBTGeFmtJmtutvAg1XbTKwvdJuZZVpyJHRL+sWRm8GIpNTw2DAE3NmoDGKf2P5qwRvdEqQHLQvg8nJLEFIXO4jqKNpipPsP+2Z7+bS/DtofYi+WpO5k8LkgpwfUVQSo0uVr6vYhX0vAQzedcDu0Z8fkDMOot8ykbp7H8XaO0pbY0tzXuJbcjpTo2YCJXFkzmgd+HJExVPCtsWy8tWrMkW1zFeKgxiFDqNSeGpqtK2LfI0KbPGEq3lfC51vKGiicjjAfhI4fD66+JKOPM+S2qkGimJAvS4yGBRButwFjTcUL1Us1Rr728zinx2diLpTIpDAFvV0I560Zkdavsb0JU2wapUWB079BL5UtdQ9lZ/yz8mDjC7KyuiXgZNqjd3/CZi7mSp2M56D8BVzh9kkggKTZA/BBuP4YiKRDGCFKbagcUXrDETi4pgvEXUQujiDGJAzPTR8Y1Q9Ses86fALFJsjCPi+ZB4JN7vnCBLj8c8PaH41RrHUlj2MDnBt0pKdlj6daR/yGtMJMRb/0BVvh+J+Njs3Q9bgNtCkECHL4DX4h0qkSxWY5uA7SkfC+qoKL4G/V9zCTFExKuyiIkLRHc+vXf/dqBkucVAwhudQK64/66CP5e17DprHrg6a/e9nRxmzbnzP7l9nXU+ieFVRTTkJl867+UPR9BRVWGcooRWznjsGJz58R1oyCj3Z71mjLc+KbShz3iRHWCzZsQg6KxPo+d/HRiT
 gJct75/c
 URe9yGKAMvgHTYdGP/LSaGXq1vekPyAReiEeD8Mv86V4wfCpG9rJBVHhPSdEn0i1+fZwP05+jKDhbaA0D3XQWDa6jrz3E5C0dIh9syfkQW84a/wjden3WdusjkogT2W4/aQyUU6AD03sbtQRUCQc6ugE97epBMH/83ERvN+4+Cj+L9yN/FOv+T/hh/b4bT1MlGav66V4Tq/srTdDUKZ43D46yon+k5Z+IuEi8/0mQ7Db1Gyab+H63Q+IyUybi+GWtP2A0vDfhOLiiPQ7ychvCOvgYH0QscYyzW7ot+aMQwUQ5kGmzr5AWLBqYHyoTy5K9GoUrfgZ6gZtNt2lxss2E7fwiy8qGz8p5wPuU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Dec 28, 2025 at 8:41=E2=80=AFPM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
> Move calculations of zone limits to a dedicated arch_zone_limits_init()
> function.
>
> Later MM core will use this function as an architecture specific callback
> during nodes and zones initialization and thus there won't be a need to
> call free_area_init() from every architecture.
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  arch/csky/kernel/setup.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/arch/csky/kernel/setup.c b/arch/csky/kernel/setup.c
> index e0d6ca86ea8c..8968815d93e6 100644
> --- a/arch/csky/kernel/setup.c
> +++ b/arch/csky/kernel/setup.c
> @@ -51,6 +51,14 @@ static void __init setup_initrd(void)
>  }
>  #endif
>
> +void __init arch_zone_limits_init(unsigned long *max_zone_pfns)
> +{
> +       max_zone_pfns[ZONE_NORMAL] =3D max_low_pfn;
> +#ifdef CONFIG_HIGHMEM
> +       max_zone_pfns[ZONE_HIGHMEM] =3D max_pfn;
> +#endif
> +}
> +
LGTM!

Acked-by: Guo Ren <guoren@kernel.org>

>  static void __init csky_memblock_init(void)
>  {
>         unsigned long lowmem_size =3D PFN_DOWN(LOWMEM_LIMIT - PHYS_OFFSET=
_OFFSET);
> @@ -83,12 +91,9 @@ static void __init csky_memblock_init(void)
>         setup_initrd();
>  #endif
>
> -       max_zone_pfn[ZONE_NORMAL] =3D max_low_pfn;
> -
>         mmu_init(min_low_pfn, max_low_pfn);
>
>  #ifdef CONFIG_HIGHMEM
> -       max_zone_pfn[ZONE_HIGHMEM] =3D max_pfn;
>
>         highstart_pfn =3D max_low_pfn;
>         highend_pfn   =3D max_pfn;
> @@ -97,6 +102,7 @@ static void __init csky_memblock_init(void)
>
>         dma_contiguous_reserve(0);
>
> +       arch_zone_limits_init(max_zone_pfn);
>         free_area_init(max_zone_pfn);
>  }
>
> --
> 2.51.0
>


--=20
Best Regards
 Guo Ren

