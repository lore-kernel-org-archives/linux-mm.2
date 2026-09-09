Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E4D1C79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 20:13:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A1FF6B0096; Wed,  9 Sep 2026 16:13:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 951BB6B0098; Wed,  9 Sep 2026 16:13:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8912D6B0099; Wed,  9 Sep 2026 16:13:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 62C6A6B0096
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 16:13:51 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E6E6C1C1CCF
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 20:13:50 +0000 (UTC)
X-FDA: 85195324620.18.2B49849
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4C0AE10000C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 20:13:49 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=juCmX3GX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of "SRS0=B23o=HB=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=B23o=HB=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788984829;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MQv84SOaC1a4xRlHxd7KhcwiZ2JQHsHJb8U+J0I2g0I=;
	b=jKt+rWJSS6zgXPNv/wm6IOkV8IZRoMLIQykI5wldnSCydbwWjzz0RUZnxkFkldnItCeK55
	kAdgM76Bd2d8kECHWDR6T2GByiicU8RVSbJZlcQQiDBa208GuZJb7S5+BxygLz1tF3zYYM
	6/rXzvE6zPtO/qHfjUUNxoJ2JDN2mQc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788984829;
	b=U5+JlRotOTu8D4jc2VfryrWo4tacsZVDoiifE3KslVuKo/vSkZyxKXzBX5ubVlNSs8TYnX
	djxbWkZvdnktDefVAPq4Cj7q18wGhzgK3E5UmTd1vfc588zj215UZ1AkbIhaPZn6fXk3WZ
	76+SOv8pECa0BNG5kU5gC8iRjTHECzE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=juCmX3GX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of "SRS0=B23o=HB=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=B23o=HB=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org"
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 67BB140643;
	Wed,  9 Sep 2026 20:13:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47C171F000FF;
	Wed,  9 Sep 2026 20:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788984828;
	bh=MQv84SOaC1a4xRlHxd7KhcwiZ2JQHsHJb8U+J0I2g0I=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To;
	b=juCmX3GXvi8gIcx9x1MqG0xHSRRFzOMy8j7taPhO0tbXRINSpeYHoyx3DvxXaGnlX
	 wqfo1OeB5lKOS4RDH4yrNYtQ1wVY/vrDlELptYhLFIiiafuhqzwg6j2KqCAVzA5Wzi
	 oy9k45btmuQT+ifPsLG8iPkCIOHZ4jzntrmTDY2Sg9I3VWVQGOotJML075qjZrmTuf
	 +djMyNK12BEtbJTOuA8s2E36bZZGfdsKyYXZzza5W0Z1BZOqjILooMvwlLu5kUPU9e
	 U4mmiccNQi7ixtQFukkHPRKfh7E9+QHCgKUc06cDEpvCDAMjN8KdGxoUBWQNiT/Qn6
	 vHB572M1U95wQ==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 1DE61CE086B; Wed,  9 Sep 2026 13:13:48 -0700 (PDT)
Date: Wed, 9 Sep 2026 13:13:48 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Josef Bacik <josef@toxicpanda.com>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Dennis Zhou <dennis@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] writeback: report a Tasks-RCU quiescent state per cgwb
 drain pass
Message-ID: <004abd0b-7ded-4b2d-87ab-7f8fd6f6cc8e@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20260909-cgwb-tasks-rcu-qs-v1-1-967a7754771f@toxicpanda.com>
 <aqGilhgcEd0qaHjI@slm.duckdns.org>
 <20260909193820.9aac7888ba9d@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909193820.9aac7888ba9d@toxicpanda.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4C0AE10000C
X-Stat-Signature: 9toti3e1zuqidy14jno5wpii7srkczg9
X-HE-Tag: 1788984829-594836
X-HE-Meta: U2FsdGVkX1/lNSxvnaTCvtDmrCIRyfGIleNIkIfL7S621m0BNKIYFNrS+jf/BZaKMT5Tvtzt/Q2HeKYnwHhISizPBH5Z8IMIlprv5JUwaEnO17vSGaLViXZURrQzdbFXD7fhw4Tok8/cCxGjQFKwimQq31Y5wEIwJ4NkKftpTcoT7JyYQFeJj5QyJ+CpanGWlWizD728c1ugZE6AyuatvJhy0AXqo1WWxQB1nHkQ3FRqgkgJBZmzuIMJL9B+OCwp7jjJgd49bdc5yJtacWZCoNVBm3+ddqH31i6mF8Fa897H/dDrvq5rYx7ZH1x8ihLh6s2wKXTpDjaxYm6gx6bRP9XlkspRYUxdFDQXmFJRzenUkxLrYO2uaK7mtt6XHoBSSONq3CALB6u+Jss9UQulLT2pqwiEoVfhBxJM7s4d8hEC2S0sc/GJiPvh9MGpBT3Kdd1DYt0Srw7yXFaeuPXTRmoAd6krZuFjaQxrAhR6y1svYQ2AGAPejAeVqBuHEhg3mZw1JGKEnc8mZCwzYBICOxANNvpb1YDkvN89RA2oitQo+l72cLCXk+Hv3NwtZdrYEy67zvENS+DJd3blqnikitjP0aTQVXh5GKy0Kz8BOmRsBARWrUqqZoqjN3bzvn6oErb+wVgO39zIAkOvk0rzEvCJuicX3zpagC3PAZUloZIIrhu/TUV2zTqT+HFUgBVF1FgQDSVjkS9lkYZmBWZ/30A3IZyv46mYTXL/fLyRjJ5M6+ukBpxkwVFyURkKS6fKadTcBfW6ZEuCc/VoGd0pS+FlfxQM9iuG2dUQCdQtrgGaQjU/xB4EVLUF4pBLGRlo7u57wrDO/MwIb6SHhWHb6uKAf7AkgbNadbOB5FoJz+j+U9WvzG9SZ1bkSbPodlZ/AZZg0ZB9ewBguSgJwQj6ZffX2TADeIN2rFG5oFAJOxYvpoFGqJDO0tRoVikAloZldGmcaBU30WCk0MKMrnh
 2UV1pl2Y
 l6KT057XhXOuEpbrhThMfJvBvxMF4E/p8TbX3OeBcpETGzInocOSjqAaLSuT1Yf9CG446849lYguEFSa13qosCkZSY3xPEiCWqeFj92xVwvN9w4TZXkOL440hv3bi3D4o0xw1ONrAWl/lR8VFW76/xO+/4W2CJXJFcS7vN86yhsl1EuceyYHJVfV8ocjD8WCNjulWwETj3rBKPYgfANS+CKYlr5qodmb0tCmJ+xp45Uy2ij2PfXdARERYQuqP16PMp3MlTX4vsiYl6nuyzeWF+Sq5wW+p+4lEdZ1c2J7nZ5cpusA5W8PJMUMGgpzkLka5VdTT3PQ/GobrxeUJP0VzrM/rwiUZBvUjHjQvanDSCAWgPgbnrb+h4gkYl02Rp6z9ZKOKmTKw4E726Qc6qBsK1h8aPHxGPE8buscx3S/iqhxoad1th7J5Mizfm4Z5VagITJrRmB60quiWU4wPbu/gukWs6GSHwQ63MhYiAFp0SfEgr+d8ZhJkwB4XUM331MM9FEbbg0rar4NgEb9hc9mXk5Wn0Nv0KPgaotsJ0NOqq+0cgjwT9tucYH/ra/DMencgdFh+JGUPwwnHQudqKgCXjvvzNODJgjv5cf3MpB+NAK/qNk0rNnb5kk25oLNplv/EbytUEPM4H4uWPOSDOqj4yc0W3t3bhG3QqhWTdDa+SZkCXD7oCSXj0dDlVQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 07:38:20PM +0000, Josef Bacik wrote:
> On Wed, Sep 09, 2026 at 08:16:54AM -1000, Tejun Heo wrote:
> > On Wed, Sep 09, 2026 at 06:01:07PM +0000, Josef Bacik wrote:
> > > +		do {
> > > +			cond_resched_tasks_rcu_qs();
> > > +		} while (cleanup_offline_cgwb(wb));
> > 
> > The patch looks fine but this overall seems fragile. cond_resched() was
> > already marking "stuff that can take too long" but we need to use
> > cond_resched_tasks_rcu_qs() if it can take *really* long. There gotta be a
> > way to make this more maintainable. If always doing tasks_rcu_qs from
> > cond_resched() is too expensive, can it be be gated behind something cheaper
> > e.g. some tick based test?
> 
> Yeah I agree, it is fragile.  Every long running loop in the kernel that
> only does cond_resched() is a potential multi-minute synchronize_rcu_tasks()
> stall now that cond_resched() is a no-op on the preemption models most
> people actually run, and playing whack-a-mole with
> cond_resched_tasks_rcu_qs() at each site as we trip over them isn't a great
> long term answer.
> 
> I'm working on something more general so we don't have to sprinkle
> cond_resched_tasks_rcu_qs() everywhere, but I expect it to be controversial
> and it's going to take a while to shake out.  In the meantime these are real
> bugs that are taking machines down today, so I'd like to get the targeted
> fixes in and to stable while the broader discussion happens separately.

Looking forward to seeing what you come up with.

							Thanx, Paul

