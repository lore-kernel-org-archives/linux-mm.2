Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A049C982DA
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 02:29:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40DDB6B00F0; Sun, 20 Sep 2026 22:29:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3979C6B00F1; Sun, 20 Sep 2026 22:29:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 238D56B00F2; Sun, 20 Sep 2026 22:29:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EE7856B00F0
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 22:28:59 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7C998120558
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 02:28:59 +0000 (UTC)
X-FDA: 85236186798.07.220CFEF
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013012.outbound.protection.outlook.com [40.93.196.12])
	by imf20.hostedemail.com (Postfix) with ESMTP id C1F451C0002
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 02:28:56 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ZOVkBU4A;
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.12 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789957736;
	b=ydyomrRc4QhaUW9EkmwUmpxiQbKFr8oFMkvr2O4r5YUKNEqLJQdVncga1bPMXFyDpkvxMD
	rQDEUldJQCM5BmPthPmX9btO5HbYfiXephvgenejU8CZxRwq6zah4VGPgAnVNhNcJHbgZu
	Cy40T9Y9T3wvGWND1lKAxyd2rU8ktZY=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ZOVkBU4A;
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.12 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789957736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gE+dUqOVElC7Qi7wE7rqVZdB6jHHbDkbmlZmlE4IKTM=;
	b=LyltASqG2skA+WbEXfJht/iueEWAEtHoO3NRcjw/BQFhAqQsBX/T0RQxO0VQJyynDjiQ1U
	gF8TvZF0iXRHcwKrkrbtoSiSzSuTfh5wh7vJ/UFPObeIkuLKOfzmiVQkyBf0hSy2D4Ovch
	YR5f+KhBBfIE3FfZFir+ZjcXLNkXfyw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p4oG0TjHmrq6Wo4RLL/KqwdOMCMuni7ZeycU5PtE0aiVo9Ct1zVJ2X1uZ9WMD2YgZLcFQKIZ9RFs2L8K/tQUTdg9ZefG76XvviE2LeHqof1mlk489FuIjqDKYzPeyFTtIam1t2mHGrLrOm+3nPf3/I6d4miSTHhUz/Z5rW+oRE9L8QfJDCtShZ4WX1ZzkM78BSax9FTEUPhRhZcXAIwacfsLO1YlB1F5Xq1eei+h1qbufBgX/z9T9+x8mxgEvmjmwXuc2bEg3hS7NBm9MvOt1NFVLkYXMqyLTul/kw6XXTaNlmZsy8UEmwYVgD7o5IaXAbd04N11t7bBWwGiiKA2MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gE+dUqOVElC7Qi7wE7rqVZdB6jHHbDkbmlZmlE4IKTM=;
 b=qprwk0I+vYhGPtxy+xuEIcK13Mb+l/hIoE2F+796QUViIAdKHCz8k96Gi/BOmR2C31P+QOH3i90CJXxtrXPmOus7s/fi9LkpTmDKuIAbk37j3vMrVJ/+AQ196fd0QK0a4tjsmmOXthX6RDttgKTOzkOKsPFL0123pXYaQEvxVaVUbstWoUluf7N7YteCYYN5861A4s08L2Iag5EbsEjLfGlPe2calhKtrDTMJA71VFFTJA3EN6TBHnH61FcvyAB1P6JLbnS2mrVu9Tq06kDfI0VcVSZNHtWv6v76kid+fQHezfzXHZnCT7ohXyZDhdrFgQUECQnO3Nbokmdl07iwkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gE+dUqOVElC7Qi7wE7rqVZdB6jHHbDkbmlZmlE4IKTM=;
 b=ZOVkBU4AqOr7uG7yFO9py1m9yG2DSpblKT7CAi6OnvqVu/rqr1u7hxnUceY85pCYUWZW9kx1+dfSnKkatBd+XzcOJ4XAj0Z//vAE5HP9fpSnPSNkMFAXAk+zx7yZYR701jVTMBwZIQ3m1C94w8dF9LIhaAdCF94kVSBVtyh1jcEdh7w7naycpyITofulIoONm2+It6QWcJbxodtfgMc/b18onFjr+0x9dBtmoX4dvk0b9Stbp2G4octMdtejKcPpP2r1GBYFVqFPjElyKqkCO55F7MgsYlDOZkaZDfGgGXdCxyh+kYLN1sZUvImIq/lxkiGs2/bCBaGJ57mgAtuDUA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM4PR12MB7719.namprd12.prod.outlook.com (2603:10b6:8:101::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 02:28:42 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0428.014; Mon, 21 Sep 2026
 02:28:42 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Sun, 20 Sep 2026 22:28:11 -0400
Subject: [PATCH v5 15/17] md: Remove the last use of page_buffers()
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260920-remove-pg_private-v5-15-bb68b6a21869@nvidia.com>
References: <20260920-remove-pg_private-v5-0-bb68b6a21869@nvidia.com>
In-Reply-To: <20260920-remove-pg_private-v5-0-bb68b6a21869@nvidia.com>
To: David Hildenbrand <david@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zi Yan <ziy@nvidia.com>
X-Mailer: b4 0.16.0
X-ClientProxiedBy: YQBPR0101CA0286.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6d::15) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM4PR12MB7719:EE_
X-MS-Office365-Filtering-Correlation-Id: 15bcc0b1-9bb8-42bf-734e-08df17880d83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|366016|921020|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	ASATcLXi4FD7gOLDjN7NFQBtShj9y/DIJqyDigxVOyQt32DV2qkGmS5UoRAfrJHNogUKmGTzomIb8ta7JRLaA8v6wRmp4OzzIvlHhXkEkLaWs9XI2/h1TKSpMjqqIyg09awPziTKp1vbd6Vc7PXcNqZ3AAZjM1IojcXwFe6u6AQHIWoRSpB1drk+0KbIYnp5RXA5Y3lMKiD5HreMZ6+L8W37M7gh9VNo2SOytJ7820TFq+MhM5ZybFfNTNVv8wq59caNx+amGOWyDLiCoy6iZjk9au0tN3AfrQjurzyWeZU9eaWnPGBldzRzIeMHWwFfaE4C6tAQaSEpk/WZ3UtHmdrZxo0NqI+L2ZDXxQlSael5VG+J1Md7elKpJX7YtacGBkRDsboxkaZrhFyPZLu81lI5PoakaHek6W1NOXN/R3zjtpIO7e9zGH3BSWkxT17NLDapwLsUyRj2lAjYz9HWDW0uV0OY8eUSmTVhVfFjrWjfj5Z4pOOMkjo/FtEALiEDPVkrL/Pr+qRMcpXabVKdrj72Aof0BNFgR0IyXuiO4Et59WGliItnkr4QPgLqSvKrBhzOCM2NAAtrclfZ6piq/GmUHc0Tv7You5Z4sszqoCbXSBcGtYSP7Ht4wRnYBRkb2KBJIwxp+L5HRO7siXCtxnYrYFr6v1xanFaFuxS1JuRi9fXYyJ6Hk2GwPSORDm4axGtXA1Zk37lZ8OUyxzBw+Q==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(366016)(921020)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TVpaSjcwNGp4OTYvMVlOVVJMN3JNYlVEa2VYeWxnVFd0SDh5U1R3Wm5wTFpZ?=
 =?utf-8?B?RHNaQ3V4RFNnczJ6UlBkaHdCc3U3N2pvOU9JdC80UWpGTkd1d1JEaHJtNHhF?=
 =?utf-8?B?WEdkSkpyalY3WGdZcVVrZ08zeDlsTUFWYjAyTU11VG9JNzhRWDh1YlhNSGtw?=
 =?utf-8?B?dVZ6cytDNzVNMmFpK2xHWkRUK3NteXl6Y09LMzlrK3pCQkgyOVdhMEFTR1JF?=
 =?utf-8?B?VGsxanphVWNqYkxVUnRFVjR6cm1aU2xBa2ZtLzl0MjU3WmROYnVuU0JPUVFO?=
 =?utf-8?B?bnVzWkxqVVRWSGRDRU9TVmVSRThua0xGZUhTb1hlU3o5YTV6TENqRzdpY2dy?=
 =?utf-8?B?MG5JVWFIMkRuR0Y3aUwwSGVXZlhqOXZrV0tQNTN5d28zY0VIMDBmRzk1Mm4y?=
 =?utf-8?B?Y21OMFh1L0U2TkRtRXkrOUhmbWlwdDlSSVpJZ2lyNG1tcjdaRytFTUd3ZUZE?=
 =?utf-8?B?NG4zdGhJZ1lLNWtaME92TEw3UFg3WXdnZk9wS2NZbkg2dFZDVnJSaWUreW82?=
 =?utf-8?B?Q3JETEVKcnlDaTU4R292eGJ5eFp2OURjc0hrV01wK29EaEQza2JpTXErd3Nm?=
 =?utf-8?B?UFlGZHFITlZJTEZLc2dJTk5IVHJtZFROU2ZtUi9kRHg1bDNBdXBORWlITVha?=
 =?utf-8?B?bTI2Ync4d2hMN0lBTThMbUVNUE1Ib3UrTXMzMElVYithcU5OS24xbEg4MDJY?=
 =?utf-8?B?UFJDRzlJeS82Y0cxWmV2N3hxcnlmR093R1dBVUNHMnh4dVlxYXlQbmtKNjEy?=
 =?utf-8?B?dVpIc1hKK1ZyenFpU1A4dXViQXE5cDJUbDR6dXkyZk1KSEp5clpaU3ZNdW8y?=
 =?utf-8?B?WjQ3WUdsRjVQWHJETnFDbk82RVZlOC9LTEhvNk0rNFYySFFjNDdzTTBhUU5i?=
 =?utf-8?B?ODMvanNvT0VubVFsMndYcVBCVVRTelRIUzlpVE9xd1hzeVA2Uks1bTBjN1Yy?=
 =?utf-8?B?ay9kK0hYZkxIaUFkOTlYVytjWUMrbTRYbkZQNzhuMEhDQTl6eFJrOXlzbFNa?=
 =?utf-8?B?enpMRTcvWlU0TlYwRjNOS2J4dFdJZTZnUlFWUzdVb0ZTZU1zV3R4VGpiTUpD?=
 =?utf-8?B?UUVpbFVFUk55ZlJuVExIZTFsN2dMWVpNMlAxSWVOUkY2ZmJQNnRBTEhUYjhJ?=
 =?utf-8?B?QU1maDBTS0ZnVEY1RlpqbVlyK0JESWtOazBEK0VoTnE4cmE4ZWVEUHhhejdn?=
 =?utf-8?B?azZpcnRoVFRWMjY3N3IzdTZlK1BDMnNlRlROMzZzVTJOcFdIdU8wSDNKRFFY?=
 =?utf-8?B?cGhxWFY1ZkRFRWVUaE0wVFhGYzJYK1AxUHk1clpBejIxdkZtRVVkd2ExNzQ3?=
 =?utf-8?B?dDJNZU5NRHA0cHNGbGR4QkVYYXluTlJ4VmxnMzhpQVBPME03bU15OEpVcEN0?=
 =?utf-8?B?YXhRTUFnSXdWQVpJNTlnQkFwTm1JMEJxZ25qSUhWWDlIdG5FTEFWM3BiaUxu?=
 =?utf-8?B?UzlqTXV5Z3lMK1JZYlRaTEZVeXUyMEFxK2RFZHNaaTB5K3hDZE82REVqeXBt?=
 =?utf-8?B?TWp4Z2RTbW15eEV2cHJMTTMwRzJ4MGZVWnZTeEpFNWRuSWxvbkJnZGdQeENW?=
 =?utf-8?B?Y0tFdmVEeFBGQjhhTmtVMS9XNFBGTGNYMnVIMTVHWkIwdzF6UHlNcmFRNnMv?=
 =?utf-8?B?NUk1SkppNE1RT3kzU2ZEbVA4ZzJxL0ZTdm1oeWkvWnNIZHQxSmJ1V1FSdkZs?=
 =?utf-8?B?L2pqMFIrMlQ4RERzNnFwZCs0VklnU3pnRzJoQWpuR0Ziek5KZGxXSDQ4Ymh4?=
 =?utf-8?B?QWRSK08xOStwRHJUdWhRalV4R0R1bXhTY2F5T1g1VUI1V3Y1SVBBcVV2TEJG?=
 =?utf-8?B?L0MwdWZMQWRBQWE5ZW1EK0tVa053NVBOeGxQaGRXZ3dOb1hiUXpGSWkyUWlW?=
 =?utf-8?B?UEYyQnAraXlvZVdzRGlDQWYyNktWVCt1Z1lZNXA4U0c3cWdZWU1xM0IvSWQz?=
 =?utf-8?B?MUJTSGN0eWVQQjRyYkF1b0IyeVBNQUJTeS9CbzlnV1FwUnV1Vm01ZzRJNStJ?=
 =?utf-8?B?ZndxWXUxeHhBNldsaUZkdjF1MVJMZVBhMUFDTExOcTFyQlowQTZiWGZObXpI?=
 =?utf-8?B?RjFvSkRtd29ibzRaZjZ2ZHRaZm9hdC9ZbGhlcWtxR3VmaEpwU1QrVTZRampP?=
 =?utf-8?B?QU5ma3dtb2VMeWtkNGNJUlQvSjJKMlNwQ0FjVWNwT2NQRE5sREtLQTRGSzZI?=
 =?utf-8?B?VFoxbmRQekJQVUx3VGlETS9vT1FyWEpOODJIYzUxbkZPVHFQZFljSUFFOTVO?=
 =?utf-8?B?TDRuN21pWStGUVNGcWVUMmpzMWh0K1BxK0ZwTmw5Z0tjU1hPd21FNkVpQzdP?=
 =?utf-8?Q?5/Z/uB6x55CHhWC09Q?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15bcc0b1-9bb8-42bf-734e-08df17880d83
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 02:28:42.0554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +996EM96FBxu4353dXsuEXShs25ioSJpccpobOy7behgshVkqEPCBiX2h2MoUsNT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7719
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C1F451C0002
X-Rspam-User: 
X-Stat-Signature: u4exa5zi6pf3f8fdaeocayyoot9xjhz1
X-HE-Tag: 1789957736-847784
X-HE-Meta: U2FsdGVkX19IE5j7R8OvgsUquiNaxS8GwZ4mMFTBOUxH6A0QV2pctvIKWII1fcxVR3ObiJne6UpnXV//wngzkX9aDcPim2tdI7aXQ6u8KCxIUgW6lUYdWmhEmsJiURwDeNhtIen+LNsL3lOOuu+yRexOYIkEbKwKaZ0v3cKKZox6TErg7VcAJ4rZ73Tc9bGrne37ghFKvQyym9PMNrJSI/36EXaS3p1GTlOB9NxkOQaEO7f6xKAOa6WNvgEH+a/bUKe2GdBygemjTG5kjOkeJEVFhaerYRy6R7Qtppgki1LPtG8qO8uRU7G9eaC3SYMFZp+YIlVQfYBYO3cx9/YtyQyQF7ozJBjYiJLemA2qAU1bRkz0fDJ5A2maZRw3W4WsvKO4LPSOilgYL52ZdXbACskxwABIGzqPIqH1fv+oaaN/6Gh8loRDx+PWyVZxLxsekmEv0LsWMV9taLjKXMtBVDGMYZ7mSXlnaM/QNp4ywI95xPwOWUve1kjlQCTNVcCM8fBba5hzRlUcb/0pllxYiXhGN9DlDGLpfzN3+GkWjmAO57MXKuHCOh6a25jsUtQ1taxEFUmR8Pe9veNDeTWYePbXsm7alI4t9yWqevKNNpov9Pbm7pC7Aa91kr5EKpaO2lLvk2AYgf4j0bi3JxOUftpM6DBX/Lj1we4XufaYJ+uHvQ5YTnAjKCijl4r7VP8voDocsPaO5MfuZSG0FGF+JtL54nVSiIA6b7OwaKXYJ8O283hcgFEAKsJkV+iAfOZQs8PH8G0kddzNJTEgDRnV/AAQDlotKSYBSInfJSnTVdvXDOj3QRh0lVmiiGGhRvOgcuvYOAnEcU4T2XV9doC4WEJEmx3cfDab1j84P4k70bf2iM8ESAI5Pbm7yzl/CdcgAyrPCEadqrlY3KAPBk2h2bwOJw4gQhlUShW4aB+rH7DzXFUuJunwvuA7gIa3CjLtWX5e6KlccYETn1ZrNPZ
 2CIFEK0j
 2GLvc4obzPdSxtJrDxv5EhcL7RapKEP66MGVPN3KzORk+VA9JAMkSYsvWupvscc4uRzZMYpHMoH7K4SJryPtQvhdE5hTgns7vXwaiA9x3fkwYwSpeV7pUL8YJu0jVRwyTNXRf4ZRWO44hpppgzahmjTiUee1/RFPSLDadyqArCVN+0x84rYwzRWotTvS1FGZo0Se9gvMlwHpdiExrz29iLC03sgW2Z7gkgmkjW1fhXtV9xf7NfTnfJBfUzK7qbHyhtNtKEDCFNmNzsfAAlr71crGfWb7qzYlNVQX3MiJKPDcRHnsyyo/25bCehAqqeqzqtHz5Rd7TLJiEnPU82YLopZoRZeWVBVCmTP2iv8NsyeFWpeQVRPQutt5kNrpfchPpCq1RhxZ2rQFSjvvXxjssFalaND7is1SXSTCmAj2YlHgwGc9cdPVAUGpTf7/cr1ow9+Btd2UcPk8Cu0AASZIFlIjpo/Hr0TK7XTabPpoFq9WKjdyuFj+3VZOk7gT+jkz0smUA/jSyZrGE7jpJ/T7S0gfbDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

Convert the page to a folio and use folio_buffers() instead.  This
does introduce one extra call to compound_head(), but will simplify a
later conversion of md-bitmap to use folios instead of pages.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 drivers/md/md-bitmap.c      | 3 ++-
 include/linux/buffer_head.h | 7 +------
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 02a126968ad40..8adf6ddca3d60 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -516,7 +516,8 @@ static void end_bitmap_write(struct bio *bio)
 
 static void write_file_page(struct bitmap *bitmap, struct page *page, int wait)
 {
-	struct buffer_head *bh = page_buffers(page);
+	struct folio *folio = page_folio(page);
+	struct buffer_head *bh = folio_buffers(folio);
 
 	while (bh && bh->b_blocknr) {
 		atomic_inc(&bitmap->pending_writes);
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 6ce2db05c60f3..4b0b7188472b2 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -175,12 +175,7 @@ static inline unsigned long bh_offset(const struct buffer_head *bh)
 	return (unsigned long)(bh)->b_data & (page_size(bh->b_page) - 1);
 }
 
-/* If we *know* page->private refers to buffer_heads */
-#define page_buffers(page)					\
-	({							\
-		BUG_ON(!PagePrivate(page));			\
-		((struct buffer_head *)page_private(page));	\
-	})
+/* If we *know* folio->private refers to buffer_heads */
 #define folio_buffers(folio)		folio_get_private(folio)
 
 void buffer_check_dirty_writeback(struct folio *folio,

-- 
2.53.0


