Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 005BBCD98C5
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 21:18:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07BF06B0005; Wed, 10 Jun 2026 17:18:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02CB06B0088; Wed, 10 Jun 2026 17:18:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5D036B008C; Wed, 10 Jun 2026 17:18:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D27846B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 17:18:18 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7182740276
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 21:18:18 +0000 (UTC)
X-FDA: 84865266276.04.8D208C1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0150514000A
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 21:18:15 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Xl3zu0tf;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781126296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ogxStp8nRv8cnMLFF2j3tzHwMzkF6jWJBUj8HHORbZk=;
	b=Effga9Exjbex08n9ZbeNkw98beo4SHNMPzvv4tro/epSpPi66unpsXlLkOFHpb8ItEyc98
	FKc80uy5OMVfgoVsVD2Nil3ffNX/uZ+5sRvUJ6RY3dO7LjoR7LolfftE/D+hvLVPfP/OJM
	GjAp0aJT95KZpaSAnKvnlKdxHymkKAI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Xl3zu0tf;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781126296;
	b=LvXEo3ZSSatAuQoOeLQeZbr7W/e2yxwjvNGSIDvkPTpf3pLQhCHP7ZH0MG39H41Qq3FXgS
	cnQD94Ej4bkrrqjjP+AhUdIO/A2Pv+clJvZn9uxTv+t8hDT/wQj/vAX18lrvLlHNb6QQuU
	L0rN4RDKerWY1XmV76Z06YNy3/4Cx2I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781126295;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ogxStp8nRv8cnMLFF2j3tzHwMzkF6jWJBUj8HHORbZk=;
	b=Xl3zu0tfeniBoMjjyPz7oPRplRLBXlWX09b1/ViEdgm56ocxs1lSHIHDZ5jqSS0a6Y+1N9
	ddKJkKhpDefK5KQd/8/zSfu308u0V6QqPk8YHdxJ+c0zILKKpNkaUn2EEBeQUywmkr2cLR
	Gy1VoVYp6BO6jK6gS48DDL3v1IeJGj4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-656-DAjNgtOkPTumi-iJBpxqVA-1; Wed, 10 Jun 2026 17:18:12 -0400
X-MC-Unique: DAjNgtOkPTumi-iJBpxqVA-1
X-Mimecast-MFC-AGG-ID: DAjNgtOkPTumi-iJBpxqVA_1781126291
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-45eee3f9f03so6945039f8f.1
        for <linux-mm@kvack.org>; Wed, 10 Jun 2026 14:18:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781126291; x=1781731091;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ogxStp8nRv8cnMLFF2j3tzHwMzkF6jWJBUj8HHORbZk=;
        b=mXcS9227H7JqjzptJkcZcJyvPf5OL4fveWYsJs5TdTQJsDG79bNoe9BlPnx0RL1oo6
         8ljrXIshgiE0xjjI2/yOe2ysdrra3Rwei9EWpt5ImBINcjjTOOg/nDqkRkrgesiTu/cU
         1sSlYRqRO7PhO4zgjJ7OO3Y+7rTkSykromfBUvExQY/UBILj4u05L+iR5j/3zyLPEuui
         k2dovfm2ViCu4WM1GlxkT0wd7Rz257CV8lCQ8EMjZJTzY/Oq/jG38nE7sU4xiWexQQAD
         /gwFXdKywLhcjDsPJwZIxZ/jcoN1q51inXNygLnsHmBqjKjR4Ewu50PnAXV7kTDW/3/7
         g6RA==
X-Forwarded-Encrypted: i=1; AFNElJ/h4XqzrXgXt435NpONFhi4myy97qLHkBkokq+hJPJwULYyewiVldm6Tz2NJ6RObGieiQRlhMKxbQ==@kvack.org
X-Gm-Message-State: AOJu0Yyah2AqIQOx45vOQqYKxsemMp/cQj4zSyfqTvg4/3rSmg9KWuXs
	B519AZYCp+xBg1+w5o2bwbNcmULUa2dCiUXThpoH7citMKZApfLTWaIxbz2BOZqyvUpJ4ZPCGfY
	Yx72FViNBBpJOXFXJ2aUME3hy5h9nsjLyFo8hBupDttgk1yCQOrNe
X-Gm-Gg: Acq92OF/2Fbc60Ul6u5U66VNQu3Q1JSkCIcfFTv7wv0pUNI+6DlbrmggEdlYVkiO0Vf
	ChTNNGNY8VDp837+mHk3U1Ncvow4JxFTFLjdrGncvLB4dC/eYCQTgNBS43tJZpPknkwT6nKT0MK
	7j3iSunG0IF5h1CQdVPbbJRGs9MJhYUw390b9Axdxg5EO0vDel93149aU8i5HiYu2ypWa7XEvdm
	7ojUL/EHVmRs4HDEaWxE3OPN1HFCNg81t2mBIYuTBQG1upbFMpA8CbZyilCK6N/Si/c3gUtqIz0
	gNw/H1h+P231cMDzrR3ZjY8XZku6wx1KxDTS0yujc/tfkm8Fbp3XmG/hQSDksLzHynyyu3AHUdA
	n8tRn0p/BIAEZCGYvi0LmSdogiipi2VIxFC8gc2adFLpZN7d8CKzGeA==
X-Received: by 2002:a05:6000:b91:b0:45e:f266:f4cb with SMTP id ffacd0b85a97d-46030506089mr31518409f8f.22.1781126290787;
        Wed, 10 Jun 2026 14:18:10 -0700 (PDT)
X-Received: by 2002:a05:6000:b91:b0:45e:f266:f4cb with SMTP id ffacd0b85a97d-46030506089mr31518369f8f.22.1781126290292;
        Wed, 10 Jun 2026 14:18:10 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-85-71.inter.net.il. [80.230.85.71])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-46059346676sm13505910f8f.26.2026.06.10.14.18.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2026 14:18:09 -0700 (PDT)
Date: Wed, 10 Jun 2026 17:18:04 -0400
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
Message-ID: <20260610171646-mutt-send-email-mst@kernel.org>
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
X-Mimecast-MFC-PROC-ID: -gKgNVvok1TD4DT3qCTgy09AvyC7TIK2iRoM8eoSB8Q_1781126291
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0150514000A
X-Stat-Signature: 7atew861mpym6wrnmh8jwk59jwg7d6pm
X-HE-Tag: 1781126295-229169
X-HE-Meta: U2FsdGVkX19VT4A/JC59erqQs0c6cIIG8eVJuRPZyjxeSW5Xuy8EhbQ3sa71B+yOBAsKuNb9uIEB3TBn7mMXqX+dOQAgYgSulryB1c1i7TJQNz23VkJ1os+gqNPBKvtm/b2ZBkV/gb5bG5SncUd3o/yrzh/deYWZEvoN2v+qz4zKcqjOFWSXDpj2iAmnS6UVQeOXkxIijBXqsrly2svyxpOZPyDZzmzpuUvdqfx5qRdQo+THQkKaH+51XLoORdqnhhkXnjXpM8smuRc+zX9NRRsDAWMt6RrV6sVr7t/yN8wj+3osk8h+0QNkn6uQplsk53gWJiFoaZae4HtodXP5WR7/TAp4jda/4n0ZSLOhI3ty5KImSzi5PVJ6ZygZApVTwqalvnACYVcs0c1GlO7ss38bsswn5Mt8rCXePuuGARbt5ZwbZuiag7BoHsPkRkjJ7jfPfFuBL3fFsedjnI0TxzPX7OQ7zG2KQ+TYkF++WnvmZ2pTk8m3HyQrgqf3T7WVEBO3KRafjptkAh2EQfe/YPxdtVddwrjA6T+JPbIGsWhv9bJ70Agrlu9QzXafVO3rFowbSQTMdfNYq2hyC8KddARBtTFzPAuNtIWzQSQ21zJ1QM7DhIyY1vo48s1Qal4R2/8nLm97AzjAIrUACp1Mj8/L0lwwwgjFKzqqMNnxi5m41UvTg1W1FGNPyFNn5cZilwXKUVUiPZfkIMs+cV6b7cEaqbxnxoLMjbqZ9CJkpwLWmpG+F4EMuXiwKKJ27CIV+X3WTQMHdRXfQFEn5aMxI7bgT9QMT30W7ibaNbsdhwIa6hGMqYjdMLsGPlZSYp/JHDA5SWs9zY8dJX/I1BXvg8rsHakuwmusvzqXaTcWwKTjSXgq7wEvJO8i7/ojvpJsEqscYiXN2hr2VGWvplirLs/jgDBFmy4sJtrxFGXB9GeSVcHSROOcpD5jgrCD0nOM6O2mXJfJj+Eu5Q36tRP
 AbKbR9Yy
 ZWXiq4xSOXEK8/AEcStjMqVmEjLPxgp5q3sg2oPfOvLXyIaGojBDt0oCdCC+qRtcN0ALmrdHb8B6OLL7IF5OqCDWKpZw8XHjmp0Y/+1rSHv4sv/s+6hIpm2Sd3oLrQxx3WuQV+PKU26nlKCEVqHe1LniSrKznoX4FSB98o63yf7qOjvY6ij2k5bhNGFK9KJNDq7MvKUja/YeKOHuyUGa2FUAJejQARiHHglIaPTnthHNJwI9aaTJiF0uY6QtC/5OBk2hO/UuuqDxV6BHo404wwu/4YOR6EfN3H9vNqlK7Q0/C19G5T/6ChGi0Fz3mOJ1WMps/NbA59L/pQ/Mm00L34LrwxzOJssQvEnbuoC7+Axk//LoXjmkcm2EZXDTtQR97QZEyEDU273FDWN2h3oVq+RR3dSozg4YjulK+g0qE4D8+iG4BSCS8DjDEwERQ790L1vVOvJYiqO9M0Ks=
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


To clarify do you not agree repeating SetPageHWPoison is enough for
this? And if not, do you have suggestions on how to fix this race?

Thanks a lot,

-- 
MST


