Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BEF3CA0EE3
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 08:44:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FFCC900117; Thu, 14 Aug 2025 04:44:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 087D8900088; Thu, 14 Aug 2025 04:44:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE09C900117; Thu, 14 Aug 2025 04:44:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DCAFD900088
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 04:44:09 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A4A7F1DD9C2
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 08:44:09 +0000 (UTC)
X-FDA: 83774725818.18.FA954DB
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf27.hostedemail.com (Postfix) with ESMTP id 42A6840006
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 08:44:08 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nbIckPkp;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755161048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3QENViyTTvOtNfEovHZABxsa92vgM7OB+/R0ZPit8MU=;
	b=MoLfgbadx6eM+YwRw9AqFtBpEb3BS90J6EyE6jkkZYK9mo0v6uT5j50x0P4y3HRIgAk4+k
	1zKDZ1RhXFsQOxc3IhLe+SJh8yzbvmF8bMLISasvfTuEN3IfxxturxHog1mhu6d+Y5xH/J
	43mjmepzJkb8jgUr8/S1eKxiebf6JjQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nbIckPkp;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755161048; a=rsa-sha256;
	cv=none;
	b=5U+wqamIxPxaa1MNMzTUz8YnWt1maSVkayHM9Phbuk7lHWuUsuEcoewq/iye/RBo2y0mRf
	UXxGvbh570fAYCWtf11ouT1zogEKN7cvzPRkggwu9M6TVbaKUuA2kddgMnGllwODSHBOXJ
	/exQIxmEoChpO1HZju+x6zHMvA5Wzb8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 932CBA5576B;
	Thu, 14 Aug 2025 08:44:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 599B6C4CEEF;
	Thu, 14 Aug 2025 08:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755161047;
	bh=CTmqLMuj0bCvkwKZAg1Un//8JJ/uJlUZHANgFIqPtcA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nbIckPkpIEKyJ2nMayYZEQWySgIgwvq+Q87fMBsC5439jXwx7UjxtP6/3aRizI0iv
	 ijsnrrrpc8/3O6G/xs9aYaXyUBJeY0IX4fqyj3/x/rGOzs3QvqOtEfqO4IsrCj1EJJ
	 vVTmwcSsXtJ+0YCx16H+VWsKJOqsPoCy1fgAXOLlGkTP8ir2BQUm7OaO8V1W2MBlEh
	 imVNM6O/c1ae9lGeBjLpZoDfgKf1bT+2dj2T7y2GbzlYFwT1eLdqkINwalGzjVIgUn
	 KmVdVPjlyrTerI/WOq7DBLaaWbpmX/v+w8GbjVLyRf5VAICnpi3ce09BCy/VxWeJ9r
	 2nFsXdboCSbeg==
Date: Thu, 14 Aug 2025 11:43:42 +0300
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
Subject: Re: [PATCH 10/10] mm: replace mm->flags with bitmap entirely and set
 to 64 bits
Message-ID: <aJ2hvmqj-wREpqXH@kernel.org>
References: <cover.1755012943.git.lorenzo.stoakes@oracle.com>
 <e1f6654e016d36c43959764b01355736c5cbcdf8.1755012943.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e1f6654e016d36c43959764b01355736c5cbcdf8.1755012943.git.lorenzo.stoakes@oracle.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 42A6840006
X-Stat-Signature: fe8tx5f5zt6kkrj5gkz67uw1ortssiwn
X-Rspam-User: 
X-HE-Tag: 1755161048-277975
X-HE-Meta: U2FsdGVkX1+OFTg8QXH+4R9VQKVRpiKonVDKes71nEr+pPjoeSAMIJKvGO5/by2LO8HKz96Kbh9niaLaJqd/vI+5eca8gFw8RKDEkuexPhahuyjs+KlOH9NU332yG3voyx3pkBTBwK0m8RVSHA0cFgAIqsC4dGuqNc8vqxVqcrRAf5ddOps0ZMG6TTaGBFLbvGRloVMUr1uIEL16X/7S0BG/eP+sLceAUcIT+VGld7ppZvShtbcMmy/rElejdLRp2gunM24j7AvOxFSb6u/uqDPaU/pzZSsIPafm+h3m4dxPpAToOa6NCPKgiY7dbUMfR+3rp4wCjXghIcNTvkkGSyzUbEDG4nZDZXIFUcfvC2ipPhnvNiaQmFt7mOcSTvaC1fLXfEvfuymv6kwdTOXur1fCdUYup25Y9Ls5fApOW0STs/SpyjmdOzWBuigkw4BknnAVpvg75xzdKBRW+lk8e41zDhaDVXcIMnfu1gsdhLayQrPPWXtr8RSOzDN6Vz3oNuQQiKzg7vySaKJGlf//UJ18YU6xpdcZXvEmRPteCV0qq0Y1IRakY7eaeWh3/AfVV7eFpY/IoW5jluC8vdb0XvPec3H3gCnLMBEGH0K1XWjt0JHwTyDmglaBy92QulUgtw9k1DObO37ELT9HTWKxDfUdVMpHFbBoi+8dj3WJf+WHqnj3YUWYgn7/5nR7sdL+1TqyaEDvy9rP8L9pRVDchDhPYtlKlRnWTYhLCmSUwANbNmBNlc5Rx6GYscxq3jenkf7C/Z1ydeDbhOE1vyyXxqLYssSLv1j/Z9cu/7IxWyvG3JHgdqjbB03UObMDeuShrkQByYR+2SCaVieOazzR4LCYozvK6RFoVFgS0eCbwTx+2aSIfS203hTa1aXLDmaq4TH5ZtXWypS4u7GUzgWRAo+LDhLnEDCDBwSQ3JTbLzDJmwu+4kV6kZ9GVNbI2c+Cg9WjMh/GNAUGtJe8t83
 +Pg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 12, 2025 at 04:44:19PM +0100, Lorenzo Stoakes wrote:
> Now we have updated all users of mm->flags to use the bitmap accessors,
> repalce it with the bitmap version entirely.
> 
> We are then able to move to having 64 bits of mm->flags on both 32-bit and
> 64-bit architectures.
> 
> We also update the VMA userland tests to ensure that everything remains
> functional there.
> 
> No functional changes intended, other than there now being 64 bits of
> available mm_struct flags.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  include/linux/mm.h               | 12 ++++++------
>  include/linux/mm_types.h         | 14 +++++---------
>  include/linux/sched/coredump.h   |  2 +-
>  tools/testing/vma/vma_internal.h | 19 +++++++++++++++++--
>  4 files changed, 29 insertions(+), 18 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 34311ebe62cc..b61e2d4858cf 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -724,32 +724,32 @@ static inline void assert_fault_locked(struct vm_fault *vmf)
>  
>  static inline bool mm_flags_test(int flag, const struct mm_struct *mm)
>  {
> -	return test_bit(flag, ACCESS_PRIVATE(&mm->_flags, __mm_flags));
> +	return test_bit(flag, ACCESS_PRIVATE(&mm->flags, __mm_flags));
>  }
>  
>  static inline bool mm_flags_test_and_set(int flag, struct mm_struct *mm)
>  {
> -	return test_and_set_bit(flag, ACCESS_PRIVATE(&mm->_flags, __mm_flags));
> +	return test_and_set_bit(flag, ACCESS_PRIVATE(&mm->flags, __mm_flags));
>  }
>  
>  static inline bool mm_flags_test_and_clear(int flag, struct mm_struct *mm)
>  {
> -	return test_and_clear_bit(flag, ACCESS_PRIVATE(&mm->_flags, __mm_flags));
> +	return test_and_clear_bit(flag, ACCESS_PRIVATE(&mm->flags, __mm_flags));
>  }
>  
>  static inline void mm_flags_set(int flag, struct mm_struct *mm)
>  {
> -	set_bit(flag, ACCESS_PRIVATE(&mm->_flags, __mm_flags));
> +	set_bit(flag, ACCESS_PRIVATE(&mm->flags, __mm_flags));
>  }
>  
>  static inline void mm_flags_clear(int flag, struct mm_struct *mm)
>  {
> -	clear_bit(flag, ACCESS_PRIVATE(&mm->_flags, __mm_flags));
> +	clear_bit(flag, ACCESS_PRIVATE(&mm->flags, __mm_flags));
>  }
>  
>  static inline void mm_flags_clear_all(struct mm_struct *mm)
>  {
> -	bitmap_zero(ACCESS_PRIVATE(&mm->_flags, __mm_flags), NUM_MM_FLAG_BITS);
> +	bitmap_zero(ACCESS_PRIVATE(&mm->flags, __mm_flags), NUM_MM_FLAG_BITS);
>  }
>  
>  extern const struct vm_operations_struct vma_dummy_vm_ops;
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 25577ab39094..47d2e4598acd 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -932,7 +932,7 @@ struct mm_cid {
>   * Opaque type representing current mm_struct flag state. Must be accessed via
>   * mm_flags_xxx() helper functions.
>   */
> -#define NUM_MM_FLAG_BITS BITS_PER_LONG
> +#define NUM_MM_FLAG_BITS (64)
>  typedef struct {
>  	__private DECLARE_BITMAP(__mm_flags, NUM_MM_FLAG_BITS);
>  } mm_flags_t;
> @@ -1119,11 +1119,7 @@ struct mm_struct {
>  		/* Architecture-specific MM context */
>  		mm_context_t context;
>  
> -		/* Temporary union while we convert users to mm_flags_t. */
> -		union {
> -			unsigned long flags; /* Must use atomic bitops to access */
> -			mm_flags_t _flags;   /* Must use mm_flags_* helpers to access */
> -		};
> +		mm_flags_t flags; /* Must use mm_flags_* hlpers to access */
>  
>  #ifdef CONFIG_AIO
>  		spinlock_t			ioctx_lock;
> @@ -1236,7 +1232,7 @@ struct mm_struct {
>  /* Read the first system word of mm flags, non-atomically. */
>  static inline unsigned long __mm_flags_get_word(struct mm_struct *mm)
>  {
> -	unsigned long *bitmap = ACCESS_PRIVATE(&mm->_flags, __mm_flags);
> +	unsigned long *bitmap = ACCESS_PRIVATE(&mm->flags, __mm_flags);
>  
>  	return bitmap_read(bitmap, 0, BITS_PER_LONG);
>  }
> @@ -1245,7 +1241,7 @@ static inline unsigned long __mm_flags_get_word(struct mm_struct *mm)
>  static inline void __mm_flags_set_word(struct mm_struct *mm,
>  				       unsigned long value)
>  {
> -	unsigned long *bitmap = ACCESS_PRIVATE(&mm->_flags, __mm_flags);
> +	unsigned long *bitmap = ACCESS_PRIVATE(&mm->flags, __mm_flags);
>  
>  	bitmap_copy(bitmap, &value, BITS_PER_LONG);
>  }
> @@ -1253,7 +1249,7 @@ static inline void __mm_flags_set_word(struct mm_struct *mm,
>  /* Obtain a read-only view of the bitmap. */
>  static inline const unsigned long *__mm_flags_get_bitmap(const struct mm_struct *mm)
>  {
> -	return (const unsigned long *)ACCESS_PRIVATE(&mm->_flags, __mm_flags);
> +	return (const unsigned long *)ACCESS_PRIVATE(&mm->flags, __mm_flags);
>  }
>  
>  #define MM_MT_FLAGS	(MT_FLAGS_ALLOC_RANGE | MT_FLAGS_LOCK_EXTERN | \
> diff --git a/include/linux/sched/coredump.h b/include/linux/sched/coredump.h
> index 19ecfcceb27a..079ae5a97480 100644
> --- a/include/linux/sched/coredump.h
> +++ b/include/linux/sched/coredump.h
> @@ -20,7 +20,7 @@ static inline unsigned long __mm_flags_get_dumpable(struct mm_struct *mm)
>  
>  static inline void __mm_flags_set_mask_dumpable(struct mm_struct *mm, int value)
>  {
> -	unsigned long *bitmap = ACCESS_PRIVATE(&mm->_flags, __mm_flags);
> +	unsigned long *bitmap = ACCESS_PRIVATE(&mm->flags, __mm_flags);
>  
>  	set_mask_bits(bitmap, MMF_DUMPABLE_MASK, value);
>  }
> diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
> index cb1c2a8afe26..f13354bf0a1e 100644
> --- a/tools/testing/vma/vma_internal.h
> +++ b/tools/testing/vma/vma_internal.h
> @@ -249,6 +249,14 @@ struct mutex {};
>  #define DEFINE_MUTEX(mutexname) \
>  	struct mutex mutexname = {}
>  
> +#define DECLARE_BITMAP(name, bits) \
> +	unsigned long name[BITS_TO_LONGS(bits)]
> +
> +#define NUM_MM_FLAG_BITS (64)
> +typedef struct {
> +	__private DECLARE_BITMAP(__mm_flags, NUM_MM_FLAG_BITS);
> +} mm_flags_t;
> +
>  struct mm_struct {
>  	struct maple_tree mm_mt;
>  	int map_count;			/* number of VMAs */
> @@ -260,7 +268,7 @@ struct mm_struct {
>  
>  	unsigned long def_flags;
>  
> -	unsigned long flags; /* Must use atomic bitops to access */
> +	mm_flags_t flags; /* Must use mm_flags_* helpers to access */
>  };
>  
>  struct vm_area_struct;
> @@ -1333,6 +1341,13 @@ static inline void userfaultfd_unmap_complete(struct mm_struct *mm,
>  {
>  }
>  
> +# define ACCESS_PRIVATE(p, member) ((p)->member)
> +
> +static inline bool mm_flags_test(int flag, const struct mm_struct *mm)
> +{
> +	return test_bit(flag, ACCESS_PRIVATE(&mm->flags, __mm_flags));
> +}
> +
>  /*
>   * Denies creating a writable executable mapping or gaining executable permissions.
>   *
> @@ -1363,7 +1378,7 @@ static inline void userfaultfd_unmap_complete(struct mm_struct *mm,
>  static inline bool map_deny_write_exec(unsigned long old, unsigned long new)
>  {
>  	/* If MDWE is disabled, we have nothing to deny. */
> -	if (!test_bit(MMF_HAS_MDWE, &current->mm->flags))
> +	if (mm_flags_test(MMF_HAS_MDWE, current->mm))
>  		return false;
>  
>  	/* If the new VMA is not executable, we have nothing to deny. */
> -- 
> 2.50.1
> 

-- 
Sincerely yours,
Mike.

