Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35F21CD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 18:03:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1D2A6B0088; Thu, 18 Jun 2026 14:03:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF4F36B008A; Thu, 18 Jun 2026 14:03:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE4856B008C; Thu, 18 Jun 2026 14:03:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 88ADC6B0088
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 14:03:38 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 00211401C0
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 18:03:37 +0000 (UTC)
X-FDA: 84893806116.25.A3FDEC1
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf03.hostedemail.com (Postfix) with ESMTP id E35BF2000E
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 18:03:35 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=TIMHd8YB;
	spf=pass (imf03.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781805816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IA0sYyo4EfGoXUxBeWeWHqK/t1kO9rAsE49hd7e6t5A=;
	b=bfxrAGGxRdiNpOhwzx+7OIey029UQfSfVnyeandmmhynVQuc6oZ00PsU6M0vvRE6Tfqzpx
	w/Hxq1WReeNeGOq9l2hJIUPVBJ60TyBiSgy3OPUnB1Z8q0iAmElQ19W6GpXBGJCrFvt156
	XqlbR4iMnE2zahm/48kT+hmno5gllNY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781805816;
	b=q5RDlFFngsL3r6eo5Yc1BtvcbLPjvO8zwlRv8ZNGxEz0gw2bPHlAJN8+6ehfPC07cJRxuR
	WSDYuPNqmwzaY1oPVyWHrFsS69UGRAKMpQQeevXJx7gFJE0q1ZYNSvnlbd2k62VTuKfndu
	8XcOSjMPQ1Be+hm2CQ01sbItf4TWbL8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=TIMHd8YB;
	spf=pass (imf03.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4921eed3fa2so9808735e9.0
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 11:03:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781805814; x=1782410614; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IA0sYyo4EfGoXUxBeWeWHqK/t1kO9rAsE49hd7e6t5A=;
        b=TIMHd8YBDxl5pBzZXUZxdj9f5aBtBCVcC4enf9MXagqTnhjHx0qmJ2lrmVODe1Hy6v
         s9y1jEoszM57oEQ0VdCv7gZdV2W8Y2GcDiCuQmo/J+tEPTBEJku7jHRBRuwaekIwU4ux
         lmrp80SbiMpZL3qEjPD0U6qlRp9I2uvCrU6Kk2QwXQKDz3cbPdxeawMO9aN4eAQ5FdP1
         pFd4SggkgEXnxjzLAKwNDMiWKAMvn2fcI72out8KR+vOMFnIL8OhjJ5/JhRyeLOiDtok
         fNy2SU8SzEoU9dlhEkTAa1mqaJrf+lYgpttFyf/t3L+9VjAFxiipem26GJFNKm4fF/+z
         bNpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781805814; x=1782410614;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IA0sYyo4EfGoXUxBeWeWHqK/t1kO9rAsE49hd7e6t5A=;
        b=pSwdHWO/09jomZ84b37g5BSOMor0fjl0/9GP4Yk1t7NSPcSnle/qlH/n17EATufzIz
         T3EpoOoMFfNxB5assnBnGe4Y84Z6276okpQxs6VelakRQAfD7cV9nLN7k0fq46el6Pan
         j2NnlZ9Qx+yqxRAhppwjnX5CXWdMEeM/hVs5qn+awmRLj0/6/9roKdZ9Ldeh9UG991IH
         We/itXouPTHJle8m1y1VenpvPnpheSeVnhoypnZo9sHbiWfLxdjG2MN1MPXZK4pHmEG+
         6NelFbAuB8c+FDqicEougB1oPwUp59iOVmJwjuzdkwKoVQiHGk1g5ZkxLgsPvd7bYrCW
         p9kQ==
X-Forwarded-Encrypted: i=1; AFNElJ8cdKi0zZ4V3MH1w8Fk4hzP/7VM/mXtIPVW8MI/VqDN65X2kEWN9Nh93hpdY42reoWSkB5AKw+pjw==@kvack.org
X-Gm-Message-State: AOJu0YweJhd/Q3RkSm/h0kAISF8jbeLJZPoHKuTmlfuOkuh0A7sOjNdR
	zWG9A7pktM4SIfG4lD4LOTXFYNmiVKGuXKSenLwJoSWC+fUzppxS4BYB3QXRLnXosMo=
X-Gm-Gg: AfdE7clMIcUY+SwwAmeHwzrtXvq+1FzoXDB6vNxusaoXsZ6/ESwQ8Jag2bUpxau2ZO4
	AIN9TfHip1f5RLGyS1Uhdl2b/zCylO69bSHkRUKvyR2+nS1qdrJLmiF36zpd/MfX/bbmbrbAk7p
	JmrJsivy8KaSImCKU2u7gImdNHntPcoyH7KjqpjCz2VDzM7k6nfbIut2TD9Fs2ymu2nKOQ++BMt
	Auox32amirzkti9cmaVwABB5wtPJ7fdYtmVV1vgiCuFMZE0U1oMYGYM1d6VACSacAKK8FR70ENt
	lz4pdz/KkwwtC7UmRD5gRaHyU1LAnBhH5ZGsVJ84centYsPQ5/nr6UElvwhuKXcg2DuOu9446fc
	AOjDlA5crPgMzaIJerlnlNYzvwnr6jHxdPcVOogsYHBalwIcS1xxqnMFf6sSK7bgCvzYQwoBIn5
	7iM67BPiRGX1PfuAPZ4VTKZgIKQQ==
X-Received: by 2002:a05:600c:8485:b0:492:259d:567 with SMTP id 5b1f17b1804b1-4923f57986bmr11284415e9.23.1781805814485;
        Thu, 18 Jun 2026 11:03:34 -0700 (PDT)
Received: from localhost (109-81-26-193.rct.o2.cz. [109.81.26.193])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4923fe7b359sm5357325e9.9.2026.06.18.11.03.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2026 11:03:34 -0700 (PDT)
Date: Thu, 18 Jun 2026 20:03:32 +0200
From: Michal Hocko <mhocko@suse.com>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: Re: [PATCH v4 4/4] mm/percpu: Avoid IO/FS reclaim in backing
 allocations
Message-ID: <ajQy9EtOgJQntHOd@tiehlicka>
References: <20260618130414.96383-1-kaitao.cheng@linux.dev>
 <20260618130414.96383-5-kaitao.cheng@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260618130414.96383-5-kaitao.cheng@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E35BF2000E
X-Stat-Signature: rd7yk4zm4r6cnowwqegj68716sugyn7h
X-HE-Tag: 1781805815-577446
X-HE-Meta: U2FsdGVkX185OsfXHPCESy7ydkVy98SYpecdWcRM+DikeihQeEnMjeayqzl8AH5Tv/lC1t74GjLoPbZmrPo6/JlHK3ulFNvtHk22On3rlM7pPgBWFQT6NVXAIXTn2LgojqeNgRCSgoNFdUlKnBxePu9L0EfHDOenySkzWbt4JlmZv/BzWxZfJPnsgfQ86Rkjt74ftLi1FD8KzKA8bMha9PD493IVZk0Dctb0l/iy5SLlIbIHvbcxox7nN68QFT6TC/l0u5Z+f4HI++av4ElL+YyaHXMtTfmKXmtaqPJQLfOQQZrg9Xr/8SLz6cNmHA9u55ED3KNuGR/exjUcjB+ZSJIECDebCvRHamlCU2GKPkfPgKMpO7oOnAV+z8RfKuz1b8ec/IkPUmmM+5YFPRO9m4tHzOtuy4IG2tcSUk8grd8eR3MSUEQNYnfv4MZ0P2iyowp5qeJk8Y/Jm+Y180WgV3j8ZKATh+Iiskdj2DMLD/YlAIz2HHPz032TWt9YTpifE+TraWnSec9zdPN2x9yWbfp08/PvsgI61gJzrpV4nzrU5uY3eOrtriIql7B+GYGpQF0OaG3bzNqfdIjqZOgJul9MA4CDMKj6fWSDYl4y46PZQW7q2jvBpYXPl3akQlghpRkb3rgLomnhQgsB6qd/wt+pfGjpstS4NyFAlEcW3Gr6c7NgXClOqfwRLG+NrBfn9iFJ5aQzY5izMXBeKvRPISvsRf7+yrg85z4eu7JO8Ul3TO7UFwXpVzwK3WpnVHjrlt+TpQ0c4Af37Bm1N7o3UoUTO58qn2py5/LZR8aX/3tOjHuW3m+z6NdRgJde2B7aaZEfLzNgC9o0+aC/MXI+qYTA27B58uCvJLMTXFH+7Erbj2Z+d/jA7VcS77XNTAENcVL6kkWk+LAVXcWb6cvyOeNNJbZL0kvAkkuXHbG5aijq9LsLXIlcdw63XTE2cccgFZ4yIxvCO9KThOEK5l/
 Awb6c0bH
 9Y6oM06/noYJlnSHk/OkBoRaEO9VHMWE2LWe8hpptPK2BRMCqCnTgnQuNssu9Prcq/3IT2MgnYfSXG8LaxIZjeuf1MA4DZcIt8lMmxrJlAf97ILuuIHJZl+08/S4DLijZ8hWOiNK+4Qf2j+XX1Bgsixz9GB0+jz4gFAC4kVMwd0lBxJXJQZWYF+u8iZycYDA5Vc0kO6rGfugGL9Yod+KHVWGJKRDnRiXTXfAk/ylHf0TjoNI1wRvj4F1i2+Srijd0BgEkAyBf4HQ5gFHhoq89ntZahLGA0t3QoIdQQ17s9Wcmr/UAuguD0s7eDK/huIMpduFVpd2jTPjigrWe4DwLZ1GZdqpL11wivO/u0DkLXvDzdLhsf8K14VbywzaIIbTBrSg6/qoBSH29QGrQDadBF94vV7RvsgjZz0Ii
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 18-06-26 21:04:14, Kaitao Cheng wrote:
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> 
> Commit 9a5b183941b5 ("mm, percpu: do not consider sleepable
> allocations atomic") allows sleepable GFP_NOIO and GFP_NOFS percpu
> allocations to take pcpu_alloc_mutex.  This avoids premature allocation
> failures, but it also makes the mutex visible to callers from constrained
> IO/FS contexts.
> 
> Thread A calls pcpu_alloc_noprof() with GFP_KERNEL and takes
> pcpu_alloc_mutex. Since the internal allocation is not constrained by
> NOFS, it may enter FS reclaim while still holding pcpu_alloc_mutex,
> creating a dependency like: pcpu_alloc_mutex -> fs_reclaim -> FS lock
> 
> At the same time, Thread B may already hold an FS lock and then call
> pcpu_alloc_noprof() with GFP_NOFS. It will try to acquire
> pcpu_alloc_mutex and block, creating the reverse dependency:
> FS lock -> pcpu_alloc_mutex
> 
> This can still form a potential deadlock cycle.
> 
> Avoid the dependency by restricting percpu backing allocations to GFP_NOIO.
> The public allocation still uses the caller's GFP context to decide whether
> it may block, but the internal memory allocations performed while
> pcpu_alloc_mutex is held cannot recurse into IO or FS reclaim.
> 
> Fixes: 9a5b183941b5 ("mm, percpu: do not consider sleepable allocations atomic")
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>

This seems like the only viable short term fix but long term it would be
really better to make allocations outside of the lock.
Acked-by: Michal Hocko <mhocko@suse.com>

Minor nit
> @@ -1749,8 +1748,17 @@ void __percpu *pcpu_alloc_noprof(size_t size, size_t align, bool reserved,
>  	size_t bits, bit_align;
>  
>  	gfp = current_gfp_context(gfp);
> -	/* whitelisted flags that can be passed to the backing allocators */
> -	pcpu_gfp = gfp & (GFP_KERNEL | __GFP_NORETRY | __GFP_NOWARN);
> +	/*
> +	 * Allowlisted flags that can be passed to the backing allocators.
> +	 * Backing allocations under pcpu_alloc_mutex must not recurse into
> +	 * IO/FS reclaim.  Otherwise a GFP_KERNEL caller holding the mutex can
> +	 * block on reclaim while a GFP_NOIO/NOFS caller holding an IO/FS lock
> +	 * waits for the same mutex.
> +	 *
> +	 * Do not pass __GFP_NOFAIL.  A small percpu allocation may need many
> +	 * backing pages, making nofail reclaim too costly under NOIO/NOFS.
> +	 */
> +	pcpu_gfp = gfp & (GFP_NOIO | __GFP_NORETRY | __GFP_NOWARN);

GFP_NOIO, NOFS are negative masks in the sense that that are lacking
flags so the overal intention would be more readable IMHO in the
following form
	pcpu_gfp = gfp & (GFP_KERNEL | __GFP_NORETRY | __GFP_NOWARN)
	pcpu_gfp &= ~(__GFP_IO | __GFP_FS)

>  	is_atomic = !gfpflags_allow_blocking(gfp);
>  	do_warn = !(gfp & __GFP_NOWARN);
>  
> -- 
> 2.50.1 (Apple Git-155)

-- 
Michal Hocko
SUSE Labs

