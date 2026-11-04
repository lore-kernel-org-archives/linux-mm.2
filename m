Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A2B1606A32D
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 14:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=fa7C4CtL
Received: by kanga.kvack.org (Postfix)
	id 504F36B05BA; Wed,  4 Nov 2026 09:07:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DC3F6B05BB; Wed,  4 Nov 2026 09:07:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A4E56B05BC; Wed,  4 Nov 2026 09:07:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1A6FE6B05BA
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:07:53 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9F838140727
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:07:52 +0000 (UTC)
X-FDA: 85397615184.17.5EB9FF4
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3AADE1A000B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:07:50 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=fa7C4CtL;
	spf=pass (imf19.hostedemail.com: domain of "prvs=97681eca36=alexghiti@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=97681eca36=alexghiti@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793801270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=StALzT24QP0y2nM7ZiWwYHN9H78Ev4aIYAoLlcMqH34=;
	b=6HFxVmY9cbpJ3jLGxpVylh8d9PcSNy7a/DK8jkZAEaxQiCuLUaASB7z6//dhF9ez+zV1+y
	R7/Ic+M9m+t5cD2hdyfodTI99DRTqWKrux8jnr4fdx03/SdqlO9iUzlWKgmq2Ijm1rjlPR
	gyzX5byb1PvGmQXEFk523np9+UMTceI=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=fa7C4CtL;
	spf=pass (imf19.hostedemail.com: domain of "prvs=97681eca36=alexghiti@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=97681eca36=alexghiti@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1793801270;
	b=YrUTDK3LtHV/S/VV7000GT6P71v2sofsZ0LSVpZgtLUxdKjszr+XGfkK+L8EsfE9nsgpnN
	XLKJ+aGMUD1bZtJjHDBUWtPRblD6h+z4kjJR4hBHarHBlAhsHWBq1h1D1mv9/Jw8/DeOsV
	VTQpVi8wXN3GNGSkeT2aJb3bMCHWG7Y=
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6A4BcfXN2718041
	for <linux-mm@kvack.org>; Wed, 4 Nov 2026 06:07:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=StALzT24QP0y2nM7ZiWwYHN9H78Ev4aIYAoLl
	cMqH34=; b=fa7C4CtLjbcjLBaRp1kFwGlFvkm8a9/klCNF05YwslLz6lgMrtD+P
	UUAp2pu8dvgXJhZJJ8y/rMv3FaiuDmTARYEjR3SZUNagIut97wcOWgQHWP2wqkM5
	ch76lvB0QUHUhp7rr1axC6KC3AWiYTaHpYljLy4aGucqOP0wQJTAtUCLX1inzr1E
	6tfK5xAulkthrxOHEIsds9kRu1ND3yYwr6UFBn8cH6juEcO74BulCa3CGiGJtDl9
	BFv1HAi6roBfaGetmc1HapdoFI/0Ks+CxyociHXcMCRsWschcfNXFzk8scpr28Ko
	vXr5T8o0htuW4894q+QTG6ouYs72mkYPA==
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com [209.85.128.200])
	by m0001303.ppops.net (PPS) with ESMTPS id 4hqe4gsca5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 04 Nov 2026 06:07:48 -0800 (PST)
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-8b18c67095dso10661727b3.2
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 06:07:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793801268; cv=none;
        d=google.com; s=arc-20260327;
        b=eFyGPDyOWkrUp+XpUfS397OjYF1Ye4POvtr3p3rffT7uoXaCp85e/2+5bW+89QHkEt
         iC4LRuf3DiBRwELt9OIYmRJqcHTeUu/PP77MLstywTVkvXjr8gakTIh0hWHgqzjHl1nd
         DMJk0YsKK9/zFZImCCeqYO/UztYkNg9nEFtNRpqNISdw/ZCAFVmhWlFMc0U2XvA3hYmR
         ZucRya4zkm9Q1801xkd23TajX/W1/DS1eea7ehp3qNUVpYF/z+Yx+EMhHYgqnbzl64GQ
         V9IcpImOq4d+9DfvSqPUS4AjO35ZB6pOYCvMIYMQFoAqkWyXGGscwWxdh+YwVUoqPO8R
         U2/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=aZOMwSWiKC1/xAL/tFc2vX9N5EC5GmGBMCzQuc0a7ug=;
        fh=VUuGNIFJutTyRxPDTOTJsvn3X/DyuTyD4VSoMZaid+0=;
        b=IfPbBgsRslBAD0NNVRgQDZ9B4JksIRbRUA4vYsBdB43DuqN0zrZ+HVdp90ZNxlLIlv
         348EJO6j8FXD/Nktn9aK4PjcDDiJ6wx76hTPgOsm7enPi+6nYFj3MjVb4b0cNlusw5ua
         Z0ESc+DBCPeBqnfMA4qnnC3ZYodr9mtYiQXWXmfs4CTBCbaQ55uDV+BUZPM52f6BNkh4
         J2S4PEfrMVcL+W9dX0FzXpfH4vdiNYvapW/Xaip989gIy6guRRQoXpTEkyiEEqcjVrID
         2z5IrLUzdg3pLPgSgGKjLfmAvqRdqfJCvtX2T7pWk+c8zNX+tF8Vag3xDFliye0pAmrm
         9PQA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793801268; x=1794406068;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aZOMwSWiKC1/xAL/tFc2vX9N5EC5GmGBMCzQuc0a7ug=;
        b=wLLwJtPrx6haIiHENtCWI2j3EuFgFETdURw7y9D4zz2q4x32aJSCIKWwqz1/F88gNU
         nnLkOMAmSl4UK9LUL3AJWTzjEbyrEVgOgzu+GwQvLVajyBAD9THVhWYoRMk74mdtG4/N
         pjh+tuDPQAko549hmyE7N9uWF5j6KTlBbTxDDEO42t2R8gJWBejlVjjaJlH3cikW+kmC
         SuhtwrpdNtBKiFVR2Wt6a4k1Bw6+BC73x5gfrhMPgppKRje4BmfPrG5xjJWxG534DAfA
         XTOQ7iPCtv2zIicF2yLOLW6qv3WOwMEPli6H3+PNz+mp0E4Q5SIlKMaETWQzU9gSRk/X
         5Xeg==
X-Forwarded-Encrypted: i=1; AKwUvBxd1HouYD81N0bmz1Eid0s80V1Mgz+/sfbZeuorCJ9DYIu9dXXZQdaCPjmex+jXIaA4cKqM5HcRsw==@kvack.org
X-Gm-Message-State: APuU4Z9WXBmygWbA0FNC0A89ONahztmYWzRoOa3zjbs53KTYsFqfBMCa
	Cy66eUa+P4KfzMHHGdYzLJk9vmpRf5QaeDBwUiEXm+jIHJhmbvyspgiLbSV12hEf0qFjjExuQDp
	7MrE0KIO8nt1jt8A5Sm5xheADwQaQB8ihKM1XVXj1VCpPEbBH0XzZ+l+EpWcQKQl47J9oOhAx82
	sdLFZGDyOuKAdvc7Cby3rEu3M7Gw==
X-Gm-Gg: AYBFou0iDz5/115PXShM7nsLaktbu6SE5c6x62qmA4eNMC3wm4Zh1zcW0fbWrl2I2mt
	BOtxvE3zgeNTyxeAOgWHFiDHA/XrMVgXmZIyknuZ2UkWzWAcACPxFmSDNHaR2aFv+smGsU+zEvw
	1MCLijYY78FtmAsObFhn27vqQLWobY06sG9yIUWCHvnX2tDSd+E7NY1oE52MjSRtjdcAzR0mhm5
	ny0qM4TP5MIAWvGZA==
X-Received: by 2002:a05:690e:4885:20b0:677:d4b0:47fd with SMTP id 956f58d0204a3-67ba4fa153bmr8030547d50.23.1793801267637;
        Wed, 04 Nov 2026 06:07:47 -0800 (PST)
X-Received: by 2002:a05:690e:4885:20b0:677:d4b0:47fd with SMTP id
 956f58d0204a3-67ba4fa153bmr8030528d50.23.1793801267013; Wed, 04 Nov 2026
 06:07:47 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261022145615.2184343-1-alex@ghiti.fr> <CAMgjq7AB4wUzmugV3n4mhWcYqMKmhoZJCDV2uUagFjZXjUUi3A@mail.gmail.com>
 <CAEmasaXz2GGoy4dyhbo9Em95Cnz6QL3u2fcnAa2=8pJOOJyH8g@mail.gmail.com>
 <CAMgjq7BjOeboPMP64PfGDoY4yMGq0xR4E4Wa66U0+gsd2tnu+g@mail.gmail.com>
 <CAEmasaV0D3ezZyWf0k_84qXOa1c5KyUjvX9Jez+RXMDPM7FdBQ@mail.gmail.com> <CAMgjq7BFbXEKEt9faj_rg5AStfLkpJ0j57EQOOJ+L3-w2xRvtg@mail.gmail.com>
In-Reply-To: <CAMgjq7BFbXEKEt9faj_rg5AStfLkpJ0j57EQOOJ+L3-w2xRvtg@mail.gmail.com>
From: Alexandre Ghiti <alexghiti@meta.com>
Date: Wed, 4 Nov 2026 15:07:34 +0100
X-Gm-Features: AclHuK8gSTKeshg4sibYpQasLMc7p8QuNu_htLWW7wYC0Zzdzry0J3NTMCIAiEM
Message-ID: <CAEmasaVKxhV1-fsRLuPth2Bw7+x5Re8mTFwMrppAaFOxLNPNbQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/1] mm/swap: keep reclaim batches contiguous on swap
To: Kairui Song <ryncsn@gmail.com>
Cc: Nhat Pham <nphamcs@gmail.com>, Alexandre Ghiti <alex@ghiti.fr>,
        Andrew Morton <akpm@linux-foundation.org>,
        Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>,
        Kemeng Shi <shikemeng@huaweicloud.com>,
        Baoquan He <baoquan.he@linux.dev>,
        Youngjun Park <youngjun.park@lge.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
        Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
        Lorenzo Stoakes <ljs@kernel.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDA1NSBTYWx0ZWRfX6djYZvVmcsQN
 IXgt7Nra06Fmljxfzao2ogZzilkbmqqeqX82PRKPI70kGBb+thRGOgYTkpczFj0TEdDZGmS8CYx
 zaS4QJHNtqIg2crlFRXozlBJwdpq3QkMh+IZwcJs1C/RQ0x8BRGVFs72kXhcZIkFpLvJYsTEBoA
 SplsEnw6a+GDz7Y7I4OTbXA+zhBwWHCgSOJnAOOYda22UqltAdZe7BT0TV458rk4PadnN6sVh2P
 Ms2d7d4KAQTHjDPtBn3cG+etw3CPYIoQ6z/33SqNJK2y79kpgbgKhb0webDazoLewFOHHkOYxv+
 QV0XFsRWtasMWs6wxHIr3U+7tC4n80c4K28qCmTDMX+dnl/ZDSHtBPupNJjSw09b3bnBruRbQqB
 l+PWsFH1j/p0W41u1KEAVVnFNSVAN0oeaoLb3LCHETG8g9HXhBFBGExyIjrT203eRvPs6SmXood
 FqBjeJJQ/MeAHUCBrpg==
X-Authority-Analysis: v=2.4 cv=P/CvFSAu c=1 sm=1 tr=0 ts=6aeb3c34 cx=c_pps
 a=NMvoxGxYzVyQPkMeJjVPKg==:117 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=_78whYxrdx1mplLwxq1U:22
 a=pGLkceISAAAA:8 a=VabnemYjAAAA:8 a=ScCvlEzxO9iafL6ztjAA:9 a=QEXdDO2ut3YA:10
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-ORIG-GUID: vsRGYdbb7g1RO-cN0QF-lZwMuDKVAcAE
X-Proofpoint-GUID: vsRGYdbb7g1RO-cN0QF-lZwMuDKVAcAE
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDA1NSBTYWx0ZWRfX9rOXQzmu0Nfo
 /l/n46rN+7wiFmfICfw5L3gu/i7zXsvk37VJ2vVuV+NJHe4j/q65ykBaXP+/eBEYMXtkUVdVnaE
 UFDdaZBVajy2WFnQMov1ukDRe1GML0g=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_04,2026-11-03_04,2025-10-01_01
X-Stat-Signature: y7mr38fnqjt5qm68df6x1ji9zjjk4gpu
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 3AADE1A000B
X-HE-Tag: 1793801270-130694
X-HE-Meta: U2FsdGVkX18qtfXEagkYeuS2V/dQb1xxduMayMlIlw2m2nIFwq3LLi1DFQIGXGa3hOEE5dPWbI2OcHFMrth2eypxBuZkv2H9/LJtIJZZo65CHBOv+7fnc2c43TVN5WZKVaA1FHwTLPGmCDfa+rT05fQWwSgLwRtuR1tOp451xHH9n/Q905MFWu8+oVKg6gtnR2GH4jbE9p3G5CdXnxLeuBo+AGgrMCOfhw7PjA7Mk3TxDeONu96bjrtDysEm+PSRk8A+8gy1VKu4dlVpuj91GgPl2DTErrz2W+39sdS3wUMIiY8tQaoRLngSy+B1Sfev1T7KmBfnEhb7UZQ8HSh9ePS65kWWNWg6KFRDYrDboybkS9Fmat4ZSvFVBoGVxJQfZGZSp3ktB2LwT3Px7Nez2H5ZkJsN8V7Br1EaEu5MRaEFbeYR0U20ZRCeXDFZrvrBh3b6jWs0+TOCtFWbp5FyYFpqyYZdcmsE+prPj7fyoomgQK6SSa2VAei4jC/9EmiWE3QmCkdBGjaLx+SErBRHqeGmjPeISUp/IkpPjPQ1KFTa+eYOJFn7TU1ZcWWpsP6Drc/sV5JM/a3osbZvd7SIGcmQNI+nrxIIrdmPsw017KddJuxz7Bh7CoiYVmf1lGRS97597aYizoLpC1Fm64se4q3hfKReLsMhfrJ2HZzv6xO1kXE05/uwLMGgBOAdRwDpnpNYVdM+HmiGxvAfiCUfcNtRImktk+I6yguMkjyO9XAIPoqbyyxEewfiHs2ESnv3Xf2DEbwOHVU2Ok391s9OhWgDfx1Jn79OrZgQG9OEWxUEm4f49/vzwjDkxSgCtkjCXlftGg30phSiuw9YWyhUez9ZI8VwdmjwAsUeSQDF0fG65dldWlNp7d5xXPpUmYT/FQs/b7UFwt03qQuoYCHZ9A0+JsiPoGsz6SdJRR6xvkETTaD8saqKBFJUkPgxIBcw8ZOmPgRrm3BCD1XBHvH
 vvIgP9Nh
 Y+6gxThecWvV8k+dvXrEGHvLrYf2enKfJ9TzFO0kHqv14fROL+VLUVj42Y56ZcY6mDIoXNROEqBOiUSSN5jrbTHLw5o9Zk294kGOhZj4aG0wfU8njWGngGmpW2LsYIvQYEgLRzA8e1R2ZjajT7FQ3bYRnsuMAvNR0EllUpimcriis7wgghnwFTerxMo7ab2jqeLhB3I0yT012fsUagKMgRD8Cd/kIxemPs5GP+3jn/Heb/qDiZTu1KjgpHkAl5+P6J0cmTux6RCKO6pd0Q90zgecYiBkiUAlsK33ECvL2xFMM4+M4uFjAYw5b9yuUv9jaM5SwzgSl7Y80jmjLJCmWS01XoV8wFwJZjsBCEG2JMyiQYNaN55AG5+TxMpQLFE4ktXCWiJ7zzNEpkbfg00krT8+MuW7d8M/53stlfKyw8Dwh2IuMEXvki/8wZ/KlQy2JK9MoBe8LED5OOA3Co6Wo64BSH/PwFqW88AaWbPdTR1T55yw6aiHg/m3Ybphg6AQBTYl+MptX0ZBWtFTFlJbZZtFVJr4LgTVfioZOd7ff+8BhX2qW5ghPSHPYskwho3Qkf8TUFud6MNVdPImpDcWl1jZxfjY38zsDcf4tKyXG6/czxv8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 2, 2026 at 5:20=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrote:
>
> >
> On Mon, Nov 2, 2026 at 5:42=E2=80=AFPM Alexandre Ghiti <alexghiti@meta.co=
m> wrote:
> >
> > Hi Kairui,
> >
> > Back from holidays, sorry for the late answer.
>
> Hello, hope you had a great holiday :D
>
> > On Mon, Oct 26, 2026 at 2:38=E2=80=AFPM Kairui Song <ryncsn@gmail.com> =
wrote:
> > >
> > > >
> > > On Fri, Oct 23, 2026 at 12:17=E2=80=AFAM Alexandre Ghiti <alexghiti@m=
eta.com> wrote:
> > > >
> > > > Hi Kairui,
> > > >
> > > > On Thu, Oct 22, 2026 at 5:27=E2=80=AFPM Kairui Song <ryncsn@gmail.c=
om> wrote:
> > > > > Perhaps we should instead always scan the full clusters and revert
> > > > > that one commit? That commit was only following the idea of keepi=
ng
> > > > > the allocation more compacted for that series, it looked good at =
that
> > > > > time. Since fragmentation issues can be solved in other ways,
> > > > > contiguity seems to matter more for large physical swap devices.
> > > > >
> > > > Oh, okay. I thought reverting it wasn't an option given the good
> > > > numbers the patch provides.
> > >
> > > That patch is 1/3 of a series, that series yields really nice
> > > results, but that one patch plays only a small part in them. Or
> > > perhaps we can limit that to SYNC devices?
> >
> > I'm a bit scared it would not help zswap with writeback on, unless you
> > mean actual SWP_SYNCHRONOUS_IO devices?
>
> I mean maybe we can just scan nonfull first for SWP_SYNCHRONOUS_IO
> devices? These devices are less sensitive to discretely distributed
> I/O. For other devices we then prefer to keep the IO pattern
> continuous by using free clusters first.
>
> That may just fix the issue you are facing?
>
> Or maybe some threshold or quick scan in partial_free_cluster before
> putting the cluster back to nonfull.?

I can work on that as a follow up if you want, I'll take a look anyway.

Thanks again!

Alex

