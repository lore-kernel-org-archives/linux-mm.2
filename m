Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62F75C61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 19:10:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67C356B0088; Wed, 26 Aug 2026 15:10:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 606906B008A; Wed, 26 Aug 2026 15:10:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CF466B008C; Wed, 26 Aug 2026 15:10:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2B1F76B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 15:10:35 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BA825A1897
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 19:10:33 +0000 (UTC)
X-FDA: 85144361946.10.492A821
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf22.hostedemail.com (Postfix) with ESMTP id B34FDC0004
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 19:10:30 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=c6vy+PSi;
	spf=none (imf22.hostedemail.com: domain of BATV+595d0ee0c1a2dd37ff28+8403+infradead.org+dwmw2@desiato.srs.infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=BATV+595d0ee0c1a2dd37ff28+8403+infradead.org+dwmw2@desiato.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787771431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3telYjFYiWNOnHqk6Dt2Y5vLbqkVmH61rJgzRfZORkE=;
	b=J7qa+A+1ZtfpHH/Pg4XBpiXh/XPvcLiTKF0G0gFlahmIStOF7e594gUz4FkouMat+Qdgs7
	fYKzQKMAGYbBjPQ7oXpU0RFzN99R1CbQTZk5Rhpy9NWSYWmCD5VQ31dauM3j0dXpJsf7VS
	HXClFX0JbZySplUIBeOhoex1tLza5Wc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787771431;
	b=L4AlEk57tOyHm+sC9J+mczFEKzPqwuDyjLSvbDOoSK0zFHpQ5WjEWIvA25IYeA+8Elz50Z
	+YutdJrBF0uyQimdXliymHtjDk4JI2/z6BXuCgN+GREzO2Ye+2QSEj6pVNKbIjnqDrdtjX
	c1foAdOk/auPMnPvF9LEqGH3BGr80zg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=c6vy+PSi;
	spf=none (imf22.hostedemail.com: domain of BATV+595d0ee0c1a2dd37ff28+8403+infradead.org+dwmw2@desiato.srs.infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=BATV+595d0ee0c1a2dd37ff28+8403+infradead.org+dwmw2@desiato.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
	:MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=3telYjFYiWNOnHqk6Dt2Y5vLbqkVmH61rJgzRfZORkE=; b=c6vy+PSit0j/le3s0QJFFYImMr
	IHaddo0nuwaFMQ/MVxza04PgyCm9f0wR/uzkxodvR8a2Fj8SdTkJH4CkiG5KjCWySBoPoGg/YQpGv
	7XsmN+r7L9z/BhTvpD9T5o42mHwxY2mDN5KDnJ9Tow7hwByKqmATZlWA3ak60eo6H3Go7fP+F3oEf
	h5onVBx3nbtrWxIOEGzmbNXxvacoWAbeqG5yCr9ZtSKGa25ud2vHSUeeAKmZBuTfNkJBPpMGiQidY
	+YhpZmPa1ZSobw6Mcq8O2ZVCbOySpe3kZTSvdS2WPrLr4HWhYRXGxTANNvurBMtC3ep+fvl1Etqc+
	S+3Af6Tw==;
Received: from [2a00:23ee:1948:28bd:e7b1:3e8e:1bc4:19da] (helo=ehlo.thunderbird.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wzJ0m-00000006xg1-2wXV;
	Wed, 26 Aug 2026 19:10:19 +0000
Date: Wed, 26 Aug 2026 19:01:24 +0100
From: David Woodhouse <dwmw2@infradead.org>
To: paulmck@kernel.org, "Paul E. McKenney" <paulmck@kernel.org>
CC: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Sean Christopherson <seanjc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Michal Hocko <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Clark Williams <clrkwllms@kernel.org>,
 Simona Vetter <simona.vetter@ffwll.ch>, Jerome Glisse <jglisse@redhat.com>,
 Christian Koenig <christian.koenig@amd.com>,
 Paolo Bonzini <pbonzini@redhat.com>, linux-mm@kvack.org, kvm@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH=5D_mm/mmu=5Fnotifier=3A_Remove_non=5Fb?=
 =?US-ASCII?Q?lock=5Fstart/end=28=29_from_notifier_invocation?=
User-Agent: K-9 Mail for Android
In-Reply-To: <98e123c9-3dc4-45fb-815b-881b3346741c@paulmck-laptop>
References: <69567965-48fd-48c5-abb6-0699d7f5bd16@paulmck-laptop> <124af87fb49c267eeb26b8b4d952b9b1a5b3fb68.camel@infradead.org> <9427a8e0-3ba6-4f31-a35d-54429bd7e071@paulmck-laptop> <3d0463b6099d4fcde9a025a2f9e231d75303b61c.camel@infradead.org> <b0be19e9-b0ae-48de-bef6-d905ee007c8a@paulmck-laptop> <ao3z7Rtw2FROkVpy@google.com> <d4f8ff92-08ac-4253-b647-f9e95c66698d@paulmck-laptop> <20260826073233.T-KtFXmj@linutronix.de> <da5ee56b7d082abfbb20f71be99a6885247e9811.camel@infradead.org> <dbbd6634-4da9-4ecc-9fb2-d7430e2743ca@paulmck-laptop> <98e123c9-3dc4-45fb-815b-881b3346741c@paulmck-laptop>
Message-ID: <ACC45EB6-F881-4EE9-A9F8-D53A2B921FEE@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B34FDC0004
X-Stat-Signature: cwmdoutypips9baaooutfp4zn3dds9cc
X-HE-Tag: 1787771430-391860
X-HE-Meta: U2FsdGVkX19cjqVC0DMO5RCCArEmqO1dmd11/kCcMgkPWT970FyIAkAstTDRjVhQMcth+mbV73ylCSEAXWWg4VIHXoHlCr/eInDjeWnnmXeARq0aZRlxbNB448AA2u2VsKN68roEAOxp7KmuIXuOviznNuXJ9oc50JVlEgxoHXy9OS8R41z9narCtzaWh/C+YqyG96M+Ofm7dAV+vZxzCq1nwzQogu2IWp4AO/AA6yp833G7QBfbZeeCn+XSqeHP+VFuMgEs/w2cQtYfui4AeLDUvxnNkw/JALKMWZ9Wvq9K2lbB5Buevxs+cbLSLDns3gVp6Vnjwbt4FbQ1ZZCX/fOKCZgun8ZmIcFyUgzIia52G/B6MxkwuSeqZo4emZ9e5LBf/w9rEztZHxxm773IlUFC7VCPHUln2yy/vuX1NyjM97EDjEhT3ILaPnvmvQ7EwHAo3btDHMjAQmHXIdQqKil4Wl/pJYucsf38cbe1b/W0brYWZFrEJ0TzLScmIn+NpQ/86A4Cej4Vk0N6g4eqGErJq6xPIS+uEnY24bq3qghl6Px/TKIg0bQ1nlxyh/aGsuVY+Xk6xdoR+Y961x6ykZ5Dz8F/qWZIR8oxyTYrnc3XxILNXtYrp2G+TMeDSCNu8kGHR0GIgdm9OzJ2JnjhZs2OSqWJGB8iMMLVZdZK9jlfy5i2kPOtY2fdMP59pQXsaCFuqJUZtX5BlfXNugYGZ0Za3oCqQFQ9ssBFUsYj7udAx0UBy5H7uDSBFRGIVYp0V7uP4/9gfphYM3+sM6UMPOrgJYJe7VZsKrbADc93CxbwoqPnktWluxX4mbzCAKsIBNTG7xotW/rZA2TnbMwGwUG5AB7g5R+K7PQDEWqYKx5L+vPNlDP8RUNgJP1eld5096CbJof4NUjXamCyvH6wRzvCIXfEw4lb6z7H3uNccJr6HjKfFEZ0YDMJ+vbDIv4jnefHCJf3BEY0qfJIwrS
 Xo6rRiLD
 vzNeUrgg0jonV08Lza394WtyYkXPkUZKLlA45nqnhogWOH/pRsvRUcJjMjYCL7splT+sYOTv1jgsHCPPS/vMtimAnRJXFaltvQeO53sXDYI7q8B8OKFCH+XsulFkMacUEvHgABUc4Mk0A2XbFAE6Kmnxzw4KHS3/vQwI7mhsMYMdy3sUHsyu45PQGiZ+evLdhfk1ETOZR8dx4/HNECt4r7XoYRL8c0gjBqxCtyb95lmT/1bEJ//6NY3308H5Jcc++iTiJ0ZCPSpH6mFZC6a4fRZlW212Kf6soNDK+EEPWp/gtWSnZPSPxF2ZiqZdTOGwnStaPnjPeI0SiSad/n5D9hTuhcstBeVbP5CzV2EjlJzkm1IxXZ6Fd1HEceT/0WUuWNssdyLPQ2Mda4Iuf7E6oXvJPDI9QH8E3hwPdAZJbZ2WxtABCnvg3O/6FzyUwiG3N3MrdvWedUyfrHc+aHXzQK7nGzhlWgDQNeehBF45NKl++zZKx0EuTzfdxY3nX6YMPRCKyuvOOkALLiTt9BQb/W8iAM37Sxmvow+Psxm2aZl4AHt+OOz07OSXqRAldmSluh5fIPqovBE4kHeuVBfJAza6hVajgUzQsQuwseO4WQLEWVUoxMqzb1hgBfrDumEOOFM5wTY5wBIJ3uXBc+9oTyuM+DhzMGKIkdK2t+HUsYT28STuXHLWP49Zv3GUx/d6s2WS2YFBJUcIwi7A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26 August 2026 17:28:27 BST, "Paul E=2E McKenney" <paulmck@kernel=2Eorg>=
 wrote:
>On Wed, Aug 26, 2026 at 08:05:06AM -0700, Paul E=2E McKenney wrote:
>> On Wed, Aug 26, 2026 at 08:38:27AM +0100, David Woodhouse wrote:
>> > On Wed, 2026-08-26 at 09:32 +0200, Sebastian Andrzej Siewior wrote:
>> > > On 2026-08-25 13:51:14 [-0700], Paul E=2E McKenney wrote:
>> > > > Very good, preemption disabling it is!=C2=A0 It is quite possible=
 that the
>> > > > PREEMPT_RT guys will need something else, but one thing at a time=
=2E
>> > >=20
>> > > This reminds me of classic RCU ;) It might work in this use case bu=
t I
>> > > am afraid that other users might come along where it actually hurts=
=2E
>> > > With PREEMPT LAZY the preemption within the read-section should
>> > > hopefully be the exception=2E
>> >=20
>> > Given the way that PREEMPT_RT treats other locks like spinlocks and
>> > rwlocks =E2=80=94 turning them into sleeping locks =E2=80=94 I suspec=
t it makes most
>> > sense, and is consistent, to also turn rcu_read_lock_atomic() and
>> > synchronize_rcu_atomic() into plain rcu_read_lock() and
>> > try_synchronize_srcu()+synchronize_scru_expedited()=2E
>>=20
>> That makes a lot of sense to me=2E
>
>Another option is to instead fall back to non-atomic SRCU=2E

That's exactly what I thought I was suggesting; I think I left an 's' out =
though :)


