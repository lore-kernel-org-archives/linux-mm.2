Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 841B5CA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 14:57:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C54BC8E000E; Thu,  4 Sep 2025 10:57:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2C748E0002; Thu,  4 Sep 2025 10:57:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF43B8E000E; Thu,  4 Sep 2025 10:57:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9B8F88E0002
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 10:57:35 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 417EEC025B
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 14:57:35 +0000 (UTC)
X-FDA: 83851871670.07.9B50BC9
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11021086.outbound.protection.outlook.com [52.101.57.86])
	by imf27.hostedemail.com (Postfix) with ESMTP id 42FDD4000A
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 14:57:32 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=d2thMcqq;
	spf=pass (imf27.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.57.86 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756997852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aJj3B83zwDD5j6pR/pnYZHtEgd4HmAzV4pHROBu3e6w=;
	b=G7NObmbxi3+Bw+rYozCVJEJCIZPLFnUKnh1JtTXJkDYYbJTNc3AHLPMKEQKnBP0SgR48Nc
	1DWF8d9fJyRes8ejgZrZuiey4RuOX1y4qBiHPSEZUIH1seg7epKDRUOCggf5aDzwkb04n0
	P+7uhdztQvYfHbvwCvHZIDt5uKEedIo=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=d2thMcqq;
	spf=pass (imf27.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.57.86 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756997852; a=rsa-sha256;
	cv=pass;
	b=x6jER/0AJTr25LIO5GkKckxipvT7cgGg8Nqgav3qySYSgeSpwx7LD6Bs7m+gcH3qixq5bM
	qPuQf1Zo6Qh7QYsEdoQbhVMi+AtSULX3FWNfM3HZXsalo6JkKcK9qvt6v4295VWTaGMW+c
	Pn0k8M3rXj1wFURNXwS3SB63I19gjjs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=trtYuzi/LG2q/a396IGwasvp9Z6nh32luWI6m7lCyMRo5aTlXqi2qLfTDIiM7rFgMpnsWlYVzPiyCOXDMhQOA7cQ7T5wCR6SzkTb2E7bXFw6Js/QkT0O8FI4+RE4+Mjnh8/mJ6LMTVDZiGiJuCglxSw0et/J6UPmjx+HlQRcybt8bvlnk/E2bUMGy9jV4NQ+U9hj2ZNg43Be4y5c4Fybozd/GzaU0HUjm85qZfxifRVBT4TfsC0YkK02GMpr7JqlaD8hUFqHVNuGtkv5nj1v5/lQMuHA0qskJR6ZT2l6LN+/XJgcKxpxdvmu9XAoLDqGrBovrMg3fz7kclVSsB8jXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aJj3B83zwDD5j6pR/pnYZHtEgd4HmAzV4pHROBu3e6w=;
 b=VJFuYyQ+MLQw69AITYQ7OggLQKQ9T6C7cyEKspPz9R2dWyV2aRnZi09s4w9EGLkW3fINYgTsuShdoHbdtXc4AgHp/KtUnQ00CINRlDzT6kssXniYL4SoIVbvmf0lbQ1EFV1GR0elhhvc4miIVEieT4wfYU5am+7scOeMUANYvzS25RhIrAateTzdvD7wsG50xppVZlMuDTZJchK43lKuTz/aIHuECgr13YzrqQcVA3dLfGsvmhR//6Ey8QeXmVEYevwNAcJ7SU9zts+OCr0TaVE3W2altZa1p2TcFaIpU6F4A7KAmgn7XKrV6K2mTAfZzgnEHDO6ELIKQBLuW9z4/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aJj3B83zwDD5j6pR/pnYZHtEgd4HmAzV4pHROBu3e6w=;
 b=d2thMcqqTGMqIwuLd5KgVxo6In4j0Ww1tE4TAEYgk9KtZDpA7EPYUEFIBem3LJhlvS8hQiewgJDY23OvXaX1saJtUrjTgtUWhASPt4tUBoFdtvYyMbfYkSHSYP9zVXxJUmi59mFn9e3xMeOVnIfKqGAKZ9ju3z0Br1rcYfK8bJo=
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 CH3PR01MB8645.prod.exchangelabs.com (2603:10b6:610:1bc::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.18; Thu, 4 Sep 2025 14:57:27 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::3850:9112:f3bf:6460]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::3850:9112:f3bf:6460%2]) with mapi id 15.20.9094.016; Thu, 4 Sep 2025
 14:57:27 +0000
Message-ID: <05f786c2-e567-4387-b658-11e579fe375e@os.amperecomputing.com>
Date: Thu, 4 Sep 2025 07:57:22 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 3/6] arm64: mm: support large block mapping when
 rodata=full
To: Ryan Roberts <ryan.roberts@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Ard Biesheuvel <ardb@kernel.org>, Dev Jain <dev.jain@arm.com>,
 scott@os.amperecomputing.com, cl@gentwo.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20250829115250.2395585-1-ryan.roberts@arm.com>
 <20250829115250.2395585-4-ryan.roberts@arm.com>
 <f787f046-6b35-425f-91ab-80aa6e8fd35b@arm.com>
Content-Language: en-US
From: Yang Shi <yang@os.amperecomputing.com>
In-Reply-To: <f787f046-6b35-425f-91ab-80aa6e8fd35b@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CY5PR15CA0015.namprd15.prod.outlook.com
 (2603:10b6:930:14::29) To CH0PR01MB6873.prod.exchangelabs.com
 (2603:10b6:610:112::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB6873:EE_|CH3PR01MB8645:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a9f0d53-8d07-4b02-5490-08ddebc35cfe
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Sit5OTVDUS9jVG5ab3gra1h4L2pESElsY21GZjRKVmYzZUxWTlpQaFRGdEJ2?=
 =?utf-8?B?dzErOWVaM2JFaGxuWWZXZUNJbFpHeDVVNVJUNXo0dm5wdENYZ0FrOWkwaEZO?=
 =?utf-8?B?ektVTGFCSU9RZE5LNHQ4b3dYSTZsR2FnZVUwOFg5RTlhbHlUYTNmWTRhRzZz?=
 =?utf-8?B?Ly9Ta2N5RXQxZHVZbGVCRDFtV1R1eHlVNnMvUjZEZTN2Z1k0S05MM25zY2do?=
 =?utf-8?B?YnMyR1BWMDUzWDk0TFlldHZ1cVBHR2I4cUFxT1N3dTk3Mk1xZ2lSVDNyTHd2?=
 =?utf-8?B?dVVUTFR1YUdxZlNKeTVvb0xKbFhtck9rUzVrbGtGakUyQjlxWkU5SUpEUzNr?=
 =?utf-8?B?SXZwUDdZQXJjNytQbWZjWEVHbFJ1ejhiMXB0eVdPZTRGSXcwbHRlQmc0SXMw?=
 =?utf-8?B?NkhweEVZNUIzVnU3Ri9wM202akluUlJTQjAzMEdEcGFpMXRQVFdMZVNyVUxv?=
 =?utf-8?B?d2FpMk5ncHd1a0lBNVNHNEhkdWhVdjdmaGlya1creW82SVBmZkU2NEN2TXBI?=
 =?utf-8?B?S1pydlI3L3NRWlQvN2F2dklpaDUyd3d2RE9CZ1VBVVdvQnFVNFUrNFdQMXp5?=
 =?utf-8?B?TWlaVmF6RGI5cjBlWUczUmZ5UkhUY21MOXZRYS84aVRTR0dMaFM4WFR3NWRX?=
 =?utf-8?B?bXYxU0xlRGtiaWg3QXR5OXJlcEVMdUVNRFJ4dTFJUi96M04vdEVUMXdzWWUz?=
 =?utf-8?B?NHd6MTgxUzI3Vm1mQ2NxdEE2eENjZm1USnloVCtzOWFqQytrT2dVZFdQSk9h?=
 =?utf-8?B?OUhPU0lHS1Q1V3phTVBSSHhQdmpiRThUVU5oa01ZRFF3aE1RRzFhVjJJOFI5?=
 =?utf-8?B?MCtveHJFUlRvaGlERGo2aXFzbk1TeUE1ZzZyQm0zbUFHZzh6YzFGb3BPdTRG?=
 =?utf-8?B?TUpHM3cxaGRKcTQ1bE16RVViMU5Xc3VXbDl2U3N1QkM0b3R2ZXBpNmU5OFM3?=
 =?utf-8?B?RlVFRGVaZm0yQ2hRQy8rSnZNTExpcHEranFSOVNxY1J1WXZ5MXB0UUdBNFJC?=
 =?utf-8?B?TVFLa3RzVjkrK1o4bU1FL0V0WWhlZVRnWEtQZlR4UVRqVHQ2ZTFldnpLYk5i?=
 =?utf-8?B?cnRCVEFCMlA1bk5lTTh3bmtaRFVQRWdBelRnZXdZNnVaNTgySzdoVnhzQkdE?=
 =?utf-8?B?ZFFCZG8xdVNCZkU3OEgrR3BScUNaZU9VdytkU2hKUG8wN0FGYWhHTWdtNnph?=
 =?utf-8?B?VUtxaDI4T0NTVjA2WnQ3ZHNWYVJPSXovUWZiVDFkUG9TbUdHbDJneFdMcVYy?=
 =?utf-8?B?aHlLWmNvTzY1VVN0SjdaWVo4d3FaTmx0cG04cnBHRlp6QmIxalAveDl4enIr?=
 =?utf-8?B?czQ5Qk5BM2FnczZrMm5XcEN0cVFvNnZDaHFaYm5kbUoweElRL0VKMGREdjI0?=
 =?utf-8?B?cllNNy9ZVDBUNDJCNm04KzB2b25uVVVhUW5JS3l3RkZzdStMTkFnUFJsdldy?=
 =?utf-8?B?MzBTQmV6K2xQdWd4Q1FuaUFITW5qT1hQc2RKZjhIT2Y3bVFablI0REduUFB2?=
 =?utf-8?B?ZGxHWUh0WUVrYkJUUE1nNEMrRFh6Tlp6Mkk4OHdQZkQrNDhTSElFZzY1aTQ4?=
 =?utf-8?B?SVcrZEpRYjJkZzZUZldmQmR4ZlhwbTZzY3dEVEUyaWlxalorUytLSG9nY01t?=
 =?utf-8?B?RTFQWFNocVU4bmFJdlZIcHd2Tys0dGFPS2YyN21UZzJSK3lwMHlqSTV4dktv?=
 =?utf-8?B?Mk1mREI3TW5rVTlwSjcvTVNNQkVpcDNQU1piY1BJR0t2TFJteklmdEltenNz?=
 =?utf-8?B?VmphdTdoUGtHTjE5NGpodnlpdFFqUDlEZG1lSzdqc3hVaktRRmdrYnY3ajJX?=
 =?utf-8?B?Q3VmeHZyWm5tOHg2eTYrMC9LYmJoSXZJQTJYeWJzdXArT2RBNkFCaGFMKzNW?=
 =?utf-8?B?Y1dSaVh2bldheTlDM2N6RHBPWVN1YVFoMCtyTzBuMG8yUThmR3Rmazc4dGZY?=
 =?utf-8?B?d1phcnlBeEVTZmNFbUExKzJzMm8vTlZkNk5vblY0NW5rZkJIWXJldEtjbXZN?=
 =?utf-8?B?Z1hpRkpvK1NnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dmdrellUV2ovVGdQQkpUcUtlN2lEUVZEbHp3M05ndHJocExyL3B3RHZwNitu?=
 =?utf-8?B?NHhGU0l4b2xydCszVFJveWFXVUFDWkJIZ1NKcFdGV3FTTzQ5VHFZbU5LZzBD?=
 =?utf-8?B?MDh4TFA0OXlSWkRjbDgyL3FqNlpXVzFtdVlVK3lRYVBiVXlleit3Q0M1TFVk?=
 =?utf-8?B?UWdlWGU2UU96SkdQd1h6Zkg1b0NDS0tzTDQyUWtKMEZrMVBDeFRYclhpTUho?=
 =?utf-8?B?Y2gvczB3TzJtRlE2Q0JMWG5HRlNucGJ6MHhKMUVTV3J2NnIyalVQVTNMd2Ns?=
 =?utf-8?B?TlhFRlBZQUxSVEVxODJiTTlZeVFrNklGa3lpWHArVW5wcHNkMEFtempZMWQ3?=
 =?utf-8?B?ckhpaDV1UC9GZU01OG15djlxbStKc1F4NzNZNi9pL0M1Qm5obHVUNnBVWWRo?=
 =?utf-8?B?amlBTDJ5Z3FGdCtlbnhSSlArUlFTU0dhT0NZcittaDNsMW9UbFB1Q21GQzFh?=
 =?utf-8?B?a2xLV0dRRVZ5NjhCa3lKSjJDM1VaZXFTWnZKSWlQcXBKbVBXYVFndm9yVzhF?=
 =?utf-8?B?dW9QU1RQNU1jZ3pTaGVPRUVLWlh3ckhXUkg5RlhyeVB3TlZEL0ZPeng4NG91?=
 =?utf-8?B?SUJPSzRFWW9aZDdWRUFZL1FiTVoxOTk4VUd6cXp5b3ZGbGpCa2psSTIvNmRG?=
 =?utf-8?B?eENhWDRHTzZibzNheisreUJ5WjBYVzEyQ3VTNDQzOXpBVmhQZ0NYYXdjOUdI?=
 =?utf-8?B?YTcwQVh0OUdNZmtRZUduRjZ1NmlFaVJpZGZjZFI0N0ovN2hyRVVrMVpXaW9t?=
 =?utf-8?B?eFNROGR0cGhVUTQzdkt5dHUwQVlZMWF2OTErT3l2UEdKMjhWTzR3NEdXbG5S?=
 =?utf-8?B?b2pkRUsrZk05YjlnWEJvT2c1eUMwK2QwUHBCSndpS3VqeVBSbFdTcll5Z3lB?=
 =?utf-8?B?VEhRTStydGN1ck5VM3MvVFlud25sYnk5ZnlLaWQ3a3g1NHdicmo4YUo3VHNq?=
 =?utf-8?B?RzBqVm1mbWJvbDFyUnRrci8wSEMrSTlsYmZXbTA4QkRPZ1NkcnlxQklJaldy?=
 =?utf-8?B?STFFWjVkMUJUQjJuMzl4UG9ZRTZ4Wk9nNDdLYnkxOHlpVWp4ZHF5UzBXSEJv?=
 =?utf-8?B?ampWRUhqeGRpWlpEa3lXYWJ6T0lwL0lhWTNFeXFOd2J2Y3V1WU15MlRVZE8z?=
 =?utf-8?B?V255Y1o4NldCOHczaVR6b3FrOFNGaGVuaUhOanlJU3diK204U0RCQ0JUYXhY?=
 =?utf-8?B?U3NSdU4rclJ1dU1xVWlCclpOWExQeUZzd045MVpLcDZLUm12NmQ3SUY1MUpN?=
 =?utf-8?B?Z3EwYUdXd3U1dmdFRUQydVM0NjVwUHk0czJJMGhyekl5TWhVRU5na0FVWnhi?=
 =?utf-8?B?U3Zheld1a2NxN0NlT1pHMEwyWDVtb0w2VElGblZRb205YUxwK0IwbitKbktL?=
 =?utf-8?B?b0dKMVVHcXJHSzI2b0U2dmdlRzc0VURCQncyc3BwNWhpbkp6V0hjeHpSS3BF?=
 =?utf-8?B?RlA0VXoveFBuOXBQUlc3VU1ZZ3VZak0wNmhBS0tBUE9BT1B5Z29WR251MEtu?=
 =?utf-8?B?Q1Bmbzk5YjM2OFNIeVlPbFVqNGhGdlJyeGx3OUQ4d0EwYTVTOXU2cnM5ZEdM?=
 =?utf-8?B?TGRqU081TXZ1THdQSS91bldCTGlwRHlQYXZDOFdqb01kQml5U0IvOGdrNlE4?=
 =?utf-8?B?U055ME1uQVozSHhpSUV0dGFESWNMbjRCWHhxZW1OWTYxUElrZHBYbWF0LzBn?=
 =?utf-8?B?L1QxdmFyWG9MamR6aHNGTUU2cWI3b29TbGFSdmZvQk5sZG1nenZPYWtvbUFH?=
 =?utf-8?B?dE1PU2pyNis2dGwyOUxWcFJ5Ylg5UStuYXl3MEJTSUs3MlA3TU84VWxtZjF5?=
 =?utf-8?B?NHA1QVJkWmMvUW1tNWRKcEcrd2xNRGJBZThWbVNpNEZzUlZ5ZHYvYVdsWTlX?=
 =?utf-8?B?N3U3WjF4dDhVejZ6aTVoZmZBMEVaS3FYeVR1aVVXMmxyU1hxMHlkNml2VDh3?=
 =?utf-8?B?MTFWcTlBQy9veVNvbjNhVjdVTFIrc0l2UzE5Y2N6bnNxUDNMYXhxcStXRWlN?=
 =?utf-8?B?d2NuTlNCditLbmc5bXBYK09YU3haM1JpaFFMQmtEeXVZMnVDd1BPZ2k0Q0to?=
 =?utf-8?B?T0NiSXVka0JqRk0yOTJPaXk3VjFvVVdNVGpMeEdiaDRnR3NNUHA3cWoyUXdv?=
 =?utf-8?B?eVE0aU5qNTdjQ1N1b0tzK28zY2pzVDIrcDkrcm5ydXlYQ2xBVG0xcTFLUWpx?=
 =?utf-8?Q?023LpTlVLPqeVe0XRtBRb7A=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a9f0d53-8d07-4b02-5490-08ddebc35cfe
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 14:57:27.3400
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WWWmAs05oxajJ+N4iyX0nJuTgC7wwidzOO6anPfK2Nl8NDGOTuRreIwWdBHto9ElfVSkI3NMAPknGroKangehzFOD3V0sI159jx9e4UZz7Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR01MB8645
X-Stat-Signature: 3rwbua6oa86bafsduzsf3ho516u7se7p
X-Rspam-User: 
X-Rspamd-Queue-Id: 42FDD4000A
X-Rspamd-Server: rspam05
X-HE-Tag: 1756997852-178637
X-HE-Meta: U2FsdGVkX185NuNmw32YVh8sQKcM0tfD/j8DNNFhHVz2J2QS4P5w+vPD8cjevVZGIxLms8VvSK/va7wypeYEa+gjhSDoVInREX2eTYAzhIObQJIiykyF0+MKJiP0qBJzo4tXjnMdhDz8Ja/tyChYw00QxNPy1uqN1mFl3b3IO197G/Jg+TOO3/xb8zX9UHmpp/rMip935fN+h58OGFn6VKSgzGMa/SyLqRyxa3UhAw3TosxQhmzxotq2oe/3x4SQT5EKgUtBldZ8tfPR1W/2chcRl6pHzqePpThJL5IweIX5FmOg5vsF7yN2vFl08UO6N/o8OuAtEh1j79zvdA9SXr7niJ2Dfyk9dGQjzs1h+f4BEBwpiIQXfwkUuxeeW8yKcJlB3A9JuAaXijRShLI5267g/uwdpllvzhubln0TVNHEF+2hZb6a/HbClBJphZl9soJuBwmPoc9xyJG/j3xCcainlbFDAVTsWfrp+NFsXBDPOYwCCViq7TjtKvPGMNyMG20mo1e2KP26kah5n2iMQQlo4ngAn9jeW8+hW0ZKqLYTEJkCIZ2zprW8M8AhJYnWDwZAXOLBUz2xWMLmxonxXeW77uG7mgEuMw5I3aOY9KUFSACDmAXIIBxDOGaCm2Rz3kjmjSx7oNH1swByD6O8Kh94iZzcm0DDSX2GEr0k3peqoPYJxUz2cAJGbas8XM/dPBPNUKGSt8fLFRDyE7cvPqpt7DW7FgnkJM4X3f7sf+BGJw+MXqLjwN72m6IdV/LQIWqt4+A49bhbW4hWcP+YlEuU9XRRwHm4XVTAJqNLxmxTGMLCnubkXtJtVrUog43O5nWtVCAfZsDVjcaw4XHlcBnKUrTeqMt84yCzYTvGsoruXalqZjNsnqTCHJHFc6/8OPAx+nOK0qY2NMeuBMZ/XeqjpFX+2riKcMWD6MYdPNTjNf5mtlkFoHsT+Z4wCd2EArqFOKZTvKvwcp3MU91
 /Tyur6lU
 r1nJ4h5D19/t5V284qtCX43ZzqXGzKyCzgoPxtA0sW2bykYpJNI9Qgn+BXBgIzKNnKkOfN3KVZk1EYNOu7q+0zfslLWfR0IUBaCCwL9BvsDOJK+WxOU7c60UABD0lNzXoqwCXHC2U6b+iDuyAGJpBiziIHd1zRuZJNLo92V60bn/iHXBdFDrjeBmVx66fGb++oHSS0epk8QZkmO0iBS2BzgmaFGXcIfW9sTGznysE/pp7GMr4Q4W6XPaWxxnFli/OjZhehIFViYn92lQ8iSqyynorxAcjvNjOSMuSvyLPoPSqX7jqfBHv8VKwj2u7QZLFW5zxjB635Pm4zJUgnFHLUFrt1b9PyXsEDE0j/y0AVaU7m5qiZhChONwsxbIM4fJZR1JC0C5FpL7WJQMzI1sT0zB+Bv+upF4AkFtzqa6Vsz0iWJleyGiu0k2rsYqykE6XgvxpdPbYWMqPHI617eivqI6NE+pkyclNtvBbz7SWaUydG88ao1UyMjTy7eFNgRfdRbu4vWz0R4JdbRl8tSFuonzlVbqAERm7EwdxOstkCyhaYWOj2Cc92yWDqgLa0VRlyNtFjHT6bNDaZHQdOc+gBx2db/4ZpSR4jG2LKxfA1jSksmzUZTYFq/mlSUyMqNmGRDecYqUtTsTZsLVXHO4Q0qXEEKo14jkTeKVCtiQ6CRNmj2KEyqlhRxGfTq4gOxWkhxRI2/JTEuzWra0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/4/25 4:15 AM, Ryan Roberts wrote:
> On 29/08/2025 12:52, Ryan Roberts wrote:
>> From: Yang Shi <yang@os.amperecomputing.com>
>>
>> When rodata=full is specified, kernel linear mapping has to be mapped at
>> PTE level since large page table can't be split due to break-before-make
>> rule on ARM64.
>>
>> This resulted in a couple of problems:
>>    - performance degradation
>>    - more TLB pressure
>>    - memory waste for kernel page table
>>
>> With FEAT_BBM level 2 support, splitting large block page table to
>> smaller ones doesn't need to make the page table entry invalid anymore.
>> This allows kernel split large block mapping on the fly.
>>
>> Add kernel page table split support and use large block mapping by
>> default when FEAT_BBM level 2 is supported for rodata=full.  When
>> changing permissions for kernel linear mapping, the page table will be
>> split to smaller size.
>>
>> The machine without FEAT_BBM level 2 will fallback to have kernel linear
>> mapping PTE-mapped when rodata=full.
>>
>> With this we saw significant performance boost with some benchmarks and
>> much less memory consumption on my AmpereOne machine (192 cores, 1P)
>> with 256GB memory.
>>
>> * Memory use after boot
>> Before:
>> MemTotal:       258988984 kB
>> MemFree:        254821700 kB
>>
>> After:
>> MemTotal:       259505132 kB
>> MemFree:        255410264 kB
>>
>> Around 500MB more memory are free to use.  The larger the machine, the
>> more memory saved.
>>
>> * Memcached
>> We saw performance degradation when running Memcached benchmark with
>> rodata=full vs rodata=on.  Our profiling pointed to kernel TLB pressure.
>> With this patchset we saw ops/sec is increased by around 3.5%, P99
>> latency is reduced by around 9.6%.
>> The gain mainly came from reduced kernel TLB misses.  The kernel TLB
>> MPKI is reduced by 28.5%.
>>
>> The benchmark data is now on par with rodata=on too.
>>
>> * Disk encryption (dm-crypt) benchmark
>> Ran fio benchmark with the below command on a 128G ramdisk (ext4) with
>> disk encryption (by dm-crypt).
>> fio --directory=/data --random_generator=lfsr --norandommap            \
>>      --randrepeat 1 --status-interval=999 --rw=write --bs=4k --loops=1  \
>>      --ioengine=sync --iodepth=1 --numjobs=1 --fsync_on_close=1         \
>>      --group_reporting --thread --name=iops-test-job --eta-newline=1    \
>>      --size 100G
>>
>> The IOPS is increased by 90% - 150% (the variance is high, but the worst
>> number of good case is around 90% more than the best number of bad
>> case). The bandwidth is increased and the avg clat is reduced
>> proportionally.
>>
>> * Sequential file read
>> Read 100G file sequentially on XFS (xfs_io read with page cache
>> populated). The bandwidth is increased by 150%.
>>
>> Co-developed-by: Ryan Roberts <ryan.roberts@arm.com>
>> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
>> Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
>> ---
>>   arch/arm64/include/asm/cpufeature.h |   2 +
>>   arch/arm64/include/asm/mmu.h        |   1 +
>>   arch/arm64/include/asm/pgtable.h    |   5 +
>>   arch/arm64/kernel/cpufeature.c      |   7 +-
>>   arch/arm64/mm/mmu.c                 | 248 +++++++++++++++++++++++++++-
>>   arch/arm64/mm/pageattr.c            |   4 +
>>   6 files changed, 261 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
>> index bf13d676aae2..e223cbf350e4 100644
>> --- a/arch/arm64/include/asm/cpufeature.h
>> +++ b/arch/arm64/include/asm/cpufeature.h
>> @@ -871,6 +871,8 @@ static inline bool system_supports_pmuv3(void)
>>   	return cpus_have_final_cap(ARM64_HAS_PMUV3);
>>   }
>>   
>> +bool cpu_supports_bbml2_noabort(void);
>> +
>>   static inline bool system_supports_bbml2_noabort(void)
>>   {
>>   	return alternative_has_cap_unlikely(ARM64_HAS_BBML2_NOABORT);
>> diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
>> index 6e8aa8e72601..56fca81f60ad 100644
>> --- a/arch/arm64/include/asm/mmu.h
>> +++ b/arch/arm64/include/asm/mmu.h
>> @@ -71,6 +71,7 @@ extern void create_pgd_mapping(struct mm_struct *mm, phys_addr_t phys,
>>   			       pgprot_t prot, bool page_mappings_only);
>>   extern void *fixmap_remap_fdt(phys_addr_t dt_phys, int *size, pgprot_t prot);
>>   extern void mark_linear_text_alias_ro(void);
>> +extern int split_kernel_leaf_mapping(unsigned long start, unsigned long end);
>>   
>>   /*
>>    * This check is triggered during the early boot before the cpufeature
>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>> index abd2dee416b3..aa89c2e67ebc 100644
>> --- a/arch/arm64/include/asm/pgtable.h
>> +++ b/arch/arm64/include/asm/pgtable.h
>> @@ -371,6 +371,11 @@ static inline pmd_t pmd_mkcont(pmd_t pmd)
>>   	return __pmd(pmd_val(pmd) | PMD_SECT_CONT);
>>   }
>>   
>> +static inline pmd_t pmd_mknoncont(pmd_t pmd)
>> +{
>> +	return __pmd(pmd_val(pmd) & ~PMD_SECT_CONT);
>> +}
>> +
>>   #ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
>>   static inline int pte_uffd_wp(pte_t pte)
>>   {
>> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
>> index b93f4ee57176..a8936c1023ea 100644
>> --- a/arch/arm64/kernel/cpufeature.c
>> +++ b/arch/arm64/kernel/cpufeature.c
>> @@ -2217,7 +2217,7 @@ static bool hvhe_possible(const struct arm64_cpu_capabilities *entry,
>>   	return arm64_test_sw_feature_override(ARM64_SW_FEATURE_OVERRIDE_HVHE);
>>   }
>>   
>> -static bool has_bbml2_noabort(const struct arm64_cpu_capabilities *caps, int scope)
>> +bool cpu_supports_bbml2_noabort(void)
>>   {
>>   	/*
>>   	 * We want to allow usage of BBML2 in as wide a range of kernel contexts
>> @@ -2251,6 +2251,11 @@ static bool has_bbml2_noabort(const struct arm64_cpu_capabilities *caps, int sco
>>   	return true;
>>   }
>>   
>> +static bool has_bbml2_noabort(const struct arm64_cpu_capabilities *caps, int scope)
>> +{
>> +	return cpu_supports_bbml2_noabort();
>> +}
>> +
>>   #ifdef CONFIG_ARM64_PAN
>>   static void cpu_enable_pan(const struct arm64_cpu_capabilities *__unused)
>>   {
>> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
>> index 34e5d78af076..114b88216b0c 100644
>> --- a/arch/arm64/mm/mmu.c
>> +++ b/arch/arm64/mm/mmu.c
>> @@ -481,6 +481,8 @@ void create_kpti_ng_temp_pgd(pgd_t *pgdir, phys_addr_t phys, unsigned long virt,
>>   			     int flags);
>>   #endif
>>   
>> +#define INVALID_PHYS_ADDR	-1
>> +
>>   static phys_addr_t __pgd_pgtable_alloc(struct mm_struct *mm,
>>   				       enum pgtable_type pgtable_type)
>>   {
>> @@ -488,7 +490,9 @@ static phys_addr_t __pgd_pgtable_alloc(struct mm_struct *mm,
>>   	struct ptdesc *ptdesc = pagetable_alloc(GFP_PGTABLE_KERNEL & ~__GFP_ZERO, 0);
>>   	phys_addr_t pa;
>>   
>> -	BUG_ON(!ptdesc);
>> +	if (!ptdesc)
>> +		return INVALID_PHYS_ADDR;
>> +
>>   	pa = page_to_phys(ptdesc_page(ptdesc));
>>   
>>   	switch (pgtable_type) {
>> @@ -509,16 +513,240 @@ static phys_addr_t __pgd_pgtable_alloc(struct mm_struct *mm,
>>   	return pa;
>>   }
>>   
>> +static phys_addr_t
>> +try_pgd_pgtable_alloc_init_mm(enum pgtable_type pgtable_type)
>> +{
>> +	return __pgd_pgtable_alloc(&init_mm, pgtable_type);
>> +}
>> +
>>   static phys_addr_t __maybe_unused
>>   pgd_pgtable_alloc_init_mm(enum pgtable_type pgtable_type)
>>   {
>> -	return __pgd_pgtable_alloc(&init_mm, pgtable_type);
>> +	phys_addr_t pa;
>> +
>> +	pa = __pgd_pgtable_alloc(&init_mm, pgtable_type);
>> +	BUG_ON(pa == INVALID_PHYS_ADDR);
>> +	return pa;
>>   }
>>   
>>   static phys_addr_t
>>   pgd_pgtable_alloc_special_mm(enum pgtable_type pgtable_type)
>>   {
>> -	return __pgd_pgtable_alloc(NULL, pgtable_type);
>> +	phys_addr_t pa;
>> +
>> +	pa = __pgd_pgtable_alloc(NULL, pgtable_type);
>> +	BUG_ON(pa == INVALID_PHYS_ADDR);
>> +	return pa;
>> +}
>> +
>> +static void split_contpte(pte_t *ptep)
>> +{
>> +	int i;
>> +
>> +	ptep = PTR_ALIGN_DOWN(ptep, sizeof(*ptep) * CONT_PTES);
>> +	for (i = 0; i < CONT_PTES; i++, ptep++)
>> +		__set_pte(ptep, pte_mknoncont(__ptep_get(ptep)));
>> +}
>> +
>> +static int split_pmd(pmd_t *pmdp, pmd_t pmd)
>> +{
>> +	pmdval_t tableprot = PMD_TYPE_TABLE | PMD_TABLE_UXN | PMD_TABLE_AF;
>> +	unsigned long pfn = pmd_pfn(pmd);
>> +	pgprot_t prot = pmd_pgprot(pmd);
>> +	phys_addr_t pte_phys;
>> +	pte_t *ptep;
>> +	int i;
>> +
>> +	pte_phys = try_pgd_pgtable_alloc_init_mm(TABLE_PTE);
>> +	if (pte_phys == INVALID_PHYS_ADDR)
>> +		return -ENOMEM;
>> +	ptep = (pte_t *)phys_to_virt(pte_phys);
>> +
>> +	if (pgprot_val(prot) & PMD_SECT_PXN)
>> +		tableprot |= PMD_TABLE_PXN;
>> +
>> +	prot = __pgprot((pgprot_val(prot) & ~PTE_TYPE_MASK) | PTE_TYPE_PAGE);
>> +	prot = __pgprot(pgprot_val(prot) | PTE_CONT);
>> +
>> +	for (i = 0; i < PTRS_PER_PTE; i++, ptep++, pfn++)
>> +		__set_pte(ptep, pfn_pte(pfn, prot));
>> +
>> +	/*
>> +	 * Ensure the pte entries are visible to the table walker by the time
>> +	 * the pmd entry that points to the ptes is visible.
>> +	 */
>> +	dsb(ishst);
>> +	__pmd_populate(pmdp, pte_phys, tableprot);
>> +
>> +	return 0;
>> +}
>> +
>> +static void split_contpmd(pmd_t *pmdp)
>> +{
>> +	int i;
>> +
>> +	pmdp = PTR_ALIGN_DOWN(pmdp, sizeof(*pmdp) * CONT_PMDS);
>> +	for (i = 0; i < CONT_PMDS; i++, pmdp++)
>> +		set_pmd(pmdp, pmd_mknoncont(pmdp_get(pmdp)));
>> +}
>> +
>> +static int split_pud(pud_t *pudp, pud_t pud)
>> +{
>> +	pudval_t tableprot = PUD_TYPE_TABLE | PUD_TABLE_UXN | PUD_TABLE_AF;
>> +	unsigned int step = PMD_SIZE >> PAGE_SHIFT;
>> +	unsigned long pfn = pud_pfn(pud);
>> +	pgprot_t prot = pud_pgprot(pud);
>> +	phys_addr_t pmd_phys;
>> +	pmd_t *pmdp;
>> +	int i;
>> +
>> +	pmd_phys = try_pgd_pgtable_alloc_init_mm(TABLE_PMD);
>> +	if (pmd_phys == INVALID_PHYS_ADDR)
>> +		return -ENOMEM;
>> +	pmdp = (pmd_t *)phys_to_virt(pmd_phys);
>> +
>> +	if (pgprot_val(prot) & PMD_SECT_PXN)
>> +		tableprot |= PUD_TABLE_PXN;
>> +
>> +	prot = __pgprot((pgprot_val(prot) & ~PMD_TYPE_MASK) | PMD_TYPE_SECT);
>> +	prot = __pgprot(pgprot_val(prot) | PTE_CONT);
>> +
>> +	for (i = 0; i < PTRS_PER_PMD; i++, pmdp++, pfn += step)
>> +		set_pmd(pmdp, pfn_pmd(pfn, prot));
>> +
>> +	/*
>> +	 * Ensure the pmd entries are visible to the table walker by the time
>> +	 * the pud entry that points to the pmds is visible.
>> +	 */
>> +	dsb(ishst);
>> +	__pud_populate(pudp, pmd_phys, tableprot);
>> +
>> +	return 0;
>> +}
>> +
>> +static int split_kernel_leaf_mapping_locked(unsigned long addr)
>> +{
>> +	pgd_t *pgdp, pgd;
>> +	p4d_t *p4dp, p4d;
>> +	pud_t *pudp, pud;
>> +	pmd_t *pmdp, pmd;
>> +	pte_t *ptep, pte;
>> +	int ret = 0;
>> +
>> +	/*
>> +	 * PGD: If addr is PGD aligned then addr already describes a leaf
>> +	 * boundary. If not present then there is nothing to split.
>> +	 */
>> +	if (ALIGN_DOWN(addr, PGDIR_SIZE) == addr)
>> +		goto out;
>> +	pgdp = pgd_offset_k(addr);
>> +	pgd = pgdp_get(pgdp);
>> +	if (!pgd_present(pgd))
>> +		goto out;
>> +
>> +	/*
>> +	 * P4D: If addr is P4D aligned then addr already describes a leaf
>> +	 * boundary. If not present then there is nothing to split.
>> +	 */
>> +	if (ALIGN_DOWN(addr, P4D_SIZE) == addr)
>> +		goto out;
>> +	p4dp = p4d_offset(pgdp, addr);
>> +	p4d = p4dp_get(p4dp);
>> +	if (!p4d_present(p4d))
>> +		goto out;
>> +
>> +	/*
>> +	 * PUD: If addr is PUD aligned then addr already describes a leaf
>> +	 * boundary. If not present then there is nothing to split. Otherwise,
>> +	 * if we have a pud leaf, split to contpmd.
>> +	 */
>> +	if (ALIGN_DOWN(addr, PUD_SIZE) == addr)
>> +		goto out;
>> +	pudp = pud_offset(p4dp, addr);
>> +	pud = pudp_get(pudp);
>> +	if (!pud_present(pud))
>> +		goto out;
>> +	if (pud_leaf(pud)) {
>> +		ret = split_pud(pudp, pud);
>> +		if (ret)
>> +			goto out;
>> +	}
>> +
>> +	/*
>> +	 * CONTPMD: If addr is CONTPMD aligned then addr already describes a
>> +	 * leaf boundary. If not present then there is nothing to split.
>> +	 * Otherwise, if we have a contpmd leaf, split to pmd.
>> +	 */
>> +	if (ALIGN_DOWN(addr, CONT_PMD_SIZE) == addr)
>> +		goto out;
>> +	pmdp = pmd_offset(pudp, addr);
>> +	pmd = pmdp_get(pmdp);
>> +	if (!pmd_present(pmd))
>> +		goto out;
>> +	if (pmd_leaf(pmd)) {
>> +		if (pmd_cont(pmd))
>> +			split_contpmd(pmdp);
>> +		/*
>> +		 * PMD: If addr is PMD aligned then addr already describes a
>> +		 * leaf boundary. Otherwise, split to contpte.
>> +		 */
>> +		if (ALIGN_DOWN(addr, PMD_SIZE) == addr)
>> +			goto out;
>> +		ret = split_pmd(pmdp, pmd);
>> +		if (ret)
>> +			goto out;
>> +	}
>> +
>> +	/*
>> +	 * CONTPTE: If addr is CONTPTE aligned then addr already describes a
>> +	 * leaf boundary. If not present then there is nothing to split.
>> +	 * Otherwise, if we have a contpte leaf, split to pte.
>> +	 */
>> +	if (ALIGN_DOWN(addr, CONT_PTE_SIZE) == addr)
>> +		goto out;
>> +	ptep = pte_offset_kernel(pmdp, addr);
>> +	pte = __ptep_get(ptep);
>> +	if (!pte_present(pte))
>> +		goto out;
>> +	if (pte_cont(pte))
>> +		split_contpte(ptep);
>> +
>> +out:
>> +	return ret;
>> +}
>> +
>> +static DEFINE_MUTEX(pgtable_split_lock);
>> +
>> +int split_kernel_leaf_mapping(unsigned long start, unsigned long end)
>> +{
>> +	int ret;
>> +
>> +	/*
>> +	 * !BBML2_NOABORT systems should not be trying to change permissions on
>> +	 * anything that is not pte-mapped in the first place. Just return early
>> +	 * and let the permission change code raise a warning if not already
>> +	 * pte-mapped.
>> +	 */
>> +	if (!system_supports_bbml2_noabort())
>> +		return 0;
>> +
>> +	/*
>> +	 * Ensure start and end are at least page-aligned since this is the
>> +	 * finest granularity we can split to.
>> +	 */
>> +	if (start != PAGE_ALIGN(start) || end != PAGE_ALIGN(end))
>> +		return -EINVAL;
>> +
>> +	mutex_lock(&pgtable_split_lock);
>> +	arch_enter_lazy_mmu_mode();
> There is a spec issue here: We are inside a lazy mmu section, for which the
> documentation says is an atomic context so we can't sleep. But
> split_kernel_leaf_mapping_locked() will allocate pgtable memory if needed in a
> manner that might sleep.
>
> This isn't a problem in practice for arm64 since it's lazy mmu implementation
> allows sleeping. I propose just adding a comment here to explain this and leave
> the logic as is. Are people happy with this approach?

Yes, sounds good to me.

Thanks,
Yang

>
>> +
>> +	ret = split_kernel_leaf_mapping_locked(start);
>> +	if (!ret)
>> +		ret = split_kernel_leaf_mapping_locked(end);
>> +
>> +	arch_leave_lazy_mmu_mode();
>> +	mutex_unlock(&pgtable_split_lock);
>> +	return ret;
>>   }
>>   
>>   /*
>> @@ -640,6 +868,16 @@ static inline void arm64_kfence_map_pool(phys_addr_t kfence_pool, pgd_t *pgdp) {
>>   
>>   #endif /* CONFIG_KFENCE */
>>   
>> +static inline bool force_pte_mapping(void)
>> +{
>> +	bool bbml2 = system_capabilities_finalized() ?
>> +		system_supports_bbml2_noabort() : cpu_supports_bbml2_noabort();
>> +
>> +	return (!bbml2 && (rodata_full || arm64_kfence_can_set_direct_map() ||
>> +			   is_realm_world())) ||
>> +		debug_pagealloc_enabled();
>> +}
>> +
>>   static void __init map_mem(pgd_t *pgdp)
>>   {
>>   	static const u64 direct_map_end = _PAGE_END(VA_BITS_MIN);
>> @@ -665,7 +903,7 @@ static void __init map_mem(pgd_t *pgdp)
>>   
>>   	early_kfence_pool = arm64_kfence_alloc_pool();
>>   
>> -	if (can_set_direct_map())
>> +	if (force_pte_mapping())
>>   		flags |= NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
>>   
>>   	/*
>> @@ -1367,7 +1605,7 @@ int arch_add_memory(int nid, u64 start, u64 size,
>>   
>>   	VM_BUG_ON(!mhp_range_allowed(start, size, true));
>>   
>> -	if (can_set_direct_map())
>> +	if (force_pte_mapping())
>>   		flags |= NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
>>   
>>   	__create_pgd_mapping(swapper_pg_dir, start, __phys_to_virt(start),
>> diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
>> index 6da8cbc32f46..0aba80a38cef 100644
>> --- a/arch/arm64/mm/pageattr.c
>> +++ b/arch/arm64/mm/pageattr.c
>> @@ -140,6 +140,10 @@ static int update_range_prot(unsigned long start, unsigned long size,
>>   	data.set_mask = set_mask;
>>   	data.clear_mask = clear_mask;
>>   
>> +	ret = split_kernel_leaf_mapping(start, start + size);
>> +	if (WARN_ON_ONCE(ret))
>> +		return ret;
>> +
>>   	arch_enter_lazy_mmu_mode();
>>   
>>   	/*


