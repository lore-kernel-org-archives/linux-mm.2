Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C150CD6E50
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 15:25:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7594E6B00F9; Fri, 29 May 2026 11:25:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70ADB6B00FA; Fri, 29 May 2026 11:25:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6208F6B00FB; Fri, 29 May 2026 11:25:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 50C2B6B00F9
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:25:05 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 16697160EA3
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:25:05 +0000 (UTC)
X-FDA: 84820830570.19.85FBBF0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id B33BF18000F
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:25:02 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BFKURluI;
	spf=pass (imf24.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780068302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yuucL8pRyKGlavgC043yPLfH9MArN/0/T/V0zfd6qpo=;
	b=eIebEn3e3LU/faQBMqQVNLF8b92z+GJYryMgXDlNzfLA22JPYQcmYi7cqID3vO8GDiq5aJ
	JfQ0Fkp2CgCDs5BH32iqq7sbSiQ7rk2w+nYBjLHzhz7r8qzpfZjTMNTH5u4VVwnrmGABBP
	UrO7PWn1zaWc+JU0UC7yfBxWjhCydcY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780068302; a=rsa-sha256;
	cv=none;
	b=B7ingnlmVAYwhqRdSDR0C8a1vuSagMv259bfBAjvE5kV3rrnANzMwNEc1MwhehUQ48l9Gk
	uZvHJZlQH4j1GovI6ivNyb3j6IarElGeB1yUuGwc0LWVJTbbRrelLhoq6Q8O8q0hkfnPcS
	ieeDEETci7/zSb49CZE7D8HCYUSd9nc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BFKURluI;
	spf=pass (imf24.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780068302;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yuucL8pRyKGlavgC043yPLfH9MArN/0/T/V0zfd6qpo=;
	b=BFKURluIe3y2KQWW3uCqt6yCGENYSjLGSk1Js0e9M03MnSzsdbZQwWrls90NV6jW2cFV/p
	nZLDE7w+1gYs6Gp4Mp1O5tKJ4566MegCT9eO1OK0A8c1AWw9QUWpd/8NsJyOv24siyB7QI
	KDrIOG9RwGicf5Tp0UyyUr6c6DDbA6Q=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-687-RVVy1q8VNomvYvd3gt5x2g-1; Fri, 29 May 2026 11:25:00 -0400
X-MC-Unique: RVVy1q8VNomvYvd3gt5x2g-1
X-Mimecast-MFC-AGG-ID: RVVy1q8VNomvYvd3gt5x2g_1780068300
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-45ef2bd566bso469485f8f.0
        for <linux-mm@kvack.org>; Fri, 29 May 2026 08:25:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780068299; x=1780673099;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yuucL8pRyKGlavgC043yPLfH9MArN/0/T/V0zfd6qpo=;
        b=bfpVhPplzmTRaR3MaJXyeEoL4dSyfQn+fbbZfNMmvy3PlG/kHC9YFNGJ7hWEVm8Cmo
         coTJ292HQD5sZgJNUWRs31H89vADMRh02aTiy4FkZH+7F0Sp4zO0Bj7r/WDYUuIy2IXD
         XiNPe6yxL2REYJCi6cPQGPgKdxoV0AKalDcVOZYyMkHM5ulpMXtPZWEUqbXGYbMMnx99
         dIhgD0/QcS6PdWjlJBG7y63dL0mbbHYLsYxKFCqLiLESjNDSaIjvE6CNm5TcLrEbrMzD
         HWhG2tJ3T+Gkg53LzzOEmLNN+uUC2jm9yaQq9oO6HrGrBap7OPwvBZg6usy3ayY3FmjE
         WTHw==
X-Forwarded-Encrypted: i=1; AFNElJ9wF3krkj44xKvvgBSNZOh15QoC7VixNaR6sdtSWC6Za/KPrIp2WdXDKigaSu9McCLoOPAEBElRkg==@kvack.org
X-Gm-Message-State: AOJu0YyGnJU/cfAufFG23X7Us31BNQHx82GBKUN7ilNq/cVWBgKuAsSc
	/hNJlgJIIhpyPBs5i4lG33e89FEaiXUq8YYZgWc1qH27TWm71gkU3Pt4+fIPsPQ562KBFcUPDm0
	w77kjOHLflfmiFJMiQQskFylohEVHariSgXCyy1BNpfZtpsDLia12
X-Gm-Gg: Acq92OEI8+RbzO920zvNH0U/i5bLcafInVU1Z27g7U3inUlzXgaEcVq+nSmdzTC1VOB
	d3QMldYImX2tIhgnU1zvsCXJUk5d76rwYIzt39ZJNtsDJQeCzsCWKsy0dkcpNx7XwrD8NTcv27A
	mpClrokxCbMpcUGnn0xGy9hbKgR26MlQc/jSJX4LHR9UbRA22Sc0YLBMR89XyrtcPFXI/xekxZM
	CDP704eYZpHAZQztdHrbUA7YA8T/79xMwPPVrx0Ai6PfXKZPLWkdudpQPlgKd6RTNlTNthSqxyq
	A58GsErrRmYHQnfkeX1wZULe5EvrpLFVZEutclqeJHvocgv6vSyM2/KJac4eh97lwZp4149GObM
	V4ZzcdHb2az0fOAu4G8NOcjjU4SREPVjR2pmaNwdnslOevtunO1Grvw==
X-Received: by 2002:a05:600c:4f08:b0:48a:581c:ead with SMTP id 5b1f17b1804b1-490a290da24mr2201605e9.10.1780068299458;
        Fri, 29 May 2026 08:24:59 -0700 (PDT)
X-Received: by 2002:a05:600c:4f08:b0:48a:581c:ead with SMTP id 5b1f17b1804b1-490a290da24mr2200735e9.10.1780068298871;
        Fri, 29 May 2026 08:24:58 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4909d68b853sm49196885e9.3.2026.05.29.08.24.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 08:24:58 -0700 (PDT)
Date: Fri, 29 May 2026 11:24:53 -0400
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
Subject: [PATCH v9 30/37] mm: page_alloc: propagate PG_zeroed in
 split_large_buddy
Message-ID: <64f9b0a9c5b1a3db23b4e4d0b11c3609c248708b.1780067978.git.mst@redhat.com>
References: <cover.1780067977.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780067977.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ePaAEwD3WVE-KYXQ28emMW7QxUIjEF9D0iJ5sbXVYVc_1780068300
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam11
X-Stat-Signature: ipzz9f5qqc4ocwkkjq114hto1eroq3s3
X-Rspamd-Queue-Id: B33BF18000F
X-Rspam-User: 
X-HE-Tag: 1780068302-760746
X-HE-Meta: U2FsdGVkX1//UntowUrxBwqx+xsTtPuaIriT1/hpMHswGMvV/TrfNhWIrd4bgVKIm6sS24lX3IppfLY8G2Y+nW4V1UWfDFCpywb/ai+2xKxt15W5CPx2WjZyKLd/qJ5QZyN14g+Qj/WEjkgKmGyUdyrkj1ZxXS0auawohMtV84PvmMBA5Uw9Bw81vBIZqcPEbiTaXwVof55f2BaG/y3Ilgs2vUh2cMLAxxkvcP5rfk2j6KQPJsqTZfvoF0KHH3gL/7OojDjBnufAVLq9ulBKuntqVv0A3N7appDnyt94rjTPQ3P7qYDpVMqw5GVlnhdr+LxtVaFsQG/fYUJ/gt7saDKYOMJktAWndAPYUSUFM42yWvS9ltT3uSGr+T93V2ksqbzosTCBEcpmoJae8e/FX+PIQP2Af6lBPpkTpFVxwtlL4/UooFrTLVcxgpZ7WkzcLaHdhIoO6YfqI66JURc0uGTdCkRes9VHJrtx9kIxta52bccmm/Lw2Z1eMX4JayawfoFaAiJNA5TRG7lC0XTUaPZiz6GZl/8oSSVvv2fIoP5d1HcdGQbbRYtSLMxJ4vjIYvNmbZpXdI1q1V91bGEJnL1QVZ572ldgalBs22LEuEIfvonY+H54GKNF6xSFGR817p6Vs0WZ772HpGG33mS7bS8IRr4czj9A1lC8AcE4w75mK3z7Kyti3Fgp/4LU4xqCpplEgePEZ1fv5pUJaM9P0SjdojhM7IAm+Hl5oLnsBmE8mjgF+ZA3FJZbFOo8MT68DToTN8md697X1KwoDZNSkPCv9ZMH/dtNx/BQ1yMyfCvquKZnd3QxibVBgS+GAq4GXCxl0rLq8N/+U94khb7uwlp4ekSfRzSqHm8me9pWWNIXiO9Uhn9/+8YhWMeRVM59TS2X2sloFaVBCr9d34sOV2nPzmuFs2dW31zEWUHF2QOsyKzSVViDpXsUxqOJvkwY4Z2A/GE5WpUhEp3hF62
 XtFbbNq0
 qo0S8vnoV3Uk17oCaVdxCdyZ9qDQxB8iIafUErFekIRXad+LKHONIUqL6FfmDlXtN2B1Gkjtwfz1Es6WCgMRzyMSdowvEATF0b6/edj1uBao0NARRCX0+ijpicJb547IUKnG+TpMRF43kf/wIHulbTkqW6pqRdqTiZAnwKPS6uXTOFGi48OH50zobiKa53OrAPxjkbLkL1RVHHiHyP/XiQZFCV288Tj5Pzk+VhiIHgoxEIChmdKafDEqDAnkdbPZX8odEHrI2p17JqPeD5Rd870YWPM2mYToMQngUXfrBVK9jzXm/tzlrlMoV3Bp6FOY4zt3ZIYqZuj1wMaxWMGb5FTDpjl2q8X0TDjTzjKOFZov3ATK2LDmY2XtLSQSqiC3tQyl7nt4UQtC24nq3MKW1gIO6pOagEsSIVxaN7CFsNhKteYLB3Ge6LLXTlzYxhbCcMosryKevY0RSVJ6Ymto7h7/8RRSpKNYiPmaWn2XYSQ0tyCN/JmfyB9BIrA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When splitting a large buddy page, propagate the PG_zeroed flag
to each sub-page before freeing it.  __free_pages_prepare clears
all flags (including PG_zeroed), so the flag must be re-set on
each fragment after the split.  This ensures that the buddy merge
logic can see PG_zeroed on pages that were part of a larger
zeroed block.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 mm/page_alloc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 72e52f049cf0..702fa2ced1e1 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1524,6 +1524,7 @@ static void split_large_buddy(struct zone *zone, struct page *page,
 {
 	unsigned long end = pfn + (1 << order);
 	bool reported = PageReported(page);
+	bool zeroed = PageZeroed(page);
 
 	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn, 1 << order));
 	/* Caller removed page from freelist, buddy info cleared! */
@@ -1537,6 +1538,8 @@ static void split_large_buddy(struct zone *zone, struct page *page,
 
 		if (reported)
 			__SetPageReported(page);
+		if (zeroed)
+			__SetPageZeroed(page);
 		__free_one_page(page, pfn, zone, order, mt, fpi);
 		pfn += 1 << order;
 		if (pfn == end)
-- 
MST


