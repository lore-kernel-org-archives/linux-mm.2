Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29129C61DBE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 13:55:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2003D6B00DE; Tue, 25 Aug 2026 09:55:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B16F6B00DF; Tue, 25 Aug 2026 09:55:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09D1D6B00E0; Tue, 25 Aug 2026 09:55:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C9F946B00DE
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:55:42 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5C65C120452
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:55:42 +0000 (UTC)
X-FDA: 85139939724.06.012E397
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by imf29.hostedemail.com (Postfix) with ESMTP id A5665120004
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:55:39 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=CAiq477W;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	spf=pass (imf29.hostedemail.com: domain of "prvs=6697db029e=alexghiti@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=6697db029e=alexghiti@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787666139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AUE5gbKvw3ZCdVV44GNbAtmKwKkuOG8ivuC5PtQ36/8=;
	b=j0Kc+VOuXdhk4WHSq3oMjkzHovCZbHW+gsQ1dMIeLBk2nM9wD0Sv9A7m6g17WgNeDBytxd
	rp2jBIlK/iZL8ixlOeqSONbkP4I29qUOaHhxH+gDE/8JHnSi79IxqSdz5Sf2h/n4Y+zwml
	ep0kYrNaReeQI1hBmBJ+bDup8gR/Of4=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=CAiq477W;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	spf=pass (imf29.hostedemail.com: domain of "prvs=6697db029e=alexghiti@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=6697db029e=alexghiti@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1787666139;
	b=kmBQDksaoSjWXj4U7WCSpnyJjwF7X8Esa48XLUz5rApsw+SvdYKkN44nFuhtjpIrlGWgj7
	UHX7yev65X3ZYsW6cP6wNglfh7ZJ1jqbF+Bx87l4yDZEf0Ao5nh2h2hj9qGKekleJTqo11
	i6eLkbspF7SSM8v41e7lTi0D8j/RtOc=
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67PAvTZL2936951
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 06:55:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=AUE5gbKvw3ZCdVV44GNbAtmKwKkuOG8ivuC5P
	tQ36/8=; b=CAiq477WtkSW4zXHyOLTD1LnW83mVM7+h4JrFR7GUARbJ2Pxwf5/E
	f7M3JEr2LlhqoUz7DeT0eq62g3yjh7d/px1jpFdiSKsF/I0UNQW381kz2XwN9pTj
	qUAeCB5oUJkVnqGWvPyhZVLooq28XsBTcwcu8sQyJwrmi5W8pyCOU+I+yqZV6D5v
	nz17gymxQ5EziiuN7+uyk1YLacTC1wuFiTQAuWCJWKeEkY6TOZf0zpdOytSqXisJ
	1ORyKrVazzcx3FfaXkdWQF/U2hsf5Z0CbtEXMU3P5SfUlJD7raLcEJUB3uv68Ggy
	qxOdoO9g9Rd8DArT4/NjtFJuimQE2jDrw==
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4g77t2jm85-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 06:55:38 -0700 (PDT)
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-6a17c83732fso5057600a12.2
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 06:55:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787666136; cv=none;
        d=google.com; s=arc-20260327;
        b=AMrrYTwLyNq4Eiy4yS0hA0S0nFtcHfVJtt/fvN1o1lwSBvjhx10IiTgkVnU032yFOG
         RcDIWsEe+YV2o383CjvgvimP3R8UbuPt12Ll+PgxR3qFnW9RxVyNLu+U0KulJ24Hork3
         pbe5ibtiR41p11Th9W9wbapzRNCwa1dpuyPXhnxDdNIVbJh1YBrcSOoOkNsUa3ba9rwW
         0bSx9HNZnBUcBh2SQqlYR2rgjFwrVB72rg07wWDyWKY8F0Hs+oX2K7gXSs5p5InCGe2T
         uPXS1HvR4gDhK7kP8rMZZJVevfAm4qFeMO86Mf/BA2zlrbNbO+RFVU/bdlmcpEN6Gqqp
         h/yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=qx00t6fKPLNvWhLaxrxwMViaY+wZYeSOBENsfzBwwV0=;
        fh=K4NedPmJ+r4Lmr1YUPu/J/9b5bJn/69aZ8A/DN9woFk=;
        b=jiap2x1F5kDmfcd/2w9LyTE8YxPK8zMYTaA8zzhDmYX03aPQ/STAIjWePNFOGsy4XM
         Ldi2sVSI4PLRClSEZt6dsvLRCWmXN7LfB+tqIVVEwZg4XJEum6/0aIKB+havbi1YVO6n
         LPdIjEHDTRZiW0w3FRjKCg/lUaovARahLYEXhqZUQgJEtTGM7cMb5nfpZymliGSyUugy
         ELzCte6+2IDIvqbBfbnOvSkxVmdNzEfT1dczV2RCtR33m1ZSP5HKUxs5xcUnqzYBN8eU
         fVZwcKwIXRU9L9MgBP4cjeDHb35GabuRTE6TcD/6cXyqw/D8uYWlBlRzE75ECS+wLvSV
         ivAw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787666136; x=1788270936;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qx00t6fKPLNvWhLaxrxwMViaY+wZYeSOBENsfzBwwV0=;
        b=sZBIRAJJW16KOL5iGBoBQsz6/zL0P1eFD4CpTmcHPwgzp3XD7vTYtFjjUhbMw1VjR+
         hnhzPknoNs4BoaB5SGm5s3CBNSWTF5veP29pII1qaXbOKTIdf6O/YwPBX0XPMOM7gFh+
         +4b4heZFfNK34mn9lLamdvVQClTbr+0wPZGp3G/5t/5avjtpMiid6k3as1fB1rNAMXsN
         gmRihf9pSOIQFLEJwRXAbqDauHHc36vPZGxTyQ5rIjuTg+xB3VXDDgF3rr9KJt4buFbt
         dbvaeTirnPqmqGy4yuBDbjVjFA22h2v+xys80JVhxUrd1FTrnyOhtWNuXMhWI++DDaS1
         XSKQ==
X-Forwarded-Encrypted: i=1; AHgh+Rpa7cd9h4d0f/1PitR3Nh4uWDEPIaet1tTukOWt0pSy4CrLDNfjtqpKtHE06bpiESWOEEEDl0XhsQ==@kvack.org
X-Gm-Message-State: AFuF++nkW62C7Bwro6GwaMvyQ9a0fD+3axms7s/mKlFcKaVXhcNqHX6q
	PhR7cAcRlEUEc39kgUfDLkHBU5mIW5htlNXT73qzbETCFYAryFydruHL6hehHMoXlhkCOcw29GO
	afbtntVZDazOLBoZp6JkNT5r4UOS312X2qEeJLaUULjb9ew8P/fdXJurPsepoCzPBvlEYZcqO9l
	NZxiorNkfm+czESYIofwH9/itz/w==
X-Gm-Gg: AR+sD11ugHk0oVelLpy2Ar4FAdV/vSoUFn9jaUYF98UvpX0vQYnwNuMjNanBzTuWBZG
	eHDsptFI/js/9F3l7dLTxjnaDXDWvlPwArNp6vClnw3bOyHnPTlWl3DwqbTaQ+yih+od4z+7jYQ
	81aKw5rn45cIBKS4Jz3/n1wG2O1h1U2CBwbCavzYGSSf0ov4tPmbekULXx9Tr5FlsU6nO3dYfr
X-Received: by 2002:a05:6402:321a:b0:6a3:f3dc:d7f3 with SMTP id 4fb4d7f45d1cf-6a42f216053mr43322389a12.16.1787666136067;
        Tue, 25 Aug 2026 06:55:36 -0700 (PDT)
X-Received: by 2002:a05:6402:321a:b0:6a3:f3dc:d7f3 with SMTP id
 4fb4d7f45d1cf-6a42f216053mr43322329a12.16.1787666135702; Tue, 25 Aug 2026
 06:55:35 -0700 (PDT)
MIME-Version: 1.0
References: <20260821093606.2231216-1-alex@ghiti.fr> <20260821093606.2231216-2-alex@ghiti.fr>
 <CAGsJ_4zHcW8oJBRmCDB2WYFc_uv9KP+M0fxOgnnfmA3+x06t4A@mail.gmail.com> <CAEmasaXU9n2Kxjf-+gvjevGJ6LS0EU8fWWHtb09SDEi3phUJmw@mail.gmail.com>
In-Reply-To: <CAEmasaXU9n2Kxjf-+gvjevGJ6LS0EU8fWWHtb09SDEi3phUJmw@mail.gmail.com>
From: Alexandre Ghiti <alexghiti@meta.com>
Date: Tue, 25 Aug 2026 15:55:24 +0200
X-Gm-Features: AcwNN1UkZPwv5wQyxl-BHwY8sLw4TH42lpY4bevPgMKUhtwinwr-WWziM5iRyPE
Message-ID: <CAEmasaUrof29qq9hXaUmtPstepZktmPMyMdQoBn0zCq4nF_UsQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] mm/swap: move LRU insertion out of the swap cache allocator
To: Barry Song <baohua@kernel.org>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Johannes Weiner <hannes@cmpxchg.org>,
        Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Hugh Dickins <hughd@google.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>,
        Baoquan He <baoquan.he@linux.dev>,
        Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI1MDExOCBTYWx0ZWRfX/FJdOtpRC12u
 e+lrk08/LeXiMYt5mpB3wApzFJep6MWQxqEXlimUISD8Z03g22j7ZQ4/WGeZheoBI1OwG/2Oc8o
 M+CSfn7eWyemBJN782i66//nGQzzYbYpDtRNs+lPakiecwPYWdaMToq9xgy5qxLOs0bSnc6Piet
 QWT9BRzUa2NtEm2psfjf3Cea+lykFIDk3Lv1zHbRk6nRzr2uMmF1cxhpCgXcSaOhk8BCWmYoRV/
 BXRhoVZAhl2PIKUMpdaa+bh1Dfy2NXo6WgyaPCYlz5soho1X90EamWMQMDmcZv4fIXP9xB26DCz
 c69rspFOEI7aZAiHZqy+CrJicVf+YvD416wt04UXkjgnjwouEHaII2stlwa5EydKfTVXOiazPxR
 i9eRmLgE4sZ8yyKTXqwQUsQFwaZMXSy2Q0eTewFh08uig/0mNXnycosXtVYi6t1T/jRCahKtxjn
 F4hOsGPAwCD2k4fCCVQ==
X-Authority-Analysis: v=2.4 cv=d9DFDxjE c=1 sm=1 tr=0 ts=6a8d9eda cx=c_pps
 a=DTy5UCxgudPLKrSn28m7Kw==:117 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=tpM8CJlwf7uhpglF1g9U:22
 a=VwQbUJbxAAAA:8 a=c92rfblmAAAA:8 a=VabnemYjAAAA:8 a=GvQkQWPkAAAA:8
 a=LhV25RCuhJYuqqpyPu8A:9 a=QEXdDO2ut3YA:10 a=VzYV69SsQLkmnS9OQLw-:22
 a=GvGzcOZaWPEFPQC_NcjD:22 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-ORIG-GUID: Ma8rsVy0ZSVAlh5j50ocjt51TlNCwJLI
X-Proofpoint-GUID: Ma8rsVy0ZSVAlh5j50ocjt51TlNCwJLI
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI1MDExOCBTYWx0ZWRfX61TTwomFA2f+
 rTy+hChvCgLMmReuyCk0ZeFqY0ySH3kpBPYWlZ+hr/Nl7pejnyVSF6s//ImRfgp0cgpMTUOfLlh
 EpXewO/nbLRaWuMd5rbZeCGn8L0EvYU=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-25_03,2026-08-24_01,2025-10-01_01
X-Stat-Signature: 35yykkagj876wh9wmu1i9xn6iwpbt84x
X-Rspamd-Queue-Id: A5665120004
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787666139-965112
X-HE-Meta: U2FsdGVkX19/hcMVO8r1WcfcnDtxQClKJgjE4vm6Km2qnZG/giIodquOLHwFbsapiq51VJ4AEiMmmC50LiI/pfqau4ZwXInMOuSZl0nhgQyuARhaGw+VVp4jlElLg9aWfbqWZQUij1bKkCModO5mM3PR1BsE+7k+TeUw5pEoY4yKaFPPWYJPvCfz5c/QReH3htkUTU/BRf+YwY2TkWrCarGXbqPpfXpjhaP87R9Kh8oD1txXO/+5wV4oZwTs1/p/czk6mAM5q6jiR1vnmNzpFuYgYjZZliUF271qSVW9chFu4kbsTJCaWophA0fUmBl2voA8eEhyd0qs3reifuyypSm3QykjLvL2Av5ldAJb5je31HaCcLYs6EzGnNfqn8r4FjQnMBbaB8Z6o8ZCJECu1GWAcnvnp0td1rGPOu+QXcVQQiEKbIyn9HsjnuWWjwfpM69Z2zkXj3fbvWhWOHePOcbKD8cZLUu2BtXqo2zTSY0j8g4wYMAZrp2KnyGf7bgJgY6zO5pfkXXedeyhhCKgstVXGlqSWqC79xP/eegRlsHc30Tx4ZXA3Oska/3CS7XtvexX2lb1+gqCGmGFOF6YIO/b1VVOkASYlHtcTKIGrh6Hmmrp4F/Vj6/ez1N/2kiJ64bLmhxBNQbjx9dSHRNU6Z206LwGy+hhZfwJboJhwNrmvkjpsiNDTWeUxhLVDMnxyybBIpZ8QoM3IcHDmXADXOLn8kP00NZvERknYzKQMSUlc/rm3wrIxt8VFmf5hGoqjeTPU/r8tp1+t8ze4zVuAHvAlpGGyaXDNiWCxpF2LG/RqwLl+/XXlIFCqNmbc0ThXrRGy4TJAc2qa9rGfIZxzZuKiaX+kmF0sef16onJGelUucFeXtnCBdDXLKgcmRupKx3EnsnTj2AkYNsY8xZF+N0zgqwyOJmBbDB+qY4gSTSq1X2GbPnHfUJgrmHPTjYf/rOz8BaAzpXp+KQGOV5
 oPt48Mn/
 BazMQBThEvpDBIcaHXMIyWWOS+8PpV7wzrrvU5zKX1MqUtRhrXQrmqxmCXPyP1qmZC6ni9/wbmBbrFgcRWGDIC4jQmQAI2KWeJckNz7OK+YlyedsUQY4z3sJcF7e4XLxcxPRfyrTnpaa5l+mc8oq65Gpjc/KOlvinjgzxR9/fh5yx3WQ8sq/sz0vgKg7U4UohFWNNlyZwre39XR8t9rrnWz3JHULkBKQtsjBrkJJXqpd4zGH6A+MZfuNEhKuA32WBYj1bHltcFiT/2ZCZZ1dTCYyeTRXT408vhDmp8+MXOW8M/pNRlkbAGnq9pXr2Y909bHWvAq2+g8eA951U+4UBXXTgWkWbGCSfmcSfo3Y9eKTaH+W5W/X+t7IY/xF4Ss2NDDBotnu9ZH8DmLqCL80TVbTalPUkQWkJ4XOZyNs/bx565ZfL58BuwRhJYIzuS46+ZyqS+ZpWAD1/cW1QHrmOBFD0AMRCxNWY/zZRbKHSDju7PWSM03DGRbn66fKqflZvkrVSyvMHap2CdTJuBlQUnEH/rm/rNewBZDb25A2Fc0GvAKPJDEH+0x40PYVhSpMEdZNqVpSh/y4avIJ1f1N/+8R8HzIM2K7YYt3gp/v6CYuBUAmYi20RACXP16i8rxMqvSFP93EBaYR1L83V2jDgDJh/s2YA3qsHx+1cEQiR80/MaOBReICKZ7+3KRuduRL2P3IRKJoQ7Jpgpttp992zyEdUU62saMBGPemg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Barry,

On Sun, Aug 23, 2026 at 2:16=E2=80=AFPM Alexandre Ghiti <alexghiti@meta.com=
> wrote:
>
> Hi Barry,
>
> On Sun, Aug 23, 2026 at 10:39=E2=80=AFAM Barry Song <baohua@kernel.org> w=
rote:
> >
> > > >
> > On Fri, Aug 21, 2026 at 5:37=E2=80=AFPM Alexandre Ghiti <alex@ghiti.fr>=
 wrote:
> > >
> > > The swap cache allocator adds the new folio to the LRU itself, which
> > > forces every caller to live with that ordering.  The next patch needs=
 to
> > > evaluate the refault of a swapped-in folio *before* it becomes visibl=
e to
> > > reclaim, because folio_add_lru() consumes PG_workingset/PG_active whe=
n it
> > > picks the LRU list (and, under MGLRU, the generation).
> > >
> > > So defer the LRU addition to the callers of __swap_cache_alloc_folio(=
),
> > > no functional change intended.
> > >
> > > Suggested-by: Kairui Song <kasong@tencent.com>
> > > Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> >
> > Hi Alexandre,
> >
> > I=E2=80=99m getting a bit confused, as I noticed that you also have this
> > patch in another patchset:
> >
> > https://lore.kernel.org/linux-mm/20260818163221.589352-2-alex@ghiti.fr/
> >
> > Why are you including the same patch in two different patchsets?
>
> Sorry for the confusion, I explained it in the cover letter but should
> have explicitly answered Sashiko's review on v1.
>
> Sashiko pointed out that moving workingset_refault() out of
> __swap_cache_alloc_folio() breaks MGLRU folio placement:
>
> "swap_cache_alloc_folio() calls folio_add_lru() which places the folio
> in the per-CPU lru addition batch. If this batch drains before
> workingset_refault() executes, lru_gen_add_folio() calculates the
> generation without PG_workingset being set, placing the folio in an older,
> suboptimal generation."
>
> https://sashiko.dev/#/patchset/20260817144622.137133-1-alex%40ghiti.fr
>
> But good news is that v5 of dropbehing will drop this patch :)

Nope, correcting myself here: I need to keep the zswap writeback
folios off-lru because folio_add_lru() puts the folio onto the percpu
lru batch which holds a reference and for synchronous devices, this
reference prevents the folio from being freed by remove_mapping() (it
certainly happens to asynchronous devices too).

I have just sent v4 of dropbehind.

Thanks again,

Alex

>
> Thanks, Barry, for all your comments.
>
> Alex
>
> >
> > Thanks
> > Barry
> >

