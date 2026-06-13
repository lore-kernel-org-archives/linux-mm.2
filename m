Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7D25CD98D8
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 17:21:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39F486B00A2; Sat, 13 Jun 2026 13:21:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 377516B00A3; Sat, 13 Jun 2026 13:21:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 265A56B00A4; Sat, 13 Jun 2026 13:21:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 12A986B00A2
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 13:21:36 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B8D968DD36
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 17:21:35 +0000 (UTC)
X-FDA: 84875556150.22.19E6F0B
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2931640003
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 17:21:32 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=Hs6ygKrH;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b="hRNKNa/a";
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf12.hostedemail.com: domain of pranjal.arya@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=pranjal.arya@oss.qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781371293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gmDg6wpviGfici5wFw4rRp3TOW9sHNaqJUgICxRvP6Q=;
	b=oO4JnlTh8NzrPZgRpd+IWr2xgdPYNF/CidXENkPJveHQNqNb5Rw0a7+onZ62ftj+V2FuKh
	Ptg0OkHvo47YFIAueaCsluFkGc3G11eVzrlQbMY0nmGzwNJb+oRtZ5mNxybZY0tfOF8QCw
	257Ip60Giu9kIORKvCEW2XcrCJ8XTZY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=Hs6ygKrH;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b="hRNKNa/a";
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf12.hostedemail.com: domain of pranjal.arya@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=pranjal.arya@oss.qualcomm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781371293;
	b=8KXrQ8VznkH5K3tT7XG+8cP0m09VZJrOOd/wZb+QqOefWv5y0ANo00FM6usmU7xtaMgjZP
	MvRHduRXDPpQ9uCTSIuHJHJj77nPd1mU14JNl+SioaQwVY5XIqEQ41B7uxfS4uS2HLRqnp
	7a7CBSzXwDO348sQt3I9vx6o/WKdC4s=
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65DGaQIu2957435
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 17:21:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	gmDg6wpviGfici5wFw4rRp3TOW9sHNaqJUgICxRvP6Q=; b=Hs6ygKrHsfqhLSA/
	y3v+FTKnv6YyTHSt4kUez393vsyDxS9tMSuz7GJlMqGy9X1VFhqDtl+fYRVqU/UL
	4oCC1wpP/zYPctUNGzpUo1WMQrRzlYQlYlkSgMdiEGYNR8cdDr+xiJXR2fRBCp/r
	7EwC+PVQ28p+bs9+38ypxUawOxqMwe+KtoqTCtQ3nNnfwysj5V8iZz08/v/nfRvq
	vZ/LAGISPOExJyT/FRXVXjLROgN1aVQmgY4MqlBOYgFBM1w2nUdykpLO0eYcOHb6
	l1ISlJz08W1pRK78IR8smpIQF/fC0irKLZybRQfjq5LzjL1vnKzaUfBGo81Bm+4T
	Z+MXTw==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4es0g81g5k-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 17:21:31 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-8423f3e4728so1362104b3a.2
        for <linux-mm@kvack.org>; Sat, 13 Jun 2026 10:21:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781371291; x=1781976091; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gmDg6wpviGfici5wFw4rRp3TOW9sHNaqJUgICxRvP6Q=;
        b=hRNKNa/aTDwb3ynZxd/h/PL44VaNv1p50KmroV7MsB0efjBoj4kUrWD0LeX4Av2+IM
         KX3gAZSBXqTHGCiqBOUTD06Gaex3kOb8fzh4EW7zAzswKv5ERPxLqAMLXvPFlV3VPUgz
         3ErrWfAlM7BaBTnGp1mxIbGN716RkKv8HEsR7kkJdqBRl6y4uaYYoIKtQnrwWCjf7yYL
         p2FjPyVVHRStiaJ4Jo13R8qLyR26Z2zBWIL7pTGhjRbIIux5d0T7rhQS2JhjBcRJbuCb
         a8/+AFZk5rDcxM5gKiGL+pC7UhZ5kAgSe/2xhaVyZaG9gwm/p+896lPDB77Rv7yG20iu
         oA/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781371291; x=1781976091;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=gmDg6wpviGfici5wFw4rRp3TOW9sHNaqJUgICxRvP6Q=;
        b=TixLIlfs78dZ+tkie9j02nexCTaBpzT+/TA280mEPKOohHDi3qaYzc9jnN93nZcj4K
         GZmX09sM8H4lywRau9yoJaq1TDwAeOV+KWa+y2jej4fu3hbJyY7yUab5BRWZ+4QFo6U4
         Kgc3ajsN5VAjtGVuGc8P7ZmpJlUHPny5rBWD8t/NjUUxdLRdZbw8djTWCk7p1Y2DKM3c
         AOHkV9W0rA38f15l43QZhgeI0dGyvkqmOuL+cJgZ7SwD93safguyZ6aa8YTMsxmxkeSE
         P4byMYG9Y52WkEf74Q8ulSUcrYKi+aomqOX73XUbJQ9uN/OuThHpQQv0JGea6TFK2K8H
         WiyA==
X-Forwarded-Encrypted: i=1; AFNElJ/tRQlPd/6llhtn6UaKavOCqUgSgNFn7yu61Fnwy50jlgGZE7PxBqZ3FpJbgAJ0N5QvjSowKm+ysA==@kvack.org
X-Gm-Message-State: AOJu0YzvDiStLRdNtS0e+7JaQznGnCyz4f7zud61/m4LEiF58qH9iRen
	L04eXVByT1Db4iDSTs+ic++JaeGGxl1tv7dWEcG7FpLLH4HGr2vAcKEqbJbJ22Jf51GYuP0rGtp
	lBi2unvlCDeIH6Xn7g6VLHTl/u5Kea1PDHqOeCRaBI3CeJEvp4WXpoQ==
X-Gm-Gg: Acq92OHTBPbRvVPW+BMNcfouYGYrDDMk/nFIOntk9GTfLms9id+nphuBHMxhD1REi1J
	zkjscr522CqJWF9GkSsfyhgIKxPNrlBE/LJ8XjTiRwfvkDIsS1rolfGH7lIlgC/IYnwdarGd01G
	f2M4LbXWJc7ZP4CyKL0ydMRtfwN3hKmMH87Cba4X27ThMXA8pPzGqF19937+fNPNZ48ScKOK762
	MAWSYaZCCnON+dfN9K0hm1mb9HOMLhhFAT4YE00Wp4AJHhvv3bYRLrwOIOcBXMmrMZhhaS0XPdH
	wKUOJ6bh2zGNs32m7gp8Eo2zHrI7J4cYVEppk7TfCyA/3wYrACWEwNVqZTpNhipJOLpuSQGHcmY
	fBQVvpFZFvrGYpizz8EJVw0Vx3wmiVH510q51oWeHrJDoddYsyj9jDg==
X-Received: by 2002:a05:6a00:3d48:b0:842:3a98:b34d with SMTP id d2e1a72fcca58-8434ce83f17mr8390916b3a.31.1781371291160;
        Sat, 13 Jun 2026 10:21:31 -0700 (PDT)
X-Received: by 2002:a05:6a00:3d48:b0:842:3a98:b34d with SMTP id d2e1a72fcca58-8434ce83f17mr8390867b3a.31.1781371290674;
        Sat, 13 Jun 2026 10:21:30 -0700 (PDT)
Received: from hu-pranarya-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434accbec5sm5390913b3a.16.2026.06.13.10.21.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Jun 2026 10:21:30 -0700 (PDT)
From: Pranjal Arya <pranjal.arya@oss.qualcomm.com>
Date: Sat, 13 Jun 2026 22:49:50 +0530
Subject: [PATCH RFC 08/12] mm/vmalloc: track lazy-purge queue as a
 list_head
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260613-vmalloc_maple-v1-8-0aa740bb944b@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781371215; l=7702;
 i=pranjal.arya@oss.qualcomm.com; s=20260516; h=from:subject:message-id;
 bh=JrEBDVSR2nkTeNdCYAhWPyaNXTAWBRV/Ax7hvp9FT5w=;
 b=HlA43z7W1BgFHiQdUCJ9NYyv6guSh8B+257WOVr1UNUmQ3utJWN5wVgMVBRX9p2ibCldFaTWa
 7E0Iaid+Gw+AfDte7XbFrrnh/UdH/cFriQdiXtcPQ+ualCVfPKMbz1S
X-Developer-Key: i=pranjal.arya@oss.qualcomm.com; a=ed25519;
 pk=ymtcTlccEIDsi3ErhpjIoZZHKdPBYWGWW0Lchs5MsbE=
X-Authority-Analysis: v=2.4 cv=OOoXGyaB c=1 sm=1 tr=0 ts=6a2d919b cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=LbbEsUlp8jkdcCOz7_EA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=IoOABgeZipijB_acs4fv:22
X-Proofpoint-GUID: AGrrlKI4bFik90XsNOv9BDtYk4rQJeDR
X-Proofpoint-ORIG-GUID: AGrrlKI4bFik90XsNOv9BDtYk4rQJeDR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEzMDE4MCBTYWx0ZWRfX+IDcQWDkN0Bx
 ruiI2TgOrl1Hm6vtG7FW28G/BUk9YesmKOy3JJy/DD/MyYbjFA8uF56KG+YHlcTWK3wCP0/8sva
 ArP3Rb6499NYoUWe/qdc8QHIa2LBtGiawbGtz5JCxK/JHp/mY3PltakCJ9krngPtFseEmuinKLc
 5cLHRe+AgkrCiorbpeI7zKjQ8cwp0HJgbBrZOlMD65CBCw+qY2d1pfphUo67AmhxDvgooLyGZMW
 R/srA3gn6gUu4yW1IqmrVK7LINPId/s3EjZQVnzw87M5fX850Kw4cfRiagsaTR++sLC8K99r0Ka
 xSpI+3sIPAEJSxn2Q0bgSo1k0NUa3YCn6QDgfZGsAcC/6iM7Mo3YzkTs93QibT24Fmc0Y4otng8
 wcvgqlL1DbnlPiICMvs+ckKBCoLfLiWKPtZ7QCkXaL5G5+BIIkLQGzSL69MpAVw1FtVOLfOvq2f
 WZHdb2qLtZa+tqN3fYg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEzMDE4MCBTYWx0ZWRfX3TwEV6Ef7eez
 n9tUnjjgR01p5m0AAVivsjQenTTBjHeOrLIU2ugCuTmBQeEzBoNzFA3XkPCdQgKIwLDQPrFKWlw
 ufShqYeNkN6vHOdvWJHzHaiX7qvjY+M=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-13_03,2026-06-12_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 adultscore=0 spamscore=0 phishscore=0
 lowpriorityscore=0 bulkscore=0 malwarescore=0 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606130180
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: bqrna8ouczifac5ejnzudgomp3ufbcf3
X-Rspamd-Queue-Id: 2931640003
X-HE-Tag: 1781371292-764438
X-HE-Meta: U2FsdGVkX1+7MtVPZWa6495F8hnfLFyvXi4asMoNw5G1hw+R9lcW1dRU1U1nB7/DKPRBzkzbGv6e9Bg2y2I4VzAsd99UDeBeBbewoL6Tvgmw6PhLm7R6inoD3A1x8G7+Zh2E/4VupYXQBaAtE80fxiRJmDunI6xprLF2pebiG3zHavO/T9EMnNu3RfPgl4KqkvokjMfh+KwFHAuOBpkmgcNHXdms7zBb1O7VqYLkBRGOKK5shZgKn/h57V/V6BOdayFnoX2gxUEzYy/H1uHCoPTxqtUAVzVHpLBgMMoVT1Ey8W6IYiTjjNYMZ+tfpS3qTUOgU+Ek79+tIMFvGWWw0yFSDJDlLQoymrRZ2g93/3WyFI+7yyyMdyEiefyoVrVAO54g7NmzzTtF4JVVQKudyuKVChCa2Ur1r8oCRTzEuHE6wxWb/P8IrhxiCxavpHORYpDJ/5FLdNk2p9W3LxeWZrs7NOP7ta57OQFfvcuwQ6LYIkWf4CiZDDBD+1Bg3IOq8dSzGH7PcSknPP8Pud/Zn4cDEH0G9ifQ9JqZJLQLV36t4o9onuYPjIgQJxgtwjo7dQUVXy00lzV+gWeRRGv36sOwqnA2AiF/o5VCHHYbET1f9oGjcXaj5Z3bXxE+FsIz70Hq0SFUUx7rIuFo1AFdHzQF0cWovuBiQ9rCjLBk38S+MTkyL8LVnWDqV7HQq9m3gaNdc4oE7p9NFqfEcStj8wedUbfDItlWFXxeHz74laT+pzGEqeRmuCkkMVJYOANmnF7RuojxUVXgOsZ7w43yxia0mkfSA25QKWEj+Iqr7FoHOWAwFY/01Bx0kFiOm3SxWl7TCZIxBxwIulChpXjpKZ4iuRwJY8xQpi4/mvtxU22KOitKx2i0kPurpqaBqFNe1PcRbw+m1JgHuZX38v/n6cw9Vbkbgjsq3a1mEG/5E7xH+4FW0D2c2hiaK7BF8puY8U1WukHDPnmkF+6oAWZ
 01se/tcn
 2t7DcH0dosvOznpf7spBllPP+oaUzZCdSWARDB+xAHeA7sGkhEgnHBNukkBXlsGZqesa+eyH0Z7OJ/Z42lWw5+m9yY3ka7LMkQQwMYzbSagszm6RyVOcHkD/DrluHjfmJaulMm6YpbAdVJol/SY2kRcMYxsH+aivccihNExVCPtYj5GNXXrumJo/bmfFuMt3C1Tc2GRV3vZnXK2d/m836turHGpiaPAb7WYxFDEbi9w8fGC5I+2ISeo6AAe89kJFFv8KBmdjeZpqvlseuWpEtD0hcP935UmAMVZXmoqHV3N7I0N46LU/uCJUMxqSalRXOITnuzkEsU0Krp25E21mosQIAGif3u0ZhFkhx5dlXnhhO8ILyg/E3tL2EHa2fPEiS9kfXlG/f44WuFQmX7NOVPsOBXtlraw9Lklykz1fk+MOO53GKTaP/fDqA7ncVU574492jydkrLMR8yGmNVyNiWAkkAluVWGrJWUvrpZLMD7w6pHLNaCB/gLykDFFPXQdn7E0Qcg6V3nNbHAJah5aYybBA5V/zWokNZcS2lQS+KRRYHStBA4xiMvRaFtT6wYBM715L1G64C+YkSWwDkGQ8I71OG9KjLPTX6vF8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The lazy queue is bulk-drained from the purge worker; nothing
queries it by address.  publish_vmap_area_lazy() inserts into the
queue and purge_vmap_areas_lazy() walks it linearly.

A list_head expresses the actual usage and saves the per-publish
maple insert.  Per-node vn->lazy.mt becomes vn->lazy_list.  The
locking discipline (vn->lazy.lock still serialises inserts) is
unchanged.

Signed-off-by: Pranjal Arya <pranjal.arya@oss.qualcomm.com>
---
 mm/vmalloc.c | 133 +++++++++++++++++++++++++----------------------------------
 1 file changed, 57 insertions(+), 76 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 73a40a88dbf6..1b73001e197e 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -942,6 +942,16 @@ static struct vmap_node {
 	struct mt_list busy;
 	struct mt_list lazy;
 
+	/*
+	 * Lazy list. The lazy index is no longer queried by address on the
+	 * hot path: free_vmap_area_noflush() pushes the VA via list_add and
+	 * purge drains it via list_splice. Keeping a list head sidesteps a
+	 * mas_store on every vfree and a mas_for_each + per-entry
+	 * mas_store(NULL) during purge. lazy.mt is retained for the rare
+	 * non-perf_mode rollback path inside publish_vmap_area_lazy().
+	 */
+	struct list_head lazy_list;
+
 	/*
 	 * Ready-to-free areas.
 	 */
@@ -1510,52 +1520,37 @@ unlink_vmap_area_busy_locked(struct vmap_area *va, struct vmap_node *vn)
 static __always_inline bool
 insert_vmap_area_lazy_locked(struct vmap_area *va, struct vmap_node *vn)
 {
-	int err;
-
 	lockdep_assert_held(&vn->lazy.lock);
 
-	try_init_lazy_mt_locked(vn);
-	if (WARN_ON_ONCE(!vn->lazy.mt_enabled))
-		return false;
-
-	if (!validate_vmap_area_range_insert_mt_locked(&vn->lazy.mt,
-						       va->va_start,
-						       va->va_end))
+	/*
+	 * The maple-tree lazy index is bypassed in the hot path: a simple
+	 * list saves one mas_store per vfree and one mas_for_each + N
+	 * mas_store(NULL) during purge. lazy.mt is left untouched here so
+	 * the non-perf_mode publish_vmap_area_lazy() rollback can still
+	 * unlink the VA via unlink_vmap_area_lazy_locked() if it inserted
+	 * one — that path is unreachable in steady state with perf_mode on.
+	 */
+	if (WARN_ON_ONCE(!list_empty(&va->list)))
 		return false;
 
-	INIT_LIST_HEAD(&va->list);
-
-	MA_STATE(mas, &vn->lazy.mt, va->va_start, va->va_end - 1);
-
-	err = mas_preallocate(&mas, va, GFP_NOWAIT | __GFP_NOWARN);
-	if (!err) {
-		mas_store_prealloc(&mas, va);
-		mas_destroy(&mas);
-		return true;
-	}
-
-	err = mas_store_gfp(&mas, va, GFP_ATOMIC | __GFP_NOWARN);
-	return !WARN_ON_ONCE(err);
+	list_add_tail(&va->list, &vn->lazy_list);
+	return true;
 }
 
 static __always_inline bool
 unlink_vmap_area_lazy_locked(struct vmap_area *va, struct vmap_node *vn)
 {
-	int err;
-
 	lockdep_assert_held(&vn->lazy.lock);
 
-	try_init_lazy_mt_locked(vn);
-	if (WARN_ON_ONCE(!vn->lazy.mt_enabled))
-		return false;
-
-	MA_STATE(mas, &vn->lazy.mt, va->va_start, va->va_end - 1);
-
-	err = mas_store_gfp(&mas, NULL, GFP_ATOMIC | __GFP_NOWARN);
-	if (WARN_ON_ONCE(err))
+	/*
+	 * Match insert_vmap_area_lazy_locked()'s list-based fast path. Used
+	 * only by publish_vmap_area_lazy() rollback, which is unreachable in
+	 * steady state but kept for the non-perf_mode early-boot window.
+	 */
+	if (list_empty(&va->list))
 		return false;
 
-	INIT_LIST_HEAD(&va->list);
+	list_del_init(&va->list);
 	return true;
 }
 
@@ -1610,48 +1605,22 @@ lazy_vmap_areas_empty_locked(struct vmap_node *vn)
 {
 	lockdep_assert_held(&vn->lazy.lock);
 
-	try_init_lazy_mt_locked(vn);
-	if (WARN_ON_ONCE(!vn->lazy.mt_enabled))
-		return true;
-
-	return mtree_empty(&vn->lazy.mt);
+	return list_empty(&vn->lazy_list);
 }
 
 static __always_inline void
 move_lazy_vmap_areas_to_purge_locked(struct vmap_node *vn)
 {
-	LIST_HEAD(move_list);
-	struct vmap_area *va, *n_va;
-	int err;
-
 	lockdep_assert_held(&vn->lazy.lock);
 
-	try_init_lazy_mt_locked(vn);
-	if (WARN_ON_ONCE(!vn->lazy.mt_enabled))
-		return;
-
-	MA_STATE(mas, &vn->lazy.mt, 0, 0);
-
-	mas_for_each(&mas, va, ULONG_MAX)
-		list_add_tail(&va->list, &move_list);
-
 	/*
-	 * Erase ranges one-by-one and move only successfully erased entries to
-	 * purge_list. This avoids destroy/reinit churn and keeps lazy index
-	 * coherence if an erase operation fails under pressure.
+	 * Move every queued VA to purge_list with a single splice. The
+	 * sort-by-address property that the maple-tree lazy index used to
+	 * provide is no longer used by purge_vmap_node(); kasan_release
+	 * computes its own min/max over the resulting purge_list when
+	 * needed.
 	 */
-	list_for_each_entry_safe(va, n_va, &move_list, list) {
-		MA_STATE(mas_erase, &vn->lazy.mt, va->va_start, va->va_end - 1);
-
-		err = mas_store_gfp(&mas_erase, NULL, GFP_ATOMIC | __GFP_NOWARN);
-		if (unlikely(err)) {
-			WARN_ON_ONCE(err);
-			list_del_init(&va->list);
-			continue;
-		}
-
-		list_move_tail(&va->list, &vn->purge_list);
-	}
+	list_splice_tail_init(&vn->lazy_list, &vn->purge_list);
 }
 
 static __always_inline bool
@@ -2806,13 +2775,18 @@ static void
 kasan_release_vmalloc_node(struct vmap_node *vn)
 {
 	struct vmap_area *va;
-	unsigned long start, end;
+	unsigned long start = ULONG_MAX, end = 0;
 	unsigned int batch_count = 0;
 
-	start = list_first_entry(&vn->purge_list, struct vmap_area, list)->va_start;
-	end = list_last_entry(&vn->purge_list, struct vmap_area, list)->va_end;
-
+	/*
+	 * purge_list is no longer sorted by address (lazy_list is built in
+	 * insertion order via list_add_tail). Compute the bounding range
+	 * inline with the per-VA shadow-release loop to avoid a second walk.
+	 */
 	list_for_each_entry(va, &vn->purge_list, list) {
+		start = min(start, va->va_start);
+		end = max(end, va->va_end);
+
 		if (is_vmalloc_or_module_addr((void *) va->va_start))
 			kasan_release_vmalloc(va->va_start, va->va_end,
 				va->va_start, va->va_end,
@@ -2824,7 +2798,9 @@ kasan_release_vmalloc_node(struct vmap_node *vn)
 		}
 	}
 
-	kasan_release_vmalloc(start, end, start, end, KASAN_VMALLOC_TLB_FLUSH);
+	if (start < end)
+		kasan_release_vmalloc(start, end, start, end,
+				      KASAN_VMALLOC_TLB_FLUSH);
 }
 
 static void purge_vmap_node(struct work_struct *work)
@@ -2938,6 +2914,7 @@ static bool __purge_vmap_area_lazy(unsigned long start, unsigned long end,
 	static cpumask_t purge_nodes;
 	unsigned int nr_purge_nodes;
 	struct vmap_node *vn;
+	struct vmap_area *va;
 	int i;
 
 	lockdep_assert_held(&vmap_purge_lock);
@@ -2964,11 +2941,14 @@ static bool __purge_vmap_area_lazy(unsigned long start, unsigned long end,
 		move_lazy_vmap_areas_to_purge_locked(vn);
 		spin_unlock(&vn->lazy.lock);
 
-		start = min(start, list_first_entry(&vn->purge_list,
-			struct vmap_area, list)->va_start);
-
-		end = max(end, list_last_entry(&vn->purge_list,
-			struct vmap_area, list)->va_end);
+		/*
+		 * lazy_list (and therefore purge_list) is no longer sorted by
+		 * address. Compute the bounding range by walking purge_list.
+		 */
+		list_for_each_entry(va, &vn->purge_list, list) {
+			start = min(start, va->va_start);
+			end = max(end, va->va_end);
+		}
 
 		cpumask_set_cpu(node_to_id(vn), &purge_nodes);
 	}
@@ -6153,6 +6133,7 @@ static void vmap_init_nodes(void)
 		mt_init_flags(&vn->lazy.mt, MT_FLAGS_LOCK_EXTERN);
 		mt_set_external_lock(&vn->lazy.mt, &vn->lazy.lock);
 		vn->lazy.mt_enabled = true;
+		INIT_LIST_HEAD(&vn->lazy_list);
 
 		for (i = 0; i < MAX_VA_SIZE_PAGES; i++) {
 			INIT_LIST_HEAD(&vn->pool[i].head);

-- 
2.34.1


