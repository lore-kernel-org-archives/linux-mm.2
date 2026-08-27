Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 457DFC61DC2
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 08:20:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 434BB6B008A; Thu, 27 Aug 2026 04:20:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E4C76B008C; Thu, 27 Aug 2026 04:20:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D32C6B0092; Thu, 27 Aug 2026 04:20:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 07EB16B008A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 04:20:30 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 81D72C0372
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:20:29 +0000 (UTC)
X-FDA: 85146352578.18.81FE45C
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf13.hostedemail.com (Postfix) with ESMTP id BCD1F20003
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:20:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=xEMckJcc;
	dkim=pass header.d=linutronix.de header.s=2020e header.b="/xHz2Dwu";
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf13.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787818827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dHKgEcpAnFM7pEhWpO1E8wnd+7B5JBIywxZU+obwOD0=;
	b=yV5AkOzv/tV37Ge752vkwL5XL/CdNJCaPCXiODp0jpIGiVdmIxZuTJPQ3Hx85cVaOuHMaR
	Ln/a4zjMJ5K5ignr1llHiNj3JTC3OK52OWGAOCLK0iyRHfxsA4SKYwNe872KI/q7eSf1Sp
	82ykle5Sar6x6fQ6lefn7o5FdFUoyHY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=xEMckJcc;
	dkim=pass header.d=linutronix.de header.s=2020e header.b="/xHz2Dwu";
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf13.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787818827;
	b=oo85kR0WYIOPoOqdbMeEPzJ+ihTc7TnVT7nYqwjwdeBZR7y5ongc7nrBtCLDfGvFW01yCj
	aKsJN85HD4CX3ISzH+cTN3tjy0ibxkjZghGX2TGKAOsIz2vM7tXI2N/ZogqANpp58SXroJ
	xJMIwurGUofQIh2+F/0kq6WXF1as0sI=
Date: Thu, 27 Aug 2026 10:20:19 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1787818821;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dHKgEcpAnFM7pEhWpO1E8wnd+7B5JBIywxZU+obwOD0=;
	b=xEMckJcctN+XyCF3tP1A7kB3Z9NMqkOr1WP3u9eNx0R1d6VPmDAbkfzv6Dz5L6rc4iPDAL
	DeTMebaCG9CYd60ZBy6/6oyFrOocGDegnbcEVpSCtOOxRTmp89Tc7fP2j9Jfwx1X3iSEr3
	vfg3fbcnrSr6VMLGvtRDr7LRYO7vMlHebLP9UMnFoEz3x5z3PqRFdQA/dGiGAceQ7kGREX
	B3FthaoTCt/827MpvioWnToPzvvNkcrRmQeEzocpdKAI+bB3Zz4jCENu/fNmn4DSRgK5+s
	gQKshKN67amzT1FdkuYnlf17RNxG4BlGjMnJafxaU6KZGBY2ee5SSXKE7rYqRQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1787818821;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dHKgEcpAnFM7pEhWpO1E8wnd+7B5JBIywxZU+obwOD0=;
	b=/xHz2DwueZDiGs6En/mm1IcQyzO3s2+iRZ1dFAnSt6ypCR7hibiWxWPyikRCsxBcAbJWib
	mLu+1zK/ObCQ8jDw==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: "Paul E. McKenney" <paulmck@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
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
Message-ID: <20260827082019.xrNuIfE2@linutronix.de>
References: <ao3z7Rtw2FROkVpy@google.com>
 <d4f8ff92-08ac-4253-b647-f9e95c66698d@paulmck-laptop>
 <20260826073233.T-KtFXmj@linutronix.de>
 <da5ee56b7d082abfbb20f71be99a6885247e9811.camel@infradead.org>
 <dbbd6634-4da9-4ecc-9fb2-d7430e2743ca@paulmck-laptop>
 <98e123c9-3dc4-45fb-815b-881b3346741c@paulmck-laptop>
 <ACC45EB6-F881-4EE9-A9F8-D53A2B921FEE@infradead.org>
 <e62a7362-7dd0-4615-8877-6ab675971ab2@paulmck-laptop>
 <06F9A0F0-2177-4173-A201-56325A73F89B@infradead.org>
 <4415dbf2-10b0-4cb1-b045-13dbcd69c5d5@paulmck-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4415dbf2-10b0-4cb1-b045-13dbcd69c5d5@paulmck-laptop>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 3wgegn4331e9iy98tzabsnpfbgokcizo
X-Rspamd-Queue-Id: BCD1F20003
X-HE-Tag: 1787818827-302375
X-HE-Meta: U2FsdGVkX1+Vp9qcb1RPDHM9NTEUPxvoaoA4rvPD1cPtcjWAEDyJYJ8OQjgUsfEao5Ngibj+HBFCndSGdRiPJ97bKaL77nTGHgk1gwinWoa40tohpj1DEZb8JkHinmLHLNYMVNR7B91bcG+v6pI7BIYmfkZ6IvYaXDIAHJUXltZcoWFx06GssoHTjtQDJzHX4y2c3BsbJWcAxtR9fdcZawHk0sQiv7rBn0DzxnkTEq16KaJJDghZfh8gWjWEDojDvIVL5olOSOG48yHmdibZJm9U/TK2bL6arRyDVhu4T04q/L+QNatP4ixLLNauDUkN0yjHngLZelb0821642MUQXqaq5NTpmAOOWOMgv6Ds/6w5iSO8GxrPsxUTJ6+XsR/Z4OIxhbiZNq09lLwk3exvgCNm9E3l6Flume2ydPfEXwdcjxgiXhyEibVOm8vvstxlou4tn+zjgiKDaFn0xHMS6HZicg074EDegZujUIlGHr0izcdH/pMWDmTkXQf/Z/YuQsCa9IF1Dzc8QwJx+X/8CoATchFJwrPRTI1sWrQyjtJFPqm4vb1VXlz2CEf7GhaP7DKcKYzY1zmwoTwWrQgtpArmq2GmPlHP7MK5ACGMxx1uRavpUPUL49sBJTEJDKgaW6IOOMMCaL8d6vowLSngeY8MOuyo6kFGivi5YNoypZwN92OdcJsm96r4T3/uIHml6cXFgmzOi9MSP4eHvK5i8xONHPmhCKs/FfFdH9mHipoJUKNR+vgRmbCUVcc/hgsFxi8JWbSzxK5cAYS2P72C/aHWUEbmqpUcfSF7VhViRkiXPxlXlI3+k06BEmOVCuf3dZ/o9A1q3uZTzDy5xIIDM9GVaKrJ5kEKIV9jKqtC8RIDiOxJP5I9V3ZvNfMLa06qCsbPr2VqdHnFxb5GmjYDf7fXa8X/pGRDvRjqA48Q6qmacNZfsyfH5Rhk0XpswN/qkpzQLh/r3350IX9Nr8
 7e6xM1/x
 CUa3CAe0K7s3xzPh2oUFZcjRdVdBJvKg1c+Z2BaZMXcAKp24r0FFpkSuQUtMzzk9YYZU1S+4VPZJHLgXr/Z7Oq2EUXQzVcLNUcOKitwkXGCwb+KkiJkYMVH7nmFFupRRBNY7dBDdr+r/BAIBF65NWe5eYh7EwmqyXfDP8RlRnMFcTtUhcBXNJsRGatg25lbOc/SItnSJs8lqBMQwhIjmA3BO37StOdlIytNdmoniwhINtUzLfgBRFbFA5OQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-08-26 14:04:32 [-0700], Paul E. McKenney wrote:
> > >Anyway, easy enough:
> > >
> > >#ifdef CONFIG_PREEMPT_RT
> > >DEFINE_SRCU(whatever);
> > >#define my_srcu_read_lock() srcu_read_lock(&whatever);
> > >#define my_srcu_read_unlock(idx) srcu_read_unlock(&whatever, (idx));
> > >#define my_synchronize_srcu() synchronize_srcu(&whatever);
> > >#else
> > >DEFINE_SRCU_ATOMIC(whatever);
> > >#define my_srcu_read_lock() srcu_read_lock_atomic(&whatever);
> > >#define my_srcu_read_unlock(idx) srcu_read_unlock_atomic(&whatever, (idx));
> > >#define my_synchronize_srcu() synchronize_srcu_atomic(&whatever);
> > >#endif
> > 
> > We could do that for the KVM GPC locking, but more consistent would be to change *all* users of the 'atomic' lock under PREEMPT_RT to silently get the sleeping version instead, like PREEMPT_RT does with spinlocks and rwlocks.
> > 
> > So it's srcu_read_lock_atomic() itself (et al) which would get that if/else treatment.
> 
> OK, the traditional approach is that raw_synchronize_srcu_atomic() and
> friends with the raw_ prefix are always atomic, and without the raw_
> prefix it is atomic for !PREEMPT_RT and non-atomic otherwise.  You would
> use the non-_raw primitives.
> 
> Easy enough to do.  But does it do the job, both from a PREEMPT_RT
> perspective and a notifier perspective?

It does not lead to any lock violations so that is a plus.

> And notifiers (though a different type of them) were the first use case
> for SRCU.  ;-)
> 
> 							Thanx, Paul

Sebastian

