Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F7A9C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 05:33:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57DAE6B0092; Wed,  8 Jul 2026 01:33:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 554336B0093; Wed,  8 Jul 2026 01:33:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 442EA6B0095; Wed,  8 Jul 2026 01:33:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1BD8F6B0092
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:33:04 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 970CE140547
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:33:03 +0000 (UTC)
X-FDA: 84964490646.25.6E6FC1B
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf29.hostedemail.com (Postfix) with ESMTP id D09F8120005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:33:00 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=YNu0KmnI;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=U0Nf7JQu;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf29.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783488781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W3F3QI++Ymkl+ZTQbO8vQyeuk6HPuF8AuBjBmELT9jU=;
	b=0XnYoGUmB8l5VkIDBQ+bJ5RXPHqHf0IepmNo84+4zn/tPaVCvimgHppLlsBCjjb3sdbJPH
	0SQkrFSNF9qFzbq1L38sPpqqs3Dfx0wIKgLqnBL61pZs1oo1xOSWyckr15l8AUTgAznBaZ
	5PPO22jHn+MvbVBIL4FGdR0jzLjE72c=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=YNu0KmnI;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=U0Nf7JQu;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf29.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783488781;
	b=cyOMt5NfdWA+VdFHd/hKWNhFfVr3IXYwBhOsMO6uo6Z00vX8XKUStQ31XKJ/KZ5RJ5/whG
	ZaniN3I0sC393VTQT+5n+DWLC0sUhpEa9uTcxIGK8cJf05XQ4nl1tL2mqpeQ7Dmmcn5Nsp
	GCeoxRt8zXfhUowjJLQ0B98TdCCxYw8=
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66842aJa1667900
	for <linux-mm@kvack.org>; Wed, 8 Jul 2026 05:33:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	W3F3QI++Ymkl+ZTQbO8vQyeuk6HPuF8AuBjBmELT9jU=; b=YNu0KmnI02jC4yC/
	1nLV2/RFfnY2EHc/tlF2Cd7G6gUQ6Yl7zDMWuXbbGv61Rpd9zp/YyPQJSkghVqUI
	nCs3JSjPPd7L4zO0ZRkmIR2Dl2R2T2xXMVP2YhovRJXS1Z+2aTFT7sVFtFTX8hCx
	KYlBxK2SgwWfto4JqKcaCSLRtVUjyiAseaY0xUTwSu/C9Q1G6cU+OW/9YRKRfBkt
	d5Mb+80OZgAebHgZ39abhnUyjDQ5kk+BZmoKVouGOGL6pTdUpscD/kkkbHtxb0eo
	mBZccT7SGgSj+3MXqWhUszJXCwkH20MQ2ndtP9xfI00eRI9HRkUgBY5T7WGTCKTT
	eFzT5Q==
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f95e5tt8t-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 08 Jul 2026 05:32:59 +0000 (GMT)
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-847ad67cc51so345660b3a.3
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 22:32:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783488779; x=1784093579; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W3F3QI++Ymkl+ZTQbO8vQyeuk6HPuF8AuBjBmELT9jU=;
        b=U0Nf7JQu1RjVSVH1Rq74Kov46YuhQwmUu07JdFQg2GHeQhK7X2iS0K+iu3CXhE0DgR
         KSRUq6dPbU/5Lmak1ORp5Ne8bNx3Dh7D290E6IWMdiCZc+TTxDAkAfu4GjlroIo7CpQQ
         I3jNU+qq4C4YqQnWyC/Jh1PPhynDZwtIUkILb5lq80NsbJk+BdUrGgNw2lAzdzDwWDPR
         mGClld1tzJhA6yjDuHwtVesdnVjVCVDUilxK8Q59USMIWiW7H0Hp7vFNJB428CYoBDDT
         JTuAzLlm/dkQDqGc1Y4AqNbyQUNV0QlHSL+VPWsLMwPUK+SS412VBeAajOb5yG/JZ2y0
         LD+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783488779; x=1784093579;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=W3F3QI++Ymkl+ZTQbO8vQyeuk6HPuF8AuBjBmELT9jU=;
        b=SLba7zodyOmYcZ67Mwz+p1VCXYiCsaiYeerOTBT+abbagP2bydQHYGkP2ww6EZw8kQ
         B6RUz93WE9MThOP7+JXIEUxdQ+uz8u9cuZBKlxq0ZxDOhFe00Dltbm8OV6brQxOnC+yF
         L5aqmijr8SIpubiPlQS6xehnTMUU8alteCYJrJ8dpEmGg8GsdEK57QJa7z+ZJccp+Efe
         OUgqmo27n3h7KEC1QXb3kBpykSAalqTB0mSnjtFjq5D+j4sA3CGSj61n1q4C7Xfnclxz
         tqQSM+UZ53srAd5NaBQakSgrTRMsIqcSRvfZ8/9qVtTqp7VKrMFuuJXmx8QSriGG9BkF
         97+Q==
X-Forwarded-Encrypted: i=1; AHgh+RpPfaGYRPuZ9C6VAMbPhRXSkl6qOEmJiQ1oe+zENMwWlqLZ6xJ3cPH19Fkzjixjk0lnhXmEeyObqA==@kvack.org
X-Gm-Message-State: AOJu0YyfpDbBdY4XIUhVz4f3f+oRJl4JA2LfcaDZfN1ane+V/i0RJoaH
	2P8DLz428XG2eUaD5+dRtzI/SIYT4Cw/AZVwuN/OmR0l+c2emh4NAj/yamw0wDi1ZRnC5kcPZa6
	x/3QuU1vkgg7JuD3j2itzCwxWS6rxAuGy/x7jjVcn/lYndoJW6l/ZBg==
X-Gm-Gg: AfdE7cm33gFfDNc3oR9b3ybl1mNoKLfdahTlssinVKttxKs2V0xwOA99kaa9uB5I4qu
	6+qVe+1GUnSdDkDepPQKEVUzuxfPICMhnK/6M96Y91rsAzOLpvmCTXNSqZgJzRlMeksQPHoOP4M
	lvEz81KdGL8IwMJX5WbNYHssFeg9+7AU2tpGGbLlph63myghk3ZjFQxHhjgJDM4GsIYPBatqw35
	ZsDkVMGG5hDyF7cVPYoxGSUfllrgwrk2nfahPUvwIYo3gA16c0cbRE8NUn27Jue06QlJcIPpLtU
	J4B/4l478qxEiAFmeKxqZn+sVFOnpzgL7fx9znyJ5q1UTDEKWe+nvWjVZq2MkW2udAPy4Byfdor
	TX3EXf8J29nVodFgejXR1SSKnd6OQq9F3Ro+nDQ==
X-Received: by 2002:a05:6a00:124d:b0:848:2ae4:d2ba with SMTP id d2e1a72fcca58-84842ee9a7amr1114057b3a.28.1783488778704;
        Tue, 07 Jul 2026 22:32:58 -0700 (PDT)
X-Received: by 2002:a05:6a00:124d:b0:848:2ae4:d2ba with SMTP id d2e1a72fcca58-84842ee9a7amr1113971b3a.28.1783488778069;
        Tue, 07 Jul 2026 22:32:58 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6db29d1sm6484592b3a.53.2026.07.07.22.32.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 22:32:57 -0700 (PDT)
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Date: Wed, 08 Jul 2026 11:01:42 +0530
Subject: [PATCH v3 03/26] mm/percpu: Annotate static information into
 meminspect
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260708-meminspect-v3-v3-3-7aa5a0a74d5c@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783488714; l=967;
 i=mukesh.ojha@oss.qualcomm.com; s=20250708; h=from:subject:message-id;
 bh=J2rXid2SL0yrlw2fwtUaAlFG710CRNb9UrbWjew6KaA=;
 b=TD35QGzVjIwYZNf7SFigqc+I/Rh0Yjyom+K2CZ+Qac5akSllT3+U5ZG26sDsxkvfsPiyNpmIr
 fPjSUHrWCbcCSiASTdRuilYPVxFPmdtOf+xMfsX25dmzDI2XfDMmr97
X-Developer-Key: i=mukesh.ojha@oss.qualcomm.com; a=ed25519;
 pk=eX8dr/7d4HJz/HEXZIpe3c+Ukopa/wZmxH+5YV3gdNc=
X-Proofpoint-GUID: cRZsw8RdboJ4CqakFjvaqWBgC6EvUgFE
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA4MDA1MCBTYWx0ZWRfX75DtMmVZv1Zj
 Hv0xMRFlhH8n2IXTsF/+C9Fgx/YYOpDyTmVaJ1CLD4sgnoxZp2BUY62eHEXlipWkUZ/1A0UaEYl
 BD5+x3fo5evrVlWVyhI3s/98ToPhnkc=
X-Authority-Analysis: v=2.4 cv=CNoamxrD c=1 sm=1 tr=0 ts=6a4de10b cx=c_pps
 a=rEQLjTOiSrHUhVqRoksmgQ==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=VwQbUJbxAAAA:8 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=5GcHMyRee5XsgDvb95IA:9
 a=QEXdDO2ut3YA:10 a=2VI0MkxyNR6bbpdq8BZq:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-ORIG-GUID: cRZsw8RdboJ4CqakFjvaqWBgC6EvUgFE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA4MDA1MCBTYWx0ZWRfX7+uMMinRite/
 PmvL0lDYyZtXDPSedkLDmQt94uFkCgSyUeFnUOZq1AK4yESiLRheCRS3KX3Vut1NNVUZCQAv79d
 hVaGr7zhuYtI0hrTJfUix7BsU3lJ/bR3YlnOp4roJhX6/h8nzq6+1/19osoQPj/1yjBZpNdxcpQ
 BWij0Vu1AJ+V/1L7j6MrzL02Y5j0fYYSTVuojBKDzB09bNAAoomNQ44/+b2pLmbL0Y/CWvq1kg0
 wNWAL6FFGIVkR5slGABimnlkA2xTfAZG5n13JjPHkHgjAYc7IQ/WfHB0VBkujWFbk9tGHlOr0e4
 uGpCXvst3UAmNBA9X2FAGr77sc1MMHkMW1S24/DvjT1/w3tKxW6IPCtMedMAmVGUM8H9lgf5Tdo
 CRhD9YmyYaVLkQ0+DcIyTMDbAR8JqiwA8AVJBGuArXoXNXMlHsc5+e1Xge7TONMXi4bqVcG2Eqa
 1FIgVhSluCMff/cV6cg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_06,2026-07-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 adultscore=0 phishscore=0 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607080050
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D09F8120005
X-Stat-Signature: dy5dipfftgfcfxja7soh44e938kpzrwp
X-HE-Tag: 1783488780-455349
X-HE-Meta: U2FsdGVkX191RCpdD8pQ7zBLA68iEOUgkRgqGmMCfrZ4MLI75tb5R7V5RXHWbe/sCOrjJJEiyzFHnjzHiX2g4HPki2QXmUMIzthdwWzTvAEVoCC9e5LAsD4GHjtg7xUeZrNRTflRvloX9HlhvYOGtxfJjY9du9n9b95KayTeIdiEBIIgcrfNX2RYHAEAVr7T45UNZ2ehOIQXqfYhA52oIj1UhQNFbbOjJZo4d2pRISAZCYGQLFb9LUptWgInLs9d/H7pbo5BLlXnYPD80G7vP5dBtNPTGs7ey2fLbBomhyk9R28U+AVBcLQezM1ysEOoiGlfW+tuNehUH7C53+30RIEuY7N8/07BdT41G7YGSG4a8lNdCcndY6sEja/hCbVVIVXICmngL3Rr7ru74li21v3VybE2Tp3LzClf9gdHodou4GeLWutIi2VL11lC0sC+uSRP5g25EozunqblffTGnYT5g5BPydJieQuYXgClweqZZ1t2tC6N7lOThivJ5ppR+LFrf//BXiB8+AChpXMN19xxAL88Ce1FT+J3dSswIDnwVtgvimvd5M1FO0v1uswghVf1N0hPBOOKoUUQ4gg/Oz6WhnQre07W5N0KIAVfIIoOqWg5+979OaXp1r/ujY7XFooHdQCqt2UcsdEIg/WNrItxGBZ8F1d+05Nrf7ux+zV7mIwQNkAGVKTHn5fPhxMeIU0BQedi8dxnR2HrQmg2xSvSBnD976Z3QMMiPliiwzd0+QlNrxsSBvas1WgeAgLZngWiZmtMddKtCaUAmpKrYb4TNZJ4JDmLPceEjo3eKl/NcUanMlk1oHi1bNCP7G4VAXt/5Oo5oSJxnlDHADqAORnmcJRJwoofcHqMAKUG+LAgVBGvK5dQ8en5rOD8HPi9RPYdD6X0u2kOqUZDdDroKPOaenaj558y69DPApbrgDJQeQdB2OGADKwR5REKKAzIbmJp84FDn8U2WYPZfJu
 ttygzFhM
 BUpVnQwch9icIoYL9gH2H6dKJAehp3Cdrpbz7L8lon1BMvJPjzojyb6Cu5vD1XMFHwj+NzhoRgfDf2ywRbFWjsOSDrc9gMOjtmn58Di/Qywqfqxfxd2huBaeqLkLABBqc1v9zKGkYc6y/n/ZC1b+6j15eZeMiGdJEbknKEm4yklSZUXfx2aGgLo6BHDW09OhIfwkLPUUWkZIILyLxAPsgLoxjnbZO9k8rxUexy1AtTZy1/iaLRA7bzfI3uU36M0+GimGzTH+8VydhyScFUv2EuZSmhZTRoiUk2Stm991F0ybkPVEU8OYkwviDeNvm7ecKRRr8jZUPOfNJ1LYg6eBs43M1dS590xN0ChoE3LtBrOpfg9LHzW3TLb/n6xfnrUKfkihvf/ia4WoQ8V8uwa2Me7omjzIOJhdUks7wOrPEW/+Vc2m8L0CmYNpNWiCK25iGUREYsYaDD9xwHfOp/Gd4L0rWeTRpi6uLtFV+TzXdL8mm/OshiOuQ7501e2lXjxeaOOYFdLbmCiLakYNiR3p840atq+rtunqUbonIt0bykoqfu8aFlUffctOA0eXksMj4Zija14sb2QGVz5P73T3kzvLFfgOaYrAIN0MYY01yblm/sz1U/QTeVPPK5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Eugen Hristev <ehristev@kernel.org>

Annotate vital static information in meminspect:
 - __per_cpu_offset

Information on these annotated variables is stored in a dedicated
meminspect section.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
---
 mm/percpu.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/percpu.c b/mm/percpu.c
index a802d72c116f..5b1c87e46273 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -87,6 +87,7 @@
 #include <linux/sched.h>
 #include <linux/sched/mm.h>
 #include <linux/memcontrol.h>
+#include <linux/meminspect.h>
 
 #include <asm/cacheflush.h>
 #include <asm/sections.h>
@@ -3367,6 +3368,10 @@ void __init setup_per_cpu_areas(void)
 
 #endif	/* CONFIG_SMP */
 
+#if defined(CONFIG_SMP) && !defined(__per_cpu_offset)
+MEMINSPECT_SIMPLE_ENTRY(__per_cpu_offset);
+#endif
+
 /*
  * pcpu_nr_pages - calculate total number of populated backing pages
  *

-- 
2.53.0


