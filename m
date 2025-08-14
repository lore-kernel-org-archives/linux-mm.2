Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E54A6CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 08:39:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 698E3900113; Thu, 14 Aug 2025 04:39:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6708E900088; Thu, 14 Aug 2025 04:39:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 586B9900113; Thu, 14 Aug 2025 04:39:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 45FBA900088
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 04:39:21 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0ADD0140568
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 08:39:20 +0000 (UTC)
X-FDA: 83774713722.02.5046561
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4F5891C000E
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 08:39:19 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JzwSedKi;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755160759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gtesHyIGbv9kln7RB0GzCr5FxVorGkocSx8TRiQ3g2Q=;
	b=Q13TGNGzWAMrknzAzW2VeMMGoJixW9WJGFY8XM8CQqShWKL1pQQNVIBfbObx31sSMpDeOe
	dfUmEJMqQm5pPGE1g1M+lmPtsBgzrf40ZjfE0K3WsFFXeZRixarkQq2w7+CSaH9VmM10G3
	yerV5dBcbkDVBzqEfXMideZ6Il3A7Po=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JzwSedKi;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755160759; a=rsa-sha256;
	cv=none;
	b=nlq0v8kY1OLJcDWXscw0ltX4es5o/CEz8R5u7qn5yYu05QUd94Qe3PItpaPkmRY6+YODBi
	va6Osbv9AYJ56TSMIgxxqduT0NL0zBnRWv43/48knpw9BKikxm0qPH3bL4DShT7ACPt8VC
	n4fUD6WZd6nqXJAmiLoh5Tz8xLfQgn4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id D80945C61FD;
	Thu, 14 Aug 2025 08:39:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7188CC4CEF4;
	Thu, 14 Aug 2025 08:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755160756;
	bh=wfqWmiFu+hf5riWH1oiwtGbPEfN6D8DeAmej1du6BhY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JzwSedKiUIueXjAwiEvvgu9Pg7k0kNpnO8Uu4NT96uQ5AFJeZLFlxMhMYmmqQKgf9
	 vkRr6fLBH/J6KQaFSI5SL4BICjVxdtsmUGvpcNsQgVqh8n+TDsLp/ZSzZGKwJy6Vu/
	 P26Vc0ScJ0V1qyZCwGuo5A9RurBj/wQK5MgjLtYcBOlURHX9zRDDmhud/nvuI+G1Kp
	 7AR6ipV+2txrE2N62GVE5xzXojsCfMmVJMeTlKseveRHMqgGHGJeEa8Tt0gzNwMRjO
	 9krcCidK65DrhHDCRoNCXT2dOKsRCBYhgtjRqtbs1HvHnV8ajX5CJxMw/Oe6FjlzvD
	 kjMlCCcya+wJA==
Date: Thu, 14 Aug 2025 11:38:53 +0300
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
Subject: Re: [PATCH 07/10] mm: correct sign-extension issue in MMF_* flag
 masks
Message-ID: <aJ2gnTpRW3QLTcn6@kernel.org>
References: <cover.1755012943.git.lorenzo.stoakes@oracle.com>
 <f92194bee8c92a04fd4c9b2c14c7e65229639300.1755012943.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f92194bee8c92a04fd4c9b2c14c7e65229639300.1755012943.git.lorenzo.stoakes@oracle.com>
X-Rspamd-Queue-Id: 4F5891C000E
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 55uhb9d4wzyuebi8ip7rp9x3sqjq9cju
X-HE-Tag: 1755160759-351807
X-HE-Meta: U2FsdGVkX1884F/oFMFFUuhLZx9zeQpc9LgKe2QLbIM+XSBvUnD3dtkWHTR+RvLkRiA9tAbtXBC/p224/RsBjehWR6c3PoGs42mnAXfHmK2Fy0cZVxVI/WmUIsZjiLHQbVd8/6cDPqeB2nA2Y4lI/2xgp4x9WlN0XbCAtD0q1BsBiOq6YBYKLZZoEIFy9imdRi8h8yZFWKIBE5q4br6QdqjkVeIwNX6KGvssX7tZ+wMuk4twoWPhSWXU2DbEyZAdjYiIX0vfk6mksPoDLHWTItr0qEVBTvjmoIwUgllUN3j2NNMAiyb5UeJ9KM56ZkPwBh5Q7xM89ICkUIou5saqPO8WBVwUFhcgdSVG4VGxFEQ9PSPH/EZ6eLUrOj1UGy9sQ/tJs/tmE5z5pfaqTX50VVgTzCLBvK54Vi3zrWNLZLOksjZRUwLpPltvMQa5/fUTVAs3JhxkArbUiu5d8gAUEwN/Euto9SXySMlQuOw+mTgoq7ue68p1tlqz2P7H4ngBMsXJNkuc8LxCWoYfmv3gq+/WjKdUG2KGEm/o5/OpguRX4Z9/zdPjmZuuM67S+B9ZIGQjyl5pxRkooQtZXfp9654ujH9M8cWMXPO4c8x5Kv3Ege0TXdkLlgt+jozdbC7dczjbLspb6v97ZFKcgp2NbqLhBWN2whwa7Fco+MqQ0MLSKSCUaQf9l1MEfff7wxAnhaEN2uM37rNcUO3y92/a4luemCZNKhypmX7IUniE8nNGsiIgbveZUFVUsB5taXLDBZMgDXRqiAd0Xe8QZpYOj/O7GbmDcomW75vm5Ug8j1UUQdT0mWlEYyxe/L4JBC8SnFgpJDKFsBKyrJI8rK9f/tsrzeSr7iTybm0rTwdrPhnf4dKV0iSy/ZiJFFOEgqaYDhpZHz83oJTUsvMkIoTVS3DCSo6DRE9JiqOxY7j3NAHj8in+mjZzhjT3fQ7Tjm6wP91q8ewvNNyzwGclypU
 RP5dm+XG
 yuxsFnIuGMMb+dfHP18JiubvbU5HNqlVGslTrqYgzd5no4YEOJrhDIXvWZF9AgZlaDJP3kxtzYji53ciIy0TZu0+0HuaC4apW94rn03KWs5VeUmBJ9Q+BoE3gxwem5/GFqYZ1x84LE+nd98W3fJGumvG4v5Fa2UMirC01nG7ZHTztoEAgsMY3PQLTQuXhCEMMKJb3AfZ3NiHg2fT9vO5L8qvRMKXwfxxGuYDgD/y8RM40E3GMJJJaavI1xqTpiKJkdumcbKg8vd//qnn6tK95Rc/Lc2ma3QgC2EfxIsT82SDdFKhGdKFoQYqLQWPQpVRq9NAXZ85EFD8vZR5hj3k+ougHJhCALRK79jti
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 12, 2025 at 04:44:16PM +0100, Lorenzo Stoakes wrote:
> There is an issue with the mask declarations in linux/mm_types.h, which
> naively do (1 << bit) operations. Unfortunately this results in the 1 being
> defaulted as a signed (32-bit) integer.
> 
> When the compiler expands the MMF_INIT_MASK bitmask it comes up with:
> 
> (((1 << 2) - 1) | (((1 << 9) - 1) << 2) | (1 << 24) | (1 << 28) | (1 << 30)
> | (1 << 31))
> 
> Which overflows the signed integer to -788,527,105. Implicitly casting this
> to an unsigned integer results in sign-expansion, and thus this value
> becomes 0xffffffffd10007ff, rather than the intended 0xd10007ff.
> 
> While we're limited to a maximum of 32 bits in mm->flags, this isn't an
> issue as the remaining bits being masked will always be zero.
> 
> However, now we are moving towards having more bits in this flag, this
> becomes an issue.
> 
> Simply resolve this by using the _BITUL() helper to cast the shifted value
> to an unsigned long.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  include/linux/mm_types.h | 19 +++++++++----------
>  1 file changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 46d3fb8935c7..38b3fa927997 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -1756,7 +1756,7 @@ enum {
>   * the modes are SUID_DUMP_* defined in linux/sched/coredump.h
>   */
>  #define MMF_DUMPABLE_BITS 2
> -#define MMF_DUMPABLE_MASK ((1 << MMF_DUMPABLE_BITS) - 1)
> +#define MMF_DUMPABLE_MASK (_BITUL(MMF_DUMPABLE_BITS) - 1)
>  /* coredump filter bits */
>  #define MMF_DUMP_ANON_PRIVATE	2
>  #define MMF_DUMP_ANON_SHARED	3
> @@ -1771,13 +1771,13 @@ enum {
>  #define MMF_DUMP_FILTER_SHIFT	MMF_DUMPABLE_BITS
>  #define MMF_DUMP_FILTER_BITS	9
>  #define MMF_DUMP_FILTER_MASK \
> -	(((1 << MMF_DUMP_FILTER_BITS) - 1) << MMF_DUMP_FILTER_SHIFT)
> +	((_BITUL(MMF_DUMP_FILTER_BITS) - 1) << MMF_DUMP_FILTER_SHIFT)
>  #define MMF_DUMP_FILTER_DEFAULT \
> -	((1 << MMF_DUMP_ANON_PRIVATE) |	(1 << MMF_DUMP_ANON_SHARED) |\
> -	 (1 << MMF_DUMP_HUGETLB_PRIVATE) | MMF_DUMP_MASK_DEFAULT_ELF)
> +	(_BITUL(MMF_DUMP_ANON_PRIVATE) | _BITUL(MMF_DUMP_ANON_SHARED) | \
> +	 _BITUL(MMF_DUMP_HUGETLB_PRIVATE) | MMF_DUMP_MASK_DEFAULT_ELF)
>  
>  #ifdef CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS
> -# define MMF_DUMP_MASK_DEFAULT_ELF	(1 << MMF_DUMP_ELF_HEADERS)
> +# define MMF_DUMP_MASK_DEFAULT_ELF	_BITUL(MMF_DUMP_ELF_HEADERS)
>  #else
>  # define MMF_DUMP_MASK_DEFAULT_ELF	0
>  #endif
> @@ -1797,7 +1797,7 @@ enum {
>  #define MMF_UNSTABLE		22	/* mm is unstable for copy_from_user */
>  #define MMF_HUGE_ZERO_FOLIO	23      /* mm has ever used the global huge zero folio */
>  #define MMF_DISABLE_THP		24	/* disable THP for all VMAs */
> -#define MMF_DISABLE_THP_MASK	(1 << MMF_DISABLE_THP)
> +#define MMF_DISABLE_THP_MASK	_BITUL(MMF_DISABLE_THP)
>  #define MMF_OOM_REAP_QUEUED	25	/* mm was queued for oom_reaper */
>  #define MMF_MULTIPROCESS	26	/* mm is shared between processes */
>  /*
> @@ -1810,16 +1810,15 @@ enum {
>  #define MMF_HAS_PINNED		27	/* FOLL_PIN has run, never cleared */
>  
>  #define MMF_HAS_MDWE		28
> -#define MMF_HAS_MDWE_MASK	(1 << MMF_HAS_MDWE)
> -
> +#define MMF_HAS_MDWE_MASK	_BITUL(MMF_HAS_MDWE)
>  
>  #define MMF_HAS_MDWE_NO_INHERIT	29
>  
>  #define MMF_VM_MERGE_ANY	30
> -#define MMF_VM_MERGE_ANY_MASK	(1 << MMF_VM_MERGE_ANY)
> +#define MMF_VM_MERGE_ANY_MASK	_BITUL(MMF_VM_MERGE_ANY)
>  
>  #define MMF_TOPDOWN		31	/* mm searches top down by default */
> -#define MMF_TOPDOWN_MASK	(1 << MMF_TOPDOWN)
> +#define MMF_TOPDOWN_MASK	_BITUL(MMF_TOPDOWN)
>  
>  #define MMF_INIT_MASK		(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK |\
>  				 MMF_DISABLE_THP_MASK | MMF_HAS_MDWE_MASK |\
> -- 
> 2.50.1
> 

-- 
Sincerely yours,
Mike.

