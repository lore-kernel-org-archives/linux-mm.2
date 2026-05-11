Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAA08CD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 08:54:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FCE76B00AA; Mon, 11 May 2026 04:54:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D4F16B00AC; Mon, 11 May 2026 04:54:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EABB6B00AD; Mon, 11 May 2026 04:54:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 310E06B00AA
	for <linux-mm@kvack.org>; Mon, 11 May 2026 04:54:03 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EB368C22AF
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:54:02 +0000 (UTC)
X-FDA: 84754526724.27.A69DEC2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7C78440003
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:54:00 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=a5aEn2yg;
	spf=pass (imf11.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778489640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2eYp/q7ILAhscET8EXyPBKCW0KNcPEmiVquSYEOS+Yg=;
	b=q1SOTyOhOm/uGPFzLlyFgdNOvoiNBAZn/EGSwWK8AyOYtPDc8peUOfJ2d36Jb/+YUZShtb
	/UEjToL++GyIniWp/lw+I5RU+w5wjzSfjMG5XdpE09uBlggycFJ6byyGrKDIPewyXOJIWL
	WkwsISct/kV/0hdIfh+3zQEkNXSRK5U=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=a5aEn2yg;
	spf=pass (imf11.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778489640; a=rsa-sha256;
	cv=none;
	b=Q+uTWqef/5bgSq1aqQLtK7TKQKTqg3usK7LD4mKDifkSEilTheLEEP3KuJvsYt8t3DbRz4
	YDGcgcv0sOJ0H66U/QFFSnA3zLIWIb3FR3RFQQWqlb+2HD2XaejVo/346bXQp6iJe0EyoR
	7fqsAn/SK40vh0zMWJFdTnKAyaHIFMg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778489639;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2eYp/q7ILAhscET8EXyPBKCW0KNcPEmiVquSYEOS+Yg=;
	b=a5aEn2ygNK+UZdh2FnV8r+oYfhO4pKQxsV5y39z+tu0J2RQPREQxZyo9cu61wPz7HZ+2mg
	4Dk+eTSvE10MpCXHLRn4zvtA5YAD+HsEWZM20O/iZtfsBapu8MwUvOwpO/YwMt85Qq7PqL
	z9nmz/QzxZCyl35E8ixZ+UzQfeUS7xc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-67--ujce5gSPjGLNFpAaQC9OQ-1; Mon, 11 May 2026 04:53:59 -0400
X-MC-Unique: -ujce5gSPjGLNFpAaQC9OQ-1
X-Mimecast-MFC-AGG-ID: -ujce5gSPjGLNFpAaQC9OQ_1778489638
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-4470d6d2a4fso4364981f8f.1
        for <linux-mm@kvack.org>; Mon, 11 May 2026 01:53:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778489638; x=1779094438;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2eYp/q7ILAhscET8EXyPBKCW0KNcPEmiVquSYEOS+Yg=;
        b=jVjAlUhRP9P9bImgYnsUNjPHAWrbCteTv4yTDUHM8ZjZc/dhrqko59crjFjx/XGG0T
         vH1wut/7E/DgigzwdTD0yjTQskLZare8aeTyGrBgKqW7C5AWYuhJGpCwxEnOL5qEBN+v
         cUh8ZCeheSQUH57E3HWGHAJamYWteOyMe7G1hZheBbDH6XA5mycrMFrmEJyyEMQjceT+
         U9bQLv7Tm2DQC7dh7osKShzgNglnx3+AQYyY3vFbihINFso5isg6Nkw/dqpUXxyoU+od
         4ZJAbrRZvcOo4uCzJlwrFP7U1WOiD7aSFZqEMXRFywAGge55Em3dLSWp57aksDlYqtNO
         IByA==
X-Forwarded-Encrypted: i=1; AFNElJ+S0Z++ekv/l3TOX3lEMabfHtdmVgTddZkP84IRX/jpaxcJCCMGrZN+6+dXxpESXIAjwfe6j8PyLw==@kvack.org
X-Gm-Message-State: AOJu0YwWQur0UpUHV5ABTOCIbu9/8T72JYkUjtwBKUzKvP0kpZWUnkQK
	JsfEUiDvbA2pOiSovCjgISQreAOV0mNOOG4khvuc7fRft6d5QnYQuMiVM5pVbBdfXGRA2kgZw/L
	mG++dAYdCGN50wiH2G89f9BboszPzmv+Q8qgzeo23qqkA7Xv14NEw
X-Gm-Gg: Acq92OGSuOufUgZ184Jasv72kcJDyhXyqh8kH/kEWKJhfYLFyCPxxQLAlFinCYPmnBJ
	jcWXBg7SFelP6ANCOHMhuaIYm0NiOwNDTLaJeGfyxaXyiDtP9LSiiz/oTdrkg7kMQB6vWwgvzjh
	IT8oUaLelvOk1LZrPvn1/Qg4IiVQRzrezjEEXkelz1N0eZ9OBUqAczyJNbu1nelvjNEA6YoPnys
	ScgQyS/ldXOMHSe+tFwDcxzqR9IfnTNm3tTV1pRhy7KyEltnjuP3hAx2sqwgcraP9/xRlqS0us3
	fEK3veYc1EygiNmKUsQKLH7ntLPfkpAdVBxXFB7mn+JC2X98NDbei2itAWBln2TSWoYbTxW/udQ
	qwRsSr7rt1IUyzYhgCW6JWegbeQl3Eu1hanfsRjWevh1lgHrfcks=
X-Received: by 2002:a05:6000:2013:b0:43c:f3ef:ee36 with SMTP id ffacd0b85a97d-4515d4d0fbcmr38974651f8f.33.1778489637293;
        Mon, 11 May 2026 01:53:57 -0700 (PDT)
X-Received: by 2002:a05:6000:2013:b0:43c:f3ef:ee36 with SMTP id ffacd0b85a97d-4515d4d0fbcmr38974556f8f.33.1778489636576;
        Mon, 11 May 2026 01:53:56 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4548ec6b071sm23659472f8f.14.2026.05.11.01.53.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 01:53:56 -0700 (PDT)
Date: Mon, 11 May 2026 04:53:51 -0400
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
Subject: [PATCH v6 10/30] mm: use __GFP_ZERO in alloc_anon_folio
Message-ID: <8b322b8e82bcfac5873c6801a26dad18e8e1078d.1778487000.git.mst@redhat.com>
References: <cover.1778487000.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778487000.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: DI9vyM-xDBbA_2AYfww9Sf3FTmDrqk3dLLkzxV0-jC4_1778489638
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7C78440003
X-Rspam-User: 
X-Stat-Signature: 6iumkr3wj8yt6u434aewd33r6899bhgy
X-HE-Tag: 1778489640-973050
X-HE-Meta: U2FsdGVkX1/fde+rpu9t297y8golxJG5i/B00vKDdeOli3BIs/wrxPP7ZZaLI8A9U1NQ92IDGarKoah6rAdMqvqoznbMUC/0rkR2chtIhYgKHHjAjWeaXeOXW9D8CwcFc4upX4+PcYxpbvvCNF9oNcBGarMGFDgM6KKha+ovJ5n+ylE1PT1rqANff+GPhoK9guMBeRAIt9cdHD2zORLBznC19Y6hQb0C+3wF50KIlycYwpYVOJ9yP/z7lT+wpjCNpZoqMUd8sOdXcSpVDIAuJ3fPeLnGHKbua/73DtNsbJKMNCCOFuTG6Q6Snwjyt/XkkT/dgYr/1Zn6TOKFlJ2B99+4Pcrr5ftbfkrDsttKNj/riyb+brUsqMoOacltEww4eowhNUkhE1bApzAfAiOEuEvRc//IyE0aWeoxVWAaA56YDrShKcT1u379Ck5UPU56QTWWNKma0IDzqWZ/L9acqpxVhDmGZLtLtNqxJoitkSjRg7YYW0s60rjlcEkrAyQqN+ido43W62xtm8GLhNPsX6rnvQ+bgCgMOjupD7HBS2J9qZ3P16Pjga1vmUBrwqLSgwCE0TDK/h8CCf2Ye4L2T5OE7WYujN0Fj9OJopl5VffvqI0s1ONeNjAE6hocbTxOMgFZEH+HgnZp8GwVgAJ8IxRiZhxPCnLnHPZwG5ZV/1FQuFWzkD+WqzVQIT5S5mvMEHuaC4VUCHm9XImsLb3FdvYJJkmGVqRXbweYUbz2O9w9PfmA1tryZH8H4R2h1O52XwPup9iqORGEqWlfxz6Oy7LZ4xD0cR79GM9H4ENbGef27P/QebtSYRcafB8YD4BB1UecqTPXscZGUey0jcownPvuvfQldcPZpYeccr+XWGeeiM+q8zISGCw2WOLeI/44Z3+uiFVSsa+9QTgnVDXm9vx0RBbPafTQ2FB4WB5I8BQW5GUoFezpcwQJJbqLe/RXB7AeiK/sz5JYvyFPScA
 EbL1nCrp
 kY28xgxlIEHe27wj1PPbZtv6EZhk22nME1PecVuhd27Y+us2fPHdokg4gXabffEiUrfzXteVLhVfXEFNHNNRdk45ELdcIjS2mIzA/WLW5Bot6IY/jFjGa/sXtvFDiOokggnHL0AKcdQDmjpUuAHXBIU6W3l9CnVlfaEA7Ei9IHkyOm9UvyHaF8rrPK7KJUOAB8I+PtaA+fpKk7LWMYPeoMl18Hc1Hpa6YBRj8YOXT+gIdUWJkVr1J8lf/CQCYvTdR3gFCbAsjV/BDS/YzcThPeFNAyLwC+eIiXRvMonpuS4RFGOUmXtjBIu0++1xAqm7zTWGVrNIBa34CMZI+7aovWurUBFuhp5+69VHa6D0JKcpa/F3zb6xKrkAv2o3YCtjIqvO/8sjqLQURfpM9qTfA+reBOQ==
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


