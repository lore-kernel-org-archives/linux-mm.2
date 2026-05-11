Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC23DCD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 09:02:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 272446B00E4; Mon, 11 May 2026 05:02:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24A076B00E5; Mon, 11 May 2026 05:02:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15F9F6B00E6; Mon, 11 May 2026 05:02:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 05B576B00E4
	for <linux-mm@kvack.org>; Mon, 11 May 2026 05:02:55 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C0B371A0671
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:02:54 +0000 (UTC)
X-FDA: 84754549068.05.2BD5D24
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 79E0D80003
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:02:52 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KVRMoAGX;
	spf=pass (imf30.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778490172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XL/pBrxkXlfOOto9pZb2YfWp+jJTrqFtHfQ0Ihv6FSM=;
	b=DtNk2qlI5zCVyL7d3jksAmWHW7sdmFatr59oY3W0FbVQFReGpmnTXNipfUZWJwibMwQ1m3
	S//oa3ZqtuwkDzWRtgT44nnCFBIBnfFnU6p09IOxFKEimwZcHB/IZDC1CFz9JsqXcsmYIm
	4VOcS33fbZJ1nGZfidUEAW3rqcST4tw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KVRMoAGX;
	spf=pass (imf30.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778490172; a=rsa-sha256;
	cv=none;
	b=hQ1NxEXcoiy9VqIezjWzgMi6nCN27jlIaNq4PgCwrpZLq/xX4l8Ki5TJ/2lD9uaKu/uRzY
	GXBhZQm6Ellgg65Il/WNeo/CrfvqJu5TBdtdlhMkSR6JJr3VnXE2lNInE6SXnGQFNlksUI
	OWRWneTM7HDHUuLqCHJylQ8O/6wSfKw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778490171;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XL/pBrxkXlfOOto9pZb2YfWp+jJTrqFtHfQ0Ihv6FSM=;
	b=KVRMoAGXoAa3SnUS5jne7tZsok/VdnF6Hdgp7SpRdEzTnFI2RiLokMydYzFcdd34zPv3Wm
	be/TfFbqiv/b1AWDpzdubgRXssNsuaNxLIkzAzpAGBMS0K6TklJPLAt0f03viTbMS+qkst
	a5SYzpKZkTNUQCOh6D7KvsS242Cthaw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-252-fwsggAfxOved9nIsRyugrA-1; Mon, 11 May 2026 05:02:50 -0400
X-MC-Unique: fwsggAfxOved9nIsRyugrA-1
X-Mimecast-MFC-AGG-ID: fwsggAfxOved9nIsRyugrA_1778490166
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-48e5df7e6ecso24056855e9.1
        for <linux-mm@kvack.org>; Mon, 11 May 2026 02:02:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778490166; x=1779094966;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XL/pBrxkXlfOOto9pZb2YfWp+jJTrqFtHfQ0Ihv6FSM=;
        b=jLJJsNEi/vU3G/ohd4psg4mtY5Tv4BhooZj5uBoEIXMFubjDoyjlE/hkYijy9aiami
         OmXqhAxMZR4ZD8kPYGYYbASyq1TDfPPdap1aEmoP3GlP859Jimu5qX/cV5viWfsli97/
         JqTxLKwZ0W2eExdzRIDTUb1JrdtwHYDBo7Y24WyuQeoKjID51P3R+XhnPRY0GhHwdhRM
         Qa6CvjXhedF9PckW4dJc5jxkUW49kM04wjy2S5QSO+eys7qjGfHcOkxOSuiLs1xu5JXh
         Y6EhLzmxyOOPDF2dLZn83Kpsh88FFQahTEmKnxgH8ciMLI2ZyrZagLSSyiSa/Ehw1zQI
         +2tw==
X-Forwarded-Encrypted: i=1; AFNElJ9oZhwB1oqiprBZfw1wHlvuUgR+rzn7Zn9QafkWMOJHr0HYbpzBju2bXnTLqh5NxI49dziXwKxbHw==@kvack.org
X-Gm-Message-State: AOJu0YwnREkloVR3Qvt/PREbNgP2P+QNMxtztqmngn36bexgk62LXcSg
	KhIhAPxV+g8dYUh02ai0kvxp9t9v5KDJdI1VEzTc7i7bOD2kS1zQkWsMXZEX4P4uMmTt0iVuLVu
	gpUkJmOZOf/PbiaUGa8umkzT+XKW/vkZF570xB94PPHiiSeCDzmfu
X-Gm-Gg: Acq92OFmgZ9F2aacrXB5JR0L1n4NxKjFr2WXOHylpN3q/66RGrz6FspCQJAQRu5f/0V
	Cn3jlGkjJMUxr83v4mHpFoCZ+IA7EUP4RXwLjJIvKSMU6iSTKecQO7CGWB81Yg/6RRizdzUuqpV
	I7kvnHIoW+8flqPublXDzH1OgqwtgUYAXLi5BcQDfAnx3nXnqzf8QRM/FyNyl7IC2CtwRIJi/4W
	JZpfjRnm6KHEW9p5MAABYjgAC3cXT1FC33d1uiLW6MaucHrYq/P/2SueVZRy2j8snM3jTBUE/oW
	/cFpo0kuilZTiRAk/omu2vmPhluK5aPBxHBZuPBLskU6ZvaCm8Qo78T4mUemfhtnrNw9mhoKfBD
	rLz9MW4S/sIs40WKyGoAO7ngJU3PRGvBuPIk9rXv8fq/lXIeY9m8=
X-Received: by 2002:a05:600c:190e:b0:48e:82af:d9 with SMTP id 5b1f17b1804b1-48e82af0239mr50308865e9.29.1778490165882;
        Mon, 11 May 2026 02:02:45 -0700 (PDT)
X-Received: by 2002:a05:600c:190e:b0:48e:82af:d9 with SMTP id 5b1f17b1804b1-48e82af0239mr50307675e9.29.1778490165221;
        Mon, 11 May 2026 02:02:45 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-458b3664e3esm8472285f8f.3.2026.05.11.02.02.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 02:02:44 -0700 (PDT)
Date: Mon, 11 May 2026 05:02:39 -0400
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
Subject: [PATCH resend v6 10/30] mm: alloc_swap_folio: pass raw fault address
 to vma_alloc_folio
Message-ID: <369a08b86f51572b2715a9ec577de27ea98000d3.1778489843.git.mst@redhat.com>
References: <cover.1778489843.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778489843.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Lki3MD04iVdn4yIf2tpGLYWcW_byXcjtWxwve741GTk_1778490166
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 79E0D80003
X-Stat-Signature: ytkqr3k6t1as6tmdae55cmw7366tyu97
X-HE-Tag: 1778490172-641116
X-HE-Meta: U2FsdGVkX1+GhVkAi/zai8Rh8CNt11+8SczjH5fCGND2d9zQwCfCzLIRt0DrFMRINq25xid1bAnObuIF0ulSBXK3s05d0sUo8BwwWm6c3pPmeDBhYpX7VmGtKYqZMeytJjSZ9QMh+RWEdCUCjzbapyDMbVK7yW+i0ZlBhTl9v28zRXbXyoDRInariY5PZfGQKssv/ru5n5h0qXX+00QHGZFWI5nZAPgDt6gTB/hTItIgfNnSlHLBdz+EqkskDVkOKHcfmwuEuBcLogVXvGYHO3Q/ZmOCBi0WZGk8lL78L3K+CqTFoTx5KgHS4OOJYTsWv5m/v6CIUTLRANKR2J+Y9em6gR/PnvRDOlgltZ3ObsfhNHJ84FezTBXetLVPjEOMaFwtQAyppCnrOUViSxaGegGx4voDVxM454Flojv7+FMTSnYwg6U6p2UBS7WxfZXuCu4TpYem6J86X7DuuqQDxuLyv8e3BFIxObJGPA3L3482qjwFdBYAMaUm4zvQpcQPJhGRbbbH4zZJsnsHA0DKq0BubSPuwcGntWuOTkR8CuBLU+mUOJKc04e9ivWEwCSn5TU3PxbIsBp7YccaGXFIr6S2XUyPDhSEHtwCdjSGr8NEc4n4SNb4LJ8sxB4tnC3EIpmZCKkA7VnXd7GZ8DFDBKD+VkvAup4qNZFWepgzgRlHv5WyoG/E3SothVj/YpoKexBirkLoNlJNyL3TvRT+fVpeZUDhdhRvR77Ote/aaLQpNc6O4F7/s2VyNmIW2YeaADHEpIeECX6xnmcYCl6xw57/ZryMqlbg5ZAkfrOBYe1L2Qlbzcx9OXH9XoqqvWERLLpcfCHGkkx17tREo8BALQuFwNdaNKMQC1m3bRmH6naV7ByWZB9PL2o97xHJypQEx4WQyqyT3sHyDttc8hQbsDUjTtANWfPGNOj0lFYF+4YUwiQrCKmLicoIOqAbCkprLqfw5XbNusJmqQNgAbT
 P3YDdH+k
 AtEtK9cSGxW/u/Vij/X7rqIttmeXJyzX2fZVMFZd9xvTh5MwUY4Mhxi+m/ZScfBKU1x19yB3puUfzMJ667e982ncFlquuuuug8DWZcxL6zAKFsJ58AqoGcDSjjXgJkYI7T7PwZKAildlrKSsb+NO4+/oE87J+emLIn7RuyMCYKgmXEbKSB9cNtgG0MueTwK9nsBfCDCC4j++DhmLM+U2KdvaptU0zWcXNQhtr6paVrryXTXE1gGXL0w7dnvzkr6dLp8V+Qxb3Pw4pPlkVFWGid4d7r+GIeJWNIM8GxydrE6bnkofrC+7GMb3PZCPa9HgdfUAnVdtNjzpSlEXMNGci3of5k67KYAkO5SSYAaEFHPgpdTa0eqsX+QHT00hckut5aTl87MMdqBkllyFE4LRlMaDCPPPxCpdaurXWVY2EDvsKFDbRLEp23mFSOC/VlTlyFCBDN55ZTdnXTPfh8/cNPyxY/2+PdxACpajL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Same change as the previous patch but for alloc_swap_folio:
pass vmf->address directly instead of ALIGN_DOWN(vmf->address, ...).

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 mm/memory.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 0824441a6ba1..74523bc00d8a 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4734,8 +4734,7 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
 	/* Try allocating the highest of the remaining orders. */
 	gfp = vma_thp_gfp_mask(vma);
 	while (orders) {
-		addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
-		folio = vma_alloc_folio(gfp, order, vma, addr);
+		folio = vma_alloc_folio(gfp, order, vma, vmf->address);
 		if (folio) {
 			if (!mem_cgroup_swapin_charge_folio(folio, vma->vm_mm,
 							    gfp, entry))
-- 
MST


