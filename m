Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CC0ECA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 08:40:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1E5D900114; Thu, 14 Aug 2025 04:40:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F590900088; Thu, 14 Aug 2025 04:40:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90BF7900114; Thu, 14 Aug 2025 04:40:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7CD45900088
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 04:40:24 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 084F1160574
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 08:40:24 +0000 (UTC)
X-FDA: 83774716368.12.39E4606
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf05.hostedemail.com (Postfix) with ESMTP id 674F810000D
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 08:40:22 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZZ5tqXiS;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755160822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ALAQ1hCCvfMNneTPSDmW2WXC/XQXQuv7liTcDor4eJI=;
	b=Xejzy4iP/x6ePQVQv9N3N9MqsVrOSEPCt3j40WLES2sUDg5wIambQrKja5X6VfX2bAVUXa
	6PkdG7lIC0tYP0kThKT2B8qPa+8CcvitAHUDmfdr5HiO4thLNHmt672UmGyo42LRcn9rDH
	KBdNVAarx8efCr4W/lmm9qhuS7BUhxo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755160822; a=rsa-sha256;
	cv=none;
	b=bHNZd7hZ5EyfrL2NnYjps8Gvumhp1Bjx/FTYLZyE5k8jVSFJpDxn2pIfmRHVXINRfSXrPX
	trBVsmNH/LwInIHInNrVTMg8t5sUJfFLshtf+22M6CvrAY9VQnGXhN4lxDgpOdRLVDOLO/
	RE3ussPF/1Y6vlavfEK8SZMttW9F9qY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZZ5tqXiS;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id AB33DA5576B;
	Thu, 14 Aug 2025 08:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FC94C4AF09;
	Thu, 14 Aug 2025 08:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755160821;
	bh=zqmt4Jj8Tl4AG5pUIufRcdzVJq4JYdl8O/zAhI2YC70=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZZ5tqXiSOEwYFaq79WS5EhkFn8Z5imGYNmIePfhjJTAhyZJEgDA7Bwly8nCqYBrRu
	 d5UBO0ASyeI4lggmFmZP5Ii3320gaokMa2FN+oxetsh12TTGQ+8oWdtIFgLAmFwDa8
	 JmyiIhU5NvRChb93aRk4sfsoi6H8QvZGvsj0WePGnaiA2KQ0/+8V6zFvTPRMYPKrqn
	 1S4BU4qOOBW810STnQ9C/RqF+W8yGtXS38JRPzp9ypmj54uCmkS4f0kA57Jmi573iT
	 nQhBwXuhJUpx99j/CnWWG20Qpb4JWWkPn9hA8ESGXnWKA625fvfdzX3MjXix2LjKhh
	 b4YJ1g7zPit1g==
Date: Thu, 14 Aug 2025 11:39:57 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	"David S . Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Kees Cook <kees@kernel.org>, David Hildenbrand <david@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Matthew Wilcox <willy@infradead.org>,
	Mateusz Guzik <mjguzik@gmail.com>, linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org
Subject: Re: [PATCH 08/10] mm: update fork mm->flags initialisation to use
 bitmap
Message-ID: <aJ2g3VODv5Fp9aQL@kernel.org>
References: <cover.1755012943.git.lorenzo.stoakes@oracle.com>
 <9fb8954a7a0f0184f012a8e66f8565bcbab014ba.1755012943.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9fb8954a7a0f0184f012a8e66f8565bcbab014ba.1755012943.git.lorenzo.stoakes@oracle.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 674F810000D
X-Stat-Signature: unu9t9c3hpynqps4bodudk9kr69y6kaw
X-HE-Tag: 1755160822-347243
X-HE-Meta: U2FsdGVkX18J7Tv4XS7ZDQboitu7uR7X2W13wtLm3qZ58j5bUddq21lhGR8vsgnGSUWL6XkO1Kc24Tadr/t2kzAgN0HC3EMAaZm4lTkbGmsLMCwN8iRkT8NgiELKd+ymbvbFjxPimH6Vp2Rte+Y0Xco4Ezfyz31du1HD+F6VtWwyoDcxXVIjcgyUTp6CXpkwlqMwyzxPHGR5e4OrUEktEIGgrvx2UK1r4kYwUpLD9VeAchNRNM/7Mw0vqJRj3K5YTfLjVEIkocv+IQvDHK1lXXtmW8+4ZKkZEDYzJGkP3dSGaQnTtL/1+HdWC6fmivoAcoSK0943vcWHP6JhqhB+bOcR0dp25FJC2AaIsRmRrtF5jegpqNmaOijy3i19ReTiSjjaKccizn7ho/zLo4LVYdwaz1/lV4wvEPFwikOqVacUBrxmLggx7rGdCEyUnitEgcs6vsq8pJHc4vJQnFDaSkrhmOlqPhcJa2FzvJgyWJ7l6aAXJrVy+B1sJUJQaYSeXoDN4lR/r9rpGVgeO3vjCR5gmEZSQYrfmXM0/0NLNcYtRuq9eliyTN/MQREOqEYFs166fz9idkZadgEc+8esRicBr810/z6XC84iCDT9TBjSUMmrEDnVu1TG9pyqTeaKijg6zHSyScwA9CYElBDSly7KXtmD5ZMUTnpv7sXK8eROBzOp1a8fhs4R+jqN0Co3VvFp76D+nw9fmr6/QeByi5A7atyj/XoX83w+ZLJbHE4ysjbCbpvmVM6cLdpSobyFxFTOzJOiJNHmmIQcPzV+WNCiHNkbi3INy87ExDs0o4XGaVpdk300Sp5iw5A9/K9AlQdv0mZiO+dufiZ5bCAbLWSOoGg2VuxagchzRZgBC+SGjQDOup4NBXYRQOrWN9KqmlPfzL6SQvp/5eTE8ND3Nz25DiUGhjQm04U93hJq9zal9HrmkQzBBDyWUHxhuXUKQW0TmylnmIpew9461T8
 HNctoFCu
 zoaVkTmdUc5Ia5J3Yibu7fu3a3bb02NbR69AXdqAEzJJcWNKkkPdHn7ZuhA1OvrPvIwnzKCX9Nr0/bUFeIy5vTQ54724VfWDQErGM3dzRQMhgwkBP2z4KW7RMDEkH4hEcb2t1pK4CZxCvl29Q3J0ke0tXQbfzYVdWe4Rnzv/C2DxnqRjmc200ZnMXSI6JamdpAOCKic6RaHKz2hqLV5HADq6ilEUg2TcYw3rQI2tKztjCP+DaKcOSgBJPTHjWduLBpJogAmE/2f1DxJ66Lcu9yjQjxn0mVfsvLtlUIJ+slAuuXs4xCVamaiQeqj3LVR9ZCZiHV/E8KhS+RSU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 12, 2025 at 04:44:17PM +0100, Lorenzo Stoakes wrote:
> We now need to account for flag initialisation on fork. We retain the
> existing logic as much as we can, but dub the existing flag mask legacy.
> 
> These flags are therefore required to fit in the first 32-bits of the flags
> field.
> 
> However, further flag propagation upon fork can be implemented in mm_init()
> on a per-flag basis.
> 
> We ensure we clear the entire bitmap prior to setting it, and use
> __mm_flags_get_word() and __mm_flags_set_word() to manipulate these legacy
> fields efficiently.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  include/linux/mm_types.h | 13 ++++++++++---
>  kernel/fork.c            |  7 +++++--
>  2 files changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 38b3fa927997..25577ab39094 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -1820,16 +1820,23 @@ enum {
>  #define MMF_TOPDOWN		31	/* mm searches top down by default */
>  #define MMF_TOPDOWN_MASK	_BITUL(MMF_TOPDOWN)
>  
> -#define MMF_INIT_MASK		(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK |\
> +#define MMF_INIT_LEGACY_MASK	(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK |\
>  				 MMF_DISABLE_THP_MASK | MMF_HAS_MDWE_MASK |\
>  				 MMF_VM_MERGE_ANY_MASK | MMF_TOPDOWN_MASK)
>  
> -static inline unsigned long mmf_init_flags(unsigned long flags)
> +/* Legacy flags must fit within 32 bits. */
> +static_assert((u64)MMF_INIT_LEGACY_MASK <= (u64)UINT_MAX);
> +
> +/*
> + * Initialise legacy flags according to masks, propagating selected flags on
> + * fork. Further flag manipulation can be performed by the caller.
> + */
> +static inline unsigned long mmf_init_legacy_flags(unsigned long flags)
>  {
>  	if (flags & (1UL << MMF_HAS_MDWE_NO_INHERIT))
>  		flags &= ~((1UL << MMF_HAS_MDWE) |
>  			   (1UL << MMF_HAS_MDWE_NO_INHERIT));
> -	return flags & MMF_INIT_MASK;
> +	return flags & MMF_INIT_LEGACY_MASK;
>  }
>  
>  #endif /* _LINUX_MM_TYPES_H */
> diff --git a/kernel/fork.c b/kernel/fork.c
> index c4ada32598bd..b311caec6419 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1056,11 +1056,14 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
>  	mm_init_uprobes_state(mm);
>  	hugetlb_count_init(mm);
>  
> +	mm_flags_clear_all(mm);
>  	if (current->mm) {
> -		mm->flags = mmf_init_flags(current->mm->flags);
> +		unsigned long flags = __mm_flags_get_word(current->mm);
> +
> +		__mm_flags_set_word(mm, mmf_init_legacy_flags(flags));
>  		mm->def_flags = current->mm->def_flags & VM_INIT_DEF_MASK;
>  	} else {
> -		mm->flags = default_dump_filter;
> +		__mm_flags_set_word(mm, default_dump_filter);
>  		mm->def_flags = 0;
>  	}
>  
> -- 
> 2.50.1
> 

-- 
Sincerely yours,
Mike.

