Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA9C6FD4F33
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 20:21:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBF056B00B5; Tue, 10 Mar 2026 16:21:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA0886B00B7; Tue, 10 Mar 2026 16:21:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D555E6B00B8; Tue, 10 Mar 2026 16:21:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C2B5C6B00B5
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 16:21:20 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A299D1B7686
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:21:20 +0000 (UTC)
X-FDA: 84531273120.04.9E857B8
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf27.hostedemail.com (Postfix) with ESMTP id 33B4C40008
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:21:18 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=MiNYG6Mg;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=KT2McpU4;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf27.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773174078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pr45VIQTBIoBLlkPvMxS8V0csqqIhMCo/oCsn7JOcGU=;
	b=NtN1a/mO+49QIB9YH0AqcF8pgKalHde3cz5NYIq3RBon0Zk35XCmIUmAxTBcIey/6gkaVO
	cvnVLDcT4DOU5lNBRva+vxaDjy30g4Teypj3j1CF/UBfXp/2HplPqPt6NEw+y8Vydi2ahC
	XFuF055kTPwqOG3wwjSIEPXrgxBbhA0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=MiNYG6Mg;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=KT2McpU4;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf27.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773174078; a=rsa-sha256;
	cv=none;
	b=QpmMQrH+u0yrV6k5mAyoeIcWBeLa4BuTmc5texAMAXan39D0/qyCQl6oBRf+CSQn0D9OwD
	eJwZGSkstawPwPXXjZwuP7GU4nuNSYg5uZRmAJ9MXusQA4JCbAxpu4C0PDF6sUcLolra3/
	lu04eoq9ZMT+nbymm1bayWtwvzQCrNU=
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62AHcodI2179278
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:21:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	pr45VIQTBIoBLlkPvMxS8V0csqqIhMCo/oCsn7JOcGU=; b=MiNYG6Mg57sq7QtU
	zJFIBnJyAS7vLog4JGVLNREvSwVC4yWzJRTVbt3IFdvKGvBjgVI97JsNiktdyeVj
	xXLfiKSQwfvXK5tsCPovUzt0e2vzyDn5vMwoDlFnQpzwd2CKrWaOmiWjrdFPeM0S
	DfqByTbpLqi4ehvVsfjsxeOhe5WkbDiZNTHQqVx/6h3Oz7F/Mtynfdha4Zcul4xg
	v0uHkmin0ZLQW7DenGiDyaWWfv35rxEZlufO0XX62XkpWC8yTSU3u7cGrHxV0wt1
	3hyTqzoGEoJLpnQoDlC/yiGAsBwrWRXROCs2QfukllG0dArhrV8lWb/nZRQNMSyk
	5qmNdw==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ctqvsrkan-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:21:17 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c73939e0314so2937866a12.1
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 13:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773174076; x=1773778876; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pr45VIQTBIoBLlkPvMxS8V0csqqIhMCo/oCsn7JOcGU=;
        b=KT2McpU49AYlzj1oyGx8DgCztPjJ07MaeciwxUbNduDShRehnTjWOxALG9bFLNRy8c
         HM7gzbE8Faq3tmCF5aDzLA4O8C5wnjDpUZ5i5Aq2hwkNkOIu4AupL6X1yfjINtSqq0mj
         nQySTpzer48xFTHPsB3phRU5eU/qJC8mgpNWTSnP90Sq4wPEOnc7IbsbS01f5lUspV/0
         FzG27+JYtY79LkPZpnJ+Rnm3ojahxqGWXiUClhhpB2h9sq1RaNUVPdbfYwAFD5L2MoWF
         aCSK8zavhSUQkkOFpk2gUNeZMHTSc5UG8Y+ydVqWtBIwt52uJoCqkjnL77E2H64TRlCY
         36wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773174076; x=1773778876;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pr45VIQTBIoBLlkPvMxS8V0csqqIhMCo/oCsn7JOcGU=;
        b=Fxjjj/D14txGSiuSa7vg+C2ASEvX35igQTIbsTq1OnINNny8KoXpar4bzN8kgeuJip
         A5q6Siv+yry6pfJC4GhKzKpwzDc2w1fObO2KOgUBOv+mhAGUfWy9FjViFNkAO2u1J27K
         fVd7E/XOaEeWyC6fTTsmckhbZBmB3yQxxCcfa+NUESFCOJFdfdQhl/ayUU6I2GIv4itY
         b06QpZhzvcoV4s4Bx6vK9xqrMvn7bimaRoTKMj5X6ytWE9zRiSlWwsbEpvYRqu4ixN/f
         vDc6vVtEjG60ZzCS0HKRTQnlsJBJGFmHMXOHs/1u9CAs3liAtXpxZiWLsrd2YUDpmaTc
         /5KQ==
X-Forwarded-Encrypted: i=1; AJvYcCX358syNB/sGILB+bKD/NAXM0n20UYuTLEaXobaGlcwplnq8gBw4A2qlnyc7GKAh6+TXnYzxGm/KA==@kvack.org
X-Gm-Message-State: AOJu0YzADpboUlxQJVqWO+FAkAz+d7y1vAS2xru7ns8/BzSkgbqjG19g
	gOt4D9tk0k/kGOiBfwp6eu218CcEuT245hY7oGvhzlhsZAl6joW90PHI5TxbU7cVDPf5lNMIQW0
	QBvHHfjy8a9zZ9Plz5VZD1uybhrnR0xuEEsGfKOjLYpriTyth2L1mZA==
X-Gm-Gg: ATEYQzwY1DJ8NX2XCB+76qXqtt8jiJDFd5QCGQ/X0Qo4lhZPa6f4F2bCmxzAxSC107i
	VeDzwlFtytB84iMNmLq3080MPnoQiUKj3hKIKAN5YWucbNjzuIpzaKkA/n1GAGWeu9evrzXh9w9
	zhGpZf2wjxumPd2qfZ8BJcx+hxE7jGgVY3p/esF1lgsKxSHiTqh8VlqM17WPAOiIcK9UYFOF5cf
	W/teu9WXrdl/W6Wpk0YaS/EoYiBH3yr9svKdKbm6zz4YavcN8bzqY20ezu/zPsTA36vR+lQgTgU
	UBEoP5x7lCq216Zpxy8xJEU7Z91q6VDR1L14j7uivN6CPdmIC7LMLu97fcIkJdfexGfechX+D2M
	s5aCtjV7BfHf6tDCi3ax6vSN0wnJbMSjwI0W0qYNx0Ar0/wh7
X-Received: by 2002:a05:6a00:194f:b0:829:737e:7d77 with SMTP id d2e1a72fcca58-829f7276aa8mr117545b3a.66.1773174075898;
        Tue, 10 Mar 2026 13:21:15 -0700 (PDT)
X-Received: by 2002:a05:6a00:194f:b0:829:737e:7d77 with SMTP id d2e1a72fcca58-829f7276aa8mr117489b3a.66.1773174075251;
        Tue, 10 Mar 2026 13:21:15 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-829f6dc2d0asm115262b3a.13.2026.03.10.13.21.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 13:21:14 -0700 (PDT)
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Date: Wed, 11 Mar 2026 01:46:04 +0530
Subject: [PATCH v2 20/25] printk: Register information into meminspect
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260311-minidump-v2-v2-20-f91cedc6f99e@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773173756; l=2132;
 i=mukesh.ojha@oss.qualcomm.com; s=20250708; h=from:subject:message-id;
 bh=DoL9F6Yy+rSvMBQNw/eS/qA8539X5KoND3cxVd5dx4g=;
 b=j+JQFKmaZDxUEpGVy3yxwRluoEiiKKxHpWd1mF6xVlnJWzgrkvwAQJ3AycXjiujTAa6qBPTc/
 fk1Ilv1rpSuD1QonOn1v1fM73CSGktc+aR8CTEikL2TUDUjPNLboP1S
X-Developer-Key: i=mukesh.ojha@oss.qualcomm.com; a=ed25519;
 pk=eX8dr/7d4HJz/HEXZIpe3c+Ukopa/wZmxH+5YV3gdNc=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDE3NyBTYWx0ZWRfXycyFpmQ9wQoN
 CdUECUwR70ZxhG2P7brpVB5Yz9KLalLTnrIa3JPh9D3oJ4hOLNDBYQErTKVVaEY6eZDnuxUx/wP
 +zuXSaeTYc0BeExqwOS3L9sFZ6stQxetIG6xbFqMsvoWtfwk4v9vjsAa99rVjLvM/VOEWySiO6l
 GlfYIKWDdfzDG2qhfb5tdiULukF7dnudXJn9FteatBJshn0eBYAAk+a2m+N8021V3I2n0v6SKV1
 daxM0vqCzATXjaRZ7PHLTPGw30zq2KkwFroYHI08viJ85m6TYyxEqA7BpB1xCMI0ZYLvxADNpTJ
 daEGruImPTLD+M1RHJTrrJv9ytpAGq5PaotOjbGJagk5Pfp7hz/vHLTRLEkg+lpiIsBd4PjZDeo
 HlFPtZx/f6F1Skqi+kKF5vi/ULRWxz4R0hHtwkYN89J4N2ll/xeLrbqvKTcaccRdSMt294YmvZT
 8rYkbpmhLLw6IM7AodQ==
X-Proofpoint-ORIG-GUID: HiikUrq15mLDzgi4V0D9cC03LCxFiFpJ
X-Authority-Analysis: v=2.4 cv=Lo2fC3dc c=1 sm=1 tr=0 ts=69b07d3d cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=iox4zFpeAAAA:8 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=ZWDwVrzm9O4pBL7d_cQA:9
 a=QEXdDO2ut3YA:10 a=3WC7DwWrALyhR5TkjVHa:22 a=WzC6qhA0u3u7Ye7llzcV:22
 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-GUID: HiikUrq15mLDzgi4V0D9cC03LCxFiFpJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_04,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 impostorscore=0 bulkscore=0 malwarescore=0
 phishscore=0 lowpriorityscore=0 adultscore=0 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603100177
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 33B4C40008
X-Stat-Signature: ajzp36b9x5u6is3aojafrmud6oqwj57f
X-Rspam-User: 
X-HE-Tag: 1773174078-217736
X-HE-Meta: U2FsdGVkX1/DStJ7e45PjKDfR4VQpfvChSIW3nqa5504MqeQv/I+aF8gak0KpmpAR7fd46tzh+mHX9yIRIEUND+KvkLx+y+KZ3JKAoOF49v0Dm5DKr2O+/jb82pNyxD3rkXKN6hO5yXK6UB0nFQumdgWnwq1/1XyZ8kQv5TDyZxNRLvQu94uKpQJcqjU4z7Ul2aQ0C3ShV5sQbwjC2um+aPzDK5pEX0KYMY657SG4jUCheLfhQx2cJ7mAQ7Kr72VQNiADsAlnmF4t8Fnd3W7u/Bcxi3NAkqIOiSPlambBD4lXdGl5lxeRrw0ymxJkYpv9Vf3h90r/4UJoR9PFWdn/mmAedd96SW2qrptmkIzWF7Dk7DfMYmrLE5CrcB8K2cTVcQRdOpWSh+rzxBbnzHPobnNymTgbUNG5tv8nRE+XbIQrD5bajO56sT8E981AlA5lnGyWaJEYSqlfP4zz4uo25ogJjgB8seG9jNKG3a9XxipmBbUKvgGqpr+t4ArOWmv5PkZZez6h24lsDbZSicz8DL2ws4opLgDakHclPZd1cU7SW8nAcewZAbOp3egIGpS8GUBPYgjO8Ozvg5ae/V9mzxbRDezmfI7v/cH8DFUa2trgfyE2EDwWODXIenoOHWD2xfK+D9Zrkt+SqwOMI/ASWO5BRQ/NR7L0lyjtkrL+Eu7iWpVsNJVP2Q5Y+csTWAruMCBMAMXoaUIWh4adipj6iliSw33qgM2EDZaORyun7PTeZRc3WVbUgmTc3COSGZ2xRk/yc0bX9ZMUhkt8I6fWEDd0BekMBWIfra1ldihJp8tfRPgMiB1eYWkG3icDqy84PJvgNk/9cbjM5P9oFAC07abuOLmdpnJG6Mmj3NmZS2lG2I5IFuKw8gHE84oU1ruox8DuD/HhWAfbxEwYzPzPK92vLtCEu8BOxg05t5zUVupxUDEn3ha/x506Gpe5+zaV2jA41x5NS1STzZgl4U
 uW9Ob+B0
 Jj6sEPKSysym85tLxZ6XOfnytWBO1OL4b9b3D5X9SB78C1M0wvrV3coJQ7wH+uDftseLMK1PsP/qfaWGbZ8xl5eski26+cnrKZtu16oGTmUbB978+LYa2j8cmEQiD82ILGcR9t6hGqgOsF0SKmFe0Osprqf7m+WEhWSipzLeS3CwpLbqi8PmpAwWhl1TtO971xYhCCz8aD2Fc3sGuO5JOVt7prpZwNsd6xPGRSEsm1dUnXf30qGAAyAYET6kgM4YS4gHi5aFMVTDEwPGczGm+c2QWon9QdmZYwmZ0wJnGX+aD0Tcn9H57i0NQuGoV/q+xv0hbbm6G4PDRIkBavQ9t5rrTDT4uXnUf/vvbOoM+HwimxEqYzyDjjY/ScaPdE6nHcRH50C5EFXKKfgbdJ+1STjBRObKHF7cOPU/GvoNLKDgl/yLDDByCvgaaqOK/Kil+yimhYVABR4G8iIOeUlDyR3B6/14BZ1rkm2aszLlbIgh3mRkwekfF7jBsx7gNi6GfHvPTOmPB+dIH1eZdacOqcT54bc0CsLHnCb/2aETVVkxSnt/Hk1RxOHrGyBOWzHfZLInv04bOmdx4dV+P45J6PzKbKXbzgTATBqhrdcgA+TDj3Z/rK1+Uw0gIf63OvOp8jY2M5Bjn7bMtCdTAeCteLD+NbXyQhbOinuHdAZhpKGcVJUpkBg9kH8eUbqad8EbWCHMTvXqBoHq/4FO2WAUv+NTlig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Annotate vital static, dynamic information into meminspect for debugging

Static:
 - prb_descs
 - prb_infos
 - prb
 - prb_data
 - printk_rb_static
 - printk_rb_dynamic

Dynamic:
 - new_descs
 - new_infos
 - new_log_buf

meminspect uses a different API to annotate variables for inspection,
and information about these variables is stored in the inspection table.

Reviewed-by: Petr Mladek <pmladek@suse.com>
Co-developed-by: Eugen Hristev <eugen.hristev@linaro.org>
Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
---
 kernel/printk/printk.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 0323149548f6..03216e7ef807 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -49,6 +49,7 @@
 #include <linux/sched/debug.h>
 #include <linux/sched/task_stack.h>
 #include <linux/panic.h>
+#include <linux/meminspect.h>
 
 #include <linux/uaccess.h>
 #include <asm/sections.h>
@@ -518,10 +519,16 @@ static u32 log_buf_len = __LOG_BUF_LEN;
 #endif
 _DEFINE_PRINTKRB(printk_rb_static, CONFIG_LOG_BUF_SHIFT - PRB_AVGBITS,
 		 PRB_AVGBITS, &__log_buf[0]);
+MEMINSPECT_NAMED_ENTRY(prb_descs, _printk_rb_static_descs);
+MEMINSPECT_NAMED_ENTRY(prb_infos, _printk_rb_static_infos);
+MEMINSPECT_NAMED_ENTRY(prb_data, __log_buf);
+MEMINSPECT_SIMPLE_ENTRY(printk_rb_static);
 
 static struct printk_ringbuffer printk_rb_dynamic;
+MEMINSPECT_SIMPLE_ENTRY(printk_rb_dynamic);
 
 struct printk_ringbuffer *prb = &printk_rb_static;
+MEMINSPECT_SIMPLE_ENTRY(prb);
 
 /*
  * We cannot access per-CPU data (e.g. per-CPU flush irq_work) before
@@ -1238,6 +1245,10 @@ void __init setup_log_buf(int early)
 
 	local_irq_restore(flags);
 
+	meminspect_register_va(new_log_buf, new_log_buf_len);
+	meminspect_register_va(new_descs, new_descs_size);
+	meminspect_register_va(new_infos, new_infos_size);
+
 	/*
 	 * Copy any remaining messages that might have appeared from
 	 * NMI context after copying but before switching to the

-- 
2.50.1


