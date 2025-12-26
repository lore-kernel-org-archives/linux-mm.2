Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 382CEE8FDB5
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 20:40:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 620396B0005; Fri, 26 Dec 2025 15:40:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CF096B0089; Fri, 26 Dec 2025 15:40:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4855F6B008A; Fri, 26 Dec 2025 15:40:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 36C8B6B0005
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 15:40:38 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DE81B58D95
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 20:40:37 +0000 (UTC)
X-FDA: 84262790514.28.880CE09
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 67D9D180002
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 20:40:35 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=B9LY35OG;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of llong@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=llong@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766781635; a=rsa-sha256;
	cv=none;
	b=NEAOzR6abdGAcUSFVOzet8VI0u8YFNvxhu50CdHMZspUB/QL4PNcH51WqOBJVYlTmU4z+x
	jNIcYE+oUOK0zOK45gw/sPG5Flfdly3EJ2h5UrDkeCCIPOW/dYqiLg/Da1IavoBrQJdQjM
	Olv75mtfZgMB7vILSJDL9tKUjQyrBkg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=B9LY35OG;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of llong@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=llong@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766781635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GeIq5WeBjJr0pHEJInnCdQac0Dvo9bQqS7LrqRILVDY=;
	b=Uc6JCUjfdzdtqreDgPe74pjOYOrUBrUJhw6m4zJWEA0o8L8gERgxIk8AJraHu0BM2qgzBg
	5FqtoWfzMa/iLvbQsnS/pn1AkuHmd/3IS/kmu4FjBtBsMX4hr4d62XMhsKlK6ggP39eZcI
	sW6RAsu8OpSYa2z0+edM2hpsjWQwlF0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766781634;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GeIq5WeBjJr0pHEJInnCdQac0Dvo9bQqS7LrqRILVDY=;
	b=B9LY35OG6gVDjLUBrb+D8xq1zI8bADGP9mvqiBHyvLOf8w89T1ZJt9voYX9WVNIJgqLyHY
	yBfea8ZxYcCe5XM1a6kf+kiK3a3P/tp5dWcukNRznNJiv0fcmHDgAS9mIAszQvxj3hP4Nm
	qT28DIGiXTF9jUHGKVpz4aVPapYiXPg=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-47-LSowyyArPH62kx60pZ87Nw-1; Fri, 26 Dec 2025 15:40:31 -0500
X-MC-Unique: LSowyyArPH62kx60pZ87Nw-1
X-Mimecast-MFC-AGG-ID: LSowyyArPH62kx60pZ87Nw_1766781630
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-88a2f8e7d8dso201443726d6.1
        for <linux-mm@kvack.org>; Fri, 26 Dec 2025 12:40:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766781630; x=1767386430;
        h=in-reply-to:content-language:references:cc:to:subject:user-agent
         :mime-version:date:message-id:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GeIq5WeBjJr0pHEJInnCdQac0Dvo9bQqS7LrqRILVDY=;
        b=dGqzxzKlyMvndNROnF8NCv3SR92ryVTxQdXODAYbzvplm+JZbOFbxhWK99yY9EKiP4
         dtOXeZ5pak+6Qj5SynPWh7mOFB5qpmseVRF+iFtUKrFq1ooSCFzcHmeH/lXvIDclACK+
         CDfTLvDDcGMRL+rdRNn4Iz/JngXy7s0HXv6emTgbBR7wCCOqSGxTFmfkv0cfiwcmIjX+
         MDO47j1ENJO3XMTyiViXK5E+ZafMJgFlb1K0qAx8fdjCTgiRNgQopshSBhnXkzFoUsXP
         3B8UmIKrE7QfzS7ZL2GpGn1XYfS22RBVm8UwxXYPbfJQUaZhg8lRflVw9YnMU8qF26sP
         3lGA==
X-Forwarded-Encrypted: i=1; AJvYcCVjBWxhWmNuLqD8QaRfYAK7QKdNtvX7Acm361B/N+SWSDgxpar+uVx3AcUU9BHCWIuwvOXnv5uXrQ==@kvack.org
X-Gm-Message-State: AOJu0Yw/lPm5cJOHZZpqQew1/xScjJ7/2JBTQb9KcjkuVoV/V3Y5s40o
	8WrsQwhRDbNEOAXk5MBmHeM3+iQTwfJvbCwZfod3+WbTH8G94hNg7BoltouGBj/D+3dWFi4p0Ek
	orkpsqdXzHsVbKab7K9jWY9SEYTXq7noCUoh0rbKwVzExVwucO+VN
X-Gm-Gg: AY/fxX5FlfjDXsoH4Ml57zRottgAzJtXOabo2o2ksJff1qBGlpOW9UkujF4rrppPoy6
	KQdqzBzNWgbJ2al1HmarNxZl7t3bSd/loiE4YQ7kpr2aqnqFcxjwj5ugFD15DUgMEKosQ0goETh
	F/pRjO9UpBhm+N3s7Z2h0AJWEBi0n9gF2pnECnFgVuCqq8mtiiXFyqNvByZgi7xcUb5sOc7G/qu
	GedwutxFNBYudFIblOK7NTkc3ByPm+q+lBkiMz2ZPjbXNIj7Tq4Eccx8UoGVN6y7luTUuOdXzv/
	LfSTyVrsS2b4jyW/9L97b7MEZfjtLd6FNnMyJna3MoymDeFtfW5WmAZ+J/PH1NPGiyvuJwrWMbN
	a0k0P4J2vRLc69XVyDbElDZuPST3sSZ7bQS9Y1ucRxeUkxGIR9+LQmZPA
X-Received: by 2002:a05:6214:5707:b0:888:80be:5104 with SMTP id 6a1803df08f44-88d819558cfmr377291606d6.16.1766781630567;
        Fri, 26 Dec 2025 12:40:30 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFJdkq+u1ZRrQHYShSOBtqa9hySrWHwPD0xQGmptftUFkBE3/xQzVpQVqAYXeMkq1K1V+nQKg==
X-Received: by 2002:a05:6214:5707:b0:888:80be:5104 with SMTP id 6a1803df08f44-88d819558cfmr377291416d6.16.1766781630178;
        Fri, 26 Dec 2025 12:40:30 -0800 (PST)
Received: from ?IPV6:2601:600:947f:f020:85dc:d2b2:c5ee:e3c4? ([2601:600:947f:f020:85dc:d2b2:c5ee:e3c4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c0973f28e3sm1899806685a.45.2025.12.26.12.40.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Dec 2025 12:40:29 -0800 (PST)
From: Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Message-ID: <a8262eaf-169d-415d-949e-70f1a17b1e38@redhat.com>
Date: Fri, 26 Dec 2025 15:40:25 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 19/33] cpuset: Propagate cpuset isolation update to timers
 through housekeeping
To: Frederic Weisbecker <frederic@kernel.org>,
 LKML <linux-kernel@vger.kernel.org>
Cc: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Bjorn Helgaas <bhelgaas@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Chen Ridong <chenridong@huawei.com>, Danilo Krummrich <dakr@kernel.org>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Gabriele Monaco <gmonaco@redhat.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Ingo Molnar <mingo@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
 Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
 Lai Jiangshan <jiangshanlai@gmail.com>,
 Marco Crivellari <marco.crivellari@suse.com>, Michal Hocko
 <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
 Paolo Abeni <pabeni@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Phil Auld <pauld@redhat.com>, "Rafael J . Wysocki" <rafael@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Simon Horman <horms@kernel.org>,
 Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 cgroups@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-block@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org,
 netdev@vger.kernel.org
References: <20251224134520.33231-1-frederic@kernel.org>
 <20251224134520.33231-20-frederic@kernel.org>
In-Reply-To: <20251224134520.33231-20-frederic@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: PtxHA4qIVSiMgTgRB0LC4FRW_PhWqfXe86stontddvw_1766781630
X-Mimecast-Originator: redhat.com
Content-Type: multipart/alternative;
 boundary="------------00BKB7bc43BQak71rKhHRgpD"
Content-Language: en-US
X-Rspamd-Queue-Id: 67D9D180002
X-Rspamd-Server: rspam03
X-Stat-Signature: buw4h1jx5sphu3netoqypeopq78415qt
X-Rspam-User: 
X-HE-Tag: 1766781635-467640
X-HE-Meta: U2FsdGVkX18pwni1N9Sag3COpNSs4TL5l6NnUuKYDWrWS02hzzMQ1239odbodIRuGHztKTd6gvPt1lXHgoRf3p4i2/zMRcrrYqDP1SiJ6Q5xgvYQBNkLcjSLgPmlMVPeATtjulKhREwc/kuafqE8z/Yj5aG6kFruZz+E4aLMHfhKmC+/b7u3Uu05dJBTVDdLxuo3tRmXYd6hVsQs75YdP2Gn2YqhTBiOM8r6yDNzjiX/NXUGpf/0HrbuNw5GosvkICvpmhgrko108Ig4UPMxc4dPuLLaNdW1l7AncOdOZ7bS6aHRBpEr1YhG8QshQetD5XF0VY4TgGkP9k7fzhAeBseJUaHEPnnzEmDxzmOezqBew2R8kDHj2JQX2CYBS1Dww2wkc6mvi89GqV6UtZbbe0LHD00HwgwTZNeLXbjaGNFY0bDwmmAv/rSIIyLDP6Xjml0PKr9Xd/1P+o8P2P7zU26yycw54XKEDKFxIAzdFQocJLicbyZATH7ZPTMIKloKY+r5EOknakxiIW1rLefU8HDpQvFtaS94A6QCyUOYVWSUpPQ4EBjVShIWZmbTeWXmVHC9wP1SrkRQeEUyWfqyl1sEIpj/v/NFAgS6ZRAHSMA7fDppk8m1i+rOHuMMgX8EyP7ruC/h4B5eF8yQGwXncXJgsFNWtFZgo6jSD5/6Op3ck/WmV6ra3v7DpYIFh28DYwLH4vRIP2bmoNSjmDHQv+G337ePHtwz6qkEo0DlOMwsnMaMAMihaWEIOhuujblQuY3azf/5K6YWP4fZMHAlCyCV8FDVwbLK48XHteaRvGfAG/Pal1iXsFo2/ZpqLVSET2DqhkD1sUb7CzHhlXYt2CrawPfLgsJEuOhS42gpZxaRNWjALTRvz4OLnC453ibfRQb/NxbrnCNY3M32RGxVIbWiu8XJ4s0KuPbbvD33H4zVWCS50MSUroGRNZvWRAtSBl6iI+PM7H++2a/hv+N
 ga0kWs+a
 dgw99Ahh40KNZ2ltDG1I4p695obAOfX4tvPmTISpp2dmSxM8+A3Y6VlZrqrIe7TC9MUQ+is2rtQYHnGN9N8Jmtiu0onzBb2meSe3Q+05xYD07bC638g8uMqbFASjbFBJHWyljG7mfnlNptoueaqgmALx+e/7kp9I6VCkS+GUHtuummnIIjdGxfipbxMj6HAoKrbyMiU3V6WJAhEoz1jJnGRcISQ7QYLVCHeYUeLxXcogEdP/A462GnAWW71UShceIwKd1EXGX1HgFJ1xCxoKhPH3FhHmdx9LdyfXm2ht0b5THjMCt6M90Whna7iHqMYdJnDAVCchzQbSHSi17jGcMLk7Xwl7SEP7r7mjpwHDn2gy4Z9swsfdz9MAxq2UgLokGhIj2BoC9qWIpQJ6rB6x+grfquC9ISawXOdUrgG/41SWn1xGum26VQh2BkFHod64nISFvNOqsUpQ8tgpe7K++NEMCf5txmDR+n7Ov2LZv6e16CSuZEX6T68TmbDCdfaY0MHNV5+6X9EE1pjPA/2ZlX+u89giAiPV8Aoxp6mOiGwbiFy12mpwHYpxFvA9HgYtoqj3PmULu2hHKWhtnffAj5p8gVmhFPzKCZwBpcQQebvGe5md2Qsh/HAf9RhwOOFl9HgnjsfN2WjialLiF3l0THsm3ual+fU9GNvGJPKaJIlFfJhDaIezbwDsbU0sF0o2saMNarArhRvOrK9DZY+QPjNXH2MZHEnOSPIcG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------00BKB7bc43BQak71rKhHRgpD
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/24/25 8:45 AM, Frederic Weisbecker wrote:
> Until now, cpuset would propagate isolated partition changes to
> timer migration so that unbound timers don't get migrated to isolated
> CPUs.
>
> Since housekeeping now centralizes, synchronize and propagates isolation
> cpumask changes, perform the work from that subsystem for consolidation
> and consistency purposes.
>
> Signed-off-by: Frederic Weisbecker<frederic@kernel.org>
> ---
>   kernel/cgroup/cpuset.c   | 3 ---
>   kernel/sched/isolation.c | 5 +++++
>   2 files changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index a492d23dd622..25ac6c98113c 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1487,9 +1487,6 @@ static void update_isolation_cpumasks(void)
>   	ret = housekeeping_update(isolated_cpus, HK_TYPE_DOMAIN);
>   	WARN_ON_ONCE(ret < 0);
>   
> -	ret = tmigr_isolated_exclude_cpumask(isolated_cpus);
> -	WARN_ON_ONCE(ret < 0);
> -
>   	isolated_cpus_updating = false;
>   }
>   
> diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
> index d224bca299ed..84a257d05918 100644
> --- a/kernel/sched/isolation.c
> +++ b/kernel/sched/isolation.c
> @@ -150,7 +150,12 @@ int housekeeping_update(struct cpumask *isol_mask, enum hk_type type)
>   	pci_probe_flush_workqueue();
>   	mem_cgroup_flush_workqueue();
>   	vmstat_flush_workqueue();
> +
>   	err = workqueue_unbound_housekeeping_update(housekeeping_cpumask(type));
> +	WARN_ON_ONCE(err < 0);
> +
> +	err = tmigr_isolated_exclude_cpumask(isol_mask);
> +	WARN_ON_ONCE(err < 0);
>   
>   	kfree(old);
>   

If you are doing "WARN_ON_ONCE() in housekeeping_update(), you don't 
need to do it in update_isolation_cpumask() to avoid double warnings. 
Actually, you don't need to return an error code from 
housekeeping_update() at all.

Cheers, Longman

--------------00BKB7bc43BQak71rKhHRgpD
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 8bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <div class="moz-cite-prefix">On 12/24/25 8:45 AM, Frederic
      Weisbecker wrote:<br>
    </div>
    <blockquote type="cite"
      cite="mid:20251224134520.33231-20-frederic@kernel.org">
      <pre wrap="" class="moz-quote-pre">Until now, cpuset would propagate isolated partition changes to
timer migration so that unbound timers don't get migrated to isolated
CPUs.

Since housekeeping now centralizes, synchronize and propagates isolation
cpumask changes, perform the work from that subsystem for consolidation
and consistency purposes.

Signed-off-by: Frederic Weisbecker <a class="moz-txt-link-rfc2396E" href="mailto:frederic@kernel.org">&lt;frederic@kernel.org&gt;</a>
---
 kernel/cgroup/cpuset.c   | 3 ---
 kernel/sched/isolation.c | 5 +++++
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index a492d23dd622..25ac6c98113c 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1487,9 +1487,6 @@ static void update_isolation_cpumasks(void)
 	ret = housekeeping_update(isolated_cpus, HK_TYPE_DOMAIN);
 	WARN_ON_ONCE(ret &lt; 0);
 
-	ret = tmigr_isolated_exclude_cpumask(isolated_cpus);
-	WARN_ON_ONCE(ret &lt; 0);
-
 	isolated_cpus_updating = false;
 }
 
diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index d224bca299ed..84a257d05918 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -150,7 +150,12 @@ int housekeeping_update(struct cpumask *isol_mask, enum hk_type type)
 	pci_probe_flush_workqueue();
 	mem_cgroup_flush_workqueue();
 	vmstat_flush_workqueue();
+
 	err = workqueue_unbound_housekeeping_update(housekeeping_cpumask(type));
+	WARN_ON_ONCE(err &lt; 0);
+
+	err = tmigr_isolated_exclude_cpumask(isol_mask);
+	WARN_ON_ONCE(err &lt; 0);
 
 	kfree(old);
 
</pre>
    </blockquote>
    <p>If you are doing "WARN_ON_ONCE() in housekeeping_update(), you
      don't need to do it in <span style="white-space: pre-wrap">update_isolation_cpumask() to avoid double warnings. Actually, you don't need to return an error code from housekeeping_update() at all.</span></p>
    <p><span style="white-space: pre-wrap">Cheers,
Longman</span></p>
  </body>
</html>

--------------00BKB7bc43BQak71rKhHRgpD--


