Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AFB5C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 05:34:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D46E36B009B; Wed,  8 Jul 2026 01:34:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1E586B009F; Wed,  8 Jul 2026 01:34:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0DE16B00A0; Wed,  8 Jul 2026 01:34:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 995F16B009B
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:34:07 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 136271A0679
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:34:07 +0000 (UTC)
X-FDA: 84964493334.24.1310DEC
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7F0391C0009
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:34:04 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=ZLEn2vC9;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=U0whPCoV;
	spf=pass (imf21.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783488844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4HpBuqrozdeTyOtYEWu93SJI5zpFDQRgHZKn95naWN0=;
	b=CqHRZrNMz5hdfH5LhRDWcv0xGozQF1c8TOMM7sO3Geb7y0rV0uyhSldd+Do18+0k2p/YC+
	hWoLpy6n7eRU2Q0Phsi9X/2W9TT3YwoeiB3pSQ4Z35gfAkds7T2DPXbjcB2wR+l2o0IK8n
	O4oEIjgDmvBX1LLTrVs6MCzCZmj9tvA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=ZLEn2vC9;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=U0whPCoV;
	spf=pass (imf21.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783488844;
	b=pa6e++WdRFp75P+FlAuMmmigKrPIDQJuGEHfLriEntfX2rMutOeiZvLZgcGNdoevF4GjOU
	PHHcwGQACPBdFO6ixS0nZdLeLzVJ5EuYc8yT1/MMbRoY0ga+jo2mn9mlJKSEAKX/VL8P59
	MqrNe5cnupfcyUz0LWB586C7YXBsoZU=
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66843YuL1528618
	for <linux-mm@kvack.org>; Wed, 8 Jul 2026 05:34:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	4HpBuqrozdeTyOtYEWu93SJI5zpFDQRgHZKn95naWN0=; b=ZLEn2vC9NxxlEGc4
	1NncPtbQ68ubHxWs4R7OVEJkvFYOJ8VJLWeaJKwtIWrm/Kjz1b8FL+bkRIscEhBa
	RHIhgaMkGvVeB5gzoG8Z9KilGd0oPTeNqemM2c5nhLpwefyLULCtJ3FGm1IRSGA4
	HOKs6PhZRS3AcIwR0u/aPAOb/46ChHOniWeCtWmsWQ8wIbIADMJkv9hvkDTcQ4sC
	j/4/TUTzyHxbVPTBZFTsuv2R1R7/4Dp+UBTLePYTFf5KCZLwuomCk1/DUqKOMJqi
	ZotjZSvlcje0VhjwIQA0CIjCu2yZ2Fxs3Hh+fC+L4XlZw7WlicRNQNdo4jwfDSum
	Bc7CAw==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f8vun5066-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 08 Jul 2026 05:34:02 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-8478a1ec69fso563494b3a.0
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 22:34:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783488842; x=1784093642; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4HpBuqrozdeTyOtYEWu93SJI5zpFDQRgHZKn95naWN0=;
        b=U0whPCoVvAj2xsnSzSXtga8GUHsYYU8gXeYO8bqQE8R0z+vTfQxwmlt+BSERhEDT6c
         W5sOKXHB9Wni4nmHpnbnw9Jq/yRTFzAkAKUFFtUCNtdB13yMelpjtdghjyZRuRpkAPiE
         bmTSpQpKZlX8MK67cwK3lLcKtwZvBnGoPomVzvcFDQfHGGjg5RtuAs0O7BFBy/JxjmWw
         7jB1+rUQelB7yTgE+fd6OPRpsqmDuLUDlLEyDBqvq3XYlHzMm+7Nm+nJQis4R7b6I2PP
         XO+qU15DowMZ+4pqWLVsEtDrERJ3UwMQRiM2z2hDQvQ4S4meU5GkJ6c8bLwuVtOoQnrr
         raqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783488842; x=1784093642;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4HpBuqrozdeTyOtYEWu93SJI5zpFDQRgHZKn95naWN0=;
        b=WD5u5esWECDtg7X/F05muhaeR0an1jlQcFROj4VVF3rR4s9X7YMojaWWJu5LY8wnUl
         dHRBFV1VUqx/VlcO21in6nvBBMuaVhrND+QzDfaKg7cKvuB/kEwpgyzAZ0IcnO6GZl3V
         JEp8v5IjHeMM8z9+9ESNR+ubm0h7txDv6W65tCdb8/zWctK0nZJgI0Q7qf7LRh2CKHNn
         p8Ud+v6twjpdOywYw9bHMcEki5SngtMzjk5PP4fKkTOQ/5HhrQPCxsmqG9ia3ZKP4ILM
         7Tz/gRIeWfK0V6RdHTIhYYUrbOwK7Nab11XpFOhCGDuTbfab6XVpUQDqTKAQ7uXc7Fuw
         0RMw==
X-Forwarded-Encrypted: i=1; AHgh+RqAi03RfPlBB50Nab4I9PI/m1xe7CgCqwY4lqeOZnHhaP51+IeJZl5QvvFlg4H5ApUC6q/ibupIOQ==@kvack.org
X-Gm-Message-State: AOJu0YxhHM4UbT0c8bBbcUtau2uGk0ckrt/XEBkavM9v8QUBZEvYPOJo
	FuFK1rGQSdX2L1jXCmxdoDRzonMErDLLbCANDYf3Oy9I+rbHDVtnabhEnAmG5vZXwrlUAJ+rKRl
	OXxiuiiCF4YJxcehEbuFIg/NyPzqtxWU1c9cuKqwInXVf8/kWtPL3EA==
X-Gm-Gg: AfdE7ckCviKlViDSAVDeqqNgFqdaFjSW0oJQRPH2APptStVO1yywRoHykWtQzICvYjB
	KbwAJ3svFgAKfEFLJZqk25OqG0khfDKw8HAy7gT6UwLLJu+PciYay0u/dJVVdS8GxZngRzH5yzy
	THqHqZjwY6BVgTlM1zoL0ctyj+9PnlIY442gw9zamAMsTMAKSjXSx2a4iiJ0DCivKojDnT81XsG
	jfMR2A2sB06lsukH9L4rDpTlLmQizxMXT5mlnc/TqqiWj9ysvbHiidbgCgNnP7hBXQuj3YXNALp
	R8sL9F+p/bk7WPQs4i9MwM53gB2XAv9owM5hbfyz6QS2YY367yDMLJj/JA5FIRbmFdSQVUqJdwe
	PFA12vlU41eTERRl/xeL/l8T1CCp3AHWm1LoV8g==
X-Received: by 2002:a05:6a00:4fd4:b0:847:9745:2f8f with SMTP id d2e1a72fcca58-84842ef9336mr1249181b3a.18.1783488842136;
        Tue, 07 Jul 2026 22:34:02 -0700 (PDT)
X-Received: by 2002:a05:6a00:4fd4:b0:847:9745:2f8f with SMTP id d2e1a72fcca58-84842ef9336mr1249126b3a.18.1783488841342;
        Tue, 07 Jul 2026 22:34:01 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6db29d1sm6484592b3a.53.2026.07.07.22.33.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 22:34:00 -0700 (PDT)
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Date: Wed, 08 Jul 2026 11:01:46 +0530
Subject: [PATCH v3 07/26] timekeeping: Register tk_data into meminspect
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260708-meminspect-v3-v3-7-7aa5a0a74d5c@oss.qualcomm.com>
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
        linux-remoteproc@vger.kernel.org, devicetree@vger.kernel.org
X-Mailer: b4 0.14-dev-f7c49
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783488714; l=1559;
 i=mukesh.ojha@oss.qualcomm.com; s=20250708; h=from:subject:message-id;
 bh=/537SqZjhoVd4pyQoK/eRmCVxxyWSUJ6mvHhf7gAvZY=;
 b=Fve9cp8pIk0fRrev0JiMgnk9tJtf1Nbcov5h2qnSMWvoYTJmuNKoh/yGQ3zv9wJ8+PXmUs4Ad
 m5Vo/TUy3rKD3XGNX5Tr3o3s7jZt5hvgFYrL80gNWyboimv945juho6
X-Developer-Key: i=mukesh.ojha@oss.qualcomm.com; a=ed25519;
 pk=eX8dr/7d4HJz/HEXZIpe3c+Ukopa/wZmxH+5YV3gdNc=
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA4MDA1MCBTYWx0ZWRfXysYGYxDnCn43
 XK6fNnXAJChpNBhevOoPmYifv9hVtcjCBGbqETazBf+ZEPHGGM6HyrOX1fO1Gjhe+bCNZU6U1li
 2tBzgI5V4+nmMTjs67JdBHaKPSELhQs=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA4MDA1MCBTYWx0ZWRfX0ebYMHdkhv5q
 nsBdYtbfXK2CYVIIE59wCIgv+wIT2PQZR8qlfHBEDX17TZD3OGSF3Cj8HKUfohOOzrd6/MRbsnO
 cpDCqZIoAql25CrIGtydiX6Bk5BIYUXiPZjuSgJCHg6WZAk2sLc/oWKu1UURSni6Q7T2WyVH621
 HcPOqSD395K7IniA2D+VfTzUJrwPueC1uZUVQcm80yC7wcSXBlU8W78qwvW21c9Ln5iFHIx6cvt
 5UGQUoDm6zZCpmuytTMTJInYEejAL/sqQ8Rm9y1SAFdFeEliS2W2F8OHcA1tECb0vghnSrrf05Z
 rP7Bf5cKAS1sn3Zhu6nTUK3JPAYnI6ue/TNj6QmnTXWKzorcVvdBvAWpLGX85KJE1ktKuSTa172
 aB/XLM4tF4qctWSzhR2BCxYjWB013v5hCQYy8AyDJp0cEHZN17lYacFrsBR6vMVUFNyhUjZ5mwH
 tW/sB3O6Vx5qUG/lAsA==
X-Proofpoint-GUID: RRc0gAxu5pJLqvpwDcnVsW8Ym1iazvyI
X-Authority-Analysis: v=2.4 cv=N+IZ0W9B c=1 sm=1 tr=0 ts=6a4de14b cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=PWZB-clRUh0r-kCehmkA:9 a=QEXdDO2ut3YA:10
 a=IoOABgeZipijB_acs4fv:22
X-Proofpoint-ORIG-GUID: RRc0gAxu5pJLqvpwDcnVsW8Ym1iazvyI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_06,2026-07-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 priorityscore=1501 clxscore=1015 adultscore=0
 bulkscore=0 suspectscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607080050
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7F0391C0009
X-Stat-Signature: 1af6nafm7qw9s5s6uyugf5oig18wsyty
X-HE-Tag: 1783488844-222427
X-HE-Meta: U2FsdGVkX18o4sIqQEaMr0vfWVNsGLPHmcRhYhukc5dwdxHE3s9FFxYXPAOiFC4lX/W2ReCpR4mrTJujgEL0QZoySnKjWH1ds2toDbLPGkxQL0ZxshoVjNgHH2TvYt9wf9TySpABn2zh0FF76OwJ9QppfpHlF3EwCcGeyjx/h0+PiM86hLqpyEzs2goyVHuUAoIOlL0xEOpQ4rLgOe5ex0MWduqd1VYDg84ocO0Ly9EWeP8SKNqswB7TgjXB3ehbTfCpNBms2Ty4XOXCVNy7c5dm4c7XmFiS31oej8aGGxRfAvh4Qz8fHX2lWq2gH10DMXZ4KAu29GvyIPJFlTOqMZWDDabw5+2C/d6T15uLI1Pd83TkJyXGB9kZbVVy7vbRsoahx3OXdEtvCcMak83PQa40Z0mBYfArFbn4qYDiCDe/wupNgnuaDA7DXnwE8idYY2pbRKAT+BaR1V6uXNOuoP/M1GFWWagQEy7fmMW9MGhlekLgdGp3LlZf5vv03pDcEkCqbhgRjtRVXQE1GGspShIlqr9QFA8d9Ukf4j7S27xd2+FSX9VQMPQucVOrqqtE2TXckrEsTzGFjIsuQ+TFQOBXEv8vCgnNVpHunYpjOUuHr18ifojaOWs08lFw3NHMhGnImjljoW5fctU2NbGSUY9vu3r5m8d2F79plHOhVav4diLo5GMZCr5nyy72lPpKgsGd54J+LSILLwsBiX3REe4uXll67Oa3lhYyvZ/fM1cNTawkA/jFZXLXce8O1a3AKberMlg+CYsTUcFb67AGHE+5/Lk12rn+WbsoJJK/tNd5Ael0Zla/as1HCvQkCoMqRcVs38VU5WDbfmtbi0Xy2d2sfBdRXpJrZhHiOgDxPW+2TKjm7zE9kshqK6hZSrHci04AeDeZ/sCTw9nGcXMSu/331+SoM5A70CDgfmvzyGRRCDmHOyvbWOiUCbnz/xQKKU4/508hxs6MUVVbEz3
 yyV5yzyR
 XcfWrIHuJf1OGIpl3ms2SL1WWMpFe3e4spMAvifwEA2iC9DMzob5xXacjWFYGTf5fEfw6jaARqtPMDfKGu+0Hosc8P53Neo0c6KILAYNOMDyR2aoF1XtnxlLpqZjyZ2x+ljCyX83QPqB59JE3ch1ivnkjQ+DKSqj5QyYiFpnDWJMNo6ZMW20sYQOGRL6o8MTvDYSq+sLFPJ7Onq3P6FNCDLC7l917cOp2UoGCMihKpEY2zeDHJEOX78YoMka1ufWXC6Vc78jBUX8UJnG4Sf2KAQSfrfDbxm5tqWne7Tb1oXiHUWcuKus8533aLE0jDnjyfB5seNFn/CPNSMeMmO7Mnxk9sVT3nmIWx+lr74KEjYOrzXsuI0Vm7CvLeY2ZrijgVVwnzIQ7zsyzCtBw42Sav3+3LdiXAmIcaow2h1AyVtnMs9dxP8hvvvbaqz8oVOhXLsAKQ4voQogroZu3LDmzwku9T5LgHtKBMBjLjLykFHrFFOrppR0iScolj5p9ulNgPGbY5C3DYFYiBpPuzluHbTjQqMPoPIUyshtIM1pbkVKKIqFDak81GZiqw9A5LjQbeSCGPJMvaUrgPAy8lpZqbsV05XPBWXtJ9DlEXUvJR0B1PKXphXDlBedLrg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Annotate timekeeper_data into meminspect for debugging:
 - tk_data (timekeeper_data array)

Register the timekeeper_data array using MEMINSPECT_NAMED_ENTRY
with the "tk_data" identifier. Update the meminspect ID enum and
the minidump backend string table accordingly.

Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
---
 include/linux/meminspect.h | 1 +
 kernel/time/timekeeping.c  | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/include/linux/meminspect.h b/include/linux/meminspect.h
index a9eb93c6ea2f..b64ca614b243 100644
--- a/include/linux/meminspect.h
+++ b/include/linux/meminspect.h
@@ -49,6 +49,7 @@ enum meminspect_uid {
 	MEMINSPECT_ID_kallsyms_markers,
 	MEMINSPECT_ID_kallsyms_seqs_of_names,
 	MEMINSPECT_ID_swapper_pg_dir,
+	MEMINSPECT_ID_tk_data,
 	MEMINSPECT_ID_DYNAMIC,
 	MEMINSPECT_ID_MAX = 201,
 };
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 5985d6652c1d..8a5da24d8678 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -14,6 +14,7 @@
 #include <linux/random.h>
 #include <linux/sched/clock.h>
 #include <linux/sched/loadavg.h>
+#include <linux/meminspect.h>
 #include <linux/static_key.h>
 #include <linux/stop_machine.h>
 #include <linux/syscore_ops.h>
@@ -53,6 +54,7 @@ struct tk_data {
 } ____cacheline_aligned;
 
 static struct tk_data timekeeper_data[TIMEKEEPERS_MAX];
+MEMINSPECT_NAMED_ENTRY(tk_data, timekeeper_data);
 
 /* The core timekeeper */
 #define tk_core		(timekeeper_data[TIMEKEEPER_CORE])

-- 
2.53.0


