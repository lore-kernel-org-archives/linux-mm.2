Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 752A4D46C03
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 21:19:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E29236B0005; Wed, 28 Jan 2026 16:18:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF4126B008A; Wed, 28 Jan 2026 16:18:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE26F6B008C; Wed, 28 Jan 2026 16:18:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BEBAB6B0005
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 16:18:59 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8A13CC2917
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 21:18:59 +0000 (UTC)
X-FDA: 84382637598.19.BFBA7EC
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf20.hostedemail.com (Postfix) with ESMTP id A82DA1C0006
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 21:18:57 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=UXyAm3bU;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf20.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769635137; a=rsa-sha256;
	cv=none;
	b=hZcXNHyBMgpEA5Y9JHZ9rroR/LKcIOFtVJvp1l2WD2IyUsm41f4yz3XHPXHyKt2wYdfFDa
	Ond6VNM9+SHGAb3ga+uYzVow8Nv8F2A40SHxqr9YJnWKhuLnEI6ZzxMEJy62TjACeNejB4
	jkN3UHMWU/XXtPAEVx6oRHd6ymYXsgQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=UXyAm3bU;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf20.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769635137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KW1Mn8hE3xrcR5j18KDZNCCnIS+/tf2Xt9JxG670/6k=;
	b=fGfhJTPCKHmSg+bO1lyDDQA+yn7+w2ZhMt3ePtIcGGFM0Aeh13nufQx4dCcbdOm+zRFhBN
	81uBo0TFwTVV91fn2+CNySr/FBRhrkyYlGMvwUzHXD3hTJHBqAqybXTH8l1uTd1hoCkX08
	KbDpyN2/vUULNZPFU36A/qsQisEZtEU=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-48069a48629so2882445e9.0
        for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:18:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1769635136; x=1770239936; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KW1Mn8hE3xrcR5j18KDZNCCnIS+/tf2Xt9JxG670/6k=;
        b=UXyAm3bUJ0VBITVKfYSZ4oZBQB4bKIdXVBz8I6sCvEZO5NfrRpEyAAgAjWX4CfuXwq
         OvaxLy3h22Nt7FjwJdMBed5C2SdCSBk5lxNsFpY7Q/2QjDUnVNBSWN+9OL9+yTOurlRj
         7TGJARJw3oSZ09V2XJVG1l+ROpU2BkPgqLwk4H6rV+nN2gBgQT/zJdnL+EGK6+eItVYO
         0HVhqKi5UKzjzzQ+BOyRv0PPTuxhwzYqNielHJCToOtsJ/F34GkjA6gBItyWdOVKJI1k
         ePd5Jhp1vrrZpexjZ0wyvkh/lEVXuPXURfo+iKrQSqV5FjPasrctQBG8aTwrEySDKEHI
         p58g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769635136; x=1770239936;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KW1Mn8hE3xrcR5j18KDZNCCnIS+/tf2Xt9JxG670/6k=;
        b=vj6ePiyMRjY7ScCEYZv6wd71Eg5A4l41/rqpIPioV4eu0wsT7FGufq1xWIwLCYMkZd
         7M5EeovTKG7T0dFUf7Inv96zyxPIbAcWAOdh7BIUZwBWU3IrW6ir7V2uOQtz27YAbTTG
         +c1UzWuq15DFi2jcih9NgOJCkl2klFhFpa8m1PQslH3B+FmJbxrxiOlmM5rSICyhPhMx
         hI54pANKdgueFLH7388Pnyeezqt+sZ3Ft04EG6UxtAUtAOgkNpo9Jj8j4lzVYz/GGXpm
         Sj2qsIW7Z40Z5sX785LbgcIHxFJY6Pq/GG3iLLvb7P1LmfjPRYpMJJiJQraKkLls8mWw
         bC9A==
X-Forwarded-Encrypted: i=1; AJvYcCWNLH1FGODKjVSdbCNPiuGdbs4dO3m9uZFMLNtvzUAlkVUCbQ/tx51yZEE2h4fm15HCuLO2BwKgQQ==@kvack.org
X-Gm-Message-State: AOJu0Yx4N4Jfx2CbrVP2c14ReOdRFXUFS/MbeEc5uF3/on0XMuJEdLLS
	tO0nUzqT6CcuLvEsiFrUE2EFH2lGTTSLavty4r4BUybs/3IEaBHu/X/9gK54kaf9R18=
X-Gm-Gg: AZuq6aLqOlBKk5DuMxAo3aCPvw3LBJe6zbZO1UGCYPdC++EG8SdxvrHgcQvLEHUMqiX
	eqn+noPi5+dTmuNfwz0LcnFFcsvoumhZb+JmyusVH2uTczwMgeSIcJT59UvbXImOXB3CHZlmOpq
	jN84b6bXJR+5aJKYJx43vyhLrc5Ex3gz+yGStHzyL9cbbK8slggoAWcANTbejfV8AYmM28JmAmR
	2xvnhjWBydbUTX5/yxT6gyN++IIzC08Iei6tGM7PXRDQ0rwhpWTx666kaRp7Oy/xYr1/F3emt9b
	u1QPBoz+zGoW0luuEr5ucQF00NZbRT6co0aO8aY0kjB6MNXvQXGAuQwQaPNZE5lCvRWrMrxsTny
	TB31ERU2fT1X2mExeXTMpsVXUDKyQUUDtqzRm3dW3MbXiS3iuskUZSDn6FibyOMSeT2lR/Knipa
	7MmhIMmqrRTw9kVx00ctBQPBcq
X-Received: by 2002:a05:600c:3e16:b0:477:755b:5587 with SMTP id 5b1f17b1804b1-48069c10f78mr74663935e9.8.1769635136165;
        Wed, 28 Jan 2026 13:18:56 -0800 (PST)
Received: from localhost (109-81-26-156.rct.o2.cz. [109.81.26.156])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4806d78cb6csm3510525e9.2.2026.01.28.13.18.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 13:18:55 -0800 (PST)
Date: Wed, 28 Jan 2026 22:18:54 +0100
From: Michal Hocko <mhocko@suse.com>
To: Frederic Weisbecker <frederic@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chen Ridong <chenridong@huawei.com>,
	Danilo Krummrich <dakr@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>, Phil Auld <pauld@redhat.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Simon Horman <horms@kernel.org>, Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>, Waiman Long <longman@redhat.com>,
	Will Deacon <will@kernel.org>, cgroups@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 04/33] mm: vmstat: Prepare to protect against concurrent
 isolated cpuset change
Message-ID: <aXp9Pp4YvlbJumeY@tiehlicka>
References: <20260125224541.50226-1-frederic@kernel.org>
 <20260125224541.50226-5-frederic@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260125224541.50226-5-frederic@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A82DA1C0006
X-Stat-Signature: dntk891sxa8yj76fywr3crnbkxag9dar
X-HE-Tag: 1769635137-929581
X-HE-Meta: U2FsdGVkX1+Ular8NrIE0X4eAt/WBOkrRkE8kNDkVxQpkatgGksjsG5UVnLoxJMncFwarlXdmYDZtZuRmJQ8zLBBIV6WZHCibKOFS94AwHpsuz/OZUwzwdU/CAwqjAz5gIckLL0Mt/nsOhVmJ2Q90tBNgyESgDPbazU6rWgGXhfJ4gQLCfG+epY3oA8HJr/H35LLSLKuHhXUBRTIBTO2yr6l88obAQNNwr7b25SP9cbDt6bg0L2zKXjlvAarJ9HyWlriwp2L2j8fA5g6Y6arBX9J/DN54EOo2GcBrc2ytIByoJpEz4CE+9gMBKFONhySGggZJ/P9F2NrhqPRKCzQWXd+Gz+M0hVveDARBKKAk2OCMtzkJMX0+Eay/inm4grfxpuTBiD0UfpGdvw+XJWZVWQ8gI8K0JkTAEO5nK7CIMj8FtME6F24DVoyqxdcaybkpCb+92cbQpmdhwVO7Z2FmzdtTbIQrWppOkkP1mAjtwDfM8PO0CLXiK6VpNDsIppWT5jxxeOTOH3sK4DNbZ6b1E7YMkzhBnG+SpDOqIRTYIBuT7vQobJfMdqk+MeRfMqxlXbOTZjKZ4fSsuSwtH0bcvL6dDjkJaDSCmyjSJS4ZhAjivCDMoC637qPCnN5mEuJVRSEvg6zBNCC99uwUjIooE0MFwlYclHoC67oblUia4af9QA+jS1znJeJ1V99nzQd+i9RQquu0K4dmvKCnQwMKdXLnqZ1GfesVU8nZAWwc4a/6ENkCyaRgH4iR1nLQ59OOL4tkdDrtYCNjikZJu2szyWBVveIm7k6onHB4kdTq/tE9XMwo44PXmEB/XzqHXIKmc0n1bCuZgtV7wPjadoIB1ePibM6564RwUbkNdXd0UxgZtJxs0nAugaxs8foigaNgvdOTZVCj+mDizA38hmitBfR5A8OsIZwjFqk0aXvm3H9yedbb4m0fTJiPe+/O6cJ/DC239GasMylQsodmjV
 35af+0Wq
 OJBw9JCbcq0VeCEHvblFBF5pCnI2DQH14RDvph98UKltYTmWzJBByVEB6mGPdjqaEm/h8gNBxaoq35EYyU6VbFKp6+a6nZF/X1ZSJwSacugmPAkyzC3p77lB2lOR15IbKy8oETB4YKC2tE/ScW+bVQOH4TEXeO/Qbptt75tsSlyvDfDGm42bBBOEK4lG+09YifyfMlRXBmF/rOz0J347u0XCuE9cFv6HPnxkiy9iMF8K5nb2jOu9YFy5hwAOhnBqHFSTH2e8j7Q0yf3+rNMh+93EQcLQ20bMJAzbu3s6IMnziB4xQa+Oa/Ez3W1ye1NzVY38UZqhwwkEtsMFxb2hSMBorPH6nV3tzGFdFE0wi0CDDX2Jk3N/ifaOilHRvIu7wq16lPCQPtme3KV0w8ET/wTmsxHpTlLopLwUuQWGf32enZ66IMKYOV7WnpRwoEjFIAPf4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun 25-01-26 23:45:11, Frederic Weisbecker wrote:
> The HK_TYPE_DOMAIN housekeeping cpumask will soon be made modifiable at
> runtime. In order to synchronize against vmstat workqueue to make sure
> that no asynchronous vmstat work is pending or executing on a newly made
> isolated CPU, target and queue a vmstat work under the same RCU read
> side critical section.
> 
> Whenever housekeeping will update the HK_TYPE_DOMAIN cpumask, a vmstat
> workqueue flush will also be issued in a further change to make sure
> that no work remains pending after a CPU has been made isolated.
> 
> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
>  mm/vmstat.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index 65de88cdf40e..ed19c0d42de6 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -2144,11 +2144,13 @@ static void vmstat_shepherd(struct work_struct *w)
>  		 * infrastructure ever noticing. Skip regular flushing from vmstat_shepherd
>  		 * for all isolated CPUs to avoid interference with the isolated workload.
>  		 */
> -		if (cpu_is_isolated(cpu))
> -			continue;
> +		scoped_guard(rcu) {
> +			if (cpu_is_isolated(cpu))
> +				continue;
>  
> -		if (!delayed_work_pending(dw) && need_update(cpu))
> -			queue_delayed_work_on(cpu, mm_percpu_wq, dw, 0);
> +			if (!delayed_work_pending(dw) && need_update(cpu))
> +				queue_delayed_work_on(cpu, mm_percpu_wq, dw, 0);
> +		}
>  
>  		cond_resched();
>  	}
> -- 
> 2.51.1
> 

-- 
Michal Hocko
SUSE Labs

