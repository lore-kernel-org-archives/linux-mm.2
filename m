Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0286DCD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 08:54:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AB3E6B00B2; Mon, 11 May 2026 04:54:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 682BD6B00B4; Mon, 11 May 2026 04:54:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5720D6B00B5; Mon, 11 May 2026 04:54:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 475D06B00B2
	for <linux-mm@kvack.org>; Mon, 11 May 2026 04:54:24 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 13ED61C1458
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:54:24 +0000 (UTC)
X-FDA: 84754527648.10.6BDEE6D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id D8552140002
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:54:21 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gtdUdYKY;
	spf=pass (imf26.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778489661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=awVRqRC+b/AmjARdxVJbu/50IYPO1xelbVaktsnFd6g=;
	b=Q0wJllFJ1yfDGjqk2fBlJ+mWzI8SDOKjjURutjwVhcH8yzJPZ/LuHntizgt22VzqDjIOx1
	HIt3tV14bFCPxEmO4KE7XEORtZq/WjSuQhJFNa6EwjifZzzWJYJvj1aGpJBMcEO0lVnRBl
	hafMLMCOmOLUGUNZyJ8TT15LwOgYq+o=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gtdUdYKY;
	spf=pass (imf26.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778489661; a=rsa-sha256;
	cv=none;
	b=bVCAPT34+N6DEKiGFcKcSnOHSzKZK0amYuxlxvCEJYmkQPCF8DjDrFs9Zfe64nX6V1BcKU
	BrNJ/ASLvGl8iTpS+ALb9Akh49W9izK/H6SGanXFCgtqhKnyEg5vtDgkNJRoXfTSak1T+a
	HIn+nGkj2PVT3GNaNINgmh4U3iYFdAA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778489661;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=awVRqRC+b/AmjARdxVJbu/50IYPO1xelbVaktsnFd6g=;
	b=gtdUdYKYnmNlUl2V8J1DiA+lKEExLVDkrNXcV8NZLs0oV81z3l3weOMGNvs/EDg5hwADU0
	99ol54AJj3Qk4pdUwBC/Ui0JTwFC+kvr/eOnFBnE1ODR4JJIg96d+Kl+ynAJoHZegl2hUP
	nO3r7fAojo9FLDmZohXHTyV2DtbeJoc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-595-NoK3_bwwP1a5CdLJSWOgSw-1; Mon, 11 May 2026 04:54:20 -0400
X-MC-Unique: NoK3_bwwP1a5CdLJSWOgSw-1
X-Mimecast-MFC-AGG-ID: NoK3_bwwP1a5CdLJSWOgSw_1778489659
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-48e7572b739so8380985e9.3
        for <linux-mm@kvack.org>; Mon, 11 May 2026 01:54:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778489659; x=1779094459;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=awVRqRC+b/AmjARdxVJbu/50IYPO1xelbVaktsnFd6g=;
        b=dySTutYpp3mqcY08uBUePOmdngrVVjT5qhkyJP98sx3Tz/mn8DTDKjPCi14+R8/CFS
         9DmlPFc0A45XEw0dGrgxgR20maVVO3YRAZ7sJGHMYv+JTZfD5Gp8gPVg+O5U7El5xqM5
         14Wh3ySAR2Mbcu+6qWju5Uvy//+f09X5Tmha5G18mx+3YDFChB3bdvShb8olBC5NxVv2
         CF5FCU1E9OzsJ9QMN50mItZUpaPaSSxa5P5Mzv+zEHHAbufOxemm3Kx/LkN6ORmdhL72
         JagTpgzQZBtNJNKlBWHA0qmcFWZMZ9yU6kuabDH9C4+8DREENfNd3gv6wLthAvHY6Hb0
         avgA==
X-Forwarded-Encrypted: i=1; AFNElJ9R0MEQtolt5+G5RimpmSC6MvT1/u6zPtHWQ/BL6u1A8L9i7key03DG077/+ZadAUqyh/vecPPesw==@kvack.org
X-Gm-Message-State: AOJu0Ywsn/etyg8/xDln58V715jD4zw7dmKHPeXGtmZNZFACx1knEfuA
	K1gXUEt4DmGJavMUcIEXB7uLoNeXtE8rUpKEuDW3u0QBLuNixkVxsEeQ8aWdOXeM2MS366gHXoP
	HAUBZ9AkHZE04Fq0QRwpGxRCykwrgeb+BoNfHlu77IKU9jNdX1ozg
X-Gm-Gg: Acq92OFdfkdKLVnSv0IT+aRBocQ1dYiokP+pWBQiXT4MLdfs/6wIykn51WDM++7YapV
	W3wCQAYnkM/Bws/pWAnivGJpBNmK92282JJBhroKHSvvub9DhFo61svEl+5FeeOBlSddNVkIlqW
	aidBjLBOlRINg2EPeVdu4a+FbvHxzM0egUkIUO8LXCMdxA/o4QkA6q2ZuQyz2td3atEKv7+uuUm
	mxkfNdo0YRRxcpE5bpiFhMyTw9l3atgNk9wdONPD8j0P3pWmASCGJcyDFaDLCh0Qel+mFcEN574
	XPyCp1mn15c8uQa2b2yi2DomlfSETEh4aEpWx/1n2IsabmOsnpYrgM7WqIhwLtX7oLzjCh8QkLn
	g63N3P2aIcNDvNcbQxZcKQRyFHjio/zadM3FMi5gB
X-Received: by 2002:a05:600c:3e0c:b0:489:fec9:a17e with SMTP id 5b1f17b1804b1-48e6768514dmr232537465e9.12.1778489658611;
        Mon, 11 May 2026 01:54:18 -0700 (PDT)
X-Received: by 2002:a05:600c:3e0c:b0:489:fec9:a17e with SMTP id 5b1f17b1804b1-48e6768514dmr232536465e9.12.1778489657983;
        Mon, 11 May 2026 01:54:17 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e6fff9c91sm181688305e9.1.2026.05.11.01.54.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 01:54:17 -0700 (PDT)
Date: Mon, 11 May 2026 04:54:12 -0400
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
	"Liam R. Howlett" <liam@infradead.org>
Subject: [PATCH v6 12/30] mm: vma_alloc_anon_folio_pmd: pass raw fault
 address to vma_alloc_folio
Message-ID: <20ce2bd8227c0149fb205d293b47348c3ef49974.1778488966.git.mst@redhat.com>
References: <cover.1778488966.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778488966.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: yMAxXar3laNTa2eLLQ4WGvhwU-6kHOx1Ju7es7p3Z0A_1778489659
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D8552140002
X-Stat-Signature: fa6qik4sth88bwqpuqxifpgfeho3kuh5
X-HE-Tag: 1778489661-870581
X-HE-Meta: U2FsdGVkX19RSH6DWO8bIgpnQvBElKmPd4NBWdCRNnYKqBEOM6FMYPggcF876Sz13gKBuUEWDxXn08wLOw0RsHNJA+xUHeO0gX3+bJDD0SHdjwEQz7B95LgN8rTUeHbpq7ZJXKlkXNcBVWp/X1w5XANdzQdp8wey0ciOEEy4DeMyxLP38RdzhDsq+GvW7v9sstBhAbHx5WyA65FGdjHzBVYIPUcSqDF/h3YyY9uRki59hCfBjqQDj7QYDawC3Uual375LILC/smY7akrziTEAi0bB0/mxhcHDIm3KD+QR+0vNz9V0TIQBa/PIJLl0ij8xlk39Kh6Gk9v1/LNOShwEWT6HJj/G656Niw5EnU8hbEwPBwn/6c5PieO949wJPHfOcr8Cno1PV2Jn+kCRDlCVwZe8aKn+Tsaaf93XCN/48cR1FKpaoRg+8tJbFjmyHb1iS3QETajyzsHlR5lUqRCctpSYzrnQevYJ85eRfDtf1fdMtjC98v888HefEIhJ0TdqAupwUE5RL3aTEpFlbd/hVWvzIMvIGp6aDqxthCZ7RQUsy3W57y8b3cxZnzixAAbe+36fxY131u/h91Lv02s7CUu2HHwx4dQ78C5jU+/k7g3T/PX5WBbWdSwaq+N30YNofZN0GSBzo1+HPNPobtpmeQgh0lnnAo1Hd2tsQlt0G3S4aNTwQH59bXus33jaXr3qvMK5z9+cowbhjpA/sDmV8MEcYU6vOi+rwF4yVzgzfiVA7werpHsAUr8CjKQBIHiJg6wiSfBovyf1lLPyC/7TEc1FH+GvnMzSgX4tLsrpX2hCHq+iQOLik/fdfCh8o2KkxQ9jZ4vjnwqT6hmpZnkYf3I80EtPmlHj1iCYti4KAp/1JaluGsOUCYk95MHM7Fjl65uPivuc1Zi1qBG5NlXVHbcCocDpJjVJFV5MHN9ptOpWXZVCprEm7OxdYxV8cUYOUgwhCRM9P/ZhuR6b2n
 CI7t9IaE
 upogU+fWYizq1ybZbaYm7lWV/piYAq4ooOUj81tyz7kTDrr2AvmcZx2/C3JPJZtBExC8/omWdYbk8hl4kPyRzlBrb1WEadUXFJKtUFdITgk6IHY5xxOU7K6fDudGPHadgWZhYkdukUFttHRAFPwIp1NdNgxq99U6N1iCuYTas4hj8ibks9iKFA1vn/EiEb00s3hIMTiscfYmqcxC0+YqPTCb6MFlkpoY0A4RWPI+jzTfTvGfWctjL7QWDqkS+h0W7voF8W/haoaFa3C2mRkX3nDLFx7oeu6WeN6GnO3eEtrwqEUyiuSMw9TtJBc/7zL0Mvu3FbSXdQF/6f0TVsfYnbeXjAI0l1nU3Dk1HGzgDxQIUr755G0y1SrBecvwSzaWGuda5ojv27kBGok/RbsajRg8wQQ4pCEKr4ExxOlqsUOJi6l9+tef+c37RIW2ACBKHuIQp
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


