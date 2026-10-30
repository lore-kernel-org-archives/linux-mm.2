Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 047BB606A322
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 07:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=nt+3bu2s
Received: by kanga.kvack.org (Postfix)
	id E4B456B00EF; Fri, 30 Oct 2026 03:53:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF4366B05B1; Fri, 30 Oct 2026 03:53:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBC486B05B2; Fri, 30 Oct 2026 03:53:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A40106B00EF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 03:53:08 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3B67BA064A
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 07:53:08 +0000 (UTC)
X-FDA: 85378526856.16.A1EBCCA
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011011.outbound.protection.outlook.com [52.101.57.11])
	by imf26.hostedemail.com (Postfix) with ESMTP id 415BB140003
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 07:53:05 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=nt+3bu2s;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of radhey.shyam.pandey@amd.com designates 52.101.57.11 as permitted sender) smtp.mailfrom=radhey.shyam.pandey@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793346785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GDMHTFGoPyfogpRLgc4NILo4wByRz7Ldn2+4rE/lcfE=;
	b=JQAN5HustjzLH+s1jhVErM/kg8FfhrPA1GgWwOtRRhGgxGVxnGJE/Q9uvgpj6LDbn11+if
	RvSzP6SgXiX+bDKEITT49URCztpfGqcecEI7E4UZEIqiniKHK3ViHrF8Gx2HE1eD666mFK
	IpyYLrXjIEiKWZfEf9rzgJb9mRfX0lw=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=nt+3bu2s;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of radhey.shyam.pandey@amd.com designates 52.101.57.11 as permitted sender) smtp.mailfrom=radhey.shyam.pandey@amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793346785;
	b=JyVkyciAK/ASMZJ7kjvMXrADAiWTYIjh4j6qsjVgDSYlTRY7syRA1R9+N8VANHiBJg0Ilw
	Xd4K14QPMk2Uv3lc/E2YEIZJjwFP08M8X5XYnSH7MfEx4iL+QvKTyVw7szIKUXjOZ24nSe
	rU/Y58lrgWFoQwpesGqKXFyPncbYttc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KkheLTuxAmzCk5VmSw5jWxyjMx3+/6B//8Hp3mjhTN+L7G4LEKIJ1X4hmBTM3O/gN2n1WL2UD4FT1i0xUyTtloMNB7tf8/iSTWp6GvA9CxKz5ro1mghRgz8Oi3qhw6xzk8+gEnk0S8hjbMIZhBX7alY6oeCLQ9i40z3Twbp0e9W1iSht2KjZ4PvyN6GrVMJxprNpyF8kyvuXyON2jOoqsqdf5covkDjbrmXbqheIQsMjFyTY08mCGHxumcwhmTHIdFxqa5KQ7BRiK5lj72L7OoYmNv9hkTxuoVLCxMEkKISoFkKs+sfs72JpHFqFGnmV+xXb9ZabX0ZNmRE43j4XXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GDMHTFGoPyfogpRLgc4NILo4wByRz7Ldn2+4rE/lcfE=;
 b=oyp8YrOeAKtAanZpMiZYvQ7t9EXzAZmPCPkD7E1lLekzD1dhfc2iu/A9DcWO6Kf75kqq7L4YCfumVTSKATkcb5VCmRMIVEZz3/IABeSwZM1M5qoJ2ZmjaFLWD9jRX6Ie2xPOplueZqMDwAoxV4RpIJ1l+8wAhaU4spj90Mys6h/tYen8wH7wKbYRkNFA9hNak3aQ9asxDKqUHPwDZHAA5cDzdFAVN5IAE//eOTBxysQGPaHsL9oG0DYf4q6xUcdIjC/cjUtcZNghn7zIajGfvrQLEMPFEM3yHklmaLH16slIEc8SSDZ8TAG32iQZltXA4BVNYu8bS/Gsza1e00DLjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GDMHTFGoPyfogpRLgc4NILo4wByRz7Ldn2+4rE/lcfE=;
 b=nt+3bu2swGVAjRuf7AAtZWMCu5anBq4GBvUpj6DxK2vzHrRXXB2YzTiKJNDPUKDot4dyEFp4vYBXtblI8OnJC2yuvKsfQJfSj+qnrK0ip9ByPIvYDogzb4i2cEcnXUTr/7WqdaostUZ0a32mObx879W6NIa+F+riccSw89AxmE8=
Received: from CY1PR12MB9697.namprd12.prod.outlook.com (2603:10b6:930:107::6)
 by LV3PR12MB9186.namprd12.prod.outlook.com (2603:10b6:408:197::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.9; Fri, 30 Oct
 2026 07:53:01 +0000
Received: from CY1PR12MB9697.namprd12.prod.outlook.com
 ([fe80::3a41:55a0:8203:596d]) by CY1PR12MB9697.namprd12.prod.outlook.com
 ([fe80::3a41:55a0:8203:596d%6]) with mapi id 15.21.0569.009; Fri, 30 Oct 2026
 07:53:01 +0000
Message-ID: <7625fa23-5f4b-4658-b17a-fe4e58103e7c@amd.com>
Date: Fri, 30 Oct 2026 13:22:50 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/2] kexec: do not place the next kernel in a
 fixed-address CMA area
To: Pratyush Yadav <pratyush@kernel.org>, Mike Rapoport <rppt@kernel.org>
Cc: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
 baoquan.he@linux.dev, pasha.tatashin@soleen.com, graf@amazon.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kexec@lists.infradead.org
References: <20261014145731.3431527-1-radhey.shyam.pandey@amd.com>
 <20261014145731.3431527-2-radhey.shyam.pandey@amd.com>
 <2vxzh5i5orbv.fsf@kernel.org> <auL3UW2InVqYU6Fs@kernel.org>
 <2vxzzevwmz2v.fsf@kernel.org>
Content-Language: en-US
From: "Pandey, Radhey Shyam" <radheys@amd.com>
In-Reply-To: <2vxzzevwmz2v.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PNYP287CA0113.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:2b3::13) To CY1PR12MB9697.namprd12.prod.outlook.com
 (2603:10b6:930:107::6)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY1PR12MB9697:EE_|LV3PR12MB9186:EE_
X-MS-Office365-Filtering-Correlation-Id: 0bf9e457-a104-446e-8bcc-08df365ad20b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|6133799003|18002099003|22082099003|56012099006|11063799006|4143699003|261026140227099003|261026121527099003|261028144727099003|10067099003|261021121427099003|261022115727099003|261022075727099003|261022105027099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	ncIkpwE30ujzOaK4NFwvXq1TNTZHZ83zhCCEoYcxlIAk9oK/CSjUhSIeVF9f2Np0zrFFMc7vq3nf0/THepf0FuMOdn1UZNZrT+fh5wU2EygJScRzVvLVuzQNarBYXxpGv9hlShKbaX3odsG7M8mfw+K+md0JD7+VKmeJkth7z3kZP9vG0lKs54YowTraB/URiwVll5vjvJOVVM5OtlGPYDzddNv+RXzT0XWGKx29kJh+HFknGs1iIp/QLJN6JvoJEjRG3LA1xhMxfEKgbc5tDJW0A5LskTzEpezrWUwwqSolyuUyD8X4akItpmEeysOFTyMgwilcQUfGwQ0ufQYkrfqclAjVTGIyl96IGTlTLUVBGBaGmij9A+AyvVDBd1sdwFICS9EYJb6WCpodTSrNYGE4G+Gpz6v3LitJRgU3qJQOtf4ytvt8D6vyCwrm2kVgpN5Bm4ItO5TuW10Bq/mWvpDhc3z+DjFAV47czOxlk1Vgzl/lCv8bVZFOj7pNi7eKO218bUdamHygVzcxVIvGKZfQqiHavA5EKRKyVTaiqWXhmaitgmop3KHKRn/tc33WeOQjL2DuvPIk9BpPdLzgCxQWpYP5HcyS1L5EBSQ4SaiHppn3iACRg2w9RBRBywxtjg/JODaLRCsJ0qlKLjMi3oFghxI1ygpN3FmLXpLHQuU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY1PR12MB9697.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(6133799003)(18002099003)(22082099003)(56012099006)(11063799006)(4143699003)(261026140227099003)(261026121527099003)(261028144727099003)(10067099003)(261021121427099003)(261022115727099003)(261022075727099003)(261022105027099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R2ZCaGxKRUJuMTZTQ3dYTVUxUk5xUzFEWEc5cUwwRWwxcGsyaG1PTk1weVdv?=
 =?utf-8?B?TUNFeEpJL2liS0hXeGd4RUZlVnM3SjFNMjRpcjFkM1VOUXJwOGxCZ2RvTlgz?=
 =?utf-8?B?NW9BTDBZM25ueWFqSDFwTFNHRXhSU1RJZDhNSjhZWTBQNEhlTUpLNUEySVBl?=
 =?utf-8?B?dFNPaThiRDI1ZmVBZzVBVHluL0tUSGNGSlNrRS96cVE3N2t3cFVPVWNNOUF2?=
 =?utf-8?B?YmwwTW9HVVl2VkkvTU9hVXBlMG9KalZnK3VJcUovODNrdUdQNnBOTkRiTDRL?=
 =?utf-8?B?cFFiL3BFUW01SE02dTJ0cEtJdjJ0M01pYU53L0FtWUIydHN5UXhQaWI4UTls?=
 =?utf-8?B?eUlncE03Q241NmlWbmhRTHY3MjEyeXVuUEJ6R2p6R0lpZzU1OEhaN0VGdTV2?=
 =?utf-8?B?cXd0YURmVERBcVdiVGU0Z0NiM3dxVUpjWTUzbE9RS01rQnpza3JZTjVOSk1a?=
 =?utf-8?B?cEN1WEJqVHBjWWFBd0g0MVFQK3pFU1dwWGc2a3JEQ3d5ZVUzM1E0bmp5VlBl?=
 =?utf-8?B?OVhnZ2Y3SjZLekRneGlubmxSM3JqdE1pSERQdHFqdWdCN2hpd3RvbVBkcVZM?=
 =?utf-8?B?dGl5SEdmYWxFVHRSMi9xeThJMzhKY2oxbXZOZ0lBaStzRVJKY2RMNE56L25l?=
 =?utf-8?B?VVcvRVVPS3hRTkdXaGNGd0VBbXgyR1JwQ0FmQzVxS2pIVkYzZlJlSU14MHN5?=
 =?utf-8?B?OGdqR2VPKzFGRy9ZWWpVaFFkTnBmakVQQ2YxVzJlN3NXOG04azNsUCtxZEJD?=
 =?utf-8?B?NEI5QTVBMDJQQzk4NkYzUUZkWHhxVFRlS1lYUkNRajdaWURKclZCQ0RGUW9C?=
 =?utf-8?B?TU5jWXpyYnF3RlpsSUVGRGw4YitpaVZkQjYvQTJmQk1ta1h3L3BaTkRSdW1k?=
 =?utf-8?B?Ui83WENVV3lRWTUzMWZ0cDNnYXhtenc5MHlBUW9DNW5VK0NiUERZRy9DWllD?=
 =?utf-8?B?cEdIM1BuSzdIYkVMOTFHRktrYUJrM2VUU3E2US9rdHAvTlNHYnU2RWhWNndV?=
 =?utf-8?B?S3V2RkNSQlBldExjNmdaTUpER2FxSW90UkZwVC9WT2VUWFI3emJSZmFxcmdY?=
 =?utf-8?B?VlQ0ZFRsQzRNYVdQUzVZSENzQlpPQTVJS2d2OTRrMCtDODVwVGk4by9HRHdP?=
 =?utf-8?B?Y2cvZk1BY1d2akhRY0pnN00vLzM5Y3lUWkNEdnM4QS80UCtIT2dKMWRpdHV3?=
 =?utf-8?B?N1I0RHZRVFUvc0ViUUtWZ09TeFI3WWluL0djNXE2VHpNek1XUVdESWxDaHlu?=
 =?utf-8?B?ZFVsTmxnMFUrcU11dzM1T2h0YlIyOE1vVHZKY3VuamxjTUZuczZreVM2OFFV?=
 =?utf-8?B?cldiUTE0NjB6SDVpbnZtN0QvK21qc001Y2RBQkN0NjQ5NlF2ejNRS0hJZGN5?=
 =?utf-8?B?QnZNNGtjNW0yUFdwQnNNcW9ZV3ZRYVJ3b0dCWU5yWXlyYndUUEFGejNTcmNC?=
 =?utf-8?B?ZlZzekVkemxRZy9CTmdsMk8zenZpcU9YT0NBZkhJRDhXVFFyenVJSE0wNkpp?=
 =?utf-8?B?VmF0SFZxT3hQNjNuMUtTVXp6OUwyOGV0Z2g2Z25HQVhRV25XNnI1QlJuNTBy?=
 =?utf-8?B?QllHNDAzNEpHTStCdWNROTltaHRnM0RQZnJNd3oyUUdGOHVuWjdkRXVtMFhx?=
 =?utf-8?B?MlpzeVIybW1yajVUQ1NrNUJxY295Ly9uYVlSdE5tSVRhalh1c3NhRGk4VzU5?=
 =?utf-8?B?M010VlVHYklDMmloVWpZTys3bERnZzluWStnN0tWSXUyNXozY2NDMlN3TWlH?=
 =?utf-8?B?UkNyQ3F0N1RGa2lNSkF4bW5DUW12SS9hT2YyMHBkR3U0WVY3VTBHbVMzQm90?=
 =?utf-8?B?UGpBSEFPU3VMQ2F0bFNGaTNqNDJJL1YyMHhYZGxucUhYY1RjTnlxbUxLNG5K?=
 =?utf-8?B?eHc2d3NxTVdXcmlnS0o2bDRpYnE0QXRHdFVQOE1wY1VMSUVmRS9XZWppUnRu?=
 =?utf-8?B?RXZjaUd6eGdKU0pWRlF4eWNmTmxnemU3Z0dsaWNYV3ZIbXNUdUFWTXVLaVhx?=
 =?utf-8?B?aU1RdXJGS1lsK0JPT09wdHRoQ1lFR2tEZTVaUzdPODRJZldvUnNwb0U5NVUx?=
 =?utf-8?B?cTZodTVxVHJrZVYveFczYzE5OXczMGxiU0ZpODRQL2JaM3lsQU4rcTBMR2Fq?=
 =?utf-8?B?WUVHbXIrSlVIRG10RlE2ajBEY0cxRXVYUEYvZGJZbTRaT3BsUXMyRFZ0QklR?=
 =?utf-8?B?WFpZZTBMcWI5M01xNTNxdDZvbDBrdG9lenVOeFpMdFhnM2VRK2NUS2tWUWNN?=
 =?utf-8?B?U2Y3ZGNSOGhVc3RpQzhydmMyM2pHelVOZXlER0dNK1dISkluZXJ5eFZBZ3pq?=
 =?utf-8?Q?swPjXtQVXvmXG88dO/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bf9e457-a104-446e-8bcc-08df365ad20b
X-MS-Exchange-CrossTenant-AuthSource: CY1PR12MB9697.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2026 07:53:01.0143
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rJUDt9BrrLzpH8B73Fds6dIAjWt/Izzi7YVJcbrCvmlmc4Md5iVY3dqQVYrzxCyg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9186
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 415BB140003
X-Stat-Signature: dqscofeojhoiwzx5spshk913ta8hhzp1
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793346785-758747
X-HE-Meta: U2FsdGVkX19hvhFngdcncgW0nN6g+r9Gygi1ap8DepwLrQWFJLP3zOYl4Om6XEnCzijfYNLxundd22wQyFpn+0jA55bn6fa0pBwipn1/JG6VZfZcLLPGz312HXIQ6qA857z7BZKebcGxzGZKoVShEZ5DWuprn4C9JtjkT3TTB5vQGNG2ighpg7lrM/whtv69icagQOsmy37JpJz87m06FOP7OxSZ3cjWQuvSvBLD9TXCFwnOIurq77DogaiCVPl/XBqYtCchcyHi5of1Sua9fQRcvjx5B64ZJ3UuZ5S0AsXziNHB2MmfAuy/Kp8vKZ9M1A1NRKGVnnRg5qvVafE3Ld0hYtKwKdKGWsleej44EJYlgI/C0Zji6xkCGve01uxg+EjxQfFwWkocEuZIxI4Jo/FxoUhZftf7OGyuLXyt2J7vc79MDac+3kZkzv079BgxtX1UDsPuJYhYDfLq/KjqgU+LqEbQeP9AwvS7rWfC7Er9P6I+nrNsKAwPx6mmaV6dF4UG5UGUuE/24sCHJk0Va5ZUsg17WCP5y4V+E5/QqGEo41GWG6WeEeObqHrYQofXedjjZxpi86iQRXo3bsoiPxr1V1COBDQl/mLoDADAiAp1wUELL+UYR8H9i+XVjVCOnFgqFV/jutM1E94DhJW/z6oIJn5/t4T9++A0lQUYL04o9a4drp3mmE08fNbbnpxvF1OLNd+/b2N9sfq1cW1B38AYomUO3UqRgAYVgwRyja70afzrArvGZc/MbkCAjPC8WxDaBPivlpJJxAAWjH+ZOqsjDeut5MYZNFJXQdLKeFYN2o4ImYitDBEgR3bB3TuaKm3eC/BDS1x6RkP65rWgtG9e8GI3al9SuPSlGrh8//irJWkcUk/sLdXvnb+NkoRMePqT8A7JL3DkB+WH2Ds+z4qojbO4kroj6NdDla0Oe399+b5apULChim9zUyKFK8pHpVTbfxvaKsbdCJVBxT
 j4smjL+9
 t3dghyQ8znc5vX3/bNLUa+t7D3TJvAtg+rpq9zOlEMiPlaPzOZ0JCXpHrgcKH8gPo9mIEJhH2QeoJ81aXnTkqyBSga/CYPAM4hmQ6CG4emdszBtPllXXtH1thcpb2rTI0neT97O+A0S4dlaEHMwJbtyHDZRQaayFNuWz0Y9EjyQx2php4sGrnONGhyYco7rQWGwAKvvuvBlRiG8/Ap0PWdBPzOtMxNzGcqQtp9srmXt0C8XEqASzMLLVP0woPurgQGx/Ob5mqmChEqoZBoLgJ272I89vLxGbhrswyYH0j/tuiXyLGJzKnJXIMAlQ5TrCchtGWSaTBShj85Y3/lrvCEBoxb+LJi+KbxdooB72WIFjuEQFUXUk91W5aSpc5j38oyia7Y4lzhsa0ci6mearEs4K7+VGVJuBGod20+nKnkYL72wBUrwBcHPq45JiO4rAdy+wW+42Cw3MNqK0k66o+BSZ4nwBv6EIgcU+cP4zvB/6xXnuMhA3qUsO+v68pOXC+ko8bPkf7ZH6Xjx1QiCXLNoSawc+tYFamHlbirfhMMfbXCXLDqARZo7+duk53l7YeSxByRn10F6kJeZq11V7evMAyzRJTzmKTcXIhxRzALiIKnmdV4f/IC8aFS9uqd2A0dlLM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/29/2026 6:41 PM, Pratyush Yadav wrote:
> On Thu, Oct 29 2026, Mike Rapoport wrote:
> 
>> On Wed, Oct 28, 2026 at 03:03:16PM +0100, Pratyush Yadav wrote:
>>> On Wed, Oct 14 2026, Radhey Shyam Pandey wrote:
>>>
>>>> kexec_alloc_contig() picks the destination of the next kernel out of the
>>>> default CMA area, and the next kernel then runs from there in place
>>>> instead of being copied out. That is only safe if the area will not exist
>>>> at the same address in the kernel being loaded.
>>>>
>>>> For an area whose base came from the device tree, it will. The loaded
>>>> kernel parses the same description, declares the range it is executing
>>>> from as a shared-dma-pool, and cma_activate_area() releases the pages
>>>> holding its own image to the page allocator.
>>>>
>>>> Distinguish the two cases. An area placed by cma_declare_contiguous_nid()
>>>> without a fixed base lands wherever this kernel found room, and the next
>>>> kernel repeats that search against its own memblock state, so it cannot
>>>> collide. Record the difference as CMA_FIXED_BASE and refuse to use such
>>>> an area for the payload, which leaves kexec_locate_mem_hole() to fall
>>>> back to the memblock hole search as it did before CMA placement existed.
>>>>
>>>> This is what makes the KEXEC_FILE_NO_CMA flag unnecessary on platforms
>>>> that describe their CMA pools in the device tree.
>>>>
>>>> Tested on a AMD Versal AI Edge Series Gen 2 VEK385 Evaluation Kit whose
>>>> device tree declares three CMA pools, the first of which is
>>>> linux,cma-default:
>>>>
>>>>    cma_reserved@800000000     4 GiB at 0x800000000    (default)
>>>>    cma_reserved@50000000000   6 GiB at 0x50000000000
>>>>    cma_reserved@60000000000   4 GiB at 0x60000000000
>>>>
>>>> All three have a fixed base, so kexec_alloc_contig() declines the default
>>>> area and kexec_locate_mem_hole() falls through to the memblock search,
>>>> which places the Image segment at 0x9c00000 size 0x1de0000. The kernel
>>>> that boots from it reports its image as [0x09c00000-0x0b9e0000] and
>>>> 14680064K cma-reserved, i.e. all three pools still present and none of
>>>> them overlapping the running kernel.
>>>>
>>>> Fixes: 07d24902977e ("kexec: enable CMA based contiguous allocation")
>>>> Assisted-by: Claude:claude-opus-5
>>>> Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
>>>> ---
>>>>   include/linux/cma.h | 10 ++++++++++
>>>>   kernel/kexec_file.c | 12 ++++++++++++
>>>>   mm/cma.c            | 16 ++++++++++++++++
>>>>   mm/cma.h            |  2 ++
>>>>   4 files changed, 40 insertions(+)
>>>>
>>>> diff --git a/include/linux/cma.h b/include/linux/cma.h
>>>> index 8555d38a97b1..2fe66377e5d3 100644
>>>> --- a/include/linux/cma.h
>>>> +++ b/include/linux/cma.h
>>>> @@ -61,4 +61,14 @@ extern int cma_for_each_area(int (*it)(struct cma *cma, void *data), void *data)
>>>>   extern bool cma_intersects(struct cma *cma, unsigned long start, unsigned long end);
>>>>   
>>>>   extern void cma_reserve_pages_on_error(struct cma *cma);
>>>> +
>>>> +#ifdef CONFIG_CMA
>>>> +bool cma_has_fixed_base(const struct cma *cma);
>>>> +#else
>>>> +static inline bool cma_has_fixed_base(const struct cma *cma)
>>>> +{
>>>> +	return false;
>>>> +}
>>>> +#endif
>>>> +
>>>>   #endif
>>>> diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
>>>> index b668ce8d68ee..10e770bcee0b 100644
>>>> --- a/kernel/kexec_file.c
>>>> +++ b/kernel/kexec_file.c
>>>> @@ -28,6 +28,7 @@
>>>>   #include <linux/vmalloc.h>
>>>>   #include <linux/dma-map-ops.h>
>>>>   #include <linux/kexec_handover.h>
>>>> +#include <linux/cma.h>
>>>>   #include "kexec_internal.h"
>>>>   
>>>>   #ifdef CONFIG_KEXEC_SIG
>>>> @@ -691,6 +692,7 @@ static int kexec_walk_resources(struct kexec_buf *kbuf,
>>>>   static int kexec_alloc_contig(struct kexec_buf *kbuf)
>>>>   {
>>>>   	size_t nr_pages = kbuf->memsz >> PAGE_SHIFT;
>>>> +	struct cma *cma;
>>>>   	unsigned long mem;
>>>>   	struct page *p;
>>>>   
>>>> @@ -702,6 +704,16 @@ static int kexec_alloc_contig(struct kexec_buf *kbuf)
>>>>   	if (kbuf->image->type == KEXEC_TYPE_CRASH)
>>>>   		return -EPERM;
>>>>   
>>>> +	/*
>>>> +	 * The next kernel runs from here rather than being copied out, so it
>>>> +	 * would declare this area again from the same description and release
>>>> +	 * the pages holding its own image to the page allocator. Only an area
>>>> +	 * this kernel placed itself is safe to use.
>>>> +	 */
>>>> +	cma = dev_get_cma_area(NULL);
>>>> +	if (!cma || cma_has_fixed_base(cma))
>>>> +		return -EOPNOTSUPP;
>>>> +
>>>>   	p = dma_alloc_from_contiguous(NULL, nr_pages, get_order(kbuf->buf_align), true);
>>>>   	if (!p)
>>>>   		return -ENOMEM;
>>>> diff --git a/mm/cma.c b/mm/cma.c
>>>> index a10ea37a261d..1f4d3d48a3bb 100644
>>>> --- a/mm/cma.c
>>>> +++ b/mm/cma.c
>>>> @@ -55,6 +55,19 @@ const char *cma_get_name(const struct cma *cma)
>>>>   }
>>>>   EXPORT_SYMBOL_GPL(cma_get_name);
>>>>   
>>>> +/**
>>>> + * cma_has_fixed_base() - was the area placed at an address it did not choose?
>>>> + * @cma: Contiguous memory region
>>>> + *
>>>> + * Such an area is described outside the kernel, typically by a device tree
>>>> + * reserved-memory node, and so lands at the same address in every kernel
>>>> + * booted with that description.
>>>> + */
>>>> +bool cma_has_fixed_base(const struct cma *cma)
>>>> +{
>>>> +	return test_bit(CMA_FIXED_BASE, &cma->flags);
>>>> +}
>>>> +
>>>>   static unsigned long cma_bitmap_aligned_mask(const struct cma *cma,
>>>>   					     unsigned int align_order)
>>>>   {
>>>> @@ -304,6 +317,7 @@ int __init cma_init_reserved_mem(phys_addr_t base, phys_addr_t size,
>>>>   	cma->ranges[0].count = cma->count;
>>>>   	cma->nranges = 1;
>>>>   	cma->nid = NUMA_NO_NODE;
>>>> +	set_bit(CMA_FIXED_BASE, &cma->flags);
>>>>   
>>>>   	*res_cma = cma;
>>>>   
>>>> @@ -517,6 +531,8 @@ static int __init __cma_declare_contiguous_nid(phys_addr_t *basep,
>>>>   	}
>>>>   
>>>>   	(*res_cma)->nid = nid;
>>>> +	if (!fixed)
>>>> +		clear_bit(CMA_FIXED_BASE, &(*res_cma)->flags);
>>>
>>> Nit: This reads a bit odd. cma_init_reserved_mem() sets the fixed base
>>> and then you clear it later. Wouldn't it be better to just pass the
>>> fixed boolean to cma_init_reserved_mem()?
>>
>> Actually, we shouldn't expose cma_init_reserved_mem() at all.
>>
>> The current callers of cma_init_reserved_mem() should be switched to
>> cma_declare_contiguous_nid() that does sanity checks before calling
>> cma_init_reserved_mem().
> 

Thanks Pratyush and Mike for the review.

The switch from cma_init_reserved_mem() to cma_declare_contiguous_nid() 
looks like a broader CMA refactoring and requires additional changes to 
work correctly. See below for details.

cma_init_reserved_mem() is the entry point for memory the caller
already reserved, while cma_declare_contiguous_nid() is for memory
CMA reserves itself, makes the split read as intentional.

Run second time on memory stage one already claimed, and
cma_fixed_reserve()'s guard exists specifically to reject a fixed
base that is already reserved, so it returns -EBUSY.

fdt_scan_reserved_mem()  → __reserved_mem_reserve_reg()
→ early_init_dt_reserve_memory() → memblock_reserve(base, size)

The CMA initfn runs in a second, separate walk much later:
fdt_scan_reserved_mem_late() → fdt_init_reserved_mem_node()
→ __reserved_mem_init_node() → rmem_cma_setup().

Mike: If the redundant caller-side check is a concern, I can address it 
with a separate patch in this series. v2 would then look as follows:

mm/cma: drop the duplicate alignment check in rmem_cma_setup()
of: reserved_mem: keep the reservation when node_init returns -EBUSY
mm/cma: reject CMA areas that overlap the kernel image
kexec: do not place the next kernel in a fixed-address CMA area

However if you still think CMA refactor is necessary, please
advise on how should we approach to fix cma_declare_contiguous_nid() for 
already reserved segments.

Thanks,
Radhey


