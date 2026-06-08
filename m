Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2B43CD8CA7
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 22:28:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8BA36B008A; Mon,  8 Jun 2026 18:28:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C62CC6B008C; Mon,  8 Jun 2026 18:28:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B78E26B0092; Mon,  8 Jun 2026 18:28:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A696A6B008A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 18:28:48 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E762AC017E
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 22:28:47 +0000 (UTC)
X-FDA: 84858186294.06.77C7385
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf23.hostedemail.com (Postfix) with ESMTP id 17A94140006
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 22:28:45 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=IWPXM6zb;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780957726;
	b=g+asIKWprLLXvtolwA7WcHKvRjXoVOcNsoG0d+0Av+xdPiHQYvOHfDnDNdjjLCNhhwE55z
	fB10mE8WDjKjgr0yHHbjKAnNm9AzPZmeCzy91NDhYLSW2XFJ3yx2oWWPUakvpQlNm2Znmy
	9zYo74cjPpSWohcvdMM07t1pEyIqNcQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=IWPXM6zb;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780957726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/gX/mp9SJHUWlSmoLEXlEEj6nZQtwhCmJ71m3qpbTAE=;
	b=O0femWs5/qDTNlRPlQMBxC15Tu/a4vkqtK3pygzK/mSDoSHN+pld2y+JNqa7J3KR8uqm4z
	FrQJ+S70/a6+jeKGaiLa2B2k/LgwNQs7t1+kM8t78YZgFQLszJ7NlWmzsFEuM8jdhJMYyT
	5WsAWMWFknMXha2PVx5+HxLduzJ0Za8=
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-915bf8800a2so272984285a.0
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 15:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1780957725; x=1781562525; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/gX/mp9SJHUWlSmoLEXlEEj6nZQtwhCmJ71m3qpbTAE=;
        b=IWPXM6zb+Ph2DWuVVbGcVoNqR+QjipeJdhBtr2YoCt/duLmw4kDXXirsdXmtBTlZGp
         i9SCmUgbM3rEcyxB5PuVrU7G5hN3wOY/q9sCfWR2E6DGkJDHecu24mYOv96VUmkf1nsk
         +7r7529qAMmDuF5TGVV2FkmMlMfaKk6ZvLRDsjUpLMeMVVa0cS0YMxAs6e5l7W6Qz646
         adtJz4WHFWQrPUDLLhg5X000+fAWnlYX2wQMBsIfZlkvnviFTLs73KYmhsyy319gZ01g
         88j/34cNES9pvjt79g2JIJly0HMi04Zyko9gu1a1e2YyLuoS4AcW/HYZQJIlV5wZTDsX
         ltFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780957725; x=1781562525;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/gX/mp9SJHUWlSmoLEXlEEj6nZQtwhCmJ71m3qpbTAE=;
        b=MrAyx9PBFfgEC4GyFMtKwkkezlM/vvwz03U4wzs1Qs1nninR3D4gVzZL6IEQogUU5J
         272E+1ypbGvOeuj9DemsVxozkYFC/9Xj8bIp5WaUG0DbrD9/dJIGW0hnwf0cv4Wg164S
         wCBmjhjV734awxoCXtD4TdWZkE5mxgOXInxAvZSVOS3J6/0X0Vuq+He8TdgCQd/Wbp9/
         d7yzzyMKl8nRxVI1aLg2HK+kgKvbE2eETj/WYn9hmfc4xTBnFBjAuLJYDagVFpH9Kcbs
         o/Y5XDjAyCUhGyaHGDwwkWSG8fpNwlnB6fDYWDqGTdksS8tYVobIThBt/eRqFpAbcGIC
         aqbw==
X-Forwarded-Encrypted: i=1; AFNElJ/uZlc0/2dj3Z1E1YqHHX4a/Nq2G96Uza09+AYU57yNLKEekbJTj9Hfg52Bv1AKDGyD7lt8kV/7qQ==@kvack.org
X-Gm-Message-State: AOJu0YwH7bOIEU+UkVbu3NYIyGtxzPoEgTQ32lgXfyZXRwFo2TiXgABu
	ZG6MjwVnT5np3iYtqKQziRreBdkdVtkzne/D4/jWoD7ePFLGCh0SP86diSWM37ySwkg=
X-Gm-Gg: Acq92OEJ7YUd8zOgrHSenhZOZL5Yu14xufB5bzVTGnoSVdwgDie8+mexurfhVQEhkDu
	MPdF4Jk1vdixoo2+Xtj8LYrnfCvGMy0IKXNNAYCOEnJ2B0R2lyO4IbgwpYCyiSlfFdpvheY8+9h
	RwRjskJRpbzIjSXT388iSECA+Erp0O5sdQCR+FpDUZQ5OPlZPxB+GeI/25ImsVcejPbCpKjJHMv
	Q9LbjXxkJOSXBS+NRqnhMdo1rozEDNU+8ahw+4zYy1MWGCMBOEmZPYR044eAPT29YtZhC0QuN0t
	K2xXcGpSFh/ZkXBkXvmKFPOc7xbzCdjdF1JBxXUlqUFI5Gw/Uo8J3BRvrmHkIm2MxNpPkcIk6rJ
	32umccP1VOX64adIztuD1K7kmIrOI1aI7HndUMt+PbkNmmgBDcIVxrqAcEnI1xsmocO/jm7oFXD
	h4993iNeDxpo8p9PCWQlEZMAf6pr0lDpyp26FaNSJzUbhmxzxX6tCs24QHXVOGiUvZvHkGxqfmb
	Q7uXQP+ZDZ+XMrKow==
X-Received: by 2002:a05:620a:454b:b0:915:a953:4b9c with SMTP id af79cd13be357-915a9c3659dmr2911955885a.3.1780957725130;
        Mon, 08 Jun 2026 15:28:45 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9158a37c645sm1828519985a.30.2026.06.08.15.28.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 15:28:44 -0700 (PDT)
Date: Mon, 8 Jun 2026 18:28:42 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, "Michael S. Tsirkin" <mst@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>, linux-kernel@vger.kernel.org,
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
	Johannes Weiner <hannes@cmpxchg.org>,
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
Subject: Re: [PATCH v10 07/37] mm: thread user_addr through page allocator
 for cache-friendly zeroing
Message-ID: <aidCGkafm9yUDTuf@gourry-fedora-PF4VCD3F>
References: <aiaUDTeHDA45ZXFS@lucifer>
 <aiagMc9Ng_AE_adh@lucifer>
 <aia93IzhTgi1vGi6@casper.infradead.org>
 <aicfERTP3H6AndOs@gourry-fedora-PF4VCD3F>
 <D1CF67EF-2CF1-45F8-9265-70A528C1CB01@nvidia.com>
 <20260608163257-mutt-send-email-mst@kernel.org>
 <BD0C8760-BC10-4BF0-9EE3-9B0DAF0D977A@nvidia.com>
 <20260608170348-mutt-send-email-mst@kernel.org>
 <DD2E08E8-1FD7-43E3-A2C8-B4435D3773D1@nvidia.com>
 <afb14c99-162c-4c36-b1ef-fe971678f6b9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afb14c99-162c-4c36-b1ef-fe971678f6b9@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 17A94140006
X-Rspam-User: 
X-Stat-Signature: tiupjw5hd43z4e37azphana8o99dx517
X-HE-Tag: 1780957725-564477
X-HE-Meta: U2FsdGVkX18ImgREyQpxqsaLV7xMxneFmsnBZjiB0XcjD9HNHt7nRzi7f4OAparX8Dfx7/m3086AWQBua9AdyE54dPbmu/2WkVub0Fu3z1gAxrLKraE6Uk++X0U9udWPnJGWvoWk5IfDgNRfOvDYCHk/0Y91qQ20oV2ZFGzCUFW1VTYWDjeg53u4SqqMQLof8knh7Oiwi5YrGDtqB9suIka7YJ7IVc1Rg7NSD16f2FS3RqXb+9J9P00NnMdwlZfdYqsieGlb/1tL0fTSOVyfipfp9JAIZjfHrB6O/uT7Qy0azzcSmn7n+W0Rb1HD/yKdX/+FplGyTMSadXMn7V0lj/QviupqJyjuUynKdzskaUQXmwiYtXeLdoUp8DDpLsCoSg1v/MAJ0CUy7InZCdTlrOG15G9A37skJjB6OcayEUI0yGpkiSMDn70vAhUyaD95sPWUs2z+1WDA/N0XhLNGms+zR5tPYMVfIFS6HmuMXwu55jLUQ0V7DyalWEv55TuKhZGk1pPpczb3gyCjZGC3MvYWjD8dbC1sDo8TVbhBTAtKpcNF57nQpQQMnBYwKhJ5PTh3QbmOB9zMkp/MTo6Kk+H86TYuIc4F4EcipzlP8Q/0OXenba4vGxx66I7LpDgGU2DZFuU+fyDS32diIzKH8aNs9zpWtmPQm84vw75sqSTGJHm5nTiTUHVMIirACFmNX41Nc4toIF9H6ju+zG523SlgUtx3yunHNewRL5OAt43zu86uG1TQupSBFgNb0EI59mdKS8kX61sPYPxU7eCWF64mTpX3Je6FVv1ZVoMSVXaDvguUtug37bHE7J4pBfKYuNTwDEow73TzXeNAHV6ZK+cG/LSWrSW1xJxI6/hLsr4aUe+V/N3bYabhpk+PKnoVRfQjcMLRIIlfFRG5BwjDiJ44LCgEWxhUh3psVDGvjBfnm2DelE/pdmOEVdaO3G+9sn20WypJ5ZK5oyb7ABi
 FOzoIW4O
 NoEC8rmHV2gIwfxM5LJw4h8EUVCVuOXCwI17GsgQfSD/DHMKPvsaSzRbVFeHogX/iwPGh10axJhTy6tG4FXQP/kNR0vFyjUFjBa7XfBPFRD2lRuQvPGPTyoJQ7qG0xCjrNwl6dIxB3u3y7DGAxSPwgAs4RqsGdJHHuIb4gOWgbDVwVDxO6lC6wXWHjcRNFs6c3K73ik302LK93anvLrZ8YmrAFOb3c8JGDqRwAmV19fqS5wwiKxwf5KzEccz7BVi1kNuY1DWngmrQPqKO+PCJxqSKJql6viFcVEFrdDDf4Up5k2pa0A5g7QcYYjTvpsOqNPLRUlpckZDV6mmJG+7VJTRqGbso5RA+2X3OAZ/C9rOgtLDQDiWkoF8qq8wk1rmjg39WQj2MnFK3SWvDUwLYWvFYz61JbAKlDjmrZpTB7UWoeqniq66aUM5U/XYI9i1U+5/9qkY1dPvlEwS9URH+esLvJWK8jLuca4ixxcZagp55whkoeRACF9/YMpXhzfa8gXZnUxmibDQ51cNCY0zyrfoQmh6S6hp/dBSM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 11:51:47PM +0200, David Hildenbrand (Arm) wrote:
> On 6/8/26 23:16, Zi Yan wrote:
> 
> There was Willy's comment in RFC v3 [1], which had 19 patches. Unfortunately, he
> no longer followed up to my initial push back and Michael's question later [2].
> 
> That would have probably been the right time to wait for more discussion.
> 
> RFC v4 had 22 patches with little replies.
> v5 had 28 patches with little replies.
> v6 had 30 patches with no replies.
> v7 had 31 patches with little replies.
> v8 had 37 patches with no replies.
> 
> [1] https://lore.kernel.org/lkml/aeu5P1bZW3yEH54t@casper.infradead.org/
> [2] https://lore.kernel.org/lkml/20260426165330-mutt-send-email-mst@kernel.org/
>

Hm, rewinding on this back to v3 here:
https://lore.kernel.org/lkml/016cc5e5-044c-46c6-a668-200f90a64d85@kernel.org/

You said:

  ```
  Exactly, that's why I am saying that vma_alloc_folio() is the only
  external interface people should be using with a user address.
  ```

Going through the list of folio_zero_user references:

Called unconditionally if a folio is acquired:
   fs/hugetlbfs/inode.c:   folio_zero_user(folio, addr);
   mm/hugetlb.c:           folio_zero_user(folio, vmf->real_address);
   mm/memfd.c:             folio_zero_user(folio, 0);

Called when user_alloc_needs_zeroing() and charging passes:
   mm/huge_memory.c:       folio_zero_user(folio, addr);
   mm/memory.c:            folio_zero_user(folio, vmf->address);

No one outside mm/ should know about this interface at all.
Arguably none of these should know about this interface either.

The appropriate place for this logic appears to be:
    vma_alloc_folio
    alloc_hugetlb_folio
    alloc_hugetlb_folio_reserve

The reason to sink it into the post_alloc_hook is to let the buddy
decide whether the page actually needs to be zeroed (like the virtio
situation) based on PG_zeroed or whatever.

It seems like at a minimum moving the logic all the way into
post_alloc_hook lets us actually delete folio_zero_user() as a published
interface and move it entirely within page_alloc.c.

The catch is user_alloc_needs_zeroing() coming along with it.

~Gregory

