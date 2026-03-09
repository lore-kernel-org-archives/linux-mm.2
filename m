Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20355EA855A
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 05:50:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36B7E6B0088; Mon,  9 Mar 2026 01:50:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 319A96B0089; Mon,  9 Mar 2026 01:50:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 225396B008A; Mon,  9 Mar 2026 01:50:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0EBAF6B0088
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 01:50:38 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8C93D13B9C8
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 05:50:37 +0000 (UTC)
X-FDA: 84525450114.10.78DC544
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 94654100002
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 05:50:35 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B+k3oNFE;
	spf=pass (imf14.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773035435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tC9OL7D0uV/0nE4z74ieVTS9O9BlK+B4AD8xfHR50JM=;
	b=jgfi2Icfzjq/OGi3x4Pm0z9CAlsSV+7MnSCnV7jx8Xr8QPtLlwxQ9FwYMlNbmWt3TavjKS
	WHWfbPNFkZw0XMUWKkD+dmOgof7ghvpT+KVi4kTtbrq6NiD/MVsxFGZPeDm5uU/evukbVQ
	CGeCBaXo/vaCHuGHcyl8nCvRTw2xb1I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773035435; a=rsa-sha256;
	cv=none;
	b=wSmYw9OECao6IYA8s8iCw6xslpXbPIJV51nrLgucXlxEQESYmAfdejvTG2zSZKUtea6W6m
	7hQNjSlhOoqAPSIAi7al5SAewwm6zoFKRoP8a3SlaUEN6y6yEydcXECVgAiVFBcKewH+M2
	iqbwRXkPwGOfSRcOrlpMhi0H6RtrA1M=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B+k3oNFE;
	spf=pass (imf14.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5EDB143A42
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 05:50:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CBA2C19423
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 05:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773035434;
	bh=Sm5xfFohT6PwWq2yTFipdvcFh15GKBv9n0Io2kRwufk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=B+k3oNFExsQRQ4W2+UDHyJXTmxlR04qoaVrm0KAhLIsFR+VWDKuI9hrKpdZz9algA
	 tTJXHWqhcyyry/nYfV2Z8qwTQd0hkdwiroDysqan3CYiNnMFc10ajGhoMu45c4sWi1
	 sAaB7VAhY7zGeTCVhszo1oTN3ng3OjfHkwjdncDH13xSyGge0IaMdp7h4oR6skX1b1
	 wnLAakDXa6ldYG2pWGNgmVskEfwBjehHJxunItLpIL5MePpS+KdqSL2fa+lPn7uITv
	 szFh6aSD7S/7rPxk/BtlnqVUeVylC5qAgsUTP6ZeEesFbm6JaGyxngxpcutn2ua3g7
	 zVgLqTnW0udjg==
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-64ca6595c8aso10997548d50.0
        for <linux-mm@kvack.org>; Sun, 08 Mar 2026 22:50:34 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVrg0TH1ZLHsMcLCRzfWVxPRhSzjGUoD54j5P3GP4R7tXlIq1RHZV40E6wpRgAsaUZn7dIQc9iL9A==@kvack.org
X-Gm-Message-State: AOJu0YyHNmR3B4AZ8Odq84OKqXZ74VcGQIBsL73XU6bEsadcOd8VLXYe
	BAanN4DrSPrkBPStc8Kr+TmPBHoKPOhjVwcW38iMEfwNfBaHUNUei4tMm6zupd7Na0tYSnwEEzi
	hYNFHdjvOhU8zgNoOVzbIqNXHfrTB+BC9fhBW/ISawg==
X-Received: by 2002:a05:690e:d8d:b0:64c:9a08:9dfe with SMTP id
 956f58d0204a3-64d1429cbdemr9287598d50.46.1773035433567; Sun, 08 Mar 2026
 22:50:33 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1772797581.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1772797581.git.zhuhui@kylinos.cn>
From: Chris Li <chrisl@kernel.org>
Date: Sun, 8 Mar 2026 22:50:22 -0700
X-Gmail-Original-Message-ID: <CACePvbU5hSTOkGUVBGnN6xDCxywgA_QDKugqn=Qw6WbHBRJ6KQ@mail.gmail.com>
X-Gm-Features: AaiRm52eBYNLkQxjnY01S_PCGKfwLmzHT6KwnBYJ5n6oOeqtSE8S9cudeU9qs94
Message-ID: <CACePvbU5hSTOkGUVBGnN6xDCxywgA_QDKugqn=Qw6WbHBRJ6KQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] mm/swap: fix missing locks in swap_reclaim_work()
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>, 
	YoungJun Park <youngjun.park@lge.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: f1pppfo3isqjjjfs1q9jt43fbb4tjkbc
X-Rspamd-Queue-Id: 94654100002
X-Rspamd-Server: rspam03
X-HE-Tag: 1773035435-27766
X-HE-Meta: U2FsdGVkX1+iv7XYHa/hgdBNvJN23ltv+7RW6kfni5gEeY4AxsEtLIwDs489E77fM6CBZ9RtuuIl0kfGPGaTG//YD8eQmlBERq7BK0qhiWjGNs7Q9NLaVj8/NclVwa4VFH4fwVHYeH6YO0ircZM/7z3yBFotUSdw39Ouil4fkBzk0afA4nscCCoOoUEkoXHmN0+cXc0xuDgu7TiX3an5bD5Qg3Fef4tk3crrBT+gBW49sUZupGrT3ooQ64Lm91+E2ripX8zoRv5eBZJzExWLip+sKqR8Py6EZLs5jPHDxstWWppJrI+dgsu1/7uZFI8HeB0WZy6sWnOxW3AHqXHJhckTcwKng3fzwBPFpGhD7yXW+Gckl2aXFdkkNXmx/hX5IqefyJSIBHAvdjeJQ/t+LlueETuJnUijJil0CIOHC18H9xvIufDGjOdU9kr90su0of3OdvnkREPEiTZT+Lh514C+vNuXMgyhaoeY8cKhoMzSs18t9OwSVGTC3tiC4SxgOeX7/yBQyy9EjY0PKu+DcFC5cWGbR08xo+H9vpuQs1/qHzddN7E+clUtONsKmbiDRGbt8yAP7v3T2m3yxEX5ei/MyT2G5Fam22R4KMDaOOalqXiS8pCiw5mk20ftIPRU+tQEZvoVeUHzkMDCTwz32NFhKhxUsZznvfNvcpoguyCIknrjAQhBNnNwXBQJvtm615afsDPv7fxV4vKriWcFHznpS/J8tVSn8Gl/1wGlG8VHWF9HP+6qAwcVyl0OMz7d2ublNmQjUb1+VwThKft1ZapJCC1mBxiPhnLsJaY/t7PG90J2LXql81Ys8f5lSGpZoDTDW0G68JNLpmWSHxirOlE2z//MUA+gSAzISssHZbhHUCkU+tChwxxaYIPZekjlq5QJ1wFQ5ZO1ulAIGLkWXPo7yEw0gcU6RLIsY44uU+gOhnWFMjuQYUiVkZ1CK29UwNqfppd/y9oLlD31fAS
 iz8eVz8T
 afdvWkGgR+9x1nyJENOb773/F6gcbcqBujBBqUpOdE/xeWJdVpf9akzqS9xJdJIzCz9fOIB/WiMKVZWv2tOL98wIx77KPrHiupTvEMx9DQeloU6x7YvHJE01BiL/FvsjcFhJqBuc6n4BNHtuPMCxAImN1hmTdWnUXzhcKsUxJhnONT+BLzAL/ucvUAE9vb9D00WxXvyjcL4VkTfNxw8MU8DCFfLfcFTGybLnWjLB92+Xnm1q3mnBkPtZTmtc9uc2/tsdF9dXPqYjrfn7ntCcJsr1QKjg4GHfyeXQIBOtaRcS5PH0byFqIxO1LP9zPVRlRYg1IIDWuP3ntHLk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 6, 2026 at 3:51=E2=80=AFAM Hui Zhu <hui.zhu@linux.dev> wrote:
>
> From: Hui Zhu <zhuhui@kylinos.cn>
>
> swap_cluster_alloc_table() assumes that the caller holds the following
> locks:
> ci->lock
> percpu_swap_cluster.lock
> si->global_cluster_lock (required for non-SWP_SOLIDSTATE devices)
>
> There are five call paths leading to swap_cluster_alloc_table():
> swap_alloc_hibernation_slot->cluster_alloc_swap_entry
> ->alloc_swap_scan_list->isolate_lock_cluster->swap_cluster_alloc_table
>
> swap_alloc_slow->cluster_alloc_swap_entry->alloc_swap_scan_list
> ->isolate_lock_cluster->swap_cluster_alloc_table
>
> swap_alloc_hibernation_slot->cluster_alloc_swap_entry
> ->swap_reclaim_full_clusters->isolate_lock_cluster
> ->swap_cluster_alloc_table
>
> swap_alloc_slow->cluster_alloc_swap_entry->swap_reclaim_full_clusters
> ->isolate_lock_cluster->swap_cluster_alloc_table
>
> swap_reclaim_work->swap_reclaim_full_clusters->isolate_lock_cluster
> ->swap_cluster_alloc_table
>
> Other paths correctly acquire the necessary locks before calling
> swap_cluster_alloc_table().
> But the swap_reclaim_work() path fails to acquire
> percpu_swap_cluster.lock and, for non-SWP_SOLIDSTATE devices,
> si->global_cluster_lock.
>
> The first patch ensures swap_reclaim_work() correctly acquires
> percpu_swap_cluster.lock and si->global_cluster_lock before calling
> swap_reclaim_full_clusters(). Without these locks, the preconditions
> for swap_cluster_alloc_table() are not met.
>
> The second patch adds lockdep assertions in swap_cluster_alloc_table()
> to help catch such locking inconsistencies early.
>
> I tried to reproduce this naturally, but the swap_reclaim_work path
> rarely hits the !cluster_table_is_alloced(found) condition. To verify
> the fix, I used GDB to force found->table to NULL, which triggered
> the following warning due to the missing locks:

As YoungJun and Kairui point out, isolate_lock_cluster() will take a
cluster from the full cluster list. When the cluster is isolated, it
already has the ci->lock. The cluster should be full, all entries
allocated, and the cluster table should be already allocated. The
ci->lock prevents the cluster from changing behind us.  Forcing the
table to NULL in gdb is not the right way to demonstrate triggering
it. If you still believe there is a bug, please demonstrate it by
providing the backtrace of the execution flow sequence and explaining
how the race condition across different threads/CPUs caused the bug.
For debugging, you can also introduce arbitrary synchronization (e.g.
spin lock) in the allocation code path to force a wait for the race
condition to happen, especially if the race window is too hard to
align.

Chris

