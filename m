Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6579CD6E52
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 01:25:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 078CA6B0005; Fri, 29 May 2026 21:25:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04F216B008A; Fri, 29 May 2026 21:25:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAE406B0092; Fri, 29 May 2026 21:25:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DE6866B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 21:25:12 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 88B708B951
	for <linux-mm@kvack.org>; Sat, 30 May 2026 01:25:12 +0000 (UTC)
X-FDA: 84822342864.29.AF3FC66
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8AA8D40005
	for <linux-mm@kvack.org>; Sat, 30 May 2026 01:25:10 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="CWmun2/W";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780104310;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=blzWfs+CdYUoQumGPXqABGcwSvz3mulcURHwgoS7ZCY=;
	b=7xcaoGXAevFAq/H43x9dzXI+nqaL1dzB2uIjWW///AtlZ3Fl7a/xgAnW7m7YakFoF7GXuI
	sZA/b/KkLdFOjxYDL+Hn/c4KYivgGzE579yekTU5/unHynA1Q3bNJALcePWMD23jeON78r
	tvG6eomxQ1z6XDPctjw3PoVNl8ACLJc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="CWmun2/W";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780104310; a=rsa-sha256;
	cv=none;
	b=MLSk8ZUmE95lSVHyLjO4hH4Vf7MEoZ6A3WpohIGbEPfv9oxDKdcXIdkHuwuzvu7aHcKy9e
	hc/q99wmPOkkMKa48aHTpNrizuLhBru5nDrqRQ7HQTmGXxZzdMxytzJZAXnEKCb6YKaQWF
	8gcA6MUntvPd+1/GmAn7dHBzrgW/v3U=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-bd8f6ef4ba6so2190519866b.3
        for <linux-mm@kvack.org>; Fri, 29 May 2026 18:25:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780104309; x=1780709109; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=blzWfs+CdYUoQumGPXqABGcwSvz3mulcURHwgoS7ZCY=;
        b=CWmun2/W3H/1/W0trND0Z4PIV732C+SfL1PqJH94l5LqOFmoOjlP9KPdFCwS/xTOTh
         zC1uvSB3ebmWWMlJ09Y/Tw0paWnB8Ftpv/bMn2YFhYimAz86K2wIsUljdR3WsGxHugHB
         sAQc57Dg3VAsqY8Cqg9Avg0zSXuGl+A4Mh46bNb1daf21wOhF9Wh7P2JJwzVXdJCsvZr
         qDtI8LFVz7nza5qjLAOgcOffgmU19OOq6/ie7h2e9vzuSv0gJuxjsU9F6jtRtdpcuiAx
         /LHTzcVXX+EEZ/qVH8m6S2wtcv5B2PwFklMEc+9taI0rfosq2E9QY6PvdXSwGJo1ZuC3
         iEoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780104309; x=1780709109;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=blzWfs+CdYUoQumGPXqABGcwSvz3mulcURHwgoS7ZCY=;
        b=SBB+pceT0GeNcXiDgw1NRWkqwb5PR29ID1+axBplCd1BEy6DDZP6RSeVrnj8ByCIrI
         5Jok5XwIqyUtn5z5iNTyQ8X14LS4EXpkuBgHGt9H+JMbCvBSzlHUibDc7ydJW/Z27nHK
         +cY72xNuiXtGp3Pgv5fHRzw5JL+VamwnRVwZ8dnOACD2yAC8OmDooBdZbclP6vGKbpiN
         kMdEL3DGSARNhzmoeiyrjbMK1gSD9pegm5YWjCp3nbyyUbYtw6vadppW+zEdXOvIuavt
         u1F9rkAFqY3ZA/CKnBQdkWeHmuoS/QQnerBa0dMFfpb1IRfkWgZrB4dCQsBdcO2GiZvS
         4V8w==
X-Forwarded-Encrypted: i=1; AFNElJ8N2a6eYaG4503xLjCd8Iq3trjHXM4d62zDwgsrJ1354qeVmZcOqvh1wlxJUVlwnuTDivhuFYGO7w==@kvack.org
X-Gm-Message-State: AOJu0YzfwYNwy7LT7Tgl1eaMCJD3ZRyyQJUQdhWDcRftbihMEFe4SDx/
	GTaSmGs8IzS6OJZ8HkbOEJw8ewaM98BP74iemK4bBPazU4v+QdCZEFED
X-Gm-Gg: Acq92OF364A7gTwTXf4n0t9mGVxPbvIBdmMr5t5TUSldclUmDGOaXNugePSwHWrZMnN
	LE6dQvGVkQJRnGfxlcReziuM9NwL//aPc36yN75NBgdTRokiPGBy0B3+yYWQK3ZafPgSwIMJmMI
	w4+s1+6n95ERrv7TDjeBwtnYfBTNqy73bcLElWA2njhmSVt+8uk15z/nC9nXOIYNBtxS2OIAbUV
	jWomVKz2oFaTQ3G6T89opupYgP8tsW5KdSQhHE+71lueOOlQQygXUmJype7KW7MDfR+xPa5WAk3
	lKOJqiKoQDo3m3asKwH5BZ6DBc9Y3PvNOqBTZrULvHAxhoWGspD6ZnuyQGnZNPYvXQOY8H9iuJU
	XsR+evNaYQDZQkcyx5yveXZxzZBhqhdkSTZYP2m1hKKMSeKvDIV3c6uBD3RANerYtuOnfvo5o7J
	qAWWV6OwVATmIrEOfR+FK/ChIx2E6A+6lWDNkJozHmSkQ=
X-Received: by 2002:a17:906:c10f:b0:bd5:7a3:a590 with SMTP id a640c23a62f3a-beab6cba322mr85730566b.47.1780104308756;
        Fri, 29 May 2026 18:25:08 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-be9d27f224bsm114374166b.3.2026.05.29.18.25.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 29 May 2026 18:25:07 -0700 (PDT)
Date: Sat, 30 May 2026 01:25:06 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Wei Yang <richard.weiyang@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
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
Message-ID: <20260530012506.yui5w25n3axgzpoc@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260527204757.2544958-1-hannes@cmpxchg.org>
 <20260527204757.2544958-6-hannes@cmpxchg.org>
 <20260529095628.nagjdy3f24z6qjtk@master>
 <ahmXqjQ0Vz4pb4u1@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahmXqjQ0Vz4pb4u1@cmpxchg.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8AA8D40005
X-Stat-Signature: 4zrytuigfd86gc6k1djzte8zwa7fu8ye
X-Rspam-User: 
X-HE-Tag: 1780104310-202102
X-HE-Meta: U2FsdGVkX191G5jXPs7X1xtc+udtKaeKhH26/ndqfsmG3CVNteEwLf1N2QsUiw2htLNDxoBRlKnmhnbhrf6hzfjHIbqIuyMCzW5pL2mCWTEiwyJ/IKOGDsLNJ4FVpUGhI3Mo+xsDPE64pwbnNmUky+SYVLBlPch34lm5OU57w9E0PgN4PfqBzzjeKv0vLm7rajumCYAq4ewaTxbC5lt/fdlDQ1DXk6whKWjKkr0ghX6jjRn/5wE9oYShExv5R5YY/Gs+ohrb4MQEsqA9uAuJpcNCAjKlKTBYGZ+BUI+nVtUw68PMbp12KjztALfbKFtsArSxzRfqS7JH4mSPFR4Bqka/OLvbWE83V+XvWIx1mcdGxdotLntcOMXbHTZGP0u8U59HcNWRlLNM63rUZO1CbygSnCvoF4G8Yk37GpQXvKD18JP3rvnAT/XCyEV5DoF/4yLuGlOBkj4NpbZfZrHcevICFfSgVU5GW6BswvW+UBmV461czBRWZYJN8GtwiSMdIoxEeyX18SQtzySxPe2ispqcLy55Nm9oNJ63jRdSAFuE4NPtlnHAIVg7EyaRxuftfrZc6gzudLyNTGVm4XAbs/FY+2EQO0JkzLO7zuWAxMHT/M3o2INZOOkUXYdV1l1SDv7YyPp2w/iSMb7T2jdboyhxmxYaEFRX1tZcD/nFp1rGeTFP61FA9Ds5SzpyRc+p4CJCu45g25Z25xnxrQ6li4eNgtf8ByZEu10b4VCE52r75cBtUoADbjUnL3DyTnhVNuISNRwm7k/FdtPcTBUqRkVwPzi1WeWMM0qmjtzMTuj5YE8e4doGzr+Qe1OD4YQx9Enz5s9pSl76dOtkDPxQ+kOQJZcUz+Slp2VzdvG1R8pevNXGwtWRFa25lFJZLDJRsSf3cJZ6vDr6jB75IpiBQcSIf4/wOXs+xxzeKioin/UNXT8HriS8O01UmuyXPJpjJWIkZN18cLm8MetPMvN
 A90JYw6L
 nl/vrJJ0pdv0dJv1IOjI+Oww184mrlDfzkd4swLIGmU31f5VG0r+lB5PaCaVWExAcKf3yDiCZ39HsLZPb4TGjuSBxK89Lr+UeQVJZEqHGRldgKQ7jkD2Yew8dr3NtL6LVJvBKFGfJoJ3wiyPchuaiOyUdYcCr4FHavEnItrkmdSl/GhxTFZEJXdBdQS+460D1WXCppqnS1+Yrp8W74o9a26b/G6eMKzWqeXoJTZI7evqSzklO+Yd8Rdk1WII/91Io7/AEUzsC0/qlVow3gh9A3BewgCMNX6j8zRYAsHOohiHby6zW+5k82jjkGSDtAndvi/kn0yG2oQWuIq5U+d3U4VSqHjIvM3vOP1UUxVjNQe3CrdYaSnLBTes8+gS6Dljx60JJiRH4NUnWDQ5AYdUwXLxsEy4X4+oxTGRuJZ3KmiKMDM61btIxpNE9aMwtqgT1biUheS7s1b+EkcbEHzUVHe63HAaySwKI9ELZ9YVJLNCc5pPTiO+CA+DOiT4jVNqV65syxb0XKfhiJals4NU5Q45AA/oZyThfb7udWw5lmlTCwrEy4d2VcXCtVJMziIbdpYEEJJsaR7W7akrdtsEPWzLVOkdbCW9izxnS5vyXn5JyvbK6eA8K7obIFEmshX1UGxcB6PbqFUzSyoZ7QNkGh273VUzu1nRxpUriQg3Lhs/627EaVAF2ipZwNOAV4vOycxRVq3vxEG8sxoQm23BLyRKUGcsnFl4nvms50sU49e31GLU2mEku1IWhojPnmDAfK6AobcCgdfykr6F3fQ2E5maiiiL6/uIRguwxovi9de9nEPSCSxsIqTDyS4nw+t67HIE+CXjBabz39NwpVmcX2wMog1/xoEvOgx+IDmDxVQn0BodSuZvKR6W69b115eBzy/aE4P4ngfVoIOY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 29, 2026 at 09:42:02AM -0400, Johannes Weiner wrote:
>On Fri, May 29, 2026 at 09:56:28AM +0000, Wei Yang wrote:
>> On Wed, May 27, 2026 at 04:45:12PM -0400, Johannes Weiner wrote:
>> >The MEMCG and !MEMCG paths have the same pattern. Share the code.
>> >
>> >Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
>> >Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
>> >Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>> >Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
>> >Reviewed-by: Liam R. Howlett (Oracle) <liam@infradead.org>
>> >---
>> > mm/list_lru.c | 21 +++++++++------------
>> > 1 file changed, 9 insertions(+), 12 deletions(-)
>> >
>> >diff --git a/mm/list_lru.c b/mm/list_lru.c
>> >index 7d0523e44010..fdb3fe2ea64f 100644
>> >--- a/mm/list_lru.c
>> >+++ b/mm/list_lru.c
>> >@@ -15,6 +15,14 @@
>> > #include "slab.h"
>> > #include "internal.h"
>> 
>> Hi, Johannes
>> 
>> One very tiny nit below.
>> 
>> > 
>> >+static inline void lock_list_lru(struct list_lru_one *l, bool irq)
>> 
>> Here we use @irq.
>> 
>> >+{
>> >+	if (irq)
>> >+		spin_lock_irq(&l->lock);
>> >+	else
>> >+		spin_lock(&l->lock);
>> >+}
>> >+
>> > static inline void unlock_list_lru(struct list_lru_one *l, bool irq_off)
>> 
>> Here we use @irq_off.
>> 
>> Do you think it would be nicer to unify the parameter name?
>
>Yes, I think it would be nicer.
>
>Note that I inherited this - we had irq on the lock and irq_off on the
>unlock before already. I didn't want to mix even more yak shaving prep
>patches into this series.

Reasonable.

>
>Mind sending a follow-up patch on top of mm-unstable?

Thanks, I am glad to.

Since this is trivial, I would wait until everything is settle down.

Looks good to you?

-- 
Wei Yang
Help you, Help me

