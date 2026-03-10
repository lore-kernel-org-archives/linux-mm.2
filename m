Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CCA9FD4F2A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 20:16:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFA206B008A; Tue, 10 Mar 2026 16:16:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BADD56B008C; Tue, 10 Mar 2026 16:16:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A90126B0092; Tue, 10 Mar 2026 16:16:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 99BD16B008A
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 16:16:47 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 641BE1B76C3
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:16:47 +0000 (UTC)
X-FDA: 84531261654.11.454A22E
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2222240004
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:16:44 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=KwXlqLyu;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=gcHfCpkp;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf01.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773173805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DTX4p31kM7kOnEUefU6ccwARTUTvSilVWBmwn4s2oLU=;
	b=t07Url0IA4OrUf0lbzpor1DztRHcvL+WN2dxB1wR69JL4q0GEU9tmpR5B7jNo2mVw26Cr9
	W5UwsbTHDIKavOYm2ytvlSuIPkn1d5uBkjvDrTUhtve27molciHYuRtsu2l6JJNPQo3ell
	jQtXovOUJ/3n4QOKXIRXHaGnr3lP+f0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=KwXlqLyu;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=gcHfCpkp;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf01.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773173805; a=rsa-sha256;
	cv=none;
	b=Z1uqhII/VxwpBwK7IMukb//f7cFquZodja3YCKLPf4jwJ7TKE5Sp+/kDk3Qv9tYFTvUBbA
	XPQsw0DfC+9ae9pelniahWG5SXkSAbs1HECezyiBejSCZiiXqDikMQHvU8UHt6tEZIsH/p
	fcGNRaP4M6uRKGYQbLrPaF5ZA9DXo2c=
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62AJXDcX3296521
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:16:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	DTX4p31kM7kOnEUefU6ccwARTUTvSilVWBmwn4s2oLU=; b=KwXlqLyunBOJBnaC
	9wTPeZY1p89fm9likNFkjIOolZGYigd4493rDSGio0Op56iSgADiW9tkmHS93DzZ
	Z4dl3kYK7EjYBQr7qF5Mwz4WMuEu52mgBz4R7wcAfeGzA26nbuhKhy1odSdpXF5K
	IOPLF4kdehxHDI75rew70DYRGZYgWX1KqCjKFVGo+O+MWeYEYdrDFGDwWZooXr+/
	R3qUdx6aW3a6GhAgqL7XEbXRAClq2wY0FQtyl9UurWK53k3N6n15pyuQA8u73CUz
	1K4KVoX2wmGYlqdjcVtdNJg7TSfXM+/x3wu36mRui73jRM69fdxknSj8BuhqU99u
	srEkgQ==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ctg1mtp3s-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:16:44 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-82990cfa91aso2090475b3a.1
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 13:16:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773173803; x=1773778603; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DTX4p31kM7kOnEUefU6ccwARTUTvSilVWBmwn4s2oLU=;
        b=gcHfCpkp7itVSdJeWS7d507NhMh+FsPR8WPymi6BiI0nnqszN7C7k/3oDa2i6gFXyP
         YxX/VoUmL0w7n9OfPy5sh+zlP2uU9VWBj7yiWXS5VfmC7Qts+olrdNx/s7Xs/0gknrkl
         +lWANKtvJs5v1tmo+AhXfYLBMbDxcx7aaCg3pkMchnr1rLsSbTt0f4yjidY9NhP+HzSL
         F1wJjBgTbBHF5+eb8j4F1CN1e6zzfUmPu01BY4JSmFF4ypUdxEF4EYTuDrwMfgc8zGU6
         0SIbfEaTkWDNJZrZ+wsCFbmzagFs2MiJuslZXGiTjpqOJO4cmkCkQOUT/1r8ZUkYnegx
         LjtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773173803; x=1773778603;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=DTX4p31kM7kOnEUefU6ccwARTUTvSilVWBmwn4s2oLU=;
        b=g81a60G76WPXDkC7CYM3qkvOgmQsMlUoiVp9EbanhXMunlXuK26RhROagbkBtrAfqv
         9DwWSNfe4/5oBnCDoF+6pT7FMPyZlrqiYhsEMpaajNpvEWO2GTHgiKB4DCIzhaV1eSOw
         nvJN4X1KO28VOqHyzTpJGTG/M6Mx//0iYjkAdLxrQeyNRxDl5rrynUefmbew4V9MxJG/
         KY+a0ulLxSag/NIHDpOBjsaYs5yYbIK0S7/Jrz/Ttu71wuxtUJNgNabugqYcdwDwJwS9
         ioNTL3kPxsQD9xUtIuDerMuezhLdLhaAn/hpIem3O08Uzt1w+Fe317Igt+oSI43vLat2
         GD8w==
X-Forwarded-Encrypted: i=1; AJvYcCUGrQ5NZM/H0FrK3oKBQI2fKVDWoGAcInO4aGXoL29BFW3JCJEHRygyz/vIkm58wH9jl3/N7Q51Tg==@kvack.org
X-Gm-Message-State: AOJu0YxF/+UIDytmuvTcd211EZqfLNQA3G3hOXfccP0EEiZUvMM7F1dS
	bcF7NSll4gqMzA7Tf8A1lYqCIUyYU3efSNWM5V9NPFEpjYGu97S8VkxGUv34agM37tXs//PXBN0
	ZenQKSAVw+Xdx11STc1USouNefTlrXBXXO3/Yc/UItp2htaw8zgguuQ==
X-Gm-Gg: ATEYQzw9fQNdre2bMurL5PECn/ATGf0zV6BUttepq/UDfaVBRIopJQ/qphnFbisy6+S
	w7IGmw6+evCrthdlTjOiHx7O8xVCMR9y/jdIsvNcwAlVEBQyo8NPgIcw9uMQbdE5NgU0Mk7BGty
	fWnxFAx9Tcn4AYJ+nm86qPDApp33ZDfkkIVoHsIOi9DOmM1wPX8euRmaGk4lJx4z6ovpEKoDKri
	a6wjHOIqlrUDFgzh/tVCrJItd9x5klXbhsqPN3brcaj3tGh4RRgXjZR93BSfP50FXXeaf9hrvxh
	RLpMt1f+UdMghDSew1kiN8Vew8FHD11XmxDf2pZqkRZAIY33espckuDjlVVhg1STxVt9MGiNcy7
	DUHX39YlGlkaNt60CVdY55qWnbdGt5q44MB0PN3Tdznj4ecV3
X-Received: by 2002:a05:6a00:1911:b0:81f:3c77:a24c with SMTP id d2e1a72fcca58-829f71c2835mr119370b3a.66.1773173802617;
        Tue, 10 Mar 2026 13:16:42 -0700 (PDT)
X-Received: by 2002:a05:6a00:1911:b0:81f:3c77:a24c with SMTP id d2e1a72fcca58-829f71c2835mr119313b3a.66.1773173801990;
        Tue, 10 Mar 2026 13:16:41 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-829f6dc2d0asm115262b3a.13.2026.03.10.13.16.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 13:16:41 -0700 (PDT)
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Date: Wed, 11 Mar 2026 01:45:46 +0530
Subject: [PATCH v2 02/25] init/version: Annotate static information into
 meminspect
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260311-minidump-v2-v2-2-f91cedc6f99e@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773173756; l=1541;
 i=mukesh.ojha@oss.qualcomm.com; s=20250708; h=from:subject:message-id;
 bh=lAwXJbujOmB09G6GZkxyBJzVpavSEwyrUE2Z7xn4ZiU=;
 b=0oYhGgbq1STEZ7k8JFP6TcqseHKDFSTb2lpqYRc6OwdRJclcX7mQ9VIpOlUuYgfOJpihrSniF
 GvMoFUpmXdqDtjHRmHcCfq12jlKK2hy1c3AQybcS1esMZcKKicnFheu
X-Developer-Key: i=mukesh.ojha@oss.qualcomm.com; a=ed25519;
 pk=eX8dr/7d4HJz/HEXZIpe3c+Ukopa/wZmxH+5YV3gdNc=
X-Authority-Analysis: v=2.4 cv=YOeSCBGx c=1 sm=1 tr=0 ts=69b07c2c cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=ZVr_NMlg2zHurtFOj60A:9 a=QEXdDO2ut3YA:10
 a=IoOABgeZipijB_acs4fv:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-ORIG-GUID: cnm_fSA0SLiZW0CVY8Razxtdnlv3wjs1
X-Proofpoint-GUID: cnm_fSA0SLiZW0CVY8Razxtdnlv3wjs1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDE3NiBTYWx0ZWRfX1SMd7ahwbl/F
 eewQ1O0hDThcY7Y+tpJ1NdKCJSPc9dlp9nhC9XoAUtcurqanLwXRR9lzfs11LzQQ/RLMgPN9tpw
 Ld4bX/JzKUSdxstRPUTx2m8fjhr1EqGqygpKq86EDz0iaFBi3uziYMgPIqDVRDsJ72ffwQOLI2c
 4X9/hOIiYdb6GK7CbS8i07gR7hn7FyaPzAEw84ni97GOxuvUtsktyVEJ2GxWnJ0QGdoxkYrqHyY
 7d+l/Mz7nGYfQYqss4Dew9dWfjOYm2eIx9hzjyLcEBS0KF4pN1oI3B131r8lcjI7ZrdXqiVmtz6
 XaekZtAVRMfi/dCZLY8R6EhsZTb4DLV2uJckPEEstDPELvtTs0fSoxYFgmf8RU6HLtVsK3+9Tie
 057qDh5KVV4Y3u9FGoOz7XaT5RHdMZFw7gzDIhixy81G3s3IayShGwZwOv3q1rXCVg1awK8YPZA
 CqBg2YnzE19+xX3kWJw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_04,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 spamscore=0 bulkscore=0 suspectscore=0
 priorityscore=1501 malwarescore=0 phishscore=0 adultscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2603100176
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2222240004
X-Stat-Signature: jgcjb1wmfw8k7se5afzcjtms4yo7gjyn
X-Rspam-User: 
X-HE-Tag: 1773173804-857658
X-HE-Meta: U2FsdGVkX1/aI0PjFg1+TijfvofII0QaTwNjhgtx71L/8qkKSypoMbBesw1x69Ni1bWl/RztiU4JMWvR7QVPi8cUUNmnRWechgHA7W9bEq1mA1UocvmW3jG9Lut1BCRkjQFTL7713Bijod1fGMyixTYyxncqOILIrskK2bh5VRu2dILnzaKNU8J2KK2T4lIOdsTX37ujl4gYj7fgZI1XUdofOMdVkVkqkeaLCbX/51TnhQrlp7bYJ6WR8z0qFQRsnc8Df3s9sJbodvQEXbnpjsoVeczq5AWYflNSoLvC8cPmP3fKRYt7rnqeGmtfOT4GbT6FTxDX/1chUmEPRGCQN61n5nlRd90Dt7oSOAJszzjn4XiRYBw415v4Xlaqu7M0XAV9R1Nq7dBhaq5Wi/Od7bRfH5RD6R20rLNLef7nZrNZiiPgJ4WfGBwxuTLtHiZq+9HXn/xKMXEUem9aQIFo+mkqntp9c+P1cHyB+nAbLiipJNFfYxUIopkgzoK+QVmCjNnAfl9ntxkNTJHEMamn2bSJCt15D5+5Dz9+kjwWwZT5BcD1Y5dmYUMzyDhIrvlI+iqLsbR9+3Zw4+SWJf1UUEw6qL+9o82IHb0hy4C2Tk9N3Z6xGqZ4TF+qi/rCth039gqEQG5qRLLNmttOyqpw1x8IN7v4U8EPLPtPGj61RA9qezAq49tjwhteW7IF+lBX5zpf91ckjxa66W84YhA3nM4q/ifzNDJI7guttb8tIg/sFo378AFYASJRN82X1u0gbmcmrhQAGXBBDggVf/yK/seO4uZ4eQuAgX9v8J9zcUWmj2JX/uobaNMOm07swsCM97ZoW0pJAfd8fcoFdGq2o95VYbcIgfXhVpQiawaNbMKluGM/eJYmz/k2ojd9Zf5bELfcrg/yCUgdE0Pperf+KcCZSyYHoa9FRZ7oN/XynfunbTI70pNX0u6ArHtE8f8l/PEEsV2tQClOWSYAJDm
 AiGGAjuW
 D0P0Iov6WbP9S7lcITsaaZWB0o3ZN4wr7WuMHIYeNMqpgRIDbODoQfga767DBneIH8gv0CUZC0t8oGHHvvdMaq1wjD/yAReK925qhDl3hjAErsJ3e8eBf9dKjqqU0cLyusLA1UuulDJsfMrT1mWXK9+0+J2rsVd/74/DuzyhvofE7uftLgGQkmC6nEpL51n93A8I2ubNTSvEmsmfGlTqtSqhNTSgEpDWj4qyI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Eugen Hristev <eugen.hristev@linaro.org>

Annotate vital static information into inspection table:
 - init_uts_ns
 - linux_banner

Information on these variables is stored in a dedicated meminspect
section.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
---
 init/version-timestamp.c | 3 +++
 init/version.c           | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/init/version-timestamp.c b/init/version-timestamp.c
index 375726e05f69..37bdcdd443f9 100644
--- a/init/version-timestamp.c
+++ b/init/version-timestamp.c
@@ -6,6 +6,7 @@
 #include <linux/refcount.h>
 #include <linux/uts.h>
 #include <linux/utsname.h>
+#include <linux/meminspect.h>
 
 struct uts_namespace init_uts_ns = {
 	.ns = NS_COMMON_INIT(init_uts_ns),
@@ -24,3 +25,5 @@ struct uts_namespace init_uts_ns = {
 const char linux_banner[] =
 	"Linux version " UTS_RELEASE " (" LINUX_COMPILE_BY "@"
 	LINUX_COMPILE_HOST ") (" LINUX_COMPILER ") " UTS_VERSION "\n";
+
+MEMINSPECT_SIMPLE_ENTRY(linux_banner);
diff --git a/init/version.c b/init/version.c
index 94c96f6fbfe6..eeb139236562 100644
--- a/init/version.c
+++ b/init/version.c
@@ -16,6 +16,7 @@
 #include <linux/uts.h>
 #include <linux/utsname.h>
 #include <linux/proc_ns.h>
+#include <linux/meminspect.h>
 
 static int __init early_hostname(char *arg)
 {
@@ -51,4 +52,6 @@ const char linux_banner[] __weak;
 
 #include "version-timestamp.c"
 
+MEMINSPECT_SIMPLE_ENTRY(init_uts_ns);
+
 EXPORT_SYMBOL_GPL(init_uts_ns);

-- 
2.50.1


