Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53830F30951
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 11:57:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA5276B00B5; Thu,  5 Mar 2026 06:57:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B79F16B00B7; Thu,  5 Mar 2026 06:57:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A93006B00B8; Thu,  5 Mar 2026 06:57:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 98FF16B00B5
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 06:57:20 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6198B1CE20
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:57:20 +0000 (UTC)
X-FDA: 84511859040.06.DF95DB6
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf28.hostedemail.com (Postfix) with ESMTP id BC03BC0006
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:57:18 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=s3v1iK8W;
	spf=pass (imf28.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772711838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MuGdh3NsMuiZscvyzRC4/MBSUBTvm1soytMKG+347XA=;
	b=cGiFAlhMRUgY0uxaQolF1E1OmELdzyig1Qm3r3DlN+gyr/6qcBQOGIXeRPRGtyI0cyUO6x
	iCMrQr5LCauJPdfediuSK7tAwh5ZUdEYMA/VIIg7A29vY2YFLBTAWSZugoKoPHmfoXDrCV
	fa0/AurSVA/z3nJrf0Ngk61JhyjR0HY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772711838; a=rsa-sha256;
	cv=none;
	b=vaDukQjqddTXIIktXpmVkBCbXpLbvpbk1cST+8fp3wSm01Fo3Rz8k4WjJftZ5JIjaZJWlw
	4hejEl7XVJJvNMNGT4HZqFzO7YiOMk4pir/JK5Ivr5vKhti31dQ7KDv/cWPGs1Fad1cs80
	NxCzIirq7P5Xb/y/4sK0bMXV/kUI0So=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=s3v1iK8W;
	spf=pass (imf28.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772711836;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MuGdh3NsMuiZscvyzRC4/MBSUBTvm1soytMKG+347XA=;
	b=s3v1iK8W+2/lyiTlyMS3zxFj3WgIlRYhe5H+s0QFT0llX2t+stJ7v/BZUrvc7S0Nhlw+EV
	9IpuZYgKVcG3RvQ0aect08xUayoWd8gLAKDQoOHod9upjfloUsBuJAYVVXJw8cV/URSRVE
	pdfe0Qfpo6AHi0UluFFEJceymQL/VzM=
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
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v6 18/33] mm: zswap: prevent memory cgroup release in zswap_compress()
Date: Thu,  5 Mar 2026 19:52:36 +0800
Message-ID: <340f315050fb8a67caaf01b4836d4f38a41cf1a8.1772711148.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1772711148.git.zhengqi.arch@bytedance.com>
References: <cover.1772711148.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BC03BC0006
X-Stat-Signature: mdcrzn67zxia8w8jbfydbbjtc1pj8fpw
X-Rspam-User: 
X-HE-Tag: 1772711838-734143
X-HE-Meta: U2FsdGVkX1+0aXxe6bsXtIp1fEyrsUCh/oE09DCHhK/b0+jmOoZs009PdeZNDFxqBWDzxbH3w58IRlw1d2V/zeUKX6xg9H48Y0sIxRQiNpCs/3jHIajAmZCDeAEbeedMhb9JLrIpe0mnme8q+wU0qUvSksaOTcw6B1JTba+1xdHFWbVX27LW/wF4lpPM3ZwZXHRCkVVkllmmdAyZ/1tbI1zNFyrhcqps2DDp6j/5z8qqAvsZQ/6p4pT2FR29/iJTCWCuM2Ds1gcy6ZErtcyJ5xqjyjMIYEqqoKeVrY63lxpIQENatdDe4m8sryvNDi4CwHw8HAR2gNGxw1EJ6Af7hocb3p81I1gVceawYJ/hHvG5Kk23sFnWbQ0c+QaT4zvaHO+0xYLLDxiUJDIATGELmzhNT0OfoBbJ9qsE1kBnK94ZVqTCC+TPydsZ9QVTnrAkgDw1YKUtLmcg1z/fv9DqPVRjWA2690UF0MVB66Gqj+DBSOJojnreMFngeJrHDYxhNklddSFK/TKV5WUvXev82+fajLlhL+YbFCtB7wzG2ZPsAe5n10midBpwjZCLLX4XtchcuYKfp/sK22MyMrvcPygImtevOnjfYrVr+Fk0j91oyFUH8d9rFqmoe8R4WWz9YnWp/6NPq5+o5SWVeqMFO27gp7GfFWDIGOCUqMFN9tIKRbfIOJEQy0rKGCGScpxi5z/9Jml+IHhCDF7tzHKpRsG70xu/ru57R4lHAYxu5JYpQiXkf846/FKK082dFnN8aG+7c38a1lsFlgZXXn1WAkqxVTtdGlR1rItiy4qV0E6WF2QNm7HVvQcrpUtaSL3TdkZHr/I33O6mtd8GqXZR1QAffvhjYGWgwCxdJigyzPDz5nY/cwb3CHYRjFf2dSHPaXU+i0hdmTB87lyYmlSgE5O6aRHx/BeM/XfHqAVhslVBQO/db/r8kmo7qH95AvtsQpJ2a8j5uNMS0/UVJ/S
 /vMJezvt
 VrsjMtGBtpx6UxqnpsxxWuh9ECOmHAm2el7JP+UnYJ+mbwpUJ3EaiAln6/ysH6hbSEMUB1BnU5owy3dRlSy045xltT+r+hcuS+teH3viqSu0XyVjmSEM1wjasKb1LqB6YUnIG2zGOh3dOkIMl7JVnPgd00ZHeari0pYKh3c1P3F/DcQapwwpccagNlN2jQt7CiKyp5sjvOtVEc78SoJ5LrIMNFt9yAeE7WS9NXjVMafiUPIPYujIsrPk2GKCCugaKhVajC7QgeVbjDdFZIy0DKnnrvbIv1utl9CnROa6tliSKnsClc9eOd5dKPcPslyAclH2x
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

In the near future, a folio will no longer pin its corresponding memory
cgroup. To ensure safety, it will only be appropriate to hold the rcu read
lock or acquire a reference to the memory cgroup returned by
folio_memcg(), thereby preventing it from being released.

In the current patch, the rcu read lock is employed to safeguard against
the release of the memory cgroup in zswap_compress().

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
---
 mm/zswap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/zswap.c b/mm/zswap.c
index a399f7a108304..fb525874a1b6b 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -893,11 +893,14 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	 * to the active LRU list in the case.
 	 */
 	if (comp_ret || !dlen || dlen >= PAGE_SIZE) {
+		rcu_read_lock();
 		if (!mem_cgroup_zswap_writeback_enabled(
 					folio_memcg(page_folio(page)))) {
+			rcu_read_unlock();
 			comp_ret = comp_ret ? comp_ret : -EINVAL;
 			goto unlock;
 		}
+		rcu_read_unlock();
 		comp_ret = 0;
 		dlen = PAGE_SIZE;
 		dst = kmap_local_page(page);
-- 
2.20.1


