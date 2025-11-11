Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E89FFCCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 01:00:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57DB88E000D; Mon, 10 Nov 2025 20:00:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 554FE8E0003; Mon, 10 Nov 2025 20:00:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4926D8E000D; Mon, 10 Nov 2025 20:00:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 36DCE8E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 20:00:38 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C2A6B140340
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:00:37 +0000 (UTC)
X-FDA: 84096520914.19.33A0B84
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf01.hostedemail.com (Postfix) with ESMTP id 121F74000D
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:00:31 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	spf=pass (imf01.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762822836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dz/LbOz2fV3pMpNZ86MhsSfDMgpaR79+9z4nvwiNtKI=;
	b=tKRXz4fS5mmdcagidsjnT/foiTvH4BmPx5aDM5EyHhJhPqzIvNpGlSB1kxiaAmGEQncbVr
	6Ca4Yp9rxUzxU/k/ZdrjrP7i7E3cDa0on3GgVoDYZtZvt0ERrBuFWSI5WUnTRp8b+6dtdn
	H3Ol47xoEBhfm4pOj4t4gvEJXPGGA08=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762822836; a=rsa-sha256;
	cv=none;
	b=K91QLKZKh3O6E8OFiliEPhDpdI6lj1VDeJ0afoTmhdtEDEAGV0JLA6OLplQPoewkgqJD+4
	zG6si/EhF+/cgPsvRS3B1AU4JVqfS43W0TjmJXmMSpEUIpo5iZcDmZ5Iq1n//fELGAodGC
	USWrOisuyhY7eAppqE8doil9ig4Ucvg=
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4d57Vh0gMzzKHMQB
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:00:12 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 74D011A0359
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:00:27 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP4 (Coremail) with SMTP id gCh0CgCnz1yqihJpULVJAQ--.64891S2;
	Tue, 11 Nov 2025 09:00:27 +0800 (CST)
Message-ID: <7d46ef17-684b-4603-be7a-a9428149da05@huaweicloud.com>
Date: Tue, 11 Nov 2025 09:00:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v3] mm/memcontrol: Add memory.stat_refresh for
 on-demand stats flushing
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Leon Huang Fu <leon.huangfu@shopee.com>
Cc: linux-mm@kvack.org, tj@kernel.org, hannes@cmpxchg.org, mhocko@kernel.org,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 akpm@linux-foundation.org, joel.granados@kernel.org, jack@suse.cz,
 laoar.shao@gmail.com, mclapinski@google.com, kyle.meyer@hpe.com,
 corbet@lwn.net, lance.yang@linux.dev, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20251110101948.19277-1-leon.huangfu@shopee.com>
 <ewcsz3553cd6ooslgzwbubnbaxwmpd23d2k7pw5s4ckfvbb7sp@dffffjvohz5b>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <ewcsz3553cd6ooslgzwbubnbaxwmpd23d2k7pw5s4ckfvbb7sp@dffffjvohz5b>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnz1yqihJpULVJAQ--.64891S2
X-Coremail-Antispam: 1UD129KBjvJXoWxCF13Wr47Gw4kWr1rtr15twb_yoW5Kr15pF
	Z8tasYyw4DKryxCwn7Ww1xXrWFkw4fW3yUtF9xC34fC3ZxJF1S9rW3tFWrKr9I9FWfX34j
	vF4Yva4ruay5AaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
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
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU0
	s2-5UUUUU==
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspamd-Queue-Id: 121F74000D
X-Stat-Signature: f3abaxzszzi57mrxfy96jdn4kamxd7ow
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762822831-472235
X-HE-Meta: U2FsdGVkX19MkcpL0XWTXG6bKt8LQIHVw5RiGvYc8FDaFzG2kYjo1gdr8WJ8BLIuTU8gwQztJtjee7DBOO191jEJZZUx1kPLlJC40slyWZx6KNP1bY1jOCj5tu4FmoD6Sti+cZcTamz2x2OuTK0KDDzJDF92u8/fgbZOfCx6i216LCxWKzRTSv6Bp5J8ZukIQEjJOlAR/g3i8ws5ck5eUCdr+Jmjbs1oFkfFtIQaPc2yzj+mgkG8EqMxbE8Vm2LwkJbqo4zI4Q+4YdWLvu+zp0JOt3QvUD8XCfYzWiafUj1HumNhInKwkFz4gtvbqlFTNzyvi31mOoVshskeouG/sDrOXZp80RW/NYJuHGig2bzm1OMklheDHGBz6CkBqG7tkZVTeizfqHLuti5G4g3/SWXQ40dr/N1UbKnolJAd7aNFRzhF/jMm47Al586XJbFWSBBKhIJSuVnrO6I83uszUOb8tXW1b5jkSwXjyHktc91NTvH8mlyHCjNSpoLnCvgHIedUwjYdQE1qUvET2sR9eamQUs+SoOKdRexCz5aoKfyqQZDOUzQrKTXGEJ5slGMMkJvTXh8wSv/Lji1y+TedXF6WE3/ivlqknI62j+fgXOr+rMAC9RJqKWn9MZSB5YjcQkUbXNkiF8lZofrYfcA4PQTYwEnjQzedGYPZhvQW/R232IjQ9ngT5LZ/Mgrp1iEOjygiSQthOlxeKYZxM3eo74CWBRKlZlcs8AjRXoUhlZR+fk97WFSusKS5Dbk/sW2U4c2SWhdgFh/8JLI3J3uY6K/2txN5OSHaXwkngvM+RK7NlNyrckuVE8MWEH7jkpa1o+XF4Vcs5i08/UVbX0yJpiZY8ImTdg6cy3yZkswHi5Ibfv7SnMUM96s3dfsZA7PaGgAhLkqQ8DkXQnyBJPkk05D9qM8OiLF/wsCdQg3dCx0y8x5n/XFHTa0IDG21mTxA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/11/10 21:50, Michal Koutný wrote:
> Hello Leon.
> 
> On Mon, Nov 10, 2025 at 06:19:48PM +0800, Leon Huang Fu <leon.huangfu@shopee.com> wrote:
>> Memory cgroup statistics are updated asynchronously with periodic
>> flushing to reduce overhead. The current implementation uses a flush
>> threshold calculated as MEMCG_CHARGE_BATCH * num_online_cpus() for
>> determining when to aggregate per-CPU memory cgroup statistics. On
>> systems with high core counts, this threshold can become very large
>> (e.g., 64 * 256 = 16,384 on a 256-core system), leading to stale
>> statistics when userspace reads memory.stat files.
>>

We have encountered this problem multiple times when running LTP tests. It can easily occur when
using a 64K page size.

error:
 	memcg_stat_rss 10 TFAIL: rss is 0, 266240 expected

>> This is particularly problematic for monitoring and management tools
>> that rely on reasonably fresh statistics, as they may observe data
>> that is thousands of updates out of date.
>>
>> Introduce a new write-only file, memory.stat_refresh, that allows
>> userspace to explicitly trigger an immediate flush of memory statistics.
> 
> I think it's worth thinking twice when introducing a new file like
> this...
> 
>> Writing any value to this file forces a synchronous flush via
>> __mem_cgroup_flush_stats(memcg, true) for the cgroup and all its
>> descendants, ensuring that subsequent reads of memory.stat and
>> memory.numa_stat reflect current data.
>>
>> This approach follows the pattern established by /proc/sys/vm/stat_refresh
>> and memory.peak, where the written value is ignored, keeping the
>> interface simple and consistent with existing kernel APIs.
>>
>> Usage example:
>>   echo 1 > /sys/fs/cgroup/mygroup/memory.stat_refresh
>>   cat /sys/fs/cgroup/mygroup/memory.stat
>>
>> The feature is available in both cgroup v1 and v2 for consistency.
> 
> First, I find the motivation by the testcase (not real world) weak when
> considering such an API change (e.g. real world would be confined to
> fewer CPUs or there'd be other "traffic" causing flushes making this a
> non-issue, we don't know here).
> 
> Second, this is open to everyone (non-root) who mkdir's their cgroups.
> Then why not make it the default memory.stat behavior? (Tongue-in-cheek,
> but [*].)
> 
> With this change, we admit the implementation (async flushing) and leak
> it to the users which is hard to take back. Why should we continue doing
> any implicit in-kernel flushing afterwards?
> 
> Next, v1 and v2 haven't been consistent since introduction of v2 (unlike
> some other controllers that share code or even cftypes between v1 and
> v2). So I'd avoid introducing a new file to V1 API.
> 

We encountered this problem in v1, I think this is a common problem should be fixed.

> When looking for analogies, I admittedly like memory.reclaim's
> O_NONBLOCK better (than /proc/sys/vm/stat_refresh). That would be an
> argument for flushing by default mentioned abovee [*]).
> 
> Also, this undercuts the hooking of rstat flushing into BPF. I think the
> attempts were given up too early (I read about the verifier vs
> seq_file). Have you tried bypassing bailout from
> __mem_cgroup_flush_stats via trace_memcg_flush_stats?
> 
> 
> All in all, I'd like to have more backing data on insufficiency of (all
> the) rstat optimizations before opening explicit flushes like this
> (especially when it's meant to be exposed by BPF already).
> 
> Thanks,
> Michal
> 
> 

-- 
Best regards,
Ridong


