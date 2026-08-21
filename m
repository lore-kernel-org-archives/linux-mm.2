Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5227C5DF8C
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 18:58:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 059AF6B00A9; Fri, 21 Aug 2026 14:58:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFDA06B00AA; Fri, 21 Aug 2026 14:58:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC5E96B00AB; Fri, 21 Aug 2026 14:58:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A6DCC6B00A9
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 14:58:08 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 23195C0221
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 18:58:08 +0000 (UTC)
X-FDA: 85126186656.05.DA1FD3F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id F3F3640003
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 18:58:05 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=G3I1INVj;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of echanude@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=echanude@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787338686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cQingZcA8JY9invl4rfVqQH3WLMP3iU/vTSgNWsiPjc=;
	b=tN2wLIvCx6MK/D9cRSCA8LXsX4wcIKVCjrtArehf62+BLyICy8FKcXyvaz6AW2ZnSv9+eo
	gMRE8RZlM9HwalbRHYcbxTDXCm7rS3b9zxwD9A5F57bMt8K0YOfyhzLxuSmAgJrxDYtQiY
	WOeFUUR8g6HXKGpOjfhEDjiBkRY9USs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=G3I1INVj;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of echanude@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=echanude@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787338686;
	b=jkb5ovPzUYIy9gUNU5sypwJKzB188gobpHNvDBA72J4b3y4g0m6t9Jm4nwNYMCnJi2PFMB
	x/pbAamGeKqW1DT1R7TL/dp1DdpSTWaL7aVKbZ0a26uBr/iio7Bi4i9RU6IcDmoL2vQ5J3
	LpJsS6j+fjVMjdzdzPkLJyaZivbbv6c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787338685;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cQingZcA8JY9invl4rfVqQH3WLMP3iU/vTSgNWsiPjc=;
	b=G3I1INVj3mFoCprarW83H5PuRE7VN9HWHXTZ2HDP4GwNRnLFk+ZPK1Q49DElqGXiXESL+e
	xBXQBRLS+tYILwrMNP1BKuG5FtTWZcrR4Jt+2aPLM/0oMxj+nn7hmNLSLLGa3+KW/AS/UA
	YQa8vdCezMdWsn+kYUha9zHrEnGQOf0=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-668-hx7CIXHlOuiDNO0sh06VAQ-1; Fri, 21 Aug 2026 14:57:53 -0400
X-MC-Unique: hx7CIXHlOuiDNO0sh06VAQ-1
X-Mimecast-MFC-AGG-ID: hx7CIXHlOuiDNO0sh06VAQ_1787338672
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-9077b4c35c5so25622706d6.2
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 11:57:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787338672; x=1787943472;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cQingZcA8JY9invl4rfVqQH3WLMP3iU/vTSgNWsiPjc=;
        b=lzT23J7V2338Z8952a+XZ9dw9LeH78SH16yaK6YR7tPjSmfVxfrEpP40JGn5xm2GCD
         wvs9oi9Bs9yc0eu3qoYYCf0mqb8a7Eq3/55fX3/w0FwteiuFfqk6gVMqhkZXKn1ZwWeK
         9ia/spRe2+b5gmxomlcTVnLPt/TRJOCVj3Ipb1frGpVkdS6cQqE8rhpBwqk96CVyf4x5
         bBCCvPgU5n6Z9w51XB1xvUpEw4Xz+2sFFyp/AJmRHEMi06S0RHTOi5Eij0YezMM/ninJ
         yNuAQphLBzx9yRSQprPfoJGQhuSiVJtGq9uev9UuCmwL/ZmqXbztSM2pdYELIgmp4op+
         U4pg==
X-Gm-Message-State: AFuF++n72yvybVBJlxnxbpRk8ST1RtMcKjUM0DozL3h/FV9zR3InAadd
	9WKG72QhVGHSioln+EN+a0fv1++1kGcSYefKvuf4lkidQqaL4zsxwujbx3wMEv5o6UQDZlPATGM
	l1r9Ae3aC7NbOLT37J14lr1wvdTa+mvdOdmtnIQkT7WttjrEQDFNn
X-Gm-Gg: AR+sD10LJTBx3VZapcdcyG9nloi5ls+GjlbywRsxmzwPbU1bYoFR9fPC/IH3azZCaAV
	2FefMqg0/fNLrza98j5XWfumMP7VcPzyuh2VKgIdNIyE0YSnzlZDF9xa/9zUFHQ1uuMuMS7xldD
	q54F1FHe23FdTmC0Ar2nZcoBHl5XoXF/ZfGIRlCtvhXh1NyEAHBpsMTCJXaCsM7+Hu8IY46cLpw
	bZscUEtlCFf8kikmLcYkhenBTKFdEC/7jIv5TitSs/D7XzaDDw6a7affkqMWhsmBJIJ66I0CtAY
	c4Usn2oy6CjNPD/FHi0GojNb6BgHCB2YDnz3Iaqdvne/YyMipnyUwbpxPI+jSKnTQmQOG87wje/
	5pkvQVkmivG2YWKPMDg8A+G3CenVcUsFaIhuI5PFD17S2
X-Received: by 2002:ae9:f115:0:b0:937:26c3:747f with SMTP id af79cd13be357-937468baea7mr97627185a.15.1787338672388;
        Fri, 21 Aug 2026 11:57:52 -0700 (PDT)
X-Received: by 2002:ae9:f115:0:b0:937:26c3:747f with SMTP id af79cd13be357-937468baea7mr97623985a.15.1787338671990;
        Fri, 21 Aug 2026 11:57:51 -0700 (PDT)
Received: from localhost (pool-100-17-17-231.bstnma.fios.verizon.net. [100.17.17.231])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-937205998ddsm651971585a.44.2026.08.21.11.57.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 11:57:50 -0700 (PDT)
From: Eric Chanudet <echanude@redhat.com>
Date: Fri, 21 Aug 2026 14:56:53 -0400
Subject: [PATCH 01/11] mm/cma: drop const for struct page on release API
MIME-Version: 1.0
Message-Id: <20260821-cma-memcg-regions-v1-1-d21b165b8440@redhat.com>
References: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
In-Reply-To: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Tejun Heo <tj@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Maxime Ripard <mripard@redhat.com>, 
 Albert Esteve <aesteve@redhat.com>, Eric Chanudet <echanude@redhat.com>
X-Mailer: b4 0.14.3
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6BcTP-7cnckOFVz9F02GqYWNNDM7KMld9mY7xyio0gg_1787338672
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: F3F3640003
X-Rspamd-Server: rspam07
X-Stat-Signature: brohe1igtz13n747rpxo1oac95tzb8jk
X-HE-Tag: 1787338685-257447
X-HE-Meta: U2FsdGVkX19oDV0chFTvJe1zIblM9qgd0hj43d9TAU5T/LukK0tTjen5n5pv7OX4D2dO2lWaoxGgw04AvIUZvlUWafZdH7ChpaFqQe7Ps+YACssiD7e06c082EtiNZ09CpHsfdL1ewgcR7nqj8W9gbllJQhWzfrQmlDNAvMyhYe9kRYcKhg0a2Pyp+IgRXA5+0svq3nlFZQuUcYEQxILlPeymxyN6jfs+wZ8v6zy9pxBnod2pyoIgSqQHV/MnsxSfxx7Qgaexlpa1HBaEzwFY0dXe6XUMwOBffMCE1whrrlTokN1hXW6AzNHGunU5Z4OSgaMh8kpERsB6rALSzhsySFu7OA9bLwePqr44SFjhVk4P9u+JIX56auab5qX9iqwXWOm7R5zM/E4WQSVkiR3psVJiPNN/mhRbfuz61J8Tp0N4BYNN+9Bn268MV8923vKms02k6wo1yg30tS8W1ydUoc06qfEv7Yw5sS24/sgIgmTvVyBOH09buiRS1nw/Xniusy6FqXkYMWNriA7e6/sUu2LHqzZwpITGY8OVDe9ETB+1IowRm0LQf6qxQp4NWlBgeg1ZYqzU6F+IItxagCxPqYHVsmbxKHuLxY8rMleWUef+fwTiP7RNVNi8JEkGJFpUVKR21dRTgxtqSDmAoe/uaIVLwnc40l39l8pAzmXJwGbcdaJcyC5gzy/HXpmvbehYJ4LxMk/rsLUWSQdHKFEd/5pRWmIzMpnvenv2B0WdE53b3lDYY3eL3tO3MtNCg+aiLOHwnFkdpNrXuy/DxBkwT6+X80SZNrpqoSrjMUV+j8eMVuMeuz3m9jbvoy9aK/8qBZLB3yUbjotojGWjNSAxEyIT7GSdsumJqALxRxruGOHvQ7YFXZOpwkkfvAc9y4blbH27GOC8s7wBgW0v+St68MuLlY0MQXLpN7DGDLwDrwYhdfWBnO1nYrSK13A7RWzvCi+t6PwRw0MvaCRzBM
 mOLX8geN
 xpJMSYpw/tbswtEsWU1KwwzwxFc+UOumiNOP6wvSxQGhvvV7NHoAOzlz6tfrFMHf37rMMVyGKF3Ah58fSSHZYHZYn57ywYyUs6MV493bjwVDXvCQs+e1eCbklbvsGkS0g9RJZGkPUJ6uJLP4aVgCSpdc5k70vQI2tigV4rqUfd1i5oEKvncJJEUcdTmkzLGpZeA6PYPYId864AgWxjxVkxQNSN5pmR9MrJ+v7xkZzPE8JcDdlJH6yrFamBitFSbAQgcNSHSMA7WV9cKqDEPRARIm14Yfa2THXCWy1AiTYY3JSwefH77t5V/UbBzE2/fqOp5GEjl+PNAT7LPmioFA1sHdig+OyI/FjuMmtYxvhfZMXOc9mG0rE8i0XYA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The const is not honored. Both cma_release and cma_release_frozen do a
struct page -> pfn -> struct page round-trip to convert the const struct
page pointer to struct page and modify it:
cma_release calls put_page_testzero() directly, which modifies the page;
cma_release_frozen calls free_contig_frozen_range(pfn),
__free_contig_frozen_range, then __free_contig_range_common which
modifies the page as well.

Signed-off-by: Eric Chanudet <echanude@redhat.com>
---
 include/linux/cma.h | 4 ++--
 mm/cma.c            | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/cma.h b/include/linux/cma.h
index 8555d38a97b1..16e2136421b7 100644
--- a/include/linux/cma.h
+++ b/include/linux/cma.h
@@ -49,12 +49,12 @@ extern int cma_init_reserved_mem(phys_addr_t base, phys_addr_t size,
 					struct cma **res_cma);
 extern struct page *cma_alloc(struct cma *cma, unsigned long count, unsigned int align,
 			      bool no_warn);
-extern bool cma_release(struct cma *cma, const struct page *pages, unsigned long count);
+extern bool cma_release(struct cma *cma, struct page *pages, unsigned long count);
 
 struct page *cma_alloc_frozen(struct cma *cma, unsigned long count,
 		unsigned int align, bool no_warn);
 struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order);
-bool cma_release_frozen(struct cma *cma, const struct page *pages,
+bool cma_release_frozen(struct cma *cma, struct page *pages,
 		unsigned long count);
 
 extern int cma_for_each_area(int (*it)(struct cma *cma, void *data), void *data);
diff --git a/mm/cma.c b/mm/cma.c
index a13ce4999b39..e1820fb451e4 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -992,7 +992,7 @@ static struct cma_memrange *find_cma_memrange(struct cma *cma,
 }
 
 static void __cma_release_frozen(struct cma *cma, struct cma_memrange *cmr,
-		const struct page *pages, unsigned long count)
+		struct page *pages, unsigned long count)
 {
 	unsigned long pfn = page_to_pfn(pages);
 
@@ -1014,7 +1014,7 @@ static void __cma_release_frozen(struct cma *cma, struct cma_memrange *cmr,
  * It returns false when provided pages do not belong to contiguous area and
  * true otherwise.
  */
-bool cma_release(struct cma *cma, const struct page *pages,
+bool cma_release(struct cma *cma, struct page *pages,
 		 unsigned long count)
 {
 	struct cma_memrange *cmr;
@@ -1037,7 +1037,7 @@ bool cma_release(struct cma *cma, const struct page *pages,
 }
 EXPORT_SYMBOL_GPL(cma_release);
 
-bool cma_release_frozen(struct cma *cma, const struct page *pages,
+bool cma_release_frozen(struct cma *cma, struct page *pages,
 		unsigned long count)
 {
 	struct cma_memrange *cmr;

-- 
2.53.0


