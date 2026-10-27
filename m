Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1CD7606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 01:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=SV0l+GzY
Received: by kanga.kvack.org (Postfix)
	id 1BC916B05B0; Mon, 26 Oct 2026 21:29:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16D266B05B1; Mon, 26 Oct 2026 21:29:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0ACEA6B05B2; Mon, 26 Oct 2026 21:29:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DCF136B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 21:29:04 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 78B64160921
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 01:29:04 +0000 (UTC)
X-FDA: 85366672608.13.A4415F5
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4F0C98000C
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 01:29:00 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=SV0l+GzY;
	spf=pass (imf30.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793064542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M4FSiPobiKPDMcBSbXnngYDEQnQ7VynA6dCDLEbFYos=;
	b=ZQ8ikh9yTCtl27BbMQl1EfVP1B/PIFQRQrUURSyYQ/avhpCaf671CkgF21K9tPcl81Wc/o
	kwiDSN0uET6EyltG18yCB4iEztCOGJ/ZIlMX+4paV0PRBqGAVEymUPWME3mS4daJleXSzr
	mSn8DoTKSG/o/o9hxIMKrGN6ZNnR6a4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=SV0l+GzY;
	spf=pass (imf30.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793064542;
	b=sE4lotCH8xSsZBE+2+xcVWrNuqYgEO3gGgZlaMOjj+biMdgIW6lsTuA+ILY8XTnRv87wBZ
	X0n4EZfFOvAgut2OxhngyVbBFfufjmttX1G8ZF98vZxZDdXK+QYpcFpdqlm0FfCnWMSRCb
	YMhdAdLIGMv9kBbxCdR0GMMiKlNVlEI=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793064537; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=M4FSiPobiKPDMcBSbXnngYDEQnQ7VynA6dCDLEbFYos=;
	b=SV0l+GzYAhUQ6KGraGu0dmx5nVnTnOStQi0F5o0Hd52llTzPrJt+2OHDGvoUcxC5LhjxrzInkSI2qI2OAIDIng4g9CjuhwBUWcXEC775ZSnTfYVgi1FqgSdeFlgUq0fltxuSbIIGd9wWHn/AZSLficYk1Dflt3IWEjq4yPiP1ac=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R571e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0XDc0mdt_1793064535;
Received: from 30.74.144.191(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XDc0mdt_1793064535 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 27 Oct 2026 09:28:56 +0800
Message-ID: <7346ff85-4941-45ea-951c-322c385704f0@linux.alibaba.com>
Date: Tue, 27 Oct 2026 09:28:55 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: Make swapoff interruptible when unusing mms/shmem
To: Chris Down <chris@chrisdown.name>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Vineeth Pillai <vineeth@bitbyteword.org>, Hugh Dickins
 <hughd@google.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
 Youngjun Park <youngjun.park@lge.com>,
 Ying Huang <huang.ying.caritas@gmail.com>,
 Kelley Nielsen <kelleynnn@gmail.com>,
 "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com, stable@vger.kernel.org
References: <ar2YlFYjYUZ49ZA5@chrisdown.name>
 <at9kJwdGkHPsWwgG@chrisdown.name>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <at9kJwdGkHPsWwgG@chrisdown.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4F0C98000C
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: if6dnhh7w3rkgheuo3ecb7m6mstofc43
X-HE-Tag: 1793064540-602864
X-HE-Meta: U2FsdGVkX1/tCVQY7Qcl24laHctRqKSi2Um+c6YJ2az5Q8rRPO14LF32KDLEavs8+Xy/AtfX34iGhoZuWMPr71AOowUQ56HAFOUhpjvI2smXvrlLIDgLYXG6V81LoB5mCVU0qfixqhT66+6hWYj9gFZAexwubncmBIKt8jIP8nPAmnkt4+bhAY+yzhT0xu8vcFHErUWQ/qBR7QSIEtmU6RkCSuHgUOgMDhkuBm6tXxQYuqOwakRg0cckoZFDAvHVe7mFYqfE2M4GhDhwsB3i/m/rieHvst5BqmfULciEVX4xcUNzwhHFE7K1wX6a1VoSFbPelW28r/dTLWblX2EWvqyR4LGZIp/X6fADLTgu7Z3sZOWuOySIwMw039e4Op/BaXOKu+N8JXSQnuz5GL1GyV6hEGRScrhkv9w8UJ1NurCabSl5ULvpRaPlGFjbhHTTG/fMQB791PbSvVKYt7afMz94fJE/8DeAmwVInJtso9qm0Y0QNh5kxj0It4n4rKTgOWiCCWHdGL6XUxJ7pdv1rDdv86uKKxRUOb1xivzdJu6Zid6sponeSVR3jDn6I9TPHEvy0cYbxCqo0nEziMXCrRGR7ZJatDQ7evBTRKp1xbfmP01TG5g99qwue2fN1bFM3yxdP3CM8QplHQ7oR8KuuaSmouOD4a6bPuvDgvcjOdl75CqHYXoE9FDw7vd3TxMOh1QtNkrTG5qobm67PMdvrSKmWl/Y6iWoW3c/GvmdcVsAE0/118wSSDdn1xoD0mqVKe2bRvrdtE6JIu9MJhn64f+KrSkgtV6wTLH/mRoGdtyE5XOfLRQJ+MRzT6rGhTftvYBcaTHX2vw584zGJ0emcvNfDkgJ9gB08OCvQmyGmeE+KF2SxQQSuKWXl72O0yv2Rm7hHtcZMX2u4fwp3/PCiqPB1qo2sSgYyCkRHj8egM1sfWzZwmNsK7M/bqxrr7FFMh82t96C6p5v8aGjWo6
 3Z3utjAK
 LHsH7l00SjTvgstfFgBmRk2p0ejaBENf7NHvhdE6d8BAWJ93F1U+nu2kjmsuUsfndmQ9Q0ARBd3VJrcVUZhK4IHU+DbTND9YbJjhNlmCYdJfOrzteButhcmzaDgZenkBuOvffioRR1yo1G04FrcP3O45WPjjqDZvQnPlayzfzBCSgc3SCah7uM5UrFhpsKd9TBzXur1kEQaBAill6LSnJ44OknOAbHrEM4N1wL0rsa6X33ad/8yZyR93VOJPFKWiV+Qml+2DTswG4B4iU2ozcu5zkjBYDJVYcExmzcoizmrygnYneK1THNFaQjGIBkK0DF59ezYkRWUQk2u1H6vaxxJu7QASkaYdjkzcF71txxkmNvsVWdyakrWrmWRomiVXlIow4FjfkLvtC2oncXroiRsh3GFBTPaL/xayzvngYxiOOIjvfpDwamEfIMZ7990CMBLIruuCAjqqs/2A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/26/26 10:31 PM, Chris Down wrote:
> try_to_unuse() only checks for a pending signal between mms, and
> shmem_unuse() doesn't check at all. That means that once swapoff gets to
> a process or a shmem file with a lot swapped out, nothing can interrupt
> it until every last page of it has been read back in.
> 
> Just as one example of where this can concretely show up, freezing tasks
> for suspend or hibernation has to wait for swapoff to notice the
> freezer's fake signal, and gives up after freeze_timeout_msecs (20
> seconds by default).
> 
> Here's a facetious example where one swaps out 2GiB of one process to a
> swap file on ext4, starts swapoff, and half a second later tries to
> freeze with pm_test=freezer. Writing to /sys/power/state then fails with
> EBUSY and this in dmesg:
> 
>      Freezing user space processes failed after 20.003 seconds (1 tasks refusing to freeze, wq_busy=0):
>      task:swapoff         state:D stack:0     pid:3175  tgid:3175  ppid:2955   task_flags:0x400100 flags:0x00000419
>      Call trace:
>       [...]
>       io_schedule+0x44/0x70
>       folio_wait_bit_common+0x1ec/0x3d0
>       __folio_lock+0x24/0x40
>       unuse_pte_range+0x2d0/0x348
>       unuse_vma+0x158/0x248
>       unuse_mm+0xfc/0x150
>       try_to_unuse+0x104/0x3f8
>       __do_sys_swapoff+0x220/0x5d8
>       [...]
> 
> The same goes for anything else that wants swapoff to stop, like an
> admin hitting ^C in a panic, of course.
> 
> Prior to commit b56a2d8af914 ("mm: rid swapoff of quadratic complexity")
> try_to_unuse() was driven by find_next_to_unuse() which checks for a
> signal before every entry, so let's restore that behaviour.
> 
> Just as an example of the improvements, here's how long freezing takes
> in the same test while swapoff is happening on my computer:
> 
>                        before                  after
>      400MiB anon       8.925s                  0.028s
>      400MiB shmem      1.639s                  0.003s
>      2GiB anon         failed after 20.003s    0.011s
> 
> Fixes: b56a2d8af914 ("mm: rid swapoff of quadratic complexity")
> Cc: stable@vger.kernel.org
> Acked-by: Vineeth Pillai (Google) <vineeth@bitbyteword.org>
> Signed-off-by: Chris Down <chris@chrisdown.name>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

