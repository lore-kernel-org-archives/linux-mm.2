Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D42BCAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 19:54:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFE0A8E0008; Thu, 11 Sep 2025 15:54:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BADCF8E0001; Thu, 11 Sep 2025 15:54:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A28788E0008; Thu, 11 Sep 2025 15:54:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8B89A8E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 15:54:51 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 28A331DF2AA
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 19:54:51 +0000 (UTC)
X-FDA: 83878022382.25.BA8FFCB
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id 02EDE1C0009
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 19:54:47 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Rj34FmNB;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=jak996DC;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757620488; a=rsa-sha256;
	cv=pass;
	b=r5/36dija4JXUGWLIxPbGnA5i9I1cky+N5BRaybMx90PtLpHOQS5OFRimEZ0AOIsvNl5OU
	URucU6+RzamYwtQxmE0ezYfH8QQmcQwmVT7cvzfIruy0jVvclOaXm3HHboztEYsGp/wCtS
	VG2zaFuVHEQeNGiJu7UxixzXuiMfLWM=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Rj34FmNB;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=jak996DC;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757620488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7wqdZwDX5W1yyx01t/9CNTQEerJfLah2JGn2qYG6Exc=;
	b=q5JBi6NTFSZSg5THB3LnFJvIyq8vufHcMe8b+8U9uRnmLGm1KjG9zIXJ8Bp/PThLttoLwP
	9c9oAD///2E8Yb8+2P/D38ilLuPgkUXTOCUybB9b688lVQtaW0G3nxfWld2G61XK7D9XnW
	qqVCTEMvxSUqywMoqU1VRgg8QHNeuuE=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58BHBfHQ000773;
	Thu, 11 Sep 2025 19:54:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=7wqdZwDX5W1yyx01t/9CNTQEerJfLah2JGn2qYG6Exc=; b=
	Rj34FmNBLihfXdpn0abaPiOFJlpdvKgkVWDAg8ZjPG05oAPCOhvFKQf5iQjgHUeA
	VLnBh6kWKja3/LmzGnKBiD2fQb6LSQ1vepiybWRVpEiuYjdX+NkAvXLU6uYhKyeX
	Y5h7Dlilb4kSg/kLNZM+8lWZhdnavp4f3r4k9vigEYWUjO5JIscXZ+p2/hDoXF8S
	nVsisEH/sqgbS9fSBIwvCPsb6XS+5pGoCTj2cPId3N0Idwex/cgO2D3T21GWuYdY
	gDyJ0TUfcSs/rawGZt+c/y5IbXY+QZ5HPKc7l4RnTdod0L1u1zsv9CH+VWScugbE
	6WDsDGOmBnwob3Eiet5gtA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4922shxx5p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 19:54:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58BIS7JI030839;
	Thu, 11 Sep 2025 19:54:41 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013005.outbound.protection.outlook.com [40.107.201.5])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bdcvpdu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 19:54:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L8IpWb4KfLEA9DCdbxWhS0h4PWc49CheUUEWMWkq+tmkBOsNCRR7scsxUvMoKlVICWcR4bUF/eEgGBAJIEW5KY8z4KHHtKJMeVxmnX7JLOJHnWLUa0u0qqjyrM6ZI17M+tvqI3OeWxvWwpTtqNQj+lzj759oy2e82WJ69yFstXgZaU+iw6Db4/QWYiJfLMUqWFs5AmfE2rVHCgDDNkgT5FGxqbikk969oDlDSz28CvhNLbGFaiaW1xvrL7BIaSi/pdOk/SREMuXCOpm77qo61pNk06rYa6BPb9QlkqaNt/0xhqdNTCxJ3G4wMP/aEW4v5Q8zgygWrURndSNkN0LdNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7wqdZwDX5W1yyx01t/9CNTQEerJfLah2JGn2qYG6Exc=;
 b=grqlOQsDaBLBLJlu+UgmrA58rtz82bfdCyNMAv/frVjJpqw+aJrZO4rir6gi1c66m0omN76c+Gm4xW85bt8YDTskmATjJrbNOu98yViZgBi5BSY7xqttUB3jOSyHXc6cqyr6234+Aoe9oK56i0nqGHBK2gPQDO9GYwy0/4E46O+4/gScE2F4jCRXC1ja4Q4ORzjpwwEh+nhoFN1hEkopdcRNP2wkVSHK6nL4OIt3h9cB/GzdtdKwD2g97p1aIf3UipT4Ex1ZX9ADJhosJpB1EHWpb62KkH5L6QfltjlBF3sAerYkt/3H/ZCiHqDPngi7rj6wWmtVN2n3xXVUFpUt+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7wqdZwDX5W1yyx01t/9CNTQEerJfLah2JGn2qYG6Exc=;
 b=jak996DCOuR5S+90V5xpn9PVXCY90bISx2+KhbJmz/hIGHTKatmqe/JL9HkLA0NFRS/i4kL6dvjKWz7UpAPpws03Q/uDGhsPeVyihFr0vFnsadfCqKEEjH91FJFJJA0Sebn0XyS1z3eKVH9yUOThkIl8Wcg4cRb8NZdXqTIhwZw=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 PH0PR10MB4776.namprd10.prod.outlook.com (2603:10b6:510:3f::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.22; Thu, 11 Sep 2025 19:54:39 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358%6]) with mapi id 15.20.9094.021; Thu, 11 Sep 2025
 19:54:39 +0000
Message-ID: <2fa7aa11-6521-40f3-9934-aba275154ca2@oracle.com>
Date: Thu, 11 Sep 2025 12:54:36 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hugetlb: fix copy_hugetlb_page_range() to use
 ->pt_share_count
To: David Hildenbrand <david@redhat.com>, harry.yoo@oracle.com,
        osalvador@suse.de, liushixin2@huawei.com, muchun.song@linux.dev,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
References: <20250909184357.569259-1-jane.chu@oracle.com>
 <e9b34151-0879-4900-af9f-2ce0dbb678a6@redhat.com>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <e9b34151-0879-4900-af9f-2ce0dbb678a6@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0204.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::29) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|PH0PR10MB4776:EE_
X-MS-Office365-Filtering-Correlation-Id: 64f40633-935a-4af3-7d3b-08ddf16d0aa6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SEZkQlUwNnhwNi9URnZnd2pSNnIvQjA2YTlIUCtiRTNSTFhwWCtwZ3BiNDBO?=
 =?utf-8?B?RDdGaTVHTXlBN1B4L0dhaEdOd2IyK3hDc0pGejJ0dTVmYmZzOVg4MXQvTVRr?=
 =?utf-8?B?aEc1QmIva1A4aWpYaGIrQ05nMWFwNmQxbElCUERWSG1wK2J6N2hnMGdlWER2?=
 =?utf-8?B?SmFiblNvVW51SXlsOEc3ejhpWWE4LzlFV1R4VzJ0UGlVcnlrY0hVN0ZlVlA2?=
 =?utf-8?B?UDQzQ0wrSkppTGxDdlRUeDV1VHA5c2poVW9MQ0pqbmYwaC9pRTJuOVJNcnd3?=
 =?utf-8?B?YXlseWVkdUNPeldrSyt2aE9QWDROVENaRzBVcklZMERYa2NMTzMyU0lkQlY5?=
 =?utf-8?B?UDRER2RrWHhHbE9BU3QvNDJwN3lrRkFFWDZyQjJBRUNBck1tZG9CemRwd2FU?=
 =?utf-8?B?Vm5jdXMzKzJiR1pSeUN3SGZTM0tKaTZ5L3JLNWtFSkk0TFBUSGcyamNFN2Q4?=
 =?utf-8?B?Nmo3VS9lSUZBRVpPY1JweklGS2p0WXR4SHJMVUZwSHhoOHFId0R2OUhldlhP?=
 =?utf-8?B?T0g1Q1lZYVJKZFJJRmJwTzc0NlZKd0srTGFPUGtBeGNXMDl4L0tZb05TSVVQ?=
 =?utf-8?B?cDlHa3lsb2RmWUVwMlh0TUJNaEdVU3RnMzJmTHZjZDZwTnJPeEM4V2hZNndZ?=
 =?utf-8?B?TzRmMGxuOUdGRHBhem1jWjZna0QrVERLbGFsT3RvNzBQTzEzMmVqRTcyRWhU?=
 =?utf-8?B?NTd0NVNWMnRBMXVuL3RPMU9RZHBmclQ5T3M5K0loYWVUMTFNOHlnZWJUdTZt?=
 =?utf-8?B?dnJnWnN4eEFnK0drSGlZNTlzTDAxc3h3MEhZZ2NFYmlDTVhBVVRhWit3My81?=
 =?utf-8?B?M1FYSkl2UUpmSFZIN3FxUkxxNW9HZGNNNEh6dWpzeWp5NXRTUktidGs1RGk2?=
 =?utf-8?B?b3BJSVFHcGw1MDhDQlA0LysvUHZsYjFaL1dtV0ZyU1ZCVEY2NWVVRjVBclhl?=
 =?utf-8?B?MTFTQzdOVzQ2cVlyQjZZc3Vxakk0NktCalQvZUZObnhHTjdRbzRZZEpuL0pO?=
 =?utf-8?B?TDBweEExSnlCNWRROVYxbi9sVWlpL3pJK0RxNGQyRE5OYmRIUWJWRTQzdWVx?=
 =?utf-8?B?czVrZUpNK1RvM3NsWkdDaEJncGhRTTZDQysrWmFCZkhwRE1rMXhIa212eDVw?=
 =?utf-8?B?Vi9GRHd1THR3WWF3V0ZpZWs2ZGhJNFJGT2dLOFVDd2pwRG13QmhYTlhTTkMz?=
 =?utf-8?B?MnhVT1B3NmFDQk9OV0dROTFzVVdMYWdxZktoUTlTcjVSOWVWSDU0WnVESGxP?=
 =?utf-8?B?THNaY285V1NKaWV2Z25QRlVpNmZlV2VLN3N6bVJMYlpFTlpzNWN0RDl5aTJn?=
 =?utf-8?B?a1ZOclE5WHNoN1VVME5PVXB4SStmdjRLU1g4dm9XTlVHYldKYTA4ZHhEKzls?=
 =?utf-8?B?T2U5YlQ4M1owOVJEVlhVTnJiSS91ck1yVERXT04yVFg4OVJjb3dYZXkxOWgw?=
 =?utf-8?B?NDEvVXlGUlJYelVWdnhHd3RVbXFiUWIzWVozS0VHNGFwUWVScVZWd01vUVYw?=
 =?utf-8?B?MW5JenFiZWNGUTlubXlhU0ZlT29MOXBPcTAzSzN4NjNpcEFUVEZ2K1M1d3BV?=
 =?utf-8?B?eGx6dXhSdkkwY2xENkF1R3JiRS93bGxtNHJQZHAwSHhPVFhIdWk2RlkxR3ZK?=
 =?utf-8?B?Smp1V2g0d0t1QXhjVjBBS045QmNWUUhVbmJtQVZ1QVV1QWNEWFpMTy9GeU43?=
 =?utf-8?B?TTdQNmxEZElDRjdIenZyY2xvZGxSOFU1WTZycnp4WW9TaitQYytjWGVEUjc0?=
 =?utf-8?B?UUNLd2p6T2M5M3J3TjN2T3grVnNKQzBUd0RNbnFjM3FaU2RGZEE3bDRXeXRH?=
 =?utf-8?B?N21FdjA4QTJjTmlYSnVTSWtxSGJtTk9mdFRXemNYclN6U1pPQmNlZlZRd2lW?=
 =?utf-8?B?VDh0VTROTStqRCt5Ujc1T0NBUUFSYzVlYzBQN0tGVlFvV2c9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R3FjemhpV0lUaDNWbGprTzFldFdVN0xMb0VlRFBlam0xVkR2dFRjVWxPaGlt?=
 =?utf-8?B?YVdJeTk3bmlVNU1oVHpUOGVaakRvdmJ5czBZSk5Sb0N6UlZ2ek5yVHlQbU40?=
 =?utf-8?B?SEFwbFYxQ2lLb2tjM3JYaktmTExCekI0K3h0Q1Y2UTU4dCtJYlJLYmhIbElm?=
 =?utf-8?B?dlZ0VFFhYzQ2cEhuYnZaeXJFNi93ZnVqeWptZlhENXJiZlZNUXNWNDNKQmhl?=
 =?utf-8?B?bk9aeHZqK2FycUJ4TmZNNEZ1V1RxQ2VaelhUdGtDdDkvRjlFNkVhbm5QcW9v?=
 =?utf-8?B?MUNidERrNFkyUEpnL2JOWmpPai82RUdueVJaMmFkMzc4OUNNSzRkQ1dqQzFm?=
 =?utf-8?B?Mm5SaU43NFJzMDlXby92UXdaakk5K2h2VmJhMGtkN3VMbnlpL0d3c0Y0Uzdu?=
 =?utf-8?B?Rld6aTRQd2t6S3hZMjNGUXBOODRZQ09QYlhlaVg4Wmx5dWppT3VkOVVadVNG?=
 =?utf-8?B?NTZXd2w2cWRXUlhCMlVXZGJoMGJHTnh5WE9JZkNMWlpwRUtnS3lEOExLZ1FT?=
 =?utf-8?B?dGlRT09HdWlJNDdMcUFHVmRMeFhZbFlUOW52NmI5UGg0ZXMvSWZDbFVvaFd0?=
 =?utf-8?B?aU82L0JlUFBOWlRIejhDUWtGTUtlZEtaMUc4VjBOUG5OU3ZqZU40VE1RNzdG?=
 =?utf-8?B?TFZSanJWUTkzSUJEeGNUanRLYitSVkJqYWgreURVL00zQU96cXdxdC9iRGVK?=
 =?utf-8?B?OW1WMWlOeTh6bCs2Nk8vRERGNEJPYTVwenNqeHNtNnZKYzJ5Qjg0UGJ6QWFG?=
 =?utf-8?B?czI0THBLdE5yM2ViaVZ1b25YZVNQWUdQSy9VVkpJVFZ2VEJWRFcrSDl3M2Jr?=
 =?utf-8?B?WEMrcXpETEZoNDJwKzFOL2JkeTkrK1RaRVZGSnMxaENwZWZzNTJ0M2ZDSjZE?=
 =?utf-8?B?ZjI1UWVOV0V0Uk5hTlhGZW9KMUxGUlhxS2txZnZreEJXRTd6Z2lkZzh1c2lw?=
 =?utf-8?B?YTJaenZrTnFpZG12TzFDZHYxV2xTNHdMR2FqLzFHckl4aXFJWVdaS2c5a0dB?=
 =?utf-8?B?NjVMZnBxM0hkbkVYWWF1SlI5UHFUTFBZdy84MjRqMlhENTBNSTJ1aG5VTzU5?=
 =?utf-8?B?NHAvM2JlRS91SmprZVE0VDg1VzFwNHpkZ1VkcU82UjR5ZVNyRnQ4N0lmUFRj?=
 =?utf-8?B?ZThHT3pFK1NOZXQ4dTEzZVQ5bXQ1M2NoYTdIZGdYUjY0U2NzY3lLMlJ5YWFT?=
 =?utf-8?B?aVU4eThZN0xGMXhaRnk3L3k0Nm5TM09Vbm9NZlZkRmgxTEpUS3hWdEtmWVV2?=
 =?utf-8?B?YU9zdGRrempRYW5kbG52aU5Fa1drcWx6RDh4UGI1QUlOYVFiNWJlWTYvSmFQ?=
 =?utf-8?B?VjNPT1Y3akM0L0k4M2hOaTlyVTJQSGI5WWo1YXBkRUhVZUJ4azFQMGRubWVF?=
 =?utf-8?B?V0FEYWR1Y3daWW8zRDVTa295KzZweWZTSGI3Smo4OEJyQ3ExRHRsSkNUdGZE?=
 =?utf-8?B?SWk0WVE2WDJUck5oVGY3Z0tndUo5aEpHeWRDR01GbG5HL3Z4dC9BOFF5OFA1?=
 =?utf-8?B?b3hDbTdvaDdpb1hFdXV3SkxGTXloNThMOGVGVURMV2VtN0NSaXltSmJsTVpV?=
 =?utf-8?B?cWhxSXNuNWN5SEorQlpCaDlTajMvaWYvUVh3L1hxYzRkQ2xjNnlTK1IvS3do?=
 =?utf-8?B?YmhUVllOcjlCb0JKZXBVL3pHczREWHk0QmRjOTh1TVYwT082NXF6NzdabHd1?=
 =?utf-8?B?R1Zad1dsQnR3K3plNWhTU2orbUk2cEJ4VVVMZnBkbEJhYWRVYmw0THdPUlk2?=
 =?utf-8?B?Q1ZWMWtEeFpxOEhadklWeUF6MTFzMUtxQ1FlbnBLVVNrd21iOW1Hd2RTRERY?=
 =?utf-8?B?bmh1RDVGSnRUSC9UT1ErSzY3MnptUVZmQWNPZ3M5ZXVsZ3IyZGhnK21xWEsv?=
 =?utf-8?B?WEZEWUpmSnFaWm8xN0RtaGxRZEcxUDZyVkUxdWxYUGJHbGdhWFFnbDRIZi8x?=
 =?utf-8?B?MUdVb2k0WFZVZklVcXJjVENHTWVZZS82TWVaR0dtQnR2RTI3VVVia0o5ZXk1?=
 =?utf-8?B?dEs4cjZrNEhxODk5N0dGYjB4NDJrNlVBVmNKUmpmTkplNXpJdjRKTllTa1p6?=
 =?utf-8?B?eHl2NEZjVy9EaS9VYWYvcFkyTElSd1ZRR296TVRUMzNldG1hOTdicTRDWUdR?=
 =?utf-8?Q?rIVMrPfXWRnGGhc4huZdO+IcT?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	srNP0j4fD3OzYqF0OL24aVMY5j5y3pXwXUWN7SXuEz+yZW/vqVzc8131LtIR6SRP7t8chJjj1pXeUMJgusPhjZnUTKxGI+V9z+bG1MPaFhG+n+EnFoahSqxIl1La1R5lw32AH14hmMHjDfWowAK3CdXgjPUjrR48tZCjGVGhqKcEvyGegf3lorJe12LxAvtWGBgjjZ9MJmGlNcu3jNZGBQ66jpxJvKQOEfUJGrZGZwqZtfegtegxUwT/JiwgJcPsGob22vOt+FKd37QfC5dL3C/085Grd3zdbDjhkdZbMzoUf2NJ7Sskj7ak4wZ7gj/aDW/7pAInkGWmoIcok5fifAUmjE38VTgO1PmjJvFA2MLTjmjK9JnHJsW7f1HDsvKoGIFVSPFmySm5P+9WKLlbqYr4XR+/vPpA8srJsX+7opzRy7IhDm2jF5tumphb/TgiLlhop0tzXiLNKjjE9P2S6Y00fqgSEZ76rFktC9Zc0l7VNv3BwVA1OqoSZNNBlclwXZM2cBOk+5wW+9lUbvDQ/LcSIYDM3CwseyzfZLbWP6LfQcRFIjQXvDEW2iYIh4kc3cHk74/b1N1hprWx9sWX1DyKYbZHtUc7COLtpO4EIQA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64f40633-935a-4af3-7d3b-08ddf16d0aa6
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2025 19:54:39.0465
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TFFjdh6/haoNWbNN1CjcrMJcQU+rephuh/K0OMlNlmWEo/VX8ziGwBcm7CkMpNSYQfRnXojNiiB2BBLZk3Qd8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4776
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-11_03,2025-09-11_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509110177
X-Authority-Analysis: v=2.4 cv=esTfzppX c=1 sm=1 tr=0 ts=68c32902 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=A4OsjvImO4NSfowvoicA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE2NSBTYWx0ZWRfXyY1IsokDEJTb
 +pX/rA0AwZToWW9rWGYA/H2Y5foiJuSl/UdyNFsGhLyoRsr680S/LyCpAWvKolA804wPo4YQzAS
 IhHINMI0hQM+X+ZHMPgFwVJzh9SmqYAszhZNrfhZa8MQEdQBzhRFH5x33CMZ9XuZoqDS/5luXYZ
 3NNZ6ebtRFmRH8pHHUB/HIqdzH/BMhh09Wb6m3/T7WpnWmiWjo1yHissI0VNSIzxvkDLGYJ/7uj
 xtLKbTJewSmfrFPfAUIeN/1xtIYyI8oA7mM2YUcIVeTwqiRcEFUmSNrJITXV7UpXJ26qxeNJGG9
 vvRWxGkW4XjAB2p89Lro3AP/uMO9PTJoGt37m1RfTPFmpzmjjhIgjaXJ+zTWwmkKO6ZyvdePDAK
 XDrqd9X7
X-Proofpoint-GUID: Ce0Ju1vnn5A5mjpCE5goOHg9pqb12Zef
X-Proofpoint-ORIG-GUID: Ce0Ju1vnn5A5mjpCE5goOHg9pqb12Zef
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 02EDE1C0009
X-Stat-Signature: 6zd8ej7rrbp6a493phhaxpaip4pcawot
X-Rspam-User: 
X-HE-Tag: 1757620487-330996
X-HE-Meta: U2FsdGVkX19IQU9GjfEN0PtO84LzRomPksRrXjL3YSrCvF1rBumbaLbVdOmxtUH1E3c52WA5nCMEK3/fHQ5SKqkdzTPKqvTCRWEI114IrHCknKvLDiD4R5Zx1L+zmTKMgErHVY0ILkrHlBv4KRJTVJXjrBts1qyjvnKe5frTcjdcJDug5jcPxmeusN1ZZbkemumL89D8ziAr65PvTpk2P71ECapevmEOHVB+vhuDzx/b8GgGoIhehCx0+tA0jqEYOwOWV3nuOUIntjtEnxWlS5hziJ4GVKn684kgeAl1TkPAzSwWxMBX1bdQ43zZMRXh7nbDN8j6aoRCEBx6FF7puY29+WCkP3ff4kCXrKVM14yfFNkK03u5fk3GM5ZXPLHisJO/wwnDgC/HDpoTs5o2j9LAsd4mWpHoja86wBICIAhstGieL10RHGaTqkAKRsHtJSn/pcjnev1Glqsax7jBj5maGXUyD9bn785qBMhkKyw3BV12LJY05CBGh0tCogaX3ThclDVSA8my61eaxyg55nXel4k3Tt8Ozw2hA1//bq91WMR2RQ0YP2FtlZNCDZouEOYc606d5YR643lzuQx70Bcu+wFiKxbcH85b/pYgUxMLYc+bz5K0k5wmZg46M/azH/mGW+j6t84UJXv2BKQd8oNrAOpm4YZMb41tbdAe2oZM8UsEogW0hhed7oUTpD6Lcc9N7WeTgi9/MIt7kK9dBVTkbCeQnxtYTJgsUP51hTB4EWotgx7LOlsbcBtsl6g7RSZtrwMYAVfupZT7f/kIT57RLuzZa5zE8yMgJmz6apFEPJCHciYy6x2X9bOl38y/bUCB3rzVy83ChEhfnrOvvcDyLsplw9wE7a5K0+/7sSWwVr8jZlu/vqqtHRX2XUly3D8DDdGKN9WwQVh1S22jHx04cVCzib8vmuiQ4CgkVkHDLgPnHbLEjHji2rvc7xcyGf5CEcsITFAvWMaSx3t
 mxBbFf+B
 4aAhDvEaFRrY43InNB1S+0mQP9KZEuJLkXRQANtiBO970yagdCYjXj1rP4rMdrQFTuBxYOJpXSK+qvxgZldnF4YPzhfScJ01Fg8hvZ/bBS//aLQZHyGjqaHFMFF2dSoNxUmz/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 9/9/2025 11:45 PM, David Hildenbrand wrote:
[..]
>> -        /*
>> -         * If the pagetables are shared don't copy or take references.
>> -         *
>> -         * dst_pte == src_pte is the common case of src/dest sharing.
>> -         * However, src could have 'unshared' and dst shares with
>> -         * another vma. So page_count of ptep page is checked instead
>> -         * to reliably determine whether pte is shared.
>> -         */
>> -        if (page_count(virt_to_page(dst_pte)) > 1) {
>> +#ifdef CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING
>> +        /* If the pagetables are shared don't copy or take 
>> references. */
> 
> Why remove so much of the original comment?

Because, this part of checking has already advanced from the "dst_pte == 
src_pte" to "page_count() > 1" to ->pt_share_count > 0, it seems cleaner 
to just keep an one liner comment.
That said, if you feel the comments should be kept, I'd be happy to 
restore them with a bit revision.

> 
>> +        if (ptdesc_pmd_pts_count(virt_to_ptdesc(dst_pte)) > 0) {
>>               addr |= last_addr_mask;
>>               continue;
>>           }
> 
> LGTM, thanks!

Thanks!
-jane

> 



