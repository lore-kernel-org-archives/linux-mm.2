Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76C28F459FC
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 18:32:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A365C6B0089; Fri, 10 Apr 2026 14:32:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E6FC6B008A; Fri, 10 Apr 2026 14:32:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FC676B0092; Fri, 10 Apr 2026 14:32:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7D91D6B0089
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 14:32:32 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1AF678BFE4
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 18:32:32 +0000 (UTC)
X-FDA: 84643491744.11.2423D9B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3CCF98000C
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 18:32:30 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="Eg0PP0U/";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775845950; a=rsa-sha256;
	cv=none;
	b=IjI18wOgYd23my1Ml56jjjNmVEnBlbqb0VueBplKyxob9spZm/7U3oAMHZrJQ6uE4T5qJm
	a4nHCwysN+KoZCpERJWYbF3jp93MzMclsaUh899L8y5ol+0Jh+QNly8RQ+kS5KrKRQAr/P
	aAVGTMBgJziwweE87bJoCHAZkO6BqSI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="Eg0PP0U/";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775845950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YJZZolRG9FlaLRoeUw+FS3eqzLw0l3IX4/lJwO0wdQ8=;
	b=v74RGLmwAauNShqhANIVbHy5teYSyO03tYR5dHJ1aTxBJjjJg3XegUg/43AGl1IdTiQpVI
	YRYbS4Z6f/qdc04bzB2r08pSqxvDFEF68nVhXMszEYRSaEINimdqAPVLneEPMgcfLC39Ai
	KTcSwTFREOgjNvXB1fIWWg4T13nfVAM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7B34947E0;
	Fri, 10 Apr 2026 11:32:23 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 94A333F632;
	Fri, 10 Apr 2026 11:32:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775845949; bh=XTlqRNuX63T/Wl+K3E/fotcVmu5Bv4KRS6GdSpRLcpY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Eg0PP0U/d9YZzUK9BfPwvahjOXD1+EK5WUggR92hUZdL20gBVsKbHtaG4wjFG0NmP
	 2NaF2YR653D//8Qagy8FKHHXyNGGknziylIor62RdmVP9YhZyaxbX+DOqPJ1cICiks
	 GC4s4+mRhC+CKMQ1wvL8yBksP3ezBBYxG396UHVc=
Date: Fri, 10 Apr 2026 19:32:23 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Uladzislau Rezki <urezki@gmail.com>,
	linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Andrey Konovalov <andreyknvl@gmail.com>,
	Marco Elver <elver@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Peter Collingbourne <pcc@google.com>, Will Deacon <will@kernel.org>,
	Ryan.Roberts@arm.com, david.hildenbrand@arm.com
Subject: Re: [PATCH v2 2/3] kasan: skip HW tagging for all kernel thread
 stacks
Message-ID: <adlCN9sUcQdWbf_i@arm.com>
References: <20260324132631.482520-1-usama.anjum@arm.com>
 <20260324132631.482520-3-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260324132631.482520-3-usama.anjum@arm.com>
X-Stat-Signature: onhaqb3t1y3ekqpc5a9ck76ryjjksgqo
X-Rspamd-Queue-Id: 3CCF98000C
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775845950-487041
X-HE-Meta: U2FsdGVkX18kNIbZEjZHn4NZ2trys0biQQ1IaZk4800LgFsuZGp8DX2m/T0gYzM1vHriDRXeqfqfRMYFVVjBua7UyqTMwDtpR+pBW6uuv346Kv6Bxf1RTuh1M7Sj8f/Ahxk1MIYMIuuGVM1tBCHSnWym1bhC9azQOQoeBTkf8mH5P8Dn7p8uWoCR4cEb+/wAx5b26+kbRQZAfhrOrKl7Typasqrv2TBtQ0iNDCJjQHX3ukyhfEfHKmJ8Fj4rpTYTwVKUxgRHetOzvAJ4xsjPVqkG1CnjsFPDzOYg2sn2dhV+pcoax37IofCv1Sptvre/0VGYvWoktbFuYGyDsokqSG9ggX5F96yYZUI4xenY7JTOXg/21M/fZc8B9x5+fzU+vSK+frjvslbsKsi49XO5lM4zBzb5lhEg0TNxKECAH82f6tztxaYdB6kVEW1VitmHaA2PnntN91kApePRsGYJ1DCxQ/nABgygF5YLM/0nIcVFd2uCfnaunbKbqvZ24DtQxilU3XuAF+DzIRHEKR7G+KrUp6ahy7bu6O9GdXzIlb3imDQ1L50b4JVu9N/KLejcDuezRJcGArn4am5WBli5D+CBwPIFibKA0wBCHOt0Gw885UdrMqSAqgmG6kw9nNZ+qJ4qtM893WgEqEpNoAqLJSOa3sSLFMYJddv0AxM8VbMI7H0SHuGm+ujoZP+2yhIMv0utPluQL9qzN2NlU5r/UejL9b0EHUnNjcRyKzhsEktYl1ccZlZ9CXLi65YKraaqeb0q0Fb8nlJSQm2IEA4QX3UCNEFzTbozvS5TTxSYGCElQSvvmDNhw004S2hiuuUhM63m8HRIdmkoFE9EvECcHNYJaBtMUtT07MV7pqMNKMvnMfebivZPO+MKolV4xS3W+cZYdACjTBiG8fu/PZ+MyJjcwca07xvCGM+9rIVhqlgSoGHqkx1m43g+NwytAgPyJBMFUOnkL3zAAhyqqNp
 8/bqEYML
 lIuk5wmQc17/wGKhMi0qiX9RnMjbcnoPoe7UBZj7x4tHQ1nT4k2Dvcu1UZMtKb/DqFmoxw755OoAPyZM4v5DcbBgLOa5Vx8RPwx234EeCIsOEJZucMVuum4Ll6ZfBs0//76Rwg9zc6wYZH4mOqxHCUWzhdgZFPwVAxUasFynAWKqpm5SpgTsDsPhRX1j1CH+k7ffoEHyVft4ngnpVchKSNJ9haxnjVNP+Y6zzJvHAMS3/bmnLHtlKj97rYSAGoIYsuXUXsdDdoeRvHD0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24, 2026 at 01:26:28PM +0000, Muhammad Usama Anjum wrote:
> diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
> index 051e429026904..307b8390fc670 100644
> --- a/include/linux/thread_info.h
> +++ b/include/linux/thread_info.h
> @@ -92,7 +92,7 @@ static inline long set_restart_fn(struct restart_block *restart,
>  #define THREAD_ALIGN	THREAD_SIZE
>  #endif
>  
> -#define THREADINFO_GFP		(GFP_KERNEL_ACCOUNT | __GFP_ZERO)
> +#define THREADINFO_GFP		(GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_SKIP_KASAN)
>  
>  /*
>   * flag set/clear/test wrappers
> diff --git a/kernel/fork.c b/kernel/fork.c
> index bb0c2613a5604..4bc7a03662109 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -207,7 +207,7 @@ static DEFINE_PER_CPU(struct vm_struct *, cached_stacks[NR_CACHED_STACKS]);
>   * accounting is performed by the code assigning/releasing stacks to tasks.
>   * We need a zeroed memory without __GFP_ACCOUNT.
>   */
> -#define GFP_VMAP_STACK (GFP_KERNEL | __GFP_ZERO)
> +#define GFP_VMAP_STACK (GFP_KERNEL | __GFP_ZERO | __GFP_SKIP_KASAN)
>  
>  struct vm_stack {
>  	struct rcu_head rcu;
> @@ -345,7 +345,8 @@ static int alloc_thread_stack_node(struct task_struct *tsk, int node)
>  		}
>  
>  		/* Reset stack metadata. */
> -		kasan_unpoison_range(vm_area->addr, THREAD_SIZE);
> +		if (!kasan_hw_tags_enabled())
> +			kasan_unpoison_range(vm_area->addr, THREAD_SIZE);
>  
>  		stack = kasan_reset_tag(vm_area->addr);

I wonder, since with kasan_reset_tag() returns a match-all pointer even
with KASAN_SW_TAGS, is it worth unpoisoning the range (unless it somehow
interferes with vfree() but I couldn't see how).

What the original approach might help with is use-after-realloc in case
we had a tagged pointer in a past life of a page and it still works now.
Oh well, that's I guess for other types of hardening to address like
delayed reallocation.

-- 
Catalin

