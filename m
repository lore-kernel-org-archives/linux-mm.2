Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFF38C5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 08:43:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDB186B00AC; Thu, 20 Aug 2026 04:43:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB2BB6B00AD; Thu, 20 Aug 2026 04:43:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCABD6B00AE; Thu, 20 Aug 2026 04:43:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A87C66B00AC
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 04:43:39 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 27ABA405CE
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 08:43:39 +0000 (UTC)
X-FDA: 85121009358.18.21900F2
Received: from mta0.migadu.com (out-222.mta0.migadu.com [91.218.175.222])
	by imf25.hostedemail.com (Postfix) with ESMTP id ECA73A0003
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 08:43:36 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XStD9AlN;
	spf=pass (imf25.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.222 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787215417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AF7NzNA2WH4okS/5y3UrfJ31WaERLVHARx6GWkc/ZpA=;
	b=cc6/N4bwABO7iMLTODtnB9ejbEOL7DF99UTVA1ZNOuoRizqHOjpbQ1oxyHZML3a+UP/xdF
	x9C5fcOZHVlkdQaQ59c05QbmFu1PRQQMweMVAJUBBq+65VANwTu1DbnSDUuNxwQ54z2uM6
	DC7aAVQbijQcYkOOY3tLTsY7TQWEj0E=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XStD9AlN;
	spf=pass (imf25.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.222 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787215417;
	b=s7eaQdskRDDbxBPzJrbj+0OFzRntIru5Umhh72Lj0csGxLrMExIJrfx8r7anAgmJnIua40
	l90ey7uovaD1OqO5CenFHThHz2jD+5SqJq2JbSNrTQzWX6B3l2s96ISYcpScxIckRgH5F5
	YoJ4uxlXG0EDclk8Ff5eh0VIb94wyC4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=yTjYhvKkMHDo9qLLabTyUV3J3cL/wvyOOWOBN5nhYWo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787215415; v=1; x=1787820215;
 b=XStD9AlN2vwxKH/blq7pNCqOEL8amlojWvPjAb3wCg/FZCrQhmsbmF9XlBqxSgj3hMe4pvOV
 PV3CVYNKEHMWJ8TsH4YheOf+VYIy8LtftbzPMevvEFDnE3/8E8g8omazPcXCdJwNacF/hGE5hn6
 S9hgxjwprJI0uMlEmYsjy6uQ=
X-Envelope-To: linux-mm@kvack.org
Received: from [10.63.107.123] (14.29.108.92)
	by smtp.migadu.com with ESMTPS id 50b587144d94fa93;
	Thu, 20 Aug 2026 08:43:35 +0000
X-Mizu-Trace-ID: 50b587144d94fa93
X-Migadu-Flow: FLOW_OUT
Message-ID: <ee4cd3ab-0708-4c37-b597-703a7d7547e2@linux.dev>
Date: Thu, 20 Aug 2026 16:43:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/2] mm, memcg: fix memory.peak reset clobbering other
 fds' watermark
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>, David Finkel <davidf@vimeo.com>,
 Tejun Heo <tj@kernel.org>,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <cgroups@vger.kernel.org>,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <linux-mm@kvack.org>, linux-kernel@vger.kernel.org,
 Tao Cui <cuitao@kylinos.cn>, Ridong Chen <chenridong@xiaomi.com>
References: <20260814033005.2481920-1-ridong.chen@linux.dev>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260814033005.2481920-1-ridong.chen@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: ECA73A0003
X-Stat-Signature: haiagcf5crntrh6pj9oh64j784gfcpj6
X-Rspam-User: 
X-HE-Tag: 1787215416-494962
X-HE-Meta: U2FsdGVkX18fm4d83faKbFi1/YGGlwsThi8fi2wh/r2NM1zoJX73pIECIQ//Trh8nkcBXNx0zYNh32th++s935xx58oUrKxSMyY+KLdfjV5hFg0wPf8tleDqbIbQodIoEBr6lTgOEjMj86Ut6gVhK7WJbgwzuhQhDC1PTNabkMqsYebOyO7O3OuZgNP7c1Xm8iKHXv4AFvb9nS0hntn2gkbZFmcym4TgLyoYrrefi6Z6RE9GVhKJGDsizRjmPEIsNxGZs5oSxN3u/D1xVt3OOHiOBg+hSelcZ+kI2DzU9k3Ze+FvsOvdQNp6TPCy8Vni25yhPRJDJnon2MSlZebdx12n78/tRdmoBHYk5brR6bSQP1Rfn/pJ6Em2BRORDjWSxnCSrDicQcsGRqcFxhCKf1M7ucivyPa0tCKwbKjzHPvHF7EQgsSbEKloFQRBr+I0dx5e9LJt9kpAsuriyQcNkUSbhVDVGMgS9oFNRKgxk1f1dwQT1h/z80R8kKZb7+ISjfDu6WzRawWh4ndxlz1VYVsD+UOInOpYsVY6+8N3Jl2YZyhOhZt0xwDtvwXt1Ms2MtPtZHsesbq/fPnFZwT8cXn+V/US9c081cQ8zaXJaJ+Cc256ZY9Gx+4gmS4T8xmfsND1HWDsKc94pyzeYRlJev1M1OrOn4dqe0but2r8DezqpP1khDmsIfe+KRfeEeySHncrZMMFeVH6hXzPtQTw/fe1/jLffpxerjUZ46BCdbwAex3ILllGFSq0/NqreMiWv4MF45+VFbwvEqttKf22iP5i6SEqRsI3R1ITLYKhyUmgIiT00nFN+6Qx3HKFN5qL3whEbfyZ5mf5meQzU222e3xmVOqJh6mwj1hpkhBgqUfg/SVBTpHewEXahr12/7GCMOb61PxEL/Jn9P/MUtWN9mY6Fd+DSEYI9W5OfvA5W/82I+L/lWDO5wmzpOnzMReVr71Ia+5dLdljQF+cWIM
 K8FuCY8u
 i0fRXSkviZ0yBXpznJUM9kFM3W6+l7Rx4PuKDpD95Opc21Lg17o5TECDVs0OUcPNvg9XFIXumdj8QfVmjF8bEx8qes4GitFxIDZ8He8N/DNegO4FPHpVTzgHegJpfGAyOnU34sTTuejA209xRilqFxLb7+WpU3uTT9TAzJQHMxX7+8Fw8tI2nhpU+klpN+07BX9yq38Glr0/+zZMZU4p5cxv6XNEMA9RxJw/j/GViG+7lO9Cawk1f7rvSxiSOGR9sv5gNPOBRXQt1C0T/izV+tSv1d5RWtz5+0Jqx1bfwgDlI/IG5LJSbfM6cw1LSLRoWkv3ia+aFsGZz7r9lBr31R1ciIr4ItyEBIgDbHhFMxO+JOFxVNbxcaQZCjVUdknLJ++qE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/14/2026 11:30 AM, Ridong Chen wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> The memory.peak / memory.swap.peak per-fd watermark tracking has two
> issues. Each open fd is a watcher and reads back max(its own value, the
> shared local_watermark); both bugs live in that scheme.
> 
> Worst case for both is the same and is userspace-visible: a reader of
> memory.peak (or memory.swap.peak) gets a value lower than the true peak,
> so a tool that sizes or bills a cgroup by its peak usage under-reports it.
> 
> Patch 1 (read side) fixes the race Sashiko pointed out in the v1 review
> [1]: peak_show() inspects local_watermark and the per-fd values without
> holding peaks_lock, so a reader that races an unrelated peak_write()
> reset briefly observes the lowered value. Transient. It takes peaks_lock
> in the show path.
> 
> Patch 2 (write side) fixes peak_write(): on a reset it stores the
> current usage into the other watchers instead of the old watermark, so
> once usage has dropped from a peak a reset on one fd drags every other
> fd's peak down too, even fds that never reset.
> 
> ---
> Changes since v3:
> - Switch to guard(spinlock) in the peak readers, suggested by Muchun.
> 
> Changes since v2:
> - Spell out the worst-case userspace-visible effect, per Andrew's
>    Go back to v1 [2].
> 
> Changes since v1:
>   - New patch 1: hold peaks_lock in the peak readers (Sashiko).
>   - Patch 2: floor the peers with max(usage, local_watermark), mirroring
>     peak_show(), and skip the writing fd (Johannes Weiner).
> 
> [1] https://sashiko.dev/#/patchset/20260730115314.1069089-1-ridong.chen@linux.dev?part=1
> [2] https://lore.kernel.org/all/20260730115314.1069089-1-ridong.chen@linux.dev/
> 
> Ridong Chen (2):
>    memcg: acquire peaks_lock when reading memory.peak
>    mm, memcg: fix memory.peak reset clobbering other fds' watermark
> 
>   mm/memcontrol.c | 9 ++++++---
>   1 file changed, 6 insertions(+), 3 deletions(-)
> 

Hi all,

Just a quick reminder on this series, could it be applied?
Sending this note in case it got buried.

-- 
Best regards
Ridong


