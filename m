Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 505DBC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 05:38:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 365436B00BB; Wed,  8 Jul 2026 01:38:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33E286B00BD; Wed,  8 Jul 2026 01:38:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2053B6B00BE; Wed,  8 Jul 2026 01:38:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DEBC06B00BB
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:38:21 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 666644067B
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:38:21 +0000 (UTC)
X-FDA: 84964504002.22.E8EDFC1
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf03.hostedemail.com (Postfix) with ESMTP id E2D2220005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:38:18 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=UhKz1d2r;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=F36c0WGm;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf03.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783489098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4uaqsQxpTR8RpSZdJeOQl+tiox2eApQxHUlenj887SU=;
	b=Yr14j0XJISHPtkadcjMTeCWQp65/FV1+v9cTioD/7XeXTfnIhKA6RRWLFvAuyzadRg7RS1
	+7oTmJR2LRtrfUaOtnjoDOAQSdr9IxoBDJKzUgZje4CPwH14WRvEGtff6axfSyoFPLhWiR
	4EZaGFDhGURqy8wA54by2bgsLyQf6/4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=UhKz1d2r;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=F36c0WGm;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf03.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783489099;
	b=OVNSnJYLzHXhIjdqabH7T/fLGPBEJgQnRXIDLuKIg8vMpkAmLQ/WFiLh3b4C5Yl1qHU19Q
	Jn5GLpNWgsFSw4ZuTnEjBV8bNLjdZjGz1MF681mivvK0JUz/1+qUhh5pxAP6PGCdtotaxB
	hF5ME+FirGwV8pJ70+9sZJLgDlI+unM=
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66842aLa1491302
	for <linux-mm@kvack.org>; Wed, 8 Jul 2026 05:38:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	4uaqsQxpTR8RpSZdJeOQl+tiox2eApQxHUlenj887SU=; b=UhKz1d2r2b0Ku1Vs
	mhD/LAkxjkGDGUdL4T6qopTKEsW9w0x96TRlYmlKV1vhZ6f+562jcYnjR/O20sMl
	cIS3FCb781xFQAnQJmuku+5NqPawQ6W1VS+DdxyqL0JUSNpIb4J714KCHN0NQ1R/
	9LhGSCrmQ+qWUcGhspqisvaTtDJyqguPfoShVwDVK+s8QCDqPfVuY+jtgi9rmuih
	gvR6+bMt3Vq4kV93NQsgSgvUsA/YNriPO2Xog3RBkdbuOd9QVd/GW3LIncYJbQGN
	j6lOs0S8WlVyBQW5hKbeTqWDyy7TxLzIHYJzFPTipqFU6J2w9CMc2fxOJinc1aSU
	cSv2Pg==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f9b5g953u-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 08 Jul 2026 05:38:17 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-c890bac374eso399353a12.1
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 22:38:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783489097; x=1784093897; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4uaqsQxpTR8RpSZdJeOQl+tiox2eApQxHUlenj887SU=;
        b=F36c0WGmjk7C3hGPq0qVb4YOov3vRtZ44aauAzBoo9EH2wi3VXuNvlh81gdHGIEn5z
         DZL1fXkGfZohKpTynnqhrCc7aCce1paGriCHexupsNq+sG8aCh1wwbjTGfMEwVK/31qu
         Ue3cyxw05u7GD5KiKdiQnOVThddXE+EqlvObBIuhE/3y1eCF1mOtI5XJdIQC0RcABsd/
         iGdJnZuXJaXmmg7Vwm5Y/qyKxfS3J77TudLu0WW/udCoSf4EPwmwOfS5odJLfbql4EbX
         Dtq/BW2Z0b61RtUUxUS150oU3obaR5ksd1n6A17teKf4X/3QU0V/8AyaK7moqOW+8n23
         /mjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783489097; x=1784093897;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4uaqsQxpTR8RpSZdJeOQl+tiox2eApQxHUlenj887SU=;
        b=YUJbkp7x3rWsHTB42q8wJEDwPBpk0zrkdJiOKW8KFEX1ppElXuTWcI60xaiVUgxF3N
         YnitSPCEumIcELeDkvWyf/t+MfwFHwQkP+52idzKgF5eVENkWXcmdxSg5EjVt6ZRYFbE
         SXzWWLKKgxiWZM2tYIABsvO8AniLGjd04wePWZ5aCcNgFKsXUXZi5wiznD1qW4kHRAlq
         CEamrR+QEzBu7+85C+MwFM2rLuaUMbtInrINXl1N0Tn6NkO/V0ylaAA66XyVtzj1H9ON
         4w2YoNQzBDOA209UwLxvyLVIueSh8T4VhZMh4xzfuPkFLjl5y2xlY2/uoLvIsZt7clPh
         57eg==
X-Forwarded-Encrypted: i=1; AHgh+Rpvcss1EK6VxQAgajm2eZD7QPRPuacZwu+J94nXhjNwWhBesrmGaf7n7mMclkXeSNMqSDvt4MSUQA==@kvack.org
X-Gm-Message-State: AOJu0Yy1JaL1T/K/j4JltYfFtecwqrT5MxvyZ1VoX/VbVBnjIyskegF/
	u2uPB0vly3+o1ETBp/C05yPtoMUbo38yLHgp/mjDg/337RHFWuplpHcrg6qpUA+jx/K6pFjy+ly
	SMDJDvoNsBY/YswAAyhDl9y0rcKbz/beFfp1BFhT0SnKfwhvGZja+sg==
X-Gm-Gg: AfdE7ckVcYIxmo/xGRX0qu8L1NNDAOMqQeFIhdWBan8ionHp/gKrcwMYek2mfMjxW9U
	BUdprJd1ruS58NjNH6UXfCZrVxNoIdNB39+3gxC6BNJTfnc2nVqelzMaApVONeilH0qj1Wx1xso
	KIr7lTAPwQEvX4WQEW1Ng1pdV4OGzKpHGwiIhhtxiJZLqMhgnwkb9f49+6RMYwAAVQ+x7hY8IvZ
	O0zuYcpFURAg3JAYe48Dx4AqsfVqK0Du56kOa43VGa+nuNHQ5OP6elR4eca93B/KXW6Ut9p7Zn6
	0CwhzOUU40jH3b/kKyUwcqWn9+oFS8PP2bZ/qv+LvyaXeWFvvxaThlyNqxmZ2yisf20oi6OR7fm
	qbfhiY5lQPlknxyawulg9c1ODdOhnUjNv2DE+vg==
X-Received: by 2002:a05:6a00:1788:b0:845:dbdc:8652 with SMTP id d2e1a72fcca58-84842ef7cc0mr1290275b3a.2.1783489096512;
        Tue, 07 Jul 2026 22:38:16 -0700 (PDT)
X-Received: by 2002:a05:6a00:1788:b0:845:dbdc:8652 with SMTP id d2e1a72fcca58-84842ef7cc0mr1290192b3a.2.1783489095833;
        Tue, 07 Jul 2026 22:38:15 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6db29d1sm6484592b3a.53.2026.07.07.22.38.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 22:38:15 -0700 (PDT)
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Date: Wed, 08 Jul 2026 11:02:02 +0530
Subject: [PATCH v3 23/26] soc: qcom: Add minidump backend driver
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260708-meminspect-v3-v3-23-7aa5a0a74d5c@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783488714; l=10861;
 i=mukesh.ojha@oss.qualcomm.com; s=20250708; h=from:subject:message-id;
 bh=C4zw9u57Cm30tj5UwIY6cG4nP7P9VZzOHqP8Ahuf568=;
 b=TWy1gg6qqcU13/y4eYt8LPmEMx41ylpHNSFV8hpJ+sMA797npM5z2aTVpXu5SYLW5z+D9jYpe
 lKEQN/RO3BJCQ3JD+H+Jm+TDaeYnP+RF0Mg7eTdFm5R/Rj6/bRkz6z+
X-Developer-Key: i=mukesh.ojha@oss.qualcomm.com; a=ed25519;
 pk=eX8dr/7d4HJz/HEXZIpe3c+Ukopa/wZmxH+5YV3gdNc=
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA4MDA1MSBTYWx0ZWRfX55Q3jd6sptej
 CFNIYUFTJMf0gkEIs3qGjdXJkpAFyS6sKqeZ/nq07QFfXnDiHEm0gZHzFppm93EyRbeHs3d/Wfw
 gvAeFl1825U0mlg0nMmhQLHrf/0bYYc=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA4MDA1MSBTYWx0ZWRfX0Zj+mxhrmy+z
 LVEZuGgTHmPxzr3U6p0jatnacuv+sv5LIn04mPPb4/OVGYPSLmLAZY+O7Acflufk4n2kujbukoY
 8JyrNRyYsbIZrGAlKLB9mqNaVUTwJx4AXsREsj9obF7dQKoeycFVlL9HNRU9FVDLcahtNqxXSus
 kW0ZTyzqe6qw1BLo/ymHFydqWHKDWdQTW4SWmzLIGtqevOUAU9kcGdkMVEBZ3cN5tT+HancLCg3
 NpXYjaW23um1lERIwEZCjMvF1aG+SJUXLSJlHKzOXgyvZtN9ZK2V3bb0RQAYDYTqVLZu8QNIib/
 gdgLUI15lCbq7nvp7Qr5lM5si+Ih3pjTSa9Sew2Ttgy0vJI+TG8n+ntIzxmjTvfKhmthFP/I9b5
 TShQxQgp2nhXXAB0mRB9tIajoZVc1MxiAeycT2nWKOEws0PcBkpnYadUV2gaGbjVLxwnSl6N6ON
 KDr7p+mSm3lzvVUHAzg==
X-Proofpoint-ORIG-GUID: kmtbquJTJ3Tt-ggyK17H94Z1anDEMvQd
X-Authority-Analysis: v=2.4 cv=JLULdcKb c=1 sm=1 tr=0 ts=6a4de249 cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=VwQbUJbxAAAA:8 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=nZcrojPlbim1gEWq_fIA:9
 a=QEXdDO2ut3YA:10 a=bFCP_H2QrGi7Okbo017w:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-GUID: kmtbquJTJ3Tt-ggyK17H94Z1anDEMvQd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_06,2026-07-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 lowpriorityscore=0 malwarescore=0 adultscore=0
 suspectscore=0 spamscore=0 impostorscore=0 bulkscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607080051
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E2D2220005
X-Stat-Signature: pbp4bq1y9wj9d6fsgai9k5qcemqm1czs
X-Rspam-User: 
X-HE-Tag: 1783489098-528447
X-HE-Meta: U2FsdGVkX194OhVLuHIdV6UBewrQgRXeokiBVMh25ecyt/3R7/c827to/CEPjHb2+nQQMbWcJ3Z1C57CkZd9lvtkLm7tPHT3PjozowQNA7x0kZ48i1o7aHTEbgoNrUnh0j2c9Zz6oU0FKDFGS/sdYB+/TkqBekFnUCH2laKu7KOOpgf4l/RVjQ9Z1Uck3cqwkP8p2PV+sph96cpE+6WRjgmfTLeMsQVP0alpq+zLCxcWPCjjuGjzgeIFollVh2IqAOJVUGF9tGeStFnQ/6OD2bcnvru2yPhu4N4XIfc/ylFIVchemPFS5KOnhtQ1WnSnL2qv0tKT6xMtbY+G1l5hN99STyUaIRNYWaNJaWgvlyYXTzfj2dOhrKXOwRCcdPU7sMfiJ4RR0NtrTjy3kO/8QMQXdcNb6Q2Vog/ObGBMi0m9Jy3WWR+TcUgUB0p7tN5pN8ffpX/necsKpz5jqa2PDYEJCtCFSB7RS7yqOyscKs9kT+iUouvcToDeEqH6byAfAPUn+KEjGVUpUTy5cS0ZsProSRUiIB4m3sO6BHB91Hvw7wJizalQ75pKBA8sjqP4Pp8sFN96gec3k9GEvTAoZWF6W+aZKZG3mrJyhOAw5j00t6FSimdMLxF1X5c74iihWH3otm3qSH6tcxZSnmJEq+S0Ko8n9raeikM4ef8LDgNh2Hgef4yC1NLiQP441T/lQ59uc+uiRmF86wtv/j50wBzbV+nsGt8Fja+onztvnK+pAo/fLb8X+rSsbpdJWGTLJAobvfEIzfd3RLYOEbUff7YNwxo+6g9mSvjVINs7H86SxTH4Rjx9iSbV4jGoJWXNTL6BoEeGtoD6wlgA+yH3sdFiw0D1w8rBSeQomNwwYgL7tbK93elZnv8/hz6y9oUDZPjYfF4gPt2JdnhdzPCIFevw23H4ZbkZOD7K2IWD4+RvybgzYreCVbKgPyxcrgD5yB3GgHszpeZ0UKdK6sG
 pJhJoEZW
 UWrZRUn3xOn135QGAU1zaN2bXOxnb6w/4gxVLDD6z+3yofvjp7qJ4AoV04OjhSzjtMGJPtOF2RI8fmA/5k2/1HHWCdEgxzCfaLMf2PHUAdWLbMhF17YlZM3dhCo3QcoPX7KrPLZ55kzWyb71EPiC7MvYTLwtsTKnEn53TpPMnkSE6ApXRLT8hi0f1e9FHq1tQUz60SS9r0/cwTpeC/Ymdab4XAa6TwEAPyzsnn2iSSuHPEsYx8Jd4Ph9VYhZpcusJO4E/nkBndk7gCb3x8b6Zqi9iNf5xkrx+Q52rw/6oYTq2gpCIDfvF61xnp7UxGfOf/0KWf7rUAKDKYV7DPFExvWU52oH8kQLqmGlEitd9N3YSOIAU7fmDZZ1uNkBY5/tS+68VnOouvTapzuCViFpesSiZdnTE3szhz9HSDLoY9jbjH+7bdioXzTbwjW5WKWsM+eNIw4L8FomZb89z5Bj60q8zYCwYlSq2O5a6CrOgW10SwIoZbYuoCWAGe8IP1DGRJzigABvY3KxGtc0XkV9DRSTkx58IgUuH31Yd6GLklKNPAGVext+B56a1KYNCrGxqLgYlrr6doftJ8/9JrsDEEkmnrWGmE0gvxi3m++9TSo1bEDcHyCLY9lMizRNYSX7NNCQwmnqaj+6zxbmv6ZcYolEw1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Eugen Hristev <ehristev@kernel.org>

Qualcomm Minidump is a backend driver that manages the minidump shared
memory table on Qualcomm platforms. It uses the meminspect table that
it parses in order to obtain inspection entries from the kernel and
convert them into regions. Regions are afterwards being registered into
the shared memory's Minidump table of contents. Further, Qualcomm boot
firmware can read the table of contents and dump the memory accordingly,
as per the firmware requirements.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
---
 drivers/soc/qcom/Kconfig          |  13 ++
 drivers/soc/qcom/Makefile         |   1 +
 drivers/soc/qcom/minidump.c       | 271 ++++++++++++++++++++++++++++++++++++++
 include/linux/soc/qcom/minidump.h |   3 +
 4 files changed, 288 insertions(+)

diff --git a/drivers/soc/qcom/Kconfig b/drivers/soc/qcom/Kconfig
index f6970431d07d..18ed8d6a3b62 100644
--- a/drivers/soc/qcom/Kconfig
+++ b/drivers/soc/qcom/Kconfig
@@ -180,6 +180,19 @@ config QCOM_SMEM
 	  The driver provides an interface to items in a heap shared among all
 	  processors in a Qualcomm platform.
 
+config QCOM_MINIDUMP
+	tristate "Qualcomm Minidump memory inspection driver"
+	depends on ARCH_QCOM || COMPILE_TEST
+	depends on QCOM_SMEM
+	help
+	  Say y here to enable the Qualcomm Minidump memory inspection driver.
+	  This driver uses memory inspection mechanism to register minidump
+	  regions with the Qualcomm firmware, into the shared memory.
+	  The registered regions are being linked into the minidump table
+	  of contents.
+	  Further on, the firmware will be able to read the table of contents
+	  and extract the memory regions on case-by-case basis.
+
 config QCOM_SMD_RPM
 	tristate "Qualcomm Resource Power Manager (RPM) over SMD"
 	depends on ARCH_QCOM || COMPILE_TEST
diff --git a/drivers/soc/qcom/Makefile b/drivers/soc/qcom/Makefile
index b7f1d2a57367..3e5a2cacccd4 100644
--- a/drivers/soc/qcom/Makefile
+++ b/drivers/soc/qcom/Makefile
@@ -25,6 +25,7 @@ qcom_rpmh-y			+= rpmh.o
 obj-$(CONFIG_QCOM_SMD_RPM)	+= rpm-proc.o smd-rpm.o
 obj-$(CONFIG_QCOM_SMEM) +=	smem.o
 obj-$(CONFIG_QCOM_SMEM_STATE) += smem_state.o
+obj-$(CONFIG_QCOM_MINIDUMP)	+= minidump.o
 CFLAGS_smp2p.o := -I$(src)
 obj-$(CONFIG_QCOM_SMP2P)	+= smp2p.o
 obj-$(CONFIG_QCOM_SMSM)	+= smsm.o
diff --git a/drivers/soc/qcom/minidump.c b/drivers/soc/qcom/minidump.c
new file mode 100644
index 000000000000..78d199b7c552
--- /dev/null
+++ b/drivers/soc/qcom/minidump.c
@@ -0,0 +1,271 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Qualcomm Minidump kernel inspect driver
+ * Copyright (c) 2023 Qualcomm Innovation Center, Inc. All rights reserved.
+ */
+
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/notifier.h>
+#include <linux/sizes.h>
+#include <linux/slab.h>
+#include <linux/soc/qcom/smem.h>
+#include <linux/soc/qcom/minidump.h>
+#include <linux/meminspect.h>
+
+/**
+ * struct minidump - Minidump driver data information
+ *
+ * @dev:	Minidump device struct.
+ * @toc:	Minidump table of contents subsystem.
+ * @regions:	Minidump regions array.
+ * @nb:		Notifier block to register to meminspect.
+ */
+struct minidump {
+	struct device			*dev;
+	struct minidump_subsystem	*toc;
+	struct minidump_region		*regions;
+	struct notifier_block		nb;
+};
+
+static const char * const meminspect_id_to_md_string[] = {
+	"",
+	"ELF",
+	"vmcoreinfo",
+	"config",
+	"totalram",
+	"cpu_possible",
+	"cpu_present",
+	"cpu_online",
+	"cpu_active",
+	"mem_section",
+	"jiffies",
+	"linux_banner",
+	"nr_threads",
+	"nr_irqs",
+	"tainted_mask",
+	"taint_flags",
+	"node_states",
+	"__per_cpu_offset",
+	"nr_swapfiles",
+	"init_uts_ns",
+	"printk_rb_static",
+	"printk_rb_dynamic",
+	"prb",
+	"prb_descs",
+	"prb_infos",
+	"prb_data",
+	"clear_seq",
+	"high_memory",
+	"init_mm",
+	"tk_data",
+};
+
+/**
+ * qcom_md_table_init() - Initialize the minidump table
+ * @md:		minidump data
+ * @mdss_toc: minidump subsystem table of contents
+ *
+ * Return: On success, it returns 0 and negative error value on failure.
+ */
+static int qcom_md_table_init(struct minidump *md,
+			      struct minidump_subsystem *mdss_toc)
+{
+	md->toc = mdss_toc;
+	md->regions = devm_kcalloc(md->dev, MAX_NUM_REGIONS,
+				   sizeof(*md->regions), GFP_KERNEL);
+	if (!md->regions)
+		return -ENOMEM;
+
+	md->toc->regions_baseptr = cpu_to_le64(virt_to_phys(md->regions));
+	md->toc->enabled = cpu_to_le32(MINIDUMP_SS_ENABLED);
+	md->toc->status = cpu_to_le32(1);
+	md->toc->region_count = cpu_to_le32(0);
+
+	/* Tell bootloader not to encrypt the regions of this subsystem */
+	md->toc->encryption_status = cpu_to_le32(MINIDUMP_SS_ENCR_DONE);
+	md->toc->encryption_required = cpu_to_le32(MINIDUMP_SS_ENCR_NOTREQ);
+
+	return 0;
+}
+
+/**
+ * qcom_md_get_region_index() - Lookup minidump region by id
+ * @md: minidump data
+ * @id: minidump region id
+ *
+ * Return: On success, it returns the internal region index, on failure,
+ *	returns	negative error value
+ */
+static int qcom_md_get_region_index(struct minidump *md, int id)
+{
+	unsigned int count = le32_to_cpu(md->toc->region_count);
+	unsigned int i;
+
+	for (i = 0; i < count; i++)
+		if (md->regions[i].seq_num == id)
+			return i;
+
+	return -ENOENT;
+}
+
+/**
+ * register_md_region() - Register a new minidump region
+ * @priv: private data
+ * @e:	  pointer to inspect entry
+ *
+ * Return: None
+ */
+static void __maybe_unused register_md_region(void *priv,
+					      const struct inspect_entry *e)
+{
+	unsigned int num_region, region_cnt;
+	const char *name = "unknown";
+	struct minidump_region *mdr;
+	struct minidump *md = priv;
+
+	if (!(e->va || e->pa) || !e->size) {
+		dev_dbg(md->dev, "invalid region requested\n");
+		return;
+	}
+
+	if (e->id < ARRAY_SIZE(meminspect_id_to_md_string))
+		name = meminspect_id_to_md_string[e->id];
+
+	if (qcom_md_get_region_index(md, e->id) >= 0) {
+		dev_dbg(md->dev, "%s:%d region is already registered\n",
+			name, e->id);
+		return;
+	}
+
+	/* Check if there is a room for a new entry */
+	num_region = le32_to_cpu(md->toc->region_count);
+	if (num_region >= MAX_NUM_REGIONS) {
+		dev_dbg(md->dev, "maximum region limit %u reached\n",
+			num_region);
+		return;
+	}
+
+	region_cnt = le32_to_cpu(md->toc->region_count);
+	mdr = &md->regions[region_cnt];
+	scnprintf(mdr->name, MAX_REGION_NAME_LENGTH, "K%.8s", name);
+	mdr->seq_num = e->id;
+	if (e->pa)
+		mdr->address = cpu_to_le64(e->pa);
+	else if (e->va)
+		mdr->address = cpu_to_le64(__pa(e->va));
+	mdr->size = cpu_to_le64(ALIGN(e->size, 4));
+	mdr->valid = cpu_to_le32(MINIDUMP_REGION_VALID);
+	region_cnt++;
+	md->toc->region_count = cpu_to_le32(region_cnt);
+
+	dev_dbg(md->dev, "%s:%d region registered %llx:%llx\n",
+		mdr->name, mdr->seq_num, mdr->address, mdr->size);
+}
+
+/**
+ * unregister_md_region() - Unregister a previously registered minidump region
+ * @priv:  private data
+ * @e:	   pointer to inspect entry
+ *
+ * Return: None
+ */
+static void __maybe_unused unregister_md_region(void *priv,
+						const struct inspect_entry *e)
+{
+	struct minidump_region *mdr;
+	struct minidump *md = priv;
+	unsigned int region_cnt;
+	unsigned int idx;
+
+	idx = qcom_md_get_region_index(md, e->id);
+	if (idx < 0) {
+		dev_dbg(md->dev, "%d region is not present\n", e->id);
+		return;
+	}
+
+	mdr = &md->regions[0];
+	region_cnt = le32_to_cpu(md->toc->region_count);
+
+	/*
+	 * Left shift one position all the regions located after the
+	 * region being removed, in order to fill the gap.
+	 * Then, zero out the last region at the end.
+	 */
+	memmove(&mdr[idx], &mdr[idx + 1], (region_cnt - idx - 1) * sizeof(*mdr));
+	memset(&mdr[region_cnt - 1], 0, sizeof(*mdr));
+	region_cnt--;
+	md->toc->region_count = cpu_to_le32(region_cnt);
+}
+
+static int qcom_md_notifier_cb(struct notifier_block *nb,
+			       unsigned long code, void *entry)
+{
+	struct minidump *md = container_of(nb, struct minidump, nb);
+
+	if (code == MEMINSPECT_NOTIFIER_ADD)
+		register_md_region(md, entry);
+	else if (code == MEMINSPECT_NOTIFIER_REMOVE)
+		unregister_md_region(md, entry);
+
+	return 0;
+}
+
+static int qcom_md_probe(struct platform_device *pdev)
+{
+	struct minidump_global_toc *mdgtoc;
+	struct device *dev = &pdev->dev;
+	struct minidump *md;
+	size_t size;
+	int ret;
+
+	md = devm_kzalloc(dev, sizeof(*md), GFP_KERNEL);
+	if (!md)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, md);
+	md->dev = dev;
+	md->nb.notifier_call = qcom_md_notifier_cb;
+
+	mdgtoc = qcom_smem_get(QCOM_SMEM_HOST_ANY, SBL_MINIDUMP_SMEM_ID, &size);
+	if (IS_ERR(mdgtoc)) {
+		ret = PTR_ERR(mdgtoc);
+		return dev_err_probe(dev, ret, "Couldn't find minidump smem item\n");
+	}
+
+	if (size < sizeof(*mdgtoc) || !mdgtoc->status)
+		return dev_err_probe(dev, -EINVAL, "minidump table not ready\n");
+
+	ret = qcom_md_table_init(md, &mdgtoc->subsystems[MINIDUMP_SUBSYSTEM_APSS]);
+	if (ret)
+		return dev_err_probe(dev, ret, "Could not initialize table\n");
+
+	meminspect_notifier_register(&md->nb);
+	meminspect_lock_traverse(md, register_md_region);
+
+	return 0;
+}
+
+static void qcom_md_remove(struct platform_device *pdev)
+{
+	struct minidump *md = platform_get_drvdata(pdev);
+
+	meminspect_notifier_unregister(&md->nb);
+	meminspect_lock_traverse(md, unregister_md_region);
+}
+
+static struct platform_driver qcom_md_driver = {
+	.probe = qcom_md_probe,
+	.remove = qcom_md_remove,
+	.driver  = {
+		.name = "qcom-minidump",
+	},
+};
+
+module_platform_driver(qcom_md_driver);
+
+MODULE_AUTHOR("Eugen Hristev <eugen.hristev@linaro.org>");
+MODULE_AUTHOR("Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>");
+MODULE_DESCRIPTION("Qualcomm minidump inspect driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/soc/qcom/minidump.h b/include/linux/soc/qcom/minidump.h
index 7449a04e6e15..91d73e647d5b 100644
--- a/include/linux/soc/qcom/minidump.h
+++ b/include/linux/soc/qcom/minidump.h
@@ -10,11 +10,14 @@
 #ifndef __QCOM_MINIDUMP_H__
 #define __QCOM_MINIDUMP_H__
 
+#define MINIDUMP_SUBSYSTEM_APSS	0
 #define MAX_REGION_NAME_LENGTH  16
 #define SBL_MINIDUMP_SMEM_ID	602
 #define MINIDUMP_REGION_VALID		('V' << 24 | 'A' << 16 | 'L' << 8 | 'I' << 0)
 #define MINIDUMP_SS_ENCR_DONE		('D' << 24 | 'O' << 16 | 'N' << 8 | 'E' << 0)
+#define MINIDUMP_SS_ENCR_NOTREQ		(0 << 24 | 0 << 16 | 'N' << 8 | 'R' << 0)
 #define MINIDUMP_SS_ENABLED		('E' << 24 | 'N' << 16 | 'B' << 8 | 'L' << 0)
+#define MAX_NUM_REGIONS		201
 
 /**
  * struct minidump_region - Minidump region

-- 
2.53.0


