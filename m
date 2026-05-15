Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B42ACD4F3C
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 20:34:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BE156B0005; Fri, 15 May 2026 16:34:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 947486B008A; Fri, 15 May 2026 16:34:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C0D96B008C; Fri, 15 May 2026 16:34:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 641B46B0005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 16:34:01 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E4D7F1C00AC
	for <linux-mm@kvack.org>; Fri, 15 May 2026 20:34:00 +0000 (UTC)
X-FDA: 84770805840.14.4172108
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013017.outbound.protection.outlook.com [40.93.196.17])
	by imf02.hostedemail.com (Postfix) with ESMTP id E4CAF80005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 20:33:57 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=jVPDlNLM;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf02.hostedemail.com: domain of jhubbard@nvidia.com designates 40.93.196.17 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778877238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+ZQVGMV8gfaDhTWsYQdRe0HpNMvzoKH5PG0NJ5JdTDg=;
	b=uqtuCZJ5h9c//dipFP/Mcp236e8kUJlCehNMZQP9cezbEXpaA9vi1X9opdVo8pcKsBR4pT
	JodXfYXO4nqSO0RUJIbOBpAl3cne3vv4QVb5kyNbFrI0H7d7XHCEGrXkAlmezAWlqw+rKR
	Ow/oBY32nFkZ0vyUSN/MUJNX+S+0o8Q=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778877238; a=rsa-sha256;
	cv=fail;
	b=U0Qqepj6HL4C6amKs98jK9HEJUf/jFE77UVe9a+8c0Jh6v+Lf2u/XlmgbPTSIsRZ+ofm1T
	nmA7TrmZjzpnD6iFb3FqV9UCIIMsr5hbOemuLTm38hX5RoKf5KUqMS8pZfXdghCYM0MUxE
	LHFoZnVcSKCxgxCG6qBhl6Bnt4/hShU=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=jVPDlNLM;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf02.hostedemail.com: domain of jhubbard@nvidia.com designates 40.93.196.17 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dL6UotegT6Q2LUXuy828IQjLsWwFIyTTjU39lH+0DZGg0lBcPsnlSAjz+DBevGAwKelBs3eDJE/jG3qtIk5TH1I+XZSvGXNFRJCx4PM7+TQyjwf8EUQ7jLofbyyUq2bGJUPE6BD5AxcSVwuquzz7eR6T3w1y3HJwNOXkbdlhJuXtdyl+8JOoosI/mRjzAar3U7UAwFFQcBmL2C4xek1mq2yWz1drwx87iOf+klkifHr6um5SdZq5gNNGk/y4G27XBHHG7MsGyBQI69E6mLSkWZVM73wipvUDu8ppfd4LE/H4f5F4LUjzuvreVrD4tEotNztE15CcogWhulOTXlTNRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+ZQVGMV8gfaDhTWsYQdRe0HpNMvzoKH5PG0NJ5JdTDg=;
 b=NjU1FXtlxrrWLMNU91roSVhOS/bVQFRilTjQdZTaSYirZxJALVeRatGzbtoB7qRwKErzJ8eL6iuiTAZYjmqAAiMXlls1DTJ3xoejHL4OB6p633WloKvL03NkIi+wwFYWRsaFukrxqNVR4axLHM5XYfepPjROBRhsOqqGT5PDmyklVEjRth9nYkN7NVeHKU1ae1QGdbHg6E86K9rpAcDdSs27euWSyfzWAJGYjBy5i+oLSBLuTLwZ8NTozxwTbcdz4cCI8DgJGTHYE+3MOenD9sTTqszwjlIYUsHULjzVXbvOm+RLizJNIb2pzW4viI7dwxr8x+VOCd+B8B0M3abwOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ZQVGMV8gfaDhTWsYQdRe0HpNMvzoKH5PG0NJ5JdTDg=;
 b=jVPDlNLMwoiCqNRvRJ6R6aFfWkWlDnvIumXDSgPu1j+ghiXYDK+4vuyUMWfne1F8dwrDzO2OFF/wcURpCv/K2gwo01Yf9/CoMtIVOANF0IBbsd5oVAyuQVsW7f4PmtaqsHs6SO11VRCP1+9ia3tFukDQzLfN/HrqunKv/Cf6OwOu+WHfyTQ/+T9qWh5PbFaAOKESqPgHdU8fdPGHeBP61LtUc9ucaeVF85EUxN7rqsLT4TCDKuw5N1GQQnsZyjIzU/p4t5SirbaTj3rWtnspCOIfSxoq8Yp1GzBHsBduUwfVCh6hSju1wbiAzlmop8dITwJJrz/eMv9QzDeCB3cFcQ==
Received: from DM3PR12MB9416.namprd12.prod.outlook.com (2603:10b6:0:4b::8) by
 MW4PR12MB6754.namprd12.prod.outlook.com (2603:10b6:303:1eb::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.25.19; Fri, 15 May 2026 20:33:51 +0000
Received: from DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8]) by DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8%5]) with mapi id 15.20.9913.012; Fri, 15 May 2026
 20:33:51 +0000
Message-ID: <c99048de-1e2a-4c92-8589-0abba45bcc29@nvidia.com>
Date: Fri, 15 May 2026 13:33:49 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] selftests/mm: rewrite gup_test as a standalone
 harness-based selftest
To: Sarthak Sharma <sarthak.sharma@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Peter Xu <peterx@redhat.com>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260515084840.174652-1-sarthak.sharma@arm.com>
 <20260515084840.174652-3-sarthak.sharma@arm.com>
Content-Language: en-US
From: John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <20260515084840.174652-3-sarthak.sharma@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0026.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::31) To DM3PR12MB9416.namprd12.prod.outlook.com
 (2603:10b6:0:4b::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR12MB9416:EE_|MW4PR12MB6754:EE_
X-MS-Office365-Filtering-Correlation-Id: caa3aac9-64f4-4483-bae1-08deb2c14617
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|11063799003|4143699003|3023799003|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	iSlSi9KOr/QGZfSqN+Vfmv3WFPfqG+BqNO4knEEAB0ZBfDTadLWjeHMO3IpORD7wXyG+6NvabsQC48ONY1kr+ErQrIBu2oXuCdQMIGnU5sJHJiHjuJNwYuwCOnzBe4F3HXCCPjECtOhdFF4keXHi4H9y3vqshvLANZg4f5LgtQYyblpjfWZyj+A3+rN7eN7WwKdkF62bI62a0hBkngv9GsLGFEgxIhQ0/j166Y0szv4Zi7+zHp6ZOlaWG+6VDOWPBj+OxQzh9CGoWuCMSM/5ECkJd2TtZrUeSkDwduBJ3BaCbohsw1e7egK3XJGw5uGNISWoJOc5bu7M3C5iy60jwgZYSppNdkJjaReC+T86GjVQOSzh0v07TVeJyDdwaDOhWiAEkZwUbP4bxLc/CCzXu81nC/4kR46+GMrDTVDS/28pbR7KQ2fpOLYvU+x3M9eUc65zCOWyfdyGlMU6iNcpk9zrN8T+Tcmnn9J6HmWlFpZxw/suZqJXeXMbXjaYaGPmm8fnejiuJmYg+KA5ZGUn76SRJ+M3cpayiE+e472a8YI4xpD3oDDFSG0Jfw3EeyNWQrqIG+i4OiH85oYF9IYGb7N0Mt1B6myXd2azMiHgyGRZpNstAcdUfLSUiCt4XnDNusOsjHrjcW9Km7L1094oZWOlVucwsMg9o1vsU8ar3tO1sbi8/pgykysnpuluKL+X
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR12MB9416.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(11063799003)(4143699003)(3023799003)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bm9idi94Rys3N0pBMS9qUmZ6bFBzNEFrTk9JcUJNTmtnZ2Z4TzY3Uk43K3lZ?=
 =?utf-8?B?MC9aRHNmTkNXbmM4WVJWRGdFN0R5aklSRTU4NVIrMVc0VE9WczhnRUZaOXlM?=
 =?utf-8?B?dkRzZVphSTNWVG15b1IzTTFoeXZrNTliWHJqTW1wcFBOdzhvVlFpK0c5d0R5?=
 =?utf-8?B?U3M0SzRwM1lBL1U4aFY2em9FV3RjM1dIYjVLSHlhZ2hNenBZRis1NGFUUWZL?=
 =?utf-8?B?S0NGejNqMDE1cGtTa2FXWGRsL2RBN3hwdTdCemZUN3VneHVNTHg4OEZ2Tk9K?=
 =?utf-8?B?TFVuYlV3UzlaQmlsTVJTUGVKYzVFMm9VZVFWQUI5RWd4T2xRZ1VvYldjdnlx?=
 =?utf-8?B?VUZDbjFnRVZZYStGdFVEbjVKamZhdld3aEVtM005NjlNRDZtZCtwNWxWODFO?=
 =?utf-8?B?VkF1VE5MbDNQTkRPa3hpdzdDZnE5SHlDaHhabHdadUw4VWYzWXM4T0JQZzBk?=
 =?utf-8?B?Q1RoRkd2ZitnRTFBU3YycmlyQmZWcFhsWlZsTTg5TUYrWXVRc3VWdkJTdU9B?=
 =?utf-8?B?OWRsNmI1ams2b2s0d0xIWEhGZ3phZW5HbG1MS3d6OEJLeFVBc3NCQTFXQTJp?=
 =?utf-8?B?Uk5LZG9UMWQremc3RjZuamF6bDVFT0RMVk9DQ2pjcGRrUTFBV3pQRm9kQjhU?=
 =?utf-8?B?YldXQmoycDNTTHp2Y1A3Q2IxWnZVR0hhWVhLZktJWVk2NDNNdXlqQmF3aGVm?=
 =?utf-8?B?NUhIZjc4Y0paM0dyMGEzbVppSkxoTFdML3ljUHhUdUhvTDU5eWs2cjFRNFFo?=
 =?utf-8?B?VFJCYXY2YUs4WEVENG9YQW9oWnZwYnpiMDhqZHIwbk9Oa3ArTWhBT0hNVHZW?=
 =?utf-8?B?U0xtTmJ2OFpJSFZrZm5VQUY1Slp2MVdTaVBBZHFFWDg5blc1OW5Bc0RpOEQ1?=
 =?utf-8?B?ZUF3dEV1ODJNVlF2WFlkWXI2Rkp1NjNUMUs4RmlzUTRMM0NteWI0QVR1djVw?=
 =?utf-8?B?bmFmYkgzbDRhM25PQ2J0c2VHMkxVV2thNE5CZ0JOdUR0T0RzVmZGcjJrWndw?=
 =?utf-8?B?RlViQWdWUFNyNlBtWkFnWlNpZlU5bUtCMmxsM0NTV2xKOXhPZ0xiZnlzTmpq?=
 =?utf-8?B?QS9vdjBlK2VTR1FqSjc2TDZxZ2ZJMmprUS9lTUZrbnUvS2tZbllnQ3ErK2g0?=
 =?utf-8?B?WExGTnJ0RElSVFprZVJ4dFQyTm5zQWlJSnlsVUEySkdFTU5hSjdiVktQdXNr?=
 =?utf-8?B?bTVWZHlROGNENDNwMC9SVWU3MXBaZUhlMnVkWWNJRDR1REdHcW1MeHhoNW9t?=
 =?utf-8?B?SklEZnBzQ0FlS0JYbjk4VkM0enRhRU94WDdOcGZvRXkxc1BremoxZ2tzMGZX?=
 =?utf-8?B?RXRLRVZHQ0tHVDhSMkd5MFFWZEg4SHQ4UHR1QUkrdG1DdGl3dVFKbkhrTHkv?=
 =?utf-8?B?aDY4UmFtWUNBVi92UHBlMm5tdEpJaU13RVY5enZxeFdzZi9BbWh2djB4eHJh?=
 =?utf-8?B?WTJnKzBZdTFnWGh5ZFhPbW94cWx6SXRWU2tqZWdyRVN1MkI3TmpxNStua2Zt?=
 =?utf-8?B?SEJUTmlmUUZWTDFjbEwycWNqdktDK1BDZ0cwbzlxR2Q5M1p6S3E3ZVpvNGF0?=
 =?utf-8?B?dUhGdDVrSGcyVUJvVUV5eGk2WFhac0lJOVI4VGhYNHRGNmFoNzhoYit4SWd1?=
 =?utf-8?B?WVBPNGVpV0tyYWtlU1VJMEFnUVVSZDhzM2ZiWFY5bjR4SW1XalBnZWtEUUNX?=
 =?utf-8?B?cjY0WFIwQTMra29vcG1Fem5qOFdCVEwreXdodENlU2M4cG9xajQ2VW1GcVZj?=
 =?utf-8?B?SDNyNHlXd0VoQ3RDZkNzUnJ2RkhkbERLclZ4ZmVuR3ZsRHo1QVVSUW1BYTB0?=
 =?utf-8?B?N2Nyd1Z2NmRqYjJjMERlQUJOd3hGSUF4OXAvMTNZNkwzZFhPR3NEMEdUYjFh?=
 =?utf-8?B?a3lhZFJmU1RPcVFqSG0vVWg1VlhqeXQ2TXdVb0Y1ZWdZcTlCRTQ4bldFcXNs?=
 =?utf-8?B?OTl2MEtYN0taVWswaU1pMVlycTcwM2ZPMWxqQXNOajNSMFQ1eXgyUEppaDhL?=
 =?utf-8?B?SEpmL3I2RXhkaEpUZ1hxcDFSd21MZ1NPOGVxQm1OV2ZWbG1HSWd6bTU0enBD?=
 =?utf-8?B?Y29Sa2o0eVkrVkdydEliRG9mcUFEU3dScVluZDNuSWljSlJmY2hKNUQ1Si9V?=
 =?utf-8?B?WnF5Z1o2NERsZGd3VWN4QWR1V1hMQXhCQk8vOWZmY1FJQ0g0aU9mNEY0bUl2?=
 =?utf-8?B?R3ZXbnA1cUd2RFNJM052cW1rbms5eG5MdWRzZE4xNXB4L3FpR01DUlhWZEhG?=
 =?utf-8?B?U1MvNFZIdHgxN1pQekNBZlJ4Uy9iM3Z5bytveXgwc3ByaXo5aHB0TlhLSkxT?=
 =?utf-8?B?TWFVZVN1Z3VmZ3dvbStYcnAwRmVOa2xYdHVqUzhsQS9rTVVacmYrZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: caa3aac9-64f4-4483-bae1-08deb2c14617
X-MS-Exchange-CrossTenant-AuthSource: DM3PR12MB9416.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2026 20:33:50.9340
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v0NVlXZVdQ2/OkMv33njHUfpPTS0AYMmSxFASLxsACrWCgLHvHQDuO1+s/iskIq1gBIDlKido4DSeRltpz6K2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6754
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E4CAF80005
X-Stat-Signature: z9gtz75cfqcdyxabp1coyfms44qjjpfm
X-Rspam-User: 
X-HE-Tag: 1778877237-761532
X-HE-Meta: U2FsdGVkX1/btqYuN3Q0in2R8WpI7rhrMRDD1bqTwJjaek8uDBiXv3e2iVJ3PKNwojTPYMUdXL4kSXVb0CJV7pZEIahWLPmA9M1lcdpaCZ+eEEPL9WdbMOcRpKAloVP4/uUtQNmkxJjKiRYqfQlUM8hsA687nuTvYd9sOC4Trv19siUTPkk1O2IvBAWtoWpRfep2brbzWjqgFC31E2KKLdySF6NhUxfEAleRn2DgVLl6DnVNxW9aLE9gf8hCybQNysk2B0tq/hestkmIiMoZn9VJ+QxD2xVZW9p9eNrdB1SmaatoUmz7nn7ArqYyzgoRG7v6kf5S1NMx6FajB0qN4doyx96NVDrkkhGUEj2XH0qVfW6XzTuuouS0KErDfbGvjB3CaJO8XQoM/9GhX9vhX90+ormiywdn1+jkqpKG6utuvDoZqEtZCRssYkZ8re2vfucmXmp/Vx+4eN5+Ifi4dSXmZE1hqyTWmtiqwPETnm6itEe3r4O8aYkSWhRMDAoAPE/Kc8U5ycdfKtKm3Z88exBMereUMa9oBxH1298lJ42RFleNPJ3AUgG9chDkvjADzxA032u7COpA3gnbmhtTYf5HCSvfNh7HR1ehKdNUvIx93uQlIeE8zBOiHehM0AM/q9hwTrj5xHrsPMruSZt56ozHk58iSuhkAOj9AH6coHVVYok+5ak18hLfEnn+L8B1CCLOCpG+QJll4fXhLWy3DhC0rUrlj9DP+h1IK45aM/td9Z3SWR5jzvGDbyOiqvMVF0MVvRo0+fadkkMjnrwes5tsaWnHpjm/pA/3AvzicntGwwWgl1GheeoUy9t9CQMD3aqK0RA5RrIHbKX7Z8Tl8qHTwC8JnR2TCBK71+T9egAYWPnXCD6LO/R4IzRSt76jXc6BpQkA29z6B0fj8/1GkZlkO7ivJ1E7bJPcTrQkU9OGqJGZxvGEQXZg0vmeOxQZurX722CIm/TqRPjcIh4
 zECrrnow
 kLR6FXWSzD4JZ9O4aeOiDM7vFRymQXCwvcJ12NC8S07/YZdkMJuPPYXDO72LIEJN/W6S3OQQUV9QQRlVmtjyUu759nIrVOQR5z2vboT4n3lbnLdvVvtlaWT5fGGFYAmBxR0VqFCgMVXlEq58kNchB5rqyofh4XdF0GzEhegvKGaAnLB76yvvUMNhLGA06g6d6seSU2YxCU7d8I9ijwUhgQGemZ3sdGiqzOdFfmpoNInwqrb/WjuIk6qNr2i8AlQAoIxpVMgk344zJ8jx0J+d+hOgfeoUjzYl3rBQjDATgr88EDO/yyrMBCr2T9TPN0hW1ASgufl8NGBA4ouJaRMGKbgOZWqsmybEdU1tJWO31s35hkuEEPcdxWMVOvPSJpkB7Bx4DU6Y4DNVIHuZMY65KWgY1Hl9FgVkCFpMkJ37jsOaISom4KgEtKOuayoAQEr0l31iWstGA7++ucAIVpF163MWsC0DNbzB5qVIyWdwVJVSkObmcNrcq0rToUJ1IBWFoIkcHE/fUB5gc16cEmURPtFgBigrX8OVPoqZ05Ck7V3FnBsuiQQkBoBqmjaqPp2z8HfzJL3KCoZj+pLS5Ul8BPUQmOzG/aRegazdaNOkmOLp9Yo6NkPGOoM5JF0SpnwmePA3Z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/15/26 1:48 AM, Sarthak Sharma wrote:
> Rewrite gup_test.c using kselftest_harness.h. The new test uses
> FIXTURE_VARIANT to cover seven configurations (private/shared,
> read/write, THP, hugetlb) and runs four test cases per variant
> (GUP_BASIC_TEST, PIN_BASIC_TEST, DUMP_USER_PAGES_TEST with get and
> pin), giving 28 TAP-reported cases in total without requiring any
> command-line arguments.
> 
> Update run_vmtests.sh: remove run_gup_matrix() and the multiple flagged
> invocations of gup_test, replacing them with a single unconditional
> invocation. Benchmark functionality is handled by tools/mm/gup_bench
> introduced in the previous patch.

Hi Sarthak,

Looks like sashiko has a few good observations, these are
worth considering IMHO:

  
https://sashiko.dev/#/patchset/20260515084840.174652-1-sarthak.sharma@arm.com

thanks,
-- 
John Hubbard

> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
> ---
>   tools/testing/selftests/mm/gup_test.c     | 404 ++++++++++------------
>   tools/testing/selftests/mm/run_vmtests.sh |  37 +-
>   2 files changed, 182 insertions(+), 259 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/gup_test.c b/tools/testing/selftests/mm/gup_test.c
> index 3f841a96f870..c0e5e88d89ed 100644
> --- a/tools/testing/selftests/mm/gup_test.c
> +++ b/tools/testing/selftests/mm/gup_test.c
> @@ -9,12 +9,11 @@
>   #include <sys/mman.h>
>   #include <sys/stat.h>
>   #include <sys/types.h>
> -#include <pthread.h>
> -#include <assert.h>
>   #include <mm/gup_test.h>
>   #include "kselftest.h"
>   #include "vm_util.h"
>   #include "hugepage_settings.h"
> +#include "kselftest_harness.h"
>   
>   #define MB (1UL << 20)
>   
> @@ -23,253 +22,212 @@
>   
>   #define GUP_TEST_FILE "/sys/kernel/debug/gup_test"
>   
> -static unsigned long cmd = GUP_FAST_BENCHMARK;
> -static int gup_fd, repeats = 1;
> -static unsigned long size = 128 * MB;
> -/* Serialize prints */
> -static pthread_mutex_t print_mutex = PTHREAD_MUTEX_INITIALIZER;
> +FIXTURE(gup_test) {
> +	int gup_fd;
> +	char *addr;
> +	unsigned long size;
> +};
>   
> -static char *cmd_to_str(unsigned long cmd)
> +FIXTURE_VARIANT(gup_test) {
> +	bool thp;
> +	bool hugetlb;
> +	bool write;
> +	bool shared;
> +};
> +
> +FIXTURE_VARIANT_ADD(gup_test, private_write)
>   {
> -	switch (cmd) {
> -	case GUP_FAST_BENCHMARK:
> -		return "GUP_FAST_BENCHMARK";
> -	case PIN_FAST_BENCHMARK:
> -		return "PIN_FAST_BENCHMARK";
> -	case PIN_LONGTERM_BENCHMARK:
> -		return "PIN_LONGTERM_BENCHMARK";
> -	case GUP_BASIC_TEST:
> -		return "GUP_BASIC_TEST";
> -	case PIN_BASIC_TEST:
> -		return "PIN_BASIC_TEST";
> -	case DUMP_USER_PAGES_TEST:
> -		return "DUMP_USER_PAGES_TEST";
> -	}
> -	return "Unknown command";
> -}
> +	.thp = false,
> +	.hugetlb = false,
> +	.write = true,
> +	.shared = false,
> +};
>   
> -void *gup_thread(void *data)
> +FIXTURE_VARIANT_ADD(gup_test, private_readonly)
>   {
> -	struct gup_test gup = *(struct gup_test *)data;
> -	int i, status;
> -
> -	/* Only report timing information on the *_BENCHMARK commands: */
> -	if ((cmd == PIN_FAST_BENCHMARK) || (cmd == GUP_FAST_BENCHMARK) ||
> -	     (cmd == PIN_LONGTERM_BENCHMARK)) {
> -		for (i = 0; i < repeats; i++) {
> -			gup.size = size;
> -			status = ioctl(gup_fd, cmd, &gup);
> -			if (status)
> -				break;
> -
> -			pthread_mutex_lock(&print_mutex);
> -			ksft_print_msg("%s: Time: get:%lld put:%lld us",
> -				       cmd_to_str(cmd), gup.get_delta_usec,
> -				       gup.put_delta_usec);
> -			if (gup.size != size)
> -				ksft_print_msg(", truncated (size: %lld)", gup.size);
> -			ksft_print_msg("\n");
> -			pthread_mutex_unlock(&print_mutex);
> -		}
> -	} else {
> -		gup.size = size;
> -		status = ioctl(gup_fd, cmd, &gup);
> -		if (status)
> -			goto return_;
> -
> -		pthread_mutex_lock(&print_mutex);
> -		ksft_print_msg("%s: done\n", cmd_to_str(cmd));
> -		if (gup.size != size)
> -			ksft_print_msg("Truncated (size: %lld)\n", gup.size);
> -		pthread_mutex_unlock(&print_mutex);
> -	}
> +	.thp = false,
> +	.hugetlb = false,
> +	.write = false,
> +	.shared = false,
> +};
>   
> -return_:
> -	ksft_test_result(!status, "ioctl status %d\n", status);
> -	return NULL;
> -}
> +FIXTURE_VARIANT_ADD(gup_test, private_write_thp)
> +{
> +	.thp = true,
> +	.hugetlb = false,
> +	.write = true,
> +	.shared = false,
> +};
>   
> -int main(int argc, char **argv)
> +FIXTURE_VARIANT_ADD(gup_test, private_readonly_thp)
>   {
> -	struct gup_test gup = { 0 };
> -	int filed, i, opt, nr_pages = 1, thp = -1, write = 1, nthreads = 1, ret;
> -	int flags = MAP_PRIVATE;
> -	char *file = "/dev/zero";
> -	bool hugetlb = false;
> -	pthread_t *tid;
> -	char *p;
> +	.thp = true,
> +	.hugetlb = false,
> +	.write = false,
> +	.shared = false,
> +};
>   
> -	while ((opt = getopt(argc, argv, "m:r:n:F:f:abcj:tTLUuwWSHpz")) != -1) {
> -		switch (opt) {
> -		case 'a':
> -			cmd = PIN_FAST_BENCHMARK;
> -			break;
> -		case 'b':
> -			cmd = PIN_BASIC_TEST;
> -			break;
> -		case 'L':
> -			cmd = PIN_LONGTERM_BENCHMARK;
> -			break;
> -		case 'c':
> -			cmd = DUMP_USER_PAGES_TEST;
> -			/*
> -			 * Dump page 0 (index 1). May be overridden later, by
> -			 * user's non-option arguments.
> -			 *
> -			 * .which_pages is zero-based, so that zero can mean "do
> -			 * nothing".
> -			 */
> -			gup.which_pages[0] = 1;
> -			break;
> -		case 'p':
> -			/* works only with DUMP_USER_PAGES_TEST */
> -			gup.test_flags |= GUP_TEST_FLAG_DUMP_PAGES_USE_PIN;
> -			break;
> -		case 'F':
> -			/* strtol, so you can pass flags in hex form */
> -			gup.gup_flags = strtol(optarg, 0, 0);
> -			break;
> -		case 'j':
> -			nthreads = atoi(optarg);
> -			break;
> -		case 'm':
> -			size = atoi(optarg) * MB;
> -			break;
> -		case 'r':
> -			repeats = atoi(optarg);
> -			break;
> -		case 'n':
> -			nr_pages = atoi(optarg);
> -			if (nr_pages < 0)
> -				nr_pages = size / psize();
> -			break;
> -		case 't':
> -			thp = 1;
> -			break;
> -		case 'T':
> -			thp = 0;
> -			break;
> -		case 'U':
> -			cmd = GUP_BASIC_TEST;
> -			break;
> -		case 'u':
> -			cmd = GUP_FAST_BENCHMARK;
> -			break;
> -		case 'w':
> -			write = 1;
> -			break;
> -		case 'W':
> -			write = 0;
> -			break;
> -		case 'f':
> -			file = optarg;
> -			break;
> -		case 'S':
> -			flags &= ~MAP_PRIVATE;
> -			flags |= MAP_SHARED;
> -			break;
> -		case 'H':
> -			flags |= (MAP_HUGETLB | MAP_ANONYMOUS);
> -			hugetlb = true;
> -			break;
> -		default:
> -			ksft_exit_fail_msg("Wrong argument\n");
> -		}
> -	}
> +FIXTURE_VARIANT_ADD(gup_test, private_write_hugetlb)
> +{
> +	.thp = false,
> +	.hugetlb = true,
> +	.write = true,
> +	.shared = false,
> +};
>   
> -	if (optind < argc) {
> -		int extra_arg_count = 0;
> -		/*
> -		 * For example:
> -		 *
> -		 *   ./gup_test -c 0 1 0x1001
> -		 *
> -		 * ...to dump pages 0, 1, and 4097
> -		 */
> -
> -		while ((optind < argc) &&
> -		       (extra_arg_count < GUP_TEST_MAX_PAGES_TO_DUMP)) {
> -			/*
> -			 * Do the 1-based indexing here, so that the user can
> -			 * use normal 0-based indexing on the command line.
> -			 */
> -			long page_index = strtol(argv[optind], 0, 0) + 1;
> -
> -			gup.which_pages[extra_arg_count] = page_index;
> -			extra_arg_count++;
> -			optind++;
> -		}
> -	}
> +FIXTURE_VARIANT_ADD(gup_test, private_readonly_hugetlb)
> +{
> +	.thp = false,
> +	.hugetlb = true,
> +	.write = false,
> +	.shared = false,
> +};
>   
> -	ksft_print_header();
> +FIXTURE_VARIANT_ADD(gup_test, shared_write)
> +{
> +	.thp = false,
> +	.hugetlb = false,
> +	.write = true,
> +	.shared = true,
> +};
> +
> +FIXTURE_SETUP(gup_test) {
> +	int mmap_flags = MAP_PRIVATE;
> +	int zero_fd;
> +	char *p;
>   
> -	if (hugetlb) {
> +	self->size = 128 * MB;
> +
> +	/* Check for hugetlb */
> +	if (variant->hugetlb) {
>   		unsigned long hp_size = default_huge_page_size();
>   
>   		if (!hp_size)
> -			ksft_exit_skip("HugeTLB is unavailable\n");
> +			SKIP(return, "HugeTLB not available\n");
> +
> +		self->size = (self->size + hp_size - 1) & ~(hp_size - 1);
> +		if (!hugetlb_setup_default(self->size / hp_size))
> +			SKIP(return, "Not enough huge pages\n");
>   
> -		size = (size + hp_size - 1) & ~(hp_size - 1);
> -		if (!hugetlb_setup_default(size / hp_size))
> -			ksft_exit_skip("Not enough huge pages\n");
> +		mmap_flags |= (MAP_HUGETLB | MAP_ANONYMOUS);
>   	}
>   
> -	ksft_set_plan(nthreads);
> +	/* zero_fd has to be >=0. Already checked in main() */
> +	zero_fd = open("/dev/zero", O_RDWR);
> +	ASSERT_GE(zero_fd, 0);
>   
> -	filed = open(file, O_RDWR|O_CREAT, 0664);
> -	if (filed < 0)
> -		ksft_exit_fail_msg("Unable to open %s: %s\n", file, strerror(errno));
> +	/* gup_fd has to be >=0. Already checked in main() */
> +	self->gup_fd = open(GUP_TEST_FILE, O_RDWR);
> +	ASSERT_GE(self->gup_fd, 0);
> +
> +	if (variant->shared)
> +		mmap_flags = (mmap_flags & ~MAP_PRIVATE) | MAP_SHARED;
> +
> +	self->addr = mmap(NULL, self->size, PROT_READ | PROT_WRITE,
> +					mmap_flags, zero_fd, 0);
> +	close(zero_fd);
> +	ASSERT_NE(self->addr, MAP_FAILED);
> +
> +	if (variant->thp)
> +		madvise(self->addr, self->size, MADV_HUGEPAGE);
> +
> +	for (p = self->addr; (unsigned long)p < (unsigned long)self->addr
> +			+ self->size; p += psize())
> +		p[0] = 0;
> +}
> +
> +FIXTURE_TEARDOWN(gup_test) {
> +	munmap(self->addr, self->size);
> +	close(self->gup_fd);
> +}
> +
> +TEST_F(gup_test, get_user_pages) {
> +	/* tests get_user_pages */
> +	struct gup_test gup = { 0 };
> +
> +	gup.addr = (unsigned long)self->addr;
> +	gup.size = self->size;
> +	gup.nr_pages_per_call = 1;
>   
> -	gup.nr_pages_per_call = nr_pages;
> -	if (write)
> +	if (variant->write)
>   		gup.gup_flags |= FOLL_WRITE;
>   
> -	gup_fd = open(GUP_TEST_FILE, O_RDWR);
> -	if (gup_fd == -1) {
> -		switch (errno) {
> -		case EACCES:
> -			if (getuid())
> -				ksft_print_msg("Please run this test as root\n");
> -			break;
> -		case ENOENT:
> -			if (opendir("/sys/kernel/debug") == NULL)
> -				ksft_print_msg("mount debugfs at /sys/kernel/debug\n");
> -			ksft_print_msg("check if CONFIG_GUP_TEST is enabled in kernel config\n");
> -			break;
> -		default:
> -			ksft_print_msg("failed to open %s: %s\n", GUP_TEST_FILE, strerror(errno));
> -			break;
> -		}
> -		ksft_test_result_skip("Please run this test as root\n");
> -		ksft_exit_pass();
> -	}
> +	ASSERT_EQ(ioctl(self->gup_fd, GUP_BASIC_TEST, &gup), 0);
> +}
>   
> -	p = mmap(NULL, size, PROT_READ | PROT_WRITE, flags, filed, 0);
> -	if (p == MAP_FAILED)
> -		ksft_exit_fail_msg("mmap: %s\n", strerror(errno));
> -	gup.addr = (unsigned long)p;
> +TEST_F(gup_test, pin_user_pages) {
> +	/* tests pin_user_pages */
> +	struct gup_test gup = { 0 };
>   
> -	if (thp == 1)
> -		madvise(p, size, MADV_HUGEPAGE);
> -	else if (thp == 0)
> -		madvise(p, size, MADV_NOHUGEPAGE);
> +	gup.addr = (unsigned long)self->addr;
> +	gup.size = self->size;
> +	gup.nr_pages_per_call = 1;
>   
> -	/* Fault them in here, from user space. */
> -	for (; (unsigned long)p < gup.addr + size; p += psize())
> -		p[0] = 0;
> +	if (variant->write)
> +		gup.gup_flags |= FOLL_WRITE;
> +
> +	ASSERT_EQ(ioctl(self->gup_fd, PIN_BASIC_TEST, &gup), 0);
> +}
> +
> +TEST_F(gup_test, dump_user_pages_with_get) {
> +	/* tests DUMP_USER_PAGES_TEST using get_user_pages */
> +	struct gup_test gup = { 0 };
> +
> +	gup.addr = (unsigned long)self->addr;
> +	gup.size = self->size;
> +	gup.nr_pages_per_call = 1;
> +
> +	if (variant->write)
> +		gup.gup_flags |= FOLL_WRITE;
> +
> +	gup.which_pages[0] = 1;
> +
> +	ASSERT_EQ(ioctl(self->gup_fd, DUMP_USER_PAGES_TEST, &gup), 0);
> +}
>   
> -	tid = malloc(sizeof(pthread_t) * nthreads);
> -	assert(tid);
> -	for (i = 0; i < nthreads; i++) {
> -		ret = pthread_create(&tid[i], NULL, gup_thread, &gup);
> -		assert(ret == 0);
> +TEST_F(gup_test, dump_user_pages_with_pin) {
> +	/* tests DUMP_USER_PAGES_TEST using pin_user_pages */
> +	struct gup_test gup = { 0 };
> +
> +	gup.addr = (unsigned long)self->addr;
> +	gup.size = self->size;
> +	gup.nr_pages_per_call = 1;
> +
> +	if (variant->write)
> +		gup.gup_flags |= FOLL_WRITE;
> +
> +	gup.which_pages[0] = 1;
> +	gup.test_flags |= GUP_TEST_FLAG_DUMP_PAGES_USE_PIN;
> +
> +	ASSERT_EQ(ioctl(self->gup_fd, DUMP_USER_PAGES_TEST, &gup), 0);
> +}
> +
> +int main(int argc, char **argv)
> +{
> +	int fd;
> +	char *file = "/dev/zero";
> +
> +	fd = open(file, O_RDWR);
> +	if (fd < 0) {
> +		ksft_print_header();
> +		ksft_exit_fail_msg("Unable to open %s: %s\n", file, strerror(errno));
>   	}
> -	for (i = 0; i < nthreads; i++) {
> -		ret = pthread_join(tid[i], NULL);
> -		assert(ret == 0);
> +	close(fd);
> +
> +	fd = open(GUP_TEST_FILE, O_RDWR);
> +	if (fd == -1) {
> +		ksft_print_header();
> +		if (errno == EACCES)
> +			ksft_exit_skip("Please run this test as root\n");
> +		if (errno == ENOENT) {
> +			if (opendir("/sys/kernel/debug") == NULL)
> +				ksft_exit_skip("Mount debugfs at /sys/kernel/debug\n");
> +			else
> +				ksft_exit_skip("Check CONFIG_GUP_TEST in kernel config\n");
> +		}
> +		ksft_exit_skip("failed to open %s: %s\n", GUP_TEST_FILE, strerror(errno));
>   	}
> +	close(fd);
>   
> -	free(tid);
> -
> -	ksft_exit_pass();
> +	return test_harness_run(argc, argv);
>   }
> diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
> index 043aa3ed2596..65a4ef0f3748 100755
> --- a/tools/testing/selftests/mm/run_vmtests.sh
> +++ b/tools/testing/selftests/mm/run_vmtests.sh
> @@ -130,30 +130,6 @@ test_selected() {
>   	fi
>   }
>   
> -run_gup_matrix() {
> -    # -t: thp=on, -T: thp=off, -H: hugetlb=on
> -    local hugetlb_mb=256
> -
> -    for huge in -t -T "-H -m $hugetlb_mb"; do
> -        # -u: gup-fast, -U: gup-basic, -a: pin-fast, -b: pin-basic, -L: pin-longterm
> -        for test_cmd in -u -U -a -b -L; do
> -            # -w: write=1, -W: write=0
> -            for write in -w -W; do
> -                # -S: shared
> -                for share in -S " "; do
> -                    # -n: How many pages to fetch together?  512 is special
> -                    # because it's default thp size (or 2M on x86), 123 to
> -                    # just test partial gup when hit a huge in whatever form
> -                    for num in "-n 1" "-n 512" "-n 123" "-n -1"; do
> -                        CATEGORY="gup_test" run_test ./gup_test \
> -                                $huge $test_cmd $write $share $num
> -                    done
> -                done
> -            done
> -        done
> -    done
> -}
> -
>   # filter 64bit architectures
>   ARCH64STR="arm64 mips64 parisc64 ppc64 ppc64le riscv64 s390x sparc64 x86_64"
>   if [ -z "$ARCH" ]; then
> @@ -239,18 +215,7 @@ fi
>   
>   CATEGORY="mmap" run_test ./map_fixed_noreplace
>   
> -if $RUN_ALL; then
> -    run_gup_matrix
> -else
> -    # get_user_pages_fast() benchmark
> -    CATEGORY="gup_test" run_test ./gup_test -u -n 1
> -    CATEGORY="gup_test" run_test ./gup_test -u -n -1
> -    # pin_user_pages_fast() benchmark
> -    CATEGORY="gup_test" run_test ./gup_test -a -n 1
> -    CATEGORY="gup_test" run_test ./gup_test -a -n -1
> -fi
> -# Dump pages 0, 19, and 4096, using pin_user_pages:
> -CATEGORY="gup_test" run_test ./gup_test -ct -F 0x1 0 19 0x1000
> +CATEGORY="gup_test" run_test ./gup_test
>   CATEGORY="gup_test" run_test ./gup_longterm
>   
>   CATEGORY="userfaultfd" run_test ./uffd-unit-tests




