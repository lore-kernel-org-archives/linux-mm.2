Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79606CD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 14:18:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA31E6B00E7; Wed, 13 May 2026 10:18:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7AD96B00E9; Wed, 13 May 2026 10:18:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 991686B00EB; Wed, 13 May 2026 10:18:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8A2F76B00E7
	for <linux-mm@kvack.org>; Wed, 13 May 2026 10:18:49 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 388AC4010A
	for <linux-mm@kvack.org>; Wed, 13 May 2026 14:18:49 +0000 (UTC)
X-FDA: 84762602778.18.454425E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id C9AC640003
	for <linux-mm@kvack.org>; Wed, 13 May 2026 14:18:46 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MGXuaUfy;
	spf=pass (imf11.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778681927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xYlye75OCf2YtQTajLfzvkg89uVXgpLkqgB1sCbwhbY=;
	b=zBCIIcdp5CQ31NFnVKo5k5CeEWxPlWSdW5tttZcHsv8UKTRra1zofkx8ztQpa5nNJSP1T3
	w/MQvS78xxjxLxZMfts2abi8iO0U6xzUgaBFoo5BYDcGaLas+sYEs5TZ4SGv7fncMMPppE
	YP5xr10voS0m5QDriuV7zt04vtgef0c=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MGXuaUfy;
	spf=pass (imf11.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778681927; a=rsa-sha256;
	cv=none;
	b=xn50DmbXTtA9ndKZbZ3pBto4zRnTUM7BbJ7uAjoelRWx4V9etPgOJiAbh8ZciBepKfJFBs
	Y71GbMA7J9wC2ZNAmvjlBkX2yvg+/U8bqlx+djo/71CF3xP2oOy5an5Jmm3ADKQfZA8HWm
	0YkP13e4tXSlfGyNNQPxG9LrcVUIfnM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778681926;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xYlye75OCf2YtQTajLfzvkg89uVXgpLkqgB1sCbwhbY=;
	b=MGXuaUfyiBZOawY1aO9SOj1dv4WkJ03W4f1y/y3w+WolCgxlKxpxwR5UWHspVUsm+02Wo0
	p+ZaF5s8+rxIao7emQzb1Fw3U87lACYeoxp09QAEiSICo6IzRyVPrT+CaA2r9Tsst9gQdF
	ZWMWdUywYfzzYAO63U/84SoQTZKKCQg=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-195-jaEYQqjrNouqacFvtLLgCg-1; Wed, 13 May 2026 10:18:44 -0400
X-MC-Unique: jaEYQqjrNouqacFvtLLgCg-1
X-Mimecast-MFC-AGG-ID: jaEYQqjrNouqacFvtLLgCg_1778681924
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-8b49260e3d5so54096416d6.2
        for <linux-mm@kvack.org>; Wed, 13 May 2026 07:18:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778681924; x=1779286724;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xYlye75OCf2YtQTajLfzvkg89uVXgpLkqgB1sCbwhbY=;
        b=lZ7+cfN7veOQFJ/FCXs14c8ZGAi36UcaWuFVdEyP6stB5LronepCeEeLv/5lDNAMrO
         We7zTQ9z+pYoAxJvZYTiUfM/KnIKMLMkk8+iryhmajICP4Ut8YOC6NKjJf9umRWZd4yL
         gBnSci1bxmeSDbd6KLzq17sTwjV991c/nXkm9DJxWbSDpnz/FPIgZZurDS7Dp/ojUAem
         CJWZEnkJ/cTecnHKBdUgcvddWSc2jS42rs3l5gIHy6C+/OVJj1BcL5uzDQJ8YFOrGnKi
         h5HaaJm0P8VfyK6F9ieKSURrfDbRTmyzka0rV9uMKcXhjNgb7S5N6hEVTnBp2RyCCsz4
         Qaaw==
X-Forwarded-Encrypted: i=1; AFNElJ9j+n5W3Q4K68DU39ytwAfQU2oZ2pvJZIp7C33ntn1Cj4O0fAg8m/AlrB6IgphLVRl4IADwA5srRQ==@kvack.org
X-Gm-Message-State: AOJu0YxI8dNk4E3UTwrKczfqs6a2KWIMSmfAZzV1Qdw8IyiV41OyllU2
	cWr6F7+1yuvr2nmHmeqyl7sDmVoTpnCrOvpT66tEA9lvTJ7741QKFrLyJSIjkTSn6Fq8PgE/UBr
	yJiQ+Xk9OitoM1l4FaGjhy/XzuyZjt8LGwqiSmUixMqLYh+HMsZe2
X-Gm-Gg: Acq92OEnwnxlfrKWNu4N0f8Rn/goHxHc0ZNO8mhxh+QUweYTqmNQVtxFmFKd+bESIX0
	NXE39me1qiFH/wS7bDojpQv1V8EjUuebtS+4IQOCCI1KPm39QUNRWgjBfTkfJPtq7sTt0lLiToh
	Gb3Sp+S8ZXsKPTCNx+JEW6u5SPAyKqvyK8U/LFOmtzXRPaZk/kAxCn14n2xEQIMOfAYmBu/DjsL
	ZI4o3ZPlzaWo53KD12vRxeAzpeHSJmdj1mYlOvIZOpS0BNNATPfnL+gLN9gQcck1OOHuticYi4p
	t6W+QY+ZMDYU6hveOrfb+Q4w7C/Gu1zTJDiVDkVjuVL2t6Tb5tLhrpTgPVsot6GyXsBYP52Es4I
	i1FtejneYxGhQPb0O87ULfH+E
X-Received: by 2002:a05:622a:5c85:b0:50b:3788:ab59 with SMTP id d75a77b69052e-5162f4b00dfmr48896521cf.22.1778681924081;
        Wed, 13 May 2026 07:18:44 -0700 (PDT)
X-Received: by 2002:a05:622a:5c85:b0:50b:3788:ab59 with SMTP id d75a77b69052e-5162f4b00dfmr48895661cf.22.1778681923428;
        Wed, 13 May 2026 07:18:43 -0700 (PDT)
Received: from [192.168.2.110] ([70.53.202.134])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5148e6336c0sm160633171cf.2.2026.05.13.07.18.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2026 07:18:43 -0700 (PDT)
Message-ID: <e3ae249d-812c-42ed-aa9b-cfc8cde27b77@redhat.com>
Date: Wed, 13 May 2026 10:18:31 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 04/55] selftests/mm: migration: properly cleanup
 fork()ed processes
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lance Yang <lance.yang@linux.dev>,
 Li Wang <li.wang@linux.dev>, Leon Romanovsky <leon@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Mark Brown <broonie@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Nico Pache <npache@redhat.com>,
 Peter Xu <peterx@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Sarthak Sharma <sarthak.sharma@arm.com>, Shuah Khan <shuah@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
References: <20260511162840.375890-1-rppt@kernel.org>
 <20260511162840.375890-5-rppt@kernel.org>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <20260511162840.375890-5-rppt@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: cEOtxNvjWrJMocpIhbdVChwzqC-WhD4SON8aWBgmDAc_1778681924
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C9AC640003
X-Stat-Signature: ihs8qh876x66wp9qazgi6rp4a3o9e4zx
X-HE-Tag: 1778681926-547229
X-HE-Meta: U2FsdGVkX1/XPFVLpSV9c9fBjz64nMcnOeoYpWEycxnhafn26J/Q9MpoZePYiHANnjKBIAuhRaVP28zf6BYDdzGAK3OWnbrfVItbS7ro1O2JhmaLRqsmN6vF6MORAGh/dF4Kx4miSrs8WMKhkTVrkA1EH8gqoW1n1E93eAPj95CB1vK2WWNAEJCy09TY81YZn4iYPSJYCtxDxBf+gEW96Zz+CrqSHvwmi866dqh9CF6jsl6mBNESpivo1BUwI+wdK+cXWnB4I1vVXFubwrfQANFodgO4Olklrn2SzQwrfn7znlHUtBCAkoeaCI8eiY+FFlb9mgylexLS8kP2PztHkv8dcFq8o0N7JBXykS24X1R+AUg5M/n9FyGIFD1E8Q/aXkHNtfbjxXbv2cYsTp6iLlzPrXweBFcAeTswJzarjHlXicu4o66yxPRqCx3QSrXGV0XQo/VeISyHXzWykjIIl5N3PiXPmYwH2QeINaSjyWgKnizBGi/elwZ23ViatlnEd5va5WZuNMjBkXIDnULY5Yfp5RKWTeFSJPvpl5nK3MeyNhXcjb1mHHuY1kUo497TiG3mWSOMNgfoLSCd3XW8f5L5InjzcxRvLM5itZQeCxWpIbIzL58uRxMWmI2/bMCurjUTVsavQpPTKDhSJB6VozpZjQveZqAOTeKYmMW1SZ5ss/BjrmnqtKud5LVmRkKwv3gKUYj9mANJfsMbnyoTR5tKByzDEoqpRk5u4ZHvpry74HQhrM5MqPifd0i6iT59c6VDt+g3r/1Z8F3S4QIxA3x5ab69Eo8GNIiuU6b46f5goWtrgLnMuyrAHSDeVGH2zR6cvSEBpdfG0BlVkgajtn7W2rCDdKfJRCHRS20sqmMbvWH/tM3AlPKJQczzKGDu3AYp8/jwiOEs5Kf5GApJJbaHH975F42cm8WjdxOk/zpxN5gq6vFG27Egoplfvm67Vo1Yx27aJgQorjFk59R
 pHBjAXW5
 QEf3prYsQMXvPbZ25S6LaC7IaN8mg/IfTAQV5t93XDrA55dKGbPVWQi2AqoxmSNBw3Z2g1tO7RteNzieLGKrVRCZaXFbtkME4FNQtvFNMdh8gGmBmosbTcbEho+factC95/WQMpCcRySnzek7DkfPFm855qqeHtiGur+zAf9PloJw4xplQ+DGa/JEnsPj2Y/aBXyjCmCcf71FL0/kQ4ZTEQuIGvn4EZhs+dadMl+0FOadlE917hZYSSI3MLMZahGo1KVdwFwyAX8UIiRHKgJymEafH6kEtBjwnWUFgfi3Fe+u4k2m3wL/rT7seuw9mmv6/MwuA7RWUwf5Vjy6EJ66MkAOAR3uDiRRMT7QFMDQAzCSsFxONS4OmOcyozXCPtNrDY9LVqYqLCx9sajJi2s20sHHvOO80lFVlLXK9NketaHP2CKRjthuPrlEDYQurKJMnhUr63SMLQk7/Qwyofyv9HXDMD+2clTDQ9Is
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-05-11 12:27, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Several migration test use fork() to create worker processes. These
> processes are later killed, but nothing collects their exit status and they
> remain as zombies in the system.
> 
> Add a helper function that kills the worker processes, waitpid()s for
> them and verifies the exit status.
> 
> Replace the loops that call kill() for each process with a call to that
> helper.
> 
> Reported-by: Luiz Capitulino <luizcap@redhat.com>
> Tested-by: Luiz Capitulino <luizcap@redhat.com>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Luiz Capitulino <luizcap@redhat.com>

> ---
>   tools/testing/selftests/mm/migration.c | 47 +++++++++++++++++++-------
>   1 file changed, 35 insertions(+), 12 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/migration.c b/tools/testing/selftests/mm/migration.c
> index 16ffd3c55ee0..e504829df6b6 100644
> --- a/tools/testing/selftests/mm/migration.c
> +++ b/tools/testing/selftests/mm/migration.c
> @@ -67,6 +67,29 @@ FIXTURE_TEARDOWN(migration)
>   	free(self->pids);
>   }
>   
> +static bool kill_children(FIXTURE_DATA(migration) * self)
> +{
> +	bool err = false;
> +	pid_t pid;
> +	int i;
> +
> +	for (i = 0; i < self->nthreads; i++) {
> +		int status = 0;
> +
> +		pid = self->pids[i];
> +		if (pid < 0)
> +			continue;
> +		if (kill(pid, SIGTERM))
> +			err = true;
> +		if (pid != waitpid(pid, &status, 0))
> +			err = true;
> +		if (!WIFSIGNALED(status) || WTERMSIG(status) != SIGTERM)
> +			err = true;
> +	}
> +
> +	return !err;
> +}
> +
>   int migrate(uint64_t *ptr, int n1, int n2)
>   {
>   	int ret, tmp;
> @@ -151,7 +174,7 @@ TEST_F_TIMEOUT(migration, shared_anon, 2*RUNTIME)
>   {
>   	pid_t pid;
>   	uint64_t *ptr;
> -	int i;
> +	int i, err;
>   
>   	ptr = mmap(NULL, TWOMEG, PROT_READ | PROT_WRITE,
>   		MAP_SHARED | MAP_ANONYMOUS, -1, 0);
> @@ -171,9 +194,9 @@ TEST_F_TIMEOUT(migration, shared_anon, 2*RUNTIME)
>   		}
>   	}
>   
> -	ASSERT_EQ(migrate(ptr, self->n1, self->n2), 0);
> -	for (i = 0; i < self->nthreads; i++)
> -		ASSERT_EQ(kill(self->pids[i], SIGTERM), 0);
> +	err = migrate(ptr, self->n1, self->n2);
> +	ASSERT_EQ(kill_children(self), true);
> +	ASSERT_EQ(err, 0);
>   }
>   
>   /*
> @@ -217,7 +240,7 @@ TEST_F_TIMEOUT(migration, shared_anon_thp, 2*RUNTIME)
>   	uint64_t pmdsize;
>   	pid_t pid;
>   	uint64_t *ptr;
> -	int i;
> +	int i, err;
>   
>   	if (!thp_is_enabled())
>   		SKIP(return, "Transparent Hugepages not available");
> @@ -247,9 +270,9 @@ TEST_F_TIMEOUT(migration, shared_anon_thp, 2*RUNTIME)
>   		}
>   	}
>   
> -	ASSERT_EQ(migrate(ptr, self->n1, self->n2), 0);
> -	for (i = 0; i < self->nthreads; i++)
> -		ASSERT_EQ(kill(self->pids[i], SIGTERM), 0);
> +	err = migrate(ptr, self->n1, self->n2);
> +	ASSERT_EQ(kill_children(self), true);
> +	ASSERT_EQ(err, 0);
>   }
>   
>   /*
> @@ -287,7 +310,7 @@ TEST_F_TIMEOUT(migration, shared_anon_htlb, 2*RUNTIME)
>   	unsigned long hugepage_size;
>   	pid_t pid;
>   	uint64_t *ptr;
> -	int i;
> +	int i, err;
>   
>   	hugepage_size = default_huge_page_size();
>   	if (!hugepage_size)
> @@ -311,9 +334,9 @@ TEST_F_TIMEOUT(migration, shared_anon_htlb, 2*RUNTIME)
>   		}
>   	}
>   
> -	ASSERT_EQ(migrate(ptr, self->n1, self->n2), 0);
> -	for (i = 0; i < self->nthreads; i++)
> -		ASSERT_EQ(kill(self->pids[i], SIGTERM), 0);
> +	err = migrate(ptr, self->n1, self->n2);
> +	ASSERT_EQ(kill_children(self), true);
> +	ASSERT_EQ(err, 0);
>   }
>   
>   TEST_HARNESS_MAIN


