Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE001FF886F
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 05:16:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B27E16B0088; Thu, 30 Apr 2026 01:16:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD7FB6B008A; Thu, 30 Apr 2026 01:16:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EE506B008C; Thu, 30 Apr 2026 01:16:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8CA616B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 01:16:36 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 320AEA0434
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 05:16:36 +0000 (UTC)
X-FDA: 84714061992.22.163A658
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 80B304000A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 05:16:34 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Pz7dzphi;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777526194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f2DAAXASVSG3WRiYQ/A9XL5CcIrU1snkCtHMmsOFtn0=;
	b=0jHB6HfwBJCTSVPEh2IFxPdwfH8RXP3yZkgJJi4agofScrJH57cA0Tk6tyFnd1aggzgwBz
	w9hGjYWfZgpMWYu6b9IbxUVmUjdz6G8R91AVADaoQQvowgmCRr+1YtZzGEteAznwsbOf/p
	IBoZkkuAHR+2TGA9vlHxTxsQj2e1JDY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Pz7dzphi;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777526194; a=rsa-sha256;
	cv=none;
	b=KP8cEveTMK5Ltl7lWgZP3jRK+MvCE74pRG1RZrY05/whAdCGWstnKsh7dK5Bbl7zUamEyk
	E/iQhwT08YspW1yAQvswnQ4wXcvgOTIwDxsSYdXmc5SIKVvROISff1EEYD0QB4FUshy0HV
	XuOhbmscSZlJ5q8vEHJHCiMm4VVIjPg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CBCE06091C;
	Thu, 30 Apr 2026 05:16:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0BE2C2BCB8;
	Thu, 30 Apr 2026 05:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777526193;
	bh=ob5nhA61HuQg2E1I2OWEV91tQOZi7aLhV6ARCC1gmqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pz7dzphiQjWPEYNMq5loyb4ZOB9EtLTqdbvQbeu78m51DIw/WbJIFrEDSUJXw3hdv
	 7dMvCaP5jaAl3fOyxEuez8+L4TQ375WVh+f5MeRNxs5JGxGuNMBBspwjqSpXpuDX5t
	 V8swLmJpNOIdsTC49zUmxK1YHQcMTU8qVoH6/e8XyPHyN6GJHNKfpdmUqvXRWILtHq
	 6NhMJJ/q8KDnakHuAokvMp33xtKdW2pqteqxcUj0ErHzzIfqOsaYx2fpN1R1pQjyy3
	 wi0H97hq0T+2EcLnrkAj6rtFA7i6DQWppZ/evPxy0OJK7gDa/xtMosPOveyp3UGtWD
	 GgHmkxzS48+aA==
From: SeongJae Park <sj@kernel.org>
To: "zhen.ni" <zhen.ni@easystack.cn>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/4] mm/page_owner: add NUMA node filter with nodelist support
Date: Wed, 29 Apr 2026 22:16:28 -0700
Message-ID: <20260430051629.78237-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <f2d8be6b-d19d-402d-ab53-b40639c66146@easystack.cn>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7idabx1c7tcnbejr4gma5uw3r3m1691b
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 80B304000A
X-Rspam-User: 
X-HE-Tag: 1777526194-803334
X-HE-Meta: U2FsdGVkX19FHLMnSWpN3TE53XZsre1nW+WIuUf2fY15/40Sj009AaIwns/SmNLyv/hZ68SxNDuMs0EA7grncVS5vEm4MIZVpCMsrxtoAN6wqnSsfjAamZ4rKfju+rZXOhIy62MwwAJBEX2QvUCaVmdRLKucFyRbD339ymKZ2DRbsRnC4YZ4gkLUsSI9ZTCr03QQm4uzyC/IzZHW9ULzgdxLjSmn/1LVTFvmNwY8bXfGPNKpKXt+sxdS6tLZtmNcTF/MbnRcL0VP+sNG7ZbNInKh5oLThvovbWn+ZDUZxqga03GOgzuajMIZax+dHqwVCmjR0GptFeHbS4+WPZHkgMd4+9NarPGDtyCub2rlTv8d/P8IRYYEpV2A0h/Z7s2yK35isfoWAEWKJ+7fqgmszvovUQeuBTT2YmXYihJJl0wEwm9U4hgT/Egd6EoAGFNmVRpr0Hny9ZUU/7NjUgq3rsu7xhD6r0D48s6V4NS2z4IyAyoN7nVGXkaZ0gssFxWsJ3NFPzGbkL6ZFtMkcBlYLs3xg27oo8/GjXdZ0aSv98ElHNKBE1XolUbJVnONiVaFF0UkEdGWPBdYhjd//d7YqIL0KcqtuAegmVn9+y4nCHwp1pcUCEL5CjBEAdWHj5rOIBok0wk1kiQ5h/5uNf+LM/GWl0vtLiNe9ZH/mUiLQ90dmxrtEif+vlVDL8rMN4JK4v4Gem11ntyl3MU18WUa7Rc3jUmQYcaEIhiSDHCEg9BQjUmLf3TpyvkyN+5dd+dbEAMnzN2MItOnnC+g3FnuOXZQkhywHDVPO7tOk9GrtkEfNz+ybiDqhSPv3JK7lvEcMBfrPa04RORclw7U4LNG8+g5YltKQTcoE9rXP82eCYq5HlMepqWIAoXMUQQe//Wu+rVqYQ2+M4AvdHFl48pAyOC/XVTaVFrbSsWADCPXsaTHtgva4GTlblFzpdU7yTU+zXJQQ54UpgezIkXqP3R
 3+t5rXL3
 ZlwVPkfi749dlk8QWw2pGe3Xi5OFioO1JH5XLtcAopVyu2g9KJoU/f6i/WBmmbe+F4FK7ooxQ8GWWSpuaWBLFpWVWtWTsHORanZRv1Nkbih2FiftnUkm03S8QMBZRZah6CPiSatPfdJa+PlxvBf5wMwoWDhKopmICtI/7WMEy0iDFFDIqSEOcYuZNjiQvoJ1efu375eOugr7bphu6pOOKntAghmgHCgxzReYSW3VPq1KvOJ1BDizD4F2meb83XO27XvDnEJYYepbVRwijaDc7wMnvYyBs2caWuxVo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 30 Apr 2026 11:56:33 +0800 "zhen.ni" <zhen.ni@easystack.cn> wrote:

> 
> 
> 在 2026/4/29 22:56, SeongJae Park 写道:
> > On Wed, 29 Apr 2026 17:03:56 +0800 "zhen.ni" <zhen.ni@easystack.cn> wrote:
> > 
> >>
> >>
> >> 在 2026/4/29 09:28, SeongJae Park 写道:
> >>> On Tue, 28 Apr 2026 15:11:11 +0800 Zhen Ni <zhen.ni@easystack.cn> wrote:
> > [...]
> >>>> @@ -685,6 +685,7 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
> >>>>    	struct page_ext *page_ext;
> >>>>    	struct page_owner *page_owner;
> >>>>    	depot_stack_handle_t handle;
> >>>> +	nodemask_t mask;
> >>>>    
> >>>>    	if (!static_branch_unlikely(&page_owner_inited))
> >>>>    		return -EINVAL;
> >>>> @@ -698,6 +699,8 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
> >>>>    	while (!pfn_valid(pfn) && (pfn & (MAX_ORDER_NR_PAGES - 1)) != 0)
> >>>>    		pfn++;
> >>>>    
> >>>> +	mask = owner_filter.nid_mask;
> >>>> +
> >>>
> >>> READ_ONCE() was used for owner_filter.print_mode.  Should nid_mask also read
> >>> using READ_ONCE()?
> >>>
> >> The reason is that `owner_filter.nid_mask` is a nodemask_t, which is a
> >> 128-byte structure. READ_ONCE() only supports types up to 8 bytes and
> >> will trigger a compile-time assertion failure for larger structures.
> >>
> >> This was actually an issue in v2 - the AI review tool (sashiko.dev) and
> >> Andrew both caught the compilation error with READ_ONCE/WRITE_ONCE on
> >> nodemask_t, so v3 removed them.
> > 
> > Thank you for kindly sharing the context.  Now I understand why READ_ONCE()
> > cannot be used.  But, is plain load/store safe enough for nodemask_t?
> > Shouldn't it still be protected against races?
> > 
> Concurrency Safety:
> I considered spinlock and RCU, but decided against them:
> 
> - Spinlock: Adds overhead on every read, overkill for a debug facility
> - RCU: Requires dynamic allocation of 128-byte nodemask_t, too complex
> - READ_ONCE/WRITE_ONCE: Not possible, exceeds 8-byte limit
> 
> Plain load/store is safe here because:
> 1. page_owner is debug code with low-frequency filter changes
> 2. Worst case of torn read is temporary inconsistency in debug output
> 3. Similar debugfs interfaces use the same approach
> 
> The overhead of locking doesn't justify the benefit for this debug use case.
> 
> Do you think this is acceptable, or would you prefer I add locking?

Thank you for kindly explaining this.  Unless others have different opinions, I
think this is ok.  But, I think this would be good to be clarly documented, on
the code or the user documentation.

[...]
> >>>> +	/* Support: "-1" to clear, or nodelist format like "0", "0,2", "0-3" */
> >>>> +	if (kstrtoint(kbuf, 10, &val) == 0 && val == -1)
> >>>> +		nodes_clear(mask);
> >>>> +	else if (nodelist_parse(kbuf, mask)) {
> >>>> +		ret = -EINVAL;
> >>>> +		goto out_free;
> >>>> +	}
> >>>
> >>> Doesn't empty string input to nodelist_parse() clears the mask?  Can't it be
> >>> reused?
> >>>
> >> Yes, empty input (echo > nid) works because nodelist_parse() handles it
> >> correctly. However, nodelist_parse() - which is implemented via
> >> bitmap_parselist() - cannot handle "-1" as it's not a valid range format
> >> and would return an error. The explicit "-1" check is necessary to
> >> support `echo "-1" > nid` without returning an error.
> >>
> >> So the "-1" check handles a case that nodelist_parse() cannot handle.
> > 
> > Thank you for kindly explaining the reason.  But, do we really need to support
> > "-1" input?  Couldn't we just redefine the interface?
> > 
> I chose "-1" to clearly differentiate from valid NUMA node IDs (0, 1, 2, 
> 3...).Since node IDs are non-negative integers, "-1" naturally means 
> "invalid" or "no filter", which is an intuitive convention in Linux 
> (e.g., pid -1, signal -1).
> 
> Do you have a better suggestion for how to represent "clear filter"？

Seems my suggestion was too implicit.  I'm suggesting using empty string
instead of "-1".  I think it is also clarly differentiated from valid NUMA node
IDs?


Thanks,
SJ

[...]

