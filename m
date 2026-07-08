Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8A5CC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 05:34:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5F0A6B009F; Wed,  8 Jul 2026 01:34:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C34C06B00A1; Wed,  8 Jul 2026 01:34:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B23DA6B00A2; Wed,  8 Jul 2026 01:34:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 844BB6B009F
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:34:23 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DC675C3E5D
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:34:22 +0000 (UTC)
X-FDA: 84964493964.09.5CF357D
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf09.hostedemail.com (Postfix) with ESMTP id 53647140007
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:34:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=NT2dGDDE;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=F4LeX9Uu;
	spf=pass (imf09.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783488860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9JKSKEpCwUWulHpC5aA7ZnyWLgFgRV0CQRGlkqfNweI=;
	b=BqRhzktRHPjvzDxdLRm+W5uOvKgsREIgMzvKoUOaKKTuSIdZzwAlOsnxGuCO/vYJdQ8pM1
	jLY8E1ljP5/nD4gvmCdJTsdtOyQI8fqe/JJERA3/IT76Y1cxAChMpsY1+hFcP4BgW4/l7T
	VtOW1/2R4bD9hgel6MGrmtNjUa1K6y8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=NT2dGDDE;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=F4LeX9Uu;
	spf=pass (imf09.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783488860;
	b=76fiXcU4eGZ0qx716QReYSrKCA5v0Q/hYUv8ycdRXctImse9fJYFI0JVqxj5WYrF+pIwsJ
	ZTMtTwlIYgehxR22GnzF1O6HxCpiE9OGsZfcteQBBEnkiGj75nAjcbXaf4Copa9JnQGFxQ
	oprtw0LpFMbU0OsUtkmkiAvWtSZnE/M=
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66842Woo1509355
	for <linux-mm@kvack.org>; Wed, 8 Jul 2026 05:34:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	9JKSKEpCwUWulHpC5aA7ZnyWLgFgRV0CQRGlkqfNweI=; b=NT2dGDDEzC2DVpT9
	SrR/ynRKYJyvutjIvYhW8hdnUYlZdoJEk+AnEimC39KOOphBS+JrL0IvpMWzyJm2
	9UiFeYoWYnSa/7i/DVQH7J3ZSewaDtqd1lD3c5aOEP5DaWfdjHkwB/gWRC0c0RdA
	nBeCmtT/PY94Nzd/XFCdUVybp8N3xpWJR4Z8PwTH0AFsEp+Qk2dql+6pTYPI3HLy
	7L49ucsHiWU5wKZhkBXxa0qLekf8/fgpoY/x9pNsOMPWBeNx/GHuKS9t1ES5MOuB
	CAKXUZZzqHepgOdcWQD05u7ulY1OLpNlml38Wm4J/iovZ0+2gQMxrr1BkR0vOWyZ
	XwfwEw==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f9be5915y-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 08 Jul 2026 05:34:18 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-847b8d76e3dso451576b3a.1
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 22:34:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783488858; x=1784093658; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9JKSKEpCwUWulHpC5aA7ZnyWLgFgRV0CQRGlkqfNweI=;
        b=F4LeX9UuRO+uVhA50rA9awNsL2BWvEbss7BM6GD2uTzynkhhoywlGic1Zai3ME/GnE
         Ope9sg46dh4fC4+7pxXcCdBmy6OiJZbacP52RR+DtuAJdW9KoqTgT+Yl7PUQLB1+hzdg
         LSiDjWbiQ0prHUhe+V8FC0H4QaRvQd693eOPUfgFzYqW9PLa3CzbBl6qsZJHe9V0QTHX
         fMplz8Oe0rgSkYFh2+yIariuuhBvj+B9J9sxp2sCVOgKeRxMZr3xEB171XeFM9lF4Qgv
         PJHmS7WIl2A7SKoLiMWtkWCQp5uZ0LTUY6ESz5LjfZJUY12yHo4pwb40XfG3KR7ZcJ4k
         7Cow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783488858; x=1784093658;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9JKSKEpCwUWulHpC5aA7ZnyWLgFgRV0CQRGlkqfNweI=;
        b=hzl2V7j5XyMH0QmRRDgUjvv58ZmG0rKfSDcKQHVtYLBpsrTWMc4+WSqRhdikJjw9Hc
         WTH2gdz0fsEJC7vhZMiMqJLSRCDg/PxJtKfDflxBdIp7TebGF/LJvO9VIXwgXMB0ntyt
         p9oHN0FU42/nVt+ZfFbUurf3KsltWxpn7/y5CTZfjTGj/I2ZtlRPwPXO6OmMjYW6TI/7
         ahWqQU6WNsmDHYEkNiG0wfnJ+z4bZBm6AUvhc61rODIHCpPTCf8jPwvSqRwFwhY837VO
         aU3/ejmFui7hSr3bRinj17uGBMCcKxGF3L+lItPFzw82HvdUcD71y4F7UI9NGPUMpaIv
         UzhQ==
X-Forwarded-Encrypted: i=1; AHgh+RpjgjUIo8b54+Y7DO9wDA5lY0S41CNCkDB+mbW4bBImHFqNPXNf+kq9zcdb7CwW3mMi/1hipPculw==@kvack.org
X-Gm-Message-State: AOJu0YxcXgvaxiPEvK+bZShTPAj6kVS5loyMewSJHvN7m0one1+eAD7Z
	6XiRBqxavqg3EuFkcuz3acmKNKUdXAO9f4bAf1Ec5nz3uIHPXxcRbp3g7lN+ngMRj5wSytWdHD+
	ri+gXqyWGkch7BmWCAObCWewvGIY47rWIuIHB4xryP1jckEAbNpae0g==
X-Gm-Gg: AfdE7cmZ5eUELqkHTIG8JWwGUaFy0ksXnPWEkqXEapnSyrYSt4InwYnMFao3JGux2+e
	CN+fZFHdmpbQX2luLHZnFrnTdNMn6kxuXs6ysz+abQgyo9cy/tP8TLlQ8vjlanRZ1tR6QCAg5Ct
	/7r6+y7GPwogdk7bAdtFPkONjUBlKvbjvsU55kGHH2H0guYhh3zhndsSRemhUEauOVoI2b2Qrdu
	UhptKN9lmHaFA+eBHHdbfGO8GcBkIJyxQcmrd0/OIwc2EzEeiSe55B5phWSRjF6SxZlmTaCT2tx
	eifxqr6hVk5RsSycr0ojPsrXdWDHBIADv+yj9GFNomHqhB32oDEjdMxs/fuSJ2umflmsgqjBtzQ
	cNf1o4p/N2CgidieR8moUGxb65vT624cYIvXpJg==
X-Received: by 2002:a05:6a00:1886:b0:845:d286:1fad with SMTP id d2e1a72fcca58-84843232103mr1002150b3a.60.1783488857917;
        Tue, 07 Jul 2026 22:34:17 -0700 (PDT)
X-Received: by 2002:a05:6a00:1886:b0:845:d286:1fad with SMTP id d2e1a72fcca58-84843232103mr1002094b3a.60.1783488857213;
        Tue, 07 Jul 2026 22:34:17 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6db29d1sm6484592b3a.53.2026.07.07.22.34.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 22:34:16 -0700 (PDT)
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Date: Wed, 08 Jul 2026 11:01:47 +0530
Subject: [PATCH v3 08/26] kernel/fork: Annotate static information into
 meminspect
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260708-meminspect-v3-v3-8-7aa5a0a74d5c@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783488714; l=954;
 i=mukesh.ojha@oss.qualcomm.com; s=20250708; h=from:subject:message-id;
 bh=tH4L3qrbhSf/V6y6KtMHUcarziHQ2L0/qqZt6IntL8A=;
 b=83U3lLes7ct+RTYAnjAk+zQH7f+zLTDcoSsWkgRb4n0jXNEWzZ2Nxi22zBFZqS5mjh5c7YHcu
 LAQzf7ye50qCA3/5b7cfLy4jL7uV11VSKD0yoe1rHcr7kFM2lXZj5Hc
X-Developer-Key: i=mukesh.ojha@oss.qualcomm.com; a=ed25519;
 pk=eX8dr/7d4HJz/HEXZIpe3c+Ukopa/wZmxH+5YV3gdNc=
X-Authority-Analysis: v=2.4 cv=GJc41ONK c=1 sm=1 tr=0 ts=6a4de15a cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=VwQbUJbxAAAA:8 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=A5cnksRAjNInYuj8VG4A:9
 a=QEXdDO2ut3YA:10 a=OpyuDcXvxspvyRM73sMx:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA4MDA1MCBTYWx0ZWRfX7ebRK8JPtLFU
 RHIscHj5kOO6RKKEWrs9oC3CP8qF/yL5lhvNQUCkyetFiwzaiJBPbf975Vvl0tpA6ibYcOsA+CS
 0nBPNgeSFfwo/BZVjN0RCGL05gDF2Uw=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA4MDA1MCBTYWx0ZWRfX/O4IXoYIhsK/
 vgrxALDHoAH4GCHomFy6o+Il71V0mom/eao/LhC88MDHw+uJ0/R062PQI8wOdvVJvizQha/kOhZ
 skHynjBFsI844NGThqC5p9APJnw/+Rdokj+XuX8NY10gGnoxJut3S/k2xXHx8AQLG+cpIEpPgCV
 jDtsKhj9jOEgqhsTE7Q3MZp2EQ0cvvcgqKPo/aelTvoezudRniDGacjx8ULa+RBgb0QQXMRlOnm
 dEScrn1CCgSJzMsG7Lm5xUuRifQEjTYMmiSZoJCqfdtzbKG4DjehxTuDmhOqFEj+T2gr05Uqf+Q
 dzC+Wz+fJGtm/5QuL3iQeIXl4yeDuQDgCFhsws0iTI9thORaaLorm5XLixfDXuVEwF8ZK1bgfeR
 nPZ5jRYHaKsdVgjCFpi6Yq4SQeRowIaO5JJ1cquxwFn7GCudnl/uCEqquFHjhIETxziwEz8XVLO
 Jst24P1bAQB1J3+Dn1w==
X-Proofpoint-ORIG-GUID: erYNaBgUiu4_54fBzZwxz2RUigRXlQrk
X-Proofpoint-GUID: erYNaBgUiu4_54fBzZwxz2RUigRXlQrk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_06,2026-07-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 clxscore=1015 priorityscore=1501 malwarescore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607080050
X-Stat-Signature: 8hy4fqzopxe38a7w1cjd61dxbh33iai8
X-Rspamd-Queue-Id: 53647140007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783488860-522146
X-HE-Meta: U2FsdGVkX1+Symqu37Mb/tJY43TSRHu8Tg15lpuZl9znnK86um+4upGjvFGImgZiJ8uN1iCSwM125pNyloI5iTS6ZJcSXaPXvB0giidS7EBtq3Uy+iQ2ACz8BiucdwkZDFdc2sZJ7XE0qAfigofaMkRIi1FZPiFodFArtMMPecQ5dFtY9Mk2IV733uXvyrWdiD80x4NzDpjglILVp6MVEChhpA+AaFn0iAlqPExTL9gF6eKNfxgkkaw7Rz7MHEPAZmpR8PKlQb8J1n/C1i8g5Om+TUNOIBD1Goii4sJ6gUNEI3UNJdWSbkO4agK0uTKxYdY76oGaQcbbXWAZwLA3p0SrknHx+FWxVeY76eVCQweCqwI/5/piH5AWxtWm7VxZ8WU2hyN0xzHjacx8BDo7FBWlDZk0hpLxFdX6sonDv3xW1BINWJzC4/4bOEsV4QOrxHC2jm0z80Ims74XlBZB0kaiY4ZzHMmwrnnHbzPkK4VvsYj4FQCf9D9U/oCIcFL1Nopt0WCaj33MS07tRsHZUKCHAVfXEqJhFm/wsuj3lhZLSDiUJykzWH+sOA0nV5sIq9MVQB6bIt+c4PdUC2x1Frzk1jV/UPmEOU103kYGFsza0T6C3yCdaG3HoEPwML6ErbRNJWwZgF3byql1/bfiPkrl8fKg8m8v9L7qqNiILwSC1Wc6Jg2wTfaAheGFJ6nc86kJTJHzZJSF8nc+TQzuqxHgnqFWVWVbaplAOT6KUNTm5MjfcOfJROIwpFbEPlxGpWQBm4bqJeC9QbJd9vqiFbtz9eMtDUMFONY29/oI/mP475J13z+XkKfi1VXf/D0B12hUAVnrn8Lmt1eRgSY2ni57uQrhkEBCttIqc/3zg9eikHEqd/IzivErcAxrrEBMhXbhuG4KJ/bX/4QAjpAAhHDHDhi4CVmD7Rbmu9OzBxpOKaRw+Bn0+WTkEq77NmsrE6l2gxpw0YAAmzn+VRm
 V0l27tGd
 YqyjvT4hMSAl5IARUHR5OgUPqrTcMc0Fi/WHU+KB+a5RsRR8PU+JWhQpG+YDnu2xrkmMmQHMJYaqK+GofOIC34i3Wfy4l4VVTwTdUcaTaEsewInpXh9oCdN3i0DOLijjYYkKIVKDaNWbpc/PXM38oOt0S/d06q4+YHwYXkz7679e/57eURw1vbPhWZ1mDQJ6C0Hdzr4t4+oMatmYeKrBfp35wIxCaXYgsxyxJR2pOV3g9K7D9YarXicj9tcqK5lej8b8HLPkNlXQU5RxSQvhlBBXXOpeNEvXgCeJooMpCMvmwblDtIN6wAEta1fLsScfTcvk2iHSJXOfVQyBBqcdWGwyAt6xGUggSbihr9iGT6iCUEPJg1/MXzuY6ZyvKGpLumNEQ4JUzXMgiQPP4ORRiAnIHMKEGclpc6YLGfmvsuFbWLl5GJ2p7EtIb5PYYNWkXA5ZlPoVnB81ecrZuIl74IMjQPMFpkp9j+QpXgvSpF1vzXaP1AzZq7xNZQNql4helGa2Mmdp7o4/RSLoxn0VW+ysXgEP93e6iUl9Ep62F3DTpzAtUjBzj25tt4QguOmJX8J25cLQt8qwY9M0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Eugen Hristev <ehristev@kernel.org>

Annotate vital static information into inspection table:
 - nr_threads

Information on these annotated variables is stored in a dedicated
meminspect section.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
---
 kernel/fork.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/fork.c b/kernel/fork.c
index 175c73bbe2bf..ec99066eedd2 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -111,6 +111,8 @@
 #include <linux/tick.h>
 #include <linux/unwind_deferred.h>
 #include <linux/pgalloc.h>
+#include <linux/meminspect.h>
+
 #include <linux/uaccess.h>
 
 #include <asm/mmu_context.h>
@@ -142,6 +144,7 @@
  */
 unsigned long total_forks;	/* Handle normal Linux uptimes. */
 int nr_threads;			/* The idle threads do not count.. */
+MEMINSPECT_SIMPLE_ENTRY(nr_threads);
 
 static int max_threads;		/* tunable limit on nr_threads */
 

-- 
2.53.0


