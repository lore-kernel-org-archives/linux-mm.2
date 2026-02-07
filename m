Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 772B9EE6B6F
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 01:06:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 934CF6B008A; Fri,  6 Feb 2026 20:06:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E1FD6B0092; Fri,  6 Feb 2026 20:06:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B9CB6B0093; Fri,  6 Feb 2026 20:06:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 66E596B008A
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 20:06:39 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 02E921396D6
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 01:06:38 +0000 (UTC)
X-FDA: 84415870518.14.4A60A44
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf16.hostedemail.com (Postfix) with ESMTP id E5401180005
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 01:06:36 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mUSBnc8Y;
	spf=pass (imf16.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=leobras.c@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770426397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u/vJ3VIJuZtQuWjK4wytFxxOtJ+FrkJK3UbUw2RFviE=;
	b=fKyJZ8W5DKLPF/Eqq4wSAvrVGDc/DUqrs76yeizvUhvLVN/pk5pS7w6lt3qxEytNPsihdd
	39w9Y3Ef9/Yclpyu5BvqnhV8EkLpk4y9YgUZ8NTHKsaMHapQU/Wegjq3EjCBbn/JlCVPaD
	lm71gUQZjifHljGznhgS7crcrNlXRGY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mUSBnc8Y;
	spf=pass (imf16.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=leobras.c@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770426397; a=rsa-sha256;
	cv=none;
	b=C/xNaBG0dG/ZpTAq72vGpFnBqNhmVyFa7iSX4O+GguolfvIDJfM3B7KphjGZY0lackNoZN
	DF279Z5T+94r84YEtEtLC7FLySmVQhIdqdCVTZCBWUwB8BbwR7S3J2bMb91H47nF/LkA+m
	R9Sln8Po+ArUFSw8GlofjvG8dMkVpK0=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-4362507f0bcso1514354f8f.0
        for <linux-mm@kvack.org>; Fri, 06 Feb 2026 17:06:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770426395; x=1771031195; darn=kvack.org;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=u/vJ3VIJuZtQuWjK4wytFxxOtJ+FrkJK3UbUw2RFviE=;
        b=mUSBnc8YWHtFft0nRGLfn7fL6XOvd9oj/k7HviGtodOIGQ2dJz/yTFQ87AyMVkl4mn
         q4reJuPV4O2VHMV+5xtOP4UJHMU0QaAxSi3nT4xJffKLG0J6P2rdgv9ZEHI/cnpUmQ6F
         60FmEMYlcpC4F6qlPbtCQ2/OzVR4UKE3mHRM3TeIjhdA5wbjsfB/Nd0t2itxZ5ezHV3v
         7pl4O2NzLn0vyWyvRKfkmiE92UBuHFFmz/Z8kwDMrdXs7Vhbhgn+AkXZ5F2uwwGL6OoV
         alr4L951oJtqelzSiFWrxvCMBgRsgTsRI78j9cK9V/16L2Kp9ylNi0YKTLkpb0MGKhQN
         zogA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770426395; x=1771031195;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u/vJ3VIJuZtQuWjK4wytFxxOtJ+FrkJK3UbUw2RFviE=;
        b=NNoTqhvA0+okXrkXSUkApMFjuC9EIxI+eP67bux34lij2MBHblKHy46bx/zFjKaAbJ
         4NWqO0r2iAc8vZ50dVdnvGW0XmFD0oE1+EV/icp65UMurPcykISraJh0G/d0AUFJKko3
         RscpgdUuIhsUG9iqBjoh6Mc8869+oeibqzN1dyv4u4G14A31rN8SVLucrrmwMmwPD8Xp
         aSAbL8dZJ3JqgCOFOa1Lp0BsOH81os5DIPCmqW/IdcJe6JJrUH7PS9yzsB4EICNZeWcx
         lU1JHVHguwIRssmEKIf+2yiRgUqw8a9yxwYAyA3hTU+OOmrOX7ljBHfIniC5zq+NRlql
         l2zQ==
X-Forwarded-Encrypted: i=1; AJvYcCWfPJLCoDIuHbW42BVeueWihuTeQeSsKZ55lF1rwVIEl8N2xt8wmnl9GKrWQ4vyxcbntFDCIzEZ9Q==@kvack.org
X-Gm-Message-State: AOJu0Yz8GSHVi7TAwg81y6404mUiKKgNN6iWJZ09g85Z1ru+4+TiBj0a
	QT7RGlJK2FLs0LX7UwRLqox3oMwYLjcp7FiQK1jM0DymQU1ofUWEyO8p
X-Gm-Gg: AZuq6aKtLKfdoYatWVJxFLiLJSspb3uKPMtYRx+oeNzTWwU82BTD76dxmNAPYfWdsTe
	umc4GJkABetArWFSrn3l9MEAcVSRVzLFLaI4hZe1tIwg+bxJRlo1TbwTPz7KKucHhD5pzAZOM6X
	rM81bt//soAVck5x0q/l7Vv0/7zXYpv8L3IrlSX8v5IQ9UMlBUGSScreJWc6/u4clKGqhDLRJLk
	kj2Ft7yJjG7tJkDObOnqcsbJkdtmvuoz3ABe7rjKef0c2ALFSIPtD3BGbCII3gbAiPYYLfNdQy9
	+/rVYg5xV0Nib2lndLlZqYcU9J71zbIQ0lPBnyg+304WfsXnv2jErqNGAuSIW+X27W1JJ0RmXg+
	dx8iV211F7q/xEsjoKHCTJfnSNtcLLNfTEG9bhxo5FUsji4V+xZRfQf4By47pBsQJAVU9l8Uyfp
	E526iJxY7ac8I7FS3D6ba7YgQ=
X-Received: by 2002:a05:6000:18a4:b0:431:c06:bc82 with SMTP id ffacd0b85a97d-436209967b3mr14539883f8f.12.1770426394964;
        Fri, 06 Feb 2026 17:06:34 -0800 (PST)
Received: from WindFlash.powerhub ([2a0a:ef40:1b2a:fa01:9944:6a8c:dc37:eba5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43629664632sm9318385f8f.0.2026.02.06.17.06.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Feb 2026 17:06:34 -0800 (PST)
From: Leonardo Bras <leobras.c@gmail.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Leonardo Bras <leobras.c@gmail.com>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>,
	Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Leonardo Bras <leobras@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>,
	Boqun Feng <boqun.feng@gmail.com>
Subject: Re: [PATCH 3/4] swap: apply new queue_percpu_work_on() interface
Date: Fri,  6 Feb 2026 22:06:28 -0300
Message-ID: <aYaQFM9sBbauUn5c@WindFlash>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260206143741.589656953@redhat.com>
References: <20260206143430.021026873@redhat.com> <20260206143741.589656953@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E5401180005
X-Rspamd-Server: rspam07
X-Stat-Signature: xt1zetismkjue78t8dd6t9mufhr9tdme
X-HE-Tag: 1770426396-177426
X-HE-Meta: U2FsdGVkX1/3iebJlRTHEiSjXTHCOv7wrC1U2rKf2kLuCr8SfJ2tkzXKd6xqeruCorx3RNaGtHxPn4OQkuh4Zyi2ZtgRDyA3hQl3RL2Dl+/nVcDbnwqc3sqI1yGdxtT3paUE1C8kgDWDSgaoG6RNrDcOsnS7uI9jcaGUnTgCqRcHWj7I1JYV+PrgrcObUdWHpHywGFl35HerFFHAZNI5SmcmCRfr7M87KFaV80HCwHcZ8/pWviSRQnjVNcrmmU5wliG1LjVJqQ03BxXM+yFp7L7T3/RSNSaWX//PwWPTMxrvTFPzoEoBMR0YkCXwggC+rO4YKaLGPCGdPMsN+9R2jUD6hK4QBUteq1Y+iuDG4eGbPLOV5sFaLrkPjRPqt+X9qDrk+unihizhZHQSCWFEOZolINACDnEOEhp/cRQuSGhlPBl6YMyjZkbTif0OK7PNqxNg+2rrmlUhNOgD9Jw13OxSYhkITQKDmjaZOf5cUkClrsy4i47h449fVkbjiy0JOb2txPQnw3ErSDiUSta9RQKpSdVVV4ZRQZ8Iw1WhvO61ntxdDFvSvxWq2oriPTWNEif5fUtEYimnmuu+y+6z2JZz9xH2IZ035+LMAX3aocyD3XzoGndU2kiIIidJVTknUXwFXapdws5tbiFePtwZ3JvRtue1SHYL62UI/78NJ54MyDaaVxhuw5axgJdf97wyMYIncDIrnCi4AOq7kNoTdPqixHOMxXU3oF21iB+1GPalMPkFM+lVgiLxC+OUEKtOIKaOu+PuoIWHIIfkWuEvxdXzyAPGz2XG1ZfvhSM67Y1d6rsEQUQZ0Nd6OOr5nX7D/ivPVGs0puVOhwJuZX48gn4cbFOEAZjvKF+6q+ZqcmenYc3p1Yx7cC1PUEgczYPAUW2XDQxG+kW88O6umfjUThfUh/LG62uU2FZw7juELhnNaEyujw5sooKzEMUTQjGkW+Bj4eNj2TtM/zgQkSh
 jNXYsP1t
 6OMU7OJMZVnxKMUl4I2YOiXh/bfu2TZvJVbKKjGBm6kTbgZI+s7j2LuKvJx9VgJDxlJCr6krRq9aoK+mGu5cf9RBphrzdWhgtlEvnHVX9XpUh8NGhRu/siqjMOQknnV/PCREf6SCmjzs8Sj9uCeONId3YHiXid318QqUgzwT9Mmil8i2LHvEnY60sqo1liZW4I4NuXJTJplXNetRLDqn79i9QVswRqbFv0H2XgtsLdfT9qln6DRi31A1xsh0pIoQqlHl1Q+dSKC79kvM/2/I3YBEJS53DEIeZLqrTqETQgaooru6yUtwLvEATtsdylC514U6tp6G+HkDMN7DoApMfYU4dXZWyUF/8NzV0zopqzeSfF0tuReqESaG/bRPaCHxY2JsJdy08oeWW8ebJN8AyAoJO3+oP5lIPbjiPs9mVUSxZ/xihEKgH9OhBoQMFKN0I+gOw2Iwpn3y1VvEltQ/NGkzGbWjWePeeSyG9TMEvCIjJqoYUtup3NRA7Ma98nqpphThBfQNL4UFsOPRqcu0TE0IhL/zk3RlvfGc9LhWDitx6O3SKx3KMSNq7ui0hBMjZhaOwxhmkv8uG8lJQ2gwjOjkVfXeoSdAHuuzSevrE2/FflhEKPOoKvBfDGfNQiqcBxBNu6VSw9ruauMXw8+ghmv1eBoliYwVHVfjfnpg7gYVxBIWb+azkXYpGvg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 06, 2026 at 11:34:33AM -0300, Marcelo Tosatti wrote:
> Make use of the new qpw_{un,}lock*() and queue_percpu_work_on()
> interface to improve performance & latency on PREEMPT_RT kernels.
> 
> For functions that may be scheduled in a different cpu, replace
> local_{un,}lock*() by qpw_{un,}lock*(), and replace schedule_work_on() by
> queue_percpu_work_on(). The same happens for flush_work() and
> flush_percpu_work().
> 
> The change requires allocation of qpw_structs instead of a work_structs,
> and changing parameters of a few functions to include the cpu parameter.
> 
> This should bring no relevant performance impact on non-RT kernels:

I think this is still referencing the previuos version, as there may be 
impact in PREEMPT_RT=n kernels if QPW=y and qpw=1 in kernel cmdline.

I would go with:
This should bring no relevant performance impact on non-QPW kernels

> For functions that may be scheduled in a different cpu, the local_*lock's
> this_cpu_ptr() becomes a per_cpu_ptr(smp_processor_id()).
> 
> Signed-off-by: Leonardo Bras <leobras@redhat.com>
> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
> 
> ---
>  mm/internal.h   |    4 +-
>  mm/mlock.c      |   71 ++++++++++++++++++++++++++++++++------------
>  mm/page_alloc.c |    2 -
>  mm/swap.c       |   90 +++++++++++++++++++++++++++++++-------------------------
>  4 files changed, 108 insertions(+), 59 deletions(-)
> 
> Index: slab/mm/mlock.c
> ===================================================================
> --- slab.orig/mm/mlock.c
> +++ slab/mm/mlock.c
> @@ -25,17 +25,16 @@
>  #include <linux/memcontrol.h>
>  #include <linux/mm_inline.h>
>  #include <linux/secretmem.h>
> +#include <linux/qpw.h>
>  
>  #include "internal.h"
>  
>  struct mlock_fbatch {
> -	local_lock_t lock;
> +	qpw_lock_t lock;
>  	struct folio_batch fbatch;
>  };
>  
> -static DEFINE_PER_CPU(struct mlock_fbatch, mlock_fbatch) = {
> -	.lock = INIT_LOCAL_LOCK(lock),
> -};
> +static DEFINE_PER_CPU(struct mlock_fbatch, mlock_fbatch);
>  
>  bool can_do_mlock(void)
>  {
> @@ -209,18 +208,25 @@ static void mlock_folio_batch(struct fol
>  	folios_put(fbatch);
>  }
>  
> -void mlock_drain_local(void)
> +void mlock_drain_cpu(int cpu)
>  {
>  	struct folio_batch *fbatch;
>  
> -	local_lock(&mlock_fbatch.lock);
> -	fbatch = this_cpu_ptr(&mlock_fbatch.fbatch);
> +	qpw_lock(&mlock_fbatch.lock, cpu);
> +	fbatch = per_cpu_ptr(&mlock_fbatch.fbatch, cpu);
>  	if (folio_batch_count(fbatch))
>  		mlock_folio_batch(fbatch);
> -	local_unlock(&mlock_fbatch.lock);
> +	qpw_unlock(&mlock_fbatch.lock, cpu);
>  }
>  
> -void mlock_drain_remote(int cpu)
> +void mlock_drain_local(void)
> +{
> +	migrate_disable();
> +	mlock_drain_cpu(smp_processor_id());
> +	migrate_enable();
> +}
> +
> +void mlock_drain_offline(int cpu)
>  {
>  	struct folio_batch *fbatch;
>  
> @@ -242,9 +248,12 @@ bool need_mlock_drain(int cpu)
>  void mlock_folio(struct folio *folio)
>  {
>  	struct folio_batch *fbatch;
> +	int cpu;
>  
> -	local_lock(&mlock_fbatch.lock);
> -	fbatch = this_cpu_ptr(&mlock_fbatch.fbatch);
> +	migrate_disable();
> +	cpu = smp_processor_id();

Wondering if for these cases it would make sense to have something like:

qpw_get_local_cpu() and 
qpw_put_local_cpu() 

so we could encapsulate these migrate_{en,dis}able()
and the smp_processor_id().

Or even,

int qpw_local_lock() {
	migrate_disable();
	cpu = smp_processor_id();
	qpw_lock(..., cpu);

	return cpu;
}

and

qpw_local_unlock(cpu){
	qpw_unlock(...,cpu);
	migrate_enable();
} 

so it's more direct to convert the local-only cases.

What do you think?


> +	qpw_lock(&mlock_fbatch.lock, cpu);
> +	fbatch = per_cpu_ptr(&mlock_fbatch.fbatch, cpu);
>  
>  	if (!folio_test_set_mlocked(folio)) {
>  		int nr_pages = folio_nr_pages(folio);
> @@ -257,7 +266,8 @@ void mlock_folio(struct folio *folio)
>  	if (!folio_batch_add(fbatch, mlock_lru(folio)) ||
>  	    !folio_may_be_lru_cached(folio) || lru_cache_disabled())
>  		mlock_folio_batch(fbatch);
> -	local_unlock(&mlock_fbatch.lock);
> +	qpw_unlock(&mlock_fbatch.lock, cpu);
> +	migrate_enable();
>  }
>  
>  /**
> @@ -268,9 +278,13 @@ void mlock_new_folio(struct folio *folio
>  {
>  	struct folio_batch *fbatch;
>  	int nr_pages = folio_nr_pages(folio);
> +	int cpu;
> +
> +	migrate_disable();
> +	cpu = smp_processor_id();
> +	qpw_lock(&mlock_fbatch.lock, cpu);
>  
> -	local_lock(&mlock_fbatch.lock);
> -	fbatch = this_cpu_ptr(&mlock_fbatch.fbatch);
> +	fbatch = per_cpu_ptr(&mlock_fbatch.fbatch, cpu);
>  	folio_set_mlocked(folio);
>  
>  	zone_stat_mod_folio(folio, NR_MLOCK, nr_pages);
> @@ -280,7 +294,8 @@ void mlock_new_folio(struct folio *folio
>  	if (!folio_batch_add(fbatch, mlock_new(folio)) ||
>  	    !folio_may_be_lru_cached(folio) || lru_cache_disabled())
>  		mlock_folio_batch(fbatch);
> -	local_unlock(&mlock_fbatch.lock);
> +	migrate_enable();
> +	qpw_unlock(&mlock_fbatch.lock, cpu);

in the above conversion, the migrate_enable() happened after qpw_unlock,
and in this one is the oposite. Any particular reason?

>  }
>  
>  /**
> @@ -290,9 +305,13 @@ void mlock_new_folio(struct folio *folio
>  void munlock_folio(struct folio *folio)
>  {
>  	struct folio_batch *fbatch;
> +	int cpu;
>  
> -	local_lock(&mlock_fbatch.lock);
> -	fbatch = this_cpu_ptr(&mlock_fbatch.fbatch);
> +	migrate_disable();
> +	cpu = smp_processor_id();
> +	qpw_lock(&mlock_fbatch.lock, cpu);
> +
> +	fbatch = per_cpu_ptr(&mlock_fbatch.fbatch, cpu);
>  	/*
>  	 * folio_test_clear_mlocked(folio) must be left to __munlock_folio(),
>  	 * which will check whether the folio is multiply mlocked.
> @@ -301,7 +320,8 @@ void munlock_folio(struct folio *folio)
>  	if (!folio_batch_add(fbatch, folio) ||
>  	    !folio_may_be_lru_cached(folio) || lru_cache_disabled())
>  		mlock_folio_batch(fbatch);
> -	local_unlock(&mlock_fbatch.lock);
> +	qpw_unlock(&mlock_fbatch.lock, cpu);
> +	migrate_enable();
>  }
>  
>  static inline unsigned int folio_mlock_step(struct folio *folio,
> @@ -823,3 +843,18 @@ void user_shm_unlock(size_t size, struct
>  	spin_unlock(&shmlock_user_lock);
>  	put_ucounts(ucounts);
>  }
> +
> +int __init mlock_init(void)
> +{
> +	unsigned int cpu;
> +
> +	for_each_possible_cpu(cpu) {
> +		struct mlock_fbatch *fbatch = &per_cpu(mlock_fbatch, cpu);
> +
> +		qpw_lock_init(&fbatch->lock);
> +	}
> +
> +	return 0;
> +}
> +
> +module_init(mlock_init);
> Index: slab/mm/swap.c
> ===================================================================
> --- slab.orig/mm/swap.c
> +++ slab/mm/swap.c
> @@ -35,7 +35,7 @@
>  #include <linux/uio.h>
>  #include <linux/hugetlb.h>
>  #include <linux/page_idle.h>
> -#include <linux/local_lock.h>
> +#include <linux/qpw.h>
>  #include <linux/buffer_head.h>
>  
>  #include "internal.h"
> @@ -52,7 +52,7 @@ struct cpu_fbatches {
>  	 * The following folio batches are grouped together because they are protected
>  	 * by disabling preemption (and interrupts remain enabled).
>  	 */
> -	local_lock_t lock;
> +	qpw_lock_t lock;
>  	struct folio_batch lru_add;
>  	struct folio_batch lru_deactivate_file;
>  	struct folio_batch lru_deactivate;
> @@ -61,14 +61,11 @@ struct cpu_fbatches {
>  	struct folio_batch lru_activate;
>  #endif
>  	/* Protecting the following batches which require disabling interrupts */
> -	local_lock_t lock_irq;
> +	qpw_lock_t lock_irq;
>  	struct folio_batch lru_move_tail;
>  };
>  
> -static DEFINE_PER_CPU(struct cpu_fbatches, cpu_fbatches) = {
> -	.lock = INIT_LOCAL_LOCK(lock),
> -	.lock_irq = INIT_LOCAL_LOCK(lock_irq),
> -};
> +static DEFINE_PER_CPU(struct cpu_fbatches, cpu_fbatches);
>  
>  static void __page_cache_release(struct folio *folio, struct lruvec **lruvecp,
>  		unsigned long *flagsp)
> @@ -183,22 +180,24 @@ static void __folio_batch_add_and_move(s
>  		struct folio *folio, move_fn_t move_fn, bool disable_irq)
>  {
>  	unsigned long flags;
> +	int cpu;
>  
>  	folio_get(folio);


don't we need the migrate_disable() here?

>  
> +	cpu = smp_processor_id();
>  	if (disable_irq)
> -		local_lock_irqsave(&cpu_fbatches.lock_irq, flags);
> +		qpw_lock_irqsave(&cpu_fbatches.lock_irq, flags, cpu);
>  	else
> -		local_lock(&cpu_fbatches.lock);
> +		qpw_lock(&cpu_fbatches.lock, cpu);
>  
> -	if (!folio_batch_add(this_cpu_ptr(fbatch), folio) ||
> +	if (!folio_batch_add(per_cpu_ptr(fbatch, cpu), folio) ||
>  			!folio_may_be_lru_cached(folio) || lru_cache_disabled())
> -		folio_batch_move_lru(this_cpu_ptr(fbatch), move_fn);
> +		folio_batch_move_lru(per_cpu_ptr(fbatch, cpu), move_fn);
>  
>  	if (disable_irq)
> -		local_unlock_irqrestore(&cpu_fbatches.lock_irq, flags);
> +		qpw_unlock_irqrestore(&cpu_fbatches.lock_irq, flags, cpu);
>  	else
> -		local_unlock(&cpu_fbatches.lock);
> +		qpw_unlock(&cpu_fbatches.lock, cpu);
>  }
>  
>  #define folio_batch_add_and_move(folio, op)		\
> @@ -358,9 +357,10 @@ static void __lru_cache_activate_folio(s
>  {
>  	struct folio_batch *fbatch;
>  	int i;

and here?

> +	int cpu = smp_processor_id();
>  
> -	local_lock(&cpu_fbatches.lock);
> -	fbatch = this_cpu_ptr(&cpu_fbatches.lru_add);
> +	qpw_lock(&cpu_fbatches.lock, cpu);
> +	fbatch = per_cpu_ptr(&cpu_fbatches.lru_add, cpu);
>  
>  	/*
>  	 * Search backwards on the optimistic assumption that the folio being
> @@ -381,7 +381,7 @@ static void __lru_cache_activate_folio(s
>  		}
>  	}
>  
> -	local_unlock(&cpu_fbatches.lock);
> +	qpw_unlock(&cpu_fbatches.lock, cpu);
>  }
>  
>  #ifdef CONFIG_LRU_GEN
> @@ -653,9 +653,9 @@ void lru_add_drain_cpu(int cpu)
>  		unsigned long flags;
>  
>  		/* No harm done if a racing interrupt already did this */
> -		local_lock_irqsave(&cpu_fbatches.lock_irq, flags);
> +		qpw_lock_irqsave(&cpu_fbatches.lock_irq, flags, cpu);
>  		folio_batch_move_lru(fbatch, lru_move_tail);
> -		local_unlock_irqrestore(&cpu_fbatches.lock_irq, flags);
> +		qpw_unlock_irqrestore(&cpu_fbatches.lock_irq, flags, cpu);
>  	}
>  
>  	fbatch = &fbatches->lru_deactivate_file;
> @@ -733,10 +733,12 @@ void folio_mark_lazyfree(struct folio *f
>  
>  void lru_add_drain(void)
>  {
> -	local_lock(&cpu_fbatches.lock);
> -	lru_add_drain_cpu(smp_processor_id());
> -	local_unlock(&cpu_fbatches.lock);
> -	mlock_drain_local();

and here?

> +	int cpu = smp_processor_id();
> +
> +	qpw_lock(&cpu_fbatches.lock, cpu);
> +	lru_add_drain_cpu(cpu);
> +	qpw_unlock(&cpu_fbatches.lock, cpu);
> +	mlock_drain_cpu(cpu);
>  }
>  
>  /*
> @@ -745,30 +747,32 @@ void lru_add_drain(void)
>   * the same cpu. It shouldn't be a problem in !SMP case since
>   * the core is only one and the locks will disable preemption.
>   */
> -static void lru_add_mm_drain(void)
> +static void lru_add_mm_drain(int cpu)
>  {
> -	local_lock(&cpu_fbatches.lock);
> -	lru_add_drain_cpu(smp_processor_id());
> -	local_unlock(&cpu_fbatches.lock);
> -	mlock_drain_local();
> +	qpw_lock(&cpu_fbatches.lock, cpu);
> +	lru_add_drain_cpu(cpu);
> +	qpw_unlock(&cpu_fbatches.lock, cpu);
> +	mlock_drain_cpu(cpu);
>  }
>  
>  void lru_add_drain_cpu_zone(struct zone *zone)
>  {
> -	local_lock(&cpu_fbatches.lock);
> -	lru_add_drain_cpu(smp_processor_id());

and here ?

> +	int cpu = smp_processor_id();
> +
> +	qpw_lock(&cpu_fbatches.lock, cpu);
> +	lru_add_drain_cpu(cpu);
>  	drain_local_pages(zone);
> -	local_unlock(&cpu_fbatches.lock);
> -	mlock_drain_local();
> +	qpw_unlock(&cpu_fbatches.lock, cpu);
> +	mlock_drain_cpu(cpu);
>  }
>  
>  #ifdef CONFIG_SMP
>  
> -static DEFINE_PER_CPU(struct work_struct, lru_add_drain_work);
> +static DEFINE_PER_CPU(struct qpw_struct, lru_add_drain_qpw);
>  
> -static void lru_add_drain_per_cpu(struct work_struct *dummy)
> +static void lru_add_drain_per_cpu(struct work_struct *w)
>  {
> -	lru_add_mm_drain();
> +	lru_add_mm_drain(qpw_get_cpu(w));
>  }
>  
>  static DEFINE_PER_CPU(struct work_struct, bh_add_drain_work);
> @@ -883,12 +887,12 @@ static inline void __lru_add_drain_all(b
>  	cpumask_clear(&has_mm_work);
>  	cpumask_clear(&has_bh_work);
>  	for_each_online_cpu(cpu) {
> -		struct work_struct *mm_work = &per_cpu(lru_add_drain_work, cpu);
> +		struct qpw_struct *mm_qpw = &per_cpu(lru_add_drain_qpw, cpu);
>  		struct work_struct *bh_work = &per_cpu(bh_add_drain_work, cpu);
>  
>  		if (cpu_needs_mm_drain(cpu)) {
> -			INIT_WORK(mm_work, lru_add_drain_per_cpu);
> -			queue_work_on(cpu, mm_percpu_wq, mm_work);
> +			INIT_QPW(mm_qpw, lru_add_drain_per_cpu, cpu);
> +			queue_percpu_work_on(cpu, mm_percpu_wq, mm_qpw);
>  			__cpumask_set_cpu(cpu, &has_mm_work);
>  		}
>  
> @@ -900,7 +904,7 @@ static inline void __lru_add_drain_all(b
>  	}
>  
>  	for_each_cpu(cpu, &has_mm_work)
> -		flush_work(&per_cpu(lru_add_drain_work, cpu));
> +		flush_percpu_work(&per_cpu(lru_add_drain_qpw, cpu));
>  
>  	for_each_cpu(cpu, &has_bh_work)
>  		flush_work(&per_cpu(bh_add_drain_work, cpu));
> @@ -950,7 +954,7 @@ void lru_cache_disable(void)
>  #ifdef CONFIG_SMP
>  	__lru_add_drain_all(true);
>  #else
> -	lru_add_mm_drain();

and here, I wonder

> +	lru_add_mm_drain(smp_processor_id());
>  	invalidate_bh_lrus_cpu();
>  #endif
>  }
> @@ -1124,6 +1128,7 @@ static const struct ctl_table swap_sysct
>  void __init swap_setup(void)
>  {
>  	unsigned long megs = PAGES_TO_MB(totalram_pages());
> +	unsigned int cpu;
>  
>  	/* Use a smaller cluster for small-memory machines */
>  	if (megs < 16)
> @@ -1136,4 +1141,11 @@ void __init swap_setup(void)
>  	 */
>  
>  	register_sysctl_init("vm", swap_sysctl_table);
> +
> +	for_each_possible_cpu(cpu) {
> +		struct cpu_fbatches *fbatches = &per_cpu(cpu_fbatches, cpu);
> +
> +		qpw_lock_init(&fbatches->lock);
> +		qpw_lock_init(&fbatches->lock_irq);
> +	}
>  }
> Index: slab/mm/internal.h
> ===================================================================
> --- slab.orig/mm/internal.h
> +++ slab/mm/internal.h
> @@ -1061,10 +1061,12 @@ static inline void munlock_vma_folio(str
>  		munlock_folio(folio);
>  }
>  
> +int __init mlock_init(void);
>  void mlock_new_folio(struct folio *folio);
>  bool need_mlock_drain(int cpu);
>  void mlock_drain_local(void);
> -void mlock_drain_remote(int cpu);
> +void mlock_drain_cpu(int cpu);
> +void mlock_drain_offline(int cpu);
>  
>  extern pmd_t maybe_pmd_mkwrite(pmd_t pmd, struct vm_area_struct *vma);
>  
> Index: slab/mm/page_alloc.c
> ===================================================================
> --- slab.orig/mm/page_alloc.c
> +++ slab/mm/page_alloc.c
> @@ -6251,7 +6251,7 @@ static int page_alloc_cpu_dead(unsigned
>  	struct zone *zone;
>  
>  	lru_add_drain_cpu(cpu);
> -	mlock_drain_remote(cpu);
> +	mlock_drain_offline(cpu);
>  	drain_pages(cpu);
>  
>  	/*
> 
> 

TBH, I am still trying to understand if we need the migrate_{en,dis}able():
- There is a data dependency beween cpu being filled and being used.
- If we get the cpu, and then migrate to a different cpu, the operation 
  will still be executed with the data from that starting cpu 
- But maybe the compiler tries to optize this because the processor number 
  can be on a register and of easy access, which would break this.

Maybe a READ_ONCE() on smp_processor_id() should suffice?

Other than that, all the conversions done look correct.

That being said, I understand very little about mm code, so let's hope we 
get proper feedback from those who do :) 

Thanks!
Leo


