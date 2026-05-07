Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1A33CD37AA
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 22:22:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3206C6B00C0; Thu,  7 May 2026 18:22:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 288576B00C2; Thu,  7 May 2026 18:22:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D56E6B00C3; Thu,  7 May 2026 18:22:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F20106B00C0
	for <linux-mm@kvack.org>; Thu,  7 May 2026 18:22:56 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BEE961C0541
	for <linux-mm@kvack.org>; Thu,  7 May 2026 22:22:56 +0000 (UTC)
X-FDA: 84742049952.02.0D52681
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 93E811C0012
	for <linux-mm@kvack.org>; Thu,  7 May 2026 22:22:54 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XZDZqLiM;
	spf=pass (imf20.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778192574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jpAQ9O1oMgUNlo5ukg9OEno1SM1k+70VK2/jH7/8vVM=;
	b=etokXoUSbrXQzrHqpcQ5iSh/tk6CeGlBWsRtKCmvoHxlGTPJbrMqe8c6bA6OSQj3hirrHK
	sBei0JATPTXwUszDzALZ1tPIXbz71DiAadhs/bzZKqOCBNvN4HhM6gPSKWm3dNQFu/HRN3
	sjJ059Z4Gfi2KlOA6rW6UcGTVgnGn+4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XZDZqLiM;
	spf=pass (imf20.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778192574; a=rsa-sha256;
	cv=none;
	b=hMN3MrKG49lYALulOLNCVrLJhz6J1oJg4UUPwCWQOkUe+83HNpthFyAM47fttJfIr7e8Zl
	e8xv/LTyzpxAWwt3oIrMbBcWPFlDm7BYzGfaR+7YGclZW+lVQr23xhLxmnEWHBEf3X73s6
	30NkoeBk9P+IMSAGvEfv/scxUayXJBA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778192574;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jpAQ9O1oMgUNlo5ukg9OEno1SM1k+70VK2/jH7/8vVM=;
	b=XZDZqLiM87bDtC8he8bnze9M1i81lsTuZe7yb6LPmjltSU8CU3kELdlTfEu8Mnfa9P6Jg9
	Qn1kx6gqBItN6VUcsmk/4RrbRycdrSrWu8sHdSDS8JikDIEnRCYRZLvlGCGGs1eaUewNIv
	FDGkAVAiRlmIL7rNHqrdzU9n0rrxUJM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515-VeLdKNv0POW2j7p9GznumA-1; Thu, 07 May 2026 18:22:49 -0400
X-MC-Unique: VeLdKNv0POW2j7p9GznumA-1
X-Mimecast-MFC-AGG-ID: VeLdKNv0POW2j7p9GznumA_1778192569
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-44f1b4d0fb0so922134f8f.1
        for <linux-mm@kvack.org>; Thu, 07 May 2026 15:22:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778192568; x=1778797368;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jpAQ9O1oMgUNlo5ukg9OEno1SM1k+70VK2/jH7/8vVM=;
        b=FIlgu32Goi2fE2HqC9VGOrxIfHuoQ2zyEY2oXziXNwHmXSkbk9g2yZh3PXJ4NW5BF7
         LpSoOHln0zDWoUF0xuEDPnOpvIm8CzKonWnfkpqEjynHjVd6a/+3s7+X91smrqhoR/Ds
         mgZU6vTVo8bzO1vhcn3SQHdr/gBnPLL4qhdx7tpg5JJVLimxZRLYERW9n2bJgYcHMmbE
         cY5nNXrvo2nus/LpygQQQAGG5thzYur5c3sAT/UJZ/VCgprvhzIl2Mk9NcTgAOlEezPi
         pIQWvkh58lsdU+VE5xOX/DBQQcS4UOXvM0KU6KoAEibmKO2QX+RkKkDhnyjQOaXHyaLq
         afsA==
X-Forwarded-Encrypted: i=1; AFNElJ/lcmS8GerJooq50RcCUq4N3xW2bveszZNsG0DjD5gcaVs0ESM29Whcc0p2K0xg0CxDpPg0r1Y7Vw==@kvack.org
X-Gm-Message-State: AOJu0YxpwKMAY/bYydA4pYUGBZygDDibsPBEiXExREZIO4XIk0nU+fCt
	AslTVu2e7PRXBYqSkgBqjlzM686hYqMi1YWraelaYMVpi2XJCjc+P3y99O2KulJUqKxnYzS1Bdj
	afcbP+YsMlC0ahEj6042j1AMlauuA9EmT9X4AZ8WRDm3M3JJ9dAws
X-Gm-Gg: AeBDietLgqUD9USNzbO1QeJKSpzB1J1roevz+17V86QWaXGumy7FW5tiava9R1FYEJw
	9LtYDfxaHJzxbg42jXu2VF74IOJKbIn5w/0PrcLRy3p44/lDMtD9tQt36g6DHQppjRe+7c2vgOQ
	Yr4qm79fOJwbMcsIHARJGRoeCDv1dvO+DNacjSw8JWSfclIA+a6qh/eXi5jbjaLtMwlZiUgIwzy
	2DDqtJsYtG5iC0Zjy3je2QMCXEpcNK/ei96MeQbillFa5gF/hf4mGpimlzukikOo4uFvw25opIP
	rRyIyrQSVejUvcT9a+fWQN7+nVXA9/kX46k8PpCnnez7aQHDPxoi9Jgq6tsTzrOPoNSqlrT4i0f
	CKmD0NNaUgkAA5XPMQxOZMTGXzkFtFluhxZkvTtKq
X-Received: by 2002:a05:600c:c11c:b0:488:a723:ea53 with SMTP id 5b1f17b1804b1-48e51f5398emr112335405e9.7.1778192568488;
        Thu, 07 May 2026 15:22:48 -0700 (PDT)
X-Received: by 2002:a05:600c:c11c:b0:488:a723:ea53 with SMTP id 5b1f17b1804b1-48e51f5398emr112335225e9.7.1778192567996;
        Thu, 07 May 2026 15:22:47 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e642e9d76sm5598515e9.8.2026.05.07.15.22.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 15:22:47 -0700 (PDT)
Date: Thu, 7 May 2026 18:22:44 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org
Subject: [PATCH v5 06/28] mm: use __GFP_ZERO in vma_alloc_zeroed_movable_folio
Message-ID: <c9cf97e78dfc57557614e56c0711e29f25a07f66.1778192416.git.mst@redhat.com>
References: <cover.1778192416.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778192416.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: NkhSX6YXogAW6B7huKhMnyoejzR2C6JNZgSU4EzVVyo_1778192569
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 93E811C0012
X-Stat-Signature: y7nwn5oe1rijaqyfihu3ffprk5q9ywoh
X-HE-Tag: 1778192574-311759
X-HE-Meta: U2FsdGVkX18vkhJ9LRTWWUig9GJxdMipe+J5WQW31msT/bTvcDMgAKO/Bl/KaZKDLZ26SOKMqgWqgiU+aSVC4LhOYZnqtMu0WLrpYQfffBBobVLZ92ByM+gMD4nu7EsDfeUy3+Mwbyb9xUCM66nkWAx0HBtDS+a4PfjJoXPO+8619PQpxVuEL4XLpCFZ6nsi2STd4WNViLjJ8bKqFrHB8ySqYq0NibQYwcIMNFhdImhsWVfcVEgndUz8q9VPQp2PratpexYBKSGo0RC2+Nc4KpZMt8pWlseIGnguLAxiXEf6giVkuErCsQg3StPQOo1gQCDet7IJZBzkVcgzWzp7jPcsV+FEb18yofFzIyExeokMm0MZZKJmgwdpGAtHym0sZuuziv0d/IrRzRFWY9PjlvkUgxb2ShXHU+7Sth+cLacozpQWqFs1tKhUSsgKfUBaBTY/3zrPe6XoqejS9hPPL6nimzP6dvpd/eFd8wtOAHItOhH/TpiAb8n5M42MEMbREoMR8bWn47PVe69IA8Y6r0048EzvmVHksnaKgTJL9dJS3zJGJQJ2n6/ciBrKpKm0pU2W7EEqjNeWYDIDMnJ+aGLXtl/IBC+FmvxvHDIxgIi8bWmKnp+KLhfT6+I6GegaTVC648QkKgF5xlmPbNpYYQvsMwyaXkco/pAdgNLqCTEE31H8aogAdvnkyQzDH/eMZdFsiQuLjExtCOyY3quZVep9zswyg6OrqS4rAtMRCWirtA/3FM7+IQk8etMUt29LbIL4JJh2wanysBKhfxEcP0f8u4W3LhDRSt8ae42Vy5sbnKarDatohaUgQpyDJ22Suk9A710weUZFzf1peHkRg2d4+9LZrOP1UIrxCgsSmNPPMdt+FiP3S8VMzYw7xPzsloIov4e8MLfxkgcVLCPDAs922wTEryBspqJmzsOIqpp8ElsFMPmh4e9cGnyvXCtHHfTbqoWQXOlUeU+H3P0
 cFoPepEw
 LYyACEgWHdL8C9lNHW3pni0tW63tTatJtp2no7pkT9MNzNehaJO5NR8mtvsAY3E+K1D3XsQhC4JnjjUI14gK1BQxesFjwVrDf8NO1bJ9fCm3ex+RtwQuvU7wWa/gpRWjrWUtpEg94Om8jKwgM12G0dIOsFM/n8iYbk3VKRpj0qeT2937Dw/gjJJLD8mgroojPgJOoiwiQbsQtD+dSei5BkoTwIp0ENonvL8yBwOgtpBjiQKbkBw5C/4HUym8KC5uQKKRxlllW+6Aee+rp/Uc4nnPnSZp93W/QtJSFPFmodraj8vFbRQcd4xuxBvn081MQ2tRT0iGTPN5beZBw9YJOXEe/XnfCKwmW6AVNKrmUtf8Y7u3spvD3T2jJ4A==
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


