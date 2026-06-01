Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDBF0CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 12:14:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2396F6B0366; Mon,  1 Jun 2026 08:14:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19B556B0367; Mon,  1 Jun 2026 08:14:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03C716B0368; Mon,  1 Jun 2026 08:14:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EA5FC6B0366
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:14:12 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 99C621C0AE5
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:14:12 +0000 (UTC)
X-FDA: 84831235944.01.394A8D8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id F3ACC40006
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:14:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="e/nh7IKu";
	spf=pass (imf12.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780316050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8KJursan6RFIgVpOy+Z9gGHMveIQA3OyIKn2aH7TFTw=;
	b=Xx6NuXbvYvYwBPLnp2gS4LZPqpEBv1n3NPLNTD8OitBo71pSJnS5HCRAECzsBVo4timmWL
	QwHLjEUO37wEJCP+p0grDBQEaMHwCkeYo8ufQEZ4ZIJbwgqydU/u9RVpxt9sVXUfD1dZIY
	Z/xGiJzrOX+WY74OQqNvlu6nwxesVmM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="e/nh7IKu";
	spf=pass (imf12.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780316050; a=rsa-sha256;
	cv=none;
	b=nDvBpw+1dPGSBSzWulw+DMPCLX2LLGSoyTyh5MGGN+9UmyNuS7vnM9+AKvAmncHGkNtlIS
	W9S9Xrz3G8MqsC3cPDhe7gtOUsuCfOe9cKntnOF4pnONqYQxem+vlOnSpu9uMwZUbBgBeY
	+FNGPDSRS/1ub+o8vs0dHAPtDzV1gV8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780316047;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8KJursan6RFIgVpOy+Z9gGHMveIQA3OyIKn2aH7TFTw=;
	b=e/nh7IKuqFzjClybVi8SbdBssN54U4GnwYjqWCxlNjh9mWfVAj2r3yn6S3sretqSN8vLpK
	8sO06Yw/uMgeuqOPJITNYwBo1iF9pnxeJUlYS6CAvscZGUsBFnpI+Sjv2j5Z9zVVIo02HK
	pPEN6FAG9LAuH04gQZe9CIHVCB/qV2M=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-106-329NSstoONiLRpxmEVIWFg-1; Mon, 01 Jun 2026 08:14:05 -0400
X-MC-Unique: 329NSstoONiLRpxmEVIWFg-1
X-Mimecast-MFC-AGG-ID: 329NSstoONiLRpxmEVIWFg_1780316044
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-490afe64f26so346365e9.0
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 05:14:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780316044; x=1780920844;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8KJursan6RFIgVpOy+Z9gGHMveIQA3OyIKn2aH7TFTw=;
        b=q3e4ktLhiaRe9lTVjrU/0ZT7N+fEcSo/IQLWpKwgdgjIXqub8niJ2IeFcR1ku2xWr0
         SUwTeoCkpx0mtXuoYA7zBZJn6InG3m5QEoDt0mu6+y5EF/DSezNR+uKYDNIc0CkM1XHx
         C0GU+RM5Hod6PveCS/Jvy+Nd+Plg3rxQmpxgpp99dWm1v6lqS0CPmo066bOa+Mxgb2w9
         G65GgPqZwxOtzyH9YhbTRlchGNhTjW4mNS/PV4xcecH95SF8Ur65wC31DMqk5QuQwCGh
         DAhyIaCXtRCt/8RBS7crOkJSW49FshOyT6pLHcdE8hPXu0hSymHQPjMJXyqEP3lzFzeQ
         RZLg==
X-Forwarded-Encrypted: i=1; AFNElJ+khHfjwcWkWvqkI/p/LnyiKDKYa820wFNEKNf4C8huODc1fXWZS7jEXpTNmdMQgTy8RxNV0xLY2w==@kvack.org
X-Gm-Message-State: AOJu0Yw6X+G2S7gswOh1JJMw11bnVMCkoTBugkyBB4JrnSJZt8Z3ICEB
	xAET/SeXc1NOLGAYPr0uQHOiAnRmz6++oxWdywAxyo2HzY3HCXxk4LlHX4ESr4gn8SPWMRxxsUx
	PcwoGf22Mg0YrBbFQ2A5Oku6H3TQbEjTe9wGg/3Qob00ufOaJYYR3
X-Gm-Gg: Acq92OGw44DrAh/7KDyp4lw8ph18B4MteJ34HdE/3ed0pTwgF987XC11NoiFCGUoLIv
	Nx5H/R4tCms4jxr+49dMsl9kFNQQrAtdzP2JSxyCUN9E/rnFiZfGNl95hYVTahHHfjSds1RiyRn
	HTBVExiBVZhgG5ENnnlKxO8zPxzkqfoJ+hPr0r8ueiIJgVvRaWsyF8wUJrVsvZkAc524EmhGFmY
	3FiYGUH+jnVGdrRxTsrvCXVZvGwx1//WVmvyDbccuTQY/rbOAymr0f8Ot/ifBSIC2nMDKXQS8id
	0rH7TxPfg5Zb2cMfh4YrtvJW2/s7+U/wWr+aTofbgRb3vRNvVFMzrYXcMqN3QYe6YTlZcbvuVfz
	Xr8IuQCa8+8choweBrevCGpMPd2gwfDOxUxyAwQfFK9rFNgAXoX6Zzg==
X-Received: by 2002:a05:600c:3e8c:b0:490:3d48:6cb9 with SMTP id 5b1f17b1804b1-490a2a02b06mr143723095e9.3.1780316043747;
        Mon, 01 Jun 2026 05:14:03 -0700 (PDT)
X-Received: by 2002:a05:600c:3e8c:b0:490:3d48:6cb9 with SMTP id 5b1f17b1804b1-490a2a02b06mr143722365e9.3.1780316043140;
        Mon, 01 Jun 2026 05:14:03 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4909c053029sm75910015e9.0.2026.06.01.05.13.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 05:14:02 -0700 (PDT)
Date: Mon, 1 Jun 2026 08:13:56 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
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
Subject: Re: [PATCH v9 00/37] mm/virtio: skip redundant zeroing of
 host-zeroed pages
Message-ID: <20260601080712-mutt-send-email-mst@kernel.org>
References: <cover.1779315441.git.mst@redhat.com>
 <cover.1780067977.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780067977.git.mst@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: BZqJOHvw_JJApgD1gXmZ-NbtLt_qCo0MQYizl5uCkjA_1780316044
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam12
X-Stat-Signature: ypqdigsbazyc93ic73ge8aemmouii35t
X-Rspam-User: 
X-Rspamd-Queue-Id: F3ACC40006
X-HE-Tag: 1780316047-960697
X-HE-Meta: U2FsdGVkX1+yFGtJJOqQbt3madeWUKaVqF3S9ZuVpQrwAC1SHaOKqT2QxJev4CyOZcCBkMvEcMlWRfWdAdKGlITTxGvHQ+Wn7ePcamzi0nt4bN/BYV/jT3WvuHFugWtT3EAK4QTDBOF+kj7y1E3yBaNIA8U505V29gFKkOxbaFZttqqvMT3QUDAB/RzKEExSDU3H/EU02Q7X6QlrKvjQwbBYR2fP4yk6tqYR6jWtKMXe3710PnMscUczPxKA8zG3nI41sIebGYFFWy2kvZ+wmH/T2uVyQi4FKBE5gLGOn5/u5nWLsZ96PNlGYXm/zZFZlxq7rvb+8HiWDGuLMenNMoTTeVPmgx8fE9wtZgYHwI9kYbglCwKnuLpCZAiu4lRyABVmFYBnvnqKNxx3ZqiZyzhFQyRJ2D6xcV7Rcr3lAZt3LUA+W8Jpnw8VtOdQswSu7vBK5y92YD22OQQDMFOH5REO1B83iAhtcyXqfRO0nk6U6zZCv0OkwvbcZ4CEtgrkfu34Af1swvC2tDpqCIfjeaIdhPEJTb6xY/zyPdoWXxoHyq+yGCX1dFSuOuMRbapiVMPQxZeVGZ9fdt5TfPeF32/tsHfbwzIs3BEKYeSSV5KYwDbV7WI9FzK2ggc4twq5Hd9vu42Ekck6OI/uF3IFKuKyQYj4VAM1au8+uSVPJ4nv1yvuBTl5eRdAucbc34/wdRVcENm0xd4x5H3Q+8mPww9SLMQsWkggFpsxpQWf43wpnvi+S4mBMbUjR8E9/Ksu3oS1CPFdzecY+UfzFR9JVA2ma8HMxhD/qsA1e+DBp/jDo+XLtYza1b1hwxFgFk6RN14BEsYbPV5yLpAi39Uq9JvZlc4s9QL46O/o2sjkDhzcfzXNy1b37HTcXNxJ78TaWIKhUApYgX1pPhNWyp8pY7jCXYuk+M6mdhLnwk1wmxztqhD8jIUXrELI5FHMOWbrBlqvlY9HElgUNZXry5b
 QNr2Dih3
 Rr4xz3ImoLDPzct58SyjZtnEd3GUOdfsQzm+xjuUBJP8ub1vBXZArWe5U4zuaAvDSTIm7qoN8oTpkhhZr6p1hF+bpl9SoohXh5bnHljvwTU1tAWUl4eC4BQNcnWOrvEX6UXWVDOqfsv445Lf308xBQ1A9efJqK56JYPttF08GJsUJDHbtJXWKEqKEmK913lBxDE0CqcaU2XJ873C9FOtqlrkONoUJtmeffEsQYAuBFj3eNMPrn7DHViYOCRWRewA/ttpRnnP1Ry6jaqdXtl5zj/UaZQYwuUgBnTJgmUCftxqUDUZEThHMWRVyuhUo3fc5Fwmv6RzHKOq57peqH5aom2p1c4NUYxLF19F/UOT1aCa6mn7jPNSQe8Sa7sRTwtxiyErkOCSEO4UZGftyjROWCoLJHDvG67cKxmy0rIGcQ91d4EzZsFiT7q2UHwvvErE3iKXwPtdc7+3GTw3kdXNM6TYOiXnJ/88Sr25qqZ2Wb/CHt4ODFMKH7NHeGijqvUW+q4zJeGaVDhTlqsJs+3NyDP8qgxfYGRXc0SHx2phZc1Z1xKZ39YyfQkZ1ng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


I went over sashiko review of this:
https://sashiko.dev/#/patchset/cover.1780067977.git.mst%40redhat.com

It's mostly Sashiko apparently not seeing the whole picture
(e.g. is says "an optimization is missing" and it is actually
 added in follow up patches).

Sometimes it is unhappy while there's an explanation right in the commit
log. Weird.


It's a pity there's no way to respond to the review, to make it pay more
attention and reconsider.


It did flag a minor rebase artifact (declaration landed in the wrong
patch during rebase). Mostly harmless but if there's a v10, I'll fix that.

But it also flagged 4 pre-existing bugs:

  - page_reporting_register before DRIVER_OK, theoretical race in virtballoon_probe ordering:
  https://sashiko.dev/#/patchset/cover.1780067977.git.mst%40redhat.com?part=4

  - spurious OOM on large-folio swapin race in do_swap_page:
  https://sashiko.dev/#/patchset/cover.1780067977.git.mst%40redhat.com?part=16

  - free_huge_folio called with refcount==1 on mem_cgroup_charge_hugetlb failure:
  https://sashiko.dev/#/patchset/cover.1780067977.git.mst%40redhat.com?part=20

  - double-decrement of resv_huge_pages in memfd_alloc_folio error path:
  https://sashiko.dev/#/patchset/cover.1780067977.git.mst%40redhat.com?part=21

All seem unrelated to the specific feature, so I'd rather put off fixing
these until the feature is merged.

-- 
MST


