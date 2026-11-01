Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25406606A324
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 12:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RoiXFi/1
Received: by kanga.kvack.org (Postfix)
	id 2C6696B00EF; Sun,  1 Nov 2026 07:27:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2772D6B05B1; Sun,  1 Nov 2026 07:27:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18DA96B05B2; Sun,  1 Nov 2026 07:27:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EB4E36B00EF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 07:27:07 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EFFA4C05E4
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 12:27:05 +0000 (UTC)
X-FDA: 85386474810.08.80D7A91
Received: from mail-dy2-f7.google.com (mail-dy2-f7.google.com [74.125.229.7])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4866340003
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 12:27:04 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="RoiXFi/1";
	spf=pass (imf04.hostedemail.com: domain of dennylin0707@gmail.com designates 74.125.229.7 as permitted sender) smtp.mailfrom=dennylin0707@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793536024;
	b=TTAj72BhgkQhfD/p9C1dK2Tgp6miBZmYqEmPIvE/VC7vHXCqALOFTnGCZ+c4e3sHUOvFp7
	oJClK8098xPK9xSkHYKxd59M2wMa6pLN+MVbV8lEyljAG4vdsgRPDwLwRcdr7nD92+iLWk
	4LD/xYtGPfolnJM0PpEAZ6GOf1o3Zr8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="RoiXFi/1";
	spf=pass (imf04.hostedemail.com: domain of dennylin0707@gmail.com designates 74.125.229.7 as permitted sender) smtp.mailfrom=dennylin0707@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793536024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=dA762MiX0XGurLRN9b/6HziROeNi9rk6flm5jzR8jYo=;
	b=InNBCeuZbTz/bP03lf80XXeb/4omhVCOioakC/6Bk2KuYQl7H/VMMan3g8PjxxE6Bm9EAx
	hdHFu1tKIH1M8NrVp2NPMw6qW+b7E0kvMppFKDSerOXHCm6xHM2rejY4u4NhnTGGAwUljY
	hvLb+lzBRHCWZ3BwyTJYKONOWiQ9c+A=
Received: by mail-dy2-f7.google.com with SMTP id 5a478bee46e88-33e5ae86ff2so1282526eec.0
        for <linux-mm@kvack.org>; Sun, 01 Nov 2026 04:27:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793536023; x=1794140823; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=dA762MiX0XGurLRN9b/6HziROeNi9rk6flm5jzR8jYo=;
        b=RoiXFi/1EWCCfZKdnCcpKepJbagzcUqPAVC48oX7QRhgAqUZBNJdUvMmRx+FAw3ABy
         skNSrsppg5J86piVEJEWCuONpAwsho7x6G3c/GNcCo78uEmEbe1Z8ze6b3sbLIu8VmnY
         RLhg4LxoxqUefT+SU/6c/IjkOa++3OjGoSmCEKt88g4wYqzfYBuZ+8sjly1qYlFLsYZp
         smvZhZrugWLR26imBxVG2bpOpGnwB5A/an+HF7hWIdOGIPy9lVHHBxl+UNCF+nq/7t+y
         mC9dTIf/zbKP8qIKEhZZo1SgMOyJrk/J/S6tcmHqZpwyBS4m7pN+VK6KETRWezTmT9Df
         sivg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793536023; x=1794140823;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dA762MiX0XGurLRN9b/6HziROeNi9rk6flm5jzR8jYo=;
        b=MUJFS8wJgMfXnJ1VUdvOslKyvz7Y7LllieCX3mg8XmC62b+Iy9wjCARFxEPbil1+ws
         RbNnv9mKqEHuahh0FfK4p9p40tMz9BaxDQuIp/ZEQK5TBc1j9orVG1B1IaO4jnewBZt2
         5J6aS+MoWKNoM5+uqMUcCHJPDIU9lNJBeLIF0/VirxZZZuda42UJ6+WBdsJ1iLgNi9fT
         o/oyhgDWQPobhJUFdYcdoNOcAoCHZajonQEkFJP04hyNYbuoIx4cCzrUhCCvibNPcBua
         AzWpsplctKhXeiUkAONRMfpya8FCaJcNORGr9dBgQ3ft+0Jj9we5UNan7RWKnBZVUHeY
         6Iag==
X-Forwarded-Encrypted: i=1; AKwUvBx+oSXiOIxgXx4jEBLNVrDE00UD2/gPQ3UJ3jmiucdH3Yi7NlHBfL3DJeeKgBRcmBJFhLgHcmxiYw==@kvack.org
X-Gm-Message-State: AFq9FYIpXbknppaJ5d+uwg+wJcQB4MiU46NknhytLhkVwAfnH+GmzR9S
	6isa92S2Jvaz0xAD+wDGU9uluAyF/AtT527n/i2GBCh2BdpbNsHQoxne
X-Gm-Gg: AYBFou3QXi903l+b2eHOGmD31cPeiwd6mpcOiKYnOSBfaXqY9s57dDMhxFP+8+XR4o0
	MiaFGrKMladO0RVmZwJBbl6e7b1ZaBV5TGXuVYUFQV2XZD8EbnVvF347pBn2uZoAngahqIJx0mb
	/5zb3Gcpq1Iu8Htyj/nBxpC6ijJfW2T6wWzCbTLg7A69ii3oOKiCmBSN2x9RpNb7kerw+grtmhz
	Vm6wFoyP0it/zdsnoQBCrzJ8MWxk7qYslHLKD8kq/AjLkBBfQzFOIhw8ZHHpiLmzk6okCu7yvov
	mDrQL+FekyuFglOsHAvijEMNr9X324g4awbd9oCf/Lxc+Wqas8qYBHsfRQfe06BavFDb1p2fxri
	2cRypDziMV5E/WMhpNa++/fTF0qB72SNeA2se88JpdfPHwoaMQVqykuC1wuvqJ7n1AKky+sGC1r
	e5kV9PEYvXlppuAggVGn8Q6VnvzgrWrv3RzPDt4i5XhmBY+heLKqYsY6MoxplBZDwzvJoAaBF2e
	i5kztoZK7g7y+ont46g3RHGF11TG1W1E+SADxEpam/UZWfqxRJ+UbLMoXUzzjzVFNMQ6npZQEKK
	ejtKKqKPhLiIz6GhbHDmlCNNaowwMnnYfdmR3jjFhV524azCt4GDAHtnhOCXpYB8KEEahg2zfh/
	6Ug==
X-Received: by 2002:a05:701b:4206:20b0:1a4:9eaa:d01d with SMTP id a92af1059eb24-1ac5fd08905mr10832402c88.45.1793536022578;
        Sun, 01 Nov 2026 04:27:02 -0800 (PST)
Received: from localhost.localdomain ([98.148.34.5])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a428aed76sm27845234eec.9.2026.11.01.04.27.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 04:27:02 -0800 (PST)
From: Hungyu Lin <dennylin0707@gmail.com>
To: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hungyu Lin <dennylin0707@gmail.com>
Subject: [PATCH] hugetlbfs: report inode limits without a memory subpool
Date: Sun,  1 Nov 2026 12:26:53 +0000
Message-ID: <20261101122653.53982-1-dennylin0707@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4866340003
X-Stat-Signature: t1q3qk5dgnndy8cuqir8j6j5kqha9bzt
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793536024-310580
X-HE-Meta: U2FsdGVkX1/NIdaTXOiehEL1kdn5QZtMHGHErKf7PRU89jZsBSwrRWmL1tINAWZpyXTGHw1cbDL49Gsxr9hHYtLF/IGhwffj2CVuiLvGs8BNi6lf/0ioPYNuwjn9FOqZyeVp9ep5p4UCQPKxGSoKM8FyAQbfKW3gCrtLuO3Uo6T6EqZdKQebT/IKBCsaRccx10683VaS0M2cZZU/ktTfU0T3pb9WJFrBZJ/b/05mugn/+nCI2+9aL/XB9qDrFz3Gxm37nkDUQzQq9XnR5sVCAphk/Tk4E6YPu3c8eySQwlLSaoy4PNsNdksWHLNzNyjBcnASgvoZWA5gTx/f3Jh9RGQqbAueHUzOOAsPKjZT6SKHMAkCn7O3ZEN7ubN7S51BWwE8sxsqj3nPRzoPoDZumXDk08alKvL9yIHGc8iGDdRT13l25Hxn9Wuk5xeKx5wAN6ZJJqQV4clwla3KNIunWZDHu5EknpTtPQVF+JaPymf1V4bMybUkan3N45pfXtACn9GUznP98lMHdzjUWhG/WgCvGVT2M4V0G62/OWPx/wI1stiv5GV9CcrnBh4RLpxtx+gclmI8KcZYHJcOVyFLiFDOu8X4qC+ejI5HdPbysEzqABYFsXIwrABa+nfvLlWJ/kPbwcU9Cc1BupkzG/I1yTCFFUWd4dNKmQfCC/nwWWW8cE60fgqeHltNjNoxeXzouZlmYsypuYF1K7dIIdr2ouoNUjfhdb250xApqYCueiGeR806LgGat6vw/ojQXa80Mz36/9sFIp01xFa+neyzo7g8bP0JFxNcZubaGliosqwmEXvbvJbgtdiFcMbZRorEDdXc00+BHLLkMK32bVcUI6soIJwIuE0Sa4Wd3pjQ9vXf8eNL8djx5bfReKZYSyz1spJSO7vQFvwUR6PTu0QUIjlnQXB77xtupZfK5zYOpLvE7VDoW7VkuVYZPz75mNgJAj53m5+8FcqLhywNdK7
 yj+VRxjO
 oSTOldLw9AvyXH2+BiUuP4vRlRwP9N39qi+Vhq9tiOW7nSi8Wu+XrLYEXtzV/JR+7ydi116TZhKI1GT8odrbntzRyJHpmtyBl9ILmftpeKMY2XyU8UDiV/T2YeuE6IBNp1dqDRZsev56NAFqFGx8ZPKTvetHcOeqMjl2QkFctotXAHpLvzzLycWVfjsjxAjtRUEqPzpKX2OBlCgCMMfRldP98BGgKA0A7ACEPelB3DmytxTF2lYTNcRBCm74w/H/Ii7YvgpOUAhZawbC9YGmeRCZ/MoXPYZ9oo1kKZAvOpJsa2hmuRYtzPRavFx1icFtd6vFadU5RhLS9oTiM3gAZcAY+RiTs2xnGXxeKrdMDsfPB5OTw3yztKmnaw9hnTauwOAQCdiLNn5u/uM7YnEVmqK6RLw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A hugetlbfs mount can limit inodes with nr_inodes independently of size
or min_size. hugetlbfs_statfs() only fills f_files and f_ffree when a
memory subpool exists, so an inode-only limit is enforced but its inode
counts are reported as zero.

For example, a fresh mount with nr_inodes=4 reports zero total and free
inodes instead of 4 and 3. This hides the inode limit from tools such
as df -i, even when creating another file fails with ENOSPC.

Report the inode counters when an inode limit is configured,
independently of the memory subpool. Preserve the existing zero and -1
results for unlimited inode counts.

Fixes: 74a8a65c5261 ("[PATCH] Fix hugetlbfs_statfs() reporting of block limits")
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
---
 fs/hugetlbfs/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 01c4d6f44ebe..e94ee8e17004 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -1113,6 +1113,8 @@ static int hugetlbfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 				- sbinfo->spool->used_hpages;
 			buf->f_bavail = buf->f_bfree = free_pages;
 			spin_unlock_irq(&sbinfo->spool->lock);
+		}
+		if (sbinfo->spool || sbinfo->max_inodes >= 0) {
 			buf->f_files = sbinfo->max_inodes;
 			buf->f_ffree = sbinfo->free_inodes;
 		}
-- 
2.43.0


