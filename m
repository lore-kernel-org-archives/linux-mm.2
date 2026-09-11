Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0DD8C88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 18:26:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C65976B0088; Fri, 11 Sep 2026 14:26:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C156C6B008C; Fri, 11 Sep 2026 14:26:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADDA46B0092; Fri, 11 Sep 2026 14:26:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 78B9F6B0088
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:26:09 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 169A91602FD
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 18:26:09 +0000 (UTC)
X-FDA: 85202310858.30.2839037
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf30.hostedemail.com (Postfix) with ESMTP id AC6E880002
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 18:26:06 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b="S6iRa0f/";
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=WunG1xUt;
	spf=pass (imf30.hostedemail.com: domain of ashok.raj@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=ashok.raj@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789151166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I2VP66MJnRkDMYUgYGBaZzplQPMX6KJi2mSu6YYl52g=;
	b=R9t1HvEqoqaiVngEPdqD9b1BVHHOW63it/8P2hnIaIO6PDNRkJRMVJ5PGxe7pPyIBFIQ2T
	BrPluAhfoKzrzgX0Ot8HrVtubEWPgB4wuKU2QEW5xXKtjHyo9T2GkZk+BxYl+Wagt7aJTr
	qzLokWD+idChtuz4m+JTruDGXkuOUrQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b="S6iRa0f/";
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=WunG1xUt;
	spf=pass (imf30.hostedemail.com: domain of ashok.raj@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=ashok.raj@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789151166;
	b=YWdqxGBRiATSd3sIuHkYR/CA4m6IC47Z1CHRPQbVWnUyFnYHpZRd4cGVWyXnJsJtK5Vglf
	IAmP1GNmTf3CsRncylReZYC04Q08VUAQIYQ4336PwrDk0TCOXamyQh7WG+iT0k8wwMnnvi
	eJiMfdCSPVGQAfMxebx58stTFZdoZ+I=
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68BHWVLr972042
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 18:26:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=I2VP66MJnRkDMYUgYGBaZzpl
	QPMX6KJi2mSu6YYl52g=; b=S6iRa0f/eOeRpK4TSer2p1jlzG4oKEUPSsdSRohM
	u16+w6WgSxLHg6yHYQgpKQZ46M6wO8+N7TRqSf7VU+v6fw9ihrL8oxa7lkFqytdE
	NcqONgZPT4DSoBo3jM9CcZ95qPPaPix592m9ZKFfgujPYht+VXIk9/AwFiiSrR2B
	J1tr6o1brmEjA/ynHBv5vYR7FxscNkuA9PUfPAfRs4f1QsqS0vtbG7A9W+mFMIac
	0Y3nKzBWheaT6q7exogm/UrGAwwX8RNyuiLXViucbsGYivAqC31UlQN8ZFuILglr
	x3Vj1ZhE3hqlLceTel4S59WAQYuoI5bIhov3/kEncesvFA==
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gmm22rrwp-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 18:26:05 +0000 (GMT)
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4b28db6c77aso1553142b6e.3
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789151165; x=1789755965; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=I2VP66MJnRkDMYUgYGBaZzplQPMX6KJi2mSu6YYl52g=;
        b=WunG1xUtC/PTYeGL8bs71yTxxFn+vRLjpo79zWfhy7zZUGzA+k3kWiQoN/FeMkX5T6
         iIdc03qZD6Wr0I+180JNgFrO7sYtboMohZrB6e9Ha5jjvT/NjHQMoRuOzqhkN4h9MRIV
         Gl9pNU0j6NQ3cTEAKp3WWfIyF7PCAQOQKX0JGjBRIg66iOcCJa7ZvjjBaeI6aELHhA8w
         HG0csBk80WF0bkqwSiX3xbM5rq2zxyqlugAJsDo5k3NKMwyEPfBajHeL3TALo/unuFvV
         blDn+0f2DOggDSqnEvjjwN/EJz7dobuP8zepudf9qUtkov6lImWOny6yTv0j262Imm05
         4Lag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789151165; x=1789755965;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=I2VP66MJnRkDMYUgYGBaZzplQPMX6KJi2mSu6YYl52g=;
        b=f6p6a4mhzs+wKwsGUcXvR8wAHJ7X4NOtb744NiHSLdgFFOP6rEs8BspyfFHYq5e8y5
         1F/Vtyk2FEsGMJ7lxed9LmJ4QMNJ93XsAHT8wYJtG7ZpxR/HAXHyzLwfnUbk8fYWZp4v
         dWf0iCJCGK3xBfu4Tddt8BA7DzPzxwDNKzzn5HmIvyKpOeJQb9FXRjE7GnawTBolm2jm
         jAYS+w9V2h7OjKiy3rqf1K5m7MuFxO4rHm2XXiypAtY8KpLQudcrHtIfHOn+U/UTQ5qD
         FUqq0oIYO7YkHWkSlHcZp0J47P+6rprt35zactrzHqsNqhse0vTkyBppwQS+jao6a0rw
         hY5Q==
X-Forwarded-Encrypted: i=1; AKwUvBxh1H8Dm+c9+KxD2gtsBrv/t9GWI6ZWbxDuma5Wzom2z5lOVMFVntm2rZSo/DkD0B00oPCl+6YTLQ==@kvack.org
X-Gm-Message-State: AFuF++lOb6t0YP/fBsxbEl+vQ8wKT1xB0RsPUbhp8ryK9nSDxgZiO3x/
	/iT15og/0clIiIx1tFHtff7aD0ZOoI562Z8N/kH1H5xY8oJuyYEvEPZKXnuCLwBb/tK3FdybTgS
	GMoLzs8z7xv0Tabm0e3JgDnCtjh59kJCQma8LTYBJ5RsFH6rNKa0KXpn1s138zujS
X-Gm-Gg: AYBFou1olryqQIHTyjAA4/tP/Y9ELeLTbAJShSf78P2ek8KeI6JcOjnYTjtiolOi+n4
	TL29/0yICA47CDfPkFPp9ct7H5SMoD6pTjpjqzcg6Pyf7UQ3QkEg3Uz1mXbuWGrZOX5V5RjY/c4
	w1uPay7dxf+hz4IEgoBM83YYRxyptJYKbfPcfKH0Tir5NxTHQAbKaKRd7bfQ8Wg3mh+5hO62apd
	GUoqQ+Nx0Ti8gFPbRujiFXMtoHz6NEHlGnEaBDJjDxxevjUDVrkktLuIjc4rzpu4IS9Sdk0UG0K
	tJ6TFCC8FXG4ZsMjpiPeFimGYH1S915uSIftR1H+3sW3IfsNdQDZbADYKjtcI6qtX00fxBD1sp/
	4EUbL3oJCuMWVtWU98HKkwLMoSmam+BmbLwG4+irhnhWEKvt1dQ==
X-Received: by 2002:a05:6808:c2d3:b0:4b9:e5fa:8903 with SMTP id 5614622812f47-4c31b4c8dc4mr3978463b6e.22.1789151165105;
        Fri, 11 Sep 2026 11:26:05 -0700 (PDT)
X-Received: by 2002:a05:6808:c2d3:b0:4b9:e5fa:8903 with SMTP id 5614622812f47-4c31b4c8dc4mr3978426b6e.22.1789151164663;
        Fri, 11 Sep 2026 11:26:04 -0700 (PDT)
Received: from hu-ashoraj-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4c3327e9300sm2849879b6e.18.2026.09.11.11.26.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 11:26:03 -0700 (PDT)
Date: Fri, 11 Sep 2026 11:26:00 -0700
From: Ashok Raj <ashok.raj@oss.qualcomm.com>
To: Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com, joro@8bytes.org,
        will@kernel.org, robin.murphy@arm.com, iommu@lists.linux.dev,
        liam@infradead.org, maple-tree@lists.infradead.org, linux-mm@kvack.org,
        jgg@ziepe.ca, kyle@mcmartin.ca
Subject: Re: [PATCH v5 0/3] iommu/iova: convert from rbtree to maple tree
Message-ID: <aqRHuO1rzkaIL0WP@hu-ashoraj-lv.qualcomm.com>
References: <20260818152505.1057922-1-riel@surriel.com>
 <aqQ2E68lmU3Fbjsk@hu-ashoraj-lv.qualcomm.com>
 <d2f5889660e97f03fae2cd43ae32d8bf8edf3446.camel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <d2f5889660e97f03fae2cd43ae32d8bf8edf3446.camel@surriel.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTExMDI1OSBTYWx0ZWRfX6a3ExRBf0xEQ
 7vIy09Q2RsufHmALIpalkn3dkvFXiIk1n05pcHVmKwitZBE6usDKn9o1B4iLisJuqSbz9jV8EgG
 hcvloLkyB0k6JDz8ftsE0olVTGe6sYmhlbXBtcyflQ2bmGyP8xBDFm2tEytTijxTajPRtRkkYZJ
 47gOQZ/hdw/1GmXvN18Rp31vLZ22L/GXyBz5CPjrmLQX9ndF49XWLDfMcwXei42QoXxTKFWPkC8
 /gqEn2DkvW2UwqAKGmrzUE/F2JpSdC5W+YknfdQp4mE0ficN4z1fHeH+88JoEPPG1KG6uYrNMnP
 hMH+idvCC1Fn1aPeOZcaiAHIHZXnxZ94TJVch9d4fmOZFHBngalXkPNwPxkwYLj7y209RwtUG7R
 KN0WuOhofUdAVyfEJrh4UGxZsiJOA7ujSAhxMUOvwG9LVHCLLaZPyLq1CvqdEVFBZGQZL+XU/ys
 q9JDVYkAKo1Wi+EEohg==
X-Authority-Analysis: v=2.4 cv=LPDz05W9 c=1 sm=1 tr=0 ts=6aa447bd cx=c_pps
 a=WJcna6AvsNCxL/DJwPP1KA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=eqVH15oDgQDJub46UIAA:9 a=QEXdDO2ut3YA:10
 a=_Y9Zt4tPzoBS9L09Snn2:22
X-Proofpoint-ORIG-GUID: gfhCc099S-LaGysENRBNOCPEwmqxiFc-
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTExMDI1OSBTYWx0ZWRfX72UGcQMQYnrg
 83vrsCcYiAOv586BdczhsRxD/2/4Qf7MsR6YejdvBn4Y/HFeICSfiOedBRJPC7gyqZnpNaqBM4a
 cggpYWFfl3+6R4EzP80ztqoONAX/IVs=
X-Proofpoint-GUID: gfhCc099S-LaGysENRBNOCPEwmqxiFc-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-11_06,2026-09-11_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 adultscore=0 clxscore=1015 bulkscore=0 impostorscore=0
 malwarescore=0 spamscore=0 suspectscore=0 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609110259
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AC6E880002
X-Stat-Signature: 751iw3ncw6iiqhohmrxq3968qiw6ne8i
X-Rspam-User: 
X-HE-Tag: 1789151166-575082
X-HE-Meta: U2FsdGVkX1+FnDyffdBJuQpvNREX1d0p66XfjJilYxKDIGhanBF1OcMUSH1LYo3dtVQ5uU5ibE/j0n8gV+3vDe1OIbg0PtsrFxVXlJJRkRnG+cpfYIFQ0yZV9eEf2CByTLHb43w9SLNu2Buxz4rDN94Je7xyXQuec+P+2qldRESI+z8yHObVtTHKY9GpZR/6zZGDuO8xwOv0cCC2e16LTEFFoTJ9Zo0ykjNuY5MZXSdVOPjCezO1B+L8QAItNYyFueLWa/tojBCLQ4lAVWCMir3uAbdg3U2o7ZxEUiLp++insIZ/qwm/lzyLXMHmGdBhJr+vVDKCCPpk2MnPbG4axIw04VpWrzRg0iKeyLnlalt9CqyrJKJLFiKoJYrjOBJTZJvBj9T7PrbxhebvNH8BisjYmBSA2l8Cq565wfjv2dPDmrF/H5UPSmV/GGgF6fGqzAplvUhvNM8s0rWEXirukG2tXhUt+N5GT0920nvppd+YKzZDy1acgD61IsX9L/cPzhMFlXF9f3GfaVDIsV1q2vnM/2WZA8A5zO2Sl8N9SArVtku1frpY1VKFyJYKv4WCEPdOD+KyyuAruTQtceC8BXMcjOOKeOzyItDE6oKKaGgTEWSKf9m8wDabgOru/hHtlxQNRLQMeW1lS358j/QTv1V7efJRa8I6/rN6V9AIVIbaxlP5Aqr1s2Hwy0Q90pwCtIgkImhOx+0fDXD+Z7NmboC1PUJhEY3pfGDMhkHzQCQia0aqQGr7jrS3Iz5lHYVsEkIKEwtGS80KRcceVC85uFWcOry9KKz3z4JnzKs6AYmf2bUYq2jQSytsvlgIUgH8/7X8bEJ/ni+o0gJ9N9Hznig9rSXQjfvf4ZevxsZ+kx9pnuXelYHKs8QWMYeLlzzSmfonV90fSsxhlcQxxnpLcKqAZoAH+DOfsikjJPpELmVNTh7ZtjU6ooP2vMY0Zhi0ya9NqM6RECpiQNPsdIM
 YgO3lNyk
 jYjSzFRVtAMo7QhQPxhJ1vtLhj0bpOezcCYEQx12k6vj0NjTqAcZSnwVuJTayduMGtxjdvKC4UYPaVt0XFR8W1RM4ziOwB6fJK7Dqw9CvyY6diUDTRDtOdHwF0/u8DV9cgTnZwv/ws+BgZT/eE2ej7wO8nuVvy3ynGXM/jSsximiNNf6Pa4uB3SS3Vwcwcp0piJhSMtfavYqOKsNPk/6Ne2OXj2pvNpELVQ3sJDwEuDLaewzt/ym1aiNG2qHdYLiCiNTC37m7D8CKYJcdcv2Eyzv+84VgV4vBZoSVqXqGGXw5l/oBX5/Ku2IB6l4I22lZgyCJ+hEYYfIw6i9Q11yAYPpYsXJO2hu8nV+RdzrLrOfmCw0E8mxHQZBNQp+TbdXBY5CzEeqYxZ4FJB4tIpE+rQGOXas9RJl1s6LNVT/f5UXn2zC4+YLp9Xz7CvZU0z/X0hWEQd5BkvVcnBbqRCxOkX+D+Ui0zu8NEhsY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 01:27:29PM -0400, Rik van Riel wrote:
> On Fri, 2026-09-11 at 10:10 -0700, Ashok Raj wrote:
> > On Tue, Aug 18, 2026 at 11:25:00AM -0400, Rik van Riel wrote:
> > > Occasionally production workloads at Meta run into the linear
> > > search in
> > > alloc_iova() in ways that cause real issues. For example, when
> > > enough
> > > CPUs at a time fall into the linear search trap, systems have been
> > > known
> > > to get stuck for so long that it causes soft lockups.
> > > 
> > 
> > Something odd, except your cover letter rest of the patches are
> > missing
> > v5 prefix in your patch? 
> 
> Ugh, indeed.
> 
> The content of the patches matches what I wanted
> to send, though.
> 
> Do you want an identical v6-marked series, or
> should I wait for feedback on the code?

naa, just wanted to tell you since it happed the last one too. 

Unless you hear from others and you want to roll in new changes, this
can stay. 

> 
> kind regards,
> 
> Rik
> -- 
> All Rights Reversed.

-- 
/ashok.raj
ashok.raj@oss.qualcomm.com
Qualcomm Inc

