Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE690CCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 16:00:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56BB28E000D; Wed, 22 Oct 2025 12:00:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5437B8E0003; Wed, 22 Oct 2025 12:00:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 459348E000D; Wed, 22 Oct 2025 12:00:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 325AA8E0003
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 12:00:30 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D86B81408A8
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 16:00:29 +0000 (UTC)
X-FDA: 84026212578.09.74BADAF
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf10.hostedemail.com (Postfix) with ESMTP id C2500C000C
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 16:00:27 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Z3MXi9nJ;
	spf=pass (imf10.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761148827; a=rsa-sha256;
	cv=none;
	b=bfVcJofL5vsjAmJDqJ3pD3JiTJD44jGLWFcIShpiHsl/uuMBw2f5JjCeUjEIRo3TMDjXlR
	Dz22FzP/u+hVqtPZv3kt0xaA5x6ZkaMUsWTnmYIsnDZfn8DcKKyuHdN9hHQU6fNBCLUvo5
	RmooYy/EP3r4dGHmABM+xZ1RG+Xmq0o=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Z3MXi9nJ;
	spf=pass (imf10.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761148827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nrE4Qz7SJRI1Enuhm5FI5J4QD5PmBoz82eoX+T/eGMU=;
	b=EvFVJCuWFwriJkoqvgGNCWgTc5BTwJ7yidPHqnLfw8nwsNxZ6M1L6Rbq8M3vQkmw65//6h
	YT9hvC3W3k7ximLmdbBhp7MHXnKMsG7HQWoyf68HKJfFOCrEqtphQlqqU7eLSLBGFN4H+V
	xafByNWdbyoWGHR1THir30hSQxNGtBY=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-471005e2ba9so68215e9.1
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 09:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761148826; x=1761753626; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nrE4Qz7SJRI1Enuhm5FI5J4QD5PmBoz82eoX+T/eGMU=;
        b=Z3MXi9nJyz++kO0nLpcU2z7DNKB9ZKRHhydnBKkDmr+E0/72wZEzJOPDBZlAZPy0fc
         ROUDKPV7gGsd73vnLl83bVvADg/hZ8i5QuJE+Jzlir8VI6+Jgx6bBmye1c4CspylkO7m
         /a1MMqUdg6oiGCZUVBV2/FVSY69s1ELsUw1i0xIU/Aa8fci1RWaWbwc4aIDzHszvX70p
         gKPUexH69nUsrrQKleQjhCJ930wImW6id0X9LI0iW1EqcZ/cHi8RDM43oD39nWknWy4z
         0v2WFAdtMQqa9uw1+KVj7AQ15sWzjLPeO5R45qgCaxboKXw/ZzeuzVvrsHNx8M7h87iT
         EYxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761148826; x=1761753626;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nrE4Qz7SJRI1Enuhm5FI5J4QD5PmBoz82eoX+T/eGMU=;
        b=CGpSb7gzcLhLWaB9bngwMabvudR7h4BM7yX6/2Brkbp/j+6rcrQceTcAg2vk8o5GbV
         oH0JaZLpdWAFrQjf9lQ2j1XhMj6dXNCx/X1xiaXx36mKVJPWr05qth6xvx3LnGT0a4JG
         Z/gSbgE7WjEen9rkHp7yRQOqOF0G+FVLO6fcqMccN1Vrx/iGmNEs8nGtOJzfs54w+jqx
         LDYnRXFWKcXr0hd6qJtho0YTcomkK1VTWl3Ul7RCguZcXBEv/ydZhtyVcUxwhcoBUTZj
         Fx+MB26XZFm3PVE0wjS/Ji1JIFxAaVThbhSEhF6T3pKFoA3Bm/pV/4jh3p9tyqBDtJTr
         Q4oQ==
X-Forwarded-Encrypted: i=1; AJvYcCV37UvbqpvaMmGV2kakIeSU7z/46p0TnVrAWQkun9n62AVCyH2N76ep6kgydOKeZRiqu+BkD5IVqw==@kvack.org
X-Gm-Message-State: AOJu0YyE1JBhkXcD981kg9K5qpQ805PsZegvxYCpHlot7xaGwarFEuMI
	Cqroek5A8cUhDH/JZPgCHLEvp27oq0ZZH2oFuTqZPvSswoUkRpq5Zun5EAAWsNVB0JRymRck8mj
	Yijs2COMQ81AYOyJ1+Bacx4XQ3xslBPwN9WwmjS7N
X-Gm-Gg: ASbGncue5IKFPSQ1Vlk+S8DTSWYLU9b37ZXZQgFG84Hbvuk6gGP7PBmNxikhViNFlKr
	eUF7ZI+riLmgvo7cLVo7QHELmsBeC1yYCn2GaD4Y9sF4bDtOx3/AEHwQ+8b2UUjmd3tR85/4SFO
	Jn7HiBtORR3tuAWJKbSsX10VBY5cJPN0Xg23OhglCI9zEobdW2TpVq00q3OMaUK+nkE4o88gelN
	Nan8+tH/JKFkQv9BiFS9JN46lwblP0vG/XHuPrIdjlQ0BIuwIW3lN1sA1tVOmgMEUL/xbmpXmcs
	hMtyt3Mp6bO0PROLaQ==
X-Google-Smtp-Source: AGHT+IGQ5urEAQ9m57T3Tr0rBInJl1kxrVgo9aZA5J1ni84q+HbgDwPfJxL7EgSHQYRd3sVOQI4JW1ylUbWl3BXuheM=
X-Received: by 2002:a05:600c:c04b:10b0:46f:c587:df17 with SMTP id
 5b1f17b1804b1-475c5138edbmr772405e9.1.1761148826010; Wed, 22 Oct 2025
 09:00:26 -0700 (PDT)
MIME-Version: 1.0
References: <20251021102327.199099-1-ankita@nvidia.com> <20251021102327.199099-2-ankita@nvidia.com>
In-Reply-To: <20251021102327.199099-2-ankita@nvidia.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Wed, 22 Oct 2025 09:00:13 -0700
X-Gm-Features: AS18NWCpMHMP31ZSlN1pMxGifJCs7kl9OgsJ-oSyN2IYIPEyac80DDLNqIbtKlQ
Message-ID: <CACw3F5036Kfs_j8np+_+YejC02ADeLoCNYaQVhmBRzQF32NAgA@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] mm: handle poisoning of pfn without struct pages
To: ankita@nvidia.com
Cc: aniketa@nvidia.com, vsethi@nvidia.com, jgg@nvidia.com, mochs@nvidia.com, 
	skolothumtho@nvidia.com, linmiaohe@huawei.com, nao.horiguchi@gmail.com, 
	akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, tony.luck@intel.com, bp@alien8.de, rafael@kernel.org, 
	guohanjun@huawei.com, mchehab@kernel.org, lenb@kernel.org, 
	kevin.tian@intel.com, alex@shazbot.org, cjia@nvidia.com, kwankhede@nvidia.com, 
	targupta@nvidia.com, zhiw@nvidia.com, dnigam@nvidia.com, kjaju@nvidia.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-edac@vger.kernel.org, 
	Jonathan.Cameron@huawei.com, ira.weiny@intel.com, 
	Smita.KoralahalliChannabasappa@amd.com, u.kleine-koenig@baylibre.com, 
	peterz@infradead.org, linux-acpi@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 6u6hqcnsaxwty9mpz664ghcogj7sbpcz
X-Rspamd-Queue-Id: C2500C000C
X-Rspamd-Server: rspam09
X-HE-Tag: 1761148827-63082
X-HE-Meta: U2FsdGVkX1+5oD04PSwmy0xzmFKffJizYiQkoYnvqF/k8DK076V465b/kZ7/OWt4gOhC17ehpSykj+qoz/GbGiVP2FToF0noKq5uNHlEuhE0BY9gOaP0felhue1hPbLNCrxA8M0P03SITus3+/0v8mLjP7CxoZKsktHbvUYVIWcjAPPvU+ZHI/Tnu+bkIa5X8s0LzCem1WOv7CdAYShQ9D8zexuVZgdwYBlkSLD7/PFEGYw8tHtrF3UlP44o+3WZA6w1JospgHTg66mIimZ/b2r0k048mZ0PQ/IQLYbJOp3ZJyhK79AZ1f/yt6483Oc5u4Wfc5ERQwEfNljFc0cExCZUM/3SmVfJw3d3ld9sQKOHqvcjQp0hvV+RN9c2gV+0iki2uyXdCPTatT1Or4DEYM5I4AGvHSzIkJAC2pwO++MzttUsxE3XxY/0o60foO5tvWcrrmTArR1s+NqB38NKVgRUqtGCaoxFkZcxGRHfJOco/hQbxS0EYTqeUw9YfhPDiNXwpU4Q+TY95zpT9GyvlrteZVyN7uDc+Tdj1T/EgGVg8ArGgzkE134HlA/s0iR0525iZDB8by81c9TEJsWVL+m9XEopFS1NmFeBYfIsv/NJaVydkI6+QUaEs+tNtQHDDVXnaTSCuEz3DcVZKdHhMRcp4JBBp76E1xo/zlJOfdfVs+04FRro9nVeIWsJhkxNt5JZy94Jz2rsUwnI9zlgvd/nvGzN2fcVVaVm4kFuOJwaORdg4pLJXNUH5/+805azGMRQp4vBTP0pGDlm/a1mlGNv13zpg4DiWXyFtqhd+KWbXFfjoRyEJ7vJ9IYAMcpZwnQp3fbcVLmyBjafO4WMFFzIM2u8nSxnKTIxxTtbVtUDeV3zG1ysEVxgry/xifQy9LQE05D6jXtuLZliMAAfShKxBHuv0zbdiI+pttqLi5R/EDClgawlzOB1yjVGJ+llmB9GovULLMtCh7i3R0n
 89F16j9v
 rMhnH2B2UeGx2gji5jzQIateLeoZdjmbZqBXPSl9ApJJess6k0g+t3THPTH6YNwO0T2mfwxAkEXNQOQdV6YZWov6MxTsvo2JEuFjmi5bl2+O2PU8bpoN+1D92nFAN4+j50ZQLmUK+Q4YYily4gcSBPbkoZfvDM2iNNZPwAkIt8oNP/w/c/ZJf8hTDsX+N9pNh/CWVYIwnkLpMbj7QYKnXClvJZIehUUhDaKrv093o/+4PG27dMkRMteLAV9qFW2iA0riFpTzFpVsx4HrkCffYdxWoRumaCnq5GKCLAUQSER6rILiRPQvklq7eFhKIAx7XiY2c0MnydnnwKIUKOLgf22zngEFeEi9CUxSfm2zDh8uwchaw967IyLwh9rKwCuuHIeFRzFDLZehIdMjOHafK5PBZu1IT80HrXI7aUlRmpgFC4cyLo14ZqSO6jg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 3:23=E2=80=AFAM <ankita@nvidia.com> wrote:
>
> From: Ankit Agrawal <ankita@nvidia.com>
>
> The kernel MM currently does not handle ECC errors / poison on a memory
> region that is not backed by struct pages. If a memory region mapped
> using remap_pfn_range() for example, but not added to the kernel, MM
> will not have associated struct pages. Add a new mechanism to handle
> memory failure on such memory.
>
> Make kernel MM expose a function to allow modules managing the device
> memory to register the device memory SPA and the address space associated
> it. MM maintains this information as an interval tree. On poison, MM can
> search for the range that the poisoned PFN belong and use the address_spa=
ce
> to determine the mapping VMA.
>
> In this implementation, kernel MM follows the following sequence that is
> largely similar to the memory_failure() handler for struct page backed
> memory:
> 1. memory_failure() is triggered on reception of a poison error. An
> absence of struct page is detected and consequently memory_failure_pfn()
> is executed.
> 2. memory_failure_pfn() collects the processes mapped to the PFN.
> 3. memory_failure_pfn() sends SIGBUS to all the processes mapping the
> poisoned PFN using kill_procs().
>
> Note that there is one primary difference versus the handling of the
> poison on struct pages, which is to skip unmapping to the faulty PFN.
> This is done to handle the huge PFNMAP support added recently [1] that
> enables VM_PFNMAP vmas to map in either PMD level. Otherwise, a poison
> to a PFN would need breaking the PMD mapping into PTEs to unmap only
> the poisoned PFN. This will have a major performance impact.
>
> Link: https://lore.kernel.org/all/20240826204353.2228736-1-peterx@redhat.=
com/ [1]
>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  MAINTAINERS                    |   1 +
>  include/linux/memory-failure.h |  17 +++++
>  include/linux/mm.h             |   1 +
>  include/ras/ras_event.h        |   1 +
>  mm/Kconfig                     |   1 +
>  mm/memory-failure.c            | 128 ++++++++++++++++++++++++++++++++-
>  6 files changed, 148 insertions(+), 1 deletion(-)
>  create mode 100644 include/linux/memory-failure.h
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 520fb4e379a3..463d062d0386 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -11359,6 +11359,7 @@ M:      Miaohe Lin <linmiaohe@huawei.com>
>  R:     Naoya Horiguchi <nao.horiguchi@gmail.com>
>  L:     linux-mm@kvack.org
>  S:     Maintained
> +F:     include/linux/memory-failure.h
>  F:     mm/hwpoison-inject.c
>  F:     mm/memory-failure.c
>
> diff --git a/include/linux/memory-failure.h b/include/linux/memory-failur=
e.h
> new file mode 100644
> index 000000000000..bc326503d2d2
> --- /dev/null
> +++ b/include/linux/memory-failure.h
> @@ -0,0 +1,17 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _LINUX_MEMORY_FAILURE_H
> +#define _LINUX_MEMORY_FAILURE_H
> +
> +#include <linux/interval_tree.h>
> +
> +struct pfn_address_space;
> +
> +struct pfn_address_space {
> +       struct interval_tree_node node;
> +       struct address_space *mapping;
> +};
> +
> +int register_pfn_address_space(struct pfn_address_space *pfn_space);
> +void unregister_pfn_address_space(struct pfn_address_space *pfn_space);
> +
> +#endif /* _LINUX_MEMORY_FAILURE_H */
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 1ae97a0b8ec7..0ab4ea82ce9e 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4006,6 +4006,7 @@ enum mf_action_page_type {
>         MF_MSG_DAX,
>         MF_MSG_UNSPLIT_THP,
>         MF_MSG_ALREADY_POISONED,
> +       MF_MSG_PFN_MAP,
>         MF_MSG_UNKNOWN,
>  };
>
> diff --git a/include/ras/ras_event.h b/include/ras/ras_event.h
> index c8cd0f00c845..fecfeb7c8be7 100644
> --- a/include/ras/ras_event.h
> +++ b/include/ras/ras_event.h
> @@ -375,6 +375,7 @@ TRACE_EVENT(aer_event,
>         EM ( MF_MSG_DAX, "dax page" )                                   \
>         EM ( MF_MSG_UNSPLIT_THP, "unsplit thp" )                        \
>         EM ( MF_MSG_ALREADY_POISONED, "already poisoned" )              \
> +       EM ( MF_MSG_PFN_MAP, "non struct page pfn" )                    \
>         EMe ( MF_MSG_UNKNOWN, "unknown page" )
>
>  /*
> diff --git a/mm/Kconfig b/mm/Kconfig
> index e443fe8cd6cf..0b07219390b9 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -777,6 +777,7 @@ config MEMORY_FAILURE
>         depends on ARCH_SUPPORTS_MEMORY_FAILURE
>         bool "Enable recovery from hardware memory errors"
>         select MEMORY_ISOLATION
> +       select INTERVAL_TREE
>         select RAS
>         help
>           Enables code to recover from some memory failures on systems
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index df6ee59527dd..acfe5a9bde1d 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -38,6 +38,7 @@
>
>  #include <linux/kernel.h>
>  #include <linux/mm.h>
> +#include <linux/memory-failure.h>
>  #include <linux/page-flags.h>
>  #include <linux/sched/signal.h>
>  #include <linux/sched/task.h>
> @@ -154,6 +155,10 @@ static const struct ctl_table memory_failure_table[]=
 =3D {
>         }
>  };
>
> +static struct rb_root_cached pfn_space_itree =3D RB_ROOT_CACHED;
> +
> +static DEFINE_MUTEX(pfn_space_lock);
> +
>  /*
>   * Return values:
>   *   1:   the page is dissolved (if needed) and taken off from buddy,
> @@ -957,6 +962,7 @@ static const char * const action_page_types[] =3D {
>         [MF_MSG_DAX]                    =3D "dax page",
>         [MF_MSG_UNSPLIT_THP]            =3D "unsplit thp",
>         [MF_MSG_ALREADY_POISONED]       =3D "already poisoned page",
> +       [MF_MSG_PFN_MAP]                =3D "non struct page pfn",
>         [MF_MSG_UNKNOWN]                =3D "unknown page",
>  };
>
> @@ -1349,7 +1355,7 @@ static int action_result(unsigned long pfn, enum mf=
_action_page_type type,
>  {
>         trace_memory_failure_event(pfn, type, result);
>
> -       if (type !=3D MF_MSG_ALREADY_POISONED) {
> +       if (type !=3D MF_MSG_ALREADY_POISONED && type !=3D MF_MSG_PFN_MAP=
) {
>                 num_poisoned_pages_inc(pfn);
>                 update_per_node_mf_stats(pfn, result);
>         }
> @@ -2216,6 +2222,121 @@ static void kill_procs_now(struct page *p, unsign=
ed long pfn, int flags,
>         kill_procs(&tokill, true, pfn, flags);
>  }
>
> +int register_pfn_address_space(struct pfn_address_space *pfn_space)
> +{
> +       if (!pfn_space)
> +               return -EINVAL;
> +
> +       mutex_lock(&pfn_space_lock);
> +
> +       if (interval_tree_iter_first(&pfn_space_itree,
> +                                    pfn_space->node.start,
> +                                    pfn_space->node.last)) {
> +               mutex_unlock(&pfn_space_lock);
> +               return -EBUSY;
> +       }
> +
> +       interval_tree_insert(&pfn_space->node, &pfn_space_itree);
> +       mutex_unlock(&pfn_space_lock);
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(register_pfn_address_space);
> +
> +void unregister_pfn_address_space(struct pfn_address_space *pfn_space)
> +{
> +       if (!pfn_space)
> +               return;
> +
> +       mutex_lock(&pfn_space_lock);
> +       interval_tree_remove(&pfn_space->node, &pfn_space_itree);

IIRC removing something not in interval tree will panic kernel. If I
am not mistaken, should here do something like
interval_tree_iter_first before interval_tree_remove, to avoid
driver's ill behavior crash the system?

> +       mutex_unlock(&pfn_space_lock);
> +}
> +EXPORT_SYMBOL_GPL(unregister_pfn_address_space);
> +
> +static void add_to_kill_pfn(struct task_struct *tsk,
> +                           struct vm_area_struct *vma,
> +                           struct list_head *to_kill,
> +                           unsigned long pfn)
> +{
> +       struct to_kill *tk;
> +
> +       tk =3D kmalloc(sizeof(*tk), GFP_ATOMIC);
> +       if (!tk)
> +               return;
> +
> +       /* Check for pgoff not backed by struct page */
> +       tk->addr =3D vma_address(vma, pfn, 1);
> +       tk->size_shift =3D PAGE_SHIFT;
> +
> +       if (tk->addr =3D=3D -EFAULT)
> +               pr_info("Unable to find address %lx in %s\n",
> +                       pfn, tsk->comm);
> +
> +       get_task_struct(tsk);
> +       tk->tsk =3D tsk;
> +       list_add_tail(&tk->nd, to_kill);
> +}
> +
> +/*
> + * Collect processes when the error hit a PFN not backed by struct page.
> + */
> +static void collect_procs_pfn(struct address_space *mapping,
> +                             unsigned long pfn, struct list_head *to_kil=
l)
> +{
> +       struct vm_area_struct *vma;
> +       struct task_struct *tsk;
> +
> +       i_mmap_lock_read(mapping);
> +       rcu_read_lock();
> +       for_each_process(tsk) {
> +               struct task_struct *t =3D tsk;
> +
> +               t =3D task_early_kill(tsk, true);
> +               if (!t)
> +                       continue;
> +               vma_interval_tree_foreach(vma, &mapping->i_mmap, pfn, pfn=
) {
> +                       if (vma->vm_mm =3D=3D t->mm)
> +                               add_to_kill_pfn(t, vma, to_kill, pfn);
> +               }
> +       }
> +       rcu_read_unlock();
> +       i_mmap_unlock_read(mapping);
> +}
> +
> +static int memory_failure_pfn(unsigned long pfn, int flags)
> +{
> +       struct interval_tree_node *node;
> +       LIST_HEAD(tokill);
> +
> +       mutex_lock(&pfn_space_lock);
> +       /*
> +        * Modules registers with MM the address space mapping to the dev=
ice memory they
> +        * manage. Iterate to identify exactly which address space has ma=
pped to this
> +        * failing PFN.
> +        */
> +       for (node =3D interval_tree_iter_first(&pfn_space_itree, pfn, pfn=
); node;
> +            node =3D interval_tree_iter_next(node, pfn, pfn)) {
> +               struct pfn_address_space *pfn_space =3D
> +                       container_of(node, struct pfn_address_space, node=
);
> +
> +               collect_procs_pfn(pfn_space->mapping, pfn, &tokill);
> +       }
> +       mutex_unlock(&pfn_space_lock);
> +
> +       /*
> +        * Unlike System-RAM there is no possibility to swap in a differe=
nt
> +        * physical page at a given virtual address, so all userspace
> +        * consumption of direct PFN memory necessitates SIGBUS (i.e.
> +        * MF_MUST_KILL)
> +        */
> +       flags |=3D MF_ACTION_REQUIRED | MF_MUST_KILL;
> +
> +       kill_procs(&tokill, true, pfn, flags);
> +
> +       return action_result(pfn, MF_MSG_PFN_MAP, MF_RECOVERED);
> +}
> +
>  /**
>   * memory_failure - Handle memory failure of a page.
>   * @pfn: Page Number of the corrupted page
> @@ -2259,6 +2380,11 @@ int memory_failure(unsigned long pfn, int flags)
>         if (!(flags & MF_SW_SIMULATED))
>                 hw_memory_failure =3D true;
>
> +       if (!pfn_valid(pfn) && !arch_is_platform_page(PFN_PHYS(pfn))) {
> +               res =3D memory_failure_pfn(pfn, flags);
> +               goto unlock_mutex;
> +       }
> +
>         p =3D pfn_to_online_page(pfn);
>         if (!p) {
>                 res =3D arch_memory_failure(pfn, flags);
> --
> 2.34.1
>
>

