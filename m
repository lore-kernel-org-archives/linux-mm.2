Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78833E9E30D
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 14:33:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAF446B0089; Wed, 11 Feb 2026 09:33:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C59D66B008A; Wed, 11 Feb 2026 09:33:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B49196B008C; Wed, 11 Feb 2026 09:33:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A2B626B0089
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 09:33:32 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3DCFC13AB87
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 14:33:32 +0000 (UTC)
X-FDA: 84432419064.08.AD63108
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6D266160004
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 14:33:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mAtw2T94;
	spf=pass (imf08.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770820410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=34CTSOm4KFPR0zPwtT9Yc2xf8bAN7Ltci530o4vZ20U=;
	b=MfbOxm72hMxZ/BSISFXs22p3XZlxBiL/eU/yA/F9RLyAbGUOqpNdN7VOdvlO+LYaU3d2bw
	1a9UmK5Ih7FEz+Ab7Kq9yJhdQaTVABG6Guu0c+uameYbOvKTx18eYPlceJ4z9eED+2F/jg
	zf4efVQsiqxc5IPWP9ankM1gIfeiXkc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mAtw2T94;
	spf=pass (imf08.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770820410; a=rsa-sha256;
	cv=none;
	b=gp/YxdbVzaNYt3ZHCtNv91IYt0qQSdYBVmk4cR+RZ5XO0nxAbbITuX1PjdQzIv4qPqkKcd
	s8dKz7JacU5BFLDur7jsPO35mGwL9TU9VPVKok/KSJB7aG7TA7x5Am+1VKUzz9PTHso4z8
	iLAdN3o+fY2YKy+DPgy44rrxWnWC1gY=
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-354a7b089bbso4179025a91.2
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 06:33:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770820409; x=1771425209; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=34CTSOm4KFPR0zPwtT9Yc2xf8bAN7Ltci530o4vZ20U=;
        b=mAtw2T94x1s8S2XhfH6krEuRmQMITdaXvnQu06vVfH0KK2sZw6UnqSQZel7vCGKRPo
         qBGyNDwan2qJ1eWEA+O/1Xy6HIXL1Fzq6nFRXDHBvH+sAvzbd0kKJe8M/BNzYN29Sbpn
         wHyVF2xZd4/EYjnomBWTqylwyuSzXGzqbNwM5oNIGTsqdZNmPqlfX3wf5AF6lv1cXpsq
         zat7GmvaNuxy0Pb7hKmUlVMiwYckPqP9fOvNWIbLF4N7tu45WeAKK1cHmEFR1VvIN8tC
         JqnDApXCeCEUBif59b3D4LxXr3mxQAgQstLDNTEHDfEp17nSIeKxjveFj8aVo6WNhIF/
         jTzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770820409; x=1771425209;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=34CTSOm4KFPR0zPwtT9Yc2xf8bAN7Ltci530o4vZ20U=;
        b=NqNiM3XzfTNd/UW0lDx/Zld942iUj8GdWywZROj7TUlS7pbxvs1VCtPwyE8+mrxqTr
         jnYlwpfMnH8p5blYKQcDwucugiWNgxhVzJj2u8jJEAkJ9G0wXOTbR3U4knDoDIq0qyOa
         hZ7wWbhVms/bUCygOALPduGXoEWEeC9nA5t8VTH9puAncAde1JAWU/aHN3dpOr7GfjW/
         RlLh2fJAuGg05ci2BOxCYwvgsc9P0TjSpwDg7JSZfeHf4vyDAoBCMD2v+liwDMHCf/fm
         l0HSDdu975tQcymQ3+0yHqdnm0m8xUQQLT4aNpXm+Prs9El/n/VTyFs90bchURw4/m2E
         0W4g==
X-Gm-Message-State: AOJu0YxNn8dS+B7PgxXRzXqwOtNKwlMnrDrVfykj7a/17DWk3c+WOj23
	5HC/vysZ2ut4r1TF1OO4eml4GmK6DoxsaMBgr42B/XhZg+VvxGd3xMVXLHBf6A2PjrY=
X-Gm-Gg: AZuq6aLm6cGJGjeiP79WWxcVZ2aDjT8Y8r5Ob0+8JqYnrSGz4Z9/ukUbh/xSAityNdF
	7xQh71ycjdRqve0u3WCwEG4VnC0EkhdA1C296SpP/JsDkh+PJMqeXfGHwluxxcEuLlOeLr4zDaU
	h5qvMnNNJREYYWe9lUkLxQEOVjS0Edbf6G5HD+susMRdjdlliBjhcjSuhwdTlRZDUPy7lCJ3y1b
	G61iRvrRjtceOP6xKbOjfZXmn0+h5k/yErkO+S1gSYRktaTMnatVUgpRDYq4HBoaGmbOJxJLtUR
	BGtsf70QoSKYpsA7N+K2vd7t3OilfpEFqpinlCRzQ40F3VdoT+cRTEmVKjns/vsWIivraoY/+ih
	HkWTGrwg7STPkJAZAXASGp/IhjUPTXXI4AluWT5FKUNcXObfqzamn2CuXly5LFkxqEg4O3jVJIn
	XTZm9DscUh5kuoVf6VJXndnJVtUy4Bf/uwAv0gyHzL93FW7Gm2Pmehaiy/ffUb
X-Received: by 2002:a17:90b:3dcf:b0:354:a57c:65dd with SMTP id 98e67ed59e1d1-3567f85c9e4mr1617465a91.24.1770820408721;
        Wed, 11 Feb 2026 06:33:28 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3567ebc4331sm2330386a91.16.2026.02.11.06.33.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 06:33:28 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 11 Feb 2026 22:33:23 +0800
Subject: [PATCH] mm/shmem: remove unnecessary restrain unmask of swap gfp
 flags
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260211-shmem-swap-gfp-v1-1-e9781099a861@tencent.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDI0ND3eKM3NRc3eLyxALd9LQC3WQziyTLFHPjREuDNCWgpoKi1LTMCrC
 B0bG1tQCB1yu0YAAAAA==
X-Change-ID: 20260211-shmem-swap-gfp-c68b9d73a90f
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, linux-kernel@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1770820406; l=1202;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=Rqa70ORfAigFfDgfrZ4/HBAYSt16a1lSXqU93koFrAM=;
 b=cNp7dUoJTW8PNS4B/8E4Qp0f9dpw1o5MMvOsM25jyfLpTo2jTUbzktkgUv9oIyWbaHDE+RnpU
 txbkQGii05EDBEi7yAnWp/+fsVdVvBk2LIon1zoIYrBF09iTxh36SZI
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Server: rspam12
X-Stat-Signature: 4r988etifw4ug6ikaif5mehtpcfjq1c3
X-Rspamd-Queue-Id: 6D266160004
X-Rspam-User: 
X-HE-Tag: 1770820410-263779
X-HE-Meta: U2FsdGVkX18eOze/4LAq/9Dz+YFnuCxelNoRG6vYT9GhoZniRFzQUOmKYLzDI7lBhCvDwZhaUw28JUUA3SnKTm8SNeL4gZunOZSr8k5O+8vW6WJBnJUELi4Tv/RWbpDC4m/Ir0cV/OvFD3Hn/rrK1xT7j6mlFnkY9ChDPbY/w5OusuCNdFzWbRWQDtyH1NDh6wMaos7S3e8IyzzbQthkmBJF2jP4whZlDmRDdwnB0NGrYH63rkwaritVBglJI9gOg/DTAsHBlfLmXf9nBOrSACZd++1+3BERzIEhAjHLZuqX4dz9gTKiwg62qQ3336lDp/kIFTLM78MEnPZbiVLHnp3bSQmpJUFLsXz+e8Fl/awEA10Ev/CzGMBWV7ozHzms4D4NRzpFlzGX4VyImYX59XDF2RP9RRF057ZnYmQ4myBcpIdNNx9erhHhkN/iTroE2sKrEg2BwysH5fCQc9xl82hoR6usYV+1lAdQCE8rqXRa5sVDTIjoaAog6up7gtxQ/AVXokPFXkT4D2CB3U7eUZpEdKW8ALCVtOhzOh57JIJIlOvt2k/np8Ebw+IfNowMmj+KsClffK/5qNutSNdJRiaYoJ9cMjrN7wLrOby289yhHDdlNTcD6frfbwQMTvMXKRBea5ZlH3tmUs10+9pEN/MSMvgPanD39B+ZX5k5s8P61QohOSqy8e9R/1v+ZUEelAVLVWcjhuuYKHJtMDCPVJs9WiPZbPzd1W18UUsXqBXrAcMJ7gx0u9/cYDz8QClRMBqqXLeTH4N9imoUraCwlqgEvhWvePAxose/5XTKBc+AWGDLbEI0bK6KHJpCbF8PMsUKyVLQtnKgq42/FPrt2CYbhT79ixbDmEyOLNiHIOE1YGuG6i0zBfsFgF138qep1nIoKngSmAH/jD5V8G00zmc6nEkKeVYe787hg3nKbRwtrss6HSRv3dI7TpNaseleAkNH3ema8glCMCrSHuS
 cCrJmaHH
 kvO0Sn7vk7t9gkvoD/FTi+ReCo34VW+xW0r2KKRcD1Li4J2j0JIKbGjaHvg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The comment makes it look like copy-paste leftovers from
shmem_replace_folio. The first try of the swap doesn't always have a
limited zone.

So don't drop the restraint, which should make the GFP more accurate.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/shmem.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index eaaeca8f6c39..4f34dfa95a50 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2043,14 +2043,8 @@ static struct folio *shmem_swap_alloc_folio(struct inode *inode,
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct folio *new, *swapcache;
 	int nr_pages = 1 << order;
-	gfp_t alloc_gfp;
+	gfp_t alloc_gfp = gfp;
 
-	/*
-	 * We have arrived here because our zones are constrained, so don't
-	 * limit chance of success with further cpuset and node constraints.
-	 */
-	gfp &= ~GFP_CONSTRAINT_MASK;
-	alloc_gfp = gfp;
 	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
 		if (WARN_ON_ONCE(order))
 			return ERR_PTR(-EINVAL);

---
base-commit: ad92386d5debbde551129dc85f0118f5a521388c
change-id: 20260211-shmem-swap-gfp-c68b9d73a90f

Best regards,
-- 
Kairui Song <kasong@tencent.com>


