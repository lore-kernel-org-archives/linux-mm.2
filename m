Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEE66C88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 09:48:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACE276B009B; Thu, 17 Sep 2026 05:48:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A58586B009D; Thu, 17 Sep 2026 05:48:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91FCA6B009E; Thu, 17 Sep 2026 05:48:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 66F316B009B
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:48:32 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9266D1C1F2F
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:48:31 +0000 (UTC)
X-FDA: 85222779222.07.AB68C3A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0EE94C0008
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:48:29 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RXQbRdQb;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789638510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SSQlyaKBFOXmjTXXwb4CnAc04mzkW2ufkK1lWWnGyPE=;
	b=Eum7QnTCy5pJY06DbBcjVKCwRze8GB0Yxhw4siwU3EGiukMfixgemTMUPJdcWEyYuLKJLV
	zjrCcqNP8IgtSg7m2iDAhi1qMVwzNpQu6axV+0C185B/CQ7bL64wtB9h5+kQOZdGHrXLZi
	7k2pNRJRH/PmTEwMpqNhs/F1Q6L7iVQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RXQbRdQb;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789638510;
	b=WkIHSDohtq0uAxnn0txJSQ1yy2lb9VxptVlx1LJM93UAgBhq8zomQoX1o0AhF/MIAZY/j+
	2/sWxKKRX5G/3+NntRq1yqGCyNGt/+cqEiWAn79RNQpMLPj2lBX2FG96oIwXrHhnjpW2BS
	YFT0+hJuF18E1lifkGfBSYt0vDWpm7w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8C2CB600D4;
	Thu, 17 Sep 2026 09:48:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A58101F000FF;
	Thu, 17 Sep 2026 09:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789638509;
	bh=SSQlyaKBFOXmjTXXwb4CnAc04mzkW2ufkK1lWWnGyPE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RXQbRdQbaMBgU589o6W6PG3uphqN8mz/5BLM7kb4FOOK2HUFAR93FxbAoJTEAO8Bu
	 eBoMaio317U16mMAW0vaD84KGV27INu10hhQohZWaKuKgfSOO3qZzptjmllqY/CUt/
	 IuuDdJMQ0mKaF3URDpMUpD2v9wmA5TOXdERqKfg6G4aBNbU+E4K218mD0RumAFV1Mt
	 COnZBQ1CMqCB/u9P+dkXryFycmkanLLTAJtGqNyQEtHTufZKXMU081Bw99vgtS9b0W
	 qM4li9bj33ALeGiPbwdYhg9T2fzZ9DGvn14y4LfOgNz2xVrwZu3cOup4lJ6KfrLH9o
	 JwkgKTsO8Aq7Q==
Date: Thu, 17 Sep 2026 10:48:17 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Kiryl Shutsemau <kas@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Suren Baghdasaryan <surenb@google.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, Peter Xu <peterx@redhat.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
Subject: Re: [PATCH v2] mm: implement and use vma_anon_tracked(), silence
 KCSAN
Message-ID: <aqu3VY-PgJQYJVHz@gremlin>
References: <20260910-vma-is-faulted-v2-1-e81ebc7d146b@kernel.org>
 <aqKzUTPbh1qcKs4a@thinkstation>
 <aqgQw6moAuJYCVw8@gremlin>
 <4b2c99f6-d7c0-42a2-bf9a-e85061d53c93@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b2c99f6-d7c0-42a2-bf9a-e85061d53c93@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0EE94C0008
X-Stat-Signature: kjwjw66z6be9px91q5944tczajo3otgk
X-Rspam-User: 
X-HE-Tag: 1789638509-35879
X-HE-Meta: U2FsdGVkX1+svURHTQXZlt7uZZfAy8gQwdBEizHzBplagR/o9AE25MoGuFqnzIIXUq5p0bVZ0TSr6xSTe1Cr/eiuslUiozjjtFk0A9Tx1gNOmq9eN3cGudnledmyghL3pp96pWM4tNKzHlDhKO1mCMqiP6lR2ltSRBrUMaElXsffr9hI9270rROBRkMJxQI43vLmn3LdSPAsnVDvWsHHmfTXHzeKJ4B5Auk+RugWt/LsipciyfZBVpWR3ANDOi2nD5yXlOfDncoTmTpCKnGjEqH4+8ID3SUT9mnuaV2B0ReNgspKRpb6rsV7VvApZQc7WEpVgFWr2Yl0scW9gnjoBqSHEbdhi4sUCb1p9Dek+KdvovFl0epB53bUf1qb1r08YsrFgqhIU7pBnQQs4p5fcqhiQ3YggXJgU9NW+XrtQAxaeRRgfhM0G/wdtzvCHOZMpYXuERdjdiMK9B7IyeD/ORtpkqt2psmL0QWmQ8nynCF2/awfU4+vH6HRDzelPn7nYvia7yRPDyv4e3v9Q0DVR+mDMWIJenGdW6FD51b2PhJIuFBBIoq7ZBJviBoRYrRKZkVQzr1kinaPDCJQHdOBccUJhEZKghWrzNA3u0hbCJDaNkL0xHNLyuxqf2xWAW0tX+ESyHGhR/nUPqgR5zxueyKjVasQnfY67gfldGCQQU8hDLTZynFjkyfRtYlQdRj0WM8Z+qFH5s2HLZ6/BocEckZ0bL8JSXWtOHF+vV5ED19g2kBh2gqbDCnFEZz402b9H3nwMxeKIDMyjDKC94pkych5YFmWzZ8B0Ag/m+9NaVFF6PPtlrjBLjkoqL4B4DCUNmPzXzI1LHH2czSBscyl16qF6NPpoTiy3mzL87kniukJLzNMxDC7LL7zI/Ao/L9FaH39xsieG0xlYh7ebS+wO0h6ImTQZXk0F372WUTEJNGXso+PG3V/BL6n6GPcrw9tofR5mHotJosZ1bCrPJM
 6DjU1lN8
 eIgKP+SpzyYFs8s10dj9XqdK+tHVUJBmv+RBl231DnRBEgCDYbJYgMwJjUFNIgB1EhfVUaMT528dsIU6D6P/UIODdB4SEIgAHaCgeoDjmJESIR7wqOeH1c67lCNUbbVJIOtOHiHRKKAQc6d53A8QYkK2sxBO/DIG8kNGpBmBIlc75t2OrfmyVot+DEb+tfo4Jjfbt+4YaYjCgPnOS/vidBMONsLS3ZVWpLJu2tV7M/CXjjTLNaGyKxU4O3tJZLqthhhHAno9PPWNJMCh4+Y/PgbUqTbaN5ROGzylKXkIFvzDvSCTt+UBXsfuAIalhW+OFRFxHMcM798hhCo+4sm4fgM+nqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026 at 11:45:12AM +0200, David Hildenbrand (Arm) wrote:
> On 9/14/26 17:21, Lorenzo Stoakes (ARM) wrote:
> > On Thu, Sep 10, 2026 at 02:50:25PM +0100, Kiryl Shutsemau wrote:
> >> On Thu, Sep 10, 2026 at 02:18:35PM +0100, Lorenzo Stoakes (ARM) wrote:
> >>> Provide a function to abstract the common task of checking whether
> >>> a VMA is faulted in or not.
> >>>
> >>> A VMA or mmap lock must be held when calling this function. For an attached
> >>> VMA the transitions between unfaulted/faulted state are:
> >>>
> >>>        Transition        |              VMA/mmap Lock state
> >>>  ------------------------|-----------------------------------------------
> >>>    unfaulted to faulted  | write lock OR read lock + mm->page_table_lock
> >>>    faulted to unfaulted  | write lock
> >>>
> >>> So vma_anon_tracked() never provides a false positive (the lock precludes
> >>> it), but if only a read lock is held, a negative result must be re-checked
> >>> with mm->page_table_lock held.
> >>>
> >>> Detached VMAs cannot be concurrently manipulated as they are removed from
> >>> the maple tree so require no guarantees.
> >>>
> >>> Use data_race() to silence KCSAN about non-existent data races between
> >>> concurrent vma->anon_vma read/write on optimistic fault tests.
> >>>
> >>> Also while here, const-ify vma_is_attached(), vma_assert_stabilised() and
> >>> dependants.
> >>
> >> If you end up respinning anyway, this would be a natural separate
> >> prep patch.
> >
> > Yup will do, Pedro also asked for this!
> >
> >>
> >>> Finally, update the core VMA merge/split, rmap, mremap, KSM and fault
> >>> preparation callers which test vma->anon_vma directly to use
> >>> vma_anon_tracked() instead.
> >>>
> >>> Note that the lockless read in reusable_anon_vma() is doing more than
> >>> checking whether the VMA is faulted - it is returning the anon_vma to be
> >>> used on fault, so this check is not altered.
> >>>
> >>> There is one odd one out - file_backed_vma_is_retractable() - which holds
> >>> neither a VMA nor mmap lock and is stabilised by the file rmap lock only.
> >>>
> >>> Therefore just add a comment to explain why the direct vma->anon_vma check
> >>> is required.
> >>>
> >>> Reported-by: Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
> >>> Closes: https://lore.kernel.org/all/20260829100034.423064-1-trintaeoitogc@gmail.com/
> >>> Closes: https://lore.kernel.org/all/20260909115723.528501-1-trintaeoitogc@gmail.com/
> >>> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> >>> ---
> >>> v2:
> >>> - Renamed vma_is_faulted() to vma_anon_tracked() as per David.
> >>
> >> I don't particularly like vma_anon_tracked(), but naming is hard...
> >
> > Yeah it was a compromise because David and I disagreed on naming (again ;)
> >
> > I think vma_has_anon_rmap() is a better compromise?
>
> Yeah let's go for that.

Ack will do thanks!

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

