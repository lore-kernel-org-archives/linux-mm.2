Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72979606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 16:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=Y6dNdwcl
Received: by kanga.kvack.org (Postfix)
	id 8F6486B098C; Thu, 22 Oct 2026 12:17:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CDD16B098E; Thu, 22 Oct 2026 12:17:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 796146B098F; Thu, 22 Oct 2026 12:17:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 538666B098C
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 12:17:32 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E2EF4160197
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 16:17:31 +0000 (UTC)
X-FDA: 85350767502.17.51181D6
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by imf21.hostedemail.com (Postfix) with ESMTP id 603BF1C000C
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 16:17:29 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=Y6dNdwcl;
	dmarc=pass (policy=reject) header.from=meta.com;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	spf=pass (imf21.hostedemail.com: domain of "prvs=87550bb734=alexghiti@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=87550bb734=alexghiti@meta.com"
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792685849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IyQXzg39zcGXVA48J3R7gRO6wWY/tJYex92UT40JM0E=;
	b=wMhgilKIWixp1Mq3Ck3ZaKG+Id+Fk9B2wtoyCLo8Hc7Em4KJ1SsaFVK37P3oXkZ+eEGrWX
	vxyE9lqdvyoXjZcugJqodXZrqo/CXyt04LJ4TzNsmHKD9r4q/n3iz6PSwnT+yz2olo1MT1
	5gbcAHsSDFHZfIUtsfc9F0StJ25WHTU=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=Y6dNdwcl;
	dmarc=pass (policy=reject) header.from=meta.com;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	spf=pass (imf21.hostedemail.com: domain of "prvs=87550bb734=alexghiti@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=87550bb734=alexghiti@meta.com"
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1792685849;
	b=Rm+GeXzIg9/k7z0bljD3Q1S0G5nJN1NODlT89F5oxRfIR4OSafi1Iy9XZ9PlcO71IPpeAT
	tj9OW59KMeUdpuiCBYnEbQ5+oc8wnqFtFMPvTIV9MtCLkhv6cnKWwu/+9ctajD+mz2IsHV
	JfNSZlF77PkQT02UodrKOp6FJKfJQok=
Received: from pps.filterd (m0528008.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69MEEBOK653129
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 09:17:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=IyQXzg39zcGXVA48J3R7gRO6wWY/tJYex92UT
	40JM0E=; b=Y6dNdwclyk0/i6LRnL1e+MW2cAlqUM2jSFU0ZaoR8zK1gTZopY1H9
	cpvA2PyeXNqMF9HZZEl9UXagnMwVCF4wFlhCfVUs2ex90MWoCFEDRlGcrWRVTDSG
	7OOkWVY2C16cGqsyCepZdHcx19AqpmFApUeLOlXb2gZdbSDgF947juJPbUK7V4C9
	MjjMkPhrXTUUZAQzKnNecwDvXXnhV/4Ep+alwhAtboi2uOXvkQJUyIwLDeEPyhlG
	dStF645OnxisrGfh2wRNwFZLGvw3xfXoI4vd5yi8fO8EuU4Jj/I+as9ZC8oSoBGs
	6zTNWAo3ACC2ppuNs9lY7nl+mEUTaNtFw==
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4hfjf6hhqn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 09:17:28 -0700 (PDT)
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c40bbd26f74so181388566b.0
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 09:17:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792685846; cv=none;
        d=google.com; s=arc-20260327;
        b=WqiHMshiJY+DLMIRtRQyeRhtH+EB5uY4EOpYqcfJFsGEMHir2jYjGHpV6+l2GbmAYn
         +Wdv+Zwoi6Fxe0DTr/2KVAxjdbuIVd8TqhsSmsliYOCjfahYoIMTwIMqCHdRG6UxLyCX
         xzNZhdphnxmGQ3py5ZmbL4tmBkvVMWB1HllaJG7VY/+pdHwM9FLpG17xgXlZB6fobOte
         HFJSKI5po4/3R3/ZcjZvhAFyTznvckITlE2q7nBTbSeGQDGSl0rkfMoKThzyt6Io1R23
         /0ZRtoZfNu35bOe50YwfrNtfHuPocBEdnD66Kec+7oAPiQ/V+CjPC2Gxk/AapWbBiT51
         bujQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=Cpb/0IA0On2NJNCBdcYW0RNbxOlGLfZgdxVpyVTyu0g=;
        fh=9fRTpSdgRe8aKfpmk9IWfmNeBdTtN9+jYGBfoHI113Q=;
        b=OngQ0aBMaOWvjS39oWMQVEC3CW0vYG/qJsT9vwIIN8WRH0JKSKhMj9+FreUmTvcwsQ
         1LVQFe846ujL1IOhUfcAgumY0O2Ik1a3/CplIAkVl3bj41C60VWCU7bYIJL1qheUvwik
         ZaVAoKrO5aaYoSurBCquu9RMcMe1OlT+9u/czFImUZcjVmG92QzvsLrsZ9E8Pjk4kU2X
         T/yc6EdpnybR/Gi0+xw8VQ84I/itBOqv/Kuk1uEayBkPcd8QCkBTA1BAbKQI4lu2OM2c
         sLZ7z+SSnyOswyN3DCpK9l7vii+Dks1GYMQMi5u6fqiE1pCWupeixym0cpwaQ1ZZX6Nz
         9lGA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792685846; x=1793290646;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Cpb/0IA0On2NJNCBdcYW0RNbxOlGLfZgdxVpyVTyu0g=;
        b=xNBhsuOQolLpMD6I0OrpK+QR2kjus3699Xo0hyr9lZP03q9Dn7AdBsw6P4v19cejMj
         Msty7lz4nqowhJ5ufVUivWg9AP2PYrlq7j+rvhWqidmnrC9Ux0IOLMzelU1xt26otTt4
         4jWp8jqqKLhbYdcIAZQGA0i44inOJK6vPk6ESk+7UXJjeaqGC3/egEt7SCmVNp0L3NXc
         IYA/bGYVPSK96BojgC8KQU/eLeFUyGI6Kn55VXBDjV9fAcIXfJxy9xlhwuBPTdxN66KS
         H68J7xdd0ESIhgoahLJ2t4L1bXJssAI+BJCWBbJaI6MtB62824KvqKWcqnpgVB3NAVl1
         6uWA==
X-Forwarded-Encrypted: i=1; AKwUvBxwIT3Grw3V4OX7hpdpBGkOjD5Wm3r3hiqN2jZpRuCQK3NvjHVNs51h0o5tOhgO3aMqEcjYBHXsaA==@kvack.org
X-Gm-Message-State: AFq9FYIK55Z4VoV4EIVtztdSckHCXfRfE2eANl0UhI5TQYceevpVuFP0
	VggSjA4vcAw3MhOQ8NzAfQ5heQJcg/jOq/FnqcWmzO14QreLuPuPtZekYrqa21raAejSVfz7n3g
	025svQmy6qFPBIIxvvkKrnWA4FLlUNLdfcGXq/fGYSbyCt7wSfDoEez64F/u6lCZmnNSFaoa7vF
	m+rLM5H9eJumf1R5VpYUOqwsZxjQ==
X-Gm-Gg: AYBFou1KBCiOVHft8gUH0/agBLCGHPb1ZCRWgfqUdaccScFKEXLiBoI9hBwsyJtYXcE
	3R2XF73pF+zWhy2Fsi6oseLfx9A1SUSqK9IWOQjDm8gP8BjWX9RzzRbNAjWX8dAh7un/iGaQ0bl
	bGSAlOW5ez37QG1MEuC545Y0926QEY6rKrwbBt29TUjFJc+tDZTYdsPnh0TADhnqb8TLGbGTXtz
	uHGD5vyRPHSeTiiEA==
X-Received: by 2002:a05:6402:1f82:b0:6b2:e2:d965 with SMTP id 4fb4d7f45d1cf-6b408edb704mr5472628a12.32.1792685844936;
        Thu, 22 Oct 2026 09:17:24 -0700 (PDT)
X-Received: by 2002:a05:6402:1f82:b0:6b2:e2:d965 with SMTP id
 4fb4d7f45d1cf-6b408edb704mr5472605a12.32.1792685844476; Thu, 22 Oct 2026
 09:17:24 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261022145615.2184343-1-alex@ghiti.fr> <CAMgjq7AB4wUzmugV3n4mhWcYqMKmhoZJCDV2uUagFjZXjUUi3A@mail.gmail.com>
In-Reply-To: <CAMgjq7AB4wUzmugV3n4mhWcYqMKmhoZJCDV2uUagFjZXjUUi3A@mail.gmail.com>
From: Alexandre Ghiti <alexghiti@meta.com>
Date: Thu, 22 Oct 2026 18:17:12 +0200
X-Gm-Features: AclHuK9GI5erCWePRdYkEH9p2977EyYs_eI8jHBxOgH2AAL38mp76QLee7bxFts
Message-ID: <CAEmasaXz2GGoy4dyhbo9Em95Cnz6QL3u2fcnAa2=8pJOOJyH8g@mail.gmail.com>
Subject: Re: [RFC PATCH 0/1] mm/swap: keep reclaim batches contiguous on swap
To: Kairui Song <ryncsn@gmail.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Andrew Morton <akpm@linux-foundation.org>,
        Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
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
X-Proofpoint-GUID: 8t76Zcr59ajkB8wHTB5yIkEwqsT3hQcq
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIyMDA2NCBTYWx0ZWRfX4MJz3aARB6bI
 F51NROvpw8WOj+55w62nPXDse26PG8tnIj66mxrazDhkAFDFunnA0MrAGMBoYhAGMpc7hdX56G9
 VKvq0T5XROXzxaQU0D9PIpwegPalT60=
X-Proofpoint-ORIG-GUID: 8t76Zcr59ajkB8wHTB5yIkEwqsT3hQcq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIyMDA2NCBTYWx0ZWRfX4aIk8knDUm0w
 gCNeicBQkYsR/Cw3wguliXngm8lvUkrdvv3s0jRvmCS8kuJz+/cjUcCS8Y0VinHLUu3x0Cmve3v
 IhhTDMIz12crJclHOpRPVu7gwUWOrBH7yOMP1SAg/hKiTpGKzNEuk3tzyCLbdMeSk+ReeUVY84f
 tPHhFV17nXWI34y1/DruPoPCeihMSmQpb3KpTYWmdQ1bl7212WG+b1D0zzxBVwmQ+lXxJ9hl/HH
 0MLg/SzPbQf7rC8jVDaSXanIT1Ac7e7ORvq0QIVxQ/LCTgCBNUN/NV2gzRWaN9OnIyDlJbS8sYY
 3j3OBFX3Aljb2pDSKbJHLnbM6REEdFghrj7p05GbATBDABBEV7ybQRLrAQs3uRi149k1pRbSR+b
 RYGevSquR8BLsOTO8QCXwEWu/hu89T3YJNnzrHBZXvWRxBHxrejVmChdWoXk0QZ7QqVmJKOiPil
 xA6lVJfO9u3r4RBAoUA==
X-Authority-Analysis: v=2.4 cv=HOVWhYtv c=1 sm=1 tr=0 ts=6ada3718 cx=c_pps
 a=edIAN7ErZTGbxav20d8A7Q==:117 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=_1IyUuN4QrATX339ibzo:22
 a=pGLkceISAAAA:8 a=AosG1spRg9nRUDFPKwwA:9 a=QEXdDO2ut3YA:10
 a=nIuFr-8touD1a-RngYHT:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-22_05,2026-10-21_02,2025-10-01_01
X-Rspamd-Queue-Id: 603BF1C000C
X-Rspam-User: 
X-Stat-Signature: ajs1u8bj5cu3cd6z95kfqtnxfbpnem1f
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792685849-259566
X-HE-Meta: U2FsdGVkX18LtZyKUjWeyzVhBNt+HFgLm1sFUwj03H8ixHOHDR8W8WcS0vkBJPdCf8yqMU4wsrr1vDbPpOIf9lEU4vboyhPkP4nXkzafhHGNlCczURDaWuw18qeboDktVbg409pyFumOzmQCWLwHpwXoyKTB2A+E78ptP4cyAJljN2x0G9EXokDNZgorW91EFhNYLpPslcGxV7jsK7n5f17vaR2WbDDUlVLxeUZ7bJT8Fl4FKjQf0mrfcF7+tRxypRnmHiZnANGAR0itel/OSBxPRdQ5WowdkV7R/8vYH45Tt9RBDav/Vx072s4dSmxp/1TFcRppLP69vmrb9lgWsyAFVzjLB4Q1IARGPa3WTGXs9gOX05xN1t9W06dpoTQvrDK6Lv8wHw44KX/6YFS2kUOew+zuN73BQdj9nqZt9oH/Vx8HLuTgYYFrSEC6mVG5B9wom7aZBcCR2vvJAJO6Fat+uuWjQDgdZWIU3AKar1Yx8Y39Y9oQ8gI4fSv+gJKQOsnBjcdPOArDwmyxrl5tWtLz4Mbnfyc5ebxlBcOWY7ApnwBmdnJN+Ftl3sfEN7F4bKCq1pmp8kP3BWmtmHLSGLfIdIPvaeTJXZcfqd44VihaJsQrJ3vflB9Rx06josfFUpuF064/qikYGP2ScVIH8rb4r/0pNKQq/CRV+QsqngrrW3o1XWQbX8RuwgW9/OHL0vaBa0bd87cHT+Q4cJF8D7axx2tWAP2rSMA+p8RscaT/5Q6jaKccjdhFsBE0NUPaVbjXk48pIG06U8EAJI/yXP5KTcL1iC2U2aPgvv/UwsNlF9ZpxLSl/jvtZjvj8Dm/ZifMLY9pIHUUqwf8UHP8zFl/hOBwHlIMcU6oUwtqbnbRFNhLQSpaKEhLUxlODRU3P/ElM1X9B95sRwbigpVwhWh5i5i1xTl7mHlD5pW+xT+I8CWE99iPZ3GRMEu5G70gbFy4UbKl9N0GTHVkFef
 TVDwenc5
 R6V83qvswf0PhzRpcxvMlaqWIw/A/UsI2qFOFfRudpXetQu/r32khBvYFUMRrPSOlriPnS6ZWBVwEX4G6z2PBSLKF9E+6JaaMlTOvXBr5TFDWU7KNJgQiInxgjLDTcVlpniXzErYZVyWvggC7YrC96zVOTfiSsM9bxtOcuzCcMboNhAHCDg/tN4e0/EhlxmMVvSefrRjQm9G64iMZGbwYjquOjA26FY9eKH7lf+qTwyKjE03YAlPV0tks+NoaULH3O7vt1u8ZtDsOJynYFH9okJDW4pRz+BF6lzRugTrr86cdwt8YN6Rjex2xFDy9ypvVYwpFI6V3S9DnphfURMk/keFf4d6qur+V3J8uhjZFIAiqCt6boFbuOCt0KgUFpoT8P/+J3JRcr2OAtOPY3O3zGtBSR1RNc/d3/9jtbeiZIco2cdsVaAS03jeABpcVaof171Rqup8b8/zvPRbYX1SjNGGEj1K3+EFACatakKntMUHHH/aFDlSvzyJMJBm8N2feDdD+e5IYzjUItHNSfkFD2LjElK88O+WpURD3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Kairui,

On Thu, Oct 22, 2026 at 5:27=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> >
> On Thu, Oct 22, 2026 at 11:00=E2=80=AFPM Alexandre Ghiti <alex@ghiti.fr> =
wrote:
> >
> > 7.3 regressed swap I/O: for the same swap volume, a workload that
> > rewrites swapped out memory sends many more requests to the device.
> > mysql/sysbench in a 256M memcg swapping to an NVMe partition, 7.3
> > compared to the previous version:
> >
> >   device read requests per transaction        +59%
> >   device write requests per transaction       +27%
> >   throughput, iocost off                      no change
> >   throughput, iocost on                       -19%
> >
> > Two commits interact:
> >
> > - Commit 9a42aed48421 ("mm, swap: prefer nonfull over free clusters"),
> >   in 6.18, makes order-0 allocations fill nonfull clusters before
> >   taking a free one.
> >
> > - Commit 3cedb745d354 ("mm: clarify the folio_free_swap() for
> >   do_swap_page()"), in 7.3, frees the swap slot on an exclusive write
> >   fault. 7.0 to 7.2 kept the slot, but only as a side effect of commit
> >   4b34f1d82c65 ("mm, swap: free the swap cache after folio is
> >   mapped").
> >
> > The freed slots leave holes in full clusters, which then go back on
> > the nonfull list. Reclaim allocates slots one folio at a time and
> > merges the writes afterwards, so a batch of LRU-adjacent folios gets
> > scattered over those holes and is written with many small requests.
> > Readahead later finds those pages scattered as well, and needs more
> > read requests to bring them back.
> >
> > I tried three fixes, which perform similarly:
> >
> > A. Revert 3cedb745d354. This keeps the slot on write fault, but undoes
> >    the intent of that commit and keeps swap space pinned under dirty
> >    pages.
> >
> > B. Below 50% swap usage, make order-0 allocations take a free cluster
> >    before a nonfull one. This is what the allocator already does, at
> >    any usage, on swap devices with discard enabled (swapon
> >    --discard=3Dpages). It is about five lines, but the threshold is
> >    arbitrary, it stops working as swap fills up, and it applies to
> >    every order-0 allocation, using up the free clusters that
> >    nonfull-first keeps for mTHP.
>
> Hi Alexandre,
>
> That's a interesting problem. I think the real problem is with commit
> 9a42aed48421 ("mm, swap: prefer nonfull over free clusters"), right?
>
> It's more like a balance between fragmentation and contiguity of small
> order allocation issue.
>
> Perhaps we should instead always scan the full clusters and revert
> that one commit? That commit was only following the idea of keeping
> the allocation more compacted for that series, it looked good at that
> time. Since fragmentation issues can be solved in other ways,
> contiguity seems to matter more for large physical swap devices.
>

Oh, okay. I thought reverting it wasn't an option given the good
numbers the patch provides.

What are the other fragmentation solutions you are referring to?

Thanks,

Alex

