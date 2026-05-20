Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E99F3CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 22:22:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DAA66B00B4; Wed, 20 May 2026 18:22:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58EB76B00B6; Wed, 20 May 2026 18:22:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A1636B00B7; Wed, 20 May 2026 18:22:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 37DB16B00B4
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:22:15 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 03520A03FD
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:22:14 +0000 (UTC)
X-FDA: 84789222630.21.7A8876B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id B7B1340003
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:22:12 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=h3q35QxB;
	spf=pass (imf17.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779315732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yH/Aq3jRD/J0BW4aKC2BcM/dVQFsNlzLQi2tKUktXO0=;
	b=dTZw6Sv5qRRh1GtyZmiYSMEpfQH2WincUBBYLYJ1d5gnL0DrkbwB0NnH1e2STzEG1Ad9hL
	Az8ea9dCTFde7RuDYIW3bssf31peto6ioKjyX+nTd1iDmK4nJ0Fy5zEqXTqwNZEaIsmy25
	/rtwPYfB1i8kB+cXb+yAjYsgO8Eo2Fs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=h3q35QxB;
	spf=pass (imf17.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779315732; a=rsa-sha256;
	cv=none;
	b=gEORf9WNYu1vrxrTp+de1Zq20HEISImPy0HRF9FSu71yIlR4gjF5SJz/qZ2DuGvy5dFHqo
	B62PqoL1pyiAqsicd7lG5f5Jz0b/xHI4dJ7T9TAyBBAgI2bsQE5pRHaDeimsN6JPXx85z6
	QzV1pKjGMpEo0H8hTDTe7lOXIHVgC/o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779315732;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yH/Aq3jRD/J0BW4aKC2BcM/dVQFsNlzLQi2tKUktXO0=;
	b=h3q35QxBhmWxApwbOSXuufgPQLLzFYtkU+P+KFdt2hL3dYlQshkqtYR3CuqQeOWbjPFLkb
	4ZEp69YX4K30xEAkB6w8Z2tRpx9jYtOPz2cecx+Gl9SXbMeGbQTeptV5bwHv92I+kcL87i
	AJZ0p2zkaupMcxByZ1tRqzUa2whCdu4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-267-q2exbUaZOp2mh2KtIPPmiQ-1; Wed, 20 May 2026 18:22:07 -0400
X-MC-Unique: q2exbUaZOp2mh2KtIPPmiQ-1
X-Mimecast-MFC-AGG-ID: q2exbUaZOp2mh2KtIPPmiQ_1779315727
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-48fdb2b0cb8so34017315e9.0
        for <linux-mm@kvack.org>; Wed, 20 May 2026 15:22:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779315726; x=1779920526;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yH/Aq3jRD/J0BW4aKC2BcM/dVQFsNlzLQi2tKUktXO0=;
        b=AOW1a2ZvTDAqMi+Qzbo1taQ0Jzbklvfz0m9tjpxg3xmusJemTINjkeAB8G1SCJvacN
         e/D/7QNE1e+z7j47NGlBvvCEKyixf/ilXCzB4XyxxDFH3OvrxFWtFSVHpJRiq7p3IZZT
         qj+I/OYbWZt8iFYGGhxNwdgGg3APP1PTv/R2fv9GY1F0MxYWHohOVOVebx6wYVzFaEm9
         +pczUtThJ1yW4JozJ1RfkpOgb2lZKw9QPlUUqqqN9p1sBwhgCHbsODvynAbh6b9mXMV0
         BkXC6Y4+SG+x0UYoq27pcZJE9iCwbvHlBuZVozNhvLmYqkUno3SewJoPuMM9X/GKGZoR
         Ds0Q==
X-Forwarded-Encrypted: i=1; AFNElJ8b7I3UW2y1F4Njrvtqm+UQ7iqeeY0i4j6xyrqPbuEOsDGFLoZB1JHth5olSUfYfKVZ4pC7+g9G+A==@kvack.org
X-Gm-Message-State: AOJu0Yw5AeIZeb6xI6EmJ5x4eeVa0e/oQV4hL/YMXNHYpyRhigWXyn1p
	bo/lXl1vrwcJ16QxPkqUzeAsQiJHcNLbhtCLlp2kt61WGk4Wp+6lU6/gpAa+XAWElg5a1ICXE3e
	uIrZmtWdy+TaUrRZLi83Gm+At+PPcVVEjyfKiaG0UsDPVIMxBiNBb
X-Gm-Gg: Acq92OEGA1Y47J1Xgu5NOLd+zevmfgbZB8DZTNYXEXizB+c8lEycg3xhfhPkF9o35yc
	xX9q9vpAipsL0Ac0vvGAW/m8GM4cTzhbMnTvcFQGKNGjQD2aZKwW0Qk9pUa0cUE146NCME2n9W2
	CFdgavUKYcXKRO7G65UKaADyBN/NY2/qB+HC2wq7GFVPxhGCdGaQ069UJg6RTmVbfgF0leMz5GI
	ZJ1Ahh2iqvVFb2CCNoQux+Vei2tC7lV5Mkr4W9XScSZTCRDq4pr45wOPsL5XKL2Dm5B+0o3RFu9
	hLheKoKcGnBS04D2yM0qBCS00TPES54q5se5SwTJ6utsyMsJtOoIaEaEhq5bsywAaEZjrdcz+zp
	HG45bsPlAsjlNKknjhkxShK3XuFEve0tNXASJdzhwg8w=
X-Received: by 2002:a05:600c:468b:b0:488:a824:fdff with SMTP id 5b1f17b1804b1-490360c53c8mr2627645e9.22.1779315726560;
        Wed, 20 May 2026 15:22:06 -0700 (PDT)
X-Received: by 2002:a05:600c:468b:b0:488:a824:fdff with SMTP id 5b1f17b1804b1-490360c53c8mr2627125e9.22.1779315726026;
        Wed, 20 May 2026 15:22:06 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49035edd7cfsm1709205e9.27.2026.05.20.15.22.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 15:22:05 -0700 (PDT)
Date: Wed, 20 May 2026 18:22:00 -0400
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
Subject: [PATCH v8 18/37] mm: vma_alloc_anon_folio_pmd: pass raw fault
 address to vma_alloc_folio
Message-ID: <ecf3d8b129863a662a79c8d1c541c6855b1417c5.1779315441.git.mst@redhat.com>
References: <cover.1779315441.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1779315441.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hk8UsEX3Lch9V0K7NcrOUusprBmrousuA6U5zYZgvXU_1779315727
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: kp3tapf5zbqofsyne5iwnygy3b43fp47
X-Rspamd-Queue-Id: B7B1340003
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779315732-701941
X-HE-Meta: U2FsdGVkX18HOGHQCUCRTFVUvVIMmHMy59IiNQXqS7e6ykrK06rsM1LpSu+zX4/N4RZGySjicWTKyqdM/E0UtPxfw3UrwfOC+bxjYVou9kGszSSJ+FxjK6RSkeEfNbVj2XNQpZoAWhSIPyKx0FinvV52z5YYWEpccvOug/Ou8pWauvuSYMj1vchsPFxmuRjD6l98z/zrPTVAlTW1sncnlRzg3WVCMNrPnv7sDiJdnLYEHyEhDWdQASjSWK45eMuaqszoXrrh9bmbRHuS01z7FFH6wRo7OlOz0/SahZeCrvtSeUm113D0rgtzb7EmvGaZn11Cbf0/T/9K7wIgSCtwYqtiafZ1mU4oKojAVkLxt3rLJevr4G7Y8YQ7/VKlCd1A5sZzH8f6CLl9okM4UVLPDCrJpjXvbNiN0M/DI9r9HT4dkXfUO9Uyd0PG+26BjqHBqLOjP25QB5zza8LQBPBBUBceLJpsEYwMTCzcMZ3d4ORnm721XZNveegZnFUbR8Co96d+WRevdhOFHFIWKWCGD+YH12MBB6bBzthDC7ItB2cSrtZWEUHoprcl+WdqTlMzSDFiFImzT/IGEl63nMUzOE9mfe7EGyXznaokznLwvGHL7Nd/Wm7EC3tQVur/3NKVEp+bd5R4/yK5KRyuydsZGqfpnUXJ/DZoK6SM//I0DKeN+mSGlVb/qNs2jgS4pRkFQL3AfpwswYdbZ49N8Q66Cegdn4AC7Bs1tEE2Jv8iiU/3vB8I7UCFqZo4aj5wWvYAThqerbkJPwh36hLOBDUvO1H6JzMxkW0VAqLD5EeFDV7JaGbDabGURgu7L1Ba1HYClzuPW5V3xq17w2EBC2maVQX7/X6X5bosf2XArrGKlcehwHXpX8JezjpoirngFptDiTPp9YfDODwo67XK3AZKTqO07PBoGpyOwh59SoD7fYCIEy8NGCjG5788CJSkV/dtlvBTBhzrE0dP76ygAon
 YzxgEsWX
 qH3vEGrva6QT9DHb7UibZ4qrl2EG5CdcICzNUDc6uccPENeWEPkU9pqqrnCwXelqJ0WegT4FZnCLgv1iH0lLFYyZsA2ZAN9rVzm831qft/Lcb/CwZ/OFzsRqF28vUlnGSPy7Eu+1GwbGUeLaitmjfD/ZIMn+kA2mydJoXSBbAXAMVe0YskC+0woj94XD/UbBVCydmsD2d07c8/EyFlzwrkuDqa7/UBF992LAc9fiww9A8UuN4OkGvu9fwFkYZemVIxIWIriL9An+rRDKfaT0XRrXi3HfxNY6vBPvBKWOmtEpG5HqL7v8HyGWiUIpbfdmEr2J1oQXoAr51czVhBW6ih1GB92Iqz+ObA7B8HdWCKz1T5O8+rVzcibkYKVFTh5dL4nYDOU0DOB69qWY7pPgIuLw4Ckz488MhL8R8gf2LAs1y/ePwo5ZvoEX/7a8CqyoiH+domPB4EcB5XJZukWt6smjTWs8XjQ6Ap6uP4OoScGeCCRolBk88uzMS6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that vma_alloc_folio aligns the address internally, drop the
redundant HPAGE_PMD_MASK alignment at the callsite.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Reviewed-by: Gregory Price <gourry@gourry.net>
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


