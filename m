Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6E68EFD202
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 07:51:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21C8F6B00A8; Wed, 25 Feb 2026 02:51:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F4316B00AA; Wed, 25 Feb 2026 02:51:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FD606B00AB; Wed, 25 Feb 2026 02:51:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F1FB66B00A8
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:51:24 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B4FC2140292
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:51:24 +0000 (UTC)
X-FDA: 84482208888.16.99E4F39
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1A568100002
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:51:22 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wY9IBiMo;
	spf=pass (imf05.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772005883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s82tZFT3iNsr3WMx/4d8Ml9gjp1Ep9qgTy0gWjRVe+I=;
	b=pfR9TcS4kb5bzMxnwQK/2NExyCOyuq4e/OG9cCOfdPnvRJHiq4Mk3S1WEQeV+Hu604J6/N
	zRQHzwJIjZq4S26ZYbfFTDad6NSMccGt+MruPOvlR2m0ErXqtg/hvhBBnxackoc/Iy2JVM
	EOTcjniep8wVn9v4LUL9qVv+PvZBeSQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wY9IBiMo;
	spf=pass (imf05.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772005883; a=rsa-sha256;
	cv=none;
	b=Bqa865Q1YjnIpKR6Xdi65GfFTauZl2GgTnKchInT79JjHtXylcdVMUm8t6KcR4RDqczQKh
	4BpSI4GNG6t4hK93s+44rYswuXIsIfOhJCAY5fjUAVirlrybeZJsFj0+Jw6KCws3IRQdHT
	syR7iqPj/dZku6iJrymQTb9FRNnZD4A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772005881;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s82tZFT3iNsr3WMx/4d8Ml9gjp1Ep9qgTy0gWjRVe+I=;
	b=wY9IBiMoZ/N2UZ2mVT/o1emkOeCjoN17AdF3B8lY1yqa+nR696TLcFgsbRGcm+723kPcGO
	FNTYC2fzjNBUq5Z0otGjtCTnT9QhedUEN3FsysHjEbv39i34uyePTT3n5q61pDdTc8ParJ
	6ewY02J13bJIf6r6r88m1+9QWADbRas=
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
Subject: [PATCH v5 12/32] mm: page_io: prevent memory cgroup release in page_io module
Date: Wed, 25 Feb 2026 15:48:45 +0800
Message-ID: <7c3708358412fb02c482d0985feb5e9513a863ef.1772005110.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1772005110.git.zhengqi.arch@bytedance.com>
References: <cover.1772005110.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 3a4mou4oubpp4ane9uyq9mq6o8755u3o
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 1A568100002
X-HE-Tag: 1772005882-575851
X-HE-Meta: U2FsdGVkX1/dBp4UGYPEFNq18e9EJDA3VHxx3pCntLnwYuKGRyr8+BYrOP49KNdVhkdM9zdI/MuEqCnD97Zw4X01p9na3Tg/agD0CuFcnUaq5oRWDSEGSRhybV2BvEhdv97MfDONdud8ZJm0X816uNxJ7QVnwgoAn95kyPjHTJ+D76es4mXjccCsy5qL6H0wWwLUNxSMuEqfB+HhHsfFemHDI99+L7+PsjxLmzTRdFObf4GigFTVeR3VnDsIUbnbKebCOiJw8t9ROA5yE1Px8+2/ctalqh2NGOxhy3Cvxsa71IOFBuAbrgqlqZu5OzzCB6F/eo59P3i3dqCDJepeEqVzYp8X/TmrHtiyBQPBMhFXH1NR2DNr8f6QJg5uHU1KekowZWQnGNJdfnNIUompgLJ2ZCoMVvphyQeWnQRYsHz5BmM92i+nDHukkx9TaiF6n+AN0tOS5TVW4dh8hVyVpZQOC/yvD7+SQtkrXxZs23laPqqU9G5nnOPwkyGGKu1DPvs+Q82zOleP751rGhlEZG+JYkFAzzQJUXX/+Ykdzi2dl4YzPk77ouVmkM3KQKH/2/8Iuvd3RaU/vy6j+x2nb8yo3hqNQ8JHUXNKgwvvWWX0AJq4iiUT/+98FQXrp1wBLI3PlUE7ZXAU3N6Th/wsH8d62lka4xyzToRH3NHPm0eiv1U0hPgSlbFdSH2BScRELBfcVw554DUau+LPeUwWrHadO5e41CQsqfKcccL1yS8V2lCT/urstlV02JVNlKTZJ9GTB5eaGc88YQmeg4fUL8U6mUmFaRZViwR0/VC7vfoqSHCJYoo/xYc2ixHGGmCYSfJKABY7+umvkfr20Bhy8AjY2H4gOfSjQgm6sfFxWgIP9X8HOmWujB29z0mC2cYUcvjlPMPHYUmsVJhUsQMMhqm4dKF2nOF4DNVYLqfCOh381H9w+8lSVgoHV+W0f++o2FVATGp7SWZZ91gMtuI
 pYNtzs7m
 48WpionIMLqhvOXiq0D9mBGpUU02fSieS+CBnxYwxqayl69i6Bgi8H79rlPeHS0yeFANWNeddxQWHZ/9uj8vYLrScPRVO4t0SFEdwZFmtfpEC4tURhmpLyp4GJJ5diCOacHyyAIVcn2hYTecxWdkvoSzZ96jqJCoVLMHA0Vd0dmCdaUWCwsWkftZL2fmonxNCLxqRr2zrmCWl7SLIXhDUk8uoMyka4elUd9OoSakJdlXWXECbJ6NDmL1CVJrojSqxOute0ZIhhOM2AKAbTGQIvLvuntcWtrLE02jIg5xd6DGfr8eArD622KJuKCMl9/HyCQCf
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


