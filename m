Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3040AEC01A2
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 08:01:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55F5A6B0098; Mon, 23 Mar 2026 04:01:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50F256B0099; Mon, 23 Mar 2026 04:01:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FEC56B009B; Mon, 23 Mar 2026 04:01:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2FF7C6B0098
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 04:01:56 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CD8A6BC33B
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 08:01:55 +0000 (UTC)
X-FDA: 84576584190.26.AF9B33A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9901C40008
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 08:01:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cMagydKI;
	spf=pass (imf11.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774252913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ro+dI1rVslz2A4EMJRdKgBDV6ykDd3GWRMG35AhNJtw=;
	b=KdBQJxAcze9tnKTHsZK0b+Lb7bvpsaFsccFXCtiDdTMUtvN7GRt0CxXn5ayGJR8fMAvVNS
	y88SMsoY9e7EjbjfggnamP6cyFIPw0LOZEOyAG72Qkv2lgtGc5ij+NobCogUjbLJUiXSDq
	ZLpFZBaRfIOvQjHK4q/FWfhoVOQ8O4Q=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cMagydKI;
	spf=pass (imf11.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774252913; a=rsa-sha256;
	cv=none;
	b=LtyRqyVJ5CHi05kILgTfpxTo5FQjGo+JtwhVeALS/Dz+8jCDV5rJDaFnEjueFZ2uj7V9+5
	0y9e7TBgxBT/ihE2K1U4I2iJoCmX5v6BabLTv8+rtwDd+erDCz072a41A9oKIxNSPdlf6s
	GpaRCb7ekyC7qWxYIw6e5SVPpIoTumk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774252912;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ro+dI1rVslz2A4EMJRdKgBDV6ykDd3GWRMG35AhNJtw=;
	b=cMagydKIYMyBNDsCnFK/MRoiI77jbIRU191MHcoM1KcSYqIfJMClRPCQanUi+Lsdu+2kd5
	C+T6/4YvY05VJs/DYv27aekzzX8toqSPQHJlkt+dY9c3amz7MUeUM5pbV+Uu/1LkP/YGQ2
	9X8OcSEolRMo12JSpFbkA29nfulFKnY=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-651-SdZ4DqldNf67ZFAWvZpztQ-1; Mon, 23 Mar 2026 04:01:51 -0400
X-MC-Unique: SdZ4DqldNf67ZFAWvZpztQ-1
X-Mimecast-MFC-AGG-ID: SdZ4DqldNf67ZFAWvZpztQ_1774252910
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-82a61300179so2186553b3a.0
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 01:01:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774252910; x=1774857710;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ro+dI1rVslz2A4EMJRdKgBDV6ykDd3GWRMG35AhNJtw=;
        b=IQX/rVl5Z1LjmJewMxbXPxPPEMXFi1Urw5DDbz2nPfeQreNU0K7gODwVfS3RF9NocQ
         C+31pD2yloSX820mcr51EFRJvon+vHuqkmvYB+p5b1DNkKv4nplRgE/dqZxWCWFcS8PL
         HSZtAK2dpqsDNEEImAMEGpfG03I/v05fSO9YgN4bYk0gddjflE+Z2O2sKh0JLYQa6um8
         iQ5DHFSIfuJgYav/OCzoD90zBev0B0fbvr2Mg5FoRZBCkW4D5NkGSk2pCCnFR+bL7IGn
         r87l6IlB26lvfFXr+z6eDrTuSBm4rCx5+bMx/hH3XMiqlRJYS7kzbhUH3EuMJLDcvWrY
         EJSA==
X-Forwarded-Encrypted: i=1; AJvYcCVMLL2wNX1V72Si4qTvPloZ02vgD7ZQKXTccXanoPoPvmJM1tpZNiaaHyFHc8KmO/kHOgz3vHWMLg==@kvack.org
X-Gm-Message-State: AOJu0Yz6ZpmarSB8GxZaajV3vQ/5wqCbCm+JOUnEhTbKkeDV9XulT5IU
	9ZdAWqhRA+i4nHUL8nQ0FJxdFQg2S5co72sXor6LTJaDte7qHaQ6sY3a18coHHg4P3D5GMrnqRi
	jto2lOobNe2AfjAdrzbotOuuYNcHjlpZF163ZULKEiMTmVGrPzuZl
X-Gm-Gg: ATEYQzx+qjD2gGwqh6FStkfYJu0RSKQN6P7dG2jZNB0hNPoCBzqhOOIOYDrh5Hl+Otd
	DImjCaNuV0ByYGcYm/zYzMhu0k4qAB1YYNiMMG8xvrdm/bEVo7ygHCOL09AUJexMjtT/m7gwasK
	ZbWfJOnNCdgw3Xv6+SfVGR+JhwsnuoShGHp9XSDxbU4fvu5XBAFuZcOTBWNkvJs8EOnCWOtdFKB
	L9WRF+WSizShcPzfJ1/vHtbIqQVAR3zsyRy4Cbmx3m3J/x104r386swgYx/kMhNSQI+WYYdca2T
	6v/YLAjsBTfx5L/q8okS4v8jVevAkGUOULP3eKI+SDVRvTTKYYiaZxLms/c/BKD8Tjtj0rj60XA
	XKZWcmvEIvvfUJTUp4Q==
X-Received: by 2002:a05:6a00:228e:b0:827:26b0:58d6 with SMTP id d2e1a72fcca58-82a8c334b58mr9632686b3a.47.1774252910139;
        Mon, 23 Mar 2026 01:01:50 -0700 (PDT)
X-Received: by 2002:a05:6a00:228e:b0:827:26b0:58d6 with SMTP id d2e1a72fcca58-82a8c334b58mr9632636b3a.47.1774252909675;
        Mon, 23 Mar 2026 01:01:49 -0700 (PDT)
Received: from redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82b0409bf65sm8649474b3a.34.2026.03.23.01.01.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 01:01:49 -0700 (PDT)
Date: Mon, 23 Mar 2026 16:01:46 +0800
From: Li Wang <liwang@redhat.com>
To: Waiman Long <longman@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Tejun Heo <tj@kernel.org>,
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>, Mike Rapoport <rppt@kernel.org>,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	James Houghton <jthoughton@google.com>,
	Sebastian Chlad <sebastianchlad@gmail.com>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>, Li Wang <liwan@redhat.com>
Subject: Re: [PATCH v2 4/7] selftests: memcg: Increase error tolerance in
 accordance with page size
Message-ID: <acDzaouBPCIpB7Ij@redhat.com>
References: <20260320204241.1613861-1-longman@redhat.com>
 <20260320204241.1613861-5-longman@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20260320204241.1613861-5-longman@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: NLHZTF74T2t_FFAqtiLl_3PkfnDA2kNDtDRVcVsGJT4_1774252910
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: rg3kcfyaxy5dg5jhshfachjcmx5iigmm
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 9901C40008
X-HE-Tag: 1774252913-575509
X-HE-Meta: U2FsdGVkX1+Fw1MwYIUdhuqfBp86S6l+Kuo0GV1+RPDHqGXrz5tm5HEeJt997Y6lzkCwRqBg1aN0wbhPyOIdf+3Fz4VnUjHfVr4P74QCQNMy87uEGFK4PgHEhgixJC/G0+aWQmTLz1OVKgpINkV18PP1QBd9UUVQlTCMG2iHzDyAyU8zQSf7IHcKAy/h9dJBurz8Qjbr/IJCvyRrYTvqbb0oy1w7WhJMOj9UWrBR26tzvSG+CgWknFPxojdSetcet0gQgkyxQ9lqdZ5m2FlNmMdhyCgIOAbDFF7jkbxklxsSuzQcew3gm5ujNaqGpcpYbfGxFgPg9+A4l+J2V8EcKWahlK6NErX9Anh4MXUuUCVB5UW54Ow9Xp/KS8aJpnMJrq1iNlTsWImdKLGPY6d0YhKnWLL0YW/c9/78O5tEhquQ8BtgYhH3A48qHKd2ZbuFI834HEhYIu+MZ37oLddlqCRkWbNfgkEVy24/nmdBN8NBmKoQiXkO4C3DIkrHgGVBHMp0HZHc0lbBS3B85foZI7e8guakCwpvNMhqCXN2sxqEkF5DNmZoDFZWPC0rep85/iFMLP4o+lnd7EU6TLTJjShthlRF45Ny1iWPMoMYXyxPDx1/XuBJyTcMR1FJjoxZAv+b/p0ytilOFOlgt2JIle/Xf+4p4LzKWQlEW3KHFYvp30BG9lcIlqprXK/7br6BceR9Eig+yxf1Wfl0Ppw9ErYqu7NLqJMZ8xjhiqQw0r+9CIMOWTSIbieEFYPWRubQosBia/E+YEL6ivkCqsYUgzjORVnGUeVgRbqLPw/RYC33kzXylw4hdGMq+XEMmSjQMM8UWFFr6M3OW/EX9UuMujsgpuXrOwh1AP7xgFSN73tEnVcNbJ+AVv+5uZxlgLvsW/8CRdgeiBTumofvMuQ1WC0CmQJHLrRYarRDKfkomw4MUzcDZotZDIYT4DRJ7YdRSu56NVMcwjDsHUMUwDT
 wZPaLQI8
 Xe/uDG7GUisyBICUlYeJf3Pc7JykPPpy+P4iRhM4t1KAeKyf5UG9qwJSUN40gO5DTGmCHnbU0EmITu2V25nSZkmMTc8O/rr97WLIbGQWzcGuhm29YlTOvE4mbV+Wf1tkxyHHTcGZbgUd0cgzhnHAhwM8Mlwv2v9RJHb2oGtkJ7VDC0hjTj56VBvyZF74z0AmeVP0MG8RbR4gLQxAIN+XHkLxpUyEypvr9p94Qg5yJ/sYLcdyo2ofJzslaHDwS6rywFsKDFvQt+UYmHlaPz54MJX5NRxtjsKH4/62H14rxd1Yl6E9k6YB0EJdEkyYwVtutMxjt/sO2lsfyKII5vEvJr1nP8nXOBZ3R8at1957doeAdk9wml68au3GpixW4P9nf/tyLpzYU7EvuGksYC9gPiHKCgQrHgSB5b/qiWsEMWe0hJ/JNsQBw+r5qr4GSFy6hy4g7muNls5tIRB2i5LnGwmdJBjGmPTKlyfBOBqtK70XgWKWIOPvKIEB5FJ1WchQlh/jFYF/MYxIlZZw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 04:42:38PM -0400, Waiman Long wrote:
> It was found that some of the tests in test_memcontrol can fail more
> readily if system page size is larger than 4k. It is because the
> actual memory.current value deviates more from the expected value with
> larger page size. This is likely due to the fact there may be up to
> MEMCG_CHARGE_BATCH pages of charge hidden in each one of the percpu
> memcg_stock.
> 
> To avoid this failure, the error tolerance is now increased in accordance
> to the current system page size value. The page size scale factor is
> set to 2 for 64k page and 1 for 16k page.
> 
> Changes are made in alloc_pagecache_max_30M(), test_memcg_protection()
> and alloc_anon_50M_check_swap() to increase the error tolerance for
> memory.current for larger page size. The current set of values are
> chosen to ensure that the relevant test_memcontrol tests no longer
> have any test failure in a 100 repeated run of test_memcontrol with a
> 4k/16k/64k page size kernels on an arm64 system.
> 
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>  .../cgroup/lib/include/cgroup_util.h          |  3 ++-
>  .../selftests/cgroup/test_memcontrol.c        | 23 ++++++++++++++-----
>  2 files changed, 19 insertions(+), 7 deletions(-)
> 
> diff --git a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h b/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
> index 77f386dab5e8..2293e770e9b4 100644
> --- a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
> +++ b/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
> @@ -6,7 +6,8 @@
>  #define PAGE_SIZE 4096
>  #endif
>  
> -#define MB(x) (x << 20)
> +#define KB(x) ((x) << 10)
> +#define MB(x) ((x) << 20)
>  
>  #define USEC_PER_SEC	1000000L
>  #define NSEC_PER_SEC	1000000000L
> diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
> index babbfad10aaf..c078fc458def 100644
> --- a/tools/testing/selftests/cgroup/test_memcontrol.c
> +++ b/tools/testing/selftests/cgroup/test_memcontrol.c
> @@ -26,6 +26,7 @@
>  static bool has_localevents;
>  static bool has_recursiveprot;
>  static int page_size;
> +static int pscale_factor;	/* Page size scale factor */
>  
>  int get_temp_fd(void)
>  {
> @@ -571,16 +572,17 @@ static int test_memcg_protection(const char *root, bool min)
>  	if (cg_run(parent[2], alloc_anon, (void *)MB(148)))
>  		goto cleanup;
>  
> -	if (!values_close(cg_read_long(parent[1], "memory.current"), MB(50), 3))
> +	if (!values_close(cg_read_long(parent[1], "memory.current"), MB(50),
> +				       3 + (min ? 0 : 4) * pscale_factor))
>  		goto cleanup;
>  
>  	for (i = 0; i < ARRAY_SIZE(children); i++)
>  		c[i] = cg_read_long(children[i], "memory.current");
>  
> -	if (!values_close(c[0], MB(29), 15))
> +	if (!values_close(c[0], MB(29), 15 + 3 * pscale_factor))
>  		goto cleanup;
>  
> -	if (!values_close(c[1], MB(21), 20))
> +	if (!values_close(c[1], MB(21), 20 + pscale_factor))
>  		goto cleanup;
>  
>  	if (c[3] != 0)
> @@ -596,7 +598,8 @@ static int test_memcg_protection(const char *root, bool min)
>  	}
>  
>  	current = min ? MB(50) : MB(30);
> -	if (!values_close(cg_read_long(parent[1], "memory.current"), current, 3))
> +	if (!values_close(cg_read_long(parent[1], "memory.current"), current,
> +				       9 + (min ? 0 : 6) * pscale_factor))
>  		goto cleanup;
>  
>  	if (!reclaim_until(children[0], MB(10)))
> @@ -684,7 +687,7 @@ static int alloc_pagecache_max_30M(const char *cgroup, void *arg)
>  		goto cleanup;
>  
>  	current = cg_read_long(cgroup, "memory.current");
> -	if (!values_close(current, MB(30), 5))
> +	if (!values_close(current, MB(30), 5 + (pscale_factor ? 2 : 0)))
>  		goto cleanup;
>  
>  	ret = 0;
> @@ -1004,7 +1007,7 @@ static int alloc_anon_50M_check_swap(const char *cgroup, void *arg)
>  		*ptr = 0;
>  
>  	mem_current = cg_read_long(cgroup, "memory.current");
> -	if (!mem_current || !values_close(mem_current, mem_max, 3))
> +	if (!mem_current || !values_close(mem_current, mem_max, 6 + pscale_factor))
>  		goto cleanup;
>  
>  	swap_current = cg_read_long(cgroup, "memory.swap.current");
> @@ -1684,6 +1687,14 @@ int main(int argc, char **argv)
>  	if (page_size <= 0)
>  		page_size = PAGE_SIZE;
>  
> +	/*
> +	 * It is found that the actual memory.current value can deviate more
> +	 * from the expected value with larger page size. So error tolerance
> +	 * will have to be increased a bit more for larger page size.
> +	 */
> +	if (page_size > KB(4))
> +		pscale_factor = (page_size >= KB(64)) ? 2 : 1;

This is a good improment but I still think the pscale_factor adjustments
are a bit fragile, each call site needs its own hand-tuned formula, and only
three page sizes (4K/16K/64K) are handled. If a new page size shows up,
every call site needs revisiting.

How about centralizing the page size adjustment inside values_close()
itself? Something like:

    static inline int values_close(long a, long b, int err)
    {
          ssize_t page_adjusted_err = ffs(page_size >> 13) + err;
    
          return 100 * labs(a - b) <= (a + b) * page_adjusted_err;
    }

This adds one extra percent of tolerance per doubling above 4K, scales
continuously for any power-of-two page size, and also fixes an integer
truncation issue in the original: (a + b) / 100 * err loses precision
when (a + b) < 100.

With this, the callers wouldn't need any changes at all.

This method is inspired from LTP:
  https://github.com/linux-test-project/ltp/blob/master/testcases/kernel/controllers/memcg/memcontrol_common.h#L27

-- 
Regards,
Li Wang


