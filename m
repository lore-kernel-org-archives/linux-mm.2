Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D54B8C61DBD
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 03:06:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D30A06B008A; Wed, 26 Aug 2026 23:06:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE3896B008C; Wed, 26 Aug 2026 23:06:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD3BC6B0092; Wed, 26 Aug 2026 23:06:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8699D6B008A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 23:06:00 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0059D12030D
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 03:05:59 +0000 (UTC)
X-FDA: 85145560038.16.EF03244
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4FD731C0006
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 03:05:58 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SjfTFPZA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787799958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=+ABL0lVs2T4omHeNrhqinBnCW8Qg/CEyqGSbYpdEGHI=;
	b=YPqHWSJGoMKl6EVDUHx1KjK1Hi7NzZGbOpAnRPVJCezzaJeVlRczo0k4lhyQt93j557+p1
	A1dZYaltAz8lVAY1mgH9Kg6hZT5cNNLOmVmJCLwzEpWb/QOWmPqfnKPDtSF0LdF6lx88wG
	tNV6b5n4q/Y27FPrBpMvIrngwEalCd0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787799958;
	b=fkOVmdrSRUi50jo9JJ2PRRlb8veSwWH5Z9Huo/JF5q/TysQLYdAgLN9B5WmdH0qUdp1bm6
	/AsLr614JTgMRAEX7tPVk9dBrZwHzL3TtqH6VQVMDcpuMc4q9u99VaejzVF+RP421F4kpg
	3k2+MTPol/JwOj/Z+qnVlhRZtlCeHZ0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SjfTFPZA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c2530cabcf4so156518966b.0
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 20:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787799957; x=1788404757; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+ABL0lVs2T4omHeNrhqinBnCW8Qg/CEyqGSbYpdEGHI=;
        b=SjfTFPZAoT/0/pvwY1ZmjvR/s3O+cvaRyVSr/fd2j/g880puHg1RnSnGjhsgxtPLEg
         XEAQW9pBzaj8HgTk2yv39rQeEoHXr9YQMpSVLuKksORrzVOdbTIWwF72MaVipUqZ7qnH
         bfXBP7zpsWfKmgEeBgyjoE4wr/ei+KZDzha9sCMNyG6l8eiphKIOeSy9toqHyYnDC+Yu
         SHrS5SPYrJ6DnS+a60rqm3qb1/q2VNbHaS+WIlKVXj2LM7kQSHoxfsaKEVjdfyPf8X7f
         cfvLTZm/KjpvbHswbH24cyR8zLWFwKPCBPQZw0bGajWNl0ymLAtYLE5yOzmOYjolaq3F
         hQHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787799957; x=1788404757;
        h=message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+ABL0lVs2T4omHeNrhqinBnCW8Qg/CEyqGSbYpdEGHI=;
        b=cfcFv9rp1m4RD6ogrDepjtIeC4Kxxk5qS/eY6vXS7FrOBLMDoNaqvdf2iPMsWdb6hz
         5QOs2d4I5B14TefQXgQm7P2Ihls8K+XI3mWXoY7/1Wc3Q1u1W9e8UoMN/XBFqOXyhN+p
         xRxy+F2SMNh8ZnSORBzOfw25Rj//Drhaiycf06ieq7MGMeXij0WKu05wKpmZppZpx1Lw
         B7It+jUxoOvrxPwwXJty+lSQQJzXWPjpVo3KcCy8CIfUiNwljrdPf+X0IqTL47InJ45I
         MR48vxzIXcVlRnJGsOD8D50me3YdtFScluHFw03W4rNLlseEQyKUfHLxlzS3wye9oDC2
         DfBA==
X-Gm-Message-State: AFuF++lCqIrDSHjdwxohJ0+fio4Nxrp8e8tyk4cu+YIWac3wp1WAlaSP
	N4Bs7KkejTbpgQlyhtCC+vHvgjPndV1ZY4NS/xjS/rQSar5V0Vlwo7Km
X-Gm-Gg: AR+sD11bDLQGz80BLxaFBsmiRMqD7UapHOugH1/e6RDU6rguEC81jWIRBrj2TvSsiE/
	J/YTcuaeBqNRXIME7LIT+HMUWybYtrqkrzXm/enNIeaOtu1KyGgi5zy+t2qQWjgzBqtXbiIxxrE
	BdAZmJfTpwbrDtCyRp6JId+Uk0D7LczcBjyg0MkqSxZQO0/AFudmuY3YbUUTAvrLAMo6wNVaXWU
	Mr3VGT2cAI/IBp3pJ/V0RRE/YS1ErcluyGFNZDTsU1DOzh31Tm/BWg0aWx7y/a0qniKNVCtbu/H
	C4LS/Z5tZg8EbbGU6g8vtavQFjC1dkAYzcKQvvgkfHnYWPpkXKMgUt9lMGpKHuLC9GuiAvqZ8IW
	FO/pngp+vGdYgTJoX9MtHHgun6uOPWxkUWsfmaheNEyL7DQ/vrE4+XzK6KM0wDozpALnIOGSlXf
	dvWwsFixLTIUmsz/R3NJGboJooWtRrWYuEezJrvrnKsFISyDaZfKXCGBZ74Hgj
X-Received: by 2002:a17:907:944e:b0:c24:f8e0:f092 with SMTP id a640c23a62f3a-c250bac7f88mr1102590766b.1.1787799956563;
        Wed, 26 Aug 2026 20:05:56 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c250a9ef92csm690682266b.63.2026.08.26.20.05.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 26 Aug 2026 20:05:55 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Wei Yang <richard.weiyang@gmail.com>,
	Baokun Li <libaokun1@huawei.com>
Subject: [PATCH] mm: remove out-dated document of __GFP_NOFAIL
Date: Thu, 27 Aug 2026 03:05:48 +0000
Message-Id: <20260827030548.16631-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4FD731C0006
X-Stat-Signature: eh7u1cm3bmm7msrqhd1btmauyggxwqxf
X-Rspam-User: 
X-HE-Tag: 1787799958-803334
X-HE-Meta: U2FsdGVkX18fYktM39Cul9L2tVcoYNOdWDek2Mrp+i0gjocCEZZYa2bfxPMCV1df+jaYKa1HE57r0fNeug4tuRrb3PNuq1891jDx/pXgNMPkd7/obWS2T5CMRPOaGwDuFQjVEHnUUzJuTACEAfkwSJSW//blW0fmPPj72VsWBuUeVXZaRTDfKNQxemBD1WSJiDdUn1ybaBu8rjf3Lbb3WKwyLlvANFRgTwsEZ+yKoN2CDXRSI2OsXwVSsMJdBo+gq1FMMOWM4TDOAN32wCC0Smh0FCnWwhDLBUWSfgQ+hhua0JyEJOJRgr7MzrgdBgS/kjqYYVmZzEeyahjMFUQFyl8BgJI/WHruq8rOBOs1XJDsORDE7/Q3e6LzdwgU8WzsVgYNqft2m5lnRpOLq43RbOkKxNFAENZiqMLtI+rkQUpVIUpsUI1Vws/QHf6PLB6G7Lem8tGV4FgYNjPnlCsSPvAPmyfsBx9QUOpTBm3g9dpjziwpVRbUGJZSgMSSGvEZWU1oxMdeo4NXxhe+DLOrZ/AJaLA4zeBvHgPfufftgDYtWTApBN6Xur74dMs24/NpQpT7o8JUKVa6C6G1Kb6VeK7EeYRDIvhlTTRcKZA/Gg8zqkO3h2pasHvs0AVgulqb6cT+UzFU3iSVqUMO6QexOuv0Rq9UWA9B979INHQMeL/bC1qkbNpNizA4M01sIKGU5v4FvpB9Gr2ZCQWg9af2NDFT2qfpLkXQzX8ijhZlc5mwGxicQLlnE1WphUIPSR9+t78Yxgla+YKj5KWb1HTIgY1Rd5XAF8YeGCyRwip7Jm0MA41wvAOmtYcVF7VUcB/FhJ5ACnMgzAvAxokz+XjlVpC9AhZG8NmZbwy6wEGvpb2+veYQ54NMYweLEFznHgEP/FCGeEdrFH31qYnAGGOpeqggzVZ5nGrZIV6YEZmH1N5v1ft5h42bKibwPCGp/doUCx6MdzKxg6F3EpMBpnG
 YvNftIt6
 1wbbYzfhGJZad/nDPOzZbL9cgXke0PhmvB/NlPS8KgeWrYsH9htNymXx9CF4D7ROUU67BM8sHQEz3LMQinqLQsxP2JxyIotOYm9lp1Nu6hOhSkdovuDXdW5bMJ3k5ekqYYOnkEzq3OeclvwT8+eueCMAr6Ro/7U/3KK/99atGVdXlNBxM4Ed9nSIsHJEmaadz8yDwobRGPGIrrpW2WDbYUdCmQLgcpYVpD6+vz0l0ZqUEHPNeekDe2K4ZMhwL2WcVQ0zoaeoUpZMpca8dSj3E927rwn5tjVR8LGo+Err4mbxk9rpNzx7Aro3A5D3mS69Oc1jSOuGyU7vzHLTkfuS/efNoORm446xGVAbIFhvXYuEHFSbdGBvk1ubf+AJvl84o6QYrJnUywEJ6DYjUNP+JqFj8T1EOSLi9dxFn88OcJhRY7Cxq48c21iVudWgsoS3bccgKxqU0jRZiWx5FEC9dDTOMK1LmIYaM4FAXnRwjN893sXAZ/AwORQD2SIylXbt4eVKnIIbmZf7GwcTjhKcBnFv17bYRywVJw0J5ctWXKasb9MTB5wDX1RkE1mHkEFm+34KMnXEXGfw0dnLjg8PDTTxx8uDmMC8TgIms0/CEv3e3cI4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit ee040cbd6e48 ("mm/page_alloc: don't warn about large allocations
with __GFP_NOFAIL") remove a warning on allocating large folio with
__GFP_NOFAIL, which is adjusted by commit 903edea6c53f ("mm: warn about
illegal __GFP_NOFAIL usage in a more appropriate location and manner").

While in that commit, it also documented this behavior which is
out-dated now.

Adjust the document to align to current code, and adjust the comment
while at it.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Baokun Li <libaokun1@huawei.com>
---
 include/linux/gfp_types.h | 2 --
 mm/page_alloc.c           | 2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
index 190191411009..24fde8eb73df 100644
--- a/include/linux/gfp_types.h
+++ b/include/linux/gfp_types.h
@@ -243,8 +243,6 @@ enum {
  * used only when there is no reasonable failure policy) but it is
  * definitely preferable to use the flag rather than opencode endless
  * loop around allocator.
- * Allocating pages from the buddy with __GFP_NOFAIL and order > 1 is
- * not supported. Please consider using kvmalloc() instead.
  */
 #define __GFP_IO	((__force gfp_t)___GFP_IO)
 #define __GFP_FS	((__force gfp_t)___GFP_FS)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ab385bc252cc..146f7e0a9462 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4804,7 +4804,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 
 	if (unlikely(nofail)) {
 		/*
-		 * Also we don't support __GFP_NOFAIL without __GFP_DIRECT_RECLAIM,
+		 * We don't support __GFP_NOFAIL without __GFP_DIRECT_RECLAIM,
 		 * otherwise, we may result in lockup.
 		 */
 		WARN_ON_ONCE(!can_direct_reclaim);
-- 
2.34.1


