Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7374EFF8850
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 00:00:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B1F96B0005; Fri, 24 Apr 2026 20:00:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 989906B008A; Fri, 24 Apr 2026 20:00:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 878836B008C; Fri, 24 Apr 2026 20:00:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 731466B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 20:00:11 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2612A1C00B7
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 00:00:11 +0000 (UTC)
X-FDA: 84695120622.08.988227D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7548240014
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 00:00:09 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IsP6Nh8W;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777075209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W3J7R3MayZb6K9GPTphDP/mJ8lRHfTntmHcZ44PjNvM=;
	b=tr4EAjxVOPYhIcl8lSq4IXCgXawLSf+DGzUtYpkmPWq5fGl7ATzoU+hQziG+41wj7fIKGu
	iogIaYBtJhD9e0LCe6xNbfeZf1sBQo4js6F/77nb0jLJmYzJTNlfbfxh100PlrP/PCn6C8
	MXfvCdWDKvBadpvj1bB8AInPOYrB2M4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IsP6Nh8W;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777075209; a=rsa-sha256;
	cv=none;
	b=EchrJSa6Z8jcMTpiqVPZqW+iPJ0yYhEqyLGDaNtFDKpdnfUTy06c2iuQ0C2hLyEN7n9Go5
	uLh8JO8NU98w8ZzZoXsLushb8dsy7/grKCkQ4zHjup0vI9GygMmI4wvrSdCQHmJic/9IbC
	FPftxIO3stn/97X311TdMjyYmxR4POM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BC07F600AE;
	Sat, 25 Apr 2026 00:00:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F5DC19425;
	Sat, 25 Apr 2026 00:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777075208;
	bh=C8r7huZNyRElYBe+dzNVCmXSopmsS7PatU3slqIvHiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IsP6Nh8WvKEeCyPJ56ahQHwF2bxzxblJotd1wZXbilPyV3ve/Uv8Fv6kAOoOzg680
	 JLRwJXvtvWV8b+bWgo10MkWEQwvxbFRoRRApx99J14hHn8fRbsy2knuRrjitI/Yqwd
	 5TDlZhBpyC/o7ItjCRUbfLopFA09l+QpXJe3pklvOuKrdKP7MrYWCUQGYquGkA6Ylc
	 z+mx7p/i4O4Y3yD3JVGMuSPP2XfiojskNYGLRFLNAXsvYcNyZ6ucZXPH7nVSKGrAy9
	 qs9kjsYLBG6KTgXZQrtiCzdp1e7jFlwQE8kqWEmr7uXOjnB2b3S5Jk68JSgotIDUQR
	 qvV2VssP7PYQA==
From: SeongJae Park <sj@kernel.org>
To: Peter Xu <peterx@redhat.com>
Cc: SeongJae Park <sj@kernel.org>,
	Kiryl Shutsemau <kas@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kvm@vger.kernel.org
Subject: Re: [RFC, PATCH 00/12] userfaultfd: working set tracking for VM guest memory
Date: Fri, 24 Apr 2026 16:59:59 -0700
Message-ID: <20260425000000.84178-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <aetaH3W47iR56nQ5@x1.local>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7548240014
X-Rspam-User: 
X-Stat-Signature: j784kepcayia1neznp7qwdkfg49og3oz
X-HE-Tag: 1777075209-28893
X-HE-Meta: U2FsdGVkX1/8Ia6cZBAXKXabA9/W+afEwNaE4umtRkYu3kROkUnA/F11BzIdWsHRkfPiQcthglMQv+cUs92GWX4DIoDmO8Iz71jGhia1dDPQ8urUwZwixV2lXudV2hFb2fPI8r4G2SG7BU6ku4hDS0SS8947nBxtSSzmepaz1N+VqCl3KJr85SfPv02Q0fHPxP+cDKgJ9INEeL0iO12fu5lfCJf3bkaPbP10gJY0YEiH5XIhIKinnVTmeqZcI40Ok50h7T9El5led8JOOiupLOXuHX3NWLylHHwvloWm5NPiF5clDTJNSmRX0OoKoQRkm2Yzxw6r7MKHkpO5sB3LIBhJFs+I/IDu/KR+ZK92aGd+v/R1J+vP6cnH+SRJ+LXyYAblDR7SwkuHqomPO4bM1vuuQkFdrRm9ftM6clVCXynDJvc9s+WS7qcji0kULUR/Fk4KPOUlLCPGbi2MUnUADp87amYHlCYDoag+8K1b2EBfL2dKrtv5/lj3q5ZpvU50aVeG0b3hguhNXu9zo+bU/B2qpJQhI41NfsmKe0zhF/kjl/11w/TtHul09YNy7fQtjYXCRU4+VXI8YBlbw+pi1fPTJXg+i/ftVP3yfHlJftq+0Ol1ul3fHqdJLtbaYak4JNVdyn+8FNa2mwEB07Ksrans27FwXqrZdDHmGqrWTFltHqFIHTcPlZpN+8pD/qrfJOj6lR9Jeh0ZupfmgnFNj5jsXgWwhTsE9yvbYQCGxGh2HXHFWZrPel6hNyFZKXpBrKm4vWxmKm4QMRe4hCtrPni6OoVbqis4AaF6HxjxnYSlDVhQT4V8tztgqUSgkgNNH2zkSvpDaBMMskmItKVGVkFWihlOKLTrBLkoUYrlOmM+L5C1nWcmWQ8NMptNSjEfUIn65Vvwh8DU5x1o/TPQJNHYZDuEzuUCFJEl+X5VXZDzeMr6xpJ8T3jHsK3mLyBQdVpbkZi8RK8JGpeuimn
 8sZZEPHh
 ELEp4oNfboM6ZpDF6UOgEZBlONKW+m5uB1KA+1NBDlI7/KPTbJd/l5B/UVyy52cqIbLDubbAYXygx4MjAlYPPWNOU+hWnuWLXIY0YO+zowoqhWmSsIq+xqM62oFA8C09UN3ozgdIyHHrYMq3ig5e5JXmlF2Z2OPs84YBU7kwpSb9YYoErnmFz0BT4CQIosJd436WkJ5KjUvLNwrZf9BIrYj+FOVexsFGttv4PV76FFrROjO71uZ4lvlLw1IpHZpHH988RVC3haWgbRDCTYnRCwaIXOkfv/tXTaQAC2vxMXJLlfGlK10zmwVjL7wNbpPnoE02MQeK+B3jwtHREfXqUqPlVShJNPagx5oEqQhRE7UaPcuK6pD89qWhfA9Pf4hJH46yoC+eGyL9g9NHdvw1rAAaza7f5pOu9N0DB38lWOnhij+c1g971LmbtSo5NHtGH4wP5uvcGwGltDZT/O05fTXzu2WAkdrx/AKtCz9URZbN33JqnriUqfEC0Q8qkKXBRH+YbduQq00aOEJCic4x28lBAZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 24 Apr 2026 07:55:11 -0400 Peter Xu <peterx@redhat.com> wrote:

> On Thu, Apr 23, 2026 at 05:26:24PM -0700, SeongJae Park wrote:
> > On Thu, 23 Apr 2026 14:57:34 -0400 Peter Xu <peterx@redhat.com> wrote:
> > 
> > > On Thu, Apr 23, 2026 at 07:08:00PM +0100, Kiryl Shutsemau wrote:
> > > > On Thu, Apr 23, 2026 at 10:50:06AM -0400, Peter Xu wrote:
> > [...] 
> > > > > - Whether we have explored other approaches on page hotness tracking
> > [...]
> > > > DAMON is built around sampling. It is good for working set estimation,
> > > > but I don't think it is directly useful for eviction decision. It can
> > > > miss hot pages. LRU rotation will also loose info.
> > > 
> > > Exactly.  If we need to collect ACCESS bit (or anything similar) for
> > > eviction accuracy pusrpose, IIUC we need per-page info, we can't estimate
> > > by sampling.
> > 
> > That's a fair argument.
> > 
> > Nonetheless, there are some companies who use DAMON [1] for a similar eviction
> > purpose on their products.
> > 
> > Also, page level accuracy issue was indeed concerns from many people.  DAMON
> > therefore provides page level DAMOS filter [2].  The idea is finding a large
> > region of cold pages in low overhead first, then do page level access recheck
> > on page of the region using the filter, just before doing the eviction.
> > 
> > DAMON-based memory tiering also uses it [3], to avoid wrongly
> > promoting/demoting cold/hot pages in DAMON-claimed hot/cold regions.  The
> > evaluation result was not very bad, and a few more users reported positive test
> > results.
> > 
> > Also, DAMON can be used for page level monitoring [5] and open to changes for
> > users.  Actually a work [6] for making DAMON-based page level monitoring more
> > lightweight is ongoing.
> 
> Good to know that, thanks for the info, SJ.  I'll add a note and try to
> explore all these at some point.
> 
> I recall I read a paper describing damon tracking overheads when
> granularity is small and when the memory scope is large (in VM's case, it
> can be e.g. 1TB or more).  Would there be quick answer on whether this one
> still suffers (or maybe it was never a problem)?

I think that should still be same.  In case of fixed granularity monitoring,
the overhead is inherently proportional to the memory size.  And we didn't make
many effort on making the overhead lower.  We have two ongoing works [1,2] for
that, though.

Nonetheless, whether the overhead is too high or not would depend on the use
case, I'd say.  That is, if the system has hundreds of CPUs, letting DAMON
occupying one CPU might be no real problem.  Rather, there were users who
willing to give more than one CPUs to DAMON if DAMON can provide more accurate
monitoring results or work faster.  That kind of scaling is possible, by using
multiple kdamonds that monitors different partitions of the address ranges.

> 
> > 
> > I understand no one fits all and the decision is up to each user :)
> > Nevertheless, I will be happy to help if you have any question or request for
> > DAMON.
> 
> I'll definitely ask after digging more into that, thanks for the offer!

The pleasure is mine! :)

> 
> > 
> > [1] https://cdn.amazon.science/ee/a4/41ff11374f2f865e5e24de11bd17/resource-management-in-aurora-serverless.pdf
> > [2] https://origin.kernel.org/doc/html/latest/mm/damon/design.html#filters
> > [3] https://github.com/damonitor/damo/blob/next/scripts/mem_tier.sh#L40
> > [4] https://www.phoronix.com/news/DAMON-Self-Tuned-Memory-Tiering
> > [5] https://origin.kernel.org/doc/html/latest/mm/damon/faq.html#can-i-simply-monitor-page-granularity
> > [6] https://lore.kernel.org/20260423004211.7037-1-akinobu.mita@gmail.com

[1] https://lore.kernel.org/20260423004211.7037-1-akinobu.mita@gmail.com
[2] https://lore.kernel.org/20260423122340.138880-1-jiayuan.chen@linux.dev


Thanks,
SJ

[...]

