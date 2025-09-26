Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9F97CAC5B8
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 18:33:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D7F58E0005; Fri, 26 Sep 2025 14:33:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AE7A8E0001; Fri, 26 Sep 2025 14:33:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EB078E0005; Fri, 26 Sep 2025 14:33:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0D3B38E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 14:33:49 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AD58513BB46
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 18:33:48 +0000 (UTC)
X-FDA: 83932250136.15.C66D190
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id F25C21A000E
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 18:33:46 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jiU5gx7H;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758911627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yz0m3v9EfT8mwyTJfXyPoCzDDhQ+qlKCuSoEzPmLLdY=;
	b=VjHgGOlvD2qMqisGkV/KqGI6B4Mqa2pMJCNxc22mJR6XyKW4ddDLPZ9OOxi1yL3F4dsUHH
	gGvIk4u4mKHMYajWMzlD+ukzn4pBeD0bPDwvfC69qvVJP6Zuhisrj0Ixgk82A70wF9imPb
	ybkAmoHU1Yn/pIl9I51ilUpG/N+C+xg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758911627; a=rsa-sha256;
	cv=none;
	b=4jo0bboGJuxOA4Ii7IXmz+NboFqC6G02+nHAJ8CDP5mM36FOD4gtfwNzrPk75I5edxv5g1
	4+SQpgh3UG14QvFY4/COBQlofaI+RvCcbMNdpDvsnUSZMH2gKWgOxOW5AGulsjvyFNq65m
	3HybSP88MSX7TDS0GwoNZu94D412O2U=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jiU5gx7H;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B85A943D59;
	Fri, 26 Sep 2025 18:33:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EA16C4CEF4;
	Fri, 26 Sep 2025 18:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758911625;
	bh=oXdar49xgqDvb/6GA2k51Cj07chVCcuaXGpUDgposp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jiU5gx7H0Z0QQWEfyb0ghA1Tu7eHHeEowdMW+LPoN/nofzvIs7hbcItqMMNVqf9/L
	 4DTttr8+d2VqDqgnWKhtNV4BuSlv0arCRIEn8csIvEGkecoPjkGqoWKdX4lemoAtFH
	 ElieiZpxTN5FpVoLOCVeU187mGKM4C2uB6d4iwGL1fcFYn0ikMaeDwPPWeeFHZjV36
	 /HlK4miuphsl2G7UIqdghk3K3ayfLH7eQ/Njd75oiUsR3uAWdKaK24eUhrvLhHZsbS
	 /SQCLU1d1BXb9CGUhEQ3uvAC2nVEHPPLuRzr/FOzolSmnS1PyscXdocYetENd9zyqO
	 PQU5ezUcuhcmw==
From: SeongJae Park <sj@kernel.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Chris Mason <clm@fb.com>,
	Kiryl Shutsemau <kirill@shutemov.name>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Brendan Jackman <jackmanb@google.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2 1/4] mm/page_alloc/vmstat: Simplify refresh_cpu_vm_stats change detection
Date: Fri, 26 Sep 2025 11:33:43 -0700
Message-Id: <20250926183343.54956-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250926182438.3108364-1-joshua.hahnjy@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F25C21A000E
X-Stat-Signature: nhedokyub6t91rnz8geuugupyx1go4rm
X-Rspam-User: 
X-HE-Tag: 1758911626-633032
X-HE-Meta: U2FsdGVkX18AeDW5NB0f5BIiH3Xf+AH9vg2DtX92CtVohbPPGtKyZtHyTNbZ3qnutSQigPVgvLwBn2JSsCVMH9rIWSFwjQo4+CXjwBpeYBJcrj0FF4OLekCbC1DHL5x8mu44XYWvv5ia9kUGsZYbWiXxseJF1ZV2xFBVzGKaogw/4l+VUQi38wj2OHBJ8TvVurhMmTYBqEOlF7vrjXbBRAjhu86EPE6agl+v9Mt8cuyLm6sukfU+O9yueZErUg89xZRr0YhdqgPShkRRRY0J7OLoykrp8xXcG5/LsF2Qz53eDVU8v4jEVDm5IYmBpY7G1edBWbMzbxmNTTEbKgGB+JjYCxzTvvvLuYwiKvsgcVmxERNwdgAoLkx+UOYy2mUtDyiRR/1g5t8uZprc/qP7AMvWTZMRn84oJlEWhfqnv6Eo93wSIxRkiE1dK2N9uZjl2l/TIqw3f4N29SqeU52p/rD6yjyYcCVr/7usP/4SxzE5FuAKk9lB6HlCo9EiGqj3hSE+/vZfr+ps2GRRDRAcun9tvggXEJkcTgpPqE3mDt6DZo2fG+eO03WDlv0+1X2RW4Dz6VDrMtAd1d3/YsOQanLL73Be7lODZ4EqFjaufBJu4wKs6UjJRxQNX9c7dFX7I9mjkhYNFYlaPf/aaXg9i7nleUQsGu9cT8wkjNIeatT2SrE4Expg9DS9F2FnA1bO6NOxe17JY+2flHObySUKyz4Q7UruswWHEaft6CQNMTuQqBIExDH2bitGy31AF5XZ99lL5gpcyAicSYUvsMmHe2recNl7sjyg6zx9y442lYwmCIrVX3ziizHRQc5tlkF0fjN+FH6t8ZkoUokgLK4COuka92EKCnIy5R7XEKCs0VTCU6S9STQiZqxWs1L+AvKN+Q1U/HqkhBEwo7hTQQMeiEz488sV1+aULXTpM8V8msl3rYtGMwlB1BFO4MSh2v8p5vsUVOnZ1nFOmilXqOY
 ajwFPefw
 RSBwo7U0+d074WTaZ0A5cMGU6JraEmRR3kMxaLMadseuvkMnEvRLKHz8UKj0zHV93r3JrMWogHgVwIw01Cj4ta4pNqolRyiFHr0KTU3dVpIfmL2p7cLJbyr+5775V/Ac3QugeNXVTlZuVqB490BMvWiVdeDtOOK0GdVnCEYu5eLYIOjtz+B3hDZ7dOGTnSsvDTRygfHpHDX9Fr4ZzGvZBFH6M1b8FzIb76pEOMp+4dhLkD5MwQCIAO3Q+1UoMVcK9BFM87Cy5OlWYGspDXnurcaoORMu7Rkt8PiDHlVJXPs3VcCwA/FPkc9B45ZMQjjdB2FEt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 26 Sep 2025 11:24:37 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:
[...]
> > > @@ -839,7 +839,7 @@ static int refresh_cpu_vm_stats(bool do_pagesets)
> > >  		if (do_pagesets) {
> > >  			cond_resched();
> > >  
> > > -			changes += decay_pcp_high(zone, this_cpu_ptr(pcp));
> > > +			changed |= decay_pcp_high(zone, this_cpu_ptr(pcp));
> > 
> > I'm not a fan of bit operations unless it provides clear benefits.
> > What about below?
> > 
> >     if (decay_pcp_high(zone, this_cpu_ptr(pcp)) && !changed)
> >     	changed = truee;
> 
> Here, what if I change it to just:
> 
> 	if (decay_pcp_high(zone, this_cpu_ptr(pcp))
> 		changed = true;

Looks nice to me! :)

> 
> Since even if changed == true already, this will be a no-op.

I was thinking the compiler might or might not emit unnecessary writes, but I
don't really care that.  Your suggested version looks good to me :)

> 
> > Just a personal and trivial taste.  No strong opinion.  If you don't strongly
> > feel my suggestion is better, please keep the original code.
> 
> I feel like if someone (you) feels like bitwise operations here makes it
> less clear what the code is doing, others may feel the same way as well!
> Happy to make the change to hopefully make it more easily understandable
> what is happening. 

Thank you Joshua!

[...]
> Thanks SJ, I hope you have a great day!

You too!  Plus, great weekend!


Thanks,
SJ

[...]

