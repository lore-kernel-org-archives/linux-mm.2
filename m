Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8E3EC5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 19:59:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9221E6B008C; Wed, 26 Aug 2026 15:59:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D31F6B0092; Wed, 26 Aug 2026 15:59:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C0EA6B0095; Wed, 26 Aug 2026 15:59:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 575B06B008C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 15:59:35 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D8C291A0200
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 19:59:34 +0000 (UTC)
X-FDA: 85144485468.07.97E2DD1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0DC594000B
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 19:59:32 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HpkDQYM3;
	spf=pass (imf17.hostedemail.com: domain of "SRS0=KFgM=GT=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=KFgM=GT=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787774373;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eKPW/iuHg1j2h6dZ9e5C+Ipu3cGJwB9tdZgvrYICRsM=;
	b=sBivrBwEp1AXAJ5E6Z44GvCAYhxT0Bt2zX+cayyWi9uIhapAX0AdRCs1KOEf1BfEfWmfIE
	AKB8MBYOcfYmw42IPuXia1fntU8zHGFJXVZPa7Rz4TukIjpg81MUgQroUdc+Gq4EH1Ufdx
	jdtAwgsFaD4AlPGuD9m5UR1KNFQDgqg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HpkDQYM3;
	spf=pass (imf17.hostedemail.com: domain of "SRS0=KFgM=GT=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=KFgM=GT=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787774373;
	b=rkROdRfheeKQWiCrng7XFPROfGOBRKkjbwliowjlMDx0YTYCiKht0DbVcInBj4XVpNNh0G
	Blec3P6edy2IjFRXse4Lvx4YYr/dtc/qbJU1LBqft3D6VgV++0UcQ+u6W4zitvtCp04RWu
	122emLexoFDqPwtT6vH1oZa7oUhRQws=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D0E2841604;
	Wed, 26 Aug 2026 19:59:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF9BF1F000E9;
	Wed, 26 Aug 2026 19:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787774371;
	bh=eKPW/iuHg1j2h6dZ9e5C+Ipu3cGJwB9tdZgvrYICRsM=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To;
	b=HpkDQYM3bLmHle/vutflxN8rq3rytEYtj22NqgqqtG5Bw9X1U05PRmODYavLMAHmV
	 bg7HR8c2uL88D/2tG+arrf/CDP9QXzfP9z8agK1NSHmO1Hcm8e9LR4iSKg1DnhExIU
	 rzZHaM8LjDc5/YchWQbldEYz/IWzfZAuUDasVpMPkL6pH4v7gsuaJLDD45JiOE9+N7
	 NwqIsw41ntp5M5ePHPacE3q3w48FU+egzG2HoOHjcWnouy9v2JN1dsqaZKFuTmXSmW
	 UfVFLuhUUACyiWv9Qax63v96g6mtcR3iJQ+k2Mh5ExGhlL2N1nIkRF2DHiaMKV2aCI
	 PLf1bWiXpVOoQ==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 6C907CE086B; Wed, 26 Aug 2026 12:59:31 -0700 (PDT)
Date: Wed, 26 Aug 2026 12:59:31 -0700
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
Message-ID: <e62a7362-7dd0-4615-8877-6ab675971ab2@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <9427a8e0-3ba6-4f31-a35d-54429bd7e071@paulmck-laptop>
 <3d0463b6099d4fcde9a025a2f9e231d75303b61c.camel@infradead.org>
 <b0be19e9-b0ae-48de-bef6-d905ee007c8a@paulmck-laptop>
 <ao3z7Rtw2FROkVpy@google.com>
 <d4f8ff92-08ac-4253-b647-f9e95c66698d@paulmck-laptop>
 <20260826073233.T-KtFXmj@linutronix.de>
 <da5ee56b7d082abfbb20f71be99a6885247e9811.camel@infradead.org>
 <dbbd6634-4da9-4ecc-9fb2-d7430e2743ca@paulmck-laptop>
 <98e123c9-3dc4-45fb-815b-881b3346741c@paulmck-laptop>
 <ACC45EB6-F881-4EE9-A9F8-D53A2B921FEE@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ACC45EB6-F881-4EE9-A9F8-D53A2B921FEE@infradead.org>
X-Stat-Signature: te8php3jenx4ragffu84t61h5chmfs9g
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0DC594000B
X-Rspam-User: 
X-HE-Tag: 1787774372-273269
X-HE-Meta: U2FsdGVkX19SguXcWvS4ZIldppCeyXwNda1Gg6i5Lnpvj9wiceEX5wlKFuLJSFMCLoZxD9xis/e1Lh76YIFHWEFam/DES6BaRLuckJVJLKMbNZutp7qs0UGh/E/X++eLnfX/8FzkMMeHgfm3OppRmxjBXdPmOw8W+VqR1WmzlxUWHppNtwtye0og10rZS5bCRmnifqS4oV8aRAuS9frFlq0MyU2nsabC/4bed3JT7quWV/IGXGrVn1pPpVLHMZgFeUgIGbXUHjHpdzowzqjlLyf0b2/3gg0MXrrzxrwk4wNSqdYQ/aDpbiQ2Utm2UiVr1DNZyNMF/LzHx9FJsIwRskUiAdvSN7gxQRoRlHm9uL1gsXrTstFAGOjhHkxSseIO+4RsDdaqBTxTswFJx+tgCTlR0m0EhfEdftvkiQtDCQ2JRZOZYM7nGETbvCqEoXxP54HZdBnRB7pqIsJHORecy2MNvvUWmOkaYS3siBHHGBSeBZOVZfwIwNaWII74UIbM1DGFCCm+lx3s+l6GU6xFhpdnEoegc+ubC53Ie8t3DKR9539987pHQvg7gtd8I5uVfOgOD3LFjL7u4EYcZcsb4DUVibfzN1/76iT1dgM5xKXBtb0hb5eNrrDZMCd9TPN4RffY0+N5Ul7MtwSm5MMf2fPWTDD0VSe/jl1imCKmy+X+OfBL9PIi9GCOMGU1KkgsOfyeuuiwgItIugKMpK5ijWGCIghDJ9H67xa+u6uceweLZXCLQk2ftiR1+hC/OFzMFDRdH5lrDl/iXadsFJ3zr0kOiCUT9Zt+HezudnkE1+xJCHCHlpi1IN4IZ/Pzx810aleZk9/s3AFDr92CXih3lAbpdMiTclnOchRLoNoAG3emNSSpwl14DHP9bQffi0UGSyUxqrnPA5nQs8LyZ5XSjVVJpNO+oqZskVMg6zdemD2jjRhuXKMu1SuwkBtop3zVNdMJyE81+xWYd8MAQib
 Q2hI8OJe
 HoclT5PvPWGwY653N8QXpE1KJiz9haSJ02tGfhZ6v/iG2Vdf1M10Vy0LRmaq2Cw09xkyfFT21UbbMsJJBBDVgAqr5/ebgCvmkatkiTqUdpIhFhT/yvqSd38X+vlZ15iaQRvU8BaFR+XFO8Vho0rm17oAL80Z4qnQg3/yAZcNA1lzcsvRJ/Dz4MV2PxaCwB/+lUEMPN1FrxgxqzS3y3IdI0LUTUpT/xqOOL/r3PEktTUb6GernujADtQbtakHun+SsfriE71j0RM9SGKtpi3ddy5pugTBZuOIrsoHrhEXh5C5spUhuFwc1WdhWFpTKSBIq83oA/N+7T8GQtOBiKIHyBUeF0NB5QkSp/rJm72kT7uuD9UphM11fOs1tOP1Tyx+tRdvqwsPGm8MVil6IpbmdpSRM6QKT3t+xfrC0PFwuMo91qkf1rPaWko9FxQiCxZuGnZF/lmmWNq9jx6qhsSYYjhiH8byemA6wq1qmQP2IDdgPTZ5GAcUOLev/eJO/1LHAoz0iecIZz8/aAhC3oJvo0MtooKsCoHHEOD5ZmmbuvVX4wWvcgRQRD50z/qIoN6TsgzmtOnaBBIMInBkPLDGJATS30v5iIY65QcPHpLSU3ybHCi4U3MyRxmnzxUtB0fU7Y8Cn/lO2pcXu2mfAiyn1SYSblab8uk0nWg7UCuTANzJH1ItA4uA8MH9o+wUZ6Xm4OrpImVOQXwgs44/AFbr/QZfymosX5g/0eAA2VIJT0kxOiHHHiMEJiHy/UkNvKNRvCXaICEwpYIa4g0KAYvfCg7WgjQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 07:01:24PM +0100, David Woodhouse wrote:
> On 26 August 2026 17:28:27 BST, "Paul E. McKenney" <paulmck@kernel.org> wrote:
> >On Wed, Aug 26, 2026 at 08:05:06AM -0700, Paul E. McKenney wrote:
> >> On Wed, Aug 26, 2026 at 08:38:27AM +0100, David Woodhouse wrote:
> >> > On Wed, 2026-08-26 at 09:32 +0200, Sebastian Andrzej Siewior wrote:
> >> > > On 2026-08-25 13:51:14 [-0700], Paul E. McKenney wrote:
> >> > > > Very good, preemption disabling it is!  It is quite possible that the
> >> > > > PREEMPT_RT guys will need something else, but one thing at a time.
> >> > > 
> >> > > This reminds me of classic RCU ;) It might work in this use case but I
> >> > > am afraid that other users might come along where it actually hurts.
> >> > > With PREEMPT LAZY the preemption within the read-section should
> >> > > hopefully be the exception.
> >> > 
> >> > Given the way that PREEMPT_RT treats other locks like spinlocks and
> >> > rwlocks — turning them into sleeping locks — I suspect it makes most
> >> > sense, and is consistent, to also turn rcu_read_lock_atomic() and
> >> > synchronize_rcu_atomic() into plain rcu_read_lock() and
> >> > try_synchronize_srcu()+synchronize_scru_expedited().
> >> 
> >> That makes a lot of sense to me.
> >
> >Another option is to instead fall back to non-atomic SRCU.
> 
> That's exactly what I thought I was suggesting; I think I left an 's' out though :)

Heh!!!

About 20 years ago, I was shocked to learn of a valid use case involving
sleeping RCU readers, which resulted in SRCU.  And now it is time
to be shocked at non-sleeping sleeping RCU readers, and especially a
non-sleeping grace-period wait.  ;-)

Anyway, easy enough:

#ifdef CONFIG_PREEMPT_RT
DEFINE_SRCU(whatever);
#define my_srcu_read_lock() srcu_read_lock(&whatever);
#define my_srcu_read_unlock(idx) srcu_read_unlock(&whatever, (idx));
#define my_synchronize_srcu() synchronize_srcu(&whatever);
#else
DEFINE_SRCU_ATOMIC(whatever);
#define my_srcu_read_lock() srcu_read_lock_atomic(&whatever);
#define my_srcu_read_unlock(idx) srcu_read_unlock_atomic(&whatever, (idx));
#define my_synchronize_srcu() synchronize_srcu_atomic(&whatever);
#endif

Or is there a better way?

							Thanx, Paul

