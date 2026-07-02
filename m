Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35787C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:40:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9463A6B0101; Thu,  2 Jul 2026 20:39:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A90F6B0104; Thu,  2 Jul 2026 20:39:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7486F6B0106; Thu,  2 Jul 2026 20:39:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 366356B0101
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:39:47 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1D821140309
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 22:12:17 +0000 (UTC)
X-FDA: 84945235914.09.D5417BD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4DD58C000D
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 22:12:15 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=PxaDKhZH;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783030335;
	b=Kf1WjNiwKBhcD0xTmjhwm50o988MeFTvRTzHASnOCZzKF02kKauXhfgieKmYriDY5pz6my
	3JWZAIX0cNVM6FdBndn+VlZtdxXx5XLKB6MQ+ZwCrFr2QL80MQjnmb9rbPohBKEpQ/WAlc
	VbWxdABmfsJL9MB4tFwUpGS5/aPyNao=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783030335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DCmjtUCFw1S3nzcmZZqNW9TzABLzOKYV3/oltfEzOA8=;
	b=A4Ke2QG7PizmYJWRvqa7GQUhMMIc9LPAukvIKtlebZmjqss6SNKD7GKll9uR8lJl6IDlyV
	l2vvdd4V/bKkic20pz3RjoIlvebUcJ9PlQKMO9Mpsax8EmOrt+Wds0TNfM3/Gtt2onF46l
	QdgAAkgEACcnLqTCXDUQRqkI8yHDuLM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=PxaDKhZH;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4F4F843B82;
	Thu,  2 Jul 2026 22:12:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 266AE1F000E9;
	Thu,  2 Jul 2026 22:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783030332;
	bh=DCmjtUCFw1S3nzcmZZqNW9TzABLzOKYV3/oltfEzOA8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=PxaDKhZHHb8/akYiF3dcP6wcs0FzNBcVN6mZPm+XqDFDNSkbNHEyTT0JZ4uNjGNdQ
	 v46xV/DhfToWjaKJKUIOLYOOn7PL0731IrvOyDZu3ummeo/dBmv8SzGd8g0TBgXpWv
	 88yyCGf1i4sTd0+2Nb2SJNNLQX4vOpinMCg3yBx0=
Date: Thu, 2 Jul 2026 15:12:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: ackerleytng@google.com
Cc: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>, fvdl@google.com, jiaqiyan@google.com,
 joshua.hahnjy@gmail.com, jthoughton@google.com, mhocko@kernel.org,
 michael.roth@amd.com, pasha.tatashin@soleen.com, pbonzini@redhat.com,
 peterx@redhat.com, pratyush@kernel.org, rick.p.edgecombe@intel.com,
 rientjes@google.com, roman.gushchin@linux.dev, seanjc@google.com,
 shakeel.butt@linux.dev, shivankg@amd.com, vannapurve@google.com,
 yan.y.zhao@intel.com, Zi Yan <ziy@nvidia.com>, Matthew Brost
 <matthew.brost@intel.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park
 <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, Dan
 Williams <djbw@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/6] Open HugeTLB allocation routine for more generic
 use
Message-Id: <20260702151210.37ec63d703da9e4c5e181694@linux-foundation.org>
In-Reply-To: <20260702-hugetlb-open-up-v4-0-d53cefcccf34@google.com>
References: <20260702-hugetlb-open-up-v4-0-d53cefcccf34@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4DD58C000D
X-Stat-Signature: a981kojemobahe5zadbqq7jh8tx14pun
X-Rspam-User: 
X-HE-Tag: 1783030335-245045
X-HE-Meta: U2FsdGVkX1/qfKzAdeYI0xAISP7XxxbqDthGrPsxvu3S6ud5P8bh5AmW42VKXSKJCMT4rz9PvwjX4pQaWJMUrtjEWQWCEyD610JfTSJj0xk0qTH4mAh4UvABSV97btbSd3gKPslXyS5E7Q5WZbEYnCaSeKmQoos2w7iwV2eIRrtHbS2UwupaXRJWr2lXiUa9SDapspqRTcnHqNIpXSYrc8G5cmsZF8fiVGSdV7CDYoezEbilRLpAGUgfDTBAzi9bI/+KX81LOo/OIUYqZxnvQXbZrnvL1pj4reyMNpG2DR0jEb1FPthHOBo0tWfsW0Dj3s2J96KNjZgrh33zvdwwMISc1l7q+nFRHOcRNCm1CGJXEzayYelfBvVyTRUkWS9ElXrAczX2HKk2FRs4A+TuwcbdjHKLq2zZNZ13gD/2LGxrSNXhDRpq2Wz7tgCrg1aNEBTj0lt2ThRSt9Cqm8dUXw8sZctIyGuZkH8TxMOSroWFIlG2l9XXJ+9xccReZr08JWlFPiAwzuKESr1zwuLfkcmeEruQpk32gCRKsvaIddUVmlubOLFp08nVuZY84n9kn24ltWD5+Ky94V6kZdy2FB+USIJkxeb/+vL1U8rYN/GDN2vynTO0sa5Swf9XinabYLQ2iQNKtSOwz4Id9PN1/QwYAtv/Z7fUgzbwHgf35v7cR1gxYL7lCcEI9GtsjrUglhE9J2HltoZpyY0Oc5K45Zw58RA5h8u8L43r3n59HB/WkOMIO8MJpns6XAFugbn1eqRV4v0LuD7WWhNqENR0FKGyuRI5BEaLTjiRypwOJj5RdCse7yaSKUdQLJ/kbbTn/JunN4GxMNLWYbpDP1sZ3Y8qQBpn2DNHDcU5oX/EFrR6yUxSxgbz3JUWR78mR8JqPmP3xHaGQV9ttwwen+ZnNWtHddlIVp7cYGAMOjMgPg9KRWBcsQLO9eiTa9gVS6h9VbDj1gIBcbmDJIzehLl
 mfg8EV7v
 jN0MlW7GlKIs5HMqQATDuk2XrIDbc/tME2LH7FPPn6kWx1ReZb8+8jjojdEeUa5NAR/WaLG57T6D0YleC/xAwaNB1UIBYXUbNf2oSC9zlBfZerBKIg8yrlGkew8ElijRihMUl/w5LZRA/gx8r60yoVFvXnhSbAwtiKXQC//azKO071acDVbQbIOMU2aVmXF7q+0Q7E5Rt2D2FOR/N09s91kr8obOa+J9TqhQl65Kha0AwPupnE9YcB8d1Pj5RFxNY0CdyOPnOjN+RqxoBVcr91GxomsykIGq7aFFUQWkWTP4mXfcVNQyz4GsLBInmTzsBp6SqolJHe2RAsaDmkHHSmpAOJ1Tw9nHFizOWF1XddigorTeLxYMGCSLaH/JPqyPGHBwAdByvDRNkUiMXWjgPjWapnT+DT20stga3zQWOHrVZm58YFCtfJ5NCgcYn0/sgXg/DF/Ugo4tbWX0vR31kE2JVpHCd6N7glyVMoA6RWOF4yUq8ZT29Rl9yTw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 02 Jul 2026 09:21:44 -0700 Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org> wrote:

> Hi,
> 
> The motivation for this patch series is guest_memfd, which would like
> to use HugeTLB as a generic source of huge pages but not adopt
> HugeTLB's reservation at mmap() time.
> 
> By refactoring alloc_hugetlb_folio() and some dependent functions,
> there is now an option to allocate HugeTLB folios without providing a
> VMA. Specifically, HugeTLB allocation used to be dependent on the VMA
> to
> 
> 1. Look up reservations in the resv_map
> 2. Get mpol, stored at vma->vm_policy
> 
> This refactoring provides hugetlb_alloc_folio(), which focuses on just
> the allocation itself, and associated memory and HugeTLB charging
> (cgroups). alloc_hugetlb_folio() still handles reservations in the
> resv_map and subpools.

Thanks, I added this to mm.git's mm-new branch.

As I understand it, the entire series is code shuffling and no
functional changes are intended.

> + Addressed some of Sashiko's comments [4]. Some of the issues I didn't address
>   were pre-existing issues. Since v3 of this series Sashiko was updated to
>   actually send mails. I'd let Sashiko point them out again and then we should
>   discuss those!

Sashiko will send emails if configured to do so.  For linux-mm, that is
turned off.


https://sashiko.dev/#/patchset/20260702-hugetlb-open-up-v4-0-d53cefcccf34@google.com
says "To: None Cc: None Status: Muted", so I don't think you received
those emails (did you?).

For some reason Sashiko did flag a couple of things which it didn't
consider to be pre-existing.

