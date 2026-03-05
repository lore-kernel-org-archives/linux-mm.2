Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16A1BF30951
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 11:56:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 807C06B00AF; Thu,  5 Mar 2026 06:56:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D8046B00B1; Thu,  5 Mar 2026 06:56:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F5316B00B2; Thu,  5 Mar 2026 06:56:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E0706B00AF
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 06:56:47 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2CEA05B7F4
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:56:47 +0000 (UTC)
X-FDA: 84511857654.24.446B67E
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6B7D2180004
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:56:45 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rFyAWsFw;
	spf=pass (imf16.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772711805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=evy5ffpxH1pOU6KU8S5DoExZmuc8IAjbV0oiS0M36hM=;
	b=ZQ0XbmZI959WAXhw934TmG+wLXdgwxIuLypnkQOVO58R8FuO6aGi0pcJZ+lK41jkc8KMO7
	iu9CN3i/7keqfl4KWk2Fr8ZHN63xvA4dK4SOdBwu9wGjGspINTD/D9fEK5Rl/IovQzQme2
	Z7m4rUoZLbOlZLAcnxq8xPpshgXZEC4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rFyAWsFw;
	spf=pass (imf16.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772711805; a=rsa-sha256;
	cv=none;
	b=UBJLmoqythuR2+XcjNcPsGwpEOtKgbvMGvWaf0GpbOKfGoN+T1YoVtTFzM5tJfptJpvfA9
	fGHZfTN6yXFrraZ7v2RaUxSOAyTik6LsX6Ts/AXrRi0RkThMdlYj8ddqKFg1vG3ycCfgL4
	YEii0QgCfLlWftUtge9U6/fD9mRCs6U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772711803;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=evy5ffpxH1pOU6KU8S5DoExZmuc8IAjbV0oiS0M36hM=;
	b=rFyAWsFwp6ftMmtwWBjFPZuuy+ovo7+R0luaziVgpgjr5WTaq8+zWKMGUQzhQlZfUTq3Ek
	gEz5fQWKGv5h+FfKYvTOMlmL4usXczqwQMgmQxXj1wwI9eoEvsMGqEZREUbRjLpCLamjX1
	zhtW0Qi/5QgfqLC47w3RZu4F4drXcPI=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	yosry.ahmed@linux.dev,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chenridong@huaweicloud.com,
	mkoutny@suse.com,
	akpm@linux-foundation.org,
	hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com,
	lance.yang@linux.dev,
	bhe@redhat.com,
	usamaarif642@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v6 15/33] mm: memcontrol: prevent memory cgroup release in mem_cgroup_swap_full()
Date: Thu,  5 Mar 2026 19:52:33 +0800
Message-ID: <21d1abab7342615745ea4c18a88237335ab44d13.1772711148.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1772711148.git.zhengqi.arch@bytedance.com>
References: <cover.1772711148.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: fro7usx64fpmn47trz9qefzdo914h4pq
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 6B7D2180004
X-HE-Tag: 1772711805-758576
X-HE-Meta: U2FsdGVkX1/18KkqmKbmj4GdfUXzg/HXR1un5bU7vYg10MAWiBeZTHdFhgeXqmDslgrv855m8AW3ycMr0y89x059yYdsn2ACdoEQ4LLsoQm3sHO4sDWuz5503qglFD65s2fAUMKg1v/bdA4LibvO9pJh9RTxBIgeyQHpx1L4FUzjfjt8ZnwRMB6LKkpx6UF2NWF6tcTrhAc6TOkYSDKiyHyELTQVJxIB79pgME9LMLt1526gwDlLF0U/dA5H2GM+0MA1lBRlw01S+39aEZ8pjWafUK/KiXh6PlyvfvnTMZ1bNXh2iNMEJGlhcFW3hQxFNncrsaRv3s5E3uYV8ENgwSVnYT8tOT1r2QOxD0CN1HuG3fsZGxGYnPrAqc68Q/jZlPb/3O+1Wi1ovPfdrXXTBiWBuoDqYv2eYrxCzA3bDN8pIfMxjS5z/eg4A8zx/n1Mexu6sR9m0ci3a5PoDrdMS0Qh3Yz+/O6LytrWtp9JLudbW6yZWzqNv83V3Ak8w0jhucrpX5bD9B5wberVKJwAdi7Q2Ddtd5oOC79syzRPSpoThKoT0rR5aerQ60HaRWyeFHkK4cCRq7B+MQ0gPVsWzcgS3ZEAbfRLp6mHfIyCJUQHtiD/OsEUMmFe8OsBOihgjOp8baxMjQv/CodSlocltS0FCJp0owbgon/dMt/LLkBavROzy8w+BUTTWXlRf5QReDspYA8HaJh0gkXSdt6HoJxykc0nfW4MIQug5UP006jBEbCzer2ba825Rv8jKssC/U3CcpryWnxexgdYHm51S0teMG7vD58/HoGeLNashS6lCcdigVY5Zt7xuj2TR5anaVc2/P1TYBaUsHFBvm6yzN1dbUGcKOhWwgQtNoUzo9qVpVfoEd2/mGRLczUExpuQk5co8OkueJkP/Z2WJSf09YwiGKcnGKa6gtRfoa+DoOL99aFC3BVrGeBJAqvKSkYTpReH4BB/iNyBOwpG/no
 Ahy3GuTX
 kecW6UsonaisWhRfxJXSZLWSXob+j7dxRPRxbEocwm6Beo3bb9qkLNZ7VSSBLu5eqn062qdiitn383emCB1NwHI4Jomm2YaFxudGSP064Kp5ZDL3/xlhEXY2DurBrfb5JXlEM/GcTaSLXyuQ61e6EELciQzFEXWY7i4Jz6kGFadvPQ2TafinYReTek3Gg1EvuiZAslHgIejBfnrvyB3vFqlI5P79jHByQ3m1rC3xKgHeBGOa0mso/XuZwI9gsTNPi2Xh3sBr7Ingv8A8q8oNtQLRHFshuTGxJeeOdCDTxNllMJYY0VVRaip+usOdXIKQWxeXf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

In the near future, a folio will no longer pin its corresponding
memory cgroup. To ensure safety, it will only be appropriate to
hold the rcu read lock or acquire a reference to the memory cgroup
returned by folio_memcg(), thereby preventing it from being released.

In the current patch, the rcu read lock is employed to safeguard
against the release of the memory cgroup in mem_cgroup_swap_full().

This serves as a preparatory measure for the reparenting of the
LRU pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/memcontrol.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a4bb8b8b2c457..063fdfdd58223 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5345,27 +5345,29 @@ long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
 bool mem_cgroup_swap_full(struct folio *folio)
 {
 	struct mem_cgroup *memcg;
+	bool ret = false;
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 
 	if (vm_swap_full())
 		return true;
-	if (do_memsw_account())
-		return false;
+	if (do_memsw_account() || !folio_memcg_charged(folio))
+		return ret;
 
+	rcu_read_lock();
 	memcg = folio_memcg(folio);
-	if (!memcg)
-		return false;
-
 	for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg)) {
 		unsigned long usage = page_counter_read(&memcg->swap);
 
 		if (usage * 2 >= READ_ONCE(memcg->swap.high) ||
-		    usage * 2 >= READ_ONCE(memcg->swap.max))
-			return true;
+		    usage * 2 >= READ_ONCE(memcg->swap.max)) {
+			ret = true;
+			break;
+		}
 	}
+	rcu_read_unlock();
 
-	return false;
+	return ret;
 }
 
 static int __init setup_swap_account(char *s)
-- 
2.20.1


