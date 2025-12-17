Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DD05D64087
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 07:33:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E64856B009D; Wed, 17 Dec 2025 02:33:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3EE26B00AF; Wed, 17 Dec 2025 02:33:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6B7B6B00B1; Wed, 17 Dec 2025 02:33:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C5B076B009D
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 02:33:05 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 849A15B85B
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:33:05 +0000 (UTC)
X-FDA: 84228146730.10.96B3082
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf06.hostedemail.com (Postfix) with ESMTP id D44A918000E
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:33:03 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qss7+xs4;
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765956784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3hCVtkwWInjeWp1lZK86oR9Lr8eWsGStrPfk/NkSL0k=;
	b=ZKUpPzDG3JydsfQQh8K0pq/nAz7fXSj1u9q3rsTC4LdydBdjQUTGdCHzNCk+oz3cov5QkJ
	HlKgkKrqYRPWxeI4b9vIGQiXOg+A9nyk7so94hyZzkYea2CHAIcmLWTIoM86r8RMuS+t47
	UcCIfs+6btFCo8Seef48jRx05owqQlU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qss7+xs4;
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765956784; a=rsa-sha256;
	cv=none;
	b=E47MhH3p56aVwRDuVi3RJjR4RUMyJWz3x1m+VZLiXAJRSfBoxid624Vq0hhYMmdWuj11OP
	1MAnxPMaoMxiC4yoP35yoHmPep5ZoZ61C/G11MsxON0OelGzhLrvy+LIJyAYamMefyHae3
	V6xATnfBTAPuJw58a3r6xQBml9e5qBU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765956778;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3hCVtkwWInjeWp1lZK86oR9Lr8eWsGStrPfk/NkSL0k=;
	b=qss7+xs4+fcC/k4TRH856pLkCsZ3zf6NmhCCKBEDP94wPzgJX5Se5bzxYs1nQvCcPAFf1H
	IUyFBywc0v7UZh6JX+MCryCQnvJm9NcBRnkhxr55rLWMPZBrpBYI7A4pbR3nSLhuCbDRTI
	7cQwLAFU/zWeAVJrioGetOwSuqdGWIE=
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
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v2 20/28] mm: zswap: prevent lruvec release in zswap_folio_swapin()
Date: Wed, 17 Dec 2025 15:27:44 +0800
Message-ID: <bd929a89469bff4f1f77dbe6508b06e386b73595.1765956026.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1765956025.git.zhengqi.arch@bytedance.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: drhuw7x5qocc8ixdopmi6zn3xo3aitbn
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D44A918000E
X-HE-Tag: 1765956783-731161
X-HE-Meta: U2FsdGVkX1/N/epThdTD6wlU1byLhCuX5GiXW8U6HNxZtM8WyqrygYV2c0fmJwduRmBNGIYGo/GRqQfMFBcBb5w4ns/L9J/7rqm5T/Q+Fs3glgIUIv5MdABmIzChZwI7SWlfCIl8mycs+rfAOMN5b1nThDgSp/onNknn3WVZb7t1EU4FtqVn0MvptNqFL6WxiIDar6/hcu+dOB0IuqPlMdxpo9zw/qxwr16fIxqJHOCCIeBXFZlMQs6j3XmCIzI4OvzuOD/S0tfcdKAKOdwRjzZX3osiZ/6rl7mVkuknLVQFHMJo1wYDdRNzW/2sf6NQ11KHyE9vCnUWzdvs6NIvS560j+CXQk/MUuFNn2HjMaYCsqknxf1qr3WuLXMBFSFbuVOes1r1ZS5iFmR4qKsm3eV5LGUcBJXvs3aLr53gNNY9HsduyJ/U63iaRvBrd8+6CpG3DVeaRvakkfKInXdWcziY+RspvMJi8QIhHNmrlaO4DiH80jpOIiFQmcodVrWhkT40TnBch47Ug8kfrtRCaweC5E6Wo/w+rApOuIEo33uCAs7JpUvgCyqLdI85xXRWorTGymUdsp4vZLX5dQzjYBTn305LtF1Hhc/OjQKWYkwvlZXGyeXJ/whyGCsy0H8p8oc7nA4v77aIlfv+UV72c1FjvFRp9vL02ooS70skSQegNk5y/UqvFiIZNLUmLBOWz10MUfRSzuPfOTzW897cy5Pn1IT5VWVf7mEjvLCbMXCWNS/iEh7pHc2ETd2SZkG84PQNS2aVJ3nTTfac9oAcSuJEPqamgaDqlvckJ133hsjD04bfp6vTuoPnxohm+7Kfgc1kogiwUGYKiHwPKiKFLHilVCvAmUR5vvcx/wE0knxZndhNoojn0DqoLLqZWS6v/Bk/QbwHbsKArGGWuDbhC5TCy0DPyK+w4dNpsg+3UsUDiSHAIjGu/Uy9FV8YbG3YF6nIs1i9D5zVg9hFqCw
 H5tneFxy
 R8Kyta/Xrdm4oGqH0Dq2im8Psd1mIcRbw6dh/kgGeKknrn5/ryd0/pyl2hn1S+oYDzRKiaNU6amWPj8P1BWC0BHUFQ4PN8twgQR+hcMnyya+fAJycdJRsQnaOXRIqEp3ARFIQfVzCJd+2bNY7+9sRyKoS7K3uwY4Q4SRcbb9V3xwI5y7qQJ1GC2cd8VIT3vWhHeZFAS1OIbJqEGaC72+12S6OcQUSRu68F1PeVuW5voqOioOKOCCWK6PerCxxv6sQcvzROugU3D3YfCE5D1eCsbnlig==
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
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
---
 mm/zswap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/zswap.c b/mm/zswap.c
index b468046a90754..738d914e53549 100644
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


