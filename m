Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6D51CD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 20:34:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97CE36B00F0; Tue,  9 Jun 2026 16:34:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 907726B00F1; Tue,  9 Jun 2026 16:34:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A8196B00F2; Tue,  9 Jun 2026 16:34:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 698F86B00F0
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 16:34:32 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1A3921A05D6
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 20:34:32 +0000 (UTC)
X-FDA: 84861527184.08.AF245E8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id BE19C40004
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 20:34:29 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iN9QJQlh;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781037270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4mpHDCXlfPC40orLRXh0LNnJgWxWBHHqm2OypJ1ZmuY=;
	b=ifdvfuGcepgDmTvDcxamoRcan0vtM6iZvXDnYVRzVLqEzsq5JVST8D5trgT0Glhj31m98q
	IZEdaZwRwhU37rjnb1i2INl9mp1d7VGixG5L64vzI+1kapuEZ6rEQaxdJZsqEIWohUdNnS
	DqCULdKy+ZXR5EbtgeQChJ0cFHeUCP4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iN9QJQlh;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781037270;
	b=jV302ee2e8aXEI02y06vgzAdM+7nHX66PnVu0/Bs3yj7NLq8kPhmKp23/fzLLaqPaTtxO8
	q4yhxqUyxlUhLHTjtu32ZFUU4BWsr9szOIRhPD9Os9Mu55A/KhqGSrGPvTxqm5sWIPMQ/O
	7a00WfbsEcykS/IMIDom5J1L9GA4Lno=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781037269;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4mpHDCXlfPC40orLRXh0LNnJgWxWBHHqm2OypJ1ZmuY=;
	b=iN9QJQlhpjoVm5lQDiDmG8Mdy+bEZFeq4clyfIaj3wI2aqq+3/19LlwVeDl3ZZNgpZj/FI
	nTEk0viUKbFROk1GUFdoWP56vKJrKh/0JOVdlgmr54V0pXoNzUKiv9Kgk6Qt8nR5pVBiYq
	Zjvngm2DwamzMiJkewUO2qJ5fTthQtk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-97-XnYp4kSWMI6G1f1dgbxekg-1; Tue, 09 Jun 2026 16:34:27 -0400
X-MC-Unique: XnYp4kSWMI6G1f1dgbxekg-1
X-Mimecast-MFC-AGG-ID: XnYp4kSWMI6G1f1dgbxekg_1781037267
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-490abeb7298so62416515e9.2
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 13:34:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781037267; x=1781642067;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4mpHDCXlfPC40orLRXh0LNnJgWxWBHHqm2OypJ1ZmuY=;
        b=TjKqqrxxaA1g/yMrcz5NKtglHIlLjnrkSXFpDfzlGGsnSuyFEV0OvW7DPeOfacwMpd
         UgvBKySKM2vzRqL20aFDE/4j/cW2nGynmowm8h4Ya8LVZDv37YlA/YWJWDNLgt+aP/q8
         36yILZBljqqNg6723sEbA+b/77n5NH3hqUNyooI0RHWiqLr9D3iTkSIaai8AeW9MzI2k
         80mPKwh0oroofHqWEmWR4qMo7hNXR1/F+BzmyXyyWqNicTZDLi1DhXp3HEJ58hM2xwjD
         uOolJjAeE7NbmMquisNfOHqm3vB/KdttTXeGyc0FmtnvUm6czhZlrmZyp7M8wx7VIg6L
         GSIw==
X-Forwarded-Encrypted: i=1; AFNElJ8AFMuLwaq5tEEfmRACzSBUbd68nkr17QLtmbJfDY2SahKgpnKRqdBz5xDRK6DPJISU1u9YheA8SA==@kvack.org
X-Gm-Message-State: AOJu0YxLviFQdTP3IVYsIz/jCQEucSzvHFarU9Ev5x8arzwwQJ1in6Y8
	wczD/wotRaI/RP+afywK8dinjalTN37TrQK0b9fTbk5n7CXD9v/G+kyfvKlpeM+FlTkb8iIkCel
	PCwgkxDm25Xgc+tlqrTB/rW3OUgQEZW/sX2nei+Wz09HpXZ81uf0j
X-Gm-Gg: Acq92OF+XLTEq7uWoy9DfriE+jn7dI0EsR5XDmibII9srjJDTqBvkICJX35LSeDSdEv
	ogLte8Es25rzLINnAk0tsNo9b2VPzm+WRV8YB+IT8YPm7ndunN3a5hOqSMw4JVnnL3HJ8NuYO4c
	0ZfDGGClCdhAK0DmHWRLrb5+M+HF8PXRWR2Ucf3HZP4J7o8nwY2X7xxdXnb5FNlSV8Sp3xaAGYj
	ka3Z6bWZGiFwyAOpQaAa6KA+8gJayYxwar3OeEGLc2Zq0gdGkh3RNUcA/cOOaoOaXlWE9OJ34fN
	sJpRsyfhR1bVLcFJa2YdhZgJuWU7nJmX+Nu01LijxP28f1E1ta1P4AsoUWs14rJRWewUimV6QBR
	AzO1hxDM5HqiiGBineAVRy2WkE8/usOWH7jGzxRBswC+wDCIKEJrBAw==
X-Received: by 2002:a05:600c:3f0e:b0:490:d38c:7836 with SMTP id 5b1f17b1804b1-490d38c7867mr111793455e9.3.1781037266601;
        Tue, 09 Jun 2026 13:34:26 -0700 (PDT)
X-Received: by 2002:a05:600c:3f0e:b0:490:d38c:7836 with SMTP id 5b1f17b1804b1-490d38c7867mr111792775e9.3.1781037266071;
        Tue, 09 Jun 2026 13:34:26 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-85-71.inter.net.il. [80.230.85.71])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490dcab44dfsm1176375e9.2.2026.06.09.13.34.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 13:34:25 -0700 (PDT)
Date: Tue, 9 Jun 2026 16:34:19 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Zi Yan <ziy@nvidia.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
	Jason Wang <jasowang@redhat.com>,
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
Message-ID: <20260609162437-mutt-send-email-mst@kernel.org>
References: <df06b66fe4ff8e925ee0714955abc2183a727b90.1780998980.git.mst@redhat.com>
 <20260609111020.e88f51a7b6ebc37360d66fdc@linux-foundation.org>
 <8c1f468e-b50a-487a-a267-8d1ea5a61c87@kernel.org>
 <FB250C43-790E-4AB0-BD40-74665FC601A0@nvidia.com>
 <38C84F23-E881-4DB2-86BA-93F39D44AE1B@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <38C84F23-E881-4DB2-86BA-93F39D44AE1B@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: IzjLYU20ZnT5mwrGNzjhG19ZWKyUk_BS1J3NPr4ogEs_1781037267
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: BE19C40004
X-Rspam-User: 
X-Stat-Signature: rsprtnudn6qibtaxsuica7n54zpedido
X-Rspamd-Server: rspam09
X-HE-Tag: 1781037269-212854
X-HE-Meta: U2FsdGVkX18I7IXKXZccy5BIvyJUR8Z9BjnSEYCHNAgulvzs/dL2kNMuOePYHyS5ZzcbOtWryGcgjt3qditNhS2UVbQZBQ0wUCcufrZmcDwnsuMfEt/ok1MAM4CZrA1b9gvlOK3ofLfESodjExyYB8XFLSvhIUn7oRnAyK+o61dkKH8WrCmhVe5GQAJpV30yt09nxEwdcqVPQwiMKFwJdLqkcI+Id2acmN3sfgn4lby6PUfyXPAxPMjcjPbxHWPcJCY1fEVQqfT2mHmAKLsJjb5OJfW9nWuBPvZLoTa9Y88qVRE5X0VT28We7g/M/f/iNcmEuYvf8Qud+Ddx8MyjkGRPpcfhHZN3gsxeBPlQZOLRDDdprmyePr2jRj9EXAVGvqKC3uan+ki2g91aofG3OUFcHlmU+y5pcfRWKKwwW3t58ZY08Di9rof/e5jTYtbS+rbd37ewU30zZU+rKN3xxTxBw45yJnmEYki2C+cqttINlBviTN6DlEKiXbuUAzti/T/IWfVQYSXPG3z/TOzb1Gxh6wOXxJI4Qdqrno5+8m1zMQ2MyNo2O4Cr94PaawG5+NO309DmWqFMoCzgTTGQ+bPM44HvNT0ROiQoIc1vbJ8dVGRIu6MR/xLx+H4uhg1Ppj+zoeACZf1yeMvstJjFmGlMoMy2xwWelrLee9+/Z9CwKai4yyJmkwZVvDXCi3iIGPPFKjGkGtBFD5oXjJvssA4WnDbNH2wqtyaVdTe8bLUOuE7pQ7DCVIpHk+MCY7b0YREcCbDwRNViP84/1tRcoYHNkbeZD4nK5bZQdF2NKlp1/WwTfoEPy+o2Ay9ZW41QFQYKrRAinu4gqRvPwdkQ4V7iQaVtyHdkOSoCCBFAeFUnuNV4rlBm1jTud6mWQYFOj4u9dnmOHs2eq2fIOJic4RRjrl3LG9fbqo5HIjqJHvA3LTS/21pXCaVnO0Ia7APWcjKWP2P0SgBpNKw4jW3
 R0/a/gN0
 LwQ7624Quz2BbizhKAr8XIPRYq0aGRm3A85fhbIJPboD3xxh7CF9LiY2VqmLtKARN0kbZiQrLcCUa5UhacRFVHLN1OBO2ImV7n+cnxPj/pIs7/h6N5WJeeoTiXVZqnU9vaaIJHRS2Xm0oQ8en5+bSzR66GRnLth8Y7qUQcvNusq3MEwzXypysWe/i1YDSU422tGQ6x5DuGVMaZ2eiUFEeefRJGktgjr9HI6foMeJDV5BWmgr4/K727S5Z0F+CDeD8ewdQTpE9QeDkzyCBaxx+gGHYr+1ijVEFYNqqBOOsd4t9/jdSaSQz/oKUk+U05AcSZXWI/mk/Skii2XHRtGagsn5iiiZiTPNTgB7LQCZZi7ZmaHXkwVlO3uMZCSJvC5yc2lldXlBTtjicr3UwoDtvGWWGV3CXYMHt+CH7slVu08TncFML1WavfO6uF5v0Snfz6IXnZJByMFfO0As=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 09, 2026 at 02:52:47PM -0400, Zi Yan wrote:
> On 9 Jun 2026, at 14:39, Zi Yan wrote:
> 
> > On 9 Jun 2026, at 14:38, David Hildenbrand (Arm) wrote:
> >
> >> On 6/9/26 20:10, Andrew Morton wrote:
> >>> On Tue, 9 Jun 2026 06:12:49 -0400 "Michael S. Tsirkin" <mst@redhat.com> wrote:
> >>>
> >>>> TestSetPageHWPoison() is called without zone->lock, so its atomic
> >>>> update to page->flags can race with non-atomic flag operations
> >>>> that run under zone->lock in the buddy allocator.
> >>>>
> >>>> In particular, __free_pages_prepare() does:
> >>>>
> >>>>     page->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
> >>>>
> >>>> This non-atomic read-modify-write, while correctly excluding
> >>>> __PG_HWPOISON from the mask, can still lose a concurrent
> >>>> TestSetPageHWPoison if the read happens before the poison bit
> >>>> is set and the write happens after.  Will only get worse if/when
> >>>> we add more non-atomic flag operations.
> >>>>
> >>>> Fix by acquiring zone->lock around TestSetPageHWPoison and
> >>>> around ClearPageHWPoison in the retry path.  This
> >>>> serializes with all buddy flag manipulation.  The cost is
> >>>> negligible: one lock/unlock in an extremely rare path
> >>>> (hardware memory errors).
> >>>>
> >>>> Note: SetPageHWPoison and TestClearPageHWPoison calls elsewhere
> >>>> in this file operate on pages already removed from the buddy
> >>>> allocator or on non-buddy pages (DAX, hugetlb), so they do not
> >>>> need zone->lock protection.
> >>>
> >>> Sashiko is saying this doesn't do anything "Because
> >>> __free_pages_prepare() executes entirely locklessly".  Did it goof?
> >>>
> >>> https://sashiko.dev/#/patchset/df06b66fe4ff8e925ee0714955abc2183a727b90.1780998980.git.mst@redhat.com
> >>
> >> Battle of the bots: it's right.
> >
> > Yep, __free_pages_prepare() changes the page flag without holding
> > zone->lock.
> 
> __free_pages_prepare() works on frozen pages and assumes no one else
> touches the input page. To avoid this race, memory_failure() might
> want to try_get_page() before TestClearPageHWPoison(), but I am not
> sure if that works along with memory failure flow.
> 
> Best Regards,
> Yan, Zi



Actually memory failure already plays with this down the road no?

So maybe it's enough to just SetPageHWPoison afterwards again?


diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index ee42d4361309..4758fea94a96 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2415,6 +2415,7 @@ int memory_failure(unsigned long pfn, int flags)
 	if (!res) {
 		if (is_free_buddy_page(p)) {
 			if (take_page_off_buddy(p)) {
+				SetPageHWPoison(p);
 				page_ref_inc(p);
 				res = MF_RECOVERED;
 			} else {


and maybe in a bunch of other places in there?

-- 
MST


