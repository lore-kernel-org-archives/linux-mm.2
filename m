Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 948AEC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 05:33:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8159B6B0096; Wed,  8 Jul 2026 01:33:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7ED136B0098; Wed,  8 Jul 2026 01:33:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B5D46B0099; Wed,  8 Jul 2026 01:33:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4398F6B0096
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:33:35 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D2BE1A067F
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:33:34 +0000 (UTC)
X-FDA: 84964491948.12.65ACB01
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf20.hostedemail.com (Postfix) with ESMTP id 63BDC1C0002
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:33:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=aIJ+OVUn;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=ilcLquu5;
	spf=pass (imf20.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783488812;
	b=dGYAbx2o8FDG73v5/jFmdEvD0pWkGDvsV2oApVT5GNcvPGA5RU+5jA4uxADAVKGvQ11feT
	QvT/kv/RyvvSqI1t7/NqvkAN5dJtyh900RwkuiYkunXxNd+pTV/9PqfQ8ayj5foDh+K8q6
	amlYzL0JqrdkRC4rtG9tWLd+ECrdD+I=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=aIJ+OVUn;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=ilcLquu5;
	spf=pass (imf20.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783488812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tw0fKvrBBEA5FX4luROpIV1tavP8899q2m1fKdILPtY=;
	b=q0SDzniK9jUj77zO2/2SjXTPySWYgSPri/jQWQw2jzWpA8mzJLpToL0GC+vSLBrUhp/am3
	8oJqcQa1U0u3sdSzlh+3AkZgDLipU2IThQQ7IWKw8Pdh7lxyydgV0ZTR/3aOYNdt5AwnLx
	CxY0TVjzwIrNnS+t030QVMzBbbZBLAY=
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66842B8X1572668
	for <linux-mm@kvack.org>; Wed, 8 Jul 2026 05:33:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	tw0fKvrBBEA5FX4luROpIV1tavP8899q2m1fKdILPtY=; b=aIJ+OVUnjOReaFIJ
	gofT2IG7kN05yyO6OHhRtExveYz2PuaQ799uaLO3FtSZhmKD1Nyb+xCKZ91fRTJ1
	IbTs/p29TaH6QeAppdwHG7Aqa+hO3ouwWFp5ZhITk+HN0qiwvqug5C6D1B2HiCM0
	vlj/LtfuoT6CkzD4QwEzimGz4gLd3Z4qvHosvA8yh1R7OjUDtUu/pXC7iIgQWDXR
	LvunRPbvLIG5hyUJCIk+lCPWFfk6bZn8eSbzShWBfsTclu95eNt0VEAaWmZAgdL1
	HjObNtYklBRkRBI6WYeqm+QoZ6naZtcfmWLcKJfhJk76NFZhH7jNaqkVnArreON3
	ohhKrA==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f99hgshb8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 08 Jul 2026 05:33:31 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-c88d7a75507so460495a12.1
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 22:33:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783488810; x=1784093610; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tw0fKvrBBEA5FX4luROpIV1tavP8899q2m1fKdILPtY=;
        b=ilcLquu58xGymqZFiPpL2mWCW99UjsY3/vRUkACgWat3PX2sj5wGJYLviZJprsmUks
         lZ3ySyXVcCc+9OhRctvGbq63ztq7YLjSi24JCZiYatHB3MwljKe9/WiXzNnlf1ZGKzuU
         8TdLB6WxDbzxlWLHunEeMIXkfnCSMNE2IKz7qQa0MuhFdJgIK4h2iwYmztsjJzA0LWdh
         IRJ1wFD9ISKHd3lCi/ak12tT9DB38TwL8Ec2a6uDCwttWLENzT8wIb5b53qEfZxaCTNn
         QlCDDuuZk0gX0BK6uUAj7piOmYLMYYgyMvUvf3Uyjbw6e799osBTsiV5eQ7ZK5l6UQVS
         OkFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783488810; x=1784093610;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=tw0fKvrBBEA5FX4luROpIV1tavP8899q2m1fKdILPtY=;
        b=gCDD+z9WC/PsT4Pw++0TzXlzE3LG0UIXclH3/roTqEqj+PfkaphUT+lGGptUCC+BEI
         BJZwbdyyYoblmL/k4ewvCq6DZOpXzL4l1RLlVjnhRwX/dvGxjogGvspCzvgnjrhrYClx
         No04hnCri/18rtzOLHjFp+t9aqMVpgnbkPdEVRj22ShcX1of5ciBfjDuBs/qsCOa2pnp
         zBI+nnlUEyuVN9reuMg+CGLR0Ybhezj7tulWenyJd34LweXO1MJInzsQWKUsAIebb6Ft
         GbGUnacrHRXDUNr8OO9V4kJvrSoOBZTzfj+inYc9A3XY63iZ7Vd4pM53TcqX1uMMESTP
         xJYw==
X-Forwarded-Encrypted: i=1; AHgh+RqUU+xK2iArOxApxb/QamAXDCglbzY15Il03/tk7ZxF2aHgy9xXl7lEgLOEQXVxIRDp21wv697eJg==@kvack.org
X-Gm-Message-State: AOJu0YxB2J186mDCGvNwruvrj/0+VJO+yVmlewlrQWPWDwN+mPJ+ExdG
	1Oxl6MA7tD/bcmCCG8S7Yms53A0AiqSqNfMULhpS7CgV2sd1pMtppLE5dXImSmXvLxO/hk6marv
	PhP7AyUby1Nq74qe3P4+rA6Sg2KlaTZyfxfbX/Oknsb/a2ysHkU3maQ==
X-Gm-Gg: AfdE7cnno7lBcBVj3vv/TzGquhsA+7v9cxcNV1o8S9tqMUupW4osw7fm5fLmdZ61sY/
	5LAz1hjR6rWuEkp9kBy4qnDOnV5cEn3YKdee/VytjHP4PDV+Cy3UzHQmIU0fRndFxFhxiGfKJoR
	6feDqb50qxqdNoZPbnwYhCC/MU2JdU4XvuHfh40RtgGJqv8B/PtJeYs/slSpU16zSsIbMG9fdKd
	Ak3UNHHPjXmQM278c08FjVbJl3ihs3O6pzxNYCt2BuDwx9ls3f5SqNoSFFOash6OKtO4jGvc0WS
	ePFuK0NkeuSe2RmskS/gnPV8L6ocXaCwSGGFXfW+Pt+4rvS+DEP63esE7XWrutVqd1jTQW1TAg6
	kkkmd5MH5BtdGcC8pgqNhTx7TTqXvqTJUFlcMyQ==
X-Received: by 2002:a05:6a00:1992:b0:847:871a:94ca with SMTP id d2e1a72fcca58-84842fd4953mr1063888b3a.41.1783488810308;
        Tue, 07 Jul 2026 22:33:30 -0700 (PDT)
X-Received: by 2002:a05:6a00:1992:b0:847:871a:94ca with SMTP id d2e1a72fcca58-84842fd4953mr1063828b3a.41.1783488809721;
        Tue, 07 Jul 2026 22:33:29 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6db29d1sm6484592b3a.53.2026.07.07.22.33.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 22:33:29 -0700 (PDT)
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Date: Wed, 08 Jul 2026 11:01:44 +0530
Subject: [PATCH v3 05/26] genirq/irqdesc: Annotate static information into
 meminspect
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260708-meminspect-v3-v3-5-7aa5a0a74d5c@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783488714; l=986;
 i=mukesh.ojha@oss.qualcomm.com; s=20250708; h=from:subject:message-id;
 bh=V0hkQm6fvvdwmLWbmnwABstbPfO8t7+liV20uf7x678=;
 b=B6bivnR7Bg4sl7bXAEOPvh5EHC7DFSJQHDd2jJMSLy/o2W0KYPGcZeOKz7zeQrcRQv7F9NTaX
 XpS7VFBMTebDkPpnbFKurlA2nLFIU7MLF0pBWpFuobcTjDgJMXosqKZ
X-Developer-Key: i=mukesh.ojha@oss.qualcomm.com; a=ed25519;
 pk=eX8dr/7d4HJz/HEXZIpe3c+Ukopa/wZmxH+5YV3gdNc=
X-Proofpoint-GUID: uE-c68W84cVLXM5m8m-umdF1nW3HVp8w
X-Authority-Analysis: v=2.4 cv=CviPtH4D c=1 sm=1 tr=0 ts=6a4de12b cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=VwQbUJbxAAAA:8 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=W0BCv_TwhUmk0ohr3HAA:9
 a=QEXdDO2ut3YA:10 a=bFCP_H2QrGi7Okbo017w:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-ORIG-GUID: uE-c68W84cVLXM5m8m-umdF1nW3HVp8w
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA4MDA1MCBTYWx0ZWRfX03tzujki/4m3
 pTR03uxCxSl4iBDoE8yu+vvrQtUFHrvGoWExbQwJ0il5KZYHQjVVjuUevbUE5qXVmpHl3Mj4Vl5
 NdeE3e+6nRAtksOTNLaRmY00SRQZlE0=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA4MDA1MCBTYWx0ZWRfXzekaWuo8IvAx
 /+WgDwLP/12ZM/iWx6eyVgFCHoyMn2Z3dvJ1NVlQ7mAF+EMBriryURC/JUat8k6UpPPDRVuQJPE
 msM1lvkgO0bjkIIu9iOWCJz/SUrLNU0gQU6RDq4pqwiusVLHspiFCeYectVI6DZWWsHYq3hTx1W
 yyTDDR5OAFVAFMLwKvYjP9Ro0YJ6pN6xOpAEzhCPaD9ZBwnLoRM66QGpo9VLGw+NvKTPgTBNFAn
 Ea3Iy46b+Br2+SeG4IV2D/77qzVkRFiOMXE8HXluQsfEiX2vHCME/YWdsTsoIdkKOjFoMXxdIB6
 w/WVFDhhMNm/hS/zyyiG3TfXPljThj3tDHpvY6dDSoTYUovcjRZIaPzqOjzBakh48F9JLdbqP/8
 wr1SR6XQaNO6um5BfDBJ0xb2wtzyFMFDcaZv9LU+EEsRKUV1SiNilC2DtrGK73KxRAGgyJhXUqz
 DxEAnYFXCjlHP16QOpA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_06,2026-07-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 impostorscore=0 bulkscore=0 lowpriorityscore=0
 adultscore=0 priorityscore=1501 phishscore=0 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607080050
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 63BDC1C0002
X-Stat-Signature: ntse7ui6hd4utyszz98rk9c3cf7qia59
X-HE-Tag: 1783488812-60575
X-HE-Meta: U2FsdGVkX1/RDA0aif6tYx3avfE3KyQystdSpXqrXFblOZqE5mR7h68fItwdaLsb+ktLeZuJ90Q5+xK1mRp3s67MGrt1VoVPvBj4b7gOBa6oXc3P30R2s6Y+UGvJtPaHKySaUSUYIveywQDi7efwf3szI+Pw8ixYUgXEKoJiRfHE8TjAA6DZPOepnSTpHXMWMkkvv2HqooeGn2+G3GwMrax+lZGbu7h6doC0n2imbqDFPXraGhjVaH+bz0ACthoO2eu2tLrqLpT6tdB36Gt2sZfZhfvk9rp6781lJXm0CVTC+Ih833sO7YwAG2sX0/xf6DG9w0Dctk3oHzUhVgI3PFRByp2KNSCzC0ePLAZrKRn3i3g8/LEq+ZUFQVD5Eb+Rh4tx6Q/XpGGNlD4CD60zcwyS5hK4wS0+8auM93u6Wun96JdmSB9JxKhHrpB0LnR+vDSQDz2++NCLXzqnePJ2PWZhFG0j/il1+6Tb/epIrImFQ/z2RGRpSvbWvsMx11kZJAHNUBxRhFYeHLxr/qi2RuqdS+SbdH4dUaZAfw5ytwONvtjT2T/Y6HTiNjKdo6a0Wor9XeKqm9yZa7HYY3WiacAcFsUYNadZ+GOoyfySM8bZyn11lCRC3xFAZ89YhyC/p/bEHwNzs6qY4v9Emzm8bnbwFZ0fja0KjktNPCINV9clJSboECPMh0xqTtXvEcywNBcTnbndpvMT6mdPt6FmwF1+sYuFL61cPkCeH24U963pH0HOZI3KHZVu7/ShgjaXuRhBLd5afaMx2ICJS58+NvZgo3akExZrZSFYHf6Rcv+7wRdwHErqgP5D9Xbckkh+c2Urs44luzwka3QNpyMm5Z8ryQrnuJFrH5A4/YWiHR+INNH+Zm+JIPjc5pBDiZbEZ6TbORAJ4qM2yEYO1ESR6qIvkKvVvDPDkSof4Qi0BLC99nAy/Q4rqRmXLpxk3XqwccKYvTHS5H+l/pKQ2kq
 BWxmnS1s
 KVdWuxUc6p/xeb4xi3u7g7DvBCoa2l5iRtNGuRpsUOYCoGkVK42Nh1muk5IVfwSpSuMqIcujrxRM8zk4NIcAK6+Hfd3SCobnWh6Ay8F9o+gUHi2Fbm4r36v1ATd1MP3hZXUZ08E57jfc0Wv7sm7xU7sq2bFBDL+61rr/iD9EgYep+JEu4WV9n83a3DuMTUa2M+pRP4IxsYlBZa8w4QZgpZ4HeOIdRj/vUuBXgb7bWG8+9899tds7TG1bNDpr7m8CjCJcU8PVsCJd2xLhKgFlQseuq8vvhX2mDV3zLOrVV9fjZyiCqS7y+roB1HzNRSeaC5Sk5QlPMBavGZOPJ+qWbNdsPzx9ii9ohqTxMjV4tqJOA5W0IumQsO1oZ5lOjfQRAJH5RFCTjAJUsxuaHFDdpnaFR6jokFoG0wPQGZk5Z4s8D3x8HCTeG7ug1sU+vDi9BNv5sL1VEUAd1TntZyd+pTvwdnApZMncJ/yNv1IxlePGnYDMY9tqwvrDGtVy++rPIBNqc6WEhxfYvVmvSUNmx+SRuSUJ+n95bdOWe3YG3Ma4U/ceZFFGVbB8S0LmaV89m666+QslFEqLtOBV+d0PsKbD3NgaBtbGVOAKdbqFXZyDBs6vbGWUStP5vxg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Eugen Hristev <ehristev@kernel.org>

Annotate vital static information into inspection table:
 - total_nr_irqs

Information on these annotated variables is stored in a dedicated
meminspect section.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
---
 kernel/irq/irqdesc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 80ef4e27dcf4..4e58e7f5fc6c 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -16,6 +16,7 @@
 #include <linux/irqdomain.h>
 #include <linux/sysfs.h>
 #include <linux/string_choices.h>
+#include <linux/meminspect.h>
 
 #include "internals.h"
 
@@ -142,6 +143,7 @@ static void desc_set_defaults(unsigned int irq, struct irq_desc *desc, int node,
 }
 
 unsigned int total_nr_irqs __read_mostly = NR_IRQS;
+MEMINSPECT_SIMPLE_ENTRY(total_nr_irqs);
 
 /**
  * irq_get_nr_irqs() - Number of interrupts supported by the system.

-- 
2.53.0


