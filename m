Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86771606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 11:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=DXhket1Y
Received: by kanga.kvack.org (Postfix)
	id 606686B067E; Tue, 24 Nov 2026 06:06:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 567A06B067F; Tue, 24 Nov 2026 06:06:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BB366B0680; Tue, 24 Nov 2026 06:06:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ECCA36B067E
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 06:06:52 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 515291A0AF6
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:06:52 +0000 (UTC)
X-FDA: 85469735064.23.2CE1DDB
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	by imf11.hostedemail.com (Postfix) with ESMTP id 48B9D40007
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:06:50 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=DXhket1Y;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf11.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795518410;
	b=w1RctW3sJaAtSpP0jPApHhtgj+xZMX81FiRWD41VicK9MV9iczlLBDrNb0XSUKzlN0p3t8
	ZcO7iLuuKUtFFwzvvVXs3CKkcESgfdBQsl+6ASHMxPVdeJCAdgMdcxYn6bF0AxUl7QqMPg
	rDkCciEKQBc7rfwETn+igPtcLnJ+ZgE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795518410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gv6+8ttYBEuxe/3XZHIl7/7OVDqVuyh475ILrhZmnHw=;
	b=3d8VZb3xlV8BUL80kfHdm1k+jg8mnEgmW8w+5Q4se9g2VT0Dn1FopB6B6i5de8ja+DuAEP
	TQ/18OBBjVrt9IWXbWO6ei2JlYWgfNRo+cUHHS+wxbowAPd4FP6eUGwLjPGASgH9wTlVt6
	y5ew7bY/hU/xqwnyz2t1uuxlgxxHTlI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=DXhket1Y;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf11.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-cc147d86bebso2385131a12.0
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 03:06:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1795518409; x=1796123209; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Gv6+8ttYBEuxe/3XZHIl7/7OVDqVuyh475ILrhZmnHw=;
        b=DXhket1YWVAy8k4ERI6rtxR0I7EQbjn16fsUI/X/FuP/s7T9dmk1/ZmHWyn7iZoULm
         g4lgrtRchB6L+cYSbmjADYJ518m6TuJB3fsgf8+8vxwAOsezh/2r0P9LOz18ooKuomCX
         o/M9qUo95pziZpijpG8JF4fibnNlW24qEHP42dnp8mAgs+ND2I6sQaFHYufbzM26VqRq
         rNOIVTE11Jqakbatt+oZN+hmIpdOJSHAJkjTllpaiZKd/ABz1qTZldUcwMh8iIO/kqoy
         yZe232eWsSBA4dy6Q9Ye2K00cGa+UoyBnJuJjp2Wb2XmGwGFVHpUtN/7QKa7zBB6oGzk
         uSuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795518409; x=1796123209;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Gv6+8ttYBEuxe/3XZHIl7/7OVDqVuyh475ILrhZmnHw=;
        b=jnSzVoQCINOLYtd0WAZPHbwafX9HfpmoupEL8r+pPnfrm06L+I2K+oF1VUsNTyxKvK
         DUtX8WuODe2g8kdFBUFRvj/GECBVoLAlfC1+0gQz9yQA9LfyJq96kp3C3JujkxwGHbXK
         TuFZ46vwNaWG1u3ZFSwhlQAhdnSzxxu/rNg6gCpLCbIbwwJl+jPy/gRoPzhmkRsLisGH
         /98N6S36Qmut8+9AlB9txtC7V8DWHHMYyG66q8/no0Opv0/dydWasFuUzpl/lP+UAfm5
         xjVBI8qy/9s6ECFN2I50/DmN8dsQ+IDy9vmV/TpykSHC2Mu4ewSy3jnJxdGegoRm+4jw
         a24g==
X-Forwarded-Encrypted: i=1; AL+hErH7KbWDa4cz2LMRKWWml6kxQkwhmF0LvPwGRZ1cmZ+ItdxtcYZNZXA1xs+csEAlIBbGKjE0OO5EIQ==@kvack.org
X-Gm-Message-State: APuU4Z8orvTeeulWYE00K6TEJipOekL50I8swKnOMrKG1Te/pxctSv6Y
	TpYOOmWl62Z5vdsVNqww+YsTlUIB1Z2/f8IZikuJNrAOvgkc7pTGSkKLAexcHZBWzyg=
X-Gm-Gg: AZFdTZdDaQwXTpcXjXYUW5pVrl5ANXKgWmuHRpI29vFvD9PHsV3LeKq8a2w8G3jM6As
	uPtOky0u4zHM8K9DJWS9iOkxP2M8RqUeZnfJ1Cj+cTD/E+1qvEzUFbqWtd4GDrOXrh6giBC7R+v
	bfIOXmF6E0wYqug5AOlyGIluJQpIZH0yuIFv9RCI5EBrQTTM/Ld4i5AAPLpUNllDmXp7E07cvax
	I6EKwmMmfHC8/Oe6+/nMTXjuxfHVS2zsjO/2gXxw6uOiG57yBjHtCf6ZoBwi8VwC/yI5m18Yg3j
	ulvarjQ6sB+/eMzL+hitJjxE/xJU/ymS1zxgluwyozC1Qx7YI/hsZaDpdbelmP801ghc5exA7K3
	ucb5q5kHRQkSn9B081sOurEJjAvDNcU2j+hQnOZLyMqO1/7Tc4tEMsYTZVAvHekMNB6lKhptyeN
	pW20NMzjZzAPI62TwMpj8hgqx3rS4FO4rgQ5QICQg+hqhE5Eq6Fbhanz0zXcyrCMNygRoK7G+x7
	AhmwPZx+tJhOeeVHuQWJDmrAdo8kIwYD1b5plDfNKvgkD6EO1Oi9pkXVAo3L8Ngm2rwmweLvj2P
	boXsA8GJfDGPycDmWLChR5kK4f7HmgAlqonhkeDQlGtjPe++tI7nKUxJO/Aqsgn237RU9JM=
X-Received: by 2002:a17:90b:5887:b0:3ae:3e9b:5265 with SMTP id 98e67ed59e1d1-3b41c93c24emr8778390a91.26.1795518408876;
        Tue, 24 Nov 2026 03:06:48 -0800 (PST)
Received: from n232-176-004.byted.org ([36.110.163.98])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41ad0a33fsm22909735a91.6.2026.11.24.03.06.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 03:06:48 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 5/6] mm/hugetlb_vmemmap: drop obsolete restore refcount warning
Date: Tue, 24 Nov 2026 19:05:29 +0800
Message-ID: <20261124110530.3004071-6-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261124110530.3004071-1-songmuchun@bytedance.com>
References: <20261124110530.3004071-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 58idnt99scuyc9crk464ep3zsbwng47j
X-Rspamd-Queue-Id: 48B9D40007
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795518410-15677
X-HE-Meta: U2FsdGVkX1/Cyjcfjr4AiO9ZLZcdcz+Pnjs86jTXaWqYMNg+6VSnNY5Nx1jAqlDbPZZTh9gRIQDQ7h4UwT3/7sqIasyf0zMUPYX+Wl2rlAaLYx12RWg8ie97BunhSINjPGv3H+pmaAa38w9LZPj+FFrS1xYYjGZek6wriKkvTyDp3ZGgbK5iJNarm2A+EJ7DvhCS+niayFwbxaX1eCDWvBrTcUtg7r8+j08M34mw2IjvC+DrVUarsxELBGF8p4nOLO4qFdGCByss/9jXvTGwDFDbgcbhy9XSoB+7vq9nCeVeQJPHp0hJPNfwm/+G4ZgKwFaABsBDEiTbBvYoBn+xDW0Lw8ttQblTk9hhyJrcHTxKRcClqYMA0anHfcL3Is31fm+mFntvG8QgzhGUVgYvJG8P5yiOE7WnNC93kzeiZSJ6+BJqHRJu8rP3cUxKR9zg144nhjCOdGai65ZtZyZpaNaDkSRyErYtgfgy+0n0frTq0y8XV6AUh/VjB5vttKxuBWk6YtH3HVhaBVhK23N2aR7ZbmoYDwk4SWKWb8QhhTQgNkh/bqQZnq3r6t43vQsjKjC/Z4HUek0t69J8hmJKqqpmI47SL8r0Kj7hr0yFYpGJZ3drbRHJ/LbmxW9W4eMxkmJC5haw2vWS2D4ToEcWcPOi9ig99B271iinWtTnE3kzYDaBdI6CbcGKmB8cTtPiE2xnK4t+jS15mHqc1h0ghKja5+OIJUCKCgdYwPOuDmqpwTHrjao9APhTwSvNfHFuilrmsGm8CE9j6ErgziNsAIWA/UoWjl1HiU/BOlY3vGdM/nX7I3ww1zoeLSvBDEm0VWiO6JWXtSh4Q+dtROO9Tmj+9c+xKY2Ypm29nqqSwVISod+cXFV5zfqMc1nEkkxUBYXXpI58freyef74jVQZJhf1vhmV/tu7M2EH/CBXJGBbthdKlIRc9k7TB3ckqKsULlwKjMiQRevAeq6yt7k
 Xloqel1v
 WMJ2CI2n7wi1YjuNBzf4OUZil1sMyqOoEfE6O44bSVmFcffGx5z/BWYgA1tEHi5cJEFOX6Cj+ThYTHUNV3nPzkg03dhsa33Qau8eacxF2E6mMagmYbIFYV/Ci5iY0zju/ZFgptmfH2x+Y3Qz28w/KqD8nmdjTMSibmc31E39F0PvQCQkSkmXaFdzNvkjvF6KfhhyQDXNrSQIvyi5sCrW/o2fI0pL31LpN5OmsHB8bNOy8oc5oBvAfGEz5MqUHICgIolLRdBsVDExyYyDSmfKkY0cwCxVovv3vFBC6btArv0SBnGUcQken8vbdQHzNHsfNaBhYDY/ymgHIr9/n8Eik7rqW8ilzk34gYYW/1wUuZLj6mfIl3u8xe3EMrz+Q/3wljdIg5pIpIdzgEFvOj5XWktrUgjFJ/OSrOVUcNtS3MrhXb8l4d5J/lR2zBK/BOGoaeFB3d1QAUbclowzVmfnRFsQOdIcCeJZj106EWBAjUKrSfzMuiTweKZPgLdDm8pfNSlv8gLpvRi1OmDEgHifnMBe5pST3bgiXcBZGaYi1OiUCPDofOTrDeHa0UbAYHKI49Hj5e1t8VSWr3BI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Commit bd225530a4c7 ("mm/hugetlb_vmemmap: fix race with speculative
PFN walkers") added this warning alongside RCU protection that
serialized page_ref_add_unless() against HVO remapping. The zero head
refcount was part of that protocol while the vmemmap was folded or
unfolded.

That RCU protection was later removed by commit 32c440d67e6c ("mm:
drop fake head checks") and commit 01b1d0ffb6f7 ("hugetlb: remove
VMEMMAP_SYNCHRONIZE_RCU"). Commit 0120a603afad
("mm/hugetlb_vmemmap: map the shared tail page writable") now handles
the original race by allowing a late cmpxchg to fail safely against
the zero refcount on the shared tail page.

The head folio refcount no longer participates in this protection.
Drop the stale warning from the restore path.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/hugetlb_vmemmap.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 7ede6b6fb4eb..d52e9d16d102 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -408,7 +408,6 @@ static int __hugetlb_vmemmap_restore_folio(struct folio *folio, unsigned long fl
 	int ret;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_hugetlb(folio), folio);
-	VM_WARN_ON_ONCE_FOLIO(folio_ref_count(folio), folio);
 
 	if (!folio_test_hugetlb_vmemmap_optimized(folio))
 		return 0;
-- 
2.54.0


