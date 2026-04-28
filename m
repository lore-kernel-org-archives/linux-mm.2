Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73C92FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 06:10:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C98986B008C; Tue, 28 Apr 2026 02:10:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C701D6B0092; Tue, 28 Apr 2026 02:10:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B86026B0093; Tue, 28 Apr 2026 02:10:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A7DFE6B008C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 02:10:36 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 68EDA140443
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 06:10:36 +0000 (UTC)
X-FDA: 84706940472.19.CB86976
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011030.outbound.protection.outlook.com [40.93.194.30])
	by imf22.hostedemail.com (Postfix) with ESMTP id 841B1C0010
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 06:10:33 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Vf8uFh7j;
	spf=pass (imf22.hostedemail.com: domain of shivankg@amd.com designates 40.93.194.30 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777356633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bqORCVo1QtToIAMda9Mfgj7ZIuHJh6GLPTChW2g05rI=;
	b=UU6NqHj9wiXYd+PkG9DlkU3g+vjaS4kVAW6z6e9JkLhuS/isc+pMV6uDVd6FS2K9HsNoVg
	NOo8tXRgM0OpN5vxwzWtey+fxUmK/Q92DkUWAaXTz+FEZZSUNlniIZfkuXJ+aIJ6xwWHeO
	qlMU6cTjRyimKUbSZ0j+osDrALjlIVA=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Vf8uFh7j;
	spf=pass (imf22.hostedemail.com: domain of shivankg@amd.com designates 40.93.194.30 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777356633; a=rsa-sha256;
	cv=pass;
	b=WhsAKp/EkL82+qcspvEeR2mXV5GxXKmXE3gsOHdmKbkVnWuEgIYBp/OZtlfDnqbcU0DHSn
	a416l6cW8RPQbJray3DP3DG3clsvtboZuWGvrwvPkFSazm8JWogF/OjoyCUhyC5Txmi50n
	yuQ6S8NYTnFkloZZFRRui5Aqjvw6sgo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yywW4e58hvY3SjUlCSDGgbsyFiihwp7G7mUYc5fH98fRFqqGS45FNqxhus6kgbRFVRw0XMhc9hIc4FfDSUa9yI6wuadnRY1ivoFpRsq9iozW3Xb2SkKrbRYJxdj/mvDYkUbjmi7bk7wNIEuyyYvEgo/NGwE/03VHidTG9UNM/ZDPUl9W7y5ifs1ciTvmWp0dpArEYmeI/s/zaiUEH9Ng6d/oRqEdlrvXdtq4Kz6STmWo2nU7L8UgyOubm/X68KAEwRkiNLexQ39NRdS7yu1x6Ds+ZTavSTFDeolL0I/OA7+Da9yRyJaZsrrxIvH9s5+cYR0sIxJRIj0cKd5szO1QuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bqORCVo1QtToIAMda9Mfgj7ZIuHJh6GLPTChW2g05rI=;
 b=E8zInLawMEYN2pi3DRtG7vEFa2q6M0h8li3TuDX44wGwok9ORt4hWcsw1K4f9ftfGs64Tzd1r9cfuHA3teUIXvuMRgxhE6iI3ornkLnlRocgKvNolmkjDoEkr5bfsQ5ePgz9IMg35aUndX8RB0U6JdH728aCavrWb9TdAvDTO+X65nfzC0maakwr3INmPeKfcW1vE8bUIxJ6uwQtaeVLWdL911Ms31dV9exWkFzLuIaiEwqZFvAfIvDsdmjIl04yeEmE1yBO0BmyLy36E+ql9S01tVIFd9+cz+wLWa0Tn1NnHIf6xobguZsj+8QZpzq/wcj1/17IWXnmWHJ+n/YSvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bqORCVo1QtToIAMda9Mfgj7ZIuHJh6GLPTChW2g05rI=;
 b=Vf8uFh7jOSDFKN9H+834wbwYAckm6wfiLPEbKkiJfjfNEVVIadkCTYdvo22GEvvKn4TWrPMGnJPmBwMBmFhVSGhXcRye61Z7p8SX31SwJdnSjE99IRBU1YttX9Tdvd/zzSjsAi50WDpd8hIv8LB5URt7eDBGMQZzxFTxr4kmwNs=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by PHXPR12MB999234.namprd12.prod.outlook.com (2603:10b6:510:3ce::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.17; Tue, 28 Apr
 2026 06:10:29 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%4]) with mapi id 15.20.9870.016; Tue, 28 Apr 2026
 06:10:29 +0000
Message-ID: <3d8895b2-f238-4c5d-a159-39dabad0f153@amd.com>
Date: Tue, 28 Apr 2026 11:40:22 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/migrate: rename PAGE_ migration flags to FOLIO_
From: "Garg, Shivank" <shivankg@amd.com>
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
 <03f36534-60ce-46fb-b999-dce1a6edc647@amd.com>
Content-Language: en-US
In-Reply-To: <03f36534-60ce-46fb-b999-dce1a6edc647@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4PR01CA0078.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:26d::13) To BN9PR12MB5259.namprd12.prod.outlook.com
 (2603:10b6:408:100::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5259:EE_|PHXPR12MB999234:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ff13486-aa51-44bc-0443-08dea4ecd91b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	nkc+zAN///nj5pOkhaZ0PUNEL1NWjMhL0mymtj01x5DAQdzCQ/HIy/7yHmhHdAqt3GKF/9wn4tPE7zc8pHI8+PfjF8StrTRKyoR3xehQJojf4ma3Jg2VdJ0KgI8zoS11OZ6P+G+bb6VAk/Cpv2x2MtKR+OYG058T7iDTgiUteL3Lk6bs/OGs3nUqM0HHOiH2PhyGbmnLxM5k78srrSWeEEJEbVxbZEJFcMkDIAlIzTlLE3jCGPUh9xEx+fa8UyJfNsudR8iQyEn6VfR8GxkdUFSwUsLMHV2GrwdNEHR5je7Pwbw0vqnsQyQIijuuK0qSUDz+uWR7OgGofX2qh2jr3GJgofpWyiv5Clr5kG2t28P7siExRoQP5BZsLH/sifx1vQ95p+AC38UZZ6v1ae5LaCp4B8dejojurQ2zUgvrJdAcWdRPq6k1/2GCQwLhKgM6GoPHQ6ZxeeOY3b8Rnw9RwLbkuItMtc0MjbxXpDZp5FTE8jQD7UHl2KpyEEKciPZMyBTom25tYTtVd8wTvCKzWSo5vxDgHGMmr2cWCuCN3EeySEcxC9QLvUPhCvpB058N4IRGYpEgMam9MgNCJu25tIyQyIIAiRigMysGVh0Rcx9jSTxTKQTy5Cm7eAHCKgwj2LZ7GEhn5S4XOeSsBvoypFDbJ9M7DmQpTvI78o9h1rl7s/1ll0YUrUJHLIIEvn7tq+6ElPAwyabFoul6jVTDPTBzfQf1mo0OeuIjFNrCC40=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K3AySVhtUUVRSlNsSVl3bFdmK216eDZQRmVlWmJQNXMvbnN2Q1dPZEJhalpl?=
 =?utf-8?B?MkR3Sk41RVhCc0tINGMxRmJhR0lBUXVnRHBOMCs5YmZFc3BYamtxd04ybisw?=
 =?utf-8?B?MHpqSW1aL05XMEhIL2ZGTEw0dGFTY0JPWk9tQlBHUUMwUEdLd2w0emVEeHNO?=
 =?utf-8?B?UytWRlpEdzhhbHZyV2loZG9VbCt3K3BQUTgzZzArVDgwWisvMGVIZGVQOTc4?=
 =?utf-8?B?OHpnaTZmeEZzWndJNGkzS053RUJ3ZDNKUEcyaGpPTkoyelJURHl5ak1PQkZ3?=
 =?utf-8?B?QXA4RFRCRDFqUHlhNEFNNDBld0lqOVBYOW9BWUZ1UFpUZWNVbk1yM3dUQXhB?=
 =?utf-8?B?MjkxMXNEeGswUnhsU0YvSGkzMEFXV29PYWFOUXJuK0pWQWdSdlppU05wN0dD?=
 =?utf-8?B?UFMzVHBDYUdNQnBtcHZCVFNDQkE2VHpOMmdDMTNWZDZFRndralMza0k1eUVl?=
 =?utf-8?B?MWZQVzlIRTAyQlY4Yy9nUVBSM2phd3crbUtJd2JLNFR6ZTcraE5NeFhIei9N?=
 =?utf-8?B?a3EyZXVFNllVK2RNVCtrUm1HcFIzT0hMRldkaFVZUjZybFM1Wjh3MCtJYTMz?=
 =?utf-8?B?OVMwYTkyZWVTS0JDdXltamhaaC9KNFNDaWNObkt1YStabnVjUjJxL0xLRmZl?=
 =?utf-8?B?UFBoZ09RR0xUSVc2cldkZHNsaTJMRHVjRVVzUXVQeTBsRVFDdGFLSnljb083?=
 =?utf-8?B?bjhwL3RlR3JrTlVFU0RlUEs1ZUY4YitmTUhjalVkd3BWWm16UGd1Si9XVzdY?=
 =?utf-8?B?ZHlYK0xKZDcrckdZNUhhaTExaEFmN2JkL0h2WVpIWUYxU00zQWliM0tNVUJG?=
 =?utf-8?B?OXhldVVNQXI2TnlvaXFxRDhrNHRWbFB2RS8xMUM5WnVsSEkxNHl3bkxBU2NR?=
 =?utf-8?B?czZ4U2NvbGlLN1R2V0ZqUzVnbWRrOE1Yb1ppSlhZZ015NlRkdXhKSzI2STFG?=
 =?utf-8?B?Y2hCd004eTEwNUoxcDRmNlMrVmZ3QWRyMFk1NlBhWVd1S2xZS1l2UGVyWWww?=
 =?utf-8?B?WGhaUW9PUUd0Q3lkM3Z0THRaaXBPVW5Sd1ZIM09zcTRLWUgxUG9heURqaVVJ?=
 =?utf-8?B?enU2ZWx1YTJQa3ZBRWdkTWFDdlE3dld4M2dBQ0xoNzJOLzNwMTZNc0tWbnFp?=
 =?utf-8?B?VlAzWVczeStlQmJZTWRmdjE3Q2tRbVU3YUVnVzgwckNwdDVmc3hoN3V6MjJr?=
 =?utf-8?B?ZzVuTzhxNzl2LzVJbXJvci9BRkY4QTdVNU5yR210eHBkQkpEeVBMVzlwR0pG?=
 =?utf-8?B?TU92aWtrZnVFcUtiRmVkSXluWjNWclhDOEhSTlZ5NHArRXlwakJsaU9sbG5N?=
 =?utf-8?B?dTlrRkRjb1I5Uk9qSjh4cXFQSDBGcTAvUG5Eb2tiVEhiRHlxcUxRTVZkYWRj?=
 =?utf-8?B?TVZkMXlzK3dpS1czOTZuK05EZTkrMGdmZlhnOW1lODdiR0VyQkxPemVIUFdQ?=
 =?utf-8?B?NHMveVBxdmVlOHdSLzVBb2RFKzZsV3lpMGlUZXQ4WXVrVEpyaHZBcDgxOThT?=
 =?utf-8?B?dmZUVDJGUmxYYmlqWHVBbW9DbU1STGtRN0hya3pRdGdsdWFWcVRMY3VhWXdL?=
 =?utf-8?B?aFRkY3RpMXgybm95MmN3emdOaWlaeTJIU0JkcDZXd3BrYWwvNWt3MEF4OVBm?=
 =?utf-8?B?WE4xVW1ZNlBOZGRvU2xocG1oQXMvWHZneUN4U21tQ055aUZjOTY0bENXSnRk?=
 =?utf-8?B?Rlp3OHpyTW04WW1SNU5hY1RMQ0x2TmZFL21GbVdRRVdxSmx1bVcwWHBTaFo5?=
 =?utf-8?B?dGtFYVU0ZlhtZXB4alJ6WWNteE9zaWU2ZXBPdHdjOFpKaHVXa3RHNXdza3pz?=
 =?utf-8?B?RFJVZmdhTFhJMTJWcXV6TXpVVnVOVWlHc2pPc096QmRSRTJPVUpOOTFEdStV?=
 =?utf-8?B?R1djbkdHZCtJQTEyaGlpNnl6SlJ3U0hJQm4xWDVZaFljbld4WG56OTJSNStE?=
 =?utf-8?B?VVFueDZpRjhYQlo1eHZzSWxDYzliMC9JaVgxWFBYYlJjeUx2SmcxdHdBY3hK?=
 =?utf-8?B?Z3JLL09VUDFwZjZTTDZkUTJiQlN4M2Z4RkoycWwvbFozcmlVK3BuZ0JoaE5S?=
 =?utf-8?B?eTJ4cVpHMGwvbVRwbk5lVUt3amt2ZnNScjgwS3RybHBIQ0hjc0VCTG9VT2lr?=
 =?utf-8?B?QjhrWldEU2VHcTNxSGRxZHNOZUdNelp4OTljcUNBbE9BSEVGYnYxVGxTcGZm?=
 =?utf-8?B?OU1uZk1JZUd5dG5LY2VLT0F3eXQ1SGFLNTMrWG1TR25MQnZPNmlWSDNnUTNE?=
 =?utf-8?B?TVZJcnRpcmtvbStYL1lVeUhudEoxR1Z6YTQyM3lkTjJ0ZmJXMmR2b0hVNlBH?=
 =?utf-8?B?L3V1RlpkSkV1T3NwVFo1NTNIdldGTFg5MG5KaWkveTRZTk1pcGgwQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ff13486-aa51-44bc-0443-08dea4ecd91b
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 06:10:29.6170
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0vEwGBU3RW/IlyrghIzCgSQUJB4j84sRqyg28MHterWHhXm2pGHkd1jnobdupYi92qAfMk+eEKl0onoVhRTaww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PHXPR12MB999234
X-Rspam-User: 
X-Rspamd-Queue-Id: 841B1C0010
X-Rspamd-Server: rspam06
X-Stat-Signature: 6hu4dqtouhgkqfppate8k5i9r44sgjca
X-HE-Tag: 1777356633-556810
X-HE-Meta: U2FsdGVkX18vSeHIluPhic9kJBP6OTwawhsrIIc5MpNdkOwKZXh1ViXT8u0yqT4Yi0va2TR50VIyei+MOAi1KpN0Edg2MIkb03HoGSlIFccF4Fg8LqUz61EKcO2qT2aQbOYFUrAB4BRWpX2zihHpgDyzTTLW7sI1EyJOHdhV4qtxx/x7srezxgrTRcxhOSh3d/Er0fOAM4OL+vTMsp4dxuF5iLfFUtS4hCNSxqMPJ14D88i5AIwNaYle8i4olRVBp6GjacgM+laJmbDRl19G80yyrTflhZbEgGuvl2x9WIayYDuJaT3YiVof9RQNky/hc9N3uakzUPk5jZS2Dam204HMkyGDB4UCXftL12tnATsaT+BfUmR6vdKmlXVr8VSbdg8H+NDFdFBGc+G4LmUy9TpE6EsUBLZjfUt/aIQfsJ+0zlLij2C7GvqwB30/HyMm7cd3tImONEOWmnOPrVUfyzgCYBPeFE/xryOg/37/Nzz3wH6peEo8/bSNLM4Ayu4fjOseSUgPEDOE5WDneqeZ24TeINVbJmJhZX1+gTANKl4Nl8GcDXXPMlUe1HNvKp0zj+Nb3jWs9FazJU6xR29hA+zsFl792oMlQ9Bs7OBqHprH1UBUkk4YYVNLyKlxQ9+14Auc/XPRQufgXOZ97OG1vvkMgtEziUw+Pkh+dM5FL515bGVqIRzB4fWRJLClFr/4MDMJaplls7pGtskMEvPU8vMHJx+WZhRllunCJJx5oZKFXEtwufU32cgUqIbVo89GfulleIZMN64xCtYaM4azhTeqC/xPNZpF4mnfg3WJkWkuIAa3sUcRHfHfVKYet2nLJeD8mp7X32yjYDRqRQtDGF2/z7QsfaAAItTv2qXFr7L25ppo42E6XqJlLqR6zAEBvH5b1ClHhgi34cFbASJjwGtlpEbOT74p9iFWRD5kvoUaHdekqcbL0MSIHWJi0SeJ31NysL05mOMCXvmhDNW
 mbgEAj+I
 x8plDu7+4PQhMR3iuIsFeUFZzud2eXyxAXK1yalocMHFEMd8/vhG/SZNsFa1vu0Esca/Q/bulYpR89wnUsCDA8RgbU0UC1/CmoXKAJotxrbkVJheLNvI26fsh+IFMMcKAndTmzjh5I86VCU7P2SrWsHcwKB4Ya8dKUULi6TWuMocIi7tzbODIljvLtijLTmgtsxafflOZ/LdgZ07pUnTZgs46U7h30lh13cZhOnaiSOk9JTF3j5p5KxXFkOE0EG2/PWLx9qlBJW7lNiHYvqL5XAxQgYS6Hp/7Qq0e0ZRhqOq6kfMSAYrHrALUORbFWnTaSDPWp5kYAz+Fu9BFyETeKg8BINrFz2CoJYhaMinuDmPwP03zupqtLxQrRXmz+VjlgGQQTmiCJUeaG20RiD6ZmAK0/cO6GHkHCND5UusOqehUuqLOufyypcvQlNR1luSDM7c6rL0v6RYsOV6wt44gkguv2SQ61EgsqLzRc3lbpf3OHuhoD0gk+me3RTo7IIuj5HTirUUBf+D1VS3pQ2OLCNaqrrehNIMCyxI/Cm9pDNeROjM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/25/2026 11:08 AM, Garg, Shivank wrote:
> 
> 
> On 3/25/2026 12:54 AM, Andrew Morton wrote:
>> On Tue, 24 Mar 2026 19:07:09 +0000 Shivank Garg <shivankg@amd.com> wrote:
>>
>>> These flags only track folio-specific state during migration and are
>>> not used for movable_ops pages. Rename the enum values and the
>>> old_page_state variable to match.
>>
>> eek, sorry, I have a finger in the dike, trying to slow things right
>> down now.  I'll set this aside for consideration after 7.1-rc1.
> 
> Thanks for letting me know.
> Sounds good, no rush at all.

Hi Andrew,

Gentle ping on this :)

Thanks,
Shivank




