Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27778CD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 06:07:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CB056B008C; Tue, 12 May 2026 02:07:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87C316B0092; Tue, 12 May 2026 02:07:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76B816B0093; Tue, 12 May 2026 02:07:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 659FD6B008C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 02:07:12 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BD0D2C1967
	for <linux-mm@kvack.org>; Tue, 12 May 2026 06:07:11 +0000 (UTC)
X-FDA: 84757735062.15.408D6F6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id DDDAD2000B
	for <linux-mm@kvack.org>; Tue, 12 May 2026 06:07:09 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NhwQOgic;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778566030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XXkanqEfKz1uvcH3O4rbsWVqyEIhH0Ce8ryQ2YgxDf4=;
	b=MILD94LASuCxjrzAMxU9ZQaBCuqCMQ2CW8GhL2zDwwJv3kThiMSi3Z1ilAW6i+T17OEtCJ
	3Mp++O3aC3R+a1+TXS2H53NI7CkqJf2oulnFT2YmnXjPhZl8sEW7jApjakSQNlPkqWVute
	XvRnBw2MbSkeo9AyKVgoHHrVxPD5rLM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778566030; a=rsa-sha256;
	cv=none;
	b=getoiuMM8IV52VTWWEZPzcDdMgZD3eHcM6VnmVACC1xsjJWQickN73pNAfARUyT7zpKalZ
	Sz8KleSgzN4EJDBk8bcDq+5I/6POq48b/EOJWheFYGY3jb8z6NvfoIkWEhi/wCecFYtH33
	Ifu7efEXhBvamisQnt+8ZiQxvW56WX0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NhwQOgic;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B3C4741947;
	Tue, 12 May 2026 06:07:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67ED4C2BCB0;
	Tue, 12 May 2026 06:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778566028;
	bh=VWElD8N5WTBdXHKBgeBL/uSoaG6aJNYfk5WH4sPgxcg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NhwQOgicVtnRMij32COh15iL/XYtaJTg+PJGfCUKaU7MEkHvuGpEOv/6uFIIgEb0G
	 Sa+RG0lJMUfC3qdEi3q2s8srb0J85P2oonslrG5B7LcXz3qO8MKWa5Y6AdBrBk6OMH
	 Gd21rDcvDSpd7N+DxBKe6fl98EMQuUlfjsABQ+eKMiq80xjmKRZbTB7mMK0JrZzw3J
	 IrCfFkR8Y8a1yVcchETCK7Wq9tEmIRGyvMjDH3wbiy4HnLd9CVTdH89NboT2+u6DbN
	 9ng6qMagu6839IQimZObhHbSqKk5OtZopLcwUE8jsoKpIyVDmfEuWXo7EOh0g3awqX
	 3ehZ0CG53S66Q==
Message-ID: <84f0811c-f04c-424e-b6fd-22e102c6b76e@kernel.org>
Date: Tue, 12 May 2026 08:07:01 +0200
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
 <c72ead41-0bb3-4da0-856c-315dc552c722@kernel.org>
 <CAMgjq7CK7DPfHEXUY+mDeKu33n=CBrh1RKmpem7Arjsas9rxYw@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAMgjq7CK7DPfHEXUY+mDeKu33n=CBrh1RKmpem7Arjsas9rxYw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: DDDAD2000B
X-Rspamd-Server: rspam04
X-Stat-Signature: mnx7ofnsmk49bfr7byd7h6dptgsu5gjx
X-HE-Tag: 1778566029-90048
X-HE-Meta: U2FsdGVkX19vz59E9OQ4DM7OTdZN45uR+KM6dgqGvQWlURYxDQQLMhlv3FtfolDMwTCAkNxa7gxvg/M9KPGPQk9cs+RGF3c8N1oKT3NAgq7l6me4wC/remd3q9UgsnAUWsHQBJJKmJcRkFVV36UQKuWlCUtvOCTaH6Z720v6kO1nrowsSUCyhF2P9+tH39L2mTA+3+u9csOyAGC/M2sj+dPUGoXFVJ3/uiRYjUty/ouj8iXoxDkIXh/pRXgz62nFh++8xGT6i7YqYA5QGQu9sPjViPodLQTyoTV0jjctMP4vSgQRslkjCWGWzzrck0Mfx2Q/VzBxFBOkLSsvWtIP88lyEfKnwFK3CCt6SHvdEldTsvh33JZx0vXFDer7rMooDhDuikEk7jsUSBtHLfpAz7T+hCKPqtGHqb6SVtrnzVbjdjdQBEMY/ndfUS58O13Mt6QzUu8mGM/6kEkDH09I9pbOgPo/WCx50/ZhdSqyahoHq/4ZHYX1Ztc7mtCGPSA35yRHiC/jna0gNXEGUdld8/DbkcymOmhg+OqV13fS6mMFv2mFAMmQ1f4jzZu/j3Dv0Q7j6D+V3bnSS2ZytJy2T9y4yD763GPSRtwCGF0kPyVAHtq9DJFylDlrOWPB9oaiJjtMJV+/IeHwjf72myrC7VZiztrbw2MNw/r4B5qpawGzR9SiuWbj0L2aH0g5RDhkmdkY+ZBy+X6cHKY/UhwE31+Un4M+kpNVYmZS/EZmA88Jw/nE1+UCvQb5rghTHgyvX1ibSViFp94v2L+1v+0MB2LYftxrgb4ffDWSvpj99IUll2JEbx37tz1XWVj6hZoMKvNKn7mqQazCkMdpGYW+8OVToz2e8na6EhLQAEKDKLFdD8sWJF3U5eJrl5DPUWMk6IF+/+9dKx/VtMX6fRcl1cmsDXfUzd9VvjH096kFinAjmhcYPmSm56NEFxlGtdVNT9dNosEjuzcx/aZYAhv
 EPlZuFuw
 oC/Tg7Q7fMNF+GoPsmUPWDUIrGKRpmXhH/w/vy6c0w0l0U7Xj3zTuFxACPRxp70jZJYTF0bqhWQg6rJ/xzz36wClvjhDKrUH63eoHGeRrfX+8N8td0oH3jfFMxrp5LNfnGWGt8MDuO7JEo1vR8mMwQs2BC3XSkxLuBL2lc0p98bpYebsdIUWGCqHdGdbT9hbcNNn0lrINnQbvya5HFj0mpWlaZE0Cvk7g3mLxLgFxUJwPw7tWC8y0jQsUtmCGzmXrPBool6UxntD2N8i/fTgcIIswskYufVRfBM6xxmZVeNQ9+D2PibHbraKAVdcGBjcvmmE3iSD0pxXwBwCy7fkVWCtpI2ufwoKprMlR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/11/26 18:44, Kairui Song wrote:
> On Mon, May 11, 2026 at 11:15 PM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>> On 5/11/26 16:37, Kairui Song wrote:
>>>
>>> Yes, the current status is a bit odd, about two years ago I also
>>> wanted to name it `swapin_direct()`.
>>> https://lore.kernel.org/linux-mm/20240326185032.72159-3-ryncsn@gmail.com/
>>>
>>> But actually ZRAM or shmem would also benefit from supporting unified
>>> readahead like this:
>>> https://lore.kernel.org/linux-mm/20240102175338.62012-6-ryncsn@gmail.com/
>>>
>>> So calling it `swapin_entry` seems more future-proof. At some point in
>>> the future we might remove `swapin_readahead`. All swapin operations
>>> could have a unified or at least a per-device readahead policy like
>>> the one in the link above, instead of the current policy where the
>>> caller must decide whether to perform readahead.
>>>
>>> But any suggestion on naming is welcome :)
>>
>> The other proposal
>>
>>         https://lore.kernel.org/all/tencent_CD11FE9B4A0B362E95E776C5F679598FAA07@qq.com/
>>
>> calls it
>>
>>         swapin_synchronous_folio
>>
>> Maybe just swapin_sync_io()/swapin_sync() or sth like that?
> 
> Good idea, I can keep the swapin_sync name at this point. Sync io flag
> still may remain for a longer time.


BTW, I was also wondering whether the whole sync vs. readahead part could simply
be handled in a function called "swapin". moving that completely out of memory.c :)

Probably something for another cleanup.

-- 
Cheers,

David

