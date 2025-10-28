Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3C60CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 14:03:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D5DD8015A; Tue, 28 Oct 2025 10:03:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45F158013F; Tue, 28 Oct 2025 10:03:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 327008015A; Tue, 28 Oct 2025 10:03:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1A0108013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 10:03:49 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D410516049E
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:03:48 +0000 (UTC)
X-FDA: 84047691336.30.C7C5A6C
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf09.hostedemail.com (Postfix) with ESMTP id 19E75140023
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:03:46 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MfRN3t19;
	spf=pass (imf09.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761660227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F4kFK5BJ7jqgsuSDiSoEfAf9VHgtSpfSrzUfS3UnF3Y=;
	b=Wzm0IYgPPzwqeMZUT42ndHixeq7uNDKPYLmImgwI1cAARGPTpntYlhDqDPzvu9mE+zt8Dj
	rteOqqQ7KpxhnQhNpOc2uBS84qctpiFPfLLd1cZoygRusu6/LRkubMT6HyrPmTOB9ge19k
	IW9sQfX1+HM02X2vmJcDTZW81nGM4bQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761660227; a=rsa-sha256;
	cv=none;
	b=euwN2qGXLeyGkbccZWa03qsmWirH5sdIBLxKdOh4aLeJldzM0OvTSMF474OLFYB6wDIzGu
	KKlYTAs+l0wddunhFyFB9rQiYsWbwectyG1eh+d2dAeQbP68WaMP3OxvSaAYyI+ctvkpCm
	CVd9rMUKVvH3IfUmLEIkm+yvfZvelC8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MfRN3t19;
	spf=pass (imf09.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761660225;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F4kFK5BJ7jqgsuSDiSoEfAf9VHgtSpfSrzUfS3UnF3Y=;
	b=MfRN3t19XYpdxb4wcQVFPd3/mu0+cZ9GQ7ccvIU9cBaG4F2YOqrqyvYKeVRMsZKhWRNqj7
	eZDaToOPOy6Fi94Ky9Hi3X1Abh0FGtpGNvKor+IdkbwbYytdVygxKfFANTcCJ8v46nZnuG
	nroMiEABUxj0K9UP7lCdMidgPxFPqE0=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v1 14/26] mm: memcontrol: prevent memory cgroup release in mem_cgroup_swap_full()
Date: Tue, 28 Oct 2025 21:58:27 +0800
Message-ID: <1593e9efc2de666e9f7e7659d5c61d2ccdd17a8d.1761658310.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1761658310.git.zhengqi.arch@bytedance.com>
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Stat-Signature: pxnmu3oof84newb3qzr5me3zqk6wnckd
X-Rspam-User: 
X-Rspamd-Queue-Id: 19E75140023
X-HE-Tag: 1761660226-329781
X-HE-Meta: U2FsdGVkX1/a9eTVRxdX5/lKsKC3YOIeNIfuxy+riPcFUBF7D6iRTWaloRVee2W6+zkeD3Ve0kZXIWCmMiCaDNnI/OKf4EkAAXkBc45EhAu8CGo3yY+19V2N+QcjJVi16fED6KobJDn3KJBcXhUf3dxV3abzZ9kxI2vqn1h63Fp1bfjYLbpWr86DlAQH/QQgxXnUScILNapU4HoZAC/JypcZQpq3rt1ivvW/vORreSBELf8AqsPsbpOcKFlj0YeP76dsH9wqVEyfoWg0GkUuFR/NEOWJOAu9k22va7qizYjKz4XVYBzcWgJTKFHYMoMn/m7p1s294mb9dCUFo50Ygd1UMBWFIVpjqeXLxj7cPiS2WwwS/e+EFINjpI7N3Ngm0hM9LUu/wcaAQNnzVAwJRVe3h/ICbQ61oRPXEZgKytoB8egRBXxU6h77C74CDKGuoGa2f/aJ9OWBKVO5zAcSuWu+lyMJ05U0GEvVruAs15aV4wvFtOKwxz17W7MJjiqBUC7ToiCr/vHVlpT4G+OAo5Qh4xbjp/QQ/eaKvMg2lZgtAe7aUTYWCfb0pPD6swH4SOD90vlTes89NAMnri6Y8P9AkQQYzruqrZOqbvELSi/8RgU97UuQIY7Dy5AJHJ5GZPtH+vsVypWI1Y4DUiM6hlZHqFK3CMmobKrbsNBNgRv4c/NaBAgU2xahTNhRsXKxB6FRSSFCBNWqz/75WmPoPpe8Cq2tn2V9bXvIV655EP6MuTP5/94H92FSTwK1tfdVhTVx435JbJDv2ztmXQp6ZkeMbYcIVhwrt5hX2N++NM3FQQ0IKiF6V77hWn9aVJ7q58hhm6hRUv7ZDrlyX5LsY2tXF9ilsTMRh5fqTOM/C2cuwrth0zRJEI1gOt9UIMaDn3Ev2r8JzorAaX7NHxTlMsFuHiyOXxJdVyCObGGwX1hghC4ateHDIu/SV7Y3KVBhQwlDWyqMaKPkBOydEOU
 Xsjkl6jI
 ibACFAEABexaWiQ0SUCkedcvgd1VWLjy8OEXLbYCTf8DDVe3i3Fe8+SqlUUIBmJ7kzL+tXlh8YE89aTDaoOazlRK2n8W1Ig4BYPtavCrbkCyjeoNhVzzjXMAF6OQZggDVkYKJ17HE1FpG3nKnmdhPKE+k2spmWmTkbsZHTwkznpPbdBbTI7VWVRSkAFtUsDmD3YbWuPrR9BpVZO8rHbum8nmInZY1vDE6GtkJeGqWbg8Q7jrgxkLYfeSQSWlQYw3IS4BuBc1ShkK1CxY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
---
 mm/memcontrol.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index aa8945c4ee383..4b3c7d4f346b5 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5275,17 +5275,21 @@ bool mem_cgroup_swap_full(struct folio *folio)
 	if (do_memsw_account())
 		return false;
 
-	memcg = folio_memcg(folio);
-	if (!memcg)
+	if (!folio_memcg_charged(folio))
 		return false;
 
+	rcu_read_lock();
+	memcg = folio_memcg(folio);
 	for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg)) {
 		unsigned long usage = page_counter_read(&memcg->swap);
 
 		if (usage * 2 >= READ_ONCE(memcg->swap.high) ||
-		    usage * 2 >= READ_ONCE(memcg->swap.max))
+		    usage * 2 >= READ_ONCE(memcg->swap.max)) {
+			rcu_read_unlock();
 			return true;
+		}
 	}
+	rcu_read_unlock();
 
 	return false;
 }
-- 
2.20.1


