Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D50ACFD4F2A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 20:19:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36B236B00A7; Tue, 10 Mar 2026 16:19:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 335686B00A9; Tue, 10 Mar 2026 16:19:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F6FB6B00AA; Tue, 10 Mar 2026 16:19:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0C0496B00A7
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 16:19:04 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D8F8AC077C
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:19:03 +0000 (UTC)
X-FDA: 84531267366.16.A16CFCF
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5B3A2180002
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:19:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=WXvMHFKq;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=HtUBp5eU;
	spf=pass (imf06.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773173941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9TmROf+bPb6FNDxEurt6WhWR2L8qwZm5Ni95BDxLLsk=;
	b=Qx2+sOe+sP4UoXVUoCWAH5iC+5UzIFfeWrbaABaMxrVZ0LrA1S1Nfcsox/+ktEm2ywG1GX
	OaK4WG9Xozww01hHXw0/Vmgxhqr6NRQlSZpE1OvPqtiaCM14xN9EBYCprGo/Bf7Cv6WHeK
	oQPN80LykEZ0yYsODx08o5TKOtcVNVc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773173941; a=rsa-sha256;
	cv=none;
	b=h44ucn8MZ5UtnUbPsd1/eGTLYm3LferrID7oBWl2q1ZB7K8LNs/k7k12fzF7ldJIqVriWd
	j9N6USZUYS7+JaN9cKWrLN34HSRT304IoVjxqdNarOptWWKjqWX55P5/U51KmBXz+lnOkF
	hQPFa9xPruv6NR6AlxoN76SnI91oCz0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=WXvMHFKq;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=HtUBp5eU;
	spf=pass (imf06.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62AGH0Zd508387
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:19:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	9TmROf+bPb6FNDxEurt6WhWR2L8qwZm5Ni95BDxLLsk=; b=WXvMHFKq+20+1g7L
	oZQU641VdU9D+cbX6AIovAiQqEr5nAj6pMMuZPy3yOFt3Wt9bNablBID4RKL4D3g
	wg6x7qai8CZwzdERZf/AnCgVVCABZDxrhBm4+3Ud6c5AnhIjA2TA/UpstU/qGbWu
	+pWrTVu6616q2Wi4HqFtVl+AGsMqXRERL62sHA3SQOIXs9juL8KIHh/u2/Lju7rG
	M+R4VT/5h+i59gwg0bduxUeOpuKM3zoFr5pBjSK4hmThUnqHwHC5S41U3f010/Vm
	yRSEenFCQbwavL+2kM2e/Hcge38aLh71cAdRl44mye1AUAnxyt/RCCt0icuwO1YW
	INbz1w==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ctppagwpr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:19:00 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-c738563e61eso4143860a12.2
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 13:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773173939; x=1773778739; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9TmROf+bPb6FNDxEurt6WhWR2L8qwZm5Ni95BDxLLsk=;
        b=HtUBp5eU81XfvBnOPTQA+WqsmtsfWnVpEDtZp+UaahUqW2osErHIW7Y9ShsfHuSKKX
         SpOunYh5an2A4AgEg6WF76atez2C7Pt00uv99Olf4M7q9IJno2C3ODQCf2QbhFo9V4jT
         +9jCGjMDDPZWOPir38i9Uyn0jT6mIgAetvSvrRl5anm+n46zh38kkfxHZKI8SuZOaoEQ
         lBiI6eLPXqS7JZxUA15YuznqQopQgqXqh62jCGTFQzYG+guaUwiwjULiV6us3/8tKI5S
         lUqE3mcbQWbd0mrKZOUplV8eWPVc6OwNICp48rZ/KLutjR85ysC9XDD0DuxIBpWXc1FH
         Rxow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773173939; x=1773778739;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9TmROf+bPb6FNDxEurt6WhWR2L8qwZm5Ni95BDxLLsk=;
        b=WM+mdDd3USrUem9LyMi1BG3XH+RL4U++xbeLQT1Ei6spjzonUuRh8sRLhy8BxiUpAC
         gVG/IgOgIRdUV66YPrTlPBxX0JKlVtxgEIubCE/7CseS3Ub4CMZoK0ZOGTKKZJHDHio6
         DcNdP6CWBx2+hpZQi9FGIKH6tRSSiehDVx/dJ/xDinm8xEkssN1DUpyvahHGjrcko7DQ
         xdlVxrbtg3+nqjPHexrOI4tmccxyOyY3lW/Szj8aTUMKh4UOIrkGpGq1xgp28eWidk5c
         jy026rPNsTkpoSWVma4y0PSVpbaR1dGje/bVaI70oECZisg/lvmm0UALPffgWGY5vKx2
         ccBg==
X-Forwarded-Encrypted: i=1; AJvYcCU+m2fg8UYnVTWzU3YbWhbv+b+G38FT2p6dD4YzzIIDsc9rYykPBaGNKNeaE6th2bLNKcPaWolmMQ==@kvack.org
X-Gm-Message-State: AOJu0Yy7fT1RmHoRt1+W47bmD+FgNEGBx+/M/TzydjQS8p4ng0UjEQA8
	9NSmDg9soBptH+q6467XeXWc7dX2JT9cLgej6XgCWWdr+nIDw+zXdI5mNb0ugKFj1UsufZ61tLm
	ETD3NAdAQ7E6sBxcyEXg/V79QN2bpqeYgv3RGzjtUfk5K4q7RBNqZXA==
X-Gm-Gg: ATEYQzx8we1N03Y/d9D2lB31Rsqb5gcEot9mLu+vBrWXxsVaRZi9EHxbz9ivIBTqona
	j1LWHRWHBgBPjFTSHb2xsirz/JyVsaY8OAiHYV8XQDeHFzXOQxJ6FxOTtGuEs9G0PpFknQydKho
	dIsQSvGPWlxqJjTE9zD7l2RIxcL+Kjci2pQxoaWYgMJHYPvj72C6Ipv00zwcZ2SFiadMjoqrevN
	4l7o+RGSAZe+hD4+WRFnSrvGGlr8RMfmpvSe0Kseo/VdF+CpMHgmggBxXcAOTiM2VcXCn1CvrMJ
	6sVcVazaB+Cfep72MZpqql26UbaSLEY9P8sM5fzVRgnxBXwfYuQDunEzLn92iyJ2gwVNl9E4FZ1
	10vCLI1oGWCTTnE7jUZnrMrp6lU39cd9zAP5K2AZbDEAEW3Ut
X-Received: by 2002:a05:6a00:a208:b0:81f:852b:a934 with SMTP id d2e1a72fcca58-829f6ec4858mr185497b3a.24.1773173939250;
        Tue, 10 Mar 2026 13:18:59 -0700 (PDT)
X-Received: by 2002:a05:6a00:a208:b0:81f:852b:a934 with SMTP id d2e1a72fcca58-829f6ec4858mr185434b3a.24.1773173938596;
        Tue, 10 Mar 2026 13:18:58 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-829f6dc2d0asm115262b3a.13.2026.03.10.13.18.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 13:18:58 -0700 (PDT)
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Date: Wed, 11 Mar 2026 01:45:55 +0530
Subject: [PATCH v2 11/25] kernel/vmcore_info: Register dynamic information
 into meminspect
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260311-minidump-v2-v2-11-f91cedc6f99e@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773173756; l=1244;
 i=mukesh.ojha@oss.qualcomm.com; s=20250708; h=from:subject:message-id;
 bh=W0/rYOUIz9/ZCoXh44K186q/e3UtR3GkqMBkRm9T0k4=;
 b=ludxEbTdMls4VjiNy/QHAIk8/k+SgkzNMzSydpcQb8gVJ4uiMEuIbGBNqWIItJVo0Zf5Xkd+v
 kxXcoDDsIsOAhyrZZK7SX5Tg2/pa7IFWKbP5zQo7BszRJRELF9pecT6
X-Developer-Key: i=mukesh.ojha@oss.qualcomm.com; a=ed25519;
 pk=eX8dr/7d4HJz/HEXZIpe3c+Ukopa/wZmxH+5YV3gdNc=
X-Proofpoint-GUID: V4QmBIAM5C6L6Yi9mroqvHs61MtqNMxS
X-Authority-Analysis: v=2.4 cv=D7BK6/Rj c=1 sm=1 tr=0 ts=69b07cb4 cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=6_paXCCOVaejlYIppVYA:9 a=QEXdDO2ut3YA:10
 a=_Vgx9l1VpLgwpw_dHYaR:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDE3NyBTYWx0ZWRfX/3pxq5k20xpR
 RsWdhfdVA0HQMwMOFSxYLVUasU3+KCsrdmJ6B3jBoh1SZ4kvajRvWg1kSsZ5128kM7bIhWAYN15
 bZUoLt7WXdNu10KyZ8FKcbgIr1x3UmSe2qMxbwh3nuvjqAr3Tzlnl1L+16MTRY2Pj+gC4CwQxR6
 4tDJCKMoKXnn2VsGHXguSvwD/gefgTUgbQxiJOHbjs5pW3LFaYn4/i+s0t9GkP00idXT15Ae9bv
 Y5m2UVkE72evA+v9uwwsfcqyZuCytoasnkY0eef9mPX//8C4k+BzHlOMY4fvFcC2tCs/Rv92dHj
 TM+/btkjRcymle+fivW2SNbgyG2J55epZhH9i/OoaqblQqhkMTaYGd0/vxbbIiAXuCGT+26NE0X
 lDM3HbmM1YysL/GEHZbsae5r7pcx/NrUJ72BGHq93XG30Ak8IrRfq/+4h9GJQFgwKXEBrB4kT3t
 csRi4U+RoMZYIDUD/jQ==
X-Proofpoint-ORIG-GUID: V4QmBIAM5C6L6Yi9mroqvHs61MtqNMxS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_04,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 impostorscore=0 spamscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 clxscore=1015 adultscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2603100177
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5B3A2180002
X-Stat-Signature: bfhuhu1ihofpo1eh5wzqyo1dak1mhkes
X-Rspam-User: 
X-HE-Tag: 1773173941-208024
X-HE-Meta: U2FsdGVkX1/gXkCQiaua9ugl1gHCHANhXf5/EmRKW/td31z4ACh8kUg802KS17U5U6JeEkZAgf7jpB+YyUKUChff7fuuQ+RMyfLnuKa7oK0BTklMonkYetugTpcW5rYYOm7sLBAZVE2XFwMsq8VC8dSMf5hSjVZuC5Xhb27DqEUAwrd6F3dtYYFwrbVGwONVTr9xBvKa+frvNfHqzqfQvmhlCkTfuwR649Cs5cImKIerY2ajKDnEGuP0QmYNCNzTwTmeQ2HLc2M6e4PgmjvP/uDHR2LY0Rv7TJcsFzorNoUojOvdFk7VHueOEUDx+Pd1OuNmu2Ieqkkp4jNsYwaIpyyretQqOfiPkPCQGD/WTtvs1iDoqbK7cH7LDgu3rtXEiTbYSQkVyztf6q7Dyfe8XQSlkhQSD0K6iYMC6yiS5B3qPptCm0m7gRjS0tGHvH86CQWOGtIgFx0a5Losdi4FeUCgYHIba1yM0QEUjJo0+7mRy2Mluhw+j3bf28oA4ckNS2r0RkdVzSfwafRAi9Fvcf3ONJjCz3Zp1rE26JGIvK3S1J+jszj6tUPxRHG7I6zJgSLxvK6QCREqTmpGbMMTmMvABnBzqQ+I2H/B7cQDpO+ggclOMqZC3NsHzQ7oW3bEQ9olVAlLkEs43NnwzUOm29mi818V7wynz3Rvbowexa2KOKR+riKHb4VHho9gRYCSL5/i/DCD5ezRd2wnRJFx1tDW4sAv8OBE1adgUJBygw3TGZ36PF6jxFh9nNbS7+SfgFnrENa2DM1Hcx7nlC0PCp9B01QQNKF64EznNTwIfXIpKpVbKTP/GtYojSlv/v1FFht7E4OGzN23rQ+T4OYzSYMPFeY026ztIOZltgTzAaLsJ5N8ZLrLp5A3vzzbYxyUBOAC5XA8tD0tskGgBtbTIx6lZDxib71Z1fy+NHf948aLgjvgfHWOK+ILjuL0NbOLGhSqEP3Dpr8aXcIe/Ne
 C7ON/waJ
 whkCHjfA0CuIi+5/qMRdQMUBOU5RemQiOs+9CPq8rVjU6L0qrpnjqa7XGEqWO2fMFXpFnWavqfliyToA5KYefTvvQzeky7OFbnFfWFpqvHznhwhJfMT5TQbswYhY+VPqEVS0eoZIM0N4ACzrM4OnQ4eFLw70bJXQGs1w76p0d4jlcvVBWctCqoOIQjxjUp2Fi+RnlrgPhBtjJG/tk8cnYUNuU23sTKM4gadRcFVFy1Y13X6KD71jJKbJE5FbmDNqO0V5c5zINc+FI3CmstVnobzQuc3tXJtQitktBBnscucDzu9SN43rxQ8I4Yxf50jS1V0fZo2NGEJgVlwmt7Qs4dtGTXk8C2Y5KRpedDHLlcQ7M6PGtDJcbGKKUwKZyK9I7UknfnkGIwX1O+A+0vQt+S4WPx7tRs4rsTGtL+YfK3LS0ektMdP38EPi5mXZZe5wvAv8dm9eDp8vjcf71rD27QkW7w9C6bKGGQSGlDZM7/NK7vBvVyFUHh46u6OHQUx4Mq9Hcfb5iXE8t+ePp0/uJPb7NJdkjj+YMvlc7LCEYlicqQOswaddOyiZgREoAKCA2xX9+K3b19cRygNNfgg+imzlXFjuUUvvUS6zeyLN8AXN0U6m0PPR0rEt2NVJpcpUgWDEloVFaaCjKOVOX7AyOuFKV8btmzsYKJ384eVkbtgQ6NyADISvUYZy3Idw4MD57mk3mNP03ARCUrsE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Eugen Hristev <eugen.hristev@linaro.org>

Register vmcoreinfo information into inspection table. Because the size
of the info is computed after all entries are being added, there is no
point in registering the whole page, rather, call the inspection
registration once everything is in place with the right size. A second
reason is that the vmcoreinfo is added as a region inside the ELF
coreimage note, there is no point in having blank space at the end.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
---
 kernel/vmcore_info.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/vmcore_info.c b/kernel/vmcore_info.c
index 94e4ef75b1b2..4ebb280dc38a 100644
--- a/kernel/vmcore_info.c
+++ b/kernel/vmcore_info.c
@@ -14,6 +14,7 @@
 #include <linux/cpuhotplug.h>
 #include <linux/memblock.h>
 #include <linux/kmemleak.h>
+#include <linux/meminspect.h>
 
 #include <asm/page.h>
 #include <asm/sections.h>
@@ -249,6 +250,9 @@ static int __init crash_save_vmcoreinfo_init(void)
 	arch_crash_save_vmcoreinfo();
 	update_vmcoreinfo_note();
 
+	meminspect_register_id_va(MEMINSPECT_ID_VMCOREINFO,
+				  (void *)vmcoreinfo_data, vmcoreinfo_size);
+
 	return 0;
 }
 

-- 
2.50.1


