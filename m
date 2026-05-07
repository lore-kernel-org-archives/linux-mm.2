Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85890CD37AC
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 22:23:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E446F6B00DF; Thu,  7 May 2026 18:23:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF7796B00E2; Thu,  7 May 2026 18:23:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C48ED6B00E3; Thu,  7 May 2026 18:23:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9D7686B00DF
	for <linux-mm@kvack.org>; Thu,  7 May 2026 18:23:43 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 64FE8120448
	for <linux-mm@kvack.org>; Thu,  7 May 2026 22:23:43 +0000 (UTC)
X-FDA: 84742051926.10.F16FBAF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 27F7C1C0008
	for <linux-mm@kvack.org>; Thu,  7 May 2026 22:23:40 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dUyeAGv5;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778192621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c6IynAVVs9vsrhP+5T0GREErRceOWiVny1P8BCgsPGY=;
	b=DLhbWWrNGwDr6k0L21RnNajN35tI3IsT1NVUg9kdlF3QZs9lIyLKuOFPun8VD36M9cHzUS
	cbxAeYUzWtPZ9WSj17HLWlu2onces5pZEP4lEBbmVJjPIruHHE1ZL+28EITeiU0SopMa1h
	ihDG1kg84LBY5zneSiQ7H4Azjkpe9r4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778192621; a=rsa-sha256;
	cv=none;
	b=Ett0uFrrMFyxJ07/OJzzxCC5xtvxzdTC6iJcT8RP6s4OoSo9xlJk2ou25OGJCBIZO1l9mm
	RGWZ29jWcBwcntaa96r0XRHUUn1I4CGhz2RLjum0U16Ub9tHjHTPrFvdnJeeX6juMBq8KF
	l9pb7BhggLoQ90Upj2rl5o/4nJY2U9Q=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dUyeAGv5;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778192620;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=c6IynAVVs9vsrhP+5T0GREErRceOWiVny1P8BCgsPGY=;
	b=dUyeAGv5a302OmVGc0DDfFCVtV9rcxjHyfhXAOiLUFGd93X+pXOcmDNfjvwgLd9WEX6Pw2
	B+D+saAggXaRi4jfz33uaSYYZGcoRQFEfZDCeNX2/3If6afQeNev7+zSCgCWOzplcptdan
	6AgkM1inuNUWzrjK2JnMKbMdall0kt8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-681-9eEkpwaJMCmEXcdvEN1nBg-1; Thu, 07 May 2026 18:23:39 -0400
X-MC-Unique: 9eEkpwaJMCmEXcdvEN1nBg-1
X-Mimecast-MFC-AGG-ID: 9eEkpwaJMCmEXcdvEN1nBg_1778192618
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-48d121738feso11288015e9.2
        for <linux-mm@kvack.org>; Thu, 07 May 2026 15:23:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778192618; x=1778797418;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c6IynAVVs9vsrhP+5T0GREErRceOWiVny1P8BCgsPGY=;
        b=IZKctw2v/OwO8apzszRkoB9gn2MmosUpb6poOng5REl0TIYsHtw0HoziICDXZItL4D
         RXaIELrfYoQQpVX9l1UXy1mPjvNGJCDhUfVGpWY9fhGfxjzPtiOAjYQNCbOO/ZYZgiJs
         vowG7OWueQDt2lGpt3YPDncaue9OkMbnvGZp2pSAj2hLVmaVAxVvMidq3jqdawcpFJ08
         D81XGBtOG/ZZ5kFaiG29Eo8937VCBz7EXcWQ6eWjHaw5yY9FXRgJ7Ly8a1fjJUzKjf5n
         9dOjr8lx3tmgvNoDzE+olhLDobgLHT5lCesSzlyPQKWB4NipYGdL1WYabV6uLDM6bbhN
         kZwA==
X-Forwarded-Encrypted: i=1; AFNElJ/D+WSXO0b1DNWtIfs+TesCsqFFdolaiuk91Bceidwo65kXR7EpPW7tSH7A5Ak/Z1jzc7lqTeIuyQ==@kvack.org
X-Gm-Message-State: AOJu0YzdDU3TpvEBIekNegFLDcLLT53ItU8sDlahakUHSzGNICYtlAwo
	oYjS0YkNKVFomNBSudP/ZMB5slbEyMhNDIGfvlqyl5uY34WhOtMne1Z7reh7/F7mfF8xgMHSJyN
	NzWfNs3PcqSuASw/keiWtujRDyAV/t5hLi7CGSvqH2GeeAKngC8eg
X-Gm-Gg: AeBDiesryx+v/2HhiN/X5QwUmL4+bDGEn/AsP9tvmYlnR4CXFrqnZbu/2eimXY1VY1c
	YKsC/Ut8p8cmF0GPlFKZqGjQaoLStBQt2J6Vww+vnI4lj53HMGJ/YNil4NObeR2TClD6ENu4UTe
	g8NeJIjpdg5AJs5I9n/thiBUR16uoGTOY1SDAOgyR96ztaF0F16aarnDGVt7j7UBXIsjvtGsJ02
	PPFZLnVOT2WEBZqHhYk4c3m6DyPb5Ur/TSHLJngh0fygt5rURG9dgROvBWYBILU7o/sq6fSnONB
	2AuNw8GiqvJLNq5XvITpCsghBOaxt6f4fDrf2t/w8UpJMLUrVzOWZK++LxBvV0g4rht964TGVVs
	9lVSNwv/mxwoKaSE9hNCuCTgZAFnICoOZAfApEweH
X-Received: by 2002:a05:600c:4592:b0:489:1ff1:74d3 with SMTP id 5b1f17b1804b1-48e51f3c4cemr161117625e9.20.1778192617931;
        Thu, 07 May 2026 15:23:37 -0700 (PDT)
X-Received: by 2002:a05:600c:4592:b0:489:1ff1:74d3 with SMTP id 5b1f17b1804b1-48e51f3c4cemr161117185e9.20.1778192617352;
        Thu, 07 May 2026 15:23:37 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e53895effsm150494415e9.3.2026.05.07.15.23.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 15:23:36 -0700 (PDT)
Date: Thu, 7 May 2026 18:23:34 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	linux-mm@kvack.org
Subject: [PATCH v5 24/28] mm: add put_page_zeroed and folio_put_zeroed
Message-ID: <83ca7d34d23392d2c830e0417b1d38afbd23fb56.1778192416.git.mst@redhat.com>
References: <cover.1778192416.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778192416.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: uucvPy5cb1JJ_AXV7xAjI-xrl8Th7KYPYnMYEuffqyA_1778192618
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 27F7C1C0008
X-Stat-Signature: sfx4c7c6mkinousfxx7fam3fogf7gop5
X-Rspam-User: 
X-HE-Tag: 1778192620-534985
X-HE-Meta: U2FsdGVkX19J9mExwVLNsXVoBFDWykKbaR+kZ8ewHAsIdWxaQ3guxPZeDDXsV5I+bjK3RJTXzHRvPaQK59MgsVPzh7/V2fBczog6AUMX0d1KbYuYvDwgSllTOXYDsbq1OOYxB4grs1v+1sa24X8ty/CJkpi/0AWkiII3GEZPtwuztj5ut91XwIHwnizvtxDVVt3jXwyNekuP6NXAclW6sGq5ph5pVtHrO48QmvO+WQ82fOYTHYBQZYZ6nOla3KnjnbnAjWsp0O708pKNQASQRt1bPJ9Si4y0zIVdHxVDaG6n2vm8yAkQiSnUY/SW/PpoZmhqzNxqY3upWjsTj+Mf6Q4zx8d7UZlUZDYj0bmeFDQ7BhlUtJDmiGaak4YqCsRbruKNhk9z4SqptcQpTYd8i5c+TN3qsTLjzq4FTRWFKmJoaICB3EBHaKLvaN84BHO5zGK+PEPJ2+aJTK/h/OyuPa3c4c2tbyEzS4zgRQeHP7O6RlMmSctEuwuFNRiMHb38c36XNNlii7JH/OEu6GhR9OwtqUAEwAg9SAs+5+/9ZYCSt3IOnqwewn5iB/HxfEvffTX/0OTw9SNDDbz9L/g/hil4PKQVLpvE3uVfVLVIrOlawhR2R054jIf39cAdDrpkor+7PA98gekB5tcrvX6AxsLFc8YPud0U+qCxjwJMLFrKUMKadDgLv9Xobf4h2AstTBk5zclcwBw8/RhzwiI7m8Uj7GWv2N26MWuoU1exJs8iBvBYoBVVcwu6uMIKiWcUwlPyXi+o+Y3PbASFTl/gFJso5rj+Icbq67D5tu1wsMUZ7Zjlg9moCyf15UdtfqX3NHENEKt4bgIKuLbRp4HkBy6HlBytvFIAKWGkAa+YF5A71DqpsU8zJTyAHwrOOuNGo1glOfhbcXqE9qRrlK6ie5Y14a6YGa4ZvJpLSVYIb9W3UgRPX0I5/RP6cIwpjk6iRD0DO6Gp1uLnDeBHQAz
 Tmiv4nVA
 86RRYdR+oux7R443gZhlgMpTIsvi4zyfHHv7PT2b4W+crjM673OujP5RsS4zUjQAFBy1LLt89SZSIHNcB1djDLsjIpy5ZDxH6mhn2j9IlgKKwKBl7KBquslFD5EM2verS5cN+HGN4Pj5b27SMnzGjVdLEBTssMbh3j9etKWYr9TiIK/+viLZLlV22JKp6jb/HP77itP+SkuC6wyCLqB3migmOTyZroHBS9y6DtuOSF49cD9IelDYfSDKoRz5rYk2qWpJI1rHU13pHFwCp90/AJYe3nXqLEY44it1Oc7MCWg7Ww1BacsGciGFFEjNLUR887Pj9j/3NX6OFbAJqw/2xttuBVQ5/m5EDgZguzdYi0AcwbzNZGoAD1QMBvRfHxx0oSNkCboKi3Jhrh/PJZ8qPdDMyiQ==
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
reference, the hint is simply lost - this is best-effort.

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


