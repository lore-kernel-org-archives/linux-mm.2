Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1625CCA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 20:08:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 457AE8E0036; Thu, 21 Aug 2025 16:08:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AF0A8E0039; Thu, 21 Aug 2025 16:08:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F01D58E0037; Thu, 21 Aug 2025 16:08:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 088488E0036
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:08:00 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CA9DF140528
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:07:59 +0000 (UTC)
X-FDA: 83801850678.18.21F6C1B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id C1A1518000D
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:07:57 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="FEc/ixVI";
	spf=pass (imf24.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755806877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NPs2EdTZ9fd3MpWdb0ATDCa6nUqfGtFMv2uyZP7L+uU=;
	b=n2pVMxiKKbzOHvwg/o28QHUEIIx/0JGTjrBiXmaXoCu3pT3Fi/AtT+wMNHs2S7AGo3jgUr
	s9aNjdp8/XKAW0PC8aUDCCZA0/51YnsMLkkKDmmPlqQQi+zgKMFqAMPloxZwCX7oX43Cjm
	RTcWPYDYICdeLNcAVnC+2/IqBC0ocLE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="FEc/ixVI";
	spf=pass (imf24.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755806877; a=rsa-sha256;
	cv=none;
	b=io7jncGFkgVlRORiACbeSUYHELcN6J9vUJimLedx8xJQIN8mEe52Cm14sp1al+q1H+KGTH
	Q9zbsQC2bvD367ZQAlLcvd23WepplxWxQI/swfq8cEpDhaPnp9X6PmBd6ll3TEkXQeM/Af
	4KSSElrW6VmhE2D4DZ7ikGFQTPuwxOw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806877;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NPs2EdTZ9fd3MpWdb0ATDCa6nUqfGtFMv2uyZP7L+uU=;
	b=FEc/ixVICnw8V0P32ZbsdqRyeMv5FyRbJKdSAbLGDxqeG/a9uo40Ij8nhW+SV6xNCFpE8/
	xC86E4obxyA9N/IdytmeQWP/ZdVM3m4oPa4PhmUGQCZ92Juvw+uHbCf1fq9klrN+nAcE9/
	0JAH6u3T9oQGr2IILZsnO5QN0Nzt/Lk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-78-7qoTuQEFOCyZkOxELnnfBg-1; Thu, 21 Aug 2025 16:07:55 -0400
X-MC-Unique: 7qoTuQEFOCyZkOxELnnfBg-1
X-Mimecast-MFC-AGG-ID: 7qoTuQEFOCyZkOxELnnfBg_1755806874
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45a1b0b14daso7258585e9.2
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:07:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806874; x=1756411674;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NPs2EdTZ9fd3MpWdb0ATDCa6nUqfGtFMv2uyZP7L+uU=;
        b=DZJEuesQyxa4CqzAs1P6OSOF9+v7cgOekg51OVKFMPs+vGJrsPxYv57BqeGwwBSZJB
         0NBb4o8Mb4Xxq+OH/MPFmmacWFlGJm4dU5I3U9jIgiXXJPJLnsD9XiCEI+rh5XDLQ1p+
         0bxkPZ2aHCXc7716AkcF4phr485lSl8BMFYw3+9SCtCzroUUpGZJb+hnd5cWfh4acOOT
         3ntNK1vIJAzituUDYI6PKwfIePJtslFrl98HICIXQALddjNIssGwYtvuwWqY5LJhwhFG
         VgMiRJfdFUy3FredH11WQHbGUPRbmPx33fUZOPbOWyTbt01u/TS3487x+JxHl6mrrRpI
         ECMw==
X-Forwarded-Encrypted: i=1; AJvYcCWdwYt56hvoxSSzh1FH4/u4LxgR1ocmcDioHfetDp1DscpEItNbymydelWG5M9EFiOucicFJl8HPg==@kvack.org
X-Gm-Message-State: AOJu0YxX/nY9SunD3exN+pS2yb0pA1y4fZLxwQ/V/7zYtBpHFTzYdpvd
	v1Qd2ZKKOPd+9Ti/D19bj3nwQbKV78oZ2MAQOGMb9rqQZkn428/uYNtkYtGpnb4SnEY/ke3FEhQ
	ohRkLrYiaJZCZi9NLoRcmDNtP6/Ln5wac6PkEf/Ib9NnpSwV8p4uF
X-Gm-Gg: ASbGncsPDs6F1DU0JiJQxGmcPHOIkjWgA2M9q6fPX2BGZjkOSOIHQLarZE94wHzN2Dm
	8ccI+g5GcJJb5H5OgeQP8sFEvMXytnQlSTsC++qQDpR2kng9/s1Gn44ORrwLDRfMByQ6M4AKjRT
	4YgBHY8KhoKXnIsDr3zI0F06HNkpzEmFM0OWfAVEpsLPrAwWHki1gUmHrkYHckcbshNtJdwpeCL
	I4AgJaEg8qNo7vgsz638EJNcp7kmAExzTufpXz3pwQ10djhiMSRDpH13i9VasaNaiV90PVgEeIV
	Nq4s8rON5npze4BHlauvIg5VSZeUk0jBHMg5FtSNpbsMkMy5WWcMYQMjbvOpWp02ChOIF+Vz4vS
	F1xNXkfGNLVVY+uA/bAcGRw==
X-Received: by 2002:a05:600c:1388:b0:459:d451:3364 with SMTP id 5b1f17b1804b1-45b517d40f2mr2554345e9.24.1755806874318;
        Thu, 21 Aug 2025 13:07:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFo8ikhW4DoWVw60oDeAXqMRvn4UERlcVawLCjGel2pacwRc1R1ONhYVQm5EzuW0YIJQT4FDg==
X-Received: by 2002:a05:600c:1388:b0:459:d451:3364 with SMTP id 5b1f17b1804b1-45b517d40f2mr2553905e9.24.1755806873856;
        Thu, 21 Aug 2025 13:07:53 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3c07487a009sm12690403f8f.11.2025.08.21.13.07.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:07:53 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
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
	Jens Axboe <axboe@kernel.dk>,
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
Subject: [PATCH RFC 17/35] mm/gup: drop nth_page() usage within folio when recording subpages
Date: Thu, 21 Aug 2025 22:06:43 +0200
Message-ID: <20250821200701.1329277-18-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821200701.1329277-1-david@redhat.com>
References: <20250821200701.1329277-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wDEVvW4NQUUVGAj6nN54U1RKwRvtd221z5AzFuNTzkw_1755806874
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C1A1518000D
X-Stat-Signature: ib9hw3w4i1yiybwbmzb66k6br88khjdt
X-Rspam-User: 
X-HE-Tag: 1755806877-850101
X-HE-Meta: U2FsdGVkX1/OQMEOEZPG7RsJQ4qmXUNZUy/gaa/0KqBhxxR09S6lwhq5v4HjsN+OJDARyCe14N2lWV/SOu7uRiGlgW04y7tZ+7NcC8Czq4ETSzwMstvhMBtn3Umd5BsmHATbvs1TxKyf86xE1ap/2LK/6l6P2qPyaEWq99sYnIOFAsgAxU1bUN6cKJhZHLmgaUPRhpxYhulBV1F72N0C+b83oNdMa1toF3mHzPrVrLLOR9VNEuWyY2UGPLlMlm051ea/qKnqlbahfKX8Wa0k/tj58UMoc9jc2hnk6HY8qMFkLiRwYAk0s4rmg5qcu3AuFQlP7kA28itOaIllUlMdprA3pj9m1ONZcyz4iBabCphVPsdhSOl7NnDy7y3AVxkS4MY4SAQXLYhZePFsa0EjPSezJJmFmBGAADuTuodBVaHb5HHpxOj+8izextV4PG8F9W5MTgWWsUoiSHYLImAkNDKho/KQgrvpOpXrmBUm4GyQ40NbZn4tgXCCr3w4g806ykkk30sG+CiH1QIecNpqpK7dfnnfu2/52ql8eOl5eimUDpOozcGhJJq8skb7d1rrwA+UetRu5Iwhc5oGbsZchxK/ROgAa3nFMgezEp17a6621rtoiICOqK735KVdgc+mj3rK7Rw4j+MNoEiGLGIRaysJYFb9kj1caBv9HEiqpPumfMS5PFWRFnfCULZomhQkcF8w9gN0rtZ+ZseZ0pUzYF0wg3P+XsNzOc3rTZMeXBTde864T6pCCIjc4BaqOg6HQxj1U1Dn69nfcXvIgUXTAWgnBD+V23+MX4q82uNuk30BFhnqjKA9xYGV6y1JVgpJVZCeZz5E1ETCaWmw/BiFAI0FdnH0cRjI03LbUenN+5lO1KAaYAL+eVt4HTVKgdjAoQsKhfO1BkBRxo1ByF3AD08K4vQpCxYZH5t1YGPcM8s1kTQvjIwRy2l5th7gkPXTNDYDRVze+m3+TesaQ2R
 L+BJgIwA
 ZbxD/BBvNVPSfFtRCs4nHobiaq0WrTpNqRs+IPe/MSyTKtdJmBqoQtAIHzxp3JviQuVQs/XX1VQLsvZDFf+1Hdpha0KNVrGBic+v0GHBawzF5zYWBu6yftChz8egIAkIvxxQrv5tChESgZu4TxQqr6WKEcLHAu3ENYm8p9GslVL4NlGrnnnZGIH9cjQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

nth_page() is no longer required when iterating over pages within a
single folio, so let's just drop it when recording subpages.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/gup.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index b2a78f0291273..f017ff6d7d61a 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -491,9 +491,9 @@ static int record_subpages(struct page *page, unsigned long sz,
 	struct page *start_page;
 	int nr;
 
-	start_page = nth_page(page, (addr & (sz - 1)) >> PAGE_SHIFT);
+	start_page = page + ((addr & (sz - 1)) >> PAGE_SHIFT);
 	for (nr = 0; addr != end; nr++, addr += PAGE_SIZE)
-		pages[nr] = nth_page(start_page, nr);
+		pages[nr] = start_page + nr;
 
 	return nr;
 }
@@ -1512,7 +1512,7 @@ static long __get_user_pages(struct mm_struct *mm,
 			}
 
 			for (j = 0; j < page_increm; j++) {
-				subpage = nth_page(page, j);
+				subpage = page + j;
 				pages[i + j] = subpage;
 				flush_anon_page(vma, subpage, start + j * PAGE_SIZE);
 				flush_dcache_page(subpage);
-- 
2.50.1


