Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 082DFCD343F
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 21:06:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70BAD6B00B4; Tue, 12 May 2026 17:06:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E2FD6B00B6; Tue, 12 May 2026 17:06:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D2806B00B7; Tue, 12 May 2026 17:06:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4E7E46B00B4
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:06:38 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0DDAF1606CD
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:06:38 +0000 (UTC)
X-FDA: 84760001676.25.159E76E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id BAEAA40012
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:06:35 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Pw4qXWOQ;
	spf=pass (imf17.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778619995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=awVRqRC+b/AmjARdxVJbu/50IYPO1xelbVaktsnFd6g=;
	b=z2mcYFQODqGfscshLpkR05CDc9KMz2xacUIMSImBsjVsz7dQsjVwuxmyfjpBZgK4Cd389x
	jcTKSLU84ZT4L9PXiruQWdgaL6BSOUPW7MwUKULW1KvhA15odSSsc6Hzc6657nE2Lpl7Ts
	k3tukyAHaoygfa/49NFtrVP0zMf3CEE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Pw4qXWOQ;
	spf=pass (imf17.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778619995; a=rsa-sha256;
	cv=none;
	b=5hnIsYwm+kxHJDHzWxIdt34zHXrq91o0Gw9HieDpABJJv0AZp9lxMTGDzTt0IHuTtsC9oO
	utiJs7QwFP4FmF71sRq2ZnvxH32vmrZucLHo9fO3/Iy9XjtoafE7CpQM6MmbBNWI5ju0H7
	hFP5baytmthRkwjqOyV+SJYT5Z2sWHM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778619995;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=awVRqRC+b/AmjARdxVJbu/50IYPO1xelbVaktsnFd6g=;
	b=Pw4qXWOQcZcW3kbLl6yjRrf+c2OPoSWA+W+X8712TMtWwDXtTH+2qbyWzv73pYQtmaXn70
	/hAaPUzq1BIg+MFGjGP0YFbq2Xdz341Kj1VzjOzXirDjqSrhKiGbU6PRYH7K+hzGxkGzqS
	vtNgsVyNv0+UC7DVqgvQa0L3tFmWl+w=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-630-7z6yqIZGONGxbwmjfgq5jg-1; Tue, 12 May 2026 17:06:34 -0400
X-MC-Unique: 7z6yqIZGONGxbwmjfgq5jg-1
X-Mimecast-MFC-AGG-ID: 7z6yqIZGONGxbwmjfgq5jg_1778619993
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-43d7730e9e3so3819124f8f.2
        for <linux-mm@kvack.org>; Tue, 12 May 2026 14:06:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778619993; x=1779224793;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=awVRqRC+b/AmjARdxVJbu/50IYPO1xelbVaktsnFd6g=;
        b=IR4s2rVFIG6MatZ1NAhp0X1yq7Mu8ukwD+1YOhk0PkJlhsKzyG6MWNY7q6KnQNTl4H
         Lh6PsSHCjZNQOL/dOwiFkfbClNfFkxMTCdEdXzT2oHxT/DAf3kLWV0DgXkiAYoKzPVXO
         U1dA5DITLSna/AgzA1xGXk2pbrSE1N6s6ZHkFZmrjXe92FNzelBbTojXIwDFRFKM/q97
         utn7LGdGm4sNgBc8nWkQXF6Q0LKqOtXCsOjuQndB7kui6FEzpJTuvtM3pVjid5hllNKc
         BquNOghPXKq8AFJk0fgawBVbdDZnacSY9nbME90u8a63UuGmZH2NYgwH4VOQ9pbNFdBC
         mCKQ==
X-Forwarded-Encrypted: i=1; AFNElJ+7gInS7Gb+VGblS/h834NvIM9YL2rufdZjkX/IDIR/3vnTT5CQtjIq5Ul5BMBTiDXB/KAjCEz5IQ==@kvack.org
X-Gm-Message-State: AOJu0YxxMaxLkGDuHOU8vgD648cZGplx8lSRg8+gID+ufigs5WHQArN7
	fl4k5lnein65BvrIc6ldkcqKAQFrNfj31OKtIUVexnWXf7Z+k7vUQB3FUQ6ytQEpj31nYjpc8Ix
	yt5bT4WZImGGkLTKUatLQsPU6G2hqLFO7VXyjh+FoCUaPrMMMgNLW
X-Gm-Gg: Acq92OGexPjwHN/j/JM5ZepF7aXWhcfOpXbOK4yR90tmHDBSRkxbIgTTYj5E2DrIehM
	cIdsCux8tKguxyQmLhovQdUIsBaX/5eEFl/AgSUBoXuZVlAiQoPgbXkjkQhx2q1D46FCvevkD7/
	5qirdehsXOHvz4lFtaePz2RNy9NnLxfmv95MRcEQUUWu8ZqBgTvGUxojnC0eyPwBM9JgER5VW5L
	h2+VjHhqZO6duUvdvvP/OPXZc1miwMOn50I8A9QXoMjb5bE29VQcMicqgdNw/7vEz3gfDNoKk81
	L37zxsdpSBExWla2dnSTRwcUPfPPu2csOsnyFKJYDdsz64ZOn0iCckn0hfamN5dxdMfdaHAWD4z
	LI9g6fl2ePC9plPWZGDsQgWiXBuJMDcbZB65Y0b06
X-Received: by 2002:a05:600c:871b:b0:48a:75b9:b0bc with SMTP id 5b1f17b1804b1-48fc9a5ed3amr5818315e9.29.1778619992882;
        Tue, 12 May 2026 14:06:32 -0700 (PDT)
X-Received: by 2002:a05:600c:871b:b0:48a:75b9:b0bc with SMTP id 5b1f17b1804b1-48fc9a5ed3amr5817805e9.29.1778619992358;
        Tue, 12 May 2026 14:06:32 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fc8d19854sm24100025e9.1.2026.05.12.14.06.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 14:06:31 -0700 (PDT)
Date: Tue, 12 May 2026 17:06:27 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
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
Subject: [PATCH v7 15/31] mm: vma_alloc_anon_folio_pmd: pass raw fault
 address to vma_alloc_folio
Message-ID: <411a7b6a750c1904b99be92fad0e678ad791ca82.1778616612.git.mst@redhat.com>
References: <cover.1778616612.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778616612.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Y6VifE_HYXPDaLKFS2ao34k36LuLcQDftrWcRRjODdk_1778619993
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BAEAA40012
X-Stat-Signature: d1fhc1aribdtmw4a3ymp7o4decxrtbod
X-HE-Tag: 1778619995-233865
X-HE-Meta: U2FsdGVkX1+84gl2ntXV/23ol5l31ILz+fUupsftx19+D1bWlTbkyClWfBkYUmG6NrY2b/q0wiqhvw25jor80VZZZtDk060G8MKKBvJbGRYyr/q/cBzPAm0YF1/ArB2e5Nyf969/ITg9BJLlUtwxJvRyyRdHg8wVwYTpv82oKEQjakaJhALiaF3S2ZAb6b1hYacDx3aZvg7FvPSvB4Ha1TfkI5/+N1HQMYPee7h/ygkM8vC1IBNzHevmGEvDMML3Pw6D42BoWZD8B/4ps1mpJh33w5dDbs0J8QV7VheHDeGlXCqIEuQQARuOKKj/3KJlBTp0ScXmy74cwudlFZzFVWdlyz+TH3MWCsgw29bCmX+0XCx/yMfneJbQwwFD02X9suNT4Te/8HObPM1hsLGcX7J5LSdlJI3TTtfFsBPbiC0k2yK3MdtuicS3pMJtDtS+mJbqFw/q70W0w5mz04PILld4TT5Dv2v/hUknVnYD/+r24NqCWFs3JMghdC73qQ0nMqrDny7tWUFoi0TuQB7gsYEIcnurQ6F1eUQJlC4Wj6kI/TaVQp5ZR2NVV098y6Kvxlw4ub/hnojWFLYA89n1+tUBm8I+3YRmluOXBqcf0FW1JDQ6ojnnVnPTsbo7PZQnNpPVFFZFzBN4yYL2hd2X5W2aGHUs+F/yL1USau1I/HR2ZiVw0HavDNVPMWBgEeTFHFSBk7vZ0hJpWHTOzSZD0BJ1xarmRB2pFNik9gfRKj2pF1h2Ek6gOB8SyolglF010LfcL40afuGAuGJYByNSdBknH/LcpU1wCLMTLqByly4a0gjUvy3sguyNT0ap/pPveSdXbqb+bTI9lJ/aBqNpoAee1dM7DgE4fR3AJ4Wkl7s9M43yoPTIm6lTLS6l0hc9fWlFYkaTElH0G0DSVWmy+pPejoIi3Jo60rTYf1f7YrHSBTJ/oxaRDjAcx9UEgzd+RhDOpPmcmHZU9qHaMSH
 q4JSeK78
 GqBaW5CVVH8t+QURfqCCUEQKNhZL7TLQLLQbLpQIPGB2aW+Yi9xYW7obLQ0evF6PjIJlmHcUzCgnK5CHO5M0mfmqjJmN0eYiKySFIEnsIoo4/F1TewtUIqdaAcXk+NH4mZ/O0o78xcCla4eXeZsLE8dF1kGU7tFS6jtTxG4Hpl2sYkOzsd22G+TD/vIZnc7jjUAM+oNr5A+QCOmOVWas9qaLFU2O0KO6nPXpswwWj8JaLobDabv896cOX8j6kLRVIFNVIBEeCQIuM+o2x+cxPtm45ZtRzuTXQbDQ8EoIWktA6GkCB68O/oiHfWXhmGmi7eM7ggYHBGlvTfL1zP4F2UAvk50pFZa34ne1EP/zQrSuFpEWotnzO23S/sGeSm8H/htO751sHV/Z0HK+l1c9Pba53ZnuOMDgwPTlRqntc9pxtvN/QXqRpjCBAw3uxAnVzJhQy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that vma_alloc_folio aligns the address internally, drop the
redundant HPAGE_PMD_MASK alignment at the callsite.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 mm/huge_memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 970e077019b7..d689e6491ddb 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1337,7 +1337,7 @@ static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
 	const int order = HPAGE_PMD_ORDER;
 	struct folio *folio;
 
-	folio = vma_alloc_folio(gfp, order, vma, addr & HPAGE_PMD_MASK);
+	folio = vma_alloc_folio(gfp, order, vma, addr);
 
 	if (unlikely(!folio)) {
 		count_vm_event(THP_FAULT_FALLBACK);
-- 
MST


