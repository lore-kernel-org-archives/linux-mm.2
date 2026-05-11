Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EED23CD4855
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 21:41:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 621556B00B2; Mon, 11 May 2026 17:41:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F8ED6B00B4; Mon, 11 May 2026 17:41:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E7B16B00B5; Mon, 11 May 2026 17:41:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3C6A36B00B2
	for <linux-mm@kvack.org>; Mon, 11 May 2026 17:41:29 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D81161C0170
	for <linux-mm@kvack.org>; Mon, 11 May 2026 21:41:28 +0000 (UTC)
X-FDA: 84756460656.29.8C45715
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id A4EA440003
	for <linux-mm@kvack.org>; Mon, 11 May 2026 21:41:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZTDhPgOB;
	spf=pass (imf11.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778535686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eFdSw06KftojPC2tU8RauboriCWgGTE1Ndjj9VMw300=;
	b=JI1/MuPigzh3lwjkFA0eMB7xKltC9Hyn2qOVAvhjbw6CpuIiUx9sPNp+DVq/ubAg2jH2r1
	9HYsI8A7XIeDzzf0Eu2mTmGrjJhr5Fxzt0adFjL5fmrcWOGy9Ov2WepqA3/Utli5i9xrly
	w2cf30FRKfcGrrzG9Se9x5uA+MzYutQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZTDhPgOB;
	spf=pass (imf11.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778535686; a=rsa-sha256;
	cv=none;
	b=EDYUXQ9dJxfKE9U/swMqr1XJsETpXMdvXkArUCX6A1L4iwC040Bm1Vmfd2uXeC0ZtN1cg0
	YbjlHo2HBysqm3HjfXbr0y4oYgYnkxlUeVn4iiTXuTYfKLI8lvEb/3cN//gWx/HNOENrWl
	+phyVI4JGRIjBtzTQ9jG7qEJiSIXhP4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778535686;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eFdSw06KftojPC2tU8RauboriCWgGTE1Ndjj9VMw300=;
	b=ZTDhPgOB92jsLuHtcG4iwPYxT8qNYhLcqrIERcUAc10YHPzOiJYeK5wkeBZBGgyRbyZogB
	oOrvCVWc57GZpQHzzf5RyLyDh7u2bBXfzTbRjLEWtFbTuDpqXlGPJci7nr6DCrPjflIPvL
	8FCPLRkaMDb1atmgQhE2KK/1NdbK0N4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-343-4fscpGabN3SpMK75PkafQQ-1; Mon, 11 May 2026 17:41:24 -0400
X-MC-Unique: 4fscpGabN3SpMK75PkafQQ-1
X-Mimecast-MFC-AGG-ID: 4fscpGabN3SpMK75PkafQQ_1778535683
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-48e5df296aeso29720335e9.1
        for <linux-mm@kvack.org>; Mon, 11 May 2026 14:41:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778535683; x=1779140483;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eFdSw06KftojPC2tU8RauboriCWgGTE1Ndjj9VMw300=;
        b=Fp0f/EHJFxEHLV7M1NmhAVjJ0IZ90JPJqpq5+VHaaxsggYPo1MzDH1ncz2ymi+CONc
         RLM148FdpA6g2Iljw8yLTQGcbbUg6+CmcsmYIXsnrFMxTTUYr8zj5Xv8bs+3ux9EnF+E
         uOrP7oow7R8NrriyBDGTCQnTgqRTSUSd0io4JfbjkgcPsOZqqXictVYZlECVVhpXdxc/
         d9Jaq+94H4b/4chf+rILqKcPCkhY2D///npvPz7/DYK6GsaeD/+RjHPU1Q4+VKtV9LpO
         2K36Cisdr96Ga7lp65y+MVPGHt2dSoJx/UAuGfWobUyUPZPqJkL4fvglPlV9ktX7pgFH
         Wq/g==
X-Forwarded-Encrypted: i=1; AFNElJ8P2deEbJi/3XPo+RDRDRcvlwC5qmlnAZqjL0fLCYc/GtZhg7URWvwApxdLgBlb/g8XHztiiIWTAA==@kvack.org
X-Gm-Message-State: AOJu0YxMHK9pPXHvlDnPSDnF6YMRqg4XE5VgCqeN/FYM1Dy+59HKBCYz
	aOUxR2sGr+QK4s12fc3PJQD/hkweWrcnVDMpeTX6yOiZoJv3uWmh2SgdGMcuBkXvGSQ3FM7TCmc
	0LgqU++tCL7TeZziLOJd4cDBMOCd8HRL32WkkduV3by2TcHHB1n6u
X-Gm-Gg: Acq92OGFm5Ye4GZoo75BqJ6Nt7uO2zLJmF+Ocvy9gNQWfcHa1o5w14e6tDEb4zMlZ4A
	a5Hr4FN0shollRw+O0ctjhVpHJYZGt6EQ2YTCV0Af/0G1mdvftwVcTH10rE4sceHVKAAZnwR/F7
	rW353Ba8TD6oPjZHm+x+DGqHzfy8zsnRNcxApM7u2dn/L/3EDU62c8sGTopNHxJJM8gO9S3PCke
	HOAmf1b04cCQ8EQ2ULxuwY6E1aePDpW0cBWG8MQ2VOmc9TDlku+r7z9xE9eMUigyH/ZN0G4GTA4
	KTqqUHK9H69eVwBbrD/ueoe+ZOftSuL/q/Byk0y84Yk16OQSmllPNO7Cx4IqCZtLLmVEPAa6L3s
	MqmvMARI82r7c2dFA2EaEf7yEY6K+A5iMQwJyLFj7
X-Received: by 2002:a05:600c:8706:b0:48a:79d8:a8d6 with SMTP id 5b1f17b1804b1-48e8e207a4emr15649375e9.7.1778535683208;
        Mon, 11 May 2026 14:41:23 -0700 (PDT)
X-Received: by 2002:a05:600c:8706:b0:48a:79d8:a8d6 with SMTP id 5b1f17b1804b1-48e8e207a4emr15648575e9.7.1778535682514;
        Mon, 11 May 2026 14:41:22 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e9053420csm135965e9.4.2026.05.11.14.41.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 14:41:21 -0700 (PDT)
Date: Mon, 11 May 2026 17:41:16 -0400
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
	Andrea Arcangeli <aarcange@redhat.com>,
	"Liam R. Howlett" <liam@infradead.org>
Subject: Re: [PATCH resend v6 10/30] mm: alloc_swap_folio: pass raw fault
 address to vma_alloc_folio
Message-ID: <20260511174032-mutt-send-email-mst@kernel.org>
References: <cover.1778489843.git.mst@redhat.com>
 <369a08b86f51572b2715a9ec577de27ea98000d3.1778489843.git.mst@redhat.com>
 <agH-PrpY269pyuJQ@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
In-Reply-To: <agH-PrpY269pyuJQ@gourry-fedora-PF4VCD3F>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6DMvhV13xKSTiwJtpDVt3rTRqeWlj1eAR7P-pU6rl6E_1778535683
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A4EA440003
X-Stat-Signature: fyzm6qhogwr78j5siijxbwk4dxgbcmed
X-HE-Tag: 1778535686-412530
X-HE-Meta: U2FsdGVkX1+hPcqp4LQyVVUrFOTpWczHOxVM0ZUdmWSn9yGjKTLXWhwuNfQFuWkJiebUaNLRF4HiVG+Co0YKu1n4iJD0veesW1PV9wL6SN0CTz+YGNkvaoZNpHZ6GvEQCS3mg4Y81fXPuimGj22OeF2lNeC9qTumVpc5D7C1r1TdQGNxBtQcdMcm3BR1DPCEoJuqvz+Ao6kt3GmR46ksJ9yvDn8C7tGCtT/n0NKQpQedL+2xlnkTLTxn7BO+O+oYIwZfKikyIiQCPkHScvoqZiSHKAQqLS9sjbfjMrYpDWFlmRF0duTSVuJ7brju4QpvviBHpqkDBHjcIJ6VFePaTh1EQls41+jpD2axPabCppjiJje43b+9wOP6+ACCWOMh9Bewp2CsLn16IhjaSVeO9VhoD+4Wy+ynx+/imz+oK9tmf8eV9wMSebgYvRwrlo7tiuKcpQp7f5/E/xDfGkAI72Lw++IzsJvu0lcjCV/3qCgDvxqMhyyfC8l6oicr1wp2OyYL1BN+88amVs5I/+za1qbq8kmlUlrI6U9qvD7kr4GRwWk82N2JVwjKwqxfankMHSnVpNPTHshJc+BoTy8II58Ox358jgvj+V5VcnqUMaR/tr0hFe2f0+tW4xExu11WcG0TCPHcCu8qopUjfN0qEhSy2gzszHE+/4WtvxZ+4jgBp25jEjWsVLNxNCMrz5exmqX62q9FclH3cpBHXEQyOhJud1JoeF5V2DSrUm+KqWp7nQwf/x6l5wz7A1777IKd55AuVBbpkJdOFy38Un5Kb8BAfGaP/HIYuCyP8DhvEMyP1sYNdrP6U1kulq5PQMcR+UyAPKr5JDaOgPFr2eMZTIvYkN5YOMSZmOWnMxTeYziXaUlPLEdvUaKqoV9yvjJcWwH/+MaVpxYstutiv00Ly3X6zk3cOnBTnsTffZCkBYnucNTKRc6Vev8PGjT6Bw2XEt06ez8iGCdU0WcLcvC
 pBEq1un8
 Ge8XJJ/pALKh3fJy3VFtoLcl3XSFDDxu4TL6p9Ej6bszoqQSkeswHsF8d5Hr9GRKlWayllp8TrBhsgVIvXqSEnrjTta2PVEGNRroSysyP2bfFK72p4+PKSY5ERlHW768epui48hidhiOvsMGprVJ3DCCNiIwedVlnN0oUJwPZPsOyBx1V7RuUGtmXXIj00vrvE56aq5XCcVxPHuCSbHJSf5GaoFjk+ZQPfJXAHyMbSb+lkkU9YC9ImerJBKdRcU6hvi8N1CoiKS42DWgELQCfiPfw+t5lys+LXDV+ZmsSse0NO/jzCsjlypKSQ1I6BjzAIAXjGBUdNGgtCO/L2ge+ILdWOU/n8nZ9mWYZ8UQrCnhu78eGdeGBOs453TUimAL4IvPitb2DwI+14eGFa6D1yoBxXNi0R+4PnQgX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 12:05:18PM -0400, Gregory Price wrote:
> On Mon, May 11, 2026 at 05:02:39AM -0400, Michael S. Tsirkin wrote:
> > Same change as the previous patch but for alloc_swap_folio:
> > pass vmf->address directly instead of ALIGN_DOWN(vmf->address, ...).
> > 
> 
> Starting to seem like this should all just get squashed into once patch.
> 
> ~Gregory

I mean I was told the patches are too big and too hard to review.
It's just same, independent changes made in several places.
Does it matter if they are squashed or not?


