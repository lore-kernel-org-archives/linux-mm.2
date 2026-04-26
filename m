Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEB0FFF885D
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 21:48:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 559286B00C2; Sun, 26 Apr 2026 17:48:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5307D6B00C4; Sun, 26 Apr 2026 17:48:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41F1E6B00C5; Sun, 26 Apr 2026 17:48:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2E2966B00C2
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 17:48:46 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E2AC51405A8
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:48:45 +0000 (UTC)
X-FDA: 84702047010.04.8615DEB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id A91C240008
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:48:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=J+sbDDem;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777240123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yr2uOCi7TxHPhFnCx38/iKRYLu7TO1I9ea6WeFSAtGo=;
	b=s/H+G5QuE1g0Rc3D8Xu9rR3ERQN/krrHUQIBrYEvH7swkaZf7SwieQbuRXfAstz1zrPw0+
	k5S3I48ICAsEH4v6LI1o+Kr3XiAjl0YGvpyvGhl9XOQldFoRoapjPJx7vdzWzBUvApBNR8
	TR9XzKQ2SY/mCMGSxRzdBjRSyMKlJF4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777240123; a=rsa-sha256;
	cv=none;
	b=iJhkzmjrb/5x+6d9Oiwb8U0VS2jZFbVOL+un5cZPMLioZLqIgMfdF77SCkg+ZX6/9sO23H
	oQSUZ7wTmF0/PFpiGf4H39hnEDjpr1l7nVx68ryya9m5j2gbBzsxLkEaMyjoNi+jqbzO2u
	ywF406Gq+OusImYYCkBsTSgfW7ZHRrc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=J+sbDDem;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777240123;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yr2uOCi7TxHPhFnCx38/iKRYLu7TO1I9ea6WeFSAtGo=;
	b=J+sbDDemBD3MheA7xfu2vBzvL87YBNPnvZXSV+xw9M+/TF4UqjFTJ0flkUW+VYG7/8ckCx
	Lgga8DiptalSWJcOIIdXEKbsPmyV9Dg3NxAI+RDcvfqEpaY5b2sqBXjLVHk4KmDCWE41dn
	x0qRRMJnl0EGVPjYaCwFLCs5ylBeG5Y=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-408-4MLdOUsbNcaFeLdeLwvvwA-1; Sun, 26 Apr 2026 17:48:41 -0400
X-MC-Unique: 4MLdOUsbNcaFeLdeLwvvwA-1
X-Mimecast-MFC-AGG-ID: 4MLdOUsbNcaFeLdeLwvvwA_1777240120
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-488d2cd2674so74605955e9.0
        for <linux-mm@kvack.org>; Sun, 26 Apr 2026 14:48:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777240120; x=1777844920;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yr2uOCi7TxHPhFnCx38/iKRYLu7TO1I9ea6WeFSAtGo=;
        b=bTgX3P+aNxh2am93DGPsvFuGVNgYwmo6LT4Mg/zwSrmPfi7hZ4eyh6yqVgVuWmlwN0
         4ge1PijhS9HjCllrOYyzdQv8257/KeQxd+DRZybN5CkluyOaHXTyB0N/imjeOK3qIYzW
         Xh2eKnqut+KXYfTk8bcT4t/QuyLXd1C6yb+i6M1Cnpmq+6LPMlwwyTZIyl+4eWfwNd9B
         Slak6MFfXw5i0xlE6OVsd0zKn/QhCVRWxfbKzc2ZQxi/7XbsVevuJwmMM3OIj8qeUK5k
         vR459mP+Lz60h4jrSt+TWCB8pR8eQs5QfQRdUIqhm0du6DuVM7l5q8OEWD9sYvHNfwEF
         U6jQ==
X-Forwarded-Encrypted: i=1; AFNElJ/yv32N3NR+sOWSOV+W4h4uFwA2VtmUlejgBlgN0L67NUN7F6BIwP8tOP/sHKNnRe7ofUq1ZcXAbQ==@kvack.org
X-Gm-Message-State: AOJu0YxztYe7ZDiFzsVoV9FGF5A7xnRDDYljg4lirv4VKUd2OsClqMV2
	lBBvFb6NHZreSAciRbuadPmDGUnHCkv7mEIip5ngamRU58keK9SYSMRmqp4iZCyEveMNfeo/UJo
	B+9IC8I0wpZy9mBBFizZRjlZr0Zasi/9PgyIoFLFhHSEZ648ldtrp
X-Gm-Gg: AeBDieu4JFcsD3wbTIz8XxxEmAe81UYpr6YMBVQHxSyNHoDEIN0JtNJUiniDjixxmuV
	U3GAF8JqqbRSh8flNy+cPlNinKtz+gUqE7eRw6oyAqNIOEmNcNb/AMmv0pbKKFBN/kDZgySEaRz
	tciM2p7ztJoFozrKATC3ca2y6gCBosegpP35P1yBXc2pBEsqvSaU+NqcUM0Nk35XpcOHwWGTmwk
	XdBnZxJp3wpBXlOIlCPP8R5skax8hiX1dDsWeYPrsHR0mZ4NkSHlcBG5hTY4vvjDuEGWRiS/DPA
	YggUDzfVGxRmilso0CQ3vRhh7oNz24lNO85wH+HgpSfSba9j2tUPLs2z+a7igSfNqrOSotbxuJK
	bYUz0ftk7jQ0xT2clKyVSeWp3xhrmtLP5Zcb/PS+20wXmUTWCRIjhFQdS
X-Received: by 2002:a05:600c:4746:b0:488:9439:881a with SMTP id 5b1f17b1804b1-488fb738412mr555456255e9.2.1777240120250;
        Sun, 26 Apr 2026 14:48:40 -0700 (PDT)
X-Received: by 2002:a05:600c:4746:b0:488:9439:881a with SMTP id 5b1f17b1804b1-488fb738412mr555455875e9.2.1777240119660;
        Sun, 26 Apr 2026 14:48:39 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-47-179.inter.net.il. [80.230.47.179])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fb7bf7besm270287995e9.34.2026.04.26.14.48.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 14:48:39 -0700 (PDT)
Date: Sun, 26 Apr 2026 17:48:36 -0400
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
	Mike Rapoport <rppt@kernel.org>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>
Subject: [PATCH RFC v4 21/22] mm: add put_page_zeroed and folio_put_zeroed
Message-ID: <111219af35c4bb357e30cf1a77265fb63eecb21c.1777223007.git.mst@redhat.com>
References: <cover.1777223007.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1777223007.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Tl_OvV1mcwfwZXX3aZV0bRzpL3ffC11bGYkf4koTEG0_1777240120
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A91C240008
X-Stat-Signature: jjbzk7suymwqywgkrdu1hkxgq41qdi8a
X-Rspam-User: 
X-HE-Tag: 1777240123-347557
X-HE-Meta: U2FsdGVkX1/c/P4NKZQboQYs/5IHyo/VMKN4K80FuOSsikEclEynrrdTS8/luEBvcusZFMCB07l0a0UDHRBR9UQknoX4p5xW/0hUD42+PTu56rrUZZyo6Xy/0IAci6LcNh09yfDv06/tzjzxbwPJTFtttZ7pNQbrwzV6RpFYMWjykTVNt85DPE844Efhxe6dQi9KvqF06XTrjI6h/OzecRquyOQENE5e/pAKjEiXGxb9GUXsIZ1tTUGPpu+Hh8JF0X1AqZlEX4NNl0sPRydBkNzmmiAAy5v7pQZuMu2OOj89bpOyV29UhoK8uGctB5t0IF/+SLntAkSskoxkZl9LzgfDntuiXWBez9XdORPatcFBr7U8nuYKWXjJGjN8mToDkPqZyeP4IyCuK3wRUgXzlbofJTxIdjYta+RfSCKytI59ysTT1gSiL3W/JLuy3Rd+x4nl7GaSF5HAiu5KhHrv/Tj8k6sfhS8BZogSNOcl5ddEbZEtvwoUXXE4LyT521r9Hc5hmVqiARPpnrlmRPoLYX1BiXZ79WwaDRxnm5ouBbJc+eopjOLZb7TS6L97nCyflkjlKD2CkjiwaczFJkIU2tbSyp1BgFDWx4V7FGnLQFQSvoicQ5Tf6pl+RonVfEMg+2l4RyYLzWPRllrcvZ7uJN3wlcWhx1+t7c5xFm/Qpkk1Ll0QEWidthdflXDoYNeQhh3zj4Vf0hQsHJdCxLssL1UIvwRdn2TS4GW3AKzmThQiJQBNs1ev+9QXjlN719fWu9FFkm3RtxnDCc/iaZmUtD+uYkYQuuGAlHHYGMdiEXMEw02xp7UMPF1uCQuhznIQqKM5kRvhJNkMVO9VdCvVr9LRx7hjBOrcF81cs4D0W/0hVHxtb+53p++JznSFeo6oKah8DoY0ePOovU8VSmjqhHby0qGu7mTESmzrPt48vpNQgLT2L5EUj36gdJ9C8nhyMpdKK+J7xZadMeX0loU
 nxK2cFET
 IpYvS4d2MzwaitAA9RbqPRdbSJz52hR2p+buQSEn/WcnscVhuVtoHW9PJmBAojwhXYHsxFJdm1TJIbJbbr7wparZL9big7Yjx2rhSiEuqAOz+VLSsX5mIIBnCgc9rGN6Y3fEIuGUDUEDk0YDJCLsJzdK+A+/T7+ju+QiIvfyvoJ8n1G/v9tF1bAO7K0HRJU48U4Lu1qngnU01QsIcGxSlqKwcDNAKQvGSIM9PaoJglhAQOsmVfaQXw4Tw6WNAoWdcbIJNbhaFep0ajw9XW0ieVPzY7dLnziBKulivTpPAVSAN+jYt0tQ0zuqjt3FQkrcNKhYAZgCBcukzUs6rNbx8pnWA3pXWAA0qllpBVsNi/xgURqKVVzru4Z600JWzxXSdES/8NcVhXxU/6GNlmpaaceXd2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add put_page_zeroed() / folio_put_zeroed() for callers that hold
a reference to a page known to be zeroed.

If this drops the last reference, the page goes through
__folio_put_zeroed() which calls free_frozen_pages_zeroed() so
the zeroed hint is preserved.  If someone else still holds a
reference, the hint is simply lost -- this is best-effort.

This is useful for balloon drivers during deflation: the host
has already zeroed the pages, and the balloon is typically the
sole owner.  But if the page happens to be shared, silently
dropping the hint is safe and avoids the need for callers to
check the refcount.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 include/linux/mm.h | 12 ++++++++++++
 mm/swap.c          | 18 ++++++++++++++++--
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 541d36e5e420..1c6bf82a967a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1640,6 +1640,7 @@ static inline struct folio *virt_to_folio(const void *x)
 }
 
 void __folio_put(struct folio *folio);
+void __folio_put_zeroed(struct folio *folio);
 
 void split_page(struct page *page, unsigned int order);
 void folio_copy(struct folio *dst, struct folio *src);
@@ -1817,6 +1818,17 @@ static inline void folio_put(struct folio *folio)
 		__folio_put(folio);
 }
 
+static inline void folio_put_zeroed(struct folio *folio)
+{
+	if (folio_put_testzero(folio))
+		__folio_put_zeroed(folio);
+}
+
+static inline void put_page_zeroed(struct page *page)
+{
+	folio_put_zeroed(page_folio(page));
+}
+
 /**
  * folio_put_refs - Reduce the reference count on a folio.
  * @folio: The folio.
diff --git a/mm/swap.c b/mm/swap.c
index bb19ccbece46..5d05a463b46a 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -94,7 +94,7 @@ static void page_cache_release(struct folio *folio)
 		unlock_page_lruvec_irqrestore(lruvec, flags);
 }
 
-void __folio_put(struct folio *folio)
+static void ___folio_put(struct folio *folio, bool zeroed)
 {
 	if (unlikely(folio_is_zone_device(folio))) {
 		free_zone_device_folio(folio);
@@ -109,10 +109,24 @@ void __folio_put(struct folio *folio)
 	page_cache_release(folio);
 	folio_unqueue_deferred_split(folio);
 	mem_cgroup_uncharge(folio);
-	free_frozen_pages(&folio->page, folio_order(folio));
+	if (zeroed)
+		free_frozen_pages_zeroed(&folio->page, folio_order(folio));
+	else
+		free_frozen_pages(&folio->page, folio_order(folio));
+}
+
+void __folio_put(struct folio *folio)
+{
+	___folio_put(folio, false);
 }
 EXPORT_SYMBOL(__folio_put);
 
+void __folio_put_zeroed(struct folio *folio)
+{
+	___folio_put(folio, true);
+}
+EXPORT_SYMBOL(__folio_put_zeroed);
+
 typedef void (*move_fn_t)(struct lruvec *lruvec, struct folio *folio);
 
 static void lru_add(struct lruvec *lruvec, struct folio *folio)
-- 
MST


