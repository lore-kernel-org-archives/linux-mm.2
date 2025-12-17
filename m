Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05DBBD64085
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 07:32:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68FF46B00A9; Wed, 17 Dec 2025 02:32:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 678266B00AB; Wed, 17 Dec 2025 02:32:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 591296B00AC; Wed, 17 Dec 2025 02:32:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 46EA66B00A9
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 02:32:00 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 12CBF136CC3
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:32:00 +0000 (UTC)
X-FDA: 84228144000.05.66CCE12
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf16.hostedemail.com (Postfix) with ESMTP id 61699180004
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:31:58 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=soa+opLi;
	spf=pass (imf16.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765956718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V4K7YSAAoMX3+MZNm3D3u3VukDVTNTfZTJaO+WTfHwU=;
	b=0fpNAe4JlfRGfAMiXrynfUrLa+JA0NXU0W0EuyCVXVGne3wnYmTBrXxod4QRElZzmL1cr1
	ET/+p7OFtV83ctCDmvn8kiD+N7sQSDW9lxWDfDmja4WnfEZr3KQCppq0X5Nu9FmcEGmWCU
	rqH8YMxp7449HAuY9DUZnRTSApi2JtA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=soa+opLi;
	spf=pass (imf16.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765956718; a=rsa-sha256;
	cv=none;
	b=joi4hOCXRmin9ujBLwE46N42Ax42WGdrEPCTPYaox9Lh3SGYF1FU+9QbjiWRo7DGz85Z1y
	3uhsnqmKPSeadowldaqMeBvBKDUWzuAhuufvGu9IH3NW6SruekYQcDeOvvEJBhyZUKpFU9
	r7MDi6hb7i5OSBG8ueDcCOP/78ybtks=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765956711;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V4K7YSAAoMX3+MZNm3D3u3VukDVTNTfZTJaO+WTfHwU=;
	b=soa+opLiHzhlpOkib/c47niPkRmdgYD8ywE7qI/ViG3fYKxPr3bMPex+1o4kW9a9f4HlRa
	2oFTuBu1qByHbwxK1c+5vo0S2/VfJbGBb7/DRCsw0TO+bIx2hsf0PZnxhl0CabMJ40pyLE
	U5+XoS3KoIKWlGB4LdX/NaW8KUaFXI0=
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
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v2 15/28] mm: memcontrol: prevent memory cgroup release in mem_cgroup_swap_full()
Date: Wed, 17 Dec 2025 15:27:39 +0800
Message-ID: <4dd1fb48ef4367e0932dbe7265d876bd95880808.1765956025.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1765956025.git.zhengqi.arch@bytedance.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 61699180004
X-Stat-Signature: m4nytnc5ng44ia63jiqmua8ixaxo3pxz
X-Rspam-User: 
X-HE-Tag: 1765956718-656953
X-HE-Meta: U2FsdGVkX1/G9feWIivvdR9k+IyEw1hTFGPq6D/xiD7HmB/ckD9HFw5zD/A20yfvVANrLceLNdVskiTSkfhzFPyqC9jNq5rOz4wDgjHQqx3PMw1O0pcpC825nFT1UCQU7XoAW0YscxvRCNMv20nEjVPm2/uAnmVRCKfNB0vD0qVIU8hUkcwy1dRAxouzAuZjMHmqWtJomEZpApwFOi6nGPJxkN1QBjMIgIrTkg79PJ38wHHAgRH0H+3KsNMbCtuQl0z7XpXRvfJLgMVrexWIz0LT/0Oh6Up9q+88iMi2MfU2PHDmYac54c+9t7czuN3MoPeYVp9AhCbrKJgjRcQyPvtr5il3KxwfzPEzx8SMMAaoERkOwn7QXvP3Eah74YySQf/EcQ5e10DyTvDxbERFYHSmPQp6tTCSeD2YrXIv3EIumB2pHIgtj6OjPQisuVA4aaJCJU92zxLZy0kZDuq0hP2brOkc2wNLFDZ9NezGJ5D6qm4NIdjUnTVnTrV8efkeGJ3fNEtl5pQAUV1D1fLdC912euR2sm4vdNdeJrJF1eWFQCkZdNsIzTZjPGLLevfUnGFAUSki//C9dwMYmcjfclbuE+JNpCX4T0+tp1DpEy638wdkn8KcsDfOxkVp757BdK6WArOSYTMMMytxU2D/9+ppXzCpvcNoEy2QLhutxMEnq3TComktc8CBwt8gC1hIEYMNoM3dWhkcYLew53dD3rd9ImEkKYCRJn1P5S6onJ0XyXJumGdx9Xj/8Gm5jUJxHSmBK/DWpt168bigSgNqRhVXJG9MSKFtuYkoZAwbbmcEBwjQBGZBIPZSdMsYD78oj8Tv6ggmVV4mWmM9drempUwqkh5LoaIp2j58HWFjaAfimvq7UXIithT8SaiP8adLcHFfn7LAiOC4WJ2AE8B+caayOuda5WcUbphECzIFQ0yam3eHrMDEUqH9IGZkqga9vaz+5IeEuFQ4s4N/3Pv
 f2A4CsH5
 i35a991P3W2CKYZ3P08xcdJpkrYfWOK8zqV1I6mm6onLsj7mi7E1gP1C/Z0DcJO1dBb/bVpVKqskPLNPGILP6jGIpkgjD5rVSQBVt8z9ghGnRiWTWhDAygOGposSY46CH6R66GHhRQDwqd9rKwNgUZOcjXlUBimKBsh41NbMl/HgCxjzyRIwirJUgOFlxGRphT+LCZhOG129JxZuaxVPvrIyaCb1FZyxBwVQGkc60s39dUr2IM6V61pOH37xCX+ms7X0s
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
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
---
 mm/memcontrol.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 131f940c03fa0..f2c891c1f49d5 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5267,17 +5267,21 @@ bool mem_cgroup_swap_full(struct folio *folio)
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


