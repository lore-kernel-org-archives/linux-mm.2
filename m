Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB6EEC624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 21:35:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B31826B0088; Fri,  4 Sep 2026 17:35:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE13B6B008A; Fri,  4 Sep 2026 17:35:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9ABF26B008C; Fri,  4 Sep 2026 17:35:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 652DE6B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 17:35:45 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CEC04140213
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 21:35:44 +0000 (UTC)
X-FDA: 85177387008.04.3C8B877
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9F58CA0007
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 21:35:41 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=h36vtbVJ;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=d9yAzAIZ;
	spf=pass (imf25.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788557742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L/aPYyT1Jy/RmfEhEFasDwbK2r6Vj3z/rQBklaXlzNI=;
	b=rh4Mg75MdAyq9vhfZuPd15xZsikEMMPZUv4gXbB3eq6PwqD3hGQdKCzr+372gDomt2E+Bt
	TDzS2+Vbja5EzW/kvrNTzkYGLvBRkjGTGyqFLBoEYaSUOC7JwH0/FtX/fTYUnxz9B9p/3Y
	hgm9qK68H+WI/XVbWmlgfAob77EpBuM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788557742;
	b=us3MQQZWMW72/QO1UglTm/myeY8Eo1O+ApSHv9MVVnKjB5xde3tZvpPCj6lpyGTpjamFRB
	gGKNuvgE0s/NQZVVG54vVj0mTD6c5ivit94d9V+TPrEL64p54w1YLcFmPOG8Cf9djlA8lX
	r5IH3AkkfEbAd73pVPE+zpB3ZZjCx7U=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=h36vtbVJ;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=d9yAzAIZ;
	spf=pass (imf25.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167068.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 684KZ0i33346412
	for <linux-mm@kvack.org>; Fri, 4 Sep 2026 17:35:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=L/aP
	YyT1Jy/RmfEhEFasDwbK2r6Vj3z/rQBklaXlzNI=; b=h36vtbVJnPBr/57FHUct
	EG1vzQhWbPpsp50Ww0DPKKHUacejmfX4tEXDe9AHJaRXF1UWzQa6CMYBXiIAHgG8
	aMUQTSUTg9jbDTdZVJzcdg+s2p6vfajitccHwSiIa9PmEq6WrpJNAae3d9IhAL/x
	8/KHRVFMEokYsmCh3QcB9/0BYko51C/snMoPCyxaKS4q+5V6a+YX4YBdiPNThh/y
	FCZeFTmEUXFM/5/t9qqpVsS7iouwFlpSXXnbmtGcq//5sh45WZuUCs+YvJ8UIswG
	xf+ZwoXDkRxAlxgKrrgdHlcQkpAg5bEKOvMr++z4CsB1xHSSPilo/EaA0ahkxiKU
	GQ==
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gg0a838wc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 04 Sep 2026 17:35:39 -0400 (EDT)
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-90e7de22fddso30665016d6.3
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 14:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788557738; x=1789162538; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=L/aPYyT1Jy/RmfEhEFasDwbK2r6Vj3z/rQBklaXlzNI=;
        b=d9yAzAIZG8TfQJ6Yw5r1o0xMwQmVtCWAi0MN4lZOc1zEgiyt0naB7QPgjcJ0zwErvQ
         PAM/UhN2U+ss36ymJ4QWaKWaw25/wK5pJLDJSopXtALDku5OF+75GXXP7nJOkCyLjcmQ
         HkHFlaQArVGFmH4KNFNqiJVpdrW3l+obI2ipEeRxAXk8XdQDdJ99tE5cfZtnm1cye/Sc
         nd7UG7KLUAIUFSeaIWnnDbc3qw0kX2V+7WAwBo/lOT7hhLbsKFy4PqWZbGM7AiItUNkR
         8Q94v9i0lVw4Ul1RZBDOojeY7NXbKezhidfUcgp8ahOnqUOzjWCOo/lDK8cul3R9VKQQ
         zAYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788557738; x=1789162538;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=L/aPYyT1Jy/RmfEhEFasDwbK2r6Vj3z/rQBklaXlzNI=;
        b=sDwtDR5lXRIONgV1WmzZwuMUjIgjuRBmQYCb7uxVwxeBvbMdj/VtKmHU9qgv5PkStx
         zz8efUWA6vlUn/3M48mhZvHUzINsoVJugi9FympdONvBGtKURzSGVaVrZil1zwS6uvo1
         UViXoeX04pTM8ai742HMZw0Pv+krveS71ftrQA34mvqbK56EIXnCVzKytSG0AV74czCn
         iraBHx94aMbdGdpBVnStYaAo2R2x9Q5tnAYHnHHVWO32Asg4LU6XgAHgtvk4x6gZ342V
         HNNBCHCvEIh9zH4AEbXSJJ7RwNr0FdRQeOLrQHbvcL6SpMbuy2S5qTaRfd7OBWRA69rV
         WL4w==
X-Forwarded-Encrypted: i=1; AKwUvBw3mVa2J9RB6+gjsuveTb/ICJGEnAYjQi0V3FhTLOJVqRby5yXViUagBTrc2HcwO8wae1INhWIvpA==@kvack.org
X-Gm-Message-State: AFuF++kdebJ7pF0ceQJb1cizQ6NHEmZwsfxDaNiV83JqrEbUzqu5wCZV
	3gUsS4r0n2wfq5IjHBQ+9OUltelxhkg5dJn/cHEh+YjGb5qPQyorezvaLIA9Lm7W6yJGNWzdW3b
	kh64j/o2YjPMqFIDZRief/S0faSIw78NlmIdkMYsW66r6w+HD
X-Gm-Gg: AYBFou1Fhuo8+vWCyehxZbD2WL4faQzyj+vJ4xSccV52jnmZcxeVsjjnbrPG9MKVoM6
	xnPQUk7nJ3leSVgMW5bcJ7G+zkPzoMOy3e9n3q6iVMqi5Aa/fo+TtHNXKr2IGXjYaVdHgv4lEZQ
	2ioERqNfya9Bj9YXELXl03AK8vRh9gTnKAYHztYZHoFCB2KdKhB/rH+W03KJs4//q0++sCdI5+3
	SWRnXoGRYLeN5sIAQUFoE0CWbCtNvmg+CkxRYBlWkKctdcf/cDdwbbmfpU0mfAkojh3OdGvnrys
	rwQQMvGxgHObtkz38f0p70zWNcIers+wrEHri+ZH4d8GbX/2TgEAxCRuDxz9hAzvxZkuQHl+Qnk
	AXQVdTWI3kXJIspKLMDepHB7/Ji4uRD83WA3yR3h6Ak1BmzvO9Tf8
X-Received: by 2002:a05:622a:130c:b0:52f:e60e:70c3 with SMTP id d75a77b69052e-53054961fddmr94381221cf.24.1788557738250;
        Fri, 04 Sep 2026 14:35:38 -0700 (PDT)
X-Received: by 2002:a05:622a:130c:b0:52f:e60e:70c3 with SMTP id d75a77b69052e-53054961fddmr94378971cf.24.1788557736018;
        Fri, 04 Sep 2026 14:35:36 -0700 (PDT)
Received: from [10.207.49.22] (nat-128-59-177-158.net.columbia.edu. [128.59.177.158])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5305418950fsm29599931cf.20.2026.09.04.14.35.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Sep 2026 14:35:35 -0700 (PDT)
Message-ID: <5ac3eb40-2c40-45cf-a5ce-d7dc3a10c491@columbia.edu>
Date: Fri, 4 Sep 2026 17:35:34 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/11] mm: memcontrol: constify the lruvec helpers
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Muchun Song <muchun.song@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260902-folio_memcg-const-v1-0-e2c1da22246d@columbia.edu>
 <20260902-folio_memcg-const-v1-3-e2c1da22246d@columbia.edu>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <20260902-folio_memcg-const-v1-3-e2c1da22246d@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA0MDIwMCBTYWx0ZWRfX/asKYMI1WIKJ
 d78AfZa4B7v7BQP90jkLXJvZchHwXB4pdn/gta71cPyiegZMrJNFAxScjb6U4RftwekDkuFvb6H
 1oY5sT8F2fF20Lk+AlgSEqR09QZ/aUbmR41gAcBWuKR7FNeImukd
X-Proofpoint-GUID: OnhSZ-StKmj94lbH-zkcOl7YYMxmXRVE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA0MDIwMCBTYWx0ZWRfX5J6+BjsT733G
 n0Ifp/SPCcHMrVTjZeslL6lkyrW7gSfHPEnu+Xx8v34H04eb9dHhMT27oz91YL9lbZFTn2IXuNS
 cDeegSBU7801kL+X7Qgo8nk9kW+F1SVuAyKWb4Akog2BH9P9b8GDORgC2fF1tT1sPTz1IB8fdyi
 Qa7Zyfm0Vko/o5VfhO3kJwod/3Ddu+yV0kbb27zCt+UB/T4D+KgDIUYcpy5u35/xGjixvLtB6K3
 QMK0QfXmpJNBh2uDhWSD5MRFqyPxxr5UR5eOxTPXVZLSjGt9tNa0gpXYWBci7kpP++OglzAfH/C
 Onep9IpZdyV8ivR+8cGP18wcL714/79U7xrAKMlX/mMkzcywRDKUz9VXjpRIEvE/BR8yj4VVEKx
 KgTUQDdARw0+Z20EDH77Hm2vQU39o1YORxca4NDUAAsvy1+IKyCpJRkz8IWTMAeZjVnZlONROF7
 fvz2Z2uSw7Dal10qoCA==
X-Proofpoint-ORIG-GUID: OnhSZ-StKmj94lbH-zkcOl7YYMxmXRVE
X-Authority-Analysis: v=2.4 cv=MZpcfZ/f c=1 sm=1 tr=0 ts=6a9b39ab cx=c_pps
 a=oc9J++0uMp73DTRD5QyR2A==:117 a=tLges04aSNaZGVAfhBIy2A==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=usPcmh10W0ubT8QP8_c3:22
 a=chcUDXjQMmrNteCdNfIA:9 a=QEXdDO2ut3YA:10 a=iYH6xdkBrDN1Jqds4HTS:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11896
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=10 spamscore=0 malwarescore=0 phishscore=0 impostorscore=10
 clxscore=1015 suspectscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609040200
X-Stat-Signature: w3wnzaku431ajqgc3aiuzzppntb8bm36
X-Rspamd-Queue-Id: 9F58CA0007
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788557741-195842
X-HE-Meta: U2FsdGVkX18ciHr6z0VItLSl2zSnrbAmmh6VU1upTyWJJEkMRko/R17HivSTJnYwQUWi7sAsjfw4SQx9luHqtaJfBjPE0vcZ/t2y7qsvmS+nmA1xoNfUfCsfDj9MciiXA8DTsVeMhcsbeJ0zfmB55HjNsUtNtdWS220iFtNcjRGZAgmJCvSjbGWt/OGB7nxD7NXXmrPFxOYVamxUAog8SznS3TBIlSStAiQuW2BSs8tSgn3zVj3pYDP1TIFN/NAiRPwyeaHNxhrwY1wSsDC4j/xMKM48eeQ7TW1d5f4N1rMVhHskJqZUU98fnc/y/NFMIWHEQ2m0Ez5wHHbiytgDewtkk7sn+P3chBT0cA65h7PWauKBC4WKnd+HJEQaHYwNyW0NECTtSH72daELnnNb65fNbQPzVURzC6O8+GAshWiPNux/WmQg0VPdEPkuJAn+G+2zBP/meYROWg372cYAa1DpCe4QpvMUwZAiYyg/gTBRgbjKgiUnyDieDx8Zrmu49xEGtUTTeJz1mfVwF4XwroQtDeaqU7riz9vzZhWgPPUAGziemrSCk9hpPJyw905XbVfuETV3bO9GPfP+WfGDc8tA9pNMU2WPH97//TnqqhalRakKbg7yp3T1OB6TXatwrSUsMJOojx/GD7eZcr0yktbMeO5Izw5Mdpb3bHgO6pwfmyXBgy5lmwjxCuEy45kC0s+8svNawDfsDFLbcUhDl8MFphSFPyrD0z1GE3yL1zndgNN4jt2UU3rSVjda5oQQs1d90q7LHuyX0mgZaBeKD2P2VQYEPGskkg7JU0M/u2jMZSa4wMmjahroqfNK1l+VKvz4mG5+kBVq3WHR4UxurX2xBpFBrPH9eunXS/KUM71bLExaWSkhych9dk02bGbwvs6JF+YAkPrFQtJkp5eMo64IZ8c1YPA5AmUIz9ZeGtq76pGf2JmecEhh77EcEMI6lxMfd5SmKO3yFEWHg84
 vxpi7OhK
 nTZsJLkuB084lUXhizVyj7xhZr9hdMD44RUggTVR8LgDzYxfWnX/lnDzmS/h7BEKRPuPTBiKzx9TCOqUA9yUoVfEkYiANlw+asZHwxg08BmVcVlodnk7NZNiQxdyqMR4xcCdxGOlw0b71YmWCoBD0zwFTpJGOtR9uV38JAHLxplwrYwr1BCJrWD6TKfh4baJf8Z5VTrHTgZRwnZbue05SpbsQwggTXFPfRrfxE1I2HLyZ/6A09bk/2MydJxOXCxK4+JE38BV3y1wUVDR0lmKPiZfvVp3WAln2WjmVhVVTQdA61BijWHZDb8GRxXg/EDWEQSTvK2hxlVFnnOgMTvXj1npVihzhJQVBIdG67fRaAW5Sb4gcoyqS5GiCq6sgaQHzrpWeaN51/QJ2SsZyTbvLKaFIiNfe0gdMrlmW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/2/26 10:27 PM, Tal Zussman wrote:
> The lruvec lookup helpers only read from the memcg, folio, or lruvec
> they are given. Constify them, along with lruvec_pgdat().
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---
>  include/linux/memcontrol.h | 34 +++++++++++++++++-----------------
>  include/linux/mmzone.h     |  2 +-
>  mm/memcontrol.c            |  6 +++---
>  3 files changed, 21 insertions(+), 21 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 2b3b62e84ab2..4b7cc97e45b2 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -688,7 +688,7 @@ void mem_cgroup_migrate(struct folio *old, struct folio *new);
>   * @pgdat combination. This can be the node lruvec, if the memory
>   * controller is disabled.
>   */
> -static inline struct lruvec *mem_cgroup_lruvec(struct mem_cgroup *memcg,
> +static inline struct lruvec *mem_cgroup_lruvec(const struct mem_cgroup *memcg,
>  					       struct pglist_data *pgdat)
>  {
>  	struct mem_cgroup_per_node *mz;

From Sashiko:

[Severity: Medium]
Does this function actually just read from the memcg?

Looking at the rest of mem_cgroup_lruvec() not shown in this diff, it
contains:

     if (unlikely(lruvec->pgdat != pgdat))
         lruvec->pgdat = pgdat;

This mutates the lruvec which is logically part of the memcg's per-node
state.

Since the commit message states these helpers "only read from the memcg",
is it safe to constify this when it can modify the structure on newly
onlined nodes?

Answer:

The write goes to lruvec->pgdat, which is stored in the per-node
structure reached through memcg->nodeinfo[], not in the memcg itself,
so const is fine. I'll clarify the commit message.

> @@ -1528,8 +1528,8 @@ static inline void lruvec_unlock_irqrestore(struct lruvec *lruvec, unsigned long
>  }
>  
>  /* Test requires a stable folio->memcg binding, see folio_memcg() */
> -static inline bool folio_matches_lruvec(struct folio *folio,
> -		struct lruvec *lruvec)
> +static inline bool folio_matches_lruvec(const struct folio *folio,
> +		const struct lruvec *lruvec)
>  {
>  	return lruvec_pgdat(lruvec) == folio_pgdat(folio) &&
>  	       lruvec_memcg(lruvec) == folio_memcg(folio);

From Sashiko:

[Severity: Low]
Were folio_lruvec_relock_irq() and folio_lruvec_relock_irqsave()
intentionally omitted from the constification?

Just below this hunk in include/linux/memcontrol.h, both functions
still take a non-const struct folio pointer:

static inline struct lruvec *folio_lruvec_relock_irq(struct folio *folio,
         struct lruvec *locked_lruvec)

static inline void folio_lruvec_relock_irqsave(struct folio *folio,
         struct lruvec **lruvecp, unsigned long *flags)

Since they only pass the folio along to other now-constified helpers,
should they be updated to maintain API consistency?

Answer:

Will constify their folio as well.


