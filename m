Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D75ABCCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 05:59:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFEB18E0003; Mon, 20 Oct 2025 01:59:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAF5E8E0002; Mon, 20 Oct 2025 01:59:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9E238E0003; Mon, 20 Oct 2025 01:59:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C54648E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 01:59:06 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 496661A0768
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 05:59:06 +0000 (UTC)
X-FDA: 84017439492.05.E73143B
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7DD4340008
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 05:59:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NUd69dFd;
	spf=pass (imf12.hostedemail.com: domain of swarajgaikwad1925@gmail.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=swarajgaikwad1925@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760939944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=jh6W7krdQiiiaYxBqeKiYxYtQ0S05p25BmbNHj4vO4Q=;
	b=MoEwRCdGqawgy8TJwtaET2LLIbpHmaeJ+YE9shWfNQ75nwLwGmfobfhoc8ukF5goIVLEVK
	fO2F6D6UzvqSXGsRJETDy9JBYzKUq/ufAatKOdUnxCm1MOA232Z8pz287F0feyI4sZUTYe
	f3Bs1BVZiT4Ikk7MPPxhADu0xCepbzc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NUd69dFd;
	spf=pass (imf12.hostedemail.com: domain of swarajgaikwad1925@gmail.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=swarajgaikwad1925@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760939944; a=rsa-sha256;
	cv=none;
	b=5dWUujERPlwMhMvSCMtSPLEQfbVKMtnALtuh5QEb4Pql8BBNLmn7bDi/g5qh8fqG8dMf2R
	Mmj1iZmS9k5OAVjr9/rEwMbBKuvbUVlID4jM9VIqsnbke9sq5dJ5vWoeQUXS8yZHFIkWJU
	utYXo/wuLyoSl8SeHCa6FKYZ19a/hOY=
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-b6a225b7e9eso2790267a12.0
        for <linux-mm@kvack.org>; Sun, 19 Oct 2025 22:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760939943; x=1761544743; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jh6W7krdQiiiaYxBqeKiYxYtQ0S05p25BmbNHj4vO4Q=;
        b=NUd69dFdUPXJtHlwecvML1YzeQQMVXORQ3EX/1vklhEIgAN0vV328rUoXvTOw408Rc
         6rlKteWhoaU3+hMMg5TtRK6Bu4QSZ51JgEUd3N8YhjDjAKBQYqu0pChscstZKWaPJ0Yk
         7Wy9VlOZVEOBxVbXt9NIUjZx6rrmY+DkNTB6VfOFWfxmVVkH9ZjZgZi18sdnWMY29zsp
         li9QXUPKzV5udAYftzbN/X4eIpixc17LKiJhgLKKb5wotf21EYv/FMYNFKKFdZiLgRMa
         zGaXfsbsG8xxdKJhLogJO71Bil15bE0j+bfZFaGGCcjgCejHTUsnHLQGssMXZWyCblgm
         2xqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760939943; x=1761544743;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jh6W7krdQiiiaYxBqeKiYxYtQ0S05p25BmbNHj4vO4Q=;
        b=NfySfxOWfSMnVqmuWRJTxUpos+K8ed7eoLiXtlMNbTu2P284s1BLVqI9pMuYAtEVnV
         p5xXT+0oc/UyLV3cBvzaLTgUKpe+gGdu7CzFIDuqji5pbkUNO/J3cSt3wforTkhWtK3U
         ZkgWlKjlWe4Ict+fTSqgSO24eHY8msy4/l7zgXTjO77lkUPHHzN957iCvcZA6OVxHYaa
         wXnEGSa+KeTY6G11Hfh/Es0WVZHA5zNsre+U7CcFj6DPcfetBZSPay0sj8yEQSZkGay1
         7LAbf5LxIKz9UrxJTz6H/KP5gVDlH9V3hZEWCNqASud6pZDCJ6hSLSy2h3v6Dzb/tezQ
         ZtCA==
X-Forwarded-Encrypted: i=1; AJvYcCWCE6wlGUjjE9rPc22DUPTg7tvxx2OGuSucaoPfN2oAJLV8NPdKKpT8fqMVhLvpaN2Ktx7FYPnNqA==@kvack.org
X-Gm-Message-State: AOJu0YzzFqceunF9/U//rvBAgXXMgfRozrQj32Cwi2j8tucVn9dPxlcu
	dIWY/KVsXhwr2lWWowB6v3AdkvZQQFL7u+yIoC5hQcSB+CZS9mb+Z5KC
X-Gm-Gg: ASbGnctCxqJeS4cFnVTX/ht76PDjFDVG3Xlydy9IvYlYvFIvSo5cSHAFWgcA2nYpUB7
	Ti2WBqKkWcx8LSYAF3KQ+wo3IvgwbcRxDzlt39fYxxWwC25vBChFUk+7GQ1DubwY8RlZsML/rH/
	flwozuNOpExmSjxZPB0xCYeeSu9qGWheoCAd582FvG+P5Yk4EKHIhBNQSQef03KvA6M9FcPUIRq
	GzrXx8pjbgsYWBy0YzQa1JUuZN0T/cBXsCI6oWyljjL0mkFiXJqUvnGduN3T6UZTdT9CvmAbOSu
	dv0WShunlFP6V/JY4WOP0MRI5W1vvsXBJzEzCht0+pAQvw0q+sbyWrgK2Isa+c9qVWhP+IWXUpj
	ZqhYyCNaa06rP2ZDZQhE9A9aqYelV5v/UwB7fFGH2YcU1+U1epyKyQnmn27/T4lu8llVpbqgiTK
	LzhWsudXdS
X-Google-Smtp-Source: AGHT+IGlZYGHdGgTHh1H3IPWV/+DfKsNTbrDi5Reqk7UDbn9zs+s3vYh2q9TI7qZwuSkPn3vMBTWxw==
X-Received: by 2002:a17:902:d584:b0:275:f156:965c with SMTP id d9443c01a7336-290cb65b61dmr142564905ad.52.1760939943138;
        Sun, 19 Oct 2025 22:59:03 -0700 (PDT)
Received: from LilGuy ([2409:40c2:115f:7331:acce:2657:d834:4048])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-29246fcc795sm70386805ad.30.2025.10.19.22.58.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Oct 2025 22:59:02 -0700 (PDT)
From: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
To: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev (open list:DAMON),
	linux-mm@kvack.org (open list:DAMON),
	linux-kernel@vger.kernel.org (open list)
Cc: skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com,
	Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
Subject: [PATCH] mm/damon/sysfs-schemes: Validate nid usage in nid_show()
Date: Mon, 20 Oct 2025 11:28:24 +0000
Message-ID: <20251020112824.144391-1-swarajgaikwad1925@gmail.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7DD4340008
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 969pi6ou6a9z7ktdyzios595kktr914n
X-HE-Tag: 1760939944-595428
X-HE-Meta: U2FsdGVkX1875tPcAvpw7aSXzeRovZgTZ8IEAR4/3yyRHgr+50CStjCzq7GOw2p4tWQar/InTU4pDx9ngBhUdi7j2UM12B7PXo2NUYR4fqe3OK0BYgQKznp6Fx59OiwQVjeCbcezX41h2lyScEzIbhUDdeAd6UFJrKxf5YEv0thc/zY/NGfj56X1PNOFFe73rN22zg3kcn2FLRyJ7/BKFLUGC+qumblU+vnaNIHe6BYkcUfZow2f7OBLWPID2sX2jqVvmEoBfl8t1pOAf8UZh4T/Ok55vnQkpi7cfbofCzAKpqRYhywPql7SXrRZuIvCf42/vfAv1OiPBda+b0+m4qkEnku3H1I80NGf6WJAm6KyRpat4QAO1Wso2a5p/ay0p2Wcqqeg98v8dDYXPbNYv1AZROYvLT/GYm02ImodgDjTGKjokQVL1MFHjOBXfQ7tQYPTAdmqcHYyCew0gBUMHU8ag+7JjqPPEivC0q7NOZCQtahdZL9abSOA1ka6cY7ITCULaVJ+kEImptnGjCfW6JKQRLvanZqL78JCIQ1Xvtfj6nrX3rq3Upyqu++21xc8JOxIyVA54yEp9afmzAf4Qf+nUQdo95jc/Xeil8enQJVfNJflwKpdA/kXM3XExDt34SY687AWW/WorE2ozdHqTMDfQgG0n+FtJDDBrbm0ztPXjvEgGu2wjsiFOv5qLRXw6H54lCW3kiYHt9FGPMkApiiJYq/+tXvP0/cK64rIYd4oFVRyMhF5+Uy1qNeotcTHtTk04D3HmQFhXuD6X/RYZbiLk6gQN49zdkz9owvrDYLSD/vAL9h38JXlJTSHkO1/MUTABV7jYB1uJ0Q3im6feJRlqsZQDUDJRqALo9aGNH3VsTeOwL6DGwWYaNh5QMWhMc7LrIgzDs4u3ThtUhFSF5ZnVJkUt1+6VJdm1zl6HOwgsjy2zxRXUw+1RdQEHuv+QeuxE35gEJi/98Uigso
 jKXs/3h1
 NaJwxOmpdfmU0iuZITHl+uMEKi40JEZ1XIgXnnHQzcKqjL8+pYjY1Uok5TQQKOwOZ9lnR93rXAsr74SWwUsRvSDmtQesuiuwsxLhT7f9sJ1hy29YkakQfpEk87aKiCd7fdGWK2LvEEBI+X9mjB5uQrsrZ7x1Q1EJriBdr1qI423N1PNHHEasjwkULub/PtZbDShapWzv+R9HjMx6tbkcWjBmHwfi3hjWqfNYg1hMa7K0vUxh97xt+vLEeNVxDh+HHOVkkB7ni59SyZ9NbYiyLTYIxqAbrS8v0OHWuIxvgs7O5AY7/EJSjVmURu1bQe965JfCFFM/zeF1BqHJBPxe4vNetpRZIbHfp1wHvZV2Iycka2iS0PRq8EPFrMRfc6Ioddz0oBywDRYcHiqtqsDYFarEP/gc0zLQQxBFsUZD98uSo2OUNWVjos1ps6zB5D1OG7GXzFT3XvZZw3n5sc5an4gNewNKkvu3wTL91VlZXdOq1J1nAQ3VdTGVSeeancDZ3zFrp1IX2zGO+Tcd8I4HG9rcb/OOuuEe8LWl5tLsKLxNh8Jw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The nid_show() function previously returned the node ID (nid) without
verifying if the goal object of damos_sysfs_quota_goal was using a
node-based metric. This could lead to incorrect reporting when the
goal metric was unrelated to node memory.

This patch introduces a validation step to ensure that nid_show() only
returns the node ID for valid node-based metrics:
- DAMOS_QUOTA_NODE_MEM_USED_BP
- DAMOS_QUOTA_NODE_MEM_FREE_BP

For other metrics, it returns -EINVAL to prevent misleading information.

Tested with KUnit:
- Built kernel with KUnit and DAMON sysfs tests enabled.
- Executed KUnit tests:
  ./kunit.py run --kunitconfig ./mm/mm/damon/tests/.kunitconfig
- All 25 tests passed, including damon_sysfs_test_add_targets.

Based on commit 3a8660878839 ("Linux 6.18-rc1").

Signed-off-by: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
---
 mm/damon/sysfs-schemes.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 6536f16006c9..23a73b94fe53 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -1112,7 +1112,16 @@ static ssize_t nid_show(struct kobject *kobj,
 	struct damos_sysfs_quota_goal *goal = container_of(kobj, struct
 			damos_sysfs_quota_goal, kobj);
 
-	/* todo: return error if the goal is not using nid */
+	switch (goal->metric) {
+		case DAMOS_QUOTA_USER_INPUT:
+		case DAMOS_QUOTA_SOME_MEM_PSI_US:
+			return -EINVAL;
+		case DAMOS_QUOTA_NODE_MEM_USED_BP:
+		case DAMOS_QUOTA_NODE_MEM_FREE_BP:
+			break;
+		default:
+			return -EINVAL;
+	}
 
 	return sysfs_emit(buf, "%d\n", goal->nid);
 }
-- 
2.51.0


