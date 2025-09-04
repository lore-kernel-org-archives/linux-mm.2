Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99221CA1013
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 17:48:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 015B88E000B; Thu,  4 Sep 2025 13:48:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2F968E0003; Thu,  4 Sep 2025 13:48:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD15C8E000B; Thu,  4 Sep 2025 13:48:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CA3D18E0003
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 13:48:09 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6409C140308
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 17:48:09 +0000 (UTC)
X-FDA: 83852301498.20.8B6278C
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2095.outbound.protection.outlook.com [40.107.220.95])
	by imf27.hostedemail.com (Postfix) with ESMTP id F254440010
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 17:48:04 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=iZheaJpi;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	spf=pass (imf27.hostedemail.com: domain of yang@os.amperecomputing.com designates 40.107.220.95 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757008085; a=rsa-sha256;
	cv=pass;
	b=8eR9/WWDY0PIECh5LR+V5rKwe/kwWgx83n729wRwQcpXVLIf1/kXjnKsAbK9cPyrrAAHNh
	CiybUTGP5hxjsx8JbiZvPVbHTD6HdtHlAIi+orGXgOsenJEkRBGVrOVDteD86b1pRN6thR
	/LbbzVff3PZu42jpDq2mSwNc3n+Ccoo=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=iZheaJpi;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	spf=pass (imf27.hostedemail.com: domain of yang@os.amperecomputing.com designates 40.107.220.95 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757008085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CxnDZbOi8nvPl9oBI754SV/7S8VFLHNtyDFqCZS3cyw=;
	b=KiSTlpdODkWNsB7YHVJqmzoJybiCKAahfM2KqtQFc7kIVqhVQjJs0kanKMJXtev6XXob9u
	Y+U85XO5onK2kiPqPlvL85EHKMtOsFoTUamNOvKv/U+G+WcQoezGv3Td0QXNfW21ZXBs69
	6F6hfepYENS0QdgYp0Q6rWbOAAhMVqc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lw3kWsWry97bvXQwE99rWNEchRdf1aohYaKVotMIKLUDjT1vu2YNxukObx/TPhLGOxwwRY72OEbK5DbnD7q1UT22Ci/kBDSqt0cVSQg/H2Ou9Qfr/+fXkaceWo067N2BjugZcrrvG6EkSnAYLrxRUI285LEdzwpIbL706AOtiH0qY+ZwhJl1NOL2DfbYROAquW5bmZm/HAWavyGj7uS6rfgrbhcCtcN1ZQxtKyvOdke31LVmUN4/CywneR5rSeK3+UavTNJzOWrJNZQE4XjNTtZ5oAOgL0k0tMS0XJK3KYMu0Goo/JbnHzP3OxTuCDjqBWTL8fV1izs0HkGzfLit3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CxnDZbOi8nvPl9oBI754SV/7S8VFLHNtyDFqCZS3cyw=;
 b=vJ2JdjkqsGM1UAccJNMY0MTPGRTt6bLER4+eYJ38IQv0IButM5gNu/gY88DgjWTYBPs0KfA6ZyHiqeQMEN/H+EtmQcEk7MvKMSME3dl294AC61bXsLKT/0iTcD0bZLyoukDmP0URGiThnkH0Xnws3UKEyuVAuoOmiual5+Er+75arG81VzmQKOAGyEbW34Me7wjLO14+6gHoiYVptY/XoB8kkjP/zf4hpr/v5ldfWuk2vn00FecymNFGpDZWALnRnc7qAI/bUPaOI+Fy4uh7KK2sFzrcI941/KzPtRc9F6igy7iqo5TisBA109xSAqKLeWTeqoNhTWbI6Fcp5e2hlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CxnDZbOi8nvPl9oBI754SV/7S8VFLHNtyDFqCZS3cyw=;
 b=iZheaJpiiZIRrL8g/AksTiIyfy0I3fhWKkAe9jcz5usuAbXLj2zLRII5pY5WzJVl6Johs/2mVSQNmKFNfncZioya2WpFj3xfkuZmC9ygZzWYWWhj5GtdmNvkOUWQ2S93vRsjzdNOF97Dxb8owKJXUPJRsPtbhkwd96XYXVa8Hy8=
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 CYYPR01MB8309.prod.exchangelabs.com (2603:10b6:930:c5::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.17; Thu, 4 Sep 2025 17:48:01 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::3850:9112:f3bf:6460]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::3850:9112:f3bf:6460%2]) with mapi id 15.20.9094.016; Thu, 4 Sep 2025
 17:48:01 +0000
Message-ID: <bf1aa0a4-08de-443f-a1a3-aa6c05bab38c@os.amperecomputing.com>
Date: Thu, 4 Sep 2025 10:47:56 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/6] arm64: support FEAT_BBM level 2 and large block
 mapping when rodata=full
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
Content-Language: en-US
From: Yang Shi <yang@os.amperecomputing.com>
In-Reply-To: <f8cf1823-1ee9-4935-9293-86f58a9e2224@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CY8PR11CA0007.namprd11.prod.outlook.com
 (2603:10b6:930:48::15) To CH0PR01MB6873.prod.exchangelabs.com
 (2603:10b6:610:112::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB6873:EE_|CYYPR01MB8309:EE_
X-MS-Office365-Filtering-Correlation-Id: 628bf72f-2d51-4b3d-5abb-08ddebdb30d7
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?c2cwbDhmV2tBU2JIaWg0U3BOY0pzd3dZZERxWVZVUnc2cGZURGxYRnRiQWVI?=
 =?utf-8?B?YldFaGxZTWRKMnpFV2d5eCtkMVUxT2o3TFBMVXVBdnlKcGQ3V1FCRHl3aU9Y?=
 =?utf-8?B?UnhoOXhkTTkwZUJpWG53bktteWx4VkdJeDJDdVpOaGg4VWJJTktVeUl5VUNz?=
 =?utf-8?B?VTN1Zk1sMjQxQUhxTTNaZEFMQktXTWVBZUlJOVRXb2FlM0l5dmp4VGZQaWhI?=
 =?utf-8?B?aVdZQXpCSlpGYVI4MlNiVnRDa1RMWkRQUHBBNEQ2ZitqN0wzUlJ1WmJmcTI3?=
 =?utf-8?B?VkttbXlFUENRZXVkc2FobG5hTmNkUnp3NnFlUGtJS1ZVS3Z1TlhuUHlWUjZP?=
 =?utf-8?B?ckFHNk1EMTVWdFZPSXk5QW5kNFN6OTJtMStpT0Y2WUo5ZVVmdlh0OGhBY1ZW?=
 =?utf-8?B?anlQVnpoVmtYc2s4aWpIS3MvTVJ2bDNGbURwamlhQzhkeG5pSFYyT2RIM2RZ?=
 =?utf-8?B?dkVQR2phTW1nMXE3NEd5ditWK2kyak5pT05mT2ZMNnorWGtoUm4yNjRXR2pZ?=
 =?utf-8?B?ellJcHV0NzJTQ3dMYnpkckFqclRndnRjcXppNVdrZk55UlVlNEZtd3lyMUpT?=
 =?utf-8?B?ZkVmQ3FQVVJRMlAyRkhzWkNiSXlwUCtka2xnVUR4dExOd2RJT0dkSForbDNI?=
 =?utf-8?B?ZGZmMVRKc2dwNGttb3RjQUNhVlZ3cW0vRjBIWXprZXZQSjQvLzA3MTZaaEJt?=
 =?utf-8?B?cy9hN1NwT2tFTlRTWkxXT1JET3lkQWhsSjJ0RDdoUXpLZHJOajNUd1IrYURh?=
 =?utf-8?B?T3VOUnNqZURxdCs0SWcvMTF5c0hueFNRNXl1MHhtcDFMQzJLeUxvT25WYlVx?=
 =?utf-8?B?dkhjRGZVQm9qb3BlN1kyQzZaQW9BemE3WFlZTWx4VEhsbURMVkIvWTA3VG9s?=
 =?utf-8?B?eU5renNSQTdTZlRpY0tlbkZaSVk0eGV0dC84aEtqa09qdWJVN3lRZDNuNzZ2?=
 =?utf-8?B?RlNySm5SRE5JRy9tY01WRzlrSXpReDBVbXdla0JxZlc3aFd5QWhzYzNHbzk1?=
 =?utf-8?B?SVJsUDh4RGFoVzFHc0dxeEx4ek1ySExhOWdUNHpyU1hHZGVKRmhGQWRab1dx?=
 =?utf-8?B?RWg4ZlZYUUQxRzQ3NFVsaEtRbzIwZlV3cjRudUFoaDE0SjFnZnNxMWN6eC9y?=
 =?utf-8?B?UkszNWg0SDgrcnNxZVI1V1YyTUh6aGYyQ0huZGNjODdzNWhxUTZVbzhuUnQr?=
 =?utf-8?B?aFkyMVgxUXMvVjZUYkowNTFZcXlDN29qN3JtWlJWNlZ6Zm0rTWFHM1FSZ0w4?=
 =?utf-8?B?aktkb0ljRWRsQnBadU1ZenR1NUNuaGt4YkNMQUVhdng5dURsZWJzcFZtSE1F?=
 =?utf-8?B?QUdLcVRYS1duMkhoUlJkV0lGTTRsYVRYZVJKOUpqTi9rWUVwQ2plQnF1ZFRu?=
 =?utf-8?B?eG05dUw0L3VMS1BjMWpqRlRZT29keVI3cm5XQ3NvR0JwdlZkdUpVSjEzdndv?=
 =?utf-8?B?UmJOakx1SHgwS2ZtZTBIS1VoOVBxb1E5a0NxK0pOOUFhcjMrTTF6SU5tOU1X?=
 =?utf-8?B?YXJoVW5KZzM1RmUvLzNVUGFwbTVqQUxRanlkZ2dhUUd4K05PVE1VVWcvV2RJ?=
 =?utf-8?B?RDRkcVBmYzZ0THRlYllUUDZHTjdwRUFIQ3ZXRnF1OTQ0cjgxcjdsdDVZRXg0?=
 =?utf-8?B?U01wUVdnVFUvalltb0tTcDRZZmd0Y2NTZVg2anlxYmFTdnFJOTNaSkI0S2Iw?=
 =?utf-8?B?WmJobzBTOS9LSmI5NUJWWmRMZlVINXpoeklZQkJNNm5IMlN2SkhaZnhnSUZV?=
 =?utf-8?B?Q0pxcUNLdVVZcHl6Ujd6RzIxUXcyeWFCbW4rYmhKVWw3OFppbDA4Yy9LSG1V?=
 =?utf-8?B?em1tUmZUQmJ0V0dlbWN4dmV6UlVqTlU1Z0lCYmt4ektVM2NIdXJQT0xxcmZI?=
 =?utf-8?B?eit1dGpMWXQwVmFtdXRRdXg4dHpsOGhramNHSmtNdWFkT05qYUhncGd6MEhO?=
 =?utf-8?B?cFFPeXFWcFRkU2Y0RXJTb2l5cGFpQ0EyK2h0TWY0UmNaZHM2VnovUU5UVU9X?=
 =?utf-8?B?YllZejZueElRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VjlpR3RTT2tPbjFMUnVWVmIwNkZwTTlJcHd0bmhkTmlGVStQakxVMzJtSWZI?=
 =?utf-8?B?QjQ2b2w0eER5UHhlSnBNZU9kN0lobjAyZGdIdHh0OWx1TUNFR2ZVTkNBQ1JH?=
 =?utf-8?B?cEUxemhiZjA5UmxSWXcvdlJaVll1RmVLckJDcGZxVXVZU3UyaWhXTUZIVVJ0?=
 =?utf-8?B?SmY0MkdpK0QrV2RnSFJpVC9FRW5pb2g5eFREbUE5VDJaMXpQU0Z1cEVDODgx?=
 =?utf-8?B?bnhIK2dJc053elUyZ0FleUQyR2k2NHZVN0g1aVNuelNQRkVjaVBBbEx5YWdh?=
 =?utf-8?B?THVhejc4R3M5Q2FOeThKRFZNMHk3dlZZNVh5czFiVUpncVo3Tkc2aWhiakdR?=
 =?utf-8?B?bTRoaXU5OWlRUHlUR2gxa1RSUzYrREtJUTNib1ZiVHdMbzdwMHQ0anpnbXFT?=
 =?utf-8?B?cHdHVk5EclRGNkpyREdWNjV6VGRPZWpJU0hYUnhEdEliTkwwSFFQRktqNWc5?=
 =?utf-8?B?c3MvY2pxSlJQellhTlB0THJpVlVwelVqZE0zbmpzNWZsQWdzVDJhUi9uKzBj?=
 =?utf-8?B?MHR4V2dGdkppOXErMy9MNzFTbDdTZUliLzV6M2I1NDRtL1JQU3B5TGx1Q2Vs?=
 =?utf-8?B?aVRKS2xsVnhObUd5czEvNm9ib0RKVjZ0eTBYZnl6c3FvMlFRbXpkeDYwWTBW?=
 =?utf-8?B?eG1rRFgvNmxMTHBSYVR5WGZKeEdyc0tpY0p3SDl5MzhqeEt5bmtOMVBqa2ll?=
 =?utf-8?B?TzBrQVVwa2NQQ0V5WG5BR2ZUMlNacjkrZmd3Q0w4RkRlM3lOSkdUSG1INW92?=
 =?utf-8?B?L3VXV1hLc2NVcUFjL2ZjeWU1YkMwSlJwSnBWbUcxYnZ3NHFpd1E0MlJvb09T?=
 =?utf-8?B?NEdMeXJUeDJTKy95Ty93WDNDbmpqcjZ1VTJLc0FHMDFQcmpFSVBmTjFjbnlS?=
 =?utf-8?B?bllhcjRHWFVHWkMxMXFXcW5qaWNVbHo3MmZzVEtrSjdqeG9Rbjk4eFkyQzNK?=
 =?utf-8?B?VnNLckdjdERhaXB0WVJ0Q1lndklHMncyUnFzdmRDRytlTmlFbk9vNHo0UnpY?=
 =?utf-8?B?WFRCbUlUcnMyWmFUMkpzdU96bGhVckdGaHQyZzI1TU1uM1dJUlZKWjUvNCs3?=
 =?utf-8?B?Y294b1lFQ2ZqRWZ1ZzROWjZVR1Y4RWdzWnVVL3hHY1ZBSWk4SVFieDEvMGpE?=
 =?utf-8?B?eVZNak5FL0JRSWxCQzhFQ29JdENHSVRhK3NDK1hVV1B2SnhTbzUxTURPZDVr?=
 =?utf-8?B?Mm41a2JTWEtXeE1oRmF1T0NsemFKTXBVS0NZbTNqeHNVOUhxUVJoZm0vOEVj?=
 =?utf-8?B?d0k5OXozZGo4Q2Ird1lPT2RmY0gzVjdMZ2t2eS9EWGdqcjM5cERFa3FMUWRV?=
 =?utf-8?B?S0tKT2JXNEw2UUFtY3hPblM2Y1FjQ3RHSHBtYk9LODlneFJoekhlTmc2MXBX?=
 =?utf-8?B?dVBGQldXc0kvWENsajY2TE84T0tiUkpPRWRQYWkwbkNTcDdOSlgvdEJhQ0tD?=
 =?utf-8?B?M2FwSEhrSC8xVTdqeVJNOHhFKzZUQUNYZkJlRVgraWhhT0loU3YzU052aGNX?=
 =?utf-8?B?ejB1aktyM001cis1UUhPRmt5amVxWXlObEVITkdNTElEckdRZFcyNEFiOHRv?=
 =?utf-8?B?Y0IvRzh3eEJxUDlwM0xBb0RSTENNOUpTeDNlbTFZZ0drYlZqZXNFYXBIeHZ0?=
 =?utf-8?B?b2d5cWMzandmenUxZWwxaUNYaG14YnhPQ056bGRzY21ON2grUWRVa3c5ZnRs?=
 =?utf-8?B?Z3V0bU9LM1ZkWmN0aS9nclZ0Vnh2UzR4QXFjWm1SYzJON3M4NmthRXZKVmFy?=
 =?utf-8?B?eHBUNmU3QXpBVkp5ZzBGRTZmN3pBV3VjckZjSWF2d0lQaWliZXFLRGtWVkNl?=
 =?utf-8?B?ZEVlcFlQdzljNUpWSndMVkVoWEc3WGM2NGNQTUw0aW93R1ZBMjg1Q253VEx0?=
 =?utf-8?B?NzZvSWVhL051VVk2QkdaTU5FdU9xVmlnSlQvNzJocjd5NlJEOEIzeXplYVRZ?=
 =?utf-8?B?NzZoY0tnbW01SktEem0ybnE1L2tibjVrUFZlajV4TEpEcW9MMUxTenp0S1RK?=
 =?utf-8?B?SzdIQkx0d0NER3ZqM2ZGci9tRzM4ejMxWmsrdkh1S0lHVXZEZHRTcjZ2OXBU?=
 =?utf-8?B?ZnMwSFg4SUVpVldubkFuWSthY0VtNU9HZThaNzRHK3ZlMzU1aGVaeTlOTXhy?=
 =?utf-8?B?dFh0M3lOWUNHZHR1K2h4OTNoSVMybnNiZVZSMUR3NXdEUTJ5Q3p3YXRhWEpM?=
 =?utf-8?Q?/IUdKyP0odi8tRfKfq6HrCA=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 628bf72f-2d51-4b3d-5abb-08ddebdb30d7
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 17:48:00.9453
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YhiXYM8YuVzgDeh9KXI0QDtUvVRYX93nzHobYjI11SGxSUbaKS01XyccBpgof/ytGTFYZSl7tIJw+q69Lwc4f8QEfpcp7r2Ia177XVC+QmI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR01MB8309
X-Rspamd-Queue-Id: F254440010
X-Stat-Signature: jrf7tp1e459j5zfj6t9636ap9usj6stc
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1757008084-841709
X-HE-Meta: U2FsdGVkX185HU2qpORHbBf2Oc7Q0V98idk0/txd/+GGFRFaPjOuTqFV+yRYLxndBK8lE9OFZ775YDmj9gjX+fM+kGou/zGEeyCrmUumrBCytN92LK8I1ZtBiOnbIqiVtJxQQYF7iTahR2xPfjhgxRvkxWlfRraViEWLRJWdzmRkiqRIhhB7ubtxFxuEU6zI3CeIe/tqJcRjbamKuSVhQ+Se1/hCUH6Cl3WxEr7XXjCEFJIqdFummQzqBhEVQO0Vf7rArVLnjNyAKKMfkkyoMumtdn5rFCeXGvEkHgsRqE3rMcjAIlRO8mGiZIS+VmFb18lyUpWKwn86QR79W7uNCek8ewwQcjSgnGkudqiUKkv8pwyUeXgWV+11bzJ4mM7iBKf4AFp/XnBGARTivow2UWYFMluoMrYv8E1ZbWPl6xQxHXYlauBaIItXS/FfL2oi5q/PaMtdoxOA4rXmL5tsqkl+oVv6iQX6lmu+AqCJ5impFYY8kzjOJBAxC5dIE1Nl7+K63uHY7fhw1G3VMdqI7qKwxq5zamjf4fj9IAUHlvJt7lCHPTDbatHRKY90d0OsOshofXTI/2fxwhz4PgEC18ZBk5OHJ7c3smX7Jbug6dQu4IFmhNGd7YT4thAf1sglj/tjtjdMuepUVlxnfCcUgbQY+B8ePKm/UbWZtTfNJY9tAQ1ax2CVRXDP9VOieVcvLMVm2xfnHZO0TkF0P5OdFVPT0sEkm56lLd590YNS5Q9QwuWkjL91jb+XiQibhWaoNAbRoOxNg6EdVFPfS9ZbSN8a9cw4qDq80hKNE75vwNx0I8j9EEwccAfF6VXAeSbVhqeKNlr9vIWvYto8kwVhTAKPEljqpp+afTzXebSyZk7SfnvjLB0R3l861RthIGFPWerAjlDhEkP4vxJZXiltvWEYx8ldSzev0wnTjW6lpLOA0SEwTA6zy/yDifQ3CQnEREt2VN64cf2fnStscLm
 LD3woQFl
 y5P60FwkhkvAtp8EUNBbOn2fjDJ3MLFAiqw6BygvJ5wrVPt9Ldofe8fpGIh7ae31cscOCqhe+F2Zi4+vcBHHyvGrX5vygmDeYJ7eQJLvoTQ1aw4KDxzZm8yRlBiFYX77KISEU1clGTHV37osF903oWbiCjpNKKUw6L4BwCTAbnFGoSKLoNg7qVY1mSw9kNOIZ7w8wMbtd1cS2V+Q2pia6qPWawOpsgqopBG9MsoVeAmBhMwsKrqWUnQvjm+Is6jJ8QfsAeRbXWZTyWB7PY+6PCYDxxUN+AP/dzYaF9CPU0nnhSARwZze9bnvqHDVN4srGad5QOh4ZSYKYhspsIZi90Rvy2qDtPCpM+uTtnnXGT7p4YGNvl/oQAtIV0ha/gRdixH4Xa6+nle645X7SfXUI+2i1rYXHJ6/U5hun2+wZO6urqVrWflCbqdTKvlHzpKSr0kZXl1WMrGyKB6JxgSy4CUktiwYW4rSnX5+7i1cbw1VAP2ZIsdwJ84D36vaLz+7b8Vi0t+rY5TOBXIeNKPl60gnVZvV52aHBqLXjQIALI2o1G76uJDrwMrBvGPKPQ8eoJLdA9bx/TyCqrhSwBca1VbG5vjXvSVAL4+f41rRto5SJeFjP4WCD7WofgB2Kdk9aD9Mt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/4/25 6:16 AM, Ryan Roberts wrote:
> On 04/09/2025 14:14, Ryan Roberts wrote:
>> On 03/09/2025 01:50, Yang Shi wrote:
>>>>>>
>>>>>> I am wondering whether we can just have a warn_on_once or something for the
>>>>>> case
>>>>>> when we fail to allocate a pagetable page. Or, Ryan had
>>>>>> suggested in an off-the-list conversation that we can maintain a cache of PTE
>>>>>> tables for every PMD block mapping, which will give us
>>>>>> the same memory consumption as we do today, but not sure if this is worth it.
>>>>>> x86 can already handle splitting but due to the callchains
>>>>>> I have described above, it has the same problem, and the code has been working
>>>>>> for years :)
>>>>> I think it's preferable to avoid having to keep a cache of pgtable memory if we
>>>>> can...
>>>> Yes, I agree. We simply don't know how many pages we need to cache, and it
>>>> still can't guarantee 100% allocation success.
>>> This is wrong... We can know how many pages will be needed for splitting linear
>>> mapping to PTEs for the worst case once linear mapping is finalized. But it may
>>> require a few hundred megabytes memory to guarantee allocation success. I don't
>>> think it is worth for such rare corner case.
>> Indeed, we know exactly how much memory we need for pgtables to map the linear
>> map by pte - that's exactly what we are doing today. So we _could_ keep a cache.
>> We would still get the benefit of improved performance but we would lose the
>> benefit of reduced memory.
>>
>> I think we need to solve the vm_reset_perms() problem somehow, before we can
>> enable this.
> Sorry I realise this was not very clear... I am saying I think we need to fix it
> somehow. A cache would likely work. But I'd prefer to avoid it if we can find a
> better solution.

Took a deeper look at vm_reset_perms(). It was introduced by commit 
868b104d7379 ("mm/vmalloc: Add flag for freeing of special 
permsissions"). The VM_FLUSH_RESET_PERMS flag is supposed to be set if 
the vmalloc memory is RO and/or ROX. So set_memory_ro() or 
set_memory_rox() is supposed to follow up vmalloc(). So the page table 
should be already split before reaching vfree(). I think this why 
vm_reset_perms() doesn't not check return value.

I scrutinized all the callsites with VM_FLUSH_RESET_PERMS flag set. The 
most of them has set_memory_ro() or set_memory_rox() followed. But there 
are 3 places I don't see set_memory_ro()/set_memory_rox() is called.

1. BPF trampoline allocation. The BPF trampoline calls 
arch_protect_bpf_trampoline(). The generic implementation does call 
set_memory_rox(). But the x86 and arm64 implementation just simply 
return 0. For x86, it is because execmem cache is used and it does call 
set_memory_rox(). ARM64 doesn't need to split page table before this 
series, so it should never fail. I think we just need to use the generic 
implementation (remove arm64 implementation) if this series is merged.

2. BPF dispatcher. It calls execmem_alloc which has VM_FLUSH_RESET_PERMS 
set. But it is used for rw allocation, so VM_FLUSH_RESET_PERMS should be 
unnecessary IIUC. So it doesn't matter even though vm_reset_perms() fails.

3. kprobe. S390's alloc_insn_page() does call set_memory_rox(), x86 also 
called set_memory_rox() before switching to execmem cache. The execmem 
cache calls set_memory_rox(). I don't know why ARM64 doesn't call it.

So I think we just need to fix #1 and #3 per the above analysis. If this 
analysis look correct to you guys, I will prepare two patches to fix them.

Thanks,
Yang

>
>
>> Thanks,
>> Ryan
>>
>>> Thanks,
>>> Yang
>>>
>>>> Thanks,
>>>> Yang
>>>>
>>>>> Thanks,
>>>>> Ryan
>>>>>
>>>>>


