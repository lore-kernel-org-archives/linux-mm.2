Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B278CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 08:19:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8F3B8E0008; Mon, 10 Nov 2025 03:19:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A66DD8E0002; Mon, 10 Nov 2025 03:19:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A45C8E0008; Mon, 10 Nov 2025 03:19:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 857AF8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 03:19:02 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 197F25CABD
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:19:02 +0000 (UTC)
X-FDA: 84093996924.10.82C2A99
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2D02240002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:18:59 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TiT8gxSm;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762762740; a=rsa-sha256;
	cv=none;
	b=DVPwH2ILRp6UozEf+0gizP5qmXrnJflDhsu2PmHcn6B3ieQ1K+8mGMEfVLyd4syCq/sIWX
	6NZMfW+QZzW+Ft1wVoJcdHBbirdbmb0der6ZMVlSK4uWqV35i1yt2yDjZlLdoHEzB6ACYx
	h6X7Ma3DQUy6BuQ3OfRRgnpGcUT+Z5I=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TiT8gxSm;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762762740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=aA2NOzQse06x9i0m2QrR5DmKV75xHASn1pyl9aKwEzM=;
	b=Wny/v9CNvsASIqHgX8Y+dXJ3ZmLH8MUhkKFupAzbtk69D9Ff+nXGh2v0N2N9xK155zApF9
	3LB6lt6/PO+bcriep2z+ZDG6vk491+uqxG+J4ieO/vF+iMzTAmDtnqdMxY1pc6W8i+00iC
	DS6HOa622VLGFNrtp1tGwbgJe4D2ngQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762762737;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=aA2NOzQse06x9i0m2QrR5DmKV75xHASn1pyl9aKwEzM=;
	b=TiT8gxSmIZ81WzRtRKz6SsqUMzqS8jbj/Jsn3CvPn926nv44UROFAlB1rctkkIP52Jt9Zo
	c+RcFMv1f3HcRg80wUVx3Qzb5d6POUdtNRk0c1qnOEFX+coIum6yru0jdCMcjY/uW52xrr
	2He9M1IqjoI9TMFwjTggRFv2dD4Pomc=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	akpm@linux-foundation.org,
	richard.weiyang@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v6 0/4] reparent the THP split queue
Date: Mon, 10 Nov 2025 16:17:54 +0800
Message-ID: <cover.1762762324.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2D02240002
X-Stat-Signature: 6z5seh6ghy3ra8mcj4hrse3u6uq6s94r
X-Rspam-User: 
X-HE-Tag: 1762762739-840543
X-HE-Meta: U2FsdGVkX184l3E2NbjFnEwn4Q3CPLaAxpJl5fbsWHGDfMxAW4/TfpY0Eo63ufPueq/Qp5/ck1oGb1Dk/58a2gqz5Q1WenJTAfZ7f+PvrfieVIFzwuDc/rj4L4FQuLDSbBKaIEBCgSOLNT9T4gi15PUh+CWXZ/7YEFl8tuY9VpRWu0kjpGsPEl6lIvKDTgmZecNWHw/7TJ41/Dyf4x5c3rY55UAxyLKvdwGEhZmuja9jo7U63ZXr73V2onkK496RszLhQZHQwR4TcD83b2eXZsRMrrIljnqryBex6AZ+vOjH9hMpLLyeU1ZE1plRJo1xOi6PeUtEQMq5F185RZ+I4a3hSFSB7MflWm9fH/UU/Xgltk2MI0hHBguUceqpNqFCuG73Q45SyW0P61qQJoSdAufA182Ba/D6E/xWcXJN6tC1h2Xc1LGP9QLK06O4mmnmQN7OpWIQ29lGPChQcEcaEE87p6LL+WM0DAtX0XrqjFbV/X4CdUk/Fs4snYdxKHD5ubOKlrygplLel2PHt3cq8+E/2rzBOnj41VG/3TIq9ID7rPJsxVWH9iirBgaB5yi7ZGYTpV5mr8a5Crx/AyYrrGSCZTVPouvlU7rShbzf3zD+asLQ/S/ro66x81C4xulC3ney2p8ti2GhXaC0Ee50qHGSmctNCC+fFumqMPi9BwOslfSYXr2C5EMJKQT6wbC/k6OEi/3v/5agaE2AML/gZZw+ykxfdogVUSv5QsxfvN0FBKtMLSjw+F4gL3E9f0P+m07fPdkHtXlLO7u/3ZnXHUIArtr+2e6sZDYfy9hgtKWgyONB64CdmdKQsvOurdTPen9x7wEbGeKwj/l3PERcRs6kRXlhuQTniYRLoowA0kULbjfN8gqfqTB1/6D0XLC7iaxIvpvspD8ViHU7CQhYfi1ed5GXfXi94P+YN7zHlS/S19y7q8QjtdoiD92eQbZm1vJgyAgTSKpNWrjMFD9
 k7nZ+I+Q
 vDQMbbCWEF3o6RECRqiA1eqYplTAjiKRhCbzvJGTL1XEkjwcYY1RZS2yL1BQsM1qiLwt6GImVVdJ3dBnItM2vAiAOs6VKWNpPhSumj62Su0oWEDIlbSVXN89f82P9APxMmQDfhDgzo5oz4rZwRwEMpJ4yOeIa6HuNaF7bl9vqQ6uzvFtFnd+gYjsry2uoearrRhWJL14nsqLiTAArUDVWm8wMGNebJMK0dLrLS2dx1Elr+ccQeSwOBr+sBs90zS+wXVPKvRyRA9Tsqgpo2qJirVEmmQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Changes in v6:
 - collect Reviewed-bys
 - rebase onto the next-20251110

Changes in v5:
 - fix the softlockup issue in deferred_split_scan() (Zi Yan)
 - modify the commit message in [PATCH v4 3/4] (Shakeel Butt)
 - move memcg_is_dying() to memcontrol.h (Shakeel Butt)
 - collect Acked-bys and Reviewed-bys
 - rebase onto the next-20251014

Changes in v4:
 - add split_queue_lock*() and let folio_split_queue_lock*() to use them.
   (I have kept everyone's Acked-bys and Reviewed-bys. If you need to discard
    it, please let me know.)
 - let deferred_split_scan() to use split_queue_lock_irqsave(), which will fix
   the race problem in [PATCH v3 4/4].
   (Muchun Song)
 - collect Reviewed-bys
 - rebase onto the next-20251002

Changes in v3:
 - use css_is_dying() in folio_split_queue_lock*() to check if memcg is dying
   (David Hildenbrand, Shakeel Butt and Zi Yan)
 - modify the commit message in [PATCH v2 4/4]
   (Roman Gushchin)
 - fix the build error in [PATCH v2 4/4]
 - collect Acked-bys and Reviewed-bys
 - rebase onto the next-20250926

Changes in v2:
 - fix build errors in [PATCH 2/4] and [PATCH 4/4]
 - some cleanups for [PATCH 3/4] (suggested by David Hildenbrand)
 - collect Acked-bys and Reviewed-bys
 - rebase onto the next-20250922

Hi all,

In the future, we will reparent LRU folios during memcg offline to eliminate
dying memory cgroups, which requires reparenting the THP split queue to its
parent memcg.

Similar to list_lru, the split queue is relatively independent and does not need
to be reparented along with objcg and LRU folios (holding objcg lock and lru
lock). Therefore, we can apply the same mechanism as list_lru to reparent the
split queue first when memcg is offine.

The first three patches in this series are separated from the series
"Eliminate Dying Memory Cgroup" [1], mainly to do some cleanup and preparatory
work.

The last patch reparents the THP split queue to its parent memcg during memcg
offline.

Comments and suggestions are welcome!

Thanks,
Qi

[1]. https://lore.kernel.org/all/20250415024532.26632-1-songmuchun@bytedance.com/

Muchun Song (3):
  mm: thp: replace folio_memcg() with folio_memcg_charged()
  mm: thp: introduce folio_split_queue_lock and its variants
  mm: thp: use folio_batch to handle THP splitting in
    deferred_split_scan()

Qi Zheng (1):
  mm: thp: reparent the split queue during memcg offline

 include/linux/huge_mm.h    |   4 +
 include/linux/memcontrol.h |  20 +++
 mm/huge_memory.c           | 250 +++++++++++++++++++++++++------------
 mm/memcontrol.c            |   1 +
 4 files changed, 194 insertions(+), 81 deletions(-)

-- 
2.20.1


