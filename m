Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DAFAFD4F33
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 20:17:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEC486B0089; Tue, 10 Mar 2026 16:17:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC8806B008C; Tue, 10 Mar 2026 16:17:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A76336B0092; Tue, 10 Mar 2026 16:17:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 95E7C6B0089
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 16:17:02 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4502213A6F3
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:17:02 +0000 (UTC)
X-FDA: 84531262284.20.55A07E0
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0D370100010
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:16:59 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=V+F18wF1;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=R4Qh+gqn;
	spf=pass (imf05.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773173820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BxwX2Y88T6y4LwZjHtHAx5HGwUr/pelc0DybJMU2hAI=;
	b=YoR0mDbwBXLsPRNRg/HlFR0ColCvIdwYLx8T/P3djlBOc89EiCr8Cruv6Ht18qUCDmpL6w
	F6S5YF3GHqo3i6A23bZFXUM7eZUqvpXJE/NMiuOuf0woCygLTzxi7fO/LXSvjJMzy06bGk
	FbUiPj8Zsovuv25bf/FqKTlHawyTvlw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=V+F18wF1;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=R4Qh+gqn;
	spf=pass (imf05.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773173820; a=rsa-sha256;
	cv=none;
	b=AU5pqZ19uq/wcwfma6IyiphpSUv2/F9TG9FQfJZ5VDy71jybl8IvFLlUxljaCE556p3EI6
	GN3U+LbBKqYjYsuPiu3qLRO9hS4r1GDb3BwYZYZjj9Qq1vHzGf3gJyeUkBjGbhLjRky+Ew
	KZ1BEEHhGoPrPF/Q38nuCBK8FWGiN7g=
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62AIZIWq3296707
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:16:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	BxwX2Y88T6y4LwZjHtHAx5HGwUr/pelc0DybJMU2hAI=; b=V+F18wF1TAP0Q2Ck
	lqU9astfKnwyjiOFMImTog9s0PfE+yGloq82sX9318GQImuTdNu1fKgoeC47LJSm
	3J6LDHLg8JyE5H6MefV5UKiJmlf2iLLqTySnJ93UwOwunil3J8r2Wy+wJkXD2RKv
	YSfbcuOWwGgv7Z9c3FLYBNpX5UL3JwKjRi7iRcb339jJaKB2ErSs/Zg1UMnUH0VW
	isatBrk6/GQGcMDr4479H0gbMtIw7/NIYmuqxcGiVKtd29dq6aBvSN/25HxDvRLr
	RC+X1AHmKE0fMXNPMr4b+/2ckH3EWIKdIyuY1/TWT2o904Mf//My74FF6m7YudWw
	b5YZow==
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ctg1mtp4t-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:16:58 +0000 (GMT)
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-829b20cc6faso159990b3a.1
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 13:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773173818; x=1773778618; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BxwX2Y88T6y4LwZjHtHAx5HGwUr/pelc0DybJMU2hAI=;
        b=R4Qh+gqn6RZbeDN+VOacXA3rN2SLdBEnA/JjJWTRs4zhI3v5uVXrBxWHBirlvFm1nh
         +ev4sIVrso9ZiVbryu83g9zEqweLPW4J1MDzE1P7dTPTB1uVZXCXwArDHTKispCVOjcc
         g4UWEJMy3d7zi/C/4swF7osgYph+dyoW0a39lb2BK9TS1/hYaEDG5dtSHZCZ0S2Bcd/i
         H7t9oVEZL4K02XQeQXadjXp448Uc91ZbByglSreLkohGSO8HgGoT5fISk+uEhcSJWWoH
         mdflDTpZFWvjik6Scgkgn39v8XnMlqggWOh6lh2/uh8psi+jkkAmVOYgXUzAB5NKVLlw
         d/yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773173818; x=1773778618;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BxwX2Y88T6y4LwZjHtHAx5HGwUr/pelc0DybJMU2hAI=;
        b=WW0QAXEOwb4Ue+h/jo0L8joZy59wJO5DXzqX//pF8HH4Nvh8NvYXlljWpKlkiA8xeL
         FqXXjzfSReWl9D/fu50wV9IqzZkOWuK70t90iYz3DaMckuSL68Dn9fHM6X86HaQmjjpn
         BHpRoQTdkw9q+LgD7kVtacz9Nq5dy5kVSWbqk3SROZfQWJ2uCqsAdqKG4OT788nlfLFx
         6Uni/wbLFRAM9AU6SKZWsGNXfFPMJNXS3d+0c9ED+0L60340nRUIXNY1Hh3qq84r4Maa
         wb7OOad6fz+rqsammCzYjtt7W5DiwLikI7S1c4tbEEVrojJhpfwjOXZx8n0P6FY7dODe
         ciHQ==
X-Forwarded-Encrypted: i=1; AJvYcCXgjJ4H02g8V3wpJVQcBd8vX7a+Vf9GpqIsBBXyP5jZiJYpFG1+H66ksq5AOmHvkSuDMyj+Pu+rPw==@kvack.org
X-Gm-Message-State: AOJu0YyNmexo0n9OvEKIiW/HvJFUIlL8gNutFFJQRv15pDqP/S+4uT2O
	Troxh91bpCDznfjGQdSKvPAcOsyupLsn2ZsHDYnXsbIB/lXNmkZ0N2AnQwxrS9SvObWq3NtGkNs
	3r7Q3GdMQClRwvzlZl2Fajc3OsW+oi4PgIRiC4tjXrSCUKvEPlZTAdQ==
X-Gm-Gg: ATEYQzwytreJazGXpHza2KsDj/uzOZhebl1fbJvR/UXcJxXn4Umx0RRXi32ObymFZaI
	9h0KX2bUb7sSSOtCzGZqnL8qdzkeIcTcgYXd3r1IvJXHh3ZuqtFdOYLtFVrdXwHUjYeDPuSMWE4
	aO+m/9FMVMsn00Zo+INBpQ1VkTEfnJYXHu2VgQNAoibY2QUBR3TtOERvtuVKb3nYWWkTdhwDE9q
	J030hlTU7oHfEaCo271jd6Bv/gNTm91rcTG07VJc9uSAO6g+PS53ypxP8OnlXMFMiXEH7Gdgy0w
	kZjDvpZqJP67IAV5irYp67TSq8LfDhIJNvUXGZ8OnQhfSok3tQNXRxSL9VJPPLBsx/miQ5twTcv
	M0Wc07TkQhVbxSZuRmGakgB7vR8u7qrORjE6nHXmwag3geXOa
X-Received: by 2002:a05:6a00:2d14:b0:7e8:3fcb:9b03 with SMTP id d2e1a72fcca58-829e4077415mr4216176b3a.25.1773173817683;
        Tue, 10 Mar 2026 13:16:57 -0700 (PDT)
X-Received: by 2002:a05:6a00:2d14:b0:7e8:3fcb:9b03 with SMTP id d2e1a72fcca58-829e4077415mr4216101b3a.25.1773173817046;
        Tue, 10 Mar 2026 13:16:57 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-829f6dc2d0asm115262b3a.13.2026.03.10.13.16.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 13:16:56 -0700 (PDT)
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Date: Wed, 11 Mar 2026 01:45:47 +0530
Subject: [PATCH v2 03/25] mm/percpu: Annotate static information into
 meminspect
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260311-minidump-v2-v2-3-f91cedc6f99e@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773173756; l=895;
 i=mukesh.ojha@oss.qualcomm.com; s=20250708; h=from:subject:message-id;
 bh=+tGlmFyqBcoz7Ktr3AUpoQMVM4JnoUBVi4FO5/qneMM=;
 b=NvchOxzzO5I0OEPe3SoUqnDWDl/QAp23qS+G7CfJ1IKH1kWlIdZBO3QW8taGx6ZIGgP28DMU5
 qvn4YwBoiI/BuGfOm2ndKfDymQC5gVBdcKxJtVxj6fAwtL9RVgACP1C
X-Developer-Key: i=mukesh.ojha@oss.qualcomm.com; a=ed25519;
 pk=eX8dr/7d4HJz/HEXZIpe3c+Ukopa/wZmxH+5YV3gdNc=
X-Authority-Analysis: v=2.4 cv=YOeSCBGx c=1 sm=1 tr=0 ts=69b07c3b cx=c_pps
 a=rEQLjTOiSrHUhVqRoksmgQ==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=H2ztsr5sKx9LglhVgPEA:9 a=QEXdDO2ut3YA:10
 a=2VI0MkxyNR6bbpdq8BZq:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-ORIG-GUID: YMXU089HhlvWKoFyQCTC_kXPM0TZpF0x
X-Proofpoint-GUID: YMXU089HhlvWKoFyQCTC_kXPM0TZpF0x
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDE3NiBTYWx0ZWRfXwnhb81F2wntz
 xKIJTpWF96qpYFCXu1o2ay+HMMoQfwYr19ZzwsGaUjmVP/aqznI+kgBUW+zohq3oWXMeuvxfd33
 C245ahve10fxi+OuCkEF6smzq/LLeId1nOs3eRYtxiNtvtT7cKxQpOATBNHQHtzcuI31FfTWjpA
 ppOr6UG/P4Eek3F4AGdzqpgX/m/KvmZcQCu0qHWbNPut0Cq3jafaO/ysnag+qONODFqctYOzLp8
 722Gg8r1UtftKNfE7Dcz89Lc0YC7QSHlF8GZgFJlsv3HCoDzQeKRYpTy9A/LgzPGEiWE/8wYwP8
 t375UFKGgCjei1iYdD0QP0gg/Mr51lDpjVsG0Y9OcQy2onvDvBP/VXmF50MnK47GCelfefpb2k2
 7owV8/Q9nzkiJhG1zgNwfN3iZ/AiOsrQg1PsnorlBY6wgvzXwCYeOaMpW1REHhn2rXbDvEQ3EDJ
 bqSPKzdpF4hgubBlDnw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_04,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1011 spamscore=0 bulkscore=0 suspectscore=0
 priorityscore=1501 malwarescore=0 phishscore=0 adultscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2603100176
X-Rspamd-Queue-Id: 0D370100010
X-Rspamd-Server: rspam07
X-Stat-Signature: orwkaw89dym7rrdre113jigaztghe1dd
X-Rspam-User: 
X-HE-Tag: 1773173819-39146
X-HE-Meta: U2FsdGVkX18s7O+o+p/3IwArQ1VQ8OnvfEi9B8PXYsx0mtCjaR5ZIHFSYB+RMnLckrzi6+4w43C5luRaCS43zVjlGSC4CPbC/cMNDncad4xfC1YpBwWxcaGutM5GsrOx8zX1WpZzvjFXiFQvFjJDbDSvZKXwThReSYPXR1WR4CnqOCsFSlV7lwT2JDoM8auvN2oY3w+COQ7bXZLS5ENFz6yrzf6skhHcLKpofriLmasXBO8MSZk7HO9PNbXb2iC2o85OLy59+bIcAe32R7uI74XvNzQ9lyRAI9ppo5zvRXNwmOTU4KCkgzAY4c2TEMh22n/gs/Ej949aQIZIx/+t0Fane/YgECmqmvj/En9wmg7L8NzDquAz23pw7tV8/8hXcx3ilNOp9EAMQ1AScMrmn9PcTBOoP2DBFhPW3nXzd4PDshAem/tTPmYufSiO8Y1nptgBnr4wu/Q+RabzGXN1/JOmgSNsHNYfnzzF9ZlKqCauhiYmtXc6VWTUkZt/jnQYdK56HjzMNGcZ0PrnO5WHIYL0+FJ0sx/ZEyeNLIUx6aFtNR5PVXFurc48dPsDFvUmFndsKI6GhY8mu1sxaz63RMcUJH2M5FlbfLQJH7mQZNKiLWy2k84lnYLftydxSACIw6aG7tmHzWYWz3o/pSjxhSTgwjqyzltf8yLwphVeD4UYN6vj/QfesrQWWIiVfp3xkvg15r1bFiFPn4vTbWB8+vvKACsDKj10M6/bGxe5Oox9MJZTX0PQHEjj+OJIUZ8y9Wi124YNdy2WKqSgFopYhF/KpkNi1CnDZcm0cuiu0huAUwj1Uy/p7+5dZ7IPmlm9SlRvOPwFmO43wIjYmzdgLNDrEeY/YdjYK80YPeiXSHsvNYwLEWlIE1zuScithzojL0r19+SbU1FQRTSj/MzRELmBf0htfABaGnIpUe/iqcU31+SQw8fULH+rx1drph6N19TMfl5vNDUi6L88RgY
 8YLRsGxy
 xGt6u2D4EJ5jX1Z+Tct3YJD39BB4zMiu+V9DSGxqI8f3Ohn0+Bb53c0bupAkpv+xk+csDcgktgItIywkPoUkQLdBYf6Qe+mHySabfbaQnsrn8FekzHnRF5rBxvHZ0anOCgLKQSt3OTkTPdWdgLwj21YntALAqMb3nbq89y7Tpd1J2WRzfpDUZDCBZ9KrSgA6hrltwuTS/XS0mZQ0GaxSmkvbOPhMi/ajketYF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Eugen Hristev <eugen.hristev@linaro.org>

Annotate vital static information in meminspect:
 - __per_cpu_offset

Information on these annotated variables is stored in a dedicated
meminspect section.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
---
 mm/percpu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/percpu.c b/mm/percpu.c
index b0676b8054ed..d4209bdfbef5 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -87,6 +87,7 @@
 #include <linux/sched.h>
 #include <linux/sched/mm.h>
 #include <linux/memcontrol.h>
+#include <linux/meminspect.h>
 
 #include <asm/cacheflush.h>
 #include <asm/sections.h>
@@ -3359,6 +3360,7 @@ void __init setup_per_cpu_areas(void)
 
 #endif	/* CONFIG_SMP */
 
+MEMINSPECT_SIMPLE_ENTRY(__per_cpu_offset);
 /*
  * pcpu_nr_pages - calculate total number of populated backing pages
  *

-- 
2.50.1


