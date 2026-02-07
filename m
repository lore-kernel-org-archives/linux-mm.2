Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86F22EE6B6F
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 01:33:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9595F6B0005; Fri,  6 Feb 2026 20:33:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 930E66B0096; Fri,  6 Feb 2026 20:33:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82F216B0098; Fri,  6 Feb 2026 20:33:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 70F7A6B0005
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 20:33:56 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2A9EC1B29F3
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 01:33:56 +0000 (UTC)
X-FDA: 84415939272.26.65C3462
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 51A8280002
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 01:33:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ec7rQqRd;
	spf=pass (imf02.hostedemail.com: domain of "SRS0=IOST=AL=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=IOST=AL=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770428034;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DDHo2+E9XhJW7WDc/OoGtu9ycrbtPPtrjT5V0ycQML4=;
	b=M9uo8rOtyzr9ZclBGFK2qh1ageGjWj+mwjjmUzBteR7s4OQ+wo/8tkgCQz3Zjssr3kaxn6
	vmGh+yQW+V0Dy85L3v4gSbuZjGS8hzGBRkqqnTvrG0ZM3asM4neocMQv3HfBtvK1Upedg2
	JbN8Y/qj3BDm5wiR6bTptAliuM+iXlc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ec7rQqRd;
	spf=pass (imf02.hostedemail.com: domain of "SRS0=IOST=AL=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=IOST=AL=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770428034; a=rsa-sha256;
	cv=none;
	b=55qZ1o3xD5WY2StBG20yHdQbShYhH49FCDWptFZvp829AkgBMQkrWqxWreilJcGQRr5IKU
	NrNEPwXpPlQhRiz6O74ZzRTi7XOfiL/WaX83SJF+lHXHSt1di2d1ALczW5y3Dtf9/pYd9g
	WCGK0y6/ESswS7+CA5XthdiNyKXtFUc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 23C844426E;
	Sat,  7 Feb 2026 01:33:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA84BC116C6;
	Sat,  7 Feb 2026 01:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770428033;
	bh=cMEW44NcK47ld+LLFpA5Wvv7fZZ/ANyC12YUx60BOII=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=ec7rQqRdDO6aGkt9QBMT+VC6N4xHCvZbP3WZLzvBWDxE2uPv1EHag2WotIdQFsSWU
	 W7YriKrmWxMTwcyUrMyy2K2sL7sT7yE8PvSwarEyTierHgnr//nrnQCbviPP0zy9jv
	 NU4dIYV6WRh+EImpq7Je9QdXRdvnMpzWac9yl9yXkGqm/050hS5y1f44J1dYUcy48k
	 IIqrNtZQbXc0jSnXmDb9buJN/ERVl1HySDKT60h6l4UNNju/JSH/1jwdDFImbYFIpj
	 CpMDCYbpwm5+sxbSJIC4HKGV8BwyJXwSTZPtDQBjHu9V7Ev5Ug47NqxgNkm9rULRhV
	 FiU6Ss672M8Aw==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 628F9CE0F9F; Fri,  6 Feb 2026 17:33:52 -0800 (PST)
Date: Fri, 6 Feb 2026 17:33:52 -0800
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>, Hao Li <hao.li@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Puranjay Mohan <puranjay@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Amery Hung <ameryhung@gmail.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang@linux.dev>, Dave Chinner <david@fromorbit.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>, rcu@vger.kernel.org,
	linux-mm@kvack.org, bpf@vger.kernel.org
Subject: Re: [RFC PATCH 0/7] k[v]free_rcu() improvements
Message-ID: <a49009d1-a0f7-4111-a148-c94fc6e506b9@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20260206093410.160622-1-harry.yoo@oracle.com>
 <3069e76d-5c7a-4c3f-9b83-43ed1700b95f@paulmck-laptop>
 <aYaTluYIbqt7xSC5@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aYaTluYIbqt7xSC5@hyeyoo>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 51A8280002
X-Stat-Signature: 3zgz7ho1qpsdhzgeb5unsiu19e6smzxw
X-Rspam-User: 
X-HE-Tag: 1770428034-864648
X-HE-Meta: U2FsdGVkX19vI1UU00oUKKO8z+xDa7hiaWzUUuTvrFMFH6W7I6Y0ANlxevWK1DciQk+OKAE40MqEToG9NTFR5mCy2qrlxSSX7x8YOLDZUp4UEOMFuVvUxDot3F2Ma4uZIlSf0N2qM6L7kaiP30AQpdvJgNehmBzqOHnWXAhe/h+j9MHvE3ultVhy1/7/OMFEzR3QWaQdhS4LYw7lk9ajn2NJDlGLqCA6chgtRPXEZOxp3OiJY3tQv79rekQ8FrWFJxqpYZbk8NwXZnoxVjZMPzFgi8EWa68uzUiOJSpbs/JAZgmTon6afvmyCyBarMJEhcg1fVRIJJMGUbg3j5qQNJ20WoRnxs+gGfy5SPsm5zKWv8aFEAEvChNvJeIJXzRZ1DU/ufcshu3wY7QvHXpv8Cjs/LTZdLw9xyxWGebSBSIYyWHVo31vfh+/IpDJ/KdDRcJSqigQMNvCacLZQnjTGztSw6QaWSFriPGyxhUNvBsY0zBfkzpJQZ/jNkXmw9jCOBJF3yCqJmJ5Fym950m5bIsrCu5AR1msorbnk/DHT/yUiBdVCkne/kD3UhmtKoDxegjf/8bmW+BA16fuUf49PU+8riuhcW5PqjT5xcoUSxleNyze2n/qd5b9CBW/32e8XALrE7nJCWj5fWW2K/ckGNBDC3anW6WbkfiYHuGaiP2WIalv9yF2fT7h3YNcbOBC5QpADu9SdvPyKUiTAkFpBcIX7AFhGiF6/fUHrohvLzJoP0yBdjKL9q8rGRqohxDpPHUfUwgorYO49hKj4+NK3An5vmSPlbC/5Vg9eHq3HKxl/EAi72Ogh5pTDhl6GTelfHXH3SScDPRG4+EuF0mTaw7ES+jiGjuUStlkZRkGPNkBGgJlLK7QoH712uv6hzfjLI5aaG0G4XMWMZixdHDVHZsdQBGCvmKC9SmXHIuC3CHMYyBfKyBRDD3PwPZM+zST1BaWvqe3aby0rABEDQk
 wE3HNy1C
 nweIf48uoDNRqjAiplbn/oIPhvxFroCchcJ3dKUocA1lQ4dy8n+CazLBp39JIvg0RfjfMJIwkM+M1ealiy9S2ntQvUTSeOd82LDhXzPyrM6NVrlvqmc/dThLWYYGiBmkhNc8K5jJppUtXmjCiXQfls6HUIPpTDlsB0CPPZrUkVIv/RzfMaDKCqwx8FxwP+5dkq7EwajRbYK1tGT/mbBa36iantROWeZ4SYLLfZljfcPsGTN5H1XCyHaxtXftzSOWFpJsGOIhLPp38VkK6M1RIldNp1jmt8vokMtj+Xw5RJ1pffa4FVGAEByIv7HuI2LBzWKjWOJKMtkqoKOAPw9fTmh82dOXzpEYm1NHZ3OthZaWoAAHkB8qrGS47+iiEBhW2mjwKL3D3Pj643fIiWKz5MfnitCLji5+CwX4ig79r8RkRbCMYnLTklPOtDUbU4IzuUjuFr/hFhulTs+gbYopuJKVVY7pECUenc3UO+QIZsFMDJq480IULdQTHZZOvpm2Ajqd2qMSEVaCVkVjUBkqXsSUPpSlPj64cewlWVBWb3UiPrjegNhH6nzGaU1wnX4klF/3LU32vQdefrjT0ZnjBK/lLw9yZJdxbAn0mGhVjXjtVxWEcU9Gv574ra1zVXEHeo4MFJbKbQwcUwfNACCn3GaJIW753kSuoFC0CaosnRGX45nQ36WT396yMkjJc9zrahFHRlgHseIs8v526yrfvIj84XzZOIZIkBufwrn1nTbuB0ZyxDTxzY2TlMwadiPO6gHcyzBR8OMx4mHp8t6PjWniQe6nsP+svIZQj1uR63pY5P7Qt4VAZbC7NrQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Feb 07, 2026 at 10:21:26AM +0900, Harry Yoo wrote:
> On Fri, Feb 06, 2026 at 04:16:46PM -0800, Paul E. McKenney wrote:
> > On Fri, Feb 06, 2026 at 06:34:03PM +0900, Harry Yoo wrote:
> > > These are a few improvements for k[v]free_rcu() API, which were suggested
> > > by Alexei Starovoitov.
> > > 
> > > [ To kmemleak folks: I'm going to teach delete_object_full() and
> > >   paint_ptr() to ignore cases when the object does not exist.
> > >   Could you please let me know if the way it's done in patch 3
> > >   looks good? Only part 2 is relevant to you. ]
> > 
> > On what commit should I apply this series?
> 
> It's based on Vlastimil's slab/for-next:
> 
> bc33906024eb Merge branch 'slab/for-7.0/sheaves' into slab/for-next
> https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git/log/?h=slab/for-next
> 
> > I get conflicts on top of -rcu
> > (no surprise there) and build errors on top of next-20260205.
> 
> Interesting, I don't get build errors when applied it on top of next-20260205.

Here you go!

Here is my repeat-by for these build errors, perhaps a .config issue
or difference:

tools/testing/selftests/rcutorture/bin/torture.sh --do-none --do-kvfree --do-kasan

							Thanx, Paul

------------------------------------------------------------------------

mm/slab_common.c:1475:21: error: implicit declaration of function ‘IRQ_WORK_INIT’; did you mean ‘IRQ_WORK_VECTOR’? [-Werror=implicit-function-declaration]
 1475 |         .irq_work = IRQ_WORK_INIT(defer_kfree_rcu),
      |                     ^~~~~~~~~~~~~
      |                     IRQ_WORK_VECTOR
mm/slab_common.c:1475:21: error: initialization of ‘struct llist_node *’ from ‘int’ makes pointer from integer without a cast [-Werror=int-conversion]
mm/slab_common.c:1475:21: note: (near initialization for ‘krc.irq_work.node.llist.next’)
mm/slab_common.c:1475:21: error: initializer element is not constant
mm/slab_common.c:1475:21: note: (near initialization for ‘krc.irq_work.node.llist.next’)
  CC      drivers/tty/pty.o
mm/slab_common.c:1477:17: error: implicit declaration of function ‘IRQ_WORK_INIT_LAZY’ [-Werror=implicit-function-declaration]
 1477 |                 IRQ_WORK_INIT_LAZY(sched_monitor_irq_work),
      |                 ^~~~~~~~~~~~~~~~~~
mm/slab_common.c:1477:17: error: initialization of ‘struct llist_node *’ from ‘int’ makes pointer from integer without a cast [-Werror=int-conversion]
mm/slab_common.c:1477:17: note: (near initialization for ‘krc.sched_monitor_irq_work.node.llist.next’)
mm/slab_common.c:1477:17: error: initializer element is not constant
mm/slab_common.c:1477:17: note: (near initialization for ‘krc.sched_monitor_irq_work.node.llist.next’)
  CC      drivers/tty/tty_audit.o
  CC      net/ethtool/eee.o
mm/slab_common.c: In function ‘kvfree_call_rcu_ptr’:
mm/slab_common.c:2097:25: error: implicit declaration of function ‘irq_work_queue’; did you mean ‘drain_workqueue’? [-Werror=implicit-function-declaration]
 2097 |                         irq_work_queue(&krcp->sched_monitor_irq_work);
      |                         ^~~~~~~~~~~~~~
      |                         drain_workqueue

