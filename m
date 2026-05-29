Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E9B7CD5BD2
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 09:56:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 478B86B0005; Fri, 29 May 2026 05:56:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42A0E6B0088; Fri, 29 May 2026 05:56:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33F7D6B008A; Fri, 29 May 2026 05:56:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 24FA56B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 05:56:34 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C089916310C
	for <linux-mm@kvack.org>; Fri, 29 May 2026 09:56:33 +0000 (UTC)
X-FDA: 84820002666.01.FCF63F6
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf12.hostedemail.com (Postfix) with ESMTP id D11BC40009
	for <linux-mm@kvack.org>; Fri, 29 May 2026 09:56:31 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eLkvPkcV;
	spf=pass (imf12.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780048591;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QlBVL2w9TAGD5JVBams2MPk6DO1Ps9XKY2pj6ZAb950=;
	b=alggYpUg+BNNJn4dhWAc/7EfW0s2CQfaWLsPdOTyzJ5g+wLInXRHjvTWc4uGfcni8mRhsb
	bVF6OOHWXrs3xF1rp9slr8ht9E+AKYO/zxkudHFkI9O09AguVw12/D7/j5IKB0yRpAmzYa
	dOdYdIwwlxHo2pYs1lJC/YgddT8rFNo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780048591; a=rsa-sha256;
	cv=none;
	b=aZ9ejeOXajjOR+klDbCT7xffWArVVB9m0zg4ZLIu92LkKcUF4pzkFV45hbbSJNSOH6xXij
	gACp+k8tvqesTuw3tIGJk+Z6xr30wZmdkzWKBu9AmiwIBFtUsiAXjwKLgJ77TO4C5jvGPN
	WV6LS6WOpjfSHisTnKdP2FPoMrsDthM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eLkvPkcV;
	spf=pass (imf12.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-45ef1629ff4so357079f8f.0
        for <linux-mm@kvack.org>; Fri, 29 May 2026 02:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780048590; x=1780653390; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QlBVL2w9TAGD5JVBams2MPk6DO1Ps9XKY2pj6ZAb950=;
        b=eLkvPkcVnjv/X8sfIJiJd50Vgb8tJkkzEp1zsCIbMOiuM2G0nozLe+jHI1jnWmZpOy
         jtVU6/vkmzY9h7OogFqAFx3bIutxW1N4iMqiLIkbkQcSrquyV7jkMOj7fjRwDJ7bkUUh
         3iN7hqUF0sWcTKcXqZ+A+R930JNuZBOnxVzPkKiMlXTMzwRmsX2wm77CtJFK7/xTvA9O
         GpCJKFQP0ddwJ5SXBn8CNY3+tJ6xvboIkxDm1jwo6k7f1QYgmXJjQ0f/3ppK+rS4ZJXq
         XjcK6W0ky0fLhX8VJ7MWDdVPDeQTBgherMKtFAOEa4jJZyKD6mQj2CaQ7oP89HDx4aU4
         N4Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780048590; x=1780653390;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QlBVL2w9TAGD5JVBams2MPk6DO1Ps9XKY2pj6ZAb950=;
        b=oeFTOXpWKVldOuxYZHhev+tp/rTldRwrnfkk6cjBJdhn5bMQVgBbiLJYjb1ziRtALw
         Z6IDs+A0FVCM6X9EYR9gk8XyOaDmnMepdL8SKg3HS2j6hY9ZqPGnrzulHXh04F6liyMa
         8AzU27cJH3puGGJotCngoqXspHU66k8yQSF2PfvFuJkSGwYPGBqOC3Ndub5y77tGxV6i
         m9OcISpnCYAnNiI63PycusB2ZRCON/30YtPXVQ/3GooXciuE0nPma1GE7hnQXYAi5W09
         lEUOpGCi8aOY6F4D3LyKpfD+NlFB6SZl17ae5b7RvDw2/oNzLTrp13w7BOy+noRCpewr
         ++Xw==
X-Forwarded-Encrypted: i=1; AFNElJ8godZghbCQ90K9Xpr/BUOk99ViUxbCwqlx9fj+XfebI4jH7rItD+ygzKO1jc7rnklQO/zKQUsdZw==@kvack.org
X-Gm-Message-State: AOJu0YwOjsHp2uELFNlMFFf4Oaj+AKF4flvbDeaCobp8WWs0Yhr27nX1
	yOF2DdPasgODGnw0eSLSZS+dfB/R7Z4dn1rqYdBZc5cvnzquhDwGBRA6
X-Gm-Gg: Acq92OH5YlMab43fPSUiJyN6K+op1I3yBxPae/2SJXQN2PUaN3XgrAIqLt6oF6oJrmu
	WsNSLcCQWYPlYkdt+heKt4d5kI4P9mJIl8B8Ps/yCUVWYcq3rJWnbxRoBemiKb5mdiXvAin9pgq
	GzTCpmSA3oy1avQtzHo6EOyxmRc2/k0o1Dy1+hq8hHbIH75jtsGZ+rBZdwg3EkUX0L8bwMr679O
	A+W7z0RRTG+SrJSvDpEAcTfErM7zmHOuHb1Oq5jYtsRMA1vkd99ykAKhQWlOrr9QWm/Sy/hm+Ax
	Dbd3q+UvUmAwC+ZHVGrn3x+K1cDyPSdzNLR7WD3qKfFwKNOLZ0MZAh4xiOSVODmCpM3Xx+QuUKa
	au8gdNWqkbojSzULvyI13C+K0Yt93RUdMuDDQrAnSmZq59+DxIQP/F/rwRojYW1/Rcfeo1H+g4j
	PzJl8M2ozAI+ij2GukmaNR04tz0NyxgusG
X-Received: by 2002:a05:600c:c168:b0:490:50eb:b777 with SMTP id 5b1f17b1804b1-4909c07267dmr43425645e9.5.1780048589855;
        Fri, 29 May 2026 02:56:29 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4909c09ab75sm11200965e9.6.2026.05.29.02.56.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 29 May 2026 02:56:29 -0700 (PDT)
Date: Fri, 29 May 2026 09:56:28 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
	Yosry Ahmed <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Kairui Song <ryncsn@gmail.com>,
	Mikhail Zaslonko <zaslonko@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>, Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 5/9] mm: list_lru: deduplicate lock_list_lru()
Message-ID: <20260529095628.nagjdy3f24z6qjtk@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260527204757.2544958-1-hannes@cmpxchg.org>
 <20260527204757.2544958-6-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260527204757.2544958-6-hannes@cmpxchg.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Queue-Id: D11BC40009
X-Stat-Signature: rhwp43ow8t8d4jd4me7d6aipdgdg6maz
X-Rspamd-Server: rspam06
X-HE-Tag: 1780048591-47818
X-HE-Meta: U2FsdGVkX18yCGnsQcRDzgyw6Fkuqqu8IM+QO9uuYozvYKLcygE5EE+0wxLxuP93edmhv60M3FxpxnRo73FVFd5w3cMVPuBLTgYhhEIAE2R8WWL2zUEYn60K6zWsQGUGzyJjIR/CnhjNJcNjV2NSkdeHgYXP4Ls5aQlGd7WV8a2pxBQ9+gSX6a4H1AL7sVvV55c25/s0EgwNBYylCebcUJmwljguCL1N9c1SuW4FX6mPP1/uT9hnhu9bQMhDqB6VyGBuLri9poXsXdvzdIb5VIajJKXNcVZkDlpXAqkp+NQlKAQR0RwFGQHqopuVhTuEbaOzbAf0AaXFjJa9Lxxoj0nsLkk4Xhv4ou0OJMsB7ixYBCMFvE3JtGKnFv0oiFeFzXdJwycRn7UtllfDWdCIVGD3MYS5sChSTSr9L5htlX33nlBixwG/VWCRjBcbRRxYu6jf9+TMX+N62LYzTZgaQ3KWyuuKOpXx4PqNs0VWC8/g45XPcXWPpfLy3APpaGNQwloEoxCGfkkC3y55WBqPf3Bzpl9WweSfszZtW/Gg1Pdc1BDFIMTDyP9yOJsNS+1mOIt8tWoKYSmpryaww4NLxxaN6iq2m5wzqy6jAU+5yUWQlBu4tyBU3p+i2w+VL7FFEGFO5fDSN9nYh/M9sjobj0p0QS8XHuNhxmEQhKj/iqevWqcGsBmOSWKoPg4gAdadeGUxBeq2JSWKWlfVUNcsDqraR/cEstt8zX2E5a38cYE8bQNARt9OjswTeYfBQ3NV8TsZLf/7v0YR4KcoG+utnLbwZ9IJHP0TjSDIZirhMjHxtpz6S6kgWmmfzInDFzUZXX66HjvPycLMeL53/ooyLGGJ0eUGUk0390leuw4QNmjbEduRteRu7iBGzKdmXgjwBk0uvs6K3VuXL8uESIptE7spuLMmS+jqJlYK+3/1ywWxJdgHYatA6oyGUbcAioX8nWp/c+6y4D9w2jjXKVW
 hybFIjck
 fk/shbYAl9TzU9wIIUlLkq57T0XAM03bcVsOK9Pl2oixTf/+Iu99zS7xwVfWspLW5E1dQpAhTJ216SEYTkjeg/1mGKLkJId48dmD589+kqwznPTWgv8ujay+BWRR7gEE4fz06WOAMmhs5iK7GlNsTKJWa2LHBKIlbwWHhowoaIc61f0iu1y5ecDPhcCzAU0UeA72P44BIzBWCksSEPop8WPOQyAh3IAvgN0t7kHgPxukS/GyyeBYi6wBmIb/TDETgLS1JOnVdLVERFdBVGZ/bbdSrb6Ax96sTp9eNTtfToj8cScwA0AOsHdZ1iBHC+7NRQBJZib4bVBotiL+41PWzuKbYuMDWdbU4M12IzfCSFqUyS9tchJZOAiiaW0PYSAi6jEGprSi6JliqrVdQPNl8o67zTdiIH6WUu37Wcs0Jfrynml4RXFntfyLb19lVLGd32/QHzExO8gPG6An/PoykR4k1leIN2ZnnFeDd/LdbRNo8Mb3rOLIUNLHDKYG/uhtETGII3x+cVF1IcMpLL6VFHM2/CsVVtW2GVgCkui5Vhug1eptyEE3YeYiTE0H84qyV2/i33egtcKBEidUn0dx9N/NKW5OIiHI6PmkguNx5cbNeskYVJ4LNRVeLD3+xExipyHfVbgULVVnCsIO7giUQ0AcMpRs2blP498sF29A/zKnhVxR2zSMsvpCahluCiMWXXhaWn4yf3bw2LlZlFLSnTEhS/C+EGJazDJUPama5NlMwISvvAWLPBcaN/Mhvu4WO4qClkOaw5bKxp+Zfgen4xNVZloFwppw9QV21QQqc5G6hATZGDYqMJw7F19Qh92GneqQ9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 27, 2026 at 04:45:12PM -0400, Johannes Weiner wrote:
>The MEMCG and !MEMCG paths have the same pattern. Share the code.
>
>Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
>Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
>Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
>Reviewed-by: Liam R. Howlett (Oracle) <liam@infradead.org>
>---
> mm/list_lru.c | 21 +++++++++------------
> 1 file changed, 9 insertions(+), 12 deletions(-)
>
>diff --git a/mm/list_lru.c b/mm/list_lru.c
>index 7d0523e44010..fdb3fe2ea64f 100644
>--- a/mm/list_lru.c
>+++ b/mm/list_lru.c
>@@ -15,6 +15,14 @@
> #include "slab.h"
> #include "internal.h"

Hi, Johannes

One very tiny nit below.

> 
>+static inline void lock_list_lru(struct list_lru_one *l, bool irq)

Here we use @irq.

>+{
>+	if (irq)
>+		spin_lock_irq(&l->lock);
>+	else
>+		spin_lock(&l->lock);
>+}
>+
> static inline void unlock_list_lru(struct list_lru_one *l, bool irq_off)

Here we use @irq_off.

Do you think it would be nicer to unify the parameter name?

Also the name in callsite and the argument annotation. Would it be cleaner
readers?

-- 
Wei Yang
Help you, Help me

