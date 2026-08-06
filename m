Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C6E0C5AC7C
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 15:15:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A2346B008A; Thu,  6 Aug 2026 11:15:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1539D6B0092; Thu,  6 Aug 2026 11:15:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 069756B0093; Thu,  6 Aug 2026 11:15:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C5C5E6B008A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 11:15:01 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A42ADC07C8
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 15:14:59 +0000 (UTC)
X-FDA: 85071192318.30.9BE6B11
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 180351C0009
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 15:14:57 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XC2JGg+7;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786029298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LNojBxIz0vThpBVl3Qav3XEH341Ryu1t4zQtn8G/oTo=;
	b=W29C8GpD3ZnTvHcBIg+vecUsio1j8TbUzhvzkhamNuHhJ4oIuO79DvJx0HaLeOi26MWcGE
	s6E0gItuws8qN6NQ9ZAK5+NlklpLdNkfkLgTAImcSjPP02fdqFUDH9uii3vArkm3q2ByXY
	elV2PX2DFp3hECLZoECHiR/GVPKV6gk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786029298;
	b=kampU6OOY4b/Wmruv4aTM/i1XudoYBmzx5ct/FKbA/NNseo42lvHjmxL91/PpVt1Ie2Uv0
	lQxHRu+lkWhm3Yzp8KYBLZcPr3QeuO/md+WtHSLRLIkFcNp1zr0yKFc9HKwiKupkqNKE7h
	0+ue2gsLCtnD0BaS2dRJn/Fu4O+n4dw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XC2JGg+7;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 595A360AB1;
	Thu,  6 Aug 2026 15:14:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A30B01F000E9;
	Thu,  6 Aug 2026 15:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786029297;
	bh=LNojBxIz0vThpBVl3Qav3XEH341Ryu1t4zQtn8G/oTo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XC2JGg+7zYOmBa0UGt6iVeCJkX9jXPWxjSpNJo8xy1H2kumCT7sMgZ4NYGQHvlen4
	 catPcK4eznZOZgXnFIDGn59kb3/FeVSCRoNKJNNN1dKG9oplNy9BL0C51WuY8yPTvH
	 yU0OZw0Mi7x8D5Uk90VzypDrlP5ysqLDjKgleGOQkM+axue/IaMdKOXQpcsVK2uC2R
	 XDOsEJWT03bTwMZu53ZlHmnQg5iHkXHsiIVwzDohQhP4Hm18+NIkVLd04owHGPN+fR
	 t9cYsEfsWP8M5Qok+cfbT1XCzI/fNgS06PlSe28vw/D0G//MBXgEQnyPfmz0Px1ikf
	 0qYA/DwSRuVgg==
Date: Thu, 6 Aug 2026 16:14:33 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
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
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Peter Xu <peterx@redhat.com>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 04/15] mm: update print_bad_page_map() to show
 anonymous page index
Message-ID: <anSkIn1fMMN5Zibl@lucifer>
References: <20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org>
 <20260729-b4-scalable-cow-virt-pgoff-v3-4-e8ecfefea812@kernel.org>
 <amrvgjPNfKqWPUU0@gourry-fedora-PF4VCD3F>
 <fec1be38-406d-4656-95eb-048729afec40@kernel.org>
 <anBqV9z6hVLIqoIn@lucifer>
 <anL0LEhb_bp_uQ1J@gourry-fedora-PF4VCD3F>
 <anL7eZcHnM5mPr_T@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anL7eZcHnM5mPr_T@lucifer>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 180351C0009
X-Stat-Signature: pm835i1r8nmf8pdre6mim9cpfx5ztf7x
X-Rspam-User: 
X-HE-Tag: 1786029297-401919
X-HE-Meta: U2FsdGVkX19xdzm4HYX9RqcdVYuOGseVPBHIy6BW4pTJyq6QjP4Si1j8We5FwWkVGYzEFCWSOTErnfNg6Un8tIG2k5+eN3faXTRFOoXFENIfzUAjwu9uanRq4sdA9rtJkdgHod6wxFmThlLMDcqTUU9d6KNP4t3Z28g4ym7tZDk3cq/kesaciC83oqnRKbAj3UBUorQzm1OVf09+QFxG5gUVwxEcd1h+G3yFvu5TEsNymozihrHZfHuvGAAvok/XloU8f62MqZZpu3phNiLge7bI1eS2LN4l9UwbZwt97F6kdjntyi5l5R5q9l2PutQz/hWWtKESVZ6GT+NbLfHwZfLeTT/FYypQaVCEG0v1oYXQ6Nsnfuo+B2qpIPbkfaeRc3dbbNnrkYSGhNq4Ab963b4UHjrcXYId1TVBU+jELONY7wINAzHbHjEPysTz4Nd8TlsOT9PVXGON3RDfCmIpExkrQwZyp4I3XGyPjMy4r1SxwK68T7MMDLC6BplRgHbA3d3jyNgCrpwHnJng5cXJ+mXA8OIlDqkX3tZI27cPnaneUIUblvuxfmshKNoyFMbd0yj77u1Q8d5Fusm9nSRs9KQ1P8ng8YZbyqqn71nlMoRD2g0mSHB2SmZ3U4OqqxeAddVEsa1qTdQPI7Fg480podrLuxg2C/ciSuiEdA2ybxNrUzi9KRFzo20H4EiddWWbm0CnueWEyr6BLgHTnow3JtgQ4qUsrL2pwxSdM2Xdx5zhMNF6kgfPbo07Bn3n59SxxWSVLNrqq4XaX1vALnjq8VzlcXXbq48xbnG3wyYhQMBUSjS1v9PD6rMGwfAI9XPNFn/lrplGtjDj1NwL/0SxDc85SJtT8odlsJbmnHufqnw6mA0PnPsxAw6aqtkP6AyUdXA5lCxbvEqLgqakHYlUaY4encdGvPXhhKqyzMCq8Ng7NYTg6YElGirtv2Sb651NWaxmSjxchAYDRKOxel/
 0zh1+gWm
 Ulmo6mLAmbjKKrEVOi8GGS3olZ2nLsgBKuQ9PM2mGcq2XJT79qh+M4Kvi9k8H+lPu5r6eA5aL7SqRNi2Or68iYV7umXqoOsFHyyah/x/0SAB48G4EIHOg7TP1Ob5mezI6I3e2At9ouh86eV/IBNYisP76XrHwPfvQUkcBkWolVzNS0mZQOoIHIzdbYQm9/Po2PfFEw4rGAFdEYSkEGdHFM8IvtTbtoZi/E+n+Ttvq7E2O8MK3PbC0bwu6/GJatYQc2/HZYaOyjBnfjpczotb/Ri+KiO0yuRYdej9SZXgo7c36Rzf1q5/Tm7v4PIuykb7oluznV6xPGuCI7Yb/LuYvnjmsxWgjLa4BFCpcn5C169K8MTdGgI4+PDPrWQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 05, 2026 at 10:01:52AM +0100, Lorenzo Stoakes (ARM) wrote:
> On Wed, Aug 05, 2026 at 04:30:18AM -0400, Gregory Price wrote:
> > On Mon, Aug 03, 2026 at 11:19:17AM +0100, Lorenzo Stoakes (ARM) wrote:
> > > On Mon, Aug 03, 2026 at 11:39:11AM +0200, David Hildenbrand (Arm) wrote:
> > > > On 7/30/26 08:32, Gregory Price wrote:
> > > > > On Wed, Jul 29, 2026 at 05:48:39PM +0100, Lorenzo Stoakes (ARM) wrote:
> > > > >> This is potentially useful debugging information and matches the existing
> > > > >> page offset provided.
> > > > >>
> > > > >> Use the raw __linear_anon_page_index() function so as to always output this
> > > > >> value regardless of whether the mapping is file-backed or not.
> > > > >>
> > > > >
> > > > > Begs the question whether we should mark the value based on whether
> > > > > it is file backed or not, but i suppose you can gleen that from the
> > > > > other printed values (anon_mem, mapping, vm_ops, etc).
> > > >
> > > > You mean something anon_pgoff_t or what did you have in mind?
> > >
> > > I suspect he means e.g. adding a (A) suffix or something? Like page offset xxx
> > > (F) or yyy (A) I guess?
> > >
> >
> > Yeah just an F/A in the print I suppose.  Sorry if that was unclear.
> >
> > If it saves someone the head-scratch of whether some bug is because it's
> > "file" or "true anon", given the ambiguity here, seems like maybe useful
> > debug information.
>
> Yeah will do on respin I think actually!
>
> I do think not providing that could result in some confusion like 'hm I
> thought this was file-backed'.
>
> (We've made our lives hard with varying definitions of 'anon'
> also... [shmem being 'anon in page cache' is especially lol] so it's
> already confusing but there we go :)
>
> I will add a comment explaining things so if anybody still wonders what's
> going on they can see what's up in the code.

Hmm actually at this point we'r printing a bad page mapping so don't have a
folio to know whether anon or file-backed.

So probably sensible:

	!vma_is_cow_mapping(vma) 			-> index: 0xf00
	vma_is_cow_mapping(vma) anon idx == file idx 	-> index: 0xf00
	otherwise 					-> index: 0xf00 (file) 0xba7 (anon)

Will do that in respin.

>
> >
> > ~Gregory
>
> --
> Cheers, Lorenzo

--
Cheers, Lorenzo

