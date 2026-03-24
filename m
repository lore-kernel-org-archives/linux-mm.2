Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A142F532D0
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 04:05:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B09506B0005; Tue, 24 Mar 2026 00:05:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABA636B0089; Tue, 24 Mar 2026 00:05:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D0676B008A; Tue, 24 Mar 2026 00:05:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8D1D46B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 00:05:14 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 07CD21F984
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 04:05:14 +0000 (UTC)
X-FDA: 84579616548.08.1E0C763
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 720FF140009
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 04:05:12 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hGnEWDkM;
	spf=pass (imf23.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hGnEWDkM;
	spf=pass (imf23.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774325112; a=rsa-sha256;
	cv=none;
	b=4QAKdUR9xDvJJXCOW17dMo051mOdhTvTH0GyK5LZGoYSza7oLzkIJBcBUGD5crdbEB4qou
	GpitkRN/LCCCgFv+UaFtUUdlqodpR8wphltmEQbgio7MHJh9kAkF+kalAiNBaWtzhg2SsS
	mOBGgNXMJYmhyVIOjDdhTE/ucgOgcvI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774325112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6S3g3leyIavTR+2wRIycrjFhKJAbkDgT1/J7exw83Sc=;
	b=26Tm/pXsbWAq8uufp3L5v1+ezt1eirCsjXOqgragvIthsBg3MnQ0aES4QD3lYOb01mY81W
	AV1BCXf4Cdpf8hi3kQ6wg3CFcknLQTOWsVuVGNHYDzyGQ70TIIkODo5+KUjqwCrmZfcMOx
	j4Qr6gVsMGZbjw9RvJrfitMTQ2uaTw0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 251814044B;
	Tue, 24 Mar 2026 04:05:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90D02C19424;
	Tue, 24 Mar 2026 04:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774325111;
	bh=eo7hLe/UY2d6bsTGJr+MAuwNH1sx7hGm4F8hmnA4vUU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hGnEWDkMGtKovAsotKqzcJxOtPk7vEtz18C1/IMUcYQzgymgXnYtn/P88DzKkS1C/
	 9bg1dZCG9YL6jHVkxvebJbkMXCHR/5ZikFRdC0bZBxN6A1MZzHaqo4e6m0z51R5r94
	 5QntqB0qAEFSx1N2RVmQTbPNdtBmHjCTPNauPwYev5mEcYTxUHd0XImtli9lne/OHg
	 LVydXzK8oeQWtKHC7IBq8Uow2rx4Nc4Q4W6MjphUTmt2e6zeikJrHKUlAmE2fSFtZr
	 ckU0C98Prp/XpM/CQGb6WbIkph7GraYrtiBP9FauBYnwH9P8cbDiZZuPGi3dPBC6ka
	 3hizjTu3jMTPw==
Date: Tue, 24 Mar 2026 13:05:09 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, david@kernel.org, lorenzo.stoakes@oracle.com,
	ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev,
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	chenridong@huaweicloud.com, mkoutny@suse.com,
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com, lance.yang@linux.dev, bhe@redhat.com,
	usamaarif642@gmail.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	Yosry Ahmed <yosry@kernel.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v6 30/33] mm: memcontrol: prepare for reparenting
 non-hierarchical stats
Message-ID: <acINdWKdH_b5LdhH@hyeyoo>
References: <cover.1772711148.git.zhengqi.arch@bytedance.com>
 <e862995c45a7101a541284b6ebee5e5c32c89066.1772711148.git.zhengqi.arch@bytedance.com>
 <acDxaEgnqPI-Z4be@hyeyoo>
 <2d39ea5e-fd69-4acf-8518-a504f5f7a838@linux.dev>
 <acExNWaaKdhrBH-J@hyeyoo>
 <c913ce46-bc83-4d36-b1b0-a51b12e515e9@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c913ce46-bc83-4d36-b1b0-a51b12e515e9@linux.dev>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 720FF140009
X-Stat-Signature: 543e8mwtc9ohcordmwfx3dse1gcedurh
X-Rspam-User: 
X-HE-Tag: 1774325112-55568
X-HE-Meta: U2FsdGVkX183IavrQQh3i6kKwruRzip1QujY7qnHvqfvJxdMrQ6XSwfUE5erVXAi4FyN5UeHAwQPnIVkOQkwpOo0TVHuStZNzmV0VicYYhSCn9ThtQ6F6mBaCy/3XLhpwDqZRSPkStUL4YmtlLix4jdTBOx5PX5Km4CVpw6Dw9QV3tQjUEgXdsOFmbX1P7983W9VZwHII7K1OhBiti8stUb2VUjcsaTkZECf2UGGd1tOxmDTKsOzuR6c7g2UiWNpfWc7itoQ3PPlRfHQm/6ywH20gXOEwu4V9l7rbtiRUNlv6a9A+1gpXhAg/DZ9Mak+lxbdVIrWHa9JxDNbfuIm6yjW7jYWyvYd6ONKhPl1Ay02GsbsJzNO28zZOxbMhVwUwBDJ0BLilcUGbHGr8ZahREm+bpedQ/gtRgYMKmP4DFf/7FMD2MceKCqn3E7FmiCg7apOIkKX73qQWi5kM887PXJ5slGFWEginE6OxLcUKigiUAzQ9rlSsk6CiJ4eADYOxpl6P6vM9srz4L4WjNtyGbEFo+4gNYTDLk+nJhIVhFU5BiYA9qwX8lS/NemhhO76k7IG3mrjTXMpgvrX0U1cWwEj8/w6gLV7YrF7YhlhzuubeO/eyj/8KR/8PoDjBdo13JNzAnIdFSsd+XlCkKQonkE4//Vs8JD54lVXoeZqIRXMZmh/uxHiM2aBo5u+ZDQS9/6/SkPHvv4XDtiktTjQUvg0+CcRfT8SETknNQz358Liome5JMhkecN1gP3rOJ1SYEkA8wdGjAuFnDgStnEU9kDL+6vvJWHbOuO6O9p8DE+MMW6UL+YMEKV04wUcLlB1sOtIbXR2qbHnH6sG5Ed++1w85cwBPScuRJzdJ6KCurU4HgMn8mtha2F1FM5Wj5rAd/Nf18x7veaIaz4wg2V8+8YK8n//GU8IqW/s6RHHxoyg8xSyruec6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24, 2026 at 10:54:48AM +0800, Qi Zheng wrote:
> On 3/23/26 8:25 PM, Harry Yoo (Oracle) wrote:
> > On Mon, Mar 23, 2026 at 05:47:27PM +0800, Qi Zheng wrote:
> > > On 3/23/26 3:53 PM, Harry Yoo (Oracle) wrote:
> > > > On Thu, Mar 05, 2026 at 07:52:48PM +0800, Qi Zheng wrote:
> > > > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > > > index 23b70bd80ddc9..b0519a16f5684 100644
> > > > > --- a/mm/memcontrol.c
> > > > > +++ b/mm/memcontrol.c
> > > > > @@ -473,6 +501,30 @@ unsigned long lruvec_page_state_local(struct lruvec *lruvec,
> > > > >    	return x;
> > > > >    }
> > > > > +#ifdef CONFIG_MEMCG_V1
> > > > > +static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
> > > > > +				     enum node_stat_item idx, int val);
> > > > > +
> > > > > +void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
> > > > > +				       struct mem_cgroup *parent, int idx)
> > > > > +{
> > > > > +	int nid;
> > > > > +
> > > > > +	for_each_node(nid) {
> > > > > +		struct lruvec *child_lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
> > > > > +		struct lruvec *parent_lruvec = mem_cgroup_lruvec(parent, NODE_DATA(nid));
> > > > > +		unsigned long value = lruvec_page_state_local(child_lruvec, idx);
> > > > > +		struct mem_cgroup_per_node *child_pn, *parent_pn;
> > > > > +
> > > > > +		child_pn = container_of(child_lruvec, struct mem_cgroup_per_node, lruvec);
> > > > > +		parent_pn = container_of(parent_lruvec, struct mem_cgroup_per_node, lruvec);
> > > > > +
> > > > > +		__mod_memcg_lruvec_state(child_pn, idx, -value);
> > > > > +		__mod_memcg_lruvec_state(parent_pn, idx, value);
> > > > 
> > > > We should probably change the type of `@val` from int to val to avoid
> > > > losing non hierarchical stats during reparenting?
> > > 
> > > The parameter and return value of memcg_state_val_in_pages() are both
> > > of type int, so perhaps we need a cleanup patch to do this?
> > 
> > Yes!
> > 
> > and @val in memcg_rstat_updated() too, I think.
> 
> Right.
> 
> > 
> > > I will send a cleanup patchset to do this, which includes the following:
> > > 
> > > https://lore.kernel.org/all/5e178b4e-a9e0-44dc-a18d-8c014365ee2f@linux.dev/
> > 
> > Thanks!
> > 
> > Should that ideally be applied before this patchset?
> 
> This would conflict with the current patchset.

Right.

> The v6 has been in mm-unstable for some time

Right.

> so I prefer to add a cleanup patchset to
> avoid interfering with the merge of this patchset.

but it's a little bit more than a cleanup, no?

I'd say without the followup, this patchset introduces a very subtle
(likely nobody would notice) functional regression visible on memcgs
with billions of pages.

> Otherwise, sending v7 might be more appropriate.
 
I think it should be sent either as v7 or as part of v7.1-rcX.
(Whichever way Andrew prefers)

-- 
Cheers,
Harry / Hyeonggon

