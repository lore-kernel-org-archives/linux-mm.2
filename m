Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FF74C61DB4
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 10:10:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9375A6B00AD; Tue, 25 Aug 2026 06:10:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C06C6B00AE; Tue, 25 Aug 2026 06:10:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 761AA6B00AF; Tue, 25 Aug 2026 06:10:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 53BE96B00AD
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 06:10:21 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D2C5D8037F
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 10:10:20 +0000 (UTC)
X-FDA: 85139371800.09.C67BA22
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2CAE218000A
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 10:10:19 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="hEp6Zs/b";
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787652619;
	b=kTPWueLO636OL3sZ9Dvkl+7pC1A2BhfxPzTuI4iaAJrUSLkAHLxE+7Ih6HDD+3TunsRDo7
	0+bKbKOikFL8MyyJFcrtiZjwQfPrm5+iR4jXD1GVvg/ys9rE2iMIF5Z5lYOI8RrPbHKZHS
	XxOLQoTbUCZWAXKi0dUZP2h7XToULlQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="hEp6Zs/b";
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787652619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gc/RwX49RzhXZE0sl31padjbZCQIrL/qbFqg1Am65DQ=;
	b=JpJSzs0aPNS3zq5GC+gzjls+M/NiXtXfjgtEMljIfVYNGK/2CQihVysNLCdbjXFQXhxKfG
	JXmRb8ZATPL4kYvZjZzamj9mDUGfCuim/MHIFkwgcMBDtT8oItkhptekNvBHSBl0t6BODB
	tN8gt7P50sox9Tv6zWHgviqArjVxLzM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 49C0641896;
	Tue, 25 Aug 2026 10:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A6B11F000E9;
	Tue, 25 Aug 2026 10:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787652618;
	bh=Gc/RwX49RzhXZE0sl31padjbZCQIrL/qbFqg1Am65DQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hEp6Zs/bcUGJlqDp/EbOC2DmyXKUeOwUhZg/4RPSwxt8QqXEK/FGUyACEgsNTzJXs
	 niAxA0abeMUsTL+DPw7nttWvgJ9hamdm1dpoemM/YCzolyR84Z5oHw833iKT9x4KVi
	 2M+mzEGzQMAnIuPf9s1rPxU3cDR+4JXe4G1a+nXmjh64ExcCdfE8ykSeKaJBaEnFX3
	 2wtnt+5yUjHf8Qn5utrGqHhYyfqZAJOxHpYvIejwTfxx91lXFxnrxSeoIyXGJzV1Xx
	 xMJSIfpSh//nweywTXWK1CFY7JUwOj9F10yzkQ8yAkrmBgZSr9bvnsty3+yaxomh06
	 0lwzDmRBoAeyA==
Date: Tue, 25 Aug 2026 13:10:03 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Hugh Dickins <hughd@google.com>, Jann Horn <jannh@google.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Jonathan Corbet <corbet@lwn.net>, Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Nico Pache <nico.pache@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Pedro Falcato <pfalcato@suse.de>, Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
	linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] mm/gup: move gup_can_follow_protnone() to gup.c
Message-ID: <ao1p-3no7A4Rh6K3@kernel.org>
References: <20260823-uffd-vm-flags-v1-v1-0-3086981b33cf@kernel.org>
 <20260823-uffd-vm-flags-v1-v1-1-3086981b33cf@kernel.org>
 <a4650e75-ae01-418a-b695-f8bb15c5d7db@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4650e75-ae01-418a-b695-f8bb15c5d7db@kernel.org>
X-Rspamd-Queue-Id: 2CAE218000A
X-Rspam-User: 
X-Stat-Signature: 49pb38nfry4nq7i3cca7zrmwzjeezq39
X-Rspamd-Server: rspam06
X-HE-Tag: 1787652619-588714
X-HE-Meta: U2FsdGVkX19mGq+dPvmTgArM7PH7vgltfXehMwSZwgLgqaGg/J2mXfo68kfcH7yNXlfgBGHAYudD7KSJj8DkUPfOSIo86pmVm/hgldfyOb7cqnftb9HQn0+Ts5KQJB2Q6eQdsaq6q3VRTNsA/vP8B2fCqRAbIESdF6zeD6VZCsJ2bH6ZWhOQ1dQeliMUtpwmFN1Be7szR2HHVUd/vS5ua5YHsN/NOZCYZrjUDpDS3bJzAGu59HyfA1zHcQ+Yc43K/7fVMZCQ2n+CWB+s0vbOBNkMbiulS9gr1XNJ13DWP6ZsrvCF8/4lQq9PJHWKbmwytEzgD2rPh2THeKOLoji4BYUdZEu8UgY+9cpV979hLucMjiEEnXZrS+jW0mWnsii1SBkty9O/rA+BJAh6dXAH+2M+hwiOAuug/qYi3LaizIN1RUxJtFRmAez3s9hhSIUx9muYlrwvDuuBK0LuNHv7gTSjz0zyk1dUrkxjpMgoorfBLRyDZfEOgLogTCgU8O3R12BOIpAfm0Cni4aBv7+Qs8U5bwK1APCJ0sBVUXJZ+DDcKBznaZuNzZX3Os8boBdboYFduyQsFBtK21PXIdWsQDhqd/J++BXUM8hua/scGEwtC6nfEWQag16TLT0aGJYx99jw6l7wS1/JoeaiQkDAgQjTv+1fxMyrAPEKPPYooZYdx/kCSvKDjToUhYbPKjZRjNRMo+HVWrbaaJetAAKXqcY89d/Wt9vjHuCs+egDw4Ov4D8u0VejT6U3CEoY6nlxKf89TOLHmTrzJY++UQnlaEPgmJGg5pDeU2mhnmrzvlbA1uQVi2A1oOYP9iy7RxEexDjQNUjDP16hemcaCr38QACYiBqLdVAPWNag1tpSbnyH2Aiog6v3SKo1uom0Rj5QuO2Gn5L7JSfHzrdvGxYznVctGHWFIOkI7D3UPFvCWrue4dcPH1y/k+8Bj7Ah4VZ+byEipPwPqd5D87MeACt
 L8hNLmK+
 cKI2K8tVZNtF0JQw+aD7cyVd2+jhZHRHz9G7c/+5BsoqA2+Mg2D/b3AliVMWlKqDjuDhBUhWWIEpKyus0x679oTCcabCjGsiI5z9Z7cuQmY3KhvVaC7OCIX754X45o7ulENWqgoFCwPkyRwvDIXdX2JzWIMjw57+2hhV3+0DgTAcyTD45STl1Bk5SfEscdk/b6WhGQg2ndMZmWL1M3XN7ubQfe3S5+wSNPC6cvEyUDL7kw31Ano35LN9U5Jr5YFWsRnbNSTNGgOu6Z68QgdTv3o4os7e9pu4UL3oOB6Or6be6o6pUqiZ6/q6chcMBQVKS8/gQeaguPq8idk8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 04:42:56PM +0200, David Hildenbrand (Arm) wrote:
> On 8/23/26 14:17, Mike Rapoport (Microsoft) wrote:
> > gup_can_follow_protnone() is defined in include/linux/mm.h but only used
> > by mm/gup.c.
> > 
> > First, there is no reason to have it in already gigantic header.
> 
> Once upon a time there was a user in mm/huge_memory.c, in a beautifully named
> function called follow_trans_huge_pmd().
> 
> > 
> > Next, the upcoming refactoring of userfaultfd flags will make
> > gup_can_follow_protnone() depend on userfaultfd_k.h which would cause a
> > cyclic header dependency.
> > 
> > Move gup_can_follow_protnone() to mm/gup.c.
> > 
> > No functional change.
> > 
> > Assisted-by: copilot:claude-opus-5
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> 
> 
> [...]
> 
> >  typedef int (*pte_fn_t)(pte_t *pte, unsigned long addr, void *data);
> >  extern int apply_to_page_range(struct mm_struct *mm, unsigned long address,
> >  			       unsigned long size, pte_fn_t fn, void *data);
> > diff --git a/mm/gup.c b/mm/gup.c
> > index eb898ea1ee22..500e2aa99e48 100644
> > --- a/mm/gup.c
> > +++ b/mm/gup.c
> > @@ -633,6 +633,44 @@ static struct page *no_page_table(struct vm_area_struct *vma,
> >  	return NULL;
> >  }
> >  
> > +/*
> > + * Indicates whether GUP can follow a PROT_NONE mapped page, or whether
> > + * a (NUMA hinting or userfaultfd RWP) fault is required.
> > + */
> > +static inline bool gup_can_follow_protnone(const struct vm_area_struct *vma,
> > +					   unsigned int flags)
> 
> While at it, could switch to double-tab here.

Ok.
 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> -- 
> Cheers,
> 
> David

-- 
Sincerely yours,
Mike.

