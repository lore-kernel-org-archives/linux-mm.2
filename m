Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6ADEFF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 13:15:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BF306B0096; Wed, 29 Apr 2026 09:15:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4968A6B0098; Wed, 29 Apr 2026 09:15:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3861E6B0099; Wed, 29 Apr 2026 09:15:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 253146B0096
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 09:15:23 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D351E1C01B6
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:15:22 +0000 (UTC)
X-FDA: 84711639684.28.D0C8DF3
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013020.outbound.protection.outlook.com [40.107.162.20])
	by imf24.hostedemail.com (Postfix) with ESMTP id A5D15180004
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:15:18 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=XTEjP2sI;
	dkim=pass header.d=arm.com header.s=selector1 header.b=XTEjP2sI;
	spf=pass (imf24.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 40.107.162.20 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777468519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4bDit8Yx6/aFmqNPGMYEbXyi5SdimGpC8GCvqtzal+c=;
	b=TfWQ3RjnD736RiQ9Tzta+Edn4BeudAV8kUcsfnQaIAR2vXHH9Evj5HEVwOX+wh8D8vMcsX
	1aGLkinMRQKB9Ce9Q5uM2I9S59AJ5Q2hz7N/GjOvNPz7FsTTKCP0s5IFjEHhgPXQD9koEg
	UkpNPLQV6tEBWKtfrghHhTK5ArE5tL0=
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1777468519; a=rsa-sha256;
	cv=pass;
	b=ZVhZ/sd3PG7wnjAG5a+XszV1/dSb9recD6Mjrt/eZ775aIcDPgcR7POaL7EZliS8h9/sHL
	qBDkcw51BZcjp0AM7YhaOT8/sLsGwVn2oEUKkxEI2X+afhKE2NxYC3Ogxr1pFTlTLAU0CB
	fWqq59cPaveax9sWPEuOxSDc6NNN7vY=
ARC-Authentication-Results: i=3;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=XTEjP2sI;
	dkim=pass header.d=arm.com header.s=selector1 header.b=XTEjP2sI;
	spf=pass (imf24.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 40.107.162.20 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=zWv1Hfvo4cfNnxmmSq3r3VhAftsaLdHS6dD9QC+i5manHq28knMrygqq3ZWbyxGpHLpWO1qh6GexL+LqxJTY+kYZkfO3EGEUP5tx2jwzPzKpSdQb712lyNzsDy1pqJ2Q0GqIpYnFqHfYo3fl/Bk8myu6R5YlOxGa6LUXwoPmlYJ9U/goEXjBt0Roo2C+VaaxS8eqvGEgwdsxZozfcpasc5bNBmmEvoIBw9OPQVJVeuMyP/H95eC8jX6ByErEBuLrHvkUvm5IgnPXsx8wH2rx4Hafs4qdpsOzYTsecS7gsr3t0ty0GXLc3D211st6N2cTchhNlikzQDacuSYrfPP0Ng==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4bDit8Yx6/aFmqNPGMYEbXyi5SdimGpC8GCvqtzal+c=;
 b=E0lOB8c86M9rbusY+ZzMvsJSK+0LYuSWY+0dV/FZjHdHJIsukZQektsT8HpgYtihvpm+1Yh/XLOb+s3AsaQkbb14Jt/1b8l3LJfrkibE3FYlcuDF8Igq6tBtIIFKWGeFCHsV1OqarhZHsJ9U2nxHGGzQE3lVsc4YqE/8GzUdkqpKNIXV1z6VIy/UkMu2z0PhQRo3l5rfx+6PnhNsWHXFL1SIIR/5ksfOQv4wu0XN2vUKlwDxjrssS5D1lPBkoX18wNcxvrcoxQ8ltLedTNmYM9tmWap5JwVnqLX7mLd30kHpftqlvf1uHiId9u7XXMtAck53eXOQUOpoaT0/Ay/Qzw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4bDit8Yx6/aFmqNPGMYEbXyi5SdimGpC8GCvqtzal+c=;
 b=XTEjP2sI4S6v8BfOpUYIriodiP7BH5/blcCVtncaIknm57Pq3PpMDBbkEg5Jz5rlvPSuoZEFIbMUO+a9ow1RumiSGrtJUkb4d0y9BwhOUQrwEkCWpDio3YNaJiogiZ43ede+tohBqeGAqYgB8C41iRoL9/RLgoYiFOmUC3KTXHg=
Received: from AS4P190CA0044.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:5d1::8)
 by DU0PR08MB9371.eurprd08.prod.outlook.com (2603:10a6:10:421::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.18; Wed, 29 Apr
 2026 13:15:08 +0000
Received: from AMS0EPF000001B3.eurprd05.prod.outlook.com
 (2603:10a6:20b:5d1:cafe::a) by AS4P190CA0044.outlook.office365.com
 (2603:10a6:20b:5d1::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.30 via Frontend Transport; Wed,
 29 Apr 2026 13:15:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001B3.mail.protection.outlook.com (10.167.16.167) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.18
 via Frontend Transport; Wed, 29 Apr 2026 13:15:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Dd5s9TogAvboY5689YjYYuoDAlgV2JKutt9hoJ+oE2/eru0QcNjyQg1Ujad3foimTcimnSooq3YtDHIjcnE0jLmotnpHX+xyIjhw8cNbyvGrH/feKa/Swt/dcG4YD7N23ZsBebT+XmeZIdyjZ+Lhkn4LLYgKmDqxyjpEsuv2Te6tivMyQYqMOzY/0YfBlsf3M4rH2C58ELKhgovyXx9oBzNT+a7/N/amgl1kgKkSfuhJtGG+pjSgotKDM6n6SwIF8zQRoWiWk5Hb93PNtnsXfi2LLsIYWvlcimdnf6IzCnRr8Hv2s1baW65PBjJh6PjT6MfXxczrUT3RRUaxdEJWmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4bDit8Yx6/aFmqNPGMYEbXyi5SdimGpC8GCvqtzal+c=;
 b=KQHihPwK44YErlpFdmg5ktRRzhtHuQIvrI2EcxKkE5K93BLypTrX0D/ovGmWg3a+mpoPvKdymTEyCQsFpFRXfbRtRYymQHNe86Xg2U7MfQTIsp9sTg/orhDVRVWpK1WJOh6TNhj66+XCKtovCSFl+9WG4BUTQnKdnSOBvHaB4uZRbye2zFarQtxBxaDvTcuSd+jyIl1DsxwRZrYZobiz5+2dei+B1dDo6vb6Yk5H9/HYi2Qh7jxRvTVzbS00QHOt4u627AYN+3qt1Ctd9p5XeJ6vv3YvDCAyZcUx4BtJpFYYdeciFXgKCT1r7VD6u6ylGhG7FZOf8KyChKqCrWcYIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4bDit8Yx6/aFmqNPGMYEbXyi5SdimGpC8GCvqtzal+c=;
 b=XTEjP2sI4S6v8BfOpUYIriodiP7BH5/blcCVtncaIknm57Pq3PpMDBbkEg5Jz5rlvPSuoZEFIbMUO+a9ow1RumiSGrtJUkb4d0y9BwhOUQrwEkCWpDio3YNaJiogiZ43ede+tohBqeGAqYgB8C41iRoL9/RLgoYiFOmUC3KTXHg=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by VI1PR08MB10200.eurprd08.prod.outlook.com (2603:10a6:800:1bd::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.18; Wed, 29 Apr
 2026 13:14:02 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%2]) with mapi id 15.20.9870.016; Wed, 29 Apr 2026
 13:14:02 +0000
Message-ID: <89382a73-4b9f-422a-acf2-02f77e5bf547@arm.com>
Date: Wed, 29 Apr 2026 18:43:53 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 19/54] selftests/mm: uffd-unit-tests: use kselftest
 framework
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
 <20260428204240.1924129-20-rppt@kernel.org>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <20260428204240.1924129-20-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5PR01CA0198.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:1b2::8) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|VI1PR08MB10200:EE_|AMS0EPF000001B3:EE_|DU0PR08MB9371:EE_
X-MS-Office365-Filtering-Correlation-Id: ed8f97d9-0408-4010-ec95-08dea5f155ba
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 fpLA8BvWeAJsutC1C0+h4k+2Vde8iJOrXtbLopBNX5fq72A/bxe6m3pO8QvbhvnHPxutS04ACdDEDfUkdi0ZxOhR7ysEDdnT+4PEbFYJi0V6x9QbmK3+e2cnxAOHYMHTbOsmGqPjOeIVRKiID+HiRewu+6tGkBEDQ6LsaXDO26/DfL2ShjByrspQVvXdHc4yuTjoT5v/SLWWtPAgN3kM5JAewbE68zjQ5HCpTRALCwaRL6HR2PCMHZlztwZrl/RDFrIHAaeBqnefdUR1ENAYL129hx264cqTi7T0eLK+2jrQYJPOkMGVXRe9WFlkQPDrFL0pKZbbtbYOkVsqkw2H2eleLaSlXL8aacHOeMM4Ln7/NDgkx+WAmk8oheLr8Re/SkJ110+1+t2IgVaXJei7uKTLC5vii4we8e4G0Rpc2iQYHjCQVHAFnFRAiI2MIoFM+Qdje0MqJfy3tTd6DTXQ+WrKi/vZ/ZVaiyyP4Mer4e99q13ppKNtXgrvlJDm/V3RwVijjl4DXJgS7vufL0bCcg6zDyL+ptCsRlZ0T/MuLysRZntSApDDrGlbKV231zll0ap12nNvrmWykt1uAbDbIhY2fbI8KWMeSBL8iFldYEMQzZgYNas8LRBlAZewyW5Lcif3oXO2eWU1CBIsFEoCRtwOewUISFKMjG/hPORszaR6mG85YOzpBfsFsjIkJhIX9SHXnCbzSBpELF18VE3sfju4IJbQMKVcDVb9DkrXgHA=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 XJc46rXEkXvZuZiWjx8fN5vnjL2N6V6StTf/8+TxpEVKj93RB312axpZNrxXz6nGcMNJ0euyKCb2IkNrixVq17xtKvGxHZz66LkjWutuHPGxC9wRaMuup/TLVhVVFDLJ595SWpLJvC9SHd18iOiE1G8C30EuCCaERrD0VPN1cC5Z9DveCvWEVdmpXPXqq3VaLpQYaPHMoBJu+ODtPwGlUt3bTqIOSp5Co1mU3xVvNUVCRaDSbMW0pqeo66L0hxN3630hII6AP3NWpCdgFLnBIOeZcuRt2hnFeomgGXRhT9rr/xlmbxKi8DFDAQydl0Zad7gPmJIbK+cosy8SGT5uqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB10200
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001B3.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	0e5f404d-3165-45f3-16e8-08dea5f12e62
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|14060799003|376014|7416014|36860700016|35042699022|82310400026|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	fty9BrPr9Ci34chJUNdZdogkughW6dZ/W6OzTMDysqAR/lYETJ0VOIrw9wGTOcm7F1R0iFLV7KMCk6ms00Jb3u49O8XBKo595T+b/FhW8ZPfDpYG7R3sjH4XkywMnzwPj2YS4BwkXSiR1AAQmgzvu+y9jSrmuUVZ+gkhgCI6wQTTSVCaiqSiFGA0h3o8ZSstT75w+p1O12hr9/gMmYu/L4QIJZDrIqKu8MQFZk89WMtytO4CRVsIU4xXP1WA38PuCaooOvFlfPbdWp8DdrS2+ii9np91lGkeBgU4uJa8tRB1J+ecq13fIfR74PciEuorb7rDlBCtJbFVIJlHfb7p8JfXQUENe7EugMI80Y11UjoJ9TQBq0lUBpWw8xgzSg26gSSSfhIFSloy1CAnHLGUiaXMeVDIMZ2pC3HoZ93DM2DBIXxwA5Q5uP6BPlGUv61dn4Lz6U2Cnoea/TcpYudooN7C/mMMpDmmaYq4Hrw/CuFsDEhs3gHvBym5BtV2FYIlsnMVB3OrcqcryK1eOoryhicdg5V9NDFo53ObsTp6l/T/vCFCzSSosqMEVI3V4sDxcRK3ex8J0ayvmTfTw+IGM9BMSS7yzPkVAtxTaS1u6PDnfkH4/eTe10QK1B3X9oLVyeLNNSpGM3m3JhxvkqjLztkgUqrsE76pylN6XtyqoSfNiU93Ae8CpKHw49SNlcYOYJhnT8UfrL0GuAy+gzOCBdm8eDIl+MT6SF6nQDp3/4W0tPratds429fCyGHs8spJG/s6jzYXqizEHSFRu3iGzw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(14060799003)(376014)(7416014)(36860700016)(35042699022)(82310400026)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	t5qMH8Ry8B/xODkOX3j8dZyFjTnBDkP7WrhzGHeGZx4/hPH2Ch8Sbts5l+Dr+2oDpVRo3RNjQYyOR2JAzcNX7/YRhCxhbmDQJ/GsGLNU3i/XD15IyLysvLDeXZ28mn752+UjZb05We9Orqr0E6BUKSwP3Zr1s+ly4c7N1X7cW7txeGS3vqldPHaIeDWAbrfOyMxt/nSJKppAUexQ5p2WB1yTIe/buzBgiUcgI+K4Eoql0ikAIWPS3XmnsyFw7rmMWJg7vyZU12TYUig+17VWE6Z2xoAaXwIfwJhGMmxEv2U0UcEO7e9IqCMcqaMuQkt7fVasZvTX9wJM5tue/sIIaFxeuf/971e3Wl3trcg639gcpTfUCx5bDidLqIN2UaiYhQURxiG0eeheFVXi+xU5+JwIikJUZCCoTntb+BjaaoXHzPNxRCB3ZWWju9JnL3zW
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2026 13:15:07.6128
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ed8f97d9-0408-4010-ec95-08dea5f155ba
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001B3.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9371
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A5D15180004
X-Rspam-User: 
X-Stat-Signature: rk4xq3icuqcw6drjwqe9tx9xfsx9x18u
X-HE-Tag: 1777468518-780704
X-HE-Meta: U2FsdGVkX1+uQz1i5K2HPgzAnBEkzakqvD5Pa+CRQwzEZUOEHn+P7Hgxh49XFLpB/DHoLnjCAYCrNsg2FZcNfJKGYX6Oi1C9AjpUzDxAOjhZe2ofKYsHpiJCOEYIBdRtwVjwLlypIGQx6GdtxvXi3hGX4Z20fusRLXVBd3hL9ZcUkZ8NAgab0Dh1FgXBrgMHoXC/2dSlRa9zIZIkXJjGDCykxY3wL1E8PsCxlmNLlvm7rlUxV6MTzePBymwmZm7ECsPpRR2xgegHU8B0GzhAAeXzbmANV0fz6j8RUAl2a/qPq6+J0WnuZz4l9NXcK674f35BuybwVVUbNv4b/tfv5vaJoJl7WN6nI8CPWzUskqEx+BOMzJ+MCTNamRWgk8o1tcjan1Bhf21voh9SS2bsWYcbBgyNGgLjOqSrfsbug3t5y5uqICbGh+hTfP5Pr5Tl2ZF1UYJHHBa7OA1ruyeKX2LR+qdB+b2J/uhbPaka0KFlbltZc8WbMXTcxlbgnaaJ73vAXdqumveqjzI3LiLGO7iFJq9SHxtv6PqE/fOS8QidfN+lWtMRrGVIFBGW6ozOdk1uRrL8TM5jLZimWfwF4PRTeQciviQpOtsoHq0hA1UsQ+fBHMulDp6qXbRjSL74vm8E0J8jen3oFvjMZzxjuxx+fD7aLWuVpkSB2QTnRC+MIstXF+D9+GOSIVc4i5FPc6W3EXNG+pXNVUBqW7k0CTtXB3kMNPukge2QFQfqFxTHde3XQas43eoP4nx/S8BoJFkOtDnYSmWaJnhkgi2Y4vWRgSL4SWAdNqxb/qwZRzbDh9koHgqzXn3WwW7kEP6pWuhZn0TYOnx1dpVjb4eqPWvM3yGobghND1ptPxMiJYJbZBpVlO6npPE80k+c3Ec/SdnrTWO2MlqGIavFbneTHUy5VtQQGqrZtvhm2LJk/PNA7r5uxRUcRGPwAM0XCp6CuqDFhar91J8gkEiJQC7
 xwr72pV2
 L3EIPZOvyIsNjmVFZyILLW6r2MtMvwquVboj3t9f2tW2CqAEBLnU4a/xN5Q5QXKPIRIWBarKiUnz0mTphGE+0jvYr5T7kTITHTnQdFI6+g2DCwgjyrYv7IKWk8SbgGBu+ER8tXxPxZvSd892+cuoCgfstyyMy5sgkb/nMdXyQfTlLctdt8eRuKe39DKlKIboEg0XYRwFSqHqI6tlDp8Z6F45PnMTxnjTN5gecXLZKuFheVkUGUioDOkmXNZBi/xQUXuyPPgS9ru4Fh1CJU3+JH/tLcJn3to0FI3mcexdO8a18jUmZXCBm6E75qzb7CSap3H+a4MsRjm7jftHdQeR5dNBc4fIq8QUfl/6SDgNgJGuEo9eM+oeqNZI6UMyoRXa/y2yx+q9rdJwxf0RpKDziRD0qmOxlZJ1O9UN9t7JDyoKfQ8dmtPbJBBNz6H2fGmBtZXCclwMEJPdANW8kL/4qsGfZV8Mt4e+GNmHWPlLtODsdkFku1Nr/u6nuN+N43qK7HoLYAqXp2ycQAOZeHX445dbqKQ==
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
> Convert uffd-unit-tests to use kselftest framework for reporting and
> tracking successful and failing runs.
> 
> Reviewed by: Donet Tom <donettom@linux.ibm.com>
> 
> Reviewed-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  tools/testing/selftests/mm/uffd-unit-tests.c | 79 +++++++++++---------
>  1 file changed, 44 insertions(+), 35 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing/selftests/mm/uffd-unit-tests.c
> index 6f5e404a446c..1a33db281f8a 100644
> --- a/tools/testing/selftests/mm/uffd-unit-tests.c
> +++ b/tools/testing/selftests/mm/uffd-unit-tests.c
> @@ -86,39 +86,24 @@ typedef struct {
>  	uffd_test_case_ops_t *test_case_ops;
>  } uffd_test_case_t;
>  
> -static void uffd_test_report(void)
> -{
> -	printf("Userfaults unit tests: pass=%u, skip=%u, fail=%u (total=%u)\n",
> -	       ksft_get_pass_cnt(),
> -	       ksft_get_xskip_cnt(),
> -	       ksft_get_fail_cnt(),
> -	       ksft_test_num());
> -}
> +static char current_test[256];
>  
>  static void uffd_test_pass(void)
>  {
> -	printf("done\n");
> -	ksft_inc_pass_cnt();
> +	ksft_test_result_pass("%s\n", current_test);
>  }
>  
>  #define  uffd_test_start(...)  do {		\
> -		printf("Testing ");		\
> -		printf(__VA_ARGS__);		\
> -		printf("... ");			\
> -		fflush(stdout);			\
> +		snprintf(current_test, sizeof(current_test), __VA_ARGS__); \
>  	} while (0)
>  
>  #define  uffd_test_fail(...)  do {		\
> -		printf("failed [reason: ");	\
> -		printf(__VA_ARGS__);		\
> -		printf("]\n");			\
> -		ksft_inc_fail_cnt();		\
> +		ksft_test_result_fail("%s\n", current_test);	\
>  	} while (0)
>  
>  static void uffd_test_skip(const char *message)
>  {
> -	printf("skipped [reason: %s]\n", message);
> -	ksft_inc_xskip_cnt();
> +	ksft_test_result_skip("%s (%s)\n", current_test, message);
>  }
>  
>  /*
> @@ -1701,6 +1686,26 @@ static void usage(const char *prog)
>  	exit(KSFT_FAIL);
>  }
>  
> +static int uffd_count_tests(int n_tests, int n_mems, const char *test_filter)
> +{
> +	uffd_test_case_t *test;
> +	int i, j, count = 0;
> +
> +	if (!test_filter)
> +		count += 2;	/* test_uffd_api(false) + test_uffd_api(true) */
> +
> +	for (i = 0; i < n_tests; i++) {
> +		test = &uffd_tests[i];
> +		if (test_filter && !strstr(test->name, test_filter))
> +			continue;
> +		for (j = 0; j < n_mems; j++)
> +			if (test->mem_targets & mem_types[j].mem_flag)
> +				count++;
> +	}
> +
> +	return count;
> +}
> +
>  int main(int argc, char *argv[])
>  {
>  	int n_tests = sizeof(uffd_tests) / sizeof(uffd_test_case_t);
> @@ -1730,24 +1735,31 @@ int main(int argc, char *argv[])
>  		}
>  	}
>  
> -	if (!test_filter && !list_only) {
> +	if (list_only) {
> +		for (i = 0; i < n_tests; i++) {
> +			test = &uffd_tests[i];
> +			if (test_filter && !strstr(test->name, test_filter))
> +				continue;
> +			printf("%s\n", test->name);
> +		}
> +		return KSFT_PASS;
> +	}
> +
> +	ksft_print_header();
> +	ksft_set_plan(uffd_count_tests(n_tests, n_mems, test_filter));
> +
> +	if (!test_filter) {
>  		has_uffd = test_uffd_api(false);
>  		has_uffd |= test_uffd_api(true);
>  
> -		if (!has_uffd) {
> -			printf("Userfaultfd not supported or unprivileged, skip all tests\n");
> -			exit(KSFT_SKIP);
> -		}
> +		if (!has_uffd)
> +			ksft_exit_skip("Userfaultfd not supported or unprivileged\n");

If has_uffd is 0, two test outputs from test_uffd_api() are being
printed and the third output is from the ksft_exit_skip(). Since we have
declared the ksft plan before this, we are getting the following
diagnostic line:

# Planned tests != run tests (67 != 3)

If we remove this if (!has_uffd) check, still all the tests are
individually being skipped with a "feature missing" message and the
planned tests are being equal to the run tests. So do we really need
this check or can this be skipped?

>  	}
>  
>  	for (i = 0; i < n_tests; i++) {
>  		test = &uffd_tests[i];
>  		if (test_filter && !strstr(test->name, test_filter))
>  			continue;
> -		if (list_only) {
> -			printf("%s\n", test->name);
> -			continue;
> -		}
>  		for (j = 0; j < n_mems; j++) {
>  			mem_type = &mem_types[j];
>  
> @@ -1794,10 +1806,7 @@ int main(int argc, char *argv[])
>  		}
>  	}
>  
> -	if (!list_only)
> -		uffd_test_report();
> -
> -	return ksft_get_fail_cnt() ? KSFT_FAIL : KSFT_PASS;
> +	ksft_finished();
>  }
>  
>  #else /* __NR_userfaultfd */
> @@ -1806,8 +1815,8 @@ int main(int argc, char *argv[])
>  
>  int main(void)
>  {
> -	printf("Skipping %s (missing __NR_userfaultfd)\n", __file__);
> -	return KSFT_SKIP;
> +	ksft_print_header();
> +	ksft_exit_skip("missing __NR_userfaultfd definition\n");
>  }
>  
>  #endif /* __NR_userfaultfd */


