Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF6F4C61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 05:31:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C097E6B00AA; Tue,  1 Sep 2026 01:31:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE11A6B00AB; Tue,  1 Sep 2026 01:31:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1DDF6B00AC; Tue,  1 Sep 2026 01:31:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 93DEF6B00AA
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 01:31:51 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 141AF12034D
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:31:51 +0000 (UTC)
X-FDA: 85164071622.06.311FA70
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6C71DA0003
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:31:49 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KJiopimI;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788240709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5yv5dZp1OovU3o/tMe/s53rqpohnpt5v6m7qLxX7u8Y=;
	b=C8BQ9NMnPa3LrE3XvvMHek3zGbx3GD+SgMV7RpxuChX8pBs9v5x0oOzdS50QUsI5V7TNx8
	3Q8WwtaWNpBXKeuAKuZdNH4iAldV2LNZmBGd6u59GZx0QDS/c4c/x1rGn2WFpdvxz5hm++
	KN5+HABku+saXOUw34V9cH4KquPKctQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788240709;
	b=7kox2NjiemDDeAOt7/Jgo74cJUj6vy6vZbg70OQMgxnCuWE/VpBWSMmfMxbpbIqLb9Hfbb
	XVw8GvH9pe/v1Zh+0/6WdFkDrtwVqVj1qAnAtfpyqQ865nqEOAnhRijxuh0ZbIDZ4Zx0Vp
	jgyUq0IrMYQYriggSFSOMvpYD0IX2hA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KJiopimI;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9F441406CA;
	Tue,  1 Sep 2026 05:31:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD4381F000E9;
	Tue,  1 Sep 2026 05:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788240707;
	bh=5yv5dZp1OovU3o/tMe/s53rqpohnpt5v6m7qLxX7u8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KJiopimIdEwNANCZnewWxQ09EWw42GY1qt1ibcigOZuwffyD2+SajimU8l1c0qrFf
	 hSYl9hcluqz9sisuiVH4ucu4xfhA9VPnp7+qbSwQqE3iCdTGG04eddL0xC1eghNKS/
	 Vh+8oxsvug8FQEA+jc2DQ6juo7zgNvAFmjDKueln85HS0QH8X6yCBAop0vt4JrHDmB
	 RDZY4NsJwBxGSh1fytV1LmIJ0CRuURf7t9Nwz/R1t2t4pWSxdZR109V3Z3A89i9TUB
	 smPDsNCwEFqdhzbop9L/bfUkXzXdXhjRFIGZ4K2WS0q+tB0rWRswv5MiDeuix8Q1qv
	 wuRBFVomwGgyQ==
From: SJ Park <sj@kernel.org>
To: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
Cc: SJ Park <sj@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v4 3/3] Docs/mm/damon/design: Document hugepage_mem_bp target metric
Date: Mon, 31 Aug 2026 22:31:39 -0700
Message-ID: <20260901053139.24079-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <893af75e-690b-48f0-9cc9-afe07c05565c@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yics9m8wxgsnkgbnzjhsgzom5y4ork8m
X-Rspamd-Queue-Id: 6C71DA0003
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788240709-256299
X-HE-Meta: U2FsdGVkX1/fcT3EZ82vHweL0tOWE2YTD7DVRdGVWNi6nZ7rPfkVtAZOMN5zLZNyFxBKS9JbzDgJB4bHCh9Ox0D6cx/6Os0T4S8JVMfelfMG36l67An4I0JOPd/JFNcYDEriC88lW+pVLOpp3jDkN8GjReBNO5WmlfEA0W1zeAba5AnLQeL6lT2Meu9K5kx8gb3dDNR8TihRr+Zo/cUmIR3wVOkjzDBRNruQKdpfUokFG0yjgx3JgxRBSw8TjWxPd6j8z81RYoIWyEtqO3B/NNJtxosWLY3PvBGTBqmS5Dx0BcJNBZwWmNSwg/0pPgzpxOHvsk1PRsc+SrLPB1A+9wPPHUCG0RBJ7rcZ8v/Yaw/8+GKZ+LuFC9844/bRXhm95didHV7GYdTqZs3fGNzrw3UMi5ofwhE5NhbWpXU/iXXjIzJj9bRJ7EtQZq6obmxiO39JdSXUu9yeRNWVFzKQTsiTe7SUGlZDkwB9JRTdG0nMQ6SHB9GKLsyYRc3ZhSkvtIRcgZF9zoR5o8phUTyvCNDJ6Z4VLs+tmi4+5n87EU2OXE3ZuueE9FEyaG3MnN4ZDaLX4vC3pgSgaHA2N3oIAMhcetQhM5mqNLY83tFJycgklC/voyiWPrP5aXzwGyIIze+i8ezux8Z8yyHsWN8LV9fAE0kb/wk2IeKSJ2YH9NjpkA/rVndTQu2dgaQ+4gps/NbKI3RXMxq80E4pghNQsWQuhMFzmzt4c/U4+kCjYAKsNXMX8Ldwthb4OTi6riUZEY5XI7Ps/jsAWrt2e3niQDml9ps3XrMniFxutrIELI8KX2RKwD1dOo1Hf+HYm6p+HqQPRuv5u1GrgtlRpzOTSYxSuVTgRNFvcAfImPJp61KDGXA/BJfRHmDX5+8ta1X+BZCpRo1f59R3M+VpwCHQLHwievYIWUPqxbFpJDfWojtj6pZ5/JQoKUtYBbXcj1VfxdkYhGX6NNhcqdZre7T
 1RgTBE/C
 65hv7cycZKq9u5vvoALDnDxrpofA29B5B1enU5oI5Of3cGsjrWNgRrDmvqea94k8peDJgoVr/KT5Aw9zsgdQlPHH4gIqZl7NtTQn7c/gvcCz1kfrdJfMHj1qI0bx0HR5NkDgeWGGwJJOGXF6UjFBHhw37EYWOOMw3wo3D82CNLWAYfuRCwhG/zG+lK5/EoLkDNaYl0PsYno/35bKGOUqY0uKw4ctJNjcwBMkrF0AVcPapECz7fiyF1B3rDE2deXc/PBtoCeHCvQaaI/EAwP9lpPhsk1vi66mEQgB2O0zSiX+DfZxUGnE6d+CvUPDj6DNkWU/Riwr5ebNStdyOM6TPaS4J3cpEAlZQ1ESPe4gbtp0pgs9JX6SwUqmB5oxHID+iMMryl9GgzCekTHuH4Ifg3UNPQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 1 Sep 2026 08:20:50 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:

> On 9/1/2026 3:47 AM, SJ Park wrote:
> > On Mon, 31 Aug 2026 13:00:26 -0700 Randy Dunlap <rdunlap@infradead.org> wrote:
> Hi,
> > 
> >>
> >>
> >> On 8/31/26 8:45 AM, Randy Dunlap wrote:
> >>> Hi,
> >>>
> >>> On 8/31/26 7:47 AM, SJ Park wrote:
> >>>> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> >>>>
> >>>> Document hugepage_mem_bp metric exposed by sysfs.
> >>>>
> >>>> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> >>>> Reviewed-by: SJ Park <sj@kernel.org>
> >>>> Signed-off-by: SJ Park <sj@kernel.org>
> >>>> ---
> >>>>  Documentation/mm/damon/design.rst | 2 ++
> >>>>  1 file changed, 2 insertions(+)
> >>>>
> >>>> diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
> >>>> index aed6cb1cf4831..a8c163475ef2b 100644
> >>>> --- a/Documentation/mm/damon/design.rst
> >>>> +++ b/Documentation/mm/damon/design.rst
> >>>> @@ -713,6 +713,8 @@ mechanism tries to make ``current_value`` of ``target_metric`` be same to
> >>>>    bp (1/10,000).
> >>>>  - ``node_eligible_mem_bp``: Scheme target access pattern-eligible memory ratio
> >>>>    of a node in bp (1/10,000).
> >>>> +- ``hugepage_mem_bp``: Total huge page to total used memory ratio in bp
> >>>> +  (1/10,000).
> >>>>  
> >>>>  ``nid`` is optionally required for ``node_mem_used_bp``, ``node_mem_free_bp``,
> >>>>  ``node_memcg_used_bp``, ``node_memcg_free_bp`` and ``node_eligible_mem_bp`` to
> >>>
> >>> I've looked thru the entire design.rst file and cannot find anything telling
> >>> me (or anyone) what "bp" means.  Explain??
> >>
> >> OK, I found it on the internet. I still think that it would be a
> >> good idea to say "basis point" one time (the first time that it is used).
> > 
> > You are right, and I agree.  I will add that clarification before the next
> > merge window.
> > 
> >>
> >>
> >> -- 
> >> ~Randy
> > 
> > 
> > Thanks,
> > SJ
> 
> SJ, should I submit a new patch to fix design.rst?

The lack of the clarification of 'bp' was introduced before this patch.  So I
don't think you should do that on your own.

Of course you could do if you want to.  But that should be a separate patch in
my opinion.  Let me know if you will.  Otherwise I will do.


Thanks,
SJ

[...]

