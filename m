Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96B6AF94CB5
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 22:01:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E83DE6B0095; Tue, 21 Apr 2026 18:01:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C601C6B0096; Tue, 21 Apr 2026 18:01:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83A0D6B0098; Tue, 21 Apr 2026 18:01:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 59EF36B0095
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 18:01:35 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 03787BE921
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 22:01:34 +0000 (UTC)
X-FDA: 84683935350.07.44A962C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id C59BD1C0016
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 22:01:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Aq7IMNGd;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776808892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jpAQ9O1oMgUNlo5ukg9OEno1SM1k+70VK2/jH7/8vVM=;
	b=rlKxfZF62H0k68EGPZBCYg8v9JcHnfWRR9jDAmRLdFaIFhpNHXEOOGlJyasxXU6dMfR44O
	pmImc7nC35H/hBlOom5UgegTyEotzL68D2GA062qglRMF9T3WNvnDY0q6tPW2RZJWvMsoR
	f8ws/oQdwzeUb74KMuExVfqVht16/zw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Aq7IMNGd;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776808892; a=rsa-sha256;
	cv=none;
	b=LgUnbvw0J3GIYYaX83gkwRSJWXMhkNmWcWRTrG7+kzH3mG+Y5L8oNnGti4CTGdlrF+lSX1
	Ay2hc4HzQXQCCxkQ7DqpbeHaP2mhcdsHZj3KpXbeXL8FM+/IISQmqlA3Fk1DVzMnID7BMF
	IDTrmn1Ok8Wdbbtc5OrkGQmJ9UO6rlU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776808892;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jpAQ9O1oMgUNlo5ukg9OEno1SM1k+70VK2/jH7/8vVM=;
	b=Aq7IMNGdy+vcFdysvnN7cwn345HFShyusYwTAF8UzGdv0/BkSTUI0cwxDI9BIWWOiU8kOF
	aCEILSvOlmzq5NgHrGt6kpNGZzCdA2dfw+/Fn/mTEbA1f2Q3t3n0OOBiXXBJSE8Agvd5hf
	Y37AqHmFMI3O5yJtZStxAAUl+rxt6vM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-635-pvo31ELeNNCWf0RMxoDy4g-1; Tue, 21 Apr 2026 18:01:30 -0400
X-MC-Unique: pvo31ELeNNCWf0RMxoDy4g-1
X-Mimecast-MFC-AGG-ID: pvo31ELeNNCWf0RMxoDy4g_1776808890
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-48a55ecc32cso9148315e9.1
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 15:01:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776808889; x=1777413689;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jpAQ9O1oMgUNlo5ukg9OEno1SM1k+70VK2/jH7/8vVM=;
        b=GgUzySfP1boHMWc28LW2Y1267dmEfAUKh1YrQURYXTcmvR1UBn7UPbeSffQn18wjjE
         MbAhYD3NifupVQKNSxD8s2pkeIgqNFSqq3ddX7U7129WsJitHfFE7gcIi/Y7n7Ftr+DE
         AM5zzBdcVzx/NIWOWONzasNWUrnp4bWmsafBwgaK5rVkFLsNFdPkMydiR/IC+PEYr6GJ
         T6huGQhmLW75HIl+mx3taTfYtad+BoIVh+K6PJ1CtWfkAxHQuKu/r77kQhsWbO/V+7MT
         VBcnwKV2b+1GtjKPjONxXp+VANnuqioJjPuakHy1CjdkJ/Z9tdI+BN8xx3pSHxyOvick
         GDWQ==
X-Forwarded-Encrypted: i=1; AFNElJ++YmPJGuHh4VSva4YiOBOLDpcsR5H1j79t/7YWKh+hfTn5xIaCREOdR8x8sOtva7t7tqThMhv6NQ==@kvack.org
X-Gm-Message-State: AOJu0YwWGAvI6O804RNKcVURtlFtT3tR+HWwnGg/Yp4tfd1fH+lpA5ay
	TfRWueHMkNBJ/zfbA3i5cG1TdzkzBEjWInX9aDLO+6ihKZTpvsagiq4HqEW9JC2vRTlWnlkf0En
	GHzv1L985inTodBOhfv0kPdkTsdcCBdnjMFsWrBqcef48ADXJYJDc
X-Gm-Gg: AeBDievTb4CKw0rlpxVqAbuBCy4bKsIzF96XyP46hUqV2f67cs7mi0Rgm932onebvvh
	4G+fXArepFfRrsq6J/JffRiyfFFqOII2m2ndTU2j1vVSRwe5rJ0j+vnFAQ0iqgp6P0EkdY0ltR3
	iEz3b7PP2OFeOJ9T2TiOTqns3O+QAkwoK02EqZ+WQn0GHNNCyfNVYvNi4vMRuBFMd6yvngP9hrY
	yvX6x7yPB2atY5nLs0Oi9gdT19Qbb5Gu92IF3BfmT64TQ0d7RPu0BDCy/ExSQ5XUKoe/432HVD5
	BH4wrxfWs1WclP+A4xr3i64XJZJvcDJMc6qNGeA9wE3qXXQAhQMGvWjIJo+aZCZ47l+bIXs/Q5B
	wdfcTc1sBHp5Z8LAGcpR3SaqhUryyM/EecjwiMgPXXX8ILmJwdaiRjw==
X-Received: by 2002:a05:600c:c10e:b0:488:8185:e672 with SMTP id 5b1f17b1804b1-488fb792e84mr214398205e9.30.1776808889502;
        Tue, 21 Apr 2026 15:01:29 -0700 (PDT)
X-Received: by 2002:a05:600c:c10e:b0:488:8185:e672 with SMTP id 5b1f17b1804b1-488fb792e84mr214397765e9.30.1776808889047;
        Tue, 21 Apr 2026 15:01:29 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fc0f8193sm361461265e9.1.2026.04.21.15.01.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 15:01:28 -0700 (PDT)
Date: Tue, 21 Apr 2026 18:01:26 -0400
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
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>
Subject: [PATCH RFC v3 05/19] mm: use __GFP_ZERO in
 vma_alloc_zeroed_movable_folio
Message-ID: <f6b439191a5aff5f93cd11c00a388b5ff7261220.1776808210.git.mst@redhat.com>
References: <cover.1776808209.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1776808209.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: vSDhklne7hnfJGLFJrU86gLCQCn-ZUt8M3QecmR4utg_1776808890
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C59BD1C0016
X-Stat-Signature: manzz5zm4d5knnfwmtwkxgabi5cnfmmr
X-Rspam-User: 
X-HE-Tag: 1776808892-778536
X-HE-Meta: U2FsdGVkX1+evxMwP/JSx+lPp0NzEkWoSR7ufWUpDg4GjuY5jsicrtwTyqQ+i5oEhN8jCLhvq/z4QtKJi9CzcROmKYk0RiRi/ki/MagJFCFVFFeksU7/6bXDivUV2UQ5cSu629rauS2ub9iI5dHUCcuCSfpGtPl1VgKEpEnlS/k57b+RIjL5B+GmZ52YVCwbU4vpWUZCbfhikmTIdCbfd5/bO2MMeNXWlddmmzxOksLI4wF9o8HdVeQvbjeVhs1AcKJN1zs2RLUoI+3oV7fltl7B6NqkZYB1mJ2W2j9mcVLnoEXuejHhxkQn/btnhuOavKssMcZUlQzGR1PGp0QgItmVMEBAjI5/biMUo1mADzKUpGcUbmCUnmvd45Jynn0vnZkMZXBCn4qrU1H7pwlHfANJohMuNEfX/aDN1/1hvK5tLpKbgdlTnM6Ko3AJxl9dX+qHZqyx99V4Vwd7edXd54foOE6nrKjCuMlzia6F9YtKSzLHgfFWXJp9IHrEN/rqHoGhY6+xOdrQKi0Ywhe9mluy3963qqtcqSpqWAFUcYJx+3gRcb8NnJFEetheQdq8Q1oYDwr0aFNZ1PExUovsCyKYWq9pjUZaF7Zjmcx1LIRxKmL+yR8feUnS4Wkcjbf2w0RwzjzC1VA4z/o8lyl3gi0BTJ5+F2SzEVF+WYTEhJwiacgqaQxLBSFUSjuoy6ARYk3gkcJ1UrcuZBCQZtIFfIIYR/k/MeFcqI20X4l8F43GdlbTKLpYl53ELZj8NuY/iEMw+H5m85+IbRXLv6OO4NzeTytirjczJLGi+wY5yEsfupbD4wp7fI4RkMNLwHtSGdKAeydxUNQsMeIayPI5iLem8LO6X2mdr0DW+10OGM3WA4togR/ctSOVMdNJdPTnHwMAjeC5Hee7dYtnl1zbvZ3Z0fFiocFE/sj5tnSUpFyTu5Nj1GNSOpBX/lF3rgo0hH8vC7vR54Ow/epC85I
 EMwz5dDA
 xBa6GLolwttTYFOYG5O4v1jxAl38uwcyt4r+Dz9L2piqxbn8KBTHApFCdl2XvaCbGGFzg0Kw0WE+LSuozY1rqhJf/KQkpc+/dt0PtXexvAarapeiiTOV8D33KFbxRWkUX1rzwORxIGMsYyMaDH3Pn4+6Ofb+eKZm2db/SY8KgMk+1jzTpNpUI8QpEQI2pu0iYIJgclz05LbOj9mmFNcPoDiFju9dzXr+vyjM2rrlwFHUX1Tr3YtYcaC7TIzbtRQSedlnYZ4m+2W6PvEHr58pkUsoIGqpIT9nqt1UhhFawtIlEnSLXy5foBm2iY6Spf3174rcMRnMeXSARbueNROncNuVgtpbQpmRuRTwzu/OC2zMDn00WMlHmMkaCNw==
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


