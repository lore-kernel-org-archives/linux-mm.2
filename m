Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED65CCD6E57
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 19:00:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E8D66B00B3; Wed,  3 Jun 2026 15:00:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BF896B00B5; Wed,  3 Jun 2026 15:00:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AEAC6B00B7; Wed,  3 Jun 2026 15:00:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 399B46B00B3
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:00:30 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C0D8D120309
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 19:00:29 +0000 (UTC)
X-FDA: 84839517378.08.1D683C0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0E78E1C0015
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 19:00:27 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nraqdA1d;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780513228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5zbCaKse9V66SE5IfNpASYQVYOGSQeR/Rad19zWfoBA=;
	b=IUE+g636mGJIBfW7J5UrdCGtDY8nZ6vdNtYi0pCkN1nvco820HYMwk0jLK5xGSyjDumcaV
	GYa0tiQE3fnK8bpEbKwM5DbWqS1wvllgOpsGWrSNa3RDp/vDgIhxc3WOwYFkKns65o9v9Y
	cGSxqT1kBMPh2gvF35DZvzoOl2JQvDU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nraqdA1d;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780513228;
	b=sod/H3Rn804tS+BxMGQYis3SXZxI7Rb5r8kx+kwXEh9NUbh4VC6MZVMeJXgwW2rKrjIpRb
	3zMZrhSEyCX5pC5xFzHz1cra8utSmjKEjuQj6qabeQfzdjCyzmYuTq1a97kkXhHH6BIV/Q
	+3o+lA+BQyy9BbDi94EuJBaiG3G2jSU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2C82243FF1;
	Wed,  3 Jun 2026 19:00:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22CBC1F00893;
	Wed,  3 Jun 2026 19:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780513227;
	bh=5zbCaKse9V66SE5IfNpASYQVYOGSQeR/Rad19zWfoBA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nraqdA1d0f2oiroPaK7Q5IGM8vdNnyflEpyhphrkbAArWnLZ5ZH5Pwg4UH+AZ3KK/
	 nG0e/TxEfVJq4BeAXswX8D0sBuBTHMBsUQPHlwLbvjGyZx06CtIyBjf9Kp8ZHX779d
	 /r/mB51xzJ6sHWmIpysxNuL+fj8ggAhYGIncqYOz7M1NKx/0sCHJPi9KxcYkEA1dJM
	 JaBBQrrd4PmwTA3UAFAdoVMcW1k4bPO/h4G9PyjPUOUTUGMqghDg+60goT0+DIS4Le
	 DnW8d8T/Yc/KvsqmFuwQY2DdwmCx1w3ERg7mnvuo6EAuOC1KccSmvdQE2eLfIwyaTD
	 FvjbTQFbS8H2w==
Date: Wed, 3 Jun 2026 19:00:23 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Nhat Pham <nphamcs@gmail.com>
Cc: kasong@tencent.com, Liam.Howlett@oracle.com, akpm@linux-foundation.org, 
	apopple@nvidia.com, axelrasmussen@google.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, bhe@redhat.com, byungchul@sk.com, cgroups@vger.kernel.org, 
	chengming.zhou@linux.dev, chrisl@kernel.org, corbet@lwn.net, david@kernel.org, 
	dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, 
	jannh@google.com, joshua.hahnjy@gmail.com, lance.yang@linux.dev, lenb@kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pm@vger.kernel.org, lorenzo.stoakes@oracle.com, matthew.brost@intel.com, 
	mhocko@suse.com, muchun.song@linux.dev, npache@redhat.com, pavel@kernel.org, 
	peterx@redhat.com, peterz@infradead.org, pfalcato@suse.de, rafael@kernel.org, 
	rakie.kim@sk.com, roman.gushchin@linux.dev, rppt@kernel.org, ryan.roberts@arm.com, 
	shakeel.butt@linux.dev, shikemeng@huaweicloud.com, surenb@google.com, tglx@kernel.org, 
	vbabka@suse.cz, weixugc@google.com, ying.huang@linux.alibaba.com, 
	yosry.ahmed@linux.dev, yuanchu@google.com, zhengqi.arch@bytedance.com, ziy@nvidia.com, 
	kernel-team@meta.com, riel@surriel.com, haowenchao22@gmail.com
Subject: Re: [RFC PATCH 0/5] mm, swap: Virtual Swap Space (Swap Table Edition)
Message-ID: <aiB5lEMSH97R_aiP@google.com>
References: <20260528212955.1912856-1-nphamcs@gmail.com>
 <ah-A2gQ0GPgerXop@google.com>
 <CAKEwX=MWX9KkSFAoN4xEMg3b+gZUN9=yd7rirAWG5NOBf26eAg@mail.gmail.com>
 <CAKEwX=MZQJLHNNU0tUqnihdhdPdVd19KhC-HtJxfbQ_d8OezzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKEwX=MZQJLHNNU0tUqnihdhdPdVd19KhC-HtJxfbQ_d8OezzQ@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0E78E1C0015
X-Stat-Signature: s54ss5z5r83b3ygeequobcn8xrys6yjf
X-HE-Tag: 1780513227-662018
X-HE-Meta: U2FsdGVkX1/ztwdl/ap7/DBOrPrBm6Wxr6RQ/iw6OYvBx+rOiQDcA44JBx5ftmDGwo/+9jzuvNT0QIcF3dRekjGpc8RIVM8X+6ylnLAEGMJYrc+vWZKuOve36RaGFEUzaplMzO4dpXfhWkTHtbhEh4Iqrd2Wkmewh/IQjXMpBhDNbHXFG/owCrGjqbKf6rhW8p0IQzSU5oH57HVAF2+Hm3MotjHg3EgbfSC1Y5K8oSDi5MX7pGyz2VdOkWgampyq95lHcw83gsmM4QFTGoeofbABQ3nZtMl2d44Z0Z1I3ARJ2si+I8j/l7+MKBvhGKW9ymWZ8gLWj0EyQhUef0oksx5ICL2AiaiDpDlN+NsxPA352U+FKbAo1sNt2fqEym5RwQ/AbOwnCT8S8k5y1LRP3uhxF2H4uoa/+MBS2DkwU4f1vvdpySvtZluNVgL6nbNCNZsRuirxcmIE4xWTtOGyYjTYPKpdzcj7dOgvZe/hJ48fj+XUg+PmZyaDGX+auGzcn/XuZljVxOiBMWXZwcQr7vDMtnuDkcD1dKILLchK5fFHKxQhOVYg0ABI3GFmJ+hZKKiOK5lKC6muJCcZT5hjNogUwRDukxyoqRUpPUlcE667zFIVjk7zUWYGQ1CwHbADwni5XvCNXGbas+0oLpLgHtZKidExXdQ6S/eiWH5/Y2Rv3GWJtkQJzv8JSApvH+1UeFghm+VJibBgKiLCS/lnuzgL0FJZYFgRLJF9SnN4zFo+lVhcA3zbZsyaLns5xprwGlIIorHbcdsx88H43DGm6mg48PoUzEyR7QMiLx3jahvymACxdJXhxDfFmWvP9y01Jrrrsldicikz7ZsOsVmatQrtOTvdET4q1inleIWmmDx2qnuOPOQIGwLIntR2wXb99LKAG2Sg0HJbwKfSYB4ALBIDyv2WSa+plPzEjj+NYWx74nvDsBXxDDl2wcyOtHJexoFA+lqYgOdtO7avdl6
 NGqSoDeY
 f8b6tfp184RR3SMW1Bhzwtnl/2IdmA+EBpXaS9a/+OQEbIoWC2KE2iELsoD8U7chfhG6AUW0UfPec+ayGc6R9Zz3euEZeRaMqAwL03mlODVTvE7LcOyDkJyW+mC8ko4TceWNVwg8BHYfRQH5rruxWDqaBNcU6sr1isuKzTdN+W7z+X5M+kvE/jz0i+Orz9sACp2QX5WJ9rdlPeUhcSWj504FyiGfKpB6x0V2oRbcsEpA2Qcl1TCXLs/5YXEyNQICt0W/tJszeHetTjLNEmMAzLwkGWCLzlDHDBUD5D7d4gBMt5AuEnjHDVS+oGHuF1CdY0ykM0n6CzVyDi8v2FXUmjT0KoUrIUb1ch8Tz7k6/fOAGX3iy3tsGrF6XTg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > > I don't like that the code bifurcates for vswap vs. normal swap entries
> > > though. Not sure if this is an issue that can be fixed with proper
> > > abstractions to hide it, or if the design needs modifications. I was
> > > honestly really hoping we don't end up with this. I was hoping that the
> > > physical swap device no longer uses a full swap table and all, and
> > > everything goes through vswap.
> > >
> > > I hoping that if redirection isn't needed (e.g. zswap is disabled),
> > > vswap can directly encode the physical swap slot so that the reverse
> > > mapping isn't needed -- so we avoid the overhead without keeping the
> > > physical swap device using a fully-fledged swap table.
> >
> > Can you expand on "vswap can directly encode the physical swap slot"?
> > I'm not sure I follow here.
> >
> > >
> > > All that being said, perhaps I am too out of touch with the code to
> > > realize it's simply not possible.
> > >
> > > Honestly, if the main reason we can't have a single swap table for vswap
> > > is saving 8 bytes on the reverse mapping, it sounds like a weak-ish
> > > argument, even if we can't optimize the reverse mapping away. But maybe
> > > I am also out of touch with RAM prices :)
> >
> > In terms of the space overhead I do agree, FWIW :)
> >
> > I think the other concern is the indirection overhead with going
> > through the xarray for every swap operation, hence the per-CPU vswap
> > cluster lookup caching idea:
> >
> > https://lore.kernel.org/all/20260505153854.1612033-23-nphamcs@gmail.com/
> >
> > >
> > > I at least hope that, the current design is not painting us into a
> > > corner (e.g. through userspace interfaces), and we can still achieve a
> > > vswap-for-all implementation in the future (maybe that's what you have
> > > in mind already?).
> >
> > That's still my plan. Operationally speaking, I want to make this
> > completely transparent to users, with minimal to no performance
> > overhead.
> 
> I do want to add that, even without achieving this, the current design
> already enables a lot of use cases. I think it is a good compromise to
> maintain both virtual and directly mapped physical swap entries for
> now, and revisit the conversation of whether we can afford a mandatory
> vswap layer once all the optimizations have been done :)
> 
> We should strive to simplify the codebase, and it will naturally
> happen when the original overhead concern is no longer there. A
> swap-related example: a few years ago, everyone thought swap slot
> cache was needed. But then, Kairui optimized the swap allocator's lock
> contention issue away, and that swap slot cache is suddenly redundant.
> That finally allowed us to get rid of it. Similar thing happened (or
> is happening?) with the SWP_SYNCHRONOUS_IO swapcache-skipping
> heuristics.

I agree, I just want to make sure we have a line of sight (or at least
no blockers) to having a unified vswap layer in the future.

