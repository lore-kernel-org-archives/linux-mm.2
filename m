Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EC1BFD4F33
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 20:20:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8450F6B0089; Tue, 10 Mar 2026 16:20:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FB8A6B0096; Tue, 10 Mar 2026 16:20:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DB0C6B00AF; Tue, 10 Mar 2026 16:20:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 568586B0089
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 16:20:35 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1A31B8B4DE
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:20:35 +0000 (UTC)
X-FDA: 84531271230.03.63B9697
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf23.hostedemail.com (Postfix) with ESMTP id 91D7A140009
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:20:32 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=bNqSVUAR;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=CCkB+GwS;
	spf=pass (imf23.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773174032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FwPwm9egcX+1gvanmp7QoXzEqEd1Picj/3vW/4UCWRY=;
	b=r4dNgYpIhM+GCmgdX9znpXzGJKqa98GvDm+aNreNaCnJhAIgEAg/dMA/fWtbNA5MbBdntQ
	TKJzDYMCZudBPfQOX+vbJanVSa/G08jyhp/RFMTCmVurX7lu/tLPhAxEWpyL99KKkuYxXs
	WudPlNBPTfCWn9AnBtMC6nne1CEqfik=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773174032; a=rsa-sha256;
	cv=none;
	b=T6FS9FqJ1K0Jf3kI80u5TpnC73Zeo5H/slNyX4MtadqO0Xrj1LOuq4BFplc1BgpyKsd8wE
	HkWc+Vud59p1KG3z7NpF8JIpfH+EVyClXOAAjGxRXyZcjmp0DMBsRCtPLlAaFajw6KNAZT
	duJTB6Xnmif+TbbDmwN/pzElibe4N3s=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=bNqSVUAR;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=CCkB+GwS;
	spf=pass (imf23.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62AIo5KZ2861862
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:20:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	FwPwm9egcX+1gvanmp7QoXzEqEd1Picj/3vW/4UCWRY=; b=bNqSVUAReEBebBrT
	ofohgRxPzbWGJJ38g5iWUzHtnSkL/fjdSQlZ0gdSMlAFXkNkOP4rEQmBrnov7snm
	HbeI38MRtkXkee+aCtlogRvfLkSMIR/qWkWlRtD9sFhEMOtYNytkfbSFOFzMfu+H
	We25PIxl2QFD57enTLWaatpPBvYhic/xuHsemTbMvEUO2G2erVOPG8l2ceamOU6E
	/FgY0+QEaDXlCGBSKoIxprW3BLsxJjuly+/xmQvEwgP3fnHLoVwiugxuExFXjhdY
	vKjH9P2s85pdWK0yn16vc2VtDZR5SmuC+uW+yDzEEAMMmgnLoDpKcDkb8EuWnJFa
	F67aIg==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cte3wb6dh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:20:31 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-829b7ed8964so2426336b3a.2
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 13:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773174030; x=1773778830; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FwPwm9egcX+1gvanmp7QoXzEqEd1Picj/3vW/4UCWRY=;
        b=CCkB+GwSjssVJ4Tpy1Emfc+3yCUE+tuKCrxgwAw3Ko66u+4lwfMcY0hdU+YogrQb/h
         LBnSpNQ84XAFNAQbyrlgnJO+LZ9KLG84+mTc0K8K8KpDJFjSEXMxHCSYjHxsxFexKgf3
         UHzAGoZhm4ZYRBKKrOAbmW8O0NtPEIAM2s1ZZyhDZLNNdGE1jabo9BCgu0BlGfMESf3Y
         /ElbDpNxj5NSa69doEH1IGokD6aZUzVu/FZ6ps3ZNJ7he7xKcso66JXsd80sh7Di/GNe
         Z26qFNqtHJ5at7gvTumsn2TcSpM+0Z+UNdOA9cfS7P/H5PfqQ8q8PR1YP0VrU4Zs4aC4
         WfHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773174030; x=1773778830;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=FwPwm9egcX+1gvanmp7QoXzEqEd1Picj/3vW/4UCWRY=;
        b=HYgU/u/ZiKzBlEVw4IJdWvV/iwN25C2L9rSr2Bry8nAP+6bsFGSkKW3w26ZqORW2eR
         tAdbJ1bXN6k18mZbEoi7jNzjELxXXlnJIIXiTdiNMilZ2Lb5UXDCX56PWPPAgLzNA0cL
         u5i92AgHHnT+S7RZb6DnDq4kFz8s1hhvEaeQHiqWIrYLN048q5QivJry+Poki0R7SrNQ
         ffxvNhBww0eU4k9v7Rr/0K8tt0LfGacxggLcP8LdsTA0ME+45UJIkON0vDVgaW60GX/R
         SPeTbOdEEMrJF1R86iKGa9IJS2UAhJVBvHeXEoPId1XgKIRDM3cbounogmyXbVf68d2g
         SHwg==
X-Forwarded-Encrypted: i=1; AJvYcCUPSuePOh0V9mDA9VbpM+MkctuTQDMjTUwh5tXUbUBuQVbwF45n8BLSKYcLGLN0YeukSNNp1ZZA1A==@kvack.org
X-Gm-Message-State: AOJu0Yyt+eBlq73LkQ84dvEl8EIgiE++D3oOaoQ142tzYW9i1bgxJk9P
	BpsKbH6wsY5BJB+65xhyDMBzS36DMB2rYkgHUBKDWNTqe0elcS8XM3uFEpTWtyhXErjAYkQz0bw
	Z/b/jYXNq/26+m3R0uzDt2652QwlFL4EuUoDqJWKhuNo8WYXD6C8Acw==
X-Gm-Gg: ATEYQzx60zTD2F0YpFm+lHeWqiVAc48j1sS0awjAM70MPqQosj4Lkdw6DioORsuJ2IQ
	Ps73Bfig+cjTkd3G+tGoOfpQeI+4a3Cm1G4zRQwZmCYb0cAQsfZrguRwxKy6Sh0QUzhDHdN4FXn
	49amNVSR5X4YB73ZNpvdZtQ+yZhthD4eZ+VAujU+C2ZZU1Ihq7YfSZj2g3ypTcg+rn4tKch09Gl
	CI78Om6KWIYDtFt9IujZAWFCDENDyelp4UYs90uv1xMIpVxtWzk6n6AnbS1+uZCDIJa3ouTwV+C
	z8smHMf2DyNBMCGr9FFTIwkITyFG3Tsm7LDP234zNHYQsq12NM2Epc75VDVU+G58YecIOLFGVW2
	r3K8APUvaR+MaMyQNwygA1gs6WLvRAv/lL7VLiGAx+xEJHBjy
X-Received: by 2002:a05:6a00:1c85:b0:826:b70a:7350 with SMTP id d2e1a72fcca58-829f7240393mr123103b3a.52.1773174030020;
        Tue, 10 Mar 2026 13:20:30 -0700 (PDT)
X-Received: by 2002:a05:6a00:1c85:b0:826:b70a:7350 with SMTP id d2e1a72fcca58-829f7240393mr123063b3a.52.1773174029418;
        Tue, 10 Mar 2026 13:20:29 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-829f6dc2d0asm115262b3a.13.2026.03.10.13.20.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 13:20:29 -0700 (PDT)
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Date: Wed, 11 Mar 2026 01:46:01 +0530
Subject: [PATCH v2 17/25] sched/core: Annotate runqueues into meminspect
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260311-minidump-v2-v2-17-f91cedc6f99e@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773173756; l=1089;
 i=mukesh.ojha@oss.qualcomm.com; s=20250708; h=from:subject:message-id;
 bh=ZO7/bDryoGYv40z36iJsb1xhTIu6V9V40nzuQaYTMw4=;
 b=97ph7aGBo5DOsMrEvMbA9BDZtVSKSQVZcudPly6Z6cNUsdakmi1m/CNdYna9ssoZjW5hq3wnH
 06UefCLXjwxBLjVEa/zKZewRQLiHGj6hw5oxhvMiehOvkGLtM23NX1E
X-Developer-Key: i=mukesh.ojha@oss.qualcomm.com; a=ed25519;
 pk=eX8dr/7d4HJz/HEXZIpe3c+Ukopa/wZmxH+5YV3gdNc=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDE3NyBTYWx0ZWRfX6eTSaLR9E6Nh
 M1nqwtUPAJdC7OQ3Jo7joe5Xv6NdxGvvBSebcOgKR9dfW+cm1nzL+wsgBWOg6FBoaN1ld25iq+W
 wXokROx31IzaImeqVkz5ta5VdpzzrtglKP2wp8+P3n95S/oWnteYq+vhML6YxOX/t/zsAtpOhmk
 z3RjNnB/MPsmM5HBGouvNXKBrfO3umHJXheJQYYRJt7le5q2OpHvt7xN8IOwhVXiFjCp1KkOg+8
 6RPiS5CgMm67fl6rWTC3hCt64M3XjD5MvEt42rdMp3WbeNnjEJTIaL6NrpOB5X/0p+6A5lyP6J9
 PZj+d0z+BIbT4XSygfbcJ+G01Xo7ew8lJu2yXDw5m0yuuPKZw8GRC4MydWrVCy5CaSFeGX1M0w0
 v4QNHVjSl+xw7hVooShwpi/ndDfO0gLOGKukfk5oAmzAkZnoxt+1rXlYw8xRV5tAENjbw0OOUpt
 SxueeM4d0n+CfKYrmlg==
X-Authority-Analysis: v=2.4 cv=GtFPO01C c=1 sm=1 tr=0 ts=69b07d0f cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=WIgWxXLGzmshCHNC7soA:9 a=QEXdDO2ut3YA:10
 a=IoOABgeZipijB_acs4fv:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-ORIG-GUID: 5XayWDdK-ztxzTg2c6XbPO-NIT5LlWFg
X-Proofpoint-GUID: 5XayWDdK-ztxzTg2c6XbPO-NIT5LlWFg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_04,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 phishscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0
 spamscore=0 suspectscore=0 priorityscore=1501 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603100177
X-Rspam-User: 
X-Stat-Signature: 1z3u75rks76kn9oy1ypzspub4rcmn1ae
X-Rspamd-Queue-Id: 91D7A140009
X-Rspamd-Server: rspam03
X-HE-Tag: 1773174032-259018
X-HE-Meta: U2FsdGVkX18oO90YfhMipTWwlp//meumIqWC3yXDASshHXbBoTDQue2Nd/wITRqE8rqFr7TpFsJxdO28cshjKEaBb4bo3pnf5qHoq/XfahZXSOW0GPU9h3lRC/R9aj3u9GPHtRDSSR1oefDRFL7p5waJfeGyT8uZUT3YIJ9etfvBav6gQqALH6T8VhRN13glHsC4jv7Y7S+wfGbKvMOYvJvRrFgdMi9r8Y5rhD/1Z08qFhrVPuEKXf04Xa/Kyxa0EU+t2XA2M1m/Q0WHzIT5ewcq2VcZhP658382VaPcDVpHxItuHxmC92OqvbMd2hwlTaxtrPR+2KzN5WKaVvi9FUIPgQfKepkoaTWAtEvc6lOzqQ5qTz2su9RpP2xRiUEOMsQfP+9KFK3N0wfRif1LkmHi3E2cTIdRhQD0/I5BsLDt+ncUClW0HiMaWF8dyqLduLL0sBozRSLYjIdENdlKIcxRzsq9gtz6H9MIX9woYSqgGaQOuxd/XXBu1gDPj59vFEdy59BihDg2qEjw8hZlWPNvLpS4hU//NVjtopzUQjrPXD3GDwRzoXunBn3WEKvdT2rdTqrXnUX0N956dSw73whQu/FWpm3cPl42eRW6APsVxQvPbh7f0o23oVMH5bf/3Q1GpvG1kSV4XszSivJHPGdWVZl4W+2IOMSUJMcuFHBpw2J5mlrv5DfWNvRjQ6gENummlkSm9xAKb6V7I8YXTiBvekIJ7CHRzB5QdWDZ1SU0JtPcFgLjhpJhGPfXUKAwlw9dLshDOR0HizEjkqD08Mh85LgIVHnfL9J6izug6d/hwitKMytMboC4XxRZrW06OwKQeJLUgVk1sqAuPNkNBDE6taIPMUMwFmCtCOpuVWTfORYyDSbyy0ygwYGHbe2t5AKWsr1TTfz84GL/Ab9b5vOD3l1QrRIYqGsvVTEPOFRtwk0TQIvV3q7rIJO2dvbkpmceuF0HabVAT4ppIxZ
 /1R5oSsJ
 kP8ujU789ue+w/NqSF9JwMJxhcT3yrTlYyNMEm50vmUYtH81aBw+2HqJOOE7SPgcr7xSSKZvKo2Kn7lBTD6J4KKL7vtvhY5rvDaJl6SFles5D+yquQKQh9oVHOgzDFYpXcu1F6KL/JxasCrkPMiIElWFVK0o4kWCF2T/qtY/V0YGbvsUhR25edSmpIJ+zXR58Uw6HWcgVhNb/vPWrefsZ5Wf1GhOyQgLvQAdD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Eugen Hristev <eugen.hristev@linaro.org>

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
index 82afa387d529..09a532a5e9f7 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -69,6 +69,7 @@
 #include <linux/wait_api.h>
 #include <linux/workqueue_api.h>
 #include <linux/livepatch_sched.h>
+#include <linux/meminspect.h>
 
 #ifdef CONFIG_PREEMPT_DYNAMIC
 # ifdef CONFIG_GENERIC_IRQ_ENTRY
@@ -8804,6 +8805,7 @@ void __init sched_init(void)
 		rq->core_cookie = 0UL;
 #endif
 		zalloc_cpumask_var_node(&rq->scratch_mask, GFP_KERNEL, cpu_to_node(i));
+		meminspect_lock_register_va(rq, sizeof(*rq));
 	}
 
 	set_load_weight(&init_task, false);

-- 
2.50.1


