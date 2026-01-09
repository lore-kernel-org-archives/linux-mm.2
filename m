Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FDFDD232C5
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 04:44:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3EBA6B0088; Thu,  8 Jan 2026 23:44:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEC716B0089; Thu,  8 Jan 2026 23:44:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACEA06B008A; Thu,  8 Jan 2026 23:44:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9825E6B0088
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 23:44:21 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1283458764
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 04:44:21 +0000 (UTC)
X-FDA: 84311183922.12.1F8E045
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf27.hostedemail.com (Postfix) with ESMTP id 714C840004
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 04:44:18 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=h3D7YraT;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=jSy7jj6l;
	spf=pass (imf27.hostedemail.com: domain of pratyush.brahma@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=pratyush.brahma@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767933858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9PMU9ieb1QmCoXo11coZcBcipTvyHbkjE2lSzxbfThY=;
	b=hp0X0kHEIeQzCIMPZCLSGBvIpe++DJ/Srp2sZQqEo/mwHTAHa9jn/wS+oOJnE6LS/cRbj0
	sUyPCmtMg8R7pduUKJ0p/lHonzHeC/ES7twEUUdGr7yKaj2AwTZzTqyY+HNWSlGnof/LsC
	+NMiaDWw3frY7AVYcyenRAiNJAX3an4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=h3D7YraT;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=jSy7jj6l;
	spf=pass (imf27.hostedemail.com: domain of pratyush.brahma@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=pratyush.brahma@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767933858; a=rsa-sha256;
	cv=none;
	b=8dMlzoz20D/nfO1ZZfM68kw0U/EoOWxVc3JpP0sZm5+00x6gvLr2gme9c0DjBa+4UhOL9r
	+QYsE60L8RjnjMUzv1zizoUrSH8KdiTaZ7xDNiyC2zVSW5JXb06Jg1X+7yBBZtLkser7af
	HbZ4iAbZWrP/YExbaGPqkzuf3nwpafg=
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 608Mowtq3219136
	for <linux-mm@kvack.org>; Fri, 9 Jan 2026 04:44:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	9PMU9ieb1QmCoXo11coZcBcipTvyHbkjE2lSzxbfThY=; b=h3D7YraTfVmsM947
	ssAm268Ecx0hciT9Z4P/p3YNMwdJ9No2awOjCMsug+ChBVc941iiP7TldxzGPBqa
	V/JTyEzFcTqAt/HJYh9eGijEQQDJL+pnYzzb/W28YmE68ZBNqijzHFtOTf3rJjvT
	yY4rryx0RtHnbufPqf1fuu5ZQQCQX7BSwlLdaoUNqfQrH6joIplWawpsULAeOloN
	FgIdSEn+3IavIxmfYxdal/UJBXhquwNJP6lfsJb1TZZfuOPohHeVVLRaawdjqMfb
	wB+15Ywi6Usvs4R2Yv6pntwve3M+nZkybOdtMn6YTUAVJojbD+7ImQf8NLT/pOe3
	zPBMYg==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bjjt0h6je-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 09 Jan 2026 04:44:17 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2a089575ab3so46582295ad.0
        for <linux-mm@kvack.org>; Thu, 08 Jan 2026 20:44:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767933856; x=1768538656; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9PMU9ieb1QmCoXo11coZcBcipTvyHbkjE2lSzxbfThY=;
        b=jSy7jj6l17bO7S9ZV7srlGLlnMn3R5x/yLqqOhRyaCQWyC+oAtOXQRRBSId52E1mfM
         69MT3BnL7spAe/qatJ3du0PkHcNcQnxFKEVHYJPQ68FYvqNmMURcj/rk2BzUPiR8WcrW
         4JVMokn0ezfXm4EBA/v8T7Wd5vQt0Bsqpc/8casNs2xIbAHTrIubeRtJHx8yi/m4xst4
         FpYXZXCoaQVlHZVzoKDSddnOUEHaE9i2yrBHVVwxnOukE2/kPIsylk4KBPBIMZfCjXE2
         aIIMzHE/iTuf3/3dzm5yyAysgHdT4tTCvKbRt3QdJ8ewluon9AbLn6F6aGnrtjunQLRU
         dBKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767933856; x=1768538656;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9PMU9ieb1QmCoXo11coZcBcipTvyHbkjE2lSzxbfThY=;
        b=ECbV9KqJCzCuIALaP9o9aQn/HRo/ymXhyImv6OaqrdcfW4NHMbjiGy2otOhwkZvdT4
         hz5LSVuBMBqBHxjY9FEVoYagsGNODdJ5T6eOTmbSz2jD1fpVLEhmJK36Wk6rMJFAwsv6
         teWxfxG3CDTq5ENlT21w1hv1vvUpddEsHutDrHp1m+ZVV9F+zW7QjIDX2gE1fO67Kb2N
         7iIstgWNI2A1fIhEqJHzKUFhBLawqCEPkgOM9iIZ1CEnkp00dTVUqIQeHhXiNuzWrCUJ
         9q1bmuaF4KdVeZyKHl4At5JMPIvVFe0C4v4xeCer1HyJxAn5MhfkRUTz7pQf5CDXuAnV
         HO/g==
X-Forwarded-Encrypted: i=1; AJvYcCX9Nz9ZQgHjDm0r+OEffYF2ai7w/ZptZXsBL99rDqq9PMy0xVunfsmck67ADKzHOiQdVKmajWI47A==@kvack.org
X-Gm-Message-State: AOJu0Yw8ud6QqJu8sZcpTpd8VWluGjAzRGuq8/XUCvLySrrCv7pbChCg
	1AjdtQzTJFvHHKKUeh1PbNqRWLiQFNX/CssYJOzy4nntiyRi/O+MsoPxfM/PphLOqt1iP31tJ2v
	MMxWDoOi5AtHcUAD+j5sPUECS7icRcZSbgZilPGbqlzQoMXzifkzN1Q==
X-Gm-Gg: AY/fxX4dARqJDXFl2UscMMXoWtLzioYw1tV2e5mGTahv33dLEB98pvoOItTuVQuvanp
	IeYVzRBnz1MY1FUX+0oYCiD52BRrND8p8fgtrxAqV07dQQP4X32QNl3v6b/fgsBNfeqMapdRSUt
	6O/ii37CSjfV0fYlhiyY7tBT650u131Huy3ebPEM96mEIGARSTm8bk52EJAER0Qt9C0FHQR2Xb3
	sjohe15cmIdl3OIFmsLztwo2O36pWeUsyHAf6E56B7qJFlJOkPemOeKnKY4MKsrEECbO6bxTD2w
	1+D2DEgo8ZU/i+xvokXUtpF1jry41/MCrrVazjk+kuakn+Mx3dEKJ3mC1GcYa6ycZCJkJMlZiHG
	WqZaiutAIaO+hL6+cPu6fJV2F7/SoAk4nNL0Yn3ooHoM=
X-Received: by 2002:a17:903:a8f:b0:2a1:3e15:380e with SMTP id d9443c01a7336-2a3ee4aae30mr77088455ad.34.1767933856411;
        Thu, 08 Jan 2026 20:44:16 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFB3u+HKizZWgXaPWyivW/bF/qgEHwpzZILB1cDaAISw9tmf93lNmF0fhBODQ2Q/mtucKddLQ==
X-Received: by 2002:a17:903:a8f:b0:2a1:3e15:380e with SMTP id d9443c01a7336-2a3ee4aae30mr77088205ad.34.1767933855925;
        Thu, 08 Jan 2026 20:44:15 -0800 (PST)
Received: from [192.168.1.9] ([122.171.107.71])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3cd2b3asm91438525ad.88.2026.01.08.20.44.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jan 2026 20:44:15 -0800 (PST)
Message-ID: <cb77c9eb-6dab-4147-a0bb-ce488524beb2@oss.qualcomm.com>
Date: Fri, 9 Jan 2026 10:13:11 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] mm: memory-tiers, numa_emu: enable to create
 memory tiers using fake numa nodes
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org,
        axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
        hannes@cmpxchg.org, david@kernel.org, mhocko@kernel.org,
        zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
        lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
        rppt@kernel.org, surenb@google.com, bingjiao@google.com
References: <20260108101535.50696-1-akinobu.mita@gmail.com>
 <20260108101535.50696-2-akinobu.mita@gmail.com>
Content-Language: en-US
From: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
In-Reply-To: <20260108101535.50696-2-akinobu.mita@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: ICoZ1DkUpAd1DJZJ5BC6hyRHxIouxRJ7
X-Authority-Analysis: v=2.4 cv=VJzQXtPX c=1 sm=1 tr=0 ts=696087a1 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=yzROskTkGupuC83a2laO1A==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=pGLkceISAAAA:8 a=gTkrCQ11ykXsVYlltkQA:9
 a=QEXdDO2ut3YA:10 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-ORIG-GUID: ICoZ1DkUpAd1DJZJ5BC6hyRHxIouxRJ7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA5MDAyOSBTYWx0ZWRfXwEVgITcknqy3
 9CdZtT4JFPrDtlQjgensBBNLG/PBlBxYZa01Kf36UC18WpuStlJTKdlZJona1cRogwtboh5xi//
 v6F0Qmk8STkAI1JxstpjXdNUvTNUigSG6Cge/ARVn9da3/PHy07PXMfZJ7pG3rZAIezOeo8KDB5
 fFvybTlraZr1X3OodsviVCetALwXckCJfYrEKQnm4p/nnI9QcB0tb/H7aiYaHt2xFImbb2J0cVy
 S3fv5h359VBzdSRcslBUa2bqBHqDMAGuxxHqy0Tevi4P0L7sKlU1NhQboVCBph8/3LfBRnWpMYi
 qs0b9uB2dmhD8TG8AnrXCdmxA+u7t3vyN7mtDrvVU0aRV2ECey4Txcwq0ijFUIKDG2HBS2dhdjU
 e1ZYs5r9b/0HxzgOyhG6nfcs5LnXGU5GqmGtpih0WonwGrXqyXCOKuQ0XZWZ1vXjgtbYwaQVFIN
 0OhVnTfrsh3BkVLnAoQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-09_01,2026-01-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 spamscore=0 phishscore=0 clxscore=1011
 priorityscore=1501 adultscore=0 bulkscore=0 lowpriorityscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2512120000
 definitions=main-2601090029
X-Rspamd-Queue-Id: 714C840004
X-Stat-Signature: ejjpaug6gxyma155yugtu4moed6hxd5h
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1767933858-432167
X-HE-Meta: U2FsdGVkX1+OaPtla4bHTHDol6k9x407/n4C72b6CvaOYxfAxIi5hkQZBoYX+2r3kMEZV5bijTj3tDOY9YeQarkGInry+VoZPd4hoA4gt+6qiwWUgcmKPMuMnPsGCKyBQ6O3WLYX4ke+KwKhW0Afu3b0HVHnNp0CCd7v9Rj0gCz6C2mUp0/zXzVdpuurf9x6UuEVgaEpHBv8S6CK62CNO5CZdAovZNyOZ7JoVJ9C2kcjh8i9dSSkPtAzbzghWzhR2cyUKYHZ4rFuIN7UBhZofOHrNhr+GbgTzanQlHIq5BYK10sgLztUXaFH3q+ODEAJ0Q5UBto1qHiN9IT48ZLKYqP6eXSx1jOBZACNOE9G1ZdHxyTq4NkIABocYYHyNFaUAetBcRWegSpu5SG6GmT9rLr60y8/28781tcdiT9CRM+wVO8HbTyWB8Y/RvyvspdecApp4ydyDb+Q0xhpDUkZVOoGgoI8iI2rNYLSMpa9ZyRAlJq6rs2naz3HcFJhanx2pUIqEWqO3jUSIvnvmO9BKU+RLhSA4dU4DSKRmJPN3G6ONgWt5gX2Enrz9gn9CbeAAArc6iJNHLk0nRvLcg0Azsy0maHThgX0ONSxkhsGz760oa8tlC46g6yiOifz+jS0kKXZDgE/OCiAIP8wTUAwxlKCp0W+vhJQYBHpDmnawm1QY2GCqew0spbQjokYyG70uhiQrdHWdgjOY70C51nnrdnXVBu8sH5NaOnPBB8PyNIShygH9bTOGPntK3Wf3bX5yx2QpVvXK6YrLXF+pddCZ4EFirE0ZaCZxU6fHMQ850wTSa+k8OkZFjDBSR5QkZX0srmend5a/dxjz6Y+bfZCjTCN55OAtNsbaET4jWeg5ndpPUxpSoCzhdTJ+VoMbWStO1MQ3JnjYBRy+TshKSeMN/W4Uq6kXzd/f3ztFwaomd11RMarfd/L00xCqfWqsGRg+W8yQBPZoLquavHIW7m
 aBjTPy1r
 jLZ4WWjIG4d4JqLE5K/9Ngvass9u6bWkxhKFURkPoZimvajTUP/7qFwFzUs0ouYZr1tfgKvMwJdZiWnVf3VQpfEpFCP8Yob3exu41zhD3Q9PDStJ78YqpVclcyd43N3JMIDwuulJSGfRYi3AeM+MCDZS4MMgJOF1btNC5aWRS+RMG65Cng8FGDK7//qMV6QKHqgMLLveZTDmItjIQRqAuWbWQkLacIwyGCSyEqxFeKpaEDxiJTL9/iYSK0vStwY0SuakK1sARNLVnXTAzsdq8lL1Vk+fjCxDAJgMgkexJi7POmtIUNobAuSA6fJANEMZu6TfoQS9ySxIZTkEv8+t4eC7OvN4ZorNZUTXhYX1LUfW2ddpwwtXWV/O+DfNOXjkBG+BmELGtxMoY/e8MztKMFS8d1RhFzhjB4AWhuMKA29B+bTd6U4eo6lDT1nabg2a9pnGQYmV6TN+D6zo8F4YjycsVpe8boqNse+vMBTW3MWnAoupEh7E0U+FfjfTkWFYwhV9fnRrm7tLsZeZ4gWJA/oDVt0Px6FL1OPvLYtTPigVZgAljKP4NC19Z02NfxVmv+O5ObhJNN2wGOQwh/A7at0sMGVxAFUZfu0HL9W841OciJ6IaPKtkW98Rk7AlkMeJCAA7Ly7PJuo8kAzKEnJa8cV07m0FHZqCHBlJIsvOo/vIpbleJRgrOE2PGgo83/2yOv6xzJZ+5Mghm8KYUq+p/LTMDw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 1/8/2026 3:45 PM, Akinobu Mita wrote:
> This makes it possible to create memory tiers using fake numa nodes
> generated by numa emulation.
>
> The "numa_emulation.adistance=" kernel cmdline option allows you to set
> the abstract distance for each NUMA node.
>
> For example, you can create two fake nodes, each in a different memory
> tier by booting with "numa=fake=2 numa_emulation.adistance=576,704".
> Here, the abstract distances of node0 and node1 are set to 576 and 706,
You mention 704 in the cmdline but then mention 706 in the following text.
Please correct the typo. Btw I am not entirely sure if this example is 
required
in the commit text here. The Documentation seems to the right place for 
this.
> respectively.
>
> Each memory tier covers an abstract distance chunk size of 128. Thus,
> nodes with abstract distances between 512 and 639 are classified into the
> same memory tier, and nodes with abstract distances between 640 and 767
> are classified into the next slower memory tier.
>
> The abstract distance of fake nodes not specified in the parameter will
> be the default DRAM abstract distance of 576.
>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---
> v2:
> - fix the explanation about cmdline parameter in the commit log
>
>   mm/numa_emulation.c | 26 ++++++++++++++++++++++++++
>   1 file changed, 26 insertions(+)
>
> diff --git a/mm/numa_emulation.c b/mm/numa_emulation.c
> index 703c8fa05048..a4266da21344 100644
> --- a/mm/numa_emulation.c
> +++ b/mm/numa_emulation.c
> @@ -6,6 +6,9 @@
>   #include <linux/errno.h>
>   #include <linux/topology.h>
>   #include <linux/memblock.h>
> +#include <linux/memory-tiers.h>
> +#include <linux/module.h>
> +#include <linux/node.h>
>   #include <linux/numa_memblks.h>
>   #include <asm/numa.h>
>   #include <acpi/acpi_numa.h>
> @@ -344,6 +347,27 @@ static int __init setup_emu2phys_nid(int *dfl_phys_nid)
>   	return max_emu_nid;
>   }
>   
> +static int adistance[MAX_NUMNODES];
> +module_param_array(adistance, int, NULL, 0400);
> +MODULE_PARM_DESC(adistance, "Abstract distance values for each NUMA node");
> +
> +static int emu_calculate_adistance(struct notifier_block *self,
> +				unsigned long nid, void *data)
> +{
> +	if (adistance[nid]) {
> +		int *adist = data;
> +
> +		*adist = adistance[nid];
> +		return NOTIFY_STOP;
> +	}
> +	return NOTIFY_OK;
> +}
> +
> +static struct notifier_block emu_adist_nb = {
> +	.notifier_call = emu_calculate_adistance,
> +	.priority = INT_MIN,
> +};
> +
>   /**
>    * numa_emulation - Emulate NUMA nodes
>    * @numa_meminfo: NUMA configuration to massage
> @@ -532,6 +556,8 @@ void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
>   		}
>   	}
>   
> +	register_mt_adistance_algorithm(&emu_adist_nb);
> +
>   	/* free the copied physical distance table */
>   	memblock_free(phys_dist, phys_size);
>   	return;
Best Regards
Pratyush

