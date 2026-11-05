Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1EE0606A331
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 13:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=fr62oERh
Received: by kanga.kvack.org (Postfix)
	id 0975E6B05B1; Thu,  5 Nov 2026 08:22:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 070626B05B4; Thu,  5 Nov 2026 08:22:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9FF46B05B5; Thu,  5 Nov 2026 08:22:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BD8D26B05B1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:22:49 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EF39CA0A09
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:22:48 +0000 (UTC)
X-FDA: 85401130416.21.4A7612E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3DF04A0008
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:22:46 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fr62oERh;
	spf=pass (imf25.hostedemail.com: domain of mpilaniy@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpilaniy@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793884966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ab9/FtU+evEOIDbPSbhyDZc8Br1EcYdUtbtpoFOf6ao=;
	b=AJp8sDCGslaekd48ox//jvSz7+q3RgZgGXA8/VGEof2uh3bEfw/vso3pPaBAOjCvMBUl1L
	dCoC2COJbTwZncA7cvzEj8ah/Gy6OlLgkfjyEel7/HmgMMV2ZPvIrPqRNgqIAR5vpeGGr9
	kWtkTwGyMUqyaqMV84vYmPMD33KkWkg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793884966;
	b=3xrI/ynlfTbnHQDq/D3iuLBXjCHNMv25izI6HYBmJsRm43MGkYQhYdK/Sc5LQui6+jU/om
	1Cw950a3YfhJxOJtqW1g5p5r8wp0ruxgfSAKPCvK7P2XFJA7TLEXVtB/80XYlctG3Kb/WE
	PZnfcWxfa3YKfblZeQvIHtde4EPYPsE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fr62oERh;
	spf=pass (imf25.hostedemail.com: domain of mpilaniy@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpilaniy@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793884965;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ab9/FtU+evEOIDbPSbhyDZc8Br1EcYdUtbtpoFOf6ao=;
	b=fr62oERhRZPVeSo7JaFnIkZtmfc/Zuq9XjmpgIvDPILYsv5yIjaN5605CKqC6hCpRVjKb0
	BLmFnc7skibXHi78azhmLrLk36SelglQwnJVM2+nTC4pQEi5WKD9g6+6567j/EHW3FABvp
	Z78b8iNI72pUClRGPWiLtHnAZ6FHSng=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-583-s1tYk10jPNSU_fiHfBZiwA-1; Thu, 05 Nov 2026 08:22:41 -0500
X-MC-Unique: s1tYk10jPNSU_fiHfBZiwA-1
X-Mimecast-MFC-AGG-ID: s1tYk10jPNSU_fiHfBZiwA_1793884961
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cc73895c7d5so2066152a12.1
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 05:22:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793884960; x=1794489760;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=ab9/FtU+evEOIDbPSbhyDZc8Br1EcYdUtbtpoFOf6ao=;
        b=BfXL8Dg+I6WrIEYvi5dIS93rNnAOVPmpZVoeCUMIcivl0uaYWZgLH+A3bL2nKKVrf6
         agtILb10svUYXEGpLFIYzRNkhTDMHh7HKcV6O1dsefpXPv2mOSCeMSfvdq5mJg2hHxF/
         gDAYVbPM4VMxVzcmje//PZwtPxPlHF1bYw/i7tvNqDEBmhEvdG3iCG9Rb5a2JM2aBYbu
         9qcOxYGruEoYZks8lwb5p1id1J1tZDaRctQFd3z+qgkU+4tpfUEElEA8+tyIwyRIfjk5
         Oyh5DoWrYwfl9MDEodTGZAj5OfiWuq+5IOfan0x5DMvGDf5/3mJtG0CuRDtPS7oMS4n6
         7eYg==
X-Forwarded-Encrypted: i=1; AKwUvBzh6DsAmSQRzQcKw8zkVssgnlyHM2lRocOpYSJeg67wF/ZEeiJlpowS+Lhq/hk3jKURzcfcxXG35g==@kvack.org
X-Gm-Message-State: APuU4Z/GQLkncicR6GiU3eEoXuyCh7EfBpRuEBC79HZlUVeMb8rwLnLc
	vmu0jlOH2FvW8AWnhwYmX1+Ife/huYDG/GT063cRmDamHwWGwNLxn9ATopxJH6Vk5Sq8VUgNd+u
	7xCsnojM2NNPiNup8tngdBSZyxv9Y85xSL61RDx/tporJ4/T//nDo
X-Gm-Gg: AYBFou1bSZjoKXAiZsiEuiPFP4NNaUn0vvlSfMPQGO5HbvX72AnvACNkD6PVF0aBA0X
	2JU6LMqfYlqPevHsnM01uxQYwkSGoLu7ayDnZH11JqvuM4AwYHD6KaWWLc763Zq3YEpYRfKaAb7
	QPsgosD8wPhPTNHMQG5DY00nyw6PgiEjfsO5B+a8I2KUIPXIn/N607J7H3pqJ4xXUQ+S92X5bI1
	weeSTrFpROeMmSkJyhuelx86SEz2VrFFy5rUwOQlnKs6Y8xwXIQVw9c7THjo+atCWwMlGhweoDZ
	/B8NNjMJIqktVewDgT4XE0WR0IxvVdjDLkDqKcwAxaSRYXK/ONdrAJkwDT2ffrPgCTvGlCHjg3J
	goUev7cwW/7FTRTpKsQmBfTpEL9l/HNFv8GhOTJUX4j8Dwk/1dg7Lfmy3locaXHey4ApY2N1Ty8
	XjtDWbr4ibvBvHbao=
X-Received: by 2002:a17:90b:3c08:b0:3a8:bd51:205b with SMTP id 98e67ed59e1d1-3ae89812f18mr17182376a91.37.1793884960402;
        Thu, 05 Nov 2026 05:22:40 -0800 (PST)
X-Received: by 2002:a17:90b:3c08:b0:3a8:bd51:205b with SMTP id 98e67ed59e1d1-3ae89812f18mr17182351a91.37.1793884959900;
        Thu, 05 Nov 2026 05:22:39 -0800 (PST)
Received: from mpilaniy-mac.redhat.corp ([2401:4900:1f28:63e0:edae:927e:c670:b679])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0b31601b7sm3856804a91.5.2026.11.05.05.22.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 05:22:39 -0800 (PST)
From: Mukesh Pilaniya <mpilaniy@redhat.com>
Date: Thu, 05 Nov 2026 18:51:33 +0530
Subject: [PATCH] kho: fix restore order for NUMA-split preservations
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <20261105-kho-numa-v1-1-e807879644cc@redhat.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXM0QpAMBTG8VfRubbaLMKryMXMYYeMNpOSdzdc/
 ur/fRd4dIQe6uQChwd5Wm2ESBPQRtkRGfXRkPGsEIJLNpuV2bAolmuUpZLYV7qCmG8OBzq/q6b
 97UM3od7fPdz3AwbzeB1sAAAA
X-Change-ID: 20261103-kho-numa-5ce38a3ed9c9
To: Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Mukesh Pilaniya <mpilaniy@redhat.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793884955; l=3669;
 i=mpilaniy@redhat.com; s=20261103; h=from:subject:message-id;
 bh=2j7UXRooyvW22SzIaRB/dl4RDz1nl9MFyxNiZyzuBgw=;
 b=vdaovpNvxbtOZRXpNitY6GqWoF6nDPZnjCousaLKgOJwI/K78h/4L2Dco1VA9V3Xcs/fKO107
 0UkOGgTHLK7Cw6fzuSyiGE2vzHPSQcKHjK954qch/bS6j+SUWRF3KTp
X-Developer-Key: i=mpilaniy@redhat.com; a=ed25519;
 pk=dOf4ctfH7dkkTYewUPOzloK8/0QFmb+uPo0tKgpSdzU=
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: DiOIxWCIH5AWdE3XLDSrun98xMNLZPaue-2RrZ3gZRo_1793884961
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: yidkb9qg1rgbyihi5718h1ofk57s5qmj
X-Rspamd-Queue-Id: 3DF04A0008
X-Rspam-User: 
X-HE-Tag: 1793884966-251617
X-HE-Meta: U2FsdGVkX1/p5sC8O2Rx+T1E3sKQChwyIaLWDT6kIlPEpWR5IUWs3hB7AxVG8zNjViWkUwJXXut81/aXGMeX9a0SF7y/O86Mthwnvc4hEH8s2AW9mlcJEqw+VR3WiQgqJ3n+ieiGVEFT+CLbqFUZ4DBsjBSP/s/duzsGBZ01JOJUmB914iWxwm5ifASH5zhIeRg5wQI0oyILCzq3IuozYKSTleV9Jv5VNgf7JO8Pi22QkAMJvI5A5idtFvUtQruYj1O/9atDpPjVke7paLXCsKOD03nFXyNC6/+6Oyx35ZOoVuFZ0yElS8UCnydtKRh5pUdIWVW2JU22Yv9PhT7B4fTI7LWGgVH4P94gmCnBcQW15Xh8uXPtIgtWOaQ3did6HRvhhPHj/wrq8nGGcStTXJckyVV7dHq7JmnSITL5nssLl7csZD/a8Idm5GF48nk5zxQuz8yhmKtm5rgcVrXdukxbR4vGwSyUG0/84YZ7T7kha0jJJfuXVVHdG7vt103WorFy9LwmcQHgmpM+GmoBlz5rppMsmk6QXfZKsYBV9OK8ZezyZ396YpXmU6Ty8cMleSWuiabpOqZdSxKLK5nEmrpS3fxip9DqFMeaD9bZ34Hf2SXBDGKshqCagMHgAxExruxNuR+d0zPjTX8DekV7/BjgnO34S8ewCYhLuJeMAEKsS7FZl8/fbAXOhBlTEftj75Ya22sNE4k9apf3+s+B4AXj0CCxpUbwh3r9xQFMp2CBP/9mfe4rtj1XHzOVAt4aeJ9rUrL8Tg2ULYwyN7LWhtxvTI9WH8KzpUi70sN/hpB29Cn3gTTIu035yaeJigHa81SQhvbp0wzS2TyFJtmvdUoxd22eois30cYkp4v3dUQswh2tLgKUUUgew4yM/MTo8h6TlvedR/UjLQFxe/UT3ArfRfOZfDSALG/tkqJZQU7KZ0SwnalScTsVyBdiv+IRQPpgA3fYRS3EQ7X0Jfc
 KF3wX1pH
 VMWRZ9inpJkYRgpEa8cX+oHfMrZpOM5hlt9hXsUJzvYE706+YezewmHS3S2F9qJHYEclKWn6ne3d+8UV2l3OrMgXib8G2I9l8rqvkEvW22tiXRLKiB9Jv+/jeoV2ySp7hLUmFb+oKz1p+3XjEd2xi/CzrEtEoAmgV0wuS3PDcH5QDC+UBsQV/rgZwzOlrxsGMw5Tq9PAIn5Yuouayse00ACGhUmuUx5afsw6NHM2f1jT2q7KYfhIQ9QMMlaKljMDMCzksO/ERqDQpeTy36DKj+/aNTG4k12BIcAzFWenKgsIOGxabgK/RITPTDBxbLQYrF6MPI1igAcoNMJc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

kho_preserve_pages() uses __kho_preserve_pages_order() to reduce the
order of a preservation so that it does not span multiple NUMA nodes.
kho_restore_pages() does not use that helper; it recomputes the order
from the pfn alignment and the remaining length only.

When a preservation was split at a NUMA boundary, restore picks a larger
order than preserve did and jumps over the next key. Those pages never
get restored: they stay memblock-reserved and keep the KHOP magic in
page->private, while kho_restore_pages() returns success for the pages
that were restored. The consumer has no way to notice that part of its
buffer was not restored.

Fix this by reading the order from the key being restored. The order is
already stored in page->private by kho_preserved_memory_reserve() and is
validated by kho_restore_page(). Advance by that order instead of
recomputing it. This also keeps restore independent of the incoming
kernel's NUMA topology.

Example: QEMU is started with two NUMA nodes:

  node0: [0x40000000, 0xC0400000)   2052 MiB
  node1: [0xC0400000, 0x1C0000000)  4092 MiB

The module preserves [0xC0000000, 0xC0800000) (8 MiB, 2048 pages). The
range is 8 MiB aligned and the node boundary sits exactly 4 MiB into it, so
preserve emits two order-10 keys, the first at 0xC0000000 and the second at
0xC0400000. Restore computes order 11 for the first page, restores the
first key and jumps straight to the end of the range, skipping the second
key.

Fixes: 91e74fa8b1bc ("kho: make sure preservations do not span multiple NUMA nodes")
Signed-off-by: Mukesh Pilaniya <mpilaniy@redhat.com>
---
 kernel/liveupdate/kexec_handover.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 6f1f55fe3181..7d30ad9cc512 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -511,7 +511,8 @@ static void kho_init_folio(struct page *page, unsigned int order)
 		prep_compound_page(page, order);
 }
 
-static struct page *kho_restore_page(phys_addr_t phys, bool is_folio)
+static struct page *kho_restore_page(phys_addr_t phys, bool is_folio,
+				     unsigned int *order)
 {
 	struct page *page = pfn_to_online_page(PHYS_PFN(phys));
 	unsigned long nr_pages;
@@ -530,6 +531,9 @@ static struct page *kho_restore_page(phys_addr_t phys, bool is_folio)
 		return NULL;
 	nr_pages = (1 << info.order);
 
+	if (order)
+		*order = info.order;
+
 	/* Clear private to make sure later restores on this page error out. */
 	page->private = 0;
 
@@ -550,7 +554,7 @@ static struct page *kho_restore_page(phys_addr_t phys, bool is_folio)
  */
 struct folio *kho_restore_folio(phys_addr_t phys)
 {
-	struct page *page = kho_restore_page(phys, true);
+	struct page *page = kho_restore_page(phys, true, NULL);
 
 	return page ? page_folio(page) : NULL;
 }
@@ -573,13 +577,13 @@ struct page *kho_restore_pages(phys_addr_t phys, unsigned long nr_pages)
 	unsigned long pfn = start_pfn;
 
 	while (pfn < end_pfn) {
-		const unsigned int order =
-			min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));
-		struct page *page = kho_restore_page(PFN_PHYS(pfn), false);
+		unsigned int order;
+		struct page *page;
 
+		page = kho_restore_page(PFN_PHYS(pfn), false, &order);
 		if (!page)
 			return NULL;
-		pfn += 1 << order;
+		pfn += 1UL << order;
 	}
 
 	return pfn_to_page(start_pfn);

---
base-commit: 2637bdec0535a2044cd830eba9a79363651d9043
change-id: 20261103-kho-numa-5ce38a3ed9c9

Best regards,
--  
Mukesh Pilaniya <mpilaniy@redhat.com>


