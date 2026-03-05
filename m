Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF76CF30956
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 13:09:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1941F6B009E; Thu,  5 Mar 2026 08:09:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16BC46B009F; Thu,  5 Mar 2026 08:09:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 098E26B00A0; Thu,  5 Mar 2026 08:09:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EB6F46B009E
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 08:09:20 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 80E4AC01FD
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 13:09:20 +0000 (UTC)
X-FDA: 84512040480.07.B63F14F
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6AE5AA000D
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 13:09:18 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=qVlDdN3n;
	spf=pass (imf25.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.47 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772716158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RCwW07BC85VhkN6p7jwWc7fFxc9d+eDY6Cs2s6mDKrE=;
	b=rhP3w8PdquCz602G1cSI0b4WumLkmowiFzN14tZ/GC4qHWp8t9Dy/v4ujImOhl+z5XYP9/
	K2jZfuuskHNhz+JFRKC92GosgOJuq48k5i/m11Qhhu6Y41Bkz4Avo7tHVPStKyRr7fDL5L
	rUoWF0JeCOElFyG++wcOoVUjOi8clOc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=qVlDdN3n;
	spf=pass (imf25.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.47 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772716158; a=rsa-sha256;
	cv=none;
	b=QOQtNQUIzyrjNxOPrhn+QQnREwXcpQCyVhAgQTthbtVYiQ7Qj4jgw5GVw1I5LfmxNI+NJu
	i9Klr7BfTlfikrzCRQtslpivFnptWy9xRFLYfp72M+Pa234BbfjeQNTydV+1D7O/tvp8JF
	CRiMb2YtaPGOnt49Z6H90rb52ncC9yg=
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-89a0ece9f14so40409846d6.3
        for <linux-mm@kvack.org>; Thu, 05 Mar 2026 05:09:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1772716157; x=1773320957; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RCwW07BC85VhkN6p7jwWc7fFxc9d+eDY6Cs2s6mDKrE=;
        b=qVlDdN3nL5tLE0pXuHiwG2HgVldIuYqpLBxOy4LU3fFCBN/YqTJrRhJ6MUS/LmAxyv
         WF1EosLRIhhQgdXh4osVUWh6/0BjqnVRU/h8QmSLJRiaeJkAq4t6iFoB/RomzMeM8Eqe
         LyrlKqvu+xuWOVWAJmD/aTuk8Gd6S4D4pd8mb/JffuBV7GrPgvFqHRIQXoA77kB7OLw0
         S44bAaAKtT/sny8I9CRTS6KrUg0564YpNjWV/9l031FLTDWkSrXHxlDN2ZYoa24kITBC
         uj9AUap1QBOmdOMq8QrexMIYvctvXUrDI2oGICRdBbHNafUKforM9B6fByTBWa5p+/My
         EBdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772716157; x=1773320957;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RCwW07BC85VhkN6p7jwWc7fFxc9d+eDY6Cs2s6mDKrE=;
        b=mI9RzmZwchIak6LVBKE01ZGz1TbJhheDaPOHDyIbGrNEK9mLnUpfDi6oeRKAqdXT5O
         P2XnfGddZXdxqub+N38VUajiUz6U7mvKUSGs3Ut3C5ef1duR45bmb840rwNKLUHROATY
         EhAVEgqYsnsHA2LAZPLwag7xZldi+qpGhSoIHwQ+SyDkv0m+/lusxdE7A6kMvjOiee0B
         dW3GoX5rFpwAAKjixxi1sov0tsv634pHWTij/YWsL0N8HEDma2rN3hGyp74MGTQMu8Ln
         RSHpofH/AVYOCHlkFKgjGHOZlHE4joHWe9u+1akfZ1Kv+gSJodEKYUD/5hQxRoN4rDjX
         OjBw==
X-Forwarded-Encrypted: i=1; AJvYcCWitV/UAvEbzB6weIt8neYUeLYg/fIivSvtoREw9wdRzeSyGll3SG6pI57aORCDAGvoSpixAGSvdw==@kvack.org
X-Gm-Message-State: AOJu0YytCqQoCuXJ+MeDoF3E+Eduyql9O7NAhMp3VxOnHccR++5lY4Jz
	WVZD5vMLsk9vzbYXqYSX8GYDabxRYUcVwHunLlmK5EB4NFVf2Bx/4aZ90wr5BeZwKWo=
X-Gm-Gg: ATEYQzwe7zIGlWb3KP0OQELhOSZJ9cJgNyI0Cz7npp+lmytSLqA4QN97IEwUJKjgETY
	qbFxYdqtR6gLlQW+/hT3h54UWmm5zicb0IK95DAEBSmA08gcEIfTqvaqLLStHb2UrHohU4a9Sti
	se/TKVw5fTx4tVXK0i7J2MjrWY6H7t0HcZXRchg0QiM36aRNpMML+8dIxDbRSXJQGUwaQ/sKTpN
	YzA2FOj8GTUFW2tFTwIG595pn6pcg4TOz40Fat6GwkP1eV0zONYE7BPx8sEBgTqcdkuBmIIRN31
	UqYUVtNG9s6xreIY3OZ4Hnl7kCZ/3LSwinuM6HBs0u3kPrhkopxeLYscaU1ADQynsVXVi9DImLQ
	dofGnQO3KIiwtROrPKhBcGWAcFrHKobqjAtioRz3xOpBpQYHXGnOHbhglz5HDAewBnQcmzzqvtb
	AfsNtGSy6flLOSdR4UPgGgfA==
X-Received: by 2002:a05:6214:2a86:b0:899:d6d2:4b96 with SMTP id 6a1803df08f44-89a19d19be3mr78504446d6.34.1772716157355;
        Thu, 05 Mar 2026 05:09:17 -0800 (PST)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-899e608cfc6sm122095406d6.14.2026.03.05.05.09.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2026 05:09:16 -0800 (PST)
Date: Thu, 5 Mar 2026 08:09:15 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, Johannes Weiner <jweiner@meta.com>
Subject: Re: [PATCH 1/5] mm: memcg: factor out trylock_stock() and
 unlock_stock()
Message-ID: <aamAe7h618G40h65@cmpxchg.org>
References: <20260302195305.620713-1-hannes@cmpxchg.org>
 <20260302195305.620713-2-hannes@cmpxchg.org>
 <e30308d3-b70a-40f9-9c4a-b3a777bbe45a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e30308d3-b70a-40f9-9c4a-b3a777bbe45a@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 6AE5AA000D
X-Rspamd-Server: rspam08
X-Stat-Signature: mnfhzbuojswsnsrycqoi9ayin1wdbfx5
X-HE-Tag: 1772716158-113767
X-HE-Meta: U2FsdGVkX19t5qLu6zMmhOoqSI7JDfaRaDaQzpPRrkQHRk4vjEtE9CQY+nOnRocvpuw2jQhrhQUKPVJLTwtJMyNy2Pe3cEsdoiLHGJHXswlgSjxwQq4YBsnR1eeBhvLPT3W+lG6xc31+RtJ605rOMmbZ36gtcBwMNJKXVMEuilUMj/NQts++DZekVKNvoEp0cKErQqZC2UpuM0VJaf2M1Jn6U1rpIy1JPMj/HI7psNjr3Q7RePeHTlPHr2JYYm0SEzF8vvTNqCfnZq0FRiGadHAYPq4zN/CwG/60k5BOQpJuFLiKkMCDJlhcqgU+CfR4p7CrBRnm1D8tPlsUQ+TSY3rc5UpZD5KoP4rHV6BeksexBD8MFq5Tp1LZ0QUc537Zai27zwRXEmvCMpqLRSYsLi5udh6Fvejy4yuHI7Bn6n2+0BJgCJKbg7cOZoht2TGbTsoRueh9AeN+gbn+0buYhhNkZ1P5CeC7M0r51FrPEFRvSOei88Q3SqBIh0vImbduiBkvIDkU5YCz66s6HkPg0zhoBh48GaUPxxnHRUUwRRybWGMNpcOXOz7Cd1+/kFhvGDJKdEKCmWmIdDOe6rWAG+H5X4QbNwTzGR31yP4bhLH49gYbWjZmUtCSOA9Ix48jfahdN2P0e3usY14ucYvM9GfvRn5RAVw6VvlXoC5m1KOuTpFv30nORRYS+6fxEFaefhN3IxkIbQXNbvQAftAQsjBVLN+2344a2PlIAwuE42G8GeI2IIW8PRxNLJ8r200se23mAZERpaUpUpCk2tGvdFeIiKeLrd/F/cAXqdhyZ9WnFuqxWC41lp0gnhms0o2b+WIQYyYANFJOQLoFfG3pvwegvD4Xt/FAPvHzJG56h1fkyn2J13a3tT/Htu34uH097MyZaxC5N511bHJgGEKVD9GyYgZlokSZ+Cvo8Po84j7z1eLzS5k8xKaSuJEXpytscmp8syihWSDSvma6vDf
 947kiev9
 JPbHtDDN+Dl84aHXeuhWO/RTQVp1yk4IXq5bCcjCgnL1Oy+1i4H4yBZbqcrzauASW50mkgwOa7FNUK6LgFK/LCdOeEpc6JpcYWjBckjK9L3ynSkfVkek9r2HN6hyfpZ2WOsUVSOV7PXmjDPfqtj3ElNZ8Rsb77eXaPhnr1QjINujlMnVpJZtd4kxrCVcPZHExRqcyxbdZbVHOEmell2iWdwjJLZlpC6ePd4yTM0ScuNwkYN1mNNnXbRe3RAJDgTS3k0OOvWV1PSyLVY+Z6rKK56YpVbhPnRvn49ez6Fz4EWTsXDUt2MlPwiz0R86ud9NMSmTMNvrtHVL0TIxjIEdYchhOmmMQpnmCJqqRq0kbyZqoqwxLKhOX14TGBlDp5IaOf38PNjGwOnmC6LU7QiFX9+C1c551ZXZELBQI6hEjweqAGzNEmD+epXkG7sCcuGxPg8dAasGfUCbxG0f+LuTXr9h7y9wMmHJrf/7QeDSnU/gIgtEK9X74V0CjbNjzc5gkz330Jw/OS7Bnx1lhNTEIw4eW91Nho2vt9wjDVVYXiusdh7DA1utRZ5XPJQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 03, 2026 at 10:23:54AM +0100, Vlastimil Babka (SUSE) wrote:
> On 3/2/26 20:50, Johannes Weiner wrote:
> > From: Johannes Weiner <jweiner@meta.com>
> > 
> > Consolidate the local lock acquisition and the local stock
> > lookup. This allows subsequent patches to use !!stock as an easy way
> > to disambiguate the locked vs. contended cases through the callstack.
> > 
> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Thanks!

> nit:
> 
> > ---
> >  mm/memcontrol.c | 25 +++++++++++++++++++------
> >  1 file changed, 19 insertions(+), 6 deletions(-)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 753d76e96cc6..a975ab3aee10 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -3208,6 +3208,19 @@ void __memcg_kmem_uncharge_page(struct page *page, int order)
> >  	obj_cgroup_put(objcg);
> >  }
> >  
> > +static struct obj_stock_pcp *trylock_stock(void)
> > +{
> > +	if (local_trylock(&obj_stock.lock))
> > +		return this_cpu_ptr(&obj_stock);
> > +
> > +	return NULL;
> > +}
> > +
> > +static void unlock_stock(struct obj_stock_pcp *stock)
> > +{
> > +	local_unlock(&obj_stock.lock);
> > +}
> 
> Could have added inline's there. The compiler heuristics can be sometimes
> unpredictable.

Oops, I almost missed that, but that sounds good to me.

Andrew, would you mind folding this in?

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 36612175e98e..178be98f2e49 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3160,7 +3160,7 @@ void __memcg_kmem_uncharge_page(struct page *page, int order)
 	obj_cgroup_put(objcg);
 }
 
-static struct obj_stock_pcp *trylock_stock(void)
+static inline struct obj_stock_pcp *trylock_stock(void)
 {
 	if (local_trylock(&obj_stock.lock))
 		return this_cpu_ptr(&obj_stock);
@@ -3168,7 +3168,7 @@ static struct obj_stock_pcp *trylock_stock(void)
 	return NULL;
 }
 
-static void unlock_stock(struct obj_stock_pcp *stock)
+static inline void unlock_stock(struct obj_stock_pcp *stock)
 {
 	if (stock)
 		local_unlock(&obj_stock.lock);

