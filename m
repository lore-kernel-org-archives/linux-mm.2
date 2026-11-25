Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0938E606A32C
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 06:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=q5JFsByH
Received: by kanga.kvack.org (Postfix)
	id 281BD6B091A; Wed, 25 Nov 2026 01:15:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 258F46B091B; Wed, 25 Nov 2026 01:15:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16F546B091C; Wed, 25 Nov 2026 01:15:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E58D76B091A
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 01:15:33 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7BA46140843
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 06:15:33 +0000 (UTC)
X-FDA: 85472629746.17.7E2482F
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	by imf16.hostedemail.com (Postfix) with ESMTP id C82A7180003
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 06:15:31 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=q5JFsByH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of zcliangcn@gmail.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=zcliangcn@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795587331;
	b=5WRHwNnsNRtU5zSKusNI30E3H2lqNyKjaHSgETkjb8a8QLmYHNsLin94B9+ea74CedQ5yz
	Z1ydPfkCCKZiElOz7vd7NPFyTNdq69HuercZJ5W07DegicA+8GOK+A3ZmFhgfUh4tk2gsQ
	8Gu9j6Iw5hCdOcj5DJMzp3uI04tsQVw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795587331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=GJn83fHmEkvzSXvNUuSjTxCL7XacZsUzXMIbSueFZFs=;
	b=UngoMIgcc9VfnCgosL8qQzZ51FXq22qIV0L+SVBDBCzefF4CjIckFrw576JsRG7PMstuFV
	aJguQ3w/Ydwes+zAK8OXDqrGiGB+2JWlpo7NQlQHYFEa6kucgOp1SNGErnD82HnGcBBJ2F
	AQIZrBbD+ojkRwoROGwglTf0zemq05Y=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=q5JFsByH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of zcliangcn@gmail.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=zcliangcn@gmail.com
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-386bd881d39so3737198eec.1
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 22:15:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795587330; x=1796192130; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=GJn83fHmEkvzSXvNUuSjTxCL7XacZsUzXMIbSueFZFs=;
        b=q5JFsByHrIlM7wg6y9vLSWggn3E0C2NxtdZYdMVtREm268Zt9VYWwrG9v9ASx2Fu4F
         Sm2GAWSQuytxz06cAxsbiiV9eU4dTvVPOkYtpfbmxXm+ep6epSJtQpLEm35JQcC9ZL4q
         0RQ+ZYL4xz5u2LeXujuSn47d1xqudJUBJGbRN5MS8ReETLz7EhV9SD9clOHHx1EApDCO
         FSkmcmz8fZzcqEfpt+e55gUN4acvVW63Jr/PEihlzoUUw6d6ujpH0J6FoN8sY/qvyfGb
         0RgvmM8uoiVQLxldQGFzKzQD1SzyVO5u8DdHPuQNfatTj9Jg952ilwN0q1AKBj8uD9zj
         h13Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795587330; x=1796192130;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GJn83fHmEkvzSXvNUuSjTxCL7XacZsUzXMIbSueFZFs=;
        b=KqHLw7IyqZnAQmNfwlTOgXlVI5dGgIaWjFCzgiNeuXMKuVzHopTlTxABQd+f2rQpMf
         +IpxruKqgabseqAjyN++9lyZlJIG0lbq/ELXozALRN7LBaKpfVILDah0TSNzVMvaqkg8
         VVvafQ7GnHwsMS+WPTmWV8KPWtJzQtH7BbrH7zanw7Zh21Xk8O9TEFOJ9qmJ5ELcPW7+
         LbByBMmlOTSJK1ovkoSk4NVCpD3ifCcxehjmEl0NIojG7x2028L4Htci9lhdm7ClEVMX
         TMsNOpqJ/C/nbSglNPzuQd3JtlE8IVn0z2M5hcQP+7881UmVbqIg1pJQv6ZznmmurENx
         fiwQ==
X-Forwarded-Encrypted: i=1; AL+hErF8rS3fHdEde6C38Mq+9P8E3VZmPHtYYILFbqGZ+/tzzzjFL5W8+rg7GFNlWJivZ1Vng53eVQ760A==@kvack.org
X-Gm-Message-State: APuU4Z/tZ+C7TrzPuO7LfcMUOWypibg7ODgV8fnXi+WItkHFXTneRKXW
	rmpW33DSiXMxXR38bgN41vwFF5F27LjNg9+zNubInjimagy70ddHFoy7
X-Gm-Gg: AZFdTZcDKiW71vDaLbRWNMRz+xb8GrzKVru/jDat5hHBxw3ov88K/TyVPSvq3GIbtHA
	nNkRYnkkMRmHQuu30P1VPSkRvUJ3Ui9tP4gQXuMN/+vYSgaZnQ/o8lAjqPxopx6DLf2W2DR+dV0
	10/6Prsh6ClfnMDJkHZugRD+45w2r65QsLoF+gthcy4RVcoXsoH8lRougSkRspthsSqV9fcg45I
	Fh4vWX4beJzSGNt9OXzZDy/gsrOrij3Km8dId/83k8PK3ohHMCOSOyMu7HOFiPQJVNCFjWB31xU
	GQowE+OnOnzXQolLVb7ZzDZL4DVCbHqIObRfaYciv4gKGEYM9PggMQSJLkZROHxtxTnZQSVbB7h
	CzE6kpXivVyVfybug31bk/TTVi2bB0lLqY+v3xtWO5bQiQUReYKsaZOXbPh0QBW5i8tVlTgly8e
	S4acQi/2A/lqxru3DGeUdSAP8aET9gXFnpp+YmERP/m+rDb5fIZI0Fwwmkw1h8Lkusk4+IrLjQP
	MdcNVJefitWNoDCs2UQ4DBRfbuk5sl3cesCMM981wuXTNeA5nwd52mIQVWNyGUf7KnA2Qx2E9S4
	69404pvpLFotuE8tTdprLHuS8uEC8feu6waqpGKCdGBe8BynEq4yuJnOzMXN
X-Received: by 2002:a05:7301:4710:b0:378:314:4042 with SMTP id 5a478bee46e88-385702587c5mr16061924eec.14.1795587330274;
        Tue, 24 Nov 2026 22:15:30 -0800 (PST)
Received: from kq.cs.ucr.edu (kq.cs.ucr.edu. [169.235.27.223])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-385666e99fdsm62468634eec.5.2026.11.24.22.15.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 22:15:30 -0800 (PST)
From: Zhengchuan Liang <zcliangcn@gmail.com>
To: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Davidlohr Bueso <davidlohr@hp.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Zhengchuan Liang <zcliangcn@gmail.com>
Subject: [PATCH] mm/hugetlb: stop hashing address_space pointers for fault mutexes
Date: Tue, 24 Nov 2026 22:15:21 -0800
Message-Id: <9a97a64f7e7aabc668499c426a2417a77d13a2f4.1795587203.git.zcliangcn@gmail.com>
X-Mailer: git-send-email 2.25.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C82A7180003
X-Stat-Signature: dwu33f5g1xxmfmwxzocthmzpsbgpfded
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795587331-686749
X-HE-Meta: U2FsdGVkX19yt6zr1ESyuV/e5b6PUsnX80DCbGtvDCdkDFi+0dHQpKosVMDQncJJp2en0VcMgK55dO9yiwx4RA0FMnsheYZLWzyeNDMn/0+LuQG1o2FyErXRdHcMgUXYzjduxieptrvpM5yBRmjpw3lpeW69rNFdMVtm8KcshfsrJFkglvsZX/A15MqRCpQXTS1xGg2Sp93jJXh+Mm0bzdBgrbiz7dIE7QAsWvdYq6hjIVpwR94+IuFEF4mqgrEBdIcH+mxWHi5JdWU0Cr+TrpuntXvQV/P5xTzNDTjRhzuekFecbsHnUIlDjoZR8Nn3AGCD3owAN5flYmz0/swLLhW5Ak12isHX2BYW2Qy4FDlA1oZr/I1Z6Gc97fEUNyI4O3wC5MeSV7MTKPl0CWIzpnHccxvR/CfKy4EZtYJWDGc/cJ0fvmcHHkndL2OusYsNl9n506IbH7xxWilLmVbgLYfGnzZjLbSnAPirLW9NZjjogmtwzY8SWAct0CvCw2vUbIUGesUP7sRjHaZALolkHa2c3hctt1ZVtBC0OZTnOIPQUHjI9yRV2dvI5SarNgVdkQNqYT0EtPXyMI0fcBLByJ8o4nPYHa9bPo1jCyKAudPnhKQcqwOvAkonoFsaYaLJff/Ln6bxhsEvv2EtseFPEkvxBWlfSVp8TxHc2y7FJUx4sQesGC8XAAKV802DdXSyklCtWUGtKNPjrwO5bdnprXqMl3b1HwG6t8nO2wJcAOcjh0l8PPvxTcmdLk5EThyoYbwlGaW7yInSMJKyAm3ecJrTg+kJzinJWLIXauHumKMNjdWZupeXnpk+79+k0jW7dbPc3Nju022CU/zkT+1DoXH9VkmFm5U+UI0dZUwllf7pJ5WKGS6klwBwPSlf/5K1UfX60KzxbSOt1L+z0pNYC3OmePU3+A8qoxrZQfRMqKDuBwFZGNAiha2OOBy/dvESqtS8BWGKC+OEYwkYH5D
 i1EsW8ln
 VP3qfoaeQAM3trdF/dq5W4B1w4c7TSibMX4RjhpOIFmZmYaEPNr4v2GezOGnOM8YzG4mfRH82fEUuS6NLJGWmuqURe30NvTPG23AUONWMdqshqJ4E5nH6ntuCdmAAwF6HuEK35uCdkyQH0gL+yfEZLfOAeeFNJKy5zEw6SSiOTWRaRomEmSgMwjvaPTSPp6f1lXhfMYOJoGdmTZVdGF9nOz8ZSZZjzCjJZ1+3r9pHqJDXTEvRD7fAdALzf+NfC7x9jWwUHLXuEKtTTHoXnQgaNTdtGNuB1/sXSGltnSznj9wrGI7kZRqmao88WjbUXI7rn+P8/DDpTA9SIFrcMdMn3EE0uUBhvEjs5Pjt6hbliLVijjk0ChlqqCmKr927isUElzk4DMex2T9SetQkzNInpGAcqRqYgcAWRwRVAnN8TKzmb4XtZ+ksKlW13Q8igCs5E3s0EWfHihUCpwK0L9TvBKiuJ9e6ESuFXcKWkMMkUOYpj2hE22e0oaj6pHUa+b9qOcnE7AAvVO+3F3CIMCevK63HoYrWEMkxdVs+B6klpXT9tersdXfmHoHRRuVdoz/q1KA2VKLH/2AdHcU90EoizMIDrGAtIxQkWaM7yMbPSGm+aDUlk/l3c29BYh2QJuZXhXCo3JxDmAH9gJADmGMtob4X+NYMTIdk6kc+kTEYoA9QQbDTJ6N/gMA8ttAhMFC4hq7U
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

hugetlb_fault_mutex_hash() uses the address_space pointer and page index
to select an entry in a global mutex table. An unprivileged user can
create a no-reserve HugeTLB memfd with an empty huge page pool, build
contention on one index, and time SIGBUS faults at chosen indices.
Pointer-dependent mutex collisions expose equations that recover the
exact address_space address.

Give each hugetlbfs inode a dedicated random hash seed instead, and hash
the page index with that value. Operations on the same mapping continue
to select the same mutex, while separate mappings retain independent
bucket distributions without encoding an address. The seed is not
relied upon as a secret and is not reused by another hash table.

Fixes: 8382d914ebf7 ("mm, hugetlb: improve page-fault scalability")
Cc: stable@vger.kernel.org
Signed-off-by: Zhengchuan Liang <zcliangcn@gmail.com>
---
 fs/hugetlbfs/inode.c    | 2 ++
 include/linux/hugetlb.h | 1 +
 mm/hugetlb.c            | 9 ++-------
 3 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 558007fa5e88..72a406b97f9e 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -35,6 +35,7 @@
 #include <linux/security.h>
 #include <linux/magic.h>
 #include <linux/migrate.h>
+#include <linux/random.h>
 #include <linux/uio.h>
 
 #include <linux/uaccess.h>
@@ -1182,6 +1183,7 @@ static struct inode *hugetlbfs_alloc_inode(struct super_block *sb)
 		hugetlbfs_inc_free_inodes(sbinfo);
 		return NULL;
 	}
+	p->fault_mutex_hash_seed = get_random_u32();
 	return &p->vfs_inode;
 }
 
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 58f755e70e96..61d833b7a76c 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -504,6 +504,7 @@ static inline struct hugetlbfs_sb_info *HUGETLBFS_SB(struct super_block *sb)
 struct hugetlbfs_inode_info {
 	struct inode vfs_inode;
 	struct resv_map *resv_map;
+	u32 fault_mutex_hash_seed;
 	unsigned int seals;
 #ifdef CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING
 	atomic64_t pmd_sharing_count;
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index ce9c8e57b8e5..6865ff468343 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6091,13 +6091,8 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 #ifdef CONFIG_SMP
 u32 hugetlb_fault_mutex_hash(struct address_space *mapping, pgoff_t idx)
 {
-	unsigned long key[2];
-	u32 hash;
-
-	key[0] = (unsigned long) mapping;
-	key[1] = idx;
-
-	hash = jhash2((u32 *)&key, sizeof(key)/(sizeof(u32)), 0);
+	u32 seed = HUGETLBFS_I(mapping->host)->fault_mutex_hash_seed;
+	u32 hash = jhash2((u32 *)&idx, sizeof(idx) / sizeof(u32), seed);
 
 	return hash & (num_fault_mutexes - 1);
 }
-- 
2.34.1


