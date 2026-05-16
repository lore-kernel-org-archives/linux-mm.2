Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5B36CD4F25
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 09:15:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD3C46B0088; Sat, 16 May 2026 05:15:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A846F6B008A; Sat, 16 May 2026 05:15:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99A2B6B008C; Sat, 16 May 2026 05:15:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8747B6B0088
	for <linux-mm@kvack.org>; Sat, 16 May 2026 05:15:31 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4C33E140313
	for <linux-mm@kvack.org>; Sat, 16 May 2026 09:15:30 +0000 (UTC)
X-FDA: 84772724820.30.67A0150
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf27.hostedemail.com (Postfix) with ESMTP id 40A9D40002
	for <linux-mm@kvack.org>; Sat, 16 May 2026 09:15:25 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf27.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778922927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BAfsVhWn4jW9ly4KCTY+GqDE3BZk6u+kGLwvL080Mcc=;
	b=IUJrdLWs2nYqflNQCTWjgd0rKHXiLTb8A0BMP8F4DanXIJCekNyys92c0hRdJsvqI3GsLQ
	s0nDboXMiwzD1Bv+8VUemnzEIMp5BBZbIAz7xPNBAQ4jhSO1TperSMbIWN1+iDDoAWLrdD
	U/rYMjwQ3THl3p6facaF/SYwrxT1oVA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf27.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778922927; a=rsa-sha256;
	cv=none;
	b=dARfGYEc4BXLjS9H9I7jztk4YPZq9nt1mzoljggiQ129dlX4fZ2OEYjBtG9beqbhV4jyx0
	CYTJyAGqDBsc/ss4dCnnymga8rK3hr4w04P1KJQaotslRNpcRvo76eGCkgu+bRQ7ROyMi9
	lTIt77UY9h23s59583CFv4v8fwycY4Q=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4gHdh01pmTz51Spt;
	Sat, 16 May 2026 17:15:12 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl1.zte.com.cn with SMTP id 64G9FB5B036332;
	Sat, 16 May 2026 17:15:11 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Sat, 16 May 2026 17:15:13 +0800 (CST)
X-Zmail-TransId: 2af96a0835a1fb1-d1742
X-Mailer: Zmail v1.0
Message-ID: <20260516171513673dGPsqh62DnbliovuIDPAk@zte.com.cn>
In-Reply-To: <0e2a90d7-8b0b-4d04-9c34-9a82294fee9f@kernel.org>
References: 20260503204843889ik1YHe8LX_5N0Neyn0ner@zte.com.cn,0e2a90d7-8b0b-4d04-9c34-9a82294fee9f@kernel.org
Date: Sat, 16 May 2026 17:15:13 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <david@kernel.org>
Cc: <akpm@linux-foundation.org>, <ljs@kernel.org>, <hughd@google.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <michel@lespinasse.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2NCAzLzVdIGtzbTogYWRkIHZtX3Bnb2ZmIGludG8ga3NtX3JtYXBfaXRlbQ==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 64G9FB5B036332
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Sat, 16 May 2026 17:15:12 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A0835A0.000/4gHdh01pmTz51Spt
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 40A9D40002
X-Stat-Signature: s7w83n1gxdf8aozmqcm8qy3gwd9nts16
X-HE-Tag: 1778922925-726587
X-HE-Meta: U2FsdGVkX1+e4FNbRNehYn8lrCzGfigpplvK/YbzOuce0nk2CkT5AI6C5TNkq7u5s6Cj3k6hhdWwPVLAGglwFr1Cw50cHF8odjJ6mPq9O5YyGDatbbeZsOJgZHZp/mcPTZPhM+7SrYpyxuBGoDXrBqJYW5CWKuV/7OwjRHiscSHVIAcZgAKDYwbILBVvh5Fr3VkHNGWiG4da8RTC6eW64HoDh031w66kCQ53LO5iQkv19YPAdMwXYDEWGIQNB0ZQI2tULxPb27E/hDmkpG9Q33wgz0QiHL6kdJgD15yXZw55X1JXgGrYOnoCIEyw0rrt3ak9ePsAb1J6jnhpiqRHl+DX9He490y2THEm+e6pOCTQFHZPwawSxq/P/HZpThUK91eU0JUg5TPdPUdU9ruNE60qpdSdVblKYAZ8BaTDmSiq1s53nxdvWiekhW3YrHM6Jv1JmplJioYbaUwkWeU7kXsWMKT/7krteGFEuOYoGVYZt7EHrHONQ1pw18hOO0uwJW1yk1SgyNU3M6JvLLXoWRvlbgLamB9T9FQrzmN3lCG34jV3Gu/HiegnZ/fzVXfVR7ueYadCATSWnPjyGLxxKjBt7UR4ACL7QQGFTMPFlnlwpOBqSPI6S+bfrDKcgykpnzZl9RWuuITI3q8HROhmd6ApEuqIYgLOSNu43LUy5ipwNLGJpOhxZuFepH5a3fQiotxn/gdhmEuYPrrZBs3rcV4cj/+LcmaciHXpQ6G4gEaawMd1NtDV2GKzAazrDnlUqunSPenm4ZfHHKCRb9H+RjgOcUi1UZUewLKzzoQuAngIYIqCcWZnG0JbEeRoRLW+0yjA4SUPwPaqtoWBb5fcA6ssZoUxtxZRZBVz1tLk8hF7k+Bgf2ItZ8y7z2SyJxUO5IcYorB1Q8jSBV6zHgZgOoIU6+730jY25iTUffoynwn2TqvUEWwR1nChfgbt9YQgq0k5DsJdjFt9dMB1ofv
 SmVibpR0
 IEm/6lrFgLmdrH/qZz2dhz0K7lzH0GfKdK0QS0tEDX5PIcrQua5QmC462GUkkfvatOGSaLzm4LY/SGoUrxxKTrzX4JcxXqgfMHbCOLB+Vo1LnSYzvDHx3iqRotuddWCyYT6eT1IemizzeLIFHNYSdeIljlFJ+d8qR2KVPFGIOVtHB1Y/PHdni0EHTUhICS9hIejNPtEAJzInfmRiL/ihhcb1sa+rtnIt0BzVJeIJWfj6PhX4OWM51ULmWWF8UWx1f++ho+q91VGCUJ39kXeoyJN+NL7lg/ZH77ZjO0fsRilXsMBY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > diff --git a/mm/ksm.c b/mm/ksm.c
> > index 7d5b76478f0b..0299a53ba7c9 100644
> > --- a/mm/ksm.c
> > +++ b/mm/ksm.c
> > @@ -195,22 +195,28 @@ struct ksm_stable_node {
> >   * @node: rb node of this rmap_item in the unstable tree
> >   * @head: pointer to stable_node heading this list in the stable tree
> >   * @hlist: link into hlist of rmap_items hanging off that stable_node
> > - * @age: number of scan iterations since creation
> > - * @remaining_skips: how many scans to skip
> > + * @age: number of scan iterations since creation (unstable node)
> > + * @remaining_skips: how many scans to skip (unstable node)
> > + * @vm_pgoff: vm_pgoff into the original VMA where the page is mapped (stable node)
> >   */
> >  struct ksm_rmap_item {
> >  	struct ksm_rmap_item *rmap_list;
> >  	union {
> > -		struct anon_vma *anon_vma;	/* when stable */
> > +		struct anon_vma *anon_vma;	/* for reverse mapping, when stable */
> >  #ifdef CONFIG_NUMA
> >  		int nid;		/* when node of unstable tree */
> >  #endif
> >  	};
> >  	struct mm_struct *mm;
> >  	unsigned long address;		/* + low bits used for flags below */
> > -	unsigned int oldchecksum;	/* when unstable */
> > -	rmap_age_t age;
> > -	rmap_age_t remaining_skips;
> > +	union {
> > +		struct {
> > +			unsigned int oldchecksum;
> > +			rmap_age_t age;
> > +			rmap_age_t remaining_skips;
> > +		};			/* when unstable */
> > +		unsigned long vm_pgoff;		/* for reverse mapping, when stable */
> > +	};
> >  	union {
> >  		struct rb_node node;	/* when node of unstable tree */
> >  		struct {		/* when listed from stable tree */
> > @@ -776,6 +782,10 @@ static struct vm_area_struct *find_mergeable_vma(struct mm_struct *mm,
> >  	return vma;
> >  }
> > 
> > +/*
> > + * break_cow: actively break the write-protect of the VMA. This is calld when
> 
> s/called/called/

Thanks.

> 
> But why are we changing the documentation as part of this patch?

I want to make it more clear and readable bacause from its function name we can't tell that
implicit assumption: "it's only called when rmap_item has not yet become stable, but page has
been merged."

Based on that assumption, the following confusion was clarified.

> 
> > + * rmap_item has not yet become stable, but page has been merged.
> > + */
> >  static void break_cow(struct ksm_rmap_item *rmap_item)
> >  {
> >  	struct mm_struct *mm = rmap_item->mm;
> > @@ -787,6 +797,8 @@ static void break_cow(struct ksm_rmap_item *rmap_item)
> >  	 * to undo, we also need to drop a reference to the anon_vma.
> >  	 */
> >  	put_anon_vma(rmap_item->anon_vma);
> > +	/* Reset pgoff that overlays age-related information. (still unstable) */
> > +	rmap_item->vm_pgoff = 0;
> > 
> >  	mmap_read_lock(mm);
> >  	vma = find_mergeable_vma(mm, addr);
> > @@ -899,6 +911,8 @@ static void remove_node_from_stable_tree(struct ksm_stable_node *stable_node)
> >  		VM_BUG_ON(stable_node->rmap_hlist_len <= 0);
> >  		stable_node->rmap_hlist_len--;
> >  		put_anon_vma(rmap_item->anon_vma);
> > +		/* Reset pgoff that overlays age-related information. */
> 
> AI review says that this might not be the case on 32bit. So I guess the comment
> should be
> 
> "might overlay"

ok, thanks.

> 
> > +		rmap_item->vm_pgoff = 0;
> >  		rmap_item->address &= PAGE_MASK;
> >  		cond_resched();
> >  	}
> > @@ -1052,6 +1066,8 @@ static void remove_rmap_item_from_tree(struct ksm_rmap_item *rmap_item)
> >  		stable_node->rmap_hlist_len--;
> > 
> >  		put_anon_vma(rmap_item->anon_vma);
> > +		/* Reset pgoff that overlays age-related information. */
> 
> Same here.
> 
> > +		rmap_item->vm_pgoff = 0;
> >  		rmap_item->head = NULL;
> >  		rmap_item->address &= PAGE_MASK;
> > 
> > @@ -1598,8 +1614,15 @@ static int try_to_merge_with_ksm_page(struct ksm_rmap_item *rmap_item,
> >  	/* Unstable nid is in union with stable anon_vma: remove first */
> >  	remove_rmap_item_from_tree(rmap_item);
> > 
> > -	/* Must get reference to anon_vma while still holding mmap_lock */
> > +	/*
> > +	 * Must get reference to anon_vma while still holding mmap_lock,
> > +	 * We set these two members of stable node here instead of
> > +	 * stable_tree_append(), maybe because we don't want to hold
> > +	 * mmap_read_lock again? Here mmap_read_lock is already held to
> > +	 * find_mergeable_vma before merging.
> > +	 */
> >  	rmap_item->anon_vma = vma->anon_vma;
> > +	rmap_item->vm_pgoff = vma->vm_pgoff;
> 
> I suggested to use the actual linear page index instead at [1]. Storing the
> vm_pgoff is wrong I think.

Yes, you are right, I have comment the reason in last email. will correct it as you said.

> 
> [1] https://lore.kernel.org/all/5401c1d2-5f42-4288-9dad-2b9768b579c7@kernel.org/
> 
> 
> In another comment I said:
> 
> But it's all confusing. Because we might temporarily have rmap_item->anon_vma
> set on an rmap_entry that does not yet have the STABLE_FLAG flag set through
> stable_tree_append().
> 
> And then we magically call break_cow() which does a magical
> 
> 	put_anon_vma(rmap_item->anon_vma);
> 
> (this doesn't look correct in once case) ... anyhow.
> 
> So we might want to reset the pgoff there as well, OR only store
> the pgoff in stable_tree_append() where we actually set STABLE_FLAG.
> 
> 
> So I guess we have to figure that out as well.
> 

I think it should be correct in general, but that code was indeed a bit confusing.
So I've added some comments to make it as clear as possible.

The underlying idea should be this: when a page is merged (try_to_merge_with_ksm_page)
and becomes a KSM page, we should promptly store rmap_item->anon_vma
(so that rmap_walk_ksm can succeed). However, there are various subsequent reasons why
the page might fail to acquire the STABLE_FLAG—for example, a second attempt in
try_to_merge_with_ksm_page fails (see the implementation of try_to_merge_two_pages), or
stable_tree_insert fails (in cmp_and_merge_page). In such cases, we need to revert the
page back to an anonymous page, so we must explicitly call break_cow() and
put_anon_vma(rmap_item->anon_vma).

So generally, I keep the same way to store the pgoff as anon_vma.

