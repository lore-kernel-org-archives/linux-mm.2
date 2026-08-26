Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCEFEC5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 18:08:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFDE26B0088; Wed, 26 Aug 2026 14:08:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B87C56B008A; Wed, 26 Aug 2026 14:08:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A270E6B008C; Wed, 26 Aug 2026 14:08:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 689C26B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 14:08:00 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DCF931601CD
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 18:07:59 +0000 (UTC)
X-FDA: 85144204278.09.1D98E8F
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf25.hostedemail.com (Postfix) with ESMTP id 41D91A0008
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 18:07:57 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=aLiR3ZLh;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=Ot9d9L0p;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf25.hostedemail.com: domain of ketan.kishore@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=ketan.kishore@oss.qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787767677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p46+lTGQMwY0s7h5NS8WStt9mOrENqE7hJSRqtkar3g=;
	b=jpC76lBaiKOuJtYtyWLd9GhCE48d9bS5GZOmcygsNlK9LbBm9ufu6FTTZBF1GPFEYVIGzu
	MO9AOIc8Vw8kyKtseB3DT3RDfsMkGjq49Jqk2h/oJu+dyI5+sH1Dqm6xFBncRD9orzG7iG
	NLrqBqptGmxAAkBkJvR7g0njrtyfG3U=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=aLiR3ZLh;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=Ot9d9L0p;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf25.hostedemail.com: domain of ketan.kishore@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=ketan.kishore@oss.qualcomm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787767677;
	b=u+h6tHJWhIAFmhtVeUTdRjeQYYH9kgow2Iq/WZo3Wh3X7VIYx8q8u28X0zeEwoZgkOSWc5
	V1hXqG9rzIuB+kiYLKFRsQdvVCX91qKe+GHiBWCtt6pFpbMR/T5iI/fZ1kcUurdibKlyGz
	EbunJQQ5wv4SJwiJWQfTvwEySDpoORI=
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67QGug601408692
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 18:07:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	p46+lTGQMwY0s7h5NS8WStt9mOrENqE7hJSRqtkar3g=; b=aLiR3ZLhebvh8vtS
	LF8J6BALZvXuDZH7Xekd3l8kcEJrbLgb3M9sNi/6a54NcjQHbMlOpfgLTyQdNTGn
	wrbryI6xKIdl/bXfScdF8GgsB9UZ4ai9jCP62vfcFstt1eafajBYy2D6NwCKNB+O
	3zxN4R6Zf5GDeERFVuaGyy8Mxty4+o94P+koJlmr2SmPu4RczoIFyg1N+8FY4jKn
	zdWCvbxeVfP4pao3HI0Qy9hrPUtAEhq2YRRHmFtKLDbIAhOIf2CO7M2GMyvQf0yM
	7oRQW2Qs/d9T80vQGQMAf01oCC+WxkwIa7shnKQYTwaOFMFx31GciVJEI7QG8KaW
	Fx6oxA==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g9x2n1vt8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 18:07:55 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38ec0f510a9so3387895a91.2
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 11:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787767674; x=1788372474; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=p46+lTGQMwY0s7h5NS8WStt9mOrENqE7hJSRqtkar3g=;
        b=Ot9d9L0pkTDH7k1x94Rm+5B+2ULk2Etr8rGi7et/YhIIpp4MershKr3tfI77pCXx2T
         UdgijSTT1j24KoBmig3KDT6c+0weLQF/N9FB6FxdmaRicCYZhja/CWheB9hdEKESbCyi
         HLsaLxBdJhhGP/e3GjVc1GxTddX1o6NR/Fg94RdA00w1JOPKtl8AnIwJ4LtSonNAOLA5
         FYCm5l88al4oCGQplbkKaoCQRAOsSa4FESgtsOyLTfxjbO8YN9ufszcMKpapk6z859pU
         i5mmIqCUafWD/oX4cNlM2XHWbksMCP2rDL85XxNB+GXFe80cQXWRtju45x6D7hds1f2g
         vDAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787767674; x=1788372474;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=p46+lTGQMwY0s7h5NS8WStt9mOrENqE7hJSRqtkar3g=;
        b=j+uFYyVfmp7Uvd+cgwA2Xgf/tTjW5rMNo+SNQ1NSbWIw0Af2OTcCofR2rNh+ivtgBf
         hpmish/AVgE3vKbOEE1kT2qLwO4FYgrcv5PlWykxBmkouWckpegf55v4n2Z7I20k/MpD
         HgMdKfh32vPlKi37tf4g02xr2FBEc3P1ij5md9mnC+2ktzAxyRu3zN5BYw9eZ166MJ1V
         JC3o1yuxsQkLGZU2kyBxpwzXbU+rTWfy9hrUqdUNX8C6Xt+1n6uEeCkQEZLdAxAzdvqn
         DeBB/ujZJ2Sy8BtmVmF+dtl4ErkoD4smAOlH+e+M8OMoY/R35GckX5jK8gewXo70jl/Y
         GYVA==
X-Forwarded-Encrypted: i=1; AHgh+RoDnFlBJNKAh9FfLHBEGFoUdVK0Ud7MDV95O9wAQXv81sjFBUN7uPAQAuSf4s6hxnaydzurbMSJaA==@kvack.org
X-Gm-Message-State: AFuF++nAX74qifqrWU3aP70f7e5OmXn/jQPl0E+hPuU9QSI8ytsIQPko
	dAATTGuZcUuRL3BcD/toHwpDrJClByI6UDdAbXSJgvHYQ+BAsqRt0im0AZLb2r0t9Lxbby69oKG
	tR+s++4iP1pKUl7Kz7jIq1fYMzqHMZZ/dqwnqpSdXKI3wNJ9CnQUIIg==
X-Gm-Gg: AR+sD12YlkMM0QceWj5IB8jGHVG0cP9WnPRu6dfQmPx+0Xm54bHSywY7V0KNU9uDE9M
	Umam+BCj4xdufvGeyNnbeepZugHveUEDxQGthazG0FOijbYiZB1CU2JPQuZtqzPzxW7chepPpUm
	Iyu0yQuAjLOxI21KIYio4JaBMwTxHEsOfPrOYwnOzVXgLlmKp0BKKn2rUHzpzj6CAijQujwH+Up
	gp3M5Jd77z5OegpNB/SCjHlQTvkEe4/f7qQItNHUKnBJ/LAmAcTS5WVb1VL24aKyMz3RbTlFEbU
	90QmMS+jzrCPQdj8GR/DbgM4gr0bO5H1apKv5trgJEmBDsMd318vVf6tAQk+97d3cTz0wN3vZle
	2UTgoYkI21u/fATFWNhwq3ryrJefClLI=
X-Received: by 2002:a17:90b:520f:b0:38f:26c7:165e with SMTP id 98e67ed59e1d1-3966d5f8f84mr19248011a91.9.1787767674033;
        Wed, 26 Aug 2026 11:07:54 -0700 (PDT)
X-Received: by 2002:a17:90b:520f:b0:38f:26c7:165e with SMTP id 98e67ed59e1d1-3966d5f8f84mr19247889a91.9.1787767673444;
        Wed, 26 Aug 2026 11:07:53 -0700 (PDT)
Received: from [192.168.0.3] ([183.83.139.169])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-141a8eedd13sm9353803c88.1.2026.08.26.11.07.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Aug 2026 11:07:53 -0700 (PDT)
Message-ID: <b1df5856-2cca-4ba6-8200-f71bcaa1d62b@oss.qualcomm.com>
Date: Wed, 26 Aug 2026 23:37:08 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Ketan Kishore <ketan.kishore@oss.qualcomm.com>
Subject: Re: [PATCH v2] mm/mglru: fix and remove redundant unevictable folio
 handling
To: Kairui Song <kasong@tencent.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
        Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
        Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Suleiman Souhlal <suleiman@google.com>,
        "Jan Alexander Steffens (heftig)" <heftig@archlinux.org>,
        Yu Zhao <yuzhao@google.com>, Steven Barrett <steven@liquorix.net>,
        Brian Geffon <bgeffon@google.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Kairui Song <ryncsn@gmail.com>, linux-kernel@vger.kernel.org,
        prakash.gupta@oss.qualcomm.com
References: <20260812-mglru-mlock-fix-v2-1-a3fec5853c08@tencent.com>
Content-Language: en-US
In-Reply-To: <20260812-mglru-mlock-fix-v2-1-a3fec5853c08@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: Qkt2Ozs9l-mfcpHUjDi5FYbBCNaYDebF
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI2MDE1MSBTYWx0ZWRfX3ueK4gSZOkWY
 2iFlpu5FWY7IhoJWU53eqpyOyLN0sYwIx8K+/+BqHQNYxCvByZdauVLlonKeVksDgQRflCWzUUs
 gRP+f62l/4r61X5vB3LI27mgG/G6coc=
X-Proofpoint-GUID: Qkt2Ozs9l-mfcpHUjDi5FYbBCNaYDebF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI2MDE1MSBTYWx0ZWRfX3uNrJVpTQT8B
 MvNDny0T8tH84VYqSU11OPe+ndI2hTxa4et8cFLyq4PrLO4/1axo2ncL+c10KYESp73W4tAo0Va
 FWGWarjt02qGrW42h7f1yf0SckCvny0zN9uYbAUjppO3+R0ckG0e9qieKn9Ubm3yL7qAm1qOtkt
 iFyqt206hD4uqzQoARTs0bkCZUg2OHwn8ml6EZIl5DkMpRTutEB4W/MdXfHTKsCh1yukbEC1SnV
 nIAMnXHJv3T+p/SmIfYzM5msxQgxrGvd8cGxnY25lxFTqFOGvA6Rr7VlPoAU0o2ddkPECd4K3v4
 mp2m4ui+oINPb+9+YIPnDjJWns8PPgYvoHMF5g8KnTYrDOwNMesJLH1Iy729B1JLSjD4DjFR5W5
 d53EGU0HzvLj7bUC17M6U++eRsJ1mGx+iZuQ2bamIe5CiD16zcon4gBhGv5mSxriueou3S2kDx5
 IruZtdjmTdVJoBfF23A==
X-Authority-Analysis: v=2.4 cv=PPQ/P/qC c=1 sm=1 tr=0 ts=6a8f2b7b cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=JBlIGz/oWaLJr6gz78UtDQ==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=bC-a23v3AAAA:8 a=GvQkQWPkAAAA:8
 a=2LXwFEv-GKRroJ71e4UA:9 a=QEXdDO2ut3YA:10 a=rl5im9kqc5Lf4LNbBjHf:22
 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-26_05,2026-08-26_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 priorityscore=1501 malwarescore=0 lowpriorityscore=0
 clxscore=1015 suspectscore=0 impostorscore=0 spamscore=0 adultscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608260151
X-Stat-Signature: cafnm7gxqxub5ye7e6djmxw6cjy1keab
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 41D91A0008
X-Rspam-User: 
X-HE-Tag: 1787767677-243031
X-HE-Meta: U2FsdGVkX18jUy2wpcQyNta/lda72zH6OUkFloWqFsErMg8O0JbE9LuuT4+0O5TQxwHftxiwL8b0ZvpmbCHF5rx8ZxJWeKza8/BWNvsBq/vSpyvQ39eIVPLKr9yJ4YoyJVcIbku0FVS92nlJjFfj4YneEXaguSbAr4IW0BVak6grD7Hdt2hoA06mzfcSpkCoERMduBpU3FyCktxeQCEKxXs8eH3wwKbqSiBXHW5yPAgFZIjcqlzYOUmJp+0dKGOlNa+yjxWCq2ZHRQKfRR76dlQgOXz73fcynujLl/lD6YdF5p1DbN+nwKwOrj1fOSz5QGpexdZJ4DOzp0nZLR05mgtDaLk2lyex5wfX4vST2B9Pm+aK3Crh71qVRkXhfHgdClRRCz6otxto+kwiMvdlUv8jW8ndRqYbqZgjbfSzBoJhtrx39aoreYDD4IuvW96SMgX6b26n/MSf/5rP55jS1jJzCYeyKDS650nEDIyr2EiUog2Yx1X5smTiKK82F/lBN+CSIzbhfol7Zz/rzztF6DUEdDuJyfetZZqZlQxx0IIuKKlainWF69TS/+0Hj98GflnxrZ+fSxy5fCZZv9bipb0L7i3F7J81H/8NejVnjxOYoNYO2T0XHthpNQrOtbFg7UPsVHdxNxaNPVsrofjuN0pFdDaARyYsshS09L0tXExkOgh2oLIUFdaEb6ZUykEi8tH6QOO5U7iHTdNHQQJ5zkFZiNi7UmBceAax+fJUTWNq6heuBnA5pl7j9+LEwOo/CWVkUjNSASzx1Mjqy1BTglopXFovlGiwo0zHfgV23EFYTZjWfUU9ZWTvgTrBW/VgoCu3V1xaDUYSiqPQYn5wgettHa36/zvulgKtJMJlm8Ea9N0O/KCj2zU3aQI4RtCWSPDrA3BWZX05NbhobaAfDRsYOtdSXIGfTLxfMTWz8OIo9B11c+c86KmkNbiBUSSyq3QvDiVFYSwXyuym2+t
 DCzLR3bv
 EuSy6OROQ9Sr2ICgSZwXMKHEFkhSRgmrk1kjYCuOftiAg9h4F70+C42iu/BHUwgSqZ7ib1DVN0kDHt0h8WcdEiJOPVf2LtQ1J+csSCYTWM8dXQdGbKKRXj5+XMh01W9Eg+b2t4wIp8OyUhGas59bH8k5Kps68ypIN14c/ky3KMb8u9+nWVSe53VBZ2/rb2Wsgk0O8BySvwEtR7tXCumUAah8aWhgyGqXy4g9Zop8055mVNBThIsAE5O+rTRubCDNvzb8bO0hd+OFBk2kECnmJ68m5jYLtH0V7d5QWL11vfI19Lnic2wzA8IBntei6IqigdloAnv1qcrZdAi4Mkl2KOFDcDGpLiO7RtCMcrcZ1eKDfojW6OzjRPbFL88GDJ9qkdlNrxMlTXP8CghN3XVbA+Hf5EoBiCH3RE6mDiJmOUNyLbidXC8N1SjgUQNuAq8PfqpSQTHRJzK+6dqy0B3B9gzy0GLpLhilm3ig40QJ0nI6b4e1OboQoRxpPnfeFoNFAAEQNPlYJPHhczjnVJ9STW+UXfzRLkA99IKlI8SeXZAXztmRlEXY927nmRCGmTbFbpY+84A7XQk5sOQkSuCDr290g5pkH7BAbJyZJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/12/2026 5:52 PM, Kairui Song wrote:
> sort_folio() has a shortcut for moving folios that are no longer
> evictable but are still sitting on a generation list.  However, this
> shortcut is buggy.  It does not follow the PG_lru usage convention,
> and it has a more serious issue.
> 
> Unevictable folios are not threaded on lists[LRU_UNEVICTABLE], so that
> folio->lru can be reused to hold folio->mlock_count (see the comment in
> lruvec_init()).  Hence lruvec_add_folio() skips the list_add() for them,
> and every other place that turns a folio unevictable initialises
> mlock_count explicitly: lru_add() sets it to 0, __mlock_folio() and
> __mlock_new_folio() set it to !!folio_test_mlocked(folio).
> sort_folio() sets nothing, and the lru_gen_del_folio() right above it
> may have already poisoned folio->lru via list_del(), so mlock_count
> ends up aliasing LIST_POISON2, which reads as 0x122, i.e. 290.  The
> result is user visible.  On munlock, __munlock_folio() decrements that
> bogus count, finds it still non-zero and bails out before clearing
> PG_mlocked, so the folio remains unevictable and the Mlocked
> accounting stays inflated until the folio is freed.
> 
> The shortcut also touches the LRU flags in the wrong order.  It calls
> lru_gen_del_folio() while PG_lru is still set, so a concurrent
> folio_test_clear_lru() (e.g. compaction, folio_isolate_lru()) can
> succeed on a folio that has already been taken off the generation list,
> which may lead to unexpected behavior.
> 
> So fix it by isolating them as common folios and letting the generic
> shrink path cull them. This matches the classical LRU behavior, and
> there should be no visible effect on the generic eviction or isolation
> behavior.
> 
> There is no performance concern either, such a folio goes through this
> once, and then it is off the generation lists for good.
> 
> Fixes: ac35a4902374 ("mm: multi-gen LRU: minimal implementation")
> Signed-off-by: Kairui Song <kasong@tencent.com>

We reported an issue with evict_folios() at
https://lore.kernel.org/all/20260807-evict_folios_race-v1-1-b167c6b4cfde@oss.qualcomm.com/
with the following trace:

   list_del corruption. prev->next should be fffffffeead4fbc8,
   but was ffffeafeead44188. (prev=fffffffee4fc4c08)
   kernel BUG at lib/list_debug.c:64!
   Call trace:
    __list_del_entry_valid_or_report+0x100/0x14c
    evict_folios+0x145c/0x16dc
    try_to_shrink_lruvec+0x228/0x35c
    shrink_one+0x94/0x158
    shrink_many+0x1c8/0x1f4
    lru_gen_shrink_node+0x94/0x110
    shrink_node+0x468/0x8b4
    balance_pgdat+0x4f0/0x9a0
    kswapd+0x268/0x470

Our v1 fix wrapped the folio_putback_lru() call in evict_folios() with
lruvec->lru_lock. That introduced a self-deadlock: folio_putback_lru()
-> folio_add_lru() can synchronously reach folio_batch_move_lru() ->
folio_lruvec_relock_irqsave().

We had a v2 in progress that instead tracks whether any
unevictable folio was returned via folio_putback_lru() in the lockless
section, and calls lru_add_drain_all() before move_folios_to_lru() only
when needed, to flush all per-CPU LRU-add batches and close the race
window without ever holding lru_lock across folio_putback_lru().

Your patch fixes the same underlying race through a simpler route:
removing the unevictable shortcut in sort_folio() and no longer
special-casing unevictable folios in evict_folios() lets them fall
through to move_folios_to_lru(), which already drops lru_lock before
calling folio_putback_lru() for them. That sidesteps the lock-ordering
hazard entirely and avoids the need for an explicit drain.

Reviewed-by: Ketan Kishore <ketan.kishore@oss.qualcomm.com>

> ---
> Changes in v2:
> - Proactively bypass MGLRU pid protection and lazy promotion to avoid
>    hot unevcitable folios staying on list for a long time.
> - Link to v1: https://patch.msgid.link/20260811-mglru-mlock-fix-v1-1-8b2321d0e1d3@tencent.com
> ---
>   mm/vmscan.c | 19 +++++--------------
>   1 file changed, 5 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 3194da7dcc79..ca2b926520ea 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4648,7 +4648,6 @@ void lru_gen_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent,
>   static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_control *sc,
>   		       int tier_idx)
>   {
> -	bool success;
>   	int gen = folio_lru_gen(folio);
>   	int type = folio_is_file_lru(folio);
>   	int zone = folio_zonenum(folio);
> @@ -4660,15 +4659,9 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
>   
>   	VM_WARN_ON_ONCE_FOLIO(gen >= MAX_NR_GENS, folio);
>   
> -	/* unevictable */
> -	if (!folio_evictable(folio)) {
> -		success = lru_gen_del_folio(lruvec, folio, true);
> -		VM_WARN_ON_ONCE_FOLIO(!success, folio);
> -		folio_set_unevictable(folio);
> -		lruvec_add_folio(lruvec, folio);
> -		__count_vm_events(UNEVICTABLE_PGCULLED, delta);
> -		return true;
> -	}
> +	/* unevictable: let it through and the generic path will cull it */
> +	if (!folio_evictable(folio))
> +		return false;
>   
>   	/* promoted */
>   	if (gen != lru_gen_from_seq(lrugen->min_seq[type])) {
> @@ -4921,11 +4914,9 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>   	list_for_each_entry_safe_reverse(folio, next, &list, lru) {
>   		DEFINE_MIN_SEQ(lruvec);
>   
> -		if (!folio_evictable(folio)) {
> -			list_del(&folio->lru);
> -			folio_putback_lru(folio);
> +		/* move_folios_to_lru() culls unevictable folios via folio_putback_lru() */
> +		if (!folio_evictable(folio))
>   			continue;
> -		}
>   
>   		/* retry folios that may have missed folio_rotate_reclaimable() */
>   		if (!skip_retry && !folio_test_active(folio) && !folio_mapped(folio) &&
> 
> ---
> base-commit: 1029098ee3275ea5b78e329ce132262affa2f8cc
> change-id: 20260811-mglru-mlock-fix-20d8f8d4847a
> 
> Best regards,
> --
> Kairui Song <kasong@tencent.com>
> 




