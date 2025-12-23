Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1875E6B25E
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 00:45:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AA336B0005; Mon, 22 Dec 2025 19:45:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 457BB6B0089; Mon, 22 Dec 2025 19:45:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 356E36B008A; Mon, 22 Dec 2025 19:45:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 237296B0005
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 19:45:52 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9741914041D
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 00:45:51 +0000 (UTC)
X-FDA: 84248893302.01.1EE35ED
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf03.hostedemail.com (Postfix) with ESMTP id A636A20002
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 00:45:44 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	spf=pass (imf03.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766450749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V+qWoNWb3ZWwrb3BxNDckjdgQmY4ZUiHfRu8HC8sAJQ=;
	b=P4Vo1GqgyYyWwB4fuQsQIpqFBObZVlpgMWFdCBNpTeTkyTid3gOmWzjW9CRt/ZPcCsAy1F
	cC+x1fxT6ru4MUC04uIWmn/uvYY/a2c/8o4dgsxkB1qQUruASx4vwHljfdw37tJDoOMGmm
	89A7ux+3jtlx5Tsn3TQhm4GkJQAsZxQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766450749; a=rsa-sha256;
	cv=none;
	b=sRS6e2FAKT1rjYrX4IcLc6VvgfmJJjMAZYuOaUmNJo0CrLmcpp4kjlrWDEpqEHLZgGngYI
	yZKsSoUHqMxeD1NY7fcrOBUZ93vbz6UGrIsFZvCc4dfUzyz0mfTQFxv/Tm8vFbrjyIeGWT
	8d+ME0f4TWgI2ChRohLMlYcD1HcbPg8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dZx9q4cH0zYQtGk
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 08:45:03 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id C0C264056B
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 08:45:39 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP4 (Coremail) with SMTP id gCh0CgB31_cy5klp8wiXBA--.20992S2;
	Tue, 23 Dec 2025 08:45:39 +0800 (CST)
Message-ID: <8aff3f15-79d6-48a0-a63d-735fabf6759d@huaweicloud.com>
Date: Tue, 23 Dec 2025 08:45:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next 1/5] mm/mglru: use mem_cgroup_iter for global
 reclaim
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, david@kernel.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, corbet@lwn.net, hannes@cmpxchg.org,
 roman.gushchin@linux.dev, muchun.song@linux.dev, zhengqi.arch@bytedance.com,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, lujialin4@huawei.com, zhongjinji@honor.com
References: <20251209012557.1949239-1-chenridong@huaweicloud.com>
 <20251209012557.1949239-2-chenridong@huaweicloud.com>
 <gkudpvytcc3aa5yjaigwtkyyyglmvnnqngrexfuqiv2mzxj5cn@e7rezszexd7l>
 <702b6c0b-5e65-4f55-9a2f-4d07c3a84e39@huaweicloud.com>
 <c4fjngkwbjlfnbjl5merldg5k2fiu43p46osagmy3ibr62cgxh@oesgt5l35kns>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <c4fjngkwbjlfnbjl5merldg5k2fiu43p46osagmy3ibr62cgxh@oesgt5l35kns>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB31_cy5klp8wiXBA--.20992S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Cw1rCw15Gw1DKw47Aw4Utwb_yoW8JFWkpr
	WDWa42ya1kA3y3GrsaqF4Fgw4Fkw4rJ3y5Xr4fJ343Aws8W3WfAF47Kw429F929w40yF10
	qFW2v395WFWjvFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWr
	XwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU0
	s2-5UUUUU==
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Stat-Signature: g98psqjz9cam4u7m3wnx9z4m7e9moerx
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A636A20002
X-Rspam-User: 
X-HE-Tag: 1766450744-704748
X-HE-Meta: U2FsdGVkX18C6oY/oNogseiDBclJHN5pBWlo0p5cOU2myCOGTkvpOcOCh/9yILeFl2Gmi6mPfKst9T3ZeeNy0AD2rP70+/RgYuWMm3rXysexqMTb4gaLfURZcn1QIdaJvtc46qVZhi+FHx3y43h4c/BktnqCa1wcxDPDyXpY9Ejzic4PHh451/ZVc64D/orinuR1txo6z/1bnBaDQN9CD+P51Xe/k3Fi/muRu/XrWeswh3ALugUMPv3T3XNJhI3sCQ1Pzu2QreefPfl6yxbtSs4/d8NWAKTcDBhczxGnPqyQW4sZsNlMv1zL1f8j84VDFxg/81ehlqTWcRxzw4vdOV/wbeXztBH25eB6w05qHt+IMZUBUxbJUYqBU+QQCnWm3NukjpX0ZQFqI6m8DtFw+4SutnZlxIA2bNlk3wTMjVV3PWgfOSbafu2t7/spYDyOa9CNDHCOh9q27ByTsqZd+Ny99BUI551xOnVo3EWamwHB9HY3NUkosPmsn8giavKwZgFAKfJ6AdczjTTXG6Y7faqKeOiDE6rY6+NlOnN/ac+PwDV3qS+v2uluNtJx5a/dJ8wU+lgGM+cqU9Xg3qY52qnJysaGF/ILl4DV9hi9ZJqoC4V+fXwCxTQId8HDg1qe33fPFcae8koRNex/15NV9X6dbFMsJSE+JaF2OQuxjHx6RS9ncfKL9xKTaxmTIE3SoelYrk68sQQy9N1H4IwzI5f+qv+Px8tA8W6ejerCJ+Q3ic11fpIbhTfAOFhRBRZb8OLszP56WPJ7UIk1r0gjWBE6EWDbcIVcRCpN7R7DYev2vpkqW3rDtow2WkmDizW+I7ZKdrKeATA+AY1yNXdsrQnXZda6U5VHw3JRBXln5yYTHGu74ppeNfTRpOPlRrdX2zx6PurtMa3FPr0AOQWfO3fgP6w6vqn67+EWvWdyP32JVdU8uwOuMOIXwFIZw1vX/IbuYRg69n0zkihXJX4
 dEARtxQh
 lKd8k6c5yKGb5XmboD+W66LltGAfkZdJ9a8dPUQ8FaK+yxZ8ZBMR6mefR2Aj9cUMplyn9ePQv3gT84IRs/M4VfQ84GJrO54GzRE0OH32ZdoFpZfpKiYnpAZlmwitQpOG2+mlnfytVRiOUgANXIKG5W1t2gDGOvdAZduMuNf+VA4IDcEYULZdhySMCpbNgBOu2QbZ+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/23 5:18, Shakeel Butt wrote:
> On Mon, Dec 22, 2025 at 03:27:26PM +0800, Chen Ridong wrote:
>>
> [...]
>>
>>>> -		if (should_abort_scan(lruvec, sc))
>>>> +		if (should_abort_scan(lruvec, sc)) {
>>>> +			if (cookie)
>>>> +				mem_cgroup_iter_break(target, memcg);
>>>>  			break;
>>>
>>> This seems buggy as we may break the loop without calling
>>> mem_cgroup_iter_break(). I think for kswapd the cookie will be NULL and
>>> if should_abort_scan() returns true, we will break the loop without
>>> calling mem_cgroup_iter_break() and will leak a reference to memcg.
>>>
>>
>> Thank you for catching that—my mistake.
>>
>> This also brings up another point: In kswapd, the traditional LRU iterates through all memcgs, but
>> stops for the generational LRU (GENLRU) when should_abort_scan is met (i.e., enough pages are
>> reclaimed or the watermark is satisfied). Shouldn't both behave consistently?
>>
>> Perhaps we should add should_abort_scan(lruvec, sc) in shrink_node_memcgs for the traditional LRU as
>> well?
> 
> We definitely should discuss about should_abort_scan() for traditional
> reclaim but to keep things simple, let's do that after this series. For
> now, follow Johannes' suggestion of lru_gen_should_abort_scan().
> 

Okey, understood.

-- 
Best regards,
Ridong


