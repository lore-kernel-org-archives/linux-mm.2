Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F15AC531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 15:57:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E755A6B0098; Mon, 27 Jul 2026 11:57:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFF376B009B; Mon, 27 Jul 2026 11:57:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3C846B009E; Mon, 27 Jul 2026 11:57:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A934E6B0098
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 11:57:25 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3413514010F
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 15:57:25 +0000 (UTC)
X-FDA: 85035011250.04.BD1440E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 885B240009
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 15:57:23 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aS3LgLoe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785167843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TxIwg3k/QeB5YpM8mpnKKHWqe4ae+QJvkXRnO46mmqU=;
	b=JvmidZY/h6sDzkP4Zk74rSjF/fm2l3zFfVQiVlKVtYev8ieJ5JWcIo04XO2pev5gmtJL8r
	WTnIlymVT4av3yZZzdC0nNipwy/8dym5V3VGcjO+LFuIbjFm6gD8IgkmOcY/wcoBT7+0y1
	7Xk/OKwBsSBeN2sI9lhU4CVT6+fnTOo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aS3LgLoe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785167843;
	b=XfF7SE+D+c5GRm8VwjLenL7naYFRKCRNSKfmvqVqx0mxWz7Ela0yhVKrdiFlMxWcT0BcPR
	JWaMecQIUNEgg2X0KpUS1fn0lesCj+ybGMMeeql9u36vALsW9sm0yc8uw6Kmn+Tn4sqe1J
	xEVNcWqxcIXP9GeekGCYuIO5gIJmxHk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9C5D160008;
	Mon, 27 Jul 2026 15:57:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 610571F00A3A;
	Mon, 27 Jul 2026 15:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785167842;
	bh=TxIwg3k/QeB5YpM8mpnKKHWqe4ae+QJvkXRnO46mmqU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aS3LgLoemsT7sttTQz1bFcjtnuSJmD82qShxfwVkKEIVhwyCRQzFYrZ1BGt+oX2Ad
	 Zf/cPw46qAZ1uENRq/ddMbAK89LecqDJ3Nd4sMeOUAJ/n9cCYEr7gF8uvY/wmGkqEi
	 PmuSEGwiQlipw0ThXrzYwa+jDqQoj+bcbOCcTcwcmHibSGq1zid3nrfThmk2upJTjh
	 G1Hetwq6wII0F3cwpJrvE1YwRvjRhA/4Gg8q9NTwPKYsXDBqFCTCLb2FSEAN96lqE1
	 rq3yR6XbderfGQLXvgkBaS7Z51i7zc6vDGwxsSYeXh2GlmRQefluWQuJ1X+Kq2YG9U
	 wmDqydDlG77aA==
Date: Mon, 27 Jul 2026 16:57:01 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 00/15] mm/rmap: index MAP_PRIVATE file-backed folios
 by virt pgoff
Message-ID: <amd9QR75eLNdgNU7@lucifer>
References: <20260720-b4-scalable-cow-virt-pgoff-v2-0-2d549757a76f@kernel.org>
 <880981b5-ef79-4c9a-a8bd-7540002fcd15@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <880981b5-ef79-4c9a-a8bd-7540002fcd15@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 885B240009
X-Rspam-User: 
X-Stat-Signature: c1fp36m1bp3d6sdcxt4toiu6dwbfsejt
X-HE-Tag: 1785167843-894176
X-HE-Meta: U2FsdGVkX1+jjkjHFE5jkccZjeeYBG05vCPVZPeBtNHcHD1xAk7HaoNpqRvPVwX4cMONla9ctvwCrrG/XKdb4WS5H8fXORwHRF6PrOXCZUuWxyJExYLT7GnIQ0Zon5EbMog6IOGc+iG89Gs7tUO4+h1eWM+UQgT3ccfaAop9Ml2QZCUs4ZSrTKtSP6++sqQkj3cODXOwfPGwMGilCzuHKKQfV7taW6BmmR0LtDh2e1g+XD10PQ4Qb2XDJlrvRFGeup2wB11wZv5wpad9SDCyMteF/chjzFxFoUiUi6r8Gf7O2netN0Y6t1Yb/PWv+4khSnYR4P+NkJvPu274xCYqV8VUVoymcnw34iGf+tsEY2fqkxJ8FOWskNC4Pw8Q4qa0R+yQJMfpx+KhZp/ltjQklz0opwzxD6u96edydx7MJyOUezM/8OLkIQdfzAbzIYMuBu9EA0JBQqQ3etZ1ZA5EoTeLbW47Jlfw2JUYa2IVFsjhMbH0AUywP7X91K9Pv+8Es3rzBNWiQPzmjTa+QuSTT62NeI2FhBrvp11TEPC7va3ujwfvFHxs5XwlfhINIjvV3dPJNjFqz4rng6Q3TvsBYZzhqxhLaBYgXQmWRApM0gYMoQeDVyqYLiXtgvwxvTm7ULdGAG8aVyohvhsrUxQ3mh+zqGNmBr4n243TTbnHg7gCK36oy+8C+0Z495QWuVaCidmpBFAVXeex3c99E2Efn1ub8l3HSVG/uHSEdwlUJewjLqJksbxCHM2R4XnLxBdABZcYUdQKuMBB1FvgMtX9l/Nmfr2v5RrNRvStRDTeD6TrvIs2UPUkWF2zW5Be2e2edTQ7NU0RjktRIIrrW8XwaOtZEdF3W4AWxIpugP9HbqdSvdbaSoStkYEmDRSlZk5U8SqfgitVV4IZa9KHdoLjDMRDXbGpAGrnIUl63T1zFiR/Bh/4UQZ0EhqnAReqk4o2rzQ7E1rwbDEPQlzOA+a
 QsB4SDaD
 UfPkEPovLjE6cBn2Iaz3w3N0eK+IVun4/hI0d4NE5LLdPKzbMGIIiQ7VO1fx9ySqlTDbVRfwV5KUUPA4Ny77zcu1EKa1pFtiyMkqx0bGmdPemcKnZBOcYyAv+7X9lXmStkS9jSq1pbvPL021NEW4aACg9LMeNb9sJIgwG4B5aPhG76Rtav8pS1NqngtDLiP+BF/Ge9fWnrZxkKrOB/EOKPDKvts88f+wNC0wZccJlzMzyemtstI1XIDjlhEnuIo81OX83HMPc4LJwewTZQNhR6iYyUnmgcFsvnMGtvWBV2FRrzqa37jvzsQiadngeEGq+De4yZK0b3Dj95inx+9WryG3P9GNupwfuiGmydMpUYa+WSYutJbstvNaj5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 04:44:06PM +0200, David Hildenbrand (Arm) wrote:
> On 7/20/26 16:38, Lorenzo Stoakes (ARM) wrote:
> > In memory management we've managed to manufacture a great deal of confusion
> > around the concept of anonymous memory. We have:
> >
> > 1. 'Pure anon' memory - anonymous VMAs whose folios are anonymous and
> >    swap-backed (thus for reclaim purposes, treated as anonymous). These are
> >    simple enough.
> >
> > 2. shmem - file-backed VMAs, file-backed folios (from rmap perspective) so
> >    present in the page cache and mapped by an address_space object, but
> >    whose folios are also swap-backed (thus treated as anonymous for reclaim
> >    purposes).
> >
> > 3. MAP_PRIVATE-mapped /dev/zero - a strange beast whose VMAs have
> >    vma->vm_file set, but whose mmap_prepare callback clears vma->vm_ops to
> >    satisfy vma_is_anonymous(), which results in VMAs that were mmap()'d
> >    referencing a file, but are in every other sense anonymous, including the
> >    folios.
> >
> > 4. Other MAP_PRIVATE-file backed mappings - These possess file-backed VMAs
> >    and have file-backed folios until CoW'd, at which point those CoW'd
> >    folios are anonymous.
> >
> > This series fixes issues 3 and 4.
> >
> > In order for us to traverse VMAs using the reverse mapping, we require two
> > fields - folio->mapping and folio->index. The first tells the rmap code
> > where to look for VMAs, and the second tells it at which offset the folio
> > starts within the referenced object.
> >
> > For anonymous folios, folio->mapping points at an anon_vma object. For
> > file-backed folios, it points at an address_space. And:
> >
> > * For file-backed folios folio->index is simply the page offset of the start
> >   of the folio within the file.
> >
> > * For anonymous folios belonging to pure anon mappings, folio->index is
> >   equal to the virtual page offset of the folio.
> >
> > * For anonymous folios belonging to file-backed mappings (i.e. CoW'd folios
> >   of a MAP_PRIVATE file-backed mapping), folio->index is equal to the file
> >   page offset.
> >
> > This series establishes a new virtual page offset property of VMAs to
> > allow us to map anonymous folios at their virtual page offset, consistent
> > with pure anon.
>
> As raised off-list, I consider the "virtual page offset" concept hard to grasp.
>
> Maybe it's just me :)
>
> Skimming over the code, I read "vmg->anon_pgoff", which is pretty intuitive to
> me. Similarly vma_start_anon_pgoff() / vmg_end_anon_pgoff().
>
> Could we similarly just call this "anon_pgoff" /  "(linear) anon page index"
> even on the VMA level.

Yeah, I had originally done this.

I renamed it because I worried that people might be confused by references to
anon for file-backed VMA mappings.

But I think probably you're right that referring to it as virtual page offset
adds even more confusion vs. simply calling it anon. Will respin accordingly.


>
> IOW, in patch #9 for example:
>
> static inline pgoff_t linear_folio_page_index(const struct folio *folio,
>  					      const struct vm_area_struct *vma,
>  					      const unsigned long address)
>  {
> 	if (folio_test_anon(folio))
> +		return linear_anon_page_index(vma, address);
> +
>  	return linear_page_index(vma, address);
>  }

Ack yeah.

>
>
> Or is there another user for the the "virtual page offset" concept? I'd assume
> it's only used for anon folios (including KSM), but maybe I am missing some
> corner case.

No it was just fear of adding more confusion but seems by doing so I've done the
reverse of what I wanted :P

When I rework it if I notice anything that promotes this as a better solution
will ping otherwise will just rename on respin.

>
> --
> Cheers,
>
> David

Cheers, Lorenzo

