Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19D99C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 05:37:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18DE76B00B2; Wed,  8 Jul 2026 01:37:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 166816B00B3; Wed,  8 Jul 2026 01:37:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02DF26B00B4; Wed,  8 Jul 2026 01:37:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CF5E96B00B2
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:37:01 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5D3B41691AF
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:37:01 +0000 (UTC)
X-FDA: 84964500642.13.87E87B9
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf06.hostedemail.com (Postfix) with ESMTP id E715A180002
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:36:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=Hs8CZvTU;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=WPv7log3;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf06.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783489019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IIAnYNUT7JIDk/4EOGJSzGq44L2ybK3V5nw9t/195Ms=;
	b=1UbPCkxuRjFys8nUrZhgWxeRiYHawYdB06izW6O5gjrvwslGGN+/eMAphl3COVjMSPg6Xv
	AyXE4kr/RHqFA/o8Q3pifNEbQpIcsngMwqsxdkVXnDcwGqAazOJfEOwAhfXbF+zID9BYgd
	rM8aFGxo/KFKHES7DH9c6gm55G4vLQ4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=Hs8CZvTU;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=WPv7log3;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf06.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783489019;
	b=RxnDLUiEIOwlbn77PFizEh2Jq/1NdsEMVzS3qBkm+K1SNIXx58ELUnOOCRiBvjj2PpH5y5
	RdzV2wtn2qUr/eb1FafqU1kwYt1ZKLRtipTmSFxiCW4AN0ltv96dLIOFJEQrIohlbsgsn/
	WE1NQuThKfMOPqYY8iaSuI97E1gZkCA=
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66842dqE1573678
	for <linux-mm@kvack.org>; Wed, 8 Jul 2026 05:36:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	IIAnYNUT7JIDk/4EOGJSzGq44L2ybK3V5nw9t/195Ms=; b=Hs8CZvTUdRuUzjkk
	8/KBlB9MALBbYzTPnNpJ8xWKxOD2Uh1JEoxS/ozoSe7jU0eflZLmzdqFEv68Mqu1
	kOpVFvvGZLQXJghlhQepHLbRAXFAW206z4Gw6IWDoZekClP0dJB0UlGPGKXBjFiF
	NXl2wLiBxduoVPT1h1Fk3TB+RAcy2DhXvqlGAQGjV1NJ1cjAUK1VJExCD3PRitlu
	DvdPY8QQNUXkiGe+Kg4UGqOAohAZdO/h7eOPVPjNDgu5uHhwRYgR0VFprg0oUpgj
	D8pHymEERJPjUs9qLNGHLtxM2/pBZDEKvramAwS6Jc4hvz0zeHQD5/PYyMZZPeAp
	hTQYXA==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f99hgshy6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 08 Jul 2026 05:36:58 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-848452dd146so765673b3a.2
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 22:36:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783489017; x=1784093817; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IIAnYNUT7JIDk/4EOGJSzGq44L2ybK3V5nw9t/195Ms=;
        b=WPv7log33B42CYgOSIU9JhbwWf7TXNtPzar8oRTJWOQcFrt+y5Zabb+HFCMLknYm3B
         T0rlv4Of4hADONFCFYw/PiDgce0G3CDSmbMD12bNhK/nTH60mrIKGVMBbmOxDSQeUvdS
         Ta5MG2rB8fCHq1QY8EOrQrF0iiZW/Uq4wisNjSgFZD4SnifTvF33au5IFX1tHHd0XQmH
         jO5bVB2tzXweDfjedQMhU3aSv0roKnPj+9oYMYXfkAhHJzo4ziJV4dSb8hsWvl6N7nfJ
         v6CjUF3UCgAjJGT/GTZAeksR7CnLajqSCpbugFCKcjK9Rh8NvYK3ZVidQnHdYIOIcMxM
         A5Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783489017; x=1784093817;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IIAnYNUT7JIDk/4EOGJSzGq44L2ybK3V5nw9t/195Ms=;
        b=MWZcu5sZtj4MFCvfmd4BBs4LxUl+ftwH7Kr0mPQNBQvq89YcQtYHb4qpA9P/vXSFaL
         lGs+No3kl2tbciqX/cgDr/LqDILqs38fb4M0iFvUo9JxTZTDYQiHAdesIiPOcFCRVXZ3
         ahCCadPsKt688svQ0tx4ixvXL6vEkUJyKXI8JrLKL3/JFuzNMwmHcIXxTyBhZOl6IFmi
         miHFaLZPjdHfeyLfaMx3hrYUo5MCUORzy91O55Hz/TM4LllSrbbIMOyQoNpAFDVjTkDa
         kaj01kP0h/z6pdI8JULLVlyTE4LxHetEdyFw+U727OdOkOLhsxXyCzTCwEyQdntOLC6i
         RRNQ==
X-Forwarded-Encrypted: i=1; AHgh+Rqx3rNP0aTqpumSikeoFqbQmDtxEVDZ0sNRj2KPHk6DlV3c7H4IGmmAy8gTYoCI6GCH9fahFuTDIw==@kvack.org
X-Gm-Message-State: AOJu0YwIKHEhaVvn5pVlTdNvetizFFQdiTp+qtRC8rx+fwI10NPpxuU6
	uz0HZVajIGN7WPM5sfiHBVjOtWL48ndRSpPLLregDave1goWdPxU6/q7nArwEwaQtvXaM7bge1X
	kiV41u3yGZsOPGzVlSvxwRMFPYZCUTIG1xi8b+A3Q25G0iW0aa7drNw==
X-Gm-Gg: AfdE7ckpCfd+CmQ6LiQsPcDGWTBM3TSP6mKhytDJ5SKNqgpOMANKu1h16XVhPJuPZUP
	FrITMLqcZk4XXtp6MVjf4YKmcpykVp5HAsqZ8SHJt53nUSwfMs/TcMoB1kRN0+AF4rh5FagIg8T
	881yJ2U/7oB9qV0c+0fORJtmU7a+uxiWNnywDbojZ6Qz0g73D9ObhIsi6fPy52RS95mUDI5O2fW
	JD0GwIPzbFuaarwogsreXkAK41UqzZD+ULepfu+fCV2jJc3JNrgYZ8DCIo6GT52q0ZlMVgvquFy
	wY/hBqMT4yR51eJvgkrz20NhlBMZKyul3G0acE585pnNJHjCpMKTQqr1WFx23VjJKj9eVe/A9vR
	xaef+aSO+o3+cEeb+e3R6QOk0aHeG6R0K3XMDUA==
X-Received: by 2002:a05:6a00:3688:b0:845:c6c3:5e79 with SMTP id d2e1a72fcca58-8484367de8dmr1224953b3a.40.1783489016934;
        Tue, 07 Jul 2026 22:36:56 -0700 (PDT)
X-Received: by 2002:a05:6a00:3688:b0:845:c6c3:5e79 with SMTP id d2e1a72fcca58-8484367de8dmr1224915b3a.40.1783489016304;
        Tue, 07 Jul 2026 22:36:56 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6db29d1sm6484592b3a.53.2026.07.07.22.36.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 22:36:55 -0700 (PDT)
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Date: Wed, 08 Jul 2026 11:01:57 +0530
Subject: [PATCH v3 18/26] sched/core: Annotate runqueues into meminspect
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260708-meminspect-v3-v3-18-7aa5a0a74d5c@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783488714; l=1065;
 i=mukesh.ojha@oss.qualcomm.com; s=20250708; h=from:subject:message-id;
 bh=JYWiKEpaZYGfni18VOJ16Qd4auRJiaJNrpQIWqmhZDo=;
 b=cv0EO/V7wbPDz5pf7/xTcxOXaIbi9Un31Ad+m/LM7I14uYWvl+7At4fcK1lJJIifZZYnjzb5B
 4sQ6pyvmT9ECMDABWn7BstHPke0QDVSzou+abCFZ7VcASrjrp50XxfR
X-Developer-Key: i=mukesh.ojha@oss.qualcomm.com; a=ed25519;
 pk=eX8dr/7d4HJz/HEXZIpe3c+Ukopa/wZmxH+5YV3gdNc=
X-Proofpoint-GUID: J95ku3q_oXIxXHYkk-d8-MxDKyYywa80
X-Authority-Analysis: v=2.4 cv=CviPtH4D c=1 sm=1 tr=0 ts=6a4de1fa cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=VwQbUJbxAAAA:8 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=WIgWxXLGzmshCHNC7soA:9
 a=QEXdDO2ut3YA:10 a=OpyuDcXvxspvyRM73sMx:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-ORIG-GUID: J95ku3q_oXIxXHYkk-d8-MxDKyYywa80
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA4MDA1MCBTYWx0ZWRfXw7u2Ia8/Uzs9
 dAIw7TC0z3kF2wc1Dnv9tKZseVhnwGMqjxGiAPlUII8+TuCOmAKC3DqessHaue/hqtskCAA0dqe
 7A8HhBrR70N9Oq02NBp+5FrQ6ULG32o=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA4MDA1MCBTYWx0ZWRfX/yFCJBqbkZfe
 Gi/dw68qqcAzL1SyWMu0nY6RlBoJx7VJ3/Db3sc3OENoPewmCSwCqBlPh+3UgQgIysOZK0+QgVE
 mmlwQ2IXLovpTjBnqFMgylhgF330xPLf+/aBxd2k/X9PFn9DFbT5p9mQ3lo1ddimaXmsjtuRnfi
 Bkl4uaD644FWpdnut2RExtGbHXwtAnzpCC8pMVss3V7V5jNzksTmDojPh99+uYZ9MtIOm7CWvzr
 JguviClRuLGfLXco/Ja0zF+HSVXDAb9Hm7hg06OI16rNsylIPRZqnBoUocm8+7zAMW92oKV1IAQ
 +ebc7OhtA46PXhZYIsoBGmdYxN1ag3izcaw5Z4kwm13ZuFcdRqwss6hrXrAoMthRcfKq4ktN1jk
 E0NuY5v7q1RYLcVXmXBS982RbNHOXoHGQT3p5ibEiRF7z5N8/GXj5JoeqkNanVQc5j5tJLMO0Kh
 J0d4kXOZ1OorNiTYGvQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_06,2026-07-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 impostorscore=0 bulkscore=0 lowpriorityscore=0
 adultscore=0 priorityscore=1501 phishscore=0 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607080050
X-Stat-Signature: gujnqgrtk3daju9znnw974juua5eoqjr
X-Rspamd-Queue-Id: E715A180002
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783489018-831558
X-HE-Meta: U2FsdGVkX1/oExnamTGBCltjrSz/MM5ZWdImlxEdFxpM/KjdK2QIt3EbqjY8Qa09GTa2O//tFbtYzRu/0tB1UlT7N+Te0D0+Mbu9kueMnc9HU4CN2j35e8oL5REVI69nwRLODEl4cwEYZaufoc5nrEtvaNoGr9tBv1+CP8klnbXphHMdopKjL0Mwc/ZtfOARFpc9ldqLGw1LkKRK96jE17CnpDnwhTqojZiVUp9YF6jtGll1BORfS7gzjvRzSdx5rq6r5Hkxtj6jJ8UQw+w1zA1MqiY1kDkbVWE9UY2wlbOl0kSbrZWUa5lOwejC7Abzz+00dxMo95q5wviTVSpNrv1kIBXiu8fCXx5ZN1h2zVNBkeJi78eAM0wYcBvQZryKQYSwH1ScXjV5YdXFui1+HkvWRFngrlMwlZfxiTcWrJOWFEci96lAoZBT/9qUkU5VOwN+sqF1CntJod1IpDs/umqdIdcKYS+inZ0OPIRpnzRtWX/bsou6O03MJe+ICMVpXc0XN9wA5x//k8Pu/E76yqwSWC2MAthwYXpX8jFRsYR8vCac6I6q916UK3Nco7R00pAzPNsC+qhHkv0S3sw8RfEY5sd/jX6nUzvfro6h5z1iaR4IZzN6dSlcrYcFZwI3CRecOgwlLaLvUrjYn5dRcPxmTvHce4BUnaGfECU0z7Cu6VH27+noMe7ticGIFAlFq57zrvY20cq+bCcGemLEbV5FzOTcnnwzY5sMor5jxycPvHBexBo0p+gzGpnrTClvlC8LGrQt72BV26dvqucaFQl5a5WSL3gPyD8RuDdWOyypU8erlBfkurb3jHcRDg/eetC5X1HKXuTpNRnVqvhgLvKRbX0m2zHSQK8CN9+/nYAGyrpc+vOQrdx7L35nKvuHYAaeunlNqQlkttSpoeTn/+Ye0aKQiWyKR16H822pJOAgR0fhPx1qQmBRgIgQKuD9Wny0tgnkH+gd3u6lqmz
 slXcF4/t
 SKn1SgMYnXsXZJ2kdshB+rNsRjKYmD8z1spd3QqDWoMqLsP8Uw4xTPP0v83UwH2jwldPslIEAw3zAHrw2T7InlkWx1pKT9fJmWtzxXUcZ2kHjcIDDXo7FjH4F6zPWDFXFeBZ0lUpR66wsn1SZvrmG3g3wqw9lt7Q72XRJOGYaixk8po7QbaKCO/wW+iR4zlW9tAb+galgOoak3zl6OfmRWpviPGvk5s/LthSoaBmV0CwzUVlPJU7FUgNXFTjI81prDkH4PssUO/4mJhFsYK2a5baQZH2zexmKTximiAAJQyesdt8Ppe3tInxxR8PJUant6qgTz5QkLCyerCssi2X61FpcUjxnHpwAXimGldVH1V4rOtN026Sgtb1g9WTwx08zhlsziJjn4n6W6GqY0jH6rsrhIZdoQG7+9/n1tO+ZoW/nDRk9nZBHWht3VmErqXOXTNHMorOcpDyPDtxKfI/Jx1i+quGf259cpYa7wPj+ew2N6dYZFNz7kWFZQ/chRptqHrKMmmGXbMLy8pykYY4E53qMaASaW+nX2ZMfVnDRhyRI21HbyPpoKxGbS5uEgRrriU8u0Pz2uedCZF6kfu8HdBJSFHSmbPKneJy7XChSmRoi1sZJG9JU0dsC1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Eugen Hristev <ehristev@kernel.org>

Annotate runqueues into meminspect. Even if these are static, they are
defined percpu, and a later init call will instantiate them for each
cpu. Hence, we cannot annotate them in the usual way, but rather have to
call meminspect API at init time.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
---
 kernel/sched/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 2e7cde033a31..1c2e80a54d2b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -69,6 +69,7 @@
 #include <linux/wait_api.h>
 #include <linux/workqueue_api.h>
 #include <linux/livepatch_sched.h>
+#include <linux/meminspect.h>
 
 #ifdef CONFIG_PREEMPT_DYNAMIC
 # ifdef CONFIG_GENERIC_IRQ_ENTRY
@@ -9059,6 +9060,7 @@ void __init sched_init(void)
 #endif
 
 		zalloc_cpumask_var_node(&rq->scratch_mask, GFP_KERNEL, cpu_to_node(i));
+		meminspect_lock_register_va(rq, sizeof(*rq));
 	}
 
 	set_load_weight(&init_task, false);

-- 
2.53.0


