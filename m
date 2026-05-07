Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46B73CD37AA
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 22:23:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2E096B00C4; Thu,  7 May 2026 18:23:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDEBC6B00C6; Thu,  7 May 2026 18:23:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA7826B00C7; Thu,  7 May 2026 18:23:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C1FC26B00C4
	for <linux-mm@kvack.org>; Thu,  7 May 2026 18:23:01 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6117DA0649
	for <linux-mm@kvack.org>; Thu,  7 May 2026 22:23:01 +0000 (UTC)
X-FDA: 84742050162.22.CB76389
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 40F9540005
	for <linux-mm@kvack.org>; Thu,  7 May 2026 22:22:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NX0e0Wrl;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778192579; a=rsa-sha256;
	cv=none;
	b=hekBrd9ahOIr7M9hE0B51VWmNriatW1tNFcBNKZqSnCCjjiWE+PffMN7EFIb947W3+q1rN
	X1NOL8sLSonCmzApswbGXIJc+4XtFmWqITBBzpyG22vnBzBGqvLqP7TWAbupJ8L0cCm+zT
	lPwmUznwerNg26Ri7D4U8xkaUd5HQ3E=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NX0e0Wrl;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778192579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C0iJX4IreXsyXpLqNVxKVCvdOAtYgnPhF7cVJs4Qyr8=;
	b=RFOmUhgKfYBSKbycYUvdVrcokR17DwvFsJehaoiXqiMa+6gYnlmO5/lU3Fq2xRMhhhh/sL
	UP+swMESogS668QE7XIP26P8o8760ILfriZia1XbVYCppJov84SM+Nd5xvIg+l0n5jkfTP
	BzGyd1oqDFfFA/Hfzc2+EeXKOY/nYPg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778192578;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C0iJX4IreXsyXpLqNVxKVCvdOAtYgnPhF7cVJs4Qyr8=;
	b=NX0e0Wrld8khH/eqcpV2SG2m4Fmb6W7ROSzA51q28at83tRiDXxW3PbmSKS/FFXp0PAXiF
	jzS55f2GuT4w0Shb7UR79QBV1/J3GLIqh/fMctaHnDX8HhaUn1d2Lo0VlwvwetEQs2elGi
	NtWoj5gXNGN1Abv1bsl2fAdGux031lY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-613-isODRPbxOWSR7EoyjZXsjA-1; Thu, 07 May 2026 18:22:57 -0400
X-MC-Unique: isODRPbxOWSR7EoyjZXsjA-1
X-Mimecast-MFC-AGG-ID: isODRPbxOWSR7EoyjZXsjA_1778192576
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-44ffa15dc73so1176517f8f.1
        for <linux-mm@kvack.org>; Thu, 07 May 2026 15:22:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778192576; x=1778797376;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C0iJX4IreXsyXpLqNVxKVCvdOAtYgnPhF7cVJs4Qyr8=;
        b=emC6chTgWxgv1kJDDjk7hllp9Bhv61ReK5fPvuRcX1A5JbStZJYw8jMW02NKUy2FT1
         VRzOcTIdUJHsh/lnDvWymO6leSI90As3PKFVtVk31dBDFTZ7QNkIWI6FxfteSCbZRvxz
         koovhEIL844JCGvt4prOoV5uVSeudIc+M3jsFq7fo8KJlHfBdlMpwUy5CfAct3ddKuWp
         Poi46jnEfWLb1FQ1xJWrVFfEK+J6aAMFPJko7rvOCmV6Tf5yv+q4Bw199zaCA+R3QjHx
         Rucat1WPEK1hX6mH3Oq0YbXob3N1bjVLKX7KS2XUEr+FoTodfpJdST0cPgohxx9Rym7g
         xf5g==
X-Forwarded-Encrypted: i=1; AFNElJ+vVRN7RFqxs5iABNO6A+CWVLa0ave1lTBz1Y3JUN4QBVIajXjSnNspiYz1EEWuvZR6KztkhkXUYQ==@kvack.org
X-Gm-Message-State: AOJu0Yx4FEdZdok/vCqPg9rGhtPR95saNEPJb1NuidJWcv+5fxF5Z2YT
	lcdWYSJHSFoMB8+LGueOgAMdnDnHdZBMYEI4E209YxncGhh13gmVZwgGpeZLbEet4Ov+W1EdqKa
	89v6nQgkq+D/ZBM9SIfzde4naGeib+vO+2TwE5SXXbOSUyeQq9XTO
X-Gm-Gg: AeBDietDX97RMdKkdrO05BM12lq3BWrRKZrOcNMTcMRj7Pi2l3ipwPnUC1wz8y5sUpF
	6Ww7aVl4YvVipPp/nfWbjyj7bvXI3iwRTTayzsL+l9eP+R7BcDZvAl4aHq62wvtsXgkTt62TLkK
	aORre7X2dbufSZ2NbECSyUk3HsnWI3XKadvaTajodvQsMh0gmsYtAqMhQ5lgxKtcQVgIOtyL/rP
	UY2Z31CyYh58pnhUt0qvZxuxp5Ihb5wSB/kGt7/MQS5Ms3CfBZ+0laBv1/nwzcJsvpbBLW3aXqf
	3kYVVVccmWIMC8dHxAJ0rxeAKtvKH6nywxOf1vWAx7JIajn2pW+64iQ32+lY3gow7TDWKKkgS3V
	RrNboVMDj7nLAiP8roVg/FpuE0sgt95Mrdn6mrJxv
X-Received: by 2002:a05:600c:35d2:b0:487:4eb:d125 with SMTP id 5b1f17b1804b1-48e51e15589mr167969275e9.9.1778192576194;
        Thu, 07 May 2026 15:22:56 -0700 (PDT)
X-Received: by 2002:a05:600c:35d2:b0:487:4eb:d125 with SMTP id 5b1f17b1804b1-48e51e15589mr167968925e9.9.1778192575750;
        Thu, 07 May 2026 15:22:55 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-454131bcee3sm2024100f8f.15.2026.05.07.15.22.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 15:22:55 -0700 (PDT)
Date: Thu, 7 May 2026 18:22:53 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org
Subject: [PATCH v5 09/28] mm: vma_alloc_anon_folio_pmd: pass raw fault
 address to vma_alloc_folio
Message-ID: <96a2f5a938bf65315ac95e75b4e7741bae018cdd.1778192416.git.mst@redhat.com>
References: <cover.1778192416.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778192416.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: d5whezLoWezip-sdexTwJOe8-j2lyM3BiYB_ulct93k_1778192576
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: 17j7wjjuyupgjjdk9ad7enh77woc31ip
X-Rspam-User: 
X-Rspamd-Queue-Id: 40F9540005
X-Rspamd-Server: rspam07
X-HE-Tag: 1778192579-628843
X-HE-Meta: U2FsdGVkX1+xo6QQBacu+8W1hccajuw7Ro4LEXNI2cJPV1Xpjy98HX8mpN67KQbdEe96llN41tWg4zUXZq6RQmcKjwtgPuRwkHn43setpV91Q0Bbtv2dhUOTBtDZRXFN28BTP51zVknbTn8D0QsW6UMoEiSMy1ul9e/1uorF6ve0JamiRWHWj8gJf9UYN3/ttIJMJajR5JhBrBon+HMQw/aQlgPK2UTwvaSmzwudoS2W4jNPpUakpoxswTjHrvhwgZ4ipoC4gjSVffJF6+HkyLnc+MowAWgF+jWJCFLOcki790zhyx18kgph0us3ZbvsJHpY4pU1U4dBkWA4V1+ohpUeHfkkD8Yy8jA4LuiIebtUAjvk1Z8HY4DhVqQlT/R5A0wCzdTZpwB775O/q9ohpfvbGH+pwh0YnDJcQ9XwRJR8L8I29y//l+qeYEGNelJDZ87uLriuTXDzyZfmidkDKfCwtg05tiK4JR9Bl4K8jdcC1RXEn1gRxyqB4swmS0ZnvLJvuZWZsPtPkj0FftaoLFe6x64qFfkdZY89z/iZAKXybw2ON+DYWdk/dO07ippmOBGow+0mH4Ol8ve7oZFs+hamvatSvc1G77OBouYXL9BNZBAY5vS9tSlpOqrrI207JmVsBZZGPCWm3VB5MFrFn9MjP9waht3LUoIckBVjZXAcbtsgesp4Gb/rQeLtJONkl4OgJ/DC0ch/nbp6lGE+oA08uqN/TnRhPsFE4t3oyz3+VF3+tmx/EWmY3CqbwoeWsV2Ga/MB6ofn59t32xxmvLXI8MDhY2RKV7rIU8Bbv1Cq2EF5sNX2r1X3z6C6lgwJ4Ov10yMpWc9Jl5J0fhfd0Oeahdp8CHunRCt+eBv5pKcWRZdv9cYeX9cDwEQmX51NAADfCpdTOAHG7gi81exZ9PDQAk/uXbTyX39oRIRoCn2++WcW3LjNv+1Al1gIzpxXxT7A47L06Bw5JtHTf/D
 FmdLHys1
 cXjKy5aupWte/7tP/C8+XUTTpuo5mDcODMzpcnhlP6lAnBHHVRbunOZkOLYxRkGTiNNSp/AqUYcRJceMfkvPddYBRgvF2S0Dpj096M1VynVaLb6GpsTm6nqoxDt3k05ULnjq26B2n+KprxPugnvDnChFd23mevlJaE7u3QB6BYi64E0HVEPvnw9PMyFR0bQvE6c5jFqRCOT4Z2vWwidJTReCf4DDy6gLcyuZNPGSeltj7kEAN3ZOZUI/zIY/b6XryY+jS23iNuvUILWMlykZ3qdLYUM4aTKfX5upunXA9KW7eud6kHzLvk8TiVD+afjSHsjrW0fFQTS/AcuMUjVikOcveMY0VLT5JZgnBVniPcz7iFo9imCb+qzEkwg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that vma_alloc_folio aligns the address internally, drop the
redundant HPAGE_PMD_MASK alignment at the callsite.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 mm/huge_memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 8e2746ea74ad..f51c0841ce91 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1260,7 +1260,7 @@ static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
 	const int order = HPAGE_PMD_ORDER;
 	struct folio *folio;
 
-	folio = vma_alloc_folio(gfp, order, vma, addr & HPAGE_PMD_MASK);
+	folio = vma_alloc_folio(gfp, order, vma, addr);
 
 	if (unlikely(!folio)) {
 		count_vm_event(THP_FAULT_FALLBACK);
-- 
MST


