Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2254CD8C8E
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 08:39:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 629EE6B00C4; Mon,  8 Jun 2026 04:39:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DB1D6B00C6; Mon,  8 Jun 2026 04:39:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A2426B00C7; Mon,  8 Jun 2026 04:39:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 39C0B6B00C4
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 04:39:24 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 015BD1C2B51
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:39:23 +0000 (UTC)
X-FDA: 84856096206.05.D896F55
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id A94E7140006
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:39:21 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ANQAfEUL;
	spf=pass (imf23.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780907961;
	b=bj5+6y7UKQDl5gEJihcj3rVMvz4tOgs//NmpjaXRZz7GHDUDroy3Jc8aoVGwI46qSdUM7p
	eXlrLQv80nxdfeOMNB66EpcX7l88Ty0zRLtR8ra80Jkl8yY9Jzb2jyDzXn9IcsMwetnz2M
	/bLxesOCTIZdXQQjJEZ2pC0T3318fKY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ANQAfEUL;
	spf=pass (imf23.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780907961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sR3mqTwhRYGGG0tioR5exPzZ/dZTwNqp64a/18KVd0I=;
	b=TbyvHvEarfDSMCSpTloyD+KOgtWx/rc/QorZ2WqmtAltbgB2feAnUb4+UkIx1gSvKK/vxH
	lVjWyshwuY8mmsmZqNKbRzWsYyk+/CmA3HqJ34lpu6CIgvL8TiEU0c1MncHOGkcx/YW2gG
	2vhZ8wPW+FBj/IAxWXclSPClQ4G+nco=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780907961;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sR3mqTwhRYGGG0tioR5exPzZ/dZTwNqp64a/18KVd0I=;
	b=ANQAfEULV8XmTV+vtAeOkdR6x4QT51Ts3l55wm9o7frJjduevHHK93WazvK8bTQO2YxnOr
	Vr+pRi35U8bcvcMKM8zcikFoEPkPjAxH7e7HLPlnvJlZWALrW3gR+g2K9zB8NNklr1TRNW
	YQix1BJAg6bCyS/glaIafxRBLEuWXRU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-664-keKYwTmQNeK2-I-GDRftcg-1; Mon, 08 Jun 2026 04:39:19 -0400
X-MC-Unique: keKYwTmQNeK2-I-GDRftcg-1
X-Mimecast-MFC-AGG-ID: keKYwTmQNeK2-I-GDRftcg_1780907959
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-490b3ec3f7fso27083205e9.1
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 01:39:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780907958; x=1781512758;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sR3mqTwhRYGGG0tioR5exPzZ/dZTwNqp64a/18KVd0I=;
        b=pdJtvgH8qzb8NW32C2Br2uuqm6OE/EsSH1a9u5f2O3yUpL611TmTs6DF/EYKsuFEDL
         5vfIyLMMlPlgGHVWD+gMQe8X0o2kvjoIs4Y6OM9ps8CMSDInMhRdXqBTnNx7px8JsWGu
         A9VgxiG3QPn6bKRgJf8icXWgBVBvRwaZszLQ6ShPs/84Nf5MQynsIO0KyDbKsIQtRryq
         8y63MHaiLWG43C9c6qsFdxSH+z5a1pgAnBQd0yFb8poHaeoocIZtPJEjnocdyQtqtHV8
         3h5tLAzpecGnnIevHieEmKmf2uen+ZZcA3L7PJ5bkGk7CKqNUo8kWt4BmjjP8ULFHfUj
         ricg==
X-Forwarded-Encrypted: i=1; AFNElJ/4ZhMOgLlHYz6EbXJkm0n1SwP8+wGIfzOeKSOS6IvbcYCzZFujTgREFMLY4T1tYAfhTeHO9MwwVg==@kvack.org
X-Gm-Message-State: AOJu0YwwAcHd5npBesSvDMwWZGjmzSzwI5n8aXoJ9XtUmu+m+zNwOW13
	ld+EKKJcETevp9p5rq2/qq6gck5JMsUHgGMLbvhYED1Xki6yjaUpQgID8Kpvcza3wBBNHl2Q36/
	appmxkVv2EFkNzi143X6Osl7mYIJowkX4aQ/tFfG0KEQBbCjy7LwQ
X-Gm-Gg: Acq92OH1zeFbZkgQeS80tKg6s3cgj/ES1CI6ksr+folTPEgeZQGc1jVZ0bPoqPaIeci
	V97NBOQJ+SFWijiihYDXnTqg0bp8VX+GMJDH2xeMD6yT3eOWS73jeu9Pe7F2sFuWxEhYECXHWK0
	vStmfbf9wpWfme1zT15wRAK5G7ceeM6wLouNoqRUYtr08n9yC6ZGs2LWbXs5rwKVy6FF6N0ZvNB
	5cyzmfCzlbjre8dJ//5eh93xirILPPdh8N82HMeN39rLFni2qGvmwrv+aNdFZ9GQxrz+ndu8KTK
	pODpm1aGMYeRjFn6E9zXTVQiswXdADsjQ7pg5AYpXDWzVQrEOQMOfzzelRK5fGE3+rnubq43DlB
	tenbROYnfbVN301H6pCPDql4=
X-Received: by 2002:a05:600c:4e94:b0:490:9588:bdae with SMTP id 5b1f17b1804b1-490c25e30e0mr244497245e9.18.1780907958522;
        Mon, 08 Jun 2026 01:39:18 -0700 (PDT)
X-Received: by 2002:a05:600c:4e94:b0:490:9588:bdae with SMTP id 5b1f17b1804b1-490c25e30e0mr244496725e9.18.1780907958066;
        Mon, 08 Jun 2026 01:39:18 -0700 (PDT)
Received: from redhat.com ([31.152.37.159])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3e59f5sm399310235e9.14.2026.06.08.01.39.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 01:39:17 -0700 (PDT)
Date: Mon, 8 Jun 2026 04:39:10 -0400
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
Subject: [PATCH v10 26/37] mm: vma_alloc_anon_folio_pmd: pass raw fault
 address to vma_alloc_folio
Message-ID: <94f64aeca62d8419d76f2cf82b36f1da6017a312.1780906288.git.mst@redhat.com>
References: <cover.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780906288.git.mst@redhat.com>
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: UshM9Affo7dLuTPyI5nijiLPMSovoFoCkxJX62K-ydo_1780907959
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: A94E7140006
X-Stat-Signature: r5h3qyhp6c9uzjwwsjccyn3bjb83ij9t
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780907961-612440
X-HE-Meta: U2FsdGVkX1/MP5dDv8MxkFNr/JFIn/k3atj/OjNAEW6nLFD+ef729e5de4ZibDJ9fV8R/NHKP8tLKFswtyV/ShZf7DLlIw0WMKvf3Nb+SUHVNqsXNgWuXat3FbfcCUXpZ/hHw27hKEfu3WN8wFQ334vYKRsesN+6SBiaC4O17zGCGM7a7oNetqlL0iR/X2VjkjZEHMOzhl9JVA6vkE93kGemCWOkEWNvoSMsfbZsf3BeTSQ1E8H3q9wIDKOlD59fORhevy0Ef09N5Io7WHnIcnBEzxXTV5D2AXjdjkrCZtdCSDqJM8MNVYlP/SAzggoCIcGlLDEeU2XUMho3hnvRkewRdtrmaCcoUbrO//ZJtpL0nwfyoM/r030Mxr48K2EvzH7p5eybyY4ZwhkgdgfnddbJueVsykTOkgxH4z5m8LSJo53yqneicjAwqHiUCbYOoS377y3Qp4P91e1wim56vqsEKlwUICVfPS82pQAyrSJ2p0+6ZddZkamJTdGuj6cx38a+1cYl7w38fxQm+pH7NW8KIdtmMtI0GHXA7UqcjOvduVvjIa+yQaP3e2u0mFQUdNLOmw9hvCi3ECyOsAKRbRbypUQ8IFLWQZcVSLu0GGzA0XqWQ8JwbT6u9lVCBQXlhD8hampPvKOTHKBbLBdhMKTEcwoFOJxHgQrlvSfAdmPWcNwDBeMPRxddFnqABv06wrdtrZmD4YE08dW5BewCNtcjrU/ZtNxA86kBJwfdt7JaY/4tgI1c/fwAxys8z8bNBGM/eqtnGHrMHbrkpP1outB49ylgsudLyht5INSQpCml6kyXmWQkqRY67j95WeL9XHwVzsioisdxxdIv/x6Y80gx+kGFC0xAgHuFgQ6FtHuXwnS9v2fkBuXG9d4rhVU5mk3pvrlcOqCAMKyckh833OBE+Qsp6o8eC0Fd/CzvhzB91gu50MlGwYNI7deSIMBEe10hUyXA4V1Y2OMvVJk
 wSoGWlw/
 P7loKoGv+9oCAMlJQFG2vavcs08Np7WwjDWhjyQv0Pk1lhhQ+lQka3UBLzZVBYSG6TnGjMAdhhmX/Tp3mL87Q7vUhCjC+zn2yfcl+yhZddw9xdWm8BPy51L0YyfaDhioU+Gp42HbKEpjy0YFqIQwvCdcqc6ygyWgVfirdFKLIcXARDtvZ5KnkyzT1fYM4KBwh6QnAZ83Lp4UTRjIOBzBT7jToeYfRNd1LiatMJW+Hi8ikxEDEC7G+rRJXQ2WalnhwVLo1QwG6W2OmFfMr+9kLA1xrd42QH3zlb+i7PCwts8mpsWh3WCd3GGYJr4LdyGTMr48X4dPDbPIYfFzJ2cJGFHKnJCR8sLvurVSXSmY5K54mAcaC0qc9F2+yFpNmiAaYOKD0Jh73MABv9xeZrByks9p+49Q+a8/mRpXH8bYuXc2C3klfmNZM2EqKeD6X8boZEdlm+QXhiqttNT7+GeVceUi0pBgRShVVYvO60fFIT1K9a/Vwc5Ea/fa3Zbqqb8YadlCN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Drop the redundant HPAGE_PMD_MASK alignment at the callsite.
NUMA interleave is not affected by the raw address; the ilx
calculation shifts addr >> PAGE_SHIFT >> order, dropping
sub-page bits regardless of alignment. post_alloc_hook will
use the raw address for cache-friendly zeroing.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Reviewed-by: Gregory Price <gourry@gourry.net>
---
 mm/huge_memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 970e077019b7..d689e6491ddb 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1337,7 +1337,7 @@ static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
 	const int order = HPAGE_PMD_ORDER;
 	struct folio *folio;
 
-	folio = vma_alloc_folio(gfp, order, vma, addr & HPAGE_PMD_MASK);
+	folio = vma_alloc_folio(gfp, order, vma, addr);
 
 	if (unlikely(!folio)) {
 		count_vm_event(THP_FAULT_FALLBACK);
-- 
MST


