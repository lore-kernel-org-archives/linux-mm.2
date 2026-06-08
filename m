Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5251BCD6E79
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 19:39:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 796506B008A; Mon,  8 Jun 2026 15:39:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 747B56B008C; Mon,  8 Jun 2026 15:39:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 636266B0092; Mon,  8 Jun 2026 15:39:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5528B6B008A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 15:39:35 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 06101A0263
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 19:39:35 +0000 (UTC)
X-FDA: 84857759910.27.39A99F0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9BDEAA0003
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 19:39:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DtCgQ4XH;
	spf=pass (imf15.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780947572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ojAM3itDn3ZymS70Vu5Gl5MXdODLh0QLR6qk02zjekw=;
	b=WLzyzO0mGwh8R7l7qQC8OA9RLzE2WR6xZLcdkK/UsFITjx6Ru5Zr2O0vTYwjZOAZ3xSie4
	DndpyGE0JLT83e4PQwr12CWfIWo80kS4a8lvpXNc2n2QAXdDGAbV5ddH6A6SeuKRU/ziqu
	V4I7lMAFK+p4AHDjrGTuRvFTEN/gAQo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DtCgQ4XH;
	spf=pass (imf15.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780947572;
	b=z0izDauFvr4OxGLAgonq0m2CJBtvYFc3SaJO2x3VDD/Eif10ZF8UUtvefPih7/J1VzpslW
	MhqwNoIu+8rzXekN4Awdz1U7n83scqYKsHuBzb6GQC7HG4dmjBLzIEGlWalisNbLxUXaNJ
	dm8jRyXAJK5C6KvG8I0S0hJV8KjD/VE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780947572;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ojAM3itDn3ZymS70Vu5Gl5MXdODLh0QLR6qk02zjekw=;
	b=DtCgQ4XHi6nP+mUNFQMrkfUfQG0HPqsf6M0YHabEEtkKvROPhOUduJAMXiK/xA98jq7FOp
	xlhttYvwaYAADv5wfUoaSzHgDtuVw6/jB20UNRVtEA0Aj+2m/U7wl5C5RzD5t4SA+pQ4i2
	TqEsBHlFaUTn4rePLwQ35EB9uQz250g=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-108-etAulFYUNgGP5THkMxBIBw-1; Mon, 08 Jun 2026 15:39:30 -0400
X-MC-Unique: etAulFYUNgGP5THkMxBIBw-1
X-Mimecast-MFC-AGG-ID: etAulFYUNgGP5THkMxBIBw_1780947569
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-46010392f89so4309378f8f.2
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 12:39:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780947569; x=1781552369;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ojAM3itDn3ZymS70Vu5Gl5MXdODLh0QLR6qk02zjekw=;
        b=SZdyfqCQxoYtkK66WEymVeYcqMcqaGc12NDRchtTx08VnqzEKD4qgKwQPtCa6epbsi
         GuV7VuBdxih5FDqCMq1DZ9HzemnXTL1nyvoqbCbWotNDB31mIET/wFcSSr7n+LJGzeD6
         woEeW6qoQbQvqUuSF4ugV1R91cv0+LxxJiVHljrZYQgaZcgYsHCEd/O/z7cG9HcXD+bd
         C04j8E+TihhKEzH/Q3GRLjX2XvW6naOF3DnzaTGmpydtqXBJpV1i8vFCPj6cc5ImUmPO
         PvDcwIajfmjpnq1dxVu0UDN+bEZc7Dq22KSMBkwy1FKI2hi2KKwv4Jge4wXfgeVF5axH
         /LRw==
X-Forwarded-Encrypted: i=1; AFNElJ9RxRAFE3UNTP7mvYxxl3bsMetbItXIu/6JpJpb/Wj9RDiTrVflsTtEIy6hwB41SZqpb4hmJko9tQ==@kvack.org
X-Gm-Message-State: AOJu0YxnJqIO9wCtON8fcfIibv3bCEE5ZPtI33bRn9Yn7VCCwHHQyRVc
	8PsDbBMSBDTeBeDKK3hCybFQoSh0+6kTb3VuDI+th5BowhQFPHdi9VM5K1ZFTvqV01rPfTXVPV8
	34F6J6tTEE3xLu/3UiSsAGt3aUJhC6JgxnC+6C1J1gfEzI7ct3NgE
X-Gm-Gg: Acq92OEywQxI9ZrccRAQNDkJX1tfE4WQT7NkmavMJrlr3AAQqNFdpl1WLPk/rR/8HC1
	+lw1PRyxoTK0iH52bfCkyKosYPk1b8nJ9+gajDtZvaFjVINwxeMpI7ybm7ybhlQIwhfyJs9UkUy
	00TgLoLOjklKHuFJzCgerEdSrNRKhf3t+t/CxFarSpGc8PeD3axArQ4OXAJHH1ffXoAfNwZDir5
	rx+zrx0FnfGJJI4+tY3QN1yFgNyCBLY+WRJu7skPQ1pvHlvCsd3x9XduUKuNYLSS+lq346zbGLb
	/nUFTPcDNOEpYYUf3x+plfYo8IbtEenigcmgsvg0Dv6N72T+Ri1G3mxzdFWMq818FpOn/WegWG8
	ywvlqtBDYh7qDhQK2NyAjfZ67zOBmRS+Zoc8VxuKzGO2hvZ1zI74ylA==
X-Received: by 2002:a5d:4b41:0:b0:45e:f3b2:122a with SMTP id ffacd0b85a97d-46030652fcemr21261540f8f.26.1780947569307;
        Mon, 08 Jun 2026 12:39:29 -0700 (PDT)
X-Received: by 2002:a5d:4b41:0:b0:45e:f3b2:122a with SMTP id ffacd0b85a97d-46030652fcemr21261482f8f.26.1780947568821;
        Mon, 08 Jun 2026 12:39:28 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-85-71.inter.net.il. [80.230.85.71])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f2dcde3sm56739949f8f.1.2026.06.08.12.39.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 12:39:28 -0700 (PDT)
Date: Mon, 8 Jun 2026 15:39:22 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Gregory Price <gourry@gourry.net>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	linux-kernel@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
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
	Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v10 00/37] mm/virtio: skip redundant zeroing of
 host-zeroed pages
Message-ID: <20260608153600-mutt-send-email-mst@kernel.org>
References: <cover.1780906288.git.mst@redhat.com>
 <8d5d2fa3-a60c-4d04-b3bf-7a8fe89cb1a0@kernel.org>
 <e54f9b79-b6b4-4911-86ac-48b61889765a@kernel.org>
 <aibjjsoeEcvXobCw@gourry-fedora-PF4VCD3F>
 <aib9QIGIn8f4W6RM@lucifer>
MIME-Version: 1.0
In-Reply-To: <aib9QIGIn8f4W6RM@lucifer>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: KPIvZBzA1VApNxJOloDRYEWPfAF5m6Tneevy6EXp3hM_1780947569
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9BDEAA0003
X-Stat-Signature: b6fupzy8xiube54xukxbqzbotgbzmeh7
X-Rspam-User: 
X-HE-Tag: 1780947572-848978
X-HE-Meta: U2FsdGVkX19Wg/5ajMye2AhiQBuAySL5v4iv6IfhqnnYhM4csz/It0pJd4TwKxSBqRZ05+fh9d+0QuKbP1M6H37TqDMJRFArNqpW2/g0eyBmrN86PeE06Q9p7q42JlVjTWW3V74HNwwC2tiayynr1QHKUR1SMVNf7ARJ1Geu0KmiN/G1Rtlbtx7lzg4F+BQPXpYWKCUIdAQtKmIbc5vfuztiN/IiV5EpMoOc0hD3OJqGvYC2K9TgvdPuR5cKb1hqYUA7GicLkluywASt2XvKEYaZvvUK6E++Gzr4UEKMkC38JwuGSXF9fR03O02QnorjRbs/aSbTWvjUx8wGOL8AJWFKhkbxof5ChpSwgxfsbm1VwWKywY28+xCeAJJLgnwr2DlOlYDDxuv2i8JinF5g5RxqEh0Ui4TgB3sRc6aNn4TkyH6yu/50W0/gPk+hv7FFkMMT1TMyBxu8hqwdjLY0tVKi/JUDcYrkqjFgRsfMhVigVftxcmU6AT4O3oFv0569/FO5n/sFH1CDEMVNm9QOvaUcdnazp28X+z8dq5qVFVTSAAM2hwP5mLN7u850VNBt+lW1CYpQc3ZT9zgFgiBeANwdRVjBRszmVu93nvWSSFkcwB08qN49Onx2tS67qd4I0nJFK0rDFjM1bdQMd3jSPhtgSXm3b2a0Q0AI8l1uiVVEBNrbJCZCTrjqIyn14Vuqoadma56TBc1BCuG3p0eCR5iVd2TSFpfQsjwiXqAs+HNQ/6G8oNY8UJzrSHVpHgi70qS6ge4LnVwUAdU+HqOd60r3eQG0nAryWpKhb+lKAlof1sl3WTffV0BAZJyhP7qxWe3G3zXCoXk/HOP76hd1UKVo8S6ekpaUpTX1K2QYXIx55tfm0Nun7RqeHFnrecvY6uWmNP64ewHhEpvFGOeNwLZerm9nba6jaPrpy8bkky3WXlZt7/Eu/PXDAKWZpixLwqs8bg41iLceB61kPIE
 eWjYOi1M
 rD0jou+cbftj7WR2vNuFQNir5ANNqrWAMRT7VMcNaUiqQ0aWV6BhAFAu4HH9DSOT6yCLTLDUsLwCH0puut41Vt+eRYX56S/aCo8JYVbZhdhInxNAzz5KDHZGxEGoGqkCkNdcZeHziARhJVMlPwE7JlzTUqBysKWoVGVQySlYK6AZA/oPUIpV3xiUExanKPUrewoVyASIjqFe2kIDFvWnw+EQ6UiR/5l0yXFfWi7uE43ZYR9v+kJtHEss3y64cY9Sux1+EdeOx4rkoSW4SBCuVMZEO7oxU5f7MnP5ID4x4nyeuN80dgj6W314UmJgHHtjws4rykwdbrze9J0c5Zu4nOt/0qRpmcIFdtnnmF+mZFVaxry0uoKMZTzcxFyDtfP4qFiKLKPMUeynj3JiKCxw7u2evknPtq4yu/x8O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 06:50:46PM +0100, Lorenzo Stoakes wrote:
> On Mon, Jun 08, 2026 at 11:45:18AM -0400, Gregory Price wrote:
> > On Mon, Jun 08, 2026 at 01:13:42PM +0200, Vlastimil Babka (SUSE) wrote:
> > > On 6/8/26 13:02, Vlastimil Babka (SUSE) wrote:
> > > > On 6/8/26 10:33, Michael S. Tsirkin wrote:
> > > >> Further, on architectures with aliasing caches, upstream with init_on_alloc
> > > >
> > > > It seems those are niche architectures so we can ignore that part for perf
> > > > purposes; the other reason why user_alloc_needs_zeroing() would be true is
> > > > booting with init_on_alloc.
> > >
> > > OK I misread how user_alloc_needs_zeroing() works wrt init_on_alloc, as it's
> > > negated. But you're changing that anyway to skip that user zeroing, right?
> > >
> > > "
> > > This series eliminates that double-zeroing by moving the zeroing
> > > into the post_alloc_hook + propagating the "host
> > > already zeroed this page" information through the buddy allocator.
> > > "
> > >
> > > So relying on "everything in buddy is zeroed" would still work I'd think.
> > >
> >
> > This regresses for anything that previously didn't zero on free or
> > alloc, which is most kernel allocations.
> >
> > I think the scope of this set has increased too much based on early
> > feedback to fix the userland-initiated allocations piece along with the
> > balloon/reporting/double-zero piece.  That's making all of this
> > difficult to continue following.
> 
> Yeah I feel this is 3, 4 or 5 series put together, and there's a lot to
> discuss in each :) so it's pretty difficult to work with them all put
> together.
> 
> These need to be deferred/separated.

I can do that, it's just that the real performance benefits
only come with the last patches in the series.

If I send series that merely moves zeroing around, with
a bunch of threading of addresses and stuff to achieve that,
0 perf gain and slight degradation in corner cases like memcg
failures, you feel it will be well received? You guys really
want to do that, independently of the rest?

Just making sure, I'm not the maintainer here.


> >
> > ~Gregory
> 
> Thanks, Lorenzo


