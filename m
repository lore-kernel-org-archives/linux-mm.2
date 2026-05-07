Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0ECE5CD3442
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 10:40:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F33DA6B0088; Thu,  7 May 2026 06:40:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE4A66B008A; Thu,  7 May 2026 06:40:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAC5C6B008C; Thu,  7 May 2026 06:40:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CA5C66B0088
	for <linux-mm@kvack.org>; Thu,  7 May 2026 06:40:22 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 187C81604C0
	for <linux-mm@kvack.org>; Thu,  7 May 2026 10:40:22 +0000 (UTC)
X-FDA: 84740279484.17.5309EFA
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013005.outbound.protection.outlook.com [40.107.159.5])
	by imf22.hostedemail.com (Postfix) with ESMTP id 34D14C0014
	for <linux-mm@kvack.org>; Thu,  7 May 2026 10:40:17 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=OYP7bZEi;
	dkim=pass header.d=arm.com header.s=selector1 header.b=OYP7bZEi;
	spf=pass (imf22.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 40.107.159.5 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778150418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SMY8xqiAJj3aREpn71Gc+POd6OXiRMj2j6fq8zEFEnc=;
	b=t10ygb8PbiiNt6JrFjZKQCIhQmuTbL90XdjcTad2suSiPMlC46I42s9onCj84k8KjVne8w
	LJEEa8BF10jsJcowMu+MFOi2zzrnCEbaMOtkqXFhL01z2amTWEN2K15KXXOEhIoBLSeVOk
	WKG5KeDcVKJt/zQCS6tLWwm+I0mdsew=
ARC-Authentication-Results: i=3;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=OYP7bZEi;
	dkim=pass header.d=arm.com header.s=selector1 header.b=OYP7bZEi;
	spf=pass (imf22.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 40.107.159.5 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1778150418; a=rsa-sha256;
	cv=pass;
	b=pe1/8ODQ9GszDfU4m/DWpMIYvNMonfbRKy3O0a49S3s/ry7ILlK2PWPUNmp4LALliXVAX7
	1sVV+kijMTTl9df/j128tDrygyiGOHTZSLjSo99W1gtCNpVA1EKinkl3ZvSoWzUJxBVWk5
	qN70gYmWqf4QB/8bQ/8TswQKZlISVNA=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=n6A8UCVA2b8Uxos3kF+4Fc2xWdexeSGpg7bclnRef5EqQXo0bKUSNmvbOyHAgXRyC6ubdmvbxfIKjnRt+I4yVg9e0FJ5wwhY7EXPVtMQff/jC1tX5YId8uGT4VpCZq90XwBd7eYpNGQxb06tOeTuAGwKUhhzE0uC0IlNbm9435dR/1SP5usUHiLvOcsPH6RvDJvQRk+HoizGKP7AOVRBcWbGjDHxcC5wemXG4GxbBol1osFMNGY5OtPeDC0hiawwqucylndXQ9dk8bm5ya4xtEJbtRMwNyELQ5ffhDSWGtUhJ/O4g2tr4H6qb0UtluCvdsDdb6wr0Vn1PeIdDqQnKg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SMY8xqiAJj3aREpn71Gc+POd6OXiRMj2j6fq8zEFEnc=;
 b=lDRQH54yLPO4ZlZlN9S8vnYIXQFoNBWwX5zwBGFX9Eu/2jccrrZWzkDdiYS6MSmTP9g31WSItPwpA6n8Kx8IJjEK4j2gSjipPHHTdsergunEOGgv9f4CppXtFxZ5kMJ/GPqQpM6+1KRt2rJTTh36EEYZo7O4+H5a3z/AlZIyTbMN9Jd7GUgWO6W/SL8cRSXAU6+8cZE3Z3krWGKI2cmPxgQWX3qOBQzr06zj8dG0u9DaeoEvwc7wvZXgD9MJmEVouBfzE8Z6lqf2tAADfPvvXvqvE6h7FGZ5BmzCeacx1WroyiNVZ5zX0beiJ9LVCaQOUdIFmVIpPAP0qcE/tbmhRw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SMY8xqiAJj3aREpn71Gc+POd6OXiRMj2j6fq8zEFEnc=;
 b=OYP7bZEiOTxqTcPh0d6UuhQB/YeDuMw6JrSb6TKLKQJDfhq5cFmHJZK0PExjA9mLpbAdBgaeFP2dHSGYNDJTDTAcy+6Ia+3OtmcTNuhTzFLgLZbvGcf+NFPPa6DTr6jmQNQY1FmELt0o4KJ+UsHoSNTi13uK9e+ST6MOWooMu7U=
Received: from AS4PR09CA0001.eurprd09.prod.outlook.com (2603:10a6:20b:5e0::7)
 by DU0PR08MB8423.eurprd08.prod.outlook.com (2603:10a6:10:405::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.15; Thu, 7 May
 2026 10:40:08 +0000
Received: from AM1PEPF000252DF.eurprd07.prod.outlook.com
 (2603:10a6:20b:5e0:cafe::b8) by AS4PR09CA0001.outlook.office365.com
 (2603:10a6:20b:5e0::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9891.17 via Frontend Transport; Thu,
 7 May 2026 10:40:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM1PEPF000252DF.mail.protection.outlook.com (10.167.16.57) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9891.9
 via Frontend Transport; Thu, 7 May 2026 10:40:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=izdnoq+ptEwhu6g9fYOBh6Qy9S7QWIGEgTBTVh1ArwMcNpmFzFIP1oyXLMdB2pEw3lSUJEJ7ozEBG7J3DsH9gTOSSPDgUHtD+wIr9yCEONjMZHVZZbeA/IolDg27VH5TEk7NS0pcM7x+qVvPgTP2Q/O0Vf5WtXRp+4tpV9EUvWTQM8IYGT6kcQXhpe/rCEeNnDG5vsHtd2RUgquIKvaat8e6c1/pk0ZLfjgx+IXRVAfRXZoTIo2vje4NUQJ9vEZmYL/nJYD1XPQcQr4E4Poj5fuedwV4jW8G+ttpQyr9d2Hd/3Lgss0AwxxcLaq2G17mymS2wcEv86Ex9lWcCOQy6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SMY8xqiAJj3aREpn71Gc+POd6OXiRMj2j6fq8zEFEnc=;
 b=iZmBKemxKRkv6RHfFtJyf8F4lsLMUDlU8CVcn7TdTvKgmWYELL+kJ064uGKH5JjBwBwU5HhUgIoQ+8+UJO8vXr8HI9IzsN2916unWJFkI12jz5J6oSsq7FRyw4S85H7XDmddCKP1Jvvst7AjCMj2IodLh99S660cUxhxYOkGezwRxLCWMUL67K/JAndeu6eKNL0M+GPHfx5hGe+6NfpxAHtI5WCST9N7MdBGX5q4GdMVNSbaZp7O+nl58hVOALnQrtjLec4ZBal3V4nNa0FP3LA4YOiODy27TO8ggQ+hx1/01Ezf68FnGRlQ3Ebw9JOhy1fuHM/IM0Z+RJXwgayWvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SMY8xqiAJj3aREpn71Gc+POd6OXiRMj2j6fq8zEFEnc=;
 b=OYP7bZEiOTxqTcPh0d6UuhQB/YeDuMw6JrSb6TKLKQJDfhq5cFmHJZK0PExjA9mLpbAdBgaeFP2dHSGYNDJTDTAcy+6Ia+3OtmcTNuhTzFLgLZbvGcf+NFPPa6DTr6jmQNQY1FmELt0o4KJ+UsHoSNTi13uK9e+ST6MOWooMu7U=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by DBBPR08MB6267.eurprd08.prod.outlook.com (2603:10a6:10:20d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.17; Thu, 7 May
 2026 10:39:04 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%2]) with mapi id 15.20.9891.008; Thu, 7 May 2026
 10:39:04 +0000
Message-ID: <0e76d61a-3695-4fd7-8270-f4b9537b9b1c@arm.com>
Date: Thu, 7 May 2026 16:08:55 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 39/54] selftests/mm: hugetlb-mmap: add setup of HugeTLB
 pages
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lance Yang <lance.yang@linux.dev>,
 Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Luiz Capitulino <luizcap@redhat.com>, Mark Brown <broonie@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Nico Pache <npache@redhat.com>,
 Peter Xu <peterx@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Shuah Khan <shuah@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org
References: <20260428204240.1924129-1-rppt@kernel.org>
 <20260428204240.1924129-40-rppt@kernel.org>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <20260428204240.1924129-40-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5P287CA0275.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:1f2::13) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|DBBPR08MB6267:EE_|AM1PEPF000252DF:EE_|DU0PR08MB8423:EE_
X-MS-Office365-Filtering-Correlation-Id: 880ae6dc-c7ba-44e1-d494-08deac250220
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 ZgB5hamRHTPBBpT9s+ATPityogT+f61z9X0ZT4bhQh82cbe3x3P5oUtVmjAZ4XTkRUWSP5KD11yWfIV+XEwBLNVW8TWXntomA4r8ODqsa594s/74hZFuGKeLkt32M0wsqrn5SwvyeQRQ5hkTl2+l7tzQoGNKtexO2xcN16B6VIr3vRoBgmPBsDzwKe7a+9PTCs5jP92JHb6hHRzkMEVctbzUiVadPRIAEipWEm+5ROw3vWwXf8LA+j04k+biAWaY7WONKveKt9A9U3XWPtMCO0+aO36NTRDzMbHM5R0/aMME/JrxIQnpri1TkgPryl+3t9Ip4Xz+2hxJwYe0ih7wN6zx9XEsL2Cf7SohXG0ucFsYkNKfk0iOT22bvSRORiDPpZaxticliGYOuLIicW0nMuGeWxJ9vJLXEJR7B0v3/JBf1htd57VmcqJaMJnNLKxXJX9jTXh1pqrNPNJQcs7Xsh12bAyoLun7TIVVI52dmDe/9KTfo5ROcq76BBeLx9RxH45rmdwseXOG5J5O1d4wZSYzIxcYyktAAhrfCpuUTRLqVKy6LgBpiSeSNqm/5e0vHy+5XGT8W5iViYfVwO1CyZo7VMje290yxxjPyQbsuQNVcxGMMKDOPgHKc6JzEhD0beTCTdA4ZB8sp/8gfQWdCvCJmrteYJQbw7UE6LKa061Wc37JEgmu8szhRI8/KkS/
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 b4m3Q+w92udWgJU9Vq+hsUpqk/MypFfaW9syrsEPbdMq/AmbKT1zdwOWwsjgGlS0go4mxt8n9ekw7hlNpS6s20BM7VWBumyp8rMFpV7NukaRUgRQUYIG3t1+w8dFxQBJwk5xDPdBuMuc8MJrBawztutxuSCpahDtrKio0N+m+15744rf5htQdKa6pXDQlSXHhCbRudU9EHDGIuKHllmLe8OPFa5SaXIsk1K/AejZrkA2OvmjMs8tWhxT7BqbZfsRUtYY9ejdDanGpoOXkXqyRlgC3m0JPGZtcTWcGO1SC9niK2WUmKtLH3RZFHtBuFr+AQSOH4SPkoBG/ZsPzj1Kig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB6267
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM1PEPF000252DF.eurprd07.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	ed13bc10-9309-415f-2e0d-08deac24dbb6
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|7416014|82310400026|14060799003|1800799024|376014|35042699022|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	3lHPw2+VDuZNeKreFx05VDjCYGyepufVToQXGg7DC2VV3OaTj0UqBUbJYc02n2P5kBAx2r+MGFg7N+aLo/FUyXa9LTjoev0YOMpv8g3jout+dWGqWEtFD+eSQihk20GHi+U/GfzPXd4uVbseNoOKgKrQndhAxJAozoH2zIN6DMV8L6nbFfSjvbS4Bs54YXXSy5H1GJ8oBka3+q9wQrnJTeWhxMUqpWKnf73M3VubxAvTWVDBbtu6SOnVn4AB907suE8r6Tu4Qo4EK8ZcfwtTD/pnpcIpBYAlRcoJfmNWH00MC1tOXMdiOw///waurIBY8hQwKWE9RnkCLDKyKKSLvVi4SV0SR5+oaT2lDuYNNVS+0uoSD+CCKMDMdEVi5vzRSI0SjBs8WTeg6qO4zyhIPFYVUu85XxswX+10runx6VDuoo+hyzNVZH3KId1GTt/fPVqMy+n+BhzL+3AtvT2uH1KH6huJT76hqIY52GiCnJenm//hC7mLEgY1AomItxQf5rKjdfK4eSMx0yMQ6VYmLRpy/Y75kiMzz6tsCnp4Y9J/ub5KLcmkOuDGGhCjfuPFYeGSHNsDeNSQhQb9S9vNmBtixciZ0V/yrofRhp1N0gLFxpIOKW+BCHdhAmXC6Vv8dag4+xcfUmLXi2BS4tlrmYVF+4p4I/eiADl3DjDhQVswUPAO1GgR/ZfKfThAvPWlgx15uHSCt/w6kWjawwluXdxu+q4Snr2H7XwVNqhgrXY=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(7416014)(82310400026)(14060799003)(1800799024)(376014)(35042699022)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	jmGEslzJfmtWnWSfZzKbMf3r81r2Tjb2p2Q+L2C2JeuVKk2OFBh762fR5WPe5B798tl39kEcicAqRPevcHlK17SBclQgKyf2ICpS2T+APOOZX4kvNkrJSF7JVH1Ej6dOskrbXtxALN0ru3vX1y4frgbOEkLjwz7fABwET3P0utxN4Z2dn+6QcV9ydTtSkx36DRTGAF7Mcl7rs8iwXwhNl1s5LJvStFCGx4dzNmqAusZwx6cc5RLH27TYc8bMHmIQBhwGSQ95uZwnU1/cAk9utJE/7ariNWJcdFVx0YB0mXj8ByW4SlCjTpCwZujy0EjyJ/n4ggAeXxV8MrcEyTS7MHwkf0A2fDhvKagdQ+LuA2XzhC7OABWfSVYpcEzYJFhCp5wsEyaDvmFx7r6m1C5u1MNLZwhtcOeSL1rurQBdiE35+X+3vzOszkR+2XJlrLUv
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2026 10:40:08.1621
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 880ae6dc-c7ba-44e1-d494-08deac250220
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM1PEPF000252DF.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8423
X-Stat-Signature: kqwro513d1zcekb9wdimqnbp4crtae4s
X-Rspamd-Queue-Id: 34D14C0014
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778150417-905193
X-HE-Meta: U2FsdGVkX1+VTgUE/T1+dEb/14XCgpzY5IcwOPXD+iSobSQOdYZEs2ZgRmoIeY9lR63cY6Xl4KXO9c3XyO6tHUjS4d9Z9GF82ntmTBNVJpAC38YSgiGszfqqU4Hmj9gSJA7yowcq0n1bvRb6szomycotXYfl8M5+4CJk8PkBCO5N7nJ8OweOIfNjLWdlqdrX3oPVkWQkpMkBnivYMKOdj4/qUI6Mzn1FXL03+AX+YbKidmjHEOwE3+KoSPgfgW+7zbIZrog1LL191wbc1GhXFfCsTgODN1aj5WiCpp7/XUboAQUNuvrYzvjZNFzLRvuEHTb1z/nGcjzzGN/ioAgFzIH0xRP6rII0dnoaA+4Q1ADSW2wqfes+GWDxRHJNBc5DbkYXapAyqKNG2/5YjNZ4jQXYZAHh7lOavoWpCr37curq/j52aJpAmt2xk0JW7bGtDmgzMkO6IDzzY0w+hPpN9oX7zkAg7ZNLf4WgkDcCiOxB/arYZMZevBcmbPH+/f2KVr9sJgv5+t8QS7TET1mQOYd1vr8cxwcuSwv4j4f70U6e/fGT9VxXYBeZnHAk/tWLdoVmD02LLIwkdAX+KMBjuvLiIRGBYF9GBy7g+1lcwpQy8mNnMUM/5gw9eADOpMQIBw0M2xuVtXN92E+t0kXyrpHo9pUtcR4UBCTwXVhUsaJp4a0EIaHcBJUAAqsdPguPKK7xhL3CERwnQbB3cKISnOUmy8ONMXjeTxGoqcR3A027IA/PF/fMLm6PLqTAjm7hLgyqCRHT8uJz7/E+6U4ksKfXn5/UEu3CIgRGjSmLjUk6r606yZ+HahjtkmdQ/aP30jZ4BYwjNt8JsNbcDdtg9uK9xHi9AR2moWnibQ+lZqt8XxIA9eVuYizNMk+cdnDVoL8L9ysci+VEX6ZZjJQVOLO/EkJBvCyOHmo9gLnt0CD5WxPez2z8pmidSqDWaoa/CXKe/Vp8CF3HSuR+Jeq
 OJGp1rJH
 mnFtZom4tda4pzlfJ13kFF3fN6US7xUvx5lr+zIEUCX0/e23pG4sNf6ujevKUtME2iQHQ0D0CxitQ9GpQG/+6cCyTWzLCPreZTeUIMgzaAoKpwiUqMDW6fC8FzV64mkXVUZ8OMoHVaJVQCUCMJH59eOGqIP4jT6pCbhq4eDnJa12hg9Y1q8MSWHNgrNO5MNtGRr6REnORHypj155DgOPCRmYHZHCtAp81tCvzuJH432Ksd4qHhnOyjBi5OfeS7cipHvtFh1eZl412zh6529RWNl4hue1FJe1mAGlog0nTMYpvyjt4atp2QQNvspRrSi+CX18iO64OCOUT/TTIgNxnYO5JlIhPxLQKCYkl24J2jglGX9EZ+EEF9LZ2r0EyW+2uuNPBQTBE+ilEuvNuEg/rtOzTXbOtgHJjojMiT9fVSWaDuCcG2mQuS+1d1dlVV04UDHw9PlxwzvYT1UGDCHmc7iQkTastDeXHzXylv1lbJBAY04yYNKAUkDBFEkh1hi+yJ1u8Iu6Q6W7DzhdIEGQPd12CDPZTgf/gvfE5q+pFjGa6E4sw5dp/XvpGfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/29/26 2:12 AM, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> hugetlb-mmap test fails if there are no free huge pages prepared by a
> wrapper script.
> 
> Add setup of HugeTLB pages to the test and make sure that the original
> settings are restored on the test exit.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

I have run the test before and after applying the patch. Before the
patch, the test bailed out with mmap error if hugepages were not
preallocated. After the patch, the test correctly allocates the required
hugepages and successfully passes.

Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>

> ---
>  tools/testing/selftests/mm/hugetlb-mmap.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/hugetlb-mmap.c b/tools/testing/selftests/mm/hugetlb-mmap.c
> index 031085cb7d17..f12fc288ef4f 100644
> --- a/tools/testing/selftests/mm/hugetlb-mmap.c
> +++ b/tools/testing/selftests/mm/hugetlb-mmap.c
> @@ -109,16 +109,16 @@ int main(int argc, char **argv)
>  {
>  	size_t hugepage_size;
>  	size_t length = LENGTH;
> -	int shift = 0;
> +	int shift = 0, nr;
>  
>  	ksft_print_header();
> -	ksft_set_plan(2);
>  
>  	if (argc > 1)
>  		length = atol(argv[1]) << 20;
>  	if (argc > 2)
>  		shift = atoi(argv[2]);
>  
> +	hugetlb_save_settings();
>  	if (shift) {
>  		hugepage_size = (1 << shift);
>  		ksft_print_msg("%u kB hugepages\n", 1 << (shift - 10));
> @@ -128,9 +128,14 @@ int main(int argc, char **argv)
>  	}
>  
>  	/* munmap with fail if the length is not page aligned */
> -	if (hugepage_size > length)
> -		length = hugepage_size;
> +	length = (length + hugepage_size - 1) & ~(hugepage_size - 1);
> +	nr = length / hugepage_size;
> +
> +	hugetlb_set_nr_pages(hugepage_size, nr);
> +	if (hugetlb_free_pages(hugepage_size) < nr)
> +		ksft_exit_skip("Not enough %lu Kb pages\n", hugepage_size >> 10);
>  
> +	ksft_set_plan(2);
>  	ksft_print_msg("Mapping %lu Mbytes\n", (unsigned long)length >> 20);
>  
>  	test_anon_mmap(length, shift);


