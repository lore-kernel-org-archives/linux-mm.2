Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E211ECD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 08:37:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EE856B008A; Mon,  8 Jun 2026 04:37:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49EA76B0092; Mon,  8 Jun 2026 04:37:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 366F96B0093; Mon,  8 Jun 2026 04:37:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 219D56B008A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 04:37:16 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E5D6D1C29CF
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:37:15 +0000 (UTC)
X-FDA: 84856090830.22.C176728
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 95918100004
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:37:13 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fpMU2b4B;
	spf=pass (imf14.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780907833;
	b=PbkHI1XX5U+YmnFeYfhMYjqXjfql3qQoJDdVD2Ewj3h4CQUkgaiMIdzWyw7W1KFuC8+bBH
	CDnhTRMDmEr03+jZ/b3AKx1GqkPYThW+aZGOMBw5auS1zp+U9h5Yh/R+Ol0CPlRPws1kvO
	0KQLzAdrLZE3xdcofOA8+9Mf+nF1rbo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fpMU2b4B;
	spf=pass (imf14.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780907833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A0GMQhTq7ZqaOlkJiK0dDinX7wgaWZxvF9PWDzI1B0I=;
	b=5AfXqG0s2q+hZaYLISFMLUo/qgM7FJv7+i+/OAVCRHhL486DovDIAiKYQPSqDBwfAjJ/Fk
	9PcayoP1kzMFslWpQHu14EiDdbCnsFcAbL8o6fDLZljNkYz6NfA/QB5ESTbSYAq6YKZ2ol
	0N6bViRdnVyT3qApvWaPWvyGmz7PF6c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780907833;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=A0GMQhTq7ZqaOlkJiK0dDinX7wgaWZxvF9PWDzI1B0I=;
	b=fpMU2b4BbncjqaQjKi7uBwjja+4eI7UA/8jRfMmtwrBXsBQk6SCMTmtHf6pFtBtrkf8Hxb
	oIlE/UJa25mkqIedwJ3IwK2nE6Wv+4ktSsW29GbcIoWXYHAickS+RLsJFzV1vQ4ecGA8QB
	/IXMTyz0DDbAtITsaqnFGReo2uWOKSY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-635-Rl-AgtyjPKCpSZn8kiEXJw-1; Mon, 08 Jun 2026 04:37:09 -0400
X-MC-Unique: Rl-AgtyjPKCpSZn8kiEXJw-1
X-Mimecast-MFC-AGG-ID: Rl-AgtyjPKCpSZn8kiEXJw_1780907829
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-46010bc0f1eso2338829f8f.3
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 01:37:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780907828; x=1781512628;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A0GMQhTq7ZqaOlkJiK0dDinX7wgaWZxvF9PWDzI1B0I=;
        b=JJG1SNIuNocuV2quENXPkeEkG45w1od9nJ4J3ZbwsBbEDMTZDdIIIb1+q2XAs9ARxa
         L51ply1dtzdZgNwWdWioAQFFbm+M568ju1ayjbJDV/E7/fXSfCPhPj4Jxau8nSfBnItZ
         WGZ5QbsPQQ0WkoaCqQzhVEQPaeVugXj6csTG/6RFsMZV6aK30OhyGVW6hgGUZFtBwJ7j
         541yCXpJ+olHv6FFiDxzdnWv455OGevbWep69b5jVEMqxgyXV1KSai/AOrqO957JDu3I
         BSu1vSYa45wY2r9dYPaGKQnamX2GVw2OCAkYNEjX37reg4/ywtGkScQjhcMDYdKm4Z4m
         nD/w==
X-Forwarded-Encrypted: i=1; AFNElJ9MEn1YLxTGtO5SPr0tzmYzlndkszoRYMAxMaPWU1DEw52CkPpJRThYNSZrsexffsDA7honkf0fNg==@kvack.org
X-Gm-Message-State: AOJu0Yz06v6iUtEQN5iFaEZyni9wHzkx4DesrJPVvFsOifwDBOLfgYyY
	xfv97/Q2EjbuUZ5wmUQiIAgZLsR/3qi9hp3LXLXWG09pHEakiFdC9CtH57A565ufGe7p5VY9509
	1MY61Cfj/HIZNDec1XPuonEKU+qbXLrZgU5/hV25EAfE+W8tUDsKK
X-Gm-Gg: Acq92OEbCy2YxnuKn4wJAmjOYvUM5od8lcOQU2fRp+pf0wr+rPDxaxlY3RAOUIrNeOX
	NTs9fgFe3SjjcbKDi+y8tIJdqYhtV72LtwBi3yz5yK97Rsiy8XdQWM7A0rNQrF+hWQsd+4KGPqp
	mmJhMstJeKRJukZWAXqgQ/yM1CKlEjUNb9sRDPe1F5jtBToKjGM7f4azPVGHdIyrtWkTjhBq9g8
	IAeMsYYZnNNg+PkW+pqpuQuPoZe43Eb1nNdp47COgiuT4TcQxw4cx6l4mZt/yUFmhs9Nc/gYc0h
	XlWke8tCJdEAo7VR0jhG+Gon4frjRJ3fWIwn+BhC+a36Fx2BVpeLYRN4zrHd7a6Xhav7A5ORdSR
	uvhFZlMQtLa+FBILI6Vy5dQI=
X-Received: by 2002:a05:6000:137a:b0:43c:fdd:ea96 with SMTP id ffacd0b85a97d-46030648ba8mr16182330f8f.26.1780907828467;
        Mon, 08 Jun 2026 01:37:08 -0700 (PDT)
X-Received: by 2002:a05:6000:137a:b0:43c:fdd:ea96 with SMTP id ffacd0b85a97d-46030648ba8mr16182281f8f.26.1780907827908;
        Mon, 08 Jun 2026 01:37:07 -0700 (PDT)
Received: from redhat.com ([31.152.37.159])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f2f5612sm48449848f8f.15.2026.06.08.01.36.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 01:37:07 -0700 (PDT)
Date: Mon, 8 Jun 2026 04:36:51 -0400
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
Subject: [PATCH v10 13/37] mm: use __GFP_ZERO in
 vma_alloc_zeroed_movable_folio
Message-ID: <862a59e98104db76ee3998460bfc55e937c218c4.1780906288.git.mst@redhat.com>
References: <cover.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780906288.git.mst@redhat.com>
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1QZ2GAECznV1IYCNz3seoUPlCEQVesvOwZ-ZnMslkbo_1780907829
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 95918100004
X-Stat-Signature: 18zxpxzmi5tcq35oo8ac3b6eg98npdx6
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780907833-773402
X-HE-Meta: U2FsdGVkX1/2BkcMBwaff1aG5/7uHsp7klKiRc8GnX3Su2fc0HFGX3+0ZVvw/jMb7c/un+AIDeBIAg1/woehRfkbmW4Q7lFPKvybyWLM6l5Jwi5nyGWdo1UwnqhZp48gToi2L2VD/jHGZbsyw+fpPbk7ETt4Yq5Qrei7+LV1IYC4+GIehskQ25tUcq2TCs1B6XrUOybVqd8+g+Sn8nH+iEMk1UgoaHg0WfWU38gn6OIUcCC66qqVqZUaWzQDZMzc3KgJJ3jgeTJHydytTEzS6vYmeJG4s7rdaNJmCztmosxsAGYcytMeehGGTMV+JfI2DW33fRLM6eaYa0yNn70rXBDqMpYfVy1bl5PpPBLHV9yGQKoCkMm9v+WoIKvHjwkn53mkQg2l36vy3SbRJlHw5nSM9jnAzdvUDCLIFP8kd6h8NJDSrSCguIVG/mi+6ao/qnkFgpNpRxNG9if/SSJU2bZ/KRchtGsCKgbgdrjRNIyK4428AePJahHz42lWMRyjXaN0+G1ZiFa1/5oN9AcQG7SD7D86KHa57H8/pSge55JT3p9O3v2Ae/66i8fO9j5zAR2HQVBufl/If1lJmKdoCU2fAopsT42TzIXZdZRpNAoEVr8dU4le0RilzC9Cq6vO/rYNKJYIIAyR/U+p7r81D4DMOhRoUAa+ju/OLMIqqBVJFkI2t6Dp6d9Q+06JhN/4Uyo31qZvuDFjaVnYhIil4rzYgu6RZw0fsQJiAQZSBGiu7/7FmJsf1A+D8lxFmi0pgh4tFsczNFzwB5UYsWF+1Ih6Zy5HwbsbihAT9VUxvjBmU4qUXAabo4onK91mNKJcsDsuajtXc3wlVMH0HN8wJfH/0sjokaR+bG7Q0UYCf03ab2xbJlAYFksGS9vK/t1DUd79r7ZojoWn1KCx239OjTx7wFzmMSeMgFM3oGtGd6db+ZELAKTkqN4S+CEfrY9AcBwRixniO+ccU4cWAyN
 CW/X66bR
 K3nKUHRPXvPTmIBPegKo90Sfjfb7TGEAcP9xiM+TQ0f0d1CK6f/IOEU2JbNEYYfDhkL/fGLUu8/+yBnr23VymxdH7KsSwI3BXHHIDumKa7fuKdFfI+hqYnAnZ8FdRxHq7THP/jlsw/nXyYWeQdY908zcA0FFCPAL5lLW4knAmgyFDztFDBCZaGRDCCE2gRGecMbOd9hzforHV+6doAMzY7LDjQp3lZRLAmOlYjy/1ei98yWBEKMOFCzyqxi+jWMCWi9AJ2dpy26JI96/uzyvp2/MeIMnebd+K9/uK13UvQ0Muu8sZwrUkW3OcFtE8wHRddvcOLFKAF23cEZKfunp7glu9RwqZe7a6ZtUKO/aPBucIy1wmy6/4AMM9MDylhQjYSoLiA2jWvEaoO9dpNcas7vvIbrpOjdCjKU0TAo/iiSfLrRwHeT2lkDFYdwewBw8w36Fd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that post_alloc_hook() handles cache-friendly user page
zeroing via folio_zero_user(), convert vma_alloc_zeroed_movable_folio()
to pass __GFP_ZERO instead of zeroing at the callsite.

Note: before this series, replacing clear_user_highpage() with
__GFP_ZERO was unsafe on cache-aliasing architectures because
__GFP_ZERO uses clear_page() without a dcache flush. With this
series, it is safe if the caller passes a valid user address
(not USER_ADDR_NONE) to vma_alloc_folio() etc., which delivers
it to post_alloc_hook() for the dcache flush via
folio_zero_user(). It is only unsafe if USER_ADDR_NONE is passed.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 include/linux/highmem.h | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index d7aac9de1c8a..8b0afaabbc6e 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -320,13 +320,8 @@ static inline
 struct folio *vma_alloc_zeroed_movable_folio(struct vm_area_struct *vma,
 				   unsigned long vaddr)
 {
-	struct folio *folio;
-
-	folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vma, vaddr);
-	if (folio && user_alloc_needs_zeroing())
-		clear_user_highpage(&folio->page, vaddr);
-
-	return folio;
+	return vma_alloc_folio(GFP_HIGHUSER_MOVABLE | __GFP_ZERO,
+			      0, vma, vaddr);
 }
 #endif
 
-- 
MST


