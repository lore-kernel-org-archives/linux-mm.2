Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14828C79F82
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 21:42:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEE676B008C; Fri,  4 Sep 2026 17:42:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9EC46B0092; Fri,  4 Sep 2026 17:42:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9668B6B0095; Fri,  4 Sep 2026 17:42:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 661646B008C
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 17:42:33 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E2643A33E6
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 21:42:32 +0000 (UTC)
X-FDA: 85177404144.01.23B08B9
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf05.hostedemail.com (Postfix) with ESMTP id 44A40100006
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 21:42:30 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=nvpYHaWp;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=Z8sEUc+v;
	spf=pass (imf05.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788558150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9sBsrXDWsA6mIM6eTb+x+9JskBQgNRQ7PhCpi14v3SQ=;
	b=5z/JyIYq9/3o1fjIOf21zaPGS6hBVPaloNk6aFvfQ9xZ4AmW7VX59gTOLlSyCyO80qAJbR
	kkZqt9Tp0/a8+cB+WUSzlgdVIvp32v2rZQjglCR9qASjVw1vpJX74P3krIe+PVUhjBXwiN
	zAvL+Bt455eIJy5nyQfGtVsle4W6nbY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788558150;
	b=1LJD4ierRtHVykIwuL8FoqD3/LJDhZ4jDe4LgqYEfn3CYseQoLb/VpJuO46bwwtg+Lt158
	K7KG3AGcO2K8gCIrUttqvAzBRecNQ8sI9vZDzxrGO7DzhxpvZ5Apl2SWxZOFimM8X/HH1P
	8zKe6HV0e1KZ8HOXhlA2SJ7obTy7y74=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=nvpYHaWp;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=Z8sEUc+v;
	spf=pass (imf05.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167072.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 684KYvRn2719569
	for <linux-mm@kvack.org>; Fri, 4 Sep 2026 17:42:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=9sBs
	rXDWsA6mIM6eTb+x+9JskBQgNRQ7PhCpi14v3SQ=; b=nvpYHaWpJagUrv72UkPu
	pSyLtzsV1MZZi57QENoYRlenxKN2V2EsKHyhZ9o5kJZaa2q3s3LGsw6nDLsiobU5
	wEQFRPDAoD0D541yZ8U1Y+BjiW9KFG6uT79JPlnRHXhEi5zNEzNRiMP+EuEnqdfs
	OrHHhY/585JZoZ7zWL8I6RT5o1wOEPg5htyWEDiU4Qd9pEcl0Zp2xARNJ8J5/9WM
	w7S9cP3TRSGxIJSjWIwNi7TV88gioy34fkCUxBgxdbyML0goMreNY2ygjzWl83AT
	iXDilJMAvs8KbeChfGBTJaCPT1NK6iCXdUUkQ4xSk8w0kW6pSQl/iCr7gZDkNlkF
	GA==
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gg0ac386k-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 04 Sep 2026 17:42:28 -0400 (EDT)
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-91043af01d9so15743126d6.2
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 14:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788558148; x=1789162948; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9sBsrXDWsA6mIM6eTb+x+9JskBQgNRQ7PhCpi14v3SQ=;
        b=Z8sEUc+vF7ftaWgOTZr7NIzbq5dnMA1PHpCZAv+ixSjj/8zYKE1nWRD7vebnDEsVla
         GGQuCn9lyvyuAG7dKNDz1m7/IjuZxnW+e363M4pONOOloT8kusFwJJ7/kd/HGv+ErKF8
         x1C8mHfYjif/WbEk6XdT2uOmMmI1L4YnBDuctUoy+BUUKs8vpbLwgBMGOb275mkvFIUw
         PzeA4hxdkjeQyxErZR2c0PZ6KlDkB36VdnebTpTJeFHxRb5KeJ/2ipyzhpdWbOUkwZz1
         0gewQunGbBQKyCX+ELXoOwNFPWRjRlf98673JvmwYF2pQM+m/RRJ+jwmb063BGm75wdt
         rkQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788558148; x=1789162948;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9sBsrXDWsA6mIM6eTb+x+9JskBQgNRQ7PhCpi14v3SQ=;
        b=GQR48qxgwV4G+Jh206yERogx5PmbgHRtv5vMchoNopJEz279TrBqgullI7jGnINhZz
         Ditk8UjcHVxbwbFR2sH7/ad3Zg2MNh9NCEwYZfk380GDxogDDVXacA//IqI+NhiKwTtx
         szMizA3Zc8llIsBBbY+tFGcpJaDvhZpHSXIO13R2hQm4Ws3xGe+kM0n5gBAUFI3pdush
         T7YY4e3v3+h9M2L+bhBsDAslX01/fK2XIMMTm8xJp/J5bZixxwPkInbm4B0qHe527RcR
         DXKWb0EYwdzBj3q4cgInvHfhFbaJcW39cv9PdSDacBXqnCW4e9d+N8mgpPyrTWkWh/Of
         HP7A==
X-Forwarded-Encrypted: i=1; AKwUvBw/cBDROk4ic8uVFy5AFHlzyVE61AKDTybdWAMgnZRd18lhhGqIy9ytIeYuxj05FMjmAIDwzvawfw==@kvack.org
X-Gm-Message-State: AFuF++npFkBNLWuHMBGXeLinG7sQJ3gkCPcihigMA2iHIQOV7wOTPMOs
	MsbHcRKWyrALew9Z47m8KAUReOZ8RQdM06DWnO8Fili1nNQlsZnu1kglZh6i34Zkiy7OpnN+wwe
	pVY7LZ92ArNu28uUXufEDSLVS4VFd1EU6Jlsx+cfy8Y+ncRqE
X-Gm-Gg: AYBFou2/vT9eHBL25v9McOltEd+szeY2HOg3s1YWQ0lKFZP1d3IFjN2YNG25MCZaTeh
	nlxIm9FF0P7CTD0t8tEq+rejdsbK52ckiS/i8JfbOWU7OWYb52mFSGawq1hZtuZUCdkS9hcT87E
	PkeMsvNNBgQHuHtaTCmBE2ECnQN+NUCsDGA5OTlBh3ZHeMh6JPr7ls/s/lCkyZ+5W8LW0I9XZzf
	iY7tlPLJvQvF8PP/wFeE3kcBU1Np4zYvB1+syZ5t7rRSb4AHekGax5Z7lHtFTjJC4lHWM3gfAHN
	slN9VDPR3HQDxi+/6RcBvDsxhnuKX3ylfCbllGZ86WRLuQLVlEIJ0Wihb+w3koG7LBmM1TB//1w
	SzeN5aM/oQqEzSGXlVj5jts5iWezXBrma9LyGZqPMaAGSHSRe7mGx
X-Received: by 2002:a05:6214:f25:b0:910:44f2:5ce3 with SMTP id 6a1803df08f44-91044f25d21mr48209896d6.8.1788558147681;
        Fri, 04 Sep 2026 14:42:27 -0700 (PDT)
X-Received: by 2002:a05:6214:f25:b0:910:44f2:5ce3 with SMTP id 6a1803df08f44-91044f25d21mr48209456d6.8.1788558147144;
        Fri, 04 Sep 2026 14:42:27 -0700 (PDT)
Received: from [10.207.49.22] (nat-128-59-177-158.net.columbia.edu. [128.59.177.158])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91043b54cd6sm18880636d6.34.2026.09.04.14.42.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Sep 2026 14:42:26 -0700 (PDT)
Message-ID: <7f70b59e-b1b5-452a-8a2b-d51392737a53@columbia.edu>
Date: Fri, 4 Sep 2026 17:42:25 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/11] mm: memcontrol: constify the memcg and lruvec stat
 readers
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
 <20260902-folio_memcg-const-v1-8-e2c1da22246d@columbia.edu>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <20260902-folio_memcg-const-v1-8-e2c1da22246d@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA0MDIwMSBTYWx0ZWRfXxoTDn0ha0K14
 9ynVtm3FkRGi4AMlPt3mF4DWqkuV3hbsZ6UOGVuiMpH3sKZdpULllMwFDGrVoQf0oEt2BjQSZPy
 MA3vZWKamtgWg8S5KwYaOkLhrlSJQebJLssmzKqISssvwsPkD92bGlrhwPKvjoy+kW5h5bf2IEx
 QaFxIHotLv6R/fr1NEej1xFaMDcASnG5n8vZIMwiah08NGOMQ0ZvJhaKAr5xsFMddNry+k0i8Ne
 GT5hICcB08IUwywMTf/PnXbm00dJ6xGBmzmYJcfxB05VNyek7X9YPyYrSLC48O4mmQtvCaVvodg
 zYpNirluwnpljb3kglqM8+AXaa190wz+55Z3B7Di5ToR4eRM1uEC/oLpFUo12GigJ+aYhIXfbNW
 LujjsNMMEDyUso3rChrnW1mHh2o+cYJjzesqJD0NPVSMSGs0bGV+xJavQoUh4DQFAkkcoZHoguw
 oxrmfW17W/mMs3zQCJA==
X-Proofpoint-GUID: xi-PlWb7BspuOIzC9bynbAP33Bil8ph3
X-Proofpoint-ORIG-GUID: xi-PlWb7BspuOIzC9bynbAP33Bil8ph3
X-Authority-Analysis: v=2.4 cv=MotiLWae c=1 sm=1 tr=0 ts=6a9b3b44 cx=c_pps
 a=oc9J++0uMp73DTRD5QyR2A==:117 a=tLges04aSNaZGVAfhBIy2A==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=SsB-OO3BMngHh3ZO9fOt:22
 a=H57HtBtNAyM616LuGCcA:9 a=QEXdDO2ut3YA:10 a=iYH6xdkBrDN1Jqds4HTS:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA0MDIwMSBTYWx0ZWRfXypxYP1dcNjmP
 FY/8SAdWjGLfLKHIBDt0Qhhh9Av1DmFwvUQFzR1aAYA98w/HEP1DN/ACTpbFz8psXtccdBKxcPc
 UkEuJ100T8ZViILZ9q0XIZFP/hWfWzk3wHrr5Yi9QYTWbmN1+OPR
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11896
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=10 priorityscore=1501 clxscore=1015 phishscore=0
 suspectscore=0 bulkscore=10 spamscore=0 impostorscore=10 malwarescore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609040201
X-Stat-Signature: orz5ywua4fiq67j8mm9mo888w873n789
X-Rspamd-Queue-Id: 44A40100006
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788558149-196294
X-HE-Meta: U2FsdGVkX1+RqOr4v7Nr6d8ogcVRTk+bBP2zAECmCTdpRw5UrgLlJDWl4sQndZgVKHldv/rhzWvaAeI5f0HWMw9XdiA5BWWly0Cflaaxh7IKO/tYdm2b8qytYln1yKrdpc7lp1qD540dOPl1ubYKsY5tN31j8rkJGh9emECXpmGD657DhExmTztAA25EOdf/epqXZo/7Qszw0nsvD5Qb95ABtJecNO76ycImqorD8rjA7MJam8ve//BZDRIbUVGWt7Wyzx+EzT5ARUkjIURNro1lZfPkUzjxdmlcCIAlUaTKSzTprBF/bGNyKpmuTtNEZapldXGa79lxRno7SWu2VXI1kOaKadUr+lqK8USCh6JjPDsHzFxLavGlESxq1QDdKYtuFZ2FQKy3WPIsi6PamfQtLg/sq0gwbvZT+Y2J9L/sJo2ASzZGjYRpqGYi0eqb4xWXQ2Tyze1/7qbWPZAzWULPbykwczMMiWYXaTjRwdlvBW0wYqVP4jEtDBKPpTqghnJBLz8xPSgsyi0n0d7UGDc8mK3Sj4mQUct+Ctmr/IIXsuVp8P349Jd2t64DgFnQeMURtQsI2yZw1R4sxt/b7VrReHseNY7DQKByAb8GyZeXUadLBWoBwPPDYvqXkFI+OfjzQ1ZPXjTtR4XORGpa7jK1xoKveTtBYucweBPyHNVxI2mAlQU4MI2k/iFA1woTHEQvcxB2PbMsVr63jCne4H7UCEp1U2fvOzqP/ukRkxCxNY0jDblvGOgVD2xAQneb3ScALm9BMFVW0G8rFNo8rmboU/JhmiJCRyLUywn/Gp/+zgnnOl9Oe1Av5OPname15R//cGMEW8fuIAma+lnD7/d1VM+19ETVC2OMOci5ueyK+kA2Kl9d/lqa1IVAcSVudPZR1VYJwnW1r7xo09RXKrAkAFT/CjtG98NkL7VT599pD/nBR4J2X4wxHn4EUKGN8makPxXSKMNdNMcSaV6
 IfUx/GFK
 1uHMn5GrsEdNayQh+jlmQi/XMN4q+4P08AWrgoIW1iJxkLFT4V/otsHsIYNIHGUXUicJwnor3dirSjddMXk8CE6kefII9h6oXz4VjLmW/m5wkKZXLfMDLupRcbhLxX/nXAg0pUy0hE3Y6WlLm3DzGJ06e5cZGzD7J2+G6Yj1bH37UHxrXus42JPfEzK+zDVYjyKEYron/fcxxMfFFEp+CRDDbppAOYjEsusJ4ob5ScIb6vbPfvoGdvMws/M58hEhnL29gFn8yWnzxL5YTjRt1GqEGn4vBA8UmWrYgL9gnO7bpLbi8McggT/oNQ8jGlg+XnR6th7N47tFxnkUg0OeEeZt3dbONHI23l1eL3gc+8STcjx0ngy2nVBrxuEmmuxs+9vJtJt3y0R7FbT1p5hFMF3280TUCSDdUuoN0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Responses to Sashiko below.

On 9/2/26 10:27 PM, Tal Zussman wrote:
> memcg_page_state(), memcg_events(), and the lruvec_page_state() family
> only read counters. Constify them.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---
>  include/linux/memcontrol.h | 23 ++++++++++++-----------
>  mm/memcontrol.c            | 12 ++++++------
>  2 files changed, 18 insertions(+), 17 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index bd82628d0d72e..10a197886f316 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
[ ... ]
> @@ -1392,19 +1393,19 @@ static inline bool memcg_vm_event_item_valid(enum vm_event_item idx)
>  	return false;
>  }
>  
> -static inline unsigned long lruvec_page_state(struct lruvec *lruvec,
> +static inline unsigned long lruvec_page_state(const struct lruvec *lruvec,
>  					      enum node_stat_item idx)
>  {
>  	return node_page_state(lruvec_pgdat(lruvec), idx);
>  }

[Severity: Low]
Does passing the newly constified lruvec pointer to lruvec_pgdat() discard
the const qualifier?

Looking at lruvec_pgdat() in include/linux/mmzone.h, it does this:

	return container_of(lruvec, struct pglist_data, __lruvec);

This returns a mutable container from a const pointer, circumventing the
internal const-correctness the patch intends to provide. Should
container_of_const() be used here instead?

Answer:

lruvec_pgdat() purposefully returns a non-const pgdat, as some callers
still need one at the moment (node_page_state()).

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 35f924c9f2a31..3d3eadddc1307 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -489,7 +489,7 @@ struct lruvec_stats {
>  	long state_pending[NR_MEMCG_NODE_STAT_ITEMS];
>  };
>  
> -unsigned long lruvec_page_state(struct lruvec *lruvec, enum node_stat_item idx)
> +unsigned long lruvec_page_state(const struct lruvec *lruvec, enum node_stat_item idx)
>  {
>  	struct mem_cgroup_per_node *pn;
>  	long x;

[Severity: Low]
Does the use of container_of() later in this function silently cast away the
const qualifier added to the lruvec parameter?

In lruvec_page_state():

	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);

This macro expansion discards the const qualifier, undermining the compiler's
ability to enforce const-correctness. Could container_of_const() be used here
instead, with pn declared as a const struct mem_cgroup_per_node *?

Answer:

Yes, this can use container_of_const(). Will change.

[ ... ]
> @@ -530,7 +530,7 @@ unsigned long lruvec_page_state(struct lruvec *lruvec, enum node_stat_item idx)
>   * monotonically-incremented event counters are stored in
>   * enum node_stat_item.
>   */
> -unsigned long lruvec_page_state_monotonic(struct lruvec *lruvec,
> +unsigned long lruvec_page_state_monotonic(const struct lruvec *lruvec,
>  					  enum node_stat_item idx)
>  {
>  	struct mem_cgroup_per_node *pn;

[Severity: Low]
Does this function also silently lose the const qualifier through
container_of(), similar to lruvec_page_state()?

In lruvec_page_state_monotonic():

	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);

Would it be better to use container_of_const() and a const pointer for pn
to preserve the safety guarantees of this patch?

Answer:

Yes, this can use container_of_const(). Will change.

> @@ -547,7 +547,7 @@ unsigned long lruvec_page_state_monotonic(struct lruvec *lruvec,
>  	return (unsigned long)READ_ONCE(pn->lruvec_stats->state[i]);
>  }
>  
> -unsigned long lruvec_page_state_local(struct lruvec *lruvec,
> +unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
>  				      enum node_stat_item idx)
>  {
>  	struct mem_cgroup_per_node *pn;

[Severity: Low]
Like the other functions above, does container_of() discard the const
qualifier here?

In lruvec_page_state_local():

	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);

Could this be updated to use container_of_const() as well to maintain strict
const-correctness?

Answer:

Yes, this can use container_of_const(). Will change.

