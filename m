Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C975DC5B572
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 13:37:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86C636B0154; Wed, 12 Aug 2026 09:37:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81CC66B0163; Wed, 12 Aug 2026 09:37:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70D3A6B0166; Wed, 12 Aug 2026 09:37:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 45E346B0163
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:37:15 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DACCC1A0252
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:37:14 +0000 (UTC)
X-FDA: 85092718788.01.54C1701
Received: from mta1.migadu.com (out-69.mta1.migadu.com [95.215.58.69])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5B07F100003
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:37:12 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gGr7Jl3W;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of fuad.tabba@linux.dev designates 95.215.58.69 as permitted sender) smtp.mailfrom=fuad.tabba@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786541832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yHS593ZsxK42RiaiFIbgrMsLtAktULqJbw1TC1CMxAs=;
	b=Z2YRH0xtFpAjvDYgmyGCEnCtB8UIHFod16eJmG0rF/nhPVi5Rfw3T6RHZMIrNkF8SfyA+T
	p9v9gSLEWyq2RqvACq4+rxT/Imi5rvVRLjAB+LahQSHRBoxzkqzILMvG51DQj4rEVUnplX
	LSMIo/F0TVZUhw0aUEVN8A/TxS0AhF0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gGr7Jl3W;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of fuad.tabba@linux.dev designates 95.215.58.69 as permitted sender) smtp.mailfrom=fuad.tabba@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786541832;
	b=GvJuXRik09eRFQKdeabQWWfPnU7gBTYy3/cQZO31CIJmA4QdXRxyK62AtztpiLxOuIgBaS
	zFzx+nwRUUtTRKMjY7Aw2HVvOj8pqMEdJToSHgDpczq9Cvt8YUGClnDzN/1vJIE9u+rS43
	JFFVEaWGgDgcUq8+AiGYQX/TmIkYL5E=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=9Xb9EfUOdgvpGqMkiydwEhSmxQ/7eEZavJu7C2JawOQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786541830; v=1; x=1787146630;
 b=gGr7Jl3WOGOYU7vbPbGo/KCeTMhNYTUwKHfJII19Aqnka2tWDX3WQ+qhdjMBPWk0uVU8JuoN
 tGFl8cQbwlJA52ePaLPuRB3B2EenEzg7QfcGPYZWH3iVWWLuy2lQKluaX4SV2r3LRaYbzIrANw9
 g4idWbW3H0ARalkCbqNwqnaQ=
X-Envelope-To: linux-mm@kvack.org
Received: from mail-qt1-f178.google.com (209.85.160.178)
	by smtp.migadu.com with ESMTPS id b3ec51eaaf633468;
	Wed, 12 Aug 2026 13:37:10 +0000
X-Migadu-Flow: FLOW_OUT
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-51c10e86e52so229831cf.1
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 06:37:06 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqBpWw5zF0Lgqu01Ik4ldH/n/Faz6m/rHA+qk8XAMH60l8qnBndvzdP+OX/ZkeMlGtUYu0OJ6jsRQ==@kvack.org
X-Gm-Message-State: AOJu0Yxp2GegnmqtaW3TS/vsjj15oPyOqFAwZVFWJbIlvuEwDRMNI++i
	BXnDBPMhV5gSsCYhFfqQDX18MVLJI80Q1KotL1iChruyM4nHTdNSP4oQucB4+FzYUQQbJ8Emav/
	YLWD77aSGCQavI8a1V3hkaeYanjhyrqSbcB7r3nVU
X-Received: by 2002:a05:622a:40cd:b0:52b:4ec6:52ba with SMTP id
 d75a77b69052e-52d61f23159mr20522611cf.6.1786541825229; Wed, 12 Aug 2026
 06:37:05 -0700 (PDT)
MIME-Version: 1.0
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com> <20260807-gmem-inplace-conversion-v10-15-2fc18ee6d3ba@google.com>
In-Reply-To: <20260807-gmem-inplace-conversion-v10-15-2fc18ee6d3ba@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 12 Aug 2026 15:36:28 +0200
X-Gmail-Original-Message-ID: <CA+EHjTxmA0U+RxULtiZtFRvBzhcbCMgj_kTO6a9fqkPvvyrh0A@mail.gmail.com>
X-Gm-Features: AUfX_myT7Ln5tM4ht32h0TuFrnmnlLxzcErRjugq3csyVB5j1YAHRpRMYVzjI2U
Message-ID: <CA+EHjTxmA0U+RxULtiZtFRvBzhcbCMgj_kTO6a9fqkPvvyrh0A@mail.gmail.com>
Subject: Re: [PATCH v10 15/41] KVM: guest_memfd: Handle lru_add fbatch
 refcounts during conversion safety check
To: ackerleytng@google.com
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 5B07F100003
X-Stat-Signature: mnygkb69w88tmctynufi5h19df166y43
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786541832-433621
X-HE-Meta: U2FsdGVkX1+g1Q9rygoYcFTW3ihXAIcdFqVfEfzGZ3sosIEjp80dMsm1rwexXGo+FOjZnq1pI5Wn2daaiiprCl3VQp3m69WsF0vYMvNJ/3Gg8EfsnLqYqrunikK+VxNUiXMU+3fryvUQEOcsdPwM2vgNNi7d0VL8jhTXthyrPzO6cMjkpMvp/jDc8r7TPQgE8abUt9mItuqa5q2gJZ+ki7uXRsqYjphENQqRtnAhlxmANOeSm8GGvB/U9ftW3lr2iAS/r9G2CZfvBNuqqE0HNx1S6Tp/ikd95zs8aAgLEwwSbNLsNlYYhs/ckAahmvdai5nL9mAJ3LYafyJn32QNbj4nWNeUGEJKq8mqjbKmMf8186sT0bPiEVg9iyGqkPh+fvqvxuzDzh0+v+AYtCsoMZLNEmO2iR19XxntSMJxyAzD+2GdVam1R5WQfpknNtUY6uGPfcntEZOm65VQHK0gFKYybMBLLtzhkGLW/AxgNu8bnHRKzGZBe0sIqEUzTLmXRtHayn7jlK+M1jMh/c7tL2J/sAsLEJ6K6VGKKkx6r9Xv98j/tZTg5vX+1CCbWEFG4BsEm4ZoUJtVWyyVq4EOTmljxqX0OfMqmUkxnE+E75gSxYZ/KAJTqT11iGczbTcjWFP9RIiRhiH0QsRRBQLt9x7Fn5/Yr8A/3u3uUmIWAAyclJDOSQyuXtX08Yu18kaNqO55aU8BXCxc/mYVfCLDrpIOeRq0FE5VkkjCzW5ShYbHt+yq3waKjjxchXq6pia0vDSyZwgtcCxVTE6S5aUdsSea8nqfrXalbalgd1o6dD5MY8SVh0s0OPdaWVF2FGkw2Jb3rHOyRObKq/OgCxAzM+EYuA2Yn/G/iHJtCi0kKd2sTPk+1stCdU3GlFvPHfMUlG/NPCNInLyQK601cNYwkzvjJ2Xy5l1LDK7u+xsqzXfHloyaAlLMM0ytGzQtHzv3aYvdqgkRNQbZeyex4fF
 Rsh1mGaM
 uAz7Xjauve6a0xAjSxKjHcTD7zKpoFPmtQWGAjnxxKlgT5XhG+oUq+9Zv8mJP8qAJTnqZnUNbYE3HTDPRCiPe0NMSKSt2UhPrGLDo+pwIMrX7fe9Q4Rj1yjbOG8FL888N9rTZSoI8aW7K0g5fieUulG1M3+fWKwy00yb6sTeJHl96CRO+evJXLVJY2HQxB528ApRrUKjZVbefNw0xs/xQEzfTcoHWb7iTeht88Y0snnq4Tn+Tg5k+ArSUhQmMjccrvCpFUkTT/EpLNwFv4AiP5Nx+P0hURK7caquqOqAACM3qFb0VgPb7CHqssLsXOZCP4iF2GIilTVD52LJBpgwDmBYSCRegBgUmjZyyD1LuxaHQcm8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 7 Aug 2026 at 23:52, Ackerley Tng via B4 Relay
<devnull+ackerleytng.google.com@kernel.org> wrote:
>
> From: Ackerley Tng <ackerleytng@google.com>
>
> A guest_memfd folio is safe for conversion if guest_memfd holds the last
> references on it. Any other references on the folio may indicate another
> user, and guest_memfd cannot convert it to private if there may be an
> existing host user.
>
> A folio will have extra refcounts if it is present in a per-CPU lru_add
> fbatch. guest_memfd does not actually participate in LRU, but
> freshly-allocated folios are still added to the lru_add fbatch for batch
> LRU statistics processing.
>
> This one known "usage" of the folio is handled by draining the lru_add
> fbatch. After draining, if the refcount is still elevated, then there's
> truly some other user of this page, and the page is not safe for
> conversion.
>
> If the page may be dma pinned, DMA is obviously using it and hence not safe
> for conversions. If the page is still mapped after guest_memfd tried to
> unmap it earlier in the conversion process, it is also obviously not safe
> for conversion. Exit early to avoid unnecessary draining in these 2 cases.
>
> Provide a drain status to only drain once ever while processing a batch of
> folios.
>
> Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad


> ---
>  mm/swap.c              |  2 ++
>  virt/kvm/guest_memfd.c | 23 +++++++++++++++++++----
>  2 files changed, 21 insertions(+), 4 deletions(-)
>
> diff --git a/mm/swap.c b/mm/swap.c
> index 8e965c8ce9aa9..9f511b97ab110 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -37,6 +37,7 @@
>  #include <linux/page_idle.h>
>  #include <linux/local_lock.h>
>  #include <linux/buffer_head.h>
> +#include <linux/kvm_types.h>
>
>  #include "internal.h"
>
> @@ -995,6 +996,7 @@ void lru_cache_drain_for_folio(const struct folio *folio,
>                         *drained = LRU_CACHE_DRAINED_ALL;
>         }
>  }
> +EXPORT_SYMBOL_FOR_KVM(lru_cache_drain_for_folio);
>
>  atomic_t lru_disable_count = ATOMIC_INIT(0);
>
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 896699afcad9d..030af0855f8b0 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -8,6 +8,7 @@
>  #include <linux/mempolicy.h>
>  #include <linux/pseudo_fs.h>
>  #include <linux/pagemap.h>
> +#include <linux/swap.h>
>
>  #include "kvm_mm.h"
>  #include "guest_memfd.h"
> @@ -542,11 +543,26 @@ static int kvm_gmem_mas_preallocate(struct ma_state *mas, u64 attributes,
>         return mas_preallocate(mas, xa_mk_value(attributes), GFP_KERNEL);
>  }
>
> +static bool __folio_safe_for_conversion(struct folio *folio,
> +                                       enum lru_cache_drained *drained)
> +{
> +       const int filemap_get_folios_refcount = 1;
> +
> +       if (folio_maybe_dma_pinned(folio) || folio_mapped(folio))
> +               return false;
> +
> +       lru_cache_drain_for_folio(folio, filemap_get_folios_refcount,
> +                                 drained);
> +
> +       return folio_ref_count(folio) ==
> +              folio_nr_pages(folio) + filemap_get_folios_refcount;
> +}
> +
>  static bool kvm_gmem_is_safe_for_conversion(struct inode *inode, pgoff_t start,
>                                             size_t nr_pages, pgoff_t *err_index)
>  {
> +       enum lru_cache_drained drained = LRU_CACHE_NOT_DRAINED;
>         struct address_space *mapping = inode->i_mapping;
> -       const int filemap_get_folios_refcount = 1;
>         pgoff_t last = start + nr_pages - 1;
>         struct folio_batch fbatch;
>         bool safe = true;
> @@ -560,9 +576,8 @@ static bool kvm_gmem_is_safe_for_conversion(struct inode *inode, pgoff_t start,
>                 for (i = 0; i < folio_batch_count(&fbatch); ++i) {
>                         struct folio *folio = fbatch.folios[i];
>
> -                       if (folio_ref_count(folio) !=
> -                           folio_nr_pages(folio) + filemap_get_folios_refcount) {
> -                               safe = false;
> +                       safe = __folio_safe_for_conversion(folio, &drained);
> +                       if (!safe) {
>                                 *err_index = max(start, folio->index);
>                                 break;
>                         }
>
> --
> 2.55.0.654.g21b8a5bc05-goog
>
>

