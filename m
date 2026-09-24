Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEC4BC98311
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 08:59:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3AB96B009B; Thu, 24 Sep 2026 04:59:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B13216B00A0; Thu, 24 Sep 2026 04:59:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A53356B00A1; Thu, 24 Sep 2026 04:59:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 854806B009B
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 04:59:46 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0A95A1401D2
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 08:59:46 +0000 (UTC)
X-FDA: 85248057972.06.FFEDA87
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6C2C9180004
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 08:59:44 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RXZd67K9;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790240384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fj1ZPwdDvX+UjsWWWJMAQvWXngknkta8Wq/rzff/2vg=;
	b=GRVP/tEVGDOAbhLa9VdKtZUN+OmuURv3lEvJAJKiVLQiQu51jSmIT/VmVXE9MOR8M+PN3l
	Figpf/2GGC6B0zWGwis/LkaOifxYOk0kT2OyGHih18fyKszkd6VMyySeQbLlH0XKdfpZ8s
	d3kBPWGtBnROmLPjySOleqQd8REUQlU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790240384;
	b=jj0Ci3/U4ttUB350wxwDWqZFgSGfVtQ2g3k3emdoQ0MeZCi3HFe5JVi7JklJ4Ts30V37FA
	qKz83BSsLsEpi0w8SHxoFNFkE+MQj5XMoJmQviTYeU6CQsDvsm92+GxkYWPAsTviFUJ4zQ
	tXCC0Q8qA0GhPsPfLSl7rKAX0s9JZLY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RXZd67K9;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A40A441688;
	Thu, 24 Sep 2026 08:59:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E35F1F000FF;
	Thu, 24 Sep 2026 08:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790240383;
	bh=fj1ZPwdDvX+UjsWWWJMAQvWXngknkta8Wq/rzff/2vg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RXZd67K9zWwIcZ0O5/CuMnTCOvAPvJXqpijri2umAWD17aZ1yScJgoFNqP1eFwwbt
	 4Y2ZA628CzFjMpQbTMetH1X47CsR6HrOR8xSOWH5fFvTSMe+60PyX0LRoepeKvhA1A
	 fLksoJUgG2MmnzXe3jdAP5GyrJI4sdtb0COiDr1B195IA6+UvtUSr7Q52qevbfCkfI
	 nDoeemuecX3yYvH9KnDZBRT5OF6pf0msb6zG/SEjVFaBiPc0dn5zIB63Otz1Ql9tPA
	 drdNDAHFq8iEFgaL0BGYcPVwKxPs75kATjDuuGSLCcAaShFe32C+hy1CvaTVXj8pvn
	 kznHZdkcUuDlg==
Date: Thu, 24 Sep 2026 09:59:36 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Vishal Moola <vishal.moola@gmail.com>, 
	Ingo Molnar <mingo@kernel.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Steven Rostedt <rostedt@goodmis.org>, x86@kernel.org, 
	linux-mm@kvack.org, regressions@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: don't defer freeing kernel page tables while booting
Message-ID: <arTmLiTLnxhwohH1@gremlin>
References: <41a59ba9-039e-454f-8d31-f647db802ada@kernel.org>
 <20260924072819.33277-1-mikhail.v.gavrilov@gmail.com>
 <65b94694-d503-46c5-9f13-f0f7f8bba8d8@kernel.org>
 <arTl5Cc1B-2_BoHP@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arTl5Cc1B-2_BoHP@gremlin>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6C2C9180004
X-Stat-Signature: h5fxmebcpob9sckii1csopykfkz8ns4m
X-Rspam-User: 
X-HE-Tag: 1790240384-70247
X-HE-Meta: U2FsdGVkX18u+yxkCNbu2qIyJU9BfIKCKCzg6zY9rI2dGzvHKYZClAj4jWCZbm9nEKIKP9BZuZc/O3Hv7CFtiR+4o7Rs3dsUxoMs+2c+xdU3xO/+TpPdrEZw2lJy9cavOaAnZTvvZipPOHHL6WYggCvMYF7nxr76YYj/NNDgh2BYAB30v3/5zyjrhnp/HTZaTt9vg2UEj92Hqqj2pV2au++e5j1oGvSaTzKG9JfHMf9abfQkMkvz/VIbSGR4GH06xV7xiDl6QjcOCfaUqTRmKurZHFcj41wvTFtT8IyT+jMXC4DkICQi+g1FVdo57PvOlRr+TvHBk88IRI6kR+GW57NdRUUHMiI+0BxYkrE7YHQYh/4LMDQ/kXk35LYJUcZL8097JYRvOEwfTTda/rUhwxrIcnrZEOk3BlRG9LRPqhtvikcoFluJM+I/1EKppOYYZDr0SqYygSx+jQOGTTpm8rh3TZAlXZvBEkY5afigmxNh+/uRjkql9pjk6eINNMq+c9mWpEJ1i9TWTzKE6dzpGNOHgvauKC1lJMZCldjpvH1DkuO0Qbj/L33K0gAI/QgeEJdBwWp2CS0Aak5qhTInT0IyLyOT09dyrrqimYjdPox+Xj2Z0uWm1QYd/07u/SQMshEVlFEG9X2cz7gBQfUcCTvblkUe+ZbEi48m+p54d5p1PKBIG+5rNFlYXZurrf7QVE7XoFJnSIWaDJHC9cO8vbHq1sjh6mf7ZQt4wMRZN7/+jfBdFrtY7QU4gnUroOjrnzjCG+nIBZC9QJ/C5HU2ulbQXQlmJv+l7Q88fsP+ihjsWwh850nCNBlKP7mTwHxItiOFrRv/yd+PUDCH7k+ay53ep8Rhfa5LQFi+kBT5IK1BWoPysiZDCQbhtG6k37flFUCWrMfqhCRNsAfD9iLK3ZfOfkP49FqzKJr35z8Ebx9jcpS+QwMc3h8dMFkrEEVpUro/iGnO0yB/eSpJH4P
 IIMVRV+a
 ltK8CeXc3tF89UukBDHvStOqP+WebGLjQ/w+zTHVDMn19slj7J160sGV/KEt6G26xgo1/4z2TL9YS1KfhEOJLWWM+P6/gA8nHUCh2E4XZCyiwinRkmeDZl2zUqNZuP9q2QF29OBHPSxV91v+cbDtCZQwrRopivDiej/CUuOHjJ7burCC0v+NOhd3QVcPjBC4+Dy5Q/X5jeiNFzWGZNWlzU9hGsyKss/ayfvbfFpYBs/UGXIAilVqCY2Tslp9VSxGzQ1i115YgPINekFFei3RoH2lyeivZgjxMh6mV+ZqqVl2MU+QhtYT8wEsHmH/6lgytVSLfp/qLOk73jqs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 09:57:57AM +0100, Lorenzo Stoakes (ARM) wrote:
> On Thu, Sep 24, 2026 at 09:31:40AM +0200, David Hildenbrand (Arm) wrote:
> > On 9/24/26 09:28, Mikhail Gavrilov wrote:
> > > On 9/24/26 09:07, David Hildenbrand (Arm) wrote:
> > >> Should we instead simply skip the
> > >>
> > >> 	schedule_work(&kernel_pgtable_work.work);
> > >>
> > >> and rely on anybody freeing stuff later to just free that one alongside?
> > >>
> > >> That avoids throwing in more freeing handling.
> > >
> > > Yes, that is simpler, and the early table then goes through the same
> > > IOMMU flush as every other one, so there is no need to reason about
> > > what an IOMMU can see during boot.  The only cost is that it waits on
> > > the list until the next kernel page table is freed after boot.
> >
> > If we're worried about that actually causing problems we could drain the list at
> > a later part during the boot stage. I'd suspect we free something else later
> > already and simply drain the list ...

And on that, yes, I don't think there's anything to worry about there.

--
Cheers, Lorenzo

