Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F1ECFEA80A
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 05:38:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD25B6B0005; Wed, 25 Mar 2026 01:38:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B54D16B0089; Wed, 25 Mar 2026 01:38:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F5AD6B008A; Wed, 25 Mar 2026 01:38:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8AE726B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 01:38:26 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2B58B1B8885
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 05:38:26 +0000 (UTC)
X-FDA: 84583480212.28.16C986D
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013059.outbound.protection.outlook.com [40.93.201.59])
	by imf08.hostedemail.com (Postfix) with ESMTP id 44F2B160003
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 05:38:23 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=xOblAm+l;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of shivankg@amd.com designates 40.93.201.59 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774417103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kPw9lvljioqASyMcAaWVjJcqUavUYZ2TlI1qaId51WQ=;
	b=uH6PCDIsWowOHvt2rY6miJgZGbLYCiYC/Z7kvSIFvabqM2MOvg3ebY/sz1zq9wK7hPwGc1
	Wl2ks6wCEETsPRpUaqI3BlBn39h9VsnhHGeYRQdprvNXvqCxqheoU+jLEDs5Ydhok6kNH8
	p1yK8H59Op+FJJDgetuS2Y/ldp3+cJc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774417103; a=rsa-sha256;
	cv=pass;
	b=Hk8xaKCwnjWBAGs0TntpVzgMYPBG2uhWKmdqMWCH0g32LTezVECeE2WktqTd94uHLFzgsG
	xCoHbiZLurCm/oHboC9ItO+ImxRB5hzgA2B2AAqqcoTP4DEGA8NZteoDlqdf8jV7hHpVuA
	yXwPByekOBYwncqDrNJcHKggl4hIk2U=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=xOblAm+l;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of shivankg@amd.com designates 40.93.201.59 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uvK/YeNoQBRUJvPcaYRtyfU6WvlnzrFab4OcdhGtCHikAC7oPPdVxQK0RZllHNor7eOjSs5UHnT8d9JhM9xgp/N1yD3DlkYmd3BCBxsSXtwyG/9JTr27u5l9UAWxNC3lF2XojcLzAYwl069gwShIn9qpWvi7m0z60qBKV/lUdvgAQPuBVEL4ChcI/Uk+MWyPYpNIXq4P1opNNkWeZRBK9XVVwtfNRO0nsdD7bUDARB7+YckpNQGsn14dSeeb2iZSVHFvE1pHPo81nsEwTYP89ErNMerHEHQKqGKyutXJWHvWjJxWsTsLrXEJd/yNHKJiYzUfFf9DjzFsQ0QDSt/KJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kPw9lvljioqASyMcAaWVjJcqUavUYZ2TlI1qaId51WQ=;
 b=fZF4VGGBoweZ40mP9zKFv4PCoxxWvShWqajWPMkEBnrLzFHHOxtlREkwyGc30de0/E2Owb9vlhN9DqOGlPh7U7szvfpRTldRElzQSeflabUs8qaGGX+J+N8zBHH5W4C5h9j0U2D/nz7kMgXkyOpqmR8iYkop9qHNOs907iwZMK6jPyp7C4Fy1QC1dAsmSpyheaHswwgdDNnDmOHw7YVX1ebGA0fResDkpXw/p1b6Ylyr10jo76EJVYvqn/gxEY8HZ+iKzSty9Im8gyNw795cMe2een9edAOZUXAD8UeJRbaN54zTHpD040gIPtPxScwI47w2THBXOxOGKnByon+2fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kPw9lvljioqASyMcAaWVjJcqUavUYZ2TlI1qaId51WQ=;
 b=xOblAm+lkdrUBjU2c842EvcYehYX4kxCb2ysn0jDsnAW5zn9Q2aDcvSPRCJVLVB15lh/IX2ohfU4EXr2I+WlNkdXlO2xH6vtLlVjQ1bEM2AhR2CsXkjGBm4/nJ7N8VDLvkWeWUHzEWnPjv/g2bJXLk2fuM+hKu+mPWnpHYcQpZU=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by SA3PR12MB8048.namprd12.prod.outlook.com (2603:10b6:806:31e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Wed, 25 Mar
 2026 05:38:18 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%3]) with mapi id 15.20.9745.019; Wed, 25 Mar 2026
 05:38:18 +0000
Message-ID: <03f36534-60ce-46fb-b999-dce1a6edc647@amd.com>
Date: Wed, 25 Mar 2026 11:08:11 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/migrate: rename PAGE_ migration flags to FOLIO_
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, willy@infradead.org,
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260324190706.964555-4-shivankg@amd.com>
 <20260324122443.0488fecde3e3183856903afa@linux-foundation.org>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <20260324122443.0488fecde3e3183856903afa@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BMXP287CA0007.INDP287.PROD.OUTLOOK.COM
 (2603:1096:b00:2c::14) To BN9PR12MB5259.namprd12.prod.outlook.com
 (2603:10b6:408:100::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5259:EE_|SA3PR12MB8048:EE_
X-MS-Office365-Filtering-Correlation-Id: bfa46836-f181-4974-0782-08de8a30b80f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	3V5ZFYpZsB32EmSM7e8/kvW4Q0qb+T8oibNWYkzBU2lW92hvoTX6JiKqDXUnT1hq4xyoCLcKf8W9R3/X+Up7UwPI7gk0dNOgMM7ftD8xF//R7h6oEITB2j6DeCBwBXXy+lE3NPKQE3kzSST7plVZ2XZ/fJg4SVRQ5rqbRt3KiXbraNwkvf6AuHZYHL2GjuDpdr7NI2EKRJegye0wyOKCHR5cVs4w4TZcL30P57akAjzOzMG3ay996Qefwh5f2UcitINaltOQCSVkAJ3f1+Wr3/eLcRyXurYRxCcrBzH5eVSc15Rdf5T9hvyloy6WAbPzQjmf4Wb1UCLNsC3Cfp6FUo/IuZDYqy5vWG4jWH+M1TvMbK86eYOofoTp0HvEmMMa7ymAe15+87GdijIZQcrLLUmja8lbnQ3owtPIJWRhtf+J7feTscnEUulZgizrBn6BwpAFknmob7hIfAYd0+LJRJShxCuA80R0z0g6VSVnal5WQJ2dI386+B3NHt5U5IdSXlo8oedoIBSppnr6QiPgmzkxX1VEb5VF+IrPGPA6zQcZ24yzb9oAv+yO07d1kwN7VnOBussJNNm0B6srpNXTMzHs1p2043slMXQM4LtnMhpvfobkJg4hb+p/l+V3l/CgJu1SwjzrYEXdaErLyWRQsTDHiflFeivf01RexoW/AIo6G26GUOnqNGuPq25OVhVgBl9fFgIhABSekmpGS3fYe+oijFGNCWcBKX8iGOvDd+k=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d2J2clJvTjhOcjRlNjhhNk1QRmo4K0M4VjY1eVlGYWJRYTFjOERIMWlVQkFY?=
 =?utf-8?B?b2c2bmkxSUZWQUVwSHlPT04wRjdHbWFnaWJEV0QyZHRKazJFT2RPeFJLVzR0?=
 =?utf-8?B?azFJbHM3aFJycUFSUDRLNHNNeWMva3piT3BBWTlMQTVjckVCN2ZxVXVvaURW?=
 =?utf-8?B?Y2ROTmJmV0dTdSs4dmR3ZCt3SXQrMkNmYS82aFZYd2FUbnBDV2xjU2pRd3cz?=
 =?utf-8?B?NWJwdERITVpPMGYrdE9BcTB2c3JtVmZST2haYXp2dkF2dk9xS29Yb2pDVGJJ?=
 =?utf-8?B?bGZLRkxuT1prR2YrRGVHR1RxblQxQ1k3TTNwSXFrZVdJZ1Q4SFpuckpqWnFw?=
 =?utf-8?B?ekNqayt3dEZEc1dCczdYZkRtOGVtNjl5cHJBVHBub1U2RytROGZncHY4bG40?=
 =?utf-8?B?ZUNac2pRSEQ4YTVxbXpscTRJVGRxNHF6cG5abmVDSVMrNEJOYVF1WDZuK3JR?=
 =?utf-8?B?a2hPcnloWGR5VStncVpNdi8xYXRqSTJaY0o5YnNRM2RMV0traUhxV2JqSUFF?=
 =?utf-8?B?ZllKV3Z3bmNnL2k4a3N2b01tMDdaMEY4cGw5MmRyVC90RkVPQ1RiU1NCTXcz?=
 =?utf-8?B?YmtFbUFLWTYvMUhPS1hFK2FmaS9xd050OWF4Z2pxZTJnLytIZ0tJcENUNElM?=
 =?utf-8?B?K01VRWd2cXJnZFpJMStnNG5IdzFzWmNJbHZaVUdJT0ZZQklTQUx5Si9NZ0pz?=
 =?utf-8?B?U004ZEJpSndsYVVIckMzOEMyajUreXV2RGVCWXZQcktETXdWNGpub2U3dS8w?=
 =?utf-8?B?YzluY1doQUJ6RzJDTk9nSnFNbGJFV2FiSVZvc01La1J5VGlDVHd6MFdHbEFq?=
 =?utf-8?B?Nm1YVnI4ZGFaZnFBK1JITHY1R1JCYW14emJVQndVZXdLRGZhQnZrUmxjSnV4?=
 =?utf-8?B?b1M5N21RaGx4M1NtZFNheGR2eWs1bGh2aUxITktFdXBUNmRmNGdHRlhvMWkw?=
 =?utf-8?B?VjJWUHdtYXhXWk95RzhRUWVTeGtySmMxdE9ScG5vWXFLRUZJNytQY2hmOTA4?=
 =?utf-8?B?eVlvYkZ4a01YYjBNVkRsU09HSDFQcFo3WU5qekhGV0xxRDlTMU12cmVMTDc1?=
 =?utf-8?B?aVNud1NRM3ZreUx6TTloSGt0alhWV2J6Wng0WFk1SzNLSnhCbEFyeFA0dnQ5?=
 =?utf-8?B?aFpLWElzVCtodDNwMDUxMkxYS016dUk3RkVJSktzM1VLNEFuOERmcmh6Ukdi?=
 =?utf-8?B?ZDgrb1daa2VFZTVTRTh0QTNEQXFUOFdmbFNqaDUyZ0lMN0xNb3Y4NTJKVUd3?=
 =?utf-8?B?OVVRV1BhNml6QVdkRVlySGlxM2VXUjZ2VGw0dmZaczFCZkY0anVEVE90L2U0?=
 =?utf-8?B?WWxUSm9XNUo5NFhPcjdmaTNMNitYaGFBTW1GMk9mbCszMkN2SFF6K3YxRG1H?=
 =?utf-8?B?d1loem9sOElRZEZzWi9tWVhBdHFQeGVtRlZUbVp0WS9SZGNFZTVoK2JxemM0?=
 =?utf-8?B?MzhwUkI3NmxKMzV6WWFOM2x4OGJOUzdBVFMxcGx5Qm1tKzJmUFVSaTgzWitX?=
 =?utf-8?B?TGVjZlA0Mnh2bmpQVUg4ejJFRU5XZk8rN3FhR1M5U0hmZC9penFMRzZpMjZV?=
 =?utf-8?B?bEdkMVJKWHpYM1Z6MDZtaVFKMFpJZnBuVkRLODk2a09NY3NmRnJCbkV5bU9p?=
 =?utf-8?B?dkU4dE8vN3RzenJ6ZlhCUWd3bEg2TEhWa0ZhNFZsL1BxK0tINWRQb1VMdmpY?=
 =?utf-8?B?eUFYZzRUOUc5SEdSbXhsNGZjcnVGRUU3ZkVnZmNnRURpWkVCZjNrcFlpMXow?=
 =?utf-8?B?WVZ0cU4yQ3NlclFTa0crSEhHZ1dFZEJlcFdFT2RyNnJTN3E0akEyMXVZcnpT?=
 =?utf-8?B?eDhza1ZzcGNmbEtoY1kxYlU0NVMzSW9LS0dmVGJIMDZnNUVydS90L1gzQmhL?=
 =?utf-8?B?ODNNank0b05aWWgrS0pyRHFxelJBV2MwUlk5Lzc0eGwydWU1c3NPMUVhNjdw?=
 =?utf-8?B?OFRES2pBVXh6ZC9POStvN0lseGJoaEI2S3FxV3YrUDQya0wwUmFNeTN4VWJN?=
 =?utf-8?B?cWsrVHAvcE4rOHA3NDVCYWEzaHJMdXZLMVQrSEhQSnZHNlJnUVFqL3UycGxI?=
 =?utf-8?B?ckJJaUk5elFBODErQysrWCtxRlhld0xLZWhnQjh1VERCRTZnL0p4WXRYcGZn?=
 =?utf-8?B?YUgrSklHZU5VZGNLdmlqYUtybGlxYkF5THIvU3c5ejR6SDcyNUdCRm9zY2Jo?=
 =?utf-8?B?RUkzQ0FCclVCVVJJeFVCY296dkw2elp0bXAwRnhJVDVzWnBWbDN4ZFlEZS9y?=
 =?utf-8?B?Z3VZaktkbjFsUEhRRjhFTHJwVmxOSVZ0YmFmVFp0Uks4bStOSTV4UVlQU3Fq?=
 =?utf-8?B?QmcxTndnMG5PcHNHamxrS0VyOElOdXNsUTlnTVAyNGREV20zdjZIUT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfa46836-f181-4974-0782-08de8a30b80f
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2026 05:38:18.5640
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DKc4q17ASDczsOgM9aoMfcRv0iAwv/VR+FlZPwqgLJgOveaESUvSo3KE2pfIHRj+R/CzKUuiACTD3c7oJNzdhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8048
X-Rspamd-Server: rspam12
X-Stat-Signature: fbkfo6ir8unpsfe5mzozn7epc7dgtfh5
X-Rspamd-Queue-Id: 44F2B160003
X-Rspam-User: 
X-HE-Tag: 1774417103-856069
X-HE-Meta: U2FsdGVkX1/YUs8tIsZRKtF2iLw4AX1Sh1Kkeyhx4LPLMaqlYEKy944QAbHRJmus2xgm1wi25RY9RbIAQVJFYntmVPWSp8K7KOk6oezJUPJD2h6S3WQ4sVhGWbr07gfzSkJqIuPgLcYPmK0NmXW1E1Myu2VUb3iThWHSpHW5SAnpR/lnr9yLsnn4QOA4+UHL4d2sjAQ8mHFGB8jkp19C74rZxzz1e9gwgScBtUYjYzyXLR+pOR616QaxnCTO1UhvJSu5/cv7xeCFhTsAzzCiEgzHxTbrwzKBkrQpj36PHlu9VtsXmvsQEBbvi6PXqtepocbLzFa0J92msh4PhBPUNyKpp+0hzbRok3ozAX605uza4o3aV/1o9Dbxok3AhBbnWqKxk8zlpidObQPae0SzyZH7Lm+/LCGb4pCAGASsJ4O02DXs8g8In6nQdveGq+TdBgg6GK5p2Yl/aV4K4FtIRdnqGiDKMX5M5tw/idC8/g0HBbERQQrAoYBcygFv4RavKgY6MUhFw6f3E25kW8EHw0km/H6350sYvs7LFADEAdeXCMsnxqs6hv0Wd1Sxw8VqqtHkblcqL8LeGXZFd0qI/Xi9MPLvDgyLIkoqUKlhNBcob6QmDdHH+IIaAiYLC8/8mqcMcpuSMEhqSfpV+R7/SVL+oPIuELwfyuDIbnAyVgO7b565H7GnaGlxMNpBkOPfmVnz1o9A2p+33Gh3wY3wUYoWOXS+x4k0e7hNIW9GquQbmXU2vBEpUU+xvglmqkd0LMWeczmJJGXuW85qAovUhs1SgRIfN5O6ZawCVudnV4ngMwxSHOGDG75oT3kqYkocpPJtd/I1XMZGMiDe/55B5MSHIEq2x6ArVG3Nm6EWGfOhV3CPOA+6zZd/nn/E02+nCxtYWIMfYXXk3h6GdlttWTsGhrRQsCns5LlkzIxPw0gZlx8LGk01LI5H9pzyF+pgllFELY0gI/E5p6gurzL
 jSM/INjI
 jQGRQUtzGNP87xiMrrwlX/fQv8AqdjFRjuYrwUJfUglEUv2QLFP0dpQ679ksZQ/s7qX3nbLzRqOKJ8GeWdSZprUEnRjHjW5bRIsJGsdXot9syXL1Hsd7QEZGGAEuXZ6f1Cwqfht+AHi81xAwkKQnmxUBxtw2o/3EbWM0KWjfStpwDUbwd+NR0C4JVSE6snNSbPfGW1CDiiSrWZszmz5IhDU93wP28SfTJmxNAV+GDHrXCykU3Q7jZwsai9gwzJZ6vAskzi5RBDigCav1MIn0FZhHmpSGH/eWxxI6XpOA1nWeV94ARysyb9r1ltb/VPiTY7/hYUQjgFr/TzSHo+d6B4xSevwhiO8N2PpTGtmJyPnad7iaMTiSTxQCD7jQrBwHCkHkf/izsocrVt1Okbw5h0/3XpcH+lVZDbqg0R+FMqPDJ9anUouOY24UBW8mXofrwveCSVwAhCcBjUI+cvS+BS/+ybIdOvjZbt9g4VxcN+bhRESdHe518ygGRv4S0MIUz5wQMjmDpJ96ejpcT3GCdcsU1Uy82/ccJ9Irv/If/Y/yrUzg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/25/2026 12:54 AM, Andrew Morton wrote:
> On Tue, 24 Mar 2026 19:07:09 +0000 Shivank Garg <shivankg@amd.com> wrote:
> 
>> These flags only track folio-specific state during migration and are
>> not used for movable_ops pages. Rename the enum values and the
>> old_page_state variable to match.
> 
> eek, sorry, I have a finger in the dike, trying to slow things right
> down now.  I'll set this aside for consideration after 7.1-rc1.

Thanks for letting me know.
Sounds good, no rush at all.

Best regards,
Shivank

