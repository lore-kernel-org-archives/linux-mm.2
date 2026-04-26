Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F388FF885D
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 20:54:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C60976B008A; Sun, 26 Apr 2026 16:54:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C115D6B00B6; Sun, 26 Apr 2026 16:54:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B01D26B00B7; Sun, 26 Apr 2026 16:54:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9EA9C6B008A
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 16:54:48 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4F4A51C0680
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 20:54:48 +0000 (UTC)
X-FDA: 84701911056.13.E8E2EF9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 00F691C0003
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 20:54:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AsIJj3Bl;
	spf=pass (imf18.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777236886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F7ngkkoYTFNaoszFfXjnqMQHnCI7xfB39TzmshJL6/Q=;
	b=tqtDQtcrrJoZKS51S60eU87fqtFVVgnNPx3eOT8o0sIkFnxZV3s3fBn+Zotg6Ks+0RYHza
	DU16SU1LMY4eemK7kdr3h7RhrAFFxlLAPto7jIirA3tsE4ViVavEcaqf7loe4ywZAapNIa
	EC0ZvT3i4RfB9wzohwwB+5Rjp6GUrOE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777236886; a=rsa-sha256;
	cv=none;
	b=doO6/JrpfJ66uIaP1W25QYH5mMVVJ4nUfKxMebrYlB3h/6SGYx8g7F3ekAumCO8/98vetL
	W+bghL8JoG3r+m6df8jBA434RPivnOVdMyS9EJeaoP8Rokf1BFlRI1m5EMmEq35oX8ibX9
	eEtED6kcUCn48Yz8JlM5lM0Dm6tzAzc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AsIJj3Bl;
	spf=pass (imf18.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777236885;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=F7ngkkoYTFNaoszFfXjnqMQHnCI7xfB39TzmshJL6/Q=;
	b=AsIJj3Bl4555v1QiDKCLiynDZxxG/s/bmorNrGecz2yWnz7lwFcJ4SrgikwC1IwqiVH75M
	/CYGnfaHsTZTjSlV55RRPY7ZiIE1VdhD9LrEendEdL69cORZtC0LSfkobWmBYs7hQlcWxf
	cTzI0y+gr1RqC+laD4NW4FBZ4C7SRUA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-251-Yf_qz0MyMSiXyx4UYTQnug-1; Sun, 26 Apr 2026 16:54:44 -0400
X-MC-Unique: Yf_qz0MyMSiXyx4UYTQnug-1
X-Mimecast-MFC-AGG-ID: Yf_qz0MyMSiXyx4UYTQnug_1777236883
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-488cc31ea57so73779225e9.3
        for <linux-mm@kvack.org>; Sun, 26 Apr 2026 13:54:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777236883; x=1777841683;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F7ngkkoYTFNaoszFfXjnqMQHnCI7xfB39TzmshJL6/Q=;
        b=eyCDiqcj84QsWxK4ypBT/zU+j3Rk5CunXBsfbKKtgZyX0uAEcB9G9ZLbngjJftgV3v
         K/6DZrk8ZfDHZPnXcyhTnTi45HpbyD1o5uyGYtPkFxHAo5CLO8W2HUj8DbMHFmemfDf+
         Qhj+IWSyXdORgQjKeYHaJ3esOWcbz5YzRipgkKC+xDfn9pKfox+bSbO47yWt8pnepyLO
         WRh8+Os/UGlhja4PuuQ1AI8IH0HtF9blREBiOiXrcJhdY3RKFM2pRDfN67LZOkWyfirW
         HtCVUsKoX/4oJNrWMs8KhlZ8Mac4ypigHQeZmCqx/zVzdjSDgNPUaL3hKjgBWKkKCneM
         01wg==
X-Forwarded-Encrypted: i=1; AFNElJ9fJm/zFtKaQ9IC3WOEooweoTT3PoQp1KjSCYPG7yJfhuLnUem4EojZaDr17FvKcwjpA4RyJVssRA==@kvack.org
X-Gm-Message-State: AOJu0Yxq/tB1Ep6ta1ens1RB5YD0vCZw8ycIYv20yAvnPuIEzNWjYqAg
	GYblMh+8Yzj/eGkC4czuQruP6aubGJGig2176zzQd7mi7HGqSn3G+qo51Acu6t8r/5dWaCyIB5c
	va3b74qqK5ZiBnTVEFwndujs8l9x4Wv5eZ5lKessSUYYKERJZ9R5b
X-Gm-Gg: AeBDietkdZ3EJD4bHimjoL1wATxS5jlJGgztKjLCTF+EG19Au/5c+pI+FjGaL5MwtYg
	kJY6vDVt7Xn/UoHZDEj7jotTa+PjHN+avDq7ZMhAFO710Wml0jpYPY3jl5K3HEA3xzfWpQC+NXR
	WPdsP0P1T3OeiI/D4WQ6ZAyICSFD8Rm8m3Ay2xpc7zb3OKHaNiSqAQJXI9Aq1JbNMkznv0P1lmV
	Tbbc8FOyNk6fNDvmaf3sbkBTc+cssmMDVKE2uXQgo2vzxLOFU5/qeyI7aCebfQUnNydeIbwCVpp
	A7IYGAkK2v/0kYKFoEysA6MpNpIYSS2Ca1flq1om08QQbd1obM3tCIlhXfEZtRoBxOdssNbuaeN
	mqAVDsqv2JNP3MCNZp0wK33Y6f4VKsZz2T0IIsqxFNmK4GvMb2qkTXtUR
X-Received: by 2002:a05:600c:3e0d:b0:489:6c28:dbc6 with SMTP id 5b1f17b1804b1-4896c28dd4emr413474195e9.31.1777236882614;
        Sun, 26 Apr 2026 13:54:42 -0700 (PDT)
X-Received: by 2002:a05:600c:3e0d:b0:489:6c28:dbc6 with SMTP id 5b1f17b1804b1-4896c28dd4emr413473955e9.31.1777236882086;
        Sun, 26 Apr 2026 13:54:42 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-47-179.inter.net.il. [80.230.47.179])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a5c24d82asm164063795e9.7.2026.04.26.13.54.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 13:54:41 -0700 (PDT)
Date: Sun, 26 Apr 2026 16:54:35 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Hugh Dickins <hughd@google.com>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH RFC v3 01/19] mm: thread user_addr through page allocator
 for cache-friendly zeroing
Message-ID: <20260426165330-mutt-send-email-mst@kernel.org>
References: <cover.1776808209.git.mst@redhat.com>
 <9dd9deabd42801f3c344326991d1431c3d8db39d.1776808210.git.mst@redhat.com>
 <aeu5P1bZW3yEH54t@casper.infradead.org>
MIME-Version: 1.0
In-Reply-To: <aeu5P1bZW3yEH54t@casper.infradead.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -nFVlSfTIXGXs5SOPEZvJW76wGhnyI0BF9fdofo52c8_1777236883
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 00F691C0003
X-Rspam-User: 
X-Stat-Signature: fznrs3oqbjbnmqapo9ojbexduayk6tx3
X-HE-Tag: 1777236885-505295
X-HE-Meta: U2FsdGVkX18f+c+gDBPYuAjeT6WkaVFu3nR2MpvY2+vaR+VIc3rBzQpzOTjzCdAdrMqbiTTS6ttUyaHL3W43mEfJi+NNMk3YZAJUGlE7qM+Uflkx/lBFfPedQXco5DQ7fDOfMbE4aYrLV3Dz7o0oocsf2R9704u/+3CkmqZczxDdOfHKTuBlIr+HeCQFjWf3ssSfJ9O7Iqb+VqVsRKjzamDnbhNIUIA06V+JsuLGQ4FnJHSyvHt5hXU5gLqCTfqneeDCKYlQAHQW3nJKVNB07rnxz23MeRaq2nC17JeKdr7sUg3FxOdEXEkErkdyXS6jhHe74gyiSTedUziM0X1nkKFvhAxMJcj6fhejXuAM8Miz2ECRgHDYzUp7gUwyUiAloDn1stPhCyDE/upq5r1pu0h3hPoh7TzFcJJXmJ1pquA1j/X476dWjkcfplMFmiUfNrVV05qeHy80cMttWPSmQD2PuUwhZ4cAIYgz1tZ7G/i6/2da/TgULB8SG8WafJHRkDoF8l8GiCX4GzGMxm3kO9H9OiachfM1tquzFkvIZM/0yjDE1iQzQ2v2NWJCJotxqlEqvzp4yKnAnb/qX64wRqsDuUbxcH2Wbs4DWCjoVKQp6EC4dEVghJzKz5PrsvTyvhJx0x/maWXs3n5ElHeGuyJCp74/8SLIneSXBx0KhON5Qe/QQq4QaLR1fUJG7dyaLef2Nb6J96Z0G8xhCPIESSlFRE5sSLJI6A9YnkZoh0GCX3yqQQRCr/Si38oCAla2mi97DpN26WinBPWt1dkWHVdm30lEUOBqX3HgGQlzZLWhllzz68Y8nRoHQZDS70dx0Wg1Erey7+xRNeBDNy6WA9Cnf75kKhOrqg62suTYH1nMyitxwB/SKeXA0+UvoF1kcd4p0Peo1bZvoKjt/pHpb16dlPd/GaJTY6tsFI3MbD4UAyL1GAjCCBeWOkIDjrHlFMgnNbmbJtkRnQtngPJ
 mdL5g0fN
 vGdpD9zpBQ3O2THQ08FWRhUBSm5ejFEEzHX8WMWlAA3xh1Ozj3i6jxJrbCy7ybAnDoUqMGIiGDXzkNsYgNHhF3mylymn359+VKyff6mrnHE90KRRVktR4LBGKIqoqgaVmPEhoxAcexAz8z8VIaP9agqUiTk/p84miiWiXyePT7zEdR4Ie+mTn3MveySjETE6r1qEfPcoDCvYmzqu9yt6Lzimjm6sZD6I7tfn7x/1zD8JyuYBBU4Zmr+obkZtELAfI51GmgmnFfvJ/pn0sLqeCp9uePNPbdQ+L6GVRH8gcMRXkSeB1cl7+bWXh30c9PNMHmy5fto2HcJuVSkK+JCpAeBz9hIsFAY60dYUw0ZEsQggoimf8yZ5H9aiBOabTI3gg/gvjQqrrXOuwfyqV34CpF4HPw5Ja4s0CLwD+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 07:41:03PM +0100, Matthew Wilcox wrote:
> On Tue, Apr 21, 2026 at 06:01:10PM -0400, Michael S. Tsirkin wrote:
> > Thread a user virtual address from vma_alloc_folio() down through
> > the page allocator to post_alloc_hook().  This is plumbing preparation
> > for a subsequent patch that will use user_addr to call folio_zero_user()
> > for cache-friendly zeroing of user pages.
> > 
> > The user_addr is stored in struct alloc_context and flows through:
> >   vma_alloc_folio -> folio_alloc_mpol -> __alloc_pages_mpol ->
> >   __alloc_frozen_pages -> get_page_from_freelist -> prep_new_page ->
> >   post_alloc_hook
> 
> I don't like this.  I think we should instead lift the zeroing from
> post_alloc_hook() to the callers of __alloc_frozen_pages().

can you and david agree somehow? I don't like being caught betweem
maintainers like this.

> I don't understand why you want to remove the double-zeroing of memory
> when the user has asked for zero_on_alloc.  They asked for stupid things,
> let them bear the cost.

it's just a side effect. I did not even test what effect it has.
what I care about is the overhead with
reporting.


