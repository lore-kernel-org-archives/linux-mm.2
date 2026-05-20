Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AB94CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 22:23:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C49296B00D9; Wed, 20 May 2026 18:23:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1DEB6B00DA; Wed, 20 May 2026 18:23:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B33B86B00DB; Wed, 20 May 2026 18:23:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A10A26B00D9
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:23:49 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5C0A8C1B2C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:23:49 +0000 (UTC)
X-FDA: 84789226578.24.0FD8A4E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 20705180003
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:23:46 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DkmY1d18;
	spf=pass (imf16.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779315827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K72Es9G8n7K8ecgoDN9zfD/eO+Zd/boK65D6pcX9pF4=;
	b=eKMzHtDvKAHIaP4LGrqSE+4zB4jeRmLv3KHLulO7oIkDtsHF4upy/kDwyEglIXV7jsP59d
	m8/gaRJNee7Eh7sKXb9ZnER4mgCXTGgkJKzKP9UAntYab1c5A6kPDFp6D5XgrwNdBsDfGh
	J9Wxs7PJ9nKkLK+W6uDHhzndOOcS77w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779315827; a=rsa-sha256;
	cv=none;
	b=wFWlXj1wTxvhQf7vKa9k+MFefhTvf2zVdEnr8XWorOTiMpF1YZ1V96MVmfGHugH9f0MeN4
	/0u+MfAZkiGtHNfE2A0yRp2W48JRn+04vyDUo/Anvl8RuTgxCRTS2JYn4lZzgcM8V0RNwl
	36HTQxirReUsA+FQZmCHn33BgtEWImQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DkmY1d18;
	spf=pass (imf16.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779315826;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K72Es9G8n7K8ecgoDN9zfD/eO+Zd/boK65D6pcX9pF4=;
	b=DkmY1d18mGktbE6OtmtMa3JI6U5xYmmgO3Vxv+5M7D3aAkb4sJT/XgaLTVikIdeRTX4tE/
	VHu8kbdYVm9D7Pi0lN0nd+h3vzXshIbqJywA55+CS0h80rsZpRmHGVWgI86OgKrs7+CbYF
	oioGWAB/SPHL5BUyjgdpR/0iksm4VIo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-397-VnUDjDZaPaSSqjZLOPIkiw-1; Wed, 20 May 2026 18:23:44 -0400
X-MC-Unique: VnUDjDZaPaSSqjZLOPIkiw-1
X-Mimecast-MFC-AGG-ID: VnUDjDZaPaSSqjZLOPIkiw_1779315823
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-48feb8b9acfso31988625e9.3
        for <linux-mm@kvack.org>; Wed, 20 May 2026 15:23:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779315823; x=1779920623;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K72Es9G8n7K8ecgoDN9zfD/eO+Zd/boK65D6pcX9pF4=;
        b=PDeaOPtsLCGNxDi3d5uB8BOdWEWvIeejyuo8YHgqtOF4q+1GVe8EFDvARVXZlFuai9
         Cg9cxojbn0sR8EFBpsA2zmIV4RJXGYYZ8g4KB1UT1xgrsCUfnSDFYBLBhh+KlU6D4NZa
         DixCBQCWuKJztW7GwZI614h3CveOqjfVU2BZgGN82j6AxeN0fTcR81KX/cAzfI2SLgum
         /rcvudgiB8MQXOphzqJ83pw88jDoExvAjHljUD7GBLOtABT2IRfF3oGcwSAX6wrQtB9B
         2NqLUPIKbrIJbFTiMi3ROxXZkWdhlDgVfUuYXvRb6YePewe6ZKFn0WgFRpnFmYStsjc5
         WlOA==
X-Forwarded-Encrypted: i=1; AFNElJ/yC0qT+F0l1xnb42ySuEDQ4dEWzT9uI67emSF95MxvtvuPp9k84Jz+U+EI7cPKRPdVNeaddPLn4Q==@kvack.org
X-Gm-Message-State: AOJu0YxS1w31mZ1L/yyyKGZV3U21snFVefo/OfOC3t5+BIlIsnHOYnmJ
	ecsCH/KRDTw+zB0/daAB8qYmo2s6QRp9Hh96Xmg1VAaXJ/hog/p3d12pxfucq+0skNEt9R6I9G2
	ff02zjDx3VQxbrJWgFlMur2yp/K4D1/+vLQiD7HAOkAToxRefTRf+
X-Gm-Gg: Acq92OGkowrGJVS4SH59io9TRdTJtEegtDhcHR9vVOXBB7uCnHZcKJfVqloKaNee2up
	aV697WNslWT0bB5094O6L3tkhoC2uPESgRY6HVh73+jL9EOI5gTDEE8zQdHTZG2oAwrJU2OxNoF
	lZlJDkmaI6v931yRTDVweBWJpGGCOvVWDV0TSvPwvS/wCzExgTHP9oHN65ChnyAdSnB+EX1IYfV
	Jud8rWF9AjZrOZ4jcjpVTD26gRzVypj6MykQmlzKq6W7wVHEo4Cp0etY1tgRDS7lpcYEZGAOybD
	q6C+o737PwP7X5rZxS2mOX2AbV2HX8wkaIviT8w73CVGH9kdMLWyOznohxMgZq98GaTBcQKYxTw
	t12e3ew38a1bogukQMWdtWrnme3LMQAn9Vbts95tOve8=
X-Received: by 2002:a05:600c:858d:b0:48f:f7cc:f703 with SMTP id 5b1f17b1804b1-490360e4c2amr1777745e9.30.1779315823389;
        Wed, 20 May 2026 15:23:43 -0700 (PDT)
X-Received: by 2002:a05:600c:858d:b0:48f:f7cc:f703 with SMTP id 5b1f17b1804b1-490360e4c2amr1777275e9.30.1779315822889;
        Wed, 20 May 2026 15:23:42 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49033d58838sm19711575e9.11.2026.05.20.15.23.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 15:23:42 -0700 (PDT)
Date: Wed, 20 May 2026 18:23:38 -0400
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
Subject: [PATCH v8 37/37] mm: balloon: use put_page_zeroed for zeroed balloon
 pages
Message-ID: <61af3e2e956952715b26b51be4afa4ca573ab631.1779315441.git.mst@redhat.com>
References: <cover.1779315441.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1779315441.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ViFsFb3lcp8fypz01xuVYXp5zru0OTaTcM_CNmcmNmo_1779315823
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 20705180003
X-Rspam-User: 
X-Stat-Signature: z3upfsf53ffcif41iri19o71tsmq8pqu
X-HE-Tag: 1779315826-777786
X-HE-Meta: U2FsdGVkX1+HFITRmgB5Ii5nJtzFw/yGqv0mo0JqaYsMTyk/6QmO7VlcWmfxJ5NPfarr1qoND/8aeN1KyjC93MzcB1G4tqGgA4FFBQ17eNPUuB9u5ggUT0vKvHTwu5YbyIVMuaFD0TBLJo2xpiSzZnWSTNBfLjOhS9zYIhN/Vs0f87UpYyRgNIZUj2U2eKUzIlCN9svDM6+12YbCEl751W+eBCFOCLsvlRWXVJXHQ6/HCJS8QSGdUKIGPPLlq01HwrcW2+MUsgfc5z5tAS1RsYlu/dnmnY6sAoa794niP2NtsAP4uBFD33Grw7KSJ40C9Ue0cZ4Hs8dlZTDHHQ5tv51b7c3PxZCgOplDWkRSK2CeP3/2vA5oJipoYfkKnCWzDK7pHDiDLgAGHTZLikUZq+ctF80N7fb7f8atcNlv/EWZ5SyteYnzZq61J0li2QSFs/rwKxpiWfa3EHeHOKI2i06d2Y+1I8SL4+RGZD2e1Aw8MXQf0J5UdnJSGtw1Ud9NTvGYz+CJnZuxvDuERX7mlL0PsLvrax+gpIBDKXnG/LqkEoMLPjsZT++9hNQ5GnYEGvvtAzuqFhShfMa5sYX6iOAh3xAhLWixgPJ98YpxLfhP4EcxcPMf3Jbk1tlyQL+eA8HwmfJWzWGo7uiqAOOMkkvWuhvadhjDcScwqXP5iw/cm91KgYc71SU98F0Qn0NOMCVOfvuMFL8FyQmMvpm8V2xhwEuaFpR8bqIsc/vApenFYRdEMK3q+CX7wL8aa5IJ/aIRNX3bUQqJf4Iz3Xp3LJLAqrqXw6JnBk3KKjh+FBJZuFuAnJPyQE+O+g05qJWpI0pYp6j+LMBQcDuGmN1mI2Ljj7xonU+PG5lO7UQwzkiy8IZbRrhzMQd2+z7TxM2mGyibng2o/8wTxIiQiolEan3KBlPe3q/nhkA064qlGgWBZYHg0X/FP+e0SnSiZY2NfZG8NxVau0xJ3W4l02+
 PYc79MAX
 Mpw2SVXR6SyP6ond+A9KzgB9SmNVrzVpr1RTJ8SgAf7LS7B5XLPzgvBsD9ZtFXHByprmphzMDNFXHQRDLT5qvvrJdlQ9dG0+Rtf2ZulTXuvF2wjQaXZc5TXeeBZZ3orQf2AzCBe5W/d6pTqkhdzTnCrIaIZ/wabPeDzykgAESlhcx7rmJUlCWwlVK2Q6Se65QprhRl9DgOUEFNoimgs22xWH43ekQkVCOPqZH8POy3JCQf/XgdSBY1yCxYcjgTrCaImzfIOgXQHsp/Gie2Npo5TOpob4it0wV5me00Y0LzLMHJEWd/z9Ej7XywWfjUqyfFaUM330h+MxqYtghwVhQsud5G9NYNpIRYqDm0qtJVHXCjjfIt8g/Mrmv/zzptro6pJmDOP55PGFR/6PisbUnuBZIReAZVh9APdu7Tf1XyuyPWQN2hnARVM9V3EeludWyKh862rn+1kDNcUoFKpq2+Ujnu2K6qVMgyjDzyitQogt74XCYxdcruPAh4EJRQTsAi76snV4MHsHlwbSpMeRwXuLU2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a balloon page marked PageZeroed is freed during migration,
use put_page_zeroed() to propagate the zeroed hint to the buddy
allocator. Previously the hint was silently lost via plain put_page().

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


