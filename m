Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FA64606A7D7
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 19:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Epucy49X
Received: by kanga.kvack.org (Postfix)
	id 505696B05B1; Wed, 18 Nov 2026 14:31:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B70A6B05B2; Wed, 18 Nov 2026 14:31:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A6936B05B3; Wed, 18 Nov 2026 14:31:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E80C86B05B1
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:31:26 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EC958A08A6
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 19:31:25 +0000 (UTC)
X-FDA: 85449233730.08.E1DF4AA
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf21.hostedemail.com (Postfix) with ESMTP id 16D731C0002
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 19:31:23 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Epucy49X;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795030284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DyoNOi8SqxQRtdWNaiooYSD8hFAkDD28ur39JiQbgr8=;
	b=PszrIhnr+zdLODtDdNH/5sRc15Dglo8Z7blYvX435HrIz6XrT67Vzdd5d0AVhSyFWBdZyR
	HR4m+GurmnAYlgBLNi0pQdl8/3Ts48V//kpmmls55JmQ6BAGV+Qi2VTOMTvC7FOKe5KGTp
	y7r5Kd+LnRjdj3cp304oThA0SdULymI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Epucy49X;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795030284;
	b=7JTuRc6F4LVtel+v4naBYWPwiCdU5Tr78LSDp1eToL7VD0LY8f7enaCHLUfqWh/O7OOML0
	Yjpv1MJkZAL2ISTU5hHbLUFjCW6W0/pgu6PoTGchoIC5HF635lLLDfZG7iYxLC/u7PIHuX
	7YI29pMf3jHk67b2+3JOlyKLb509Qfk=
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c4cac7a7d3cso191710766b.3
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 11:31:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795030282; x=1795635082; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DyoNOi8SqxQRtdWNaiooYSD8hFAkDD28ur39JiQbgr8=;
        b=Epucy49XQ7DX7k5sujMq2+Q3Z18VXc3Bui6Dvn59VKrdd/kZPxKWux/vm81zyshwo4
         RzaKW28ECzWiy2oHY5kIyp7OlVGXUgQe3xrwuqaSPNb/uxtRe6UFeAFaJ8TUMLY1Gkz4
         DZj6HQqOuBGvLPs1wym0hi8w7nezPY8HYWvqDlNKtuS/KuiWR4KSNQK5JaLRszoAsuv+
         VYeufQ4SlqBpBlLbdj9xWOq0YzsaatcQhFqNm+TYOTv3j6mmj/A8LuIiJwOy8J9BN87k
         OyO6UJyE10F2EGL5z6eApe8bTHPHH7vgJ5uuLm/2+0pp5LlapgvAQq6YtxqPfWRR94sM
         Qqwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795030282; x=1795635082;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DyoNOi8SqxQRtdWNaiooYSD8hFAkDD28ur39JiQbgr8=;
        b=YK3g59AknQXddAUG2SwDcVSMDO7hWIFt2N0KOF1ppQAIcjulmeKI2MFXZlJzgHtQXT
         7Tqv73AKyq98FxCiaPiE7JgFAZSLo/WvVOdJbylxXTi3NBkHkxDHZvq2JXEAuAegah/3
         P58m7fpPRLqcr69vn/ZG1QG4FdzYJIJwS5xmO7pkrjEAz5BFzhXLRyjkU71WNMKoksn4
         GXTmnNVyNtIzPeso2a7cFUodSciRQk3RexuNm8bu3+qHQelWst/t0yKp+z/ctjwJ1R7f
         +dI/3OH5CZW5xQxGwW/2juDeeBgH0EIo16ycCfCTg14+Nvex1b0ezSnZGA0pZIsP3PsD
         ttfg==
X-Forwarded-Encrypted: i=1; AL+hErG8C1NR3r9u9or9a6gkAOcIpXovUJ1n8NCJeFAi/7lvqOtKmo/4972TqxX7pawxUhgIpntHha3KQw==@kvack.org
X-Gm-Message-State: APuU4Z/LUeYYl84GFjQ1WXvXMBzd90RXsH/vQ8pDx3s9ToHUpVJzSQlV
	5CtDojUujk8U2wf8BNuYLqeB+veqdfvbLCrth8JPc3Tb8vEBprmVcMhX
X-Gm-Gg: AYBFou3haz51uIsPSAYvBihvGHbIoi6JY7P2ro92AaYxNBgZYSgeUTlbUnEkj/irT1+
	TwEREm7Va85kgQrWKqFAGGyNK1lVnzRpxsQXK/SmoMBK95a+Fd/+jnEs6R/JCD5e4ESmIYIPtk5
	ZXyGvpttU3nfvl3+ssZ+jeEtWgT1wVvxhb0rB0Ck/325sH4DhVMEbZ1NOogkkKelPF2KvmqSIKt
	QzdXzQ5kjt3Smr4OHtq4+AfK/S1asNTIbXW5u1Te3icTa2Ilq+Hy294azBzGkrR00hxFoxkNUFl
	J+sNEI1/D95S98QKD95B+3CliGZIbiodU/EtA1IDKtpSOHpfv5RXURJbHUuicJoYIAcNiH/LAZ6
	JeUUlAtAEyoCKvR2KQyenlKcR0ufl/Vdou2uVu1WehY2jUvxpjB2ZRSrpihjSc/+MehsROQmYO4
	LdeCElzn+9JhqWkKqPaYmKMY/m7p2Vx1o3V6Qx+S3FpRrPiAbqmtZvjMErGxhnscSMAsNdwPIGE
	us/1eSjCzear8ZENzvMq63+zC23nNi1vHPFa3xHk5OM8wLAiUR3guRtXBLm0rXfetKlIg==
X-Received: by 2002:a17:907:3f93:b0:c2e:61e:f4fd with SMTP id a640c23a62f3a-c510debe470mr322367566b.5.1795030282513;
        Wed, 18 Nov 2026 11:31:22 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c512351bc7fsm29492666b.86.2026.11.18.11.31.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 11:31:22 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Wed, 18 Nov 2026 20:31:18 +0100
To: Hao Ge <hao.ge@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>,
	Uladzislau Rezki <urezki@gmail.com>, Dev Jain <dev.jain@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>, linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
	linux-mm@kvack.org, Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH v5 05/11] mm/vmalloc: only flush the cache after the vmap
 succeeded
Message-ID: <av39BuCsq-dRFiMM@milan>
References: <20261116071325.263682-1-hao.ge@linux.dev>
 <20261116071325.263682-6-hao.ge@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116071325.263682-6-hao.ge@linux.dev>
X-Rspamd-Queue-Id: 16D731C0002
X-Rspam-User: 
X-Stat-Signature: bz4wzhty4wdmfodrpwqyg4nf4o6f5jq6
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795030283-193562
X-HE-Meta: U2FsdGVkX1+HBQOOqCMlovNQf5ZudFS1Dg+Czlye+U2Y02AdHnpT9WxjX8n5JLD9EiaJJJ7J4YoSPB10o50nlpDKKyH2y7x9QGRmy3nK+DjWHEvCAIFXK9JsHrCocjlS8j9RLMSE5+1mUkOt7A8ISZFE3sLmQwKb/xZ4Xf9/m1C63l1LoqTaG+lMVxQCZGC+BcmWe3bieDv6pcie3v0gb/pbOeGJZKv9AhwmoMY3vICBdoL3uYtEpJpDZUyONDuEqPHDfh7uEK7gOGlsp4Qopurb9rgW+Hf4cRtDSEtLTPM84R0ZI99Pz8MgmSYa63I+fGiClGu0Sc0DAjpgP5mtPidj2HdLP54F8bUaWatFQjzJqxQN9ophWiBhPYzn89D2LoXN8CHcYJT4eA2NplwZV+ZOtYmdiv6WCeUhrpbUpsxUJ9K73VVEw9jLmY/zmcgr2ZeHbZJJixNYg2w4JzgMNIF8+Hhd20UPFcSjwEBzHS+6yJGqdD70t7DmDVaBEHZjfAoTXWTnbXy1fsAX3vW3PP7z+5I8unAbAIosW1ImhaqxFK2qwdYXdpjv2+U8q6lUTkomXGkIL8bTPaEJzCbpPlGafc4Ru0CHrvRgY3HDLolM0f8cpDQ2mVht9HSFyYfhz04/hX46rALfaW0U6AgLkWCgrJ13U2DObYZ2FvnVO+5gvsOyxlEaI4e3IlH6akV20CHni+O8mmETN6FXJnaYQ1NZoyAIA0vpXVuL1K+tV2GKeQczrQYZr3S9YtKq63a60vtHucSVh95wrFp7LfGpuj7xfho9WwDrGNC00x7sUC61t6GZBSZZXLCeNN+Dd0AKYAgKZAvdoBxdAYyC/Bg3mMkIzEwooOZ3/aWmLEN6MrBNxg3fJH7kLGaRS1+zb+u6ntGEepxd2K83wcZzPEhY9RJnmkRz4niGZO8DKTav6EMGb7QZGlJb57qfGXO8eZBgHEece19GFqholN4/E2q
 FS/tB+ZK
 zEQokYK4R4gzXH7I1PxJ442eea3BnHcEE8fjXxIzAgFNAnD/aYWW8SkSpisXFrkIgp+i+rSZrcW/9qpqRvc4+F3jx48J+jeFVqv0bLAHlC/mnQ+pPAJw7JqmAwlD6oHJTM/1PV5vP9ysqMF222xzKfmmbKx7bXAqNeMjgYGd/JbbjWEPFaD4LYbcRKn7bC/FQoOYsHTy7752VyT6+7EoY423jXaJCEPXhTMG6Iy3kDqeY65CjrCi/6EUJRAnK8IRz8UMr4S+mouhV2akdhItqe1zsJj6itul6MeFaF0WrKRq8tT7Hir+Wrd99lydmAj3K0tY93CnqUhMJ2lc0+4oAhKl2eNXKY2efmybsUYRQ4N8r31kmR9cZIUC7dXVaA/H6ymxTh97dKiHfu5gdvCEZ4dci5Gsxgtiv8o6+3sF4nqPK2SoW6hFVBtFStqfogoPgISymnMG9soFeZ77vNinwittYFl9usKY3IbFXGC5LY2VlsMRlzCSezwDlwGwh3KHWKFNF5rCU5ktPB6JtsrwkANM5RAU4KSdfU19oX9huvACaZmzowlDY1PeqGtca2v9GC2p2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 03:13:19PM +0800, Hao Ge wrote:
> vmap_page_range(), __vmap_pages_range() and vmap_pages_range_batched()
> call flush_cache_vmap() before they even look at the error code. A
> failed mapping is never used, so the flush is pointless at best.
> 
> According to the Sashiko review it is worse than pointless on UML:
> flush_cache_vmap() there is flush_tlb_kernel_range(), which syncs the
> PTEs into the host OS. Flushing a half-installed mapping therefore
> leaves host mappings behind for a range that was just freed again.
> 
> Only flush when the mapping, and for vmap_page_range() also the KMSAN
> metadata, is fully set up.
> 
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://lore.kernel.org/all/sashiko-outbox-178439@kernel.org/
> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> ---
>  mm/vmalloc.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index e2b63cb1592b..d99d7710e1ba 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -371,10 +371,12 @@ int vmap_page_range(unsigned long addr, unsigned long end,
>  
>  	err = vmap_range_noflush(addr, end, phys_addr, pgprot_nx(prot),
>  				 ioremap_max_page_shift);
> -	flush_cache_vmap(addr, end);
>  	if (!err)
>  		err = kmsan_ioremap_page_range(addr, end, phys_addr, prot,
>  					       ioremap_max_page_shift);
> +	if (!err)
> +		flush_cache_vmap(addr, end);
> +
>  	return err;
>  }
>  
This is incomplete. Maybe merge with 6.

--
Uladzislau Rezki

