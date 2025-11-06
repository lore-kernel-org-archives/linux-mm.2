Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D89ECCFA05
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 12:16:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30DDF8E000C; Thu,  6 Nov 2025 07:16:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E5A48E0002; Thu,  6 Nov 2025 07:16:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D4548E000C; Thu,  6 Nov 2025 07:16:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0B6648E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 07:16:56 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AE50DC06DA
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 12:16:55 +0000 (UTC)
X-FDA: 84080081190.07.43B3D62
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011053.outbound.protection.outlook.com [40.107.208.53])
	by imf28.hostedemail.com (Postfix) with ESMTP id D0B1EC0004
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 12:16:52 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=eaOEXvAk;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of shivankg@amd.com designates 40.107.208.53 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762431413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=L2KyRbNg/UZpRQZmzIPKui2hiGQQh4NCHD5QoP7Funk=;
	b=Jtd6wfPhXi03nGWqjyvBolYrERz3jevDPA3cVDgQAA1nE8uIYGetm98FBzDLzjDEP7uu8g
	2mE1DERvlc0MWMV4dOQCr4o/vYa8KSSoNyvu7Rk1bdGvnR7pj9sN+sO2KkgjhQimwTFtJp
	EzqV34c9G14xmtlonhLgphcnhg1whgI=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=eaOEXvAk;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of shivankg@amd.com designates 40.107.208.53 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762431413; a=rsa-sha256;
	cv=pass;
	b=4D9q0o3axrP6jT5ZBLxD0LxcETcpkQLwb3rwEXW0kSMQJRiRZcnmH2CeuTf14GJF9XjOA5
	/SAWOO9UboFb7FUBKivNZMVnVYW2qpbiF1L3OJE50ErxcUwQZSfyFPVobB2rH6oJNBGQzB
	Uf+aoQwVoGfHUr/OkXXvUX9CqkMf/2E=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WNUW4mUQoULdKGx2+1S7fY4um/fGXvd2qrq0EMnS2eRLLfpQGNAvrVanH+24DjjnBdUzaobUY3BWkCWBM4ZnBXb5k7XcZlauCAeG7nsP+Qg/2rRPNdb4q0eHfbgbOtL1tLwb9unhoaknO/Nug/YapyK8K8Ra0vprWSUI9ParJndDS9w2z55itZDkewUXWnDTjLArGLdxk1fV0AX8hqj5DGkw21meDj7nOxfggsDSncsmdvcvLTXn4pWLCZR0TUrSN4L3rx0/q56hElYWdeqTllIgoE498utNHZVvl6ImRmy/d4CRNFTMvwTBrP/9IsSCdv7wq580GDYBRX2KeuxDrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L2KyRbNg/UZpRQZmzIPKui2hiGQQh4NCHD5QoP7Funk=;
 b=GqECWppSfoqMHt3Q68LcZ/iLAFDPpFlq4T78upbZ8QRolZ5a/rFewbNw4A3gJ5Pw9+74bDhXZ/CBnibJYP4q44CtcZZ5ntuaVZBRcPHiDAE5F+TSUhYJDe9ABlVguV1hTkSBmbjrPHaxxa3xlhN/qhIfREt1LIP7hUKTV6Z2XLmIkC8wR8Ee5mTbMA1hU17ObugxtBodZ+bOYJoBhL3woPbFQ2bDoMIqJOxyFypkiywO3pH2eorMSLfDKHh26X2vlfGpPfJZ7X9GDWWPkLZ79pTeOjvgcmDaLrMExgF0Ztl4QiLMESbGM+2wjVl+eEi5Qjr4+Ao6cHLSpbjJVPjr8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L2KyRbNg/UZpRQZmzIPKui2hiGQQh4NCHD5QoP7Funk=;
 b=eaOEXvAksKWtVYzpc9+LyXar1iEmGdj0p9ILP4dLi8StWvSz5W7Qq15iUXA/1tLKLDbDJBcbqSKbWgaihtaV+pWevfYwHQHSCb+YCa5ZrWres1NpK0nJnNemd4tUTmpxOf30eJBQnthFL7f9/juS5vnsf8fPvu6LM0oE/we8zi8=
Received: from SJ0PR12MB7458.namprd12.prod.outlook.com (2603:10b6:a03:48d::13)
 by MN0PR12MB6224.namprd12.prod.outlook.com (2603:10b6:208:3c0::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.8; Thu, 6 Nov
 2025 12:16:48 +0000
Received: from SJ0PR12MB7458.namprd12.prod.outlook.com
 ([fe80::83e7:e6cf:26ed:2f3d]) by SJ0PR12MB7458.namprd12.prod.outlook.com
 ([fe80::83e7:e6cf:26ed:2f3d%6]) with mapi id 15.20.9298.010; Thu, 6 Nov 2025
 12:16:48 +0000
Message-ID: <4e26fe5e-7374-467c-a333-9dd48f85d7cc@amd.com>
Date: Thu, 6 Nov 2025 17:46:39 +0530
User-Agent: Mozilla Thunderbird
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
Subject: madvise(MADV_COLLAPSE) fails with EINVAL on dirty file-backed text
 pages
To: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
 zokeefe@google.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, shivankg@amd.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4PR01CA0053.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:274::14) To SJ0PR12MB7458.namprd12.prod.outlook.com
 (2603:10b6:a03:48d::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR12MB7458:EE_|MN0PR12MB6224:EE_
X-MS-Office365-Filtering-Correlation-Id: dddb249f-c7d8-4b21-c536-08de1d2e5bf6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SFgxQStLcWdZOXU4dTFCSTE4bldMNmFxa1IzSEdYd21oUTFvb2JOcnpYOUhV?=
 =?utf-8?B?ellhakVFOUhHVkxWTmVtYkk1dlNpSmYybGk0czVFemhUZVVsUjh1aXlHaW8w?=
 =?utf-8?B?OVF0MDJzWlFScGFOL3Q2RFdBQXptWkN0RkhyTVl1ODJBbVF2bHFleVo0SW1U?=
 =?utf-8?B?eERIbXFxYThwc012Zi8zWGY3RUZ3b0w2aXlMQXJyRXk1WnZPN3VXVU1xT3pj?=
 =?utf-8?B?anYxYmo4STllQTU2SkVNKzMwS2NNVWZKTDFUa3NvRnJqNHFlS0pkenk1ZHVH?=
 =?utf-8?B?ZTk1Ty9LbWZjcjVDUkhadkIwOVpreFJDTnpFNnYrQ1pLL0RCT0JnYzl4WmpC?=
 =?utf-8?B?WXhmTnE3NjgzV0U1TVgrZmtJUlZ1VE43dnhML25lVUVjeGFxMWN1RGh1NWg0?=
 =?utf-8?B?M24wWnR5Zm1hNmxOZHBYdnIyQjl4Q3NtZzVKVXVXVnBSeWExaXI5S3BMR0hU?=
 =?utf-8?B?Y2NyQlpwa1NsVFFQdzJEeDEzZUlRS3BGZis1OHVldGhCVjIzd2pscXdFVWVr?=
 =?utf-8?B?UkJVR2kxeWMrVGZ0RGFRUXIzRlhwZ1czdDk2QnNGVnZwY1V4U0xKWENBaXdZ?=
 =?utf-8?B?SDUyeHJDUW5jVm1FWXgzRVoreXJNSnJnYlVhL3ZhSEtxNUMvZlpBMWZJdElF?=
 =?utf-8?B?K1MyaXJxZGh6VTN5anhheFFnUGdRYXh2cktFWVpERGZOYWtBanhLbVZJYkpG?=
 =?utf-8?B?bUljckxsSkJia1pLZmpvSEtlSXNnK3NSdHNMdHNxcjVoQnpsNWdWdFJGQXhx?=
 =?utf-8?B?UnhrcmdDdXNYUkVTRmEyYkV6U0g4RU9CTDAxa0FBSDRhR0JnS29zWDRTVEdC?=
 =?utf-8?B?OFh3bG5oUlFPaXQ3aVBtMm9yQytXK1hjZDV3SnBVdlhTTHY2VGpGODhndUpi?=
 =?utf-8?B?QWwybXRhWGdTemRjMGh3OU10dnBXMjgxS3I4dXpmYytHOWIwanNTQk9jMTgy?=
 =?utf-8?B?RHBuaWR6ZUdZbW1CWHowK001SStUL2Q3MGY3YnRKOG9WcUEyU2h0Ny9iQkph?=
 =?utf-8?B?WDdha1kvSlVBZ0pUU0QvYitPc3J3eUt5cERiNXIxY0pCUm5UK2UzUC84TmFI?=
 =?utf-8?B?a3dONHl5Qm5yQ21YRHhoMGpJNkUrcEw5ajVWRmR4ZzBWQTR2V0VUVWpma2Zm?=
 =?utf-8?B?YlJGZWQxMW5yRmw2SzJWOXJDd0RSYm83MGwzSEpld0FWNVVFZWJoSkxLVnVB?=
 =?utf-8?B?Z29vMTFiUTFXRHJ6UGFpUnR4ZG5GMDRyNjFkd2JlOXFYSzg2OHI5MXlHeVBY?=
 =?utf-8?B?Y050VDV5bCtxbzJNWkovaFJ0bWs1OEwyME1LQWc1M2M1MU4yUHlYM2hDYTE1?=
 =?utf-8?B?cDIrbDZXSUsrQ1U3Y1haV1Y0dzhzUjBCWEFWdDhxbkJ1eDFSMmRsL3BaMnRt?=
 =?utf-8?B?eEVHMlA3amRiQ2RVSUw4ZnpEUzZtbjRYWG5uOXk1UHphZXN2TlQ3QTJzRWNJ?=
 =?utf-8?B?d2tiVStSekd0R3VmdUZpK2R4V1AxMjdzT3dQT3VUWkV0KzRHdGgwdCs0SEJQ?=
 =?utf-8?B?ZHUvSjh1UFNoS0MwNmhtY3ZKMlhLZlowQmRNK2FSaCs4eGlzS1J2WEdoWTZN?=
 =?utf-8?B?UzhQallWOEE3VGw4dUNzT3VaVVluSnc4eUU0aWJGN1ltVzNUalFNNmM3UlJP?=
 =?utf-8?B?U1dBWmx5a2c1TVFaNVZOdzU2NUIzaHFQanh0Z2kxc2lqKzZ3bDlZUEZ2cGx6?=
 =?utf-8?B?ZkQveGUvQXZKbTNYTkV0eUpBYlVBcHEranhJYTVreDFyWnVHKzhEZjVJQ09m?=
 =?utf-8?B?Vng4SUhsUjhLdkJwYnZFeWNidmZCdGI4c01JMmVKc1E3ZFVWa0l0cTNxTEV2?=
 =?utf-8?B?NTNUVytQdCtDdWxBSC8wZVZ6Y041eWZPbDBlWGV2TVBzSHd5M3ZsQUcxTVhy?=
 =?utf-8?B?dUNPSDdDZG4vVTZJSlRHT2tkNCtGRFh0V1B6MnBFdElSYTZXZHp0Yk1hUlVn?=
 =?utf-8?B?REdnUFA3am5Mcm01Wnp5VEJtcTJvVURpS3NpQ2Q1OXFHK0c1dmcyM2xGbzJL?=
 =?utf-8?Q?rrAScez810vttRP+2m83Ea64TWWaBM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB7458.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q2dYYVVET2xOL2pZMmd2Undkb1ZZSGFOOENYbjVLa3NDK3JVK0I5ckZsV3dl?=
 =?utf-8?B?UkJoTkViUUpvN3pEYUVLelJLSzcxVzN0dHhBUmMzTVJvVzVORmQxYUkvMmtE?=
 =?utf-8?B?amFSRG1LSG9VZkdOenhqdlZYTExaWFVlWW8vZEdUeS9WK2txeXVxb2kydWRK?=
 =?utf-8?B?VE9SMzNibXVpY1BaMFNlY21wWHN5MVNhM1VRL3pqTjZkYWR1bFJDWUUwaG5x?=
 =?utf-8?B?TzhnUGhqV0s2YW1qRmFtdFNZbmVhUlRNQ0ppczZMejNOdmRLRVZKbHlOWTdK?=
 =?utf-8?B?SXV0M2thWnptQ0RnOWdxNUpSbm8rVWJ6MlBRNDdNRm1ZREJTeWZqY3EyclFy?=
 =?utf-8?B?SFd0ek1LdHgyTG14dFByZExBeVBweTlINzRlRFJKRFlEeWRYcE16R1J6TzVQ?=
 =?utf-8?B?YmRtWGNxRXo1T0dqdm9SOXc2bmVadmFodVJHMXpjOWpQalNHdXNnMkxIVnpM?=
 =?utf-8?B?RHRUMGF1L3FaT0VPTzczQk40K2lXWWp0aEN0UmhoVk5NYkZJdDNMY1NCT2JB?=
 =?utf-8?B?MTdwaHQzYkNxaXZiNGh5QWtBWW1Wblk4b3RWdWlhOUx2RkxHcXl3RTJMaU52?=
 =?utf-8?B?MFA2MHM0Zm51MFRHaFJWUm43R3VaVXZqdHk5dUN4c3JYVG51SlIxU1NRRGxu?=
 =?utf-8?B?T2JRbjUvZG5JNHhDRVFIcXFlS3pwL0JSMS8rWjhKREV6cUVVUk1YeHZ0L1lr?=
 =?utf-8?B?aklCN2s4NFpMejBlRXhFaTFYWi9CR09sZ0c0VGhOVjh4bG56RDdlY2FOYUFI?=
 =?utf-8?B?cUZHMldyck93U0h5ZmwrcHhnRWdMeG1kY0pJM3BTeVlJalBITThtYTRoSDJw?=
 =?utf-8?B?VDBkRVdNUUdMbDJBMm5JZU5FazVueUZQMStNb2oyWUdORjJKcTcvK2JMNmFk?=
 =?utf-8?B?MktPZUpiNk9JT011OWNlc2pLcVRBM1g5bGpiYnU4d1NZeHN2ZGNwRHlvUzBP?=
 =?utf-8?B?V0N2dGR4eUFrek9MRkxZMEJydnZaR2h1TUNOQUpNRXlpZTRYcFNPeDVCYXNG?=
 =?utf-8?B?VTlSdEp0STFDYW92VEhJOGl2bWNWcEQrTm9PaSt2bFFNdm1rbURNTlJ2bUpz?=
 =?utf-8?B?TWcvaEg4K29XMGo1NFFLbkw5NkVpa3U5dWQ1YjMyM3p2bVg2RjUrRFdqaG9s?=
 =?utf-8?B?NVY4VWt6K3JqcWYzZzh5UWxJcEhqbEg1TWNGUXNDamxJLzZhc0F6dC9KcmJw?=
 =?utf-8?B?QVhCRTBUUWMrVC9tODJpTGVMdzlrVEhVRmdGQWd0U3lWMU1WLy85WEFsa1Z1?=
 =?utf-8?B?YTFJWFN6WlZKSUtCeHVPYnQxalVXLysrdWRVL3lnQVlrdThZYS9Qc0xkRUxn?=
 =?utf-8?B?Q2R6TFpPbUdvd0VWOVdJa3RwOTIvaE5CNTBGcStrcHNGalZiV01HNFVyb1Zz?=
 =?utf-8?B?QTB2aUowdUxrdytWV3ZLUlhGUnJEZzAyMVU0OXpCSkhkMTkyQmNadXdsSS9G?=
 =?utf-8?B?NFp3WkFlVWtoVGhTVUJRSkZYd1RCYUVZcGpTYytSOGZqODdOYTFNQVM2akZB?=
 =?utf-8?B?N24zT2d6UFh1SFZsUVlmUERjamlVckZwaUU2d0x2aldNbEpBeDZxamorZnN5?=
 =?utf-8?B?bkkvaEh1Y1QrTFFJcXpNTDZhOE1YUktmMjZyU0VTWjZUUmFka1hkcG5TdllP?=
 =?utf-8?B?TTM2U2lCK3dJdVhJa01mODcvSXZsdU8yT0YwSXVnOG5jNUc4MjhwOGlPWnR2?=
 =?utf-8?B?dS8rYWZMU296UkhGckppUkswdjlsOW45eUZYNE1IUjlZTjZ4ZW9XWWErVlRN?=
 =?utf-8?B?blJvY2M3eXFEV0ZQT0NEVlZNdjgzMmZTMklrRVk4NkhVWDczZ2VHaU5oZHlk?=
 =?utf-8?B?dDl5MFFiM1JYRDZTTk5FdWVybzlLT2tkbUROdUFudEFqK1lGVzJrQjFVZDRN?=
 =?utf-8?B?ZkIxVFhlcHdSeEF6L3pvMG01VkMrOThRVnBhcWtLQmRPSnRHVkFQaDNKMlJs?=
 =?utf-8?B?QVBjQVlzVVJId01nQ1R2WkZjaENqd3ZYZWNKZW9pVEZqQkhianR0QWJEZnA0?=
 =?utf-8?B?dWY2cXdIUzlFSWFubTY5Mzhpd0NQZGZzWEswa3I3dzZ1bUhXMWU3N0xwVFJz?=
 =?utf-8?B?MnhOL0FYTkJMWUp1cFZXQ0NKRzhkMy9wNmF5MWFFOWVvZC9HOUZlLzYwSDk4?=
 =?utf-8?Q?R6leI+uwdk+MY2rPv6Y/JKa9P?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dddb249f-c7d8-4b21-c536-08de1d2e5bf6
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB7458.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2025 12:16:48.2876
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VIze/f0foDf4Hknftu+SeCDrtgFuhpJz1nQ0tLgu927OxhuAzSmlR5FluAaCNQDWkqjsHdRG0zzneVkVyezSOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6224
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D0B1EC0004
X-Stat-Signature: a7iwiuuhzjiegtiy1e8du69fi74589nc
X-Rspam-User: 
X-HE-Tag: 1762431412-664731
X-HE-Meta: U2FsdGVkX1+d65ok9OyuFp32NlYZErygY4kKStB9bYU4Ro+eGKC+HbD2E+LzR6Ia9BLQvSOIF5bmaF0AkpvdzXsWiO0oFVijososwE8OcDqte7rCIjnp2DxvhZ2PsMPIGqRMlmWDWwDMovgz1a2dVgceBpYrl25Z1bTS6dMQMm/BFPjG+KpN5/4kBpofo7uIanogpi17/YjUA8rMCG17FFDtvqlTSNq4lBb6l45Dre89iqfsg0bA97TBeEXw5NBXUKqbD5CSgQFzZzhl8SY0MUTgiUSCr+fk/1ne/N5tlJT8fYkgfU2bduqoKonJZfygBnAbHkzafkLK1GjvFJ3HK+O+KUH91YB/W3jguPdAUUioWcfOPd8NT+YaAfHqug82dWQks4L7fFOxWKUaRrOoo9zQ4CTnHgvmwYf88pi0O2iW0uvT0qd6/VKFO1C3kzy53trWZEFQYvGnwNimldRozFSI/1TD9O0arVl8Qv7foD8DtMLoPEM21DeZL+t+V2GNuIQ4k3knj4PU04lLBUCE3YYBoYezltFGtSmyoBN5OJSBalzqBkFKjz2gEGBvEEO+30oIQGfTU+4bHEl/19XtzCK4/xYEW2eTY/3vGSmSEYc/uP42VE6DfvPI10fLL2Nwk1OKNl60+winlcMi7ZSYkX+svRbcjeMcuhJHDh4dE0TsWDHbYkAPxwltmH1rOCECLVjEYr9NdaZ5U/4BnMlUTtbqxlHdGMWrq3l4lutTJor6eJqeBPpjXc+YzNq4h1PQUlmza/6JvvLJlWFpGdMaVUHA+sBL0T7pF8qMdG75CbqSS09JX+D4gvtFYFFjh37l97eNFHIVUSQzq++vKUgGBaB7Tg3rXhsTurlNGyW1qHWCignw0LOdPtAUwAxJO5c3Im8sWtUGzh4u6Mi7bk2Z6frYQK0FYosZuHWC5EODuWj0Hz4ZF5Dow9l655zrY9tm2TDOgzIta95Hy8tvI5o
 STpawq5V
 CM0uXFbtN00c/9aKG0pd8WcRZhIjKGp05MApZc5hlOhxojodEMxfYCRBnonjM2+dlGXmMM49fHgqJqcJKfy87BdU9PFM2Yll248+2V1JTXZOR3UkmxeEHEKeqARkF+oLFt52XWU+avxl8IZ3ShOxM2h6qFsKS3UhJVyXRVO+nTjhWEjnAkrHXIvMa6FIatmoESUuyixm6SzjYMnjD9hzR/3sjTxoPhA5vyq+FKyaY75O2CBuP0JRaGjHSwGlLroMRUuTe+qbK6bO7koLJqJm74htU3iG6xqBgex76mPz+1QLlNbKb+9YgcLIFeTuE93rek9+z/R3uXqgCXHeiRQjEoDQXXqwGM3RfIdHkEqJstj/yOFaBvdjaHO6O15jYFVL99QTboS0zoxK6FtFs361WPrmwfSVY0FbKYIoqo/H4nWUvGtQafmMgwa5tOrIo6ZlnwUPo5qYCatfyjgU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi All,

I've been investigating an issue with madvise(MADV_COLLAPSE) for TEXT pages
when CONFIG_READ_ONLY_THP_FOR_FS=y is enabled, and would like to discuss the
current behavior and improvements.

Problem:
When attempting to collapse read-only file-backed TEXT sections into THPs
using madvise(MADV_COLLAPSE), the operation fails with EINVAL if the pages
are marked dirty.
madvise(aligned_start, aligned_size, MADV_COLLAPSE) -> returns -1 and errno = -22

Subsequent calls to madvise(MADV_COLLAPSE) succeed because the first madvise 
attempt triggers filemap_flush() which initiates async writeback of the dirty folios.

Root Cause:
The failure occurs in mm/khugepaged.c:collapse_file():
} else if (folio_test_dirty(folio)) {
    /*
     * khugepaged only works on read-only fd,
     * so this page is dirty because it hasn't
     * been flushed since first write. There
     * won't be new dirty pages.
     *
     * Trigger async flush here and hope the
     * writeback is done when khugepaged
     * revisits this page.
     */
    xas_unlock_irq(&xas);
    filemap_flush(mapping);
    result = SCAN_FAIL;
    goto xa_unlocked;
}

Why the text pages are dirty?
It initially seemed unusual for a read-only text section to be marked as dirty, but
this was actually confirmed by /proc/pid/smaps.

55bc90200000-55bc91200000 r-xp 00400000 07:00 133                        /mnt/xfs-mnt/large_binary_thp
Size:              16384 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Rss:                 256 kB
Pss:                 256 kB
Pss_Dirty:           256 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:       256 kB

/proc/pid/smaps (before calling MADV_COLLAPSE) showing Private_Dirty pages in r-xp mappings.
This may be due to dynamic linker and relocations that occurred during program loading.

Reproduction using XFS/EXT4:

1. Compile a test binary with madvise(MADV_COLLAPSE), ensuring the load TEXT segment is
   2MB-aligned and sized to a multiple of 2MB. 
  Type           Offset   VirtAddr           PhysAddr           FileSiz  MemSiz   Flg Align
LOAD           0x400000 0x0000000000400000 0x0000000000400000 0x1000000 0x1000000 R E 0x200000

2. Create and mount the XFS/EXT4 fs:
   dd if=/dev/zero of=/tmp/xfs-test.img bs=1M count=1024
   losetup -f --show /tmp/xfs-test.img  # output: /dev/loop0
   mkfs.xfs -f /dev/loop0
   mkdir -p /mnt/xfs-mnt
   mount /dev/loop0 /mnt/xfs-mnt
3. Copy the binaries to /mnt/xfs-mnt and execute.
4. Returns -EINVAL on first run, then run successfully on subsequent run. (100% reproducible)
5. To reproduce again; reboot/kexec and repeat from step 2. 

Workaround:
1. Manually flush dirty pages before calling madvise(MADV_COLLAPSE):
	int fd = open("/proc/self/exe", O_RDONLY);
	if (fd >= 0) {
		fsync(fd);
		close(fd);
	}
	// Now madvise(MADV_COLLAPSE) succeeds
2. Alternatively, retrying madvise_collapse on EINVAL failure also work.

Problems with Current Behavior:
1. Confusing Error Code: The syscall returns EINVAL which typically indicates invalid arguments
   rather than a transient condition that could succeed on retry.

2. Non-Transparent Handling: Users are unaware they need to flush dirty pages manually. Current
   madvise_collapse assumes the caller is khugepaged (as per code snippet comment) which will revisit
   the page. However, when called via madvise(MADV_COLLAPSE), the userspace program typically don't
   retry, making the async flush ineffective. Should we differentiate between madvise and khugepaged
   behavior for MADV_COLLAPSE?

Would appreciate thoughts on the best approach to address this issue.

Thanks,
Shivank

