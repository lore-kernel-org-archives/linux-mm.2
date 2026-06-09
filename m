Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F7E6CD8CA4
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 09:54:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9CD96B009B; Tue,  9 Jun 2026 05:54:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A73F96B009D; Tue,  9 Jun 2026 05:54:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 989F36B009E; Tue,  9 Jun 2026 05:54:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 88A4D6B009B
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 05:54:26 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 511F11C281F
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:54:26 +0000 (UTC)
X-FDA: 84859914132.21.A94CD83
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id E7041180002
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:54:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fJZxcPi2;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780998864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W5AGHJKl709rDF75fggz2CPtkzpWxiGnDcPVzzKSTGA=;
	b=Q86PzixOugIUF4g70FpiOb9/oDGv3742b8vUyrcYmN3qCb4nxjt4h6ZT7/RyJSGTFsmznA
	kvJ838H6yByM9S7/2wjuTHJopL1l2FlPrl6JkTduAawa9I4pPvw+u3fTuwrfM4A9lY5bCn
	JrbOutOW4XTEOiA5s8i6TsHk3Voa1Z0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fJZxcPi2;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780998864;
	b=10uZ7R1QDTa24MPu6nltTICEdNSzDeISWFClCJbOc9C1AL+24omjT3S9hbtOwj09z8gey9
	Zh38MzyZHKIHRWyPqjgPT+SmGB6Agdq01hV1ZhjhV2FdjLCSuj3Zw8bvNgusEUfHojdJr6
	YMr3C/P6TKbUMiFt+90Vv2zs35M5teo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780998863;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=W5AGHJKl709rDF75fggz2CPtkzpWxiGnDcPVzzKSTGA=;
	b=fJZxcPi2dDnj6kVMKcASWJDsYC8zewraoDMaJHxLCy1cZFHmPsCsHzSfz94Zj28k9J4zD2
	LIL04CkeEgNisoXjUmwA+P75WM0VthWq9DuNYvSSQYbWK43HTsrD22SC3/c0QkldDkuMRo
	nIvICMGDPLSE0kOa7c3wbwGo+lMsDUk=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-423-TSbrk1r8NtmTnLQv4hJQCA-1; Tue, 09 Jun 2026 05:54:20 -0400
X-MC-Unique: TSbrk1r8NtmTnLQv4hJQCA-1
X-Mimecast-MFC-AGG-ID: TSbrk1r8NtmTnLQv4hJQCA_1780998859
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-beb5131c31cso305912866b.3
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 02:54:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780998859; x=1781603659;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W5AGHJKl709rDF75fggz2CPtkzpWxiGnDcPVzzKSTGA=;
        b=pp4I8w3UFSx40ZY+Rr5JKKPJZMS+hn7iSLtqvmcXCDeJY/0Jynw1IWsEkNQU5FqeD7
         x/mnf0hvwfsnV7OdZzT18PNHPjC6pxkRHpiLqXdd7rpKTFu2QuiDZZmsHoOm0M+y7Whl
         Y4KFs6AX0yQw8vYV+ZtNbFS8I6/eB0MY/woCsw2CG8I4YTbx1pU+LX3VhIbIdGJ2kuoU
         58Hqh5ixsbSJuafI1lucbLOz6wtiOkgAr9m5AzSMt90KXIXFAsS6OIApuJOKTLht/oTK
         g3dBGw9R25xst/6FNzO6g8daluXAAhHGdSLMvh4G0OUfFu/LS02Hp+Q7UNUjEVPaogIi
         xZOw==
X-Forwarded-Encrypted: i=1; AFNElJ+S1dIsXKLiCJyAkKfNZ9XtNlclQoXd5Jmvvh57bcTXmkkblW+glYLR9cEznlQHj228RZ/kcHiSpw==@kvack.org
X-Gm-Message-State: AOJu0YxFiHs8fxsuDjnZgd365SsCjb4DufVgjMb5UDmBUTv4vUPTTmkQ
	z8WizFuCkri/k+s18waeK8K9uQnm/JvoYy3Pl1e6VJ/E/oRBX6Yzm1AhMLD4r5xCOOwRl4LCiyB
	FzCFhpHo5LCoRmCcSoxXb5jugwh12+53N/a8C6D0JkHVQZZg90URy
X-Gm-Gg: Acq92OEfjeEbSHbIt+SCRg0V6TSaye2qY50TZlpUoZ+5q89r97vkcOcP+aI0GyouOza
	IvFhrFJFtTIghMPiByVNloTtkWd3WqN3vP/XVx+w71vbDWi4dM6/n7eldJ8AD/phrz8qq4koFYV
	hQl7epNv24DHGig3hduTWlnsiJoro7RoTb4sAoE1aBhrtSaDaGVq6HRUngZOOppm2pF8r4qB/z0
	2rGcC/RwYZNmNitjXfM2rPdWzmdWV+NydimgYovOu5L3dacLuoejpsdWST/ymzJGQLi+JD8/F6r
	mz0XY/rITdk2m75WcmtnQQLUOcEXxHHv3B/DYgx74IaBrMVK7N6dg50EAyVnzVpiWSZj0eMmVBd
	5fQpFrbryVzT7zIk6Hbx3E8atojmi3AaG0l2KzJThmb+bTppCHA+WVw==
X-Received: by 2002:a17:907:ca84:b0:bee:f72a:28d6 with SMTP id a640c23a62f3a-bf37096c195mr956581466b.14.1780998858691;
        Tue, 09 Jun 2026 02:54:18 -0700 (PDT)
X-Received: by 2002:a17:907:ca84:b0:bee:f72a:28d6 with SMTP id a640c23a62f3a-bf37096c195mr956576466b.14.1780998858161;
        Tue, 09 Jun 2026 02:54:18 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-85-71.inter.net.il. [80.230.85.71])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bf051e9aa33sm1010527766b.24.2026.06.09.02.54.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 02:54:17 -0700 (PDT)
Date: Tue, 9 Jun 2026 05:54:11 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
	linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
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
Subject: Re: [PATCH v10 07/37] mm: thread user_addr through page allocator
 for cache-friendly zeroing
Message-ID: <20260609055317-mutt-send-email-mst@kernel.org>
References: <50d410b47fe3f45327783e05bd306d5eaab75e65.1780906288.git.mst@redhat.com>
 <aiaUDTeHDA45ZXFS@lucifer>
 <aiagMc9Ng_AE_adh@lucifer>
 <aia93IzhTgi1vGi6@casper.infradead.org>
 <aia-q026facbptoT@lucifer>
 <d0ff6269-8b8a-4983-8569-d9a8495829f3@kernel.org>
 <aibSPsc33YQiYSMI@casper.infradead.org>
 <ef14cfdf-5f1f-4e3b-846d-fe1462042883@kernel.org>
 <aibVTe5HTk-fF_kj@casper.infradead.org>
 <68ac0163-865a-452e-b643-351e094cb2ba@kernel.org>
MIME-Version: 1.0
In-Reply-To: <68ac0163-865a-452e-b643-351e094cb2ba@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9fd_2OjN95NMdWXtaUUAH6fLQUU4H1cPIQtmpnvcYBU_1780998859
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E7041180002
X-Stat-Signature: nr3f8ims5i9ymwi41s66uzii8eq5cisd
X-Rspam-User: 
X-HE-Tag: 1780998863-206924
X-HE-Meta: U2FsdGVkX1+2CYNjGIDkZ1SP1iL6v7cx0Ov9ePpGXPdWgk60cG5cu+8U1lj9ZBGRS61vVUsdGpLa+wF0LoxgYSGJbWx6j8FK5BOTdAcQW/sK64U/FgnbEsrlwThEOCvBjhPqZ3a9P6/HC9PcdRFD9ldXYxcn21kMXA6ovBdAMcNQCsxs3+X8j3kucuqd0pf+eumH6J9m0GZ0YIQJe4Yld06YUPBmBrQWyvb874hpxsFO2MPCQYmDsPDFN+2KdBXz4l0GToRCjQgxSsKFhYJaUnOoDKFqTgTbGBS3jqWb5pWd+ZvIAAcxqpAwcgLfTlKEVMK+pWs4O5M8Gr845akB+2I20yA0Lsvw+1aqr+b+hYH0uYqGtnqRIeHjrcWuQ4rC+TGF3/tUCkDDZfR97rxL6TJ7PcjZT6YRZXcVrm9NOlXO+Q71FaE6bRzcD2YyGupeCUqiNEeNYT2zYBgUYiRnBB3zl1i6jex7YTsbfJTS+H6wGZa6rUfbeh0QkGYfGrCi4uOOt9axG0vOfgkiNAjhIF1fYid8H/zRucK/PpumzMpxeuJDk2PqlTi/wIMFBvMSkaK7EXDmgFvg4jXk6p3hLOmhzCgwWfs4JlhLQ1Mx95UKjRf2xf633kh54w9gwzQg28PsEBuH0BMm+VmCUFpKtn/gMolb1bTVBSdPkJYdZk9PIH1zH+Buj1MqWP3bigVOV+85Lfja49iJ3AzEwMyTVIdFCgcqkk0AwEvgC6UXsDXVFu3WNkLE77brug2vPoKyz7fxjaAmb5K+M+tXtFDO/z4OV018DYYY241RQoT9B8/LQXyCCxlvs4yl2UBu8FSqEPCPFyInbBxQ/lanl2c2MpOLEvj7Qbdou0jWIrCjWVMLiTeFN2O10FQnLIdp36ksRgbB2VWPnFIyLn67VtQf+umtmMvBYDl0MwQavxgJlnq8ePheyqBggxft4I4gVCSH59In9Fu7x+qOOPlL8Pz
 1/b3Km3k
 7SKCWPoCSK0kATg35Ly/LX/bbhQO6k1et6Jcf/2xxo+wstg0s+rKF2MlrcNehzA0gO+udZOGX3KZucE+pdTHScGa0WTygfUKi50RWO1EpMIFdDBbug7CK/Oc8Q0dFGUREI78uDlUWw21fhyDuGvt9b2QNvQ4K7uPdsgslq4d1WNW3cW65XTKMLxmQfV9qawQtTNwZ6ku1H+CQ944HCyqaD317gBBjQGWk96j+3kcVE5jvTpSPHVIQbPl0aJufn8/amVnyC0OF6NPwpk4KJm99833RiWbtAceK96eoKrgZ4IqmOUJDchXC4y8L1Dfz45EqIE5qWGqRM93omt2TaqgMV+kjUtsps9ZCa5sAkcbhAqKIF2jtk4cN7/RF6hyncDmilorgIC/XSRZmsNNjpGayLY0xV+5itGvLGDh/WnDdPKGDUhUEcLihUChBIBrzTgDd66nHQMPUIuEYIKU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 04:55:19PM +0200, David Hildenbrand (Arm) wrote:
> On 6/8/26 16:44, Matthew Wilcox wrote:
> > On Mon, Jun 08, 2026 at 04:37:03PM +0200, David Hildenbrand (Arm) wrote:
> >> On 6/8/26 16:31, Matthew Wilcox wrote:
> >>>
> >>> What I don't understand is how the kernel page allocator needs to know
> >>> the user address in order to effectively zero it, but the hypervisor is
> >>> able to zero the page without knowing the user address.  It feels like
> >>> somebody has x86-centric thinking where cache colouring doesn't matter.
> >>
> >> (not commenting on the icache dache mess we have to drag along)
> > 
> > Well, that was kind of the point of this email ... I did ask the
> > question you're answering in a different email so let me respond
> > to that too.
> 
> Now I'm confused :)
> 
> > 
> >> The thing is that with free-page-reporting the memory is already zeroed by the
> >> hypervisor as part of discarding that memory previously (e.g., MADV_DONTNEED)
> >> and allocating fresh pages on re-access.
> >>
> >> So it's not a question of "why is the hypervisor zeroing less efficiently", as
> >> zeroing is just a side-product of reclaiming that memory in the first place.
> > 
> > We definitely have users who don't want the guest to trust the
> > hypervisor.  So how do they disable this optimisation?
> 
> Right, I don't think we currently have a toggle to disable free page reporting.
> So IIUC, this optimization would similarly automatically get enabled if the
> hypervisor advertises it.
> 
> -- 
> Cheers,
> 
> David

Not as the patchset stands:

[PATCH v10 35/37] virtio_balloon: disable reporting zeroed optimization for confidential guests

disables it.

-- 
MST


