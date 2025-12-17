Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14FDAD64087
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 07:32:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7950C6B00AD; Wed, 17 Dec 2025 02:32:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73EBB6B00AF; Wed, 17 Dec 2025 02:32:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66C6D6B00B0; Wed, 17 Dec 2025 02:32:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 527C26B00AD
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 02:32:27 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1936F8B6A7
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:32:27 +0000 (UTC)
X-FDA: 84228145134.01.F60B575
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf04.hostedemail.com (Postfix) with ESMTP id 40D5D40004
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:32:25 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sWrtvrRI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765956745; a=rsa-sha256;
	cv=none;
	b=koEfDNEIUe+OMUWwGmqDUxzdaRh8v9Pme7jWPI4ZXPXv3bqTuIw/J1AwhjGeK537VAsmyq
	DGitbPn+NbFGokmtHiSw7XM3do5OoJmqMttTIxW7iT7u4fAvWCzVTLjNT1ouNK3szg//i3
	Od07H7Z1nw5RrarM+C3ZhD/r/pKomzE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sWrtvrRI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765956745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XgHA+TVYxxe6Vv06rsmZd9zVObrCtofW37vIgARv2qc=;
	b=lGukjXn5sbNunyPmUUkL+VXP6En2J01cW7SxcuT4mRaTUPoEGgtDTIeqsvuwejdL0dZwcJ
	V9fenPfYlfj4c0sfFU064r9Y2r5mcfcKXMk+SvJj8/ctty+JPikfUNtbz2PhUmFFrLDL8w
	Fw7LAz8jS3qkoZJBNngLqsf+MgHg7uY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765956738;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XgHA+TVYxxe6Vv06rsmZd9zVObrCtofW37vIgARv2qc=;
	b=sWrtvrRIUjcLsV7Wz5k1ASxrUwoIXf5ObCdZlxnW7diW5X7mj4vFtrqgIm0bmWwwlrporg
	FvuQhwE+227JPy6VoGESBiGjDTkh1nwLknInGXf2rSOD4WFKaF/jNCHA5EV+7gOdbt70ce
	PqEwH7/QF0cw5Zu1jPS8S3uwLTa7hUM=
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
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v2 17/28] mm: thp: prevent memory cgroup release in folio_split_queue_lock{_irqsave}()
Date: Wed, 17 Dec 2025 15:27:41 +0800
Message-ID: <4cb81ea06298a3b41873b7086bfc68f64b2ba8be.1765956025.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1765956025.git.zhengqi.arch@bytedance.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 40D5D40004
X-Stat-Signature: rqp5papq8r7dmym3n5zrq37ti6du1ecr
X-Rspam-User: 
X-HE-Tag: 1765956745-589607
X-HE-Meta: U2FsdGVkX1/HLZoeL8oUxVJHHC554Cg7FFe2Ao5K56shi05vGfdh88xGhe3p8KyI7eQz3Xxz4DZbbhaj93PZHJPV2v4mx7a+Clgo6kBFT0wQglW0CF9S0EAmNOWALPJsyvHgtAnuMdmqGibTfYCCMhpglWuQOq/9L+mpeQjmC1DI9mSkDtBpgTpPdRiRTHiNdee+yQ/81R60XSKZIzfUQ/Usn97xMZ6du3/qBiaQVWOTqDO2ygCiMw9xpZau2rCEwzJswy+ciLhZmfVQcC8zMghlpkqmGsPQY49l23V26AxmImYxHSobtLox7ns6ZrL1ow3H5XCTKD9MQjyJqge+/jA44YXa61ecOz6Db3dwYi7Gdvp+Ogup/eVW0zZ9mv22VlrLL8B05hn/lyC4eCbxEDAA+PJ6bFejVDUNl1d28W0FKYzgKas+7/+g5/7jscc8z+B+dczhtBM4NJXoPB3j/WAydXeng9GGNhaUSuH3b5zyuWjMlzuV8XnkOf3ZdovXWoidSgdEhGSLoGcjQSpUnthNbjGH1InJmbZStjxcsr/VnGJ5nnz0JHVPsB7rpnnzIxnWzx8GqsCMcPRmUZqvd1cbhMa9dJRRFBynEkypJrkSFZEZnpXYBlIiJ1/CuLfWRnXCWXBs5K9Odzjf2ZzofRC1JZQWxdQu5NFEVDVU0nsWtHO1YM+eL3xlHVIMcQYjLeIZcbPwWPM3A9y+1XArEbEC6vTf+vKD4U30YPuLHM8mZQttBrL/ZsB3eVonJPEPFW7DRDvYPkr3Q/bsHEM0Ed55zZz0MXiFxk71Lo5/qePdlOgJBzGFOG3rADawCSHQ2sDi7FiJ2ZLBerky2XFcnD/7GrxwjH9c0So3Vhm389x3xHpsx2JA+Lr11ThPntroEiLsFP1Hj5LjweWQJGSvvsOxk6QeUTUC13PehzeFQrn08WLWZmAHGzkayy0gBufFekploVYt6pvTLn8LrqX
 MFZ0KoUF
 tXeEsgUWeBu3dKhFduniD73fAArL0Y0v/0OPSHQA2CZ5V0awxc4jecBEMrWmk12vlEfNfo+x4ViyQx/FBHcy0noi6D19coDLVLKRz06/llzsfWFhNPYocPtiPlfenA4MVn2x4L1G20ARsFtXHrGy6Ey5OTSUjCcnNBGmyiJxMPAOydYURLYfngiWnQz9j7R+oS9yGaCk1jJDRbRVQFXjqYNuY3sHLdM/veXaooWdTgXuT2/y/d418BjS+mzaYwyP9kcBn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
the release of the memory cgroup in folio_split_queue_lock{_irqsave}().

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
---
 mm/huge_memory.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 12b46215b30c1..b9e6855ec0b6a 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1154,13 +1154,25 @@ split_queue_lock_irqsave(int nid, struct mem_cgroup *memcg, unsigned long *flags
 
 static struct deferred_split *folio_split_queue_lock(struct folio *folio)
 {
-	return split_queue_lock(folio_nid(folio), folio_memcg(folio));
+	struct deferred_split *queue;
+
+	rcu_read_lock();
+	queue = split_queue_lock(folio_nid(folio), folio_memcg(folio));
+	rcu_read_unlock();
+
+	return queue;
 }
 
 static struct deferred_split *
 folio_split_queue_lock_irqsave(struct folio *folio, unsigned long *flags)
 {
-	return split_queue_lock_irqsave(folio_nid(folio), folio_memcg(folio), flags);
+	struct deferred_split *queue;
+
+	rcu_read_lock();
+	queue = split_queue_lock_irqsave(folio_nid(folio), folio_memcg(folio), flags);
+	rcu_read_unlock();
+
+	return queue;
 }
 
 static inline void split_queue_unlock(struct deferred_split *queue)
-- 
2.20.1


