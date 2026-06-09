Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D447CD8CA8
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 20:24:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F12B36B0093; Tue,  9 Jun 2026 16:24:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC3506B0098; Tue,  9 Jun 2026 16:24:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB2856B0099; Tue,  9 Jun 2026 16:24:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CA5C26B0093
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 16:24:30 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 59595164EB7
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 20:24:30 +0000 (UTC)
X-FDA: 84861501900.05.65BF093
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id EF72DC0009
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 20:24:27 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RgO1q+TW;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781036668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nTUa2dI672FDZzKGV04n9VclX+EgypGNikp/bmy4IOc=;
	b=blHLJ6InEan7RSJt/raKvrkpgNOYYKtl6VD88DuVgP/MhRx8cB08NAphVENYl+Yuy6ZwHP
	tzGIozTcvKCMC68IKwAXenOC4DrlBfw7ktBHOfp7ORVCWUSfPBunlmk6BUhalh++e099Kj
	3SjNmcVhdhtdkVygInjgWFL3MMcHj88=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RgO1q+TW;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781036668;
	b=qdmtrZHQNzYj9NG5YJomlR08GQMwyoY/LyKyWZyFhI3IfbTeugzt+zYcRjK9LSyH6qLTSc
	maTy2yFA4g7h8S+zDOMmADgLxjXOTsKkLpk+KdJNGf3Wug1Co1q3j6oLoe9QrijBDjMKWl
	8tx1HCyMt7ct80Xp36XTWQyKFe/Ln48=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781036667;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nTUa2dI672FDZzKGV04n9VclX+EgypGNikp/bmy4IOc=;
	b=RgO1q+TWO8/tFnevqDoV0a0ucccHN42YiLl67jxFW0vgLsHQ/Kl3+HmciZZeHFCXI4NYky
	oPdoSFSqiVlVFkNpafkkF6kegF4dKiY62YyXTZYPMUnnotEyT7I2RODJcan1b+7df8ispa
	N55OA4nxhEeZmbKNAnVMAWT8f4G2nuw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-591-2qY9vrbbPZKEf60NFIqSzw-1; Tue, 09 Jun 2026 16:24:25 -0400
X-MC-Unique: 2qY9vrbbPZKEf60NFIqSzw-1
X-Mimecast-MFC-AGG-ID: 2qY9vrbbPZKEf60NFIqSzw_1781036664
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-490d3f03883so14523345e9.1
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 13:24:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781036664; x=1781641464;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nTUa2dI672FDZzKGV04n9VclX+EgypGNikp/bmy4IOc=;
        b=NaK1xRBvhhCOU7ze29chKlrkPjT5znXJZ6tlgykr+nxO9wFRpk0bqQUeFmNcOZ0jXe
         onFhLHbwQ0TtMVAZgZhG9MacEjb7/omnua9tuufviHguIsZXkcQHOmVPu72GgPsxPEg7
         Gt9sUvq6XpkA9tkCpG4ASYY+6vGAIqSAfQf5zKxEkQGCRQSuRE7/Ddxqm6ZUvIl2iIwk
         pD7Sd/W72pAGZzJOekLY7zBOwBKDO6yOQh1GYRzm9qUaJwk4Wbpus9PmrKsmo2dxt9Ys
         vLIniY8djs9QmB+C8j0Zc7hLeR/6RN9ejkGslm+pJr8ipel0hmK/XMlmzpaIR1WHT6Ua
         opqQ==
X-Forwarded-Encrypted: i=1; AFNElJ9+3qx3sTjfrh77FMXXGFu/j+TMQn8aQy5j0Bn/s1COW5cUahVDQUz20gH67TdZUMaS2riQzO68nQ==@kvack.org
X-Gm-Message-State: AOJu0YyQZznQg6AT08HA19xYaVOb5kcwXrRDVRAS7gdyaNGGqYVu3AwT
	JzdertDWss2XDfQwQiEvuqilE8JoVCm9jISRYvP3hBl/vgUULxCZsvCDWFmT58BJ2KnLivpezaF
	y8PDBW/pQvxiFslwGFWctQaqZRsmyhNHWuQKH4Y6poEcIuewjsiki
X-Gm-Gg: Acq92OE49QcUZ3DBywsqsZ6GQKLC649gNpjhgNVxMd5j0qEIdkl2h8yAIANysu2GVtI
	QyAUSde89QXsczZl01uA8Fa1IeDyFWGAXdDwORU1GCKiiNBwz+RO9NlPRKIqZH8kO2CtfVfLTLZ
	nSCLe1qggif97qJI76qSTTpYtHD9C85h24nak8rsIZXXh205+I6miZ3JrhMl/gN6lHAx4GVocH8
	yME9JM8bRDNAqW9EqiYJYjLDiW0yWxzO+p8+OkxjYTdfy4YcDrry78veUyH0C2oaxnqNLBxD1Hf
	5bzZ0ArRELzkwxu9pUgEUl40zX2lLvcT3R0n5yz1DepI0g0+vSyUAoqpD0dnmKefqrElcTqHIDW
	9WRXp+xxCucbQLI6uSl6Z+6bSxST887Pa163E2SbVMOIdfnAZvWkEsg==
X-Received: by 2002:a05:600c:674f:b0:490:b4bc:4f3d with SMTP id 5b1f17b1804b1-490c25b06a1mr339837675e9.18.1781036664328;
        Tue, 09 Jun 2026 13:24:24 -0700 (PDT)
X-Received: by 2002:a05:600c:674f:b0:490:b4bc:4f3d with SMTP id 5b1f17b1804b1-490c25b06a1mr339837295e9.18.1781036663783;
        Tue, 09 Jun 2026 13:24:23 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-85-71.inter.net.il. [80.230.85.71])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f35133csm62850063f8f.25.2026.06.09.13.24.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 13:24:22 -0700 (PDT)
Date: Tue, 9 Jun 2026 16:24:17 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
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
	Andrea Arcangeli <aarcange@redhat.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: Re: [PATCH splitout] mm: memory-failure: serialize
 TestSetPageHWPoison with zone->lock
Message-ID: <20260609161227-mutt-send-email-mst@kernel.org>
References: <df06b66fe4ff8e925ee0714955abc2183a727b90.1780998980.git.mst@redhat.com>
 <20260609111020.e88f51a7b6ebc37360d66fdc@linux-foundation.org>
MIME-Version: 1.0
In-Reply-To: <20260609111020.e88f51a7b6ebc37360d66fdc@linux-foundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Jnd6yT_rMM2CxZN1VdynhMlVmMe1vq-J6Bl5iArE3TQ_1781036664
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EF72DC0009
X-Stat-Signature: bmt3jx3spp1hi4gegc9eo3j85a8ku4kt
X-HE-Tag: 1781036667-482100
X-HE-Meta: U2FsdGVkX19xwrMLHayY2c3bqslR2JAm7XFTSlfl2KH8yZdDkmaX6eGZDNGT9N+XeI9BeT5mxiGIdmGC5KhKWDqXk1j+Oj0lT61S3u83/39QRpkT/MAamhw50ae28iniKSDtJf9wy8gub3xefNXQj78oy5eeCPtUCXFfbbQ79E5j/6edMt39o/2C/4KU+2eHRa84gnHkRQzs+CjKkbZ3WGg26pS/c35yCdV3amt8lzVILXOcwCv4tI+E7qcfgu3Ne9N27pleeGytS53o6Nv2jpmmPp3CsOzKMgOaddE4e9f/GguHv6CVWmpZEBvgLCY8hBDbJ+SKl4cK8r+uWoAimmQqHm+3krbOk7G94z32/xqnsUq6cVjpVxIgUDN6xc2V8KJMi9qyCbISiTZTGVbM+nkoQ9uYssN995ECmzNw685XKRAh31ktoWJBoA56x4aNchqFdVeabGGbBRYf42WGPXNJ4ub7sXbaL/e3+ObhM6NoDaLEXcl/OdVh2NIPAdoyx+ppFMOVvQ+hLF1EgnAiy49y0/AfNxZxECtnwkCeYsmg01ywHwom/o2jCcZxYXuWHtrnH0ExBdCSjlYSHSUQd3AmBZjihJWg87P49YP4Ds3FdLObI6D71l00Mt9oNPxVxX8askJ2lfBIbVp4HqnEsQnto9a5bzIfkJtBcDLxCzY3jK4DGHmU8sTV9NZhk55vTkWSZKnIr67MPcUCipLNja90UzGmaXQF+dT4uOXQ0/8Q72j7S19bzwllhRD5pCXOKBT+gJyWgzGRTQLazdQmHOv4LyMlUnnFBfQu26sqwfgoj51SNO3UqWMO++nXxfBqVtYbhWF3b6Kdbq2jJ9RTGFbRlLfJ0aTO3sYLRaRZ08YEq+fq2kb6ac/xbah+bNjZOrHp1/TJt+a4N6F7Hsgmes0ZQaPkT3ssVbDh3vCUzqROvjGtUzi4FQpHCnkgOWFMhUpnJR0oAE/OKb3BpvS
 +O6whQGg
 btY7Hqg5WHKv9Tbcfu7/FlUw16+4TQktf8ctOh6+YF6/uSeI6vWM6nYAVyaQ0Fzr+akhJJPyl7YF5/hAez8xcOKxH2BKIfLhtEGCZN260eD0UiwsaDuyAWO1GOjK0DwZ9hmmJe8EY5aBXlsZ2rGx2jtn2d7ZUILDff3Brr+hY1Xs2xCf4AVU9QDzQviGBVj7HzCt7EQucjtF7RRl7ZUfQLzaf5Z1OlBICaHgg+dIEZ95Ttas9D0bof2gdUM2ZMnw69n5LiCnUsxaeBdKpajAQwAUFXXKpuyoWTBYzpHYwmaS6oKgrkTir7/6aRUqLHiuiBHFuj6bkNkz9B4Y9JhDQM7wr+wqC/QLIjZIMer+Di7Xs7lRN6WwLrmUD9z+h/kdMumqwKYnjjBucPUaP0QobL55WhRN1WjyNCdTFvMuds2j2mzhlOQuneXv3NtGrytl+gO7ObtZhrsonMuE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 09, 2026 at 11:10:20AM -0700, Andrew Morton wrote:
> On Tue, 9 Jun 2026 06:12:49 -0400 "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > TestSetPageHWPoison() is called without zone->lock, so its atomic
> > update to page->flags can race with non-atomic flag operations
> > that run under zone->lock in the buddy allocator.
> > 
> > In particular, __free_pages_prepare() does:
> > 
> >     page->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
> > 
> > This non-atomic read-modify-write, while correctly excluding
> > __PG_HWPOISON from the mask, can still lose a concurrent
> > TestSetPageHWPoison if the read happens before the poison bit
> > is set and the write happens after.  Will only get worse if/when
> > we add more non-atomic flag operations.
> > 
> > Fix by acquiring zone->lock around TestSetPageHWPoison and
> > around ClearPageHWPoison in the retry path.  This
> > serializes with all buddy flag manipulation.  The cost is
> > negligible: one lock/unlock in an extremely rare path
> > (hardware memory errors).
> > 
> > Note: SetPageHWPoison and TestClearPageHWPoison calls elsewhere
> > in this file operate on pages already removed from the buddy
> > allocator or on non-buddy pages (DAX, hugetlb), so they do not
> > need zone->lock protection.
> 
> Sashiko is saying this doesn't do anything "Because
> __free_pages_prepare() executes entirely locklessly".  Did it goof?
> 
> https://sashiko.dev/#/patchset/df06b66fe4ff8e925ee0714955abc2183a727b90.1780998980.git.mst@redhat.com
>

Oh. So it only helps with the prezero patches. Maybe other places where
flags are touched locklessly. Not __free_pages_prepare. I was too
focused on that. Scrap this please. I'll try to think of something.


-- 
MST


