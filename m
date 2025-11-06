Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A05ECCF9F8
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 01:20:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC65A8E0009; Wed,  5 Nov 2025 20:20:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D76B48E0002; Wed,  5 Nov 2025 20:20:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C66148E0009; Wed,  5 Nov 2025 20:20:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AEB938E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 20:20:37 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6682888652
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 01:20:37 +0000 (UTC)
X-FDA: 84078427314.09.11F8A64
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf24.hostedemail.com (Postfix) with ESMTP id 40F46180012
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 01:20:32 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	spf=pass (imf24.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762392035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qR8bcP4Haf1jVpemGjVbv5/S3g45vDofyEAO2bsulko=;
	b=LpNToFvRfZC7H6fBOKTMqLAXsxGuQC8uLKAEMasMTuM9wgjEFKLB+UG6wv46X5zNzv/UOm
	4+QxRk8+zzUPnoeMi9n6ytE22MyO3ym5DSh9WnI70hydbs6+GG1oWVQaFq4erMmjbDrqc4
	Deoqa09aUhC9OSO3Fpq9qYaGbTHW/rE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762392035; a=rsa-sha256;
	cv=none;
	b=mdM0vmkUfcZCtvWKV7AxZ9cnbRoD+2/39A1TXh7eYPuvfExsI93x/wYRjCV2o5ClzsFhr2
	KuVfBrxKGHg/XjuWuxzMnUFHIY+2gQC5myr9SNDsF7UR2UgnLA7s+qVkyRtrM2u7+8Z+jT
	MUftSIskR2oCrvwaSlL+zS7/SXB1HMA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4d24BD3lnzzKHMLt
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 09:20:20 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 8A4421A092F
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 09:20:28 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP2 (Coremail) with SMTP id Syh0CgAHqEDb9wtp6fpnCw--.52284S2;
	Thu, 06 Nov 2025 09:20:28 +0800 (CST)
Message-ID: <7742487a-81e0-430f-8c4d-f1a761c2af98@huaweicloud.com>
Date: Thu, 6 Nov 2025 09:20:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/31] cpuset: Convert boot_hk_cpus to use
 HK_TYPE_DOMAIN_BOOT
To: Frederic Weisbecker <frederic@kernel.org>,
 LKML <linux-kernel@vger.kernel.org>
Cc: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Bjorn Helgaas <bhelgaas@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Danilo Krummrich
 <dakr@kernel.org>, "David S . Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Gabriele Monaco <gmonaco@redhat.com>,
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
 Vlastimil Babka <vbabka@suse.cz>, Waiman Long <longman@redhat.com>,
 Will Deacon <will@kernel.org>, cgroups@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-pci@vger.kernel.org, netdev@vger.kernel.org
References: <20251105210348.35256-1-frederic@kernel.org>
 <20251105210348.35256-7-frederic@kernel.org>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <20251105210348.35256-7-frederic@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:Syh0CgAHqEDb9wtp6fpnCw--.52284S2
X-Coremail-Antispam: 1UD129KBjvJXoW7WryDGF1kuFW3trWkJFWDArb_yoW8Kw45pr
	47X3yUKa95JF1rG345J3WqvryFgws7Jr1DC3ZxGw1rXasrCF18ArW09asayFyFv34kur47
	Zrn8CF4SgF4rArJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AF
	wI0_Wrv_ZF1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26rWY6r4U
	JwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU0
	EksDUUUUU==
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 40F46180012
X-Stat-Signature: kdrdsmg6mp7h74pq6u7n7i99necbjmhe
X-HE-Tag: 1762392032-289074
X-HE-Meta: U2FsdGVkX1/SqC1S3Pb65aUzSOyqvt0zTANqFEo0+h88rhJv5dMUGtc2Mw7tsM3T6coq93N3YPKslmNLoFn1ceW6LnjQfGaDhlH4i/eglOub/lOqN0p/gAlP5kvN4CHKOPC4NBk3ffR9UiQM2asq05hnxc63KO5g6JON6gNOgnQTzyB+aGG4O1eCqRrRYFmcIoHG2v4VIEZSiNupUoXoTgbmScVfKUWTx1mFfnF6ZHvAQKBd8QwfFyimYuZmt1V1/ua2JgYAvIWXUXZMCBw9emBjnTrumHLZnKq62UJt6RSu4vsTrBooZPV3SDoyUZ9Me3HvlBTjng7psmcXGeoVYdLC4E7QQcPsa80rgEolgifXGASXauDauGIm6KtUDtZnvNpp8b2+lMwvSpxb1msycybb+Th+zeKGDn+jK4uV2SF+KjuNGc2goEmUBDM5cG4cRzS9lL8eqLAvIyJW3JnVAtoLFJeNXOZg+d8wpjG21nEeb2eUZE+LPVOikKg1117IvCesakBEiYsvE41CgP2hPD+emyM9nCkC6GImgnxlZ3qOtYsnSCtZh2sWaGTCVkkDbqIMPfa5RrFz/rP5x2pPvarYo7QSEz4+/MY6pq9tdvg2faub67RxesBhzhuxsV0OnlV0FPTuIUwBjmaFwu/72Ziv+x2b2ZJmAle2D/7b6VxQPKeOtmFLapId1I63KscCpP3EfkPTcXbIJVyGr+gkhEGEpplEIeKoPKBWee6nq5hJgAZM4a3Ju+pjo3D8ZHSwrHvXrSDakjy66XeHVnE4PF7iJRUdES+qeO3FCBeLkhxbpeCPxrsHmApOQk0r9nktGy+3O3zSM7Fsq5ifFBTv+tnscGPa1qvNuxXs8MYAucaTfQEReut8z8xIHcaFe6vRICycAdxWfi0m23x8LtiTITlMQFRZl7iqQ1RYsJMme0E20U149I4ecSUqmFDLClWxz1ZzvKYbqlrHAYdas5+
 x3ZcJ1lx
 Douhc7pW00yUjhyXFT3JGyNoEjgdxI4OnjlRtMhZ2KF2JBgI+nrPgXqfUbzNw+qZQY63vVmtnc5ZtH/8OFZJdXWyxyuQJfbgAeX4RmXAwFRpqkqkuKirOOeu4uRU5OkMemmfWYy7bb20nNr4vMUw6M9bzb92nDrOcgH3o6uZIHlVEwYwAcV7v7ytJX/JCppFsrTw95Tv4JjNCA9CBcIXtn2Kl3k84Ix6oTSIzxLELTY9rpUw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/11/6 5:03, Frederic Weisbecker wrote:
> boot_hk_cpus is an ad-hoc copy of HK_TYPE_DOMAIN_BOOT. Remove it and use
> the official version.
> 
> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> Reviewed-by: Phil Auld <pauld@redhat.com>
> ---
>  kernel/cgroup/cpuset.c | 22 +++++++---------------
>  1 file changed, 7 insertions(+), 15 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 52468d2c178a..8595f1eadf23 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -81,12 +81,6 @@ static cpumask_var_t	subpartitions_cpus;
>   */
>  static cpumask_var_t	isolated_cpus;
>  
> -/*
> - * Housekeeping (HK_TYPE_DOMAIN) CPUs at boot
> - */
> -static cpumask_var_t	boot_hk_cpus;
> -static bool		have_boot_isolcpus;
> -
>  /* List of remote partition root children */
>  static struct list_head remote_children;
>  
> @@ -1686,15 +1680,16 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
>   * @new_cpus: cpu mask
>   * Return: true if there is conflict, false otherwise
>   *
> - * CPUs outside of boot_hk_cpus, if defined, can only be used in an
> + * CPUs outside of HK_TYPE_DOMAIN_BOOT, if defined, can only be used in an
>   * isolated partition.
>   */
>  static bool prstate_housekeeping_conflict(int prstate, struct cpumask *new_cpus)
>  {
> -	if (!have_boot_isolcpus)
> +	if (!housekeeping_enabled(HK_TYPE_DOMAIN_BOOT))
>  		return false;
>  
> -	if ((prstate != PRS_ISOLATED) && !cpumask_subset(new_cpus, boot_hk_cpus))
> +	if ((prstate != PRS_ISOLATED) &&
> +	    !cpumask_subset(new_cpus, housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT)))
>  		return true;
>  
>  	return false;
> @@ -3824,12 +3819,9 @@ int __init cpuset_init(void)
>  
>  	BUG_ON(!alloc_cpumask_var(&cpus_attach, GFP_KERNEL));
>  
> -	have_boot_isolcpus = housekeeping_enabled(HK_TYPE_DOMAIN);
> -	if (have_boot_isolcpus) {
> -		BUG_ON(!alloc_cpumask_var(&boot_hk_cpus, GFP_KERNEL));
> -		cpumask_copy(boot_hk_cpus, housekeeping_cpumask(HK_TYPE_DOMAIN));
> -		cpumask_andnot(isolated_cpus, cpu_possible_mask, boot_hk_cpus);
> -	}
> +	if (housekeeping_enabled(HK_TYPE_DOMAIN_BOOT))
> +		cpumask_andnot(isolated_cpus, cpu_possible_mask,
> +			       housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT));
>  
>  	return 0;
>  }

Reviewed-by: Chen Ridong <chenridong@huawei.com>

-- 
Best regards,
Ridong


