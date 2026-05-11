Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45130CD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 15:15:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE12B6B00CB; Mon, 11 May 2026 11:15:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB8BB6B00CF; Mon, 11 May 2026 11:15:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CEF36B00D0; Mon, 11 May 2026 11:15:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8D1F46B00CB
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:15:54 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 30AF71C0081
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:15:54 +0000 (UTC)
X-FDA: 84755489028.14.A3C8026
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5841B1C0011
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:15:52 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Fb7tKuor;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778512552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XjdwrlaOaN3+z/wneNjLT6PJRkSdEUcDIk/Xh69xkSY=;
	b=SV8Nyv/spXJj23BaStCH/zPa86GsiOW6ZnarH8Vq/aXCg1rHslmmYvTMXOmmzj3Zhz4v1n
	Yigv8imHKw9l7sn22qNrbb2td4essR27iqR9MGfyodANwXTdo0k4DG21mTQINaee4AQrPM
	vfvRc8+CeIlM5LrpeU0UtMvDMgJYweQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778512552; a=rsa-sha256;
	cv=none;
	b=nMFXba8CGPVQE7EJzAwH2wuhXjeYqnDdQPrPXGp2NTNg401PvtpZycMGa9Cnm8F0lrQKh3
	K0aIdu6OSDiOzNPxicNFkchTYR4qiv1DeC7H/TgaqCZL1GDbQv+IHXpvHf6PKDar/RR7k8
	ezn6FyjUeo9z+2Wj+jKAq9EwWDj8ijg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Fb7tKuor;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 997896001A;
	Mon, 11 May 2026 15:15:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48EA3C2BCB0;
	Mon, 11 May 2026 15:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778512551;
	bh=XU8h+UNIZXd2xu8Y6zOdyfGnC8dGq+kPUi+hYVKln78=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Fb7tKuorEh7gKXNnQi4K7eFGBeo2w8f3vgRJMdUhhqPl8rhj0zua61ZI1MLE/hL9P
	 IXocQEGsApafUL4lQlxZ1tO6lJp71RkaiJZXmAtf/1o8kkItpPhg3TyhR8Wn8UfpUZ
	 sZWAYh+jR/2lacJ3BhpstlHUqnnj+K19vA3Vk69fHjGi7wOH6PY73beiIkHyJrWYa1
	 fW4w0yhbR1ej4tzu2sNhdbCUIBnkJflAd7CvIC+gH/33s6cJoGOuHBsz6jzjRMrnzC
	 r3p0ibbAePYx7w4LVg/xyj96Oa8q/0+2p6hGngNv0023489qEclWFXHJmDYvt6/voO
	 nuHqWuY/CpZJA==
Message-ID: <c72ead41-0bb3-4da0-856c-315dc552c722@kernel.org>
Date: Mon, 11 May 2026 17:15:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 05/12] mm, swap: unify large folio allocation
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Barry Song <baohua@kernel.org>, Hugh Dickins <hughd@google.com>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Youngjun Park <youngjun.park@lge.com>,
 Chengming Zhou <chengming.zhou@linux.dev>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Yosry Ahmed <yosry@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Michal Hocko <mhocko@suse.com>,
 Michal Hocko <mhocko@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Axel Rasmussen <axelrasmussen@google.com>
References: <20260421-swap-table-p4-v3-0-2f23759a76bc@tencent.com>
 <20260421-swap-table-p4-v3-5-2f23759a76bc@tencent.com>
 <675e9027-9fb5-47b5-9a2d-c9a416a27d0d@kernel.org>
 <CAMgjq7DegMz2ZEHOhHkAqDEWDuCSZ7Ktsxw1ibDY8axFzRRGnQ@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAMgjq7DegMz2ZEHOhHkAqDEWDuCSZ7Ktsxw1ibDY8axFzRRGnQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5841B1C0011
X-Rspam-User: 
X-Stat-Signature: 86tq8p547wo94qj631hhj7pcdzc177ir
X-HE-Tag: 1778512552-679209
X-HE-Meta: U2FsdGVkX19KLr4hWE/XcCK2nrtqUIrOzJ07mrVsdxlyjkftW+rXVDe0+j6QfPfG9jp+6RVJJ16alMnJ2F7HddKFaZHCJlAskJRz1OhAzWKy+1TPROHzyyteJNf9cpe6iq+xXhr/HbSQw2GvWj82xUSHu12qlXAWQNl3GWjmMu1Jixa29L7vFm9U/Btv52K6QIpzzqaMMP2tgxIVj9TDJ7c092iyVpHAVBP7MC4P0hOo2mW8cpieCCDQGiul+MAK/+JhImumUFFhqfeg8kQGGjn6sVsz/tTReK6iToChpiLE0fd7aHDzenWnHjmlp++QwYiosvnb+xGPmIQSwRMqoxQN5AVdeR5mKATRW00qp5c5iPC5ZKz+f45fZOeE3c9/Ccsn81jFvr8wGfjSO1wlOxO+gDo3R5rHKpjgqACRLO7p9vzZv2/M4D8CU5KECsiBnz9TdRGisBFXCpcgVrW4kbfywozDsjIEw7Uknatd14aTWnGpykCYipui9yH8xHVbesXR+5LifZJMfZpUMqsG/JOfdSnHw9nfr9pP37F+a3cJVVmFxzSSx7abURDr0+eKFqcht8d5EoNJRYPjdipISnlxnGrW8Qp63ofiaq2gjlHjwuhixoE8hC/9OBntldFvKZ4siPDaFQCBi26vAxc1idA1q6o/dzbcPAgk3sxYcRE92NCbyqZ59ykhNX3DlZa3RQzSdFDrPYSFpGlruQkePvPwiiBvk8y/LA3hFGcNTMtkANZM/0n10uyaCnXeVklPUGcz+o2gKv9gC2VSX0scF5CCJXaVYndDoHsrDplJg9Z4jQ0fPEV40H9eKbLE/6KknHsH8EGYSn/9KucbuvfyVZun2OyNpz8MVyHR/yiMBFLac9hqH6B4+9HNi42NSgrAY15Gk77lASvIc5bAlcy499pga8xfvnPC2EkD7fdvY+TZKzwZHFJvc7VGfAxW+kCH1mgYBmcQso5MzBbqRAk
 m6DrgHDB
 BoDUp5NubI1pg/yP1kQbFfEFi1gPZAk7hZxgZDJNWUEzCWCv8sxPObOAswCDCQZcPoNuPIeG6YEFi9R1fAvkphUeN/7XIbrMboCqvBAI77478o7o9m7EmGU7Kf/A8sNdYOHyuArAA9e8j1fVEDLYNCe9xCpPKra2Z9vqFzRTpOnhuHv+ulyQ7DZs16Kd083IeJRhkCL3x3qDk3QQBrCGwUxuiDWsO1U5A7t+nHIigbTMZowGcLbV5IVigoy1czbgcs+rh5Z6Zb3FcR1ohRrmfUtgj5vt83hXXgPuMpXl72Nfs86qCfFYinGf/B9nspeq12Y78H44x/ExGZnvloEjwJ5OnwSOw57zaLxLyZ9nSOwr/IbRpxsC954xwQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/11/26 16:37, Kairui Song wrote:
> On Mon, May 11, 2026 at 8:58 PM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>> On 4/21/26 08:16, Kairui Song via B4 Relay wrote:
>>> From: Kairui Song <kasong@tencent.com>
>>>
>>> Now that direct large order allocation is supported in the swap cache,
>>> both anon and shmem can use it instead of implementing their own methods.
>>> This unifies the fallback and swap cache check, which also reduces the
>>> TOCTOU race window of swap cache state: previously, high order swapin
>>> required checking swap cache states first, then allocating and falling
>>> back separately. Now all these steps happen in the same compact loop.
>>>
>>> Order fallback and statistics are also unified, callers just need to
>>> check and pass the acceptable order bitmask.
>>>
>>> There is basically no behavior change. This only makes things more
>>> unified and prepares for later commits. Cgroup and zero map checks can
>>> also be moved into the compact loop, further reducing race windows and
>>> redundancy
>>>
>>
>> You should spell out the rename from swapin_folio() to swapin_entry() [and why
>> it is done].
>>
>> swapin_readahead() vs. swapin_entry() looks a bit odd, fiven that both consume
>> an entry.
> 
> Yes, the current status is a bit odd, about two years ago I also
> wanted to name it `swapin_direct()`.
> https://lore.kernel.org/linux-mm/20240326185032.72159-3-ryncsn@gmail.com/
> 
> But actually ZRAM or shmem would also benefit from supporting unified
> readahead like this:
> https://lore.kernel.org/linux-mm/20240102175338.62012-6-ryncsn@gmail.com/
> 
> So calling it `swapin_entry` seems more future-proof. At some point in
> the future we might remove `swapin_readahead`. All swapin operations
> could have a unified or at least a per-device readahead policy like
> the one in the link above, instead of the current policy where the
> caller must decide whether to perform readahead.
> 
> But any suggestion on naming is welcome :)

The other proposal

	https://lore.kernel.org/all/tencent_CD11FE9B4A0B362E95E776C5F679598FAA07@qq.com/

calls it

	swapin_synchronous_folio

Maybe just swapin_sync_io()/swapin_sync() or sth like that?


-- 
Cheers,

David

