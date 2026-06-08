Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 020F9CD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 08:39:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 678086B00C2; Mon,  8 Jun 2026 04:39:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6287B6B00C4; Mon,  8 Jun 2026 04:39:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F0246B00C5; Mon,  8 Jun 2026 04:39:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3CBDE6B00C2
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 04:39:17 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0F910120A00
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:39:17 +0000 (UTC)
X-FDA: 84856095954.28.8075864
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id A94F820003
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:39:14 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Oc+QV+qs;
	spf=pass (imf13.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780907954;
	b=ihiNkDEpJ/Wxr6Uc+BQHEfl+Z3KRBYzJaFbj7LmLAOuaGIIVAbOM5iODijyiQhgvfYFZ83
	DqmaPbudcVsWhjnn3BVQHtPzxogZ0q7KZ30dhEhs9n/HpoTWaUxYZjZMl47x0ac4Z9y8Ui
	j1/TpU1m0Ww0TJXBKJTkWTe9bCDc3V4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Oc+QV+qs;
	spf=pass (imf13.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780907954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3+rjGl0pefUb9vVc/tCmuC8Z28GLOAKmmZQW2TUwDlo=;
	b=V/PNOpRlXcxYmagDlLxxgqr6beGiMAvC3pgzNPWqibBS4Dz0auRsjlnYlT78PfdmA0MDI0
	AYt7XWAwUHacynZYet5ijQg2u9PvlfUNc/DAq3a/N1EE8DRLdMRvkpUyEjZf2SZLPeSDK8
	npOPDU/19IUdb/nuPbbHxZBFSWEv2Tw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780907954;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3+rjGl0pefUb9vVc/tCmuC8Z28GLOAKmmZQW2TUwDlo=;
	b=Oc+QV+qs9O3xfqQQflJcbNRabWfHjVlloaRFnzN3mCCW+M31WbwmvhXSWjtIknERJDhox4
	N9tcvjXj0Uxs9VwL+poSFf45qk4+TPpwfqRz5Bigcu0sunhE49j5ETt9qlO3FY9oAAdM2t
	UJdQK0lJXAGBYK5UAWRjwhVEcWa0pvo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-675-u5Vg7abMP7yr1Itdnzp03A-1; Mon, 08 Jun 2026 04:39:12 -0400
X-MC-Unique: u5Vg7abMP7yr1Itdnzp03A-1
X-Mimecast-MFC-AGG-ID: u5Vg7abMP7yr1Itdnzp03A_1780907951
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-460153ce644so2916748f8f.0
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 01:39:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780907951; x=1781512751;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3+rjGl0pefUb9vVc/tCmuC8Z28GLOAKmmZQW2TUwDlo=;
        b=tGdoroW4pfltLDx0JXCpUGkdomzqumHTBY5pgo5jXWF21FsM9w5b/tw+y33HW6Rlty
         j7KVT4+jT8RLshkDZA8NwQDlrABVp5iS4RfFDOv376UIhzFMCGRLTBOsq7BG/tjaJ4ed
         yOFUBF9fjVmfzFZPXMeTwY115nRyCfObZWePWGKp/svawGiu6YcTup74iwg+ANbev2HW
         WlF8Y+QZ74MUCHIjfhKqbP8n9XbgKTOp8fueplKuAxnB+cpdPEoOODxSU4e0wn3+hHts
         dT31WM3otivDn003JWDc8Ke3FNEGJVR1Jbd9zDcGV02StAUVla5UCfBb2oyuEJ9pDRnP
         TBaQ==
X-Forwarded-Encrypted: i=1; AFNElJ9Hi6Up3HXz0M0pDfJSJBwaOkRv6izHJzMCO65s82FT1Y404XnK64IdYHqeS1qVXOzShNz0azMz3Q==@kvack.org
X-Gm-Message-State: AOJu0YzdDo5G9q7pBVpY+s1AVLcsyZpQAstbT4Qc2cH2oxE0ZXdHZ3Mv
	qz5whCjbJbYtGDPvJjDchFNGDxmn8C0x47bTcUwlqCGdyh7WNEtacAAT5Hq8dKBW4WPJf2xpOR6
	4Z+Um7IkJxMnUVkUP8p2n/dEc29v3PuPU+XmEy3R5qxn7r+whOdW8
X-Gm-Gg: Acq92OE9T7HCaCuZQbsb2t9YeCKnaf41DPlkBG5zzK6ZJbXx8T10Jlx2mOG79DB8GGo
	fnzbi/xWTq2Cwq5i4fP196YwcryV0+VQwQcCT03IunMpfM9B5DkbTN8YmcAiETfhP7+sZIQyA6h
	e9Q9OdGrnK8PVAJ/vElRpq6Huv4xk6QGRoly6SZPk1B9d9x2e5JeoQ6SPHhIFkc9X1Hh4SpR9e4
	03VsljkgkjG9YN9DcQ8fHAmUOPUJZUTBfRyEjzplY5SdJDPkOovU9WKX7maP2YR5fqAtcCPcCzO
	RMEYQmK19pdLIse8UvR41HARfVd9+K8VLBF84ioSoNtRGenzfMEd8UiwO8B7IyMmS9J0cX9/u4j
	I1p/+d/+flzZsZMG6XOlrrX8=
X-Received: by 2002:a5d:4a85:0:b0:45f:f142:d55a with SMTP id ffacd0b85a97d-460302e5e92mr18158170f8f.14.1780907950682;
        Mon, 08 Jun 2026 01:39:10 -0700 (PDT)
X-Received: by 2002:a5d:4a85:0:b0:45f:f142:d55a with SMTP id ffacd0b85a97d-460302e5e92mr18158101f8f.14.1780907950019;
        Mon, 08 Jun 2026 01:39:10 -0700 (PDT)
Received: from redhat.com ([31.152.37.159])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f2f67c6sm48744304f8f.16.2026.06.08.01.39.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 01:39:09 -0700 (PDT)
Date: Mon, 8 Jun 2026 04:39:02 -0400
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
Subject: [PATCH v10 25/37] mm: use __GFP_ZERO in alloc_anon_folio
Message-ID: <13ed2aa6607d510bd8dc6d602e96626511ee4fee.1780906288.git.mst@redhat.com>
References: <cover.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780906288.git.mst@redhat.com>
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jMijIsY4dmeXPkrK0N7yU6D__9ww4DM5nSf_fXrtXv8_1780907951
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A94F820003
X-Rspam-User: 
X-Stat-Signature: 1inguyikuaf8bqrhgsuupezq1nwu4rom
X-HE-Tag: 1780907954-883997
X-HE-Meta: U2FsdGVkX1+lhWsRnV5ABfcbvnoAW9NcdmuXAvTZzFSOHHjfPqx7xlwfQ+BD7/xdKKhkdAbOUxS2We0cTPQ8CUusOcO9pLRjI4dUTyICtbnhPNja8wuIvCj3OzVKLWMVgcgQROsqJFQHRBuwnxP4W3Eku7fA58V8TPX1X280ieFBSF0n1ZWi9PGI+7vz/zGAnRYo1UoFVnB2iHdZTOdKl8PEHIWdHR8Yky3Bc6irSTZiUbdfM/xNBvKHteC9hyfTOSfQFj/V+tKb4Q0+FhTveG2kJ6Gm9wJxMLKSQxIPHsCnMi/jvOXwnlGQV+H9PnoICttwS7rJk/ixOb21AJQiY4O+zHMwjNt9JVLKLPSvLWyYlccB1yijdbz79elevpNmAHFS9tXoywxnA+zq3kpQ+iaDdzCnUXbUfiA/XK2J32+Zbouf7Pe1NjqeulisCRKv8nMu17AmrZWltoQTSEIPf70QtbLtMefZSqa8pcWhKaw5Js00cUiD8LHKm6LVCQj7Jeec1dl8kjhd0EwuCffyoepL90hr5AEmHwtaU5VmZhL8Krq2U+m2yYZ18mS9p3UJBjCzgkzvZVrBEZjtb+QX+6ATon97HeyaZaoAeMNviHsPpXrVA4m/OvE/9rNFgREbV118sprxcEBPo4/tldtB6WxqZUhFuD91mQSYMKN1eiPFHxryRWXCdSU4jjNiHC63E3cwrB7kO6JF+ZVZgGICIu3BNMpVnrhNZcIMH8gEouI731devjHgMY3y/6fZfJS1SCQV+IS2mYN/nAwpzF/3Jrj8KBxxN+5azar+r7FBG7u2ahIF7t7YCE/WwSF0TssxTx5LNP9lTzAdVaQjuTRHYGgKMgNOqLKOYE07XTrrrv20h3yfnVMYmhkGkbjjI9jaL6uoehtSDD4cnJAEzJMSiFu6xrRj0ZVj+GkflVm4X0+ln8b1GmgXXKv6jrpq4xU8ddT2Y1pFblpGlUBFGRC
 ERscyfNv
 2h9qXBD39OLhVXJTqOJQQSiwEJEjracNFOg2N9wecfOVtngVVleS0Pz3cyqh4564VzY8u019jT/gqnJamktVdsLRvhxyXbDM+rT7kF6h4jq1FHmcBuWhvQHg/jp7+7yZ7XzIGHsYlaoFnhBIxO/4VY3JGPC0/zCDpPnpWa5tI25W8h+3fc+33E93tf5062Me7w9kC1fi3jFvn3DH0EqI1HN7rp4dq6zgCE8YdDdZt2ChwO0UJlVmae/Btpeo5j6cdFKUqoaSRWpy7eTraMiP8Ow9ZLzbCysrF1XHT0F6AO+ZPdRdcxO7SJD8zCrPiS16AkOMPHQph+/1qJmUGPK6ygV0gIyvKVZb7pOtLPbOwnLyzkAKtdmw3acYzQc3Pzf7KF09GPObfLlr+6Kd3UeHqmDrpSxac8fpS7OPfJVNYFZ9wmFkIPiwSd4BhHnNBDc7X+h/UUW2oJKFOLhbbGVfaP2tCPzn67QAxXObS0w8/OB0gV54J32SBgXB6p0A5lg6xk7BJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert alloc_anon_folio() to pass __GFP_ZERO instead of zeroing
at the callsite. post_alloc_hook uses the fault address passed
through vma_alloc_folio for cache-friendly zeroing.

Note: before this series, replacing clear_user_highpage() with
__GFP_ZERO was unsafe on cache-aliasing architectures because
__GFP_ZERO uses clear_page() without a dcache flush. With this
series, it is safe if the caller passes a valid user address
(not USER_ADDR_NONE) to vma_alloc_folio() etc., which delivers
it to post_alloc_hook() for the dcache flush via
folio_zero_user(). It is only unsafe if USER_ADDR_NONE is passed.

Note: with __GFP_ZERO, the folio is zeroed before
mem_cgroup_charge().  If the charge fails, the zeroing work is
wasted.  Previously zeroing was done after a successful charge.
This is inherent to moving zeroing into the allocator.
Charge failures are rare (only at cgroup limits).

Use folio_put_zeroed() on charge failure so the zeroed hint
propagates to the buddy allocator, avoiding redundant re-zeroing
on the next allocation attempt.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Assisted-by: Claude:claude-opus-4-6
---
 mm/memory.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 6c14b90f558e..6d6a3e1a02c1 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5265,25 +5265,16 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
 		goto fallback;
 
 	/* Try allocating the highest of the remaining orders. */
-	gfp = vma_thp_gfp_mask(vma);
+	gfp = vma_thp_gfp_mask(vma) | __GFP_ZERO;
 	while (orders) {
 		folio = vma_alloc_folio(gfp, order, vma, vmf->address);
 		if (folio) {
 			if (mem_cgroup_charge(folio, vma->vm_mm, gfp)) {
 				count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
-				folio_put(folio);
+				folio_put_zeroed(folio);
 				goto next;
 			}
 			folio_throttle_swaprate(folio, gfp);
-			/*
-			 * When a folio is not zeroed during allocation
-			 * (__GFP_ZERO not used) or user folios require special
-			 * handling, folio_zero_user() is used to make sure
-			 * that the page corresponding to the faulting address
-			 * will be hot in the cache after zeroing.
-			 */
-			if (user_alloc_needs_zeroing())
-				folio_zero_user(folio, vmf->address);
 			return folio;
 		}
 next:
-- 
MST


