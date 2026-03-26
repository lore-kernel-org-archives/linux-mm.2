Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C2A9106F2FC
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 08:41:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CB026B0088; Thu, 26 Mar 2026 04:41:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87BB86B009E; Thu, 26 Mar 2026 04:41:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 795156B009F; Thu, 26 Mar 2026 04:41:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 67B2F6B0088
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 04:41:34 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 31F23160AC0
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:41:34 +0000 (UTC)
X-FDA: 84587570508.05.854050A
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf24.hostedemail.com (Postfix) with ESMTP id EAD62180005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:41:29 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=XQYKTxfM;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf24.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774514492; a=rsa-sha256;
	cv=none;
	b=PAHaF4MJLmxThg2cefnRkr8p8i7yuQQPYx8+JXgmIpPWNOzUY3OTYLha17GAWRsxzOUfZQ
	kVgKVsikMjxnlU+W88q6eaBhpZZS4TP5GZz/sDoIcCZvS97LCCo+TukV6gFOVQQYfCZ+qW
	vEy0/QmViJ9iT2UY+2aEd8ZPj8eyMhg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=XQYKTxfM;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf24.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774514492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S+d6Cp7V+ffV/ZBZMslYlaeNUy1XXkPL+l/jdknO7xE=;
	b=eFMCaZ/b0C+Cw6ZVbJR3V4fMbx1V9qReQcMJw8MDRXhwSVpr17icufLmkMbDF7qK5ZDeET
	bkOZbueg8MIkblcKOyS16Ty0yd/qR/YjDDPx9VqNyi9O1q+orYG8m66YX02jt6hHEBjme/
	brlAT76KgcQPofqPeMTXPQuTmVdgNWo=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774514486; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=S+d6Cp7V+ffV/ZBZMslYlaeNUy1XXkPL+l/jdknO7xE=;
	b=XQYKTxfMDs2yIB6CWGVZiSp5f5BHo9jhEr9E32RgdQuoefyg7epRcIq51oEJggqu0uAXyQRA/5N3ttRgh/7ilsrGpKCu32YnVENGa2JfAYzLGV10948f3oc9L2QmXzeNiRGKw9OPwzDrSvhKLvF17KNo4s0pUwKafo+RKpsUWA8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0X.kdTKZ_1774514485;
Received: from 30.74.144.123(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.kdTKZ_1774514485 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 26 Mar 2026 16:41:26 +0800
Message-ID: <b6f8e48d-4440-44ac-b4c9-79aa777ad2da@linux.alibaba.com>
Date: Thu, 26 Mar 2026 16:41:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm: vmscan: fix dirty folios throttling on cgroup v1
 for MGLRU
To: Barry Song <21cnbao@gmail.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@kernel.org,
 mhocko@kernel.org, zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 kasong@tencent.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <bf40a20cd93b6c21f10db95657928fdae185e843.1774438978.git.baolin.wang@linux.alibaba.com>
 <CAGsJ_4x4-hURgpH4ctpUG41bpeyrMYWrVNvyZLYheunNqrgY1Q@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAGsJ_4x4-hURgpH4ctpUG41bpeyrMYWrVNvyZLYheunNqrgY1Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EAD62180005
X-Stat-Signature: zka4upejyotuy3fezi6gbec14t1q3nwt
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774514489-572486
X-HE-Meta: U2FsdGVkX1+iAz1fSpzW7BAI6J3lge+tjPTSLIDjlIW62sBIaBzEfLZTGi8r2KAoF6uu90rz2annxVU323PHsA3v2kBDklcV/6FfB5hL9nrYDX16YinfS+/Bj7exDIBFIRgjP6gIzwJufFNgKPlTHNYaX4pC/nZiN3QMlHx9APb5dctnozSKy2k/FVhn/B3V5St4eqWchwrFAAYlNxOVxRW3nIcZQ3S1cGH7w5bLxBBYqunlokrBBGDSEyX9AB8r4FVzGdJqrY20H25Z5EzJfLn3Kvp6qhZgG7Yi/psHk+kjZXt8pLZmmyGkwkYaBqYRlgFiKihqXI3gRBcQqcj40IbsBf1men3QvRu6NxC7HhtCpcPTVn2Q/zWkTmp3viXTi0vTf1MqUi3rRxaAavtbM8b0w/BwaZi+z6Ob/hjhmn0yU7Cq7qfYXSnT+mQNPFtM4wcebz02dnTmkxVALVVKXl6wRiwqwmejelWKkWtmEOyKC3mjhVmXofNLbO2CsEQJYq32DJgnuLLkiwVW0d219aR44YT9ALUpV02seWT9JE5DsUbzGGHuwH6LpZoMJQZ28xpFfWqxYaiSjlbyL/bECk7fwZ5tMzg901lvFGn0eF4SF+Qx1nubQwMIYLlX57lfaIJYAmmKD/UxCfKKAouRD2ty9f0eBbTmEBdQGvhX7L4CcZdeSTQRdltC0Bk4/P8XGBQm2/FkjeQgxFOPFHY+GuCcrxP6Ha13deYIQTorrg5N6a9eGj4K0yKpJ1CR1i0fEhkiZpc3wUDb93A47PDtF6ulae/511f9IzjCp1F1ky/XxORoVpKhl8w71ZPkxB6QwJrripO/H0lPJxLif2M7PZ3ggDpWqVKLUVJBzkmkChmegSZ6gPCDFMiar1DBNYkkQCChjxQNkCP2hpVd+kkSerhgFBYI99ps+0duvFbEQtBlldegYwnS6sMPpjAYURAnqteUacYDA7Bnv4r8IJc
 xsCBoE+6
 MxHPRugm/SguYpYKnMJeMQLa6PGSbVFMUpPq8ARxXU9KNKVmgnrZLY8WMDftNa2d/YguS/Xz4T+hW++v9v8EQ+D+DXNI6WE9yExhl1OcmcQzDyznhQ++Awsy6e7l5hCZ2bCbyRyGLlEMQnfUS7zvpRaryeXEI5zRnfSg3x9Rp0w5LlY+LhzK5S+WInUp442iKQgpg47ymFqR0mMmJpmZ7w6zY8gUWEgCn5TbwughbQ3nbbRUYcT8kWEOpEK1oI5HEv/h+8jhWhEx2cc5nem0H0HIsz1HZqsFioHV1+9q9fZDGG+9oCRIrbQE0ITnAGuZeTtvDbD1+qQ6yEFsJJJlBVoBR3yEblHSISdsICA6N0WWt/viMONey5Lsmdw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/26/26 1:04 PM, Barry Song wrote:
> On Wed, Mar 25, 2026 at 7:51 PM Baolin Wang
> <baolin.wang@linux.alibaba.com> wrote:
>>
>> The balance_dirty_pages() won't do the dirty folios throttling on cgroupv1.
>> See commit 9badce000e2c ("cgroup, writeback: don't enable cgroup writeback
>> on traditional hierarchies").
>>
>> Moreover, after commit 6b0dfabb3555 ("fs: Remove aops->writepage"), we no
>> longer attempt to write back filesystem folios through reclaim.
>>
>> On large memory systems, the flusher may not be able to write back quickly
>> enough. Consequently, MGLRU will encounter many folios that are already
>> under writeback. Since we cannot reclaim these dirty folios, the system
>> may run out of memory and trigger the OOM killer.
>>
>> Hence, for cgroup v1, let's throttle reclaim after waking up the flusher,
>> which is similar to commit 81a70c21d917 ("mm/cgroup/reclaim: fix dirty
>> pages throttling on cgroup v1"), to avoid unnecessary OOM.
>>
>> The following test program can easily reproduce the OOM issue. With this patch
>> applied, the test passes successfully.
>>
>> $mkdir /sys/fs/cgroup/memory/test
>> $echo 256M > /sys/fs/cgroup/memory/test/memory.limit_in_bytes
>> $echo $$ > /sys/fs/cgroup/memory/test/cgroup.procs
>> $dd if=/dev/zero of=/mnt/data.bin bs=1M count=800
>>
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> 
> LGTM,
> 
> Reviewed-by: Barry Song <baohua@kernel.org>

Thanks.

> Maybe we can extract a common inline helper to avoid the copy-paste duplication.

Kairui is planning further optimizations here (including using a helper) 
[1], so it might be better to leave that for his series.

For this patch, I intend it to be a standalone fix, and I will add the 
Fixes: ac35a4902374 ("mm: multi-gen LRU: minimal implementation") tag.

[1] 
https://lore.kernel.org/all/20260318-mglru-reclaim-v1-7-2c46f9eb0508@tencent.com/

>> ---
>>   mm/vmscan.c | 13 ++++++++++++-
>>   1 file changed, 12 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 33287ba4a500..a9648269fae8 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -5036,9 +5036,20 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
>>           * If too many file cache in the coldest generation can't be evicted
>>           * due to being dirty, wake up the flusher.
>>           */
>> -       if (sc->nr.unqueued_dirty && sc->nr.unqueued_dirty == sc->nr.file_taken)
>> +       if (sc->nr.unqueued_dirty && sc->nr.unqueued_dirty == sc->nr.file_taken) {
>> +               struct pglist_data *pgdat = lruvec_pgdat(lruvec);
>> +
>>                  wakeup_flusher_threads(WB_REASON_VMSCAN);
>>
>> +               /*
>> +                * For cgroupv1 dirty throttling is achieved by waking up
>> +                * the kernel flusher here and later waiting on folios
>> +                * which are in writeback to finish (see shrink_folio_list()).
>> +                */
>> +               if (!writeback_throttling_sane(sc))
>> +                       reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
>> +       }
>> +
>>          /* whether this lruvec should be rotated */
>>          return nr_to_scan < 0;
>>   }
>> --
>> 2.47.3
>>


