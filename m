Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D6CE606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 05:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sohsIdi/
Received: by kanga.kvack.org (Postfix)
	id 135EE6B05BF; Wed, 28 Oct 2026 01:18:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E73A6B05C2; Wed, 28 Oct 2026 01:18:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3F1D6B05C6; Wed, 28 Oct 2026 01:18:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C5AE46B05BF
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 01:18:53 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 47B7EA8A00
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 05:18:53 +0000 (UTC)
X-FDA: 85370880546.29.6952C92
Received: from mail-dy2-f8.google.com (mail-dy2-f8.google.com [74.125.229.8])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8F52720005
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 05:18:51 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="sohsIdi/";
	spf=pass (imf13.hostedemail.com: domain of dennylin0707@gmail.com designates 74.125.229.8 as permitted sender) smtp.mailfrom=dennylin0707@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793164731;
	b=7Sm27mcNms3xKBkC0UgvZOW9N3SvoQ0eDYFE6LUwk9QyGofES7FIK8ifz8KHkrhsRFX2K2
	wOkP3icFchi7shSviBhvmjDcIoSacjMKQ6FHwM0MxzjxmuMwFFNrAtliO4XifLtrQv6kq7
	mY7IKAQ25tyzbxzhKMra5VGgEXFmH0w=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="sohsIdi/";
	spf=pass (imf13.hostedemail.com: domain of dennylin0707@gmail.com designates 74.125.229.8 as permitted sender) smtp.mailfrom=dennylin0707@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793164731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Kxy/cpuRLXwPgzqyyNI31i8ZGa3rFt0MAU8X+pyKMqo=;
	b=BcMf1+c3tTY2EqSjzcESmfaHtKocZku17+V8rws5u5FHmap1WQIe1uNWe8lq2h7h8ax5U8
	ghYt/cucxQnv/Y9kxDd7HRcex5E3WYIDUMYH0uIxU0W4io7FrXexDf6EBfcnndz2UsdjG+
	aHD+XXmZ5Hhgj5hWuHzYpNAZCMB6yew=
Received: by mail-dy2-f8.google.com with SMTP id 5a478bee46e88-36a24f47293so82718eec.0
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 22:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793164730; x=1793769530; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Kxy/cpuRLXwPgzqyyNI31i8ZGa3rFt0MAU8X+pyKMqo=;
        b=sohsIdi/DaWdygtEvQS1ryfqsModS9r4LGiVbf/qYSZqOGG6cidoKRQ5hXYkg8aXFk
         DcqHlSIqHtT21qPFbRb1prFscjh0FC8WNUnChmy3RThCNkADY/P6Jb5LnCuXONLThtmx
         srpttMQNJMyHvVQuXYDAcW9ueT1rnQKa2vaOr/F2kktVbrsilHxRSzN1PUCUbqInJ2u/
         PmUg5t8HKYQc+8902KJNdO/vBdJ+GqrqKuWlgYp9dHGZkYeULqVC9iqeZTW3PUGAY3yR
         soe6U6YWVOELk7D3nwX2XMjQbSohDcwsKTVoGusYhmdDOnbbS7CducFYmRZtEDNKfeg0
         1KsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793164730; x=1793769530;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Kxy/cpuRLXwPgzqyyNI31i8ZGa3rFt0MAU8X+pyKMqo=;
        b=KBZJXYyk+OfqCr3E+tcl1YCT83U5wbEARyDBMcNNB0zRG77Fr+q/ljCYzs2xl6+cfv
         X6t4/5rjaKXdNr3VXnWPYnpRNweJF50g+XeBn1qEqcv22LLaISMGK/7TJm1vlg9AUB6z
         wivDifD1nRWFTe9T06HYhkAU7LNSv2acen9QAIt8Rtn7LfKvPPo8Xt/GzDuzIYva4c0S
         9oWP46bayHu8kaoUkMmibFM/eS/uhbWLoGMQTZ8NXsQMHpXT7pEnCqbOsQbclep2KznL
         5Zqetk63/Cy5XCbGlUQJADEu4E4iDodya8QWJGmm3M6hu7uM2KjeGOqA+QkQphfcolFL
         dRGg==
X-Forwarded-Encrypted: i=1; AKwUvBxHvU4mKD/40AEEHyuS0VVuauG+SyHuog7dDpsaxr3Ca6/v4XLsaxgiRpx54kDVcS2Vvo3hWuNVKA==@kvack.org
X-Gm-Message-State: AFq9FYIUyRX1RyEzHKFJbeJQDCcwhqYuysb/HJNXzMqRo/IgxTiR6bEW
	zK30yjx+tyKwMN3d4okFX2xAhBQPR8bv6v0grlrOaOkK6P139bkm7dbP
X-Gm-Gg: AYBFou1L7SVyqtLxlw1AY/qPNG3tilIw5ltwMQZfT4ZLrtx/Dy4y89WovJK9m17MNYS
	3JKcViV8iJ3N/Q68tPrDZlh5qYW4sgNFoAHaJS5agU6TCOYgNgEfK6hsu9OoKDVpr4+wJ+JhS+A
	xGDjskIxRAaY63WM4gP/UuG8e8abFDT8/qUkSjTuiSHcMtoVufRSqLR5khT5vapI4rgL/I3bSws
	8My541SioRgcGTm84nhAMyVSqWJKa9md1u3bUVNxIr4OuLNC5Ckj+E4G7cNOxY4T5mwfajuw3QD
	ZxH5H4krbJSCG3lULZD3ZTrHCSMDfHrR4NBrHB73pJSTTuRedpm9nSQvQyxzpJfcvHU/6cU6Oez
	7zMFWAwxI1XjGvJzia9xho2/ztag/RMiqlGLK8LglbDxrsKVchi0Al4tXH7z5mXKUPWNIMiV+R8
	38o6FHzpE+3Al+X7GfvavpAZTcojM7HPaZkmi1ow1FIYYBH80qKRCjiPG+gAd8SsupflZgf7f3m
	BaHyAVclenIsePlTtx4Z7DUJKjtIsRFq19opNISTOOmmP2qyd4kc9xoFWFFC0/IYuPkAVH7/cMr
	JFa/XwkYbaeTPSh65mn2iLXyPD2n9nU1Z6r3Jpeib8XRS+Lvi8dzozLf
X-Received: by 2002:a05:693c:401a:b0:36a:1b95:fc75 with SMTP id 5a478bee46e88-36a2040717fmr2696113eec.35.1793164730087;
        Tue, 27 Oct 2026 22:18:50 -0700 (PDT)
Received: from localhost.localdomain ([98.148.34.5])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a237be80csm5255949eec.2.2026.10.27.22.18.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 22:18:49 -0700 (PDT)
From: Hungyu Lin <dennylin0707@gmail.com>
To: hughd@google.com
Cc: baolin.wang@linux.alibaba.com,
	akpm@linux-foundation.org,
	tim.c.chen@linux.intel.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	dennylin0707@gmail.com
Subject: [PATCH v2] shmem: clamp negative used-block samples in statfs
Date: Wed, 28 Oct 2026 05:18:26 +0000
Message-ID: <20261028051826.23058-1-dennylin0707@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8F52720005
X-Stat-Signature: xntndgmjcyb58uqf3niri1789cpxn6cy
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793164731-428792
X-HE-Meta: U2FsdGVkX18SUopWpVqFSXud/DMi80iFrZtnOo6fGrWgNKgb5K+ZcrNAQhjLrJOHlm5HHtRsJW7Y7A2BuwNtf/aRLz36OWigfNMFDmYVrIif1x/kWjjbJeWrYR33uajdzuZYQhQZTssvUWk5Z1NYutV2QRN9dOI/u2RJzwW4OcGuG8fUVvkfD95fvUKv67wCSCC2FnsskU4dv+luFahPXjytcIuAPyL8kNGUVABN8qmmIpm5GJDsocLcCGt5Zs7lln5XGEgPLp69NJi2rtyJ+xwsmAuaR9UP9iEAAs90LoNy8y3c85oIScRCUJtGeHY2h6NDZybfH6deiIyZ7A2Er2pusT9h7703CKJYZCkHTA75UyBUpJnGDJnLAJWyzIO9fHdz2H7UaHzprlaso9XhTCkeHBFRXt4TyX0/Lr+xghUmNv3dlIzvTGGhzDmHM0++JRPaJsutpd++pUA0vzPfnhm7Ahr/6FdKLDvmAr8jKydMOLkbwc77beiP0MT8a+vFJ9+YW4+DNBLq9uUZFgnxTtJULsefC5y5ZcDa914gwvvid6RZ3KfjkB2ucQHedT5y4SmE4KMhuQ8lP+iDlB18mE2cXwS8yj8hrcb2KOCzOZuj4NrmXZ2lgC8pTSQvNQKIMLQL9IakwHOUpkuFJw34EjERT+c+sMOhG04SmpQkA8zjW6U8/th6qAFDvkqb+8bE0IXjSLdJKNlDMkymeN8Ie5zf6a8UYGTiTmCf28wZxz3ikhSM209t2SRZED1Ezs2lXr5nJzmlvC4xLKMKDewvEa11TchzfGSa5pNa5aqp1kr5sODi1oUClNxvoKZRCuQ6hwQeamFM7S+drqHadKx2pw/3tMgqiSRnHYt/2hxeRVBhSlYnjlU5no9U6FzUB08oKWrC43344D3xRURiMauf8C0aczuTPZIykKLkaZPR4JsFmB0eO4gSjxRH8A6RhrYdl8NNmcEc3SRwedYNToQ
 4XNN/xb7
 3kV7RkWyc3mU9jqnyJHoVATHAjLSHtfFxOweUvrJJmmlQPZSCJq3P3X/JGL4s2RhgxFdjczkbtmssOt2Sw6u0Cj5KgOiHbCPLG8RHDnA+aTNEhECkeCIn9H/AaNbVfS/FNO9BVrDm62W5MbyjH9vqXovqApVk1gKcwIbxOi63j0h+jySflLWlPnEyutvAc4QtzsiW1AooaTwfcBqu0Ha7CKF+MqKhX9Fd1bsgQKDsgpEiiBC/sxDxqoE9R2qgcmy6vOxPVPtFuh/wEJlbjSRH3kmp3zXV0mzcImYQZDMoA7/vtWOI64PmcT6dWOtFds4CWQg/fJ/d3ZmRBVODfl+mmKov6/5H/kpZuop7ch7SHiE5n/NiJXm9xBLbMYV7b7iPX+iAaKzFp6/YC8fK3b+C7gUjQ4Hqh/jjtfaWRMdTKCvG7UXi5BWVcgDdxw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

percpu_counter_sum() holds the counter lock while scanning the per-CPU
values, but local updates can still proceed. Concurrent allocation and
freeing on different CPUs can therefore produce a negative sample even
though the number of used tmpfs blocks cannot be negative.

shmem_statfs() subtracts this sample from max_blocks, reporting more free
blocks than the filesystem's total. With a one-page file being written
and truncated on separate CPUs, GNU df reports negative used space, for
example 67108864 total bytes, -28672 used and 67137536 available.

Use percpu_counter_sum_positive() to clamp a negative sample to zero.
This keeps the existing best-effort accounting in statfs and does not
change allocation or limit enforcement.

Fixes: 7e496299d4d2 ("tmpfs: make tmpfs scalable with percpu_counter for used blocks")
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
---
Changes in v2:
- Describe the accounting as best-effort, as suggested by Tim Chen.
- Add Tim Chen's Reviewed-by.
- No code changes.

 mm/shmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index d97fc32e7c94..092bb45a076c 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -4005,7 +4005,7 @@ static int shmem_statfs(struct dentry *dentry, struct kstatfs *buf)
 		buf->f_blocks = sbinfo->max_blocks;
 		buf->f_bavail =
 		buf->f_bfree  = sbinfo->max_blocks -
-				percpu_counter_sum(&sbinfo->used_blocks);
+				percpu_counter_sum_positive(&sbinfo->used_blocks);
 	}
 	if (sbinfo->max_inodes) {
 		buf->f_files = sbinfo->max_inodes;
-- 
2.43.0


