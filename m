Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DB59CD37AC
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 22:23:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 717986B00C2; Thu,  7 May 2026 18:22:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F07F6B00C4; Thu,  7 May 2026 18:22:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CE436B00C5; Thu,  7 May 2026 18:22:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 36B446B00C2
	for <linux-mm@kvack.org>; Thu,  7 May 2026 18:22:59 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EE8654065C
	for <linux-mm@kvack.org>; Thu,  7 May 2026 22:22:58 +0000 (UTC)
X-FDA: 84742050036.05.97912C5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id BBD04C0002
	for <linux-mm@kvack.org>; Thu,  7 May 2026 22:22:56 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FnU9HIEm;
	spf=pass (imf28.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778192576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kz/3QoaXGDemZuo9qs/jsQY7mExo5lZjuRcNC3I0rZE=;
	b=XcHn3kG7yc4/+eW2wbBbBMVngUYWIkhAaHVjpGa113FhJTI//PFbARXVRL9RxbXW17+NNE
	QnhNIMlWslECMjo6QBl4KOX6V7OJhhGzKu6eIhYn4hTCSBkknHM0mpLgq5b1V3x/4nOD3j
	xgH2wLZwTayuq/utzp+KIiLFawJk2ys=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FnU9HIEm;
	spf=pass (imf28.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778192576; a=rsa-sha256;
	cv=none;
	b=WtrFX+t8lvHvzVcvguGH7/i+wCCT/h2Bon/3rXkBUxcKaninclTYUSfuOgLmSFSHh1b3gd
	u9ShQpPPW8cPhfEbkEHghdp/w6RkOBDj/amZKPnudta8S0lAKDxnBjSh484osp4abF0r9a
	aoWUtdFhF4+GBefUsHwSwxNcicI6E/U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778192576;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kz/3QoaXGDemZuo9qs/jsQY7mExo5lZjuRcNC3I0rZE=;
	b=FnU9HIEm0Sr+ykFRBv+KUQl/jcTU8LDDUe7vhKIIcRUygKzkSnlXavAGyV6RaldDPFYxBj
	vW22YWN3OmomGUAoBcuFinF3lCQY7mPKolm9y47a60XjTp+8vTm8izVU0cIN+y3F69jmY4
	CD2lB5dRsTBHuGN1HfiAm9PukHm1Sug=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-58-pqkXQNTbOLuEOWCq595q4A-1; Thu, 07 May 2026 18:22:55 -0400
X-MC-Unique: pqkXQNTbOLuEOWCq595q4A-1
X-Mimecast-MFC-AGG-ID: pqkXQNTbOLuEOWCq595q4A_1778192574
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-48a55de6fb0so10693265e9.3
        for <linux-mm@kvack.org>; Thu, 07 May 2026 15:22:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778192574; x=1778797374;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kz/3QoaXGDemZuo9qs/jsQY7mExo5lZjuRcNC3I0rZE=;
        b=SQCLM/veOYfFBaCJglbgSla3Qe7SH/3bOV1D5XiViQs+IpporSxgrtXa5kMny7F2wn
         F/AQryIcOknTWz/XvppZsoLSx785l9XUQUB4xHlTU0KY1nAnz8/EC8DLhiOnNqQBH/tU
         QmVmKyIhnTXWtmuEbmcvJzu6RWWQRLc4ToWeqf0JB6YnxPI+6NI8tzVZ3DarrwDVeShW
         UUUg0MvUukL9GMs4vBS78AmgG8JcRHy3NzJPul0Ss0vApDGS6vlxEDQm3+TdqFpDEz7Y
         ROz2qigjnXrVVzBQsV0PPh293PMwGyTQ47vNwfJD2vxPfrY2hLzeBtCglFxF84UNR3M9
         EXIA==
X-Forwarded-Encrypted: i=1; AFNElJ8RzqahXAkruKaLsVFfX+tRlV6YoLBZ1Mz9EzaDnMf1yb+KweyKbmFQRs5K9ECZAWCC9YjxDyocvg==@kvack.org
X-Gm-Message-State: AOJu0YyNRS9OoWpCNvlspmrhw1cV/q4ErI0YDV/LM94hbiBfiiSnvAYc
	+K6+AFfpvexq1LmXA3akXGnd9Gb8O6spjVBAJJTSYvtGKhj13s9P5ksOyI/CB6H5R1YYBnkN4U3
	b746cJhlpcHoqQtWUkfAtDV9Y/mT4dP25RXuSfVTNDWQPzOxFQ1XY
X-Gm-Gg: AeBDieulww6tZ3b63rbNcPQU+T5jLixtYem4cGZXYx+p7VJOuCJm3NDA0vS5O8Jqb+W
	PMn9RwSDumVwf+Be2j77tOaCnWdp7Pi5U8yDW2dTbW2sseBPPeWJJ1uvOPUDuyCObE5nuUmUm17
	5Q/IxFuF4/Vnd+EuIDONVIj7fbJlJcq5A6P/XZM70qZKULTgl6h0y7/3b1xRipu8fpAZMWHiQPp
	QsZ6AGNh4PE+AaFp6vzvKYWZxFnC/+cTckcwuZNRa8/bkUG2JHiXlcsvluutwe+9jioGW5khNjx
	/fLBA1ow7falVHWcFCZ6U/VnSp7oS1BBAZO6yszqMk0YPnYESMwtgkNPB5o6E0mUI0ilW/+tUtp
	pci8VAx+aatT51WpfSF+/UM1xKQUImQutA7A+kIiL
X-Received: by 2002:a05:600c:c094:b0:488:b14f:b8ed with SMTP id 5b1f17b1804b1-48e51dd89ffmr116909375e9.0.1778192573728;
        Thu, 07 May 2026 15:22:53 -0700 (PDT)
X-Received: by 2002:a05:600c:c094:b0:488:b14f:b8ed with SMTP id 5b1f17b1804b1-48e51dd89ffmr116908985e9.0.1778192573187;
        Thu, 07 May 2026 15:22:53 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-454128207ebsm1463589f8f.7.2026.05.07.15.22.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 15:22:52 -0700 (PDT)
Date: Thu, 7 May 2026 18:22:50 -0400
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
Subject: [PATCH v5 08/28] mm: use __GFP_ZERO in alloc_anon_folio
Message-ID: <d6bee28faa05d3779baa839bb141360c2da849d5.1778192416.git.mst@redhat.com>
References: <cover.1778192416.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778192416.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wCRvrcaHdkvk59CX6JR8NrUKjc8sAMqQqVx7clGTYXs_1778192574
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BBD04C0002
X-Stat-Signature: qthmwht1bjta48ooaknwr5wwpq6gwh5a
X-HE-Tag: 1778192576-451132
X-HE-Meta: U2FsdGVkX18RXk4bXvSnTuuEAhs6fTFqeyla9N4bnwQRqXZWJ2rmfnE32BjMWut0qC6OyN+811Nq9/BeFEO/+X4gTC57bs8Z6PxRJ9NVm6FCI6lcsupFwOCT6WZblTU1pQriyLis6GUt9A9RsCvQGst2WS4t5VaYbE+8fT3NSpoGseB0bUq7EWMYvGQLYDq9Td1a+kQZdA3zY6n3U+K8xq5UJ70dH2KReW4R/VdmdxR1poiXXzRl4yC2Y18K7zEY9P2tbZ4M74AClopUS7mFHgWFAZ56XGRvGQmvdNLIM0eW7+9kctH0kxq0t4a0+oKoeC1bGWYk0kjPnaNi4QDoOmAfbCj6g4nD3m4G+yq6xO/DHphb4fUK4L99vS7Zv4DH5FSy+XwLTbjqA5n5zd6IKwswLQQyytJ//WoZQh+qj0YUHcAZ7RUsmomiNJnTPdGm48rr0i6iSdfpWJ4X4HqwB4aY1sURm9innWPO9quEIatDcywS58PCz7CTtmsrI+FyZzLGlTFT2ULwHNqoPZ2WJTTGPZh/km551kdNRGZ9uNJwbMaJbHEEnMn2LndA5QIKrWsDwASS+IcXh1nXdtYac7EtnE+lz0k3z7iLNth6uQ3Lzs4HXBXGoty1XiwkP73gsNfzt0ifNYfFpI21SDCdKiPnEfmGGoKOJgAhhl80rHv1gzbAdkO1vLVpv0vBlcEVcs/+kTEzEADTz+1v2z7T46HO/E/HAeBonoZofpTiOmbF3Tmr4rSnjcjK4X4N/TksKSxrRmc5qBb3aUid1F1FzY1swbabXOg/H94PDQy58wd0KIbIx/OPpURaay0/W/lrtBgbkzt0xB3W639ES9ig9TdvtN2anoplOk3P6liM1fjNjd/b0/teXT296ss1IHogVoPeD4tAEdtSZq+mwxYILHxd7/elsBpES/zEkE7SPJDLmqkUfPd9qiFjFlx8XDXrws8+0i9wCBIAWm6OtcJ
 8DjBNl21
 jWVyHa2s06gMvnJ6rUiYw7oVUsm663MtXrxdQV9XOfPPDp0QyXhJRkv9EpSoKZOGf2CI0rAUXzkWHbk8hWXhKk3j9NJ54vevvf+Ht/DhfeFCtEa4oyKToE6ycY8leMaRfUGWorDYtzmXNq7FS7MC4dLx8XygWm7Xtvoe61RtkU8uKugmpoXvyYxGWYF1XlAI+mJnK7R7yQC45R8WCB+Z60LUTURTBFpFPZf8twrbTttk5AGGFhiX39C+KaechuiINfubRx3vrFdtxtDnRBzBhB8gB9Udd5Vu/ighRSiDsn+In4AhTejZGY9HOJWE3ryIXi/CKMH4Ebs0tfOXK65LibfmCfnAwQAwN2uT3PGwHcSpLZL+IzngRNl4qyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert alloc_anon_folio() to pass __GFP_ZERO instead of zeroing
at the callsite. post_alloc_hook uses the fault address passed
through vma_alloc_folio for cache-friendly zeroing.

Also convert alloc_swap_folio() to pass the raw fault address
for the same cache-friendly zeroing benefit on swap-in.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 mm/memory.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 70ab8b3e3a29..bb24a14d97c2 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5175,7 +5175,7 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
 		goto fallback;
 
 	/* Try allocating the highest of the remaining orders. */
-	gfp = vma_thp_gfp_mask(vma);
+	gfp = vma_thp_gfp_mask(vma) | __GFP_ZERO;
 	while (orders) {
 		folio = vma_alloc_folio(gfp, order, vma, vmf->address);
 		if (folio) {
@@ -5185,15 +5185,6 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
 				goto next;
 			}
 			folio_throttle_swaprate(folio, gfp);
-			/*
-			 * When a folio is not zeroed during allocation
-			 * (__GFP_ZERO not used) or user folios require special
-			 * handling, folio_zero_user() is used to make sure
-			 * that the page corresponding to the faulting address
-			 * will be hot in the cache after zeroing.
-			 */
-			if (user_alloc_needs_zeroing())
-				folio_zero_user(folio, vmf->address);
 			return folio;
 		}
 next:
-- 
MST


