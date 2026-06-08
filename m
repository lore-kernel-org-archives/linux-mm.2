Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB743CD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 08:41:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E2C86B00D8; Mon,  8 Jun 2026 04:41:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BA626B00DA; Mon,  8 Jun 2026 04:41:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A99B6B00DB; Mon,  8 Jun 2026 04:41:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 18B746B00D8
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 04:41:00 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D67DF1C2B71
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:40:59 +0000 (UTC)
X-FDA: 84856100238.01.A47F600
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8537A40014
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:40:57 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gpyB1DFB;
	spf=pass (imf01.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780908057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P4H6i1o8NtKwI7+T7msfk1MScFiiY05veUMkpUANhzw=;
	b=yIE7GxEP68D/DxnTGnRkiCbdyRIHyV7g0yqjvNSz0gIpCQ8x4G3a1hyn+f+Ov11S7pcZLp
	HYBlMPB3vN/Sk5zSJ5hWDrSgCylCddGgJTfLyuHBJlz4zBvVXCnx20ARUQW0tJDOjhv40t
	rNKWx4yVzDJVwC5zyGXUfdCCGgutv5M=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gpyB1DFB;
	spf=pass (imf01.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780908057;
	b=X8JIFSlAKZmnOmZ0JtDBEa1Qi+ElRLljGrFrEzBDa8+GKRrAfwzvrtjYQr6Zexe1GIxmus
	+OfguxumsucOdoghLVtYp1rU6kPvW2lBQQ2mIIvvuQNNHGQDlpdXsq2BgqZOaCW1ZMDEg8
	qrew3KVLEVLpoMaCoaCphQiLVal/6Jw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780908056;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P4H6i1o8NtKwI7+T7msfk1MScFiiY05veUMkpUANhzw=;
	b=gpyB1DFBHBqRt8TxVV/0gphRmaODaMN1xJs+swGqMZ9a9kF/mA6ZLs/ZG6hOZBguTyARiq
	JyT+MhUgWZ2JimftVCXXQ8sJ4lNZGz0DUKXZuv/oRAusGAqz8jPUgQtoh2z2yNlAEF/PaC
	PaoaENrZ6/9K9536Dd6V7FYl9X/tjk0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-387-NmNEQVQQOJWm5vEshF1WpA-1; Mon, 08 Jun 2026 04:40:55 -0400
X-MC-Unique: NmNEQVQQOJWm5vEshF1WpA-1
X-Mimecast-MFC-AGG-ID: NmNEQVQQOJWm5vEshF1WpA_1780908055
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-490b37e1f48so33645265e9.0
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 01:40:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780908054; x=1781512854;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P4H6i1o8NtKwI7+T7msfk1MScFiiY05veUMkpUANhzw=;
        b=WhbvbiYjXInM6f/WdTWVaOnkyFGxLQ6QSDsArAh0kkq/6EWRJtJdCr1oKs5EmaKMvW
         IE1eqpfqX9dV/vhD+GTKrQOt69d2G3YHlror88OozzR6+S8gufOBuqOxXHn6notMLTow
         TOPw+xFGCGaWghRdy+LmSMRznCA+61gVLOCix+tbTvNkE5L3N3YPcnJNza4R8x9lvFp4
         PwCDJgDNRPNkZV39Lqa7XjzbO9/LSWgIzk4SFvZiAs1q8rfgLUjhW5v4fNXS1ts6/Hit
         s36zekg4u8sMAYK+GP3jPlFeVNlqiuIVqopNZ6crMXL9Nyl4Cfn23JqDrmCnWlb6REGe
         mpjg==
X-Forwarded-Encrypted: i=1; AFNElJ+5XJ1jhPfWVnuBWP7yql2uT6JzBee6p83GIck0wXb1pdzAI7aV0H6kbZpnqfVK2Xcp4i0HqxWdaQ==@kvack.org
X-Gm-Message-State: AOJu0YwHD2jY2IWbQD5OPzEG22/eByOg/6iWRmt2lgYPooKRqD/xHRrL
	t+5Nr9/dCslpklcyO9cs5FN3XYNbc5/sdbnubQZTJIVaaGJc4jf1o+zS/fJhttuIBiXUlsq3Ieu
	kLM8+9xsDNlJtJGMRTs7b9NlrnjJh3XW+T2dwt5mXXgE+IuZCcdZo
X-Gm-Gg: Acq92OH0oYcGLnYikmScqJBoQmLzXNlWX26fFWjpmslOGON9jr3+RvsIctIkUCkCcy9
	rzTEyFLcnUSEADjX9O09ROvAGpNRfclIpjaeAjXPwuBEZ44g5Vvsy7Gk7m+EL1IUlXfTt/ExJWF
	u9a1YP9VO6sY4s9NQgcSXCwhwkF239JrIz9OK2LBjhAhWSzaG+8csL9B5XDDW73geDCfkyP/5nG
	fqMNk1sMthsxChB5PIgAxk8kg6f90ipHjPaTGkxcCT5PevRDi9tsXmeMI9Ww/YZU6mRzTXCudJK
	G59NULg39CksZOyjPJaMpDT8Vz+9z5LD1rb9Ev31eYEUHzj2PAJi1Znlu5ypW9UJlVIhiK4v9Lb
	KsZxukdug68Drxwc4A0MA4/0=
X-Received: by 2002:a05:600c:c16f:b0:490:b8e6:be40 with SMTP id 5b1f17b1804b1-490c25fc0d5mr237785005e9.21.1780908054481;
        Mon, 08 Jun 2026 01:40:54 -0700 (PDT)
X-Received: by 2002:a05:600c:c16f:b0:490:b8e6:be40 with SMTP id 5b1f17b1804b1-490c25fc0d5mr237784245e9.21.1780908053964;
        Mon, 08 Jun 2026 01:40:53 -0700 (PDT)
Received: from redhat.com ([31.152.37.159])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3b5b06sm343164275e9.3.2026.06.08.01.40.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 01:40:53 -0700 (PDT)
Date: Mon, 8 Jun 2026 04:40:45 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH v10 36/37] mm: balloon: use put_page_zeroed for zeroed
 balloon pages
Message-ID: <619342ca2c01c60862fe49cd4a790d171cd65ef3.1780906288.git.mst@redhat.com>
References: <cover.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780906288.git.mst@redhat.com>
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fZMdMpptFSGGTgl80af8jTwmg3KazoCSVLjBmIu-yOg_1780908055
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8537A40014
X-Stat-Signature: naop1cga8myt1w36qcyr3z5mxpjfx7ia
X-Rspam-User: 
X-HE-Tag: 1780908057-359916
X-HE-Meta: U2FsdGVkX18KiseLNdR1QyUFX3jIg6J+EOqRaS95I9AL3fqmb4yTISIs6/UD4/MPbLJOy4kIGXTkr53fA3VR1PRDmMIXnJILJhHYtMiq1H2ptqjU4oQ1ZLk9mb0dZpycFMBemGDG2qyqtI4Dhd2Q+EucuudQqddOFEQ8u0km8pjeBrtN5P0oFlHkYmFx/qSdaeWjs1etv7h+pS4KF66/3UxcY2uIIKpapXEaKkDyzHOuJgkj9i7rt4NMTq9u/F6vOTmKEUK7/COwX4qqBIlCizG5WCAONZhNB3irYwVsZ8uS1cPWSWJgFCPHXxlPG4QT/s38lFEvuOD8sskM0iCmY+afs4j6ITkxUmKDoNyJodW/cJiVPGGfnqwb9lYv4m4UEZWAcS7Kap0B0F1bFEz2Xevz1TASAiftZgfF+oH57Jk6Aq/vcmIrlARKcTQ+iT7VfUXhUed4X07/z/hf0MY0zTnAkqfPjiP1fVZo0n7nIdpZE66N0sRoWKp5ttbuKlQe6kIxWwaNtnKgdVaYh0WjFY4ezbkonL03j6iAX7qgJJTluygGBa4HrBqeD+UsdedCrYrNW/I4OMQXG9eX55iNRA+Vz470YGtp5NQYiaBdO5JeW3EYchl1WiHUzterH1GSD6nbjsTh8hdUQBy0BU7WqW+DIu7+0Rx7Hh5cqM5XsB82N8bq2JOT5r8FWAMA7Vbh5D4pI36YFeFsQw9TXm18RuCxpZCM9dh+6C/a4nnsG3vDiJuNfBH5dOiAEOU00nJce+4eHAW3u1zyQIPnS/uYfTcwXUjAGXeEhmITNESColzJ72KvrfAm/2ogMsHK8bu9UBBToABFcekNb/C2ydIoidrXbFKJmr1rBmg7JKfSz0ngKIgA63IM/vBamHRpZgiBbosOUqUvSo5eIcZ0McQyVdshBF/Tuty0r7Fm7vLT1ZVJ28IqpUqkOHkeUdPxmChGErGRZOJrm7A1co2dSBn
 5lKplf4f
 lDz0nFjXVrPCRLtd0zVr5fb7osmTh5ZI5wzoq4ZSAlW4UdW1lzs3N/k/oL41egZuk7cvU42t3yhaylK4BgA/KKivXVyfDMoqlNsZ3o0MS1ojE0mYYGXvFD56XkXLdKANeWoJVEGSMHSBUWYNRvawz7mKJfnMWGfHFcRAHsa3cTiuTTb67ffAwZi+9IdMaOJZ649oemyLoCK0mBOs7hR87UFKhdiSURV18fuMfJ2p4mvE2NaEvgr4Utkyc0IdWUQwwSxKeP34nOciJkqfXi2W/k0AMkdiLuEdp3767L3Pto8lWi8ZMxA8Qr1rnqIwkMBYX9MSixvrEEhURdXi3eNiafZfITRc8viAC9TCWbVQG+u5wWFAV6kp3mxEiUhzMUurtuEX5eDTCtOp3acqHM06CcixFVxD7MXDzxPVp9smEHi5q7OFAxzY0aBUBHVfefAhteGrz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a balloon page marked PageZeroed is freed during migration,
use put_page_zeroed() to propagate the zeroed hint to the buddy
allocator. Previously the hint was silently lost via plain put_page().

No page has PageZeroed set yet; the next patch
(VIRTIO_BALLOON_F_DEVICE_INIT_ON_INFLATE) will set it on
pages the host has zeroed during inflate.
Note: during balloon migration, the migration core holds an
extra reference, so put_page_zeroed() will not be the final
put. The zeroed hint is lost in that case, which is
acceptable: it is a best-effort optimization.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 mm/balloon.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/mm/balloon.c b/mm/balloon.c
index 96a8f1e20bc6..6c9dd8ab0c5d 100644
--- a/mm/balloon.c
+++ b/mm/balloon.c
@@ -324,7 +324,15 @@ static int balloon_page_migrate(struct page *newpage, struct page *page,
 	balloon_page_finalize(page);
 	spin_unlock_irqrestore(&balloon_pages_lock, flags);
 
-	put_page(page);
+	if (PageZeroed(page)) {
+		/* Atomic to serialize with memory_failure's
+		 * TestSetPageHWPoison; not under zone->lock here.
+		 */
+		ClearPageZeroed(page);
+		put_page_zeroed(page);
+	} else {
+		put_page(page);
+	}
 
 	return 0;
 }
-- 
MST


