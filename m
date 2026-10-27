Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7CA560A260B
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 12:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=RBTg/FKM
Received: by kanga.kvack.org (Postfix)
	id AEAB46B06D4; Tue, 27 Oct 2026 08:13:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9B0F6B06E5; Tue, 27 Oct 2026 08:13:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 962ED6B06E6; Tue, 27 Oct 2026 08:13:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 70CB36B06D4
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:13:36 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F2155409D7
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:13:35 +0000 (UTC)
X-FDA: 85368296790.26.573967D
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf14.hostedemail.com (Postfix) with ESMTP id C5607100005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:13:33 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b="RBTg/FKM";
	spf=pass (imf14.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793103214;
	b=jeAvx8+hhTWzzV7GTJ4ZF2k44NnuAobQnj8pWY/lQRnfH0/JLiYGvHkrSSygcrVII+22kJ
	Blu0QBuJkHBgKl2vOr0n5/edLMMPUGNzDDMyzcvPdsD1GCYVdxo0JCpbaLW4q60jcJfdU+
	RU5YgWvpYrnlPxi30R3+qDYW0EDE38I=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b="RBTg/FKM";
	spf=pass (imf14.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793103214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UqgubOSrlWvHKhI1cqoT/fdRktbJuQr2VeGa7H2doB0=;
	b=x6/uIbeDGHCiNLUR5iYXdnxWlPW/GQTQWhHwD6+UiM0hjyq+LewDfMDRsq5NyWtIDYZ3Bs
	sJ7Q2FQjQ4ZaHoD9aB1iaZlZCThe1Rk1OA+w8d1EnmRSKS4KMPXf1eAeNKSVPoavJ06YzL
	ivgGxu3TCUB86E/QHnZ9o6UdkJFW41I=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=UqgubOSrlWvHKhI1cqoT/fdRktbJuQr2VeGa7H2doB0=; b=RBTg/FKMjiMJhvBeWjtZ6CZIY9
	rvPo1ckUCe6w+h0QiGzd+6cZ2SX9h4XjdR9cge27tpZKPnYIX66xu0ynCGVEVN17tU71OKLzHYeUd
	YqLq2zAJnig/4jV33IsJ4SPBSdrisjLfFdiJlsjpW5dPMWCs+MvV7MeJYcTUbpvu4bgIGirMrhNRT
	rfQtF87hxPbl4GLZG512PZKdcraOJ9bUOs97wFlIO/vsRNJjr0Xeic51ZjNa4hLcU1g1mU3TtvmU/
	TMvXw7zT4HnYQe+O4c+SJwwIKJjffebWKGrSbkUjU7VknhliRZuEvq3AGqvm5+9EA7IZvX/8NaQPB
	FB/pcf5A==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xLg3R-0000000EufN-04F8;
	Tue, 27 Oct 2026 12:13:25 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 9C1633014C0; Tue, 27 Oct 2026 13:13:23 +0100 (CET)
Date: Tue, 27 Oct 2026 13:13:23 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Matthew Wilcox <willy@infradead.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Frank van der Linden <fvdl@google.com>,
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>, Baoquan He <bhe@redhat.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	kernel-team@meta.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	loongarch@lists.linux.dev, linux-riscv@lists.infradead.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCHv7 13/18] mm: Drop fake head checks
Message-ID: <20261027121323.GO2668564@noisy.programming.kicks-ass.net>
References: <20260227194302.274384-1-kas@kernel.org>
 <20260227194302.274384-14-kas@kernel.org>
 <ebc7bde1-f52e-4da8-b16f-822d6c0a4d74@kernel.org>
 <at_f43oDv73y-t7O@thinkstation>
 <f97a8d33-50b2-4a86-8381-ee840cdfa2f9@kernel.org>
 <20261027110028.GH2668564@noisy.programming.kicks-ass.net>
 <auCKv_omLGRc6wv2@thinkstation>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auCKv_omLGRc6wv2@thinkstation>
X-Stat-Signature: ko1wz7kajdge58xabaue3j5a6oh3m7j1
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C5607100005
X-Rspam-User: 
X-HE-Tag: 1793103213-210022
X-HE-Meta: U2FsdGVkX1+4+lviDqhxAg9+JbCT5JU9uNKkgQakmY2nkjT9yuv1QqqykDr5LuKUTrtWQuGF23r80yRu2FXUft5ITA64RctzUeNmD0+BIxx5X/TIRQcmIfgrKN0OAbxLDAYlD6dongh42VyHjtLTRIUhoQvUfKj6eqLCSsuu9JxOlPTPGyDeR7rTfYY/y9vclTpqzPIfHJ90pEjJak7VM3EStKbu45dOPlJgv78OHtDfjdS8sQIu4fk1WUyr6/ay5COzR2ejrdsKgCmkLSP2Xh1OpGB/Xpz0U6orp1G1Muw3nD1JJGh5RMiZFV411Z5hsy2j0gc/VUa9j585Txq229+rjGCM6+CcYw1AtBfCKpkvnwxJYLzbd7FCwbGZ8zgTN0wplrYl5yES9tfgCcNiwAjuZoEGLDvVh4p9KqIvrFodWLx0J5FkBlL3nefgxqvUuvdnHl7Yim1pLolwz2b/JsmH0sDuYahD/IWdmJAVyxfDGvhSGJ1WYSi5LiFHDRHBBp5FuH5gKM3EXVojiCFqKJsQS9ET2bwPZzFD3+YbzdVP0mH6y70e8V5Zao2qypq8E/Au0at4Z51tUp7VIfTIAlj32vbzZyC7bwhgZkbueeiwMxZBoD/11Tor0/4y34v2tYEvRA0wHtAi/hO9neOXJzZ/1Y9n07uJrVCF+joDNqWcEs3EfLgBaGAnN41Qso+w4ba8WolwZNw3QsrfnipC/6B11JJw1aHMZgPBUBUtBjgi44ab56YKsb/VTz/DbaRy+Y1KtDt/a9OYqe3K/9IRifiz4Zq4PzJCOujyGdNiMNTwtPvtpwYMlyjoXW6lyssOZxgPeskSrIigti6I0B0JKRWus6MvIAYBWRQYh3f6//x/i3gv6NqFJPjAul0wkDTG3kLJQZq55ftvUXxJxAEmumTOvoFC3/LG5On+AAe5EGUSG4ThlCsDeOcmMVqFPsbQ70Cq2f2Y3vSyLHJXaiJ
 E+zfJi+c
 XyX03Dm2JqfDkEUo2ky3W6gdxQyehYyg6cZZv2/w/sgyNY3sklh3GEQhUcf3FLTSqCP3THmjg8FEa4RjgAGRYdBIvLr24x+lJP4NWUYSsAHI0xugjlrFhl3xrOtuarHHjOw6ylTJXQMffzk6wiPpEzU6h0etqdUQG53Lek9oERAYhNahIeJbThIFzyM0rKfQKrKDLhH15bXK6xjk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 12:00:47PM +0000, Kiryl Shutsemau wrote:

> Fair enough. Here's some context.
> 
> HVO (HugeTLB Vmemmap Optimization) frees most of the memmap of a hugetlb
> folio by remapping the struct pages after the first vmemmap page to a
> shared page, mapped read-only.
> 
> Every lockless get of a page reference (e.g. page cache lookup, PFN
> scanners) relies on page_ref_add_unless_zero(), which is
> atomic_add_unless(&page->_refcount, nr, 0).
> 
> The page can be freed and reused between finding it and the get; the
> zero refcount is what makes the get fail. The race:
> 
>   lockless get                        other CPU
>   c = atomic_read(&page->_refcount)
>   c != 0
>                                       page freed
>                                       page allocated as a hugetlb tail
>                                       HVO remaps it read-only
>   try_cmpxchg(&page->_refcount, &c, c + nr)
>     -> write fault on read-only vmemmap

I missed a little something here; page->_refcount is in the page-frame;
how does the page itself being RO affect this?


