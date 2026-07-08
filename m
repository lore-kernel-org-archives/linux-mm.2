Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF5A3C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 05:36:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D25356B00AD; Wed,  8 Jul 2026 01:36:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD7156B00AE; Wed,  8 Jul 2026 01:36:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC4866B00AF; Wed,  8 Jul 2026 01:36:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 85DEA6B00AD
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:36:14 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0F58B1A067E
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:36:14 +0000 (UTC)
X-FDA: 84964498668.03.5437EF3
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8BC0C40008
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:36:11 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=jIQYjWOp;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=kkjbDekn;
	spf=pass (imf12.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783488971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y+bdn6fLnN4RyU1mq30fExI6NTYfDOdkcveqvmjmCHE=;
	b=z2cXTqOz7/XWzDCNgNJ7JYdM3An3a/grx0HOmmg2J4vf0ti/UlhVTlq+AIQcV+0DYMXNPO
	FFUb9Hpjm8mipadZBuPenDDk5MWYe12dePMkku4l4wz/RxcAWPNFSvuzBos7zM12jCfAoX
	mi3IDDKLM9hpTZB8+X32PL+sCem9y2I=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=jIQYjWOp;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=kkjbDekn;
	spf=pass (imf12.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783488971;
	b=wIdgr0uBSX85lDW6bLfp2MOc+SZSQCpL6n2Vmvn6I/s6u+OTQSs85H1f45HkRb0aD1kNi6
	nT3WUqX3zL4qbOkoEDDD6CeWOjiVUHjzkSoA468fzk3em4aApSqy9TjDxNaUJc0KbCC7fx
	p36/vrJQGbp29wytGdItSYtC2CSi4vk=
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66842aKB1667900
	for <linux-mm@kvack.org>; Wed, 8 Jul 2026 05:36:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	y+bdn6fLnN4RyU1mq30fExI6NTYfDOdkcveqvmjmCHE=; b=jIQYjWOpMdm4Yf7/
	4ZAx6VsUGkkHx0nISbMer6Ogn/gK2G51oS6foy6Mgwl4NbjhK79MVO52gyhU8v4+
	lw+vlWG0mBYq153kmRtblw9p85pGfVTgoBpeqdZ8A6nDtgtpcHmfumsr30eRS9L9
	iwpMpdI9qaaC26l7CgW+S28KPz1Bw8vDhH4rSyEWBFhXFaJ2m9/Yn9YxEFw0L+RZ
	Av9xJ+vKxbgKHJWyxplIeJ82xC/NRVC6fyNpAmMjrVZ1ynOf78It107ASYJ6z3kA
	FSRJ+dnkJ64wUDccTgvDKXl0OIkKNM6qSZG+Z9+vIvUNqnDvu5CwLUQVKhBpYqQo
	6/3Dcw==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f95e5ttqt-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 08 Jul 2026 05:36:10 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-8478947e047so635585b3a.3
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 22:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783488970; x=1784093770; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=y+bdn6fLnN4RyU1mq30fExI6NTYfDOdkcveqvmjmCHE=;
        b=kkjbDeknkVkCV84Q+Bi9oASJK76WaATpFOyqKgOJayLNQ0lklsTryRcXIQLPnW2PxX
         ETkFoX22KlubXtN3nKXuQLKgQMq5AuMesLZEDN/7wI1PSKkm88UdEavfKqC86QPA4SIr
         R3bELRT6DVR/GQaZnz88Iph/q90LmH1Q9/PgMN3kxU0DVLJmxG5w9xY1I/U83FJMuqok
         cuP+cOPNf1Fmk2uMR2UmUDVhOjSg0p+LLP04WqVg3RuuLOjuW4NlnzQ5THaWk2hsg8p1
         z7cFV7m69RPtftviYO3scSLw0bERvue6fefO64wuLJSQC2bj56I+giUKaFttWPpQrExF
         9OXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783488970; x=1784093770;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=y+bdn6fLnN4RyU1mq30fExI6NTYfDOdkcveqvmjmCHE=;
        b=im8FgXJkpnxmmUgGcZ1Lwh0yGbdO9t0BQULpaYGkAou/qCX6OQWSqJHBNtaA7UTFPO
         Z4edY8fbyWDZkokR/ZOlA3NvmXxiofFITNIpFKTDAmo8msloAP6gHgk0r11Ux5eNgaiw
         nToSVJYa74AIaNXG0JSZuQdgf59ntMfu6rx7FEuKSDOqoh/5Lziqy/rLvaiCIeU/ybdn
         RNn4UWzUMFxIdP+VquWTdbGdhxax4Tc3o0rX8VdOPFtN3pGoUwuyFBcsccMN6C0Xkc4F
         FdcX7Dsq578mPzyTuwX5o8bnVwazmHMg42xFXfds0h6Y01ZBEIoV7Ck3RjsUaPFjlzNa
         y9JA==
X-Forwarded-Encrypted: i=1; AHgh+Ro6e1T+FGUfH1WqfEVYoJ579wf6bXZYWjFAlajWv9Z8tfj6c5TmrAg1elJ5XwrSxBIry2NWwAPOyg==@kvack.org
X-Gm-Message-State: AOJu0YxGCZbHlBtlvZEOWwVpewJZi4R9WKrlix7u+50w5GrgzWcIZ3Hf
	VK0n6/JpBx+NTyflsrjptqkhb+QkF/Pud1kPpvnDo3u3TCGKjYCV6P126HolG3vW3LXmBS+Fpds
	syCjKErHdHzl1AE8ZFmH8k7rBbp/hYx0t2gusbxmUgdi4JTWu5oKL6w==
X-Gm-Gg: AfdE7cm3VdpcgGL8aQMowtQt+oYB0P3bSlKxI8Slr21L1eOYC9tOpDY+A8SY+Y4Oy3E
	dCkRTtuI8bIBqu3SVBzOc2iYU+Pai1CsAl9qqyK/EWHJALx9EbKiAMI9P81xnofuPs3j3QKdSKM
	VSJzaDj2UWGrqHfBhyx6mnf9toNoySoBlHWWgalaRI7q/SlrnLcZ6WQDwERTlYL9Jhw9lbnJHbN
	G5JvWkgAg5wrVXne/b5G8r69uL3jGfmaKylGmbaKaalhy+AftAbQT/qa5XxIrfJ7AC/OwMBQms5
	t6Jgvi0rbMJ01nhdlwpK+X7EVpNL+9lSfgDOD4yulxlnFp8CXw8pn/dAmz98qf/vPa35QHP+pYg
	S3SVX1y10laXb+ath0bnR2Mn8XtfvHlnZ9scE8Q==
X-Received: by 2002:a05:6a00:23c9:b0:842:2ae0:968d with SMTP id d2e1a72fcca58-84843246a07mr1172494b3a.32.1783488969240;
        Tue, 07 Jul 2026 22:36:09 -0700 (PDT)
X-Received: by 2002:a05:6a00:23c9:b0:842:2ae0:968d with SMTP id d2e1a72fcca58-84843246a07mr1172435b3a.32.1783488968604;
        Tue, 07 Jul 2026 22:36:08 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6db29d1sm6484592b3a.53.2026.07.07.22.35.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 22:36:08 -0700 (PDT)
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Date: Wed, 08 Jul 2026 11:01:54 +0530
Subject: [PATCH v3 15/26] panic: Annotate static information into
 meminspect
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260708-meminspect-v3-v3-15-7aa5a0a74d5c@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783488714; l=1392;
 i=mukesh.ojha@oss.qualcomm.com; s=20250708; h=from:subject:message-id;
 bh=2Ckm+YqBY68LnQw06/xX1Rice7q7oHfxcc3Oa8J95tM=;
 b=kNcFd/6IJruvhbZhgcKF1kf9nMQRpQthTbMHEFUl0hfgNNJOPNaYN4PdRHLxJ2YhHQpTBO7+8
 6jxCLWuRI8VBffFPcyBuoS8d2GFeO7KijR6/mLX0R1hgBfH+2V4jfL9
X-Developer-Key: i=mukesh.ojha@oss.qualcomm.com; a=ed25519;
 pk=eX8dr/7d4HJz/HEXZIpe3c+Ukopa/wZmxH+5YV3gdNc=
X-Proofpoint-GUID: mpsrCdsa_iFnczBCByM4Asz8qI3YXUif
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA4MDA1MCBTYWx0ZWRfX8Sb9XjfxjTeS
 PNs6uVfFO6DiPDzyvadC7Aq9S4gE6xo/uNUMRVUpIS4VJJ0RT2RzOQy5bBdLa3kwHwsujhXn3ow
 E2fHNT5FYG5xHqyc6ZxDFhdm/7z2G9Q=
X-Authority-Analysis: v=2.4 cv=CNoamxrD c=1 sm=1 tr=0 ts=6a4de1ca cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=VwQbUJbxAAAA:8 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=sIx07V1IIwI039IRSX0A:9
 a=QEXdDO2ut3YA:10 a=IoOABgeZipijB_acs4fv:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-ORIG-GUID: mpsrCdsa_iFnczBCByM4Asz8qI3YXUif
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA4MDA1MCBTYWx0ZWRfX1Uoq93A6WQXk
 +wOQhyzJyU2n5tCzT3DGGAm2XeEJ7sC5l7zHMDCg7XjoX0bildEXVYLBQHc0IZoiEKogLBSKiOD
 e/CaGppd0oMJXE/4wFrMfmZ3tfQOssZQ/y0iXGbNCCxRlKu/1acyKoGoBkJYEfs1Fd87UIibsZf
 yww2kwCTK7uFxz6cVgFpHf1wqn5NMOt+0Ja7t6fOgfouKsoOVM5OjoVrWPExryQUyBl5Jb3WKva
 C1X6wwDTX0fyi+Bby+8SpMDxVP3mM/gHVkpdrOdFaWuz80Hq2+43NV9WWQpMiCnxTv+45X0Xu/e
 FZFBId3bxOThdKiIwNBUjDpIPFRQ3Ldtwj3lmV16xKx73fWdj63kYf4rMHNNOm8kwXA45z1XtKZ
 nIhW5deMEKS3beWxS5WWKvrH+EGNQy3u4IGjRL9M8dS0WIURNINcETPQHuQA/5w2jxEZ7/iDd/M
 tUXzrElAzfiMykuJVVg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_06,2026-07-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 adultscore=0 phishscore=0 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607080050
X-Stat-Signature: rcoq8u6satrnp5ht8xg5agf69gsm5zaj
X-Rspamd-Queue-Id: 8BC0C40008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783488971-713047
X-HE-Meta: U2FsdGVkX18GnoWBcoT/KNeR6Uvn6lo7XTgHIc+c2nR5skLD1Y1Maq5wfufB8iJzml1ZyBz/wGK4UdLEMG4Rp68zalRHruL2u8/Zc2uvz4NLlpsCWf8mI1ZvHpXGUsRNsowfqYrHZ/L0a9k3AeKB0ZqFJeBzr19Y355eW9hmaqZHg/vNwMJYFjH33tpV/Bpp5FwWMCxk3WwUyJGjHDhyynmbFL2+KD03SdNK0saaEZV3AOYGhhia0JnJ39gRoFmKK3pcDm/a99tU3QkSGPCYAW49C2KscGb4gjVwL+Hu/Fq1vSEP8J16m9u4E0RCss6kw83nypJ8jmbYJhrAyaDJL6cskZABAa546iTILbPBsCSdNAkjfFuCyEVFLibizsVSomcxQP5WIBszy9Dmf8WIW0/KoyDeIB7qdR8XSG+k7NnWKACQOlkm5mToxziOzUyRawyZu4lhvySd9sjY1nn+I16oollAG2Te4TjU4lMuAHtDp+zjIRc9S1IRAoL1dws59LYo4Kfi0k7jYvqvxYGZGi9ToD0ND4kLSj7BaE9xbU7hEK7H/Vl/6/x8i9YrTAzZmfYHohRI3eFWJhU3WSqUfyuqhBYdjz5+QakyZq0r026Jyn3u+0PXl8wmJp8dNf0um+qGkkyX4e+gXknJBKrEMDcgZerZnLd829wn/xQbQ5LIQNpofBiMpn0i9SW96frGs4rhWaj8WiMGN9nNA3o1MIC7tqyOlshJy0bhq9RWnN6fuMBwsZeADLzs+Dvsv1J6UfJZt1kwNXbS9lx9CwHbvxaOC2GAPcL8Rl4FAowJba6bdYukcq5LI5BmX28y+U4l1lkZ7ghXA4fwXqYJDunpRBnxtav2NT7GUhPDRYNtj3rlWkKnV8iVZ0RrXDyXnASCEtNUznLOzEXyUuzt0qbC2V0Nx0OFrey5lZ0jWs73kUEQ0ioIFCLyK+wIlJQp8DSua1UjyMDyZ4Cw8Coi5n1
 ZiBFoorB
 cF3HTb4xRvDy9UCg7azQdJ6JMPOJ4LmgaDV9DlM1qwOWgxhvdh5uYM1r+yGRBB6xKoiKrmzyTUrhX+JZWyRIXCK7Luw1aIilBkjaIwUukEJtkRUP6bRSCb1J2iVgSQMl+b+HhMqEV2i9D/lTcK83Toba7rTnh6L0LIRGw6Z0oJPt2vwVl69ZYlJebTr9qzxyKPLTKkNksFftFTj7a/oJXGu5YMLU6QUy2//V/fExCeZmEEkCl323ZdqJJYXJrHvMOwMEzHHY6fiy3XAygl1yYgAybXAfvMve2hTi5q1Gp21Jd4J4yAKvd57+ajrZOTDiOwHBi4DfYHNOd5+OFmQmxVxf866oZPLYhOgM5aMT9pK5EIy6D2Mdq5uVhYxdLYA6xi8/9/1qNAvVT7j16hK/YVuUe9qHpJPgvt1tbdQjZjOPv3kEYAwhpuhhnn1EMAM0xL7sWWi1SZAhr37W5IOjo17tEqUGpmrKaGxRXp9Zr72vju5oEK7FH2Yd92rcI4GnS0YS7Ug23q6BiNX6BAuqSlsWBiiAiHuMEvWarsknBKo+H9s19ioNt39/LU/OWrlHfE5h04RF0Nlsog7IgC+rFHpfJhHfDb4oB7lKf39N7NZ9ta0Lk9twSJGt2Gg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Eugen Hristev <ehristev@kernel.org>

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
index 90e21f15fd7e..31d2e08b7e2b 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -37,6 +37,7 @@
 #include <linux/context_tracking.h>
 #include <linux/seq_buf.h>
 #include <linux/sys_info.h>
+#include <linux/meminspect.h>
 #include <trace/events/error_report.h>
 #include <asm/sections.h>
 #include <kunit/test-bug.h>
@@ -58,6 +59,7 @@ static unsigned int __read_mostly sysctl_oops_all_cpu_backtrace;
 int panic_on_oops = IS_ENABLED(CONFIG_PANIC_ON_OOPS);
 static unsigned long tainted_mask =
 	IS_ENABLED(CONFIG_RANDSTRUCT) ? (1 << TAINT_RANDSTRUCT) : 0;
+MEMINSPECT_SIMPLE_ENTRY(tainted_mask);
 static int pause_on_oops;
 static int pause_on_oops_flag;
 static DEFINE_SPINLOCK(pause_on_oops_lock);
@@ -833,6 +835,8 @@ const struct taint_flag taint_flags[TAINT_FLAGS_COUNT] = {
 	TAINT_FLAG(FWCTL,			'J', ' '),
 };
 
+MEMINSPECT_SIMPLE_ENTRY(taint_flags);
+
 #undef TAINT_FLAG
 
 static void print_tainted_seq(struct seq_buf *s, bool verbose)

-- 
2.53.0


