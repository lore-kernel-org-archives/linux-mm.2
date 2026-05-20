Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B28E6CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 22:21:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 209A26B00AA; Wed, 20 May 2026 18:21:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E2866B00AC; Wed, 20 May 2026 18:21:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F7036B00AD; Wed, 20 May 2026 18:21:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EF0AD6B00AA
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:21:44 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A8CC68D824
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:21:44 +0000 (UTC)
X-FDA: 84789221328.24.C410B92
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 80B48A000D
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:21:42 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="ay/iaZkH";
	spf=pass (imf15.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779315702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jpAQ9O1oMgUNlo5ukg9OEno1SM1k+70VK2/jH7/8vVM=;
	b=hbmTDA5VraPzr84gZElPk0dT6zoaGlx4snnpgKcGqLCfab08dgXcBCa/39dXMnT88jj6EH
	hyTpzLl6CKpLsbIkuSpYBIRQyGP8NTwKeRVOPQ3TjAWqrEaG8NzRqoddu7TwnsoXQJPLIe
	uWDiu8JRqIbp3QRly7fMGfG4nChZmSw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="ay/iaZkH";
	spf=pass (imf15.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779315702; a=rsa-sha256;
	cv=none;
	b=MlFGwZuUvI5hvXAZPR8RxuTLGG8rO1NtEFqnKzo4n/Hp2nhJLyLDeXhtiLwjmccrFMBqHh
	jS1rkXZGGp4fKN4B0O+Uz1bJv5dfvGJQEgh17wRZy5rYDg89OCkbSnrAESL09oUIzNSvcE
	9CcQSVYZvTrhNXTKAOnc8UkQDhgyy38=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779315702;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jpAQ9O1oMgUNlo5ukg9OEno1SM1k+70VK2/jH7/8vVM=;
	b=ay/iaZkHfOAYwlSlXLbBF4/axJd0NLUBQSbgNENDC0yVyMG2BGWWukB95/c0EP9diLCv9E
	6RROMokQvP+Hplo/JqtAWqP824KLI892JU50kj6VI1BUzAxni+DVAhKoiTaSsGVZawbe3w
	wEIMwPF6caiGaatSRqhXILZ3LskVcVU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-359-xMn0i1eJP8KRONhR_ZRpag-1; Wed, 20 May 2026 18:21:40 -0400
X-MC-Unique: xMn0i1eJP8KRONhR_ZRpag-1
X-Mimecast-MFC-AGG-ID: xMn0i1eJP8KRONhR_ZRpag_1779315699
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-44cc3c9b2feso5149306f8f.1
        for <linux-mm@kvack.org>; Wed, 20 May 2026 15:21:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779315699; x=1779920499;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jpAQ9O1oMgUNlo5ukg9OEno1SM1k+70VK2/jH7/8vVM=;
        b=fxLrzAIBxU+dAVBzHLORJLa7F/BtFPQC4LHFAzXzOZGqItLWn+WdnkszWPXD1KcsvI
         5qJLvZ7gLRCKISGst+tSZ+GHUCAcX3+VDc04nvByhugzUu8lwCnjy9GatkYOithVIHQ4
         f9RAbWlZ3soYV60qRRv0qL1MkT1cq2b313UQY95FqP63qE/DFdptD41Y5vxhWhkRWwwy
         YMohW8YmJ37GPPwqWo0jLSp3WRzFbJbJ5AregAprAIybn9mnRsUBRr0JkqMIqsFBgzN0
         qV9FBJn7SVofUYE5v4tC4LUV0IG3lOHTypYecAKWyhMHo2h5IDWRsCKU88fyKC0QiFFC
         Xppg==
X-Forwarded-Encrypted: i=1; AFNElJ8B8Wj7HIjE+c5rAXptctwH/WAc5LpmhrclZUrdjkRwkh0e0GjBd3uwv2fn9ZCPuNiKvt7Ok31l9Q==@kvack.org
X-Gm-Message-State: AOJu0Yw2ZKyyVozOtOGBd5CzS3/Az4bClCdMEiXV+7JH/JEnjbQcajVM
	BtwNmgEU4jLqNw8q8mQEbj3itWfOLmAYFdVV6PMXJgdV1oc248JgnKMTQGf5OQ/BCaWPVAdZzGn
	XZshFf4cDOTS7fOQ9b3nLhEkJ62r/PSvBJh8Jb6NNkHo8yTN46YBf
X-Gm-Gg: Acq92OFzi3nGUjv6gdY5BeWTrDNqYw1JWH6Ph0OJC7nobRda1pY/yPsSRElcSXx4GGm
	EtUuAxnVrTqklNZzEh6+Cl8QiAKZd5cRD++jeogZ7Usd36Blv2wUzvDrLBhYrFi5wRQ6cQPhg8d
	ftLECjGhw6dfP3Ob6BN7x1veAvXUyZNSeINMwlcVXvKUS97vOd4fWuU1ml6Xji4MzUhUit+FEtE
	bil85yEFm8NeMp7zMxb12QlS6UXqmbSW8y6iG3FHD5ahIwUst+2ANvG6hkF7ndi9+Amcf5Y6a7v
	R2Eab0HT0QDPl4Dcu2IFgIDw8jr5lIi9qmAtZfYwiMxN6HpiLuWxBpypjB4NF7ZAqr2dkeUW8/X
	mEo84VYMDmy5OPrQjX2N9QrHicHjMoi2Fntr0KZZkexA=
X-Received: by 2002:a05:6000:186f:b0:45d:b14b:23fb with SMTP id ffacd0b85a97d-45ea38bae4dmr340570f8f.11.1779315699138;
        Wed, 20 May 2026 15:21:39 -0700 (PDT)
X-Received: by 2002:a05:6000:186f:b0:45d:b14b:23fb with SMTP id ffacd0b85a97d-45ea38bae4dmr340516f8f.11.1779315698648;
        Wed, 20 May 2026 15:21:38 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45d9e767d0bsm55493374f8f.3.2026.05.20.15.21.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 15:21:38 -0700 (PDT)
Date: Wed, 20 May 2026 18:21:33 -0400
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
Subject: [PATCH v8 13/37] mm: use __GFP_ZERO in vma_alloc_zeroed_movable_folio
Message-ID: <d8e0bc4a28e5916b47840b824991541b2a76e5d1.1779315441.git.mst@redhat.com>
References: <cover.1779315441.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1779315441.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: gapAZKiV10oEtVQK4b6yURQ-6Unlknw_eIM_46ldEXM_1779315699
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: 9pauunhttkmmfqubqhx8s85sqkxu4rmm
X-Rspamd-Queue-Id: 80B48A000D
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779315702-888148
X-HE-Meta: U2FsdGVkX19DXRD0yUHYG+s+ixUFESomVkYVwrCnnCtvq/W+Ug7iEHBLimbLA5nsmRi2oOdMX64j7MfdrHpV5VJo/uoMrNHcyy7XLwR6dRlfsOocIJ1J7CjkOxLakZVJ9HIDRUDP7ARHZKmcI9DGDi1pm2+E1yGoUVgCOkZ4dQnl+dwJtEnAeNY7QL1MOcmdUwJe2ACbGGmgo3tLJCOQrsdFgOzhcMz6Qzxl/grJNODAur0HSq1WqxpB9Pudkzi5OIXtDD4pdOPLvIGwjUvi2SjNMwhcYPyRRfGh1A9FSeLLLwP0sJolZueZ3sFOvwFuV+V49DgWW1PqRUp2Kjp9Qalarc1vMYrsRCDon8LqRRI3qnN9EFC7ee8D7mk6YuPi/rSY+CAa+IDjFm/lYMs+dHEmbeCCsNiARsmCJ5bOo35FQ8IVYiIQGuWTwuGGum05xSMAmaVzuYCUZYw91ljguJQJRifSZ1xO+GeGjAv8JKXpy0vJOCreVNXwuu7NFIdk4qvEyJrBXYOUodXKbLyZ+VpIwrSqTSd+cOhT9BuhY5KG5UVd67xBaIqvlcNbQQ2MkyhGuji9kiYndCO8P8z2b9EfOy2QJiL82r4TICyX3xyaHUIq+g9tuR0iZ12XDxq8jDY+hq9/sGVsBUvyj1A9Bi7dhLA94d/RlJhB6w53/kSe6LcBu5Km1OODXaINXFGPwmHemYUfIHHIJgmmKiMwxcwAZBWyfasyezJZ2S2+hQ9m9N9mIw0nxa2gjs5+NjB6ajBJVxklCC3w/WIWYWwJ2UYLWcRpMEWxDgssqcBFRmfmy8r9kfSUmOOy8tT2Y/OvSg1oW3DfwE/iGT6emTrD1vKovd+F8lWbmt62KfiHLnDxqclyfbCuzVHkmI3DM+3Q0Ve7dzjIVjnLC+Oj5hPgEYyvXXaBkAQm/TbRyierIuaVIrf4wJdNCJ6Pm0r86u6NRV5tLRjX0heRoz/c76T
 Lo5s3j03
 VJYF88eoWcsN7rEqylGq0nfj7IS53zjDDL53JUOXejEQ/bpTLS0sFBlbHhLOlxHaYTY82gqOEefbeeaCqG3K4M1CUBrTrcSuYGzLEHzGogG2absdD+SJYWZJ408a1cBf+31rZLDXR4N+K22ZR+RPBc3ftDweo1aC9g9KeMOgoDwnLaSxogXVGZROEzDNgSHxfSR08gPmy4Ov9zcEXc292ujLmQs5p/uR6pbTkqCHl2z/BX6gE8ryufA96/BXhHD8hBp+SX0jxa/dFUYOAa3MxDixfkcJ1DtzVHV1bdf7CXl41u3zBDWPL59qDG7q7zz4v7h4MN/2vu1pDaKI2K1MGC+dzW3vkgb6IxJNeqM5UnE6TLtDJsgt76yWQ3XBdQ1d1zW2wgx9c8c/tP6ETpUTlsEAGYiX3mVB0uzP0Owz0hf4bvdR+piVJ86LcQl7TVwhV7vL4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that post_alloc_hook() handles cache-friendly user page
zeroing via folio_zero_user(), convert vma_alloc_zeroed_movable_folio()
to pass __GFP_ZERO instead of zeroing at the callsite.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 include/linux/highmem.h | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index af03db851a1d..ffa683f64f1d 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -320,13 +320,8 @@ static inline
 struct folio *vma_alloc_zeroed_movable_folio(struct vm_area_struct *vma,
 				   unsigned long vaddr)
 {
-	struct folio *folio;
-
-	folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vma, vaddr);
-	if (folio && user_alloc_needs_zeroing())
-		clear_user_highpage(&folio->page, vaddr);
-
-	return folio;
+	return vma_alloc_folio(GFP_HIGHUSER_MOVABLE | __GFP_ZERO,
+			      0, vma, vaddr);
 }
 #endif
 
-- 
MST


