Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89193FF885D
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 23:43:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AEDE6B0005; Sun, 26 Apr 2026 19:43:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75FA26B0088; Sun, 26 Apr 2026 19:43:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64F756B008A; Sun, 26 Apr 2026 19:43:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 51DCF6B0005
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 19:43:20 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A33E8C1A0C
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 23:43:19 +0000 (UTC)
X-FDA: 84702335718.01.6B884CC
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf17.hostedemail.com (Postfix) with ESMTP id BCEF740007
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 23:43:17 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cF64z5Z+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777246997; a=rsa-sha256;
	cv=none;
	b=6Z5+Wd1rqFfLF4D6ErIfuSDVZhAiX4Renvmg03Lzy/7SGIbcqpv+0MrKRyGz2xsBfdSOny
	qldMqzWEnSg52Ug77XzR0M0f7aUaztDQ+3Hs3xF2slPL3bKKvDQ4jQ2yXvsUCu+0Q08e2G
	HG3AQP/3k+GfLhboFx9vdj3abU++G0E=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cF64z5Z+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777246997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GMcuATLy/ginolpQIDJCxy12h57szRVGfrxwU4MqXGI=;
	b=mwWzRBl8jrGZEySSYqI/wamQiL8yI0rbTDkWGua2SQFZ6f59wA6eWEcO/A8p+eA6l95DQ8
	8dtaLcjKDkkjTu1AbCOopkgOZBFOoaknt04pqrMbLEzcaqf1Q3rb9KckmyaYi1qWajgTfB
	YWvODqEe0qxEd0Rw27VC1l6wFekqUbM=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3567e2b4159so6453904a91.0
        for <linux-mm@kvack.org>; Sun, 26 Apr 2026 16:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777246997; x=1777851797; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GMcuATLy/ginolpQIDJCxy12h57szRVGfrxwU4MqXGI=;
        b=cF64z5Z+NyiCtU5LNGSyWc+9o2VdWUYo0JrFV917SxBR0uqRzng12IKh3ji+LkDU3Y
         ck6FE45QjzwZMGXjso6cj2s30Cjaauq6CwKTI78TFjSfnrs5fhhDaIWHIJseLR58IuAR
         OR34SAQ937303yQqKz6hmfCSvODgWhcNUTHlxclo0Uit9+iTDx8UbDj4QUz25qDbT1+b
         xZtVroLHN2q2pe7s9aAc9OBmeA91i0tkFWaOmB29LJt8DqbmTNcEE2DYAPzDyptU9CZL
         lZ8TlRSI78B4nI9SlzZ2mFu9DGAKbISpBlJVke4z1cdxF8WnOaM1ejLIb2PfGYhSZA0M
         nl3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777246997; x=1777851797;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=GMcuATLy/ginolpQIDJCxy12h57szRVGfrxwU4MqXGI=;
        b=NzDdeqEFfMJ/O+Do0U7ZwyiqF7KYT/ghbONcVkKE/Dq+AyLBJHPIONXmSRM0XQsQvt
         qGCEj4uL7Y8eFxh89xg5zAiIFrzxqWdQ6zJO/ENXH+aJ8wehX9ipYa7PI3+sppPhDHvY
         UR9Y9yMNxCA5+/QbT/JDI6wmfhL5W94dFsVBzjtOKNk1Ofjob+iAwodXj3m2trL7x/5s
         3GMGwz6kZQSLV6Kt+qXidRuv/Y1ndH6ndXbL2REpCgDR654PExJhCc0ZpvySLg1pMNWZ
         OPcJhPcukzg2NH3CjW28dTUjMGVzH553U9FieknROhL1yBpq5limUz0JDoXnVV4uKTD+
         snRg==
X-Forwarded-Encrypted: i=1; AFNElJ/xc1+SvCkQJHoTpuevAC73BBfcQdbn+WvGo3lDaCW1hHEF2blQh/2tSxEEebMQwyXFSXtO8lyLjg==@kvack.org
X-Gm-Message-State: AOJu0YweRvcgrlR+6mOynNbsCjmJjbyycN+KMJStiYrrTfPIVcZPtH2G
	0I3uu5xoOW6oyzOAOnBg4jvRPK0M8pRDvm1l4Dj87TFTVmet/ysDBaPA
X-Gm-Gg: AeBDievUb9srJXWrUfQMJNyUfCg4BdqNSxDtkU0WFAmRdcB1LGmetBKympdoCbzD+Ch
	M5dRa/0rX9gX8zih0PSYxmoc1MwpOM35APpT3y0uisJA0/zJbudrLJPlDvTAAZOGm+b8YmLn9q4
	KbHv0Uc/h6RpyImVF/9Jkuk/fMr0PHr7a1t5Vl2fKgOm3CibOzZdScRadCumZ+DtfmMGtCi5gq5
	FAvA766LYoJuhMMd2rjEEaURSPV7Q1POFwyCp9sSDdHiTkVtC4BKgbdC/KmrZQjIUlBhGA90x7B
	1yUmzPHWRQOfteHbe3spvHtlPsjMB4qNTSOmpjbaYlUZSSLSEzMrBiiW/yqO1EgM9Hja7pYG/Ee
	cQ0OJ9lUlay8cootzqEh2YNzjB78gymrC+OVng7NlLzlgKTV+AfxdDvak45hfR1K8Oc4eYepEyu
	8qSkZ5Yf2Fc2A8ATpOthalozWyCBVXXhw7
X-Received: by 2002:a17:90b:5845:b0:35f:c46f:2b0 with SMTP id 98e67ed59e1d1-36140473f70mr42914414a91.14.1777246996503;
        Sun, 26 Apr 2026 16:43:16 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-362b9a79176sm17396721a91.5.2026.04.26.16.43.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 16:43:15 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Jeff Layton <jlayton@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Mike Snitzer <snitzer@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	Christoph Hellwig <hch@infradead.org>, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Chuck Lever <chuck.lever@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>
Subject: Re: [PATCH v3 2/4] mm: kick writeback flusher for IOCB_DONTCACHE with targeted dirty tracking
In-Reply-To: <20260426-dontcache-v3-2-79eb37da9547@kernel.org>
Date: Mon, 27 Apr 2026 04:01:15 +0530
Message-ID: <qzo1s6a4.ritesh.list@gmail.com>
References: <20260426-dontcache-v3-0-79eb37da9547@kernel.org> <20260426-dontcache-v3-2-79eb37da9547@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: k3nje1qf8ggkckefbhbkfrgmmmm5s53a
X-Rspam-User: 
X-Rspamd-Queue-Id: BCEF740007
X-Rspamd-Server: rspam07
X-HE-Tag: 1777246997-838254
X-HE-Meta: U2FsdGVkX1+Hf2J82tdpEYPdxtGY/KnNiB2+0TUKZXGya3xZ9YjB+jv9I2QN0DAvSI3Q7LCQGbl0rRtEx9+HbJaTNvJ5fLqmI7pOnaxXOv8Uwb+7UortNOqHGdFrMWkZRbihGXIylFFG693SqjbkRFa7l76YB6FQWB54cB5gJSkslAVR4NFMv6Gb18KJu5GPalyGyFEEHnVPP0xDQtNoZW1FLUJdFwY1ZGADxiH7/oOJK1kArriWnDCzsQuUGDaGG3f4Cgo9ZLNlZ/78d1sn/+6XSOs0wFBBFZirbJjd6dr/PJxpDjpXZ7gFAvpvRl8wNmcw3nVv8thCqMhgFKxfwgXMXwYnmX+0zv0wVS7beDHINqjSLKtHeL6sKRbji04Gv5okbdx4dxPSMeOiGnq3JNn8gqIloiixwfBQzWxSIfKDGkwdQVsm3A4JrvQx/JM33QCtaGkMv78m/XUklN1nmULVGzsqWq6gPiYvZ0hUmabPJeK4JPcOcnsxFcrQfACP0fk808jP/KMlJKke4Nech11gumf2P97aBZIGUpW8CLPbrEgmT7uSKOO+hJYHJdNlXSdL+lRRGEWH2QjuCus99twaDGzr459sCpV2X3XuxW4nvuYMYsarRGkq9KufFHLmXg4HfFRKt+QhYv/pxAirq4O+sXxAVNpILS+qb/UXisITotiu8IWGSyppRBmiAIQb1TtKmNUbGHZq0qkw3CTy3svsEFoDVxZNLptuNh19Jk85YUdtJ1PHjl2YWNrDrEZyg46aaKmFWjKiJvu1j/cVFxkN0mQk+OHdtv81Fn35x9jKKg9uWAOACj+qro44jvEzCv8swaPpkjuS3B9W2auYj4dJ2f7+wEqX1hl0cQFjx/bdzUWZ1DpsFHRMAyWDc96EzP/ReumLYx4WqmkOt0p760CjtIPGAS06v85+uaf5Zjw1ePMUShLacK4nxMKGK5tH8KHOOzk6Xr/Q8A5JWqk
 Y7AhZw54
 VGuV5/U7oGoSEmg7OJFl8Co1QhTzhgllPwaEB0eWlGebMjDXWdv2w28zZV2QbhHyRG8hKyGzaiTjKTE6qLMbmCTXuEPJQH1dEo4O6zcdVo17NLFW69JWrHAqnGXI25GJKkZzPekeu8QznTOWTm40Skd0nyk6BSJYRh1HJpuLl/PSFxlsz0kMZrJE+yOkofXgALlBULF4wbW01lpQV916UlenkYP6pAfRgNNjzrKHlsEXX4VZEpvbT2US6XTpEnw9+aRJSmWX/Z4i6UjVqzdjPFTmPJxLh+dTFsQ5RXg9F1iwryNZEWM4WHteGSge+Fx8m3T3j/F002AoTuA98DYJ5djP1uvwd633ToYiQf6uqkIhl2+ylf+v5x+D5Tuqn1mhjF/AOMaNjzg471cfmtulxqdVHnYCoZl/Wa5px/7ottWiZrVhrvaW+HUn1ysOhDCOeM64+rTn7Lf6Vun20MurmnTfMzyzhQCuAY63DgZ3jnf7uGC6Rx4yDEZHwGANHc5PTeTzM0SLtethVEZOey7RLvevmeEx0T6YNKRbe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Jeff Layton <jlayton@kernel.org> writes:

> The IOCB_DONTCACHE writeback path in generic_write_sync() calls
> filemap_flush_range() on every write, submitting writeback inline in
> the writer's context.  Perf lock contention profiling shows the
> performance problem is not lock contention but the writeback submission
> work itself =E2=80=94 walking the page tree and submitting I/O blocks the=
 writer
> for milliseconds, inflating p99.9 latency from 23ms (buffered) to 93ms
> (dontcache).
>
> Replace the inline filemap_flush_range() call with a flusher kick that
> drains dirty pages in the background.  This moves writeback submission
> completely off the writer's hot path.
>
> To avoid flushing unrelated buffered dirty data, add a dedicated
> WB_start_dontcache bit and wb_check_start_dontcache() handler that uses
> the new NR_DONTCACHE_DIRTY counter to determine how many pages to write
> back.  The flusher writes back that many pages from the oldest dirty
> inodes (not restricted to dontcache-specific inodes). This helps
> preserve I/O batching while limiting the scope of expedited writeback.
>

Yup, so, we wakeup the writeback flusher, which will write those many
"number" of dirty pages. Those dirty pages written by writeback, can be
of any type though, can be DONTCACHE or normal (non-dontcache) dirty
pages. IIUC, writeback doesn't distinguish between them while writing.


IMO, what we could also include in the commit msg is why is this above
approach taken? IIUC, that is because, by writing NR_DONTCACHE_DIRTY
pages, it still reduces the page cache pressure and still reduces the
amount of work that the reclaim has to do, even though some of those
pages maybe non-dontcache pages, in case if there was a parallel
buffered write in the system.


Also should the following change be documented somewhere? Like in Man
page maybe? i.e.
Earlier RWF_DONTCACHE writes made sure that those dirty pages are
immediately submitted for writeback and completion would release those
pages. But now, in certain cases when there is a mixed buffered write in
the system, those dontcache dirty pages might be written back after a
delay (whenever the next time writeback kicks in).
However for RWF_DONTCACHE reads, it should not affect anything.

> Like WB_start_all, the WB_start_dontcache bit coalesces multiple
> DONTCACHE writes into a single flusher wakeup without per-write
> allocations.
>
> Also add WB_REASON_DONTCACHE as a new writeback reason for tracing
> visibility, and target the correct cgroup writeback domain via
> unlocked_inode_to_wb_begin().
>
> dontcache-bench results on dual-socket Xeon Gold 6138 (80 CPUs, 256 GB
> RAM, Samsung MZ1LB1T9HALS 1.7 TB NVMe, local XFS, io_uring, file size
> ~503 GB, compared to a v6.19-ish baseline):
>

Can we please also test parallel buffered writes and dontcache writes?=20
Since this patch series definitely affects that.

BTW - adding these numbers in the commit msg itself is much helpful.

>   Single-client sequential write (MB/s):
>                        baseline    patched     change
>   buffered              1449.8     1440.1      -0.7%
>   dontcache             1347.9     1461.5      +8.4%
>   direct                1450.0     1440.1      -0.7%
>
>   Single-client sequential write latency (us):
>                        baseline    patched     change
>   dontcache p50         3031.0    10551.3    +248.1%
>   dontcache p99        74973.2    21626.9     -71.2%
>   dontcache p99.9      85459.0    23199.7     -72.9%
>
>   Single-client random write (MB/s):
>                        baseline    patched     change
>   dontcache              284.2      295.4      +3.9%
>
>   Single-client random write p99.9 latency (us):
>                        baseline    patched     change
>   dontcache             2277.4      872.4     -61.7%
>
>   Multi-writer aggregate throughput (MB/s):

Can you please help describe this test scenario if possible.. In above
you mentioned we are writing file_size as 2x RAM_SIZE. But your
multi-client tests says something else..

local num_clients=3D4
+	mem_kb=3D$(awk '/MemTotal/ {print $2}' /proc/meminfo)
+	client_size=3D"$(( mem_kb / 1024 / num_clients ))M"

Also the multi-writer case is spawning parallel fio jobs, and then
parsing and aggregating the bandwidth results instead of using fio to
spawn multiple parallel threads... which is ok, but a bit wierd.
Why not let fio do the aggregate bandwidth, and latency calculation
instead?

>                        baseline    patched     change
>   buffered              1619.5     1611.2      -0.5%
>   dontcache             1281.1     1629.4     +27.2%
>   direct                1545.4     1609.4      +4.1%
>
>   Mixed-mode noisy neighbor (dontcache writer + buffered readers):
>                        baseline    patched     change
>   writer (MB/s)         1297.6     1471.1     +13.4%
>   readers avg (MB/s)     855.0      462.4     -45.9%
>
> nfsd-io-bench results on same hardware (XFS on NVMe, NFSv3 via fio
> NFS engine with libnfs, 1024 NFSD threads, pool_mode=3Dpernode,
> file size ~502 GB, compared to v6.19-ish baseline):
>
>   Single-client sequential write (MB/s):
>                        baseline    patched     change
>   buffered              4844.2     4653.4      -3.9%
>   dontcache             3028.3     3723.1     +22.9%
>   direct                 957.6      987.8      +3.2%
>
>   Single-client sequential write p99.9 latency (us):
>                        baseline    patched     change
>   dontcache            759169.0   175112.2     -76.9%
>
>   Single-client random write (MB/s):
>                        baseline    patched     change
>   dontcache              590.0     1561.0    +164.6%
>
>   Multi-writer aggregate throughput (MB/s):
>                        baseline    patched     change
>   buffered              9636.3     9422.9      -2.2%
>   dontcache             1894.9     9442.6    +398.3%
>   direct                 809.6      975.1     +20.4%
>
>   Noisy neighbor (dontcache writer + random readers):
>                        baseline    patched     change
>   writer (MB/s)         1854.5     4063.6    +119.1%
>   readers avg (MB/s)     131.2      101.6     -22.5%
>
> The NFS results show even larger improvements than the local benchmarks.
> Multi-writer dontcache throughput improves nearly 5x, matching buffered
> I/O. Dirty page footprint drops 85-95% in sequential workloads vs.
> buffered.
>

Nice :)
Some explaination here of why 5x improvement with NFS compared to local
filesystems please?
(I am not much aware of NFS side, but a possible reasoning would help)

-ritesh


