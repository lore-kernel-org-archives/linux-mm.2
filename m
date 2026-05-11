Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50D5ECD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 09:03:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B246B6B00E5; Mon, 11 May 2026 05:03:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFC956B00E7; Mon, 11 May 2026 05:03:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A122A6B00E8; Mon, 11 May 2026 05:03:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8AF3C6B00E5
	for <linux-mm@kvack.org>; Mon, 11 May 2026 05:03:01 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5ED00A0592
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:03:01 +0000 (UTC)
X-FDA: 84754549362.13.7BE9FB1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 21FF7A0004
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:02:58 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="UiC3O/lQ";
	spf=pass (imf25.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778490179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2eYp/q7ILAhscET8EXyPBKCW0KNcPEmiVquSYEOS+Yg=;
	b=5hLGc3Duv/ywd3M+UCWz2NZftecCsy7x8ZbrGynTJS20qez0dtCtwN8QW7lQWQ/Z9wvqql
	v0ong90ANysLfICY4GIQvYcbiJGFAx9COR6PK5dkdofb+GG9dYOPtJ2L24pSXpYCJQK0Tx
	FoWIbWCipE/iu6jnDHtDKqw8NwBIO4s=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="UiC3O/lQ";
	spf=pass (imf25.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778490179; a=rsa-sha256;
	cv=none;
	b=n+spN/pKFjuFhIC/pf+dAoitgJ7lEoHIsPvOt1zTwgebvIRghWRbeX2XbAsapdsxFHsUpo
	Lwzkj5Lxva4t3zKXYhOBTPkKdXSfI0cBK0BSyWt1ixfdhVgRgRUOasghDn8CMFXz4MXJVl
	pT6ITrrypf2+Q+86Fl3tbymCwVf5qQY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778490178;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2eYp/q7ILAhscET8EXyPBKCW0KNcPEmiVquSYEOS+Yg=;
	b=UiC3O/lQpt/FjYXj9E1RYZkVgPn95S0lcD9YR877Z46o2BLc8kXmQ55xtT1CCEmuFL4ccB
	/FZIJVXfuGUb4EYCvxREb5q5t3c45ajL/fm+5yE4AxCzYXAaZXqKqoD7kOIE4g7YZ5Gy9x
	7v0ynetrVmq0hb+1tbv8wYFPJsQ+Dhk=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-70-rik1DRCrOXSM_xMoa9TjVw-1; Mon, 11 May 2026 05:02:54 -0400
X-MC-Unique: rik1DRCrOXSM_xMoa9TjVw-1
X-Mimecast-MFC-AGG-ID: rik1DRCrOXSM_xMoa9TjVw_1778490173
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-bceb2b8bc2bso69422666b.1
        for <linux-mm@kvack.org>; Mon, 11 May 2026 02:02:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778490173; x=1779094973;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2eYp/q7ILAhscET8EXyPBKCW0KNcPEmiVquSYEOS+Yg=;
        b=s9T56PLvcfii83c6Pvmgb3nU/eBl8Jo3ociTsDPn7oTtuGMpNJsEeQgL+1zgJmXqo5
         uyy2mXCFcur4/97WfIYBtnRP9Xe1qw96qq+xginqWPoaJw+NNxjSoV8hzxDZlW+2r2Zq
         1TE2EQ6/CpKPPsTD4TtQpXRRxLDMdWqb2gCaDuOH7n/h3RelAnz8qd6BaqhsgEBzbQMM
         9jOZ22F2s0P2nue57+3z0jdLCngevIX89Fg9QfZQPPEkc4SwUMlskvJts5/kJ0V3D6m7
         pD9CAQtY7aYsrj6PpzDCwm6m6selmXLNQ8ZwXONVZDpTi2vkUf7NHBQTaMPQpPLZUhv8
         oghg==
X-Forwarded-Encrypted: i=1; AFNElJ+8ZVZyZMKhacGPYoWeoTb4K/AImehSPB4febbP6Myk2fZANtSKQkCGV5uQVrnKL5fxl4WJoaSkfA==@kvack.org
X-Gm-Message-State: AOJu0YxLTClL6EmJlNm30qxnI8BYRx3+28aFcGsQd02lxeNo2dQHDW9W
	wAhGcb6798+VRk9WZEZecl6sMonBe02vUPwFx2JbPaPBSAe8g+bleIzitExVe8t4XnPMllD3hI5
	mvvARZsJnj3fLC9leRIcbd9yhWY4BIoGmUmRlGezZhkZ+s1eWdkuU
X-Gm-Gg: Acq92OGSDbRqjkINPaR/vhuKMYSxLx+tZlBBFLa9QG+uMYdsZUO890wUJvqSNuqg7Hb
	zx33iGmjKM5b6GAFchoyzVMOMYHfaOrv1hpbVhsMQ6PRm9+MADMe1Te3BLxbgtQcnJ4xsr8ne3q
	cNUD/SNr+42SU6zRSy2kKfIHtjY/mOpQw58yuxmP9n6dUN9B9n5iwpKsJY1sWpWMClrlX8xovc6
	WfJS9XCJJUM3Fmha2O6m0ZdVpgM6hU9rd32K/LaS7Iqmvu1kS9PbfTZ5S64m0Xvru6ctd2XLIU4
	qzpOLUtTjz47j2zzHwFKf0EqrvK+9lTABmtzKVUtxMuqSGOFa2THf72v+Uh8WEspd0SDri+Le+G
	A6QQ/qc4Z6l+48AOCTwoyjkNBx9BxOTstRqBK/yfEQV11O3tpsrA=
X-Received: by 2002:a17:907:98c:b0:bad:255d:b5bc with SMTP id a640c23a62f3a-bc56df1b69emr1313613366b.39.1778490172538;
        Mon, 11 May 2026 02:02:52 -0700 (PDT)
X-Received: by 2002:a17:907:98c:b0:bad:255d:b5bc with SMTP id a640c23a62f3a-bc56df1b69emr1313602366b.39.1778490171589;
        Mon, 11 May 2026 02:02:51 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45491ca2fd6sm25007169f8f.30.2026.05.11.02.02.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 02:02:51 -0700 (PDT)
Date: Mon, 11 May 2026 05:02:45 -0400
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
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
	Andrea Arcangeli <aarcange@redhat.com>,
	"Liam R. Howlett" <liam@infradead.org>
Subject: [PATCH resend v6 11/30] mm: use __GFP_ZERO in alloc_anon_folio
Message-ID: <99c79224ca94e63dfcbe8523cedb2a8d658bdce1.1778489843.git.mst@redhat.com>
References: <cover.1778489843.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778489843.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: B0waWvp-lCFlZMAmFatOc7ndvnOt9jMrC6jxJablMQ8_1778490173
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 21FF7A0004
X-Rspam-User: 
X-Stat-Signature: jin6pmpgeik3hcr9tyheh9ibdnae6bcz
X-HE-Tag: 1778490178-425820
X-HE-Meta: U2FsdGVkX1/deA2OuMGxFuCg9Tk6LJt8m6bcSQ2ciSyTakka+AB9oy4trwle1VI6oMNE+2m8mlwJnPsqDrlejKSWWor8TmCmXewLn/89qqq3AouDNoB2PJvvF3K4ksrawppxklnO1gi2joM7fvuqSmTvA2lDhKZmfUhn8mFhmgsFqUb/7oxFV2CovqG1Z3UrJfIIOvy8lcV30TwZTCypKsVK+R9pABidjY4K7nTfsTiFIHlDUBG+NlbAORrs3PGN/SO+l8kOlxRMq4bfqzlZDufXyevrQZdMgqnIU/rkkunKzMpfaLUEdUoYQLz1GpTYdjJjsuFp00M8OGMG0BOTdOyJpNgqf9W+usya2eVHwNXbjcIq+E6wrxQcC+/kA1DQOVzg6H8DmZ3n1OUg3kX3FA0DFdsQrLRUjZaeRLUCIZob/V2C21sBUp/jV0eFsSe1F9oAeBxomz4UgcKqm0+eyJTkC8Vj3j8UrhK59oNYc4NPFdFxo949tXdDV8oMTIo8MZFs/OOFUl8VNows4TPNgQynaKDFZpRcXEtuxdcx9wz5nss+koAHttQU6jtdeGXNiUgzAKsEtiszj6i9s/X4dGUZWCrmMoN5qSqAtSRMMpJPNudEHLtpdSMSwEkhxFL7lIN5/dlttYyzvnUNmA2gxPGofPCQcWLoiE9ZcHuqOh9w16e36jHbwEC+UcGsQ64UW8RhdacAjkxhlnrX/VrZ8QkJdEvIBjNsaGlTjzah6GRgUd1HQcKNyPVQjvqNxkKUb5q8+2RjTqU2iVr6cgJF1nSkp01dyiOKOGUyOWkFsEhepz0X8538HQKWM4qAwn0nB399h+PO/wXjh28kuZcH5tiPhi3kOwHEIvbu8Gv0jbamptT3oljUVBGKPzACEw5NgFFtH+HxV5GaDDtN9h8H7iNX+WW34pBxEZFOg/KchLlkZDrAraidmPL+ufpGKIw/Y7+FVJKcAtjymv6AizR
 Euc/CR9u
 1aAr+ZIECQMIV3U+76KuQFUIC3bnXit9NuGRp9dgPClcHPH6H5x0AxxGiF+gto+auaSay1k1pkQAwS+N9qoqj7SnrDsRgZ++rGX0+qy+UOonQ73pDFm6RTHDI6FwKWms+prB6GwKT/8Z+4/EGwWb/fe2/f/iDiC02AddFx9+hLU2vWxizRB1knf/IgdDExz0+6ynWNr/25buhjA8+WVqWUQqyAZd9slz6LV60kQFm2EggwTG8h7fOtkT4P0VoOzz8r+s30m158fMNrBxwo5XNITV6UHX1ZM5jpnS+/l0teQH82rA9j3KymSDEAjUTU9Dot+pItGgRFthi5UiNw0gUQA1ocrurbBlWLDZaL81CtVSlnl60Es14rPphcn6GTDLym/bcjI+QWAq9UpXkzpZ6N2NI+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert alloc_anon_folio() to pass __GFP_ZERO instead of zeroing
at the callsite. post_alloc_hook uses the fault address passed
through vma_alloc_folio for cache-friendly zeroing.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 mm/memory.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 74523bc00d8a..f3f1bc66366d 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5249,7 +5249,7 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
 		goto fallback;
 
 	/* Try allocating the highest of the remaining orders. */
-	gfp = vma_thp_gfp_mask(vma);
+	gfp = vma_thp_gfp_mask(vma) | __GFP_ZERO;
 	while (orders) {
 		folio = vma_alloc_folio(gfp, order, vma, vmf->address);
 		if (folio) {
@@ -5259,15 +5259,6 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
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


