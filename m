Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 246FAF589DE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 14:46:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F8F56B008A; Thu, 23 Apr 2026 10:46:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D0846B008C; Thu, 23 Apr 2026 10:46:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E6BA6B0092; Thu, 23 Apr 2026 10:46:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6DE7E6B008A
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 10:46:47 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3742A1401D5
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 14:46:47 +0000 (UTC)
X-FDA: 84690097254.21.68FD27D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id CC99EC0008
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 14:46:44 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JJrHBp1v;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776955605; a=rsa-sha256;
	cv=none;
	b=eJHpnD/wE+PWi8XdK5CtOtHSF7CsfXT7hZwOCyIrs6PQZA9HQKP85fY0nKeUvZH191zXwf
	Tmh60TzQM9hHlxUkPksG9k+iD86pEoADv1jnHMyNqBgoTS9v7z26ZHohYFvYZwKqgV18Kh
	K7lsor/cx4EG+dmJ+m2iDjJCPwEODN0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JJrHBp1v;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776955605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l8MfwEpFW90pOYwmA/usmJLfbbJthitR1+FeR/wvevQ=;
	b=swle9HDZxAmK8pDpPfhFxy4nYT5CJQHnhZ+CjMxHnUoKnZHt/oeShZnT28+GYr2RPDEIYj
	Jv7GKpTCbeO7gyik6j9LQ/leZBqZ1vqBeexq8Yc/lkFAb0BXMvK/gks5lM1WY7WDgIAi6O
	Q6BxW42FTnmWmE4qrErbhhBp5x/i7Bk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776955604;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=l8MfwEpFW90pOYwmA/usmJLfbbJthitR1+FeR/wvevQ=;
	b=JJrHBp1vvZqx8y4oj+Mm37/zXNiW/9eqa6I53poZSxqFnfFw52Sgx/kNhWwEtAquP39VUt
	PFTQXNCJP8TaadVpbVayHf+67K5gXEk0BIr0+J4ckS7ypaM6ZRBy9rEkA1SYLB75q1jx2s
	XLkkivgkUhl2xBtaIR2g1XQeBdCElrA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-8-w2o93PmqOgaL2pzRJsGzHg-1; Thu, 23 Apr 2026 10:46:42 -0400
X-MC-Unique: w2o93PmqOgaL2pzRJsGzHg-1
X-Mimecast-MFC-AGG-ID: w2o93PmqOgaL2pzRJsGzHg_1776955601
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-488cc31ea57so52769335e9.3
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 07:46:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776955601; x=1777560401;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l8MfwEpFW90pOYwmA/usmJLfbbJthitR1+FeR/wvevQ=;
        b=G5yNBIDtaNJTmmFxmyOhSs0hcrl4KL1VhOg11MfPomwVQZskiO2iJLq3rixbUw1Mhv
         zQgWbIfv/I2qEdY9loXFtheoo2qaQ//y5Buv69pjUQc5/zw7fBI6gtkgjBjJ6e+2Q1hO
         LKQp8shFpkwWmpJgJ6rIJcKb83VD7X0mltNSLPMyD3sSM4vZGNySokm8D5Jv++on5YzN
         ZYZPtBR4D6X1VmE8+Ov71V55rrM4otEJYa1PTkPhnOG4dTRxqy7k09oflxVEfOFcKrke
         D3DX4PCg1f1t/n6wT4QEtEQkPhjTfaBp6JT/FNeFMsE16aOs5N18RDu9lAvJA+2l0pl8
         /E2g==
X-Forwarded-Encrypted: i=1; AFNElJ8cugfOl19PPzAjmQxrLv93/AgrPuQdmmJKCXTslf41JXk8gLCFh3FxsHOPFNMWV88BYOWP/cUgLQ==@kvack.org
X-Gm-Message-State: AOJu0Yzl5JgEuCbxJIkuPk+xLMP/lZoTZS6Er3rivQvZjDIqE56VcV4W
	DUuiXpyr6U01o/hGxXfjQzaUjNUB2qf1PkTm8mf2hrIDhEZGv8aR/v/QYYX9fRZ8ek5s5uCpJkh
	8opVGCHkbudyfiUA+pIu3yokzD+Sn+RmGR20ncQgAP1uV11Ebx6RZ
X-Gm-Gg: AeBDievy31cW9j1DRhzyhCeMGxN7ieJLjLxr/+c3DcTwYSIMsW++c2zVwjU1jM+pabM
	pe+JVO0jehHer0QxtxReDN06zbdg3qAUpyzc0H5AKwZxhpYd1wU1S4nbKGowaDniKStd5ZALJzT
	EAv4seP3ObLQc7PUGNOwE+1yegWM90ZKZBwlg+SSklJIDko7cyhSoK9js3ikiS9Q1EKHcXiRGIp
	YD3fXdnYgxxDjsQ+Os13h/CpOsnbuDDuomBDTLoMIYuFM8q/R2XJ/C2f32A+bP0F1fnB9sRlqGm
	VBFmSuH8S9zrobCDrr5Mz5X6ISlg3pkcdeAwnf82XWaQFBvxubTmiZq7oBczHHyuBCBqdBI2gVj
	PEj/Hz8fBXh85Mc3HJLBHTd7MwfoT4tklAXNEub4BywdQxQaXry05Kw==
X-Received: by 2002:a05:600c:3553:b0:48a:52f2:a0f1 with SMTP id 5b1f17b1804b1-48a52f2a5f0mr200255485e9.18.1776955601344;
        Thu, 23 Apr 2026 07:46:41 -0700 (PDT)
X-Received: by 2002:a05:600c:3553:b0:48a:52f2:a0f1 with SMTP id 5b1f17b1804b1-48a52f2a5f0mr200255085e9.18.1776955600835;
        Thu, 23 Apr 2026 07:46:40 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fc100162sm540787515e9.5.2026.04.23.07.46.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 07:46:40 -0700 (PDT)
Date: Thu, 23 Apr 2026 10:46:34 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Hugh Dickins <hughd@google.com>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH RFC v3 01/19] mm: thread user_addr through page allocator
 for cache-friendly zeroing
Message-ID: <20260423104120-mutt-send-email-mst@kernel.org>
References: <cover.1776808209.git.mst@redhat.com>
 <9dd9deabd42801f3c344326991d1431c3d8db39d.1776808210.git.mst@redhat.com>
 <aekluxNPxF8CN8fL@gourry-fedora-PF4VCD3F>
 <20260422171315-mutt-send-email-mst@kernel.org>
 <aemglPlcwFFHNj1A@gourry-fedora-PF4VCD3F>
 <c165d6af-4a35-4a41-9086-ee307640c044@kernel.org>
 <20260423074433-mutt-send-email-mst@kernel.org>
 <aeohzbmhQAoOODPm@gourry-fedora-PF4VCD3F>
 <88b0765f-7cfc-4e44-83d2-c01a1755c842@kernel.org>
MIME-Version: 1.0
In-Reply-To: <88b0765f-7cfc-4e44-83d2-c01a1755c842@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ZbO0qaNcxP-10ghhSMjI_fX-xhN9xK2QlOPbrOCASWA_1776955601
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam10
X-Stat-Signature: yoynrrkosaiyrfedu89jzxu8xxbykbcf
X-Rspam-User: 
X-Rspamd-Queue-Id: CC99EC0008
X-HE-Tag: 1776955604-568119
X-HE-Meta: U2FsdGVkX1++7h/7gyb6RcVnpMM7tCegvIVZt9XYjxEMDxeYt0o5qx0nugVnmhsYpuxR2IhcMKZoU0/M1PK9K/jlDioEFlmZprPDMYsQGlbW/M5cRXRtVUv8VQniC13GWenjsPDmmJx1HzDYtVQd7qPr4lk7P5O7Tu5WS9cpm1G9WYo8ujEguJ+yLPq1tqE11WcSUBn1mBRxxdfz3YBEDjr3um4NnogvlwQDiccXf9j31qpo42Bwir0o86/IPLwVZGYctMQHJSxgAAWxYC3l50tuBtJXBKWQfRsMh4Zlk+wVELQgbg4Wu//35WL6xgsBpE510UwGgDELK5Qc83ugPPPQuamb2HgX0ZR3eqfwBeqLz+vLUCDVFYlsD3wPPC82OTlI2tqxy+VoT6XGrSsk/t7Vz7GdPCz7IeDkfYcc7nW1WQx9CKTwVTNSreYCZn/xWWJP4k0PYuQciaptEa17lhD8jhxRlh3MucWC3rRjXenHrjp/BK2Q3CBm73N0rv9rwmXP5TKTl2MoMnKZ/WSX+GbJWBy/jhXjGlB8eC7vz02HzwNLEQ6fkPFLt+OPWlE2z4Rohs7U2U+ygRwXCQAzKGTAVZcO51lfmNmozZercS3Rqw7sK2ncyFSyzo1Y1YsA0PeQEFHqvqg0hh/YI987hgyXszE5psHCrFi8NB2H3+8pVmjHrssKZTKPUY6w6nQCet+HjwL/OKnTksFkwZDairCD7e5/1T0HjEGMDzemXUXocw4mcp80CKy8nTiF2b253m2A3uPDsKqCChUI0l6sG55rJX2DVojWE8vxQ1C/AA4fxr1Y/yAmiZH1VuVf0tLofQOoZVLL1yS2LSyXjd2mk9fb1lMo1SWJHgzJyR7eK8HaFQ8MTPB/xQOjQKpUj6NE/D7anc2/lcEZgY352wcQpS0QzkuoxWAq+gr+HpjjQbfS7OKF9pKgXe1EEOGbXnteqedeqPmbAGlI0sxUzd8
 qLAIxEXv
 FjbvR2je/9CedwoC/Ahz0/khOkl0H0BHDM9hVprM2P2vMSTEbA5zB/kdWs9ldirIHBKBWquP5lxbdWspVX56UJhpiMcOqwh9fAzBkw5UvMUCcpvsn3tOi/ABJPAnCd3hr3EcSCBZRL4ScOaeuT4VzpQX3vVRUZZfErn1yX7dmzpeL0chwj5vo/2Cg8ifejBo3w2P7e4UYx4Q75m2NiW9XE8wjZlHaHYS7OAHHEMqOwLITXo4EgLs8TNkGYoaYFQ3LzzIrOl11LnPhpln1tLH6f5en5hXdm2NI3Kgzn9nVFFh1ckqEOUF5Cf1NaJeqd+OimxZ0+Wd+F5ik5JWQLutjolV+U66wOzzYRnYosi9ricHXnjnyTSYaEfwX2U6uwCr2lbQ7VNq5IQN9XeIY0ydO44uOyQ1eknIZ5J66KZRqxtbm8kNguG5UIKvVu1d1unzfVXOrMwwANM7Hi1s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23, 2026 at 04:13:50PM +0200, David Hildenbrand (Arm) wrote:
> But really, that hugetlb code is rather messy. I'd vote for leaving hugetlb
> alone on a v1, and focusing on non-hugetlb first.

I just dislike it when things are non orthogonal.
People are used to: hugetlb = same perf as THP but more predictable at the cost
of being harder to use and using more resources.
Here, suddenly, we have an optimization but only for THP.

But sure, we can merge a part of it first.

-- 
MST


