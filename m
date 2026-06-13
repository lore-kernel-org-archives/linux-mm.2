Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58848CD98C5
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 17:21:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C03136B009B; Sat, 13 Jun 2026 13:21:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB3B76B009D; Sat, 13 Jun 2026 13:21:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7C3F6B009E; Sat, 13 Jun 2026 13:21:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 934B46B009B
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 13:21:11 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4D7101C233B
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 17:21:11 +0000 (UTC)
X-FDA: 84875555142.22.547A709
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf07.hostedemail.com (Postfix) with ESMTP id BA0AF40006
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 17:21:08 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=MZlaAldJ;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=dVxKXtFi;
	spf=pass (imf07.hostedemail.com: domain of pranjal.arya@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=pranjal.arya@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781371268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yByRTqcgr+Wmflbfnv6FJYfUST+aqgHU9xDBqMKtVHU=;
	b=s2gZ1lddViQEKo6QFjRjz3BLrLbjSx+XiHiL9HTw4fAL0fPWmJ1WgSU9C1vDSy5F2LT1YN
	x5P9olcOksc5XxMBP96teKf/j48lSxHpR3uPEDQKunrleq6Xs10MMrK/9mXRiL37CHjziT
	28iyf6ZpmCHZJyCnEc3jeeKTBOJ2FC0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781371268;
	b=iEHoqfyG0aYevPTglg1vUV5W801BCQ06O1dhqwAGIXVM5K6tyA8EaZR+gSlBSYdIPjJjJX
	RaBGNzXwCQX8muPP3R1WAauqIzKaqSYOYKiet9OEiYoT7y7eDOzoW1MnZ6JVmbPcxgTVQW
	9OsjnQxNVgHjvFHO4g08WixeLcnLd+8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=MZlaAldJ;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=dVxKXtFi;
	spf=pass (imf07.hostedemail.com: domain of pranjal.arya@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=pranjal.arya@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65DFAP6M3318058
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 17:21:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	yByRTqcgr+Wmflbfnv6FJYfUST+aqgHU9xDBqMKtVHU=; b=MZlaAldJLzVAYK1l
	p0tS7zIIn+KuuOOBF24rcUDf3A/f+vnzj5jLpjqiS2X9Qr4zcEe3wmQDqzuicrSR
	w+/7ceBEXQ9NySVojXFWjQFlFgN/WMVujKUQAcwmQT7Azeg36FTPVHU8+0rImlSX
	7nUYkEL6vx59+qkd/D47M8CdBEsu1OUlVmLh2hf0yI9zd3IZOk+emYHZ2gKaEGlH
	ND2+LcthBI/R2ikjP6Tkh4TZhnuiBsaTZd92V0jn9jy02ZCGPxxts1zTiekvv4qg
	0bpUUcZtNMRdXV1CPb453q5PzyDOXPLVsBAQ48qNJPakvXcCDrWFMsdwrxxVZty6
	Q5KIng==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eryc6smqu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 17:21:07 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-84240b58211so1414519b3a.1
        for <linux-mm@kvack.org>; Sat, 13 Jun 2026 10:21:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781371267; x=1781976067; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yByRTqcgr+Wmflbfnv6FJYfUST+aqgHU9xDBqMKtVHU=;
        b=dVxKXtFiV7V1VZGxo4El/I429mUYLsNcK/Cc3xw4w9nV88dt8OvVQPqZOQInzk0KHH
         VfsxQVR1ksZMcSFJ85nhYTkWAMkuInzXRLjPJJ/oHwrYesiQlKDoGUCzcz8KJi0feGtF
         KjzCL+42EpNg7gNTew8cukkqAwDluouqWm6YaRuvozqzaGj4fRHUgudxucPcfk9MEeem
         BJWlafoNlGWIPJtyNbgaQUdt25aHBTqFnSkETxWdteq3p1DhM1+jvX5RlQXxpSPTCXA8
         iNbMeeC4Rdo4zBlTxMKIE6HmS0tAHSxpen0zeSsMyACuKu0FbuPMo0IoJqIKC4LoATaE
         zWRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781371267; x=1781976067;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yByRTqcgr+Wmflbfnv6FJYfUST+aqgHU9xDBqMKtVHU=;
        b=H3jCXLPa7Nv8TPHJa8Q7BDUdnKFiToZtJsiS6EHNLkDQlNYuZQjABsHeojqvD5VLgL
         R+kSS8yoX3LcanFmgsZkBqmEq65TcheUmKZ7CSf4ce7UnWgcK25XKOc0RNcNAC7jX2IF
         SXBYZILfbYl/zMBVTrNpjRkbJcZgKnxOm9Bmmkij0XTkNQI1LhK07JjB/QtwK1e9Muz3
         DRX7wzxGSLMXBXkSFBGgBR6Fu5koxydC9sQS//EWKvbpX0yTEufuKDlNYzz4On2XoQQf
         umUKYdb0NF7zCDVKx9DA55HmfC8A4XLP513av7pmuewXM2Nx1Ads2FSLUA/FG4D35tcV
         hXXg==
X-Forwarded-Encrypted: i=1; AFNElJ+eP7tLMpkTI7wLSayBzjerEwJ3g9KxK5x50YX134UDEHnupMzcid+W+xGcUQQ3X0oWJ9iYDDmccQ==@kvack.org
X-Gm-Message-State: AOJu0Yy1CqMbSAjlXVZ/+0W9Xj5LIbmxxjSpqAwEjKi5iTucoSqFug0i
	2ebN/l42S5ZV0URYS5GEmhF3jaCgS+Wf+NOz5gVCgaNPeBR2x/vxdcCeyeVs+991LTAdItXOLnI
	bxW/j+Vnv0Jk6wuXP4KOQR6Ea7Fs5g/bJfySiDxecyLc/1c/p17oUww==
X-Gm-Gg: Acq92OE/q4Reyt1m4aTT7fTpQ6Pf3fxvekNJOHv47CmLdInMmORY7JNcZfHwOr3XeO+
	5Go/ePjE11M0850Su0/eAdpOmsGCsQtXYhrEudeNRJFxXMeZ9b2yNMEm2dBUTrMMHtfVr93iBHF
	TNMy1Iet9xKF8lendh2CigMPaolOJGHk+OiMl8WTNHEtI2fHf9Uald02yjvTgBTlEX6CMCQmznv
	fEv+EezstqRbn42nppgiQwuSBSUur6Itfp/HIT4np3RgUC4AvauTtXyRPLV6XBWDdJ8LNz1Uzot
	UwriFkmB/QHWXIoyGON/OKO9w/2XxJqoeEb4VLXo7G9pJx4swMiWepi0kHvgxrLoj3DxviWnUco
	CWfEWZWrewze5mI5HeNBDv9XUHmP/p0Awd7++r4Xg77DHRUmJUsiqUg==
X-Received: by 2002:a05:6a00:950d:b0:842:2f3d:dff2 with SMTP id d2e1a72fcca58-8434ce81341mr7553839b3a.34.1781371266340;
        Sat, 13 Jun 2026 10:21:06 -0700 (PDT)
X-Received: by 2002:a05:6a00:950d:b0:842:2f3d:dff2 with SMTP id d2e1a72fcca58-8434ce81341mr7553803b3a.34.1781371265702;
        Sat, 13 Jun 2026 10:21:05 -0700 (PDT)
Received: from hu-pranarya-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434accbec5sm5390913b3a.16.2026.06.13.10.20.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Jun 2026 10:21:05 -0700 (PDT)
From: Pranjal Arya <pranjal.arya@oss.qualcomm.com>
Date: Sat, 13 Jun 2026 22:49:47 +0530
Subject: [PATCH RFC 05/12] mm/vmalloc: tighten failure handling under
 memory pressure
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260613-vmalloc_maple-v1-5-0aa740bb944b@oss.qualcomm.com>
References: <20260613-vmalloc_maple-v1-0-0aa740bb944b@oss.qualcomm.com>
In-Reply-To: <20260613-vmalloc_maple-v1-0-0aa740bb944b@oss.qualcomm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        "Liam R. Howlett" <liam@infradead.org>,
        Alice Ryhl <aliceryhl@google.com>,
        Andrew Ballance <andrewjballance@gmail.com>
Cc: linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
        Lorenzo Stoakes <ljs@kernel.org>,
        Pranjal Shrivastava <praan@google.com>, Will Deacon <will@kernel.org>,
        Suzuki K Poulose <Suzuki.Poulose@arm.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Mostafa Saleh <smostafa@google.com>, Balbir Singh <balbirs@nvidia.com>,
        Suren Baghdasaryan <surenb@google.com>, Marco Elver <elver@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Alexander Potapenko <glider@google.com>, Shuah Khan <shuah@kernel.org>,
        Dev Jain <dev.jain@arm.com>, Brendan Jackman <jackmanb@google.com>,
        Puranjay Mohan <puranjay@kernel.org>,
        Santosh Shukla <santosh.shukla@amd.com>, Wyes Karny <wkarny@gmail.com>,
        Pranjal Arya <pranjal.arya@oss.qualcomm.com>,
        Sudeep Holla <sudeep.holla@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781371215; l=27712;
 i=pranjal.arya@oss.qualcomm.com; s=20260516; h=from:subject:message-id;
 bh=93nd/fp0WT0lOBo8bTdnf+a1qmT1fxj8wsunRs1e6EU=;
 b=u5NeW4Ud9Q3H5+3jTYofL7oc8m5kRtaEgxllCWom5Z0j0JW8ZN6Ht4QAizUAGKSg0IlzZP5gc
 14TKEq5dlwXDvGo3hbqVIVJiZ2SroiXTIFhM+jxPuhZStMZf5j4gbD4
X-Developer-Key: i=pranjal.arya@oss.qualcomm.com; a=ed25519;
 pk=ymtcTlccEIDsi3ErhpjIoZZHKdPBYWGWW0Lchs5MsbE=
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEzMDE4MCBTYWx0ZWRfX/1yGXtenXrrG
 6+iaktuYzNJsiK5bR3r0Mf9N0PSmaEUBISAcpf+yrEWNGGj/rl5LPGdVfUs0MBCdFAdIkwjvB0Z
 1BXlA4c+cQptPO8KsBCMp0F6u8xs568=
X-Authority-Analysis: v=2.4 cv=Oop/DS/t c=1 sm=1 tr=0 ts=6a2d9183 cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=o4zA9CgbANw9Vykgm7UA:9 a=QEXdDO2ut3YA:10
 a=IoOABgeZipijB_acs4fv:22
X-Proofpoint-GUID: hwK3l1_iMWen6UQo37ELtA-suhxJ8lF0
X-Proofpoint-ORIG-GUID: hwK3l1_iMWen6UQo37ELtA-suhxJ8lF0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEzMDE4MCBTYWx0ZWRfX8XH6/h+qH2+v
 8X3936l5vnHvbr0CeI2cC+O0RESLY7AYvztUJ5hb+9GyH5plkaZKVZmXT0zkR0Gm7s3J4jESSyH
 K/QeitBn53za5huVgrcy/1HhJ0wCGxxgn9DrfMqMsR3zRjkEzfAzVBSijVX+wItqyNlmrWQ+CLC
 3LiPPaRwD+bZVzIDEFYWhHv3iOPsYiMPvipy8uVT15ZEivnZNZEbHuMjLeH4BGDhHPZkqRC1UQB
 0ZN1gFPpDed9c0m6TD/+f82kl9BqAAxgZPFFGD8ca74knpwEW1j4HC/vLV/vecvqOjtx95Yzr4N
 inEn/31si0xJxRLxq3karbTD/Phaj3LyuawiP1aLO9OzjEfGckdwIKp/5Az5lJSbbMtY9qohzm0
 nVZGx/WT1YOQKhPD7Hdk4+F5vDWSn4PO37z84F7evqUGhySpCtGky20v0bERImv/IVAet2bLmnH
 hukP1SZ4V6BVRkXC6gw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-13_03,2026-06-12_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 impostorscore=0 lowpriorityscore=0
 clxscore=1015 bulkscore=0 spamscore=0 malwarescore=0 suspectscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606040000
 definitions=main-2606130180
X-Rspamd-Queue-Id: BA0AF40006
X-Rspam-User: 
X-Stat-Signature: 5dtrr41o6ob5551oqogcas4bh5gjx7to
X-Rspamd-Server: rspam08
X-HE-Tag: 1781371268-537940
X-HE-Meta: U2FsdGVkX19Vy7MGQTF4NfSZL1LHcugvln/jq5q1rKq+7SRVoE9b09r2MpnVWfTsv4TevOMovq7BDD13YBSwthN0eZqRKQ9GDynde+uTpwERzgu+7awU7yLgaYT9xFGmHm9IoOFY/s04HI9osdrKQODXuK6SlWWv0Q0/+s5LGviBklZUWHhfju3mup/dMSYh8JuiixenwuWKio4G7HQK/rvyA8Jd4UbnDvTyTSJdwSKC+jeKXNm1oYwCTJEC7hg2ptBXwMZH6Xw6NwXk3cuCsybiFnFH1+l7PpCwosrty98+sj+Qo73FnqLdWxuGUrerORcrDvdkiyUfpDxnNfAGAUuJisfNShLu4/nJ8hHhxavX7XS6dF37No3E70Jmu29Hw33YbxOmI5ZJOFmHbYI6oMF15ct1nJCWlnVXsYo66DehHClvNpISb5jvYvM5BmSInrdvU4tghj4MQo4P5QbaFLKcr0Y1Wmt4vVFJ5Fp5guKlGu6WVmdiLZzqWXDtHI17dpQlw8CzUbGfMDtaiHK8AjUqBplL7KLN7gAHL8fh/g51gpA5UjaUtEzpv5w4t6dFEXl0rH9Igt/FVFp8ZaUjvf6c7aIGPrJItw0oRJihon9lCw92YOCpPqQV7t+cmOsIP0D1Jn1+SM+gz7gjjFgu4CMjWr/IKkM1aI4Xn1MvFuSs1O+hZ7HxpbjvBDDwBurGnDLah8H9+hhtUmIDjYzaj2Ky9jnqQZMzxDcy9Myi6+ECy2IyxPqL0mXLS73cHn8fsZEIE4S/2CROIxv4198335G1XAkXBJPNRuqvXwCioephTg83Z73LR7CuUUqkkIv11PpmWDr2ipcN8YFTWKEh2Wb8X+c4w/Ci35eDhmZe2dalibHV0faYWFydj3po+HpZfOo0kXLjq/mJniyBh/ofchUwmqVGl/2Ox+qNm/v20qy0KgqkKVwlE5Dg7P4smjt62O7Rw/8z5yPpw2vB6f9
 i1gZL6n0
 Orcy61iEebGA1S5Hb0D0GPPacM3IRBk4DHm1zcyDm08HYy/TxcXIOkY8R2HEzZ15k98rUZ/LHGMVtV4qeEaIl9d4yu+onf6qpgcBPxaZ7zqquVhfUsz2FmJwFIdGzw//NoZ7AFV5MNwYnFXnfQmOnEtqtOEpheP5lMKLg79a5WbH3CnZYDtjmD9pEuYARbc5j5fJFKJ6nKquRt3io30Uqdhq8IrF00pjT7rU2+bOjElnUu4ZJ1SWrN4wWFUJIpfUdgpghLgB+l4LycDAA5uyvFSmvtu6F6gVHTI86F9v/Kxzcwm7sINU7+11ToQD0rS/GVcGUV/LDlBvBuXczZ0i8uCXEgQiTomj+7+pfxqhxTxDksscYZIEHE79sy73hb1Yr6DaVjPAHzShB7wtHjAYGOua77bFekRp7G6i2pPGjEvg8WUkfzHpJXbNLZ/M68JTc01kbD0lDEZK4emNAW3XrsFKHBulfZu3rqxQ9z2Yd2cQbVsegqtSV9yLf9K7pW6AqzFRKXoRnmqxulhoOxVUe7n3hsA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Tighten failure handling on the two paths that publish into the
maple_tree under a spinlock and have no caller-friendly way to return
-ENOMEM:

  - free_vmap_area_noflush() falls back to vmap_retry_list when
    publish_vmap_area_lazy() can't allocate maple slabs under
    GFP_NOWAIT, and reschedules drain_vmap_work to retry.

  - the alloc path rolls the busy insert back onto the retry queue
    if insert_vmap_area_busy_locked() fails, rather than leaking the
    vmap_area or panicking.

Add vmap_retry_list as a non-indexed retry queue scanned by the
allocator as an exclusion set and drained from the purge worker,
and wire the two publish-failure paths above through it.

Signed-off-by: Pranjal Arya <pranjal.arya@oss.qualcomm.com>
---
 mm/vmalloc.c | 566 +++++++++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 474 insertions(+), 92 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index c908c1a0fcd4..7feb1b182cfa 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -869,6 +869,12 @@ EXPORT_SYMBOL(vmalloc_to_pfn);
 
 static DEFINE_SPINLOCK(free_vmap_area_lock);
 static bool vmap_initialized __read_mostly;
+/*
+ * Non-index retry queue for ranges that could not be transitioned to their
+ * target maple index state in constrained paths. This queue is scanned by the
+ * allocator as an exclusion set and drained by purge workers.
+ */
+static LIST_HEAD(vmap_retry_list);
 
 /*
  * This kmem_cache is used for vmap_area objects. Instead of
@@ -1113,6 +1119,47 @@ free_mt_update_va_locked(struct vmap_area *va, unsigned long old_start,
 	return true;
 }
 
+static __always_inline void
+retry_queue_add_va_locked(struct vmap_area *va)
+{
+	lockdep_assert_held(&free_vmap_area_lock);
+
+	/*
+	 * Keep a VA on one list at a time. Retry entries are detached from
+	 * all indexed containers before they are queued here.
+	 */
+	if (unlikely(!READ_ONCE(va->list.next) && !READ_ONCE(va->list.prev)))
+		INIT_LIST_HEAD(&va->list);
+	if (WARN_ON_ONCE(!list_empty(&va->list)))
+		return;
+	list_add_tail(&va->list, &vmap_retry_list);
+}
+
+static __always_inline bool
+retry_queue_overlap_locked(unsigned long start, unsigned long end,
+			   unsigned long *blocked_end)
+{
+	struct vmap_area *va;
+	bool overlap = false;
+
+	lockdep_assert_held(&free_vmap_area_lock);
+
+	if (list_empty(&vmap_retry_list))
+		return false;
+
+	list_for_each_entry(va, &vmap_retry_list, list) {
+		unsigned long va_end = va->va_end - 1;
+
+		if (va->va_start > end || va_end < start)
+			continue;
+
+		overlap = true;
+		*blocked_end = max(*blocked_end, va_end);
+	}
+
+	return overlap;
+}
+
 static __always_inline void try_init_free_mt_locked(void)
 {
 	lockdep_assert_held(&free_vmap_area_lock);
@@ -1169,6 +1216,14 @@ occupied_mt_store_range_locked(unsigned long start, unsigned long end)
 	return !WARN_ON_ONCE(err);
 }
 
+static __always_inline bool
+occupied_mt_store_va_locked(struct vmap_area *va)
+{
+	lockdep_assert_held(&free_vmap_area_lock);
+
+	return occupied_mt_store_range_locked(va->va_start, va->va_end);
+}
+
 static __always_inline bool
 occupied_mt_erase_range_locked(unsigned long start, unsigned long end)
 {
@@ -1339,7 +1394,7 @@ find_vmap_area_exceed_addr_lock(unsigned long addr, struct vmap_area **va)
 	return NULL;
 }
 
-static __always_inline void
+static __always_inline bool
 insert_vmap_area_busy_locked(struct vmap_area *va, struct vmap_node *vn)
 {
 	int err;
@@ -1349,12 +1404,12 @@ insert_vmap_area_busy_locked(struct vmap_area *va, struct vmap_node *vn)
 	try_init_busy_mt_locked(vn);
 
 	if (WARN_ON_ONCE(!vn->busy.mt_enabled))
-		return;
+		return false;
 
 	if (!validate_vmap_area_range_insert_mt_locked(&vn->busy.mt,
 						       va->va_start,
 						       va->va_end))
-		return;
+		return false;
 
 	INIT_LIST_HEAD(&va->list);
 
@@ -1364,11 +1419,11 @@ insert_vmap_area_busy_locked(struct vmap_area *va, struct vmap_node *vn)
 	if (!err) {
 		mas_store_prealloc(&mas, va);
 		mas_destroy(&mas);
-		return;
+		return true;
 	}
 
 	err = mas_store_gfp(&mas, va, GFP_ATOMIC | __GFP_NOWARN);
-	WARN_ON_ONCE(err);
+	return !WARN_ON_ONCE(err);
 }
 
 static __always_inline void
@@ -1391,7 +1446,7 @@ unlink_vmap_area_busy_locked(struct vmap_area *va, struct vmap_node *vn)
 	INIT_LIST_HEAD(&va->list);
 }
 
-static __always_inline void
+static __always_inline bool
 insert_vmap_area_lazy_locked(struct vmap_area *va, struct vmap_node *vn)
 {
 	int err;
@@ -1400,12 +1455,12 @@ insert_vmap_area_lazy_locked(struct vmap_area *va, struct vmap_node *vn)
 
 	try_init_lazy_mt_locked(vn);
 	if (WARN_ON_ONCE(!vn->lazy.mt_enabled))
-		return;
+		return false;
 
 	if (!validate_vmap_area_range_insert_mt_locked(&vn->lazy.mt,
 						       va->va_start,
 						       va->va_end))
-		return;
+		return false;
 
 	INIT_LIST_HEAD(&va->list);
 
@@ -1415,11 +1470,72 @@ insert_vmap_area_lazy_locked(struct vmap_area *va, struct vmap_node *vn)
 	if (!err) {
 		mas_store_prealloc(&mas, va);
 		mas_destroy(&mas);
-		return;
+		return true;
 	}
 
 	err = mas_store_gfp(&mas, va, GFP_ATOMIC | __GFP_NOWARN);
-	WARN_ON_ONCE(err);
+	return !WARN_ON_ONCE(err);
+}
+
+static __always_inline bool
+unlink_vmap_area_lazy_locked(struct vmap_area *va, struct vmap_node *vn)
+{
+	int err;
+
+	lockdep_assert_held(&vn->lazy.lock);
+
+	try_init_lazy_mt_locked(vn);
+	if (WARN_ON_ONCE(!vn->lazy.mt_enabled))
+		return false;
+
+	MA_STATE(mas, &vn->lazy.mt, va->va_start, va->va_end - 1);
+
+	err = mas_store_gfp(&mas, NULL, GFP_ATOMIC | __GFP_NOWARN);
+	if (WARN_ON_ONCE(err))
+		return false;
+
+	INIT_LIST_HEAD(&va->list);
+	return true;
+}
+
+/*
+ * Transition a VA into the lazy index and drop occupied tracking. On occupied
+ * erase failure, attempt to roll back the lazy insertion; if rollback fails we
+ * keep the lazy entry and let purge-side erase_occupied handling repair stale
+ * occupied state.
+ *
+ * Returns true when the VA remains lazy-indexed; false when it should be
+ * retried via non-index queue.
+ */
+static __always_inline bool
+publish_vmap_area_lazy(struct vmap_area *va, struct vmap_node *vn)
+{
+	bool lazy_kept = false;
+
+	spin_lock(&vn->lazy.lock);
+	if (unlikely(!insert_vmap_area_lazy_locked(va, vn))) {
+		spin_unlock(&vn->lazy.lock);
+		return false;
+	}
+
+	/*
+	 * Keep lazy.lock held while dropping occupied tracking so purge-side
+	 * lazy extraction cannot move @va to purge_list during rollback.
+	 */
+	spin_lock(&free_vmap_area_lock);
+	try_init_occupied_mt_locked();
+	if (likely(occupied_mt_erase_va_locked(va))) {
+		spin_unlock(&free_vmap_area_lock);
+		spin_unlock(&vn->lazy.lock);
+		return true;
+	}
+	spin_unlock(&free_vmap_area_lock);
+
+	if (unlikely(!unlink_vmap_area_lazy_locked(va, vn)))
+		lazy_kept = true;
+	spin_unlock(&vn->lazy.lock);
+
+	return lazy_kept;
 }
 
 static __always_inline bool
@@ -1437,7 +1553,9 @@ lazy_vmap_areas_empty_locked(struct vmap_node *vn)
 static __always_inline void
 move_lazy_vmap_areas_to_purge_locked(struct vmap_node *vn)
 {
-	struct vmap_area *va;
+	LIST_HEAD(move_list);
+	struct vmap_area *va, *n_va;
+	int err;
 
 	lockdep_assert_held(&vn->lazy.lock);
 
@@ -1448,12 +1566,25 @@ move_lazy_vmap_areas_to_purge_locked(struct vmap_node *vn)
 	MA_STATE(mas, &vn->lazy.mt, 0, 0);
 
 	mas_for_each(&mas, va, ULONG_MAX)
-		list_add_tail(&va->list, &vn->purge_list);
+		list_add_tail(&va->list, &move_list);
+
+	/*
+	 * Erase ranges one-by-one and move only successfully erased entries to
+	 * purge_list. This avoids destroy/reinit churn and keeps lazy index
+	 * coherence if an erase operation fails under pressure.
+	 */
+	list_for_each_entry_safe(va, n_va, &move_list, list) {
+		MA_STATE(mas_erase, &vn->lazy.mt, va->va_start, va->va_end - 1);
+
+		err = mas_store_gfp(&mas_erase, NULL, GFP_ATOMIC | __GFP_NOWARN);
+		if (unlikely(err)) {
+			WARN_ON_ONCE(err);
+			list_del_init(&va->list);
+			continue;
+		}
 
-	__mt_destroy(&vn->lazy.mt);
-	mt_init_flags(&vn->lazy.mt, MT_FLAGS_LOCK_EXTERN);
-	mt_set_external_lock(&vn->lazy.mt, &vn->lazy.lock);
-	vn->lazy.mt_enabled = true;
+		list_move_tail(&va->list, &vn->purge_list);
+	}
 }
 
 static __always_inline bool
@@ -1463,11 +1594,6 @@ insert_vmap_area_free_locked(struct vmap_area *va)
 
 	lockdep_assert_held(&free_vmap_area_lock);
 
-	try_init_free_mt_locked();
-
-	if (unlikely(!free_mt_supported()))
-		return false;
-
 	prev = __find_vmap_area_enclose_addr_mt(va->va_start, &free_vmap_area_mt);
 	if (prev && WARN_ON_ONCE(prev->va_end > va->va_start))
 		return false;
@@ -1512,16 +1638,16 @@ merge_or_add_vmap_area_free_locked(struct vmap_area *va)
 	if (left && WARN_ON_ONCE(left->va_end > new_start))
 		return NULL;
 
+	right = __find_vmap_area_exceed_addr_mt(new_start, &free_vmap_area_mt);
+	if (right && WARN_ON_ONCE(right->va_start < new_end))
+		return NULL;
+
 	if (left && left->va_end == new_start) {
 		new_start = left->va_start;
 		unlink_vmap_area_free_locked(left);
 		kmem_cache_free(vmap_area_cachep, left);
 	}
 
-	right = __find_vmap_area_exceed_addr_mt(new_start, &free_vmap_area_mt);
-	if (right && WARN_ON_ONCE(right->va_start < new_end))
-		return NULL;
-
 	if (right && right->va_start == new_end) {
 		new_end = right->va_end;
 		unlink_vmap_area_free_locked(right);
@@ -1580,9 +1706,28 @@ occupied_mt_find_hole_window_locked(unsigned long min, unsigned long max,
 		if (check_add_overflow(candidate, size - 1, &candidate_end))
 			return false;
 
-		if (candidate >= search && candidate_end <= hole_end) {
-			*addr = candidate;
-			return true;
+		while (candidate >= search && candidate_end <= hole_end) {
+			unsigned long blocked_end = 0;
+
+			if (!retry_queue_overlap_locked(candidate, candidate_end,
+							&blocked_end)) {
+				*addr = candidate;
+				return true;
+			}
+
+			if (blocked_end >= hole_end)
+				break;
+
+			blocked_end++;
+			if (!blocked_end)
+				return false;
+
+			candidate = ALIGN(blocked_end, align);
+			if (candidate < blocked_end)
+				return false;
+
+			if (check_add_overflow(candidate, size - 1, &candidate_end))
+				return false;
 		}
 
 		if (hole_end == ULONG_MAX)
@@ -1828,6 +1973,70 @@ restore_allocated_vmap_range_free_locked(unsigned long start, unsigned long end)
 	return true;
 }
 
+/*
+ * Roll back an allocated range when busy insertion fails. Prefer returning
+ * it to the free tree; if that is not possible, keep occupied tracking so
+ * the range stays reserved and allocator state remains coherent.
+ *
+ * Returns true when @va remains referenced by the free tree and must not be
+ * freed by the caller. Returns false when the caller owns @va.
+ */
+static __always_inline bool
+rollback_busy_insert_failed_alloc_locked(struct vmap_area *va)
+{
+	lockdep_assert_held(&free_vmap_area_lock);
+
+	if (!insert_vmap_area_free_locked(va)) {
+		retry_queue_add_va_locked(va);
+		return true;
+	}
+
+	if (occupied_mt_erase_va_locked(va))
+		return true;
+
+	if (free_mt_erase_va_locked(va)) {
+		retry_queue_add_va_locked(va);
+		return true;
+	}
+
+	/*
+	 * Occupied erase failed and we could not remove the temporary free
+	 * insertion. Keep @va alive: both trees still reference this range.
+	 */
+	return true;
+}
+
+/*
+ * Reinsert @va into the free index after occupied erase. On failure, place the
+ * range on the non-index retry queue and best-effort restore occupied tracking.
+ *
+ * Return: free-tracked @va on success, NULL when queued for retry.
+ */
+static __always_inline struct vmap_area *
+reinsert_or_queue_vmap_area_locked(struct vmap_area *va)
+{
+	struct vmap_area *tracked;
+
+	lockdep_assert_held(&free_vmap_area_lock);
+
+	tracked = merge_or_add_vmap_area_free_locked(va);
+	if (tracked)
+		return tracked;
+
+	if (insert_vmap_area_free_locked(va))
+		return va;
+
+	/*
+	 * Retry queue acts as allocation exclusion even if occupied restore
+	 * fails under pressure.
+	 */
+	if (WARN_ON_ONCE(!occupied_mt_store_va_locked(va)))
+		INIT_LIST_HEAD(&va->list);
+
+	retry_queue_add_va_locked(va);
+	return NULL;
+}
+
 /*
  * Returns a start address of the newly allocated area, if success.
  * Otherwise an error value is returned that indicates failure.
@@ -1840,22 +2049,42 @@ __alloc_vmap_area(unsigned long size, unsigned long align,
 	unsigned long nva_start_addr;
 	unsigned long nva_end_addr;
 	struct vmap_area *va;
+	MA_STATE(mas, &free_vmap_area_mt, 0, 0);
 
 	lockdep_assert_held(&free_vmap_area_lock);
 
 	try_init_occupied_mt_locked();
 
-	if (WARN_ON_ONCE(!occupied_mt_supported()))
+	if (WARN_ON_ONCE(!size || !align || vstart >= vend))
+		return -EINVAL;
+	if (size > vend - vstart)
 		return -ENOENT;
 
-	nva_start_addr = occupied_mt_find_hole_lowest_locked(size, align,
-							     vstart, vend);
-	if (IS_ERR_VALUE(nva_start_addr))
-		return nva_start_addr;
-	nva_end_addr = nva_start_addr + size;
+	/*
+	 * Free maple index is authoritative for allocatable ranges; lazy and
+	 * retry entries are intentionally excluded from it.
+	 */
+	mas_set(&mas, vstart);
+	va = mas_find(&mas, vend - 1);
+	while (va) {
+		unsigned long search_start = max(va->va_start, vstart);
+		unsigned long candidate_end;
+
+		nva_start_addr = ALIGN(search_start, align);
+		if (nva_start_addr < search_start)
+			return -ERANGE;
 
-	va = __find_vmap_area_mt(nva_start_addr, &free_vmap_area_mt);
-	if (WARN_ON_ONCE(!va))
+		if (check_add_overflow(nva_start_addr, size - 1, &candidate_end))
+			return -ERANGE;
+
+		if (candidate_end < vend && candidate_end < va->va_end) {
+			nva_end_addr = candidate_end + 1;
+			break;
+		}
+
+		va = mas_next(&mas, vend - 1);
+	}
+	if (!va)
 		return -ENOENT;
 
 	ret = va_clip(va, nva_start_addr, size);
@@ -1883,6 +2112,7 @@ __alloc_vmap_area(unsigned long size, unsigned long align,
 static void free_vmap_area(struct vmap_area *va)
 {
 	struct vmap_node *vn = addr_to_node(va->va_start);
+	bool queued_retry = false;
 
 	/*
 	 * Remove from the busy tree/list.
@@ -1895,9 +2125,19 @@ static void free_vmap_area(struct vmap_area *va)
 	 * Insert/Merge it back to the free tree/list.
 	 */
 	spin_lock(&free_vmap_area_lock);
-	WARN_ON_ONCE(!occupied_mt_erase_va_locked(va));
-	WARN_ON_ONCE(!merge_or_add_vmap_area_free_locked(va));
+	if (unlikely(!occupied_mt_erase_va_locked(va))) {
+		retry_queue_add_va_locked(va);
+		queued_retry = true;
+		spin_unlock(&free_vmap_area_lock);
+		goto out_schedule_retry;
+	}
+	if (!reinsert_or_queue_vmap_area_locked(va))
+		queued_retry = true;
 	spin_unlock(&free_vmap_area_lock);
+
+out_schedule_retry:
+	if (queued_retry)
+		schedule_work(&drain_vmap_work);
 }
 
 static inline void
@@ -2119,6 +2359,7 @@ static struct vmap_area *alloc_vmap_area(unsigned long size,
 	va->va_end = addr + size;
 	va->vm = NULL;
 	va->flags = (va_flags | vn_id);
+	INIT_LIST_HEAD(&va->list);
 
 	if (vm) {
 		vm->addr = (void *)va->va_start;
@@ -2129,8 +2370,29 @@ static struct vmap_area *alloc_vmap_area(unsigned long size,
 	vn = addr_to_node(va->va_start);
 
 	spin_lock(&vn->busy.lock);
-	insert_vmap_area_busy_locked(va, vn);
+	ret = insert_vmap_area_busy_locked(va, vn) ? 0 : -ENOMEM;
 	spin_unlock(&vn->busy.lock);
+	if (ret) {
+		bool keep_va = false;
+
+		va->vm = NULL;
+		spin_lock(&free_vmap_area_lock);
+		keep_va = rollback_busy_insert_failed_alloc_locked(va);
+		spin_unlock(&free_vmap_area_lock);
+
+		if (!keep_va)
+			kmem_cache_free(vmap_area_cachep, va);
+		else
+			schedule_work(&drain_vmap_work);
+
+		if (vm) {
+			vm->addr = NULL;
+			vm->size = 0;
+			vm->requested_size = 0;
+		}
+
+		return ERR_PTR(ret);
+	}
 
 	BUG_ON(!IS_ALIGNED(va->va_start, align));
 	BUG_ON(va->va_start < vstart);
@@ -2221,21 +2483,40 @@ reclaim_list_global(struct list_head *head, bool erase_occupied,
 {
 	struct vmap_area *va, *n;
 	bool ok = true;
+	bool queue_retry_work = false;
 
 	if (list_empty(head))
 		return true;
 
 	spin_lock(&free_vmap_area_lock);
 	list_for_each_entry_safe(va, n, head, list) {
+		bool occupied_erased = false;
+
 		list_del_init(&va->list);
-		if (erase_occupied)
-			WARN_ON_ONCE(!occupied_mt_erase_va_locked(va));
-		if (WARN_ON_ONCE(!merge_or_add_vmap_area_free_locked(va))) {
-			list_add_tail(&va->list, failed);
-			ok = false;
+		if (erase_occupied) {
+			if (WARN_ON_ONCE(!occupied_mt_erase_va_locked(va))) {
+				list_add_tail(&va->list, failed);
+				ok = false;
+				continue;
+			}
+
+			occupied_erased = true;
+		}
+			if (WARN_ON_ONCE(!merge_or_add_vmap_area_free_locked(va))) {
+				if (occupied_erased &&
+				    WARN_ON_ONCE(!occupied_mt_store_va_locked(va))) {
+					retry_queue_add_va_locked(va);
+					queue_retry_work = true;
+					ok = false;
+					continue;
+				}
+				list_add_tail(&va->list, failed);
+				ok = false;
 		}
 	}
 	spin_unlock(&free_vmap_area_lock);
+	if (queue_retry_work)
+		schedule_work(&drain_vmap_work);
 
 	return ok;
 }
@@ -2330,6 +2611,7 @@ static void purge_vmap_node(struct work_struct *work)
 		struct vmap_node, purge_work);
 	unsigned long nr_purged_pages = 0;
 	unsigned long nr_failed_pages = 0;
+	bool queued_retry = false;
 	struct vmap_area *va, *n_va;
 	LIST_HEAD(local_list);
 	LIST_HEAD(local_failed);
@@ -2358,7 +2640,7 @@ static void purge_vmap_node(struct work_struct *work)
 
 	atomic_long_sub(nr_purged_pages, &vmap_lazy_nr);
 
-	WARN_ON_ONCE(!reclaim_list_global(&local_list, false, &local_failed));
+	WARN_ON_ONCE(!reclaim_list_global(&local_list, true, &local_failed));
 	list_for_each_entry_safe(va, n_va, &local_failed, list) {
 		unsigned int vn_id = decode_vn_id(va->flags);
 		struct vmap_node *dst;
@@ -2367,14 +2649,60 @@ static void purge_vmap_node(struct work_struct *work)
 		dst = is_vn_id_valid(vn_id) ?
 			id_to_node(vn_id) : addr_to_node(va->va_start);
 
-		spin_lock(&dst->lazy.lock);
-		insert_vmap_area_lazy_locked(va, dst);
-		spin_unlock(&dst->lazy.lock);
-		nr_failed_pages += va_size(va) >> PAGE_SHIFT;
+		if (publish_vmap_area_lazy(va, dst)) {
+			nr_failed_pages += va_size(va) >> PAGE_SHIFT;
+			continue;
+		}
+
+		spin_lock(&free_vmap_area_lock);
+		retry_queue_add_va_locked(va);
+		spin_unlock(&free_vmap_area_lock);
+		queued_retry = true;
 	}
 
 	if (nr_failed_pages)
 		atomic_long_add(nr_failed_pages, &vmap_lazy_nr);
+
+	if (queued_retry)
+		schedule_work(&drain_vmap_work);
+}
+
+static void drain_vmap_retry_queue(void)
+{
+	struct vmap_area *va, *n_va;
+	bool queued_retry = false;
+	LIST_HEAD(local_retry);
+
+	spin_lock(&free_vmap_area_lock);
+	if (list_empty(&vmap_retry_list)) {
+		spin_unlock(&free_vmap_area_lock);
+		return;
+	}
+
+	list_splice_init(&vmap_retry_list, &local_retry);
+	spin_unlock(&free_vmap_area_lock);
+
+	list_for_each_entry_safe(va, n_va, &local_retry, list) {
+		struct vmap_node *vn = addr_to_node(va->va_start);
+
+		list_del_init(&va->list);
+		if (publish_vmap_area_lazy(va, vn)) {
+			atomic_long_add(va_size(va) >> PAGE_SHIFT, &vmap_lazy_nr);
+			continue;
+		}
+
+		spin_lock(&free_vmap_area_lock);
+		retry_queue_add_va_locked(va);
+		spin_unlock(&free_vmap_area_lock);
+		queued_retry = true;
+	}
+
+	/*
+	 * Ensure retry-only backlog keeps making progress even if no new free
+	 * events arrive to trigger another purge pass.
+	 */
+	if (queued_retry)
+		schedule_work(&drain_vmap_work);
 }
 
 /*
@@ -2392,6 +2720,9 @@ static bool __purge_vmap_area_lazy(unsigned long start, unsigned long end,
 
 	lockdep_assert_held(&vmap_purge_lock);
 
+	/* Retry queued transitions first, so they can join this purge cycle. */
+	drain_vmap_retry_queue();
+
 	/*
 	 * Use cpumask to mark which node has to be processed.
 	 */
@@ -2489,6 +2820,7 @@ static void free_vmap_area_noflush(struct vmap_area *va)
 {
 	unsigned long nr_lazy_max = lazy_max_pages();
 	unsigned long va_start = va->va_start;
+	unsigned long nr_pages = va_size(va) >> PAGE_SHIFT;
 	unsigned int vn_id = decode_vn_id(va->flags);
 	struct vmap_node *vn;
 	unsigned long nr_lazy;
@@ -2496,9 +2828,6 @@ static void free_vmap_area_noflush(struct vmap_area *va)
 	if (WARN_ON_ONCE(!list_empty(&va->list)))
 		return;
 
-	nr_lazy = atomic_long_add_return_relaxed(va_size(va) >> PAGE_SHIFT,
-					 &vmap_lazy_nr);
-
 	/*
 	 * If it was request by a certain node we would like to
 	 * return it to that node, i.e. its pool for later reuse.
@@ -2506,18 +2835,20 @@ static void free_vmap_area_noflush(struct vmap_area *va)
 	vn = is_vn_id_valid(vn_id) ?
 		id_to_node(vn_id):addr_to_node(va->va_start);
 
-	/*
-	 * Drop occupied-range visibility as soon as the area is freed, even
-	 * though coalescing/reinsertion into the free index remains deferred.
-	 */
-	spin_lock(&free_vmap_area_lock);
-	try_init_occupied_mt_locked();
-	WARN_ON_ONCE(!occupied_mt_erase_va_locked(va));
-	spin_unlock(&free_vmap_area_lock);
+	if (publish_vmap_area_lazy(va, vn)) {
+		nr_lazy = atomic_long_add_return_relaxed(nr_pages, &vmap_lazy_nr);
+	} else {
+		spin_lock(&free_vmap_area_lock);
+		retry_queue_add_va_locked(va);
+		nr_lazy = atomic_long_read(&vmap_lazy_nr);
+		spin_unlock(&free_vmap_area_lock);
 
-	spin_lock(&vn->lazy.lock);
-	insert_vmap_area_lazy_locked(va, vn);
-	spin_unlock(&vn->lazy.lock);
+		/*
+		 * Retry transitions are drained from purge context; poke it
+		 * immediately so transient pressure does not prolong retention.
+		 */
+		schedule_work(&drain_vmap_work);
+	}
 
 	trace_free_vmap_area_noflush(va_start, nr_lazy, nr_lazy_max);
 
@@ -5023,6 +5354,8 @@ struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
 	struct vmap_area **vas, *va;
 	struct vm_struct **vms;
 	int area, area2, last_area, term_area;
+	int inserted_busy = 0;
+	bool queued_retry = false;
 	unsigned long base, start, size, end, last_end, orig_start, orig_end;
 	bool purged = false;
 
@@ -5061,6 +5394,8 @@ struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
 
 	for (area = 0; area < nr_vms; area++) {
 		vas[area] = kmem_cache_zalloc(vmap_area_cachep, GFP_KERNEL);
+		if (vas[area])
+			INIT_LIST_HEAD(&vas[area]->list);
 		vms[area] = kzalloc_obj(struct vm_struct);
 		if (!vas[area] || !vms[area])
 			goto err_free;
@@ -5170,10 +5505,14 @@ struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
 		struct vmap_node *vn = addr_to_node(vas[area]->va_start);
 
 		spin_lock(&vn->busy.lock);
-		insert_vmap_area_busy_locked(vas[area], vn);
+		if (unlikely(!insert_vmap_area_busy_locked(vas[area], vn))) {
+			spin_unlock(&vn->busy.lock);
+			goto err_unwind_busy;
+		}
 		setup_vmalloc_vm(vms[area], vas[area], VM_ALLOC,
 				 pcpu_get_vm_areas);
 		spin_unlock(&vn->busy.lock);
+		inserted_busy++;
 	}
 
 	/*
@@ -5197,33 +5536,43 @@ struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
 	while (area--) {
 		orig_start = vas[area]->va_start;
 		orig_end = vas[area]->va_end;
-		WARN_ON_ONCE(!occupied_mt_erase_va_locked(vas[area]));
-		va = merge_or_add_vmap_area_free_locked(vas[area]);
-		WARN_ON_ONCE(!va);
-		if (va)
-			kasan_release_vmalloc(orig_start, orig_end,
-					      va->va_start, va->va_end,
-					      KASAN_VMALLOC_PAGE_RANGE |
-					      KASAN_VMALLOC_TLB_FLUSH);
+		if (occupied_mt_erase_va_locked(vas[area])) {
+			va = reinsert_or_queue_vmap_area_locked(vas[area]);
+			if (va)
+				kasan_release_vmalloc(orig_start, orig_end,
+						      va->va_start, va->va_end,
+						      KASAN_VMALLOC_PAGE_RANGE |
+						      KASAN_VMALLOC_TLB_FLUSH);
+			else
+				queued_retry = true;
+		} else {
+			retry_queue_add_va_locked(vas[area]);
+			queued_retry = true;
+		}
 		vas[area] = NULL;
 	}
 
 overflow:
 	spin_unlock(&free_vmap_area_lock);
+	if (queued_retry)
+		schedule_work(&drain_vmap_work);
+
 	if (!purged) {
 		reclaim_and_purge_vmap_areas();
 		purged = true;
 
-		/* Before "retry", check if we recover. */
-		for (area = 0; area < nr_vms; area++) {
-			if (vas[area])
-				continue;
-
-			vas[area] = kmem_cache_zalloc(
-				vmap_area_cachep, GFP_KERNEL);
-			if (!vas[area])
-				goto err_free;
-		}
+			/* Before "retry", check if we recover. */
+			for (area = 0; area < nr_vms; area++) {
+				if (vas[area])
+					continue;
+
+				vas[area] = kmem_cache_zalloc(vmap_area_cachep,
+							      GFP_KERNEL);
+				if (vas[area])
+					INIT_LIST_HEAD(&vas[area]->list);
+				if (!vas[area])
+					goto err_free;
+			}
 
 		goto retry;
 	}
@@ -5240,6 +5589,16 @@ struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
 	kfree(vms);
 	return NULL;
 
+err_unwind_busy:
+	while (inserted_busy--) {
+		struct vmap_node *vn = addr_to_node(vas[inserted_busy]->va_start);
+
+		spin_lock(&vn->busy.lock);
+		unlink_vmap_area_busy_locked(vas[inserted_busy], vn);
+		spin_unlock(&vn->busy.lock);
+	}
+	goto err_free_shadow;
+
 err_free_shadow:
 	spin_lock(&free_vmap_area_lock);
 	/*
@@ -5250,17 +5609,25 @@ struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
 	for (area = 0; area < nr_vms; area++) {
 		orig_start = vas[area]->va_start;
 		orig_end = vas[area]->va_end;
-		WARN_ON_ONCE(!occupied_mt_erase_va_locked(vas[area]));
-		va = merge_or_add_vmap_area_free_locked(vas[area]);
-		WARN_ON_ONCE(!va);
-		if (va)
-			kasan_release_vmalloc(orig_start, orig_end,
-				va->va_start, va->va_end,
-				KASAN_VMALLOC_PAGE_RANGE | KASAN_VMALLOC_TLB_FLUSH);
+		if (occupied_mt_erase_va_locked(vas[area])) {
+			va = reinsert_or_queue_vmap_area_locked(vas[area]);
+			if (va)
+				kasan_release_vmalloc(orig_start, orig_end,
+						      va->va_start, va->va_end,
+						      KASAN_VMALLOC_PAGE_RANGE |
+						      KASAN_VMALLOC_TLB_FLUSH);
+			else
+				queued_retry = true;
+		} else {
+			retry_queue_add_va_locked(vas[area]);
+			queued_retry = true;
+		}
 		vas[area] = NULL;
 		kfree(vms[area]);
 	}
 	spin_unlock(&free_vmap_area_lock);
+	if (queued_retry)
+		schedule_work(&drain_vmap_work);
 	kfree(vas);
 	kfree(vms);
 	return NULL;
@@ -5364,6 +5731,13 @@ static void show_purge_info(struct seq_file *m)
 				   va_size(va));
 		spin_unlock(&vn->lazy.lock);
 	}
+
+	spin_lock(&free_vmap_area_lock);
+	list_for_each_entry(va, &vmap_retry_list, list)
+		seq_printf(m, "0x%pK-0x%pK %7ld retry vm_area\n",
+			   (void *)va->va_start, (void *)va->va_end,
+			   va_size(va));
+	spin_unlock(&free_vmap_area_lock);
 }
 
 static int vmalloc_info_show(struct seq_file *m, void *p)
@@ -5635,13 +6009,21 @@ void __init vmalloc_init(void)
 
 		vn = addr_to_node(va->va_start);
 		spin_lock(&vn->busy.lock);
-		insert_vmap_area_busy_locked(va, vn);
+		if (unlikely(!insert_vmap_area_busy_locked(va, vn))) {
+			spin_unlock(&vn->busy.lock);
+			panic("%s: failed to import busy range %#lx-%#lx\n",
+			      __func__, va->va_start, va->va_end);
+		}
 		spin_unlock(&vn->busy.lock);
 
 		spin_lock(&free_vmap_area_lock);
 		try_init_occupied_mt_locked();
-		WARN_ON_ONCE(!occupied_mt_store_range_locked(va->va_start,
-							     va->va_end));
+		if (WARN_ON_ONCE(!occupied_mt_store_range_locked(va->va_start,
+								 va->va_end))) {
+			spin_unlock(&free_vmap_area_lock);
+			panic("%s: failed to import occupied range %#lx-%#lx\n",
+			      __func__, va->va_start, va->va_end);
+		}
 		spin_unlock(&free_vmap_area_lock);
 	}
 

-- 
2.34.1


