Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2556C9832F
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 11:48:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 685516B0088; Sun, 27 Sep 2026 07:48:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 636606B008A; Sun, 27 Sep 2026 07:48:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FE666B008C; Sun, 27 Sep 2026 07:48:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 189116B0088
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 07:48:43 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 66E84A7170
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 11:48:42 +0000 (UTC)
X-FDA: 85259370084.29.289FA2D
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf03.hostedemail.com (Postfix) with ESMTP id BC7E520002
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 11:48:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=bhYB1Snz;
	spf=pass (imf03.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790509720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6UgoZARQeqwbtbTZxY5jfWds9R7jptg+w98Z3sju2mM=;
	b=Nl0cDEpnP+7J6bH+iglpFbm+qUU958Kv0SLG8nK5tLP7JyzordD4xx6oGLMnkDvfJh+F63
	79EoqThuhPp1+g74r3U0xvvXtwCQEZ8xras1hQzXoyGoFEijIUQzRZuFS3zuTODSdtUQlG
	9WFQwB97TDCtLRxRXvDHee0VLipLM3Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790509720;
	b=QXD644Hu0A7nBcNLpdERnIf4muUV+SUKm0SpO0PDSOulViuHM/dFoYrPxh4bUmRK13HWxk
	svXnIE2QmW93Cd1PNs+TrntLC2+AliKu5lbP8OdR5zmx2sZQovGPOpmwUHlZxlw2ooH+ro
	4GPl8y2Lo0RYhqZFPpB+x53N9V2uSLc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=bhYB1Snz;
	spf=pass (imf03.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2dd1dcdcf95so9987905ad.1
        for <linux-mm@kvack.org>; Sun, 27 Sep 2026 04:48:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790509718; x=1791114518; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:references:cc:to
         :from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=6UgoZARQeqwbtbTZxY5jfWds9R7jptg+w98Z3sju2mM=;
        b=bhYB1Snzdrk1MWc9kvjqfItQNxlc336EUMRAjBPml4c0MeVfNXinxrgc3uiIG6QPZ7
         t14Ykkjtrt7kjngS17z18I1lpJ3DEJnKXkQFwOXE8srGvJKMd+EdSpVOeCEn6+/D5ust
         /vItIVjsIFRMQJ5qjsp7W0c092e2/LOAD1N59bWoQg28TryvUXV1RsEwPUCSeOgoke0W
         8A3pBsyTKtlxnFp/2i0/obtsRiay8sWeNAUWoQUZ4y/QMnBBML6CGIsZL66TKknfYi5S
         1YRGMpil0STWR+MuKQVA7UcPeK1yxrdsQcPQQ/sH3pKyUfks1dbxCPPru27zUN6A70wT
         4FJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790509718; x=1791114518;
        h=content-transfer-encoding:content-type:in-reply-to:references:cc:to
         :from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6UgoZARQeqwbtbTZxY5jfWds9R7jptg+w98Z3sju2mM=;
        b=PIDnv+e9V0HDtiMBWJmQxBoXjg26yh6UE7QKWLXiQAt3eE0Ol13Cmf+n8VlqBatbst
         lV+hKeszHEpMHlfQ2ugoPonMrtoCQgADNhX/b4u1To+sT9BxUKDUZVZszR4FW6sXpVsC
         PYeHUmWyaoDJUSFnN+CpV76jRgnKRYpYMaC07s+ZrXJQBzhppvAzKyOrS0IU6kdkC6w7
         9iya15+ZkThYBBjYmQamO/czz5HTrcdpjzEemurEAdJsiaTuNV4EAcLVMByz2xHpMbXN
         xLZoCYNk+eCue6qbkbYKupxy9pKxFvdVG+x8Mf8q5TKDnd+vRqyZr0Tmf8Nps9kBs4xb
         LuGg==
X-Forwarded-Encrypted: i=1; AKwUvBx1zwWEy4mwq2xgkALzQwNjo3kulz2BOsdx629npiPEr+hmTzdkg/3xI2y0Cp8vud7BMy7t6qj1XQ==@kvack.org
X-Gm-Message-State: AFq9FYIYi1XOjcpsUYBL2Qll2VBvMZ+Sfu6iei0+91a3Op1SJ+g0rqNY
	m03LYsqzetXPzUN28fRsUNRoHdqcs/7PTqPTPEivjFMgY5YXm+EQeM2QF1OnmJayX6g=
X-Gm-Gg: AYBFou1V3P1XqIa1ZTRaUc7v7g8qKxblWpCijEW1hJs4Cp6Jz+aC1gYZyVv9IQ/xepN
	wftK5ddXb4QZ0nJgPcfCW2GkMCNuonTaX/C88u/WcROUUOAsk6pk8TWiDUF1AvipvL3hb5puCMn
	4UOQaafG8fCl4u+JxAC9I5i6eDeUyeub45BwYCbqoLehNRvvdw7CzG4/NWXSEVN3t6f146zCMNN
	L2QpRoZ9+SGXV6C65qvIdAafioohl4fa8LmMHsSS+0vOsznH65Bo7QcTyVYOYAAXV2UdCE3fMGs
	npnkYkH1YyXOxziik1gGWQMnORVM40RGMRp3WUKXtivRyGufyluUPHWAChcg7OoSqTWDL9TTWXA
	0vHOw7/QpJsRleN21KsAkWP6LkkV2PWd3uE5jgpaYc4SXqwiy77htJYp5EKjsPZkm5WI6cYj0gy
	rYJVDDXBhQnyRN0UJxOD/0ZBgfQQ2u4gqvMKBapzBNDBxix2YOkqDF3loYokPvigiAdLLatSgpO
	s3JlBIZZ3itQM4jpkDRVM6k9wDqW3mqJOmYN/R99lc2uSVmIGw1+EJk6pfQTPQcbKo6gjYUwI7F
	gjXUxw==
X-Received: by 2002:a17:903:144e:b0:2d7:1cbd:9ceb with SMTP id d9443c01a7336-2df7dfc2e54mr63334925ad.12.1790509718121;
        Sun, 27 Sep 2026 04:48:38 -0700 (PDT)
Received: from ?IPV6:2409:8a04:3024:f231:884:d8f1:aab5:6785? ([2409:8a04:3024:f231:884:d8f1:aab5:6785])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df9146ed7csm28018285ad.80.2026.09.27.04.48.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Sep 2026 04:48:37 -0700 (PDT)
Message-ID: <b5da5c30-7c8b-4c60-aa3b-d2e3603e82c1@bytedance.com>
Date: Sun, 27 Sep 2026 19:48:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 0/3] memcg,writeback: flush foreign bdev mappings
 separately
From: Julian Sun <sunjunchao@bytedance.com>
To: linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org
Cc: axboe@kernel.dk, hannes@cmpxchg.org, mhocko@kernel.org,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 willy@infradead.org, jack@suse.cz, tj@kernel.org, akpm@linux-foundation.org
References: <20260922125015.3435215-1-sunjunchao@bytedance.com>
In-Reply-To: <20260922125015.3435215-1-sunjunchao@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BC7E520002
X-Stat-Signature: q18jb9wr13jn7hu8fsebdpbatrbguwrk
X-HE-Tag: 1790509719-939023
X-HE-Meta: U2FsdGVkX1+bX6K45aneErkbPztlE06//ocLVLZVpgRsQ9QmG0ObnFvcK27XoRnlBtprK9xmJnMBOMybNWRBMaFX4/B6kbe4OKlNFdIGw8jkRXHktso3Y7ls4tcEMBOcaxLQepF5czNXm5CdDvEE48wzdSCCT3jXlG1hhBvz/mAgDlUFvk0eaXZyiMANblf/zQ7yDyDpQaNjMlrl2AKb8hS6FHd+C0wJG136u6CA1QQ5mUnChj4Xyfx+M68v0DRo/Fguoh9zz5/V93HIuhKWbTshWPYyddPRGQ2hF5B3EuxnRQyrviQ/oUQN4W9ckX2SPeUqM1zx2WUplOYq+QcJV3BOWhu06F/W2SEVbProGwaOZQBdyUDA361Px6gWEfJvuagGf4/SXfl49sT5Lny5rKAVh9Sdtpt8cNAkoPwBmbJY9ngH3iNAn7l1SMXSyyxF/gBcrS5Hw8yXkVF2RYO1W2rnRfiSUJoYVZ9xj6C3oMVg6BpoQYRV0GtPubG77MHOtcnLQZDC1pWMgPLpV2q/JgJHr3vp1YZn+HIS1903bfIb85v2O6p3ggPF4mCmlU5fifU0m+xkA/895Xyplyb54Y0xkn1EHK/si2vwrxnazu5VDF6blDJPHj4+/ZZfjBHPwk2djTzwCnj9C+L2tdqRtUz3L6UB8gZ/QcRMP1OJLr+bMz1hJBFXgxckAdoNir2F6KyOe8J5cVYGYDn/owlu0KKP9nv8riXQ5I/WhlpRL3mvx5YrA2VA0hg3Jaim+NUEPI5ZmBgsAaqweMihRxNVCLfaj8asqvblp0IxnTxxIFkT4isaXlLxJcqkjom8G0d7t0UWdrbn5ofDoUCi3bhAWLQKeTuV1OQeRLVlz/fH5AKVNVSYlH4SPF3lE1y/6IJJfWikUzjJffhRGvpBCw16G/j6gQ+sF9o6dWBh2xxXFG6mmjCsK93O9iY43P1e+A3Z6bVz23YybPcKlEn/rB5
 ZUAv8ojQ
 NbstvMKTY7qtFyiG/mJ6mKlJBhgXyPtp8dSrMU60s3D+33MKf47Sm1p1FvEsp8YX6MPSRcDIhtD2S5a0oPY5Uw/va5XtR4i0RQ1MZ+vYqPNIZc666EYT/fghIyGsF/Q6oUHRiAqxT+1fuC1ugc6SaeRT0pb9FaU+QsU2icuFqEFqibGfZnBBJu4keEKI9iQOniacnb2SzkVlfiqM6MVc9uhJNa2JQ57GLTlTi0t8gCaUr0DtpoWqYN5Je/uUG1hEGfYGhmii4nXqhHSTy1HKiJ4bSjTI8PI32yvIjMfhTt7V1MzHzYverPDDI7k6HJJeurDfbm3Jpj/xv/FKRvk9Tth04wcNrIM3Z9D+G1nzam70pL9uhvGuETCoapA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/22/26 8:50 PM, Julian Sun wrote:

Hi,

Do you have any further thoughts on this series?
Should I rename bdev_flush_by_dev() to bdev_writeback_by_dev()
and send the next revision?

> Hi,
> 
> This series avoids owner-wide foreign writeback triggered by dirtying
> shared bdev inodes. Instead, it tracks bdev targets separately and
> schedules writeback of their mappings.
> 
> Problem
> =======
> 
> Bdev inodes are commonly shared by many memcgs. Dirtying their pages
> can cause the owner wb to be tracked as foreign, triggering writeback
> of the entire wb rather than just the bdev mapping.
> 
> In production, almost all the foreign dirtying we traced came from bdev
> inodes. Across our observations, a bdev mapping had as little as about
> 10 MiB of dirty pages, yet foreign flushes targeted the entire owner
> wb. On one machine, we observed 599 such works queued on one wb, with
> an average request budget of about 43 GiB per work.
> 
> Measured impact
> ===============
> 
> The synthetic test used a VM with 4 vCPUs, 8 GiB RAM, ext4 and cgroup
> v2, with device write bandwidth capped at 200 MiB/s. Background fio
> repeatedly overwrote a 256 MiB file using buffered I/O, while
> foreground fio performed sequential direct writes. Four memcgs
> generated metadata and buffered writes to trigger foreign flushes.
> 
> We measured completed block writes to the background fio file,
> including final sync, and foreground fio bandwidth, latency and
> completion time.
> 
> Across three runs per kernel, mean background file write I/O decreased
> by 72.7%, foreground bandwidth increased by 23.0%, and completion time
> decreased by 18.8%.
> 
> Metric                         Baseline    Patched     Change
> Background file write I/O (GiB)    6.154      1.680     -72.7%
> Foreground bandwidth (MiB/s)      150.29     184.81     +23.0%
> Foreground completion time (s)   109.203     88.652     -18.8%
> Foreground mean latency (ms)      212.84     172.74     -18.8%
> 
> How it helps
> ============
> 
> Frequent writeback of the file overwritten by background fio reduces
> the opportunity to coalesce buffered writes in the page cache.
> Several overwrites of the same page can otherwise result in a single
> write of its latest contents. Flushing between updates instead writes
> the same page repeatedly, generating more device I/O for the same
> application writes.
> 
> This additional I/O makes the device reach its performance limit
> more easily and competes with foreground I/O for device bandwidth.
> 
> The benefit is expected to be most pronounced when these conditions
> occur together on the same device:
> 
> 1. Limited device bandwidth, as with an HDD, makes the additional
>    writeback I/O more likely to saturate the device.
> 2. Multiple cgroups perform buffered overwrites. Frequent foreign
>    writeback reduces write coalescing and increases device I/O.
> 3. Concurrent direct I/O bypasses the page cache and competes directly
>    with writeback I/O for device bandwidth.
> 
> Approach
> ========
> 
> Following Jan's suggestion, this series records foreign bdev targets
> separately and flushes their mappings instead of their owner wbs. This
> preserves a way for dirty throttling to initiate bdev writeback while
> avoiding owner-wide writeback triggered by these records. The existing
> foreign-wb mechanism remains unchanged for other inodes.
> 
> Tracking uses oldest-first replacement and expiry after
> dirty_expire_interval. Further dirtying during an ongoing flush can
> trigger another flush after it finishes.
> 
> Tracking is best effort: each memcg keeps a bounded set of device
> numbers without persistent device or inode references. Recording runs
> under mapping->i_pages with IRQs disabled, while dropping a device
> reference can sleep. A memcg that never enters dirty throttling could
> also retain an unused record and pin the device object indefinitely.
> Recording only dev_t avoids these lifetime constraints. Device removal
> and device-number reuse may cause an unintended best-effort flush,
> which is an accepted trade-off.
> 
> Writeback submission may block for a long time, with up to four work
> items outstanding per memcg. A dedicated unbound workqueue provides
> a separate max_active budget so these flushes do not exhaust active
> slots on a shared workqueue and delay unrelated work. If the workqueue
> cannot be allocated at boot, bdev inodes continue to use the existing
> foreign-wb path.
> 
> This primarily affects filesystems that keep metadata in the bdev page
> cache, such as ext4 and other buffer_head users, rather than the usual
> metadata writeback paths of XFS and Btrfs. This also covers buffered
> writes to raw block devices. The decision still does not account for
> how much of the memcg's dirty memory belongs to the bdev: even a single
> dirty bitmap block can trigger writeback of the entire bdev mapping
> when the memcg enters dirty throttling.
> 
> Changes since v7:
> - Update comments and commit messages as suggested by Tejun Heo.
> 
> Changes since v6:
> - Drop open_mutex and the openers check from bdev_flush_by_dev(), and
>   add a !CONFIG_BLOCK stub.
> - Follow the existing foreign-wb tracking policy: use timestamps for
>   oldest-first replacement and expiry, and allow dirtying during an
>   in-flight flush to re-arm the record.
> - Replace frn_lock with an atomic in-flight flag.
> - Drop WQ_MEM_RECLAIM and explain the separate max_active budget.
> - Expand the dev_t lifetime rationale and filesystem scope, update
>   the foreign-dirty overview, and drop the Fixes tag.
> 
> Changes since v5:
> - Fix repeated overwriting of slot 0 in patch 2 and add comments.
> 
> Changes since v4:
> - Add before-and-after performance comparisons to the cover letter.
> 
> Changes since v3:
> - Flush foreign-dirtied bdev inode mappings separately, as suggested
>   by Jan.
> 
> Thanks.
> 
> Julian Sun (3):
>   block: introduce bdev_flush_by_dev()
>   memcg,writeback: flush foreign bdev mappings separately from owner wbs
>   writeback: record bdev targets in foreign writeback tracepoints
> 
>  block/bdev.c                     |  18 ++++++
>  include/linux/blkdev.h           |   4 ++
>  include/linux/memcontrol.h       |  12 ++++
>  include/trace/events/writeback.h |  22 ++++---
>  mm/memcontrol.c                  | 123 +++++++++++++++++++++++++++++++++++----
>  5 files changed, 160 insertions(+), 19 deletions(-)
> 

Thanks,
-- 
Julian Sun <sunjunchao@bytedance.com>

