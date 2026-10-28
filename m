Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45ED2606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 09:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IQLvv5Vy
Received: by kanga.kvack.org (Postfix)
	id 497966B05B7; Wed, 28 Oct 2026 05:10:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 447CB6B05B8; Wed, 28 Oct 2026 05:10:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35D296B05B9; Wed, 28 Oct 2026 05:10:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 19B0C6B05B7
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 05:10:02 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AF5CEA0C4C
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:10:01 +0000 (UTC)
X-FDA: 85371463002.15.C7D176F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0F6E640005
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:09:59 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IQLvv5Vy;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793178600;
	b=W8i8yaY4NFc/bFukmdVEgo/F66tZ+opVp0xhl+cG7+0EQQP9423MfnF9imsnuhGqKmj5UJ
	yqHnhuCegZ3viAIk/0WYwIEXxeZrNfd/sUyGk62nnTeBZR2YIBjzSefeUinlQougpKD6MG
	d4QNAgG7dAuJjAD+CN32oMz8BKupD2k=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IQLvv5Vy;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793178600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bLZSl7G53VjRTMzaR+4ybREso2p4MLSxqwNzQhyf3As=;
	b=Hi1ZbuIHdV4daH/hIOQ4gK0oPbaUOIp7PEW9siYkb+ogy1wfF8nMXwOBI+AerXGJb79//y
	Sh+dRQov48eA5RMKKVRntfJfAPOB77yfxtmYUMV+FFfL+4AjyySY5NMAO8qkVGoVPGyfGW
	xqycDIzSD0Oa6DEBJ9P31jJhPsj22BM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7A5B1416AD;
	Wed, 28 Oct 2026 09:09:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61CEF1F01825;
	Wed, 28 Oct 2026 09:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793178598;
	bh=bLZSl7G53VjRTMzaR+4ybREso2p4MLSxqwNzQhyf3As=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IQLvv5VyEW9W822k4mht+xeLq3S4XizAu+yULPQZsw/IVShZGFw4v2DipYDdBsIDM
	 ZuO9nCZm9CpX8w5ml0a91JdjeCai4IiV9QbHxDf8RJ5flGZR1CGm3IoGtSym8UApk4
	 Csg/F36qW6LxKG3+BIRu5428gBcRYr7WkphITq9nSu15oEzQk7PBodVhHzdvwyKAsU
	 L0DDpJRkU7kCsCA8XIudNovrwViAworRTX8BBm8mzz3lW+kK0r+b10tnjOyJB2Z4jA
	 ml2WMykb/ecw+qvzqKMXuJLLemM/U4ijkpfsw/rwxPj03zXiSs2jn466I+8Fyr4hbl
	 WjWlEy8zwut6w==
Date: Wed, 28 Oct 2026 09:09:42 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Hugh Dickins <hughd@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Oscar Salvador <osalvador@suse.de>, Minchan Kim <minchan@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Gregory Price <gourry@gourry.net>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, stable@vger.kernel.org, 
	Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH 09/46] mm/rmap: handle device-exclusive entries in
 folio_referenced_one()
Message-ID: <auG7p94aT3SynuWy@gremlin>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-9-6f74bec9a5bb@kernel.org>
 <e32a19c4-76c4-40ba-83a4-781333af7b0a@arm.com>
 <f5b90920-5923-45a6-be2b-f558801781c5@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5b90920-5923-45a6-be2b-f558801781c5@kernel.org>
X-Stat-Signature: 9rjnsqgj6p8kix95usd5mx7yjgre66yo
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0F6E640005
X-Rspam-User: 
X-HE-Tag: 1793178599-120526
X-HE-Meta: U2FsdGVkX18zQTF20Ffsdq/aTOIBV4Fydf2K4sCv+5bGPX7V+5Q07kX8dMKfdNXvmFGLqsSAlO5SWAmQ9D82CNVOmUWn901vQQ8+n0ikWBG6rkuDR+FWXt1mLjWfiSjghRVDyr6jrSAYqJ90t5R+5ehVHlg/1QcT9VcNDECmCa7TVM0aniq3eCIund4OXe/GU9L+hjwgzlUDbkFarH3PKINleYNhHS+wnoncbIhFDGNoZ+DEfIimso8/L+7jAb0PGUZOg1i+31b5RaDMlGXHCHHlWQYVDcZcBaYhAKzgmiZAxDEdDmhOal3+XM0ORbx+3uSQRSfwVRiEskvKGUe5sq2Ih2dDH9WINHiTGoUjnJn+ZyYBWgflCfi08pjg+CRq7Vc8tV/E8KO3Ebo0gqTgmvMSqh7rfYJpNT8z+64S8zm3XvbuCX9Qa109zxBwuzFiE7sNB907vcfCYJPfzYpVuyiWq2ZQBnANCEtVYNIgZOZaucPCR5ntCkZJ5Hz+SfJ0i2uLiVy+SQuQrSN8VzpjEeNVQnhwZ8te5d/OC7/Vr6XS6w7FcUKLEUMlwkSaUwZuZfn/EJppKqBWkCw1r7FhMgveDaRDEiykEHUAQWdUw9Wspy1Pedyy4tyfQoEcV2JRyNwpnU/OvR+bQzIms2IkzfS3KagwqymGcolwgYZgpDChj2l5j01DQ9aEzjL9n+cjiYNsAr8RBc94kFOJIZM7fUYre7GrEblu1/knQaYslSGBtLvVJZxX9MOVi+qe5HyhiovXa6ncfMEPH9OOdmT3ufVsQ1l678nj7k643DZUoCp6E9dvZNzQIi3BKqTVKNQ90D6jKe5XL8C/wiVlveVeO1nbQc8I7YRC0v7E5y3giHn/KMeLAVo1eEPGhYmWzi+0DsOZX3ulRd48BMsUZpSaCbt04QuX9a2jp50I2CKQvozSWBUeLiWfUcScZgliEAFJKSVUr7a2DWNMqrGI0U7
 8aKYj/WK
 rvM851l+f36dVIsNVa/M5SrohLOKnG+lxlWHlZLppSPwDaJi4oOjaa6gQcCJjl/8FveQ2i2zMAvtRRpEi+I/JeajAna9Z9gEr6G+DYh/m/G5ThpoWVJMOnwMlAF9/dYXvcMK2AVjat6XdCZ/1Q3RHZYaCd6sPphW+hk4hUKGFoJbHLMdqXLx3GiB3UoPStlrUk1ZAhPUG9P3QlvIhKuAKBo2MY67iqfG0g35kB8wNq4iOBge7LG6Q+jS4X1HcZ1tuzjV4UGq40Jsrni4vY2L0+W1GI9i6uM+3IMkYQhPBOVMleVeBzbSvoHeRuNQZlzPQS/CpoLd6qFmT3Sq6Dh9VsTXzUHPWmYCFpEkFsD6CK0G4AVoMH1zLAIA3Dg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 09:08:04AM +0100, David Hildenbrand (Arm) wrote:
> >> -		if (lru_gen_enabled() && !lru_gen_switching() && pvmw.pte) {
> >> +		if (lru_gen_enabled() && !lru_gen_switching() && pvmw.pte &&
> >> +		    pte_present(pteval)) {
> >>  			if (lru_gen_look_around(&pvmw, nr))
> >>  				referenced++;
> >>  		} else if (pvmw.pte) {
> >> -			if (clear_flush_young_ptes_notify(vma, address, pvmw.pte, nr))
> >> +			bool young = false;
> >> +
> >> +			/*
> >> +			 * PFN swap PTEs, such as device-exclusive ones, that
> >
> > You mean "PFN softleaf PTEs"? Better expressed as "softleaf PTEs embedding a PFN" ...
>
> Lorenzo raised this off-list as well; I'm using the existing text we use
> elsewhere for consistency.
>
> This needs a cleanup that adjusts all of them :)

*like a proud dad of his softleaf name :P*

Yeah, agreed, not a big deal, and easier for me to just do a bigger pass
finishing off what I started :P

--
Cheers, Lorenzo

