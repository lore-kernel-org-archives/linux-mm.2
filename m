Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3A37CD4F35
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 01:27:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 954EC8E0003; Wed, 12 Nov 2025 20:27:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 905EA8E0002; Wed, 12 Nov 2025 20:27:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81BAD8E0003; Wed, 12 Nov 2025 20:27:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6FE078E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 20:27:26 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 207CDC0743
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:27:26 +0000 (UTC)
X-FDA: 84103846092.03.D80CF08
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 574D080008
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:27:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j9EZH2it;
	spf=pass (imf30.hostedemail.com: domain of "SRS0=9OOz=5V=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=9OOz=5V=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762997244;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OjDSWhETJLY023FMAUhr1MZo/3CZ2QjEBxmSshluYZs=;
	b=jYolSe5yXdRYuMJ5r8bf3OItFhOJzlK3MKPq5tUNkVXBc9MX5imGmBfp1XbkbXrCfbhQUV
	wlX22XKfLmtgahbvhrfq/Xn+KsfkDi8D7tnrlYuX/LQ2WOlyQDMGizz1d0ErCA1thKwrn+
	AKcuJ3xMFyOK5wUgj+qqTa8LOyYnyIM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j9EZH2it;
	spf=pass (imf30.hostedemail.com: domain of "SRS0=9OOz=5V=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=9OOz=5V=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762997244; a=rsa-sha256;
	cv=none;
	b=KognxldzSi94cMToGE9SivgUfQHZ65Mu5Vi1RsMjPMClYo9NegYbB+UeEUi38lmXdajYv3
	STCglWGAEEpS/ito7IyvQWsLf4fo+9GHsnehvz2tqHAPMV83Ri3kGxBZbFJKDlFeBRfvFN
	wgpdApUOeHHS+7DTtt4KrX/XiL0FQOA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 13D8141ACE;
	Thu, 13 Nov 2025 01:27:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E905BC4AF0B;
	Thu, 13 Nov 2025 01:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762997243;
	bh=TF5Nr0Z6ILPUdtsJnj/5x/ih/OKOmW3hFeReBsHZthk=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=j9EZH2itZecujLn0J/BBW/POwZhnFbrrB7plrJIULMFOn289/jDaE6KBDiy8QUOII
	 ncfIj4xIPZJNS2b2G52A6EF7rfMYg2wUB1sCWY9CGd199fQcSpBu60OdPVwm9WL5/z
	 fpsZS5sTaPyuGt6y8ul+eVQrvOWPFUsAjDeLuTeGXHI7MewSLhMxIET9AjEYh1Tl2Z
	 cv7RTUNLtfaT+EEtsWEdyyxnfQaudACiQMZEzx1dvAgB2aRGPlwujPcWZW3x+dS2va
	 kD2YZ3HmtwaynqlRFn0Sf2RsDvKxiXqu0T0z1OKJfiK6icIGMsOaqyciq1hvzYPYLZ
	 UmfN5Cwn5vszg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 631BFCE0876; Wed, 12 Nov 2025 17:27:22 -0800 (PST)
Date: Wed, 12 Nov 2025 17:27:22 -0800
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
	stable@vger.kernel.org,
	syzbot+131f9eb2b5807573275c@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/mmap_lock: Reset maple state on lock_vma_under_rcu()
 retry
Message-ID: <d9e181fe-e3d8-427a-8323-ea979f5a02ad@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20251111215605.1721380-1-Liam.Howlett@oracle.com>
 <2d93af49-fd76-4b05-aee7-0b4a32b1048e@lucifer.local>
 <aRUggwAQJsnQV_07@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRUggwAQJsnQV_07@casper.infradead.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 574D080008
X-Stat-Signature: 34khg73psycjwnw9bh6p3m5xg5iirh97
X-Rspam-User: 
X-HE-Tag: 1762997244-192578
X-HE-Meta: U2FsdGVkX1/JVndkDXUlKk3TYdxakkGLlbvakylDHPjdI6tBl2qpr669tnEDDxyfhLiUJ43e/SGQ8S694002OO/0edk5gtsv3Rzs+sJJetTmKsV7grgoZ+gkHPEIDbdG2gQXtBuL0dtGrzazHD1WFOmdZ2cnsysQyrGmDPZs4mllCwXu5uZMfOeHCxPQGVZ249iMIVjz5aFhbMa0QSBGVkctcJJgcLsgesRlZ1JWewcS8TIwfSIFk6oQKNpGlIy7x8BO+6KY1U9W/rJuFZEgbToxzxC4+VVyvFZ9ALmhQcOE8VBunjJJauQs5ud7WqDkwCeConia1JsZ8NpqqNC6Ay4fgSQBWFMMJfSokHAJGoq9lZmEnh/v2MtxSvdmeuVmihvZJtYc0DHqE6Z55Z1RyiRPsxZrXCepK2425sve/QUWyE5kGcf7sczGpuRDtw3lb8fUCo91deJFwrDLU/GXvx9lBItoB3xRwi/uFAkB9Ib60phn4IsQUMsBqz+zYNoBQ8XxMVTzE9s9K6eIalfJlNSekUO7E1KOplGV5N1QsO1Ajkke2bJtbuGAgjkuzFz1pRnX++OcDnMXF0gFJ53nDQ4l4vZl7dZYtT47Ithns+5AFMLG57SaMrBJimp4DSz2ZIMLqrTiHnJDsTPyRcFFwkXyzXVnseZCOtEHRuPlQPDhONxbDhOD7Sx02p7uKxZt17wC5PeYr5nGhYJNqxyOVIGoOl+5CqAOf4Pznw0rm8SuWET35ZcTuLHqGI1Q8ayXdwmMICdo5vVxoo3L8Pn5ecFn0A6hHWErAjR7mJ6RPa+6MNXOdM6CKuu0GpjEYhMxn/zqQx3WtFnbS2TrShyVm6bPofDxeSw5yzpjUgyqS6RNcVxAFZQ5JOgqy77/RqKu6pE1MQqdHSyUIiUue/4B5/NClC9pw88/DCg1TQ+cQqt1rTS/Unu0q4Om2DHud/hPEbEZiC055at9g4z+9pc
 T3oWBI8e
 nNityIA+RA061ygzFzJ7670EeaKb5JCzVFrW+hroBJkFwlUMFlMGBzL1dF3gZZXM4SCWS7MsHeASD6N2QGeppU1NrPlLEGXdjhxUK6VaavrwOnW9MK5r/aD/7/9ReCx2ICK3WCdhqQebw12Rk3qz+33GOkvL2vLKaUOEWBa34fLDfKUrWK8pFWTfwRnGQqq0K2pIWj+zFa0t0er+pArG7Jj4fXkfLra+mD6H1dVWdVB3l1T+wNiSeJlrPRbP6iNP9ktvCSjrVCaL6+cWbncYQU3CfO2U53BQv/9GTEupKuypO40EGbbC4Asn3m3AYMarIK1kFuLIw1FT3PgUErbkCp7cUGiRsp/FChN56Dp0T/evlk9Lu2jpO93DGzjOXkwoYXMssrmMJwRRqJ8S9Oa68HYnIY2Z8Smm4HnU00B9uAWmVvC0D3qHxGDJJprAVrQak3bjPPWiwrIyYAsQYzLjKLfIJaVVoi1abzW/+9OyayvkcH4JTNWJRFvimmbDmrROL45V1rdZvbmxBohtXR4eByxc2HNNcjSWyFwAE/6Vikx5KHRIJtZaEhLYgFyj+8uLwpxFBtfI2K4FDRqtg9sZjHRCYnZoGDtf/AneBqLdStZrBgnt1xqV8uC/9T8AGuv/MZ76t0mqTqpdqCCvHR2R+qhWUVBrbSa4JsUE1O+0zd5KkaBpqLTh8g/7NTjlsHXouqZaBpaNqjWW4HnEdZStMIdBubulIfwhkQxRjaJTQYADChzA0FDPRGh9wGUZyebVzP6Zsf6KyL4rLIVQLyscDMyhFTtM35AjS7zCg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 12:04:19AM +0000, Matthew Wilcox wrote:
> On Wed, Nov 12, 2025 at 03:06:38PM +0000, Lorenzo Stoakes wrote:
> > > Any time the rcu read lock is dropped, the maple state must be
> > > invalidated.  Resetting the address and state to MA_START is the safest
> > > course of action, which will result in the next operation starting from
> > > the top of the tree.
> > 
> > Since we all missed it I do wonder if we need some super clear comment
> > saying 'hey if you drop + re-acquire RCU lock you MUST revalidate mas state
> > by doing 'blah'.
> 
> I mean, this really isn't an RCU thing.  This is also bad:
> 
> 	spin_lock(a);
> 	p = *q;
> 	spin_unlock(a);
> 	spin_lock(a);
> 	b = *p;
> 
> p could have been freed while you didn't hold lock a.  Detecting this
> kind of thing needs compiler assistence (ie Rust) to let you know that
> you don't have the right to do that any more.

While in no way denigrating Rust's compile-time detection of this sort
of thing, use of KASAN combined with CONFIG_RCU_STRICT_GRACE_PERIOD=y
(which restricts you to four CPUs) can sometimes help.

> > I think one source of confusion for me with maple tree operations is - what
> > to do if we are in a position where some kind of reset is needed?
> > 
> > So even if I'd realised 'aha we need to reset this' it wouldn't be obvious
> > to me that we ought to set to the address.
> 
> I think that's a separate problem.
> 
> > > +++ b/mm/mmap_lock.c
> > > @@ -257,6 +257,7 @@ struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *mm,
> > >  		if (PTR_ERR(vma) == -EAGAIN) {
> > >  			count_vm_vma_lock_event(VMA_LOCK_MISS);
> > >  			/* The area was replaced with another one */
> > > +			mas_set(&mas, address);
> > 
> > I wonder if we could detect that the RCU lock was released (+ reacquired) in
> > mas_walk() in a debug mode, like CONFIG_VM_DEBUG_MAPLE_TREE?
> 
> Dropping and reacquiring the RCU read lock should have been a big red
> flag.  I didn't have time to review the patches, but if I had, I would
> have suggested passing the mas down to the routine that drops the rcu
> read lock so it can be invalidated before dropping the readlock.

There has been some academic efforts to check for RCU-protected pointers
leaking from one RCU read-side critical section to another, but nothing
useful has come from this.  :-/

But rcu_pointer_handoff() and unrcu_pointer() are intended not only for
documentation, but also to suppress the inevitable false positives should
anyone figure out how to detect leaking of RCU-protected pointers.

							Thanx, Paul

