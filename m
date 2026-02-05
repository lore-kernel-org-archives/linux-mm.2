Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBB6AE91297
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 09:02:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E3DD6B00A7; Thu,  5 Feb 2026 04:02:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 391976B00A8; Thu,  5 Feb 2026 04:02:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29B056B00A9; Thu,  5 Feb 2026 04:02:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0F9C46B00A7
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 04:02:50 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B59C958A26
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 09:02:49 +0000 (UTC)
X-FDA: 84409812858.21.A6BAB02
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf01.hostedemail.com (Postfix) with ESMTP id F167340006
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 09:02:47 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=erBLz1He;
	spf=pass (imf01.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770282168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s82tZFT3iNsr3WMx/4d8Ml9gjp1Ep9qgTy0gWjRVe+I=;
	b=IOi+V9LyT/1CZGTIV2A2h8dDIR737cICRGaWqsLu0er6HIMXifHhneF1d3rqqIniAGPHg+
	8uzDDvRkUIrzKYOXH6zpm0TvSjzk/ID4ZczWhcyIuZX33B/hL0Gxa1MGN+6YaspfL/zv/Q
	QrGmEa0SU2joVKg9DXBFF4zD2dCZAKo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=erBLz1He;
	spf=pass (imf01.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770282168; a=rsa-sha256;
	cv=none;
	b=M1q1Ce0Vq9eZiE7WV29FpPFZdtajN1IiNOxZzPeLO2Y2KsAThRylZ9Nbus9MyrV25uDfFs
	BSK00q6+1V8VlPGnfcX6+4pwRIDIt0VU5dm1iGsWCuMQGkqqD2Lnoc3/L5AcIM0+rh4wa7
	o8LGqmWGzm2UKXRrTqvH3DUr5eDu8G0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770282166;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s82tZFT3iNsr3WMx/4d8Ml9gjp1Ep9qgTy0gWjRVe+I=;
	b=erBLz1HeMegVFPPeha110SLblcBQhIgpCtxuFzHpIUTarxrMbF2odGtdfOwJ7O3DtbThau
	so8xMWG1irDvelZ5WFNSdLACWsOf/8Xsm6H1P34+UBbWJANSbel3BxkbmFEJhoQCMAB/kR
	EZAHSX9B9Vo5PMYVabTHIS/NUzaQiNk=
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
	bhe@redhat.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v4 12/31] mm: page_io: prevent memory cgroup release in page_io module
Date: Thu,  5 Feb 2026 17:01:31 +0800
Message-ID: <28e046370ee364658799704b40d06d3cae8dbfeb.1770279888.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1770279888.git.zhengqi.arch@bytedance.com>
References: <cover.1770279888.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F167340006
X-Stat-Signature: 55s3zkaffb6gjj9eoiai8x6585qcofi6
X-Rspam-User: 
X-HE-Tag: 1770282167-239594
X-HE-Meta: U2FsdGVkX1+4D9I/eE4Y1MI9GT2h/yEYcXMeqo9nQnerqzFEBf3WIklcYd3UteX7ZkKlf+CCt3LxIUdNAI6zhPmFpt2+pxHb/+JTMijSP5qtT+Vmf9P61GsPCzOv5phaaOc4I0p22uexn1vC/1qxShp2OqIrgivirQEe0wjEFchmpfOzzbUG8/ZzxwBg/aExscp1Os6RuEHKWMIFtrs2iuKyub+UBwLM17UBwQVd4nUGgwr65L7t3fpkdKjEjbZZWVFwVqYxT9gTe5np2e+4FOlD5/iG2Cr0rDob4SRdxpgsvcOTRc+2QPuiqgzAVKN0h12WCjjVcdHgnSmwIUqBPVY+9EjaaOl28XERy67KSPBkKsF92uOqI6XkVw905ng+MVHbhLfsE/70ueFPn13WwQ0KgLSayMAzmv7PHCkYk1V7Xor60XSEG0mjcv1beGJujCGiHOKDJ7lK745vaMPvQE2loIdUNBzd3rPl2YCxD/PJnJHkUYPmsHNLRJibnfJKRjALNEJAYfZ9kco6WFKtIs7/Gv/ArrMKCnXVpLNAloAsO7sa7ACqO0szwKbjycYmv5vwb7E4HY4esY91iSPvIPrBNtsSsf+z/x+c/80i0Bgr82T00xwtIVA/RYObMG0WRw9NMA/zt1njCmQeHqmkmALPU9nbDFvfhDQSDgWgm3xuLbrzvHHTdA95nYZpL6GYg0MO++CcrlF29E6+2H729YIiUQXmITWXaVVaWv4PhP5YiZwwDsHpo0lQcOKn6AesZhHkCtPAsGz1ZbqHH1Hza88GZuEI1swfDMNBxckNiCi+dfzkBQ1IQR4pqCzYIbEzel/F1iJ1KB0790xP6xFkxnBrtYKgWPLjncYIhr/DwjlITB4bxvwGWoyp8OKDxx8vnZLWRpZF0B1jw8lfjIS1speUdCqnUNHyxYDq+oXLK95qN/Yzv52zRrntSXTa9RbplOx7pkUC0YpUVMLxck0
 TiuIz/Yu
 vS5vuIhdXjI5lqjKJZ4QX1xzwHTn9cOCJZZpDBBIQD2BgyoaaWvad8WCT3ZfM7nTbbn1XFoK2McNqVOQSQgjaXwpenbumFEXFhuA666gJtfZdPc1ppaPEBdB97jTB1eej9gUtLYGEfdqMCPqklFCMi7zi81bVd4kPxqBdeae7IDyDi+7jIfAe8HOhT7bT+zgF1KpmdbnNYI4cfeh2e7IcDRJp+a55MdxY4KfX6J0xJL8J/jLkDOQmJpRHBQhZUY+9dfPpf+33PL2y6CsTMPzB1NP0nOgawJyvECZ0cjed6M//fDHKf/tgTCLL0g==
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
against the release of the memory cgroup in swap_writeout() and
bio_associate_blkg_from_page().

This serves as a preparatory measure for the reparenting of the
LRU pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/page_io.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index a2c034660c805..63b262f4c5a9b 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -276,10 +276,14 @@ int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug)
 		count_mthp_stat(folio_order(folio), MTHP_STAT_ZSWPOUT);
 		goto out_unlock;
 	}
+
+	rcu_read_lock();
 	if (!mem_cgroup_zswap_writeback_enabled(folio_memcg(folio))) {
+		rcu_read_unlock();
 		folio_mark_dirty(folio);
 		return AOP_WRITEPAGE_ACTIVATE;
 	}
+	rcu_read_unlock();
 
 	__swap_writepage(folio, swap_plug);
 	return 0;
@@ -307,11 +311,11 @@ static void bio_associate_blkg_from_page(struct bio *bio, struct folio *folio)
 	struct cgroup_subsys_state *css;
 	struct mem_cgroup *memcg;
 
-	memcg = folio_memcg(folio);
-	if (!memcg)
+	if (!folio_memcg_charged(folio))
 		return;
 
 	rcu_read_lock();
+	memcg = folio_memcg(folio);
 	css = cgroup_e_css(memcg->css.cgroup, &io_cgrp_subsys);
 	bio_associate_blkg_from_css(bio, css);
 	rcu_read_unlock();
-- 
2.20.1


