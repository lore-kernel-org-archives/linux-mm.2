Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4B50CD8C8E
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 08:34:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2792E6B008C; Mon,  8 Jun 2026 04:34:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 251216B0092; Mon,  8 Jun 2026 04:34:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 166CE6B0093; Mon,  8 Jun 2026 04:34:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0A49B6B008C
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 04:34:31 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B53511A09E6
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:34:30 +0000 (UTC)
X-FDA: 84856083900.27.F5AF5CC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 821AB140007
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:34:28 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XSfxHWpw;
	spf=pass (imf26.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780907668;
	b=TogsaWiCWtpLCyAb4Ah/J8QJivJJMyVVMmlUMVRGioanAnR6P8XgBkwt1UJaHuRRnAoBMF
	DpAUlh4CuCTN19mcBDz0GAPgucPRNv2UzOQi0A7Va7yW6HDQEFp6C7qVU5nY8yW5eNVK60
	CgNSo0yOdHDKRwxkhbaK2Wlr60dYLcc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XSfxHWpw;
	spf=pass (imf26.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780907668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=315e7bSessxyz662R8s4IU7FTBDlj+mVbEZvVNtQrTU=;
	b=DS/KucDOjvPjYx1+4CQ8jdDrNW7FKOmk8qmpFvVhJyzjsJWZRge8TjihA6ZkMhfkE9jpNY
	eFnp31/AOfcryqTISnKjDDn8WHJ0PJqbH0yrrERXq4wodA41S5WIKkatWNhqgjG9Q9r6qr
	EGBme0/NYysJW+k+mC5uPUEx35oIYGc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780907667;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=315e7bSessxyz662R8s4IU7FTBDlj+mVbEZvVNtQrTU=;
	b=XSfxHWpw7ZSbtQcevoNYNScaVEONZGoat+gVoZ+afcBPnnBWFGhtZsrgnnldOxecOHg+Pr
	vZ2vsYxlmHvDlKjADHHNDB5VYO8cKaF2uXuUkeabTpnE4FaEiM71LqKHRm3kYuR8TkTZiP
	fDZHQCs+m/WxqzFWyRNPuHvlHql4oJU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-400-IF85H_YOM9idu7MSFC4X0w-1; Mon, 08 Jun 2026 04:34:26 -0400
X-MC-Unique: IF85H_YOM9idu7MSFC4X0w-1
X-Mimecast-MFC-AGG-ID: IF85H_YOM9idu7MSFC4X0w_1780907666
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-490b8adf8b8so38328035e9.0
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 01:34:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780907665; x=1781512465;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=315e7bSessxyz662R8s4IU7FTBDlj+mVbEZvVNtQrTU=;
        b=HPsDC89gRVGPvv4z7Vf0ebHDMnwtmu5CaB1faO0v/KME1lf+AsAXv8jTAmggMLJL2H
         VOQts8933bzeaYbmmj/9q/6DQ17d6r/Re1kCGgq6pg8+FyRMKVkD9DMJxjBv3JtiRdSy
         4MdNyVs55RozcRkOn5YjD4pL0EUsHcsSvEdJbXMkqMsSp4qOSbBFDb6YdXhIxLWjQagg
         1tQPqj0Aq07yn+9joDwUI9RdpyyOBOilSUAOcFQSGuYl7QbTgUtGWkRjNEJPDYYNaETJ
         4Vfns+S1BzkNaeedJoRV25AOOdzfpTy12TWPeiiPG61x7URdkTdJq9qZLO93O+0xO8G6
         p8jg==
X-Forwarded-Encrypted: i=1; AFNElJ+o7csAO6Vew+qbHJIAP9MV1Nqu7pVGpoTtcITsfj2GzQW4L0Wd1ROxgNU0J78UjSLJvDZwikKBjQ==@kvack.org
X-Gm-Message-State: AOJu0YyfZ9eCanesG6eMotS+ZHzJp2MnDP/6c8K+7mX6wzlX9ryYQufw
	hHWRePWTxUqq/rRAEF0PkCz8Nt0RsROYEX9W7TifNbkt9eEZuGKrD9XbaQ2YDq23dSQytTVofJ5
	+84CCT+QcE60TQMYbbZTf4s8i5f3B+hb1W2YGoaLtA5CH7qpgBRYO
X-Gm-Gg: Acq92OFDtjzJuQCUpDzK44wfmJEDKauQ7aSQhaGXHj2kj46cCOD9vQI7e2ljx/P+0tN
	NBidEczmpqz+14dxSU92E95r1Y6JxCuH0TLv1MsPUbEuV9sTtrwbrRc9qiBqdvDaIV+AiGgrANt
	b4Vba7h4YzvvTe9GnhRsKRl0hoM5alxNSXshbT99ssD0GkwyYz2E/1ZRBwA8MOe7BBO+KTYAHTo
	WdyfLPAUCBfATZNN8+GHtuYQgT9lRuTZJ4ZasnhRxGGBzRmX8LstRshHr/4Kiasml/ROug4/43e
	1UnwQUB4wPWjMU3kZWiaj/+UQ5sQHaJbQGqTYNayd6zb6Oln7QLpDIx9N1+CwOobhGqHKVGRGoC
	eozifunsAUJCwoM5UOBNkH3k=
X-Received: by 2002:a05:600c:4708:b0:490:bd66:e522 with SMTP id 5b1f17b1804b1-490c26038d2mr235216015e9.29.1780907665095;
        Mon, 08 Jun 2026 01:34:25 -0700 (PDT)
X-Received: by 2002:a05:600c:4708:b0:490:bd66:e522 with SMTP id 5b1f17b1804b1-490c26038d2mr235213495e9.29.1780907663108;
        Mon, 08 Jun 2026 01:34:23 -0700 (PDT)
Received: from redhat.com ([31.152.37.159])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3d66c8sm356368295e9.10.2026.06.08.01.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 01:34:22 -0700 (PDT)
Date: Mon, 8 Jun 2026 04:34:06 -0400
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
Subject: [PATCH v10 01/37] mm: mempolicy: fix interleave index calculation
Message-ID: <f5b1dcc97baae7183e96743873b943315d93cdb6.1780906288.git.mst@redhat.com>
References: <cover.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780906288.git.mst@redhat.com>
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6P8krT59bwkUPJFFZktkn73keR8jIIduG4hRyug0hQQ_1780907666
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 821AB140007
X-Rspam-User: 
X-Stat-Signature: dphzhu4im6ekep843ifoe17ha1jengsz
X-HE-Tag: 1780907668-17475
X-HE-Meta: U2FsdGVkX1+VBa665r8Cgk3vJgCFZutL8RhCW6itOTFBW2ld0FN+gEcK6YnGGYUL0MXozlDnPt3EpM5VbAaY+HMvcj4a+dVP6r606El5iuaEUEE4F5uiQMi6cUuQrM1nwCJNtE3AJaqzvG9hNnCJ42T6o60qk+oFuJ0mJwUa1536frftpnx8h269UVmbxMw4aSHPAViaBa6YGPTvvhYGe7R9hHcOmr5YNgg/LVV+/GdICpXfqfJ+x1t4MahCDcNkKBRC0O1MN7WGmKFHgCmovIVz7q5QjYaFd0ZgHS9SVZsnRe/rhiw4wS71fTTlqA5X9OzlTcWdQHE9dc/VW4rTeXZCOl6SjNBMxh3T1I0AC9eRTJpcg7UGNzUJj6OIbUcxa+ndozYnJvN73V1suaLAPKk54YEvWawGX9gKFLJvMuxbO56D/WUcWisec++2qsraKeGlmXvKT87Rc6CW3VWFAFrVc6T4BPKDmjoskxMhcNKmgNdNA4Pssj0zv9Vb6OnuVU7W0NeroObLH9tJ6l2JTqDWWT75ucFQmzjSAUIm3TFUaWJJBv61z4osreIrTqIvWnEEJUlg+HtCQpGuCxDnqSrxAH3/boCVw26t/vHqwMARYWb2eUG61Dr1ij3nS2odGstUrX5hQIUz3Ze4E7koKkFeqPe+GsETJNh4/uohbJHQn6E+62hsqsTVnkJtwyADw8HontQ810ufo+S9PxNnjxkkXkzC7fHjAVPVdBI0nN/TKxEpc2n1c1m3bOP433til6wpTWHZl6UOCjphx5EpHLtAsH4Ncs/WTwFd8p30LG19emPC7Urr3XyTh5haHYJCQiwN7wToaOnyCKeLWQEYzhTVbmJMP9QHWxXJ5xgu4C8pfdcvTSEDPcer8XZaSpBxZsuZJziB1sRQk9VMh/Mt9FHz728at8owd4IUbEvowHDxtjrWzN1Zq1SRdboexUivpib70a8yoU75DBF7d00
 Hgv1EdRC
 Uifxq0DJZ5eY3Rr3D85zjrq5Owsp63IvdPVMDYSI583aDg8B5B22wfnbxFnxeYSn0ZTb8wyOFNjKd7kASujoorYuYMrEPg+1oIW+xWkM7fqDU1gHIlHijtNjdDFB1eA/IZjQG4C48T8hGm1/pnnbY3sGyEonbZ17Xbrhjed3bOvP1phzicuLRmrAzi+JxCqoIH/9P1rFsilg4oWhPKaVgzzbNHsjY87tUDX3hyjA7nJUrvokQeqmAM0UYCbTAytBukcRdXWd8RCaEEyoFbJ0Vcc2QlMySG7s75ee2RGyYJGmn00JM1i1GMBk3unNhwgPrvy12SFeITtSZ9FcbwsljsJFHgjF3xVjcqSNq5px8/EmhmyOEZ8YddJIpniEp/OYaHFJuLmoOWXZNxmleKZyD97/3kdJR4KrABh7UtiVRiL4Bufqx6L26bskMxuUAaLOjv4AnTIXSMpgTuW0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The NUMA interleave index was computed as two separate terms:

    *ilx += vma->vm_pgoff >> order;
    *ilx += (addr - vma->vm_start) >> (PAGE_SHIFT + order);

This has two problems:

1. When vm_start is not aligned to the folio size, the
   subtraction before the shift lets low bits affect the
   result via borrows.

2. For file-backed VMAs, shifting vm_pgoff and the VMA
   offset independently loses carries between them, giving
   wrong chunk indices when vm_pgoff is not aligned to order.

Combine into a single expression that adds vm_pgoff and
the page-granularity VMA offset first, then shifts once:

    *ilx += (vma->vm_pgoff +
            (addr >> PAGE_SHIFT) -
            (vma->vm_start >> PAGE_SHIFT)) >> order;

For anonymous VMAs, vm_pgoff equals vm_start >> PAGE_SHIFT,
so the vm_pgoff and vm_start terms cancel and the result
reduces to addr >> (PAGE_SHIFT + order), same as before.

For file-backed VMAs, the sum vm_pgoff + (addr >> PAGE_SHIFT)
- (vm_start >> PAGE_SHIFT) gives the file page offset of addr.
Shifting by order gives the correct file chunk index.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Reviewed-by: Gregory Price <gourry@gourry.net>
---
 mm/mempolicy.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 4e4421b22b59..d139b074a599 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2048,8 +2048,9 @@ struct mempolicy *get_vma_policy(struct vm_area_struct *vma,
 		pol = get_task_policy(current);
 	if (pol->mode == MPOL_INTERLEAVE ||
 	    pol->mode == MPOL_WEIGHTED_INTERLEAVE) {
-		*ilx += vma->vm_pgoff >> order;
-		*ilx += (addr - vma->vm_start) >> (PAGE_SHIFT + order);
+		*ilx += (vma->vm_pgoff +
+			(addr >> PAGE_SHIFT) -
+			(vma->vm_start >> PAGE_SHIFT)) >> order;
 	}
 	return pol;
 }
-- 
MST


