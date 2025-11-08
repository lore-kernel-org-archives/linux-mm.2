Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0687CCFA1A
	for <linux-mm@archiver.kernel.org>; Sat,  8 Nov 2025 09:05:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C10648E000A; Sat,  8 Nov 2025 04:05:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE83C8E0003; Sat,  8 Nov 2025 04:05:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFE488E000A; Sat,  8 Nov 2025 04:05:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 960D78E0003
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 04:05:27 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2878C4BE44
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 09:05:27 +0000 (UTC)
X-FDA: 84086856294.28.6A61705
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf09.hostedemail.com (Postfix) with ESMTP id F0138140012
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 09:05:16 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	spf=pass (imf09.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762592725; a=rsa-sha256;
	cv=none;
	b=L883c5yNW1tTHnq9OMit5uj/5g0eks+wTqd3osgrW8sJaodYVHZXj/jqlepi2b4j2pOBZb
	+8YdBI34plEf8dQsypwiAoe4YDPVbofApQX5QPra+Ih2ZIDL+emqsk+ecTAxqT5zFFLx9+
	W6LgM0yHIoKcr13vjWWMM/wRJbWIfz0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762592725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BRq2F/Fx5L2pqw/kvbroKu2B4rLSIR/GciQ6lz1GC2Y=;
	b=Jc2ic2rc4nDjlhqFBoXhdHDBAGnEX0iqE1ATW911PWGS8moNaDguGMQHpltCynB2yd/xdE
	AyI+bY1RtexM73uCW14ze4tgazyCck+oJrm1B+/X7sQ9fXEpGR4IYn+XHBv9CrZkO6ETiq
	0wrEGjzczoxs86rvuMBkAQN4D9HBKGQ=
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4d3VPG20MjzYQtsR
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 17:04:50 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id B7B111A18E0
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 17:05:11 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP4 (Coremail) with SMTP id gCh0CgAnUF3GBw9pgLIYAA--.42082S2;
	Sat, 08 Nov 2025 17:05:11 +0800 (CST)
Message-ID: <e0c0f8b7-112f-40d7-b211-89065e9003b2@huaweicloud.com>
Date: Sat, 8 Nov 2025 17:05:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 13/31] cpuset: Update HK_TYPE_DOMAIN cpumask from cpuset
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
 <20251105210348.35256-14-frederic@kernel.org>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <20251105210348.35256-14-frederic@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgAnUF3GBw9pgLIYAA--.42082S2
X-Coremail-Antispam: 1UD129KBjvdXoW7JrWUCF4fXF43Gr1UAF4kCrg_yoWDuFc_Wr
	15WF4Uuw15JFyqgw1Yy34qga1fJa17t39aqa48try5W3Z5JF43Jrs3A345Ca13Xa4xJF1a
	934kK393ZrnFqjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbxkYFVCjjxCrM7AC8VAFwI0_Wr0E3s1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
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
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F0138140012
X-Stat-Signature: 84ysprzfzdujzcfe9nod35s61ofcgkfn
X-HE-Tag: 1762592716-459718
X-HE-Meta: U2FsdGVkX1/sqOyt5LzwGo3x28B45ECba3euqz4NQycaMZ1SbWk0y8cB9PJfZNSowLBC8L3H0eOX2pW+em/gjr+9+Qs6f2iAwcfVEa9vcE8Iu+3+pte/hCA/9DggZjm7rNdpTjTvWVS1Y2+Lc2XM0ViP81gITuTGecam9Es74yrieqmVZ3TChJmfxH5Td+A19qUoO9T0r44154Nkbc871/dKBYPY6GKU2tdOIcgu+i6TUubG3a96M7C6fpB/SZDtiOjFWkFvrCfoOttwhVoumPzoEqUqtKE0awn3q8XV9yjjsooDE4u32KJ5B0xLEK3SO8oB0K8RUmWyaPy66Rutc1LLzd47COKotGc876ePMf3EwEuieXchxtAz3g05y3kGHaXbbSGz3rUl72jexCt2Cvy2sk2FAszYpTwExKn3c0NnpY0LxD9M8pzE0MvrD6Fu+j2kQF5hJTa4g1kEkVesyi/CrMCqipXdVBP688h9YpdtRnt4IOnCzOigxcC9bKS51mtkJCRrmfjNv+Ks5nDH8Oz3lKmKgX32ggG9KkTiPPiuDFZGjGRhvEA+UtZG0yFQaoJHt0uxB06j+S0+mPlltuu12OMMQNcCBKs4wnR2oy+ysZnPHGY7vT4pMP510hfC3q72hIWVNpiye17frx0BzwARgLYMCm0rLv+Whc2eb/oWbST+nbXRqC9Fij868746ITEPkj+2zcR2qUqXvGlHRlHx9f5P74IAzSYO+lmvFmqXP7Z5D9FJTW0siJSuaCPptd3COExKZOFouzH8Qun78mGB5cjbJ0ApeYi2Xvjm/s99cFCqu3swnyLtgIAjpp/0NVB/MIdZNFGoLHmZ0KtuRYF4kuBZrvkr5kshKFekqLuK6DUf66FdHDq0otxMJO6YscocaRAyrOGCQ+kc4iVAEcbrnYbcSc7+1JbjNnRWTc2mA+jl1wovmITZajtB/rLzjpFqH5zXGAEgglHUCDT
 zesz6R5E
 QLr8NJnA13lOsNSo1ZyT/BBZDf7+agktWdf6qZ7sR1uf9h3RuNZg6VDVDdKlGsvHRr9LCML35NgR7ch5Lbj/eshJRy0ZK6OQOaAXEF1A27OIyC0UOI3f9p4KBY67Ftg0QHIhLyjFxqqp4q1YvEqiFboOhi0x1EuxhjvX0CRipCeEPvDs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>




> +int housekeeping_update(struct cpumask *mask, enum hk_type type)
> +{
> +	struct cpumask *trial, *old = NULL;
> +
> +	if (type != HK_TYPE_DOMAIN)
> +		return -ENOTSUPP;
> +
> +	trial = kmalloc(cpumask_size(), GFP_KERNEL);
> +	if (!trial)
> +		return -ENOMEM;
> +
> +	cpumask_andnot(trial, housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT), mask);

Since there's no comment for the 'mask' parameter, would it be better to name it 'isol_mask'? This
would make it clearer that this is the isolation mask input and what is doing here.

> +	if (!cpumask_intersects(trial, cpu_online_mask)) {
> +		kfree(trial);
> +		return -EINVAL;
> +	}
> +
> +	if (!housekeeping.flags)
> +		static_branch_enable(&housekeeping_overridden);
> +
> +	if (housekeeping.flags & BIT(type))
> +		old = housekeeping_cpumask_dereference(type);
> +	else
> +		WRITE_ONCE(housekeeping.flags, housekeeping.flags | BIT(type));
> +	rcu_assign_pointer(housekeeping.cpumasks[type], trial);
> +
> +	synchronize_rcu();
> +
> +	kfree(old);
> +
> +	return 0;
> +}
> +


-- 
Best regards,
Ridong


