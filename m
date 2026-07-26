Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD5D5C531C9
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 18:41:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 831216B0093; Sun, 26 Jul 2026 14:41:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E2A46B0095; Sun, 26 Jul 2026 14:41:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D3556B0098; Sun, 26 Jul 2026 14:41:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 378BC6B0093
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 14:41:34 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A63B21C0C8C
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 18:41:33 +0000 (UTC)
X-FDA: 85031796066.17.854C40E
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf26.hostedemail.com (Postfix) with ESMTP id C51A8140004
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 18:41:31 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jBImui7F;
	spf=pass (imf26.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785091291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rnsX5Nycy+Nw1GF/hyAVIF+SSLqhhOcEVPTSmKPICUw=;
	b=k4872uqdX5kTwKfuDucsfcJTIIN5uAklkvI2v6+3Gjnt5ZpNKIuA3Tc9z1cAFxAxXTPnpR
	9pIGEdL7sJ5J8qXlD8suPSVn+Frt0jNdF0e8jJb1AkBXrOO3/5CJCcz9msLGfZf0JDQWo4
	86zD1fdOJOnSWI9OFQLUx++wfKclqko=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785091291;
	b=CSYWn5P2ueQdPTCGkV6+oI8CO3+XnGNExh4LzV8TEwiKTHQrU97TeaOS37KDY93V3mPDuM
	lBeo4G3WviwvgtWlZ7FYvYvjZcWEh+us9I0Pc46wWLCdHJYINrz8XRUykPSjzOAu4JQcMi
	lCeuCliLLkE89HqXpM6KSLDc9MW8nyg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jBImui7F;
	spf=pass (imf26.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-38101f85591so2686237a91.1
        for <linux-mm@kvack.org>; Sun, 26 Jul 2026 11:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785091291; x=1785696091; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rnsX5Nycy+Nw1GF/hyAVIF+SSLqhhOcEVPTSmKPICUw=;
        b=jBImui7FnXGleVZ2j8fu7ruN5NGYKmfT2x4s7AcjRp/YvjhagQmoWa4TvMR9ArA3no
         +UZrl6KptOC0Z7KjIBISMNVhNLC+aw6wZuEQDYmqQF6qQsyE/tOZV7Jza5nbxAyauDd5
         GYfHPkJafdJjCYQaH00qw2ixawYLovswtN90ywEp2auVrTmft/ddZFao03K5pV7Hhd/v
         b0fCjhkv6D4IuqQkninjaYL1YURgfmnsYFwQQ6D84JNEGWCQG7f2UXtnVOW1R7subbLZ
         VMqFH05aEy7qPo6ZTlkjeeZPV9WvupUGRUcwa1X2MhhXLJt4EeTqL02v4E3ujKyTHwhb
         JOcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785091291; x=1785696091;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rnsX5Nycy+Nw1GF/hyAVIF+SSLqhhOcEVPTSmKPICUw=;
        b=jBluayaFTjEqNplxegMx70VjIAML0sg7ZePtuAm5RwwMWvCtxJWPQ/w13woBbQ4utS
         zh8VY3qvbF1aqzD336fgtNv4YcGdeWtfIqbhOhn1yPxPP7LBkSwFh4M9eIvxVAiulLjy
         IUh/WQM2Q1Y675mi8DZkKHS+Rts4iedoH9Y7OXEA7V270tLYckfOLjdKW6LHYTV/yHPc
         drb8mxMDYlV0etT+omzRTRnx6Fh3ejyYkwEx5ZA10b0Qmfi/CAg2oGiklbwQjf29YZK2
         MFEVsK2mYpaSqtI3tGXNjE45Z8NKTK4pcQFC4sXlTQj3v0ChVz3rYIP+E84gzCeba4x2
         +OnQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr2EL4cNSDRuES9W3LT44cKTnW1isATwpxYWQCfPztRBv3qDn8or7gj71RikFWYqiZj/r9Gju2xbw==@kvack.org
X-Gm-Message-State: AOJu0Yzm3Hni55H4PfdSkWwSThGm9rYjP14Z1tw0FiunlNl3JAzc9nnr
	PYZ13hmbUnGRJJnRXq8rXLKZ0Zl5wbGZKdaQO5QILEYl1pOP4x2mxFFd
X-Gm-Gg: AR+sD11Wad05SjOiyQ8n8jlivdr64yfONGYr4MEAnDkR8Z1frkmreBGppibFHP4Ycd0
	+D+Ja086kWI5zyA9/jJcMU823RkBTYPVf6AvuJ4ol4JyG6p09WRjs9h07VD9Xyv459RPn8aKUlG
	i58NKZC9T4U49bwQWVOD7+OeOlBIC6f3qbuwh3vxTnn0MC47TqsQIhJ+Q8fF8dLlGWoRIKQjqNs
	B7ePOnK4yW3CwufZQS7+9/5EiwvykpXll9zpYraGmLpUYBvDdAbP/MWm8Mx/hzr6e9qqpcYbUS8
	8xOoOWeHEX7UZREipce5MOdvRv3M+Vt4MkO1zRlu/eQzv7h4urwqHrAVn0xbxkWh0hO2aPb4DmO
	gRoViICkJcKkBSWLi3cL39EjbdallPoLQ2mbO+6T1dOX7PtJowynDsduAeJYEuLKm+lhlDRgnvL
	/0TKLrBI0PwsVV+HAKdVCMBiSC6zbtxTuXm3Ymj9Qz9uA1
X-Received: by 2002:a17:90b:4d90:b0:38e:4e61:c9e with SMTP id 98e67ed59e1d1-38f2aad0dbfmr4574273a91.21.1785091290598;
        Sun, 26 Jul 2026 11:41:30 -0700 (PDT)
Received: from skinsburskii (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f0583bcd0sm3144769a91.1.2026.07.26.11.41.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 11:41:29 -0700 (PDT)
Date: Sun, 26 Jul 2026 11:41:26 -0700
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, David Hildenbrand <david@kernel.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	mm-commits@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Subject: Re: [akpm-mm:mm-new] BUILD SUCCESS WITH UNVERIFIED WARNING
 34cacd0ac7c10dc9e34e1b9f28a2b78d335cb487
Message-ID: <amZU1hH_9IOeO4G8@skinsburskii>
References: <202607251512.KMStVfrY-lkp@intel.com>
 <20260725193155.0e03a382d76a99485ca05cdd@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260725193155.0e03a382d76a99485ca05cdd@linux-foundation.org>
X-Stat-Signature: u748onxa4iiowj9wzkunwr764u68rkio
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C51A8140004
X-HE-Tag: 1785091291-434870
X-HE-Meta: U2FsdGVkX1/I1ENkAFh1HATaX6weTUz14/5N5xsgEZEcjI7TOjAJWgE0nNrsszb/pX4O/V/kHrgO3784YOSoRko9XXKsvJCUDlUpqccjKt54qjTwmPVYeHQrVPkxnI6dZwTvc99cROi2SZW51063LmlY6WErOUKHJgXbUH2AHRfJ5V/4TWjfMc8LlBwB1tjfT9fPu4H5+2EDmbE791xDlY7wlPNe/CHFD+R8GzBSqPqGWHnwatJjAraVEz+oqkxTm1Ct/cZTYwhL0jVBj8sCIG+MgJI6i3sM+mUwYW2f9UY630rLYnWHKkdaDl7zFurNmEqNCptbwAEpW7d6kw79R1Hu9xa7j5Ba+B6/e1BXZA1LZXcf8dFKe4L0DUb/hl2GVY8VeoaQ5Vl+Yb9wz6gtc346vyPZA8QK4YmRGC+O6kV3gb5tcpLtGMNARYm/NOigCIVAZJOg/iJ7eNywrM2/7Jbc3AE48u1Z9i3IjmPAlyFOmiW8X4dPv0Tjv4ANlZxnv6MJfwT94oPj8BuhWyMqvOnB0GOVQUnmIWL2J2hYbzfcxNzz17sAFDKVsm0YmJsiEqtV5BZvirD+c+BJSOiOom/M9Fx7d9jrxtXQ5ldTA4EIe9hOaM8RU/wbAjVKTl7q4CqoB1WUz6UMCUUQe1s1VkmrlVM31dJIaCB7TOjrEKMLw6w8Wm2nogArE1H9rBsCnqJLbNEVSj6JfjT1v7BXZLO4Kdfkv5f49n+pb3HOzlmUhyiPIMOMkgf7mNQLguMZxxrbu5Fp5vcJNSe8hSHN1F3bgBxOjjmQQdJ5DfRORmHaf3sDtQDz8zPIjtDCy33iTUXrkiJAA8ZCD5tcYyryPKSlSOiE0CYxg1x+/l8BOrjqnnvXkNdLs8xuQ9sMvqaGEKIyQO150uYmxU/+CSuGkFFG0wsPAADmvkgKKSv2sKByBtl33hIkR0yLQ+CK4QYyMQHX82SmnaUJtipvIiU
 uqIJ69TH
 8vthwrQNQgj6Sui3t6ulB5kZO1S2FzPMoBbdaydcKm5N+ABaZrRUD+pyg9Gppe1vRcmbSo3hCL5M8UOA+jSXsYweZMq1wEV9nQVG7vUvBfH3oPPl2NabSonYgKMnPbiEsD8XbNKR58m4IzDQipLheguZj+e+/SLv3qmi7ssOjSJsVd8e/m5MG16lTWS+PyuadpJuhPdhiKuZA4Pq1j6brMjY9dLKomxPWSEYRkJuCcnVQbFd4XwV5vowOsw5Ve//QykAZvri3JdDCf2dxYUPzLBI8c4LGZYnUpkslPefyi449C3grhbb90CQGpLxN6Ur3yYTTyMRkjcf7yat2CQh4n5mDhZGWYdFnl8fm03+M8TCRwmra8RMSorCbaxlD8pHghNaVFkMjJKj2YSqQ37cBsCie2c9be76MIEbO/gN6/cOh/XRL74aY/V8Ow068MFe219LZw8a7o3GqWmUmhAE6zm/JAq8uxvl4y/DZzITerFRO7IDy9qx3+Zh9Nw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 25, 2026 at 07:31:55PM -0700, Andrew Morton wrote:
> 
> Thanks.  A few head-scratchers for hmm people, please:
> 
> On Sat, 25 Jul 2026 15:11:38 +0800 kernel test robot <lkp@intel.com> wrote:
> 
> > tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> > branch HEAD: 34cacd0ac7c10dc9e34e1b9f28a2b78d335cb487  mm/swap, PM: hibernate: atomically replace hibernation pin
> > 
> > Unverified Warning (likely false positive, kindly check if interested):
> > 
> >     https://lore.kernel.org/oe-kbuild/202607021433.DYT5fDqE-lkp@intel.com
> >     https://lore.kernel.org/oe-kbuild/202607120402.clBrrZQA-lkp@intel.com
> > 
> >     mm/hmm.c:673 hmm_do_fault() error: we previously assumed 'hmm_vma_walk->locked' could be null (see line 654)
> >     mm/vmpressure.c:123 vmpressure() warn: check likely/unlikely parentheses
> > 
> > Warning ids grouped by kconfigs:
> > 
> > recent_errors
> > |-- microblaze-randconfig-r072-20260725
> > |   `-- mm-hmm.c-hmm_do_fault()-error:we-previously-assumed-hmm_vma_walk-locked-could-be-null-(see-line-)
> 
> With this microblaze config on current mainline I hit
> 
> mm/hmm.c:804:25: error: implicit declaration of function 'mmu_interval_read_begin'; did you mean 'mmu_interval_check_retry'? [-Wimplicit-function-declaration]
>   804 |                         mmu_interval_read_begin(range->notifier);
> 
> And after adding the hmm changes from mm-unstable I also hit
> 
> mm/hmm.c:805:25: error: implicit declaration of function 'mmu_interval_read_begin'; did you mean 'mmu_interval_check_retry'? [-Wimplicit-function-declaration]
>   805 |                         mmu_interval_read_begin(range->notifier);
>       |                         ^~~~~~~~~~~~~~~~~~~~~~~
>       |                         mmu_interval_check_retry
> 
> Both of which can be fixed with
> 
> --- a/include/linux/mmu_notifier.h~a
> +++ a/include/linux/mmu_notifier.h
> @@ -576,6 +576,19 @@ static inline void _mmu_notifier_range_i
>  	_mmu_notifier_range_init(range, start, end)
>  
>  static inline bool
> +mmu_interval_check_retry(struct mmu_interval_notifier *interval_sub,
> +			 unsigned long seq)
> +{
> +	return true;
> +}
> +
> +static inline unsigned long
> +mmu_interval_read_begin(struct mmu_interval_notifier *interval_sub)
> +{
> +	return 0;
> +}
> +
> +static inline bool
>  mmu_notifier_range_blockable(const struct mmu_notifier_range *range)
>  {
>  	return true;
> 
> But I do wonder whether we should be compiling hmm at all if
> CONFIG_MMU_NOTIFIER=n?
> 

Documentation/mm/hmm.rst explicitly states:

"Address space mirroring's main objective is to allow duplication of a range of
CPU page table into a device page table; HMM helps keep both synchronized. A
device driver that wants to mirror a process address space must start with the
registration of a mmu_interval_notifier"

I think making CONFIG_HMM_MIRROR dependent on the CONFIG_MMU_NOTIFIER is the right thing to do.

> 
> And your hmm_do_fault() warning seems legit:
> 
> 	if (hmm_vma_walk->locked)
> 		fault_flags |= FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
> 
> ...
> 			*hmm_vma_walk->locked = false;
> 
> and the blame seems to lie with Stanislav's "mm/hmm: add
> hmm_range_fault_unlocked_timeout() for mmap lock-drop support".
> 

Well, this is the same behavior as in fixup_user_fault().

The fault handler is not supposed to return either VM_FAULT_COMPLETED or
VM_FAULT_RETRY unless FAULT_FLAG_ALLOW_RETRY is set, and that flag is
set only if hmm_vma_walk->locked is not NULL.

In other words, only buggy fault handlers can trigger this NULL pointer
dereference, and I thought we had agreed that we do not try to support
those.

Let me know if you think otherwise and I'll send an update.

Thanks, Stanislav

> 

