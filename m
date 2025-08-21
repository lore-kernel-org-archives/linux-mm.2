Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 504DCCA0EFF
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 20:08:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E46068E003B; Thu, 21 Aug 2025 16:08:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C450F8E003D; Thu, 21 Aug 2025 16:08:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 910F18E0037; Thu, 21 Aug 2025 16:08:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7D6668E003B
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:08:17 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3B54FB9DF7
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:08:17 +0000 (UTC)
X-FDA: 83801851434.29.84E5886
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id E168D20004
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:08:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Asgvc2nR;
	spf=pass (imf03.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755806894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NKFS9/TuG2v9AIcAoooIJr3bGKW6zmP0XL+5izT5Y+4=;
	b=hflzjuXE75y6oFLKLggPb+KfmURtJwwop76I2W++tXQgQrdIm414dqH5gt+0LNJ29EL2du
	Kpa1ZNEYLOjlx3H1igti7ajBkbgkzCRg8Jf3Oklzv8naEydISY37bvxhRp82LGKpOENtnq
	7zAojNGxDJ5MzMtFOq2u5w3yTgz0JeU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Asgvc2nR;
	spf=pass (imf03.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755806894; a=rsa-sha256;
	cv=none;
	b=PLDcpsT/PPmE2IZHod+/ked0+Q5F/FBWGvTA/xdO+Z4AALwmTHTD7l+L+Nv2nzsn6OOsBZ
	q0FR6QVX9hLht6Y0HXxPWFulDGHJygSX3x/2mqRI2vXNnq1xTawpnMHnD5JUSFPzTqgd+T
	5FC0Bn5Yv5QZPpWB0MZFG9AKtzeusvs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806894;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NKFS9/TuG2v9AIcAoooIJr3bGKW6zmP0XL+5izT5Y+4=;
	b=Asgvc2nRe+TJEI/uMByKO0brPcrRkTx89JxKNv/DzB0ld+4mIl0YJFypNHpcqTdk7x3Vbu
	0xnohi5l3C7ieinDW9UAB/Y4J6Pyq6TeJ5iZ2kNUsH1yFrKBwpCY9USfDDICSpbEYpzpOf
	bmBgtmyzF4u/4vr9Pyaua/G5SjzFLjw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-589-yuMWo4PVNsmpfzBtkIZhGQ-1; Thu, 21 Aug 2025 16:08:13 -0400
X-MC-Unique: yuMWo4PVNsmpfzBtkIZhGQ-1
X-Mimecast-MFC-AGG-ID: yuMWo4PVNsmpfzBtkIZhGQ_1755806892
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45a1ba17bbcso7096915e9.0
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:08:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806892; x=1756411692;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NKFS9/TuG2v9AIcAoooIJr3bGKW6zmP0XL+5izT5Y+4=;
        b=lwKyRIpfFvOMxWQvYwN/MnIMdhlc8xqVaskGkPrTGduGr25c3gwTnGjqHgRRMnPTym
         Pxi6PDBbmgInqy4jY/iMiGlB7bOgByZ0m4GlKNwmfJ5anPIMkvjJSAEqVNCw10Z7yWZ7
         UA6moqUQ+bMphJTtTG0Duh/JAHO0KB+w/FDlusqR4Iks95TM6cMVR0hudhlpLHpbiZqS
         ej4SwsePv9pvvVRaUMI/yUV61+nhxPSOn1lWXKYogSc7NoVbm3SKYAiC/l31Z3bjMz49
         dgLEyOnc+a/PvmHt67VtH3cpiJ+laoF3L6VR8CSpmjzszntK3xe/W9/1xboFE59fis7R
         4n9Q==
X-Forwarded-Encrypted: i=1; AJvYcCVtUiP/IKlfJY33v4/e3YgHffEhcS4UKibd07/rtqBvwOrAgu/26LEBOCmYzSoXON0bWKus3emkiw==@kvack.org
X-Gm-Message-State: AOJu0YyUsVLTMNZjJMMT9b3j980HoqhJ/xvuuD12d42lXSB4EpTJfHj5
	AQpjPCMal+6yRK+p9OzRMgpO01QtGrab/WkFzDvayNUGTJtb5AJatdMVMd64jfqTMchtJUURVaa
	z9pkm9aXpxC3zikGWmKVVwUgD1syOyGtbMJeCqUtAKMs2LA3S9MZQ
X-Gm-Gg: ASbGncvFjMvwLz6jFSXAndA/zBaRXPVWfaOq/q6QjjfjToxxCwy4D3y/UOna5K3OVCg
	1hclxqDc/4xluZBpoiG9CjIK8sMGjg/1MIZrbSBhD2IfF+JXV/aDeKGgSPQPbADoeLuzJa+4Scr
	dMG3NMPAUGDwYeC5Px0NZNhemU0ezCdYxNHCzHxKDSUw1+Eenmfc8uB+EHhqX8DMfrAxNgU/9f7
	NSfhvqMKjz3C3esveD4gJr+JGIWVw2gtECs9W+1scGQQ0N6d7F015Jt/kbPzlEGHUt/cO22rAgK
	6Xk+6P8LXVrw1o8FAMITpJlil7+B46k8qrtjFueCE/IEbJbGmQ+cxsGHoQFZdJ5jTLgM7ZrxnAr
	dkx0lK88HrJzguk7FY6dRgg==
X-Received: by 2002:a05:600c:1f1a:b0:45b:43cc:e557 with SMTP id 5b1f17b1804b1-45b517cbee2mr2552465e9.34.1755806891759;
        Thu, 21 Aug 2025 13:08:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE/z26sBz7JGLAktk/cnLNnmvA2KmHoRy5M1TseKC0NpCNohvOWfWbiwnk6fyruz4Gv4BdEig==
X-Received: by 2002:a05:600c:1f1a:b0:45b:43cc:e557 with SMTP id 5b1f17b1804b1-45b517cbee2mr2552235e9.34.1755806891155;
        Thu, 21 Aug 2025 13:08:11 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3c0748797acsm12277591f8f.10.2025.08.21.13.08.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:08:10 -0700 (PDT)
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
Subject: [PATCH RFC 23/35] scatterlist: disallow non-contigous page ranges in a single SG entry
Date: Thu, 21 Aug 2025 22:06:49 +0200
Message-ID: <20250821200701.1329277-24-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821200701.1329277-1-david@redhat.com>
References: <20250821200701.1329277-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 2k9_GSYJtlfcGdcn8YmSj74KpAKQXROre3AMjaJyIs0_1755806892
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: E168D20004
X-Rspam-User: 
X-Stat-Signature: 16g19z49xjhmktir5gfhtrejz78dpuk8
X-Rspamd-Server: rspam09
X-HE-Tag: 1755806894-818995
X-HE-Meta: U2FsdGVkX1/QjOmss86Btzl7rrsQCweHhpWLCh7L6oc17/pkN82NTs6Y8oFNfo5MuKC6grL8mmdQjIP5mi9ZEnY72xdNfFOQOC4BciJ82Wa9bNbF/pcSVPnG8XZL05HfLqpHJnX4V9xnC6bMkPLyKzTHdirH2nH9nyo4Dg/zZU4N/dRQaTMjIgE0X8Uf9LIu58zE/FAs2gfqw8OhZjmGMBhCXHf3dDf8NKZlycPGNzTkLiFQ2rW3Hz/mYGLP8VT3rs/W0eGKctcFwtTUTQoA8VcK5/C4Au+olrozldtAHpbsKTUb0eTGGsJKljPam2g+9x7e/L2BNledKjbvVZogz8/ChrMCph9CMMdieIl1IBUx4lL4eCtV5JyvYmc2UrPZk/31MgYigo4V8X6MC328YMWUOI8ZTz8pKk+TU+rxGLlPjudXP7gT2VkCKYgeYeK2HIlP6zhjhE5tokMz5OFdwPhClFtRJjg8Ws1Cfn70Z5/wi4lpTdOHCm6cMvRjfSZghZ7wzQFZgJ24NrMOIEBb7+GlYRziKFKdL6gUxlKJLN9vD6kOsWcBIyVBExLw7qMXONz77AiR1g+bm+0xvwe4L4eTYFNALSbWeVMiFNmO85DQVddqthWcL3x9YuSIEpkDU9cnvwCySyOg4/HhxZaxE4Mk2bPOG+rPik/qMYeruQbsxbhzrna6CzntlBgZSrStsbFyLsUNAXKPDOGxtWLfvrg3Ze/G3jusdJFuKC+cppf9rgcgjT/aU25UDH3O8HksUBJXqaipC+UcF6z1Qo08SY7oVAaWoyDXcn7XHIFUnIRVaD4VImQE0URwmiWGOzAdhPF98nu4vxPY3gZdkBcWB+b9VSjn9m+FlQB4pGxk3mxrTY8z4GK8PziLW7Hff9e8KScA89xqdvwegO9iB2N8KgdlM0UpF08Ybr45kmmDYe7mLpg7hTdJWj9MaSbnCrRYoUxhk9shgOB0Ouu63lY
 7nN+U6Lt
 k/Nsw681LBRmUkKCRh3tIXd5+rOek7G+D3sPIKQmkUsDzm0IJiZDBqa1u/OPMOaZaqwIfaQE0JF85hiAaZfAsVNtPyBRXXufdXHDwbPu5rqZllI/0OVpnLu7blq9SuqZICBwWH4k+iSv3PxNr+hwI4N8iaIJw/JSELfmRetI6lJP9blltwmt83IVG3Me3qaeo2J+OvbX+m5GGEl1slpAwWJ30u0b0/dcFWAFwxwGJ9roLInlAs3igvmxqTolQ9J+VZD+QTNq25DPgXDhxCPraxjTxIHKslQtFuMxuOEjFLYoJ5Fmp2iz4gs4vi/mXTuTIRwyDOh+tJG1gPmfBsWCGObtexr0Ovgxz+07ig7953LBqHg1hVgrb+FabhoUEhm9rUSJ1otE2O/bjrMAakS2D8BXVefYEv2IWOzbwgnQnOuJ/3sB/aVrINNP7Xm+8HMBpvYh7zyxvS/N0qJm1YjIPZeLmSxbANWAyOBiY8rxlyN8M1uaNS4p2LI7eiCgNMZUrthfvVqdsPTkmgV6BTEUnNRXIfz7WGsv2ruAGMYBjsT+mSChWf1aQGXgqNTuxVO/HIt/ZTNg61vL6lNo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The expectation is that there is currently no user that would pass in
non-contigous page ranges: no allocator, not even VMA, will hand these
out.

The only problematic part would be if someone would provide a range
obtained directly from memblock, or manually merge problematic ranges.
If we find such cases, we should fix them to create separate
SG entries.

Let's check in sg_set_page() that this is really the case. No need to
check in sg_set_folio(), as pages in a folio are guaranteed to be
contiguous.

We can now drop the nth_page() usage in sg_page_iter_page().

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/linux/scatterlist.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 6f8a4965f9b98..8196949dfc82c 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -6,6 +6,7 @@
 #include <linux/types.h>
 #include <linux/bug.h>
 #include <linux/mm.h>
+#include <linux/mm_inline.h>
 #include <asm/io.h>
 
 struct scatterlist {
@@ -158,6 +159,7 @@ static inline void sg_assign_page(struct scatterlist *sg, struct page *page)
 static inline void sg_set_page(struct scatterlist *sg, struct page *page,
 			       unsigned int len, unsigned int offset)
 {
+	VM_WARN_ON_ONCE(!page_range_contiguous(page, ALIGN(len + offset, PAGE_SIZE) / PAGE_SIZE));
 	sg_assign_page(sg, page);
 	sg->offset = offset;
 	sg->length = len;
@@ -600,7 +602,7 @@ void __sg_page_iter_start(struct sg_page_iter *piter,
  */
 static inline struct page *sg_page_iter_page(struct sg_page_iter *piter)
 {
-	return nth_page(sg_page(piter->sg), piter->sg_pgoffset);
+	return sg_page(piter->sg) + piter->sg_pgoffset;
 }
 
 /**
-- 
2.50.1


