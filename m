Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75010C982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 13:49:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A5ED6B009D; Fri, 18 Sep 2026 09:49:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87D946B009E; Fri, 18 Sep 2026 09:49:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BA9C6B009F; Fri, 18 Sep 2026 09:49:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 528496B009D
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:49:44 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0A29A16067B
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:49:43 +0000 (UTC)
X-FDA: 85227015846.02.CC9E68A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 628951A0003
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:49:41 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JIFor4Si;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789739381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I56ArlD9g2uoL/lG5d7qnG9zNUL8ABoq7wmxn3lzZPs=;
	b=QuBVGH+AEPOsRLmCR7gK/fVTamJy0j4HsNcKPxXjcE9dG2lFsw5G34wP8FOtL8EsFxUAZv
	CrtuXrKqYpDH7aYkQ02Px9EJhTERrfstHuA7Ki2ISpQYyXs2C73CTQuu78K9qRlOJAi+bM
	Qjs62CqWespmdl6L4iGm/ZVKim9uEIs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789739381;
	b=u5VgwtEzMqU6hCxAqsWQpNW5lZ0MIQdPQ6nlU6Y8HngDkpmm5PIjbzpNL5h5yn9OWOFJw5
	CmSM5mraQ8oKqdzYu6Y7DcjWcVvRsaknc+Wae5raQ4xt/jrz3ugmNFkjoWB8AZknKgdQ0o
	eotwLYHUIHlWKb+ZKVXANZIJ7w1SLAA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JIFor4Si;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D8B70601EF;
	Fri, 18 Sep 2026 13:49:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 933411F000FF;
	Fri, 18 Sep 2026 13:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789739380;
	bh=I56ArlD9g2uoL/lG5d7qnG9zNUL8ABoq7wmxn3lzZPs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JIFor4SiKeif9cZimu50LNcITC108q7tkLBa/wxMMSkNByvmlzjr1fysTSXy55uxc
	 lyghMl7Tqhy+pBmJx+LoEXHr1+1x1bbNqDDHDmz3eU/NYM5vViksoXXq0XUTgvPIZN
	 26oAYlwsjcbEb9IKzM7NosZVNlbFHp7VP8pcMKKdVAYB+AMTkl3dxj88Hc1ZtoSoAp
	 Y84WIzDzE8aUl1OYiAb9Rk6NFDh/jazWKgQMkQv3/za6ihVAfjD1iGZHX0NoLwjbO+
	 KbjlL2ZdqatfQCRpkAfRY/7Io/XCr7uCPwacvF+gmkbm8mg9LL9HduLzNUAGUZiPsb
	 s7RT0tx4X97SQ==
Date: Fri, 18 Sep 2026 14:49:27 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, Peter Xu <peterx@redhat.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/3] mm: update comments to refer to anon rmap rather
 than anon_vma
Message-ID: <aq1BACGj3wkdL530@gremlin>
References: <20260917-vma-is-faulted-v3-0-5c22314a72e7@kernel.org>
 <20260917-vma-is-faulted-v3-3-5c22314a72e7@kernel.org>
 <DLHVTX80IKX4.GKQ7P0C8S5IK@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DLHVTX80IKX4.GKQ7P0C8S5IK@nvidia.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 628951A0003
X-Stat-Signature: dwf84559m6ieo3q7o9oi8o11en47e51q
X-Rspam-User: 
X-HE-Tag: 1789739381-816370
X-HE-Meta: U2FsdGVkX18BscN0iMnMTxObWUxu0AmzHyvmErYC5h+5qDuke3iZOrmbfmXMW7TTkBG22IncFCS53W+P6FwS1DVK4Oc+oZqxlq2AJ9qRuJDj6Q1aEHMyfyUUgogGdCYGK82uLL669/NqnZ8ySoJGsliYHLo9DiUJWgB6RsklGo4QBd8aQQnzT9o4PjG/0NEEGTATV9AYyiti1TzKJnom64amOC3QrGAZOlBPnD6QoA+Hias7c15ennu14iqxr3fcxLfAaFFQ4k6stL8IVh3y9QbsCE1AF7Tdv7v9q2Di9R7vDXFGfRlKcy4R7okv9fvr9uMFaScR8quYlkYLi3oQnFMeEq9nZWT8bBWlkBcnUtCXYcNviCYwwOnhfTDhte9TAcAI2kLltTOg2OEEGBIYD+W4Cx5KnJ20k1yl8wJrxJ1Sg/7cryEFOhAN45zLYYo+O5OWzIKvPCsUwoAKbsz7gmts787ubJlrPpXJG17PM9Mqvdvs5BDxhvKBZLGbTQTd6oo+4PDrucmlQ3BkJlNDMRj91oc3cL1VB8VU0z68ar2PCViM6/4wJItcFnWoTY4aUHdKb/WLjr6GuNyZtqR57Wy31gZVqvIuw4dF9trLgnGLCJNAq9Xn7a+s5vvCnhptCDwPZy+efYMvsfP4j9fj58ATF+f/MaELVYByugMetnQNE4Lpr00oH/5f5ddzY2oz+mU9G2HLVLXN3aIZNz4kPAeODsu3gdgqPDqrfUErBRNkjKOmpqOaJE8gHWPVKZ2OpEhusW66OkltnbVJyUkXAG6Ovk7hf7q9cgnysY2N4UBIRIN2VbDXvY9P6fFV4v25eRG77vXLgNJnPEFr9zZ11NM0NDg6z4vugckedeCEkTpXvWERKP10Q9sJPMGnT3nMbG3H2+NBn5tWz2QR13IFGqMtd1t8Y0Cuv90W67vV6cMC4+AJ7j+YTX85rv967jR7+Kb3BS3p2QTbmFCsDKm
 MV9aMo3x
 8nPrsuxGIB98lp6QoB9kRVCikBmpwPW+HN1hb9xoEm/NaB9YCEQebU4y0Y4FMzhPD+ZsE9jy8QuQ8mOrah4HZeX2KCOuE5fKGZhTuHoePEGGncbC3qyudhAv1DKuh2sSNMTYjDph75h8Ezs27S2ovM4VkMIG5E9C1I2l5DjuzC6v7RLPHFh0ap/TFRe2f41YyinUYFf35xKRlejqhFCJWyH1n0hJUmFiRqonFX0mJd/UcwbLswCoOnbSGDp265sSKAhutlcGLQ9GE1jPITSzEtmc6R9OdlP9u8OyM7kXJ+LLZxe5+HkmP2zFafIm0/xdENmFNovml+JqGoQ8v7SlVd2wv+ujZkqa+TsO61b+PbyyFonfQZAhbUKsCOqRPCxNZdMA7vhYPgZCAoPko7+YcdV4lbK4xNzGncky5mpWNq298m+c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026 at 04:43:15PM -0400, Zi Yan wrote:
> On Thu Sep 17, 2026 at 3:47 PM EDT, Lorenzo Stoakes (ARM) wrote:
> > Now that vma_has_anon_rmap() abstracts whether a VMA has an anonymous
> > reverse mapping, remove references to anon_vma and instead reference the
> > anon rmap.
> >
> > The anon_vma is an implementation detail and should be treated as such.
> >
> > Do not update mm/rmap.c which implements the anon_vma mechanism as it is
> > reasonable to directly reference it there.
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  mm/huge_memory.c     | 17 +++++----
> >  mm/hugetlb.c         |  2 +-
> >  mm/khugepaged.c      | 12 +++----
> >  mm/ksm.c             |  6 ++--
> >  mm/madvise.c         |  6 ++--
> >  mm/memory.c          | 12 +++----
> >  mm/migrate.c         | 12 +++----
> >  mm/mmap.c            |  6 ++--
> >  mm/mprotect.c        |  4 +--
> >  mm/mremap.c          |  6 ++--
> >  mm/pgtable-generic.c |  2 +-
> >  mm/userfaultfd.c     | 10 +++---
> >  mm/vma.c             | 98 ++++++++++++++++++++++++++--------------------------
> >  13 files changed, 96 insertions(+), 97 deletions(-)
> >
> > @@ -4176,11 +4176,10 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
> >  	if (is_anon) {
> >  		/*
> >  		 * The caller does not necessarily hold an mmap_lock that would
> > -		 * prevent the anon_vma disappearing so we first we take a
> > -		 * reference to it and then lock the anon_vma for write. This
> > -		 * is similar to folio_lock_anon_vma_read except the write lock
> > -		 * is taken to serialise against parallel split or collapse
> > -		 * operations.
> > +		 * prevent the anon rmap disappearing so we first we take a
>
> s/we first we/we first/

We first, we happy few, first we take a lock that we have on... ok
no. No. You're right :P

Andrew could you fix up?

>
> <snip>
>
> > @@ -1619,7 +1619,7 @@ static int try_to_merge_with_ksm_page(struct ksm_rmap_item *rmap_item,
> >
> >  	/*
> >  	 * We can consider the VMA only while still holding the mmap lock,
> > -	 * so lock, so reference the anon_vma and calculate the linear
> > +	 * so lock, so reference the anon rmap and calculate the linear
>
> s/so lock,//

>
> based on the code after this comment. Please double check it. And it is
> a pre-existing typo in the comment. Hmm, it sounds very Sashiko. ;)

So Zi was sashiko all along... interesting ;)

Andrew - could you fix this up too?

>
> >  	 * page index early, before stable_tree_append(). If anything goes
> >  	 * wrong that prevents the rmap_item from being added to the
> >  	 * stable_tree, break_cow() will clean it up.
>
>
> Otherwise, LGTM.
>
> Reviewed-by: Zi Yan <ziy@nvidia.com>

Thanks!

>
>
> --
> Best Regards,
> Yan, Zi
>

--
Cheers, Lorenzo

