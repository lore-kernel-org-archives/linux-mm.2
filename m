Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE9BCFD4F33
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 20:19:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0070C6B00AB; Tue, 10 Mar 2026 16:19:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F29346B00AD; Tue, 10 Mar 2026 16:19:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE93D6B00AE; Tue, 10 Mar 2026 16:19:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CB36F6B00AB
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 16:19:34 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 65509B812B
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:19:34 +0000 (UTC)
X-FDA: 84531268668.05.4F08937
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id E941C80010
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:19:31 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=lpukSPyA;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=Yj5fvk5c;
	spf=pass (imf02.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773173972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o14Z2a6/l2NPuJTTgYLWWvyApkp7bYXMngm3IoV823k=;
	b=zq1CuY171mstafBBEorchDr7AwtCOk05zxED6MBhQtilZCdbIUntVQ+A5IGgq0H3vOu0mo
	+OXcLS5AS04pDSFdvOejGLXWzKcM3ARKoAdacBzl9p5v4dGZNSKEPlv97tQFdjfimBAH/n
	S+PuxpznP9RP4Maq8U2r/ton81Yg8eE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=lpukSPyA;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=Yj5fvk5c;
	spf=pass (imf02.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773173972; a=rsa-sha256;
	cv=none;
	b=Iq5qem46dDOZ30x2bI23m6Y3cYhnsCEmdhe8zOQIl8SZ2XKM+tycLQFkmYUEcvc/fiz5JW
	dBGMEok+OATqGj1FSEVbaLbiO1owKVqZWCvxZtJzsy9livVutWL2jGzFLdR5AHrCyjhxlu
	oBabo2PfnOd++x9ijsIU2tXab2EET7A=
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62AGGtqh508287
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:19:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	o14Z2a6/l2NPuJTTgYLWWvyApkp7bYXMngm3IoV823k=; b=lpukSPyA3VeEnHyR
	NLJSoEqP4ax8Yy2GOodPU4MzO3kLLtNTNCVaqaajOgmUE5ZC1WAur70H7NsehL4E
	GtQ9HNrCOhegZZFynzYM6fnATHBTeZ3o+wH/Yq7J3k9EVPuVbRRiMMPsDcwFHuHr
	XOcT39XRmjb3bwN52r+AnJZD5kU118bZa73vAx3Yv5QoYGmGpkvts05pinATjuhV
	wSf0t5jNLICVa69+TV4FioHsK/egPTVNgWdbu2uEL86s5BWsNV2aJzVTNYENoA1W
	qnHbsscQCwJAEsPoPKAyDgJSgJIn5hOHgQes0gIOMWxoxEEMxkkHZcjGIW7N84/u
	tMOAvA==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ctppagws4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:19:31 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c738b1f630eso21068595a12.2
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 13:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773173970; x=1773778770; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o14Z2a6/l2NPuJTTgYLWWvyApkp7bYXMngm3IoV823k=;
        b=Yj5fvk5cF9R1y/HRWoQ+Gj9KmQlf7NyHkjHsxdS+1WB9FyS6i3za1nv7AdcNNUEgx6
         i6o+hRlxDaGK/hwYNrbvpNYLqsgFiv4DVJ8nxFrJoGowfXeQoF3zlgPQiQweeD2K+77L
         esKCBz837Y0GMrsD8ppVx8nPsccjybZSMNXvdfP9KFIfF3hDjGV7f4lKvLb2UngCS07n
         qIVYneIEZK0g/N11seplMZd+qs9hi88j0yJZtVa8hnFnO+jFBCElXO5YS0GDOujbrmig
         H8LxcBxZfN5fhZsHMOmGeQ0sPS/IVa/AI0rSPSstZnIIy8mF+4hhJwNT/Jm3iDKkRnRa
         K6JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773173970; x=1773778770;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=o14Z2a6/l2NPuJTTgYLWWvyApkp7bYXMngm3IoV823k=;
        b=MkS2OpAtrovHZ25CRSnIfqQsda8LiKXCbDrUNSTuiOTfdbTC3Tyd/O7WtJ3+UrYzlU
         l6LrBQiy6jahFhxE4Wc9v4uaKVDcqjl15CEWgjnu4QpNK9cY0ewg5pndfgRxrqWTr3XD
         5bRvbe/5H4ubvM4n0lvb53ml+msuPQZrRYwJs5aXNWhtbeo239WFJ1gcP9JRrpfPcXJD
         6cPzI3kkd9LspdvjWEhd/He+IVxJqqj28TSYpYG54mFVockm2TjEMjnC5juwIOGJ52kV
         PdJbEkqUEnl3h6Hx0Trdy5/EggcMqYVsX/m2oP78+UHH4p7wcqoKE0ypmAP2E0Jk6KR/
         wBZA==
X-Forwarded-Encrypted: i=1; AJvYcCXrgcC2MyF8Zq0pgJ82laSkBoZF810URG1UnPPPHV0+clKBKD5kloihqBYgFItDSQSLRJx3J68hIA==@kvack.org
X-Gm-Message-State: AOJu0YzwH3t3E7sSui8MGcbsy9ahZMkO/0gR0qqAH7iu6aSwrbfxXTPJ
	5Z7hPA2gQrzgs8Ljm5ovLV9T7NU3dFbjUmn+4S/VUsNjx/+3gwa73mLHWCDeaGiCG4K8TUW7FWI
	9a3n0VXlSufC6bgpSP8lkJ48v9sCrKo/YHvMCXWaCmeRBYgsWFGLvkA==
X-Gm-Gg: ATEYQzxQoxIoU/AKpgmTIOvIIaL93rkUN9WnNxcqrGm0F1vYMFr9RlJcAv2DDlF9nwm
	sQHBpDvzFD/HXoU9ZL3JmcEkRyCQ2ncmN5VgGWXwg0uNCCkBboYlSt/WyMYHFvSnkf2dzeMZ8Ff
	+jUFsBgmSqPkN9/pI9/ljsnAMoGAu+H6L1Z0xj1JCtMNzb3Zkm+RF3mdPNLCDfRh+7FG55zFbYd
	rTP7FlrQBem/EtANdmrw8/xBTrwXXSOtujZKT+7cbN5EGXidFazVi+dRzD1mF/l2UJBogW9rGYH
	ob0S+CZw2VkUIMw+vnz38orNa9alax5CX4yjHW9veptkR9nncOmkBR9HQxvderQFvB2JB47SH9I
	G9YDk4oW2iuJldBtCnUBOdenjayxL52XkFVMTB9ansC+MSnA8
X-Received: by 2002:a05:6a00:94d2:b0:827:4372:dd15 with SMTP id d2e1a72fcca58-829f710801fmr145172b3a.40.1773173969636;
        Tue, 10 Mar 2026 13:19:29 -0700 (PDT)
X-Received: by 2002:a05:6a00:94d2:b0:827:4372:dd15 with SMTP id d2e1a72fcca58-829f710801fmr145089b3a.40.1773173968931;
        Tue, 10 Mar 2026 13:19:28 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-829f6dc2d0asm115262b3a.13.2026.03.10.13.19.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 13:19:28 -0700 (PDT)
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Date: Wed, 11 Mar 2026 01:45:57 +0530
Subject: [PATCH v2 13/25] mm/init-mm: Annotate static information into
 meminspect
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260311-minidump-v2-v2-13-f91cedc6f99e@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773173756; l=1598;
 i=mukesh.ojha@oss.qualcomm.com; s=20250708; h=from:subject:message-id;
 bh=5nQ0p9n3c31Q2RIq4yMUZPGaE3IA3pjushf8tYEqgcs=;
 b=t7nzKjfrKipDpTwS4ZqlI9VkibqL8C9dDspYDVaOjrd+X4QGwj5GMAm1C9hhwSvzQOmAs+88P
 roE/qXbWEnYD4lhp8Gct4DRbuiio0CZSZC02jdz7e/q3zVjh3RXgYE2
X-Developer-Key: i=mukesh.ojha@oss.qualcomm.com; a=ed25519;
 pk=eX8dr/7d4HJz/HEXZIpe3c+Ukopa/wZmxH+5YV3gdNc=
X-Proofpoint-GUID: f7co-8jSS6FRPBbIplj0HdsyqvV9fJha
X-Authority-Analysis: v=2.4 cv=D7BK6/Rj c=1 sm=1 tr=0 ts=69b07cd3 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=HJIP93yTpLwjP442z3MA:9 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDE3NyBTYWx0ZWRfX+iKGjplma5qV
 YHtEyNNVW1CUe7ycKmnzaXlR9kP/0Y9pZqD3jbSp8IKzo7oVHT1Smbv3bxz4qiLyADlH9yp+YJ5
 /8RB+IP+LQ5nCALLBH/aoMp7I225RJFcFMvuwehNCc1DdHsL+YKzbn9iJYf/jhNWs88GSe6nEtx
 0gvHUOgyouHBtwid/QUjy4jSdk4u5eJUNVA6PMu6MNV5N6hzwGXa+MUBck6woKKotgyBEJzYM4A
 pgNB5VNBhqyXgWm3Rj4SFpolg6KhRtv8tYvRaKby+0XmYqrm5OYRlnLtFsgv5yPBpTm0nrcDSzU
 PP25tQhshHyx6OIiRpsFqp3orEIPPGhzZxnRqfm8PW0tabI6xgMGgVx3MMEqj4cwM/qmnRzRnzO
 6/n6PKA3tcdx4WWXRCa3/UqwK2v/GQmK6czZdchR7ExWQ88T7k1KHWFgs3LKj6oqHNQDIUlC0Vr
 0S6fQSeBqMN5V/kUbbg==
X-Proofpoint-ORIG-GUID: f7co-8jSS6FRPBbIplj0HdsyqvV9fJha
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_04,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 impostorscore=0 spamscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 clxscore=1015 adultscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2603100177
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E941C80010
X-Stat-Signature: ejykbf53s9n9h599cmmy9ougj9shaopw
X-Rspam-User: 
X-HE-Tag: 1773173971-163701
X-HE-Meta: U2FsdGVkX1+jFJtD0L+eqKEBT96CopHBmvCv9R4EnDO1MbvPxjkByJk6RBPoFFq3F7zKSL7MxOW1/Ld2eQUyoOuSj4sRb9rBsw5cbFrYLy8LV+Dn3pmRhIXFzUDN1nPLe7oSSrNvs0kJZFepsRDFzouhHijI3VFMgzeLoR3bQsI5xKhxPkWPs4lT0tCqt6rpKBmMpmM2Zz1dIkz4hEzIgjfGHbQJyOplDwroqdatxN9m6wj6LkCH7cOJjz5r0EETvhTXE6Cj1uueCp4h9M9xqSq7z/vg7L9tmFxN+V8QnDBaJKTfLGdyro/OLs7SJGwEDqBhx85DgiaXkvIBQYKq0pRQkwtLaktkeeozK0DG01VuOZ0c8dnxB1tUIHY23xUw7psps+1KiD19H8oewBOIM8YjAiAbAdt2qmb08TeOYd6IgvISTuh7PfdQ6uHUG+KReDR+jrz0vc60x2DRskmpBISZ3Wkq3bH/2Eq0Duz9cu9fuzIbz/sMExG+76oEfrrJS39ObyNs8r9XRPrK+bb4HUFQI5vbMQ7KCexCvnjS1iEyc47i6kQwAzxFuLHP29rXe0TSvTmbmT8RrAfus/7K3ppKgsnubiGs/RrCEYLlXUFoPmcmud027EgsOw3c/z3NrPISyslB5HRiTkPl3FosA3uMA5eiF59LYbMOUXsqUtfwFYdl4+e6/HA3XSlpj+iTzwja4N7vGCatSX1XKnvKkQPHhvYYxahzjWSyQJK3VtdcLNbN3CJMdzZGoOBFzn7H1HG1TOqfBN6dyq8lESn2j9dJ6zyUeWcqNs3njTMGQOGRZbHWMReldUC1P/uSKTQrlqtir8U4iHoGxcdQEM7j01ZaMA3nxK46P1wMEj+uBU6IZJw/JiJaJxP5YUZpTGDvvWKO1kbJs0nuKrIPbnkrFBFlJyMK9yiWD5gGLw/l7MLNPOFf+7TPLr911bUWMAxenNRx46QdBrWpbaLAhe9
 y4AfVfdf
 WKUhczFx7NH83iJa9oEz0EQglPUSrqMK0j+yHK+VxZCTsYSrGIl5mw3IkyoOLvGLz8Jz7WyZ3NWRuw9dVOyjmvSm6iO0saa8Q2TE3BY/vLbvomIt436gguPaQ+Nnw5Wx7zlWdr2HEBYyi+dJA7IBDr4BSIC1tFGuDJXtpNvT+8Ojja7r8ZIkFu7IjlRusp2o6zvjbqktHB/DSO/t2f6jeQPZG6nRJoImyeHxBLXLTYWPYt5A4q61OKEak16uiNs5Cz6FaiKtcOHQVH2E3b0kQjePl9XUzsHSXSgwakZdGmDHoenKJS6E95fFhmtzaofRCcfu/ALTuSTsrlZ+n6WfbLtNT3oa83iBzxTS5AjQcfb8jMKHpvGF6Ifr3Ei3Suw89RkLv+cm9dH/vAQ86mnT8i33fBYlG8LvMulrs3sZZp7hrBFvEPnN4zsNK1VCWf21mmuCcAKkQzFpe1rMQzWVjeWzmIeQtvK9dEUhpbTptH7sVnwSArxcZYf1Pj0dEZA+5eBgwVsK1vcEpjzibL/eMJQzV5FxDvCPIigeNvv+OCzgTXNgOx23c+Ms+tKC+F8GoUD0W/V9QIi54mnT+KzaBwtBBy31ne5Qt2v8BCvNrphIHUfVG9zlEUUHkWNj1HusjiF1r994aExMH6o7z0/GqHF7lJmSlHAElrITi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Eugen Hristev <eugen.hristev@linaro.org>

Annotate vital static information into inspection table:
 - init_mm
 - swapper_pg_dir
 - _sinittext
 - _einittext
 - _end
 - _text
 - _stext
 - _etext

Information on these variables is stored into dedicated meminspect
section.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
---
 mm/init-mm.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/mm/init-mm.c b/mm/init-mm.c
index c5556bb9d5f0..4add144a0e99 100644
--- a/mm/init-mm.c
+++ b/mm/init-mm.c
@@ -7,6 +7,7 @@
 #include <linux/cpumask.h>
 #include <linux/mman.h>
 #include <linux/pgtable.h>
+#include <linux/meminspect.h>
 
 #include <linux/atomic.h>
 #include <linux/user_namespace.h>
@@ -19,6 +20,13 @@
 
 const struct vm_operations_struct vma_dummy_vm_ops;
 
+MEMINSPECT_AREA_ENTRY(_sinittext, sizeof(void *));
+MEMINSPECT_AREA_ENTRY(_einittext, sizeof(void *));
+MEMINSPECT_AREA_ENTRY(_end, sizeof(void *));
+MEMINSPECT_AREA_ENTRY(_text, sizeof(void *));
+MEMINSPECT_AREA_ENTRY(_stext, sizeof(void *));
+MEMINSPECT_AREA_ENTRY(_etext, sizeof(void *));
+
 /*
  * For dynamically allocated mm_structs, there is a dynamically sized cpumask
  * at the end of the structure, the size of which depends on the maximum CPU
@@ -51,6 +59,9 @@ struct mm_struct init_mm = {
 	INIT_MM_CONTEXT(init_mm)
 };
 
+MEMINSPECT_SIMPLE_ENTRY(init_mm);
+MEMINSPECT_AREA_ENTRY(swapper_pg_dir, sizeof(void *));
+
 void setup_initial_init_mm(void *start_code, void *end_code,
 			   void *end_data, void *brk)
 {

-- 
2.50.1


