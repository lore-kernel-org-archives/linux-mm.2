Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6067C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 05:36:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 891F26B00B0; Wed,  8 Jul 2026 01:36:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86A0D6B00B1; Wed,  8 Jul 2026 01:36:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 758E86B00B2; Wed,  8 Jul 2026 01:36:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4939D6B00B0
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:36:46 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C8273A067E
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:36:45 +0000 (UTC)
X-FDA: 84964499970.01.6B6E122
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5851F40004
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:36:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=bY7gB7vt;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=BJmtvGAT;
	spf=pass (imf01.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783489003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UqTfYZuS5v9TxvWd8p5QVvgMLn1YG1IPnoC+xwtJa7I=;
	b=53r55R0ddTI37fkAh2hX3pP0IhwMotoekoWuFQELhxS+NXwCgFOqEx+NE6lJMlvSoEHM4x
	LaiY4Fs0lXb3gMVJp728YlJDRWMGTPeTdVdyG5knIV6yrGf9NLIyL1q3rs3mvfj2vUS5jr
	af222PXee5ttjWHZd/jVuxybe1Oe58I=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=bY7gB7vt;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=BJmtvGAT;
	spf=pass (imf01.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783489003;
	b=X+cwqxoGcMXxKhglslSNPVI3EV5SBx5/ISmry7P45cGufj0tnPwD9itJulVHDBHpHerKOn
	RLGJZC0fx8ka0GkuvWRt+n6ZAuBYlML8pUoS0zGmDsiG2uVsC7YjWRy51+el60bqLRS7QL
	aRGcY9SSpgsCzcLpUoC/1B2VrDBP/20=
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66842hGX1625066
	for <linux-mm@kvack.org>; Wed, 8 Jul 2026 05:36:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	UqTfYZuS5v9TxvWd8p5QVvgMLn1YG1IPnoC+xwtJa7I=; b=bY7gB7vtGS8iufzp
	Aps8jeKcX4XgrAJWi3U8RG1DNWLmc23/ZS5++izX2zXirGVrH7nHEhYlRn42vY6i
	wGhTFMamIDLJoj3sUgqu6VBwoxT7ZVJGKkPInUh/xbag4Ja8O3yK2XKc0m2L2zfg
	kB15s+RoFoP4iezQSUzk8iCZFz6w+ddGEwklrZMf2jkdbOd7U2f5I64Vo2EZHR45
	6coNpwsO3rlnQuL9jAqb6b3WJUSaMRwvXcM2wNosfqs+DnOyFsS37ELYHTE3QCn5
	8qwWqZ91PSGQzaQV8mWRyyzhsc8FQ06P9/r9HAG/4mej+cAA2O4p9EyHAW2D28g2
	uSjXMw==
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f95fd2tup-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 08 Jul 2026 05:36:42 +0000 (GMT)
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-8479c6c6cbeso403074b3a.0
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 22:36:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783489001; x=1784093801; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UqTfYZuS5v9TxvWd8p5QVvgMLn1YG1IPnoC+xwtJa7I=;
        b=BJmtvGAT/j2YNrpj5NduPRkYbyL75YRs8A0QQpuVg8QYiXt/PVl62nda7uKy4qZnGP
         MRgekV0/YKQk6zebDZFrnHxbrm9NslA02jHldFhB4CUF24vsb7W4G0TAyMU0FtgiHH1R
         GtwWaZl/VNmsjNpAkkEgjM/OXO70EB7vZowri4tuptdiGX1ZKniMZEJBnsp6P9CAOxvS
         SyrlokaHwgT72OH7aWxPK+SatQKpmTRGGI3cg76enYLpsYruwE/uHWiv5fab0ekITRxS
         UJp9LLwdRDWL88yh83G6Z3JFSBAWXET2wEgSPRtYJHgOOPl9bCJnfsQnEAP4FHcGpAD6
         khxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783489001; x=1784093801;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UqTfYZuS5v9TxvWd8p5QVvgMLn1YG1IPnoC+xwtJa7I=;
        b=sC0tLUyUbCkPdd1sz6UHzWNmHdqJxGclZOrYLmGA+hcvfqEQ39nhZ8qedOZ0gn14YL
         DtWYHY8a9X1O+HhrdESwXpbcz7Gdl3EZffCrvOxda7hewT2j4FKHbmVnU5KyA/v7IDrd
         3aziUrU3skzkIc/uQEHkCyfLZ/Lge8labXoVZMSlyr0IhUD4n8HnFlmZ2qoG4Uv7UvE/
         wmDVpK3DvYgeb1DGtmU3lB7dj4M6gVaxPGmJry/5rvO1m7r0EfG8RmbbTzyD4IbKoEBM
         8aHAlc1gG9pwJBEkEfxlkx5xaq/pY85jVpvMkGreP3lVGMlMQF6yp5iJ36vwz+1MI1If
         ZXBQ==
X-Forwarded-Encrypted: i=1; AHgh+RpN12297d2jVWGBehskzzN3BZeZHBzZdu/0dwZks8dhURjmwN5B86dJ7he46ztVcMB4Jx4nIg7F7g==@kvack.org
X-Gm-Message-State: AOJu0YyXDOWs6UuB/RgGrGnYBFmZ+m92BnX+oKTaxNwXOlWEXdbpjV95
	t5PATzG/e9Zb/OBjASDrt1A/+sYEmtYT4YOy8EBKC1GUDuG+c+lt3ygKGahxOvTTcTg/i/I4EBB
	8RwqK0rkumJQIMi84+f9FGnxZxFIoMFdoc+D6tcPjoZ1OjwZ/73i9lA==
X-Gm-Gg: AfdE7cmVUaC7e9gUre2OWw/jcFWdHaAKPqVfnRAPOUnXufiEZg2En01fthfKSKyEBBg
	djj3rQ3a8Eo1R73k++OwukWurmGPsNKpAYX+kyI+XLFsRaDiHcFS/v9rAueTPhw3xgponA7S/Qk
	NeVf8g9mcxB7xqcQpo5mkgQOl6N7aQ2etjLqWs9nrPhWY0sFzGDr9Hk69ehSqtmfutAmf9Qxf+G
	DnzFN/0fRzvOA6POCchB0FwJheCW+yWbln0ik8eFKcDPAPe33T2V/cxAQQEDiS4PKnKqw46n9Lq
	AoxVJYsiE8n4NQ6QeRfgS8b6vUSIZroWfIApATi+kglnaa+6v1+lCfW3hUYDeLkqE/BwGIMnjDt
	M4ekvudPGvvFeUYOC+8Imr4gFTBENnF1b/DvUOQ==
X-Received: by 2002:a05:6a00:2e88:b0:848:2f71:b661 with SMTP id d2e1a72fcca58-84843000749mr1202821b3a.76.1783489001214;
        Tue, 07 Jul 2026 22:36:41 -0700 (PDT)
X-Received: by 2002:a05:6a00:2e88:b0:848:2f71:b661 with SMTP id d2e1a72fcca58-84843000749mr1202755b3a.76.1783489000489;
        Tue, 07 Jul 2026 22:36:40 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6db29d1sm6484592b3a.53.2026.07.07.22.36.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 22:36:40 -0700 (PDT)
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Date: Wed, 08 Jul 2026 11:01:56 +0530
Subject: [PATCH v3 17/26] mm/mm_init: Annotate static information into
 meminspect
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260708-meminspect-v3-v3-17-7aa5a0a74d5c@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783488714; l=909;
 i=mukesh.ojha@oss.qualcomm.com; s=20250708; h=from:subject:message-id;
 bh=4qnpCkPRiE5CsuQx1UWQEXlwAhSangPKX8XiWfRWTRE=;
 b=z97EtvKBT6y9k21SRqlalAiHkntvPI/WQIsgr0jHNuEecXk60Tdz+odDPSt9xKDoeipWusU9X
 d9152pff/1jClPE14SdlYcsdmZc6dXry9myPmuVfXbE/BcULjts2es9
X-Developer-Key: i=mukesh.ojha@oss.qualcomm.com; a=ed25519;
 pk=eX8dr/7d4HJz/HEXZIpe3c+Ukopa/wZmxH+5YV3gdNc=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA4MDA1MCBTYWx0ZWRfX6mVsnjLM9Tmv
 8QTzw4hAmGq9Vm2MuFckwWWdRK6+QmDR7BaSsQwC7bgD8+EjC4H9ib41EWy8+yIhoEeL9aJU7wk
 S1d+Ku4hudtLhyi+WwzUchns90isX2GEFklTR4BkBxuq1K6T3jTmNm44HUx3obSL7I7Mgg5r2Oq
 DSFnrHSnZnuLS6AckcmKHJL7uzRQAu9BzkvWrCpZRMr/WaysEWLIm1O4ZwyFK/eGC0DlP1tENVs
 AFqCExUuoNtv6Y4taOMrvQcL1Dy0+ocK3ZWwhr0wLXpZew/Ef6LOeKTMn7zczyLenOCetQjkA75
 MjmtQQlduJW7P067xkfAgTYSk6IXIP0SAdLn582y9xHzItbSw3XhbUkzGYQ2e6o/9f5ByqsrMhx
 OW7LywaUn1fa8u+fkc1Pv/z12mybFsMv747PDtQm5j1279rYkBGA1g2aBiBPXje3yk3s4aSceZx
 IfHUBgkBnRF2D8mFQpQ==
X-Authority-Analysis: v=2.4 cv=VZLH+lp9 c=1 sm=1 tr=0 ts=6a4de1ea cx=c_pps
 a=rEQLjTOiSrHUhVqRoksmgQ==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=VwQbUJbxAAAA:8 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=R-PfVeyQBJMsRd_P_MAA:9
 a=QEXdDO2ut3YA:10 a=2VI0MkxyNR6bbpdq8BZq:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-ORIG-GUID: eJ19Q6FS1ECfdHsJG2q7LVzt0y-34n56
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA4MDA1MCBTYWx0ZWRfXwyO4Euhs/8qb
 6BjQ7u/oKJ8jMbSXYoQnBhldPIQ3iBzqmnU40m+4V0b9T36RC9Lz3WZPrfLUOzrxkI8hbgomx6A
 6/LJpIkGRCFAOVnDLyTM441/gfTcLtA=
X-Proofpoint-GUID: eJ19Q6FS1ECfdHsJG2q7LVzt0y-34n56
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_06,2026-07-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 bulkscore=0 priorityscore=1501 suspectscore=0
 lowpriorityscore=0 spamscore=0 malwarescore=0 adultscore=0 clxscore=1015
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607080050
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5851F40004
X-Stat-Signature: aad5xkcutdyipynuqphdgwhfcf5cba6w
X-HE-Tag: 1783489003-25029
X-HE-Meta: U2FsdGVkX19jg2kCROCLXw1KZclPTGb4yniEQvMM9/a3sm4cq9rjCvba0dJ+bwDwQiBqgx3d30pwWPjr4xy+/6l2bN+V+jXBCNfUeKoq4YZo0Nj8mzQHNLVN2aAIwS+7NivAlzXvj32SNR+AyJJOlYcj0Ao+AorqDPY2FxTBKRbCszsJylk0BIvWLJNnKfprC0lIA6ZW0VgXafoOGDCq34ofmiPkjmreZQ5rKyy2L7ESvWyZ5ZcCueYDAX/griqczU5nkYpbyZuP6lhTWBA3O7D4Su6OIc9Nse4BQpOl6QQE8738RGxxb2a7uuBiXQliaTQdXLdmKtdsCl/o3Sq274dA5+viTfovH6i8zI30yboxFBNTxOPrJefdmPHx0Bw4xC/YtVN0VUfDsLjulI3j/ZS0mc0WfTFLj089lrcCBwijN7rTjuupNSwFDKcd9Emw+NWXLNsbffcJJHOmgs7dXpajEX6gjofsbpgrbvyc64m1ORnHmOFlS8TJIBVJM6lTMPTW8p8u3mITw8ltRPGx6G1Tmna3/x2biuvCwLTu2x4b7hY2Obom2p+zitF7WiLvXagnyW3p1esFUVuZ+lB6t/qCThbnguVInF4RHIPQWE8OcI1x/5TR9GZEit3Qqlqk58p2a+yXqOrm9EanSnPIDXBldjnbY//dsDZCJRGA4pPgHnVZIB59P1gfX0qQfx7wvUMsKpiUmh5msYSNZ1Kt/8pEdEHefcnGgKMrJ2kRQQgejX/usCUHPVouUyNleqGrJrPWeczoe8/jH2pYEbYpYvxjx9WIliIPvADxBNY8edLTnqP6frPaz1aQsBNCEd8af8wCLU00T1heXEeHwVgvLjyW/a693HmEHiD9bLzWljTLyU+PvMBUkVqL2lxqLYR0vA0lvQTef2p57TgaQD5tB+PNLv0st3PXRKy2OiHJIQmvZ/Td+dsLSdZp4PIDn4KR5u0b3BCgqdFNo7VEWQd
 +E1W3JsG
 cd4+rKLRjUQSBTinzDkZLaNbVc3CFz69V1uf6Zi4dAIJJTAr+73WUCK2uXz0Zz8CNOvx1jTpX+YnuZqoFICDy3qgqjJuWAf6olqGTsJfhPUufKxzlz2lPltUkOE5QVMTHwDPudwrn6b2nypZLpIenbLw5lsT8Ux11ISIatWyPELsL9EUnElk3lmMxKOyXRA6TqZNL93jisofU45n9d/s+XYR+jsN9D/bEnOEvi5/rLBrO339cz8SrXxXdhvW8Y7qpH8R48C0pzsU+PVsMKupBtLnXFUBs+2mVLMKqrZVMXpqJJXRuJZYKCqzf2yUwDEOTxYiJa/uDpv3yt32HZnTJIOnapAk3yy/tCa7UUKQLLDvlfzTx1lKvHHb2aTXfFJyeEV9GczZdEJfIuI7EHE/a8kavqFG80E1MaoXDEYh3iG+SZEcenZxSPIx1ERraoaRuogCR1dh5Sk8A94x90TSF/sWAoezpURFokkUs854aUmb4k3AzkMqbai6mD1KnQCb0+nLRoEQu2kqpIIMSAYaZD6VP5u6zjZNbQTOnzno0bJfd3RQCzu6bzKG4sho1hvbRjHExZuqXKQ7FT5PAE2GIARQrKfBwoIvv/8numz6rY0yg2YkGJbBZ0de9krA+zpmw/h8+qX7sE+zrBI9maJnaIH8+OEBr7QLBDIA/KNYy1yIQrnA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Eugen Hristev <ehristev@kernel.org>

Annotate vital static information into inspection table:
 - high_memory

Information on these variables is stored in a dedicated meminspect
section.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
---
 mm/mm_init.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 3ff2e90aa17a..d98b6071d2a1 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -32,6 +32,7 @@
 #include <linux/vmstat.h>
 #include <linux/kexec_handover.h>
 #include <linux/hugetlb.h>
+#include <linux/meminspect.h>
 #include "internal.h"
 #include "page_alloc.h"
 #include "slab.h"
@@ -53,6 +54,7 @@ EXPORT_SYMBOL(mem_map);
  */
 void *high_memory;
 EXPORT_SYMBOL(high_memory);
+MEMINSPECT_SIMPLE_ENTRY(high_memory);
 
 unsigned long zero_page_pfn __ro_after_init;
 EXPORT_SYMBOL(zero_page_pfn);

-- 
2.53.0


