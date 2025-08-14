Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02ECECA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 08:31:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9948E900110; Thu, 14 Aug 2025 04:31:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91DF5900088; Thu, 14 Aug 2025 04:31:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80D66900110; Thu, 14 Aug 2025 04:31:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6BEFE900088
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 04:31:17 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DA72616054C
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 08:31:16 +0000 (UTC)
X-FDA: 83774693352.10.A87B6AA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5BE29100005
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 08:31:15 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AX8cNCfp;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755160275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3kkoC+9K6leAmPMFEfAsksAWG+4P7KDqYhIP4QTY7yQ=;
	b=iekkhwHSbDJ0Ue2ETvX0stU01OTWF1t3wJeZ5y3vQHnRCEpPdTCSbpqTkaUazPQxNsd7De
	EkB+VdWJpsTlZldy0OYa/o4cakSKo5ijI3fFLyKZuEsc32rl0woVwm9eUpFuB+71R43/Z2
	45U6djbfpouf+V315vid3/i+AIEIKjk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AX8cNCfp;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755160275; a=rsa-sha256;
	cv=none;
	b=kH198vM1NaTzflWywOSI8MQFjLqpEpzxDTP7vxOd5SOUGkjhDtZETW4H1WWT40PJugnkXS
	/jIEVVwWCNn3rBwN0Dpbgjs8OE1fn2bz3Sgg/0GRnlspR5brsDOIgkzbqueV2D/EdXR1WI
	HZCAesxzEV9kYfIEu+HSeG8cFJbvAXQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AAAAF60209;
	Thu, 14 Aug 2025 08:31:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC3ABC4CEEF;
	Thu, 14 Aug 2025 08:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755160274;
	bh=VZwAT4nuFzlo6iiZ+ZB4KjdwEiWrPMXFBSLlSlymS54=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AX8cNCfpn1HESKoFuAmO+ofK0K08xD2ds6IMbbIAyUZ5G1opIHUqO/jfh0dnqTs1L
	 i+9/9TDQqyuA59+2NNHVDTjjgM3kATsYfk15tvQgNWNLysM5awURk6yWoFT7xQc8Gk
	 FaNfrd36A6c6CWsrMpb/KjIez7XstJ11dFK4CBHKy63X9yPF4p86KG7u/aWQt9onHW
	 cODXDHoRGXmI2Xv/sApKf6oi2erN4CbM0DD8DpC72SsJdg5XdCkoeGqdAGzN9pK35k
	 q4EpVl+/BsX4Pl1c9wfcSUumLoc2uJ8YjQVtcbpPVBRa/degA6woRCYDWZP+OL5XKt
	 6xP2evtyLgaAQ==
Date: Thu, 14 Aug 2025 11:30:51 +0300
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
Subject: Re: [PATCH 04/10] mm: convert arch-specific code to mm_flags_*()
 accessors
Message-ID: <aJ2eu1qv1KkUsSbL@kernel.org>
References: <cover.1755012943.git.lorenzo.stoakes@oracle.com>
 <6e0a4563fcade8678d0fc99859b3998d4354e82f.1755012943.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e0a4563fcade8678d0fc99859b3998d4354e82f.1755012943.git.lorenzo.stoakes@oracle.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5BE29100005
X-Stat-Signature: 7y6s9sht4z3kxddthiai8zqadr373z8y
X-Rspam-User: 
X-HE-Tag: 1755160275-181480
X-HE-Meta: U2FsdGVkX19Iufddb3Rd53DMuuCQyMXr/qJeceFFWt5J7F9afKfUX94FU77UqXDehF01NwBes6yW4XtwgaRVHX6KkoKRLRodn3UE5UObZS3BqHszR4UuIxsaQyZpnB0Wp6TJu4iV3tg1upwapwhHQGaXwhqDR9+qAJWdJrpl4H6o97RpnexYli3brI+LKNBj7TzhmxeBF6t6J3bKZ5AS9/DEdEiNe4i84YIFKszFqtgAb2T9bIsYR2vm225cdyBVXYdBQfunFDhLolqs03IO3pdFTD2NJx1ixwOVYpYjsWUTWOLfb5kqMnSf6yDHtnDyk/5RK7be5VLX4lIIxUVvw5pB4ZqjJUiPwOyvOtvIie4Yndtqd8DgRb+ErxQ8zK2Dt3RNmlivPCbXeYuu2W9x96ABVc3LC/uCoMZya/lBg6FaflX7jUYAtxUa81V5s4O23csy+mZrnygDKJlU1hZKgkDqk/WQFsDmYO3xNk1hDrQs6CLX5gnhgG+uRGff/yB0YwshGdqVeouep1dGQmX7BMsPONwKaBMgDNfCiWIjyZJb639ZuqvApCFTUv0FhQ87WYfRRqSy2u+4N4jf1BbkkTQsaoVnxKKP9NgzWRlw29wuDv0keqNtqlBmSs7kvCtaLgSYIo3t6BmI4KpOwMhfCQ9k8MYNOmxJsEXxKcSIQq7XWOB6ENr3CoSDhGKTWN1n/EGg1D8uHteIB/fJ0KDuSnzyZdyNnx72gBWl73tQc63ni/FNdxBayUdxtAqHK9inamSPhJ3v0SuS71I/69BAkhidvZ7eptGFcexnfwiUNopDDkPcI5/ngkyOL1CLN1pKhtoSKxLpkYJI2LPdh88ajWIrcSpromyd+kXdvmUsyETLchWBxS+0uWUPS2l5VBHculxrlIP0cKD1C0wF059hMqS30RttMnuOsdgqR7gFg4ZP2VBUeFIg2DURrjgcTckjoyRCuvI0eHrxmv1fJc5
 o0QaGkpL
 zE5RS6k9A1rqVJPI9CEEt2q48RjVE3wiesTkxcz/WC27DSyQqfGLIoMj7WRsnZnp2xXovqUNdTHVktNcI+reV14C6f9DW6yLoguNZSx9t2oV25pjZ4a9njlI1pSgxxCQlAKSS+zNrphAPEa47a+zXOIhr+Hea0pbj37wiMT23IDj/gp6ak6xPJidbKEhHx7WWj6uvhgIwafvCSDH0cnhnlZZl4aNIiV3/D42P3c+6lkrtuEleLo/XcJy63dfvf393jgRJhIcEpXQkZkzLZeMtGaU4n9TEibqI37zC2pz1rMEppuIKdyyvR/ITIA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 12, 2025 at 04:44:13PM +0100, Lorenzo Stoakes wrote:
> As part of the effort to move to mm->flags becoming a bitmap field, convert
> existing users to making use of the mm_flags_*() accessors which will, when
> the conversion is complete, be the only means of accessing mm_struct flags.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  arch/s390/mm/mmap.c              | 4 ++--
>  arch/sparc/kernel/sys_sparc_64.c | 4 ++--
>  arch/x86/mm/mmap.c               | 4 ++--
>  3 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/s390/mm/mmap.c b/arch/s390/mm/mmap.c
> index 40a526d28184..c884b580eb5e 100644
> --- a/arch/s390/mm/mmap.c
> +++ b/arch/s390/mm/mmap.c
> @@ -182,10 +182,10 @@ void arch_pick_mmap_layout(struct mm_struct *mm, struct rlimit *rlim_stack)
>  	 */
>  	if (mmap_is_legacy(rlim_stack)) {
>  		mm->mmap_base = mmap_base_legacy(random_factor);
> -		clear_bit(MMF_TOPDOWN, &mm->flags);
> +		mm_flags_clear(MMF_TOPDOWN, mm);
>  	} else {
>  		mm->mmap_base = mmap_base(random_factor, rlim_stack);
> -		set_bit(MMF_TOPDOWN, &mm->flags);
> +		mm_flag_set(MMF_TOPDOWN, mm);
>  	}
>  }
>  
> diff --git a/arch/sparc/kernel/sys_sparc_64.c b/arch/sparc/kernel/sys_sparc_64.c
> index c5a284df7b41..785e9909340f 100644
> --- a/arch/sparc/kernel/sys_sparc_64.c
> +++ b/arch/sparc/kernel/sys_sparc_64.c
> @@ -309,7 +309,7 @@ void arch_pick_mmap_layout(struct mm_struct *mm, struct rlimit *rlim_stack)
>  	    gap == RLIM_INFINITY ||
>  	    sysctl_legacy_va_layout) {
>  		mm->mmap_base = TASK_UNMAPPED_BASE + random_factor;
> -		clear_bit(MMF_TOPDOWN, &mm->flags);
> +		mm_flags_clear(MMF_TOPDOWN, mm);
>  	} else {
>  		/* We know it's 32-bit */
>  		unsigned long task_size = STACK_TOP32;
> @@ -320,7 +320,7 @@ void arch_pick_mmap_layout(struct mm_struct *mm, struct rlimit *rlim_stack)
>  			gap = (task_size / 6 * 5);
>  
>  		mm->mmap_base = PAGE_ALIGN(task_size - gap - random_factor);
> -		set_bit(MMF_TOPDOWN, &mm->flags);
> +		mm_flags_set(MMF_TOPDOWN, mm);
>  	}
>  }
>  
> diff --git a/arch/x86/mm/mmap.c b/arch/x86/mm/mmap.c
> index 5ed2109211da..708f85dc9380 100644
> --- a/arch/x86/mm/mmap.c
> +++ b/arch/x86/mm/mmap.c
> @@ -122,9 +122,9 @@ static void arch_pick_mmap_base(unsigned long *base, unsigned long *legacy_base,
>  void arch_pick_mmap_layout(struct mm_struct *mm, struct rlimit *rlim_stack)
>  {
>  	if (mmap_is_legacy())
> -		clear_bit(MMF_TOPDOWN, &mm->flags);
> +		mm_flags_clear(MMF_TOPDOWN, mm);
>  	else
> -		set_bit(MMF_TOPDOWN, &mm->flags);
> +		mm_flags_set(MMF_TOPDOWN, mm);
>  
>  	arch_pick_mmap_base(&mm->mmap_base, &mm->mmap_legacy_base,
>  			arch_rnd(mmap64_rnd_bits), task_size_64bit(0),
> -- 
> 2.50.1
> 

-- 
Sincerely yours,
Mike.

