Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11AF0CA1013
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 21:50:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71CBB8E0006; Thu,  4 Sep 2025 17:50:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F4D08E0001; Thu,  4 Sep 2025 17:50:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E3B68E0006; Thu,  4 Sep 2025 17:50:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4B6818E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 17:50:08 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DD8BDB9559
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 21:50:07 +0000 (UTC)
X-FDA: 83852911254.12.C28C7F1
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2105.outbound.protection.outlook.com [40.107.220.105])
	by imf17.hostedemail.com (Postfix) with ESMTP id E937A4000B
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 21:50:04 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b="QpTF/WNL";
	spf=pass (imf17.hostedemail.com: domain of yang@os.amperecomputing.com designates 40.107.220.105 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757022605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cWxG39lj1alVc5fKUWfPaW2apdrvU9ilRuy3aQcR/PA=;
	b=BmoP56rs+s/D6B+m1oRDCStjbJJhPski4zP34CVlykOSaBXSaFU1HU4yrYYsdvri9euI4k
	f7o0A+FwrXZDE9FcabFNEunQqSXg0lwRkUegfyYK9+efk8UeY/CJEPBCCwqV/SWKFJzx8E
	yuGnMQPHP6N0zAaxo5gFlXXCaqYuMQI=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b="QpTF/WNL";
	spf=pass (imf17.hostedemail.com: domain of yang@os.amperecomputing.com designates 40.107.220.105 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757022605; a=rsa-sha256;
	cv=pass;
	b=PK0pBeaMkEYFiblX/oqI1S+4JnDHesJPp8NLVq8ngCSNRJXumCZUkAU+seoq5E4TJ1OP6p
	mXbncPBqK4vZ8yqd3HILmxdVs6o6Slo7AuDLRwYkf5feEJYoWKSZP2sOe3kdlFbbezQ+s+
	hsj6BJkQSH76lxocKbz8qtho22/5JQA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K93cJKGN3RnVutBMIZolalggP2CnEBGPUigkUv0OVdcwDeN6RPXFMhSKLTEX2xF3p4QL1TjZpeV55Wq6VMqIH4jTd4Mk4KJr1g5DWtf+ErPY67VoDCcgut2kIqmzxELxZ8UlplWESayGqacFBTbsYbVYm44IXOBmSPug5Q7Ojk/d+Za6tEV8eVGKWUK1MirfiKChcLDonR3HA/Rib3UscsaiD1DM3yqaOcVj1k6MkcXpUvVXkjAtkAuHrZwZCmtlnG4GwOHTW6I/ycGjZOdKGrM6GXLQxzlwkujDDfZkssKfVC9FsPBFGdLNMj0tngB96yHemULdawN3NazuoNpmEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cWxG39lj1alVc5fKUWfPaW2apdrvU9ilRuy3aQcR/PA=;
 b=a72neUnQB7kjuzWsFio0aqQ1d7QSVk1/m2wAPQLgY6/8pt2C7HrgcThvFJ8Zmp1Hgxlt1VMgB+nb5bTxcw2OqKS/EXHPSUrRtEsUR6+JGncUPsxgiynNsBkLKKgwtrEvUxRUjRMWLKTREWPKV1YZe6WERg+sw5GmuWClb3KTHLFkPwVkJgwbdRhUCqIwmRmGjROSvMNQ5fiGmm5fgPPWwY+Janr7Qi2l/rQ+WWZUc6AZ2cH/vR+wizGJvJTrbtkKNRCrxOUFM0QCllXZqoEWoAAdGIJKyfjp0qrFHISHOJ/EUnxEBUdQXH/sy5KyTwvUQAQRbJhxMW982smnNjH1Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cWxG39lj1alVc5fKUWfPaW2apdrvU9ilRuy3aQcR/PA=;
 b=QpTF/WNLmqnrzQ5xemRCiPFWlYRgIsjrJavQMhxYUxykHcJvIgucWIufBSEpb6Vi8tWYFBtmakLUMo0oYQOtH50Y9QgIYYfLhNIzYp29IpH964TIm3WI6mj4fq3biBY54zDGfcUL6LQH3n2Zl58toLGVJoEw1xwPoU5JliCbfus=
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 MW4PR01MB6385.prod.exchangelabs.com (2603:10b6:303:66::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.17; Thu, 4 Sep 2025 21:50:01 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::3850:9112:f3bf:6460]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::3850:9112:f3bf:6460%2]) with mapi id 15.20.9094.016; Thu, 4 Sep 2025
 21:50:00 +0000
Message-ID: <39c2f841-9043-448d-b644-ac96612d520a@os.amperecomputing.com>
Date: Thu, 4 Sep 2025 14:49:56 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/6] arm64: support FEAT_BBM level 2 and large block
 mapping when rodata=full
From: Yang Shi <yang@os.amperecomputing.com>
To: Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Ard Biesheuvel <ardb@kernel.org>, scott@os.amperecomputing.com, cl@gentwo.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20250829115250.2395585-1-ryan.roberts@arm.com>
 <e722e49a-d982-4b58-98f7-6fef3d0a4468@arm.com>
 <dd242f5b-8bbe-48e8-8d5f-be6a835a8841@arm.com>
 <aeb76956-f980-417f-b4e7-fe0503bb5a2b@os.amperecomputing.com>
 <612940d2-4c8e-459c-8d7d-4ccec08fce0a@os.amperecomputing.com>
 <1471ea27-386d-4950-8eaa-8af7acf3c34a@arm.com>
 <f8cf1823-1ee9-4935-9293-86f58a9e2224@arm.com>
 <bf1aa0a4-08de-443f-a1a3-aa6c05bab38c@os.amperecomputing.com>
Content-Language: en-US
In-Reply-To: <bf1aa0a4-08de-443f-a1a3-aa6c05bab38c@os.amperecomputing.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR04CA0003.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::13) To CH0PR01MB6873.prod.exchangelabs.com
 (2603:10b6:610:112::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB6873:EE_|MW4PR01MB6385:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d626899-f80d-47c2-771a-08ddebfcff75
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZGNpTWh4S2tNRTdYczdJV3FUNFNrdGVrKzMyOWhZR01Nb3FxMHB2d0c5NkF4?=
 =?utf-8?B?VXBCWWtxWkloaFNtOXlZNHkzK0YzMmp1Vzh6TlIzS3p3cjRDajJzUE0yTENv?=
 =?utf-8?B?YU9WUVVPRDViK1pQOUg0SktlV0F4S21oR2lEZ1h4TEhLKzBWa3FXd1BKNzFu?=
 =?utf-8?B?b0U5cHZzWGZVWEJ2RUdqT1p2bU9VYlViWGJ6SFQ0NlNRNW9VTG5MTld4NWxF?=
 =?utf-8?B?L0NkK1lVUDhkK1Z1VTlqT21BNUIrUUxqQjJDRVFuaG5Wcml1OUJMQ1FQZWQ4?=
 =?utf-8?B?dUVyajJ5U1BCK3FRSEM2eTN6YURJZ0h1L1YrU1JSUVM1OUJlUEpQOVpVd3F5?=
 =?utf-8?B?Z05BZHBuMTVWYkhFTG1talJqVk1JeEE4NHk5d0lkUlFnUHVwc1BCdlB6Nnh0?=
 =?utf-8?B?UGRTMHhFVFlQU2xXMngwdGhXZ3AwbzI0eUJPeDE3SVlSRk5KM3JqakFVK01w?=
 =?utf-8?B?MUVuRHFmSXNTM1hxVTVDSWpobVpGT3N4Nk8vMlI5QXdVZThMTUl4b3lMeDVQ?=
 =?utf-8?B?TkRsc01DTVNKS2xRQjdmZnpRS2pNWmRENFE0MzMrR0paMFQwU0x5dkVqelJO?=
 =?utf-8?B?V0h1M2FvWVlsbXFZZEZTdHhxcEUxMGVjSHNaZ3YveU5HaWh3N0RuSzZ0ZFc3?=
 =?utf-8?B?R2FBZlhyTWJtbS91Y2QzaGV4YnpVdVFBd0NzUzlRNURBdGRMSStMam9yMENU?=
 =?utf-8?B?aklNRnhOMUZIZ3plUUhqeU1xaGJuWDkwLzV1V3QxYjJFOU1ITXpDQUQyVXNr?=
 =?utf-8?B?N00rQ1NtbmRmQldkM1o4NEYzeTJ5dXQ1ZXdyV2RtMExFdE5yNVJKdzRGRVVZ?=
 =?utf-8?B?Sk1oeDhaandNNmwwWUlhUkpsUmR1eDM1REJTVDZxYUNRNWxEdzNMRDdYK1F1?=
 =?utf-8?B?RTJPKzlRbDVhWjNtZms5SmFhRW9CNGVYQWdpdldxMHZWL3NtL3VuZXF1YlVy?=
 =?utf-8?B?MVhMb0ZqM1ZhNWdVblIwU2tOUC9DaVNCc2RxWXIrUGU5WlNVcG1tY3ZUT3F1?=
 =?utf-8?B?NS82RW5qYmRwdGIwMnVoMFQ5R3NJUjhaMUw3ZWJIbUFnb2YxWWxLTk5mZG1n?=
 =?utf-8?B?V2FwcU5Uc3hGVlIvRGVmeHRHbGFCSmVFeEpMRThlc0dnYzRteEJpWk10MTMr?=
 =?utf-8?B?blNwU2k1dnB5c2ovYXFnMHRGUGJiZUdCTWsvT1dWYUQ4TGVpTUZ0M0IyUW1S?=
 =?utf-8?B?anozL0REQnVpK05aSHd5b2FkK2ZtajVSR0JMaElINnRXV0tOODZhbEg2bmlS?=
 =?utf-8?B?Mm5rZ2d4WXhtWGI1WlQ5WUVqRWtCZmdRL1VRclpsZ2VMbEk2amFuUDZFa2RR?=
 =?utf-8?B?UFh4R0ZCV0xTMUFTWnpjU1JhcG8wNnptMU4wRWJoZFJsdXhDTWZmSyszUTZP?=
 =?utf-8?B?aTFBNGxNclFJcmg5eUR5eXE3dDUyL3JSVnJtbVNnTUd0YTFWdjZDNGFsSHZv?=
 =?utf-8?B?REhNRXVnV2VUeG14UkMwZ3dsbm43Q3NRejlwcDd2cjYvdDI3K0F4VFk0cmRM?=
 =?utf-8?B?N2xkN2JCdi9uYnBqNnJZY2FBOWhNUnhCWkw1R2FPUDgwZHJZNjkwTTJkL3lh?=
 =?utf-8?B?Q2o4OHpPdzYyUVRDcGJiK0V6eFN1Ty9IdTRYdjI1dlM4NnVLNVhGaXpQcTYv?=
 =?utf-8?B?Y3NBN2hEUW5NM3FpSXdVRGk5NC9hUHAydTUwZE1FSUdiOGdLdE82bW9Icldy?=
 =?utf-8?B?cGNpNzN2TDZ5RmhOempSNGxlN1ByY1RSa1lpZmlyZ0JLVlpDNWxiazU5TWJL?=
 =?utf-8?B?RWJNWHpnbVF3bGV0My9SZjFQOU1WeUNLQjZXNWl6YnZ5N0J3cWQvNVNpMFQ3?=
 =?utf-8?B?ZWhLelZiS1IwMjZrT2oxUVlnV2NLZ3ErUTlXSUVJUkVlQ0ZCR3dJZGFrWEg4?=
 =?utf-8?B?dW4wUnBDYmNaeTNnWXhSSlJQblY2bjJJUEM1OTBzZHJSUzB4RlZuRFNVb3RH?=
 =?utf-8?B?UTVpaWNqR2pXanhtaXAzRGFTR0RWZWNQRjBkM01hdFhwRWJvVTloNjdEdk1K?=
 =?utf-8?B?Rm1rcFYyMll3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bXRoZ3lwNmVidFl1eGY4Yy9nUDhGVzUwUmU4QW9GdFpneUgzdG1zR0N3dVQ2?=
 =?utf-8?B?aXJjV0xoeWR6K1hES0kzUlE2L3pEVWNQUHdUTDkrdzhRcVNUT1d2RHNFbUJx?=
 =?utf-8?B?Qm5GaEFGVGp0eEZnWU9uMUs5WWU0U3M3QmpUbjBDeFFlam05a3k0Qnc3K016?=
 =?utf-8?B?bE9oVC9sejh5VFYwRnVjVFRUcXhaQmtyWE92Q1F5b3F1bEwzLzN3MmRLSHNn?=
 =?utf-8?B?TTAyU2g2Sld5YzM2Q2JqQ1czYnNkSzBOcG90RHlMWUFucDRWNHdvUmwwWE03?=
 =?utf-8?B?QkJjbitGamJ2UW1rN0RCbEdTT3FqMW84S2YxS0J0RGE4UnNHYTNCZW81VktF?=
 =?utf-8?B?VU5NdHJ6a1VaZjlEY0Y3ZTFERXNwc2lLcDhsUnpOUWVpSEIrV3AraXZyL0Rp?=
 =?utf-8?B?Nzh6Y3lLcVZJd2RhbFpZdjlpZzVDWUZQYXlaVGNuaWh0elQ1M1NpajJYbG40?=
 =?utf-8?B?ellRVnlIcTVLYUllSUM0Z3dkTk11akd5Y0RGS3RUMGdMbjVjOVZCeENiQnlJ?=
 =?utf-8?B?Z1BrU2xXZUNOVndkcHluUEM4L1RNQXNuNTM0eEVGaGVSYk1IaHJOaUg4d2FZ?=
 =?utf-8?B?MTVSWTdleVF5QzQzdEVVTUZKK1FRNXBmTFRmUnhTZ05iUDZYQ2NObkhiR25i?=
 =?utf-8?B?U2ZURUFyS2NiTmM2eXdmcC9ZY3drMHZsM1hMeWN1dFJLcVFvWlFGQUlqKzk3?=
 =?utf-8?B?SWkxdENNTUpoeTI5ZkxVQ2hFOEdJTnZyZmVhdTI4Skx0MmlWNUgvelk0WDBZ?=
 =?utf-8?B?Qm93U3NlT1pGZGE1SWd0MStWYi9oVGRMRTYxVG9lVHNZKzhaN1dZOXdZVU5v?=
 =?utf-8?B?WXRwdDJhT1N3cmU4SW0rbXBXMUpNRDJXc29wT2dQOEd3aTdGZmVuRVJkTGIr?=
 =?utf-8?B?eUQ5bmpnU1ltbTBJNG95NFc5OEF1N2htUlJBRHZwbTRLR3NTWEdmUThSeGl5?=
 =?utf-8?B?N1JTM3lRMm0zQlkxeWN3dEJsREttbXZkOC8yMHc3b3kwNStoaTcxeHpBZ0lE?=
 =?utf-8?B?Mnc5bTFOMFZWQ1Y4cmk5QW1MQXdHSUd5TmhYVXE3NUVEdzNnSlNnQVQzZUJ6?=
 =?utf-8?B?RkJETXljRmlKVm9iZkE0eFJta2t0T0loS0VJaXBtQ041YU9kUFhWUU9JdVRM?=
 =?utf-8?B?V3lCS1VDV1ZVS1dtaUYzcGNJUlFVdzRJd2JOVHYwTTdieCtjcVhHUU8rUGRU?=
 =?utf-8?B?ZTEveXlsVWF6b2VEQWx6Y1lzMzVySnkza1V5VWZwQ1RtTmVIWjJ5dXpaVG5O?=
 =?utf-8?B?OWpjNFhtNktFcFJ4YTZVclNPeHZSOUFrMDU5UGNNU2Nlb2d6V2h4Q3VNTzAr?=
 =?utf-8?B?RytpUzlmYjdjZlBNSmRzcjR1bWRDRUYrSGlYb0l2d1pDVDBBb1U5eHZHNUx4?=
 =?utf-8?B?UkQzLzVPdDlOaTV0b2xYUkExTW5ENFljdXBueTF2YTN5Q1MvME5vb2h3eUxM?=
 =?utf-8?B?TWtjUlJ1VTRKVVRBQk8rY1pPRTBycVdBNXNmMFAxUGZsekR5Zm5CR0c2ZGc1?=
 =?utf-8?B?RktKdC9KRkxyUlM5SEVBOE1WV2Zqam04Rk94NXFPN3lBUGp6aFl1Q2ZEVnZX?=
 =?utf-8?B?Mnh5UGJBRHJaUHVOdWYraGxNUDBpQlZqMW5KSExJMHk5TzllK3g2aXVJNy85?=
 =?utf-8?B?Qit6QnZ6N2RsbnNGWnR1VGMxaWd0K2puZEdFM1BwZjdJS3dyUlBpeEtJZEQv?=
 =?utf-8?B?ZitUNGRCT0ZXWGtMd3VsVEhyLzlhUXk5TThBYkhEYzdhWkNuUmhJS3ZLVXZZ?=
 =?utf-8?B?Z1lGc0U4bkU3SVpJa2dIQWtWNnZqSmVzK2RVYXYvL3RCSlAvcklYTDRkRkJz?=
 =?utf-8?B?WmhPL1ZSOHI2dFdmNFVIKy9OVFJIaWJ5cXRVYURaOE5LQlRWWkRCSy93d2FV?=
 =?utf-8?B?V3RXdzFmTTBDZ2s2UW5WTCsrVTV5ekc0UlpYU1JEMU9IdVc5WDlnUzlpOHQ3?=
 =?utf-8?B?MVVuSGYzeDh2ZmhYQmJkcUNPOUI0SW45NXZ2ZFZIVDU5TmYrUFByRnd6MjJU?=
 =?utf-8?B?ajFyL3VHTnZsZlc0SFdrSkJrWWZ5eUNibFNyMUpSNEZOQ25iTzYya1JDM3U4?=
 =?utf-8?B?ZTNqaytVSXUvTjBQSjZSWmpVNEhFUTA0OWptZ2dKK3RZaTRsTlN2TmRGMFBS?=
 =?utf-8?B?TElzMmxJcE53SzlCUmt3S3JTZVcxWkQxSzR0NlVSYWJ1SVloWWxyMTNpdG83?=
 =?utf-8?Q?lCXoyg1RdSLKXuTRHxVAl8I=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d626899-f80d-47c2-771a-08ddebfcff75
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 21:50:00.9019
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3AzyfgQg1hhjPRD4yxweJyrihwepC7OlVfGUVu8pDNgnF7mOOBg25+H07NFszKEdK9pUs0YaXJRS7eDSt7U6Zvx/aELgCu4T85HOdkuDJps=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR01MB6385
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E937A4000B
X-Stat-Signature: h6cp93r5a8ysubxmu7u6sfdqqyui6uei
X-Rspam-User: 
X-HE-Tag: 1757022604-862641
X-HE-Meta: U2FsdGVkX1/tvPlDh+hGnx5fzINEQO3oSVXBhJMAuDdUWeSgjPj2kj/syGIw9h/V7yY5AGTy6vyTzC8d+wPrGclSF77tMGCpVwaRYP7tnoVOSqNNkOUnX63wYIwCJDZ9R4VzKBYo2zVqwYHyfgceAFMUtTqSwoVa2Q41gcgoChZW9oAK5e5rBU+Q13+qqCFV1PWRGu2G8+ysrcG9Vg6f9P4BPerFl1KCMn+lPqPsFpAV1cMV9rB9BkRCNMUdU2mJFQ/5kIAIO45W6lfwj7xVG0W0Wm1qVhiwUPmiOD90EqvKzOxDj86RbI4fxBHUxKJJ9UHMTE0WFYT9rQrBaCjfGw5jIYpLQsWfBEER6lTowSIo83RidVfOHkpeg3hI7xv6RZDuA6SzwrHhyI872Ef49MP8LCY9GQT+IbSj73R7t5XzFHhDDJsB90+Zgt/VyEoJieXNeWYoDxbN83wtwMImh5jYgilDTBaO6exQ9JbDo0k6C4s7QypPcJGnuRewAMXIuoJJcW3KiihtOk5KBnmyI3raMxWCd71t2kLCX3CS0LVwKzYIH6WxzANhwWCZnsFmmgL8zp22FckNJ640ThBJ2crzbAOPly3elQSMwS1fgkkNLsUrOF4sIVXyFrwRNRGQ2ZHopYZSz4Dg3fCnHkfANItLts70QvfDd4w26sbQJAMwEyjBRMC9vUJo+bUFHPFPYb4dF2IK6UFx/tezvMp8nZFOhq51kJLj2U7Pn0fRaXCrRW2TIyHBmw9iN0a4Te13AdACUujR8zwtWgvv7fLGcGwaEjUHJ4Nc4FHcmIgxBdvs3RksrINdRC8kIYp5SEF7DsBvr1RwtCukcNSZCuqXPpGHy6xGos2PZU+j4MXRnp0H13dC7+LP0/p+GL97o+iEy/uTlBjHbeVnXan20mIZ/Qa91r/VuVZBt/k3EkQsYPAE2/gQ2nLRImKlQQIFqinXQJSL2fjlsx+5JqRvwuP
 NSFZ38hc
 UwHyfRXH8Vrns3Y4QQjyO+nxF8f3ML72/tv/c+fGjtJzEotUX0E5s4ZX1qGMhDRv5Mizmg1cLIredJPjqKLTKQ0ASI1if6LjI0dNEg1Q/ovMiYzgFUnajNEjGSrbPWyyJbwzG5QLfFOroS3P/Na4JhbZpFM26ebDRvlI4JZ99dsbMhyylTQ2PbU6bwDUs0h93UP0tJjq2sXxNpDuaJqtdL8FQwa8Yju1gr8V7U/XmSZL+c5bzE7UILgXm1P8/N/I++Td4dyknb7DDU6tNGdcpaV0KhLp/ew4AsGlsSx5TZWnsuyXMzg77vizxy1RrWO3K8Kkyw/ZFsmjCDkDE6sZ9nXB7ZWNwI7Rm/Hgs6hFvKd6K61KHvZ3QWb9J/YzjiEDxseqOXj7sZBTqs7//16uDanzXYZVkr9OFOU0qeJUIsaSsO0lv3AkkFrEQ1jRKmE2XZVt6CeYLhnL4MI6nH7+A2GTJ2DXas8cSIhjwnLmxRj0RMMDWzcTiNcvCiX+8JFXBh11su25FtSJoB5QeID7Ybvbbz41ojorTvmDam14B03eY1dg0c1LZQcGpWHra864VN1AqkFqVTTY5a9GAJ0OsvMmYidGhS6x05RnJSBu2g5u7GWoovOtc4aAKttYMkxynJEC33BqeWJajCdzRD4PK/Umb+kTNaxObvrHq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/4/25 10:47 AM, Yang Shi wrote:
>
>
> On 9/4/25 6:16 AM, Ryan Roberts wrote:
>> On 04/09/2025 14:14, Ryan Roberts wrote:
>>> On 03/09/2025 01:50, Yang Shi wrote:
>>>>>>>
>>>>>>> I am wondering whether we can just have a warn_on_once or 
>>>>>>> something for the
>>>>>>> case
>>>>>>> when we fail to allocate a pagetable page. Or, Ryan had
>>>>>>> suggested in an off-the-list conversation that we can maintain a 
>>>>>>> cache of PTE
>>>>>>> tables for every PMD block mapping, which will give us
>>>>>>> the same memory consumption as we do today, but not sure if this 
>>>>>>> is worth it.
>>>>>>> x86 can already handle splitting but due to the callchains
>>>>>>> I have described above, it has the same problem, and the code 
>>>>>>> has been working
>>>>>>> for years :)
>>>>>> I think it's preferable to avoid having to keep a cache of 
>>>>>> pgtable memory if we
>>>>>> can...
>>>>> Yes, I agree. We simply don't know how many pages we need to 
>>>>> cache, and it
>>>>> still can't guarantee 100% allocation success.
>>>> This is wrong... We can know how many pages will be needed for 
>>>> splitting linear
>>>> mapping to PTEs for the worst case once linear mapping is 
>>>> finalized. But it may
>>>> require a few hundred megabytes memory to guarantee allocation 
>>>> success. I don't
>>>> think it is worth for such rare corner case.
>>> Indeed, we know exactly how much memory we need for pgtables to map 
>>> the linear
>>> map by pte - that's exactly what we are doing today. So we _could_ 
>>> keep a cache.
>>> We would still get the benefit of improved performance but we would 
>>> lose the
>>> benefit of reduced memory.
>>>
>>> I think we need to solve the vm_reset_perms() problem somehow, 
>>> before we can
>>> enable this.
>> Sorry I realise this was not very clear... I am saying I think we 
>> need to fix it
>> somehow. A cache would likely work. But I'd prefer to avoid it if we 
>> can find a
>> better solution.
>
> Took a deeper look at vm_reset_perms(). It was introduced by commit 
> 868b104d7379 ("mm/vmalloc: Add flag for freeing of special 
> permsissions"). The VM_FLUSH_RESET_PERMS flag is supposed to be set if 
> the vmalloc memory is RO and/or ROX. So set_memory_ro() or 
> set_memory_rox() is supposed to follow up vmalloc(). So the page table 
> should be already split before reaching vfree(). I think this why 
> vm_reset_perms() doesn't not check return value.
>
> I scrutinized all the callsites with VM_FLUSH_RESET_PERMS flag set. 
> The most of them has set_memory_ro() or set_memory_rox() followed. But 
> there are 3 places I don't see set_memory_ro()/set_memory_rox() is 
> called.
>
> 1. BPF trampoline allocation. The BPF trampoline calls 
> arch_protect_bpf_trampoline(). The generic implementation does call 
> set_memory_rox(). But the x86 and arm64 implementation just simply 
> return 0. For x86, it is because execmem cache is used and it does 
> call set_memory_rox(). ARM64 doesn't need to split page table before 
> this series, so it should never fail. I think we just need to use the 
> generic implementation (remove arm64 implementation) if this series is 
> merged.
>
> 2. BPF dispatcher. It calls execmem_alloc which has 
> VM_FLUSH_RESET_PERMS set. But it is used for rw allocation, so 
> VM_FLUSH_RESET_PERMS should be unnecessary IIUC. So it doesn't matter 
> even though vm_reset_perms() fails.
>
> 3. kprobe. S390's alloc_insn_page() does call set_memory_rox(), x86 
> also called set_memory_rox() before switching to execmem cache. The 
> execmem cache calls set_memory_rox(). I don't know why ARM64 doesn't 
> call it.
>
> So I think we just need to fix #1 and #3 per the above analysis. If 
> this analysis look correct to you guys, I will prepare two patches to 
> fix them.

Tested the below patch with bpftrace kfunc (allocate bpf trampoline) and 
kprobes. It seems work well.

diff --git a/arch/arm64/kernel/probes/kprobes.c 
b/arch/arm64/kernel/probes/kprobes.c
index 0c5d408afd95..c4f8c4750f1e 100644
--- a/arch/arm64/kernel/probes/kprobes.c
+++ b/arch/arm64/kernel/probes/kprobes.c
@@ -10,6 +10,7 @@

  #define pr_fmt(fmt) "kprobes: " fmt

+#include <linux/execmem.h>
  #include <linux/extable.h>
  #include <linux/kasan.h>
  #include <linux/kernel.h>
@@ -41,6 +42,17 @@ DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
  static void __kprobes
  post_kprobe_handler(struct kprobe *, struct kprobe_ctlblk *, struct 
pt_regs *);

+void *alloc_insn_page(void)
+{
+       void *page;
+
+       page = execmem_alloc(EXECMEM_KPROBES, PAGE_SIZE);
+       if (!page)
+               return NULL;
+       set_memory_rox((unsigned long)page, 1);
+       return page;
+}
+
  static void __kprobes arch_prepare_ss_slot(struct kprobe *p)
  {
         kprobe_opcode_t *addr = p->ainsn.xol_insn;
diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index 52ffe115a8c4..3e301bc2cd66 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -2717,11 +2717,6 @@ void arch_free_bpf_trampoline(void *image, 
unsigned int size)
         bpf_prog_pack_free(image, size);
  }

-int arch_protect_bpf_trampoline(void *image, unsigned int size)
-{
-       return 0;
-}
-
  int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void 
*ro_image,
                                 void *ro_image_end, const struct 
btf_func_model *m,
                                 u32 flags, struct bpf_tramp_links *tlinks,


>
> Thanks,
> Yang
>
>>
>>
>>> Thanks,
>>> Ryan
>>>
>>>> Thanks,
>>>> Yang
>>>>
>>>>> Thanks,
>>>>> Yang
>>>>>
>>>>>> Thanks,
>>>>>> Ryan
>>>>>>
>>>>>>
>


