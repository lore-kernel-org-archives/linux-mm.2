Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47310FD4F2A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 20:19:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3B036B0088; Tue, 10 Mar 2026 16:19:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A023C6B0095; Tue, 10 Mar 2026 16:19:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B05B6B00AD; Tue, 10 Mar 2026 16:19:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 757566B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 16:19:49 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4913516029F
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:19:49 +0000 (UTC)
X-FDA: 84531269298.19.88D62B9
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf03.hostedemail.com (Postfix) with ESMTP id C921D20004
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:19:46 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=DjRDOs4L;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=CnzmyuCz;
	spf=pass (imf03.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773173986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gwpDp7aMAgBSG+xcal97Cd6xKHw+4XmuCvZKGe6Z0+E=;
	b=AzRIAKFk2B4AcvYOEm8VaXIDRCGp5WzIMrhPCQMDS6D8rZnl52hBgzlJAwa3Kv6QKUhrVV
	D5RmMx6UBh2co6KMnPB57mtVLl6SWqv244acQ9pSXBnMNvGVJOq73h3c7AC12QFbAAGkYq
	kNbktlSDHBJMgyxjqZMD8kZi6vSk9Ks=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773173986; a=rsa-sha256;
	cv=none;
	b=o98ao20AAHf/ptVos1l03MriZYGMgVZieN9G/BABztXkzdB86+dIwe440u4Sg70wAy+Fnv
	m6ixyPefzCzZ/8Wlalg0ICwsEGVIn97Bx187zTWLGFFOfAH5m3FVq9/qhWeXzToHiiFV9j
	gxMqu6sGANGvPV751svjv7SXDGGgi8Q=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=DjRDOs4L;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=CnzmyuCz;
	spf=pass (imf03.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62AGGvKO508294
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:19:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	gwpDp7aMAgBSG+xcal97Cd6xKHw+4XmuCvZKGe6Z0+E=; b=DjRDOs4LgNnogppS
	pbEtzYSW/aSQ1bjfJwg3k2S39P0xRyV7xKiR+7tMMqNmVhvTUY+UQft64oSHwc0m
	O0wKRltcKUkeV5nyagGJrw7iUhjkQ+KaQGhmsAFJu8Ns8VKMirOXkYe9TL/kbNKn
	1EtKdUpA3QAi5bLLilcf6G/V4kHSC3+YBVcuex7nOWge88/ZR8rzGtzNSpfHfm4/
	/PperC8fre5EIXn8E9lbFebGMkC3Jj5XtWMVk5RDFZAHzj1PEvi51Vq/eVnzlBTQ
	nnCRCPJW8Vto+Q9/ZeP8V4rOHGT0Udq57XA8N60ZS4vIorBICL6riLYCBqLcC9Uz
	ax41ZQ==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ctppagwtn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:19:45 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c70ea91bfe1so8029211a12.1
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 13:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773173985; x=1773778785; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gwpDp7aMAgBSG+xcal97Cd6xKHw+4XmuCvZKGe6Z0+E=;
        b=CnzmyuCzWD011ulma7ULTv95Gi+gVMjpgxR9qv9tIaEM3CKph0IQa5p/gXsEy79sV0
         SqAEe6w9rnsCrSPAffo3zhilEzkb7pRnfQCxB4h84tDgmzJk2/d6HJhx3VCDnY3ecUU+
         7wqG4dyZh8C+/267BHnga/io5FAQhxBjWgahMrl05lx4BLEG44cepAf8GOfaKTQBQpwH
         0mxuXQE9BvEZXb3/NE+42JI1GxEjdAdhvF5eNOq6a7T8OsW5HK52SZIieAQ/KUSr4SG0
         4hIn+tHKhmVu0PAvtVlhcT35bPWbLqAnIYrjZDkvvbX0ThIbl1ZBPBxaAglJbohCHmP3
         CWkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773173985; x=1773778785;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=gwpDp7aMAgBSG+xcal97Cd6xKHw+4XmuCvZKGe6Z0+E=;
        b=Jw179Sxu51nfbE56kj49POPCKv1EGZz4Qo8Otq+D9Cj9fq7ygdv8EjaEEO3sEBG8wl
         KwZ60iqK6zqWyETqR1/nke/vZsnC6j/LsY/f4unve2F3pt++e73BNSq5THnKbBrd04/F
         C9Tm7tIEiQRlKiXsEMyWeSzscSOdg4HOoBMzjCIG8MzxLhAgGJzhRYcH42oBmxvMW/db
         0r2+3Y9MlcStRantOe9a3NQh1zWirRwI8SESCvRvoknSuJpgsixaZcNWtR7U/h7HpOlH
         TQFqYzi+6DdbVHn4RwA+P1hgeIDCKUV5ypj1USSI/e61a5ZkjsoBYSb1C4oPeL8Ynvpl
         MjrA==
X-Forwarded-Encrypted: i=1; AJvYcCUhiwa/4+9HsURwkX/cPBXBAH00a8ahuuqE04SX7qHMzzqD1dvJfNjjQ/7yEkynm20OhNUR/E0Jyw==@kvack.org
X-Gm-Message-State: AOJu0Yw1dxgKo9WIOSh/v2T0DvkP/8lUw8ujgIm7k7PEvt2/H3Y5XMPn
	oYtxNetjTKjaSKX9NcMw+xrwQkDh8gH+HnHXNkjLVKZgZYMh66sXMO8fzM/qMEk1aMP7nbMLEhy
	qfNckvQCp2IAzIVleqEyjPEN4wyVk946OyeRb9LyUw5vi/TesENWVhw==
X-Gm-Gg: ATEYQzz3sbZgjw+e2I8+cKuqIBQ68OokdB5ZJnP5AMH13DQ33wPyvVGGlDCXdgKD7fq
	dV2tkqea7j3Qkwl/Rwp2KN3pFN/sXiJCxszh1qeRIwn6duL88XRLDsI68L2LAakiXGQrnwpFN6H
	Xo4slNECA724tcz5cIGsAXS9J90RQqL0fo/Kzz+XJaGSQatuYL+QJi1lZrl54Tj65K5y1TyzDln
	UBxksu+9U4ucuU6FaujTUn7sxsIYjj/50Uy1UAJBZr0hqOX1xcIN+OSidLYOJevlNw/4WVuM0F/
	PAl3LyI1z3lPkb8QdTeHBx7mk/BJ+AlH8Y78NFa/Fe6f7fDTPE1qyTc2MzIqYiGusfPX6F4pe95
	fWqMe4Oo6shd6FrPq2HKjMMm1SajZ3QLKkuSfg1qFBaqMggJ6
X-Received: by 2002:a05:6a00:ad04:b0:827:2736:d928 with SMTP id d2e1a72fcca58-829f70f04c4mr138777b3a.39.1773173984647;
        Tue, 10 Mar 2026 13:19:44 -0700 (PDT)
X-Received: by 2002:a05:6a00:ad04:b0:827:2736:d928 with SMTP id d2e1a72fcca58-829f70f04c4mr138715b3a.39.1773173984034;
        Tue, 10 Mar 2026 13:19:44 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-829f6dc2d0asm115262b3a.13.2026.03.10.13.19.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 13:19:43 -0700 (PDT)
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Date: Wed, 11 Mar 2026 01:45:58 +0530
Subject: [PATCH v2 14/25] panic: Annotate static information into
 meminspect
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260311-minidump-v2-v2-14-f91cedc6f99e@oss.qualcomm.com>
References: <20260311-minidump-v2-v2-0-f91cedc6f99e@oss.qualcomm.com>
In-Reply-To: <20260311-minidump-v2-v2-0-f91cedc6f99e@oss.qualcomm.com>
To: Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
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
        Konrad Dybcio <konradybcio@kernel.org>,
        Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Saravana Kannan <saravanak@kernel.org>
Cc: workflows@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, linux-arm-msm@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, devicetree@vger.kernel.org
X-Mailer: b4 0.14-dev-f7c49
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773173756; l=1365;
 i=mukesh.ojha@oss.qualcomm.com; s=20250708; h=from:subject:message-id;
 bh=lNXUiyOavxpH+nkJAUsL6tXwgIVeayDdpUTtrMGpbN8=;
 b=XhDH2w4mEz3MQsVANAQsn4u6is7j4U79l+YZiSzviUo/lRPaV+eAvCHeg+LHm3FJEyUmXtITH
 h7lwIX9gOjtD4Zhh82gN9bDOruCNJrlOfEq3jVS3l0UVOlydRIeQN4F
X-Developer-Key: i=mukesh.ojha@oss.qualcomm.com; a=ed25519;
 pk=eX8dr/7d4HJz/HEXZIpe3c+Ukopa/wZmxH+5YV3gdNc=
X-Proofpoint-GUID: o5y209pBpwrThO_c-wj_xUAmYzdl-zf5
X-Authority-Analysis: v=2.4 cv=D7BK6/Rj c=1 sm=1 tr=0 ts=69b07ce1 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=sIx07V1IIwI039IRSX0A:9 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDE3NyBTYWx0ZWRfX31hmjSVCE62y
 Alxl24qaiZSpmhaIB3FNPRshGAA8XU4lwBXulKrVu1sfIn4qtDPneKpFScFAqPiZZ1ko4M19qPQ
 YRbeeK/GfhV+vOncMtQXtj/O28LxB25FJSahpBbJXGxOnth6JuTee3wi7R8qzofagvysnq+T63F
 ApWgx0DZ3b36TW8rk2bjpylAMVHaXq0M5b8uDqIhgxbvNwaVttzrqBggj7nN4d1sIyr7QP/xbOr
 ZlFDDaaSjSljJZDMbZPlkwnm0ARVRmzNwu8doqmgL10TsBuJEMau2TAL2UnH98Gvf3hr3C/CNm8
 S877EcLjB2srOYGJcAaiMWK4Q+fWodohWgGTw/O0o3rQmGDF1U1B+dKSVHA8sgOMA+FY9yj+KLy
 aRDTCoY6JDwUqzi3E/SLds1TI3kOn1Yx1r81GB/PKTX7ER5B5j7AKNW2jzeL3BkWFKmUrruZOb4
 sIPTtVQRWcYQnLAsoaQ==
X-Proofpoint-ORIG-GUID: o5y209pBpwrThO_c-wj_xUAmYzdl-zf5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_04,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 impostorscore=0 spamscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 clxscore=1015 adultscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2603100177
X-Stat-Signature: 7hz3crz66uafjj3pay6dhxdc8j65hr9m
X-Rspam-User: 
X-Rspamd-Queue-Id: C921D20004
X-Rspamd-Server: rspam12
X-HE-Tag: 1773173986-556792
X-HE-Meta: U2FsdGVkX18/k75ZsTrltz/puj9GcMHxSkMa7TU2Hp6DEHDsOZRl0jM6MxUAPjFcSZme9LomaAohL2oNKMe2s02wBB4DJOo1kkIUFZpyiVNbng9lve4PzvK65gS0vSAu5w06wfZgjZVmjmSZmC5+UhrTY3Y8fVCvuqbnVdVuUzivuvuY3Gj3ITGnK0mN5EkUYURvjb3iEA14BYAQBERwyVteADMbEY782xqkw3Ba3TzlNsc+J/d+o9Xnc/TU0JwphOOL60XJcytLoArAZbMpenwU8lBNV4PZdyqVEfMHre6CqlzUEtz8r57993JBoPjz2l2zwveezYmkhjrP2EXF5usJjT0ZlhHNYD3ayPo9Gl0wvTrkbioy6ck1KnKKOPxZALCMqjLkAi43WDAK9OSqkMcOcFkuWxs0/ivMqMmx+2x/8WmUYiM/HKUdmNguOjac/SS6tAXohwEQ4Y6yFRD314akyMyiJNx363XwY2ILm1W1eX+ZW58SUx2GCBmdz/d8Vckye6+Eoihp2J0gtmTKxDzYPimZzzQzdAqjU4cwSU0UnUJHri4Ln+rjNRt58qFSNFNIedoWh7ZWoE6ZuJCsjU9m4IC/3Gjhk5bBS3J5b16T0NINKLcF8syOWxns7URDO2aD14Li0AKI36bEa/Us9wIVwR5AbbZXEjUuDwSpFGVSFZGA//a451ZMxen1NzsO3bkcCat2Q++1lkfI5f/cFdGTM3VqxCLnSqKb6z4zM+dpLX0I+8DUjXugGWSppK5eHh50yLZzI8hy7/+/5iZve9GRfsMtBZa25QwBYCkMDxRSRLLw8uOCgS9blpBXphXau35cW2/Vs21SkSHh9XM45mZ/N/oAGBF6ZG4CZHuVvPv8iqr+fjWfP5XF6u/3Il1pHHaJ8V335aooo+tsV52SUhZTSlSNnfe1r7c5QqDOjToiSHgRgaPE8jz1wiYwgUY8LxfmTeJUFZK2c9cdSvK
 XzZ9G+vZ
 IM7UR5m1aSYS5wApDGuQ0hEUS62a2tbM6+EhZD8fo+teM/xQmOZQ4W+dd0fOSFMxjscB6LR+MLNdbruashTCLHN3q5XQhuGlBLQp0PNj9uS6hgFDaSnXU0Npb9B4LOjUQG3Jr12CpsnvedO6KXQIU04yxWpPPw/L7FrYkbaF3yH9Csa9/OIVRKwd1q7tnjo8lkJWjhKKcJVM3ELgMey1PfLiP2uVvUBvtPlZZgON/8mDZlGuqvSQkZlDv91uZ06U2mYNO2bKI7tEyIsOupkIrZHfAP+qftVpgCwVzwm48YzmOYZtv2PdyWU01JpErFvSRgiHC+A8cbfwW7TMNNrA6+8YoOQrbTe4V97/KXetHggVwkD4L83yBKPR9cqe0kS7EgrKej5v5CSrYwSkrgYtZZTbIGsSNGV0c5LqNAED1xUHoH5+ifyRyViiSfnMaGFEpQ1k+BH2aapLAYOmyJWZrmmFmYOLvUVidCTMz+GWPtvhdFH3NV3y9Uwejb9ph6WLfa6Gfvoyt/vHAeqvKgR1GLm8dfrhuc/0Jjg+Vyv8sF3boFLJmH45IW6YyRiUfmksmj1hbMvB0AmOyH19wmZDDCgnEZm3xQh4a9B4ZByseI5zbVtLpmJZ/rOrpMt62Y+q85unrSVI9uEMLhqhNmGzlHF19Og==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Eugen Hristev <eugen.hristev@linaro.org>

Annotate vital static information into inspection table:
 - tainted_mask
 - taint_flags

Information on these variables is stored into dedicated meminspect
section.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
---
 kernel/panic.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/panic.c b/kernel/panic.c
index 20feada5319d..ea1969d81fd9 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -37,6 +37,7 @@
 #include <linux/context_tracking.h>
 #include <linux/seq_buf.h>
 #include <linux/sys_info.h>
+#include <linux/meminspect.h>
 #include <trace/events/error_report.h>
 #include <asm/sections.h>
 
@@ -57,6 +58,7 @@ static unsigned int __read_mostly sysctl_oops_all_cpu_backtrace;
 int panic_on_oops = IS_ENABLED(CONFIG_PANIC_ON_OOPS);
 static unsigned long tainted_mask =
 	IS_ENABLED(CONFIG_RANDSTRUCT) ? (1 << TAINT_RANDSTRUCT) : 0;
+MEMINSPECT_SIMPLE_ENTRY(tainted_mask);
 static int pause_on_oops;
 static int pause_on_oops_flag;
 static DEFINE_SPINLOCK(pause_on_oops_lock);
@@ -827,6 +829,8 @@ const struct taint_flag taint_flags[TAINT_FLAGS_COUNT] = {
 	TAINT_FLAG(FWCTL,			'J', ' '),
 };
 
+MEMINSPECT_SIMPLE_ENTRY(taint_flags);
+
 #undef TAINT_FLAG
 
 static void print_tainted_seq(struct seq_buf *s, bool verbose)

-- 
2.50.1


