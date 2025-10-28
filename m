Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23CE1CCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 14:04:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E5CC8015E; Tue, 28 Oct 2025 10:04:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 794D18013F; Tue, 28 Oct 2025 10:04:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6839C8015E; Tue, 28 Oct 2025 10:04:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 532AA8013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 10:04:16 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 22C7613B110
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:04:16 +0000 (UTC)
X-FDA: 84047692512.05.C0BD168
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf07.hostedemail.com (Postfix) with ESMTP id 799D040008
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:04:14 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mQRNNpfr;
	spf=pass (imf07.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761660254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=awA3itBKj19H7/d+bEsq6yy17boeItLnhliB54mswXw=;
	b=b/S2shO30rlORx+P58/j8YPCA6lRiN0ZOsxWxPT6ucwg9W7nSEalxhTN36Bk33YuJ/9oAK
	FR5jLrdzRVM/Ne0pNY7BkZ2cFlcuJ4ltY5BmWavVr0Y4T1hhsVECV3uQY+WPc4N52XcrTz
	mTZD13876m4ycKUCwAAAUqScHNsJRU0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761660254; a=rsa-sha256;
	cv=none;
	b=aQdS7xDtUFQ+MWh1MdvfEvzwJ81ULNXZqq8gbrOxfc5HIHpWUT/CQrCKo2AKkdIiP8fS8c
	6EZJ7LJK8Dhjkl/rUtX9RIPHO7//oC9NMNcDIKYiay46Vgcfy3viy6ROy0NLmOtqyv15c+
	oOscpgQyxe18V4VtF1rPo1jINnnBbTU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mQRNNpfr;
	spf=pass (imf07.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761660252;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=awA3itBKj19H7/d+bEsq6yy17boeItLnhliB54mswXw=;
	b=mQRNNpfrKBpzz1ab1nTDgyCoguSHCTkk95shXK3iNipGI04oEMEXi5IIHEPqlqy+SEmRpM
	qyRZZQYqvRsB5YE+THqhsZdE833GfIrCf6qfwNtQCy481oRQtt+89LTqZmnI4GWpd8q08w
	S9hcQ/U+3SEnqwhb2eichfz//vZJxFk=
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
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v1 18/26] mm: zswap: prevent lruvec release in zswap_folio_swapin()
Date: Tue, 28 Oct 2025 21:58:31 +0800
Message-ID: <c85c86746a3103bac3657934a2655c1eb81ff290.1761658311.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1761658310.git.zhengqi.arch@bytedance.com>
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Stat-Signature: mz7rcpezprsfmuji5d7fzd4jk8gq9a4g
X-Rspam-User: 
X-Rspamd-Queue-Id: 799D040008
X-HE-Tag: 1761660254-760265
X-HE-Meta: U2FsdGVkX18+cGq8S/GD1vsDCsblERamxoXDejJufLOeo4LP4gmtSo8JquCOX2u3f4Nib2PTshh2Lb0xcpS9runnTA8+MnFddvRquHARaGKLcFvNjOEOGiIES18fioHTfJJLf/o1lISQnnxd1D6Z1iTCmZAVovi5O61stsdy/jAxhHOGc2sCrO4y2tqUUuQbgCMdgNiEiAk1244aAGO3XwbHT0yw6osJs6Q7wucAlhaUm9OumWjF+rt/j06HB1aYpuJFD4OM0V7IYPsraJmkCL9ygTgWxmY7wmbCQj3tFUYpIQZvsipgx+i1e/t4iB7+UHSTmdVMBKzChx6tU1LaXzLL3Sjg/Z5NzfoHlDXNVFOcROlEEUKEd+3p/SVaBsjab1n6d3csSQs1fO7swYptfRby2QBrwumJiNW8F5kPxd72LnuPzxJK5A+8nybLO0hBg2Y/9iraWoreIfvCFcyYhWWnY3xMfXfo59nx5LzYPxCV38UzKP3At4xT1MyjRHZJFoFieDCD0A6pMvIgz36mUyMwUiCG7XMeDEUKvOrg+s+o9aBaV4sOaU13TZiFCC17NSxF5ebGG88E7wrWdkq12yT4vF/G0HpnDIkXvACtfHlIPRlJeMfCo1o0Lew3ixmLIQVUvlQqu/znTpdczG3OZRqBZnGtuyTUUTyMOirwbvieSV/z4P9281OQegozxfByRjb2Dj2kOHAGMrvbSfjnlhSZkS41J1GFtMJ/LKEnN7xbqhLiAnXgGv6624cH5R6451JReaKD6crhUK9sBFqOsoCcUi0+QHefcVnRL0zedTayr0NLOy+g/o7rj2HjG2Jhdt56g3SukvpBjJ554OkpZ7RIelOX5jPW0M8uclSxlnTEU905IeaYrJTGbszsMt/1cHaS4aj7DeISDQQab8V2+f5IWIQ4UT7zsOBi3JENLUzLwWZdWWZjs21bM1hrG2WDPN+uJm7KMV+MJdblRYx
 5UTRFYPA
 KgRtPRMIjvlVwSfR7CKDHYc8PEXDnwSjvU4ZMXz0BMqlX3q9kRM65suIYeWYIxXyFqWr1sIy+cQ8rnGBpmaWBX2AecYKkmRKyDYRHJCCFdyQUVeU5uDXa7P2QDd9ys+V98GNpJP2PuGf7kk4yxM95f18eeCf3+RnmLP73wKpxQvk2WEKruANjfG+Bi6WpxzKZKq0+3yUSMN2ahkvdf9L/gEzwDA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

In the near future, a folio will no longer pin its corresponding
memory cgroup. So an lruvec returned by folio_lruvec() could be
released without the rcu read lock or a reference to its memory
cgroup.

In the current patch, the rcu read lock is employed to safeguard
against the release of the lruvec in zswap_folio_swapin().

This serves as a preparatory measure for the reparenting of the
LRU pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 mm/zswap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/zswap.c b/mm/zswap.c
index 5d0f8b13a958d..a341814468b95 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -664,8 +664,10 @@ void zswap_folio_swapin(struct folio *folio)
 	struct lruvec *lruvec;
 
 	if (folio) {
+		rcu_read_lock();
 		lruvec = folio_lruvec(folio);
 		atomic_long_inc(&lruvec->zswap_lruvec_state.nr_disk_swapins);
+		rcu_read_unlock();
 	}
 }
 
-- 
2.20.1


