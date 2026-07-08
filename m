Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B49EC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 05:35:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 003096B00A5; Wed,  8 Jul 2026 01:35:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1DDE6B00A7; Wed,  8 Jul 2026 01:35:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0C5C6B00A9; Wed,  8 Jul 2026 01:35:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AC9F66B00A5
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:35:10 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 231C140686
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:35:10 +0000 (UTC)
X-FDA: 84964495980.20.D48BE1F
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf05.hostedemail.com (Postfix) with ESMTP id AEA32100004
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:35:07 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=M4u4oLee;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=ND1hEJBw;
	spf=pass (imf05.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783488907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e3kzuLsbVSP+LQEgSP+wDvBNkj7pdMjocJ33jwAybcM=;
	b=qiWz+Wit4C6wFd2G6eUq8cE3IuI1M/wNNb9gYFbYQUlCa5oQGxQwVQG9h/FsOQQCkiaLBM
	Oh2feh1q1f8QkGHiA++H37+9owyZY0w8OmBIH1DoRC+UB3cTp4o7HeDBA1RL0PtLiGYoHA
	frtPd7awXcZmco5Vs9CH+Q4uH85S1Yg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783488907;
	b=um0iMAsfUlfnBsYqZ09S8NaunYd6u25Ji1PKrN4GSJZ08KrEdpei8QkNyz5o0YjvdXZrru
	yB0JAfadhxAZVWo5QoYyNRsCREptwEyqFl4f/6audMFjfcLIdXZRB4QK+5yULSN0k2dDwh
	waXTzNoSmLvQz2Eb6si+QjD8dH+N15A=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=M4u4oLee;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=ND1hEJBw;
	spf=pass (imf05.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 668428U91656386
	for <linux-mm@kvack.org>; Wed, 8 Jul 2026 05:35:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	e3kzuLsbVSP+LQEgSP+wDvBNkj7pdMjocJ33jwAybcM=; b=M4u4oLeej6p8aS0u
	TRiwSM6+IF3MEJ73TbAD5e3O6bITNiVhDsevvmXVA8qM7eHF8ko+X7aB5nuu9aa0
	VGyZj0lxfsCcIoLynfx+qcUXzgOwfBJSVD6Coh/wG1mrFdfAuVOm4FeR5jHxaJcn
	OSVcziuUAkVr0Jsie3RsCsuxwHRnw92TBYL2AsOpSOI25B2LX4lyximoVyCKH89k
	RCi4EMAa0qHudCXQ4GNEai/e3XLrrL90yW7MoFAGAG61/ffzdilghSC5UKSGVJkZ
	pBAjnOcJqrkdnfbmUkEkRcCbaSL2MoV/Z0A5zUJxUgBmiq/OUVKrib1maXiZWC4R
	hd26Nw==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f9cssrts7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 08 Jul 2026 05:35:06 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-8423f1fe39eso661455b3a.1
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 22:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783488906; x=1784093706; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=e3kzuLsbVSP+LQEgSP+wDvBNkj7pdMjocJ33jwAybcM=;
        b=ND1hEJBwgSzkZy1HtYREzpCCu2WSBYQMDevhYkRbJ21L8yE05Hw4qZSV+E2dhE+5Ub
         3R3T89eFlJBgqiF0QbuVab2jC9XZC0PzSfsXf5H8TXiY8Srdd16mLfSsezBSZsdYvE3S
         eh0ftr2C5CK9jlVDGtWPbc6USAVDhHgqHG3gCtBkXZcIXEWnGT/mcBfwuIJT8BgkC0uU
         EUgj6FtGjgSOtM/QApai5GWu/Yo4ehpwTMYYux86pbZHDJwui7vWi1ekmK7wcPBwZFKZ
         b9NIXU6PRjn5wrm+AMPiptJ+aRnZbIsd6fwVzJB4cr2RbsEbR5EtwGUMs2Xdtl3hYPzo
         mK6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783488906; x=1784093706;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=e3kzuLsbVSP+LQEgSP+wDvBNkj7pdMjocJ33jwAybcM=;
        b=GygfBWNPg6H+PgagHJ4t3UHXlvfHX26Zphq61tEOcce4o3fsmROy8fZ1H80KaCBEDV
         trI0vmEu7Hx649QfD8SBDRj3EMGUyM8ofvTeP5tH7YhfPSp2La6GL22oKm4jr0VarPwX
         YvOjo5RvMl03fj4LJslXHzITuZQpnJ2BRTVHBnfiUyAo/+6ftj5n3Pk6I9g1pErzryQl
         Dy7Eq1ImYshkjlXS3bdKRrqnMXmnbBf8DXVPdHfwkXXoCE7wgS+WNWo+Eb0meSrh2RAb
         gspEZSVo2sIt9NQkIoy0SRq6xGle2RREPHEFyeb5RSPYD2dvgiDMd1cBm7UJsPU70PCf
         ZPpw==
X-Forwarded-Encrypted: i=1; AHgh+RrX6Edkzo3UWTPLvQvSuzMbf9CnwJBhlj5LCFNn/Qqq8wnVP0r5N6mTHG8HBbNsRxM4BkSbSWHScQ==@kvack.org
X-Gm-Message-State: AOJu0YxnkWZFng2PIe5GZZ1t/wyjuYk8EMWkCos9m+iGjikbprm8thEa
	wyag8SReYDjrfk/CvtNHkpr6xdhDIfINlfv5LGO2UsyjpfrhSUVrOu7J8qXGZITsBQewevYT/6x
	jezZ2KZsXj1HS3WRduix4tZD4CVwhj6nNkDnaq/I4lw3lG1a//O2j5g==
X-Gm-Gg: AfdE7cnoqj3DXRUV/9OiCms5jsaHFvnZFGf2pp7qRxsEQaG5kGF3Z7V5iJFbzSTj6jX
	FVATMtGc8sDoIgAfplok2hlBFAW8xD4xJqRh/sL9opbfXWTIC9DRQEgHuHbqxxYAsyZoIrUm6Yb
	O2YjE6E1H4uHDTtXFguxQdfdc8S1TBKB6h7PxKDUQdkRb/FKinUFRbmhvk7EuQtumWo2zEzxWqd
	MevnPGZczJrHuhyyE4evw4WwqgaRHH+dqw304Y+KMwr2rpMYrLjW3B57SlDgF4E14ehUQHunUR3
	M+ZF4bBRhvFqf8r/u4Tvu0qqtZTwKu8uGQivcqcZ1F68DSJO8F8vMEeJbN1eIn7qlvZ/3FHB6ie
	pt3jcJKMFKoPHY9IcG5svoeHQxWmiPydEZ00ssA==
X-Received: by 2002:a05:6a00:9aa:b0:843:49f0:f5a0 with SMTP id d2e1a72fcca58-848432a16ebmr1252334b3a.32.1783488905624;
        Tue, 07 Jul 2026 22:35:05 -0700 (PDT)
X-Received: by 2002:a05:6a00:9aa:b0:843:49f0:f5a0 with SMTP id d2e1a72fcca58-848432a16ebmr1252249b3a.32.1783488904894;
        Tue, 07 Jul 2026 22:35:04 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6db29d1sm6484592b3a.53.2026.07.07.22.34.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 22:35:04 -0700 (PDT)
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Date: Wed, 08 Jul 2026 11:01:50 +0530
Subject: [PATCH v3 11/26] mm/swapfile: Annotate static information into
 meminspect
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260708-meminspect-v3-v3-11-7aa5a0a74d5c@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783488714; l=977;
 i=mukesh.ojha@oss.qualcomm.com; s=20250708; h=from:subject:message-id;
 bh=Le/Q1zQCFzKw7TzU97mwXcZteClh+RXmg0tVYvpLcUg=;
 b=/A38jB8jdahPqFeNwjbw3VsOCOB71d39aCOjB+lkv/q++5YdKJm74I+QKrYoRlSQmDy7ph1py
 Js3L+F1YhD2A103w/t5mZSZ9W83XBW+cKVhsPjinjQelhxoWx2X6Hww
X-Developer-Key: i=mukesh.ojha@oss.qualcomm.com; a=ed25519;
 pk=eX8dr/7d4HJz/HEXZIpe3c+Ukopa/wZmxH+5YV3gdNc=
X-Authority-Analysis: v=2.4 cv=EtziaycA c=1 sm=1 tr=0 ts=6a4de18a cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=VwQbUJbxAAAA:8 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=7W-H8-9HiqHpPtFVMfQA:9
 a=QEXdDO2ut3YA:10 a=IoOABgeZipijB_acs4fv:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA4MDA1MCBTYWx0ZWRfXwC/+IFUADVZx
 kMdmt9SgBFO/AKVbRQx8pYOn3hCHx5dVpJIYUGyiRDOwucfNI1Vy5RyANh+lSR49HNYuQ8q+jQp
 Wca30HHj5AGatTJ4TzGY/2a2DfaZz2tkHZdsf0GtbX5MRfid7+qk31qnJMEYLa75uyPhVfc/xM4
 Vqei3JQwAlAcUi+3ot3wlA2q5GJONuQC8+MdTnEUGQwQj5bebeRgtiJevg2qacLaToECVfETEPC
 WyD95u2ctUlRtvM228ry1UpEQ8h01Qad6SpjsAGwJHgumy55KJQBVOlrfTFHmEtx6iCnKYBklaD
 oJCg1Sfa0aKEdA/99MPDTavoUMULxHEpBPz62yoIwsLMiuQ5hafyJIXevrbMg3eNBExksVEaHJC
 Mf0n/SAKoiyoOMKvLZn79PKd2Ev9hbkmepEohlE4Z24m6DxLeoiQDlURpb6iaEbZe5ZneakbV3/
 WJqNMhJ1zY4qxMug71g==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA4MDA1MCBTYWx0ZWRfX2v6ndH7MJFOB
 t6mLvPds2n/tByUUSNsjodQYiF/ieRYC44cSMNA/C0+ZJdOZEmxVkYC5DIP+nmS6c41GLOWEDze
 tTu5hMlbBKCoKjqlrrujgi4Yd/j6tsY=
X-Proofpoint-GUID: FnzSoSnBxs59FrXY8BdooP8Q0T87Tbrn
X-Proofpoint-ORIG-GUID: FnzSoSnBxs59FrXY8BdooP8Q0T87Tbrn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_06,2026-07-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0
 priorityscore=1501 clxscore=1011 suspectscore=0 bulkscore=0 impostorscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607080050
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AEA32100004
X-Stat-Signature: xku3ez5fh67hf1jadr4ffjnn3btpjdej
X-HE-Tag: 1783488907-321184
X-HE-Meta: U2FsdGVkX1/qMZtLyk50Jqsk8zHzs9y/3n45B1IrhOOegPYIa7jEVxKRD96CFSB/IQtc2OMgIIdeBbJCaYkOFCCJW8ob0jty48deQdeBFFe35sIQdnKnCjfZLAlUG9JFCATAKfeuHVUvDkwifI1Vpaa4LIfm6sOG92kenWFXBfcbcQ5TcDcLLFE6Pn2e3SRJOK7R8D1/kwHXfYM9m2AAs8n9Zb7WS+bMq7eDk97Qg0/SSXfNr/A0dGFakezQB3jymJDBR1lXVlYpJidWQ0KVkp7ie/sd5sewF8YVlsR0IzSpwl0y28Yd0sATWywp53jbJKPwxD1oyCzhWIf5UyPP/TBUiQWh1FxGFlkYlsXRL3qgG7G9+dMrhop+xNbC6/tT6svkMOP4gJuSMl7+IC40dNKRRfKbXq+Zbuc66fgT6K0T53fTuC3VF6gc5Grond15Cy0gPcmO2fFz2Q4J/g7hNpm/R6mjsRf7SWrzawkImbyhwP77OSOre/fhmvk7RfbCQjVsIQnFfn6V9DAgmaIW5T9P7GC4O7C2+HvcWCMakIQ4fYuneYXRyZV9QmWW3EvfTmoe1MUbiw/FMZ6lCsFMPUrPPFBln39aW2KCVOD80n22+tqh9ZXzTu+I9OKwcU5x+iGEmO/ApvRbMwlxRDpYKUcRsqJf2JkBClAIBjVGnqbUHqQT2XgTjIU3LLjNR/QG9vIDxD09RZUxhUsgeAww3IHmuQWVuxe5YO2AvIkvHJNdayfiHogYx0/6y5T83SH36dL/653LFXEOLu6C6D0nijkmtA60gucuScOEjo6UfeRoCo24yj0hiR0ZanUcr/SpYbvuye+gyMUoq9f72imbe4K6xU8DISIJmJh1QUbx1oocbBfkFxO9laTQMgqSlhHR6VIyG37R6zch0hWtjNhzVoK3NAvyDqMC9h+XkwrVY/qHp4EG7gqNAn9y+xhX9PBnp0HXPWaXEKaG8ptsI+2
 y6xkFO42
 4szeHnh4gekof494Z4i6Cm5Myt4xxO6B+M8Bky9qxJu2RPLEv3GaQfRUbt4n7+vqWNQ0kMdqOe2MRTOGIpurLadYUcivUwajjZnOexkOwklyl9yvTd3OC+9/f+QDThgy4GB0syAKaCdRdoU1m410ALWDertwK8q+f54wCz4OGTXqT1dKpK2oftTeevbOhRdDAhSLBX3DFsnDTF1W9n6qz24e/eeUY7C+0/XIOtDVLDnlUvf7J1Y9YOQkGjtk6zPm1Y/wKEDxcDvqLYrsosW0rCKj5AjL+vBq4shlWIclEXyWX2zrMhnOaA30c4PLQaIfcxyKFrmINtKuhdtDZIRUKa25dmLxwYO9rCkXq3cYQE0LdonTW8r6boU+q0vZY7wjVYj4O4+aaZ/eAmiA4oVydYFdUcIS5BJC8UYQbqu5A1Z8VcZjqOiuYKJKyj1lB2FwUJ5nTesqriTpnJLLUAVddsUANAdJolgvGYXB6yyTdF0aqIyfc3qkkA/NITQAtJ6z/qTtU2IRDtt7hCzxKGFKqQC9uLjmxpeVd3MeFSvvdU4xFgGn+6AgzPOCdlHD2ZskC/x0RJBNtZoSGtmhRwwynli86HQghIRvxpnx8BTd5QY8ztgUdXlYIyqI9sg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Eugen Hristev <ehristev@kernel.org>

Annotate vital static information into inspection table:
 - nr_swapfiles

Information on these variables is stored in a dedicated meminspect
section.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
---
 mm/swapfile.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index a602e5820513..d480727e4987 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -42,6 +42,7 @@
 #include <linux/suspend.h>
 #include <linux/zswap.h>
 #include <linux/plist.h>
+#include <linux/meminspect.h>
 
 #include <asm/tlbflush.h>
 #include <linux/leafops.h>
@@ -65,6 +66,7 @@ static void move_cluster(struct swap_info_struct *si,
  */
 static DEFINE_SPINLOCK(swap_lock);
 static unsigned int nr_swapfiles;
+MEMINSPECT_SIMPLE_ENTRY(nr_swapfiles);
 atomic_long_t nr_swap_pages;
 /*
  * Some modules use swappable objects and may try to swap them out under

-- 
2.53.0


