Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD629E63C85
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 04:04:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30DDD6B00B6; Sat, 24 Jan 2026 23:04:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E27B6B00B7; Sat, 24 Jan 2026 23:04:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E51D6B00B8; Sat, 24 Jan 2026 23:04:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0DA156B00B6
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 23:04:06 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C57EB1B021E
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 04:04:05 +0000 (UTC)
X-FDA: 84369143250.07.1AF8A19
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id CF8A84000F
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 04:04:03 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XaocTzgq;
	spf=pass (imf27.hostedemail.com: domain of chenhuacai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769313844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YIji0mr4R4g6O+9f/Cna4+ZOaPUPp69jiL896lrkq/s=;
	b=Nf6ZWIlBaHIBPsRSINNK6wpTckyFvjP4VzLhYeEDH+g7KGw9/5hBIb3D1wpD5Xdi6jl1n9
	MwgLESfmDoC28ZOXUeX/UW53LLFrQV9pBopeJR2ldYaf03lLBDBHx0nY00Y4cTzOFX9sMk
	L9Qk21srZGTpKMQfW6Hl/Vzt+R/pJXU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XaocTzgq;
	spf=pass (imf27.hostedemail.com: domain of chenhuacai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769313844; a=rsa-sha256;
	cv=none;
	b=p0WHALkx6Cx82CgMTbigIYmjtqsVOz/se214EcHqkRbrl5vA6uE9vWy7Pus2GU/obBtKpa
	1urVJkuLecCnDfB/IPpdY6oRlfOR+0uClLyTiKiTlShoc4Hv0WHemd9DfjWoHvavR2pZkE
	yUUbyzGLUCbow2U1v1K339KM2PJyok8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 01E834444C
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 04:04:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5DBEC2BCB0
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 04:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769313842;
	bh=1QP1PVbgfgapGdfxYG9jR9OdjDGN0laLbzVlm9bi+/I=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=XaocTzgqc0Es3j4/8T8G4uoAUd1mHKH8AtIbtaR4alhCqdNxI2igRM7p74pjxp9Zw
	 EbUuK8JheqrMq2x4ij0eRY/zLBKSaT1YhUqAYJc2/BgeVhsg1DjDUzseAe7n4vnIth
	 z/2zsYwWVwmv+J469OSN6ycJFOAxYUGOduEKh/tNSBz5fl9nDuUmlOQjaSVCpQFlvC
	 I84Ws91PfAh9Xd0qhFxUCaI6Xmh1He4hA0nVseGgoY0TqFkc520zg+x6bi1Ndr0L0g
	 MJOhp0QhEXmv9pfq2vAiH2j9uZP9ZfVCiV/qw8Giep843cZzl/3qK/yeHG1FdKT4j7
	 E6Kf0m/KYw9lQ==
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b8869cd7bb1so300063366b.1
        for <linux-mm@kvack.org>; Sat, 24 Jan 2026 20:04:02 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWOTtboKdjJaHi5Xx/n5ge95Q0IzT6AnMU6wmQC+t2eUOPWqLBcRXB8/+jo87cCcCni1TfrVA4+SQ==@kvack.org
X-Gm-Message-State: AOJu0Yy2UACpdyOuaUCeMv6On1xYCv1p+osmfeEXAfhTGeH4fedkyc9d
	JkKOouGI+w6R7vEDopTNj8hD1ABgua9OzS70SvWxEWW8tKncZ96Nw04KqqK6CTk+QrliwotjFF8
	o30Ug6F7nc2nDHubo0UDEDCi25ykf5t4=
X-Received: by 2002:a17:906:f58c:b0:b88:60d2:11a2 with SMTP id
 a640c23a62f3a-b8d3fbba376mr29407566b.34.1769313841185; Sat, 24 Jan 2026
 20:04:01 -0800 (PST)
MIME-Version: 1.0
References: <20260109051054.188030-1-fearyncess@aosc.io>
In-Reply-To: <20260109051054.188030-1-fearyncess@aosc.io>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sun, 25 Jan 2026 12:03:57 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7Yk5OWWeH7p=h3JdtJHr6GFoq6wAfCHUbj_R0eoLre=Q@mail.gmail.com>
X-Gm-Features: AZwV_QjI7_MypoP-cFKhVGgow4YwRF06xAdcJWacmzKDSMsegChV4xgnK6Efe80
Message-ID: <CAAhV-H7Yk5OWWeH7p=h3JdtJHr6GFoq6wAfCHUbj_R0eoLre=Q@mail.gmail.com>
Subject: Re: [PATCH] loongarch: wire up memfd_secret system call
To: Lain Fearyncess Yang <fearyncess@aosc.io>
Cc: WANG Xuerui <kernel@xen0n.name>, Kexy Biscuit <kexybiscuit@aosc.io>, 
	Mingcong Bai <jeffbai@aosc.io>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Shuah Khan <shuah@kernel.org>, Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, Arnd Bergmann <arnd@arndb.de>, 
	Jiaxun Yang <jiaxun.yang@flygoat.com>, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: qsokdrrpr54q39bfhq4ga6rtnoqfbnwi
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CF8A84000F
X-HE-Tag: 1769313843-130609
X-HE-Meta: U2FsdGVkX188vpvofIbZ/ErRul312Kp7O/8Had5naZnnk07Sfw8s3WrxSyFIB+HnH/++dwx7PAlBmHUyNHB9NhUEcKLVMWoFUinreW/UoKtC4lBeHJHCf/G+VCeSwCfV6iRSeh4vRYcu8sS/QF7ivVLIxgPBO9uCBVVG9o0pxcep2DDNMuswoubFCFoNB8CfuTuujH61OIMyrw3pYJ7gE+6TKKUfidVmSLyG8MW545njkzyBx5VLDNP+5XTp2AzP2Acsw5L3cKOXOWNDpw15GDH9MQ0/p8kG2R0ImPD+fbSQavS7+9TqmKy43KW4bCFS/2GXpLF9Z6I3Ef15ALu9YGzUj+1yXEUxrXJx42rSOi62EuMXjZ7NhVm8MfOLEVVA9AFApQelFlK5L8i3Y06Uvf8XdrMkZiQq4h1XIMkbUJggLmjwxRP9R+kHygDXs2nhrzvhkPm6TB223xga6JycjyuSjDKScYVa4T44HGJszQSaKjWABcA+Nd/1n3QXLHMonD3362XrdmtnsvDAd02SkgUvsqPBSIFBB1UW9I4laVb+LWIcm01qCrV6+QFUeMC+VFO4MgEzwW0iH4ACI/+iZVLUPJr7JCjXlDHrUwpNQU8j72ksAP6IAAT63uUeBFlnxi++LnXlqMSwCmyiWRboyxOv2+Gr1j3079vkInoyRhO1udbrIQ5hO6Q5emEfVH0KZawyxbZQe4bNz/N7Dvmn9iV7Wn3PUYce8K1dSUOlXRWnJhKfSOwt4MwvJnqoOqGUk9eFqpvByR9rVn+U4VcEfs2kTvxsuiW5dq5qK3kXcYsb4nrV39MjNB7am3TzaXyKfUpoASD/NK6dCvwgvs4rNajV1havrLr5TqBO963PjDcoet449uqRrfxZBO+fjQByWQXtCZAH8zz8FjvhSCi5XtN6JgAgbf9bbLZmGXJCUVIwSxGc6nXxr/UTSmpRnxZvAbc1pQZ7YQ/9VSH7EW4
 3kDKjjoo
 7XsOfawAkZ0YRATToPCOwI4onnS6csnwbJPo2P3xEPOEcrtsIEs6LMIbUbIct4AeO8vNZsc5vaMXkqTuuvUbu8yhfMEoBIVCOdPnCGmqap0G26+gnd0uqEbH5KCQxd+/9fVb5V2/k72O/8l9OBco3pwT10/EdFdn8u9spJRuZETDiGNnBcf8ygumTHDubYmfoch1UHgXZQ392sqerHLUt7siOQPgyksMsMMHiCAYlqDhApvGVsXlH3TzCRH0OX/mIu+1O969uv0xX950+1fDK7aP46ezFgoHzlou22CC9C9tpvItHZESzdXOECGL81NWPMmBd4471ggzxYz4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Applied, thanks.

Huacai

On Fri, Jan 9, 2026 at 1:11=E2=80=AFPM Lain Fearyncess Yang <fearyncess@aos=
c.io> wrote:
>
> From: "Lain \"Fearyncess\" Yang" <fearyncess@aosc.io>
>
> LoongArch supports ARCH_HAS_SET_DIRECT_MAP, therefore wire up the
> memfd_secret system call, which depends on it.
>
> Signed-off-by: Lain "Fearyncess" Yang <fearyncess@aosc.io>
> ---
>  arch/loongarch/include/asm/unistd.h     | 1 +
>  arch/loongarch/kernel/Makefile.syscalls | 6 +++---
>  tools/testing/selftests/mm/Makefile     | 2 +-
>  3 files changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/arch/loongarch/include/asm/unistd.h b/arch/loongarch/include=
/asm/unistd.h
> index e2c0f3d86c7bd..e7649c1582482 100644
> --- a/arch/loongarch/include/asm/unistd.h
> +++ b/arch/loongarch/include/asm/unistd.h
> @@ -10,5 +10,6 @@
>
>  #define __ARCH_WANT_NEW_STAT
>  #define __ARCH_WANT_SYS_CLONE
> +#define __ARCH_WANT_MEMFD_SECRET
>
>  #define NR_syscalls (__NR_syscalls)
> diff --git a/arch/loongarch/kernel/Makefile.syscalls b/arch/loongarch/ker=
nel/Makefile.syscalls
> index cd46c2b69c7fd..6360381baf931 100644
> --- a/arch/loongarch/kernel/Makefile.syscalls
> +++ b/arch/loongarch/kernel/Makefile.syscalls
> @@ -1,5 +1,5 @@
>  # SPDX-License-Identifier: GPL-2.0
>
> -# No special ABIs on loongarch so far
> -syscall_abis_32 +=3D
> -syscall_abis_64 +=3D
> +# Add memfd_secret explictly for la64 and la32
> +syscall_abis_32 +=3D memfd_secret
> +syscall_abis_64 +=3D memfd_secret
> diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftest=
s/mm/Makefile
> index eaf9312097f7b..79582438efc4d 100644
> --- a/tools/testing/selftests/mm/Makefile
> +++ b/tools/testing/selftests/mm/Makefile
> @@ -72,7 +72,7 @@ TEST_GEN_FILES +=3D madv_populate
>  TEST_GEN_FILES +=3D map_fixed_noreplace
>  TEST_GEN_FILES +=3D map_hugetlb
>  TEST_GEN_FILES +=3D map_populate
> -ifneq (,$(filter $(ARCH),arm64 riscv riscv64 x86 x86_64))
> +ifneq (,$(filter $(ARCH),arm64 riscv riscv64 x86 x86_64 loongarch32 loon=
garch64))
>  TEST_GEN_FILES +=3D memfd_secret
>  endif
>  TEST_GEN_FILES +=3D migration
> --
> 2.52.0
>

