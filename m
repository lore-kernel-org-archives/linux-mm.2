Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC6A6FD4F34
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 20:22:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20B9F6B00BD; Tue, 10 Mar 2026 16:22:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DF8C6B00BF; Tue, 10 Mar 2026 16:22:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AA986B00C0; Tue, 10 Mar 2026 16:22:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EDF876B00BD
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 16:22:23 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A46981C324
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:22:23 +0000 (UTC)
X-FDA: 84531275766.15.EEB4C26
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2B3FDC0008
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:22:21 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=aPw1h3cc;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=Qonf17zu;
	spf=pass (imf28.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773174141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/uUYtzbBAMu+u7bupalNhBTW7BYEt5Sa2Qb3bAaRTLs=;
	b=IFmWwJ/CSDXDbyMVJWTt+3fgKHr5oO02md8bcPpRQIEcucFDJ4L6F7mPPDDPdciz4Fcjpt
	mRUWdul0JOBc5hhbTMNfpKUYwzsKvNt28efA838kSdB9aIUCJpD8c7FwZ5RaOixvDUoYpX
	ulYCm5wsPE7D1YYtCeUZFLhdcyaVoOE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=aPw1h3cc;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=Qonf17zu;
	spf=pass (imf28.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773174141; a=rsa-sha256;
	cv=none;
	b=ohiWA1vpuCIbAfVl8sJ5cSouQ3SGpHh1SAGngUEN8WzdQlbC7d7tEIXLqgo/Q3lHhDZzVC
	sm1n+6MhOttFe5EUt8JIk1aVBqGVXwq0nUjOAmx+j5/vp5aCIbLzRP+t37m+PAKAcRnXKm
	4AlYY0SQDi0EqZEt477FprOpeymJ4Y0=
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62AGH4Sj508501
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:22:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	/uUYtzbBAMu+u7bupalNhBTW7BYEt5Sa2Qb3bAaRTLs=; b=aPw1h3ccTPQ6vDva
	8RL6Id8V2H9C8hHgbuFfmEhGDmnb66zSn4duAggHPmCRidkKkeyWI2C71J46RzVh
	xEmYcvijqUFc063opGpKoJds5en9I434aZD37fdwqygNZi38H+sNnj3tiJHvNmaK
	Q/7YZyhp3lwCWmwcUg4mJaVZaWy2BWI6YokznMU+P2LlC6zp2oryV/X9AGryskIB
	D+T2+reeGB3+BB9a4illrxG7VfFFABat1d0C5HOBn7StO11xfUh3IXQinWhjw0he
	4xgTqLGpeGIzh0BoJ8aYSWIPxxkIMDz0RovcfKd90Af+N+l4plGNy856xnj/hPv+
	CzKZIA==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ctppagx7c-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:22:20 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-829b7ed8964so2427080b3a.2
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 13:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773174139; x=1773778939; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/uUYtzbBAMu+u7bupalNhBTW7BYEt5Sa2Qb3bAaRTLs=;
        b=Qonf17zuPdHOLZdcbqG7wNIo/MBHHSneKBbG5wh4CVjeTnYbMH/w719Xjl6VJlReft
         kqfGdY6O5py2Uu1ay+1THGyDVsjePMVQnlQypZE5m4IN8Hi7tWi12snLoBkBxUVyC4n+
         F+69fhQN2X147lQ047FA8A8dIzXnHOTL8ayPFfEkZs90CXEJCgJWhVqW6NbjTQ5KMjdg
         3za22ajRz7WosSNfXCfZFmJKuHxM+nZKZLbK2sPn/Z3sxkPziZ4RTEpC2UAgL47JmXrY
         S5kSvNbphxIB0QOKnp1jxKMVgVFQkBA4afrHZ9tFtQIk1cgQHWezgR0SYYmbjxbrpICg
         NZiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773174139; x=1773778939;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/uUYtzbBAMu+u7bupalNhBTW7BYEt5Sa2Qb3bAaRTLs=;
        b=SM8x/l2GrJkE2d6f6QXPvqBnhAjY2Bg4VgWVJqXk+mygVJt9s7cpAT+/oEXA5kC23F
         RPfV0z3JIlQ8eGunyYCFJvGSKCxKbrvsquoZI4i4zZ3jqkcM/AA69/WBePiVnqbhv0zh
         1bDmkPPCdCakngWlXNPq9gpFZsmGgMZcYqXY6R3CaQ/MFD8tdGMKC0D8EwPvXqNRO+Gy
         5IyfyaSj6M1ywHiCNi2LaHlHrZ/hHLtCm6Biu1t1vpLvxqhyn6Pnmj7zZp+y3GnMLJWJ
         PsOMYPMOFSGXlHluWELm9emL6/Y7lmDRV5YzGflsosmIqhKqzzArJr0zxAUXIqB62oaK
         V6oQ==
X-Forwarded-Encrypted: i=1; AJvYcCUGZgXGvxa0Sb2V89kjJBE0FOtwkQ2QP9AcmlqSWINDwrjJ86IAM+rflVLs2wiBJAK1OBXadg9geA==@kvack.org
X-Gm-Message-State: AOJu0YzRbriTU5L7hoHv5P2Qx9r+BhfWmLEtfSS+00DuV9vg668y8x8L
	x4q5syaJnLB0Eee+LRn0uRlp13g3NffzsEBAJEW7U8O8jlkBHGcrqtZ7GtLblZRUDkM/IQmWuby
	X9OjDTUCedGDBXzwIhfgDCM1ypRj06YFfjH8WAC8Z/7BjtdgJCE9P1Q==
X-Gm-Gg: ATEYQzytrHq/LCoC9PplJYvukyNuUd/9G7w90GeTbMZR2QV8YjbsR2tjxxtzMhU+oMY
	QX3W9x9EnIT/8ai9xI2N3SDwrbk9wa1FGK02zD/kdy7NlRfSsEKnR63mwRoS8fjBXzRQUE2S9ic
	YMR2mZMud+qGyejEU2TAUxKQLomqZePf23zWhYMlFJP3Z67iJasFIhAlQFSS9fLO87YA5qJWhft
	CaLpyl0VegclUbSqwhXb6y/rk3o2oNmtqqQBd7K3xRa8zKVSBVmfCsS9OZnFKIPykh0sKTJoKLV
	EVqzTX9glDsX5KEDILXiv7Qb9hOz8AmYK1dXRmAb99mYxR8ko2dSGsSGpM9fgsJFzqNScLOcm2E
	yEvA9ojfqf/caOogo1DElXcSudwOHhD7wkAs6dbooLEAKXLta
X-Received: by 2002:a05:6a00:1d90:b0:829:8041:83f with SMTP id d2e1a72fcca58-829f707301dmr155578b3a.7.1773174139080;
        Tue, 10 Mar 2026 13:22:19 -0700 (PDT)
X-Received: by 2002:a05:6a00:1d90:b0:829:8041:83f with SMTP id d2e1a72fcca58-829f707301dmr155530b3a.7.1773174138369;
        Tue, 10 Mar 2026 13:22:18 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-829f6dc2d0asm115262b3a.13.2026.03.10.13.22.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 13:22:17 -0700 (PDT)
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Date: Wed, 11 Mar 2026 01:46:08 +0530
Subject: [PATCH v2 24/25] dt-bindings: reserved-memory: Add Google Kinfo
 Pixel reserved memory
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260311-minidump-v2-v2-24-f91cedc6f99e@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773173756; l=2474;
 i=mukesh.ojha@oss.qualcomm.com; s=20250708; h=from:subject:message-id;
 bh=kxkhHL6Inn5vy91sWNPBwxtVUU5b0erQRsexgGrH3n8=;
 b=6MT7VZEYiJ26WHI1HB+RUTYRS5S4mWBasU/tY0AGrn+K0ZHF6GT766OHo8RuR4PhqhgpOtU11
 ixnzFMgK0faBvouTgqwCNSVVa7/2YaR2C2ym1CGyS7TIOWKzb2K+whi
X-Developer-Key: i=mukesh.ojha@oss.qualcomm.com; a=ed25519;
 pk=eX8dr/7d4HJz/HEXZIpe3c+Ukopa/wZmxH+5YV3gdNc=
X-Proofpoint-GUID: fCUEbrD8gDva4AILYMtVFrCct_N4vg8i
X-Authority-Analysis: v=2.4 cv=D7BK6/Rj c=1 sm=1 tr=0 ts=69b07d7c cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=gEfo2CItAAAA:8 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8
 a=37rDS-QxAAAA:8 a=2rb2LGFNx5Mo7s1WZPsA:9 a=QEXdDO2ut3YA:10
 a=OpyuDcXvxspvyRM73sMx:22 a=sptkURWiP4Gy88Gu7hUp:22 a=cvBusfyB2V15izCimMoJ:22
 a=k1Nq6YrhK2t884LQW06G:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDE3OCBTYWx0ZWRfX3cfgof2b1cpQ
 7KyJ5SeG53GjN6hZMKICyTtnqkYhWj8K1CUQ37yf7ffmoywQM4n5Y0M2uJeuK1M4iHYuwt/y9AL
 WVG3N7qlmErvetuBKNNZLCekkVOomWPrVUdKucR1+Gxcbh3QJiWty0d3g6L1sv4ZU5zlFX0Kc/y
 GEN7LsPznxeqb2h8o18cjxOxC8fOQ5NcnUmxMeQQgfmBzBG2ocFu+M3TnWMCXrhTk62XU3yitBi
 ZxrH3bEdH25myneCrXAboC6+m7a5ScIT1Wu8TbP2A3vtbxIkl1rLIE6JKa1NGs1b90JnCuxXXcL
 f1HPdusPpZJN5agFJz7zgntOGxfkKFiA8TBXDsJCDR5bL26zqOeDirubBpqrQ5BSesttYYvE4+6
 eJfhEXDMSF6La70QEjLn84WjQOGBm0TZB7dd8gedxzk5gLGClIyBMhcBRWgZkc8cHbAFsr0N+3i
 BumhpEQFJM6jvxr2+YA==
X-Proofpoint-ORIG-GUID: fCUEbrD8gDva4AILYMtVFrCct_N4vg8i
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_04,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 impostorscore=0 spamscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 clxscore=1015 adultscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2603100178
X-Stat-Signature: upqjg5gi441hkswk4nd5jr4ste5dutia
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 2B3FDC0008
X-HE-Tag: 1773174141-377126
X-HE-Meta: U2FsdGVkX18aBbR0D08kkomKK8/5quE4LxHmJ0JxkJMQZH2tjCd4m37EdaTWxfTMBw3TO5TaibmokH69zVSDZIWntO0MFW4Lq4H2mCMMKtYFrls953OgKm5rinEJzV9KgLc9KnHaJt/FQzuAHGSJR237pH8Bg0WdD2cujt3/VTtfrsBvZonaq6WYiimotcfV+7n6jXmlN6SEsmJRObxJDvoLaTvDQwoasgN8YX6QX/2fwjDT2J/UHXXjskfcrxX0c1p+qU4h1LtCuvY0AhIcUAp5A8nCTh+NYhQV8Vw05EfH4IUgWSHBq4keRpChG8viaXNjTdp2WoXJPLoitvxeNKPBAROjaYYAD7WcpJvZINtU1/EKZcP3dR4RxXxsR6U31luuh5CkPygf4f//jtroqCXkQsz8ifnbCoeTPHSePZ/qJgjWAwuIrDqg7WtWW+nSB4BvghJhdLirWo8Vv/OvRM7QQ63M2aPJhpEpjpBbzlomt4kp8H409g2EGHquLbtN/aVbGvFMIifLr4Xk4mW4nEa/cP3c52ZoHQhr1sBIbYuFvbyoH84rv8Q/I+2xiaV7uXhN2Celk6rLYrwlsoKdOjqXn/Wbgx3Q58fZ2QUZKwDOFZ/PwOt/aLtnq/VgBT7/owEWn8kpOCpiOvDyNABuQHkQZNgvd7K1OJmip7cu1/BqqlbEG4dZs2+y/nYm207jzsOttAgGoNBHl75DERj5s+OVWjzXK6e+7mxfSDENcZt6cESBPFYMqdSwyazVprC7kVqZWx+pQGvZ21WzTAv7eMGgFn4+npSiAGHONGnxNCH7PVkKTghc0gkUM0lyuDwSwOji8oWmpgEXNLtgQSecLqJWJujTqDJGZHU6v/aMGAxUMh2gEGimxLXiXs1vX8xc91Ox2dNomZy0+vv0Vb/q5WsYq3Bn7xLCyh8caofof73zSw4fSH68mv2A1/w82CnhYnbAVKVJTXg7qTRmvz4
 m181DnhC
 423E/vemVQF6YemAHFBk9geicYdS+p8YCceaesTQ4YIQ+aXQC0BbdX6VwK64FiMw3bnRKooKYFBgCeV7/Lb9cWFY4bNbA/STU00xCZqfx142rwCc5qMv1SkR6PqiJT56VGxGUYcOoMKlySYKtUoeQZ8ckP7zhQko9P/VMglSBJLFN8swd2HQngi+do8AcfXF7bXAH+guOsdLqI93Thw7dnlWfCm6f5lmImpLwmKBT4OshZYWKPef3QeOcwtxJ5v/os6XdAOU6K8MCHODXzyyWAhmkPmQRBsKL1hqOzEpoDa7Oq68VDWkRV2T1F66I+/zdiE03m43o27WQ2dx4aR+F0z807eOyj4vFdthNTVQlLMJBBDTEuw1Fmjdo+G+TlG3/aUERJ2cGbVLfPd/3U5ssjRxx4vK0Gu1mgYKc1hmCyUQRCKqE0AGnt0vfCz7YCjL/4kJuMYy1q7vfqRFOesqWwa/VCZp3Go9Ih/v5QXp+wDlXmkXmsAFnCuDbnNBnxEvow8VfUGg9zTwYYKnXHGjqHAH/31u7U4cY4wiC2sqFrN+wa/hL83dyZR8v/wX9woDuoTOfjC4MVncSb+t2wPowSFqmbi4obRh8Yl7cRN7TvVkNZZhCJIbsOSgT4Q0d3Sb+RFeTb3Nt++mMA3cL0xeC6/jNU1V1lxKmd5gUBgFz+4V+T43Mzo3UXsKCEpNSqPUDSVErvH0dYdnohiD5AoIRK8YXu4Ev0zZRkCeg+iCnYtH5H+5NP/srU4wt1aL8OYaQSupe/7O24PHhKl9Fy7fglZE27W+clMPo/R3VKxOSpH9+quY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add documentation for Google Kinfo Pixel reserved memory area.

Co-developed-by: Eugen Hristev <eugen.hristev@linaro.org>
Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
---
 .../bindings/reserved-memory/google,kinfo.yaml     | 46 ++++++++++++++++++++++
 MAINTAINERS                                        |  6 +++
 2 files changed, 52 insertions(+)

diff --git a/Documentation/devicetree/bindings/reserved-memory/google,kinfo.yaml b/Documentation/devicetree/bindings/reserved-memory/google,kinfo.yaml
new file mode 100644
index 000000000000..2f964151f0c0
--- /dev/null
+++ b/Documentation/devicetree/bindings/reserved-memory/google,kinfo.yaml
@@ -0,0 +1,46 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/reserved-memory/google,kinfo.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Google Pixel Kinfo reserved memory
+
+maintainers:
+  - Eugen Hristev <eugen.hristev@linaro.org>
+  - Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
+
+description: |
+  This binding represents reserved-memory used to store data for firmware/bootloader
+  on the Pixel platform. The stored data is debugging information of the running
+  kernel.
+
+allOf:
+  - $ref: reserved-memory.yaml
+
+properties:
+  compatible:
+    const: google,debug-kinfo
+
+  reg:
+    description: page-aligned region of memory containing debugging data of running kernel
+
+required:
+  - compatible
+  - reg
+  - no-map
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    reserved-memory {
+        #address-cells = <1>;
+        #size-cells = <1>;
+
+        debug-kinfo@fa00000 {
+            compatible = "google,debug-kinfo";
+            reg = <0xfa00000 0x1000>;
+            no-map;
+        };
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index ebf478dbd15c..2504b7df0e7d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16592,6 +16592,12 @@ F:	Documentation/dev-tools/meminspect.rst
 F:	include/linux/meminspect.h
 F:	kernel/meminspect/*
 
+MEMINSPECT KINFO DRIVER
+M:	Eugen Hristev <eugen.hristev@linaro.org>
+M:	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
+S:	Maintained
+F:	Documentation/devicetree/bindings/reserved-memory/google,kinfo.yaml
+
 MEMBLOCK AND MEMORY MANAGEMENT INITIALIZATION
 M:	Mike Rapoport <rppt@kernel.org>
 L:	linux-mm@kvack.org

-- 
2.50.1


