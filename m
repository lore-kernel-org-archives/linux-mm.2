Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 786A5C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 14:38:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 929766B008A; Thu, 10 Sep 2026 10:38:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 908F56B0092; Thu, 10 Sep 2026 10:38:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83E0B6B009B; Thu, 10 Sep 2026 10:38:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5F68C6B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:38:16 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E52C11C2346
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:38:15 +0000 (UTC)
X-FDA: 85198107750.03.E46D849
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 504B8100003
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:38:14 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I5pFoW74;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789051094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MK4zUJB9+wzOo/C/BizaklPC9wZpzdasI2Hvs/7YAKY=;
	b=2cGaEDeWq3l0ALzWz91rdhvpBWDcCVJxVvkM7x3FC1N81hnVDtlGPDKnEladU1rPhhaUAN
	TgvQfWUb9XvBgHgWu1epi5gKuq4nKyFdIAMbNWQL66ViR03+EGn1iVHJWstFVRCtn6CX/f
	+yld2MPkc7/fr22o3R7hxUmXCdSeeSQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789051094;
	b=5ejS1WF53USWs41yC77RDNOW4jGWoWFVzc/YI71y6aw0IEZ35ZhY5QSCfGsrtoKNbqHAl0
	PK02ENpxE0gZb4FDXkEN+J+iDeogAJ8AGP/VW98rybKVgDb5bd2JXszSlJIOJIqbFJWn28
	8gBTSaIQUIo00nFBb/ivYSdf3qyoDiQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I5pFoW74;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AF8B660202;
	Thu, 10 Sep 2026 14:38:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5071B1F000FF;
	Thu, 10 Sep 2026 14:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789051093;
	bh=MK4zUJB9+wzOo/C/BizaklPC9wZpzdasI2Hvs/7YAKY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=I5pFoW746SSPNXz9o8Gr2kFBOSCOW/xePk4xTDfyqFgvoAmf0tODgEET0eRkncke9
	 XZfiCBHYBPe3zMjtgMElX9WcKhEFwpWObpy1cDNNXfZ82Q10+JbzOCJjnJSyAnK53x
	 7vuGYjH/35JsI1+OK1y/muHGz9/onzcxiv9oEU+nc6hi8+rY0ajtvZgR1zgS1lrdUl
	 MYlX5KHgZuMvcheoJuo7cNLrgBsMOqearr46U9pUJlt6Hu0phy1p2dpwJ5CUSI15fd
	 AtCXxUto9Jhl3wqLtR0RwSlAn2asx1Z4EZT3Es7V9UREdrzYdWck5ixnGT2gsty54b
	 uZsXfs+QijvtQ==
Date: Thu, 10 Sep 2026 15:38:03 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Oscar Salvador <osalvador@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
	Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-cxl@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 02/12] mm/sparse: refactor sparse_sections_init()
Message-ID: <aqLAplL54O9rpM_Y@gremlin>
References: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
 <20260909-b4-sparsemem_cleanups-v1-2-008fc8d579fe@kernel.org>
 <aqKo5vHZbDhzrUZL@gremlin>
 <44f7ce5c-b75c-4c44-9202-1d2d3a1de965@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44f7ce5c-b75c-4c44-9202-1d2d3a1de965@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 504B8100003
X-Stat-Signature: m75ide8p7aytsqxk7oxrbfd5miyccn3w
X-HE-Tag: 1789051094-849172
X-HE-Meta: U2FsdGVkX19dC4KxfWI7vJT8UadK5pxHReUetpuAzFPjEZofnXFcYGyb5oid91V/0Mxsu2N6TDfjGGp3T4E8kqGoFvIQpkw1UVhItmjpIvtM6v/ddIq/H6su2izzfJb1aFOR34EHIyRfY2whg5CxWxrZ5578Yy02Q3e3/c5D+YYpnaxiVQFANUbtgYPIKrkD5V0/sxInkYVRz4LlDJdlM0rBkiN9bsHmiMXjQJnJbOtvoPdWT730JrR+0a+TiUrPQkW/59HyMjS+Io2of98BdPw7r4jCbtc6ZdDyqY3MP2dhkVobBwqmrB/prEIaLrQuOfJqrootHP1rZewDJHQfIItEwi7DEh8hrYabzcAnzm44vh5vfKa6jhimr6b2omG8dhGigQyJaz9yRdy6zUtp9sAJerD5uj7McDB9kh/QeXMSEoR++313WbhiGLi5C/X4ZVPEonYXPfEehDMML5E0QfnmzZHwYZcxJTJrwprH0G5Efa1O1Ic7SaKGMbI9v1zu/g+2oB+P4+UD+wnAvUIDNKKVHHQ5LOOwgJeT/vO2MwBKx9p7YosGeQmmDYeRI5pMlgeLWq7DVvaV4VuQScZFPQUeNFsLWsfuz/K1Rhk2JNd+jZi0f3cpW8oC7Vyg+SlOyT5iIHIuZCcWVeU3fhwqlltjNltTssa5sUIvoZ0pi26GMYlMIRycikopBacQh5sOd0jcKlfCpX1mIiqsN3Fphlbqc1KhY5cSTlmlP74J86NrITTkwSS87ncE41oTIHcNnO2UshF8URh2e8CiipuKGa8hYl/hajhypv2vZMnAomcy9ZNYdfeOfgwsmsfELJbPfbMwPm3NYobnMxTlUipvPzZ9ZWpW+oOsSoH9+IJD1S46HR3w4fWsAEJEceRKRxiWD/X+tOrrxL8KB1V1PG+pojQdFPYmH5QttMMevwhggj1GXDTi09JMDD8nwdDDSZ03xVYZTQtf2loFv4QNEGY
 c8dsQywd
 TUpbL+LfJDMQsmVITtb9wTSu59cNeHJgZvOLdtqUWb8tjoQ/McXCIMz7x+q7y5KGWko7EKr1ZiZtsPWddPvrK3r/wX58t4PlwW/72JMBL0SlcuDOWKC1K1TM3ux0QdEF/vJaalcrIAfOCpE+UoeZ4uJdSOj7ckblouhcgLY/Vg10R3XkdneZFurMHb9aU/nZg/Pi869Jany+Zxhs1EfMxysa15wEoL3c3cW/wLOCshG9X24cUeTi9MspyitfnidVv/d8zqyMWlLzV9Qn8Jp0FycafNOvhrHOFohfk4D3pZG3f+xdQIJYAwf4qeXPvQBupBAJJUgCPRDL2uJ5jP6K3YnKM+31Qi5/HKyMaNQJFWBcSl50=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 04:30:43PM +0200, David Hildenbrand (Arm) wrote:
> On 9/10/26 15:29, Lorenzo Stoakes (ARM) wrote:
> > On Wed, Sep 09, 2026 at 03:32:55PM +0200, David Hildenbrand (Arm) wrote:
> >> memory_present() really identifies+prepares all early sections so the
> >> initialization in sparse_init() can properly iterating them to
> >> initialize metadata.
> >>
> >> Let's just inline memory_present() into sparse_sections_init() and
> >> cleaning up the code a bit while at it: make it clear that we are operating
> >> on pfns.
> >>
> >> Note that we call set_section_nid() now only if the section
> >> was not already created earlier. Now, there is no more inconsistency
> >> between what we (temporarily) store in ms->section_mem_map and what
> >> we store in our section->nid array.
> >>
> >> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> >
> > In general please keep move/refactor steps separate. It makes it harder to
> > review when two things are going on at one time.
> >
> > But I guess in this case the diff wouldn't be that different.
>
> Yeah, I actually want back and forth here and decided to keep it simple.

Yeah, this one's a bit of a blurry line but I think fine as it is!

>
> >
> > Anyway seems reasonable so:
> >
> > Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>
> Thanks!
>
> >
> >> ---
> >>  mm/sparse.c | 41 +++++++++++++++++------------------------
> >>  1 file changed, 17 insertions(+), 24 deletions(-)
> >>
> >> diff --git a/mm/sparse.c b/mm/sparse.c
> >> index 6a6d258862904..36e3d854febc5 100644
> >> --- a/mm/sparse.c
> >> +++ b/mm/sparse.c
> >> @@ -179,22 +179,27 @@ static inline unsigned long first_present_section_nr(void)
> >>  	return next_present_section_nr(-1);
> >>  }
> >>
> >> -/* Record a memory area against a node. */
> >> -static void __init memory_present(int nid, unsigned long start, unsigned long end)
> >> +void __init sparse_sections_init(void)
> >>  {
> >> -	unsigned long pfn;
> >> +	unsigned long pfn, start_pfn, end_pfn;
> >> +	int i, nid;
> >> +
> >> +	sparse_extreme_init();
> >>
> >> -	start &= PAGE_SECTION_MASK;
> >> -	mminit_validate_memmodel_limits(&start, &end);
> >> -	for (pfn = start; pfn < end; pfn += PAGES_PER_SECTION) {
> >> -		unsigned long section_nr = pfn_to_section_nr(pfn);
> >> -		struct mem_section *ms;
> >> +	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
> >> +		start_pfn &= PAGE_SECTION_MASK;
> >> +		mminit_validate_memmodel_limits(&start_pfn, &end_pfn);
> >>
> >> -		sparse_index_init(section_nr, nid);
> >> -		set_section_nid(section_nr, nid);
> >> +		for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
> >> +			unsigned long section_nr = pfn_to_section_nr(pfn);
> >> +			struct mem_section *ms;
> >>
> >> -		ms = __nr_to_section(section_nr);
> >> -		if (!ms->section_mem_map) {
> >> +			sparse_index_init(section_nr, nid);
> >> +			ms = __nr_to_section(section_nr);
> >> +			if (ms->section_mem_map)
> >> +				continue;
> >> +
> >> +			set_section_nid(section_nr, nid);
> >
> > So the main change seems to be calling set_section_nid() only if
> > !ms->section_mem_map (and obv. calculating ms earlier), as described in the
> > commit msg.
>
> Yes! I also played with having that in a standalone patch but judged that it's
> not really worth it. I can move it to a separate patch if you think it would be
> better!

No need, not really a big diff delta and you call it out in the commit msg!

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

