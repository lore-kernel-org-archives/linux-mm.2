Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91F0FC5AD05
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 16:57:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C09196B0089; Fri, 20 Feb 2026 11:57:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAC4B6B008C; Fri, 20 Feb 2026 11:57:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB25D6B0092; Fri, 20 Feb 2026 11:57:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 930B16B0089
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 11:57:42 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 38D17139559
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 16:57:42 +0000 (UTC)
X-FDA: 84465441564.02.635C5F8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 07B878000A
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 16:57:39 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WwPzpsjJ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771606660; a=rsa-sha256;
	cv=none;
	b=TyYd8dTrqcm7Tc4ufbBjPoDOecgWuICrFm3TsVoJ2sLwZJckUbEbWYu05ZZN/IrFGpgazT
	ce2NOyzxZq33XZIoz8yh5G9Oh5VbRzn8mQ5s515PoUzJx5nrT7UxQCPEbEc6zYbOp8t72v
	GHqdh0eKbpZ/cboo17qAFjGYFY8qTXs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WwPzpsjJ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771606660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ppw4K3DbmN7RYbMzOdLadd1esQw4LW4oIH3NAVRbdGA=;
	b=iV0V9zYvzFAdUbYvzmw7cmmmL3vXPHxzzNOikj0A936MV/fyOjvv2+Bd4GqdpM+7AhAmAi
	A2pdF8+zMdKzfwzfzbGxwUp3wI7G0MQeQHaByC0TKH8Q6m9YWQ/VnmlMwLgbjesg5c81NN
	ctDhpqwKLffgpb1S0cDIPYO9JEHMvYc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771606659;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ppw4K3DbmN7RYbMzOdLadd1esQw4LW4oIH3NAVRbdGA=;
	b=WwPzpsjJfVASNJ/mymnhuUVb64BXUU403XccLop0Um7nFW6XHS0XC94iAoioae+NMI6pIR
	qL9YAhDOQ+DUKAGWsD/Ay/FrB9mwNhu5hdboBRl3oCqYooLnHj/nLEGz+y+HFxebqrWCNr
	YIMN7LVZqTAinBs7Vqs2R15mwZwAkHM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-252-3ATclVuAMMCAteY8vl0Zow-1; Fri,
 20 Feb 2026 11:57:37 -0500
X-MC-Unique: 3ATclVuAMMCAteY8vl0Zow-1
X-Mimecast-MFC-AGG-ID: 3ATclVuAMMCAteY8vl0Zow_1771606655
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2210B180057E;
	Fri, 20 Feb 2026 16:57:35 +0000 (UTC)
Received: from tpad.localdomain (unknown [10.96.133.4])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B0CC61800671;
	Fri, 20 Feb 2026 16:57:33 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
	id 6B833401E19EF; Fri, 20 Feb 2026 11:30:16 -0300 (-03)
Date: Fri, 20 Feb 2026 11:30:16 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Michal Hocko <mhocko@suse.com>
Cc: Leonardo Bras <leobras.c@gmail.com>, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Leonardo Bras <leobras@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
	Frederic Weisbecker <fweisbecker@suse.de>
Subject: Re: [PATCH 0/4] Introduce QPW for per-cpu operations
Message-ID: <aZhv+Bw7nKKmbFdq@tpad>
References: <20260206143430.021026873@redhat.com>
 <aYs6Ju2G4bm6_tl2@tiehlicka>
 <aYxviLoWsrLqDU7o@tpad>
 <aYywl1hdBQP2_slo@tiehlicka>
 <aZDw6xI2izFDfuuu@WindFlash>
 <aZL45yORfkNvS9Rs@tiehlicka>
 <aZcr255pGT3B/eaL@tpad>
 <aZdk19MqYhWK90Do@tiehlicka>
MIME-Version: 1.0
In-Reply-To: <aZdk19MqYhWK90Do@tiehlicka>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: nYJeJAjdEbIkpzQjghCGtAODsF7jFUnZO_-VE4RlPuA_1771606655
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: cgnnrza5hchdotyx1r7gpxdqesbr4566
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 07B878000A
X-HE-Tag: 1771606659-114189
X-HE-Meta: U2FsdGVkX1/s0Gm2A+h6parNp/AswwPXEkub+E17GK1LGM4U3LThfI04N4hOLMUFumreD3+6n2bXw/qaD2eXGYpEsUkzVTSYSrHrHbnj0xkuB1nbB2i6mOC1/qqRhy1WUgjxw/pCsXODyGexSHpRsr8x8Xd1Gkf4GKzyciPAfElifswH2RZT5vhIjmwNj4hmlPq7y+4nPydwVJ5cl8eQkshD09E4dWmXdC3iOImfn6564+D02lLwAp8GQsjHyEoCfS08/3ABuVejlr15CGojjUGrLLG76XxXH1N7ocr4lOsFxObha6wkslmR/xYHw3ogrFzv6RsCNFHPGybO4n7R4WPh7row8cbrPE2Rt84YbcAYEMNV9IeM27xUPpPyW6KmTCJoFAUp/QCGmyqneuZLUySRCpC1jLuXpDgn/KRNJjGGpHoJ1AACgGGkNDQfrCu6yk9UvI1VyKOQWTxqdK76nrg5xTmVZEVmeM8CERLF+EHkT8wKFu1oSuHheSl1Wh74ZFwETWAl0FzYgw86kH0wWTLPsFZy2WJVMEgwVDLqD2TTkWaY2rGJnwq3wArCw2ZgPlNEdx5ECMkw5N7ajkH4JOB4RvJ/lgz2qdcasZEx9yHheiPH8uwA5c/4g1X4nZdv81Vx1/BUai2uDUWMmn+4cFV/ofBEDAJ/kSleoN8b0btD4vfrFWtLkdt/TfFoLh3hc9/Sx+5Pm5jxxUCKq8x5+9n01Gb5D+XFMNP9ULkTHhm2gZeg+vVdk/gCM++dK9qV54tu1WKQXmqoEeKQtXlVxSrXnOwsYTxr1rVnBCWkdBBvec7WEmrUKsGq0d2hSgkx5U5N4E/8gcfC/ejHjWP5Jzd2dElIw/bNmZcFqqcpRDz5JyHENuXXGns1s3ohHXGtz170avLZBFYyzuR2vmLKU4sj/OIMYIHyZwunAohAFFQV5NzDqvfw3gJvVHgWwGn8OAw005Y0xj6HDYvka6P
 jCEzZHje
 /zUFEzGOPQsNSwO6lrDkmzdsSLkj6BXyNhgBugLuMPp3D1w/h/8V0Pi481dFz0AJYq+093HpdVNRkThC7RwKxg1mBJvzGTrcLbOWFkvHCEmPQp1aqpL7y3zulacWJO134JeQ0ZoYYBNl/o21fHV47jytDXs90VCBmVp6mn1nmcl/9WpVKtHXGiKRTb8UnHLBhJ35vlVZoGN144V1tnI830fewgkHJNBsTdqHqozf1LGjS6/rEFjiilXjiOWFJ92B6rNNuhXhYX5xJIXlE/uvDuNDATIw/+df3hYqUi8AoCHkhcNFZTrsUG3enuWvDam6WCdB4rxlOyKBc4RHXERvQ/bQSn6gPVGMkSqUvTOk8ufV6/4XRrXA8uacaxOds/0lI9nz/UZKu8zgtIIY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 19, 2026 at 08:30:31PM +0100, Michal Hocko wrote:
> On Thu 19-02-26 12:27:23, Marcelo Tosatti wrote:
> > Michal,
> > 
> > Again, i don't see how moving operations to happen at return to 
> > kernel would help (assuming you are talking about 
> > "context_tracking,x86: Defer some IPIs until a user->kernel transition").
> 
> Nope, I am not talking about IPIs, although those are an example of pcp
> state as well. I am sorry I do not have a link handy, I am pretty sure
> Frederic will have that. Another example, though, was vmstat flushes
> that need to be pcp. There are many other examples. 
> 
> [...]
> 
> > You can't delay either kmalloc (removal of object from per-CPU freelist), 
> > or kfree (return of object from per-CPU freelist), or kmem_cache_shrink 
> > or kmem_cache_shrink to return to userspace.
> 
> Why?

Because kernel code might need to use that object right away, so it
needs to be allocated right after kmalloc returns.

> > What i missing something here? (or do you have something on your mind
> > which i can't see).
> 
> I am really sorry for being really vague here. Let me try to draw
> a more abstract problem definition and let's see whether we are trying
> to solve the same problem here. Maybe not...
> 
> I believe the main usecase of the interest here is uninterrupted
> userspace execution

The main usecase of interest is uninterrupted userspace execution, yes.

It is a good thing if you can enter the kernel, say perform system 
calls, and not be interrupted as well.

> and delayed pcp work that migh disturb such workload
> after it has returned to the userspace. Right?
> That is usually hauskeeping work that for, performance reasons, doesn't
> happen in hot paths while the workload was executing in the kernel
> space.
> 
> There are more ways to deal with that. You can either change the hot
> path to not require deferred operation (tricky withtout introducing
> regressions for most workloads) or you can define a more suitable place
> to perform the housekeeping while still running in the kernel. 
> 
> Your QWP work relies on local_lock -> spin_lock transition and
> performing the pcp work remotely so you do not need to disturb that
> remote cpu. Correct?
> 
> Alternative approach is to define a moment when the housekeeping
> operation is performed on that local cpu while still running in the
> kernel space - e.g. when returning to the userspace. Delayed work is
> then not necessary and userspace is not disrupted after returning to the
> userspace.
> 
> Do I make more sense or does the above sound like a complete gibberish?

OK, sure, but can't see how you can do that with per-CPU caches for
kmalloc, for example.


