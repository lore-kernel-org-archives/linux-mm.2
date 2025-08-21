Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81096CA0FE2
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 20:08:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 084F38E0034; Thu, 21 Aug 2025 16:07:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 034FD8E0035; Thu, 21 Aug 2025 16:07:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC55A8E0034; Thu, 21 Aug 2025 16:07:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C2BC98E0034
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:07:54 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 92A488373F
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:07:54 +0000 (UTC)
X-FDA: 83801850468.25.4D3F522
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5C114140003
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:07:52 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IWRZzC5I;
	spf=pass (imf09.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755806872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MzMWVCGQW0mP4+/ULAfe7CdOmgWkAKLnoxAB4Fy092E=;
	b=3MBs/si7SU62RJ31dZbBEEDaNgaOi5eekk/bzpdCcqVBiyAFFkiQ9yRfynKV5twOFiljAB
	9gLR3Q9VKpaKjiiFyGe3R9EctQQpFW5VguitCE2gFWPDZ63bZpqR7E08j9emHvZLMZGbjD
	pErsY0Qx3WK24CGlCHtD3NdunrxnbLc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IWRZzC5I;
	spf=pass (imf09.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755806872; a=rsa-sha256;
	cv=none;
	b=8BcDh+iFNED+0pWlJiMblqvCNT4V6PWPt6urvRuHG0MnIv3q/6zubtxh+rkYqiNR4elSVn
	MkCPg0588qiHfG/gj9q3s35aRkp8YPruj4xtCyBYepaEJGevCmNSexth9uOQnRZZtDCW9T
	8dLNjeaRDPCh4R5ZF9FGqrdlJBzlFmA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806871;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MzMWVCGQW0mP4+/ULAfe7CdOmgWkAKLnoxAB4Fy092E=;
	b=IWRZzC5IsVlSxbV8LOgcIqYVH3xDPPkD5smnBkNlJmhYzdKrtZyyjbN2K76bWUFfqbwrs9
	ef5TOSeMjccHyioNA5TOo12Damqmlfl77rwzBVipmkAjBzNz9El3RETVsFS+m91rQMc1H9
	anmhqo6DtIkealFaAritIlt3tzVoDxI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-661-Jj9PK7_jOWGSCISKFMLIJQ-1; Thu, 21 Aug 2025 16:07:50 -0400
X-MC-Unique: Jj9PK7_jOWGSCISKFMLIJQ-1
X-Mimecast-MFC-AGG-ID: Jj9PK7_jOWGSCISKFMLIJQ_1755806869
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45a1b0b14daso7258285e9.2
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:07:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806869; x=1756411669;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MzMWVCGQW0mP4+/ULAfe7CdOmgWkAKLnoxAB4Fy092E=;
        b=llSX1nEMmTIbO8gT5MT9Nv2bPmuvdd8ORDy4gVryo0ccUZWop3pJqkSQyWT4o3Vcg6
         o2flKE0r5TcxS7AZQaXGgDdVd48VdlxTHnljJD/AeBVs/687WkpjYd9yPaGH036ONn6D
         yLA0fJt8/dH2f4EOEo/BFRnD5YVEwwSopF6+TnBAcPQvbbHaLtnvPLMVO4nkjt0OzHVZ
         BwjUbJIIu4Gkrtb1K47grt7q8/LfDqQ3qUjna/efWVV6jpt5Nc5Z4GZVzAz6dBkhfgh4
         Hl+eoHWPSxorT17/VYT9BDBbhcLMVjeQPg99jQm7sapFzYKXKha0DXFwxhCN07REp/r6
         Pk0w==
X-Forwarded-Encrypted: i=1; AJvYcCUmOy5/QvDcDYA5YlEdchlEkgd7O/flE2p3ntXk9taSsNKNNXYtRNmG26ZMgzNGCODfeqx9hduUWQ==@kvack.org
X-Gm-Message-State: AOJu0Yxx8VoAc4VjJNG0jgfUsUXwiBgrEwmAjy5HND8ifsuVYnuy0Tvm
	bFqicYxC4glTHePiy0VoSBYM+UTDWAtfD85AVbxWA0suRgyj15EqgN9xMY3LMfcHl3OQuP85DJI
	KIWBiFkOoH+Ragwvy1o14gqHJyIk8BeODbcJ3AUrhOeCcrOb2BVfC
X-Gm-Gg: ASbGncucOXP+xwyvRQq40CQcZlP/5g1PJHugl7OM1T0FfHdLW4rz4Nuh0De+bdU1qcL
	NkW4AwUv7twXy6sournFWNfj+clRQsxjNcs1hOS3A6FHLAor+4SteQaiaihhHJW5C5vyZd8jUl7
	8zpS23Nud2q5G+8nl7pz5AQarA58/1Wk3hp/y+APLGwbuYOElWcNDtLEtIArT2GbdoOhT/IjrgM
	Dl6GgEk/2h0sbe5DfVPl1BqUQQG6h3RE9c25ss1m3sbbAV3+oIo0KJO6r8Lxp1cCIRVhv6uj2oV
	p5iW/6rskBbrVzfu/m4kIqp6ZtJK1mvVZJple5XJuwJjaWwdDp/Bn67UJwWSZYi1zATv7ZM/QPJ
	E+F2jpRjDR5A0kjukhZB3+Q==
X-Received: by 2002:a05:6000:2901:b0:3b7:c703:ce4 with SMTP id ffacd0b85a97d-3c5dcff5f3amr167805f8f.59.1755806868899;
        Thu, 21 Aug 2025 13:07:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHCm64ALptQrKyrLlaLt4xJ2vziBy3gZm4Q1WMVX6wnWhr2W2tRcHnZJHBwxpAOnTfL4mKx+A==
X-Received: by 2002:a05:6000:2901:b0:3b7:c703:ce4 with SMTP id ffacd0b85a97d-3c5dcff5f3amr167760f8f.59.1755806868453;
        Thu, 21 Aug 2025 13:07:48 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3c5826751d5sm1323274f8f.14.2025.08.21.13.07.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:07:47 -0700 (PDT)
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
Subject: [PATCH RFC 15/35] fs: hugetlbfs: remove nth_page() usage within folio in adjust_range_hwpoison()
Date: Thu, 21 Aug 2025 22:06:41 +0200
Message-ID: <20250821200701.1329277-16-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821200701.1329277-1-david@redhat.com>
References: <20250821200701.1329277-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: MbchtEoRJg1A_G48aFSpXkeo0eWxny807mJ1KMCqAgc_1755806869
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5C114140003
X-Stat-Signature: 9h645uxsrb3pdgrtaqm4cop4og9am4cb
X-Rspam-User: 
X-HE-Tag: 1755806872-659714
X-HE-Meta: U2FsdGVkX1/+zitNZU+dssbS/bV3OMnr2BbpFa7Gx0Pt3f+aouiRR7OdsMclliJhF8zBWSQYfvYUfHNCsbOZoZ8yFj3DG1+I2Payg75f7eS6Zr4YQU1o8areUzCSpuMhIoXjSk2pGUJHvEdf5l44OIW7wy/H8882k1RVm9S5gOzqdQtHpcQCjssa1YOt4Mi52wIopZzE5haOACEIe9HBnEAdH4qtuYnA4VBYcZgkCRBndwuNKwUpYk+Yw16GAbfbxZjMKpVhmyTM3iFzjlCc2sev3ZpLgbzwpXc26KwreQ7KqPx6qQM0mGThc2Pu6tdjTBQBJlNkhF3y0GqcSYKJdL1BrUh2rb5Vs8nlzdkAMA6chJrUEa8nf0Tinvy0ocHuHl+Touqgn72owcJ+hL5nB6cF+AddIMxAzllc/7EGopMfbeQCuCoh5TWziza2QphoidpsOjzc7X0EfTL9FKCx6lCQc3USo2LnddyfhtBOIXwBWSCYKDHMIriZ7qNjm92es8mLzxRmTR8h5GvEvQSbeiCxQLhhEujs+HurpA/tkn17R6qOgFmyDz+FHyqFJ0IdkvUmwRZPRjVB7ptmgkKqWGQwQQZ1Ag0qH8moPsPXuZ+gSVg6CT/cIf4Jlf11EU/VEgCBkx1mGK0CafZWdmDd2G4Hm4/2IpD5ROj8qI2hhF2W4/7MHqkgKlSzgrcaWtAINJD2wEbuxwdOH5CgJu6SvYw5D75gQUwcj5MLDP59qx0V1tNHWgtHkzMbJG8KYLB7UhAHxO7Q1aZZZ+H2HH/BekwhH0zrCh/o37dv6ddN+wGIuSZFFS4aYi+eyiPbcdrzJjAOqCEJ2TcvfD8UrpKzyai+B+OWYCmGAD1Kfr0p44bpaTom6BuX811qNeGPj/uDt4SngOToP9Ea7/lBEk+ouZdvlHaNAraAMQ4rnGIBjR1CH5Rq08OXv+JWm6nbhdeMI7j/x1GDOwMQ5KXD8RE
 Jxv+p+zt
 EWJBhneOD4qAI7837cMCW9N9VYSB7LGkkEp6e6/BMsVsP8RYFiIL6ey/aTqdf6KqKdwF8OTA95KfXUakuFw/2iKkk/DGhxWwgFprMZxzwMPWjF48LFWfL2jUDXGAsaLfZa7oBPeimNOjYkkGTTyO8F1G8pdFZQnCdQ0RqYCeEOffyl2Nv1CY0OxWdiW3wATDtx6+hSobifa/ZiOQ398DPF7GuBifwHlbl4VD/h2uGcYPCLtgvNBL1mU7iuP5b6vUO7k7bMrxSbAnTQqNeYydE+bt7ZNSH9bMjqfYjuTGGQ83Nt1QeQnyalQAl7QYNu1BTU+X1N3cimP/VqaUcYNFiUUqdu5XDyuZ1yQ3MOhSBbK2ChUciMChjrSfFwjZXXf/1YDtTNItBk7R6Tb2uSbKD23+FhpYh2a93hFg9x5HBTabUR4pe9qCaGTAdxSaEFDndi7Ca7do73l1s+Owh4bfKLZDzV9hBJxC7q5vRbU2TyeK1a1HlqxENLtP/WAnJjydD65BHN25tCH7j8NWfcReerCv+0Zcgv3o5je6iFUyOjzStGU1o0eibzJgISg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The nth_page() is not really required anymore, so let's remove it.
While at it, cleanup and simplify the code a bit.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 fs/hugetlbfs/inode.c | 25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 34d496a2b7de6..dc981509a7717 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -198,31 +198,22 @@ hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
 static size_t adjust_range_hwpoison(struct folio *folio, size_t offset,
 		size_t bytes)
 {
-	struct page *page;
-	size_t n = 0;
-	size_t res = 0;
+	struct page *page = folio_page(folio, offset / PAGE_SIZE);
+	size_t n, safe_bytes;
 
-	/* First page to start the loop. */
-	page = folio_page(folio, offset / PAGE_SIZE);
 	offset %= PAGE_SIZE;
-	while (1) {
+	for (safe_bytes = 0; safe_bytes < bytes; safe_bytes += n) {
+
 		if (is_raw_hwpoison_page_in_hugepage(page))
 			break;
 
 		/* Safe to read n bytes without touching HWPOISON subpage. */
-		n = min(bytes, (size_t)PAGE_SIZE - offset);
-		res += n;
-		bytes -= n;
-		if (!bytes || !n)
-			break;
-		offset += n;
-		if (offset == PAGE_SIZE) {
-			page = nth_page(page, 1);
-			offset = 0;
-		}
+		n = min(bytes - safe_bytes, (size_t)PAGE_SIZE - offset);
+		offset = 0;
+		page++;
 	}
 
-	return res;
+	return safe_bytes;
 }
 
 /*
-- 
2.50.1


