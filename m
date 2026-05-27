Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A2BFCD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 05:25:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A96556B0092; Wed, 27 May 2026 01:25:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A46C66B0093; Wed, 27 May 2026 01:25:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90E486B0095; Wed, 27 May 2026 01:25:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7C99A6B0092
	for <linux-mm@kvack.org>; Wed, 27 May 2026 01:25:36 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1A940C1DFA
	for <linux-mm@kvack.org>; Wed, 27 May 2026 05:25:36 +0000 (UTC)
X-FDA: 84812062272.21.E69AFBA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id D9E6C40012
	for <linux-mm@kvack.org>; Wed, 27 May 2026 05:25:33 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gYGeMHv+;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779859534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FIw4sRKy1aKBAfMhIWmMCv5y10kgNoyzfTI86dVZAyk=;
	b=j9asOsoATrf9APnPfHBpaqdTZgYyY58t1H7sWfLgbudStUG5hvqa+iXgHZaj4QlaLRZuyY
	dDQhxvJd2I9yVXXgc/qSDdQmf41DUQpt7qyNnBFJJgquHdk59C9eOO+bdt8BQJ+Hr6jQVk
	7/9mk2QZP8YDih0YO1R1XP+jbilfk6M=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gYGeMHv+;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779859534; a=rsa-sha256;
	cv=none;
	b=7wnTmsuqne+Z4fkieym0Vtac3vNxwQh4Uwt86O/RvFzsHWZB3a0rxP6VRZSI5SKXXQqzkR
	kywOf5z2Az22t4ooaT4S6RHRMcAWF/GbLSu74uys/33+0pjlkZqt5Fh4UEv41Neb+sVL0i
	O+PEBhFxyqXfJktvfSv7dN3Htc7zoHw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779859533;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FIw4sRKy1aKBAfMhIWmMCv5y10kgNoyzfTI86dVZAyk=;
	b=gYGeMHv+y3dQG03EF1/3oaGq4hsv03NRagKTE4wdFbTXvtBHfsejugFSVDBPzbbQh85gKW
	oBXngxgd30AX8r8JUfpEIMifKNYCxojYknPCYC3oirrLxctew/IW+IR71/deE/hgV4gbyy
	H5VUimFH2AFc06tc+PRRTaCziqil49M=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-156-evBAXmiZOEi8FyolWZDukw-1; Wed, 27 May 2026 01:25:31 -0400
X-MC-Unique: evBAXmiZOEi8FyolWZDukw-1
X-Mimecast-MFC-AGG-ID: evBAXmiZOEi8FyolWZDukw_1779859530
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-44a52d5e572so7800474f8f.3
        for <linux-mm@kvack.org>; Tue, 26 May 2026 22:25:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779859530; x=1780464330;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FIw4sRKy1aKBAfMhIWmMCv5y10kgNoyzfTI86dVZAyk=;
        b=cM2zZQkJl1GhiGcICZHW+ahcSfnHNYpZVQ8Xiku8WYFxW0LADSDQB17XimyC2waFJL
         j+grG5X715vXCNw1fF6GCojDraAt/D7IPGYDIpR/iyFDpv9ANnK2cjFweLQT7UWP6kGp
         dwszWXQdpfdQw63QNcWgwcit3JalISnwacRIg5/4HFNOZnNkt6Lacuxn4IJu51pbtPON
         A2JObYhKz3IWshMmwHxRuKyXaJdz1X4ifdXFsdhuITue/kbSrctUpzPnRuGayqcJ3vma
         weXFBMkSqhyGAofbDPlI5ys8MenBpQRV6Xi41tjRvczx1Oa1WEvdmsWRPbdHEYDR5ESW
         j8xg==
X-Forwarded-Encrypted: i=1; AFNElJ9XpL08wI+Ge+nUXnq5o1OrXOpIUmtIBRFB7pcY2SlfIPdeUN9HOktXQjpt8JjhbDa10JfPCbf9gA==@kvack.org
X-Gm-Message-State: AOJu0Yyf+v08TcoQ5BcVuY3OdHBXNiYcxkcvBp+3jWVS1A6CdVvUTAY8
	Eo2k4Ug+ooE25QWmHzVNj8WJIbszG8Taez1Oti619U1XHRy+Rg2C6yEWr2xjzf8hLjXKNNVUVtJ
	Qvpx//BlZmXitiWtnC5kOu16p9cI5/OpxAZvuSj592TBAZQl2YjTE
X-Gm-Gg: Acq92OH3e7W0yM1qrnxKBuofmyshd7M6EBkEo+A138mgOqvi9ptKqBvemUwe367LH7W
	NR9XBB91KEFZaJgoSReONIrX5ylKY+2bZckSrjed/wNzRwXGuhoZt7kbiHJpNff4smNL2WzBbTJ
	uyLsROO5HY6EQF1KszJQjXGsRO6PigD6kYcac5UCorM9EAXYFvi3W7AKiriHaQanKfa2WJZLss2
	vbIPXqIEbgNLWCk+AwkLQfy41IBiAEo4Nhw2aTFy0HKXUT/rTAxjDI3nULh5VCFByat6/t/s+Bo
	+covTy/Ims2nODPQMc3x6vFlv5k3KVVJDkE0bAHHWCk/tm4oyWhSd7yG9xxNgCSuk5KQTrevPTW
	qyncOBOZ7RrUyCg1Dj3epJ15PdzvAfGkDH1NKUJ9gB+EjCydwT8hX6g==
X-Received: by 2002:a05:6000:4803:b0:45e:7c19:a328 with SMTP id ffacd0b85a97d-45eb38a10ccmr34423025f8f.28.1779859530280;
        Tue, 26 May 2026 22:25:30 -0700 (PDT)
X-Received: by 2002:a05:6000:4803:b0:45e:7c19:a328 with SMTP id ffacd0b85a97d-45eb38a10ccmr34422955f8f.28.1779859529704;
        Tue, 26 May 2026 22:25:29 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45edb54903csm3490131f8f.6.2026.05.26.22.25.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 22:25:28 -0700 (PDT)
Date: Wed, 27 May 2026 01:25:22 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: linux-kernel@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
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
	Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v8 00/37] mm/virtio: skip redundant zeroing of
 host-zeroed pages
Message-ID: <20260527012249-mutt-send-email-mst@kernel.org>
References: <cover.1779315441.git.mst@redhat.com>
 <20260521100313-mutt-send-email-mst@kernel.org>
 <eda29390-94a2-c4f6-a3e3-32bea8c6b363@huawei.com>
MIME-Version: 1.0
In-Reply-To: <eda29390-94a2-c4f6-a3e3-32bea8c6b363@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: vXuxKeXvpPGKKqyMIOjB4S0XngDKuHvaBA_kREt__fc_1779859530
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D9E6C40012
X-Stat-Signature: imf5psedz669bb7bhzq46bns5bykok5j
X-Rspam-User: 
X-HE-Tag: 1779859533-624857
X-HE-Meta: U2FsdGVkX18VQpWoD3VIULbO/Yn9tyr0xPtVu0Rx7xZP0jDHECYa1WVnMk9ZbMsAoO138xwWLx+XlpHNPTEXax3xdCD0GcYkyB7Efgbl9CU/k93Te6YAkNFinPReRBJCb7xhDJ5dR0hTgPkyvGclDVsuflZeJIjKmzT2sYEScqN0JFmJH2pgMwdb0kEFX4a7eLDn9TT+QZhRurSTfbrRJnyeTpXVR899Ul33u0BUNcf4LdXqmtFeJLqKdPeejigis2ROgKkJ7ksad66zuABB1xsoBHVZuSa3KoMMxfslefdWxw9h8ozMbqC69zwufDkIiDGhYLWjP3MhTftC29Z6aThWO5IL6Tu0dHVnnMi7Go//d91YQiljo+D+DpNh9sjzUYga7kZugXiBaBgZIsooIAc4cvzgtEYaSQya9QMiMwHlvurobLqPi0kdLFXb86nUBDBh/mYeI3BPfPYbIqkLz0vm5bhs25+7kzgQGHLJj4SkLRAxrBttplykhGo6u70j9EiyoNe5ymUjKcciNe1XrQ4gCxDBJQqVCrFSIfscSkPlkh96fnR6mRtLWBbMnyayHQugxdBjDgN8wahM7I3UtmppkSeYAr8QAiuO696z3CeweRcaPtfDkuUuvUHPt9p81XeMIVThCIxDDeYq/NUPL39NXw2cISzV88IP153dMEDIyZQzhxZmvSpD5gJGPBCV06TrT7uKRe2FNR1sYb8PPwRuGnaOeAJQgDRQ330TVJZct+Ak/NB4uWggdUd8sWSYpoR02naPx1m17oyZAfpG4/9QnjHpk8iAZtdWNDqOOUeK3aTbiefws9+Rr0qm4ZL5jL3Cpp8uob7A1xAhgc7Ka2NbqS/0rpdEZOFTyWSNu+QaJ23DW5nok7ydOtNikKY+evxYxWnWsFBF4KNBhoOfnn3BBEna0x2O7qjN0lBHT7bF+sFNxjA7rX0UmqxwJT6e5pLLUzgB/xH2Pk6NoqR
 CmT2Pfet
 lcdoEXAxZZElHUlyQ7O26+IHPsqnq5G8mHsK3gqwspxKD+uJ2DlQXGBEhuppviwA0JYlG23kCiP+YgzI82z9VDf+rvxpAi5c20jgKw5MaTEpxP22BKjyZLyrhLVjJZRzK1E/3pl6y0AxiN9yXI/zQraMhOmJIUXWAd187IUsfqq7tUY7ZcTqqrcUaa7ppUvnaJk+jtBtjUdN9345OgRuZPT22Obl+gONm8i735Nook32a08Frosjxkn2R+CD6KPcBrePtQtWFSOFemu+1mcfP0M69gGUzWSiaY1yYEI9pRIpMjxgpzGefIUwp7S8B2G+R5TwMEaPndSiBjRBD8snZvMxgQI3G/86k/lfaMvisoExm85Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 27, 2026 at 11:23:23AM +0800, Miaohe Lin wrote:
> On 2026/5/21 22:09, Michael S. Tsirkin wrote:
> > On Wed, May 20, 2026 at 06:20:13PM -0400, Michael S. Tsirkin wrote:
> >> When a guest reports free pages to the hypervisor via virtio-balloon's
> >> free page reporting, the host typically zeros those pages when reclaiming
> >> their backing memory (e.g., via MADV_DONTNEED on anonymous mappings).
> >> When the guest later reallocates those pages, the kernel zeros them
> >> again, redundantly.
> > 
> > FYI Sashiko reported a couple of issues. Mostly false positives but
> > I tweaked commit log to make it clearer. But also a couple of
> > real issues. So far I have this diff on top:
> > 
> > --->
> > 
> > Changes from v8 to v9 candidate (code only):
> > 
> > 1. mm/mempolicy.c (patch 1: mm: mempolicy: fix interleave index calculation)
> >    Combine vm_pgoff and VMA offset into a single expression before
> >    shifting, fixing carry loss for file-backed VMAs with unaligned
> >    vm_pgoff.
> > 
> > 2. mm/memory-failure.c (patch 2: mm: memory-failure: serialize TestSetPageHWPoison with zone->lock)
> >    Wrap ClearPageHWPoison in retry path with zone->lock too.
> 
> It seems TestClearPageHWPoison and SetPageHWPoison are missing. Should we serialize them with zone->lock too?
> 
> Thanks.
> .

I don't think so.  As far as I could tell, none of these are called on
pages that could be in the buddy. And all the non atomic page flags
games we play are only on pages in the buddy.

-- 
MST


