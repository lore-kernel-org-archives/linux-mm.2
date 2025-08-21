Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 730A6CA0EFA
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 20:07:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1E2A8E002E; Thu, 21 Aug 2025 16:07:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CF318E0027; Thu, 21 Aug 2025 16:07:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8982F8E002E; Thu, 21 Aug 2025 16:07:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6ADF38E0027
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:07:38 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3594F140542
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:07:38 +0000 (UTC)
X-FDA: 83801849796.13.63803A6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id EBFF4140003
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:07:35 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=E5sl1wE1;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755806856; a=rsa-sha256;
	cv=none;
	b=chsst94vEr3qfD49ED0iCb2gRAPd9thxL155/m5GX1XXRvS4UoE6NxAgn8k3ked+isWX4S
	v2YcSwyLzcAlYvpI91oIL9LhaCXveTTH1N6bEVEcI1G2Hg11djAAreqZ9wvm5EwVUbcH7b
	OSL+K9KK/4dhcSmZhUm0e5LsCZrv4RI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=E5sl1wE1;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755806856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r/kmddABpvZJu5K+QD662cz6jOGE1r8xokeQdlRgepQ=;
	b=uLvcg7YbGmtOdJHMKhtoEE+d+o7Deinw1ZArEdG2Te2PozVqXQyjeGeEnKupF7Q7tYU7jd
	ZEHmHFl8cA5rZMly5D7a59kZCVh5L/SpPnHQWCPkn/vecUJiQD0XKfSs1fifxe+0+jdEIy
	MHjCkVCozgBkixEdkTWhk0d1DbOxYKQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806855;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r/kmddABpvZJu5K+QD662cz6jOGE1r8xokeQdlRgepQ=;
	b=E5sl1wE1CIsFxUa+wftRZxms6HR2vxmvN9JdZjJYNl0uTyOJx5CZ0nCloW0VrKdexTfYgZ
	N3+MiM0LTD0pGSt+G0DAUw0xS5VRBIWbGUtIJRjsSdrsQzmH7qeH3FwG7wtuUKGm6qW68O
	nSiCz60weTDbWZ1Z4QK1GAoMaZsCJY0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-126-HLYDp20kNV6Q4OLvxH1p9w-1; Thu, 21 Aug 2025 16:07:33 -0400
X-MC-Unique: HLYDp20kNV6Q4OLvxH1p9w-1
X-Mimecast-MFC-AGG-ID: HLYDp20kNV6Q4OLvxH1p9w_1755806853
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3b9dc566cb4so996111f8f.1
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:07:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806853; x=1756411653;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r/kmddABpvZJu5K+QD662cz6jOGE1r8xokeQdlRgepQ=;
        b=asVrKj63I9NVjytluSWJebBTCauQhCvhklKTm/Jnt668c8gYPm0XXZfJqIySCq37FU
         ea5MQHuxCMpKzaRxPWfk3U0b1wK+qiHI5y+MwEKpUY9gAcrsxBVrkqzvPQ7z9sNQHPA9
         1cZgmqS4AFbac0ilHazhvd9o1w9ZDuC6XN+XbjTzzQnaBWR3nW4MjmJff40XplAItjHk
         QAiRNZrM1RMs0oeX2brpEFJeSJXdRkg/ku9kha4ABOmtp2qNGMN9NKSGQGgILhUN/5Kd
         lTqr0iTjJS0BLZiNpHDF92e9aaW3HFPX5Ph/wy69GnpEQNN49ObviJzYE6bwOnF7Kz4x
         pUuA==
X-Forwarded-Encrypted: i=1; AJvYcCXg29k7MeZBDiaBOCgMdTXkS/IY8aVKwR+JXAVWQkZVSIFl0VtSpp/dp+UaL4fIxTrhxmrgq9Ol5w==@kvack.org
X-Gm-Message-State: AOJu0YzaxCXeLzFABEwhy4+NAPgsonmyktA2bp+OTj4bA+eqP015qW0I
	Ai6wcgaRmm8GXlQTvh5qqoT4Wewllm2UYRHMbmFE32bCWLT+TWaYTBzyH2hE9S+bjtMZgISwmEW
	Jwbqctv8ksNnjQWDHUDsgukfesSEHXSGtkDXlcXZDJw6RUt/ACWVz
X-Gm-Gg: ASbGnctxscKYQhNkIvo+XgnPliMA0Ea+QVuwmH093VDBSI8vLmMgIRdNZR/9FksQ0dI
	PhtZ0WSB9EOhK/TiPuOaWvkzo8iiX7NqSld53zcPCIXbJ5DKXey1ZqDHO09zg83KOAbKmACTY2A
	cBjvEL+5USuOTRhd35NReVxRXBuB+pM0fYGeqNOzBfML5WQsqH4IImCMhKlIvlqdMrjWsste8uv
	79TP7m7fVw6rFvpmGW+po13fO9GmrSGcL+cY+VbQZIGnnEJHLUSdqsTDGzcRMgNxcBnW583R/aZ
	blH+PXAVJKeqZtwhMVo3cB1z5sYPZm0btjhwwRSP2unjJfm+vyImnYCHK/ZNLMLHLwys6bJ7ejN
	rvtES9dwxl/tT5xedvIbHdA==
X-Received: by 2002:a05:6000:2dc7:b0:3b9:15eb:6464 with SMTP id ffacd0b85a97d-3c5daefa9e0mr244704f8f.15.1755806852614;
        Thu, 21 Aug 2025 13:07:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHbqF8V2lF/CygktHxSJZNB7+pmyneW6nxhnLwTxWefpTwvecQ9FG1LkYH8lxi0WUYYPrMQFQ==
X-Received: by 2002:a05:6000:2dc7:b0:3b9:15eb:6464 with SMTP id ffacd0b85a97d-3c5daefa9e0mr244660f8f.15.1755806852102;
        Thu, 21 Aug 2025 13:07:32 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3c077789c92sm12629958f8f.52.2025.08.21.13.07.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:07:31 -0700 (PDT)
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
Subject: [PATCH RFC 09/35] mm/mm_init: make memmap_init_compound() look more like prep_compound_page()
Date: Thu, 21 Aug 2025 22:06:35 +0200
Message-ID: <20250821200701.1329277-10-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821200701.1329277-1-david@redhat.com>
References: <20250821200701.1329277-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: UpEegFs2zkX8VTUpEZg2uhQfiWiFV47_VWW9pBxDpQs_1755806853
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: EBFF4140003
X-Stat-Signature: r1cox18hmm1xebugy41q6ngcbofyk475
X-HE-Tag: 1755806855-749303
X-HE-Meta: U2FsdGVkX1+iCVnRblng0Bld0zWUphU83AGnMozxKDJgmO7hlACaSfU9KKiXR57hIKoAlBp/R240SY9KrMbeTo7UzA/yY4hu9of1vABflioteeaCzGE5wrIbqrdVPkr21CvGLX27xqM2nkHO6c3bVUjcIcWmhpS8VTgLf/WYUxGNoBW9t/3RLSA+eDXfQUpjhLFEu9MHU044iPi73W5FwynISw2l1eKii3LQ/UtXz4xfe/Z+KPc4xl/wUEIm8Saww7KlNXrdNbLUUbOGyeBW3OhpR2xVzjJN/mS/XfozdhjIOv/y10zP9WiPxYFkKjyv+Ju2JBM5rM49wVaXC01qZUeBIM+mjdK656czvl66VuEuusSWlv2C+9GrteIR5qUK0wJi9mEKhTRYv9MPvEguktwzq3c7ROi1zsFCUNGqRfn4GE+oL4isY//wF9FcqqMZqqEoLG+l0hA5XAIIqhavDnnDFvMhKbRsY0PL/+I6FPA8sOk9R4WDdtgRVOaGR+ZvpCXMOaf4YRMVWUkdyxblZ05VkDa9lbhdcDN1NXDtLilP9SUR6FSMZb2kIk5WDYpUDbbDFLeX4s6yTZhnMBjprrMxMSkp2q3nzzJnUGSONHWG7XRGjwAtL+Q8WasOGYVmD/KFgP7Q0U8ync4YSzs8hhmqXnXmAp5lU1LobjiyUi9DPlNKg+odvBioBTtPf7LL9bdTZrzZBDCWvlqZtEH1qgtujyo/vpuoD337IIjm8Apf8H9dd2r9hbu9Xv8GBrjp7W1lXN9FNkvHL3bb8naeyeALU6x/L7LxjJgugbcFUEi5RVVGtu8LVUWCrfGIsWkmfHsGvoRHWYQWCijzRcXjRVNUsZbQWJhrxuEQCuna0tHq+1Yp5jHWXseXOFF366zbIZcvgfBSnfrsJbmvx0jRs4CJ7GKRZuuSHP3NHEptT5bRVdTKIhBEXU6lsNTZ5WPt6iI/xFB4K3+bGydFGuS
 GJTvAYtb
 WGh3SGUnuOZF8GOChgTXVJHglIsAOZ5+4NqiQ7qn/Ce6BsE2hVLLulzgtWzyx5sB7XGQqDwdOHP8xPXVb6gNyf7PxYx3wW8WIdSYyAcc4X5nK8M6F8erxfvBLbIG6oFO5+yJ6tA6u7M5TmPb0dLBoikoT+9+TRmJ1keyS409T+AJeYcO2r72Vm9eYu72J6/uthE8hjGnxfWMlri5dQ95N0cJgsDxcqoOcFqncSXf41Y2gudGrftzTfnBnZ2Xnm3aHBN0FYC2hZn9c32GCjkyvQP0QAbPw9sj0jxB6ENVkhbOsARP1CdN2tO+e1s4SFkf2ybfBAWKQo0tIfr/AQwFAe7A+QwWsmHEmUP1ZmzTsxoHzkgYdO6GOxL+FhqlDE5WcRP41MsvJJiL0tya5T9UMZ69Q8STQCZUxHeTez6hLbVJNnHzkyErfL9/bBjI37qsVi7mV+8emvNcNF3JfZizdcaybEarvYvrIDdZWymuZjq1TCIEorYodRxOPTIChji6VdfXXWFwYBjOqEsC3xp/Xzs8csZTklsNwluFavNBvEF2dWaK6WECx2vsAIg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Grepping for "prep_compound_page" leaves on clueless how devdax gets its
compound pages initialized.

Let's add a comment that might help finding this open-coded
prep_compound_page() initialization more easily.

Further, let's be less smart about the ordering of initialization and just
perform the prep_compound_head() call after all tail pages were
initialized: just like prep_compound_page() does.

No need for a lengthy comment then: again, just like prep_compound_page().

Note that prep_compound_head() already does initialize stuff in page[2]
through prep_compound_head() that successive tail page initialization
will overwrite: _deferred_list, and on 32bit _entire_mapcount and
_pincount. Very likely 32bit does not apply, and likely nobody ever ends
up testing whether the _deferred_list is empty.

So it shouldn't be a fix at this point, but certainly something to clean
up.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/mm_init.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 5c21b3af216b2..708466c5b2cc9 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1091,6 +1091,10 @@ static void __ref memmap_init_compound(struct page *head,
 	unsigned long pfn, end_pfn = head_pfn + nr_pages;
 	unsigned int order = pgmap->vmemmap_shift;
 
+	/*
+	 * This is an open-coded prep_compound_page() whereby we avoid
+	 * walking pages twice by initializing them in the same go.
+	 */
 	__SetPageHead(head);
 	for (pfn = head_pfn + 1; pfn < end_pfn; pfn++) {
 		struct page *page = pfn_to_page(pfn);
@@ -1098,15 +1102,8 @@ static void __ref memmap_init_compound(struct page *head,
 		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
 		prep_compound_tail(head, pfn - head_pfn);
 		set_page_count(page, 0);
-
-		/*
-		 * The first tail page stores important compound page info.
-		 * Call prep_compound_head() after the first tail page has
-		 * been initialized, to not have the data overwritten.
-		 */
-		if (pfn == head_pfn + 1)
-			prep_compound_head(head, order);
 	}
+	prep_compound_head(head, order);
 }
 
 void __ref memmap_init_zone_device(struct zone *zone,
-- 
2.50.1


