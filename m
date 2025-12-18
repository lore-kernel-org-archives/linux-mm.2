Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7F77D68BDD
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 06:26:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 117246B0088; Thu, 18 Dec 2025 01:26:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09B026B0089; Thu, 18 Dec 2025 01:26:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDED26B008A; Thu, 18 Dec 2025 01:26:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DD52E6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 01:26:30 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4949213C228
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 06:26:30 +0000 (UTC)
X-FDA: 84231607740.18.EAAD73E
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2947440004
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 06:26:27 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="FuYlSs/7";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766039188; a=rsa-sha256;
	cv=none;
	b=1EHk2Eg0IjHUnpE2Ujq+NjoLPA5TJSuqRHR1EJncZAyIjbNRYsY9XecXPx4+SjbTcHwvO0
	Hi+hs5O7oow0f6yXMSL7B4RQvcP0X4/KtTnOPPxQUEnUdLTAjTLCslfNiHCUGeRVFFsjC0
	Bs2xifUVE2FEN6pVvhWJVS2VBB78lJU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="FuYlSs/7";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766039188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JQrjMLHrieslIFKAFZlyBoYqknDz5bzEWuLKkBRkaL0=;
	b=pRSMsFpfjqKlgozRNZ2Uk8CxGrsRfPPTBpmsc8KbZMQtbOSt1TvB700UjSJFTnwmexVPHp
	d6T3Gv392qphi4oP8/AhXEwHztzYl92ykCMucncMDS0nvC0XOF/HzIRd5su3S1V1SJ84tk
	6JsSNqOLqEsYStfwScozriDZWT9jQsQ=
Message-ID: <0088cfa4-7a60-4a44-afbf-7ee0b6ebb2c4@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766039185;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JQrjMLHrieslIFKAFZlyBoYqknDz5bzEWuLKkBRkaL0=;
	b=FuYlSs/7qmGAWTBWBQxbkrQbCqmEgMoaZbgNCMzzBh2YuxnQ4ybZRmxxhOsEvYhEP/oLbi
	kCd5PStGxyUh0c2Z4AaMItHC8yCAjs4pfvMkkqPWpkdLoA07BFunegRu9McSC8iyvdBI9U
	kiSb3lXDFNSP9K+oqxxW3hL4HtTI+TQ=
Date: Thu, 18 Dec 2025 14:25:26 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 06/28] mm: memcontrol: allocate object cgroup for
 non-kmem case
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
 imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <897be76398cb2027d08d1bcda05260ede54dc134.1765956025.git.zhengqi.arch@bytedance.com>
 <aUMfALjD7Q1A3NU8@cmpxchg.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aUMfALjD7Q1A3NU8@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 2947440004
X-Rspamd-Server: rspam10
X-Stat-Signature: u68zyuz8qi46qqj7eqxwttqwwewxg8yq
X-HE-Tag: 1766039187-743000
X-HE-Meta: U2FsdGVkX1+Ciw7MXbIBZjlyDLrfJvEb3m+NI62wJRk5YTso6a/Q6A1ilASC9e5INi3ZOCYYD3m1UHROTmniO48Ms4me3wKP7BpVolXq1CsgOIgERJYpD4f7AJSNGVIEz+k5CPkDnDVaBSJkxSBp28r4i3+SqPLAM28y4ekPd7O3PUdMHyGk1VE0OFdZ4VZuipzBgKdsHh88Hb3A1WW8r1mQ1VPVmgYhLjdJ6b0Q8M26S2sNb7qLK13EOOvQvMOenLCr1GxP0puin3Iv3+K6bRvoVYYFZCoHmT8Aty02EfIziK2Y/oQxdx7u5NitY2UxQefKlwkEmAwZnLDS3WQ5k6mdQ7xff+Lvk3cOl5k1+R/uDS3cAUopT2pnjsRmaiXmAbOeewES/yplXQXrdh5x4a2Qz2Eelw4slLFZSvErh709DJJrIbTj2DL43+fyzK1kacA9uZGMbKb+7Uo5HPyce9plsKGP/cexIG/rbHHfcR9eM6ZgYC4+N7kXN91c5LtcS8KrcuoBi8zPKMGo8FsVsL4gRIV0bGnC4kbwhm0HkiiUcp7oM873qGDAlWjpoSx7l/rbPX4juvdkWRVyP2ScYnYDg+fSP0LQNBo/BsKQZuTlJNua3Mrxq/2TfspTHA6I3r7Rqzf6+GuSraCE19jMRHtfZso5UcM4CLHulivEtcjW76zyBpzHI36GsxgZDs95aONY1dS/lssR2OblTCmnjQPk8phHBHNORHHBkfEXcX+Gl/Qc3GK+6+FB7M43TWUiHvCYn0dqv1XdMEfN+MospooQvQG4kqudpcokGkD9Iv2dqD1wNm/8/IdPN4zId+8HWpqU1LP5q+riWkKezyzoBsK6D1HHGDbY/N6HwJNMRcnrp0djvewVVEUIPw4UurUfwSYqcxYjUrMjwSg1J7cZ/IqczIoH+X69pSqQJdVbmlRy0mLAiiuOgiJpdXcRWjsRqHW4jHvpqBwLaPRP8HV
 pqF+S7xJ
 68bRKjgEUvKuUKFr3J/ffabwTCXAgyzreFquCh/bQgfW5NmUiOwJvjsueCwDg1ZNh7OBmf0H3wUgEgTAwcrUCaIS1cpaQeGsFi9r9GiCj8Jcmjswn24sfnZwypgUpvX++DwX5nTJX1E4oXQ4vwgv97kksaZrYsytIpRV13VxNCrAaxOmEVvOwF3Z1o2tr8qvnQCCADGl0dSwmcdKHZkwh9cqS0tfZm+g6TtgoyIMCeYHaI61GaJKjUPzaAxX8w43Y1l01/deJ+cBtz9PUjGUiLbijF33DLWXgOcNj2w55E78OJBexMepk2OF5ZkmPhee6IlER
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/18/25 5:22 AM, Johannes Weiner wrote:
> On Wed, Dec 17, 2025 at 03:27:30PM +0800, Qi Zheng wrote:
>> From: Muchun Song <songmuchun@bytedance.com>
>>
>> Pagecache pages are charged at allocation time and hold a reference
>> to the original memory cgroup until reclaimed. Depending on memory
>> pressure, page sharing patterns between different cgroups and cgroup
>> creation/destruction rates, many dying memory cgroups can be pinned
>> by pagecache pages, reducing page reclaim efficiency and wasting
>> memory. Converting LRU folios and most other raw memory cgroup pins
>> to the object cgroup direction can fix this long-living problem.
> 
> Not a big deal, but since the coverletter will be preserved in git, I
> don't think you need to repeat the full thesis.

Got it.

> 
>> As a result, the objcg infrastructure is no longer solely applicable
>> to the kmem case. In this patch, we extend the scope of the objcg
>> infrastructure beyond the kmem case, enabling LRU folios to reuse
>> it for folio charging purposes.
> 
> "To allow LRU page reparenting, the objcg infrastructure [...]"

OK, will do.

> 
>> It should be noted that LRU folios are not accounted for at the root
>> level, yet the folio->memcg_data points to the root_mem_cgroup. Hence,
>> the folio->memcg_data of LRU folios always points to a valid pointer.
>> However, the root_mem_cgroup does not possess an object cgroup.
>> Therefore, we also allocate an object cgroup for the root_mem_cgroup.
>>
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> 
> Looks good to me.
> 
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Thanks!



