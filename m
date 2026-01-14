Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BBDDD29FF7
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 12:22:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 893F56B00AF; Wed, 14 Jan 2026 07:22:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8175D6B00B0; Wed, 14 Jan 2026 07:22:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F8A16B00B4; Wed, 14 Jan 2026 07:22:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5A94E6B00AF
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:22:32 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 317B7160494
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:22:32 +0000 (UTC)
X-FDA: 84330482544.10.A2BF236
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by imf20.hostedemail.com (Postfix) with ESMTP id 09A161C0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:22:29 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=MLrMZEyN;
	spf=pass (imf20.hostedemail.com: domain of "prvs=94744532ae=clm@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=94744532ae=clm@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768393350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cdnDOBIi9MmsNfktRk6AkexRuBKfttaLQPTXyR4ZCo0=;
	b=j7drXaYF5wE3hIcO7XKzPuw1gNAdk+zwa/8E9OlqeN/BLvvY9bI11OlnCpu2AetwFsm54X
	8S4E+eZRGg3oZ+LEU7DfpBmrhdWpus5JTzkiy11uIUlpuKMx5gT/yhidca7sVsrc4eLaUx
	K00dkZV3MVJE/Tg2a1wdsc+1P52oc1g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768393350; a=rsa-sha256;
	cv=none;
	b=mS8/0ZvZcOI/GnmH8QprmzVi1Qunmx32cpc6k3qHcBbMdVieGrrK71dXbrTu4BVKj6hvvB
	VGIS/7dWot2ayrFPAAqkcNibkXX3kt8e1sERKZWMDvEb6XLteclc3bsO8ieSn3+UKY2dES
	2dfTC+xZcc93F6VVZ0vzHLMiQ4Jy1/8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=MLrMZEyN;
	spf=pass (imf20.hostedemail.com: domain of "prvs=94744532ae=clm@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=94744532ae=clm@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60EBY4G81562086;
	Wed, 14 Jan 2026 04:22:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=cdnDOBIi9MmsNfktRk6AkexRuBKfttaLQPTXyR4ZCo0=; b=MLrMZEyNSrrG
	vKhqf4wEdV1b2N4JYt0OOETldkgRoXR/CpmGJHsUwZ3Nh66dFTZ0yUXi7cA8xO4Q
	yew+ui7BDLtoZ3CRtk+eZ41DLeNmagGlmkpLGQmAB7aFXNL4ml9EvCiX3/davalB
	LOKyZN1TQ9bz8PUgo4CF7o2bakHyw8ID5ErFjukOsD8fuVJUcV/wcIdh5U6Dzv9m
	hWNZoaXWCeg0XDreW3LqBlpdsgzGuji8q5mHTCMI/8rjzb/+fTFOB/9luQaQVaXE
	jln071en/icuJDtzsR22x8Oj58O7yMsJwYoMQ5VliaD3SwBWeRveb7OMsnp/dpjf
	nck5v3q6VA==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4bpact8a7h-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 14 Jan 2026 04:22:27 -0800 (PST)
Received: from devbig003.atn7.facebook.com (2620:10d:c085:208::7cb7) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.29; Wed, 14 Jan 2026 12:22:22 +0000
From: Chris Mason <clm@meta.com>
To: Dennis Zhou <dennis@kernel.org>
CC: Chris Mason <clm@meta.com>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter
	<cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>,
        "Sebastian Andrzej
 Siewior" <bigeasy@linutronix.de>
Subject: Re: [PATCH] percpu: add basic double free check
Date: Wed, 14 Jan 2026 04:22:00 -0800
Message-ID: <20260114122209.1075584-1-clm@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251220002737.84100-1-dennis@kernel.org>
References:
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2620:10d:c085:208::7cb7]
X-Proofpoint-ORIG-GUID: RmaQIs9xHiqsEAtyGwuoKECAJf0_iZ4S
X-Authority-Analysis: v=2.4 cv=d5f4CBjE c=1 sm=1 tr=0 ts=69678a83 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8
 a=E1IHwRy6t-lTkHfHgIAA:9
X-Proofpoint-GUID: RmaQIs9xHiqsEAtyGwuoKECAJf0_iZ4S
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE0MDEwMSBTYWx0ZWRfX3ipYuxGDsbdy
 SEaa3IItAgOlCcmrVSe7+hIQ/EstsHjW6Hu4nc6U7NOv7/NgLdZ64vEPQ/JVroGmdFoqLlSSV2Y
 LC0FQp4JVo7fKhBe01rzMemvm41iRmFrgN6X0/GnpXeXpa/qeTEk/+XRVP0dCm8//eUZdRJO32Z
 fWGX5w1jlLC0o5x6qfBOtaF6p/VMC0LvGoDq170ef4RsUxRwldE4Gst8+sxtp5SDdUAPEyXHE2b
 YgK8cSP2a3NHOnI4kXZDNjzri71A5fL9qtTuy1qCdCJYrMxHoaDEbTGRo95VhqrrSdNvpT4cn6r
 Bf10TYAXq7tCLBqY+Uh7tQYdUbUH/iLIUf18mEeYW4eE/Gd5Etj7Jp4NB5hll7CdQBDQo+latlg
 c/ZvETPlLWuHliSu/YwRUTHwcaxPL+0BnAW9C3+szD1jqzYjzbxe54wNmVa1+iuEGUeRiy9STo6
 JP6MGdqa1y0//FdP5Wg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-14_03,2026-01-09_02,2025-10-01_01
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 09A161C0005
X-Rspam-User: 
X-Stat-Signature: 8xihp86kxkksfwwqdcrshf4e65eu98xy
X-HE-Tag: 1768393349-248587
X-HE-Meta: U2FsdGVkX191mt7Sr/FyDsuQ3hIGaImzId8zqIMTTW73mzIUSnsQGzxGth7mETnu1nP1rxNkT+N0Ig0wqfiplc+hLwsOSmiFk8+SwGNc2e1/ghJvs4LZTDLPkNzo1bz79a/3F22B4u7SJeRqPwmsglNDd61b8zDNVqC1gC5l0mSQcV3pkS/yXVuMC/ACRX2guqPite0VNYVwwGK+azQtkmTfsp+sAMwP9aOnMPjUr79bQxZXCqGNqGY6bropnzAESQUeNmcdgcTU8FGBMDhZItTlKB7fibK6ty91+4sc7KCjqUJSm4Y9YQONlTFGq+4qRmiAy4DMFIoShfdPdx5ZWAK+eaAeZg5dwAjcj/4sE8GcipgpySflxY2u/91DHtHLH/1Y83PwCcS1qz6q6lhb7I9aeIpAzbyjkLlpZQjex081k14A1ds8kXPl/MPfL0JwLq3F3rN8e1l+03Xq7cVtVz+RyopBSySEKUJi+DtYnaXp9CtOCtyLP+7Z15vsUv93Q6WI91bTL27YbNmuAOe7MNyz/LDoN/1LA21FiGDQq/MyUMFFmULa50qc+W2PeNodiRplW4WzNgl4tjTbvgGfU9sNIeyQj1VhBQaKGrUCClc12JesqTlec61KQM+evbyBy79EVwKFuzK24w3UcULBjKel8GXiqAY38DgO8xk20QQ9dk8OgCZkvq/3YJs6ksInpNXb/KbY8d6zzjS6osRtkEItd+M7NKOTKUKsplCVykl23jjYxs495czN9/CdnhyrwiWyukZUPxIY68xUijaNIFAalaJrii79b55L2mgk9tR7BXi4A+Cu8EUaBG7rmGYzdFNe4ONf97QwUMezzL+VNWWS5euk49EtAhpYwJKpWrucDhb7vMero7eE2xHdIJoXbkmOOSIj9FtjYiGtc1r0Qdt8Z192HMY9bTTmkGqPbR2Nsa68xV+FjHHJxyx1quwpguaBTbg3iJKyNkCzoUw
 6j2l/qAW
 E4OSQqwPAKEr0EdIhytkH5mvLw/8bykodT17AZB/24+KbJWWsgmVoLmGzXxcAK0ONaKEa7/J3OPWZ4oAOpUnwunMDmujq4qBGTf0w0y4AudJ7oGXdxezWt0wPQqNmuvHMxImDfCZRz5uwY9VDGZPx5kwTtrKHEMrWyGmE6t0/vqpR5kHudBkDqvTBrXF9O4mzYd7qLcS/Ky4pt+/KU6Rw3c1LM5zHkYIsSp7eFZEF2HXJ9iuooCgQ69uEoervCeQqN0+T0zy7eegSZa+LUSOatPl5jd05wSLsqN5rnRDXfiWHFUmy+jLFac1hNnHO6hnedF6Xueh3vNMP+OHaZ6BN4M5X58MRYB2SsWvrVAEkHyO8llSZq0XZbrt7hBize69JkZnH4zA6+wZk0Jw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 19 Dec 2025 16:27:37 -0800 Dennis Zhou <dennis@kernel.org> wrote:

> This adds a basic double free check by validating the first bit of the
> allocation in alloc_map and bound_map are set. If the alloc_map bit is
> not set, then this means the area is currently unallocated. If the
> bound_map bit is not set, then we are not freeing from the beginning of
> the allocation.

Hi Dennis,

I ran mm-new through the AI review prompts, and this one was flagged:

> diff --git a/mm/percpu.c b/mm/percpu.c
> --- a/mm/percpu.c
> +++ b/mm/percpu.c

[ ... ]

> @@ -1285,6 +1286,11 @@ static int pcpu_free_area(struct pcpu_chunk *chunk, int off)
>
> 	bit_off = off / PCPU_MIN_ALLOC_SIZE;
>
> +	/* check double free */
> +	if (!test_bit(bit_off, chunk->alloc_map) ||
> +	    !test_bit(bit_off, chunk->bound_map))
> +		return 0;

Does this early return corrupt pcpu_stats.nr_cur_alloc and
chunk->nr_alloc?

Looking at pcpu_free_area(), earlier in the function (before this new
check) there is a call to pcpu_stats_area_dealloc(chunk) which decrements
these counters:

    static int pcpu_free_area(struct pcpu_chunk *chunk, int off)
    {
        ...
        lockdep_assert_held(&pcpu_lock);
        pcpu_stats_area_dealloc(chunk);   <-- decrements counters here
        ...
        bit_off = off / PCPU_MIN_ALLOC_SIZE;

        /* check double free */
        if (!test_bit(bit_off, chunk->alloc_map) ||
            !test_bit(bit_off, chunk->bound_map))
            return 0;                     <-- returns without actual free
        ...
    }

When a double-free is detected:

  1. pcpu_stats_area_dealloc() runs, decrementing pcpu_stats.nr_cur_alloc
     and chunk->nr_alloc
  2. The check detects the double-free and returns 0
  3. No actual memory is freed, but the counters are now wrong

Should pcpu_stats_area_dealloc() be moved after the double-free check,
or should there be a compensating increment on the early return path?

This could also affect percpu_stats_show() in mm/percpu-stats.c, which
uses chunk->nr_alloc via find_max_nr_alloc() to size a buffer:

    buffer = vmalloc_array(2 * max_nr_alloc + 1, sizeof(int));

If nr_alloc is underreported due to this bug, the buffer may be undersized
for the actual number of allocations tracked in alloc_map, which
chunk_map_stats() iterates based on the actual bitmap contents.


