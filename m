Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0D00CA0EFA
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 20:08:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11F3B8E0038; Thu, 21 Aug 2025 16:08:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CF848E0036; Thu, 21 Aug 2025 16:08:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8BC88E0038; Thu, 21 Aug 2025 16:08:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 611E98E0037
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:08:03 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2BFB3138C32
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:08:03 +0000 (UTC)
X-FDA: 83801850846.24.151D67A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id D79371C0004
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:08:00 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=d50BOTRb;
	spf=pass (imf20.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755806880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hICKs+PYshPEfoclHwqOXtWPheskj6p8LyRcJkrFnX4=;
	b=jhQdAWSJ35xNgNSxzYWGK2Ya/hbczlwQRj4t7gVGX+d0ebh8kO950IUMFPRWrcSH7WNwFq
	OPXmDFNawmaaB6CEsJWFEXLj5mcRmhoEEtM0GPMO5JpMY7r8dc0Mj+W4o6nBK7T6H2ZDYL
	dYsUxTSn53B2Sczu5YJSR/orKMsIO44=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=d50BOTRb;
	spf=pass (imf20.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755806880; a=rsa-sha256;
	cv=none;
	b=1IyBHNMDG32SDxmuJvtjFDq/KJOQ0BoYCaNV0YIpI5Olm+IDpFn7tXW/XGogxNLqhUSoSL
	S/XaKBJ5fnjEPq2WYfmIFN8Rq3tN7G3WcKJyIvqMwltYvN9x2DYvvXnPHdE7YBwuSUQosV
	B44gN0+uqV8OjxlSKVDz4WJCKcez7tg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806880;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hICKs+PYshPEfoclHwqOXtWPheskj6p8LyRcJkrFnX4=;
	b=d50BOTRb+SEcMJs+gPi21vd4ycSzxd+Hq6bmtV+XrL44+R89DB6hvtzUQNgULdNUcDSJVS
	0goysmH283RP0xKSkgdmsR0QkSU5sOzbbYg3LDOKmhcFFui3QjMGy0RNsIGRAnFZWlO5Zp
	t1fmTshP+97z+qpiYMKOo/BrfLJTrNc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-168-E2KX6wIROs68d-dl0eFaSA-1; Thu, 21 Aug 2025 16:07:58 -0400
X-MC-Unique: E2KX6wIROs68d-dl0eFaSA-1
X-Mimecast-MFC-AGG-ID: E2KX6wIROs68d-dl0eFaSA_1755806877
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3b9e41475edso915374f8f.2
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:07:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806877; x=1756411677;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hICKs+PYshPEfoclHwqOXtWPheskj6p8LyRcJkrFnX4=;
        b=XYnqo4UStnQIW7Tp/n1TWuG3LZZ/R5qdz6N35yvAu4905uXiDzLJdAHcK68CJyAgjC
         zIT1ZUSRrMgbOOp66DehsnG5jUDHlWtUJlj/2KFbddDLDAtZ7Dlo4GJjIy/LYOZ3Kjex
         2ncDmnIIiukELq+M17TCD11o86GbEHOQu3dblpTgZQu5DEzZlmY27MRyjAr/fTZKKWIr
         r5v1Kzbryf8C4yf+lNzA3vWJUM/EavFKd1arFO3xG+fBSYN0rjpyi9PMPLW6oWq2y94B
         M7UwIU+13lGk7DA6pyuFlDgnogK5aATOvq5ERqFTtFiWTYcdcjwkPBU77Y8KvaFr2OYp
         d2Rg==
X-Forwarded-Encrypted: i=1; AJvYcCX4bIIC/iH18T9uC4aO/Mb8i9+6zljt5XQqB8aL4DK6yhaVB54dFKK5MUaHGpFsSwkiQaZfbRDL9w==@kvack.org
X-Gm-Message-State: AOJu0YxdQvo9/4DmDeOqLmkUxLCbEL5wEJvlOroV8CjNDnhzeHu9efu4
	jrk6zGvScw7ChdkQUGr8xiQFgho0QJ09TjH4AS0dUhvoAou6U8RdrsMVCx1GHFLA5TOmM8L7mYJ
	68QR4Cx5+jS6A4Lq2AnRUwOWnc1Shy9vglRbZcw6/YrbxyvSZryA5
X-Gm-Gg: ASbGncthdXbmURcvCvtf+hirIc0fEfZuvePRPNrm1LNnMRBFdlVAqz6ll2pUpkk4mku
	cA+wK2qE0FH8d4kczXZ6m5fcjOVYK4fqW07IUAMdhpX/OUIIMNjg4Sh+stxQp5JOZdPONNtlElJ
	wDZRtKRNMOaAjxIuYgVr4zxLP5WhisfgYaj3J11/Q0Ilan8rrU2IvAZELN89IsLNk5IQoK5nu87
	+0tu4L17WmdOMOJGRVcWv75WHylfePap7Wis+Y2uB7V96UnZz1lLyKwgN6Yl0DXZG2CyFRJDsK2
	Y6khKAGVXkwIkai3Kgvtme2qusuKHhi91zO7dwYkIDiNC4vHbZBFWvV00bgblECJC+mTKbwH+O4
	oILMo99v8WQnaCtjdGu0knQ==
X-Received: by 2002:a05:6000:1789:b0:3b4:9721:2b2b with SMTP id ffacd0b85a97d-3c5dac17062mr195841f8f.12.1755806877264;
        Thu, 21 Aug 2025 13:07:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHgVLjhFaRrDh3LOBLGV7UmH7wFAxvy1IR++ErfO8cOP/XFU/ikMyZpM3bVU7Jjqctj1mhmFQ==
X-Received: by 2002:a05:6000:1789:b0:3b4:9721:2b2b with SMTP id ffacd0b85a97d-3c5dac17062mr195797f8f.12.1755806876810;
        Thu, 21 Aug 2025 13:07:56 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3c4f77e968esm2903478f8f.21.2025.08.21.13.07.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:07:56 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>,
	Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org,
	iommu@lists.linux.dev,
	io-uring@vger.kernel.org,
	Jason Gunthorpe <jgg@nvidia.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>,
	kasan-dev@googlegroups.com,
	kvm@vger.kernel.org,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com,
	linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	netdev@vger.kernel.org,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com,
	x86@kernel.org,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH RFC 18/35] io_uring/zcrx: remove "struct io_copy_cache" and one nth_page() usage
Date: Thu, 21 Aug 2025 22:06:44 +0200
Message-ID: <20250821200701.1329277-19-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821200701.1329277-1-david@redhat.com>
References: <20250821200701.1329277-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1-hI5qLpUDlK_pjwbB4ZoV3hldIpoaekaljV7jgWZAA_1755806877
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: D79371C0004
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: gho7xohsgj8anyf6mspfjdhcznxyr5ey
X-HE-Tag: 1755806880-496521
X-HE-Meta: U2FsdGVkX1/9HyP/EVsMZqTWWTPEPbsL53asjcSGdLpetm6ENqgi2I4I1Y2CuCHlbDGiktpIawk7zygqXCHkrOiZ/V4uGiVdokKK8zsOGrbifQ9OWEnJM+a9PQAoUxIM/PKYhR7VaeshdNvOrHiD6vDp/Abi+C0Z7XAqClRgUKFa5fgqT3yFEqw0a/YnAjjSxe+mSyN3sy15gk9tKgpIYnRq1UAD4eT4g/bYFeokXi9whA9bG9kmCErTVb1WVqmvTQzH14RS7B+TZuG+j2wVlVtEyJK5BWmebTGWie6jsLIMcRJOTjmPPoWTl6Z7qxzxH/wnFVL0Io5vE81wiApZXPyoes6L8VsBiJ1Ci3JKtVi7+EQkKgaMSS1Aimf/4DshXiQ1nFmNhIN2LxhgrjDdpW6akvC315NdFq3WZxZY4Gm6UNgcLLdXZDSCDZRBjy6APjxhttIJQpRzm1Q2e05vhKmCbjjuSnIKJqW+caA1GKlc/MG8CBhMU9eDXl5NL3MS4kBwdTxIQ+jsBgrCqUSK1/mkvliunkpZKiAdYLd03oA2zmJIjxu2gQNp67ZC2vTUaozz9kP7lFBLh7uIsEahRM+KLhL64TumvYj7kq0vFxUQk3BohDyQrN9S9RfQfZUsINfdcNIYGBp9Qf6LejhArnnLuf3uALhbVXIZ4VVQ1bf2MZNGr3cvQvVTjFYbju3llkR5P/0Z42oO/cL4tFHDXI6nuZFuIkRpWe+Pj9oBqozgzvn06TqOKTaOpVZM/FqhawNb2Be8vEXqlGqeQcem07Nl34J7ijXitm6M3gbl1UnEVb9VjrVSOUi72gGYBM9e3cLblKx/saYUQg7pW9IKtt+BIUql6i3M2UQdNogl1NR+0n2aki99vQamPh1n0mV3QyK+SP/jwECGmF4iSAmAx/ph7/Lg77XFarQVjR20Ft1P7NNaIi8jN77dTXaHdO26oXsSggl1OfUATcicftZ
 JHh47xKf
 xjhPy1gTA0KPS1duCjgKH1dl1Kw1EpzwLGd/y8ZaJ2t5SsVad6apUdaGFVIiQrYmFTETT8I44uJFjA+L3oxvQ2Q2tv4aUaUkxWTfXde/5rS26tGOnUsG/EoFB8vx+RFaznO//5g2D3qvNhhgRKkxVwwCdPvn0sgYb2p+3d8ReMsTm4A4hRK8JvKm0HgkkzKe2Bsrbgew16jACgwn+wlyNin+adfdzAzMVsOzorYE2gUxcHJgpKQdtmKruRyKxFFgC4uzfviJgtO65WqF/Fl4TSOMyw055D7ioHfIV7fXcCE36WUsu0aMFdjnYHLTbV3bDz94D/HuaNzyObUSClPpZh+ZyP8W8aWZK8LHEia3Jh3a4aF4I3LfD/9OmsZs9xAc/vTyUY6Yna+SjhzyObDtoMiHkot83v4IMkJ0VsvKhV0WSt1SnmHYoMwbmpoMQmy7+LdLFCCW0WhQ9H9rBTl+aETEMf9/i9noS0SmbNLe3M3MHZ0SPOVuqpQ9FenJHDWJzpREJvWaq4HRS0670boPDwNElj1AkfCZVDdbZkjhSUdSXh03qS7ofYkMmXA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We always provide a single dst page, it's unclear why the io_copy_cache
complexity is required.

So let's simplify and get rid of "struct io_copy_cache", simply working on
the single page.

... which immediately allows us for dropping one "nth_page" usage,
because it's really just a single page.

Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 io_uring/zcrx.c | 32 +++++++-------------------------
 1 file changed, 7 insertions(+), 25 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index e5ff49f3425e0..f29b2a4867516 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -954,29 +954,18 @@ static struct net_iov *io_zcrx_alloc_fallback(struct io_zcrx_area *area)
 	return niov;
 }
 
-struct io_copy_cache {
-	struct page		*page;
-	unsigned long		offset;
-	size_t			size;
-};
-
-static ssize_t io_copy_page(struct io_copy_cache *cc, struct page *src_page,
+static ssize_t io_copy_page(struct page *dst_page, struct page *src_page,
 			    unsigned int src_offset, size_t len)
 {
-	size_t copied = 0;
+	size_t dst_offset = 0;
 
-	len = min(len, cc->size);
+	len = min(len, PAGE_SIZE);
 
 	while (len) {
 		void *src_addr, *dst_addr;
-		struct page *dst_page = cc->page;
-		unsigned dst_offset = cc->offset;
 		size_t n = len;
 
-		if (folio_test_partial_kmap(page_folio(dst_page)) ||
-		    folio_test_partial_kmap(page_folio(src_page))) {
-			dst_page = nth_page(dst_page, dst_offset / PAGE_SIZE);
-			dst_offset = offset_in_page(dst_offset);
+		if (folio_test_partial_kmap(page_folio(src_page))) {
 			src_page = nth_page(src_page, src_offset / PAGE_SIZE);
 			src_offset = offset_in_page(src_offset);
 			n = min(PAGE_SIZE - src_offset, PAGE_SIZE - dst_offset);
@@ -991,12 +980,10 @@ static ssize_t io_copy_page(struct io_copy_cache *cc, struct page *src_page,
 		kunmap_local(src_addr);
 		kunmap_local(dst_addr);
 
-		cc->size -= n;
-		cc->offset += n;
+		dst_offset += n;
 		len -= n;
-		copied += n;
 	}
-	return copied;
+	return dst_offset;
 }
 
 static ssize_t io_zcrx_copy_chunk(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
@@ -1011,7 +998,6 @@ static ssize_t io_zcrx_copy_chunk(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 		return -EFAULT;
 
 	while (len) {
-		struct io_copy_cache cc;
 		struct net_iov *niov;
 		size_t n;
 
@@ -1021,11 +1007,7 @@ static ssize_t io_zcrx_copy_chunk(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 			break;
 		}
 
-		cc.page = io_zcrx_iov_page(niov);
-		cc.offset = 0;
-		cc.size = PAGE_SIZE;
-
-		n = io_copy_page(&cc, src_page, src_offset, len);
+		n = io_copy_page(io_zcrx_iov_page(niov), src_page, src_offset, len);
 
 		if (!io_zcrx_queue_cqe(req, niov, ifq, 0, n)) {
 			io_zcrx_return_niov(niov);
-- 
2.50.1


