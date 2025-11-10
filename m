Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30B70CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 10:50:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43D078E0014; Mon, 10 Nov 2025 05:50:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 414E28E0002; Mon, 10 Nov 2025 05:50:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 351FA8E0014; Mon, 10 Nov 2025 05:50:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1F5738E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 05:50:11 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BE7925CA66
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 10:50:10 +0000 (UTC)
X-FDA: 84094377780.25.8AE9A9C
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2E22B20007
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 10:50:06 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Mib8tEax;
	spf=pass (imf13.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762771809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IYGpWxlfS7Ghtlne/3hBnEGQd5/vaVez4+R8iM/BRvc=;
	b=ozpfHyqSKNAgq0w9+s+a+ydbFifQZRxsutptIUkLCVviuiFs/2QslfQVVJpzcYnTLW6F+5
	j7FyKWXoxPYhTR+xBK9n4Y4+MkMXe495IM75nTWqepWmp2CHH4FAuGPOuZn++2M7Wl/YsC
	HKdQbQCk5XgyQemq+8oRSnaas4FHPfw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Mib8tEax;
	spf=pass (imf13.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762771809; a=rsa-sha256;
	cv=none;
	b=437XzFxUMg7VG72R49wWphIX/ACm3JIhLg001KuobNZi/YYEkrXmIlyXBShi9ZkiE1pf6/
	gnVDKlJSz3+bYeo94vt8WBENl7uSanZTlZSdJzeR57jQcnh5ou9rpUQUuXmF1nXoXreRTa
	Eb/bPT7Nwk5+Wu1Xj+YkS+p/A2QqZYo=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1762771804; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=IYGpWxlfS7Ghtlne/3hBnEGQd5/vaVez4+R8iM/BRvc=;
	b=Mib8tEaxFA7R5wFd5+SCweSusyDh1kp24viV8bLJUhkZp4n0FAA6reSyjigFYOpMdnZfCBYiKb726VnbKLCuNCStyoVlBmcBKsPgHOCKNuR656pNXZixnATkPwY9g3gycX5lImWdxU8dOtTDE8q5U8+7E3Jq/KlzRkyea6EUzkY=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0Ws1z-Vy_1762771801 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 10 Nov 2025 18:50:02 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>,
  linux-mm@kvack.org,  Andrew Morton <akpm@linux-foundation.org>,  Kemeng
 Shi <shikemeng@huaweicloud.com>,  Nhat Pham <nphamcs@gmail.com>,  Baoquan
 He <bhe@redhat.com>,  Barry Song <baohua@kernel.org>,  Chris Li
 <chrisl@kernel.org>,  Johannes Weiner <hannes@cmpxchg.org>,  Yosry Ahmed
 <yosry.ahmed@linux.dev>,  Chengming Zhou <chengming.zhou@linux.dev>,
  Youngjun Park <youngjun.park@lge.com>,  linux-kernel@vger.kernel.org,
  stable@vger.kernel.org,  Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: Re: [PATCH] Revert "mm, swap: avoid redundant swap device pinning"
In-Reply-To: <CAMgjq7CTdtjMUUk2YvanL_PMZxS_7+pQhHDP-DjkhDaUhDRjDw@mail.gmail.com>
	(Kairui Song's message of "Mon, 10 Nov 2025 13:32:52 +0800")
References: <20251110-revert-78524b05f1a3-v1-1-88313f2b9b20@tencent.com>
	<875xbiodl2.fsf@DESKTOP-5N7EMDA>
	<CAMgjq7CTdtjMUUk2YvanL_PMZxS_7+pQhHDP-DjkhDaUhDRjDw@mail.gmail.com>
Date: Mon, 10 Nov 2025 18:50:01 +0800
Message-ID: <877bvymaau.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2E22B20007
X-Stat-Signature: 17hrac7xbk4jpd95gb8yb5sagnpqhc1a
X-Rspam-User: 
X-HE-Tag: 1762771806-583588
X-HE-Meta: U2FsdGVkX1+/O9EvfcVwC4ZV7RIJw+bQZWEO6O4Ckkq/Sm/a+UbSquPdFCsnul3Qu8M+qzT2FeuqKuX9sVg4M2gw/s5T42qxtE0Nk2SBIwcbYMCyuReREY1vWlqysKSxQGfum8e7AObxH/NSIt8L5wSQx18I4tKv8cz0Q7W4Mo4pUmDSyXlpVPFrvZ0l2yO8mUHPoSQ4LtpUL9QHq3LH9G+a0bgqXAWrR/9zSFHungKuM5E3Ob0WQioG0YMU/7Bptz6YoE9ETzodxKFZtzIrsSYtAFkCSgglhYNCoUUpitbjCvORuOqO6FgDhmfcRAENd6Q58yGSnQfJ2/mROsxr2d1An3Ideg4s2U9osmY4JrE2WA9XxPindArfd6ZnRM+n947afSmhAGNEon2tQHhiI/koSp3r4EXu3E7qjGKyMfhSxDADkImCm18L4ffLZpwJ+wNRXSXWIv/zZc2PXWvr/AXsHDU5jsfSQl1e7ouMTlIRISjL/LSmwW5z3ggS+z0OXEW0DCtwndzQ3DDIbuvdgcx2DG5JcpqCpWpF3yswiX8rrFIl5id84d5jxgQ0QEPnDg5xnCaF+2uI36b7A3Su60ZjC6YSDbRRfn9mGSBDFKLiQZd/EBW0WJs/M2bZ2pTFFr54Tcdyx71f+y4xK//W+9Ucunl7NgWETbx8lbSN0paVuXUUEDwwyBtUbQZuHrAFgqo3I1RSfwXEytbZPf4w08zBKTW7caUK/k012libVfnwNDEIqWwX1ljaWCJvWiQuIUNUIxvIX2MNNNC6W/0aFjRqJGUsp7b4VAfol59jxyaF1364+BtliasNUT7AfEq31wU7E68Ww3vFifscGIBLMJQccSWTHX6LoayltsU5Toqx7m0Sc8NbrNtX0+y8olMkjJRrrxr/ukDBWJ8PIcl3lDx2yIO1WR9XndAPRPZbwGGtpT5tutpES+ziUk3uAuwTycDST7ieRrFRjPLiY9T
 w/DMeehw
 hLH2svQXAITc/GedxJp5onD502U2NBFlG5RFjOt9+xh/zH0nhW4xMfyxEZ2Cdu10lKuZA9zKZNiqEij/PjfW2tlrCcpN4jEItVTeva39dApWdT5OiYty4XwFFDjN7HwVWp7ykmbjUqBi4Du1029huTImn16iasqUBQhjKO5qKLyS60m7+oQP6qdeeaPgkw8rjItdPePPTlpHGNBVIn/IDsueRbj1YPdTXoEA6YWmLv7Zf1qlyv0CcO790s/wjqbMMD63HTG/fezgSZKwEhSzG88vnJtlgt48FSYzVVOe6QKLmczJrFn6rxocgQXT1R7W+8n7LODzZihIJvoQCWdj5PPlxoV0mKH/AClIk7Vmt/x4Wp1OfPhfddqSXfGCSG2WDCwduH9/J5gwVfbg3P7rXaC+d6BH0oJvrTnDNPQLZZogg67w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kairui Song <ryncsn@gmail.com> writes:

> On Mon, Nov 10, 2025 at 9:56=E2=80=AFAM Huang, Ying
> <ying.huang@linux.alibaba.com> wrote:
>>
>> Hi, Kairui,
>>
>> Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org> writes:
>>
>> > From: Kairui Song <kasong@tencent.com>
>> >
>> > This reverts commit 78524b05f1a3e16a5d00cc9c6259c41a9d6003ce.
>> >
>> > While reviewing recent leaf entry changes, I noticed that commit
>> > 78524b05f1a3 ("mm, swap: avoid redundant swap device pinning") isn't
>> > correct. It's true that most all callers of __read_swap_cache_async are
>> > already holding a swap entry reference, so the repeated swap device
>> > pinning isn't needed on the same swap device, but it is possible that
>> > VMA readahead (swap_vma_readahead()) may encounter swap entries from a
>> > different swap device when there are multiple swap devices, and call
>> > __read_swap_cache_async without holding a reference to that swap devic=
e.
>> >
>> > So it is possible to cause a UAF if swapoff of device A raced with
>> > swapin on device B, and VMA readahead tries to read swap entries from
>> > device A. It's not easy to trigger but in theory possible to cause real
>> > issues. And besides, that commit made swap more vulnerable to issues
>> > like corrupted page tables.
>> >
>> > Just revert it. __read_swap_cache_async isn't that sensitive to
>> > performance after all, as it's mostly used for SSD/HDD swap devices wi=
th
>> > readahead. SYNCHRONOUS_IO devices may fallback onto it for swap count >
>> > 1 entries, but very soon we will have a new helper and routine for
>> > such devices, so they will never touch this helper or have redundant
>> > swap device reference overhead.
>>
>> Is it better to add get_swap_device() in swap_vma_readahead()?  Whenever
>> we get a swap entry, the first thing we need to do is call
>> get_swap_device() to check the validity of the swap entry and prevent
>> the backing swap device from going under us.  This helps us to avoid
>> checking the validity of the swap entry in every swap function.  Does
>> this sound reasonable?
>
> Hi Ying, thanks for the suggestion!
>
> Yes, that's also a feasible approach.
>
> What I was thinking is that, currently except the readahead path, all
> swapin entry goes through the get_swap_device() helper, that helper
> also helps to mitigate swap entry corruption that may causes OOB or
> NULL deref. Although I think it's really not that helpful at all to
> mitigate page table corruption from the kernel side, but seems not a
> really bad idea to have.
>
> And the code is simpler this way, and seems more suitable for a stable
> & mainline fix. If we want  to add get_swap_device() in
> swap_vma_readahead(), we need to do that for every entry that doesn't
> match the target entry's swap device. The reference overhead is
> trivial compared to readhead and bio layer, and only non
> SYNCHRONOUS_IO devices use this helper (madvise is a special case, we
> may optimize that later). ZRAM may fallback to the readahead path but
> this fallback will be eliminated very soon in swap table p2.

We have 2 choices in general.

1. Add get/put_swap_device() in every swap function.

2. Add get/put_swap_device() in every caller of the swap functions.

Personally, I prefer 2.  It works better in situations like calling
multiple swap functions.  It can reduce duplicated references.  It helps
improve code reasoning and readability.

> Another approach I thought about is that we might want readahead to
> stop when it sees entries from a different swap device. That swap
> device might be ZRAM where VMA readahead is not helpful.
>
> How do you think?

One possible solution is to skip or stop for a swap entry from the
SYNCHRONOUS_IO swap device.

---
Best Regards,
Huang, Ying

