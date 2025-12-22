Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0783E6748D
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 08:29:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 045F16B0088; Mon, 22 Dec 2025 03:29:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0AA66B0089; Mon, 22 Dec 2025 03:29:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC25D6B008A; Mon, 22 Dec 2025 03:29:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CA61D6B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 03:29:05 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 67AF5BC828
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 08:29:05 +0000 (UTC)
X-FDA: 84246431850.30.0091E69
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5D7DB40005
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 08:28:57 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	spf=pass (imf07.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766392143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b0TfbXSi2AXLImC/IbPoInvGeC2fmV5CnvJlw4u1NME=;
	b=l/RxaN5j8kMjCRq6gMNyFHNESR/RgAJLkabanUz1IDHhptALMIIQ7I0sXT36Ji6ltVh15P
	XYw0MZEO4H4ZmQLZhMV2vKFwRBrK/bwxGkSFRRLq8ddA5zS1AolaBednBsT939AvDierkC
	h2HD4Kx9bheRavmT2YVSHVdHJjGkIF8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766392143; a=rsa-sha256;
	cv=none;
	b=vQtroh7syIXx2cLyeno8wulIeTmhDz/EQ5rVLlaf7nYl1iMSDONCurhN8ifn0/GgnpTglg
	utj7PZe+PUkW/JiwiFkb2+81C81fZNcau9zaBK+42FWrFKUD0RX+vlRRtnSQhBsXD+mPl/
	EIhcVNb/VlDwLg6iPu8Qf9IJ5bs0gtQ=
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dZWVn6hNxzYQtns
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 16:28:17 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id E753F4056B
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 16:28:52 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP4 (Coremail) with SMTP id gCh0CgA3l_dDAUlp1vdGBA--.55773S2;
	Mon, 22 Dec 2025 16:28:52 +0800 (CST)
Message-ID: <2906e2b7-cc89-4d1b-893a-c20e4f100f97@huaweicloud.com>
Date: Mon, 22 Dec 2025 16:28:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm/vmscan: check all allowed targets in
 can_demote()
To: Bing Jiao <bingjiao@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 akpm@linux-foundation.org, gourry@gourry.net, longman@redhat.com,
 hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, tj@kernel.org,
 mkoutny@suse.com, david@kernel.org, zhengqi.arch@bytedance.com,
 lorenzo.stoakes@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, cgroups@vger.kernel.org
References: <20251220061022.2726028-1-bingjiao@google.com>
 <20251221233635.3761887-1-bingjiao@google.com>
 <20251221233635.3761887-3-bingjiao@google.com>
 <d5df710a-e0e1-4254-b58f-60ddc5adcbd5@huaweicloud.com>
 <aUjgt4EdBv4UyrTM@google.com>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <aUjgt4EdBv4UyrTM@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgA3l_dDAUlp1vdGBA--.55773S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Cr1kAFykGF1kXw1kuFW7Jwb_yoW8Zr4fpF
	1UCF12ya1kXr1fCws2v340v34Fvw18JF4UJF1rJFn3Cr9IyF1xAFn8ta1YgFyrWF1fur10
	qayYkw4xua4DAFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvYb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWr
	XwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x07
	jIksgUUUUU=
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5D7DB40005
X-Stat-Signature: u8596zmw3x9gxu6rdmc119xacoq8x43b
X-HE-Tag: 1766392137-249571
X-HE-Meta: U2FsdGVkX19p3NbYyzzjd7LhcDPoLzztVSJ7mEtKpVt8Qyx+UjbJZ0iJFBy5Uezk0v+0VqCxnPJRPTIdfSjWPtNcV6Rmt27rQy8MHyv1sjaq5vzw4NMr/FjuwXbz2wsZTfNOB/f49QMYmdEBIT3SYJW/cOCgqhqNOxjlgVuvqnHKBt3IKXdcbHnrUhXvUi+73sw7Ll1edgP/FSEnDu/ra2/VEYbZlEqakXFpz2sUMw7UhPOnf7iwLSdvGYTMtMtvE9CuUYJis/klplNqxHnKWcvzEyoIP/1fbezn6Iw+PBy+4RbzUOTlbeZrSezdfjs74quyTAYsGDyFH6daQH24nN2b12H9sySPp7eNfIN+pyXoOuModiO1N2HXf12GP3teH3vVEDG6qmzsqYWdS3sE80jeC5p2LqO1AKA1x3qhtlVOFlfrfxjdClXZZ68W5hmDO1IBzYhtxJwmA8uNlXvmHYp2kVLZelxnclVwsfp88l8HHGkgzNrf4+0VvWA/2flDFaBLITPgQQTC/hNhsgahcJbMPxwIT6u8zKriMiWQ1PiiTXMA4hhUH2oHTiY0wWeM/PjwdXdarw89/U7yhWy3Tpq2mSTvPvWtIUmuRsdTUq1qmpNjHZAVNgFJG0/6jouqkpZWcFnT7RhPY/hl39Yi8izHI5ywQvlR4rjahfEoa6NGkjjZ6QfmmMAmkqnHWCjygL4rG+qt9T8a4Zx693C6WM59jOQUvfhe2mN7KRIPJj8Q38cE9uo5Hs25dSDxtAy/RltohsYaxbvug3YAXcr6gKLCqe5ciIJCHBXWJVsb7pfKijonNjjz+JuBY/W768i7PT+IhsAwaVVNVKIpM8v8uJZ4/+AJXyPmfLuetP1MEXDspbRlTxB7gIE8VvJsuQlhjaChjRaQ/Q3F+fHosu+e4Qr5EF8GvmkPupvJnWWixaWNplEEhej3tXUBqc0qwX6OwAvEjoJA+s2O8PlRFOZ
 Yx02pI7X
 q0zD/sAojywzWGJac4OQW6bl+netsQ4AFhqrXodjLAlrovFFEreO3FliGQuzg+hpcCPvH/cQokBrmgeVlFQpqO7iwsOitxJCTCls8WgwrZEA0YgWN4M7bfO2hLsViF2et7yFvcL9RggdPXotdoEBTHMbxVO5Thr3b+fPKSOXc6D7OHN0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/22 14:09, Bing Jiao wrote:
> On Mon, Dec 22, 2025 at 10:51:49AM +0800, Chen Ridong wrote:
>>
>>
>> On 2025/12/22 7:36, Bing Jiao wrote:
>>> -void cpuset_node_filter_allowed(struct cgroup *cgroup, nodemask_t *mask)
>>> -{
>>> -	struct cgroup_subsys_state *css;
>>> -	struct cpuset *cs;
>>> -
>>> -	if (!cpuset_v2())
>>> -		return;
>>> -
>>> -	css = cgroup_get_e_css(cgroup, &cpuset_cgrp_subsys);
>>> -	if (!css)
>>> -		return;
>>> -
>>> -	/* Follows the same assumption in cpuset_node_allowed() */
>>> -	cs = container_of(css, struct cpuset, css);
>>>  	nodes_and(*mask, *mask, cs->effective_mems);
>>>  	css_put(css);
>>>  }
>>
>> Oh, I see you merged these two functions here.
>>
>> However, I think cpuset_get_mem_allowed would be more versatile in general use.
>>
>> You can then check whether the returned nodemask intersects with your target mask. In the future,
>> there may be scenarios where users simply want to retrieve the effective masks directly.
>>
> 
> Hi Ridong, thank you for the suggestions.
> 
> I agree that returning a nodemask would provide greater versatility.
> 
> I think cpuset_get_mem_allowed_relax() would be a better name,
> since we do not need the locking and online mem guarantees
> compared to an similar function cpuset_mems_allowed().
> 

I think the key difference between cpuset_mems_allowed and the helper you intend to implement lies
not in locking or online memory guarantees, but in the input parameter: you want to retrieve
cpuset->effective_mems for a cgroup from another subsystem.

The cs->effective_mems should typically only include online nodes, except during brief transitional
periods such as hotplug operations. Similarly, node migration logic also requires online nodes.

Therefore, cpuset_get_mem_allowed seems acceptable to me.

Additionally, you may consider calling guarantee_online_mems inside your new helper to ensure
consistency.

-- 
Best regards,
Ridong


