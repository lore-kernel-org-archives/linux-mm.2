Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E0CDFF8875
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 13:25:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7CDC6B0088; Thu, 30 Apr 2026 09:25:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C54C76B008A; Thu, 30 Apr 2026 09:25:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6A896B008C; Thu, 30 Apr 2026 09:25:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A61DB6B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 09:25:41 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AB168C4980
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 13:21:48 +0000 (UTC)
X-FDA: 84715284696.11.0D3B0FA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id B0E08180013
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 13:21:45 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FU5d1VAR;
	spf=pass (imf24.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777555306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RqyhJSBH3U/dz2zZH51faGzShfNGK8OLcWgd9e7sk6I=;
	b=JzAWSaNDQIHz323l7tz35CtsaodsEWJtFQqUFya3+H5BwPFEp5iP9tZ8mYLgnJpx81L0Hu
	qJt78kXbL5bfXBC9SmOFgpRHwNbmDqrrh8n6BWceNKH/rGbJSToQAHLJhVhLUilMBXvB8p
	k9Edg/jdRm2lDZmSZ94SZq29p43JJZ0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777555306; a=rsa-sha256;
	cv=none;
	b=ma129rBXrCFHfRJSDZFr2Xa35T2Jx1lDyOFsgMVHbXm91WAJYqTODKV2EhAn8krEkUA9LQ
	wNwAz/eA9FjgsoENqQbg19SaxR0SSBgt02rhEss4W0sXaZhrVzds8PVrN/8K9O+Pm4dPeh
	5E2SKzUgjdGgzh/nc6kkS7A3eOeNpo8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FU5d1VAR;
	spf=pass (imf24.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777555304;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RqyhJSBH3U/dz2zZH51faGzShfNGK8OLcWgd9e7sk6I=;
	b=FU5d1VARum3RmSIUCiztZ7llt3RCoTidSsPbKEMfbz/PFURypQnTiUlCOIy8CZChbmUK2G
	jpGUtVJdzxzGw2mxgf7xrr402HqFm93NppUMJmohQKOhDDWlit/JkIcsLEwH1qP1/S1OW0
	rgjdyp22Qp5GVWJvz7xTkWynbx5BwuY=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-292-PhrnbL3TPcCbIlOkpat9uQ-1; Thu, 30 Apr 2026 09:21:41 -0400
X-MC-Unique: PhrnbL3TPcCbIlOkpat9uQ-1
X-Mimecast-MFC-AGG-ID: PhrnbL3TPcCbIlOkpat9uQ_1777555301
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-50da31af14cso17416051cf.1
        for <linux-mm@kvack.org>; Thu, 30 Apr 2026 06:21:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777555301; x=1778160101;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RqyhJSBH3U/dz2zZH51faGzShfNGK8OLcWgd9e7sk6I=;
        b=qdfAsk1ElsQaYsRz6zmkSXV1ANHVSOSNNk4PE7Alc8d6reB4gktzOega7nUsEHFFhc
         MJ9QuPwM+0p4xyIJMUnX8yQWysBhf1D1Ako05g2xwsgUlqepTSeRbZlwbdCvq9B/95IB
         x76Gv0MYUQpKQvPfgWsWTO28+pXsou7dl1bI7piOEqT8AJT97vXcem5qq3GJTYOsC/qL
         r3TdHfbNUST7PFlPs7z2KD8IrOOaWeCUbMoo4exoVjGT+fIt09gJvO+eQ5Lsnh+vxcIJ
         RWzqZIZlp05weXZtZW9vDCPq9l8orZr1H+rWEDAMqvUQR2LllZxXzF+BWLoW4hAk98fX
         8lbw==
X-Forwarded-Encrypted: i=1; AFNElJ/hmGQ1wxE0a4UfDGs+iuFRIU4s0RW9Qn55X8K3YtBxV0vAqdNiWsKd8x9FKUfgXzHiIpdNEJBTTg==@kvack.org
X-Gm-Message-State: AOJu0Yxb/ORFVqpoSUQuMHJ7d9tZqCMxPIeSnspL5r5dsU8m5RytQMFH
	SimyIaHECDQu7+wIPnyEpps45Qgi6jrvGRs0ckn9zEahIBDUHFEu3ZWxfAYq972wRoRLkz5PxJ/
	2L9FiqdoXJxfdOddoiKYzm8ZG9gvXomn9P2tdF4F1x9bxFKSNszWm
X-Gm-Gg: AeBDietvJ4vlcB3oLJIVZjGLjeUVyfBttMuYgIlfpiL6vJPtk6VoqMLKXV6TsimC+wv
	u6oPjf7cl5OKcS+arb9DAkkh5MyDeEIgnoQwvb/1rsDwFxhklSsyyMDF0WooGWJu3t/pUTg30ia
	Yp5KS60cedYBnIMDNbh71kEIyG8Qd4rqd8qZatHtoovhcqBEGXddkGRrXbrhzOHfas33RSkIdNE
	JO/XC3R8JbooV8H+tDzitv9b190/PiKOOd0yQ436P5MAXBcOOsU1ZhuvhGgS3iKVFbwVdoYqtIN
	GP0YhNf+3XAOab4lmqx2XF57PWRpmojPiSTFXPCe60rIp9bR2ibNgFoZDtrVeo6J+GF2cIv/NQM
	yBiPxKPRKoDKVvC/SDZtpdJiq+JoNzmrlWCY=
X-Received: by 2002:a05:622a:248e:b0:50b:5146:8803 with SMTP id d75a77b69052e-5102ab41a36mr37911281cf.21.1777555300880;
        Thu, 30 Apr 2026 06:21:40 -0700 (PDT)
X-Received: by 2002:a05:622a:248e:b0:50b:5146:8803 with SMTP id d75a77b69052e-5102ab41a36mr37910491cf.21.1777555300284;
        Thu, 30 Apr 2026 06:21:40 -0700 (PDT)
Received: from [192.168.2.110] ([70.53.202.134])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5101ae3c0b9sm49981021cf.19.2026.04.30.06.21.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2026 06:21:39 -0700 (PDT)
Message-ID: <a9864510-ddd2-46a6-99d8-8d7851c187c6@redhat.com>
Date: Thu, 30 Apr 2026 09:21:28 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/54] selftests/mm: migration: make nthreads represent
 number of working threads
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lance Yang <lance.yang@linux.dev>,
 Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Mark Brown <broonie@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Nico Pache <npache@redhat.com>, Peter Xu <peterx@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Sarthak Sharma
 <sarthak.sharma@arm.com>, Shuah Khan <shuah@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
References: <20260428204240.1924129-1-rppt@kernel.org>
 <20260428204240.1924129-4-rppt@kernel.org>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <20260428204240.1924129-4-rppt@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: goGY5jpM7H3qkohMaPtFm1OUfjxEeoYbnYerr_OgDfc_1777555301
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B0E08180013
X-Stat-Signature: 1re3n6bke6hmuxsqe8qtiufrooksacef
X-Rspam-User: 
X-HE-Tag: 1777555305-181854
X-HE-Meta: U2FsdGVkX1/t1kiRD/x2+5Km6Sy8000mqttFTD/rlCtkzlpPqtUHxk4TirqWktGv5D56QMIPn93ucXjYm/tTY3ou2cWrVxLhE7dT21QkZQwNM+GWH8RR+qRhal1Re5nQNqCXA0asPhyGEnS5EqhMTiimlZmtAtcyCtzCtxngBW9ijyiN4um3K8tSUj0IVIJSDhV619p26Q0/B6dFtWD5I34q/Sdkd221/szjZMClQ7zudZ0DZK4w/Uu7Q9kV0ik+AR4HqWZ9X/jtkW5P2b2FQbX/lgM0nphUNJdlaFdGO0AL1RqpImyQUDKhmWirtYFe9p/fXMvYdOwo9RSKNJAp6VU13nlzWVz0XeCtwxwmccJDrG5R6mTLspLsmxaV+c2Us46zXeV7UbIDNuXHxoQ4cvjU8BT2aoocOH0WEm49d3WvTyrpjIX8VJPEdN6rQw8IcyvjX65GvddGADPYsyJGCWqka92aKnlULTW3ReN4ngg4S+5zyDONugXn6cEokjc7qo2AflUSK1a/BqrV6kglEBD4USXLdhJWSmx0eyb6BqZeqybr28GnXLmnFKiuhi2sGUOobIPivP6f5RyqEUjJwqAQE5XfMu2TAU4uXIljmIo7qYm/ep5WPzXretdidb98FsZEc2pZJwP8/R8qL3Z6IXXPFQtzZHEyx0XsyNPMKCza0099h2DukVlGI3eVmHNVNuFoL+O57yJnMh1jtR4jleAyq1ReKTcQ/vmzD5h7j2vOeGGdYejoPKeYHbbazc+mnm8FGDiEKSh/WlBiyjeIIYp2xaAUvVcl6nAcJ1iJ/8cRWXwSXSzGm+6Z9XMC8Pp0EldAT/y7sjroKu10nq+KV2FCRe63O9HtliJ3GveD+3kjFNiQrmiG+45TxJVXpiQiIDH+f4vJBDWB0nSCVXSCxk9C7Xq7EEjqNKyj+3XuexlqjRz+zwk9pecewED0sfz+pQl+hrSSe8SYwDYFo2j
 Df049V7d
 SgEibfBY4dqX86WT2XS14kNvaNpEl6Ah63xhVEtSrKsEZsQTGlNG+WfQ/mvYt1AKi+j4feEbZ+mExWvp3Zq99+sus4zWbspObqDoEyER5cn2Y/1b91xNiavm32jb/GdBRbTsR1/r5XLyBr6cKsxkb3LI1DWHIhhi0QS+ZRZczrsVOVQy/+8EXeL540qIVVqi+JmlmySVJpz+/iiEtjJxYTxgGsL0GUppYBUjHzIkhMYSLSZ0uWA1i7rQsmAtxfDB+jZfIICrNgHAmNj3EWpqtU+BwoWBZfSMBmeZTZZqj98bf1P2/qK/ymaFoBI/x/oDhZirs9boAQWg1kqkhEmUEVmJL88vZ+zOhImPx0kWxZ9Y7wvR0ntM47DMdexv88rJAKOdC6CPhcU5+AvbqADsU9X1V34ocPY+u9Ox/wb9BHgY3RWr76wAaUdvtzrWnmaGF6MQ7cN8Zgt16Fz+xsKmWO8CLxNyMTCVIGm9o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-04-28 16:41, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Fixture setup sets self->nthreads to number of available CPUs minus 1
> and then each test creates 'self->nthreads - 1' threads or processes, so
> essentially nthreads counts the worker tasks and the main task.
> 
> Make nthreads represent the number of spawned tasks to simplify
> thread/process creation and teardown.
> 
> While on it, make the fixture setup skip the tests if there are not
> enough CPUs or NUMA nodes instead of checking this in each test.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Luiz Capitulino <luizcap@redhat.com>

> ---
>   tools/testing/selftests/mm/migration.c | 47 +++++++++-----------------
>   1 file changed, 16 insertions(+), 31 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/migration.c b/tools/testing/selftests/mm/migration.c
> index 7e547d945e1a..3630f2fb0800 100644
> --- a/tools/testing/selftests/mm/migration.c
> +++ b/tools/testing/selftests/mm/migration.c
> @@ -38,7 +38,7 @@ FIXTURE_SETUP(migration)
>   
>   	if (numa_available() < 0)
>   		SKIP(return, "NUMA not available");
> -	self->nthreads = numa_num_task_cpus() - 1;
> +	self->nthreads = numa_num_task_cpus() - 2;
>   	self->n1 = -1;
>   	self->n2 = -1;
>   
> @@ -52,6 +52,9 @@ FIXTURE_SETUP(migration)
>   			}
>   		}
>   
> +	if (self->nthreads < 1 || self->n1 < 0 || self->n2 < 0)
> +		SKIP(return, "Not enough threads or NUMA nodes available");
> +
>   	self->threads = malloc(self->nthreads * sizeof(*self->threads));
>   	ASSERT_NE(self->threads, NULL);
>   	self->pids = malloc(self->nthreads * sizeof(*self->pids));
> @@ -127,20 +130,17 @@ TEST_F_TIMEOUT(migration, private_anon, 2*RUNTIME)
>   	uint64_t *ptr;
>   	int i;
>   
> -	if (self->nthreads < 2 || self->n1 < 0 || self->n2 < 0)
> -		SKIP(return, "Not enough threads or NUMA nodes available");
> -
>   	ptr = mmap(NULL, TWOMEG, PROT_READ | PROT_WRITE,
>   		MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>   	ASSERT_NE(ptr, MAP_FAILED);
>   
>   	memset(ptr, 0xde, TWOMEG);
> -	for (i = 0; i < self->nthreads - 1; i++)
> +	for (i = 0; i < self->nthreads; i++)
>   		if (pthread_create(&self->threads[i], NULL, access_mem, ptr))
>   			perror("Couldn't create thread");
>   
>   	ASSERT_EQ(migrate(ptr, self->n1, self->n2), 0);
> -	for (i = 0; i < self->nthreads - 1; i++)
> +	for (i = 0; i < self->nthreads; i++)
>   		ASSERT_EQ(pthread_cancel(self->threads[i]), 0);
>   }
>   
> @@ -153,15 +153,12 @@ TEST_F_TIMEOUT(migration, shared_anon, 2*RUNTIME)
>   	uint64_t *ptr;
>   	int i;
>   
> -	if (self->nthreads < 2 || self->n1 < 0 || self->n2 < 0)
> -		SKIP(return, "Not enough threads or NUMA nodes available");
> -
>   	ptr = mmap(NULL, TWOMEG, PROT_READ | PROT_WRITE,
>   		MAP_SHARED | MAP_ANONYMOUS, -1, 0);
>   	ASSERT_NE(ptr, MAP_FAILED);
>   
>   	memset(ptr, 0xde, TWOMEG);
> -	for (i = 0; i < self->nthreads - 1; i++) {
> +	for (i = 0; i < self->nthreads; i++) {
>   		pid = fork();
>   		if (!pid) {
>   			prctl(PR_SET_PDEATHSIG, SIGHUP);
> @@ -175,7 +172,7 @@ TEST_F_TIMEOUT(migration, shared_anon, 2*RUNTIME)
>   	}
>   
>   	ASSERT_EQ(migrate(ptr, self->n1, self->n2), 0);
> -	for (i = 0; i < self->nthreads - 1; i++)
> +	for (i = 0; i < self->nthreads; i++)
>   		ASSERT_EQ(kill(self->pids[i], SIGTERM), 0);
>   }
>   
> @@ -195,9 +192,6 @@ TEST_F_TIMEOUT(migration, private_anon_thp, 2*RUNTIME)
>   	if (!pmdsize)
>   		SKIP(return, "Reading PMD pagesize failed");
>   
> -	if (self->nthreads < 2 || self->n1 < 0 || self->n2 < 0)
> -		SKIP(return, "Not enough threads or NUMA nodes available");
> -
>   	ptr = mmap(NULL, 2 * pmdsize, PROT_READ | PROT_WRITE,
>   		MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>   	ASSERT_NE(ptr, MAP_FAILED);
> @@ -205,12 +199,12 @@ TEST_F_TIMEOUT(migration, private_anon_thp, 2*RUNTIME)
>   	ptr = (uint64_t *) ALIGN((uintptr_t) ptr, pmdsize);
>   	ASSERT_EQ(madvise(ptr, pmdsize, MADV_HUGEPAGE), 0);
>   	memset(ptr, 0xde, pmdsize);
> -	for (i = 0; i < self->nthreads - 1; i++)
> +	for (i = 0; i < self->nthreads; i++)
>   		if (pthread_create(&self->threads[i], NULL, access_mem, ptr))
>   			perror("Couldn't create thread");
>   
>   	ASSERT_EQ(migrate(ptr, self->n1, self->n2), 0);
> -	for (i = 0; i < self->nthreads - 1; i++)
> +	for (i = 0; i < self->nthreads; i++)
>   		ASSERT_EQ(pthread_cancel(self->threads[i]), 0);
>   }
>   
> @@ -232,9 +226,6 @@ TEST_F_TIMEOUT(migration, shared_anon_thp, 2*RUNTIME)
>   	if (!pmdsize)
>   		SKIP(return, "Reading PMD pagesize failed");
>   
> -	if (self->nthreads < 2 || self->n1 < 0 || self->n2 < 0)
> -		SKIP(return, "Not enough threads or NUMA nodes available");
> -
>   	ptr = mmap(NULL, 2 * pmdsize, PROT_READ | PROT_WRITE,
>   		MAP_SHARED | MAP_ANONYMOUS, -1, 0);
>   	ASSERT_NE(ptr, MAP_FAILED);
> @@ -243,7 +234,7 @@ TEST_F_TIMEOUT(migration, shared_anon_thp, 2*RUNTIME)
>   	ASSERT_EQ(madvise(ptr, pmdsize, MADV_HUGEPAGE), 0);
>   
>   	memset(ptr, 0xde, pmdsize);
> -	for (i = 0; i < self->nthreads - 1; i++) {
> +	for (i = 0; i < self->nthreads; i++) {
>   		pid = fork();
>   		if (!pid) {
>   			prctl(PR_SET_PDEATHSIG, SIGHUP);
> @@ -257,7 +248,7 @@ TEST_F_TIMEOUT(migration, shared_anon_thp, 2*RUNTIME)
>   	}
>   
>   	ASSERT_EQ(migrate(ptr, self->n1, self->n2), 0);
> -	for (i = 0; i < self->nthreads - 1; i++)
> +	for (i = 0; i < self->nthreads; i++)
>   		ASSERT_EQ(kill(self->pids[i], SIGTERM), 0);
>   }
>   
> @@ -270,9 +261,6 @@ TEST_F_TIMEOUT(migration, private_anon_htlb, 2*RUNTIME)
>   	uint64_t *ptr;
>   	int i;
>   
> -	if (self->nthreads < 2 || self->n1 < 0 || self->n2 < 0)
> -		SKIP(return, "Not enough threads or NUMA nodes available");
> -
>   	hugepage_size = default_huge_page_size();
>   	if (!hugepage_size)
>   		SKIP(return, "Reading HugeTLB pagesize failed\n");
> @@ -282,12 +270,12 @@ TEST_F_TIMEOUT(migration, private_anon_htlb, 2*RUNTIME)
>   	ASSERT_NE(ptr, MAP_FAILED);
>   
>   	memset(ptr, 0xde, hugepage_size);
> -	for (i = 0; i < self->nthreads - 1; i++)
> +	for (i = 0; i < self->nthreads; i++)
>   		if (pthread_create(&self->threads[i], NULL, access_mem, ptr))
>   			perror("Couldn't create thread");
>   
>   	ASSERT_EQ(migrate(ptr, self->n1, self->n2), 0);
> -	for (i = 0; i < self->nthreads - 1; i++)
> +	for (i = 0; i < self->nthreads; i++)
>   		ASSERT_EQ(pthread_cancel(self->threads[i]), 0);
>   }
>   
> @@ -301,9 +289,6 @@ TEST_F_TIMEOUT(migration, shared_anon_htlb, 2*RUNTIME)
>   	uint64_t *ptr;
>   	int i;
>   
> -	if (self->nthreads < 2 || self->n1 < 0 || self->n2 < 0)
> -		SKIP(return, "Not enough threads or NUMA nodes available");
> -
>   	hugepage_size = default_huge_page_size();
>   	if (!hugepage_size)
>   		SKIP(return, "Reading HugeTLB pagesize failed\n");
> @@ -313,7 +298,7 @@ TEST_F_TIMEOUT(migration, shared_anon_htlb, 2*RUNTIME)
>   	ASSERT_NE(ptr, MAP_FAILED);
>   
>   	memset(ptr, 0xde, hugepage_size);
> -	for (i = 0; i < self->nthreads - 1; i++) {
> +	for (i = 0; i < self->nthreads; i++) {
>   		pid = fork();
>   		if (!pid) {
>   			prctl(PR_SET_PDEATHSIG, SIGHUP);
> @@ -327,7 +312,7 @@ TEST_F_TIMEOUT(migration, shared_anon_htlb, 2*RUNTIME)
>   	}
>   
>   	ASSERT_EQ(migrate(ptr, self->n1, self->n2), 0);
> -	for (i = 0; i < self->nthreads - 1; i++)
> +	for (i = 0; i < self->nthreads; i++)
>   		ASSERT_EQ(kill(self->pids[i], SIGTERM), 0);
>   }
>   


