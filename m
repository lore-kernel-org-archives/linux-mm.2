Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38E72FD4F2A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 20:21:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 979716B00B7; Tue, 10 Mar 2026 16:21:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92F846B00B9; Tue, 10 Mar 2026 16:21:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FAFC6B00BA; Tue, 10 Mar 2026 16:21:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6D0BE6B00B7
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 16:21:36 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 279411402A0
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:21:36 +0000 (UTC)
X-FDA: 84531273792.26.87D19D4
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf23.hostedemail.com (Postfix) with ESMTP id 74765140016
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:21:33 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=cSKAc1KE;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=A+ysWVDZ;
	spf=pass (imf23.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773174093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rin5Xzgf9RNm/Gx3a/2HtbrcZkKjggIhMf3Yv3Ghmqo=;
	b=30e3PYj4MPS98QLC2NsBRswj0KFGng2r9mvQ3odXiZXly8hDE/idzKCj16r4wQHtjAkLQa
	wKG1WwARLMqpjIrNvhaEkGou3Z0EWL6ApwO1A4JXCtT1odIRAvcHl5SeHCLtnPch9eMKM5
	Xa2njSS980GWdIlvNNyloHFN2eCmoa0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=cSKAc1KE;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=A+ysWVDZ;
	spf=pass (imf23.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773174093; a=rsa-sha256;
	cv=none;
	b=XpHiD6slC+j+4chmhQw3bszU0L0hpSV7unsfsBiXN9V+jUDWRVGEz09EtAVGgE8NYEhVB2
	hPAeVbh+adf+y9pSXGrSuJS+7eq/3e59LYdPIPgjbXWuMqq8RMjylnnMEEdsiNFoXng7PY
	Pe3MvQp6pEc1Gs8pKV2gTIE9LN6pJ9Q=
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62AIUMKX2862598
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:21:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	rin5Xzgf9RNm/Gx3a/2HtbrcZkKjggIhMf3Yv3Ghmqo=; b=cSKAc1KERyQjjkOA
	qTajW6Q83Ix/u5Eo0LKOiiBoEeptb7pCB/5odF2wr54RzKSDwm2ZvAH1qbcE7bvL
	888ZY5YbJRAd5+ZbXvznNccWLQNvJDYINVNXrJlChhha/S6KjOCs25AuVQMZS/I+
	IW3ufpqfqgC+m3IVCa7My1xhEC7ecNIzapfE8ftgLSu0ZaKFg4Fmxnnw2k+EzT+9
	i+5yGn0jb2+hNMwFqqHO3SkKe4Htt4NSzxCd6uI6/y9xDdr55bRTv8B1pq++DHtf
	mcckOKiGXNl/58X10nzQET/pv5I2+NglpHcBJlr85o0qksKbZMF1kfx9UYGm9UHC
	dST3QQ==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cte3wb6hj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:21:32 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-82984468f85so3332338b3a.1
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 13:21:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773174091; x=1773778891; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rin5Xzgf9RNm/Gx3a/2HtbrcZkKjggIhMf3Yv3Ghmqo=;
        b=A+ysWVDZbdIdEZMS1R4tCyIlS8s030odpfccqtl0W5qdAxEUohErVomKlfCnaWAuY0
         YgjUC7CMerFxzpkb/p8bfXDEc8fhyr7qwg3OmnMwg2w1t9THBDX+LLVHDkkbAWbCwXww
         2NFFQH/Ra+g8/7w5T7K0KpfJ3j9sXAwU5NpNstzxQskRSOKd3DiRfmzNdVtocxDnY6dv
         ec4BLY72sy1q0K9lr5bp6Q0SubrG4B01HXUdxmXTtEFBgP8hSnQT0xSEO6WnG3IKyPnr
         FosOxU0zklsX4/f5e1KnElxxSr0WSY6XKcW5WHNF9xe1dv5UI25uyQW1R3hZ+cMAZap/
         oSYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773174091; x=1773778891;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rin5Xzgf9RNm/Gx3a/2HtbrcZkKjggIhMf3Yv3Ghmqo=;
        b=CXKP3sa+EDLVNL0DBPNbxALHOAiE28dj8sY//P5MBVFh53X10y/OAQpgOAUP3+OGQE
         pcm8VBPi9JkYXzPaLEiq0tVVI+njO+NawH8oDEpHN2LkvIGrx2GPkMxkoDbzcboFAabR
         PgbCKxnbKTPWNgPI0EoYzvQv3D0OzHpXrRcYaDEm6QCEPzPGrCxhIZ/iXTA9NEmzLU63
         F/X/G0CyI5xNJEuo4hMarQ4SDlbULvN0tmn+Flo0dac2d18agQqEyc4suNZe9osfho3F
         mwxeVuK+LnJnEY5TOk8medmmU7P4szJfNq8BjDFxi9g3lWEr8jIBW/Qas2KKP6JigKvs
         R9lw==
X-Forwarded-Encrypted: i=1; AJvYcCW3Y0lbNZK4j5EknNXFeP+9GOrApM6CmC5w7Fb35VFAHVHSCCWm0yjGPIynzHcKrAAO37W3/H5fJQ==@kvack.org
X-Gm-Message-State: AOJu0Yybv+db/NARUV9xnxeJEK5XPJq4JEaftqNswnDkQNNeA2KWfkSQ
	Gga/cyhZbHCOyOxdrBAd73we4iUIqgU1tIZ93UU7gW7MH289m2s3+5z0UtIdflYN9ZSBnMHHi+K
	fdzm+i6Q3Hgz2bEv/6IVllwBPL3NmZf/tLgUEDeREvmB7f95nyoeKSg==
X-Gm-Gg: ATEYQzzHGJ98ah+yg8M+Jg+LhRK5jT444BFSeYPeEo4g7cwh9A3ihedzAlsBZuQ+UeL
	03utkgOoJARubW18wSdc0eifHLwe3/vCeRQkuuZamvZSu3cnI58cZs0SHKz/0otAGmwuaGwcsZW
	ieXr9KUQbqnn16PaodNlvGM/oEwQKT48SlZjUFg7//wPbesZYimHH8s1PDeu5ufXA1inLsfa6R2
	anUmIWIKmC6rakRMe7HweBuQBfbaY5TYHFMl5lLJosGR8adjqt0T+OGSR8RAJR+shSh14npz6Dz
	blgD+oXeclVLzxgAPcViXlrHK90O16XD8Sah6UK10wWm8Pk7Mn/96KsOwl8yJr6lhJdvTpGfJvU
	TwJhX8FeWmGXQDEdKcohI9YKsAU8jN73somNOirR6gTseT1Cy
X-Received: by 2002:a05:6a00:bc93:b0:823:cbb:a484 with SMTP id d2e1a72fcca58-829f706c200mr175203b3a.14.1773174091199;
        Tue, 10 Mar 2026 13:21:31 -0700 (PDT)
X-Received: by 2002:a05:6a00:bc93:b0:823:cbb:a484 with SMTP id d2e1a72fcca58-829f706c200mr175158b3a.14.1773174090546;
        Tue, 10 Mar 2026 13:21:30 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-829f6dc2d0asm115262b3a.13.2026.03.10.13.21.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 13:21:30 -0700 (PDT)
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Date: Wed, 11 Mar 2026 01:46:05 +0530
Subject: [PATCH v2 21/25] remoteproc: qcom: Move minidump data structures
 into its own header
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260311-minidump-v2-v2-21-f91cedc6f99e@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773173756; l=5406;
 i=mukesh.ojha@oss.qualcomm.com; s=20250708; h=from:subject:message-id;
 bh=KXQCMJRLCbRonZvqZxJyWcxsG8bFtO60YADpZ72A4+g=;
 b=7x0MeE/624UBgwaYA8d01C2eHOaPSi5LvmpDqTC0RDeXSdnY95KEknozT67woVS1EZWsgkcpb
 kHF12b/JwLyAxBxitovgKsNVTm6BUP7AGvDHLNONgLVcKcqhMzi7W9d
X-Developer-Key: i=mukesh.ojha@oss.qualcomm.com; a=ed25519;
 pk=eX8dr/7d4HJz/HEXZIpe3c+Ukopa/wZmxH+5YV3gdNc=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDE3NyBTYWx0ZWRfX/0vxEIR9iYTl
 6eInW80cy6xnhqD8xkixE9hrxpweyo/SSX/7zlV672R87Wo0aadh8sZjfLu/DWOyNWidGo+Dsa0
 5UlLbC2Ynfm8CjrvIn3Azbg0l+ZHruPBhzWknFoxo1pBwiP1dyG7CBsONg6aLr+2iCBi7uJH92b
 ieUFyuKZpbjlySXuvPwfy+eSGdmiUOGBaWJWXh5pe8vjFuTH99YHElunwhLTVVUlXLDL4pCFX79
 m6owt9PGXFnNuqZefFvzBeUkfiKSvTSr9KJcI/QP/MIdnmYySPSUO9+SgT/UOWqyqgMUTbqkJRc
 p5KGS2zBQ96ylY1RkZpAl730cgmLibZt90uENZJ7xrJfMXVhjSHGlMpUYAiBfcBhDgbADdKRpD7
 Khtr9/8UGLuvgsVt9v0aJCG8IbZR34bVayazd5NXv//pRKchgFfr+ZsXZfJo5Y4zwNSrXR361yi
 u1b4JlZ+JTdUnSUwbWg==
X-Authority-Analysis: v=2.4 cv=GtFPO01C c=1 sm=1 tr=0 ts=69b07d4c cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=NM4Q4TbMW06K43K3HisA:9 a=QEXdDO2ut3YA:10
 a=IoOABgeZipijB_acs4fv:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-ORIG-GUID: t2YTqgGVau5va0HFVjbp9sVrAmBeFzah
X-Proofpoint-GUID: t2YTqgGVau5va0HFVjbp9sVrAmBeFzah
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_04,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 phishscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0
 spamscore=0 suspectscore=0 priorityscore=1501 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603100177
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 74765140016
X-Stat-Signature: so9xbgfb5r1rukeceq5wa5ymegat94mj
X-Rspam-User: 
X-HE-Tag: 1773174093-138386
X-HE-Meta: U2FsdGVkX18AUxKpiKvAe5YINDBNJHc85s8qTr+fZ/kzwjl1Pj5JgaLQh1fT1zPvyrRsSg/ib1ooKtaZUmWC0EXaoAPJq6/IRNjJ1GBn43CDeJagXJHrU8AQ3NLnRL8QZ8e7PwsA/MnuUmqFaCAwESYkXsbHoXC9U0Pk1KYgwsUDTBqOAr5/ZL2YJ3LiYIbMqEstlVyozb7JIir71onKQgsSavqdghCX8Bz/RuyEqL+o7NjelJ+6h58fKBxrXkzfAZkd6C/O771/u+ysh1HuCrJSK5HmH5aIIwU1oi77qKHpcvCye55Ui8WUhsDjKyvtk+NE6VpafJijlVnX69EdMo3kS7xagCzaT06/n0tj2BA2lBkO94POBho6gPnCmUWNld+HsEE+lebf3RYIgGYR9RO9yeCcULQDjkjr0Wh/XLBHmfvEZjf2O43EQXjOhTV6OF0GPFguuu7PD0tFQJvOsbPfn52aoTY3jucJKSLR8w2JyW6ccIaKrzdseHUrfY9fvoEtGARxnDVK1+Feov6JmbwrAHhfjhesniryi0VonFrOZLRv70/2MTaenqA2mpQug5/LsG8H4VfFGGLUtA0gIgQ231QRa0HGaPerqY5Pkcm2HfjrFtTrd1zCZauilbX4WgJ/6eQalZGeCQrCWieWR9r4nmv2sLLtawggQKMNSODXznL24+2umKSVjyWojwp3oEaU0jMSvfbbTTx0quhFS1JFRhMFcxizG8pfOMAhC4SyKRQN7gwuKGopHnDjxS131svNCXYAZXxzjyW0Ee2kdprMgUalzSrNvruTeGpKtW0FjouRoRKoWgYxoZThZXYqjr1HIYT0DxmgQ/OOd3KBwRQdRQmCYuWx+dKI0ji/To1mSz5T6G0Kd23xcvEUYL0fwNY5CGdIOFggym/+Dz5AjkuosbmcvaN3TP2cVOsaJ9R9Q+ULk0xI6gClTw3X/F6XX+GLJno4GQJ1nhfxou2
 3nOJE2S2
 K/ASLMWyowQBYCpjCb+bhATP+Ycc0//G4B2HcVTDWT1NRVjg4inKrGPljcWb9LnBSu8RTtD/sQjctFda+KtxrBNEdGLRZIvD+F7HyTtDvV8obq+TzMmnL0y61tvOr0VDXa1WmnbwnkBYlt/6SnwZ1BiA9BDqfgnGU0F2xRlbkXl/D5TAkXDKkENa6lcNw5/JQitFTe1Rxv6qDSjA+yrbtkuFJCpTtweoTgKnB6B6+TEta/nvlHSAwwMcpN6UH9Qm02hQovXEhsnWlMjCqiO9AVHcIOLPMx4910SEBOB5NRKOQnpIrQLzklFdjuzi9zIkEWNETxG1gTyxMT+1JwclxIRuxHy0cor08IGuaTJMKT68kCqoeKsanrjgv1vy4tQv7tHeQ86nb5Wk+FgDJp14ZO65x0hRDHwd2wAzsJdV8tGES7BWX0sPCwzub8luWuuuC1EbvHco804wT+WiHmIGW41qgeQacvwyG+9j0lWWGBJlovl1tILh3VsiyVUUpjl2t59v+Ei0N6zCOyuHTJN4czO5z4hjy/ZgcgObm9UMUih50z+a9qdrDrpSWGx6fd7w/ZT9342P536+Qn04gaOFaunvplvzpxu0iNrqlS8Qh0NNgswUMF5gpkViLSnPuhlHIOBq4EPnZ7wK7SqHDQ3dTBCcMjIgEsXYeyinGunIrvfLO6Ogv0bQurn+uhg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Eugen Hristev <eugen.hristev@linaro.org>

Move the minidump data structures into its own header such that it can
be reused by other drivers. No functional change.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
---
 drivers/remoteproc/qcom_common.c  | 56 +-------------------------------
 include/linux/soc/qcom/minidump.h | 68 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 69 insertions(+), 55 deletions(-)

diff --git a/drivers/remoteproc/qcom_common.c b/drivers/remoteproc/qcom_common.c
index 6c31140268ac..864c89f060b1 100644
--- a/drivers/remoteproc/qcom_common.c
+++ b/drivers/remoteproc/qcom_common.c
@@ -18,6 +18,7 @@
 #include <linux/rpmsg/qcom_smd.h>
 #include <linux/slab.h>
 #include <linux/soc/qcom/mdt_loader.h>
+#include <linux/soc/qcom/minidump.h>
 #include <linux/soc/qcom/smem.h>
 
 #include "remoteproc_internal.h"
@@ -28,61 +29,6 @@
 #define to_ssr_subdev(d) container_of(d, struct qcom_rproc_ssr, subdev)
 #define to_pdm_subdev(d) container_of(d, struct qcom_rproc_pdm, subdev)
 
-#define MAX_NUM_OF_SS           10
-#define MAX_REGION_NAME_LENGTH  16
-#define SBL_MINIDUMP_SMEM_ID	602
-#define MINIDUMP_REGION_VALID		('V' << 24 | 'A' << 16 | 'L' << 8 | 'I' << 0)
-#define MINIDUMP_SS_ENCR_DONE		('D' << 24 | 'O' << 16 | 'N' << 8 | 'E' << 0)
-#define MINIDUMP_SS_ENABLED		('E' << 24 | 'N' << 16 | 'B' << 8 | 'L' << 0)
-
-/**
- * struct minidump_region - Minidump region
- * @name		: Name of the region to be dumped
- * @seq_num:		: Use to differentiate regions with same name.
- * @valid		: This entry to be dumped (if set to 1)
- * @address		: Physical address of region to be dumped
- * @size		: Size of the region
- */
-struct minidump_region {
-	char	name[MAX_REGION_NAME_LENGTH];
-	__le32	seq_num;
-	__le32	valid;
-	__le64	address;
-	__le64	size;
-};
-
-/**
- * struct minidump_subsystem - Subsystem's SMEM Table of content
- * @status : Subsystem toc init status
- * @enabled : if set to 1, this region would be copied during coredump
- * @encryption_status: Encryption status for this subsystem
- * @encryption_required : Decides to encrypt the subsystem regions or not
- * @region_count : Number of regions added in this subsystem toc
- * @regions_baseptr : regions base pointer of the subsystem
- */
-struct minidump_subsystem {
-	__le32	status;
-	__le32	enabled;
-	__le32	encryption_status;
-	__le32	encryption_required;
-	__le32	region_count;
-	__le64	regions_baseptr;
-};
-
-/**
- * struct minidump_global_toc - Global Table of Content
- * @status : Global Minidump init status
- * @md_revision : Minidump revision
- * @enabled : Minidump enable status
- * @subsystems : Array of subsystems toc
- */
-struct minidump_global_toc {
-	__le32				status;
-	__le32				md_revision;
-	__le32				enabled;
-	struct minidump_subsystem	subsystems[MAX_NUM_OF_SS];
-};
-
 struct qcom_ssr_subsystem {
 	const char *name;
 	struct srcu_notifier_head notifier_list;
diff --git a/include/linux/soc/qcom/minidump.h b/include/linux/soc/qcom/minidump.h
new file mode 100644
index 000000000000..25247a6216e2
--- /dev/null
+++ b/include/linux/soc/qcom/minidump.h
@@ -0,0 +1,68 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Qualcomm Minidump definitions
+ *
+ * Copyright (C) 2016 Linaro Ltd
+ * Copyright (C) 2015 Sony Mobile Communications Inc
+ * Copyright (c) 2012-2013, The Linux Foundation. All rights reserved.
+ */
+
+#ifndef __QCOM_MINIDUMP_H__
+#define __QCOM_MINIDUMP_H__
+
+#define MAX_NUM_OF_SS           10
+#define MAX_REGION_NAME_LENGTH  16
+#define SBL_MINIDUMP_SMEM_ID	602
+#define MINIDUMP_REGION_VALID		('V' << 24 | 'A' << 16 | 'L' << 8 | 'I' << 0)
+#define MINIDUMP_SS_ENCR_DONE		('D' << 24 | 'O' << 16 | 'N' << 8 | 'E' << 0)
+#define MINIDUMP_SS_ENABLED		('E' << 24 | 'N' << 16 | 'B' << 8 | 'L' << 0)
+
+/**
+ * struct minidump_region - Minidump region
+ * @name		: Name of the region to be dumped
+ * @seq_num:		: Use to differentiate regions with same name.
+ * @valid		: This entry to be dumped (if set to 1)
+ * @address		: Physical address of region to be dumped
+ * @size		: Size of the region
+ */
+struct minidump_region {
+	char	name[MAX_REGION_NAME_LENGTH];
+	__le32	seq_num;
+	__le32	valid;
+	__le64	address;
+	__le64	size;
+};
+
+/**
+ * struct minidump_subsystem - Subsystem's SMEM Table of content
+ * @status : Subsystem toc init status
+ * @enabled : if set to 1, this region would be copied during coredump
+ * @encryption_status: Encryption status for this subsystem
+ * @encryption_required : Decides to encrypt the subsystem regions or not
+ * @region_count : Number of regions added in this subsystem toc
+ * @regions_baseptr : regions base pointer of the subsystem
+ */
+struct minidump_subsystem {
+	__le32	status;
+	__le32	enabled;
+	__le32	encryption_status;
+	__le32	encryption_required;
+	__le32	region_count;
+	__le64	regions_baseptr;
+};
+
+/**
+ * struct minidump_global_toc - Global Table of Content
+ * @status : Global Minidump init status
+ * @md_revision : Minidump revision
+ * @enabled : Minidump enable status
+ * @subsystems : Array of subsystems toc
+ */
+struct minidump_global_toc {
+	__le32				status;
+	__le32				md_revision;
+	__le32				enabled;
+	struct minidump_subsystem	subsystems[MAX_NUM_OF_SS];
+};
+
+#endif

-- 
2.50.1


