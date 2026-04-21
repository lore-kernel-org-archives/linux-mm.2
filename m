Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E57A6F94CB4
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 22:02:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52E036B00AE; Tue, 21 Apr 2026 18:02:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DEA56B00B0; Tue, 21 Apr 2026 18:02:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CD3A6B00B1; Tue, 21 Apr 2026 18:02:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2AC126B00AE
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 18:02:14 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D9FA1BE4A3
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 22:02:13 +0000 (UTC)
X-FDA: 84683936946.06.6C5AFA3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 94D308000F
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 22:02:11 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZkKWhXWb;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776808931; a=rsa-sha256;
	cv=none;
	b=kXVHOHICA9ZuUFj4kGQdf2GHNFjEBsxXwRpIMBwil1efGlwG/uM709TYvSGGPxXIM0jbOl
	15DUL9Kw9stgxGH215GKqDSH/bMOQR7PFhfNk4yCYMpaJ3vx4ZZa1cMKa0Qhkx62a3HFME
	olNq/hDwDWsJ2yq4JhGJUEoOodEXy4Y=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZkKWhXWb;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776808931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b5ITR8zgbYah+ZxSMqe409RlUP6fQP6IKxEaDIol6Sg=;
	b=hlONHVStNhh9qz0XD3ZauXcVYJWQE9z/wtzgUzca2rszeDsFZmeOkDi4K6wSFzZy/q0ZHU
	WZxbaeOJrQs5CTPK8yX454jojhkuStildsCJTaNLJuFHzKmQdT82q5vPRSBVtU9eRorBJ6
	O1vp1B94rXg90xA3IW5r5eHPYXLLyHE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776808930;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=b5ITR8zgbYah+ZxSMqe409RlUP6fQP6IKxEaDIol6Sg=;
	b=ZkKWhXWb0Y3TzEDpEbSGliUNPYLOxxRqI+lql9xqqcxpZMWluk3iIiaaCidNTIOoKdKu7I
	ju0vm7mKjviRFbAfqn+UqbPTuvxjjufI30izfSnWY/H0P/MD3r0o9pFgSmDgbT3ZZmNpxg
	KTYiRHr8fiH4aB+XzjeksTvmfU32NHc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-661-7CmB3pNjMWy6hwoKmx8Cvg-1; Tue, 21 Apr 2026 18:02:09 -0400
X-MC-Unique: 7CmB3pNjMWy6hwoKmx8Cvg-1
X-Mimecast-MFC-AGG-ID: 7CmB3pNjMWy6hwoKmx8Cvg_1776808928
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-488c0120047so26448085e9.0
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 15:02:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776808928; x=1777413728;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b5ITR8zgbYah+ZxSMqe409RlUP6fQP6IKxEaDIol6Sg=;
        b=DLSa0R6V9E78F82ndUuuvuouqXyZHmHIm6MD0nHiE+3YKgC4bOkNt5malyi0kZAmXM
         dpXGqfqBmDxao8SZ2JGYsh+5bwJqBYfVAmq8i6NfsyTq6YovbZI9X/2E0AUnH5Sq9/s1
         94YDk+Hz8sN3T8946sxySk3ZtmqDRJCb9ngriGv7fvNdMIsCMFwUOcaF2NI+uNhgnpUk
         /HM3V7Y52C8hwsogF4A1NuyJWCCsc2hUID/eUlHAEVV4X1Mmda2lj7b06urYTfGPNseX
         pI4WKg1IjeqyPSKp53zKHSJ5DkkBbEaw2+Ft2qRhnu/lqKryDfzn97tnGzesirP2GJtF
         Wfmw==
X-Forwarded-Encrypted: i=1; AFNElJ+QOWGQq/SBLKohEZM9cpAyqcc3wtqVP700n5QWPIkEQOTtL5euAU7J8ebrAuucvRHtdVojeeiBNw==@kvack.org
X-Gm-Message-State: AOJu0YxxiFS2Q+zTVzxWUfZOAiwdhKNxtsltwtkbqgd8xMbhgKaF+L+b
	C0rv/62VrzWQgVYZzKb0+VtO+dBnW7QbJeItHJBPyasjSa9OFPxeUGD7e4G+LpTJOtCtJhKYQ+C
	IVC8xMpdaUh9eIy2Uobx3xfMC0CxPn/D95HJEHSxh6vuSUz3CPNwn
X-Gm-Gg: AeBDiet7LYja/fEckbTzcrzO+srXG0N6Od0FxAp3zrne6dSKvjBDqUknren/ek3O2va
	rMwwiv5tRIrWIssvzzZ5wfBxW7QkiulF5XNNOQRHwCUrKUp8Ue8wvr7rftra+cZhX/5W/HXa9fr
	1SlvQ/xmPqXEAcHPZDzNDu5Zlh8zBrIfjbF6kVfIayqdzwD6HkVpY6A1OO4zLw7u/F7WxbaiOtq
	iijEsg5d0KLVIN5Sd/0RQCeUi5l7KDIDHVnKlrQtRukblZGnljYi4viJtrKUI6HJLB90FYqpXRq
	4jDlx97SfzYhS9rnMuvD93uSOtnWgCnSS0hTajLr99qeWKTxt0bnEpyqa3dDZWnBL5ompiRYeBZ
	L6gsd5GKd3z9LRgFDMMwFdmxolJDQSGmb17BQYE9A3JdCe1jlAlKQKg==
X-Received: by 2002:a05:600c:1da1:b0:488:79a3:f04c with SMTP id 5b1f17b1804b1-488fb7863femr300220425e9.27.1776808928260;
        Tue, 21 Apr 2026 15:02:08 -0700 (PDT)
X-Received: by 2002:a05:600c:1da1:b0:488:79a3:f04c with SMTP id 5b1f17b1804b1-488fb7863femr300219935e9.27.1776808927735;
        Tue, 21 Apr 2026 15:02:07 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a5549f582sm28914685e9.33.2026.04.21.15.02.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 15:02:06 -0700 (PDT)
Date: Tue, 21 Apr 2026 18:02:03 -0400
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
	Mike Rapoport <rppt@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>
Subject: [PATCH RFC v3 16/19] mm: add put_page_zeroed and folio_put_zeroed
Message-ID: <d06416b80bb505e8ded9f96bd28f0a63678e4a97.1776808210.git.mst@redhat.com>
References: <cover.1776808209.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1776808209.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: EB4pcgFoaJqCWbczx61mdKDfTL8W3UDQD9pOWILREXU_1776808928
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 94D308000F
X-Rspamd-Server: rspam12
X-Stat-Signature: 6bjk95dhybiidufou3g3rfmcsswoyqu4
X-Rspam-User: 
X-HE-Tag: 1776808931-52085
X-HE-Meta: U2FsdGVkX1/19+TPdF5iqWM11JMoBUjUE072F9VEc9/+eyZF9kdZqNaDCKdjqAc7n54lzuWF+NQPnF+Jt/U/aSKJAaP9ixzVWGYPZaDaHLQ1G5ZA99AoBioCh3XlvjpsiLN/OXJaxGA/WCpnhTQiEJLaNAhEu+7AUTpa5f1Ms7AuhApzY73oSISVM+WhoMYbua17E0nIJEGFbWSrr6rG8xJ+SGoqV6QrJzTxWxtzhFqZNio+uFnTXg+JSiCnGRBIqc7yr+mjMDpgM491X7tfSmy+xDKOSTBqEad9fXHqzuN6g3Ep7iORma+fVhEBIjM1b0IvCJH6no0ZtKaxDy/0CsdExNCzrV7f+lzper+/+bf2eSTlpyhmayeJ3OhMI8F7TSQPEuM2qkZvHkgIMq7PwxoOnRw4uxUKaDhsoW9XhrIvA0uJdKfSwt8E+IzMzDGE6C5lXavpHPD34thswCC8NqlxqT01zqkW8RjTSSF6UcXhL9OfU+BkWWsSjd5XrE9Nzt84d4FwVu8zjliA4jrrKAKD4Yp+c9ep/0rvA/phDhM6uhNaUvxlUiOQr9GowMTIXvmDnxonaTjfNbSrm4lHcBL96wA4QSWgO2RYKQMrbEjQEHNFbRvKkt2JmPQhQm2aBPX/5PUxPQpXTz5x3PeITE8gTwzIEabNfKhHS2KkUK4WmPX4MJ1GpdMkOeBHTQkCsdBEKwxbD0NLa1la0yJY8p0bzPV8+OlAgnTFqqyPZufIeX5qqo8jg4mHMeWFDu+AWfDFoqeG/uLEgbivLHNmxvtqvDEjCA0H0Tz23obyM5b+vfzXIp2J7jOcDxf5qEfOsHpvFmiuFpvV7gWeKsIPC0HJJxwWZ/NgxvbYrmP6JtYhovfNE85sMSPNJTFTE7l62TX69Hs5+XB9Ft9aKEYPoM+5r5xZJwbj4bz9yK64ashBMYsnbrsFSoq46SgXF8idRJuW1f0ick8uxGtXwl2
 tkeT9Rev
 rQ5xAYiSt9WXLfQDj9zoxvM27i1xNwLVqjDV+JmwYJ6aG6pUpkPWIQ2CLoYQIZw4ewHXtEiP4xaW7mTU0fcoHkHirOIpSHDwk2bb6q+eLmo98lywAPiHc+u39p1fpUclOZfo9kMQ1CW9DU2QHJEUw3AzvMB8fILJTSNS8RUFTdjn3inH1L0zpgmLoXr/7bQI6V1kvcKIT1dj983lJ/jbZQjSQ4WbR7A33xNEslTvJH71VWnHhgQS+Av1tLun8QOcvGQadldG91Oj4hxLTUijRe/TapI/hT8SAR7pc7MnuRDKG1dm7Y+Aq6/Ro+zFe5kBze5CfYgNQpuepej67kf8P8w48LdYa8z6ah2HV1tMq+wt6pDRq+MYHgHjYe6FMg0s4jiFMvzvlttf3dZ448kaMPyL32Q==
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
index 821034dd33d1..878544830369 100644
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


