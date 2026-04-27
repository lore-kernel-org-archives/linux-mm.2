Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77AA8FF8868
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 18:51:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCCFB6B0088; Mon, 27 Apr 2026 14:51:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7D7F6B008C; Mon, 27 Apr 2026 14:51:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C93B56B0092; Mon, 27 Apr 2026 14:51:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B8E4F6B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:51:03 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 85EFF1C033E
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:51:03 +0000 (UTC)
X-FDA: 84705228006.14.00727F3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id C0E33180010
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:51:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a0L0AZP9;
	spf=pass (imf06.hostedemail.com: domain of "SRS0=5R8g=C2=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=5R8g=C2=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777315861;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gp83lGspVAjzx8xM35sMJOv6Nx6ekR0y+QLqz9EQJQ8=;
	b=hUXwjdiuOa+K/KJdG+nW7WcmU1fuU2CvO51gcp63uOX73YpvSLMG065biHN9vqvNCHGrfp
	RhPEf2ABOCnjWFKhDr7dvcqFz0xltCtq33O3V9QQuolDpOSpvV2IzzUMv6YTVgdT3lyUhJ
	YVCNs1/cja4FOUD+kOGt8AkmSzZVysQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a0L0AZP9;
	spf=pass (imf06.hostedemail.com: domain of "SRS0=5R8g=C2=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=5R8g=C2=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777315861; a=rsa-sha256;
	cv=none;
	b=3SdIAw4b8Z5GTHxrErrLWh/hqx+dy/mCjc86RJzc8O22qzMVC/4bh2pfSFrLIRwLJAu7CK
	0OS2GbFMiXfGcXAfOiN37RimwE9iASM1VwpSRhWWsEAXcfigJYKu0uyeDuGk6SjoEZ/2zT
	aGqmZrCkABihJOQqxj/39622S6UxcQ0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2B92860138;
	Mon, 27 Apr 2026 18:51:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC4D8C19425;
	Mon, 27 Apr 2026 18:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777315860;
	bh=v55i0w6M0EcnzLsslbo9Aiy+5pDv63hc63AF66VcSWA=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=a0L0AZP98abJNOh6BidmAL1LYYkuUK5S75umWl97+QgD6zA2qkGPYHs9hphVGG6Fv
	 6GqWxjWhwlPoj7tsvz62+3peBqK74Hhkw69GSoNtQy1r64Fy+EeCJLVNduxMrujur7
	 eqw/8msUeVFfU5P89Lir+TIColzTYCrfeIyNxtpf3rEEB7qYchzRuapU4G/TGXqknJ
	 T78/cbnkD46LwN8NhuShusptW8ho2zushibx2uY20CtJ+WCENi5BLs2mmakjIopk5V
	 m7iX96x775m8EOThSLL/hNKgVx79C1B3AuQzeKEVJVzlqac+we54AEumElnIQAjp+V
	 JoPVZuNIQXUKA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 83F12CE0DD4; Mon, 27 Apr 2026 11:51:00 -0700 (PDT)
Date: Mon, 27 Apr 2026 11:51:00 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hao Li <hao.li@linux.dev>, Alexei Starovoitov <ast@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun@kernel.org>, Zqiang <qiang.zhang@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>, rcu@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 4/8] mm/slab: introduce kfree_rcu_nolock()
Message-ID: <efef0b9c-1b1d-47b0-9c73-b2f9659ec635@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20260416091022.36823-1-harry@kernel.org>
 <20260416091022.36823-5-harry@kernel.org>
 <aejeVK0J_jHSfVhD@milan>
 <aelxH--hZkCahPv6@hyeyoo>
 <ael8R0vOeZ0Xbcoe@hyeyoo>
 <7526f30a-a008-49bc-a064-07f4e4a7920b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7526f30a-a008-49bc-a064-07f4e4a7920b@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C0E33180010
X-Stat-Signature: hz1bnsgqcsc3t5tdd9h1ey6rqezejjcy
X-HE-Tag: 1777315861-501721
X-HE-Meta: U2FsdGVkX18vFp8P83N7IBBESlB7PHuI66SDbB4nHZT3xF40TdWJQmZO21b3CCMXPNynOU8WOKyHH+UlvpMLqFSDRSnYImlIbx4JTRaLQqkia+fltEMmTZVv/Sgx9hZV5PzMnLX+OW2AvWa6KYGpH2TU1mJdXUwcNt7zU5HV8aNKfRmG4ol19UaSRes08y3HzbTF/g3SsZYhph2149Bs08ejj1uqhT7HciQr2dm/8aIYAwqRwDcj5hx+ISOZknonxaWTlmkID8tIkQw7wHFgx8cF+hIn4rWz7/izNTPQ+93DidgCvFr/IQJf8QKBeKE5b7R1rTbT8P1dlUKKJ5Gx89bmVg/Wh52tPlLYUfpJ4fG/AOrlY1Yv4LEewwE0U3jA8ePwZwem66jDj1CtC3pnVBviRmtgPIlhiM+W1AheKluifWGz5lyFB3a2Nd8e99lT+BtnATfXi3w8IXCAtCcDn2ZkpeQ2DgXhpzpSdnK5TMZQDvd4it99C8oMuHU9Zbss+4OHRinubNvUabXmjwWwf5tSqQMDl8xrcSfWtR8h5IvjCt4dYUyCzjFKlBLE707DtSh7XlqTr16Oh6NufDHR53zhiQg73fHEyoUpCoh8K7tdAq8/aKSx7a1QtU4nsl+5wMFApazQSzBas9mihWKQI2CxzbZv519103Tyo5MlweiEOU3fiiOUmbCEgKgRcKvYzHDcBApsdPR12prqrrt8VzxYMTaeMY3mYGAbaG8+YgPNlA/X4O1zqLBoeSCPxzQmI0OJCJJtvd5u+S5mv5EKcZM+frfYEaKBjm5On6i2anA0pYuLlAa7HPyGMnAZ9KztrQ/2xoCqJ+8vAGHjxj6LNlMfDaW9YvQ2ArQ56z2wcxLx5lxDVj05+PVhLlY/gid0r1D3mLfYnLEGgLRxY4Fe9Q5NT/NJqwpbnIpJJBowLp/Q3MA//vmnZdbV67OKK7iSGBimDUc3Pkhhi2QNmNh
 ANGbm1F6
 k0Ygr1cc4n/6REXl5b/TiXV/xJ7VAMOQglcX0RXYWQpiUnLK4wFVMQyTX4pC7SlBvStaOxY4JmHWCZfJwcNUoAUoDqD/61m5sa1jRH+dMq5mHpEqR/9xZalCxQm+ayA5rV7/c9goUsA58p++Ec11fa3MEwIKy8cQGZorZYKsMAMPP9mgm4sf0p8aF1bK+h+FMGIcd3VWl7aJp01iM9ibrb6FCdLMu9mpmsmELcYKHyKJdldnPW2A5CB2AXS940FbZF98NqL9tEegTXPTW1XFPCrUXtHHha/jBEnAJjswH9ABHKzjtlnBJlzDhBxHbbxvY3jasa2prEnGwJE0rNP/f/dyVj+MPw8eZbEwF9v2CMfiDNc9xTkUo5zfwfpUwJVfjhy0u/5HrVJNbssptV/4BvIYuHfhmIoTUDv+QBenGSU61MrjK6cFfWuOmjcH+Lqtgla5ZkvdIYzHNqbaujvZnK3fBhqh0yOG/TM2SfCanWjRyTfTdmbBnTZQE+XLsTJrDukBstxXTrXEbRKaWx24MHi61UKG2ClH1Zz4n0Bky+JZvQFIYyC+GinLHpHqe7POOvQvmMuuR+p4bhSPco7mgPXQqIGExcsqgb/OWi6PlIOc8TbeBs3DFSzs6mEs6+FB7fKvslbbz+l1WtjatNZxhD7NyRMJiogZ2U0JrQyvIPmCKekqJx9Mp5Jl6SnFfXUewUqOS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 08:08:43PM +0200, Vlastimil Babka (SUSE) wrote:
> On 4/23/26 03:56, Harry Yoo (Oracle) wrote:
> > On Thu, Apr 23, 2026 at 10:08:49AM +0900, Harry Yoo (Oracle) wrote:
> >> On Wed, Apr 22, 2026 at 04:42:28PM +0200, Uladzislau Rezki wrote:
> >> > On Thu, Apr 16, 2026 at 06:10:18PM +0900, Harry Yoo (Oracle) wrote:
> >> > As discussed or noted earlier, having third argument and check the
> >> > entire path with "if (allow_spin)" is not optimal and is not good
> >> > approach. I do not think it this would be a good fit for mainline.
> >> 
> >> I understand that this pattern is pretty uncommon and adds complexity.
> >> But there is a reason why we're doing this. As Alexei pointed out
> >> earlier, even rare spikes of irq_work hurt performance [1]; that can be
> >> avoided in most cases where the lock is not in use. That's why buddy [2]
> >> and slab [3] accepted this pattern despite the added complexity?
> > 
> > Perhaps we can avoid complicating existing kvfree_rcu batching
> > (and still avoid hurting performance).
> > 
> > Given that kfree_rcu_nolock() (at least BPF) doesn't need to free
> > vmalloc objects, we can make kfree_rcu_sheaf() handle most of frees
> > (slab already knows how to handle allow_spin = false) and fall back to
> > a simple irq_work as Ulad suggested.
> > 
> > But then we need to make kfree_rcu_sheaf() try harder (currently it
> > gives up when it fails to get an empty sheaf from the barn).
> 
> Yeah, if there's a burst of kfree_rcu_nolock() calls, it might exhaust that.

The usual trick is to do an irq-work or similar and have the handler
do the allocation.

							Thanx, Paul

> > And I guess the tricky part is making kfree_rcu_sheaf() work on RT ;)
> 
> I hope we're close to that, as discussed on patch 5/8 :)
> 

