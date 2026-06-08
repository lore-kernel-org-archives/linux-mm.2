Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C17DCD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 15:59:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8FAD6B008A; Mon,  8 Jun 2026 11:59:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C66BB6B008C; Mon,  8 Jun 2026 11:59:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B55546B0092; Mon,  8 Jun 2026 11:59:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A5FE66B008A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:59:38 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 561AA162FE9
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 15:59:38 +0000 (UTC)
X-FDA: 84857205636.05.7E177D8
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf03.hostedemail.com (Postfix) with ESMTP id 71CDC20011
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 15:59:36 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=s1pKHQBb;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.181 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780934376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iMleNw0mNiEoxYUiy61FpITmPtoPBIE8+C8594s7Zxw=;
	b=uw+5X/P1HbB+IyZuePU+WKOmLJpv4ImctsV1/8m3upfrbOjql9rW+Whzv0Bh7Vf+1Bp7zP
	Ti5fY5S957vcE84YRCj+5SNaLFJffKSu6i2oWBB9EZ8QSTI26Us9xQDNkcGxaMdL4Pf5lh
	IpmGPm7jnS2J65tnubvc5F50gGbB7Hs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=s1pKHQBb;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.181 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780934376;
	b=QMrkc4htq335CwO2zNv1h94cvdA2gfE84jKgcNgEamEYUnq2AuDawhihKEP8AHPTDefU5E
	RJZ6ac8NwlXJJZ5HpaiJk42TRCgJguGp7NyRs3BWd1yspEXUN1sZljc+MMUuNpz4ZbbaqP
	InDnP/XiFz8TGYOOeAp5dNRR2fN6YzI=
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-91591f19c30so700936485a.1
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 08:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1780934375; x=1781539175; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iMleNw0mNiEoxYUiy61FpITmPtoPBIE8+C8594s7Zxw=;
        b=s1pKHQBb/t3MyMpiHbCGz5xJ9LMi4wtMjGJGILohNiDjMgIO7/3o+JhGMKp9M7+BaD
         Eki8UmUy8k9UHAsWS8FfapV3yMgzJEMgh3yfy/2NmAR5xsfhOfuLds1i7rqajwavkb+j
         RxqeonPT7ukgJceUnv0eO3bDX2dD4Ixia5O5Vno/xGBaLWorFl/1edGaD2znAttB6mm1
         XAZEHm56HlOuwsQyiLmZdEu2mzcbuQicSWG5xhTbkpH98bAAY03Ig2RuUGqfT30MyuTR
         fO8O+jd6rjM7u/Ryh+AqlwodhyrIr+2yMMvuhvUQk9ubib2ZpHlTr2eUemQmv9FYX/jG
         feKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780934375; x=1781539175;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iMleNw0mNiEoxYUiy61FpITmPtoPBIE8+C8594s7Zxw=;
        b=nrbKIqx2mUkDK8eHZv7Vs8M7upiWqYdply5oqXRiiqYKejeFm+hQfTqxERbwjafQpu
         nDaL2I/c38IX1i7vfDL6SDdgwJ0EdEf3Jn6NKPnFySZjjKlG2ddTQmB7GLTAdiDqu30g
         ihIP5lwgHeCjyb/KC5qAMlop8UrLc/jlJ06ldD6pLvvTF/HJgbieYxS+ElgPRypmMt9T
         bmk1Q7VBV5rOBs2bV4CCZgIsZkbRvb5KSvcJUTvoygBasz0aAAau5syrHcEWcAU+bMwm
         WwV6SmpmPvS41N5c+TZs+DApDp3A/EbxH4CidpGyh0wQtEEG5qNh+Qjr1E7ZroGSkYQu
         yOcA==
X-Forwarded-Encrypted: i=1; AFNElJ9MVgac6j3xo+jjCW6uz8VtKVswefFG6w/jSbpKeztbv+amMAvssPn1wFbfeaaPBce4829ghQbzzg==@kvack.org
X-Gm-Message-State: AOJu0Yw7Dp9jyB8oDj60ySKRIEI9bOZDZgCTDD84cKKwYlsv+3RuJE0H
	7LpDnVA57fdeM4KCNHE8+RasJCf41PwwztTEoClOvKEDxG91/TiiwuBn2TfYpoKOUzs=
X-Gm-Gg: Acq92OFr+wkY/Bmo2bewYtn2aa44a6F/aY8/kSOW5bG/lbUmy0qCIsDM251FTRd2wH7
	mX6wxUBZ8j9T4f84/L5xhMYDWmcTlN8QhNPcqk5EfnqBDMgpYNk2CMRrMGYcUGa4EQ6eBSCQQVk
	TMfhaa4UGeco/Vbbw9resB4ZJ83HFYumYB3c1MuR6gmDTfLAyGPSwu1ahD+Peesc0qByUNBBv3x
	Wv0NESBhmB4XVC2YB/3OOR1o4EHSeF4clYcnycPptASnWpeN588BXP7pP1Qdh0G9++JDoL0DUOd
	OEDaVBImEEHiptoyCa/2pxCBvB/rdHPL/A9J32eE6dPKgjpMWhpi4Fy0+Gxopa5evGyZaFVLGmR
	zab9Fom943LJRTh2RV7hdzJDygdareRjG5fZ7/TkCLkRWqKqcEZCn7m/1bPnZVHkhbpo49bt0TD
	pGbJWzyz5pFxMMHQZxJV/bvFns+BguggyoXBXD/wkK5d9fH0SgMMd+V5gdNBQLHczG0+XIaBnKP
	on3z9K6vNeEDiZ/OA==
X-Received: by 2002:a05:620a:a189:20b0:915:a4c1:8c45 with SMTP id af79cd13be357-915a9d7656fmr1848442185a.34.1780934375430;
        Mon, 08 Jun 2026 08:59:35 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ceccdc6755sm168719846d6.18.2026.06.08.08.59.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 08:59:34 -0700 (PDT)
Date: Mon, 8 Jun 2026 11:59:32 -0400
From: Gregory Price <gourry@gourry.net>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
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
Subject: Re: [PATCH v10 16/37] mm: alloc_swap_folio: pass raw fault address
 to vma_alloc_folio
Message-ID: <aibm5OFmiFK6lCqH@gourry-fedora-PF4VCD3F>
References: <cover.1780906288.git.mst@redhat.com>
 <d2be78654e9dcc7cf5b8a542c2c8f331187c80c9.1780906288.git.mst@redhat.com>
 <aiapFvxPXuPd4-OP@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiapFvxPXuPd4-OP@lucifer>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 71CDC20011
X-Stat-Signature: 6xzeyzzc88yw4sjmt9ad5nq184rjnb1o
X-HE-Tag: 1780934376-224427
X-HE-Meta: U2FsdGVkX18Yd3mcvuJOn/QW8amBhW5ZwOoeLl8F85aoHaX9mmWicCcW04Crsx+I/F2DTKdhyNJHRMPNOaQ9HNoLooV6lpXTYiaiKRFqFleyYaqbTG/fGuoFOUlPb5MqUWZqPoDxdWGGSvkEBp/OhlN7VU1kaSmvlGHQ+nTf9cbVA/Zo5GK476rSYDZ/2A/U30lEUvRDB2tkqAZgW7+6HTuSSZ5T3lN/ZJ9360VP2diknmofIwZF0uNHB0npp5wcRelhf5kJtxKpsv/x43H9S3up6/Dm9DqXluX5Hm47uHBM/P2sk5q0fxUH65AgBzbaVqIY6NdzXpZjduKq9qj0VmyUBfB9/tQbpoevUDYwxDhPCLL8OXjDNqDBzUkpVohC8H7EB1uoJd3bN2rFR8Gv7rbakBW/PFcSHcoJBn+MhyfsYumMG8aZg1UZKQaozkzvD8tbq2GDLFYEIzLvjr8gTXbZD7EbZzwLuiCEhT7Q6wgbeESgyOoW2DC9jOi54YRZbytl9Is9C0nQdj+jnnCGtG4OoMo5m4PqWmu35EtwwkIeAgsEt1tmoqbwpK+a9x42l7Hf0NJgsVp/CLAo+01aDoHS1bdaMSzZDlvG89ME7x9Jz6wm8LzEU5fpC7JtgEhp0fcQ8pysE0Fdwh/yVfwQOKD3iq6vSPDh+dl9bocza/fA3sO3kH+kRDb2CEzhMoooNyDMul9YCvIYe2mc1TsxqAH4v71dM/JC77gGWOaKfQ9oioYyq3XyCPfBWzTLcr+wZfUDsLTssRH0hK+NaArp+AeySKypuP0jLgWqlbAdbjfnBDK6j7Gi/khzY8OErRstjI6xgWUg+8l2BHfvgo56uDKSg1jpcNCTf295pFpS0Bz7fo03zdoekVSBfaqr6kRdQMdw9HYk2JA2ybRY7bHNwJq6CkPUFtWt6A8oB+PTZB4uayHptjIhjy+3wOpOtndH6bcXGOCug4jxl1P3iWT
 HKy7SpJw
 3hCJAcT1zuRmmlgi2R2tYvVNSU+qqk2Vqsh5/BjL2n8u/h288M8C/Cw6yuC5Rxycutz0pgFV/DqdElfblI0gOqi5OHQ9q5fpsyVAsUe875emw0ghmOyLL9+9aUwucLKatU0uT/em942jlcRUc4s8cxJxuPSUfVReLTiLGjlhP5L5Joyurxrb+XzNQ7dqNnsUHbown5zJ3PtbL6VbNueYLV2ztU6qvhN2GJoSJpYd5+Bc4g0+MpP7w+5+5jkWMqoa03Wfs64l+5ssubnpAixSf0z4byPuv7o+yrHY78t9YYacaQMphnbJG3nQjD5cxoj0aCb8OZO3dxS1Dbm+j6Zr72x287SxyucBpmHiD1kSJ0NXwLaAdFiObFMDLyl4fROt5wcpGbZlBFAEkWVc7veEpRKRbsL6cib5k3k17WGhMRwXRboridPJ2x2zJzEEOoiZMQOeQ/zeyNENHC/nooiJRBuP3iL1dugMbSm4h
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 12:37:20PM +0100, Lorenzo Stoakes wrote:
> On Mon, Jun 08, 2026 at 04:37:41AM -0400, Michael S. Tsirkin wrote:
> > Same change as the previous patch but for alloc_swap_folio:
> 
> Please don't say 'same change as the previous patch' :) explain what you're
> doing here. It's a pain to have to go check otherwise.
> 

MST you need to slow down a bit.

I gave you this same feedback 3 versions ago:

https://lore.kernel.org/linux-mm/agXUHItfxSwtriRF@gourry-fedora-PF4VCD3F/

~Gregory

