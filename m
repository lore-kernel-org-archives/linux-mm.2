Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFBC4CA0EFA
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 20:08:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20BF58E0046; Thu, 21 Aug 2025 16:08:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D3F58E0045; Thu, 21 Aug 2025 16:08:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDABA8E0046; Thu, 21 Aug 2025 16:08:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D75898E0045
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:08:48 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A68501A0572
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:08:48 +0000 (UTC)
X-FDA: 83801852736.20.A8F076A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6CCEE1C0003
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:08:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UonbbPAB;
	spf=pass (imf18.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755806926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z7iPpUiW3LrFM0W3XrB+Z82uodwKTsefoCzXwhLbLUo=;
	b=xv4V0T4K0dlKeOmYB4nSwrgmW2xVGMGkMhX3AyYptN3746+c7Ssp3tzkDj8UJWNJ/yaC6I
	2fsqbD+UdkWtxLHd7mryeT3o3RqbCo5kKCeOKKeUIPKKa3D49BFl1BNlNu5NMDNFn96t5Z
	fOybGy1sDftfHgCg25CbM87nU/QcOkk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UonbbPAB;
	spf=pass (imf18.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755806926; a=rsa-sha256;
	cv=none;
	b=GkwAhHtftl2ShGbjV6R3ewQXkXiCrTV6fQ4W3/o5wxtcBqAzxrmnC99RqZQvj4Nw1aArwh
	TNPdPL+C1ToAScCTkUipqURVUqsGECLsBS9Msab9zxR8w7HulHOtGgdCXjZl//sjv81iXJ
	TYSFfL768DXF+4oVR2N4wta3UBx8j5M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806925;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z7iPpUiW3LrFM0W3XrB+Z82uodwKTsefoCzXwhLbLUo=;
	b=UonbbPABs/WAVZJ+kINp2q/lhGgM2bobix8GHDf7b+5l8wT6zS1EEwQKVIipjhp7kANz1G
	6qN0HXc1f3tA5YdI62e4WfebyfFYLgR0INJwDIY+GOce3ZnZNdU9OpuLKm5ORDZ9vPb7NW
	kx5CHPOcDKoq6F21zkgReSDFBMZc1Mw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-588-SAhQEVmkOqaVHIHQDYoHiQ-1; Thu, 21 Aug 2025 16:08:44 -0400
X-MC-Unique: SAhQEVmkOqaVHIHQDYoHiQ-1
X-Mimecast-MFC-AGG-ID: SAhQEVmkOqaVHIHQDYoHiQ_1755806923
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3b9e41037e6so864605f8f.1
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:08:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806923; x=1756411723;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z7iPpUiW3LrFM0W3XrB+Z82uodwKTsefoCzXwhLbLUo=;
        b=P6iK5yx1PksssJLozxOhO2YsSqvH5mIn/7WTLJsRYLyinXRJCXxnh9NSRkp4Q+QnCA
         211e6xCC6N3/Ymj9uy0+cpKSWgu9IVXrqikuMnIg3S0j66LUahtVFVyfadFI4UVjDX7N
         rtfYzh7+aviEuiDNcRLVkeYPK7HnQ5k3NIUW6lEH8OZB6Zrl96oUunhaG4Im/EAaLipX
         yDJlfs9XJJszE6e0n1DnUlJVNdaJuvUyrZL8e/HoCbkv33xvYdYTKtVxdCN/3bR3Xx7Z
         hOIa0aSCQTZlG5H07ipwvM6TLo2iPe3xoVuozHY6A9jQqsqgH59PO/HItDf/Xly/l5Xv
         AZ5g==
X-Forwarded-Encrypted: i=1; AJvYcCXJORTv/7t1yEWb6KYW43y/sV33cajbI1hqFxW+kWTyPy0Rigs+QGCXrb8KJ85VreM6jkXLtLL/ZA==@kvack.org
X-Gm-Message-State: AOJu0Yx66Mb8YOpn6fRNvVKyEIydETQIjQ4psUCeR+waaypN2xOSrmXt
	/UGD9p0JQHCWA8/PicqWISwgaH50Lo5xoKTniXB7nesXTfIxTMdONkfrKSWf8zaEjnOA3UX9zlG
	BkbxmmM0PADepUHiOYGNZdywNQbZaF3xW8Cik45imrjqRJaMVfQ84
X-Gm-Gg: ASbGncu5P6aQNTeG4tYpXYQpl/eTJdl/iUcB4CnLp+G0LYafbSc+knxn3zCNgbCpKGN
	3sfRdwfbh0LWxetDsuESwhVW5lWuGXy/JFlAEjuvrmsaitUkKK8QHNMpZ2Y6A47msrjJwr4jBHo
	ymYnqit3CGJd8Eyxz1vUcLD7EHzoZayBOK804bsZTt2LD0bscuNRqcrITsMfn/raSNkP43d6Y09
	bshl2P+2chvPb2KZsmWZo7I22Z8JVUorC0yG5DxCEgP7zu086ynn/gohcRSbEkJDiDe2ueoee0o
	5XEQ/mjGLKiVc0VqZIADWEOyohrloMa51eo2AFxu1batHFrQapCg+XIO6i4yyPGwqHlJC90F8TM
	wJoNip0Mk7zq/5H2q5505NQ==
X-Received: by 2002:a5d:64ed:0:b0:3b5:dafc:1525 with SMTP id ffacd0b85a97d-3c5dc7313famr204679f8f.33.1755806922953;
        Thu, 21 Aug 2025 13:08:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHnHzRKC08dohUKQD/XdldMc6IWYVddiLtTh8Yidep5vx+5++gzVG23SiimMwYZ+HldR36Zkg==
X-Received: by 2002:a5d:64ed:0:b0:3b5:dafc:1525 with SMTP id ffacd0b85a97d-3c5dc7313famr204645f8f.33.1755806922505;
        Thu, 21 Aug 2025 13:08:42 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b50e3a587sm10028205e9.18.2025.08.21.13.08.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:08:42 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>,
	Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org,
	iommu@lists.linux.dev,
	io-uring@vger.kernel.org,
	Jason Gunthorpe <jgg@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>,
	kasan-dev@googlegroups.com,
	kvm@vger.kernel.org,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com,
	linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	netdev@vger.kernel.org,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com,
	x86@kernel.org,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH RFC 34/35] block: update comment of "struct bio_vec" regarding nth_page()
Date: Thu, 21 Aug 2025 22:07:00 +0200
Message-ID: <20250821200701.1329277-35-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821200701.1329277-1-david@redhat.com>
References: <20250821200701.1329277-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bufAakMtFosVAquu9QvH63_-uPfeU_m6Ow0cbcr3NXs_1755806923
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: 3kxkq76j1unhf7axayy6e3mpi9ae663t
X-Rspam-User: 
X-Rspamd-Queue-Id: 6CCEE1C0003
X-Rspamd-Server: rspam05
X-HE-Tag: 1755806926-698799
X-HE-Meta: U2FsdGVkX1/v+w/pVpUjj9vlVKKi/82+WxCE/oYq1h+J5J/VltRdYmyyQzcM2ov9R47Ut4ML81Z0Z7h0rtQSvXwa1SXpNYEu8youFrrHEno2MsYVNuLsRcXEQ0pzyPnpXGTUiHembfgHPYj6QI39hB/GythCnq7qs1FPwDc8OZTDYGECrPK8l45WtpJiYb2sLZRsHlg9NRYFHyTwZ9i/fXeHCPAppzwdDw3nPR8u14Q9sKQdwmgHHfpogFQRsDLvCCGKyOI42yfpIWGuZvRYYpy366R6oIASGgnZ7u2Pmoiq16V02z9vbpsq/BlH4oMDmYLjRKBsdbx7jXvxiObgWx01vY08vSR+UvHQyeT+JhmmtBSMv6wz+ghovphnK/bjQHOFkKU4rXNoCjIIFr9YPpnxPrsusg4+Y5bwPwKOsuTyVsihWRB8gqfMCWSy1jtMYPU+UJhcahmBqYiRpWcB8Of0bjTI+voUvj7YKcf1TYKfD9V/TBZaud+e2Og8Qpg33ZGjDsoLUCb0q/SBgcx2gNxOY1Q3g1HF8CzNfvQInkhXq176dC61of5wTVdNevT8IUn+LYT8gCE1jVPEndqZxbeYqezlENnqRMXo/pAtUjRMHevcUj5HZIR3tTpUb2xG27BzqBr4tujsIsxUcVa8QQ8XJpvtf9DP/dCoKuxnT2xkJjW4AV04pIzLfK7cNHobkg7x4QRt5pq1PR0sOdSAsgHxd6fWa/7fHEmG/yXgjwGcqK57di1eA7QAPpvpnoehPcRBXvohHu9Dx7YubeEAyLCEzep7Exe5+EmgkTxmrmgH/2mBaODmjXbu/xX/DEWPofE9GWraFD/AOdw0J9julyb/yTZihYYGQYwZY2MHGbpbnWiDXDCKeZvMpIOBT+FmPYivOoUtP8GQ9EeVwxWia6yZql83Q4xceh3RAOL8ySOxSFNaVJU/34Fep/Yp0UfJF5YSWPC3vtOH1KpDKxE
 x0vMf2ZW
 Cj4p9tXEcNuep1tQidtRtjQqghsHppZ4AgfBeoqiGR8eONw9xMT3JSHzGq3hyht85C9qtaXnPQLgdsXy0wqY66KBGPgrczDQaUpAl5FdLhQhb63xdGMIddll7EpAIZjz4S/tnmEIZEuVPat4OzXpoBASNJqMOOkaGMztgAXWoEo+yNGiXhDPDh0yIJ5i+vDEyhzSOogw01m7SFE+Yqn3p83Pq+STdK9vZ+s/F9/IIF2lo3XKsv+5miYyNydQuuBNHcfESgvGHdqmc1Z/z1npslkfwhaVtxCZqRPM/AZwwPHxNpOO7Vxod5OqyYi9jCGN3EFOD04NAtUehgtU0UzG0vD2j7ZyU/NexbSQWcvMRayL9XoqCy00gTDiXuEipTQvfZKuK46R999tjiCENScQ+PYARnWjz87yQCiKtG50b7GQqySpKbh1fyP/pKPH5D4tfnqV/YLyKjCfXBrXBSjsIEMg5xoQIDExjHMbpiu7rZLnDAFgbkp4XDRYPRL17LWqVs2qymXRSjj01c7GUekl6SDmIROzq2N3BCrtqdSi9PD0ci2l0hFx/4mNMqA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ever since commit 858c708d9efb ("block: move the bi_size update out of
__bio_try_merge_page"), page_is_mergeable() no longer exists, and the
logic in bvec_try_merge_page() is now a simple page pointer
comparison.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/linux/bvec.h | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/include/linux/bvec.h b/include/linux/bvec.h
index 0a80e1f9aa201..3fc0efa0825b1 100644
--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -22,11 +22,8 @@ struct page;
  * @bv_len:    Number of bytes in the address range.
  * @bv_offset: Start of the address range relative to the start of @bv_page.
  *
- * The following holds for a bvec if n * PAGE_SIZE < bv_offset + bv_len:
- *
- *   nth_page(@bv_page, n) == @bv_page + n
- *
- * This holds because page_is_mergeable() checks the above property.
+ * All pages within a bio_vec starting from @bv_page are contiguous and
+ * can simply be iterated (see bvec_advance()).
  */
 struct bio_vec {
 	struct page	*bv_page;
-- 
2.50.1


