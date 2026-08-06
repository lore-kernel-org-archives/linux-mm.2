Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49AB2C56205
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 17:19:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 173A46B007B; Thu,  6 Aug 2026 13:19:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14BEA6B0088; Thu,  6 Aug 2026 13:19:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 062ED6B008A; Thu,  6 Aug 2026 13:19:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CD0A96B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 13:19:05 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 338BC16014D
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 17:19:05 +0000 (UTC)
X-FDA: 85071505050.08.427899F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8CC0380013
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 17:19:03 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OzMqYvoc;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786036743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9DtZb8DjUtisjREwEwWOkrSi6943Av38G03foEcQ5Cs=;
	b=lNurZRR3/Ek8J3EJOYP2Ew5VdjZyprejwl99kybcjQhTsT7e0meJnbwdULumgWchoZsUGa
	rfHCrwJrKSD7mzVAdd7NdjJ7X9O75VfUFuqkmmGezeAqdHl6faC0H0g0najp1uNUMunTLm
	FAVt95bbSew0V7Eevrwnk9s2tost6As=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OzMqYvoc;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786036743;
	b=4WThnT7r4XAdGoJOBANU14PUa5LmHiMDlBoGuk4+BpUtbcOW9yhiGkq3Bxr234Or4J0xTi
	pZeRy7se2ZS9cbFfw6zN7I999WReAes6tTMMA0kzqlGZ0hEHHpL+LFHK0wghELhzYQ0MbD
	vb+IDCnR9cLYUY4yrWtwP5Lbp/E8LBQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DD40B60AB0;
	Thu,  6 Aug 2026 17:19:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68EC81F000E9;
	Thu,  6 Aug 2026 17:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786036742;
	bh=9DtZb8DjUtisjREwEwWOkrSi6943Av38G03foEcQ5Cs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OzMqYvocxdfGC7/3077EFSOTpCiRyY/S///tKrAxuNSNHDGT7dYqW/ifw8C53hn08
	 bVPveNzCLYASrmi+XIBsRC5dHYyKhvnEgJ7RRYM5UaDV2ShMS3HdHOIYQxzooWczah
	 uJw3asizLGfuGO0yG4jMJvfxju5LTC8IkCj46t6HOZDaVyvG5nQFIzKvISEBW15ZX/
	 XVDkGY27+aumRkGCpa8T3TIyVNkiUEcqPO4IdulUjKtvDy+9OeQO2FwYjVdee+3WqU
	 ZXTOdK03H0E2NO+41f1dG8ICvMjqi5euq978ibaYowC2NC86ibx4uWtEdZmVVaYLX7
	 cxKyb9XkgRFWQ==
Date: Thu, 6 Aug 2026 18:18:38 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Gregory Price <gourry@gourry.net>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Jan Kara <jack@suse.cz>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Peter Xu <peterx@redhat.com>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 04/15] mm: update print_bad_page_map() to show
 anonymous page index
Message-ID: <anTAk9V9ceYq1jyt@lucifer>
References: <20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org>
 <20260729-b4-scalable-cow-virt-pgoff-v3-4-e8ecfefea812@kernel.org>
 <amrvgjPNfKqWPUU0@gourry-fedora-PF4VCD3F>
 <fec1be38-406d-4656-95eb-048729afec40@kernel.org>
 <anBqV9z6hVLIqoIn@lucifer>
 <anL0LEhb_bp_uQ1J@gourry-fedora-PF4VCD3F>
 <anL7eZcHnM5mPr_T@lucifer>
 <anS8UbQF1aE70gus@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anS8UbQF1aE70gus@casper.infradead.org>
X-Stat-Signature: gzo6zkb61b35him7wbwibqqdad8gsfth
X-Rspamd-Queue-Id: 8CC0380013
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786036743-240406
X-HE-Meta: U2FsdGVkX1+S2MVgn5JOZnNdek37B5zMgrRLuxF9+UHWpCBAHbjuTu8DN9JzFMfp61NEIHzce3WGA46fb59CNpPlQ3I3H8fHkGB9ulBuUTFvQqow11mUfgjx8MSGI4/sNcHaP14tQ6FxPLI0u3wkF7PH/mo65SwjrAD74qYyaMXnw+i2jXuXSxJZDqLxMXD3iAGjlvZzj41gJuO65Salbdjv7CMea88Lb7bXxTWt2bb4JEgWIrJz3XcggJ4kO3MOE4bts9YHUy9vUnwu1dOFyv+kS2L569jPuebku9CaatuPZe1raQwJmDOdjnIu2vzaD0eGXoKNkq6sIdIHQKNbSGxO67fq+d2nqH1T1SMuRZc7O6qzLYqOCuvody61twDUoSJ/dZhTRvcB8obnvAuGiWtWj5RbqdMKC6MBaIFvg2r72ITN3zrLltqW0jeQkZ5MvhtXe5meeGw3RrY/WkgDl0Eh2j8Uzn74PLYKsDFWlHcvksLqetK34ZnXwbNqwdZdiW25Ww9+xAa8Ewn76K0gK1Vn9gvtwd8ahvbJlqsw8KXBB4lTucAI4Bp/DLca5W2l4RebnIT+JId3rW/l4yLEbA1Lz8v/UfYZ7jG/lAixE3jjzbgvapygQkgKWS9McI/ab1jcZ7ImOlTkcuSpY/tv1S1kkhSp8JRPs6V3sBwRuFMP8qIIYLPc6PgHhU9v5jOfRRS5GOrKqel4fhrmmqlwYAf9A8TXDS1BSWz9mp0puiIly38dos+QN3tD+swvIOlBy0mJX1McDiDVN2pa7ctyXD7yusYHKOetoEGegMnRbFbFDogpFykUS0wyKm/X6lv1yg1KGtPi1TH389D4pHvTIlXzCCIDa8vXL307KQTepNBwlVPnyk3qp6CQol/b9CLy5CX0zFqdEj8U+gO4bPmMZPTOBnkjmLPSO5gywWV8iMLmwwi5FjviQEhiBO0rq9aqIp19Jw9SR7RUcB5nbpN
 ctnqexNn
 DazMmbe9YNsVbSjIS7orCbfspqUwuuMDTvEbeDJ8CtQKvmozgHQxuL3msz38RSkC5d08N7ephVraDOJDJ6qB2E+++rIKALMwWSmjx00G/NEKda3v01Z+fYq4YCKj/CrVnxVLAz/X332LjUQyN9u9fubkwZUAvMdtEogYP9Q5kjK2ikgaSD1LI6tCUVto/KU58SMtJDeHPiDg+ubzgdYvLpD/1pqsiBQJKHymQGis6KtNv0CKkpz061vYV/QFnPOsZs1Oi3UHIvdA5siHM8OlOz5P1Mjy0QPxrobZWizHYSgKk63XVWeSuDFJWL9UL0qP0idBIzm1PszVV8P7MFGpMZ705voviKd9u8vUd2pNWKDoozHUtGJsvG8TVwA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 05:54:41PM +0100, Matthew Wilcox wrote:
> On Wed, Aug 05, 2026 at 10:01:43AM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Wed, Aug 05, 2026 at 04:30:18AM -0400, Gregory Price wrote:
> > > Yeah just an F/A in the print I suppose.  Sorry if that was unclear.
> > >
> > > If it saves someone the head-scratch of whether some bug is because it's
> > > "file" or "true anon", given the ambiguity here, seems like maybe useful
> > > debug information.
> >
> > Yeah will do on respin I think actually!
> >
> > I do think not providing that could result in some confusion like 'hm I
> > thought this was file-backed'.
>
> not sure it would.  Look at the whole thing:
>
>         pr_alert("BUG: Bad page map in process %s  %s:%08llx", current->comm,
>                  pgtable_level_to_str(level), entry);
>         __print_bad_page_map_pgtable(vma->vm_mm, addr);
>         if (page)
>                 dump_page(page, "bad page map");
>         pr_alert("addr:%px vm_flags:%08lx anon_vma:%px mapping:%px index:%lx\n",
>                  (void *)addr, vma->vm_flags, vma->anon_vma, mapping, index);
>         pr_alert("file:%pD fault:%ps mmap:%ps mmap_prepare: %ps read_folio:%ps\n",
>                  vma->vm_file,
>                  vma->vm_ops ? vma->vm_ops->fault : NULL,
>                  vma->vm_file ? vma->vm_file->f_op->mmap : NULL,
>                  vma->vm_file ? vma->vm_file->f_op->mmap_prepare : NULL,
>                  mapping ? mapping->a_ops->read_folio : NULL);
>
> even if we don't have 'page' and thus dump_page() won't tell us
> anything, we look at mapping (NULL means true-anon, non-NULL means
> file, possibly COW).

Ohhhh ok. But you still can't tell whether what's actually mapped in a
MAP_PRIVATE file-backed mapping.

So I still think giving separate anon and file indexes is useful for debugging
purposes in that case because you might be debugging an rmap thing and the
ranges of linear indexes might be handy.

>
> > (We've made our lives hard with varying definitions of 'anon'
> > also... [shmem being 'anon in page cache' is especially lol] so it's
> > already confusing but there we go :)
>
> Woah, woah, woah.  Do *not* think of shmem as being anon-in-page-cache.
> shmem is a filesystem that happens to use swap to store its backing
> file.  I dislike a number of things about how it's implemented, but
> describing it as anon-in-page-cache is furthering the confusion.

I am not sure 'file system that happens to use swap to back it' is that much
clearer ;)

But that _at least_ uses different terminology and swap-backed is pretty clear.

But :)

Functionally it's PG_swapbacked and !folio_test_anon() and nothing calls
it anon, except... well reclaim! Which gates on folio_test_swapbacked() for the
'anon' LRU and refers to it as anon throughout vmscan.c...

My point here was we made our lives difficult with naming and yeah we do. We so
so do.

--
Cheers, Lorenzo

