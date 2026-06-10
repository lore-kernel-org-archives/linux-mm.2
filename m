Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E4E4CD98C7
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 07:35:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BCF46B0005; Wed, 10 Jun 2026 03:35:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36E586B0088; Wed, 10 Jun 2026 03:35:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25CB36B008A; Wed, 10 Jun 2026 03:35:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 13ED86B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 03:35:51 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8AA051407F5
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 07:35:50 +0000 (UTC)
X-FDA: 84863193660.03.CBEB727
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 130F82000C
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 07:35:47 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=igh6hm9f;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781076948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UWlNJsELOJGMZ+FI7OsgS8pm8RymJ32pYzeA2rVYtbA=;
	b=uMSV0PdG4oYuaTXee3PIXdJSHF0ZWYkYbqp5recJ0E/NxykkvUv28mGabuGO0iXwl7KQou
	e/yofKaCXFnPIL1/lvKAr1ks6Ylt3PfbuD8KxB4kkA9FUcLHxZVBBfDHTShIgDTJtTfPTn
	Hpvcjv5i8iTHO1F2v2V5s/VWmHo4bQI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=igh6hm9f;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781076948;
	b=dUQ7lob3MgdDteFIhVR0lfMOutuM0eMSVn85XPLvtYx3bhpcCrnX6NXw2z/YQS4Gkhdw9f
	FnZynesKGkXvreAiFYECj5GPCp6CMRn0pl5qSzu3kyNfqGT3LwAYkcdnWBwF7SaNK0OObT
	xCvRrsD6/ghY9LpPn/A1cwiFuRirqf0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781076947;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UWlNJsELOJGMZ+FI7OsgS8pm8RymJ32pYzeA2rVYtbA=;
	b=igh6hm9f7nUIR9lkZKRgsGien6hCh8vzSIoAhLv+OVq8vaKCiRAhX5vF+80kCOBRwkQBCZ
	G2Ge4z9WoJUaXEB8iy2T1wPOnFDq1ZwcARK5HDY4dOD6FeWpXjtrItTCuLKDQeoZT5Oh6Y
	JQ7Hcc/ldg2M0lxgjeOra5uaSHj/Dys=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-612-PuBjCG3BPVCyyrgIe62iZA-1; Wed, 10 Jun 2026 03:35:46 -0400
X-MC-Unique: PuBjCG3BPVCyyrgIe62iZA-1
X-Mimecast-MFC-AGG-ID: PuBjCG3BPVCyyrgIe62iZA_1781076945
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-490aadb1386so33443385e9.0
        for <linux-mm@kvack.org>; Wed, 10 Jun 2026 00:35:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781076945; x=1781681745;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UWlNJsELOJGMZ+FI7OsgS8pm8RymJ32pYzeA2rVYtbA=;
        b=kA/MnPYh3d5Rf382vu50XLEWFzGUysQIpbB2Fs/LAFyRExHZo+SK6VYt27DUn2mCch
         dlKsC/nT6CMo3PYQz2mCd5gh3N7I25AE+yUbLtafb1Bwf3UdsrU6DNR/ycHCuw0W9/eq
         ylZz+MhUkAGFhf/4FCG9LWL4fdpc7QotDtt8xsAh1h6rYObiRgiRN3DOwDD52aU4V6Z7
         yA2eqqmB1N9XcF2q0Qo7Rtsy4apXy/taJtI1JbEc6co1grFzFxtbtM0GHsi3xky3rc/U
         ykYC0lQMa4c4cVMkHIr/r17CjFcpHIt6Igu0ne+qh6ingsDbbZHQtY8QA/H3xe1JhK57
         bM1Q==
X-Forwarded-Encrypted: i=1; AFNElJ9LUkKr3IrG1wS4lfcthRlgPz/yL/y6PXpt1whjA1e1kt7sEEN4Bz0DJJhDpGSpDV6M4xY6ADgugg==@kvack.org
X-Gm-Message-State: AOJu0YyuwmpyqtyQgLtyAy0DvFJgJH55mgq8dOfRxwCtXcFBw1kWyJX/
	/rWMNycfDnVh756wQyYTGmCktt38VUvnJlpNnatEulR/HnhzvG+qe0Shi4pfOVHTFCwI/NtwHOu
	dhOCPWo6QRdWpncfu8NUVgS6qrDubonKwCJeyDGUIldc3SMEDTX27
X-Gm-Gg: Acq92OEiQeQy73JKA6cVdNRAfcep7xejZXjkKQpbPqbD1dckqeAGCG0PCWJ5G83TS1F
	WyYjKS1ATVPYiaVwhWOsxGkLSCsYg8EnuOw+uYG3hOcKcefZlCukrZ19BlQVeCcA++ptmO91iNq
	iXM9RjEcm3H8cZCofPfb6WvULDdFqugNSVAQeGgGp6HqvDHmOcMcbY+5oGi0KgRodqkfK0Gq/z9
	Xjn3mnEI9tz2sOVay4C50W70BmQiQFVlby57WO/eUCVY341IDdXe5c3wsOAo2s1fZSItM+9yOCS
	TBJ8NQPs6YwEmaTB1UKxP3XHJoACUbtkqMf+8Eaii6iTBaDFOJJE3r5/lZigpVlcDs4wmQuajqn
	L2rj7I+1/u3OooVTjItmNAzaafb89m7eHVxzKpLjY1rNwA5zha7HFdw==
X-Received: by 2002:a05:600c:3588:b0:490:4b89:5372 with SMTP id 5b1f17b1804b1-490c2cf5433mr343576805e9.11.1781076944806;
        Wed, 10 Jun 2026 00:35:44 -0700 (PDT)
X-Received: by 2002:a05:600c:3588:b0:490:4b89:5372 with SMTP id 5b1f17b1804b1-490c2cf5433mr343575795e9.11.1781076944181;
        Wed, 10 Jun 2026 00:35:44 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-85-71.inter.net.il. [80.230.85.71])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc391aaasm627725935e9.1.2026.06.10.00.35.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2026 00:35:43 -0700 (PDT)
Date: Wed, 10 Jun 2026 03:35:37 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: Zi Yan <ziy@nvidia.com>, "David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: Re: [PATCH splitout] mm: memory-failure: serialize
 TestSetPageHWPoison with zone->lock
Message-ID: <20260610033441-mutt-send-email-mst@kernel.org>
References: <df06b66fe4ff8e925ee0714955abc2183a727b90.1780998980.git.mst@redhat.com>
 <20260609111020.e88f51a7b6ebc37360d66fdc@linux-foundation.org>
 <8c1f468e-b50a-487a-a267-8d1ea5a61c87@kernel.org>
 <FB250C43-790E-4AB0-BD40-74665FC601A0@nvidia.com>
 <38C84F23-E881-4DB2-86BA-93F39D44AE1B@nvidia.com>
 <20260609162437-mutt-send-email-mst@kernel.org>
 <4BA276D9-9EB9-4E2A-8A05-657ACACFF227@nvidia.com>
 <20260609165829-mutt-send-email-mst@kernel.org>
 <dd8d89be-9c73-8ff7-7d44-9705bddeda4d@huawei.com>
MIME-Version: 1.0
In-Reply-To: <dd8d89be-9c73-8ff7-7d44-9705bddeda4d@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fwj8dSwvqKwx3RFBKmyx0W7Ra151TkJFvs0BNCEie6E_1781076945
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: pdatg76799kxfm1tbtqmytckrsk9wr1r
X-Rspamd-Queue-Id: 130F82000C
X-HE-Tag: 1781076947-383607
X-HE-Meta: U2FsdGVkX1/VV9bs3E1m1HyzoyUsDAHtimBud1TfayCijWTYO46oIicq3yELz2GHNFu3C5oU0dC4AuW3zifdYmGzXgrQzHpLhkQc9aN9eiHQPczMrX4aK2ZRjQjbYTWsLjWijbEgov+tElNZNSp/WipRPP2MrWqYKfJfAm9wb9xTWz4iDBsjUPPUjchljfCDMtYcPwbBxq4oF9NGXwJtkpU38muyXfzlTrnbKtbTScev/K7Ei4sx8wKCHJXX6N25cg1ekLLHpk5DzGKPZYzDZo/6ZtliJf3CuonrF+ArqVwFRsRneJO6rWczxL8SwG/H5PrQ/0mm792OwI3WOHQlHFahE39dhNrLwiQw5MuPQYVswvkfUY+dLUdv8TPT8tWAqwdFxY+j5wJpczxl9fyChSziZZRPP4tOsKnvlKCMAnBfOohxve5XFsZhFZKUxCUTHR15AyPiJwQOHGxqwsUJAHUULoacaWp0rYU/NGWl8kOkGZ4kU7qHLEJT/suHivL9oDo2aU6Ym8xebpZSdiUTPiiacdZDvDxY8GstcIzzc0sJJrLt8ZuQB3NVikGKHmhYPPtqNtBITyCV7Ac9Pa4uJccAQBVpe/r18Es9c4M/XllmWCEuUMSG2O2v7JSRxOowFTaeZW9R0K8UEVaP6FY2FzkezByjs1ZDwAdzRQ3CWKNcmabo74VOceDoSpDMb+OuZt1pDkabwfWMQEyJfr7apKIrSHNJYU0zJHHfC3IPIURQQqQZU3/M66t+ZaUS2UqtoAuf3o7uZRUnmhe/oCudzx8muD1jKN8J2qYGRG3B8NLcJIXFKCNIvb0ulGgcV4YQx6AV8s78vDR/4biGOpo2r1NcMoRMHjVfTbxyeb5FboR/pQ383qEd3DyBv34sZbCufKUsrVskZfSiDe9ZSYrGylh5E49nNJhgFSbXYYL9tat0i7nsrAxJBNThidEliC4B3v1TTLpn7bE41BcGWCw
 L02wQJkB
 zvFpSsSDXEYroqKY4fd4Uytobll4rZ3vgNs89+LEK92TNU3G/DnnHwmQ3Ii5zqcvr+uJwDSvxEM85lr6xoO4SZJwy9zkxb3PDYAJPZ/LN6hE1swVFwBNfNuvnE7dlLl+1UXF0uqAOaVJSr2ttaM5+n27M88nDQokxC+W8w/6k8Fut9ZMIUZyp93p5CDsa+U0hKIu+fw7oh5hOUczTeJXzOuaYFJNSYhWiODuZO4KLKlnmA9TWJv4cDns8YxgKYIMcmUg+Um4bwRCG8vouP++usnxJsJaEjTOYZb5mX7In4WqAtUedpqnIc0YPBH2AP+NZvu1EX/2LWINuV+7dBVFfzueV477vmPeJ2oOBESUZhGVpIVuNuk0Yp3ILSqoHSOw0Ur1+UJfDAGfOUTAu6JXAckGpxIN0xq9HO3X/gi8QbF/3Ubq1NtA341RCS1yC3rVAxxhm3lvHsY86E08=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 03:24:30PM +0800, Miaohe Lin wrote:
> On 2026/6/10 5:00, Michael S. Tsirkin wrote:
> > On Tue, Jun 09, 2026 at 04:54:01PM -0400, Zi Yan wrote:
> >> On 9 Jun 2026, at 16:34, Michael S. Tsirkin wrote:
> >>
> >>> On Tue, Jun 09, 2026 at 02:52:47PM -0400, Zi Yan wrote:
> >>>> On 9 Jun 2026, at 14:39, Zi Yan wrote:
> >>>>
> >>>>> On 9 Jun 2026, at 14:38, David Hildenbrand (Arm) wrote:
> >>>>>
> >>>>>> On 6/9/26 20:10, Andrew Morton wrote:
> >>>>>>> On Tue, 9 Jun 2026 06:12:49 -0400 "Michael S. Tsirkin" <mst@redhat.com> wrote:
> >>>>>>>
> >>>>>>>> TestSetPageHWPoison() is called without zone->lock, so its atomic
> >>>>>>>> update to page->flags can race with non-atomic flag operations
> >>>>>>>> that run under zone->lock in the buddy allocator.
> >>>>>>>>
> >>>>>>>> In particular, __free_pages_prepare() does:
> >>>>>>>>
> >>>>>>>>     page->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
> >>>>>>>>
> >>>>>>>> This non-atomic read-modify-write, while correctly excluding
> >>>>>>>> __PG_HWPOISON from the mask, can still lose a concurrent
> >>>>>>>> TestSetPageHWPoison if the read happens before the poison bit
> >>>>>>>> is set and the write happens after.  Will only get worse if/when
> >>>>>>>> we add more non-atomic flag operations.
> >>>>>>>>
> >>>>>>>> Fix by acquiring zone->lock around TestSetPageHWPoison and
> >>>>>>>> around ClearPageHWPoison in the retry path.  This
> >>>>>>>> serializes with all buddy flag manipulation.  The cost is
> >>>>>>>> negligible: one lock/unlock in an extremely rare path
> >>>>>>>> (hardware memory errors).
> >>>>>>>>
> >>>>>>>> Note: SetPageHWPoison and TestClearPageHWPoison calls elsewhere
> >>>>>>>> in this file operate on pages already removed from the buddy
> >>>>>>>> allocator or on non-buddy pages (DAX, hugetlb), so they do not
> >>>>>>>> need zone->lock protection.
> >>>>>>>
> >>>>>>> Sashiko is saying this doesn't do anything "Because
> >>>>>>> __free_pages_prepare() executes entirely locklessly".  Did it goof?
> >>>>>>>
> >>>>>>> https://sashiko.dev/#/patchset/df06b66fe4ff8e925ee0714955abc2183a727b90.1780998980.git.mst@redhat.com
> >>>>>>
> >>>>>> Battle of the bots: it's right.
> >>>>>
> >>>>> Yep, __free_pages_prepare() changes the page flag without holding
> >>>>> zone->lock.
> >>>>
> >>>> __free_pages_prepare() works on frozen pages and assumes no one else
> >>>> touches the input page. To avoid this race, memory_failure() might
> >>>> want to try_get_page() before TestClearPageHWPoison(), but I am not
> >>>> sure if that works along with memory failure flow.
> >>>>
> >>>> Best Regards,
> >>>> Yan, Zi
> >>>
> >>>
> >>>
> >>> Actually memory failure already plays with this down the road no?
> >>>
> >>> So maybe it's enough to just SetPageHWPoison afterwards again?
> >>>
> >>>
> >>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> >>> index ee42d4361309..4758fea94a96 100644
> >>> --- a/mm/memory-failure.c
> >>> +++ b/mm/memory-failure.c
> >>> @@ -2415,6 +2415,7 @@ int memory_failure(unsigned long pfn, int flags)
> >>>  	if (!res) {
> >>>  		if (is_free_buddy_page(p)) {
> >>>  			if (take_page_off_buddy(p)) {
> >>> +				SetPageHWPoison(p);
> >>>  				page_ref_inc(p);
> >>>  				res = MF_RECOVERED;
> >>>  			} else {
> >>>
> >>>
> >>> and maybe in a bunch of other places in there?
> >>
> >> You mean for fear of losing HWPoison flag in the earlier TestSetPageHWPoison(),
> >> just set it again here?
> > 
> > Yea.
> > 
> >> Why not do it after get_hwpoison_page(), since that
> >> is the expected page flag?
> > 
> > It's still in the buddy at that point right? I'm worried buddy might
> > poke at flags.
> 
> Since __free_pages_prepare() executes entirely locklessly, the only way to ensure
> HWPoison flag won't be lost might be only set hwpoison flag iff we can make sure
> pages are not on the way to buddy...
> 
> Thanks.
> .

Right so here after take_page_off_buddy it's ok, for example.

-- 
MST


