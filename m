Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FF1ECD343F
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 21:06:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 054696B00A2; Tue, 12 May 2026 17:06:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02C2A6B00A3; Tue, 12 May 2026 17:06:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E84196B00A4; Tue, 12 May 2026 17:06:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D8AC36B00A2
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:06:11 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ABBE11C04A1
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:06:11 +0000 (UTC)
X-FDA: 84760000542.06.3D78878
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 58A8A120009
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:06:09 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UOyCE8kq;
	spf=pass (imf29.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778619969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jpAQ9O1oMgUNlo5ukg9OEno1SM1k+70VK2/jH7/8vVM=;
	b=p96gixEIkI46OQ512D0NlfaB+W8vafypjTmlfd4b7HEjOPFLct23P07UFJGeT15PLFZP8U
	rVgoVMFMdEkxo+ZkSOmKot387FAkCz4g8OXM6kfmnIopjg+mtwNmQ8CjrENIx7yYNoTbrF
	7vQVLSXirlkhe2z/ijTT6mvX46iXIJw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UOyCE8kq;
	spf=pass (imf29.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778619969; a=rsa-sha256;
	cv=none;
	b=0ZJi0CG8kMNXfWfShNX1FOqasIJR+JUrfthJaINpt6kBwJk/a3Nlu4IMQqhhXyC2+1hW1H
	Cg4+huLuC2NtunDsK8Ch6vVzzaI1YblSfZaoeJQDmJk4BSyaVL+qJEu2iw803sKfwW+BNU
	nCm3A0G7HjjPo1/8JEGQnCqtulma7zw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778619968;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jpAQ9O1oMgUNlo5ukg9OEno1SM1k+70VK2/jH7/8vVM=;
	b=UOyCE8kqgxj6DT8d9tnNaicNWKoZ+nlph3hDi2R1thXlSWC3k9dRrhTPKazC7470C2/v4F
	kTHlqxQahSSnqTa3ynL/+dKZ7C58TvQ8b+Wztq/o27gAWpfHfR/iDn8uMtXzo/nXmTzTP5
	Lw3SktYCXBAcN12F1a/aSmBFq2gcPu0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-136--4LZgFZgNLeKm26pluQlMw-1; Tue, 12 May 2026 17:06:06 -0400
X-MC-Unique: -4LZgFZgNLeKm26pluQlMw-1
X-Mimecast-MFC-AGG-ID: -4LZgFZgNLeKm26pluQlMw_1778619965
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-43d7730e9e3so3818898f8f.2
        for <linux-mm@kvack.org>; Tue, 12 May 2026 14:06:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778619965; x=1779224765;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jpAQ9O1oMgUNlo5ukg9OEno1SM1k+70VK2/jH7/8vVM=;
        b=EucKBJACxnVbyGLV/Rev9uH0UdSNX9n1IZ3sFPmLGnon3c2QTY0kQPoSvwk3o6fat1
         AdioXW+JwfLYRjcfxBXpUPMQR23FNYTq1rt2FKyo6DcHPz5uc6x315iT/lBc6gdl6es3
         rl5RBy9HrxMwxgNjZzsiVl7DR8840vhlOF2UpcL7couTASvKQJPz7nXIRzo+eG/UrKlC
         GRse2msvF/vkBwdUVRUC9fHUdyZ203YKWuHSh1jKkhzKOUKW4eyF/fXG4oOtKXVUq9A5
         C9BkM/5tzKfJ2Fji8y2JXw5dnn6yCA/5WZrGS44oYISlTdQejEqzowP6i2CVh5ozX7dc
         PZMQ==
X-Forwarded-Encrypted: i=1; AFNElJ8il9asn1n2P42sky2nkZeJ3YeEAZE1s5IKhn5COHEcA96KUUefD5reZYi2a586PLT31hgGd5opHw==@kvack.org
X-Gm-Message-State: AOJu0YyYat38pDbQKALO0Ln1lxfR2cgskRIbiEWaLeBiFE/7vQ9B16LC
	CIePAN7rfVk8dNYA6ffDWC43W3AOWdShb5Otp6x95KTVwsGCfTHbmpIRtBZix3NCYk4hLmqYw62
	qGIWZ14Lz7VMZiSsRF7DtDrIeScTIpnMgBinD/J5a5raybE05epG7
X-Gm-Gg: Acq92OFVPL6sJ5gZyZb05Y29bRX1SSDvtoPxHx0acbEL6T6EBkjgKC2BuSzy0VSEGT8
	eZD/3nsHrkZXJogPEKUVUNSneQ46xVvbKr0QZA+SewrxnAeQg22NtqsSa19p5kyizFKCtrk+wRj
	M6wbEqsItAaUZzWG+KetiLP4WtY73zWjeuYJC9NI69L/D588eiHzF1QTe5OeDw58UpkvoN4Dscy
	mJdqMGXC9YeXwXG2NBFaA1BtLZ15o1o/z98Eh/noZqX6G8SaKpVEcT8+EX0UMgQ4BaR/Ix39A3e
	NClbrcUnPfOdBTd0CHkgzN2XIFkxtvsFZoKUdzWFomR9Kf7S0N723mrlDaXYYOPphoRknWRugFJ
	lgoDloLM2MWYk2NfyS018IICqGe6xOyGznKBT7MHa
X-Received: by 2002:a5d:64e3:0:b0:449:9aee:4573 with SMTP id ffacd0b85a97d-45c584a91cfmr556792f8f.18.1778619964959;
        Tue, 12 May 2026 14:06:04 -0700 (PDT)
X-Received: by 2002:a5d:64e3:0:b0:449:9aee:4573 with SMTP id ffacd0b85a97d-45c584a91cfmr556737f8f.18.1778619964519;
        Tue, 12 May 2026 14:06:04 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4548ec6b00fsm38840020f8f.11.2026.05.12.14.06.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 14:06:04 -0700 (PDT)
Date: Tue, 12 May 2026 17:05:59 -0400
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
Subject: [PATCH v7 10/31] mm: use __GFP_ZERO in vma_alloc_zeroed_movable_folio
Message-ID: <bc48239f8f4eb21cf2f9f6e6533c68daaaa2a01e.1778616612.git.mst@redhat.com>
References: <cover.1778616612.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778616612.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: LIVPz0IG9ZPkFid1ijEEMcx5cfrKVfNOVn79_YU9RY4_1778619965
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: r6ugy1q1kpc6s6da656fsa7drkprca75
X-Rspamd-Queue-Id: 58A8A120009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778619969-173239
X-HE-Meta: U2FsdGVkX19m3oEdmoyWjgPeHZLYtwifTMZkeF+Es3D3TKJXyqNN0lv9m4Zt36qw0DFBWTySlSKPDfgPv2/6wieufNqLNbq/ua4Hb8HFXOh2BJdCVu/sPTN3uv4Oo9Y2380+tJppFQKKkmw43qUjv7tBOliWfNMn4JDjEqW2WwSNV1EPbqRbwu7HAX0soBz3ZKhi4NwIJ972O5KdGwCKxLUEM9lhyHLWBx9WAdeBLb2oYPkCC/3zeJemvx7KDss5am5TKnqtsNGJNT3N6cDNxgSw72+GfKlWKyHyTJOML4AA0R8h6vGIXTYP54BpJW/QqbQGmnVbxWk5ohU7mVQ/q0rXspZHT2YMf4wIIxmIwgpfhk8a8V1vUxIjEaMnoQB9NieVx5tpmynmUVEKK9fowiH6RQBWnwYdsbw8EqgEzs9WK0Y6ByE/lGriImyTXkjxHead5Win5RMuWhLVwSJWZFLC7QAxYGEl5stLBonAG0roH5xCicmniHlsBK+bP3mj/4gNDGJem5nzlzevyshgTnNAWjAdf1LefKcMw4Edwe1+vFYgywiH85ov/eZA1TDgnVWK+9Q8x30vJZWDhSajmJNv18/WXSWuGlsEB6aXe+Q6Wn2it2GEDvjS3Z0iYiqVZRi+0WoJazSBXeL6igxvu2h6cfvC62iXGF7mW9GnKunk34Q6mBtxjkyKIa1lvUD6gI9j6TBwdInBdk1P+2uEadpSEyICGusZMLB+MM02WnIOqFvM1XGlL5QND+kGVTyUbkoHxm0WJkt6FlPR7zhGXUKat4nr0cL778g78YawfqH9esJiDoRz672ZLKAwX4YSuHjQq36O4Zbg0LBQElzrMRODSrnGZKPWBqBcSzAWJ6/C/O3GTeSnu975sjAc7xqMCR5VSo9oNQyb1RJoYmBFAVPaADpqt2mhUUpjcrntqCE3BxHr9oJszvZDzh/PDJc0L2wDjgzorjDTiDu2/Vg
 fgS+2F59
 JalZbvYVEKS17pjVQR6MZIhmkU8wLR8Q8hiQLJtl7Xa4pYRO7XnuAGVbBhz+xQEtQZeT/GxvT4eiMPiOYjw0yLovZQjxcMvYdhkOjEPV60Gmvpf7gbQoMVWS5JDzoVF/7nmYV6Bfjp36bv2CQX458ZUwt1k2jaGfFoUgLc4aNNM4hIdFjTynGkF5D7qhFWrrfhb7mVp3x9KPspKA1KAbj96hlIdo/8lbKU0uqWUXPQEBLqeyWBy4IfFjynq67dRG7wKgNEKqhDT1+MPD9TvBNVPmIcW8Bw2HUWSVyNsI20lyV4F1iQy///SuV+VxvhbBlV9UY0IxL1le94wt+hIM5L2wwFhxuzwRm9/bcW88r62oH6rfggcIOv/BfzhUWHXtrmxVYsrCVkTF9sHYjPA7vDuPZeC0fJmlzQHkAfT+xuWRJ05QYRTksX6ySNJDTvjV3bs50
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


