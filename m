Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BF7D606A31D
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 01:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=MT4i+kBt
Received: by kanga.kvack.org (Postfix)
	id 790BA6B0934; Tue, 27 Oct 2026 21:06:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7682C6B0935; Tue, 27 Oct 2026 21:06:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A60C6B0936; Tue, 27 Oct 2026 21:06:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 45F6C6B0934
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 21:06:19 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3CD23A8509
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 01:06:18 +0000 (UTC)
X-FDA: 85370244036.23.9EAD5A7
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by imf25.hostedemail.com (Postfix) with ESMTP id A1CBAA0006
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 01:06:16 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=MT4i+kBt;
	spf=pass (imf25.hostedemail.com: domain of 3h0rhagkKCP4zpskxiokxmuumrk.iusrot03-ssq1giq.uxm@flex--tjmercier.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3h0rhagkKCP4zpskxiokxmuumrk.iusrot03-ssq1giq.uxm@flex--tjmercier.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793149576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=PpW1w1fTH4pWdwk/odzA2Xx9G09sfx2zMLzLE1poreA=;
	b=tKEuFvb45i3qmQjN2/d1NthByXNLuQQ16Epzk8hqPLuF5AgJHLskCb+8yYvp6d9UAwaWWq
	0fyhcreXfvniwlf/9FlQlQNBY/fr5g3QPY2R9hl1C2EVe4vM7aO0hzIX2NpEEx3SPC9JyQ
	Lf7KZvJ97R0eaZZhydjwAyxQc+X9y9A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793149576;
	b=W5QJiWvN7c68fyNfrpAmcCnjGftX3B2P1kAVCzxCYm+wA/gwyRLvOETSXmtjwm34/a8ehA
	la9Ae43rvEFRlXVNRXe10yujz0dBa3Xm/qnheGgYNJeGbhPt8lFJGFVA0saylE8IS8ZN+Z
	JOeLmCkvDfQtfCx9RSYjjL/ud9dy0rY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=MT4i+kBt;
	spf=pass (imf25.hostedemail.com: domain of 3h0rhagkKCP4zpskxiokxmuumrk.iusrot03-ssq1giq.uxm@flex--tjmercier.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3h0rhagkKCP4zpskxiokxmuumrk.iusrot03-ssq1giq.uxm@flex--tjmercier.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2ea63087d79so3456165ad.3
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 18:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793149575; x=1793754375; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PpW1w1fTH4pWdwk/odzA2Xx9G09sfx2zMLzLE1poreA=;
        b=MT4i+kBtgkn34Wmi7LzyCXCAuPk+Cp9Q9A7WpA8EOnJ5HKX40gmdE1AMewwSSxe3mm
         HaqhjLy+donUd5W/afKULoJj7fTLsjMNWMiqMqmzV8QVbl/FWy6LPkifpel3Q/u/h/3b
         tX+O8Rxad5kSsFL1mdhhcEEl3zKu82KtS6IYg7W8BXuUMFqQzepi/pq13Bccbkq5sfe3
         EizlZfT2SWnozlE3+db7j4x3X0bZboeLU3mwpCmma/mKx08u4uDanrUq5/nAc4S3e8xW
         eaTYCZ2i0byp9j3RnOEvYE7o9F6DQkF3tYCr41Plbza2ltyq91+g6kfVO5YH6AUOPmU0
         mbHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793149575; x=1793754375;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PpW1w1fTH4pWdwk/odzA2Xx9G09sfx2zMLzLE1poreA=;
        b=L8+zVTM7eiwgiNFe3khTbFe+YqT/rk2qm3lfLH5ZoFUbU6/QoRzE3I/Zctb8oQSFGQ
         dzYb7FUcl1Vl5MCsDVYb5Yg4uEX0i245HUEUjPHYAILaUtsvsJlF+M5s/FNYh0vc+Iaf
         fQUcWOrIJLUwn0oH7/5gGmvMUgCuj3/2Ihq6MVpoGowu/ieEoxyR2ICrb1rIbEvGexcv
         yDnOH9S0DzH7WhtkjiyrFrvp5UDQkpMHpH24VHODv4Fsm7L+tKULBnpxSioXaCQZ3muO
         Ei/m8HFF+g5Tx28KnOypEz3yrQby87t1eOL4SCyBdIRD7lObEHWojBg29+/+KP4EfvBP
         b2jA==
X-Forwarded-Encrypted: i=1; AKwUvBxuFNFW5hQomfgvqqf701Muhjwgy3K7QO0gYUTpjYpCNTym71vEEuOSY+StGTRu888UCeKq6aLKDQ==@kvack.org
X-Gm-Message-State: AFq9FYI5xD8LuFkOnzOJfg+oxIv3a02Iig6vrVuS9nEFVSzzJJf8HdOI
	YN8JH2wHzZnw7IrdUfaIZVDTqznV8txlmCXwucqZFscfCeMJY5HUyEgaX9IBBJ1xeQbu395K79M
	srjO6e8mrLAPSYJDHNA==
X-Received: from pldb12.prod.google.com ([2002:a17:902:ed0c:b0:2e8:fa52:c600])
 (user=tjmercier job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:37ce:b0:2dd:c100:b2c8 with SMTP id d9443c01a7336-2eb005a750dmr7696975ad.51.1793149575175;
 Tue, 27 Oct 2026 18:06:15 -0700 (PDT)
Date: Tue, 27 Oct 2026 18:06:04 -0700
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261028010611.3929937-1-tjmercier@google.com>
Subject: [PATCH 0/2] mm/vmscan: remove obsolete offlined memcg reclaim handling
From: "T.J. Mercier" <tjmercier@google.com>
To: roman.gushchin@linux.dev, muchun.song@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Johannes Weiner <hannes@cmpxchg.org>
Cc: cgroups@vger.kernel.org, "T.J. Mercier" <tjmercier@google.com>, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A1CBAA0006
X-Stat-Signature: 5usi6khrizy6crtqgguon1ui4rafxma7
X-Rspam-User: 
X-Spam-Status: No, score=-21.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793149576-338644
X-HE-Meta: U2FsdGVkX187L3/zBrbno8Ah/tGwZwNNYHdVtHO6qVl8b9cBF9K1Qlsnf+P3wi9a+fowWplFrXpnVqi//cj9yHq+Jx/3GWuC86MKAYViFc71pdjQqBqAkUrlpfW3ut4u9UE9vderAXh8tpi36iXZmj8V42lBC7pvnb3SXXqBqFLetwN64JNFY4LzRCDy9VJs8PV/Ze7JhlVicrmJBWsDIy/OwhMetuT1jjvVDwNASx2l5sbDgky+BSv1i9OYVI1zVg4PRuw6AdOevSfbmqLGMjfhyNmcyjozuHofJvpKbpymKjfoLKo9n7C9lfPskAM0MNmxoK3/1nDZwFMR1pP+V5roQZIDtKvS6Ns2UmZkPOTqtuyAz3xL9lhFbK8IXIbt/Dd7AMJHszOA3oIDfVc7XM7CWk0TSCZwjDF3n8jHjp6xb0aXvN8haAU9v3N0/rnBp7s8b2escGp/NTS1YhmeVl/H6dus+0t4XaGxHrOpXZJUBry+Pe0C11TFef0CMQX9nup3ufdMBwhGr5Fw8KyKBTMGzdTjArA8KceSN1YpowH7L4h+qn+YqIoD+3RLISRXWu+8h2OQdNVXUs4s8IlkYLb9UTQv5P+ubnim72PYBZHUnpzKoG0nE4cgNIifhJY+G4xGJHapFFxe6/k4fZ/W0xXif1xxxA3NP5Du3M8uufYvFjvCCi8aP1tmpf0Wq8nIIMs6QuCOuxdRaDd5VIgruGs1EbWJBvBHB/3FJLXEM8jEbDFIDsfHJomcXeIYVb1dun5ze1H+QlaWhU5vJwIlOm4ytlbzIptsS/+P59RNN0s8ocvniiSWtBWrPqSz4TI2dXCUfPKpMAxGHismpJKbMXLXyn+AyZKbuoMXY+ElmaDqUlGKrtR2x9ZSr7wsTIY9FJ91LpueSgyCfeDAgIfVlz8TxBMH5jB3JRP+bLHZLBQSJh/5P+q+uT5RHQCSsCdOgINu6K2r0GbO3celBJT
 +wK+4dLV
 odaYNeIHpN3AIuP6I58ikLZZ7UHpCcoqr2qLDD2gUuPpfJIgUzy4no43CRnI7WvL5Vf6C/er7DoFgzT31cZzcLHnYtkrINKl4bdaR/bqgzDiSbgWGcN4beYqn8GKjj4Al9pqDB4vcjeqOluVeYyZHLcmQDpJPIsYgXWHFGEeutaGysLw/QrmGqYA6ywYo5Yl5G64PNAoAg419GSyOwLu7ubge8SNPYDpd9p+LVy5iKmRDTgth/EeS86WeD5pgrWUkVVe1juHY9bnJZQHJb4eMYQeyKMuc+YShFjhnwZ24q1p2SeH3wauZYOk/EM/crcbu6mLg/O4Knpyt8NbjZhJfVKpNeZXAohnysncrU4PAeqaBhll4QDdKhg0Hk/sQ+r/YWp/sZrENUkShXYILsY71nBsYLiFwCqhhlbXujsK+3g6QsBjRXJuEO+Djs4racyiEzKSqZzKTZTzjH/lyDX07ak4WMwGClLBH8WUCNx3xuo+rptYnipswVjFnaUPS2nDZBNr6+zXMU60IVRg8hvozC4Jwqd2T4eRLgZEfeO/P0sPbUHuWDqwgLIL8ABKji9IdtbsLRWrL4E0Z/grbZAdJd1FNVyN1F8DqrSkOmK9psJANS0k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Since commit f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of
dying memory cgroup for LRU folios") and commit 0e0ac326c511 ("memcg:
move LRU size accounting on reparenting instead of copying it"), LRU
folios and their size accounting are reparented to the parent memcg
before a memcg is offlined, leaving the offlined memcg's lruvec
permanently empty.

This series removes the remaining reclaim special-casing for offlined
memcgs that assumed they could still hold LRU folios:
    1. Remove redundant !mem_cgroup_online() checks in vmscan.c
    2. Stop rotating offlined memcgs to the head of the old generation
       (MEMCG_LRU_OLD) in MGLRU.

T.J. Mercier (2):
  mm/vmscan: remove redundant !mem_cgroup_online() checks
  mm/mglru: stop rotating offlined memcgs to the old generation

 Documentation/mm/multigen_lru.rst |  4 +--
 include/linux/mmzone.h            | 22 +++++---------
 mm/memcontrol.c                   |  1 -
 mm/vmscan.c                       | 48 ++++---------------------------
 4 files changed, 14 insertions(+), 61 deletions(-)


base-commit: 2bba28e98578de622ef307d00875aa8f8bca3d10
-- 
2.56.0.307.g5fe7bd680c-goog


