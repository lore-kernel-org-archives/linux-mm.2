Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4141D106F2EA
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 08:21:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A82946B0088; Thu, 26 Mar 2026 04:21:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A333B6B0096; Thu, 26 Mar 2026 04:21:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 970416B0098; Thu, 26 Mar 2026 04:21:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 844E06B0088
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 04:21:30 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0C5B28CDC0
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:21:30 +0000 (UTC)
X-FDA: 84587519940.08.4B14F9F
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf03.hostedemail.com (Postfix) with ESMTP id 64E8E20002
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:21:28 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JLzZh42X;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774513288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wjPS8nNoUBDz2hTHGCQoOfGnhbBIjkw5dn0DefZiGfQ=;
	b=HWbt0gvoYyoO5TdZhYdH0rIQySKPkec2aGnvGO0GZtSBlXsepG5NuagE0roR5uIZ/WR4Ym
	tq7V7sv4UYv4o4Qj3agfRl6/H1Erc+Nhw6Sew3Zhab9XgsfIYirRjxU4vsb37/1e1cH89F
	1TKoyxmGLwFgfblQLV27C7qD4UovYz0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774513288; a=rsa-sha256;
	cv=none;
	b=cuymxeFwYHdcAShFiTa7f/gpy9Hnz5RUAlDP3yKUeJ4tBXrOmYAvdRngUk7UYWXMVp3GUB
	AQpoGql5ZqJqCn2v7mpQ3O0GCH+x+AiNIOP4OkDpd3hVbd3kh4Bcp16EKNC9qLHne2Qdkx
	NcTUKxzzlYYOKcPBC/5nLSC3dgTkQWw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JLzZh42X;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
Message-ID: <77ad6aa3-923a-47cc-9625-ed627c2ac9ed@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774513286;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wjPS8nNoUBDz2hTHGCQoOfGnhbBIjkw5dn0DefZiGfQ=;
	b=JLzZh42XhNyWURFwyTn4Yt/1OFjIeomUubGjMLnf8Y1EfyCvdr+a2dFCMPX/HlLv6XPKz8
	GHbuZ4/s4xt7GLJZWjQ9z3wDc9s7+tTmS/7lSXUqH+0NQM1xRr0EJ4FCSAZBy2KFMXE6ph
	oQRBKdIzTX4cJpqKYsSLjs5owqlD+uE=
Date: Thu, 26 Mar 2026 16:20:57 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/4] mm: memcontrol: correct the type of stats_updates
 to unsigned long
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@kernel.org, ziy@nvidia.com, harry.yoo@oracle.com,
 yosry.ahmed@linux.dev, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1774447069.git.zhengqi.arch@bytedance.com>
 <158fa0b1296168047342f02050e9d2bda6888d27.1774447069.git.zhengqi.arch@bytedance.com>
 <fcd29ba1-e02a-4c91-80d1-2d1280e2ff99@lucifer.local>
 <c46cc185-5c23-4145-bfad-5c455b84857f@linux.dev>
 <3eb8b252-b6fa-4708-8c84-bf90142fe682@lucifer.local>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <3eb8b252-b6fa-4708-8c84-bf90142fe682@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 64E8E20002
X-Stat-Signature: abduototftwwfdhr996t9f4uzp5bz8h5
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774513288-969788
X-HE-Meta: U2FsdGVkX18Q9/khKauYYCVKDtNZ9J9i3wCd/6E/bvw94zhJ+oxQhlbQqOBRXsav+CHnFXb5VUu6Tz1kfZa2BhDQsZd8OWgI1SB8hesB9e3kBTiauTFQdu5zadNs2wl+pSCTcZVy3Yg57URzO3FY7dKc6qX+Q3yb/0OpxruckgCy/afgV/AFWykq2As622ZtLMLwm2kbLTi5MSrdE0lKyh2/0B9cPdnL+UVQIppzRj/YuTFpZrirqA+mhOYtpXRnhCTSfY82MCeUBJqMcjy3AM3DqgJKFgX3RLgxr9LKYYU2czcOAzhL5JCuNLnCJMsKu27xe5BuqIMbh2DIZwwSAnsKHhdZ72QDWkVv1nY8nISyBoZP8f7Pe/Wun40aPDlJp/cD1Eh30+6657BMsQY5ypBmOb5G1SjZCoEXHRzOAVyVJehsV6h0KcGCRpEYxj3WzNtMm9dxRWubVKv1oiBRvWmt1yeD6KHWB9GBSJhfCAdI+321TkozQkTuSpmz3T+TDHmRQQ/W+C0DTIYPW5JtE7/RmtNZUcx6Ri/fZYkhVsp5BO5++rIiWWF8andTlDC/MNL7Z9nm8ixADHhz5SNyaOrQOo230Y7Kx+K7PvzzThU7zD9cP4Iv8XAMy4+Qo79zwRmo8dKiLKx3pZcvt+LUOlo3tMbAYK0p+fvXhAiziaqfx/CpqHdgddrfuS5X24FVszxEgbppB1CLc3kgVyiqr1CSuLytzTLFX9hkXENvEsQQp6VEhLdkFAGkVR6jZYievPSelPukhpUgVCgHvDU/BxREU5+NArePgSwsL3dSRNKKW6h5PHD0oiAPO0EylGALXxQLN8zAiQUQdphFfv7mX8sgLNob9Slpb5IfSoGoz+7xFaV3BZs5X16jFt/wH2tL/n/CeoS/pnlXDXBMvMWchBCd1gzWOHAw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/26/26 4:05 PM, Lorenzo Stoakes (Oracle) wrote:
> On Thu, Mar 26, 2026 at 10:32:43AM +0800, Qi Zheng wrote:
>>
>>
>> On 3/25/26 11:28 PM, Lorenzo Stoakes (Oracle) wrote:
>>> On Wed, Mar 25, 2026 at 10:13:22PM +0800, Qi Zheng wrote:
>>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>>
>>>> The memcg_rstat_updated() tracks updates for vmstats_percpu->state
>>>> and lruvec_stats_percpu->state. Since these state values are of type long,
>>>> change the val parameter passed to memcg_rstat_updated() to long as well.
>>>>
>>>> Correspondingly, change the type of stats_updates in struct
>>>> memcg_vmstats_percpu and struct memcg_vmstats from unsigned int and
>>>> atomic_t to unsigned long and atomic_long_t respectively to prevent
>>>> potential overflow when handling large state updates during the
>>>> reparenting of LRU folios.
>>>
>>> Do we need a Fixes, possibly cc: stable for that? Apologies if already
>>> asked + answered.
>>
>> Before LRU folio reparenting was introduced, we wouldn’t pass in such a
>> large value, so this wasn’t a problem. Since LRU folio reparenting is
>> still in mm-unstable, so I didn't add a Fixes tag in [4/4].
> 
> Ah, well these patches should be _before_ the LRU folio reparenting then?
> 
> Andrew - can we ensure correct ordering here?

There are some dependencies for this.

To be precise, it should be applied after:

[PATCH v6 29/33] mm: memcontrol: refactor mod_memcg_state() and 
mod_memcg_lruvec_state()

and before:

[PATCH v6 32/33] mm: memcontrol: eliminate the problem of dying memory 
cgroup for LRU folios

and there might be conflicts.

Would it be okay to merge them together into v7.1-rcX? Otherwise,
perhaps updating to v7 would be more convenient for Andrew.

Hi Andrew, what do you think?

Thanks,
Qi

> 
>>
>>>
>>>>
>>>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>>>
>>> Anyway logic seems fine to me, so:
>>>
>>> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>>
>> Thanks!
>>
>>
> 
> Thanks, Lorenzo


