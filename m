Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA4AFC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 05:38:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 871096B00BF; Wed,  8 Jul 2026 01:38:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 847CA6B00C1; Wed,  8 Jul 2026 01:38:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E8C86B00C2; Wed,  8 Jul 2026 01:38:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3357A6B00BF
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:38:53 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BBF2040692
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:38:52 +0000 (UTC)
X-FDA: 84964505304.24.DE9B725
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5472420002
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:38:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=EL1hUm14;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=eewcK+j2;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf13.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783489130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/X3PuP0EE4zFbYmFK+cTACEjEy2NM6zeM7tRQiHecKY=;
	b=1ro5DqGUBVvHpvUXN9LxUZLY0NaQ5k+es5ORk7zgKhY9pr8Y7FT2quF5/iqDjvwzUZ/Nfc
	q1qRer88jiQSkooUAWO3B1P2+aRFdfGBINsJRT1HVN0mrVNp6CUl1D3Yr1hmrZXmiZX+ep
	gUKnDlybhbo9OTA/aPWUw7DzbnBwx9A=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=EL1hUm14;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=eewcK+j2;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf13.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783489130;
	b=xyX4Y0uYrNaQMdW9IU4ToMhoxXsLgp9CUYgTo5n84DUvCCLKfWo5OV8p40kelCoCYYStoL
	nF+MLbJ2aBlEKUcy2TcUorMzvP7+eadJx/kO8JGpq+RB6x1uz88Omz3ehj02AbJqbuJFGG
	F5xnUU8eoHV2t5w9M/dfFImWmqvvHC0=
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66842aZ11491323
	for <linux-mm@kvack.org>; Wed, 8 Jul 2026 05:38:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	/X3PuP0EE4zFbYmFK+cTACEjEy2NM6zeM7tRQiHecKY=; b=EL1hUm14z7DQ/aie
	toNLc4wir5Xb7/R5+/n78Td6Qp5uABES0LJgz4U+ZxNgO8BvtYeOqdrL5eOOVSFE
	m5PoMxOtc0Eaa2+A75pDlYyY6cjeVwVkKOX5uod5btMfqbbbcweOq4IaKvVAPzp2
	MRIiAN2E0zt9hOIDizdPd7FV568FNMWtqI8aL3Frj/zkRyFC6Bw0lg77CueNscoE
	u9DYL0J732btCGqOW6qoCVurAKfExy9bYfY2Q9v//RR7PJszsZSKyEK64fzA/ACN
	xniDwxlXOLHuncXkbf+VtRHuPf93pMMKWEbkIBli1yE/kw8mhtGqMmEkqSnV7Im+
	Xo2Lng==
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f9b5g955m-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 08 Jul 2026 05:38:49 +0000 (GMT)
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-84770f89b99so575251b3a.1
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 22:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783489128; x=1784093928; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/X3PuP0EE4zFbYmFK+cTACEjEy2NM6zeM7tRQiHecKY=;
        b=eewcK+j2k70El+MGNPqCBuekZO9BIb1l3SrXVPlsS3zvH1esMNop1rcSySE8vNxVDe
         v0TQSWaac9vBfSAsZ60fmkgJh6X2At3Oeg3+lxSpb09XeQ303f8pCru2fDFm1/LDyWz2
         3Vzv3GWQYcKlsc6t7pMTEC6TwBeVJL/hZy96Dcnxw9/Qd8WjgBBub9MEm5cXded3yQMA
         ZzXxzqEd8QXioxv3WjKcCZtvxTqpuvp0aGGjilM4WPkmdmfVEUD/+YwDsH01Er4tzygR
         xMsM13W9NLUOd65EIAuOvFdGSFxnmDSjRpOutZvlp2ugfRNi0ewVtfmSbYhPFFvQhBpW
         lkqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783489128; x=1784093928;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/X3PuP0EE4zFbYmFK+cTACEjEy2NM6zeM7tRQiHecKY=;
        b=IR5SKYfNsF4JgnLGAAgCBu0MOCTf54e9Opes/Z4Vtd6ggQovJam9j0lO/O6p7P+Quw
         tFazzUHuSiUuUEJhQmMhzXraWbEc7jkjbNwrZCVoo4gBnl6sOlvv9dk3SnI9JdvIzM5n
         LGL672jJ6McK0uovApwnqxWOvIn1zYI86q2u5AS19LC6m3P1azPbkLlbkkn7VWQKqzB+
         lucTnpSo8sHnKdFsGzrbO4Oz/zrNHlS77XWXaOdt7rRa30C35i/Vr746mmGxZT9YKYYI
         /3yCZKkfzPAsjOdQrhyO9Hw9oSeMsm3Ac+bhrcmhP1ww9BqPAnzbkYVqckV30i2cExUd
         oy+A==
X-Forwarded-Encrypted: i=1; AHgh+RprKf5ZzQ2PlY4VEWDr7keRGewFYuhRwOgijQ8xeec7BnI1s4v2EkHY4tHPeD0XI78zJI1BlGvJGw==@kvack.org
X-Gm-Message-State: AOJu0YyMxIjb6aP4i+m+nTjOlhglnapPtnnjEhpeVbUAXxwREW/qCId0
	DJBnLB1XNxyrZeCzW7a14xpixLoC8uB+At46jKcArLTMxU9XYcpRzgveSiPbZEpwSAanYACI1B3
	EuCaQmA2lGz0aFrYdA8kN488CGFp5i6X7TOYpMHJc+YegsvSv9EtgQQ==
X-Gm-Gg: AfdE7cnpGwSmvp2KCjjYLDbqOCi6jBrWFEOtYNYIw+xCp5AZN8mK0w6TDiQdiP2Li96
	aaW/4PRAbgBarwGUP84H26KrYNWK7oUoxW1/pH3LKqu3mIt9JEqt2cUCK4pPmFNLriB5k5gwky/
	DIiz4gd/LKw9qBuTFrBhPU3Xt8QoT7zspVCMaboiVGfY2jQH//VBbU+EKaftnfwsyfwDw/yqfVH
	Ux+oYIS4iJbfw5a50Xjh/eQAN/VMKbrmWNNTJFVTfR0471QlQ71f+7I8GuvSmrNB0JcPAr6oHSN
	RronNMlUYV7vt7kfdQEiYuA0TdzFAGj4jHfVW/AER71Opd7f7ko1rBH+7jwkRp9sag9Vs1ohChU
	hou37ALw2gvNcdcETLMkhGlK02fjzNZhIvBJWuA==
X-Received: by 2002:a05:6a00:1992:b0:848:2aad:3393 with SMTP id d2e1a72fcca58-84842fd495emr1090487b3a.44.1783489128286;
        Tue, 07 Jul 2026 22:38:48 -0700 (PDT)
X-Received: by 2002:a05:6a00:1992:b0:848:2aad:3393 with SMTP id d2e1a72fcca58-84842fd495emr1090447b3a.44.1783489127740;
        Tue, 07 Jul 2026 22:38:47 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6db29d1sm6484592b3a.53.2026.07.07.22.38.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 22:38:47 -0700 (PDT)
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Date: Wed, 08 Jul 2026 11:02:04 +0530
Subject: [PATCH v3 25/26] dt-bindings: reserved-memory: Add Google Kinfo
 Pixel reserved memory
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260708-meminspect-v3-v3-25-7aa5a0a74d5c@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783488714; l=2504;
 i=mukesh.ojha@oss.qualcomm.com; s=20250708; h=from:subject:message-id;
 bh=EqDXuZR+VwoiCHQ8MrohT0WWo31+t7/SKpMrOr+qFys=;
 b=IlHziXitcvmT7aPW0vG9xreygnlcWjxZOdssLB909oS1UY6NFTJQZL2kltBAv7qt9PX7Oo/km
 XzLe3BF48Z2BxC3z5wIZKkBAe17AW3wGDH17Hjo8UngU4VxpQsJGmSU
X-Developer-Key: i=mukesh.ojha@oss.qualcomm.com; a=ed25519;
 pk=eX8dr/7d4HJz/HEXZIpe3c+Ukopa/wZmxH+5YV3gdNc=
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA4MDA1MSBTYWx0ZWRfX7l9G+JCSzzBs
 lXvHU20NcsqMm9/mCcUfilOP2BPJCUx0PwvXFle/E2K+Fj2+x/OnyHbnjoM94296j3tCOkjtT1z
 dhbSP4ewsHpxyy50OoIrEoaHnEgd6Xs=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA4MDA1MSBTYWx0ZWRfX4bz+nsHsIUNs
 a65ga5+R2z82HGhJPsYoaTdeGnc8fxHzMPmqT+CGCoDANU0rB+JkpvBYDYbx1M3DsQaRCKHU1xa
 N6viJgDxlb6Pu4sl+/jG1lO85loNDQ0NtdBcQmmrFIEtuDzPMahqGTBMFGPCuIbuil8VTqLhQV3
 5BwsWiyhNQ/8bVrxcxKvEkBBhkTged/hu4MdI5M4QtwBwB3iprEgoLVWY9UkzDCKf5qa0O9VZqj
 Ip8BiYBHeGIo92w/IRmGuUh0ufiLwp8DOdmFyuGf9Vj6lnIxms3ABpR3whAZEfn04qEg2mvhe9a
 oV85xS6mP0ZjgNiRkq5XubFc5S1Jq2ckAHL0iuJiqtuCCGsAjnwzUuI5iILqdCgisyDIcVcxYh9
 T4EBRPLNAtU7w6wrZrgQQS3VODMBYfNTUMsfOPmhPQwMiLaJslaqgoy75USIam9ZFsfZgtvxQ82
 yuNAADg1rzGvxJDqAKw==
X-Proofpoint-ORIG-GUID: bAZkG1LzPC6KbTNJJWG9U0xaiLpvZ3a5
X-Authority-Analysis: v=2.4 cv=JLULdcKb c=1 sm=1 tr=0 ts=6a4de269 cx=c_pps
 a=rEQLjTOiSrHUhVqRoksmgQ==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=gEfo2CItAAAA:8 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8
 a=37rDS-QxAAAA:8 a=iNqdCcJJzjlvehcLF60A:9 a=QEXdDO2ut3YA:10
 a=2VI0MkxyNR6bbpdq8BZq:22 a=sptkURWiP4Gy88Gu7hUp:22 a=cvBusfyB2V15izCimMoJ:22
 a=k1Nq6YrhK2t884LQW06G:22
X-Proofpoint-GUID: bAZkG1LzPC6KbTNJJWG9U0xaiLpvZ3a5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_06,2026-07-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 lowpriorityscore=0 malwarescore=0 adultscore=0
 suspectscore=0 spamscore=0 impostorscore=0 bulkscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607080051
X-Stat-Signature: c1efrsfzxnm19f3oh9raeps7hzmykjm6
X-Rspamd-Queue-Id: 5472420002
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783489130-92976
X-HE-Meta: U2FsdGVkX1/i27DjatwAIeMwZdZLngNhErAD0ugN4lEF/sQtq+BJgkVNrLjPuQdCv4jT3epHk5ods3J1bONZ8KvNR/ncS7qVYG0P7wS24pQtXsxB/W14/xjVkfw5m2xHJPmYI9GW0bZu9OyA8GaxbVDbfTt/4dj3sdIFuMCbjQxxavay1R5FqE+7zynbLVGW0E4oQ+X+F5xcJjdwkTOE2Jafjr63J8z48WC5hWwTev2q/R93hyYr0g5fdvFhh8wlH+o/n7iZlbUnm4xogFnzqswuG5E3Id5WPIiPonp8UgjoEDq5DRDwsw91sNe8+Dwph/ntVUcg2Gzc8QtOvIXJ3zhgcN4+PcnID6qgIlhaxzqL5ceawqlM8s4d+cd4U42NVKTKqtkzm1L3jHjJpXb0w2XD6RTBOWyNgn/581Cp48oYlyTDGB9SS2OzfEOoPEQVcLK/ZS/dV1w6lGYRsx/PvOu65f3uIZIpbPQGlb5kjXFuC8AKLlvC2qFFwnYqLuo3P7aOJ4YCHyn+P2GLK3HMDYi8N2mmAvqFjdqUe6/6aHtvQWxVZrRNhuj8XwCPDtKvlfXEftQpSK6GnJ2wcKfDRsCDQLlnrm2TlABDPI/vSBUt9ktn6yVIO4nPQrKnn5sXzr+4HsDXxxW5wNaoNhhpZHNKWKowVcIIr46EkEQqRTJ9enZILluotsJlha2Nm1OpJkOP+qKMVLUlBLQrFR+JD5HqYvuoiVasz5Gm6BT6WcZ1YTZ5mMyaFZfY45Jue614GTbu4TkKyJB34bkPUzKynkQ9JZLeKTbJ6BKiBINKnk3tNgQiAmU3ILx3/pqFOMX2Ib/5sK1J6Hj1q7757K1OSwzChU0lTJeKNrKko+b3LfIPNwsh2swETQnnHAtj6PrHP8iVlsrZHC983CGpJQI0IWjgavOE5LmgAZma8m3EXHFqgR0LDKOEusXm+6qo9JaGNZqJi1TZ41T5YkEi3zf
 9bnLUNTU
 RGnnIsh58Oe4NY1tcgP4CufjLs5qGDEa+vItyclzNh/bov90Ymwp8AzPYZl/NgrOD0NKYJ8OP+GrrycQvt9YPOh4wEzNYi//vL6LHXcTYTaNoy4KvsrAD5sHIA6IHiy9ymEf45fozAPnQ10P+LFiYCmXXJOsd5W7R7egLrzEUHpDP06cYmZVlJXdNaeaNT6NOAChXh52TUb22zLWr194ClgUmX64mCFP8sV/KKbFSps4RiZUciWdzKNElF/BE8swIf6PJFYtjGzETIMYoPxobde98elDkTm2XQCMWBWQyrgNU/HRjfU2HiyZyOwLW/fI5lwwDBOFN5iQT3sRCF/fRaYgiVlA5jxLCqekdJZtVbDxzexWIlah2VdkfonCAoPUUBFQxcS5zBcSmwrIJ9XPiucmM4ofA/7zaWogW5dxk+qI7wtjEOAyaan1MC5UsIBOdN60vPpIp0f8/wxu3ia3fYxTO9jTfVvScTU5MLfn177hG6UhtCL6RinlrdkZGaKR7iTcfuU1HCoUWDGHgdahofmBF7x4LSQuEanRrVIDGCWNIj4GRQ96dL4meMK4Q6OAeiUq96PedkJ3WaFYcH7nrhkIozcgdIAIQz5dirzZd94h3radj9OtDH76Am3MeLdGJdSPlJTDeYenalSO0vHxE2PWkHuwE6RHHdJQS8nOhXUxigAdNazTX7sLPIYhxWdxrpcQlH3pIEaOys5sXNdPqNsMgoaXvcfeWJ2dfwOK6FTrLnVyOfFJpugs5hQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add documentation for Google Kinfo Pixel reserved memory area.

Co-developed-by: Eugen Hristev <eugen.hristev@linaro.org>
Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
---
 .../reserved-memory/google,debug-kinfo.yaml        | 48 ++++++++++++++++++++++
 MAINTAINERS                                        |  6 +++
 2 files changed, 54 insertions(+)

diff --git a/Documentation/devicetree/bindings/reserved-memory/google,debug-kinfo.yaml b/Documentation/devicetree/bindings/reserved-memory/google,debug-kinfo.yaml
new file mode 100644
index 000000000000..d260c2d5f70b
--- /dev/null
+++ b/Documentation/devicetree/bindings/reserved-memory/google,debug-kinfo.yaml
@@ -0,0 +1,48 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/reserved-memory/google,debug-kinfo.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Google Pixel Kinfo reserved memory
+
+maintainers:
+  - Eugen Hristev <eugen.hristev@linaro.org>
+  - Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
+
+description:
+  Reserved memory region for storing kernel debugging information that
+  can be read by firmware and bootloader on Google Pixel platforms.
+
+allOf:
+  - $ref: reserved-memory.yaml
+
+properties:
+  compatible:
+    const: google,debug-kinfo
+
+  reg:
+    maxItems: 1
+    description: >
+      Page-aligned region of memory containing debugging data of the
+      running kernel.
+
+required:
+  - compatible
+  - reg
+  - no-map
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    reserved-memory {
+        #address-cells = <1>;
+        #size-cells = <1>;
+
+        debug-kinfo@fa00000 {
+            compatible = "google,debug-kinfo";
+            reg = <0xfa00000 0x1000>;
+            no-map;
+        };
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index fdad8ef377c8..2d816d783024 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16901,6 +16901,12 @@ F:	Documentation/dev-tools/meminspect.rst
 F:	include/linux/meminspect.h
 F:	kernel/meminspect/*
 
+MEMINSPECT KINFO DRIVER
+M:	Eugen Hristev <eugen.hristev@linaro.org>
+M:	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
+S:	Maintained
+F:	Documentation/devicetree/bindings/reserved-memory/google,debug-kinfo.yaml
+
 MEMBLOCK AND MEMORY MANAGEMENT INITIALIZATION
 M:	Mike Rapoport <rppt@kernel.org>
 L:	linux-mm@kvack.org

-- 
2.53.0


