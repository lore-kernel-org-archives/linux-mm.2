Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88EDEC61DBE
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 21:04:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97A196B008A; Wed, 26 Aug 2026 17:04:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 951BB6B008C; Wed, 26 Aug 2026 17:04:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 867456B0092; Wed, 26 Aug 2026 17:04:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5CCC16B008A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 17:04:37 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5B247120259
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 21:04:35 +0000 (UTC)
X-FDA: 85144649310.29.2BC45C6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 86ED618000D
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 21:04:33 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lhQSVXjd;
	spf=pass (imf06.hostedemail.com: domain of "SRS0=KFgM=GT=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=KFgM=GT=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787778273;
	b=lS6aCXT0nN5rZnIJuM9xfBtH60YVeahqG41ol46Hjj2Ibvq4BrT8Ga8A/uOktiIbaT5+Hx
	xu7IA91pC6/vLBfiEmcBmv1r2nQjWoPhbZwQ1TtoCeDhwiozhVgUTkN5TXswJH7uDHAOyR
	L92WI3FRBmrKcVYbHNDvKITyJm0pYME=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lhQSVXjd;
	spf=pass (imf06.hostedemail.com: domain of "SRS0=KFgM=GT=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=KFgM=GT=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787778273;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wd9D8o6DYVa1N38/T0CvGYo4puGoZ+VeLzsnpIr+Xj4=;
	b=Paqcs1A1VD4PmLcJAWagV3kgRowcEE0LpnZmcVZK2bHpdVrLLUSU0hcnKTrB+l6U2hdGaJ
	kI8PupdBoSNysxNJ0rWc08JwAZxQ9hz3xVrYrSwt6o6hnTcErd3sy5pqxHpf8K/Hd/pvB9
	N25XK1Eoy6fyi5NqMoj7WXC5m5fNFwo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BD75541671;
	Wed, 26 Aug 2026 21:04:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9975E1F000E9;
	Wed, 26 Aug 2026 21:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787778272;
	bh=wd9D8o6DYVa1N38/T0CvGYo4puGoZ+VeLzsnpIr+Xj4=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To;
	b=lhQSVXjdgZwex5bvjjr7tkNgtCyI0uh3QOi97Mn+cGoo7bug7cBFqPh4Bcvz/TW1M
	 haTgWlQYOjVnbxfJx3B/DsL6ZSG/kf9n1MrX6q26iIpenqY10g/rg2fzjlgJt14sWG
	 3dSP5E2srWDX+MEwBm0xlxAYMEf7oC9hyARAxYmEsiZnl61DzYrTeBGqgOlt994U6V
	 i0JOpFzibPy2UxMEjVA1dC53FAjJ/qrCFVWNaBQqfi9CKA3NMZttw9YiEWBG6oDoC9
	 G/UCMlmFl1i8BdHtuy/WX37Q/rns6nlG5d9xsX6gn+ww/fTV8ZHmgPc5lTz1AEvnWz
	 JWfsvLvEd2KUg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 64492CE086B; Wed, 26 Aug 2026 14:04:32 -0700 (PDT)
Date: Wed, 26 Aug 2026 14:04:32 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Sean Christopherson <seanjc@google.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Michal Hocko <mhocko@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Clark Williams <clrkwllms@kernel.org>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Jerome Glisse <jglisse@redhat.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-mm@kvack.org,
	kvm@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mmu_notifier: Remove non_block_start/end() from
 notifier invocation
Message-ID: <4415dbf2-10b0-4cb1-b045-13dbcd69c5d5@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <b0be19e9-b0ae-48de-bef6-d905ee007c8a@paulmck-laptop>
 <ao3z7Rtw2FROkVpy@google.com>
 <d4f8ff92-08ac-4253-b647-f9e95c66698d@paulmck-laptop>
 <20260826073233.T-KtFXmj@linutronix.de>
 <da5ee56b7d082abfbb20f71be99a6885247e9811.camel@infradead.org>
 <dbbd6634-4da9-4ecc-9fb2-d7430e2743ca@paulmck-laptop>
 <98e123c9-3dc4-45fb-815b-881b3346741c@paulmck-laptop>
 <ACC45EB6-F881-4EE9-A9F8-D53A2B921FEE@infradead.org>
 <e62a7362-7dd0-4615-8877-6ab675971ab2@paulmck-laptop>
 <06F9A0F0-2177-4173-A201-56325A73F89B@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <06F9A0F0-2177-4173-A201-56325A73F89B@infradead.org>
X-Rspam-User: 
X-Stat-Signature: sm14r858u9ah18cqut9dija1upgoweg9
X-Rspamd-Queue-Id: 86ED618000D
X-Rspamd-Server: rspam06
X-HE-Tag: 1787778273-356707
X-HE-Meta: U2FsdGVkX19tbqMsQFGqEDJMuhNdddubcxBn/amSfDcRx2l2QxiNJ0q8lFcyEnnLsYUfzf6p6FfOn3T7L1kdNpdd73qwF/04bgvx0oWmSUHiccLa4Y2jGgHNn2ZEUdM34wu67p5X1OJTfX8VzhvdgBKINpolON0N1drpRebDIaAh7wnsybQnUFb5uyEsm9YuVRaVB/1ay3w5Jm0hQG5dhe3k+j9pmNVGwaOg54dgd0atKbFTj/Ap9EwmB9eGCDwUq4KVopqM/qvaBl7UnXlV9jF7SZg6ib+YAubdirslzmG4QFb9C/dcEii/IdVNpooN/OW4eKo5ueiBqSA9gVGmWQAYU+dKj+iZoy74jgOmm9Or7YcGq+XjAHGMS7NcoXAyK92tJIOS2bEprsOEM6ByKLld8ecvPMk3Hw1/ykpXNEWImVY2FCR6fQzbsmbglS+uzh/WebalpzKCTqv7ezWN/QGiOIdVm8kmiIGG45vrd5R1SmMRy0WM5fADr8Vgr2KFmPT/QjexcjvOkLxD5/hYKv8cbZBR2p9RUVkEAaEFdmvqdlDfTLwlabdpWUUw9Q0zsoGzquydLY15KMV4JPHRWvZlAnlyg0I9QtoOl8oZX1who3azkAr4WQ6sn3vssmC3b/IGhNeMhFMMzh8JvcDhLN0T1+ZXrR9lbQdvjx/ZnreQdtxIPa7myvG60NMImNNIKQIZEDkyb8r3cSVJcA8DlaS/x4DHuk6F7L7P/OP9WenY86wR3sVHapB3oc1140hvVC+P1d2YtJ3J1lZO79r3F3Rpiu5isw1WQ0qxS/NxakV6OoqT51DreB+VeLwNEpwFDyYIi5dBylj/JV6CmONhLUEvZESTe29N+E+zxRR7FziE+N8IaM5OYyDlYpiRDZwVyedifhUioncq0bICGyzeWZzA4J/2GY02gGB/UwmV7I0OtzFPvj92kfyLoFChqtsiCR91mtSH/pxczce/MHQ
 yMAF/8DH
 8+SwpRlb39XREhs0xWhPXKk7LxF7XUST6EGMeSJlkaT7+8CoWXSmW/wI6X26pJ+GLKefxJCj9eEXq2OISwFUSXCSRCba+mRnpFlZTRRcvWeri15i1TCHiNiljHoWBFYMZDZFuijen//bViNrgUZ/CenRyJKOwvF18xW5AfF+98zRUnRqwiXv9tIr3bHOtQeWSp9TNeADd3JcYeJhDJG1edfvJyMM7L15vyxWRu455dZljlJL/etbAbY67LUi1UvO8Jl3sxAQYxrKoGESRzu4qnjWhls2xZD/Y92ITDuIincpd3Bw3EGmJPKEcWBKpO3QQZj22tXR7+M1/2rJd1JGTK8SbAigLg7n5DhUYAP8T0kIeC2ibcBhgVQkq0EHE/HSdxOhFHuRHE4nyeHkhSpix4pZRmXZpdTCV0I6DyQqwy2VOro0cf/0xo6CPC4k0LTIIqCwBeyZWQ4RCp3Z5Jy2Aukzs8vt5URZ04JZINM2k8i1WawBaEDo0WYPvPOZIOfvFD0MMEztybr2rAP3WE3oNouI5fC/9d99VWkjg9CEiENPml6k2E26MuCySjoNE5dbevZRcxn/F7COU0+91rbcSFv2sbfYxt8Mkm6uBBT2ujiPkIEAYXOO0m+yhspHTwXn9vS8YBo7sovSD3DzdF2ZPLV0Mhw/3hoUgfGSz6HYe/QutjMyW1nhVerOMkU7J268HMZtMf2BsOBXgQ7Rsre2X5pJjBjCDucLspBbmDFRb1DicdylEoNln1jHvZ6FEUS8OqfsyZF44RIBf7M7XflxtPOPV9Vlb5BS+pTq6d2XmXhw0EcBI27FMhMBbncGuaeZvhL/o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 09:30:43PM +0100, David Woodhouse wrote:
> On 26 August 2026 20:59:31 BST, "Paul E. McKenney" <paulmck@kernel.org> wrote:
> >On Wed, Aug 26, 2026 at 07:01:24PM +0100, David Woodhouse wrote:
> >> On 26 August 2026 17:28:27 BST, "Paul E. McKenney" <paulmck@kernel.org> wrote:
> >> >On Wed, Aug 26, 2026 at 08:05:06AM -0700, Paul E. McKenney wrote:
> >> >> On Wed, Aug 26, 2026 at 08:38:27AM +0100, David Woodhouse wrote:
> >> >> > On Wed, 2026-08-26 at 09:32 +0200, Sebastian Andrzej Siewior wrote:
> >> >> > > On 2026-08-25 13:51:14 [-0700], Paul E. McKenney wrote:
> >> >> > > > Very good, preemption disabling it is!  It is quite possible that the
> >> >> > > > PREEMPT_RT guys will need something else, but one thing at a time.
> >> >> > > 
> >> >> > > This reminds me of classic RCU ;) It might work in this use case but I
> >> >> > > am afraid that other users might come along where it actually hurts.
> >> >> > > With PREEMPT LAZY the preemption within the read-section should
> >> >> > > hopefully be the exception.
> >> >> > 
> >> >> > Given the way that PREEMPT_RT treats other locks like spinlocks and
> >> >> > rwlocks — turning them into sleeping locks — I suspect it makes most
> >> >> > sense, and is consistent, to also turn rcu_read_lock_atomic() and
> >> >> > synchronize_rcu_atomic() into plain rcu_read_lock() and
> >> >> > try_synchronize_srcu()+synchronize_scru_expedited().
> >> >> 
> >> >> That makes a lot of sense to me.
> >> >
> >> >Another option is to instead fall back to non-atomic SRCU.
> >> 
> >> That's exactly what I thought I was suggesting; I think I left an 's' out though :)
> >
> >Heh!!!
> >
> >About 20 years ago, I was shocked to learn of a valid use case involving
> >sleeping RCU readers, which resulted in SRCU.  And now it is time
> >to be shocked at non-sleeping sleeping RCU readers, and especially a
> >non-sleeping grace-period wait.  ;-)
> >
> >Anyway, easy enough:
> >
> >#ifdef CONFIG_PREEMPT_RT
> >DEFINE_SRCU(whatever);
> >#define my_srcu_read_lock() srcu_read_lock(&whatever);
> >#define my_srcu_read_unlock(idx) srcu_read_unlock(&whatever, (idx));
> >#define my_synchronize_srcu() synchronize_srcu(&whatever);
> >#else
> >DEFINE_SRCU_ATOMIC(whatever);
> >#define my_srcu_read_lock() srcu_read_lock_atomic(&whatever);
> >#define my_srcu_read_unlock(idx) srcu_read_unlock_atomic(&whatever, (idx));
> >#define my_synchronize_srcu() synchronize_srcu_atomic(&whatever);
> >#endif
> 
> We could do that for the KVM GPC locking, but more consistent would be to change *all* users of the 'atomic' lock under PREEMPT_RT to silently get the sleeping version instead, like PREEMPT_RT does with spinlocks and rwlocks.
> 
> So it's srcu_read_lock_atomic() itself (et al) which would get that if/else treatment.

OK, the traditional approach is that raw_synchronize_srcu_atomic() and
friends with the raw_ prefix are always atomic, and without the raw_
prefix it is atomic for !PREEMPT_RT and non-atomic otherwise.  You would
use the non-_raw primitives.

Easy enough to do.  But does it do the job, both from a PREEMPT_RT
perspective and a notifier perspective?

And notifiers (though a different type of them) were the first use case
for SRCU.  ;-)

							Thanx, Paul

