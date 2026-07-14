Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BAF9C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 00:11:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65FB76B0005; Mon, 13 Jul 2026 20:11:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 637606B0088; Mon, 13 Jul 2026 20:11:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 501BA6B008A; Mon, 13 Jul 2026 20:11:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 24F4C6B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 20:11:14 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9F0B51601F1
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 00:11:13 +0000 (UTC)
X-FDA: 84985452426.07.6804813
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010026.outbound.protection.outlook.com [52.101.56.26])
	by imf15.hostedemail.com (Postfix) with ESMTP id B1914A0003
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 00:11:10 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=i2H7qS16;
	spf=pass (imf15.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.56.26 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783987870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=47ROepTMiYiWFVpKLb/v8LN/D3YyyeqMTQDgBZzWuRs=;
	b=GmWYIMRtyS7J4e9fwmDGEwe2O9FH7PnIBpgBpSGs6kV5+ytx03Ad4+bmCUCW8yXtyRGJqm
	Ck3yj7WMmwP2xE9VdWVvcqH+pX1BlsTcj0WR/IDvCKjEuU/LYCyLMMuuCVPaE6MH20x+lL
	LM28Y/J/MJCr7YJU/kYjJnb+6+UrXTQ=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783987870;
	b=LPAsFrzkEtfo+tRWzZWIyB7XBgUGpFCvdCI+l3e0L7GWevzuDrzmzJ42RUWPHuWxN2r2VH
	I57UeQZ6DuaylrfPkhjvGZVeRngxNlAa/yW/Qlt+ketweADdoshN5JTpnkJOr8xsMOUwIJ
	uytB3g+yW4872Sudk01UBiO5+U7PZ4k=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=i2H7qS16;
	spf=pass (imf15.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.56.26 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ld/Q18ccc67ZjQgLeyprkM+iPWKHoyqbB8v+wGdaK52C+q4aCUUhM5z25cTygkWtawPYXpdKnZTkQLqt+UlezTm3qXegDOMBsoLf7cH9GMY5axEiHf0CJh9EPc4fbNqpYL22vWgEMuB6wXZEtcNLMUiR415HgNFCJ1mzsMU1lOMaR+qeGlbjRP3gzg9huLZBxbm74VsBmrhMzjTzUODY5kHIasL+7v6Wlo1zF+/37aBPVqvYJmOwN8SzA1HPfPv3dhsCtlJR2VOWV3aZzFtlzIvqfNLEcoAxToxdMdlWRXjd9MNzaPXNjgV1GBVyKwyXjHBjytOOWJNrwt9oVZdjmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=47ROepTMiYiWFVpKLb/v8LN/D3YyyeqMTQDgBZzWuRs=;
 b=KRfMpbImpM4GVmWsiDEr7EOhZ1KiIGC/hC/JP6JhXiMRKe3D4bFmYZrj/PL479xb/pbNd3zkeK+wJZf+kv4JqHQigYaKipP52jaUtSL9ScQuv6ERwUVRYDLAM06vxzosFFMxlnct30Jga54NdUYe0dpZ5UX6h/ycj0HJJIXj4afzE6L6y1Q+9GGlC2+JjIV5lhpZUkuc8cnCgY+xVFzJ2+jJ845xNrBjUS8GjM4OLIT3iIu50yalIyWDl1omcM2otCMyCDuZQbx9z3JtSLTjByTRhw7Zhs3mF5Y3PbjzlLP30jAJuD4aKuJgIdI/p/QjokPmNIGKjQK+xDiSMZ0DjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=47ROepTMiYiWFVpKLb/v8LN/D3YyyeqMTQDgBZzWuRs=;
 b=i2H7qS16H05/P0ctgDJ5/YfRIKpgvUEFTZBqmD2Jgo5j9qG4bw5AlH0wh9lKjamZVOB1hYSAKcnlt0rdWs7ewh78RM77NdMh9tNbLzpIgHtUt7KDeBnx/fGnfl3sK7OvcJ/uXKbBLg7lyTgAcXVTW6sg2+8o7VAeS+R9WZfM/obNMyS955Z+ZWJl5hJFZyouHK97qaua2j5iIEamGp3Hi5T70bMxSiR47JqT0CfAaMSSQzob+rrmpK9/twrkUhxwInv8vC/U99kxHPTyCakX2wheKutymgwqTe7RtIVBmM+y7y70I2dQ108E9KkdTZmApweEy/dErQGwh8E5ZNk2fQ==
Received: from CH2PR12MB5001.namprd12.prod.outlook.com (2603:10b6:610:61::18)
 by LV3PR12MB9215.namprd12.prod.outlook.com (2603:10b6:408:1a0::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.19; Tue, 14 Jul
 2026 00:11:07 +0000
Received: from CH2PR12MB5001.namprd12.prod.outlook.com
 ([fe80::89e3:6df0:de90:8dfe]) by CH2PR12MB5001.namprd12.prod.outlook.com
 ([fe80::89e3:6df0:de90:8dfe%3]) with mapi id 15.21.0181.014; Tue, 14 Jul 2026
 00:11:06 +0000
Message-ID: <aaab69a7-d1f8-4fba-be13-6de109f37348@nvidia.com>
Date: Tue, 14 Jul 2026 10:10:59 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate_device: avoid overflowing migrate_vma
 collection arrays
To: Alistair Popple <apopple@nvidia.com>, Zi Yan <ziy@nvidia.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Kefeng Wang <wangkefeng.wang@huawei.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>
References: <b806c878-e1e6-4af9-8816-678955288d82@kernel.org>
 <DJT9JHBIGW8V.17SI5NN5GCJVQ@nvidia.com>
 <DJT9Q4WLXSUG.GHQOMM41P9PZ@nvidia.com>
 <DJUUUX0BK942.1ZP1I5GNIGEY1@nvidia.com>
 <89d20411-4915-43e8-9808-3a7fbd98d2ab@kernel.org>
 <DJV02L9N37X3.1THK8MN9Z2RUR@nvidia.com>
 <a29dae55-93de-416e-9f34-b7911a2c9fdc@kernel.org>
 <A1606A10-AB38-4101-A058-8355E5E81C47@nvidia.com>
 <57cc487b-6ec3-4ca6-8735-f37644e2b0ab@kernel.org>
 <F14401B1-7388-4C5A-A19F-E031002A76CF@nvidia.com>
 <alVjyqWiAggf1mTG@nvdebian.thelocal>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <alVjyqWiAggf1mTG@nvdebian.thelocal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: ME3PR01CA0045.ausprd01.prod.outlook.com
 (2603:10c6:220:f7::13) To CH2PR12MB5001.namprd12.prod.outlook.com
 (2603:10b6:610:61::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB5001:EE_|LV3PR12MB9215:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e6d4be3-91aa-4be9-ad2e-08dee13c6681
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|366016|1800799024|22082099003|18002099003|4143699003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	Sqkobhd+I6NV1opYZFYPEevHhVO059SvxQOMcC8lx2Cnu+/MfGa2tihOhgp+1dxwSPMRbcVv9J+Vw1X77Hf9ZHV1sG4FydtAm5qzWjhINKWZVTDkd0/MpFlhD22KBtyzYGloy6SYo0AobDr/0zrFhsjMq0TjWXPwQdXTwSP4XID3IGJvwu13Tr5Y6G0crFzv0sIya0cUrsWECQDde9yoRVFHEZlB+3UWUqEF4ggcrY11ynCdpMeiwL4C/LO/KVhVneQdU35dhiXyOCDKtYvprI/w+CzK8BMr0tXpYbQcXnadalUDVVfxbKNhmOey+g1onvGvYHlmuwJHGipcnBsillxWl9v5HJoB5jHHhRfFLeIv72Zofi64icwq01qEi65AwKlSWcx9FZf/P0OJfZhj+klCdadg442o8jtaTClJyy4+lrbldHwmx5oAl0a/aaKdFZ09Osz0OlGiLYOUYVhkccLqwVTnB/fkKmrpj/c6wVLeS7f2MYRLnh0cgGBzrta7llA5TvKhT8aRtvSJDnBB4dGMwt3DPLJPDEXpVNkHuQo9Iybjs+6qPaugES6vc/Et8hQ3NiPpEADKWSWD4iQ6ddE092WBgvv/Ub+UBeA5TJ0aTzqsJmeQQ3nyEya75uDp7h8YUJPGUVAMKqeZxAZrPLoceSbL+QKcHNewlQL3QDw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB5001.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(366016)(1800799024)(22082099003)(18002099003)(4143699003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y05VSHo5alNvSTdkRi9KQmdTbFNGM09Nejl4ejAyN0pMYzkzVWpwbjE2Tk5X?=
 =?utf-8?B?eGpMN2JXLzM2dTh5czNIMnQ0UzJvZC9ZTHZUSWRpQnpHNWxTVU9UMnRPYVR6?=
 =?utf-8?B?NFdPQUV3Q1RHL3FrcGNkSEVta28yMFNxVm8yaXk3NU5xSXNtWmZTa2hRTnVP?=
 =?utf-8?B?SGJvVEdpem1lSzhHZzFzSGE1SzMzRGEycWphQjBzV0xWdVNoTVd6SVVuSFBS?=
 =?utf-8?B?TEp6Z1hOMTdZY2tPK2FDWkdIblFuSmFzL09lc2VaejBVV0FYNlBaREJlRXNW?=
 =?utf-8?B?dUdRUmxiS1hFWUM2R1lVd21idlV2ckFFNjg2MmlJQThvN1dFb2Q4Y0ZTaGdR?=
 =?utf-8?B?K1lmSStnSERRNTlVRkVxVFZhNjA2clBMTVRXTnJYeVZ2MVFRMXJyN1pQeURt?=
 =?utf-8?B?YmpKRURwd3cvdlZ0WXczcytGSndXUk9RekV0dEM2WGFZMG5xZ0tTb2YzUitw?=
 =?utf-8?B?WXB2eWpLU2txVGx5T1lodzR1YmlVcURVV1V1OWF6Y29IS25leFFPeGRpYVEx?=
 =?utf-8?B?Umw1WDBWR2dDNnIveENjVkNnS05oc1k3Z1IyLzViRW5pVm9hcUNKdjVLRGFS?=
 =?utf-8?B?Y0tZdjIvQWtuaVFNNEhjWVRNWFQ4c1NYQlFsNDFPTlBrMkJ0WG56ZGF0MC83?=
 =?utf-8?B?S0tjWnRKbkhvV3NXR3diKzZieW9IblV6ZlRaR0J0Q3NHOTQ4VU82Vi9nc1hS?=
 =?utf-8?B?RjA3K1pZWHE2eEZabm1ydzM4QWMvWFlDVWJSd1lDMTN0K28zTStUaVJ0Qzcv?=
 =?utf-8?B?R21hMno1N2x6ZGVPeThRc0Y0NFhlOWVVNW5jak8xbHp2a1Q0WXpXNnJSY1lS?=
 =?utf-8?B?TzkxYnhTT1NnNndaSWZKMHVDbFBjb0t2K1pLTXJHOTFKRzJlUG91QklHcUpJ?=
 =?utf-8?B?ZjhHTTBRUWdHR2xWbFdZZVpDSVFRZXhtTk95bVFSWlV6bDNoeWRicmE3WDk1?=
 =?utf-8?B?eG0wblFKVEdqZURmZTBiUmJMM01PVzQ0Unk4U2JTRlkyUVlLTFl1cjVTaHgw?=
 =?utf-8?B?S0NlY3NTVWhhM3dzdGVlc3V2SWtYcmhMYTJtNGREU2RXdDJEUm84bG5WWmpL?=
 =?utf-8?B?aG9RK3BOcFFqWEdzQ0FtZzFDbG9PZ3pNeWY5ZGIzN1NVVjZkYnhTYXpuMVhF?=
 =?utf-8?B?R0lWbTJ0aGNHcGEvczh4SlBGZ2tOZDRPYmxob092WFM1ZE02SVNUZXpwQXEw?=
 =?utf-8?B?R3V6bVBzNEFzbEUybFhiVVhpYWZjL0FDU3A0L0N4TURLcDBBWEFRbnBjUkRX?=
 =?utf-8?B?TmJ3VldNdnJRcHo0Z2EvRGNoUmdxeDY0N0VEV2NKVzkwUndlMU1rajRvbHJY?=
 =?utf-8?B?Z0pLWnpZNFpWYmRaNndwZStZSUxYMk1jd3A2ajRkdDRpVXBPa0tqYys0UXVh?=
 =?utf-8?B?a0N1ek9pRUlpalNwWUhZVUZmM3ZCejlVV0JOOUs4L2pYUysrMUJiTC95Snpk?=
 =?utf-8?B?L0s3NjRnc3pkTForVXlYU3ZTNDUyamVZbm5DQVcwa1JxdzF3TnpQSXVDYm9n?=
 =?utf-8?B?WEJvYkRKYjBIZkU0K3hoVG5hV0laS0xFUk85ZTI5U24zVjB2Vk5lS2g1MGFy?=
 =?utf-8?B?OURaQ0RsTmNqVEtXR0RxYjE4anEwb2VoSjVZdzBSUDhNNjQxTjZPRzRYOTJF?=
 =?utf-8?B?NkJyTkJwQnNKVXNaSzNBTG1HY2U3Zi9OdVgrWnA1b2NoMTZ0eVhNYXhTM2RM?=
 =?utf-8?B?Ny9MVVdxSkJ0Nit6dHl3dWpwZEhlWGM3QTg1L3c2YnZtNjBrczhieXBkS0pw?=
 =?utf-8?B?OW9PM2tQN1BzMnAyUUVQRFR1Ulg4ME1NL3JOc0hQK3NpWFpDeFpCa1B4US82?=
 =?utf-8?B?L014dXpSZWQ4bEo1L2N1ZFZQbi9heTN2RkpCUjRsWTdmYXVuZVprK2FKNE1W?=
 =?utf-8?B?bVQvOUR5djRjQXlEN1FvakU3a09YM0NDZUV5UXVwMzgwYUgrSkdBK0dDeVNB?=
 =?utf-8?B?NHhwcE1jbERqZEY3SGhySkFmSkZIbExZdG9WaWUyUlNyL0NFQnMzQ1E2Q0sw?=
 =?utf-8?B?bWdnbUZ4Q21OZlhqcjNNTmVmVVlsVTZsNThKRHRJWnVxQk4rOFUzWVAyS3FE?=
 =?utf-8?B?QmlwNkY4TE1jWUg2bkhQZW9MaUJCenNMWEJEdkI0blF2S0svL0kzZDZPL2RS?=
 =?utf-8?B?SmlSejNNZi9YblZDaW1oUUdEOE16TWt6b1dGbVVnZ3V1WGxzOHJ6Q3Z3ZlpF?=
 =?utf-8?B?RjZRRi9BWk0rd1U1QkY1QmtNZCtnMWFndk5FODNxZVpIeTRsOGlsRm5YalpF?=
 =?utf-8?B?b0t6NmhobHlGQ0dWZmxSN3FCRWFqUzRqYmR5Zmd0Ryt3WjZNTGdtTm5VbWJS?=
 =?utf-8?B?YUNubVZNRG9hZEk5RVp6MFgvS1NyWWVVeE1pWVd0cW5yQnNJM1RiZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e6d4be3-91aa-4be9-ad2e-08dee13c6681
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB5001.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2026 00:11:06.9056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HIHzsy51bhvEh14YbnWceafJwiwB8U2aTtALWIunKSGBkmHM2Kk//FvKQShsWXvlgJpPrfsWbU6VVmLkQLMSQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9215
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B1914A0003
X-Stat-Signature: 33io5hwofkcuq7nm9ug8dewyxh653889
X-HE-Tag: 1783987870-575350
X-HE-Meta: U2FsdGVkX19ji5sK1U2hqoBbhEv7W9A9D3ognXiCD0Xmglmn19/nza8L5dYwcuyrsjHvTHZK/N4SfgZpNKCSiyXLTDyawTcA6a5druGmNosN5YqntMm21EK6NAqhu7G1kYJGc+bQOy0Yc8h8bbSca+h9w28egoAKGGo7auwo7trCkBurdDYwxSFuww0qoffaY5Z5fQ3YyC5p+NOzM6nEAaLl6aCi5jTfxKKOlt6YlKq9dbUCkAwzTmU3YyOrQTMFbAwXBTaYjpyvG5AkVy4MtIk8wiIYbFhpeKpn7tZrrssm7KRJxpDF4NPJfhDdD5HDOpEIOfHe+7qTGl8FDyfs/zxaA30a1iWlnP4fpVwSMx5WaSF9Uwx8JuOS577D5+0eeOi/LeuuaMFAX0fqTt3gBVtaVSWIhX0D13yVbgaISRjT/OQe1pEwt6/Dl4aOjuz5ICMmZsBDnFyemjjsONzTj6P+6Ze9O+lcPL/oShNt8udyzM0lcZyrJV5iut7eyH2o48ebxsN/jtkvzwm7+qeZG2H+h9oZTG029UPd3TA6GwXuUdh/5oImvEdhtjkwcG+XJuZvUEUNcBIUfO93qZzDFvhQBSLhIsI74sSTIBDGtFCley7Nh/A3gPEwbX0SfF6a9zpqpqmURxbGddfVWI0XXHnDgRWS3RVzeEoNjzVCd3sph+bMwQquitEp2BhnRX0GdhAn1kIZ1QuPOY0qL0kL1bTzIpAvw/mRoYNK4vHJeQvDu1XpjL3EMk9mdZfQUTSUsSwnxkVktaTrFx4o7mBgAZXEblXjqzhwi4dITSGgoPB3R1MwyWrIvTAFJIWrYcWOQwSYFFeFj/mDUAcHu0eHQ4nYZLVa/SpRSEa2JGdy/+JUYEOqWPbXPVgcyTJgKaF5cXv0sGGQifM8hldy698V9vLI2F3Rxp2KI3wVoP+OTBx+VRya/LUjQJ7RZaoUMJ7LYDHnVEYwrIsv1Xm89p4
 S8qg9/wH
 KQUjPFu2/SQ9GiQX4Awsoq1AO76foqYuP9Y9Obqri3rZAGcbWJ4l2YglxNbmDyoWYRJWQtCDzyC7GNmJfRe5OvJBGoMx8iBAh5PYFyAo2+7FvfgUjTNsF4y3tEhd4HutEADk4fKHNNeB7SrvT6P+mB7Y8/ec0zZ1NfmRav0yAuSS70dzmewARA4O4uOqPsfSsTNErgrVfPBM/WRZX/4SwOwB6pDKPqJlIuAMxGi+4VJsUbz3qRb2En30EWxg295yb3OYtRzNfEoE13V1bV38rn6Ou7KkSRbodHDkLsCahm4Oq68Op+MSDcZV8vTYEsgD8L9ESZxeIXdNitsdjZJIUhIHH6lnfcanO0ynaJNnKXU9FqIRt23qwWia6yEWBQ2pVK7zgkbiNueoRm+IPFqzO+hyhSTEaHJ3geNiTRd6+d9P+BVnRof3rA6L2E3H0aZiwXTW5jVkb+Deuf1fe2jThvyvzyxTJH4Lks7abp0Kdffd1ttBOJYGYQOv7cvAlu3hKQYBuHnkxMuZZJ7V85rYpxIdufbsuI3LFZ8Rt0Ttw6XEKmMvTpoOmd4FB8IXVQ2oRraxo7GimRH1P9hc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/14/26 8:24 AM, Alistair Popple wrote:
> On 2026-07-14 at 01:39 +1000, Zi Yan <ziy@nvidia.com> wrote...
>> On 13 Jul 2026, at 11:25, David Hildenbrand (Arm) wrote:
>>
>>> On 7/13/26 17:20, Zi Yan wrote:
>>>> On 13 Jul 2026, at 8:57, David Hildenbrand (Arm) wrote:
>>>>
>>>>> On 7/10/26 17:35, Zi Yan wrote:
>>>>>>
>>>>>> Not all the time. After a folio split and PTE lock is dropped, there are
>>>>>> different cases:
>>>>>>
>>>>>> 1. no page table change, the collection grabs the PTE lock and continues;
>>>>>
>>>>> Yes.
>>>>>
>>>>>>
>>>>>> 2. some PTE(s) is changed, the same as 1 and the collection continues;
>>>>>
>>>>> Yes.
>>>>>
>>>>>>
>>>>>> 3. the PMD pointing to the PTE page table is changed to either a leaf
>>>>>>    PMD or an invalid PMD, the collection cannot grab the PTE lock to
>>>>>>    work on the remaming PTEs, since they are gone. For the collected
>>>>>>    PFNs (they are mapped more than once) and folios with elevated
>>>>>>    refcount (they are mapped once and unmapped here as an optimization),
>>>>>>    they will be processed later in migrate_vma_unmap(). Since
>>>>>>    migrate_vma_collect() is best effort, there is no need to revert and
>>>>>>    try to recollect from the beginning (to get that possible large
>>>>>>    folio or skip).
>>>>>
>>>>> Yes.
>>>>>
>>>>>>
>>>>>> BTW, recollection will be more feasible if migrate_vma_collect() does
>>>>>> not do unmap singly-mapped optimization, since in the case, no PTE is
>>>>>> changed, we just need to reset migrate->->cpages and migrate->npages and
>>>>>> restart from the beginning.
>>>>>>
>>>>>>
>>>>>> Right. The PTE page table should be gone and the original PMD, pointing
>>>>>> to the PTE page table, becomes a leaf PMD or an invalid PMD, since
>>>>>> someone changed it when the PTE lock is dropped.
>>>>>
>>>>> Right, so I guess we'd have to remember how far to rollback, and rollback would
>>>>> mean resetting migrate->->cpages and migrate->npages.
>>>>
>>>> For case 1 and 2, we do not roll back. For case 3, since the PMD is changed,
>>>> we just roll back to the start address and set migrate->cpages and migrate->npages
>>>> both to 0.
>>>
>>> Can't we walk multiple PMDs and have data already in there?
>>
>> migrate_vma_collect() is the pmd_entry of struct mm_walk_ops, so it only
>> walks a single PMD at a time.
>>
>>>
>>>>>
>>>>> And for the entries we rollback, we have to decide whether to folio_put() and
>>>>> whether to folio_unlock() [fault_folio != folio]. That's the confusing bit given
>>>>> that the code is rather "interesting".
>>>>
>>>> IMHO, it might be much cleaner to remove the “unmap the mapping if the folio is
>>>> only mapped once” optimization, so there is no need to roll back at all.
>>>
>>> I guess most folios are only mapped once. Do we have any numbers on that?
>>
>> I will defer the question to Balbir, Alistair, and Matthew.
> 
> Unfortunately previous tests that I've done showed the optimisation is critical
> to performance in the common case (ie. singly mapped folios).
> 
> I say unfortunately because I have similar feelings to others here about this
> code :) I tested this a while ago because I was trying to clean up the collect
> step by mostly removing it and replacing it with a hmm_range_fault() type thing,
> but the optimisation proved too important due to unmap having to do another
> rmap/page table walk.
> 
> I don't have the numbers on hand atm, but will recreate them just in case my
> recollection is faulty.
> 

I had a patch to add tracepoints to the code and some of that instrumentation
included this data. A combination of the trace points + hmm_tests will help us
get some data to start with.

Balbir

>> BTW, for this patch, since there is no bug report on it, we would like to
>> fix it properly without worrying about backport, right?
>>

