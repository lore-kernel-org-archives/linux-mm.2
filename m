Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05ED1C5CFCF
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 08:41:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB5AF6B007B; Tue, 11 Aug 2026 04:41:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E66716B008A; Tue, 11 Aug 2026 04:41:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D54536B008C; Tue, 11 Aug 2026 04:41:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AA74B6B007B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 04:41:29 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9381C1C0FFD
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 08:41:27 +0000 (UTC)
X-FDA: 85088344614.13.ADE8E74
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 025864000B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 08:41:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HneO5wKc;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786437686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B9oyw8VGrdnmKGUbtduBgbxCRdwpvdeLqgkhrCXDNKQ=;
	b=zUh2ffPdujseIX15scjtukQhf6IacwdRFCbePdSRPlL35SSOMWUPPUxpA5i4Me2l82VQDd
	5Nf3ql7r6AMaPmblfEBrkNNbhALgiqOUo/1Tejd02PzFdSihc9Fz7PeA12VceFLweNRiEb
	J/LdlnFCuupmyoRZ9kyIzW34kSD389Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786437686;
	b=FAcv8V2+ZChqrgdhjgUxvOIlckWCfDTlU/a5BztnMYXHYG5NKgJ/G6/jLiYYs/A0Adodle
	DAkSKkhGVo01TvX/0XgxFsrvHIH3JjsQX/lPNuetR0zkLePzl9K5ElnmEk6LDf5WGuuzfS
	c3BRl5C/Db19VWY2zKieSxs6xZ9vgmk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HneO5wKc;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 747C9600AF;
	Tue, 11 Aug 2026 08:41:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B8E21F000E9;
	Tue, 11 Aug 2026 08:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786437685;
	bh=B9oyw8VGrdnmKGUbtduBgbxCRdwpvdeLqgkhrCXDNKQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HneO5wKcZdSzCZgiPL7O6y0hkp8NxpOysOwjQ1/0p5DZJDgbHmr8oIIto+qbUqUP8
	 QSncbqQais7NDR31QFmgQ7SJeueG1RlsaCn/ugXce/uqztMKctFvKx1+vcfyXCvqNZ
	 VJEHlmRInootV9fshr8tYk5LG1afiv/E+UOYl58uNgPRApc4UGU+ngmdh3PqQBdarD
	 Za9aH05yjKoWK0cBkN69Xhhb9cMAk62gCUKpXkd+IC3tlRx4y1qZ5QJ3SYz3eWJwWJ
	 /V1P5kbBwkgzwAFtJUA4uuFpLGZnK495BJYq41HQc15Y/yGaMH9StOXlfO1t3CLsMy
	 Wo0bc8EiRjuEw==
Date: Tue, 11 Aug 2026 09:40:50 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, 
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
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Alex Deucher <alexander.deucher@amd.com>, 
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	Boris Brezillon <boris.brezillon@collabora.com>, Steven Price <steven.price@arm.com>, 
	Liviu Dudau <liviu.dudau@arm.com>, Huang Rui <ray.huang@amd.com>, 
	Matthew Auld <matthew.auld@intel.com>, 
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, James Clark <james.clark@linaro.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, 
	linux-s390@vger.kernel.org, amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	intel-xe@lists.freedesktop.org, linux-perf-users@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v4 02/20] mm: provide vma_[flags_]is_cow_mapping() and
 remove is_cow_mapping()
Message-ID: <anrfA56ZIL7QQqvk@lucifer>
References: <20260806-b4-scalable-cow-virt-pgoff-v4-0-ab318a350404@kernel.org>
 <20260806-b4-scalable-cow-virt-pgoff-v4-2-ab318a350404@kernel.org>
 <ann-vS6MYT9kuXqu@lucifer>
 <20260810151007.c1cfbcf46d498d2f8ce566f9@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810151007.c1cfbcf46d498d2f8ce566f9@linux-foundation.org>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: utkyax1eq1bue8z64pgxi5q7onffbzgj
X-Rspamd-Queue-Id: 025864000B
X-HE-Tag: 1786437685-197516
X-HE-Meta: U2FsdGVkX19J6FMuEZKYtO6P/kC2/+ysKAZh50S120f5Z/QPxh6iKgccwnXAHZ3y2ixH8aaJK7+WmeMKqS4vrBsgJnhfH+1IdAeoXm5eIdXAeKKON4j5Rb67gHuzQhPqgg2pirRgGcyAXOR4orEf/ebduDMFefEY/ZeNVyrDEZupMFZiUsiTm4IHKnj/7txvLtgBRkn+vnqdUkc9p6lQ2FO0Rz9Z25zscUuQoQphGt0HsBkUaRQkms1QBUhK79hgMkFGOduWLwVd+pOIvUYE+k1LuA6VNXz9JLQPdJ3Y9XO9J16lFjhfqtCT27Xe2E0pEw0d4n0aJjORVSJiw48bPyqkUGEilotq9WA0NPj9tYQoEa6iijS97vsPfnzba3IIAunRva4065v2aFBtDlnEvT4zFM+txQY+qW1RtRJXWh2aQHl2WZxKCHfNlRAFUT5SrwFwyWea04xSbMIEd0hxSozXO+4KqzD7zpZujzmvIKWtO26a2BLkbLQpO4nhjqmiYhb+ZRwooOZZp1YAr9sy+8JfN5RbaoPMqmXf4I9NzM8Tmht28Og+x/uPg1TS9J1An/A00mhd6eI/1h8fTGpxBeLH0Ctwn82fzn7enc64Mrk9fLeyF7s+dT806rK1HZNp6FHpMCzVvRz8wil/HQeiBr+CESvoh3WI0CaLUOOS9Wp35UdD8YbLYYokrpAXfFWEAKwlbdujclbROHI1u7amWf9tBSWxiHQFkQTgJ42hKyIiCILy3pVS+3bCXSqPkdWAHH/oyTrqBHAZ/sz3eTszPHSzzfOSXgQAl94w+T5DZGo0MB/3eHq4B0E76NwWRbOCq4+xodwsrgJv3S1eHEY+BqTkaMQg36Q3SmtD7dEx8abGsPbUIJ5sYmG9IHGHhXPnGatUxaXfqzC5VIBv0i94nIWIAwcYw1WnsgFKbFMELUB1JDLkEp12sR2SdFWYgtQEnnghtHTR3G6Yts35uaP
 Sz0NtZMR
 nUFdhgX7BtERcJKzPYSMS4wKJw5jHPYSxTfOZKVjtElx3iD/ZY/p403TDK8WJ+tkNb58EXR/xsrU5e5ViEAQJlEQCOA0yBeBPY6Dfgc3jEsr2EZ3WMBYykBwTOWGVafiARazRIrlxlPbPmSlHB9jQ/EcYvlta/KOAsT8IX0JaMRfW9PHmNvEQuCzEPLAxJJUBET8uEx1uEdWVjF6u58iOdeBSYi3WKqECWSnodBXfAAz5UxMtWbTzzKxqb3DymWpVC6xoxKPiytV91l3F7QAdBq/HSH67wSLVaXj2+Dx3oLVcxRe4J+/0iHrtg7EP2UiPZFKvnezNGzfb09ynOEtHSFCVbo8K89usM97/Huoa4podyKBUOOy+gelowOMi81eZeYwGIw+kKu+CWqVyurc5YE2sP1oeqrM4EdVZRY4e0QZV19AoYPyuvYXjHKastb3ui2WxkP97+TowPoY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 03:10:07PM -0700, Andrew Morton wrote:
> On Mon, 10 Aug 2026 18:59:34 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:
>
> > Hi Andrew - would it be possible to insert the comments added below? Trying
> > to avoid a respin if possible :)
>
> np, like this?

Great thanks!

Just one minor edit below (being pedantic here but kinda what the comment
needs I think :)

>
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping-fix
> Date: Mon Aug 10 03:07:02 PM PDT 2026
>
> add comments, per Lorenzo
>
> Link: https://lore.kernel.org/ann-vS6MYT9kuXqu@lucifer
> Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  include/linux/mm.h |   57 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 57 insertions(+)
>
> --- a/include/linux/mm.h~mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping-fix
> +++ a/include/linux/mm.h
> @@ -2271,17 +2271,74 @@ void unpin_user_pages(struct page **page
>  void unpin_user_folio(struct folio *folio, unsigned long npages);
>  void unpin_folios(struct folio **folios, unsigned long nfolios);
>
> +/**
> + * vma_flags_is_cow_mapping() - Do these VMA flags imply a CoW mapping?
> + * @flags: The VMA flags to check.
> + *
> + * Mappings which could be CoW'd (subject to Copy-On-Write faults) are
> + * described as CoW mappings.
> + *
> + * All mappings backed by anonymous folios (all anonymous mappings and most
> + * MAP_PRIVATE-file backed ranges) are CoW mappings.
> + *
> + * All other mappings (including all writable MAP_SHARED mappings) are
> + * non-CoW.

I ummed and ahhed over how to put this but now I think this could cause
confusion so could you replace the paragraph with:

 * All other mappings (including all MAP_SHARED mappings) are non-CoW.

It's _all_ MAP_SHARED mappings not just writable, I thought people would
automatically assume read-only wasn't included plus drivers could in theory
do crazy things (I have a pending series to fix that though) but it's
clearer just to say all.

> + *
> + * The criteria are !VMA_SHARED_BIT, VMA_MAYWRITE_BIT.
> + *
> + * VMA_MAYWRITE_BIT is checked instead of VMA_WRITE_BIT to account for both
> + * future mprotect() calls which can render a read-only mapping writable, and
> + * GUP with FOLL_FORCE (e.g. ptrace) which can CoW a read-only mapping.
> + *
> + * - No anonymous mapping can ever clear VMA_MAYWRITE_BIT.
> + *
> + * - Writes to anonymous mappings do not immediately result in CoW faults but
> + *   may do so after the process is forked or if a read is followed by a
> + *   write.
> + *
> + * - Writes to MAP_PRIVATE file-backed mappings result in CoW faults and may
> + *   do so again after fork.
> + *
> + * - MAP_SHARED mappings of a file opened read-only are transformed into
> + *   VMA_MAYSHARE_BIT, !VMA_SHARED_BIT, !VMA_MAYWRITE_BIT mappings, so remain
> + *   non-CoW.
> + *
> + * - Drivers may clear VMA_MAYWRITE_BIT but do so at mmap() time and cannot
> + *   mark themselves anonymous. Having cleared this flag it is not valid for
> + *   them to leave the VMA_WRITE_BIT flag set.
> + *
> + * As a consequence, the anonymous reverse mapping only tracks CoW mappings.
> + *
> + * Returns: true if the flags indicate a CoW mapping, otherwise false.
> + */
>  static inline bool vma_flags_is_cow_mapping(const vma_flags_t *flags)
>  {
>  	return vma_flags_test(flags, VMA_MAYWRITE_BIT) &&
>  		!vma_flags_test(flags, VMA_SHARED_BIT);
>  }
>
> +/**
> + * vma_is_cow_mapping() - Is this VMA a CoW mapping?
> + * @desc: The VMA to check.
> + *
> + * See vma_flags_is_cow_mapping() for details.
> + *
> + * Returns: true if the VMA is a CoW mapping, otherwise false.
> + */
>  static inline bool vma_is_cow_mapping(const struct vm_area_struct *vma)
>  {
>  	return vma_flags_is_cow_mapping(&vma->flags);
>  }
>
> +/**
> + * vma_desc_is_cow_mapping() - Is this VMA descriptor a CoW mapping?
> + * @desc: The VMA descriptor to check.
> + *
> + * See vma_flags_is_cow_mapping() for details.
> + *
> + * Returns: true if the VMA descriptor describes a CoW mapping, otherwise
> + * false.
> + */
>  static inline bool vma_desc_is_cow_mapping(struct vm_area_desc *desc)
>  {
>  	return vma_flags_is_cow_mapping(&desc->vma_flags);
> _
>

--
Cheers, Lorenzo

