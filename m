Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51547F46450
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 11:12:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7F2A6B01AA; Mon, 16 Mar 2026 07:12:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B298D6B01AE; Mon, 16 Mar 2026 07:12:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D6926B01B1; Mon, 16 Mar 2026 07:12:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 884216B01AA
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 07:12:51 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1EC74139305
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 11:12:51 +0000 (UTC)
X-FDA: 84551663742.03.764C16A
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id DBB3318000B
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 11:12:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=CDwxuEaj;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=R4WzMRak;
	spf=pass (imf16.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773659569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w5/6niFrt5V7BFvAJhjkDkCnF0DdVxA73yi+xL5S+XY=;
	b=ZjTKws2qf8gxTepHK+5NlTLvM+WkOHz2PxXJHTqiK7H9na8hCYA0ejXgByH5l4ue480N97
	KrRSoQaqtrF0+FYOvsThSIU44ATc03aQDytMbd2s+Zo4Q7gt+Z3rkvd/XJlw+eZyfBYtBp
	6zk+WjWnH84mxBOyV3NB8XpoBVZKROk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=CDwxuEaj;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=R4WzMRak;
	spf=pass (imf16.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773659569; a=rsa-sha256;
	cv=none;
	b=L460R9krpRhvP7cqphUrmULyRNoEcje7bXmkaWyumSH2TidWllyQGAcbTQ9nCIpJ2CfQgP
	ryjrgRKWSlpaq56HlvDFJlVJ5pth9JQEK8/Ot7hD7G+uv4+C8zH5G4gSKTwmKuL126J0E5
	UMqRy/MqH4b3o4f0DENEpUOEO4ek9W8=
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62G658aO2673271
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 11:12:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=w5/6niFrt5V7BFvAJhjkDkCn
	F0DdVxA73yi+xL5S+XY=; b=CDwxuEajblCQa73IHjI1KRv+qjwCyoVNureInyV6
	3AO1IsWyKP90P8HLWYMsgU5Gow0JYKUA18JfRh4ZlS44jXiwnKrqfaDyJdZ4dxWb
	vaKLNySyjdPUqlLlxllawE6p29LtbZubiBLghUL3AFK/Z+5IplkxvtU0UuU5l2ys
	G7xnUX+BaMSr7Qbho62ZhEvtS42LwJGFd4ksqW0xE/txBvTeFn24PZZJi8HMD2WD
	nAQQOra67cDBT3Vnfc57Q4RlHG9uxUl6qAKSJxwFW45t6SEIYXH36w4oMA7Q1YMM
	keFH4ckLoQgz1jMGYS5AnhgjfLH+UsO7//1wxanVlDlyUg==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cw03xndt0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 11:12:47 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2adc527eaf5so36170955ad.0
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 04:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773659567; x=1774264367; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=w5/6niFrt5V7BFvAJhjkDkCnF0DdVxA73yi+xL5S+XY=;
        b=R4WzMRakUfqPF51Lu0QbN93bYGuk0MO81SrbVl4CINa9U5C2RoNizDgLM4V6AFoIsn
         O1Lfh+2YmSgk6fuSupnBJU1MtDzkKlhfbHMSiaVZ1PM6CKwNIINKlys6P9MaX1yWSKSj
         zhQ1EmHmEfkS8YlGoR1ydjzpLYODy0uRSNESWSI3BBnJnbvi1iUPDtNXhNdszVPLXdSq
         QCr5uv+YvGk2vM1A3t2SMw1knUilDFBYsIStUGlVJSu3HFAl82K3dyy+iu2oZceMy2L7
         KP9DdkpX3+ZCc8mXBgdEMLqmvF+2IdRSoqFPNbG6bmNVrIHLOflbk27MayeH6E6V79Zr
         OhvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773659567; x=1774264367;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w5/6niFrt5V7BFvAJhjkDkCnF0DdVxA73yi+xL5S+XY=;
        b=BcK18/1w0JOqfcCqMwf2NNKcMxW6Zj1hUS83f7aS8+f0dHPeWmOgEf3f8wQ2qiHDmR
         XwacmxX0/GfDFS/FHPyLDDNaic0pLniMuAU4icm4PehGCPHFcJ2m9/MQb0IoNoRjZhmb
         KU9HsBah5AoSwQE1bnGbhfsCZ3TBbcaJXotkkhugyL54DYRlACTWbiyfae637wal3s2+
         PB6wHHPZwViug641QviDkWjNY6ROYjUpcYJtvge+sK4a9n076QSJg9xLokd6jUjBaneQ
         SpuvAHI0Z1AMtGwpFGDwQSaemU7FINLH3XdzRzQtB8Son/t61c1qkb+fZcLqOrkrdq/c
         fg7w==
X-Forwarded-Encrypted: i=1; AJvYcCWeiMw9pO3dHysA8bIOtLmw4eH6SPKFyeP5G0L7DuCT+yBUr5vXc8edPjLmOJXfS2JMxxTxF/PG+g==@kvack.org
X-Gm-Message-State: AOJu0YyUZw9IPaXXN1mUaDfP54j+MV3smwzAjNGyOt65bfWavEyoXH4/
	oiqn0QGmRG2mx7x16ipjRi6VNgp3067owfSxj9LchG1ydCTOork4zRMDbkqk8cbq/XtZb7Pntam
	dsh9xRs+s1qGJz4fOphaUpWilOMRfts+drbCmPYpNy4wRaCssJv9C0Q==
X-Gm-Gg: ATEYQzwzreLQShMOq/YKeeCQM9Ixg4sH6jKg3lrNNmoy5jwckmoW4LhJ2wsQxied9Nd
	mpcajxMWDY+/RRKkcvGxZT4lb0psyHKjzZcU5DyPLls9bAH7Vy/MSRrja1h4p+y7i3rqjIBdkiX
	Iz6iaWvZsPQqYwnxuDYQQNWLnKAsMj/enyguLtlWH8wSFf82AX+cL8GXDBtn2hpBE5F040NtIZY
	GRFJ2eVXTvWm0TrfchV4SjXd3dpxyQzB3neBg8Cwr8YCSsJ/dTxSlQc8vJQHfkkm7ClJJlTCBtp
	UsolJ6nOOCwki1bdOhjeeuSR2JRuxa05Kj3/vm6drApXm6kxTXMIp3ivqgQCa6N7W7v/3/Owx6q
	VRgPoXJas0diPOdr0iBLAAqFP2gI+ytI3d0B1ZdGlt02LZypn
X-Received: by 2002:a17:902:e94d:b0:2b0:5fa5:a68c with SMTP id d9443c01a7336-2b05fa5a811mr9896275ad.9.1773659566702;
        Mon, 16 Mar 2026 04:12:46 -0700 (PDT)
X-Received: by 2002:a17:902:e94d:b0:2b0:5fa5:a68c with SMTP id d9443c01a7336-2b05fa5a811mr9895615ad.9.1773659566145;
        Mon, 16 Mar 2026 04:12:46 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aece7ed753sm133558805ad.45.2026.03.16.04.12.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 04:12:45 -0700 (PDT)
Date: Mon, 16 Mar 2026 16:42:29 +0530
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
        Eugen Hristev <eugen.hristev@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Dennis Zhou <dennis@kernel.org>,
        Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Anna-Maria Behnsen <anna-maria@linutronix.de>,
        Frederic Weisbecker <frederic@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
        Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Kees Cook <kees@kernel.org>, Brendan Jackman <jackmanb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
        Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
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
Subject: Re: [PATCH v2 24/25] dt-bindings: reserved-memory: Add Google Kinfo
 Pixel reserved memory
Message-ID: <20260316111229.q7ip55q5h725owj6@hu-mojha-hyd.qualcomm.com>
References: <20260311-minidump-v2-v2-0-f91cedc6f99e@oss.qualcomm.com>
 <20260311-minidump-v2-v2-24-f91cedc6f99e@oss.qualcomm.com>
 <20260311-light-terrestrial-bison-d9cd97@quoll>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260311-light-terrestrial-bison-d9cd97@quoll>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE2MDA4NSBTYWx0ZWRfX867au+bZwo5K
 ex0p1DyfILgqiAyXHz5Me3rgXCdJGDyLi/rEYnOahB1XKf3qlrzFKUj5tMvyC1aukSduGOQrAds
 aeKJUeKjMfPoLnEm0NkStSCinnNQ58lqs6Oz+G0DNLoNL02hUXUajo0jSUwmTWiid2igEkra/ZY
 yvLNfyPSwgexeVqcpXiQqfwItA9Mhyb2udjHKbG9RQqWJts6FdBemS7MssuMOq8Kkpiz95FO3tV
 aWpMrjQGQZj3OcchvgvTooObJPrTvFSEVorokeAZIqe4t3fbHBi6AQzdT0favsYGn3Z0jh7mYnl
 7/xaaP2jzsGGBcfC2fhUM7PCoTjbV6vbsHEhs7B4wcOlDRdp9Q05fHJ7Sdfh8hkjZHw3E4tyNxE
 JmTDShWPmFqNxnEsubrzoOnOcfSGQiF2Wd7fOcwT7IdRtnUw2GFpJFSWzNCtPqfZmi5DJc12Mr7
 HKQ/bFO5JL2gl24LyzA==
X-Authority-Analysis: v=2.4 cv=YLOSCBGx c=1 sm=1 tr=0 ts=69b7e5af cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=kj9zAlcOel0A:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=gEfo2CItAAAA:8 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=mRjidWuB3r9cVBOPW6MA:9
 a=CjuIK1q_8ugA:10 a=324X-CrmTo6CU4MGRt3R:22 a=sptkURWiP4Gy88Gu7hUp:22
 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-ORIG-GUID: m4mGMjZnD6uVkhMF5pRnDrTYNvElKnSt
X-Proofpoint-GUID: m4mGMjZnD6uVkhMF5pRnDrTYNvElKnSt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-16_04,2026-03-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 clxscore=1015 priorityscore=1501 impostorscore=0
 spamscore=0 malwarescore=0 suspectscore=0 bulkscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603160085
X-Rspamd-Queue-Id: DBB3318000B
X-Rspamd-Server: rspam07
X-Stat-Signature: hqry4i839aece7powy4csegwf8ucpsee
X-Rspam-User: 
X-HE-Tag: 1773659568-380813
X-HE-Meta: U2FsdGVkX18wpW6c0QUwS7NILkmdKSuzGiDkXvfLChkuLUbQOucu612oRunrhLaB4zO1evo0yA3LJIrfE/cTJ/PMjEtHQJxy3PN11Hbh1ZQwy9ABNMDHBi4ZAfJwGpCgix4jI3WgQWGWEVGVWf2C0MzB61Y7Gv/2STA2yUTpYyFgP4wtX9zYZXs2PEifExjmlXYk9WdOUitVJIEoCtpVsr2ZLxeFv+JcQSrh1Ts5wR/UKB7dHOCZaK8w5e9DOigRCDj8Wis6iZUKB/jCQqnrPpWO3gy2WYlwdFAgp7fQdZPcCrRQ0co2/DnU9+KmwMYxiv6540SRanz+BQm/qho3kgt+XkGXaUtSuwiFueTp32or72yQ/o+mUAxesZSudjkyGCtnwy1JLjQH6IStskVcl7nqAzYH8SfBIw7Hlm+kvkHG8Pf7mxaPhuZjHSRR8BdMeeJCs8GLh8H4twynXpnre0mcLwbgWUjWUDJlFwgt7muW6qWa2KsBv5xBSiGRoFQgkS1cI6mrDfKis+MU/w31k/s4p1HSLbV8N3mzc4PiW1WukH0vlgqwvQ3xcZIfLP4AszSUmgtgP30DepcmYpfWFj7ariYLczDY/lRrLE1etNXyBoGBb7V4fLtZPlPUBP9vGhnELpf8gI+m43fMS7tUd+gai8qwe04SVy+kaV/rRfU7W2fLWYPN/nTbP6m5+dx3khMIl9r3fQ8G893u/SH1ke8CNH2OAZgMYQHTjAwnnOn8tOmb6YvrdrKuVjDkRZJXDACRiap3MWigi8L1a8sJDii9tmO2SH8GQ/otlZhGOOIV9CiUnm72r+REcri/KXssNIdPEFQ3ZM5FelT+4riAnuswb2YFpaszyQ3J2EoBhUBwpOFmaFFkzkX349r+x7GkHt1lqyUBTQdms8lj1IbEl21PUPlnFwG0aoaiToO/d1FGRWRdqFhqGvZJPchmCXQcLYSokOuHShMWyPE5hzN
 E3NI6qK1
 A40y4FZBDFcdMO7wPdxP8E1cTg3HU19tbKuwO3QuJGP9FF8yAyDCbrY0OQDNtHgbhjf+hEG6i3hkPLYJaSzEzxWkRnumkg0iYUNFRSCHMMpXFpcUd/nx5+sxttYAVyv/+nmyp14kJ5dBsy3vtJAS3lsuKdyd66enIYdj2GiPVv1ktlhz+xXi327N6e6rJOrTaSqiPFTA2j44ylvjIRKKcBJkdPZxl9gv84uxmCON0SmegfxHcLvhmko0d1oDU/yG6yDHi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 10:05:55AM +0100, Krzysztof Kozlowski wrote:
> On Wed, Mar 11, 2026 at 01:46:08AM +0530, Mukesh Ojha wrote:
> > Add documentation for Google Kinfo Pixel reserved memory area.
> > 
> > Co-developed-by: Eugen Hristev <eugen.hristev@linaro.org>
> > Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
> > Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
> > ---
> >  .../bindings/reserved-memory/google,kinfo.yaml     | 46 ++++++++++++++++++++++
> >  MAINTAINERS                                        |  6 +++
> >  2 files changed, 52 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/reserved-memory/google,kinfo.yaml b/Documentation/devicetree/bindings/reserved-memory/google,kinfo.yaml
> > new file mode 100644
> > index 000000000000..2f964151f0c0
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/reserved-memory/google,kinfo.yaml
> 
> Nothing improved, read previous feedback.

Missed it, will need to fix this as per compatible name..

> 
> > @@ -0,0 +1,46 @@
> > +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/reserved-memory/google,kinfo.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: Google Pixel Kinfo reserved memory
> > +
> > +maintainers:
> > +  - Eugen Hristev <eugen.hristev@linaro.org>
> > +  - Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
> > +
> > +description: |
> 
> Do not need '|' unless you need to preserve formatting.
> 
> > +  This binding represents reserved-memory used to store data for firmware/bootloader
> 
> Nothing improved.

Will reword it.

> 
> > +  on the Pixel platform. The stored data is debugging information of the running
> > +  kernel.
> > +
> > +allOf:
> > +  - $ref: reserved-memory.yaml
> > +
> > +properties:
> > +  compatible:
> > +    const: google,debug-kinfo
> > +
> > +  reg:
> > +    description: page-aligned region of memory containing debugging data of running kernel
> 
> Missing constraints.
> 
> Please wrap code according to the preferred limit expressed in Kernel
> coding style (checkpatch is not a coding style description, but only a
> tool).  However don't wrap blindly (see Kernel coding style).

Sure., will fix this as well.

> 
> Best regards,
> Krzysztof
> 

-- 
-Mukesh Ojha

