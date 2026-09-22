Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D41DC98307
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 05:35:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F6B76B00AA; Tue, 22 Sep 2026 01:35:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CDCF6B00AB; Tue, 22 Sep 2026 01:35:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E3DD6B00AC; Tue, 22 Sep 2026 01:35:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DA28B6B00AA
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 01:35:01 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5CD161403BA
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 05:35:01 +0000 (UTC)
X-FDA: 85240284402.08.8E1F843
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1DF7E40004
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 05:34:58 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VZv8OKbp;
	spf=pass (imf01.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790055299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qu0BSxnttTs+uKLg/qx0GDVYgMyi2m2Up9fDq2tLMMQ=;
	b=dkpbTHqGgcu/mwPAWRexiKGdtFgYc1xI6zD2f9epTl00OI0Avz1qbE7/Id0W+kNXVb3eYM
	HnXwBQwwa6lsiSQ1r+Npxza0s4Y8FJbGrmhxh0XyJML5OqIofa56G5QUq7Hp+PEY7LRWQh
	QT013+rFdH0Dj4it8rS9byhOX8mqNcM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VZv8OKbp;
	spf=pass (imf01.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790055299;
	b=HgfdmKitqiRBKLc1cZczPmSWEydIaQzrbO0vaNU+RGs91N+XHHF2Tsz3PQ8uJp5i1s9k/e
	X5EcV6NpAcx5325bSQMoFEU9h3dqzg+KG+pu3wxPMCdQ5YdJslxdUBAtLS85YjP+vkGJ2G
	19xVCePyv7Ov2dpp4PmAD6K3VLa0Rc0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790055298;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Qu0BSxnttTs+uKLg/qx0GDVYgMyi2m2Up9fDq2tLMMQ=;
	b=VZv8OKbpcf/tSWFr73LbODQ3xsX+pNIXLgBqh3ISkQzwqalw9VqTuO4N9JmQuU9k9WM/so
	fcuwhISSzSLFE9G5SPJgFD+C4dsBp8NjNmwdx/FDd3Ix34QLrL96TB7nlkuHSplI41svmo
	eMnlnerIqilVxgR3Dc/EzHfLGyapHsI=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-198-l3QkxCwFNhCDId3-7asukw-1; Tue, 22 Sep 2026 01:34:55 -0400
X-MC-Unique: l3QkxCwFNhCDId3-7asukw-1
X-Mimecast-MFC-AGG-ID: l3QkxCwFNhCDId3-7asukw_1790055294
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-5b767214d60so283480e87.1
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 22:34:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790055294; x=1790660094;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Qu0BSxnttTs+uKLg/qx0GDVYgMyi2m2Up9fDq2tLMMQ=;
        b=zJIqGmjQz+/y9w95IC83yRMztAqy/hZD4HnsSIM+N/YL2Z/l3I6LWV3REXpNE9zxYb
         w54ns4+TNqm8w8qfQsiRRGioGlnjNPqLoG+fU1t8jNIvsagWUIYCaELHcVLAtF7T5WFC
         lI+zndKNfWwElyiqibUidbM9ZVRi5MSla+7pXrbXSWOU6WDIrF94vwofdRc1Skc1Tcir
         EBPEPRWG9VHYVmrjdTZLjY2RV92HtLZjncvUx/PAwcPv7uzoX6Wp/cZcRfVWKfzi5W0X
         lU5pUUtrBGQmRQJ3gCOGi3/XU3kSqU0QBx9Cw5pv5Zz+ayLT/g3fygkywebQDoh9zIK7
         A4vQ==
X-Gm-Message-State: AFuF++l9pNrjyk2B/U99Q1oAb2qHeBWORct6ESfeS7BMFRzaL9HepR5p
	8RIszo7L/HQOo0vHn+VYFS9Fi7JpEIr9YKIADNeKBfxLVzIQ/4P1xm0WKHyDtR93TSWOSnQTkNE
	5KkN+jvaDQphZMGkTytxaM+Pcb+8/azTEDsK7b4Fsp3utrIMJuPZ09sD1+EBgXLCkQ+JvOxjfCS
	fTM+XFLfT3Rax7ZwjowLxGcCxXIiK9yXVnDzzxvg==
X-Gm-Gg: AYBFou2ZyjXSx/V5QROhptriSikx9j3534u277UImG44Z692OJGikRue5d6W6v1SXq0
	90KeQBiINhXWa6rv1izolVh7NxijgRDd5m1XHFcdrKLGXXWTauen3cGaGZ/picBW5hmQBgj5wbP
	H+2lWI/6SQzLi+wZkjwosQUAK9zwxBI8ZmS/J+mMohJvmLREY+mEQS6Ldfy6mGfxZaYNb/4otBc
	tCGZJFwHye7ir+ZfGp/A2jUA8BTGwZu9on0UrWyn+LinHVuj32y56qna1Ao5HCfg48I13HNpXlU
	qWKHVLCHhR0xd9cVfSwETthhIv1lNKETHyeCmzbCce113V2GS54GH1j3VwncDZSTWf+elqCgu8N
	ZPzzEXgbNZVliZVDQjd90
X-Received: by 2002:a05:6512:aca:b0:5ae:b7c7:5334 with SMTP id 2adb3069b0e04-5b8d28fbc51mr474032e87.17.1790055294154;
        Mon, 21 Sep 2026 22:34:54 -0700 (PDT)
X-Received: by 2002:a05:6512:aca:b0:5ae:b7c7:5334 with SMTP id 2adb3069b0e04-5b8d28fbc51mr474009e87.17.1790055293609;
        Mon, 21 Sep 2026 22:34:53 -0700 (PDT)
Received: from fedora (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b8d46e0966sm191742e87.55.2026.09.21.22.34.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 22:34:52 -0700 (PDT)
From: mpenttil@redhat.com
To: linux-mm@kvack.org
Cc: dri-devel@lists.freedesktop.org,
	intel-xe@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v14 05/12] mm/hmm: implement folio split for migrate needs in HMM pagewalk
Date: Tue, 22 Sep 2026 08:34:14 +0300
Message-ID: <20260922053421.4092027-6-mpenttil@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260922053421.4092027-1-mpenttil@redhat.com>
References: <20260922053421.4092027-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GCLuVtUpqEcXYioAyEO4tqWxMVdynQCBtuHEl_OWmDQ_1790055294
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1DF7E40004
X-Stat-Signature: tdfjt5n7byrcqjmwqxsmegmrazxmpmdd
X-Rspam-User: 
X-HE-Tag: 1790055298-56760
X-HE-Meta: U2FsdGVkX18SmrWxzE0duScHU6p8gAEKQ0KgwyvwGPSWyx3exPq5VQeywDv2N8dTiqcKzeMbhyzU9zEwLRA5R1pnTHga/dwB1MVOaFI6nbVV4XFxS5vqgnDYCxxtQW6vx9XQKE3YF5dR7dNXHY3y5BmnyDwKvgTkA5aR2rPzK8IaB+CQujgWxCc6KBLho2ptEVJKbP9OfPwOEYNIkzYXUaCHKzPdIDtCVVo9pqddEj0H66Sdz8ffWFq/rfo92XQvjMkI6hT2qHO5/Xdrrj+JyOAmEf7ct1mDCIUsVg3o+eUqZ78QDyF7l3tYUUbYBD5dF7zLRwfXOZLLnqvJomALmvOKea06Ckx4gmWcP/gkVup++x53OTKGs+qDvqGnjKm/T/jgDCw0RODPKBcinNam+P/dqD2iQ/qeAxO8Q5E3Cjs4AxFb3CNNwtcR+scUIKkn3nwa0EWqbEfiOr25EIxC96B3KOEC6CrnwqXSYiBIJnTfg3gUx+/E1j/eAf8LM70ZLG6EL5V0iOj53p/VyeZClnnrpCdJ6OZmKnSZXD2MtE1ScI1sMadkbHZkMwrB8jnj9/YCvrOVI6IiCm0tRKbM6SiuJrDATDEOSK3oLMdTEj2856XaWOsZrj+dA7LPDLpJdxsS0q0P/w9SqPvy/yiV+h68eynpUvX9N6FVBTZ/MLMMT74puPtlY8CRHFSckQ4PjvClscFBYmlj+rPAxxsOKt1/GvZIC/bgX9B9tl4hhUio82cZ7H0JvsihBvvuxaC49AjEf3tTAQFj2sLGyrcxRSVBz01bXQe3Fpcn3ejSm+O/KEZA29q4JXHmDoDJW86N513J4oZnB/i2ejsh1q2gTPbQdn7TcTfVTjbB4pQK7F+jKSm57T757OHSMZf7PryPAgfBrouM221jk+EZtQh/flWe9W/N9FZ5IhogEM/PaKwhfI8HDqK9gAM1y23avlI4+3yU41Ych18cl8T1Bw9
 5JxsrSCo
 M1yvDx2Lioauhzpcg3hf2kInUENVbblyTxh3Z7cyLkeuAdDomoDjOKIGyrpExj4n04EhCnqMkA79oAV5OmTPbb9TRLru52fZw8XZoq04UEPPF1Mvgvq6m8CyS2GQpfHmuaoSbmqtA1FsHYEcFYA27aSsoUl8CzMrZfjQd0dXSgOqT1WC9Yie21KxwsQi+j+ba82dJ1wib1I6MVFTX6vwkUN3hPpcNrLFQtXbSGeWB4l5f1QL2TOWF8/RtTLcCwORAjqNpyK7A1bbqXAFew1jT0y5L7leUKdYHUvOGF5cteQSVRGmXaZWoWJAUUZTTF/TTrU9x5QrRaa9WOr6Aou5EJ84r1hchtRNnq9VVH78zGeF+ZA/PRlwHNGCkR6DZ/0Z/b9vZqKQvCWKdTJtMEKOGZN3sufxSBgxbIRtGXwZW+C4h5SIVcxnQ33oxoUPlScBZlJYI4jC2Sd1t3b6RjokHBL/Wo2KxEGFJHnM/E46+qZc+9+Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Mika Penttilä <mpenttil@redhat.com>

Implement the helper to split PMD size folios during pagewalk.
Splitting is needed if the start and end addresses are
not PMD aligned, or setting up pmd migration entry fails.

Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Leon Romanovsky <leonro@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Suggested-by: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
---
 mm/hmm.c | 47 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 44 insertions(+), 3 deletions(-)

diff --git a/mm/hmm.c b/mm/hmm.c
index 4805c88347e6..e6469ef4ae6a 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -514,10 +514,51 @@ static int hmm_vma_walk_split(pmd_t *pmdp,
 			      unsigned long addr,
 			      struct mm_walk *walk)
 {
-	// TODO : implement split
-	return 0;
-}
+	struct hmm_vma_walk *hmm_vma_walk = walk->private;
+	struct hmm_range *range = hmm_vma_walk->range;
+	struct migrate_vma *migrate = range->migrate;
+	struct folio *folio, *fault_folio;
+	spinlock_t *ptl;
+	int ret = 0;
+
+	HMM_ASSERT_UNLOCKED(hmm_vma_walk);
+
+	fault_folio = (migrate && migrate->fault_page) ?
+		page_folio(migrate->fault_page) : NULL;
+
+	ptl = pmd_lock(walk->mm, pmdp);
+	if (unlikely(!pmd_trans_huge(*pmdp))) {
+		spin_unlock(ptl);
+		goto out;
+	}
 
+	folio = pmd_folio(*pmdp);
+	if (is_huge_zero_folio(folio)) {
+		spin_unlock(ptl);
+		split_huge_pmd(walk->vma, pmdp, addr);
+	} else {
+		folio_get(folio);
+		spin_unlock(ptl);
+
+		if (folio != fault_folio) {
+			if (unlikely(!folio_trylock(folio))) {
+				folio_put(folio);
+				ret = -EBUSY;
+				goto out;
+			}
+		}  else {
+			folio_put(folio);
+		}
+
+		ret = split_folio(folio);
+		if (fault_folio != folio) {
+			folio_unlock(folio);
+			folio_put(folio);
+		}
+	}
+out:
+	return ret;
+}
 #else
 static int hmm_vma_handle_migrate_prepare_pmd(const struct mm_walk *walk,
 					      pmd_t *pmdp,
-- 
2.55.0


