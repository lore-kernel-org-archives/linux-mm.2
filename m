Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F97C606A320
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 12:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F19LKSe7
Received: by kanga.kvack.org (Postfix)
	id 71DAA6B0622; Thu, 19 Nov 2026 07:05:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CE956B0634; Thu, 19 Nov 2026 07:05:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60B236B0635; Thu, 19 Nov 2026 07:05:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 334546B0622
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:05:24 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A56EFC0A6C
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 12:05:23 +0000 (UTC)
X-FDA: 85451738526.12.9A7197E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id B4CDD4000A
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 12:05:21 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F19LKSe7;
	spf=pass (imf17.hostedemail.com: domain of chenhuacai@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795089921;
	b=qXfJQ/LQ4/V10Q15ruieKncZ9Due6w2676f+ro6W5rlDGdIXNNpwBBK+VV71jCiJkpVJkb
	StUjwe35hqvDveSzZahnT/ULABUCYvgYvNdQxIeb9gI9Ok5tJBduz6vttJ2fKZhaf4JH9p
	s+ylCmuJSuceZFq7WacyLV6WYYMUFJ0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795089921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FBxJcPXeAm8QKAUiFswz58ZNqPTA/e/PJf+hWh7nZOk=;
	b=g/wWsxvpsY/YHV6jFIt5g+xyeU1EMMmqlMMJoivwHUCDQeIytYPHL75z6B1of8GbOU/z6K
	3FHs+ql6fGlSfRxAlv/oNU88mq0ImOu37OO/pvBHLF1eieUCoLU9XSPwc4v5IMPoj1k6Z8
	7qiaDAVE4jLgUyLy36JciilcRf8s/pM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F19LKSe7;
	spf=pass (imf17.hostedemail.com: domain of chenhuacai@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DCE59624F5
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 12:05:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97A7D1F000C5
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 12:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795089920;
	bh=FBxJcPXeAm8QKAUiFswz58ZNqPTA/e/PJf+hWh7nZOk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=F19LKSe7uDen+UvWYVGeYYdk9oWw0ri9Y5JIS3d16mhgInPtDp0AyEAPEY0AK/AJA
	 AWBSc0NV1eTlvSs2pabj0ptMpNlbCbQFGTo+bzKE+2Z/wTM09vqSwxUF624zvojg86
	 EE+98soll+0f2PeedrC8zb0l867y9yYGNOgRjexyc+1YqR32fk0DDkLFsqwv8tRKr6
	 KEE8YMnYIdneUSySln43y+p+2irxKQ/JgWo8FKZhtuQyzKHVa6TrxEQX/hckIl/btV
	 A3bUjmy9zwA8+VgRGdOwjPQnu/hlCuA8gGwOLVmEM+K9r6r2AVkKrjpGacHWgi/wpn
	 tChIou+xt4Fbw==
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6b88d143160so2687120a12.1
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 04:05:20 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErHky7VRNIj2MaVfy4OkbbO67p3zC0wHuyiUrYvfrLdI9l58DtdG93Yo7c0izAKC8eR2FR/iodYG1g==@kvack.org
X-Gm-Message-State: APuU4Z+GSj/bJ0xBemsSxG2HC95I4lfyGgfL4t3d5wtEH1QuGu0kMBDF
	er23HWvyvtFwTxGPRsUFu/LrPaSjNARTrsM2y28pG315dynAC3hrNEcx3U+SAyRqadfP43PPVme
	mZ2wS3j6OEIWDR2HGrP56zLksivhvIlY=
X-Received: by 2002:a05:6402:1ed4:b0:6b5:5530:c9af with SMTP id
 4fb4d7f45d1cf-6b887e83a81mr4871588a12.15.1795089919238; Thu, 19 Nov 2026
 04:05:19 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261119100216.10182-1-dongtai.guo@linux.dev>
In-Reply-To: <20261119100216.10182-1-dongtai.guo@linux.dev>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Thu, 19 Nov 2026 20:05:08 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4pmcV8hah8sPyQn3nR9cO-NwkXMPLeSABAO-VEnS08fg@mail.gmail.com>
X-Gm-Features: AclHuK_cEZcZkwIHDpc5O50alIIDUZZaaZh_szL239OmmvVzzDhSkIejCjgHXmg
Message-ID: <CAAhV-H4pmcV8hah8sPyQn3nR9cO-NwkXMPLeSABAO-VEnS08fg@mail.gmail.com>
Subject: Re: [PATCH] LoongArch: Allow memblock arrays to resize
To: George Guo <dongtai.guo@linux.dev>
Cc: kernel@xen0n.name, rppt@kernel.org, liukexin@kylinos.cn, 
	guodongtai@kylinos.cn, loongarch@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B4CDD4000A
X-Rspam-User:
X-Stat-Signature: eg66ytsjc5mu7of6jbk9qdj5dyrjrxso
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795089921-501939
X-HE-Meta: U2FsdGVkX19B9XifqP954ORN0z31t5UDhaTNjgRxKNZRbrT5Q0734ANdv0yP+EDHIpA31JUZ97W1FPXCtunFMg/2G+4tKAc9nuNdEOWMPq6lNR0vTMDqAu41naNhqg3PLY1lGUwBdCq/8F75JO+WZ00XvUKSG/epxGeMBruHA5Rdnzz/6gX3+A2nWkh3f3WBfeS7qEl0XRL1hMPAKqnxYMH+1QLecwhwHntgIfyD4ArYD6v24cE+fbYAH2JPvu7M5LjQfFF5NHwZcEOw68nzaQuHrfhMFvyPSsBqyqqaEFAHr3VH9upKjkxCWfyipnfHCVQ8pT/2YDlR65bmMUdx1pxQBlxPTCC43le/6WyP99qzTXfbnyhp0fZeZ0dyJ7VDCEWsfbNdcUQ0bnc1FCfttlf3Ql/WD9qNWjMPMOake9qmOBhjkGIGv1Aub1mvIXJWccGDE7OyVJQWVlJ9P2JQGYjqY8Os01AtydY5taPD4dpkhM+QuhYcH6bTxDRB56ZdZZk0uNJUNqxNb7ZfLt9iMc2xEL9rwSPZNiakTyUNsmJNIDjGHULa/qGBObKNyORYnQ53AV3J67zMEB53Gq8FWXoJ2ozuzMdFNi2qgSDdIGsqNtabl1GhN9BX62McNvVApcuJ/IQNUg3RGdWWJapXGugE8HLWyZoC+sqbnPqGUAyjyiRba0uvMXJcyx5VQJZ7y5xs5ptVaCQWiwzbstNZ/+1GK7O4Z/OR5lpgnvrjb/dBFlpl24aYPa9UcUBsdgouHdOOkhdMw1uYauS6zxMX7fnzrbX5IklzUUSOUGSmXodQCR3phgvGT2MyTa3rjy4rRc+Xc5GTtTeCj/vN6b0HlakpWdsrtwGRfFOSTk0oiobd7A5gXLHRfVG9xl08iAb9I5CaY3yMcvXHtzGc/MoffnxzntsKA8Y4yA9WAz0AgHky3djCkDJPptkMqEa2Du9ijPe1fBpymza/CaAyEp6
 NO9Qy7Lm
 90SH1CNQCWYWuS/9l5lcZhDUuYhuorV2BprqXeXvSTRuQKqq6W3BOgHg73xNI11xzaDs90CoWGmLvZ/EC1xfZwWllndIEC6e4H+gQjct7O6D3HuIiVyvXwseq9fDHIQOS42YO/Q1HS5QgV2JUkiHiflshB7SXf8zLzNGRanxMEQH177hqFTU9V+jvEgV06FCG7+kRnTur+aCGJAxrqvpqVrr27stv8AxOFMDSa9x9zHvm7NPhZGYmJJHpDRO/o6F+uMNpWDgaRyrs8eHlucqD31O6IuYqU55smy+ukD5hsvuqJhS7BTUXPjum/GRZhRlxZg1UqkLIVhFKn3eXMiBA499tWoaTfcomMe/M41tHoZcjt0A1HQ3GiJGMnjY7tKueuJU16/aijgwg77JcOcvyq62wA9v0xEw+YoTcjkh5OkdEr5+gyXsnwwEQ6eXVjMQOgffs54woAi2KLqL+gWLF2UtcdqdHqRCsybT6+6V3937q0g4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi, George,

On Thu, Nov 19, 2026 at 6:02=E2=80=AFPM George Guo <dongtai.guo@linux.dev> =
wrote:
>
> From: George Guo <guodongtai@kylinos.cn>
>
> LoongArch never calls memblock_allow_resize(), so the memblock region
> arrays cannot grow beyond their static sizes. For the reserved array
> that is INIT_MEMBLOCK_RESERVED_REGIONS (INIT_MEMBLOCK_REGIONS +
> NR_CPUS) entries. Once it is full, the next reservation that needs a
> new region panics:
>
>   Kernel panic - not syncing: memblock: cannot resize reserved array
>
> The memory setup code was derived from MIPS, which never enables
> resizing either. Nothing on LoongArch needs the arrays to stay static.
>
> When an array is full, memblock allocates a bigger one from free
> memory, so resizing is only safe once all memory in use is reserved.
> By the time setup_arch() calls arch_mem_init(), the kernel image, the
> initrd, the firmware memory map, the device tree reserved-memory
> regions and the crash kernel are reserved, so enable resizing there.
>
> Co-developed-by: Kexin Liu <liukexin@kylinos.cn>
> Signed-off-by: Kexin Liu <liukexin@kylinos.cn>
> Signed-off-by: George Guo <guodongtai@kylinos.cn>
> ---
> This was patch 5/8 of the LoongArch KHO series v6 [1]. Mike suggested
> fixing it independently of KHO, and Huacai preferred arch_mem_init()
> to platform_init() [1].
>
> KHO for LoongArch needs this: after kexec, kho_memory_init() reserves
> every preserved range, and luo_stress_files with 500 files overflows
> the reserved array without CONFIG_SMP. A bigger array cannot land on
> preserved memory, because KHO limits memblock allocations to its
> bootmem areas by then.
>
> Changes since v6 5/8:
> - Sent on its own, without the KHO series.
> - Reworded the commit message and the comment so they do not depend
>   on KHO.
>
> [1] https://lore.kernel.org/all/20261029172956.20791-6-dongtai.guo@linux.=
dev/
>
>  arch/loongarch/kernel/setup.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/arch/loongarch/kernel/setup.c b/arch/loongarch/kernel/setup.=
c
> index 6fa4a22a58fd..8c33346a123a 100644
> --- a/arch/loongarch/kernel/setup.c
> +++ b/arch/loongarch/kernel/setup.c
> @@ -402,6 +402,9 @@ static void __init arch_mem_init(char **cmdline_p)
>
>         check_kernel_sections_mem();
>
> +       /* All memory in use is reserved now, so memblock can grow its ar=
rays. */
> +       memblock_allow_resize();
Would you mind if I move it between memblock_dump_all() and
memblock_set_bottom_up(false)?

Huacai

> +
>         memblock_set_bottom_up(true);
>
>         swiotlb_init(true, SWIOTLB_VERBOSE);
>
> base-commit: 422e532809572ba1043192bf6a0c653bc68b3140
> --
> 2.53.0
>

