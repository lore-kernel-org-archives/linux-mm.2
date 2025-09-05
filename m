Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F38FCA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 20:48:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94FE28E0006; Fri,  5 Sep 2025 16:48:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9258F8E0001; Fri,  5 Sep 2025 16:48:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83B6D8E0006; Fri,  5 Sep 2025 16:48:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7336F8E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 16:48:55 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 16EDD139919
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 20:48:55 +0000 (UTC)
X-FDA: 83856385830.02.4CB1A13
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf13.hostedemail.com (Postfix) with ESMTP id 363562000C
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 20:48:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Q2GSlrrF;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of yepeilin@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=yepeilin@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757105333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0GiODW3jiNFo5GcWlFYzIpqNrxA7Q2Lf72MRDCRU/DQ=;
	b=3mEE9PsOJRA4Idl9XJcaiceTXdEwpPflxv4O1udo4EKMjGeRv8nlKa1y9xakGFLvijNR2E
	1+0mDGn+1wZMlUb8xx4TZCMdsOeA6Otql9q2lU5pjr1OGy0UtParpCxkCp8jwU65dGBE81
	uHeB3hIzVmCCmMn0jHv+JoeohmcJrY0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Q2GSlrrF;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of yepeilin@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=yepeilin@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757105333; a=rsa-sha256;
	cv=none;
	b=yDq46Wwt7SoDkKRiBfFkQKMcu5FujyhT/3/B5hHvGwcSrhnGZyxIytqaR3QaiS65oJKbbS
	qfZk7OZu3pkrCocCKBZTO0C9zRI3nPoqe1TvFD5hxxXMGZeHJuEm075w236kWEwX3/l+fV
	0N0NCr4N3RTF3cFphUWoWvnoCz3Tm2s=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-24cca557085so17305ad.1
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 13:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757105332; x=1757710132; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0GiODW3jiNFo5GcWlFYzIpqNrxA7Q2Lf72MRDCRU/DQ=;
        b=Q2GSlrrF15XrW36mVNrQ7XdTxbwhngu3bcR6vvkDkO6lIvUY4wsAzCd2vMVYfvY1Ol
         k4VsLWKsFd0NhnwY0WcHq+j773MZOT4+ZHTpynkUvVgIK1QPS/6ib81VgHpFAsBNgDnj
         LKGrjiWP7OD+tuthxH1H9HHEQrOXo21mckq8BMiYmTcM2Z/QyO4AQ4sbwxgEAy/wMROx
         WWuVhBORZs6y4dis7cYKLp6XRq2nsiYHSRH384i+As+Nsh7KKQh5t0OJqdaPCtjQiTy1
         PBs+McYJ741af7GQ+u7z5bdI3afSLjZWltPVA+fMI++0gmUBu+kmXQ37TVNqOV3QRug7
         v8Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757105332; x=1757710132;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0GiODW3jiNFo5GcWlFYzIpqNrxA7Q2Lf72MRDCRU/DQ=;
        b=SF1kpDdsx60eAEegQUdiSe4rxwECDDAQ+93RnIBia9jPb4M6rRY7UKRLl1DeHOWfqZ
         smIWg3imxtNqQViRlkT5ooOGmcnb8jYEjFh8pPqsdnm4TO82TqMz47qZU6G/vevMC7Yx
         jt7iUib9m7tZ2jm0EztsH0ZnYtwcqkjvVDmL7syigGewenCQNeu8iST4/Q7lf9VBBCVd
         GoZCYztNsuoKJPDAoaBMX4nHfnAJuVWMhBRdw9jsbeO+KHyAyMblsvS19gFqPCzLseyQ
         +sWufiK7yLf2ZshZ1sxoTiyhX35zo8qOzqcV3JSxrIz7uAzJFoCM6X/4J/L5tgNImE01
         pc3g==
X-Forwarded-Encrypted: i=1; AJvYcCUiFK/PwykqkTzpPu339f/pNF7AUycegRsYClIkPh8E0aI2GhPc/hn3/E7Yk00I37ULboWmBf/n5w==@kvack.org
X-Gm-Message-State: AOJu0YxJuaL5PrHZFNVbMOYIR/rlFC9vSrZhLgLxusyvZznUvfzkGnQQ
	3bVoHm5wDQ55TH9avCjmC3TVHp1dgk17lppR7u4Pd3c0U/OO+qzgyG3R4X9jQjcsnw==
X-Gm-Gg: ASbGncsMyuGE0Mh6AmsDKvjNbKmuyaHTLcxsNzTli5xf5BStncJSa77T4UoTFbvPBbN
	RwUOtkNk2s92KlB879dzw8X101hQcKgK0AtSzq5oAH785zKbxl2pjwqTXr/1wASR7QwuwjroRpN
	R8ooLFeD4ZXqPpIYJ/594BS0Fi4/e4lE5ZyuMb3sEZtgkw6bx14EU310PuI4Pi5qgyFSQWWpddl
	Ea3GK+reN3H+huo8yTS/FXv02Q7+iM/atdDv8izG+lWE6CukvjfsqmZjYZ95RJ+dEb0n6fkmHGO
	bRqJ/k8wOAsylJVGPNA51NB1yr8R4UOtzR1xEOKLZIsrr+wWqUhHoux6W78Sj24OEzmJdKq0aqD
	jXyVqg7l4spQFQPFa7oa4xsoKax+lotw12oFD+/ypfgHy1PNDImauJLPUeftvsuEjJK8=
X-Google-Smtp-Source: AGHT+IGxaodK2oxo1/T0jE66aVjXGi/uDMun6FTCnFGDt00e/yHDWzq7NKgwd2BLevagOtIH+S35aA==
X-Received: by 2002:a17:902:e850:b0:24b:131c:48b4 with SMTP id d9443c01a7336-2517446fa94mr26065ad.5.1757105331740;
        Fri, 05 Sep 2025 13:48:51 -0700 (PDT)
Received: from google.com (132.192.16.34.bc.googleusercontent.com. [34.16.192.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24ced566602sm31649925ad.126.2025.09.05.13.48.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 13:48:51 -0700 (PDT)
Date: Fri, 5 Sep 2025 20:48:46 +0000
From: Peilin Ye <yepeilin@google.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, bpf@vger.kernel.org,
	linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Meta kernel team <kernel-team@meta.com>
Subject: Re: [PATCH] memcg: skip cgroup_file_notify if spinning is not allowed
Message-ID: <aLtMrlSDP7M5GZ27@google.com>
References: <20250905201606.66198-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250905201606.66198-1-shakeel.butt@linux.dev>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 363562000C
X-Stat-Signature: 7ueocmzoxq7t9bijedduputjqw9kqx7u
X-Rspam-User: 
X-HE-Tag: 1757105333-135798
X-HE-Meta: U2FsdGVkX18/ahQC74ve0vPgl/kQi6O8QoYQHoTUkzrq5fXS5+hTSSFcJFmFdaN8Cmzz8g4uVXkGhp7lwrtUPDlAKvB/lzH+q98x5OsSn/ASFPeo+E36x8vrY5zM6LIQy5ZhaysjJ9NoFRhc3n8CBY1hsY7WTYWIWU4bbEktVVF5ADsAZl/4Ml4SOroYTjzPnZUrbrTMKRPOXTuLGzPbhHGXFToSl8COCdlvMJB5Uzf3XQc++W6Xe7UX2LLcGnZvm23Rjxm8GjVLb1eohObHt6MxokF1Nfn/VDfL2PMnsvkr+JhLx7if+iupByPnOAChJYwpH6TM349S1zOEObjRZAgr9o4d8RdgvxStL3/fwL7jLW4zocI0rkdeBZRe+GAgXYDDimYdNoBYJD1U+cpuD7T9du48c/sfvLu7XGRudEF2dMzQC21RNoCg/io5Ha1wnl1yPGj2HFHIoN3smOp0p8+P57sX+XvfyhDAdXcIpCuAgesicubPQQEBbHh/gDP/w5y7jFc+PIcgrK2NiMV1f4c6QBBk8ux0xYukgXE4eyKBbquouit4WeVKb4eh4WuXXiq48XjPstofi/H31NF2LlanNgkQqz5cRm463vtzXCpvS8qP4OYtwhWh7r29SKvJPuERSISJE+u5aBOiEVd5dJOY/u84kFYjAehQHuL8NIE29oRviRmh6s41EgSwoHnGbzhEx+/24S58u/MjrljSzrgBK6eBP7H1LcV5iIgqYbUw3fx+cHW5jQwnPbK8LP6Hg92Rf3H7OmtDOHTArm7ule6b9WUwIjeyf2ryy0+D9vFLbIOLzPefCFPOZo4hb/+KBKXa3RVgP2fJkYwMfonvfhpj3id5cxFsZdmSPskKDIz2vDZjxlN0DgMiHp8li27dB9Yk0Zvatem05VGJFnmgD+sH7QxS8x14x/cIC6xqboNSerYaM5Wo4jWz5VUbp/zpm2ankJsqk0XdPOf8dWG
 LyMzhg4D
 845sdx+1PbYas2xy3My3BuzK9yeAb1t5/DS3q/MacIuo3bj13ihPOnCysvQxUvRLk+z1dgP7oqpqGLhSy82EMGwFzaq3qie23yZZeO+d3G8UhVqx4OjNIDM/ZX4+3htKF4GF0vcLlbfRCo3q506+xd5kbibMUbWbXAx9Se0DA+6XgmNlwiYGxhjar2GgJpQWBB3wAV8BBQDmGYUhVzKoYRJJc/RNBpA/KwJmUwdFIwTZ98oj8qB53FLoD3o5AakXZSbKD7pE8ZmY8fwv3pI6vfGVtMSPmG+FSHPCIs6TjV1U822L1f0/7de2n2ZenciVlww19Bn3jmixmeZgwFAgs0k9Hz3cPg5k+wwRjoxBf3ON/mINK09wJld0D9vkIinxoenPoQyvuAxugJfRK2ftGiEW5R7Fo7Sneq+i/M5vqjy6EB6o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 05, 2025 at 01:16:06PM -0700, Shakeel Butt wrote:
> Generally memcg charging is allowed from all the contexts including NMI
> where even spinning on spinlock can cause locking issues. However one
> call chain was missed during the addition of memcg charging from any
> context support. That is try_charge_memcg() -> memcg_memory_event() ->
> cgroup_file_notify().
> 
> The possible function call tree under cgroup_file_notify() can acquire
> many different spin locks in spinning mode. Some of them are
> cgroup_file_kn_lock, kernfs_notify_lock, pool_workqeue's lock. So, let's
> just skip cgroup_file_notify() from memcg charging if the context does
> not allow spinning.
> 
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Tested-by: Peilin Ye <yepeilin@google.com>

The repro described in [1] no longer triggers locking issues after
applying this patch and making __bpf_async_init() use __GFP_HIGH
instead of GFP_ATOMIC:

--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -1275,7 +1275,7 @@ static int __bpf_async_init(struct bpf_async_kern *async, struct bpf_map *map, u
        }

        /* allocate hrtimer via map_kmalloc to use memcg accounting */
-       cb = bpf_map_kmalloc_node(map, size, GFP_ATOMIC, map->numa_node);
+       cb = bpf_map_kmalloc_node(map, size, __GFP_HIGH, map->numa_node);
        if (!cb) {
                ret = -ENOMEM;
                goto out;

[1] https://lore.kernel.org/bpf/20250905061919.439648-1-yepeilin@google.com/#t

Thanks,
Peilin Ye


