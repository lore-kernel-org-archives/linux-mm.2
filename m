Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3D44C61DD3
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 02:58:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AC346B0088; Fri, 28 Aug 2026 22:58:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55D056B008A; Fri, 28 Aug 2026 22:58:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4737A6B008C; Fri, 28 Aug 2026 22:58:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 216956B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 22:58:56 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9ED99A3FF0
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 02:58:55 +0000 (UTC)
X-FDA: 85152799830.21.A30AC92
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf07.hostedemail.com (Postfix) with ESMTP id 12A2440003
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 02:58:53 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XMEmLGsr;
	spf=pass (imf07.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787972334;
	b=H6J1e5QAQIXJ/Y69m8Mk7LbRUMw/bbL/emICz9RiUN+0Rn8pNnhT4KDARhUByQlc20ERmS
	sw3q4AYvg4owKGJeOfQ8xKHickynFrp7nwZacOLKGDM/N89QVzFSwBLhHubWdB7spUzAna
	/sZm+cGQVrl2ImG98rTaSu4yDHJyZjA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XMEmLGsr;
	spf=pass (imf07.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787972334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=erpIzgXZaIbN7nWQesP+4kuweE5Y/K/C1rP9kfbv+ZY=;
	b=77B9rCSPq7exta8rPaNZeTdZiB77zefEORNPqnIm4/9AndCqp8V4GvGx/f+wIZvdwBnho4
	gHhqupAhgKQJclnUew2HUHMWEhLQqbe6pGhHMpMxs4yz4ZpL/XBmenpwsP5YHvoAiTI/ti
	gk5ijbovEovPUAe1v+gVcbaWB+DTk70=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c1670dad7a8so267142066b.3
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 19:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787972332; x=1788577132; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=erpIzgXZaIbN7nWQesP+4kuweE5Y/K/C1rP9kfbv+ZY=;
        b=XMEmLGsrYXhEsnyijb4jGoSRHnA7J4YWqPYd8Tjmrm8T6CBqumfvmumeHJVaJvQD53
         diNDUAst03Q/3fkT0Uv3se09d6Uro0GEs60ppWQIn7EZ4VaZjrWe/ZXblZQRRrVAB8dm
         /goWccZeaSf3pzR9Wo0LhBdsYcb83D+rgvGHGd0omzA5IOhS6xBB3q7fvdwdm6NLlqH4
         JJzFhoDkNIz4qjMcHXhpxQi7yqoqupJV+dVJlCMfOw7JAo1wvemHp2ZLZvLwjuOoycTU
         YpGMgP1m8xmY16PVLi8lOXqxcl39R9ukIvw+n5JEFMnQwD6z/pql/S/6rnzCtB7zYS8o
         Lg9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787972332; x=1788577132;
        h=message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=erpIzgXZaIbN7nWQesP+4kuweE5Y/K/C1rP9kfbv+ZY=;
        b=re0zuh6cwcmVBxfiJjEcFyJMy18yNW17H5nehwdOcDtc/QFMOfQeangtlUyk2lgfA4
         0YRxL7CfRMAMXMbTM4azxixqzewuI1SbvtBVMC1d2CK/NLC7nGKJj660dGXVKoB69U9e
         MEnETqquTEDRPCooCc7Q6IPLlXk81o7hOFVJle8zzTt6wsxd4AtcIJT76kzGzHhDf7nB
         Bw0j4EFA2mCI+NfFjtBUYqtsUkReFKDXRlBFHIUWnRKTqEIdTAIyYZQx21K7JaPE3Nwv
         n8C9+TuACUV8tFi5uu0a9uLQOlnca14LUh+5qGLQGnWujRcRS28EHmrQRbQnf+loj5+H
         JVUQ==
X-Gm-Message-State: AFuF++m3CfkWAagf12yQK6M0xALve0htom66CLQX9/mwhdMdMezmCGf/
	kxk+qAi56GrdppuwuXWDd4jWorYdAmhIuIg6V8Zpn2+v+/ilou64xrb3
X-Gm-Gg: AR+sD10hYvuxGyy7FKisx7dNFnPIN4TItRYuExMXXsEwMGLz1wfkFMIbNdBXqTKz/Vc
	WvBM2ZjCmM2Viwa0vrehiZo7BJvS4tpyWX5HgTrnbrQH9ogaydTAH1+YIEUiqj4fAtuSSECr0bI
	/kd2yUS86TZWJ6qDtTb9QZpRsjwv4y/Oz7X3vrW5jje4xfP+Ur9EWGhY5qKKc1w6+e3OTFRpSAq
	0o6qmDBtIYMnoRSUQ6U59uslfvHMTkr1UW3klMF/AnanDHVOZXOH8wDjQezhjPFgig0CP3zBdaW
	kZofeNB+DQBvkZpc6wrznBTnFiSx4K0KqneIVTVYagXAU7z253eWdH6PQwbX5991oWgRiRJFLDo
	Y7lIcEkUU5GwZt3bHEnW0mwwXOADVElYocCtAPgBcAUeGC9KjTJfFvO9tljQ6iI7Jc7UJFet4jw
	HDYNU8vpv6zyeWnUgBnBF34ShGdMfMDk6arIrZ9XcmOHuKCD0ljJgFt9+4X60=
X-Received: by 2002:a17:907:7a94:b0:c12:83da:7eeb with SMTP id a640c23a62f3a-c25574862admr880775666b.19.1787972332414;
        Fri, 28 Aug 2026 19:58:52 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c255ee0b233sm153800966b.11.2026.08.28.19.58.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Aug 2026 19:58:51 -0700 (PDT)
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
	Wei Yang <richard.weiyang@gmail.com>
Subject: [Patch v2] mm: adjust out-dated document of __GFP_NOFAIL
Date: Sat, 29 Aug 2026 02:58:47 +0000
Message-Id: <20260829025847.26779-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Rspam-User: 
X-Stat-Signature: bt3s4a1ia7niss79o19sqidg7m4uau7g
X-Rspamd-Queue-Id: 12A2440003
X-Rspamd-Server: rspam06
X-HE-Tag: 1787972333-736652
X-HE-Meta: U2FsdGVkX18FK6dkd0d8FAZNlHgs256XHurd+532vGSQ+1t5i3YNfaqD8kcjs+Bi6IKVitYYyahzkaOCDJNloob/rY4jsy3hZGcn4Bct/SIwRELB/VruudnU8p2odbNcZxRaPmG1bZwSNbHBSaic2stMVXWO06facWbLJqRlVuLgKoX2+jGbOyQIF9atRJxR28059Xtb7L0et2CnaWzu0YrwWFU0VbSIiTgYu/3LafrxlXgXHzBuQqhdAoMRj+jB/tPtGVgqLwm2Puy1AFlQ/0L/u1PjqXZAXjmgeWHMjO4booEsIxuEFlTHeQZQgbxFod6T9dva/L3lbrwhk59pP78+fdeYCG7XB2Yi5OezEAYOx4AsIJcAQvvyaYCjENdvpINsZ5d7Aqs3ohjky2TwAFNMi8goW0IoiVTpL+prDMdim2t7LHtUmnAsjTcX6R6luyHOTw4pGChSF8q0THRnqrP6ewDrUHXOrLX3J5tak668HgdhlXgH04q9E+TZ2X9B/FmgRU9KCWwdTvtcJT2U+MZhWTOpyZTJwcNngyzyJBgOCMVWM6cmzxr4qT7ZihxmT0yGFMtkaVCutw8MVxstI6v62rqHLtYkA112hZxw3Ul3j8+WG6wzetJ9jUDNceCwBTzT3mKwKqixi3k+QYrswtYb7siQeK8h6frqLbUpr7qQmElZIAGUhNmW45ioem/DLzCBch4X63N+pVjMxEbmGOEqDQ9VRufR43r+Ko0/o7evJH4j23N1huv9HTrqw4xl9Mex5gY8+xhIobab7bptP/Hyypls/mLwlc59EW1kW7v+fWR0H+G0H9kB24VCJ31Y+MuEFqxS0bcHArTqZssaEE1UX81pFRNnIOhTxyTOVBfYqqVO6Zf8eLck5s5KAqcAEDJ4aiU28YKoq2LSDs8hpXW3E94w8zJPrLmTQWRUlpK+QIcSQuNCSzJu40mOGbUJlxlOWrwA9QcAICaB4b1
 ZhjJYlWr
 ScEu7+9jTo2xnEBPw8gtwMk/y0i0f0yjR23GK76cC9NuVqJkFOXTPU/tpAed+6LuOoz1Fd3S+8hqMDijk1tfZWW9yTEHIzwEf+gIpJ2FUQk+2H7cUaBrdDNWGqbO/GcdOdAuoyWP8jM4vIGVsArYL3I6+B9n3KUMJO6nTb+snJGiWbDLYlbwWyI3SDa1TUa9at3muD8JfZNl8+b/QmPisxmjMV1n6tRmBrZ4KzV6yrrpcDJyaI//rm2m/cOZA/iWc3Ua9oINJwDt24pJySxmLB1qocFF7GssC4hSkaIoqYvOCvAbESPuAiaB/2pOMenP6QIsVbZjcAYB3A0PvYwoQ+cz2GtCp6qrwDbmgq1C+eguMSNRp6GX3CUGP8mG2sh36lCPJ02/sYS4OFpfNvkU39ax+HyiQ0oOTcGtKy58z3F4BiQRJX8u4wDWKxzqTKcSegv2a/ycPUDyEbZdwqxhRMdfuL+5KrtN00iyvRQCxi0HFfehenHS0172sBgyqFCUa5Sxizz2m2PC1xFoU4vlcHLaGJfB9h6K9pnTX54A9eEgFa26mpBVcESQyOy+7XZhO25assxoMRBXhFTeoXZV0lAy8+I4dYNsOUfqWbjn/JppI7bI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit ee040cbd6e48 ("mm/page_alloc: don't warn about large allocations
with __GFP_NOFAIL") remove a warning on allocating large folio with
__GFP_NOFAIL, which was placed there by commit 903edea6c53f ("mm: warn
about illegal __GFP_NOFAIL usage in a more appropriate location and
manner").

While in that commit, it also documented this behavior which is
out-dated now.

Adjust the document to align to current code, and adjust the comment
while at it.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>

---
v2:
  * s/is adjusted/was placed there/ in change log
  * instead of removing the document, say "is discouraged"

v1: https://lore.kernel.org/all/20260827030548.16631-1-richard.weiyang@gmail.com/T/#u
---
 include/linux/gfp_types.h | 2 +-
 mm/page_alloc.c           | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
index 190191411009..bfd4c43ed777 100644
--- a/include/linux/gfp_types.h
+++ b/include/linux/gfp_types.h
@@ -244,7 +244,7 @@ enum {
  * definitely preferable to use the flag rather than opencode endless
  * loop around allocator.
  * Allocating pages from the buddy with __GFP_NOFAIL and order > 1 is
- * not supported. Please consider using kvmalloc() instead.
+ * discouraged. Please consider using kvmalloc() instead if possible.
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


