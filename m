Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A49F2CD37AC
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 23:29:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF7EC6B0005; Wed, 13 May 2026 19:29:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA88A6B0088; Wed, 13 May 2026 19:29:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9979C6B008A; Wed, 13 May 2026 19:29:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8A7976B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 19:29:21 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 29226A02AA
	for <linux-mm@kvack.org>; Wed, 13 May 2026 23:29:21 +0000 (UTC)
X-FDA: 84763990122.25.5F2B53F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id F4234A0007
	for <linux-mm@kvack.org>; Wed, 13 May 2026 23:29:18 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ephJ37MO;
	spf=pass (imf15.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778714959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=izvY07KqS+wf5+fN6802J9TRTtuhLJpx997g9sZkIas=;
	b=j6EcGsAgOGpmhq+bihtpTppeEPgsSK6hU0Bj/4TOyqs3qQImw+iX4UsEt54kHaZQ0dIUmz
	/a+9YQ2o/qdLR9B1kjwXqZ+MinFIwHeCo/cjKnKN3o7W4acZg7/WPKakCCF0yrsvux0vol
	TrUY+bj27G67rj3DlYLp6O0CUWKA5H8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ephJ37MO;
	spf=pass (imf15.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778714959; a=rsa-sha256;
	cv=none;
	b=pE3srWIzpJ4lgzzaw5zl/NsvU8hFzDuCE6/LzV44FwMBRM+r7FodM45egMeBaxBkdMTRqe
	7+bGn9vgCg3w3R9pmr7Sthm9k6J/1r0AM7XKGPdcwsvow9SBIH4IjSZXddDBxkkJoG1fyO
	DJ01Vy7RarYENzUgrIknGEN4o4TOuL4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778714958;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=izvY07KqS+wf5+fN6802J9TRTtuhLJpx997g9sZkIas=;
	b=ephJ37MOXlflLCJdNeO0M+4A7r0qyj5SsjDuimd+uc3gkVDvkDjZ35bj2828tg+nWIp4qP
	EvtqObbxdPj/U7ZwXktmlgf7+1x+QtcOLstFlSU9s8S6kHqdhdNORK+OiEPwbU+0opUo+o
	WLiAbqHkE4ZcVMVxTKOuddDELit7Ezc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-111-uHpPM3cNNGClJFtd7p-lLw-1; Wed, 13 May 2026 19:29:16 -0400
X-MC-Unique: uHpPM3cNNGClJFtd7p-lLw-1
X-Mimecast-MFC-AGG-ID: uHpPM3cNNGClJFtd7p-lLw_1778714956
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-44d9ace59efso4869731f8f.1
        for <linux-mm@kvack.org>; Wed, 13 May 2026 16:29:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778714956; x=1779319756;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=izvY07KqS+wf5+fN6802J9TRTtuhLJpx997g9sZkIas=;
        b=IjSSIKVe/BkTMDXOc6AOqjgCvfbJD7iU/4h4lIVJjqyZHpziWt/CeqkMyaw2S0xn9O
         WHrAtxGXyiOR5XhJv11jPHM4wJAf+Wuu1WycKcw7HbradgizS+6nu+/E2AAavyVyfA0h
         f1/UYMzmQcP+FOHB4NRrEVxVJCK8crgjuk9fTrpFjLJynND1eH2stCqhJOt86P7Hnw2j
         neqvD4wNol3qj+rKzcK7u6uBdKrdzcxXXNO2n6gBUiDPNJ1CdByDOFdmcGdYRsXYYd/2
         PPsrrEKM2GLehMvwlerYxezNcWBy4UuIfScLjKVCrB8AMhKGlUl+cYQjQqJzqeiWNvas
         K3Ow==
X-Forwarded-Encrypted: i=1; AFNElJ+CcB/mbJO7ZHK09MUoY9uH82oBWi6NPq1nyWn9jhSoP6PuEBLJJ4S5f71AoDt28aJ6f3e5XQRtzQ==@kvack.org
X-Gm-Message-State: AOJu0YyZwNFpf2eMZquUPkxQv8p7cILf4eyJtFCo/ICGnIjiULfUGuc6
	YR9ZfwA4Z4mXY2Dk3UheRRC+aw5BGjHwfxhkGHYZEUmuD9LFuRSIQxWCEmkm71N7EH98t5UKdAH
	SC/ozTdK9Fw/AfmVhNE+wlvCpGAs7TiyZwNGltNgjg4ZE0qagTMu/
X-Gm-Gg: Acq92OGCuXYRkq/BTr2jM084MRM+7f/jYsFFsNiy/1i1I+1rgpOBTW0k5Vx0R8MYCAY
	hIfsqGMCFo35imHQdHwYpllPsNWDJbVAm7A289BgL06TKWgG2fBjnlWKaQKjB4/gR+9ogXvbjDB
	cun/SyJLdRNHj2da9wy1EJCqYgNAnS1vAtBxeryOYBv+49K9Ev1axn4r+M7+/AZe7lAfM1Jour/
	ro0sZoilDHbREIeLVfIoWqh49i9Wa3ZM3KthQov5y5qlDmUcprEJ/Y2QIkSC/XgUcWZnQ2yqfvv
	K0GOGaZtLd8lvKjIXPW19i+tYxyjRnxjJXSj0BoY2XOipVRoZ+sBaiVci1np9EXVIE7smWdp8gS
	npjwLiiOeh9L98n+yWNejypcvL9fkHwu1cW8rzLgnZtI2gdsFERY=
X-Received: by 2002:a5d:5d87:0:b0:441:1c18:f779 with SMTP id ffacd0b85a97d-45c59cce4demr8601829f8f.37.1778714955697;
        Wed, 13 May 2026 16:29:15 -0700 (PDT)
X-Received: by 2002:a5d:5d87:0:b0:441:1c18:f779 with SMTP id ffacd0b85a97d-45c59cce4demr8601791f8f.37.1778714955170;
        Wed, 13 May 2026 16:29:15 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45d9ed2ffdfsm2070342f8f.15.2026.05.13.16.29.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2026 16:29:14 -0700 (PDT)
Date: Wed, 13 May 2026 19:29:08 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Price <gourry@gourry.net>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
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
Subject: Re: [PATCH v7 00/31] mm/virtio: skip redundant zeroing of
 host-zeroed pages
Message-ID: <20260513192734-mutt-send-email-mst@kernel.org>
References: <cover.1778616612.git.mst@redhat.com>
 <e7e9b30f-ee5c-44c4-b377-d70156be41e9@kernel.org>
 <agSoDnbk5rjx9yM1@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
In-Reply-To: <agSoDnbk5rjx9yM1@gourry-fedora-PF4VCD3F>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 39f69e-oLoe32QlMUzmtYQo00DTXussaE3PU4LUfR7Y_1778714956
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F4234A0007
X-Rspam-User: 
X-Stat-Signature: o7eymozetxttbuns7z3mu84wfdhxzm77
X-HE-Tag: 1778714958-976419
X-HE-Meta: U2FsdGVkX18drtL5mZtnxtVqWbK69V/if38Lm3ftDdJPfAbgwHVJcXUmUcNXtPtvFkmLQ9tZdkF6SENN+F6v2Zek5RSMSBQup1O0mKDWaS9j2TS2861hsu3V+RbPu3Vu5C2ZB05PsQlbgmg7TGTSpJIQVmbVQ3Wf+2UxLqUPbuRozumezoa7s6i+3o+nLPFr+0RRoSOMHOeDAtR3DjUDcOdWxBpH5Xd/xz5EClE1Q4XEx9qxYFbYQ702DBJ+Z2qmXIpavuygY/NyrMyYGzj7dY45fjLjPQ+ugzlnKZBEtwC2bZOotk709v7P3dFUay/t+Ym7aKOjYnTyq5s5s5Y6YRw2d7UdKGcbTKw96NHGJ49JwTsDBQmoCHnqkyaVo5+PvtefcrJ0i+VzGm15nn/ih/kWCj3R9D/xPeh+hqdkqYXkDz+aQzn8Je0brtbnt4EWN5pkDI8LvIIU0bgGL27Mr6UzDc9pxjHJt6iSHf65iCDc7wuXdxbxf+dGgnHFkYs+ZJHclRD4QLFDuWwgZM4Zx9DKwPfDLqK3QxxGo7NYTRLv0UJf8L6+tYBtaUjew76Y0pVVKvtJD/w+zoImA9zByFdoQ1u3WBQd4TcuqEvILPD5ODnZLaIz8tfFH2pFZ/pRIl6V6mi1v2VccHwpnurPVW8iBOV2eDR0jK+RlTNAaIXUpKa4ttGQ325rzK7/AmEYl4ccUa2cWxElu9FGWkR2+kRHMBdq53a3MMkG0PH2vT6SJplM32aB8DARQ5zp6+4shMoEIHGlheansb/7L19E5iu3pLZ7Iaoew9WUK3+wnZdkF66GLtqtRlKFXhtqGDwtw8s96jUo4xvh8o64yMQD8moSzvidIY+b7eTLE6eSva0ABPVT9zRR8CW2yoTAeerKz0/mpio4ewEt/NTTga82zHyJQBlXjSiPOTkYqGSrd37zHPa51qrTuAh+hiLjQ0xqC9mXqe7+dVBbB6qd0Fg
 qhFXc5UV
 4XJr9RnnXM3Wh9BUCaASS8w+q52cxA3TGl/dvNTYu2OnWqL7c+jk4rtS3WEg4X9sR9yzFWvOv2WA2Yk4WpCf+P1uqKeE4vQC4QAmDPCIDjR599gReqnlMlw2I1KGN0mGLidYDPqpLCF/7gskKpszoKmDkXmE2VwfaJ7y+T+t2Tc6k13ccKvBJ3x2l9eIAeA0ku04AuCP4s6Vtteq2kH/aO/vGMVa3Lo4Fstf8Cdih0/fTdfU4YlINmJ8YtNMYEpLEfpKqdOVIBVeP16K4/sl2jehGlB7kQYWQQ6fGx0lk5fnmLhBmv+2cgEGl9XzWR3z2BnV0zz4GsGapuSLHT/O3bGDXjXMt6yKRwLWbt54vXKKNbIs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 12:34:22PM -0400, Gregory Price wrote:
> On Wed, May 13, 2026 at 09:36:06AM +0200, David Hildenbrand (Arm) wrote:
> > 
> > Please wait at least a week before sending out new versions of this size.
> > 
> > It's just a lot of noise in people's inbox, and as raised, a lot of people won't
> > manage to review this before next month.
> > 
> 
> Also I wasn't even done reviewing what you had previously sent lol.

Sorry thought you were.

> I can only spare so much time each week on upstream patch review :]


You certainly invested more than a fair share on this one, thanks a lot!

> (This is also the pot calling the kettle black, I am guilty of doing
>  this same thing so uh... lesson learned, sorry David and Andrew!)
> 
> ~Gregory

Ya I clearly overdid it. I'll wait at least a week. Thanks!

-- 
MST


