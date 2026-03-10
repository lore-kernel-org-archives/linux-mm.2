Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22F31FD4F34
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 20:21:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CC336B00B9; Tue, 10 Mar 2026 16:21:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 794A26B00BB; Tue, 10 Mar 2026 16:21:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 640E26B00BC; Tue, 10 Mar 2026 16:21:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4F0406B00B9
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 16:21:52 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 228B9883D0
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:21:52 +0000 (UTC)
X-FDA: 84531274464.05.56C8D5E
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9423E4000A
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:21:49 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=HQL1QpS6;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=Kvvtf3DQ;
	spf=pass (imf17.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773174109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VCdzm9lFxRWxv/OGB66sjGQmhg7GtSvSgtFyJmtFvU8=;
	b=vDNGiGnKoi0h+cbETAUDAHxJ0mImDkl+HPz+Vk8i9sCZaMOGrAtf9akHicA1Hto3tYMOA+
	UcKwF9O75p1Ga8Jfs7U3wmelnkhNY7SAqjROMDm9LC0pxoJr310jmq2wMiJblPHUT/IoXR
	5egHf2e5CgQdtDTyHB1k7WYBGUmv+J0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=HQL1QpS6;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=Kvvtf3DQ;
	spf=pass (imf17.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773174109; a=rsa-sha256;
	cv=none;
	b=5tYyn8nwZrbrIraJnbKSg93wi6UYKltvLOkehyZNWE/6kJesRYijNew2R9PhW+bkgoBJMa
	/5ke1uezmzQojKQMRJXEyMYeitgbRxI3eTQcmXkv/2l/b83kyQzPfUhi0PTbPJu/I6xyKp
	jHU28CG8M6kI7o8I/IyEpJ53669uMh0=
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62AHcodO2179278
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:21:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	VCdzm9lFxRWxv/OGB66sjGQmhg7GtSvSgtFyJmtFvU8=; b=HQL1QpS6PGBC/FZA
	PX4YjsgO0EBnSchfNwcBS3m6TU+NNlCLcGrQtQkorNh0FzaHM5W1qBUSH4t40Ywe
	rnqKPE+bKNZHgqY6cQwf4xlvZZWCp452mWOUukXFDr0W7J54/mR69MCA3ZBbLonf
	/r1SEgJueONA3Z83MxDPYnNQIwaW3hnRpauSnUkZh7U9UoVPrYU2J/tcDo7QurKO
	wSAkOiSXKoaEchsvNOOrD/jiFQaBVl6utpry/KlB+nytq6sReLZ5m7oxRucUenoE
	NsMcKBaLuf/yCIWvjHH7ul8NkWRIdrXIa0DVm0Olsw2A8tyt4D9vZ4VeTQZGe++R
	9biJ7Q==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ctqvsrkcj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:21:48 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-c73887d0297so3321114a12.0
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 13:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773174108; x=1773778908; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VCdzm9lFxRWxv/OGB66sjGQmhg7GtSvSgtFyJmtFvU8=;
        b=Kvvtf3DQ1QM5NHCXxBw1EwfNBH85kGjcvGrH/4pZ+5NXGG8GlBd+qvSSzh18D+RnBu
         uE8jpcdwTkqcANnr2JxodmPUHXQJsSdq3xLMAO3bAiBsCEtoWqT6LCRmBc+guE3ph8IQ
         peWK7uZ7rvYvScM3vp2+xAuJrtlQstcTgnVstSxjIbsFF+4GCljZpt4aCXA3mFYr+7Pr
         o7gH5epbCTUXip8kcTZp+j8fxJe94x6+CaKSBJNJCjHG9HfEAybyNI4es4BsJV1n5O1x
         T7PREakfMM4fkOy4fbhEBDbfYo4b54sxquWOytXEDJH4A/vBAuC5f1ZCg4DZSr+IPyrF
         89Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773174108; x=1773778908;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=VCdzm9lFxRWxv/OGB66sjGQmhg7GtSvSgtFyJmtFvU8=;
        b=XRh6OG+YQ6Q6//jE5UgqBwQZs4k++4PPF0tL3IJlXI05nyuEFOqBCwZLlyi1GEFtrY
         OjNXxE/JaWHZ70/zfv8YtTk3hDcqx9IniFgAJ01aNkMyJ4ciZUdmPIq2cAP40zcG4YxL
         uhoBsoYFV0UveaoZVoNFWaJMYNCasmiipBuzHS3V6WwKVwYZ0mJlFpD+Q2CGjQAQwK6D
         97AFUKMhXUJX1Wt74zwTy9xpXyMa0QLN+sfB+efCWtFIGfSvw1EMGva3FzxsgN+qVpgu
         fwNEmsmwoMUZMuUHSvtv4iB1zUtbo6Ckgx9v9Qi7d+lWnzuu9gW6mIYkX7BI35/mu74c
         fxOg==
X-Forwarded-Encrypted: i=1; AJvYcCVuDfoGkcIfQR2csT+7IbL8E+aE70lYw1jEDpAIzWYY54Y5PIIjhxbTU27eVT2Zj2ozEOFVr+IkYg==@kvack.org
X-Gm-Message-State: AOJu0YzYBAfi+J/vjTeegTHa5V9gEfe7pvmboRSVJioxLFIQj0uwpoNP
	D8FvsSff1lEAQLQKMTa1rjtRrfwfv7M1/TU/4zm8JBBSTNYsWeuorX7n/gyJ0DscMR3dQJL0g8P
	DrHy10x+YOUaYdUyJDkvuOLJdqOV8KmYxWfAz6VSyS9ZX6yO0SY6Zgw==
X-Gm-Gg: ATEYQzwZiHt3GaWSpNqZWWUROmJefMq9x9uG+39V79nHnvUzGF3LpXqBwb2yz79lKjZ
	ywttCwRYdgOe8CKp9rVAtd5zUlN9YweBHwNgYtsVxkeIT6+QQAi1vzT6boR3bmUpwwpC0qSV8EW
	x9LkIzpFUD/vAlzDXD+fmIPQJIZLqdI9qHwouq8axJDh2F9kPC1q5D16h7esozCFuXM+F63Ke37
	4RTaYT0nj3O78EKPRdY+TE0AcJjZSi3PL9SSeYOKxGRcxDna+GVfiayJjLC0WIW/4mdBQrB1pw0
	w7w6AftqKZEJD4cUOFuXHfRgKk/LgRi0dbr7xRFdIG3c+43PflBRORF/6tAHzLRknGP772GePGz
	e7Rq8+Bt21bAStpJJ87ThRr8eLzluZcwpOeiZyRixZFYVYHWD
X-Received: by 2002:a05:6a00:4b10:b0:81f:4dfe:ddd5 with SMTP id d2e1a72fcca58-829f70733aamr147789b3a.4.1773174107373;
        Tue, 10 Mar 2026 13:21:47 -0700 (PDT)
X-Received: by 2002:a05:6a00:4b10:b0:81f:4dfe:ddd5 with SMTP id d2e1a72fcca58-829f70733aamr147769b3a.4.1773174106642;
        Tue, 10 Mar 2026 13:21:46 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-829f6dc2d0asm115262b3a.13.2026.03.10.13.21.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 13:21:46 -0700 (PDT)
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Date: Wed, 11 Mar 2026 01:46:06 +0530
Subject: [PATCH v2 22/25] soc: qcom: Add minidump backend driver
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260311-minidump-v2-v2-22-f91cedc6f99e@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773173756; l=10956;
 i=mukesh.ojha@oss.qualcomm.com; s=20250708; h=from:subject:message-id;
 bh=RDT7v6bqYk5bgglut/PG+8UNw5M1qTcxV6gcC7IX5m8=;
 b=6AemMMzEj5Dcxm3yu8ESj11geNVlW4Nj1GEwJAOJ9eDH9gXDzgGOuIBfr3oWn4RQBrTsomaxJ
 Id1S77WZvDVDh1w7OTBnW+ynij8GaYSu7aKk6/IJZndYW8gs6ezdeuh
X-Developer-Key: i=mukesh.ojha@oss.qualcomm.com; a=ed25519;
 pk=eX8dr/7d4HJz/HEXZIpe3c+Ukopa/wZmxH+5YV3gdNc=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDE3NyBTYWx0ZWRfXy3JU0LimMrEX
 SpDOXVaou+HOqfS/QwvEdd44RkQG5hc0RAEQ5Xv1bo8D69qAeY9jov6HtypPDddBcIXlM5MtEMa
 FGszjPijhIddQRYRyPAAfVxcnuG3uw76hWif9pn0EjveYt9qP2oH0FJbI51h5BfMSRpVNMyoeXF
 K37dAm9fb7AeaX8WXPwPIYrI6+939DQvfgks1VDP6uo50vgdVaFZwf6k5SBTjry1UJ9OhmSp+iM
 evcwT7SLvsuIWCR8whbCEwd9pYxwWPwBxzhDvcrHlauD61oArKY45I/70gmzTUP752o1Z/3x+qp
 EVWrXilfu/DLIeQpX56ycpvPEV52GcR4EKIh/rvkJjYsmqAcyI28Ct+Gq59GNviXhwErn32fH2L
 t8fxkrgfITegNcvjdUvDdZVx0vAI3e5Bie9VRC7WwIHXismys5Jc3DJQXGttcboJPM9ubnielJJ
 NK18CI6q5ys6MyDqn5w==
X-Proofpoint-ORIG-GUID: 7b1UOO4LIChvWm_fgHR6VmyUtIJ2tY7A
X-Authority-Analysis: v=2.4 cv=Lo2fC3dc c=1 sm=1 tr=0 ts=69b07d5c cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=nZcrojPlbim1gEWq_fIA:9 a=QEXdDO2ut3YA:10
 a=x9snwWr2DeNwDh03kgHS:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-GUID: 7b1UOO4LIChvWm_fgHR6VmyUtIJ2tY7A
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_04,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 impostorscore=0 bulkscore=0 malwarescore=0
 phishscore=0 lowpriorityscore=0 adultscore=0 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603100177
X-Rspamd-Queue-Id: 9423E4000A
X-Stat-Signature: hy5chdkmcwjrdqnh465rzpuuirm1odp3
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773174109-354586
X-HE-Meta: U2FsdGVkX1/XX0vzQXkAZYps17cdupV0ktZ9UQG1V5xUgIhDEHZPKFH6XKhYTSg/7F1d/2AXy+KshOi1/1uOqUF0oz6j54dFjt3KWvTQLAUR6Xm6/6nOalM8CdbMrQKgOB8dPNIkzTcZ/C3zfBeE8/rjavvhJszvgde4iiRFc0i3DLcAHD9VU7/8WHweoYHMtrkjJuIBXrUG+TG1tnx9fXKusEUB11DiTtuGNS+3YGqx60ejYSIfcaffp1A7xwiqYoKh0Att2adPA02pI9WNmQVCss6cm6RIWhq/2F4PvkjjXZwILHVgyADXANiDqSV0oTkaAOyf1bIlAdPzCQztPa0Hpxgvk0RzZ02r4WCpUSIJqlgqETHItzEy14L6GePdEL8R66v3HTxkFW3Xy0K/mX6orRP2bMe0elPNvoS7W3va3bC47/PliegXDvAs496xtRFq39atE8kI9PTC6x0eDxatIudVLSrXBgH6vivZhAiIjaLE1tgqr3zzN7hnLxxxWwkwumt9G++wltlRNcP/3YymNP2EnoDjriUMCemaSUm428JaX9wosjCbeYLZz1QeCFkCeYLyDIPCyznSUvdTUQz5EDGSYQI29T6mxIHgRwwYT1MHej5BzIJkz2J7AAmjcwedLq7dXVfFWUgFzhJ/lk8JAGcLNFPg/+ToB/RQQezmTKLY0Oukvy7x0A+2Nr9WOC87u4UcVBc54DGwqqMqBWAndxnA+ql1ucx2ciqFkOFPU1coqTjiRA5qyQcxgkKCx3ypM+8mcbJdTbrd2YlVEfNDv79lfv+dzjMl3colI13zW9RwcHm0zo0EuAXD02JnU+a+czyRnFnspdTmZtGzuPlbJg+EgDUzYp0JUTh41t9m3xU8NfHgIiCwKx5mnsTHB93gOs6bOXXlcoU2kJv+iiK1KWolnyRZPVp5LisD/l/yBURbh+FRIVRvWpzzUIFln140q7y18awcgQ4Mhlf
 Zt64rbiP
 sZglxUhkwPUCvaaE6UtKxozmxejezuKwA6xntsL5cKk2Hh4fe0++AJbuYPNF4CD3oRGAg2onZZ/9wefqYnZertycYtNyE6bdS4deHumyNyVccYTm3H6XgfcCQEadKOIzrDwYAOsY+ImWkgDkDnDcVWW5ryZBFUQXpjU5XDExkhidJO7UBQZSDJzhinDbvyQ4g3qv6qxK4LFDvQSQs3vDkEQOeMCYA5esJZiF8G3xFEz9FHigX/6PcaZseMtqttqdHkfPuRsL09tHCYVAz0zXCF+dHG8FhIq2EsD7+oHJ3wQC2iJoBWi2Q1mT2UldPSYL3ouMgvkGoEwVW8ACo+ORyzrAKMUKI9VZvwO3bVDi6HoIdqxoSwU+MZDceFcYSLa5+lpsI0PAUCG6DyUU4WJdQ2UUTXpUIJh+n8AGkxomAn7X/JbaBOEmesa2awSxwEEVbK4kgpQ/uC1EYj+nYvjpoh/EsZXsyKJ15fPLrntoDN45y5ATrQR13O0F6DD8j7cKWnxHlN9tjACRkVffXM1Tcm6/5AtN6pofj3hmJM1Qu/+X/TuwO+sRfhw2aRN2rxhNQ2vIk4dscKESe47y6lMJRrTHw84ZOpTLOVd91pXiyrl4EiQquZ++lrYWq0vVPjwWZD6beJ5T4mktqHu6e/wA4sABQzKct0lbsTexvgJMy6ktGWTVLdUv2B7v5Rg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Eugen Hristev <eugen.hristev@linaro.org>

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
 drivers/soc/qcom/minidump.c       | 272 ++++++++++++++++++++++++++++++++++++++
 include/linux/soc/qcom/minidump.h |   4 +
 4 files changed, 290 insertions(+)

diff --git a/drivers/soc/qcom/Kconfig b/drivers/soc/qcom/Kconfig
index 2caadbbcf830..be768537528e 100644
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
index 000000000000..8d2e5047b5d9
--- /dev/null
+++ b/drivers/soc/qcom/minidump.c
@@ -0,0 +1,272 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Qualcomm Minidump kernel inspect driver
+ * Copyright (C) 2016,2024-2025 Linaro Ltd
+ * Copyright (C) 2015 Sony Mobile Communications Inc
+ * Copyright (c) 2012-2013, The Linux Foundation. All rights reserved.
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
+	"high_memory",
+	"init_mm",
+	"init_mm_pgd",
+};
+
+/**
+ * qcom_md_table_init() - Initialize the minidump table
+ * @md: minidump data
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
+ * @e: pointer to inspect entry
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
+ * @priv: private data
+ * @e: pointer to inspect entry
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
+	platform_set_drvdata(pdev, md);
+
+	md->dev = dev;
+	md->nb.notifier_call = qcom_md_notifier_cb;
+
+	mdgtoc = qcom_smem_get(QCOM_SMEM_HOST_ANY, SBL_MINIDUMP_SMEM_ID, &size);
+	if (IS_ERR(mdgtoc)) {
+		ret = PTR_ERR(mdgtoc);
+		dev_err_probe(dev, ret, "Couldn't find minidump smem item\n");
+	}
+
+	if (size < sizeof(*mdgtoc) || !mdgtoc->status)
+		dev_err_probe(dev, -EINVAL, "minidump table not ready\n");
+
+	ret = qcom_md_table_init(md, &mdgtoc->subsystems[MINIDUMP_SUBSYSTEM_APSS]);
+	if (ret)
+		dev_err_probe(dev, ret, "Could not initialize table\n");
+
+	meminspect_notifier_register(&md->nb);
+
+	meminspect_lock_traverse(md, register_md_region);
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
index 25247a6216e2..f90b61feb550 100644
--- a/include/linux/soc/qcom/minidump.h
+++ b/include/linux/soc/qcom/minidump.h
@@ -10,12 +10,16 @@
 #ifndef __QCOM_MINIDUMP_H__
 #define __QCOM_MINIDUMP_H__
 
+#define MINIDUMP_SUBSYSTEM_APSS	0
 #define MAX_NUM_OF_SS           10
 #define MAX_REGION_NAME_LENGTH  16
 #define SBL_MINIDUMP_SMEM_ID	602
 #define MINIDUMP_REGION_VALID		('V' << 24 | 'A' << 16 | 'L' << 8 | 'I' << 0)
 #define MINIDUMP_SS_ENCR_DONE		('D' << 24 | 'O' << 16 | 'N' << 8 | 'E' << 0)
+#define MINIDUMP_SS_ENCR_NOTREQ		(0 << 24 | 0 << 16 | 'N' << 8 | 'R' << 0)
 #define MINIDUMP_SS_ENABLED		('E' << 24 | 'N' << 16 | 'B' << 8 | 'L' << 0)
+#define MAX_NUM_REGIONS		201
+
 
 /**
  * struct minidump_region - Minidump region

-- 
2.50.1


