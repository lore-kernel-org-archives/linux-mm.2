Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 442B9606D808
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 12:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=selector2 header.b=bDt8cX+P
Received: by kanga.kvack.org (Postfix)
	id 5F9636B05B4; Wed,  4 Nov 2026 07:01:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A23D6B05B5; Wed,  4 Nov 2026 07:01:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 491606B05B6; Wed,  4 Nov 2026 07:01:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 205066B05B4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 07:01:38 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 87A0BA0725
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:01:35 +0000 (UTC)
X-FDA: 85397296950.27.9C8F0C3
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11020088.outbound.protection.outlook.com [52.101.69.88])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3CD122000F
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:01:32 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=bDt8cX+P;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of khorenko@virtuozzo.com designates 52.101.69.88 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793793692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NkhsPTWded1eSTF0X+YMyw2xIxsyUU8cDM+BAy/OvQM=;
	b=MgPy02a3cyc2nBRM+ips/22jNXcWbI9vwcui9/UdfpP38txBBGkf6BSnG0OFCnBB8fd6Cs
	k67DOU+yJ/VgKF8ku+duV3sqCe5qpyFC4yUd52kRIySVIKcREnTq/WSk7sC3glPIOfF8vH
	4eDSiuBhHRTv7x5fgm7pP/E853ZcxKk=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=bDt8cX+P;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of khorenko@virtuozzo.com designates 52.101.69.88 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793793692;
	b=TcjHEj1EyjwkW+FBd0SazaSdnnNyb4Vf70yvBbOrNdWgi1sREG16UxlbRj2YVRGCN7bHfw
	SPtdYDHzJzkTu4ic6N622CD/2XW7b0pdXz5w2chzGZLsUURluQT2hFcprYgEvFyIdkF9Yn
	rEgiZRng0DumB9PtoFqUjFmFA9tcAsU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AdK3o+pxNalZwAoxmkVnqECOccVHZ3ljqezswQVM7gTu4+hOBGIkcpKKLXqW3b27xukh8UeMQJJG1W8cnq0DsjyjK0A6v7EKNMn73lIntXCUzUbWmj9YqTyNLOJl+1X/aDD+57ElwEz4WqspQzzsM3yzvUa/G+PIdrzdsTh+p4iGDdfVrmWzTXTAPtzl287qL5Ud075K1+R75F4ubAVg+lMNPIGAowr/1KX1PIbF6U4Qc6Lz4+sp6d6Ts9qvfBpRFXRun2vHIlMJrGRsPvusV2w5OxdgstW6HXe7vHBT8RMQhwb/gLPM9dcu+GHgtoOoRBEUxv+OVv4q6vzRXyiQXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NkhsPTWded1eSTF0X+YMyw2xIxsyUU8cDM+BAy/OvQM=;
 b=JSjLD8I2YC1GzvIZaEgY8kGuvgogrI9cznDC6tKR2Ste6CsWYd7F/ExB2ZoBe1LOmdKIPzQNFjyhM+Z27zGqxcozS64RHiaOLKZmwyUV2OiB+lkFDQb3S5mnxcliNmcvZVwYZh28VFvc4SYDktyt8uKE+RFWh7JB7z3jVtDpyAOw3tciIz3FUBV5WAzHJJwvA7ligaHaB2pzt5hkGQ8I2v1lUhHmz2yHx+DsvsR+FtkOYcTF9H9gMojumCk7UFRsd4IS2kN7u28w8bhweWqFv5ZglanZd7x2xozomMa2UarQNP3e/xTHruPvPDBxS5jSjis3HlV8DiQwdOqMpglDpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NkhsPTWded1eSTF0X+YMyw2xIxsyUU8cDM+BAy/OvQM=;
 b=bDt8cX+PaRAb+lbAjTuVrvQoC0TxJXlPLsjA/l1gERtw3IAW3G08jIw7SfSV9e/e41twuCdX4DOjjhun2RhwKwsuF5fHBED4IYKpdt+yWCHRmcnoDtk1+fBWylGDLLHpF5MU/NsHA0Ih96JbiX43+D4JldDS02LxInUJ85RTAk7j5MIrwMd0DHHrbh7PjFQcXKsCJOzQsD11oEIfvU4ttpHgbWAQP10nIPQScIyWgDjAr6ZfqjOKWJJY5uXc1+2s/hAoxRMaBxFE/CrZBTglIpoyUbibjqclb1hCvJe8qa+KL6KVcyIJS+CHgdrs4QLc99I1R1bpGpZMXq5oBaP/BQ==
Received: from AS2PR08MB9075.eurprd08.prod.outlook.com (2603:10a6:20b:5ff::9)
 by AS2PR08MB9871.eurprd08.prod.outlook.com (2603:10a6:20b:594::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Wed, 4 Nov
 2026 12:01:25 +0000
Received: from AS2PR08MB9075.eurprd08.prod.outlook.com
 ([fe80::3f57:9ced:7a37:1bd8]) by AS2PR08MB9075.eurprd08.prod.outlook.com
 ([fe80::3f57:9ced:7a37:1bd8%4]) with mapi id 15.21.0592.007; Wed, 4 Nov 2026
 12:01:25 +0000
Message-ID: <7e5a6819-9e29-4187-96ed-f716befc2bc9@virtuozzo.com>
Date: Wed, 4 Nov 2026 13:01:23 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/4] selftests/mm: test fork of PMD-mapped shmem THPs
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Peter Xu <peterx@redhat.com>,
 Alex Williamson <alex@shazbot.org>, kvm@vger.kernel.org,
 =?UTF-8?Q?Lo=C3=AFc_Molinari?= <loic.molinari@collabora.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Shuah Khan <shuah@kernel.org>,
 linux-kselftest@vger.kernel.org, dri-devel@lists.freedesktop.org,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>
References: <20261021-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v4-0-66f00b7a564c@virtuozzo.com>
 <20261021-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v4-4-66f00b7a564c@virtuozzo.com>
 <auC4eUEN52PJF1bM@thinkstation>
Content-Language: en-US, ru, sr
From: Konstantin Khorenko <khorenko@virtuozzo.com>
In-Reply-To: <auC4eUEN52PJF1bM@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P251CA0023.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d3::20) To AS2PR08MB9075.eurprd08.prod.outlook.com
 (2603:10a6:20b:5ff::9)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS2PR08MB9075:EE_|AS2PR08MB9871:EE_
X-MS-Office365-Filtering-Correlation-Id: 02b321d7-78bb-4d9b-b60d-08df3a6b59d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|7416014|1800799024|18002099003|22082099003|261102123227099003|4143699003|10067099003|261021121427099003|261022075727099003|56012099006|261022105027099003|261026140227099003|261028144727099003;
X-Microsoft-Antispam-Message-Info:
	9X6/ebo1Cyv1x5w6+PrF1KkjdYac1aMASsA6MRFeRzpRyZMBXQUmXM93wPAznWSlqePxXhqnTJ74yIiSEEgvBFbcC+a2uJGTSwYFNCwTH7J0PjVhW4nW5fwiQRyV6wn/q1EpGmTXzyORXWtcjq0XiEaLMa0xDJJdzmZvwuOaShTh5L1hXEETyF3eAQr2teeklkDmxY5CggCE6MV+onL+EBvTPE+HHwRskeisolk3gL/MjkYd/7aOrWdtGhgONHqLljcz9f8LURysAFlWclBSlC/ZJV1PaQRYlvypgQYQ+LR5zaw4qQhWVAvtfqIzwM2bgkB8rfmppe5t3JvoF5l4KwMpH2a/7psK+jHI3mNWGrrvHMMXfrQmyID+HjwG8kvzF84MncP6mKgfM5ahSUdBZn74aAEavukD/QvWzf2Fe2xvzOR3O3vqyGVIJj6qHn5HzlNm8OFsNtxxKkT+O1RZNVgjpNN5IpQaHwgGHfTbB7m2TWifCyhpe3rve10z9JmO15tN5YyspKVdx8zk9DPn8lgtSFr1TCV7RYevmQ/+DAfONqmvT8z4eB0ch5439v4mnyzIfrLgH8Km8tvJaCc/BTnx35w75QeC2ppSTCCguurvkpvjCTsDJ9Vr5gz5S5cGgPqqfB4nuXT5HccGH6BrecBpbxNWxwujpkqurlYdoeQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS2PR08MB9075.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(7416014)(1800799024)(18002099003)(22082099003)(261102123227099003)(4143699003)(10067099003)(261021121427099003)(261022075727099003)(56012099006)(261022105027099003)(261026140227099003)(261028144727099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V2FzeEEyb0hnYUc3TExoMUJTV0dEdDRISllpY1NLNzc0b0dOUFRrSVp1TXVP?=
 =?utf-8?B?d1J3LzBadjZ2OHFnNFYrMzlteVNJd01LbmNKMVJ5eENhMXN4VXJHc3VBZE9p?=
 =?utf-8?B?V0pjK0ZrWjJPZmVhWEVtN2luT21FMEJnSEk4T1RCUmtDVXZwMUpVWTd6a3kw?=
 =?utf-8?B?NGl1aDVzT2lGOTN4cjNMQnJ5Q2o1ajV1b3NUVmVhaHBjckFGN012ZXlYRmVt?=
 =?utf-8?B?cVZVTXFLUU8vSW1MNDF5bVJtSy9CVnU0VHgyM3o1Z1V5ZWEzWWMwNGtJUXNa?=
 =?utf-8?B?YjNndE9QeWl5SG9oUmV2WjRTUzlMaDBCSjQzSVdVZThGWEt2Rm1pQXZjTDJV?=
 =?utf-8?B?VGJ0ZzhRdjNNM29yYzJzdS9WcEVXL3JjYkZlK21EUnlRdHJTdDBRamoyUzM5?=
 =?utf-8?B?ZE4wYnQ0Rm1EdGRjMUdiNWJkM0NCZUVRMXJNOTlVdC84ZHZqckl1ZlhYWGxB?=
 =?utf-8?B?TllvVXhDV3Rubi8ycUdrTkJmejI0WVBFSXlrSExXeTNac3VQZlVWNjZUTXYv?=
 =?utf-8?B?WHBSMDF4cEQyeUtKNWtKNEp2UGhsWlZIR2RhdTBHbVlCNUdjZmt6Mk9KcEVi?=
 =?utf-8?B?SGpYY252K1ZNajZVRllqazhZNUFuakNjOVdFSXk1UElncmtCekZxV0xER1pH?=
 =?utf-8?B?cXF3aGtvOVk4WWF5SHRUSFhWVTBDdnpDZU5NaXBkNnlKYmZ0bEpJelhkaVRk?=
 =?utf-8?B?MW5JcStsNnkwaHVVYWdidlpSc1FsNEg0dmx4NkNsYlRnMzlmSDV1OCtJbHlp?=
 =?utf-8?B?dWtMOEc2ak85aWJhOW8vdHdFMldwQXVleUhPalY4Ukpad0l2a3AxclM2RTdi?=
 =?utf-8?B?L2tiM2pYdTNhYTZDcmlwN1c4TTlKNkNwQXNCWDZQYlFmcWx1akIzTjNIUkhm?=
 =?utf-8?B?UTBKbzJNR1UxZnNZbGZ6KzRJRDdXK25UOEEzbWZkZjArTVEzS2x3ZzdEMzZL?=
 =?utf-8?B?WHBUQjJ0UWQ1ZnZwbEI3VEpjZlEvblhHc1ozZDdPamMrdUVITno1d3VzcFBn?=
 =?utf-8?B?bzQ4NnJZTkpXZWVyQlRISjIyZmlEZytZSmNSeVpzSTRnelRUK0dZRGRzYmlO?=
 =?utf-8?B?RlNDVWNIMzNmVTQrWS9kRnUveCszcWFCeE1BV0VTZ0RWU0ZOVHFIdjdzb3h1?=
 =?utf-8?B?U05PRHRlNWNOZVNXUVFJRUxud1FkaDV6ZlNMUTEvM05pWDRPcTNoeGVTSGI0?=
 =?utf-8?B?cDhwT3RRVnk2WnJvekdDTkJJZ2RQOUJ5NVBFZzF6U1dUU2NnWFBqVDFJcU9G?=
 =?utf-8?B?RkZuVlVVci90eUx0a2lGd2FmNldzQUtMdm50ZHBEQ3FIYkMwUlNQaUxXUEVT?=
 =?utf-8?B?LzdwMVRNOHFVUHhhMWJlZHg1RGY2Zmo1TExydlljM2lPZGZ1YlBqMEVmNC9S?=
 =?utf-8?B?WThObDBKMXVobk1YemQ2c2RCbGJOMDBwWXVXcGpDYmt3VEtFZG5WNGtQbVVp?=
 =?utf-8?B?cVJIU1dTaWprMG1aRzZtMDFjSXAxM3ZIb0trOU12OW1wRXpxNThYV2J1d3VI?=
 =?utf-8?B?NTVSVWNRSHh0Umx2QWREVHBCVElIdnNCWCtKUVNMQzBQSHNxZGRZSjhNY1oz?=
 =?utf-8?B?eGN3NGJCTnVEdVlZa1ZETlhCb3VBNm9Bc3FuVzc0U29sMElRZTNaR0FGbith?=
 =?utf-8?B?SU1hZ2svZy9TK0tJTDVmWFdwMXZaSmRYaUdOLzhaL0pGTjVlOXlBdFNzZDBT?=
 =?utf-8?B?cE5GeFlHd2R1VllEWUZQSmxxTnppdWhkTHM0MW14M1Z4djlOQ3JxNnpRaUhP?=
 =?utf-8?B?bVpOQmNYNHRLL2RMcWo4T2ZZYlQrMFRDTUhnaURJKy9ZUjlDdDhpang3VkZp?=
 =?utf-8?B?SW55L3J4STlCWFZ0NEZSc0NEdTcwZ2dYOHNoM3BSN05MQ2lDNHg2cmhzY0RU?=
 =?utf-8?B?L0h2NjRqYzRCRE45bkhHTXdhTWtLTmhpeWJQdkdFbUd0Qkh3d1RaQ1VkNlpP?=
 =?utf-8?B?aGIxcnNFd0tWTytuWDYyeFR3VFJFbzdiK0lTaGM1T2ttQlByUjdCS2hvVEYv?=
 =?utf-8?B?V0sxTDJ5T3BjRnFvTmJvRndGWHM4RVFWSjFXd2NRT0M5RFpxYThTQXhKZm5M?=
 =?utf-8?B?STFTc09hUHRabHMvRjgxc2VPdWpiTlkvZEY0VFI0SHVQcERpTUc5OHZIMkJB?=
 =?utf-8?B?UjZuSEZ1SXROa0MxM2hoTzVsSzk2Q3czcXd6OXUySGNRMTd5cGJLN3ZuU2JM?=
 =?utf-8?B?N0R1a3hHTTFXSkd3cHBaZGRkS0dEQndVcjB5c3FDeFFTSUV6elhxVnZwK0Qy?=
 =?utf-8?B?clFKajl5YUdqQmo4eW02NzZMOVRaZU5QQS8wbmp1L3lzSktnRjVMeUdSWnFv?=
 =?utf-8?B?bERqVjlxbHBhaU45TStTelh6dlJzckc4SnhvZGlxMFhPdXUyd3Mwdz09?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02b321d7-78bb-4d9b-b60d-08df3a6b59d5
X-MS-Exchange-CrossTenant-AuthSource: AS2PR08MB9075.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 12:01:25.4049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cjJN4N2vaHqRMIuNpuGwpTBNC3tVp1MI2lliGmq0U09d4/MtAoUx64gNYaCqRlfun+cOuofKxXtji08vMaCIrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9871
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3CD122000F
X-Stat-Signature: cciu1w98hopa6s914jh15gnywd18gntf
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793793692-873026
X-HE-Meta: U2FsdGVkX18dulbsqwPL3om2S9sFXYhxcVxok++7r93tCiTN6kiukle6fATsbUO9lYrigVh1e8WIaWFEGx3fSYZlml7PqzVHu4Gf7JNnCPAnZxu4z/9CtbDIOg6ZBPGm879801RIsu1RhBI1orV5paHn0CQpanDBvXKPYOiZGb9t4/AXCKE1Hne66oLLa+nUATUnrzAXmQgx0yCXxeqMcQ7bI/AkgmaNYsgt9pbS64QuzpTKYKs4AWEu4fl1UHk04BU7VcghBITpOXwbeiYZhSqO9A3BIrx+1VKqE9AEcZrAqnyU3kednFpnTSqL9WBPNadSfkI3fm9QZY4NVq0lPWstKQhPjTry/8TLkMceFV+mJ1TzOZL2vF2MzUzTHCaSanmsWscHEO8EphQSv+Ep1qKwacQ0XGFSuomEgXMODszLQlpYlMJO9ismfgvu1TkBtfo5ii7HWWJ2pwaX6Vp2vvLV87I3zb+SG4useaB1CZWMyBqVO3AdfZaLEsNR7KN97jB0gLKG7afcnZ/xBcyh4UuIkQMyQtrme7LBK8pOmwvnz9v1JPVcEEsBUBN8bUGvpSBWocY6b3qbhWVRN7CFyT0ch1eUJ4G4ZIBx/Ss2L81Cf5j3SSaWuEAAFfn4SYLDGBaSxCf576jeQRQoj5T5TLcq8yFZ7LkfMxKoDkBDjECetFjffc+5gikEa2qo/iN1kYd3bTl9MtUQb5DPuS5cfiKfHynmJo+WrTCiROuKaC/JJSogKoy7c9+haBQdrc7fZsi8Gr0LxVHTP2p+H/80c9auJojk9vpVKUgv4J1zlT+VxDPTWATrnTQj45F0XLK2tEnX3xYcOnWe+/SZ3w3ePtOkrbAVhsBDMF67ekJQCAAVxR7LYH8rizalsisi/+LLUmMbad1DkLkd4Fm78rEBKcDgvkggQuZ9Y90El8nCzMFwZQmGo0nHEJfSiDGyRovoYpCuBJhkbo1k+dFC9C9
 ifBTHREJ
 PDXAKTEAD0x6OIQ1a0+6ihxse5zsT7v49cz7RQwK7W/kU0ZQ9EdMM2RgElypqaGjxYolFq4EyU69wmepDRKDyERAYrO/7MHeY/Afe0xAe1lE/nRsuYn9whhyildBJ680LWvBN+nEAdDEjAGWZdpIO8hdzHOxGPW4IlZgseP5F8hcuxfTuoyLCox/lDa0H17K5IHx1VvhKKTgHTUHa0maInUdyg8eemMULWXuDLJ168HFtjdj+IeaBhiuwd+yqSRT8AOoXwI0bRP3sGmxLCFnoDh1QYBOQubqOfGPs5hIuS1c1oqILOZ5w0F51E/wtLmjcZAtPWXpqYCGQosenF/sCunyeELoxH+rgdv/oEVFxMQqyUhPYW2m6M+LCISttlkC8879hGn1ny0xdI2yK10fAsJuoVPmiqgR4zmytonMqnerCd9IlohILLJgz5SnUNWfkTA54mtbNggSUTPvcxf5/nM3GLe/aZjnGKWvibR66+BCW1CjlXentpcGEdKOLj1Iry/k2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 15:51, Kiryl Shutsemau wrote:
> ShmemPmdMapped is system-wide. A drop of 'own' or more from another
> process between the two reads fails the test instead of being retried
> as CHANGED.

Right. I'll send a new version where only a drop of exactly 'own'
fails: that is the parent's share the bug takes off the counter when
the child exits. Any other change will be retried.

> The parent's THPs can also lose their PMDs during the test: reclaim can
> swap one out, and NUMA balancing can migrate one, which leaves the
> counter low while the migration entry is in place. That gives
> FAIL_COUNTER, or FAIL_PARENT from the exact count in check_huge_shmem().

Right as well. In the new version the parent will check its own PMDs
before it looks at the counter, and a missing one will mean a retry,
not a failure. The same will go for a child that finds no PMDs because
the parent has lost them. Only wrong data in the parent will stay
FAIL_PARENT.

Each retry will start over with a fresh file and mapping, since the old
THPs may not come back as PMDs. The test will make three attempts. If
all three are disturbed, it will skip and say which way: the counter
kept changing, or the parent kept losing its PMDs.

Thanks for the review!

--
Konstantin Khorenko

