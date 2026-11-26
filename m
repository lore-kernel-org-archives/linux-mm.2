Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1334C606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 08:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=d6RuUVoy
Received: by kanga.kvack.org (Postfix)
	id E766B6B05B1; Thu, 26 Nov 2026 03:30:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E003B6B05B2; Thu, 26 Nov 2026 03:30:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC7C06B05B3; Thu, 26 Nov 2026 03:30:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AAB1A6B05B1
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 03:30:49 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D24DFA02F0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 08:30:48 +0000 (UTC)
X-FDA: 85476599376.29.ABD55BF
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf30.hostedemail.com (Postfix) with ESMTP id 00A048000B
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 08:30:46 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=d6RuUVoy;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf30.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795681847;
	b=cZytIBzoA3cqGRs0EpXfoiLX8fPrbJZlzGztJ6NFLrZlXYZ4nd32DeLbcZDGJoXyu7MVYr
	IyuMuH0Hb50lF/SPSXlIFQ3LkDHYdQy8Fra5M+ksYEL0+uYKNHgknDbEa9ZiEhsMnHLmFI
	NrfQFgrOkxKOKZV4JxOh6aQL6DjLTuQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795681847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FyyIgAo1e3KK4/AdbdpOK9l3019Yj2VAw+xdIQTmPhE=;
	b=N/3qAO8XONsPtzqMrFyuTYgy285PtEpiceAb51feNaFDlE1PrjVHiQDbtepBNFyEuMRGJl
	kTJfhZbAwz60g6/srFJ5+LaXazeH7iG53FNJhk5gOaA0Z05c34sitm7OfzsW3s+uJ7IMsa
	20DZ2EqZtmIb5RskwrlTrjPSDG8IbmA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=d6RuUVoy;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf30.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=mhocko@suse.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4bb9d8e8e90so38364475e9.3
        for <linux-mm@kvack.org>; Thu, 26 Nov 2026 00:30:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795681845; x=1796286645; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FyyIgAo1e3KK4/AdbdpOK9l3019Yj2VAw+xdIQTmPhE=;
        b=d6RuUVoy06dgLUXVnRD/NsQAym9gaTp7Tw/wkb+HDfDDmezyS5OxCh2STGR5omctxY
         1vBnWjQuXh+019Z5RtkkhZsot1LdNn04QKn6EPbgbEa19OeS0OBI0pksWFioe4YOmfpu
         yzN3cJPIKwms71XEqeIeOOkRM/NhJOO1igRT47qF7k6kNaBMjtwLMMyUAJ6zwa+FZXic
         OO9WyzZaWA14Ky2QfgaNoofB2T2KxmeQDyNkGE7sFjZbE5Qy03DW3JbLWJmEKIiFrIIA
         ZudKBwJyOBrvfCs8KomY6h4oVFbFVuv9dyFQgfG28ra5hJna20a4qEgigd3kgBTiOPyc
         t13Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795681845; x=1796286645;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FyyIgAo1e3KK4/AdbdpOK9l3019Yj2VAw+xdIQTmPhE=;
        b=jrdF6vPXDi9FArXFfdkmJBk/xIf+BPfoOuazO/kZs7biQ4jNCYnoV1KcRwIAu+vsQt
         itqhWMVNLpMejl16A0W9sPUMI4D/wyxyDn9EJTah3XamoS/q24sIDnQx5bySTlf3Cirx
         I0Cq6L/UK5TbIphoUhUo5PIq0XZ220j5A9ZJ+2Ma3g0e8XKY3IdUNEY+oMYvBMSZuN8u
         JwL2iGHyU+wzLrzaU9Wj01svNl5CT0JQWqOeNTQCuhe28LS/DrnDsrZBt7GemoLNQXVv
         Fhl/+hb9wJTBp2lyj3Hhx/uZjJ4a+fVWyV9usoCz8EaGBZM2oWcp2Tvptixq89vwxJOI
         CS9w==
X-Forwarded-Encrypted: i=1; AL+hErF8Z7xBWsiJytO3RAY5wDUE1PZ8kZw3991R78MlnLRwEbr/5Ll9PD3PX5+cT4baLNHIrt5J+h8GNA==@kvack.org
X-Gm-Message-State: APuU4Z/uxAOa5+lr1tmKvBCV48RoetOMby1hVReP5mkKsGXbi8bUrfKK
	CYGOipn/vQSJbVdOL6cX9nDwmyqZLT3odzuPtiG2MSC5W2v9LiwIyn36HgNmbmJ8dNo=
X-Gm-Gg: AZFdTZeaM2S89x45XqXbtoMoekjre7Ia30EqrnxgFzy7Z8+RM+4WHb2pfvELym7s2df
	/hxn9mgpx5oYP1511lyQknpY/XBxDcVtn7X9cFCza4UyQdwEq+Oq/3rvLV+EDvRznN5gXssJOS5
	o5+07McYumZ/NzaaFv1lRyx1RflykPfQdw1jN5JKIMTTE0bDmDhAVcw5/XVSDGg7T5u7d20xja1
	AyzIRorZSMAdmtyFBULJ7C6wuvKfbicaJmIo8XbyiavMwLlC9WsL7fwan92Nd+fm8++j4DPuuKF
	yAs+S6kjMRIoKhREf0j2TcTKXTiCm8xYbP431zdrzemgc12l5YiIAhrtaBXWHGKGTCPqi2gdvaV
	qo8XkwfpwmvtEu7aO6gIMSBuxbBRsHBTgprJUqY0H2Zotl1DPzsqjoYC8khsiqXek6WtiesytOI
	T0KT15Bs+7dkrOXiefNjAUJuAAlU9Tvtq0/7QDJfgS8xJQ1+yibGaGD0NNswwmvE4/FkPb62pSu
	9dbaptkROpNFYSIJq8W1dSqq1iphSJUY3S3jLL52FtaE0ahfPpdbMG84aBRLGc9Hlsa1/NRxubv
	ZY8Cz/YF0FpQjy7lJflp+HdGy3sr2Q1bEofoAEH6
X-Received: by 2002:a05:600c:6219:b0:4a1:d087:f6ab with SMTP id 5b1f17b1804b1-4bb8880badfmr388991925e9.18.1795681845543;
        Thu, 26 Nov 2026 00:30:45 -0800 (PST)
Received: from localhost (109-81-21-11.rct.o2.cz. [109.81.21.11])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bba3d3679bsm61507665e9.2.2026.11.26.00.30.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 00:30:44 -0800 (PST)
Date: Thu, 26 Nov 2026 09:30:43 +0100
From: Michal Hocko <mhocko@suse.com>
To: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/memcontrol: expose anon and file reclaim statistics
 in memory.stat
Message-ID: <awfuM7vj5Vyb6Fjb@tiehlicka>
References: <20261124-memcg-reclain-stat-v1-1-c6cb14b0d917@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261124-memcg-reclain-stat-v1-1-c6cb14b0d917@gmail.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 00A048000B
X-Stat-Signature: p9f8chuwrriruomfghworqi1i4nsigk5
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795681846-282472
X-HE-Meta: U2FsdGVkX18RG9tzob/V56OYzNyAEOPKBLHouRtZ8Nqscgo9lBctkTjmcnrbGhTe5M5PJyCnPvQ8vX5jaiQ8y26j6EIsKLA4PMyx9ogkhXb7+etktaxCxWWnbRC7Tz8kVIv/ZT531PjuQv5z4HE5lE/pciCMxJlxseIIwxqHw4tl8hSX467R4m91pSxrsHfhBiv3bPD5kAtlRztS8FewjhTNgxxqL8DoPN4uFr5EVKmqtjI9pdsj2fZg2GyHKhBLg2EOsRvYxt7we9uEO+WiIdTC40+fFkcOxQc+Op3xhbzZ1vdNOEUY7qFuh00ILhEeQpiN2kKwsiHU1CxKUeNbMPW6frv/pv/PeM/WSMGQt7GDt4hLjrUSmYCpzpzH+f7WQlFdigtLcJ/BuY1FX8LQBXdI1CbKUhfuC2LFAa8tnZzYSgOggEYv3XEL+k01QvKM1DKS9whO3YhrG8Dofx+5euPZS1OANNgCOusduOOSjphNAzAsx2JFZ74TdWeqc8mIlS91eKLDVj8iDsrcHA7heR1qLVvJNRvKZ1xfd7tZ6gcrfSQMN0FP7ZqPk9nMNx/Aljv7n+T7BOOw7mSIc/+7yk+ufnWSaPt4aKpJKOoJBDx2aor+QDxYq4IZuYUkhrDEwG9Zh8xicBoYAkbfuuiJieZ9JBp+dS5a/fSVYcgGiuIj5UhfKENCup9Qr0hdzTKLTP72IelzIzOV2yhXUeGJkw4SeBwyO4+CsLb/6HKfKVzcNYKdksFSGp+j2jwWcGayQz0aT4tYk8+kXXko4LiXTZzuWBRCCVzaS0lDq3b5q+dfIbSRlHYiGsmaM8QbTPffdx7lvYFTHkm98HZfSdZy8UgqhgJKIOEmsDGKUbE0JsNrQ/y7VrqAQ5nSLPUOJ1iCFirYhFdeJMBY5H4BReJAaUldZBPzb1ey9GE2+pmjDZJK49gPUR01XZxgY3T443IpUiFIrKpHi6aGCrRCTei
 x+iYIafa
 YFtko5rVyQwXoMr8gX2nnqLlqwL2SfRS1t/S3Y5HGuDHDQgVZwFYms/568SqNGo5EkGtg2mFZw1VHmX7t/0ef8STzvDINhHaFd6oZwy7vL7k9vjS9CToOizpaO75CKrt3T06iDJSoAe4KBWuid1m6LNFZkuvZS3xnFfKnwUq36mxehxVR/kESeZftYLtBqNBucJaIbCqSw/i9ar8mRPMtpZZOAzaHAaGo9yMZynoUzaJZeJJyRr7KctRih2hKRaYrq3LNRNvSUP52QfcW/RH5bnzHHXkCL/umFxeb1FqwQDmxPsv5OeSHppLBpYIL5WkVpM1vZQ/SWL2sYaPbr+q+oxvHVSgGgnUN8sTQXY1Z9dO7qapywiT4tUxzuwSGSkxs4zvwDrJdBXWE1+J/N26pznaADu8N2x/IshGBsyupbAaeZ3REghqres0SkUGMTeOecKD28M9EOCG7a+UXqJ2bSx3u3q3/qw/0VmBCliOHuGoaN+Ho+v1vl3jpGm/T8JHKt3yrwr7nonuXbf0pawWiUyQiJNnpuR55ab1NCi+Es2aU3XRHutve051iNyU0yqNtdKKeEag1mUU9oeLQymG5W7+4I19a7dw92BhdvkmORe3nRCWNn6xyZX2PfyLWWF39e/Wu3yUvWQtX99Uagl2aj3wdcn83BgXNpHOBFHpKdEsXHiL82/83YRYEm4B1OMM6fr7Wkxb0/c8wH2iqdNw/HO1NQPiep+paUbLdcA+hbqz4iNQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue 24-11-26 15:51:27, Xueyuan Chen wrote:
> The aggregate reclaim counters in memory.stat do not show how reclaim
> is split between the anonymous and file LRUs of a cgroup.
> 
> Expose the existing per-memcg scan and steal counters by LRU type so
> userspace can measure reclaim balance and efficiency when evaluating
> reclaim policy. Report the same counters per node in memory.numa_stat.
> Both files report the counters in base pages.

We have found these stats quite useful when debugging issues at the
global level many times. So I think this is a useful addition to memcg
stats as well. Especially when we already collect the data so this is
purely a change to show the already available information.

> Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
>  Documentation/admin-guide/cgroup-v2.rst | 20 ++++++++++++++++++--
>  mm/memcontrol.c                         |  8 ++++++++
>  2 files changed, 26 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> index 9e3c67b02ae2..eeeaf635754c 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -1726,6 +1726,22 @@ The following nested keys are defined.
>  	  pgsteal_proactive (npn)
>  		Amount of reclaimed pages proactively
>  
> +	  pgscan_anon
> +		Number of base pages scanned for reclaim from the anonymous
> +		LRU. With the multi-gen LRU, counts pages isolated for reclaim.
> +
> +	  pgscan_file
> +		Number of base pages scanned for reclaim from the file LRU.
> +		With the multi-gen LRU, counts pages isolated for reclaim.
> +
> +	  pgsteal_anon
> +		Number of base pages reclaimed from the anonymous LRU,
> +		including pages demoted to another node.
> +
> +	  pgsteal_file
> +		Number of base pages reclaimed from the file LRU,
> +		including pages demoted to another node.
> +
>  	  pgfault (npn)
>  		Total number of page faults incurred
>  
> @@ -1829,11 +1845,11 @@ The following nested keys are defined.
>  	application performance by combining this information with the
>  	application's CPU allocation.
>  
> -	All memory amounts are in bytes.
> +	All memory amounts are in bytes. Reclaim counters are in base pages.
>  
>  	The output format of memory.numa_stat is::
>  
> -	  type N0=<bytes in node 0> N1=<bytes in node 1> ...
> +	  type N0=<value for node 0> N1=<value for node 1> ...
>  
>  	The entries are ordered to be human readable, and new entries
>  	can show up in the middle. Don't rely on items remaining in a
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 1ebc9330aeae..ac12ff69a633 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1647,10 +1647,14 @@ static const struct memory_stat memory_stats[] = {
>  	{ "pgsteal_direct",		PGSTEAL_DIRECT		},
>  	{ "pgsteal_khugepaged",		PGSTEAL_KHUGEPAGED	},
>  	{ "pgsteal_proactive",		PGSTEAL_PROACTIVE	},
> +	{ "pgsteal_anon",		PGSTEAL_ANON		},
> +	{ "pgsteal_file",		PGSTEAL_FILE		},
>  	{ "pgscan_kswapd",		PGSCAN_KSWAPD		},
>  	{ "pgscan_direct",		PGSCAN_DIRECT		},
>  	{ "pgscan_khugepaged",		PGSCAN_KHUGEPAGED	},
>  	{ "pgscan_proactive",		PGSCAN_PROACTIVE	},
> +	{ "pgscan_anon",		PGSCAN_ANON		},
> +	{ "pgscan_file",		PGSCAN_FILE		},
>  	{ "pgrefill",			PGREFILL		},
>  #ifdef CONFIG_NUMA_BALANCING
>  	{ "pgpromote_success",		PGPROMOTE_SUCCESS	},
> @@ -1699,10 +1703,14 @@ static int memcg_page_state_output_unit(int item)
>  	case PGSTEAL_DIRECT:
>  	case PGSTEAL_KHUGEPAGED:
>  	case PGSTEAL_PROACTIVE:
> +	case PGSTEAL_ANON:
> +	case PGSTEAL_FILE:
>  	case PGSCAN_KSWAPD:
>  	case PGSCAN_DIRECT:
>  	case PGSCAN_KHUGEPAGED:
>  	case PGSCAN_PROACTIVE:
> +	case PGSCAN_ANON:
> +	case PGSCAN_FILE:
>  	case PGREFILL:
>  #ifdef CONFIG_NUMA_BALANCING
>  	case PGPROMOTE_SUCCESS:
> 
> ---
> base-commit: b024a51b0184b1efb6f55b11aaf7b15a490a6307
> 
> --  
> Best regards,
> Xueyuan
> 

-- 
Michal Hocko
SUSE Labs

