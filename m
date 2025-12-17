Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEFE1D64085
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 07:32:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60BD86B0096; Wed, 17 Dec 2025 02:32:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B5CB6B009D; Wed, 17 Dec 2025 02:32:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DCB16B00AF; Wed, 17 Dec 2025 02:32:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3FCAC6B0096
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 02:32:54 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F3E00BBC20
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:32:53 +0000 (UTC)
X-FDA: 84228146226.18.112BC4D
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2119F180014
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:32:51 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=utjimqar;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765956772; a=rsa-sha256;
	cv=none;
	b=aibOSXTYoOcu4ehn1LYbtLfTTnJyxkDgz8LNWtnbCG/vnQPBzBSotCCc7fpze/+GMdFAUG
	WtNs32dx/91UrDSgu8lDLFHZyktiq8ouN5l2y4lHQqESJYPbdk+b9vINnhAj/Y0Nf9qgLJ
	EV70dJtuDJ/aF7yQ8/ehywmg8Nt9K+E=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=utjimqar;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765956772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r7R2YsecSy/bMyWfSR2fXTDFkSfi8ZmuktkAOmJUkaM=;
	b=caitP/bwyjgPLFs9NI1UCpB/dc2GRqqo+L/5LlCtOnygYoxdtoMisawdPhqk7zGb75uam9
	gVcxR3Yu+qDUVr26FQ8Fd+oyLu/RWBZt6fDgAqrzXR4QtdA2QyY8i8QMs7nZTsBUptSd4P
	VrJvwYhe19ogZdda7tFEWNvgIaQ2eF8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765956765;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r7R2YsecSy/bMyWfSR2fXTDFkSfi8ZmuktkAOmJUkaM=;
	b=utjimqarpJXzPTVvhid+eE3cwOsJ/hVXX6Fz447+S0Nrj5Mhr4vYtYMabOisntRkuyl9gg
	MQYGXnv6tjh2xy/Ve9Lmnbfr5XyjYeZXIoIuOKmxsE5zZxZmcG1tdfavDUQWt8ksYgQ4hQ
	Asqcc8Q9449fvBZaJ9EYLaptzYLE8rs=
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
Subject: [PATCH v2 19/28] mm: workingset: prevent lruvec release in workingset_refault()
Date: Wed, 17 Dec 2025 15:27:43 +0800
Message-ID: <1b6ad26b5199b8134de37506b669ad4e3c0b6356.1765956026.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1765956025.git.zhengqi.arch@bytedance.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2119F180014
X-Stat-Signature: 5eukjawz1xnqcnoc6r4g6xxr7qkcj366
X-HE-Tag: 1765956771-27459
X-HE-Meta: U2FsdGVkX1+h/P3O0Rlxy+hA4zKnsauaCesJLP7RmDwKwLkdmDUrDnRouUYOqCAPwPWO8J7ZFu7Mi/nkAQgDwG4XQzuOILU7jpogGblMw1IaWjuIJ5OF/Iiu5MiBUSpBHJbyPd3UyDW+6zzxmm2Bc/dJY2ttayxuZN3IZuQFa+yqmqc4xO4fcGn465jnGEZkQDNkQu2/e7vyHBWjydIMfhY6ZrwumSFVhq9CNqSf8OIIAXUd178wZe4TliKRI4olbNV0McaJi11ZUyJSuWz83mX6kRRshRP939A+ZjARA7h/sAuBlyPohaLdqFZsAiHSWz0EH4aEokEuN0DPbzCdud6RdMTmN3Wb5VjJKBS0z/MHtpAbOUChzoXxmVKuyU8LT04tmyxs1+dcVHFpELQhPqDY35zpSPayA2sh5M9wLItsvQ15WkiPC52oYsRVJkIPb3Tc7r8tmkRQyVU9HGHt7dkoF+p4iykhqYSIBU5P4QTn9C2Gf1TSyzE/wh4phyvBhm1DqvxAyvhSdJe1Jqay+32IYfTuAXVcPgmWi1TA+a2qUxmHxMeH9ymfcitwR8F8O/mKWTHtf2CmQ95oxXpp3eH/+1uDPDrl3nJL5bU85OV+iX6CrBAJDnszEyr282az3KdTdQUHWf0lZGkJzl9EQZylrEWFZ5Xh+2pQAXJWvsG0NZmXuFjxdW8qjklc55phEHU7sGtCB10px2VxbVSgv96GVVscnweXOePxJvzs5WITHCIorBnPQ7wfBxUNlc4GUpy/NwHVrD/y6CihpyvIj+5GVg2tZNdanSCmarzbkkjvH73l8lwLlii1zG2NfJuXWxvghmcVteKGttarQydNyVkEzMPsWcWJ2hF/MOdS5S/RqeuTGFcSMn9kRx9rCyI+OCnSORWM3Wv5VtnOn/A/GJXtkQCH2EPThXtmcuUGAvN1PxHGn4x52YDRFG30LN+yqKYb01gHlZ1gSN8c+aq
 bTHXSsgF
 xkv0IE/1/z6iHkz9ceETNhg1vhPkZlwKYlxGoCs/7k6GBPcxGeYS9qwmTq6rsFeYy5SAw8OfCJJbxbQ5x5oAec/WVcfBjpyyjLCKKNA2k8yKh3g7+3MyNlCiwf6xuXGZsNSw/Mzanyau2O4c6U1OZmbLh4Ran4lVbFMN6U4ocHOoo8oNjvJARuyaoIhWesEn8CgCeESLkhVJInhPyaRoiDcl+r4xnYrs/eT+BMTSXHEIK7uAQSZxpIX9A35qWBmaKsSzR
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
against the release of the lruvec in workingset_refault().

This serves as a preparatory measure for the reparenting of the
LRU pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
---
 mm/workingset.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/workingset.c b/mm/workingset.c
index 445fc634196d8..427ca1a5625e8 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -560,11 +560,12 @@ void workingset_refault(struct folio *folio, void *shadow)
 	 * locked to guarantee folio_memcg() stability throughout.
 	 */
 	nr = folio_nr_pages(folio);
+	rcu_read_lock();
 	lruvec = folio_lruvec(folio);
 	mod_lruvec_state(lruvec, WORKINGSET_REFAULT_BASE + file, nr);
 
 	if (!workingset_test_recent(shadow, file, &workingset, true))
-		return;
+		goto out;
 
 	folio_set_active(folio);
 	workingset_age_nonresident(lruvec, nr);
@@ -580,6 +581,8 @@ void workingset_refault(struct folio *folio, void *shadow)
 		lru_note_cost_refault(folio);
 		mod_lruvec_state(lruvec, WORKINGSET_RESTORE_BASE + file, nr);
 	}
+out:
+	rcu_read_unlock();
 }
 
 /**
-- 
2.20.1


