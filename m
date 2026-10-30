Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34A45606A33F
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 17:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=5JayW4uB
Received: by kanga.kvack.org (Postfix)
	id 542126B05B4; Fri, 30 Oct 2026 13:59:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F2466B05B5; Fri, 30 Oct 2026 13:59:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 393426B05B6; Fri, 30 Oct 2026 13:59:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 14C416B05B4
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 13:59:32 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 914781A0842
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 17:59:31 +0000 (UTC)
X-FDA: 85380054942.15.AE38987
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010019.outbound.protection.outlook.com [52.101.85.19])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7948A10000B
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 17:59:28 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=5JayW4uB;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of radhey.shyam.pandey@amd.com designates 52.101.85.19 as permitted sender) smtp.mailfrom=radhey.shyam.pandey@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793383168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iZmi5tpFXwhfOkG0YQ8UjtPGEyGwEuV1Gr1U1fVTNWo=;
	b=mAPsobk6lHpmzlWD4ka5My4w2YZ6Pbq4wOhRR9F08R/jrWaev1isNvznAQ2xYU6gvhXnBa
	ZA14gDYpaz3rr4kHJYkKLHbu0NhfZ5DlYdp2/Qko/VjMDhyRwaa16mJ3B4HftSwXp5UIJI
	spaw9LVs3VhFnu3/20Sc9Nt1SU325kc=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=5JayW4uB;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of radhey.shyam.pandey@amd.com designates 52.101.85.19 as permitted sender) smtp.mailfrom=radhey.shyam.pandey@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793383168;
	b=U6ebFIwq1WjZWQqQAw1NzQswmeDMw84c6X10/Zg6zmAqsBmo6DaSedQnCuBdgspO3L5lhh
	Bi9d0SXplgGx4aTO6aZGSB4lHkHgyu0bNChd/Xj/qT7YD2Q+VIcVD2i8a1RBk3c1PgbMLL
	VGQzhy57RXMY/x3WOIs+TvZsdss2wQo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L5yeOGDdkYtpQuoynm+lpD1YX/9kA+EX8v8kWz8Ifi0bsiFTiK2P2gxMvqtt/QhZq48uD9zR0i6iRzONH0uzsLhHQj1Sfc+oy+ah36BXVImkoS3uXa8psp89ReurKqil5SipOTmdltC8Hcz+RLbHK6XGStfN9D0tsXxDWb+6LBbkqqglp6pxfai1zYJb+FTJRsv7YfjhqrtyF3ctK9T2D9jvkBp61c4IiTIREbS41QFDWSfSwZSO6ggRvI83lbGv4iPkrbtoLy6gKyygsITimGz1QGH89E0zOq3a4nH2o9utLtZiTg3OvIust6SvzTbasp6nK0VsvnyUdkEqcofJ/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iZmi5tpFXwhfOkG0YQ8UjtPGEyGwEuV1Gr1U1fVTNWo=;
 b=HSAneYf7Rn8iNgYJC1dVjJdlLBQv63nYXCUGkdoQRGpGlDeT59ub89RgZ6n3yEg1Ta2ipvgFQrRbLHpAemt8NooUdiRUD7CEBBhUGAdKXsDrDiSZYCMKPbSTaNrzX725s3sae8SOYLAWKhJ3AyuUjUVx4GXYDZkqWOSWW4Vk1Oo1VRRJPUMRBM77PC5bBd+lxlbTS0sXxT19dUvm/vrC9oWJyCVXj3Nu/hRS3W3AcHX9pp2K1Ahf8srmhInmHaEP6D2ABQwmyjPCCRBKCyRXdU15Rq3Qs0mwsPlCQwmfAFIbEcAWfX3tKyh8cUBCqS8F1uqQXzLpL0VsZLdhWrf/RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iZmi5tpFXwhfOkG0YQ8UjtPGEyGwEuV1Gr1U1fVTNWo=;
 b=5JayW4uBJMPn//bPg+2mEhWt6DLOJOKpnLt4m6azxaYIPSoY9kNOjz3lmI3hcm8781D2n1kCO/YCu7odDZ2T8t0pn6lQcMuQyQvrgrIaMnSWG1yKB4MIYJRNLAqMf1YiuOV3PWF+Glxut3BZNIoC/etqIBQcl5ey183d8aoliPk=
Received: from CY1PR12MB9697.namprd12.prod.outlook.com (2603:10b6:930:107::6)
 by LV2PR12MB5918.namprd12.prod.outlook.com (2603:10b6:408:174::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.9; Fri, 30 Oct
 2026 17:59:20 +0000
Received: from CY1PR12MB9697.namprd12.prod.outlook.com
 ([fe80::3a41:55a0:8203:596d]) by CY1PR12MB9697.namprd12.prod.outlook.com
 ([fe80::3a41:55a0:8203:596d%6]) with mapi id 15.21.0569.009; Fri, 30 Oct 2026
 17:59:19 +0000
Message-ID: <9463783e-5425-4ba8-9155-033c21d7f516@amd.com>
Date: Fri, 30 Oct 2026 23:29:11 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/2] kexec: do not place the next kernel in a
 fixed-address CMA area
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,
 Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
 baoquan.he@linux.dev, pasha.tatashin@soleen.com, graf@amazon.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kexec@lists.infradead.org
References: <20261014145731.3431527-1-radhey.shyam.pandey@amd.com>
 <20261014145731.3431527-2-radhey.shyam.pandey@amd.com>
 <2vxzh5i5orbv.fsf@kernel.org> <auL3UW2InVqYU6Fs@kernel.org>
 <2vxzzevwmz2v.fsf@kernel.org> <7625fa23-5f4b-4658-b17a-fe4e58103e7c@amd.com>
 <auSHrdDdFrWRsuzM@kernel.org>
Content-Language: en-US
From: "Pandey, Radhey Shyam" <radheys@amd.com>
In-Reply-To: <auSHrdDdFrWRsuzM@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4PR01CA0014.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:26e::10) To CY1PR12MB9697.namprd12.prod.outlook.com
 (2603:10b6:930:107::6)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY1PR12MB9697:EE_|LV2PR12MB5918:EE_
X-MS-Office365-Filtering-Correlation-Id: dd6bd916-7b3c-4ed7-baf3-08df36af8571
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|366016|1800799024|11063799006|4143699003|56012099006|261028144727099003|261022105027099003|261026140227099003|261026121527099003|261021121427099003|10067099003|261022075727099003|261009223027099003|261022115727099003|22082099003|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	F3UmCoUIEt9wXI1Wsq5GLcygBuZuykUdwDdVql3k/91lgNdXJB045FU2sV4wGbIMm/1kA3oXgs9w5e5AlcKLBEZ7RO0i2Z/p3odMPmuIHBD9aY0Slx5X1hzMYt/SW9oonAhYwKSZ2Vw6LKhvsibpi70w8gsMp36vUmLA5hqV5K5BXuYFp46uBmDDmjmJCZ4XXkf0sr0VdZXT73zWVJxcKxW1QGtjDTUC3MdSco0f7Lr1HHoHU3fQTtrjS5bEfA3zMKpWuwJDRzXxj4Umn8NPhNEmYc33OTUHcxbzUdSRzsBgJrnnHtg+m3xYPP65JbRPHudWlqhfQdFN7ife1HVgxyvBHSINmHGmc+8wZ+4p7I+TcVEp3Nm5t9+q+moR2kgOi2bcXx/ECy4WQKP9isoOzj4h7SJ4rK2nK58p7jOWEk+HNw9wES+57IrmffAd2K6mkIavdDoB2u7t62u0L+drdmd1DWDFi6eXtRFS8nhTXODIpNISaDKJNDjggauhtg4Pd0iInvLEwChk87wHTgFW3QQJV+qT2zAQFRIsO93/hkViMGomDdcW3txBsxle+FoI3H5P3eC792cliKswjyfsk5TLVxY8H46eUS9e/VEyfL5oKSIZ2IahfJAW4PPeX8tmHkoMEBqGGMEUfssY/mwSPZpGf/Rt5LikMWbzyHkii6Q=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY1PR12MB9697.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(366016)(1800799024)(11063799006)(4143699003)(56012099006)(261028144727099003)(261022105027099003)(261026140227099003)(261026121527099003)(261021121427099003)(10067099003)(261022075727099003)(261009223027099003)(261022115727099003)(22082099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cDhCQnl3ZTBvNGlPVVFMNzUrdGhxbFYxWm9va2tFajkzYmtnMjBKK1NXN1Nn?=
 =?utf-8?B?K1FrMkdqamxIK1R5RUd2Y2p2M2M0KzFDY1dzcTdrWW1KQXY0ZXM4V0VuQlFJ?=
 =?utf-8?B?Nys1SEJsZkoyMzVET3c3RVVrVzd3NE9WdS9IaGo1Y2ZobmVNeWJlZUZMcHRN?=
 =?utf-8?B?OFVma1greDByRno3YXZ4WGRKM1RFZE9UN2lBZVJpb1RUR21pOTJGT1dVOUN0?=
 =?utf-8?B?czcrZ2dTRlJkRkRidVRRdHAzdWxjTjdmd0VjUnNCWVBFOElCWEV5dDVIY0JG?=
 =?utf-8?B?OG5kdXFObjJMWHc4S25FajFrVEpsazI1d2JtQlRZcXB0OE4xQWw1Si9oQjIv?=
 =?utf-8?B?RHpJYmh4OUJxSzVHb2grdW1uMHMxN1UwUjNWTkJLL1E4WXFnMDk4U1JXaVRn?=
 =?utf-8?B?QmduUHA0UmR3UEoxc000TDlBUGZSbEdlL29obnNkOElrZHpwRjMvSUNXcExs?=
 =?utf-8?B?bzA3MGIwQ0V3RllUbzc4NXpGT2I4Vm81YWlONmpkM1BtLzdiRmZ0Y3Y4Y1Zz?=
 =?utf-8?B?cVl3WXZqaHpNMkdSSVFRNFVpbW1LZHg0OTQyRUgrTkFqQnJIUXJadzUzREZS?=
 =?utf-8?B?QlpxZXROL1lvbjZPNFpGc2xUTks2YU9RVGJKMUJydWFrK2hrYlVMTVk1V0px?=
 =?utf-8?B?N1FwMlhGZ0lZVkVtcUgyb0RtT2FwV1E1ajA1SFdBdXoyT3YxVGtSOE5wMnJl?=
 =?utf-8?B?WFV1Ty9SeGNCYXZuSkpOQ0p1ZDcxRTBIZnpVejBqTDVjcTdQUUFla1c3dzFz?=
 =?utf-8?B?NmN0Sy92UmwvK1N5S0kxY3AvUlM2TVpOb1hVVzJzdUlrQlc2VWh3TGtwMmxz?=
 =?utf-8?B?THBhRlBjTEdTbE84T0xQUGV0MjN0ZGZ5VTJFc09yQzlSTTA1MjlzeFNHV0l2?=
 =?utf-8?B?L2llZ3NwdGhUMkZybDQ5R01EWEpXVnkyV3MzQlpqa3ZMa1VvejlEM095SkFZ?=
 =?utf-8?B?Z3Vxd25BUXZqMmxBZm00VnRsYVJkdnUxUmZTdWhRUk92Z2ErUDY2Y3p3NktQ?=
 =?utf-8?B?V3pBczJES0ZGQStaWlBCd0gyYldNRkpDcjRLQUFmVnZQSVBIUkpoZVZzZ3hy?=
 =?utf-8?B?TUNvRnkxbnU3eGdhMzQ2MG1RcW55aXM5QnRPckJJMzQvTnZwQUdBRVZMdU9l?=
 =?utf-8?B?OTI4LzBseG1LeEV2b0xQOGFBdDNBaUtVa1dTUWZyNnQ2VjFOcFlZcHI4S2tY?=
 =?utf-8?B?Z1ZhaUsyOTBUWDRBR3ZXc0VDUUlSalZlcmtRQy8wUmVDZWxvakZ6VWk3VVFQ?=
 =?utf-8?B?c2FmTUJBcjFoajVyTGszMk5ybjRGcTQxUDBIWVdxRUc4TG1maTV4eDU1RGtu?=
 =?utf-8?B?YmRPZlJZZlFsek1mV3lZdU1wQ05VaGt3elpab0E2VnRzZWZxZi9NdDdXTXhi?=
 =?utf-8?B?ZjduSm5pL2IxZHYvV2tjbXl1SlJQdzdlNTZlYXdoSTR6dWVEbU5GMCsxQXRw?=
 =?utf-8?B?dldIbjZjN3ZnQnVFejlxZ1MvMEpXNnM4a1NBNTlBSlhHRk16UFR4ZlFENkFD?=
 =?utf-8?B?UWk1bGJhUGRGYmZCREorV3Y5VjU0ZUtORW1ONlBJY24xeTlteHdNUjB4dVNv?=
 =?utf-8?B?UHNobGZ4a3cwOTR1QnZjMW5MNXVBYUlRekpxeENaWGhjeUdHQVdDZ0g2M05n?=
 =?utf-8?B?cllDMUVDU3B2ZmNIL3ArdUp2dnVucFBybUloS3ZCOVNFNUVEVEV0U3ZMWDZo?=
 =?utf-8?B?MUJFdTNEUVNlVU5GY3NrYTRFaTQvcnpFN21vbklPT0E4SVozYXBNaXhpZnFN?=
 =?utf-8?B?cS9OdWl2b1dZU04yRS9qUHBoVWVYWXpvcllNNiswdE9RVjBQZjN5RytINmpt?=
 =?utf-8?B?R2R3ejlLTzBIeVRqVVIxYlV2TGt5YzBSa1I4eDZtVlp2QW9iMHozd2FtSk4w?=
 =?utf-8?B?SUJLVVVURlJvZDNrWHNZN2FvTDZIMnhuQTY2WWxpQVVBYTZoVkVqRkgwZ3k1?=
 =?utf-8?B?RGVEdVp3eVVmZGQ3di9GYlFiK3NWTys2LzM2RUNnYnhjYWlzb2ZqbCtiUlA4?=
 =?utf-8?B?djhRVWdQRjF1eFJKZUVkQjlMTmsxS2lXdytOdlZycy9EbGNFcDZaamYzb2Zo?=
 =?utf-8?B?RlFKeTlTWTM5dFo3ajFZUlMrQko1T3ZqNGMyZzFTS2NEdWFzcGF5SFl4NWZk?=
 =?utf-8?B?NUdYdDAxelNIbmVCT0lQZC9IRnhwSFJlbXpwOWlEMVN0NW1TK1VuOFhDMStn?=
 =?utf-8?B?bmp5dlcycHBCZkpwa0ZaQXhLd3JwYzJYQ1c5ZkRYRDA4MkdEL0pSOHd4a080?=
 =?utf-8?B?VFJqaXpIOEhYRDJDN2haVjFjTkcvcXY3NURMQU5FZU4rTjMxMHlKY2JKYnVZ?=
 =?utf-8?Q?pku3Gg8MeUlQYSLf+r?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd6bd916-7b3c-4ed7-baf3-08df36af8571
X-MS-Exchange-CrossTenant-AuthSource: CY1PR12MB9697.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2026 17:59:19.8463
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y/Fa/RgVHtk4ZUYmLOK6d9NsecHaD9JRKrd71RD0vEIOKR06x3Dhr9AdqhJA+Rax
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5918
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7948A10000B
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: qwnsmwsj6ow8gbpepaexmatrnwj9mnrd
X-HE-Tag: 1793383168-907505
X-HE-Meta: U2FsdGVkX1/oIF6Lg1w9wWrpJocVjh2udrbLd5+c7Ovg8wI51N9Tq5XybvHI15V+wzXtUP5iVaw/dkLBBu9gnDjcOo9A6ABxLT1WXzd+ZiUMExp/U4+upydPk49h405sAH2xpowUw5OljhqIZP9ItnY3TFt/F9SSmrvJ8d5makoQ/SCOG7oPh3onMJTEcjjO0URiPMNVGtHDRh9Ndo+GuZrSYzH8134HQImogZ3ihQEL1BeHPmZUdSn/aKwzfSamkv58UrYG7bNG1g5nCL974QsAKtN+MWhFWEJVfoe0t0yltCMOfiHWcFR1ecW+yUge7LgIBjHYeDnJNVqkrJSIU+2ED+kWqNAZ/v0By3O7IOcS8IlBs552UcNreKg2wNE3vUVnEuSLXWzqLL8uWKSjNzQKoqI0+MFMhaJhS8V7kO411qgf2316V+DvKT/oHUHFF0OdMzTUVJf2avYe+m0XeEVSXNzF7WZC1YMb90Ej1/I20AS1e40uSzcnigfMk4iHz6dmAlgBlJtlEywcjm379q1VgQpTG4S1jxjb/Z+kA2h9PvxJpytLJsOdAe73VqQUk9p4W5Ecmueh6NXMWiZ8eNzjLTsQsOv5w5NPKwEld+UabkO9OAjZp+tcktSBiodFuxJbCRJu4eXQOiclciMh51Fcu3wG7xPNjRksMbK4NmLeVrWMonUtHTgyvBWj3T+QnWFZxHCVuglya5gesddo89ip6ypRe51tn5dPPQq3VOocF5jfEupJz1iucGDHElGR/1prr9AH1AYrvlteYPgCBV3R7FK8YYCx7Tfqym19UVrU8KoSjtPCtnRqQRi49sp0bNqA6hBCRa7kh9/JzO5SzKULLxHf/zyXQGGBpydjRcO65tWjIixT9OMvR5z/EFzVglMy7f6+KmMH8UFsnSTuITGa9FpDNsiY9ikXe+Gdo86LVq0YiWODFzSW/rtd+d06HzHm2LOtlBR61w667Mo
 qVliAdyN
 Oth8yA6okMcOkp76aqtZXaZYvnBc63JiyGLbMSWjbwylsfav9Mn2MmDQm7l5A9pKFjElgatdbn419yZlHqmpR5WKavMpn3i5B+SDXHXbBkhJz1xQlu+vMsp7c9Q0PpZ2i+AaRzJIcze+lXB13GkSwNPIz0eZ0eBFV8NWxV33BjUhGunsVgmvlM4fpkQGjwKlsALPQ39i4RzZl6sfWiGUdyKD0nxhnIz5qGuJB1pDARxPqq6PYtFgYWNDtx8+Jm4Rw5k0E6VZl4dxheznsn0bdJK+Pn79eFU/S6yJcMf5qv9vOGbhr9VghSzybCvY1FXfarHBVaKvUxpPxXEXPbDGaYfDcDYHsSlOcES2U45mjHQaeLGMXD2QWnzinpwT5lJrAAhE9/MjYqmDrVJcZEFO/JDDavaWfCH7jKm+xbUASo471v/QhkXiu5b6C1B+ZIOOXsfLRnpeep5/Cy0t4EtqhRsoJ67/YOHmPyPpPnNfxH59M98Z2xfIiYeounV+Y+SstrMaLR7MgVXRqGcwo/U6n4ZIxD1oHvNhUDQLkD1pR0idH7LCRBmhOVHtV/onJ7VvSbuZ4WYvdvej2twY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/30/2026 5:33 PM, Mike Rapoport wrote:
> On Fri, Oct 30, 2026 at 01:22:50PM +0530, Pandey, Radhey Shyam wrote:
>> On 10/29/2026 6:41 PM, Pratyush Yadav wrote:
>>> On Thu, Oct 29 2026, Mike Rapoport wrote:
>>>> On Wed, Oct 28, 2026 at 03:03:16PM +0100, Pratyush Yadav wrote:
>>>>> On Wed, Oct 14 2026, Radhey Shyam Pandey wrote:
>>>>>> @@ -304,6 +317,7 @@ int __init cma_init_reserved_mem(phys_addr_t base, phys_addr_t size,
>>>>>>    	cma->ranges[0].count = cma->count;
>>>>>>    	cma->nranges = 1;
>>>>>>    	cma->nid = NUMA_NO_NODE;
>>>>>> +	set_bit(CMA_FIXED_BASE, &cma->flags);
>>>>>>    	*res_cma = cma;
>>>>>> @@ -517,6 +531,8 @@ static int __init __cma_declare_contiguous_nid(phys_addr_t *basep,
>>>>>>    	}
>>>>>>    	(*res_cma)->nid = nid;
>>>>>> +	if (!fixed)
>>>>>> +		clear_bit(CMA_FIXED_BASE, &(*res_cma)->flags);
>>>>>
>>>>> Nit: This reads a bit odd. cma_init_reserved_mem() sets the fixed base
>>>>> and then you clear it later. Wouldn't it be better to just pass the
>>>>> fixed boolean to cma_init_reserved_mem()?
>>>>
>>>> Actually, we shouldn't expose cma_init_reserved_mem() at all.
>>>>
>>>> The current callers of cma_init_reserved_mem() should be switched to
>>>> cma_declare_contiguous_nid() that does sanity checks before calling
>>>> cma_init_reserved_mem().
>>
>> Thanks Pratyush and Mike for the review.
>>
>> The switch from cma_init_reserved_mem() to cma_declare_contiguous_nid()
>> looks like a broader CMA refactoring and requires additional changes to work
>> correctly.
> 
> Hmm, you are right.
> 
> How about we invert the flag meaning?
> Than cma_declare_contiguous_* will set it where appropriate and we won't
> have the weirdness Pratyush pointed out.

That's a good point. I will invert the flag meaning - something like.

__cma_declare_contiguous_nid()

<snip>
+       if (!fixed)
+               set_bit(CMA_DYNAMIC_BASE, &(*res_cma)->flags);


So the v2 series would look like:
mm/cma: drop the duplicate alignment check in rmem_cma_setup()
of: reserved_mem: keep the reservation when node_init returns -EBUSY
mm/cma: reject CMA areas that overlap the kernel image
kexec: do not place the next kernel in a fixed-address CMA area

> 
> And Radhey, please, make your LLM to spill more concise and to the point
> text and teach it to trim emails ;-)

Noted. Will take care of it in next version.

Thanks,
Radhey


