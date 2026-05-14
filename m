Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55FC8CD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 15:41:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 930466B009B; Thu, 14 May 2026 11:41:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E13B6B009D; Thu, 14 May 2026 11:41:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CFBC6B009F; Thu, 14 May 2026 11:41:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6ABCE6B009B
	for <linux-mm@kvack.org>; Thu, 14 May 2026 11:41:51 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 193B08DDA4
	for <linux-mm@kvack.org>; Thu, 14 May 2026 15:41:51 +0000 (UTC)
X-FDA: 84766440822.12.6F399D8
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf20.hostedemail.com (Postfix) with ESMTP id 435CE1C000F
	for <linux-mm@kvack.org>; Thu, 14 May 2026 15:41:49 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=AWrWCbDe;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778773309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hgKCwvl8qCOC7UfBkBLgKxl3JgTAzl9p+k26wMt8Rf4=;
	b=gs8RJ2Uw4nzA2en4rgAKQkwTh1XqqZp4SxXkq+eTR/QL+Q+j8gIgWKyuD58cdteNM0ja+K
	M6kLJJdrRYdL6/+W54lRRyWBTe5cOBQL8yRasiequAdy4MA8Ve/9XXdUJ26s6h5VNq4PYy
	1tFQ4Wiqg2d0uqLQ+GY8NGCktJK+p6o=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=AWrWCbDe;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778773309; a=rsa-sha256;
	cv=none;
	b=Z/WY63jy1YmajkzJdgD50kWA+qe1aK6Tn2fq7KpdMlfXIhr5HV67/ux9uO3Yc3cQEHq2ZF
	QgxjaZh9UulwX815B7VrJHfKHEnAZOVkL3vU8HszvD8mfgtiaN7B0+tCjY0dcQ6U6wSC+7
	I+lAO1wpyJQ9vFvHA+XsVgU1dlQZOWc=
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-9118b952e2bso17601385a.0
        for <linux-mm@kvack.org>; Thu, 14 May 2026 08:41:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1778773308; x=1779378108; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hgKCwvl8qCOC7UfBkBLgKxl3JgTAzl9p+k26wMt8Rf4=;
        b=AWrWCbDelMN7AgC/95yKlCb9icSrdBfeJwbgu7HQj9zRRugXBqHB6Xe6goFvnHIj9J
         p3yRjaPPzTNQno2evmAORwY9xeRzQwlwhM5Xk4pycpLaGiDRjTYyafgWFXmnL3Kd/0bc
         PV7WpbiYDSxkYtmH/yhqdWn1AfqJibq2sT/VZ9qGRsRndBQKLHvViE9Z8KQormn2VwN7
         DFIj7NiSuLkfDUE5c3ijYa5A1/LzcvY0sdjk8nYBJSck4zWhFRPprKjMJG01eYYSCi52
         aklw1pdME7c8YwRdGaBA1MbL74f+Y7x8EUtDsse+A8MtW7rTD5swzvNDN/5E93oHN3l1
         6kow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778773308; x=1779378108;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hgKCwvl8qCOC7UfBkBLgKxl3JgTAzl9p+k26wMt8Rf4=;
        b=osQVr7KRCMq1R3M4pb3Gyzs6dUPHLKxuz+wQn3+txmTVkJ8MV0bnJ+JU3hoUJWkOkx
         wxrxfuXNZ9uoN82FxQ8bPccWFBUR8faoglk8ymUneRhK7YgTRFxLex6wDQUFKw4QQYZB
         Lwu60010/4eNl0FesjGRNSruewJy9o0BuGeK0gDqAorPRgUkgkb053CtuHDCVxTBivBO
         qJECTjWoTxUdXhDcheSVu55YSP0HB08Zxi5jVwNVCch4fLJYXuHYLC+jQwIY0IJ+YrHj
         jIDAaOa7ejWwk9pUlenTOAeOC99xFok2fMo86/dJXIAUONPJiEPWv/SR2X8g3dlmtYOM
         JfYw==
X-Forwarded-Encrypted: i=1; AFNElJ+M3fma82djDWVYRh1977aCeyDH/I4Bkr0KTdlhfCxO/3XVs2LB3RE7ebFtShXiYtcBHmcc1NkvXA==@kvack.org
X-Gm-Message-State: AOJu0Yww3rBIlvEPX7Qo1Pt/r2Mh2pLcN1nbkwmGtaxP9ZOu2oLxCej4
	7zZcl3PJieB2KbnJ3P7PjOJdLhWuzGy5nT99OHIpJVq9HW2i6SFouWz2kSkTgh/AR4w=
X-Gm-Gg: Acq92OHvr0a9UqelLEr9ec23B35nnL5vFT2J6Ak6jfDjz9mGTcNrfGasMa6RuJ6f5aE
	+21pzxgHCyf7iNDBauQhBUz1NyI4h9JsYcJYjeeD7Fg8uFcfJ5TzPhczAW2+jKW05OSyTWGUF1a
	DVt3fqEKWIt2kuHbyje33ikvhPIU2pPZdUisryC1Bm8I/v/uURaCql69Y8Afq4heYN2aE/Pd5xu
	tn41y8yoF7Xj5KLjm2/bVXOafxSIL+UjBaDUR1sgG+ypC9X6jtF7O3BPmO8MTgQIiShYrlM6CNE
	4CwhyBupriXABWub4JtwAviExl4+hxOHAc+MAjVFwTZvAkBSc4sWDxyZlbtW/AabUJfbTIBbBju
	SduahwjsgeYwuHc+G+dAb8q1dewc6sSp8ZRsLnV4nahXAM4ULsEpNmN1E13QL0JjixaD+UOO2xB
	20zxIxlMynFclSGAM0VC4OL1ASOJxysqe1YPseS+5B11GrN0oZKkZZTbOgA5q/gjqm34FwOOJ6u
	C+oDmPP3l/x
X-Received: by 2002:a05:620a:6cc1:b0:910:d1cf:915f with SMTP id af79cd13be357-911cb72a697mr20518585a.9.1778773308288;
        Thu, 14 May 2026 08:41:48 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-100-36-248-188.washdc.fios.verizon.net. [100.36.248.188])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910bd02f12dsm279596485a.40.2026.05.14.08.41.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 08:41:47 -0700 (PDT)
Date: Thu, 14 May 2026 11:41:45 -0400
From: Gregory Price <gourry@gourry.net>
To: "Michael S. Tsirkin" <mst@redhat.com>
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
Subject: Re: [PATCH v7 02/31] mm: page_alloc: propagate PageReported flag
 across buddy splits
Message-ID: <agXtOeuYNin9nYN8@gourry-fedora-PF4VCD3F>
References: <cover.1778616612.git.mst@redhat.com>
 <feab82b370b3e66b58b9cfbc1efaf26fe6061d2f.1778616612.git.mst@redhat.com>
 <agW3JyLAwVsCZ2qR@gourry-fedora-PF4VCD3F>
 <20260514104735-mutt-send-email-mst@kernel.org>
 <agXrCinY2HmJmhT6@gourry-fedora-PF4VCD3F>
 <20260514113337-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260514113337-mutt-send-email-mst@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 435CE1C000F
X-Rspam-User: 
X-Stat-Signature: ks8iuesyr8ug7xeucdwxghud6icqrebb
X-HE-Tag: 1778773309-420945
X-HE-Meta: U2FsdGVkX1/SRNTDRK/U+UjW/xUphygFEIpMjxa+3drA604b323bm3SBw845/SWB7jONexEVME4HRprTwjF/xdGpdOAe4NAiglwaownmLwTr9icRzREpNC71vsU7UjTcJt8Cc34fF+78ugI9UkPdEzRigXJDjTJH26lnoozTu0CBP8g4ptyfqfmASLAy7qGlNV9U+iyzE+axB9F8yfh5bH52kUUoKLfsprJglSpAgxO9otPQvJc5kGiH/LxfGyNNa58IjbK6yzk1WGEcDS9+vluVHHkPL0MPqtlyJL01n0VQHvh5EuP97RfMMFHBIMzaR1klyIFws9sfS1fLQgMUgcUyCudL4W8XvSUwxaFaX4an+N5UyerkvXd6NPJptf0vQClPr6atw0G8rVx+8vb1jhu78qFeeiyQk4naAh0z8hyWm7SEcgsPYaQD+jABYcpih16ms9HHKheOMCrDH2ykxDKSr9gdBKUstJBbwaYADHsRC45lZT+HftpmRuM4lm4mLCbcj4uY1lVKO9ZIOFDFSAg9WhcJzzQzPAv39pFMfWo+DCyyyzn9TrgAD/m7YsLYp0Hx2ix46gcBipK+j3vtmxtEKzwq+wmXA31/kTNCzo6hloUjSV5aQ+aM6e+aMai2eRKSAbk1LQxgbMsk2PMzGSW/GHTHlHKOHQtgrimuK0pJ908zB2vpRGxrudX+84NHSDAfX0R2C5KNXu36oPAz7gJetUBHZYuHookIZ8keSU5bDU6X7GlXG2AZJ9caXr6hbGV62XVXmZjdneFKpwy0hSr/utGoYuwoTFkKxk49iocw4ifHdhPK+RZDbLr8hT6vs4gLBym4Ek1dQjzjkuBc0OPscWzBVeFR2MeFCCTo4OEWbkbPcrz0+gZZcHn5QJsbQpogc1QevKHh/YlsOC9DjzzENVThIDWjxbTsG2Da67X5wcBJjnyTjJA9LAj6bltsU8A/kbPY78N2nMPDd7L
 HGtLQeL8
 8rpSkU8y18xzsJAW24cORIxBEr8WRtfZyvgbpmRpcQuzHrsbHg/iIXGpKyCyUiqxjD33KyEJF44qR2heNTQ+Yi+6EY3w/tHc2bw/EB/IUlcpuR8lvv6LOeBgvgRr1heYgbT0wHSl04BEs7Z7aFv5D7qdzVl4EsRLg8iGh6E1qQ03mdAkKSZIfI5Uht/FDdo2nAUhWq3RlceQVQifS2RFpbpLz88UjiF2K9cCiNp0WofhTheUW5WE80kA2OsT7fNh/O6d+fpILjKoeCGcxwhzf3mgVctyVFrt8JgmFYx1VCziopRTGEtOeLjIuUYqDesCVPNhq/EoKjCbqf/YHtY54MqEazrZ/waid5rd12UY1LODmLY0hZwN4EVobfAJCNgyARbPdNc2swBHbENgdezwrFtlEswABFwq/yrH1vxzaRRZcSvUfzd8N0KH5IhzKYxFs9JAEoRVo4Cxy5912EqyZvpGDVoncMhT5C9iQT32rholBjwJekugFVBKxwLOwuz/SAq+cPLEVHs5Gme1ftA8RyMcU+kBNdlkTnOOtMvCVTthCKjWlPVDyzsvdCU3+QZZVhQd23VGLwdS7t/0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 14, 2026 at 11:34:14AM -0400, Michael S. Tsirkin wrote:
> On Thu, May 14, 2026 at 11:32:26AM -0400, Gregory Price wrote:
> > > > 
> > > > Maybe mildly out of scope but worth asking:  Are there other flags that
> > > > should be retained/propogated on a split?  If so, rather than pass
> > > > was_reported, should we just take a temporary copy of the page flags and
> > > > pass them all in?
> > > > 
> > > > ~Gregory
> > > 
> > > 
> > > Not that I can see, no.
> > > 
> > 
> > You do this exact thing again later :]
> > 
> > https://lore.kernel.org/linux-mm/9a22e0f9bbe1278913754db6df76e291a006181a.1778616612.git.mst@redhat.com/
> > 
> > ~Gregory
> 
> I mean yes, reported and zeroed) Just zeroed does not exist at this
> stage in the series.
>

More of a forward looking question: if we already know we're adding
was_reported and was_zeroed, maybe we should just pass the page flags
through entirely and let expand() check them instead of passing it
through individually.

We end up doing something similar with post_alloc_hook later as well, so
I'm wondering if there's a general improvement that can be made here.

~Gregory

