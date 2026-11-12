Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DEBE606A33B
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 12:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IcnyYf4L
Received: by kanga.kvack.org (Postfix)
	id 485046B05DC; Thu, 12 Nov 2026 07:33:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 436086B05DD; Thu, 12 Nov 2026 07:33:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 325216B05DE; Thu, 12 Nov 2026 07:33:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 115F46B05DC
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:33:22 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9D2AD1C3DAA
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:33:21 +0000 (UTC)
X-FDA: 85426407402.05.3A74A53
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id DC2C914000D
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:33:19 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IcnyYf4L;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794486800;
	b=ZKA7De9pwDJ90bLfH+YQzVPsLawk8JrCpor2LR9Wz4FPQ/I9P+E1F8mfd6xYRlTl6NTHFC
	kUA2Itk8a4aYTLe7IfqroqHmVU3KDLgxq7G5yzTQNDSvFe8KcvCsFRnMZuW9p8HQHVhKMB
	gJS+njFym45OCZsJUMFaKChwr8zrUpQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IcnyYf4L;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794486800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DFTNJC77J9tgE0ZUnDgATKIY1weLjDkKxfUFz6j/nbA=;
	b=YXFhBAe16emwYRCgOQ885HaA9HT5L+WQQ8ojNE+rcST+/7LlkRquL7ZVF/VitVo1xkdCNw
	JLpc9QUYANmOwSoCUuPHZr31OwmvmfEepD+5wvJFY89uZnoh6Vquixa5BlQRCrGlM7xLTh
	41MeKLinotjZTL4DzS6pg941YJvV9e0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1345342E0F;
	Thu, 12 Nov 2026 12:33:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E91D1F00A05;
	Thu, 12 Nov 2026 12:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794486799;
	bh=DFTNJC77J9tgE0ZUnDgATKIY1weLjDkKxfUFz6j/nbA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IcnyYf4Lnmvno4HSaDYNqpLViApXQJxkxsTrmbBk1kxUnJoVojSJPuh7/q27zkDUe
	 tspkSE3MSu6vxUJRoLTa7pCfCX2QRUgHs88Isq+w5Jqo8J/IJrVwRqefO9H016yWWv
	 VF5EkeRCe5dSMxXZhQRCBXRjsdXQvhVu87d074n/znSQB/iUlkSFLToer3QfZnmI3m
	 RGjscswltykJ4albLnBEHIJYeq7/eYGI7b7TFKoRIxYgODlHTf8YewkEMXYtZWd+qe
	 5gAsaUol72u4NigCA9c5k8cUiVZOwLd5uZxmAsQvEBhkjfVry2KnkmuNxFHWRo4+8j
	 KxGaZYiCTX+dQ==
Date: Thu, 12 Nov 2026 12:33:07 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Jann Horn <jannh@google.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Balbir Singh <balbirs@nvidia.com>, 
	=?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Kiryl Shutsemau <kas@kernel.org>, 
	Yu-cheng Yu <yu-cheng.yu@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>, Chris Mason <mason@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	"Borislav Petkov (AMD)" <bp@alien8.de>, Mark Brown <broonie@kernel.org>, 
	"Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	stable@vger.kernel.org
Subject: Re: [PATCH 01/13] mm/mmap: free gathered pages before MMF_OOM_SKIP
Message-ID: <avWxV0AcMe_5bAdc@gremlin>
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
 <20261111-mason-migrate-et-al-fixes-v1-1-3d2454362e8d@kernel.org>
 <avWgulaWoKBfIFlo@pedro-suse.tail5790ac.ts.net>
 <avWtxdIHSJJ_uNwG@gremlin>
 <avWunRPQJQctsvYl@gremlin>
 <avWw2I3Or0z1OmqE@pedro-suse.tail5790ac.ts.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avWw2I3Or0z1OmqE@pedro-suse.tail5790ac.ts.net>
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DC2C914000D
X-Stat-Signature: pmbmrxbchft3e5mohd1ew6fq7o7f7e48
X-Rspam-User: 
X-HE-Tag: 1794486799-761998
X-HE-Meta: U2FsdGVkX19AWbIhIOw8NFx+xUUJnaDK/qqHs6seXsocakOivj6ST4nfkbk3MOlGc8cvkak7ys12ukhkaICFVW2s4hwJCeWiM0jpkIJO4K0wZHLS+FUED+X5pZ6E9wnO0XOD7FhfanEiY9zLnmi/nj36IQg7lJfIFm+RYqiEcLJxis9cSUc6vkPsJpUHkvjLY7mQMvFGHwOqDN5tnazJuJgr5FDfsBcZgPxFymgPk+DMK051HavCIKThMX4pvDSWK/2kwMtMoPEzFxJ01oRuOMTLMLZt/c2di4aJFuj6f2GHbHTiVfKTn4g7Vo7tRbiihJAXivArsUmOImUmQn6WXp/nxuACheQLInLp3GahKFz7/5l8xuxCozLcHHQb9kO811VoHlnP+Cu/N9k03cb/IrmFB2rjfloVpyQ6YVlrIpkQ19+6noOv79c0erT9EvecKQLnbJQ1Bv2yNMUAlYwPAPy5WRpRbed/3ccmjQqDVa2fO/+CF+dIQgO9vMGny7bXRdlastgOge1oiHQ74FJDWlVB53xy9MrWRuMgrQBHsTshfWgJsTctbqNkWP8eksIqL0iM7rA3k4AVgug44Hgh6W1sT9VilQE/+TywCIQkGf8QWBJFpgLZDS3rC6oPeKcpt0twLS4e5TlNRbBz2yrucspFfLGTifFSY1WKTm542PLOVaB6DlMRQS6wZmCwQJSKUlAEgEM2k6OHKMR5roaoNXV+0jNbj4Ss3OGcodx5KhqNarJ1/9uXMlTC0LZWvvNR1l0nE+OO4yNKkm5whODjX9hinEYDNbQVOy3wb3GjeKnWdih3DzcrVmF0GPq6QDFotTee81sGW6na/tHymBgJh+euoQ67ozexVGJ/C4j/S7ZA04fugRmq+/YBhtg3LxFYGbQwAUtZamHIZhxA5/kSRUPItKWsY3zfPdpfaZnoVygry2Zm0E+FETzPIfXQ9ANFgT8FqrLoR3zFZZXIwDC
 Nw3ETEno
 9S8t/bBae6aVVQ2FgPZx1UTg2A09Tq72aRzzzGKOLhK46jIfNJSFd3UcszGNYnoUAbLjqlRbGEKmtgZu2F2Zan+A+c0assNbDMXy2jDQfvRywrgNb9+/1p5zbR6EQ+GyBErIewwSlfPbbpSZEXmO3H1N0qESvFoL8ITwmGHNqSFg3CTZEO6vlrx8Jh1Aek3DRUfD6KIWsd+NVmAX8GRtiH7Q38M57PMfiSoQFUYaUa8mKvDFBmuRyCl07f/Wap4KxmK6ii0862tZKl5vJuKLdny6ftLQpV1Bfy/RLYMtzpSS/KQf42bAdxl9xnm+AW6Y/HOJ5+e3e8b03iEeHhl7bxiVaT42/T1DQ7uVykAP+KgOxJdtJoOKptnCoeg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 12:28:50PM +0000, Pedro Falcato wrote:
> On Thu, Nov 12, 2026 at 12:18:46PM +0000, Lorenzo Stoakes (ARM) wrote:
> > On Thu, Nov 12, 2026 at 12:17:21PM +0000, Lorenzo Stoakes (ARM) wrote:
> > > On Thu, Nov 12, 2026 at 11:21:38AM +0000, Pedro Falcato wrote:
> > > > Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> > >
> > > Thanks!
> > >
> > > > > diff --git a/mm/mmap.c b/mm/mmap.c
> > > > > index 7618e72766a5..4cb18b217048 100644
> > > > > --- a/mm/mmap.c
> > > > > +++ b/mm/mmap.c
> > > > > @@ -1313,11 +1313,18 @@ void exit_mmap(struct mm_struct *mm)
> > > [ ... ]
> > > > > +	if (mm_is_oom_victim(mm))
> > > > > +		tlb_flush_mmu(&tlb);
> > > >
> > > > I see there's a different tlb_flush_mmu() call below (in the actual function).
> > > > Is tlb_flush_mmu() idempotent?
> > >
> > > No, tlb_flush_mmu() is cromulent.
>
> Naturally.
>
> >
> > (kidding, yes it's idempotent :P)
>
> Great! Thanks for the cromulent reply.

That's gracious of you to say. I'm glad it has embiggened the debate,
however serendipitously, and I can only hope it hasn't furthered the cause
of antidisestablishmentarianism.

--
Cheers, Lorenzo

