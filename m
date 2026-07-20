Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 995F9C4452A
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 13:46:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 575676B0088; Mon, 20 Jul 2026 09:46:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 525D66B008A; Mon, 20 Jul 2026 09:46:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 414326B008C; Mon, 20 Jul 2026 09:46:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1394C6B0088
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:46:04 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9E90A140197
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 13:46:03 +0000 (UTC)
X-FDA: 85009278606.22.23D6456
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 039CBC0010
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 13:46:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="FEZ/VcLn";
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784555162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mtsGfv0qZo8eE+b6wV0mg1potj8D90YUibrQdPUxUuE=;
	b=odOuO1dtHTYEr5iivVT0SW5yEsLL0b6JXA/E34hzTZhFfb+fw0b1sKTQKjj5/sgaoIZTCb
	SFDvHOCWHNClY1bn5wE407L9aBTPNzmu8THtU7PSMwculKdaHOFPEin18+t4oecxpchKU8
	qfm7TaDFWlakizifDWiT/pyyaPnrcnY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784555162;
	b=5z34dmzy14c8gb/MdVlAgtZGqOi1fBR60Wn4Zjg+DdVmRM2iCkNBh5+0pA+vzVQl6g55+x
	K1kmfQpy/kNkYqtsZ9sX4ryAJlcozF2BCAccz04HvdBTMF+3MmJ9xrxkQNBzXHj5N7bfJe
	UPlv+Plv1BZHHHbqlHUEZZcApQZ5Qvk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="FEZ/VcLn";
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6F88560A8C;
	Mon, 20 Jul 2026 13:46:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA0001F000E9;
	Mon, 20 Jul 2026 13:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784555161;
	bh=mtsGfv0qZo8eE+b6wV0mg1potj8D90YUibrQdPUxUuE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FEZ/VcLnT0A7eMkVOjqoltnaWxaLQzMGlXqa68s0cMd8wgtcFQS07Sk+oKGtBEu9t
	 Yszn6sQNStr+J3MBNvAZtgx3U7nA2B1wG/hx6rh6MvbKKxUOwxxoB7voevnsZXvare
	 4ARLE8P4AoB5CuR+V0N1sj8Bnt0U4dGXsY1TT2S3eUOG4/oduebt4tadZkXMhJh8V7
	 eSzKXW8uQ4UZw2T/XpOAfbaTT2SjTXnFTuwPXDksb5g+VURDvdFDGpKk9xwezeJoBx
	 9214spBP3MDSR6Hm597U+mFiV+Lxaw4okAfNWWbAPnf1rHt48qowukrjIipbNeSFyA
	 jkG/wtTGSppwQ==
Date: Mon, 20 Jul 2026 14:45:38 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 00/15] mm/rmap: index MAP_PRIVATE file-backed folios by
 virt pgoff
Message-ID: <al4F3fbXFNTiI4xU@lucifer>
References: <20260717-b4-scalable-cow-virt-pgoff-v1-0-cf24910ef094@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717-b4-scalable-cow-virt-pgoff-v1-0-cf24910ef094@kernel.org>
X-Stat-Signature: z7is3zb1k3b5cewkqydxneexhez661nf
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 039CBC0010
X-HE-Tag: 1784555161-45095
X-HE-Meta: U2FsdGVkX19khFhgpiud+5QP8CCsxj/ORxldQpP4mwFUpj7441A5zsM+o0cF5e594IbGz+QlcCs8MI+FnDI5aKoHQPwD8SHU8O0VGrB82pJHK+CyWtozgHX7xktEBWQdqjXaIuJvs0tpWOcvp2hN+LMPHsJQiW+tH440Z6FnitJvjtrB6e9JwaVbEan4xgjTCv9dTZW8YJ415nlm1VXsxYdv28EnqbhmpzfuiAuX3fFCgMOI2IBUlxl8zPpwKIK5vUtpx59ZErUVcfl4OZerJlsI0OaZUG9ZJvvT3GTE6y6X6rrqQzLs7xZCWOhXU2oUsI5D14EcjZ3Xi/B0NGpQW0gIZXjgvBAol47h1aZd+MjoJ2Qmvcdet8vfzKLKNWu7vBjm5c7vqeN0f3bnZPbVbl559g4M0nEqX2+6DuWyPZ5jaLmcQUYXXr1mkXW1wzJObDwuMpiBowRDNQCxiahnUW9Q4wt/w/xpBPXCJh7gshpuJAmcFO0+AG3ZoftKzVM63fHKPVAdVtjdVuQpf9BBKNK7lhJQ7F186VtywCMHGHqjqEjgL3aKKxa67dlY8liXjD0C0smZQNzqT7YAXH1F5O3yOE+fgCmzzTTl8f0DDrkqoVygQAutcRlJA0M9QRTbFDScQQDOpp8g6uUHpTE+4f4LQcS0h4RpGcpJf8RSTL+jJMexJqbPWw38h/nqB8TXtOWrIjOmju05GjTUlsh7w9fC1piBteZsAij3aZkuKmyqgeQxAIuyI/UsovAIPhmDzGJbb6HTT1+1zyYlu5sLeG4K64h7eHl4roYsXnXqTaQT5YDQr2sD36IUJzOkHF85X1rPMVnvVL6BnIp2/ib2GXcOLvZc7WXulaOPdCP03wUgd6Q+/EJBgqZ+U0JMYKZQD/s9a2RE3tehJ9BR+W5fnMCCDWxMOllv5lRa/AgmKxLZKmteHfvS/vl6QQUEXw/enLSF5ljGhZ6dZRaOx2b
 35QH7gxc
 i1TQvl7PhGCkiJfCX6A4RonHNPROtvRUG5cu20DsqL4u9O3ikqsFagpPKl6GZZP0tbs55zN6axIoIU1dBaSpfrnGXQq0nIrMkZoXCQ+u9SYT+RF5t25/YlF6FSgO5PSX/cHE4epObHKxLezF2iV8bBvAF1bx0lGoPGJaEwdh9foXn0Y2J/zgCZ48a/7vftFw4NQkxI1cIq/72KuJHxZrnHK/sWHKFwMZdwmwYJF2riztBy+f4O/OKbGuKY1yiMFC6ypXeOJWKJqybxYzyTTvM95TSLf6Y+3KtmerxWHW85NAb9n7DFIYpabFGitlSWkPf1ziJTFabE2wfmuS7+DP1Lur7ku6i9U0fISSrRFaiFbBc9HuW/meXopV5jjylgC0ZFgOXavHy1uVDapcKOFkctlQolliaPGab99cOowSqOxCfieIWndqgZrx2Cbjod8/UdL6V5oahptZ/Npk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Dealing with the sashiko feedback ([0]):

Since there's not been review of this yet, I'll send a quick respin with the
valid bits of the below addressed.

Many duplicated variants of:
> vma_start_virt_pgoff() is wrong for zero-initialised VMAs prior to
> their page offset being set up

<incorrect>

Sashiko seems to be using a crystal ball to predict that I won't set this
field at the same time vma->vm_pgoff is set, which is incorrect.

Nor does it quite understand 'this feature is not switched on yet' :)

Also in the sensitive case where asserts might fail due to chicken-and-egg
'assigning to a fresh VMA', I use e.g. __vma_set_range() which doesn't perform
the assert.

Note that vma_set_range(), which is typically how the pgoff field is set, now
also sets virtual page offset.

Many duplicated variants of:
> vma->vm_file is an incorrect check for anon because of 'special' VMAs such as
> VDSO, VVAR etc. not setting this, so don't assert !vma->vm_file and assume
> it's anon.

<incorrect in practice, but dubiously valid>

These are only called in instances where a virtual variant of vma_start_pgoff(),
linear_page_index(), etc. are called, that is places where a 'special' VMA
should not have that called on it.

However for belts + braces will update the asserts to also test
vma_is_anonymous() (the 'special' VMAs have vma->vm_ops set so will be excluded
by this).

Also noticed linear_virt_page_index() was not updated to account for
MAP_PRIVATE-/dev/zero being made into pure anon, so will fix that too.

(will send fixes for this on respin)

> Does this patch miss updating the VMA merge criteria to check anon_pgoff
> contiguity?...

<incorrect>

Another case of sashiko not understanding the meaning of 'this feature
isn't enabled yet'.

I make the relevant change _when I enable the feature_ to avoid bisection
hazards.

>Can this result in a NULL pointer dereference when CONFIG_DEBUG_VM is enabled?

<correct but already addressed>

Yup :) this is valid but already reported by syzbot and already fixed, both
inline with a note to Andrew and also locally to be sent in any respin.

> Are there additional core anonymous folio creation and validation paths
> that also need this update to prevent breaking reverse mapping lookups
> when the underlying behavior changes?

<incorrect>

More of sashiko not understanding the concept of bisection hazards or the
fact the feature is not switched on yet.

> Does this change break NUMA node interleaving for mixed MAP_PRIVATE
> mappings? (9/15)

<incorrect assessment, valid that it's something that changes>

It doesn't 'break' anything, but it does affect it.

Commit 88c91dc58582 ("mempolicy: migration attempt to match interleave
nodes") already makes it clear that this is best effort and may cross VMA
boundaries, so this was already fuzzy in the sense that it's best effort
and designed to endure a varying 'base'.

So CoW'd folios of MAP_PRIVATE-mapped file-backed mappings will simply be
equivalent to the base varying.

It's also very unlikely that anything in the wild relying upon this
interleaving behaviour will be doing significant amounts of MAP_PRIVATE
CoW'ing, as in practice this is largely used for things like ELF image
relocations, etc.

I will update the commit message to mention it.

> Does this code miss asserting virt_pgoff for adjacent VMAs modified during
> the merge? (10/15)

<correct>

Trivial VMA userland test change, fixed up will send on respin.

> Does this code unintentionally overwrite the anonymous state of
> MAP_PRIVATE /dev/zero mappings? (12/15)

<correct>

Yeah it does... I deal with this correctly when I make
MAP_PRIVATE-/dev/zero mappings pure anon, but this is a bisection hazard,
so have fixed this for respin by gating on !map_is_anon() when calling
set_vma_user_defined_fields().

> Does this missing device type check in map_is_dev_zero() allow block devices
> sharing the same major/minor numbers to falsely match and lose their mapping
> data here?

<correct>

Yes :)) I added an `S_ISCHR(inode->i_mode)` check locally. I was not aware
that char and block devices have entirely separately major/minor
namespaces...

Cheers, Lorenzo

[0]:https://sashiko.dev/#/patchset/20260717-b4-scalable-cow-virt-pgoff-v1-0-cf24910ef094%40kernel.org

