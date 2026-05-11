Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 138FCCD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 09:02:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57F556B00DD; Mon, 11 May 2026 05:02:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 557096B00DE; Mon, 11 May 2026 05:02:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46D066B00DF; Mon, 11 May 2026 05:02:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 345406B00DD
	for <linux-mm@kvack.org>; Mon, 11 May 2026 05:02:46 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 007161A037C
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:02:46 +0000 (UTC)
X-FDA: 84754548690.13.8879A93
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id C701F180010
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:02:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SGJ4CaB+;
	spf=pass (imf16.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778490163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PyhJPD76XSlXOLIxrgX26vlRXB2m99TPkgzm+4tnrhY=;
	b=VN3b11dl7eW9kjocLcLAzP/YJd2W++ceJwI3egFM6U6MTphM4iWjYjYbMmvBb3emhyGIQI
	Gu6kXQoezEq0kyinMa7M5ttrONYmVtyvd5dwCIzpGtYXZ5GL1FLM0Dac2xszbVLtuY9jSD
	DN1byRs8wDc4HLFEBYyHoBRKll68c0o=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SGJ4CaB+;
	spf=pass (imf16.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778490163; a=rsa-sha256;
	cv=none;
	b=VgUwAC6DyTTzF57vQf33EUi9jTlQmhL1qgPdZ1TO7xtDOJJGGAZm/UUby8gzvwWLLLKdn1
	e8GL+4ScwYeZ5/7ndkP91bxEkshvIJsog1PzS27wIEbvNz995TO17OiHm9/Uy23XYU+sj/
	ggt7NVD4mouRLJumzsLYn3rsvajaAsg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778490163;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PyhJPD76XSlXOLIxrgX26vlRXB2m99TPkgzm+4tnrhY=;
	b=SGJ4CaB+Iq8XxVixOV1kCOvGAAJSd667Sru8U6ED6bEoGcl+PQM2uD7QkQaZB8fb7/85zt
	TizuSqDJR0beOomwMFDVAP7LTAnTcChL7tbb27CoTgePY1Q92iR+6UtMzeKAqV1Q6c36Fs
	Av9Yl7yswLLTMiWV+k9q1mipQVxXEpk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-683-MMmciT12MqODvL6gORRabw-1; Mon, 11 May 2026 05:02:42 -0400
X-MC-Unique: MMmciT12MqODvL6gORRabw-1
X-Mimecast-MFC-AGG-ID: MMmciT12MqODvL6gORRabw_1778490161
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-48a7994e8ddso26343085e9.0
        for <linux-mm@kvack.org>; Mon, 11 May 2026 02:02:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778490160; x=1779094960;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PyhJPD76XSlXOLIxrgX26vlRXB2m99TPkgzm+4tnrhY=;
        b=chd6wlnOq7eS2nS/5HJz8NX9nj5EIfNv5Cul/tEcL6t/9cJAavGb/NJPTojy+0KQKf
         4o6NNIYyIQxdcoyOpuVkyWbAj/yrY99Xpi2RVnOHpldoeUCSybR1pce9+lxxccm0vOZv
         3dmWOB1uCcI+yPQ2DwmXAaHGAXcUKPzX6alMlx6P33Zn1uYjYUdDNTiqBQXVh52fPgki
         6EEvwMOfc6nODbaF9XxtJrEs5nFaupLyY0vYn12NkaUmMaVTJN346iDorh4x5v3vNoQt
         KtFAfwvGHUKuveZecqianjjfJQv7HgybgXCJnA7OoLfWnI1UE8VhUHm7LsZRb6kM+4pN
         D5YA==
X-Forwarded-Encrypted: i=1; AFNElJ8zLE+1c9oP8bJnMwjgejVw3vusxAbtyx/kWGYSR6IVdxbgCkNo5GjvPnq+zzw2HYEFN+SPQoYdEQ==@kvack.org
X-Gm-Message-State: AOJu0YwD82N8nzOoZjvkXZ+/P4IgstTccamiUGxo8SsQSgOviSJJH17L
	JWR/m/trsvSldqS4Np/AjQnZIOfn8hMzDQEb/Fe3uNi64hFzLBpMjiUfFuQ+mJmfbQRdVe0vG3P
	E+R0iwuETMjI/Hc5krhM6FK7e/brWE2FLrhk2GB1+dhc/g1H6M/l/
X-Gm-Gg: Acq92OHEw8Y6gzs+YijKsXLqEgqrG8AdFXUEiR3fsVO+GhaN1dGLe0uG21a0f8yaIV6
	XsPMiJR4KcUApsz+qtM0k16eL5TvVqzpKMo+9uZw+dtorQ4ATIaHIIxsKdNNy4pChsZEvlSbCR4
	FtZV3lrYbqZwJKaPJcOPmU5lAGWZBpQgmeK8v8fsPUQ5YYays8wlZGG5vR2fI7Tax/2V+aQXY5T
	bKdpIYrkK9nofGGv6NCNfH08kSGgXw3ec8dgbvYvO58qtKnUsopatgSi6b6i3JQB6NMstnnA/La
	SJPhGVWK4WprN9ykqCQwF+KDLo02Ij5YBbZg4q7ul/fIgqzvY92J01jdVSWF6UXrcliwv1GR6B0
	JLLyLJuBQXDXfmHu7VUzr+O7l4QMszSSIXj/Kaves
X-Received: by 2002:a05:600c:628b:b0:48a:557e:6b4f with SMTP id 5b1f17b1804b1-48e706cd77dmr153153255e9.23.1778490159963;
        Mon, 11 May 2026 02:02:39 -0700 (PDT)
X-Received: by 2002:a05:600c:628b:b0:48a:557e:6b4f with SMTP id 5b1f17b1804b1-48e706cd77dmr153152205e9.23.1778490159368;
        Mon, 11 May 2026 02:02:39 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e702e5516sm264424385e9.7.2026.05.11.02.02.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 02:02:37 -0700 (PDT)
Date: Mon, 11 May 2026 05:02:32 -0400
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
Subject: [PATCH resend v6 09/30] mm: alloc_anon_folio: pass raw fault address
 to vma_alloc_folio
Message-ID: <96bbd5dcc37aed93a9b7733780bdcba4fdacfa3d.1778489843.git.mst@redhat.com>
References: <cover.1778489843.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778489843.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: E46j9C4qSafaX1TrrYlQ3HPlZ-CepfsTHEqnxI1XWt4_1778490161
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C701F180010
X-Stat-Signature: noafktq7bh7w9qmky1phnxbczfxcddsm
X-HE-Tag: 1778490163-115083
X-HE-Meta: U2FsdGVkX18B9SU02KRLf1LtyyI1S35x/39YFh1hgoZRwGullUDUPuHxfFIccf8fyRIdvvMbD6F7PqouKRCq76G4E4GdSjK3c8h9Cgg9t3YCU+8Zm50YVFdmG0d6z3i++9y/f4xL9TJoMCzr14+RiDxMwst4Pi9ACvfq8RUYKa/9f9SjvZiYU/0Kb/ghs4/vPIQTwH8Nk9zyCHl35inaMHojI04iUBVk/TkemlW0xsfslfAVX0Tc1ihcdLt+I6/7MJ75gNpfrMV5sZR3w/zPW3E2tbibtYtHSCruqFsVlS2NyCIv+MK+g4tJUmCK/TRw5Rncago/k+obswLz7JAgBh6QRvdye3bqs5GPOxcvlvXIV/X2DpG4yC1VrX/acZUcNzheNl2xDjVODm5dtwda4McQhEAeWgZGnctA2bZ79E5hVrQW3hfCKdMdEleEW3ZnD1Sq2OMkgofC+Oxc0e64ALBavoeAOaF66Ac7pzxN1OognkLUCSYBH43LdE2shJLe2f+1zR2DxWPX77U9LT2dTT9EvkR9HcUe8YnKdlBzEFm/NBSeWhPH3wHfK677jnmeqysMq3Sd8DlEae7yzBm9kror3PejUbi+dpWshYr3zrXyPrWIaOWabxMZycsHbsxFczHIisgaeBxsMG0UC/9hK+GJ8qSPQyyc/ONzoLkD8Zko9fXl6gKyvgJKm5do8h19UD4UNrhy4gAsEqtLawtwW3WjeadQMv43YQqkZlOceB/woMQQ9d+bag4xAGhkQWaxxo+I87tDNeRIkmrX984usJPgQcozG9tCJZOAdhbBgip3urb8IZbBa5jrcakqMaVBCJnoSbceYuQNcQXs404SILakH65XzVqO5/hlgBOirdAx4nlB/gKPIDTdsRX8DAgUQakPIUYSwpxI8dv1u1Kr+p53vW2ZWYW6LKh2TsP/yk82m6VMrFnin7XarCj7uh/HozK0yZdHWxYRJTJD8WW
 sn+5oc3O
 53Ubn570Ei75UE2AfD9hMGXlES6KK59fI0yqdsEDITNFykNYcrnK0c9hwzM/et5chU1lHc0Qdf2r6ojWZGHEIwLP/qlb14CdrkMdN4C8RS6zV+VNotEhyux+vuzslXTF2hpfW7WPxdiub4yYfF45Roeao1tqZuLkqNrNYSOEeUUecBZpKFfjeTmPqRQw5WYA8g1zrmDnAMYWTluw98LHZPE2OUozf9DnuIZ4PvK3RT/XPFMVzDRvXyZU10zUlQlyr7hNJOBO/gAxeqCLppRokCeVVXPCNINHHwHAj7JaLT56klJgPsMlDL2Szg7Vm3pSU1f6LvcEDcrMEbTQRf5ZaYQfxUcbayoz7e7R95yGCVgeiuriL4UyWu0le5HbeM04SKygUDtuzD/HUgebYAUeU1fG783j8thr/UfrWMobJjS/MKbithVrCL3IBX7IyluQrGiR/dAMhEXe3/9V3PkvD3CDLO5pTKG2RKTlW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pass vmf->address directly instead of ALIGN_DOWN(vmf->address, ...).
vma_alloc_folio_noprof now aligns internally for NUMA interleave,
and post_alloc_hook will use the raw address for cache-friendly
zeroing via folio_zero_user().

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 mm/memory.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index ea6568571131..0824441a6ba1 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5252,8 +5252,7 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
 	/* Try allocating the highest of the remaining orders. */
 	gfp = vma_thp_gfp_mask(vma);
 	while (orders) {
-		addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
-		folio = vma_alloc_folio(gfp, order, vma, addr);
+		folio = vma_alloc_folio(gfp, order, vma, vmf->address);
 		if (folio) {
 			if (mem_cgroup_charge(folio, vma->vm_mm, gfp)) {
 				count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
-- 
MST


