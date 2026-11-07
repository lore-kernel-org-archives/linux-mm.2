Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B7C0606A326
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 13:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=lJxfz6F4
Received: by kanga.kvack.org (Postfix)
	id B6C966B05B0; Sat,  7 Nov 2026 08:57:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B44666B05C2; Sat,  7 Nov 2026 08:57:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8BA36B05C3; Sat,  7 Nov 2026 08:57:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8913D6B05B0
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 08:57:39 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1F1C040355
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 13:57:39 +0000 (UTC)
X-FDA: 85408475838.16.5D05F80
Received: from mta1.migadu.com (out-145.mta1.migadu.com [95.215.58.145])
	by imf26.hostedemail.com (Postfix) with ESMTP id A8B7A140007
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 13:57:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lJxfz6F4;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.145 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794059857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bof9tUcTOZBXMkDJCDfY6C3YrCB7UvJznTngHIBFOlg=;
	b=H+YidmgUhBwNXCQzOhiuXfWuF2aWp6CmOlkFVRFYafakzkNVESTfhDcK+TJyuSfV1F34s6
	k60eg/JeZEaV6xMZ+imANcy7yi8bloHeJr8ElMi6t5TDItZ3ERqDtXAO8nHuIXpBE7Hzrf
	lljnrNvHR7lkvtGQGKjxdEIkP2fE/Ec=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794059857;
	b=pBzI/SR3DurImUZ36dRxCdI+TAOo3A618htWbvRISms0P/HKJT1zDF3MYEASYi3Eno3UY4
	lkNE2MaAosIv1aj+nfYcLYIYfKccsZT/zGn9fLFpqqnNtteMnZSDV0vMPEJs96GQR4hSRT
	xg/dAvQAb11MXKlyPPr0ZZI+W5dUWbQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lJxfz6F4;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.145 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=a4WQjTS9cLmNAnAJkm3u/yMKK8cVrEp4RpmNfDVq90s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794059853; v=1; x=1794664653;
 b=lJxfz6F4qBNSR5tFla7gLu8C60Ut8j6sNhgl36PjYrBesekcQ460PWTFUBZKJBTXlOb167Cz
 EYAxD+DU/YXTiDp0v0C46KCq/hhwcfZgC5Q+E2SOBt3QwWyB+hXy5CTC+iuQKMFnn9NMW+C4It5
 ILQjSrkCXaBdr5OGpjI70qJg=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id bb1f088a7420c55f;
	Sat, 07 Nov 2026 13:57:32 +0000
X-Mizu-Trace-ID: bb1f088a7420c55f
X-Migadu-Flow: FLOW_OUT
Message-ID: <fd7ed305-6192-46e8-a5bb-cc1ed8f12f74@linux.dev>
Date: Sat, 7 Nov 2026 21:57:02 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/list_lru: Account node removals in isolation helpers
To: Johannes Weiner <hannes@cmpxchg.org>, Dave Chinner <dgc@kernel.org>
Cc: gregkh@linuxfoundation.org, arve@android.com, tkjos@android.com,
 brauner@kernel.org, cmllamas@google.com, aliceryhl@google.com,
 nat@pixelcluster.dev, arunpravin.paneerselvam@amd.com,
 maarten.lankhorst@linux.intel.com, mripard@kernel.org, tzimmermann@suse.de,
 airlied@gmail.com, simona@ffwll.ch, viro@zeniv.linux.org.uk,
 agruenba@redhat.com, trondmy@kernel.org, anna@kernel.org, cel@kernel.org,
 jlayton@kernel.org, cem@kernel.org, akpm@linux-foundation.org,
 david@fromorbit.com, david@kernel.org, hughd@google.com, yosry@kernel.org,
 nphamcs@gmail.com, matthew.auld@intel.com, matthew.brost@intel.com,
 thomas.hellstrom@linux.intel.com, jack@suse.cz, neil@brown.name,
 okorniev@redhat.com, Dai.Ngo@oracle.com, tom@talpey.com, qi.zheng@linux.dev,
 roman.gushchin@linux.dev, muchun.song@linux.dev, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, liam@infradead.org, nico.pache@linux.dev,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, usama.arif@linux.dev, kas@kernel.org,
 mhocko@kernel.org, shakeel.butt@linux.dev, ljs@kernel.org,
 kasong@tencent.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, baoquan.he@linux.dev, chengming.zhou@linux.dev,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-fsdevel@vger.kernel.org, gfs2@lists.linux.dev,
 linux-nfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org,
 Kaitao Cheng <chengkaitao@kylinos.cn>
References: <20261103045053.59548-1-kaitao.cheng@linux.dev>
 <aupITfr9pBKPrU20@dread> <au3eyCrHiuhbJx3u@cmpxchg.org>
From: Kaitao Cheng <kaitao.cheng@linux.dev>
In-Reply-To: <au3eyCrHiuhbJx3u@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: g73zw6rho9kbk85yt6awppionqrap7n6
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A8B7A140007
X-HE-Tag: 1794059856-76127
X-HE-Meta: U2FsdGVkX1+BjD5zpZwSn2DQgD5A5XKTYIV+t9lLHoa9Gf456ccr68zSZZUke9KSLH3zob7vMDVKcjIvnwgED4n9Zc7Ib0PxvBBmtHvQsJRHqtFOiML63jRXqGJE3Hr62pktYQJN1h8rgomMX2ZlqFGb8aVGdAE0fwOzEa4nSKuVOSTerEMZmDgtQA4ghNCTzIYi0Ua2P4H1xdaQ1fXAEqNUAf/9FdDyUZJU9g4RosnGEWXXZ8751U13nQY2hZsffP34E6toG/7xbUEAq+M777FfZkUM3b9EQ8JA0IqeVoWDdTXBguq0vsjP0VbtQMOq6SfRDghALB8D717LDiXeRKgOx3giR+PftqPVq8f8As859bpO44xLDSahaOpAKGCvjQ4OOwJcseij7ybVkonrjYc+gqYMGsw4SJXDIAcbZ2ergOeLqgRbxZ9v5FS2M0Hv+toTDl7kRGMQJ4uB8HNeBA8jvuODebpTGt5Rbh5OFhzTCp/RA197BDrdg8BwhVVAfIQ2GhNMjkQ5QN80vXfudshj5dH1mJbMprKtdFVtl2CUUpoZM0cw6eaXvn2hfQgmFR6bpIIZPQEHRDsAL9MqJEIWkSIdcCCpi1UuZjvsqdToFTZ8oW7wAUPW4VKpZfp5gEWYPFE5GYmzadM/k/O+Bc1zcv+Oz1FJl/5RZCNLneRL7VrY8ZPGmWmp6A1yXMKIsK+WJNhDaBAULC+pFBBZNKcPTCs5PUE+noASlqRgReZtZphyHEsxA4M5jqrVotLSZb1q5fW/dKy/S4Rg35q83RHUYqn27twAKtuflZp5xtTfRb3eCIPNjrqSDRvsVdX4HuBwtzRQD6pj4uHsBTU2+07TnO0Y7tGVaCpkEn5kT5VToM9pxCU+YKsOFZ/NPO7c6uCGBQjgNaUfWxWMsfDJGd/dMTkk++VHD9ZxkFoGPDfAXASxEDk1KbB1ovr5etk1gPxgDW/ZQvwfrDXxSDy
 jwyUY9SJ
 ktZdjHmxu99tGUgCpV9rc3dYW/d4VkFVnGbHbZdT8Ab0BnMvC5/OhBSMySQwUeLxZujS8ef+Kdle1IL3bO3IkRuMuIDqeu4HEbM5eMukdCt92wJIkLf/lj8MLBUnAV/o5SMb4wj3Twz1Mfx8V9NaLSA5QlkiUUWr0WyMSEp9qXB3LjP2Fbs5cwvfa5ctE9HCAiKkEgIgGJC6zIWshTy/Qe2o9PsvZQF5DVNIAeAWsZS1lXjOD1f2JxxPpVBE7uYb+gqR6lSArmjdhw237rZ8nU0+PZ+syOOtIqt0P6tMul4WEbg/ESNdXWHvKMF+HpPruBKi/TgjICgAELY7Re/Fq8KOz/uWbRwdTz8gRv2KPBODF/R9IhWoszjcaYCg5qEfZ+WBY2Se8BtowiAeuLbWstAxM100zY4JxY0YVNMHNcYRsIG12r9omfvTwDCbr/IV4tfJK1YXIpXbMioJRqB07HJmcJ5ap71oe8m3JWjpF7dnKIVOvEttEhqIaCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

在 2026/11/6 22:06, Johannes Weiner 写道:
> On Wed, Nov 04, 2026 at 07:47:09AM +1100, Dave Chinner wrote:
>> On Tue, Nov 03, 2026 at 12:50:53PM +0800, Kaitao Cheng wrote:
>>> From: Kaitao Cheng <chengkaitao@kylinos.cn>
>>>
>>> Successful writeback calls zswap_entry_free(), which removes the entry
>>> from the LRU and decrements both the sublist and node item counts.
>>> shrink_memcg_cb() then returns LRU_REMOVED_RETRY, causing the LRU walker
>>> to decrement the node count again.
>>>
>>> The affected call path before this change is:
>>>
>>>   __list_lru_walk_one()
>>>     shrink_memcg_cb()
>>>       zswap_writeback_entry()
>>>         zswap_entry_free()
>>>           zswap_lru_del()
>>>             list_lru_del()
>>>               __list_lru_del()
>>>                 atomic_long_dec()  /* first node count decrement */
>>>       return LRU_REMOVED_RETRY
>>>     atomic_long_dec()              /* second node count decrement */
>>
>> That's a bug in the zswap code. You shouldn't be calling
>> list_lru_del() from __list_lru_walk_one() context.
> 
> Grr, Kaitao you dropped the wrong thing that I thought had merit in my
> proposal...
> 
> Dave, would you mind taking a look at my patch at
> https://lore.kernel.org/all/auJkvb-Lq0M5Enkz@cmpxchg.org/?
> 
> Ignore zswap for a second. I know it has problems. Most of it stems
> from the fact that we rely on the swap locking and do none of our own
> locking/lifetime on the zswap entry. As a result we work around it in
> odd ways. Sorry, you didn't ask :-) That's worth revisiting, although
> it's likely more invasive work.
> 
> The observation that led to the patch above was a much simpler one:
> since we now have the caller-locked __list_lru_del() anyway, the only
> difference between that and the list_lru_isolate* is the
> accounting. The patch is about one thing: removing the isolate helpers
> entirely. There is then simply one tool for caller-locked list
> unlinking, __list_lru_del(). It removes an avoidable distinction,
> shrinks the API surface, makes it harder to screw up.

I don't think replacing EXPORT_SYMBOL_GPL(list_lru_isolate) with
EXPORT_SYMBOL_GPL(__list_lru_del) makes much difference by itself.
The only reason I kept list_lru_isolate() in the current version
is to avoid passing an additional parameter (nid) to the isolate
callbacks.

I don't have a strong preference for the current approach. If we
can reach a consensus, I'd be happy to send v3 with the proposed
changes.

> The zswap weirdness made me look at list_lru. Consider it a stress
> test from idiotic code :-) But I would propose the list_lru
> simplification for its own sake, regardless of what we do with zswap.

-- 
Thanks
Kaitao Cheng


