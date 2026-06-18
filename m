Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AAAECD98F6
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 15:15:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B4716B0099; Thu, 18 Jun 2026 11:15:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73D686B009B; Thu, 18 Jun 2026 11:15:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DEFD6B009D; Thu, 18 Jun 2026 11:15:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2ED816B0099
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 11:15:34 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 70868140150
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 15:15:33 +0000 (UTC)
X-FDA: 84893382546.30.E80D65B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 85850160018
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 15:15:31 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c4otBAAd;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781795731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f+ZFI7Qgbe7xnOZyetZ4L3vI22eJ2l2ckq5hmR8a2XY=;
	b=BUQVl24Nsc36VQx989FEN/Chh59uOjov4PClIzYrp57gpVvZkWXQ0YuODLuQi/NHPGFacP
	H7twJT6QOfxKKQEFc16Ir7+nRzoyEzcmmiDxXbvY8v4X+0QlXp6p1wxrzFUuX8gXt2fVJs
	qn0bHvP9YwSyPPAsiWGRrTpQLUKMy28=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781795731;
	b=ZO/CUTpWrtUQ+FAh8T6M58oFAuVzPhic0M3J+2FdiC+HLFdpchlfwAoh4PEtdVL272OWwd
	WClTWdLKOzhb1BQk8kDQhhNDnAyiE1+7dwBs3yzkrQcvv5anu3ZxYkrWNVIJfwA9n2BkRg
	Vls17p+mBoQe4upmeaT811yJpe681WY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c4otBAAd;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F218A600BB;
	Thu, 18 Jun 2026 15:15:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 940931F000E9;
	Thu, 18 Jun 2026 15:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781795730;
	bh=f+ZFI7Qgbe7xnOZyetZ4L3vI22eJ2l2ckq5hmR8a2XY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c4otBAAdK7g3o77FEZQlZkjkONMzdQBJ0R4LsRPs5AkdB02wLhURfZ5fgv/dnc1eW
	 x7EtoweTcNqhD8+CSvHCtoKjG06LMUpEU/sMWCBNiThl/khQFDDxnamTr2pbeGL6Na
	 u14I1gBO1NVF5qzQ5SVCCdRULpcy/o1xKdvuLG5e7MsJQv3LbGBjInCHNIgPOQenbQ
	 KhCLsKOe/KUMaBEfTu3BFjCxi1nmosMs/FD4xSVEcOCkvC5kKCj6yWaz5QhLzePkE9
	 t7HRJH/vG4FA3T7JSX7bq6rso8OyVWf6DKuJY7ytEGZHa3AePC67Ma5zeGjIYBXC+w
	 6MQCZ6V9CAJxA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 5 . 18 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 02/11] mm/damon/sysfs: kobject_del() region and target (error) dirs
Date: Thu, 18 Jun 2026 08:15:06 -0700
Message-ID: <20260618151517.5366-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260618151517.5366-1-sj@kernel.org>
References: <20260618151517.5366-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 85850160018
X-Stat-Signature: btfnbcqo5z1zyc3hqx15ow735nfhfxbw
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1781795731-753547
X-HE-Meta: U2FsdGVkX1+bsQG1wjIM38dzHiouCHyS7fwwcRNHvodxwQpp6iL8+bIgKsoWc2jEzrUezYF6z6grtSYV0FENF0bjiNLZlEZF+AK8VcZBRN0gALJlANCzw1q33cLjuAbtDMIZ53ZiRy2VlPGja3H2ppy2Zj6NLC3Ctg1Z5Tl/IB/XoNJ3QM/mg1N8GgY35qF/Yv3P7/qmplMkp4sHVsQ+dbM/+rIYotcvCulHAmxUBC2DlocsIcRRl7dBgTjJKXne0maLoHGPPts/gK6I60zqW8BbQ/O7p7psKRHs7ny/trvoaNC8o8udUcbyxH7qGaDawYqqgB6mya4siPD2gF/GEgbkswoDq1RdcALQIlE9uHE2sobAl/ynTdQC52trUtRna3NQn8CJyKSyNK2Pw7eDwypAj5zodgaq+EduNd81ph0/UbSH0M5ut0QM26kpSln8d88I09q2mCJbpg0v74NrSJvDdL/tGEnZOPwL7dL00iTiNZW8MEZm6aX9QzmxfqdGaZ5M0g05+DR+fqD8O6bl2ha0171+3V4+Bh4tszLxWdGJf5Rc8uxrp9hAy772ipHVMZMLRuNP7YakFkbt8PoU9pLzwijU8GHxrGPHiGJtXPgJZGZ4Ad7La2kBOIBaYMVvg/3eNSOG52xf9TzkBT29aIKZhx/F19uBoR6F+vkUZC2ijzaK9mpKkR8B75/vVn1GfwLfMQSpw1ICofp1J6f2XY6kBjsOR+vR0J6/oQIsExrFDIGFCBcd0f0bo8Tqp5O3XZqos94FHuYp599/Yvd7mYzNJHOEAb0PAlYJdS7eeD5azBI0JIj69MzKf0Bkr9tLonx3YvoNwIRuxfKjqJtkAz7iuYFOU4Ja/KXrz+Qff+Zqu+pSCmmNIt4V6DwYMCW54ThJHAKuSoSwzecvDjcrnOlB1Zk7g3htgOiSazBUpd/2K9CerXS9i1sHKlBziiLYh0gFIE2mW3moTOwassd
 cCVa7bCx
 i0Pnkp+1gZuN4yI3wLTOijc7h6sebHkI+eGoCKvFsZhAGBmFwmKU9Xyt3j8kZoF+jqvQsfc8SHKAu2jV5uZNKgEJdJQj2Dan7WH8uqe/WrIiflQtxX63RsQ5+e5gDbD7iS1ezLgWxhvXCI2LUpMUEAbGP/xWpWy7TExGsAdLnxy4D+AHbp2Jm2gOLq8dCMHSX/qiBJ8vAB1lu+cT9/qeYXaP40aw688A5SyggHmy+K3N6aZKvHlGBXzY6gAMk5kamoTgSI7/+30yYiqEgYzC6YLBFhw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts. Fix
those issues for the normal creation path of region directories and the
error path of target directories, by adding kobject_del() calls.

Fixes: 2031b14ea757 ("mm/damon/sysfs: support the physical address space monitoring")
Cc: <stable@vger.kernel.org> # 5.18.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index dba1c67fc188f..3c349f0fe80f0 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -107,8 +107,10 @@ static void damon_sysfs_regions_rm_dirs(struct damon_sysfs_regions *regions)
 	struct damon_sysfs_region **regions_arr = regions->regions_arr;
 	int i;
 
-	for (i = 0; i < regions->nr; i++)
+	for (i = 0; i < regions->nr; i++) {
+		kobject_del(&regions_arr[i]->kobj);
 		kobject_put(&regions_arr[i]->kobj);
+	}
 	regions->nr = 0;
 	kfree(regions_arr);
 	regions->regions_arr = NULL;
@@ -372,13 +374,15 @@ static int damon_sysfs_targets_add_dirs(struct damon_sysfs_targets *targets,
 
 		err = damon_sysfs_target_add_dirs(target);
 		if (err)
-			goto out;
+			goto del_out;
 
 		targets_arr[i] = target;
 		targets->nr++;
 	}
 	return 0;
 
+del_out:
+	kobject_del(&target->kobj);
 out:
 	damon_sysfs_targets_rm_dirs(targets);
 	kobject_put(&target->kobj);
-- 
2.47.3

