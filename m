Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B2B8C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 05:35:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EE8D6B00AA; Wed,  8 Jul 2026 01:35:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C6BC6B00AC; Wed,  8 Jul 2026 01:35:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED0A36B00AD; Wed,  8 Jul 2026 01:35:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C8A1C6B00AA
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:35:42 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5CDFB908CB
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:35:42 +0000 (UTC)
X-FDA: 84964497324.23.5AF6640
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf21.hostedemail.com (Postfix) with ESMTP id CD7D61C0004
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:35:39 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=VEFi7exh;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=FQfJtnf9;
	spf=pass (imf21.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783488940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mY9TC1kShItUPWikoDVcElgzg0fCudtz+RsSBo7NFkQ=;
	b=gDNVZ0ed5fxp6jv8PQ/lMM+zWCJXUjT1ZW3CaElVlY8cUqXVfDBdo/BYxmQg/0WAXang7v
	WsyO2GRWNGFYumlY1RHpeg8rDEfSke6kXyCUFOmSN0L7vzOpXgbqJPTOrFHeJqgIg9y1qa
	sbEu/o/OneRlZeQWw9eRnCUVf9wEacE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=VEFi7exh;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=FQfJtnf9;
	spf=pass (imf21.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783488940;
	b=swQLw8+LO+ZhvF4E2WCr6iLKrKXVP5q2cLaRnMWXLfWNc3fS4L1aa1u7r9PSfQTDh4n15T
	kcwNEk6M+yKvo/mnGS4eve9IkatmaUB6YwFZZpV/xxaPI6Su69ijiQleond11RGEteCYbC
	jbJcWpHEiiUhTGCpjoXUqOE+n+oUPHY=
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66842EAb1695157
	for <linux-mm@kvack.org>; Wed, 8 Jul 2026 05:35:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	mY9TC1kShItUPWikoDVcElgzg0fCudtz+RsSBo7NFkQ=; b=VEFi7exhNSE6eNEW
	+eOINcOvpmvrYtMDQ2p7cokzjt5kzecHBE1gJNpxiTLmdl1qUz9o1o61/AidoM9W
	5aVMXNyOdd4piuVhr9ZC+O09c06yDw6rYq9buVtuC53q/zta3TqKj6PITSKHl+/k
	4PQSHLgG6NrMtQ4lDdeuzpexKnNxfO5AlU89IR26micEaRG1GgUStu+GqIHiKTVc
	HGee/omlz97CBjj3CBgGEj+7JiOX7FYdeyJXhDqFXm33K0IEohevYWzTnQ226eR8
	qJgj7kGAOJQh7X9PuwyrCsOhrXCLtCpcWAVqDBKFcdtCsj/36uY1RrBoJoyk1l5w
	LvCdVg==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f9csw8ss5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 08 Jul 2026 05:35:38 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-845bc2e658aso372689b3a.3
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 22:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783488938; x=1784093738; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mY9TC1kShItUPWikoDVcElgzg0fCudtz+RsSBo7NFkQ=;
        b=FQfJtnf9RUEktb+pfsEgli7hv+yi//swMZTBDEzy66wZXKVMHEqr792DLPDYKzHQP7
         5tZUuKVjjFK7PXvKSPLjCd83yURUxpcDyEz7NT0m6pjy3GOLcACuRe31P6cjlwbtEtII
         SXnCc31ShjRbzDjt3czCzViGYRiXMPyLPny7G7sjQxPk+WjYzRheurwa3510iswQ1Xge
         GitZKCNkMkvYwlpCJLZW8zqZBwfSnFPLHfNm1yCr65W5kXUDTg19uMGASowOX1CPcoYL
         r5oNh0kGwYGR6N/C8fKXd98nfLB5iY39/fnXhJIJYTcT5pNfae8Y735w6/ahPBbkUdbq
         9KbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783488938; x=1784093738;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mY9TC1kShItUPWikoDVcElgzg0fCudtz+RsSBo7NFkQ=;
        b=fysOP6mWxcJWUFhaEr6EKdzfTq0Fbg67fP18Km4IroLk1zAdN7P3qQ9CidjrMtVDkW
         JAH5RxliE/SKGTq4uiqNKonyVN23m/q3HCGPhHpIj73zDe/uJHl0sT8LBTHCrW1CTr7K
         zOh4H7SoBW02KnaaPcbWB8WAvak5jtqKzEwSC9Pw3gU/+SSf1ipPWxM1TnJd2f8z60w3
         g6PV3T2xor+hbeTcmDpX6crhv/9N/cDvUUnzm1TR/ogPXpY8aJlS39ktjRxMDT586poD
         JS69soA7yIr1/TyMibv0oNEeYXzh71TWot0PbHcDz1xxAB7PH+tuS75PLWDWov/VB6X4
         LWKA==
X-Forwarded-Encrypted: i=1; AHgh+RrBnuAMsSqMTLtFeyW4TCgLPljQcl4lYjx8Et/uXSaNgLnQCfsBFszXZdGoSugB2DNMPNQOZ+YYTg==@kvack.org
X-Gm-Message-State: AOJu0YwEyH3GuWNoPc4mnA80kdKKFKGNmQxLCtXk1tuWyFDQVkvmfjjb
	R1be9A18LOUO5XEogqS4Pb8t7MtsT7DUAF9OvgKp933J8wLjhn4U5eVC+gIBJ5YQM5Hf2l70CXe
	C1RRY5NWp5aQG45nynGqVc1LZL2HkpZG4JoWGDjVumJB+tZB21gcUQg==
X-Gm-Gg: AfdE7cl+RvvyG2kywViaI6ZchPPhi1RQftacRQ/YDqbujFPlnuKtuycYhasGwT8g88X
	kgLoyNpDeQ2pVk7fuaVrhzHnPcSr6642WkB/oga61b0JXhrfm7vwKEuf1a5LR5jAcyszB5VDQbm
	FRQfCUVewjV/lQPxv4CwFEFaAU+CjoFcgwrDU00BMHvUjwtAnOdsT65I8vEoG5oV/BURcM/hURz
	dsuuh9RCUz1c3vgVVMC0pvQ9yaGO3P20YV5qPOHtyRg7IYZtUEESPnBtWc+LD4yS9HYA9kjsD8N
	6Haobu0It4W8Gs+FgEVTC3R+fZyfOU4k3K1F7LDxC/Nqu0mG3cs93WpAoWJ+D2tWavYxBEZskeC
	ZWRH/NuxEPykzdNhZC4ZEVBPqTNKAs7OsIH6vUw==
X-Received: by 2002:a05:6a00:3a13:b0:848:2f74:1d66 with SMTP id d2e1a72fcca58-848438d7230mr1080708b3a.76.1783488937319;
        Tue, 07 Jul 2026 22:35:37 -0700 (PDT)
X-Received: by 2002:a05:6a00:3a13:b0:848:2f74:1d66 with SMTP id d2e1a72fcca58-848438d7230mr1080644b3a.76.1783488936625;
        Tue, 07 Jul 2026 22:35:36 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6db29d1sm6484592b3a.53.2026.07.07.22.35.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 22:35:36 -0700 (PDT)
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Date: Wed, 08 Jul 2026 11:01:52 +0530
Subject: [PATCH v3 13/26] kernel/configs: Register dynamic information into
 meminspect
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260708-meminspect-v3-v3-13-7aa5a0a74d5c@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783488714; l=1125;
 i=mukesh.ojha@oss.qualcomm.com; s=20250708; h=from:subject:message-id;
 bh=ZV2kS+66Zo+GSuPrvrjZxSGkrByR7dJYtHrlrdTWNGk=;
 b=5SVbNkatrByr1/TpyiDmMuVtbPFXDVWi0cCCZKl5b9Zre8CMglPYGspE5ZWEb3Shosf+K63nu
 /z7Qty/Pfv5AEFi1fClZu/IN1yxFaXSgXEakFkdUbQUtlP344UBgWQA
X-Developer-Key: i=mukesh.ojha@oss.qualcomm.com; a=ed25519;
 pk=eX8dr/7d4HJz/HEXZIpe3c+Ukopa/wZmxH+5YV3gdNc=
X-Proofpoint-ORIG-GUID: ofXfIJNYksLOT8aoU0Opu6eRkkN-Sier
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA4MDA1MCBTYWx0ZWRfX0MdLghY0EaP4
 wujZZjtmLocEoCq1NND2lBgENLOHIFbc1BHYACsDtfDitzssbU9WeeixO1FjNHbezW2/knCv2yL
 Du7Hx0UadiW+HW7qh4zqm+f8yO3gjU0=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA4MDA1MCBTYWx0ZWRfXxNRXsVZ2fPYU
 DgQ5ink+o/WavzKz6JdcNreXb9ByYEzJwl3oASfAnsVzRRS37Jr7zgBrmyqgK6sxEK7P51XyauD
 ZKv9DjgiH66SSouBHLFZQPqV/4mgGf3B/6RDR/LVfAjzyivdwDZjvwlzkekpqR8PurmXi+ZeJTN
 t5O7HZ4KpcuPmjcZjZL623nybxpz9g/L1mHb3feoM8ZcHBKPeRxgeB+8KZONYWd2wlZRI4+/MAo
 YcDnCONseM/kCLZ5/2+MqWfV3d291SNb66jN0tskdcqQm7PVImH3eNBVrq2AsfAFj9O/3y1KLts
 Yq3tJg+zFTKoOW5HSAtdO84Gr1YbdtG0sPMg3mYEKHVo7r2jkLmc0hHm3jt17TG9LAKp1p1AXvJ
 +4Nv7rdLxa9KF34Va1Y2Dn1bGc4ray8gERcPSBDe1xxi5kguxcaPSLyG5SDkQUYdzoKfuGLb7St
 cf8rTIwoDA//hrQoxbw==
X-Authority-Analysis: v=2.4 cv=HaYkiCE8 c=1 sm=1 tr=0 ts=6a4de1aa cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=VwQbUJbxAAAA:8 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=LjyN-fOCrMyGU0ESAFYA:9
 a=QEXdDO2ut3YA:10 a=zc0IvFSfCIW2DFIPzwfm:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-GUID: ofXfIJNYksLOT8aoU0Opu6eRkkN-Sier
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_06,2026-07-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=0 lowpriorityscore=0 clxscore=1011 adultscore=0
 malwarescore=0 suspectscore=0 priorityscore=1501 spamscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607080050
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CD7D61C0004
X-Stat-Signature: uepyjjtgz7afdquu3aj9pu391ebm5opj
X-HE-Tag: 1783488939-772269
X-HE-Meta: U2FsdGVkX1+/6bTEI7YWUXYGLytE5PAuJMUjJ8nFGSBzaWsUSwzpQLqFcbPjdvnXWvGl+kkfZnPeG65fsPCCDSz1q2scpKf7DZjOq72C4SZ1tLMNPHohbtjTu6z8jz7TE/Ve5HoGMzEzLho2C8SgZvqIMDiGRIhBHXI0B07FcIHvkTC+qyE+K2kovzMNgq1pDpbQS5sI8hFMMiODDkVEn91TMKC0tUnCBhcO05V71QYqUVsiciW9/tGni7Pt4ZXK8u655EHHTGDjaRx2DHfsjujlxcGUlgfNyDz/EQFh25y8cGVT9f9TzrXauEgQ4lzpcxdN2YOAr5YtnO7337yBKeMt8F/aaUGL0MKbayBZ07RkJ96Yu1DBbkBgS87GOf9VdG3Sz6m2LY6vJYDkDWbOdhPwGQhQh+2vyy6pituEDle81JExGs8glYyGAJNoERUjDR5YXvG+QgGLi8izjx1X/zenh5AhuN44ik0oMf1NmFGB9nG95Q9QkAAqUGM2bRSoumWSGdKkYUSiQW9mS0iPJqQrCTEQYFzdi4EpICI42zWxR1bIpZ3FeW5hLgp5HMBlIg2q+rMoTCv5Hyn60Jx5MCZZY02lzGkhQXpo0DiO5F3f2viLZRrlm5uik6mqEU5Nn2rL+lT69Jy1j36nWI7wsVeXKPyP4lBsJ3GOc5R4SHIYGfUfwFmR+QZA7HGzXjasBRnSbyyQwJ0ZuNAa/ejaL/KMgHwM3SNxUzFoEY0yoQ+v7nUDc4scli5mxKP94Rz4tiGlu+zZB5qY7jyt2dNwwEelJfnnXCvsadYplLz/QQTR+Lwr603DWT56CEbBcNO7e1IYfLyHCJFLG88RzTM7BBLmfCgaOHHwpCiDwk1dOVAvxkmU+FC8mFfdTSMGBBbky/OB4ug+GX39GG0yx173mcBK8O91ug4gxFBGtUa8LW17YsvI5AZkW71E641ybQB2FZwJCTu978qoOcXJMTv
 ldS7LcZ1
 GU+iJs2NyzZp4VhSwqroDFLK/PPPByqGNRjKFxc10nMJ85F/+HsgkowDiW8wjJ59euVPPHD8b8KRqIQHkjIA02Kqa1cNqFHN3XuIAzZ2qvQmpzTgqfU6iCZYievq7gh3ThxMetjONLj+iionULa6QpE0WNRkHuQsWkGwnsFxkWlYDy8IRwCY2Y/Oumr2rC1cwCcYj+SiGUI/K0w+X3vfN5KIjVq5G4+2UQaKndIv5cuebRpyzwE+2z2Ot1xRurBB/NkZ6DrhANFXor+ZiQsnTk6VSYd7IimtQKrWDm/6lpNirTeOGgq6zExjlCqkpG0SO0wy1e/hG5KUdmw6BCFaH2q0ssqOUqcbV41om1Nv2IpmXGuJpKLie7QfIhqZMqZf8z2h9hQa3Y1OWGcmMAAsG7/ErGciZfTh71ZUwHsmNcySxqPeGgkqwilKO0qpaJn8vZxoejk/1wuCg/ZQUiawDIkC0/7wIpsHqEwZRhuGlL8t12RBbW3JlX21T1Tg/Kb9ZhTgNbvnwvOk/qWR/zrfFJJ3gVZ3j/kAt6flbnJfZT9X+7avdYARQjIJ9h6E1xOq0lymhzeUA/0d3cjMiQDx52A5/OtRuSYSKLeqXSxmO2Q/8eyUtcMhYiaBH3A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Eugen Hristev <ehristev@kernel.org>

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
2.53.0


