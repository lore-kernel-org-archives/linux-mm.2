Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED1B9C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 05:38:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCDD46B00BD; Wed,  8 Jul 2026 01:38:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9EA86B00BF; Wed,  8 Jul 2026 01:38:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8D0C6B00C0; Wed,  8 Jul 2026 01:38:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 90AA86B00BD
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:38:37 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 246D11C8353
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:38:37 +0000 (UTC)
X-FDA: 84964504674.04.7DCFB1D
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf09.hostedemail.com (Postfix) with ESMTP id A41E2140004
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:38:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b="LQQM5//9";
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=Ki+umSJE;
	spf=pass (imf09.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783489114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fca21ZgkD7LFTSRCvjaeWw9IaPpMxur6ce+e2Kwqgnw=;
	b=uvQoGfQZ8h5KGSIhBGdyoz3lrRBZiHdEd6gg3PwpFOm/CsurJXFNSJPecJ1pHcvG66Q4mg
	rjmlRT1M2acNc+xPB2yT/Uqxt6qjMCqab5CbGfr6NQKntC14zyR3F2cC1mScAAHnlyRSNn
	0k1RxEsvijEAPXoXZmDiAAXXd5GTkzI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b="LQQM5//9";
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=Ki+umSJE;
	spf=pass (imf09.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783489114;
	b=tZnhyRLU6hPQqpImyMPrr7cO77LAHCn2NOpSJG0oB8evmrSNxev574TejOfasDKG/B4Dw9
	WMXuCq/qmRIr/tGcGvJIjvnZ2DMwYQNh5erhFqq2rloLzh4l1vKXs2kXphMD6kpXAab0OX
	LQEWTnE6/MutuioF4jeVRq/neEhFeWA=
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66842HYX1656627
	for <linux-mm@kvack.org>; Wed, 8 Jul 2026 05:38:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	fca21ZgkD7LFTSRCvjaeWw9IaPpMxur6ce+e2Kwqgnw=; b=LQQM5//9LbOc30Sx
	Mt1bSo5SZ+865GzEibBA6hJzyNwcXqIeC4xNa/lu+UrzBww8zpjUEoagRsBmiPsk
	bkIL9n2SSQ19liYsFwanGwNmXHDW4XvXIoQZQxPmi+k7pFEdgT1XVz5dllYIE8DA
	i2jCbyd3PlNEPfvdrqQznXquMv+tj8ZFi9hvpMf5XJHJMqhFG0XtrH09BaVTscJk
	EWmbh2EI7f+Tk0n9foFwNQ2P0/bE/ssMfwnAVa8nh35hZbW16HSd312t0lqw/LBc
	7JXd0SWCeELa3ZGymk4NGryqrDs460Gg056U4JmmadqGfExst5nRMOgWFF6iRP7K
	vMhrhQ==
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f9cssru82-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 08 Jul 2026 05:38:33 +0000 (GMT)
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-8478947e047so639316b3a.3
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 22:38:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783489113; x=1784093913; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fca21ZgkD7LFTSRCvjaeWw9IaPpMxur6ce+e2Kwqgnw=;
        b=Ki+umSJEmlxa37nacUVX3nc9jc0quDWaebzTeARNtkJdEy42ImI7Dz1J/Jk4sOXBOC
         DV220XMSKK8l/NgCqG46RTedXUvZ7+5Yeiv33b+D/jMzeRL6wtNgMCuLfaJGTK1LmAcb
         s0bBm6AfpaGTepTAFDf0ZeqZVNlcrhqoQvRsbUioJoCTWoMFR1trjiEiPmZlp6cWjraz
         QRwkBpGxg3HNEK4aACq0rTCseqopG+1PHYzVhvzFGXXSfp3gdhhtCojCHhiMKDsLvdAN
         DX8u/tdFPJv8dQVXEkSTgYe5ov5xEJvcy4FRabKG3puilZ2ejxCjwrkup2lXCz4VztYX
         qLZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783489113; x=1784093913;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fca21ZgkD7LFTSRCvjaeWw9IaPpMxur6ce+e2Kwqgnw=;
        b=gqV7CtYSGZJ4KiIx6O+DQK9CvL4g/takQpRG6sgVFBVHOvn4LPC3GCBenc/Vna82H9
         pPkQZl3VZJC3Q7OFDP3/9Qd6r0oka1CBqhGwQOxglVvgvyp1pj/jrp5XdWyfILoDk7dy
         dmF1MWysvbD0sr2NlQgH5On4Pjy+L/ctAwVwYC2auHQhBRQEsto+oMucXh5zZCF/M2sC
         eietCes9xnNhhCgR7Gd70xQS5LlKMwB2yK/AtqSr8k+PEqg8yg3WM0CDLQNsezxDE+tR
         dyWpIiQ/YFNn4awwWhCiq0JFdpG9zzjFOUEr3ODTcGHVlKEXrJ/TJBGNuMbqAtsytuEj
         Z6oA==
X-Forwarded-Encrypted: i=1; AHgh+RpmFf69RY3GH+P7XL5/RiCvedtew1sVeWxRw/iEgTXP7b2rLkjuYSyRH6H6YQxThcHy2QsOYtS5+g==@kvack.org
X-Gm-Message-State: AOJu0YyF+Txou1z9VLB65aPoFMvPXU1VvzeVhrswADHYeNJdLOUk/G2p
	GG5XbzZzOp2+B8h8a3fqZ0noTmoQnQRpsR7tHQvp4ZQ1mXJpuaqLrKWBUO9qzyOt5ae8TTnw0lc
	fgG4MQjdUytdUK5E6fHGDgSBY8QtopOIUCf26MsL131gVsJ2G/Po6xg==
X-Gm-Gg: AfdE7cm+VGHOCy6VHKOm6edP+G3jFilUw5mtgSbmV3suFVnuamvEOn4ItxMs255joiX
	QjwTCa11+8ie3KCkq+TavcC+vRSaaT4T0F+U5K5lH18mD3Xzqxi1sXXeHYoC9RlT3g5SZSyXfMV
	IXQ4qq2/PTHJOoRLYcks7ywHjJEhVkWOtbzJ17pdRWL1P/WvjcXJNWVPklB0Pvbhg1f2u2x2vX+
	SdlWJyXpHgAlK10LMLR3bA6vjlKHhegSuYvakhujp+HuiiQIATdIOuIP8BUmzFss1cnzpa5VMII
	CR2nfJvcmHistifEZ521ZIs/SiJk2JozAuULfg/3+m4GqQ5NAzE8aMkYgrAN+OWzbGq6OGcITdL
	SVNy0Ks3Id9/gpQRS06yOCrQIG/WZBAFYBt3CwQ==
X-Received: by 2002:a05:6a00:2993:b0:848:2f7a:2e50 with SMTP id d2e1a72fcca58-84843689a40mr1216590b3a.63.1783489112624;
        Tue, 07 Jul 2026 22:38:32 -0700 (PDT)
X-Received: by 2002:a05:6a00:2993:b0:848:2f7a:2e50 with SMTP id d2e1a72fcca58-84843689a40mr1216519b3a.63.1783489111892;
        Tue, 07 Jul 2026 22:38:31 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6db29d1sm6484592b3a.53.2026.07.07.22.38.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 22:38:31 -0700 (PDT)
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Date: Wed, 08 Jul 2026 11:02:03 +0530
Subject: [PATCH v3 24/26] soc: qcom: smem: Add minidump platform device
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260708-meminspect-v3-v3-24-7aa5a0a74d5c@oss.qualcomm.com>
References: <20260708-meminspect-v3-v3-0-7aa5a0a74d5c@oss.qualcomm.com>
In-Reply-To: <20260708-meminspect-v3-v3-0-7aa5a0a74d5c@oss.qualcomm.com>
To: Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
        Eugen Hristev <ehristev@kernel.org>,
        Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
        Arnd Bergmann <arnd@arndb.de>, Dennis Zhou <dennis@kernel.org>,
        Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
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
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
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
        Saravana Kannan <saravanak@kernel.org>
Cc: workflows@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, linux-arm-msm@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, devicetree@vger.kernel.org,
        Eugen Hristev <ehristev@kernel.org>
X-Mailer: b4 0.14-dev-f7c49
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783488714; l=2166;
 i=mukesh.ojha@oss.qualcomm.com; s=20250708; h=from:subject:message-id;
 bh=qD/nh641ZSFjZGTcbJ7iS+yBVa/+Otl0CfqdfCxWsT8=;
 b=gt6zHK586TYGPJ/gAqsyCYCD6hbQxtHAnbJHOmkGZ2yjp8Q1La0mBTlUIIpunCFMmTt6hSxAn
 uwkN9HKuN3hBSxqOUojHd4WBwfub/7sr3Dd6ydglmyzHr5NZOT9sPBK
X-Developer-Key: i=mukesh.ojha@oss.qualcomm.com; a=ed25519;
 pk=eX8dr/7d4HJz/HEXZIpe3c+Ukopa/wZmxH+5YV3gdNc=
X-Authority-Analysis: v=2.4 cv=EtziaycA c=1 sm=1 tr=0 ts=6a4de259 cx=c_pps
 a=rEQLjTOiSrHUhVqRoksmgQ==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=VwQbUJbxAAAA:8 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=3CFpAjl5I9ltKDqHFfsA:9
 a=QEXdDO2ut3YA:10 a=2VI0MkxyNR6bbpdq8BZq:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA4MDA1MSBTYWx0ZWRfXyPj6C+X8gLo2
 XgqmXtgW9J5Cz8Rx2CbMlh9nuzbSz7woajXNW/JzaENI0wRXB81omQm4eitjFVXyY3XQAIeh85h
 8bcSBuiqUKIkfo1pXvvIQiGrApNkMtAphiFa9J6hztIFDT/9E9jVVbB60G7ye63gSTb2udSBWwd
 GqiayQ++fHnxIV/ZjOnxlvxqOeuiXqHeV//u5SNVZ/ZflKvoZqqSsMJO+uINn9rer2PV+VAQrcH
 17IzyeXuIsggyetnIp2PS3PnsXAoWoM1Md03GFSOAMH+Q9IZbHM2+lcWoxJ5XUOjtUOBVZpGsJ/
 jfukTUlcvFpVsmccFsb/9IUsFzXCs3UNxTvH0dAV1imzaYhyfESm1BmyeovaVUGGiVy1h9yxtoJ
 4RhNLvfPKh7spU55rpYeRrugM1Wjo4Wdk/m9BkWyugl2BPMaAIYWCmWQSm/QsmApLtppkbbQAY+
 n6NAt9+WOGiWZXYPgRg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA4MDA1MSBTYWx0ZWRfX7Td1OGi81oNP
 b1mfT2YGln5w4/1etP+6IAEjFhTJrHcaeJHk4iDwQb6h2YazTsAPPcahg/KdX+SSmPMKLaAy9/8
 IcfT/RROK0QN95H6tIYCMLGp1K0tbMY=
X-Proofpoint-GUID: zwXr0GsHbHarOt1_UA2xgpTddZgLUKbv
X-Proofpoint-ORIG-GUID: zwXr0GsHbHarOt1_UA2xgpTddZgLUKbv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_06,2026-07-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0
 priorityscore=1501 clxscore=1015 suspectscore=0 bulkscore=0 impostorscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607080051
X-Stat-Signature: yso34e4jm1xstjc947egcjtbx8eouwna
X-Rspamd-Queue-Id: A41E2140004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783489114-912817
X-HE-Meta: U2FsdGVkX19/pAJfYB/SsaKqV7cNzMglB0KCYnOJVo2+3LOqD6mxQiky5+mH7YTElcmZVn/Y98SQIRv31JkoFU7jqU3ukCgDN/PD/jFeU7eElXaOF60wlYTMV2VBNX6QFg/8/hvmtyn/sa4GaaSsJCJ7nW+H83oWOoR1NZ1LNMryPdDt6KrnTspXqpM/wwPozJlq+yAQxP9yrpKYN+Nl6PylfQznm7hO9Ce14WwdU87gIADD/F6c0lQPM6v7r8gUIwv2t01rj4Zhvhhlo/ElLD1qRgvExO7XR1iMj0edm49aH7uYkUxShtH+A0bDmENwpXylbDMUKDpERVHwHMvLq2SLdZGwTEug4JHoMgfyFhStmvdsq2MxrXoDs02HYTn1Qk2fv92U9IJt7GtY+Kgdjjtpv2nKnE1svDDIA/QA8lYSHMd873ACyhU9AsR0r6n6g/i43+NLAy1sMGocpMAZ10vjTLBk/Cb/CGCEZ5ZCtcdF6tUmBKdncTIRtoce20xa+36f2i5OodqgdKvlMdhRL1oVUhM2npfzHlOiRI9Nu1U5fGc++zCA6aU68HB9rsS9//Us7iIg4nKvz2mSXxXYHl9866SEdkgqQ7Ap0WTIWV1bAZR+q5Z7VaiWXslBEYq0mmSxEKeQSkXWN991339zAk5/Y1BUYOo2XiWx9FBajZfRKfvO0PaFuGFuijcOmf8xrNCl++wZFWmJfzgC0gWc3At0UVKeXH2xbN9Zhdx+tnJi34ls/lW0c+hXq7ZzUo/vc6hrmvfj8DpyPmXYA1Xm4Y3JDuneIlKg2yw/2ZO+aSKPDkc97DEutHDr2D5O3pH1nyliGonKtYOUg/U+8yl8fpkHJ9zK39tLwOO8yvwroEa4B4ea/obAKSQKLUnRklAQAEC5WpS1rLMRpkDFdnZBdP6KYPvTzvgS5zsPn0qJ2+SAZpJCw3724koqQvt2OZBjBpQqUqwd1KaSTi8A9Qo
 /blt7XlY
 RKuL7FMg1tOkQ2CMipPZsNFLKway8R1QaxR3qlAq6nrbzsUiYz6uhKtoWH/QayL4P/zRMW2YvYurmV1RUzt94EG9anKM9dgZU96rfyJ/WsXw1NfMcDSZmIrxE2oT07K6aJYy9Zn1UUouEZ++6tYS9PhNvlLWp0TPg4Ib8oCbxpKRURD0JioVHHWzL1AfV76shwXv+CSaE8EvfJgJeTOD+vJ5lH3j7bCmqVyf6+3UP7OjvTiVkhoSBc+agQDIbgpAVmkL4w+ThlWklmSZ+6FJQxJKunb10ZPC5SRzdSWgdNySTe1mPpN7e925oAeVHC+2fXZafBnUWSYLs7THgFN5qFerqlLzASq3g8QnYIZfOKhzBSpA8psCj33SL0QgVcXkK/gudVjCg5uLJwXbGJ2BI/2xWevD7dNfUOVZd0V/KXmNKCtHLkHxl5yJhbwfknXhVtZXmMS21qFuyXHxNKofWpPy0R13LILBhO2KYSsWRP2O2PNMlP97B3arMP0pRKjvEJKmaNJgKBlzjkKEEDYCO305E9FMJbdc5vTJbW5qYz/siYyYNVXIU/2lsJUfD7prX7YB92rBd39/llxGqKsBv4U+D0LXRqrfKE6YvyqyhBk1r4wTMh/DQvb4D4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Eugen Hristev <ehristev@kernel.org>

Minidump can collect various memory snippets using Qualcomm boot firmware
support. To determine which snippets should be collected, each snippet
must be registered by the kernel into a shared memory table managed by
the Qualcomm SMEM driver. To instantiate the minidump platform driver,
register its data using platform_device_register_data(). The minidump
driver will later probe the device and retrieve the required memory
snippets from the memory inspection table (meminspect).

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
---
 drivers/soc/qcom/smem.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/soc/qcom/smem.c b/drivers/soc/qcom/smem.c
index afb21a778fe7..11ebcfc34d0c 100644
--- a/drivers/soc/qcom/smem.c
+++ b/drivers/soc/qcom/smem.c
@@ -267,6 +267,7 @@ struct smem_region {
  * @partitions: list of partitions of current processor/host
  * @item_count: max accepted item number
  * @socinfo:	platform device pointer
+ * @mdinfo:	minidump device pointer
  * @num_regions: number of @regions
  * @regions:	list of the memory regions defining the shared memory
  */
@@ -277,6 +278,7 @@ struct qcom_smem {
 
 	u32 item_count;
 	struct platform_device *socinfo;
+	struct platform_device *mdinfo;
 	struct smem_ptable *ptable;
 	struct smem_partition global_partition;
 	struct xarray partitions;
@@ -1245,12 +1247,20 @@ static int qcom_smem_probe(struct platform_device *pdev)
 	if (IS_ERR(smem->socinfo))
 		dev_dbg(&pdev->dev, "failed to register socinfo device\n");
 
+	smem->mdinfo = platform_device_register_data(&pdev->dev, "qcom-minidump",
+						     PLATFORM_DEVID_AUTO, NULL,
+						     0);
+	if (IS_ERR(smem->mdinfo))
+		dev_err(&pdev->dev, "failed to register platform md device\n");
+
 	return 0;
 }
 
 static void qcom_smem_remove(struct platform_device *pdev)
 {
 	platform_device_unregister(__smem->socinfo);
+	if (!IS_ERR(__smem->mdinfo))
+		platform_device_unregister(__smem->mdinfo);
 
 	xa_destroy(&__smem->partitions);
 	/* Set to -EPROBE_DEFER to signal unprobed state */

-- 
2.53.0


