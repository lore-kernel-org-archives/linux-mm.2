Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4789FE9E31B
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 15:43:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD25D6B0092; Wed, 11 Feb 2026 10:43:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7FFC6B0093; Wed, 11 Feb 2026 10:43:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98C496B0095; Wed, 11 Feb 2026 10:43:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8A2A46B0092
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 10:43:13 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2E52FB9555
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 15:43:13 +0000 (UTC)
X-FDA: 84432594666.24.25E1970
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id EBA961C0006
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 15:43:10 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="fVc7/mIe";
	spf=pass (imf20.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770824591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QAsCSJyvhO4BKRpaZq8qCLo9xLrC1Bu2FU5B/EJQXzA=;
	b=XBJ9L2rJnOyRzVoZp4mZq1ippwrOP7Y9P51+t2Wrkj/93LnPvncf3rBmjcGow78AFB6b0n
	qvR827dxUqacNTywnuyojbUg3aSliA/L5XNQo9lQjIPMfzQKAW3DXmwljx97uZPAFO7qvh
	PNW8mbhtE2+2ULnQauYx4dEkg6RBTns=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="fVc7/mIe";
	spf=pass (imf20.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770824591; a=rsa-sha256;
	cv=none;
	b=H+HuR3kGQdvX+blxWfdtQCPmk6L5Ph8Xy3cS6bkyiLqvPm2xkFhdEDjgxY1hempUgxRfUR
	rVRIatovbBHMxsXFL320P6tQoJP7EJ6TJyWQAFT3BaJZu9/UXpNxuu2/3OBKNF9Wp5ecrQ
	X64XfdBdKZKW8tPi4KL4Iaq7/Begc5o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770824590;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QAsCSJyvhO4BKRpaZq8qCLo9xLrC1Bu2FU5B/EJQXzA=;
	b=fVc7/mIejKqxg3q6sUgGOM1cUtTs8f7Kr4rU/MDJp0BH8eIjDdgx5nIf8wcyGyzGF8F2vU
	I2/i7SsoRT2+iRD3Ti2wcmrcyvPNaHapAzuycKNZ734wO0lH7+g7zS2nJpTzQfXYteLQAE
	0DZBJo9/8/uQ3leV7VO6YKKBgO9C6pI=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-608-VY_sHjiSNkmUh9yogSGtRA-1; Wed,
 11 Feb 2026 10:43:06 -0500
X-MC-Unique: VY_sHjiSNkmUh9yogSGtRA-1
X-Mimecast-MFC-AGG-ID: VY_sHjiSNkmUh9yogSGtRA_1770824584
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DA8E7180057E;
	Wed, 11 Feb 2026 15:43:03 +0000 (UTC)
Received: from tpad.localdomain (unknown [10.96.133.3])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0104D19560B7;
	Wed, 11 Feb 2026 15:43:02 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
	id 5CE154036F1D0; Wed, 11 Feb 2026 09:01:12 -0300 (-03)
Date: Wed, 11 Feb 2026 09:01:12 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Michal Hocko <mhocko@suse.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
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
Message-ID: <aYxviLoWsrLqDU7o@tpad>
References: <20260206143430.021026873@redhat.com>
 <aYs6Ju2G4bm6_tl2@tiehlicka>
MIME-Version: 1.0
In-Reply-To: <aYs6Ju2G4bm6_tl2@tiehlicka>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: z1_br-YVefUs_4kB1B-xkG0tpMK3T6rlj6wbrNe9Y4Q_1770824584
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EBA961C0006
X-Stat-Signature: y753zp16czge4sm8k4jfgo6j3jot84b7
X-Rspam-User: 
X-HE-Tag: 1770824590-839426
X-HE-Meta: U2FsdGVkX18LwjZCeNA/hUbuLjptM6ezUGX1wIInjRe2bUMrVCvXPP2skRQSwdHBL1bGvQxGGz2uJ123RuyH7zcfekMtX8/4i9cts1654/CcZfhHrdOH7ddzw08Gh3bcXlaNMMq+Z0ut5wGxa4qkDOyDKVeB9zVn5qjlAXK7SGSvxBsgpG/Z3TMo8RBq+TS0mStoGiDRBJGtYww/pKc7MWX2+J4zcIaSIa0ZQwMIYIOlOoEkNEnOwAlSO7pSRHsJ9gmF6snnF8zgz+t5tq+wmmebUK8/h8sbsYDkRr7Qc5/IK7TpCiDmSt/SPvK80rjpkOLlnjtkdbcrsYfYc8LpcgDbeljpsE2PA2TygqFi6x44xCeC8LYO2dQfsMc1757VrcXVqNFvqg0gdjxV9ht2gTTpj/Dthow+fW2378AoUE8ccsU4PGh13r9LPHcCSa45IuUF7W1fs5O7b9ktaQ5lF03j6Oedkldab3nRx2kEZvss+9TinGXjXjiFYN3CPgo0MMJy2ovbA+HHujx/VJRwOIQj4DebF+F4zE0bOGGlaDwqWqAMreNZ+0nCjfeyKHdPVhYkU7hlJe/XVjf0eeYnsn2ThFdmfsep+y/ky+OS4/EGfnIzgQBIkujVhsKpQefzh/AZdFmLCbONBr/IFnIg8r7/4PoRHflNSlLGdGHxkYVTix2ACesCeZCqo3OW9vpc4HSQaGptDS83MhZYXDqf1UqfFUJZYPtakKqIYOWrFvhgKWfrcTpGrPtyDUvVtNRirmdwLYmNKYuP+mzZyhw9w9Kg21AbjSn6bZ/DfoKF4EUz+xhREUldHZBcHKaF3mEpZestZETwj8/BUfplHwvOQNy6HofNnIKArFhQPyqMdbf6hA40txQDV48BqvAbwGNkp3crwpg7Nz1QXHKwhGeSxO6MroEpqny1dIvJQideUrPhJE0YxZzC4lhsn4dcrGlR5KCcZvr60w9iY2zrR6l
 YW8Yelgq
 rRGrGFH3Mh0+Ap1J9SO1gaQ6CQFrudm4y3jiaFoz9Z3+IyHpUocuuQvf9B9A4wYpHZdOysQRKKSj4o+Vd9zZXEqySN/IZVnqaGRfO9dqDv5j9W2YINF1d2KGe7RPCle81aWvQNaRo2kTqRRY/g/tb/96Gqs4SU3AC13FDvJyQp2b1AtD1fDzWCdETpc1XGyDZe0KaNc0hc+dnc7+OqkNT059UKMhyC+nIDZ6Go8ndyG/MtWQJKHKNCBKCGTeZH2YH/NdfAaEBhz2C+MXaZc+fDmmAiHc15WsYwYxSkjKBLFVLOytCXVwLFTutCML1cEE/Qqe3xO9ISiMHAUC7/NilNjs/zlseCHtGiWGp/3cRH8+etBz9UJcV0D5YdulCjoBuSDcRoMvXK9rMw+k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 10, 2026 at 03:01:10PM +0100, Michal Hocko wrote:
> On Fri 06-02-26 11:34:30, Marcelo Tosatti wrote:
> > The problem:
> > Some places in the kernel implement a parallel programming strategy
> > consisting on local_locks() for most of the work, and some rare remote
> > operations are scheduled on target cpu. This keeps cache bouncing low since
> > cacheline tends to be mostly local, and avoids the cost of locks in non-RT
> > kernels, even though the very few remote operations will be expensive due
> > to scheduling overhead.
> > 
> > On the other hand, for RT workloads this can represent a problem: getting
> > an important workload scheduled out to deal with remote requests is
> > sure to introduce unexpected deadline misses.
> > 
> > The idea:
> > Currently with PREEMPT_RT=y, local_locks() become per-cpu spinlocks.
> > In this case, instead of scheduling work on a remote cpu, it should
> > be safe to grab that remote cpu's per-cpu spinlock and run the required
> > work locally. That major cost, which is un/locking in every local function,
> > already happens in PREEMPT_RT.
> > 
> > Also, there is no need to worry about extra cache bouncing:
> > The cacheline invalidation already happens due to schedule_work_on().
> > 
> > This will avoid schedule_work_on(), and thus avoid scheduling-out an
> > RT workload.
> > 
> > Proposed solution:
> > A new interface called Queue PerCPU Work (QPW), which should replace
> > Work Queue in the above mentioned use case.
> > 
> > If PREEMPT_RT=n this interfaces just wraps the current
> > local_locks + WorkQueue behavior, so no expected change in runtime.
> > 
> > If PREEMPT_RT=y, or CONFIG_QPW=y, queue_percpu_work_on(cpu,...) will
> > lock that cpu's per-cpu structure and perform work on it locally. 
> > This is possible because on functions that can be used for performing
> > remote work on remote per-cpu structures, the local_lock (which is already
> > a this_cpu spinlock()), will be replaced by a qpw_spinlock(), which
> > is able to get the per_cpu spinlock() for the cpu passed as parameter.
> 
> What about !PREEMPT_RT? We have people running isolated workloads and
> these sorts of pcp disruptions are really unwelcome as well. They do not
> have requirements as strong as RT workloads but the underlying
> fundamental problem is the same. Frederic (now CCed) is working on
> moving those pcp book keeping activities to be executed to the return to
> the userspace which should be taking care of both RT and non-RT
> configurations AFAICS.

Michal,

For !PREEMPT_RT, _if_ you select CONFIG_QPW=y, then there is a kernel
boot option qpw=y/n, which controls whether the behaviour will be
similar (the spinlock is taken on local_lock, similar to PREEMPT_RT).

If CONFIG_QPW=n, or kernel boot option qpw=n, then only local_lock 
(and remote work via work_queue) is used.

What "pcp book keeping activities" you refer to ? I don't see how
moving certain activities that happen under SLUB or LRU spinlocks
to happen before return to userspace changes things related 
to avoidance of CPU interruption ?

Thanks


