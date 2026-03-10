Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E238FD4F2A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 20:20:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 098CC6B0095; Tue, 10 Mar 2026 16:20:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04FDA6B00AD; Tue, 10 Mar 2026 16:20:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5D4F6B00AF; Tue, 10 Mar 2026 16:20:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D44F06B0095
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 16:20:19 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A4BDA1BC58
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:20:19 +0000 (UTC)
X-FDA: 84531270558.04.BE6BECC
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf05.hostedemail.com (Postfix) with ESMTP id F2357100011
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:20:16 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b="Kcj/fPZ/";
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=HDYr8TvD;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf05.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773174017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t2HzBtnh7QV7EHA7wh8q9lV9zRoeqSwGw+3QCMSiaC0=;
	b=TTwRSUaZWcST63CjUYI1DwWakkcw7Z5TAxYkh91EYcvpdpb3YSCBzAlbvanq6vCCRGLE5a
	XPBpkiUDQjeW9CzPDJkIx3XbgPrOip79vVQkxporfz0TkuB2RWd4W9Y/kiUJwfAUXT94wW
	oPAo4ur1luSnne+amjhGodfPE0329S8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b="Kcj/fPZ/";
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=HDYr8TvD;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf05.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773174017; a=rsa-sha256;
	cv=none;
	b=PjQvnxPObuHP18eM38jHpdyqnIOpGaDW89x9v8bKQFI+0YZSMw5EnK7fmx9Kf7vYIMn8WA
	C4f+g/xu8EOCj905hdflEn7hUp3430DpCjuZCxzqvaqLJlzbHxqsI2JRNZBCNTOFDXsSHM
	7CDxkHwYBeLHt9t3207tBFkGv0uvasg=
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62AITvcq2862005
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:20:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	t2HzBtnh7QV7EHA7wh8q9lV9zRoeqSwGw+3QCMSiaC0=; b=Kcj/fPZ/cpOljFC8
	ggqErlBTtfF+TdraC1O0f1rho0XEPKKZ6o2Yw+WE95wpJdRXAc0+qCBIN/zepz9i
	LcSwm3oqsSsUlZC2OQRvxxPdClhNjkpWeEXSilhPesJt7G/DBKTu/jGAm3JuKgQ5
	H9XHXg/vRhgxSrecNxbG+HBo8xI+R1DxZ++B63aTilUJ8O8BYsPcxoZAk7kTDz3d
	7c/FUBMuxtNOBhlSPTp96BX9PefFu3KoMjtDL6+WGxEyQrJtf8LdlVhuJLK1twzh
	REzMRHwO0BV2rzW+BpmfiwiDIeZD8OL2t8QqGeF3nlYgxmBh7Ih3AT7Xazciul7e
	i4LpUA==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cte3wb6bg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:20:15 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-8298150caddso4554198b3a.3
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 13:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773174015; x=1773778815; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t2HzBtnh7QV7EHA7wh8q9lV9zRoeqSwGw+3QCMSiaC0=;
        b=HDYr8TvDtssSCYEhwb9PWbqSaNTYot8NMECgq2mm1ui4N+RxlXpvBTW3FER6hlmYP6
         igqgqv5FfcvAqvwdgFHMt5JAJpdEDSxb9WwgS16VveW1mhCxzBemQ3i69HCAT3Woa0ml
         ii8b/NvEmpomU9WHuy+BgnD/Y5z5K7Kx88WaGA/VoCbdTYoVNBNdpQH9NhpXTX7OIO8L
         v0XsxKatyKD4qA7/QB2GkFABNxKuawgwwDGRp5ukzUTQaplF8mtZ7aeHiTpdMdl30g2w
         zWONBXzCqxTLMkQ4xicmI9UFXom6c21wcG6Y6qVzekMEPZA7DpfCknblo0caB3tJwnJj
         dSGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773174015; x=1773778815;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=t2HzBtnh7QV7EHA7wh8q9lV9zRoeqSwGw+3QCMSiaC0=;
        b=QsJpG/a4ejLmub/gpaay5R6pMaHH+J7n064zMb9Yk3hoCPO9XCNIyUcgsuRkcILaOS
         f6XNkJ/9nA7Am2XLtmKquOeLsromOZjMemsBfBPB+FAtlLaX2NGvqzjBJoc2EKriCAPS
         Q3J3Ayn3ClzmoGFTtMUTntLhIbtj4stH/cmQ0YyaHp+ZeqRXJn1DAZfpNOWkARbr2jeA
         RX3JgGTcslFuCZ7ZFZrFGetKqUCeu8J7C/alU1HYnlcZddIaDTsWSnmQ1Cj8GK3ZYPmQ
         bw8vrSkpYdPnM4PdI37ostkZzOFlmYWl2AVqyMevSn2HxNlj6ri5kz72wwnmXvCjZhOq
         SvsA==
X-Forwarded-Encrypted: i=1; AJvYcCWm0RyaTSpH0hAfHea0UlKJMts+uGXg9wZH4hLCTqu8GM/KCrSXlfY2IJOnzTMWApbPC/XbXegzHQ==@kvack.org
X-Gm-Message-State: AOJu0Yz93UaO9rVQYPhVPw6qIJ+FRHSUY9oYHfnoScHy+E9Lxz64r9Ex
	Q7kgbx2oiQsFKx5MyE6vjJVpxiZCEhz2VwNCXpGIMo5VTpK+JucEyrFckHu68Tkyq/w+JqozU9H
	VgPd6mfS2W3gGXDRblk8CsKUkY4jflaeL5suAdWDjUAVFVMnbYJmlUw==
X-Gm-Gg: ATEYQzwQm0SmJRtYgVPkVzCZDaaiJPgawpiZrRK0gri1u14xBhFjO2m1sCd29HRhljy
	kZ5yx18FbmW+T64DzZ2y1tL3F+2FMkpB6DZr2sCUZAz1jIMyCqhrij1X68Klolj5UuJMKFkVsP/
	bHS+Os7DjtJxsD9QcXnDpWto/OcV4yN2AFQhwFWedT0KSSY+TtFygPw9zg39Mm1PU7pgBKL0GQe
	AWX6Ep7nZkhhucfzR/jdAWLp4fteUPiE+OG9DN02iW2KaC3lu+y4IFktgXND4ztiuGPeGzsE+uc
	X/tt+Z7hT67Uwph2ek7JyeLsYtDkIf/8iPjiWqTrqITlWNWFteKrPMTYE6+gE3cVwDKroD4scz8
	0QJclNxlsfF40TYAZbejntbE5uOwC5baPRlTZotqDhhlbfOxp
X-Received: by 2002:a05:6a00:9298:b0:821:8ebc:2899 with SMTP id d2e1a72fcca58-829f6ee87aemr174169b3a.7.1773174014917;
        Tue, 10 Mar 2026 13:20:14 -0700 (PDT)
X-Received: by 2002:a05:6a00:9298:b0:821:8ebc:2899 with SMTP id d2e1a72fcca58-829f6ee87aemr174107b3a.7.1773174014221;
        Tue, 10 Mar 2026 13:20:14 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-829f6dc2d0asm115262b3a.13.2026.03.10.13.19.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 13:20:13 -0700 (PDT)
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Date: Wed, 11 Mar 2026 01:46:00 +0530
Subject: [PATCH v2 16/25] mm/mm_init: Annotate static information into
 meminspect
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260311-minidump-v2-v2-16-f91cedc6f99e@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773173756; l=916;
 i=mukesh.ojha@oss.qualcomm.com; s=20250708; h=from:subject:message-id;
 bh=DTT/RubkS1uO6w8Q2uLlEU+1CHFNOkom7gwELIcItBM=;
 b=2RE1s2i4KuvAIh/et2VJGLUruCSAirKOtEoh43eZpI8VBrpC3JkYwLQaT5N0Z0sjwA4h7TPsx
 8yuvgeVV1F/DrKNesJyEKMfCO6ycGwgttYEV2WQsmy/djxLHR8nIR9O
X-Developer-Key: i=mukesh.ojha@oss.qualcomm.com; a=ed25519;
 pk=eX8dr/7d4HJz/HEXZIpe3c+Ukopa/wZmxH+5YV3gdNc=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDE3NyBTYWx0ZWRfX2xlwokK1e8kU
 8u4lC+bz2Qey1fFnSJxv8B/eackePCttocP6g8P4zVSQFHKF5ec8bnWzHTkj2yp4LSmr1I9tJmo
 wDLnQfHQU5A+OHE/Uu8oTDYvyi7LTzevBanFNbY1TCnBuecnBsa9vcWPRzCh/vrz9ZCdjaxaS8g
 Trgc5sPcATDdOp4u6NJMIXrDtUFO+9iGeUyfkxcExOzh04oPqvR5TI+k15QM1ed1fuwVL5B678c
 sVKbT2sV+F3SVf+Jp8uULmq27b1NcFCjPyT0Ud6UmtFcqoWJEto407cBA9EQQV5PXq+EVweKiRE
 fYUxcozaAGxP8YIuNSA6PBHFl8eurF3FwniT89NUfVvfcDeap1Vm8du869V4429W1nxDqcgZdxN
 1OHrz0hIL2j8KSAM9aC0+Xr2kd6aUGYlxXMUGsAjR/m6Ej1US9lvxbucp0GGwAlk0Pnpc+Tzsvr
 g1X0rmsqaSLKuWBmxwg==
X-Authority-Analysis: v=2.4 cv=GtFPO01C c=1 sm=1 tr=0 ts=69b07cff cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=R-PfVeyQBJMsRd_P_MAA:9 a=QEXdDO2ut3YA:10
 a=IoOABgeZipijB_acs4fv:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-ORIG-GUID: D6u1wqrDZrzqcmi3jPnny-MYrJeVnuYo
X-Proofpoint-GUID: D6u1wqrDZrzqcmi3jPnny-MYrJeVnuYo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_04,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 phishscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0
 spamscore=0 suspectscore=0 priorityscore=1501 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603100177
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: F2357100011
X-Stat-Signature: j133on8xf63j4riozyhpeo85e71bc3to
X-Rspam-User: 
X-HE-Tag: 1773174016-76359
X-HE-Meta: U2FsdGVkX1/nhZ0m+DnAOo0PzArNr5arDXMrbVmIHfO7CVPv3/8DEWFeOALEQxd51IPCPGtOkH4FqzOurBdUYX33sqvLKUOHaHvhwXrm95aTHadwN9nRj29ds82R67kSvJ7owxUhP70akNgQrfvg1uv8h171LLeGAy6ToC0dbWHJMthGW0rp9TclhN4kxthI0MQF29QKbS0yZM0N/Ife92Dl/Xn61oVSKWY+PpBEGLu/mpyAvPnzUSMVy7yp00GqI8p/pEsUnMa7gCUMg88crhVtV+LIiEjDWXbFwtjAP9JIclNhyGAve5KTIw4dC21d87lsCzceCEAZATfr8RwkobXi3VTQWGZzuKD6JgsNIKqeWtY3VR4jrHJuBEtTGdFzetc/7qu1samDDizHXRYhBO3qfzF+JELvtec+IabWjOBQNlBnHPwjpdBcoqAShlSMCfan2GONLSBr/+OFeIyn+79PBtRIsRpQDZjUsRn2riMC4zLXtTa/64Bk0DjuCmK7X8T4CM5JFraXD26SvTXd5h9XSkrxSESnT8+lk3oQuscd+1JNkss6P5EDIZHd221w010yw0/muGtiGLj16GxeIbhSR/lXJewsMXiFFPuTWnlfJktZjhn/UkH6Rkg+QXynyn42k2iufvIhS34Rc+9fT+nH/8aH6WcK+fO8bXKm+N+1ZOmi31116NaALytwqZGX8P9lqtD1wGdMs/dRCNW8kctL4+XIo7EhhIhm8Pfiil5osRvr5KG9j3EyKpw/lg+WA5wDx+1JAWAb147LDW6jgunFMHwyoZoiZSJmQ1PMUW4hAzAfCABU75V9v768A0YtszxWA5KErLvitEpSr2neQ2ndsgt0a28t1LSpZsVteMr2lybgfvsaXPWzvFJRV2jQ6K9twQwr59SoFHbCskFEqyHL4rNZGwSvn57nx1qHkYm/lu1zG3+DWSgBI2AFqYMPBKb6PPKZOozBxBFdq7g
 Vbkrrj9t
 JB4PifVo63nx6zp/FRzYBuZTKrZERIF5QoCOyqX+dgxwyiEw3HuFcXBglxNXvTLDvgtzS/9xVMLYH2LvGzqkEpBS9juEDCVpDy06KyGoopPk+fUpTx/T12e2Na3XFxl9flNhkAXhBd8jjuPpCCWPN+TGLdcp6olmSmoZ9W5YxPlkSVJjtlCRM2M3IRZA95PnbGNdGaI2GQTP0Mzv6frSU8NP+uJjDdH4O7QDvyz6gK1ezrCRCsWEIBJT9iOh+44WsKzuPQ7suGAO7mrLd3lvfkVoNo1L5KIOjY8Bn97/lnocrmewak8TKn/RC8Ou/p2716m0rAT6haK64vz39SJ3vKukb2JodbpVLMyQWJw60zpKxxDubjgchqULkpd6QJ+HiHQll62n1pX4MTMuUGe9a+utoNOnLO4d2NN3puhZvdRAKSQwGqGfurGSp0XpXHURdhE5BjUkW7c2AyDfi6bVYy4VAxcDdazVZ0Ku3PBwQw/g86eMSr/pW7ceyxi3r9f8kzq0h9PRRKSCasiz+VPCpQc8zUot5KoqIQQTXaPls+9Cv08w33F4Ty9tic/HATUjeGl5HuXPnmIK7KJOnaHdcKGMqX18xjJ7lQky2XCm1c9lMUVNp3ot+WDvCFXkVTiy4aRuJkwRrgBJnk0SIygbC27QcXC2td1l1L6okzygeJo7b/ZVd/N/dFapEgZiF0hjJlVTg/mtlB62VM1c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Eugen Hristev <eugen.hristev@linaro.org>

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
index cec7bb758bdd..3cfaea1e0b21 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -32,6 +32,7 @@
 #include <linux/vmstat.h>
 #include <linux/kexec_handover.h>
 #include <linux/hugetlb.h>
+#include <linux/meminspect.h>
 #include <linux/mmzone_lock.h>
 #include "internal.h"
 #include "slab.h"
@@ -53,6 +54,7 @@ EXPORT_SYMBOL(mem_map);
  */
 void *high_memory;
 EXPORT_SYMBOL(high_memory);
+MEMINSPECT_SIMPLE_ENTRY(high_memory);
 
 unsigned long zero_page_pfn __ro_after_init;
 EXPORT_SYMBOL(zero_page_pfn);

-- 
2.50.1


