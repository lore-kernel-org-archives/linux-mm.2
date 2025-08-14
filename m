Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BD3DCA0EE3
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 07:24:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DAA69000FF; Thu, 14 Aug 2025 03:24:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B7EC900088; Thu, 14 Aug 2025 03:24:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C8179000FF; Thu, 14 Aug 2025 03:24:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6A4AA900088
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 03:24:31 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E88CA138384
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 07:24:30 +0000 (UTC)
X-FDA: 83774525100.14.49B5682
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id C02AC40006
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 07:24:28 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="VsbIZ/B0";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755156268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aIvfbzyT9Aegr3dWXVJ85T4HzEO+HdxXBmAclblXRsw=;
	b=8nl/hO31Ssski4v2vDayfgtBNqIgWa2mUw++T44Bs7bOZ1Eco2R/3qbXLoxgayyVoQMvyK
	GRPWCkYWwLQO5qQnaNv57+7N4hb21OEZRaxCnA9EJ0+dSTFYagVSPG35h8kh5AOaMV71VU
	QgbScw4Y8/X2lR/s9k/8usrhKWOGBxE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="VsbIZ/B0";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755156268; a=rsa-sha256;
	cv=none;
	b=3ioiLXYWfG3pAG/7cwiTyBj2HUwxVxijfrF2XfbUBZGwZfa4NSANuKu67pgg5037UABW8Q
	nlaziQG5inFYspDyJf4+pQJ6hCLXGQz0Rh4FGScX1qVi/G0WfEV6yZy1okMEmqwbjBu5Zm
	ofuDXS0vH070DGVfEZ6mG78r/ac/e/k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755156268;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aIvfbzyT9Aegr3dWXVJ85T4HzEO+HdxXBmAclblXRsw=;
	b=VsbIZ/B0iB23MzUrsDjMC3h6YJlq4RLsyHLNQIf1r+alKmlLV1/madWQUVKuNG0IC4zAOX
	XJN43jcrZCvfD4f68Y0Ali33mlBf+QYOrGCn7VtgbKf9Qs4h6K8aJMhTOmjpq6RIHeeQiH
	zyAMedagaFJHzJUglIRMAkp/OPhA31w=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-472-1nGSe5iMOB2TEo-Au9uSFA-1; Thu, 14 Aug 2025 03:24:26 -0400
X-MC-Unique: 1nGSe5iMOB2TEo-Au9uSFA-1
X-Mimecast-MFC-AGG-ID: 1nGSe5iMOB2TEo-Au9uSFA_1755156265
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-333f8d3868cso2031941fa.0
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 00:24:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755156264; x=1755761064;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aIvfbzyT9Aegr3dWXVJ85T4HzEO+HdxXBmAclblXRsw=;
        b=hVUoGl+0Pd0IV8FfaFGOyA+1N5lYFOaL7oUsu6KLRGz4oe58sDoMruYT/DHRL02ITW
         etxVWdi6rDlRjWkG9y0r4nEI2ZzORvs0XS0gxsfwPPmaayXZ7BoUHrCDpUO9q041H3ly
         rvi7b5Z19rjSOCnmSLnGT02k3BeESCjxlQC8iZlUczQsLuvSoD/qY9tXiM4/HE6tdM6P
         UiF1JvbRepDVRmxTvTdbMsJxaK4fKct8qz1LmbN4xKt1U1spSnQs6xTl15W1gBEnUSt+
         rFLuABrfaUkd5pTUtDo5aQP5kl6/vp90E3x/OpLx5GkNtZY1mkoSuRxp+1G9iEBrNAOC
         E07Q==
X-Gm-Message-State: AOJu0Ywcfr/ql8OpD+EwlAs2K/7EsIv3aC5ORNloVtHumiqdhz2Hkljl
	LZub3RP4ScbPNnV9fqW6RK1vNwNUGCk8vgacHe0gZjoD7tGFqFaJ6NxHMWvWyyL31ADrgtTNp51
	ZuXU99AoiuN+ri4WvsYveICPr+kg+LQ2t/jI5SGnQ+rU3sFaoc+iqjLJElPJTE9a+n0DTJ7x1cz
	XFFtD+/j4ImsUvsQilskRNtgRGKHqLd83MG44=
X-Gm-Gg: ASbGncvG0sl7wyHLJ6IDdla/4kNcUjUOO+II2uEZk+PPM6KwE8oYIXepzmxMXc8R475
	plpHryFZo72ly2FYFzeZ7/ifK6URI91ouSs8sYFuh6grKJht5acO4P83IAmt51nng5YcS8R2951
	bfdvI/YzT2M2pdTMUE7TkOYMvP9Y5POjyftaqV6ACe+Zs+JbkROvhh9eAvvtOnEM0A+IuJ+flDT
	dLzJxpgDLE8NkVwmvV0KSdAv6w+XcqALSute8Aj1wKliUAPCk9MgvBEvdeAj2IqF6z+J1JWSLEV
	tXmrJytZseko/ABYznX3w1GoyyFCFceSc43JlCifeqXQ0Oq5o+v7ADA=
X-Received: by 2002:a05:6512:15a5:b0:55b:7c34:2b95 with SMTP id 2adb3069b0e04-55ce5045da9mr796984e87.20.1755156264215;
        Thu, 14 Aug 2025 00:24:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHtIPuBiMFY0ZIY9glLmcyHL2YD88jMmKDvw3Qwgo8mPRFe+d1e9BQ4g3jqn4rV/aPKZsRSdQ==
X-Received: by 2002:a05:6512:15a5:b0:55b:7c34:2b95 with SMTP id 2adb3069b0e04-55ce5045da9mr796971e87.20.1755156263663;
        Thu, 14 Aug 2025 00:24:23 -0700 (PDT)
Received: from fedora (85-23-48-6.bb.dnainternet.fi. [85.23.48.6])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b887f72f4sm5620240e87.0.2025.08.14.00.24.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 00:24:23 -0700 (PDT)
From: =?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>
Subject: [RFC PATCH 1/4] mm: use current as mmu notifier's owner
Date: Thu, 14 Aug 2025 10:19:26 +0300
Message-ID: <20250814072045.3637192-3-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250814072045.3637192-1-mpenttil@redhat.com>
References: <20250814072045.3637192-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fWe2S2SnMF8ygBeTzsFV_cqnjtPxrheIHwAAuf4EG8c_1755156265
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C02AC40006
X-Stat-Signature: 1dcyuhkex7c7aszsq5ns7fj6qp35by14
X-Rspam-User: 
X-HE-Tag: 1755156268-235205
X-HE-Meta: U2FsdGVkX1/jIYuu9p3TPbw2N+wfhKNEB/6JsGShxCSkIATRdoz1ZRLM1PhX6n3Xcxdup8tSBTDUkSmG6n/eSQON5vww0+ZEjUg2zbT9hs8wJfrysVXXr/Jq9awDyMqu2gn+Xh85iNYzh4tsdB+iqV6gbWQQ3zdSj7h+aTMxmBweFX81yMWVdiPoUEzVymOdQzo4N4O8x+bGWsKtDid3RSQLi0INoO8wjfH/0yuo+jVV2ROdIclCaUeap09BdibbcKe+qRl/5l6rYP2FIcINEu3aPqVvZmKeLZwNQyAvO3afrXVa+sN+rJL1opreTxImcvxUz1RyZrZHs8lqu0GswXVdMvVZaLKuKr77s6kc/2nhowfqXXhv/ca3LpvRdkVeoe5oHdRuHS72lTVcm3pEkM6EOntYZwpWkddTJvcFOJBY+BuEkDdwjD1/ire507lWeC5KgOehp1RFa+UKQD3mTL8BMBZIt7Y6oioyXHbmBpPLDg0ZLlcLLQf7f/lOGqb0wrzZEtxrG6hOHN3rJLKIClRpB6GNlwkWtEFKcIq+3tH1ZyCt5g1DdQuAUf19ZuDbw/f4xbkoulwNlP9xw8GM+lg40UJYMjQyOaTemM5f4PGrCXwB3kGycCq5LEQSRmFgwqiPcKTZf3i8kgKtinOsd4FV1XBcpRiT9ivmDieUqoJCjKeOdl+q/0zQf6FRbAph13yABNLFKMJYmcSd46jOlzqE5mGAv74Zb5pUqGJpAivuJi1MGmEnmI6t+8xxkq3xQRYt2fxc7L8RHtKaNatUohCE21DZOYdCOvoYI7S4+3iKjii3khqjCSSJFzg9n7pLhGE9cXpYYjuyCJDX4Zuu4hhtezrl5O4t5xp5zaZoPH8i6vUy5cDnx0wcM123a0zXRIjl81sZPczIAZ8zCB8G/V3YQK42ePNYg6/guUOoijVXnKB4xBN8s6T1ounrqF7TLIzxNDanswV3ZuGRwFt
 m7er7WRp
 IMIOeceME7vEHumJnAa6QFeCWdh5aNkmDjBGB7F/uLg/0mwlwaiAAw/BS1Q9x9QZTO/FX4P4qxWJfBC7bZv6yeodDlQlaEz8Z954v2dfpNszjnXu3rThmX9PiLJW8NFjil8H1Y5w4InoQ9IDTWK9CLQJJ5bCY3pDCGfl0oHrfmQssV4hIU0lxxC6Pcuz9MSEXPM7yqGP1ieKyz4U/gvuVgDYGoEPs9sRFg5zBX4jHoLBinA6iOv1dspSe1Xlb1MJ212EJjbIxO7cklnkG4HdJVtI6ecJurF3Uu2NmqZ+/HbiM5kNyf6489/Ocebxwcq3kSWuf+w3CVoxttEY2K1W3PkSC9aHv1N2+AdVuIIHtBpHeUM/gtUn2s48uYJfmDUXzMesC9PhJZjSUOUSnDoBxmR3pQ+YeyX9WbdAv/Qkb7GWeLBRAAf3rma1uuA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When doing migration in combination with device fault handling,
detect the case in the interval notifier.

Without that, we would livelock with our own invalidations
while migrating and splitting pages during fault handling.

Note, pgmap_owner, used in some other code paths as owner for filtering,
is not readily available for split path, so use current for this use case.
Also, current and pgmap_owner, both being pointers to memory, can not be
mis-interpreted to each other.

Cc: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Leon Romanovsky <leonro@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>

Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
---
 lib/test_hmm.c   | 5 +++++
 mm/huge_memory.c | 6 +++---
 mm/rmap.c        | 4 ++--
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 761725bc713c..cd5c139213be 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -269,6 +269,11 @@ static bool dmirror_interval_invalidate(struct mmu_interval_notifier *mni,
 	    range->owner == dmirror->mdevice)
 		return true;
 
+	if (range->event == MMU_NOTIFY_CLEAR &&
+	    range->owner == current) {
+		return true;
+	}
+
 	if (mmu_notifier_range_blockable(range))
 		mutex_lock(&dmirror->mutex);
 	else if (!mutex_trylock(&dmirror->mutex))
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 9c38a95e9f09..276e38dd8f68 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3069,9 +3069,9 @@ void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 	spinlock_t *ptl;
 	struct mmu_notifier_range range;
 
-	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
-				address & HPAGE_PMD_MASK,
-				(address & HPAGE_PMD_MASK) + HPAGE_PMD_SIZE);
+	mmu_notifier_range_init_owner(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
+				      address & HPAGE_PMD_MASK,
+				      (address & HPAGE_PMD_MASK) + HPAGE_PMD_SIZE, current);
 	mmu_notifier_invalidate_range_start(&range);
 	ptl = pmd_lock(vma->vm_mm, pmd);
 	split_huge_pmd_locked(vma, range.start, pmd, freeze);
diff --git a/mm/rmap.c b/mm/rmap.c
index f93ce27132ab..e7829015a40b 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2308,8 +2308,8 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 	 * try_to_unmap() must hold a reference on the page.
 	 */
 	range.end = vma_address_end(&pvmw);
-	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
-				address, range.end);
+	mmu_notifier_range_init_owner(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
+				      address, range.end, current);
 	if (folio_test_hugetlb(folio)) {
 		/*
 		 * If sharing is possible, start and end will be adjusted
-- 
2.50.0


