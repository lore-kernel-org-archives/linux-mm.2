Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85F5DCCF9EE
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 19:02:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E05D68E00D0; Wed, 29 Oct 2025 15:02:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB62A8E00B2; Wed, 29 Oct 2025 15:02:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7DF68E00D0; Wed, 29 Oct 2025 15:02:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B225A8E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:02:33 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5E5605B1CE
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 19:02:33 +0000 (UTC)
X-FDA: 84052072986.18.6A3AC71
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf28.hostedemail.com (Postfix) with ESMTP id 42CF1C000F
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 19:02:31 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=fBPjPg2r;
	spf=pass (imf28.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.174 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761764551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6sw72SXv9wDgu6p9YjUITDDH7nA95nOzLTT0dvLDWRw=;
	b=Uc3wdA08+VcIPzXr6gKQlP3DxKEKLyOB9GdfZMeUtcV/xUiGY/HGQzqpQ8JU3hwATuveoy
	eJwu+bga+x/BBqEv/pSf+d/5V3Ktr7x3eN/uZiX+irsqDupbTWRPoBk7bs57eYkUOM00xa
	KcoFkCPIuj3e8vGCQ6CSEULiduT8aDo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=fBPjPg2r;
	spf=pass (imf28.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.174 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761764551; a=rsa-sha256;
	cv=none;
	b=vwbdxLR3OIIYM/xQxV/8Ui4Zv8Js+0H39OETqPMtnomlM7v5lPi9TqsRwSR7WYK44J5VMq
	VXDw8h6Zh6JaGNiN7onfjrWCZbdZAEUQQABFb67so2gWT/1zzDWJCY2flYGLUvnHu4xyA/
	InSlMn896H5u6uACIWQhpyK7Mixw67k=
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-7f04816589bso16420285a.3
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 12:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1761764550; x=1762369350; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6sw72SXv9wDgu6p9YjUITDDH7nA95nOzLTT0dvLDWRw=;
        b=fBPjPg2rsOQ0vJyc+A8pehFLXf1Eqp/sSUgA5SXm8fm/dnNx8Fa+8PwxWpSBk/ElCY
         iA0FKXSArF1yZW27shdLq4fAnjKmRnoWdHQOqz8Zl8q3VheVp8WjLNxrep2oy2sSCG/+
         6e8y+4+oxI6f+VHDjfSIm8sIpnUmotMWyTVfI/jUH/Lt7Pqb1CMjS21YkRbi8V2JRAs1
         nFdHsWykqY0vIwT8q3++Yk3Tnd+vckQMl+n0IeMg5ERtERiZak6lGCrVzNdJpJ+GC/dV
         RsNrBYawIpi3uvSuY6oiaUvsX+ApiCFlVEmBndCK0XPq4va1GvM57AeLkjVx60YVBtV7
         8HSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761764550; x=1762369350;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6sw72SXv9wDgu6p9YjUITDDH7nA95nOzLTT0dvLDWRw=;
        b=iATGreZw7yxvGyNp248k0V3N0VGjzev/sfJX0/NfqVpPniIYsBX9KcpVgwnR2uatlo
         2LOLxir11ekRIHN5kZDa5qWB0oyXO6JatGYpHfaeBLxjq3dj/KlegkRW8G9AT3pf5E1p
         kB7rsqP5Fuf+m1dyaJDIw7TrcoXJZLbkMFHg+9YjSJuGr0LwWo14aZ8O4YVTpgN26SV8
         qXte11PugSsd5dl90GaWgCPD9lp2MAzRqnlWk6CxF3+ePr2amDrM7Ni2A8DlqtInB7BD
         pGHaWnOwzvWRMtg9F07v6liZMKn+U5W86IuSqtKHiRKzAsPDc1PdQp8WqBdMDSsymxKY
         W4rA==
X-Forwarded-Encrypted: i=1; AJvYcCXL1oefQvrHvBMuJHmAWyXtyZ6QWt21weLCDLtbIPlWxKCxuOWitsUX4kRdq/6lwIX6QNw3jdVXRg==@kvack.org
X-Gm-Message-State: AOJu0YyFh77TL6igqK2fLCyc6dSDgPKcPsA1J+QGkVKu2uTioA7mXxiG
	Vn7PpEGoU+wh5SsAQl2E+M8gJzAaHIfqPqiMyIFnpBPzvSyuWWlgq2ZsA5ceRcKAUYc=
X-Gm-Gg: ASbGncvWv6nVgqP0KeV8MtVLdS4uy38wvVUwff4zgWfIxJmuI61E9UyOFg3X/YiE573
	6UxOOHq4RkZ5jRIlYtmheyxCcCInkyaDyk3PKb1sTGKjLVmvwr8w+2Esli7KvbZpvM+S05bNdZ6
	snbU/CQtIm0AXAg73GJzc1Src93OKjETP71yM0LCeAmWAEtf+GvS1cwa5Af13Z1qjFVQyxYfoJo
	Z/+Qm1An0BGOx+YWaoOt0FlY+DeCJdSL2qxk/E6VHULVjK7CsqvAS5xvH0/ku/OtwqXUvPYshAP
	fPp4Z9x19PuK32eJNlftZHAaiz7n53l3sCOu4pCf/stqt/yJUwS5rdq6DtW4UpNLHk8isM+1hlb
	5icSmZECuiJuFENQEwLbMXmx+UzEwNh8cfSc9B/GroHkwDnHM/lphzSVQxhFFpCSLvTzASWHLEv
	R0LLj7qqMZFA3PzqCP1MQBtLSd3v7L4MtyX+r+YkY9LqVxfg==
X-Google-Smtp-Source: AGHT+IFEZVVWBSeU6miQg9ukzVA2Omdwgy9xE3uJN2mdElXkmiiS2fX8FwhQFoumPSYknIKRu1v6vg==
X-Received: by 2002:a05:620a:2915:b0:8a2:234a:17be with SMTP id af79cd13be357-8aa2c08ed8emr119910685a.7.1761764549800;
        Wed, 29 Oct 2025 12:02:29 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-89f254a6461sm1145536585a.30.2025.10.29.12.02.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 12:02:29 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vEBRE-000000051Qy-2L0s;
	Wed, 29 Oct 2025 16:02:28 -0300
Date: Wed, 29 Oct 2025 16:02:28 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@redhat.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Peter Xu <peterx@redhat.com>, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Kees Cook <kees@kernel.org>, Matthew Wilcox <willy@infradead.org>,
	John Hubbard <jhubbard@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Jann Horn <jannh@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Rientjes <rientjes@google.com>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/4] mm: declare VMA flags by bit
Message-ID: <20251029190228.GS760669@ziepe.ca>
References: <cover.1761757731.git.lorenzo.stoakes@oracle.com>
 <a94b3842778068c408758686fbb5adcb91bdbc3c.1761757731.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a94b3842778068c408758686fbb5adcb91bdbc3c.1761757731.git.lorenzo.stoakes@oracle.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 42CF1C000F
X-Stat-Signature: 1ny5jkpeduunxbs6hfyui5ctsknuq4kc
X-Rspam-User: 
X-HE-Tag: 1761764551-825747
X-HE-Meta: U2FsdGVkX1+WhShOeFzYPqqUMRI0TZgCYuZORX/f8+Kr2dUPQiakOYObB1+E1tX5NT2znrLTgDaOXQ8L5J5IXo65gXkB0yRUc7Hzgf8B4kucX5gTGxQY3igyCDN2gZ9vKNEp8p4cFdg0DrlCPDUMOEv4Cr27ehuOztSnRhfGSo6jNawX/KSdN7vJmlEGH/yZCslFoO8roY1uSWNLsGuX7uQsfRqKAobyregQJB4xU8ZPx/DIaJdIXpBQ0BYI3Zzlane5Mqi1JlvMk9O6t3JigRAMYAn36XWwC6ZLHlt8ZZwMeep8xmrOaEOfDkbByaXMCIe7HZQkLv4cpZej3Z45m+UJG+LEBvQ8CFTg5juVnDV5MZ2u7iNkJdimF7e+jQkHJW+8UDlcegD2epv3Pb9G26ez8CK9Z8rn3T0AhPgcfBmkw6M3EhVtrFGAjA+wC8tzVBz4gfSzuVTLYCKV8qWkkAWocv7wbPG5S4ajm8k/AkzjMcXfTkkaDYnkSlL0AoDkjOaK5sIpYVp4xOliZaBaP+X2C1IyRVTCFMyA9ydrk15YCNJT2epqmMEQd4aOLlm7BWnUuTwUZMkbtTZanQWGarrYtvK/4E0+WkqPEg/+BSqPpsImMMAQhePxsxhWqjlRlIIyKkpJMGXFF88TOEs2UjAa0/QBP/AZWT/HVu58ouE1WtLaB6Rj7y8zyPlbJnlmE2atRPKVsxI/pBShJ8itk3qpcFv9cLmyCl4uF11Nh3PK93cEebmHwmjm2UImliodbc1e2/rxnzxr6hcVS6cA+zXDjti9ENDp8A30iU0Pwt++9aHG+1PuVQdqkcYag9VdoVYi6DzJFk1ik5yfr+8wLTF6/zdp/P2RL0JAdEk8QD1pQnE77bWblz8vH3SybLKqVEYCMkAGNyq0Z9KEjo52/CRmjw8Ra7T/WrSo1xaROtgrhgIpbN9uo5hqnIo1TfqDOOtXNekHHbWeraoPfmA
 aB59ubUX
 8kJJ5Q0I8C57KiRSQ4W1x9yyOoahUnvTpfA94XkbUfDDYz4K/tRpG2pn2InsgTX2PQEtACed9pn9pYzvkSrXstPlMzymuG85hX9MH1Cu+5bNqvhvcW8UJvpm1IJRvcYypv9sLV4EIcrfe1GnM5VdyroNozHqWzbLUIq2ux/aXPmRPAg4EMoTI9gpN0nEwYkJYLsMfLgk8kPAYnXq6UOO/UMUVkJgVVMN00jijeOis5iMUkmhvt7b2dXio8HErZojcKks0hMdhVZCDoVGYd2Lx9J0xsh2PSqXrYlneO7c/vAQHDsqLxq3RKbaaXyC85lmLgMr+X1hE4xiLIaMj7MD933jf208n4ZsGEmtpJincA015ejwo9U3YlteeZlZ1qBMrVwLh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 05:49:35PM +0000, Lorenzo Stoakes wrote:
> We declare a sparse-bitwise type vma_flag_t which ensures that users can't
> pass around invalid VMA flags by accident and prepares for future work
> towards VMA flags being a bitmap where we want to ensure bit values are
> type safe.

Does sparse attach the type to the enum item? Normal C says the enum
item's type is always 'int' if the value fits in int..

And I'm not sure bitwise rules work quite the way you'd like for this
enum, it was ment for things that are |'d..

I have seen an agressively abuse-resistent technique before, I don't
really recommend it, but FYI:

struct vma_bits {
  u8 VMA_READ_BIT;
  u8 VMA_WRITE_BIT;
  ..
};
#define VMA_BIT(bit_name) BIT(offsetof(struct vma_bits, bit_name))

> Finally, we have to update some rather silly if-deffery found in
> mm/task_mmu.c which would otherwise break.
> 
> Additionally, update the VMA userland testing vma_internal.h header to
> include these changes.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>  fs/proc/task_mmu.c               |   4 +-
>  include/linux/mm.h               | 286 +++++++++++++++++---------
>  tools/testing/vma/vma_internal.h | 341 +++++++++++++++++++++++++++----

Maybe take the moment to put them in some vma_flags.h and then can
that be included from tools/testing to avoid this copying??

> +/**
> + * vma_flag_t - specifies an individual VMA flag by bit number.
> + *
> + * This value is made type safe by sparse to avoid passing invalid flag values
> + * around.
> + */
> +typedef int __bitwise vma_flag_t;
> +
> +enum {
> +	/* currently active flags */
> +	VMA_READ_BIT = (__force vma_flag_t)0,
> +	VMA_WRITE_BIT = (__force vma_flag_t)1,
> +	VMA_EXEC_BIT = (__force vma_flag_t)2,
> +	VMA_SHARED_BIT = (__force vma_flag_t)3,
> +
> +	/* mprotect() hardcodes VM_MAYREAD >> 4 == VM_READ, and so for r/w/x bits. */
> +	VMA_MAYREAD_BIT = (__force vma_flag_t)4, /* limits for mprotect() etc */
> +	VMA_MAYWRITE_BIT = (__force vma_flag_t)5,
> +	VMA_MAYEXEC_BIT = (__force vma_flag_t)6,
> +	VMA_MAYSHARE_BIT = (__force vma_flag_t)7,
> +
> +	VMA_GROWSDOWN_BIT = (__force vma_flag_t)8, /* general info on the segment */
> +#ifdef CONFIG_MMU
> +	VMA_UFFD_MISSING_BIT = (__force vma_flag_t)9, /* missing pages tracking */
> +#else
> +	/* nommu: R/O MAP_PRIVATE mapping that might overlay a file mapping */
> +	VMA_MAYOVERLAY_BIT = (__force vma_flag_t)9,
> +#endif
> +	/* Page-ranges managed without "struct page", just pure PFN */
> +	VMA_PFNMAP_BIT = (__force vma_flag_t)10,
> +
> +	VMA_MAYBE_GUARD_BIT = (__force vma_flag_t)11,
> +
> +	VMA_UFFD_WP_BIT = (__force vma_flag_t)12, /* wrprotect pages tracking */
> +
> +	VMA_LOCKED_BIT = (__force vma_flag_t)13,
> +	VMA_IO_BIT = (__force vma_flag_t)14, /* Memory mapped I/O or similar */
> +
> +	/* Used by madvise() */
> +	VMA_SEQ_READ_BIT = (__force vma_flag_t)15, /* App will access data sequentially */
> +	VMA_RAND_READ_BIT = (__force vma_flag_t)16, /* App will not benefit from clustered reads */
> +
> +	VMA_DONTCOPY_BIT = (__force vma_flag_t)17, /* Do not copy this vma on fork */
> +	VMA_DONTEXPAND_BIT = (__force vma_flag_t)18, /* Cannot expand with mremap() */
> +	VMA_LOCKONFAULT_BIT = (__force vma_flag_t)19, /* Lock pages covered when faulted in */
> +	VMA_ACCOUNT_BIT = (__force vma_flag_t)20, /* Is a VM accounted object */
> +	VMA_NORESERVE_BIT = (__force vma_flag_t)21, /* should the VM suppress accounting */
> +	VMA_HUGETLB_BIT = (__force vma_flag_t)22, /* Huge TLB Page VM */
> +	VMA_SYNC_BIT = (__force vma_flag_t)23, /* Synchronous page faults */
> +	VMA_ARCH_1_BIT = (__force vma_flag_t)24, /* Architecture-specific flag */
> +	VMA_WIPEONFORK_BIT = (__force vma_flag_t)25, /* Wipe VMA contents in child. */
> +	VMA_DONTDUMP_BIT = (__force vma_flag_t)26, /* Do not include in the core dump */
> +
> +#ifdef CONFIG_MEM_SOFT_DIRTY
> +	VMA_SOFTDIRTY_BIT = (__force vma_flag_t)27, /* Not soft dirty clean area */
> +#endif
> +
> +	VMA_MIXEDMAP_BIT = (__force vma_flag_t)28, /* Can contain struct page and pure PFN pages */
> +	VMA_HUGEPAGE_BIT = (__force vma_flag_t)29, /* MADV_HUGEPAGE marked this vma */
> +	VMA_NOHUGEPAGE_BIT = (__force vma_flag_t)30, /* MADV_NOHUGEPAGE marked this vma */
> +	VMA_MERGEABLE_BIT = (__force vma_flag_t)31, /* KSM may merge identical pages */
> +
> +#ifdef CONFIG_64BIT
> +	/* These bits are reused, we define specific uses below. */
> +#ifdef CONFIG_ARCH_USES_HIGH_VMA_FLAGS
> +	VMA_HIGH_ARCH_0_BIT = (__force vma_flag_t)32,
> +	VMA_HIGH_ARCH_1_BIT = (__force vma_flag_t)33,
> +	VMA_HIGH_ARCH_2_BIT = (__force vma_flag_t)34,
> +	VMA_HIGH_ARCH_3_BIT = (__force vma_flag_t)35,
> +	VMA_HIGH_ARCH_4_BIT = (__force vma_flag_t)36,
> +	VMA_HIGH_ARCH_5_BIT = (__force vma_flag_t)37,
> +	VMA_HIGH_ARCH_6_BIT = (__force vma_flag_t)38,
> +#endif
> +
> +	VMA_ALLOW_ANY_UNCACHED_BIT = (__force vma_flag_t)39,
> +	VMA_DROPPABLE_BIT = (__force vma_flag_t)40,
> +
> +#ifdef CONFIG_HAVE_ARCH_USERFAULTFD_MINOR
> +	VMA_UFFD_MINOR_BIT = (__force vma_flag_t)41,
> +#endif
> +
> +	VMA_SEALED_BIT = (__force vma_flag_t)42,
> +#endif /* CONFIG_64BIT */
> +};
> +
> +#define VMA_BIT(bit)	BIT((__force int)bit)

> -/* mprotect() hardcodes VM_MAYREAD >> 4 == VM_READ, and so for r/w/x bits. */
> -#define VM_MAYREAD	0x00000010	/* limits for mprotect() etc */
> -#define VM_MAYWRITE	0x00000020
> -#define VM_MAYEXEC	0x00000040
> -#define VM_MAYSHARE	0x00000080
> +#define VM_MAYREAD	VMA_BIT(VMA_MAYREAD_BIT)
> +#define VM_MAYWRITE	VMA_BIT(VMA_MAYWRITE_BIT)
> +#define VM_MAYEXEC	VMA_BIT(VMA_MAYEXEC_BIT)
> +#define VM_MAYSHARE	VMA_BIT(VMA_MAYSHARE_BIT)

I suggest removing some of this duplication..

#define DECLARE_VMA_BIT(name, bitno) \
    NAME ## _BIT = (__force vma_flag_t)bitno,
    NAME = BIT(bitno),

enum {
   DECLARE_VMA_BIT(VMA_READ, 0),
}

Especially since the #defines and enum need to have matching #ifdefs.

It is OK to abuse the enum like the above, C won't get mad and works
better in gdb/clangd.

Later you can have a variation of the macro for your first sytem
word/second system word idea.

Otherwise I think this is a great thing to do, thanks!

Jason

