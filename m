Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E254C79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 21:07:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2382B6B0093; Mon,  7 Sep 2026 17:07:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E8896B0099; Mon,  7 Sep 2026 17:07:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08A216B009B; Mon,  7 Sep 2026 17:07:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D1B5E6B0093
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:07:53 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 583D54030B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 21:07:53 +0000 (UTC)
X-FDA: 85188203226.12.FCB7F60
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6B6BEA0007
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 21:07:51 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ocLeIaRa;
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788815271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j33dWXa87ubHe2rcHlgmZCfdvDttwcXovkMGxt/Pcfc=;
	b=AQAY7tztjOfZfpOmhOyTde38YU+XBG7O5oKfHWNjmbtX53yiIEoWgj3QufDhiQfYs7LGbs
	JjvNqUJ/Zc1qVxarPUkHvJ1VQq9EGDM8N+4ENbann4auhNrZjESUygLfGRiJZfZ1h5H5Xm
	cmTQ64n9dTBzmUj08hBxTELKP7PGwwY=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788815271;
	b=lCyqRC3bkIQ4eDpytJZPBeYYa0v7vY/dicJfyEsn04F+gcgUIoVPk90HzO+uTX9KBaEgZP
	0lp3aKtJszuVOhSD5SuFv/RWPDc4ENyTrpppNG8+hkbCNHMjXkB/sXmbY7FU37asDwme+7
	U1DoSY3U981aRZ4P3C3lj2VwswrWt1I=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ocLeIaRa;
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-5306706e89dso455941cf.1
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 14:07:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788815270; cv=none;
        d=google.com; s=arc-20260327;
        b=ZoYx4o0w3Va5h++jv+HzWfftmkPr9/BeQyPQ/pbPT8xRq8WgMIvmMkq8CDaxERR8ek
         3VYcr7BZfU7cVkt/j2pmQ3qnuOra/bfdLT5FfzoIT1q7zQYbLsRqpvoiY04bQ0jmD7yp
         eQJNHrx4QIgt9SO6zbD5mDjLCqpRa9vy+nmAPqE3A8Aj7RgktMOQGexRCs7EINq0+ARF
         MXPdUmBsKwV8kpeanKD7nGAIXstYYsjv5u2vuQdAJGe1j6zeQzguXhwp1TH8wYpWRHvv
         uEcckD4IBiHzmmsA2MoKLtB5XtQ9i0CRMWGhedmAPgR5vz+3A539pPq7E5sB4ym3Myz0
         QfQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=j33dWXa87ubHe2rcHlgmZCfdvDttwcXovkMGxt/Pcfc=;
        fh=coJgWrVHvSdeKM+qRqpC9fl0tV/Nptsz4tGhOptfbM8=;
        b=IBp/S6S8+dofLl/Q11Xn8abPbU9MgyAi2DVlZVgZA2r5Za9E9VKf7WWHHI5BoVEWBg
         bJ3O+FNHyqmVtLVtsRboRm9BnNaw3j72UlexZlrN/XndS2vZgpu7H0qPjcHyGpw3Fa4R
         T58dJ14Pgy8+wgw+f0RyREWEAZ6XFQogxgSqXF8BB4KHCc6aNiHYVQ32Dq+BCZSb90bt
         YnaC4WBHGQcBYdE+q/zDuYBCsSzrnbeMtIby4L9M7mEMWaoxX/x4Y7m18Y6g+Ok9k5VU
         UrLizPZBxvGNWnJVa+AeRrUIIMXeOavLlnqhOydnwl3eiYDa2TuCNXKbKR3FPAPPsCMf
         Q+qQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788815270; x=1789420070; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=j33dWXa87ubHe2rcHlgmZCfdvDttwcXovkMGxt/Pcfc=;
        b=ocLeIaRaBLUn/1xNl2FCkzUyoOU5cKekqWDu4y50u//1xE3P3IEv230mQ1f9xyPCJQ
         SouxW86/iLq5FFlsGADc5eje1A7Jc27xnP6KzDPkSQWvGz/BfDOt8Hsy+uiNTGjv0nhX
         nVcRUEC04c4qysh9Omh+uVbWeyKik344Fmi2LzYha/aVaYSGyHWtXVlKjmG/aJ9tr7Sg
         8LUqhIFXrfbE70cXiQdltpaR/IwKmsNW+x0w3JzrjPQlJL2WqUlgQFjVOVI82cXh2kDn
         10p+irpkyphIxLJbHX9GkG7HlkSMh7vmKG3OB0kcQ7j9Ld5YZ51IWbxWj7h6xBduWuxa
         SwCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788815270; x=1789420070;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=j33dWXa87ubHe2rcHlgmZCfdvDttwcXovkMGxt/Pcfc=;
        b=WQuDvjfOWbFjI54o+JRP8mqCr0U8WOxhl9NZmmTB3/VH7IgbWcJ0E9my8Pe75L38Cr
         U3c7Wtkxi7VkFtEofSpuRIxi/MBE/y8ITtW26KXjk4IXiV2V4eAz82nEGKCzCJj0vbvl
         SxE9ZY6AJ+tVBWfKpM/ai2ma/ZvIFZM+MVxWfVt5ZV33SUWdQom9mhi4falW8ecz21+A
         gxAifBmXZcAU9Jo4nnsehGvThzvrnNV9ecw+FDQtOBoecbZrkuBVdgRZE4+EdQ2dNwwN
         WnV2ZJNE6LNNYqDNooNEYL7lHF3+QeS45x1MSidPQF2gPu7Yr2Y2e+2BxzdiddLHLKaG
         2Clg==
X-Forwarded-Encrypted: i=1; AKwUvBy6/WUbKNS9wVPUSzO5VD6jHHzqFGYgxK9CGyBQ6ZaMfJVmGx4BpNVdfF0OlNebKGHLHmpZVKxMXw==@kvack.org
X-Gm-Message-State: AFuF++mz+WRcBAic8cirf+VudfYLa7tltLA0A0xYnBP94RVbl6FhXvCh
	lwFzUF+WlwZbz+em0jAOguU+/Lao6EbCkAoCV2ikSdwzPwqb1fE9vTmDPh87S1MS4U5JRi2Ujvd
	IGi/7MUaG8KRx4zT5+C/Z03jzM35CFr/3GSRo417z
X-Gm-Gg: AYBFou1hmTQqT3AAC+gALM5Qt6tNCRijnQ7vzMoS0EGvSKP9VFxW4JU3VGd7OLgqXKN
	s67Xnl7dw/Efp/+q1yMPfSqm0F/pFJLGiC2o3NT2ZOw5XKwyomoBUjSRvB1NkmyP7AGPv/mEx01
	eT4erIyY49vABFBd3U64wmmzS3CPfeBtVb98KlLYa3s2cvYbQQFnJ4/5cIXBJplDOeF8tatF+GL
	Qy/18+goGb4Uz/Dbj6EnD9z1+YjdPClpiYjQ8axbdRtP/OrswvKq9Wg1vH0x2Afr+Wd7xjig08E
	Z2rUxwGmN7sWYWbjRsgk47a+0eM25JxoeT9Xqa87e6U=
X-Received: by 2002:a05:622a:2589:b0:517:64f6:3365 with SMTP id
 d75a77b69052e-53065d7943emr35669061cf.4.1788815269129; Mon, 07 Sep 2026
 14:07:49 -0700 (PDT)
MIME-Version: 1.0
References: <20260901-rcu-pagetable-freeing-v1-0-5456a81c8212@kernel.org> <20260901-rcu-pagetable-freeing-v1-5-5456a81c8212@kernel.org>
In-Reply-To: <20260901-rcu-pagetable-freeing-v1-5-5456a81c8212@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 7 Sep 2026 14:07:37 -0700
X-Gm-Features: AcwNN1U8TkUrFVP6EqWbmqC7u-eOkQZui9u0urXe4uY9QHhCrt9ILjWVeJ-SJWo
Message-ID: <CAJuCfpESe_BXihJh-8FhjQVKzsSpnS4zdMgg3e59byJTc8QViA@mail.gmail.com>
Subject: Re: [PATCH 05/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for arc,
 microblaze, xtensa
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, Guo Ren <guoren@kernel.org>, 
	Brian Cain <bcain@kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	Dinh Nguyen <dinguyen@kernel.org>, Simon Schuster <schuster.simon@siemens-energy.com>, 
	Jonas Bonn <jonas@southpole.se>, 
	Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>, Stafford Horne <shorne@gmail.com>, 
	Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>, 
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Russell King <linux@armlinux.org.uk>, Vineet Gupta <vgupta@kernel.org>, 
	Michal Simek <monstr@monstr.eu>, Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>, 
	Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
	Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
	"David S. Miller" <davem@davemloft.net>, Andreas Larsson <andreas@gaisler.com>, 
	Richard Henderson <richard.henderson@linaro.org>, Matt Turner <mattst88@gmail.com>, 
	Magnus Lindholm <linmag7@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Huacai Chen <chenhuacai@kernel.org>, 
	WANG Xuerui <kernel@xen0n.name>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Helge Deller <deller@gmx.de>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, 
	Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
	Johannes Berg <johannes@sipsolutions.net>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-csky@vger.kernel.org, 
	linux-hexagon@vger.kernel.org, linux-m68k@lists.linux-m68k.org, 
	linux-openrisc@vger.kernel.org, linux-sh@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-snps-arc@lists.infradead.org, linux-arch@vger.kernel.org, 
	sparclinux@vger.kernel.org, linux-alpha@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-s390@vger.kernel.org, linux-um@lists.infradead.org, 
	Hugh Dickins <hughd@google.com>, Qi Zheng <qi.zheng@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 3q168qpea956kuizify641fp1f9os6s3
X-Rspamd-Queue-Id: 6B6BEA0007
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788815271-853539
X-HE-Meta: U2FsdGVkX1/cLogfhQ/SPeQnTlBDfvdCnr3QDMy+vOZ6xsaDt2vc0wStW0XcEe2G2l+L33ftcZJuNMqS8d1no/Pga+tOMBKlme1of7X3QbzqhEg57xkAz581Sxy/kIpoJ1eIdwuntNrCL9XuF3KvDiu/viXMgweSZXfuGaEF28Uretyq3Pwt5WbTybm/qw9qyHIATooTDDAH6ldQ1kS9+qhQRNO4OEfoo9djWSal/VqREXVEwRgEkjwhQ6JkzmfmpZB50z2gscqgGE2y3EIO4AD0slaXARDvA6K7XhLYB1nFtizBQN5M5HDKfnl65IbyOaMBI98VN5Gv0i8lFla0z2hm0ruAJYEyJQAgN1u7z0BzlBhFj1f/OeEvqdaPqz094Jwi+ISxTJdkibkz1gP9zrjR1buwwDRrMO0oOTifc2XwXle915KhxFWyg024tCPbwLsHzQp0AZAGpZkKzOAiGwCaNeD8I5NHjpvVABdVreBIt3KdsWIl2i230VfDf9UECp5r6ULgdMJOmiy496lZa/lZtc6jOBx5NfPxRO5vtdcNpWI20wlpOYsMCicHqc2b1GYddnHcTgD9CBc61iAH7JCCC1qlXDFkWwq/NVBrYVCqo6vz0xUmxZ33cFionxhyX/qBqFJfPByErkdHhf7PbsNnVK+sVPR/k+IWBk3LsKMlg6YqT85VGLGOS/af2g5crFU/sSu1DXgFDCUC5n9vMvGqEw/z+aiks8FD/6cKBVuGevCwoNO+TkJKY/eYH54oLjH6hDpxcOPIP/Qdj2wTm5aaRbRY1asQeKNqYzFiLamG7CqsQ2seRdNnkhV0lyn7vyZn0t9Q3iSiTq71Mos08OnWSY67wqnEtUaxrCPFhma0A6oPMo/U8jw0O/1RZ69fC8u3wE+Cz+9ES+bhUYFkWuKtwVyXOcn0rXo8tOAlSsrPXX0A6tYxiHyGWTM0xbecx+YWWLGW4MAEaywYX2X
 1VuVsbFj
 D2J3uhOgl7A6RDJWhfNPHbVbvSUEa1IIH7HehXyjZnhedSfM8g8d11hJJuK8XN4s9x/OBB4uMUgB4wKWQVp3ZsOxkcxjqjZsTWR97KSOCPoSzk+iiKiRnd7659T0larIcI03aPNh6Qhi5eIHRHnd+Hu/pxexhWZuqWdJro/bXDPEAoGFZURgXXpZjgkxZeUrEKYuXMSoZBr6uNpUkYih20KNEiRIArCHNf9MXhudUnqSfXG9fzHzeogiy4Ngm93/QZS8yPKehGD2cq6H21W89bYifCeg+ZSb/PEyQD8k1ASjAlcyJvYcXW9qYtMAywySsSE4JYzadEVX3Va4HnDj+bu8rc3TGFreqB1IBG5IIDKLrSh0HUlchggTUxMi85/VeeMUD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 1, 2026 at 4:06=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
>
> Each of these architectures directly free page tables without routing the=
se
> changes through tlb_remove_ptdesc().
>
> The use of tlb_remove_ptdesc() is required for
> CONFIG_MMU_GATHER_RCU_TABLE_FREE to correctly free page tables under RCU,
> so simply update these architectures to use these functions.
>
> Since none of the architectures share page tables or do anything unusual,
> nothing complicated is required here.
>
> Therefore this is simply a mechanical change - convert __pud_free_tlb(),
> __pmd_free_tlb() and __pte_free_tlb() to use tlb_remove_ptdesc() as
> required.
>
> At the point this is in place, all mmu_gather page table freeing is
> performed under RCU, and thus MMU_GATHER_RCU_TABLE_FREE is selected for
> each architecture.
>
> This forms part of an overall effort to switch every architecture to this
> mode.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  arch/arc/Kconfig                      | 1 +
>  arch/arc/include/asm/pgalloc.h        | 6 +++---
>  arch/microblaze/Kconfig               | 1 +
>  arch/microblaze/include/asm/pgalloc.h | 2 +-
>  arch/xtensa/Kconfig                   | 1 +
>  arch/xtensa/include/asm/tlb.h         | 2 +-
>  6 files changed, 8 insertions(+), 5 deletions(-)
>
> diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
> index 2ed7186c81c5..7a7542b61823 100644
> --- a/arch/arc/Kconfig
> +++ b/arch/arc/Kconfig
> @@ -47,6 +47,7 @@ config ARC
>         select HAVE_SYSCALL_TRACEPOINTS
>         select IRQ_DOMAIN
>         select LOCK_MM_AND_FIND_VMA
> +       select MMU_GATHER_RCU_TABLE_FREE
>         select MODULES_USE_ELF_RELA
>         select OF
>         select OF_EARLY_FLATTREE
> diff --git a/arch/arc/include/asm/pgalloc.h b/arch/arc/include/asm/pgallo=
c.h
> index dfae070fe8d5..9b6c37f92e97 100644
> --- a/arch/arc/include/asm/pgalloc.h
> +++ b/arch/arc/include/asm/pgalloc.h
> @@ -72,7 +72,7 @@ static inline void p4d_populate(struct mm_struct *mm, p=
4d_t *p4dp, pud_t *pudp)
>         set_p4d(p4dp, __p4d((unsigned long)pudp));
>  }
>
> -#define __pud_free_tlb(tlb, pmd, addr)  pud_free((tlb)->mm, pmd)
> +#define __pud_free_tlb(tlb, pmd, addr)  tlb_remove_ptdesc((tlb), virt_to=
_ptdesc(pmd))
>
>  #endif
>
> @@ -83,10 +83,10 @@ static inline void pud_populate(struct mm_struct *mm,=
 pud_t *pudp, pmd_t *pmdp)
>         set_pud(pudp, __pud((unsigned long)pmdp));
>  }
>
> -#define __pmd_free_tlb(tlb, pmd, addr)  pmd_free((tlb)->mm, pmd)
> +#define __pmd_free_tlb(tlb, pmd, addr)  tlb_remove_ptdesc((tlb), virt_to=
_ptdesc(pmd))
>
>  #endif
>
> -#define __pte_free_tlb(tlb, pte, addr)  pte_free((tlb)->mm, pte)
> +#define __pte_free_tlb(tlb, pte, addr)  tlb_remove_ptdesc((tlb), page_pt=
desc(pte))
>
>  #endif /* _ASM_ARC_PGALLOC_H */
> diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
> index 484ebb3baedf..af7e821e96c1 100644
> --- a/arch/microblaze/Kconfig
> +++ b/arch/microblaze/Kconfig
> @@ -41,6 +41,7 @@ config MICROBLAZE
>         select PCI_SYSCALL if PCI
>         select CPU_NO_EFFICIENT_FFS
>         select MMU_GATHER_NO_RANGE
> +       select MMU_GATHER_RCU_TABLE_FREE
>         select SPARSE_IRQ
>         select ZONE_DMA
>         select TRACE_IRQFLAGS_SUPPORT
> diff --git a/arch/microblaze/include/asm/pgalloc.h b/arch/microblaze/incl=
ude/asm/pgalloc.h
> index 084a8a0dc239..ffee6a009219 100644
> --- a/arch/microblaze/include/asm/pgalloc.h
> +++ b/arch/microblaze/include/asm/pgalloc.h
> @@ -25,7 +25,7 @@ extern void __bad_pte(pmd_t *pmd);
>
>  extern pte_t *pte_alloc_one_kernel(struct mm_struct *mm);
>
> -#define __pte_free_tlb(tlb, pte, addr) pte_free((tlb)->mm, (pte))
> +#define __pte_free_tlb(tlb, pte, addr) tlb_remove_ptdesc((tlb), page_ptd=
esc(pte))
>
>  #define pmd_populate(mm, pmd, pte) \
>                         (pmd_val(*(pmd)) =3D (unsigned long)page_address(=
pte))
> diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
> index f2f9cd9cde50..33c4caee30e2 100644
> --- a/arch/xtensa/Kconfig
> +++ b/arch/xtensa/Kconfig
> @@ -55,6 +55,7 @@ config XTENSA
>         select HAVE_VIRT_CPU_ACCOUNTING_GEN
>         select IRQ_DOMAIN
>         select LOCK_MM_AND_FIND_VMA
> +       select MMU_GATHER_RCU_TABLE_FREE if MMU

And MMU is required because NOMMU does not perform mmu_gather
operations, same as in the previous patch? If so, maybe make a note of
it in the changelog?

>         select MODULES_USE_ELF_RELA
>         select PERF_USE_VMALLOC
>         select TRACE_IRQFLAGS_SUPPORT
> diff --git a/arch/xtensa/include/asm/tlb.h b/arch/xtensa/include/asm/tlb.=
h
> index 8c3ceb427018..6fb7b78154f6 100644
> --- a/arch/xtensa/include/asm/tlb.h
> +++ b/arch/xtensa/include/asm/tlb.h
> @@ -16,7 +16,7 @@
>
>  #include <asm-generic/tlb.h>
>
> -#define __pte_free_tlb(tlb, pte, address)      pte_free((tlb)->mm, pte)
> +#define __pte_free_tlb(tlb, pte, address)      tlb_remove_ptdesc((tlb), =
page_ptdesc(pte))
>
>  void check_tlb_sanity(void);
>
>
> --
> 2.55.0
>

