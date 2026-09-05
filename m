Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1AE6C624D6
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 04:03:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64A2C6B0088; Sat,  5 Sep 2026 00:03:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 621836B008A; Sat,  5 Sep 2026 00:03:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55E736B008C; Sat,  5 Sep 2026 00:03:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 358B86B0088
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 00:03:17 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BFC19A41D1
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 04:03:16 +0000 (UTC)
X-FDA: 85178363592.22.106DF84
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7D70B40005
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 04:03:12 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	spf=pass (imf01.hostedemail.com: domain of shikemeng@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=shikemeng@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788580995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ypuMNANzZkUknbrtbZYNBPUM7ZPhuLWbSdjgdFvvfX0=;
	b=FmB0dnOPhdKZlC8EHTTdy2p2E9CNQg9Opkk1f9dHtXzt6zLreMSE/hSiOHmvFs2vuU0e6a
	tOmvOtWAIlXVn/F5YkpmxaKxljhZHHQ2sF3tRZAX36L2eBIgjVtxIVcDbh+yl2S8aSp7n+
	qaElr1R2hHkH6DtMvT2YdOYzAdCfILs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of shikemeng@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=shikemeng@huaweicloud.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788580995;
	b=zL6BVnFyXeUs5t2GvyjFjWtc80cdq/BAW9EJZD1JwXFGYSWceZx6D5gPhJAMMgNnCmnY9D
	f53M45uPjg3Rqf6i771ppepx+PC+OLyuPDi8q9T/xxelE6Y4e+c+ov8GNK7N6R7o6QnPiO
	QK/VuQib6GDRIzKesoqHbeiIAMN2WVk=
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hcKR60tSwzKHMKN
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 12:02:10 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 7620A40561
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 12:03:06 +0800 (CST)
Received: from [10.166.163.161] (unknown [10.166.163.161])
	by APP3 (Coremail) with UTF8SMTPA id _Ch0CgB3NbN5lJtqvW00Aw--.4273S2;
	Sat, 05 Sep 2026 12:03:06 +0800 (CST)
Message-ID: <ac358441-95be-4254-ae2e-f9b2f6eb544e@huaweicloud.com>
Date: Sat, 5 Sep 2026 12:03:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] mm, swap: Fix potential NULL dereference when
 trying a sleep table allocation
To: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <ryncsn@gmail.com>
Cc: chrisl@kernel.org, kasong@tencent.com, nphamcs@gmail.com,
 baoquan.he@linux.dev, youngjun.park@lge.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260820115505.20027-1-shikemeng@huaweicloud.com>
 <20260820115505.20027-2-shikemeng@huaweicloud.com>
 <ao_ybL9yRO_pHphW@KASONG-MC4>
 <20260828180338.0e62379137b832bd66d48b7d@linux-foundation.org>
From: Kemeng Shi <shikemeng@huaweicloud.com>
In-Reply-To: <20260828180338.0e62379137b832bd66d48b7d@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgB3NbN5lJtqvW00Aw--.4273S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Kr1rGr45Gr4DXFy3Aw1DWrg_yoW8Zw48pF
	sYga98KF45tr9rXr4vya4vva4ruw4F934DW3WxKw1293Z8Xr1xWrWkCrZYvFyDC3Z7Xryq
	gr1UKw17uws0vrUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUymb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E
	14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07UG-eOUUUUU=
X-CM-SenderInfo: 5vklyvpphqwq5kxd4v5lfo033gof0z/
X-Stat-Signature: co37yjqwyui488gikn5f5ys36u4unns8
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7D70B40005
X-Rspam-User: 
X-HE-Tag: 1788580992-236030
X-HE-Meta: U2FsdGVkX192pkPLQtPLQarxiTioEc8je0RdW9RDyS+FixZUfE5LzBXblP/MJ4KNwdcSfvf/ihK0opEtZPYXMXRUXILvBOrAsyxepEncawfQmWIF9TS0fzWdcSt237FmNf1wBMoxZccQjYSq6JPTCOzRgp5uaDYkwQ9k6SLiJF9zoy64Kx7m/e3oz0hcItgjqlzJYRqrWon28LAgD9O2tmp0V2cxwKd1nqoL6Ud68wZoCDAhJiKR7XcjCt0xpBPlxblQOXxD8OrROF/0mj7sIHz5F4h/gedTiO9qlFiOEmdjEsmjY5Jxwd4Dktw/BWBNz1i4CJtwF7spjD4rp7oCa0V1Y+kLPIPwlcb7s7FreO8DmbDPKTDSRrKWvjAep3UAUKeC4bp14aOX2qkU8Q5dNqjE1FzWVMIDuoKzC4RzwwX8+jR8LlnO2aiUCkpzH0a4np6rDGC6oFwaGlbO/SzdaW+OHMt+1Z3mnZ7Yxog+gfFSgLJ3vNBOC5t46AkHeZdshMYoILNQb4IQ2peWONOrZtt79GHvytPtnE6E4eRzri6I8ui8GChXY+eeT9jvxVtNRoQPDWWmsOPA9POBwBMxaQuufugoZEFYJquiYWXUt1I60DmLtSYQWVWKuuh0n8JFRhuT56ggmxRTykvPR87NmKv8Mzjhiz1wOQpUC2I9QJujbIQ/gzxpXyaovCiFWQhyEnylZ8TFZYzHw/scJkqzdiVdErYsgVHejBsDOxUByazAp6hJl1j7Qb9j7QZWWZEj35qj9kNJenNoQq70+Li8e0FitUqu2AGCCguzBxHLBU5FrFw2SuNryz/ArNZSl5petOmtzBRJm/SjtgJe1Zti/dysYCsGyFyHTdy0y9S0Jg2CjdCUmAhoNBE4jNgVGIg1G5ElULxF2qp+OARR0HK1UZNHh8HfLjT8zMY00+fPH8C2/xYj1X3DjfESNRttgW6cdepq8t+m6QKRpQyt32w
 YOtnn8R3
 ZsUuA5Z0Ga0qME/eerS1GrW4e52vCnhAs3gWt4nBOeUytTqJNvPrb+9T0OPSrkNCJU7aKwg49lfge5Zz/V+VgRN3AJtERJKL/LX7Kg4OIZMLHvWL24UbKbs+/q6MWAfctM+YOHg5oRGiOpxS8e5wBvqqN1aVkLJjxa/zvA5z0Ha326JwR+wAEp9ax+rpo5O+odSV4jM6iRhefz71aV/NOENg6AwFtf+2ZacGSs84PWwtxNPOzJGGbHJLRekcKi75cL29ZL9Ju56MdTErH4Koi2vdhmQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

在 2026/8/29 9:03:38, Andrew Morton 写道:
> On Thu, 27 Aug 2026 17:10:54 +0800 Kairui Song <ryncsn@gmail.com> wrote:
> 
>>> --- a/mm/swapfile.c
>>> +++ b/mm/swapfile.c
>>> @@ -466,8 +466,6 @@ static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t gfp)
>>>  	if (!table)
>>>  		return -ENOMEM;
>>>  
>>> -	rcu_assign_pointer(ci->table, table);
>>> -
>>>  #ifdef CONFIG_MEMCG
>>>  	if (!mem_cgroup_disabled()) {
>>>  		VM_WARN_ON_ONCE(ci->memcg_table);
>>> @@ -487,6 +485,12 @@ static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t gfp)
>>>  		return -ENOMEM;
>>>  	}
>>>  #endif
>>> +
>>> +	/*
>>> +	 * Make tables visible to cluster_is_usable() after everything is
>>> +	 * ready.
>>> +	 */
>>> +	rcu_assign_pointer(ci->table, table);
>>
>> Hmm, but for the error paths above, they will leak the new allocated table?
> 
> Sashiko thinks so ;)
> 
> It also might have found a pre-existing data-race which seems
> sufficiently on-topic for this patchset?
> 
> 	https://sashiko.dev/#/patchset/20260820115505.20027-1-shikemeng@huaweicloud.com
Thanks for thre review, I will address the leak in the next version.

As for data-race concern, I analyzed it in [1] and concluded that the cluster lock
already serializes all accesses in question:

/* ci->table: protected by cluster lock */
swap_cluster_lock()
cluster_is_usable()
 cluster_table_is_alloced()
swap_cluster_unlock()

/* memcg_table: protected by cluster lock */
mem_cgroup_try_charge_swap
 swap_cluster_get_and_lock()
 __swap_cgroup_set()
 swap_cluster_unlock()

/* zero_bitmap: protected by cluster lock */
swap_writeout
 swap_zeromap_folio_set
  swap_cluster_get_and_lock
  __swap_table_set_zero
  swap_cluster_unlock

Since all three accessors acquire the same cluster lock, no data race
or memory-ordering issue exists on these shared variables.

Please let me know if I miss any case.

[1] https://lore.kernel.org/all/76738b02-1f12-4deb-84f7-542d9830b0b5@huaweicloud.com/

Thanks,
Kemeng


