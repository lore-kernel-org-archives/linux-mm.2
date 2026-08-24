Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C5F3C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 15:50:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 830096B0095; Mon, 24 Aug 2026 11:50:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E1C16B009B; Mon, 24 Aug 2026 11:50:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D5576B0095; Mon, 24 Aug 2026 11:50:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 323BE6B0095
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:50:43 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A4CA0140189
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:50:42 +0000 (UTC)
X-FDA: 85136600724.19.1E5C25A
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf29.hostedemail.com (Postfix) with ESMTP id 917C7120007
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:50:40 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=i6qtTiWn;
	dmarc=pass (policy=reject) header.from=sifive.com;
	spf=pass (imf29.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787586640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8n2sUFyNkTeeyJ480adWKOU51gCub2/F4WE3r3BRNf0=;
	b=cOVUgi7Gf0BDWifr53jEFNyrCvxL5m0RDCvb39FNZJr2ZD5AZmVTp768WoPxwz/ImZH8aw
	42XmN7R4v6BzvNA8xtp7oIU0rb4+envxWw1ICGcXI1eHH4M4gDcKRlmT+OW5aqU1IPTfZL
	fEHoim9Yv1fPzBcSqPHL2KrghlgZ4mU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=i6qtTiWn;
	dmarc=pass (policy=reject) header.from=sifive.com;
	spf=pass (imf29.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787586640;
	b=JyyhIVJG2t7xl9R1bgE7fToeRMx1CWFljzjSHaZ5XHZWfS78dp2grrXcq56TBA2VsT1TJK
	QZqOw/jwIHbUPUoX7pkcHQjqOeiXvfC5dhnfs30dLKk1CIsymU4rx9KSsD6k6Cr4ACVDSJ
	oyyDF1UgG+JkrP9N7gNBcpKb+YJZymQ=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-84874b52eabso4705965b3a.0
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:50:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1787586639; x=1788191439; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8n2sUFyNkTeeyJ480adWKOU51gCub2/F4WE3r3BRNf0=;
        b=i6qtTiWndoQ/OONhREsz/c8P7ajzOxjJTd/vk37WaNjpaeOntfld/KtMQgC7VQsHJt
         TXZdkh37ETR+rl2I+J90ID5tuhMfHhEKTcl8OYT5dhKXxgNXPgZOm1P3prj5/P2zrrub
         95145+kWdlC5ikhfWFSYDSMK17Yy254UMgITrrz3d2xponurxxTE6Bild1RMKO147p2a
         cfFRlca0hEkGCSFlrsDsUmi30/s62o4z/BKmyB6NfKA/q+Mir6yZ/MoEYT2lRgSlmN1l
         BTGUJQycQXaKrWaiWzSK5botdh2LQCOzAueeya6Q/JV5tnIQoiDlJTtLCP02AA8kCc4g
         EbmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787586639; x=1788191439;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8n2sUFyNkTeeyJ480adWKOU51gCub2/F4WE3r3BRNf0=;
        b=AEfpYJs/ykJBcVj2RM0xd3CO1GhF08yIy/c4QnCwCIYFmu5p/98NZ/FIWYI7lCPitL
         C5d/YfaTbt9aqaQ3Co9phFUM25zNsGZFvtMqUV3ptvZsbIVQ4Lzg6QLqLHcAkwCZLAqO
         qMFGqWyV28PsbEybPwV7iJVJXQQcpHJk0RNOf2+IJOOsWV4dVf8ecC9GVHbeTfQhmcyc
         goYU3Eo7D9DuErPS++tMT2v4Zd9/6Wkpu876y4SBQVHBo34kzaObpfNxNrdWey630MVf
         zHjfE3FANY0CoEOIsAQIrZo7xBxO4hm/kQuQ+APYCsBideH/CtmcjiCTqUhAWAM/c9Yn
         E7KA==
X-Forwarded-Encrypted: i=1; AHgh+Rr1JFquWjLfvop4pEZugI8hwzFcOnN+y/SeI3Euh+tC5tiXCXZv49Gv9u44K41MHt5FY+y5lMTSyw==@kvack.org
X-Gm-Message-State: AFuF++kbZtOiu3lEEx7kPCns1wpp99yMa3S3VIP8Da1R0K+Hvpw5rhR9
	v7XkBu0Z9M95FHuTU0W0OqEGvYeh4h1AogypUrAy1noPVoyAXubNCOOSl+CvnOnKfo8=
X-Gm-Gg: AR+sD10g7tdk/KrSwR7jXbnaNhhj0mletmHDZon+X6qV2NcrQ2pso8V84H1TJT+WvVW
	DD1AX3gIhxqu3AOQc9lBn5i4Xn/g+1dnY+5fkdTG+/hVhTyjfFTo/brIlq+F6YheAr/KgXPwND+
	hRo8jJV2qAPSufhEHmWy7k4gaQLCPVMBeK8xqNWpbrMPfpxaVYx8Da4I5spCfw7aIIJTv2fZS8R
	/uMcgnZvQdyAhtE3PzN5WBRxfNuRR8wLgJ3MgEgLb8v7dOWzYyZcU7KKWd+I2RKgeewLUgGTgGA
	b0q79pmEuDE9CJDGWv2q/ChB4XDFYc54RFCJpymaYRAhtuF2hAhjMu3StNQtdYADnZYhGJhOwQb
	uKk23MDTiiLbaZi1gioHBvNVnLWloCVL8pBiRESTTcI5LqGTU+3SreI7uJ9jxdy+nrihk+m+85Z
	W5d94fwr/oBvbaUfAGhIGR1XXlhKidYFUeDff3K97Gp2Xa4Bq6bhyRUah3IlnCSxG2
X-Received: by 2002:a05:6a00:10d1:b0:848:5540:2377 with SMTP id d2e1a72fcca58-851fa070c14mr40910400b3a.17.1787586639434;
        Mon, 24 Aug 2026 08:50:39 -0700 (PDT)
Received: from [100.64.0.1] ([165.225.242.163])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8520ef36048sm2219670b3a.26.2026.08.24.08.50.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Aug 2026 08:50:38 -0700 (PDT)
Message-ID: <6dae9cae-9665-4dc8-9a49-d6e5acda221b@sifive.com>
Date: Mon, 24 Aug 2026 10:50:37 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V3 8/8] mm: Drop pxd_ERROR()
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker
 <dalias@libc.org>, John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Helge Deller <deller@gmx.de>, Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>, linux-alpha@vger.kernel.org,
 linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org,
 loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org,
 linux-mips@vger.kernel.org, linux-openrisc@vger.kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-um@lists.infradead.org, linux-arch@vger.kernel.org,
 linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
 linux-mm@kvack.org, akpm@linux-foundation.org, david@kernel.org
References: <20260818040041.1891769-1-anshuman.khandual@arm.com>
 <20260818040041.1891769-9-anshuman.khandual@arm.com>
From: Samuel Holland <samuel.holland@sifive.com>
Content-Language: en-US
In-Reply-To: <20260818040041.1891769-9-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: z5met3gryt63x4a1rnbkgisw5c46o8f8
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 917C7120007
X-HE-Tag: 1787586640-769074
X-HE-Meta: U2FsdGVkX1+Opff5UScuftVLWwqE7iDKafWc5dSt5ty8qlBTVCoVmeKoq2RUzOy8ww4rBelvPIgLAH1c+3y72IS+zyfVFqpzSyc4re3DTb+UBPu80U3GAPSbD8wAe7MZ7dPPz7IwZaaPHutpAX5v2wZsXzN3ozj8GCIjwe3LRSuJOkJupLXLFGzv2LCg9NeJhhtXdcf2Zda3YnyjI6ndnJQn64Nf6EX0rv5mp7KFJVbccntEPeTGArsgnH6i96J8y2EEvilHJFfDvFP3azSWkuP+9m5VDZpwF8XEUbi+avMoenvyskQGbEBlEcAAPic14awxRR5RHwGN4iqhaSiNLvp18poIn+MdPh6mFQvTbkI763SEhO0tG8Fb7zVDN994Be6E/i8oDHrPbLZ8SMKKpE9oKf2rhkLTYG2DmOlA53CI7fNcdcJAez0Hk5EO/M0pe86J1RLziSFiat/1X/D6GkqLSFjSNjR0J7vHi6PcyuVNQi1l4Y2UdSm+DtssApux55xrbOaP7If+jaoxA97jLfl/SJ9JM25mwXPuzdw3Wk4bavdSk4JZquJ1QJTpgKp7K/kGPuIs6s9StliQ9V6tFE1ofk4XAxWRm5TeoMlpvaJvZeasGHcwKdl55YYXM13q2H8EtbzE/0ktB8we6R8SH86NhEEZPUDwd73lu9QTvSw2cW+lkWAH+jJkNu04hW7pGIZRoIgu/taOeat4Vt4Zu4Da5u11AypSicvjSsZs5jJVQoEiTgAUW1lwWPIno5cgBEb5lHcJ0QvQb9xu53/1omue59DGRfEvy8Y7pbZ9wJu0h9yCg+qVPhecfG2EVNCQhnx4IfQ4IAPoolo9u+9/Jf2sMKySBIOQY51ZugMOUu5FtwDJZnM4jK+wygOOVjDyoPtAe9fJhY7wj2Owvbwyn7fFeoQ9RPVNwjEhpnTtCfqQ2WKEZ1Eg8WA4GQrYy0hKLH/ROwLIoXtYPCGWHjN
 /4pGSrcq
 zjsYhe5RrY/JWFeYs/BFjybxaPqDS2jdrEzSspWitKet/yVhjaSfaFaz2bFbpfi/7e9765A1So+79knOtScp8XyeS2iUB7UaRA8CF5cCdpIjTnTSmmZQDKcvtoh/bXU8z7fKVPKail1zBKsyvCA06Yb6neB9smBRzUNp1fTLYJXV2S7uOtJqkjKSTlVygWrEpdD4eyovQ7YjJpdzg+CoNBARN+HnCSfSW8qyi4Qs5cNLcBSAoYKXP4Wg6m0dspQEgJrOYqetkW1lr5bJa/q8Gy++Ees5F2e1XHy89xl0w/jQIiIDmZHB6Egsm6EqzKgmT6Dn0HX5uz9OgzBd456DGaiRbU0Y+DOF4JwMX2BDVRHdRHie5edtek4TmJm1mXed6U6Mfmh5N2s4bCUrSYmzuMXIDvT+8gtwCJbJkqmfrMAAQ276ME3a1n6R/vkC5RfD5D6UxVvWM0NUCp4NND26QuMN5sU+FbyLwWhn45HKCcnBDd2LFb5BGdqF7Co06USuyIdAGm7pOWEZevg3c0f+jnoX0UWIN5JB1Edb6PDZiW2ARG30ch/B7Z/COHP31IjERFph0DH1RC3D4ieoDH3yiCyuNEM0Co4JRsQPlyTtS1IGSCIMaKHwcoj0lB7vIgY7AE9wAJ25RFbv9EjIjOoB3bMIiFPe0uGaOk2FKh9F7DRlwknhHFnlStH/BvsQ4UaxTgOMKQ8sf4gxhMrHTk0KOmCyyUvuY4zr8uEfIolngoEccZKQVN1OEbItpxcStysI55THB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-08-17 11:00 PM, Anshuman Khandual wrote:
> There are no more users left for any pxd_ERROR() either in generic MM or in
> the platform MM. Hence all these platform macros along with their generic
> fallback could be dropped across the tree.
> 
> Cc: linux-alpha@vger.kernel.org
> Cc: linux-snps-arc@lists.infradead.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-csky@vger.kernel.org
> Cc: linux-hexagon@vger.kernel.org
> Cc: loongarch@lists.linux.dev
> Cc: linux-m68k@lists.linux-m68k.org
> Cc: linux-mips@vger.kernel.org
> Cc: linux-openrisc@vger.kernel.org
> Cc: linux-parisc@vger.kernel.org
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: linux-riscv@lists.infradead.org
> Cc: linux-s390@vger.kernel.org
> Cc: linux-sh@vger.kernel.org
> Cc: sparclinux@vger.kernel.org
> Cc: linux-um@lists.infradead.org
> Cc: linux-arch@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Acked-by: Geert Uytterhoeven <geert@linux-m68k.org> # m68k
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
> Changes in RFC V3
> 
> - Moved ptrval_to_str() as header in a [PATCH 1/8]
> - Stopped using pxd_ERROR() in generic MM in [PATCH 2/8]
> - Dropped pxd_ERRO() macros from all platforms in this patch
> 
>  arch/alpha/include/asm/pgtable.h               |  7 -------
>  arch/arc/include/asm/pgtable-levels.h          | 11 -----------
>  arch/arm/include/asm/pgtable.h                 |  7 -------
>  arch/arm/kernel/traps.c                        | 17 -----------------
>  arch/arm64/include/asm/pgtable.h               | 15 ---------------
>  arch/csky/include/asm/pgtable.h                |  4 ----
>  arch/hexagon/include/asm/pgtable.h             |  3 ---
>  arch/loongarch/include/asm/pgtable.h           | 11 -----------
>  arch/m68k/include/asm/mcf_pgtable.h            |  6 ------
>  arch/m68k/include/asm/motorola_pgtable.h       |  8 --------
>  arch/m68k/include/asm/sun3_pgtable.h           |  7 -------
>  arch/microblaze/include/asm/pgtable.h          |  7 -------
>  arch/mips/include/asm/pgtable-32.h             | 10 ----------
>  arch/mips/include/asm/pgtable-64.h             | 13 -------------
>  arch/nios2/include/asm/pgtable.h               |  7 -------
>  arch/openrisc/include/asm/pgtable.h            |  7 -------
>  arch/parisc/include/asm/pgtable.h              |  9 ---------
>  arch/powerpc/include/asm/book3s/32/pgtable.h   |  2 --
>  arch/powerpc/include/asm/book3s/64/pgtable.h   |  7 -------
>  arch/powerpc/include/asm/nohash/32/pgtable.h   |  2 --
>  .../powerpc/include/asm/nohash/64/pgtable-4k.h |  3 ---
>  arch/powerpc/include/asm/nohash/64/pgtable.h   |  5 -----
>  arch/riscv/include/asm/pgtable-64.h            |  9 ---------
>  arch/riscv/include/asm/pgtable.h               |  4 ----
>  arch/s390/include/asm/pgtable.h                | 11 -----------
>  arch/sh/include/asm/pgtable-3level.h           |  3 ---
>  arch/sh/include/asm/pgtable_32.h               |  8 --------
>  arch/sparc/include/asm/pgtable_32.h            |  3 ---
>  arch/sparc/include/asm/pgtable_64.h            | 10 ----------
>  arch/um/include/asm/pgtable-2level.h           |  7 -------
>  arch/um/include/asm/pgtable-4level.h           | 13 -------------
>  arch/x86/include/asm/pgtable-2level.h          |  5 -----
>  arch/x86/include/asm/pgtable-3level.h          | 11 -----------
>  arch/x86/include/asm/pgtable_64.h              | 18 ------------------
>  arch/xtensa/include/asm/pgtable.h              |  4 ----
>  include/asm-generic/pgtable-nop4d.h            |  1 -
>  include/asm-generic/pgtable-nopmd.h            |  1 -
>  include/asm-generic/pgtable-nopud.h            |  1 -
>  38 files changed, 277 deletions(-)
> ...
> diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
> index 5d5756bda82e..993a6505eb8f 100644
> --- a/arch/riscv/include/asm/pgtable.h
> +++ b/arch/riscv/include/asm/pgtable.h
> @@ -559,10 +559,6 @@ static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
>  	return __pte((pte_val(pte) & _PAGE_CHG_MASK) | newprot_val);
>  }
>  
> -#define pgd_ERROR(e) \
> -	pr_err("%s:%d: bad pgd " PTE_FMT ".\n", __FILE__, __LINE__, pgd_val(e))

We can drop the PTE_FMT macro now too.

Regards,
Samuel


