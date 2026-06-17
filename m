Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 620B7CD98E4
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 14:48:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAF536B009B; Wed, 17 Jun 2026 10:48:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5F396B009E; Wed, 17 Jun 2026 10:48:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB1E76B009F; Wed, 17 Jun 2026 10:48:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 750DB6B009B
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 10:48:37 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CE100120452
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:48:36 +0000 (UTC)
X-FDA: 84889685832.12.93FF3B9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3648C80016
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:48:35 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ei7jrHtx;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781707715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oMPoBzlor4YU5RTzivO7rISJyt7/7CUYk2cjtpLbxXc=;
	b=wZCxyAYqF13j+o1NsappRakwQeYaAKL5AiTY6FnkjeDBYwGN1P/PBjVSw8PYFGdhi3USzV
	GzhdsoKTO2NzmInIfdopWtfF/GfIB3jcm9PVdFcok8iFGTBP2YpNsyxUMRg+1FuugdtPQL
	7IBVw+rFcDR0Z7QKNjsTK3H1dQcC+lY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ei7jrHtx;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781707715;
	b=RPkzlJNMyPZH6L4FKCgCYpLgiA7QjOqiGIEfQt7nxHdoIfKPGzEkSC0eEWL872+lSMC7/G
	t94q4JCpnvIHypqZ9yc/MF+FHobc5XwXNHYZpfKdgKU/3rwz9QvbQCHnTvS9UQfeh9zzEx
	Q/n8PwG6UMZ8SAEmgJAmnsoo+q4qQWE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8A56344569;
	Wed, 17 Jun 2026 14:48:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 611FA1F00A3A;
	Wed, 17 Jun 2026 14:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781707714;
	bh=oMPoBzlor4YU5RTzivO7rISJyt7/7CUYk2cjtpLbxXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ei7jrHtx2dlhidm0rTM4a1j+BoexWcUkxDPwPYX+0eqTMV3QQN3ANxShN00kB3BNN
	 Kupt4KlTe9Q5f2rQfV/1QCt6OhODTnXcqNmbwTWQwAKlXiS93AskpVj7Vh9lLRFcbK
	 VrSxcOUHZtT+BwSki/KRjUoQ7285uGp/sBKc1LrlpHsebn/5HndEjdVvODHT2wFTNk
	 Mv4bqYk/0VM+wlJGCuNKpmM6PZEe55mjKeeBZmasb82+xyS8p4b1KlT5ykEkju3+Is
	 DW8vZGtWAuOeksxaWN7Q4CQJl1KXgPNOgd0RT0hSTt9Ig4qNdSbg1oLRDDVMDRX5NJ
	 qf+Yire5fXKeQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 5 . 18 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 03/11] mm/damon/sysfs-schemes: kobject_del() scheme dirs
Date: Wed, 17 Jun 2026 07:47:57 -0700
Message-ID: <20260617144807.91441-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260617144807.91441-1-sj@kernel.org>
References: <20260617144807.91441-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3648C80016
X-Stat-Signature: ymhhfwophziuqy8dzcbkuukrbcxnd5t3
X-Rspam-User: 
X-HE-Tag: 1781707715-574830
X-HE-Meta: U2FsdGVkX1+mP7Ct+D5DlxajPwyXLBMJlw/3ni8nfm9p0w2IKe/kuW2lwfY69ZjgcbBS52IEu6GGbZ+865TUEEkAWM7NxyPPJt+kR5uvtfyCAs0eKv1h8OWfRgY7PXwxWqx4c08ueoHLYEFBTnBrVXT8C3x3yPA/rlC+SoDnmzVifn/Yke2G3lwEtz0+Qn3KuNldDaQcMQO6ouwHQA535sk2nP3AqCYP+6AKqWsvyY8hZlhjjK0vWEYNNDTIymivu6JlXz5EystukHBHhvrJZ33ow7nT2wNps1AL8A0mAOwPnYgFo/43qHoIl/9obOZmpqzdnh5hvq+oltuPta7dycL/JzPHy6tzKpdJ0Qo9cfS4WsXMIkEV/8nCqaeuSoqsx7fnFg2Wsf6gBnU5bTuNobDnnY+7g5bxmmu66w+BFUJQLNmhSsHY1qAq/Mr62UCDazia84PvBw9Nv4Ja6ELMEwZ1FqrwxCN64vvuyF0IbOGigzZtF/sKgpE6EX1jF6SdDrZ3FjTgjkNRejyti6MPxfQJDfqGawfX6HwlBaf111dIYJYvz1ftIfFtZxxSGWYgBKxSQ/c5Ezeo7QXweFRoi8h/vUqpbLSxzSo9p9Socnib+i0ybIZj8fiCIQb2zt9B9duDWtny10jzneLDqqMcU9yYkqci+UkdZ/VBnTUuvmm8Oko5VZIQU3wB/Q8FqnG2HuKvN/FT7KspmGfOnATbfuh/7hu7CgGOg3ltywAknjsdpBNi+kh94jCrr36JFW6QQygoPhaJkvlVYunuXqscCZHLXtKS+MF0gdKzogzIM7FtCBZon5JZQ+Ac6i4ND30dLWSoS/52TSZwZW3u0rUz4WyIv/lniReu97DdCoNelmif6RrMHNNH8g34GVjmorm1v9HBwKGKHzqZRHmUjnijDW+lzGaN+1fjphONySr7AvFKrQKCo4nOIa7ZAkwE3XdB4Al4qFbNLJjX4jxAQM+
 3vy/uH/x
 EoUI7tBMO05u5bewRq8tbhohcOsRQmN3e8OM6mVPbkN18yAt5pSkt8/ValPtHKFIQN+ZfBji6RBaX5lYBEhflq94cRDHYBJaq/OOVF8a/QZSU2Z7VL//DBpos6aV3E9lBQWB1guOjCnA6MAlyXfSrmILI7a/R4ZCwi5F5an8/mVfh9ADObuXB6QL/PnuASsaSCJoMOwIqXUJtdzN0lb5Ogy8KFRfVvxdFF1uIBoL9yH4fOgkoqBRyIyoMpBBXWMCwRtgWjmarpfX8ufCHHWRL+8Skfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts. Fix
those issues for scheme directories by adding kobject_del() calls.

Fixes: 7e84b1f8212a ("mm/damon/sysfs: support DAMON-based Operation Schemes")
Cc: <stable@vger.kernel.org> # 5.18.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 0134111c3c1ff..debf2a3a0d8fc 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2683,6 +2683,7 @@ void damon_sysfs_schemes_rm_dirs(struct damon_sysfs_schemes *schemes)
 
 	for (i = 0; i < schemes->nr; i++) {
 		damon_sysfs_scheme_rm_dirs(schemes_arr[i]);
+		kobject_del(&schemes_arr[i]->kobj);
 		kobject_put(&schemes_arr[i]->kobj);
 	}
 	schemes->nr = 0;
-- 
2.47.3

