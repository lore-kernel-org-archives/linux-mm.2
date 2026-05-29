Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05D2DCD6E50
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 15:25:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BE096B0102; Fri, 29 May 2026 11:25:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 695DD6B0103; Fri, 29 May 2026 11:25:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5ABDC6B0104; Fri, 29 May 2026 11:25:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 410B46B0102
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:25:36 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F402EC0A3E
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:25:35 +0000 (UTC)
X-FDA: 84820831872.26.4711F74
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id AD29E14000F
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:25:33 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BmMhnZBc;
	spf=pass (imf26.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780068333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PJ5vvVKjiUlKZvlIAO4D+aYwhndM/ly8HIEHblxR0ik=;
	b=SSGFafWjcRWTHO4MjxU+aSUuWagXdriwp4AJB62CYPxzhhTHsDwaKqEsKuETNp71Q99j5A
	qVdT7kMPBR3sU0dG4PQ4NhQ2VYilAz70Qc2z4EIJvygiiz5NDRGeubPf35h/HE2+4L/G8Z
	0l2gAVQsYM2D3sMiHh/7BdWQI//jK+Q=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BmMhnZBc;
	spf=pass (imf26.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780068333; a=rsa-sha256;
	cv=none;
	b=xvl+xDqqpNGePa+XffcCeROVRBZtt5Yk/kqMnTS1GSx9FvVQGbVHzB1fC/kqptrsjMvqgG
	Dv44pzWKW89hYYoFcvmiPin+f3P50Vfd6FwExVZspCHgku686vh5ptLbvkPIlF0hkW7fIP
	gwWkU6rIigAJPuvFEKPtDSaC1OA7YsY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780068333;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PJ5vvVKjiUlKZvlIAO4D+aYwhndM/ly8HIEHblxR0ik=;
	b=BmMhnZBcbnZeooEGRJWEDpBFjKaMXv7WG4JWRasxcUPOAk18QDsLlWe6R2tUeIAG9UoCsw
	ZtaCNLgeCjYYOy9Px8hqoxQxR6g2xmzlydPcbeaSb0lddtVB+XeAgW8KxsmbSmJvYGaHln
	I4xMjB/ocJif38B9oTDJ9foErIGrHX4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-255-lIaNFCVVOlmvKwGpNTCJsw-1; Fri, 29 May 2026 11:25:31 -0400
X-MC-Unique: lIaNFCVVOlmvKwGpNTCJsw-1
X-Mimecast-MFC-AGG-ID: lIaNFCVVOlmvKwGpNTCJsw_1780068330
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-48d127eb013so67712805e9.1
        for <linux-mm@kvack.org>; Fri, 29 May 2026 08:25:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780068330; x=1780673130;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PJ5vvVKjiUlKZvlIAO4D+aYwhndM/ly8HIEHblxR0ik=;
        b=oESiBlwNIB/Ua+aPwc6HrsYvRzeqQrghq/hmsWtk4RsWDXwzHqyvj1ueixxaU3AZvw
         OJFDatgBanKJGxereDFUN9u3Am9We5dhckCvaoy0GsSMhGtRZjAZAIuAiii/AnrRs23Y
         UABve7jELnrpkp+q3xw5vXr27rm07mwnT2SpgCiajE0GXLpqsr/2g4S4oZMBWbVK5Pyn
         IBDH51gUsXDOOALQj8oFUGxATPWRO2fOsHmYFT/J3c+qBqftGbll6EYywLp5WsgjDPbt
         fTKH55K1fobhSl1rwS7XH1PzxVuNhEyVWIR/TiG07TGgfTIONoIWlB5h781XwSDtUk/Z
         uqqQ==
X-Forwarded-Encrypted: i=1; AFNElJ/i4bnWJbDWJvUUfu88KAP9eet0KFq4a+wpb6weWWNdqtJOvOyS62ppGfN6jf8nWndGI//tjfkeHA==@kvack.org
X-Gm-Message-State: AOJu0Yz0rljuMNZKT0UVCQ7uK6KCiF6n0DspRStf+XSvHcQRcaGxuJmm
	U3fW7YfuR3TeXZfXW6iTmRtEQ8FqA2qUMT5tjBEZtf+zg/r0GRYaa7URtMYzZOR+po2wzEGBauc
	769BfX2hzHCbtYYPav1AehmD9wP9RD8BACai9miv81UnSiEDBoqK8
X-Gm-Gg: Acq92OFHdqC03WwbFVFGMSXJAbKrOISk/mwPwnVxnR5NbbEwV82TQVZk7meI4yyE3sS
	U0OecMsfaEqY8Y0J+Iw6SazIsycMcGHOYfRpmwFYcUaQQSjkJ4e+AKDr/shaqfEiM6rSggJpqoi
	IvEu5J8sPTtkMklmek2oQqHyc6V/9fYVzHtdfdBe9mh3rtO9U1PNpWp0aoUPT9mc4lbnlL8NJJn
	5LVqyGG04Zrz5R6RctoEfYpzQjXgIz6vYhLxnXIgD1atDvDx1y86vXvY0bxVBRFtJnAVVrHickg
	Rba+bU+IDG4s0ja/ibl+cStHwoeFjeZp+5KvUe0yEl0T1pcBYwSbapLMm1QT1frdPiyIfLJ4moV
	CuhHHBuWlmbOBEoqNJm8Io74dfFqsCml2eUPfdiMQIZV3e/vVqa7mjw==
X-Received: by 2002:a05:600c:4f89:b0:490:4717:970f with SMTP id 5b1f17b1804b1-490a292ec27mr1653675e9.14.1780068330277;
        Fri, 29 May 2026 08:25:30 -0700 (PDT)
X-Received: by 2002:a05:600c:4f89:b0:490:4717:970f with SMTP id 5b1f17b1804b1-490a292ec27mr1652655e9.14.1780068329671;
        Fri, 29 May 2026 08:25:29 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4909d6a0a89sm62305115e9.7.2026.05.29.08.25.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 08:25:29 -0700 (PDT)
Date: Fri, 29 May 2026 11:25:24 -0400
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
Subject: [PATCH v9 36/37] mm: balloon: use put_page_zeroed for zeroed balloon
 pages
Message-ID: <c91973e21bf6f59e34a239324ae0b898525aeb9e.1780067978.git.mst@redhat.com>
References: <cover.1780067977.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780067977.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ZxusLDuwNDUKxi4BNzZVSB5qpQANRHUQ4iV6r3BHt2s_1780068330
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: 5aqpno9w4mbehmx6u8xt6uoku1ucd4oe
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AD29E14000F
X-HE-Tag: 1780068333-151269
X-HE-Meta: U2FsdGVkX1/iZbQ5RTI0Czrk2mUtj0iLmYqN3rouzvEZ6rgtC9AxcuqtJYY6T+JsyL0+dE7UI/otXTAOBsSTZiz4xV3+JBEKG95gQbuQtkN7F1pGx4nGWJGCFnVyHESoKcrPqId+cNYAcUda+8lLFR7rlsVXbK3w4sfey42ENGDaLDhmOKdfcTkCe/EX5kdr7Cp9W1gYGoEtiFfgZNCskTeKOP+acET+JdHej16Gysjh1OvYuVVrlYd69HR2ojeZvPJVKYKMcgBaxm0UsiI1+Q2dH1FCwwDgDCJP+TxMBKAVyptQpYfUS2uSySpF0deX8IB0O8CF6UYXkcUhDuyj5NR6yMJrVDzZ3r/bxXhzQ2oF5UIGzchMX/ilM9nTgZH7CaJyludjGj4+7fD0ippuPL+tJQdloYdTCHdjhb7wZMMCMH1tNYL+OwWIB+lKns0M3cKAUFgNsSG1mR4n116elZYRsL1AMiVMjvqaf9sj7QCsjzNPacJlr3M5D6eJZ9TnG8CThSFIpsDmWV4CVg0oYJpvQdxcAW46gcMpWaNkvR3XKRnqCCCbhWMEVUAm8k95/1ON05usLTiqeQjfMOHHvNyPlanvsMeKK4i37+y6ZUXO4y5L8iXqnmvLUfMdkHAF0jmdNozB3QGhGNhq9gbWq4881dCcJVTXHhXuhufxsYkh+pJT04kIEMtEPX8F9dds183MlbZ8VwTH5HW4aLieCz7igb2w3V7Sd0sm5vAfvK6UKYJkOuj5WhHt7eFbe3ZpXEcxDE7SS6nz3vz/Hktm3D2zIi6Tu/ChWztfI5Z3PJGaTcCg6KbrZpcz+U6mE43vI0YoqFie2OEUWxvFuqGiHixAI+vqhDN/WZ3+0KMJM4JqLa6IqlV+TVmGlWNZzhCOmzQeIfP44MvHe1j2BVgXQ3fDWM94QNa97A+hyXwZLN4dhf1OZaAY1WPFtack0U/4W/0v2yMNLtduXLb7UlX
 tPPI3H4D
 0HAJDj1/mKk+rqK4rGSJxBMUrB5ZkIV5bN8opP+oumwn5scMlgRpvnoyydCpusl4XoXQ08cmKvgDm1OAW4oAPDtiJjL56O/0cTM17Nw1H/5iGr4XtrC1Nawvo7MGCni5Kf2f1RRBLu7tVCQjUfGNBvbnLIsj85kjzgetc5yqC8ZOxkD2sdmevtRZLP9mgojFdcozpDgGxjTf9UC5Sjl6WNR3myV4CRua6qG9uRGaBjcWjZ4T7HU8qK3kxUT14mreTWlqpz5TkhMDKrG1VdSiA5vw8hS3ZOIgmY1qT8ea+EiQI6x79esK2gtiyYLzoIO9VNuNobkSzYC8+dwonEw9k9t3gdeCxBhQHUr3Vlt7E87xrva+c09OpxmE8X6rFoX1OKqff5/fxhbNa1eku9UXctq8QhXJA3qW56dNcxUofNc64FGOWByxLhLXnnTe6fp2ZuX6m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a balloon page marked PageZeroed is freed during migration,
use put_page_zeroed() to propagate the zeroed hint to the buddy
allocator. Previously the hint was silently lost via plain put_page().

No page has PageZeroed set yet; the next patch
(VIRTIO_BALLOON_F_DEVICE_INIT_ON_INFLATE) will set it on
pages the host has zeroed during inflate.
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 mm/balloon.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/mm/balloon.c b/mm/balloon.c
index 96a8f1e20bc6..6c9dd8ab0c5d 100644
--- a/mm/balloon.c
+++ b/mm/balloon.c
@@ -324,7 +324,15 @@ static int balloon_page_migrate(struct page *newpage, struct page *page,
 	balloon_page_finalize(page);
 	spin_unlock_irqrestore(&balloon_pages_lock, flags);
 
-	put_page(page);
+	if (PageZeroed(page)) {
+		/* Atomic to serialize with memory_failure's
+		 * TestSetPageHWPoison; not under zone->lock here.
+		 */
+		ClearPageZeroed(page);
+		put_page_zeroed(page);
+	} else {
+		put_page(page);
+	}
 
 	return 0;
 }
-- 
MST


