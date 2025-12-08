Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9377BD2CE17
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 02:27:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD9366B0008; Sun,  7 Dec 2025 21:27:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8BB66B000A; Sun,  7 Dec 2025 21:27:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7D266B000C; Sun,  7 Dec 2025 21:27:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A0DB76B0008
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 21:27:14 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3F44C12EFA
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 02:27:14 +0000 (UTC)
X-FDA: 84194716788.30.F544A11
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf13.hostedemail.com (Postfix) with ESMTP id 513B120006
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 02:27:07 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	spf=pass (imf13.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765160832; a=rsa-sha256;
	cv=none;
	b=XeSSeBTvNp6bt/eL9ny8OsgBtLzH+04hA2i6zSmyZlNUQYgBKpACqGRZkWK5SFo/WNPJXc
	hawDxVh3zh0mz6qwfVGs+axYrpB92yE2N5+Swoj51Hof8qH3UXQB5ko3bsWsRMH6cazztc
	NrzE8Fl5BI16eOVKQ+iNIOuGuvAh1Zw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765160832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=91HDWzMIl8X2IrSy07pseJ9XkQqAIAhQ8mPwkKpi+PE=;
	b=du/k6LDqhjd7cQHY7raQqd+rqD9H/hhwg23Rdtf042MocAzY8/EA6haeXgYkmJROKJrzKz
	86O9b8n8jZ82SRUnZluh/K2kfpdwciIqBfvd6dZdQW2gPQhAgHreJgO7YaDQRC2rveFFHT
	CgAX/Ci8AnxWolqaBYkQ6uIe/XUyYeM=
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dPm8D5DxQzYQthp
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 10:26:52 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id BDE4E1A0B41
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 10:27:03 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP4 (Coremail) with SMTP id gCh0CgCXwJ10NzZpuBbzAw--.48454S2;
	Mon, 08 Dec 2025 10:27:01 +0800 (CST)
Message-ID: <e657d5ac-6f92-4dbb-bf32-76084988d024@huaweicloud.com>
Date: Mon, 8 Dec 2025 10:26:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH -next 1/2] mm/mglru: use mem_cgroup_iter for global
 reclaim
To: Shakeel Butt <shakeel.butt@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, david@kernel.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, corbet@lwn.net, hannes@cmpxchg.org,
 roman.gushchin@linux.dev, muchun.song@linux.dev, yuzhao@google.com,
 zhengqi.arch@bytedance.com, linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, lujialin4@huawei.com,
 chenridong@huawei.com
References: <20251204123124.1822965-1-chenridong@huaweicloud.com>
 <20251204123124.1822965-2-chenridong@huaweicloud.com>
 <tvrspnhlo7x7gpjc4nn7f73b2qoyphkpaxlcnnn4fsxciv6bks@3dibvbs7u5do>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <tvrspnhlo7x7gpjc4nn7f73b2qoyphkpaxlcnnn4fsxciv6bks@3dibvbs7u5do>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCXwJ10NzZpuBbzAw--.48454S2
X-Coremail-Antispam: 1UD129KBjvAXoW3ZF1UZFWfCr4kCrW5JFWUArb_yoW8XFWDXo
	W3Zr15Kw1fArW7Zr1kWa1kCrn7XrsrGF1kKrW3uws8Zr1xXa4xKayrA3sF9w1UXw1qyr98
	GayfKF4SkFySyF93n29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UjIYCTnIWjp_UUUY27kC6x804xWl14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK
	8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4
	AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF
	7I0E14v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7
	CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8C
	rVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4
	IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACI402YVCY1x02628vn2kIc2xKxwCY1x0262kK
	e7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c
	02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_
	WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7
	CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v2
	6r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07
	jIksgUUUUU=
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Stat-Signature: 8f6at53eqxr4dw93bywuutbqo1xcnuow
X-Rspam-User: 
X-Rspamd-Queue-Id: 513B120006
X-Rspamd-Server: rspam01
X-HE-Tag: 1765160827-733830
X-HE-Meta: U2FsdGVkX18cTVnjE/AH6DINsmu83Fms0UKzUP4d+wCMyPKsk0OUhkCSd0bpIqgsiG99mrqLhizbB3OdyVa9cS+8Ff/NIkroJhvEpg5aFxOIHiCFCW8HPX4kRxPuPKNQU+vldxOujDUdmb1+B2R+OnQRV8VsnoPNA7bXPZSSHpzA4+WEKHqtx23Shh7EhYmRcDocNEa+OybOzPsTpgIFFx9Hl3Win4gIlrhxm1IcTiUn6NfWFrQ5qbUgUU2/RSTg8nQ2Z/b05aXo09W9wz4r6jw416Gv+WBrSnjSzkuGZ6KMKnb5ZJdwb9EIn7JqQK2tfhzBTkKIQL7O9fGz+d3uwrBX3DJwkjGsuSLOc/U47li0REHdaRQ8NvK19loJwMNsLwtiGi1qLpgd23mH5GVfYr5qKFX9YWtY5Bg1KYbO+XMbb5ZRX3P9781sw+wuxzZRh/WqrvoH54ydLJVZAdDlG9E7C9eX3LfJ78DV/xmwy3yLataA7YPp9ONVWKa0Eq4LzMpIoYuIr4tFaYGpLGVE4Ili0/VL30S2pWJ/1D45w4cDVDQUBmIObktxpUsiyaDJ0Y00Waszz6633zsmgi8WMC9DgmV8bok3vHjGe3OEAByd8WMwOrG46nOBGorddODh5OPV4z4aDn9u4XN+ZSpwi2V7D3ketQasY6YTXW/VZFHzCzYkx3WGCaFwKo/ATjuLmRra6ARQGPbv2qLnzK+kl5zCnNLthCV9ZjqYIde8Qx0R+5bJbv/9CqxZvdupVK4x/euXiYcEmLbk9Ly1amMz1H2YgWYNeUEx+m8u+5r3/QJ0Iol1xv+KS7DbecR/dTmasrbi3cp4cCVaFv4jt++/LydD7oL0x3jHGbFlwVNp0o2ZYM639gLMNluRnC3qfil7kUDuWBW4/MkOsvMwb1Am9Xr0Ujx/+icaLqMcuwXCJ2DD4qx4uKVaPK/ulVdK4Wuef7bGSBbGekZgEqsHRdC
 Jo2JBZNy
 MZg9w1GA1dDIVERO68f2mKGnIMp5IxOScbLjv75dEBjMe63EKU9fv6n14vJUCfkky0Uuc+zpq4afzxgz4skPkYh80Ut/GPn+tflYG2XZr5FzRlHfTdGbJ29W/ovZadxY+31HY9MByZFfFkk5iGiF3O946icKKgKKIMJDcU+eOIOIqoN3sjhjpwN0DoYM9tBr+B83u9SJHS1GjocxTnrBoRDjoq88WH9Xl1s5ck9cHA5SnMoGks4v2j1tjIkgQJ1GnY76iFaLhScO5pWYWKtLqnqjtO8tPucpL/C7sA2Qcwn4ddZ3l2hXzetsemm3FJ3DGJSrc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/5 6:29, Shakeel Butt wrote:
> Hi Chen,
> 
> On Thu, Dec 04, 2025 at 12:31:23PM +0000, Chen Ridong wrote:
>> From: Chen Ridong <chenridong@huawei.com>
>>
>> The memcg LRU was originally introduced for global reclaim to enhance
>> scalability. However, its implementation complexity has led to performance
>> regressions when dealing with a large number of memory cgroups [1].
>>
>> As suggested by Johannes [1], this patch adopts mem_cgroup_iter with
>> cookie-based iteration for global reclaim, aligning with the approach
>> already used in shrink_node_memcgs. This simplification removes the
>> dedicated memcg LRU tracking while maintaining the core functionality.
>>
>> It performed a stress test based on Zhao Yu's methodology [2] on a
>> 1 TB, 4-node NUMA system. The results are summarized below:
>>
>> 					memcg LRU    memcg iter
>> stddev(pgsteal) / mean(pgsteal)            91.2%         75.7%
>> sum(pgsteal) / sum(requested)             216.4%        230.5%
>>
>> The new implementation demonstrates a significant improvement in
>> fairness, reducing the standard deviation relative to the mean by
>> 15.5 percentage points. While the reclaim accuracy shows a slight
>> increase in overscan (from 85086871 to 90633890, 6.5%).
>>
>> The primary benefits of this change are:
>> 1. Simplified codebase by removing custom memcg LRU infrastructure
>> 2. Improved fairness in memory reclaim across multiple cgroups
>> 3. Better performance when creating many memory cgroups
>>
>> [1] https://lore.kernel.org/r/20251126171513.GC135004@cmpxchg.org
>> [2] https://lore.kernel.org/r/20221222041905.2431096-7-yuzhao@google.com
>> Signed-off-by: Chen Ridong <chenridong@huawei.com>
> 
> Thanks a lot of this awesome work.
> 

Hello Shakeel and Johannes,

I apologize for the incorrect results I provided earlier. I initially used an AI tool to process the
data (I admit that was lazy of me—please forget that). When I re-ran the test to re-extracted the
refault data and processed it again, I found that the AI tool had given me the wrong output.

I have now processed the data manually in Excel, and the correct results are:

pgsteal：
						memcg LRU    memcg iter
stddev(pgsteal) / mean(pgsteal)			106.03%		93.20%
sum(pgsteal) / sum(requested)			98.10%		99.28%

workingset_refault_anon：
						memcg LRU    memcg iter
stddev(refault) / mean(refault)			193.97%		134.67%
sum(refault)					1963229		2027567

I believe these final results are much better than the previous incorrect ones, especially since the
pgsteal ratio is now close to 100%, indicating we are not over-scanning. Additionally, refaults
increased by 64,238 (a 3.2% rise).

Let me know if you have any questions.

----------------------------------------------------------------------

The original data memcg LRU:
pgsteal:
SUM: 38572704 AVERAGE: 301349.25 STDEV: 319518.5965
refault:
SUM: 1963229 AVERAGE: 15337.72656 STDEV: 29750.03391

pgsteal	655392				workingset_refault_anon	17131
pgsteal	657308				workingset_refault_anon	24841
pgsteal	103777				workingset_refault_anon	430
pgsteal	103134				workingset_refault_anon	884
pgsteal	964772				workingset_refault_anon	117159
pgsteal	103462				workingset_refault_anon	539
pgsteal	102878				workingset_refault_anon	25
pgsteal	707851				workingset_refault_anon	30634
pgsteal	103925				workingset_refault_anon	497
pgsteal	103913				workingset_refault_anon	953
pgsteal	103020				workingset_refault_anon	110
pgsteal	102871				workingset_refault_anon	607
pgsteal	697775				workingset_refault_anon	21529
pgsteal	102944				workingset_refault_anon	57
pgsteal	103090				workingset_refault_anon	819
pgsteal	102988				workingset_refault_anon	583
pgsteal	102987				workingset_refault_anon	108
pgsteal	103093				workingset_refault_anon	17
pgsteal	778016				workingset_refault_anon	79000
pgsteal	102920				workingset_refault_anon	14
pgsteal	655447				workingset_refault_anon	9069
pgsteal	102869				workingset_refault_anon	6
pgsteal	699920				workingset_refault_anon	34409
pgsteal	103127				workingset_refault_anon	223
pgsteal	102876				workingset_refault_anon	646
pgsteal	103642				workingset_refault_anon	439
pgsteal	102881				workingset_refault_anon	110
pgsteal	863202				workingset_refault_anon	77605
pgsteal	651786				workingset_refault_anon	8322
pgsteal	102981				workingset_refault_anon	51
pgsteal	103380				workingset_refault_anon	877
pgsteal	706377				workingset_refault_anon	27729
pgsteal	103436				workingset_refault_anon	682
pgsteal	103839				workingset_refault_anon	336
pgsteal	103012				workingset_refault_anon	23
pgsteal	103476				workingset_refault_anon	729
pgsteal	102867				workingset_refault_anon	12
pgsteal	102914				workingset_refault_anon	122
pgsteal	102886				workingset_refault_anon	627
pgsteal	103736				workingset_refault_anon	514
pgsteal	102879				workingset_refault_anon	618
pgsteal	102860				workingset_refault_anon	3
pgsteal	102877				workingset_refault_anon	27
pgsteal	103255				workingset_refault_anon	384
pgsteal	982183				workingset_refault_anon	85362
pgsteal	102947				workingset_refault_anon	158
pgsteal	102880				workingset_refault_anon	651
pgsteal	973764				workingset_refault_anon	81542
pgsteal	923711				workingset_refault_anon	94596
pgsteal	102938				workingset_refault_anon	660
pgsteal	888882				workingset_refault_anon	69549
pgsteal	102868				workingset_refault_anon	14
pgsteal	103130				workingset_refault_anon	166
pgsteal	103388				workingset_refault_anon	467
pgsteal	102965				workingset_refault_anon	197
pgsteal	964699				workingset_refault_anon	74903
pgsteal	103263				workingset_refault_anon	373
pgsteal	103614				workingset_refault_anon	781
pgsteal	962228				workingset_refault_anon	72108
pgsteal	672174				workingset_refault_anon	19739
pgsteal	102920				workingset_refault_anon	19
pgsteal	670248				workingset_refault_anon	18411
pgsteal	102877				workingset_refault_anon	581
pgsteal	103758				workingset_refault_anon	871
pgsteal	102874				workingset_refault_anon	609
pgsteal	103075				workingset_refault_anon	274
pgsteal	103550				workingset_refault_anon	102
pgsteal	755180				workingset_refault_anon	44303
pgsteal	951252				workingset_refault_anon	84566
pgsteal	929144				workingset_refault_anon	99081
pgsteal	103207				workingset_refault_anon	30
pgsteal	103292				workingset_refault_anon	427
pgsteal	103271				workingset_refault_anon	332
pgsteal	102865				workingset_refault_anon	4
pgsteal	923280				workingset_refault_anon	72715
pgsteal	104682				workingset_refault_anon	372
pgsteal	102870				workingset_refault_anon	7
pgsteal	102902				workingset_refault_anon	661
pgsteal	103053				workingset_refault_anon	40
pgsteal	103685				workingset_refault_anon	540
pgsteal	103857				workingset_refault_anon	970
pgsteal	109210				workingset_refault_anon	2806
pgsteal	103627				workingset_refault_anon	319
pgsteal	104029				workingset_refault_anon	42
pgsteal	918361				workingset_refault_anon	90387
pgsteal	103489				workingset_refault_anon	626
pgsteal	103188				workingset_refault_anon	801
pgsteal	102875				workingset_refault_anon	11
pgsteal	102994				workingset_refault_anon	79
pgsteal	102910				workingset_refault_anon	43
pgsteal	102922				workingset_refault_anon	687
pgsteal	103941				workingset_refault_anon	1219
pgsteal	903622				workingset_refault_anon	113751
pgsteal	664357				workingset_refault_anon	27959
pgsteal	104947				workingset_refault_anon	11
pgsteal	701084				workingset_refault_anon	30665
pgsteal	650719				workingset_refault_anon	20810
pgsteal	641924				workingset_refault_anon	17137
pgsteal	933870				workingset_refault_anon	98393
pgsteal	633231				workingset_refault_anon	15924
pgsteal	102936				workingset_refault_anon	34
pgsteal	104020				workingset_refault_anon	781
pgsteal	104274				workingset_refault_anon	1841
pgsteal	621672				workingset_refault_anon	5891
pgsteal	103307				workingset_refault_anon	474
pgsteal	103386				workingset_refault_anon	27
pgsteal	103266				workingset_refault_anon	243
pgsteal	102896				workingset_refault_anon	15
pgsteal	103905				workingset_refault_anon	988
pgsteal	103104				workingset_refault_anon	304
pgsteal	104277				workingset_refault_anon	285
pgsteal	696374				workingset_refault_anon	24971
pgsteal	103009				workingset_refault_anon	775
pgsteal	103849				workingset_refault_anon	747
pgsteal	102867				workingset_refault_anon	9
pgsteal	700211				workingset_refault_anon	35289
pgsteal	102923				workingset_refault_anon	88
pgsteal	104139				workingset_refault_anon	789
pgsteal	105152				workingset_refault_anon	1257
pgsteal	102945				workingset_refault_anon	76
pgsteal	103227				workingset_refault_anon	343
pgsteal	102880				workingset_refault_anon	95
pgsteal	102967				workingset_refault_anon	101
pgsteal	989176				workingset_refault_anon	89597
pgsteal	694181				workingset_refault_anon	22499
pgsteal	784354				workingset_refault_anon	68311
pgsteal	102882				workingset_refault_anon	24
pgsteal	103108				workingset_refault_anon	24

-------------------------------------------------------------------

The original data memcg iter:
pgsteal:
SUM: 39036863 AVERAGE: 304975.4922 STDEV: 284226.526
refault:
SUM: 2027567 AVERAGE: 15840.36719 STDEV: 21332.00262

pgsteal	103167				workingset_refault_anon	203
pgsteal	714044				workingset_refault_anon	42633
pgsteal	103209				workingset_refault_anon	581
pgsteal	103605				workingset_refault_anon	240
pgsteal	740909				workingset_refault_anon	53177
pgsteal	103089				workingset_refault_anon	141
pgsteal	726760				workingset_refault_anon	32624
pgsteal	104039				workingset_refault_anon	397
pgsteal	754667				workingset_refault_anon	56144
pgsteal	713916				workingset_refault_anon	41813
pgsteal	104104				workingset_refault_anon	307
pgsteal	109567				workingset_refault_anon	244
pgsteal	714194				workingset_refault_anon	47076
pgsteal	711693				workingset_refault_anon	35616
pgsteal	105026				workingset_refault_anon	2221
pgsteal	103442				workingset_refault_anon	269
pgsteal	112773				workingset_refault_anon	5086
pgsteal	715969				workingset_refault_anon	32457
pgsteal	127828				workingset_refault_anon	9579
pgsteal	102885				workingset_refault_anon	109
pgsteal	112156				workingset_refault_anon	2974
pgsteal	104242				workingset_refault_anon	948
pgsteal	701184				workingset_refault_anon	47940
pgsteal	104080				workingset_refault_anon	836
pgsteal	106606				workingset_refault_anon	2420
pgsteal	103666				workingset_refault_anon	129
pgsteal	103330				workingset_refault_anon	532
pgsteal	103639				workingset_refault_anon	275
pgsteal	108494				workingset_refault_anon	3814
pgsteal	103626				workingset_refault_anon	412
pgsteal	103697				workingset_refault_anon	577
pgsteal	103736				workingset_refault_anon	582
pgsteal	103360				workingset_refault_anon	281
pgsteal	116733				workingset_refault_anon	6674
pgsteal	102978				workingset_refault_anon	5
pgsteal	108945				workingset_refault_anon	3141
pgsteal	706630				workingset_refault_anon	33241
pgsteal	103426				workingset_refault_anon	134
pgsteal	715070				workingset_refault_anon	33575
pgsteal	102871				workingset_refault_anon	12
pgsteal	103617				workingset_refault_anon	776
pgsteal	767084				workingset_refault_anon	64710
pgsteal	104197				workingset_refault_anon	176
pgsteal	104488				workingset_refault_anon	1469
pgsteal	103253				workingset_refault_anon	228
pgsteal	702800				workingset_refault_anon	26424
pgsteal	107469				workingset_refault_anon	2838
pgsteal	104441				workingset_refault_anon	1562
pgsteal	123013				workingset_refault_anon	13117
pgsteal	737817				workingset_refault_anon	53330
pgsteal	103939				workingset_refault_anon	759
pgsteal	103568				workingset_refault_anon	783
pgsteal	122707				workingset_refault_anon	11944
pgsteal	103690				workingset_refault_anon	885
pgsteal	103456				workingset_refault_anon	145
pgsteal	104068				workingset_refault_anon	632
pgsteal	319368				workingset_refault_anon	12579
pgsteal	103912				workingset_refault_anon	304
pgsteal	119416				workingset_refault_anon	3350
pgsteal	717107				workingset_refault_anon	34764
pgsteal	107163				workingset_refault_anon	535
pgsteal	103299				workingset_refault_anon	142
pgsteal	103825				workingset_refault_anon	176
pgsteal	408564				workingset_refault_anon	14606
pgsteal	115785				workingset_refault_anon	4622
pgsteal	119234				workingset_refault_anon	9225
pgsteal	729060				workingset_refault_anon	54309
pgsteal	107149				workingset_refault_anon	536
pgsteal	708839				workingset_refault_anon	43133
pgsteal	695961				workingset_refault_anon	40182
pgsteal	723303				workingset_refault_anon	32298
pgsteal	103581				workingset_refault_anon	1305
pgsteal	699646				workingset_refault_anon	49924
pgsteal	717867				workingset_refault_anon	39229
pgsteal	104148				workingset_refault_anon	1318
pgsteal	104127				workingset_refault_anon	568
pgsteal	103168				workingset_refault_anon	322
pgsteal	103477				workingset_refault_anon	538
pgsteal	103022				workingset_refault_anon	60
pgsteal	103305				workingset_refault_anon	323
pgsteal	103812				workingset_refault_anon	1324
pgsteal	103139				workingset_refault_anon	126
pgsteal	723251				workingset_refault_anon	34206
pgsteal	103068				workingset_refault_anon	861
pgsteal	742515				workingset_refault_anon	54439
pgsteal	762161				workingset_refault_anon	52654
pgsteal	103934				workingset_refault_anon	889
pgsteal	104065				workingset_refault_anon	315
pgsteal	383893				workingset_refault_anon	25036
pgsteal	107929				workingset_refault_anon	2367
pgsteal	726127				workingset_refault_anon	45809
pgsteal	675291				workingset_refault_anon	66534
pgsteal	105585				workingset_refault_anon	2323
pgsteal	105098				workingset_refault_anon	1625
pgsteal	104264				workingset_refault_anon	718
pgsteal	741873				workingset_refault_anon	47045
pgsteal	103466				workingset_refault_anon	70
pgsteal	723870				workingset_refault_anon	58780
pgsteal	104740				workingset_refault_anon	521
pgsteal	740739				workingset_refault_anon	45099
pgsteal	752994				workingset_refault_anon	53713
pgsteal	110164				workingset_refault_anon	2572
pgsteal	711304				workingset_refault_anon	41135
pgsteal	746870				workingset_refault_anon	60298
pgsteal	729166				workingset_refault_anon	42594
pgsteal	110138				workingset_refault_anon	1511
pgsteal	103836				workingset_refault_anon	675
pgsteal	116821				workingset_refault_anon	3952
pgsteal	104967				workingset_refault_anon	2035
pgsteal	711362				workingset_refault_anon	31458
pgsteal	103835				workingset_refault_anon	507
pgsteal	113846				workingset_refault_anon	2997
pgsteal	104406				workingset_refault_anon	1724
pgsteal	103551				workingset_refault_anon	1293
pgsteal	705340				workingset_refault_anon	44234
pgsteal	728076				workingset_refault_anon	29849
pgsteal	103829				workingset_refault_anon	254
pgsteal	103700				workingset_refault_anon	712
pgsteal	103382				workingset_refault_anon	506
pgsteal	728881				workingset_refault_anon	60152
pgsteal	614645				workingset_refault_anon	43956
pgsteal	107672				workingset_refault_anon	2768
pgsteal	123550				workingset_refault_anon	11937
pgsteal	103747				workingset_refault_anon	899
pgsteal	747657				workingset_refault_anon	50264
pgsteal	110949				workingset_refault_anon	1422
pgsteal	103596				workingset_refault_anon	278
pgsteal	742471				workingset_refault_anon	69586

-- 
Best regards,
Ridong


