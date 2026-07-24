Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FBE7C531CC
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 03:35:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0791D6B008C; Thu, 23 Jul 2026 23:35:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 050256B0092; Thu, 23 Jul 2026 23:35:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E83266B0095; Thu, 23 Jul 2026 23:35:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B8ADD6B008C
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 23:35:37 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 32B151C0314
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 03:35:37 +0000 (UTC)
X-FDA: 85022255514.10.01424B8
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf18.hostedemail.com (Postfix) with ESMTP id 71F561C0006
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 03:35:33 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=P+noAgjK;
	spf=pass (imf18.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784864135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=uVmINKpInT9k/IDJCUM2+h4Wc3WLHbV3fIvwETrUsKA=;
	b=CFPwGTm//M9RaUtfB71ZQSay9gaGXRAFA4U6pnGh90Y2eXh/XAC1NovI0mrrY6y5VRboX7
	decZqGnvXJQGx0RXjfPzQZ3raqDj9H8Hd0ytiRrPYhelvMln0VJvJdQ7cLETB0Z/L2oiE6
	c4CEhbPWRN9kfdCKdi0kra3okHuKpak=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=P+noAgjK;
	spf=pass (imf18.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784864135;
	b=gGr5l5Y3sCwsOdPaTC+rRNQfvpWS2DcZWIb6LLquSd2IpYDviIvurCvFO4iJ4jrrq72Ilv
	G5Z23ZJmkRdAV5uUWoFDrdADlxy8Cx/OBpv1WduBOgEi08J7DtKQQUYPaqXSpwuYRbPcCJ
	eNRN1JjulTzgGx66VUHhtUYL9B7Lhy4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784864130;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=uVmINKpInT9k/IDJCUM2+h4Wc3WLHbV3fIvwETrUsKA=;
	b=P+noAgjKnkV/UEVcxM6GJx0NoPihSkVz5ZvamYPwfkUPfhK7MDWgzZAIb3QqgHnPz6gk6R
	KAjeI1xr3MqNbAb+mXB75BkGHtxXaX09Curs6zlIxOq1Ptwe0ABckgTRKORcQSRVGdRqOG
	dnHC3I+cNSyzGG0/Y0bY+zL95L6nemw=
From: Ridong <ridong.chen@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Zhongkun He <hezhongkun.hzk@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH -v4 0/4] mm/vmscan: fix swappiness=max and clean up per-node proactive reclaim
Date: Fri, 24 Jul 2026 11:34:31 +0800
Message-Id: <20260724033435.2573323-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 71F561C0006
X-Stat-Signature: mqimop5qq9t8kqja5wkbb3ywwm3w5y1p
X-HE-Tag: 1784864133-987145
X-HE-Meta: U2FsdGVkX1+sbg7qInrUvSiyiFEuIEYw6PEveLYQvuTgZ2Q7DC60dT+U8W8FgAC/9Wd7LJsaJq5BGA77M3iHMVxSAc6fqhLW+Ni6JynsFEcbcfr7OCkwgRW/ZEsKK97+/Zde5fJMrWgPcN0cB9z6S2g+thxKLWbAZHKwv8mB7MG/62Ef+I9zDYV/7h7U8m+QMvxLl4/Mc3kMIKRcbEl51hSvxoYhEcJhwOHdxy2DnRw4xT8Fhpr4q2ZI3381JbkmyuuK0f1J05GE40nJd0NCMXqhZ+75Z3DDlC4bXWiC1gwILhqnWTkyo71JWn7cg3uBW/IeuNbHURj4uQOUi+d3ULdyqIIaHYW5/FObvy8b97YK/u24tq/AEFpAjr6d3qLt9dDBXuG4PHUmvIlyr7Jg8aadd0JQlgWG3rL6LDgsXUJI8nWDaSVqmmHd3I+SHnFTrrhLpxOSZFBMoWtHLGfwI4eSVAnwyRJnXsSdNYmN4H6XVuSXxdvTqDdHmyaD+Pdi+T8NZ4WtOzK/yX61gS3VcDPmVRdDyHucj2SAN4EZi7ynClTkFQn3qS8iESzrgh5BFzqmZgAXbc18rimKlDerPAvpFbvFryXHnsT2O4mqlSz8U9auHQZOt77PC8HXWRzNYc2+/RLyhg90ta+rBHri5umoj/1Um3q6xoJGrdHb0E7w3Nudf397kNJ0v5HLtVIZ5K0GFnvLQf/GMaRFh0hBGeImH9UkjmAtRVJ2FcfFE5ZdlDHBE5C/eTjTsFCYT1CaXaUdfZQudgsb+AFtJ5PXpetXkSBBKhaXOuPf9fSwLo391bVTBJrg4PFhf+O9EqzsPfsZi4e4KooNYgls11vcofEA6HtMQcQbC0vBO1Vg8XLTtJDwbZx3eigSu0Lhkq+osvMKBvJJ8IP95z/amc2o7TFbyNAvsH1suvJfz3vDNHV/ktg9qLqTn8QRgfrY8lDDm/eO3zmXTMFdsvkboc9
 zhKVYXzr
 JwJ6B7ES8a7sQ0a2dYR28h7tMGfJP8knIQJ3mVnHT01ep1vFmvISRsbPqfkA9jFMKtrSEQRo9FivFBMjV4VlTOMjm38/SYoynJpTU0gzXb2Mw6exXnQOGRTKoRf5Q2I2SDa+F+VtL5MJVZFDElWeJAFlbVp+Ga1PCMU1OEtfvQYznvdY6KoZNENx6QUS9/5emTuWYrUSbsE/nQk3WdIe4UmItWmrHXcDSLF/I
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

Fixes and one cleanup.

Patch 1 fixes "swappiness=max": the anon-only test in get_scan_count()
sat after the "cannot reclaim anon" check, so when no anon was
reclaimable the request fell back to SCAN_FILE and evicted page cache
instead.

Patch 2 fixes reclaim_store() collapsing every error into -EAGAIN, so
callers can no longer tell an invalid argument from a busy interface;
propagate the real error code, matching the memcg path.

Patch 3 drops the now-unused gfp_mask parameter from __node_reclaim().

Patch 4 fixes the same "swappiness=max" issue for MGLRU.

---
v3 -> v4:
 - Patch 4: Update comments and commit message.
 - Patch 4: Adopted Sashiko's suggestion to use WARN_ON_ONCE.

v2 -> v3:
 - Update comments and commit message.

v1 -> v2:
 - Collected review tags for patches 1-3
 - Added patch 4 to fix the same issue in the MGLRU path.

Ridong Chen (4):
  mm/vmscan: fix anon-only reclaim evicting file pages when
    swappiness=max
  mm: vmscan: propagate real error code from per-node proactive reclaim
  mm: vmscan: drop unused gfp_mask parameter from __node_reclaim()
  mm/mglru: fix anon-only reclaim evicting file pages when
    swappiness=max

 mm/vmscan.c | 55 +++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 41 insertions(+), 14 deletions(-)

-- 
2.34.1


