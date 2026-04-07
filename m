Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C75DFB519C
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 06:27:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3825F6B0088; Tue,  7 Apr 2026 02:27:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 359C56B0089; Tue,  7 Apr 2026 02:27:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 297496B008A; Tue,  7 Apr 2026 02:27:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1C3C26B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 02:27:20 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C87441B87C2
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 06:27:19 +0000 (UTC)
X-FDA: 84630777798.23.0E5BEAF
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf05.hostedemail.com (Postfix) with ESMTP id A518110000B
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 06:27:17 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=EqT4AlXg;
	spf=pass (imf05.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775543238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jRgffIbQ3Wm7XMbVgBeY8Y4whueyqSiXwa6QomzKNFI=;
	b=KURvcPXAa861VRhGVoYr3Z31Mr0FxFyrXDok54/Mg4+9cMo5iySNo/5Kv5UnT2M7q86pn9
	s2iMGnWZqol7wxVIfmPxjwV5QACwE4CMC8RV+M7nAX4bLdPPgAMlsnDdUo0pNG5oLKY0WG
	0o8chrEr+u48M62MJavluFrhgYwqZBs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=EqT4AlXg;
	spf=pass (imf05.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775543238; a=rsa-sha256;
	cv=none;
	b=I6pbrsdWSMVdyaKrGrPO/ilmUApKk0WSBas7wlv4ZIWfD8vsIY9LHiAVRD98pqTrRjq7zm
	x572Pv/R3r60qF4Fqm4eAG44SrT/C6tK3tKEsXfnY8HPyqR7CAYXMQVYUngwbK/y8Znc46
	w05iPWrVCvxXDfNt2MoDLi8rTUEkcH0=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775543234; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=jRgffIbQ3Wm7XMbVgBeY8Y4whueyqSiXwa6QomzKNFI=;
	b=EqT4AlXgvWuPgPPxEET5MGuMyg/HwRSjfIyopKfw2N/GC6cs48UMsmSiQJ3PU5BGZjxwx9fokkXXN7+4SRal/eCoMfryn7IzBz29tfoO3q5GpHSZ9h32wurEY+T8fiMA5Pn2Rvu4k0auWqDl7IxB/+udj42fahDXz6XpBMigyQs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R581e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=25;SR=0;TI=SMTPD_---0X0atlpk_1775543232;
Received: from 30.74.144.138(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X0atlpk_1775543232 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 07 Apr 2026 14:27:12 +0800
Message-ID: <f27f59a7-cdb2-4b91-8cfa-b4ec7686ba12@linux.alibaba.com>
Date: Tue, 7 Apr 2026 14:27:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 14/14] mm/vmscan: unify writeback reclaim statistic and
 throttling
To: kasong@tencent.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>,
 Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>,
 Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>,
 Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>,
 Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>,
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org,
 Qi Zheng <qi.zheng@linux.dev>
References: <20260403-mglru-reclaim-v3-0-a285efd6ff91@tencent.com>
 <20260403-mglru-reclaim-v3-14-a285efd6ff91@tencent.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260403-mglru-reclaim-v3-14-a285efd6ff91@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A518110000B
X-Stat-Signature: uft7r8zudsjr9kf8xtfzmmu6grzyi799
X-Rspamd-Server: rspam06
X-HE-Tag: 1775543237-676244
X-HE-Meta: U2FsdGVkX19K+jUtiEJOFtiAGQYYyC9VG3S/rieboTwvC4bNeSpapOvbyVYhYT7cAVzixqMLewG2zXvvl2t9PBYg2VsNuOBJL1dDGWjnnaNWu/SqQOG9+2j3hwZN6crvUTT0zAUi6F3qeEwlD221v91wPAkoHa0e6vDqfMU1xTSOB+HgwlGJVFOfbz5neymdgpuLI/yX3Nn6iLgPJa2KnBtfMVFd7MQv1dcllasTPshQPRWOF8WFRjPTNXW/xr/w3EnFjoL27wi3LDceoeR5OPuQMcgCuX+2cK14E8/HDfcZd+ohWREmXzcFAtZxaxiOQXKu10yDBes5mNo6URnkQXDVHQ13zeMTuUFinl4YF1bI2hOzQOsvNV6FLyJw6TPa2WMpUuXyr32L+xqMlQTTafAuWuP6VIbhZI+ellPn1iZOmewRxQt85AzXCwc4CuWTHL6nDEAIMbNXiJPkicyKS/Wfn5G6W8siTPat8WbdIqx0RDXwDeMVDYpsrD9Pn+5AjWHULVZRLspMN5QRtDLyGWF4LL3cbOouVgHfQa/1fHxkDV7V6AG3oSOLQm5i6BTKKbs0y2DoDcSBLeNOI4d92fqf2jBu2smaQJL0gNeFU6M8R69tDE70m/kkDK41d/biWamTsndpt/l0X2nq1WNPAhnbxWaeoO4kcEkiYiVPSexVo98NL5Amn9bKdvV2gInFHmdLV+1a+LAf1uiHnN89CL+dzr16QAS9vGUOqyWyCLj2omM/HkOMHActWDzRZt2UDFRa9o3xVoUSPfnYySb59WRCi947ivWiZvZgbIPvVhk3THk4ANZKIATZSU4ENnt4LW5spZ5dEW+giovL8sAAFQYX8q89YfXdN1S5mVN6CRVVSDTAmWOCy9yfznyZIQ21IZ+jP27BJ/mqMpL21lyfCuDxWO9HvNhg4ZMuteo7RNYNcglrXzlaItZrunkqW7mG6FUSUpJkiorkyf0P3pJ
 rrR87qlR
 f5Z4g4AdMYPIsqmCH1UE+IVmyliSCsn+0fysqmfYvHvuv/SRsY4K7mmj7LItcq0KeBxN6Xn/QY5n0Qh27VeR9Kz5nxGL+yxx7XU9OJEjYKrcLORvPXqYyq3rPRuKTi0M+utGoW57Jrw/5CvS7EdcKXHpYOXMr6JWj0TfrIMOQ7aH5pv8HansxLQBxY7G7a+zRMAZ8SUmaXWG1EAVMzpa3CQGX3Fx0xv9/iHwHJ/OGIDugEp2Vw37vEhpCNtI+wOMNj+QHk0Le/Lj7BikubtxDPtZVqVv432WW+XBqTnJXIe2ZWQ8XWm3m0Q7byR9vTLIMk7/0f3QfO+AnxlidKeXmJV9I7RpcY1rYTTtkB/YDILqtTkPMrAl0Lqm3BJKv6UQHjBDlWNMM4gzD6WSKYEvBC10p+7wkUHWK/m/4b362bjvp8E8bYoz2yj2U/7x9ousvBjT2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/3/26 2:53 AM, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Currently MGLRU and non-MGLRU handle the reclaim statistic and
> writeback handling very differently, especially throttling.
> Basically MGLRU just ignored the throttling part.
> 
> Let's just unify this part, use a helper to deduplicate the code
> so both setups will share the same behavior.
> 
> Test using following reproducer using bash:
> 
>    echo "Setup a slow device using dm delay"
>    dd if=/dev/zero of=/var/tmp/backing bs=1M count=2048
>    LOOP=$(losetup --show -f /var/tmp/backing)
>    mkfs.ext4 -q $LOOP
>    echo "0 $(blockdev --getsz $LOOP) delay $LOOP 0 0 $LOOP 0 1000" | \
>        dmsetup create slow_dev
>    mkdir -p /mnt/slow && mount /dev/mapper/slow_dev /mnt/slow
> 
>    echo "Start writeback pressure"
>    sync && echo 3 > /proc/sys/vm/drop_caches
>    mkdir /sys/fs/cgroup/test_wb
>    echo 128M > /sys/fs/cgroup/test_wb/memory.max
>    (echo $BASHPID > /sys/fs/cgroup/test_wb/cgroup.procs && \
>        dd if=/dev/zero of=/mnt/slow/testfile bs=1M count=192)
> 
>    echo "Clean up"
>    echo "0 $(blockdev --getsz $LOOP) error" | dmsetup load slow_dev
>    dmsetup resume slow_dev
>    umount -l /mnt/slow && sync
>    dmsetup remove slow_dev
> 
> Before this commit, `dd` will get OOM killed immediately if
> MGLRU is enabled. Classic LRU is fine.
> 
> After this commit, throttling is now effective and no more spin on
> LRU or premature OOM. Stress test on other workloads also looking good.
> 
> Global throttling is not here yet, we will fix that separately later.
> 
> Suggested-by: Chen Ridong <chenridong@huaweicloud.com>
> Tested-by: Leno Hou <lenohou@gmail.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

