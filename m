Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10286CD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 15:26:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F9336B00C0; Mon, 11 May 2026 11:26:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D13B6B00C2; Mon, 11 May 2026 11:26:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 598856B00CF; Mon, 11 May 2026 11:26:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 443F16B00C0
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:26:49 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D9F831A016D
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:26:48 +0000 (UTC)
X-FDA: 84755516496.15.0777256
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9A691100004
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:26:46 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=V8PS8xJh;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778513206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VtgHwsv3Qeq6g1IIGujUjXaZnU57hLsTfcwqNk6aZ/k=;
	b=o8IhehxaeVvLaOC5ydHjdjhl2qIWja2PGZYZzTvmhyb1YBwW2NgV5CunHR3js9EWh7n6aK
	L7kahfrwo48svzVgGRsWl3YDOJyO/lXukigj0QB8gqN3Q17MmSKeK7GGnKEiY1s5VUjkwp
	9Lnzaq4fasT2+FX+4z464rPzpYjIMZ4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778513206; a=rsa-sha256;
	cv=none;
	b=iH22Sbd6qeGlKcbHKvwoCDgsw85i+udwSsiMTDdZt2QkKQxQl7h9UO2hbm4hr5MrZE9cW8
	twhb7VeaXNsF3tAhpCoy3D7BELa1xUbKkuq2Hqn8F5mjt0QZkISRulVAnsBABDw3hXGCZR
	jwUBCvHjxRAn0TVtvwwA7jji0auvmXQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=V8PS8xJh;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778513206;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VtgHwsv3Qeq6g1IIGujUjXaZnU57hLsTfcwqNk6aZ/k=;
	b=V8PS8xJhhcgBl5zM6zBJSsB3x3xGrfiNi12h9mZPQabcX/UgDfMlMOQMYD0TynEM5TYz6Y
	rplyVqPDZKUYKdR1iF8tNkKx1+nAtCuZwT4Bb0JE0XbKETXCVYgkCVv579GsaUQXLYATWY
	ZFMXqodUdVh4pIpZOCkkkqNAmyN61EI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-470-2SeqgtSTN7mTsHpacsS8KQ-1; Mon, 11 May 2026 11:26:44 -0400
X-MC-Unique: 2SeqgtSTN7mTsHpacsS8KQ-1
X-Mimecast-MFC-AGG-ID: 2SeqgtSTN7mTsHpacsS8KQ_1778513203
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-43d103e46c3so2736928f8f.3
        for <linux-mm@kvack.org>; Mon, 11 May 2026 08:26:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778513203; x=1779118003;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VtgHwsv3Qeq6g1IIGujUjXaZnU57hLsTfcwqNk6aZ/k=;
        b=k8iENO0Jir1fRQ9wB/HjHxURrKr7rDB9hXsH7wMlLpQREpXF0Y1IGC4Y5zh+DdLZo0
         HsZX7f1j4FeHxjeaP89TyB4f14eiQj4c3ud7e17NfcrOXzw12CSdGSiL/iesoJ1/h9yB
         m6SZwdIJLpmkmvkAG0jNMWkwswU00VIkMlpS38OZ+CXOb5a1/ZuEdm66iPJvnO37c8A/
         ftbDwZMH/Llvc8SyddUG8/vxVFeedMdWNf5ovE7O3NLXPM1FvmQvT+s3m3VoHSjw9MSL
         kkZ2REhKZjXkWSws3UH9BhqDofZyNcBqTMci6I2c4OVBfHCJ6joBVYfR1HjJDaVx4kuj
         ZySQ==
X-Forwarded-Encrypted: i=1; AFNElJ8hXhf0LcWbHd26aoIw3u5/xNx8FMhncclQiqhPmErr29oHfww/XRU4h+/A6NOxshLmzGe3aPZbyw==@kvack.org
X-Gm-Message-State: AOJu0YyGzmmQFBKpbGA9kXEQ4cdR8OOBGQblnBILsHHl59PffQdrIU8p
	XYdPnq3mpXGqFn5oDMLixyMb1XJvvqzY04KrUWoeRTMIUDfppsMBJOm/npmkIiPEjDKCAZ/5j1T
	lSLYndNJcgE4HBuQIHsu8m2ZTZse4DdButpHGF+E3kb3T+F9CloFU
X-Gm-Gg: Acq92OF8fq8kyjuGTnODvMsEqX1SjfcUkqkvQim5C+dyPIlmq4Bik23pB5qNqqcG/2I
	tFVtScrg+4Xe8ZAMOXBQkeTJdhG4i+bVqnRz2PdO7HcyOUuC3nd1Kp/Nsj2oioaJiqiBmSJCaJ5
	prZZd2SYXg62vUrb0Odz2rj3/FGbH4rP68sPQPpVxUT4fWDlmDLIfg+aWRiN+AMijqCe/JLY2df
	NNJ3vaCUSXUmiGZ6OCHRK/Zc+iG/vL22ZVVvVyl2MOu5Q8AaPE79ZDQxWoUHXpIx8IqHMelWE/s
	mn527jOnJAUAAo42oci1pQmrlxzd3wV9QcTA3D4PCDGB5hUE3REcN28eYrBiIZtq5TMRk0gnylO
	d/ue3wkQYYSx40mJJkhV37KrGSdYGstO4GUhAPOJk
X-Received: by 2002:a05:6000:3103:b0:44f:da83:2030 with SMTP id ffacd0b85a97d-45463d88e5dmr21406815f8f.41.1778513203082;
        Mon, 11 May 2026 08:26:43 -0700 (PDT)
X-Received: by 2002:a05:6000:3103:b0:44f:da83:2030 with SMTP id ffacd0b85a97d-45463d88e5dmr21406697f8f.41.1778513202344;
        Mon, 11 May 2026 08:26:42 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4548e6a66bfsm23102423f8f.4.2026.05.11.08.26.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 08:26:41 -0700 (PDT)
Date: Mon, 11 May 2026 11:26:36 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Price <gourry@gourry.net>
Cc: linux-kernel@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
Subject: Re: [PATCH resend v6 02/30] mm: mempolicy: fix interleave index for
 unaligned VMA start
Message-ID: <20260511111905-mutt-send-email-mst@kernel.org>
References: <cover.1778489843.git.mst@redhat.com>
 <41bd50fdaae943e1a79215ea4000322e74a823be.1778489843.git.mst@redhat.com>
 <agHu4iaL-3By0YuC@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
In-Reply-To: <agHu4iaL-3By0YuC@gourry-fedora-PF4VCD3F>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: gYhmHcb8Rb2Z7YvOZ5_AXrc-oUSmFqbRJua-Ly_ImVU_1778513203
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9A691100004
X-Stat-Signature: im5595ihfjyhkq1faj4uca1sb818gffb
X-Rspam-User: 
X-HE-Tag: 1778513206-304415
X-HE-Meta: U2FsdGVkX19GBEgcncRNMP0FCjA4TW22S5yoSSYvKjQOiVkIvEuZKlBVOGO1f5gUv6/ngxkev+j+1l8aXyPtSrUGlmLN+sR4OX3LZjNxv/B/1j8oJqmHJC0ZmEl99P94kOjYgyUYFS+ukq5jywq4931ifTc+Z9fcWatm+hDg81i1dShjbg1WQE90OkjFU3YzNji+QEsvkKU+8UbuazQzmO1rH19d4F9WbaCrlMbRIDTE5mh1lSlgQALriFQLdNc4EK4t8nEd83j4/XMV0lZgwGTGYYWNbiM+fslReHV4D7VONAY1cTs2JueH5eyXSg3RgxUyaYGEaVgjot5aSzkAMwVdvf1EwhrLGZKjxlESbOmRVMme2TBrRzhhh7BpVkvEox8eo/lkgNiRprP5Mn+i148EuzcWjm6YymrY68Ds6JGhGTwvrbqxn6Kpw1152ttRSol+8QHmluaiOGWqLHWPmikS6YCrp8a2wom4wzzK6uGMNa1tY29c1JVMWxXLbXLecWjXaHpDPf7Ly011npmRvg9k7DSNWtuVZDgYcrDXPIvxoYNFihV0h+a084f9z/JqfifHWozOahqiqi3PYmJlnyXRMELZX1RQyoDvZsDynwYBlcbckkrQbhSs90h4XhAVzkJNE1a846grKhecppBa1EfxL45heY+hR4VU8boTm/MfTUxMCVtAo2IVPnFFmDDqoN5BaFukGYvRl4reI8gZ/3EjwPtgPQ1EArUoM8+pDAhh+6WaFDbBel1PMXHnUcsMDpI+kA5cj6OkQXOElqLiobcDVUK0gO4NKZGAEl4jPItYE/GvW5dCHVcZfANNVIouVDQZue0Z1A5c9i0GQGHQp/A3ZLCRoqAsUWSpo0g7bhgBp/lYC73n6ITvUqEQZoQ8C5OxXLXS53ffmR4fXwA2eghN5jp/I+hRm3qqDLsrChy++GfbxIY14aPEAVQ8w3FnNn8JTshwTkwu45VoWtt
 t94d7hct
 qa/tuN8e/n1sCFmjpb5YFfj2xTmA6vXb9Qwc6ljKevAsF0A09ebDAY2eAFPX86jXQZsTlneNcrPRvLcfgsAl7HRrWgxKo6tpJZv3CeOzk/L2cvwgwpaJCYWxOqRh6r/7QXIf36cFOcrEtrClVziHBDm841qw2Co8KsEDLmgTrjqIl76vH2UTHm91nl8qJpXKgP6cs5Vz1rX9BicAIG/dhZX4W6ccSTSqMmjfGOS5saBudIqd+2gNrcz8hOyojdZEbXFNi5kAuKYfTSK5SEBrKOn8OzmFUv6pCnbSpST3HOQsKSyoEDw2PmAG/+5o7hI0dLFRX0JLPWrGVqFOkU3p5lC7WZF2FDE0+cF3ZnAVll3WLHRxD5xF4gkZ1zU4UeWEHxZ4xaEgiX3k9RwI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 10:59:46AM -0400, Gregory Price wrote:
> > ---
> >  mm/mempolicy.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> > index 6832cc68120f..39e556e3d263 100644
> > --- a/mm/mempolicy.c
> > +++ b/mm/mempolicy.c
> > @@ -2049,7 +2049,8 @@ struct mempolicy *get_vma_policy(struct vm_area_struct *vma,
> >  	if (pol->mode == MPOL_INTERLEAVE ||
> >  	    pol->mode == MPOL_WEIGHTED_INTERLEAVE) {
> >  		*ilx += vma->vm_pgoff >> order;
> > -		*ilx += (addr - vma->vm_start) >> (PAGE_SHIFT + order);
> > +		*ilx += (addr >> (PAGE_SHIFT + order)) -
> > +			(vma->vm_start >> (PAGE_SHIFT + order));
> 
> There's enough (PAGE_SHIFT + ...) spread around the kernel, i wonder if
> it's worth a define or a function (not in scope, just pondering).
> 
> ~Gregory

66 of these. many are not about order. Popular ones:
PAGE_SHIFT + 3 is bits per page (for bitmaps)
PAGE_SHIFT + 1  is thread stack

definitely not in scope


