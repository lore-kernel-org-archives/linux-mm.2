Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C3F3F94CB3
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 22:01:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF9646B0098; Tue, 21 Apr 2026 18:01:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD0CE6B0099; Tue, 21 Apr 2026 18:01:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B44D6B009B; Tue, 21 Apr 2026 18:01:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6AB8F6B0098
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 18:01:42 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 218061613FF
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 22:01:42 +0000 (UTC)
X-FDA: 84683935644.26.49A8EA4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id D6C1840010
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 22:01:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=R1vDXOqu;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776808899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PFV0AQVcu3YAl0tYQcglaFwWX0QLOSqW8EZn+GtNSTo=;
	b=kPy1d9fyplPP4V8FHR1WqnKChpjww+5/OQgwL9SyZ6uTYqtE2eEQ2iuIP9TxLVPTb4vpLu
	Er7BRSQO/aes7AuX7fe764LMamlQX2TsmwHWmawbQF9yg76UC8xjBlTF729zkas88SFBlM
	wZS09njicPA/7GthKF7WSdeBVzTy/DY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=R1vDXOqu;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776808899; a=rsa-sha256;
	cv=none;
	b=kJyjvx/jl9hq1czgdA9QdcOpWywUrmPRBBJcGhZxZqOAZPzg+q1aUknbeeR1BbjK+KRm9c
	MqJEsfGky8kL4W8jpeAVvZLFhbO1RIIbfmOa2qBoO+3gQtP7u0FS1fHhKtWxKucMXCB4/d
	evfVTPHgIL2CVR9RAE6gMo6G5/uENck=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776808899;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PFV0AQVcu3YAl0tYQcglaFwWX0QLOSqW8EZn+GtNSTo=;
	b=R1vDXOquG6GxP3Py39kc1lnp7s+rbE28SOv9RLVRTyOPWSollQpMM0/GCs1/Kdmsr8rFhb
	i+d8L6t2mD/kZhjJ3yC7eavgh8Fwplbcjuy0shI+UMv9vpsijyGllkeDIuax7HJ5fLTJaP
	Mna9hwgvQT2rlsBO/SSGAPA3CwHXTt4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-637-PP3nfBkzMmCxAK5MRzdH4A-1; Tue, 21 Apr 2026 18:01:37 -0400
X-MC-Unique: PP3nfBkzMmCxAK5MRzdH4A-1
X-Mimecast-MFC-AGG-ID: PP3nfBkzMmCxAK5MRzdH4A_1776808896
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-4411a69f565so1982503f8f.2
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 15:01:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776808896; x=1777413696;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PFV0AQVcu3YAl0tYQcglaFwWX0QLOSqW8EZn+GtNSTo=;
        b=RNS41PPongYcVqbF2cCpmYKxM0FSQiL36EujDD5zlWwil3NCBmJfu+m+XaakGai/io
         Im2QLBngjvz051R13I1y+OL+Xe8tAsI9a/BkGjFkPf8mr+fI6mYXm0TwMRcT0niU+PK1
         KhKrHdN6qKDKIFa14Up2Eg0yGctvdFkAhmuaUm17ik2HpHWihC1lexiN9LGHAcC3z5+y
         b5mV5rASHg7er74ibmPYbyz6sG04Xz7LOjPqQrmSMw3c87NbBd7ODFKJuokzrYfLmlCT
         7qazh5tu+GjHCEsKOIAO/OAGxXb83jI3GyXPgwIyIwNkWZl1dkVArgrstk3iyLOA5Pa7
         tatg==
X-Forwarded-Encrypted: i=1; AFNElJ+azosDnMwKUevTxytFdnxXyjhD+8j8NytqZHjut7Fy/DY6ApNbPv9YYyXKC5ssXG/Abms3oacSrA==@kvack.org
X-Gm-Message-State: AOJu0Yw1SenOzpTlsGeyexGq4VeUv077UEY+YniQjic6HkrlkjYR7kT0
	JHPpoWocpnNMDjsP2pwDa39xdnEMHQjIskkpaCkt9i+SXM6k8fvFFMHM8l5DdOEb4m150aWBmK0
	Sj8kHXZl6K5BfL0hlLoiHUcS9XNJblU/rcRlDXLWLanetRDSg5ZBh
X-Gm-Gg: AeBDietnXEBxUdb+RSw6og/jkudWqXUGwuEuiegwRpmMNSpjGKayDAu+fyKakv2+3cc
	veFqFfsRGLScQF5IttX1KN9REXOQwVA6vgGTgrSojodjQMRTvY6HmxsuI+TiPW9YvPsFhgSRTQE
	nUaFyGgbk3g3CBwH8w26F/y+1Gfg8ai1FRCyyJ+ydWNUZSYylTJKxebiKZkMFq2w/OxCLt7TIR5
	ypxgV3SgltIV+p/Dx1cizlbux1bwQx0zVusix44WdvokA2eodwSs4rw1Cz2dEka650x7yp8iG2G
	3XMsY/fCrr1HxHZUtVWtMkfUUDMXn1+XOMFbHJbPRErgR8S+LpQr2pdbP3KPxElGqP6AyQ2qv1p
	iyZhNZv1d7TiYL8yUW1HhR/UdlcifQx2VufTj5Rxo171uWsuSuMDAHQ==
X-Received: by 2002:a05:6000:18a5:b0:43c:ff58:35c3 with SMTP id ffacd0b85a97d-43fe3dc818fmr31329456f8f.10.1776808896348;
        Tue, 21 Apr 2026 15:01:36 -0700 (PDT)
X-Received: by 2002:a05:6000:18a5:b0:43c:ff58:35c3 with SMTP id ffacd0b85a97d-43fe3dc818fmr31329402f8f.10.1776808895818;
        Tue, 21 Apr 2026 15:01:35 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4e3a174sm44697673f8f.18.2026.04.21.15.01.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 15:01:35 -0700 (PDT)
Date: Tue, 21 Apr 2026 18:01:32 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH RFC v3 07/19] mm: use __GFP_ZERO in vma_alloc_anon_folio_pmd
Message-ID: <028a9602232ce76e2b207f730982ad3135897bc3.1776808210.git.mst@redhat.com>
References: <cover.1776808209.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1776808209.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: lCXjC2yX-oIRewL_goGuf4YMQoh2UCJs8ZUl3w-cNGk_1776808896
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D6C1840010
X-Stat-Signature: fuzj98xdkn7phewfcwgcfwuhg5e591zg
X-Rspam-User: 
X-HE-Tag: 1776808899-471744
X-HE-Meta: U2FsdGVkX1/7uvoHgmQ68gVA/gdJbxNV1udRp3FEaxJvR0tqxtR7bFJaJIyEAnxWwblOgxzphj9ag/1womoaaOrChAp6BCMnQuDoAUwBI8JNC2r5s+bpyG5CXgEOB2176i7GZfgSTuHMXXzvH0VUt9K4qCzBuAOD9Le/WO9qfJpBBdHSUp3N8Edbt09Om7xInAqgXzQVdbLxo96WJaHNBqQd+xsaWYDxsy5mYfN3/bNua7AbP/HFOqcgUM4QPdUS0iON3ugtS+20DtTD+gdVUxBu2CVKm9aMFKHmfShjbMW94H0Nt52KNd++XTHQDkWBtb7YRHvQd7PGfoRnycwNUYcCLpaRelVoofmQe/vclW0NqR9ZhqALLtRK5Co7L2yR6l/eHMDUErbcyqzBis8Q/z/kx/CxYYPdPYDlRwy/jfUKpj7NYG9AVzW179jSo+PISJzcRou5OPE797z95PhuqNVcXjPJWSkmllD4V7NIBMKi0J79qchNWzMg+r/BVlxL3BgmLWjgqn+4jS20RGr1sYGpNBNs/9gCOHWMzqtMVuNpzije0h9nTLU17AGBZppB+0tkcT0jnquqY2T5cFiI+o3f3L9Nl+VPjC83hbuPywBZ9GVFMydHw1doCAJ1G/mrjo4Qz23NDS9OfivEG0J+K1XVoYj4ngxvBAgsa4B/zGtH/Zd6TkvG/A/KqNDvsvPJSU0NcRIbdaHOMvSRf/z9hAuNtBYKBkBWIrXjQXESwnx1L5xkxf6tUGtJ6PN4XwNlF3QHQVALp3zeEzyMAJY6ePNk344NiLakE/ZEUWYIOKNUNXRk7i8CqC5Ot33w/QzdmQXgc+N3/f0i7aOBb5/NX5Q85rsiorENbo6l769S3xcyhLXtS+gMMfzH0HybnKW3yPagvMO8kOBqm3jTP3NnbNjLQd1zQQAJRhfzvg1/v2C8+UDO8OTA3TTg9GWuAwQMCl0ZMwWAfkrb1E2iwGM
 aFCf/SwA
 5cYMhJFelAQuTZfL4TTVWTO+ZmEORBld5xdqOgdsrll0gy7j90ASU7EGXsazDUkFAnlrGWfpC+T7T5gkzYiaRM2Obn8mREvnP7tTrTT87hepfRvniIttNVa8D20gVF9DZcQ9navIK9/EknkDJOuK+ixCkIGNiuDIQL+2BtG8QkFhxFyorEUJuw11oh1z9pVuS+nMuuoI3zbROwm9vgGp7tWJNaF/VBwYZgQ2waH1sVB9cBGEvjClzgE3ajNjqCIrnm94YAsTSfRO32/zfhOt5ijkE/pCoIY42vOV63lDNhcPrguxTkQBTRevTeWAl3ArQ/y+hIG3wQs5Z/SPDoygLLggzafp3KPHVUS7ryyCQpE9X55kq0BR/YKWwYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert vma_alloc_anon_folio_pmd() to pass __GFP_ZERO instead of
zeroing at the callsite.

Pass the exact fault address (not PMD-aligned) to vma_alloc_folio()
to ensure the cache locality optimization in folio_zero_user()
works correctly.  The NUMA interleave index computation already
shifts by PAGE_SHIFT + order, so the unmasked address gives the
same result.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 mm/huge_memory.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 8e2746ea74ad..3f2a868cf9e9 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1256,11 +1256,11 @@ EXPORT_SYMBOL_GPL(thp_get_unmapped_area);
 static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
 		unsigned long addr)
 {
-	gfp_t gfp = vma_thp_gfp_mask(vma);
+	gfp_t gfp = vma_thp_gfp_mask(vma) | __GFP_ZERO;
 	const int order = HPAGE_PMD_ORDER;
 	struct folio *folio;
 
-	folio = vma_alloc_folio(gfp, order, vma, addr & HPAGE_PMD_MASK);
+	folio = vma_alloc_folio(gfp, order, vma, addr);
 
 	if (unlikely(!folio)) {
 		count_vm_event(THP_FAULT_FALLBACK);
@@ -1279,14 +1279,6 @@ static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
 	}
 	folio_throttle_swaprate(folio, gfp);
 
-       /*
-	* When a folio is not zeroed during allocation (__GFP_ZERO not used)
-	* or user folios require special handling, folio_zero_user() is used to
-	* make sure that the page corresponding to the faulting address will be
-	* hot in the cache after zeroing.
-	*/
-	if (user_alloc_needs_zeroing())
-		folio_zero_user(folio, addr);
 	/*
 	 * The memory barrier inside __folio_mark_uptodate makes sure that
 	 * folio_zero_user writes become visible before the set_pmd_at()
-- 
MST


