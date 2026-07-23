Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE534C44524
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 04:57:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4623C6B00A2; Thu, 23 Jul 2026 00:57:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 439866B00A3; Thu, 23 Jul 2026 00:57:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 379BA6B00A4; Thu, 23 Jul 2026 00:57:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 152816B00A2
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 00:57:48 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 91B461A03C5
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 04:57:47 +0000 (UTC)
X-FDA: 85018833774.07.184A6A9
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf14.hostedemail.com (Postfix) with ESMTP id 35638100003
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 04:57:44 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="cB/EqYXQ";
	spf=pass (imf14.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784782666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=D9PXK/VnSXu9mRT9lWl5kfcdPoYQW0WERqPj1082VQo=;
	b=yeEUatidh6IHqZKFYmBT0w3JNGGodogYY8INgvTKJlDyfJFJIXbi/UE9CIB2GnZTsVrJJX
	fifQ00IpNR1rpyWiaqY8oWXGHza0uVMqml2npChhxs0GaaFN8g1JhIC+B+I8IIH+bJXe6E
	eScUTg5KXHWsRrNIz3wv0iffIJjyWNY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784782666;
	b=NkZvmocBrJ6zlS2LgwE+C0OF/CUBgtSe/FTxVRqdP3rcm897LyUbV3SVCgYMn2TOj9pLmA
	QU4nkIU2MwwDA+4FSpPQu8wNICwrj2oxlYu48LqFtifDAYglvmaX5xUAIGZScC71qTF6yC
	vpOcPAlowz7+Dmnc5+g7vFbCiRKkA/g=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="cB/EqYXQ";
	spf=pass (imf14.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784782660;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=D9PXK/VnSXu9mRT9lWl5kfcdPoYQW0WERqPj1082VQo=;
	b=cB/EqYXQJO3MdMYA92smLpSiJGKIBTCciBIZHrnkrEmRbtbVMzslvXCBcHawyVA5c4Z67K
	TIXaaFnfmrdygiHp/mJiGgyZSMWRJmDEMJRU0kZuEKiNlJr4KANEbWYIKu+XS6SuPQ5Lgz
	D6HsvqW9syMp88D+ooqgIVvnrpCrCO4=
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
Subject: [PATCH v3 0/4] mm/vmscan: fix swappiness=max and clean up per-node proactive reclaim
Date: Thu, 23 Jul 2026 12:57:14 +0800
Message-Id: <20260723045718.2052070-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 35638100003
X-Stat-Signature: uabhij58goeerkw134wrkpgsk5d6muz8
X-Rspam-User: 
X-HE-Tag: 1784782664-828896
X-HE-Meta: U2FsdGVkX18Ugz9EAiI+dGErOakb8CTRfuBulmkL6HS0ZbHPYUPhi0C3YyUp2P95yU4DtNA9iwI1StSf2OsKtDartM0KjQLs8VXdH96BoneHDw1XA1KPAA6MOFL28aB+m7GjiyX12d+R1WIT/RnC4uBlu3T/Crv1RA68WE2zVkOlxrxfz9psPhD7/c51JVEuIVoc5XUPfVxbZkolCiYgShNQfI1r8RS2jWtXAvWP2aJ3wROFbvs8KI2afcBFZWidtT8FIdUpIjbtzf8K5nzp2N6OB7sIjCrBzIqaBr01Ei8pwFjMh+aOcsfq83dvao405/AhpALLSYqIJBAWD9LtKQ3Trml+Pl2yMxPSIlttT8OrOsSiBXZsSY2EMHx7hKxFJi48lSCBuAnvL9eA6TAaz0w75jRNQny/AcmLkOUABtVQGns3iNE9Oil9F/kenGuzauGPuc9zqvU+P2W8B+Ahig7447b+JpEtPTm+oF5vOIbix0QojIFugZI42AltgzUm1Za9a/cgMIC0p3z/GWLYrUxJfqdx3KE/62nUrrJ1ve/6HtYxkFi6wuIr4/raAeKi7H3tSDfe11wnb2yxhLL1EVRBODwqE8qfw/P6owx8nomKd6U/qVyIzbXGgv3YzmXUcwxFbhDahVUrzwMurl0AgYYuJpIfrpW506DDSN4dmxAiN7l9ZBSSKYbCJteHypYI90lUCkKtoxPbveFNWbbJztKjEz+ZLas5smp2UsW55/NUqDwX6SbffTVw6moz7uFlggCsOALaH1XsLpjJkqTxlhr4eS5tQDFa+ChNCf4RhwbaaQelKPgOlSpX+iV4Jheqt33rMx0wSBZ5pOfZW4ux51qJ5fkdoNewhb6QulgU1DRhefgNV2pMOpn3S6HSDX/quw3vNlqxDz1TCb0A+G0+5pYWIUgXcxNuJjQIClGigT/KuM85Qgt85EqqivZ9iNUMcDcCm39P4SIYo1dVzvS
 lsN7+m4C
 u8TRXAU0covERuGWI9EF3hPRWvoAHjCy72vBuuWYTCh7gS7qE4Ac4575sV8r1DKkcTZ89VhN6DeRrU96onoW0qcFf3AB687TQiYXa4ZEtY4NHSsB2VXiYuEB6pa4WWQTjZ8i/KnJ4jN0mxtqiGyVseRZOAzqu1R9PunCC5QAkoCqRDOs1YnFapWfITRmM44kSoKnSsAGOeQwGWWPc7sO2tJydsZFf7nk1v7LC
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

 mm/vmscan.c | 54 +++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 40 insertions(+), 14 deletions(-)

-- 
2.34.1


