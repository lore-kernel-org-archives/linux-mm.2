Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28211CA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 20:09:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FED78E0047; Thu, 21 Aug 2025 16:08:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B0BC8E0048; Thu, 21 Aug 2025 16:08:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 674988E0047; Thu, 21 Aug 2025 16:08:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 49F2A8E0047
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:08:51 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 17DBEC056F
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:08:51 +0000 (UTC)
X-FDA: 83801852862.09.FE87092
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id E2A8540003
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:08:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=E+EKZVNo;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755806928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8aQmj/0+AYT4mPx/DatgQPPbmq0Lkvm9KCqKkKCdC9Q=;
	b=p0DA68KVcBO//xJHmN7HZXjE/tjryF8nLpPBQ514E+LRW3REWz8KYsDd833K+IUSPyFBCD
	ZZeObRar8nNOyTl1DxcRYC+ipPUg3e8wn1mwlGMgFWG7CI9/F8nYWclMgtNg3U38adTlhi
	YgWK9mEcXNwOPe9Ok9TiPw2gaQnhgro=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=E+EKZVNo;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755806928; a=rsa-sha256;
	cv=none;
	b=1TLbwTwHGZbLWnn2m7np4LngouW75135a27zeW4zSBQCkJ4BVBHheICq5jxUS15p1q4Lsd
	0+9Pv5MRAZKG7yHq67rX/L3i0m3v9D69yQOblpbb7ZhJA2CJZdY8hDwk1ERVgIF0B5lTat
	kbke2zBPYqNBIfAVEZDG5zrbwvDBNGg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806928;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8aQmj/0+AYT4mPx/DatgQPPbmq0Lkvm9KCqKkKCdC9Q=;
	b=E+EKZVNoIN341jMTTRkCIXdmOqy0S50EZmPngqAufEwPbx8Oovknj/Of1Vh+DK6sLftdgY
	L++eBcRmIkt7n+h5FO9EfzS43bnLz3RahmZyzXuxYejpK2VM4NKGP871WLsIEKMqLyzFZW
	j9CGwzD4GF76CZDfMH8D9xnFLWmSOgg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-347-lOZWTNySNwOFyb1uHScMCA-1; Thu, 21 Aug 2025 16:08:46 -0400
X-MC-Unique: lOZWTNySNwOFyb1uHScMCA-1
X-Mimecast-MFC-AGG-ID: lOZWTNySNwOFyb1uHScMCA_1755806926
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45a1b0d221aso6550455e9.3
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:08:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806925; x=1756411725;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8aQmj/0+AYT4mPx/DatgQPPbmq0Lkvm9KCqKkKCdC9Q=;
        b=R8DFm+IGGGiMgHS9MLATR2b4EwNo6uzTsDUSude2Hlsf2m2Qgd4oGWKErEw4UUWvEb
         c5oW1iJjIkOuXU8Ob9pP548Vy+DbHjxgvUBjSNxBYR5uCtgb6bh92236pCYsUtnKd6QL
         GfE4HwNmF6GL+KgIj6OYY8EXAmFG3HR2bpitTaqR23uqxD9qVhT58KYqKtISsXQWKhbc
         dwV8uaPBj2RpnN++LG1xHb0EaFUjgnh3S23wQazGyFCdnx3tC3J5Eww/6es3DhNGmWGy
         PJwO+9wYzcDrIOf6XDDmfYraxFGXZzi7zc+k0KweOtJDlQF/xYG6GuL7841XiAgUbNQL
         4fbQ==
X-Forwarded-Encrypted: i=1; AJvYcCVeNZDyy1o57hfejdw2klvxPkeEjwPof4dcXTtH8S6FJLA/jQa1kuYwzU04zxOUcDzsTPiwkjlpJQ==@kvack.org
X-Gm-Message-State: AOJu0YyfTjDx+NOVtv83ugW8sGo55YOj1aTRDMJD425pqYgBhk4Qlxcg
	NzGzB2vgj9uH34D7LxGTF9I2c1G8oTASAJYzoUVt/Z6Qfj74Vt/54bYULuim+mHBtgPLrxDtXgK
	FA+TXEY7bKZd4Vc4+ZleWnFdozQKRMlYrqXBlxnmHcVI2Nt+ygTWQ
X-Gm-Gg: ASbGnctwwfq5mXuL2xwUHehOKjpyGA/uGSJgtdXkzRIGuqmmO2KLRepsO6SkJaFfQ2+
	qDouCNBBqxLKWT7E7poavX4ZRWo6VSj1CJhdnInVO2e2Rwl7F7qnwoPqNvLV2ATi2lRqnrcp/wp
	ZAXjq7VjgE0IZnof1YmXBTMkDcMlZKm+n9waNC6vYbHkpiLvAa0O6j57zWT+6bW8g9CFpjw9BcB
	q0EpzNRrN05n4RrU4ZIty0im6CFMNjjS+flftrr0Va5CJGs0PWxBy3cuTZ+rgTGvxwKM1ukw4XX
	zItgPwciku6rjdbLw4tTHbKWvPzI1LYmQaJ0tDsWjHepEAwTPlWYmLbE2zAgRTexlu6ypE3oAgy
	aLNV1khfJsMPdyL4pDNsdFw==
X-Received: by 2002:a05:600c:3b25:b0:459:da89:b06 with SMTP id 5b1f17b1804b1-45b517b008dmr3774505e9.16.1755806925542;
        Thu, 21 Aug 2025 13:08:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHDDv+I9AWZPVyKVFD2prHDmQqsK3mzEWwP5yNf0oRJXtHjmqgi3hMC3hwAmszm5rTAtK85Rg==
X-Received: by 2002:a05:600c:3b25:b0:459:da89:b06 with SMTP id 5b1f17b1804b1-45b517b008dmr3774035e9.16.1755806925116;
        Thu, 21 Aug 2025 13:08:45 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b50e0a479sm8895255e9.21.2025.08.21.13.08.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:08:44 -0700 (PDT)
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
Subject: [PATCH RFC 35/35] mm: remove nth_page()
Date: Thu, 21 Aug 2025 22:07:01 +0200
Message-ID: <20250821200701.1329277-36-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821200701.1329277-1-david@redhat.com>
References: <20250821200701.1329277-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 15PPe8nzFM37t5_K9HMelBnIQFthke1OKTiN6irIRHM_1755806926
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E2A8540003
X-Stat-Signature: yrspekj4di3u79oukri8xik97eo4ji54
X-Rspam-User: 
X-HE-Tag: 1755806928-193983
X-HE-Meta: U2FsdGVkX18jVdAVEeOfKQGWKc34dFWmMwfX92HPJq7KqpsIMaua+l4OH60umwOI6JJdbOhoNDu2xQgdi8Fd7lHsgGUlaiqVZq9O4ZmOZqY0NvDXxWurezNf2S8SP6FYLcNvL0h/G4dridqoTFjNta4SU9oi/qZfoswn9K7aTVuepYeS5jwCEDmAbTpX2DqxArFl57eSoy/7L8/MNvtJ++XCIonPqXEP43UPsDzJfcbzgPzLDR3IKKxNf3Qg7V8QUvNGRb0SyDupdqTYNfi6zrx9WY1lMuFSqb5nAUl+rAlLPJ45f/weDvaFPp90aECFLxJmmD8rQujVgkSreE+YF2UOxhZFpPP8N8PxD0odwPhMpKMhBA5fl8PnqLgeWjK1lPfP5GWrfWr/OfGIR6nYNbtGYkxKBxcXDeB95/iR9plDbo+YPmkLgetBbw7cpcHwlXmEHr7BgIjDl5hs9I6FHVnkb6jOgn3NlDa8OWvNeNVltSB+ipiRH3Pf7aL+NpuMzH0E9H+JQFzVm/bc06LbWdNpcL/is10Hco/ST1lvTDV2mL+oOveXDagjUqr0irjsDljqrEpS+tTqRoRvfeBkI4gUUQq/7AtkZCawwyawmZ4TrlQi7+KbITItnmNckps7sXIDxENP4+bDtuwRRY910jGFc4wwI51XkAhBMk5nL+uMBzJaLXXyqxCYf9d2yct5IfHa4ZQKgkmrUyC2Fqtf4rHWY1BuQUYCKWS6AVFKR6fHqMpjYghqP1BvsAbL0O6wF/z5fT2Y2RL+Vkq2iAZrLtfYUqL8qHdiut9R8zRN7mkNsjuC04MQlha28VdG78QA5attQ/TZFyTdmQr6qKIA5bQr+cH8H4pUbCxa12SPrx+h7bXuD+iI21GmvzR83rffKrBaWzZMgAY3mB07qAuITghd/6vN3Fwx1GU8nDonHiiyKT29p/4bCMlnuB6Js/SNmT4btjLJ6lJE41+Po1j
 9HKKky1d
 k8xZQrdMgIPnlkvw2O42SrgSNju2VpyTAVge38BfdHR7CuQ2pKy5q+LyfJ6O59fd+bKOGF/gONaP+Gi+Pzr9eDsbjq6AX1Qp7FoMxjEI2PckucVTwSXPvDIVeWnurWq0qJaYpFuk4pJBfW2GXJcnYbis1Q6CWmeaDMeuqy9zoFsWUsjjdZTaHMdkrWOHhnZoWvjj8ZSNPHlvKb3gxkG2TsjilgJjCcUOS28vedSN5CBFfJB2SpvUOk9gHntDOu544SsOkeRPoabvS6vIREiCCBZY70EQfdS9mEEunb0Y8Ff1fJuREEZJrFZaGKi9mIdH5pGs3G/wlfmy//ZNaW0krFu38g7XwXptqcfQUkPiZJI0AY1FXaxzEUONS9EB0URMaxOmdHBAY3e1CMfr54jVaHzznMHN2HCgr3nJyJ9p8juLoQhEcxyyg+EF6r/flqrX+vg0qkKLYJ4jYLpQFnmkpPT645vC4MDW4tg1UynDdmgM7DgGBo2Rtu1o8btqcZHxCB6dFYFgKjIwo/2dh12E85b5UUs8gQixRZQY7Pl5FHRkTqCP0fYcOw4jfnzOGnbTQQiXT73woB1xNdHWVVyp4eVJffA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that all users are gone, let's remove it.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/linux/mm.h                   | 2 --
 tools/testing/scatterlist/linux/mm.h | 1 -
 2 files changed, 3 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index f59ad1f9fc792..3ded0db8322f7 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -210,9 +210,7 @@ extern unsigned long sysctl_admin_reserve_kbytes;
 
 #if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
 bool page_range_contiguous(const struct page *page, unsigned long nr_pages);
-#define nth_page(page,n) pfn_to_page(page_to_pfn((page)) + (n))
 #else
-#define nth_page(page,n) ((page) + (n))
 static inline bool page_range_contiguous(const struct page *page,
 		unsigned long nr_pages)
 {
diff --git a/tools/testing/scatterlist/linux/mm.h b/tools/testing/scatterlist/linux/mm.h
index 5bd9e6e806254..121ae78d6e885 100644
--- a/tools/testing/scatterlist/linux/mm.h
+++ b/tools/testing/scatterlist/linux/mm.h
@@ -51,7 +51,6 @@ static inline unsigned long page_to_phys(struct page *page)
 
 #define page_to_pfn(page) ((unsigned long)(page) / PAGE_SIZE)
 #define pfn_to_page(pfn) (void *)((pfn) * PAGE_SIZE)
-#define nth_page(page,n) pfn_to_page(page_to_pfn((page)) + (n))
 
 #define __min(t1, t2, min1, min2, x, y) ({              \
 	t1 min1 = (x);                                  \
-- 
2.50.1


