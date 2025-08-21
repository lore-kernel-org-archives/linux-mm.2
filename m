Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14131CA0FE7
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 20:07:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B376E8E002D; Thu, 21 Aug 2025 16:07:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A43E68E0027; Thu, 21 Aug 2025 16:07:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 932FB8E002D; Thu, 21 Aug 2025 16:07:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 812C38E0027
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:07:33 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4EEF11A056F
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:07:33 +0000 (UTC)
X-FDA: 83801849586.22.62AA901
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 169BF20017
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:07:30 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YjT7EvFr;
	spf=pass (imf13.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755806851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A9Znt0atqEjtEUkbTSfKRsvBJ9rEcbnqI7Kn1XkJSrA=;
	b=HSgkTjphJkO/q0FaABDip63WY+8Mkk0aWa2VN54iIgtbbuovUlJgu29VZ3Plj3SLXvr4jv
	ZRBIeYCQAW0W9/3uQzrOxzqqsPOqNNNpc6hWPtSfHOsw3rGWOW0mdAQlE9H3Ms8fNIl2DG
	pMX1zQo3+ak8IAHtAIJNPTRLCHsHxsU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YjT7EvFr;
	spf=pass (imf13.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755806851; a=rsa-sha256;
	cv=none;
	b=frh+dtc78j1ce/Do4sYnmian4fqPcQbFDgtVNhYTtfzmABYsIl7lv83G04AhSEQ3FJnQHi
	tgNTlOJWyWenURUzK9zfGlZ8pQN4bNennNqDo1jL4eTEqVOPZz/duIOsmRQl8qwT5oEmRX
	OWpe6+8waLshGkQNd8Rn79u3jHQaz+I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806850;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A9Znt0atqEjtEUkbTSfKRsvBJ9rEcbnqI7Kn1XkJSrA=;
	b=YjT7EvFrJT5scdeM5Zhxs1Qk/Cqch+J+8hIxWxlHb7nVNU02myxpnBeJveCAmU84L9yDad
	vtsRlwxqXN6zx8RcnWcVFKhynJbqTs2VIm3xSpDL2hddvTFVyKK/czblWXG8Igw2XVihhk
	Fb0YTZpxr5lzYg/3oduk7oOlhbYva1I=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-178--DRbtMESO7K_uNbQHXZLHQ-1; Thu, 21 Aug 2025 16:07:28 -0400
X-MC-Unique: -DRbtMESO7K_uNbQHXZLHQ-1
X-Mimecast-MFC-AGG-ID: -DRbtMESO7K_uNbQHXZLHQ_1755806847
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45b4d6f3ab0so8376805e9.0
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:07:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806847; x=1756411647;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A9Znt0atqEjtEUkbTSfKRsvBJ9rEcbnqI7Kn1XkJSrA=;
        b=aD+LtW/Ftn0HRFntj5J0mMUY4V9YwMF4xk3tmVtUhFH7x7WVNXCFhFlFT3HvfCUBSz
         RoZV0sJn/hoAbareWC5kuayHigA6QoaXekOHfB0HC11+6MMhiOSr9RtSIy//XebmAhrT
         gstyr/3M7YQKu+3ebmGdEQBxnCyK2+CukZw9SIny9VusvKXN0SFy+UGG/F1AbVB3W9wU
         rhMm94oRma+iAmRGsUqE7ziJMHqOozslnOsRkEHY5Qkkb4BA1AGZBVI2q8+Fv5Jp7+Xr
         3IEnkw240E6jclS9qTrfIb3f+sokzzEYRJeJX0j5LzrNjr1OcVBz7eSJZjq9HKrJKmWY
         n16A==
X-Forwarded-Encrypted: i=1; AJvYcCV3ua4tJGwPR6HSSY/JTo356ZgX/Wr17CE+CUFHu0ovqDxXpOZKhDQOxKc5w9tf+CbdQmwCUdq0UA==@kvack.org
X-Gm-Message-State: AOJu0YwocVZ8naT+o9JZoC0QfbTlEcOXpx4DHJYAU4iEnUk42igNLDBg
	o5QXPUnTtDun56X1rDQbTK6cH6HZ535ZuWRArG7mSZQZ4q1h8Xkv0drjyQ8OY+sw44JFh+xjpUx
	XY3mOWRVGzNccBM1MDW8uyLmDCaxd85l29fG8QOeH02mWzYrNOkr0
X-Gm-Gg: ASbGncubw2lSRESUxU+kWsDx6cwijc0YIgSRuDCZAb92ekrko+Jqtlrlfefz1w4sU0+
	sPAduQFcWiYszGZ1j0oKkk91WskCWrk8bttxw97Wgzv8h+NHgC/NMx3s7cJq1ZPy2PYj0W16Y/7
	Ihk58fF+bqEXqKQ65niPViQEgssnYcQX3eFzM3ULTxgyiEEJM65pE6QtZpfYPB+ch+AqckT0o73
	6g9vuqb/c0rprymkh2MzpOyHYkeKBhnaPBN/X5ZIz8W0USVQ8BGSFcOBPF3IHkcHZWuBXhwEHOc
	R6LwCmAIAgNlXXl1dD72qxEGA2ftipvXNxuBJEFH3xJ71ldwzrBC44pTOdtoABD9qv36mHxhGMa
	2A/F7Ge475iJhuA1Cmz0OCQ==
X-Received: by 2002:a05:600c:3552:b0:459:dde3:1a33 with SMTP id 5b1f17b1804b1-45b517d26d4mr2922305e9.26.1755806847228;
        Thu, 21 Aug 2025 13:07:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGUeapMM5JkcwJNJXC+LM6ICHu4lGUEF2ir46AAuHXhYXAFzTcPIdec/q/lplZD/isU7mGEgg==
X-Received: by 2002:a05:600c:3552:b0:459:dde3:1a33 with SMTP id 5b1f17b1804b1-45b517d26d4mr2921795e9.26.1755806846742;
        Thu, 21 Aug 2025 13:07:26 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b50d62991sm9535385e9.0.2025.08.21.13.07.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:07:26 -0700 (PDT)
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
Subject: [PATCH RFC 07/35] mm/memremap: reject unreasonable folio/compound page sizes in memremap_pages()
Date: Thu, 21 Aug 2025 22:06:33 +0200
Message-ID: <20250821200701.1329277-8-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821200701.1329277-1-david@redhat.com>
References: <20250821200701.1329277-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fDreGTIpBPDbRd5r8bODhQ2L39yUmAIORlJBlxntnKQ_1755806847
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: jsefrsqfa6mddpwnak4rom5fypt6bspx
X-Rspam-User: 
X-Rspamd-Queue-Id: 169BF20017
X-Rspamd-Server: rspam01
X-HE-Tag: 1755806850-403515
X-HE-Meta: U2FsdGVkX1+bt3TOKIDB2J5+87zCJaF2vx0Ki+LBUV5o4h1ivVAZj+EOyK1PSZ2tNboeGN259CtF0b9m72BS5LHfMLp1RHBIAsfAK2cGyxGmVMNa/vjT65HmsFIhv+b5Qha+mFHg0wEn0qMFTIYZQ5wnnnus7x+Z7d6+71iM6+uqiyIkq0HOrHYwCB47UGHUL+Y/SBUc+BcqHr1rPQf2qruyc+y3F8W3img3+O/IOWbvjVs9WFODDIV9l42DNIsUbb00XgKWAXCBJYvZBcwJVF3RUDqFZOYArN/2IJfnY+fpLnqA2I37Iy7x/ggn+eCtftWNYLOlyoWaGCEHKYSxm8TE3aT7byFa7LRt9iCB0jzNBupykG9F0RuXQSlqES8W4ETtpxQm0NC00uzYbqrvPJ2IBNKTZhr6Af60hx6U8U5RAPLVrcwZZCs6b1HlJ/8nByTatyF+HKgcIpcN6rM4AaaXU/Dn1KhmOA+sM2VlQag1NTxOfbN4V0JKAEt7CyhWb4YulisRCawQQn9nq7mH6xS/L8exaxM7IVM9Xs0RUPPrrfuN2JJunhB+98F95zoJS86ROHx+fj44Kkkssn3upn+vgRpt2OD/FS4h5TjddN6yLK4d+EkRL5HeQE6fke6MuId+eaFLUNhvTb5tn7VuIs9E3irrlUhlbyqoOWoLod3VCOVrPD7Sb39uFzBNwyCDcHc9v6hZurgBPi7yzYrpSqJY+pPY/QpfZC4DHEJLOk3Bnm5Z7sQzGfcwGVCpwpBPxNcv/DlPnmKaqj3dqxj9q+TvocwNwTW+QLzlVX6aLLdAEE4fllJF57YkXbhsllNnuvxOpTJwyCwp7zia12eXBjgNLOfs64IUv/JWILGjthaDx9H6nqFoqty6QfTsnpYo27vzxVFRuDzwPq+z7WVoChrPoOVJ93I8jnOTVUV26TEQvqNl8BRCgBLO/O73ehIhxQCXlxyYOdqoZ/YyQSB
 +un/cRMv
 XZXpCVqir4H0OmJDBWxDj+UBm3sdegAawxPOmrddl7dDHzrA5nVHIL6ULzZDDcNIPfsdwh56R7soF0+Xuj2hz/57524Pdi/Wp6q+oNASrbudC7995xfK8xJbcd8+76uuh5lON++7zKL53kEZqZ+1Z8TBuISNE6tAAAYCXY95751gLoDzctQ6ZAPna3YNMO/oET139BsnwZxQFwl4b2RcJsT6TIP82Uea18ZhVRtzhDwTvkr2FpAWJg1P8Zlvhz/xEgSCVAd1e1+b8+pvrYcbOCmrlBflV8HXZO1tCOGwUhkhe3ZWvEX8Bb9hJkkMmz8MHXD44MRemFFkp+siuJdQ7QtqBif15uqNcOsY0DmI6uHi1ss4zuUVWMusARx2/2EcESmkJozId7aJuK9EOHPU+YC0zWnUpkWJ1fS5oTLsgHrmC3nW+Aog8+16x0SAAPtf1aYFNlce9c9RAZi1WG98GUPbzM/XgMOyQoQn3U7KlQGrOo8YDNHo9nU20cUQtskj9A1vrYIBJWZV/npZyEkw1r01CTjSIdof2dxb+i0aGZxwNiXciWrGb4saBFQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's reject unreasonable folio sizes early, where we can still fail.
We'll add sanity checks to prepare_compound_head/prepare_compound_page
next.

Is there a way to configure a system such that unreasonable folio sizes
would be possible? It would already be rather questionable.

If so, we'd probably want to bail out earlier, where we can avoid a
WARN and just report a proper error message that indicates where
something went wrong such that we messed up.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/memremap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/memremap.c b/mm/memremap.c
index b0ce0d8254bd8..a2d4bb88f64b6 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -275,6 +275,9 @@ void *memremap_pages(struct dev_pagemap *pgmap, int nid)
 
 	if (WARN_ONCE(!nr_range, "nr_range must be specified\n"))
 		return ERR_PTR(-EINVAL);
+	if (WARN_ONCE(pgmap->vmemmap_shift > MAX_FOLIO_ORDER,
+		      "requested folio size unsupported\n"))
+		return ERR_PTR(-EINVAL);
 
 	switch (pgmap->type) {
 	case MEMORY_DEVICE_PRIVATE:
-- 
2.50.1


