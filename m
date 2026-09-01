Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E871C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 23:05:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FBEF6B0088; Tue,  1 Sep 2026 19:05:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5ACC16B008A; Tue,  1 Sep 2026 19:05:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C29D6B008C; Tue,  1 Sep 2026 19:05:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1D37A6B0088
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 19:05:37 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0CA3BA4402
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 23:05:35 +0000 (UTC)
X-FDA: 85166727030.23.7720535
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2800114000B
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 23:05:33 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IA59QNDE;
	spf=pass (imf23.hostedemail.com: domain of "SRS0=1F1W=GZ=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=1F1W=GZ=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788303933;
	b=8lahStfk1ayS07rTp8ppM/M6Ca8AYkKlXKJft1yUkFg13hfviCU9iU3w2reASKYJuPQX5A
	MDE9myBoed3XkmyVxnQ9NEme3f2baOua9mrbijz7vaks6DDYQwNA2WEE4TMR+kuQ5FbKlM
	UPAHCkLuqJQPwC4MlcFN01FPjS6rtL0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IA59QNDE;
	spf=pass (imf23.hostedemail.com: domain of "SRS0=1F1W=GZ=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=1F1W=GZ=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788303933;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0htWeaKeIqw48Ih+M0qU/N2hCQgDCF5iuzUPSnGY/sQ=;
	b=N7/4KE9eHR/y8qMLXfQVcdMPwBvhS3u7bo18V0pueqCrDt1vRMfGeVSpUJeN1TKtAtAo+d
	SX8k4WQIjA6X1x5BYiGvqHNOFTdClcDjVHngJp3jLin0l+7Lf8G7vwfwpkEnW39OVeN8fw
	XbpzPfRPOVsW5Okt1h9Za7TwIqWRO54=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 847B543584;
	Tue,  1 Sep 2026 23:05:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 612EB1F000E9;
	Tue,  1 Sep 2026 23:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788303931;
	bh=0htWeaKeIqw48Ih+M0qU/N2hCQgDCF5iuzUPSnGY/sQ=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To;
	b=IA59QNDEFlOCImNWFQJPZbXiWFaq1xTWw9bnb5X7bxpsdSW/X/3c8p5mts3Azgq2Z
	 7lSsnOCFsOI961FM9HrSshMg4uDVR8LTudC00ThQ0Qxw+JDDWkdPun8xOEzEwOIzSA
	 GDjCtziFxJxsMY2H/R0LkW5yYqsO39ugtiXXsvTErPrCgGmG99stE720A6j7F5G6mp
	 6NozGNcA8AvzBb4uQAFzbSTZdymAO3Zq2xOrRgyVs6HoOJ/lXO7siUu8wZBGIK5Km+
	 9FYxC24GXaOySPLTlqpxuM+3GR+iSooMmgT10XvJb//kdQOuZ7qlCFYrh83pQ/c4N+
	 IHIPejGZ6H/+w==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 24F23CE09F8; Tue,  1 Sep 2026 16:05:31 -0700 (PDT)
Date: Tue, 1 Sep 2026 16:05:31 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Sean Christopherson <seanjc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Michal Hocko <mhocko@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Jerome Glisse <jglisse@redhat.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-mm@kvack.org,
	kvm@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mmu_notifier: Remove non_block_start/end() from
 notifier invocation
Message-ID: <20bc5559-a1b9-4ff3-badd-1166eca60b57@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <9427a8e0-3ba6-4f31-a35d-54429bd7e071@paulmck-laptop>
 <3d0463b6099d4fcde9a025a2f9e231d75303b61c.camel@infradead.org>
 <b0be19e9-b0ae-48de-bef6-d905ee007c8a@paulmck-laptop>
 <c39bda52f4c1573193aed39246f0d705755143fe.camel@infradead.org>
 <90d91673-a912-439f-98ee-e43285294486@paulmck-laptop>
 <8cd4aa65b1b499d4c614aa4cba445b6aeb89acf7.camel@infradead.org>
 <apcjs83XSU4Eb9hm@google.com>
 <e3197a0a-e167-4ea1-bbde-9c7f11f42198@paulmck-laptop>
 <apdW2edsT_ZKfuUR@google.com>
 <19e2a25c50a551398dec060fe0e5d3720b027ad2.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <19e2a25c50a551398dec060fe0e5d3720b027ad2.camel@infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2800114000B
X-Stat-Signature: dxzskjmpj6w8ostbgy618i53n5a4s6qk
X-HE-Tag: 1788303933-953915
X-HE-Meta: U2FsdGVkX18vZr5dnux7yT87ESubWBfbQomcAdhBAyZWeDNNKjLfqrbN5IAYToxgh/5lEJBzb1+i+bxA7RmCmCrysetBwhX+ejuidX1P+gyza30pD/8UUp8Q8cFpxp2u0Fj0031k4AlM1kB7TqfIxVSLPiQLk+6SOHL6G5ygXuqh5G1V3/6QazwvArn9CY4CsmDGRbNCEiJUDUSsus/8h3KrmN7zdZg3Bu8IOKaYdyI2P9sD9TLP9fvCHDoQOq1WS8FXlXWGwA8SRcQNfEV8zn/I62TDM8YwAW3tPQEm7JIHWq/iDwk2F0CjQ+324rPF/Edo2R+PGct8cxfqcGGP82BC026M1UizUDzWzsD19Acd9csDq5gpcQ9DViCJCqs4mH5X8joBZDXZWlvCUicMMKU69ckm7fE2+uVhi0yDhBw8nA3V5M7+YshtqS3rwPhVJI6XRlQAAiPCFtwk2gBSoACu0nrE5P0vqCUJ1HWGt/4F2Vi3sFTs5u9rhr9cUWO8v5VKHedcH1qJ9axIIKLVx2m0Rs0f03esbzvycw9/mgLEgDWNFJmv9UlQRnzcGl7ICKTlv7upz1m162RfFPyXIf/0yZb9E1/gFmv7oAkLdjOgOmjM/5Mrs8GA0HXo2wGsdvLfAlVyLzV7G4kh/IMDppPyxFnXCxOPmbPYp73r7HmGZ0lMRt7lTjqYxhIDxzO61Y92baO6yc2XQ+JAzKHW80GHR3gnKpFwH7uY0fQfKLmAi+I9Da04jxesGK+ME/AAr2h7AGa27yHyLEN5FB8z+ogF6nyTiGIgInUhdkJH5UvgdZ0+6zIaF8SmbeaPPu0ryMXwzQsEl8cPAAgeJlSERS6idYLg5JGpk8F9rPpEbFPBx8ufXnuxP2rJdEQaERBjPdlEhyunmwWbhGdWvHt0GYIdkXoEFxX6rHa5xcup5e6GnolDe9aIElxgto1mQmh+DrCuAQV78ryjzeFq2qf
 rZ4Uous5
 1fqHK9AIq7eEC36tOdNCeJhEiqizHsy01Zbe4TzyDkaIta6ip1ep8OE6JllPLnuMrp1R5VULdjdWW4Aw8sEz6T4GvCXEpMkO+5+rk8rvjGwtvFyTYdg+PiXYfRwP0L6TsSN/jTH1PddLNCOjq9oON5xUeVGFA7Iev5P1feo06m1Z9R1ahMW+Uy5HjDT2dRCjqUnCopKfBuyX8GkzUzhpMWmnfCLqvVUSBE8qIdNNzlzK7y956XR5+GtSb+WBrgdqZMHWReHqTkEZtJrz8BwBpO+Immp2cLqHBeg8Djxe2ZQKVUgpChJ0Q38Pu5Ds+YAyUo2agC0Pub5JhDSPNYNKT98EaQCE7cjKXAsjaHFILwb5+kPUhd6L0Wt1AwLHRxuw5of8aW6ca9PD0BBhNg5SI61TtIWwPJ0UUEMal3abdU1e0pqB+RWiFF9K68Gp7nK2JzCl7t4bxW75Fkuo/xX+m2zO7qSUB8hJGjOXKP4S1id/1BTr6aAVRInJhHk9c9gk6Xlu1XSs+Wkoh40FHf5R1snMwD8ANizIE1QBanwUpS4dpQrcYd0lEPSfoljNlH7uKNIZvNS40tJQEepfqADcomPEry4PtUIaaHyVn3iizN5h6OrUD+58JjtyaNEw6O+hM6/yK9u5R3rKx2NMlRpNF8mxG7rqPMikK6pVhYEOHskaPELE2dlyOUtS3EVONieK8GBFB3wKBvTsVojcDILxPtvn7g72hYX3LUyhaY5RIHerC3Thxkzz1z+NQv9P8irflFVir7lY9vw0CAzg4apGbGUgxUjLWUgbgGMC5ca3WsDTjvh9AJAOi4nbeZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026 at 11:53:26PM +0100, David Woodhouse wrote:
> On Tue, 2026-09-01 at 15:51 -0700, Sean Christopherson wrote:
> > On Tue, Sep 01, 2026, Paul E. McKenney wrote:
> > > On Tue, Sep 01, 2026 at 12:12:51PM -0700, Sean Christopherson wrote:
> > > > On Tue, Sep 01, 2026, David Woodhouse wrote:
> > > > > On Mon, 2026-08-31 at 17:58 -0700, Paul E. McKenney wrote:
> > > > > > On Fri, Aug 28, 2026 at 12:25:01AM +0100, David Woodhouse wrote:
> > > > > > 
> > > > > > 
> > > > > > >   * 23f10e07aba3 srcu: Add try_synchronize_srcu() for callers which can prove readers absent
> > > > > > 
> > > > > > I do not intend to provide a separate API for this given the possibility
> > > > > > of indefinite postponement.
> > > > > 
> > > > > Makes sense. In that case, calling it internally from the 'right'
> > > > > places becomes important, as the callers who care can't do so for
> > > > > themselves.
> > > > > 
> > > > > We discussed the fact that synchronize_srcu_expedited() will also want
> > > > > to use the same fast path.
> > > > > 
> > > > > I'm also looking back to Sean's call_srcu_expedited() patch from March:
> > > > > https://lore.kernel.org/all/20260309193059.2244645-1-seanjc@google.com/
> > > > > 
> > > > > 
> > > > > > Due to differences in how VMMs manage guest devices, and in the
> > > > > > architecture being emulated by userspace, some updates trigger call_srcu()
> > > > > > with concurrent readers (i.e. while the VM is active), while others occur
> > > > > > without readers, e.g. when configuring devices during a pre-boot setup.
> > > > > > For the later case (no concurrent readers), using the vanilla call_srcu()
> > > > > > is problematic, as it can kick off a normal grace period (totally fine for
> > > > > > freeing the object) and effectively transfer the non-expedited grace period
> > > > > > to the upcoming synchronize_srcu_expedited().
> > > > > 
> > > > > So the offending path uses call_srcu() and triggers a normal GP, while
> > > > > the victim calls synchronize_srcu_expedited() and gets stuck behind
> > > > > that non-expedited GP.
> > > > > 
> > > > > Sean, if the victim is the "no concurrent readers" code path, as you
> > > > > said above, do you think the fast path in the victim should suffice,
> > > > > without the cost of an expedited GP for every bus registration?
> > > > 
> > > > IIUC, you're asking if being able to use try_synchronize_srcu() for the fast/happy
> > > > of synchronize_srcu_expedited() (i.e. for kvm_swap_active_memslots()()), even if
> > > > there's an in-flight GP, would suffice for a fix of the regression introduced by
> > > > commit 7d9a0273c459 ("KVM: Avoid synchronize_srcu() in kvm_io_bus_register_dev()").
> > > > 
> > > > If my understanding is correct, then yes, that should work, and presumably would
> > > > be a notable improvement overall.
> > > 
> > > Then we could abandon synchronize_rcu_atomic()?  That would not be a
> > > bad thing from my perspective.
> > > 
> > > Just to be sure, please note that synchronize_rcu_expedited() can and
> > > sometimes does sleep in order to avoid odd corner cases that could
> > > otherwise pointlessly monopolize a CPU.
> > 
> > I think one (or both) of us is confused.  I thought David was asking if we could
> > avoiding adding call_srcu_expedited(), because the proposed try_synchronize_srcu()
> > would fix a regression related to KVM's use of synchronize_srcu_expedited().
> 
> Indeed. This is a *separate* problem, for which you had previously
> proposed adding call_srcu_expedited(), but it looks like having
> try_synchronize_scru() as a fast path of synchronize_srcu_expedited()
> would suffice.
> 
> We do still need synchronize_srcu_atomic() for the MM notifier case for
> which we originally built it.
> 
> > I don't think that has anything to do with non-sleepable RCU?  Or is there a
> > separate discussion and/or implicitations I don't understand?
> 
> I think the lack of 's' there was just a typo. This is synchronize_srcu_atomic().

Right you are, and apologies for the confusion!

							Thanx, Paul

