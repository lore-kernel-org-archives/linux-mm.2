Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E781EFB800
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 05:44:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74E046B009D; Tue, 24 Feb 2026 00:44:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FB976B009E; Tue, 24 Feb 2026 00:44:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6073E6B00A0; Tue, 24 Feb 2026 00:44:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 49BD66B009D
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 00:44:21 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EDD68140468
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 05:44:20 +0000 (UTC)
X-FDA: 84478259880.23.8559244
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf05.hostedemail.com (Postfix) with ESMTP id AADF3100003
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 05:44:17 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="e6L8/GT1";
	spf=pass (imf05.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771911859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UDiN5/pgIKNGFEPeeKgrUiwMTxAa7uwUxPs6Mze27+s=;
	b=6uYIy2uo5AWB4Ljdl4LtaF4eo81bOoBKVNVDPLIEd+FKdpFOSsuGQv2aLRW1mWH5A+uGL5
	SkKUvm2JGw1FOOprCO3tgMtqstRa9FhHY2AcxcwGvwfg0vWCgD29dv4JF8h4ToWHFqvgt9
	5JWJ12I5fSYtq97Bga7Wu2EnEt5+OeY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="e6L8/GT1";
	spf=pass (imf05.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771911859; a=rsa-sha256;
	cv=none;
	b=Quc87PL8I4mgVud9qh4BFsGgk66aQ2DpSMNkvGlpNWi+n5FTv27Wz5x5xyx0VXIl3HFqtI
	CMrrh5Lnujk46dqYh0Mqw0tQIvbXpKJYIZkGGHRIKGu4QRU+WF/STBdPe22+4JhzQPpQni
	x4jsRq52UkHwNGSx5c7XRT6jXYWRhLE=
Date: Mon, 23 Feb 2026 21:44:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771911853;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UDiN5/pgIKNGFEPeeKgrUiwMTxAa7uwUxPs6Mze27+s=;
	b=e6L8/GT1w+S0WHuke+elD6HX1fCEaenrz3zCvyh3NXASLHKqK9yOcMYaviWPPxQ9i3CM5l
	S3uG94ZZqGDNz2MHWTWR/eWKsrNBV6PzHFtCZXDUEKKGD6SKd9YvxkeWJdzfjzqwm2nVnH
	blglS5BubzOu697v/+JyZGkuED/kCIM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Barry Song <baohua@kernel.org>, Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH RFC 06/15] memcg, swap: reparent the swap entry on swapin
 if swapout cgroup is dead
Message-ID: <aZ0oXHNMe7_3P9OT@linux.dev>
References: <20260220-swap-table-p4-v1-0-104795d19815@tencent.com>
 <20260220-swap-table-p4-v1-6-104795d19815@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260220-swap-table-p4-v1-6-104795d19815@tencent.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AADF3100003
X-Stat-Signature: iwb9sphu81ugjnbou9jxisubtmm3oke6
X-Rspam-User: 
X-HE-Tag: 1771911857-739583
X-HE-Meta: U2FsdGVkX192oQJQYsmhbIWAfoaVgLkP1JeTWbMl+BUoA6LfgMG02jPg+lJ1EnIZBWcm1QubdwQGB/pL9YVsitnQXC6JLCLWWdYvFy4nX7RMbQFkhNiw9fAvl5gk4bVmGyCtaGJ/wzfyO+gM0cvgIB8A1IWoVz/ClIpwVJQiYewn8PHjC8a+zQLBOW1j3Q0biL3/LBgiRvwiv2h2TV2eOue8ye1rT33K83ou6FO6NpzxozznGW35avO5ClJisQTEWS3fM4qYK2crrBUP3e6U7Pswz3IilqLEszUF6ZTBczsYreOXK9lKLZKjGX1pBBseSecfwbfwkHGSkJYpC0qxNQ/6BvF/AUlKMNr808om+1cSwinLtr817lfgT8MPCNNvbocb1+2GlZCpK+gm6pt0Pq1qr1PweEiUwpR00h0YiXJ+caPk0aFpZMQYhkVBLJ0zRXdDAbaosODxL42QZq+WiY2GphWKwMakQbI38hhqha/vrwNECNk4hW6PBxHHXXZ8XFT9O7a/ElEtcCvURXqYI906WRuOBl1PcRwX+K6NTrT5j1uhL6pMUjErLXTFOoDvB5Dp5WMVB0abbKYSWLhJgYiOVK7jxj4WzsWxZ9aPMmPKtC0AYTCLk6jwCs3V8EJKFUbG1rFcm11ZP5KPCGo72rgIH4ic4YoCXwl5oQ0jDoFI92GCy0tav8KT9rnzihYFiMWDdk/f23r+/8s1XPgTBvNe21GatS2PgLKEnBEywq6Q484M3dSu0M/th9wLf8GWdQJm1BgrmlfVWJ9sfXUwKgpVeflj9wDSq0hiLdnl/f4umiRIm/Zk+/0EzfbRhybfmRb1n0yCjqws0dApveMrGCRFDQFCEY0ZZxp/QHpCCH3OWWhbEu7t5g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 20, 2026 at 07:42:07AM +0800, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> As a result this will always charge the swapin folio into the dead
> cgroup's parent cgroup, and ensure folio->swap belongs to folio_memcg.

I directly jump to this patch and the opening statement is confusing. Please
make the commit message self contained.

> This only affects some uncommon behavior if we move the process between
> memcg.
> 
> When a process that previously swapped some memory is moved to another
> cgroup, and the cgroup where the swap occurred is dead, folios for
> swap in of old swap entries will be charged into the new cgroup.
> Combined with the lazy freeing of swap cache, this leads to a strange
> situation where the folio->swap entry belongs to a cgroup that is not
> folio->memcg.

Why is this an issue (i.e. folio->swap's cgroup different from
folio->memcg)?

> 
> Swapin from dead zombie memcg might be rare in practise, cgroups are
> offlined only after the workload in it is gone, which requires zapping
> the page table first, and releases all swap entries. Shmem is
> a bit different, but shmem always has swap count == 1, and force
> releases the swap cache. So, for shmem charging into the new memcg and
> release entry does look more sensible.

Is this behavior same for all types of memory backed by shmem (i.e. MAP_SHARED,
memfd etc)? What about cow anon memory shared between parent and child
processes?

> 
> However, to make things easier to understand for an RFC, let's just
> always charge to the parent cgroup if the leaf cgroup is dead. This may
> not be the best design, but it makes the following work much easier to
> demonstrate.

Please add couple of line on how will it make things easier.


