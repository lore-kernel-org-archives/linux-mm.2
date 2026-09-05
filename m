Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 463BDC624D6
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 16:24:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 325916B0088; Sat,  5 Sep 2026 12:24:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D5AC6B0096; Sat,  5 Sep 2026 12:24:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19DAF6B0098; Sat,  5 Sep 2026 12:24:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DA6816B0088
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 12:24:17 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 54B42160357
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 16:24:17 +0000 (UTC)
X-FDA: 85180230954.11.25B305D
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011037.outbound.protection.outlook.com [52.101.62.37])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9388D100003
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 16:24:14 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ioCZhwWy;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.37 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788625454;
	b=EFChY0inmOagfBYVyVlehhxDAKiZ8pEjIEJSXFtxkrDA+DZlFteOusfRzIM5KE0xlMkcqL
	GG05Y7M50j1wXD0qZKeYiIrcAthmplNSWoBvf0lLq7YKbGEBKgaTMJrxFQaG9MnU13NXWj
	l9gE14Cc9z/l0uhFBV/OvxI8C1BWwK0=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ioCZhwWy;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.37 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788625454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=enkvX1acuDbN935agxC/YbowI0kGLhxOhnSaMtsFtA4=;
	b=5nXbG4+oVCOH+ypxmRmSan2zLAF/t8qs8NHn0f/rmViJaRzN8gEqpPJAlw3Low5Hv7TWDk
	vPqhr3c4AwqdlD+f0IvvxTnYkpT8pyQZ90SesTZXlSDaShg24ZCi5ZFtSaNgQdlmxTSPK3
	f5D3HEhejmv27eKfegPkpw24GWhed/I=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XVeAkfsWy8tF8ZymZPMDu11TnRxggMYTI/WfpAruallaPYX7WK5+8I7bKgEqXRvFg6k81SacJR/8waDv7gRIJjhmqk6bujjTRVulnuc7hGm5yv9Bhe1Ye8btDyL25RFuipFqht+bBxmYAU4yWrVj+9yYgMMNkPSRtJOcPh15rMDgUMGSZ/pkFGm/nxrn412cdWjTfWvgXrpKwSAi/fUKbqF0QmOhlDWOQacv/hfHxFiG9iv6Lka2ZOljf+yxpGAPX2EJl6OJBqRPQZvGUWPqB0t29WkZ6g9dYHTE1dpbYex1Ec3K3kqBSCdL2nrnySkRsro8Ja0vSY3KudZi+9mvKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=enkvX1acuDbN935agxC/YbowI0kGLhxOhnSaMtsFtA4=;
 b=oXtEmVv3EQnLvZE9qVfvm1CnKSFf1Ms6WrS3W2/l6kzi2Yq0R+tYf6ePQGdmhx8nBFul9Mse0vp7ft3xPN5dmYilyG3MDB8WGWf1Qeh7aX8lQOlY7BkvbCXGg1w4v/AEbXyFv6vSF1J6EbJmjvRv7ZGv/X3rnYLg5W9956Qso2NeV02561BJTEwyHbuXmNtcmmq1iDvzYJ8yIejVDzaH6jkkDijOPjqkMRf102TrXtfOCYREuJX8Gyf6j1taCOoJuqqML3Ayp03/JmWTbx/qxrdfx8mT4NBUdnXFae8XH3HTjgsjNU5khmeawXI0RDChlYSkjZky6PVkFH+nhFDT6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=enkvX1acuDbN935agxC/YbowI0kGLhxOhnSaMtsFtA4=;
 b=ioCZhwWyiPoS6RRRjzO8ONXsQynUCFhrjfvBALICT4piiBIcsTow8HcGjIEMcYyDpHDub+5IwzT8LZcJVvpvLLq4lF4duMiwi5geX5ZQzNh1P6XzhjMDkitss9QgFLvLydTekpC3GBXIAfagnonjG/qKph5/A1Af0yvftFCXLeIH5MHlBYwlFayvVoWlM+Hq2FViV8f61wemaqBiTBGyqEr/G1qS9YvuxBvrCwcrb8u27KpDzU9ncSPkDji3LVqk+GgVM8ShOYmVVtS5msYuQXtRU8G2D0LKE++a6ylTA5/cqiXpg7OJq4qtcZXdjFAwraOkg2wBVmM6FlKy44cWDA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by BN7PPF0FD1DEA27.namprd12.prod.outlook.com (2603:10b6:40f:fc02::6c8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.13; Sat, 5 Sep
 2026 16:24:09 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0382.012; Sat, 5 Sep 2026
 16:24:09 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 05 Sep 2026 12:24:07 -0400
Message-Id: <DL7ISZ2NKFSC.1R1X1VJPVOI02@nvidia.com>
Subject: Re: [PATCH 3/3] mm/hugetlb: fix various coding style warnings.
Cc: <baolin.wang@linux.alibaba.com>, <liam@infradead.org>,
 <nico.pache@linux.dev>, <ryan.roberts@arm.com>, <dev.jain@arm.com>,
 <baohua@kernel.org>, <lance.yang@linux.dev>, <usama.arif@linux.dev>,
 <kas@kernel.org>, <vbabka@kernel.org>, <jannh@google.com>,
 <pfalcato@suse.de>, <kasong@tencent.com>, <qi.zheng@linux.dev>,
 <shakeel.butt@linux.dev>, <axelrasmussen@google.com>, <yuanchu@google.com>,
 <weixugc@google.com>, <mhocko@kernel.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>
To: "Christos Skarlos" <christosskarlos.kernel@gmail.com>,
 <akpm@linux-foundation.org>, <david@kernel.org>, <muchun.song@linux.dev>,
 <osalvador@suse.de>, <ljs@kernel.org>, <hannes@cmpxchg.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20260905140140.60792-1-christosskarlos.kernel@gmail.com>
 <20260905140140.60792-5-christosskarlos.kernel@gmail.com>
In-Reply-To: <20260905140140.60792-5-christosskarlos.kernel@gmail.com>
X-ClientProxiedBy: YQ1P288CA0015.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:9e::13) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|BN7PPF0FD1DEA27:EE_
X-MS-Office365-Filtering-Correlation-Id: 56649f43-91fd-43fb-111e-08df0b6a1d32
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|7416014|1800799024|10067099003|22082099003|18002099003|11063799006|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	sMOXNm8hfLeHMdQZIxBzuqMUeLaWGfwh0iRvS6GdC06tGvDWx6CkW0/rTO0kn409mG+eAFAWvbPhsrKAe+kjC1iX8wdEijfT+ma2t05RFQb667Y6YXITmxxVD/60afNEhFuHFdpO8eQ+Q/JPlxJfMj2YOTISXTYEp6uhA7uZdtHrLSq6CUbn6jPG99Qnout3kVWg4rYrODa85dbCkn0Yxp3OzxaP3Ufc/TgoBX0hpO3Sc+1tA+j9gxpUCFj1TAxNSXx3WFufE3p6GT5gcgYJb2CBHJwhnZwwc9shzMtEh1oh4WMyoGssaHHimlfEP7a0v27+c/6SuzcyPIfWZzAQ9Cw9t0Mcy+/jH93s2OpoMTrAisxbY/RO4tbI4fDH7uvjyQReEUKIp19FWwU4Ga2BHpXGzmz+6Yj7r8Cz/ScYzLEz0Q9WeofrE+j5NPh1+SY9e6Rpch+3NSvJ0l9OBQqNxf6ajUTZYISYAT+PMK45ag4EJAw/rb4HxsyDOZPoNgkOmkpkFRogCdp/VjiJ6f/RL/aXZz60wycTYd9VxnkmVID33Z13U5TiO+ysqAHJnlQGGG2wcA7//U4VvoPd+q8xicsiGOAY83Z7FNcdzavj6VcpfzmWH5GJQIfzxqHUVbJFIripj1zW3eFVMP+za+khLwrehNe7ct+YuB7922MmaZQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(7416014)(1800799024)(10067099003)(22082099003)(18002099003)(11063799006)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?alJDUmE5dWh1VHBSV0pGNElVWTQwemt2ZHF4c1cvajIvRVROR2F5a1VQZzNu?=
 =?utf-8?B?NVJvMzZmT0dkWWlmb3VNR25iMUlqZTYrRXNvZFQ1dHJ4SGRJcW44MDZVQ1Nz?=
 =?utf-8?B?OS8wT0V6VVpCT3ZZSWw3eTdJQmd3cUExcEhVZDY0ZG5CTi9PM2w2RFc5VkNl?=
 =?utf-8?B?TjByMHhkU254SW02UGpqdUhZcWJTYUdiOThQK2tUcDJ4a2FpWm5yOXJKRlpl?=
 =?utf-8?B?OERBRlN4S2RkYkpYb0dyRy94Q2RoWGdBZlBSdmltMTdPbWNmbDJtZkFsQmY3?=
 =?utf-8?B?NmE2VHlCaVVnbU5OajBRd3F4QjNBaUJ2bUgvbWJvTlluTnJsRDh2ZTkycWRx?=
 =?utf-8?B?VEF2SWoySXpWdE9NaEZTTUJIZEY5K2drcjhTbzY0U05SdDZSSUgzek5HOFNM?=
 =?utf-8?B?aExIWnB3VDNTWFNFOFFBWXFLSXhzT1pZNWVjUjh6U3dYbzZaWjg2SHdPVHZ6?=
 =?utf-8?B?Z2dLLzFSSU1tQzAvRDBYZXQ5aGtmYUNxWHpaQXBlcUZ6YlNiYU9BWVFvb1B0?=
 =?utf-8?B?NG8rRStGYlYwZjZZWmtna0FrU1FJSXZ3RmR6NGV5S09TOWFuRUt0OXBPTWpS?=
 =?utf-8?B?UlhJWmFNam81U1lzZHNmN1NqOSt2STQwL1VuY3kyUThRdXI4OHRiU0F3QjZx?=
 =?utf-8?B?Z3BkWDVPbUVxTlRTeUdFeGp6UzBXK1N5cnZuakJjRFRNYmUzSU1XVS9RNWNu?=
 =?utf-8?B?dndrZ3V6WWRyZnozWVRCZW9rZ3Q2My9ZSGpuMTBQRmg4VXJ0R0RlM1d0WTZO?=
 =?utf-8?B?RWNLUGlXOGpLRHdZRUlMM2J1VUNZUU5maUZTVjc4UkFndGFwVHN5VFlpendq?=
 =?utf-8?B?Y01aVWxuZU1teGExSGFKVzh4UTBOVU91VHo4UEc4N2pLR1ZYOGhVYlhuOFg5?=
 =?utf-8?B?cDcxQXVHYVpqMEJzeGNVaDB2bHA5dUV5cW96MDY1dGlRTUhxYWY4dXBsRFVE?=
 =?utf-8?B?c3Mxd3o0Mm5TZXNHSFlGcnQzSnlGUXhuWVV2VmJ3ZSs1YkRWTHplMzBCT1Vk?=
 =?utf-8?B?bFFWVk5vSFdxcGRJUWF5MjZpK1VhQWl5TzRFRHhvOTJoNTlPNGdOSHJndHVE?=
 =?utf-8?B?MDVqSUlYelJ3dTJWUkJReU5LVDI2M3pZSTk3ZkNkMCtZd1B6MkttU2RkdVc2?=
 =?utf-8?B?Wk5IamVuNkt5SVByYWR3dkk2RnZqQWt2VWcvMVNpTkZKelpJN2ZqbjFPVmdO?=
 =?utf-8?B?elVFbVdqcm9GU1djTU5XbldnZGw1YjNESWRja0cvM0lZVjFWdFhYYmovb3Fh?=
 =?utf-8?B?VGRwdTdrWERET2dQWHpLcTZiYmNkVFVsejVNTFd4dlVZbWJFTnFPdk43N2xu?=
 =?utf-8?B?RTBMY2p3MHNsSlhwMU1mallLK2R6VU9pdzBDRjFrUTVOSkF1SWQxeXRSeGE3?=
 =?utf-8?B?bURhdmJTZW0veXJzcXBYTmlzdTZqMmhmT05PZDJMTTYrSVNWQU93WFNhbWFO?=
 =?utf-8?B?NHN0Y3BCU2owbEZzREVtZCtuR0padzIxV1h0eXJEZjNmSGRTRFYxSXExSnBm?=
 =?utf-8?B?VGJqcER3SnRpa1d1b2diTk4wNTEwZy9hVVJlaFArQUNLYzhKaHhsRzk1c0xO?=
 =?utf-8?B?WThheHIyMDRxQW9TODhpeG90WXp0UWlnK0h3Z2JLU2wzL3dtOHR4bGhtSjMx?=
 =?utf-8?B?VDFFdTNhOFVjMURGZ1FQYzVWM1VSc2E5eEZ6Tm9jUmdkNXdCNW9GdkRMRHpu?=
 =?utf-8?B?UGNoMFhUek80UEtoK0tLOElJTXBMcXVmMDFvYlVUVkZaKzJ3Mm1aUCtjSTRD?=
 =?utf-8?B?cGFkMS84TnN2Yno2d2libkdqR2lFUFViYUE3YU9aSW5WVzhURUJGVWxIZnRQ?=
 =?utf-8?B?dm9lKy9iWUZUK2l3ZWoxRXorclRwQXp0MHU2cEFCSWlHb3lzZDNmOUlYS1dq?=
 =?utf-8?B?ZXBLRDEyRGVPcExvS3U5Q2RRS0xGSzJRd0FpQUF0cW8yTkdPeXZISXY3M1FB?=
 =?utf-8?B?SUlFQ3pXUHNmRnBPNkdwbG5TZ2FOcngyUDJac25mZWJCcmVWS1MxREt6Mmh3?=
 =?utf-8?B?TE50bmE1SFVBTXdEVGpmeEpLUHMxb0hET1cxTmFKUStTTzBpNkY3VVREa0dF?=
 =?utf-8?B?bllnUFoxcHNOYmR1Ty9zTlBhWkhGSVZ1em1JR3k5U2tTREdCeGQ1cVRoM09P?=
 =?utf-8?B?UjJLbWh6QWJGcFhsVTJZMGpsdEZ2Vzc2RmdzdDBwS2ozQTIyeVJqaXJITC80?=
 =?utf-8?B?THdrUTN3K3d6ajVOUHdhU2tVVHNvUENwb2lIS1o3SkZqSTRDa0xQMmlkUnQ0?=
 =?utf-8?B?OEpROVV1TG45RldJUjhJMll5VW5ycDNqbnV3ZXkyV3Q1THJyVjBXayswUmJH?=
 =?utf-8?Q?LvUT/zAvAMcykr4p+h?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56649f43-91fd-43fb-111e-08df0b6a1d32
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2026 16:24:09.5035
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y/+XTFC32abP4OZN9bohUjKBNS15Rvx0pouusjI5DKU6dH7qyam0w5m5h07Im+ol
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPF0FD1DEA27
X-Rspam-User: 
X-Stat-Signature: erzbqsrk48nm7o1b4psqbpaqe1itqz96
X-Rspamd-Queue-Id: 9388D100003
X-Rspamd-Server: rspam06
X-HE-Tag: 1788625454-192608
X-HE-Meta: U2FsdGVkX19CM8/VNEoxyeVvAwYXZ90XZo78BHblBGQVR1kvAoz2kX01dPRwdWNsAXjNpyCi/sxJ3/XNBSC+epImRvzzYrnHSIbBSNWNtOLngcLN3BDcEMrjq+vQClofB0Rj16wN6WSXAatiAatDeTtzndB2MlATY0POgn+8+J9hcYde0NF+bklQlQ0fY15UwynLSLJ9A1On/6p8nxhjJpTS63EzwU9trOj9QIe55fPVqe2YSiVXk/xCA3Pj6BSx0utjZh/TquncWSuB9y5CPd0vzVV/KcUinLaK6ROffoqAtivSgsL4DOWMSMcDCj3tQsyGwYZxcrs0Wlu9PriORlfCFgE7JvzkUhGSMi4Xw2Cv9xJbIEt+kZl2Q1YY7S9TmSmgypLlaVEXDH7b8H1cM8ZOWfAPnzDyhPfKUNs71T9fYeE5JkGDMGOmNLcamzj23FBswaVC4yiBTBGojE5rc3Jj+t0FBQxb9/mvs5C00Hq+iUht1BkCVv1BT8UDBXXNjO+tPoS+LjQgKN/nq7+AhlLuoAW1A5sxGNCuv5Ve/EEMcuVw97pOkvRHhJDuJJEWRQrlkXJ8PSTpe5rZ5/um4LZluz0ihtUMfIvxubLZQliGXIDrq6vLLjiHmlxJ8YTmoD7jg9uta4cSzHWfZPW/GHoDUX9uHYBO17BzgZRcjrULx0WIWFO58i0e0isSMSDZWSpd12VVpm9ph7uaC4xCb0h0qYdIHZeC3TKqtOCqypVfaa+BLw/uMtcuxRJz6+fDIZr1cp1c8OP6Mk31rjSZ1rI042suqv2aiKAYfNfzpOtCCq/xVFiIuQ3wEYfDXL7qaKA6SS2gZRZ8NvaGpt2CJSl6As2Wqx3gUF23UgAWMznwY+V75Btrcv8jCbMACTs2NqS0o1zmrYctNYkn/MiolqilqT94RtE40JYzpl4ZBz1DTBFI1WZpUo9yA60Mp2RXdUBa2aktbzqXQT+ekLx
 hItQf5mk
 NzcEh2Yvly3VnhqnLbM1j+OrWkyeJHCIU9iExDsxLi1je5mx3NdGqr8l/EWmY08q+vW0aSQgyM7Ueo8R1T/F6kgIRdc2GMZfeKyNMouSCebdKCjldO7QdLzzbwrPYBILGaCP3uAGXQVDGgfCSDsdnexmeh1VNsrFxUV18A8s3NWqq0WCUwzfw0ZQ7qQeyNUW4NhJn0Wxr9lF+8OvdeCm7hnAmwE6441uNSTIGRTtmkmOQ4Te6+9JfzuHvXuE/sDGhv8vga5FLCiatEIHTjTL8HKa1E5le1d+mIDrVKd1IoraiF2lzhEGhOCbJhzKtTh0j7Vpg+2pp1iNM9SOwSdod14PVHEdtogpzZkYSCo3c40StHfXTJoAQ1FdR/KOwSmgzLezwa/MV+WMcG1euq/N1x4oc6keN++50JO234FRh1DF15ssYymrVlIvNytx4d8zeRXEWwzMWuLarz2vQNTYGT4YaBf/MGWndFW+A
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat Sep 5, 2026 at 10:01 AM EDT, Christos Skarlos wrote:
> Resolve coding style issues flagged by the checkpatch.pl script. Specific=
ally:
> - Fix block comment formatting to keep tailing '*/' on a separate line.
> - Add missing blank lines after variable declarations.
> - Remove anecessary braces {} from single statement blocks.
>
> No functional changes where introduced.
>
> Signed-off-by: Christos Skarlos <christosskarlos.kernel@gmail.com>
> ---
>  mm/hugetlb.c | 17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
>

<snip>

> @@ -3764,6 +3766,7 @@ static int set_max_huge_pages(struct hstate *h, uns=
igned long count, int nid,
>  	unsigned long allocated;
>  	struct folio *folio;
>  	LIST_HEAD(page_list);
> +
>  	NODEMASK_ALLOC(nodemask_t, node_alloc_noretry, GFP_KERNEL);

Please check the definition of NODEMASK_ALLOC. No new line is needed
here.


--=20
Best Regards,
Yan, Zi


