Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 903D4C624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 15:31:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 598FB6B008C; Wed,  2 Sep 2026 11:31:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 549C86B0092; Wed,  2 Sep 2026 11:31:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4633B6B0095; Wed,  2 Sep 2026 11:31:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 28BB66B008C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:31:50 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B02FBC026C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:31:49 +0000 (UTC)
X-FDA: 85169212338.10.0FE8E18
Received: from mta1.migadu.com (out-244.mta1.migadu.com [95.215.58.244])
	by imf24.hostedemail.com (Postfix) with ESMTP id 69AFD18000C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:31:47 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=swoV9l9Y;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.244 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788363107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VldnDiGQ/mI/c2rmsWiz7o4B9kg+zdXv799I/nlAbs0=;
	b=UCF2nBM1Hhn8LJfj6OEkU7+7QBbZ8NyU+iW467KBKA5dcAHPM7oNtckeYIW4T7PLTDLDJk
	Wv3dPSqGk7fIc2X9vzi2PKIp1t0aIDeWHei3OTInZL4mKEJWOAnSp4hg3D7FOCj3DW0mj6
	uQYU9C+F0l5+L5i+dHj9x/eRWHrqN/g=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=swoV9l9Y;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.244 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788363107;
	b=ZdIqAwlDeAJjH7l1j1RakjLZCyicc3aIkKlfYL5QoQ6BhzQ9Nv+cs6BJ3v7fnUJ5KYctAe
	HSSXu9hqBnUg8ZYE1BjRdPK3LqVceIG38atMnbCd71NlM5nQTjvs8Gvv1IA9AZXuE+eMso
	ERyb3FNatrBzNhSM/sImBolcesj2mz8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Hiru+gE5U/tTPNwMNfjfi3EaG0xWxlNq2qi5LPCEe18=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788363105; v=1; x=1788967905;
 b=swoV9l9Yio1mlNL29YUx6wmKu5PnLWNdnzH/Pyo9VE5WsT0UyWPythPJxDzE8T3DwW4V7gZ0
 tmmdpF3ZSmv0wXWZDmQXC+Wfzl/zvYXgKkPQCCelh8UJo5T5terFKy9pZuWRuWaK6Glddb8VhfZ
 RmKfiL+CrtaP+FaoEGDjXdVk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 8935c3cd496893e1;
	Wed, 02 Sep 2026 15:31:45 +0000
X-Mizu-Trace-ID: 8935c3cd496893e1
X-Migadu-Flow: FLOW_OUT
Date: Wed, 2 Sep 2026 08:31:44 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: brauner@kernel.org, djwong@kernel.org, cem@kernel.org, 
	akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com, mhocko@suse.com, 
	brendan.jackman@linux.dev, hannes@cmpxchg.org, ziy@nvidia.com, david@kernel.org, 
	qi.zheng@linux.dev, ljs@kernel.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/4] mm: replace PF_KCOMPACTD/PF_KSWAPD with
 kthread_func()
Message-ID: <aphBHnm7ejNM3aNR@linux.dev>
References: <20260902131653.1338227-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902131653.1338227-1-wangkefeng.wang@huawei.com>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: hwqomyg8rbh4oe54hke1oi3xd7aognj7
X-Rspamd-Queue-Id: 69AFD18000C
X-HE-Tag: 1788363107-812148
X-HE-Meta: U2FsdGVkX1+hP7crG52K/niovbzUo07qU6S//rwkREt0ZalINP8t1L8Q5n8jkCw229gH9sQuTldHdFyo9oYPAodueajxg7Yvo311skAbud6mCUficbv7IO180JRvLFHy6W9d58SXv4Oz1QUDaAW3q2Wnjb8ln67v+thy26scCcEnuPBK1+woXNjL6EqxUDSGXlcb+u3O9AYwwhgoLO/Ts2G2BiTxy5GJ/c7yLBXgzGYEDjB5fHUqOTaojmK6RJwxJwUx9vFCHzD5fFQQAbdztY1RbrRy2skt7Uz4sMnr+h50AQTft+FW5WZg/Q2FyUCjxRMoJSpBkg8wEIoRp6Rsg9pIjP4+iEeYhiOHt6iRuaNiHGIQslcsn0J3/FbyAhVspp/NQKx8MExaLQDFJpSnL9tHEwov3mfQRetqr5etKzs+Ji7fEFN4uQH2RLAMCSDNEDHvKhvydd+U4pCiua4R+6Pe0XtfC1USw1+XPW9XVLzpfoQ+oPu6yZyfaxw1UgaguB3o8q8+Z8AaMB6GD/eWgUMYCL6xfNeBq1t2Am8aDjtR19B+J77/MHMVDs0AUAoJUfQCWAv4Bvr705Vak0IJoku8h99YYPe61nFsHJQaX3igV7Pq/WJC0VvXjq4TiRp1f/UFgJRIF8flRbDU1c5kTOe0naGuQi4GtiqynhrwTFDEBDAILJdjVGIFI7BYAI/lhirop7D9SGlLCLCG11iBOxDzqWx3mu8CI6orRdhvRNE9nrJtORjGqCAyf1hzG/Vt9D1bckl6f3ODsiqtE5R3lLqgwbJaHkG99+giE1ffAqfTSnZjRc1+hLCaIqX8iTuCcELQD5wCj2/tdm69fjYFkB2dXdlE7CZ/yA1kMoxFcLjecAsoHAgM8lSQ138Ye52OxvY8RuKNHEj+TLGgPVdi/ttn4pgmzqMTb32A5BOSDtfFiRI4T3dQUASWHRoeq2cPjTeO+Qtk3jyfDn2RopE
 j20IuUeV
 F0tnO0CsMf4/1VorphI1aZIAdNhrW6IKavhVbaHalpsE4LpmruSxTfREFWYHHhBRLHkaO5dkFD55L7Rfa6txI/fddl29QplzDxaMUdQe5pMeSBoVHGMVVhMXDswSMRGkHyem2WTBxHC7NlKHD6f9XYw93nnTXv9UQRO6gIDHkwh/xtJYNBMKJKvjjRqkXx0wsGzjiec/4OQqnsyVD6H5HKOOf5pS4usE6ObC+zw+PjxIoeMnLPPDjCPdXPl7Nw83XHVd5CHrNc2be3DnIR5/0GdlA35vrpykV9ZtgDz+opFtqKhghYaRDn9dQSXJld9QF364u
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 02, 2026 at 09:16:49PM +0800, Kefeng Wang wrote:
> The task_struct->flags field is a limited 32-bit resource. Two flag bits,
> PF_KCOMPACTD and PF_KSWAPD, are used to identify whether a kernel thread
> is kcompactd or kswapd. Converting these to use kthread_func() frees up
> two valuable flag bits for future use.

I wouldn't call it a limited resource. We can have more fields in task_struct
but I like the cleanups.

> 
> Kefeng Wang (4):
>   xfs: remove dead kswapd flag inheritance from btree split worker
>   iomap: simplify writepages reclaim guard
>   mm: replace PF_KSWAPD flag with kthread_func() check
>   mm: replace PF_KCOMPACTD flag with kthread_func() check
> 
>  fs/iomap/buffered-io.c                   |  3 +--
>  fs/xfs/libxfs/xfs_btree.c                | 18 +-----------------
>  fs/xfs/xfs_platform.h                    |  4 ----
>  include/linux/compaction.h               | 11 ++++++-----
>  include/linux/sched.h                    |  4 ++--
>  include/linux/swap.h                     |  7 +------
>  mm/compaction.c                          |  9 ++++++---
>  mm/vmscan.c                              | 10 ++++++++--
>  tools/sched_ext/include/scx/common.bpf.h |  2 --
>  9 files changed, 25 insertions(+), 43 deletions(-)
> 
> -- 
> 2.55.0
> 

