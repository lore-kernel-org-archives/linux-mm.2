Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9198CD343F
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 12:12:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D4CF6B0088; Thu,  7 May 2026 08:12:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AC0D6B008A; Thu,  7 May 2026 08:12:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29B4A6B0092; Thu,  7 May 2026 08:12:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1DB0C6B0088
	for <linux-mm@kvack.org>; Thu,  7 May 2026 08:12:16 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C27FF8CACB
	for <linux-mm@kvack.org>; Thu,  7 May 2026 12:12:15 +0000 (UTC)
X-FDA: 84740511030.06.B6250E0
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011038.outbound.protection.outlook.com [40.107.130.38])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0110E1A0016
	for <linux-mm@kvack.org>; Thu,  7 May 2026 12:12:11 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=TAre95a2;
	dkim=pass header.d=arm.com header.s=selector1 header.b=TAre95a2;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 40.107.130.38 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778155932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bzK59wRq4zR/HCMQOlXgmdxFKRdA7gCmz2OJNANtr6w=;
	b=f3/SiETXbD9SZH+keA4nplaOiSYGTz17lzqFQS8J29FZ/B4/qfm/TIgaGet2grv/2xOrFy
	rMoC8FKGRO0nPt0cX1jN5A7yDh39ZKjoWpPDDskgs8MVbgT0SdSelT7W/wD5rCl5/5a2ld
	NGNdjqrps7fHF24AbBA5FH8YBJ5cS4w=
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1778155932; a=rsa-sha256;
	cv=pass;
	b=HvIlIUpum9nftgeEIRmjOTchEORVy2V68eVFi/Z6Fye+SCS+U0pEKwKhXFdm3V/JiCY/GG
	P06qSY9pyH/s0Qj47JUtOKWyRU1EtWIBFI9YmYUtlYMFta/4yHSH2+sQncA8FIHw1AcMlh
	cCh4Q2SoFTg2D852UGzF3y1lznVHIfg=
ARC-Authentication-Results: i=3;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=TAre95a2;
	dkim=pass header.d=arm.com header.s=selector1 header.b=TAre95a2;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 40.107.130.38 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=dLUBF9k8jTgy4HhNK+dB0e6DxW4uWAT0eG+AGgnUH6jphFdbPYC6MVc+niTe2RKjcf3Agglg7/TX8M+k2enRbr8sUwAbeJIsTJ1OWIjAcqamiE3eCayFOXrxIOVF+U3El49V0ifigkCnzdUc1smPacVgIdXrUZvyStY/iPkE/fFncgYww/7lFF3SkggutvolzDhgAoD8drQeexbE9Aoq+ykMEj+lKWdFDgEi6Mj4kFkk7U/5+kXrS7g4P1+Y10qAvrh98T0/Li4L2y1MVpFsB831sgKCccDGfqPiTIxtM+r4h2k4cgacQN8EH6mIyqgGYLeDXW6sPPaxVwwBGBNM4A==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bzK59wRq4zR/HCMQOlXgmdxFKRdA7gCmz2OJNANtr6w=;
 b=w8e3ImwVMirtwKL242B71w/fk70avKFRvn/AyidIZurzMWgRb5MQELE0ws+7FfFBo6RtRI3pwRx7Gwiutp45zZq+5lwMOZeKSnN5xKYKkAMTOvzBfDC4e2t1lUqMSuolHh81eBWl20N/9ptXAN6JDrS4nfG4t7/+PRnDdrCyY7YGnOkeZHnU6PXP1whfBygfTtxaXRRrNDykDyQWZIDhCu+WeIbZSKrUBx23L/z7g2UorRjGtE9h5GhS9/KI81NfDPYPVUpz6rE9fhwCmSCo8Flnfglo6ip33gAiEhz2msxNvTv/E86wHuyTPTMuiaDZuP9H6TNLsGymc+1boIdNFQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bzK59wRq4zR/HCMQOlXgmdxFKRdA7gCmz2OJNANtr6w=;
 b=TAre95a2LC3Qe8WzmLZtnSd3806XKv21N5QbwkJLMshrP1qBFCqdORDnB7+iVYobc/d6RO7AC4Vph8vOmdEwJAAAbvkjc4oKWB1HhzX78pxA6h14Jo2oQrF5Y1/mNc5ObuibRra7TFu5EarkOWplhg1USSDawLRZbYvehSwsxB4=
Received: from DU2PR04CA0035.eurprd04.prod.outlook.com (2603:10a6:10:234::10)
 by VE1PR08MB5741.eurprd08.prod.outlook.com (2603:10a6:800:1b3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.15; Thu, 7 May
 2026 12:12:05 +0000
Received: from DB5PEPF00014B94.eurprd02.prod.outlook.com
 (2603:10a6:10:234:cafe::ce) by DU2PR04CA0035.outlook.office365.com
 (2603:10a6:10:234::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9891.17 via Frontend Transport; Thu,
 7 May 2026 12:12:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B94.mail.protection.outlook.com (10.167.8.232) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9891.9
 via Frontend Transport; Thu, 7 May 2026 12:12:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hrTDQcm67S1A6s+AzzsHDBk6Kud9r+kpQQShTNE+VZuKOsygIdpR90Csuqnjk7V9tTUMVwOMBdl15cpdzD1aJN/eT7gyOiwcwzHIPmcpOEMVlmtgR8/JrQOMj7pt/GaL+Ws+cBlKZdB7YDtAPyQY9YSifYiZi30wR2vV5bJO4zPG8YW6jfexM1vBDk7BsNuvzDVXkZR81DZWOaUzFsJeEI2sVzxV6C69yysM7X7hoBy9VMmK5PXiFVD2NLg3UpVJOTv8F/6N4xYL9WtN7zyNhTRLzvoClBs2Be7+ThU4ZTcSibJ/KYFBOROcT6b8Rk8qv0bkEx3bdXiuhVC2NQL1HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bzK59wRq4zR/HCMQOlXgmdxFKRdA7gCmz2OJNANtr6w=;
 b=MJSTnt2XTBCgbTZzvuIk/PA0OL10LssuTWjTkmJi4ZkeQkA7fvesrZyJHSS5um22Ljp2gQzbkZBYI/SOY3aca7LxW3Q13nmZH0z4TsmCNVRNVtQS8Zwnb3Fc1n6dCl4kfcRSyWVQIjOm8PxGZ7v5Ydm9cABTgwaRxYWOAKPn+XV4BFQrYf7IMah4JkaNzZdADxr/rNL/SsKVvTq7qj7UFI0CXAxtPPxwYvXfmnFCdp8YqYDJe+q1vkib3HuNR1JWBtFziSNFh1F2dXeP7fVuWXdikwp17LvVN//n8qlnz1HrH1LdXi280biVy/BWOspOX6+ujsuiu4x4xqO54Y3xHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bzK59wRq4zR/HCMQOlXgmdxFKRdA7gCmz2OJNANtr6w=;
 b=TAre95a2LC3Qe8WzmLZtnSd3806XKv21N5QbwkJLMshrP1qBFCqdORDnB7+iVYobc/d6RO7AC4Vph8vOmdEwJAAAbvkjc4oKWB1HhzX78pxA6h14Jo2oQrF5Y1/mNc5ObuibRra7TFu5EarkOWplhg1USSDawLRZbYvehSwsxB4=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by DU4PR08MB11594.eurprd08.prod.outlook.com (2603:10a6:10:627::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.17; Thu, 7 May
 2026 12:10:57 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%2]) with mapi id 15.20.9891.008; Thu, 7 May 2026
 12:10:56 +0000
Message-ID: <321674db-14b6-4ece-8b0d-f5ea08de1563@arm.com>
Date: Thu, 7 May 2026 17:40:48 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 54/54] selftests/mm: run_vmtests.sh: drop detection and
 setup of HugeTLB
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
 <20260428204240.1924129-55-rppt@kernel.org>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <20260428204240.1924129-55-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5PR01CA0087.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:1a8::11) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|DU4PR08MB11594:EE_|DB5PEPF00014B94:EE_|VE1PR08MB5741:EE_
X-MS-Office365-Filtering-Correlation-Id: 4dc924ea-be4a-4e54-a282-08deac31d9c2
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|1800799024|366016|376014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 XPLJ3WOLUkNRLKf55VAzoH5wbnjV60NV7K9ylunQYf/L/v3GP1jdet6SWh6P+BvGttmHArZ9i6/zlfG5R6Ict9VjxkKdZ5sNMtL6yMyvnCWG1RpWFddzuksbNiu8vk4H7DQMK+s2dM8p6cSpMXOh5/AlCkTJmAdgHG3R2DbAPkVMsEbwO7blUIn/muyrxF1pAMBDK0VzXOWRFZydX4uRnLxHPB2M1Z4gfIY2WtHWYdMw+bfExsyUASA+uKv+zwhgSDm9BznKKtyUjw27GsKcGo+MbSYNp3HTlH4W+AC3mtValuW1FbPFp0ykR3I52Orcz8UQXBS0Yo6mol/JkynVtM8a/FtbYIIl2lQL8j67ePUMIH65jR865wHwYDqif05Ns8QVkEYhgZxQKgdIp9P14YJBUMxPzO+kaWl74AqxmKoy+UKgxlFG6XNsp+8e+o3Ed49hWOiavv3Pdr81YdlQwEdb/avLD0S+WYvyO85ZyG3fr8fnB8AA0+sjEXEzk7R5Z5QbflqQqBRvXQpid+jsm1S6nDP/y9WN1TA8zGlYrXCb3/fB5MzLcdwASOocsU2SuTn43dAKf8S98l7xP8gG5Jd6+ZkUqhGA3f2P77iei2oU5cqvoCbeovMxWQ6NWy+oVq6b0W9uQ+qFrY9m1qKTdAScY3chyXsE++bZuGTpOP3pXyBdutJ/db09oCiLz8oA
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 Fa8Iv/st82U7luPMpRfptb4h9b9JY+9yo4OG+PGr3tjP7AtC6g60wz2aSNqUKdg8tSCr4JMFyRMcQEcET5BFaP5TvNXX/uWt5soSDoWTbCWKw9s+hMr1s1q4BSHWrChtoChKe00dajGAiFhaUwuP1ZJ2l1KOK98t/o3srHkqzFyJTRxi5+hokyHqtO1eJSw29MlS5Ri954S9hwuEyEg7KA/sbZxT5vsJRpuAN16jyF7oeP+/rqj4bgWi00Bt0qhBShV1L1gRS2A7VLL90dqLRl29JCp7LgmA3dujHgRI3E1y4lBCFp35IkUCz7VwqkvTQv0/Yh1HA1dNvecD8DF0aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU4PR08MB11594
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B94.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	601c5df9-7427-44ca-696f-08deac31b199
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|376014|1800799024|82310400026|35042699022|7416014|36860700016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	Ifmq4vli1J4uKkOOsmAYR8C6n8p4EyXF3nkHeo3rFqbTRajjUvdTuTneCt0/ck9abUwrTt28B6XBFg307FPqQAaw8422HlYyV9zekPuihsqxil8Xsf5gEmODODcCSfmeReHleDf2R/JKOtw+2tzctVWYYloqslR9cjh0Tr4VtTnYxHYZ5eIILm3GSiOtX0zXPYX/tJOUN7azWHA4/6FqA0umnIzLmUcTqWFl+LWNnScf8Zo8s/g8DQi94qtS2SsE95bv8VQXUZcTAxDrA6mWdWuzuc2InjGKGYHmXDm4+utGCdJOurvmYcUleIYcwh8/7A976/PhRUwTpY3Ih0CIXb+dkMfefuPyhdakzTtd8qX5AErB+JJeXmZ9BInVTM75hSnQWbHG8MHopkurfs3rKjyxVbBjVACEjRMc2u78eM8+SD316c0bSdmlYIGRCHoTqgaUqAF2fFjHyTrecxI43sxdf3V14EzV9hGbdVxl7aI/cX1QxWmUBrsvCOCfktYUMfWYCxOx98vKoqhW+/8uvayttKXoubGUcd/E6d2qOStS4YbkAZGZrAiEqOi/Lr3rDzzq1IOHfcQ4XY9zKwezWdFFRigCn3CP4ILiN37gtYfmfj0qVvvoibmqKV9zH+A7IUv9ZZHxlzJ4u6y/Y0U5jmFMS+Pakq4UBEQSgObHgCZY4kvtlf1kmK2aotIx4dC+iYcJ9TYYGs8tqacd4BN/W5oTVLJufclnVUdCLhRoSdk=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(376014)(1800799024)(82310400026)(35042699022)(7416014)(36860700016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	iWtqPQoFTvjnCPXwDqg90RysIosk5fcoSfgltb52E0Q2llRMQxdMN0j2Xae3cygHIRss4tw7p+1YCkHi1rrczYQ6owSEhtkGNkivUoV3/sPrxiXP83LY9ksWYGQA8xP47rniSWH4N7knQ3TpdW31Z7FdN0003bupkCGOEVVeovlLV2HgMlYBamzcZ2oTjLHMka4ubH9BiPtH5oxfvam+EwsAlnh+vUBiH5yWDOYOlo4jC0XoUAyl/kYc84vUGiJjmXSoj7EUJWyfvTnHg44mp7AG0YG4C50IWIEdu2NIBXXw81i1MTbnGT4viPr4AvSq+PxJ1AiW7BbDvsbWarLG9eSZcnMCx/1/IMs6YZ60OnMsDWc9FxVKy2hqfXLK0ztx48PAB4FpietYJP0olN13FT6wCFs9FmbwsLL8YhidksakH/sLAacGGbsjfiRG0VcZ
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2026 12:12:03.8987
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dc924ea-be4a-4e54-a282-08deac31d9c2
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B94.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5741
X-Rspam-User: 
X-Rspamd-Queue-Id: 0110E1A0016
X-Rspamd-Server: rspam04
X-Stat-Signature: 1ojjf8beazdejwtc8b1aume34z5kxe8h
X-HE-Tag: 1778155931-946805
X-HE-Meta: U2FsdGVkX1+2NGEY5BULo6W0gmeW/Vep2LXn+AncCVFNS/8GZs5/2SVgyDx2vYpzWYRMmH4/Mi9dLCD+pr9piHKgxJVRdjz4oIA/q3fyBWVJqOMwlPvjlbdzB0Bq9nsCTih/jFyP1L+/kjPiLsGinA/eCfTWyrwWEojBCE6+o5XAE64BsAqYVLt2W+n9FXe9gtsP36ID739rj5Qpn1W6rHTD2yX9BDXdMHJLF6Zh5ArjngJh3ksD1uo/9HGxX22f6fVmo8rcbki0h8Nv/deiX8DBodeRXb3wGRkNazbkF8/i2oWJn7t1hIy7v2M0TqdTT9ZvyLNR3zpWWXB+78qlNDhap1zEQKjwsaKOlhUg3++8CBuUl58CMyz+Z7PiSMYSamtxAxARLMNaj4umWnJJw20jrXwxMZiW67j3+Ov2QYgABd65sFKNa0zwtIH2ApEti6CMOiOQQtYrjFHWFTK+S6swrCS2jwu4yoJ722EqRX5lsF2dt7nMDXuCW2P+RBmQ+syde8zOL90sEeTX1OGy+s71E9BRChcNLTbcevfpmzVKFeNiF++U182226Nz/wKrP4W90Ij3Bl7hlSWHh70KT0wpF8gdXp9OrA0o6vlfHki/fxcQcs7OSfKupxNVyUBDktJRkW7xP+ESqBWs++LX7BqoWAE1TANg7EdTRwnfwlUpa/68HwbZi0oQaHb6tV5GgTmpUpuH9uqfElJraK4SijISvfXUC489CkJlDe6Hz8HZMGxFqOHM76pyiZHh4EtjKczqNAhZzeyLH2dPkuWPM0MKoUf+yuSnjgktSJIUhmQZdCq4nO3T6ahoDB3aC/2CShIeDJtX1KHxKcBKEMJiExtapERtC6CH0mT1hrHhAfgsUk3w8CrpaYdoAG0p9QtKpMzjFbeZkB4CJq9LBm+tw2dEHJ9VdaN7wJo0ZzX93yp9E+7It58V/9/oOeMWihVKGkTDUO4bkmZy/gyuWpw
 UFOmXYGS
 Ot8QZjJ1hglvP3FHxlX0uycgcybQHlGfppnqp6sCxaCK4DPOll82ul3xoZ4RuHhO4jfTgRviB4Cw5CIIsiCTmoSL4tCO6cYrSor5+YXvTGaOq+sywbOw1ViZjzysfXdBfSBfzTBAd3UDfubJAr/GkfJvCoxiYdd8wDIUFA3BF8MVWGjGvjlxd3UFWDnbNUjEZWsdip/ufPZbnXE8PEtNm6+yZVtK0nLLe56eAOWRmBrc3KHdvY/Wbawsf8KKv2rRILURd7/rLs3rUvEXcDTk9ypliqgGPbYKbtUrJKWS/tg9ZpUwuX5sHwuzWCI07z8RSn0bSaZPE8/vJnQhrDeZMCA1RadkcfH/1lQJjeRcfQD/c+VHFkw/Fb6czFasN6IHI/28pldpNM3ut815zsb+9qAHBsE3+L4zSerAMCFNIfqzaR894lwCyzwjajoag4oeT4ViGcWYknUX1QaHLqBYZnFvghZOyFg+sQvUtygnkoLJ4BOeQXLq1d5Ldi9VlqIkeNBY3oDDPPeiWcjoCLSvlzXoiPTGmbyKlzbOhbvk4hOqDk+N+BhOG3ff6bdrZclGrxmZT9xIvO1nZSmcRu1GXneV+GYakM/otBdpvT+8dQjq9TvQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/29/26 2:12 AM, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> All the tests that use HugeTLB can detect and setup HugeTLB pages on
> their own.
> 
> Drop detection and setup of HugeTLB from run_vmtests.sh.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---

This patch looks good to me.

Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>


