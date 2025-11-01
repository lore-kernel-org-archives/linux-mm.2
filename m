Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84BB2CCFA00
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 16:14:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 422E58E008A; Sat,  1 Nov 2025 12:14:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D3FD8E007F; Sat,  1 Nov 2025 12:14:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E9F68E008A; Sat,  1 Nov 2025 12:14:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 160708E007F
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 12:14:38 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9A5DA160623
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 16:14:37 +0000 (UTC)
X-FDA: 84062536194.16.1BC3E12
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9399720008
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 16:14:35 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FyPTtNdF;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of groeck7@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=groeck7@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762013675; a=rsa-sha256;
	cv=none;
	b=FU3w2GX1MybSmiWKqPSfzHxJ26WFquvQJRNvuJ6w08Sobs2Cxe3BoSAF4IH8/kzJtZ5mc8
	MbrGl9YGcpj3crCzqKstTHhWhP2kMT9zmFqrMVfVC01WGZZZhobT2HHiJd3W7SGLfspfcQ
	ITq0MNEeFnfuYNY+LMPZiGQCBkTu6z0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FyPTtNdF;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of groeck7@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=groeck7@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762013675;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v0VVOPFGNqZxWLjcPxZHY3pwKLOJGpCx2gYYUsTkw98=;
	b=p3Ye8un2CPUOgM7XH+YfWHncMPES+aqpCIj2mkkEcQpq0Y0qCQEul+apjC4ZeaGceASvGv
	fh3IzE2a3Ep7bzankJSgY6zmQ1HMJjl6icR2ds19Pw3W3DKSnI77iFeQjVm7y70rQZT7Vb
	9DxCSXkIEHSYbRTkRkd5NrPEYC5HDsk=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-29570bcf220so3062535ad.3
        for <linux-mm@kvack.org>; Sat, 01 Nov 2025 09:14:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762013674; x=1762618474; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v0VVOPFGNqZxWLjcPxZHY3pwKLOJGpCx2gYYUsTkw98=;
        b=FyPTtNdFTVhhWmm3AFN+pCYjnMEqkWe4bAKztW7wdOcgXQk12dFHVBo+jUPbZQ4dAq
         JwiQbnhmGkFyMNS2idhWW6VLx0bErkHUUI8N581IL0pzAlZR9DgrSGGqZSdQAG/rbxa1
         HQ68qeT9dcofN74+JT4dgnnhQmuKdu9TAjH1SM+BXwDLvb7x42JZLY5qLWSJVpl7bdug
         YbnUSs3q9NMs+95oWAjerPnPpSnj9A7dFqOE3mxSADHgg+B6jn9O9a4rhJM4CopneY26
         Z7UxjhMZiMYpMFIWcFC+2s53/D4Fx/M/6sEAad0V83RZ/z8BwlQ6l2PsiLqRt9XdlYua
         2pVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762013674; x=1762618474;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v0VVOPFGNqZxWLjcPxZHY3pwKLOJGpCx2gYYUsTkw98=;
        b=OexgI/kJVpbzNSrbWqY04I3vouTurYPAAQTNdU37Y41JJc+Oi0g6Fq2OZvf1E4hWj9
         DC5qzKXn28OlWnWzXLbQRuv8QMxCzA8wXDYaxsQa+/gRZZPtoNHSnvIaS2dNJ2En8W8x
         sPi/1R9qB2DMwsfm/p69zelW/TU+yANluJDPURuGuulkP8ja2dppXlx0jhrCGBgAw7P4
         TxakcyyIMs7Tgh7WY0dvaVVY/+L16rKIXkSsHldw53OJhgkf5aRtspV+ISDA2I/hl6Ay
         5sHjcjFAbEYIvxWVSg37MonB6u+TABxJGKm/Qtk6TV8Ui9Mqdl2y3+DKUryyuBdL6yzd
         LcoA==
X-Forwarded-Encrypted: i=1; AJvYcCWk1e2P3g40sqYATngkjaNmwTHYFl1IEABPwFVmp7/3zboJgCyWkDEfHa2DkZcnApi7QGyK7NgqDg==@kvack.org
X-Gm-Message-State: AOJu0YwNc/Yu02KVb/sxT1udPGOE1EodLcpm+84sylbCklH0nSo/4nZ4
	LN8KcDJniQF0UPkXrWjKVikkBROKeQYkCoIpgRZlZU63Ns8xmst5/5h3
X-Gm-Gg: ASbGncvBseKlIhPW1mxfxfGnCjlJ8cpcrAz+hhJeEbwc0NUFIyLA3qHWbuo4mnc/CGL
	QjQjWOTtfrJXITTXhlMwS1XXCxWnAWONOX/zbJ5hWwhpAZ2bWmlk4ss6oKpxklEX8Zpfy6xIENv
	ENmgrmLRyWfl3bZTvaW4af3t6JS3cmivoIygtvvdTZus/oNkV+DH5OZtcAiTD4JlebqmVC+RDPF
	PATa0PgR7acp+JlDcxovRrtLGiyO8Kp1WCYOVeJJDXXbP0VvcGt6vQ3vGa/81jVvAl/XeuLNehU
	pRFc6EJto+uyj1w7+zbvXXuJvjeeB5ArX8EnXMi8t/cqK4QsKCCbAGVCSplmGONh0chsUQHFPBx
	PRVPzMEh0td99w7+C4kc83Ry/fxKC3DCoP76EiyFXnH1AY94AzzNFqz4B6/Ywte7/winh2Kozc2
	ivyCoD28ttthe9
X-Google-Smtp-Source: AGHT+IHN0y7sON+faPm48FjlWrhktSmV+dTMcFYFDjkUeKCSzm3MXacCB3qeyREgWewnhdn1tGJ1Qw==
X-Received: by 2002:a17:902:d48f:b0:24c:c8e7:60b5 with SMTP id d9443c01a7336-2951a38ba91mr106200445ad.16.1762013674162;
        Sat, 01 Nov 2025 09:14:34 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a7db86cdd2sm5626310b3a.58.2025.11.01.09.14.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Nov 2025 09:14:33 -0700 (PDT)
Date: Sat, 1 Nov 2025 09:14:32 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Yang Shi <yang@os.amperecomputing.com>
Cc: catalin.marinas@arm.com, will@kernel.org, ryan.roberts@arm.com,
	akpm@linux-foundation.org, david@redhat.com,
	lorenzo.stoakes@oracle.com, ardb@kernel.org, dev.jain@arm.com,
	scott@os.amperecomputing.com, cl@gentwo.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v8 3/5] arm64: mm: support large block mapping when
 rodata=full
Message-ID: <f24b9032-0ec9-47b1-8b95-c0eeac7a31c5@roeck-us.net>
References: <20250917190323.3828347-1-yang@os.amperecomputing.com>
 <20250917190323.3828347-4-yang@os.amperecomputing.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250917190323.3828347-4-yang@os.amperecomputing.com>
X-Stat-Signature: 9dsug1r7y94hzcngn4c5pojo979cumtu
X-Rspamd-Queue-Id: 9399720008
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1762013675-567088
X-HE-Meta: U2FsdGVkX1/bdIwKzkPeOcMP83v5r6u5wVa7V5TuzjJqJlptFgu6l2gQTGJHHs+B60wUySHmO9DG9CqucaudDZXogU6N15N/DY/A01EWBX+MXNrlSsoN90KPTLfmP0dzuBMoUUOnR3wKTnEkI7wzFbQ+3lA8xo0/HCZGZy313KSeLPRDQ6WOOg/DqS6iJmXyVb/FSNjYExzZBV93FJpUszWTdMhUkJIloOf2csXnupIz9raO6swXhMmPTbrq3i2mUREb6jzxbCSGk+3bwGjonp1t6klWxdQWDAZQkM3fYOfn44CQZGICXmiLSplq8pG/PA6qNYpuedlcyd8IpsgUPjSV7aBF38o48oUhJLz2me3hWDkfY9r/lP/nynyHcjc3wDqLQQUzOmzcF7R3rEkGRUcLu8UsRlSVaeiZ2jHRG00C3VH+Yul+hXc7HTuUXxMsgJjOa7T1CW3i92S8WiSuwuuPAxeZcRVUM/V+5R4dd3yRjGAhKxpmL/RmRP7cj2KU+jGm1nVRlEHLQBDkapCrowey2SSVxacT9eC7o0lzuMShtmWJPISz63k9xjh3jrCdrsVjYBnW4A99cSyOM88FMr0+qzpzQaRaCmcOEdHqaY/4ai/6JqXZ30ugru4byV7TQHSiswloWXKQ76sbGEOCow0OyjynzjC3tGH69cXrVhipYu6RF0HU7FDEY1U5E5a7GiVWQ+Z2xCDMjyWAMYQY2QVrixdjyvS/gCfqNoF9Cxvhp9Jauw5SlLM7UaIaDwuhBqLaM8FsQn0Mh+MwwvZxFmwCjMfO65f3otNVUG5CWwyiBXZrx9BQGFac0Rq2Hv7owTiCuc2fDLl7wkYTSsa5sBapS3iJMhDNIk0REt1J9uDvLhn1QE5Ly0oxBA5tzJuDcaczTQZK7FgEtG5H/3LvZe6FCQe+g2BITFJy2lbxbRRbr7xVWphJPAMEOJOOSG6KuHeQ8cchzQJNSaqpS+0
 XQIkljfd
 qzR6/4SHrCL0TFvvN+SATUreppe0vn+OFUrwPI/5Y9gz2Bo14YiwNBMHEiITXgMtWVpjbR6Rqd0b+sWfOVMNLZm3F8vwV3v1khDB4qhzifBseOrm/mHbVK+OUqmAbrc1KGXE2dFx/VPouLltKEWTnyc9n6BiUgO6KPLSj1mCpYr74ssKhh71YucwFyY8Da+1Wy0PbS3vHHdXGdm+ZWCZ/z6wrqcM2VEPFbYD0gYXn2A9rck9vmkIzj1BPvXAo4BnLxGmBLTDW0xZxE4W0ktvSI5c+yHHXQ95J9dlLg3ngVc6FmySEkfKBse9zugpkzpa+Jw7RzhElEGlpSPJz94n6h5d7lMbjozgBrMUjE40K4kHXK85qVxXDZ0iQmcNRODeslKLWt/3D8+mTotKuoqzndqaBse+Ym4lCeRQ4vkL2NGqSctgzIWHANAP0TaSCSSaDAuONzMBsI6pjZukktDh/+gSdNHXPgKnll347osKlajvJwWNRo5efUnDPQ9rlSLXHRIhAn3N6zlwcQZH0Yq0tpGfUGnbSrZrIEikOhO6SeVS7ACQgspRL2FQPYrP72aa/Bs46H/OrklgVbFSSsRFYAwb1K6GTfKQOly2hq1beh6HwOfvVus/M9xwBSVB6TVLyHDdh+XNfX6P4nn0ZpQZURGsjr0JhkPjnXeUC7Zr9igMgw9D8UbL26Jzztus+EjSjsVDxKJKw8zachTxZQTfV+Qv7Fz0zf/sbh55sjGInbbixri1Pv57LL9CxPw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Wed, Sep 17, 2025 at 12:02:09PM -0700, Yang Shi wrote:
> When rodata=full is specified, kernel linear mapping has to be mapped at
> PTE level since large page table can't be split due to break-before-make
> rule on ARM64.
> 
> This resulted in a couple of problems:
>   - performance degradation
>   - more TLB pressure
>   - memory waste for kernel page table
> 
> With FEAT_BBM level 2 support, splitting large block page table to
> smaller ones doesn't need to make the page table entry invalid anymore.
> This allows kernel split large block mapping on the fly.
> 
> Add kernel page table split support and use large block mapping by
> default when FEAT_BBM level 2 is supported for rodata=full.  When
> changing permissions for kernel linear mapping, the page table will be
> split to smaller size.
> 
> The machine without FEAT_BBM level 2 will fallback to have kernel linear
> mapping PTE-mapped when rodata=full.
> 
> With this we saw significant performance boost with some benchmarks and
> much less memory consumption on my AmpereOne machine (192 cores, 1P)
> with 256GB memory.
> 
> * Memory use after boot
> Before:
> MemTotal:       258988984 kB
> MemFree:        254821700 kB
> 
> After:
> MemTotal:       259505132 kB
> MemFree:        255410264 kB
> 
> Around 500MB more memory are free to use.  The larger the machine, the
> more memory saved.
> 
> * Memcached
> We saw performance degradation when running Memcached benchmark with
> rodata=full vs rodata=on.  Our profiling pointed to kernel TLB pressure.
> With this patchset we saw ops/sec is increased by around 3.5%, P99
> latency is reduced by around 9.6%.
> The gain mainly came from reduced kernel TLB misses.  The kernel TLB
> MPKI is reduced by 28.5%.
> 
> The benchmark data is now on par with rodata=on too.
> 
> * Disk encryption (dm-crypt) benchmark
> Ran fio benchmark with the below command on a 128G ramdisk (ext4) with
> disk encryption (by dm-crypt).
> fio --directory=/data --random_generator=lfsr --norandommap            \
>     --randrepeat 1 --status-interval=999 --rw=write --bs=4k --loops=1  \
>     --ioengine=sync --iodepth=1 --numjobs=1 --fsync_on_close=1         \
>     --group_reporting --thread --name=iops-test-job --eta-newline=1    \
>     --size 100G
> 
> The IOPS is increased by 90% - 150% (the variance is high, but the worst
> number of good case is around 90% more than the best number of bad
> case). The bandwidth is increased and the avg clat is reduced
> proportionally.
> 
> * Sequential file read
> Read 100G file sequentially on XFS (xfs_io read with page cache
> populated). The bandwidth is increased by 150%.
> 

With lock debugging enabled, we see a large number of "BUG: sleeping
function called from invalid context at kernel/locking/mutex.c:580"
and "BUG: Invalid wait context:" backtraces when running v6.18-rc3.
Please see example below.

Bisect points to this patch.

Please let me know if there is anything I can do to help tracking
down the problem.

Thanks,
Guenter

---
Example log:

[    0.537499] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:580
[    0.537501] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 1, name: swapper/0
[    0.537502] preempt_count: 1, expected: 0
[    0.537504] 2 locks held by swapper/0/1:
[    0.537505]  #0: ffffb60b01211960 (sched_domains_mutex){+.+.}-{4:4}, at: sched_domains_mutex_lock+0x24/0x38
[    0.537510]  #1: ffffb60b01595838 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire+0x0/0x40
[    0.537516] CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted 6.18.0-dbg-DEV #1 NONE
[    0.537517] Call trace:
[    0.537518]  show_stack+0x20/0x38 (C)
[    0.537520]  __dump_stack+0x28/0x38
[    0.537522]  dump_stack_lvl+0xac/0xf0
[    0.537525]  dump_stack+0x18/0x3c
[    0.537527]  __might_resched+0x248/0x2a0
[    0.537529]  __might_sleep+0x40/0x90
[    0.537531]  __mutex_lock_common+0x70/0x1818
[    0.537533]  mutex_lock_nested+0x34/0x48
[    0.537534]  split_kernel_leaf_mapping+0x74/0x1a0
[    0.537536]  update_range_prot+0x40/0x150
[    0.537537]  __change_memory_common+0x30/0x148
[    0.537538]  __kernel_map_pages+0x70/0x88
[    0.537540]  __free_frozen_pages+0x6e4/0x7b8
[    0.537542]  free_frozen_pages+0x1c/0x30
[    0.537544]  __free_slab+0xf0/0x168
[    0.537547]  free_slab+0x2c/0xf8
[    0.537549]  free_to_partial_list+0x4e0/0x620
[    0.537551]  __slab_free+0x228/0x250
[    0.537553]  kfree+0x3c4/0x4c0
[    0.537555]  destroy_sched_domain+0xf8/0x140
[    0.537557]  cpu_attach_domain+0x17c/0x610
[    0.537558]  build_sched_domains+0x15a4/0x1718
[    0.537560]  sched_init_domains+0xbc/0xf8
[    0.537561]  sched_init_smp+0x30/0x98
[    0.537562]  kernel_init_freeable+0x148/0x230
[    0.537564]  kernel_init+0x28/0x148
[    0.537566]  ret_from_fork+0x10/0x20
[    0.537569] =============================
[    0.537569] [ BUG: Invalid wait context ]
[    0.537571] 6.18.0-dbg-DEV #1 Tainted: G        W
[    0.537572] -----------------------------
[    0.537572] swapper/0/1 is trying to lock:
[    0.537573] ffffb60b011f3830 (pgtable_split_lock){+.+.}-{4:4}, at: split_kernel_leaf_mapping+0x74/0x1a0
[    0.537576] other info that might help us debug this:
[    0.537577] context-{5:5}
[    0.537578] 2 locks held by swapper/0/1:
[    0.537579]  #0: ffffb60b01211960 (sched_domains_mutex){+.+.}-{4:4}, at: sched_domains_mutex_lock+0x24/0x38
[    0.537582]  #1: ffffb60b01595838 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire+0x0/0x40
[    0.537585] stack backtrace:
[    0.537585] CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Tainted: G        W           6.18.0-dbg-DEV #1 NONE
[    0.537587] Tainted: [W]=WARN
[    0.537588] Call trace:
[    0.537589]  show_stack+0x20/0x38 (C)
[    0.537591]  __dump_stack+0x28/0x38
[    0.537593]  dump_stack_lvl+0xac/0xf0
[    0.537596]  dump_stack+0x18/0x3c
[    0.537598]  __lock_acquire+0x980/0x2a20
[    0.537600]  lock_acquire+0x124/0x2b8
[    0.537602]  __mutex_lock_common+0xd8/0x1818
[    0.537604]  mutex_lock_nested+0x34/0x48
[    0.537605]  split_kernel_leaf_mapping+0x74/0x1a0
[    0.537607]  update_range_prot+0x40/0x150
[    0.537608]  __change_memory_common+0x30/0x148
[    0.537609]  __kernel_map_pages+0x70/0x88
[    0.537610]  __free_frozen_pages+0x6e4/0x7b8
[    0.537613]  free_frozen_pages+0x1c/0x30
[    0.537615]  __free_slab+0xf0/0x168
[    0.537617]  free_slab+0x2c/0xf8
[    0.537619]  free_to_partial_list+0x4e0/0x620
[    0.537621]  __slab_free+0x228/0x250
[    0.537623]  kfree+0x3c4/0x4c0
[    0.537625]  destroy_sched_domain+0xf8/0x140
[    0.537627]  cpu_attach_domain+0x17c/0x610
[    0.537628]  build_sched_domains+0x15a4/0x1718
[    0.537630]  sched_init_domains+0xbc/0xf8
[    0.537631]  sched_init_smp+0x30/0x98
[    0.537632]  kernel_init_freeable+0x148/0x230
[    0.537633]  kernel_init+0x28/0x148
[    0.537635]  ret_from_fork+0x10/0x20

---
bisect:

# bad: [3a8660878839faadb4f1a6dd72c3179c1df56787] Linux 6.18-rc1
# good: [e5f0a698b34ed76002dc5cff3804a61c80233a7a] Linux 6.17
git bisect start 'v6.18-rc1' 'v6.17'
# bad: [58809f614e0e3f4e12b489bddf680bfeb31c0a20] Merge tag 'drm-next-2025-10-01' of https://gitlab.freedesktop.org/drm/kernel
git bisect bad 58809f614e0e3f4e12b489bddf680bfeb31c0a20
# bad: [a8253f807760e9c80eada9e5354e1240ccf325f9] Merge tag 'soc-newsoc-6.18' of git://git.kernel.org/pub/scm/linux/kernel/git/soc/soc
git bisect bad a8253f807760e9c80eada9e5354e1240ccf325f9
# bad: [4b81e2eb9e4db8f6094c077d0c8b27c264901c1b] Merge tag 'timers-vdso-2025-09-29' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect bad 4b81e2eb9e4db8f6094c077d0c8b27c264901c1b
# bad: [f1004b2f19d7e9add9d707f64d9fcbc50f67921b] Merge tag 'm68k-for-v6.18-tag1' of git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k
git bisect bad f1004b2f19d7e9add9d707f64d9fcbc50f67921b
# good: [a9401710a5f5681abd2a6f21f9e76bc9f2e81891] Merge tag 'v6.18-rc-part1-smb3-common' of git://git.samba.org/ksmbd
git bisect good a9401710a5f5681abd2a6f21f9e76bc9f2e81891
# good: [fe68bb2861808ed5c48d399bd7e670ab76829d55] Merge tag 'microblaze-v6.18' of git://git.monstr.eu/linux-2.6-microblaze
git bisect good fe68bb2861808ed5c48d399bd7e670ab76829d55
# bad: [f2d64a22faeeecff385b4c91fab5fe036ab00162] Merge branch 'for-next/perf' into for-next/core
git bisect bad f2d64a22faeeecff385b4c91fab5fe036ab00162
# good: [30f9386820cddbba59b48ae0670c3a1646dd440e] Merge branch 'for-next/misc' into for-next/core
git bisect good 30f9386820cddbba59b48ae0670c3a1646dd440e
# good: [43de0ac332b815cf56dbdce63687de9acfd35d49] drivers/perf: hisi: Relax the event ID check in the framework
git bisect good 43de0ac332b815cf56dbdce63687de9acfd35d49
# good: [5973a62efa34c80c9a4e5eac1fca6f6209b902af] arm64: map [_text, _stext) virtual address range non-executable+read-only
git bisect good 5973a62efa34c80c9a4e5eac1fca6f6209b902af
# good: [b3abb08d6f628a76c36bf7da9508e1a67bf186a0] drivers/perf: hisi: Refactor the event configuration of L3C PMU
git bisect good b3abb08d6f628a76c36bf7da9508e1a67bf186a0
# good: [6d2f913fda5683fbd4c3580262e10386c1263dfb] Documentation: hisi-pmu: Add introduction to HiSilicon V3 PMU
git bisect good 6d2f913fda5683fbd4c3580262e10386c1263dfb
# good: [2084660ad288c998b6f0c885e266deb364f65fba] perf/dwc_pcie: Fix use of uninitialized variable
git bisect good 2084660ad288c998b6f0c885e266deb364f65fba
# bad: [77dfca70baefcb988318a72fe69eb99f6dabbbb1] Merge branch 'for-next/mm' into for-next/core
git bisect bad 77dfca70baefcb988318a72fe69eb99f6dabbbb1
# first bad commit: [77dfca70baefcb988318a72fe69eb99f6dabbbb1] Merge branch 'for-next/mm' into for-next/core

---
bisect into branch:

- git checkout -b testing 77dfca70baefcb988318a72fe69eb99f6dabbbb1
- git rebase 77dfca70baefcb988318a72fe69eb99f6dabbbb1~1
  [ fix minor conflict similar to the conflict resolution in 77dfca70baefc]
- git diff 77dfca70baefcb988318a72fe69eb99f6dabbbb1
  [ confirmed that there are no differences ]
- confirm that the problem is still seen at the tip of the rebase
- git bisect start HEAD 77dfca70baefcb988318a72fe69eb99f6dabbbb1~1
- run bisect

Results:

# bad: [47fc25df1ae3ae8412f1b812fb586c714d04a5e6] arm64: map [_text, _stext) virtual address range non-executable+read-only
# good: [30f9386820cddbba59b48ae0670c3a1646dd440e] Merge branch 'for-next/misc' into for-next/core
git bisect start 'HEAD' '77dfca70baefcb988318a72fe69eb99f6dabbbb1~1'
# good: [805491d19fc21271b5c27f4602f8f66b625c110f] arm64/Kconfig: Remove CONFIG_RODATA_FULL_DEFAULT_ENABLED
git bisect good 805491d19fc21271b5c27f4602f8f66b625c110f
# bad: [13c7d7426232cc4489df7cd2e1f646a22d3f6172] arm64: mm: support large block mapping when rodata=full
git bisect bad 13c7d7426232cc4489df7cd2e1f646a22d3f6172
# good: [a4d9c67e503f2b73c2d89d8e8209dfd241bdc8d8] arm64: Enable permission change on arm64 kernel block mappings
git bisect good a4d9c67e503f2b73c2d89d8e8209dfd241bdc8d8
# first bad commit: [13c7d7426232cc4489df7cd2e1f646a22d3f6172] arm64: mm: support large block mapping when rodata=full

