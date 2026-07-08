Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B5CCC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 18:53:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 195E16B0088; Wed,  8 Jul 2026 14:53:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11FF16B008A; Wed,  8 Jul 2026 14:53:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB57C6B008C; Wed,  8 Jul 2026 14:53:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B7ECF6B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:53:37 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3E3FF402A5
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 18:53:37 +0000 (UTC)
X-FDA: 84966508074.03.E98860B
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf12.hostedemail.com (Postfix) with ESMTP id D322240006
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 18:53:34 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=Pzn6zAx3;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=hAE5wWkR;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf12.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783536814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MDd5hUGl91pvH2nEiZvHsBpBwd3Dg/kjAQn4WJRYcLM=;
	b=ESxhbyoj+q/TtoSA+jEUj33HYJ9mQbKIZeTqJ/PKAR4eqr5wNQ7dLw1rB5kryLP/w5TgwW
	11rM90ZbuII/mInn3gDtonl/NDfqiX2DKM8+4xTqOoRKRTbj4azTH2LVwFhtfW3YxPqejL
	XNucPwTtOhQFSjgvwbz2W7596NwggTY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=Pzn6zAx3;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=hAE5wWkR;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf12.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783536814;
	b=CYHCr47XcSUypeWbIzWiCZiAZjV5joUeBTrCBOfvCR72VctBzi1TM3B1jSDTmFLqWz8KtS
	nK90QuXYRx/0xY3j7cyCsl23/h5gxfNHNAgXvDdykqmcnxCByPDv1qOy8rYxerbnJWPYaZ
	w7E8MivOT+DZXhPsBbD0XqXd5kcMRvg=
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 668GLFlM3304954
	for <linux-mm@kvack.org>; Wed, 8 Jul 2026 18:53:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=MDd5hUGl91pvH2nEiZvHsBpB
	wd3Dg/kjAQn4WJRYcLM=; b=Pzn6zAx32z/ioGd9q+dGf95FcLUV361Rgr8snpUZ
	AXUDDl8H4xBi27nUisuSsrKlBbAi3yVvVDWUqWk/4g8P33d5Y8cMcEHjM4mV3Ysj
	6wT45Y93lvgq3qtKD7QyBK6mnKSrURK5EpCYWmg7wYzzObkS8AKf9OXxS0zj3BMw
	0ymhVUdZYzWMpUnvTk8zUTLEUswZYyWtrStGD5jBqwV+fLXiWhr2xcdYbkhJAH4J
	DxVCwO50bJCFx8Gt2O39TOlXL2U5msYKt9ljvHRk8e/FB8RC3p25oKuOT4+39SUW
	fB8X6I6jfIVK9oswSOlBE7R+j/w2Gcgnb94+Au3SymeIhw==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f9rq311n4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 08 Jul 2026 18:53:33 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2ccf43f7a99so1881405ad.2
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 11:53:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783536813; x=1784141613; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MDd5hUGl91pvH2nEiZvHsBpBwd3Dg/kjAQn4WJRYcLM=;
        b=hAE5wWkR+75gRUdjrQ8xzh9w3znPoMR2WpBzFooLhMg4/Lz3sskF0IoZ7QWcMSxLfe
         kj7GuOoh67oojpMLqEORSV6yA9BTsoEhmjrgSUFTaVEtAZqEaNIbtcXdaJMZ/9PVKAfh
         dFdmRO91TkGhe1ktDmP0GFh/Z/0sAtxprf2nCNE21MxV9WhrLT7wFiy6HTW+clBTGVfX
         Ys7XeadiLDJjHX9ZkNbWQuhtOew21ccv4BWp24Pm6//Qqh2LS7KjL4k+av6oI4Qriyc5
         YG9W+rVyzfJLp7E1fg6h56nBGnVriKmVHuHp65Fv7o549snQSqpKcDS5MTdPXn73xFN9
         YA4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783536813; x=1784141613;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MDd5hUGl91pvH2nEiZvHsBpBwd3Dg/kjAQn4WJRYcLM=;
        b=J3vtAp5SRju57w8WJkYaM1kgtonoLJWEbxMGVVWU3HjqsM4Bt58sNjOLwggLHxK0YM
         5HBNC2Kfi5Z9/ezDr/xH48MM+SB+Cfuh9w0mbaZ4ZSILrvNtyzJrRMOGwS+p4AbIi1xM
         jWwluA5hXqXTqL07Me9sjcsvNUn+E2VEIXCViKh1ru5NQ+UTurkfo9n1TStTdPQ2oBY3
         ksI49vaQfUbswT/xSdqRJjBctgulEBxXAZWIngBtCDBR2RpHAZFtkD8opfCtSjzngFUt
         j1B4hrSLQ5zyfDQn95Bw3ukcHjYtOUCsAcRt5/Px7vI2QrjwA9O6gdUfbQxRW5a5U1FZ
         U6kQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr5JqyfLktVBbdwGlEMZTHdea8XbA4e2bmOERaO/x5Rn9RL7+Js7QmCWfY0MasVXc/p0DANXQ6JkA==@kvack.org
X-Gm-Message-State: AOJu0YxQ2bk+uff0+uvwiZAmSTO7d3C1c2+16w1Ahi9DPCVjXLtVrnF7
	YIywwH3Ar9lzV9+IN8o+N89B55y1LsEP6Rj5eTw5wOEhAflorawhrpFwqMqG6zH3w1Qgt2PFxHI
	AYjevS9zCWQBGwf0rrJCuGdsf/94f+yQSBBamigiMlmKLho+u6JCwCw==
X-Gm-Gg: AfdE7clRIM+vlN3xj4B2qeoqGh9DhhiSzZoP1cxMg5y0kjPE4bQ/ArIdEbmHMDDBElB
	vbMchTNTA7b1jtNPgoXdk/6Kmbv9OZvzZkkPOx6Akq9NFEb3AGXSXq4ITWQIwCU99cmvGsNs36q
	tPV0AXYN2UN2PvFcPu5NUE0hBI3kB8mntArXWZ/n1M1mj/LjEqfhV4MEso5tRZ/5d8skjIjndW7
	unIunGNScq8BB4rQfGLyhTFFXQzlhoVVrs6IKtUYE2u31xHnqHk2bA1vEWJIUPxvaQ/HMtlHmic
	MexnRogIvdN1KBrdS6zg77eubqTXaQoolDm///o3ez0zwAyhVun5/m8LhzVv8AvRAz30ltQgv/h
	js/xy6arYzc5b45KmFjlqKIfqk7nHx+yHFlRBHw==
X-Received: by 2002:a17:90b:17d0:b0:382:1aaf:4bab with SMTP id 98e67ed59e1d1-389416e7dbdmr3591584a91.27.1783536812849;
        Wed, 08 Jul 2026 11:53:32 -0700 (PDT)
X-Received: by 2002:a17:90b:17d0:b0:382:1aaf:4bab with SMTP id 98e67ed59e1d1-389416e7dbdmr3591525a91.27.1783536812170;
        Wed, 08 Jul 2026 11:53:32 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3117483941csm23706217eec.7.2026.07.08.11.53.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 11:53:31 -0700 (PDT)
Date: Thu, 9 Jul 2026 00:23:13 +0530
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
        Eugen Hristev <ehristev@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@gentwo.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Anna-Maria Behnsen <anna-maria@linutronix.de>,
        Frederic Weisbecker <frederic@kernel.org>,
        John Stultz <jstultz@google.com>, Stephen Boyd <sboyd@kernel.org>,
        Kees Cook <kees@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
        Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
        K Prateek Nayak <kprateek.nayak@amd.com>,
        David Hildenbrand <david@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Brendan Jackman <jackmanb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
        Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>, Petr Mladek <pmladek@suse.com>,
        John Ogness <john.ogness@linutronix.de>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Konrad Dybcio <konradybcio@kernel.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Saravana Kannan <saravanak@kernel.org>, workflows@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-mm@kvack.org,
        linux-arm-msm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v3 21/26] printk: Register information into meminspect
Message-ID: <20260708185313.2fj7vltdoevflu7i@hu-mojha-hyd.qualcomm.com>
References: <20260708-meminspect-v3-v3-0-7aa5a0a74d5c@oss.qualcomm.com>
 <20260708-meminspect-v3-v3-21-7aa5a0a74d5c@oss.qualcomm.com>
 <ak4Cr5GEMdo8xWqu@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak4Cr5GEMdo8xWqu@lucifer>
X-Proofpoint-ORIG-GUID: GhbZ31TnbjT2Uw3g5Wb7OUITBV83bzxE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA4MDE4NSBTYWx0ZWRfX65Z12t3WTc+p
 IfOFmhkm8kcPWDpWgn3Efc2I2ZNCQJ37ozXTHFECktCZ3JJrJkfWx70G89iT3ekvC8fLPd6Mjjw
 WtJ/NVrB+be2Cupl0o4Wm3vpy1rlO85ZNHTyC34vCP2NTFwKdABA1YOdZx0ejF9pTELMwwvdTWx
 yZf9oVoOs10neVe+srtevA144vySvrNgkDN52pioiHerBfyYdOZo2wGntBVFPZSZi6y0tzpnfxh
 AIgImuhyDNPD2R/CTgeflvJPFUZtfD4D0zA9Mb4qVzUECJ17XtSiaFIeJ7jCpQhp0p9P3i1x6p1
 intqMi4Wfva91dUBT1CdC7iataZQuFrLUd+j+Yg+z5HF6nDiBYxBOOsnAZt5fZ+xC8UMUy6fIbe
 HjXAQsQEceDcLN0b0qYhA2ZMultKM2VB5sUFXi8ALIOzGo0HvUVL0NvmLAM3fRY+P8HmEEtWacx
 tlhZKO3Fp/XyjePOsyQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA4MDE4NSBTYWx0ZWRfX6HCz+eVfyHeT
 Nn64PfNUHyvjS2q4uCP7zdLQJxa4IUbfmc4GiG+AHZZnCzh187SwhoRIfyrrLji136tjnhheDpa
 xpQ1z7yGM4Rs4JUyh5Pf+KJOrdf6i+A=
X-Authority-Analysis: v=2.4 cv=PYPPQChd c=1 sm=1 tr=0 ts=6a4e9cad cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=kj9zAlcOel0A:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=iox4zFpeAAAA:8 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=Oescfv6KCf7l1tfy-NUA:9
 a=CjuIK1q_8ugA:10 a=uG9DUKGECoFWVXl0Dc02:22 a=WzC6qhA0u3u7Ye7llzcV:22
 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-GUID: GhbZ31TnbjT2Uw3g5Wb7OUITBV83bzxE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-08_03,2026-07-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 impostorscore=0
 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607080185
X-Rspamd-Queue-Id: D322240006
X-Stat-Signature: ef7n4sc53gc9bqi58aruhxcbrhefyh1w
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783536814-334541
X-HE-Meta: U2FsdGVkX18Z8NJGW90omFm4cc2hZoidRJ3LhgUSRbuKfmncqN4tkwvDwm3+OLTundpF53RSeAqBsK6vsy/u8TYZU4l1VFmoHH1dbzzGWXCcSYuBNyRmre1OYkiabheS8a/i4JrK7NSLBLW6+t3PxX4CwInNfsT1pGlW95HmxU8FDMDqCfiaXK8fY1kTsuapJXfO4yaUE2n9NR5s5y3c9l5sQIBn8k5EWgeipj36dzuMf3Qk8fxD60HH4B3YxcAz3sJPQ5f+gntYWU0TOtRMDtZR9WpqJWyRdKDW/3YwL6rRKoXpab/elPztB2UilYotBwBGAlZ12t1ccPjRFCh55OLLitFTYYkCssnZNQU90OJFgMM/ywVNb3ImgfY4HZ/CLeWxIdZdRbMuEFq/Z1auT90AH27cwlzBXg61yY2dTAW09BomErhy/OkEc95tPzwN7ANrZ3cOV1AsJ798slLmf5UNrw+fzJub4rsi2S8jR9fRvNQIY0sgJUIWXW9jA2XRHtxX9BCmH/PJIpPA42/cNFXcsHd1mxPs2mVJJ8qBT08VPBaX8aebzge4Y90x3T9M28AZ9QGwSM2fYiHXkiywrBdNqc3ppaeqO5Fo5K9HP77eSMLvvjwlxr0mWFDzYkI4oY7O5Z1VaDOAhLqz7T9z0UeEf5JTJFdX5bTIZfSA2sUui7ZpmPhBUwh5PaXPJjg8bDAyHBB2Fr/wUZsR3Fep5Il0dkgjoqdC8mE6nlHODGNW+ZWKn3kEC/KXH5MppAVtubBP07StUeU6IRrYd6k/JLo3hrrpI8bc8IOOHdgae5sr13cNlHKKSYqVDKESl6q2atCT0nKC1qzKK47yBvQcn+Lavk6ArvD6b4D5mXV/D8tAj2yrEN7YwPMy8fF0slBhC+a5bC9sW/8WcykyLaoCeXZewXPlrAqfwOLr1147Vf2iLbH+KhakD4xrZWV/yp+AZ0CW3rNF+p3NUv/gJpa
 YKUtsVCR
 zIsTmNRasnrqPpRfQV33Cxawa3i/bbXpyS4psauQ+qph/6aVDYFEtlAr0Akq6Z/Hs1hiViHKkohsRtM5GBU0vqhfD4hR+anp9n2NW+yw5w3znsnZDRCcN6U4GR06UF74cQxDVd6HN5TAnP8nv6Bgn8ngIEU+DD7s45CCkWMXPIlXnPByGQ3jg1WMAegNihM6CYlwMRbtxFva7FkmDhquk7n2wWxqHc4tnpQkYSzVW1m4PXXN0tN1r6BYel3lyHAp8eya6vlNngxQM6+tAJvrONel1i00QZ9/Abbtp+zK5asOkElX5g+SHuRr0+8onbzfFf9nAqxW0qXwwMlqaSsGJQ1vgG5tOW4izmYnw7aYXEV1utqWlHHAvN0zAUDXDzTCXorbQn8m9A1JIZQv8U2wquNBa88UA1OTbp/NZwxhxEl3Y9MddsIErsES3A6hVsoL7yZos5uTotKunJynwNMdVENeuI0Yop4YA4vV+mnuEmPQkgt/h4431LkD++ma1iVotzI5inQ/Tx59ptbHCY3LhKD9ZyhSK5XV54SJoIvrA2eSqGMwCqwf44L/uJ/MuzKszBYYmqiipa9cm2MI7PDv2MrZOW8s3i/1ivSoFTZH3ZoYzHUbUNJUA2YsQaLOWjVgtLXG6iidQuB5PbeJwXTTquGW3Ww3ImpDA+drdfVLiF87n5sIBL7EwOTjXW5MNil4IQccH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 08, 2026 at 08:59:26AM +0100, Lorenzo Stoakes wrote:
> On Wed, Jul 08, 2026 at 11:02:00AM +0530, Mukesh Ojha wrote:
> > Annotate vital static, dynamic information into meminspect for debugging
> >
> > Static:
> >  - prb_descs
> >  - prb_infos
> >  - prb
> >  - prb_data
> >  - clear_seq
> >  - printk_rb_static
> >  - printk_rb_dynamic
> >
> > Dynamic:
> >  - new_descs
> >  - new_infos
> >  - new_log_buf
> >
> > meminspect uses a different API to annotate variables for inspection,
> > and information about these variables is stored in the inspection table.
> 
> This commit message is a mess again. You're writing what the code does, not why,
> you mention separate API but not which or why.
> 
> It's useless basically, and it's weird to list arbitrary fields like this.
> 
> Always think 'what would be useful to reviewers and people coming back to this
> patch in debug/development'.
> 
> If it just says what the code says it's useless. Put what's NOT there.

Ack., will reword this.

> 
> >
> > Reviewed-by: Petr Mladek <pmladek@suse.com>
> > Co-developed-by: Eugen Hristev <eugen.hristev@linaro.org>
> > Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
> > Reviewed-by: John Ogness <john.ogness@linutronix.de>
> > Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
> > ---
> >  kernel/printk/printk.c | 12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> >
> > diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> > index 2fe9a963c823..f7f32c09b9b8 100644
> > --- a/kernel/printk/printk.c
> > +++ b/kernel/printk/printk.c
> > @@ -49,6 +49,7 @@
> >  #include <linux/sched/debug.h>
> >  #include <linux/sched/task_stack.h>
> >  #include <linux/panic.h>
> > +#include <linux/meminspect.h>
> >
> >  #include <linux/uaccess.h>
> >  #include <asm/sections.h>
> > @@ -518,10 +519,17 @@ static u32 log_buf_len = __LOG_BUF_LEN;
> >  #endif
> >  _DEFINE_PRINTKRB(printk_rb_static, CONFIG_LOG_BUF_SHIFT - PRB_AVGBITS,
> >  		 PRB_AVGBITS, &__log_buf[0]);
> > +MEMINSPECT_NAMED_ENTRY(prb_descs, _printk_rb_static_descs);
> > +MEMINSPECT_NAMED_ENTRY(prb_infos, _printk_rb_static_infos);
> > +MEMINSPECT_NAMED_ENTRY(prb_data, __log_buf);
> > +MEMINSPECT_SIMPLE_ENTRY(printk_rb_static);
> >
> >  static struct printk_ringbuffer printk_rb_dynamic;
> > +MEMINSPECT_SIMPLE_ENTRY(printk_rb_dynamic);
> >
> >  struct printk_ringbuffer *prb = &printk_rb_static;
> > +MEMINSPECT_SIMPLE_ENTRY(prb);
> > +MEMINSPECT_SIMPLE_ENTRY(clear_seq);
> >
> >  /*
> >   * We cannot access per-CPU data (e.g. per-CPU flush irq_work) before
> > @@ -1238,6 +1246,10 @@ void __init setup_log_buf(int early)
> >
> >  	local_irq_restore(flags);
> >
> > +	meminspect_lock_register_va(new_log_buf, new_log_buf_len);
> > +	meminspect_lock_register_va(new_descs, new_descs_size);
> > +	meminspect_lock_register_va(new_infos, new_infos_size);
> > +
> >  	/*
> >  	 * Copy any remaining messages that might have appeared from
> >  	 * NMI context after copying but before switching to the
> >
> > --
> > 2.53.0
> >
> 
> Overall exposing live dynamic printk information to drivers seems unwise, but
> not quite as insane as some of the other stuff thus exposed...

Thanks, this is minimal information needed to collect dmesg from
crash-utility in --minimal mode.

> 
> Thanks, Lorenzo

-- 
-Mukesh Ojha

