Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72FBE1112279
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 02:39:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA7026B0088; Wed,  1 Apr 2026 22:39:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A57AA6B0089; Wed,  1 Apr 2026 22:39:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96DD96B008A; Wed,  1 Apr 2026 22:39:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 826366B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 22:39:15 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 12911139503
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 02:39:15 +0000 (UTC)
X-FDA: 84612059070.26.16780FC
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1E49EC0007
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 02:39:12 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sAxkuYR9;
	spf=pass (imf28.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775097553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j3m3jQtL7qDYgpW+vrpvI9VfgnJDYp7uTduhdYR8zOE=;
	b=khBStBI5luJRKHSTiPzw/vCGq5EZpkX+YlYKr6rkV/EAeknhv7DnXvm1MtqzJZcBxszkbS
	D5VFWymQw/cRElysmqAhY+14ibK2K0T0f9e7IMd83R5ZHuFNIt1P7tqqbsAAk731o1+5AN
	4Gm/YSlReKdSXxaU9a7mpYacUKHDYLs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sAxkuYR9;
	spf=pass (imf28.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775097553; a=rsa-sha256;
	cv=none;
	b=ULlq8W7uoEtkHtWKMa4IGOkzMrZqchcBrImIndvdLZcJUKXTjNVl52jhYYgIR5xM2gBi9w
	3OEna0QKkB9iXKUbikXZBcFN7+CTtOJQ8jfpOnuwKyDpZLGnoq06poQBmlNdrEMKDWwajP
	o7xDpyubZD8/mwiv97U3jtqj6LypIKI=
Date: Wed, 1 Apr 2026 19:39:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775097550;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j3m3jQtL7qDYgpW+vrpvI9VfgnJDYp7uTduhdYR8zOE=;
	b=sAxkuYR9DbGtdMhP/b5j/9a1xBzaSQQky3hhK4fbJndRUz0w+hB5f3aG8Dqbxq0Ltgsgw7
	tj3gBwwKl7JE9D4JY+O1IsYR7u67zKQBxwaYC5hIXK0xLrenr5sMbbpqAB/S9XWTxVqgiR
	61aDdEtITtihjrCnbCClOZR8StGp0ls=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	David Stevens <stevensd@google.com>, Chen Ridong <chenridong@huaweicloud.com>, 
	Leno Hou <lenohou@gmail.com>, Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, 
	linux-kernel@vger.kernel.org, Qi Zheng <qi.zheng@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: Re: [PATCH v2 12/12] mm/vmscan: unify writeback reclaim statistic
 and throttling
Message-ID: <ac3VV7h1fuDuUOJA@linux.dev>
References: <20260329-mglru-reclaim-v2-0-b53a3678513c@tencent.com>
 <20260329-mglru-reclaim-v2-12-b53a3678513c@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260329-mglru-reclaim-v2-12-b53a3678513c@tencent.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 1E49EC0007
X-Stat-Signature: z6pzirmjdisf4j5gpjxdynyqxrdjdikq
X-Rspamd-Server: rspam06
X-HE-Tag: 1775097552-652236
X-HE-Meta: U2FsdGVkX1/IWzurKt2vzzhvGIIm4oCz4PbaxB/GmnDN4Raqr1+dHoEQiZ9PfVnon6o5geDzbq6QsLR0DCRGeDHgU/1GZ8YysOHKaWwK/3KT0vn/bVmnfoqzsZSARKipCDG0srE9EqWM+bdEruQ8Z8kP5iPin2ydJdzU+igQTIoLASCx8iSjUgMTR2yXAoOiaL48W3vNdUkFk+5crWJs7EJibvfhO95csdOibhsYjvnSViCRmGwnakOWkfvJd7mg4H3WO/6pgWqdr8gM3+PgNk4f3VHhv9DXxlGMLVqctn0CQNcUID8idnSgleooH4YGwmW2tAkBaIi17z26PprW/BGYE25nXcJ5fqJD1xST5ss0UHDUcg0cvFia8n8mo4qSRH/1E3WLrZG6xd6K3aQGhvbr2rdhd4u+hL05vwLI/v8cMieUW30Jt1HHsoi6ZhrAz6oxy0o8qNT5zE6G/1/pfS8WOF+pLeVXkMnh7Lkbz5fjC4C8ohhrDB/HXHu7YuLHXqO91AMdtf7SXf1kkLDQHImSp4HJadpVj+/6RVopIiJFN+2YPQ0JWCl2azx/IjGYfPJyKqN6Ob62TetwFs8JcmakJ9L0OPDnemi9G8y4bYgX1lyulu31fzx9ldJa1mi1g/mMwWrPPiZljnKwKRS/JkUZpMyilOsYbYDZj4llZgsjQ1ay27crfMci6AFkgX53vVV+CK+SRDMlFpbFWvf5+iUYAfvHcteq2EZ8+dqf0aPEl4bO6xMTc3G8eWklsuPZ01vlE9FKTCT69UZTwI8ouKz8AK87FdJ2B1Ykj4M3VHQpR9RbDjrYj0vDyrJajFwnG4OJbrgV2vjjvBTLn2VJc8eh2juk7xWi5x4yHv+h+OJHEFazrolWebFlQteVrIR1mwpLFD7ptRlCYbFrK8PZ0lLmi0A1T4ksUAyMz+H6nfDsEMfJILrZHzmHiupV1vkrfuBzEcDzd/Egf9F5y4I
 8sMFs01y
 Pylf3jpGZ9qaVr6SFl5UzEV6HrGSOMUhrtz71OKO+RmrwspXVH9lTBg6V1m6ZsTvllAvos0T2Etx+Fmyq2Xx+7p/nQzlHWsDF/IhE3tq83WpBmq8oiq15XzGINNcS1MFgpmbM6Ac6V+ijN0VJ30EzWMJ+QeYKkBz+PwplSDzpfyaB1yMJ13EEaAJ8WsC/7hBqX115bLZ4Sd8pm27/0PqGtlKLwql+cTvTKvYobMTo1290dgIF1ypIfwWUwyQy+ABkGc0GI8S5cXDGmZWNc2RiL8A51qXO/yDRUpgZaSmRihFHWeBidGByMLi1hM/sCGUkVIewG1ONsCsZ+Aw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Mar 29, 2026 at 03:52:38AM +0800, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Currently MGLRU and non-MGLRU handle the reclaim statistic and
> writeback handling very differently, especially throttling.
> Basically MGLRU just ignored the throttling part.
> 
> Let's just unify this part, use a helper to deduplicate the code
> so both setups will share the same behavior. Also remove the
> folio_clear_reclaim in isolate_folio which was actively invalidating
> the congestion control. PG_reclaim is now handled by shrink_folio_list,
> keeping it in isolate_folio is not helpful.
> 
> Test using following reproducer using bash:
> 
>   echo "Setup a slow device using dm delay"
>   dd if=/dev/zero of=/var/tmp/backing bs=1M count=2048
>   LOOP=$(losetup --show -f /var/tmp/backing)
>   mkfs.ext4 -q $LOOP
>   echo "0 $(blockdev --getsz $LOOP) delay $LOOP 0 0 $LOOP 0 1000" | \
>       dmsetup create slow_dev
>   mkdir -p /mnt/slow && mount /dev/mapper/slow_dev /mnt/slow
> 
>   echo "Start writeback pressure"
>   sync && echo 3 > /proc/sys/vm/drop_caches
>   mkdir /sys/fs/cgroup/test_wb
>   echo 128M > /sys/fs/cgroup/test_wb/memory.max
>   (echo $BASHPID > /sys/fs/cgroup/test_wb/cgroup.procs && \
>       dd if=/dev/zero of=/mnt/slow/testfile bs=1M count=192)
> 
>   echo "Clean up"
>   echo "0 $(blockdev --getsz $LOOP) error" | dmsetup load slow_dev
>   dmsetup resume slow_dev
>   umount -l /mnt/slow && sync
>   dmsetup remove slow_dev
> 
> Before this commit, `dd` will get OOM killed immediately if
> MGLRU is enabled. Classic LRU is fine.
> 
> After this commit, congestion control is now effective and no more

What do you mean by congestion control here?

> spin on LRU or premature OOM.
> 
> Stress test on other workloads also looking good.
> 
> Suggested-by: Chen Ridong <chenridong@huaweicloud.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>

There is still differences for global and kswapd reclaim in the shrink_node()
like kswapd throttling and congestion state management and throttling. Any plan
to unify them?


