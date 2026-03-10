Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 433B0FD4F33
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 20:19:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EEDB6B00A9; Tue, 10 Mar 2026 16:19:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CC846B00AB; Tue, 10 Mar 2026 16:19:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88D516B00AC; Tue, 10 Mar 2026 16:19:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 75C786B00A9
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 16:19:19 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1DD5CC17ED
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:19:19 +0000 (UTC)
X-FDA: 84531268038.06.1660CB7
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf30.hostedemail.com (Postfix) with ESMTP id 98FB380013
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:19:16 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=THJUFaLa;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=i8RvY8N5;
	spf=pass (imf30.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773173956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kYJhzYl6FEej6COPJvSo+RvctMPhBtSRzrUgpZSWkkU=;
	b=vTOfzFLwafVGC28B5bAc6rdu0hHNw42ZBLbQSFHX85v58mniTwiVMH5Psj4ko1XBZxnlPu
	uG/xm+VP/FZgoXw/+6FdCHb3w1R58sZf216/T1lc8VPMwjvgG7LjhfPE94gNEeEobUumIT
	BrZ/LhJWiaIW21zqvfH9i1vAByRhnKs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773173956; a=rsa-sha256;
	cv=none;
	b=MJPA8qb7vgC6aJII+zP+vN7Qzty5V79kLC0gINnSMWNaqzZ3hR6XNmqDJQvEf9srJ9zk/A
	xgabnTA3dc9tkal080S8afam9Ts92AtCYAsBr0Zv0YASIspc7POrpxuxd2xctVfBz7nfHk
	eIkRo1UAxkmT1W+hrJwpH3bnR5tCgsI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=THJUFaLa;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=i8RvY8N5;
	spf=pass (imf30.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62AHcrx92179348
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:19:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	kYJhzYl6FEej6COPJvSo+RvctMPhBtSRzrUgpZSWkkU=; b=THJUFaLan7yW85No
	KtNajqmt9jkj0m0v4tsUnn0TXOioxqA9pC6GgXVe+uq4xTQ4fE4pc2+M0lcIiw+r
	OsQ+OteLPXnmDj/HehvSLHxPeAAWfBvAwIG5wFrOiN3Bo1OOopzCgo1sZjHIwD5R
	1/BawwZmYr4JUc2KQ+8HXxwMl5tpsq96+enPtYBh1fvGDMvElVpbCTGli/jZAuls
	fCuIndntMxDHEkGZKbePaMGMU2RKnhE9yUzpS8eIRY5gfqCPxVWTBG09/LtUEzOO
	eTpkkh5x3LhuJp9IiLLMVEYja9+ug/zM1MLnE9F/2G1+QRoGpO1Nd+qelmxHme9y
	ZlWwVQ==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ctqvsrjwe-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:19:15 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-c738f71723aso3332345a12.2
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 13:19:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773173955; x=1773778755; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kYJhzYl6FEej6COPJvSo+RvctMPhBtSRzrUgpZSWkkU=;
        b=i8RvY8N57jV4mjbZLJXCzoXwpzlzjaiFeE7hIkivZkNmJ01dBm5ye/DG5BEFG6rdgW
         MzlNSLWewUAYC6mDSiCTPOPB45NY4Pm0nMszFMSa4slGw5mBlXLnDkZlR6u4oHaWjoPE
         tXadVnkS+CuryI8kc9izMqwTrqJXcpRGRQ113z8h0IVC7CIjgqHPbUrK1vdspP7GWMdG
         zMTcAFiQs7BnZ+WLshwO2RF7xP8VeKAEZGnbkCdDzMiJ2yMedMHBe7JuZbln1xYkL4J+
         KrtG0Lj1c4RJIWwNl5YT+s0VWUamLNg6AcLO0hjZYJ/TCFNfLWMmlIB+h4Mw48TXBQE3
         Z2MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773173955; x=1773778755;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=kYJhzYl6FEej6COPJvSo+RvctMPhBtSRzrUgpZSWkkU=;
        b=aFhL/NlXRoy9t9o7deJ271A8ECeCY01WMbJJxCt7a90PqQiDjCG1DThq+wM2DL2esz
         6Rk93bR3fVH2Z3iZWonLCzhH93IndqDEupbc2DlqSlK2exrRVcdDsP/10olIsZ4c5l7A
         o7WHa0jaxGRVYuhjwKo0dc46FNg727KWg5ku1VlVF5Pgq7ZpnTpjc7Yom90v2XHzkIT5
         ozrJEOleY7a9rH2/wRWqMgZruD3KK0brA4GngxSEG03DxvhA9K2gHpKZbr0SCv6GurOs
         MZJ+a+NgyQa5RObxR/WKHn0hoMOpQtBu60FlDAP273fvKM24xB5/qTDvnSY5vINcbS2z
         AOqA==
X-Forwarded-Encrypted: i=1; AJvYcCVHApA2iW+U0yFE0gc2ocq/YRZyLay9MfJhT2Ccyx8b0kEgMYaPV0BFY/daYBMmjNyaHfbzCjogbg==@kvack.org
X-Gm-Message-State: AOJu0YyMhpVGilJ9Krz7Giy1hIUE9ZjZF9sFM13AmKM1G2g4qD0hqWir
	GMFiUf8gjNmFiZ8sjReg6ftnRYAGEDf6OtKLAeVv6l+jou8wUh9T8qKmntWWRdEH4/4SbtmynLl
	Q51AVutbnx2XnIyweqljPBEfrTcJsdbgSAkTVVfWwuoW0mpaNDgzQHA==
X-Gm-Gg: ATEYQzya2+oAL08GrWpLeb8th7Sjccgui36TZTP8Ii/CZFphVmVc57BfuijfZBdU/sJ
	G8rsD9aSVtkPmnjXBC+qmU5528mcOjXnRPc2ESn69PGs1KRSID2OU5OHgCJyoGrZgOYIp4B7V/Z
	6smeMZe/fO+voLBtmaXC0uQxahQ1qbBDK5ikLZZF6mZGibUfFGz6i12mjJHg2rztFpv/jtAPQyE
	s08m3rRziZ0OrwSdCNgGFDll9VbM8/kmcKF6jkIriR9HFGt8c92ezJ61s8Fy9N9MPoeSKGT4b2s
	ghOF8jKkdGLuAPKlMMBLGyY5yBt6SjadotR9mrUYU/ZUvVNNCGc7QGsl0Bvb0D+6LGNrTY/JYDH
	N4D9dbb9jmQApQ0/4rxq0FBQWE1nbtZaATiDNetAnQb7oKeSL
X-Received: by 2002:a05:6a00:3397:b0:823:f96:63bb with SMTP id d2e1a72fcca58-829f721d2bfmr128179b3a.52.1773173954467;
        Tue, 10 Mar 2026 13:19:14 -0700 (PDT)
X-Received: by 2002:a05:6a00:3397:b0:823:f96:63bb with SMTP id d2e1a72fcca58-829f721d2bfmr128102b3a.52.1773173953827;
        Tue, 10 Mar 2026 13:19:13 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-829f6dc2d0asm115262b3a.13.2026.03.10.13.18.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 13:19:13 -0700 (PDT)
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Date: Wed, 11 Mar 2026 01:45:56 +0530
Subject: [PATCH v2 12/25] kernel/configs: Register dynamic information into
 meminspect
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260311-minidump-v2-v2-12-f91cedc6f99e@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773173756; l=1125;
 i=mukesh.ojha@oss.qualcomm.com; s=20250708; h=from:subject:message-id;
 bh=ltcakv7Yz2En9FQrum1FNPMsP+X0e/gYDhIrKVCzFFQ=;
 b=BClB+LbWS820CJZtnnqAtm5gJtokT2sFMM8TPzt3+PSi0gs6NBgaizBv44fpO+LMuPBGRc+yS
 y7xG++f/5G9CN5rwIv87GOQsBogg0vfWjxMNrycZKJ7h1enoDkDDWR2
X-Developer-Key: i=mukesh.ojha@oss.qualcomm.com; a=ed25519;
 pk=eX8dr/7d4HJz/HEXZIpe3c+Ukopa/wZmxH+5YV3gdNc=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDE3NyBTYWx0ZWRfX/eSSk8HZqkVT
 sPA4uUiBYFRhBM9JoWxT+X8IMTOw51dKuxOPnJHS17oEN4ew+L8ZquIoC1wgscZUqXgd1LoHEdY
 JvkdbCUctUQnwWnMu2ChramIcVIuRK9qDBs8IjM9eoWiDj9WG9AKPkaNIwPvYtaoJpxXF4IYUv2
 tTS5sufuh8FEAfr+TtGdsh3h/3q7+kDsUqSbkldsvYIsD0y49yE3eyjpb+Dlxv73niWTZzaw4t/
 pPrKMrIs73kh9Q3AP6EoKAUzt1ytnexTPM9tlnBOorYYoknQfmlVQtX1Ho7ppaEDah2FY6iOdIS
 2MKUPKe5mnzopPU4x5a7GKFsP5Qc1ebqeTqwhFmAQtQdxmkirFWEtwaKPWMOD+oaXeNmnEghYnV
 s8OBiqqBrd4APoqMH+9ajTi1cjHDUwFrglvki2TS7Rs/TgcKgZa1l32PeMBm+6n057urqe2HeK7
 5Lt88dzosZ2S9QSa1jQ==
X-Proofpoint-ORIG-GUID: k3LDnifYoSZ09P61q6XFQ5w_jx9tMGEg
X-Authority-Analysis: v=2.4 cv=Lo2fC3dc c=1 sm=1 tr=0 ts=69b07cc3 cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=LjyN-fOCrMyGU0ESAFYA:9 a=QEXdDO2ut3YA:10
 a=x9snwWr2DeNwDh03kgHS:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-GUID: k3LDnifYoSZ09P61q6XFQ5w_jx9tMGEg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_04,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1011 impostorscore=0 bulkscore=0 malwarescore=0
 phishscore=0 lowpriorityscore=0 adultscore=0 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603100177
X-Stat-Signature: 1s79f7bzdkpfkyqeg7c5jiyqc5o814g5
X-Rspam-User: 
X-Rspamd-Queue-Id: 98FB380013
X-Rspamd-Server: rspam12
X-HE-Tag: 1773173956-561521
X-HE-Meta: U2FsdGVkX1+lrgW0G08bevlJ8IbaIKW11MUQrgMEibaxLx7T6CZV8AQmlJHdz5Zd4K4j7rrWXGOVrn/NMhltcxpApQ6QA5T6OlCRDpYlIh8yp5AR5IX96DA54Xt7Pb09YTuC7U5+Uz8ZIYNmCWVwE6UBFj+x0Cm/HMF/FL4EAa7qEOrF2os1Q9LhqV63P93eUt2FaVJOUYcbUNzKa7eQgcopPqZeGTQf3CSjHlG8VqnI/eDGI4OACoQvviTEW9GYnHJXTPdweq1K37HDVDTezVf4ix5dn4dwmKpq1x69kxlSCeNkOo0wF8axqDng/eAGDAqBOI/TlfUixWdEmKJoZQvgRy/hXqoToAjN6bA0Vf4HgoH2iJkizsnK9xLFI0fFD75oqLtlWSpM3KS1AL6tQ+FJuoTqQZvSt1DW+eU5PAjJfqpGJ0TMzIe0ORvDf+HFl3FcCn3nJEm1q5wVXt6uuhbevoPR+nOSKJIshowTOFNUxD2YJJZmB9brZF44dloD9dvPRa3evaWCgEvdKURBA9sYkNh24jAzRY5I65ZhxMjRva7wpKSzl4WexDu6l8Y4ShAxVmygD6pCTvL2f82tXEXpaZRHvb1Wx4ZFbBlYzKjW3Z8VdVGBT+CODH67M0ySNTe6GdqhnbeRDTEmrdV4/5PSAiaSn2Igpf+n5LmeJ6n2hPWdxrYutprcsdBS1DzZR2ZcPBgY6D6+o/i1aiGqjB2K9kuT9i3CL/0gEaQPkYxrvINC/837If5cXBtJRE4WN/zDn70WrajkUWROUWOBsZq5BiTV97Kjx5zeeMVT3bzu8jDowRmv3zakDeyF6pwGU6f2a6ITeF8BU4JCr4FiANvV5g2qXcI99ceuDYXjQDf1n/3I2pddOtFh9XTIdm9N05seU9uOOBv5PjYAVKHvy4qHhLfmTV4p0g6g4Gjk35uT9+DRmT/qsObpcmxzOKrKN7kQfrMGjToU3b7D12D
 QhzhLCuK
 CG1k17/DXAA417uo1B0zg8lulppJNpknTlYmo5suuKwXSwC6/m8dajpTMJkxTNbhzjiv2eBYs1OLHG/w1FkS2GBRIqHQzri4DUotqqMsaeuD4xtiF6Q7tF1qZLcPS9x71fukug39AMlwb282BZAoKqd0lB0yO9RBwRxTU+Fd74YJz+EOkaWuzMMjNzv862DqplNKi3eSYXG9i+t2mgHosPFWYHo5ZXCYs/2xmcpee3v3pECvcdv5i1B+81rJKMMmMqYNZVT7eeojDelvKdk3RuYBkukpbGFFhtKOTkyuhkNZjmYsJ5hqTWWu56t1yNOxP5aa5xEC5V3K7P1v5cR18yIIp90iS2vzO+nGQJBfIRuy8f43umCHr6i3nypty6zLlQ005NSntta2VWz7CAwrxmSTfT9lfqKlC7OE/1sZZUpHjl2RaVN2u9GyArO8PV7Cmr6EJ7d4c4uz6r304a9Q6DaS4BwGbNpqxB+3zKz4QFTsiqOvr9dzi87ZS6Wnf9OR7tCbs7HEGPqV9IE2Z/uCJ9hvjmHc4holDGezPLXXve1WoonmkLiqw7/cKEHCvXSrZV/Ysff+aZ05QTROINOJw88Ym4NRlXr5zsgTtAOi62w00YPxnNCccdpzXCpoH9/Cu6YhbzwGC6IngAlmJoGYNEGkVwg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Eugen Hristev <eugen.hristev@linaro.org>

Register kernel_config_data information into inspection table.
Debugging tools look for the start and end markers, so we need to
capture those as well into the region.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
---
 kernel/configs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/configs.c b/kernel/configs.c
index a28c79c5f713..1e7b86a8b3fc 100644
--- a/kernel/configs.c
+++ b/kernel/configs.c
@@ -15,6 +15,7 @@
 #include <linux/seq_file.h>
 #include <linux/init.h>
 #include <linux/uaccess.h>
+#include <linux/meminspect.h>
 
 /*
  * "IKCFG_ST" and "IKCFG_ED" are used to extract the config data from
@@ -64,6 +65,11 @@ static int __init ikconfig_init(void)
 
 	proc_set_size(entry, &kernel_config_data_end - &kernel_config_data);
 
+	/* Register 8 bytes before and after, to catch the marker too */
+	meminspect_lock_register_id_va(MEMINSPECT_ID_CONFIG,
+				       (void *)&kernel_config_data - 8,
+				       &kernel_config_data_end - &kernel_config_data + 16);
+
 	return 0;
 }
 

-- 
2.50.1


