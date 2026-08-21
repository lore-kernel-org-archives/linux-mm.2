Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48997C5DF97
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 17:47:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F4BD6B009B; Fri, 21 Aug 2026 13:47:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A5D76B009D; Fri, 21 Aug 2026 13:47:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BC6C6B00A0; Fri, 21 Aug 2026 13:47:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 030926B009B
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 13:47:15 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7865740146
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 17:47:15 +0000 (UTC)
X-FDA: 85126008030.20.07C7C67
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9EE7A1C0011
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 17:47:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="OQnoSUJ/";
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787334433;
	b=G4l6Mm5xOBuIf6Rz3wQIPs2oCmsFp2t3azFmy/w38nALVs4rz0sAMsJ9LbAUkBc0VSH74O
	3uul6oz8vV9NRF7sa9mslq4X/tEnY0Hl6VMZ1H61WP0povs2iZbhOplhiM2YFWcLyyPUse
	o0+vrKaP0EMX2L0HfScWL5yJu80VZLg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="OQnoSUJ/";
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787334433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7LpovUuBXQ1rmSnUnPw6Mn33E9THVK5Leh3D5MMLADs=;
	b=hv025N23olZPTsCMXw6IxqdPztecGAga6A9pORfr6czpy4L6vx3Jybi9MI8KIWocitDqF8
	W8bEW1m9PF4CeiuL5Wy+/P4VKyuo5PhX8n/eVIQ9kiGWgUnajgUuviCTsPe4tOYvH8Kxxl
	+POjLrDd5zCiS9OyGZE6WDaJhBDJlGk=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-527e352a167so8466441cf.1
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 10:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1787334433; x=1787939233; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7LpovUuBXQ1rmSnUnPw6Mn33E9THVK5Leh3D5MMLADs=;
        b=OQnoSUJ/8qS3OKMVir2tyssOu/ZItKDci14qyvlxpS0ZN6wQNhoYeyzEnBfXQ3DZZX
         ojgO9x8oUvuaGf9a9apg4h2+eEOG+RMRerxVI893Aw0LFQsmo4X0kied9iRhuSqKKMg5
         IflmsH/+v8J+2F8KittrEf8JI8q+fKRtoVi26xr57hbQEbp5t7F80FO6T09EdJ/YYuk0
         2rGtVzrAXmZM7t7yCzh3m3jobF4OBrg5nfbBnd1wGvnC4A+z0dqhh7F62X8c8CfuRI8o
         7Y/x8qeyDNJOrBF4+HKKcV5GZMRpADXoX2I6c3YpNLhPKtpsyphO/Nzg1I+aY7UnNLxy
         Wapg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787334433; x=1787939233;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7LpovUuBXQ1rmSnUnPw6Mn33E9THVK5Leh3D5MMLADs=;
        b=KAXLOnt8bqviGFa+1syYbNSfzywfySLVuJu6EgZPyhEJ9yCGQl4d4zKDo/NksR8yzT
         zYJ7rXjgsv6ooVf7j/2peiHiAfnifaR+r7jTt6dotB1VCTgQKKD2dMw+xXWk3eR7rmYS
         RLDwz3yt0efqKeztq21AN9BCwtkLydIJsWe/UwgkWIKVet3mrYxFOSdeamhaE/EPgG6A
         R+gN7uUdYhymmSojq8Dtap2I+sb9IgGkq7pfGqZgC5voW/5aO6vJLMMywiNMsNgYN7sF
         MChnYrl8UbxWjUcEqvti3kbAL44626dtyqfdYbXnv9wn0L3Y2jES01p543LRO8xqJTZ0
         gKZg==
X-Forwarded-Encrypted: i=1; AHgh+RqeHBnbihR9sh90wn/gCvsinKc5KzYbL4VWzMj1S6ONDwGHd0H/93S0AIkg9pIcgjAiCZS6qei/hw==@kvack.org
X-Gm-Message-State: AFuF++lGGJWqE5J5le5E2Xm/wdb90wzfv5EUMUeS0nMncb3RlGNfzKWa
	iEeKLqNHnZZdyJ9U2mzHnlynTM2TiYJLEzJqUbbq6uSRi30gfNG84/6DWhFPmwII0II=
X-Gm-Gg: AR+sD10CJp6yqfPDMDKeqPEusNC/8drsdDPW22AAM1NXs+d2wunQHVa235tpNF/El6H
	OKdpq+3ZQaJmrOvZEP9ivqcRmg0OPxO4JEDyeE2/JnrLNPeWT7WCHrzNhTVj8dTFSv45Ezcp5l1
	1gJHHXBwZRzzwBm3sNwzl0WOiUSN8brT69WhI4cxf/1NdnJcWwYb4UcniOY2Gv06EuJGP0fKnx3
	Ut91/TyyIntvrVhJky9gndbChI2gFPNmhI2ozs34+ptK1LtNCMjRzXfcyy+aB96eVq2h8aQfMCR
	uKr29/qnqDiXQPIdXpxTp/JXX4X7pF+2Gj1m2vJ4KmWm/8DdZVwIXVxdLDA/E3o6AoCON1yj11U
	E5qmgseCZn9cNV127ppK6eJDbf1tRgoIgvCd9eiBWR7hX9OJheWAiHg+F135Q6cknxMOWSk6tv5
	w5z3EDesT31WB4MsbVQ5hH/NhqEt4lXZnHkNV+pL4PXy+SZtCg5qlg3HiRErX+r/MErW9Jp2puv
	VigUMLMNBcwUi8jvobZq4B++1HI50Lae8p8x3WmuAyl
X-Received: by 2002:ac8:5702:0:b0:51b:fb4f:afdc with SMTP id d75a77b69052e-52df573878bmr74337971cf.11.1787334432715;
        Fri, 21 Aug 2026 10:47:12 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90c5f2b2b38sm67816356d6.43.2026.08.21.10.47.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 10:47:12 -0700 (PDT)
Date: Fri, 21 Aug 2026 13:47:10 -0400
From: Gregory Price <gourry@gourry.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Dumazet <edumazet@google.com>, 
	linux-kernel <linux-kernel@vger.kernel.org>, syzbot+0dbf6d295b3350944f0b@syzkaller.appspotmail.com, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org
Subject: Re: [PATCH] mm/mempolicy: Fix sleeping allocation in
 alloc_pages_bulk_weighted_interleave()
Message-ID: <aoiONiqcPJG11J88@gourry-fedora-PF4VCD3F>
References: <20260821170407.3721004-1-edumazet@google.com>
 <20260821104043.f692421fec915c0c5bc1fbe6@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260821104043.f692421fec915c0c5bc1fbe6@linux-foundation.org>
X-Rspamd-Queue-Id: 9EE7A1C0011
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 13o1h661q5qe99m1yrd8xjjwy4g63711
X-HE-Tag: 1787334433-741931
X-HE-Meta: U2FsdGVkX18gUAj65vsFrKAMUvQOheVDpxlxgmRZAznXtlT0JQogQLir8EUPH1/dmw8s5PNEaVgAZUfvjXDDcQKPD+CydhiOJmTjeWWHYo/C9FMZbGmGqf9al3ZwNpN04i8CG4OOmcWRJeVLAu8/qsdii/yQtLvDvUxL7uVa8hnmNW9gP22jkoUFXLsK0IRmr1aW9x6dCemQ4OaXhjZRpSLSTldYUewsE2n0oOar3pDnXQfkE+GjeficGMlGG9L9OKD6vAp9Bt6BO1Lm4FbEXidbXMX0nHgClWyEW2omCTjqoTlwxgM7REcx/PFW+JNaS70hgxEMOUsUisd5IYEVcdahHi5WiFRSSoy4Xx8W0eLnhdS340sSFqyrTS3Xrjd5e8aoy1sN9JKBnPyppdzUV7JMPEY+5e3JIwIrIVTolXH0zWVtTmkEp/GCdxTo2tHTS4GWj2LmYgFdCBkwovouE3IdqUwt6iAFdALkkh53hHZmiH6hVCugUnWksQUFM3JAVp0SaD8X0mE5M02gg5lOcqyxjshqI7mkzRbcWonBwJUnUOHa5w/MJxVA1kPHI1ck49sZ8gO0BI1foIxVfdi97a1forxkycGJc9V6CjFJHGSDXiUciG94bmgGkR2VEFYO+rKk5/PtyF6rPdFTKHLzu9jQf1H8bLTTSQBMmcZOQoJpaghNlMFd/ml2W5cOs0CSVCpGlzSx5uGYipiTZPadF+NQW86U2LNvH2gCO+bLq6K3UOcRfKRFuIzNMRJG2tAmi+hQRdn+W8YcZUeZw32DMi1bKFIzvZDHqiSd+fMuTuGSL1dAB3HIJNk1B1hHe7j5RFSbPe8CQ08fjmfJTjWbFn6S/mVwnJiKDa07VYf/FBReBdviMfYUG0XEBMoCK9MrWcVlX/fEmnkgMXNzowyDQx1oy3gmNLbAfxtj8ZUoq3J2cYWuEar8Td3Aew6xJ0GV5K7Q2C1K29OA0wUoFRY
 aO2MIA7N
 mHaBf2z9zXw/Cma0fWkOx6LWOPFZiPC3GnCygeRkGr44/R976Zm9D+fkwWSzVVoYyo6ySX5JJ+eEORUQ3OQy97Xj6tzfjLqquyr8wJoBE6mjaqFt6pC8s8+RXIH+qzcAPCXsRjC+QNKmCo+nJk1MoybkBMd8MMAV3Q6DITqAnK3FYHjgxylVikaTVHnDt8z89tRq6pE6Paj4JY5c77kxZPOl7p+zaqk9PwwT5Zw50CR84B76rZB3Uk9UN6yYPz6VdOP1wsPG4xOF4kaOBlyQ8Ni8yJt3ZWJNzLnK1LKN+3+2ICW1iJ0YU78BnAi42sLds6301ot2n3Fbfytluv1cQ4fGrLSw+Zfp7Iki/0ptdUH2A3F4Ci5f3jJB81T0VYO/DNyyKgFmNLsWewmFbkwqbw3spcRgA0ZMdoh65VZSSEkIzhv8KtGd1Z2XljRwpSaFC03FZWXq8wr4Y3yMRD0EDGqyF7HyGooErY9bkGbIZ869YrRVsTPx0Mu7FhrpEi/gMl0J8W3ZCV1+41EINQE34Wm6HHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 10:40:43AM -0700, Andrew Morton wrote:
> On Fri, 21 Aug 2026 17:04:07 +0000 Eric Dumazet <edumazet@google.com> wrote:
> 
> I wonder if we *really* need the local copy of state->iw_table. 
> Perhaps with appropriate care we can directly use state->iw_table in
> here.
> 
> How much would it hurt to expand the rcu_read_lock() coverage?
> 
> A local array of MAX_NUMNODES bytes isn't attractive - 1k of stack.
> 
> A spinlock-protected static array would work, if super-rare slowpath.
> 

I would need to go back through the original thread when i authored
this, but I think this is possible.  I will add it to my backlog to
investigate.

Weight updates should be *extraordinarily* rare, unless someone is doing
dynamic runtime twiddling of the sysfs values and thinks that's somehow
a good idea (or expecting them to be timely).

~Gregory

