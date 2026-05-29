Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A422FCD6E4A
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 15:22:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBF126B00B5; Fri, 29 May 2026 11:22:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6F846B00BC; Fri, 29 May 2026 11:22:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C85AD6B00BE; Fri, 29 May 2026 11:22:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B6EA26B00B5
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:22:17 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 68EC2160E14
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:22:17 +0000 (UTC)
X-FDA: 84820823514.06.FB47AFA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1BBA020004
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:22:14 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="ES/pdulu";
	spf=pass (imf31.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780068135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=315e7bSessxyz662R8s4IU7FTBDlj+mVbEZvVNtQrTU=;
	b=iKZvyI2yV3l5+6HUNvwmtkyF7bmANzmaSb7AevE7PtjyOblervuxBswYhd7KSR540Nj1Yv
	qSdlI/da7QCuRZnL4pD2TxrOAuKceTTRMKyF8+Rw4M4RTLqz1xRf9wpI5hK4uV8k3/0hcF
	eusT5AHDl7lILeA4aLjSuVr8oW3c4LU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780068135; a=rsa-sha256;
	cv=none;
	b=sWNdnQo/c82nFXAUADLGwAWVgyYOu688gsq3vaYyuvpSYyaasQcQ50598NtlAegCvcN17P
	uMKaGpQdX3Pj7e4fMCuZOcZrKFghO2jOayqVBRCaBUe9bxQD9e9KIyiM5yvfqgmSCauNAR
	vMH0FuqUJMUEleph5WVEDFNXDPptXBQ=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="ES/pdulu";
	spf=pass (imf31.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780068134;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=315e7bSessxyz662R8s4IU7FTBDlj+mVbEZvVNtQrTU=;
	b=ES/pduludp2aYGXqaSG437nkkK1KqnvyK8CfoKoPA6ZD65saVYx5C9hxjBjgyhaM5rlIdr
	h1APbunb4/3aHjuau8Kt67Uj44ZMBw0IO095NwA42axjRE78TkUxsFRAFycq3H1qh5f+Sa
	feQXsKXs2MaMeAC3FPaNoHShaC/sPPs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-403-Uq_-AkfNPz6RToJkTXFLjQ-1; Fri, 29 May 2026 11:22:12 -0400
X-MC-Unique: Uq_-AkfNPz6RToJkTXFLjQ-1
X-Mimecast-MFC-AGG-ID: Uq_-AkfNPz6RToJkTXFLjQ_1780068132
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-48fd3dbd16aso115314065e9.0
        for <linux-mm@kvack.org>; Fri, 29 May 2026 08:22:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780068131; x=1780672931;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=315e7bSessxyz662R8s4IU7FTBDlj+mVbEZvVNtQrTU=;
        b=a/2d/5Wwoqt+jWj0ID2Y+MqZ9s7FWihhnzMAZFZTT9bLrxZbinq00PH4vtzIUh6OEJ
         Gko4YC+c7pNKN31Dlwi8XZ0EMsxYC38mtuGBHZKVZJBme3BJrZ6nw/GyOSkshx4zf4Ar
         uQ4CmBAXMSy6uRyGaXf6nda7qD1uaG+De98Xu6lOrrJUsxv3z920efcl6v3xNLUPd7Gf
         qUpPbAf4wAeHo4nFwauG0lNK1w259GdpTNE1Brp3p4j3JuDuOV6P/aNp+NFRFaQ01+kn
         uTadBo1yUAnDFqAvzu7JETitq/2VNtFzzwRYi/yUXRv191qJGnln678Sv170XM8A1LnY
         o2/A==
X-Forwarded-Encrypted: i=1; AFNElJ9dMOsTfH0LUbagfNUKglJgsNcE7LDe7Tc0qlq/jqVxrMr/9A51k/TxGYFtIwh4wJAD6eI71mv0nA==@kvack.org
X-Gm-Message-State: AOJu0YxUSFge4Esea7mHggD2TORigRvJDsdqT+eovSMBRT8xJYL6SY38
	ACT43Ev4g6GumWvfp1srracfv0xbSXxR0vCuMlJzrX2KuGMvz2eDXiwunsohcz6J7B4wHGeG9nV
	zRWj0BUl2KchCP+my+WxHGTwH3OuuWbca9ZcAOFT11hy6EbwoHnx+
X-Gm-Gg: Acq92OHqMQ8Q6du71RJ9+GX0eghNU6wOeJs1WzpO4EQodre5R9uqJrAw5axrwYMB9tP
	GlJ4SP9ydetOsC6yALX0pszA9J5v82sfmToKX+0FiazmM+J2Udq+WXJ1KR8eae9KMix62+mgy6/
	6FSdbXMmRwFN5mwOcpDpvY6VR019epLU8MxJKfP//+s64phduyq8tPz5O3JlLgI2uoO5vFZciY3
	c0zRd3DdVihknyrsD6B/StuyYTzF+M0rbZSsv7NEJ/3q2OdtREY+zYmSWu++GoFrF73ofiBFqF/
	83o01AcKqpFBWDye0XzxV31wSM4WcYOg8UMBnKB3hH6LAXSMaKBPdlzehdPn2ujWuaENmAMtONl
	0buJ3uP5uIDauuHyjF0x3U4MqKcmDRzjob1hFAB2FZ02L6hcBXb/ZVQ==
X-Received: by 2002:a05:600c:8b12:b0:490:2238:4021 with SMTP id 5b1f17b1804b1-490a29079a0mr2311425e9.8.1780068131462;
        Fri, 29 May 2026 08:22:11 -0700 (PDT)
X-Received: by 2002:a05:600c:8b12:b0:490:2238:4021 with SMTP id 5b1f17b1804b1-490a29079a0mr2311035e9.8.1780068130983;
        Fri, 29 May 2026 08:22:10 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45ef34b47eesm4805302f8f.9.2026.05.29.08.22.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 08:22:10 -0700 (PDT)
Date: Fri, 29 May 2026 11:22:05 -0400
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
Subject: [PATCH v9 01/37] mm: mempolicy: fix interleave index calculation
Message-ID: <56ada5b2073a7e307e03fcb3f5327d0cf3dbeb8a.1780067977.git.mst@redhat.com>
References: <cover.1780067977.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780067977.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GzcA65ywc2Fv6b-3DGNgWyXx-6jqtX3jVC0A7a9LGd0_1780068132
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam11
X-Stat-Signature: jyk5jd9hk4y45bq1wsti9p9feuqhj34m
X-Rspamd-Queue-Id: 1BBA020004
X-Rspam-User: 
X-HE-Tag: 1780068134-714824
X-HE-Meta: U2FsdGVkX1/4mePndCm0n/hNi4TBcIk3sM9HgXCFtAV2McCOOuREDnfWrXf8Hw1u9+XXjDtatAfZq8Uly97ixBiGLdjoidEsSlp1jTJ69Z7ibg0X4KpzdncecrTlIeYi3iJrw5iFqtXzeDKiN4gWUVtlkt35vOLIC6STNfOnKEcVkbU8bUp8P05wyB/s7gou5O0qU8zGdQDOXVZ3UALOSwdXav5jNiWpKNtW8Q+JarwI6vkf+Fxe/6TmKW9yTtk/pD4ldz2gV8Tf5u9w4N/p9+aPisx9+QaFNI1eeri5alc0umWrQgjTv3T6KstzmpN5fpzKL7r2cUsolc6N0jnOj/uxNZWLp5GsVWa4dRH1pU1CRNP/5sMY04NxlYKsfnuECGM+/Zvq43x+57Yl+p1LdY8vyLmelBmUdu8MpHSFOl6aWQEsKm8pILZLWk2oHP1osAedp8qBcNV1A2Z7Q3m6Nw4BMWp0AbjUr2dUG7k73d56Xfqpq9W/QlrchURMsUiDZQlF0u1lwGsT3jEhG+Xy4sHM7Wumx5m+NM0lFQFBtPaY8LY7BQ0AM4wtdYX7iGAhnxdteoJgF8Xh6gDeCxIsjepkw0MlBPqI6A/Lv9uei1Sn/mYekm/M1BAPp9/f84hc6md+5yjheszCpTAhps81EeE5QkPepgAmcwX5U7wBDFYOZUtoW8iLd+xbOXm0keBOBW9gRJJaFPyevws1sTnuTgq644V0dA6iIZ4nD+ZMa5LQvIFwIr8w+jo2dN0PjZKyS+kskxNYh6GpQd2JIMUm2bCSMv1YpRV5uGpZ5ZJayzwpf5osJMjsKNIl9ABzd6KhRvLQ9JaQ3FIA10pB4RS5jW8ns8X4/+sMUxM2icH7TpsScHvsJ0/19ysUHF1AvImNfxFj2IfIS9bjL8WbZbfHbBO+1nQntGJEn6VFG0mWYJB3D4fOSxSj8dS8snqQG9Zo2zgWZjpUNSgG/dCAZI4
 2TElYOSV
 u4pviJsDk36GePMh2NU7SHFyLRKg3hwD9wk7Ur8PVmOc3jLLQSH7sqUSzkXtPz3X9h8zTsAyOcGf5ByRTQXFUEySjl802Y9PQrhE/uwPGxXmS4I8u+AaYY6yPIMO9Oh4OMPotGG8I6wpF0/KiXsZWHuIK+yKgZx1R7SYDmzPvMyLJe5HH6lnUF4RBdDmKif6r8h/1ReBHQi+QatzAkMJ2wSw1449khgNmTmwG4b07CTwj49ezr3HejATVq27kzU7OFLTtvu2WabsqvLecf2z5nEpWepAUP/TCHirfPyyTMGBljHfY9721zBbd59109JLFFtK1tl2rMCTvjLETHqTR73q9TGycsb+jqiPl/IeRdHkDru1nxK+O596J1lV5fHJARAobEZONrA8IBxp6VfcImDeJ5uvIZcR6lYgUvp8qliYiY8QAeeoQjufNqCAOpJsyvxOw3CSuAmPbmsg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The NUMA interleave index was computed as two separate terms:

    *ilx += vma->vm_pgoff >> order;
    *ilx += (addr - vma->vm_start) >> (PAGE_SHIFT + order);

This has two problems:

1. When vm_start is not aligned to the folio size, the
   subtraction before the shift lets low bits affect the
   result via borrows.

2. For file-backed VMAs, shifting vm_pgoff and the VMA
   offset independently loses carries between them, giving
   wrong chunk indices when vm_pgoff is not aligned to order.

Combine into a single expression that adds vm_pgoff and
the page-granularity VMA offset first, then shifts once:

    *ilx += (vma->vm_pgoff +
            (addr >> PAGE_SHIFT) -
            (vma->vm_start >> PAGE_SHIFT)) >> order;

For anonymous VMAs, vm_pgoff equals vm_start >> PAGE_SHIFT,
so the vm_pgoff and vm_start terms cancel and the result
reduces to addr >> (PAGE_SHIFT + order), same as before.

For file-backed VMAs, the sum vm_pgoff + (addr >> PAGE_SHIFT)
- (vm_start >> PAGE_SHIFT) gives the file page offset of addr.
Shifting by order gives the correct file chunk index.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Reviewed-by: Gregory Price <gourry@gourry.net>
---
 mm/mempolicy.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 4e4421b22b59..d139b074a599 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2048,8 +2048,9 @@ struct mempolicy *get_vma_policy(struct vm_area_struct *vma,
 		pol = get_task_policy(current);
 	if (pol->mode == MPOL_INTERLEAVE ||
 	    pol->mode == MPOL_WEIGHTED_INTERLEAVE) {
-		*ilx += vma->vm_pgoff >> order;
-		*ilx += (addr - vma->vm_start) >> (PAGE_SHIFT + order);
+		*ilx += (vma->vm_pgoff +
+			(addr >> PAGE_SHIFT) -
+			(vma->vm_start >> PAGE_SHIFT)) >> order;
 	}
 	return pol;
 }
-- 
MST


