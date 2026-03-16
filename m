Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CEA7F53D91
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 20:02:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB0C76B0377; Mon, 16 Mar 2026 16:02:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B344B6B0378; Mon, 16 Mar 2026 16:02:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A08D66B0379; Mon, 16 Mar 2026 16:02:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 89A676B0377
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 16:02:46 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 390278B989
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 20:02:46 +0000 (UTC)
X-FDA: 84552999132.02.1580539
Received: from relay.hostedemail.com (unirelay02 [10.200.18.65])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1C10010000B
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 20:02:43 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773691364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7V3wvHKfGkpMPIV76I5Rlltr0JUjBnbucUah80AaxFQ=;
	b=vtUXNYOoP0fYOyBXWciaHZzv/TAJePBhIdGHWZXmg5ttf5ZM1vUFNOZX79zI21kGz79vKu
	NZg8UxO2UXoexl9C5CNoC7ko/daZ2/+/KPha9K8EjQxOuS8Vksql0mh3QMJim0wSJU4miT
	8HEHGsUcwQtD2p6VvGbS21Aghw82lek=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773691364; a=rsa-sha256;
	cv=pass;
	b=taHCt9OHVN1Jw46znHUIk0rxCWyL19rNV3HHqWy+RQ17nn36xm9Gqbv4EZCZujSZGVJnEV
	1XxvXN0M4E9dkznkPNHVr7RAGV2tjA65NqZpUuiIJXjsIsq7GbDcGjvkrmLjhjL4ltfv0l
	tabjbvxUi7V99HlFKdpkfvAvr0nV9Zk=
Received: from relay.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9C41013B151
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 20:02:43 +0000 (UTC)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6C4261B81DA
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 20:02:43 +0000 (UTC)
X-FDA: 84552999006.23.F3F9494
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf16.hostedemail.com (Postfix) with ESMTP id 926A3180002
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 20:02:41 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773691361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7V3wvHKfGkpMPIV76I5Rlltr0JUjBnbucUah80AaxFQ=;
	b=GNOAaRFjPEgnVbYp5v84b2gGtBUb5VTfuNfFF8OmI6PSugPUE1/5E0TSdRmv6dPv1nz5xk
	gAMggWE03Vc+gHXkZbLZD3yvtTz9RO5IzhuuRZ5zVabV4JK5aJI4MqvkJoGMQTDglz0QlY
	jNaubg+5Lpoetri2frNhSRXCsiH6SKY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773691361; a=rsa-sha256;
	cv=none;
	b=JxIzLlO0eZFyk/4YUZQ5Est/yxuwJ7xZMu6Z0qaYJ7wm8F8MbrChtjSHLqjuQhZnEuROGl
	l/jH66DJAbE/1x+82fr3Rbmn9SxvabLZh1efHlDqAw+faqBiH9oJbEj1GZpeixV3+wGpF7
	3XBDmRrKV5YzxK9gDqYj9vYHN3dGXi0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=RRuZUuAa;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf16.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=mhocko@suse.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4852f8ac7e9so59914215e9.1
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 13:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773691360; x=1774296160; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7V3wvHKfGkpMPIV76I5Rlltr0JUjBnbucUah80AaxFQ=;
        b=RRuZUuAa1ZzUZ0vACMYFkTRWFZupDw+v+4p+iMtyhJO5kwU32nFKKiuqXYxV5NyRmv
         iFu+b1TUR1CRLS+Q5fkkHqMJkug6ZXc8HynMYw9fYQB6N2ExYd1s4CsyK9ntr8T0iD5x
         tRYlE2FAaS6E8tq8R7PHELbKOpwcrCuwWSB38CyVQFLyzEMmGDooFabg1/fJWlZTIdx6
         /ZFzKpW2wHvzPOjUYZwVKOAaPE+gWV8joGw+GmI0rzic686kIn46TSTGCtV2r6Aj13Vo
         dlEhREGqtECqpYKrDPJO/Dr+psQqkdQ6yuEYLiNqVGDyT1X72AEaKjszk2UXwcw7dNSo
         JpfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773691360; x=1774296160;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7V3wvHKfGkpMPIV76I5Rlltr0JUjBnbucUah80AaxFQ=;
        b=JHuxFgFVD315VfsLA7sKCno62pfhY+aTV278eFUjx+JADcay2rT5OFzhTwRlQyyLo8
         drmbm/6uf+vKvs3HnJ33n+i0eeuJ+RoO7oPZDntGl2I4C2Zm49lL8F2pFCy58EbBPZG3
         t3OHlEljn4o1Ns4n7+ieyAruxBSJvekbgUqbxMsvTpy/MfVjhjmew+GX95EFMoxTSXAh
         a7E23OGibIbgLXLDFYY92kQuwVj3iIe8/nBCyxTO2BZSBX3ztrsq9YWgPd5jmIx+efJa
         eOBYIGTjOlcdM2fY0B/wWgvRleM14Te+Bhx1E2Ha/nPPR+vlCYO91eDlYwkOxoanjS4m
         EaUw==
X-Forwarded-Encrypted: i=1; AJvYcCUsuQnfk2YgHY0BDrdglPKYshOmyTaxD9ydfWHNksgy2+lcsVgwRWEC6fG2d0lDC2KrzbzMsfHeNg==@kvack.org
X-Gm-Message-State: AOJu0YxEmNXrO+ajDJbEcaUgap40kXzQ03s4gBE0kwwPwMQqEERhq/mD
	rvOYywbAhgo3f0/5CdnwvxoEX2la5NHI0H4JwEqad/JyGWoMTZoQqyBTy7PIMnyKRRU=
X-Gm-Gg: ATEYQzz60r2udftedkZKNC8OjaZMNv+01x+SiYQc7AnDC6K106mIT1Q9Ht6HP1dcPB/
	zn8A0oQr3C8p1yxewTOvDOkAX+/6bxq7p7ra6Z3zmErcYIAKESQywM7EEd2KdmS4OyEvj/8AOFS
	r9+qzcxLKwJOXomy5UmIog42UaKr4tVKZlHGmDMXtVBxluIgzw1Sp4LKev/GC/thcZVDHwc4pnk
	6UNTNAfjbp7lB4XSivYuEDfiMWRCNQmjC7Rv6uQMELqG0oNhwp3HQYO1lwmZIXt6UQJOdBWZong
	LYWHMMylxyJhyVcgcrYlVPQT07rj2AYjdo36HrfiNAgjDHrGGUjNpfmxrjJe0nQyHbsH5MS5p2b
	Bn0m6E3bqc4OZt0eyRsLEM1jKprbYvVqyiEwDbcYApjtKxQhyqviD9/PptYraNil687GkTdFMUB
	YmX9OX01T7Sc8udAtSg9/CHdQwG/ZYKQs3Jw8O
X-Received: by 2002:a05:6000:188e:b0:43b:4aba:8f52 with SMTP id ffacd0b85a97d-43b4aba9116mr739610f8f.32.1773691359851;
        Mon, 16 Mar 2026 13:02:39 -0700 (PDT)
Received: from localhost (109-81-21-195.rct.o2.cz. [109.81.21.195])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b4389321csm12045529f8f.29.2026.03.16.13.02.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 13:02:39 -0700 (PDT)
Date: Mon, 16 Mar 2026 21:02:38 +0100
From: Michal Hocko <mhocko@suse.com>
To: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Yu Zhao <yuzhao@google.com>,
	Rik van Riel <riel@surriel.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"T . J . Mercier" <tjmercier@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Zhaoyang Huang <huangzhaoyang@gmail.com>, steve.kang@unisoc.com
Subject: Re: [PATCH] mm: remove '!root_reclaim' checking in
 should_abort_scan()
Message-ID: <abhh3lKb6med1LSp@tiehlicka>
References: <20260212032111.408865-1-zhaoyang.huang@unisoc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260212032111.408865-1-zhaoyang.huang@unisoc.com>
X-HE-Meta: U2FsdGVkX18oOhOByMyRAt4QymrATe9lDKJCq+ZPApXEa9K7dMlt+bbetBX3Ub1mfr0kxBUXmTOXL2pjozvfcJ7eZz3w9rSiWTmGu1Rpslg1TU01+G5rtxqebFGFXUVih/BVy/LZ9i+9PGjBgYuOHLIya8SGkk/i/xTGTcMnlv8GwfvFPMexcajZOuINxe9Cg8hJ0cMjv5vIGoY9ZHuT2ni8QgP1ai1axrZoBJag+Qs3iu+ES2B/SL1UNVC/cbRy3NsOlNSwtYWCK1AdU1JuvSRwDetozW/uQ26P2AhnViOvz0V3R0WVYc92Qik4FqqHi1mvdunb/IlX/QmAPiPdg3n6IlxcGcN3xpY7mN0bNjzjdK+qQNdTV8tHPllyFPN0fRqxpQ2FmfipE1UqUWsRNsohGT8cPuJlzXFDBba9LnSox62+n3dAactdkaZtFbjSeFTxBMmSdTjbDYQshcBJOprMj9dfdtpJzCOcxGt3LsdeUWpu6BHMZAi8f/xxjFC3OxxbSifBY3YUxYrVaa/+se1pOJ1RyLP1XRWup7pBlb55I85U499uvK5QAX/ZyQbCV81T4dH93T4B2EsFWTMQgZqlI9OdMyNOd8DnZ+i6qr8MkIYFaRN5QAZJ6u8RrpMCh0ZOLbBX8oL1YuPHobjrgQ85siQmDVwy5n9Vllq9Qomly/gmSgJDsOoMEYUrEVEYrRstXL2R4zPjn+icTIa3JNWRbPoCJELtAL+s7CKlRDfRTxgS0qqwBJoDKiqzLrl4tP0UTfcJgP7666ZDiNmM/qIvETVFPNEMnEAeqp6uWwbJMMMXdSwGqeikQXRxJYLDcBMJUewwuk1PZOTER6q8TfBq8wjondehQkMe87KBT0Zdaeuyie+fBavWYBe4OcjnGwrHNMKAKTRgA93DpfKY3T+sZUCSDMWGBpqi4cR4pCvnpyBXlIxFZxGu+9kRQ9gb1V/lmIwy5Raec4SUkGN
 4WYKefhy
 tBkROsntiFjhkYhJds950BywgFFrbUV2OC8TtVruE1gySQx8hyWKPWdVM9kFehUdmKFfq7akXtHnEYKF0OPeVHsOvQ9mDpARV/4K+OaE1bJ4TE7LWZu/oEoqonksAPEO/fs1gmbX80aUST/AJcxEct7ofw3JzvNdono15SvobESR1EdIT+Hsbxvk2p6r20rhfpr4zKNzHMBprgSHygiuMh3OVDabTp7QEM+ViGPe9Eq2Jo+I=
X-Rspamd-Queue-Id: 1C10010000B
X-Stat-Signature: nzesx8sgkyftesp8fxf9e7g5x6ytso5y
X-HE-Tag-Orig: 1773691361-361041
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773691363-422143
X-HE-Meta: U2FsdGVkX18gP1xkSscPFwuQQelwhUvLjIHfWu1Xi30U/mM6BaUOrGUKITMjLyDkvBytpudURC7WrfEVIQSG9aAdQv1ZUX3/oHxXmutgjMhEnBaOOEg4xQarbqr9UkSIqGIn+7Ji3jZ33o3xywIsE182kwH+9Mi1WWjyJc/2Jw9UgbCW93HMVQlCRdb5XFrZpMHT/q/7Td01n2G08ZZ5mUCGd/6hts4LLmPPmz3poqYv4Ap1zT18v4zegNCTfgjoSY3hYxx0YxD+oEsGuKX67SOfMM18KvlmWdCr1agZjKLeD4lE+sBT7+3Do87kFaWqkauxk/gy6t7Jh14VJ9ddd8rpjDMkVyGyzgylyc4bC5itcqOMj00WJsuC7PCTYMQotN/iIZppyBxKPSjLcr6L+s8gNGwbjXRN9ruhjbuiAhwJVaT+UlrGzImuxBuJMtQAkIxdcjL2zL2Fzappp7ulntxxLI7YOGMQsUFUdWMSegPw6kHlLsU8kzvmQ9GzN4SPVSx+s5felqmNwBhPiXz6hlZ5HPSj/7UzZEmQVXzgr6tJZavRvIr1TDph2s+e/tnwMcBCAJvdABPQTfQ44kldOgqYsf4E2c7XXHe0TnXUj5cJWb14p1CQy6c95pX90bY2bAjG8vlYcG2Zo7Rrey5YvhBZi9AlI7p/ZNRHcdmfn5DU5e342ho9Xa9H0IbdfT4aaNLJD2hO1+OuecFpOdsVWTCUQlJYhBPLTiPyDExY9oOq/9ukjvEacXfeYLzel3yM+RB+bFYqfhxtFF7MWWwziA+1pWBbrrM3t7vafMs0XaajcVU1OApnkIkq4uxgYw4OwJJ/v6tdOQBKypaP00MosZ6RvbD3eENp3nigq8BGEY7KCL1wlOPh3DdvMXDhhM4AFIaAjDqgXr0pUOlZXfcAf4g6lbTNG2eYcb5/Oe/iFAElN33SYCVSsVzj7oOGsZKkRnahGigs9duVBs56dH7
 HA1AdSi2
 LouZN09kEyV8th7kt1ljNRyk0A/RxKaav/0rT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 12-02-26 11:21:11, zhaoyang.huang wrote:
> From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> 
> Nowadays, ANDROID system replaces madivse with memory.reclaim to implement
> user space memory management which desires to reclaim a certain amount of
> memcg's memory. However, oversized reclaiming and high latency are observed
> as there is no limitation over nr_reclaimed inside try_to_shrink_lruvec
> when MGLRU enabled. Besides, this could also affect all none root_reclaim
> such as reclaim_high etc.
> Since the commit 'b82b530740b9' ("mm: vmscan: restore incremental cgroup
> iteration") introduces sc->memcg_full_walk to limit the walk range of
> mem_cgroup_iter and keep the fairness among the descendants of one memcg.
> This commit would like to make single memcg's scanning more precised by
> removing the criteria of 'if (!root_reclaim)' inside
> should_abort_scan().

This changelog, similar to its previous version is lacking details on
what exactly is going on. How much over-reclaim are we talking about
here? Is this MGLRU specific? Why doesn't our standard over-reclaim
protection work?

> Suggested-by: T.J.Mercier <tjmercier@google.com>
> Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> ---
>  mm/vmscan.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 670fe9fae5ba..9d900be478ea 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4832,10 +4832,6 @@ static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
>  	int i;
>  	enum zone_watermarks mark;
>  
> -	/* don't abort memcg reclaim to ensure fairness */
> -	if (!root_reclaim(sc))
> -		return false;
> -
>  	if (sc->nr_reclaimed >= max(sc->nr_to_reclaim, compact_gap(sc->order)))
>  		return true;
>  
> -- 
> 2.25.1
> 

-- 
Michal Hocko
SUSE Labs


