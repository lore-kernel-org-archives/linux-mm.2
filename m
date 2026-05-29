Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CBF5CD6E4A
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 15:22:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEAD06B00AF; Fri, 29 May 2026 11:22:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC23C6B00B1; Fri, 29 May 2026 11:22:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB12B6B00C3; Fri, 29 May 2026 11:22:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9BADE6B00AF
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:22:37 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 69847A0195
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:22:37 +0000 (UTC)
X-FDA: 84820824354.04.A39DEF1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 16B5040004
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:22:34 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Q3f4U2ha;
	spf=pass (imf17.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780068155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3RnCcviTYcs0bJrQCPa7/Ta1tOKxh1kkpoqwRDnBft0=;
	b=6g7FF9nn58XkwwiBhMlZR7T/3ALGMUc9ew1PlHk5Fs/yOL/gSshIfpZstMzi6dy2smy6ay
	bQLQdMdr79QYoFFyUoiN4rajepwA6+UMIOOPvmHy9wn+Ue7F6IiAG8UZeGSsylMkhKGzbn
	DHwKu8d8S65VrfEnbNrOYOflTcIGYO0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780068155; a=rsa-sha256;
	cv=none;
	b=0V8anufalgWM/2hY2T+Z1rehp4EDEy/MNzgN9JmexeJ0nzSPcW3xY2Z26R82BWjVfQlJE0
	dir2MtyxCofzQNI+zwvtjZC1Cfs4mGWTMQU+w4UK6QyjAF6xYKmkFAiuTKory37mozi70i
	tXxyfY+87rC/z7kGjLRtgafzyOfUNfA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Q3f4U2ha;
	spf=pass (imf17.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780068154;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3RnCcviTYcs0bJrQCPa7/Ta1tOKxh1kkpoqwRDnBft0=;
	b=Q3f4U2haBuvuzxfAXnu4OSPJ96PbWImWFQMEJKbOfbETDPSPX8rEmkaFOqFWi9x0z7HjRl
	00Z6T4Dbq1qx0as8PalWGaFDcAqMYsKNJLWKkW9z0mKdemAFXwf278lAzwQWsRT5w8G6Qg
	5t2k8kQXki91cGhfSKLCYSV7FjXHG7E=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-224-OHnQ3yugPlaQFwosOyT2Mg-1; Fri, 29 May 2026 11:22:33 -0400
X-MC-Unique: OHnQ3yugPlaQFwosOyT2Mg-1
X-Mimecast-MFC-AGG-ID: OHnQ3yugPlaQFwosOyT2Mg_1780068152
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-49081106196so27065315e9.1
        for <linux-mm@kvack.org>; Fri, 29 May 2026 08:22:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780068152; x=1780672952;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3RnCcviTYcs0bJrQCPa7/Ta1tOKxh1kkpoqwRDnBft0=;
        b=XPM4ByDxfIy9vsmaeT7g5xCTxhSddw7pU5PZrL1NSSMQEp3Mvo+KSy9Nn8gYHxx+Iy
         J2SWwqmIIFzAsHMh90lJvpahW7WgW9TelWq9jzBs6QEuF0jq27+/YP7my3pewiLTych3
         m5C7ur/ry+LpJxSTtKz6UHOvKfLCrNMpoLk8vxGRh96QIkeGDeOXp5t+MGHW0NEEsSTT
         T4B05s6REcrD/LP0tvPCNWrY24Z+IjNnU51XWzl6zIXADHPJNN5ebFry8i2QCsIGA6Sj
         MW1GcmczVG7bAvlSE6iJK8rp3HbL7YXeBySC+7fq/rfO/GGpcCQAek2wI9OmenHQfzL2
         SEnw==
X-Forwarded-Encrypted: i=1; AFNElJ95axPkqpgET0bmcJ3Kwqz8lkXWpOmNLdeQpR6cAW/fF2HWTMthSeeVS56h8Jlxz+tb3ftJc6AnJw==@kvack.org
X-Gm-Message-State: AOJu0YzexZsJbum9u/xgZNjpWkIUj4BZch3q8hklSZdP179y0OZ43pzw
	QLwLVReE/uJF2CcSJBe71m5YoHgC+sSr3zso8y+8jMYtjazUVJeJPQsFK2q5/7ue4q2xuePtJPD
	uhw+LZQfy3nLsQE1SF75aP3TW6808RIkgFbGso5mKtD+8dZcJnc/Y
X-Gm-Gg: Acq92OH7btLk8j+xgzP1Bv2ubIuFttTHm/Jw4SSYb1Kt7+0mytkoXTCUFJ9o7xG9wHX
	C0rMKjyg7+63rT3q3VzME2OVO7Dk/F9UmJGQMBUDXvenRTxfXaEQWE7EOx+Tt1Xj9FJ6SnfWHeY
	ZXn/j0uaZQMPULzOyQOwsuTI+8jemceHIKDx66OlD1+ONIFLjefj0gFjFO213prygFUTQRDAX5r
	5JCbueYDsX2nMtOFPnVX8hs1gzzuaQNS2SaLuBUyOUbMwkABG8XTTJZGv2ArFyNt4nj4X7VgX4V
	zoVaOQuR/ZVtAdRAOV+T1nVYBXU8cqa+QZxd841QuwPQG692uHQcFSusfnOkTrj+e4IUW0S6w1a
	jDNyUkCON9x74SPC2cd1kgiSOyUYcX+uLYNGVjabOE6AaGWyVfMSFig==
X-Received: by 2002:a05:600c:34cf:b0:490:5e2a:f924 with SMTP id 5b1f17b1804b1-490a2900e81mr2227915e9.7.1780068151783;
        Fri, 29 May 2026 08:22:31 -0700 (PDT)
X-Received: by 2002:a05:600c:34cf:b0:490:5e2a:f924 with SMTP id 5b1f17b1804b1-490a2900e81mr2226845e9.7.1780068151254;
        Fri, 29 May 2026 08:22:31 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4909d6eb3adsm46766005e9.11.2026.05.29.08.22.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 08:22:30 -0700 (PDT)
Date: Fri, 29 May 2026 11:22:26 -0400
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
Subject: [PATCH v9 05/37] mm: hugetlb: remove dead alloc_hugetlb_folio stub
Message-ID: <8e2d9431b0e324100d550c765024c883560a4367.1780067977.git.mst@redhat.com>
References: <cover.1780067977.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780067977.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 73ZiwMKmUSMnAzdsXKMnhPZa0lbOayr9_waB3zCB_Lo_1780068152
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: 16B5040004
X-Stat-Signature: epwi7esus1jufqwj9dss7zw4jdceh9bm
X-Rspamd-Server: rspam06
X-HE-Tag: 1780068154-551363
X-HE-Meta: U2FsdGVkX1+F5PbacCRkLOJm2SoUjNBO/Jr1QCh5a/0lHEhJ2xmw4XjIcEFrlZG7rua2uhpKh4jiUGOuuZDPaqA87V77ITpmhYuiPOPgTjokMTfrTo80V/SEvLqGmkdIoI3OHCfks0btNVJTr/7kTWQd5AS3KqWDC0ehLNf6hejIQHhElrHIjNT56CCv14ws9oM7Dr10vKgTRerbl8xdGXGPMqhJLqKN5iEOk/hJhpsizcYun+ow6IjjM9vx/kDvwqjOxGKja4WA1c1P6nN3H7mUmk+xMc4FsGQHYV6FfdzsjDMIuYJdavyvW+HfVBQWfb54kQ8KvWTU+uFvO9D/7nCer+RWyzlxCDW7CP+g9e+cciew5U37i/oi1lXPbW5EawgH/zECV7+7xXKp+NieGxrV6ZlvlfFx3kBrSaq+YIuGqjYjaQBgkV5WuMQheUdUOJeDWQWJy9ZhrGvJV9ZxOgvN0UMJIhPqRXK5tBIESZTTu9xJg/u20xdD5QkNK5lbCSz/Sze/Yk/U3CR7jLvVM0cQ3FNKH1lFcylThlPV7gkvd13m85KYy+EpJlu/2/27kQLA9W27rPeFIACIjfLzug58usnYuoFfdHdfwX9Rq1jKH7yCZcDGWG6pGYN7Rmx5qXtW0lEOG6cmS6ecR86sFb4qtk+Gzo9v2N120Z49DmQJ+faIn8kOG9TIdclv2Vtl0Y8YrsEhumxnabErubgRy6mM//aIMYDfaG5PN9+HHe3iVb49rfjfElt71w40X2H7SISSummbq6pV4/x7tf7lIDQU9IWuoeKKUlQ78m/DCBOZ2MsEUlJbxhiE1ad1akOBv0Jv18q5PjNT11xmLZK/hLQStJyMuWeY3pQEpSau82tAFWxrao7EjOAz8hFlMkgCp+GK7KIawV9LvKSdaKoMcPJW7lbqEKeqKFtZfHKUubG1fL4oDRAfMVb0PuV8k1xSW9P2vgKhkPFS2I9XiQw
 onMQWdpR
 MIIL3/5CNNZg9dzr+bNU5ek7+nA8MZWLeOZrMp6JKYGnz9aY5rvJh5i8dgO5K7BnX6qhNxALERQRIUGDVkyK6RU6laF/ct5IaPEHHUWMc0fPa83CXjXo14rO/bOjFPmETvjJXj9ymCzFWVV+meV+LcH7TfPARSMhgxXj0thKx8IahOAhm4V3wOY7iahT8NQ2x6iC4RfKKd2KPISzhwZ08ZOslvl+gjetIX1RWfOyWl7ecvNCsaPCew0p3L6KAbP//ayBygoJas1U/a9sybDVRRaQ/UZke3zdUk7RigQBTUaG9rV7S/8vjVQzpZJh+Da7Mg2haFVyfnit238y7l38vWvXl2CsKq5B8+hOJ1529ULv/w6ZpCUO6NaQzwlMr2L4hLTupQ5aC6uePCsdFJDo8ZboY92HfjcRTp8hasiw7fY52JuBxFPzM2yrALAcE9Z0JYTaS1BXvkG+TY1ftRmhVIx0l1eJmlNWUfVLUtFxarUQHZkbM+1pWCtbyVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove the !CONFIG_HUGETLB_PAGE stub for alloc_hugetlb_folio().

The stub is dead code: all callers are in mm/hugetlb.c
(CONFIG_HUGETLB_PAGE) or fs/hugetlbfs/inode.c (CONFIG_HUGETLBFS),
and CONFIG_HUGETLB_PAGE is def_bool HUGETLBFS with nothing
selecting it independently.

The stub is also broken: it returns NULL, but all callers check
IS_ERR(folio), so a NULL return would not be caught and would
crash on the subsequent folio dereference.

Remove it now since follow-up patches change the signature of
alloc_hugetlb_folio and would otherwise need to update the
broken stub too.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Assisted-by: Claude:claude-opus-4-6
---
 include/linux/hugetlb.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 93418625d3c5..f016bc2e8936 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -1129,13 +1129,6 @@ static inline void wait_for_freed_hugetlb_folios(void)
 {
 }
 
-static inline struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
-					   unsigned long addr,
-					   bool cow_from_owner)
-{
-	return NULL;
-}
-
 static inline struct folio *
 alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
 			    nodemask_t *nmask, gfp_t gfp_mask)
-- 
MST


