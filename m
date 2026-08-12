Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60CE5C5CFDB
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 21:42:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 489B96B0172; Wed, 12 Aug 2026 17:41:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43A366B0175; Wed, 12 Aug 2026 17:41:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3550F6B0177; Wed, 12 Aug 2026 17:41:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1703E6B0172
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 17:41:59 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7E0FA802EE
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 21:41:58 +0000 (UTC)
X-FDA: 85093940316.27.977C3EC
Received: from mta1.migadu.com (out-3.mta1.migadu.com [95.215.58.3])
	by imf02.hostedemail.com (Postfix) with ESMTP id 283C580003
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 21:41:55 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eM67pAkU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.3 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786570916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=32zE9UxQc7MlRCAQTkE3gRvYDAzRK0TQaYBKoF13bI8=;
	b=OQ2kMC7JPKmGM251oar/aRIrVLwLnlFnrpV8t2PCQnQXaXvoO9edcIW1iHNeREjdbdweeM
	a54XSk8ssZz5zxFdSRRiGLVrRNOInV5N5MhbdVQ98sp3M1qirOT7fWryl8Fa22GKPoapyN
	oyKUfkEz0fA1YPuDLihutPMDcxAgbEg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eM67pAkU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.3 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786570916;
	b=mctpDL+1nMTBcjKUQxB4eXM22hfmIx6cTDBHB+78rrVApxYN0qg5bXWX9K5R9JmXyrf89U
	nuwDRYEUq2APDpSPxTYCV6vdmsGnrhGL2jizHxepAsy879v7nmtnlOijSjLGEOcoLTS2nt
	kEvMg4/wt3NAJpLxajMECLWie+YpQIU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=2F5NhUpezBCQsHKeIjnstp2S/raV+rcTxDfwPc9Xn34=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786570914; v=1; x=1787175714;
 b=eM67pAkUUhF8/me/ldGi3bvDUWGNU1Pd9opNRMcS+ebTYCsoa3RarEcx+NjIVgRds9QYw0QL
 TKPCEmIKLwRZ5RsUTyFMoJdJnyS5/k360fnv4pmha4VxLR/F1Bmii8G8po19QfbzDOqSlN0UqIo
 02kz2Dfcqvc84NTYdbHL4JGE=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2a03:2880:10ff:48::)
	by smtp.migadu.com with ESMTPS id d28f7b4220e49d71;
	Wed, 12 Aug 2026 21:41:54 +0000
X-Migadu-Flow: FLOW_OUT
Date: Wed, 12 Aug 2026 14:41:49 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: syzbot <syzbot+12ee2725d5fde63a9c96@syzkaller.appspotmail.com>, 
	axelrasmussen@google.com, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	cgroups@vger.kernel.org, david@kernel.org, hannes@cmpxchg.org, kasong@tencent.com, 
	kernel-team@meta.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	mhocko@kernel.org, mhocko@suse.com, muchun.song@linux.dev, qi.zheng@linux.dev, 
	roman.gushchin@linux.dev, syzkaller-bugs@googlegroups.com, weixugc@google.com, 
	yuanchu@google.com
Subject: Re: [syzbot] [mm?] WARNING in set_mm_walk
Message-ID: <anzojtrifviGUjLN@linux.dev>
References: <6a7a6929.b50370da.49fe0.005e.GAE@google.com>
 <6a7c6670.3668565d.e8814.0012.GAE@google.com>
 <20260812140358.343927ad8d0955b67c4e7ad5@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260812140358.343927ad8d0955b67c4e7ad5@linux-foundation.org>
X-Rspam-User: 
X-Stat-Signature: wjstw1a7q5dadfzjk14n9ay1otddteqt
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 283C580003
X-HE-Tag: 1786570915-795094
X-HE-Meta: U2FsdGVkX18MU5JzzezgQg7jzmt7c8cNPPCkpB8i3pkHf2pFXezVw9rF6q+HZ0K3OA2JAl2eqgs0ttaBdab6QSsXniVFEtbNiVZQUd4tkjDh/MZ1FJU3jrQm2Tr/OjadTIa9b3salFqExSisNe23C6GsZnVOpDJw9iiTX1uk1QfiWzBkR4ijInM4v0qOBuTgANCDF3u+k1dkTEraglLKHG3fshGqTFv6tN0Fw7ZEA6TWWPLM9mhb1J1tiPK0PWruzdavn0D8esj/+lhBt7QuG1LjPBzh0tJrLlMVLRxBhRp1vDt/4iG+5R3RJ7vf0Q0L6gj5H7+ftxTlnsw3fyupqIf5T3MdH3wzzfZLbSHrx9w70qlxyESQnGt6jJkkz8mIwc9t3ZHjqUJ6hKD74nnXQFD5GxBvIxL/GJljFKj1zRmpOoIYkJXUq3W+V3QgdpEeUl6hUUHQ8IgJU0rKCdGdfSsBU/YD3ciEqlqb/qMnEl95M8fqv53q6wYR01FHh96tYa1WPRHcUylcsithByzqK8l+jjKozJqT7C3aCWytflnWJTBMBZeNjVkFyByNwKUnIx2WsM4XWdM/gKUkl28WQDqLfoCUSXlvXmSUQRzNJB0EAXSFA1HxqfbkkyJYkFJgtZRWBrwyRjJDgS8DFsBE//Y3vCaSS3YI84pS1mkqSr4E5PH6R4W89RG0+2R8UMGGyTBsntV/8Qi5luCjX8PFiRUcVwA1XvUtryqzBkRh2EpEliCirvNh2sWXMaCiQ0sxvFVIGqQLeEIR138Es1dbDUF5ENCCPlpYWLCzPlJD48QuDZrrGecWs0d/FmduETZqKUYAMr+91Ya4EYuHFsvgs08fVkEOCKM0mWGtrVNnkmXtxQ7nULTRE2VGsucgEmyJaQm0Bh5mu7Nm2GMDOxo/V6pJoe8WKD+wZDWT4CBhjAgA9HlhDk+b8DSSh9WDw0Fx+yqDPmJz3zfsupHO/7n
 zo9G+4Ml
 FWacCrMoFIiHPq1mOnKGp1hA6bRFZIk8gTTTquFIDbL+yn52n5KA6vZCgzQ2boZjRWXWimokIw6A2yGQEdKhPCiYPqSeFUC8S2CGmpo3bZRVYX3BDP+6ZOQ9AEDR7ReINFsT4ASBjVpnTiHd/tHVC83lvZ4ml5rAajO0yRGYfQaMGtgS7Abamj9oTahd5l1E5irlhpsNcvS7UsbeXYLB8zrlNtx2eqbb+S0pEp0sXKGnUUSjSfBJZrrrcRt5uVRgJMD6oaZS1fLAUscqfLc9s3WttMWmVtCdGjeprlqvHs5JfmoKBFCOBpGq6iDWAgKXOx3ntqvoNzGbNuEvr4gEHzx4hODmvY7gYWbL3C40scSEhF6Yy5Gvj1vi9yTw1DAM1ljv4pGvwQRQ/80osnOTLYGH8FTXuxaOCl5Ow6CMBDiu38WQPIguIJBx9xZGDC2FX0HYM352y8g1RvVApLGYx50gD0+OvkF+0QFoQAKDbuJ75LXWSDI3Oul7XqygAj0NxqwHVlsiTDdfcscbRP18LIwbUYvz4FQJSmyPfYggn8lPbwLq4OWdU5vhrGzNPe0I2p9iVqOuwKKv8eSGft7HdDTeL7tDxkspfzf4qqZ2HqAp0Wh2W51UvuQ0AapmTlpajynIPF/1tKAZ5REmjWm9epAh3Jry3uRtF3JqYX+g/SMckN4nXK2u+4q0Jb4XUJHvF5KMvFVrf7eipKe1sj8+6/He7KswduJg8FB8iO8maEKM1Prd/x8TRt0Awy5LCgM/oh2zBTbmeTMdRB86MCpZb25dvM3FF+SZWiSbGauetFIVVH14=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12, 2026 at 02:03:58PM -0700, Andrew Morton wrote:
> On Wed, 12 Aug 2026 05:26:24 -0700 syzbot <syzbot+12ee2725d5fde63a9c96@syzkaller.appspotmail.com> wrote:
> 
> > syzbot has found a reproducer for the following issue on:
> > 
> > HEAD commit:    f5bbbfec59b4 Merge tag 'probes-fixes-v7.2-rc7' of git://gi..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=11f44c79580000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=c44651ea7dd2f307
> > dashboard link: https://syzkaller.appspot.com/bug?extid=12ee2725d5fde63a9c96
> > compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10d11149580000
> > 
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+12ee2725d5fde63a9c96@syzkaller.appspotmail.com
> > 
> > ------------[ cut here ]------------
> > current_is_kswapd()
> > WARNING: mm/vmscan.c:3800 at set_mm_walk+0x210/0x270 mm/vmscan.c:3800, CPU#2: kswapd0/111
> 
> Thanks.  Shakeel is working on a series which will fix this by removing
> the calling code.  But it isn't a minor patch.
> 
> Shakeel, it would be good to have a backportable quick-fix to make this
> warning go away?
> 

Actually the first patch [1] of the series will fix this warning and we can
backport just that patch to the older stable kernels.

Do you want me to send that patch as a standalone?

[1] https://lore.kernel.org/all/20260811203203.3456029-2-shakeel.butt@linux.dev/

