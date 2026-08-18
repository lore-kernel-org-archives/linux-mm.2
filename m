Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4C61C5DF81
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 18:18:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0D4D6B0191; Tue, 18 Aug 2026 14:18:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE44B6B0195; Tue, 18 Aug 2026 14:18:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFCCB6B0197; Tue, 18 Aug 2026 14:18:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 877BA6B0191
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:18:35 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0DDCF1A0217
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 18:18:35 +0000 (UTC)
X-FDA: 85115200590.28.695FB1D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4E3AC160006
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 18:18:33 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cp8x8hOS;
	spf=pass (imf08.hostedemail.com: domain of "SRS0=kD5B=GL=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=kD5B=GL=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787077113;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lHkgO62VARB1BZerT3cLWYX4fEgJZv19mZbLBDUYoks=;
	b=oObz87vHE5upC5qRIAaKwMXM8IxKrDGecjSLPa/2auHoblEqXcD8i3xebD8ybNGlkKSZUH
	UXjg/lJyYbzplDkGiOPTRBaDLU0vn9lIB1wXC+BVbhfQySCGmPeym+3wlNQU1dUOk5F055
	NjrHcmI4QGO+LMWPSO1CaoQ7Q6nv318=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cp8x8hOS;
	spf=pass (imf08.hostedemail.com: domain of "SRS0=kD5B=GL=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=kD5B=GL=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787077113;
	b=MBDvM9Szr+NgHcPvRaZvU2xx7Xn3mBqYXNllr0Hr5q45OF8YUfCMGeHDkc7FymFfHQELbc
	S5/+cHy6d1J5sWf1ynKNoawjI/n8i4qPdx90qiBGO/MV3lAkYKiBKyQQ/nyke43xdeKydx
	36ZMRKyyVhpLKs/G/TZkLaT71ICwK4c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 927A94098F;
	Tue, 18 Aug 2026 18:18:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70EC41F00A3A;
	Tue, 18 Aug 2026 18:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787077112;
	bh=lHkgO62VARB1BZerT3cLWYX4fEgJZv19mZbLBDUYoks=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To;
	b=cp8x8hOSSpz/sJye8Q4MMvhA8ZK7QujQ0rrdjr0GbGqZP9y2r+o8cf/WZN6UI7FwI
	 LnDTGaD0a0TK2lPowDdVJbV4CkSUAEY3Wwrmc9Ok4YvbGbEeypjgWAze154w3sXcY6
	 lIauGUEX+Qx3BLhY7FBah0nSL1A1t6H+pQgFdf3NmOJ/sNuhAKq5feEH9+4l/KyfVR
	 z9N31fia2WakSzVInaiahdWihqYxi4ot6SDiryHzxLLliZ4OsEY9J4zHIGwcX4AES3
	 ml7ldAgZmb8HtZhHkgei9GL4dyogvh/VfeLfJjNcF/p/+PrrObVXvKSrkLK0V32yV0
	 WOgzv1ynTcyGA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 2AD17CE1A23; Tue, 18 Aug 2026 11:18:32 -0700 (PDT)
Date: Tue, 18 Aug 2026 11:18:32 -0700
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
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-mm@kvack.org,
	kvm@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mmu_notifier: Remove non_block_start/end() from
 notifier invocation
Message-ID: <49df45c6-4d0e-483a-8acc-0ace7f9a6484@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <c41c52f02f033ea980d4b5f9b8239d5e9411a03c.camel@infradead.org>
 <20260812134934.GC662699@ziepe.ca>
 <a48e6e7063122b22a8083bb0792984a204f316e6.camel@infradead.org>
 <fb87f673bf290cad133d113dbb0750a7752b9d30.camel@infradead.org>
 <a94b75e8b9b1d2191f365c0f4275fd5082332df5.camel@infradead.org>
 <d0692500893f303906fba1d7d596eb59a07a806a.camel@infradead.org>
 <anydY25Cl78l1HfU@google.com>
 <932DB129-1794-4855-A61E-F4C2B54B1EE6@infradead.org>
 <b736237c-64ee-4eb2-8201-5685a3853844@paulmck-laptop>
 <5f6a0669f319951462c2aae3a50d595983a42e4c.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f6a0669f319951462c2aae3a50d595983a42e4c.camel@infradead.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4E3AC160006
X-Stat-Signature: z8wtity133u6fqkdt959ewhr9fxuz7zo
X-Rspam-User: 
X-HE-Tag: 1787077113-278611
X-HE-Meta: U2FsdGVkX1/YfCtBvNHLTGMeUGi0ecc5pGnfCfEQZ6ioilzI1iH56Al4txpJtq+rRPogEGIgUf00ARLPijmYcDmlGxzJ7YmwIQrk4oc6yvRHMN//1BzzI4ueXDgFNdmaabGdgVlysMUkAQ5EfZD1wxtie7gnGMgLxz2PZzddsh8h36RfxXHoZ5QfGnwn8eL9OBRnBx2xOuVWiWuBUR5+506if12T1SIfDbVhM+pgBjO3UThHps1ORhJutyWEw8g/8qimUeuFEFkJ0RudqhB0F6n64uOQ3vx+a5B8+YrmyGuzL6fIb3Wt6N1/i0DvXP60gd7UDhISbd3amoiKQ4Tfn5RqyYfDv4BmKk+Qqdy1tKyjNYVMgm9UOynPNcHp28/8nFBRYTirX23tm3W0sExF84jz2TIVuRyfvr5dzExIG6CjtiVwPQFUb1zg98K7VugCHgnSeY9KUeX72zz0TeIV568rvUyuYNURzSt5czhFlZPSn6c3obUC0lhSVr1jQhrtv8mC7jZbeVgNPSCgggLlpQF4sn8tDbDhBDjs/a9tKSmE5U/mn3ey5d/4H/bX7P/QZlcMe20YEYBh7vTsCBC9kbSeP4X8vvt1Yngyxfe2ZKxeCpzwoVP+goG6HaxIqfL5x0+ZO+G4bDqZdqG48WYWXNf4M0sXKugnhL6WMzTjvENKeOACLvlCidz0wKg1sxsWLvpgsyjxt/BvKuQznl8xmvpZ67ExdEvPZ7M0nJYw5JWbbdZSOOZ0xNt+r6eg3E4zlPgov+xYXg2aVW2hG0wdG+GjKgF4r4jbgjj3Si/bogEsInjJ3+++eXkEsKpYPLHDQDzdibexqxs7P7DgOgR/yA9arLjqqR8+0IGmUPt8/+tMoSgvSkPtpQ/nX5hxzdoPBwMD3+zlXl8VNOqnfR5fEWajjd66K0faHO8aFEgIzTnPD20QM4gf6aH/7iXamHawv7pSoDEeD9MRJnUDCgR
 g4dsGWhl
 hcD4rvEo7eKSOhus+jJ4sC4Zmd6/gnVAfDVZZnbMT/ug3jhHuGgEdoOWj2CnoSjOMFry0wpG735UFTXcpjSbvNeVCqmj1cjqr1KZpBDZGSUqa0wL4P0nXEaTo03zyPprCnANih6/DP6vfE53n/E2cqZCujxiE/Au5xQTp9eAGz1ujr52gw8ydXOrEJg5S5k3VESwnE+PiosKqpmDGYc4q/u0BKZd0azFTbl+N3uBOvBfoBl/rA3FKMA285/z/6/mrzPBlTpR6StIsfJP2M4RHXnsAqsJ+fMlFLZvd2UvUlhpaZEzEHEAD00toA6cTnDG7Pmpi+CtQpTsd6u5B4BxiMK9c3C4EYnshf+GV7jcmAuHKauUcXygkXp9VJfuhL1bO6MNYF8QqPXLClzRMGz9XKum1xao+0l1OEOORODMzRQD6Xzx30b7t6JCYKN9jXHfT6kWk7NBg7Z9Rovgl4SNfsvNIjeJCtTBArnEaMJ+EgbCtq6dLi5HntG7eGnAL2MlnQxEwom303q7OG3T2Qf/f7xm9WzJe4EveGtVdS0j9BooOfh+kALrVfQ0PnMtKQKMxIWqcHyyI818mQshx2aIGYcWACl/qODO5TsLwxUU04K7u0U9AcsuyBybGJC6agZIE6UqEZ1rcNKvMpeH3x0/1+2JdiuK3GlLcfCpH1xAmUb9hhNg1M4hhWcd1VEYbORzTBl0FYxyQvabiSL6fHdrs/sPMpGNqVQpLdKy1ZwLEyV2cj5EH/hBWWEB3+ffDSDSpn0DbCFriaulOlVZqLQ5sAg7Omb9sEiRGQufY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 08:54:44AM +0100, David Woodhouse wrote:
> On Wed, 2026-08-12 at 14:38 -0700, Paul E. McKenney wrote:
> > If not, please let me know, and I will put together that does the
> > job.
> 
> If you're working on that, I assume it'd need the readers to be known-
> atomic. So if any of the read-side SRCU_READ_FLAVOR_ATOMIC thing I
> already threw together is useful, you can find it in my tree at
> https://git.infradead.org/?p=users/dwmw2/linux.git;a=shortlog;h=refs/heads/srcu-atomic

Thank you, happy to steal pieces of that with attribution.  ;-)

My current plan says that if you have an atomic SRCU on which you
use srcu_read_lock_atomic() and srcu_read_unlock_atomic(), you only
ever get to use synchronize_srcu_atomic(), never synchronize_srcu(),
synchronize_srcu_expedited(), or call_srcu().  Does that work for you?

> Slightly orthogonally, what do you think of making
> synchronize_srcu{_expedited,}() attempt try_synchronize_srcu() first
> for an early return?

No objections, but one thing at a time.

							Thanx, Paul

