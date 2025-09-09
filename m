Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21E53CAC587
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 09:56:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 779A88E0016; Tue,  9 Sep 2025 05:56:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 729AD8E0001; Tue,  9 Sep 2025 05:56:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CA958E0016; Tue,  9 Sep 2025 05:56:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 41ECD8E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 05:56:00 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DE0A758F97
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:55:59 +0000 (UTC)
X-FDA: 83869255638.10.CC2A0CE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8D071140007
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:55:57 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=he7uv1AN;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757411757; a=rsa-sha256;
	cv=none;
	b=ITIWW4AAl0SXfsBwNY6axVd+KvnR9oI4pTwZpP/hb9n/eAEanxY38ACP31HaOlYCv0Qv1o
	Qi1K7YeASKYNIlIx2t99o+8wRo5VS353mALa1SBhTQtuvthUEdWBSktq1ByXbmxMEGX1ne
	k4mODH9tpC0TjW1buWV99XTsQAe9BQE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=he7uv1AN;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757411757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uuhn5XZ+k/yXfBkz6uI/EJtHiraKm76UcsqU/6SM9xI=;
	b=Ist9n7nQJW7JbkQgl00u83Yq9CzD0tBDZjIpvQbLTWWK1dFuzkyNsdVlAoD4MG0PnkLaIA
	xSTspnSjR3iDgEeZKRxYkebMdQz4pQD7Czdcqw1vsfHq5ldt4f67dQcWxCGEnqRC3Se7dp
	xT1fnNsPItd3h8H46wX11CPGwwgGpR4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757411757;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=uuhn5XZ+k/yXfBkz6uI/EJtHiraKm76UcsqU/6SM9xI=;
	b=he7uv1ANAW01eUnXD+VlJxKPV9Yg/8eHB0FFOy7vX9PsI3RMRddchVeInBeXBfCt+Njqsd
	mIZlrOJICr129i4mcdn8gv6Kn/R4KeBGOenSyIexiOOP5RkI5uCpfEj1ysuOuesGxJHpra
	tsdiZBstVMj0VcVmxEbVH6/XjqSqP6k=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-674-umyGDvwpNUKie13bD-6qhQ-1; Tue, 09 Sep 2025 05:55:55 -0400
X-MC-Unique: umyGDvwpNUKie13bD-6qhQ-1
X-Mimecast-MFC-AGG-ID: umyGDvwpNUKie13bD-6qhQ_1757411755
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45b9912a07dso32781325e9.3
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 02:55:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757411754; x=1758016554;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uuhn5XZ+k/yXfBkz6uI/EJtHiraKm76UcsqU/6SM9xI=;
        b=VzvUFZvtXsAXT8B2c24evWtBnYK+rTrlT9Oqim1CtpzQrNidjS9azmxEqIVVMUsxtG
         yQw3wWX8Z04p3xbJQ9hQPYPkzSJ2CLpr5doftRUFsGc+XCuinYP/VlaTrdmH+678WlPf
         3XkVMwOJF1oMfv5UAjaw7t+umfHKqut7kdz34eRZRRBTtUz6ZErFd+h3hYTs7o5EOlz1
         8z8+I3ibZ/UMnbPVEuBTObJv9k7Z7td/y3lc9tUZihB2nIj84439FQwAAeipHs+Lryo1
         QhF/u+t6ij5oku/+oTNe0RKNDfDpu3Tl3WSiPpZLWHzAN2BW6de2kuz8Y8z/MBjX4JBa
         qNBg==
X-Forwarded-Encrypted: i=1; AJvYcCX18I3XfGt00P5qwA9lEs1uEsXgRIdglAJu0QIGiXmNQgjUX3CA0KJMFEnphPWvyczGPhK62LudTw==@kvack.org
X-Gm-Message-State: AOJu0YwF+HVBvI1mVNEX0mJYtqwsOfKxMujDAnAvUDPBuKdCZKmHz2fK
	ckf9pcQ/8oj9P7recbX/Mc4mRHGwDptAdUW9lg/VJIh8Cd42vFJjc3IaC3wY/ZMm3ZdH1qQMGbF
	5dWgcDpkCD69xk2F3VqcvDLZTYSzQlnKrVruwetKhQyS5zNwiKA1u
X-Gm-Gg: ASbGncv4LZob9TdW9Lj3nMkPx4VXHPq0/klE/oKeU9lJPd4+ozxBgKUCe0o+NI7rHib
	LgHhM3WVpMvp3i+eotSUrflKblVu3U9Hh2F1HVItly0iX5o0IWTpGqTYxrkSTl1S09pGfrJ5UqO
	BYJdeRQQrB4FZYgnOxTRADrEEn/iA1EU+FdXkFC/bvKvzG20ESQMcJQins00sVdwYwx1UVQWTr9
	b59rE1bfhDbGBx2DyokHr0G4MToPSvLp/IsExztRDaVhofo8hiqfGH4Ybz8hIQYybZ6QdTx1VQQ
	fCmrcYSyiTKKZIBowfYi/N1QVPBtVioTXxZko+CrUtmb7VQrBx4hx7f5NLd4hKIltG6gKOwvxmk
	w505QUeiT39RjfyMBYW5WiMZN0RWTS67mxOhMqv+j6pj4C94cAeYlBg7at4hf1lKCQTE=
X-Received: by 2002:a05:600c:3510:b0:45b:8366:2a1a with SMTP id 5b1f17b1804b1-45ddde829ebmr106120415e9.11.1757411754439;
        Tue, 09 Sep 2025 02:55:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFywLrR0DszeWqgd9Y5zxb2+w3HhCmkVKXj/s/GXP5Ci/2ssUudLpQTkEWfsIqoDp37rN0MYw==
X-Received: by 2002:a05:600c:3510:b0:45b:8366:2a1a with SMTP id 5b1f17b1804b1-45ddde829ebmr106119935e9.11.1757411753943;
        Tue, 09 Sep 2025 02:55:53 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f23:9c00:d1f6:f7fe:8f14:7e34? (p200300d82f239c00d1f6f7fe8f147e34.dip0.t-ipconnect.de. [2003:d8:2f23:9c00:d1f6:f7fe:8f14:7e34])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45dd296ed51sm228257165e9.3.2025.09.09.02.55.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Sep 2025 02:55:53 -0700 (PDT)
Message-ID: <6ec933b1-b3f7-41c0-95d8-e518bb87375e@redhat.com>
Date: Tue, 9 Sep 2025 11:55:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 22/37] mm/cma: refuse handing out non-contiguous page
 ranges
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linuxfoundation.org>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
 kasan-dev@googlegroups.com, kvm@vger.kernel.org,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Linus Torvalds <torvalds@linux-foundation.org>, linux-arm-kernel@axis.com,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, Marco Elver <elver@google.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
 Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
 wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
References: <20250901150359.867252-1-david@redhat.com>
 <20250901150359.867252-23-david@redhat.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250901150359.867252-23-david@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: CKTfyBOUuj970iXWP_BUI4-wBjLnFzD6YNU493w-bOs_1757411755
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8D071140007
X-Stat-Signature: kno8m8q4fo64ixnnyxu1zhf94ztpc18c
X-Rspam-User: 
X-HE-Tag: 1757411757-835952
X-HE-Meta: U2FsdGVkX1+Y0jZeEnGp7PiEGMvS5vYhLs/ip+PDVjLsoZrjtcRPG89oVeDAqC/tqW3TN4zLftBDRzhUKIgKiwoEpWKqp7nzT2lLX2dlxpGa1q6uU6VbN116O+O/TdAb5nw9Fo5cp+2IkqIli85q+5zj/2kLIhMS9lXtpr04xtFFL3bZ8GlT+8gUI8/GeHlJ2zCNPd3rBS/pOg6GXtqIArk/TpjTtnMyUM8+QhJM6br3ki51MRJSeEqdBJTTGrUiG2vOs2eBZdgxcPf6S6exkAcYawnn86youwp5HLvP11ZCbEzeI/DLP1uoBAliBC0LWyq8RzpC+6tx11lfQCEU1ZjK1D4x+y7ZA4qFaRAp3iBvzQGX1HOb99ylIBpk2eehFsH0Lv7fd3TnQVaQpYUg50WCVTG2BBr7Jb1KGwogL3RlkNOdML1aEkmLXvH7FsMXp3fBFhxIQ4XcJZwS2erq2bEgwuCGBEsT+9pn0Ae9+Zfpfs+kRV5W2Uc48CVTI/qkoaNxHFJzrbbcmgrn4tVKstguOcsuG4//ntGwfxnadwV+UU3IRchBDLe1QqaJPCot78nFiAkyioHO27kQhGFeB5SuIkh+/o7xXzde9j3gq0Ppy3x+RD1lsnVbNLrrQDnNjuc4anEDDwo0PQIeXgRAj+FFrAE7Z5HsXT1UVHO9FO09xP53nIKtm+1km3Ofrqnx/zxlohH9mVK6cQiP8epCBCFahbWj4mNs0DP7UN10FOqSn0HY5j//9pqH+2oovBRVdXQOjQRM0Va3oDDFRUt+SgC2/mCRYhKTpcaW6L7nAguezdvihGQ5taFSPaoaxCykafd39IuoyZsx2gdM2pl4GG0xzq+jcZK13nI9I0OIGNT891xfOi3jYtp8h+o+1pl16xGZUJepwwIyMUjaejb66Xl05t8idyim4qfplTAumJYF3ION6LmYaZOpGRdvugH8ZXFUaU4ZRx4ETJ2+CWo
 zEy8s6hB
 kq6BN52pf798+q2hhNguiZ211Jz0BZrzjs7+BbcDXo+7574CTcT7a7ExeP7oaN22L1AK1L/Z7y3vvgC17v4CbiYvB00wZgAvFsRbm2vxM/LrUXbsv23u+KpLhGLDTqME8I02GqB63bLHJpfIEQgPB/pONTp2OJdph5Js16lrRcJK367/KK7hCp8N7VAn760fpzcMjc8joStrblaTGBwwH2SkS+bmDJH+8NM4Q9csNjokeRPAMrIzN4zCm3Q9GBEAcglGk1NahJU7hdHe5Tek9ZdlPT0x8pLN2iZS0bkgZdehWRqJ98UQAmjyfKxSglgasiXrdoAi24Z93QCRZXoGMEcmkDQVF8+zmmHaQV4yTvmjpZoBbY8LJoV9EO2d8i/HJjpCJCVKyR+KJ9q0AFamBg40JD+llzj2KsLQ9BAxwhOeI8uiMf/F3/jM83Ruzz3/FvSXopTuS8BAiY4RK0rSrt2yMtguWX5QWzyksRFhtlogEqH7XA+6843fGx+8QfGiQp/bBfigpajigFb4K6lGOKmfQk3wCDVICnT20xYStXAvwMB1H6+AYoCiSNi1doJ8ZRL0olDhatit/rDpiDK1yQapGlg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.09.25 17:03, David Hildenbrand wrote:
> Let's disallow handing out PFN ranges with non-contiguous pages, so we
> can remove the nth-page usage in __cma_alloc(), and so any callers don't
> have to worry about that either when wanting to blindly iterate pages.
> 
> This is really only a problem in configs with SPARSEMEM but without
> SPARSEMEM_VMEMMAP, and only when we would cross memory sections in some
> cases.
> 
> Will this cause harm? Probably not, because it's mostly 32bit that does
> not support SPARSEMEM_VMEMMAP. If this ever becomes a problem we could
> look into allocating the memmap for the memory sections spanned by a
> single CMA region in one go from memblock.
> 
> Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---

@Andrew, the following fixup on top. I'm still cross-compiling it, but
at the time you read this mail my cross compiles should have been done.


 From cbfa2763e1820b917ce3430f45e5f3a55eb2970f Mon Sep 17 00:00:00 2001
From: David Hildenbrand <david@redhat.com>
Date: Tue, 9 Sep 2025 05:50:13 -0400
Subject: [PATCH] fixup: mm/cma: refuse handing out non-contiguous page ranges

Apparently we can have NUMMU configs with SPARSEMEM enabled.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
  mm/util.c | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/util.c b/mm/util.c
index 248f877f629b6..6c1d64ed02211 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1306,6 +1306,7 @@ unsigned int folio_pte_batch(struct folio *folio, pte_t *ptep, pte_t pte,
  {
  	return folio_pte_batch_flags(folio, NULL, ptep, &pte, max_nr, 0);
  }
+#endif /* CONFIG_MMU */
  
  #if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
  /**
@@ -1342,4 +1343,3 @@ bool page_range_contiguous(const struct page *page, unsigned long nr_pages)
  }
  EXPORT_SYMBOL(page_range_contiguous);
  #endif
-#endif /* CONFIG_MMU */
-- 
2.50.1


-- 
Cheers

David / dhildenb


