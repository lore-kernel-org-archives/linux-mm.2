Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36C0ECD342C
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 10:08:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F7CF6B008C; Mon,  4 May 2026 06:08:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CFCC6B0093; Mon,  4 May 2026 06:08:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BEBB6B0096; Mon,  4 May 2026 06:08:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 09CFF6B008C
	for <linux-mm@kvack.org>; Mon,  4 May 2026 06:08:58 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AD1711C1238
	for <linux-mm@kvack.org>; Mon,  4 May 2026 10:08:57 +0000 (UTC)
X-FDA: 84729313914.09.2ADDC50
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012019.outbound.protection.outlook.com [52.101.66.19])
	by imf08.hostedemail.com (Postfix) with ESMTP id A40EC160010
	for <linux-mm@kvack.org>; Mon,  4 May 2026 10:08:53 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Ux0iMaI8;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Ux0iMaI8;
	spf=pass (imf08.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.66.19 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777889334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ub6ZL2tIcHwar9sNIuSCmy+/Vnt+jHpKR7DQxRMuYy0=;
	b=pIcDzvAVSSIhWaFIqU9FQ7Xkkmy9vXDKPLSuC7pEEA4Lu647Jm3lHdWPZtjxD6GpU1z+HF
	GDuf7433aoNfX0cx9kSq0+GVhHt/Dh8zXKf/dQUAijDgl50C11GHVEfp4QNzhtIowrW+R6
	yH00ydn+eA3CrIRB05zCRsH2tUz/158=
ARC-Authentication-Results: i=3;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Ux0iMaI8;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Ux0iMaI8;
	spf=pass (imf08.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.66.19 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1777889334; a=rsa-sha256;
	cv=pass;
	b=t014HAVrX2V2nLpq37J4rtGuhL2Jz6s/nbRO8nj9/b6p+/h2/mSCmAkvNzFEWMVrJPzIdo
	x/S7ekFZVNG4O/mm74upukpDyVTyky/tm/sjVPvyE/kEdcx0mlijIaQ8Epn5TAVWuuzTou
	rkH0KLBuQvVoeGGRFvtIgXMtmUSdugQ=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=scUAKiuCOak9DS95xs2q/b89ZEIRSmpQ7Iq42HmAifkPybMNP+zqowbdy3cEEDcINnepxxaMJ3xsu4rFO37HIet8zQXBYEPTqAQYDwdPI3RnX1yASnpLqYDbg/p1AEKZlVmXogdzGxd7TuDFp2kRMmf6WqAxakr+TLlTfNDu+XFXW7Np2Nyg0EKKqpGa9LtkNloYQrhBNgj5c0qWbmpjDuTfjtoYeer5sf/jE29PcoJnKhHxvdQvhrIz5xHUaoTcPhXNqlEnqv95Db+GlXNi+88DR3MlGT/APLlb1NBM3k3nvQ7kUP5sDf9pQwDtzm23LYEo0xbrEkjTJ5/vmoZQxA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ub6ZL2tIcHwar9sNIuSCmy+/Vnt+jHpKR7DQxRMuYy0=;
 b=R6ph0LDjNZ7OVa/pfYxabWAx/mU3wCtaPDLuYAiW2O54YmpEzfkFf9jpCCIxNsUrmAWtS3zpzPy7Vz6D+Qr6MnB/uUcEkeriIjeEj1RuMZovSKcvpxxm4FEWAWSQCwCg+ukf7VTT6GFLFAdgH4iD0dq53gFkWUYXPEmRnZ+7H+Ty+uR0u3l1emrrTsq/SboV1juVyMqDmpddo3Ebiq7F5XiP5zVqshEMg5Z+n7L4OihqtJCJU+3YKGEgZ7/Joqf1nKd3THboPcRTHk071f6gIEejPmjRm1RKwvycbVIbD49thVBX+7okdm+TZMDJYtDngzebr3DGvbyIgq6KgD3lww==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ub6ZL2tIcHwar9sNIuSCmy+/Vnt+jHpKR7DQxRMuYy0=;
 b=Ux0iMaI8GkWUHBStbtfG23cm2hB91ZcLDsGgJN/7g8ScAPmKg0kTMFsOKH+vm4oi82INc7kU4L72jW2jT9jYbCcsIZXbJ17QVzOO7bz4CKp+FfmNlFBZ26A5bprUHLGtXQGL13/rh95NFbHXwbOHpSvOz+kGzkBVtvWyDv8hhuw=
Received: from CWLP123CA0229.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:19f::16)
 by PR3PR08MB5578.eurprd08.prod.outlook.com (2603:10a6:102:83::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Mon, 4 May
 2026 10:08:47 +0000
Received: from AM4PEPF00027A5D.eurprd04.prod.outlook.com
 (2603:10a6:400:19f:cafe::3d) by CWLP123CA0229.outlook.office365.com
 (2603:10a6:400:19f::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9870.25 via Frontend Transport; Mon,
 4 May 2026 10:08:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A5D.mail.protection.outlook.com (10.167.16.69) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9891.9
 via Frontend Transport; Mon, 4 May 2026 10:08:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z+uu7G7avTL4iW91Rkyv0Ch3B6NWIiepztolMBpjixgWGzFoxVrcq8LYGZhT9evarEHs8PRJU2m2zDeLdV32UYuErSONmo0IIBvJzzXxhETtBXbORp3BM5Zx7ReNGl+AlSsbEOkqSZtprrqvkejweVpe2jsHLLBEvdYQ0oM6poCudycqRDCaXhs+G0OleW0Yg0hiusl39a5aoDRMFns5N33yXemz4WUSwrkg/BpnNYuFZTvMQbFiBzcdgOIVJ5c8ozbn7MiSjtfyRljuC7YE2GoaYv2qZLtAvM6HaXoUfqEC0GkKxWYLiB3M3i21sxqtq064n7i0ORTBmCu4yULjzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ub6ZL2tIcHwar9sNIuSCmy+/Vnt+jHpKR7DQxRMuYy0=;
 b=qKPq/so1O00DyRvHMUM+a4QubMkxgjQNPnWLg3BxeEF8rf19UikjIs+4MJyjmd1Mlz5QlimQ7ZX4qsWgNtcy7LVsKnReqLFE4TteKxUKD4N0nLwnd1KXz4G1L93yv64Jgr4E0IOPpZ0IklA3mAmFBmET1QCSlyO1MVdQERNuoj/4LPG8iMDKCSipxdfTQA8ilhrnuMR5RRoucW4bDMqy3yOODC9W5m+3IUuMorsoj7CsAqar1IlS5c8N6AjByyh3qL6xrf+2ox+zKKO8Vioock9e9WX2ryZvNJxtc5LHaOAthwdO7fwpk8PAStzEVjwh78wcPbVjvKr0OAi658u3Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ub6ZL2tIcHwar9sNIuSCmy+/Vnt+jHpKR7DQxRMuYy0=;
 b=Ux0iMaI8GkWUHBStbtfG23cm2hB91ZcLDsGgJN/7g8ScAPmKg0kTMFsOKH+vm4oi82INc7kU4L72jW2jT9jYbCcsIZXbJ17QVzOO7bz4CKp+FfmNlFBZ26A5bprUHLGtXQGL13/rh95NFbHXwbOHpSvOz+kGzkBVtvWyDv8hhuw=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by AS2PR08MB9545.eurprd08.prod.outlook.com (2603:10a6:20b:60e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 4 May
 2026 10:07:40 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%2]) with mapi id 15.20.9870.023; Mon, 4 May 2026
 10:07:40 +0000
Message-ID: <daa3e21f-0c48-456e-a4a8-198a8c907b9d@arm.com>
Date: Mon, 4 May 2026 15:37:31 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 30/54] selftests/mm: compaction_test: use HugeTLB
 helpers ...
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
 <20260428204240.1924129-31-rppt@kernel.org>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <20260428204240.1924129-31-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA1P287CA0007.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a00:35::24) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|AS2PR08MB9545:EE_|AM4PEPF00027A5D:EE_|PR3PR08MB5578:EE_
X-MS-Office365-Filtering-Correlation-Id: 9097419f-1b9c-45d6-55a6-08dea9c52174
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 767K5GkBV9F8nQHu3tpD1ThvTPXmrE92sZkGSxbaY9UHRZGcHLLa28Sj+0gS3myQ/g/gfHl6FnevuII60exqzMErTBgCEzcYivUDY+TDDO/Fv13ecl1srTw3ORYb79/EdS4Cqzxrf8ysFEyzBsT6q4SxxLpCxmPu+fAxJ0nJmFwBTVAID40y5oF84Kv1i/cFSr6Ii5wnqmRU7jXcyhkYZ7hVt5Khw66n4qQp1DLuAzD78GI3qTl4GSuGtMRDlAz8GzgeJn376uXBiXvsm0dYrD3DZ8YL9pdlLaJsgPwbh7CmwasHfjtO9gyA0SMhogDxnHgJfTqghO2LzKECJEgUMOdWCeRYyXkiGGJqRbzMwsKCYlENEV1UfMq4+9VqZBNQohAaFKRtLq+3cJh5swHQlrHTD2vRzWeXD/RiTYM6B8I7wew3o2gm4Gl0gxQLJxQBiM/HGPqiVEGuif9Uk0L74Uvc2JE53tJfWcVuHWUpy62aFSsbkAZ3dL5TognUIIBj+RCfHKJn3J17AUGGwH2G/D+F3N/pbLV28qRiQaStKis4DKotVAePlawJmKgRlunWtGJZn8k2K6OIFekTnHRfZz2eGftLZUcU5iftCBphGFzaLU2O/nDLsMRN4cvhyzmJ3rnmcgS/ifoAQzYnE2vYekyxX5dxzwpjkJOKc5nUc083uUHhp+RyJ1I13HWABQ6Z
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 U16upLbK7sZE3LTw4pFVL45tZJtJKTDLy+fy6a9WVCkDx6YP802TQtkYr9VUhfDUmAqcNtZAmYB2TYJyP0XOTE0URu9h6DshGXwXewGjgHI9gNkvF0pXAbbS1siZ0+f2ee4L0DDz0my5BrGnk3mjwk1/100XnSoWml9PhNuxfBRFd6U40WftpEfMiHFozG+mDKhu+q+pX4/y5t863JkS2QUlMvvsjLgajdqN3904Yvg9AmNnHh+xy1so2a9bXa4lSQf+OunvTLSPGnJ+98H1zrf77dXGg1i0yEtlF6BdC8RSP7X33We9CtaCp/AMnGEgXMPu2WESFI8GQSNRQl7PdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9545
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A5D.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	bb688eab-4279-42b1-3923-08dea9c4f99c
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|14060799003|7416014|376014|36860700016|82310400026|35042699022|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	Df7XWqW4vAeCpQlbpEExjAVXm20uLAT/UDsVStpGk1mdv8kKEfbQ3p4dSrO5+l9yBrQEyGSyQ3d61fB5R1+Q3EdS2LXtlnqyYf3yhgUUJDruDTfSGpZwSf+85ztYxVqxIepmsNo9687kFm20o9IlNyJ4BD4T4SvkAbl3czN4Ku4qeRANH++lwEEaKpqQGDxTxWkFbhL+tWJLmQLOH+YTlSjtm2GJgq62XMTwo5A1UhrkCFEX1MTZ/xwiuakgRvV4EUnuvTR8ZhPAoS+HwWSLZRCaPO97FAgZNv84CfhIyCph1ffAwzZrFU6it7ysoaKp4tFArryv+fn0H6MMP16txoM0PG87Up3ateu4tVNk+xbygH856g8Tfr1wKJ6QCcgKXZ5mqyt4mHx//Z653t0IQFqgiZQc6QTfwQQq51RFzPTD6v8auwHXvjiNJwMgmOcCTCYZfymvoNswwzCMHP9XLpOw2kKd1NfH2VSAD6DMJNODYzwapGzUImnV0/9dcUK7y6vJV1pcF+iWv4SwSwicB0F9hoKCHC1HRT/MI2skHajAHARqUQR1vtji3V/efr8VJES5H0CdDPCe+zDcui7r/pIosdyS1KBbvCxkyk6FlaRvIwRQVB5g3r+kgWAqFUy1x5vco3/95eh9mUWzzo55W4FUkKWvk66x/RTU0LLGYiO49QhNFaD/TAb7rX4BAquiAP+F63owMvc3YRuTS1CeonuiL/jXpD/wzP5mEMLNKUg=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(14060799003)(7416014)(376014)(36860700016)(82310400026)(35042699022)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	9DhyOhnxgg1nq4YEIqFideE8z+ApPa1CBjNsgT78pMf/3ummKNxp6ArvYkTVXSV7INx9DQzRhIOn9OzWAdhWkWVvMuIddxpRms31gX27LlusavNDHd4wcO2c8IJJDxX+k+AgSpxguQ4zEqhKBmO5gOdbjEjIJYMKyaldiVwXzIP9Lr2Prxw2obmeqSjPAV60paB6t+vTR8tP4KATR/4fVfH9HUPeELJw63kFnHZ65i8J2Yf4MD2zVhxKzulS5EWA38T+aBaDQU5pw7pWSvscPxc160HkGj1isr+IG3cUslHbgmgch5gvg9BqrD9zxsyUwde7MflWYMwgFIjLg75vM64PWFsR3SJoMZbtfbI7ZIBQJ1lVscWAZnkqmUFdbu6AYolSNU+qxBEqpa4fRv+u8pfwQEp7p9IKzvPBOAQXu+b6UbpDZP1cCLwvIQarEFG/
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2026 10:08:46.7107
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9097419f-1b9c-45d6-55a6-08dea9c52174
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A5D.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR08MB5578
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A40EC160010
X-Stat-Signature: g7bbaqseyqsaxwz3tj85qfzqyyq18ei1
X-HE-Tag: 1777889333-585500
X-HE-Meta: U2FsdGVkX19pdNm904FPydgz5FxtRInFUqV6t/QF4sEmv0TN9YoTZhyCc6GcgNOAqO57sb8zuTW/WXG/ABPqW37wia4aOwfPM4R1178dMtrlbOJETOfXcA/bwbg9zbn7+0YyPklftgde99FDaC1XhTJa3/eoafO7y5YWNqKO4OPvLxiCDcCpi35pV4QDqtGOX+MTqMGwpK7IzAbHnTZ1IByH6bNxxDgv6rjWXSCPTBy6g5ltzNOnMLqlWnpQAnfKRk+1zDFVcMEbKN9tzgfb6uuC0QCLOElUMH84S+DKKUolJslZ3nspyZs3afzm/HZDgXZF2qFeaercTWc8ANBthhwcZ28mR5bA9vhhEL9Ni4GQuZalBHP10EXWxxsBVQ81A4zWKHArUTt18bRV1Ai7B6RILuVDlqjL90DVnMbPHK73fSZlrg/0V8Pcc5n42aQsrcc5wxglKyurbZIAUrXEAHfvFdbI4cAMiS5j2HuU1/KFXPAjyGCX9prUjFn37uJsOTZSZkRwYzjKKzXJeOl+NN5/SWqq2qqxoztpzzY8FoYj0iUu3o86FcjanLBX54laZQXxkyKvy672mSnHXQr/UMkvAjxTriZTtBJGba7/OCBGNpOOFJRnkk9EbGpGqcfU+ptTlRxNA+MP9hAwrkCa2bIEVyC3kfzE+XM4fnacY38uK+qWRW9JfUOsOmnjhhHcVLgZPKoPTUzAtAwIW+RN0iiFNCV+RMlFdkMvyXN9/gafMECAt9Jj2McwiDHV7MZsOz/acVfqxV/AvoFrtlSQk0dNrWNGFQ/pP8jOzzhsbL2uUX/Wpd82/Gx03HSppzG9CggykLIlWPFpnwi5rDEE80MgZ3beKXwRRSRvlDLlrI+17kJmy4KVTp1m5OHyHlIEOIIvGb+GMF7NbzsRkFpmbhUa1AphlgNbYVTrKpN67Qt7pBOAwNTUNU+4vuMdiUEG9w2MJclzPxI5MXrHkTh
 uSdXbova
 WW8CoaXn63RF86tdwgn2rtUTlIYSzDZBYRN55fivBrnKqFWEjEUiHf7e9G6bhJkGiCF1v8Tx3WhUSd+7UfmbISuGDLXp833L9Vsdfq2f2FCpkdKrUpnwkv/gHhxVVIsDkaEvxNBKFq1/coouwqO+xnG9CefZRHDq8b6j6pNQ+ZSw+WBOoeN2cqBVM5KUom4/vBX5AAujNoxH4CIkSvcWHulRjfQcIxEYpdarO4Ven+GuJoXBrZrkYpD9nJ0MujEKRT9mhuIIxZTNZSP8RVl/ikMtzj1o1F301mABgNV9xlX959/yD6H+gXby1LRj/7N9gnv9E8UTfFW+TxLtn/9FCguX188Mjb4vRh3kXDXMMPJ/DLPbLvRGp6/sjvZKlOUiYYN1ZvPFB+NLyCGp/Cf1dEO2Eyo4ua3IWoA/YTxsFUJK6IqSLH6LBXcqKRRH5EZlazTURyGgVEYuiEiEEAAwC+UiNHAm9bop/3G2DnPyMgWHFtONH8pLD9Scwi28vjKFzWDFhmWHiTfp8+AOk82w8XxoTeb+05RifFWayYdoJ6cyk23E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike!

On 4/29/26 2:12 AM, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> ... instead of open coded access of HugeTLB parameters via /proc.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  tools/testing/selftests/mm/compaction_test.c | 113 +++----------------
>  1 file changed, 17 insertions(+), 96 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/compaction_test.c b/tools/testing/selftests/mm/compaction_test.c
> index 30209c40b697..962a50c3d66f 100644
> --- a/tools/testing/selftests/mm/compaction_test.c
> +++ b/tools/testing/selftests/mm/compaction_test.c
> @@ -17,6 +17,7 @@
>  #include <string.h>
>  
> @@ -161,48 +120,10 @@ int check_compaction(unsigned long mem_free, unsigned long hugepage_size,
>  	ret = 0;
>  
>   close_fd:

A small nit, should we rename close_fd: to out: now? After this change
the label no longer closes an fd and is the common exit path, so
close_fd feels a bit misleading.

> -	close(fd);
> - out:
>  	ksft_test_result(ret == 0, "check_compaction\n");
>  	return ret;
>  }
>  
> -int set_zero_hugepages(unsigned long *initial_nr_hugepages)
> -{
> -	int fd, ret = -1;
> -	char nr_hugepages[20] = {0};
> -
> -	fd = open("/proc/sys/vm/nr_hugepages", O_RDWR | O_NONBLOCK);
> -	if (fd < 0) {
> -		ksft_print_msg("Failed to open /proc/sys/vm/nr_hugepages: %s\n",
> -			       strerror(errno));
> -		goto out;
> -	}
> -	if (read(fd, nr_hugepages, sizeof(nr_hugepages)) <= 0) {
> -		ksft_print_msg("Failed to read from /proc/sys/vm/nr_hugepages: %s\n",
> -			       strerror(errno));
> -		goto close_fd;
> -	}
> -
> -	lseek(fd, 0, SEEK_SET);
> -
> -	/* Start with the initial condition of 0 huge pages */
> -	if (write(fd, "0", sizeof(char)) != sizeof(char)) {
> -		ksft_print_msg("Failed to write 0 to /proc/sys/vm/nr_hugepages: %s\n",
> -			       strerror(errno));
> -		goto close_fd;
> -	}
> -
> -	*initial_nr_hugepages = strtoul(nr_hugepages, NULL, 10);
> -	ret = 0;
> -
> - close_fd:
> -	close(fd);
> -
> - out:
> -	return ret;
> -}
> -



