Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D385FD4F33
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 20:18:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 061786B00A5; Tue, 10 Mar 2026 16:18:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02B046B00A7; Tue, 10 Mar 2026 16:18:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E25176B00A8; Tue, 10 Mar 2026 16:18:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C90876B00A5
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 16:18:48 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9C16B160345
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:18:48 +0000 (UTC)
X-FDA: 84531266736.06.7C3F97B
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf03.hostedemail.com (Postfix) with ESMTP id 09F0420002
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:18:45 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=ik9HsVe2;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=RkWdGjNt;
	spf=pass (imf03.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773173926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GRfV+v8T0vtqGrE/H48Sbm8BwZSwOTwP5bNFawAy1Fk=;
	b=LUcRWQE5JNr9hsMAVXi3aTQ/COoWsWYBCuugNrCF4xlp4502wKT/4tZQD5JQDPr3fTbvYg
	h0wiwqsz8RxvOLpNQuQC7yIzugY637On6ZjZ5S+5iUMkmvZqhppVMkNkT9YOVN8GKkZcxU
	G47ivRaQy2Gw2i38TXFG0h3ndgTwUng=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=ik9HsVe2;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=RkWdGjNt;
	spf=pass (imf03.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773173926; a=rsa-sha256;
	cv=none;
	b=zBXbQ21MEn4CiBj8u/MvPHJIt+4WHI5kHAmmL8n7LCbpJGRLZNB8j0yWt5aeIY5cprGRzZ
	BRpYTRmCwdKwGm4MUdlC4KzQbNXyD2eNhZTGVSKh03qBUcx0rwswXD3Gi+X/7vMfTND7s7
	kOVAfDm9PHz7fRp6q6NAg6xxMRGWUiU=
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62AGAjDO1265992
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:18:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	GRfV+v8T0vtqGrE/H48Sbm8BwZSwOTwP5bNFawAy1Fk=; b=ik9HsVe27x7k7E+e
	7lwbkzTzKs+Xaa30Gwlu8DLnPa/d9oQ0nR6g8WEDDpquIfohhaf/ldNmONkYrHSX
	5+aozV2K6RXs05Ks5/qSSt8OAA7DFEB3znqkdC1gCDMTAN3Hz9nvYgKTD3vtKpYC
	1UZKCggpJTEftG2QeJGWx9Pdfz72tXsFE0kTxa5COwTCVBIoN3KguwyA4zxmhHWL
	p/w8XWCMBJhl44cJq9qnOKhcsk8lSeDdyOGEv0v/xA1rAPZyLpsaXrNFnHrYFcTx
	TYYN1mU1HNA35xh9h1gWfC0mcaWaRFK52is/s4kKpby5MgjBrr3SPbnthq6zQtzF
	ojqwBQ==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ctpkfh048-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:18:44 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-82983c9d78aso18115960b3a.2
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 13:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773173924; x=1773778724; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GRfV+v8T0vtqGrE/H48Sbm8BwZSwOTwP5bNFawAy1Fk=;
        b=RkWdGjNtSesW92i1v88l92gH2DV6oaIg6AvkTgFnz0FLHr/5gvKOoB60Mg6cZF4N8t
         WLDNicRTVo/1gaLrElkz5I/SXpyImdhs3Lm1lGqJv61w519sUukea66MNm/Qlad4zWcs
         EqBV//oiLjlxWmn8Y2jYa0McL8YImAJ2L3CRBnjaSSnXv55bNvCdNzzq+0SKnJJMLf/O
         7GJPQTALxk1iXJfZgiMpC8Q6OYW5EJz0HuQufafecrS59EZgtF9M5BdKIZ+0S6cgYPxS
         NzWjwVHT5C0N8+UxdoUJ6CicwnuJv0ddhI1sUJEWiQaLeDde1nIp97YPTTusTsRY5Xhk
         OJkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773173924; x=1773778724;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=GRfV+v8T0vtqGrE/H48Sbm8BwZSwOTwP5bNFawAy1Fk=;
        b=OzPiJgRp6sIPygtpOQp2LmgCv0JoPOJoMmMXNFdS6prsG8MoypoFMrBm7/TtNRzlb/
         8FEtu/rHe0Kux567BCu5DVScIZLrtnUJxw2abb9P37XdfctayJANHbyqiFzDM0p3hRoq
         aNIfoj7PvVWAp3p8oAUC9a8okIpatU7v5JG6NBkSaOi1NJW7wvSfhyTAOLGiXn/eE4He
         XSHQTQLm3Wq6UarrtOvstc+v0hb4soi07LFH3rGgcU6C2AtfutILotqXmzca6IqMnxXD
         Nqa37eztw6yBJ/0hQouFaaKIK5gzFNJVSGv31VEI4/rLAejGM5cQjhsu0Dj7YV2HldUW
         NLQQ==
X-Forwarded-Encrypted: i=1; AJvYcCXTIHBtQdf+EMCiWH/hZ2UagQTj9C5gpcI6rK9TBrNshDwjuOUT7pY60NE3d59y38Ka9CFAfY3fkQ==@kvack.org
X-Gm-Message-State: AOJu0YyjT+rke8q8KafICtnSi/fjg1by70dxMi0tnRVT7XfJz3JGRk4U
	NBHPPRNfJFAeUSoJ0Htf9x/C4qIRjbnqPRFn1RqE5nzqM4I4IqNJ4XnyvY0enqHzXIbdoGoISkQ
	X8COXR8+neo+g1nwdkLgA1Qn3xTelETml5Eb9guwe+9R0wjceqyFwsQ==
X-Gm-Gg: ATEYQzzkCEYDVlCwiHypNZE0H0OSi0ru/05v9jYc/puknLbtWfXm2RSYk/r6CEJNon3
	TpjF2VwqmN5xmbyOgVrgkFAgNo+7EISTQSqYUdAQNezDhzn/ekBQv+2PzpFMx93XMsUejotGMf7
	K+DWZtEVjwNbOK945K4tykJxV1Vle0QaRZKKj0Ak5VBN1aqi5wpRTOmFRJolJKn3sN9YTayXxFq
	t6UxZrB3AiZ2HjWQ/0gVJm+Ktex21Z55XyKcX2tQghjtoO4oHD/RgrY3hu3anDeXo31tanom7wK
	UxGU7bOvaeI6tClplRLi7VM5PmO/PGSibcv/kEUqaoh767e01SbsbvjhSEq4yz0S38csOVTdYjU
	ZCZtoxSy6kTVFI6tVtuwQrcwFqFREZg5Qd0tlbawX+6Yv0N7L
X-Received: by 2002:a05:6a00:7082:b0:827:2cee:ed88 with SMTP id d2e1a72fcca58-829f71c2ddemr118127b3a.66.1773173923945;
        Tue, 10 Mar 2026 13:18:43 -0700 (PDT)
X-Received: by 2002:a05:6a00:7082:b0:827:2cee:ed88 with SMTP id d2e1a72fcca58-829f71c2ddemr118106b3a.66.1773173923413;
        Tue, 10 Mar 2026 13:18:43 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-829f6dc2d0asm115262b3a.13.2026.03.10.13.18.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 13:18:43 -0700 (PDT)
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Date: Wed, 11 Mar 2026 01:45:54 +0530
Subject: [PATCH v2 10/25] mm/swapfile: Annotate static information into
 meminspect
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260311-minidump-v2-v2-10-f91cedc6f99e@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773173756; l=977;
 i=mukesh.ojha@oss.qualcomm.com; s=20250708; h=from:subject:message-id;
 bh=Tfb2N6LauUTGiRFAYk0nYJYKBMAQNAqF6HcYVIzPbHw=;
 b=So4F5y2//OWXVBpu6mb1G2pjPDprKl6dD0OwLjg3M54+O5uetJywuxdJPx+lFXIZJyyrlQ8RK
 O05sCcy76vCAVjm8ctNTaSyWivzLnJvWFr91LSWTGqkpzQ2TiYaDGt2
X-Developer-Key: i=mukesh.ojha@oss.qualcomm.com; a=ed25519;
 pk=eX8dr/7d4HJz/HEXZIpe3c+Ukopa/wZmxH+5YV3gdNc=
X-Proofpoint-GUID: jFKEY-djEnxOQYk0YRT9hHSopqxoaH3p
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDE3NyBTYWx0ZWRfX+jOwnaemzLGu
 j5ZMMoSgpMHdMU/K4kNcgCk7uoi8gyTZxpuYS4jxMVq5cMEYBbqkVfdpDlLKcJU50G3TC7uAKZT
 IDdCK8gdzTH+t+2jhp5SEzb2GW7kBeGm7WI2FtF8lFDuUJUCak2TQuu5c5i5CWeRHGaQ3az2OlN
 COH3Asj5scSL+0ui1H10gYGAV8oKZ6rh61idiIUOF7idZbyQN6Sv7ldm8CMtIqDkihuJVCeiBDz
 4S1hh7l8NnG3LYuXCdmUypaaVBgQoajDglWardVGWNUyWRhc2Z0Npjg++hvral8bHlqg6L9tZWM
 6eqaMOTdZI2jpgXAnLWf/jMn867ZjRjU2U0YCJLOoh4+8WdRbe5EZ5sTTE6yteLUirfSfQa5LX+
 NxVADBswWuhGTOG15e8qYpYJHBofr7R0Eq85TnNp8K0tyYTgOyB8xFHSMXEEpvgdAtK9oApKJ8O
 fhp8A+kMRu16c8RWS1Q==
X-Proofpoint-ORIG-GUID: jFKEY-djEnxOQYk0YRT9hHSopqxoaH3p
X-Authority-Analysis: v=2.4 cv=Gq5PO01C c=1 sm=1 tr=0 ts=69b07ca4 cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=7W-H8-9HiqHpPtFVMfQA:9 a=QEXdDO2ut3YA:10
 a=OpyuDcXvxspvyRM73sMx:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_04,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 bulkscore=0 lowpriorityscore=0 spamscore=0
 adultscore=0 clxscore=1015 priorityscore=1501 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603100177
X-Rspamd-Queue-Id: 09F0420002
X-Stat-Signature: tdnjh9emj3o141i1aowdi37opt8ammzu
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773173925-169666
X-HE-Meta: U2FsdGVkX18fNYUoIjaCU/DQfn+rSmNJcG6vE85RiJSGj9sr6vQ247kgGVnLI09tbOzSJ9zQRVgkmWlobQLqdWq5wuVRKIdp5YB7uA1KlEGcFGdFOrZLOYsL1ggXX5jZyI3EPXv1cVWMrtKGZ8YZhglm50FE5DZ9OEJlLPyKMtSTMF0LnMJlW/34VJOnXVvTEAZHbR/LBH/8OHG23L6MLroTOc3sUGmWJ0V/L6tShKXP/QL+eYBqv8pGtesy3ljvHB0q5BkmcaPmEYPB5JQHzZuOjKKV668vtYioPzKDfvAwmhPsz6TH9i7pkGwfK0+946LfqHks+q/Anpstc2VaFQ0Ajg5vylJCtvqU34YtPBBl+QyqonOHnIMNHiVihfCGRlBV1EKyuQDDn/uX+TC7tMBfIqE/O0gGdUcM1ybAqcTKX6lfY/C1/I0kfGaUTwSM8va1mASgij2CfgWnkNoNLEyOa/FNOzE55eTGOlQqzI86IudL6QmNw40qbRdlz1bMuNFdC6dj7jeQN0CFhfSnYP7Du5/O1snXILYKwLpOgRkwqKUhabRyv5jgF6EmKN3janhs5C2MMmDq9Gbpo3zbD2kqo+jPtU0WM+5IcXPSg5gdlmMXWo5xuiNF1bN56XQq7Uja4IyZ8Vcv2yK6vlUlP2YgamHF/pAv+h+Ys51FEaPO5Udq9+D67NMa4bcktbiMlXbBfAdNSPR70iKSSmvcuEsbUAVFyNNV87DNDHKjEfiiQ0H50Uw7hacdwha+98LoGBRVXneTZZg5VZ5Z+X87dIVE32GIPtbdMQpQb1vjMSF5u1B8iZsy8LtwHeznnVUGRSmmMnmkBY2HyKHAU0uX7eQzYgeTyiGlwQiBRXEHqOItclIJc6X0l9CYjK9+eCM5073vMiKAXkfv88hp4Oje6aG/Kk1uVl+P2Xq+O98unyja/p5+BF+AUrUTlvmQjfh9R2kPGVVyHmRbIsCBYDY
 YQe/235m
 XoueAteA1rcHTIa8ghvboFRiQ86DYvTPQ4Fbzlrq0T7fT1bq5C34TGoRb7nCPFbvuxe5/T6hYP0ZtSpK9nA97zAIijojnzIEOo5vPvvEAVpx/afuHD91vsz0awi04/l+fLbIdE25djNuGS6umrta0nZNxz9s0giq4H7h6JqWdBebn1MQNdjx6FtLYYUdui1ap0uatwFGbLTdNjFEV7ir242FqHYn68ClNXV1Z5auTP/PC1QTBn6DH2hG8yw3gfPGFGLo0Nqj57SiIcxYsyW+7tMTZzwQDpBAPMqchBn/FNDpqsAe+jSe701C66QXTXkEgoxNGHKvW1SkRVR+zfpr3d06Bccd6vv20axiPIKiS2VDwRFr5nOshZFXgHpPVuFEgIGLr1L/8pMrLU0+OT575CG1sYnZcq1mxS/+cnfbxHLcJ3W3sbTEEGXuJGX3wsJy3/gxbeOiBLlB4p+UhzSfo/Bd/bQVgFca9sQm9MNtvCL2n9SZObQwNHMdOCcxm7Q1fRIWfxnI0c2vYJSUbVB8a39A6p/9FOG0EwvYI+MVeDV6BbPDAUqs7qWamj4w/eBvLlCEP8k5p6OQ/4w6eMlM0y1v2mgPTPoDRZ5HZTVVqA1M7BQs09lTFaKSct/zLlfm6hjJijIJDONnUP+OHphr8m9yHGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Eugen Hristev <eugen.hristev@linaro.org>

Annotate vital static information into inspection table:
 - nr_swapfiles

Information on these variables is stored in a dedicated meminspect
section.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
---
 mm/swapfile.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index f39c3d712273..03aee425bdbd 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -42,6 +42,7 @@
 #include <linux/suspend.h>
 #include <linux/zswap.h>
 #include <linux/plist.h>
+#include <linux/meminspect.h>
 
 #include <asm/tlbflush.h>
 #include <linux/leafops.h>
@@ -67,6 +68,7 @@ static void move_cluster(struct swap_info_struct *si,
  */
 static DEFINE_SPINLOCK(swap_lock);
 static unsigned int nr_swapfiles;
+MEMINSPECT_SIMPLE_ENTRY(nr_swapfiles);
 atomic_long_t nr_swap_pages;
 /*
  * Some modules use swappable objects and may try to swap them out under

-- 
2.50.1


