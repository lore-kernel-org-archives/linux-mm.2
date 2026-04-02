Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2309CD39421
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 13:19:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5182D6B0088; Thu,  2 Apr 2026 09:19:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C9A56B0089; Thu,  2 Apr 2026 09:19:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DF9B6B008A; Thu,  2 Apr 2026 09:19:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 30F026B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 09:19:33 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CA1B313B497
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 13:19:32 +0000 (UTC)
X-FDA: 84613672584.27.2347D08
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 26F171C0012
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 13:19:30 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WzJ7fOKs;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WzJ7fOKs;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775135971; a=rsa-sha256;
	cv=none;
	b=OoYPyYR0YKRAPDBrw6wm8LWmo5PAIqTCtyR3cPQ4n8cDb27pdYVZOtbFUbiZhkqi6Ht2sA
	Oe9csbkcHBSBV0Lsjz7t9cK5w8cubgoigSadi1KAbQgb2C3w8Wm07JC3OaPNqo+V60ngZs
	TBmeTNhBQqcMD/jBfYzQC07f+iI65hY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775135971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U8snQy/eQ1CtSl7sjsyKzVMyGOlyG6mxJvBfsXBezEg=;
	b=fjYNpGeUwZVWz7DTgiRSmIl1U5euy5bJom7U+gzMURzuPcLw3xS0EULvDC8cfT4u2z1eVV
	C3YHfKXkG97BzhyDRXChpk9a4ltKwnELB2zZ6TSCOV24iJqc+AVHxD45jOecGyIJmU682i
	SRnfbKrwnR5XF/smdO05xVRnU9mPd1k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E1B0A42DB8;
	Thu,  2 Apr 2026 13:19:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31ED0C19424;
	Thu,  2 Apr 2026 13:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775135969;
	bh=CP9YsJiyp8+E0fCnXGymsdmnpD+1bZ07yNUfO87lEas=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WzJ7fOKsWMjrIYw4RJoa1MJ8JdkSBETKO0e3SOHFOipeBkQaHxlJaKax1lNPJAeQM
	 AyQHmkOhxZVOkl6d2nMduakMhWSuDlo9qEM9+GrE4ZxxIEUxLicD6UisMn9EKqxiP9
	 WB8vE2SXYzvePC/wKF6aqhfFUmK0Obdf/6vaD8rj8DGtV6r1S5Z8KNB+wXA9V6Ey3k
	 hoT4E+QVrLAPlVw39NhFwHRy2vT/WfASIQgOWFBVDasGHTeogMRrCF7a7HzWLX036o
	 A+9JEDdDNYvUUqHINUb/XMGlk1O4ax+VM1V28f+QpJ9iKqzfmWmQ+8TDG62A4a7/Vn
	 53EDKad3CxxLQ==
Date: Thu, 2 Apr 2026 14:19:18 +0100
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org, 
	david@kernel.org, ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz, jannh@google.com, 
	rppt@kernel.org, mhocko@suse.com, pfalcato@suse.de, kees@kernel.org, 
	maddy@linux.ibm.com, npiggin@gmail.com, mpe@ellerman.id.au, chleroy@kernel.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, hca@linux.ibm.com, 
	gor@linux.ibm.com, agordeev@linux.ibm.com, svens@linux.ibm.com, 
	gerald.schaefer@linux.ibm.com, linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v6 2/6] mm: use vma_start_write_killable() in mm syscalls
Message-ID: <495a4331-6575-4eb5-91a5-245ab0ad3637@lucifer.local>
References: <20260327205457.604224-1-surenb@google.com>
 <20260327205457.604224-3-surenb@google.com>
 <5d90d998-9b8d-435c-b684-260600311797@lucifer.local>
 <CAJuCfpE5w8r_6Ss=5ZPrEb1RQOTG6HyY8Pivac=iiyqFRZvD4g@mail.gmail.com>
 <20260331112921.854d4f6cc793dba0972ee9f1@linux-foundation.org>
 <cf6975a6-336a-401b-b122-b9597b5710b7@lucifer.local>
 <CAJuCfpH2eomYbZ0DzKpkae5DKVF69aRsfXx3HzMfPc6cTT5fTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpH2eomYbZ0DzKpkae5DKVF69aRsfXx3HzMfPc6cTT5fTg@mail.gmail.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 26F171C0012
X-Stat-Signature: 8hh7zbaed3zy1jywr7bk8m3zi9owwnkw
X-Rspam-User: 
X-HE-Tag: 1775135970-331535
X-HE-Meta: U2FsdGVkX18O2SaYnm/1ULMBECdlFJRJ1iZ/IlQTO5L7EozYihz3n5+OQi5HpavjiHBWSVmeNCODQRosNpg84RsIHr1FXK4pLW68RaMlqiJQXP0XCNydV8kT/GBBtoU5CO3U2w/tpVw7k7l8Gf0dGTH899XrSfkvVIvxm5i3ZXtHszKMPoS5q9PY1nI6Pre3yVLyfycSW54rNxRJHjtBS6pybIReJVUgmbWL2iRH5MYSMZyZA9bSxJ12Xr6YIZrujsjP4WbtQNVmW3ViQfWoGOY7dXhUMmRJ1zwLjNs77aEiYxrmc2QYFs596cvIcb3waRijEWSmyrfes7aGv8pRxcVFyTPjvU/i+NbrMm+d0CnZ8kZhkk2jRdpj1sqzS7JTttaZfbq0aNzZ61aUa0MMKOai2h8BNz/g+fDWHx9v1RmYkT6MIh9tpNFkuFXscvh9Phk5n5nzMgR4sxKu/RC9uILq2r31XtY9cEuvkl3R+GN/h9qUnS2mAtCBrypBN2ArpUW/2epN2JNDbdlmolQJIlBneFvu8oUWmEE7Oxpkk28cso7xaOu4MYZlsB0pzGXTsshjIOdLZyw+40IgZKbV+57Pr8X1lhyGYErKOt6GXGcRD8LHd61Rw+9IhHzT0OSGsZuO1wtmjQkzkGT808luuDXpm9VbmRYUTFz+qmzOERve7aA8ywnqMAMStLmmSTOL2nihsKdFK8zVebLM7c324KVQPjNYgZfiY0CSbcGXgBmlv7kiW9Vrnku/yorliV4RSRWTQIGtfxFC7u8BmPcBWvFZTQbveKsW9BywuFGhxTGlQ5As2HSwb4mCS0SnuWKmB6nmGfAzkbsA8/NzxpYGK6/jv8VNq0wFzuVwlOCCLGP2U39k6BDdfLEebqMHymILmj6eNI8VfzHO6L411uHgiYCvwSszqbuf+MPefJSN9YvPc4uxN45baFc2jUQ83LqX/+VAe/cqJ+fvU+KH5/4
 BgRvIaGf
 CK0MWJMm8jUts3P043EjUV27JHqo67X4xa6hOzXSY8N9JnqVuJ/Cqsta1MUMKQ9Io+A0aVhR4Ucm3FvSNEOhfMkIfQyLh/hsEuWhR5n1oBB3kUp/Vb+pVQiApg1jOP1tp3OT0MBW9/yKSr0XfrzEKSc9WK/orCGBdcUN4ItScN5UHgu2OqcDqPfGeF7niqMIESp95IZUMzDLJex5FUiOFUMVNpRY9LzeC5WgfjOHt/j1NQeETVmr5mCKzWgaufqHQRSyTrtl+pjV7JdFMXqJ2GAw1Mx86ZsHzqQSdgndikF5VazqkUYHT7MLiHUeyl9LPCTTE9HL7XQWnP7nxs/l32/7w9cXPq++AaNkpnxfh1/DY+HjarKO3b5pNL3qqkQje5OKdvDpbOwNF0HbSj1t/GXQlZw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 01:14:51PM -0700, Suren Baghdasaryan wrote:
> On Tue, Mar 31, 2026 at 11:47 AM Lorenzo Stoakes (Oracle)
> <ljs@kernel.org> wrote:
> >
> > On Tue, Mar 31, 2026 at 11:29:21AM -0700, Andrew Morton wrote:
> > > On Tue, 31 Mar 2026 08:01:11 -0700 Suren Baghdasaryan <surenb@google.com> wrote:
> > >
> > > > > Instead? That is, assuming we really need to care about this at all.
> > > > >
> > > > > But I think I don't like this change at all?
> > > >
> > > > Yeah, this was the part I wasn't sure if it's worth adding. With your
> > > > vote confirming my scepticism I'll go ahead and remove the parts I
> > > > added to avoid extra vma_start_write_killable() call (3 instances in
> > > > all) and will post v7.
> > >
> > > Thanks.  I'll remove v6 from mm.git and shall await Lorenzo's advice on
> > > v7.
> > >
> >
> > Ack, if we just drop the problematic bits we might still be fine for 7.1 :)
>
> Let's get your cleanup first and then see where we are. I also hate
> the way I have to report a fake error code, so with that cleanup the
> patchset should be much nicer.

Ack, yeah it's horrid, + _my fault_ :)

I can put something together now perhaps that can potentially be queued up for
7.2 at 7.1-rc1.

Cheers, Lorenzo

