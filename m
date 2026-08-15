Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05D83C5CFC1
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 00:48:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F03976B073F; Fri, 14 Aug 2026 20:48:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB3A16B0741; Fri, 14 Aug 2026 20:48:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7C2E6B0742; Fri, 14 Aug 2026 20:48:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A646C6B073F
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 20:48:52 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 34A6BA02E7
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 00:48:52 +0000 (UTC)
X-FDA: 85101668904.10.BBC55EA
Received: from mta0.migadu.com (out-221.mta0.migadu.com [91.218.175.221])
	by imf22.hostedemail.com (Postfix) with ESMTP id 19546C0004
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 00:48:49 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="M/iz1KRZ";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.221 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786754930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RqnE69uQywPoAu63fy6IqdJ7L3LylRRMzmAIeCZ2SVI=;
	b=uT1Rfb/glKSyImMIEvjYVzcEwjlJCllZoOSkACMrDx8BLE89pTJuZ66GE+JYCYey+gTB6s
	ZEml6MsutF4w63RHVBiYjg8dfg2EYAoHcLx/N3ZMZYtKGVBQTVDGruLjWZY1knKq+xZcNw
	SO29iZGfOyU86NsgIzGmZn4ZjPKI0QY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="M/iz1KRZ";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.221 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786754930;
	b=tSu4szobfIb5G6GMJid2inGnM/n2pAhp3xkDauzG4aW8Ia5pw392TQTUMi12VN3Rk8RGs7
	CIkeoeUq2hn8Zb7nf49HEd0vpn8R8UyCWJ2HtTdSsasmj5d47ilGSMoy8y0ieBIgzuWKDo
	1oYHTREW4LY5b5q/fmVdX2sIDtdX3T0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=D2tHr41vvRZOGh8CfotiS63LZpn9WEESIso0qi3hUnc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786754928; v=1; x=1787359728;
 b=M/iz1KRZ0lTqKQZPuHWE8x3SeGdOLunKWprCkF0Dgj/TsGb/fkncKsgqGHuMZGCmzFBiyPnL
 cT21e0jdaxqQPpW59MxViYonn4zSWPT7iufa4AqAiBX7/jlJZR9VmmN7AJgK46C5NETt0zUn2Ny
 9VpinGuAWToyq70d7paTn19U=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2a03:2880:10ff:12::)
	by smtp.migadu.com with ESMTPS id f2405bb7f12b9bff;
	Sat, 15 Aug 2026 00:48:48 +0000
X-Migadu-Flow: FLOW_OUT
Date: Fri, 14 Aug 2026 17:48:47 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-7.4 0/9] memcg: remove the v1 soft limit
Message-ID: <an-3Ssc22Gm4J_Mb@linux.dev>
References: <20260811203203.3456029-1-shakeel.butt@linux.dev>
 <an2HYmJ57BCY_Zwt@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <an2HYmJ57BCY_Zwt@lucifer>
X-Rspam-User: 
X-Rspamd-Queue-Id: 19546C0004
X-Rspamd-Server: rspam07
X-Stat-Signature: srewre77ktyi7h9uq6gkjk8mtsr8rp3h
X-HE-Tag: 1786754929-250855
X-HE-Meta: U2FsdGVkX19KkNjRK7IUGoJjHcJpbvEWTEKdHGwXC0vJmof4q6Fq8x1Yy4smSoKCgiiGlEpM5Nh/wHKjlx1uU6QRvpunYzUH9VKerHIYqXYh1T7FxdQSI/objbDh0vkfULHVIFZnV9ad5WK/tcxxeSn+6u9DHoHKezqCrs9kC5mPti0m8NlyeWKJ3SN5GMvrnGqka/ILF0VGsB/G3YXYWKVYAxJyxJVdDqHMOSGnuUHhZEJznbvLeW7sybrmJIf2clcgK/y1G1SOGjHVd/74EUtoOsr4GhDQVgtIesnealS5BUQdjZV1eTDGkpgC3I3h0Vyn9fGLJPa0eWnoSR+carnzNXFrtDPWOepldtncBx5nyihVuX3yK/l2TQ7CFvZgwFPxnkjI93giOkI0JQhnhZ2XKyOJHZ3wFNkJMaygbAt8HDsFMi8G8XRiw5AX14f1pWVUukOKecOOHPwNnyjYSdRPTIva5oHCLzvOKv2DNdMsmUQIm975jX3UpQVvwP/G3BrEHq0NqguqdCYVC2HMOfgOXEo0b7w8ggcyIZh88qym52T3XNszUQEyV091gDMQs6787dNXrcQF4uuD0jH/KrnWxb3GVL6mWT8+lt4VeYsfp+WNHCYaGMub86+oAckDryvoRYL4R3SzS1UfbVBthXZvLKG3ZxKaDP+1QWjkMZNmoMvPht+9RxyKsb7A9x3FtkSZTLlF6+q+WEdhA0TNBEkd/2QvUKRhrn+koIKQT3TQp8yk1xVYmlw6eahLSkH0Kgwh0+xIcSyIdSJXvJ9EBGyiuJboc1so3iI55EuN7aCegdvA8Oe1/CUlg3lhuHwNKKm4dbWLgLggffyjcsSD5Gs/xJnK/PzMwxv4gi8hggsTAmkn728tCmdtNXVScHa2CE6UP7QPdhfrpQyWwcy71rQHuIJUpaU1GHk2m3QGd7FvYcv6pE+mQVXYG36i5OBsNSX0gSD9WPtU/syLbki
 PujM1yVi
 eqQVCtBL4anTIcQybxAJea5LE0+qcEZI2YNR+1COBtCttK5Y1ElcUaNBIx7UJJQPcWpiWXl+Eyc785AYuwL763QHFjzk8O5Ui31P8ccrD7qW7m4fb7XakA9i0FGiV1BfB3AIcYnq5A6Umi5ChTDyuKSZDUuxt3pCuCTiPYba+N4f5DqDcIi/uoVHAVYNFOEjnvwQPOFAU77NL+znQl3LiwcX/D2zjtfWrub6WGkDj3MKmP/MaTq923g3q6aF/5jh9ZkEMRKgqHLM8cjs30J/vITs7rS3D0lqitCLaADIxWDQoPDWiKRYPVPsprKnNwTlirjwwWstfnkSnVVhoMnxbZ3HU4LWaor5qiY++/uPTiHHNjH4ksxgTTmfOcw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 10:27:09AM +0100, Lorenzo Stoakes (ARM) wrote:
> On Tue, Aug 11, 2026 at 01:31:54PM -0700, Shakeel Butt wrote:
> > Syzbot reported [1] a set_mm_walk() warning from kswapd. Soft limit
> > reclaim is the only thing that runs shrink_lruvec() from kswapd with a
> > target memcg set, and thus the only way kswapd can reach
> > lru_gen_shrink_lruvec() and in turn set_mm_walk(). The offender,
> > mem_cgroup_shrink_node(), has long carried a "Only used by soft limit
> > reclaim. Do not reuse for anything else." comment and a priority hack,
> > and it simply never got taught about MGLRU.
> >
> > Rather than teach it, let's delete it. The v1 soft limit was deprecated
> > in v6.12 by commit 569c4f62d84a ("memcg: initiate deprecation of v1
> > soft limit"). Nobody has reported depending on it in the ~21 months
> > since, and v2 has covered the same ground for a long time with
> > memory.low and memory.min.
> >
> > Link: https://lore.kernel.org/all/6a7a6929.b50370da.49fe0.005e.GAE@google.com/ [1]
> >
> > Shakeel Butt (9):
> >   memcg: make the v1 soft limit knob inert
> >   memcg: remove v1 soft limit reclaim
> >   memcg: remove mem_cgroup_shrink_node()
> >   memcg: remove the soft limit reclaim tracepoints
> >   memcg: remove the soft limit rbtree
> >   memcg: remove lru_gen_soft_reclaim()
> >   memcg: remove the per-node soft limit tree fields
> >   memcg: remove mem_cgroup->soft_limit
> >   memcg: simplify v1 event ratelimiting
> >
> >  .../admin-guide/cgroup-v1/memory.rst          |  49 +-
> >  include/linux/memcontrol.h                    |  27 --
> >  include/linux/mmzone.h                        |  30 +-
> >  include/trace/events/vmscan.h                 |  14 -
> >  mm/internal.h                                 |   4 -
> >  mm/memcontrol-v1.c                            | 435 ++----------------
> >  mm/memcontrol-v1.h                            |  12 +-
> >  mm/memcontrol.c                               |   7 +-
> >  mm/vmscan.c                                   |  96 +---
> >  9 files changed, 66 insertions(+), 608 deletions(-)
> 
> This is a gorgeous diffstat :)
> 
> Obviously not my area but looking over it, all LGTM so feel free to add:
> 
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> 
> To the whole series!

Thanks for the review.

