Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA191FD4F2A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 20:18:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 122CE6B00A3; Tue, 10 Mar 2026 16:18:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EB026B00A5; Tue, 10 Mar 2026 16:18:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF1596B00A6; Tue, 10 Mar 2026 16:18:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DF0F66B00A3
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 16:18:33 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ADD1014032B
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:18:33 +0000 (UTC)
X-FDA: 84531266106.20.4C1C29F
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1D85080003
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:18:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=AnrC4NkB;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=ik5ihSBC;
	spf=pass (imf02.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773173911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xUalwRtla+ayp0MJOatYREBpi53Z8RFSi3SjDfIMcEA=;
	b=4rHk7fpDo2SIBvjtBQPGQEajiAhM2B4TARqQo79CSoenfNP7YjTyQTyXG8qIAiWn+CiIM4
	HXbFPTbseKV/2S20Up9dIuAkHbUJVG2d0NpvmFT7RNoljHxpJtf71U8YsompDCvPl3OZS3
	n3SkYyYnqapD7jVaqKslwD6R97YfebM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=AnrC4NkB;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=ik5ihSBC;
	spf=pass (imf02.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773173911; a=rsa-sha256;
	cv=none;
	b=cqxAY8s0YjP965yanaf/KUk6ZyLDKdopN8gSzvqYWcaJIN41jRXDMQnMp9ePZx/R+nAvFt
	X/Xn0sea4cWxLOF+nwUqxa7SbCTnRNky2sHDYg9GNQj1/QzIpZwvM3hHL2Wb9COEWrVEm0
	IBzhKMQsKmqD98NuTq3V7uhC9ejmti0=
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62AIekDX3893219
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:18:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	xUalwRtla+ayp0MJOatYREBpi53Z8RFSi3SjDfIMcEA=; b=AnrC4NkBToNr65+G
	AeOELDrpl9XgKlIS8M/AtttB4QyAglvTb6SQxjBuNnsCiDxLCeSoU5WmEqxThd3n
	q1r7NaFq7tri0wHflV+Z3u1FJeS4NCUh+YoW29ccfw+azNMLfQsyntExTh9g0eM/
	OK65QDkAjslsNMXN0BZIg5Zs35L3NZGED64QqDWnvxaOkQbYFjYXtz/2YHDRZZ4x
	d/i6zaSKGtTvF74k4p0sDUwgSutpk1nIU+WC11pYUqWQKNQWVXSoRlKiNN3DpcMs
	OyewJGRmFq0SSbpreUfhULNlhtKqRVRBf7e0xiXv8vwnmwA8wH/1n+oQZ2VCsAGO
	B+jY/Q==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ctkmyst57-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:18:29 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-8297d2c1e64so2200856b3a.2
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 13:18:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773173909; x=1773778709; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xUalwRtla+ayp0MJOatYREBpi53Z8RFSi3SjDfIMcEA=;
        b=ik5ihSBC1Q4KWjBa6IJWTs0R0l4BUFkHw7t2P4Te+YV2q1aeMxHnSRnmv0mLvunBf0
         li8Zhy8U+x6Dz9CBrDk0CaXLhtI1FuWcJeVcJucai1U2BNRJ1LYow625ijafz7xgG0tC
         2GPBcuue5qMO1+ObhTe2X/oQCeM8hUChB8ukcAwQ2RMXslMHAPl5JHcj+e0Zl0txNicJ
         6IlFZsp03RIAmw3EbxGI1jP5ylR7HB/BQwfXdM1KAiShdL6mva9Y67WPe/X2lJN48eZh
         V74T5u6ZQtGOMzPm2n4/naPYbuRFNhEwLFVI4kidZup0KhkrTeSg36RNnDU/jE41nDlR
         K1tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773173909; x=1773778709;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xUalwRtla+ayp0MJOatYREBpi53Z8RFSi3SjDfIMcEA=;
        b=iC9WZ+oJJgy2CUtMORYUkJOTBLeRXGnpNzvIqAzi1tNNMrl8qdIF5+XXhZcm5G/IU2
         3TfgViXaCrawcEU0Y5zQl+PrD8GHGjPWEsMS7ZQCAKMcwqdaN55DWZRjukn9Zo23ZWNQ
         acOJ4VypZZyDDwKCZsDvV3pe7+zhZ3MMYMw1d0c9FH3K92ipxBjHgjDfxOc2Yq2kSX4J
         5wvdymXNmU7IYhOzcM2Ul0mMRuXulWHiHiRcn9U/JRZQH+ARYpqrmDi03cDuzScq0BDI
         M7sZmigYbIYwo88U8z1oXNv00CkZ5+vYGHi2WQ8LoO1HKCMb7vKdg7QB5/HiWwi5YGXl
         HtoA==
X-Forwarded-Encrypted: i=1; AJvYcCV4JFcMBvCToIUg1ca8QCG9S7b9lA0HSTPYkM+9Ov3+c6BYBL05stvAlXGdMx56BFL/JOYV64513A==@kvack.org
X-Gm-Message-State: AOJu0Yx0MKencec6ZyzhbIbuswWu8TuUmEOz1hy6FXmP57Em5tiKLtdv
	DgwyB3E+NECkrBxH6dMArkV2a1MEWxTxHgHUp6ZTM1ecUBBldHCErdJw0UEl3uhSG69m9Z6ndLO
	v2QuoWTxnHGLcRiWR8ggsHLGiWgD/CbrLLlXCMgnCE7wyhQe5jzzTvA==
X-Gm-Gg: ATEYQzwS+HUpQGNpmf1lKPSGnukTTG7q8r2cPZ45dXD/TB1ziS6nzcECcQBgU1uqh2J
	AS/l6/7IiieUtlO4uFReMbIaQD5eDOYvzTLRZTSzK98nXi4fK3xR/rqb7OG1G5tFNSjG/qoGXr+
	7Vj6j95U0IL/yfAcvPSeAYlYxf9PQ8reaX+YgHOubUXlw+QiWhsVtSN54+NRq76xtztJ6O7RazQ
	4eJwBuTinRD57qLJiCA0vGAq0NCjxKoApP0ArDRR5Gk9t/z5HaQKjlgzrQX+5HltcubTZd8RAUF
	t+glyfoQSWIL7p32IAFa2YMhVd4kc9Qgsr5Jso7JItRZyrWi0UrzH4FFqGcL4m7cNORew2KMDUV
	n1WG8/i+bWRIAkrosI64ajS1UfWkAVK9v6dSSaIOo8BL/i0m5
X-Received: by 2002:a05:6a00:1c9e:b0:829:88e7:c89e with SMTP id d2e1a72fcca58-829f6ee65abmr187991b3a.9.1773173908901;
        Tue, 10 Mar 2026 13:18:28 -0700 (PDT)
X-Received: by 2002:a05:6a00:1c9e:b0:829:88e7:c89e with SMTP id d2e1a72fcca58-829f6ee65abmr187951b3a.9.1773173908318;
        Tue, 10 Mar 2026 13:18:28 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-829f6dc2d0asm115262b3a.13.2026.03.10.13.18.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 13:18:28 -0700 (PDT)
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Date: Wed, 11 Mar 2026 01:45:53 +0530
Subject: [PATCH v2 09/25] mm/show_mem: Annotate static information into
 meminspect
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260311-minidump-v2-v2-9-f91cedc6f99e@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773173756; l=896;
 i=mukesh.ojha@oss.qualcomm.com; s=20250708; h=from:subject:message-id;
 bh=hnWgTs3BqNwkuy01WGRtLHEmLnAWVLqGtO9y7HspcnE=;
 b=uLHZ20TEam9IFeoPaxYKND50xjzJmo8/66x/toJROlPuRsGnYldJCrFNEUSo9htPmJgsz83XB
 h1nzBbPPYs9BIy9KMclSQJQfzgEIMyig5knFQTbc87F6JhGMpL4Ps/A
X-Developer-Key: i=mukesh.ojha@oss.qualcomm.com; a=ed25519;
 pk=eX8dr/7d4HJz/HEXZIpe3c+Ukopa/wZmxH+5YV3gdNc=
X-Authority-Analysis: v=2.4 cv=RYudyltv c=1 sm=1 tr=0 ts=69b07c95 cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=Ayq6lH46roXo9nsmW_UA:9 a=QEXdDO2ut3YA:10
 a=OpyuDcXvxspvyRM73sMx:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-GUID: bnDtB7HjvVcbfBDAiR28UzZpRJKy3xp0
X-Proofpoint-ORIG-GUID: bnDtB7HjvVcbfBDAiR28UzZpRJKy3xp0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDE3NyBTYWx0ZWRfXyQimHm5/KDgJ
 YzCET+JtoFIcK+uAnMNHHTiWsPJQHBLgplU+hucY5zHQ1hueRBLiIv1iZe+jsRGbHWwJbOjsopF
 XkOrKhYJQLyDNtdRdsXGK3d3K7vCocsCwQAD6mJ8u1tTOoegcyxUbhj8B4b2RW6dvBKTlS2GKJe
 o3RP0MqxuikZOaIsh96ijyd4HMHQIEzgzAAyz5NX6+EsamAk5HpbalY5H2pqpSN+OsBitln+HDP
 OTT4k67LyikQv/aXV4svEsrolsC73/uZJo8ggOgcMjMD4qbW3nXxXxZQQYTclAJSD5XAqFKibm6
 KRJD+1YOgEk2qqZFgZUWTyaeEyfgSZmjwFXXbsVJW8SubNEW94GIMgtkJH/2nui5xbs/w3O36jA
 iqsR2a0YmQrQnAvXjUqvuAxjvVeeC7HSbnDEqspoGYt3jlbDzbwCyuwdROTDB/xb9wjcV3bgaAV
 IwWSid/yVJ0ASLaH5HQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_04,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 impostorscore=0 malwarescore=0 spamscore=0
 phishscore=0 lowpriorityscore=0 clxscore=1011 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603100177
X-Rspamd-Queue-Id: 1D85080003
X-Stat-Signature: oesrdt4r876az9fs1beatgjdpdaf1mxf
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773173910-940128
X-HE-Meta: U2FsdGVkX1/QAi4hXhjZ8S0UdmYArsF8BgyQUh4LpL5UuS7a46Uml49kvgE67XWQKlYNp3oPXVi/NKANVYsbYBR1g4Dhqq5xE/4uuXr5swvOZ1mFTMqC6a+Zm+2L6KAJfVWoGHNdJiQ8A482j0heTUUTk/BcUQnu1ZjkP0VNAOJyklGnbDJEDv64hZken3G/Y9NoynyGROxke7s0357TFhB3fL6FDFJ9D6ljJzEKGVdAYrxENloJ16+1p1sPknlnCM5A5PxAJShMAwV9D8wPnVNHqx+eXDVRDNaAI54x02H8OmAwzp09Uhvtk5BnkmRIhWf1cIeAcjXbMS2NEsQ++QpYRrYM3e3LBV47rJEkozuPklxCH+TE3Vf5j+SFmdBPBSLDqNi+I9dNRGw5Y6IE0cs4A5HIgXsn/toXs9Ft0+oQyIGHv9tggeanH4OqLLjGuhchOi+S2KRnJq/qiLz1rQNlCbdZnH3JWxeuEcgEwZYt6UBA5soVYoXULR16zo9+T+kuN943nEIMiZP875BoTiPWI5KXLaQjmgNTQrlC9MUmGqb+3z5K07epxedyxd2yg9HI/XVuZJ9MAz3ZBrZbqhQM7q+yvqN0Amaz04zCU/URmFRGeAMeG7NoJE7+VxWBOTqTFeBDdsvoBFXsoCfe4XjmhX0/xziGneuULKM3fIFifv170fw+WxtkaTOyb0W/UfD6dP4axis4Jr+gASJSeDOJky30SRuUVViPy6wB4L5Jz15rB5tUg4L2aftpOnfZyhamaOx7nIpSZ4HQlsUuAmDFwlTO/oWKkONEE8ibyHJ9LOMtMP00qxtY9d9Wj0wRsGNHOccBrvfj/VntosLRWiPptViyQaA7hnMcYFI2CEePaUjasPhat0yYLbSP08Gfs7HpkcfVsiOeWNtdfX6blX942XvEOd75uJV2Gstb6lYv/nKPOFOIJoXv/ZL+9UENIXaBRIXxnz60bzFYqOb
 H3iOS1/K
 dHbi8fBTGLXEjtH4ZDxvKN6Z9PpLb6jSkNdQJJs4eJH005YWqvX7ET1UhmFmMKOyvKvzkcIU2AcFn3cT1U2dLxIMxLPYJWo7mmZFyt5d8jjDDfWYnhY7ySy0cdz60VXqYQYnuVoI/Lc8oxxRHkDNWXA7hi/agFr0M7HUxUv98UOCDVaJcxVRHMtHs8MyFvRwAjg6LRj/XJlPTFKcMdzjaakMzBgRRNZuJuuumk844CPHQuMsnGkY6sHdQpi/ylTq2Wwdm8sNhN8WjzhZg5IyMPX6fAvpFFA1++P4aine9AxmzxFKSn/NIvnYBz1yM1HOtbNpWEyKKVCaSvz41rJ78/rpw0BFY+3rbRaF40BOIvIk3o07nLNFXyGPWuWx7PeYhk/xiGizxt+Cc+FBA1gWmQtrsXjB9Y7T6xpIiG6dxNj50EpiXXai2wv9+2K3mEWToOJQh8CjQFZt5BQ97o1Y54b3rsVO6qGltM7XnO1shRb9Nwm9MSeNzBFAPMwv42+7eTRd6N/PbrdHYVTTkZHwVtqb4VuK1/zQRCBotLjfmvL4cn+ns0FGo1J796q3ZXtlXj1AT0pORpotLAql7Pr7XvymejzYNu17p01wJbXo9F7N2SxPdydKzoBGH1zC5CpqgANbYxl23szbAHRnBN536xfqteps5YuISrfNnv7Xfk8bQpDPee827nsM42XN1xLQot2mCUCcsHZjzHns=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Eugen Hristev <eugen.hristev@linaro.org>

Annotate vital static information into inspection table:
 - _totalram_pages

Information on these variables is stored in a dedicated meminspect
section.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
---
 mm/show_mem.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/show_mem.c b/mm/show_mem.c
index d7d1b6cd6442..f6a92c7d9d1d 100644
--- a/mm/show_mem.c
+++ b/mm/show_mem.c
@@ -15,12 +15,14 @@
 #include <linux/mmzone_lock.h>
 #include <linux/swap.h>
 #include <linux/vmstat.h>
+#include <linux/meminspect.h>
 
 #include "internal.h"
 #include "swap.h"
 
 atomic_long_t _totalram_pages __read_mostly;
 EXPORT_SYMBOL(_totalram_pages);
+MEMINSPECT_SIMPLE_ENTRY(_totalram_pages);
 unsigned long totalreserve_pages __read_mostly;
 unsigned long totalcma_pages __read_mostly;
 

-- 
2.50.1


