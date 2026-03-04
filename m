Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F9CEEB7EB1
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 08:44:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CFE06B0088; Wed,  4 Mar 2026 03:44:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2706A6B0089; Wed,  4 Mar 2026 03:44:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 180016B008A; Wed,  4 Mar 2026 03:44:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 03A3D6B0088
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 03:44:13 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 91DB713B18D
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 08:44:12 +0000 (UTC)
X-FDA: 84507743544.09.6FE51CB
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0BB024000E
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 08:44:09 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=UomrPyVX;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=Rz+8GEQg;
	spf=pass (imf11.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772613850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A4hVQa4Ck15Gxh0A8DRKmYnt2BE+A/oq+1oyfVx6EaY=;
	b=sOX8w3tgK3f2xUwZT+HD5ADA8Cjp0fv4jbmDWtQwCAjgdexpRVmIT/tTvExhcpyr62ln5d
	0Xd8TKhJwmPMJFzfJkVxC6sdKYLHO6Q0++oiL4sun0BxABUY9WAXzrtoVBvLQ1+agcNn1k
	6IL4RVQIH2Hc6wrV3/81Vdhw6YwmTKY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772613850; a=rsa-sha256;
	cv=none;
	b=pGDBIlPjA+oLgn4Z9WtZo7HYSzWT5pbQfTZh9yskYo4aAQ+ccIjFHcvCQ5uOJZXvMuxCBM
	Oqa7v/4kRaXKl6yzcIuKeuG7vU0e4T4mT6Vscc657oCfUE5kbJR7KaHgc4q9CSOWB9tgU7
	oZ061X5FA/iwZSbhRX9q7esPHegp5FU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=UomrPyVX;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=Rz+8GEQg;
	spf=pass (imf11.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6245SS221072422
	for <linux-mm@kvack.org>; Wed, 4 Mar 2026 08:44:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=A4hVQa4Ck15Gxh0A8DRKmYnt
	2BE+A/oq+1oyfVx6EaY=; b=UomrPyVX6Vj4jQd4L8JKq8WdlHJbzwgN5kLFyUyb
	O4aj8QK9JigxGnLhJKpV5nX0udO4u9YnLWT/9MXQQg1eAcDIicjDy1vKuZLien/d
	qbjKCndKoTGoqxEQLvfulbwLf6fASgpdXcJZ3krVrgtabQg2doE/qnKFwcVWJugo
	53PeEKsxBlLzI4cOdg5zRziUUULuG1rozQfVfF1WBD5HEOIzU3TkbSCGYnrGRVyX
	xOOGgCZNE94hfQxkEyBf0a3PIxZCJF7Dhv57Qt/sIPjLshN1RjVOyAspJcSa+Tl+
	D5GlBO0U7GgzrROeN5jS51sEeGbAiWtYDd+uMPxuzLkAUA==
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cpcxfgxa4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 04 Mar 2026 08:44:08 +0000 (GMT)
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-7d4d6edec7eso47377704a34.1
        for <linux-mm@kvack.org>; Wed, 04 Mar 2026 00:44:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772613848; x=1773218648; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=A4hVQa4Ck15Gxh0A8DRKmYnt2BE+A/oq+1oyfVx6EaY=;
        b=Rz+8GEQgeiuC1QHY5RJbefSJd0A1MD+PjcRkkFa5zhNK6PMSi1WShyrxmW0/vm1TLB
         ygYjKIH4uBV6jMXG8g68+tRbyUCQhxV6Shu4wW+M51Wt6b+nKwD3K6Lo8nz/JUTgamsu
         q00P3wIQv+g9GgguPOVMYwmgHZJjewMtXwipU9/kuIwck7qFCGxU4tzqWl4mw9UGM4+R
         HxKMyKs2A7KQa0oYqGRLk2DusmTV5Wyh0NrZrD5FFIG6rBQfukzraByb8r9HzVjd4vzE
         DVM93MfaF2Q4E90CqOymeHAPtm1qX11P2VVakosAsn+F6H+vxRye4lX2YI3wu3NbtEgJ
         lACQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772613848; x=1773218648;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A4hVQa4Ck15Gxh0A8DRKmYnt2BE+A/oq+1oyfVx6EaY=;
        b=mBvwqV6tPmCgX4vySJGfOoMKUuAPTlSM1cVJMcAGr/W+L8u6zcAY2XPrNkpnJ4cM9w
         WQrykxmcSrkKLWSfaz10pb1nV3IF3fYTtwV0oIXG7M0OrPFH6SHLAX2iAZVf+xLPBUMk
         iuKuG3f/JTjRaT/CxO8og3EEb3VkegRGUSFVWH0k9U9N4fNuAQs8QYLKn9s1t/bvHUHT
         RDpdef7wlJHMpzVII6hKDfkaVasBArhK78LgrEFkOZnlieRZnQM+QU1AJcZkEyFGtZKP
         JkfeYG1LdCQBFiFXLYFIArsLaP7suqNAG/9MsI4TrJYxFy0LFMoptqNFO6irCQS7U+oY
         Gg4A==
X-Forwarded-Encrypted: i=1; AJvYcCUGETP+zekxarlirLViv6pNFsKGhtRjmYhaVLm0Eal5aef/LTV7RWAdChyN4wnvCfBosUElPp1s9A==@kvack.org
X-Gm-Message-State: AOJu0YyfAtyrA/M+uDprHVcFjPiIJ3PNZB/2fyrMqLlSPuT6ehd3z1+c
	OF4MYPNiv8d7fzgJKBlid4LojKQWYjSu7Bnd57X/wrKayyAkq74jsA50HaE7dYqEjehxuf3al+d
	3OMu22VNu4ILM+U5eGno4NXaz0Luz84REKxNarDJutQofxFY5/FVPPw==
X-Gm-Gg: ATEYQzx1l/0JKjlO/sYKP2TsrXU0DhYfGlMVGaaAJTYiwxCZydHdVmJNYTpWipfQr4V
	HZCwedb15nlIOKCQwnOV3f9XkNVPZL71DUyirGavl3fQu1sEkugM7v+21yOkzX2hhEBRuEHRzT0
	s0b0aq9LICSb1A+McJ2abYglf+/q9m+mrYAvs2Bm8PUFTzp6a5uMqnB95hOd3WhjwGQ+W53a0Pk
	A2AKB8IKaBs76yZ2gKXq69KXnPmVTLvsmb9sWi88MuLnJ/kxvPS+yPCXYDTmmOmWRW+CGwnYtpV
	F/zz4ICfnNMbeXjbbQqzhtU0iVZG5+0DmbzxlYCfFT8Ke+mCWwk/rLvjVTM2yYOvkqdeaKOj+k5
	ChkH5tpIwh9pMKXFuqYreSqcJDZ7lNaJ52ewg5PLP0Bfj3V9O117lo5dX6295F4gShk5Jd57NOQ
	hsPuvQ
X-Received: by 2002:a05:6830:3901:b0:7d4:96c3:3f8b with SMTP id 46e09a7af769-7d6c7f5d9c6mr844971a34.8.1772613848092;
        Wed, 04 Mar 2026 00:44:08 -0800 (PST)
X-Received: by 2002:a05:6830:3901:b0:7d4:96c3:3f8b with SMTP id 46e09a7af769-7d6c7f5d9c6mr844945a34.8.1772613847716;
        Wed, 04 Mar 2026 00:44:07 -0800 (PST)
Received: from hu-ysakshit-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d586626869sm14945895a34.16.2026.03.04.00.44.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2026 00:44:07 -0800 (PST)
Date: Wed, 4 Mar 2026 00:44:04 -0800
From: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: mst@redhat.com, kys@microsoft.com, haiyangz@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, longli@microsoft.com,
        jasowang@redhat.com, xuanzhuo@linux.alibaba.com, eperezma@redhat.com,
        akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
        Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, jackmanb@google.com,
        hannes@cmpxchg.org, ziy@nvidia.com, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
        linux-mm@kvack.org
Subject: Re: [PATCH v4 5/5] mm/page_reporting: change page_reporting_order to
 PAGE_REPORTING_ORDER_UNSPECIFIED
Message-ID: <aafw1FO6pFe8p5mm@hu-ysakshit-lv.qualcomm.com>
References: <20260303113032.3008371-1-yuvraj.sakshith@oss.qualcomm.com>
 <20260303113032.3008371-6-yuvraj.sakshith@oss.qualcomm.com>
 <849233d2-9d40-4d67-965d-262153d15d07@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <849233d2-9d40-4d67-965d-262153d15d07@kernel.org>
X-Proofpoint-ORIG-GUID: qGwb0zOuhCX8mdqZsKCT_kNyII5P3S21
X-Authority-Analysis: v=2.4 cv=R4gO2NRX c=1 sm=1 tr=0 ts=69a7f0d8 cx=c_pps
 a=OI0sxtj7PyCX9F1bxD/puw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=kj9zAlcOel0A:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=ciUuy_i2Sbo4mXWE2mcA:9 a=CjuIK1q_8ugA:10
 a=PG_jTqMH23MA:10 a=Z1Yy7GAxqfX1iEi80vsk:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA0MDA2NiBTYWx0ZWRfX9pzipzdVtaey
 Yyx4w1+/p4Pf9ie1asN4Khmxr6ddXxLJ4YIkpc2ZHVxjMqszJie5OKAyLzZK7JSCkj6PW+mF5as
 H4ZSVcmAHDFPZwa1RR9pFTI3IK8PSLgi/45Q742obrsn/wzoDFLnrymIXC5MAsEw3EBmbZ18W87
 i3RcUVlfB4Ipdvvj0hsTKlGvW2UbZR0LXsSmGF6GWMJgg2OR7SpEphPN9WBuxFk+RqIWUe9qxeE
 rvJZVLzV4fubpu0jZi+XNHIpOiwenoREFOVmqV4Jlj+TtSaaOEbojIJd6W2/jXIyIls86Haiqs7
 DfvnBMtH1fJb/kmQ6IOyEoDj/0A9Q/daZlwDDHDZK+2u92w7eHtfrRe7KkBTbWF7FmPYYEtwGEH
 suXsgxfxRXjx1mi476S5U1NaRwrwJSfdKES5KU8ShfSeCjoLcTKq4F7PmloTevDT3nqGQ3po0eF
 xhLusVoRdmVEyCkaNJQ==
X-Proofpoint-GUID: qGwb0zOuhCX8mdqZsKCT_kNyII5P3S21
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-04_04,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 priorityscore=1501 clxscore=1015 phishscore=0 bulkscore=0
 lowpriorityscore=0 impostorscore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603040066
X-Rspam-User: 
X-Stat-Signature: pbigsf47mpqazqrwce3c7fk68f37fock
X-Rspamd-Queue-Id: 0BB024000E
X-Rspamd-Server: rspam03
X-HE-Tag: 1772613849-427446
X-HE-Meta: U2FsdGVkX1/HJ1XoCIFmqCK96rave0JWGzymdRsVSXYqRtF7G4IXqCA364lS3uvZ/uyHccwSpck6wdHzgoOMDBW3NRwFOiC0ttga3ivHE6yo9ZrZTR061YMDLhFdu8Ch+j+0tUuCpyBYzqbDScmEqjKkEhKJ6bsCsYNCP0con8kf9ETqqOZjTB33ptYEkaddoZeCMqCzBywnpLqlJbfDT/OCmFvRv2HI+gI3cAj0rUqeQzIR6bHfQrJdaUSgqCpWN+uCLCAIrnV0lncJB/hkh+zc5azM8mfPqZEz7ZZO2qeIR4yP8SFO7Ojt9CWD2j1U64Kmoyx/2kbdeN2TLFolyWeGH1g5aOTCVrzvZbamuVvvUZ9Gqoy/pvgEsFqRytb226CtrsRi+Webgg7OQwBCkF/c/3bu5p1mlIk7S4QmIaaTm6Q3PcaKTQUDRBSxEx6gfEKUeSSaokRw8/nqhiJ178QdiUY9BEQIrPgafa4WkoOR0ca2KkC3S/bD+XcQRe/9ucQnp273amfYwYgti3HntG/hE7+s/ceufbs1FMFU9rm4PPfaAC95mGjFMyZprTV654y3z4AgPPaOUE9qbvbi+9vsOxNzqU2jp9/dRo5X5cr2D8PMcxlmLhf3vWxWdjdLKKS27zAPpsiR6pNtphW9MXEgffP0PHlSOiZuI8FxJl7ZJ8sKRwLmw5FGRtQOYcTWsTr790KvuZozRFUni6vp+GDBWQtTlq45/HPSDFtpudg1k6AlEGNgwxVWnunus+gZR2GvMSKR960qzVaD2xQxcbGRU1dWDf4bOCx2D981fBI3zQGj2QO9SZL2hkdZPnnH13nNjJBxRn3l4NFjew0+cUbgMAzgNBPp74vhTJ6ysshdbfimkVurOmrS4kWvRUutNWAi0VOXlIldrlrNIs3yJ6IHXU1WRaX9BA0c5b3OavzLE2cpuPTfGbD3AfNKw3+qj5mNNdr6A6LW2EfTddI
 V0uJIAjJ
 OrdQiKY0+NiIx8PhE90G4rcP48VmY5qP5IRcrRgdYC+GsGmk9suvAHiVAe5jrG8N7YkbTenXyq395ZhZfYl4ZKTKhncyHo169TvGGThR9BCgfHx4LkYjLPM3bFBrdSRd3MJ/voFQwWFZ6chrnyIzSe2hNBK9wSNcTOEywzhL5B7I3Ujh/vQ4hemJXAEF1K63Sl/QJx1NYT7tzev709oevyaaaDpDK/Vxhw50Y0GcAaRfalICrm8cpZ/O03z6kjUfx3AtdSRiJhuYah8uQY2Q0e0qA41oOCsH/00LoZobyB1UZVR8dnJwKKBJ/GXutYIvE/xZpUo+v3oc2zuL0euaixjf4mmJ9j6u7Kljx1V2+mjv2OEgkGEDVKVfXazMjmLxpEkP5uAYeqpqXVEyPZlzZxL5xXI5tMk0GLxIc7YIk62+hy1/ZXuUv9vUZzARVxwO5faW+NRa9WwfhdWGFoAFWLTIkN52+FkFy0Pez3n6B25iqqK5a9RDDTjfaHMM/jLfZYT/R9Q4wtR/jcPQ5/H0+vkR/BAEOmGdII1AEuO3UhDoerHnSHB3u4aZG7Z0a6NpTY6Nb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 03, 2026 at 03:59:10PM +0100, David Hildenbrand (Arm) wrote:
> On 3/3/26 12:30, Yuvraj Sakshith wrote:
> > Signed-off-by: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Sweet. Thanks for the review, David.

Yuvraj

