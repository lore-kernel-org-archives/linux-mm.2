Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CED46C5DF77
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 15:55:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A165C6B014E; Mon, 17 Aug 2026 11:55:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EEE86B0687; Mon, 17 Aug 2026 11:55:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 904026B0835; Mon, 17 Aug 2026 11:55:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6DE346B014E
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 11:55:30 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EA398160755
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:55:29 +0000 (UTC)
X-FDA: 85111211178.17.FC01291
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2B36720006
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:55:28 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=ri+cHTNf;
	spf=pass (imf31.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786982128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=48TIkL8sUSQum4wB/ysMBVLF/EysIA6sIeFfAUMacVI=;
	b=Zk9taPKLu/PfmdVk8WRRl2mlxUQfwk/Z90Crb3asN0IZkBUR7/JIIjVt8SKYYxTP3U0UzU
	hVon6eXQ5O/8EQU3yyLL7kbPvUmAgBCBhV5wvmqnlCauAKNzw0CZKLKML7BsyPCgXuaOHn
	AurJqXSsTuWS8BuLtTVOjVlvNOLjpzE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=ri+cHTNf;
	spf=pass (imf31.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786982128;
	b=PjB92EA+F1UidDe1R3fL/bxyDpB1OU6bKZBgMZqzdr8qzkEBWYe4V6lQ5etW8gnzW4Os42
	l3XHE/iR16pKcVbvX5DDbKUrO5+dsKZdjVAWNZYHtsfAnuD9RCh9AsLYpM3HTH+N3Qdz29
	CwC7T1pYAoA2Wc6IRp37JgEFbpRCZ5w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 44ECD436EF;
	Mon, 17 Aug 2026 15:55:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7F2F1F000E9;
	Mon, 17 Aug 2026 15:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786982127;
	bh=48TIkL8sUSQum4wB/ysMBVLF/EysIA6sIeFfAUMacVI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ri+cHTNf8pTkaYcu8jGgme42oh1ywbHOIQl3X9aABqkYRkrf9HMT5pIRLwUApQcR6
	 vNND6mO3wBrwnghWLHdvMfK9SOQbrAhy9TZ0LFGau0B9QDnO7wDvUhr1I7HKpOxqKY
	 3Y9NQwUxiwwqdV+E74TPz5Nr4/3npBUTt7Qj67t8=
Date: Mon, 17 Aug 2026 17:55:22 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	syzbot <syzbot+805630f1453e490427fa@syzkaller.appspotmail.com>,
	apopple@nvidia.com, byungchul@sk.com, david@kernel.org,
	gourry@gourry.net, joshua.hahnjy@gmail.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	matthew.brost@intel.com, rakie.kim@sk.com,
	syzkaller-bugs@googlegroups.com, ying.huang@linux.alibaba.com,
	linux-usb@vger.kernel.org
Subject: Re: [syzbot] [mm?] WARNING in ep_write_iter
Message-ID: <2026081732-unaltered-regime-f91f@gregkh>
References: <DKQP5QC9XTDJ.3MI016NP0NPFY@nvidia.com>
 <02c2e5c7-0d78-4763-90ff-75fa87105fcb@rowland.harvard.edu>
 <DKQS9ADYVLN1.246LJPQ9QQYVP@nvidia.com>
 <9787b33b-b30e-4c5e-a0ee-7f14515c7166@rowland.harvard.edu>
 <DKQU9SQUIKDR.2KEZZPONJ1IJ7@nvidia.com>
 <20260816194213.0e813ed338144ebc81ed4050@linux-foundation.org>
 <472add4b-f16a-4b87-bbc3-98c8aa385cf5@rowland.harvard.edu>
 <EDCC14FA-F7D8-4F72-B780-37D09E26D16C@nvidia.com>
 <2026081745-unshaken-retread-d744@gregkh>
 <1ED81A86-22F2-415A-8CC0-7E9B4A4446C2@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1ED81A86-22F2-415A-8CC0-7E9B4A4446C2@nvidia.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2B36720006
X-Stat-Signature: bjaw543cccx3xi97onokduwihjgus3yw
X-Rspam-User: 
X-HE-Tag: 1786982128-508027
X-HE-Meta: U2FsdGVkX1/EVv1uhjLb/Wop7z1DMBGcUCzh5paP6HrBci10+v9OkUuhM6SqUvXvzq1FeW1l/bEmyN8znPcWfPD+GLUM/pGpoku1jiBZ/QLaKiDOIKD0LzCDq1gDwoJ2j+gjoMkXpLVIzVIpZ/WguWfubq+8nXup1Uk7FYm0uoh34Mj9KqitO8fJNipoLi40gzvGW0RX0b2RcXeEY2uJIMLEY+Owj5xoHaHhmztsrtayk6/x69/Oq2vY4bgEbDbyfi436aovKGCaGW+oVBoSBPDGOvyhj8IDCatBOXL8ivM0JXCBkDi4/tbiRo/FfzdTIWHHeyHMrkWTgW/eHwuP7wMz8ZmU4MXCxVnBcRlVxjjqnhAxKbpPsqT3Wk8OUf4tiBcC99gHaR574oQtEIHs+0+41wEISIHbjvT0vml6q4Es1uHGUYl8KiyO2M+AAr5tkSoQ4MkCUx+NCAoeuC/wllH3GSzomrLIvo88RdGs4vAXbm75NunF6s8EcwYYMlwAs1owveplY3d01rCb8aXKjr38XmSjAmy6psbwAZ8OeK3+ZhJ7sRBUUElI95w0JaHUI4mmqLtZ0fNdLOv1bzo9UPWrBwQzhvGycikTSHeuqbBDF3nqqPyrrZIohtIXlp03F3aowAaUuU9rz+ubKOEQPxYttWReZventZjQZtdnkEBSf6nzLiPMCiyJqhuz+8hox9/jbC9waK6ffa0VWPKcRvdkwDV0M+cia5tRfy7CxC+iYk54YUktiXMbibKfq8Yfj8dhsiS048eBw6s2OT33ZGI98tLM9X1kheRaw4TQjlt03WEe5JtoqtH/lcSCCZEPLBg2ZvNWjl6Z4xDyS4o8yOEl4GyAEPEyBOJ1uuVaufgkoUAzCp4q/79zPN+ylyHP4m5gQL3kfwbus6PXOvDFrYciWudh5Bq6A3rxjFiTXBUPkvF54X21PDl3lYey8JSsQ96+w6CgtlWRmrbF3s+
 nVhGOHYM
 M9hHJVwOj6+frCyTD77gYoEZDUDeMyBSx/fx3HSiRB6B7uIwJlyqaNHVaK4DGR9jDzDjPZ0U5ObMpzQ9wjrX1LXxbPUSGNcvotD4kQcqGbWGD7YKNtiZXQB5HDQL1jAsDPHkVBDTco1XqNofe0gWNnv9FdHNAcgH+STawLtqdOgrZ8Aq+DlAvbJH1qpiKKCeZVK/YZUl0CngZ3/t/1jHVGK1ZYfv/rLT9iule7eZEwmaelNjeiJvVVFrXXH32rrBwyE66tuAkPtPEaoqHmWnuNg8anDYxVnUs4TW92Q1/zeMiOmM9BJzKucfUj4mwUpUB3xsT2xhZTk2rvWfJ/0qsiJkaWWlvpnLvakUFwVl/NCSDx+grxm9QV2oJ+JbE/dB1mX2bSVgOzEQXrZrMF2p003UVkJ55JdlVVF5zCC4UXnlxTcIAqvW+oOkTx7F3Y+hjJURvq6uE97BQWYnd25CLWPbbnmsxw4xylj+RnRAQ5TIwzoSC+EP56sReZwai9UTIHRlvgVQYv5HEEFzNeEe2JT/e4UTorkcu7Wka0lebfqfVOenJy9mucjhjzWh1Zmgdzi6+lJAKE5QXzUVJJXgerrlljQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 11:19:23AM -0400, Zi Yan wrote:
> On 17 Aug 2026, at 11:06, Greg Kroah-Hartman wrote:
> 
> > On Mon, Aug 17, 2026 at 10:34:26AM -0400, Zi Yan wrote:
> >> On 17 Aug 2026, at 9:55, Alan Stern wrote:
> >>
> >>> On Sun, Aug 16, 2026 at 07:42:13PM -0700, Andrew Morton wrote:
> >>>> On Sun, 16 Aug 2026 21:47:58 -0400 "Zi Yan" <ziy@nvidia.com> wrote:
> >>>>
> >>>>>>
> >>>>>>>> I prefer Andrew's first suggestion.  If the user asks the kernel to copy
> >>>>>>>> too much data, just fail -- with no warning.
> >>>>>>>
> >>>>>>> __GFP_WARN gets rid of all other warnings, even if user asks for a
> >>>>>>> reasonable size. Why use such a big hammer?
> >>>>>>
> >>>>>> Because on many systems, WARN causes the kernel to crash.  You don't
> >>>>>> want the entire system to crash just because the user asked for more
> >>>>>> memory than was available.
> >>>>>
> >>>>> User asking for more memory that what is available is pretty common and
> >>>>> should not trigger a WARN or crash, unless you have panic_on_oom set.
> >>>>
> >>>> I assume Alan is referring to panic_on_warn.
> >>>
> >>> Yes.
> >>
> >> Right. That is why I said “unless you have panic_on_oom set”. So panic_on_warn
> >> will not crash the kernel if user asks for more memory than what is available.
> >
> > Are you sure?  It kicks off syzbot, what prevents the oops from
> > happening if panic_on_warn is enabled and a warning like this happens?
> > Am I missing some code somewhere?
> 
> usb’s inode.c uses kmalloc to allocate > order 10 memory, namely >4MB. This
> caused the warning.
> 
> kmalloc’s doc says:
> 
> kmalloc is the normal method of allocating memory
> for objects smaller than page size in the kernel.
> 
> Shouldn’t usb inode.c use a proper memory allocation API?

Normally this function will be making >4MB allocations, as that's what
USB devices do.  But if a malicious userspace were to ask for more,
well, that's what we are now discussing.

This isn't the "normal" case, it's a "bad user, so what do we do to fix
it" case.

We can bound it by some magic value, or we can let the allocation fail
like normal but just not cause a WARN message.  That's the two potential
solutions here.

thanks,

greg k-h

